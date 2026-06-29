Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B3EC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EDF6B0092; Mon, 29 Jun 2026 06:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05726B0093; Mon, 29 Jun 2026 06:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4236B0095; Mon, 29 Jun 2026 06:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 981136B0092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:34:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EFFEC317E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:41 +0000 (UTC)
X-FDA: 84932591562.26.BF7C164
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3018820009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782729279;
	b=yneqEnlwFQoR41GOiY2dmzBxUa9RqqtgKaENE3d52d3BUD/mh7bVMKKcWhF1C0DyLWSMDe
	ZMNIq7sy6IKCQNRcmTsLwHRDC7J60MX95JMqRUGdL8ahOjnRZxuRWkjWJdpxF2Bd3U9C4H
	BII+9wwBTLoB0VtL1YiwArOLV9wqufE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782729279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aV24DYuwhork68bad2fQOFfA7K/L2mvlMBJn42NoYZo=;
	b=1ewXfMFwjnvkWSxYH2XveBLvDz/4jGla5/XA/r6aOdA/x0grOw5nqhAvmhuEVaQV0z8Cnv
	VIed8XqSAPzcOMWcGqTqFsMpjsZ2NO92u7QshqHzMGePZ0X5zKWT8I4F4lN3MlZOuDZyur
	7ANgSZIEY3oQXHQciCDnmE9I11ri+bM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 1b68b9e273a611f1aa26b74ffac11d73-20260629
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
X-CID-O-INFO: VERSION:1.3.12,REQID:3c67f2c1-0cc1-42b6-be84-7b241a095d1d,IP:20,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.3.12,REQID:3c67f2c1-0cc1-42b6-be84-7b241a095d1d,IP:20,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:39263ce372bd17c97042e39bc81deb12,BulkI
	D:260629183431J32O24EG,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b68b9e273a611f1aa26b74ffac11d73-20260629
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1582167501; Mon, 29 Jun 2026 18:34:28 +0800
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
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v7 4/5] selftests/mm: add missing mmap() return checks in pkey tests
Date: Mon, 29 Jun 2026 18:32:33 +0800
Message-Id: <20260629103234.3240178-5-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260629103234.3240178-1-lihongfu@kylinos.cn>
References: <20260629103234.3240178-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3018820009
X-Stat-Signature: gpm9qsp834hgzethg4sw9mdetjmsh8zn
X-HE-Tag: 1782729277-526380
X-HE-Meta: U2FsdGVkX1/MHDzwA5EuDWH+YtL0mAjmd7kHMKHSBuyiLWIdodLj069U9NeZPSDWnh4nsHG6SpOpMi+GUKXdRA/Dc8NKWb8d1lwlMwB/BfCE00/3qSxok8OY26DM4GgKip6jjXI+fRwq/KUWdHIA//Gu1Bxb8NJkR5M4LLKJjSadP0pJmegxaGyfJ6vH/aRb4wWlNAX5+62SzuAcRSvtelgA/w7qLBrCz9PqyPYgSHjw38jmNPU54+3J6GuPydpAogRX4J4XiH1GYlOd9EJac7ROxXmc295/ri81zMW0bG0B4jMsRZEYYySPOX4rO7SIev3D8h6gDpnqxiL0FMD9Hf/xQ+T8KrhT77g19V+lexKsjo+LQetsvOF7HflFTlked5Bo0t4d2DC3iPjE24mlnu0ZsUDPccGWOYRqwa652CtopIoxRv0L/PW5UGHyNAAlhE3SseL+sD6keFNf8rS2lzQ+tpIuF3W8ygEjyjDm7XC8fhU9H+IipIElUOQc5uHNmoDA5gKZfB8D6nV0BGUFn04dgJD0EqxMfEjtfwqUniajJTOcx0+iYnCsvl34gnQB7QqmXwsu96AXEmb7p68+6teQqsI9wQpFNEMt1kHF+mvZH7r6NOKVS5YToaqqHNgvwah2gQ9ep3zyKXWdId5WW6pAVpNkfzvPKyauo0RMHkAOWNkT3hNlwMVpowRGEaTT04UhDfY7P0j+tYz29mmz9Oj7v5QavJNBGGMSNdps7qxt5YtHfeOfcnXb98/g9IpWCD+1npE/IedeSjzy9bab9mobV8BDqJYbICb2j3VtFZpSOZ2oar8SG9P0bC9nfIqPN9l2B4eOjUC+msh1/Iidai034vaPyMydXV9I+qBqwz6ccxT68oT0e16VzC8zf1GJKg60UzJTvSAaOiolCGIQ27UceBrMYQnpa///7RbQ8f/u0NvzxvIjGFAzIv1q7b4c5WDhUUCFGbTxYZYbtOu
 24m+hlFU
 j9pp9
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
index 882928f2912b..d185d3da26cf 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
@@ -492,6 +493,7 @@ static void test_pkru_sigreturn(void)
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
2.25.1


