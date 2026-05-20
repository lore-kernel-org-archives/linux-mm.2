Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B69A6CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ADAE6B00BC; Wed, 20 May 2026 18:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257396B00BE; Wed, 20 May 2026 18:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146306B00BF; Wed, 20 May 2026 18:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 005A26B00BC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF7494043B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:32 +0000 (UTC)
X-FDA: 84789223344.13.C024005
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70B33C0006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EdEoqdez;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YVd6WxtbkfB/mW7jT3E6E8CanzKli79KiDV6z3ud74=;
	b=suaMEkjzTCRWd7xugr/b2dpEbjonqmwhKm30nFsRn/S2r2c/YFKx/VI5+D0h347rYNK8WX
	2pKVPtUKs2vuNELacCbqTAE9Rai0+6vhVWkHYhXPF4akeXmBFNMtCrC1cgVd1dk+ysC4We
	vK4atURrTmifVWClGEoK8kfEkaQEQwc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EdEoqdez;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315750; a=rsa-sha256;
	cv=none;
	b=kDPcHU+cZZNzA5ewOrDrezMTvVcUjh68pW0TivikkYmt+mMiPbQHUSRSWpjpU/Pk6gtpaF
	TgUPooLGVHK5ZG0Eb+vx4R9lljMs+kFALc4E04fSMN2P3TJ1D9qW/UIjNsQroeTHO6tp0r
	+wzNg9MTY/QVdppAt8yBhA5XjS82UmE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1YVd6WxtbkfB/mW7jT3E6E8CanzKli79KiDV6z3ud74=;
	b=EdEoqdezz86SptwqxEOt9NkZT1wc7iwjZ9EO9x5TruQxen2Pxf1Qyn4YUzfZ+BfwA4+bxi
	lI+E28e1+NgQFIz4dHWCT4dFaMO8ciiNUwBvWPwYXlPQeotoox7DdH17wG3hyglv7PSrx3
	7l8G7f5EwHUT+QK2VwmfWGdy1KUG8p4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-8ntDcbeeNKK2miwsFZGf4g-1; Wed, 20 May 2026 18:22:28 -0400
X-MC-Unique: 8ntDcbeeNKK2miwsFZGf4g-1
X-Mimecast-MFC-AGG-ID: 8ntDcbeeNKK2miwsFZGf4g_1779315747
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-447f2ce5556so4363661f8f.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315747; x=1779920547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YVd6WxtbkfB/mW7jT3E6E8CanzKli79KiDV6z3ud74=;
        b=ZOHZS4bpo+TzBcLnGU0sgczkdgQV/CAXYFTVQPJScbPYOnVX37rfjDKDEZBudKyciT
         lyrraVNGGedSzgNAVZA3dfbu9aoA4nlcXRipiVIogKqBJeoI9f37sBqkkSgCDuctVjNg
         6Ss0POq4Ekadlozjx/mH5XDhyukff0q8aMvENVvaDdGVg1EOEQNV3krd8DnHM35J+5Nh
         Nm5CDMBvxYr16AK+a/oJ0mEnyx9hKNQ03KK//U4s8iY0b6HjW7UwuIa3ppRLdozuZknx
         fkNOKGFwrkCIPy4VT1LZnfgdHMLfwRpOdic0pbYZGTgwyNE4tI8f917TrCF5rpZL9yLy
         f3yA==
X-Forwarded-Encrypted: i=1; AFNElJ/QBrd4ihW+vRmke9Psm3et5g2lxbHclsCp5VDsHnR8sCawJrnNo7nNF/FKvxKyt8TxHu2JbRzKyg==@kvack.org
X-Gm-Message-State: AOJu0Yyr6kaM4+gUVwVRFgcat7Ucs81M4g2cYOJT8f1yL1hY46xXozPI
	+KloU72fupbhDkZn0aUbHUfSMdu19EXw2ur3rWvncbiUKTTeOFsmDhoTUV2zt72gJ6FFJN7SnfP
	3cVzPYhZ7pw3v51X86y53/XKphYRbsVYLioo5CjMSL2wj9+z9seSv
X-Gm-Gg: Acq92OHQkKmBhnC6RGQEed2KTlfs9/w294mDSBOlctUOojN49Mu1mlgX3vODv5M60M7
	ymM3V2Pu+G5JXJo3thRpsgFZCXq8L08/91yQVbwCb2QJ6lNXOqeLY6Wgtjh27McvNrUvNWvDG8i
	ytRWsGFmQRv/EmojuDJOiK8bQS0/MgTVMEgz50Qi2KzMpTm9rnYcsjuRuha5IV6h6y4SfbgNkZS
	4XEcehX+ODBgapRHZPS3vRc8x7QO9r9zNGhKExdE9cc2/pJHT+1LE8C5uA9PWlk9V5jM8wmoxLf
	3rIGucMRmOF00j7duS7Ed8xePO6fMY+lK3FVfSn/JHUh7L4NiObY6aqyhg6T7KBjEJZkG9MnmsN
	XASSng+0T7lHHxzSLr+N2bQbzQOZxDZ2HMQyRUrGwE/M=
X-Received: by 2002:a05:6000:4310:b0:43d:e31:68d1 with SMTP id ffacd0b85a97d-45ea38ea8c2mr301704f8f.21.1779315746918;
        Wed, 20 May 2026 15:22:26 -0700 (PDT)
X-Received: by 2002:a05:6000:4310:b0:43d:e31:68d1 with SMTP id ffacd0b85a97d-45ea38ea8c2mr301669f8f.21.1779315746363;
        Wed, 20 May 2026 15:22:26 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe1a41sm61751303f8f.31.2026.05.20.15.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:25 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:21 -0400
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
Subject: [PATCH v8 22/37] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <b870d5a0ebb7b315a7dfd5ab1500f352eb41951a.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GN11OfcfirYHl07tPVWWOIw54c5zvf7JGxOmdZPlqcY_1779315747
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70B33C0006
X-Stat-Signature: mk4hu6abkacd4qiy11yf4bjsije9b446
X-HE-Tag: 1779315750-470020
X-HE-Meta: U2FsdGVkX1+t6dm1G78F4UXfMRqENRPzH0IC5pcPW5z6Ln13rcruwC94FZKiFSKgp4Loy76j3DFn6AsCsHF12gI30EJfuCrQEUIVss7Z1KMwAm+8yHEoACdB7mh90UQhZLea3jbZQYPXJQZ60spfLmyxxSY1ZZfGf7UJiRhc2XfU5Tm6wWckoMZwbOGz8pv4T7CYi7tMSOCtoPrsgj9/p/BAOciqY8j2xN5tmxXsCIJIYbAWiDX7bP1y4xRFB0r2ANnTfUcAOzNYBWmoctK8gqw1HLAka9/mEC5FwnMDNFVQLQ3y8/2BEoHdfbNCRJ9Oa94rRivq2RSFRpi2cSXjEe7oqk/dns5uzycUS20wKKPU86CVx3OWElq4s8FUX8B4Qun4zu/TF3FfPzEhUMi54rjiqSiXSs9+e9IMvZ0w0EFibZI8lrp+KA8TFl7qhrLm2SCnbDKCfTphCcL7Z89M2633V5anO4kYlTlfMbG/ZDueV9xA6ul+kBsxjD83aV5Yzwbwt4FJhvfnk7lSF9SwqQblxVWvGvsfBCl1UkCeYkuA9sLalRj90mxqj4qmbj5Z39Kc3zTO4wbSBAurncPkpDZKhWACN4CfRrJ2YDQPhVAjpqN7TaX70APWkDZPljjBvqWv4MR186yoj2NtbRw0N79s4syp3/6QuQiGGv1TqSxKl7/+2wC7ufhWZzyMclC6ZmZckdGpLxJVp0WYXjJiD80eU7bLuBzkuCoTyFCoZQsZkSGudysF+XWGi3kHy+QZVH9oS3RGlXdDsdnrRIFpsp3e7PcgXDdVoHGywesXC2owGW212sjm2bvNJFes5Ju3gamsfvGJvwsg70oBwYD0g3pLnaXIna5ubILUOcg+egdEQaLHUE1on6bdlqh19jAeHJ3Sm3+FF/qb7S6QSKQtcSMEB1AxbwY0hP9o8tP+qnURa0ky6OaFr9gU7kj6raY/utgBla/HpUHipglW+ki
 ct6IWeB2
 Xn01vcmmmOnGyW9P1IdXw9EDU+wOxUrcdZL/+7ZdFmNYh8L+1M1Gib/ZwpbPnAdZTZfb7hS84bA2EVNhvUs0YklmkJmh6HHa0+K+C6up37/c7SY+wQiq0mjaDK//bZoQOaIe3sn/+SvduLK5SyL6M84ZazeRP++yWNXStnLx5i3fBWLwzgBHMxznGMMmX1e1XP0Li2sf/6gpzVblnJXLTDTJYSd2Naa8nGCUl0xYnS3DZSszwdqk3CJP6xfoQmU0RXejjSpcPOBOXLaj34HFmJQY5cQP8PDqpY7czBeFYth9xvrkevs4B6vAGO30cYlPKiy/6xzWz9i8IiY3eZ5pY/1jWLQVunyQFCg6zd8UIrrGg1Gpf+/Tk77hz9noIxp0eSqvQ8Ab3yKMHn/A6mcfdldt5BmpuaualF4jF21u/62AvObKfGOjVdJHC4c+m23+0Q8tu
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
 mm/compaction.c                |  6 ++-
 mm/internal.h                  |  2 +-
 mm/page_alloc.c                | 68 +++++++++++++++++++++++-----------
 mm/page_reporting.c            | 14 ++++++-
 mm/page_reporting.h            | 12 ++++++
 7 files changed, 88 insertions(+), 26 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..4ee64134acc3 100644
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
@@ -673,6 +675,13 @@ FOLIO_TEST_CLEAR_FLAG_FALSE(young)
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
index 5ab5be02fa15..c331c6b36687 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -14,6 +14,9 @@ struct page_reporting_dev_info {
 	int (*report)(struct page_reporting_dev_info *prdev,
 		      struct scatterlist *sg, unsigned int nents);
 
+	/* If true, host zeros reported pages on reclaim */
+	bool host_zeroes_pages;
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/compaction.c b/mm/compaction.c
index 4336e433c99b..8000fc5e0a2e 100644
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
@@ -1849,9 +1850,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
+	__ClearPageZeroed(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
 	set_page_refcounted(&dst->page);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
diff --git a/mm/internal.h b/mm/internal.h
index 389098200aa6..fd910743ddc3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -928,7 +928,7 @@ static inline void init_compound_tail(struct page *tail,
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
-		     unsigned long user_addr);
+		     bool zeroed, unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ad0655387e9d..5158f7e23d18 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1746,6 +1746,7 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
+
 	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
@@ -1818,8 +1819,10 @@ static inline bool should_skip_init(gfp_t flags)
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
@@ -1828,6 +1831,14 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
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
 
@@ -1870,7 +1881,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	 * through a user-congruent mapping.  Host-zeroed pages
 	 * (zeroed flag) don't need this: physical RAM is clean.
 	 */
-	if (!init && (gfp_flags & __GFP_ZERO) &&
+	if (!zeroed && !init && (gfp_flags & __GFP_ZERO) &&
 	    user_addr != USER_ADDR_NONE &&
 	    user_alloc_needs_zeroing())
 		init = true;
@@ -1903,13 +1914,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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
@@ -3175,6 +3186,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	}
 
 	del_page_from_free_list(page, zone, order, mt);
+	__ClearPageZeroed(page);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -3247,7 +3259,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *zeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3282,6 +3294,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	/*
@@ -3350,10 +3364,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
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
 
@@ -3388,6 +3401,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3396,7 +3411,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *zeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3414,7 +3430,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, zeroed);
 	pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3439,19 +3456,19 @@ static inline
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
@@ -3842,6 +3859,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool zeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3986,10 +4004,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 try_this_zone:
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
-				gfp_mask, alloc_flags, ac->migratetype);
+					gfp_mask, alloc_flags, ac->migratetype,
+					&zeroed);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags,
-				      ac->user_addr);
+				      zeroed, ac->user_addr);
 
 			return page;
 		} else {
@@ -4216,9 +4235,11 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
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
@@ -5191,6 +5212,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool zeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5199,7 +5221,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &zeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5210,7 +5232,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
+		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6950,7 +6972,8 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
+			__ClearPageZeroed(page);
+			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7156,8 +7179,9 @@ static int __alloc_contig_frozen_range(unsigned long start, unsigned long end,
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
+		__ClearPageZeroed(head);
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, user_addr);
+		prep_new_page(head, order, gfp_mask, 0, false, user_addr);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index ae8d55f89f25..e42f857485ce 100644
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
@@ -393,6 +398,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -417,6 +426,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
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


