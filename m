Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A20ACD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0141F6B00CE; Thu,  7 May 2026 18:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D506B00D0; Thu,  7 May 2026 18:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43866B00D1; Thu,  7 May 2026 18:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1F4D6B00CE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84A061A064B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:20 +0000 (UTC)
X-FDA: 84742050960.30.3F2A6E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4668680003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EjsIgRDg;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1oE2m6ZJQCRMesu6P3aMUgnmuqGZRVXH3PwwJINZLk=;
	b=syYk3lWaxd6IJXsbvILWEyGbNq8KQUIwMcSxkBLPOYkwCzNNqYxXVHGtlkr9izbIs1BHqD
	2y3EMRZ9qC/EpLPJm7d1VnAsFalWjMi7TI0tcgGGAq2bXWsdXsGlfNJGRkZEZQSSm/ask+
	Q5zWasS19j/tmxzoJlmP37KeeC/UK6g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EjsIgRDg;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192598; a=rsa-sha256;
	cv=none;
	b=ymhcKD71KlYJxMj3RHIRTj10/5lxRj4ssRgoC9zgWQC1SVAB3bvib/q9xCPry5bkdrEp/V
	N39Y1lGuEHxwDdBpMV7oeeIvek8HJoee0YrF1JX7zcXP2uspBZwrvqMYhC0c5LzuqopQvU
	JQOaGxtNe/h3cH6kbssLLgFaMkRopyE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t1oE2m6ZJQCRMesu6P3aMUgnmuqGZRVXH3PwwJINZLk=;
	b=EjsIgRDgcJPwVTT1LMkutOFq2uLwbDz8dxACMPMKcX2O9MhxpFBaBlgAfK6qBD5p1QYxNP
	8e+01QeG8Ua3uLgyOJRM6N67sLj7JhzqvUZDlV5up8XpvxCFa3CCw6owdza6zdWBNVJCR3
	a7iHD5N4/tK4k0QgrfGeGNIFgBU+cko=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-kGvyROPKM_S5EEab7woyEg-1; Thu, 07 May 2026 18:23:16 -0400
X-MC-Unique: kGvyROPKM_S5EEab7woyEg-1
X-Mimecast-MFC-AGG-ID: kGvyROPKM_S5EEab7woyEg_1778192595
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44a52d5e572so832532f8f.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192595; x=1778797395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t1oE2m6ZJQCRMesu6P3aMUgnmuqGZRVXH3PwwJINZLk=;
        b=TQ6IwVV0jjhSrygiO+6Nv6YVz8KJGfFUkkRyQTKsdOcvOih4FQRaPZywdF5MTvrriR
         K3j5nLNIoRFeW2zqNp363m6upL98egnwbjyVY8FDywFnDITqKXr04rNSLULpqk39ISHp
         sBzZhzVnXffTmitxGiw2s8MmCddLi9GhjYy988NmoVPnEK2xGigKneTqDcNATZeBbyPj
         abBycyVCUoWM8T5MFcGeZlZTL2S3dGPzaCRbFup/EocpdRtdg40AGMr7z70lXZHnjDlU
         tOksCKtkzZ7at5V//UXpErWIOSeU5d3JJaNSZxhdfUr8wCmq9FxhdbYtV2HtUgGvuaVI
         cyQg==
X-Forwarded-Encrypted: i=1; AFNElJ8lShbqv/wCj5rwqLCbZGhuF4lvz87ORluEcGfSrwue5m1F1IUiOMZ/xZTvRZStiXcXPXkV+K/+0A==@kvack.org
X-Gm-Message-State: AOJu0YxgsUQDiHSRh02gh8bLrWR5XT8jerP+sLfCP9L4tHH5E+hVgMZE
	PhHhRRGJGDsSlZPRB0Y3XLlyF5ckQBfGY4wQEk2eXOICUfCu1OtwiZtf4Cqyrxt85XL5vUJeBxJ
	eNdrmG9OMBYEYjLdH1onbsk6cs4YAmlHgQ990ilewevRt065nfgkJ
X-Gm-Gg: Acq92OFE9uOyIDnV02CzQot98YdIgqOhuGvJqXyHUoC2DPlitVK/BVN1drfwUidSEvU
	m8yxbTE4/ODenFKfWQ4i1Wf27ZRclCKJJNE7/yT+DS0Psl1a0SPWDN968zJovvKWQleSezom8hR
	nHCYhgoYCCPjGh23Q0PQCUgxiC6MHrIoxteJquM7sbcZ7f8myXfFQgMkNnElbeDgCTd3Dxg57Ar
	UQh0mGoBpjC+9YQYgPBPfhZjbyS+HFO3YN96f7GjcJOXD6q6sX5xtambFHLyHDPKiD8cMrhKso6
	YpVlqHTt4N/OxRKYCzgWD/HkTO3kIOOCvcogGXkiGWYdxbef7dvadv0re4R7P45kn84a/8yDKLc
	+u0BwfMOZIrLVtvEZTM+9pSEXUB3QsWwCftiWnVOw
X-Received: by 2002:a05:6000:1ac6:b0:43e:a9ba:b194 with SMTP id ffacd0b85a97d-4515d5c6b69mr16657080f8f.34.1778192595111;
        Thu, 07 May 2026 15:23:15 -0700 (PDT)
X-Received: by 2002:a05:6000:1ac6:b0:43e:a9ba:b194 with SMTP id ffacd0b85a97d-4515d5c6b69mr16657042f8f.34.1778192594539;
        Thu, 07 May 2026 15:23:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454177de66esm1815153f8f.33.2026.05.07.15.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:14 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 16/28] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <da0482ba6f868a12417e46a8eb86594f5eb58d83.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aO1vI1EzQlD3Ib8Qaj3xrm2-OFyRfbx51z1Pyb4SpYU_1778192595
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4668680003
X-Stat-Signature: ehqd8hankar5kgq66etgruu5ahjkx3f8
X-HE-Tag: 1778192598-652331
X-HE-Meta: U2FsdGVkX1/Ubl4s1rmbTAXDhrV8ZSMu69C4seVSh6T1jMW24Dd8Q9O4NZj61IWkDcTSqtMi3TEXB8A5qwmdnUtAn/oJmcA9vs8s1iVXBSMlILGxdP70DzKH16j6qQh09+npNNrQ27NMupbyhAevMuFGMU1MV13PipHeLYafDur5KzgmtsKwznv7uPddbV//G4TzGOOeVzrtjeq2eRsArxvUPJWHuqLxCY+zk4rwt75PbYe+rc2yLQXtWicRSair8nnnyrnlDCcitDPjiCc6JOXBlisBcV51UFTH6dkRf279za+alpg8Yb0o1iMUrLmqye2n/WYvE4pK63FZvgvd0OwxhEU0Tyi4EFxw/wZV/3TzmBKLFnP4KVtao6nxkt5nTJg6uXpfmuYv1Al1KS+HtFIXdNEZWAauk6JQFp/Bd+pCa9WW+ZjDVIy/ly2qwSe14FSiWRaT9xz+hM4n4nGSn/RL2AadGLOk83OoaaVE7ASgXsOgQL+YGw8nKjyALdT5LHM0WeHINx3SgaJ5XFteUWX/4hho3d5xfsqy/WTq3kEQWrqnGUa3Ui/3CZ9A8nFvdc3Qhu8+HZvLF1TKJIGwu1Qc6pWgWrjvYaKxtM1DrKaytYSQ1OQB+YY9E3FGnckMvBu2DEzGLcFIt8O0Yltt+7ZX6pbHzijmIiPaJVgo5cryEyQETKgLK5pYuwc58vNe1Nnfjj2UIGhNm4z4os3lQLqIiul+82tJI/ZZk6ZRAdohhzRlBcoSp0wpM1hSWhxwFlYhcVSoQmQLWm+1zLqa3ZT708y9Z8pHADoD1anrDApkIrPD3aTt+dV8cUqIoyNsSr+5tjL8/ilb/WvxZPs6uwMDRQ0NLCg5vyq5UYWDgLdTvoBDkQqgv7iYUtfMKgWKywErxEfqz6V2SsEvDmsYgZVDaXBwyRYx/l3GUKAeg4liM34ZHiIEVXRssNfn+WBTBWXRhgKhpo4TCClEj56
 mL4+IjDZ
 SGirIvAJZh0r12xWUEO38Yi9fQ8HfLi79UKS4s8qXRJJfKu5tvjYPLoBcm+cnpbizlHKrfKYwAdDtb0wrl8a0XXzo1tFAd/xSnrevO9SH26mUY0WKHPOZLdiv2KupX+h1jitfOE8fDnEMx0y9+5q0fQmegQE6CwUqdbXwAywgRLx4NMLvEJNrMfb9kl+wqmgfzeF2trmqb3w/dh9A1LadRAIHLJy/wCyX3mUBBvnBbtM0wFGm600wVhn4E6LiyBz8cWJAHpoS9VJ6hUu0UivQGik5r9k9d3I3GdOUTQCYk3v7ZV6L8ArJOnCAtsm3fQS5Fp3cyWd0Ql485wlHfRWBN3EcUf/39KO/Y6k6mOR10So2wVCvqm+/hNF6sA==
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
  that have been zeroed by the host.  Set it in
  page_reporting_drain() after the host reports them.

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
index 306468b6c7d8..81e5a2819b3c 100644
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
index e39abab956e7..a01bc2c85cf2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -895,7 +895,7 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
-		     unsigned long user_addr);
+		     bool zeroed, unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 127b343d3783..e5db2601d673 100644
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
@@ -3190,6 +3201,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	}
 
 	del_page_from_free_list(page, zone, order, mt);
+	__ClearPageZeroed(page);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -3262,7 +3274,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *zeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3297,6 +3309,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3358,10 +3372,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
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
 
@@ -3382,6 +3395,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3390,7 +3405,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *zeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3409,7 +3425,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, zeroed);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3434,19 +3451,19 @@ static inline
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
@@ -3837,6 +3854,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool zeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3981,10 +3999,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
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
@@ -4218,9 +4237,11 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
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
@@ -5194,6 +5215,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool zeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5202,7 +5224,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &zeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5213,7 +5235,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
+		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6975,7 +6997,8 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
+			__ClearPageZeroed(page);
+			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7180,8 +7203,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
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
index 247cda44e9de..1f48fcd7c042 100644
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
@@ -390,6 +395,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -414,6 +423,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
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


