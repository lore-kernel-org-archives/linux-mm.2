Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FD7CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60AE66B0093; Tue, 26 May 2026 21:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E24D6B0095; Tue, 26 May 2026 21:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8296B0096; Tue, 26 May 2026 21:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 406B86B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:38:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA843C1D84
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:38:30 +0000 (UTC)
X-FDA: 84811489980.28.18F1413
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1F1F240004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:38:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779845908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qW42JXTul1w7LOIO25NEo4fQiV7WnGfsvd0AiN4slaQ=;
	b=M0K+oBWeJTgVLTowd+iLkuwtoRSRey6JuP7wov/10W21zNTPaHzboCnvziYyp1n3Fl/lJ8
	SbPwE3zznGh8cKxpjhgBka7MbH3v0rh10eeZcSGMZ3VxcCZUM1dlswdHiDwfygyk//2Iie
	5iQANerjP3QGxtmEiNT0SpPL9Etk2jI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779845908; a=rsa-sha256;
	cv=none;
	b=k/+YAUe/2O3oAp3+ue6WskwnwdjxOk8ZYhWlAaKUWg0JiVPeeG4gUNafuzciUJvIUu31kJ
	h/FzFw70zHayOQGRhKLJ3+PdezSobwPNwd9kv883X+jW1K+aZn2845Qoob1zMnrWX7alEE
	I9NHo6em4nd4fiaMw/cHscGnF+U6yC4=
X-UUID: bde7164a596c11f1aa26b74ffac11d73-20260527
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
X-CID-O-INFO: VERSION:1.3.12,REQID:2c5901fa-b67d-4165-8bf7-7b893bceb6bf,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:2c5901fa-b67d-4165-8bf7-7b893bceb6bf,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:6818a2f5f96fa0529c7c5c47841df6a6,BulkI
	D:260527091300VQJFK9I1,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bde7164a596c11f1aa26b74ffac11d73-20260527
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1442202244; Wed, 27 May 2026 09:38:20 +0800
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
Subject: [PATCH v3 2/2] selftests/mm: add missing mmap() return checks in pkey tests
Date: Wed, 27 May 2026 09:38:25 +0800
Message-Id: <20260527013825.1134225-3-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260527013825.1134225-1-lihongfu@kylinos.cn>
References: <20260527013825.1134225-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1F1F240004
X-Stat-Signature: pd5t6563byobruga3kjjgzyjnacxxkip
X-HE-Tag: 1779845907-51987
X-HE-Meta: U2FsdGVkX1+3E7mX42Gcs4NEw4zjn04fufkg0bGSz8xexWmB3nFhd0eaA2K1Z9KXJXO/fJPHRweb5HEsQa+h8rNRjNT9T7fEtBQoipeNKUF6jqWnuMLbomGGEwCp1XOgDxnbx/vP3q1FQhc61zDMvWp3dNjwo6Wd3yc/ePYvwb4q2YaF782lRD1UHROTufpqG1cikU2pocRvDXB9ZpJWPzXI/zPnj7X2LbOQDS3UnLcSHlsqC2iY6NnwZvqk6LGD/R0uVHi06zmONAGo74O/MH06Wqh8YmG+aAk7E9taZZ+OHr22WELVZANDxX1dsG2+eFh2iIkPPauuIjdpx1+UznPNa5EUrvViS+qqJ1uSfP35NzTYww1BUviUtDpj35CTCYF8KNe9/7xDZBi53gXtjaqqiEZWi2awuf0qyzcKKNSnLVmq/dRATqvm5t1hQMvI8SKP0SBE9dl9X1Vb7621c1Z2qKDR3HKOcxQh03F2oO1BZVxqtHFUz0wAGpaN/cVylGMFjMm6RkKJQWrD4laD/BvGAR7UWYa/3z8ppxLYRWKQLWAknQOtsgd7U8T5S8n4VCV61ghzFfoKJpXhzDvXVfhSXcECM/ixdg9xvUCOflwrCMrge8tLXQDAKvMYvxpdX5AxaUz6b7R3HiXSAAOYS4FqDJtDZ0eFuBT0Ojp+DitEF4d6SczMbKjzapYPpjz/4lYhhDyHu8F5FtefZaEEr260SPKex6bB/GDDH3WOa2dY2tK1svoG2OB1371EY1sQKbVVtt85CONciAsGfHH4q9BYhIEAIfv8/TeqbDb4d6raWxOuoq92XHqLf6ISzFMyagpHWQGVMBK8jlj9ow64z11zaZ+fnCWh1Lw108qmEJlYOBsAam8eKeFg9hQBd/+dZOlHGBcRvP8AM15K+mM4ILvHfXYfjErGi4wcNCXy1rfjTTXAFFMjgsDqETJdlQ4RkoltMow7Y7StlN/foMw
 X82pzUWX
 jk21t
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
 tools/testing/selftests/mm/pkey-powerpc.h        |  2 +-
 .../testing/selftests/mm/pkey_sighandler_tests.c |  2 ++
 tools/testing/selftests/mm/protection_keys.c     | 16 ++++++++++------
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-powerpc.h b/tools/testing/selftests/mm/pkey-powerpc.h
index 17bf2d1b0192..f482b1abcf55 100644
--- a/tools/testing/selftests/mm/pkey-powerpc.h
+++ b/tools/testing/selftests/mm/pkey-powerpc.h
@@ -126,7 +126,7 @@ static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 p
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != (void *)MAP_FAILED);
 
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
index 3c0cbf8f3eaa..ae474e65f3aa 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -585,7 +585,7 @@ static void *malloc_pkey_with_mprotect(long size, int prot, u16 pkey)
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
 	pkey_assert(!ret);
 	record_pkey_malloc(ptr, size, prot);
@@ -608,7 +608,7 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
 	 */
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	record_pkey_malloc(ptr, size, prot);
 	mprotect_pkey(ptr, size, prot, pkey);
 
@@ -688,7 +688,7 @@ static void *malloc_pkey_hugetlb(long size, int prot, u16 pkey)
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	mprotect_pkey(ptr, size, prot, pkey);
 
 	record_pkey_malloc(ptr, size, prot);
@@ -717,7 +717,7 @@ static void *malloc_pkey(long size, int prot, u16 pkey)
 		pkey_assert(malloc_type < nr_malloc_types);
 
 		ret = pkey_malloc[malloc_type](size, prot, pkey);
-		pkey_assert(ret != (void *)-1);
+		pkey_assert(ret != MAP_FAILED);
 
 		malloc_type++;
 		if (malloc_type >= nr_malloc_types)
@@ -1135,6 +1135,7 @@ static void arch_force_pkey_reg_init(void)
 	 * doing the XSAVE size enumeration dance.
 	 */
 	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	pkey_assert(buf != MAP_FAILED);
 
 	/* These __builtins require compiling with -mxsave */
 
@@ -1693,7 +1694,10 @@ int main(void)
 		printf("running PKEY tests for unsupported CPU/OS\n");
 
 		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		assert(ptr != (void *)-1);
+		if (ptr == MAP_FAILED) {
+			perror("mmap");
+			return EXIT_FAILURE;
+		}
 		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
 		exit(0);
 	}
@@ -1706,5 +1710,5 @@ int main(void)
 		run_tests_once();
 
 	printf("done (all tests OK)\n");
-	return 0;
+	return EXIT_SUCCESS;
 }
-- 
2.50.1


