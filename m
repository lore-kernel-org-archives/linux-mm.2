Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC287606A330
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WnA9bELu
Received: by kanga.kvack.org (Postfix)
	id 821936B0BE0; Fri, 23 Oct 2026 15:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783B26B0BE2; Fri, 23 Oct 2026 15:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627606B0BE3; Fri, 23 Oct 2026 15:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C92A6B0BE0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:54:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCF5540210
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:54:51 +0000 (UTC)
X-FDA: 85354943982.20.A39DB79
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id E9EEB140007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:54:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WnA9bELu;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785289;
	b=mvDOavciu07XiGr9ProGCITuQw+6lwhkh6OW9rBcPDkihTsIbcfQclhj0VFQZCOIbvU3kL
	xpqgPqlekBrKXKYx2rNw1BH0yYZeMBtXaCUkgpAVVR1MwbCt9t/MuyGnpVcTB3oHx3kkEW
	6jz/E8FZZhUtbb6sq+BC4h8Fpc6VBQQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WnA9bELu;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyKibSqm1+8ho4Nz7jrRZ3yeDtEDcgPdxxTeTW5ThPU=;
	b=3c2wVnF3k22ZvM8ot7O8Zqmp2VNr4IvqqBLpeGgqVljDF+g/JdUnXsFUUnDHlRO0w4iOs5
	/Yl9bycioTTYJJq2q/wt9AWlg5QSCxBcLIP2y+QchLayFFBnSmod7Rp03fc6x7Hp2arF7z
	xv5hmNmhPJPUnaKAFRINs1ILVAG4qsA=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6798c43a3d6so1009333d50.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792785289; x=1793390089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oyKibSqm1+8ho4Nz7jrRZ3yeDtEDcgPdxxTeTW5ThPU=;
        b=WnA9bELuDs5N1jxmMRK7FyaGKwrF9I6QWbBFhIepjh+sftWUKeDg09npXH5c4viefZ
         yCNRcwnTJQNw7PNxay1pWz2RE3AiBg+pc3A+nJ08qyoNu2eF51+dmKij/BpMivgsNMd6
         JFJx0iWGSBkB72Bg6oJ3kD5bmw0XXybcq5R71DPZhQahKkZT2XfY4qzZ4zDm93SIgfej
         YnGI7+PLeE52Ys8irDHsq4o+4RH5xHdDQEG4oizieoGjf1VVdUAmmJmGv1xLgGDmjlrJ
         00G8WsdviW8oz7xagQgHT5jAZvu6plz4mjxw1kRmSvVrCAcRA1CpvIqjoa6OZwAyOJZp
         4mKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785289; x=1793390089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oyKibSqm1+8ho4Nz7jrRZ3yeDtEDcgPdxxTeTW5ThPU=;
        b=MIPSyQ/0oCj9vz1bUNSGOS3Mzw5qdR2435CCd+YLYQ4uZQpvAxNUEKgeiQB7542lNu
         1pzZ8775SoNxrPty4cy1Sd/wlIYlxtiWBBbZ5dlgqO1md0qgZpYqfwTe1WIn8nUyJUvk
         e80EttYThWV7qOF9ONnvu8rPIKloAfxUfGWPSQo+8cfouTdLKFQVZGw6yMvHFYdyY7Dz
         tdbL9t0rCkWxrFa3EbNyo+yoacp666QMHCh0jBdL7Y0gMtD+Pf9iCyftMpemOi3LOHK0
         tW3m+qlISfFHpy/+4Nn6oXfbJ5vE9yu7SkcPPELBjQ3hqdDeTgjT9Pt67IIDXai9x07F
         3PgQ==
X-Forwarded-Encrypted: i=1; AKwUvByHfCWuzbFRPs4qKkzb6dpdTkx/M3EhN7uIJMf2W5DrAfnKZi7rTZDrEpJnJj7QuVToxVGE7WVlsg==@kvack.org
X-Gm-Message-State: AFq9FYJzgbmsuqUmHVM3EH/ix0ntKhAVI/Xz++k4s9UJs9UuIO+Rez4G
	ssulK1EqabY2vY7CIruHsUStD11ftfer+y+cyIf1OAP+IXbxjSbCj6Y9
X-Gm-Gg: AYBFou26/SZkxRvLNjNI3Pnh/GSNC+kg475ccaTondYVZI7irxs6xEZg8dh2kCqPFNQ
	M69GVrjNmNQi+E7kY0+Tsx/oyniVicHw0WPlC18aqtRBy/2Cwq9tTjuskD3g6cjwJksph6Xq9bI
	yNrwA7ZSrgN3j3YgRyUhtxzHlQL/U9Z0mJDeFCuDmbMp3NPozPGGnlyTL0niWCQcWk+ov/5Y5t6
	r+7/lrBu3+K+96rtx4AShECcXNwWwIrxK1OLVR/92WFbf7Ojey9nHGSfZi4UYvf4kkO2dS9Xsrq
	2nS1cLj3XqiCYZxv1pixdNS5POXbBGTVIVKBcgRXgZH44UviaJiz2pvksJIwGMDv18fsrNXo89M
	E3OBn1TOWp+ODo1BokZSeS+RIBtQZXGXw7BTl5muVHW++JcacU7fFLzQNmCNb/9mWmtV5bPjbpC
	9spGdAAYmJccNwFZMzpP/mt92sLKEdZUNdpyHG3+dv3S9jsxi2pcAh+EpyVjbTxSsajMbZb6S7R
	hyKBiSMis/tvBUmXsztuNklWsx83h4wT9LCLggTr7WncKCl93cYWEARoMiaF+/Ewyiwh42vthgs
	ayy2S++QBeUCEJuddvdoNRG23EQvYO6r
X-Received: by 2002:a05:690e:4553:20b0:677:a7ac:5624 with SMTP id 956f58d0204a3-67a45493fecmr69048d50.44.1792785288872;
        Fri, 23 Oct 2026 12:54:48 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:47::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a4626fb03sm9649d50.17.2026.10.23.12.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:54:48 -0700 (PDT)
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
Subject: [PATCH v3 2/2] memcg: don't go through the lruvec for folio and kmem lruvec stat updates
Date: Fri, 23 Oct 2026 12:54:17 -0700
Message-ID: <20261023195417.1391216-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261023195417.1391216-1-joannelkoong@gmail.com>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E9EEB140007
X-Stat-Signature: adbsu4zbiy6hckid34pue1yqmkj5xg34
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792785289-245733
X-HE-Meta: U2FsdGVkX19t59LsWamIxnLpTjdbE4XBAkxHGiMGoYhsoltuF2PX9XBwTYN4wp8BMFLEi0AFFnfh1pkSydX9ehjuzLHw35NGY3OUH5caCtji8AFXzy2e50EHY5FfsTXzRmcNaYnF8DqA6I89I0sxZjhSyp92e9VkcbA0E9E/zYKOdnD7GOckDugqsLHM7Ge8O65b99R4pfwCOfyiasY9FYmsLiYPtay3JE8lgKgRUMRlmYQEFDp5HLVn/a/jWqCUJD6IhFpVywkdwikJ1N9vGIP9nlxebwerkeRnAnDi/3LxsjA9NHcbZ9TYchUcdRTxapFRz+Tv/Lu41gLH5AJquFZRuwkxCNlQ/vCkAOLGk4x5KThl2JeEpV50laolaLcGOQiC5dcfff37X0GByB0pshHQKC20vh1JlN7PHc0ANgPEz0ppzG5Ul9mHpJChKIEhjsKzT9f0U8E2+tSm7/w2C6Mz+WNbJky7ssZl44dm31oC93wD7nTOwFSvvb+/ssph+zjKfDH11O2/omvvvTd4V0k8v+iWsDOEY3ISaHUO8EtF8eMACaQy2ePM4w1RkMApZ2wE8cEpMnri9mJblT1XW1HWeKxICoYNM0z39+i5sr0WbgFS4itGuBpF5akvbu/NGF2KD0bCPUEQN/n8Nb266hSU+0O+9e8EB+N+uHkY959JNt8nUdT1vV9AQC9OmiYLmuCLspQZCU0ntEQODs/nfCxloCbjwqdlb/h/7T3Bu9YzuHwR2ejzsEIcIPg7GPw/ztwu2UtBvMNfH/Wb3IIuVEuxxde4+XYpobETzj2KXjeoJgTj1yHB6B7l3SgLH+JYgABh0Cqf2T2kMnh4Hocy3zgrw4o7QbtScw/8p7v+xgaOlVVWN1y0zfDrw2bk6ZbBC2ECHnSoJhBqBwKih9Y52g2NB/chzJJKXsYdRLgWrmkKxrPBXTB4yDjZfRaSNCtRU9ZARsjy8TaLPtHKoHP
 hryo2e2o
 TFVdYo2KVSjWEeFWuEuVN9Q3cvIK2Xq00zVSSNxSdPLCN2LanX2eLDKUMnrXRVachkPx91FPK16AH/HZHJWQkqLAoqWzX1Ibq8Y9ezWFuDnbPREiIJgGwAlhbSfWgU1xgUgaMILH41QWwoocCxgxXUki1f6VdzkPFIgeuFCip94n4Eq+hIptkm8gIMmUjgrt69i34ijA/9OLTt8561E+W2pyO60/wqdJq9h/Nxij21FILwuSoBCScUDT+EDmBQECAydxUT8VSXk8sZggTiqATjpGM/R2kkVbrGJVjUZFKLJaknimQKdLv8uRlvb4z4qK5uqsmLHAYLixCye8/vT2C91pqOIctwnzJ0jRVZCal0y1VILEiJaxjxHsHMde7qyN91v5kKWxN5JSllqpRo+c0H7BLYxrcJ7Nojt8bb+gdGltlJokTf/1IrT82nM/PFrwROWM4CIWkR4oU/ok=
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

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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


