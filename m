Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C91F588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80ED86B00B0; Mon, 20 Apr 2026 08:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8B36B00B1; Mon, 20 Apr 2026 08:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681526B00B2; Mon, 20 Apr 2026 08:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5751C6B00B0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:51:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4987A8C9F2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:16 +0000 (UTC)
X-FDA: 84678919752.20.0C27187
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD09014000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HwxB/CZ+";
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bi57iZ++pwWctggr2TvdW1CtXtPNYbcTAE7BCEX37cw=;
	b=J/Dt3RQM8Cn5KF6B0sxycsIR5Y4lXSwG4Inp64Bf8IADyHJc1PDvr772xpdxZFJDeb6oJK
	wmyRvShcrxYUNmadWwjfrQnkJJybXjyoDELXc8+hiY56216Rsft9/AwoXbNs/L4UKk5WEC
	jVq26Zq58roG0cETayB/pI1SV4X1jac=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HwxB/CZ+";
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689473; a=rsa-sha256;
	cv=none;
	b=GcYx7Kouz3sfGMI0DD0zE88ugyH/CZ1njEQE5n6AU0uVkGLLzUa1Oq7TOSrUkLxS+UR6v3
	Fb32Ldkhlr8FT8j/tgOUEOys4Sd+mcW8IZ0kt3xAVRATPilu0ZTkv7t06PC/AAmhM8Z9gb
	+anPFSkY9JL1XL4WsAJ0ldIFle7+pfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bi57iZ++pwWctggr2TvdW1CtXtPNYbcTAE7BCEX37cw=;
	b=HwxB/CZ+vBrlhpgVxDKjQQkuhKh6kuxAVPWzD7rMpf9wfxUqxaxYPRiUmmBwjFfIpXPiMW
	IRF8n15CL7GEzyUkb/2kRycvgW/Yh3aYSmmwDY4c5RjTqMumijHtNYZE1dGQvaQbDxuWgu
	obFsDk20yrgBJIbjSvKIloOlQ/6vvWc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-C3XLtblpOaG4MiRyJTI6xw-1; Mon, 20 Apr 2026 08:51:12 -0400
X-MC-Unique: C3XLtblpOaG4MiRyJTI6xw-1
X-Mimecast-MFC-AGG-ID: C3XLtblpOaG4MiRyJTI6xw_1776689471
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4411a215f17so536413f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689471; x=1777294271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bi57iZ++pwWctggr2TvdW1CtXtPNYbcTAE7BCEX37cw=;
        b=qNYJ+AsGd4zfU7DYhM0jucIC1Vohf4pmB3Elnea89jlv8ZkV8J7aLw2fTz8lHqo4xR
         +IIl/TYGSCG2qBEe5lA1d8sqX3J3vs7fjjQIN3rP2t99ZvEuZ9jq0I8U13pn+5WJ3790
         zJE0BK9Slrjgo60LWVT02G4+xKaL2XaUF9s9dQ7wB+uIvUVrmUj2+CZdfUFCuv6gWUW4
         OvDUs56dQz4PHusky9AxdpBrmuBmj/CWRfs60vL420BD5m1KpCqP6d+GPGIEJPF2b+Df
         MZekn/2iQaoVKFUtzITwnmv5qkBqG3P6w3pHY3Xgs3igTAZBPk7HnUBSButpEaxJHkvl
         AQvg==
X-Forwarded-Encrypted: i=1; AFNElJ9SONMjZYlvdtbZwGV0BMlUiBidvc3JjgsPbbieaQ5wPCuTSW2wAUT8jWBi3BrkobHv/IP82pMpbg==@kvack.org
X-Gm-Message-State: AOJu0YxJJ/DUWZEXN0PF2EwDGjI24laHsEWE4/dbi+fZyKUFCFwS12yF
	XMSAwgCAwpJ/UfO9oEayVOiybbwAiPe0caIhN7NWQRvoFjsLzdsKxarcWBFUHxlOErG76S87IJz
	/JecKZvWAHFezUUCzpnu69rYlB6c4n6yYoNjpLj2TrShzs0X997Gy
X-Gm-Gg: AeBDiessPATKAJ8bmPR2NRz5dOETBFk4CPr3urvhNjaUMhpiyO9kVhOWnm0gcrk9fqZ
	iiYKyrV0XyizPlm5wkL02/4iKmlnTekCrQjqkYNKLJVKZSgUIrwZONmZV1ZXOvxFmeqve/+q+Az
	hbMRyMU/qbVU9FY5JlX3pTsxZjl8EWBhY9M8LF7Gd3stDPnJ1LJeD8HiJNSeiozjS3WdIUPOoZY
	jiQyQNp8WC89wBstOZ7nD+zHt98TVkdr2yAs+nGRyBV7mSwpqCzkwXAmRGrds202EMtKK2fXv4L
	p93XYfO4KmyK9qpsx6zqN5uKXWDGJaNPByQVydRkuMCyoONrx5uyOGKrcAenr1C/hdrLqcXUDFt
	xHFtlG67DHox7/MVK7qUzii2A5TstDZcuzLgw9QzSMOtbtEbxDQ0elQ==
X-Received: by 2002:a05:6000:18a6:b0:43d:4e65:303d with SMTP id ffacd0b85a97d-43fe3e14f76mr20125443f8f.37.1776689470595;
        Mon, 20 Apr 2026 05:51:10 -0700 (PDT)
X-Received: by 2002:a05:6000:18a6:b0:43d:4e65:303d with SMTP id ffacd0b85a97d-43fe3e14f76mr20125355f8f.37.1776689469912;
        Mon, 20 Apr 2026 05:51:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4633bsm28592720f8f.26.2026.04.20.05.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:51:09 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:51:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and
 put_page_hint APIs
Message-ID: <c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yAn6RE3hnkXRYcAK6pWXb2IExftrMkpxjglqlPuGYlY_1776689471
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 5ki5j7tsmr9b1ab9x33g1rn79m9kgoiy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD09014000D
X-HE-Tag: 1776689473-421600
X-HE-Meta: U2FsdGVkX1+XcJ8OKh1Nh5uKhip+vMPZWfzo6fo4HBT0TbwvBttm+P1niOhlErT51zg5FiKEKSNUCdiadDNkIBSFKp/gXzAKKZBjuzqGaSq8SAT2M7rK4QexD7LskdrJJF+tdObFAq1E9i6l3kXFSoYBWFfoZGM0l18fM1fl/Z+Ls49hF7aPUqwoTgS9k+4Q2j7GVmTSDu/mlNhxXgncxu1LvBsKYR53+h4xGGvJsP7AeyK+7uznVNDbCqSsUcWWjTAudXvoiO25gxkflKhCu2bPlm5WxTCXUSIVfTYQaLsVv4oIoMjthWgEYtlzVTwO5Jo58H2MCr6WuaJQlstSB837auSrgTd9ilKnuibSWh2G+HCgoUKOQYhhdeZCyCHoxwvzYIDwQ3U04Zf12mdK2WPcPTv+9VmmgbSZbUj6/bneqg71Pt3p/w0yR/OYnJXdVOVCUBN3ObMdpze0Jbo7/gMoRdkzSj6C6/NnPoiOF9pNvA5SGWU6Baj+GIY5GxpT/Vdu7kCGRe5DfV1zkW/E6+g640OW2SeZqQ4usiZkWDUSTexcwqz4diCwWqjRMxO9HnVq0lU/8MySu7yBTYHtt47AvECZBqPtFFWoA8CaMdjdHE4iOTAXQwlCAifx0lkk5BOAN7YgNIpiRuyPN1XuqV1IjH85rMTp8Qy48yrYqQRLArlb3wCJxzOcTgMD7lTTOgn71hxqPYIqE7NXu0gLxg1HIADLfHvipPwibVCqgXsTMlU1Kia1Oh7apcD88REpOn7xMtWWFatj4pTYQ2fmgRQWFjBVjGM/TVz1BnkKCaeD924c8gWz/zXnIHhv+NXWgQ0Oz4q2HfBAxCd7LQ02Nb5BJkz9JsZw6xfqjIADORsyAL1ikbz5vxBgsqXr6ES8E2UPFmpJeGcjmidZke+NjQEj29WcgOtt+jha1cQP4BqCyI/cnx8aGWzy7ehLWTDIDmV7K2S77KDPXyETpMV
 NQmArAtG
 iFyv2lQCPWC4z3Zx3HRhbev8/zlxDel6vEjTzZgFGpg5trJI94ccoWO0hydjxORNqamDj3/vFoU44TwYQYcyqn4URkconTbLHvCBFE1v8nVHaN+3PLZVaH8xIdLTZj3Z8DdFgr5QwZF/5J7z9FijbzwNWG5mSyMIRoByu0tFljfh/YEQKesFRwhvHW5e2XlORWseDa8QL79VRwrsQipsu2FRJLC5pioihdfJvvU4weNzaNIQoe1Hhlb/WpMBwLrCH3jm/kwP2jGU+uopT77csWakOs0cpm7w4OSusJqCbf6bliC7aH8M5laWzWH0XE8Mx77v0Vsfpj7Rdnr1MqUxEuLsE5HbvJ3r2fMnFM4ue9oWac7wqMtrLM5p8aehfUuTwzRZWHPYVJXoAoi1XbmRmxDzbyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add free_frozen_pages_hint(page, order, hints) to free a page
while marking it as pre-zeroed when PGHINT_ZEROED is set.
The PG_zeroed flag is set after __free_pages_prepare so it
survives on the free list.

Add __folio_put_hint(), folio_put_hint(), and put_page_hint()
wrappers for the put_page path.

These APIs are intended for balloon drivers during deflation
when the host has zeroed the pages.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/gfp.h |  2 ++
 include/linux/mm.h  | 12 ++++++++++++
 mm/page_alloc.c     | 21 +++++++++++++++------
 mm/swap.c           | 19 +++++++++++++++++++
 4 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 14433a20e60c..b226d5e1930e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -404,6 +404,8 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_hint(struct page *page, unsigned int order,
+			    pghint_t hints);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..f4e28c55e2c9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1640,6 +1640,7 @@ static inline struct folio *virt_to_folio(const void *x)
 }
 
 void __folio_put(struct folio *folio);
+void __folio_put_hint(struct folio *folio, pghint_t hints);
 
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
@@ -1817,6 +1818,17 @@ static inline void folio_put(struct folio *folio)
 		__folio_put(folio);
 }
 
+static inline void folio_put_hint(struct folio *folio, pghint_t hints)
+{
+	if (folio_put_testzero(folio))
+		__folio_put_hint(folio, hints);
+}
+
+static inline void put_page_hint(struct page *page, pghint_t hints)
+{
+	folio_put_hint(page_folio(page), hints);
+}
+
 /**
  * folio_put_refs - Reduce the reference count on a folio.
  * @folio: The folio.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a4cfd645599a..f04813db3015 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3000,7 +3000,7 @@ static bool free_frozen_page_commit(struct zone *zone,
  * Free a pcp page
  */
 static void __free_frozen_pages(struct page *page, unsigned int order,
-				fpi_t fpi_flags)
+				fpi_t fpi_flags, pghint_t hints)
 {
 	unsigned long UP_flags;
 	struct per_cpu_pages *pcp;
@@ -3016,6 +3016,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	if (hints & PGHINT_ZEROED)
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3051,12 +3054,18 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 
 void free_frozen_pages(struct page *page, unsigned int order)
 {
-	__free_frozen_pages(page, order, FPI_NONE);
+	__free_frozen_pages(page, order, FPI_NONE, 0);
+}
+
+void free_frozen_pages_hint(struct page *page, unsigned int order,
+			    pghint_t hints)
+{
+	__free_frozen_pages(page, order, FPI_NONE, hints);
 }
 
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
-	__free_frozen_pages(page, order, FPI_TRYLOCK);
+	__free_frozen_pages(page, order, FPI_TRYLOCK, 0);
 }
 
 /*
@@ -5385,7 +5394,7 @@ static void ___free_pages(struct page *page, unsigned int order,
 	struct alloc_tag *tag = pgalloc_tag_get(page);
 
 	if (put_page_testzero(page))
-		__free_frozen_pages(page, order, fpi_flags);
+		__free_frozen_pages(page, order, fpi_flags, 0);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
 		while (order-- > 0) {
@@ -5396,7 +5405,7 @@ static void ___free_pages(struct page *page, unsigned int order,
 			 */
 			clear_page_tag_ref(page + (1 << order));
 			__free_frozen_pages(page + (1 << order), order,
-					    fpi_flags);
+					    fpi_flags, 0);
 		}
 	}
 }
@@ -7879,7 +7888,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 
 	if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
 	    unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) != 0)) {
-		__free_frozen_pages(page, order, FPI_TRYLOCK);
+		__free_frozen_pages(page, order, FPI_TRYLOCK, 0);
 		page = NULL;
 	}
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..1dfd232d3944 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -113,6 +113,25 @@ void __folio_put(struct folio *folio)
 }
 EXPORT_SYMBOL(__folio_put);
 
+void __folio_put_hint(struct folio *folio, pghint_t hints)
+{
+	if (unlikely(folio_is_zone_device(folio))) {
+		free_zone_device_folio(folio);
+		return;
+	}
+
+	if (folio_test_hugetlb(folio)) {
+		free_huge_folio(folio);
+		return;
+	}
+
+	page_cache_release(folio);
+	folio_unqueue_deferred_split(folio);
+	mem_cgroup_uncharge(folio);
+	free_frozen_pages_hint(&folio->page, folio_order(folio), hints);
+}
+EXPORT_SYMBOL(__folio_put_hint);
+
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
 static void lru_add(struct lruvec *lruvec, struct folio *folio)
-- 
MST


