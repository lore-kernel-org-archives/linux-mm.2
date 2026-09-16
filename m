Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D18AC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2286B0096; Wed, 16 Sep 2026 04:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859546B0098; Wed, 16 Sep 2026 04:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F946B0099; Wed, 16 Sep 2026 04:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50E786B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:25:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C1771C2BD1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:50 +0000 (UTC)
X-FDA: 85218942060.07.08FE729
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	by imf03.hostedemail.com (Postfix) with ESMTP id 37A1120002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aSPynQyf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aSPynQyf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547148;
	b=B42JH2bXgKrJd4D4Mf+DwDTlbEllKd/95lg7aWp4judYQhPH508dz43VymuVqrKjZOCxds
	hjN470Sn5TaRbajTzoAtsJrZd39V6xED+7CXQgLsA2HVPM1rZ9EI2fz41ti+4CjWDCS+93
	GL0Cla80iCrctyI/ZZTIS6z+noY6Lm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/tIGTo30mKJ21qg/bGL99r2Mo2ceFoUD8zlOI6ZWwg=;
	b=fP1Bof/3O9Ad0Ys67FAPjM2K0bX66hOmmcbUmn5jf7/xRo7iwojNOoXBms3hqvK2aAjwSr
	/XK8heP3HFLzcs/zz7WDDXWiecogubZXm4XmuwP/j50S0Ts3L7/YxIvy51cuXsggC1AL7v
	wWsWE0eY7Z4SLSndQ+v8aOKEpfw+tnY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ueVOpPzYnMeot+dswpS82YrnsBHSSPYd5K+PQjCvvaY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789547146; v=1; x=1790151946;
 b=aSPynQyfMUG2H9BmxVXCV4FnK6axdeQJwoaBm0dwzKfO5QY+E49jQV+0EnTxpxrPDhrYdChl
 l0flyyXv0lDnJ0Lb6Y573bBson+hYvzYHGZKFs+P5xcC28Cd2KoMVjbi5tbFNrJD/ZwhywwEMBm
 Ytw8pMerXVjeRW4SFzAIFjF8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3414f8a749aa3b67;
	Wed, 16 Sep 2026 08:25:46 +0000
X-Mizu-Trace-ID: 3414f8a749aa3b67
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Wed, 16 Sep 2026 16:25:29 +0800
Subject: [PATCH 2/3] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-vmalloc_dump_obj-v1-2-7aa402d224df@linux.dev>
References: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
In-Reply-To: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 37A1120002
X-Stat-Signature: xefxbwiu39hw8hhr7kri1qk6ax8y3fot
X-Rspamd-Server: rspam01
X-HE-Tag: 1789547148-298860
X-HE-Meta: U2FsdGVkX1+1Zg3HPUfIKaWCvHKFVnj7ermbcHrtzMOXPxvqEsdeszYOnbnkqEw/TjzTeU6DTOpPVZPvyxQz5l7vB5yaVAKxr1Z1fHeZHr+rIvRamnRHgpRZcLn++EYAG/5I62fmEbFPBkqnqIkdS2hkZs4+Bly8L5B8JLOC/XomlUbd/hIiBepvh5NFOcYOtgVH/BImkwQUOyZ+a52X/XAgJOHy7tJBfr7IPcalh3yRdYuQcg/3Kv3zMVg0R6WGqsxrbGtDb6fyiblxzbNA3FUgDzrpTwQn1OZKJZYX3CksLkABcRCr1idWhE0qCKaoX9gDyZ310XobQ3AE3bke8YxvYmW9VVj9k8YXQ6QNjDp9y5l7m0coDZioUOADfgnBNykBl8ee2EfFORp9gp5k12kE6+4KE1BWOU5INjSYogiLyX+fy1uG92QLykb4kpw5HjgBtsXqCbkG/GbOhrnGpdiwFZgtLI1wnRgzr8rK3BtRYdEVoD1x1hsqL9UjPCsmXsE2biHwSdbxcECczfOCA9CQjlYwj/SpL+Se5BfC2Mqvaa78hxtW4Addc2pa3+MHW30swpexnY6Ur820JA2aoEb0SAqbvTELDZ1XVOjK/iviLmsXUMR4zuQH/Egoekpao7Ws0CmPBmW2LFmCq5ZAE67MhF42b3TBkPWLX35uE4s2Tzqiq/Jm80384DEcwpzb/qPst+0ITBbchvUiwJX+rR6m0izMmEnrZzj+YT0CmNMNfu+lBKnTD4JbN0HX2u9yv3PwMxIJPtLHqsQeo5ZcF75pLstdxxHKM4LFTWVCQ6uvNqBiujJHfVw9EKIvCRQ6NhcWmKtim7PYb+AyhwHZ4CDHD2dZrVW8DCF+0uVHqYySrO93fTHPyc1DYVCNaOkbo/GE/BPdnk10hLr73GHycx5L35mIS/XytS7q/KLrxlxIadZZzyfNTSAkXMU52aSVWh7+oN99HmA+JxWN2W3
 xLyW8RCl
 J67tcuA9+BgFjcWecwLeovhKNr6fSc2VLT2ZTlqhhwOlAuicl3VpMCu46CWv8OPzvQ7xVTuNoo2pbUfBoFHnG4UAvve3xlrcnyO3nzinUt/pJjKOWflxTiWuJZO2wuh9rzu21tAoo7ljRopvJy1j098nqYe6tFJQihRKWcI+MO0iqSQSGHyR/n7QMdTkkY/RhRMbq1XDYBNFxoOKC+mvZ6wPEiUDjugEaGfD1Lfv+0nQFQyVX1B81x31tI607kvUmveF2XE08ihwkz1s5mKJi16DFoA==
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


