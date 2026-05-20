Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8281ACD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2DEF6B00B8; Wed, 20 May 2026 18:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05596B00BA; Wed, 20 May 2026 18:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF62C6B00BB; Wed, 20 May 2026 18:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A68086B00B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F0201C130B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:22 +0000 (UTC)
X-FDA: 84789222924.12.D772ECF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 11B20180004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gqCgxNZ4;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFnBVDBDzVeV9p9dYXmJ4JPUR3YMu/6T3H2GlWvoQjs=;
	b=qpK+gfxuRUBM2/fJkgbO3W5qGYMLeJV6WJH5ePS/zHtx/E6ooM8LSyGfLL3WH4X5x1Qkwb
	2w8Su8cb5RUT4K07AmfJ7DIMIIunMGZHcsHzYmFshPWnefdgJYFhIcukA8t4D0HOpoBi5l
	SLu4fkMKkTGX6VfdoO8RU+tj9npxhiE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gqCgxNZ4;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315740; a=rsa-sha256;
	cv=none;
	b=K44HbYdCIwO/2+7PLltq4PRdzRTpBVdHOVE8wPDPT1yVxL0AyRiDsK7ynYA3f2MgWjGEqE
	l9ngg/RFYSBOcAjcD8NSHK6+yFInNXNHtINdCXARp8fR30Nhd0mLAm0At5oHWZKFSMdv5x
	7l1+55flHycBl9Z2VIzIZOqQ1TFUApw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YFnBVDBDzVeV9p9dYXmJ4JPUR3YMu/6T3H2GlWvoQjs=;
	b=gqCgxNZ4pPWItivvm6csFx3m0NiRc5w6Djv2sk6b3VrB0bdOSEKJs3aPnN79Hy1m+Y3dge
	IAYsxcRBQUPa8An7Ndbg+ZCaiHTl31H6o2cNiLAtOsosv05wnG5DsOf3w0e7xV3WZHxnWO
	oSYzx0+u5zcEEyLffByaVphyaQ6eyFY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-V9eXtQ_ZOkytuQQPdKrNtQ-1; Wed, 20 May 2026 18:22:18 -0400
X-MC-Unique: V9eXtQ_ZOkytuQQPdKrNtQ-1
X-Mimecast-MFC-AGG-ID: V9eXtQ_ZOkytuQQPdKrNtQ_1779315737
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48e79219704so37864545e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315737; x=1779920537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFnBVDBDzVeV9p9dYXmJ4JPUR3YMu/6T3H2GlWvoQjs=;
        b=nnYyTcLyDZK4o65Gkxaer6MzML1a+QP698LpkLTkC9k6GtLrIpQY7I74d7aL4+x454
         myGqh+yv2qIjqhD6ZMtHI8rx4T3Goua8HofdbJNL4MDV07ltI2L3BCozX0Ddn4SjXYva
         nvSHnlqsdezohm/iGlFpr0l8TAczOkEboF57MwRO9+Ln3iy04z9RfJtq7w9bfbXr7uKT
         VdgLFNF9rRJF/KtD3huOhreAYqRhpwV9SWaW60hrgrzloLQ+OKD1Zv2vU40PIaXkWkGw
         p9yLlChNPRfzuo4h//Tdkm7lVgGE/6JNXx2Q79doQZO5f4h5Qx1d0bMiL71+kOGp6fe2
         d4qg==
X-Forwarded-Encrypted: i=1; AFNElJ/D7FhVKts4jDjF7Za/9NR7hBOMsTEZRogAI28FoSTCj2fTqqgmrIiyJ9hvRReRzObYpsPpIP34Cw==@kvack.org
X-Gm-Message-State: AOJu0YwwW6Bep9QWwgrTXbRJDCVc+lF3by+pyJEMqfllVVOnuJ5fDdtC
	LB/iOIGz2xXWxeL0lGPbUJYfR44SJ+XVNcQ7UY41+zk3Uu11sXmVWxPOo2v9T7cH+w0bTsNmgzF
	wlIrd3KsvDCc6ivZccghb+Ls83dRpiaCkOtg9JyOzD5d9zqU+8hEA
X-Gm-Gg: Acq92OEjgYuMN926N1Ak7gH5UyHvFbOPBqqYVe9PuYwuQr9pYzkdgPxNqyBdI0yC2bN
	PbX8BRK5kFDpk1cqBx2bwfC03aepnSCpfpUipUobcPOCv3OieO2/xVWvhA2fyzbWUMEdgrDFILD
	irLVPM6u7irDND3zZX8SIhZIaAbLh4rVg5KWeo8aXOfvTpXOv6YCVkIPwRRD1qtI2tUK8VtCw3U
	UfYwtfCQ+lqI0Sc967C8rv5JEL/Y3eD9uCtDVoUmanBWgTMfKkee121c0CI8vEL3TptgNGEoCL4
	UC1rCbIs3JjOLz51rv054BBhqGkKFTjGLwjROVysCDZhyNXJF/YP0BBwW14ICPzMXdvlSecn6zP
	Gv5ye4G+9J1iTyACtmXb+vJgASXEIP0u3hDgT3sfQSHEgPrxG6FfOMg==
X-Received: by 2002:a05:600c:32af:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-4903605e3damr1812015e9.10.1779315736867;
        Wed, 20 May 2026 15:22:16 -0700 (PDT)
X-Received: by 2002:a05:600c:32af:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-4903605e3damr1811475e9.10.1779315736278;
        Wed, 20 May 2026 15:22:16 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d2fd6bsm20770385e9.1.2026.05.20.15.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:15 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:11 -0400
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
Subject: [PATCH v8 20/37] mm: hugetlb: add gfp parameter and skip zeroing for
 zeroed pages
Message-ID: <4eb3feb0a01adc0f2f68e0d0ebf48a43e28c00f1.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -1XmIm3ywX3srBoPc_9d-E_tTrrPkbsNt04ylu1bPjc_1779315737
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 4hykhfjtrjigjkhwwiyb39qzr7mo1fd5
X-Rspamd-Queue-Id: 11B20180004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779315739-34020
X-HE-Meta: U2FsdGVkX1+O6tqops9qdMO5omoGiIfdp07ob2eV/sGIZyOKD5w//jSXPAd7d7ZSmJfmCB5DxTAvKz/s/qni9ve5ZM1RbizV+Y53iSCj9eg+2SIq1EoXImmvAWox9Rngh9xdIeFUxuX00N9Cr943qXNwMZVSxUnpK1dgbAAXLHA6lBvDmqUT5Gu8eQb9gzkTrCoAtxg3+oKo9J3lwXsknd/Fl2lIA82u5CzPgA5u0+0epaH/XkUB6u+Jf+aHKVn0DuxMy5EYIs8837uyOWsIHtzRFXxGENxpvt7j5wLhikazTmNcvQ5/ugNDIMEDQ5cjdFCBExLuSO9Q/X6F/gknd4buuVWFu3L9jichz/TkCzWXaCwNXqw/9XoDtKGM2x0WfqiGZLFsPs3lIfrvxsO2IqyISJASlPfxkBrzc5DkiayIfZCfZrD+4s1KS4URwj9V58C0O0eGFfkur6DANgEGVlR4x7OnJDxggwP1J70KBD7Wy3KLUEEJQyUrUBM85dFTc8fgpOgiZfcoEA79hyFQz1pJMoB3qdTb4OB1l5wZ/i+qFBH5XghnLwV1vJAe6bwUCUXqvA9ZZFlrUyFdOVUEVBpFCL+t+4oMuillzo8mU2zqZx+GBY7soeO56mUXvc0bb22ESSn6uNT/UqZ6ceBvyBm0G/JoZ6zPNTsPD4FB33RerXetqVS/3M2E/qMXRevmUX+/pB5dSrX4ZrwB9fzvp3g2aamhuahKyrYtP6ZKJQv0rHWORGElyWVO8idNa3BpJ3roBwFoJd4fMtHAsfhKEHaHryqqtEmD1Ln5qBm5v5ORwocbNEqAs88jjC6ZwC6/mW4a/xMh0ekC4HwBHDSq3R8dLDPg7uGPtgAdBgd7+S7F7D+XndeGvgYyDpZ5rXDdVMHYHoQPK+52K7hvA5i8UbGXhsWjvtTBnu7osjuCjoRCcHFTIE70Y9rRkrwJ7hqa2mphin8F6vVpGrZ9KjM
 3/ZWiP8O
 cWFMabj1FJkGfHr2aGHpSas6QvwkVqLUH/aUyL1XSaNrTOIVTbafOKep5C33LR/514LfOYyBhOKaStPncPTZeNtHNL67sJ7ZE9utc5N7OED0VPJwFGTgTz0fHcrITg+Wtt0YRzSX9NvyrdNqVKQ3VA1t3xTtdOvyIhFA6MqCAFSs2Nca/scdrMoNEjlw+Hiuf/4tqU3mhSMHAFk8mA96K2GNI81x63CG2AM2QNTGs9w2gPV82dCSdlCGVeQz9tMs5+kPAV6YTliCsYkMOt9+xSb6quf1NPox31tDhs1KjshvFSmHfOozQ5UiYELsMz/4lI5iHB9GHiCduLl9OFBD6N+AI73HQbDKFcYjWzFTTYh5fikcE+fto4ivz6+IdcPGxGH0NyHpE8I7UsdDNz80ctdq206OtZP/7YwSrayi2JcF+ftX19XP2p/wN0eN7WZZCeATLb0CW6hWSGxE=
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

Suggested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 fs/hugetlbfs/inode.c    |  3 +--
 include/linux/hugetlb.h |  5 ++++-
 mm/hugetlb.c            | 42 +++++++++++++++++++++++++++++------------
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8b05bec08e04..5856a3530c7b 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -810,13 +810,12 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
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
index f016bc2e8936..49e5557d6cc0 100644
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
+				unsigned long user_addr, bool cow_from_owner,
+				gfp_t gfp);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a6afbe99116..4ccf4eb91d92 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1712,6 +1712,9 @@ void free_huge_folio(struct folio *folio)
 	bool restore_reserve;
 	unsigned long flags;
 
+	/* Page was mapped to userspace; no longer known-zero */
+	folio_clear_hugetlb_zeroed(folio);
+
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	VM_BUG_ON_FOLIO(folio_mapcount(folio), folio);
 
@@ -2113,6 +2116,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (!folio)
 		return NULL;
 
+	/* Mark as known-zero only if __GFP_ZERO was requested */
+	if (gfp_mask & __GFP_ZERO)
+		folio_set_hugetlb_zeroed(folio);
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2176,11 +2183,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
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
 
@@ -2877,16 +2884,19 @@ typedef enum {
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
 
@@ -2954,13 +2964,12 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
@@ -2983,6 +2992,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	if ((gfp & __GFP_ZERO) && !folio_test_hugetlb_zeroed(folio))
+		folio_zero_user(folio, user_addr);
+	folio_clear_hugetlb_zeroed(folio);
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -4991,7 +5004,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false, 0);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5520,7 +5533,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner, 0);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5780,7 +5793,13 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
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
@@ -5800,7 +5819,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
@@ -6239,7 +6257,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
@@ -6286,7 +6304,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
MST


