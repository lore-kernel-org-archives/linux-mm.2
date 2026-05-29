Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6099CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21F06B0088; Fri, 29 May 2026 03:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF97F6B008A; Fri, 29 May 2026 03:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E368A6B008C; Fri, 29 May 2026 03:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D820B6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:16:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86FF61C0FA2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:55 +0000 (UTC)
X-FDA: 84819600390.19.C61ECCA
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id D0B3E4000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780039013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dGjNBi3OKwtZoMSzezwHJQVs1boMMjpPJiceXARZMEU=;
	b=gqlC5weEf+nZ2/p7rzODGtoNhz8ojRS+6fg8WBvsmlqzZC+uULo46NYKAByXxRZEQtBBVX
	SfAgClKypX6HvKcmwc5Yh2g47InbL6G9mBBjZLGY6igCHg8mGqwII3hFk1EoOf2BW248tJ
	oq4WG22VQDLbEqlwwb9LtexpRm7d+IU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780039013; a=rsa-sha256;
	cv=none;
	b=sYQv8pi5xuqua1l59vA9DLBe8pHxGBTVDOI7CmvmVzPEMytMWOX6IrchM+pZ3b+YmXflLY
	E8EDbXQm/tr2z1XXxg+UU450GYXdNBDVHC9iU6StEtJ4e7lCeHwvC4o4Ccvhb/JVy1utri
	vjjilvOAkuYNBCdmLCJmYXb10YdllKc=
X-UUID: 57e720425b2e11f1aa26b74ffac11d73-20260529
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a19f7d76-04af-41da-86a9-7550af511965,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:a19f7d76-04af-41da-86a9-7550af511965,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:1b31b111623e58da5bfaa0e10929bad1,BulkI
	D:260529151645CVNH2SBZ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 57e720425b2e11f1aa26b74ffac11d73-20260529
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1554856261; Fri, 29 May 2026 15:16:42 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v4 1/4] selftests/mm: move pkey selftest helpers to pkey_util.c
Date: Fri, 29 May 2026 15:16:30 +0800
Message-Id: <20260529071633.2807814-2-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260529071633.2807814-1-lihongfu@kylinos.cn>
References: <20260529071633.2807814-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D0B3E4000E
X-Stat-Signature: mssoazb7wpxa5jtierjfjndzf3i1g8ze
X-HE-Tag: 1780039012-171138
X-HE-Meta: U2FsdGVkX18Vl0QHdBqYK7A4yJeIYm0WYg4elKoudUDMyPuiePcBL9GHLWCHMbL08u9cNRbT2OBSh7rlGc7Jv2Fi4RqnfcHBC8PfI9Dt/yI6xJ15VtTzz1WqhaLZSnej5QNEcTPMl1nAp9n/q20ewWNabakx6VfiERcJZgPUIK6Yar7HxiFhi2kHy6NHdiZFL1wsX9MgY0Cs1/1sfVa9iKyYYfOw6RjRt6xlTQ4Rr+6SdP4UVFwilwrPpiSqK6F2RIykTrvTumqcROs33QPfLnIVUdM8UialeKFJnS75zo40mOHwr8LWxvfhq3jkwnAPgoCWF3uINI7Ik0mNrxbBlyI5t4+femwd9zyJOs8rh+D2jwls6b9wvsFnVPYHUMmrH0Nj2q7Y5X0QM/+cP+BWPeslseFZdKbk+O5VUI09VGOIN7BWZmu8MvopKkNlhfBmcZOUh7KTyuzy8r/obhm7cJ/Npxb0He7BHpd0LTCmYUhHxhL7EANvSLZxhEdCdBYQqy2y7WKHjJkFJPpweIRl0EvDkpgd1vMMM9Rfdj0bDzC67qu3inINb9VRrMGydvgStPirhh6xB4lHcS57TDPghSZwZ2Fd6T1hJtM4ArHtuY9Shs2EqnBA5AZMS04RfF3SMBW1QihvcL2dUR08SDRc+T3yDL9+JlaG38WmQQtqgcohaAzsOiBQMK4xBccVbyiTWJg58VySqZbOz0bdu6a8QQ32BGu0HsrxQUHVcqB34e9htKMj6Vl3b6NDXeeYjVtzYETuzgvN2kNhh6aw/8KP90JXHUFEXMRe/G0kPO92SvDEnjpDEkePF4vrPW/bn+bzAk73eUNXBFp7A0G/848JdlN/+Y9bcbfUF7Lft3OhiUOV3p2porvLv1SwiYSDxdiVw0zvIfA1tt5WZvtybfL1Y3897vBwEAdO6T49SmyEylY8IZC2BTccZzxWr+arZb9ocvFzBGKkKlzEbVPNYml
 NzjfkWE4
 /icfYSfkZxuUNXNDh7VHgCCaIKWM6HecBzSTQeliidqZqmlvQzlSuvffHSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move pkey selftest debugging helpers into shared code so both pkey
selftests can use the same tracing and abort-hook logic.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pkey-helpers.h    |  5 +-
 tools/testing/selftests/mm/pkey_util.c       | 86 ++++++++++++++++++++
 tools/testing/selftests/mm/protection_keys.c | 83 -------------------
 3 files changed, 90 insertions(+), 84 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index 2c377f4e9df1..cfbb8fa2af3c 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -68,7 +68,10 @@ static inline void sigsafe_printf(const char *format, ...)
 #define dprintf3(args...) dprintf_level(3, args)
 #define dprintf4(args...) dprintf_level(4, args)
 
-extern void abort_hooks(void);
+void cat_into_file(char *str, char *file);
+void tracing_on(void);
+void tracing_off(void);
+void abort_hooks(void);
 #define pkey_assert(condition) do {		\
 	if (!(condition)) {			\
 		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
diff --git a/tools/testing/selftests/mm/pkey_util.c b/tools/testing/selftests/mm/pkey_util.c
index 255b332f7a08..81723db43223 100644
--- a/tools/testing/selftests/mm/pkey_util.c
+++ b/tools/testing/selftests/mm/pkey_util.c
@@ -2,9 +2,95 @@
 #define __SANE_USERSPACE_TYPES__
 #include <sys/syscall.h>
 #include <unistd.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
 
 #include "pkey-helpers.h"
 
+#if CONTROL_TRACING > 0
+static void cat_into_file(char *str, char *file)
+{
+	int fd = open(file, O_RDWR);
+	int ret;
+
+	dprintf2("%s(): writing '%s' to '%s'\n", __func__, str, file);
+	/*
+	 * these need to be raw because they are called under
+	 * pkey_assert()
+	 */
+	if (fd < 0) {
+		fprintf(stderr, "error opening '%s'\n", str);
+		perror("error: ");
+		exit(__LINE__);
+	}
+
+	ret = write(fd, str, strlen(str));
+	if (ret != strlen(str)) {
+		perror("write to file failed");
+		fprintf(stderr, "filename: '%s' str: '%s'\n", file, str);
+		exit(__LINE__);
+	}
+	close(fd);
+}
+
+static int warned_tracing;
+static int tracing_root_ok(void)
+{
+	if (geteuid() != 0) {
+		if (!warned_tracing)
+			fprintf(stderr, "WARNING: not run as root, "
+					"can not do tracing control\n");
+		warned_tracing = 1;
+		return 0;
+	}
+	return 1;
+}
+#endif
+
+static void tracing_on(void)
+{
+#if CONTROL_TRACING > 0
+#define TRACEDIR "/sys/kernel/tracing"
+	char pidstr[32];
+
+	if (!tracing_root_ok())
+		return;
+
+	sprintf(pidstr, "%d", getpid());
+	cat_into_file("0", TRACEDIR "/tracing_on");
+	cat_into_file("\n", TRACEDIR "/trace");
+	if (1) {
+		cat_into_file("function_graph", TRACEDIR "/current_tracer");
+		cat_into_file("1", TRACEDIR "/options/funcgraph-proc");
+	} else {
+		cat_into_file("nop", TRACEDIR "/current_tracer");
+	}
+	cat_into_file(pidstr, TRACEDIR "/set_ftrace_pid");
+	cat_into_file("1", TRACEDIR "/tracing_on");
+	dprintf1("enabled tracing\n");
+#endif
+}
+
+static void tracing_off(void)
+{
+#if CONTROL_TRACING > 0
+	if (!tracing_root_ok())
+		return;
+	cat_into_file("0", "/sys/kernel/tracing/tracing_on");
+#endif
+}
+
+void abort_hooks(void)
+{
+	fflush(stdout);
+	fprintf(stderr, "running %s()...\n", __func__);
+	tracing_off();
+#ifdef SLEEP_ON_ABORT
+	sleep(SLEEP_ON_ABORT);
+#endif
+}
+
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val)
 {
 	int ret = syscall(SYS_pkey_alloc, flags, init_val);
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 9a6d954ee371..e504544e2197 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -62,89 +62,6 @@ noinline int read_ptr(int *ptr)
 	return *ptr;
 }
 
-#if CONTROL_TRACING > 0
-static void cat_into_file(char *str, char *file)
-{
-	int fd = open(file, O_RDWR);
-	int ret;
-
-	dprintf2("%s(): writing '%s' to '%s'\n", __func__, str, file);
-	/*
-	 * these need to be raw because they are called under
-	 * pkey_assert()
-	 */
-	if (fd < 0) {
-		fprintf(stderr, "error opening '%s'\n", str);
-		perror("error: ");
-		exit(__LINE__);
-	}
-
-	ret = write(fd, str, strlen(str));
-	if (ret != strlen(str)) {
-		perror("write to file failed");
-		fprintf(stderr, "filename: '%s' str: '%s'\n", file, str);
-		exit(__LINE__);
-	}
-	close(fd);
-}
-
-static int warned_tracing;
-static int tracing_root_ok(void)
-{
-	if (geteuid() != 0) {
-		if (!warned_tracing)
-			fprintf(stderr, "WARNING: not run as root, "
-					"can not do tracing control\n");
-		warned_tracing = 1;
-		return 0;
-	}
-	return 1;
-}
-#endif
-
-static void tracing_on(void)
-{
-#if CONTROL_TRACING > 0
-#define TRACEDIR "/sys/kernel/tracing"
-	char pidstr[32];
-
-	if (!tracing_root_ok())
-		return;
-
-	sprintf(pidstr, "%d", getpid());
-	cat_into_file("0", TRACEDIR "/tracing_on");
-	cat_into_file("\n", TRACEDIR "/trace");
-	if (1) {
-		cat_into_file("function_graph", TRACEDIR "/current_tracer");
-		cat_into_file("1", TRACEDIR "/options/funcgraph-proc");
-	} else {
-		cat_into_file("nop", TRACEDIR "/current_tracer");
-	}
-	cat_into_file(pidstr, TRACEDIR "/set_ftrace_pid");
-	cat_into_file("1", TRACEDIR "/tracing_on");
-	dprintf1("enabled tracing\n");
-#endif
-}
-
-static void tracing_off(void)
-{
-#if CONTROL_TRACING > 0
-	if (!tracing_root_ok())
-		return;
-	cat_into_file("0", "/sys/kernel/tracing/tracing_on");
-#endif
-}
-
-void abort_hooks(void)
-{
-	fflush(stdout);
-	fprintf(stderr, "running %s()...\n", __func__);
-	tracing_off();
-#ifdef SLEEP_ON_ABORT
-	sleep(SLEEP_ON_ABORT);
-#endif
-}
-
 /*
  * This attempts to have roughly a page of instructions followed by a few
  * instructions that do a write, and another page of instructions.  That
-- 
2.50.1


