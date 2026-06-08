Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F27CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C406B00C8; Mon,  8 Jun 2026 04:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBFC6B00CA; Mon,  8 Jun 2026 04:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0840D6B00CB; Mon,  8 Jun 2026 04:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7E976B00C8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:39:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C8581A09E4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:43 +0000 (UTC)
X-FDA: 84856097046.30.D136FCC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 447E220002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UzO25CmA;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907981;
	b=kvFZmgdXzEnijJ5fEWCO4NawUtygchecYPChgyI9gGVZz8Hw3u3AGC57NGBuJaTDerf/C9
	2sNWDSzvoBXedgoUr6nMMVvFKanL1bYkYrJsDa42oRVCDrSLe7FrMz7UOKH+blTcnXPOIP
	KEvBcXR5ha/N6Mumin76l4IY84eLsyY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UzO25CmA;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjTJBqpyDofbRU0ObNPGnhPpa7CYDWMZBguCdtv7thM=;
	b=4odBJHVpE9awlEOaXrKnPy/RQwJpiTcvdqK9IVcqj1AQV4mIE9GF5Jtd2K64WwHvcCMtr/
	/N5pmKPCU9xj6SC/LoSGKF7Sfx+ZoSIw+jT/H64N0fFJ81q3F50f6+LCq1RvYIpyuX+X59
	sySrJl0/Tb69Vw/mxx0eHK+xYppcjvQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AjTJBqpyDofbRU0ObNPGnhPpa7CYDWMZBguCdtv7thM=;
	b=UzO25CmAEwlqIFruSOMKUlRbQPbB3Bj3mPxjpOFurGYjJln+Vlf83eSIfQPLXmTl6phxYA
	39Ca3ry40c2BONTL10NmN5pQNdtuGG6e4r4TN8o8DiOojXKWzDNfpZJMGSFshTw7tLN2HA
	4pOxI6QFbnmprtmU4iG8zrYD8qNime8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-ZnjxWE6AN0uSYCb10WKubQ-1; Mon, 08 Jun 2026 04:39:39 -0400
X-MC-Unique: ZnjxWE6AN0uSYCb10WKubQ-1
X-Mimecast-MFC-AGG-ID: ZnjxWE6AN0uSYCb10WKubQ_1780907978
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490b2f22ea2so42659225e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907978; x=1781512778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AjTJBqpyDofbRU0ObNPGnhPpa7CYDWMZBguCdtv7thM=;
        b=NpOxv5PursXHjCrZ/cpzMNtkTiyPiTs/EojLzC5zE3eHAJumiAzm3jwimeddzW4rRX
         4XfoHhnmqBdyGc8EyqwSYKG3KRGlr/8XcVi1Ep5P+8CYLDxH73fihpSYFGZUFGsrzNw+
         DGymQ2Bg/bIJiopxWe9uEw+kW4tkXtLQmxwyLftYAUa4IbmDwoeMzDzkON3NRxxl2Zz8
         FXobt5sIfMcjhDY9pJ/lvFDIdGrcht4HnblOjri8KUzMrCJiGi5QajmXmXg0N5TiS21f
         0tNVuaBsYzIzt+Pk9pesWWkwW1dD0ijicpSdRocYffZIPaCUCUqqAoBvieLiWLirCuM5
         3hDw==
X-Forwarded-Encrypted: i=1; AFNElJ++CF4HcHcuMDuHQfbsNaOAmTc5W3Y+cmf1fNhUUGfpfBd9gTB0VvzGbqKlRb6qcEAH/8ZsN8Hx6g==@kvack.org
X-Gm-Message-State: AOJu0YwcXNuzoSSRnyJ2iNzWDleeYxWAz4cKwjAR1JZZ8y4U1AvhDcyO
	z2PMxBsIekKDU+1CdCfqB+XeuRwBLh3b29NnywYr6GcAFx0AMWvN9ch50BgE72KXmnuVRm3idTs
	eSYiiSAFbRI6I3flpAUZJW2HkXZLwkLr5d6off0v9HicCKCJYgmaW
X-Gm-Gg: Acq92OElJjiMyfKpxWZMV2fb4TtblH1RXO9dDP0f9Rc+kooRa0D64H+xZ8BRsZlqoEq
	rTp470x1HfhnV5r5728bMT6RecA2C7JFlpl+qsz3dPj0NP2nD3YWMqjicqh/ElsdLhPjCZ2wZGQ
	6/Uqc/ZfBktX8i7UBIplwCmKglfoy8FOF5O5YOxqkXCqZnJ60MhcI9qP8FxmJ0pcQFgHleFrCLQ
	2oHk9AfywIPXg3tzleCniK0TdOQebpq+XLqD5rFVytEiJb6z5lmtCSQVOY9Gh8AAlnW8UY2mnvd
	sARK1qYaJ27rAlcO7ej6e91kaXV76s186Xie4ORXjBevCA4GtbRaNaELMRKeftEZDdUnv06lj8N
	zueqf3ZYSLwxWcDpNnwyOlqo=
X-Received: by 2002:a05:600c:1d2a:b0:490:bbc1:d508 with SMTP id 5b1f17b1804b1-490c258f3femr244579875e9.1.1780907977554;
        Mon, 08 Jun 2026 01:39:37 -0700 (PDT)
X-Received: by 2002:a05:600c:1d2a:b0:490:bbc1:d508 with SMTP id 5b1f17b1804b1-490c258f3femr244579295e9.1.1780907976956;
        Mon, 08 Jun 2026 01:39:36 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3fd502sm376493895e9.11.2026.06.08.01.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:39:36 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:39:26 -0400
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
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v10 28/37] mm: hugetlb: add gfp parameter and skip zeroing
 for zeroed pages
Message-ID: <f251c9e495cdf98169f225559927112103303137.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W_uDrcAdiYgi548ziQia1rv-pAgjxaOIdZzJTp7syBM_1780907978
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 447E220002
X-Stat-Signature: hcj7dyhsfpokre179x6ahe3huu6brafd
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780907981-66490
X-HE-Meta: U2FsdGVkX1/DKUuV9Vcyqg4w3AvB+nrRKrn4j655kcCgO8XZfttKuPTrh3FnTkuPwrgh/hpu61J1USsijzzxY8gr0Xmu1kHXazNz+f6H5fnGzszcN+6HqnxvzyX6NFKp41DYXj+PxFiGjPNV4V7M8gYPjC5Hinxm52NyyK3YXr9rz0J2VNGMxSKBIgYsKMEm/prbegZ/i1pJ1XElc1Bh6DNbCnStg8wzHiVeqOQDLrqo5G74sXLOYS5VFcxamkCG5BTjrVkklHGLQy9A9ZrXMOKQgzKljOC78i4RBj77yxUVyT3VWR4uAYtuXA48ey4jij2Ku6GUOJpqgFew/mwwBKk3Tw2Hl+3M8/tIfb/m92ZjwMuH0lw+3ShcSoy88P9gXqVVcqkYDS4a5KqjtSCAN8HaKUntTSjfU/9QOkKJMLNIJdsjUAG6214eZ7T2PEBKnWvRgBzMtMK+w3nY/MaqD8dlXjZXJqS/CsbUqL59vF6aooC1OY47rx9OuqlbYaO8NSE+HB0Kl7vQ5QLwUK5A226aW6EyqUlnCoQawHkGpoXHf3qw+nPOVZ6NQYBj3p2X6pYvfUS/W1VNkspjgshXaZ2lhotjGLYo/sueEgZibMGCpuY5XdY3gmbNYHkjFg2uXaEo7lr/pkqTuYqaSEdRKFHCMamLPss/rGOMknTZlE3ep70s6XUadG6YiuL2SdgCFa0FioX5PWfVtGTjSNJ8K4uAzq5YD/03OmvVUx68RXV7yNvh0ZpSlNKIHqvkid1NK8vyxrkEsvcid7uEeFVsq5tyOoLRweCE2UUFJ7WsZbFDaFQ6sg3wzOKwm7xEJDeIErcaVtrAFyocPghQAyBm6lvCgyXOO9hSVnn/rS29q2sgpISNu6Uxa4+di20U+HQfnSvvZIA3ZO6mbm0b09R1IlDzLJQxS+LvznSw1zp2tfqJIV34UMIzBaDDXMxXal5ofE1Q3kvp6Bl8bNpv6R1
 Al5xRPTM
 H97XSFUQmOweSqGXkKMgwAHltn/epOX/t+Z8A2M2DcrkuufiF+Lv0cpX1lIf/qKqIDCv7xPEPI/gwcX7Rsh/iLgu/9C7J+YtEKfb8HEDEnosJtu94TPgd4tWTsLekBOOoo0pLKqM2gC6RBiNas49ZyYnle0yfItPn/5PQI4zVMOi2Q5dv2PY7RMXxDIi2tWOxxj+6x2JC7wo1Az9mlqfEYWsb9aV/yWJWGVtxRdpfxAKrUjIDuy8RKeOieq+Xp9kLNeshzZzXB7t6FRHgZpPN6TtjKeryeuiBC6Fdu0Uag5P3+9TDLbUXJpebLxKvkhw1xae6ri+9fTB4OsE9dLFGHxkn+kMrLGQqZ578fv6ZaOXkd+p1VQRh3TNk8bhp0rSqcfuxQfrhUlw5d+I1p1duM0L6i1a+2XSBUARUMBPVQ1acDaNUOeTnrhiFK76Ec+9BacLPZynQStnETmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a gfp_t parameter to alloc_hugetlb_folio(). When __GFP_ZERO
is set, the function guarantees the returned folio is zeroed:
- Fresh allocations (buddy or gigantic): zeroed by
  post_alloc_hook via __GFP_ZERO, HPG_zeroed set by
  alloc_surplus_hugetlb_folio.
- Pool pages with HPG_zeroed set: already zeroed, skip.
- Pool pages without HPG_zeroed: zeroed via folio_zero_user().

The address parameter is renamed to user_addr; the function
aligns it internally for reservation and NUMA policy lookups.
For pages that need zeroing, user_addr is passed to
folio_zero_user() for cache-friendly zeroing near the faulting
subpage.  All callers pass a page-aligned address; the
hugetlb_no_page caller passes vmf->real_address & PAGE_MASK
for consistency.

HPG_zeroed (stored in hugetlb folio->private bits) tracks
known-zero pool pages. It is set when alloc_surplus_hugetlb_folio
allocates with __GFP_ZERO, and cleared in free_huge_folio when
the page returns to the pool after userspace use.

Note: for gigantic CMA pages, __GFP_ZERO is passed through
to cma_alloc_frozen_compound() via its caller_gfp parameter,
so the pages ARE zeroed by the allocator. HPG_zeroed is only
set when __GFP_ZERO was in the original gfp_mask.
Pool pages allocated without __GFP_ZERO (e.g. by
alloc_pool_huge_folio) do not get HPG_zeroed; they are zeroed
later by folio_zero_user() at fault time.

Note: with __GFP_ZERO, the folio is zeroed before
mem_cgroup_charge_hugetlb().  If the charge fails, the zeroed
folio is freed back.  Before this patch it is zeroed after charge, so
simply freeing after zeroing would be a regression.  Thread a
zeroed hint through free_huge_folio so surplus pages freed back
to buddy preserve the zeroed state via free_frozen_pages_zeroed,
avoiding redundant re-zeroing on the next allocation.

Suggested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 fs/hugetlbfs/inode.c    |  3 +-
 include/linux/hugetlb.h |  5 ++-
 mm/hugetlb.c            | 78 +++++++++++++++++++++++++++--------------
 3 files changed, 57 insertions(+), 29 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78d61bf2bd9b..2c0c51fe9ec3 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -790,13 +790,12 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
-		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
+		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false, __GFP_ZERO);
 		if (IS_ERR(folio)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 1f7ae6609e51..06d033a57a61 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -593,6 +593,7 @@ enum hugetlb_page_flags {
 	HPG_vmemmap_optimized,
 	HPG_raw_hwp_unreliable,
 	HPG_cma,
+	HPG_zeroed,
 	__NR_HPAGEFLAGS,
 };
 
@@ -653,6 +654,7 @@ HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
 HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
+HPAGEFLAG(Zeroed, zeroed)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
@@ -700,7 +702,8 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				unsigned long addr, bool cow_from_owner);
+				unsigned long user_addr, bool cow_from_owner,
+				gfp_t gfp);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5d7e546565f5..ed00db703911 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1455,7 +1455,8 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 }
 
 static void __update_and_free_hugetlb_folio(struct hstate *h,
-						struct folio *folio)
+						struct folio *folio,
+						bool zeroed)
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
@@ -1506,6 +1507,8 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	if (folio_test_hugetlb_cma(folio))
 		hugetlb_cma_free_frozen_folio(folio);
+	else if (zeroed)
+		free_frozen_pages_zeroed(&folio->page, folio_order(folio));
 	else
 		free_frozen_pages(&folio->page, folio_order(folio));
 }
@@ -1545,7 +1548,7 @@ static void free_hpage_workfn(struct work_struct *work)
 		 */
 		h = size_to_hstate(folio_size(folio));
 
-		__update_and_free_hugetlb_folio(h, folio);
+		__update_and_free_hugetlb_folio(h, folio, false);
 
 		cond_resched();
 	}
@@ -1559,10 +1562,10 @@ static inline void flush_free_hpage_work(struct hstate *h)
 }
 
 static void update_and_free_hugetlb_folio(struct hstate *h, struct folio *folio,
-				 bool atomic)
+				 bool atomic, bool zeroed)
 {
 	if (!folio_test_hugetlb_vmemmap_optimized(folio) || !atomic) {
-		__update_and_free_hugetlb_folio(h, folio);
+		__update_and_free_hugetlb_folio(h, folio, zeroed);
 		return;
 	}
 
@@ -1596,7 +1599,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 			spin_lock_irq(&hugetlb_lock);
 			__folio_clear_hugetlb(folio);
 			spin_unlock_irq(&hugetlb_lock);
-			update_and_free_hugetlb_folio(h, folio, false);
+			update_and_free_hugetlb_folio(h, folio, false, false);
 			cond_resched();
 		}
 	} else {
@@ -1621,7 +1624,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 				spin_lock_irq(&hugetlb_lock);
 				__folio_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
-				update_and_free_hugetlb_folio(h, folio, false);
+				update_and_free_hugetlb_folio(h, folio, false, false);
 				cond_resched();
 				break;
 			}
@@ -1664,7 +1667,7 @@ static void update_and_free_pages_bulk(struct hstate *h,
 	}
 
 	list_for_each_entry_safe(folio, t_folio, &non_hvo_folios, lru) {
-		update_and_free_hugetlb_folio(h, folio, false);
+		update_and_free_hugetlb_folio(h, folio, false, false);
 		cond_resched();
 	}
 }
@@ -1680,7 +1683,7 @@ struct hstate *size_to_hstate(unsigned long size)
 	return NULL;
 }
 
-void free_huge_folio(struct folio *folio)
+static void __free_huge_folio(struct folio *folio, bool zeroed)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
@@ -1692,6 +1695,9 @@ void free_huge_folio(struct folio *folio)
 	bool restore_reserve;
 	unsigned long flags;
 
+	/* Page was mapped to userspace; no longer known-zero */
+	folio_clear_hugetlb_zeroed(folio);
+
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	VM_BUG_ON_FOLIO(folio_mapcount(folio), folio);
 
@@ -1735,12 +1741,12 @@ void free_huge_folio(struct folio *folio)
 	if (folio_test_hugetlb_temporary(folio)) {
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_hugetlb_folio(h, folio, true);
+		update_and_free_hugetlb_folio(h, folio, true, zeroed);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		remove_hugetlb_folio(h, folio, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_hugetlb_folio(h, folio, true);
+		update_and_free_hugetlb_folio(h, folio, true, zeroed);
 	} else {
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
@@ -1748,6 +1754,11 @@ void free_huge_folio(struct folio *folio)
 	}
 }
 
+void free_huge_folio(struct folio *folio)
+{
+	__free_huge_folio(folio, false);
+}
+
 /*
  * Must be called with the hugetlb lock held
  */
@@ -2031,7 +2042,7 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 			rc = 0;
 		}
 
-		update_and_free_hugetlb_folio(h, folio, false);
+		update_and_free_hugetlb_folio(h, folio, false, false);
 		return rc;
 	}
 out:
@@ -2093,6 +2104,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (!folio)
 		return NULL;
 
+	/* Mark as known-zero only if __GFP_ZERO was requested */
+	if (gfp_mask & __GFP_ZERO)
+		folio_set_hugetlb_zeroed(folio);
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2156,11 +2171,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
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
 
@@ -2715,7 +2730,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		 * Folio has been replaced, we can safely free the old one.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		update_and_free_hugetlb_folio(h, old_folio, false);
+		update_and_free_hugetlb_folio(h, old_folio, false, false);
 	}
 
 	return ret;
@@ -2723,7 +2738,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
 	if (new_folio)
-		update_and_free_hugetlb_folio(h, new_folio, false);
+		update_and_free_hugetlb_folio(h, new_folio, false, false);
 
 	return ret;
 }
@@ -2857,16 +2872,19 @@ typedef enum {
  * When it's set, the allocation will bypass all vma level reservations.
  */
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				    unsigned long addr, bool cow_from_owner)
+				    unsigned long user_addr, bool cow_from_owner,
+				    gfp_t gfp)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
+	unsigned long addr = user_addr & huge_page_mask(h);
 	struct folio *folio;
 	long retval, gbl_chg, gbl_reserve;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+
+	gfp |= htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
 
@@ -2934,13 +2952,12 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, user_addr, gfp);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
 	}
 
 	/*
@@ -2963,6 +2980,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	if ((gfp & __GFP_ZERO) && !folio_test_hugetlb_zeroed(folio))
+		folio_zero_user(folio, user_addr);
+	folio_clear_hugetlb_zeroed(folio);
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -2999,7 +3020,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		__free_huge_folio(folio, !!(gfp & __GFP_ZERO));
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -4971,7 +4992,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false, 0);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5500,7 +5521,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner, 0);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5760,7 +5781,13 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, false);
+		/*
+		 * Passing vmf->real_address would work just as well,
+		 * but PAGE_MASK helps make sure we never pass
+		 * USER_ADDR_NONE by mistake.
+		 */
+		folio = alloc_hugetlb_folio(vma, vmf->real_address & PAGE_MASK,
+					   false, __GFP_ZERO);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -5780,7 +5807,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
@@ -6219,7 +6245,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
@@ -6266,7 +6292,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
MST


