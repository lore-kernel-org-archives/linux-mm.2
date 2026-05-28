Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002DECD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A69C6B0098; Thu, 28 May 2026 05:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356C56B0099; Thu, 28 May 2026 05:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2940B6B009B; Thu, 28 May 2026 05:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15B2E6B0098
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1C07C1FC9
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:28 +0000 (UTC)
X-FDA: 84816366096.06.071D391
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf19.hostedemail.com (Postfix) with ESMTP id 534AB1A000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sk5xpDBr;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3vBrP0czaKHTwDPD06avz57QmH+1JNC+yH6Fj/n/GA=;
	b=4krTtZn3f2wvE9t3uDq0KP/EH8Rgv45UY/rpguvHPploSaUlSX8I7mpOgzkGvzuHpYyI4i
	wICXw/KUoecIZ+LGkf6PUVt3C9WhAyFIPq+zflDIc0gSKTE7JIq3L1jvGkVQ1PCV82+WLP
	FGL0aKTkot+vfWGJV8GHZp1fH7xPCj4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sk5xpDBr;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779962007; a=rsa-sha256;
	cv=none;
	b=v5+BIMlmHkeR8ZMPAHaWeSdu4WIauCEh/lJId9tp/M8v572yoSwIV3//N8W4rKkC3tvKse
	7us/UbVmqsZB8O01eJTG0x5hrQyBDTg3uN0cc4uNfo3OgSzL+fjHv+i7SUN1lGhKd6mUZ1
	NJFUTExi6t3ttDQxhBypTPKgdf9ceoY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779962004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v3vBrP0czaKHTwDPD06avz57QmH+1JNC+yH6Fj/n/GA=;
	b=sk5xpDBr47nH4YUBnVq2KUK2/+UXlt8usoKUf6Y+8gEF8KPMkHtwSRb8O6Drk6AquU3OX3
	TIdfIFYTVVdzSyz5lkB4UuYwzI3wqP1cL3M8Qex/creCZdP56x8yevEHAkkXYekhECnFSi
	PllMc7zDX3aNAYJ45Yy1gFsF/ftvc9k=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v2 2/2] mm/slub: introduce helper to decrement partial slab count and clear flag
Date: Thu, 28 May 2026 17:52:44 +0800
Message-ID: <20260528095254.43721-3-hao.li@linux.dev>
In-Reply-To: <20260528095254.43721-1-hao.li@linux.dev>
References: <20260528095254.43721-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 534AB1A000A
X-Stat-Signature: t1gsmz5kmkns3djmdbzpfykmob8h5yzh
X-HE-Tag: 1779962007-143060
X-HE-Meta: U2FsdGVkX19sHJpgsXamE84UeOpO1MazvSPf0Lo6VzNN73We2L+qSLkxc9eYL64KL1LXxG+vlCHp55f/I64GRrM+Si3YiUkQ43hWWI39YBPnf8pw0Pi9aj8xGPJ1jMEY3KP0LHqqj/xrYnMvgZCVKpcOZygVtKc3HhvEoy1mPX9C0pqU/tKLmnYawerHoUgsXCixPhCmCAvsmah1HeXu+/+EPfNlRXtvWFtu719geGswCkxpG4a6xkh1jaMOMvubfPn0Gjz2n20eYa02NaEEgnkXPnZDMNp2MQIqH18mgey9RB7a3OLVSj1giDN3kvTP0dsX51ad3hg8iYT2/pWYX5fWtrSOvdS6E0IMg1MyKSmd1SQy5UpUPq2jCFk1imCE69UnmwFRLoKTJAcdL4G733saY4rzFBi64sHezFMA8noN+VJHU9vhkhTyu1zwAQc65DV9Rs9lw6urIb/uTsNoFyJ2bvW0cLjFcLLKrJaijIIOw+gQF1LwBqjOUHu5teTbxU9tshYkUlEScWwqd6nEYA+gO2bFIj4FhLBx7FlVF0OOhD1aV+nzwwfCU9kJ0kwBmEjJi5YpcJ8kVeqUg8XMeUDM0AuI3yovnQgWPF10K2XZUv1puf3WP/waXNRZ3kR1Mo4m8ygpp5xAZbhGNYPyv1cWQLXfVHnsVfOgebpT9FE09nKeBe2sDGXjdHukow3ouJ06X9j0upDbxzFMuQJYcswmHtQE2WfdhqTgcwKzIIj7wAC81NJG1tcQ3YVbVJOmdMaaQFsxBir1mUL7r5G/MBiNeLWbhr1D0h3k88yeixIWE9HxnFa9PujC65yFoYbOIpBMbU1ykSZf6rQQtaD2+jfq4V4g+AeU9KtCKhlDoFvznV5NQrYb2TRZT0iNhuO69zkA9jQj2fMgqKLeyT052jQo4DDoMQX2CXr9O5cRQ08AxgHV1Mii6om0F2gMa7YV2l2FYF2oCc/i25R6XTQ
 hmE79g/I
 GZQ25AOG0OrmmsMNGswM3xTjcEL72pEIkgIHEDuuKcmd7HbLEe763xmpp8s2iWZ1gusN4YOwGSibxOBKJLowWw4kquWgSUUfbVddmcuBkaWR5hWp7ZzrzQgzkitG2DyhZ+OpqhZowVnhv8o+CNT8fCfYl/QjcG1DGRT2qjR0t1rX6b1NmAHpY+W/+QRYB3io/lKQsGaYooIdI0exwkEjn8PY/Z58WwxQYZgc2xUCKxMq/sFPYGBa17twXYZRQ30SbIBcN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wrap the partial slab count decrement and slab_clear_node_partial() into
a helper function to reduce code duplication.

Suggested-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index eb60b3da23ff..71305290c8ca 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3539,13 +3539,19 @@ static inline void add_partial(struct kmem_cache_node *n,
 	__add_partial(n, slab, mode);
 }
 
+static inline void clear_node_partial_state(struct kmem_cache_node *n,
+					struct slab *slab)
+{
+	slab_clear_node_partial(slab);
+	n->nr_partial--;
+}
+
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct slab *slab)
 {
 	lockdep_assert_held(&n->list_lock);
 	list_del(&slab->slab_list);
-	slab_clear_node_partial(slab);
-	n->nr_partial--;
+	clear_node_partial_state(n, slab);
 }
 
 /*
@@ -3786,8 +3792,7 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 		if (!first)
 			first = slab;
 		last = slab;
-		slab_clear_node_partial(slab);
-		n->nr_partial--;
+		clear_node_partial_state(n, slab);
 
 		total_free += slab_free;
 		if (total_free >= pc->max_objects)
@@ -8286,8 +8291,7 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 
 			if (free == slab->objects) {
 				list_move(&slab->slab_list, &discard);
-				slab_clear_node_partial(slab);
-				n->nr_partial--;
+				clear_node_partial_state(n, slab);
 				dec_slabs_node(s, node, slab->objects);
 			} else if (free <= SHRINK_PROMOTE_MAX)
 				list_move(&slab->slab_list, promote + free - 1);
-- 
2.54.0


