Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E450CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9476B0005; Thu,  4 Jun 2026 08:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889A66B0088; Thu,  4 Jun 2026 08:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79FA56B008A; Thu,  4 Jun 2026 08:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBDD6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:27:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3758E1C1DC0
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:27:48 +0000 (UTC)
X-FDA: 84842156616.28.F466DB9
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9FB03180004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:27:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780576066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=FJGkmvCa9IHx1hVGHfuMwJ+Og/IgEp+YpLB1zSyBesE=;
	b=arru0zJDpjpEYjChf3XQoGkySsipgta/MccbEqonRLRCrZvyZk42uSjHSKF2O1HGyO2CZH
	lYXv93art+XbiXmazGI6Ykndezgjpi7aZ+OxgfnDMQq3sYSNwnpEFed1W51UzN8figtkiF
	eQ44D4HJRpy2N/qJtAv2dVvawqzdEDM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780576066;
	b=AuzFhs3NCBgX6K0vqqXBLb8mA8hux8njVYX4CbalyZxb3m9fnMaovoyWBqFb9m217g4cyP
	2ojsFf46Abn6hrB4Iqj1WX3JqF5qM6bacKim7aWLU3hTwmDDm6CGlX8sFiDi+ZFD1CBJlX
	rUYxjWJG73j2M78KQjPoQOscJXyKLfU=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gWP3J4xs7z8XrrZ;
	Thu, 04 Jun 2026 20:27:40 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 654CRToK075263;
	Thu, 4 Jun 2026 20:27:29 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 4 Jun 2026 20:27:32 +0800 (CST)
X-Zmail-TransId: 2afb6a216f34b2f-c53ad
X-Mailer: Zmail v1.0
Message-ID: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
Date: Thu, 4 Jun 2026 20:27:32 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBtbS9zbHViOiBwcmVzZXJ2ZSBvcmlnaW5hbCBzaXplIGluIF9rbWFsbG9jX25vbG9ja19ub3Byb2YgcmV0cnkgcGF0aA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 654CRToK075263
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 04 Jun 2026 20:27:40 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A216F3C.002/4gWP3J4xs7z8XrrZ
X-Rspamd-Queue-Id: 9FB03180004
X-Rspam-User: 
X-Stat-Signature: 81whmrwgx8zn46zmtxzd91p7p48w7mhn
X-Rspamd-Server: rspam09
X-HE-Tag: 1780576064-173266
X-HE-Meta: U2FsdGVkX1+eTc4KUt6KhCeg7qiml4VtUMKl2Q+3dIBeWnWj8mBKB3oWyrXLXXVd1fTVujfb7lYAxMfXFm7imCFBfcJ2hkJZvgJhxradRyu5qwpv0nI6CwZCHdWkReVVB5MWK4rChHJ6GphC4UhxY4/+/3g+TMaShLT8MjrhWlOc5q0/fptTjgXXVZYNDtnMugVUDrQYpc/OEq7sRzWQJOF7KHdBETwm4ZEByJi03xjiROxPm3GozFAX0SAwhbHM3gzlGCWz+nSdclvHaNuPzffv2rcnOcf+2/enO9Ul9IyR0d18uMxtXUImGEHxYM8HXzwLcBE4B1lJBHghmOTFZMNFwx71twIktZU9D7mXRDn1wjOkZ64wUCw9mpV+bsj/D+sSRtqLNB+wwJ93llZ3Cv9980LOMHYxCtlJMmoH8TAJcfWaJpl0C/EyLDsmhfnPlBye3k7fV1l2uqkNkSDne4mP+oxo8MJQa9PsKvYYcJ3vObL0EJCYpAOF2SSY/Uh/OPQDltBTHpJviQWbcaDFXmeDzpHhQ5PQ19a/uz9XV1DwbRc577gyEf+5s1CeJKmn0iwYc3IGUGcP/KeGc5xANjmQPJNmxMHtvI2fGjyUqksDaPzEP9ZmfKOXna8kZF9MCByggl0ARnzz3wWFJ+3gkBjdLuUBL2zcBKsBVFcMtGDS7ynMSpk6YOt+xcbw3l5zOOZ6VgyJaRyZfhB3ffFDQJNTDrKxe8ti6YDybBHJC2R1c/jMd/L8UFAde9p98w7BMWOJX4/perxC/4clLJrEslqC2QVzT3qkIyEgurTK04M4X80rY0m17WsKese5NmXEODGSRIJRch3nDOvual94TrcM+QTBt68knbgY2/7K1lKTEKnQlvvoFLqEZGo5eoC8saezcKPXjw8DKgMmNQ/wUwq2t78yooa34fNDJahniFTnCXf9Xeoes56knJ23iQeRX9hY71cXDXCV7wwbEer
 mdYKhZyj
 gAose4hIa/ZgDvRbzM8zddsm8m0ertY1dpw1mO1sJ6VjDcPtKtwN28fZLKphgyozazjbxBPt4B52h/1BbEPgAz3RXtvoYuYzTZV4nMhkfCWglXlIFOg9jJELKCAkMPtptcrZssMnZCF5nkj2C8tNPrffA0qEgUu2TlNd7vhem/CDKy6i6lzX6RdJckYANMIEB0WicgZqJNL67kratcR2NZJmV+zTNbo+dl3Qy2GPutdnDlLoNkY3wJimgf76lLF/kH+UGH0KSlfnQpo6fnP6FlKn7ANX1OOnus+TE
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

Keep the caller requested size separately as orig_size and pass it to
the allocation/debug/KASAN paths. Continue using `size` as the retry cache
selector.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
Changes in v2:
- Use an explicit orig_size variable instead of bucket_size, as suggested
  by Harry and Vlastimil.
- Link to v1: https://lore.kernel.org/all/20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn/

---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 67abbbf68fc1..7e1a1fe5daaa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
+	size_t orig_size = size;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
@@ -5398,7 +5399,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
+	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size);

 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5422,9 +5423,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 success:
 	maybe_wipe_obj_freeptr(s, ret);
 	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
-			     slab_want_init_on_alloc(alloc_gfp, s), size);
+			     slab_want_init_on_alloc(alloc_gfp, s), orig_size);

-	ret = kasan_kmalloc(s, ret, size, alloc_gfp);
+	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
-- 
2.25.1

