Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FFFCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4546B00B8; Tue, 12 May 2026 17:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B736B00BA; Tue, 12 May 2026 17:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3476B00BB; Tue, 12 May 2026 17:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC9476B00B8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CC6814023A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:49 +0000 (UTC)
X-FDA: 84760002138.30.928A757
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4133E40012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H4cvaf88;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/Cxk+5FcCUhBSxOxnUb0BunlHOXkLH/UUFvsIViUiI=;
	b=XDfQmVqLKdNfqpH8eQcdUrIBv42vKZwW907FWTne94bc2RjvDXFlCABsLWZaSh7Xe9slrL
	Ov4CfbvLzdf8FtOYkVTa8aeMsOHS2psaauWzG8f96pc+FAXtgGnXsBxdIf17i7ecv45cwK
	g1KV839TeeHOrwcsxNvyWJtzVWUeDAo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H4cvaf88;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620007; a=rsa-sha256;
	cv=none;
	b=qa7l9D+s7PJE9xhJGPVJ6522R6Ykl6ZbKRVjV4+zzjUg1ew9mw97RcqnGE5rkIQkkLdPes
	5ZQpLESyb2svN/ttVIqWJc4O9vF6mNCY9yHhWRMcmyIFt1eHXF7rPmN7rX/02rbbFM3hCY
	G7iYXBMqr8rSk2I6aqjcdB+46dQtRhA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g/Cxk+5FcCUhBSxOxnUb0BunlHOXkLH/UUFvsIViUiI=;
	b=H4cvaf88JL0Tm6F63iHdb8HYeRF1kZZz8n0/h9Zx104ZiwajKJIghrATUrcFc1nHftWiWw
	u4nvzWpVMPMLO0vqMozH7bfC69S6NG7BAeyu8Nkc1l9nxitv2OXX3MDEREFWpyeN1aNgjw
	7Q0I23dO27X+CnwEN3Mn0Pa5Kd1QHoo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-qoijftRaOUKG800pFuZcFQ-1; Tue, 12 May 2026 17:06:45 -0400
X-MC-Unique: qoijftRaOUKG800pFuZcFQ-1
X-Mimecast-MFC-AGG-ID: qoijftRaOUKG800pFuZcFQ_1778620004
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43fe791a398so5571540f8f.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620004; x=1779224804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/Cxk+5FcCUhBSxOxnUb0BunlHOXkLH/UUFvsIViUiI=;
        b=frlesNjbX9craFKtiRPvh+zzew5CFi0RQUrywSeUGIkEsSKDlf3ErRGgd9sgnoGQYb
         TJwcH1EtZu9RB9/QkNFwipsrbDhh9CDhSFyYEd7ruT/0mGDF3y55FzBzJRFLZrHL/u6+
         cIMqCzJqeb6OpoEtNFyydNR8itTIoj89U6I3i4vQ/Et3U1O9bKjA4Ls3oFtHCwalVMXn
         8s23t0xR1QRFBSfsadiru1MwgMimms7BoftbuemmhtpbVTJZ5QGoDTGdBa43SXp5DZyW
         CvQUKlIkEicvDKGZWCD3/JclNtFgY4isUL7ySssEfq3CJ3E11Wjzic3KRCQax5Fm2Rq+
         TgUg==
X-Forwarded-Encrypted: i=1; AFNElJ/tbQE64yZ1ohdp+TZ0il5tTEcto5m89vPGgI9x5S6q0oQtSBQZEonl1nhqeRxT3VDdto+v/TI1gA==@kvack.org
X-Gm-Message-State: AOJu0Yz9hY7JprG/Z2MxI5bE947yeouB3WqWRhstgnCbmtIhuTtSKiNJ
	YFynPo+L6jNmgK/Ay/rRYKoquxvt76Nlq26nDpmZED+8xAntAwFK0ZA7JYax/qUormV4W0D/gVj
	olc8Z2PpY3Lb+ERoALUZ+p+jjCBmiJEqnDzI8lVufldsEeLqbJJBT
X-Gm-Gg: Acq92OFI4xdqekfdeHUOZY9P3O98Kg6pJJkidtkAwe3Dw/xQfh2g7ZYdePWhKmEjlSE
	HO6YAur1OiO9miNMVbr8LKKXYQhFqeW+fGEunR2g0D0iPjsv8hAJqjYMw9hSYShms7Y9sz+ZxWD
	1MlfcS+zUmtfJNmbJR1mwScfGurKLw7/EDNk8nz+srqWdYJBOhaYiMICBfByXEbGHM4OTCzf+Gu
	qg2MV/SR/TMjZ9hS0FeaEUuuI1VV07t5grKg38VhqiA4CfOCIEHSrzaLiPwbI61iKb126xDUl0Y
	nDKZIXZbOq6bT5x/i1IGpWqYMF2lOuoAoucZHeAVOd2IgtrHUccrMowaNPC/qcqGDZBgBHMcxY6
	JO7Na7+7nSrSmK905HG1jCbTsy1haE2SOgHvMi/Iy
X-Received: by 2002:a05:6000:2506:b0:452:c246:ab69 with SMTP id ffacd0b85a97d-45c7814a806mr40257f8f.13.1778620003530;
        Tue, 12 May 2026 14:06:43 -0700 (PDT)
X-Received: by 2002:a05:6000:2506:b0:452:c246:ab69 with SMTP id ffacd0b85a97d-45c7814a806mr40192f8f.13.1778620002975;
        Tue, 12 May 2026 14:06:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491ca383asm34333795f8f.28.2026.05.12.14.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:42 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:37 -0400
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
Subject: [PATCH v7 17/31] mm: hugetlb: add gfp parameter and skip zeroing for
 zeroed pages
Message-ID: <4039b0b96594b69b15ad4bcd64cbb33de3cec350.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t3ldjpGp1sP5zLD4wMvlAea_W3XYjgDDZFjlPAY8PgY_1778620004
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: j98prxjmuo17b3whxmimkce1s1997ffy
X-Rspamd-Queue-Id: 4133E40012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778620007-73274
X-HE-Meta: U2FsdGVkX1+fwnSMyiPun75nGJ7VdatHJ5i8V3j3BWW/FNAzjkxYhURkqyhXT5HtBz9TxZ1+ikCiMovpYi5MCK+lHIj1YypMsTYX51iTaqL7hJij0HwyHOEvsxqMr+LO2kbEUwkgG1iX4a0MWWEMW1vxJ1flzQnugyMGqugomDhrrLdhpDb6GDgYEIBwx8uOseLOTZzSpPPMDlBAIQS4FaZhyJQzTU1MsGMWK0DvMco8tyBrrCyU7ZY36joRn+qMOGgYDP894YFmzijBaCWQv8cs2GQw8kIGyHGywi8QaX/M+GflH9sV5PA8YDD+Gdl8tejvfeg2v+8E6JI/Q9QoPeMx5RxM3GCMcuWu5oHHErEdbyVtRDOJrtVbGBspsdNbj57vFkTzYxNr34iCS3gkFIqHh/BxyDMcbRHcINRXJf225BHC3b7w1XcN/Kus+pPOs+X4jySy5jnDpQc/z0yF50JwoXe0GzppDSrdeTjAmBmogZEks5egDoVqopdcf4cCc2cvVkarldXmtBh/uuHaJACkGqigJuJ27mhL/8GavPnfZFN/hrS5ZLhMstcWpmpuMff68nxjTdiPhMMBnJNHDpUvwUb9JE123h/SdPvPuinxRQ3O5B9mr5QXxK8yBprzt4CCELjFyB7HSbLDRDEo3VcyPKdIqjkhPHrC+kg/1VCG1lbcml/m2HU3/DhiqkKrc2cqPtcSGr31khllN3lPop+tljhNJOtZA9clm2ajVE9gQ/BzuMRdQ+UNjt/gGwlGiSUXVXdhNlGbcC/NH6c/A45LgOZcBW7bSsoSpubRadMRgEDansmjaJmnB1I1gR9eKfR2JHlUNMhLNAas59YuGFakPu70ND7bHcaGDclB6vE4ERAqUwpQv4BIzeTarO/P0NBefbw9z6BMOL+vN4c/nAgO/KCu9UgAZUWIGniNYr4KOKI+TUAXKDXnWQiDtFJ8yiMlo2hGi9F96YeLne+
 lYIeWYyE
 L7NMs7P5rcrH8xqL0DoKISmUKCcaafW4a4CWg441iJFGhcVLiYIWW3iMLG4W23EK6SyGambSumgxlB5B6ac9hWJU1EQrBn3yRXlrX3YXhGfD4oU4s1uJXfNzPQ5XIofDwPJjig4csTevSVprJ/KbcyrxzhfYoAzpLxvd6JRn/ruGESlWgHxHszdY5tHeXavwHHZ0Jw5yGSXVjfh6qqfsduYPi9/nG2QQRDXynKTwIfejCcV33HzO5VIpLl5enwP7wK2HF6Iab3AiV82WuwV2Gsj8OET++jctYFJyExv5ClUoqHVaHOXXElbkX3DFeKHcmZkK5lf3jIiKtqvhhce+y+/wAmO6nfeHw6ZGYK0YNVjTayUqDzpsVQ6gdycLscS2c6qVpcMKnhFZMg/8L3f1y5VwAM78e3cMUpIVAcd8m1+gXZ13nRC84aLH128bVbmg+mBkB3Da6fT7FWi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a gfp_t parameter to alloc_hugetlb_folio(). When __GFP_ZERO
is set, the function guarantees the returned folio is zeroed:
- Fresh allocations (buddy or gigantic): zeroed by
  post_alloc_hook via __GFP_ZERO.
- Pool pages with HPG_zeroed set: already zeroed, skip.
- Pool pages without HPG_zeroed: zeroed via folio_zero_user().

The address parameter is renamed to user_addr; the function
aligns it internally for reservation and NUMA policy lookups.
For pool pages that need zeroing, user_addr is passed to
folio_zero_user() for cache-friendly zeroing near the faulting
subpage.  All callers pass a page-aligned address; the
hugetlb_no_page caller passes vmf->real_address & PAGE_MASK
for consistency.

HPG_zeroed (stored in hugetlb folio->private bits) tracks
known-zero pool pages. It is set when alloc_surplus_hugetlb_folio
allocates with __GFP_ZERO, and cleared in free_huge_folio when
the page returns to the pool after userspace use.

Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 fs/hugetlbfs/inode.c    |  3 +--
 include/linux/hugetlb.h |  5 ++++-
 mm/hugetlb.c            | 47 ++++++++++++++++++++++++++++++-----------
 3 files changed, 40 insertions(+), 15 deletions(-)

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
index a999f3ead852..2ea078d4e5a8 100644
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
 
@@ -2874,16 +2881,20 @@ typedef enum {
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
+	bool from_pool;
+
+	gfp |= htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
 
@@ -2951,13 +2962,15 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
+		from_pool = false;
+	} else {
+		from_pool = true;
 	}
 
 	/*
@@ -2980,6 +2993,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	if ((gfp & __GFP_ZERO) && from_pool &&
+	    !folio_test_hugetlb_zeroed(folio))
+		folio_zero_user(folio, user_addr);
+	folio_clear_hugetlb_zeroed(folio);
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -4988,7 +5006,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false, 0);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5517,7 +5535,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner, 0);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5777,7 +5795,13 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
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
@@ -5797,7 +5821,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
@@ -6236,7 +6259,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
@@ -6283,7 +6306,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
MST


