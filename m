Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF53DCD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 03:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1046B008C; Sun, 24 May 2026 23:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04AE06B0093; Sun, 24 May 2026 23:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2D46B0095; Sun, 24 May 2026 23:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2E176B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 23:23:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6536540121
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:23:15 +0000 (UTC)
X-FDA: 84804496350.29.4CA9B56
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 97639160006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:23:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rUMQfxxC;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779679394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oowUe/5TJUbyngfeGH7m6ljYwCauEoDHldpXCalFn1M=;
	b=hlZ3gd8+vP1tDcJjHVzKbb6JOfbl9ZYaiaL4icRIv4ZhJviddXyoZGaqCKKtuBKoPdGkc/
	UAUo4QK+AYFXVyz7bMQeOLmx74xDgixTVhXI1r8sjyrvb3CuOV2SJE5O7fW+yyQCva8TCK
	U0soBoc2EzeBW7cdM47xD8uS0UqzrbE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rUMQfxxC;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779679394; a=rsa-sha256;
	cv=none;
	b=Ax+L90HI+YdS1wOHd8PvWEoNndMe/2K+hqh2VmikAfnl90F3krd89QALZ0ebHrEqFHjG/K
	5fpq54n+loM+4SsA+KQgMQz74Zcpdw2+eCNx2Y8yZWy+Zu7DEz76FfgJhp37mlaZ3J7Ut9
	PkL17JiyNt8eKp1lZX++wt9CzviRtC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779679391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oowUe/5TJUbyngfeGH7m6ljYwCauEoDHldpXCalFn1M=;
	b=rUMQfxxCsJGkN9LPb7hW9/kqAT9WysixDLbH9wBFKq4J9cHfT4gllSv+fzggu3vvWYnAW4
	ayoomg0m/J8gQHUqIWr1s/6e6qMCFgCfrRWrBx9JGy5YCGfQu9Hm8TXldl4TN6vANUtpgo
	WZmQjpKuW8h4G6/DdNGg+LTt2Fxwfhc=
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
Subject: [PATCH] mm/slub: batch-detach node partial slabs
Date: Mon, 25 May 2026 11:22:09 +0800
Message-ID: <20260525032233.10847-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dduae7kthfw9rtyxg15stnjbxr3ib8x4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97639160006
X-HE-Tag: 1779679393-218117
X-HE-Meta: U2FsdGVkX19DS4yqvssrLnE+UiT0x0HRsQgezizmeBcuXbjBIzGczNtoRd+D7q73DlM7ZTzyLfnasHQcCKlxyQKSo8rJe0rn/5cCQZbbimrbpsUp4MPM+Ws6AxV55hDwoMOs+e4saMQ8YaTc9yPSr4yO3B6HAhnrBzdB7zYH8qcPjcOFFZ/HECAL6JslePDPYBUXO/E7d2cZWYRNoDHf292zwZylrf9ojoW5pbS1iPv4xKaJ7eksVezOHUhnMm0uZMEOySWCJijEWCE1S1Yi3WEx6xwGiVl6ecUHRsov91d6YB6vlCtVp52QRemvKfadqpSKfPa7af3747OaZH+H6QA8MReqlBrQBwFsfqXDX/ZXR7Gyc+z0P+IFhqMVWMn3vS/Di3CXyngNHstvWz21uy+GaIda0vAVG9M16CVd5jo3w9sMFrAdl4JRe/2ZUTQKF6AquPzBBEX3IVWGpiJFUe2+3MjhAkSiAFNk/PPmYgPPWmIh4D1mgSXjwaRHCn+Go8mIoa+uGsqAbvwUkx+giZFbNZeyI2XcWHFEbDoydyc0lBGbC38lM9GCliKWeF0IOR1rkSeNOcUwMyWnNu2tQPqAviaHQxV45WiCKfv+IAAe8obqIsa7RftKyKXb9MlRdz1HjHybT9a728P3UBc5d74EOX2xGNWvrj2+0bdJE7KxJgs+rRGv091C4Hgs1Z5vouh0k0Xq71ATGaq1gNmGpik/VS5GgLsLBG7AxVKhKS2/zZyY8SZr4M7TCnk1qAj8zmNdP1/uvzL6zRdHei0WtfeQe/ePH3VM7M7S5LtYmoZbAS8j4lUc+WXJUenOqBgO+GzhLF2zjXpD54gAS9uAGFZyZ1pKAH+rVLw58XJ7lltnFkCHif/3jWcGqNVQRZCX/ig94OmmJYXhncxEwAXjWCuRGl3BmX6MWSOSpA9b1PIn0edjccU7qay7AEKffc+BywFZkyO7CXYGDR5OKHd
 NTOuzGfs
 QxEIxezoZpNMG3nzH11vH8vRS9WzAsojJKgbwK6A+hsPanG9wClZO3VMyrnmpGtfGVf2tE4mr+aV8atO2K4OnFy9u3/D+cWlV0uRrb7O6odOKjt96KRbxl18QLJ8WmiJ9Z6hJ6Xd1SL2apVVfPEPvJ2q2d6AFDGfR8Sn3osNRV0X4cBeq443QFoIMSuR6r3rGKznh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_partial_node_bulk() used to move each selected slab from the node
partial list to the local pc->slabs list using a remove_partial() and
list_add() pair. In practice, the loop often detaches several adjacent
slabs, so this repeatedly manipulates list pointers while holding
n->list_lock, which causes unnecessary churn.

Instead, track contiguous runs of matching slabs and move each run with
list_bulk_move_tail() in one operation. This reduces list pointer churn
inside the lock critical section.

The mmap2 testcase shows a 5% improvement after applying this patch.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 04692a6f9128..180973a4a3d2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3739,6 +3739,7 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 				  bool allow_spin)
 {
 	struct slab *slab, *slab2;
+	struct slab *first = NULL, *last = NULL;
 	unsigned int total_free = 0;
 	unsigned long flags;
 
@@ -3757,8 +3758,15 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 		struct freelist_counters flc;
 		unsigned int slab_free;
 
-		if (!pfmemalloc_match(slab, pc->flags))
+		if (!pfmemalloc_match(slab, pc->flags)) {
+			if (first) {
+				list_bulk_move_tail(&pc->slabs,
+						    &first->slab_list,
+						    &last->slab_list);
+				first = NULL;
+			}
 			continue;
+		}
 
 		/*
 		 * determine the number of free objects in the slab racily
@@ -3775,15 +3783,21 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 		    && total_free + slab_free > pc->max_objects)
 			break;
 
-		remove_partial(n, slab);
-
-		list_add(&slab->slab_list, &pc->slabs);
+		if (!first)
+			first = slab;
+		last = slab;
+		slab_clear_node_partial(slab);
+		n->nr_partial--;
 
 		total_free += slab_free;
 		if (total_free >= pc->max_objects)
 			break;
 	}
 
+	if (first)
+		list_bulk_move_tail(&pc->slabs, &first->slab_list,
+				    &last->slab_list);
+
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return total_free > 0;
 }
-- 
2.54.0


