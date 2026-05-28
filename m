Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274DACD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FBD86B0088; Thu, 28 May 2026 07:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC346B008A; Thu, 28 May 2026 07:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2766B008C; Thu, 28 May 2026 07:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D31A6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:35:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 063F3407D2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:35:48 +0000 (UTC)
X-FDA: 84816623976.29.C9E0B02
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2535814000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:35:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779968146; a=rsa-sha256;
	cv=none;
	b=dDEcpfRBMC3nMpoMvpv5XGddXLGGCUvor+OQ8+0e5cvxeEdej5Xpv+I0BFxb4PfxjfNYBw
	8fJIq4DkhDuBR0FF9O1MscjtqniglkHCzSYBlbzbhau6DoWdFN0Y6lARBX6UX/ZUt5y0k7
	4aZ5i6rwQj+YRqzwR88HR314P/vjOmg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779968146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=b4i57yzRnWEhfXBL9ZfdMWG2a09rOSMdpLSkqgpy7oM=;
	b=U+VIyImLGrxRQ8ENPAYs4rUy9mr2P0C2Qtk2temW5F38/Dqca6kxm+HIJfNFHRA4Tq/syf
	wwwCu977LNSxkhubxDpiXNjyJyUYubiIQSyzWAOnjqqfC6Z7JG63M/Kt8FvCM9MC/qoML0
	lhzUcc6VzdiFJkEFgq9XIGuJDjbAI1Y=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gR4DZ1FDPz5BNS0;
	Thu, 28 May 2026 19:35:42 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 64SBZY8q019030;
	Thu, 28 May 2026 19:35:35 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 28 May 2026 19:35:37 +0800 (CST)
X-Zmail-TransId: 2afa6a18288917d-17382
X-Mailer: Zmail v1.0
Message-ID: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
Date: Thu, 28 May 2026 19:35:37 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY1XSBtbS9zbHViOiB1c2UgZW1wdHkgc2hlYWYgaGVscGVycyBmb3Igb3ZlcnNpemVkIHNoZWF2ZXM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64SBZY8q019030
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 28 May 2026 19:35:42 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A18288E.000/4gR4DZ1FDPz5BNS0
X-Rspam-User: 
X-Rspamd-Queue-Id: 2535814000A
X-Rspamd-Server: rspam03
X-Stat-Signature: iemai4i8qo94yuzh4o5zu8au7skcux16
X-HE-Tag: 1779968144-202836
X-HE-Meta: U2FsdGVkX18qlEOZkK+RmdPrVQ1LDkjaFcO731jfgs99rHy0T0nAr0J9HstCESZHxQBRX+4WHNvQ/5ycLEv7nRmTN6E3u4AOqHasL9GiOtJEcdPp63yk0R8ENycPfeb+X/8CgWuE1UM4PQFkwx9pi6nbYMLZV+YDiJ0r1pXkl4OIocSY7XtoLVDx8NIY3PMr5XbjiqcHliDiP65ildEuSRkWudVpqn6QA4oo+ebM+Yn+adAg5Qt4XIK/A7cH4VlvBU66XXj6l+eCkf5n/CJk44+limVawot9P4sEAJDZplC/Wkizd3QIkCzXJCewF16B3SCVal4JvURqwcOynzZElIpDH/RPQcAuroG1wlxsyeDHZuMSiXTjotRFAerXDo4JtOHfJ1scEwFA0vYO9mfH3E4ApleNs77Z/3x5+7QU/UPbU85xfMbffW/1HH2/NCYnoAaxB0mf/sdfZmaj+nsPuTY0vtO4FuSItNfwwp/LuGfvRB/asIXJK24jtJ2FSdTodDUaokX3RPuV2cob3frlM6YMkt0oLjyEG8Be3PEu7yC9ZLlOcjshK2klIOi6zKLFREbPcMP47PiGTKvh+Dfr0R0kxHRXMMdrS/bmJtxmZiv/5Lg9oLYWxHMkIN37NWJmC9Io9RUCGW/+K3+sWWttzJYJCy/PxnnRiqRVcl/ga638VfNCcsEoarRMvT8gfoxg40J7J//NAG13zGTPnNlmNeZVlmj+50g5cE1HGpQJyOaZAFwc8YM2q0uL0OKnWUH/X4ElBM1ZouNWtU0P2miM1VEqTfRCF8NWey0CDY/KXfFzSKhJbOUBdNDwii8lJi38V76Tpq7QMLTRA6aRbOibyW4U5QRGW5wTT/Hj1OMkIqTCf8vl3fUZLqXR7GdGZ9mqJR4AwtInUEHtGm7IJz+2l7yqc+/REij3VRWMBGP+heZuzpa6nGF2H3ty94OH+OD4ZDJ+6C09Bhz0VIb4j2Z
 FxrpUbz/
 nFjMO0ACGrqgLpKxf1fFRsYVqBH2OA4zE3fwIM0Dk8RdWXpNCT6bQNdyeVXku0//qy9zgoNLRSb4GK+s4KL/uYimNIbmr38me5wMAp4N7hYR/1IHXx4R6dewHkxkHMBg9FO49ehbLPtpmQr84zSjH7QMGHMJJXvBYn02OGDujxwRQ4MT4+mja2LuaJNcyT05RP0K5k4KsB/TOOwc+GdAMGekZTIydJ9nhe3AQmOX8rJbSVXc4duSEWyVOqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

Oversized prefilled sheaves are allocated separately because their
capacity can be larger than the cache's regular sheaf capacity. After
they are flushed, however, they are empty sheaves as well, and should be
released through the same empty-sheaf helper.

Allocate oversized prefilled sheaves with __alloc_empty_sheaf() and free
them with free_empty_sheaf() after a failed prefill or after they are
returned and flushed. This keeps the oversized and pfmemalloc return paths
consistent, including the SLAB_KMALLOC-specific __GFP_NO_OBJ_EXT and
mark_obj_codetag_empty() handling.

Keep the caller-GFP filtering in alloc_empty_sheaf() instead of
__alloc_empty_sheaf(). In particular, do not clear OBJCGS_CLEAR_MASK in
the raw helper, so the oversized prefill path does not unexpectedly drop
caller-provided flags such as __GFP_NOFAIL. The SLAB_KMALLOC-specific
addition of __GFP_NO_OBJ_EXT remains in __alloc_empty_sheaf(), matching
the free_empty_sheaf() assumption.

Since oversized sheaves are now allocated and freed through the empty
sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
sheaves. Update the stat comments accordingly.

Keep the capacity initialization in the oversized prefill path, since
capacity is currently only used for prefilled sheaves

Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
Changes in v2:
- Rework the change as suggested by Harry.
- Teach __alloc_empty_sheaf() to initialize capacity and pfmemalloc.
- Allocate oversized prefilled sheaves through __alloc_empty_sheaf().
- Free flushed oversized and pfmemalloc sheaves through free_empty_sheaf().
- Link to v1: https://lore.kernel.org/all/20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn/

Changes in v3:
- Address Hao's comments:
- Drop the redundant `pfmemalloc` initialization in
  __alloc_empty_sheaf().
- Keep initializing `capacity` and `pfmemalloc` in the normal-sized
  prefill path, since the sheaf may be reused rather than freshly
  allocated.
- Link to v2: https://lore.kernel.org/all/20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn/

Changes in v4:
- Address comments from Hao and Harry:
- Keep capacity initialization in the oversized prefill path.
- Update SHEAF_ALLOC and SHEAF_FREE comments to mention oversized sheaves.
- Restore the oversized sheaf pfmemalloc comment.
- Link to v3: https://lore.kernel.org/all/20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn/

Changes in v5:
- Address VlastimilBabka's comments:
- Move caller-GFP filtering from __alloc_empty_sheaf() to
  alloc_empty_sheaf():
  - keep the __GFP_NO_OBJ_EXT rejection for regular empty sheaves;
  - keep OBJCGS_CLEAR_MASK clearing out of the raw helper, so oversized
    prefilled sheaves do not lose caller-provided flags such as
    __GFP_NOFAIL.
- Keep the SLAB_KMALLOC-specific __GFP_NO_OBJ_EXT addition in
  __alloc_empty_sheaf(), so allocations still match the
  free_empty_sheaf() and mark_obj_codetag_empty() handling.
- Link to v4: https://lore.kernel.org/all/20260526232429176aHA6oZjTYdhXcZVHc2ZQ-@zte.com.cn/

---
 mm/slub.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 04692a6f9128..8663ce4ae1b0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -362,8 +362,8 @@ enum stat_item {
 	CMPXCHG_DOUBLE_FAIL,	/* Failures of slab freelist update */
 	SHEAF_FLUSH,		/* Objects flushed from a sheaf */
 	SHEAF_REFILL,		/* Objects refilled to a sheaf */
-	SHEAF_ALLOC,		/* Allocation of an empty sheaf */
-	SHEAF_FREE,		/* Freeing of an empty sheaf */
+	SHEAF_ALLOC,		/* Allocation of an empty sheaf including oversized ones */
+	SHEAF_FREE,		/* Freeing of an empty sheaf including oversized ones */
 	BARN_GET,		/* Got full sheaf from barn */
 	BARN_GET_FAIL,		/* Failed to get full sheaf from barn */
 	BARN_PUT,		/* Put full sheaf to barn */
@@ -2762,11 +2762,6 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;

-	if (gfp & __GFP_NO_OBJ_EXT)
-		return NULL;
-
-	gfp &= ~OBJCGS_CLEAR_MASK;
-
 	/*
 	 * Prevent recursion to the same cache, or a deep stack of kmallocs of
 	 * varying sizes (sheaf capacity might differ for each kmalloc size
@@ -2791,6 +2786,11 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 						   gfp_t gfp)
 {
+	if (gfp & __GFP_NO_OBJ_EXT)
+		return NULL;
+
+	gfp &= ~OBJCGS_CLEAR_MASK;
+
 	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
 }

@@ -5015,12 +5015,11 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)

 	if (unlikely(size > s->sheaf_capacity)) {

-		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
+		sheaf = __alloc_empty_sheaf(s, gfp, size);
 		if (!sheaf)
 			return NULL;

 		stat(s, SHEAF_PREFILL_OVERSIZE);
-		sheaf->cache = s;
 		sheaf->capacity = size;

 		/*
@@ -5029,7 +5028,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 		 */
 		if (!__kmem_cache_alloc_bulk(s, gfp, size,
 					     &sheaf->objects[0])) {
-			kfree(sheaf);
+			free_empty_sheaf(s, sheaf);
 			return NULL;
 		}

@@ -5097,7 +5096,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (unlikely((sheaf->capacity != s->sheaf_capacity)
 		     || sheaf->pfmemalloc)) {
 		sheaf_flush_unused(s, sheaf);
-		kfree(sheaf);
+		free_empty_sheaf(s, sheaf);
 		return;
 	}

-- 
2.25.1

