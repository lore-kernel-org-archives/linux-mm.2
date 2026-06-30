Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B41E4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FE96B00D1; Tue, 30 Jun 2026 03:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811616B00D3; Tue, 30 Jun 2026 03:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1FF6B00D4; Tue, 30 Jun 2026 03:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA4B6B00D1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:34:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A47441403B3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:29 +0000 (UTC)
X-FDA: 84935766258.14.7BAF663
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id E5D0480009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804867;
	b=W83sJY9cyKxhbKqYOTH2ifyqpBcRlgpWCGrf4AcU0fqYWU0kTiA/vLznNk7HCp4WMEG3DJ
	klo2bhh/njMOL1gg5AbT1okG7xKTs67mx/mYM0jpVBylJu6TKxnVTCtn2pdeTZj/FcSM3x
	UydZ3rPh2XjN51veSodGK0z4i8LTbCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aV24DYuwhork68bad2fQOFfA7K/L2mvlMBJn42NoYZo=;
	b=DqITz1y4Lun3DU3ztr781esrfcVMp3GNa2Ue73TzqCQeoM6WfwsY9b+RNeUlH0oBXz5r5H
	7sAgrCSY6cH2OrNAdZV5JEDzouQ/y2uev6KAiHwjU93/vc6+1GWZGg0EUk0VVVY6hsNPX8
	MFwLED22oS2NWlZu8GO7aSFuqJe1qWU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 1b8dd24e745611f1aa26b74ffac11d73-20260630
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
X-CID-O-INFO: VERSION:1.3.12,REQID:8b538913-e8a5-4d5b-81ef-4ea6998bf052,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:8b538913-e8a5-4d5b-81ef-4ea6998bf052,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:f82a6f8db54d5ccb7877978593d3e77a,BulkI
	D:260629183431J32O24EG,BulkQuantity:1,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b8dd24e745611f1aa26b74ffac11d73-20260630
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 700629608; Tue, 30 Jun 2026 15:34:20 +0800
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
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	maddy@linux.ibm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	zwisler@google.com,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v8 4/5] selftests/mm: add missing mmap() return checks in pkey tests
Date: Tue, 30 Jun 2026 15:32:34 +0800
Message-Id: <20260630073235.3802271-5-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260630073235.3802271-1-lihongfu@kylinos.cn>
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5D0480009
X-Rspam-User: 
X-Stat-Signature: b68kan4h5hdjote5yjbe4mbkm3npenwb
X-HE-Tag: 1782804866-754777
X-HE-Meta: U2FsdGVkX1/oHeq5L+D7F5FTpbh+/Z/vdaI3TQmX3zBGzetXzUAOq7BkSRPZIt76/48I4H3Jy31zDCkbqfNnmw9aCX/ildyPwD4aHGBr1qQufwa+LQqUP+kBZcAav2AEp5qN4EDqPjj0Aio/iSaxU8GFnsjLQ5PwMshRYkdo8t8hbRWHlRYPemQ6PJ5QwcH/p0VXpm7nqYOOoH+L+a/XQ3ow0cep4izfdYts9AXdvYJlIGOIHE4lDLbZZClf7zq8FeiTvhptL25bWsxpkdzcLaBeNpOEvR77964rfTkiZSOD4PedepXjFUy9PSMWNZ/Gmsqg1Td/rH8DzAq+ZrCXKhyg1vs97loQoSeMH/gT+Kg+9k1jYDrYvg9o2cG3c/JvSAm7Aey2gGq7pTbvih8o8BuuhEsR5PI9w8IjoIPcM2+Y9REHzXs7lp8Mi2ry680G4/kw4e3uJ1H9NzPhK18xJ9rJa+nfx0vOTO7mnXWxCUYWQjg/0PyUhsbK4uiizyRU1JtmuLBzKX1psP3pjX5N5HUrB+FWQZHztj2UKHa4kT2g8XXUZUSL1sqbnhHrA5pbv5PY7WudlNNj6nof8Q+6asOvYHe677Wol0noyxPtiZtRP4zoK5b9N72Z+Nxl0cR6Ioj3RRJrOOh+626bLf0SGYfNb2M5cF+41y855g79BEJRGm+Xkax1/Jqgzn8Wk/W8f3Cqoe/UJtlMveRCvhGnaXsMSTgvTG13mEzVcM9JhaukSAxSPCLxNvoRm/IL7QsU5DYSdi37/o/BL6CVXxV+4R5DOwLtzI7Qc1Fm9GdPJ6DeDOEh/NEb/sHShpqXbqEr+OCMrp5psW0hIHKT2btHwwSYHzXgWl5OGHgvGYQju/7eKqMZxCBPCJxyeBnW4FY1uBeZ71sSRv+6tQnRUIzKwGE3MZliMcAvZIlYqJISM86lSJKmgRIvpo7QgQhDDPitJsxa+W8Kg9uRF1cTprF
 ckdP+KuY
 8BbUb
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


