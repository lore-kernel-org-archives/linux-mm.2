Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA524CA5FE3
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B261C6B0098; Fri,  2 Oct 2026 19:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87BC6B0099; Fri,  2 Oct 2026 19:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976596B009B; Fri,  2 Oct 2026 19:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8F66B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:11:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC0C8807EB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:36 +0000 (UTC)
X-FDA: 85279234992.29.F95C79D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2114340006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZwDDJgA;
	spf=pass (imf04.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790982695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2S6KB+pb+BQT5oUBqFqBJ538QVfRgtrf68Zq5YYeGCI=;
	b=iQgrmnIczpN8aOqZpQdi/m9kt9gcmLuwqWvlgM2ug2WJ4xQAB6Mwx29SEHDOlTLptX0jbr
	rGd6ky92V373bCurxzVIh5mVD1RQPz/DqbnO0YdYKgdy+jGpB8ac8DsyV1RjCi+XOxAZ19
	PCBoLx8gObqnvldKzY1BH4F0mqWz3BA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZwDDJgA;
	spf=pass (imf04.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790982695;
	b=rGGCZkJfdU7uPysU9ginb3yGeMxhdyesBoofGJzc8OeGVUEzMYa5QR9OckkgBzsH4kI613
	Oonh/kCa4tcDBREdNFzQeC5Hq2KUT4SLbfCsU4AQOKwZm+QmdepRP5LCGgfghLtS2vQDRh
	IORPp/Aen3mUH6xX3DxWqIhEqBxQyBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C519C4481E;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F0F1F00A06;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=2S6KB+pb+BQT5oUBqFqBJ538QVfRgtrf68Zq5YYeGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZwDDJgAQSghfefVAcf1aopBete44JcDPrKGL6PJwJzfBYFU8vMxVqCe6UyXBmz/x
	 TNQeNLWMRwMUN6KJG15N/2h49A9XaujWv7NDH6MJZ720SGkGECRdDU990p97hf1aLN
	 wAG6n7Qf+ekX54iwAG64JAb0SfxnTUZU0ru3PwUjtQYvvLu2bltbmU8PIsXEvWyi1J
	 FcQVEDnLZz+hh18WTUf3Y+ZIDWphF2xeYyAF9qJWzxbt7uWdJHiwOm/AYHppugfpFU
	 YqLeFIvXsYj6Ah3zUyhGN1j2oAN4O/dEO9yCtD3zJGrV75IJQB8zw3Mt7Zd+4wiy0l
	 hyQT9D+tFV0Yw==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	netdev@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: [PATCH net-next v5 7/7] net: skb: isolate skb data area allocations into a separate bucket
Date: Fri,  2 Oct 2026 16:11:27 -0700
Message-Id: <20261002231132.1646573-7-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3039; i=kees@kernel.org; h=from:subject; bh=6RSadgWMGYr7w5XXzzDRtJ8OGCSMMWfVJU83WYKH/TQ=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrOT9qv5cV5CaV7MmgWXeH1HWxZ+47u33u886tfcO4 5dt0X7bOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACai/JGRYWrn6d6I6MO9V+1E U86tY6maqum/cdUiy7XHdti1hjKz5zP8Mw/kaXirdKske23hPeVWuZSW3raY3fPuW9cr3hX8+b2 ACQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2114340006
X-Stat-Signature: 1nie71fiu31654p6r4a9j8pikzpbjc7a
X-HE-Tag: 1790982695-88736
X-HE-Meta: U2FsdGVkX19NXPy4NSm3pb2v+Ra5uyI2IC7T8ggtpEQnjxtFhoHu3aVSjK2Mve/4WPzHjxdDWRgTaVlZtFT//yNDT8JTdAEENYkDmo19p/BcOZ8oDS/wBBjrN5L45ax091EYk6W/BqSGWNW3zDwoZJ2GshCtQJjujvr0wZlhs7RKkSBVqyl2c7w+fApTFZ4+tRIt3fmnnRlMHcicYIDnWaC4BHL4XIPSGGBXz1FTX6l3AwPrlsW+LjEyqqcLdG2BvNvHtYdfJnyuSy72rNH6oJUwrDdJSnaRKE/gI7hiJgiQRY/uQ1+YWGPGFS/BUY4YROhWg+RW42UOezWlsts32gNPEj2Bs6h6/s5sVrxUYa6uk67m4Bed8Lawi6pKYkg9g8pIt/Uc8U4l2DbwdJYx/6HVTv7BULJuhE7fVz2VSCZg7RZ3HHP6cmXlspt3EGgULPSB9fjmH7XcgZVfulN0ydeQ79P7tss0RrUXcZtRbTtH8ZJusggwFEK9l6RfyeM3Re7lPVjx4tuGZ6M7I69vBeD9NQ1vDoijmfS3X2UjlGLorHqH8gv1vixv0lDAACri/K14EDFVr0TdMf/GUM3rDNWL5vyZstNXF6Qgd4cDUM0WG3YNTT9PZsd6ZFjEKsDaTsGJyWKDOjiDjTKOxJHb9QOvwohD6IB3VDlwAPgwATickAimha+iGBL1nlgKj9IhTn+TTid5H9YkwD4nDcXSZ2+us2lqJBxPwJZJOJTYlucfSe7DKXk/cTbmtxkj0SHPxplOaM2z+ImGgKO6QV0KG7C2t785TYHYgmpqseCN3RmzOMHSHR0YLwJfECQukmOboL9s6dTiK05NdrOb4Cl1iCpnkSjnCAtAslzQ00USjAiurhnUD1Sw09NiLfHzHnAR56iurvSQfmYCmBXPo0LjfD6V6JaIH2Dlqgkt/Ni8z58H4CKqyOfSbjGF4WrFbDW1HkGupu+AsRt5QJEOyPm
 vq34XJbw
 lJ7bowI3Gez4pSUamulgjEM4yv6pkd0m2TaqqOj4gSanfFIVk1u3t2A7NPvFxgEpt+TjdegLzC8Hpo3ei1HIlUCC5xQ/bp852HlrQDcrK0tBSS102jQYVU4OEoCPmgxvI+nzV8IJ87RD5/UsCQIEg7eK8EmMUVCeMnhdfqGzsoQK/Ft8EmyYftzBXdiDS3oitPvpdf1H1J6nD5tm8nYOdLjPfOsvaZYIns1QarAj9TCvLiiRYF7jXwdta5NE7J2TJ48KbwgMZRwcZbeqCMLQ3Z0W+ankzsKvj1OZwuuDnFVthgZ6tJsKIhd3IPtD81bML+mwd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pedro Falcato <pfalcato@suse.de>

SKB data area allocations (as done from alloc_skb()) use kmalloc().
These allocations can be variably sized and their contents can be more
or less controlled from userspace, which makes them useful for attackers
that want to overwrite a use-after-free'd object from the same kmalloc slab
(which often just requires the sizes to roughly match into the same kmalloc
bucket). [0] is an easy example of an exploit that uses netlink skb
allocation to target another similarly-sized accidentally freed object.

While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
probabilistic. Use the existing kmem buckets API to further isolate these
allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.

Ask for the accounted kmalloc type as well as the normal one. AF_UNIX
sets sk_allocation to GFP_KERNEL_ACCOUNT, so without it every AF_UNIX
skb data area would fall back to the general caches, and those are the
ones most worth isolating. GFP_DMA is left to fall back, being passed to
an skb allocator only by rare devices.

Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 net/core/skbuff.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 966af3beed94..e0660b2dbc19 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -586,6 +586,8 @@ struct sk_buff *napi_build_skb(void *data, unsigned int frag_size)
 }
 EXPORT_SYMBOL(napi_build_skb);
 
+static kmem_buckets *skb_data_buckets __ro_after_init;
+
 static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 {
 	if (!gfp_pfmemalloc_allowed(flags))
@@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 	if (!obj_size)
 		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
 					     flags, node);
-	return kmalloc_node_track_caller(obj_size, flags, node);
+	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
+						    flags, node);
 }
 
 /*
@@ -634,7 +637,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(obj_size,
+	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (likely(obj))
@@ -5235,6 +5238,10 @@ void __init skb_init(void)
 						0,
 						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
+	skb_data_buckets = kmem_buckets_create_types("skb_data", 0, SLAB_PANIC,
+						     0, INT_MAX, NULL,
+						     BIT(KMEM_BUCKET_NORMAL) |
+						     BIT(KMEM_BUCKET_CGROUP));
 	skb_extensions_init();
 }
 
-- 
2.34.1


