# Default admin user (password = Password.1, as created by `ddev composer bundle:setup`)
SET @username := 'admin';
SET @password := '$argon2i$v=19$m=65536,t=4,p=1$VFFhS3VWV3VJN0wwQjVRcQ$PPnfvUlVIO2qJvVIkcmQS7/du4zrf/amXXmDEhHDE2k';

INSERT INTO be_users (uid, username, password, admin)
VALUES (1, @username, @password, 1)
ON DUPLICATE KEY UPDATE username = @username,
                        password = @password,
                        admin    = 1,
                        disable  = 0,
                        deleted  = 0;
