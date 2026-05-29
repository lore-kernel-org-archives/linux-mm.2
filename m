Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1395ECD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D0C6B0092; Fri, 29 May 2026 03:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4C06B0095; Fri, 29 May 2026 03:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732556B0096; Fri, 29 May 2026 03:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 622846B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:17:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EA8B411D4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:17:01 +0000 (UTC)
X-FDA: 84819600642.15.C7E4298
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84B1E12000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780039019; a=rsa-sha256;
	cv=none;
	b=ayjOwHlTiVkJNUrlm9OwACiRztKQgMW53sjBti0SHKKQpqqCSpNVOb/5u/b1enbAyvFsA7
	5Nw5etdR4L+6DfIBujtsQjUjab59iY83EjNsa3PRnrOcmQMRxVyHOTWN7T+7wRSQLHRUX4
	S8f1y7QymNM0kMI8QaPkXbBfHZPrdPc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780039019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dkTFn6hzuioVeNRgbic0O5QV5VxAO1iOjJPuGtNcfFU=;
	b=lIET66w4193goAeoOq0qEs/yLZJ2qbbwXQWUurLicYOVxPTkYeHNB8idaSwJt7SsEgoNjf
	ZktJYJDQSHrQcTsD3sh8ZD9SP/jmamHsDOb46BOVBaCKi9K/bM7aXNcTOGYiNFMH5j7jQb
	XGseKAXmVYzbSMNPPxzmsPMM2Ly8JGY=
X-UUID: 5c7fb42a5b2e11f1aa26b74ffac11d73-20260529
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
X-CID-O-INFO: VERSION:1.3.12,REQID:4ec710d6-bd5b-435b-b9c1-7e282f6a352b,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:4ec710d6-bd5b-435b-b9c1-7e282f6a352b,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:19088d55d0b9648aa9a0e2230f330fb4,BulkI
	D:260529151651FH9BHJLB,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5c7fb42a5b2e11f1aa26b74ffac11d73-20260529
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1744596335; Fri, 29 May 2026 15:16:50 +0800
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
Subject: [PATCH v4 4/4] selftests/mm: add missing mmap() return checks in pkey tests
Date: Fri, 29 May 2026 15:16:33 +0800
Message-Id: <20260529071633.2807814-5-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260529071633.2807814-1-lihongfu@kylinos.cn>
References: <20260529071633.2807814-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 84B1E12000D
X-Rspamd-Server: rspam03
X-Stat-Signature: r7e3enayjmjqs5qnk4ioko8n7jssy3f1
X-HE-Tag: 1780039017-492254
X-HE-Meta: U2FsdGVkX18PB0YDJyvmvPUrpycS/tVYAqPqFWuYYH0k1/zxD4kLpH5sUzMKOQOBiO4u22fD5TSmtPAKOg0JKX4TffGkjpqEVVnstCPCezbd/auLa+/5JhVc4ifagiWLfJdFRKiIh/tg1A/TMB/TdJWa3Gu8AGEZIX2iVbExQ02JR5JJdMnPFKKwUFQK2H/urpNFuBHbBjelIuHLMwUxlpkmUEWos/xOwoOBLvNurcdcFw/auy+ul5C5O6aY0SI4s1NhJEC2Ywl/0ns588/45ytgVwXJzqAaZ8cV5X4pxyNru099/4egxvBJRit7ZNxPJmQZRplMMN/f/PidE4a5pNynIC/jpB6EQkVNL6QE1DEN4Aij6wE8i5cfcDuHkUKn2lwecDahNXQU8zNIvDf6WpoFZBEfkt8GIvGgX0sbHDG/q9ux33d4WnUrKeOjUCG16hiP2jnPtNRl9+nQOEDsnNgOw+k04JIXTI2TI2pSu1sZQ4PGVFVNI1Fk4l805YC0WJiePpUBIqOiXc7qNieSZD4HqCXmGUD2LlTRgYKy5RYmT7/j6ow1Rpew/5HYeR8B4yz7344O0QCU8ljzOsDgxfi3RygWSfz/W3dNjWZnF2JbrG+Ezz07MZHTsWZH+WcPHNVsvB5V5rZsj7YTTF4fMj1zoOvIuYwLmVSCFA4DgVTDyHo521Qwme6lqkObVnyqRV2ozfVJGX+VusPDtmfbwZMX5BQjhRtoZKGxnW19fncYlEHE+KY/S5CDIosY9L3MH3cQaPnhGtrQ3YB/EThxa44TQTeWHZupxjGkbUm7Sb5ZAZKYMQ+JBuaTX41csdjd+/tr3foy6ccH+41gkfjZjcofxNQeo0g0KFCGZTN0S3xP8tLWsnYwt4lLe1bv4q6pQd11N+TrgOVwuvr5wwvlZhQriCwgmLcnZBpta8XmOcHrHMMzrh4zDKoEy2hXkjC+5e13Ix1pBIJJaOnB1Vb
 L3WoCVCj
 U3hgd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing checks against mmap() return value, replace (void *)-1
with MAP_FAILED for better readability and consistency.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pkey-powerpc.h          |  2 +-
 tools/testing/selftests/mm/pkey_sighandler_tests.c |  2 ++
 tools/testing/selftests/mm/protection_keys.c       | 12 +++++++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-powerpc.h b/tools/testing/selftests/mm/pkey-powerpc.h
index 17bf2d1b0192..2ce85580b404 100644
--- a/tools/testing/selftests/mm/pkey-powerpc.h
+++ b/tools/testing/selftests/mm/pkey-powerpc.h
@@ -126,7 +126,7 @@ static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 p
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 
 	ret = syscall(__NR_subpage_prot, ptr, size, NULL);
 	if (ret) {
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 231dfb079075..475aa3e3208a 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
@@ -486,6 +487,7 @@ static void test_pkru_sigreturn(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index e504544e2197..96a4eb26f326 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -586,7 +586,7 @@ static void *malloc_pkey_with_mprotect(long size, int prot, u16 pkey)
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
 	pkey_assert(!ret);
 	record_pkey_malloc(ptr, size, prot);
@@ -609,7 +609,7 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
 	 */
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	record_pkey_malloc(ptr, size, prot);
 	mprotect_pkey(ptr, size, prot, pkey);
 
@@ -667,7 +667,7 @@ static void *malloc_pkey_hugetlb(long size, int prot, u16 pkey)
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	mprotect_pkey(ptr, size, prot, pkey);
 
 	record_pkey_malloc(ptr, size, prot);
@@ -696,7 +696,7 @@ static void *malloc_pkey(long size, int prot, u16 pkey)
 		pkey_assert(malloc_type < nr_malloc_types);
 
 		ret = pkey_malloc[malloc_type](size, prot, pkey);
-		pkey_assert(ret != (void *)-1);
+		pkey_assert(ret != MAP_FAILED);
 
 		malloc_type++;
 		if (malloc_type >= nr_malloc_types)
@@ -1114,6 +1114,7 @@ static void arch_force_pkey_reg_init(void)
 	 * doing the XSAVE size enumeration dance.
 	 */
 	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	pkey_assert(buf != MAP_FAILED);
 
 	/* These __builtins require compiling with -mxsave */
 
@@ -1680,7 +1681,8 @@ int main(void)
 		ksft_print_msg("running PKEY tests for unsupported CPU/OS\n");
 
 		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		assert(ptr != (void *)-1);
+		if (ptr == MAP_FAILED)
+			ksft_exit_fail_perror("mmap");
 		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
 		ksft_test_result_pass("pkey on unsupported CPU/OS\n");
 		ksft_finished();
-- 
2.50.1


