Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB0AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0D06B00D5; Mon,  6 Jul 2026 04:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4617A6B00D8; Mon,  6 Jul 2026 04:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329356B00D9; Mon,  6 Jul 2026 04:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F156C6B00D5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:17:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79633A0300
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:31 +0000 (UTC)
X-FDA: 84957647502.09.2C24BD9
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8353C0007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/S1JdQD3HF+91pNDr5VTsDMKGvUxvsIIFLU/hF3YEVA=;
	b=0IbQuhyx1Q5m0UJkATk3ElqoPrTbkmHYVGwc64gnC3aDdg/fAUtUYyDb4XPR6d9ZXz2RWi
	x4P2Vd/hncU7WpTIeW5d/FnpmnM0Gsic0L7DkDtEmmR4fRpvnDWbD9VVf+JEA1TXURZGni
	EdASD2z1AoinxqZfEJOMza5DwjEKscc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325849;
	b=T93lWz5uiP5dGLOUqKOpCufTs4wE2RuwSUSg1cj2gHODpbUCXi90mPo4VlMu42S/oCkb3N
	8wxQkQoowuEIbxGQOEh8vKKuwRbGuhVWf65/jCKrthRVhtq29qxBnAgc7u1BI/nU786sWX
	rdl8lY3aiLYW4X+E/9P0l6AhzyMHvFA=
X-UUID: 1ac5166c791311f1aa26b74ffac11d73-20260706
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
X-CID-O-INFO: VERSION:1.3.12,REQID:3909b2f1-67d8-4ad4-a0e5-71db74f0385e,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:3909b2f1-67d8-4ad4-a0e5-71db74f0385e,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:db9c22fdfce9175bff763b21ab82e015,BulkI
	D:26070616172085EONZK9,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ac5166c791311f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 980413701; Mon, 06 Jul 2026 16:17:18 +0800
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
Subject: [PATCH v10 6/6] selftests/mm: fix clone cleartid race in pkey sighandler tests
Date: Mon,  6 Jul 2026 16:16:00 +0800
Message-Id: <20260706081600.3570203-7-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260706081600.3570203-1-lihongfu@kylinos.cn>
References: <20260706081600.3570203-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8353C0007
X-Stat-Signature: 1wdq48y68xw5ko4zstnsctoouxj35dny
X-HE-Tag: 1783325846-429169
X-HE-Meta: U2FsdGVkX1+3s6IN1lgvlphMcWJ+JPByzffcH90Nq8wyl7bWkM8dNIOe/4pfcdzqRXT0lAJr8YQbqn0JsS7GSLz3McLWzubsxJr7qmBzReV5CahBNebpo7HvnrJi6WKUcZPT3W3DyDTlm1t0bD1hsE9c8T0pZqPKvdt9yTle6KUj7w724HdabN+K/lT/5vK8oluStSs0FlcM06+insfHuyqJRq/MnVoW7OiGQxUijHJDidp7eJ82Od9HmbDOtQNpsyIVdz3Cot5F3BW6L855HHt1483FWR3eK9LnU/mgcN0dZ+1NSqaYOKwscFVFOVDq68S0x34Nj1V22RF/pfUn4wUUay/qbjydbRcJfWi2iGxjTLFBUrkaIGckeo+lCGO2vip5zhfq85WKlmHS++/qn/unFoU781D8UjTi8fHdl8hIBptPP3tqE2q2QDwQE5tfCwOinaDdh1mDZV/BBhwklFY32/XuvsC1BjWtUSdidLYdSzBWT3s+8vO9u7gCQ4DWCnGiuAGvQYOvbE0ly87oqjotKNdtCQ3ARIjPHVSIQowRvoVhp2KDpwjWqQNB2miBnXqUlbWfFdzlZ9XMWZxnpuEOPqyAAcsnphdZ1jD8oWn71F8X7EREeKVBNJwON7iTMN4JuX9cFy2YHeJL4eEh+M8WXVWloKEUBO/w7yM38cYck880YBE4Q5CWTlIV8Rydlad0dk2d67nVDUEDlximRZ7bJOWD3IAZbbm35h9NfTdYZaS1/K0k32NMqalsxh6W9iA5OYXmd/WANuThVrIBFkLuj41a8chnC0MzhLny6/7eTsEtHe43gs7VHTBpQScVM7dXiFQ1mdQNXdn4ITga5Ck+sGqdg/ZBRbQAmIQ8wcjYCaHFlvWdr9J/+BZSNoOXtL/6KynTK52DRo5bJNVszuyt0CTHfrkMFaA3P7yJHv3ef1DZLji/efTEpdQNeiQZYUkvWzpS3fcXHuRd6UY
 FNFfAZd9
 32ejm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Passing a stack-local child_pid to clone() with CLONE_CHILD_CLEARTID is
unsafe: the kernel clears that address when the child exits, which may
happen after the test function has returned and the stack slot has been
reused.

Neither testcase uses the settid/cleartid pointers for synchronization.

Drop CLONE_PARENT_SETTID and CLONE_CHILD_CLEARTID and pass NULL for the
clone tid arguments. Wait for the clone child to exit via tkill in
test_sigsegv_handler_with_different_pkey_for_stack(), matching
test_pkru_sigreturn(), so the detached thread cannot overlap with the
next testcase.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 .../selftests/mm/pkey_sighandler_tests.c      | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index cbc24d6cf770..c218d0510a2a 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -290,7 +290,6 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	static stack_t sigstack;
 	void *stack;
 	int pkey;
-	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
 	long ret;
@@ -330,11 +329,10 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			CLONE_DETACHED,
 			stack + STACK_SIZE,
-			&parent_pid,
-			&child_pid);
+			NULL,
+			NULL);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -344,11 +342,19 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	}
 
+	child_pid = ret;
+
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
 		pthread_cond_wait(&cond, &mutex);
 	pthread_mutex_unlock(&mutex);
 
+	/* Wait for child to exit before returning */
+	do {
+		sched_yield();
+		ret = syscall_raw(SYS_tkill, child_pid, 0, 0, 0, 0, 0);
+	} while (ret != -ESRCH && ret != -EINVAL);
+
 	ksft_test_result(siginfo.si_signo == SIGSEGV &&
 			 siginfo.si_code == SEGV_MAPERR &&
 			 siginfo.si_addr == NULL,
@@ -445,7 +451,6 @@ static void test_pkru_sigreturn(void)
 	static stack_t sigstack;
 	void *stack;
 	int pkey;
-	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
 	long ret;
@@ -504,11 +509,10 @@ static void test_pkru_sigreturn(void)
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			CLONE_DETACHED,
 			stack + STACK_SIZE,
-			&parent_pid,
-			&child_pid);
+			NULL,
+			NULL);
 
 	if (ret < 0) {
 		errno = -ret;
-- 
2.25.1


