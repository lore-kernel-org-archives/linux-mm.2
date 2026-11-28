Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD97F606A323
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 07:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ZT8lgopD
Received: by kanga.kvack.org (Postfix)
	id E297E6B05B3; Sat, 28 Nov 2026 02:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01586B05B4; Sat, 28 Nov 2026 02:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AF36B05B5; Sat, 28 Nov 2026 02:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 897A76B05B3
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:27:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DED71A05C7
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:27:37 +0000 (UTC)
X-FDA: 85483697754.19.BBC30C5
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DCAE1C0004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:27:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZT8lgopD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795850855;
	b=TB4ZxPrmjqLFamx/tN83FDf+J5APPYlpKMzhd4wsgGk7y+h3ZzvK0R/vWudGJiEY7UdDeq
	JkwxNsxHyzyoT+x4Bs0xgE6y+IuJCoATlvBRc1k+iG+k0kxk7hHoeVuPtGDXi8tA6YPC/d
	fDAeOQbeehC8QU13ifwhucCJ6wWekcs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795850855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKGjH6wS2a4sHmXZLlgO25XKxI/4g/tKHlpp0EC0Hlg=;
	b=PiRrapoxd0nJjNORMBP20r/75bHccsSt94uo1naZR8VddZDLpFSDUgh6yLN3dVXt4RAc6/
	J7Fqq8ZOzqZOui/iF6hnvQMyPYYy+uc02c0+DXz990aBetqLJZUHxOz9MUnLSDB0NcC0w6
	oZIZJnpJDbN4qqz7k96gzceTavUvG88=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZT8lgopD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=longwei27@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iKGjH6wS2a4sHmXZLlgO25XKxI/4g/tKHlpp0EC0Hlg=;
	b=ZT8lgopD9VuauBsAONcI6THMkpuSRbLWx/lHGseaVInjt0vU+TYa9M67rPEzfr2AHVy02PU71
	WIqUznSiO4MdmCDXN87x/RXDnIML/yddpzAI65Y1u4k+J7xA62G699h8p4xSbTZ4XiW6VxHiZyE
	8+X57tS/edSZrkQV77DHGuI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jc2056Mdsz1T4Fx;
	Sat, 28 Nov 2026 15:26:29 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id B6DC040561;
	Sat, 28 Nov 2026 15:27:23 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 28 Nov 2026 15:27:22 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <shuah@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <hewenliang4@huawei.com>, Long Wei
	<longwei27@huawei.com>
Subject: [PATCH 2/2] selftests/liveupdate: add seal-after-preserve kexec test
Date: Sat, 28 Nov 2026 15:24:44 +0800
Message-ID: <20261128072444.1114964-3-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261128072444.1114964-1-longwei27@huawei.com>
References: <20261128072444.1114964-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5DCAE1C0004
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: zyq7oj4666m1xqoafoqtowxdmtjy197r
X-HE-Tag: 1795850855-835519
X-HE-Meta: U2FsdGVkX19BUIp2loc6tocXAHCXUftuPuFUm4ewWQVJbBKPUi81XtisMcMxUmWTe+VbWTjivw2KCKfXPY9CNjUbCw256EY1WvFlILD6lPsOpZ4ej8LbAhgY2okk9BMRjFypt7XgMh0EF6vuWep2uEz8PcwRiZISGsmwQLWm2Urjat3uvlCN5b2zb/aYkGw4ZQxMlB2aUKg6euPe+4BOFlJZt6LkfRWs6jF1UUGxC/xgki5CzLf12GWmMF8eeIc84KEJd9rqhGMpHgVsIlPtmXBPaMD0OPp9BfPJhqpZCx62zV1KgVbD6SK+ma0/OVHNzsVjdqCsWNQM8Vsq2jPLKALcPL/8la7eBrGzGhtKHzQ5/+D+vT4LrQusFEk0POKdnQBDaEOvkg+I2G9jc2coNvra7Rzb/cSGVIxo3lELCZn6M/x3NEo4TVz68yN2KwI6duOZ3hh+As+3wfRlj60xlfBqqijZ3FNew/05f/pMdz46IXxksUKYiJo4XmYI0gZ0BFPhuskPRa+F+c+reh6mSWEteWiB6VBOL0KF6r8DpDkir0dS8H2z2lp2ZOq64NjiDrEVJiGy4l9O27LTWu0SeW50G38xN/odZxqhRKTkXp+GXs7XIVv4MZNR+3vWAFPLTWWL3ix78HLxbX9b9EbWW//OuxoLpulbUOjk4eW9/TAHuqsCYkyEws7LgeIcFajHQkgKirfViJrESU+clOI0xC8zs8Bq0InKk6tQzADqJl/kUCWJ9R1PtOhSWJRPwM4CuQDiikqg+QOw5UEOX0O9KtYABU/WufwvQ9tT/igvR2HyulXC8ORGPc2+x2sU+tdK99eubHBV/lS4iYhhCZAvo5M+RTx6JzBVm7dDe5QIj2l7yZI5hPh3/NUsodCYeZ2sR3jlbjC/rr8cMyywR8Dx9Ba71Gaz6n+TUc+chq1r+9Q2EHVMpVA9Or8H+NJsyxQwqdljlIz8FzlQpiYbJg0
 rTXlMSdo
 Wruwyl5cKSspmdB/YZO9MlToL/Rpsyo+h1XWeNIjlQNz8GF7hHNwSZOH7254VcaQqGAnSrPeQ5l+CcZYLtyPKYDYYtcaiUJTZjfR/DQ2jwnhsxGjEUe4Ie9dxIVeQElVFh/U/lvYtzuwb/V3x0MWYsS/3j1OGN8UYAQOrnllwAMjNB71OeeXucNnI/cwkez3MDva4T/KFMnbrGI8e8P0yhL8MNt6Ewyc3/ZdddZcFtG7j/d88Ja248I+XXxv5EzReefZP4gkTvNYJVsJNzfHnK/udytzxOa/B2ryOJXUwslmRwmtIAdWfSo+DNJldl+RHvE5tQC0q5875KP+d04DHkKRXC5Ag5zNTo2+Ub3TOYYwu+hw/Oh6R1S+HP7epdhKqo4YU4S+Ros1EPrwfhNB2Ko8Qv+fCUty3x2wdF+1ZZ7vRfDneEuXbak4Klu1IRI6zOIyefkELp1iCapM9odCDIBwFNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add luo_seal_after_preserve, a kexec test that preserves an unsealed
memfd, adds F_SEAL_GROW *after* the preserve (which used to be silently
lost across the handover), and verifies after the kexec reboot that
both the data and the seal survived.

The test creates its own memfd instead of using the
create_and_preserve_memfd() helper because the helper creates the memfd
without MFD_ALLOW_SEALING, which makes it unsealable forever.  It is
registered in TEST_GEN_PROGS_EXTENDED and TEST_NAMES so it runs in the
vmtest CI.

Signed-off-by: Long Wei <longwei27@huawei.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../liveupdate/luo_seal_after_preserve.c      | 170 ++++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 3 files changed, 172 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_seal_after_preserve.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 634211c66652..03bb09bb9867 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -6,6 +6,7 @@ TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
 TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
 TEST_GEN_PROGS_EXTENDED += luo_stress_files
+TEST_GEN_PROGS_EXTENDED += luo_seal_after_preserve
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_seal_after_preserve.c b/tools/testing/selftests/liveupdate/luo_seal_after_preserve.c
new file mode 100644
index 000000000000..12e6731c9235
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_seal_after_preserve.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2026, Huawei.
+ * Long Wei <longwei27@huawei.com>
+ *
+ * A selftest to validate that a seal added to a memfd with F_ADD_SEALS
+ * after the memfd is preserved is transferred across a kexec reboot.
+ *
+ * Note: the create_and_preserve_memfd() helper cannot be used here because
+ * it creates the memfd without MFD_ALLOW_SEALING, which makes the memfd
+ * unsealable forever.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include <libliveupdate.h>
+
+#ifndef F_ADD_SEALS
+#define F_ADD_SEALS 1033
+#endif
+#ifndef F_GET_SEALS
+#define F_GET_SEALS 1034
+#endif
+#ifndef F_SEAL_GROW
+#define F_SEAL_GROW 0x0004
+#endif
+#ifndef MFD_ALLOW_SEALING
+#define MFD_ALLOW_SEALING 0x0002U
+#endif
+
+/*
+ * Prefer SYS_fcntl when the libc defines it (glibc, musl); fall back to
+ * __NR_fcntl which is the only name nolibc provides.
+ */
+#ifdef SYS_fcntl
+#define LUO_FCNTL_NR SYS_fcntl
+#else
+#define LUO_FCNTL_NR __NR_fcntl
+#endif
+
+#define STATE_SESSION_NAME "seal_after_preserve_state"
+#define STATE_MEMFD_TOKEN  0x1000
+
+#define TEST_SESSION_NAME  "seal_after_preserve_session"
+#define TEST_MEMFD_DATA    "seal-after-preserve"
+#define TEST_MEMFD_TOKEN   0x1001
+
+/* Unsealed, non-empty memfd open for sealing. */
+static int create_sealable_memfd(void)
+{
+	long page_size = getpagesize();
+	void *map = MAP_FAILED;
+	int mfd = -1, ret = -1;
+
+	mfd = memfd_create("seal_test", MFD_ALLOW_SEALING);
+	if (mfd < 0)
+		return -errno;
+
+	if (ftruncate(mfd, page_size)) {
+		ret = -errno;
+		close(mfd);
+		return ret;
+	}
+
+	map = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, mfd, 0);
+	if (map == MAP_FAILED) {
+		ret = -errno;
+		close(mfd);
+		return ret;
+	}
+	snprintf(map, page_size, "%s", TEST_MEMFD_DATA);
+	munmap(map, page_size);
+
+	return mfd;
+}
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int session_fd, mfd, seals;
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating test session '%s'...\n",
+		       TEST_SESSION_NAME);
+	session_fd = luo_create_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_create_session");
+
+	ksft_print_msg("[STAGE 1] Preserving unsealed test memfd...\n");
+	mfd = create_sealable_memfd();
+	if (mfd < 0)
+		fail_exit("create unsealed sealable memfd");
+
+	if (luo_session_preserve_fd(session_fd, mfd, TEST_MEMFD_TOKEN))
+		fail_exit("preserve unsealed memfd");
+
+	if (syscall(LUO_FCNTL_NR, mfd, F_ADD_SEALS, F_SEAL_GROW) < 0)
+		fail_exit("F_ADD_SEALS(F_SEAL_GROW) after preserve");
+
+	seals = syscall(LUO_FCNTL_NR, mfd, F_GET_SEALS, 0);
+	if (seals < 0)
+		fail_exit("F_GET_SEALS");
+	if (!(seals & F_SEAL_GROW))
+		fail_exit("F_SEAL_GROW missing (F_GET_SEALS=0x%x)", seals);
+
+	ksft_print_msg("[STAGE 1] F_SEAL_GROW added after preserve (seals=0x%x).\n", seals);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int session_fd, mfd, seals, stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2)
+		fail_exit("Expected stage 2, but state file contains %d", stage);
+
+	session_fd = luo_retrieve_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_retrieve_session");
+
+	ksft_print_msg("[STAGE 2] Restoring and verifying test memfd (token=%d)...\n",
+		       TEST_MEMFD_TOKEN);
+	mfd = restore_and_verify_memfd(session_fd, TEST_MEMFD_TOKEN,
+				       TEST_MEMFD_DATA);
+	if (mfd < 0)
+		fail_exit("restore_and_verify_memfd for test memfd");
+
+	seals = syscall(LUO_FCNTL_NR, mfd, F_GET_SEALS, 0);
+	if (seals < 0)
+		fail_exit("F_GET_SEALS");
+	if (!(seals & F_SEAL_GROW))
+		fail_exit("F_SEAL_GROW silently lost across kexec (seals=0x%x, expected 0x%x)",
+			  seals, F_SEAL_GROW);
+
+	ksft_print_msg("[STAGE 2] F_SEAL_GROW survived the kexec (seals=0x%x).\n", seals);
+
+	close(mfd);
+
+	if (luo_session_finish(session_fd) < 0)
+		fail_exit("luo_session_finish for test session");
+	close(session_fd);
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- SEAL-AFTER-PRESERVE KEXEC TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
diff --git a/tools/testing/selftests/liveupdate/run-vmtests.sh b/tools/testing/selftests/liveupdate/run-vmtests.sh
index c3d828cfd63b..fbc853d981db 100755
--- a/tools/testing/selftests/liveupdate/run-vmtests.sh
+++ b/tools/testing/selftests/liveupdate/run-vmtests.sh
@@ -20,6 +20,7 @@ TEST_NAMES=(
 	"luo_multi_session"
 	"luo_stress_files"
 	"luo_stress_sessions"
+	"luo_seal_after_preserve"
 )
 
 function usage() {
-- 
2.43.0


