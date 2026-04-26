Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19574FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817A96B00B4; Sun, 26 Apr 2026 17:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF806B00B6; Sun, 26 Apr 2026 17:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE7B6B00B7; Sun, 26 Apr 2026 17:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 577256B00B4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CE3AC2039
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:25 +0000 (UTC)
X-FDA: 84702046170.20.0C37F12
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3D80A0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JGSCo28A;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dr6ZqFIA5Mzb1p3xA6qD39ykvEmtI/Ko65Z86qQV6KI=;
	b=q18HattQel3oS3EKTGwxreVCbua5hY/iqPR8C/kkLZ84R8jkCSKr8l6UgztDOs2Yf2jhNm
	AM2gYDzMbEw8pAKQS1o3f17AX0gXaAamppTPGm1KkDMy1vW/UcrywHL9a82GzxcOtrmjAy
	FVT7itZ7QPZdFf7jc5IFESuzNZrTySI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JGSCo28A;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240102; a=rsa-sha256;
	cv=none;
	b=PrqgYvaAtkoLfDMf+20AOnel7M15zA0pJx9y4/6859O5/qPBv76iK8toIbXxF8Ka9EEhk0
	zRKG27UkGVSBx7wFM2SLFKBDNq6LNlwpv2NsitoyVGVtmbEHQmq/QcX7bjuBkJdditcq0d
	9LPkQcifpyiHjG+NN4Z6TpRizollqjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dr6ZqFIA5Mzb1p3xA6qD39ykvEmtI/Ko65Z86qQV6KI=;
	b=JGSCo28AfJ1KYnijS1k2he9LgnLsJqkCAqF+qbhPwZxitqCfbuCp2OsXoV5zpr5cNCEoSN
	Kb7UaDpuOHuSjX+m0lJdexkHCRDkUIw7H+8DfpyXgaM9Oy7bVoLFTxHpHrqNlQP2JeJfZm
	STNZhkUt7122/RwjESab2pB2W/3Tw2w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-KEIZ7ks5P1itTa6m7H3r9Q-1; Sun, 26 Apr 2026 17:48:21 -0400
X-MC-Unique: KEIZ7ks5P1itTa6m7H3r9Q-1
X-Mimecast-MFC-AGG-ID: KEIZ7ks5P1itTa6m7H3r9Q_1777240100
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a5c837c44so34605555e9.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240100; x=1777844900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dr6ZqFIA5Mzb1p3xA6qD39ykvEmtI/Ko65Z86qQV6KI=;
        b=EOBv1agp4J8KaN8TBd/1+S1X5u54geUn3oHWn8tEHotETmvuGSekMSOphw7ntDcfrN
         lceV48C1gawzR2iRZI7qeK0yLlCf7Q0MyQq9vWyAzQXcHMmGqTRHpsyTv7RNi6rFM7OD
         4UsXFKBHcmpOhcyI9lKZ8wvx95C3OqSHQBYI5Zfp/cUkJZgzqf2EwKGd2p14CHa2pUvI
         hIlDeBYs+ygSqtEAdX2+kEb2uYRn50VXi1e4qQRvbhC4AkTxwYM1UrMm3FdPxPrWkkCy
         tSNUJXZVpeTYq3w6je+buwcLcXmv9dxqE1MNj7az2efDGQK8TBJZZHBsSNqxmiyzMPBk
         iz7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+Wj4pDeqAm/SopVmKRU24yEYa7nUpcGRcwDqCpBVrA9zpVDeunLgwiD9w62+FcMtDRL5bbclyZTA==@kvack.org
X-Gm-Message-State: AOJu0YxRFJ5WXG9ZsOBd7qkh1DiPVGmnV4ZpdmSRaj52cboYerzIa8YM
	Yd3ax4E6+XjAtL1M2Pwu2jxUF8LHsMC0YAPbcCQa5zA4SoPtwFwAa3GVOAYgkYYdju8fQX+nytH
	K1HOYn990MAVp8fipfmcx63zv0vVIjY4H5KaY+7EEHaHVC+U1H4uw
X-Gm-Gg: AeBDievhOkwP3J1uc8a4PSaDRPJD1kK8ZupTPOouU6zOvHLQmzIe8rX5nXm9wJcP9xa
	b5x5XY2bvNo8AoDiL828vCvBkzXB5GZA86XEKXjUDDppYSthZqh/pNfM+A4pFtXW08VPivebxzC
	d9uVakXX5lZ5LizR0nxU0ugZrq12rEmOGECZC+mw1mdP6st6S7E3rkriYPBTkT32hDjkyjXHYVg
	OL2L/HWmZax0jxMFxBMHnkBMrQFmkvKxh+EAYx+wn22mAGphlqC+cQQV4IdK+0gBphbUnXhlPkc
	GrFYJBoB7bBoblh2+1B1R+CCo7cs93vt8FY4B4QspGAYyjDHauszBdA6uq2OWLVHgfSwzw0mvoI
	kwnKPEHbktHaE6uOt7AFzN9n5ZV4orbr+g84D+0hnjXpnQEJ0fEDA6Xnv
X-Received: by 2002:a05:600c:8909:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-4891b10dd45mr420917105e9.0.1777240099542;
        Sun, 26 Apr 2026 14:48:19 -0700 (PDT)
X-Received: by 2002:a05:600c:8909:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-4891b10dd45mr420916875e9.0.1777240099012;
        Sun, 26 Apr 2026 14:48:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7aa593sm236693945e9.24.2026.04.26.14.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:18 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:15 -0400
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
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v4 14/22] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <788d5a09394ed1456beaab23f75d91846ceeb611.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zqaDlkTng_HoWIMT2piwLfKq1oewcJyBk7_dwDKbo6I_1777240100
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3D80A0005
X-Stat-Signature: i41rtkgbfwtyt8mhojac3x7f99yj64yc
X-HE-Tag: 1777240102-219661
X-HE-Meta: U2FsdGVkX1/nKI4WQ5D60kOJdZrhXICyxc0oczrrLY1W5bfCu1y1Wf724nAd+ThHWnwxJYGtEYT9yiACc2NIvyA69Y2fvVGXgj/6rvdwt5/De/ZLdd2ZTvqN9HhlnywQBTXLF6wrRVvp+pxIBvdjplEnACOgWFz2EQq6O1/I5kt7TU6YdmY7jRwjTH8I5TIKpZ6qj83KAtyX1tOD6S4ul8vQ249APJMR3+a3Dvn2gQJUeSzE8rt+S/aHPfYkIw8QaerGp9w7pQEsnZvaCkW5SH7j/srwuJGZiqGR42dJ+c3xltYvvZY/1uEq5bF/oWwybm2T1vjgIoPC5AwYiKq/LhFqyjuZs75/f5aWw4egE7HBQ5GgNSdgMLXcAVdPdkRyoqKOmmmgBe8bCx7m3XyU1R8wTZQCz2R8rbNwYipFNmF4ScV7vFbEpRv0HD1a0mXR5mCP9v4TyX40ivbiOXx8bF0GWmcnrjv7bv9BrNg8BSUARCxdgZsYP+cqSomdiICcH1HKNW7vZaCfyPEhAVzezQmDmGfGrKmaO3BoEAP5Rm4iJYkkRjIWbI0c3B9F4nNmBwoK6tpKbokZ76r431rpiDN2pZPV5283f/bh8p/IQKiXTHitqt66MJJKRMwntIDQOw8twSzzDk3JehXthLOn+SQDdUEVmLBtksKArs0xgTS1I0J/Mb3WbEkRXgYF1RcL0BIO2Oct0VP2hnMEJOGCxjYxcKi/fL3sKlUV7ztX6RqjJXCTheUUZ3DPPVKJKqxPTcr/bKtipAagMLuHGtLDcJoFEr4YRjsUC/LBmhzaCUd7hRCVtQ4b4SKbQH5IRu4IJvPHxOu0plLlpoScg+eL+APxDkqlsJZiKrBNuxLnFZwo4qgZJ4n6z+7FxkK2/cV5fBuulElM9OldcfHCdGjRgqLdCD6oVdqnaQhVaz82dO01kP5bGlvNSMqy0T8YgBqQQL+z6dcqX2KdHm7e9fn
 1p66TtV7
 kyiuyave4D01gaJzTDe+SlQn50V9/TQubqhvuBs/MnKm5+xqp/igyyV8wHPLjipxYdXStPTuK25yB4oH5X2fWiW5i7zX+dquAsYRW9Msb66Lz1BbsDLTEwEAS1SBQQiDy0VnKwCJK+e42e0lFT5g955kNHWrKtkTkFJ1q/ZgksOKwAEUsUZvBU116sBspaaksCRv2gXcZ8z0mxrbEoGSykkYvGAOX9LabRTR9fPh/vHZptYpK0Hkp5aa6uTrZ9bdvz7jx0moBOlzgeeAPDN7raui+DAI5ZCYyo6LMwxSS1tTSnwR+gmVOafdmef+mj4OkOmpjcyVlL8hZYw6m4vV5aFGCAbWqcelKzhcTjpwbT3K2q1o9aGRdpwckrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a guest reports free pages to the hypervisor via the page reporting
framework (used by virtio-balloon and hv_balloon), the host typically
zeros those pages when reclaiming their backing memory.  However, when
those pages are later allocated in the guest, post_alloc_hook()
unconditionally zeros them again if __GFP_ZERO is set.  This
double-zeroing is wasteful, especially for large pages.

Avoid redundant zeroing:

- Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
  drivers to declare that their host zeros reported pages on reclaim.
  A static key (page_reporting_host_zeroes) gates the fast path.

- Add PG_zeroed page flag (sharing PG_private bit) to mark pages
  that have been zeroed by the host.  Set it on reported pages during
  allocation from the buddy in page_del_and_expand().

- Thread the zeroed bool through rmqueue -> prep_new_page ->
  post_alloc_hook, where it skips redundant zeroing for __GFP_ZERO
  allocations.

No driver sets host_zeroes_pages yet; a follow-up patch to
virtio_balloon is needed to opt in.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page-flags.h     |  9 +++++
 include/linux/page_reporting.h |  3 ++
 mm/compaction.c                |  6 ++--
 mm/internal.h                  |  2 +-
 mm/page_alloc.c                | 66 +++++++++++++++++++++++-----------
 mm/page_reporting.c            | 14 +++++++-
 mm/page_reporting.h            | 12 +++++++
 7 files changed, 87 insertions(+), 25 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..eef2499cba8b 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -135,6 +135,8 @@ enum pageflags {
 	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
 	/* Some filesystems */
 	PG_checked = PG_owner_priv_1,
+	/* Page contents are known to be zero */
+	PG_zeroed = PG_private,
 
 	/*
 	 * Depending on the way an anonymous folio can be mapped into a page
@@ -679,6 +681,13 @@ FOLIO_TEST_CLEAR_FLAG_FALSE(young)
 FOLIO_FLAG_FALSE(idle)
 #endif
 
+/*
+ * PageZeroed() tracks pages known to be zero.  The allocator
+ * uses this to skip redundant zeroing in post_alloc_hook().
+ */
+__PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+#define __PG_ZEROED (1UL << PG_zeroed)
+
 /*
  * PageReported() is used to track reported free pages within the Buddy
  * allocator. We can use the non-atomic version of the test and set
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3a7c..10faadfeb4fb 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -13,6 +13,9 @@ struct page_reporting_dev_info {
 	int (*report)(struct page_reporting_dev_info *prdev,
 		      struct scatterlist *sg, unsigned int nents);
 
+	/* If true, host zeros reported pages on reclaim */
+	bool host_zeroes_pages;
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/compaction.c b/mm/compaction.c
index c1039a9373e5..61209cd408ea 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,8 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	__ClearPageZeroed(page);
+	post_alloc_hook(page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1832,7 +1833,8 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	__ClearPageZeroed(&dst->page);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/internal.h b/mm/internal.h
index 8e4616e42b4a..0600d824ba03 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -889,7 +889,7 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
-		     unsigned long user_addr);
+		     bool zeroed, unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ca4f9c0948af..eff01a819744 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1774,6 +1774,7 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
+
 	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
@@ -1846,8 +1847,10 @@ static inline bool should_skip_init(gfp_t flags)
 	return (flags & __GFP_SKIP_ZERO);
 }
 
+
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags, unsigned long user_addr)
+				gfp_t gfp_flags, bool zeroed,
+				unsigned long user_addr)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
@@ -1856,6 +1859,14 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_private(page, 0);
 
+	/*
+	 * If the page is zeroed, skip memory initialization.
+	 * We still need to handle tag zeroing separately since the host
+	 * does not know about memory tags.
+	 */
+	if (zeroed && init && !zero_tags)
+		init = false;
+
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
 
@@ -1913,13 +1924,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-							unsigned int alloc_flags,
-							unsigned long user_addr)
+			  unsigned int alloc_flags, bool zeroed,
+			  unsigned long user_addr)
 {
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
-	post_alloc_hook(page, order, gfp_flags, user_addr);
+	post_alloc_hook(page, order, gfp_flags, zeroed, user_addr);
 
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
@@ -3189,6 +3200,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	}
 
 	del_page_from_free_list(page, zone, order, mt);
+	__ClearPageZeroed(page);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -3261,7 +3273,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *zeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3296,6 +3308,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3357,10 +3371,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
-			int migratetype,
-			unsigned int alloc_flags,
+			int migratetype, unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
-			struct list_head *list)
+			struct list_head *list, bool *zeroed)
 {
 	struct page *page;
 
@@ -3381,6 +3394,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3389,7 +3404,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *zeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3408,7 +3424,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, zeroed);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3433,19 +3450,19 @@ static inline
 struct page *rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
 			gfp_t gfp_flags, unsigned int alloc_flags,
-			int migratetype)
+			int migratetype, bool *zeroed)
 {
 	struct page *page;
 
 	if (likely(pcp_allowed_order(order))) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
-				       migratetype, alloc_flags);
+				       migratetype, alloc_flags, zeroed);
 		if (likely(page))
 			goto out;
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
-							migratetype);
+			     migratetype, zeroed);
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3836,6 +3853,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool zeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3980,10 +3998,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 try_this_zone:
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
-				gfp_mask, alloc_flags, ac->migratetype);
+					gfp_mask, alloc_flags, ac->migratetype,
+					&zeroed);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags,
-				      ac->user_addr);
+				      zeroed, ac->user_addr);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -4217,9 +4236,11 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	count_vm_event(COMPACTSTALL);
 
 	/* Prep a captured page if available */
-	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags,
+	if (page) {
+		__ClearPageZeroed(page);
+		prep_new_page(page, order, gfp_mask, alloc_flags, false,
 			      ac->user_addr);
+	}
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5193,6 +5214,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool zeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5201,7 +5223,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &zeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5212,7 +5234,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
+		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6983,7 +7005,8 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
+			__ClearPageZeroed(page);
+			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7188,8 +7211,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
+		__ClearPageZeroed(head);
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
+		prep_new_page(head, order, gfp_mask, 0, false, USER_ADDR_NONE);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..6177d2413743 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -50,6 +50,8 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
 #define PAGE_REPORTING_DELAY	(2 * HZ)
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
+DEFINE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
 enum {
 	PAGE_REPORTING_IDLE = 0,
 	PAGE_REPORTING_REQUESTED,
@@ -129,8 +131,11 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		 * report on the new larger page when we make our way
 		 * up to that higher order.
 		 */
-		if (PageBuddy(page) && buddy_order(page) == order)
+		if (PageBuddy(page) && buddy_order(page) == order) {
 			__SetPageReported(page);
+			if (page_reporting_host_zeroes_pages())
+				__SetPageZeroed(page);
+		}
 	} while ((sg = sg_next(sg)));
 
 	/* reinitialize scatterlist now that it is empty */
@@ -386,6 +391,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -410,6 +419,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
 		/* Flush any existing work, and lock it out */
 		cancel_delayed_work_sync(&prdev->work);
+
+		if (prdev->host_zeroes_pages)
+			static_branch_disable(&page_reporting_host_zeroes);
 	}
 
 	mutex_unlock(&page_reporting_mutex);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index c51dbc228b94..736ea7b37e9e 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -15,6 +15,13 @@ DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
 extern unsigned int page_reporting_order;
 void __page_reporting_notify(void);
 
+DECLARE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return static_branch_unlikely(&page_reporting_host_zeroes);
+}
+
 static inline bool page_reported(struct page *page)
 {
 	return static_branch_unlikely(&page_reporting_enabled) &&
@@ -46,6 +53,11 @@ static inline void page_reporting_notify_free(unsigned int order)
 #else /* CONFIG_PAGE_REPORTING */
 #define page_reported(_page)	false
 
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return false;
+}
+
 static inline void page_reporting_notify_free(unsigned int order)
 {
 }
-- 
MST


