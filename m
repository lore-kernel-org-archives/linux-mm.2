Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2307E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181136B0093; Sun, 21 Dec 2025 18:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158926B0098; Sun, 21 Dec 2025 18:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057776B009B; Sun, 21 Dec 2025 18:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E762C6B0093
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:36:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E27B5B719
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:36:59 +0000 (UTC)
X-FDA: 84245090958.18.B471B9E
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id C42594000E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:36:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0nNh41rR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3mIRIaQgKCBUw38143v919916z.x97638FI-775Gvx5.9C1@flex--bingjiao.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3mIRIaQgKCBUw38143v919916z.x97638FI-775Gvx5.9C1@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766360217; a=rsa-sha256;
	cv=none;
	b=4h5B7elpxQQTMkHm/eINHgSnaNj6qO123LiqMlcamziFEv4s1KmdNgNrdU+7E0PO6pV+WU
	E4ubLqDqMaCLFirjP86fGKKOXX2Pzqgi/6sdu5C1APfDgI4Gj/9RJoQvPCV3Zk+t239E6V
	70lZqK4HYgO0DVWk0dVJil2b23KfHUs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0nNh41rR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3mIRIaQgKCBUw38143v919916z.x97638FI-775Gvx5.9C1@flex--bingjiao.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3mIRIaQgKCBUw38143v919916z.x97638FI-775Gvx5.9C1@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766360217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GfhhMoWYFTh/aN/kwrLJXHldk5+UtwhObh4bR+INB4=;
	b=JvWuo17b+cG6/++7nTgUGVG3rUcKty58nchz9Az46Ho1yK/2rl8YrWsqPdUhxIyFEHSxFf
	o6gVU1VGeqnOIw64juzEfCCVvLjGq47AlmbwYzUIRL+/rFEcFxlfGW4fYiywmPoX/sZ/t+
	CGPRnUxxmLa1s3WJoYLeTcN25Ofs7WU=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b99763210e5so6945451a12.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766360216; x=1766965016; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4GfhhMoWYFTh/aN/kwrLJXHldk5+UtwhObh4bR+INB4=;
        b=0nNh41rR8bvvaY1vBQQyiOvn7Gwr5mI760cidDq1mguV4BxZRJpn2NG9ZYQPgHRd9+
         6duT6QiVA29Bb0HAlirQnT3q9mQIYUjmd798Q/U2RpjVDAysA/ZGRoAgd5EyZ+1xWD8f
         6tMKxbsFYjopS8/sU4B6wju5W/qgzWksR2YvbZTSW5Mv33aRWZBHXSduYgKsm26kE4yF
         I5LSod3HefWqLHmmWOzcgtQ+dB1uHPk2qwZJFF1xj3R+9vJw30KliEpbgv+V6DlH9ZSO
         v8LhN44fZkNDfdN6Dorfww8fbXatTzSuevQ5VHFiG5OmhZO7JoCszYfAW4VaoaSUioAf
         7kAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766360216; x=1766965016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4GfhhMoWYFTh/aN/kwrLJXHldk5+UtwhObh4bR+INB4=;
        b=edJDss0L+cCMeI9YMZ0u8ch2HjYPZy2hU8z52I0VMAtGsM6iYcZBROuaN7Q0yAplN/
         i9uya2o0S6DTX5wpqdRUK5cckkYegKtpJp0uCNExf7KanTjx8ujagef6f01SN++qaiSN
         aq0ucENrAtDWvqn+S/74IDJ3kRyowiRdTiWW2AhgCDR6IEBDeJEai81qfFRiA9Isn3uD
         tO5ntbspPaa4D/fvW4ZUMmio4V9LSnKDezMfiwrYjoLxKzMO+uowQHe81oD3sME4zXER
         b8+ssfQ47E9H0iXPT8+yd8l5ikX7XxXccGLAmbFADEzUXAttDB5Ij/sWeXSzAUY0qtm6
         drGQ==
X-Gm-Message-State: AOJu0YzDN1eTEayYikR3DMcofATNGOf4rvb+gF7nQvfXJgR6Nngx6r/V
	dvHC7Ysf7iP9Y5GCqJuk7fYhQFC6jBvYQySlO8qweEtfJWjmblDRTVLXDYAj9xJTf/8KkHgcgLO
	DITe+OUM3ABcIzSy3O56raxOng8/PLq3HUoNlR51S0UJIVE4kb2A4Tc7vNbr6feLJl11uvUfuic
	L8XZ1gtGobGoZge1qe9n+77JMfywGv2W0p7TcKJfgGQQ==
X-Google-Smtp-Source: AGHT+IEicLxazx7S6uu1698T5FhlbmHzMdzgeAbcuTNEEaAVkEM1v1fpFPWcA/uiQi7D96w3YBVKbgPaJ+Ktsg==
X-Received: from dyboo7.prod.google.com ([2002:a05:7301:1e87:b0:2ac:36d5:fc65])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:d89:b0:2ac:2263:dcc0 with SMTP id 5a478bee46e88-2b05ec19181mr11168511eec.19.1766360216254;
 Sun, 21 Dec 2025 15:36:56 -0800 (PST)
Date: Sun, 21 Dec 2025 23:36:34 +0000
In-Reply-To: <20251221233635.3761887-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20251220061022.2726028-1-bingjiao@google.com> <20251221233635.3761887-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251221233635.3761887-2-bingjiao@google.com>
Subject: [PATCH v2 1/2] mm/vmscan: respect mems_effective in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, cgroups@vger.kernel.org, Bing Jiao <bingjiao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C42594000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 8u39w8jsp7dg8kw3a3dmj4ri93j3qdgz
X-Rspam-User: 
X-HE-Tag: 1766360217-430256
X-HE-Meta: U2FsdGVkX1/DEb5HF1kZIEVQFQygTA5NqHKxA66ODjqH7a1Yq7Nfl0i23L+E3rjRWzEs9sIQAt/U2qdkT8a8cn/Rq+ERCUv2BatqwAIHc1r+h8cHwXWxJQQq6PeOiq6gh8XoKhKGoSwEfMq9enAzex7DEMrUYWw2GyW+8iLJS719MNcpCsymsAc6cyK//3Ygnt+Z8M/bGYgkfqI0BtaZEQuJxuYrRwAE830OY2wB4GoBwcVoYxt5bqaS8bDDXVl7PBL7VNarj13c6Ut5B+fjbUGq725u5nmYHbbBDclOOABpQ3+u1V4tdRS+gxkgrzRB3BAMmqnOys4TtAU6nj3BIf6U+PN1ybR85qtgnVvAeG0WM+75kHL574VcSL988mTR9gn8b7lTFNutBenLO7yWyQwwSxnubS0JdhKE42/PhhFOx8HF63annnxi5a1wgKCz9DdTkHr7sd+JHRTGuk/6Vw/35jqtx5VQJHDE55fDwZZ8YJTJBhlGAN23uWEPdwVGL79w6oiHds4hvdCcfCpPApgcJendm17Vvn9Fcxj4avpPYorkCm7anZR9/h1X7RCo+Ol10LTTy2Ip167o1t0pEn+3gMuzl1ur016TEmNch1fEgA09qmotxQZHUQ8cYbbd9/SpLE/vpw7bhEedRYeGk/SY/FCZ6hveXTBfk2pR8DG5VTUjXojg4n3PjeRXRmAO0eINeOfGJ1fMP7Vm6iFjO/IdeI2++H+KveefjQsFpn4nHeYhRatym3sbGcsWpxY4poTzS9BXcDnGG6jxl0X34CV7TdQtzMgAF3XlmhhXq/xHQKZcGxubEbD+4GMfPvRZmnqUXITpOMJwdq+kJcxdfTFIkJfv8PBM3n+tmz93BeyODMpUB0GRvSoBWQmWj+JwdjeP0n615X+c516S3tvMR/0ELVah+vaJyy1NhqXbU4bGtgR4ORr91U/CmXASihtaSAQMQtKSc95SqvEEwct
 Ge8rZpn+
 fCcwtP9s9ds1FKcDdrkOGL0OK9oUiCs8Ms8T1OEaAaP8N0vi7snE2K4iiruMmgalfWTRbJfvyfuBHBLXH13SuPC+AZC0HE7Lu5tmFIObZ1rkAvO2FA52AeDtzWS9VyXtSsB+ebsm89vDZqfH4g60CIzmN+p6Esx9HZ02fWY1IwijbgffrwQ/ZDqk+O5MDgdNaalkGyJVw6wb/3Tm/f42F7tqA+keG3zh1JTTi0mg4/jN7YPXUntDFILIUKiuuoimQBSFNiyO7MpoEAsgVcCpp38swjynrAJ0SLWoU+LWemilwa3M9hDuyawoqeWQ3dwwKlOd55H3UWmfgw5NZCgjwfoikvRPYIjumc8JVBV8k2Fj32q+x85IOqqEHmQpbEAoTG+sLSxenpLU1wuQAxSeMnsc98zFCiJadKTe7virEerEduyYq0UiH58APAWIDC/v7INkkNFQhSU/D3uJqFYpbr+5Q69OgFMgZJmdNFWLqVsPJGVnmhRrcfowYMOqpHvr+GAvqrtHzBbeJgWsXnESPDoMITg7X81xO4A0WUb9409UB61XrS+jkH9fppXDPEcfIBPgk/zanZVUVvmjPF/BWCsZcai72L/BVe5ujY41vZK1or93TjdS1/8O1tDkcKpd9kCuxhYQXT5x2/3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to
can_demote(). However, it does not apply this check in
demote_folio_list().

This omission leads to situations where pages are demoted to nodes
that are explicitly excluded from the task's cpuset.mems.
The impact is two-fold:

  1. Resource Isolation: This bug breaks resource isolation provided
     by cpuset.mems. It allows pages to be demoted to nodes that are
     dedicated to other tasks or are intended for hot-unplugging.

  2. Performance Issue: In multi-tier systems, users use cpuset.mems
     to bind tasks to different performed-far tiers (e.g., avoiding
     the slowest tiers for latency-sensitive data). This bug can
     cause unexpected latency spikes if pages are demoted to the
     farthest nodes.

To address the bug, implement a new function
mem_cgroup_filter_mems_allowed() to filter out nodes that are not
set in mems_effective, and update demote_folio_list() to utilize
this filtering logic. This ensures that demotions target respect
task's memory placement constraints.

Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 include/linux/cpuset.h     |  6 ++++++
 include/linux/memcontrol.h |  7 +++++++
 kernel/cgroup/cpuset.c     | 18 ++++++++++++++++++
 mm/memcontrol.c            |  6 ++++++
 mm/vmscan.c                | 13 ++++++++++---
 5 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..0e94548e2d24 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -175,6 +175,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 }
 
 extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
+extern void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask);
 #else /* !CONFIG_CPUSETS */
 
 static inline bool cpusets_enabled(void) { return false; }
@@ -305,6 +306,11 @@ static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 {
 	return true;
 }
+
+static inline void cpuset_node_filter_allowed(struct cgroup *cgroup,
+					      nodemask_t *mask)
+{
+}
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fd400082313a..7cfd71c57caa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1742,6 +1742,8 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 
 bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
 
+void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
+
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
 
 static inline bool memcg_is_dying(struct mem_cgroup *memcg)
@@ -1816,6 +1818,11 @@ static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
 	return true;
 }
 
+static inline bool mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg,
+						  nodemask_t *mask)
+{
+}
+
 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 {
 }
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..2925bd6bca91 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4452,6 +4452,24 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	return allowed;
 }
 
+void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
+{
+	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
+
+	if (!cpuset_v2())
+		return;
+
+	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
+	if (!css)
+		return;
+
+	/* Follows the same assumption in cpuset_node_allowed() */
+	cs = container_of(css, struct cpuset, css);
+	nodes_and(*mask, *mask, cs->effective_mems);
+	css_put(css);
+}
+
 /**
  * cpuset_spread_node() - On which node to begin search for a page
  * @rotor: round robin rotor
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75fc22a33b28..f414653867de 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5602,6 +5602,12 @@ bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
 	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
 }
 
+void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
+{
+	if (memcg)
+		cpuset_node_filter_allowed(memcg->css.cgroup, mask);
+}
+
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 453d654727c1..4d23c491e914 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1018,7 +1018,8 @@ static struct folio *alloc_demote_folio(struct folio *src,
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
@@ -1032,7 +1033,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1044,6 +1044,13 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		return 0;
 
 	node_get_allowed_targets(pgdat, &allowed_mask);
+	/* Filter the given nmask based on cpuset.mems.allowed */
+	mem_cgroup_filter_mems_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return 0;
+	if (!node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;
 
 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1565,7 +1572,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
-- 
2.52.0.351.gbe84eed79e-goog


