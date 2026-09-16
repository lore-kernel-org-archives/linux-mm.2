Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B35BC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83F06B00AE; Wed, 16 Sep 2026 05:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FB16B00AF; Wed, 16 Sep 2026 05:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6CD6B00B0; Wed, 16 Sep 2026 05:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDBC6B00AE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08EC6A5D05
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:21 +0000 (UTC)
X-FDA: 85219109682.14.944ABEE
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2217110000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E a6Pu3z";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IeQwcZRT;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551139;
	b=1ZF6oIE+raaU7S9drBcmTz1trNiRCAuROAqSMOoRf5nwgyBECNIdkwN3H1GnT+hL76eVGb
	UGFj+088026pUTGifYGRC81+UJsWmXcDs3Qj2depho0grCIYzzGvD6saM5Gk8UJ+XWFGrK
	Qx76o9350ZeCvocPpT8nDb13rc8Yi8s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E a6Pu3z";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IeQwcZRT;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLFqjvsypH6MxOVzXQHLvkpXTaqk9hfZ26wZXIiSNXs=;
	b=4uoa5igforrSPR7R7MFtUyErNusitkRZB2XGfDigzIy90ki3XvbLPDh0loHLyPAjkBrDTx
	okcEm49+/6rxB7+jquYy+nCWCTbZ1eqxDJKmVioMMRPHQn1ju2chp1qeMhMGp2MsCEskxZ
	izJmyqilYN+UFANubI4aLk/Tmip9AQM=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 29C877A009C;
	Wed, 16 Sep 2026 05:32:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Wed, 16 Sep 2026 05:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551138; x=
	1789637538; bh=VLFqjvsypH6MxOVzXQHLvkpXTaqk9hfZ26wZXIiSNXs=; b=E
	a6Pu3zXuqqWTRgFc9dCprk1E+1nEaPZGG3gn/vy5mLnXwEoyDTb+owl9F+8Kw4/Z
	1IIflXvtN8/4i8e4X9Rh9K5YbXBdvCCtg+sQXVwsoQK+HCSdrbT/cG5WcGSuJlXy
	VDStdVqz7yUFnXuz/mCv0ypbPxtDgc+53XU2pi1By400Fnep4we/dfWBDafiNg5t
	Uo31Tf+FXGvOf0cWge2wGfS/r2pGC6MgZ/ynCOxnG6APLpVF95tcxY3O9WHmCg9c
	ySoMq+XjqcW4/YFWkfrImWRNQSXz+eKiu366NdV3FugdFNkwBkU6qVPBp1G0rhMi
	L4vXssdMbd5mKKq1MnLIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551138; x=1789637538; bh=V
	LFqjvsypH6MxOVzXQHLvkpXTaqk9hfZ26wZXIiSNXs=; b=IeQwcZRTAPVFcGsQt
	Zer36Rd5cqawzTROfp4A8YgmjBBfRBDmw5GCCudOkayPzwCOTMl0mpt05eXdaJkp
	IhPr+vYIAYEQeVbl7TCpf3UeOKAqym8H5np4l1jDpIrPV0fEqb0Ey7u/B+0BEK0k
	a+SoQHBneBmURAS6He4gaCUbdG7wS4X8ZYZ4mT2Z9c6TdMeX8NRawACSWAVwK3bi
	8zFflZQpcW2NcDT4ZQe/s1pl5DxfDaokZMWxD/p5S/4EDK/W78tszdunG+kbEGa7
	m6eZTzHmmSu7Wvoh99fyOZaJzG7klLAgcUMt02XC0gYIyRXWk7Mp0IQ6VivPgWVn
	hdzhA==
X-ME-Sender: <xms:IWKqauOnpTSK09VLRo3WzLgkczxSDOBqUm78p6h365n0LcJWoJ5_6w>
    <xme:IWKqao4s5yfxSzsR9W8rehfC8e40rRmK71tSiuRBvR1W9HK7WPlc8wQws26f6z4LS
    n8MBBJJN4Ot3_LSWDF0K0Twtg3YQBPiWj95_qw4C7ILsh58sJQZajY>
X-ME-Received: <xmr:IWKqarYoP6kCxNse6Nn_em8wZgT3SML3cOSbsNGnZyW0j6N32hTAlJXAC3M>
X-ME-Proxy-Cause: dmFkZTE31qL+uaIHQKQPvpaICSxxs7QGWvIquuW8cKaqYQWKvt9pKCqy5bgk//TApl3wTl
    ad4FQSRAknjhMkzVuMAZNh0T12ywqROLvU4AnUXGVwd2kiN78Ar+1NR+fesCkATu1LALh1
    4LvX/9qk4pAfO725ECjoAkI82P3z755hZxEkAV0An15e7Wr2vIbgLFM815SfkNmTU/eBmL
    ORNXO2IPaHkpkCtL9iOfg4dR3lpAdl3Xvq/Y35opAbs/zzbuDBIkBs44NTO3w5x5Bedurt
    thFl4kzzMjhv7UlAxOBz4vPRXQMYZm6skstaNA0N2ZkZEKrpjBUX5624wA8G4zEpHd89Fg
    GFq+lpZWo+FobnIjGR6ga/tKZzqv1DP/krPF6lxtDnv2fFXQnF/Rd3AO3J7hcv9ukN2DGp
    6X6cee47q62i28Js3X7EW25mKWln6wdpQFZrygm5UqF3Et9YHPkeUlJ93E5PA4EhBriP3U
    EpsMUFUs9Fu218oaklx0T0LNWB02N/m51/dfvVtVhJBM7n1n/QsabKldxETUmAMJzmAzUR
    /CvzoYL1f2qH8D4MbxYT8IHdpFBAqjrnQ6FGrEZhJFfzUk9/ppwqlWpnrHfao3S6uVW9YY
    HpgZCmZMGM9109dFSfc/zw9cOXhkSEvi+Oh+wc+XAMszgXkC0Q4yRjMa/Ixw
X-ME-Proxy: <xmx:IWKqalGy5UwN3dERqcF5wh-HOjsurkMWseYEPvaYWW1bljPf7Dtqrw>
    <xmx:IWKqakllbckvBo5fT5n15aA40j1CNMp2KBM38-MDvX6QQJz58ttoQw>
    <xmx:IWKqaslRCFeXXeoGfQuaNIfFri1gGkyoDD-QCe_iIY0no684E6XTpg>
    <xmx:IWKqahWI8IVS0_u8xZP2hD_G1br1QqouGX5Ao258nR2iBaFQkuE-LQ>
    <xmx:ImKqapvzTR4fQikr-neJK1KScQ6S-m_OTLvv01tiftv_5KZOVvXPcysl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:32:17 -0400 (EDT)
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
Subject: [PATCH v3 12/12] mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Wed, 16 Sep 2026 10:31:39 +0100
Message-ID: <20260916093145.4022188-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2217110000B
X-Stat-Signature: xutne6dzoaytwa1kz8ehipmhtmjwrxfx
X-HE-Tag: 1789551139-101844
X-HE-Meta: U2FsdGVkX19fOYq3Y3Hc9w5IwTz3lQ7GE85ygMK7gEn+DGo0an0Cy6CjbQWO4fuCWyO22I7M9PCCWayCWN1WQ0HRDpi4oLw6KQkuxVp5OHQzQt5vQdO4z3We7weTpHfObBd5S9250jkIUv+NJueezGui/J6N/pXfCttbcI3lf64OWexYY+MxrN5gRxj9iGT+gt6eKnP/f/E+zqbt6zEMPDDJ+gSnCiXb92BtBmlfYoCDWahb6jNvLaQdALRFbr2Grk//+ywZuGzmQCqTmks3vL43m8fLagxQ6+qvaDE7dVgc5Fnc7xh82vI2bKzz5SJYXxiIBy+xKUqwAwVGOsEbvFdMFQNC2U0cBU5XZ+u3sqnDLxxwacfOXOMnh3KyW1G3mlE57KUbg1qddc4fxR4KE3pujuX1M4Q1DuAIvg6lxiQXQZnJLFq74X60E2CHrGlRQMNkv4QbS23HNztRap6QRgSN2Xb+VAw7EsscTcLHYr5zIyu2Fa/AK2U1kZS9S3B4UGtyv6zkIfOkIpbNRcBkcD4NLZYfHyzNHgK5edk3xCocbo9pZNK8WrKVWRAS/sh+jMPwbM9R8u/HPiHBfz4hePfw5gF+t3urbxUg3sfUmfRb6RkxyHVd3s5J8TuBPlFLcWWpeIc7lMGX0TMe+pgZ6xdpXo03T/5qMgExs9jVhYVhld7VU/P06pBQaeYVikaixOCrxf9Pzr3EojRfsAuQOscUtyUtSo2mIh0Pti46NiGdDT/WvD6TxAvM1Vf6nUc7Kvkum7QI021eeGo2H8+f4fCcl8AEFh/q/Xh0h768Pu6Dp3WAvkw+VdOPjKZ5aJN1SOCfHeH4l6llUnlHki6m+WeuEuvcfENHhl6vQKvWjk7mYjG4q73mlCbenwkxyNtj84OcWFWclYzIrTyIeQUWS0Tw05/SLaHvwKDyZRfQLQScRq860WbIP+nESkWfjFDqjqEUcISOPw0IXg9j3r4
 fsJrJIEE
 tQ3rb6atnV0xZPk5gEgq6KpcjAzlfH5mzDmU7HcLeG8f2n3F2aNW0Ukl1DRD24PGgdqYPQ816OG8CU3X6LWukmj+TiXxz0Avjsshux/y0YqTdajPYnG5+8kh5fMZpQF9N4iPm8tceysM0QRXF2KX29efrrnYaFUoCF/+QrVZOMBlwN+j+RbCmaRaU2bzK8wHBYJW6Pn8dQ+CTTE781PLi7qRfmTgT8djG7IFlg92dUcuoto3gqRc2Jwn1nphPy4T0z69h0emGRUxqckmH1490rbrQK5i4Lq+sxk6bVq1tumM3rspd7hLKLTjHUR+c8bcgKLqCrL3SV58J3RAR7IKPpgfQpuGugTFiCeIzAeRfK0f5KgLTaoogeeLtezyLy90fyU10U08NXhNqniM9m+c6CRzoYUTzFo+lp86TZ4+pHh9OsbALqN7QSrbJ9+RZt4PU58ITMP8txdvrLlYBa8p/px5D+oJHdX4rvxSgnDk7+AGDCOOk0bRdViNNCA==
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
 mm/khugepaged.c         | 158 +------------------------------------
 mm/madvise.c            | 169 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 169 insertions(+), 167 deletions(-)

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
index d4e0674a05d7..2a10a30055c6 100644
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
@@ -2822,9 +2807,8 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
  * and with it the VMA and anything derived under it.  The run revalidates for
  * itself rather than trusting what the scan saw.
  */
-enum scan_result collapse_run_pmd(struct mm_struct *mm,
-		unsigned long addr, enum scan_result result,
-		struct collapse_control *cc)
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
@@ -3198,141 +3182,3 @@ bool current_is_khugepaged(void)
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
-		/* Nothing to do here, and the lock is still ours */
-		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
-			goto tally;
-
-		/* The collapse takes its own locks, so give this up */
-		mmap_read_unlock(mm);
-		*lock_dropped = true;
-		vma = NULL;
-
-		result = collapse_run_pmd(mm, addr, result, cc);
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
index 963337f93a7a..33bcd390ce43 100644
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
+		/* Nothing to do here, and the lock is still ours */
+		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+			goto tally;
+
+		/* The collapse takes its own locks, so give this up */
+		mmap_read_unlock(mm);
+		mark_mmap_lock_dropped(madv_behavior);
+		vma = NULL;
+
+		result = collapse_run_pmd(mm, addr, result, cc);
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


