Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF47BCDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0406B009D; Mon, 22 Jun 2026 06:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089396B009E; Mon, 22 Jun 2026 06:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E921E6B009F; Mon, 22 Jun 2026 06:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEC746B009D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FB3C1C27D4
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:58 +0000 (UTC)
X-FDA: 84907107516.18.7871904
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 54E864000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQgzCNL6;
	spf=pass (imf17.hostedemail.com: domain of 3EQg5aggKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3EQg5aggKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122516;
	b=b3HlDdwCU3i0dXou+8FtilLje83fomjy/z5M/zIy8TzGQ8OwAE4Ke/lgz5zoNE2LdWpLFi
	359BdXWEw/gOG081hj+vxBhFc3l80igVaJiNmhvI/h657uwXFP2YkjCL58G1bQ1ADJX5h+
	HpESFRRe0gbGF56l22UVe8S/FLgivlw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQgzCNL6;
	spf=pass (imf17.hostedemail.com: domain of 3EQg5aggKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3EQg5aggKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCcnOhiuUzkCpkbV1xfgXpOTpaq02YLmqaFAcy8zthU=;
	b=fTsGsMF6EUkKsvbst6/kbZU9Vxcd8i30t/aGbfenePayR5bT3oci/Qah6MoGDl9QNx34tW
	5QjuDkeFaX4SCRrOGsGBx7s9CSP8FsOxRGvUPMVwsJdwPVtFjn38QwgqPzuLWpqDFLHy8V
	Gne7xvOTROOxvhFG2gQBoY53ENP91XA=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-69604dfdce2so3909481a12.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122515; x=1782727315; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TCcnOhiuUzkCpkbV1xfgXpOTpaq02YLmqaFAcy8zthU=;
        b=QQgzCNL6S3sv9AKdG+J71g/rtx+kwI0jz/e/2pGRbamjruz0nx0i/umlrZWmMImpUq
         mpl51s5AQD9Zx6zjM5ELrFDU0Df5H6iVj+3GFPkCbjHyDp4hhezbzwYvYEJXf7t08JIM
         ACJRQFGLwPG5VwoDC+2jQhsxv69bYJ7rHs5Wfv+ZFVVAz81S//Pj4VOZyVQGZ3wfRsaz
         TNv/i8FFlPEnsUbnbiVduBon473YrSmt1CFvASSiGOalgQHJrReMCiEQcxtIa1c7exr/
         rPcpiktMdGyqTKXDX+KcriGzB8+Cz9IFo/z9pmWyf1+oPIyEhbu2mASj2BcTbDXbYleB
         /Whw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122515; x=1782727315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TCcnOhiuUzkCpkbV1xfgXpOTpaq02YLmqaFAcy8zthU=;
        b=MjJBrSuqeTffThQyOPMnLkpYeHb90FbEE3VqxIMScLVv9iSXA+jgWv6sW4icK4LA2h
         VvUcPY3topNQSHzMDBScWSrFF6yKMC3Suo7GgL5HOHDkPSC8TE7Auvl0IP+nTpyggeex
         iFqLB1qd6IMzVFed5gWkLga9uEF7J3WGIJnIpEPdn2lIntnuQZnYKeLPFxJN7BKnzPOe
         iZj+AmLPT4cse4lk8XAbdRHLaxarK0uQyLIULy5nmhE2vkQhYOMHGHT3yIQaK+4j4F9K
         H56ZJYCZtwp/o+w3OgwNd5kaxN7/1oGBSJajDfuKdkJPOIYH0y20BpWG45s2T8TsU5jC
         YQBA==
X-Forwarded-Encrypted: i=1; AFNElJ8Bpm3ztwzOhI7vFfFkmP257pLd1S0K6O4JshxTI0ImwsC6/oHl+SQlCXyxscXYpYIdZxB1Ggr80w==@kvack.org
X-Gm-Message-State: AOJu0Yy1KfzxsCJjusvhW3aVpLDGn0asZnJscOuQ6bvqKfyDZMK4Ogtg
	dVVGFH4gvoIC2NWoknk69JPSZF1zGdhhB1kz1/8S6916DIAEfZPOKLSH8vtion6lpUhM5zlPLU2
	Rsul0gZhAtWhV9g==
X-Received: from edik3.prod.google.com ([2002:a50:cb83:0:b0:695:6267:8c69])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a51b:10b0:695:45eb:8ff4 with SMTP id 4fb4d7f45d1cf-69711e1625cmr4201100a12.25.1782122513986;
 Mon, 22 Jun 2026 03:01:53 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:36 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-9-31f31367d420@google.com>
Subject: [PATCH v2 09/13] net/funeth: Switch to higher-level allocator
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>, 
	Dimitris Michailidis <dmichail@fungible.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 54E864000F
X-Stat-Signature: 7hkjdon8ziofx9r7ui3dkmfhffijr9ot
X-HE-Tag: 1782122515-927169
X-HE-Meta: U2FsdGVkX19UfZ3X1WD1sYw5FHMM1YJ6TXOYUbkbir0QOvXkjqYgvgxKFwk+JguGLZtxXyZ2QTtWEps1iVE7jEAaLFYPSEp0QOGpD4sWmAp7i6c4DM4w6JK4iTAL9+cIRKXa09j5HuIrl8oxw0Ub2/UjEStGpbugwj7htwtQFjKw35y9Lww95MmAURQdtvOV1B2CuKaQ4b8ti1t9h6wQcsCpgp0sjDWZztNkGKk8bgQQ1KSV5kQ+OHXTEkS4yTfLOpEq3jMyN6focPBby4ABS3K2IC+eVsTVv0iHVdym8Wtn1grO/P4fpKVXajbILtz9dfovsLN3KX1X9VX/iE1vlScJejetkzWBLdqAvZk4XUS6vNrl+4hKTIdNfoRtyEppget+eGTll2ZS1By4eBwjVt4HWWOOrTmeQT3ziBaLGMnHI0VV5R1ZGCaHXY5VDEiOG9EpMnBAgiqtkT1q45Unrj42FoeRSm0Gax7t18QC9SVaVL277XMxQoTuaqrSH73oo6JArpIrKQBdqSSRZGU885cGDcgDc8WnUlFuIayj1yQhJs+UV4bPzIZxKFXE8WoBbZowSeNNCIZ4ivsogktq1QcCwqcziDXKh0oyZ1M+UJIwWVRqydfTsiWj/j0wTLt46TZGsol25VcnGguI2ErQX1kKGnEgiBW8Eiea27gLG+r++yDbfOHA17SVXmloeWdB+yAqiSGm38miDKKkjfzrJNZAP6cBVgau7e9p/UA7+GXm53eqQLiwJtP6RM2vxyDxGDik7foR8+d3i6Mj2bLFBlBBowcj/EqT3X25oEC9XpeoXvnGLKKzXBpKnBE4DwF19T1Jr/NbmtPj2mJ0Orl012XYiqfSZRuBUGDNP68O4O/A3danhACwr//EX7yt1x5fSbNClMoG1P3MisXc9FWbgLvOZ3pk2PAsFKQumKAgdDtsdVH87ZD5bQ1NBSvC5QziEkcsOiYTtJh0G6zc3Hi
 eNfjbM3N
 3BaJwa6zQ21rxLvOsBt+iO511X/WQhiXvLTn1f09Jfu3jV+vk5r7ZijloriYBaAM0Uvi5KZRBPSditcqS4drHFKWyT2WveIb3A/iA/3E1zsinFmTJ19FT72Y0voQCXU1dmZo1GRPWyEa2U/Hxd0h573VtGAH1klTZwLbCtRnjqgvwusQq5hZRDQB8mO/WUrJWC8AqR5GjI+K3VXlufxQTDJDiDeHv9So94uW4CZCeLR+GIafenRSwombDqm82oHugeJ5t7293yR//r49SzN6x5xS2DiAS0G+iEJTXe4V2D5RP+sik9nyGooLtCcj7kdUNWJZk6P5G1/MJYWdvk5Gpx6vn+aJw/tEIj08NDXa90cOK6PN8pEo0Hcu+DzH/feL7RXu6L/4351rZOqeF1cXqXdl3jOAucpahWATFeGOQgRlisEFJ3/tGHLM8oJ9MiErl7i7xjhDoekmCCjliK4rMf3eNoyXAO+H0dza6AihiD9vwezxeucNo4qd2Q3EKffybeua7X1OzhDy34IDWkOpSZIaZoJP8gC9oQBk6zk4QjJacUNg3k4jbuK+jG+ne6Kh1QaobtG7Hf7ma3DfumEfcBX+OAZ05uyhZo3QqXC2b2WAJrs/oxsGbgQWOMzy+kXd+oZqTc3P/MOYDixr/ULIysV3qvc89s3r05y2uthO84DrK3w3/hGBReeGc0UAVWSqdWx7wP/FZxPYzqU6sbSczjViQngBxC1VdgeWnpMIBUz9hYv6AU0Sij4Nre+IWqSHGV14QNxwR2kfqdihlZNlokGBx4FQsG0rI4z6tRqrUvd75+4VPPDZTP5++gxGGkaylcDrwNSz6Dt5qqPNr0SdhIUM5QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the former allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Assisted-by: Gemini:unknown-version
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/net/ethernet/fungible/funeth/funeth_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
index 7e2584895de39..d7000017ac2bd 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -103,7 +103,7 @@ static int funeth_alloc_page(struct funeth_rxq *q, struct funeth_rxbuf *rb,
 	if (cache_get(q, rb))
 		return 0;
 
-	p = __alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
+	p = alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
 	if (unlikely(!p))
 		return -ENOMEM;
 

-- 
2.54.0


