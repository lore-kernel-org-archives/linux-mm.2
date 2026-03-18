Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A6A1077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6975B6B030A; Wed, 18 Mar 2026 16:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6498A6B030C; Wed, 18 Mar 2026 16:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C27B6B030D; Wed, 18 Mar 2026 16:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 364C06B030A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 004BB1396FA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:13 +0000 (UTC)
X-FDA: 84560260428.03.B626C28
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 59B1340009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kcFKvJon;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKEn0eNu+Wls6kueeJsU2hAaS0QRR2i3TclFtAuyFDs=;
	b=D00p/TaKPbqU7h4ZDbnrEyY1EjcSw+MADLctuIYsqe4MoAWask4XyORL+4eQXTStvf5vhf
	bhHH4/4JAKLy1JLx+rtnt3ib439RafWkHcj1mCGDvjNm3TIRSK8XJTetc5xjPn0Pz/TALW
	76Fl6dQMCp8oGco/5C9sQF0fX3qL3K4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kcFKvJon;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864252; a=rsa-sha256;
	cv=none;
	b=RbCR+dDRTQKDMTXpddtYPQAfOhcsOTeftK0LifM/zzkjGSLz8jPWOlOi8Eg7yPNw5X2Gt8
	Ipv2vWMUTG0kcOhgy3qXs0T3pSR2rAARRoypNV1mt3zh0AJlMrN0N4vB+gZ9VGoHkWGIAZ
	K9KLFYCyPwUQvIUDN1XV2T61DAHqpkg=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-89c4bc36053so2392516d6.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864251; x=1774469051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKEn0eNu+Wls6kueeJsU2hAaS0QRR2i3TclFtAuyFDs=;
        b=kcFKvJon2DS209+Us0kuG98XtsAULZxtQeA4w4tLm9pVGyV5LX4F+kkgTxgZg4ppTK
         z66WaEsOhl3cFivl7GK91RVODTmR3dRk6Db7Epz8mdG8NzmAZIErTEOMikNHkBM05Y2Z
         KjOk2w669sjWUqMjlFkrXQ++Jo+RJ4RJGOsPi+aGVsERt3SCxjun636yb4yudUHv3Bvc
         OPkr7U6QmiNFmkcXdmE/UBFetQCdD4TsL7WR0VSZxR3hSmSV+ZjdWU5azGeY6tGOaenF
         buUbqAKMvVTPTpP//XjxN93dv9q9XR++OcjqGc7blk2gV2aBSLgh/I13CdAmExOVuTuE
         pswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864251; x=1774469051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XKEn0eNu+Wls6kueeJsU2hAaS0QRR2i3TclFtAuyFDs=;
        b=AjET/HUbMYg1hzCJx7ZGRFeepeDfsLYCfuk0nWqNgwFS/mBH7OMz9pyXn/vMJmoqm2
         OYS8pldBH1CZxWcvziXzAWCnYEkuj8kkwnqydiV/7JVTbK7qDlxCfQHkxGqPskJdCAq4
         Ni89PGaoKlUnfvH0upsc/fToHv0vZ9hWuRlL/Ilbso72dRAAHLPmZPJbngA9msuETxef
         jIALHhH/3k2WMsT0KMXMUg+S5w/VSAN+8ZEVeiUNLRH4La3w/eI64JVOLpklGCNMrJTf
         Yz1oZVdqDkj8b/fKKlcyJjtxF0xf3ibtPch/eGdJLqYPfI9b4/QL3HpVNk4o6Es8Dy8S
         x/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCUGZDviUYirv0BSriinfHiJPgunN2f6RUL8oHIvo24QkLlbUDg8HHx+n2qvAj3DEg4l3d0hDooL3A==@kvack.org
X-Gm-Message-State: AOJu0YzqLLUl2QHlKBAWxV/uI0cCXx5qGDxcgrTH6zKml2OwMR8NjRd2
	k42j4/HMwuu8aDKLxDeOrmj1sBptlCpuXAqvCAzBdD++4ALwVWqX38oZJPduEYmpEAo=
X-Gm-Gg: ATEYQzy16NMxjqljO3I+1xay12bn85cMqLL978nDE1Uve1JyKS+lD/DKQM1oqzWI4ez
	qe80MuL9OAoHIsG1+zJE0Uqkufx8VAbtBtjcWAnsbtEYL9Z0yrExAtj3r1zUxO2En8LeY87Fz7z
	+urlm9oDORLI5JwS07/eny8NmOVCTiISKfT3ok1XBtH/3ebbri9Kl62+yz8kxXjBFCG7UO+zyjf
	ED9Qin4MT1eQWV2uBZmvgXjF0970NqT8OWUwEdbaIAVMymQyjkMi3hX691GjMEtc+/0ztYaIQFN
	jvwkapM3Iddbs3m3efMk+s8z3KGt3l2swczVYoJ+HUQbBdeEWxOFNqHucaZo8FQ9pMN9xWXjPce
	hTN3w56APKKCdMugxUPV1Yb1KUPM1xOd+NenxkXX25+9TNURibtt8jyvZQiHGRB/JBD0UZxw5yM
	zGwY0hQXI4u9C5qGVqeBwyuA==
X-Received: by 2002:ad4:4ee8:0:b0:899:ea9e:31c4 with SMTP id 6a1803df08f44-89c6b5c828emr66247796d6.51.1773864251348;
        Wed, 18 Mar 2026 13:04:11 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9cea7bsm33041426d6.27.2026.03.18.13.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:04:10 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/7] mm: list_lru: introduce folio_memcg_list_lru_alloc()
Date: Wed, 18 Mar 2026 15:53:24 -0400
Message-ID: <20260318200352.1039011-7-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s4gi718tgn53fcxsqs8wiq9fh7zsoxug
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 59B1340009
X-HE-Tag: 1773864252-510730
X-HE-Meta: U2FsdGVkX1/GM8BCKZ79rLERxsjx4ojJhhZTj3hIv4CPzIehysQBJy93ZhwfCEvkeklW+hQynpC3dTdeJYNUMNa3XGk88sBoNC7RLs5DPjl51IcD6UIKpLfmoVk7GqAuDJ5PK7SvEjZURjhYFFJfJ+CVb3C3OKWZkMNeLNl9+xLcHuwNId77Uf9MuLWtDGMUjZZ8MeiRaM1VQ48dj8IRGNM4HXE3aoOlBmG1M/IF9sWAI9I5leqAJvWdy9BaUbP6dwFPl6CNNdKCsTC9LDRKEiM0nUXICB7Jlnag0AJzkdHTXMgl7RITC2Pad9OVoGlf47V37lSmKae8rKSgW8QayayrZDzDFhCKT6ShApL3bCXRL83Xvi/LGU6Zp+8bPblmKJ3DTWBmSMoam8tR6PvQpbI92vQQzOFFiJiCXEWc4Sxkz4RRHNUe1UGd6W8BhKvz1rfFNw4YHGVU2u+VyDbL4uoKEV7a5T4ODUfnchWDT4W/pLcn9M5Hay6saQzmOYToPYu0hSFD0IjZhjsX9iDqaJPDn3w+DooBURHcV9TzMmMdbyAA2e26f004zhVX1zT44cNmOM83NW8HmJsbXfK5/ezj89SC4UOu5N0wqHapmBduIIGe7Ua/Shy85NmgaN3nlfFrm86gleETZHFkBStMZOqAgs/QqEHX0AgTVWdQp8h0xa2FipnmsrtxTYrwAwW1n3gpcyoeky6aTgJWajh62M0vusQ2tUXbF0Z6DAgpt4kpQKAjiziB0mqiRTXntrKoaKA/agweLrYg5kIqAAK+H/bxUC8Or4Hy69/P8IXuWixPYhuXyDaZ/wIzCcap4we6sz18VZnMs7lPU/NsqfrGi5YdyjmgMawNbahEtQvXrWuocNL4UL2ZV6ASjZ/2EQxqWdmo++hrJGkbwwSvFazzj4Bv06HFCX3m2kdkPRaM679ndl5/pCk46jIjU5YjD6B+jC0lQIeKB1iM1UIjMVc
 gXk6Pcry
 rov0phsS4tQZS7Xm7kCZeI/O19gaRcjdXdwrnaRdDTbLU+ZAwJkpVJeXNOBwutHqfZbLNg871iBZOm4RSaKo6TUvT2+WV86awd05Ujk4WDrNXT9qbYFu1yxxbpGyNvBPE3QUgBn17z+lCX9/ygSatboKB5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_list_lru_alloc() is called every time an object that may end up
on the list_lru is created. It needs to quickly check if the list_lru
heads for the memcg already exist, and allocate them when they don't.

Doing this with folio objects is tricky: folio_memcg() is not stable
and requires either RCU protection or pinning the cgroup. But it's
desirable to make the existence check lightweight under RCU, and only
pin the memcg when we need to allocate list_lru heads and may block.

In preparation for switching the THP shrinker to list_lru, add a
helper function for allocating list_lru heads coming from a folio.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/list_lru.h | 12 ++++++++++++
 mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 4afc02deb44d..4bd29b61c59a 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -81,6 +81,18 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
+
+#ifdef CONFIG_MEMCG
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp);
+#else
+static inline int folio_memcg_list_lru_alloc(struct folio *folio,
+					     struct list_lru *lru, gfp_t gfp)
+{
+	return 0;
+}
+#endif
+
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 /**
diff --git a/mm/list_lru.c b/mm/list_lru.c
index b817c0f48f73..1ccdd45b1d14 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -537,17 +537,14 @@ static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 	return idx < 0 || xa_load(&lru->xa, idx);
 }
 
-int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
-			 gfp_t gfp)
+static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
+				  struct list_lru *lru, gfp_t gfp)
 {
 	unsigned long flags;
 	struct list_lru_memcg *mlru = NULL;
 	struct mem_cgroup *pos, *parent;
 	XA_STATE(xas, &lru->xa, 0);
 
-	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
-		return 0;
-
 	gfp &= GFP_RECLAIM_MASK;
 	/*
 	 * Because the list_lru can be reparented to the parent cgroup's
@@ -588,6 +585,38 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 
 	return xas_error(&xas);
 }
+
+int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
+			 gfp_t gfp)
+{
+	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
+		return 0;
+	return __memcg_list_lru_alloc(memcg, lru, gfp);
+}
+
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp)
+{
+	struct mem_cgroup *memcg;
+	int res;
+
+	if (!list_lru_memcg_aware(lru))
+		return 0;
+
+	/* Fast path when list_lru heads already exist */
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	res = memcg_list_lru_allocated(memcg, lru);
+	rcu_read_unlock();
+	if (likely(res))
+		return 0;
+
+	/* Allocation may block, pin the memcg */
+	memcg = get_mem_cgroup_from_folio(folio);
+	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	mem_cgroup_put(memcg);
+	return res;
+}
 #else
 static inline void memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
-- 
2.53.0


