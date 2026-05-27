Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7D5CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCFA6B008C; Wed, 27 May 2026 16:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184296B0092; Wed, 27 May 2026 16:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EFC6B0093; Wed, 27 May 2026 16:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D933E6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4D4E1C05BE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:10 +0000 (UTC)
X-FDA: 84814387140.18.A1DA13A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id CDE0D180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="D2y/MVzG";
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBXzyPhWkzGmNH/N9A+/kfLtlL9nu+YFCZMUKmgaFzk=;
	b=HUy9be4vcsNDvO/bfdrFYbNJ3tqFIigITBSl0M6v3shpt7Aq2njtYPqK1GSQzh6nOiMjVH
	cLW7v61PiSuB6QHiM1abhyWoMKerczyj1cc8xXM8K1adwKbB1dz399IwaME4AIA2JZB34r
	UXabnuH7ZVNrKtm4Sy9SArzwnAKRQCI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="D2y/MVzG";
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914888; a=rsa-sha256;
	cv=none;
	b=NjNhxyn98O9aY6/ZuYcqpd0kpwVea9fWplJqGv6nFU41RVP9vTLIAZtxt5hcR5dLfCZVW0
	c5crcxb3B0JC7IOPAiS2zwhzTCDceAPDw39gemiudRB4/+jeo4ttxoBNGpb6H/dxSH29+t
	8vGFo0Xt+J5KgqDbc5NvO6h6F/JS8xc=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51306c9f2e1so141376301cf.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914888; x=1780519688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBXzyPhWkzGmNH/N9A+/kfLtlL9nu+YFCZMUKmgaFzk=;
        b=D2y/MVzG5MzvOV8YXELhgrHiIXZUaha+D9ZgSdMN0BIQ6IbyhMMWRJuKKatVVfsPeG
         ZPdIzxmuF90PAnlIo3g3QgAnQO+Fj5/wch3GLkYwgxkkvR9A1hhNWetv4swncz1ZyZlk
         f8Var0TrbV+wQAr3l7LO/ycSA3RZXRnwG1lqaT0zxhlNkeol/+LNLvlYGNqS3LfJwkmO
         W1hlHEjhOxP8NBNv8qMLJy399XOgiNcbScsKOqzhRUjSbDBReCbvHws5Y79U5retc3IB
         Omk1gDTt5KIEf0fXyw3q5u0Mo9lkfzlXX4TnTqo8pBv0P3Ns+Vw9tUgmOy7HuLp3CoO2
         6cQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914888; x=1780519688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GBXzyPhWkzGmNH/N9A+/kfLtlL9nu+YFCZMUKmgaFzk=;
        b=nmStNmskoiCMPFxoTUvl11BU23FV7JGomV3u3jeW5d67j99tPN34qw4RIVl5M70NvQ
         s6PA/xKeHdsNraC8JW9A687oRm5hCbTHhrghTzZ8+pAMTxa2KIA49Y6Y6LG5XO3eqXjw
         FFG3cfFcoHOYVKhWzUvdNWJkXtbtOupGKLd7bxeDuuLmWV7Yp33RAbrVwDsv0RvMjOLF
         uFwKrXRBlI1mD6G+7TzSufiFaiSNCZXybpMYDtmn2hjcWzduX/X+zHPXD/vKwOfikwg3
         0jsj9OBJR5CjAWNNFO9bbArV1zL1eoBHNROz94ibIKuRmUowCj+KpH6BHJLg0jL/hWcv
         AhOw==
X-Forwarded-Encrypted: i=1; AFNElJ/Hb7jOe13nLS2tggIOycx1gcWVWAA012E/Pa7IQ+nip/B/OBFEpkEUZr23y1ZGOR/12iyBZxMYaQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9uY5nAESC23y2UIK0wKFppm/nEYBzOw0EHMZx7Xwl18+zT2fG
	U2m708Ep4Tbsgbq919u/jkT7mIKNEMZJQ2xPLYeUfarUpePZ0alhxQTrNOXdEuWa02c=
X-Gm-Gg: Acq92OF/LC3Iyku9snq9fHlts6Iu1eJUOSQe2uqmA0RzBeijsdkPo3nyryNvNA0XaVS
	lB2ODAhrH/Pun7o4vILad9ucVESMIMHoExnvg/oICcN9CAubtmZM277p4m7j8eeanMp0q5fk8CB
	1FrTNQd3UtSxcY6AMRifdl72u4Wy5TvOyKOVEm9coXQkTry7brpqWCiG+1/kJhSzu5ld1xkRdWg
	MEiAEPuAtkfq6gtw0yyAohZzJVWwwQ2pYylExalS1fRu9PCnJ5k5v2y3kCQj5+o4s/PdaYdmay6
	huG/mJJYSvD0xJtaGhPBEampFa2qK3K0SmtwJJhwACky/ZPqV2P9y60NcoybOcAOnZhGDdyFuzQ
	LnNqx+wS1E0jrRJQ5gZwBmRQyZhI6GgLEEDrOHXxxOkbcWYnGTk2TP43qp7rAuWsfFHfWMjtiw3
	N8rf3p4un0t6U7v8UQpdUI53EmACEHnB2b
X-Received: by 2002:a05:622a:244b:b0:50d:e471:2d1e with SMTP id d75a77b69052e-516d43cb2dbmr336768581cf.35.1779914887963;
        Wed, 27 May 2026 13:48:07 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517069f2d2fsm59376831cf.3.2026.05.27.13.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:07 -0700 (PDT)
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
Subject: [PATCH v5 1/9] mm: list_lru: fix set_shrinker_bit() call during race with cgroup deletion
Date: Wed, 27 May 2026 16:45:08 -0400
Message-ID: <20260527204757.2544958-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gghzopb64ebcmfsqawzp1a9fcqutja8s
X-Rspamd-Queue-Id: CDE0D180006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779914888-992664
X-HE-Meta: U2FsdGVkX18CCmgETNNgXJe5oQOtu+sO9OuW4fQtr3gzA0O8swBtpVn90kJUe+gXwLdPaULqMFqsr43fFwzV8YIsE5fhy8Xhgazi0IOwaHfRMHcfTYW/uq72rMeYylOoroIy18TMRx8fdG1QeBPZvVb8M97zXFqCZoddohVHcl9h00dFSwLP3cKWkIwEEsyiLmqnRWdCGhDgg2sbzs65l0eAelDUjJ2TU4J07wstWYh2OXut4bPYwfIu0FU5jo7ae5SmyoYuHelauDERjwBbnlPf8x7Va1QZeyOxk8IoiNIEX4utUoVda3l3qeSdUC1otGpZWN9IbMSn2CcyCyXuyvHnzc89ABkXTDAMlgLw5d5O7CEdEfGuSntiyhMpvTYn8u5lh50iJJ3gBHBj6b7ZDZREWYD7i7kFqCdH4Id139bxftAJhFifboAbW3H94AZowgvx9uiw243mwDXk1/b8jlQMbGJP2Xwc9iWhqtOipbCQOn56Ofgu1JaIOXCtkHHsKjLRdqMYisJkBOCHCUb6/o1igFQjHK3gj1K6C7RWYfy6sKKGmokBwFO2DscYIfDg7df3Z4sZU8awtoSwBhU0MIKKB54J7RHGqRWlGtvWTBAFSHpTk769YowV3ZrnunDz3pwYxvU86sKDbdLAvlGi4QnArDKCwmWJN1JeXKgZL9+uhjJzzhKpExftzr821BroVR+Kwz+n4/NYQCthuvbFDrn/RQeGazbGUQPwmnE4NHTkD3pO4PgneRYuWLaIBPXJB5eujrGNm9bQKNbCnucagbfgKWaiKV3v2hV9ohUI81vSqMgkAuPTen5f4WYrzRCn8+Rcj8SMZK+gQh3TaA1UBzlEPwnz4zMNO9RP8QbcbfsbtSDlH6TFkQJYSC/F6iO1wdAuqT/oesOXjTr1+tS8MH+baGbvq3ZIS/QFfV73ZgFY0icUx/KxpmTovOcNd6y15K43bHE1JQll1TiT4rf
 t/4CtH3C
 WnkKC6rhodBkVqPHvXiFetO01uaTkTxGyBwYN5S3XDSU+Aiybvr1beZwZQrw9WfjUh4EJCq4nsI2coaUXgi8yjaMcrSl9V43RiHfg7bExXcHip2W4ICMmTsz9Xl9rjDxWXRwfiLb2fZ+WCGuWXdPSfLWc3Xn6hdN+hct6StFxFHMQDn5KH4MoKnRfveIxGcm3lpVRoACfj/GhMpQJCiny1CkwqeCrA9EF/j0X40Jeptf66rM7HxcBNdxk9eGUC/wa7iGIVSd0yGekwxlYqmaJXdz/UuE6RTYMRTNIDCX6MLc+SkFWdLIesZ/xwdUT7jD7aZfRYYpwyEXjYiHwk2v94RmKLFL2KdlyG/s/SLGW+PUPaM6CrMFKaXLR+vbgYMfXoYGyxUOzfp+rifsETAjv0rThTp88DcktJXMm/0O4/jKP50K6g2M9jqAjJzYN4/ooKbEQB3iXK5SHS9m4YY9BLSlCkJKob2i21VCA4sY3u4BB6ZMs2IHLOB1s1DnE83dUM2GuMiAxHKmNe+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When list_lru_add() races with cgroup deletion, the shrinker bit is set
on the wrong group and lost. This can cause a shrinker run to miss the
cgroup that actually has the object.

When the passed in memcg is dead, the function finds the first non-dead
parent from the passed in memcg and adds the object there; but the
shrinker bit is set on the memcg that was passed in.

This bug is as old as the shrinker bitmap itself.

Fix it by returning the "effective" memcg from the locking function, and
have the caller use that.

Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
Reported-by: Usama Arif <usama.arif@linux.dev>
Reported-by: Sashiko
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index dd29bcf8eb5f..45d1b97737ea 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -77,14 +77,14 @@ static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
 {
 	struct list_lru_one *l;
 
 	rcu_read_lock();
 again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
 	if (likely(l) && lock_list_lru(l, irq)) {
 		rcu_read_unlock();
 		return l;
@@ -97,8 +97,8 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		rcu_read_unlock();
 		return NULL;
 	}
-	VM_WARN_ON(!css_is_dying(&memcg->css));
-	memcg = parent_mem_cgroup(memcg);
+	VM_WARN_ON(!css_is_dying(&(*memcg)->css));
+	*memcg = parent_mem_cgroup(*memcg);
 	goto again;
 }
 
@@ -135,8 +135,8 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
@@ -164,12 +164,16 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
 
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
 	if (!l)
 		return false;
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
-		/* Set shrinker bit if the first element was added */
+		/*
+		 * Set shrinker bit on the memcg that owns the locked
+		 * sublist - lock_list_lru_of_memcg() may have walked up
+		 * past a dying memcg, and the bit must be set there.
+		 */
 		if (!l->nr_items++)
 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
 		unlock_list_lru(l, false);
@@ -204,7 +208,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
 	if (!l)
 		return false;
 	if (!list_empty(item)) {
@@ -288,7 +292,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, irq_off, true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
-- 
2.54.0


