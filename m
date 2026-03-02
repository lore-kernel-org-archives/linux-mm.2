Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD42DEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D946B0098; Mon,  2 Mar 2026 14:53:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E486B0099; Mon,  2 Mar 2026 14:53:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553AD6B009B; Mon,  2 Mar 2026 14:53:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 447CA6B0098
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A2F51402FD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:23 +0000 (UTC)
X-FDA: 84502172286.14.F6343D6
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 331D540005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=d3esndXY;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7vZGkE+1JaDLDSfa23XDw27l8nhvvwnMmFZbgJqVLA=;
	b=v8jmaqC13pLj9h3vT5LJfhGPzMVVy2MLWmQxXK1o4rTyTXcSS9A+5E8AV+K1+2Vpccn/xI
	pn4k0huOGg+lds0YDGAsgbNR/UNMwUvQFYr5RZSSEY7nkRVYXNtRHE392BTjc12qyCWsbc
	QuAzsRex8x60ADXX52QhtuKddST3INw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481201; a=rsa-sha256;
	cv=none;
	b=mMEpFqjcf/e4xFtu6sisBAugoh5m986LrxDqlELEnzt0BM+HXnO4taNA7Lkz9a4BacepPf
	7h4Ypz+8Q8Yuy0BK77ep7XSBZlRH84fKZ5sB0x9W/ThqMgvqAAhQGR/0P6wixjvTF1G7Yi
	cKEr+mLjaVS3uqR1jFyvhpBPNQkCT8M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=d3esndXY;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899e87b04d8so36962406d6.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772481200; x=1773086000; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7vZGkE+1JaDLDSfa23XDw27l8nhvvwnMmFZbgJqVLA=;
        b=d3esndXYlq+Pz9NZyJnl5MCPI1b5d82P5cVGjXuEg6Sd67fPzldM2adiXgRJmkN5ep
         QH1fAa65vHacwnadxlz0uCmRUnKqIGGdDkIPfvN2AvO5B9pSz1W46OYoIwHVSSwIacye
         1r6S28LK34AkxzJSx86cnmvx5VnsNfRm+cx/6cv8FnghBmjdUGxV7V597YCttZ3Zm60Z
         McvvgWWE5vZdGVq0rOleSEqDkhxcRGcJZeb+A7xyC8ku373DKR3tWigkPAIu0jqGV7Tl
         McrvKy4MdHzrWhd7CFtbyf1f3+bCWo9CL1M3b+CPmkIv5iCtU8n6Sbceq9p9ty/sef0W
         EI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481200; x=1773086000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g7vZGkE+1JaDLDSfa23XDw27l8nhvvwnMmFZbgJqVLA=;
        b=qMb/wyh8j/6HNMm1FyzaD/bjkhA+BaA/yIHE8dpXwBvrCqugmoyhD2+TRExgnM6qQg
         btAVZ6WN/Ovp2OAnBNzj1ul0IeAI5XwIvV0qSgvQyZeS9wysEWNC8Mq0YRD00D40WoDV
         IBkewc7r+tumaGMPez9W+eDdnfEolGEN7i2fBAE6ETRzr3swEoK9vd6uVy1A3yqau+/x
         dbaO6tQ8dZfphVXPtY0Mu8rXAtna/CIsmglB1nhiIK5RnWR6RdWceN0f9oSsFLjzjM8q
         YwfkNoDZ2ko4o/Av8s5gHRPa26puzYZilVJJkqLJW89I+AHp8MCeVnPCcTJpKGGeS2im
         tuDg==
X-Forwarded-Encrypted: i=1; AJvYcCXVkMWCsCQfmuk16Xyj6+nPXooybCgEjoeXJstcBfUcJaIHo1NRwymxGrDaD1egg2sHl8amAO1LIw==@kvack.org
X-Gm-Message-State: AOJu0Ywr7OBEXW9B1lYFz/l7NnsXrrrpz4nmwhWx86oJKoy9/2jwezMF
	TVKaI8+Ck8+UdmBJXDjZuZmpwU2QOmwH0W7LXSIjREyzeoaFYeZCmc7NZkw6lGXOE/Q=
X-Gm-Gg: ATEYQzwZIH5XdnWlwFJLrZyXl+0ZjzkFIVovUc0uxGkXvPyapHjcLP5+m2ZpIW8yOr/
	KGgBrDI/GL255hvwt9pGfq++l2zXql1zBGf2pOuv+Bd25xD9buIs/S3TFBDN2dHHZximU1EIzym
	v0hblKpinOOCzbgNz9M0jTKlrh9wztSKbAxe87NXe7t4AKNw75gHgGMjoTvY/P5b00lyH7oaAxy
	O4HiCIvzsh19N4yeEF2Uke3Uz+kcl+lSpPiWa5wlMTpz8oQTm1da587rb8R0iEWSg4C97eEbWGn
	VxMSvAewv4O2/TNf+diuwePZqNImHyFy3rqGZeoeAFXLAUASaYmfR4mtuGblxO/SVkgogjzeIx7
	JLuKuC321PhMNKTnBVoXB2RqC9GDSi42vz5sVjsVn3TSam/iwQVqu58yLcdOb5UaXtzaFr9uy67
	CjTfxuvolY/+ncWlnuxOIn3wGh1cB0J4L8
X-Received: by 2002:a05:6214:d4a:b0:899:fd80:f79c with SMTP id 6a1803df08f44-899fd8106b5mr59620616d6.22.1772481200266;
        Mon, 02 Mar 2026 11:53:20 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899f4fb208dsm44179416d6.28.2026.03.02.11.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:53:19 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg charge cache
Date: Mon,  2 Mar 2026 14:50:18 -0500
Message-ID: <20260302195305.620713-6-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302195305.620713-1-hannes@cmpxchg.org>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ew8c3jsmb4xifsse7w9z6huax4m3bjmw
X-Rspam-User: 
X-Rspamd-Queue-Id: 331D540005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772481201-773013
X-HE-Meta: U2FsdGVkX192ZpDsG7ptw0/ze82/GipCG5+u5t8cM3jpo20HtwLO6lNElxpGE89VSMFEUZel46zbDGJP0GRBJ7Q95PQRFcOhL7xJ2MFgwawxVrzurRnAhEgS2X1EY3NlkDFPYHiPq3o/ON1WzVbUomv2BwkqnJecjBK9f6bNti4DMjaJ8o+2MMRvLKTvwmkp849toy9ZIN6YgHJsTGFw0KvtuhQqeKKooZ8VivJZsNW3wBu5pTsz1wz8+9WAlfjg22gd6v6HP3HFBNF0EzmJPFy0OPl4KbHlp4HVE6toblSIfktjZTmgT23vD5HmhB2rK9I7rOWBb0gMBddgfgTp3VbBtzZYVdy4j7Q9EYY16uAy+c9hnn9ecC7pVaShe84a1Co56MZxbjNlh2wc5MVDvkOBGaGD/5YH99nZ3YRCu2h+KgmfTn/4bp3The2+aQakSEP3XjIHvnQ7/QLKfi5L2SgUO/nfnN4lenOhWlSjupbW0NH0lKgJfVcq8t5aPXY5JjD4BzEmS0MLMWEHXNbbJ2sjfo2G75LztmvQ+E526cTl0a9iI1AXQqzcitFGI76bxps12k3/hPhY88gn2pAKziC8XmspZPnJRKpYrDmRFvW5b8TGPRXqfDElCKTcKCVf/vsR4xfSlNLiBhaD1BMEGQ8UjqcMrgckclLF04RCZKF1QpZbl33kQsqTUfiqX4mZrHnYFuQxtMVOynVAhWhTC5ub8Qj7OrQ6H99dWWI5mzTu3ginNcDQIYmZl3ebkgPiGqMPBFETl1TmAgH3KAMpmAJVRowWF+KuRrGbwP/u0BdZlQdXvHNyW1WVgWZofwWs7xmj3Y6yPXIakOe5a+SKjcnXTRD4IcSw95r6h+rlZVrVPrqEOU8oVhYhhGtZQ/hi7fupwqtn3/s3dd+PVHzWzP1o8lbDfowXYgX3+eqK2W9+0MfHnciv4akUGrUnsuYrm1ELkZ7BMdzL2tmGFCp
 QiLJic/e
 h7ix+zJEkKeTkeDwAzOXj1nGL/Ydd2sD+DSwAYza0s/Lh1nnlmwGfEPZIFnN7gjTSm19iuQBpclmzX/f3wwsIC1C8eiw8NAmQibB9TdLCP5/y7IZ//QgFNkfOl3/AJBmtqevimMYGwscKRZgAt8NfJGUdoYHkmHOmauDUOM+FsGljtCz6SjCsaZtCxERGrALrrhhkKmYIaAxFuQ3ZpZ74V/suhEz1lzfKNDGw97RE1njh2VXu8CtPhpGHjJjQUFGKl42VvIv0wtBnovoUTIUP9EjNVwB0qwwPC+Ksz3C+PUZc4wNwQpa03VzuykBDlzaaK8gC6Y+UFkSFVIqt+/XwJJONhLvWN7fzSzXZGwe81lusThheRbeOWUFYE+6M5eiLHQQw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cgroup slab metrics are cached per-cpu the same way as the sub-page
charge cache. However, the intertwined code to manage those dependent
caches right now is quite difficult to follow.

Specifically, cached slab stat updates occur in consume() if there was
enough charge cache to satisfy the new object. If that fails, whole
pages are reserved, and slab stats are updated when the remainder of
those pages, after subtracting the size of the new slab object, are
put into the charge cache. This already juggles a delicate mix of the
object size, the page charge size, and the remainder to put into the
byte cache. Doing slab accounting in this path as well is fragile, and
has recently caused a bug where the input parameters between the two
caches were mixed up.

Refactor the consume() and refill() paths into unlocked and locked
variants that only do charge caching. Then let the slab path manage
its own lock section and open-code charging and accounting.

This makes the slab stat cache subordinate to the charge cache:
__refill_obj_stock() is called first to prepare it;
__account_obj_stock() follows to hitch a ride.

This results in a minor behavioral change: previously, a mismatching
percpu stock would always be drained for the purpose of setting up
slab account caching, even if there was no byte remainder to put into
the charge cache. Now, the stock is left alone, and slab accounting
takes the uncached path if there is a mismatch. This is exceedingly
rare, and it was probably never worth draining the whole stock just to
cache the slab stat update.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 100 +++++++++++++++++++++++++++++-------------------
 1 file changed, 61 insertions(+), 39 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4f12b75743d4..9c6f9849b717 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3218,16 +3218,18 @@ static struct obj_stock_pcp *trylock_stock(void)
 
 static void unlock_stock(struct obj_stock_pcp *stock)
 {
-	local_unlock(&obj_stock.lock);
+	if (stock)
+		local_unlock(&obj_stock.lock);
 }
 
+/* Call after __refill_obj_stock() to ensure stock->cached_objg == objcg */
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
 	int *bytes;
 
-	if (!stock)
+	if (!stock || READ_ONCE(stock->cached_objcg) != objcg)
 		goto direct;
 
 	/*
@@ -3274,8 +3276,20 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 }
 
-static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
-			      struct pglist_data *pgdat, enum node_stat_item idx)
+static bool __consume_obj_stock(struct obj_cgroup *objcg,
+				struct obj_stock_pcp *stock,
+				unsigned int nr_bytes)
+{
+	if (objcg == READ_ONCE(stock->cached_objcg) &&
+	    stock->nr_bytes >= nr_bytes) {
+		stock->nr_bytes -= nr_bytes;
+		return true;
+	}
+
+	return false;
+}
+
+static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
 	struct obj_stock_pcp *stock;
 	bool ret = false;
@@ -3284,14 +3298,7 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 	if (!stock)
 		return ret;
 
-	if (objcg == READ_ONCE(stock->cached_objcg) && stock->nr_bytes >= nr_bytes) {
-		stock->nr_bytes -= nr_bytes;
-		ret = true;
-
-		if (pgdat)
-			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
-	}
-
+	ret = __consume_obj_stock(objcg, stock, nr_bytes);
 	unlock_stock(stock);
 
 	return ret;
@@ -3376,17 +3383,14 @@ static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 	return flush;
 }
 
-static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
-		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
-		enum node_stat_item idx)
+static void __refill_obj_stock(struct obj_cgroup *objcg,
+			       struct obj_stock_pcp *stock,
+			       unsigned int nr_bytes,
+			       bool allow_uncharge)
 {
-	struct obj_stock_pcp *stock;
 	unsigned int nr_pages = 0;
 
-	stock = trylock_stock();
 	if (!stock) {
-		if (pgdat)
-			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
@@ -3404,20 +3408,25 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 	}
 	stock->nr_bytes += nr_bytes;
 
-	if (pgdat)
-		__account_obj_stock(objcg, stock, nr_acct, pgdat, idx);
-
 	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
 		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	unlock_stock(stock);
 out:
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
 
+static void refill_obj_stock(struct obj_cgroup *objcg,
+			     unsigned int nr_bytes,
+			     bool allow_uncharge)
+{
+	struct obj_stock_pcp *stock = trylock_stock();
+	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
+	unlock_stock(stock);
+}
+
 static int __obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp,
 			       size_t size, size_t *remainder)
 {
@@ -3432,13 +3441,12 @@ static int __obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp,
 	return ret;
 }
 
-static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
-				     struct pglist_data *pgdat, enum node_stat_item idx)
+int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 {
 	size_t remainder;
 	int ret;
 
-	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
+	if (likely(consume_obj_stock(objcg, size)))
 		return 0;
 
 	/*
@@ -3465,20 +3473,15 @@ static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t
 	 * race.
 	 */
 	ret = __obj_cgroup_charge(objcg, gfp, size, &remainder);
-	if (!ret && (remainder || pgdat))
-		refill_obj_stock(objcg, remainder, false, size, pgdat, idx);
+	if (!ret && remainder)
+		refill_obj_stock(objcg, remainder, false);
 
 	return ret;
 }
 
-int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
-{
-	return obj_cgroup_charge_account(objcg, gfp, size, NULL, 0);
-}
-
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 {
-	refill_obj_stock(objcg, size, true, 0, NULL, 0);
+	refill_obj_stock(objcg, size, true);
 }
 
 static inline size_t obj_full_size(struct kmem_cache *s)
@@ -3493,6 +3496,7 @@ static inline size_t obj_full_size(struct kmem_cache *s)
 bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				  gfp_t flags, size_t size, void **p)
 {
+	size_t obj_size = obj_full_size(s);
 	struct obj_cgroup *objcg;
 	struct slab *slab;
 	unsigned long off;
@@ -3533,6 +3537,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	for (i = 0; i < size; i++) {
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
+		struct obj_stock_pcp *stock;
 
 		slab = virt_to_slab(p[i]);
 
@@ -3552,9 +3557,20 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		 * TODO: we could batch this until slab_pgdat(slab) changes
 		 * between iterations, with a more complicated undo
 		 */
-		if (obj_cgroup_charge_account(objcg, flags, obj_full_size(s),
-					slab_pgdat(slab), cache_vmstat_idx(s)))
-			return false;
+		stock = trylock_stock();
+		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+			size_t remainder;
+
+			unlock_stock(stock);
+			if (__obj_cgroup_charge(objcg, flags, obj_size, &remainder))
+				return false;
+			stock = trylock_stock();
+			if (remainder)
+				__refill_obj_stock(objcg, stock, remainder, false);
+		}
+		__account_obj_stock(objcg, stock, obj_size,
+				    slab_pgdat(slab), cache_vmstat_idx(s));
+		unlock_stock(stock);
 
 		obj_exts = slab_obj_exts(slab);
 		get_slab_obj_exts(obj_exts);
@@ -3576,6 +3592,7 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 	for (int i = 0; i < objects; i++) {
 		struct obj_cgroup *objcg;
 		struct slabobj_ext *obj_ext;
+		struct obj_stock_pcp *stock;
 		unsigned int off;
 
 		off = obj_to_index(s, slab, p[i]);
@@ -3585,8 +3602,13 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 			continue;
 
 		obj_ext->objcg = NULL;
-		refill_obj_stock(objcg, obj_size, true, -obj_size,
-				 slab_pgdat(slab), cache_vmstat_idx(s));
+
+		stock = trylock_stock();
+		__refill_obj_stock(objcg, stock, obj_size, true);
+		__account_obj_stock(objcg, stock, -obj_size,
+				    slab_pgdat(slab), cache_vmstat_idx(s));
+		unlock_stock(stock);
+
 		obj_cgroup_put(objcg);
 	}
 }
-- 
2.53.0


