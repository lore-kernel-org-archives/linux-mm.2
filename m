Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784E2CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 13:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26146B0005; Mon, 25 May 2026 09:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD72D6B0088; Mon, 25 May 2026 09:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC8C6B008A; Mon, 25 May 2026 09:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7A06B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:10:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3780B86090
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:10:16 +0000 (UTC)
X-FDA: 84805975632.14.B022037
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4675F14000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:10:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779714614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=WaGcJ1cTnCeP+whh22P4ymgxEXNgIxwqLlIgoAI2mlo=;
	b=iY/asnKJ66H2L/xHPU9ItTKsKhNEtcfNM2wOBs3mw3Vp9BgT+zikKuNKzbg1uaVPYokBVL
	twV5OdRxn+oHiqZS6qyAQEXKEY2voxfXYJaODjhaZZ4aTsQCkRaPloh7YVzpoI5YuWjDrp
	MogWRpD1SImWo+c7Gic6rrviNiRq9pY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779714614; a=rsa-sha256;
	cv=none;
	b=XuNvkDTNCCia9aA+5Wac+yiPmt1IRaATmmhSA7p4bjuJeeAnf65qv9Cwo8QYAYgXW8FNPr
	ylf/FNuaNTp204jP9C7Wfs8YOjBB25m8iOEB0X/jx6qL6shnTGaPCHJVQoDmVjyXnEfOJW
	2yBXMaFYkU2ivb/lT5soNQ5J2bshShI=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gPGSx62Nsz5B108;
	Mon, 25 May 2026 21:10:09 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64PD9vPR077828;
	Mon, 25 May 2026 21:09:57 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 25 May 2026 21:10:00 +0800 (CST)
X-Zmail-TransId: 2af96a144a28f0e-b7461
X-Mailer: Zmail v1.0
Message-ID: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
Date: Mon, 25 May 2026 21:10:00 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYzXSBtbS9zbHViOiBmcmVlIHByZWZpbGxlZCBlbXB0eSBzaGVhdmVzIGNvbnNpc3RlbnRseQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64PD9vPR077828
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 25 May 2026 21:10:09 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A144A31.002/4gPGSx62Nsz5B108
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4675F14000C
X-Stat-Signature: 4zrziqn9hfx88k995paxh1nmp814ucou
X-HE-Tag: 1779714613-522515
X-HE-Meta: U2FsdGVkX18jyl/OG2o+7qRhGFsfZyhtxIoyhossPjjDsrY+HMMMgoHEbw4h9pC6pe4eQHfX1EgMdZjlt0hHxMs+2rnQN+7Sk6VL9iZ8OtCazEfbmkphW8arwV2JOrJCjgknjoEDwYQGj+cHZkbH+L/NoKnoLwuBbn/KE30J4AJvMMU37HKw3jj5iRGVM7P2g14LhCA6avtT3ZNHUwHkMECfJ2B6ru3EfZNMjdnLqzxLDfMBRQt2MAUnsoNb/W6DdWo2sZriI6k6sN/w57bVlIXHVj8fVX9cdNNJrAh2wY3ezAvp2tS+I74zt9oGW9f+bL5dnkm1x6sCFpWPWlf9w+YWlfx6wUZQvQYG9rbhB2TPfhCZ6MJietspNBxP8gvQET4I7sB9rO7reP2AjzQ544d3TQX5NXQVqoVH65Zqg4SUKtshtYfF49WzsIXLQQnh/5wBqk5KZXZ8Tb5/fZbbkG8NmVls9o5bqfEe+ACH0C6m/VnrePYH6MU9Yi+jujFmIQ0qjSMOYTvDa9evoluSfuxc5m3Y/1AvqtP+03W1qJijVyH4iQIca8oos6D4y/uD+lRRqO9UKn82HylvtqJi2VEt7rsNZqfYEAAiGcqReJAjrsW6PT+2ar+3VYYWHCHYQTk7w31vcLB9cqIsnlH3PBUq7cUNvqttZzH7HsrvfSCwMSwSC6bZpovtCj/Iq6fFKpfKyFdfX67ZDGMDtcGfhVZcTTmQM8roWtOku+Htw1SXpsXbRprqvSc0EYfDOhyMwoo31ftewLJBD1C7GXM6xljPUMvrBUglucXPlE6decdxV92MVrjJnwcq5sW+u1O6QlZaPpSo0+C1EXgUZhEzsAIDalh/ufI2PU/0idDbDYQ46dnHCO0nCgWf/a669chUv7E/AB85FA6ZvntR6wqo7p6OklH8Y5ODx6n0ljk5JHaKLw7NY+uw9C+/AiPZ9Q3SvJeHwdo/uzlGjvXFt90
 /rX+F5H5
 pH7bkOWxYf11TSo5ITaKI88lxECavIC+jZ0BqxhoZhEs0/95/wL/Z9c83UGJKrb5MtOZP3wj5uGIQgjwB+5sFiCjYnoZOErnhlyVvMmRR+QjzhMAyYxg0RZfLwLzDJjGu+HacCOk6qTt72Jztq/R9VadFNphYXE0DzyomidFz0SldPHymZ2Yu2IRMb4Ot3Qmiuh/+yiCsAk1j/V5GgDKtrRHRAgmaPBkKExtkBwIdHGIKGiUpe6kM4n3QtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

Empty sheaves allocated by alloc_empty_sheaf() should be released with
free_empty_sheaf().

Move the empty-sheaf capacity initialization into __alloc_empty_sheaf()
and use it for oversized prefilled sheaves as well.

This keeps the prefill paths consistent: after flushing an oversized or
pfmemalloc sheaf, release the now-empty sheaf through free_empty_sheaf()
instead of kfree().

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

---
 mm/slub.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 04692a6f9128..f4c06bf43f2d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2782,6 +2782,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 		return NULL;

 	sheaf->cache = s;
+	sheaf->capacity = capacity;

 	stat(s, SHEAF_ALLOC);

@@ -5015,21 +5016,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)

 	if (unlikely(size > s->sheaf_capacity)) {

-		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
+		sheaf = __alloc_empty_sheaf(s, gfp, size);
 		if (!sheaf)
 			return NULL;

 		stat(s, SHEAF_PREFILL_OVERSIZE);
-		sheaf->cache = s;
-		sheaf->capacity = size;

-		/*
-		 * we do not need to care about pfmemalloc here because oversize
-		 * sheaves area always flushed and freed when returned
-		 */
 		if (!__kmem_cache_alloc_bulk(s, gfp, size,
 					     &sheaf->objects[0])) {
-			kfree(sheaf);
+			free_empty_sheaf(s, sheaf);
 			return NULL;
 		}

@@ -5097,7 +5092,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (unlikely((sheaf->capacity != s->sheaf_capacity)
 		     || sheaf->pfmemalloc)) {
 		sheaf_flush_unused(s, sheaf);
-		kfree(sheaf);
+		free_empty_sheaf(s, sheaf);
 		return;
 	}

-- 
2.25.1

