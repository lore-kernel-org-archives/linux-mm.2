Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E47EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14ED6B0092; Mon,  2 Mar 2026 14:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3076B0093; Mon,  2 Mar 2026 14:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBFF6B0095; Mon,  2 Mar 2026 14:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC66F6B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BD131401EE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:15 +0000 (UTC)
X-FDA: 84502171950.15.95A1ABE
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A7BAC0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="G44YdX/9";
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m4nFf6dF08qw2hzXIDF9i+2wZFYfD7fQfBYIdzHPvQ=;
	b=Nr3W0KKRY3x2JG9miWKlkYXu5u0BRofKGRIwhD6kFCCvbF4YzIdQ/om1OLnNuh3Nw35kEq
	2cIq131ctFWP1DDgx8qq6eRiTN9lP9mdmQqmqDy26f+I8Ze3qdqrPf3pnjU4wL6LzarYPf
	D+yfgyDSW1h2IfBAJ9MzddiSU0Cj/ls=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="G44YdX/9";
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481193; a=rsa-sha256;
	cv=none;
	b=4QiEXnNf05SjhevTkQJNjw2EagGF3+dzo+CySK03OSc8TaZI3es4VbutGoXaP3XqJKphTG
	kmpYKf8cf1AxTzTNECRefKLBP0cxMp7CaTLd3RJFCUHSBcuDST8isY/8VYQl206+zbvU0T
	xKxy8ivthxXxF/nleTIhS2y3v6qXsUo=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cb4097794dso477350085a.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772481192; x=1773085992; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5m4nFf6dF08qw2hzXIDF9i+2wZFYfD7fQfBYIdzHPvQ=;
        b=G44YdX/9ozzL9ogVZtuohf4BR2/T6EANg2D8WXx+K7eBupPhmtk7Xhhal3PGepVyxO
         AkOgySy5eGN53tiJFK895RHcUc9O68LVCh/NSHSqujd+6Lj46oe/VX/ynLLvtbYZe+sa
         nFyHn8dWd4AqG5XX+JWyiPn7jMvZIz0zm5Def9enz7aMPowicx5Wn+7ylrOKi1lyDfeD
         AlkVyb+zdreG6FXwGZTFq4EVMpe2ysmModT6+j8FKMy7Krf+MwWYu4HmrjbQbqf+Sgn7
         bx8eFYFxQObPuslSCTD8puAJpF0KPJIbGEmXsQs+ipeS9hm8Tq3mPWQYKlvAUy70XZK+
         694A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481192; x=1773085992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5m4nFf6dF08qw2hzXIDF9i+2wZFYfD7fQfBYIdzHPvQ=;
        b=BtVn1IThpzd3o3+rtXvr/2r3Tv2amuWcB+05z+d7FypCr98hJ26zKeEu1TH8USvDYD
         RAwyIu3391JegOB/deF74QZ9Ws8PY517JbrKfNZtsLFy1UCsj7ABROGwIF/GQmg7pgbW
         IxxBDJrTIdlfIUP894CGo6cDNNUhxKFluowbIYZvk2D4V9eWzJtrM7iaMwJacjUw/Ivj
         twC5j67RxltGpMjda1NJNrn4+Nq3j54wsDfjHNnsbJJQAJYRMja8/EPaGi2RJESZIEAL
         Xq5YbhRGHTGBuUAk6j4jqH98APHsBov3teJCkGODMNwf7gERJJuAlVo1ONnSUXiPSDmf
         ChBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyH5gVr5azahqg2cf/MQgaL9MBKQ+xllF7AhPY6XnMEZ/F0UOy8xs+SuCO/lAdXQo4SVaCcP1WfA==@kvack.org
X-Gm-Message-State: AOJu0YwtOoqN/J21nwNHJ2gidTR1VwvBbmE2+1PTHmx1TTJBqII2KRvF
	LU1ke/1nB3lOGgJM45t6x5TN7kC5mnzUyKTN4Xaa4XtHuZjvE6aPfr8BlwBXn9Yj+v0=
X-Gm-Gg: ATEYQzxnUDhv5IQcqZRVt7QHdLQkyMsWYRlHsjzqEAf8ST3rqqCYTe6101y9ItQ0We5
	0rFiY01pqrM3gFBH/5866SqN5xbeFU/3si0AW75zss5MKtG0QDZi54HlHJtl18lWAzMQATQLJl1
	NEddNHiUdP3EAlCK2gQZr/wYsy/VtuednW4hlfb1lbF8+Ik2RUyvofLjWZA4o8NjypeMerTBnXc
	OJlsbngqjI6FvQVo5YLBTse9+tDa4og7E2I5yZ3IzVL/QsiDKKUqRXGvH6+mWwGqXFSlhQazdvM
	EJwQuPzuYCKMOPeGdI+UpPIJN+ifRSQtZ0SLUf4vhu21GNjfM1tDpQCLk7cD8J6NomiYzAlRCJj
	dEqfFzn6Wxxe/WXSBYVa2xeGQsLIeHVH5puW4VKXbrqPJjzKBkOAnNoU4b5v74zn4Mx1ZxMlrif
	uwTXDcBU42/ful2cTLmNR0Ng==
X-Received: by 2002:a05:620a:254b:b0:8a2:3be9:1d79 with SMTP id af79cd13be357-8cbc8d7a9camr1778134585a.18.1772481192477;
        Mon, 02 Mar 2026 11:53:12 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf652bb6sm1307822585a.4.2026.03.02.11.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:53:11 -0800 (PST)
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
	linux-kernel@vger.kernel.org,
	Johannes Weiner <jweiner@meta.com>
Subject: [PATCH 1/5] mm: memcg: factor out trylock_stock() and unlock_stock()
Date: Mon,  2 Mar 2026 14:50:14 -0500
Message-ID: <20260302195305.620713-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302195305.620713-1-hannes@cmpxchg.org>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A7BAC0003
X-Stat-Signature: i5noxff896attaufp8atzojfjttsnart
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772481193-198401
X-HE-Meta: U2FsdGVkX1/h2YU7bGJWvx1BNV6rh4fLwN+N2+6tlq0XqsjAGbQh0pG8Y3HbvkE08DjPUW7HVjYo7waMV4vGIEhuGonsInFxq4B2g6ct1qXYFSH7dbj/Eq+RE2ygDnKczmO3UGhVYjqp7rDZq4etw6kkNlBKuNsN94gT7Xmz3CihgrPHvRpkog89DuccJZ88dujpuMKn2h/wzRhlYyeOC/thh1XH7cJqmt3xjPmfmV5iUrUQK5sLVYRs2zU/U7yhe7fz5IOEN6+Wa+BPY1mGPxsnJOFnpLHAN1wkwxkz3pOqca0nf5E5mYYJ390ExlZkPOkSyMuTFOsqAG12f5jgDTy6voCuGI7ppyc38YZ8ldbSlNqusObpWE+oeWOPSKsDGrC1QBPBvV5Jj+IWtL9DC5YT6NTq5lZexZB6Lr/CvJr3pt+50kTCPTx4zDTVqyf4s6y0o9ZWODt2omLDX89nmK38xJi0DQUcAUCxByPp3z8TODLTdvz0xtpToTA6bSlzd7O5eaIuThDM42ys8ow2pZLJmXZfI/Q7i7sYTnRmKoXhXU9waBPiXRLOHXitdD2dKwtGcNjct2f5F+lR0vlrdGt+HUa60l0QgEsHi+N1Un1t6IEKOGlAQ/T7Tik/JFwpU25UTWjLi2yCToOREV6Y9w7S/KYmiHzSC6f81vsI6uY7un+1tczEN06WNVMdmDkuKFJVEvLAtUrmw9AtoIp/WfFY28MaUSs8f0LjOGjHiBAwRpfvYD6tUq4hPdc8vZAmJZ43NzDt05x5ZuTpXvR1QZJT/5DGWN7jbKepbrkvN1r+pKx96sOwtQK3MkKt7kJKX1X7aaUA9UcVuLxFmY573yDRGMNgXSoYGGxFaabPH0Z7W822kyesa8c2gI8U2YgrRcb/gdQl8L8fM0f3B684aghdyDxgrwYU5LXtUautyH7ZJZ5XEeQfjN2KWeLf2EU8B2kTqYNt3dVyg2TEet7
 i6HgiauY
 chsMRUzV93lHjaEWM9kht4JJI5RGXp7p1jSGvTsU8rklN5A3St+EWVGiGYlEWk6UjdPbqyKx0atjpK3NXyGHq/1nG5K9RwOBozpUnUpbjVzFYle3ucRLg0WvvadWZVHYUGpRkbThMJCv789D7kh41PJ1LKQUuw+qeHAu9RwDy7W4m93Fpdwv1BckK96p/LK0xtZQmH40nKarrsxykjPR5jScw4/zZM+v1LNncEB8QlXqKGaFXKeb/pEu5vqKacIHZEG8aPh1/2oBVX49aPDG+Do7C5yuDHD3FZ6GZXrV+o1x4Wq06PU/3atnpxR97PPJFiCrZ9JcFo69S4joqOp+hgx/O0XHctH/B9xsYGn1Ryz8HfkXkPD6amasUY+57SEBLtJ04g3UPsPZwa6Lex0sX76GDAxrUYjbncL4ZIzc19W+/5aP1XDvdii+Xg53nK83IxbLQczUa5kQTe3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Weiner <jweiner@meta.com>

Consolidate the local lock acquisition and the local stock
lookup. This allows subsequent patches to use !!stock as an easy way
to disambiguate the locked vs. contended cases through the callstack.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 753d76e96cc6..a975ab3aee10 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3208,6 +3208,19 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
 	obj_cgroup_put(objcg);
 }
 
+static struct obj_stock_pcp *trylock_stock(void)
+{
+	if (local_trylock(&obj_stock.lock))
+		return this_cpu_ptr(&obj_stock);
+
+	return NULL;
+}
+
+static void unlock_stock(struct obj_stock_pcp *stock)
+{
+	local_unlock(&obj_stock.lock);
+}
+
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
@@ -3263,10 +3276,10 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 	struct obj_stock_pcp *stock;
 	bool ret = false;
 
-	if (!local_trylock(&obj_stock.lock))
+	stock = trylock_stock();
+	if (!stock)
 		return ret;
 
-	stock = this_cpu_ptr(&obj_stock);
 	if (objcg == READ_ONCE(stock->cached_objcg) && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
@@ -3275,7 +3288,7 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
 	}
 
-	local_unlock(&obj_stock.lock);
+	unlock_stock(stock);
 
 	return ret;
 }
@@ -3366,7 +3379,8 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 	struct obj_stock_pcp *stock;
 	unsigned int nr_pages = 0;
 
-	if (!local_trylock(&obj_stock.lock)) {
+	stock = trylock_stock();
+	if (!stock) {
 		if (pgdat)
 			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3375,7 +3389,6 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 		goto out;
 	}
 
-	stock = this_cpu_ptr(&obj_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3395,7 +3408,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock(&obj_stock.lock);
+	unlock_stock(stock);
 out:
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
-- 
2.53.0


