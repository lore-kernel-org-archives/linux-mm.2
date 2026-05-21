Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CADECD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8C46B00BE; Thu, 21 May 2026 11:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1086B00C0; Thu, 21 May 2026 11:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB76B6B00C5; Thu, 21 May 2026 11:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7616B00BE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 784571C0524
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:50 +0000 (UTC)
X-FDA: 84791746620.20.73DFFC0
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9AC224000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="LpTHPt5/";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJv7QOlxyTdHx0IQuT1IvjERhQqwxSN8j0WlihPGf50=;
	b=Kii1S7H6Lw240A6lhlPvnv7dfYUAGuOSFlDq8PDZZoyNCJtmZgh9/OvP+whuMSnzZP4+XP
	J1oHv6qJ8BA1K/F0tLab7NAD6B1aUAA/ShD8Okaj237mauR3UKlyuKk3Acry2sWskkDssQ
	ImwopwqsNBFOBonl7dKFmvfdirDHBw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375828; a=rsa-sha256;
	cv=none;
	b=St+sqR3rRPA/35XxaJbv52v7XAwt3WM8h59k2vnucvRXmIWQuuuc+VT/D2yMbvee78y9hg
	XTTJvltLJc7jHLLfhjUBWpjLOXTpxis/VS83seijQpR83gSGIET2oFhmXvIojn3KJIfXWj
	v9sWepVZ9Rsm5tWq64+5EXcVQq1fmFU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="LpTHPt5/";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-911796e9885so599137985a.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375828; x=1779980628; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJv7QOlxyTdHx0IQuT1IvjERhQqwxSN8j0WlihPGf50=;
        b=LpTHPt5/YDmjiBmezE8KDxguXm0hiNXK1nlszVfLTlCHToQ1RWfz1HtvHen7UAG/p0
         IiI21DF9bQGaCYSWosi8SSp+rDAdKhZ2wF7plhwY9t400Cu8ZUGa2ObOS2uTJbgrh49z
         Tp1b+4iv4LBtsSQH9VYbsPauduUDBJsRGmeNTJtyVervQfVJdKorBeWR5Cvqizyp/EEJ
         rVnSPpBL6B3ZzIa5qb4AGU8MiQbosd67w34Fkfh6TDtMJj510VIVd7u1r0J8895cnbBY
         Gu7/GwJGLr207mqQdEucXiinhLT33W6QtjyysrEPJwFJfoX9VO0DMZ5QtpCCwp+m+d8h
         buWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375828; x=1779980628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XJv7QOlxyTdHx0IQuT1IvjERhQqwxSN8j0WlihPGf50=;
        b=aiTjKX+yk1zquUMqmDjL8I4hB7idPNRJ1+dQiB13G0A3qxnNRaB2mE4En4oE5semHI
         L0NEXk07NJr9FbXrhQqXJbsK37D2McUGMhpAHimW7rmMJ+N87i9GEKqcHUXk9rp5jvVV
         clGu2ErqeOzCbdPbhvghVQtJZ3soDAW0liRnK+8e4sO6lRL3B42DPI2ob86rWz02OJJ2
         3JQaVm6BvVhxaBQP9Q9sWfeg+NGgjfSvuZEVGNG3LhXnwRpQlZgpTQ2OOA1v25nu8WPS
         x5PrO0SK0Y64ndLLgf1COcjQni0TFaYg/ha/5kLSQ1w+9ftgVYaFjPluValaNwIuO7Gq
         YTEA==
X-Forwarded-Encrypted: i=1; AFNElJ9/LqL9ZBR3aBmjjHsukP7MXOxQ+6jgRtaQdpdc9WuTYHfCBcEYAsE+4I97Mf26+3zlbmquXtHJBA==@kvack.org
X-Gm-Message-State: AOJu0YzHBz+UkxiKwCMPxPq977HAELazVfDIurMfs8kewFVGF3M5gvK8
	Qu+wDmRKli+RsOUUSv7mIBxVOZr+eQdJC/BhapWGoxYBgnhLhxFs0Cg3uFrxPx+y6GU=
X-Gm-Gg: Acq92OEO38lIf6uAGgbIY9NLr4YY4jevZYMc7xi43TIUDXLbH/QzzZnRCbldqn8dZ7a
	LC96S3znaTuzEt5owaToQdztjkHKmiZ3/TTYvaO1vIrXmNEvgIq3/FPAZ0VxtxaQb+RxknPk3OD
	kPq0604YWhZ8PG0DXU76OMW9xau2C40ueebpJffkH2buNohc6y8FcN3XmE22RZ0dMDWZme38GrF
	DKQY/QQ1lxOPozqvb7q09JGAf/HaTYAYPSDpYXIF4oPd3PPyoWaDSf7RzHJm1qxRyMCNi4dp8rE
	0UhA3V5oO/HK/0BTOqkcOrAhDQA21AnT7tW0xAnLdavJmcY69c3aMvGl03cyZ2lo/BcahATkaM9
	YibqTN4EitTiYUiqdn7kfPXaHYa84bMmrafDitNje1nxYHUMBY30B7HUeE6ol9Riw4bP8FxvmJy
	M/QXxajMhaBUwLRGHFKAGVHxUR6mqcI0WW
X-Received: by 2002:a05:620a:47ae:b0:914:a824:6695 with SMTP id af79cd13be357-914a8246d0bmr214593485a.37.1779375827591;
        Thu, 21 May 2026 08:03:47 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914ab9faed2sm114273485a.6.2026.05.21.08.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:46 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/8] mm: list_lru: move list dead check to lock_list_lru_of_memcg()
Date: Thu, 21 May 2026 11:02:09 -0400
Message-ID: <20260521150330.1955924-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260521150330.1955924-1-hannes@cmpxchg.org>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9AC224000C
X-Stat-Signature: 8wiadr5r38bzbmbwc35mbuzzkzn4sx54
X-Rspam-User: 
X-HE-Tag: 1779375828-125412
X-HE-Meta: U2FsdGVkX1/ud71sjd+dC59x7yfvRUDmpwO2vjxX2AdGfoM9QkIkYEGECX/CotrWSqq1FfDmS+b8veRUX6JK3gunsJrmDP6kXSnxXyY9HVArc0IRYzaNwYGKmZ5SGIiXfC78Vee4JdfSBuiYn/lf2U/8G5bjBM+akl58mvXkYYLKnTpgdxky2OPTAk4It9C467nJCRq0Gy/k8nhbDjOnbn8ai2qVryadGg4F9IFpcnBsCXiJxm3Eu9ELvL+2EKfgo50VfDqNLE9MaHKDYVmTfb/BSKoIesb8xwO1G3XJECwcfYMgDfcdDCvjLyI74/JshRNlY+5gEl67pWP11kPnBClKTYH5kB25KNUFtURLLYwb8Eqvta/2Q+vbOjsmp5u6c9yGOifyPv+a1dm10ENDMKfow3x+znuTOqPTZz19OvRZw71CdTKBkJ1RaqbAGPC3q+CKrnXj9LxDSybDV8BEyb3gUO8fS1QZCpUayS/jboNGtMQ0frJDy+i8jFWjF9JwqOrWGfreqvt3NMWZb1PgIzH7urJxjSAfqZr8xyJXaMkNIrlBBKCsTYhqHWQKg+g7QNadDlQmu5GZUTTEkzTL8fnlW/9xbYdefdknybQTtSal/JMLZx1DY8N4oXaBHfvJpXXcxF9WJJiJBSe9ZBQHJRGfHZKmQ9aMTqCxmgLQhZfqviSJ6wnZ8xkcRNuXo8BbooWELgk3rOhGHmeNGfGCAa7MS919RGJjTzhKncfDjETZD/4kM0PeE+XgBiW7iFMifXyzxnP462DkOoQTpSmw6XPDOiYI7fw1quuFrsewuuhISG4fmOdL3f3uJG80uqkzD1NcPlBSXi1yBpPoc/G2g0gYMA0wdmH2r7t+XGiqVA4uj7u82okKFPjvsGUw6E8499JZ3MPvfTDjrO8+nejZDmI9b8vlZo7UUQoqTRoJ7XOuNtxlTx5t8dtppxz0yafa3ECEaDXzrxDs7Lf1YRC
 8uyOgF70
 I/5RjBd4BExuoQ7kMkbnH3zYAEGMcdxdPGjcPHa8r6UOQ4y4z6io/vc54DzdL34tyYWVZ2EE7wUtEUjO4VeEANllG8X1XDlNhDAOrCLvWJYtgBWcVRBOdFFwldCjphKXKr5Gy0jsE2FSrAXcZypfm7A08dWOGYL9B7ATuAmadwP2rHTshRy2EMvo8j3NB45Ps3nZFd439qivmKWf2zuI0U0cI8jcVXEGAz34lqvlZow9ScTt3/S1fyjNlByulpzcbKsdA8w8tQQ5BCWWAUPWfmwTLd7yd7EqngStj/Ged1y+5ioSxb4shr19OUTuMSVCx+NG5YvA65wUatvXBgCqyTQ5IWMwcGAWR/jq9vKewBd7VNODs5Zz9vLSbo8D4UYzJBO1KFtNQb6srsuo5tXLnXQBJbjQRBnCkiPwtUWRsseg5EiUaCOwo4S6IMjT7iIbTkj4UzWSa06nfRyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only the MEMCG variant of lock_list_lru() needs to check if there is a
race with cgroup deletion and list reparenting. Move the check to the
caller, so that the next patch can unify the lock_list_lru() variants.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 9a68177619bf..9da6fce19832 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 	return &lru->node[nid].lru;
 }
 
-static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
 {
 	if (irq)
 		spin_lock_irq(&l->lock);
 	else
 		spin_lock(&l->lock);
-	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		unlock_list_lru(l, irq);
-		return false;
-	}
-	return true;
 }
 
 static inline struct list_lru_one *
@@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	rcu_read_lock();
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-	if (likely(l) && lock_list_lru(l, irq)) {
-		rcu_read_unlock();
-		return l;
+	if (likely(l)) {
+		lock_list_lru(l, irq);
+		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
+			rcu_read_unlock();
+			return l;
+		}
+		unlock_list_lru(l, irq);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
-- 
2.54.0


