Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C479CC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF5A6B00A1; Fri, 21 Aug 2026 05:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70796B00A2; Fri, 21 Aug 2026 05:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88936B00A3; Fri, 21 Aug 2026 05:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 977EE6B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:38:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2866CA2FDC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:38:35 +0000 (UTC)
X-FDA: 85124776590.07.EA20963
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3AEEF40005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:38:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787305113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xlEOdlu4msF49a8IhNA+LeROtCCzXGHfwFBJSFcTntk=;
	b=s200X57X0q+feO/g69aGuBBwlk4b1C1vCzf/1p/bmTJfQ8M5jvEQVf2qML9A4VmhxQAnyn
	DcsD08stXhOJilGbqV+QNQv3EB/l9FfNIZXetOkj8xUPobVGz61m+3Jfu0+/3B1RaWcClv
	taLZ22Zm7kZ2dq6SxjOlQT5J0/uH7n0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787305113;
	b=6NXmZcuITSqcMzR62qddOfD5xvRNck9Pt7yPhgEJ2IiJSBthL/qiB4EYlBF4Y8trI7v5M8
	iacN/jfwJL7tep9ZBrmHRxx2fEW6a9id5z3hP7m6JCq25u8VcuIjwrh9tnJJy/b3E2ClTk
	qoG5wMuxA2kE36eXJot/n3H6s33LHB4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id A08963EC29;
	Fri, 21 Aug 2026 09:38:25 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 2/3] mm/swap: refault on swap-in, not in the swap cache allocator
Date: Fri, 21 Aug 2026 11:35:55 +0200
Message-ID: <20260821093606.2231216-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821093606.2231216-1-alex@ghiti.fr>
References: <20260821093606.2231216-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTErKtDAElrO1XbYJ02bIJ5u+kAEI771CSqWJ4BMPbtzjcc+QiDRiT8rnvO7aEvGHLxV55MABFghpv2hRYyhYb22X+k3a534lA+0fLaXgI2Vl7ZOd3J6TrKoqujZ1fPXnGKsf89UhPI6nmsLVsEkISjh1U++gQpnpFreovJhpwsvZnkYuliYT2nNg2Cu84Qf13ASmPW708FrP3WVvrWhfrZRI4GD9mEQIGiOpdtdtoYyMrBrp8kXvIBheI8bZBHrdpz17b7iPu7m5BqEZWyxDHPPiN6qOYko0Dvrx5vI1pn9INeM90CNQtJDG5KS8A0OtWMdvh+AtL3I/bYyuKcyAMzSGJcLVn6H/kmqXINANvDNz/y60uykSPG0k0YZyBd3Kiqzh05A2ep65JDrP/kg7qmWFq+H6KOethjqGQvR/Hb+1oNm0k6VG+JpFhNHKhyXA1MUJ3ZS9EJHXGtpcqdG3Fv5s9/HeOJ2hktMJXn6g1Qtq6CmIkubZFCPm7l3a8E9TFdJLMGSTNzv6VaAvnsxjiFxoHxwbtnKWnFvbvKQE9ar0vLMrEIdfiwxQl3Zon4DVZG0PnHFpSL5ueyz5Srt+9d/Gr/0Q+xI870cKIwNKyFQ5hBJLF/0ki6fUj9FakPXy+7HlDe+3zegtr2qAA1NfM8q1G4IflHsGYrnmUypy/VzGA
X-GND-State: clean
X-Rspam-User: 
X-Stat-Signature: s93yn1kgke1nkoyinf75w975hgqcjgke
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AEEF40005
X-HE-Tag: 1787305113-586675
X-HE-Meta: U2FsdGVkX1/bc6zOWEQwiUCzAv6tEeQLVyBk89aZMLoKa7rN0lBMo2//1s64iOkMj986f2qJO3tFYqihZnoW2GyDEy6pOliBCwzbki5xzfx7qLuMG6OgKA9oTiPn5aDR6GO3YurEE1J2yBGDLyJqDeE9e1JZkAt7+kUgbavlzYQJkCBj4H5du459SeFlcp6iVM5RM/8fgn5pA1cLNLq1E1FBChkjkzEPdMjOLVxQKovJOvHs1Sii4sQ+eqz/3ea1PqF/gHoCSNf8bLwI5vRP3A72cMYvMQSO9F9M99Awjv1mBtaRyZ6DqN/OBCwUO66SCjn1H3flSb2GCwoXUTwC2z6cCbaS3iOO4I4H4KSl4nq1QlPgMVw+GSvrPOwAwsc4JIvXOy9geIyBGRad+tm8I1ErfkQtizzu48YBgJNkmOPt5TE9WFcTwj3siL7xIL6LJYqNldJ41+X8q5jrrSOR714rGyPoeZxxnlKbiqcHT3phBqeYAT4pbHgMSiWEwwV2kWrzGiKQdbjHBtc6vFuLVDbFrgZo79uS1kwSC9CcYcvYvady4JRV3MOE4Dq4WX+J+GIBgNRY4Ax/DM1P9w0EHkfsTYd+5miz2tWARfIYC3eNWq33+vcg7ewv6z7VeNz4r3dO4tf1EuyQTvO7V0FlA9cJ7hOVnmi7S7lKyu28l0PhBEzy9w0+Kf5ycJPnKJc+x2mgP6lGTz4wGua5PFUQdmWMJriNY6ky5+5qNiRGoyU5/szK7KGamIJzCzYMACFz+/k163PFnjC9s2k3yC/2UwvLFCQz1HpxEntHs/TiW/xF0Jam/9W5hxoP89UhgW3m5GK22nT34h4MlPQM4Us8hpBXdNeD44jABvcok3+/XFCD8FZhveuF5mzC9ew7EHMHqM2JK7+zYqpwwSgkgafwjnhs+qnpeZ6PJZR8kpd0iW3/T3B2ph3/ooGVVM8OR6XU+QpQqxrzhR1PxCu4F7m
 cJcUK2dX
 Md1mx3f1WfEHwu2G8iMtSM3RyJvAyedF2sY8E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap cache allocator evaluates the refault of every folio it
allocates.  zswap writeback also allocates through it: the shrinker puts
a buffer folio in the swap cache to write the compressed data out, and
that allocation is then counted as an anon refault (and, if the eviction
looks recent, as an activation) even though nothing faulted the page
back in.  On a workload that writes back continuously this inflates
workingset_refault_anon and workingset_activate_anon substantially.

Move the refault evaluation out of the allocator and into the two
swap-in callers, which read the slot's shadow before the allocation
overwrites it.  zswap writeback keeps allocating the buffer, but no
longer reports a refault for it.

The refault is evaluated before folio_add_lru(), as it was before this
patch, so workingset_refault() still sets PG_workingset/PG_active while
the folio is off the LRU: folio_add_lru() consumes both when it picks
the LRU list, and under MGLRU when it picks the generation.

Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap_state.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 90638a8d7232..4e15d50aece6 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -477,8 +477,6 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* memsw uncharges swap when folio is added to swap cache */
 	memcg1_swapin(folio);
-	if (shadow)
-		workingset_refault(folio, shadow);
 
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
@@ -640,17 +638,26 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct swap_iocb **plug, bool readahead)
 {
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
+		/*
+		 * Capture the slot's shadow before the allocation overwrites it,
+		 * so a fresh swap-in can be evaluated as a refault below.
+		 */
+		shadow = swap_cache_get_shadow(entry);
 		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	folio_add_lru(folio);
 	swap_read_folio(folio, plug);
 	if (readahead) {
@@ -681,17 +688,26 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
+		/*
+		 * Capture the slot's shadow before the allocation overwrites it,
+		 * so a fresh swap-in can be evaluated as a refault below.
+		 */
+		shadow = swap_cache_get_shadow(entry);
 		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	folio_add_lru(folio);
 	swap_read_folio(folio, NULL);
 	return folio;
-- 
2.53.0-Meta


