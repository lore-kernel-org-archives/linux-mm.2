Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580C3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADDF6B00F6; Mon, 29 Jun 2026 09:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11496B00F7; Mon, 29 Jun 2026 09:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62A46B00F8; Mon, 29 Jun 2026 09:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71C6D6B00F6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2D181C6D46
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:34 +0000 (UTC)
X-FDA: 84932989428.01.8AF5CEB
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D121C0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l+Cpghoy;
	spf=pass (imf28.hostedemail.com: domain of 3P29CaggKCIAnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3P29CaggKCIAnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738753;
	b=r12ibJTuTRBzYd0VRDeree5Lcuyi7PDfxVvkmBM57J1wiUr6EJpjjPw6ToDOacyNeFzA74
	dUZAjm9khfcLydbvD3AU5jdHMkEs2NXvrUaIw1ceEZ4HhuoKKdC0zd6WCA3K+8PQDGODJa
	x7JP8t5WmOgQmc0+gfql/mqXYe6jMsw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ugcG2ITTUxGvxQmxOqdEbKCPZm3gjUsTH8fz5PvZZs=;
	b=p4yhv55osbVIyCy+jLL3XA78/6+oaAaU4bSlAvoLWdnH3w/VeePG6Ubt/iIifqTlimrpwP
	BXRoGcTITWxufltG5Xqiej2+1DUajQTzEtbsgwJ+N3DfGJjg7KRSV4ir8U1YCojc+7kpTq
	2e/0+gEihU6fg2/AEx7Wo6Tl8sh6PCk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l+Cpghoy;
	spf=pass (imf28.hostedemail.com: domain of 3P29CaggKCIAnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3P29CaggKCIAnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-492488f8583so35359745e9.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738752; x=1783343552; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ugcG2ITTUxGvxQmxOqdEbKCPZm3gjUsTH8fz5PvZZs=;
        b=l+CpghoyPhKIXWLINlqOe+wKUt+hTEKioTFOkYnCuB7hHZv5sF39iYr5mddcnMkl8l
         V/ILJUxdiX0wVKeoQY1rOi+toG4IiULbh3wBmKFMk1RkCCkAKnOm/kQ0fsPLhm6BbnFQ
         +yCEj1xzrIq1Tse3/tp1Buv2yIMiMCrOxvusTGYpQ/O2QsaeWWytk3p09glagytBH2y6
         HjQvSvrOUWYtR70pGGoIouNEvrYsVQsR5aSp78upii45/nMrwGUbTxoMNuoGiYw08R5C
         qSyyQik9yPCfoN2XmRmJHtiB4Gv7+8ZPEj8/7Ts8hIsmYVOJoJ7QP5v+Pdr/PpD68d+8
         MBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738752; x=1783343552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ugcG2ITTUxGvxQmxOqdEbKCPZm3gjUsTH8fz5PvZZs=;
        b=H+cIEd9lfSIS0/WCpn47mb+FGsW5C3r6/Kg8WeMdNJWzG5uJr+rTMd76vouDbw82z+
         8fmDNKcE0JILPEgh/rXEscroPZEMQib7BrTNsokPv+rBZN6EP2WA5uNCV7MxbU/Nzp5D
         EkzIZdSjBfps5w1qmvCfLSUuJGHt1vOTNh4OhBzEROmFWhWu3+PYXWv1VorN1iqp7F6R
         2/0GT6U6fknxrN723HW5NRQJxSmeOrhUDsejDqP0TKVKh5+/3wBsXlRZ9Vuv/sbLKqHw
         QPtbs1K/bIiRnjERp7U2eSGDxNCBiAv0Q78BqbcMAm0gnNVskSw66HwOOwROEBRSf8fy
         fHKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9CLR4NtmFOoMBCVBNIp01joxo37Hfp9TrDwV8xZMPJBHEF5rumTxN/uj5Vq159pgbyxJZEkdVOSA==@kvack.org
X-Gm-Message-State: AOJu0YxU02hssl5HF02VTWBdlyERDSm87Zp2LVV3847+sbTQXx2hJ09Q
	qzkv0yMT7QvbI6XkWKaLW3bMi6NYqKxsQwqJBCMdjlFfUSJpapGn7qCBfWONmTP+uydIAb/gIOb
	JecVICyaiWxDAOQ==
X-Received: from wmby23.prod.google.com ([2002:a05:600c:c057:b0:493:b4ee:171])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8454:b0:490:33b3:4be0 with SMTP id 5b1f17b1804b1-493b71d1679mr10649785e9.20.1782738751401;
 Mon, 29 Jun 2026 06:12:31 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:12:01 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-12-57bef0eadbc2@google.com>
Subject: [PATCH v3 12/16] net/funeth: Switch to higher-level allocator API
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
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>, Dimitris Michailidis <dmichail@fungible.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: qh1yw1yegknpg945h685absicewx4py7
X-Rspamd-Queue-Id: 3D121C0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782738753-800646
X-HE-Meta: U2FsdGVkX18W/S6oUsyLWuNg327nqFkJjeDs0gWZP6E8PYSKp2/cLR9v7GaWKbbYPR37F2EQYOi/m/tURsccerVPrOtQql7k6Q+6iLww0YZUriDGDlX+C2vRqdIF/Z8NdME4tPiyOxCkXooi8PzloC8ffh+cJpXp2PtfPwO2F28FNUSe0s/vhSMJCxmPJe3cx/cngW9zbcehhniClLP82yQyUH2/7+geMd1zIDxVayCxx3eW2GydY6SEEnZn0cGMq2/0902Sz0lyvG2qge2QB+czqdC3+3ZdWHS/zLn+AgWsXxPHrpCpbZfVGxpBvfjCn3pZ3zdPwfCILODOcCvCheQWlp0j29MlQGT7pcbkqI5GpKjAXlw57g7x0DNTlEigRyQt44LZ1ohghTBCkZ15HIj6rrhAuEh1I6AkJrdEP/Jug4WIYvfggEHv/BYbhKwCgct3YbtjFFHxomv7zm30sO8U6TzCEdMGaWdqXmyF6nB7SKbipuVAh3jaH8726tfu/LhYlbsFQ/c2ANOWWzSxIMlU+dgRZhsvrFVHa0DU+EirdemNVvrwiF6gqU4zKI7faURSf4u+LtAnJkEEoE+U0/r3kLPpP93IZ53aLkCxBmAXKwuSmJhyzIR11OzbM4gGopRFL66LyHuMrjPtv2TkPzFGXi9acT70QchPX+u5C64Eo1GQkRVc1pp1fI/orxfNbLLsSFVb7ugk5fX5dnmM7B/WJvqcxx8QrMz2QRHWzs+u12E3gkbnfCgK5JOTknG5V0WcvF6whaRkyKReqLsIvMUXqabi4DcBLgmFxD7LrV5CEAmPoh4BcqmaI/UknkUtw+a/lIVOQDHmctcZ3RjzKoghMhbLW8uUAW9eTG59Mo5QIov9PHdjw5G7caed4VK0lfU5lxXh87c4FfK3ydDU3LYDxQTPL7w6Vz5yuhOpr+pyv3a+8A4jsvznx6org0a8D0boL2EWJ8++Hio8YCf
 gvuwjySt
 6hLYItKPkh5QBY/l67ETlx+s0NjhQ7CrHYjedrllAc0XTi2PMTwv0/ACuQmNT0dCjHHWRLyTza1h78FdRpm5AA9+soAqDGs49k+gVGaAC7vpY6a1X6aBQ5j7Y1GVVuxOtKX6nJdb0GZLYRD6pKukXKXP80RySGFzQ56fGnLLBaEh3v5CCyj0kv/mgMzRRtEMuFJtJsHw1xLx6h4hSRHis8SmtEfZi87GXI+34EXetwNj3581RlqL7Pn/hVTX6slQnTwP0dS7O6lIB7GJHrR70U2XFaM2sFwLXnulJ9Na4J77pn+NxzPNNZ/O83wgD4DHbPnysWDKB0IDc/Hjg0NGSgUPY97FSbsYaKIlEtOFxK2W4eSTAGddT7XeQMjjAlhNewmVQ7OoDw/4oAuBlxSaqZWlZzqjxOyCJ3d8nKQkeqH9LLmHvINsx2sLDOjqKgxcytcWyewL0I8cCNkZlYm84Sc9AyyYUi5DvuqdiivgKl8KIr1iuB8f8qcbWe0Bj6Yd+JhXrUsCI7hqpImJ+SWxxq89b+Y3ABA7zIuHSTlX59Hzhcuneetzvk070wmzpQxH7LH3gWYns1yWJWlFVu+Op7ZxgVAMPbryG/zZA0KTZeVxJ4PfL4NzSW9SKxm8QhFSSmpJcnfrfmOuYXQrwGrAuZpac0kh9hrD/clofYpPCmXXyV3n48lLoYQCrfvPg5+wpDm1TLPdzChgJkbLgWJ/OHyFqpeidTY7IHYtxFcdbZGOGeztPx7ptkVUikwRrkxAO+NW5l1+mU4Bz1c19aOrmwWsoUAllkbBBGojML6zcHBSPfiWByQUteMMFB8dvCRT6+SpE9sfYb/8/2JVBFK7J95vzXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Assisted-by: Gemini:unknown-version
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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


