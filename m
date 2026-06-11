Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9060DCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DF16B0098; Thu, 11 Jun 2026 08:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE6F6B0099; Thu, 11 Jun 2026 08:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2BD86B009B; Thu, 11 Jun 2026 08:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B40276B0098
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:47:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A948C234A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:47:00 +0000 (UTC)
X-FDA: 84867606600.20.DAFF531
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6F42A40003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:46:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sSca1lk+4IHszXL76rB4WMDi08SP8mFDHFZVnXSlj3o=;
	b=6Jra/0IuXQfR0qvI9mv8Q+5RzB5X+hM5I+lBPzw1Vea+tqIgBxXyikUqdGLlm6gXbtDq3q
	+4ChY74G+TqSLwh3Awa7slzCy20+uhb8/UAs9IBmossR8yK8/xgM5o8yuCJgBAJq3yyIuO
	GV0qQ2VgCUv2kmDMH2FW9yWIU8pLWD0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182018;
	b=xtcoUTgrBhV4cFDYJINK1KQD3Mqf98sFhrhO5SNFWgA0jqVsCzm8YHwHQoJpPBej18GfOW
	Spcl+PDD4aA0hDJrV8TbqyjLtf8DT4gurs6elmHrcAWXCMA4+e3Wyu0OM23wb5q5WKnLzw
	1jH8d3LhiLBCFwTc1Kf56pcqZkia7WA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F1606AF07;
	Thu, 11 Jun 2026 12:46:49 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB34E779A7;
	Thu, 11 Jun 2026 12:46:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SF0TLjeuKmpaagAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 11 Jun 2026 12:46:47 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH net-next v2 2/2] net: skb: isolate skb data area allocations into a separate bucket
Date: Thu, 11 Jun 2026 13:46:42 +0100
Message-ID: <20260611124642.345400-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611124642.345400-1-pfalcato@suse.de>
References: <20260611124642.345400-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hrhogyxaxd3h1w9bhz3mgbwtwedgr4b8
X-Rspamd-Queue-Id: 6F42A40003
X-HE-Tag: 1781182018-775675
X-HE-Meta: U2FsdGVkX19E4OhD2J/0fidzVCTQCaD4Yc8BZ8sY8owow6UvRaTbrbMb34cAWAcJeUzSYMaDwPjsXch/heQLaEXqPLeVkwSjjlpWokaNtHWN5ZaywhC4FBpIwXoSYY9XzWbdg2zPM1AaehbUr9gINeWov4wot3pM9QKP1c1zMOTrqUAe31OCvF7K9ZWrZgBYeoChAAWkS+Fh1jF2bMX/iTVZ2AgXjqKg9l2XrAxrfsEv8SHhRBSi9oB/SxpLryZ8u9mE9pvvfk+EIFQkDZFxs+UC35PJSM5QAeQaMG+ao/QSbgYUhrv4Cs69DPxu/HH8dW07ngsMUompxlL9xceEjklzAVQKxr5QrYZJArDJiGkkqbpCOwLx6PHdKE5gpkkLf7IjAjflByW/hNIA7I1MOYAVGt8r/GULseGPaoHhG00SAKEROVRXpwpeTWihyQ3o96Z64uWomo0NUwU4BapdgZPfoMPOA6kreF4PdmXT+nQvlApcexibDlFj6o3mNYvDpwSCbChAp8jhiZOVofsi45/71UGKD76qr35uNdYSmQCCSobDZo1VSGs0NV1DCKmNj4iu4cVm822GeZJK2/OszNVgIaeNr3jdDhVg8fvHUMQmbvbZGP1Af5Razki0ONsF1UyPCRVPnQnf+3/LjrS5Z1Ldx6sIqzT4b704KhOtvEk7nko1ZH6wlWNjBW+1itCJNCyOC1d4/A2YZuT9wa2ON9yg2XodmAX0aYvJXzSOQjzO2+pWg7sR09C8GbBgvIlw3+pEYm2whrHziblgglsju/AbL+ApvFRJ55wTtVfyMdDdawKvyRPTdPYEMPIgMiZtJ82bbZLRCNAjMwAszza2o06EmYY8xQWEKcrz64xjDN/wR6KJ+OqW2iDr0Gr/Oyt3iE1pcyezTu452fWEeUz4C6thh5P5A6NsZwNvcfaFadORL2Dk5eKM5l39loWS+fJ6av5sNzxTOe7/BsAuSD4
 uJjmSVsw
 3XnA92GOsNTBRlWj0/DpmqNNFI9VKooTxU1itenMCnmeMaOI/WIUVipYw0bF9uti7nFrJQe0PBFJUx1iSFpUkXujUklSL26TBRjYdLGBUYEOlXOF/PDBp3mJHWTC1+oWD7eVwNX3AvYPzdwntWNQW8VRuZp12CSoj0maafO90lQuwiiomgPlbHhg1ZS6gPccq871Iw/fuOcOGkY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
Reviewed-by: Kees Cook <kees@kernel.org>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 net/core/skbuff.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 44a7f8401468..ac9fed7461ba 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -584,6 +584,8 @@ struct sk_buff *napi_build_skb(void *data, unsigned int frag_size)
 }
 EXPORT_SYMBOL(napi_build_skb);
 
+static kmem_buckets *skb_data_buckets __ro_after_init;
+
 static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 {
 	if (!gfp_pfmemalloc_allowed(flags))
@@ -591,7 +593,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 	if (!obj_size)
 		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
 					     flags, node);
-	return kmalloc_node_track_caller(obj_size, flags, node);
+	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
+						    flags, node);
 }
 
 /*
@@ -632,7 +635,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(obj_size,
+	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (likely(obj))
@@ -5213,6 +5216,7 @@ void __init skb_init(void)
 						0,
 						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
+	skb_data_buckets = kmem_buckets_create("skb_data", SLAB_PANIC, 0, INT_MAX, NULL);
 	skb_extensions_init();
 }
 
-- 
2.54.0


