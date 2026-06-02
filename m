Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E053CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428E86B04CB; Mon,  1 Jun 2026 23:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD056B04CC; Mon,  1 Jun 2026 23:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7876B04CD; Mon,  1 Jun 2026 23:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF19F6B04CB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A74738FAE2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:37 +0000 (UTC)
X-FDA: 84833512554.29.85288A9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id DDF6DC0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kUo9HOrK;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370255;
	b=um4SeOkGsI44FkbgZ/7Rv7qiOpoG9A4BRkGAEjMziOOcj8Py1Ljh9cXYlzBGfx3St/tBsA
	zHzVa6j9BR41jpDfQyQ80EF0Uiz9CK/WjRaXAw4sYs7bYqoUjs7xZ8xDHfTuC3ZkB24zCF
	Wdcj/yx/nLIEFrnszz1LyhK8pP3YWNc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kUo9HOrK;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
	b=BZRYRIcu8C7eFJUP5A4Cv9EatF7DeGAoDCeiC8ul2SWmRrSElVPqmxqhsOlffv1GDeJD7I
	w1IrJsUgy1OrXaru7Zf1/fl72v1LtxHVqEFYNCw0SF9r0g56olWaN86AHc00fmmLegDo9F
	9uzndANr3ucKdip4BNiJXnev5Iy1q3Y=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-516de78c4dcso100868501cf.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370255; x=1780975055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
        b=kUo9HOrKv9t4/IUOI4B3+E34Hys5vdgqyHZFKiprDNdxXJSaXDJHlwZPdBJWlWnXC1
         WU4VMtGMA1c4uYDkXEDYj9VkGSUXB7UcffzcWVZa8SU8EkQfjWN0sW1hVKWyhAAk4emr
         rpdIp9XLop0s1rBI/q1xseC9AcJkkzri5qjnkddoJql553tne3HeqqFqLQ1fwnyPkZL6
         sSFSzPLFiyCi6Yc0LU3aBhgC3ULMRLDburw7e1jioOLZAIu1WrK7snhB4uQypt6l3VKx
         otYZKfUzQjMgFo6SXr/M0O+jXf/0tQxuuQBObVWFGRIiN6W9ZpQMhVbtIQkLXKJkOc8Y
         caGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370255; x=1780975055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
        b=cX86qo6XUhZVSKg5M+l+qESwMIFD88A7YbNUBz/E+Bwqvm9cJIXDlBbrfp9QCdWzAp
         nkw5AKEMbA3pV2Ya9E1T1koHIquMcrwcyA2RAwH817RDL16EnS4X2xBc3Y6zZRewktD1
         L40p5b74JOTSYoYLMDquuHVHbeOfW6rED8BiLw0TKmV08lfjGZFLMxJeOkHfg2cMVyLv
         AiVp6Ofqc/R70OfLlGiqz7RkYfOHxZRFeycBKwpRaYHY99APCPkQvaqLrhJzr8+Oxde+
         gxcudWnz+ApoQQBs/msIyFF6AD6qFWljSEBxj5ls+S6e7i1oK1odePsIpF2+gINiAkER
         ct0A==
X-Forwarded-Encrypted: i=1; AFNElJ8PLTNXrHkCeWTptJhiPBsUjMrpDlCcqWJxW7BVi/ARTqBJmdHzJ4MWekt1Oz3p4zcvSedbTj0hfw==@kvack.org
X-Gm-Message-State: AOJu0YwVVOx7/s1AW8MYKt9hBkQ7UedamQXK9e245hhG7VOafsIs3KoD
	o1lymwUkA7YbMjom5ZYhIhp/YO4BN68ftt+tVaWV63Uche3fWUIoptnDTK5tQeXqe7Q=
X-Gm-Gg: Acq92OG1GhxNsHAjjhXsKKVZ7WWLFvSpiCSYg8KErvzN5tFy9k9YZjXlqpV/pi8WQWY
	/fwk4yDiry7YQGYI9HXMqwP20s+yEVkwXr0warG81SKzUDii1xEJJNdskqiWG74+coTwwQGwRje
	w0GCiwU6i69v9rwf0K2TVGseDhB5SgZN40PjU3YiraT7fvrMXaE2h+WOIODIFykY52yeP9oxQDe
	DoB99AaSJ8blcq4Dk0H7rHIzgayMBMN9/hhaqaSx/5UIiVp+X4BLMtyyZ4Y6fHaYJwajCTgOuFo
	8hdHQDQDYEIjGvthPVLSAn81m809158WZdgZp4MHhq/MaSVZs56AleEa/N0bEbnK/YFKCE+sNN4
	gPmlllFQjA7pWccFkFiUblICyahXMnevepl8HucERXDQGfXM/NowPrEwdXJxuiC+HVTZvC1SRGc
	4hB/6nZWFZ9QqYJkiQAN2KKA8T/Hm8r2XMjf+VvEQmk1fvKUbYglP9Ljf4Ps/5LQ==
X-Received: by 2002:a05:622a:4d44:b0:516:d971:1cb1 with SMTP id d75a77b69052e-5173a7b5766mr182980701cf.39.1780370255021;
        Mon, 01 Jun 2026 20:17:35 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:34 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v5 11/13] selftests/liveupdate: Test session and file limit removal
Date: Tue,  2 Jun 2026 03:17:15 +0000
Message-ID: <20260602031717.197696-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DDF6DC0002
X-Stat-Signature: zwnx94t1t5tmx19bjejaz96kaincmkjy
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780370255-671149
X-HE-Meta: U2FsdGVkX1814fBTAO6K5L22R3R35DMdCAmMXknMiARjdRcRqF+vOiXSsgl96Il5eA+0ip0rn4oGxi4hiJ/rpFhnQ/8koY6qgxQdpdzREJLPdZWlz2AmOU2/eGlcSf02fUPSsHQEzMRmEiponFFNXMywbrsUCT+vhADEpw7dAX8vUuRPUIobSVuAfHYzcM0zKWLWdPLgmShEGTftj4cBzgtLGPKvGx4ORBR2a+cWEO2MeC5yHHIMB2hI4LixUmYX+O/bco83DoaMlMTGYc2VHH9D2SG4K2kaJyb6sy4jMX8s5Br9zpE3NNggrTNWQcJw7Yy9VbyJYxDGqXt8W7Xv6AOuXvgYiCEikswR1751arTNXSbCQTP2nRFlYBXniPFZkOtRI6GZHb1E0j00Hk3WKAIymC5TMQxUBH4N186fVZFWSAUT2iLIXAmm1U7KrC0IiYAGcIjjpJX8U5BxfYnTNNhWyZEo2lQbCDLrH4KrtAovtyFWJKzdacqG07AuP03SfDmJC9w8XlUiuuJHYkk9OL3MDF3SQ2FnJ+LJNUnW8hnDiWLrS372Wtz8A8f+zLROysuONuWwYFyGOftYc4KDA0jRzC1vZCR9SD2eGXuqaRZIcFKAqseHZOtEz50BRjP0SG4d0QGvfLFbeeHhziSzPR1cMUM2SEarXFH8VaLURKrhDRLP3VwXt/pVGbHx6BU0cm8HoyQ4qF+945+iIkMPF1nms8lNZSqGtOfsRkvX6WnUnP6OtQNNqIoGEg91qKQ14Il63uQZNprOzp2zTh/8q9or5QBF/yCDwRfOPkjEuiBK/9UhynhnFSEcgNk4DcGBsr8scIBmzYGEyAdhg9ay7pz4NZxQjlogml292Ql3DYvPFErWGhbapOd1cIKXv0CIheDE/L2qNQ0H/Tcnq8mMFFp6TFLE4ji7VKnD6SdIFCIEWC2Uq7EQ1kfdwoiSa5ov5ZehQnklJo06+k7YJuy
 PNEQzKSt
 bEk5mJ3qi3Z2GSzuJdtU6SKvesgLx2BFkdh+to3YFlwjIjjaaC/eaFN90knEjTFEZTCc8j2/YH8w/gEHzS8Mfz5WN4nyqg+QO+z1NxKbsEMb6hT3zdJYEdNw8qxcrpZWOIAfHWIflABl/auBTSS2yzFDnjiPQdKXWaajqLPdoZTBmxwfh42VPFNUxxXgMsoW15rO87S4AAiRe0ddwTFEREp+sb4hfRLKpppiDMLVTeO+Rf9sZl4i3A7YmYu21/esLvlgmyb3lji4bmev6Y9DM1cqi9lsrhARRzs80KMHKKUIYquhWJLIUxq80m2hHJGV5t2N++BQXdq6Jjbqt47rF8ZwXTTIwAPEHU++pdDytkcXqMr7CdIxas4WOiRxl9cDCFY+cvhN9V97+OQkWHK5yD5LM0z6ndoXO22Na2AuVknpKhxjskU3XTmsWvxxLurWihKF9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the removal of static limits on the number of sessions and files per
session, the orchestrator now uses dynamic allocation.

Add new test cases to verify that the system can handle a large number of
sessions and files. These tests ensure that the dynamic block allocation
and reuse logic for session metadata and outgoing files work correctly
beyond the previous static limits.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 75 +++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 24 ++++++
 .../selftests/liveupdate/luo_test_utils.h     |  2 +
 3 files changed, 101 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c7d94b9181e1..502fb3567e38 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -26,6 +26,7 @@
 
 #include <linux/liveupdate.h>
 
+#include "luo_test_utils.h"
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
 
@@ -499,4 +500,78 @@ TEST_F(liveupdate_device, get_session_name_max_length)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Manage Many Sessions
+ *
+ * Verifies that a large number of sessions can be created and then
+ * destroyed during normal system operation. This specifically tests the
+ * dynamic block allocation and reuse logic for session metadata management
+ * without preserving any files.
+ */
+TEST_F(liveupdate_device, preserve_many_sessions)
+{
+#define MANY_SESSIONS 2000
+	int session_fds[MANY_SESSIONS];
+	int ret, i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	ret = luo_ensure_nofile_limit(MANY_SESSIONS);
+	if (ret == -EPERM)
+		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
+	ASSERT_EQ(ret, 0);
+
+	for (i = 0; i < MANY_SESSIONS; i++) {
+		char name[64];
+
+		snprintf(name, sizeof(name), "many-session-%d", i);
+		session_fds[i] = create_session(self->fd1, name);
+		ASSERT_GE(session_fds[i], 0);
+	}
+
+	for (i = 0; i < MANY_SESSIONS; i++)
+		ASSERT_EQ(close(session_fds[i]), 0);
+}
+
+/*
+ * Test Case: Preserve Many Files
+ *
+ * Verifies that a large number of files can be preserved in a single session
+ * and then destroyed during normal system operation. This tests the dynamic
+ * block allocation and management for outgoing files.
+ */
+TEST_F(liveupdate_device, preserve_many_files)
+{
+#define MANY_FILES 500
+	int mem_fds[MANY_FILES];
+	int session_fd, ret, i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "many-files-test");
+	ASSERT_GE(session_fd, 0);
+
+	ret = luo_ensure_nofile_limit(MANY_FILES + 10);
+	if (ret == -EPERM)
+		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
+	ASSERT_EQ(ret, 0);
+
+	for (i = 0; i < MANY_FILES; i++) {
+		mem_fds[i] = memfd_create("test-memfd", 0);
+		ASSERT_GE(mem_fds[i], 0);
+		ASSERT_EQ(preserve_fd(session_fd, mem_fds[i], i), 0);
+	}
+
+	for (i = 0; i < MANY_FILES; i++)
+		ASSERT_EQ(close(mem_fds[i]), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..333a3530051b 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -17,6 +17,7 @@
 #include <sys/syscall.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/resource.h>
 #include <sys/stat.h>
 #include <errno.h>
 #include <stdarg.h>
@@ -28,6 +29,29 @@ int luo_open_device(void)
 	return open(LUO_DEVICE, O_RDWR);
 }
 
+int luo_ensure_nofile_limit(long min_limit)
+{
+	struct rlimit hl;
+
+	/* Allow to extra files to be used by test itself */
+	min_limit += 32;
+
+	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
+		return -errno;
+
+	if (hl.rlim_cur >= min_limit)
+		return 0;
+
+	hl.rlim_cur = min_limit;
+	if (hl.rlim_cur > hl.rlim_max)
+		hl.rlim_max = hl.rlim_cur;
+
+	if (setrlimit(RLIMIT_NOFILE, &hl) < 0)
+		return -errno;
+
+	return 0;
+}
+
 int luo_create_session(int luo_fd, const char *name)
 {
 	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
index 90099bf49577..6a0d85386613 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -26,6 +26,8 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 
+int luo_ensure_nofile_limit(long min_limit);
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
-- 
2.53.0


