Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA62CD4842
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC206B00BE; Mon, 11 May 2026 04:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3C36B00C0; Mon, 11 May 2026 04:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B1A6B00C1; Mon, 11 May 2026 04:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 082026B00BE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C72988D612
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:50 +0000 (UTC)
X-FDA: 84754528740.12.8226F53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA17DC0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iq5ei2mj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
	b=YGXYxdrf8k/jnlf/auaqXlaLb6TSWvUeLWIosJ/Zrjs2UwHpyaQbUSzS7GZBDKby2RDVUE
	6p/cQHjHMW6ZwkTXPiXbr1ZPirI2dHKynObpV3bWSFyy3X4RcAzhwUaEtXIExR4mYnlbxk
	X2PNxiwNpLIJlbldI3hICnEcD7PKCR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489688; a=rsa-sha256;
	cv=none;
	b=suuGu00QUCwqcZP13zKOOrWT9sysX6LKavWokkV+AFQYRfqM3s63Som4gFNJ09uOJYR612
	W0mDYQKCsCr6KFPFZvjRP5orZmd3iFYwnUA4FUduFt/O6VQ6ZNstL3o3SxfdTTHFaf7V2C
	dic4Ev1XX31sBU+GQFMOmRj/Nat62gU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iq5ei2mj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
	b=Iq5ei2mjRxkQCFX1BCWiA6zpZMynMMLiCVnyz+y3sk9cMSPeewvSnprV6krAcUDPx0jk5h
	AGfgQ3/EuuHt2HLqaEXdorI1Z5Pb53tW0IKPyH03ZjApzp3Jnp3xedeFGz3f06wn0gWaRj
	Gn/9fbe6rdsMwRYZCJ2Ujkc6SAzrPNQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-eISVIfjhM6GaSQAaRnnf0w-1; Mon, 11 May 2026 04:54:46 -0400
X-MC-Unique: eISVIfjhM6GaSQAaRnnf0w-1
X-Mimecast-MFC-AGG-ID: eISVIfjhM6GaSQAaRnnf0w_1778489686
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-44d83e45febso4081678f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489685; x=1779094485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
        b=MICMupC9kLsauf0YRnfrM8IbXKQcq6nwwId4EtuCY6KcbWk9mow1Lmg3AlxWJCNZuy
         rALv6ZQWQQkjWb5L9WxX6gpK5NI1lzfI6PSSzFjSgcUJKyWF5VMaYgrjEzq/HnRo4+07
         /PRb6+d3EDJLiJWD0gBT/+xaD1CWfRgs9Vt7TKPix5PY8PKQxGWVRLIvVRUBJZaPTALU
         MJ9Psau+MUc1UppxwNyqtPU9LhMZknlo19VqJxtBuvTaTEFiVrnbBOZQI6DrOvG5hXgC
         BedMYYe+ten+4F7SwfA/mOutki/wN1ShfsjlVBoxoSiPpQP55NRcsaOD/4v0t5oyx+Nl
         X8xA==
X-Forwarded-Encrypted: i=1; AFNElJ+RnxhWccrEz82VqwkuoRBNvBKComy8FilqsExqgCVenx42joXbqwndKFyIGjobN3RsdhqSsbLu/A==@kvack.org
X-Gm-Message-State: AOJu0YwJnf/UR14+LWiivDIoxQJcKsOwFyrIqTD1nobI5GDXXwxueX+6
	cnPdZDmjKHu+uh2g3B5B25CsHSKWYGY98HqJSwT3A9kg3EWhk4GQBiTyqRa8BtesJjNxPK/cNXv
	ZQlniGJDRnKqVumfm4L0pUu5OYHfA9RlCMQA9HaIBWC5azE037V+v
X-Gm-Gg: Acq92OEp5b8VadXqCzyEPyREWlK4ndJ4YZ++0rFVY9fxdn03kP+8kqNlqhxouwbj0mb
	/UzcoWmzCtotcmWFt3iyWe6PTFtodNPtECj6lFbfyzEv7GBkAIYlC20v+QNVkF+3ChGmv4omhU/
	ra8EgRAgTfErVV40XqotxB1GuT/5HCMh2quyC+rR3QwktTG4XCl3aP4u/saw7Pe2YHKvuA2TER8
	ujpbsAUlijl/nsU9x+3tNVJiLEgpffvlG7Wa+/KYTdrymsSPd6fMScrlNxoIFR3zUrrX7YfkJ/K
	Ib3PuEX6+U77c116RAHlzGyXSNOAj4wjqDWkVZ1MY98pWs+GZFZh+P2PpOikdVID2EqSVC52axl
	DGOjjxITIpJdVCi57qWM0kWkiWdJ+yfpmS4sKrVd81bOK87WdP/U=
X-Received: by 2002:adf:e905:0:b0:43d:210:2b2d with SMTP id ffacd0b85a97d-452eaa28388mr19585546f8f.31.1778489685367;
        Mon, 11 May 2026 01:54:45 -0700 (PDT)
X-Received: by 2002:adf:e905:0:b0:43d:210:2b2d with SMTP id ffacd0b85a97d-452eaa28388mr19585465f8f.31.1778489684785;
        Mon, 11 May 2026 01:54:44 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a68ebsm22598211f8f.1.2026.05.11.01.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:44 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:39 -0400
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
Subject: [PATCH v6 15/30] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <a39ab8288aceb244bdb31141aa9cf67106c0e042.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NllDCDA_xR09KGT4fMV24a6xmm2AgCCE4o3ZmA_GJjo_1778489686
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: AA17DC0007
X-Rspamd-Server: rspam04
X-Stat-Signature: wsff1ssxejbc668jqyiwxct6h8crojet
X-HE-Tag: 1778489688-682304
X-HE-Meta: U2FsdGVkX18ZfTrnEGvaOVfvMXvkqJFjrNWRec0cCEHLjtQ5SkdDmCRE7/pddPU0OJdUMeCCZVzj0Zca5iKHKzr1umL1R3ehq25RNJYAxFdbt69SIXC/18DVms9AyxD6ZKrXta2MnJ8b+EQkfbqjmzIEJvTogyXke02zXyXMmNueOFKc2OKfM+0drrypbdTy2KA5S81hcu4QH0D/VJVdzTYBdfEHfW3+JEgw+F4garB0GZyK2UZjVhPNCtbIdgHdU4B8Ndm1Hxm2iwXG6wtVCZ/kHGz/KgjF14cMg7J7WLVj6SLcA8VO5CiAsNUFL+Akp51NNqvjEgTXNVStUWj44qJfFU/cb445q6vDTuDTXeD5R2mDIA06H3ZYKaPpRV22taql35BcxRPck0p3UsZ47krTDE50H71ltJ0tBLi+Z3ad6LBZdf+r85BgNgTfVhdJVfCMMDbaLcKmFJtf2dUkw9U3pUfUZBVIc1FEN9hbQYtt0fEwflp+NzzicNwfZoBCgCojuR7HvmjgeGiGqKU7ceCi1j2jrIYgEHdPHo2VjFymXi9PkwnTfKjGk6MJdONSqjSu7eV1E09YO5CepGSul+6uaFU7maT+TwopumAMWrfJL1CzQY5XXHpYSQZFu9IG60oGc6DBi1tSVImKqTdZVM84o63RLdtRkx8Dj7ILCziUs5rF9LCrHsnT6unUoI7sMbYC/WvG7TCT5d2MPEGEOlO/FFLYtQc0eTsIX0Tzxu4QaDWt8KWpkXde3K+2RDN2VmP6NVjN+ueyNdzpywrzLgp+FHDPYzLjhXB3WTgo0l98CmoViSs3zzdxijtKi8nkuNPDlSHrdhcYT9u0FdeFNQo9r2UxSD8Vv652QH6Tn7pyIr8kTcSyTwX2b+h42J+vJNw6j6DcOy5nfn2poZUEJ2fCsxSvkYeL9ZT2vEZSiZ6DMLyIS1Igb/6TUVNgI9m1rh3PuI7Km6mTaydTjmK
 6EdRAdWK
 BqJVSrfyJf5ldZ/uXelJPNcGGRsI0JJ2QfFsPORN8hWj/Uqm9zbyCjccWgP+RPNgKgVqBPy6jlyMoof9BR/8KDj6e+Pc5NbHxUNT9XwGrns62hoSUrjLTRxd406FR+BroclTwWUbYzPZjqxjU5ghJKuNwJWHSFGgysRBaovtQfwkrFf7sQxX1+d5aYq/leh2D+lR0PysAcAzi8uAqnYG0vAnUYYGzD9VWIIfiGdff8115l0jB3NYLB+biWurQmayQulIwrf6N7cdoJp7Ar10kBO+B0yhjcbd4CDQCTEImMDAYeniRymryaYmSw7V2Z4wDWEIzOI09l9DR44j33/9dALejzEzRdQjaiCEUlC3bxY+2P9DPsz+R5kTZaOVgo72zG/vrkkJ9D4WXAOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gather_surplus_pages() pre-allocates hugetlb pages into the pool
during mmap.  Pass __GFP_ZERO so these pages are zeroed by the
buddy allocator, and HPG_zeroed is set by alloc_surplus_hugetlb_folio.

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/hugetlb.h |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/memfd.c              | 14 ++++++++------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 950e1702fbd8..c4e66a371fce 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -714,7 +714,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask, gfp_t gfp_mask,
+					  bool *zeroed);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1142,7 +1143,8 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8710366d14b7..03ad5c1e0655 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2205,7 +2205,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2221,6 +2221,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		h->resv_huge_pages--;
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (zeroed && folio) {
+		*zeroed = folio_test_hugetlb_zeroed(folio);
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	return folio;
 }
 
@@ -2305,7 +2311,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h) | __GFP_ZERO,
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
diff --git a/mm/memfd.c b/mm/memfd.c
index fb425f4e315f..5518f7d2d91f 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -69,6 +69,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
 	gfp_t gfp_mask;
+	bool zeroed;
 
 	if (is_file_hugepages(memfd)) {
 		/*
@@ -93,17 +94,18 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask);
+						    gfp_mask,
+						    &zeroed);
 		if (folio) {
 			u32 hash;
 
 			/*
-			 * Zero the folio to prevent information leaks to userspace.
-			 * Use folio_zero_user() which is optimized for huge/gigantic
-			 * pages. Pass 0 as addr_hint since this is not a faulting path
-			 *  and we don't have a user virtual address yet.
+			 * Zero the folio to prevent information leaks to
+			 * userspace.  Skip if the pool page is known-zero
+			 * (HPG_zeroed set during pool pre-allocation).
 			 */
-			folio_zero_user(folio, 0);
+			if (!zeroed)
+				folio_zero_user(folio, 0);
 
 			/*
 			 * Mark the folio uptodate before adding to page cache,
-- 
MST


