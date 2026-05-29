Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78CACD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11516B008C; Fri, 29 May 2026 03:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2EA6B0092; Fri, 29 May 2026 03:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7786B0095; Fri, 29 May 2026 03:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF2E96B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:16:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 446B01C29EB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:58 +0000 (UTC)
X-FDA: 84819600516.16.5D85287
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C3B414000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780039016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uDmd7JXMFyuaVqIC0b+ucWUtwtdAdxpCvkNWVmogQLs=;
	b=Cg2Q7cTNxvwfJ/Undfgb7tRmHb2cXDUgqiSvgx/mWxYRZtCbAEyiXwmgaoq4o5JB5ztgg2
	N5VDdXfbRev/BLjMew4VvJpPtfVSUaIMI2QB0UDTVgpFJ7mxWp0U5nxg8qlrn4bOC1d18P
	9nrbPYa9ilzdDkUPos5scPfTjzFBK40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780039016; a=rsa-sha256;
	cv=none;
	b=d0Q3v3x8yeAcxFK1qsyzQz0/+UEf6Zsynb/ubfVUEO62RwjREp9JzfSIZzabN/5aT53FUn
	WIVSh5BOA67xBJQBYsR9T0PsuHE/o9HxF7vAMtcXOQL7uhtH/Z0S8a+YarSVzY6ISpVaCg
	iOGFq9+l5psk5hc57BYYpYViWg7tRpY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 5a58c1325b2e11f1aa26b74ffac11d73-20260529
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
X-CID-O-INFO: VERSION:1.3.12,REQID:f5cea95e-45b7-40cd-a8e7-7ddb4f546a06,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:f5cea95e-45b7-40cd-a8e7-7ddb4f546a06,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:fccff6c7c321acf57ecd24f5f08fdcc4,BulkI
	D:260529151648DI1LVB2E,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5a58c1325b2e11f1aa26b74ffac11d73-20260529
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1536740536; Fri, 29 May 2026 15:16:46 +0800
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
Subject: [PATCH v4 2/4] selftests/mm: unify pkey sighandler selftest assertions and tracing
Date: Fri, 29 May 2026 15:16:31 +0800
Message-Id: <20260529071633.2807814-3-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260529071633.2807814-1-lihongfu@kylinos.cn>
References: <20260529071633.2807814-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: zkzhisibppeg6mfq8jbbk17o7wg7oyzq
X-Rspamd-Queue-Id: 7C3B414000A
X-Rspam-User: 
X-HE-Tag: 1780039015-150087
X-HE-Meta: U2FsdGVkX1+AnZEbGQOKwgVx/0QkC3r+1HWH4sNuvxtsNIe1n7Y3u4X3PEwfEF9V1HZOl0udX7qoxzmZkmpA9EMpqjunqgJyIGmhtnm9fRtyUTaE7hjeEraum/xIaUkj2xHk6/VmV9IYZj6yR3kD3SShAc51oD97du/aBvQMwxNT7TyutmVm8xQM448y1LULb6mF9t9HBSvqU1/ML6GyzenQzwQr+rqAX0L4Tcuvb6dPMhGjaQ+g8BiProBfONwkq3NIm0HNLs4FSdsvstF6qKHv0kA+YWMiIH/bZX9TVl/XmDMWOHhoz+gIUWK6/R6El4e48cMcA7+HkBAfWJZozSKUL3KFtihGQRHAZK6DDUEW1QevCqW188w4YzvbAQ0ZMFRVZAXu9iePmYZ62Qp5IKD+eDA2uJRnmuy6yJ6luL35iUlNp0eGXAs3eXiSm9gdr5ULte1W6rebHuR0PpW/g9aJuaNmlHQHNi7roHgfBU1OK6xU5GfpCO910IIsqu3c1tFgIb+3nk5yV5GxkGFCfxD+vAu4GCPqah47O8v7Rd9J92M2kgF57QCKB8r9QHOkXozNDZajdA7PheEhElU6Ml2flk4Qs6PPNYxQIUZuH+2GjExWoIuXT+dUkZOVzkiNR6iCAEPqdojl1GaGs0ucr/ZlBVf2Ib9AMM2XHjQcSWM8JwwKTVkUj+t2lAWDyKTi/DYzATQkZdB3jdERe6xEvXL2CVFUgkYGpCPnCy5gKDJfbQFsFYsDvPuR8blEO0W7M75I89c+a1wmJudPUy0NwBGHaeInWZtjJxlGB77s2y0zheokq++WHnOzGtWPcUGlAtzw6b0LcWROoMJ4keQfQbMvU00SegpMn8ehRAV7SL0jZ84GzG8QGkVMlpkFFfuwWuPPKOFZY6F3WgOB2ZRZC2VWzhxZpYJekC9jWc25TLJGz+ti7Edrk6FB3b1QFJM5u7smC+GqUoEjLw9EnzP
 kPLQ4sKG
 FYPf/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add per-test tracing to the pkey signal-handler selftest and use
pkey_assert() for error handling. Each test enables tracing at start
and disables it at end; on failure, pkey_assert() calls abort_hooks()
to turn tracing off so ftrace is not left enabled.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 .../selftests/mm/pkey_sighandler_tests.c      | 104 +++++++++---------
 1 file changed, 50 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 302fef54049c..80b5b3dad86f 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -19,7 +19,6 @@
 #include <stdint.h>
 #include <stdbool.h>
 #include <signal.h>
-#include <assert.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/types.h>
@@ -36,6 +35,10 @@ static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 static siginfo_t siginfo = {0};
 
+int iteration_nr = 1;
+int test_nr;
+int dprint_in_signal;
+
 /*
  * We need to use inline assembly instead of glibc's syscall because glibc's
  * syscall will attempt to access the PLT in order to call a library function
@@ -207,15 +210,14 @@ static void test_sigsegv_handler_with_pkey0_disabled(void)
 	struct sigaction sa;
 	pthread_attr_t attr;
 	pthread_t thr;
+	int ret;
 
 	sa.sa_flags = SA_SIGINFO;
 
 	sa.sa_sigaction = sigsegv_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -247,15 +249,14 @@ static void test_sigsegv_handler_cannot_access_stack(void)
 	struct sigaction sa;
 	pthread_attr_t attr;
 	pthread_t thr;
+	int ret;
 
 	sa.sa_flags = SA_SIGINFO;
 
 	sa.sa_sigaction = sigsegv_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -288,21 +289,20 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
+	int ret;
 
 	sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
 
 	sa.sa_sigaction = sigsegv_handler;
 
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	stack = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	assert(stack != MAP_FAILED);
+	pkey_assert(stack != MAP_FAILED);
 
 	/* Allow access to MPK 0 and MPK 1 */
 	pkey_reg = pkey_reg_restrictive_default();
@@ -323,18 +323,18 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	memset(&siginfo, 0, sizeof(siginfo));
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
-
-	if (ret < 0) {
-		errno = -ret;
+	child_pid = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+			      CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			      CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			      CLONE_DETACHED,
+			      stack + STACK_SIZE,
+			      &parent_pid,
+			      &child_pid);
+
+	if (child_pid < 0) {
+		errno = -child_pid;
 		perror("clone");
-	} else if (ret == 0) {
+	} else if (child_pid == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	}
@@ -358,6 +358,7 @@ static void test_pkru_preserved_after_sigusr1(void)
 {
 	struct sigaction sa;
 	u64 pkey_reg;
+	int ret;
 
 	/* Allow access to MPK 0 and an arbitrary set of keys */
 	pkey_reg = pkey_reg_restrictive_default();
@@ -369,10 +370,8 @@ static void test_pkru_preserved_after_sigusr1(void)
 
 	sa.sa_sigaction = sigusr1_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGUSR1, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGUSR1, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -444,6 +443,7 @@ static void test_pkru_sigreturn(void)
 	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
+	int ret;
 
 	sa.sa_handler = SIG_DFL;
 	sa.sa_flags = 0;
@@ -453,24 +453,20 @@ static void test_pkru_sigreturn(void)
 	 * For this testcase, we do not want to handle SIGSEGV. Reset handler
 	 * to default so that the application can crash if it receives SIGSEGV.
 	 */
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
 	sa.sa_sigaction = sigusr2_handler;
 	sigemptyset(&sa.sa_mask);
 
-	if (sigaction(SIGUSR2, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGUSR2, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	stack = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	assert(stack != MAP_FAILED);
+	pkey_assert(stack != MAP_FAILED);
 
 	/*
 	 * Allow access to MPK 0 and MPK 2. The child thread (to be created
@@ -494,23 +490,22 @@ static void test_pkru_sigreturn(void)
 	sigstack.ss_size = STACK_SIZE;
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
-
-	if (ret < 0) {
-		errno = -ret;
+	child_pid = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+			      CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			      CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			      CLONE_DETACHED,
+			      stack + STACK_SIZE,
+			      &parent_pid,
+			      &child_pid);
+
+	if (child_pid < 0) {
+		errno = -child_pid;
 		perror("clone");
-	}  else if (ret == 0) {
+	} else if (child_pid == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	}
 
-	child_pid =  ret;
 	/* Check that thread exited */
 	do {
 		sched_yield();
@@ -530,16 +525,17 @@ static void (*pkey_tests[])(void) = {
 
 int main(int argc, char *argv[])
 {
-	int i;
-
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(pkey_tests));
 
 	if (!is_pkeys_supported())
 		ksft_exit_skip("pkeys not supported\n");
 
-	for (i = 0; i < ARRAY_SIZE(pkey_tests); i++)
-		(*pkey_tests[i])();
+	for (test_nr = 0; test_nr < ARRAY_SIZE(pkey_tests); test_nr++) {
+		tracing_on();
+		(*pkey_tests[test_nr])();
+		tracing_off();
+	}
 
 	ksft_finished();
 	return 0;
-- 
2.50.1


