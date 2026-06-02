Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A46BCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 18:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B536B008C; Tue,  2 Jun 2026 14:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BBA6B0092; Tue,  2 Jun 2026 14:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849606B0093; Tue,  2 Jun 2026 14:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 746306B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:31:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10C19120A0A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:31:50 +0000 (UTC)
X-FDA: 84835816380.14.2834A62
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A3BAA0015
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:31:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780425108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LByzQMHWzpjqZbKGb0fLS0QtAqKmBvDgcDpwjSjyK08=;
	b=D4nqcG8WyL4embYt3y+WRGltuaIH1aFYV1kclKVfkJ50aSl8sfUO1T7jira8+09TsYAUPJ
	YLoutMyc7SABmWxURusMA7j2y0ht/xKeweT+iyhUXz3QPZ26snmH/LrZNcuXmAkiBvxio1
	95lNAnlggvCvThDSTbMMVDTPzlRyAx8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780425108;
	b=iaNjw2hxOH+wOYAWlZV2aPPbXqunzhAGejAcRFpVMSOm91Lxp4seVYoTg0BItZCFRffo7B
	c4RG5IAdcqeLGjRchlzNj5GbKHCirj9l4fYWe7u1UVuIIYTxQlFNf9Mc7pMNr/rH6hmWok
	F0CMgXZqTYZilTYTGO04vAlAGT7BgQk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2687A6AF1B;
	Tue,  2 Jun 2026 18:31:44 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D666B779A7;
	Tue,  2 Jun 2026 18:31:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4KvUMI4hH2owXQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 18:31:42 +0000
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
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH 2/2] net: skb: isolate skb data area allocations into a separate bucket
Date: Tue,  2 Jun 2026 19:31:22 +0100
Message-ID: <20260602183122.747759-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602183122.747759-1-pfalcato@suse.de>
References: <20260602183122.747759-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A3BAA0015
X-Stat-Signature: 83h1uj85rnpf93619rccn36xsmokpoze
X-HE-Tag: 1780425107-966127
X-HE-Meta: U2FsdGVkX1+L8a5+apJ7d0B/IoMmu9tHF5EUW9trAe5IMzC5a8MQjSUVpCTPk4mg41D2/bC2vaRmLLPN8GMIfWw3bh7CB+vvaYFkLrnuVaSjFwPfXDOegXPUNNhVjNEH2ksjXkjkfZ2n23QxJfUMVAavlhm4a8NKePuUOIw8TZCLzS+QMCmNlfzn/nCbZix9YWAoO48rtYeZylM6NvqlcSq2ZuV4gc+URXZ4nFI8Y9S2fZSHGs4d2CwyICGU9JWEwsGnNiFUVmYrJgKKveOgaahMCf37+WP/FmUBW7SRKifdVNzqhMuWxnd3z+NFDbweQsO0NrEVG4GXQYA7JuabBJhmR46s2N38zqfVyAzWf2MGBtskpWEtpOPO2cXdO0GlBTcndgwHxVDRJgS+wRuHPtlLY9Ny67biXOQxhW3apki9k71gfI8zWtSuIRQ3k/6UOtTK+wYDYAmsv8z4hcG++G+yeYRaoiMDNVb6TTBFzTdBQI/s+TWU3Q/hOXbDD/hvXTFSHy9zd0GoFgNV+f4lBMQaygW3hW5YMmpZpKqzFsaovjCfyHqstaj5DbWHr8WtuYedYLsMVebz3ffdFX8YAsWathf9CxhGyauK7V8BMhVemUqUqV2npIHgjYVpPky6VWt0qoXOG81MMi6xRTJgosmoSLx8p/n8wQlwjVgHXRhpKRFCF/JojhdcPTk7MiuB4kllzPJvsIVqBJloRqT/JiDG/XFU1946ge62MTuexkwAL5Rh3r/wNDU0VGDUVquFMtqxiFeQDuETNTYdX+rAnbK6j6J52zFN9AouFVBAqBG69tybScGuiy0bqxUzQotvzK3kk++1mWG43uxHcRMIeIcndY7xiP96KlNwhce7NUG6JllRlH8DXxsBlHLXFbQdgs1C4MAAs8YzT03ySWHUPYQjypKcVhkaQT6sBqSx8KKKQ9iof+0DODHPhek9eysT2YJUgrCz0JA253wDlyB
 DLX2cgLe
 oHWUq0dizqX7R+KErVkU2Pt/IAclLm6F/WnKmh/nGvTV5H+oN8BgdS0vRFYgxlNgewNcUZK3DDlTpxFm04ive6/8u2JYdGwDt/fOOs+duFjsGFIJqJqQd/f7SfD8MEur09t7s/iZEQLVpXwRni7SXqqz3x2s8StmZrOVLLXhw+pL8rv5g3vv1qiii2g==
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
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 net/core/skbuff.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 44a7f8401468..1f6c6b531ece 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -594,6 +594,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 	return kmalloc_node_track_caller(obj_size, flags, node);
 }
 
+static kmem_buckets *skb_data_buckets __ro_after_init;
+
 /*
  * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tells
  * the caller if emergency pfmemalloc reserves are being used. If it is and
@@ -632,7 +634,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(obj_size,
+	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (likely(obj))
@@ -5213,6 +5215,7 @@ void __init skb_init(void)
 						0,
 						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
+	skb_data_buckets = kmem_buckets_create("skb_data", SLAB_PANIC, 0, INT_MAX, NULL);
 	skb_extensions_init();
 }
 
-- 
2.54.0


