Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2231EFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C176B00AC; Sun, 26 Apr 2026 17:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C4A6B00AE; Sun, 26 Apr 2026 17:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE0D6B00AF; Sun, 26 Apr 2026 17:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5767B6B00AC
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D7FD1405A2
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:12 +0000 (UTC)
X-FDA: 84702045624.17.DAE5394
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id E76AF40002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KaY0WGEJ;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5XFq6evYUr+s+QSCea6SglT5emqQpzsUniObvQ6PpU=;
	b=T5ZwfZ6V1YnXYMLE+tDgl1/akjcd+fDu7BkowZCRHm8+9+8z8Qtn3My7bntTJIXbhuZx86
	a5hm5arKMw7goJ6HrSStJhyLbmqfYZ4R7CuSU2juH4LV/GXTkAgM0PkTI0f68g6dJKor0x
	6JPzMJfd1X8zEpIWKDJsYdXpemMdWoE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KaY0WGEJ;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240090; a=rsa-sha256;
	cv=none;
	b=lQ9MR2PeC25SJnipk89mYKOeR3JhzlPW9SVkLi2fg/AxPkZcw6wGv09DSOJjdgZAcxCVj1
	k359cBn8snxu4C+MkXALsQqAo0r7NBjm7Z+0aaEjXdt7VGjmEP7mXM0b2LrS3o3LWsyk15
	a35QSd7nxoFjvF+6Ix2koJDQ9p+6EP8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d5XFq6evYUr+s+QSCea6SglT5emqQpzsUniObvQ6PpU=;
	b=KaY0WGEJFljGuHRBYU9eDutqJJgff7cMyGeCiVXimEKsFTdHKh6EYB4gSk0FS13ot398rI
	I3YSkop2vqt/yhQUfFuXX8sCLr6u3CwCKKO+gRHG4xy8f7PvjHWuFJKXYD4VnhLgHBjYDk
	aGJ3rt3sC4c18FchbUEqr8YUZp51c1s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127--IVMWe2ZNcq0wwJTWYYcDA-1; Sun, 26 Apr 2026 17:48:08 -0400
X-MC-Unique: -IVMWe2ZNcq0wwJTWYYcDA-1
X-Mimecast-MFC-AGG-ID: -IVMWe2ZNcq0wwJTWYYcDA_1777240087
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7a5b9678so7456818f8f.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240087; x=1777844887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5XFq6evYUr+s+QSCea6SglT5emqQpzsUniObvQ6PpU=;
        b=roAwpqojYrRTk+nH2pU9QynAEn+toSrhc2UUQhUodwGQs/MmaEZCb8Xmp+vTl3VRhz
         X4wTv+GGVnrjc+k+yI3UMyfWCuS9jWQHd7TW4IN3FZyh/0UGQpCqos4HyxuuXP1PHHAm
         1D89QJV0IMD2QkEsMGaCstrf9k0EsY1qJCmPuwe4WtAh/EAMm8SDs5NK+epjqfkKBNfq
         nG8o8zoNyHeP9BzoofBcij6EYksHrOS73iBtgfBT6fR9Ci4xYUJTL9MrbZQYRxg+QY9I
         Fxdvc0/63yZjQqSoCZMGsDKNRWsC0pdAZDbxUZvid8NS8w4NSmDmyAFmD558Sfb1ZEHQ
         iBCw==
X-Forwarded-Encrypted: i=1; AFNElJ/lB685J2E+z2R9Kx0l0FJwUYqxrl0IAOeMqFVL+l0l8QK/kadCkbsXk29zSI0Qa5oabdj2xAuTqw==@kvack.org
X-Gm-Message-State: AOJu0YxGcfwUYavts+66gThtplpP+6r0yF+/3uHO3AAsVv15TuiZ0J61
	FJG/VkJbARRfBrFR4SU8zmrt0KSsWW/DJlS3R49fHa5OzT8kwsnIKekmfFK+fBgzFQytZGQ3aDu
	VPQoemxeW5ZmmpHy/8i/1bSVnTG7/10KOHrgL6FuKBoJy/76J9Hr7
X-Gm-Gg: AeBDieuWg9AR9GVczqbhLoBtoJ9Iv48UCRUR9e250AVsV1Xq5bqSmWImU37wt/aqgIa
	6Ae7LpcBJc22oyPqASgkrVG/JuoOzWmgvkzPpgJ2tbUMwaaEgyRKrQa+TQIIQObXT7KEE5SaE6q
	KTJ2gdrl1JWt2zUwHLXhiLDuCs8cyZWE07lNssNBPsxxnBWO5z/wWMKIqIvhMMt0Pxi/4v/aule
	LC+opxXgTbIuhR5seranx8F4Cu2NxsSsZww6HBwHRljF1AQkq6YwHxYjzR2P0yrDZYX8cCor1he
	KWZ/gCCDtlKMoOs2p7jJleRCCKUZdqZDNv61vWGb970PWL5OFyV50EHykhjg+JEbuyKyba6zP7i
	EMXHmgz7kMbBgeEByq9Tkg2gBHFNUHAfx4GaooYYckGirYTHF4QKFWJDD
X-Received: by 2002:a05:600c:1f94:b0:489:1c2d:211e with SMTP id 5b1f17b1804b1-4891c2d2213mr444173025e9.5.1777240086702;
        Sun, 26 Apr 2026 14:48:06 -0700 (PDT)
X-Received: by 2002:a05:600c:1f94:b0:489:1c2d:211e with SMTP id 5b1f17b1804b1-4891c2d2213mr444172595e9.5.1777240086146;
        Sun, 26 Apr 2026 14:48:06 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a341sm81500119f8f.24.2026.04.26.14.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:05 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:03 -0400
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
Subject: [PATCH RFC v4 10/22] mm: hugetlb: use __GFP_ZERO and skip zeroing
 for zeroed pages
Message-ID: <dc4e2fe5bab515278cb9d69a21a07e7faa8bec40.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F69Dn_zmh_SJ8RHA7fDjviKLcug844HxlLGCQggn0wM_1777240087
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: uj31m451fafte8g7dfi3t8gbwuso19jf
X-Rspamd-Queue-Id: E76AF40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777240089-686716
X-HE-Meta: U2FsdGVkX1/bZkm0Kvfj+MdSpKG80vzMpb2gkjOb8nFHTrm91IpMltCyuuX9dgQ2yTjjeJsYuc5DqZAub1mx6phazgtHiEYJbZvhTfF1zdQoWcrYk4yt0bSbQQvIQMk3lU3/1ucecgFzAVoA8YN385PP/eGcT0mSlTCh8TQ6T9GIQIocsZZNUH983eYpCbV6CeBq242YAlpTXqlpkXZ6YmGETrN8o8rVz4TPOLYYLki+H9tOLc+fFo25ajO+/ckb/MlUrZ9R/hzNcWJAQluNgZysmqxchlQCOu7l2XwAHpFJxtrNPV+JH2hyY29XZM9v7ATA3fT/MXU01NQEq7R8IoTgF/08+bmKR2zr9i0/9FI3BwcKJHTu+8SmFjpn836pjfoQmvoLLIB0pgRmugCk+LPn7EGP41Hsra6yffzKZiUJv2BOBJiYI3H8Nag6HVagS8bKbKuIA7Y9OdxaRfg2wypZAJg0t8AZQiT8OIJSIxISJyo6b0XamdVkiHTY9iOETDLUJgpkRDo7UyAO5PtI8ElzFKYkpvVwitdKtJvh9v4kFG2UmqlqS5RxQvxIDHjjsL5Hpq6vX7y2uRdg/qhKmuOb23RO9WzW2vQvyUJqlPHAz56YFhAeWElL/pYAQV+iBkhW9KLclrwoPYkR90wUvVaLB9Ti6XViG9QsrgOFnOSI1A6EABlVvpma7s1YzqkhrjEeP3XZjsjj4ehUVOqTDDQ6Rx68m4mv9nP1z0moewCc8TNrjGZiK3rkWPkd5O+vDMr6ysHZ0ArJghcij7dFX8qxN1VTYBaJOf3aZMQH/H5iQCVIMbcj6tZkAoqWwldzzw3kuChRcN+7g5wMlKsWn0tpO2GANwtyAjyFtFxM3uFTsiTklJXDOuQZg49RFBY+he63sRQfDKQRhtQr32HkiLqALeOD7GRUyyDB9IWbif1doJb/IQzxSuLtQHEbuD9Vq6GO5OSZmk7zsW07NNx
 b6+ebwic
 KfUQlR4WxrRoMBsgO9d+91aewf/tVLYhICQz87uYUaB1ljLZH1R5HHSqruvreJbOpt1EPvfbC8SSE5bf6WjaiwAh3VTqLN1CSE2FORX0Kx/8dHAM5Fbz8wZXVQJu1fXnW1Tr+LsrXh+3rJaXW/l9MZUo1R0OkoScmCk7R40TER39H1b4BU2kg1jcNXXg/RfwPLztYxkeUyI3mf4en5qJTW1SkaXUQove9+2XD5N6Zyr0WtW2UkWIoGRJvAEDZuXSia09XYh0y+aPHlZjvmYC/INZihL4803sG1wVPJb8F/Q1jVr6nHuHBwqLbJbwJL1WU7APvsNNWkyx5a208kowLMXB0D0hzGb9fdJzuKS8+W3N3QIsVP9pBs2VzvQ==
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


