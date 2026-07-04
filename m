Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E57C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 08:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DA96B00B4; Sat,  4 Jul 2026 04:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF59F6B00B6; Sat,  4 Jul 2026 04:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B1D6B00B7; Sat,  4 Jul 2026 04:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77CF76B00B4
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 04:05:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4025A0450
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 08:05:00 +0000 (UTC)
X-FDA: 84950358360.17.9DF8519
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 61179180003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 08:04:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783152299;
	b=3j8O3LJuwZOn2EQBQKyhD24//O2JZYMPPDFfqlP2cKSSa6rE6yhailfh3jVqdy8nT2o/ka
	JXoi+Cj/yUyJxvgEZkWESybGce99tLwhH58Yb2ZMjUnN8ZY6A7jw1ZF4FQCItYGNZWhj4Z
	OISH1RpFQmbWtsdnjprfNkiuFJceoCk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783152299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=2LSeS6OOQb//wtwByIWhmHGFDjON8rDYfvIzffmPM8k=;
	b=kW8nOCR18Hx4qWftRdrRkDu/vQtgg/DTqC5bqi20Yr5RRbtHfINar85uDApcVyOlvhVFQS
	RNC6dmZK4IWR3vaMg0sn1QEsLW+bgyvULiVnWUKXXvAciZAk7aJWehgcwj3CdE13sF0FFI
	aEzIqHk5npVs42ej6fESB/1zFoIswZw=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gsjpG3qsFz5B101;
	Sat, 04 Jul 2026 16:04:54 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 66484npL029654;
	Sat, 4 Jul 2026 16:04:49 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 4 Jul 2026 16:04:50 +0800 (CST)
X-Zmail-TransId: 2afa6a48bea2383-2098a
X-Mailer: Zmail v1.0
Message-ID: <20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn>
Date: Sat, 4 Jul 2026 16:04:50 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9zbHViOiBmaXggbG9zdCBsb2NhbCBvYmplY3RzIHdoZW4gYnVsayByZW1vdGUgZnJlZSBiYXRjaCBmaWxscw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66484npL029654
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 04 Jul 2026 16:04:54 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A48BEA6.000/4gsjpG3qsFz5B101
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61179180003
X-Stat-Signature: oc3wayoh34c448wzah6y85paaqjoaqok
X-HE-Tag: 1783152298-43114
X-HE-Meta: U2FsdGVkX1/KaKknKqhss5g/FFOqdR5r1oqSCD8op6zgYrIFufJQ9xJtxuPDCJ885uIV+so6ptKAcla1ABXf4uc9z+7yEVng8vfyF43FoFgQ22X0TXHCPr6Kj3W9hX0adOtcaGJg7JRTtiZbAV3Mr8wgRjm0ZsWPYKklVGe3VcXKOpyqAcvpeIZbcvwpD1YifDeiPXbgAQniiLStawkIwH8dkBhHCIbUu1QFF+6r4zgnPtqO49eGkiMcZXkRcKV4oCX8HJMjFgMzq6te9/L6BJG6v3HUdRUl/mIGPnrriFjGwZARBetdDjnbIl9b2Jg0h+9kAAKy6cJLml6AI0BQn7EKScloONSacjCCJ9bn0TBYAyz4/PH2XGL43gKm8CgzD96ZaIz47GaKgVRsByOKitIXVZTpoe4Wm+qR0XcyIGm+qge7Ngo68POCbk/+p2s3AQ0bWiaCHMGH6aoLCijYexDOE2KybU02ZA1IlZclR0Ll7NGw5w/E7w6y4Y1YFYxVPG6FUqNCSX5S/zjmye5RPXnCujlEjOYpctsjQ/ZGxg5cJurxpGkgyGSG45WZt+fSx/6lMPjYU8PQrJni0QuNoabKx3qhrflgOzr5/vTt/cUNKf+NK/6nRHPzVqL9q+CyibY2sDo6Fa8sWO5+PaM0nsm5p8QfbdIJikHpG4wcW6rCmILo/nS9uOBAbIMArf3H/l1n9zRwfYyZC5ThoQl2BtiEo1eRA6nM/Hi5hl2ZacfDu5P0R7Bx1U9LV5abrVRA69RMDiLw3uQpUZ9ds4JLegEr47Br8WAWKxZ09B0c3M0Vlt1BmzF4gTKuXn71FLBsGRR8kIf0xi/fq4EmMtkdS5KoGji8mWLMx6AUAVg+AJYRYTqW8tUFFXAKtbikPucKm0FxANOndWAehChqOTXhAfPDCSttsSMyYPSTguU6SWacnZTLwVxCXGYqh5UWCaRocr/3YgQ5OhnwKvesb78
 EfCkr+ml
 +wbaBUpkNP5rhMEo7o/IA0nNiwDWSt9GAKtkrnjeQSi5vk7+xjWBcuEorZ7RatK9Dd0bw/yOJaC0UGKybDZPV87rjik//ADm6YKLBHLs7eybl4VMCtZLBHP3+Wrtjlb4wfddVt9UUFMzK05TneiaLm79vPb/eHqd6t3QZ5+z50wz/bh1G1jksRs7sZeH4ztTKpJ3reB7cTB5G1w6pP2UHLuEr9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
the code jumps to flush_remote to free the batch. If all remote entries
have already been compacted out of p[] via tail swaps while local objects
remain, the flush_remote path returns early since `i < size` no longer
holds. The leftover local objects are then neither cached in the sheaf 
nor returned to the slab freelist, causing a memory leak.

For illustration:
 size = 64, local objects at p[0..31], remote objects at p[32..63]
 After scanning all remotes: i = 32, size = 32
 p[0..31] local objects are dropped.

Replace the goto-based flush with an in-place free of full remote batches
during the scan, then resume processing the compacted array. All local
objects now go through the normal fast path, and the tail path only
handles any leftover partial remote batch. The redundant next_remote_batch
jump label is removed as well.

Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object freeing")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
 mm/slub.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9f754cf1c187..4d7e3067a5d6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6193,7 +6193,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	void *remote_objects[PCS_BATCH_MAX];
 	unsigned int remote_nr = 0;

-next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);

@@ -6208,8 +6207,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		if (unlikely(!can_free_to_pcs(slab))) {
 			remote_objects[remote_nr] = p[i];
 			p[i] = p[--size];
-			if (++remote_nr >= PCS_BATCH_MAX)
-				goto flush_remote;
+			if (++remote_nr >= PCS_BATCH_MAX) {
+				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
+				stat_add(s, FREE_SLOWPATH, remote_nr);
+				remote_nr = 0;
+			}
 			continue;
 		}

@@ -6293,10 +6295,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	if (remote_nr) {
 		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
 		stat_add(s, FREE_SLOWPATH, remote_nr);
-		if (i < size) {
-			remote_nr = 0;
-			goto next_remote_batch;
-		}
 	}
 }

-- 
2.25.1

