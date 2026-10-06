Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB3DCA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013C36B009B; Tue,  6 Oct 2026 05:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C5F6B00A2; Tue,  6 Oct 2026 05:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43B26B00A0; Tue,  6 Oct 2026 05:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5F286B009E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22A50120182
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:42 +0000 (UTC)
X-FDA: 85291656324.29.375F9F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 641D64000B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVpLBxgf;
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278440;
	b=RH+S88/jupXG/fwkFd6bav+p4sKHZ89Mno1nlQYTnhFCOSEQhlbYzs+NpFWvvzeZaWUd3t
	83yuXc19xlEM2TqWRJFEldaoBY3XiWWKHFd7ayZExsZa3iGpkrsRZbfMxT2ObSZ4nddCqX
	WwlsfXOoJk6oMAUB/mMutk32+cR4bFc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVpLBxgf;
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnyrpAYa14sI6txd4i9BRZdPd5nnZg7VR0kQkLdWkQw=;
	b=sFQ9oTlrcqeVfftS7ErybEEJohMByT/TBi4gU7laibiiQU8bEBIR3epPI5d4OR/VANA07i
	RoXh+/a1KP4b1Lz+wJ68qRS1LybJrH0PbWOzymAc5PqrUlcKUcamFSOdCu0CrCeDNhBYJQ
	1PTaxZdO0+nfOkrSbN6tNGrfYnZfVMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AACB8447C4;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888BE1F008A6;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=CnyrpAYa14sI6txd4i9BRZdPd5nnZg7VR0kQkLdWkQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVpLBxgfM0rONG8Wiwrrt+BhOMXh4zL2IuOALKVYginZxUX/sgl5lHJGPcHCzPhYb
	 xyIfyzfGeLK/YZIAtGx2FM9tYy89UNeowwgeonbhVtB58jYPR2yraJiEpMbBWJSUcM
	 uFhrZFhuZ+BXwXQaodLHmPNB+kvd1+oP7enMIKBsad3i0IVDBEDqE0GQGhCq1hJUnb
	 D2+A7jGE4SpDgT1woYYm1nBOD+7fNCvcyKFOFfjDaaGHCXmx/RMcb3o2Rne/4ggJoC
	 o06DCfwkWu0JNR7R3YwQ/R5QdgSp6E6dt2UoXzMLA5BsbnK2gc1kQpJJbKrFH4MlAc
	 tQ1OaEdUcNw4w==
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 8/8] net: skb: isolate skb data area allocations into a separate bucket
Date: Tue,  6 Oct 2026 02:20:34 -0700
Message-ID: <20261006092035.166776-8-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3264; i=kees@kernel.org; h=from:subject; bh=croNj7wGZJutVq0MdlBIPVhcFuxS4L8MSQxkndGPUZM=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9iZOsbhvGdjwZt/kH1+3q/4/WHJ8GWfDpJT5Ok/OC SW8kLR63FHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjCRXx6MDH0LL/dzTltYrfc+ 6GZ+x5LTld4lV7P9l/OHuu89cDfLoJbhn1ZvG9/Us2n/vislCfxZ7Lvh12nXul8nlY/8903zi5/ 8nwsA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 641D64000B
X-Stat-Signature: 88zx5y7fgj46oehsy4emmgw3m45zwoxd
X-HE-Tag: 1791278440-292970
X-HE-Meta: U2FsdGVkX18XoB6Q5WMwJe0OzfUmDXItfwjF+CqGkEQrRef8K95A9sqHqOQR+NAU3fWRr/ybhRuUMjc2d3WcWDMmkggcQsZ7fEqsARF1OC5jGKgpA8uosg62ls72z54q/pC1p+c5oKoI/Mf8bMghvpdxmufV5qMBprofBNpp6yVGKzWCK5EdGoFp6zt6MyVS301nl/MemN+fztWmaRmBwqdNqxaqwRUocRbYRNyhjzwovENN0E5ag5qvh+Lz2wBLFm0eLT1o5hxniTt5rtI8amKmRjM3kGBa1GPhxb/1lkLZuKbbOgeR7noSY3PsQv3YcmAn31nMu5/jOikszj0kpvWhECqjberU1Yog2xGXMTs/YOwZCKeAlNn0jlWetPOzkGmEMtCvCqVHt6f0XaaVNz9Aw3TMN5etjnJNqwHRIjJa8hoVxtXrdshUeUUBwqrVu1/ThF5hH3Lin2p6L+G0WuZwqDAWmgFTVzJuHzQNswl+d4KjZNno0QsqlBtr471tv3DsGSO6d/255d+06CM0ig3+1NQB4vNV4pccFAamxqdOQy9v5MajH/71A8we/8gkQBKgMZAl2Qh1XQFoXWLS2+4dj1tF4YzpLr+pfanDYWDXbbZPXf4m7RWrJEs1aYJ+BBV6PUrAO3HPPqYgJiMtkTf0yD45FILuWEbUoXWDUhhpJIggy0dXcX6GpoAb3jUCkKlOjKTRFv7w6WgYo8D6p0h9Uw8BSeOykRKhA5naHoj7+b0MiPOBpuf4FH+79O0BD+hjbxKpzbfFF3VxFRRMhyKwHzLmUzajXVfSbb8bDJc1PscW/X2Q+ZSzDrPr+eyxD0Ip3oMXTih+K2l/htIrjJZTTjPwaGM1pGVTKTSjMNFzWrlNk4iQwIdvwbuuKoDBFJzqDHXUJAzVSMZS4XI7xpd9Sh6vculqH7TGlC3+e6A6Xa8PKkBQBkN9ZfxKujgoHmxDoAPlI/RFmQgPk5T
 H49HZhm7
 lcfzH+1I/l23b0oxrGUaozIrNuI6PwsxcVfQR6oPBy06tl7S/UDSyOgppN54HtFH8fSWVB2vtjQqpDKnPFCnkRQODrfgX8QGFBOOwrGD7qDg2gf+zhwObgj4iUDurdfOGfhOYRkkrQDNQG/VfqKJ0d2Yw0d8o4ngCOW9Dm4i2BvkEykIGA7lyCTc6YAbuO6urXsN0CdbEd+Ivuy+RjPSkQsVa7N3dswPMEUAysEUADAcpKzgNhXJXcTetRtS/LbP4jeo2N9xi+QlOctV+Nqx80YjSVjovKZrpbhiG0+62uncN0ETdn16zqsKodiBHAjzZpdQM
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

AF_UNIX sets sk_allocation to GFP_KERNEL_ACCOUNT, and those skb data
areas, the ones most worth isolating, stay in the set, where memcg
charges them as it would in the general caches. GFP_DMA falls back to
the general caches, being passed to an skb allocator only by rare
devices.

Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 net/core/skbuff.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 966af3beed94..6f6b5f4cb39f 100644
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
@@ -593,11 +595,12 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 	if (!obj_size)
 		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
 					     flags, node);
-	return kmalloc_node_track_caller(obj_size, flags, node);
+	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
+						    flags, node);
 }
 
 /*
- * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tells
+ * kmalloc_reserve is a wrapper around a caller-tracked kmalloc that tells
  * the caller if emergency pfmemalloc reserves are being used. If it is and
  * the socket is later found to be SOCK_MEMALLOC then PFMEMALLOC reserves
  * may be used. Otherwise, the packet data may be discarded until enough
@@ -634,7 +637,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(obj_size,
+	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (likely(obj))
@@ -5235,6 +5238,7 @@ void __init skb_init(void)
 						0,
 						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
+	skb_data_buckets = kmem_buckets_create("skb_data", 0, INT_MAX);
 	skb_extensions_init();
 }
 
-- 
2.55.0


