Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2032EC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570966B00AA; Thu, 10 Sep 2026 08:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA0E6B00AB; Thu, 10 Sep 2026 08:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1DA6B00AC; Thu, 10 Sep 2026 08:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8E16B00AA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93CDBA4EFD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:14 +0000 (UTC)
X-FDA: 85197717108.02.1A43125
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf18.hostedemail.com (Postfix) with ESMTP id 96AE51C000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A FLreen";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=F0b2S71Y;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0JyoZbmyblE9u75HKEHqN4ei8zPfvwntibjbDEyo6k=;
	b=G2cfWUlqTXu7mM5ZAogx/tHLdlELbRG3IhPCbxVv1hsAJ3pUNT8wiBhtE7BAdGcHx3EnpY
	k69t7Ib8IsBlatjsGGN6U4Bw3CyqzthyuuLKK6foeOGsZq21obxO9FujtZ2o8hqzO6Du2m
	WSfvlR7DfweYbYu39/bWqZCjNt/wfng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041792;
	b=tHEg3sSgVY1kt5L5gA/OskBd0ckPgM8gP8iBxZeiuPlRZuq+XkNB2ePkrxcmL+KFcUJ3o+
	7j4/oMV0WrAeroYJ+KAJX6UdiyhCqwLwlL3uLejbnrhzS7TEXHHTM5W/CYGxa+GidG8nZJ
	cH2hwU5GfCs/jeOBhVansJvKMTkJXss=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A FLreen";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=F0b2S71Y;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 8661C1D0006F;
	Thu, 10 Sep 2026 08:03:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 10 Sep 2026 08:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041791; x=
	1789128191; bh=q0JyoZbmyblE9u75HKEHqN4ei8zPfvwntibjbDEyo6k=; b=A
	FLreenn/FKiN76vFFDo7ezg7+h5fUlfERrFlbWnzdgZkxHtyZdLuN9UWj/Xo3TR4
	EWI2aVmPgnLHibn9fUnlRdCskXtz4rbSaiJFsRGCdqfBoQus49TX86CZxGN171HS
	BjhATunS8qCehWn0CPlettdJxcIb6ZnW4+W4itlQHRb7rbo2rwP99RyL9HPwTk0G
	DlvlQ0JPmXya79GVdL5gW92o5aQc08qzM2aFD2DojBXgMB/L+oqXusvsL0wogcCd
	o5WeqdNmEpzhBToFHSAYYXN5oBucL5shVq+ZX37ncX0M+iztEAKhYtT0725Ft3Yb
	Q3LChs9ExYiztWAY77UZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041791; x=1789128191; bh=q
	0JyoZbmyblE9u75HKEHqN4ei8zPfvwntibjbDEyo6k=; b=F0b2S71Y36jbXPMSH
	QFQuddPwPMhuJLoaSOwi6ZKPZ7SZoEvhRJUwWEs+7JWjyJClCCyl28BOmQABc9oO
	IauGAlvOLVF+9BHKVkhURQzEYl/L2dTC2oTYgSwV6cPhvagxjtlGlHVh1owNflId
	MWyU5D0m77KIhm+7VCXauH9CwPZ9waFJOWPfCL/BIWwID1lXthgYcNntHmhZJCSI
	54bH8lNiiIe5+76zcBanpDuA71oFLdrMMc2R+VQzw74wxuutg/eAf/f7avyDzMrU
	D6HI4tsyRppOc6t+pcRNDI/SmVrwod3F47rWrh+8u1HxNOYPzgcZeViw7XFsYUUB
	vKrTw==
X-ME-Sender: <xms:f5yianrlduVRTI_zPt8qvaSKb9pARwjzjmf673xpOrhHA7Orw0bwng>
    <xme:f5yiatkPiCciZaw6-gEGNnWY6yp6nTkzrHCsYbEzNrTdersxTwHbLGPujB_jJaI05
    JGGW8zpy5a0_PSaUiUUYajal4U9NhZtrZBqFXB025nHIPl-0VEPrCJl>
X-ME-Received: <xmr:f5yiaqVRGaCt7lncypYXiKZ0kw2f2lbFdmKK1uiDZMe3AdsM0RZvlOvvH_8>
X-ME-Proxy-Cause: dmFkZTEVCHaom43ud29NDpH2Ao3u7HJ/1ECQvA0KKWbvYxhttLa4TfzKR6zF5UuYx3UdSX
    No90AnuR4y57x1CX4a9AAsMV1JR4eQYCvRkfoTmW6C9Lc6lI8AZbTNwmqz4UTzT3vnk7qg
    ph+TCI1xI7srBtDO6Tg5MLzI4vqgzAzQGVqRHCjhPRmxizMOs2MvZfOp4fytB88FrNmNEM
    gORbCSjN6PT3vgIUt7WNrJZsAWFpVymtt3pMoPYb3jF9rU+m42uK7S67tVqaIc+biyrQXs
    /trDbiCnZfBDKlB4R/Y3z4EcguiWXCyuMp2o4aP4AZn5jbn1xeIsCoHcLAwPh3Pk2CuoKe
    z9gEfZbTx/s1NRbY0jw8R+QgBvZ0u9iB6GeqgbbrprwZ22eKYswqdWvNOA3y2DzUhzgifJ
    L53mMQtzGsi8vSL/IvC+q3HdiZUi9t5dgSeX+YtwXNJa7ADsBMfmglT/I2qmbIDhzGScte
    RJjv3ehRhULU3HZ3XbvpWYtZsWv6O0Zkxn35AopAZA9dvcjzKlmDJv6kdFgXlqwfKUONgk
    7F06cG+mHPizviSr6lePKtukpa6+OGV3R1JWhNCMHndZK+FsrVTG8zWeIbFh0hFzyuoVoq
    FTfk9M6RLNhEUYFvbPZ8zHbCVbtEsAs1dZzM3yRDwyQgKwmEWN0r2/rzs9zg
X-ME-Proxy: <xmx:f5yiahTa42aaScDMyYJi4NIeOdkrbRYuQUZashShlyvREubINww0Kw>
    <xmx:f5yialCFIfTVSOkRnyrbMZM4t6tfPSSA4VN_noe3uLB4iy_X1wbnkw>
    <xmx:f5yiasQ-9PIxVxzRl0OmdOewdChyt-QOO846Q1-rp0iYleW-QTlfhQ>
    <xmx:f5yiavTwsQHbgy4Bwv12nrwC5EovNDJehUtLMBQ2LnB-gQq3wRBDww>
    <xmx:f5yiaqhAxo9QNzwRym1aPC0lWuC588mWhaDJSVK-pxWv-PBkeCMwTQZl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:03:10 -0400 (EDT)
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
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 10/12] mm/collapse: work out the orders a VMA allows once per VMA
Date: Thu, 10 Sep 2026 13:02:30 +0100
Message-ID: <20260910120238.2529819-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9s5x4k4jiaka31z5tyssc8yuhs674eke
X-Rspam-User: 
X-Rspamd-Queue-Id: 96AE51C000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789041792-480168
X-HE-Meta: U2FsdGVkX198cxnsWsiEl1KW8VsMPDr+OEsxZagQ9st8uWFGkO2ALDBTI3HZQmF06AQV98JYCPhB+x5cJ/E/lXd/KAbXZ7qsfgfLJL/AevIaMvWKUcTFRk8Wvt9yCLEK4znprZvlsvWANT15tVWdammksbwlbYj9YPiqeYO45ZYCHhC0ncGS5yrZuY5YB11VXC1w6HmetXG5GWL7aqmVA4upd5fgOXdg5sUXFN4lB3hF5pGU+pPnpgOi3wcSLrxDkjPrBl6b0QgFs9Qt18dmgUuJ72zHsi9Koi4gTZ7d0ZVGPFELNIwX9uOAwcKZZQkozxrYzLm982+U6TAByEwUELI8KeOy4hXk80q5X8PwNjadyPVAVbM2YzlU0tqhxe56Mwt0aFZ0TXfjP5jwOjG297pup5r8EJT7zuhT/kd6QeAsqmy8Z4GSjwcCrTeAkLCCTS7zN2jnuCzEk5OVyY51MOFPHCLjAigA7eIcRSg+gySImqmJleRutdXOGMnfm0M7+pOcABSpJjBHs9iL1fIsQzPetsCuv7cgScZgpxWO5R8YqH60HHoXxEGLGlDfZHoX8XSw6M4Czc4zovfHLdPh9zTr2p3AAT4m9jEsOu/ZuDgQhfiteBjxFj2FgVTl6LM2RHy2MZVVgR7hfz363gw7cEoDwOopnVFQYVO1/7JaKMK5K4cCsKiH/DUVqX73SdAQDmUJ3IWrM9zWDk5naSopUniQ323HG8XOQimmnBcNNbFQ0Va9le6iXoNBc1bHrES7cZ6NhCGkLdb1S5u6Uaax+L13aSue8JlSK+qLO3Fo+4fb2YPYitYXuUwnFFjbu8I7Cer+R8CHGFtt7/DIPjs7eF49T6TKvHw6a7FRyhHP5laeC/5ZXa5tE8mDCR/OhXnXE3DnqHM3PcxuTYHRXhG7krljerA38nSHTg7fzAK8nM2AWaZC6CuIt98SW3KZPkYNGJQ9ABOws76P4B4j3dd
 LTONwDaf
 ++yQ3NBkti82gQbyR5190HunxT0d1qGF0aYYHZCezRglrqjD9HMBLLlyICtKnwFvyYvZCWaSSg/HxQyYQzwRAQMkrvekMDylKl81PDb6Ph+OlqFhrxi7xhIG7ZMDSvXSK5YfXtpUqIaVrPeaAp0vP381MLoFXNXCLJu7npaqzYxt5SuJFjsly4GzThVA3MAk2D6sjpKbFVB4HOz92R4WyuPbQcpCj7/bIm1YTJxE6J7zOIYWyPC2Fvvrc0f2S2TVIfHiRENPc06+/j55L0YeP5ytByjUx6qGWdWic+DPvW2Ctt8U907icFjGzeYbMUZOzuSEcZaEF8pDG7lqym7rsO5d60n+1gGeQpTym8iE7sph2mn2hy3Yfs6GTb5AaScg6bqhp0VNnsT2/Dk3NGBHvJE9SrnqKXxOdq4ut+PXIC9QfgyjjdkreegVRz6oP0p1k8nhWxloEnY7vse7K6GxgzK5CzUUSbDX/Ly+M
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
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9bdf12128357..9e77f71a788d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1551,12 +1551,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
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
@@ -1567,7 +1567,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	unsigned long failed_pfn = -1;
 	unsigned long addr;
-	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1581,8 +1580,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 
 	collapse_scan_reset(cc);
 
-	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
-
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
 	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
@@ -2762,7 +2759,8 @@ static void collapse_control_release(struct collapse_control *cc)
 }
 
 static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
-		unsigned long addr, struct collapse_control *cc)
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders)
 {
 	enum scan_result result;
 	pgoff_t pgoff;
@@ -2775,7 +2773,7 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_anon_pmd(vma, addr, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
@@ -2896,15 +2894,17 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
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
+						  cc->policy.tva_type);
+		if (!orders) {
 			cc->progress++;
 			continue;
 		}
@@ -2933,7 +2933,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
-			*result = collapse_scan_pmd(vma, addr, cc);
+			*result = collapse_scan_pmd(vma, addr, cc, orders);
 			/* Nothing to collapse here, and the lock is still ours */
 			if (*result != SCAN_SUCCEED) {
 				if (cc->progress >= progress_max)
@@ -3217,14 +3217,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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
@@ -3262,9 +3264,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			}
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  cc->policy.tva_type);
 		}
 
-		result = collapse_scan_pmd(vma, addr, cc);
+		result = collapse_scan_pmd(vma, addr, cc, orders);
 		/* Nothing to collapse here, and the lock is still ours */
 		if (result != SCAN_SUCCEED)
 			goto tally;
-- 
2.54.0


