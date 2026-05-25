Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0346ACD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2FB6B0098; Mon, 25 May 2026 03:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D256B0099; Mon, 25 May 2026 03:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592A76B009B; Mon, 25 May 2026 03:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 499DA6B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:30:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5054161AB8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:30:17 +0000 (UTC)
X-FDA: 84805118874.10.44E5470
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id C658D1C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:30:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779694215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CHf2EyuFW/xqLHPbmcbL09Smr1x8TZtfALKb4spkt2A=;
	b=5Ug/ELYjpTk7EPSGRaQGhALzB1Cv+ieTZYA7TNtT7XaMahb5mxWqXIdme1dEUr03T3XPUf
	g3Db+IwMIws45x8WfrOUWnO6FmvmGnVptzsJR+3ii1p0IVf6JU/iWeSwetZyrM52jKvsuS
	sEmGOto4XZ68n2CHtWGwlXFRG3g9UUw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779694215; a=rsa-sha256;
	cv=none;
	b=q4sghwA7aAHDcmnMG8xCv2HYXU9ukYQjdAmGz4YtktnaeeBkM8mxyjdpU1Xlvr+T97EvzJ
	QqnOCYtcw4H7YfTRnFmjT6bVlNw3B9CNrjf57Ie2YLNvXFT30zrbJz4b0otWLsJh/xKzng
	EvUkYdABIut2qQIiGYrW882IE0fgGsI=
X-UUID: 8d92659c580b11f1aa26b74ffac11d73-20260525
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
X-CID-O-INFO: VERSION:1.3.12,REQID:e20a2a85-badf-486e-9b8e-38006600a15c,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:e20a2a85-badf-486e-9b8e-38006600a15c,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:cc07f8eb02a872ef031ba1554e11b9d8,BulkI
	D:260525153008XY0789IE,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8d92659c580b11f1aa26b74ffac11d73-20260525
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 701083469; Mon, 25 May 2026 15:30:06 +0800
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
Subject: [PATCH v2 2/2] selftests/mm: add missing mmap() return checks in pkey tests
Date: Mon, 25 May 2026 15:30:26 +0800
Message-Id: <20260525073026.27594-3-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260525073026.27594-1-lihongfu@kylinos.cn>
References: <20260525073026.27594-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C658D1C0007
X-Stat-Signature: 74dngezmxhizcs1bdgey4zw8nt9trd4p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779694214-524918
X-HE-Meta: U2FsdGVkX18Cwmohfk4FlxUBNTmmV9Ka3+5cUIbVulIUPUtkE+G4QkPrMul3RdOq58IvNrYUeTTCs1RLhjxP3+ikteDidwDqcJ8ztnCjjvCjSUsfFch1ItXzte30VFEKAPND9TD2Klx6jx0b/8wogTJgRlnIQ2m0SQPqzRO890YvRL/wwPgddYg2ESoziouyNOo2hc1u1+sUWRIo1O7iKdeJlpn5FwgKRDNXX6KlYbEzK7j96gi3Y6A0tegH1pxA964xl0octZ+PVtN6L0OUx3TJThpqtPZBCol+C0OkwLb7Z2CJZOAd5cwSVrdiWirT1596cbDlOF/RBtX00fSa1kDD3m7CpGzvIyNmkpALAGVkBKEH8rG5EDZWe4AHVM9Sd1uZKquN9ptq+5D8VZiDLF1J1n0vt3ssnfoJrxKvPedko4nCXl6JKXpmaDj3fCLCW8ELVy9QrvWINYvLf7JJKGNGlQ+LwDM7nvDaaV9BtfMk/jSJOO6Elk4H2yytX4Vu2ElOcqFP0kh5UowDnj7qIizzDXk7ozyF9BtV3kpMWwGMVNOFGzwUsq6FSB1XZEB5FWrMSIW2HtmGmOjEwEBFLY4tB6V95SbCm+b1mHc0WInSQZyRzzGU4x0ppMT5U/IHGqW2AQ2x/72/VrGR+O/Hr0rFHkFp+dO5hc36GqoCxG02RWSILssxlOOlS83c7sRpOfPnDy7Io4LNhPsZVipTR16bKHwWMrdRT+6duVQfmTSijK2hHE3sCKRqG+Th0ENjFQF/rXOhH+aKJKrYhw4Rms2XtBo/ev2CFzetEaZAggilZ3E+sbCRHBJX2oChlDbsZsJwIaylQ99z8AM2SBzy/utcOR+fGzAfMW8tx1iVEx92173fYMeTg0HEGpgRm2NkQ6afkWk6cVRpoSJiSG4tw6Dsat6zXY155IlPB96cFDIeQdWdxrghgQBGu0Vs7PzTPlGMuVGh+l6clnArOe9
 BGUIVruk
 pCHLE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing checks against mmap() return value, replace (void *)-1
with MAP_FAILED for better readability and consistency.

In the unsupported pkeys CPU test path, replace assert() with an
explicit MAP_FAILED check that provides a clearer error message on
failure.

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
+	pkey_assert(ptr != MAP_FAILED);
 
 	ret = syscall(__NR_subpage_prot, ptr, size, NULL);
 	if (ret) {
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index a390d183ebdc..eb7893ac6ebf 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -320,6 +320,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
@@ -493,6 +494,7 @@ static void test_pkru_sigreturn(void)
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


