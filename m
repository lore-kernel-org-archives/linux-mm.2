Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6AB9C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939606B009E; Mon, 21 Sep 2026 09:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874226B00C9; Mon, 21 Sep 2026 09:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1A46B00D7; Mon, 21 Sep 2026 09:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54CAD6B009E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:17:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D11B2A0192
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:57 +0000 (UTC)
X-FDA: 85237822194.21.F29ED24
Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	by imf19.hostedemail.com (Postfix) with ESMTP id DDF131A0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X/SjqYcJ";
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789996676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/tIGTo30mKJ21qg/bGL99r2Mo2ceFoUD8zlOI6ZWwg=;
	b=eF/nAa+l21j/vCO06Jfwv4lZZh4cO7Y0+XupTy+HCyn5Fbxys2otXn004u0yinp4MnwYtY
	b3E9gknb7DTl+6sHrjAnkFr6mdIGV3h/8h/6WQbGU35vafT5BOrqTIaop82pLuTimlRwpL
	Tmwszed9ZAmY/tUGSZeB4x3+DtO8lCs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X/SjqYcJ";
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789996676;
	b=uYWyVJkcFH4iZl/yFWx2B5V8AW8Ve/dYcb5Pf927K/6W92wvBMZKyu3IRhuVxjGOPF19Og
	SUMmuhHZYkZcqi3dmh1VpLKQxvuW8o5cqBQuWeY/XDSY9vokuOZ28zl3iKX+Zy+jKvsiNB
	lC2BwENTeD4i0WTI9xp1XnUBQvperKk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ueVOpPzYnMeot+dswpS82YrnsBHSSPYd5K+PQjCvvaY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789996674; v=1; x=1790601474;
 b=X/SjqYcJokzG5Jzyk6IVWxAXA+B4Xm2zy1fhXRgjy9ZEfXBQNe028meEjtHeHVkI9ZGDZo0U
 vBCYfFcQl7QxHlYUPwMhSmzQ9JxpQNVX7LiAOzX4bRqgCdd6x7u/k1nBG4zy91iUNa8YHVRUDCW
 AjTsvty9tppeRrskQ66c1STU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f48b4f0c2c5289ef;
	Mon, 21 Sep 2026 13:17:54 +0000
X-Mizu-Trace-ID: f48b4f0c2c5289ef
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 21 Sep 2026 21:17:22 +0800
Subject: [PATCH v2 2/3] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA
 lookup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-vmalloc_dump_obj-v2-2-73fceb3ed1c8@linux.dev>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
In-Reply-To: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: b7hfq1whesh6zzbghycmfkwfsqxgnmyh
X-Rspamd-Queue-Id: DDF131A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789996675-28469
X-HE-Meta: U2FsdGVkX1959+g6e6TTrMEDFNJbvhudptJtRgT75ZtPTLjRuuQaia30T/RETUhlPC70IMI1hQVYxCBTVJ91lN+033n/mmHJiMxYU1lozobx28hE4Z985o4ZYO3nu+6292XIBFf2YuA7MM33a3/Nx3sLpF4FcuCZtBzWoRDPMsDRoeKX2J/sia1arsDb3mQgXc7Qcqsc/A6bfGoXvGZWs0/hqGimvnJMvYLNtVJxqEYUR584rTrpp4LC3wj5jfV9H00w3OlaCHAa5qd2m9WXet3UJjlACzE2ZhszXdP5UH0A7uWeToecIuCD47u7f86yzcUx8dBmBlhFYxJOZO6htZnZdVIBylZPP42GtKslivmaJWp//kk8DMeOtqg5s8iidrF/EE1X/MTS92hXDc7TmUqQwQAhlslOXj1xHsKWCnwTp5q5Cj93mVJN36/g7lxgFex2wZLa/2B8myx0Amq/97kW/HiOpbUVQGkzUK0seWqMIb5v3CbDweQfXqJGEE6rK9KE2MTkDkMoA88Vgu79pszCmHPUo1qWQQc0yKOyX0RB0eJHGzSmFvXle12hO+Y1u4KX0SCZHJJtze1PWyy8va97pcheroRHnwcHzqLs/j/9ZKx98OTxgYNKlYyH+o7BHcmyyAHgBFG0YL+zZ03ET1BpLy4RJfvn2q5PuyoAasuYio6oobXRthT9TmQRCloVcs6QELsBiTVy0igFYGbV0GLPRGYKcqVX0r7WFTMX7D/ePCrKkNfy57RvCdpTa/jU3esFlk2NH9Clij5C/l3XMRs3Y6SxRmVGR9xbaBTBc8gOosqZur5jOCfD7S7/3NeJggAVShpJuWRS4AkWISlOavWYoCunhqFeVuSnpFB9PAFE0mkEOOgXpakfQJwXkcTy6dpFD2OhO7NeeQa4MkFpMhtClynaUZlnNJSsN4BHq19CDZN3LZ0tSPZQPFZ05u7fUMm53F4ZxcVScG2WCF6
 RkgVbqd2
 1QxB6T0oftmSPd3uJ5G9ZfzV0ONZnX2rgw4pmWjNYAmr/FL24Lt3/LrYBw9xjzksIiN8fZaI0CvKbMIEeMqy5r926H2dXmbtmOhW9F7L+GJa4o9jZ/IeoX4GIPwD36qs0A/QZ4gi9hivdMVSp0AUqNZ9c3EkAw7hqNEXkH3b5t+KlmmFnQJYbVs0hdT9dgRXBhPFvjnRjVrJARGt08udQgO5lgdepZKo3Ldg8KxkEVxfazeUIoPpJ8BUHfcoRSGxmEe4dl1io99oEXc5rjITfTtyPfmyY4GJjqnAz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() searches only one vmap node (addr_to_node(addr)),
but a vmalloc allocation may span multiple vmap zones.  The VA is
stored in only one node's rb-tree (addr_to_node(va_start)), so an
object pointer in a different zone than va_start maps to a different
node and the search misses.  This affects any allocation larger than
vmap_zone_size (64 KiB) on multi-CPU systems.

Iterate all vmap nodes using for_each_vmap_node, like find_vmap_area()
does, but with spin_trylock instead of spin_lock as this function can
be called from atomic dump contexts (OOM, KASAN, RCU).

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index df42d8a6f058..30c610f678dc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5278,17 +5278,29 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long nr_pages;
 
 	addr = PAGE_ALIGN_DOWN((unsigned long) object);
-	vn = addr_to_node(addr);
 
-	if (!spin_trylock(&vn->busy.lock))
-		return false;
+	/*
+	 * A vmalloc allocation may span multiple vmap zones, so the
+	 * node whose rb-tree holds the VA may differ from the node
+	 * the address maps to.  Search all nodes.  Use trylock as
+	 * this function can be called from atomic dump contexts.
+	 */
+	va = NULL;
+	for_each_vmap_node(vn) {
+		if (!spin_trylock(&vn->busy.lock))
+			continue;
+
+		va = __find_vmap_area(addr, &vn->busy.root);
+		if (va && va->vm)
+			break;
 
-	va = __find_vmap_area(addr, &vn->busy.root);
-	if (!va || !va->vm) {
 		spin_unlock(&vn->busy.lock);
-		return false;
+		va = NULL;
 	}
 
+	if (!va)
+		return false;
+
 	vm = va->vm;
 	addr = (unsigned long) vm->addr;
 	caller = vm->caller;

-- 
2.25.1


