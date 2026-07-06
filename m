Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD47C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106C86B00CE; Mon,  6 Jul 2026 04:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B79B6B00D2; Mon,  6 Jul 2026 04:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A266B00D4; Mon,  6 Jul 2026 04:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B405A6B00CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:17:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BFB31C7BA9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:15 +0000 (UTC)
X-FDA: 84957646830.12.F3ED73D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id 52E1E120007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hY/gjZ45PoJyRYfHFauwzcmJp2WL4pYHG5uM4QJaKZA=;
	b=qVkH3hJVE7fmLlQ38yOeNThwkr9K3N+KCZG/aoEQeEHYEyacOu8VkZ4+j+u6wlZZ50UcLb
	YoUUTg+b++0PRPvKNR/QIQqZzeOgf+KTvn5VtNxstNeVO6u/S8NDZQirxcpt36pZ/SMJMA
	mahHwzK9mifuRNQxOFBt+oPN3MMvy4I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325833;
	b=sPuEyd4Yq7ve7ifXbdDjSawyefcq93ppHWnmY0/ZYd8zk75K2WVcbaEYG26xpy2oOU2vgF
	2tV9hrFmIJBRhoZ1g80GorcPTLlilZ6Y5qJufNb8boFu7aY7epyDLWHjMf/vuolz6nj6QW
	iWiHVVV5S0pBo2zVbeSkdqfNz4Ho2TU=
X-UUID: 11d4036a791311f1aa26b74ffac11d73-20260706
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
X-CID-O-INFO: VERSION:1.3.12,REQID:bd4e6470-38af-4f23-8089-94d50ee56fea,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:bd4e6470-38af-4f23-8089-94d50ee56fea,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:dbd5a0260f46cb4e765880b08095b91e,BulkI
	D:2607061617050D5RCIVN,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 11d4036a791311f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1696451613; Mon, 06 Jul 2026 16:17:03 +0800
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
Cc: jhubbard@nvidia.com,
	joey.gouly@arm.com,
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	zwisler@google.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v10 2/6] selftests/mm: unify pkey sighandler selftest assertions and tracing
Date: Mon,  6 Jul 2026 16:15:56 +0800
Message-Id: <20260706081600.3570203-3-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260706081600.3570203-1-lihongfu@kylinos.cn>
References: <20260706081600.3570203-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52E1E120007
X-Stat-Signature: gyc4t5b47edhudwkj5eb5qx46949hk5z
X-HE-Tag: 1783325831-119240
X-HE-Meta: U2FsdGVkX1/80mMPC2PABaOYm2TS9Utslm4xbbx1v7sneEWPpPI7Fz9Ow8uI44Vjprz3TuJKeKmTY/VXia05ojwSjujZ6oOBLY0J32deBcL9L2oB/Lq2FKutnrW6dW+yuHJtLNAt5+XNfa9HoaLg3iV9JhLGG8gRe/hi1Ys04+uqWoUM3kUzwEnwsVxL/wK4wJmU90uXvIGkIxGJtjrQp8DdE5luIeX/zyy85S/iPwTl8S9HJeeY7SoBJPabZEioIWinoY525gEVs0poPmJZpUC2dUabgsdR6hYhLWrSWNmnYglLg8JJm8RbdoKIxxYkIEAzoi4CU+o76AUHYmm+yZDLv4Qm9W+3hIoaQ2Gz+LyCr4C9ybCDgSvf0rP64KOfA9GiTvH2nqtfeMSRA/xI2L+0QcLr/H2+0K9fYvz4L28EF83e/W/pfRUdlHWCO6OxveihnsEmrqB9G2X51gzIqBBoWtvDwu+d4KzkbHbhT6tEit8eF4rMROPUdrnkK22579cwO9rp0qEyeGMMkplecb185r6uITSKXF8OoUWBL02PVZhoAPeGqO9sUl+0akKcA+MyCW70zgEpcSlVRgWEI0Dv6V7WRB8zgUbsuXHYcfhmKlwtA/bC6H9HL9P3lgS4RbbhdRquG17EBpbCOnSxKK1h6q8w9JqYX5y3fQcG8SSEfWb2NGbJqQiBk0ruF7YqmuDITgS4cV8DXJh7B7Z2ZKMkutPOxrnBplTnftkiyJ4zyO8o3bhwU2MgUbh4q46gGcxHWI+jhO/Rcyyek4W12Jz1OptkOn6hbTG2sh7mW4z9aNNPB556TbgHpSee1W0qloEZhihNXr2MqLYdbIsbBOySgvugVRbKQLs1J2l/2cazYtII/eRwcouls0HBgYaI//ukKxJtWoZhjPk3MicHT/yK2ridJHjePGj7UKpwzBwGfszfXkJ9/OvptH2ri9YfAsvD8t4OKqxoAVFesnl
 8dv3KzKM
 z5bDZOyDi/7Wk5U5kcY/kHuYbWo8Fz6OOqBmSAK0iwLzEBzSmTcwTTGhuXAa+C8M0/+OPMVdYNOWlCKXl6c6HX3wrQN/x5y57ymbgc0DjPylpdvYw7a2cSvxsljwVgPoKryb7Xcbg/7QtLjaUa9+DcnbTFg==
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 .../selftests/mm/pkey_sighandler_tests.c      | 89 +++++++++----------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 302fef54049c..8b3400379423 100644
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
@@ -207,15 +206,14 @@ static void test_sigsegv_handler_with_pkey0_disabled(void)
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
 
@@ -247,15 +245,14 @@ static void test_sigsegv_handler_cannot_access_stack(void)
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
 
@@ -288,21 +285,20 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
+	long ret;
 
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
@@ -323,13 +319,13 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	memset(&siginfo, 0, sizeof(siginfo));
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
+	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			CLONE_DETACHED,
+			stack + STACK_SIZE,
+			&parent_pid,
+			&child_pid);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -358,6 +354,7 @@ static void test_pkru_preserved_after_sigusr1(void)
 {
 	struct sigaction sa;
 	u64 pkey_reg;
+	int ret;
 
 	/* Allow access to MPK 0 and an arbitrary set of keys */
 	pkey_reg = pkey_reg_restrictive_default();
@@ -369,10 +366,8 @@ static void test_pkru_preserved_after_sigusr1(void)
 
 	sa.sa_sigaction = sigusr1_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGUSR1, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGUSR1, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -444,6 +439,13 @@ static void test_pkru_sigreturn(void)
 	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
+	long ret;
+
+	/*
+	 * SIGSEGV handler is reset to SIG_DFL below; turn tracing off first
+	 * so a crash does not leave ftrace enabled.
+	 */
+	tracing_off();
 
 	sa.sa_handler = SIG_DFL;
 	sa.sa_flags = 0;
@@ -453,24 +455,20 @@ static void test_pkru_sigreturn(void)
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
@@ -494,13 +492,13 @@ static void test_pkru_sigreturn(void)
 	sigstack.ss_size = STACK_SIZE;
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
+	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			CLONE_DETACHED,
+			stack + STACK_SIZE,
+			&parent_pid,
+			&child_pid);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -530,16 +528,17 @@ static void (*pkey_tests[])(void) = {
 
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
2.25.1


