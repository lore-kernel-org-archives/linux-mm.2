Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76954C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 20:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AB16B009D; Mon,  6 Jul 2026 16:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC1C6B009E; Mon,  6 Jul 2026 16:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5D96B009F; Mon,  6 Jul 2026 16:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF1D56B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:45:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CAA3A01FC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:45:11 +0000 (UTC)
X-FDA: 84959531622.03.805BEF2
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id B031E140014
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:45:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YF/WVVlf";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783370709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XVLOymukG8mEHjr57PGE+70BcqfkinJsntMYx+ElCgI=;
	b=2uhmwfKQYq59zX2B40uEo+4hz65vXK8rvvCE7WsAL8DP10Sl0gKLCOGBINk2Rxv/3o9i1r
	uPg3hTp9OE6WTbqiJrBjtdubSe0qQlcbZVPvmmacT59Ql/sCbUloEYB9OWCPfOq33Efdxm
	l4BY4Q3OMr+cFjIIiWn/DC6hDhgafls=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YF/WVVlf";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783370709;
	b=cZKkjrL6N9MZAxJJKWNsaI1geYYg+VHXbQAP+23spDM9hS3DKWa6CKv4s2+2n/TFbKTNEl
	HX7QjkRbWHwcMwWIlM+r/7FScJWte96fJ9IDspxWGbuWzWBNNKxNw0XrN5GHk3EQCMvw87
	EUzWNNUgy3yZq5+27w+aFbGmIUG/13E=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e9ecd7216cso1480422a34.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 13:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783370709; x=1783975509; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XVLOymukG8mEHjr57PGE+70BcqfkinJsntMYx+ElCgI=;
        b=YF/WVVlfJ5YSeWn1t3FDiRUNehDEgzUcp67WRaYxadhJxp/v6IoZpOXaDLYzg/JIy1
         SmKVBzbrEqVvSoDpuTi34e3t4GNij5AubjfcA5KpD4Ry3QtwoHiyJVpscxp+iKw7oxqj
         ZFFtYQ60LN8ne3yS6H53N92aa9Sa/qkJGzD6+a4YE1ch1ExeIYcraBAQQIW3NRpEdmeH
         Tv4lU5S92x9efTwizStWHfvTR5s1M+g2mVtc+boj6hRTAP3lROLkOrg5yBeK2kdpCbq1
         azLa1eyZGw2/u5DwnSsZD8ntj3UPjyORlhg/g85kWl9JMCdxYsof0AlWTTCO0Eruev5s
         w44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783370709; x=1783975509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XVLOymukG8mEHjr57PGE+70BcqfkinJsntMYx+ElCgI=;
        b=VURnkCDb26LhzElgQfulItaVvuQqrb934UHGTJEPTVvlnz5OqQVF9mW6imp8y1RR6i
         acnsOlAcCQ4iS1IX7Lji7i5cz+Zmgh6Ly+esBpkkxMubyFdkXpyrupM+wTYHbyMEd4YB
         e7oYpS2J9ubqvAhPQ80++8LqoKPUH/csAr8LGQFP24BDlbqj9zWGvjCyBJRUtwgMozdv
         WCebCkoy/CP6HWRGXlXFILERITzp1/d1GxDS1V8v4Osq2xMH/CKcvhZ5MANoi2YL4fWl
         3dsQd39GjvSYdjUgFegvQLwXhRdOdRtRHvhcWxENpL4KwEE7+reBS5RoHBotpOhusXGz
         zt/Q==
X-Gm-Message-State: AOJu0Yx6apYjdNcEd8DuMZtkDv6FtOoka1p+68Zoe6f/LYMzufdFlM9I
	erm3jsQsuOMi03wg14DowF0Wci5JIqXAMNclRiEyJQnEKH7a67GZXJHhlP0XjA==
X-Gm-Gg: AfdE7ckRMId2ov3R3tCwrBx6/0FcqyPKyQWkEFzsS7cxCB00Pvl/N2AXn92OC5um3R3
	FLw2KHcrzoqrWp2qKGEcSk29KvU7KncJGAw2t3jvy25AgurHmQ8xGXm+jYIUfoz04Omx6Gli5b4
	a/55ZAw7exAI4jPaImt8KjP7hS5ARd4JpugyxWelHb72wRFEkkFbkg0yK9GUi/Guak4Dc/JkyZy
	oQ73HW6xtdUJ596jIXfQq+LH78V7BTuyVz9kxQnbN4Z2lTpTX2Fz4RlpnaGX0UXqS1WCR3QAWIC
	tiUW8METpzp9J5Pz8mNiCBm+ELGqhSJCbNhDwtbd0RvmT92IMfzRiHHn7KLApBD2xt306OgFfYv
	OwkTxMs44CRYcxXITV/7tZExdYz2awXxkoU8A0wcvb4gmwGgcabE2GzwjdvjZ2OtVKz8ZFd8oib
	6fZ8bC/z2W3GFpmeXe7kKwSAjxRcVSRbUjzi20nb1ZOXw=
X-Received: by 2002:a05:6830:7307:b0:7d7:e142:2ead with SMTP id 46e09a7af769-7ebb232166bmr1568070a34.20.1783370708494;
        Mon, 06 Jul 2026 13:45:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb8998850fsm5937937a34.11.2026.07.06.13.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 13:45:08 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/memory-tiers: cache top tier nodes
Date: Mon,  6 Jul 2026 13:45:06 -0700
Message-ID: <20260706204507.98522-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B031E140014
X-Stat-Signature: xfccjoak5jquk7mh55qn6xgbfirbjboo
X-HE-Tag: 1783370709-607079
X-HE-Meta: U2FsdGVkX1++lsGrRtrdB8iZtHyegBXxvm8FLgEzBHeP1O8IfsdWDazLYsyIuNs1pVxQS/orMjKE3Pm/7dIeV6XI3TcC2IK4+j9TzVSSLCWP7cTHJEyxktRegzk7Bamq3Hfq66YoBkIb4YQxpXjH7VMO3GAJ9dVnDgsvwyWkiFrzbuvjX90iw9Byib/Trc+9uZW91my9KqkLhcGYpYTeqd2Rgiz4y5zeh2lCRPTL9XNjIZqs45eQ1ADlWacpQ6kDF+Ty3K9CKhHX082XcTiGgb0HkaXeCBsuoXKMUp0x6bzLy/jsQEZWwahkATX6Znt6zjGlju1teTYmbi679Nk++elWLLDkdn9GgaO1woymCPqMjBQhiFF39gFFipshiErOZRiNcXDvwBabqzn5nXqL8gkAr/1vRr8l6PHwyw6FEXUX7lpTXuo2tjqLNEsGpaapkRBh5pGQSIglWOre0x7n6LmNOZU/3YTbLAijr93pAh4apBLnPd1em2CyAmS7AnpmkoVUyXMiKXP5Q+gJpz8bX67SqO+xk6gqtpUjVhqB/XwSoyhy0Byw+twUt7MCBT07snJF3DhSL67i2DH6QkATGChenSs6GoEF9OmyhedcSl6DimOYxAqUSrhs76UbcJdWk+ZA5WDFR0M73ejUev4QmnGIxZVa+13NC6G5ljG0or4x+2SLHPOTOVutIGA+l2Fqibr8iYPUpmfTKUigE+9GZcdmyxvZEK0qWc2+6TWfYs17X5LiWmdt3OgsZhkm3Nt+A5V4SUaK8XT5hqO8jyqPtqxHCOpiorovSMh8fvDW+UmOu7ntkHbVQnU58C0bbsdqu8zser8/BLv05/XDTGMO4m6SrMwMaLhyPjrglZrBBEIUuJRokbJ7sBTPxH4kobTRh6n1VdUzK+IHJYDuWQH2SDA8dyi6A5okuiuzTUBPgNgZ/Uza3gobBXNTCR1zrgjHg/Xr2Q0T5EqWTF2e/3Z
 /BM2loSy
 SeDugSG05THZQAhsJKkGpFdyWPFp1i77HcJsgeFUNGb4y5KWMewoj98oJabV6gu3TKZn3WM2nOmEdrcsyJVzCY7y3usOF5I/19aYrTQq4mC1q7XfiOzpSnPUt374Hz80o5QDj8pMKykUE6HjlxtCkVwrYYeEO4KxCezKA/zYPOTM7ESbfEgBUrlelR0opJ+2FpRlHyi4o5wlHggxe2ptcAHBVleOvOM/pbwDjew7wqIb7toxHGO29p1U5xgKMR76GVEiiaHLm362tGtMPZKFgpMPLLUMJVTFHC+kM0cNI2Nv7zx/9kR/MxtCGjOBLvBHz+S99G1dRqXrmY12kxDYHeLFoGsKEJdCuEPexokQlAHFOTUuOh686Mh8or0gwtovW8A3Fi+fAJssoEpc5bY/RZ/0mgnyENfO9jy5qxyo08w912YZPTVxt8pPdWYjrudmARTbPTfzVmYqEuLFmPS5isb8BAdb3UTvWM3ziQ9M05O2vDBzJZbJR58iEml6wcAKQ8aIl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

node_is_toptier() is called in a few hot paths: task_numa_fault(),
should_numa_migrate_memory(), folio_migrate_flags(), etc. Each call
takes an RCU read section and performs the tier distance check again.

Tieredness for all nodes only changes on memory node hotplugs. Instead
of recomputing toptier nodes inside each of the hot paths above, compute
it only on memory node hotplug events and cache the results.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memory-tiers.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b0..2e6e02ec1fce4 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -71,6 +71,7 @@ bool folio_use_access_time(struct folio *folio)
 
 #ifdef CONFIG_NUMA_MIGRATION
 static int top_tier_adistance;
+static nodemask_t toptier_nodes __read_mostly = NODE_MASK_ALL;
 /*
  * node_demotion[] examples:
  *
@@ -276,27 +277,7 @@ static struct memory_tier *__node_get_memory_tier(int node)
 #ifdef CONFIG_NUMA_MIGRATION
 bool node_is_toptier(int node)
 {
-	bool toptier;
-	pg_data_t *pgdat;
-	struct memory_tier *memtier;
-
-	pgdat = NODE_DATA(node);
-	if (!pgdat)
-		return false;
-
-	rcu_read_lock();
-	memtier = rcu_dereference(pgdat->memtier);
-	if (!memtier) {
-		toptier = true;
-		goto out;
-	}
-	if (memtier->adistance_start <= top_tier_adistance)
-		toptier = true;
-	else
-		toptier = false;
-out:
-	rcu_read_unlock();
-	return toptier;
+	return node_isset(node, toptier_nodes);
 }
 
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
@@ -497,19 +478,22 @@ static void establish_demotion_targets(void)
 		}
 	}
 	/*
-	 * Now build the lower_tier mask for each node collecting node mask from
-	 * all memory tier below it. This allows us to fallback demotion page
-	 * allocation to a set of nodes that is closer the above selected
-	 * preferred node.
+	 * A node stays toptier unless it belongs to a tier below
+	 * top_tier_adistance, while each tier's lower_tier_mask collects the
+	 * nodes of every tier below it so demotion page allocation can fall
+	 * back to nodes closer to the selected preferred node.
 	 */
+	toptier_nodes = node_states[N_MEMORY];
 	lower_tier = node_states[N_MEMORY];
 	list_for_each_entry(memtier, &memory_tiers, list) {
+		tier_nodes = get_memtier_nodemask(memtier);
+		if (memtier->adistance_start > top_tier_adistance)
+			nodes_andnot(toptier_nodes, toptier_nodes, tier_nodes);
 		/*
 		 * Keep removing current tier from lower_tier nodes,
 		 * This will remove all nodes in current and above
 		 * memory tier from the lower_tier mask.
 		 */
-		tier_nodes = get_memtier_nodemask(memtier);
 		nodes_andnot(lower_tier, lower_tier, tier_nodes);
 		memtier->lower_tier_mask = lower_tier;
 	}
-- 
2.53.0-Meta


