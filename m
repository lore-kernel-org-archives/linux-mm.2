Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D75B1C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F876B00A4; Mon, 28 Sep 2026 06:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506DB6B00A5; Mon, 28 Sep 2026 06:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A81E6B00A6; Mon, 28 Sep 2026 06:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1245B6B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95599A456E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:57 +0000 (UTC)
X-FDA: 85262742474.02.C426B89
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D4EB140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q Nlv4uy";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kx4lJqVV;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gwcys0R8zu3t7D25+QkuyNJ3AyWPIUyF8hGHaRqZS8k=;
	b=cCtCJ9pblMPK0T+cihS4a6nrzFNGx1SOh9irxXPS63nsHQ3SdJUbDiHZgCsSlzc0cQhVhW
	8EFe5rs5jvg6IT3+7gIfPdla6Knjgfb4+cztpAIpR7HmZC2MViMcUpWARYgGfCMVb81CeR
	pVYaSEPmmAKHmAlJmJfJghqPebvGG34=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q Nlv4uy";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kx4lJqVV;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590015;
	b=7+9yQgZw/86nvL5QmDZ33nyisdFK68erJ9nNHF1l/eIJoDXR2lda1J9zyGsg4X1iV9YjsS
	8/wQP0Zn7yxkUMfGw7tQFqHyV7pHpa0k6yvFo02WZfo9FWb13MrqTn0kJ+/D5YbD3hgwIj
	aQ9iFEp5U3erp3tJ9ssL2yWPabJvxHQ=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 2E2E9EC011C;
	Mon, 28 Sep 2026 06:06:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 28 Sep 2026 06:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590015; x=
	1790676415; bh=Gwcys0R8zu3t7D25+QkuyNJ3AyWPIUyF8hGHaRqZS8k=; b=q
	Nlv4uym2qFFSw3f0GIsB4vE6nEg4cDK7MUv/bBlkpLyQgYNd03zun6yxIoguO3KV
	SFvhZTU+AEE1tCZVu0YfRAntZhszsxA4J8pRjiTsLGYQLqc71Y1G1Z03cdTnZ2up
	vLiCROXsgHT5FHos+qdDnpMcX+PFirMJMKpoI1eCMv5NSMGaLzoWEgTWUia/4T+y
	y4iBjg3v02l3riLmWilXdw+tZaijEZedLrrj+LJ74r6UxBOlZa+t1/SK0/ZgVIy4
	cEWlgbSrlGms/59B0Z5xkV6rJTmb94iMu/Hzj4cTW2nwMurvP1YMid3aR1SEdIRr
	zZWfH4Y4M7oYXKKZ+iFyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590015; x=1790676415; bh=G
	wcys0R8zu3t7D25+QkuyNJ3AyWPIUyF8hGHaRqZS8k=; b=kx4lJqVVP5OtKUc/u
	m9tuTS0gcOd19s5j1TqmxMW3NGOCjgON3k8G+Q244vjjOyCeul6D7kYoVQh+Oj3z
	02ygJf/1Gwma047kpiamYN1RWA8lmMvSQKEALyeXXGpiZePOfWQevfzroKIRh4m4
	tCjJzJt5HQDPC9MmdG7NrkraXF7qOL8gotYM6XYjngTZwYh3j/nvF+SuUT2BEPC/
	+B8+KAXJvaF9jaywRwKJMFfDpB0WUdHcjHa95TMMqLpd+IzjxzN/mSqWAgl6Eg8J
	I8MSU2x9hwBUseQGuGAy4XYgvhLTdMjawZ831BxwNPbJIs8vhYyogMKNdtDEBtid
	/T2QA==
X-ME-Sender: <xms:Pjy6aoIjvAWo9DtE2-qvryzg99LVHGkLAJuF23Z-rZ6uMnJNqRCatg>
    <xme:Pjy6akGpHjrcGd6ByBuvnD0aEzNGQtP2bR5psRNleqLssF2eNHeaeXrUoJWpk7K20
    sxWylxz3Xd-UT1K2X5y2BTORWorUt1oNozdgosuPB4xF4eqGpBfG2s>
X-ME-Received: <xmr:Pjy6au0S7HPIIXRTKsX15mCFrNPnxUMPoq2ohpq0zeLYgPpF-Bx0hkJjX5g>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqr5
    LkwgIlcQ/5zusUTb4uYUipsjyIVsn0ddKXIy7/Ac2+sBl5e/yrfSLCnNoYrJETdKg/o8kF
    fzUTvtNjeshNyHb6EtUY+Sbn/hKe6TEGbR69JgnW7mIGuwd+rMn0PMpJ//XilUHiBXlSCM
    OSHSJ/SzT9IkHsx+m71fdnluE4UNRHogmQH6aUHc67kGTpU0B8tDYKc16c2n/ivHvkuF0i
    QC8Z7z9Jc+Peh6y4NcytFtgpHwLoBMiSEhQXSy3L73M+jKjP7qHHcG+IPB9+Zq2+qw61bM
    zixA4S9j4B+tGPkbqX4asZqoT3BZncVEvlTevF+TLtplJMHPi2WXUvW2NjnA
X-ME-Proxy: <xmx:Pjy6arzVpo_3L4kPXiWV_qyQmMcxYBjkAtL0cR2u4BpINbCPC56Lng>
    <xmx:Pjy6atibHyz5RiZ1hgc-3KS9FTFWAqLLMN29sRNZ9LSYoUsSfWRCBQ>
    <xmx:Pjy6aqwGwsffpvjYdhQ771x6rZnf-MltFiIDygIuxZ0PWIMhtF2q9w>
    <xmx:Pjy6arx-yvhPMlPLX_7DfiTmfN70kV1vlm_cWNJXWtoxYXB_JWNevg>
    <xmx:Pzy6aiKVCOKs94n55y3H0z-HkvYAXB5tZRC4xMIgJ5xw0KiBBoKInBhL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:54 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v4 11/13] mm/collapse: work out the orders a VMA allows once per VMA
Date: Mon, 28 Sep 2026 11:06:25 +0100
Message-ID: <20260928100630.21870-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 79mqgzcyiboiomngiip98f391uzbhocn
X-Rspamd-Queue-Id: 9D4EB140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790590015-708858
X-HE-Meta: U2FsdGVkX19Nfyok8dKjP6Jt5STk34sym3HjKnU9F1Lf//JUrZLXFEsH7xwdBHV8sVTlV/yabPtvK3RC4YgCTOLJLJ8bPIbWNERrqK5agXQjdoWMYOHQdutkiAM3dMV0XSAHtO4M4hx4T6Y3OS42tkzoD9hiUHA/EcWpveHjLMtsIAljQNLMIlMG+c7MQW5LzxkYhHP6msvo/BxsL8fyPboqrB1wD8DgTpR/sR4pqevV70HPst/6rpOi3MXD41bEDbOpe5ICr2AuNjBKUdFvobmiyBg1wVcyJBtatgNXKdfiOfubV4LGULZfh7R3hq9sNBtZmav5OuUyejyWKprXK1bMiB83H7XU4GhpjPaBaefmh11TO4TMbzLOAgABflr5jzCjTsMtaES//iygAh39Aq5rd2uyyc3mtLPMAX1kPLy4LZhhxtYN/IwM6Hb/kG+ajSeF3XJMtEY1uyWLhoDQSWIsigpoaB928WVdkMO2UqEP5avl/trut2M6uOgj9cKxEDin0tHBT6Brju6/BCjA+jxNEHCuKuZcqHJTxGrEJCUIS+GjVPME9ut+GP2DfTcV3EURyjApv05i/0TYzcp8uF1d2PYED9XnvmfFC/RhuWyQzAxoHSyc0ar5JtkDd3lsR2xoC9/YFE0EnCOKeN5v4/W3ILaFwaB9HFuJxNOoPg1f5bLSFxkyehTp9nvQIyaSuUJmvp+t/No8wDUrSv8p3D73nlfRC3BEdwGQ83NHAeYvDDQaH9yTzKtJPSzUP3WBKsivWrYIJ06NSTQKmu0yyCj1FnDirwiKZ/4uxwr5zCiBX9pBoNRhdqyf3OFrjDwNfO+XpoJremIhd20Jh+tQuMHn1mKmrot2BOz+m2xn2WR88FmnaQJVUv6Fkl+OIauEVJ0S/GCiKmg2yH3ve4YL2qqXjPybmwgrMWHTs9jgfLkWsq9+C6YaTj2RIqDiAZ4bXwoKRPd65z3/SlF6Gad
 tybvcW5s
 PyqYt+1zVJjPTTTPkYwXafFnthGoCikZ8it3871y1JPnxfQ3X4Gn37IwBExUxAcBhlv3cJvFlMfWbwx6gzOn7yNM5cYKPcYKYLZErTo2p4v+Aes4a03tFntHtmNyLqH9NT9JAOPN/DTJ2nJcTqOkue7sHSiGBeUlhh/nLmLVr57YZgTunZwRf0oiAhxc23GgBZMk+Ui+59n6ULUoQQWgNARC6u7iR5ifI4qvqD20EUW6SbwiQFVyeu0fRMvxuKdPfMY0A8hEPzXn5N1zanziiuaqh88QVWZ+JF9y8CH20S06bADDNYd6FjjGAHGXGnMHWp51w/8/nu5zWq5wctO06z8d/Ye47W6Pg/UjByhVPDQp+LDA5aIxCaUYJrfvqEPKsbn0qW85fAMa0pnhAMNBFDVAJlSY66ZFe63vnXY6C/ByG20CPnpj+Np9NswUXqm1Sktg2Ykq3yTk+LgyGwnb+oO5A4+UzSD16udLX5zU9BkVG3g1NEyPMYYfLniEMV3EECXShFrKy8C+ssHalEAuRhEiHeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The scan asked collapse_possible_orders() for every PTE table, for an
answer that is a property of the VMA.  Both callers walk a VMA a table at
a time, so let them work it out once and pass the mask in.  It is only
good while the lock that produced it is held, so madvise_collapse() takes
it again after every collapse.

The mask is then sampled once per VMA rather than once per table.  A thp
enabled knob written during a walk takes effect one VMA later, and cannot
widen a collapse: hugepage_vma_revalidate() tests the order again under
the lock the collapse retakes.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index be8a26e1de49..ed74d3268698 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1547,12 +1547,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long addres
 }
 
 static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
-		unsigned long start_addr, struct collapse_control *cc)
+		unsigned long start_addr, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->policy.tva_type;
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
@@ -1563,7 +1563,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	unsigned long failed_pfn = -1;
 	unsigned long addr;
-	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1577,8 +1576,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 
 	collapse_scan_reset(cc);
 
-	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
-
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
 	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
@@ -2749,7 +2746,8 @@ static void collapse_control_init(struct collapse_control *cc)
 }
 
 static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
-		unsigned long addr, struct collapse_control *cc)
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders)
 {
 	enum scan_result result;
 	pgoff_t pgoff;
@@ -2762,7 +2760,7 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_anon_pmd(vma, addr, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
@@ -2872,15 +2870,17 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
-		unsigned long hstart, hend;
+		unsigned long hstart, hend, orders;
 
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible_orders(vma, vma->vm_flags,
-					      TVA_KHUGEPAGED)) {
+		/* One mask for the whole VMA */
+		orders = collapse_possible_orders(vma, vma->vm_flags,
+						  TVA_KHUGEPAGED);
+		if (!orders) {
 			cc->progress++;
 			continue;
 		}
@@ -2909,7 +2909,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
-			*result = collapse_scan_pmd(vma, addr, cc);
+			*result = collapse_scan_pmd(vma, addr, cc, orders);
 			/* Nothing to do here, and the lock is still ours */
 			if (*result != SCAN_SUCCEED &&
 			    *result != SCAN_PTE_MAPPED_HUGEPAGE) {
@@ -3191,14 +3191,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 {
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr;
+	unsigned long hstart, hend, addr, orders;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
@@ -3236,9 +3238,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			}
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  TVA_FORCED_COLLAPSE);
 		}
 
-		result = collapse_scan_pmd(vma, addr, cc);
+		result = collapse_scan_pmd(vma, addr, cc, orders);
 		/* Nothing to do here, and the lock is still ours */
 		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
 			goto tally;
-- 
2.54.0


