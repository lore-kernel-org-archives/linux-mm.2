Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D615CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E0D6B00B4; Mon, 11 May 2026 04:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A056E6B00B6; Mon, 11 May 2026 04:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BB76B00B7; Mon, 11 May 2026 04:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8126E6B00B4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E3D58D6B2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:30 +0000 (UTC)
X-FDA: 84754527900.14.E8A37C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id F2EA2A000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E7MOHO6p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
	b=cXQF2LyPxbxQSd9nQ8AGa9N7U8FOFyXL+cJPGirtnNFyUWKFhRrVeEOiOCR0jXFAKOKnWe
	q8Fge+CrZHKByXR+vuWH+f4tKZYaRg9G4R4rENmVJ0F+yZJM7bz1nYjt1X1kA5fe2hoD0L
	A0QOJF4Mz8lOCscBXHfxgj+eaDz8tbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489668; a=rsa-sha256;
	cv=none;
	b=0Zj/Fn19CHdZK6Nl9y4PaL/KrPTWBZsy7QpEKO+k8ReMjLaho5Cc8MYZAEBMTnIJrpGlkx
	ihVPI6TVYcAmLsxBhDwdLsI9joFCFk+oJSuMFVK9+SfKOnDL9qFu8NgBp0ihfrEwkRdjIk
	SjEQPRo0XIWkacIWH0LGkRtrIalK3mM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E7MOHO6p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
	b=E7MOHO6pHYqPNs6AY9cf2I0uWd1oazsIVznURSfRbctAVHeRtdQGx2JiZP2k410/GjpXO4
	gDsXYfK/tOWl+WMhV+swGcTd5wrtp6lAM0yeF3W+vl26rMlDqUVaXeVUvqCds9YoHgLKMN
	bUQL8W4/lcShfTz55mBDbsiQaVAXN0A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-QDSjw3LVMFKuoZ0mYlLZRg-1; Mon, 11 May 2026 04:54:25 -0400
X-MC-Unique: QDSjw3LVMFKuoZ0mYlLZRg-1
X-Mimecast-MFC-AGG-ID: QDSjw3LVMFKuoZ0mYlLZRg_1778489665
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7730e9e3so2633552f8f.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489664; x=1779094464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
        b=lWqd3YzTPqlZfAIDhY4AiBqMaCdRUl4zIWg0ljdyrpNXv3X6CVp/kbwRC/8s30mTGn
         /76JqAWRBoq+vZyi6CklexL1As5p7tUcZICbg/j5olcEaTrBkRasnXUg1MkPK4WvcTRz
         weunMvLsruMQXVA/0wNbTaFnCawWQHPV12ndoAEdC6cTCHT2PGJDcYsgOwNQuQW780+F
         u2Lng5GkGlh4vX6s/j/bwA48EyXPSWGUp3xgv/ifScbFvJzkyYN2EzfLj41zsb//I7bL
         ikLHQWqCbbDhleWpHhshmWJBd3E6Kax0tmDTDRZ8Yl9Sx+tJz8PpFbSMkRE8+pVQmld9
         P9uQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Yz6ilWgqTqodi3H39y9d9LwYZ60idyoRLy42Rxq8Pq8J+TctVLFKfUmreDNwC32Of2gLZL/YdNg==@kvack.org
X-Gm-Message-State: AOJu0Yzh+9AwQhbWK2lJxzVpmV9VsjaWaMI7zZLCzP4oINbcnKDXALLH
	Ux5tOBFyTgIQ8D6kYUoPD3gmkci0j9QbfFKasGSQB1HFKY0YeIMrDM8fxbe74hqJ2UwMHYhe7uV
	QE/SchlnpN9tXmWcdkeDx11FA/rfixxuB9Y+B7VIIGt8auzPfu63Y
X-Gm-Gg: Acq92OFXp7KspTQJ6tpGSmkgJV+uLtGq+KjDD2X6H02Z7e+u5qTPSKufWzLcPbskYCW
	n/GjSZN2t9Jp7BK8Ef3/sYxXEezuLqKB/9xa4wZ66zYYMbRS5qQnRjFlLJAxyK8jd33Tfa8OnJi
	Xfxz79q8ifALt4FO12hQCGeaneo1NM4eSB76UN18bKcwP4UfQrGUDW2QAwHRp9PNxuqf5L6ekZI
	IGe18yaLmOiQPuvp0Tr/APx0KI2SYLY9JTZ8awcoNMf19hSMY6XdBmeHqpm0yWKjFCyRJY2r2ER
	dDsc8Pv569CWgLBi55ZJT/1V+BbhQsIy7o5eN+ZwMMqXwrRV3Q0dhOXFoexZzVeAE0qgRf1ZGaE
	55ioh7XEFLqiJdjpTtmFmyh9tvhMSfBVzLJnhMBnT
X-Received: by 2002:a05:6000:2309:b0:43d:4b00:9ee7 with SMTP id ffacd0b85a97d-4515cc31df6mr38451200f8f.33.1778489664147;
        Mon, 11 May 2026 01:54:24 -0700 (PDT)
X-Received: by 2002:a05:6000:2309:b0:43d:4b00:9ee7 with SMTP id ffacd0b85a97d-4515cc31df6mr38451128f8f.33.1778489663387;
        Mon, 11 May 2026 01:54:23 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b071sm23662062f8f.14.2026.05.11.01.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:22 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:18 -0400
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
Subject: [PATCH v6 13/30] mm: hugetlb: use __GFP_ZERO and skip zeroing for
 zeroed pages
Message-ID: <cf506f22ebca71906dfe609f81a050f563ede335.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K9e-3e3yDPOwJnAZis_QrE-CID_zgTSxS4OlBgow34A_1778489665
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F2EA2A000A
X-Stat-Signature: pfqcdu6isaus6q3qnjf7kbujqojxh6cg
X-Rspam-User: 
X-HE-Tag: 1778489667-631356
X-HE-Meta: U2FsdGVkX1/l/TM0zcg/OWf6sdnamJxMQrwIh9cm5fXIbPUX3YYtW0OgluAOi4pZyJbJUR3DuSuTIVqzR5HifICAhd99KcBu/sZsbGY/4lZaj70SDOHqHNdpZrPqZC133iMYfCNajFSRcFrRcIehXChtIDzH8JJu720W3FeCUG041QDkAMQbkT/b8EQt+zPKhtkZT1tZEzf95wo15q/uSZxVeviWR7gGOMfCCVocCCJBaT59aBBDaa4rc7PXdKky39E1QE+s+Ce3/TwXX6O8GiDBRBPnMKI/B9BliRl1WVKEM9WYnRqo8Oy1g8uorlKTrKSDeXulOWeEaD6bFs8Cz9pIUX2ezz4MUVTjrDjpEAOADHEw30EP2RApyZBeTzFBFXY+kdnh/ZL8v0BW2WyhTjNaugnGxtJElSlXSVY9kHgzjo0DIyKAuZBW3l/vOBl9MTOoNFoJ3P7/71emq6lwiFGHmXADHpV/gCslTI9TyBv0B+0IZznTqB6FXIXmuNs/NbHKe4OvOMXkDIS3ev4Wwgg998N1VBgrNIsGmmBXloYymMNWLu8pGTSGZ93uu5IYxhSmjGdJx2DHUgPNzkyf2sfdyfIVQbsoqOHV48v25HHWrGWMRFLDkXD6DXpmC/sv3Q2Seh/lIWQ//KKO61lDvERhLfTig4dA46zyUx1+n7yyWA09CY2Ju1vF6rv42G0UNRv+OxTvD5027fn1rpKh3QELqpmJd36ITie9TUznq6XSVvXpZMVDe050BkeSHJcV0J5gCBOtkdl314m+NQkn7BLdTe6kxq3jWgKc3ZUglLKVJcIF8C/AvpjLVzzygbdidSBp7TfrGzgb+0B4aBqVZYGWEYlNFVXLz9FFBj+rx9+5qU5TTJSk2yq5ug1ZBoUnjMu8eW5JSbAN6FIwHKTL4KxmlZdzLvBJvoAS2lkujZvQsCICH7rZqMjbKLvwRoTS518ZGtG2bSROvb7nURe
 gxA2F6EF
 KLGgI1kWgL0tYs/6UwZKtkUGwQvQ0VutvO/YndCsyiPKfxnKgoD6hU9B324bfVYE1EEQ2fEqF3byuLyfdf+HOB5S0lkD/b0E93lSYBz/jG2r1YI91jjXyywnR9ygGlP72pATIrKpMq3ZIrq50/cBQ/Rq7a+bZrP1JEHZS+4KEpxt7lUXbaz2JG7aqWIr5yBJw+aF5gC8lvXmEC3A+RvGV8rY5+WnH5q54fhvsx9L2ZkxJNuY17kFqZ+1UXpIfKZT4GNLnlrrBPGquJcTCrVPENVUS6fFtrYTBrv87y93puXGi6lL3/+q6DEgVXLsh9fFZsPq/Yw48EK+8proXX0VvvYhbY39vdXaSm4f9RVOxPDL99cLNJW3hBA/e/BlZCljy0Hg7J2ciWA+cvizinn6M/lISQEizVRGgn1h9RYFu9T37Grs/o8qoS3HrFM6iShGLUjpr
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


