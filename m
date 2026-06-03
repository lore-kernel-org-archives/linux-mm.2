Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB12CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C876B00A0; Tue,  2 Jun 2026 23:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DEE6B00A1; Tue,  2 Jun 2026 23:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF07C6B00A2; Tue,  2 Jun 2026 23:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA7176B00A0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AF4D1401E8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:25 +0000 (UTC)
X-FDA: 84837171090.19.87B5665
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id D968B20004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="doBk/8BK";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
	b=evyuqJ9eo9eMzGW3s21AJqeJ6OJDrh4fQ+cvoL9AQD4RNvQkIYPzOCvaz1MTO4vzepPblA
	db2YQwGbcu7HpoW/cZR5W4bejY4htvVHyLwgFS1N4W/EmXySfLL9rhO8lkKuU9m2Uplu1y
	QMh8l1hm64SpHonAoCI8hnr0xWFrMGA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="doBk/8BK";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457363;
	b=1vqjCpOa9eAbslOFebYzhINtLK7sWIvCTihiDCVdI4eveJKrPVWE9gV+4nXRPGFZUq8yF7
	hguzRFIDS+P5tdyS6NLHEYiKM/Sndkgg9XXnZuoEdzSq/7GBZxUtd9A0eGottgi9QtliDN
	kxv+k8iuvzAahW0o6GPGn1SkrJf8FLI=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ce9d444173so35627016d6.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457363; x=1781062163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
        b=doBk/8BKAu4qWjKEGTjkOgYZ8ytmlZPqCZmC1De6hbV7ATTxW5539xEmb6Cp1aPrh1
         hfNtw0nlxK3wPjqEFuROoKb3FPeRlqkagnpkHU13DLh7y1vV73eweR+9BgiVekgqZrxr
         K/pM/OHmdGsmHusImN8L1rP6fbGusjIYAL6TKSwzmKhxs+p2fq1l1kVKbfKGYXqefXM3
         XImC9D4W/uGJKWD28T7Wd6Fdc+QOEYtJDbnVOVqnVq0CDZ2iAGCEdX+Ohv1jqTTPgDTe
         KTxGPD6807I1u5Cbah+rAP6lpI/nuu9AMevk2MzO30VHAo2x6A61TXKWsp5BGNowNsNl
         wSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457363; x=1781062163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
        b=Ch3Rphfu1/rp0o9Fg++ihJbXQUXLHOBJhfYpyZ66KoLOLQZxl4Uri2AqjTVdmPbtGM
         p4z6VXbuZEDHNTziefKZpE9MMP5c64FX7o89kMccMlW56cZlT5m4buzwdFzTrSohlraf
         4wRCu+GPbSRN5HfTrcu3d1dXwQmX/mN512AMgnxblDZlI2UjPwQkBR8YZCSVXeJxpRlN
         QHdDK+NaA+ZPtdgvWfEQeX0i3CjJt2TJVtm6bkKOpjIqsbYZym+lxgX0fzylnFUSghda
         IOTbpv2NDWFgMY6sEYVTuP89AC7gl9UxpO3idVFES705jRHl0aB4qlARbKMHud2SzHF5
         tYfg==
X-Forwarded-Encrypted: i=1; AFNElJ/axciuSirDdTtenQfqLn9sroObRAjHDplIcGZEpOC0s7b53+OwzlOc0Hen+CUmWLpfDZWAR9rKkQ==@kvack.org
X-Gm-Message-State: AOJu0YxC3aJZXasd0m5Y/9R6YQ55qbr6k5BKaWypjOj16brRLG4vCeof
	xhGI+K50D7JuKPYPJaBdLTtylKVaYOqYPtRMLPjMZR50R5ExjjKaJ1qbSc4gSy3YaHU=
X-Gm-Gg: Acq92OFY5rdQ7tRJ5N4gVyqjHrZwkt1HamQpY2k4Jg9nYmbpVw37/NUNapcIax/QQFf
	aw1UJGMLVcrU1Q7nD++sIX9+2SL0ZfyzS5yYKEOzVZS2hU5NpMEtRmG7aKnYoI3AzJCKqjWSTm2
	B9VDx9hadUv8jumn8welJ2lwF2U/Cv4LWrvx9QYRqMBiFgln+31BERgoXoQ9/tfeVI7/ZZcyG+J
	VWt7aQNgxtCONjdF1s5Ag/zgf+pQbaLcZFi4WRBJ3y+xdAgsW5MUgCZxXgeKE/3USfB9FPZ+WIu
	okffEIXxdzRqQnHlbepAPCRvzhH/wDIcDl6PL9orCQuG5s0N18maUz+paiTBlmeYr9mbSeTqH6U
	Cf0xYAHblP1Eti4Xfidl31kld4plpZ4CRMDM6zXkcBxaF3GFme4iSwJg3ii3cZHWZBJ5iULRHLn
	CDOkoRMNPBvOfPNuG5re6H3s+7EWVZErkT18CHms+tVMMA7HB8Ps4U5Q5vVx4Igg==
X-Received: by 2002:a05:6214:4c86:b0:8cc:f354:f47f with SMTP id 6a1803df08f44-8cecdf0ee3emr21236886d6.29.1780457362975;
        Tue, 02 Jun 2026 20:29:22 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:22 -0700 (PDT)
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
Subject: [PATCH v6 11/13] selftests/liveupdate: Test session and file limit removal
Date: Wed,  3 Jun 2026 03:29:02 +0000
Message-ID: <20260603032905.344462-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D968B20004
X-Stat-Signature: 54emawd9iuhbjajefm75pe5xy6iukza6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780457363-52984
X-HE-Meta: U2FsdGVkX19if0JFVcIlZYY+UxQXNM6LoeUrVH2eYy3EJfBHo1s3uYT2iorOoq3u78vBRl9MkJDbzIzqm6Rcr36oRdX+II1OnCXbAcQhEco7NjFq14BdLdeDMXWLG7ujhu4yHkkv+ECqg/qcY31391V1mrhW9IZnSL+XhAvkYkBJs5KeHQjGGfLuJtmDBjDBzpw2KGaWjOkryxT+gonhsIFXA3RBoRWO4+iHuQa7uSC1BrnxwfY7L1zF9LfopjbA+o11Qgfrghw9po9TRIQ7alK0Vu1HT51lQCR3nUHWhgWDOvLI3f5WJt+Civ2cAafW1YFgnJIDauca/DfZO8FBkJrPQEDULdMfbpmcYlFXfHjLQEm0ujzYLQqHVwLvtjY/Dhu+aKB2C/Ppo/0sJE6Y/L5P9RzDqR2HngXtlP3H/zPh9qfDd9Za1rfFk4PT2nRy//dcWps4hrP6nOk//ewXtJYSn1lMqRQJOtjDb/Miom0rhONtmLSg60xOm0vsoCBEbxKimeMiGAX/vhwwHFs9T7Ld73taY3hnXKjmi+gQtDmj2nR+rr2CylDbKU0fEC1HINxST+5KW89X8Nri/+djPmzvhD8Pcls1bZqtHXupurCsCpIkiNwBNWP8naSghnO05eSRQ22t2mYQX3YZTFigo6Pl4itT68ZM9Kz8TxJ3w2WlSzdJ5TE+BP5kW1Y75Q5rY1lXYQH1URecBtNGLsc+wqlItCkTeD3ucDCS9rzo6X4E85zrifJC7qhd2arlbqiEY49aq58KH5naX9YP1cLzvEM9wRJK67ssL5mIAy+36nDUKXMAlAjZVawSAsVk+5wgPDuzs7QvQ2+GSvUwUPNDFPH5D+e9fld9fxhvFF9+fNPs4shIs5RBLagbxRfrysRKRVhX4RbHpPZXUrYuciep7Blgvqf3hQjc5l4bvGDKPkxy0LtVqZK/kU8Tv1o4Fwkgfx8LvEK9mZzHiuJ+d+P
 o790jOeY
 PMAEIc9hhisUCMiBTxGaS638W0+AQaIRbMvjE5oNhCDm4DG7WO5KJViVSQzDCWsKbNhjZVde8NMZDLxyLytfTqJsILldf44zjWK0WnTzOoJNSnkB2rvCnZWmiv4ULFky0mDlW9Xenlcjnd//0qg8O4fHbwvaBGBNSmIjQrCQeRTpB0oVXYymTkQJqpl+KKXR13yIBWT/zxqW68lwyD7WXR+tTLQ+q0QuLIDKET0leqlubbjn/GRxItiP3+IBnigqXV9oJmKo+rEHcTbjTdWIEFSXmIlPvlHpGWaIjolg343plMZkHfKV0fiFHjrVztlMyTRy3NiG/MaL3triO4+nWtaFuZu5HqpmuKkKx
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


