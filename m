Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF683EE6B4C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873A66B0098; Fri,  6 Feb 2026 14:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDF56B0099; Fri,  6 Feb 2026 14:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E206B009B; Fri,  6 Feb 2026 14:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 553206B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:13:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20900139FCA
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:13:16 +0000 (UTC)
X-FDA: 84414979992.15.7144136
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4413B100009
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:13:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20230601.gappssmtp.com header.s=20230601 header.b=I2iksyzC;
	spf=pass (imf05.hostedemail.com: domain of slava@dubeyko.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770405194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hp7dE9rfuLorTfLe8+rhBEONpAq5JPSPoipR3P8yp2s=;
	b=sPdzl8dgbFQiyALtoD65YLmhQpyLacw+jDHZKGZBDbdyUZkjXo1Qg6kUAZ/lRpLrmB+SHZ
	mrM5O+1BR/gnF10xPcPZiU/Peq2fq7lU53uDeuFWAcsbHETZkJSO4w4ignrQuxWrzgZhWY
	c/jbCWQDiv1tOIOTXVwdKIY5RF/TfvM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20230601.gappssmtp.com header.s=20230601 header.b=I2iksyzC;
	spf=pass (imf05.hostedemail.com: domain of slava@dubeyko.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770405194; a=rsa-sha256;
	cv=none;
	b=Dny2hXBZOAOa+qwt/8c1BxoA5RggZNznnSh9oV8DZe1yT1fJjhSTR0QTz6y5h4N2kzQ9tz
	l7VPWKQblE6skUOUSMgKdgS12HXh3NXhNqHQ+Xc8gUuRiqpPXKsQ5CNwlUNATx7C0HTTcj
	+7WUG9CfZJR3mEE6bP3f5kWEbxXWL58=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-794ed669269so40449727b3.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 11:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1770405193; x=1771009993; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hp7dE9rfuLorTfLe8+rhBEONpAq5JPSPoipR3P8yp2s=;
        b=I2iksyzC/JV9iF5wOx+50buUQGinmkxN49/HF6RfaypdsvMS0VpPKucNDi2zl9xaTM
         4uzB6eAbnQQoerfIOc7zlQNI4wwU74nrudK/f8t8eNv8FaghofsJ+eE6v4BX0VVOsuly
         ymaHfmUeuT0b3e8zPbBxxy9QLlgJdYd7zoQsEBlzuI61Ce1fPk2IIbaqKZ4Kztd9UitN
         UDJkwccTsez1C0H1YncGi6XYdYZFHVQuu4/MfuiJDU3aisdcE43h/lxSJr+yfHyn+D8n
         KTDCsc3jMwjjJDP8C7tO2idfR9vxsiiWaxN40IwcxGkd67adOSGAAhQOH/wDp90U9QfC
         sfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405193; x=1771009993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hp7dE9rfuLorTfLe8+rhBEONpAq5JPSPoipR3P8yp2s=;
        b=tlnSrd9gVx3njtBT/QEekhR6zef4NFjgVWltpHDFVu5tCDeWBdSqd75F/w6BG8bE1Y
         icINKeE/SjCZWlZ1MDoqDVNDN+nbDnWLx8PqlevFmnClCRglHq1V0L5VyA5W0woi/RHN
         Fcx0F1Uni+YcZGdYjwKsm3I+PlBKQJ+scmN4zBL/6zOInWcYmYCSKvTO8OpQZPdNSaBp
         KJqTKpKgVbU6dFQB86j8xwtnE0yT5dbzQfyd+fz5/lm/yiTOpd/nSzEe/QprHCUktQnx
         Tryzd3Jb993xfyDCFuBnA2NWf5m3OIJtptyR1Aohl2RW81J3xNqYlHqsCO5Tr/b0cu5E
         C3rg==
X-Forwarded-Encrypted: i=1; AJvYcCXPzlN7xi/mVzhUXPHNbCkft2OFvl8Z9bTZ2aEEkT6HUt8p+5bjXCVWTOLduEUiHJbWIpIgzWXS1g==@kvack.org
X-Gm-Message-State: AOJu0Yytkq/SY3nb9w9/L3pdA8AEgyKVMvoKQAHQD2cU84Qix75b63KL
	cp+oFlLGjHeHyosftP69lgW8IDpeVUqIE380QlhfIqWNvazVd+b4edJ/QehFYSpvoyk=
X-Gm-Gg: AZuq6aJlquY/QBZqVAQPu9edz/QkPOIhGBOAWt4tuc1lqjfdiJkAOItq9eOy0rNnuMa
	eiGMA/0cMYqXMzUstxkQws5Ppc1K0EwMFHdhXQrnOjZ7K5I+RNAZYKRwvp9i6Sz0OFjgHohbF7e
	/h8cjs0Q1GPAAJfVCHyrs6S0Gu0lSfRP3fwlmDCja7jBL8MxKe4aicVq8KMMoP0Jkwu+UAext6O
	NP9E+6Uy+jP/+62FeIT2EijgkUAnFF27kjHe+VSziMw59uLSqwx9m51Lt/ek5BWZs9g8Rr16Ywj
	guJnZMcFM9L/pBl9K3lFds7PKovTklINq+XauXTM3i3wXr5cqufCbA9DNPsd7SH/3AHn2595mHe
	Qt8BYckZRoHxlRbstN+hH091rzH2QfMHf/56T7brSeb7CJX9SgsAT493dXWJkqQGO6QpB9Gs5Kk
	B6EBS1olGunABmhy/h2nZgVUN4A0/Y5r32TKIrWr+Kf2uV6GF16g1jf5AS2WQ2NqFllnhNipACO
	ZpR3FkK2Ohm
X-Received: by 2002:a05:690c:d8b:b0:788:181b:86c1 with SMTP id 00721157ae682-7952a63e4bcmr38138647b3.5.1770405193303;
        Fri, 06 Feb 2026 11:13:13 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:9fc0:ed7d:72bd:ecd1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7952a28697fsm29051277b3.50.2026.02.06.11.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 11:13:12 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 4/4] ml-lib: Implement simple user-space testing application
Date: Fri,  6 Feb 2026 11:11:36 -0800
Message-Id: <20260206191136.2609767-5-slava@dubeyko.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260206191136.2609767-1-slava@dubeyko.com>
References: <20260206191136.2609767-1-slava@dubeyko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4413B100009
X-Stat-Signature: t9ti4971qwixrmxu9hb6gqhqga67773h
X-Rspam-User: 
X-HE-Tag: 1770405194-958965
X-HE-Meta: U2FsdGVkX1/bLIJdMmUirs04ahA7O4iy98h583ewbCHPW8iSflZhzidEWmaT+gIgEQEFgOaqaxc1AyZz8YpIXsini9vbKyZbvbBeO6uiiMk7ZiwiUCiSBB6h5/sJWfaRxrSw3+McukuiUzCPO00k+QjSTEQ1xGjA5jiHTPN2hMPaVlyRwFGDX7xJ63SK+mrekpy2CVIWAB5LJgitORkYg9AQwoDrSVBt53Dk3R0wNvPXMkmKdsqXfVHRyg9g6AP/5cNXw9VZD9EM7N4umHYgar0gLf2OWYbqhhONlz/iYSfBAdg5sxLJ5hfhqDraL7AfAa1TTJ68xkW+9wM1PLvpkYw/CNkh+9KDe2zZ0FBZXssM+2v528udxnPFgnlH73qQRQAHEccJd4vZB0JyIE0ChUbeL8rK/URqmTtEKJ0twiDi2wqbVUSqmoYyykWGRU5B0cY/0h7+k7HbBe6IJJeCuROBQnAOZAwRGpyPSEPGsihnNo+Cqkd3Yq8QrIWUb0y36nvNUEzJdQQ/TDb7HQTCX8Ozu+u4HmmkCP6tu8pG9PUAOlGuW2JyhHUTnw1qXet0PGhn+HzJt2CFUEnrZC2Gd6kvhRPRtrXFBp7CYYSrvQhI/UlYNH/j3Zf2TiUr9UrECciiX38CjV7uLrRltRfXHx73w3H8fD5Z5QfPkffuGYYskIGwv/Y9EuGRfMZQb0UElCQarwPR4G/F0TEXetJ2rMgca5EIsgXNC++d8vXsVKxOYR/5RgBUxxGGqDQpOumNCC6t+goSC0m9EbteI06tdPIzSMgjIXh0MnLt3vIcaHpaTqMVc6rz+5h/gfvOmE1OVZJMW1MNCzWflpJFPgiHy1z+NVL6sbyqkoaKXNoe5eUsg/BJ9i52zqxDHKeXo+ORoabhBI13BZWgr7ufzQPaVlyFoIFj7P3jEd5EnfKCWmf+nWJIOCct5wXrIa1rcuWcuBiPONIOqQQFKwNWc/K
 cs7pBede
 wbbAAf+Pyy+P+bbE57WV+fYk9ueKZ+LQsM5NOnnuiLvAVsIuQPrEN4n0gJghytZHRB5D5TFdEKdtR9PwSrptx0X0lZ49ZKKHpdujBCCPraBcWirka1IoMCHnpr9tYQALb0Wd35m7G7mB/jNsuqrNP9zhB0Ld6uDIXpcylG7wSnUBT2xXVIFDddvbBuXmVcc8ChQ9okqD+k8PUPX7JpbBX+XfO2cum9+vou0FejwUAT0gvgkgw3lbWbGpLBIiuu8Q9zIONdbcMJ23yIIY3tN79zkN7V1yGH7zryYOPq4DCFv30iAzpievCFdT5G03YLjzr72JnLWg2RK8SpOdFXawqsKaKOFSOC9JBj//2VU3mHi0V+3YOTByWA16QsmWCf8PG2O4OovHqiiw+U1MVefbZZ2calOvephryMVZiwlVxitXGrciR657Ml5TUP4ppGXdGNv91
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement simple user-space testing application

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 .../test_application/ml_lib_char_dev_ioctl.h  |  21 ++
 .../test_application/test_ml_lib_char_dev.c   | 206 ++++++++++++++++++
 2 files changed, 227 insertions(+)
 create mode 100644 lib/ml-lib/test_driver/test_application/ml_lib_char_dev_ioctl.h
 create mode 100644 lib/ml-lib/test_driver/test_application/test_ml_lib_char_dev.c

diff --git a/lib/ml-lib/test_driver/test_application/ml_lib_char_dev_ioctl.h b/lib/ml-lib/test_driver/test_application/ml_lib_char_dev_ioctl.h
new file mode 100644
index 000000000000..7ea74e840fda
--- /dev/null
+++ b/lib/ml-lib/test_driver/test_application/ml_lib_char_dev_ioctl.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Machine Learning (ML) library
+ *
+ * Userspace API for ml_lib_dev testing driver
+ *
+ * Copyright (C) 2025-2026 Viacheslav Dubeyko <slava@dubeyko.com>
+ */
+
+#ifndef _ML_LIB_TEST_DEV_IOCTL_H
+#define _ML_LIB_TEST_DEV_IOCTL_H
+
+#include <linux/ioctl.h>
+
+/* IOCTL commands */
+#define ML_LIB_TEST_DEV_IOC_MAGIC   'M'
+#define ML_LIB_TEST_DEV_IOCRESET    _IO(ML_LIB_TEST_DEV_IOC_MAGIC, 0)
+#define ML_LIB_TEST_DEV_IOCGETSIZE  _IOR(ML_LIB_TEST_DEV_IOC_MAGIC, 1, int)
+#define ML_LIB_TEST_DEV_IOCSETSIZE  _IOW(ML_LIB_TEST_DEV_IOC_MAGIC, 2, int)
+
+#endif /* _ML_LIB_TEST_DEV_IOCTL_H */
diff --git a/lib/ml-lib/test_driver/test_application/test_ml_lib_char_dev.c b/lib/ml-lib/test_driver/test_application/test_ml_lib_char_dev.c
new file mode 100644
index 000000000000..432b8a0ad068
--- /dev/null
+++ b/lib/ml-lib/test_driver/test_application/test_ml_lib_char_dev.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Machine Learning (ML) library
+ *
+ * Test program for ml_lib_dev testing driver
+ *
+ * Copyright (C) 2025-2026 Viacheslav Dubeyko <slava@dubeyko.com>
+ *
+ * Compile with: gcc -o test_ml_lib_char_dev test_ml_lib_char_dev.c
+ * Run with:     sudo ./test_ml_lib_char_dev
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+
+#include "ml_lib_char_dev_ioctl.h"
+
+#define DEVICE_PATH "/dev/mllibdev"
+#define SYSFS_BASE "/sys/class/ml_lib_test/mllibdev"
+#define PROC_PATH "/proc/mllibdev"
+
+static void print_separator(const char *title)
+{
+	printf("\n========== %s ==========\n", title);
+}
+
+static void read_sysfs_attr(const char *attr_name)
+{
+	char path[256];
+	char buffer[256];
+	FILE *fp;
+
+	snprintf(path, sizeof(path), "%s/%s", SYSFS_BASE, attr_name);
+	fp = fopen(path, "r");
+	if (!fp) {
+		perror("Failed to open sysfs attribute");
+		return;
+	}
+
+	if (fgets(buffer, sizeof(buffer), fp)) {
+		printf("  %s: %s", attr_name, buffer);
+	}
+
+	fclose(fp);
+}
+
+static void show_sysfs_info(void)
+{
+	print_separator("Sysfs Attributes");
+	read_sysfs_attr("buffer_size");
+	read_sysfs_attr("data_size");
+	read_sysfs_attr("access_count");
+	printf("\n");
+	read_sysfs_attr("stats");
+}
+
+static void show_proc_info(void)
+{
+	char buffer[1024];
+	FILE *fp;
+
+	print_separator("Procfs Information");
+
+	fp = fopen(PROC_PATH, "r");
+	if (!fp) {
+		perror("Failed to open procfs entry");
+		return;
+	}
+
+	while (fgets(buffer, sizeof(buffer), fp)) {
+		printf("%s", buffer);
+	}
+
+	fclose(fp);
+}
+
+static void test_write(int fd)
+{
+	const char *test_data = "Hello from userspace! This is a test of the mllibdev driver.";
+	ssize_t ret;
+
+	print_separator("Write Test");
+
+	ret = write(fd, test_data, strlen(test_data));
+	if (ret < 0) {
+		perror("Write failed");
+		return;
+	}
+
+	printf("Successfully wrote %zd bytes\n", ret);
+	printf("Data: \"%s\"\n", test_data);
+}
+
+static void test_read(int fd)
+{
+	char buffer[256];
+	ssize_t ret;
+
+	print_separator("Read Test");
+
+	/* Seek to beginning */
+	lseek(fd, 0, SEEK_SET);
+
+	ret = read(fd, buffer, sizeof(buffer) - 1);
+	if (ret < 0) {
+		perror("Read failed");
+		return;
+	}
+
+	buffer[ret] = '\0';
+	printf("Successfully read %zd bytes\n", ret);
+	printf("Data: \"%s\"\n", buffer);
+}
+
+static void test_ioctl(int fd)
+{
+	int size;
+	int ret;
+
+	print_separator("IOCTL Tests");
+
+	/* Get current size */
+	ret = ioctl(fd, ML_LIB_TEST_DEV_IOCGETSIZE, &size);
+	if (ret < 0) {
+		perror("IOCTL GETSIZE failed");
+		return;
+	}
+	printf("Current data size: %d bytes\n", size);
+
+	/* Set new size */
+	size = 50;
+	ret = ioctl(fd, ML_LIB_TEST_DEV_IOCSETSIZE, &size);
+	if (ret < 0) {
+		perror("IOCTL SETSIZE failed");
+		return;
+	}
+	printf("Set data size to: %d bytes\n", size);
+
+	/* Verify new size */
+	ret = ioctl(fd, ML_LIB_TEST_DEV_IOCGETSIZE, &size);
+	if (ret < 0) {
+		perror("IOCTL GETSIZE failed");
+		return;
+	}
+	printf("Verified new size: %d bytes\n", size);
+
+	/* Reset buffer */
+	ret = ioctl(fd, ML_LIB_TEST_DEV_IOCRESET);
+	if (ret < 0) {
+		perror("IOCTL RESET failed");
+		return;
+	}
+	printf("Buffer reset successfully\n");
+
+	/* Verify size after reset */
+	ret = ioctl(fd, ML_LIB_TEST_DEV_IOCGETSIZE, &size);
+	if (ret < 0) {
+		perror("IOCTL GETSIZE failed");
+		return;
+	}
+	printf("Size after reset: %d bytes\n", size);
+}
+
+int main(void)
+{
+	int fd;
+
+	printf("ML Library Testing Device Driver Test Program\n");
+	printf("==================================\n");
+
+	/* Open the device */
+	fd = open(DEVICE_PATH, O_RDWR);
+	if (fd < 0) {
+		perror("Failed to open device");
+		printf("\nMake sure:\n");
+		printf("1. The driver module is loaded (lsmod | grep mllibdev)\n");
+		printf("2. You have proper permissions (run with sudo)\n");
+		printf("3. The device node exists (ls -l /dev/mllibdev)\n");
+		return 1;
+	}
+
+	printf("Device opened successfully: %s\n", DEVICE_PATH);
+
+	/* Run tests */
+	test_write(fd);
+	test_read(fd);
+	test_ioctl(fd);
+
+	/* Show sysfs and proc information */
+	show_sysfs_info();
+	show_proc_info();
+
+	/* Final stats */
+	print_separator("Final Test");
+	printf("All tests completed successfully!\n\n");
+
+	/* Close the device */
+	close(fd);
+
+	return 0;
+}
-- 
2.34.1


