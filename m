Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE380CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362FC6B00BC; Tue, 12 May 2026 17:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33AB56B00BE; Tue, 12 May 2026 17:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2296C6B00BF; Tue, 12 May 2026 17:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE7F6B00BC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B422B12049C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:01 +0000 (UTC)
X-FDA: 84760002642.01.3506010
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6B4FEC0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnZ0tkDJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620019; a=rsa-sha256;
	cv=none;
	b=HZdmFyxMj0ikiOO5sY/eh6QW1VYAKouoW2j3qHsLpUtdb46yV/qS73hjRcwFb5+aQa97Sf
	iyL5KJQ/uSqRG0E+ETSQS/WTmlWPoLe0kfEmQdKroVYtimhIy1GKAFvvqK7W3CFnSNVFxp
	/cncJBbwMwcUv+pnv+osfKDk9CJVL+I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnZ0tkDJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7ug8Z4kui901Eg+tMJ5hLVMh87nMDvb3T5J3R0m9NQ=;
	b=xHySUxbd67tnX5lGxiTUMo/0hux5A9kfZGGWyV9rTpsqwbNhj2KQFgP6Mf0wf0SFi7cChj
	ig0AVhFX3/+Crn/SSK5T/S+cCJ4XLaBD22ElOMiJDF6rFN1mjDNCQSrFRxEiPHJ6c2Om99
	S0aOOnR3FYbQHHB4PBQd1cvPnK7B5ZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n7ug8Z4kui901Eg+tMJ5hLVMh87nMDvb3T5J3R0m9NQ=;
	b=DnZ0tkDJuLnBf4I5nzcMzIiDw+1IYGRZtR1AF/SiUZGjianfSCDJgRetfTQHle5DxgDIeo
	L+VA+vkkzR/675yx2b9RKq6v1wLVQu9vrX8j7YF8mBfB1S+gqZmpLW+FYEfMAMMcbkjvlF
	HGn1lPmQ6vJEwr+UebiUDbHNICtnr5A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-QiJVJxLhNrOCYwB-jf09sQ-1; Tue, 12 May 2026 17:06:55 -0400
X-MC-Unique: QiJVJxLhNrOCYwB-jf09sQ-1
X-Mimecast-MFC-AGG-ID: QiJVJxLhNrOCYwB-jf09sQ_1778620015
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e60b55de2so52989475e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620014; x=1779224814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7ug8Z4kui901Eg+tMJ5hLVMh87nMDvb3T5J3R0m9NQ=;
        b=DhFpXbwyEiKdSb5MBLZAcdkgoh6OYdpGdxmSct83erCgZrcXWkf0lHnXfl10ulLUyb
         poOPsGbj0jdcSkn23MIzsETN6AS+8VAkFqAqWilWwNkTft8T+eZZ9cZ8AJHK6Ed2KVSz
         Tlib9zTFa5C/hvlFwRlJw9lAA+JYCPT/CWCFDoFqjeFPurOy+EFbJ3TiLptGjKt02mdi
         h+agV142SjMkgarjwCUaxPpmBq7AqZTnVw5xOYXekRxKY5B4QUOBc7kDUnX9OkHnwZGl
         ziBnLTZ0SgZCI+lFjxU/EXq9zQFnAGpO4kaWv3dUVqLsURgypoPaOLp2sr9K/LDhZ7Iq
         nBEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+KAJlJZvGINdYg9AcPm9Kf+Ja8Y+p2v96ZhcWxr2Kl82i8IJCQwMadiYTfxpGBjV1h2JUn3Ott2A==@kvack.org
X-Gm-Message-State: AOJu0Yxq8zdEnqcCx2H/UkheJx+0FuR+EBeBBV2o+55SDxRup5JJzSZQ
	Iw8M7Y3ITvPQPcH9GNSsHI6mSSFB1+TJLDbzdPRDyCdorHokbYhWXiOTZK0zJOMVAzEq9BOyU8k
	eql73AGOxrDK45YvwceLBZfii+kH3vNxvsEBhgIIxDODo/heeoiBI
X-Gm-Gg: Acq92OEAfkrcTOTATbg/wdkbH+3HlS2JPJiP4SdU1VA3aSN4oC2DTdGlky7pDxIbR4M
	oGHGDWAt1aETQ9tMtjyGWoUBFFpQ+p72Yp+y5DaQabx+0IDTKZxsOUs4tGfaN3fDkQ0QfiPFyRG
	jCg5bDza9JtzOq0dSMqSs13xBGHKAmQ+OxOvfpRUIAMr6DJjcK0wREUzw346cfPJsl6zpUmUx8e
	wL6nLOwmxMLnztxfzbAY6S4EHBg1wmytWpEax8ae3xajXR7ARgQyjqGfb/hBI2zydWH9fQRwBQu
	V1asO5U+dqrJ+1KhNIiV7+bSAeVPe8Rvy5lWfdxBxzyJTsDWTLGcWshv73+VVqJtWaVj3dR/mp1
	RchQ/DkFOxtnd8l/D+QkR68kUOSgHhzO5zSHimdX7
X-Received: by 2002:a05:600c:6303:b0:48a:592c:e632 with SMTP id 5b1f17b1804b1-48fc9a2b921mr6297375e9.16.1778620014255;
        Tue, 12 May 2026 14:06:54 -0700 (PDT)
X-Received: by 2002:a05:600c:6303:b0:48a:592c:e632 with SMTP id 5b1f17b1804b1-48fc9a2b921mr6296645e9.16.1778620013630;
        Tue, 12 May 2026 14:06:53 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d1986fsm19666505e9.3.2026.05.12.14.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:53 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:48 -0400
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
Subject: [PATCH v7 19/31] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <b6966bac2a4bb8027ec0383ed84b497e05d5f835.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uCjjAZvnirA1XtyV_VXjF8VY83RwwYvgzIhSyYErZI4_1778620015
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 6y4wh8cunfaghawp9wsft4ddfa1g4bej
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B4FEC0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778620019-932608
X-HE-Meta: U2FsdGVkX1/Hz1lcEQ8QnExBHsvkwkr8DuZWd0mkTUJq2YdFoHLndHAyvjnFcuYqZ9b9JjDwRhRO2QFBdo4ZN96KQ5hbaQ3a7VK0bB/uenLcTEDtggpy4Lw0ik1e+eY301Y0ChqLqUXjUMXpyGSikG6v6fhf3MhgvG+skEHZTi6/IvHg+nQiGtiR8SaM+sOg05h7aJTHz2sb+C5J4jv9bWubvWmuzU+kk2aD6VYm/sGfgxjKx4WHDzHgLBhT/btglei1d82eFWu+y9kphb/aQxEFlA9N1v6Pkwl/sLgVhDke1cqFGxI1l+SxQnS144PWOAkInasR+KXKX8oucFdZwegtdIrS7257NzhidrZFPkIx3LbJbgyNiagrTLHjRu3sE6gcdISNp16+p0inQYbofA7DTiF5uBrUdthT/x8A2doc4Swzhz79yFxEzVXHteY2zd0kV2BRNqvGfUMc9GBbeDvDUzFY+ZCY76PGg9Xlxp+AVbcYbOfwzPaQND6b9SNm1G9JkrYZsnMvxGRh41f3jNaYrbFbtwK/LUTdMtd9Ysfpwk6wfUAKv0EBpffIsP6NAf9QpyiFBf3e4j4d3EZ5hEfrJMhz0P4fN9DryvKs4xr9NrVjGwmIWzr0JxbSI1IL7m86PQuvNLEgEv5jG+QHSLi6UlatM8z/0gO0H4nLBi1i3m9NbjafEayfBBCEhy74mX1MI865iHkVEKR5pw20wNYVNKv2Xf182y9lwrtdHebQ/l59QPkGzsdrZmp26yV2ZbXKx5wVdIjbmaRaXfy2UVcVaEm9K7AKuqq1w1BKt+rVq1MgNHmQWqCmq5ELizmZQl4/XAQRT9k6OfSlygwlScMfYrlUfVB80Yo0WqGBixEOE9932EGXxFQ5hUVDfpSEZ4TDesfpqHLUlIdOPIVcJ0bD3xPkeqW4YAjVln8Ntz/bQNpS9RxG4ArM3SfzGO8aoyvEOsoH818xl1HvMgc
 9vwFoMv3
 IgPB2wqVVKTR38M/HaOKTaXxipuNGyyf4cRHC45JgkdMJ/3dcYfQqdFYk7s0H8Sj08PYnPfremQmoHIJGLQa/CAd0ahA4/vAssfcq4ZLkp3zW2Uyb3kuNn2hf8SM1paohBtv7S/HQoOLwB/H8GtT69tjmtt1/8Xzm4ySdp8yeoeC4ZNbt45xTE+PlusS5AZBYbkZ5GpzzyXXic+CGZjdfJoHhnogkJwbcuQTm19YgVqq9lcgBoIC3MrsUMrAvjHiahbjQo5OB+7l/SQVpLmToK0zz6kA7MgTFamXUWEr4HvukrXCEUFf2IyDwAb41+UBaAnO5dvnbsxSxFAX+kbNVlcyaVhVWrH4tiQHt83Hf1udeD11OwdMQ6HE1NBDTfHQxTQBSVHOILDsdjA1354kEzq9Sk4rpNRoNUxtrT/gz/vGPwhBtTttEG2tBTs2Q9etSeQaW
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
index 76f39dd026ff..bd3b909cacdf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1743,6 +1743,7 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
+
 	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
@@ -1815,8 +1816,10 @@ static inline bool should_skip_init(gfp_t flags)
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
@@ -1825,6 +1828,14 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
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
 
@@ -1882,13 +1893,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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
@@ -3154,6 +3165,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	}
 
 	del_page_from_free_list(page, zone, order, mt);
+	__ClearPageZeroed(page);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -3226,7 +3238,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *zeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3261,6 +3273,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	/*
@@ -3329,10 +3343,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
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
 
@@ -3367,6 +3380,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3375,7 +3390,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *zeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3393,7 +3409,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, zeroed);
 	pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3418,19 +3435,19 @@ static inline
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
@@ -3821,6 +3838,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool zeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3965,10 +3983,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
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
@@ -4195,9 +4214,11 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
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
@@ -5170,6 +5191,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool zeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5178,7 +5200,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &zeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5189,7 +5211,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
+		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6929,7 +6951,8 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
+			__ClearPageZeroed(page);
+			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7134,8 +7157,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
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
index 006f7cdddc18..37e4fce9eb38 100644
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
@@ -391,6 +396,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -415,6 +424,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
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


