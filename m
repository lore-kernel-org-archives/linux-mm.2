Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D52CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99026B0095; Tue, 26 May 2026 11:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70936B00D4; Tue, 26 May 2026 11:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD5A6B00D7; Tue, 26 May 2026 11:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7C486B0095
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:24:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 893B6120358
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:24:44 +0000 (UTC)
X-FDA: 84809943288.20.CE6C410
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf29.hostedemail.com (Postfix) with ESMTP id 427C3120011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:24:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779809082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=TSWd2gdeSAiirf2gt0ZfvXw1y0Z4lkiACkM2Pz+037E=;
	b=anaooPbLZTr/H3dY6vS3FcV/dDqn77R2leuPV76y7S0ZDMqg6+4CpDDhCKboM7FpXZV74+
	8nkT07GNniFuxO2H2z9CHgoFiW4cz0xujSoy4Qilvz9Y7WdbWhSxtjlzwaVHL0p7xParVr
	Bif9qPdkxUsujHAg41zCD1GqdijVG80=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779809082; a=rsa-sha256;
	cv=none;
	b=EeAIG1UKDvwDYTShyp3kJsyAXlgSuPl73Pr/ed9amei7v1epAYH/r3NVJNk7XMhPs+c0p5
	hhzq7qjAnGn1Cu18Ijc/VcJnhAXtww9TmjdiRffQ106wGjBE3m4ms4f/BUC1MJIBOAdPr1
	CknLNjk1mHt4M8v0YnuqbtNbImCQdNY=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gPxPc1Rlgz8XrrJ;
	Tue, 26 May 2026 23:24:36 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 64QFORPo004235;
	Tue, 26 May 2026 23:24:27 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 26 May 2026 23:24:29 +0800 (CST)
X-Zmail-TransId: 2afb6a15bb2d784-d55bf
X-Mailer: Zmail v1.0
Message-ID: <20260526232429176aHA6oZjTYdhXcZVHc2ZQ-@zte.com.cn>
Date: Tue, 26 May 2026 23:24:29 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY0XSBtbS9zbHViOiB1c2UgZW1wdHkgc2hlYWYgaGVscGVycyBmb3Igb3ZlcnNpemVkIHNoZWF2ZXM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64QFORPo004235
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 26 May 2026 23:24:36 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A15BB34.000/4gPxPc1Rlgz8XrrJ
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 427C3120011
X-Stat-Signature: 55p5j9fgdswm9g7dpwmzf8ag8tcezqeo
X-HE-Tag: 1779809081-385325
X-HE-Meta: U2FsdGVkX1/Quof4jTgpyCVV+qjnjda7PNTRKD/lMA1osL8LK++aXQq0yVihYjNqNru6FALed00kl0QVye0jomOUVCl25JrqdlH2HLiB6lgRSYLFGzoi7E7lFBQ2A7oqxZMOr6RHu4rgVP8woO1+lNGUmAJcE6AXxPSdtXVZHwHI7cmQJJS0VOPB4pe91NNkzB90Ex2rgS87STRLAsMkQBEDFlhXUbFDPDuYZAy1nxh3jC1+pkUWGEQe2JRCy///g3FC+FygwkaJpcxn6TyLaPazhWYndfO+Ooq6/okE7O5gMONQ7gIlsKeY6tXynyd/yC9imik6gCkWHtNIrHg4ZBpxw7e7Bple8Bq2zfJyVyIXAd6IVO7lKvfmIItuxr8ZLUlVsJDlx0mWA2JXf+2pPAECn5H7Sr8VskzRpYT9cWfPAmrBaRP7hoiUlvHXNg8vmHUFIzo2K76CRZbTjfsQeydvUK/cBsrXgKCTbxFw/6GXrZwGIsCzi8XWeJekUQlTMWYZha+Fxv/fKO1wNEA7x9IKCp13qYcKyZhRpKKWeBhDOuJhALE+3uUpUn+rrXiE+frewbYGsr4Goljo2nI3J4TKH8HRkmz4dQg/c8X5GEoWai3259tVLbzxifWWHPkjaO0UYzGsdLZ4ls+POFcONmNRFAIu84hJbzebIb5Bb5oO7VkErvrrSg4dewDW2m4vpJIQLV8VlnuJbCCJrkNQfyhLz/7uXlksKfLfWXUhMv2m03EkkvCl420E8rCIWoo+w2FhG9MBHvj9wz8UIAXih7Rfj62Z7OIA/6FbbkBocJ2lBGqSkNKuR+RjS7z9Qudgdtbu+kffSxDqBQ1o6nlm8ecJaG/DKphL88IEHACR8ost7odj2Tj6ak6vWnQEPRenKOwKUP0OLsV/KfjJXE3Kgix2Eq4ER7vVAJcZlgMmtaBg/6hxg3Ou6qr91JPzqSqHlSVj4DHykPe/t8cFI58
 n0Ar25Mq
 KXtVmMJtXS/hbG+gFo1O+i3NupBaIOHEuXlwfJYBmpuRv8HYs59cwVWn9KCPKEljYQZgZRrs2VTIHzbh+ZnWtdVO/mOcLiO1t8HlDtZ9U4m2vZrswBHBxcuG3ldhRSinFfVL+COhq58oHguB7u+KgFe0vmyQXbYys9t6GXRkpVY0U3qzKFpmoXJwKQfYBjfoTlHm3OF7shdCDeWL7sKtGHH73mY750Se9th/PX35XMSx1wm77MzGi/JWwDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

Oversized prefilled sheaves are allocated separately, but after they are
flushed they are empty sheaves as well. Release them through
free_empty_sheaf() instead of calling kfree() directly.

Use __alloc_empty_sheaf() for oversized prefilled sheaves as well, so
that they are allocated through the same helper as regular empty sheaves
and released through the matching helper.

Since oversized sheaves are now allocated and freed through the empty
sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
sheaves. Update the stat comments accordingly.

This keeps the oversized and pfmemalloc prefill paths consistent after
flushing.

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

---
 mm/slub.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 04692a6f9128..08812de7a8b5 100644
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

