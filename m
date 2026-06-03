Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08B5CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0226B008A; Wed,  3 Jun 2026 09:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079B66B008C; Wed,  3 Jun 2026 09:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E842F6B0092; Wed,  3 Jun 2026 09:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7EEC6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:05:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 745E6A0341
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:05:38 +0000 (UTC)
X-FDA: 84838623156.05.D14A892
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf02.hostedemail.com (Postfix) with ESMTP id D3BE580010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:05:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=+2psCEdHz2MlqyTpA1+7BYHrYL+dorP1n7QDY4omABw=;
	b=C6JGlJlX3LtqrvodvOOeWWOJ/EoaWsw4giWM1+CLvdFyVvoWdzLM94AzEu2Di5TTEEjzPA
	GKx8CvaLNrnld4iw0wQvrzg8qSlXwc3fS1nJoXioutSBhUXLbZMDUYpCCuKyF61p1iMaPE
	yq6Zu3SX1dMVKqazdhLpV2uDdFwUW/I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491936;
	b=YNp/4zqZge+OY0SUi9PRjlLuDo3kIn9mdcLgDmmhdY3qor5hEe8NRfJ5BoPGqM+SCZ1XzF
	y+enXJl/jD55TBikSqlJazsH02Hcm2Ck5NbC8PZ4jkoz5tiU/GgO2pByJDraxmNkNWCCPD
	QFdBEXmEGPkSno9Ea1pe7mEOAvkDcts=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gVnxQ1pTHz8XrrJ;
	Wed, 03 Jun 2026 21:05:30 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 653D5O50070885;
	Wed, 3 Jun 2026 21:05:24 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 3 Jun 2026 21:05:27 +0800 (CST)
X-Zmail-TransId: 2afc6a202697ae7-409e4
X-Mailer: Zmail v1.0
Message-ID: <20260603210527431ZrTTKiFTGmLH-rs42OdIP@zte.com.cn>
Date: Wed, 3 Jun 2026 21:05:27 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?bW0vc2x1YjogcHJlc2VydmUgb3JpZ2luYWwgc2l6ZSBpbiBfa21hbGxvY19ub2xvY2tfbm9wcm9mIHJldHJ5IHBhdGg=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 653D5O50070885
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 03 Jun 2026 21:05:30 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A20269A.000/4gVnxQ1pTHz8XrrJ
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3BE580010
X-Stat-Signature: i9fzawcznk1op7zad9chjtq5ddpehnd6
X-HE-Tag: 1780491935-543559
X-HE-Meta: U2FsdGVkX1/RYYNw5Rs7JtAjQJPGGR6k3PYKiyUdXw6/+NnFJKbkkctW/1j7JEbrZREEqxoIbD0H5dl61pYhoF5woA9zilPU+nRJcjBMjdlW0U4q0xuHfBsiVjrktIat6+US6gOnQCshptr465PlhqAYoeJqZcRzi0efQnMXvR4301KQMEHG+33RdGDWbmNAzELlnXdQNURPzAnFN6pZrxaM++8sOnGyzbcvyXJ0RHztKQQLwwxiDt0L0WSj3lZ+DBZA4K4b8AU6PX9/JV52ku2uiqzorVmMhAO22eReerPfIhSbri3/SyC+gLxal4KyaSa+wzjEj53K5wJZFh0MJIoNFCT6CSuBfhtSfd/18dtgf50oVnM/xUZEYtiT914yPcVcTCrEZDWiiADxAnOIDdyWep0zLI4Ku1VwwHS7STpiST+j0Ba94WsrOdkSOsNHcQb1+XCa9sFTcnjbCrkJiga7LVMM+Y7rT2V7Ba8EjMg4kc69RUkOBxfP6cLkrdde7iTixej7xiQXcrc4kwwsZrp5cASUhv7myze5FfyBGO/otR+w9EqiUQBNq/f9BoCnO16ouM9FTuVvfpAAaJbWteXYR03uNh7KwsU9bXnFZOp4l0MBroahGH0gMhVzS5a3/kbMiTjEw8a3nuGMO9v/AJXKv0YXaj5mrO5rak97bYqIqJ+dM67Zx8SrI8J8BApe9RRNyn8HXGIIMR+tuWllhKf2ETQVxR9I1S9kRz0B43qKiCtuyELMU9Bt0ltDCJiranQ5r9f4FF8MpeHk0VCuxgbMhaDOwW8NTJ7UtXtGz8icjiVZkIeQzh2nvP+TRc5KtwMVtHQwE0iMFsSFhFetL/glxa8b8i1cAF8h+oR8lI/Vv5axOPQBkRK0bSaBGT/a9aFwVSsjCwNTyqibkoEJjBXJ4xmHIckWB1DAW99raBRNfyEdl9uPJKXkkhfbqNRIE/4czGqZvU5E+vj7tbp
 5GR3kiSp
 eQZeHQdZ3g0xPSmOEhVmoxu7FxBAzBJuSmMSbyHyydUiHMgpUPXHtsTu5VnEVdMgzOS9wGQUtWJj5x4UFJg6LOPfkMtt2JH5VtpMFED5N5UZ1eGsX/Cb3nQnD9PDjhkS+/Mf+EGv0AY/5Y4kzoioYAegl7Yj5u8WX7sDtWJShn8rBMEZHD2jWdNTe78ALg/qLO/yaD2CSUB4OmopVHucy53vd/6K4G6LZ5hAf/GMBQlUZKxg2pDZyjvS8YTr+805VZvNaJP1W5a8cH2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

_kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
initial allocation fails. The retry currently reuses `size` as the
bucket selector and overwrites it with s->object_size + 1.

That value is later passed as the original allocation size to
__slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
successful retry this makes KASAN/slub-debug observe the retry bucket
selector rather than the caller requested size, potentially widening the
valid kmalloc range and hiding overflows.

Keep a separate `bucket_size` for choosing the retry cache and preserve
`size`.

Fixes: <af92793e52c3> ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 67abbbf68fc1..6a2b3ade3611 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
+	size_t bucket_size = size;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
@@ -5372,9 +5373,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		return NULL;

 retry:
-	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
+	if (unlikely(bucket_size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-	s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
+	s = kmalloc_slab(bucket_size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));

 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
@@ -5408,7 +5409,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 */
 	if (!ret && can_retry) {
 		/* pick the next kmalloc bucket */
-		size = s->object_size + 1;
+		bucket_size = s->object_size + 1;
 		/*
 		 * Another alternative is to
 		 * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
-- 
2.25.1

