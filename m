Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C66BCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77856B00E9; Fri, 29 May 2026 11:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28386B00EA; Fri, 29 May 2026 11:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E316B00EB; Fri, 29 May 2026 11:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 905316B00E9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 586D81C028E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:19 +0000 (UTC)
X-FDA: 84820828638.08.E5BF785
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0EC518000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hmjHS/xz";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ha0MKvEjPpqKYjU+TNR9cOwfxNwOYM3BFVBNkyNiIfo=;
	b=gKvE3Ok7XMopyJrf8zY+qTVWpdLArdvT/mNRm6Wc4/MZeC0wrXdF334ukxbgj6P3O+5OOo
	K+i6fN6k50uanXEql0QC2ouspq55awFJmP+ds7q1xREI6fl4FlSk91w3iJPZxyOSjkvS3q
	w37TiEJJJhRMkRVCaFPHV+F+gtL0/+k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hmjHS/xz";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068257; a=rsa-sha256;
	cv=none;
	b=rgGLv12BcqXiZHKCFCs4KxKN3aevPTgDZ10qE40nfkTz499asI9mO8QrZ9RRP+4vcd7VbE
	Co1TenrwmD0XZU/UiYu3cpcdNdrOxfkOaZMZyCmm11Cn3QKAyBg1DTqDceN9KU8V71+/mI
	wAI196xbgF6UzELI3o0BbGYraOZgvtY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ha0MKvEjPpqKYjU+TNR9cOwfxNwOYM3BFVBNkyNiIfo=;
	b=hmjHS/xz6CWhW6iIu6yN2Rj+aC6ePhv1TnPgBFi2JTpyqu0lb0JeLiP82KBRifb3qI/72m
	lAiHZuNk42XbfB67HCHlmW8iS0KLE40f8i6U84rvNO3QeIjGUZp8r3YHr/vWaZj5HvFpol
	iaoRJUHx/4Gy76tmL1+SgeC8/mTYrS8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-C7WTWQzyPz2Gtl_RDwy1qA-1; Fri, 29 May 2026 11:24:14 -0400
X-MC-Unique: C7WTWQzyPz2Gtl_RDwy1qA-1
X-Mimecast-MFC-AGG-ID: C7WTWQzyPz2Gtl_RDwy1qA_1780068254
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4903dcb32f8so69896395e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068254; x=1780673054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ha0MKvEjPpqKYjU+TNR9cOwfxNwOYM3BFVBNkyNiIfo=;
        b=Wx0JOIH03+caOWCP/eMvkYPZR5/8LrA/1GOifjjVzDJEebn4P5aCO0y4QTIu5RtoAr
         Fe3dIocxeByB4n5KKCuwO9DiK3IJsCAsZ1hoEr8LIc09pet3ik0U7wuvclj8SyJK7cOe
         u/gCagffY9msGYFgYJ2+/OKXYtnTeV1WcdwJrPQfyTK/VHyStCBMl92wqDbZE7s2zwXX
         zKsnByDCU4kLLkY0mKPYog1r6qazjk7usDix+Wed7YZ4sBK8QO/Sz/u4SfCSV+vdfZXs
         8I3L/LW4550iKmsltSvIZkE8Szun0kFXeNe9YD4zwwobTD20wlvvF0+wBroaPaiB4Jjl
         izJA==
X-Forwarded-Encrypted: i=1; AFNElJ+2ibpj0+eKIwAxGa+pjfHh4tBNbq7ySY9hg1joLMsg+aesSW10Qy5vBs13H1BOODG6atwPXUe3og==@kvack.org
X-Gm-Message-State: AOJu0Yzvf0ina1N5oAVCEiuLXwc/twAfzjLf3FwLAnY1sn4YtcWmFhe8
	uj3/4tD7vwNJY28o4DOE4pNNCjXhi6wk8F5f54AoAuS29Yvg7GybnYQvhPnRxU/GR05EVUheQVn
	Q6O0/Unie3/KrWX2fGZ5g1t2HnSqojGgVFk6eyN9WkqQGmuVfsC62
X-Gm-Gg: Acq92OEOdrnDMZOsL68ruldjctZIOtcttih/MAe3NlbakDbjTu15c1JReUrqiZB/6c+
	KRxKbaAhNlfpDvfH75lESncYprE5hGWFkfNuoXjvXc6clVAOgOF7JsKF6BKcQP5zGMa2xwElxk7
	X7C1M3/0pnJG4k9ljhGzOAvv5IApZ+Bbo0bfU0ejM4fH7uAwrBr3civcfuBl3MiuRfuJvU8QAt2
	kooQi2gshk1nX5YPz3orktJ5MFxh0nAmeBvQYKFHR/avhcga8XvXBd5FNDd+6FsjXc2guxvI7RN
	aHjS2rTSUVolUJkx6p7KN5i7D6OZNssiyI/tPt/OHp7np1MGDweo1sGPJLpzhKLcLp/FsXFhRJc
	avEg2kPjb/sL9GZESSQVFnWbPG60b4padMDT+PMqYY6m7uoXdGBZCgA==
X-Received: by 2002:a05:600d:640f:10b0:489:2005:b36e with SMTP id 5b1f17b1804b1-490a2941d4emr1178705e9.19.1780068253486;
        Fri, 29 May 2026 08:24:13 -0700 (PDT)
X-Received: by 2002:a05:600d:640f:10b0:489:2005:b36e with SMTP id 5b1f17b1804b1-490a2941d4emr1178125e9.19.1780068252950;
        Fri, 29 May 2026 08:24:12 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c103a89sm16422195e9.20.2026.05.29.08.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:12 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:07 -0400
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
Subject: [PATCH v9 21/37] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <43b19542a07b568279d1a6e734d6729d347b78d5.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 16FtGbsTLQN9JTSHb6stidwtTXF194yV5l74HXKt41s_1780068254
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: amsyjg76wkhz8ae11cgiapuiyn3k3znd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0EC518000A
X-Rspam-User: 
X-HE-Tag: 1780068256-367610
X-HE-Meta: U2FsdGVkX1/Xhhvq6RmNsHI6mQoHuLlOUL8EjoUV8QgD0keA9QBZzoBsLlOix8fc92znqZByEX6G5hrCKSWTY8aDi/0BaKyqzKX8+1UxafYUI8OZXz66m70emry/JbaBzI67120NcuQ87N0yHgLJqNU6rn2q4N/fWF1cEjgQD2AoLYvsFrDp1DST9jrCddEu4LgRQ2YZMiMtXiL6rbOY6q1a2mkksm+xMj8E9LjKmfUBl8cutRILcZenaWBH+n9T0f13gz8R2yCGe1iuuowBSyCMk6KvbVINTqJhOd9b3FWeAMMuEZI3xUXjlFLRR3IV0Qv5bOE/YKRvfhu8d3oe36ALozjALfIBrBP0wx9wrTibnEUb091JHpovnsZ4yeyiI7aa5c1K6DmMz0xrFFSe/rmO6uX5es0rKq0VkytSpJZBYB4DutlSq5VBs2wGE6oHPUeH+1KmDI1d7l9prZpsCEjrZXeJsw3TUWeyTkrl9WBcs7HOvE1Bu70aJJfjBfgpuwVkE9uHw9235A0plE30JhrO3NZMvBLqC0XCqOO86LWAeVJm4DwP38z2dBVfxei9jyocasm/RnjKHn3Z5v5YtIQlDrzquEK7iWOt1aZBsluugiOvpKDRzcPFlD0oV00K1uei/wcC1crLZ3GkaMala0Oa615QeRMryJ2UFXyR9DOHpu48nqX6YPfybgYo3xjYgbNN155N8EleVxQnkpk4aq4vN6YFgRVNoWDXw7v0g0bffg7flDowsOz8N7AsTuNoXM/b70OSz+bN0lvXqTqrMrLENTpU5MBTrH3m9hiW+aST6byZgsb/FsTC3pI6GKzlAh/8knlF/7kdbaP1zObM0l+Jprboh7624sghKuYgTtNgmHkm3KRnCC5pGf0Sl1pVvFvPhum50WK0yvJUkKF6mzv2mvGwvUZyNC9InrMBPw89/BasNyMwO9ve3YxV5gF/Yz0Yfk31TnBaZ4bE7xm
 LF8hjQjQ
 RTHXmY+nOyG0yBM6nfChnY1RubHdtmjiGzntTViroW03WTDFSVTJD09IO2UU5xxK/RocaepS5xm1Zq1QP9mP2NCAHTVNBIxAanGtQjsELMgAhgy0z+ZNwhjiXjhR/IMIAtP3YeM5AjCMyyrcEztVixj1JIBpWVzvvBfpVmfH5dCbjj1JbpNo/VvUbGrijXANDgRxt8eBM4phowdMVhstlMCYHFQqPoDMGUlZV076sb3IR52SlFiTxqWxTUgIpkPg3kUC4oLO5VfwT5uY6Gxg8fpysXQ505Te0KOizq9Y6hq3fz5IG7oQLNnpzTBkLUsDEcjquOg5tA5s09B5N/FN9ZHtSc4f+hAWHdupDkaXGaInOZTSlY9i7v6qXLaHoKJtgRmT6pDslYSGdmPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/cma.h     |  3 ++-
 include/linux/hugetlb.h |  6 ++++--
 mm/cma.c                |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/hugetlb_cma.c        |  4 ++--
 mm/memfd.c              | 14 ++++++++------
 6 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..dee88909cf5d 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -53,7 +53,8 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t caller_gfp);
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count);
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 49e5557d6cc0..3d23267014e6 100644
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
@@ -1134,7 +1135,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..27971f6264ab 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -924,9 +924,11 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t caller_gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN |
+		    (caller_gfp & __GFP_ZERO);
 
 	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4ccf4eb91d92..649972101ace 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2208,7 +2208,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2224,6 +2224,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
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
 
@@ -2308,7 +2314,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h),
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 7693ccefd0c6..c9266b25be3d 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -35,14 +35,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 		return NULL;
 
 	if (hugetlb_cma[nid])
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
 			if (page)
 				break;
 		}
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


