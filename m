Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB67606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fmt0A69s
Received: by kanga.kvack.org (Postfix)
	id 3DE3C6B09FF; Thu, 22 Oct 2026 18:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BC36B0A00; Thu, 22 Oct 2026 18:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E606B0A01; Thu, 22 Oct 2026 18:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E897E6B09FF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:40:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7902F1C22CB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:40:00 +0000 (UTC)
X-FDA: 85351731360.23.781DC06
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3418A0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:39:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fmt0A69s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792708798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rv4DFzQPHD9Cms8Ln5ojDdkO6t1/sYTvfN0XHmaC5ec=;
	b=eMZvr0yCeWQlUfOx35/bRL9AmNLqDumjt0TrcopZPKEzWaoVBMaIQuyyHZXLss2Uheu7w+
	6dvD65yb511c7MDsIfM2MFFAY6knur1EDj8EXLjwykPZIuZGKB+O7Fzgya2Pk3ZWKSjb0b
	LM2a7Jy1k6OBd3Ul+CQl7Vlg6q2p2BQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fmt0A69s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792708798;
	b=Z1RQoBPgjHg52rQiYmzQAbbOKbzzlb8/jGM/yveKHlkTDdykkDhVtlYruwmwNoVD6S3HgA
	a4z5/0V4dtxeVZiikxHXLZL4ebA3dbxSEuKxRjzy7aQ+rb6yloG8Zi6SoSliav+7gEjwjv
	is9ijgjW4RSnC3IoSF/8CslsICjuNLs=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6798af41644so256493d50.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792708798; x=1793313598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rv4DFzQPHD9Cms8Ln5ojDdkO6t1/sYTvfN0XHmaC5ec=;
        b=fmt0A69sCBfAuWqoiccQCZwK6wOAWQpPKLuQieFMCN1ip6jx3Rc2tJbbhnaTBMeNuy
         /dFgGekx+2c2HIFxCTZlMrBF05vTuIpvD+FhbQDeMpgA4d9Tab2QlasiecBMwCDycjfw
         yWaenVd7sr/kU6t7LrV2RqpD37qQcD81WJMESS2bi3IRGXzYlzbHs5Q0qDgfkV4ZrhCU
         xNZwqHs0N1AkoERLFV0NondOFSqXb8dmdv0jjcaLpvPxX6rOKSp65jjUzmvg+uhaHc1b
         zxf+hYlHI9c2Ap/bgjZLB1yNvwbD9e0763inxjZCOEzTBlZpaH8BdpJ3ih6lpvblJ+Tv
         AaPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792708798; x=1793313598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rv4DFzQPHD9Cms8Ln5ojDdkO6t1/sYTvfN0XHmaC5ec=;
        b=KINgxDWOWEvFgCFC+wTlLq7w2POJZSJQSTgzcw25H4zA8YBouAiFlPFhEff5kqfRBB
         bsoDqLYjbmJxlaKt94mEDBpwcruP6TRg5gIKqJOlpmQSo7a76EocLmskau7tFEIKgmos
         aHHggLakzq+w4IyBePswpokgkOEmR72z9ocB0FksHozqORGC/eHskKYJfhoSXzSY/yEw
         RI4Z7xv3Afc8o/Cd/Y7/uhv059RguTqZLrPD3pBNwXvsDWWda/g17cRFRDNgSb+RTP1K
         tvCwVcVxAgV1Ht0eXuLAKHVonaA4F4Eb3DiihSMJlh2Um2Ji1eRHW7NfL352xav0TGLG
         DrnQ==
X-Forwarded-Encrypted: i=1; AKwUvByuajucc5sawBBF6kq2NanVBB1BsFiB1cSkAbTBmuBggSf+Xbt92reXK/qJ6q6xsRUnO3SVpEgFYg==@kvack.org
X-Gm-Message-State: AFq9FYLjn+3FtZQBwXlI24nDm4ywhkP6HhIAqIliaJ7+SVHOumrcspii
	K9PpeUqK8puHVJ9ZydNB8dJbFfLBq+OfkXxkOYE7hn0Tb8I5jKEjI2YL
X-Gm-Gg: AYBFou3IvnD958EvTKHwAIoUhZG4uxSNCRZG0t2Vq/ido/8nfv4DXd3SVEt1AgTUwh0
	9eIL64Bd8JcMJhXjNgtuHBLntmm4b+9C6Obq7UEsGU7Y5IzgbBIr0y45Q3TgvimSxru64dktnAQ
	1Bivl8wCCtTIbcznE9YPbsH8vPCKm14OHYmMrFmMkE3BZ2N7H5KbYr4Y8DoBfOXVD+DMxS3lJj3
	CixCH29aJ1qyUBBpmF7rx4wHi1qSCxBmIFrkmiKXhNPMQOz5Xj/TvQD5wsuJD3jkr8glRcZyTk5
	qqNzlNxLd9mHBRoSv5+FwDFpMdl2x+ANLel1EKn3cCLArD7ZYXO7meCpbG/EajRuhWrnokVH8aA
	vrodvEX9mcq+MpKMbhdQVfUzcq0I90idyvRzhXZYZhTgDlOs0pgb+hGt11385EomeF/qB4zSi9L
	fgg1QAGh7B7l5j2Oi75M6IdLQjy80J05vJUJ0byjvlF1PcO1aKkejEAR9EfCYdrjEMUouENvfuH
	GATtABYal0t2lGStnrocErCPPYh3KyFqIS2gRAuFn2Z7kC2x8mC0C8xD4gEZEIrYEG6btVt/Or4
	Umxj2qxKIUQ5B+QPmfx7RN40cYniKk/1
X-Received: by 2002:a05:690e:138c:b0:679:2ca6:e702 with SMTP id 956f58d0204a3-67a35c0d86emr297112d50.89.1792708797649;
        Thu, 22 Oct 2026 15:39:57 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:58::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a340745cdsm419859d50.23.2026.10.22.15.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:39:57 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] memcg: don't go through the lruvec for folio and kmem lruvec stat updates
Date: Thu, 22 Oct 2026 15:39:30 -0700
Message-ID: <20261022223930.138779-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261022223930.138779-1-joannelkoong@gmail.com>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3418A0007
X-Rspam-User: 
X-Stat-Signature: bf41taxunmm3c1jwixrw7nq3ew5dxzw4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792708798-144841
X-HE-Meta: U2FsdGVkX1/yCYRUF3+wgOO0feDPsufOhBDaVuL2e5YEozfFV4PuVC7ojwBuurW4b4aKMsr9yvVhNjNIMbDaoWKf8V9+6KGe1s0rqxR6lxZh4X1p/RYVvPr9pSA9S2crIv9YY10seX9Dkdsb2GCAvRFTwJcp8JcU+0tiIWR3si1ykPvKPq+NLfnXTL8O2G1ug7nvTS9Li5C89Ld32/Omi6CyqIGrcWIPXx8NOn6TXsxlVvcOTNOdafxEqBRK/XwLyT0yq61BzeK9vyGl9AGJMtAePSuEjZBBSyGrAPTUtt6N3aRIrTgYiYWTvsciIeb++Uas/4hxAPtfBW4DMDRsy8F/OH64QJkeDZEO3dgLjtod9hddo/UauXxb+l8DoJ6gttiqhjRaDaGskfKplGo/2+tFKUUJng9qELC5gdFHTD6j8r+JElHicf9eGOoo22lRSdtkxmMdAd+T6WXOSjQKiCC0U4x0UgTjkG5Y+WpR8Q1EGAdrQinCPm4T9SM6JPOT+pqHRsTHTdMZi4Ery0dY6pgfefXvIJhsLU2DPYtQcKPPUjvFWfrU5YKOB8YMO4qXrCCMKFWdw+AJ4JpyqLtBOrDdaruIIT+ZvT+Olt0qUy32M1eyckBS18ZMAkoG17iHKFaFlJuA8S0ae1Lb6PuBtzJEkvNtScdDQdLkgQpTB46Aqkq6HYaQeVQywXGCiRZGnyfMjn1apbkfdnihmK1INr2KiUgXUuMYTGQKDtzCNaHYQT+8k6g96wQNWsY+k8Dp2zlaHdIXqDQukoPS3n7uLOu/FyUkf2mWH9aRT+ZJZMqiXYU6ke24jYgy87SoXJTnJ5khuWUcNyVG0qSDENQ436WJ2j930hXJ+lngDrFV0g1F03clJip4f0JZzTWGQTzRu2yB5mmtCtFMa7umhsX7tO7FzVtbq3DXZXx+qO3yzqVJnGGJVMh3Db8HTg6YEfSD+DlGNT27T0Y+THl+xII
 tMk4KwEz
 yIMIoi6DvgsIUZcFt7noeWNJvBdR6CqPWHSlj6J/Dn3TQtorD2XeHsqlojPx/lPFDn+NNwRFWl7MxPU4kYS4DIc2eFWtA7StPQ6WPpVLg+dv8znydtM34RRqcVsZd746Q8LnCfy6XRQUDgo9qV+VhHHnR2Nfgg2U6Eqn/Wa6USRH6GmpVzIDeONNvvRxsvgUFhTxazlRx57s+1Hm3bP02v8aZcl8PNN3G+qxtaSwXFkKhSuZILST+3ZX5l6PXv3WmBhtJd9W2KLuZjqgfZifJ/RmbzJ3x0Vnl2ph6vDB4jXZFY3bFDjd1bKjkKAMkQB5O4fwECIQDRxY2+rXwNR6b3R1cqzOmvDM8bVEIexSSTH+vs+MQy4hTvXULoJO+n4apwibs452+lInMk5RiFYP99PqX8KkxO2j8NcMOvVOm2H+ztTuckx+/4TIrpVvBJrxNKXmda/fuPpVRz7ooSf/2RywQeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

lruvec_stat_mod_folio() and mod_lruvec_kmem_state() already know the memcg
and the node, but look up the lruvec with mem_cgroup_lruvec() and update
the stats through mod_lruvec_state(), which reads lruvec->pgdat and
mem_cgroup_per_node->memcg to get them back. lruvec->pgdat shares a
128-byte cacheline pair with lines that the lru_lock holder writes
constantly (lru_lock or lru_zone_size[], depending on the alignment of
struct mem_cgroup_per_node), so on CPUs that do spatial prefetching
these per-folio stat updates contend with the lru_lock holder.

Pass the memcg and node they already know to mod_memcg_node_state()
instead.

On top of the mem_cgroup_per_node rearrangement, on a 2-socket Skylake
(80 CPUs) with threads faulting in and freeing shmem in a single memcg,
this improves throughput by about 3% at 20 threads (5.59M -> 5.77M
pages/sec) and 2% at 80 threads (8.66M -> 8.82M).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 71 ++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 42 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..9f33cc5c8293 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,7 +587,7 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return x;
 }
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
@@ -596,16 +596,11 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 	int nid;
 
 	for_each_node(nid) {
-		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
-		struct mem_cgroup_per_node *child_pn, *parent_pn;
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		unsigned long value = lruvec_page_state_local(lruvec, idx);
 
-		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
-		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
-
-		__mod_memcg_lruvec_state(child_pn, idx, -value);
-		__mod_memcg_lruvec_state(parent_pn, idx, value);
+		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
+		__mod_memcg_lruvec_state(parent, nid, idx, value);
 	}
 }
 
@@ -990,10 +985,10 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
 }
 #endif
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val)
 {
-	struct mem_cgroup *memcg = pn->memcg;
+	struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 	int i = memcg_stats_index(idx);
 	int cpu;
 
@@ -1015,21 +1010,23 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
+static void mod_memcg_node_state(struct mem_cgroup *memcg, int nid,
+				 enum node_stat_item idx, int val)
+{
+	bool rcu_locked = false;
+
+	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
+	__mod_memcg_lruvec_state(memcg, nid, idx, val);
+	get_non_dying_memcg_end(rcu_locked);
+}
+
 void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val)
 {
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
-	bool rcu_locked = false;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
-	pn = memcg->nodeinfo[pgdat->node_id];
-
-	__mod_memcg_lruvec_state(pn, idx, val);
-
-	get_non_dying_memcg_end(rcu_locked);
+	mod_memcg_node_state(pn->memcg, lruvec_pgdat(lruvec)->node_id, idx, val);
 }
 
 /**
@@ -1058,19 +1055,13 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 {
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg) {
-		rcu_read_unlock();
-		mod_node_page_state(pgdat, idx, val);
-		return;
-	}
-
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_lruvec_state(lruvec, idx, val);
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
@@ -1079,23 +1070,19 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_virt(p);
 
 	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
-	 * when we free the slab object, we need to update the per-memcg
-	 * vmstats to keep it correct for the root memcg.
+	 * If we reparent the slab objects to the root memcg, when we free the
+	 * slab object, we need to update the per-memcg vmstats to keep it
+	 * correct for the root memcg.
 	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 
-- 
2.52.0


