Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3715CA0FE8
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9588E0032; Mon, 25 Aug 2025 10:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480CD8E0001; Mon, 25 Aug 2025 10:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F7E8E0032; Mon, 25 Aug 2025 10:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 235F68E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:57:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A793759001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:44 +0000 (UTC)
X-FDA: 83815584048.07.6FCEDA2
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id BDD0C40008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JdDeF16C;
	spf=pass (imf04.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPfCdUbCeDFsUsPpoXasJyGte3SUGn6gCviPu/g9Nmk=;
	b=mNKbpMicrgfdEy59cgiOdLr6Kox6xntyXqnlkbZlnoc7ePeI1GonMsRa82aD/yV1TFEXva
	jF+XWJn1KfNfYXdcnBdtHlO9cogOH2j+QyG/TAG+C0Ib+67z5Zkiabq10Ert6qERjEqoOD
	g5NBBBRseEm4MX/537Zpq9aA8uww49A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133862; a=rsa-sha256;
	cv=none;
	b=gBgHt2XuNd1veBwm4nDh5aJIOTwcAkyyhizYCf7I1Vz2QGWzL6wKe0PTYACne0HNoWIdus
	Kv+TJghfQdeCORTQGjRxeNm1HAqs72828UsMkAWswwzN84kLxxIsSJiXnALptJJ83pzlB5
	8JkS/NmrYZ8YreDwK+ofHIisJd5d/Ig=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JdDeF16C;
	spf=pass (imf04.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-771ed4a8124so546596b3a.2
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133861; x=1756738661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPfCdUbCeDFsUsPpoXasJyGte3SUGn6gCviPu/g9Nmk=;
        b=JdDeF16CgJvfhkT4y3vDOT5CSNiO0muTTKsNqhSTefqWQuZy+vafMrB23YXk7gQDbF
         K+W+H2ktgbz7mHLC67JoGFu2wkIlk29U647u857p8bVz1SiNCOvtxWR8om0otr/cWI3d
         p8z8RlHam+lhZyPTOJ5GBqUqb/+Xpx/tzkyhYRw36lgF6MYLgLYARaBu6XCFyNHfddTA
         Pja7Wjn/blw33mTE6am7BzBSWjV297tg8uoE0S7qJGXtg4dW8D6WMxLhjEG+viL9IHeI
         LVienpXBFMRyhI4D/qRiDldOf0r92Ix7Fi5nP4nTArUWzhxz2I8NtKvc02Q5IVlujZH6
         trlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133861; x=1756738661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPfCdUbCeDFsUsPpoXasJyGte3SUGn6gCviPu/g9Nmk=;
        b=USDNI/SfGtotwOLR9Y4/CR0jNAYL7ZefLJKtEvlGTmlgdwMK6NDtNOylWHsuhskxEE
         w1b08iQ2zfEF1z1UWQNQUAMs7b9/lp1TfMd0pXUGX9Zrp9wJRab+R7qkgAu7GQCmQR1S
         OsLurOQo95ScPWZmLoSD4/kB64pvAIWx6wAG7c0+zMSkcHq5dCNQnXB6VNiOk19vg902
         GgwohVcAz1HuWjYexqdhklpKbq29ulOKOUDRUvc4+7ioNLDGqPCE3OKe/1FUPiqG8hTe
         7VlPo3noDsWvjIJuwQevuxmuwZfLYVMhMz2wh17oDLW06V0zHO+Zgls+U0AdtPSziDLJ
         mivA==
X-Forwarded-Encrypted: i=1; AJvYcCWVbc0jDurpJcc/7lk53QAxsWBxfJVpXDZz21tY32eVkkkhMkvBUGsoXCdmoWSuaGTvHyRx9kXsHA==@kvack.org
X-Gm-Message-State: AOJu0Yy3P7/hEu9Z45LQqh9nWcsuN95yiSQ4kFr0aEgFugHBXaMFahFw
	W5SD/EQcwTKReDY/3guBO17TE7ifZBLhw04/GvH5F8DDzUdtDaljL6p/LPsmCcCmZ9g=
X-Gm-Gg: ASbGnctYOgHQjx9eVrQFedQbzgwfFK8qcoG/VbprU8hnZVloePbkX+kXYPt3tNC14L0
	ELe7ewK9xF1njla57CjUlNuN/eJN/48x2YvABXFN1I17Ej7P8w3EZ2HSzT5RzHA743LlS2GW4k4
	8KZN/VueWzYXv5MApwx2fsCOCfzRk5Gu7DdX+UG9v9zS2FVL6kU/vsflVAN08WPjOtA7fgFP+Q7
	Jg0gebH6IVu3qSZwEHtO0PNpJ28j4NYesW5sdIBtMft6mpIUBmfhsvkfoBy3JzvZa1By9ofpxog
	+0RrQPCoAv773o5iV63PKcdFCucJv8Z07CoHqhr+WUUA/DQ76qnvatpDAxZG7/ilxYnnfzez2S1
	y0QhaCBR6zaFtLIpt71vmwz9WWGInhYMortlTgCSpw7oj5T58Zhhf4AvY2nrjcNPaDyEStGk=
X-Google-Smtp-Source: AGHT+IGi8AlmioEDn8F5OEJC9Uwl85Px8BWcJiffXHL00QHD0rhIGgqp+SRRXzN7jCPLWKMu1CF5lg==
X-Received: by 2002:a05:6a20:3ca1:b0:240:1204:dd5 with SMTP id adf61e73a8af0-24340c2b7ccmr16679364637.8.1756133861321;
        Mon, 25 Aug 2025 07:57:41 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:40 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mshare: selftests: Add some helper function for mshare filesystem
Date: Mon, 25 Aug 2025 22:57:06 +0800
Message-Id: <20250825145719.29455-4-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDD0C40008
X-Stat-Signature: sj8mj4583cik5egn7qdmruh3idum6wze
X-HE-Tag: 1756133862-24013
X-HE-Meta: U2FsdGVkX1+4yBFZB2suyU/p7FWjEzZkjh+3ev8slG+7L26UWv19xR08W3LcXjPPdhsBv2hrI+pVZm2hCNfKl0HAS62GSaakhKdHs30zKUHUQTl6KloA1aO7iliRNeY/6UM7ZJ2FY8iHbkK8OTGH4SDOSAoj5axIdFQ26D0Wf6WSB4NnjfCdm9mzO8M/Ka6hkI6TjahJ/Ap93mKv0VjymZoyycFBZ1yRLU4UnAUpfry5B5G/FCEh+SiEWMqpI3D5EFpUFIsiVQB+Iu4uUasEns1IvvxeNXXOBnBvwK6ac6iF7PFlSMOv+Fy65rFn6sc8NPbt+mgrK8uQv1DUalV7l+5zEFrQVE3gM+xLTg7mZypZ0ex7Xwnd+PnGE60cBmQ7bdOEVLboDnRtmhZWDHa1kxAYAM9nsOKeTodcXQpSztGXp5TieA/jUk+vBR+189gAxPTjp5sBjhOrmIpZsxHqGX9gsnXXqBrRJhsEOktawHeZZZQjIyscZgkTK0jzrPCHieWZJwcPtizjfFkbC46eMfppQFFJcrbyZXo8dAQqD7UB7yKwN0YwtzY7figWRmognFsafTs+DAGD6dOakfEhqlzscTp3aW6xdyP6D+KJQC8B91d923sIQhYpj956Ouiw8tKhgGs0ciodyZgPT13ygrD0PFHstu5M/kFqFVKmRPbX6pbSryC98nuErDBY/l74EiVlxyQgiIftUAldryJFmH5WP+Kj8b00jym9eAESFzVs6JH0SiiN6WtgX6EYSIfZdHArzR9Gj1O7CGq4UiX5IgEMOlOAiM0PIUM27xhjBNKSZqC4Eyve+mZHAkaa3nu8F2Q1Z58CGXJ2micdhmZ5Wf6ilFZj+HGo1aIXPiTQ9kmgYqjNJR6GXaYlOzwr2renNvyLXsw/jZrfgyozuQD4RzqvfCTjkf0YeTbxQtklT65Jl0o1uvMhG8CdPX9BVqE8TEFdc7HBKNsQngJC0Kl
 NHbZG0G9
 b9w01CjOUQyO5n6Gxlpwra9zwcEiFHUz64ZwuOHToExk+naWj9G/u76I1ZYQ7OP8ujMsQVDXg01Q7yk4jFKP4MlmKkoD4XwwetatQKEdHqgUDShJcPAoObpeWiiAdWU/DImQHA8DnIcofkXx0r+U4Nq0VKydgsk6QC7OWrU9rpYqQZwP/ETQzkQpyYLBc+SnRug9LClEtLv4HqToNWwt/qCd4C6ahBSWWidIxer3sQ1EljdBnERwQGmu4zi0jYPwcIUeZKgjoG2m5COvyumIf2J6B1XRJ5ZaodYsVrr3QNTaLlOfHp7t7XBzgjHBL/OLzsYr9Z12NH9iC/QIjSgsGlh/J+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before create basic test cases, we need to have some helper functions
to help setup the tests.

These helper functions consist of:
  Mount and unmount the mshare filesystem
  Create a temporary file which be performed test on it later
  Map and unmap mshare region via the ioctl syscall

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/basic.c |   1 +
 tools/testing/selftests/mshare/util.c  | 123 +++++++++++++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/mshare/util.c

diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
index 482af948878d..35739b1133f7 100644
--- a/tools/testing/selftests/mshare/basic.c
+++ b/tools/testing/selftests/mshare/basic.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include "../kselftest_harness.h"
+#include "util.c"
 
 TEST(basic)
 {
diff --git a/tools/testing/selftests/mshare/util.c b/tools/testing/selftests/mshare/util.c
new file mode 100644
index 000000000000..75f6ff25aa2c
--- /dev/null
+++ b/tools/testing/selftests/mshare/util.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/msharefs.h>
+#include <stdio.h>
+#include <mntent.h>
+#include <sys/mount.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+/*
+ *  Helper functions for mounting msharefs
+ */
+
+#define MOUNT_POINT "/sys/fs/mshare"
+#define FS_TYPE     "msharefs"
+
+bool is_msharefs_mounted(void)
+{
+	FILE *fp;
+	struct mntent *ent;
+	bool found = false;
+
+	fp = setmntent("/proc/mounts", "r");
+	if (!fp) {
+		perror("setmntent");
+		exit(1);
+	}
+
+	while ((ent = getmntent(fp)) != NULL) {
+		if (strcmp(ent->mnt_dir, MOUNT_POINT) == 0 &&
+			strcmp(ent->mnt_type, FS_TYPE) == 0) {
+			found = true;
+			break;
+		}
+	}
+
+	endmntent(fp);
+	return found;
+}
+
+bool msharefs_premounted;
+
+__attribute__((constructor))
+void mount_sharefs(void)
+{
+	msharefs_premounted = is_msharefs_mounted();
+	if (msharefs_premounted)
+		return;
+
+	if (mount(FS_TYPE, MOUNT_POINT, FS_TYPE, 0, NULL) != 0) {
+		perror("mount");
+		exit(1);
+	}
+}
+
+__attribute__((destructor))
+void umount_sharefs(void)
+{
+	if (!msharefs_premounted && umount(MOUNT_POINT) != 0) {
+		perror("umount");
+		exit(1);
+	}
+}
+
+/*
+ *  Helper functions for mshare files
+ */
+
+#define MSHARE_INFO MOUNT_POINT "/mshare_info"
+#define MSHARE_TEST MOUNT_POINT "/mshare-test-XXXXXX"
+
+size_t mshare_get_info(void)
+{
+	char req[128];
+	size_t size;
+	int fd;
+
+	fd = open(MSHARE_INFO, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	read(fd, req, sizeof(req));
+	size = atoll(req);
+	close(fd);
+
+	return size;
+}
+
+int create_mshare_file(char *filename, size_t len)
+{
+	int fd;
+
+	strncpy(filename, MSHARE_TEST, len - 1);
+	fd = mkstemp(filename);
+
+	return fd;
+}
+
+
+int mshare_ioctl_mapping(int fd, size_t size, int flags)
+{
+	struct mshare_create mcreate;
+
+	mcreate.region_offset = 0;
+	mcreate.size = size;
+	mcreate.offset = 0;
+	mcreate.prot = PROT_READ | PROT_WRITE;
+	mcreate.flags = flags;
+	mcreate.fd = -1;
+
+	return ioctl(fd, MSHAREFS_CREATE_MAPPING, &mcreate);
+}
+
+int mshare_ioctl_munmap(int fd, size_t size)
+{
+	struct mshare_unmap munmap;
+
+	munmap.region_offset = 0;
+	munmap.size = size;
+
+	return ioctl(fd, MSHAREFS_UNMAP, &munmap);
+}
-- 
2.20.1


