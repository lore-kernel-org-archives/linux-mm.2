Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1BAC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C986B00A4; Fri,  4 Sep 2026 11:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2463E6B00A6; Fri,  4 Sep 2026 11:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3426B00A4; Fri,  4 Sep 2026 11:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9D7F6B00A4
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F7DB401F0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:54 +0000 (UTC)
X-FDA: 85176417228.04.1EB8FE0
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7AB3E120009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a MPSNVU";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CVLXwanr;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ccy6RVDvD/8YFeNTOJ5S1kQA1S4Ako8Y2iYhuKh8Zuk=;
	b=AB5IkEVB1s2QG0THi+TIGrY3PyOclny6sgn2xi9RzUnsFMLDVPGLWztNPopIi6vdgj+svD
	8Fxrja9lYX2M/WcPt5v02cmW2J5toAaaQxFReYArcZCE5kxofIrA/vHFioU4MyMgjJGxvU
	KGLlBpKU851YvlDzNmPswbACjckobNk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a MPSNVU";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CVLXwanr;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534652;
	b=ecXLUX/NzpfbNLYo1iVwAdWvgG5PUeBsCgH3setmXNO12Pe8CpnlCD/GalatPmPDbkJU08
	g7vGri+od02svopEtKyA/RuZ4+g9GilHwO2jelp6y2rY96U7qTAL9NMD+RWfZ8evBAzH7d
	Oup+KlB0oaiHFhHuz3lD1UaoYWft/jo=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 08DAC1400112;
	Fri,  4 Sep 2026 11:10:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 04 Sep 2026 11:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534652; x=
	1788621052; bh=Ccy6RVDvD/8YFeNTOJ5S1kQA1S4Ako8Y2iYhuKh8Zuk=; b=a
	MPSNVUmkZ4q94Dd/bhIhiZ09l+zrxVTy215hZytih6waWGbMA2v2ESz1Df+YElOY
	Ot5XOqO+uyZY3crH0ppV/b/ISl3APPo2YgHAhE8ODgXjgt1uzrhRXHCjzGzBaoPn
	DabRInv8Oclx91vbauuOag/Qc0hqXljsav+tV8PTSPJL18pRyROdiRteYQ/hh2MG
	V8T/+x6QFzKYNcSwiyShHasRPeAFEFJuPourrenAthi8VWnr1otiz+O2bD9uGt/X
	oHskaaxTPFfAcWKt8ISM3QV3qtOCGL278M9gytGQxZoK4/bcKvrgbEaiIZG4SK7s
	vZABkGbBukkjP4arT+xnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534652; x=1788621052; bh=C
	cy6RVDvD/8YFeNTOJ5S1kQA1S4Ako8Y2iYhuKh8Zuk=; b=CVLXwanrO6sThVsge
	KJyXdziqUqvvs+AiYHEXenfLYKhwP+EO+9NWSBoSnHblOmqnGz1VdD88KGf7oDYm
	kncA7r3S87+p5Btz4Rpf6bSvfK5+1Z8/doCVf4KcLiKSaSxddFiMSJlcTSEz+FhT
	+rOS5utqwwOqESTuP5b6nSY5SyG3ctvAVk4/eooqEbILJCIx5wmYtzGhSt4NdiWy
	V6+JPUfGOhH7jKF5Pom6DpyUKiFEaQfjQnrC81JkLdjlM0dBf2iY4RX0Qb/Ba8oy
	nSeiHKhis2EEcn5eWpJ/aEqlGvemR1YvfE9GlpCXN8ZKl8XHLa21YFPZx5LXDCvs
	DHHYQ==
X-ME-Sender: <xms:e9-aalZNtEBJ9jYp__o2mkJRR246cHZhHchDXz-dllj3cE8c9aoVZg>
    <xme:e9-aaoXwzLIj3GyVgT6tiYlTRt59CQ3rNcqwi8khHxDFMoHboIQ7cWNss5Y3Za8Bf
    tDKL6GoX6x3x0jvSMWBAaPEqxU1wsAMq8LFhSHOIQQJDFIn8Uro3PCsXQ>
X-ME-Received: <xmr:e9-aauGC1xRDdJ5ihZIlP0ahw-sD9hr0qzCS7-_0CRecwVp-_ZPX1fnWkmU>
X-ME-Proxy-Cause: dmFkZTET6cjphBfz4H8Wg4Mwj3Q2fsO4rbzY0RZa6uwdK6ABZ7pEhWaf3DWE0Wh23XozXl
    YXqBYYUtwtfZ1qQ9wX2bCqZqo/yq027VrzWqESBcvph06bOS8vyiOGOCS0fh2RY7A/kSFI
    L9MElk4eZ3HddGFY9A2GQHzM4/P7C4mhUDQ1iVikEtpcmuF5W8uFTm0u0CjZbROqFnINk4
    xO1zzX/Hj74YRRcHjJyG4ygWf0Hx5RhGZptpxeuVNBh7kD8dz0lfmQnwRvV5yZ57YM54K9
    KH8vVIjAAxpTayQfOZqnAJ2Uka0rmt6zQ0IYLz8TzxO+2W2OgPHZMW2lenfH2WoNpxg3YY
    DbliSH1tOdYs4x4aCoptHA30V8qxy/dp7UU56lpnsMwYKlJ2phGDgNx0bHcFNcOPxepHMX
    jl09zm5j5DUI+QBOkfeGkm58rFd36YqbNGTXV/60BMrYHPLHK9N5dtTvv94hEddeWWJTS7
    p+WCzfY+L6jW/W42Qd2vbvlKjObq9OvBSNjlRaiWuC/wWZ0bxY1sCE1ULsugksgvekA8sJ
    Rt+UMhHMKN/v3KiYFi7p6LeOb+BlwcQqfqWxWHh8IqUCxI6XsEYGhSWfuvND6uPMnra4gY
    qVNN0c/MZ/BeVEv8Q3lgjNIZqeDA32eL0WSaslD3pgt3xYWz8Hvnx2LVfdKw
X-ME-Proxy: <xmx:e9-aaqC4amflzgZ654T5WmHjlb8VRf9E5AIvEiFdnnzK9bZug6-ijQ>
    <xmx:e9-aauwOkOpxkMMHYBZUHAX4gDtCEwueRDnU7YaRqNqL1SjWE3MlYw>
    <xmx:e9-aajD-dlPJJ58BZ33icEVFRKl2TUxdRyy75hbAuyU7qD5DvZQ_eQ>
    <xmx:e9-aavB56LAZjNs-avJQbls2ZPCdkmZ3hI2ezeDnLmUKfbx0MWBssQ>
    <xmx:fN-aauRFpUT9ULKzP2yruteKSujufaRvTMnzoHT04f-AoAwQaSsrKNh2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:51 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 12/12] mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Fri,  4 Sep 2026 16:10:26 +0100
Message-ID: <da931ba050ace8e045a14429022e80cd28a96001.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AB3E120009
X-Stat-Signature: gjxgeco3bboskeg9bg9aqpjz71zznsqb
X-Rspam-User: 
X-HE-Tag: 1788534652-225846
X-HE-Meta: U2FsdGVkX18UW39Lgd6+rLMjo5oGX+3fNjwI/SpqShJ+sTnhYYsokEt3sZmpAKSOY4K/JxwlebnZ5BL1MGLsH9AGUzW3TgUbi8YBCgB6FUk2QzdOQq88PV1AVmaP/ZOgHVWRKX92jvY2Hr9iAjpqOUhwcnjVEb3AyoO4BcN715Xj+BG4ESxdeOfT6VPRvZuy5TRT6gANtV3iDbZYl+gUURaB/TgJYUkOKTOOZXTAb7AwN4a1pyRSWYE21Eheb6QEyqnMO6YyzxD1qwRWypB4/y34TQdzqStp3zyXnz++H8D5TNZQ1TCYF1Qpl2o69Xj8O8PVGfPyAB9sfqaCixpOt6aOwlQ7C70o5YioMyvsSI1gJl9HNVErQQAq6yuff4j7AXeKc22/ApwMYbyMTwLsfB6p7Q0g5mBK77/msCcvfMevZ+4nxeN77Aje5D7RdGd+ptGMTHG+EpmMzjIK9RDLcUDPgS50M0lRLCjpsDo6RGh8gTIqvjVJ02YZBCT5cFhUhhppvkLSw2tVvXmZsCYdFMM9ZJnivEsjRhrxCKbzD74MSt3prRB6RQb0dE5GjbezsBbQ9ZDrpggoErD2SW8bmjbj3jtjIVNrl2eQWhOEiO+8s8K7SClHD+HQndrExGFu7sJtKqkNHQ828jYS9OfIUkfyAlp4CbHGWWLxXsJmmKnReM8VSzAKbL04G6CxeRRPWxOe6VA2HNPR368LN2Hf6TWIpNQ3JjfG0sW79dJ0Behv81uVXOqt6ZBer9RjytnXfG76vUxKBAE1x7pBdiQ0wcyTjkvVMUkqdFs9VOQskU2BDaLS7NZz2ua5LD/eBONdRbn0EbHZQIfAT7Bbk4RkQeCfOagGOSamvM3ujZ0FWLgu9JNvSQd4Ogw0hC87uAPOXiHgqhVBk4bOj7Nki52G9IZ0wFh52mXFo4wBMYn56SIL06uNXS49iIsucDG1KWLxhs43d3GJWjF8kC9yY6D
 rffSK0eV
 DYdiNmx5NEpjMX2fe8dRLYJG62rS6S43lDu9OGxhWBLGmfmu3wpGsT0i4B6PudGZBXi6XxBPxdKbYBm+LxjRBgGM1TEgX/8kTkeWwNT7ufDRArh+1+0R6eK/shr4HSyIy4s6cI5DXA4H34YG8f5czW2qEMLI0UNia67hs/G27ebH1u0TdZgtCsY8/YSzONBQphVd3nA5JqYeQMINj4PDyf8mrEjh3Mt+4DxnDbknUKPETh2EJF+iRkwK1W5BM90NlPIiW1XnuLLMQUfC7gC+N69DR/BTQT0RlGtB35XkY94tTblqp+ZGQoQt3BIfbtY1x54TNYe/5DyUSLkPGubkLILgTvcaoGFNMAB9uRebU+t+xA7011jL7pLRfBW8dZ3pdBVIx49tje9ON1Sg2MLt6hAVGQMJN3tgE7Rk49rz4WygKi6Sg0IRJ7CEVDg==
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

Assisted-by: Claude-Code:claude-opus-5
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
index 13c4dbf04379..0bafdb725204 100644
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
@@ -2793,8 +2778,8 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	return SCAN_SUCCEED;
 }
 
-enum scan_result collapse_run_pmd(struct mm_struct *mm,
-		unsigned long addr, struct collapse_control *cc)
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
@@ -3160,141 +3145,3 @@ bool current_is_khugepaged(void)
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
index 73c2901b9adb..25a58f97b4e5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -38,6 +38,7 @@
 
 #include "internal.h"
 #include "swap.h"
+#include "collapse.h"
 
 #define __MADV_SET_ANON_VMA_NAME (-1)
 
@@ -905,6 +906,171 @@ bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv_behavior)
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
@@ -1372,8 +1538,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
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


