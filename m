Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490A8CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE116B00D4; Mon, 11 May 2026 05:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5BA6B00EB; Mon, 11 May 2026 05:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D766B00ED; Mon, 11 May 2026 05:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87C186B00D4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 509691606A0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:15 +0000 (UTC)
X-FDA: 84754549950.25.7C1F119
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0DAB98000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MRnFflQ4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
	b=SLfkfiUETTzgcOzXRgXysqPrBW0hBEW9Xkzi9UQUf6BSxc7atLyysFVMUZ9Baa2rbqlssF
	2Z8076SzAWEVf5yU40eUkD8zO7JUBfqPcY4KYahf+xez4FZ/yy0bKmDQ6PYwv1OR6cHDFE
	m3vbyKoan469fdXG95PhjaN9PAVEkZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490193; a=rsa-sha256;
	cv=none;
	b=MNfZqg8K2C4h8TB0S9xk4iQVQ6dW56TbNiHZeeJiegj6IYDh9oyuBap/MjVFXjstlExWfB
	blv6ZuOzXzVdnLKNY5lOWqBhM4I4RdBSBUBbmy8AH0fw+/mrupLNuU3vOGJmoSZI99dU6q
	/N4fU9gNVkN7HIA+MswS7Lk5XcDwtqs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MRnFflQ4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
	b=MRnFflQ41NOFzN1im9OlE2AfxSH/lXjRiAvZjlZl2D0IE44CpY5ac7EEZUMQZy3YFhioPY
	5VUw3ERYAGpgvzEZz/ev9Uu9BjAEe+SM5BbhuXJr+Qo/ZtyuuD0z3j7KRpR06m3qpxBIzv
	z00rWeZ7b20iLEJitf6mu02Zy5bfvrM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-BvaQvWoQO7G6noUi6qW3ig-1; Mon, 11 May 2026 05:03:10 -0400
X-MC-Unique: BvaQvWoQO7G6noUi6qW3ig-1
X-Mimecast-MFC-AGG-ID: BvaQvWoQO7G6noUi6qW3ig_1778490189
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488f973ddfeso28773725e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490189; x=1779094989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
        b=PUBGUwOe52A5xTARI7EmFmDc4d87huBqtcbDeFRoxDB3yuIUgBrcsCjezSr5T3VLXQ
         L5NQFY05qkP6inekym5EFRchNhwwp/mCYcFnuII1YavhoXE4wIZfSfYGAmOMxIxgSfER
         g+fv7rBWak2Nq3W/pV7NEoC7hbrOwD8IPzoieBwXak3V3hNYGbu9ikeZtjqVUwiNpjen
         HLe6PkiCGmwfmSUl03GxgoGtrr1wmN9cFwFXmpykxLKhZ208ZuPAlhoNKjVjn6659EPm
         mut6+3AbIboUb5ohgsNVxTIx+sFDEXtM9PgDsSwIPUm2TnIi38/tMzhz0Fy4OU+zTP2M
         NeZg==
X-Forwarded-Encrypted: i=1; AFNElJ+UUAOFodtg+JYWRhB7JXf8syEUwRPF5qrTPqbjr7o0hRj1eot/kuIxehAy/3/ElA7SgL5G29Afkw==@kvack.org
X-Gm-Message-State: AOJu0YxxQJbkT5ZWNIlRBmbw5g+f8Ze2fYd6DwYHDYMV04oGIX4+LuLe
	vwxiMbgaH1xOwSoc8tPvVQaZxmROgs3pK1wJ8GXivL2a84SvfJTzF5zx8uDsXbjTt/MgjrYWWEM
	1g7C4EZQp8wzTk8DNGIDCJ4RzJZrOKTdN6K/B2c33JBfnVZor/YRS
X-Gm-Gg: Acq92OFAGr+j2PAH0TxCnd7aY4uUI77Z6RmlbHQYbEwdJYSLyc8oQrbbifk8RYAj9nW
	tx86vi0QF1f7sVi4m9cJeUuUWFti1kCtWGiuDErNx5hFXzSAMgMnrN569s9fXygd9uYvI6Yj2KR
	lv24poTLMG2XWQihh7DhtPGxq9QR5y1kHzhYg8I02kVIdaE/vPbMcqvfy8TBzZ6zIbzewlmIZdr
	7HREhEoDjsPlyHmFlzfF78codHMM02y8HCc5Ai/RqmKVQy/1jI42gOfMX597KiCYuiP2ySuqhEK
	DGhPNchR81NBiqdB7YNn0ZGYMcboIOuclhCTiaJhM7gMuvGMzqO2BixK7zE3lEGO1lQ//2BxnyC
	tTG2DT7aAf/B07/TKNNRPHfzyzy01JXw2Jx+UPbVa
X-Received: by 2002:a05:600c:a110:b0:488:ae6c:42c6 with SMTP id 5b1f17b1804b1-48e51f2e8a3mr329714585e9.14.1778490188944;
        Mon, 11 May 2026 02:03:08 -0700 (PDT)
X-Received: by 2002:a05:600c:a110:b0:488:ae6c:42c6 with SMTP id 5b1f17b1804b1-48e51f2e8a3mr329713385e9.14.1778490188196;
        Mon, 11 May 2026 02:03:08 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d895781sm104533135e9.0.2026.05.11.02.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:07 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:02 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 14/30] mm: hugetlb: use __GFP_ZERO and skip zeroing
 for zeroed pages
Message-ID: <fe1d24d4deafe0f5d1a9c51fcc040d9561c8592a.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vkJlD9mrW4Pa1R4i5meDCjkl0o7wVHCjatEn9rDL4Qs_1778490189
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0DAB98000B
X-Stat-Signature: td1moi6dhrn3jxyhgje9sdpdbrox374e
X-Rspam-User: 
X-HE-Tag: 1778490192-95838
X-HE-Meta: U2FsdGVkX1/6IDQsmFVUOGZANUaoXb1Oa5M4cmg3RSY9xkQ2QlqNOLjVyc3nwJKX8ZieRmupzl2wP8Dm5VMSily0LN0ULJ1wd8cJmEnFp/0tsedvnu6X6MkU55v0QPSgjS0ipSKoVKUthYBDcRb+N9b7gOiGQxt+L2WBhab2zQe22vI99Bw7ceDRgTLwdK/pWak3HGh/gNFBJIHylnnX+kRfi2aB6FmtR5irZCi6kIH3oLhm41EfWEAKBaF9BiN+fix1bma8Ect/vmWX1q2s2Iktd9AYtU/7UayFsFNe2Oh1nOmr8esUzdlh1I34SvwTQqFEhHMOTdIOOYEqAP6XNE5n1CnsScpLJIlpDSGmcqQO55Rp6dNWYAbCMR7GmmvnVbim3MZRE5cXXPi4D2Tn5Dx/m6qIpQcRmXty7aHXpbGo8VTL1M/YKW/Dauo8Juh1V1tgqGtwvK/6RbGn9W+79QWNxKEIPhaF68FuWzGfJuFbj7DScaOV0M3ITdL8jPlc4Ii5qMggK/9fA8zoT8d09Ef5Jfym7QL5BHO7vPr3MNvUpuUHm3n+ztjG3k1w0IrK6SpytXZfP0O/g8WxFqAbLij6n3Mt8JeaZQGAh50tKwbLh2MnW6NLpt5c1l7z1gLHubLf1/efH2pYk4Tf9d1cv64YqWOGJPFMNC1xeAYCeT5HyMN9kkMGBXqAemU1S838HaNleZ/kXvmy2J1aaUv6Hn/ji8Wn62qnewN5KwRua6QtrnmVHz9/nXX8GLDdHX21JpeO73jMyRLn3XUnHH5SI50hu9N/KSGr0dxlDzMwY2ff3YJp3+jSo8Ee7LRBn3n4RM+gGFbFHYV/iD1rUL2VeCF9toa4GchYZ7k9TG5gpVn6tvsx7CeNBeeQFbpK97bX0u4/ljY+5jtWUaiEzVztioGovvnhcz3PFckFHAvORKqFd+i55uemVSyp0+6v/qeinAE2zTSf4X+8cjo98Ph
 PuO3aEyw
 tDGCg8wlxcoXi+j2MRnrDr8kFsoEDB4XP6kfskr9FwtkQED452+q0NGGyY30Tj9b/jyAE2Km3EqcOpGK0/CDwarxKJhRJsLPGNPKpp5X0/+fvmB/W8h8aHR166rQFTfczuLWmTErXW3n/I+G+NNFk/2/okYBsKyacdpTf9uieH+TXvYz5ra8l8s8TL8lRZbdBs2KiiThvD32F2afcvGpSSAmngfnmPeb8LnQtjvzfPFmjnyMBqClv/j7ezh8xLVoBGsmIr5VGB3HMXm6SJvqX0/hcPhUwKwngGaOS55D2kR/uM5upA9DUdM1FwbqNBDhjBumudFIfYnHdJ5W4m1PuE7qb6+LcszQEXoEFJYPDoR4TxIKCfosknz1KuCVRz6CoJBAxSSQLxHjz3CjQKWrir+ZR3z1FwPDhUyZZhblE//G5qP3EvVvtoOo3mYpPOsWwD4Tv
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
index 8b05bec08e04..24e42cb10ade 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -810,14 +810,20 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
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
index 93418625d3c5..950e1702fbd8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -599,6 +599,7 @@ enum hugetlb_page_flags {
 	HPG_vmemmap_optimized,
 	HPG_raw_hwp_unreliable,
 	HPG_cma,
+	HPG_zeroed,
 	__NR_HPAGEFLAGS,
 };
 
@@ -659,6 +660,7 @@ HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
 HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
+HPAGEFLAG(Zeroed, zeroed)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
@@ -706,7 +708,8 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				unsigned long addr, bool cow_from_owner);
+				unsigned long addr, bool cow_from_owner,
+				gfp_t gfp, bool *zeroed);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
@@ -1131,7 +1134,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
-					   bool cow_from_owner)
+					   bool cow_from_owner,
+					   gfp_t gfp, bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a999f3ead852..8710366d14b7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1708,6 +1708,9 @@ void free_huge_folio(struct folio *folio)
 	int nid = folio_nid(folio);
 	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
 	bool restore_reserve;
+
+	/* Page was mapped to userspace; no longer known-zero */
+	folio_clear_hugetlb_zeroed(folio);
 	unsigned long flags;
 
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -2110,6 +2113,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (!folio)
 		return NULL;
 
+	/* Mark as known-zero only if __GFP_ZERO was requested */
+	if (gfp_mask & __GFP_ZERO)
+		folio_set_hugetlb_zeroed(folio);
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2173,11 +2180,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
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
 
@@ -2874,7 +2881,8 @@ typedef enum {
  * When it's set, the allocation will bypass all vma level reservations.
  */
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				    unsigned long addr, bool cow_from_owner)
+				    unsigned long addr, bool cow_from_owner,
+				    gfp_t gfp, bool *zeroed)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
@@ -2883,7 +2891,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	bool from_pool;
+
+	gfp |= htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
 
@@ -2951,13 +2961,15 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
@@ -2980,6 +2992,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
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
@@ -4988,7 +5008,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false, 0, NULL);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5517,7 +5537,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner, 0, NULL);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5711,7 +5731,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
-	bool new_folio, new_anon_folio = false;
+	bool new_folio, new_anon_folio = false, zeroed;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
@@ -5777,7 +5797,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, false);
+		folio = alloc_hugetlb_folio(vma, vmf->address, false,
+					   __GFP_ZERO, &zeroed);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -5797,7 +5818,12 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
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
 
@@ -6236,7 +6262,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
@@ -6283,7 +6309,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
MST


