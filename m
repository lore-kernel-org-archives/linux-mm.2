Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25306606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=EH0ZHWjM
Received: by kanga.kvack.org (Postfix)
	id 6585C6B05CA; Sat, 14 Nov 2026 02:10:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629BE6B05CB; Sat, 14 Nov 2026 02:10:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA076B05CC; Sat, 14 Nov 2026 02:10:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27A716B05CA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 817D51A01FF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:43 +0000 (UTC)
X-FDA: 85432851966.26.D7B8713
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD6DBC0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EH0ZHWjM;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640241;
	b=Uh3G34r/ztNQVnnHRWmRmwHicW382jb4m58kA68eXYD1u9x2PLg39B0Zcre/cbxyOdme1t
	oI8yzPOltWZIxXSYT/tuN+8Q1/ML7hAlhC4jLTrj1POhA1gc0KAj1RytEE4R6V4xdC484r
	NLySgZElHpmCS8cfis6cu23fWs9CL1s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EH0ZHWjM;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fkzw1dSkiJcsilY2Mokhk9gjBcrzBYNOsKL3JfHFbP4=;
	b=y6ij1AQprUgjN3uIh773wDvPE4gg+ZyEVGh4eK4rfEroM1Cvh/KcYnKI451hk+8s59qEP+
	ucxw7G4SxYImDPkN5Kmy2xE5T9Eqw/HIOyGeYrOA3ToCykJFyOylxfSLoev374MpkjgzHL
	DV16l46fS6rrY+PpjaPSugKlGCjtFAY=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91f2b826fe9so19624106d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640241; x=1795245041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fkzw1dSkiJcsilY2Mokhk9gjBcrzBYNOsKL3JfHFbP4=;
        b=EH0ZHWjMpf6Fl6O04cJ+upKRtzeM7hmfrsuYiTxPEcviCUBQ/629DDQbKB2wXYw2Es
         Zf90x8lALBIofG7J5dW/ZqiRl8TEAJpSDD/R0LXrPZi5ddLgL0DW1myN9aGtYo73Jqeg
         gMIe1aDpLhh+g3eqUVJADrMgyfFwT2PohybF1N0cAioEnTuCPUsLvYFPb+JOtDwPC3dq
         vGPY8IxJHIO7kD2kGReF3GsI7B0nNdK0Poq8F3Rqim6VtEv5pa4Gugp4vIYdhSjWApyK
         sF9bYa/5rEC7Kp4erW+0znulfXjf3WYc5WSWGrX3nSBJj07HUZQZXO5X5TbwZnNoCEcJ
         XhiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640241; x=1795245041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fkzw1dSkiJcsilY2Mokhk9gjBcrzBYNOsKL3JfHFbP4=;
        b=Sxy4F39moIIMI+wtgn2DAMVJBPjK2rczwGBxzEKkP6K7Rbei66Bx3PBv986M2xoYHz
         DduK69BggirU4Zs2BnNcDap7QagS6njTJzPGt8Cah+PAmeVrdo95OqV8yz2xgPt4J5YH
         CBF7vEvJnZ1DWPe6A4LXz0nSd1r1k7SS3uQk+Ajc5PUQTmzdlbf1l2rhglc5PSF2QmKP
         JWVb2ucabKqWjWo0VhZ8PQOznaU6ushie5faPo0FQr0PyV9kzxhUXsPGdnyEww3l+vtU
         nKHSQ1LDfjqaSNO8k2dqbawcSAfHKmc3qITYEqm87YHR9jbLZ3/uJz/lARbsSqNpoLjb
         tPGw==
X-Gm-Message-State: APuU4Z+X5xwFhbWm194A4Qr3R2t805SbMzHC7qckIzUpBY0Ct1CZ+mHe
	ojcyvjjjOtSt5Ic8+7rUfLQwGukzSGzSt5w6yKUVE6ey+GKzUlxyoFmvgKTJad/tH5Laruk2CE2
	avxDs
X-Gm-Gg: AYBFou2bPvNO41KPFLW7BuURL/PPn0LZdDKcxf2j7REstvURc6b0DnDy5jdTQRX8q/w
	luaG1lNJNujCKADXYGzixOcuNcbENpEP5Y3iW5fg8wqrWXMtT5EsVzw9C760e8rI4Z0Vxw5+JJf
	E3ZPIlGwC9yIWNM8RJXlMKuGw6kbYcSPOt3o6HdKHJiKJ+Ccy3e/zc36jVIcAtUBehu8tW2nqc3
	EZJjEd4/0K81zQ9xA3IxP2fr2+DmoMHsMEhBXiiaW9NbFuqR6BwFGGWcbM/p87PU0bNubxmEMBG
	gA9cKc7ru8sG1ocDiiW+sIlRtsJgjQcqCdOduD1sjWG2jr1OO7KiDUXm9Z7WFZwjDI5m6QEOJJ0
	13lF4XteDiVWAB3Y/RMqkpQAmbqUW6PKJdy1meWui8BpedaIIz0wJjnAt03wT6cIA8b+YO0KBpj
	OFg/coBUwpVAlVMsCh0lOapUIy4CHEL82YsSvF0pEsak0RqZ585ig3RDK4SzdabviJa7f/PAgCM
	Uk0H+2uZQhqDTlBUmdWcvMwDf/c8NRhPBvxtUz0h9Vc+TEF6cjUoEIR9XYEtiG2MVu6cXKLF2uE
	nYsaGwM3SZjxuSoc8/1vcqTD5Uo7OnhvWHxA8pHxmbjJPo5xTACCssdRJOaxNCSWLUaEaFkUmla
	BhfeYnDdB012mo0M=
X-Received: by 2002:a05:6214:c2b:b0:91c:9086:ee07 with SMTP id 6a1803df08f44-91f2420df31mr81654406d6.38.1794640240818;
        Fri, 13 Nov 2026 23:10:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:40 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 17/22] mm/vmscan: restrict reclaim to common memory
Date: Sat, 14 Nov 2026 02:09:54 -0500
Message-ID: <20261114070959.3490008-18-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD6DBC0004
X-Stat-Signature: ndntgqg31rqh41fat5yxie1zsqefcpjg
X-Rspam-User: 
X-HE-Tag: 1794640241-643986
X-HE-Meta: U2FsdGVkX1/7IjqN/gd0hoTLP2+XoSyxgMPbO1YRBmc96KtWzMekIo/TpSC1rDE/4FL8K/vQBXktqZDTKnnJ7RLmLY8kw+EzDkjKpn7iex3VnF/Q9+9lIbAC9uASgkZEUg56eKGLEzoS6XqkalpplpbABX8KNabBXi+Ph1SF4fjtvPw3GbJ8hvn3G9xOP7YYGYGyXgMxhqstsqF+j6S8iAQy3G55FO5g0cig4MWGZ50JkahRppLAu8JhmJoi6JvtblzaVbjAEZs4jVIq2XgFnkNOYW9irWQYy/h8x+fy+HxP4SPexFz12DnC4lOVeOzFgd93xHf5WsUuQoCLHrRQT/BCxuNiX+76GcbzaphYwPru6RPlxNmV/+/hTGqBbhWm3kbOoBT1VdTc6VTjyjQWtFMEr+pwIwPP06krTwUQtRKmOV0I+iQcS33kDsPk4xshpPuU7BZhCVgHx6u4Xlz/WuyhKgsO4+Dd4Gv/bTsEEryJmxFi+0CVZfZzlvN6Mhy/sM/A/LWQe5k4cm6y+ck3VRs5stEfM1A0lY73soXekBhOIC7xdkhwwAHcf6e1lpAs8KN40Tlso2TFhnt43evUGi+yKOCMeuZ/URaHJycYi0A24l3uEQFqY5QIlifAfxbBEVi2Ts2RSOcorL+qgVdXX+TYqxvWoLfF5ZgLtQsZQKP5klp7kw/DYi7go64KwPI8AE36cIUDOJ9GTF9hIPYFYWKH+BZxmCj0E8kPhylt8uNIil09hKT8wf2+RO96OCLIaf94v2mnblKCRWoWg2jAtNeeXa7yqyg/cV9oM62eaE9xQB/TqKrPOuA39+zG/TRINgd6ZPCx2tZzqdHjK/59PE/QIoyakqe8y1R5bN4Bd8sj3i3lQQFHuxpL4mreYnw9OZDWKd41pmmhht1I1uUUyIZw9aoVSbXCf/YneirGl66+kya/mYl1x6YO8kqY4lv+LMs5m1TrGyjRturFipz
 34OYsjL8
 ZGku1o9vD/17WhhxawyJerIFXIB+/GCvRHXUZzpSyxNn2TTn4lqlUDLu71Nu8p9LXr1uyQrmjGzYlB4xsytQGBnLaqhAfNqqN07w6PwJKRMALAA7v3xlnu8zSq+XIrBkZhi+TiqR/R5FBbuU6ZTYv6aGpoDBoLiNeGqaTjGTtt2FuKJ0pcWuB+Jt5WTx1N+nvGp30yQFLEr6CDkjHAcVVR+4nqumvB0mKPPD8wwRMy1q8CChL3fyfxxu0ATfztTlVn8/8XKEw9i7QIzxe4+Yz17f5B23+20lQs36aVDYUBPBQSmMWde2G3G4aMwHLXjPwXc04k0wN1E64oY+QiOOA1N+gLg7chE9hvnUDTtLHa9g4Yg87p1KQIpaoxJI4OacQUxDG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim serves the ordinary allocation domain.

Restrict it to N_MEMORY_COMMON:
  - start kswapd only on common nodes, at boot or hotplug.
  - walk only common zones in direct reclaim and when throttling it,
    so no reclaimer waits on a node that has no kswapd.
  - walk common nodes when MGLRU registers an mm and when its debugfs
    interface iterates or validates nodes, using first_node_state()
    and next_node_state() in place of first_memory_node and
    next_memory_node.

The fallback zonelists hold only common memory, and all memory is common
at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c |  3 ++-
 mm/vmscan.c         | 26 +++++++++++++-------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 29ff2c46499b3..410a29732bae7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1207,7 +1207,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
-	kswapd_run(nid);
+	if (node_state(nid, N_MEMORY_COMMON))
+		kswapd_run(nid);
 	kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 061fbd168d982..bb7b1c50bfb78 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2932,7 +2932,7 @@ void lru_gen_add_mm(struct mm_struct *mm)
 #endif
 	spin_lock(&mm_list->lock);
 
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
@@ -5562,7 +5562,7 @@ static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 	do {
 		int nid;
 
-		for_each_node_state(nid, N_MEMORY) {
+		for_each_node_state(nid, N_MEMORY_COMMON) {
 			if (!nr_to_skip--)
 				return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		}
@@ -5587,13 +5587,13 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
 
 	++*pos;
 
-	nid = next_memory_node(nid);
+	nid = next_node_state(nid, N_MEMORY_COMMON);
 	if (nid == MAX_NUMNODES) {
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 		if (!memcg)
 			return NULL;
 
-		nid = first_memory_node;
+		nid = first_node_state(N_MEMORY_COMMON);
 	}
 
 	return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
@@ -5665,7 +5665,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (nid == first_memory_node) {
+	if (nid == first_node_state(N_MEMORY_COMMON)) {
 		const char *path = memcg ? m->private : "";
 
 #ifdef CONFIG_MEMCG
@@ -5765,7 +5765,7 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 	int err = -EINVAL;
 	struct mem_cgroup *memcg = NULL;
 
-	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY_COMMON))
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
@@ -6492,8 +6492,8 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		sc->reclaim_idx = gfp_zone(sc->gfp_mask);
 	}
 
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					sc->reclaim_idx, sc->nodemask) {
+	for_each_zone_node_state(zone, z, zonelist, sc->reclaim_idx,
+				 sc->nodemask, N_MEMORY_COMMON) {
 		/*
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
@@ -6604,8 +6604,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	} while (--sc->priority >= 0);
 
 	last_pgdat = NULL;
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, sc->reclaim_idx,
-					sc->nodemask) {
+	for_each_zone_node_state(zone, z, zonelist, sc->reclaim_idx,
+				 sc->nodemask, N_MEMORY_COMMON) {
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
@@ -6756,8 +6756,8 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 	 * for remote pfmemalloc reserves and processes on different nodes
 	 * should make reasonable progress.
 	 */
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					gfp_zone(gfp_mask), nodemask) {
+	for_each_zone_node_state(zone, z, zonelist, gfp_zone(gfp_mask),
+				 nodemask, N_MEMORY_COMMON) {
 		if (zone_idx(zone) > ZONE_NORMAL)
 			continue;
 
@@ -7736,7 +7736,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_state(nid, N_MEMORY_COMMON)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
 	return 0;
-- 
2.53.1-Meta


