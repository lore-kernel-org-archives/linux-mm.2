Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873F8CD4F49
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96F06B0005; Mon, 18 May 2026 04:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E546B0088; Mon, 18 May 2026 04:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABFC6B008C; Mon, 18 May 2026 04:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAA3D6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:21:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7941A92113
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:21:17 +0000 (UTC)
X-FDA: 84779845794.26.F5BDC48
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92F21C0004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:21:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779092475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+z1IFgELzXm/qZ5/JbkmNIArFgxJnYL9g2v06Fp28kw=;
	b=qltYmqlXZ/9ZtRdUznyfOMUlBSWoc5mkEJDeX6XlEXsxEbJf0HYci9VRIpfWveRbokKwsI
	/oBtKex7xKabiwBFv5POksfyvs8BEGCI541Aad1xU5/uB7Sr4IuVUkvgkJUrDN8pTDmR9x
	w3SbiPMORubN9a/Dj4kzLgfrIJph0UA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779092475; a=rsa-sha256;
	cv=none;
	b=x8XX0PneAyUcCy9iFOBzy3BiTmrPAp+oiXozscpf+nqMybHS5hXccWpKLaMjC3M8IS5tmS
	iDQXZ6RlVFf88YLbOBmc2EYCBqAfrFdDM7HhwEyscghoHDn237BV/t4qvscG77zGNp8xmS
	au9nicDsm4Rm50AnXL36GGf/6SrmXyg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 84798ff4529211f1aa26b74ffac11d73-20260518
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c43c0ae4-c94b-46a4-88a5-2b37133bb355,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:c43c0ae4-c94b-46a4-88a5-2b37133bb355,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:4e25d0cca9c87494f8cb9aa16d37c8e7,BulkI
	D:2605181621085YHCR8YL,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 84798ff4529211f1aa26b74ffac11d73-20260518
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1102519821; Mon, 18 May 2026 16:21:06 +0800
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
Subject: [PATCH] selftests/mm: add missing mmap() return checks in pkey tests
Date: Mon, 18 May 2026 16:21:20 +0800
Message-Id: <20260518082120.3890552-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92F21C0004
X-Stat-Signature: hp5o9u7qtro57khmss7fk67bfp5pd9pn
X-Rspam-User: 
X-HE-Tag: 1779092473-955759
X-HE-Meta: U2FsdGVkX1+vnN3TmNNTXWWYA3al2KoudL66M4mUrtTIMHIuXoP+IkC057wq/QZk+IGvlvG7RpHnS+4vlfAzzz5K2K36yQpnV5oFpxfCC2ub8inf/RFH1Ye+BfThGg2DML6EIT3MLriTx6W9mU5Q/IDLGxxK+ulMeJy1/m02kU8wRLsEUkofjIKhxvUiaUx+pcR58Nunz3G1aeL32FYKx7mMvgmuBcs26lM+Q1ognK8/m9YAgePU7tzGcLCb1bXUgmIeJ6FjK+WV4pqlu0xB+s4QoUlkZgbpm5vjh3yGzcfylzgkNOZUDxM1X6PGFgFD4/QbHRYQv4TaIzR6qDrvWt7YByrtbIeE+nTb9UtguiSfWjhaZ/5CYTlxhftcdsmIu3VKNr58srgJJ0Bx5Y7byS/+UDj132g+s0HpyrtXIyANkxhf5Jx4oDnJhlX81rAkg4PTCWqHnhjUOuMTyzm9sEUjaTtDNPbZ1eAlgJej3DPHsitwhGPwx/frJ9OnJ2r+j31m6gsiX1HYhtdO95ksM6iNHWUoKfRRR0GMTmMSJ2p9chHQeaVdt25XheVA/YxBH0IL8bmEbWO+9JxNlT0yp3nldxRhWswv8NSP7Noua8+oZjca0E0wDCIJuHcVhD96nHeB29RH6iy+Ws78fx/j9hYRWI6Z6jcfVafsZMVs8xjh2RixCmyt79+N+fIOWGh8ILQ/4S4qOLuTPn4S0Z+sK1cme5yHWEDqPAbxF7GGQrVoEWG63FYpMRQP9GvhpaMdZ9Gia+FZxTR6DhABZrriwnVRrUNTobxySDGTc784LhWIsnsvS9zyTU29+JKGYR02XYN1XKSd+Co9Axfj3urec/D7SGvK/Lif8hDZuwoag+N3gGhMcosCmDivyBz4POe2gPgcae/oz8f0bEPniNtOm2F6xXC+G6tX8rKbpGQ/B9Fl2pE6slkVHp3CEOuZ0fOknermWgf+/5HUlIeCFRh
 DaAU9PG/
 s58ez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several mmap() calls lack error checks and would crash on failure.
Add the missing checks. Also replace bare (void *)-1 with the
standard MAP_FAILED macro in protection_keys.c for consistency.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 ++
 tools/testing/selftests/mm/protection_keys.c       | 9 +++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 302fef54049c..4637809192f9 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
@@ -490,6 +491,7 @@ static void test_pkru_sigreturn(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 2085982dba69..d53bdc540a74 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -667,7 +667,7 @@ static void *malloc_pkey_with_mprotect(long size, int prot, u16 pkey)
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
 	pkey_assert(!ret);
 	record_pkey_malloc(ptr, size, prot);
@@ -690,7 +690,7 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
 	 */
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	record_pkey_malloc(ptr, size, prot);
 	mprotect_pkey(ptr, size, prot, pkey);
 
@@ -770,7 +770,7 @@ static void *malloc_pkey_hugetlb(long size, int prot, u16 pkey)
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	mprotect_pkey(ptr, size, prot, pkey);
 
 	record_pkey_malloc(ptr, size, prot);
@@ -1217,6 +1217,7 @@ static void arch_force_pkey_reg_init(void)
 	 * doing the XSAVE size enumeration dance.
 	 */
 	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	pkey_assert(buf != MAP_FAILED);
 
 	/* These __builtins require compiling with -mxsave */
 
@@ -1775,7 +1776,7 @@ int main(void)
 		printf("running PKEY tests for unsupported CPU/OS\n");
 
 		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		assert(ptr != (void *)-1);
+		assert(ptr != MAP_FAILED);
 		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
 		exit(0);
 	}
-- 
2.25.1


