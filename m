Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A51C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2D06B00AC; Thu, 10 Sep 2026 08:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374076B00AD; Thu, 10 Sep 2026 08:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2639A6B00AE; Thu, 10 Sep 2026 08:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9F326B00AC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5137A1404CC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:19 +0000 (UTC)
X-FDA: 85197717318.11.884A5A3
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf05.hostedemail.com (Postfix) with ESMTP id 55467100018
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y /IDDIa";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hpByUBib;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZttzZbEWmniFloGWXXa9WcpJ9aZ/lRN/IO7GYTjQ29k=;
	b=k+aF3S7mXvhnN9S6cH3IdEtP94QEnZJyQ/Pm3hEF3aUSQrrzzanDSF9yyUc1+O0+iP2nr/
	yCTf00x42M4cMNr7u0HWtcXxfxFfumLHuW9uzv2E1jOlCoTQA00z9Ek7MB7HdgU/S2X7kg
	nDXX97aWIeoewx0lqGRfRsGuGgpTYLc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y /IDDIa";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hpByUBib;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041797;
	b=7Pau4MijAphr1Z7xL7h0n3m08NFpVUfBnUzMNQg1AAJ91B6zQb7vemTMQagor/Wnli51o1
	zFaPuP5SJiieGC9Axzsw3pTkr6pZCAwcnx5uAsw3306zMxapfqpQcr7lVmWjKNpDhs5YH6
	1j/DhPGkdSAPOfe8pf8d+c09UziJshA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 4255A1D0004F;
	Thu, 10 Sep 2026 08:03:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 08:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041796; x=
	1789128196; bh=ZttzZbEWmniFloGWXXa9WcpJ9aZ/lRN/IO7GYTjQ29k=; b=Y
	/IDDIawoHWwsapkKw6WfeUQ/5ZhVEe130M8sRiq1dHYJgA7nuOCfyb3jyPOAkM7M
	rPIiJZu3JxA/zcskxOHDEg/vr4YwN7q9sXaFnRI9I1z0pIXld+ykzCipwsUJAc6L
	Ncu0gqfn/l1Esf8aVfiv9lNK70XN5OHrpj8/BdsiLz569CZjverp2Re1WwOjjypM
	Fh9dYae9KkB/SYvS2TDDJVhgn9GUuy7vg4R45ZCjcRlVTBR19xuoINVpRsLZ29SD
	DvdTTjKxEaBS0p3hIBXi8FkPoyrycFLlqGXYa5OFO69d/V8yKKgwQfTkpwurbkUK
	iSLL0k71z3wUnllHm23eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041796; x=1789128196; bh=Z
	ttzZbEWmniFloGWXXa9WcpJ9aZ/lRN/IO7GYTjQ29k=; b=hpByUBibgZSTSQlt1
	0A+OsZkMGGnQF9esFIvBt9DgvbTOiCfur4ZTu5QjuTr5Fl3oTaCcvccQbCbvmmMo
	TxmR1W15njV63TkCNK66knLEsUKeng2qkj1SRPd0cxbYIyV8WPiEDs46pJSeSOQP
	z26/UluebBIvIC2edFhjVChSV9BZ1imXauCc2/k7QZPj7hGNYwIJXf/9XML3hjxw
	mzRmynUvEaYSM/Xj8MQrLcP1cVslzivl4grnggCZC8QXf7EccMPftP0Rd4AmaVJr
	KDLFGXMJsuk4cD/iaB51Jdlp0hVP2Vsif9GJu+ZJNHPlRTv0K5TK6AHWkCkrniQy
	tP6ng==
X-ME-Sender: <xms:hJyiar1t3gD5TEo1FIWIYfoFsponz1O6MhStxObIiUn-XiBNEtsv2Q>
    <xme:hJyiamBGzY5HXI9JPbWXyBboPlz3wZ_cYBtZhJfm8QEKWyv4JHogLP5qrjcISxcW0
    z1B3QaqTmcgAbRgfSl9rhBcrBZPO8dnAz0ICBnkOYAUcIhPtnXYNk4>
X-ME-Received: <xmr:hJyiaiDTAh5N2apvvbLV_OIHuaR0XGhQk54JhfHLuGDHrxysLLztoR_fgN8>
X-ME-Proxy-Cause: dmFkZTGUwtybjwPNTLo6R8Djs851CxE4dYABoksc5DOLebDAdjF/7kz2LTXedMZaJHaEsl
    u+9R36zRT1ZhtRkJBR4Xz/EwBimHSAG+mwOmEGehzEiv3PYSuq6Z2mKTclu6l8ZCGLaRVv
    RupVEjOuMXLaHhEvmZ7MRnQK4S/jaA4Fn+A/pUOz8kiJx7aYiU9MigP37WKT+MGxNap2wz
    dRarL4pe9tmhsdpwwUXZj55Ji6mi71ZgLtAGecz1FGZAcB1ieVS0L457vxQ1F9sxIDxLwT
    QcbTU8EZJEacVnPbAL6aT/vW8eX/g2TSMrM6YxxBPc/XsEEo+/bzW/w+LZ0gFhc/ZZnenC
    oz1QcdLXM9OiLPZRMrV452RrLNmkTNrinjOdREYRHS2NkkyGueNPNckGvPvq6YZoblNe4k
    bFSCxQvNlMrOLPybz0XCbF4VEV2g82XKF47qda8jBCJqqo6DE4Jt7dyt7qjGHpXsek1lYr
    wMLN4eubNCOayGO5XTPuTSp6zMxz7RIv7XbW/rsKqIftVh8MGIg3m2KN63AunHYZiIP5tp
    /QRV0UtUulhq0K59rVSm7YVyeLPkSeHydjthDNWGrQRUG9VTdcENvWdeFscLeoefHiMs7X
    O9QxfbHnwjHq3HT2aJxYuRAFT+5/1vfzUIIgKRzqSOv0y1o9qiXJk1ZRkDrg
X-ME-Proxy: <xmx:hJyianN9CNWT-04FzRhPtOTBCirKmW29N_3dGkD1GzmpGsDUPdX_Hw>
    <xmx:hJyiasNuFsJoNiijWjFMCygZ9Irge7J9GNZNwAY1xFm2EtGApqILYA>
    <xmx:hJyiarv2_J1KFwV_E5LQidmZO7YMqa5PwU94DX72tsxGfjaZHEQFCw>
    <xmx:hJyiah8vZHOpeH0UwN51AGQPO3S6R8tvy4wTQ6mkNiviCt1WdO_cYQ>
    <xmx:hJyiaiMbIWG-ZBSFChakE68IALr2SNRjfYniHsaqnixqYV3sbgifBYsv>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:03:15 -0400 (EDT)
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
Subject: [PATCH v2 12/12] mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Thu, 10 Sep 2026 13:02:32 +0100
Message-ID: <20260910120238.2529819-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 55467100018
X-Stat-Signature: ade6gerbszn8qxb58e7h3ry3y5gsmfhg
X-Rspam-User: 
X-HE-Tag: 1789041797-313404
X-HE-Meta: U2FsdGVkX1+VbdLrjZboVx9sH0OopW8gvxYj+G8BbLLHQOb7oaTczo3uFscWYaY8uqIT2+vQXG9ef296ODefREjq7uBsQsZHCfVPPVOtSRN2miQ3LrilMlF9F+Au7e+sQVv+dwBavRAES/QpMF8tJ/gHcFcRJVmEUP6pEj/fKkjHmjOXY4YI0oGKseGe1A5J8tUC1PUMG6MUim6TmOCynqKa7OcUIP4BGJrTnBD3FjG2rVLjQXxNbTbk/3UzMjhN3IAaCXubZ0M8dtH3Tq9+6KwhCVtxsuQDEYFkHu8PxyQES3vXIJO5Adi7v5Er8dfy2wvoRTk6ukAWlZkX9CwlEoYQXonAdT61s74s5Uu/rDTaOshOOdznGIa36+1Bf/GT/FegAoDsIibCJCl25Mkq/OcuYdkjPxJcPF3WK6YHMACsnHN5teSW+ugTviqWQ5zp4iTTojVLwN0wZdiaApP6ckwn331UUQHQI2ivmiIDUD9K2yOh0XaF8mafcXFidW5eTaLRzFhFThCCmZvsW8+c9AbwVEwi9kVpissKrBJJmTgUcDfwexE6iuCTvxN0jlj7hgwWsG3vn1E+K1J5nZB0YnmgunAdeBzZ0jQXUJhXCpvgL3owE/oWWxwEYQW+SdoEplkdyCDz1yIjeg+9A9/jo22jzoA9fcC9jzMdfDmLmGlCHvbNbj4miVZ/RhyeM916jOSvM6BMHTAhAlKzEgVz07kO3FuVZGTzxhdMptXHDSdmGYlAwSRcYjssFkRFjB1x/dr1BSuMnvtwqF1InXSMKY2g7jyMMnMvrHM+884nilmsMhp4TQDExrDcXqcsu43OlJmAQ7y0IQXdn3r3ghEsLDoDOrilOxn7OxcW48uFDDcf054FONoh/+DqhRF9I09jam5j24zT01n3Vg82EO51QGDukzJBw21CaInDgGLCOfdtJ/8aPAiECh8FtFMz+fhMV1BTnkp+NMPwVku0+Fr
 h4u0JeoH
 M6pzweRwkOM3Ne+8/W5369bSZ6G0paQHaGjiHyMZXmezOg/4kM63bjKjxP5cvmX0J5nh5rmOgKgBhBsw2u8yBarhDHX+tpwq0ZIxoG2rCq2qs3wLcnvMRsUvyHFZTaOMnbPlXhB9VQE13TiAkR+lU+ACx3Lk4rqirT+AjFh2UjqTAuQ+XO2tlG2PJ09G1HD6gKtcivZt+lXlM8hdtwonkXDBTnxqKZgy12FmwN5X30yeCi/Lb8z9N0hhRIedV/VB4pLBL/UK2Gd1zrRPFjFSE7jX4p82ypEhrZMDIGTL3elJS2a079knTQbmAPh1ECR/nqcyo+Q7tsLkANm1+5c7i5YF0WWBseKBW1Jty0/I16KpdaFKHo06J53R3OLbYyx4FmAuh7no/ocD2jRfP7Ts2ngIF2JNMHmz+OZBw+9BoE1PT6ILaFgpoPifTbCMWIUeneHjUkrlagn4g8yMJ+o/kr2jHgCNstNnY/LRF0HO7xjg1ZaL4gmOMI07BPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

MADV_COLLAPSE is a madvise operation, but its implementation sat in
khugepaged.c.  The daemon's file therefore also held a syscall's worth of
code that has nothing to do with the daemon: the walk over the user's
range, the per-PMD loop, and the errno translation.

Move it to madvise.c, among the operations it belongs with, along with the
errno map and the policy it states for itself.  It takes a struct
madvise_behavior like every one of those operations, which is where the
range, the VMA and the lock-dropped flag it used to be handed separately
already live.

It stays a caller of the interface khugepaged uses, so nothing about the
collapse changes.

The !CONFIG_TRANSPARENT_HUGEPAGE stub moves in with it.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/huge_mm.h |   9 ---
 mm/khugepaged.c         | 157 +------------------------------------
 mm/madvise.c            | 169 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 169 insertions(+), 166 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..8ca0fa3be2ac 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -510,8 +510,6 @@ change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
 		     int advice);
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
@@ -715,13 +713,6 @@ static inline int hugepage_madvise(struct vm_area_struct *vma,
 	return -EINVAL;
 }
 
-static inline int madvise_collapse(struct vm_area_struct *vma,
-				   unsigned long start,
-				   unsigned long end, bool *lock_dropped)
-{
-	return -EINVAL;
-}
-
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 77f34aedf0f2..1deb74cf28af 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -969,21 +969,6 @@ static void collapse_policy_khugepaged(struct collapse_policy *p)
 	p->tva_type = TVA_KHUGEPAGED;
 }
 
-/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
-static void collapse_policy_forced(struct collapse_policy *p)
-{
-	p->max_ptes_none = HPAGE_PMD_NR;
-	p->max_ptes_swap = HPAGE_PMD_NR;
-	p->max_ptes_shared = HPAGE_PMD_NR;
-	p->strict_sub_pmd = false;
-	p->skip_lazyfree = false;
-	p->require_referenced = false;
-	p->install_pmd = true;
-	p->writeback_dirty = true;
-	p->gfp = GFP_TRANSHUGE;
-	p->tva_type = TVA_FORCED_COLLAPSE;
-}
-
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -2802,8 +2787,8 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	return result;
 }
 
-enum scan_result collapse_run_pmd(struct mm_struct *mm,
-		unsigned long addr, struct collapse_control *cc)
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
@@ -3179,141 +3164,3 @@ bool current_is_khugepaged(void)
 {
 	return kthread_func(current) == khugepaged;
 }
-
-static int madvise_collapse_errno(enum scan_result r)
-{
-	/*
-	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
-	 * actionable feedback to caller, so they may take an appropriate
-	 * fallback measure depending on the nature of the failure.
-	 */
-	switch (r) {
-	case SCAN_ALLOC_HUGE_PAGE_FAIL:
-		return -ENOMEM;
-	case SCAN_CGROUP_CHARGE_FAIL:
-	case SCAN_EXCEED_NONE_PTE:
-		return -EBUSY;
-	/* Resource temporary unavailable - trying again might succeed */
-	case SCAN_PAGE_COUNT:
-	case SCAN_PAGE_LOCK:
-	case SCAN_PAGE_LRU:
-	case SCAN_DEL_PAGE_LRU:
-	case SCAN_PAGE_FILLED:
-	case SCAN_PAGE_HAS_PRIVATE:
-	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
-		return -EAGAIN;
-	/*
-	 * Other: Trying again likely not to succeed / error intrinsic to
-	 * specified memory range. khugepaged likely won't be able to collapse
-	 * either.
-	 */
-	default:
-		return -EINVAL;
-	}
-}
-
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped)
-{
-	struct collapse_control *cc;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr, orders;
-	enum scan_result last_fail = SCAN_FAIL;
-	int thps = 0;
-
-	BUG_ON(vma->vm_start > start);
-	BUG_ON(vma->vm_end < end);
-
-	orders = collapse_possible_orders(vma, vma->vm_flags,
-					  TVA_FORCED_COLLAPSE);
-	if (!orders)
-		return -EINVAL;
-
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
-	if (hstart >= hend)
-		return 0;
-
-	cc = kmalloc_obj(*cc);
-	if (!cc)
-		return -ENOMEM;
-	collapse_control_init(cc);
-	collapse_policy_forced(&cc->policy);
-
-	lru_add_drain_all();
-
-	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		struct vm_area_struct *found;
-		enum scan_result result;
-
-		/*
-		 * A collapse gives the lock up, so the VMA has to be found
-		 * again after one: it can shrink while nothing is held.  A scan
-		 * that finds nothing to collapse leaves the lock alone, so a
-		 * range that is already collapsed walks on without relocking.
-		 */
-		if (!vma) {
-			cond_resched();
-			mmap_read_lock(mm);
-			result = collapse_vma_revalidate(mm, addr, false, &found,
-							 cc, HPAGE_PMD_ORDER);
-			if (result != SCAN_SUCCEED) {
-				last_fail = result;
-				goto out_locked;
-			}
-			vma = found;
-			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
-			orders = collapse_possible_orders(vma, vma->vm_flags,
-							  cc->policy.tva_type);
-		}
-
-		result = collapse_scan_pmd(vma, addr, cc, orders);
-		/* Nothing to collapse here, and the lock is still ours */
-		if (result != SCAN_SUCCEED)
-			goto tally;
-
-		/* The collapse takes its own locks, so give this up */
-		mmap_read_unlock(mm);
-		*lock_dropped = true;
-		vma = NULL;
-
-		result = collapse_run_pmd(mm, addr, cc);
-tally:
-		switch (result) {
-		case SCAN_SUCCEED:
-		case SCAN_PMD_MAPPED:
-			++thps;
-			break;
-		/* Whitelisted set of results where continuing OK */
-		case SCAN_NO_PTE_TABLE:
-		case SCAN_PTE_NON_PRESENT:
-		case SCAN_PTE_UFFD:
-		case SCAN_LACK_REFERENCED_PAGE:
-		case SCAN_PAGE_NULL:
-		case SCAN_PAGE_COUNT:
-		case SCAN_PAGE_LOCK:
-		case SCAN_PAGE_COMPOUND:
-		case SCAN_PAGE_LRU:
-		case SCAN_DEL_PAGE_LRU:
-			last_fail = result;
-			break;
-		default:
-			last_fail = result;
-			/* Other error, exit */
-			goto out;
-		}
-	}
-
-out:
-	/* Caller expects us to hold mmap_lock on return */
-	if (!vma)
-		mmap_read_lock(mm);
-out_locked:
-	mmap_assert_locked(mm);
-	collapse_control_release(cc);
-	kfree(cc);
-
-	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-			: madvise_collapse_errno(last_fail);
-}
diff --git a/mm/madvise.c b/mm/madvise.c
index 963337f93a7a..f75a9d139980 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -38,6 +38,7 @@
 
 #include "internal.h"
 #include "swap.h"
+#include "collapse.h"
 
 #define __MADV_SET_ANON_VMA_NAME (-1)
 
@@ -906,6 +907,171 @@ bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv_behavior)
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_forced(struct collapse_policy *p)
+{
+	p->max_ptes_none = HPAGE_PMD_NR;
+	p->max_ptes_swap = HPAGE_PMD_NR;
+	p->max_ptes_shared = HPAGE_PMD_NR;
+	p->strict_sub_pmd = false;
+	p->skip_lazyfree = false;
+	p->require_referenced = false;
+	p->install_pmd = true;
+	p->writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
+static int madvise_collapse_errno(enum scan_result r)
+{
+	/*
+	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
+	 * actionable feedback to caller, so they may take an appropriate
+	 * fallback measure depending on the nature of the failure.
+	 */
+	switch (r) {
+	case SCAN_ALLOC_HUGE_PAGE_FAIL:
+		return -ENOMEM;
+	case SCAN_CGROUP_CHARGE_FAIL:
+	case SCAN_EXCEED_NONE_PTE:
+		return -EBUSY;
+	/* Resource temporary unavailable - trying again might succeed */
+	case SCAN_PAGE_COUNT:
+	case SCAN_PAGE_LOCK:
+	case SCAN_PAGE_LRU:
+	case SCAN_DEL_PAGE_LRU:
+	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_HAS_PRIVATE:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
+		return -EAGAIN;
+	/*
+	 * Other: Trying again likely not to succeed / error intrinsic to
+	 * specified memory range. khugepaged likely won't be able to collapse
+	 * either.
+	 */
+	default:
+		return -EINVAL;
+	}
+}
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct vm_area_struct *vma = madv_behavior->vma;
+	struct mm_struct *mm = madv_behavior->mm;
+	struct collapse_control *cc;
+	unsigned long hstart, hend, addr, orders;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
+
+	BUG_ON(vma->vm_start > range->start);
+	BUG_ON(vma->vm_end < range->end);
+
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
+		return -EINVAL;
+
+	hstart = ALIGN(range->start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(range->end, HPAGE_PMD_SIZE);
+
+	if (hstart >= hend)
+		return 0;
+
+	cc = kmalloc_obj(*cc);
+	if (!cc)
+		return -ENOMEM;
+	collapse_control_init(cc);
+	collapse_policy_forced(&cc->policy);
+
+	lru_add_drain_all();
+
+	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
+		struct vm_area_struct *found;
+		enum scan_result result;
+
+		/*
+		 * A collapse gives the lock up, so the VMA has to be found
+		 * again after one: it can shrink while nothing is held.  A scan
+		 * that finds nothing to collapse leaves the lock alone, so a
+		 * range that is already collapsed walks on without relocking.
+		 */
+		if (!vma) {
+			cond_resched();
+			mmap_read_lock(mm);
+			result = collapse_vma_revalidate(mm, addr, false, &found,
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
+				last_fail = result;
+				goto out_locked;
+			}
+			vma = found;
+			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  cc->policy.tva_type);
+		}
+
+		result = collapse_scan_pmd(vma, addr, cc, orders);
+		/* Nothing to collapse here, and the lock is still ours */
+		if (result != SCAN_SUCCEED)
+			goto tally;
+
+		/* The collapse takes its own locks, so give this up */
+		mmap_read_unlock(mm);
+		mark_mmap_lock_dropped(madv_behavior);
+		vma = NULL;
+
+		result = collapse_run_pmd(mm, addr, cc);
+tally:
+		switch (result) {
+		case SCAN_SUCCEED:
+		case SCAN_PMD_MAPPED:
+			++thps;
+			break;
+		/* Whitelisted set of results where continuing OK */
+		case SCAN_NO_PTE_TABLE:
+		case SCAN_PTE_NON_PRESENT:
+		case SCAN_PTE_UFFD:
+		case SCAN_LACK_REFERENCED_PAGE:
+		case SCAN_PAGE_NULL:
+		case SCAN_PAGE_COUNT:
+		case SCAN_PAGE_LOCK:
+		case SCAN_PAGE_COMPOUND:
+		case SCAN_PAGE_LRU:
+		case SCAN_DEL_PAGE_LRU:
+			last_fail = result;
+			break;
+		default:
+			last_fail = result;
+			/* Other error, exit */
+			goto out;
+		}
+	}
+
+out:
+	/* Caller expects us to hold mmap_lock on return */
+	if (!vma)
+		mmap_read_lock(mm);
+out_locked:
+	mmap_assert_locked(mm);
+	collapse_control_release(cc);
+	kfree(cc);
+
+	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
+			: madvise_collapse_errno(last_fail);
+}
+
+#else	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	return -EINVAL;
+}
+
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
 static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
@@ -1373,8 +1539,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(madv_behavior);
 	case MADV_COLLAPSE:
-		return madvise_collapse(vma, range->start, range->end,
-			&madv_behavior->lock_dropped);
+		return madvise_collapse(madv_behavior);
 	case MADV_GUARD_INSTALL:
 		return madvise_guard_install(madv_behavior);
 	case MADV_GUARD_REMOVE:
-- 
2.54.0


