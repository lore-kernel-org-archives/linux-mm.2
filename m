Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD07CAC58E
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10D08E0001; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1538E0002; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6E98E0001; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5ECB8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 579231A078C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:11 +0000 (UTC)
X-FDA: 83872595142.12.83B9C43
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id D29D7C0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k6P7YCNl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7L+CBN32;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d/9eUt6t";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0VKnQ2OG;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAwVYE4NG8inGvdEGs4C6XcT1t0ZcCQnS4gQbGvqQfk=;
	b=NOnoUjakfTiv1YUzUPQmO/TQUuUOy4m66dCqmeKRTXyQbmub0C7mnPcpPNW/HJcAyogcmM
	M4TJ3VQUVW2TljJ9kcwbth3M7GKm0dYDI7nKowAPU9METBnbvSg2DUAd63RvycQTtIN46n
	zB79ch15XccTfpYgY0vmi51ptgBC9hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491269; a=rsa-sha256;
	cv=none;
	b=R83viGbhx55/7Hx/MOhEAXib1AdM+1eD+F+8MNZSuWmVpDRS0PQtQn3JNV5GZnGxBRlqmi
	6ybTyMDF/wWXi+R2N23i5HlsYaXTnGEbryklx+Y2+xvv7Hk+0MBHVlhusbPy/nzzNGM+Hy
	nj2lW3RtHGywtksJE8CnN1BT/Ix5u/A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k6P7YCNl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7L+CBN32;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d/9eUt6t";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0VKnQ2OG;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DFB2F34BFD;
	Wed, 10 Sep 2025 08:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAwVYE4NG8inGvdEGs4C6XcT1t0ZcCQnS4gQbGvqQfk=;
	b=k6P7YCNldxNO9tGL0KHyGYqkJ0vwzAF74+VcWsT3RFofiTxwZzTBUpAkMGmtH1z4FctPnL
	vyUnai1vRS3PQwiZZg1y1WilRUassffb0dcKtMSnBXDt+Ie1WXqSohGfryHOvuZvmx1jJS
	TThTk+kLrxzKfdAfA3W48Q3KaExlp8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAwVYE4NG8inGvdEGs4C6XcT1t0ZcCQnS4gQbGvqQfk=;
	b=7L+CBN32sCDv4omTTYmqZmhK1iT/Qog6f/sov3U64S3HvAVSsNP5tKfiYxW0d1fhUXBdok
	StqLHqGqzZHZIIBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAwVYE4NG8inGvdEGs4C6XcT1t0ZcCQnS4gQbGvqQfk=;
	b=d/9eUt6t0sNGla2HbrdNRg8+vqxixCr1e+tbj5lyL1L/HBY+icNr3yQjVJW61hmZTA1NdR
	8KdTKaEeCBg9Q+5i04Qh5HPwpNOK5CZIquEFgPwQq0E9j47eMeSxwYfZDwX3EiMHLmQHeL
	4BBofwFAR3xV6JN4QLCfeZRTL/FDdYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAwVYE4NG8inGvdEGs4C6XcT1t0ZcCQnS4gQbGvqQfk=;
	b=0VKnQ2OGFAbX/IBUZB2pe+bZpGugEIX1G2uBwV5cQtkrlSQuvQdyxK/ofC19sjQ8Wyn2+X
	kb30+uZYO/GxtEBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C9DC413ABD;
	Wed, 10 Sep 2025 08:01:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id INX8MEEwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:05 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:04 +0200
Subject: [PATCH v8 02/23] slab: simplify init_kmem_cache_nodes() error
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-2-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D29D7C0005
X-Stat-Signature: fmxp4shpfsbdr1eatu3ouxwq1pzhrp81
X-Rspam-User: 
X-HE-Tag: 1757491268-155447
X-HE-Meta: U2FsdGVkX1/OKuUBxekprDHKFBDaqGEz5pPpW8c5IBR5AK+KihRXlCGINZ6+sLbJoFzHlxqZWChXSiMiZsMSTBv+yxR20ou5vzvmHFmWWCTyWao5WROJGjgPK4szxup/j8UvuLzVEGYr5Rtd3pNOEX07NxYxP1a4j113y1i0TfvkR04vn0oHD0NkYKih+u6FEmhssnP4u9eiaM1fx87Rg5PWSDQMXJFVWX29VEmJezzkNT+3S9etund/Z0rfpBRtdiddSjGsMKAFcxa+J5g6Ot2+ly2NvJLAvUPmXpukO0jEwUYAyfybe58/fr+IOCkIxJizI3GIJkD72ydzHiRxE58lBIDYIrA4qVwZ9TiLyI+/AsiIHTHrrY7FpZwh2y8Cp2sovXT/zRrqxslFTTWY3sOyvJjVxVmZsl/hYdZxX3FCO6DbJ5LDy99LYllBEFG+QjLfxaiQK+Fg7w6Qt03LcacPhsgcrp3EXyogWBAQGIU0K8sxpYIhJkNT0KoxWZ4V4+GNaebq7BcjObUIrJKdARYXoykEZ3I+WQlbMdFA46Z+bfqn5pJtlXPwPvsbzmnL8M1TfQINTdRKYKgtgw2j+hMpUwQmv4fPp/lEYOGI01bOfmrFk3vChX7BY/LGaovljqlCWcEi1pnuOEZpuqU02t+y7nd+sYZmxDEnO7RpH64NpmSGyzUYqZyd8auu7AGAbv+7E9eW1dEvGa/eXdFjFBlY+/VROncNl5XaNpANW7FD380zJc3AjIzpyspOPp0LtrLGYJY+/i/KeIRTKEiSdHVQiZ9OA0ZIrzruT/WWeGLmn0LpAaj00iyxcPiymZ/TGvHC6z02x2sBiGoAnw7U3rMQGiH6WnaZyaJw5EWtedhnY0KqKSKQ3KAWZ0WcqsNIqQToj3hcMNFj+nmAumxXVrGbM4t/ot1KIp2Ki4Aar5eO7CS5ACgL2buMxgmdsTpw10sxhJWGR3j3NokRr6j
 zaxtsjYK
 nfZ2g6N0HO4ielgiliuzKXQIV+xPzuKIWysl7DODX7h6vmmVVitbLDomWRy+WGNCQNGdAIwYIC5XgGC2rtS6bmsQiMDREown+2HGXcZUWB5ai513UM0MhMzwtGmGTP+h07XmO25YDF6sWTMH9jTegOzTugOO5Y5RkO12gOC4GpA031GDm8Pm8FCGDVvb4WQAa5q7n4KRgrP5qh7v93mfMToWclYlAsTz1aNwH0/17nUc+Q9P1GGPfnKPE4QXxd1vK2aUqZ/Rv6X02hkT10y2qB7SS6++S1RfxJ6iSVlQTsI4pf0PhZXu0ySpWnFnvV25gh0hJXHsmvm/t9C16vKPcOR1XsfDZAcIvzwsl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need to call free_kmem_cache_nodes() immediately when failing
to allocate a kmem_cache_node, because when we return 0,
do_kmem_cache_create() calls __kmem_cache_release() which also performs
free_kmem_cache_nodes().

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224c2704a4b93082b8b47af12dcffc5..9f671ec76131c4b0b28d5d568aa45842b5efb6d4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5669,10 +5669,8 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 		n = kmem_cache_alloc_node(kmem_cache_node,
 						GFP_KERNEL, node);
 
-		if (!n) {
-			free_kmem_cache_nodes(s);
+		if (!n)
 			return 0;
-		}
 
 		init_kmem_cache_node(n);
 		s->node[node] = n;

-- 
2.51.0


