Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A52CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7665D6B00C8; Thu,  7 May 2026 18:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716CA6B00CA; Thu,  7 May 2026 18:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605D66B00CB; Thu,  7 May 2026 18:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51DAA6B00C8
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15D30160669
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:07 +0000 (UTC)
X-FDA: 84742050414.07.67085AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id BF5F780003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oq64O1t8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqwX2bUTal2ZUsYHM753A+5S3P8U5GEJZpwze5+wO1I=;
	b=n2SE4w2spc4rVVMKCuOZunZrnb7xB3NLuuE9jAbx+s9OnjvhqPyHOKQd9i2e/3PGr0RxZq
	WOqGiRpbrGB4SaatpOKBNWNfWdEa/w1yqiaiw5fCtfSqvH3J+TO+S1+i5eQ399Nc8PwkxG
	cyqwpEwVsjgmYXipEeSMz57fDag2c4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192584; a=rsa-sha256;
	cv=none;
	b=7JsuOKtvgX9QAoASOm3TBbKNmE8kHl1zZZ/B6OEYZu7zv+AWu+qT3IBLhJXK4xoa25jLBf
	aCL05eywa3dGEMFJGXvlvUirIQLwKg9w9TCtef34zU2jLlUi6FR1D8V1/YGyO6TLjyQL4r
	SAbwA2WbKM95PqyscpAv7v/bJNNv13k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oq64O1t8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cqwX2bUTal2ZUsYHM753A+5S3P8U5GEJZpwze5+wO1I=;
	b=Oq64O1t8o7yysZ5oQ8ey61FkHIBW4wnGse1gNmk4XooQM6m1tUr6l7J5524MszA3B3VQmA
	VDY8gk41Ypo/4GtHMlGaxnN/crY3qpLppssI5vk7qaf4mCMSvhM7v2KZLSxxc4pLdk1qn0
	XSSfNDuG/IDVRQE95cnsWM1HTjRm1hA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-SH_2wMlbNV6DfUO6REuxCg-1; Thu, 07 May 2026 18:23:02 -0400
X-MC-Unique: SH_2wMlbNV6DfUO6REuxCg-1
X-Mimecast-MFC-AGG-ID: SH_2wMlbNV6DfUO6REuxCg_1778192581
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48a5952c635so13460695e9.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192581; x=1778797381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cqwX2bUTal2ZUsYHM753A+5S3P8U5GEJZpwze5+wO1I=;
        b=HFaJ0Ngz1Mg1UdLoMK6VrBqiFSaJSH5zafFXlvyqn6NIQEarTcHkvKQ4HVGNCD64aY
         Pp+GasKUGct5iibt/ibfDqHtzRCYdMSnNWitkDNN/uJgrY8V8t67SJF5eYIngJDIKYIT
         CrCaChLhfjBE82b/QJ23BsBK2VO5xt5htPLVvGN0xW4lBnGyf+X5nnQUPcVW7OJSJcsm
         yZyCRgIi53tWkr0YOqyGHizjlryN+Pstf+ryr5tG5ba0fVoAJv9op5u10dZoIIn8zD+G
         +TroWy9mbT4Cis881FY2/ALsBkOa2avUWHBGGRqcrfDUKLtiaTiL3ouvAallFaR5X2z0
         bclQ==
X-Forwarded-Encrypted: i=1; AFNElJ8maIOeNTif+yQJJKvd9S1kr98OEIxFIDJnCSkyYiyPZ+p0ILeqpofqRXtBmwHb2fiPCQpSNTsKlA==@kvack.org
X-Gm-Message-State: AOJu0YzqJ1KKRl/uQPJ5Vlrt6CafWTXvknXjKeZW7Kk4ecDq4PH10nyw
	B76ktoES0YZH+GeRja5lVQR6PZMB6FCzTrEAVFsJ41p9mO1JPWv32fkcd8WwR69pqvw61P+FwFr
	LMIrsqpsdGdhsg4OCKjT53IFrnCVuG9ULKTfpso8pfN1zC5WYY99Y
X-Gm-Gg: AeBDiesoCJXgeQ8oFmsqQ/swBDPCyPMFE0gah2dwaBMgR9F5mW58pSxFSTh/xC+0HG4
	KWoSjy7ui/ap6gnz4kK8WHgbREN0O5G+oW4RXmdtI+LXfKo77GEwJnfdB6v4eGRcXNbzqtORMoZ
	DBaHnp6X8cqLDUC0Hb0Ecn8ULyx/H1uB/mdpQp/cBUPWBob67H/9rDZ44docIlnG5cJy0jhTRvo
	PgN5RL8JUconS4GVv//ZhW2cOHYEPch+bSgLBi7Lv5sl6xkZf7JuMOftQq9O3Ks1qDoKg8kT2h9
	0BVLk/2Vds+L9FMCSmbqBULwDVsgxx4AWE4CwWe1J4z7B+vQ1CNEI82mgmPPGcuKiCFi7bCKLqM
	3QKYxa9tSGzIX7YuXHJkxlPBhjk2clY7tZOMd2bm9
X-Received: by 2002:a05:600c:1e8a:b0:488:fd7e:1063 with SMTP id 5b1f17b1804b1-48e51f4cdcdmr152031045e9.29.1778192581284;
        Thu, 07 May 2026 15:23:01 -0700 (PDT)
X-Received: by 2002:a05:600c:1e8a:b0:488:fd7e:1063 with SMTP id 5b1f17b1804b1-48e51f4cdcdmr152030715e9.29.1778192580730;
        Thu, 07 May 2026 15:23:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e67349ddbsm3318515e9.9.2026.05.07.15.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:00 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH v5 11/28] mm: hugetlb: use __GFP_ZERO and skip zeroing for
 zeroed pages
Message-ID: <23cda0a1cc4103c3f5f187749d5b5b2934d85821.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cDJPls8_XmEVisKHnued4San3Zj--kOTyhNBYu7kI9c_1778192581
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF5F780003
X-Stat-Signature: c5o4c45deze8h35d9z6jux96zhuatryn
X-Rspam-User: 
X-HE-Tag: 1778192584-350312
X-HE-Meta: U2FsdGVkX1+Duxem7LSIJuxk3/GM5yyQ4ne7oYK5BOgLGWDz95QWu/VNhJtNhebQeBXKHh07sURt1mxT8uFI8eUOPGI9gbNDOzOsZ6S/kgouHRk5sdtkk6AkMceROOyDc6FdMptNo+4ikf9Q396jtVxFgr5ccd8q1QidM7AWf0GiwYa4nyqN5GxRkotgVrfUy4srvDtG3EZvIWNlkPwdYKsBtFxya3+/qflPsQZohusMK2ZoyhKeaCdKycBeV3I/4GSgYn1XUPyRMzzVdS+jCdqKaGsmbda6VoA3sJpiGlfLJq+AWw8Tdouo/EEr5dlkXpDAWrAMfNV5bEfbRZH7Jz+VIQUfElAjS8VAIGDLpZq6zj+i706fHP834CGmz4fN5Bec3NEeU8/qFbI6R5XrW7Gy0IoboWDvDzpvx4adBhVozgVt1GOCN49Ea1ur7UMaYEw98zeVeQU8MocYr0WkDy/OV3fCtKbGJ9Vy6N1nfI37H8bwS50/tFVwPBgh+tpxNY4E+f/ud9Ms0qekmR94I9o9YmBguZWXhHjpq4xMRhA2SnvBsar2+iUuVQwRss+aHR+77ne7dmPejszUctjGsLyXSz/d7emb80AsuQaO5I+VQeM+Alph5DjMtFIuUxY4E/JZcbQn6AkEeQOlS1L63jzHylbddg4QgxdGJx9n4vJfzLO5XyqOqxjLb+5WDXw1ocuu1GNpQpDYQPYzoOTP6wLQoS8pYNJGPqd8GfqhH1jXHLHR/UOKdD3QFzZ/KcDm+YyyYTyJxryX/BNpnQh7C1JlZnzXGhZ7tnueMcqL9IB+qr9dIS3Ck6K4hU7cf0CMIUKvGIp1NQq1M93S+NcFWUzc2G1WIXXdLDb7GSXgLP6H24FLtwdtSNEIQtdzz4vrgBjVFN/7LO0h5Bgb9Hy7A3wnVzridZbNdOmQcHzmayXA+dZHEcqnguoGXj1PGcbKOcF0KBehdxW8vHO5nuJ
 JsApwkEz
 d3JyGwSjduebmhklEisJB50f5jpDcLhdJMQqFWhgfxkU+mVB5P8dAXgs/WkPukEtNt0IZEmu3U5KsgDQZJR0uNG9p4/hzO6O4dGs36H3c8oFopoxVxoR5WelaQ6P5ImNkchdCUuWb61y2NfZMapEHhQ9mCgFuGPu+galnPEhE3OrKmC1hgAVAJhlbjT53kEq68TkdCK17pQTIPkii30S5SM67CdSjOFXQ6135YnUhfl8HHN7WID+KM9OSroZ7JtRYM/jvOMZBdRYUjOBAn0nr+1J5HIl2l9Th0xqW2qTGAlJJjB5sJnVvVcWKvT8d8gTErH/mgBH0aI3SaU0nJLKk4hnkO9ofyjYL3x29jbKawMYIbns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the hugetlb fault and fallocate paths to use __GFP_ZERO.
For pages allocated from the buddy allocator, post_alloc_hook()
handles zeroing.

Hugetlb surplus pages need special handling because they can be
pre-allocated into the pool during mmap (by hugetlb_acct_memory)
before any page fault.  Pool pages are kept around and may need
zeroing long after buddy allocation, so a buddy-level zeroed
hint (consumed at allocation time) cannot track their state.

Add a bool *zeroed output parameter to alloc_hugetlb_folio()
so callers know whether the page needs zeroing.  Buddy-allocated
pages are always zeroed (zeroed by post_alloc_hook).  Pool
pages use a new HPG_zeroed flag to track whether the page is
known-zero (freshly buddy-allocated, never mapped to userspace).
The flag is set in alloc_surplus_hugetlb_folio() after buddy
allocation and cleared in free_huge_folio() when a user-mapped
page returns to the pool.

Callers that do not need zeroing (CoW, migration) pass NULL for
zeroed and 0 for gfp.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 fs/hugetlbfs/inode.c    | 10 ++++++--
 include/linux/hugetlb.h |  8 +++++--
 mm/hugetlb.c            | 52 ++++++++++++++++++++++++++++++-----------
 3 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..d5d570d6eff4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -822,14 +822,20 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
-		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
+		{
+		bool zeroed;
+
+		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false,
+					   __GFP_ZERO, &zeroed);
 		if (IS_ERR(folio)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, addr);
+		if (!zeroed)
+			folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
+		}
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..094714c607f9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -598,6 +598,7 @@ enum hugetlb_page_flags {
 	HPG_vmemmap_optimized,
 	HPG_raw_hwp_unreliable,
 	HPG_cma,
+	HPG_zeroed,
 	__NR_HPAGEFLAGS,
 };
 
@@ -658,6 +659,7 @@ HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
 HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
+HPAGEFLAG(Zeroed, zeroed)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
@@ -705,7 +707,8 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				unsigned long addr, bool cow_from_owner);
+				unsigned long addr, bool cow_from_owner,
+				gfp_t gfp, bool *zeroed);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
@@ -1117,7 +1120,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
-					   bool cow_from_owner)
+					   bool cow_from_owner,
+					   gfp_t gfp, bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index de8361b503d2..b5bc2a9f5022 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1744,6 +1744,9 @@ void free_huge_folio(struct folio *folio)
 	int nid = folio_nid(folio);
 	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
 	bool restore_reserve;
+
+	/* Page was mapped to userspace; no longer known-zero */
+	folio_clear_hugetlb_zeroed(folio);
 	unsigned long flags;
 
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -2146,6 +2149,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (!folio)
 		return NULL;
 
+	/* Mark as known-zero only if __GFP_ZERO was requested */
+	if (gfp_mask & __GFP_ZERO)
+		folio_set_hugetlb_zeroed(folio);
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2209,11 +2216,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
  */
 static
 struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr)
+		struct vm_area_struct *vma, unsigned long addr, gfp_t gfp)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
+	gfp_t gfp_mask = htlb_alloc_mask(h) | gfp;
 	int nid;
 	nodemask_t *nodemask;
 
@@ -2910,7 +2917,8 @@ typedef enum {
  * When it's set, the allocation will bypass all vma level reservations.
  */
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				    unsigned long addr, bool cow_from_owner)
+				    unsigned long addr, bool cow_from_owner,
+				    gfp_t gfp, bool *zeroed)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
@@ -2919,7 +2927,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	bool from_pool;
+
+	gfp |= htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
 
@@ -2987,13 +2997,15 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr, gfp);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
+		from_pool = false;
+	} else {
+		from_pool = true;
 	}
 
 	/*
@@ -3016,6 +3028,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	if (zeroed) {
+		if (from_pool)
+			*zeroed = folio_test_hugetlb_zeroed(folio);
+		else
+			*zeroed = true; /* buddy-allocated, zeroed by post_alloc_hook */
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -5004,7 +5024,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false, 0, NULL);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5533,7 +5553,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner, 0, NULL);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5727,7 +5747,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
-	bool new_folio, new_anon_folio = false;
+	bool new_folio, new_anon_folio = false, zeroed;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
@@ -5793,7 +5813,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, false);
+		folio = alloc_hugetlb_folio(vma, vmf->address, false,
+					   __GFP_ZERO, &zeroed);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -5813,7 +5834,12 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
+		/*
+		 * Buddy-allocated pages are zeroed in post_alloc_hook().
+		 * Pool pages bypass the allocator, zero them here.
+		 */
+		if (!zeroed)
+			folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
@@ -6252,7 +6278,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
@@ -6299,7 +6325,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
MST


