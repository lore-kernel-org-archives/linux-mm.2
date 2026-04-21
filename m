Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EE9F94CB3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA126B009B; Tue, 21 Apr 2026 18:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AFD6B009D; Tue, 21 Apr 2026 18:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04AFE6B009E; Tue, 21 Apr 2026 18:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E311B6B009B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB4E91A134B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:45 +0000 (UTC)
X-FDA: 84683935770.10.1C55B08
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76C3AC0018
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WqSgCtWh;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5XFq6evYUr+s+QSCea6SglT5emqQpzsUniObvQ6PpU=;
	b=5hxesBKTte0NB41tLXjbqkWDkx4YCC0Hnb8MERLqR7yKV80qExs1Req10X/9TnN/LuTkdE
	nNpMoliwvFqPOErlQ8aDsYv7rDPk9vBlURQ5VNiWDr1+luslGpaIxdHYxDs1/uhvQes4XU
	qxLCqoYbGH23J8LNDBcEgtLz0yCHgjU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WqSgCtWh;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808903; a=rsa-sha256;
	cv=none;
	b=pDip8uI6WAadpPpkiH0r2ba+fZvIoySfO250TfSUHohsYoyHRsQ+JcdI9E4dfwpoL4Sttr
	9j/CwQT9r4wUr3gyrU4bZXycVfv8f7vW7tChjvXEC9iNr889bGbQpCB26pZgP0jMYml9xK
	6BvBVbwnJsxlgotcw5DzSJvdsEyhmEg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d5XFq6evYUr+s+QSCea6SglT5emqQpzsUniObvQ6PpU=;
	b=WqSgCtWh2a3aUDKJtXi5cv0W1SRbV8bpBm//nsplSHOxV/e9V1RgQvYFUPB5uu6+6CtxRs
	4lSZwPV7omYYIfuuvO8HdXYrS05QCVesji1I3LdCaSwW3W7y5k/+b7xcihl88Y9CgZgF+T
	IdM5oKfgZnF3+k+Dkkg2cwHeEk2zh1w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-usvH5hjCOvGaxJxojIxkbw-1; Tue, 21 Apr 2026 18:01:41 -0400
X-MC-Unique: usvH5hjCOvGaxJxojIxkbw-1
X-Mimecast-MFC-AGG-ID: usvH5hjCOvGaxJxojIxkbw_1776808900
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48378df3469so31088225e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808900; x=1777413700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5XFq6evYUr+s+QSCea6SglT5emqQpzsUniObvQ6PpU=;
        b=J5GtDmEtBhVfBGQd0hqsq2D3DKkzpaJYwfnn34SQd1qH+nC6beyRNU3ZJqIXkYLrPm
         nesBKCUd4QhfSxaAXjdKewZcbgHWsUfbOunNDXlTzvdaBVhRZIMHSv6FUIhu00BQ8weI
         lZic+5ySC9CnsOUWJR6/6crIFKHOaoyWt9NB52TMd0QbsRNp8q4jDFhiHc+0VcZtGJNw
         c5zwlECmmpVQel0qmxbeyS9fAqsfeU08Sb6taB5g0qQfT4BJCbZWlWspkxWtHW0cvi0w
         zklBaS6siiNNJPt4Y5nB4NeIts7zCQMhkadCOmhXsRcNgjss5glsBXaWL4jOpwAsQMoY
         FWRA==
X-Forwarded-Encrypted: i=1; AFNElJ/ZD+sKTbGxCQ7tt668mdEBQl9VyeWfGa+wQZcNiS6eDonsd18sulR+PHxbHooKMKKKqCMRd5WyVg==@kvack.org
X-Gm-Message-State: AOJu0Yw7Rp0L1b4fz1abmSanO/jfiT6FWl95+/28zEpmj6TSbis9QabS
	d1+rJ0EidOStidr7kmDg3AhrkKD+8eNbLgIqMqLgnjNHq70y8X+1I9vspdU+nvN3Sy/Fd8VpdfM
	5HCpR2hZfH4pBjhhdlJ/7+58acSrDMULzpp7CIGTZP75AnH0ND+E/
X-Gm-Gg: AeBDievu68xNn0zTKl3xGXWmIVqZfJngtmhNovAQpv7S6cXGZPsQokHVLy9xNc7glko
	hkVBjDCHuq7y2mEBfFZsqPaRdL+q7hG3N1VTUMsWZ4YbPoOXwgXs3CrPJGLZ4we6JlO89/AXmQL
	MT5I3488n/SMo1lfFY+NKZj9Td3IeGgZ9cAGD6xPOI7GlAbMnLZJDm7eevGwfYungFVBlfCMvJ6
	I3L0e0oC9wnhmJ93+74dPbXQIsuaFlzSRewW/pGrllUaC/ISjq+fvVxbZE2NBwO/9MSaNFGmkAR
	3eLWXA7+Z+jNRuhLFCcsJGYUmkrUemRACG5Pr+5cmctG0CSZEVXlkcJ/CJheSQKEEk1b0pEYU+v
	1xt3sLOtHbrESBQD+SP2wpIhYoMFEG1YEXER2zckZ+tgxE1toeVHjqA==
X-Received: by 2002:a05:600c:3ba0:b0:486:faa8:9e4 with SMTP id 5b1f17b1804b1-488fb8b91a7mr256828925e9.12.1776808900211;
        Tue, 21 Apr 2026 15:01:40 -0700 (PDT)
X-Received: by 2002:a05:600c:3ba0:b0:486:faa8:9e4 with SMTP id 5b1f17b1804b1-488fb8b91a7mr256828685e9.12.1776808899635;
        Tue, 21 Apr 2026 15:01:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891bba6276sm93953895e9.0.2026.04.21.15.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:39 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH RFC v3 08/19] mm: hugetlb: use __GFP_ZERO and skip zeroing
 for zeroed pages
Message-ID: <6897aec7727120849077661a33248fa2d58b4fe5.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6CZoegPssu36fozb4Wcd0difA3ryofeuyb7my2eRiwQ_1776808900
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76C3AC0018
X-Stat-Signature: x9hs97fcbbioe7wq4ekt6se16xqwm6qz
X-Rspam-User: 
X-HE-Tag: 1776808903-424578
X-HE-Meta: U2FsdGVkX18irb8sG3oI9rTh2gdOr1EkcJjkQxEMfAC0QHY1hS6/1rY/e/Na0EDE2j15+ZWdjhTrQe3pT9Jq2zo5m5r5LdU6JYooF40Kk7szRtvEUoGjeBLA8iaFTrSyddYPeyb1TH2tXQOzz/DhQE6uiGwfrIvCXXFAIvqPXvat4SO2d0EtIM0F11mUG/5CxNbIJVUW8CYmS/TKq3vINWPYsoUYoheWcTemXZbBFH4ODOXBtDIw1Xh6YJKR7w2TT+sZjHz1kfwSNQLJm5W1NGH7GLgDniMFtXUZ22P9k4pDQ7GVtAOhkqFH2YL+IeKX8YXG8bpnmXyB8VElAg4F+mYSm7LDH2bR3XU5KN74jT7feakDbYPvsmeP1xaFcHsli93CJZIUrAQx4qElmd3LXIChq3FyFTlTK1w03RDcSVv96eXnaG4DGH59wVf3Ks2twQ5R+Ujf+IBRrE6/4MYSUAQ7IfhwyxTioGkC8eZ5F+fg6vq4K805ZVVT6I6IUYgx6Gv2Q0onhVgbq4JpvRCLH1PJul6zDw2WkcbH1ak0CM0wuCEfPdDGO6Q3p2Yf7yxpINCsK0dlhNe+KDnPPucFtwQF5v7ZyZT3oTEmnPsqJm2UBl77TfXMTkLCYpaO+ot0wrJry6FllOBY6Yh2g+NQEtXjln4zPPqCNk1SPLZJgccB66xWfiaVEN5oiUFDuGGhfqxfYWP0g97xB5pWbK8WLjOixOCyK4c6g9dhJM1w+H0x2vzKYltXbIxSCDSyFqCBiz8cZMA+O0ymzdIOYNjf8cQ0iQj8joVBbMhlUIsCQXNhOOnAZuTGyz9phBBfdyoV29E1eERTWJyI481Rm4E9jihYRY3JqAdlBIdHMg74rH5I3Me/W87MLJgFEbwGFNkYPMg6aguwBP2uQIlpc9iiZ78wxH+4KZT7OFwLpbT8/GoYu6fOc0wpix2DPT+7aPnIriatQNYUGVuy6RPEUvs
 MHQt/HfL
 0HSdi4o1kVNNVCo7EPDVqrFQeCbsI8DBX/YmQnjGDCLiQ5B1oYjD+S91882YnDDCZl0yZZ3Bq7OZTa1MsNsrnZTICzusUMqh0P9ntHzZdY7FbnP4CdQkVheEG4IGnMPr6lNMAb6JEzb930IIwT0oElwCEh+R73S6Xv2NYCViOrQIBVTDNuIoMJC/TGHvzIj+PsfodhB0OBexQC4xEI0Kx/aMzfZtbdgv9xVQcLqNVWKZ6KkswrQJlSo6NOFwX5x//6LYx4cHq1+3pnlsgiePYRZJH3oWgO4SQaPt4C7hM59FldvjCCzKosek5213NukMAEnR+ZMn6hkF4Ppd6IgEtRso4oD4/FBxNZLvu+q6DNAWKf52JyemjnEPnvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the hugetlb fault and fallocate paths to use __GFP_ZERO.
For pages allocated from the buddy allocator, post_alloc_hook()
handles zeroing (with zeroed skip when the host already zeroed
the page).

Hugetlb surplus pages need special handling because they can be
pre-allocated into the pool during mmap (by hugetlb_acct_memory)
before any page fault.  Pool pages are kept around and may need
zeroing long after buddy allocation, so PG_zeroed (consumed at
allocation time) cannot track their state.

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
---
 fs/hugetlbfs/inode.c    | 10 ++++++--
 include/linux/hugetlb.h |  8 ++++--
 mm/hugetlb.c            | 54 ++++++++++++++++++++++++++++++++---------
 3 files changed, 56 insertions(+), 16 deletions(-)

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
index de8361b503d2..4f0ed01f5b13 100644
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
@@ -5793,7 +5813,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, false);
+		{
+		bool zeroed;
+
+		folio = alloc_hugetlb_folio(vma, vmf->address, false,
+					   __GFP_ZERO, &zeroed);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -5813,9 +5837,15 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
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
+		}
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = hugetlb_add_to_page_cache(folio, mapping,
@@ -6252,7 +6282,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
@@ -6299,7 +6329,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
MST


