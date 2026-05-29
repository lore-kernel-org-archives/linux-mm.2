Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2E1CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4586B00E6; Fri, 29 May 2026 11:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A641B6B00E9; Fri, 29 May 2026 11:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9319F6B00E6; Fri, 29 May 2026 11:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81A1A6B00E6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C445F1201E7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:12 +0000 (UTC)
X-FDA: 84820828344.18.2EB3828
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 908D816000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1rDkGx+;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFnBVDBDzVeV9p9dYXmJ4JPUR3YMu/6T3H2GlWvoQjs=;
	b=pAlN6mxIHJ+IFLN4RGKfWgjjBvBGLSICMjcFe5sFLwHim7pVimLIBLzfeB54bj6XENaN26
	g7LAuVJ/UiPsNgJ0oqYS9V6uIdPMzTDyewu8vUeNWYPoJHmuejglvQ2LcoAFZ0qxBJw7zh
	VWuTkXYfbIe6H8yqPRazSvxMhrRPrrA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1rDkGx+;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068250; a=rsa-sha256;
	cv=none;
	b=wOojDO7R85m9jJUXZf4MP7ErfgH1kWFxhMRB81uGl0BrGmXvBHhWQ+ES7wdSssksMz29Hk
	xiSNJ4aT1JawDkS3PChYhyd6u3ATit9ClaytpxppmcdHcTNebwHFuW8KZ164Vbmb2u9NwB
	mRzLM4+L4U5ZZIG7qgHBtN94m05Nk7U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YFnBVDBDzVeV9p9dYXmJ4JPUR3YMu/6T3H2GlWvoQjs=;
	b=Y1rDkGx+vgybkYSA0eHhqScEYfbjq18Eq4ln1deiNEyAPONZEixy18jVjqfT/cTf1HO3kk
	4hL4yJL2v6riSxiIebrW0uPvLzWMTTvKeF+DjvotMkozORVeUx4cO9qibTJpSxv8cZ9sGM
	8ZIU55mHaYg9GNDKVWJN5GKOaqaG+3w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-g77pzJPUMha9ojqJRgyTlg-1; Fri, 29 May 2026 11:24:08 -0400
X-MC-Unique: g77pzJPUMha9ojqJRgyTlg-1
X-Mimecast-MFC-AGG-ID: g77pzJPUMha9ojqJRgyTlg_1780068248
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ef55779d1so241384f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068247; x=1780673047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFnBVDBDzVeV9p9dYXmJ4JPUR3YMu/6T3H2GlWvoQjs=;
        b=KG1LXpvaCOTVE4B19MhKqyITtt/BA6mn0ZbdYkmbYp4olKzxz2NYu6cKfwaylSO5Af
         vMcI0c8CjohBUgGyK1y+29RkyaoPO8AKpazx6eHbqUqQb+sBil+3cFG4G99AHamixtta
         aUs4s8S80xtd3kHrYERx94alJetm6OYHg6ueJJpPdbAhc77B2m2VoAhP+ToJhHa3L869
         /rKxoO6nUTv+TJ6cPd3BUttqRpiYBNGmD16o7Nu4L2s4syvzMFg2HpXfs2I8yt8sMrib
         2Hr/IrVd3oCAFQeMv9MOGxg3tcEqDxT6+IT/JyI7+OfhUBntmBZflJq5fgqJLSeaz9N2
         lJjw==
X-Forwarded-Encrypted: i=1; AFNElJ8o5KOJlbdLRSS807QcA1tqYeCuq8x5VGFtKVcvd6z9BdIbF9by2zvBxlhvy+jW+Yj9cM466rMrbA==@kvack.org
X-Gm-Message-State: AOJu0YyReXRC3Q2GI2fBkpMvmf1Q2/YN5H6usGC8gVbJiHTC/eEmN98u
	naEsOpvA2vFCwbHvOFrF0gmOo5edvTjq4zzvB0aMorNZ7UJ40iljUvwgk2Pb2iLwxdr5TDyrOiw
	KXgY7wmTBeAC1Ndg4uZTLJormufeU7j11tBq1yjtnFicpUnvtzFC/
X-Gm-Gg: Acq92OF3Kkef15IsEXxChgCHvqdI2fEzk91bQFBlc6QE/GhXU9oWtp7I0AJtWIHcJOu
	MUZTMDSvaYLoI9DjV0nUvA/4FldmEDiR8rF82tz0oTslbVqgqE1c+1ZNyO1E7nMDsxabXTV/647
	+jW0LS0uZAcJNQyZTOwnrod2JTZowNpwmc1KN86sl7DLgPNIGi5GYa6zULjejZPyaNFzqXZnboh
	LdtioGblSzF+IPrBzoVZSjBqWPtXm9jH4m7FlfX4pj9fiGTMqlETt0Tm5ov43ojzOUmE4GiQfX3
	TMG25uxm1z/r7mFXyrjfXTbEYh/xu5ucUKzN0yyzE7hPkEtBWOA2e7JvUw2pVU+sM70YceYQMP7
	BE3hJ3Cnfl3YtBXcPeEgTTLnP101+8bbHuWUCic/FCjLWUekjdEvWrw==
X-Received: by 2002:a05:600c:6385:b0:490:40f1:5314 with SMTP id 5b1f17b1804b1-490a290ec08mr2724765e9.1.1780068247457;
        Fri, 29 May 2026 08:24:07 -0700 (PDT)
X-Received: by 2002:a05:600c:6385:b0:490:40f1:5314 with SMTP id 5b1f17b1804b1-490a290ec08mr2723495e9.1.1780068246818;
        Fri, 29 May 2026 08:24:06 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c09abadsm16343845e9.1.2026.05.29.08.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:06 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:01 -0400
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
Subject: [PATCH v9 20/37] mm: hugetlb: add gfp parameter and skip zeroing for
 zeroed pages
Message-ID: <783540fe912fe437c98385c1b288a7695ef45ab9.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YsTeXeLfcd3zkZthe9nIbWwOjcNwI8QTcBiC2IxLg6c_1780068248
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: 6qtoz1ynpokaxfcsbgi9i9gnc8os64n6
X-Rspam-User: 
X-Rspamd-Queue-Id: 908D816000D
X-HE-Tag: 1780068250-559816
X-HE-Meta: U2FsdGVkX1/bH2iFNv0tXDGQnUYNwTq2aoNIOq1XShvnNVdVccnpa4r2pmN8mTXu5n1wBD1tj+IW0t9izk4IvOTz5ZVaXVQpF/MTlYrCAwsPnVSjDr4Xk2xxOupzAqJNkRDvJ1a0lcCmklTFoM3H1M2ae6844wBTRFYo1XVKzRfJboV/aNCm/4ejRl6t5jW8xsBHb4iUmxfOf9cf8zGw1D5lagvOQZWsMDG1u1QjEo7fT140cR6KOYVJHMYzUChhJx/UWnFnGtCsclT8+FQWrqTu99MmP+Kb7ecA0o4KvkB1bXFDOWFER/bCK5VF6sVFSFHYqODP0C5ZYwDPXPNcLPPjbGXjtgF2QB3SjfYW/Lgj9DC6BH0Bgr+FE4ozv/Xu/+M9nEkwMpQV9P35waAjeECX55AHHkUt/cpEx5jMZkc/MBBB23CuDIj+SJQpYAhiPZx7rbrOfQNCCwEl69WTkYuMy11XB4KOkIE4ZG/qNy4+u3RzHTLGgA6MojV7ojqAOKLVlYhWqcqJTHEKJTxdIT23kImAfccFK/9FRx2c0ziGcfu4Vfm1c0Jb5WLD70vV1LPADIOjm3F+GFNxBGTrE2I3Qp3E4DBfXpLYHpQ2Pash7bXBnxa35LP28EmFSETMGC7/sBqMZ+m1Pau2T+Bus+BwiD1xLfLX6VTE8XPVoHnP2d//qXtJT5FrCGklKboxn4g4UFAl2J+ttFn5GSgDwnBrLf0RyG9KmaIeBe8eASVqE/UyIDhpo1Frba4a7qSDgUKzqwUSqW/Z0ga4t+CmUntjHbPgXepEFz1YqbhWtZTdicQjn3OXCch7emYF4mgsfqV3OSPUgjmq+WSMBZjlAb3RbhlSXcdNl1ly2SnYGbwEsIbQbbv6FFhKtyJLoQCGjNdhqGp4QpbXoDFd1HzCiP5m8fnvbqwuIx491zxYg9pfWxMO8+aRikFZTjcldnfjK9JwuaysSRL9LHEc9V4
 tqivJAZ1
 4LmlZbMSmdGYgKzCktJoTKAFyMIau6FI1D97MXukdRUYPnLS60zxgO/upIfeq9J1G6GQbw5gA0KpCbSjE61jHjNP4OP+KXfs3jAKtudOsMHau1GuWli8+P9ZnmNxer8sCiBXcWCZTfsc8jmtIKnCjZzdx2LZn0s/8ZlwKZcDeaLZJUe22K8J+zQyVey2zWWBbhwOIj3ZHEMaLsUSR1Wyu0NjwE9iCNNqmKmpfAzQdopmCG+mZv5XntrLeOM9HtF8W+2dOXTrh/0IWtwxoun6Ct3QGfYAL2gbQime9RerdvVl30wRjUPDT47YFrLRHs3YXG5MFecgDwHzeXdvQjEC+6BcLGzz4mledhk31T/R+Ab+F0Xq/JinMgcWIxtGVxBKPRR9MOC/G+7O058PQU4CoXmpokJoeph4y+ByN800WQth3EYIJ4hx4O2M+2z+uSCMv8iN9VYqBjpjDw+XQ8ZbKGtaXG2IxEhWEs4JJdX+Kxg2LyVoZf+DIBMVl/+qag+hbyi1EyKjo/A4VC9RMCFnCh05/Tmg7ojjHyaqV0pBhno4QGwwBxMHyyaCHpEyQxkBxUZgP
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


