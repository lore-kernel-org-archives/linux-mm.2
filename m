Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B986CE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DE96B0098; Sun, 21 Dec 2025 18:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268706B009B; Sun, 21 Dec 2025 18:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B4D6B009D; Sun, 21 Dec 2025 18:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 057FB6B0098
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:37:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B31EF16098C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:37:01 +0000 (UTC)
X-FDA: 84245091042.24.E742312
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF3FE20002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:36:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uwgy9DxG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3moRIaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3moRIaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766360220; a=rsa-sha256;
	cv=none;
	b=RB5Zlk7oDEttMoLUgX+eBtiSEWiaPQBvJcVWwkVgnf8O3r/lJA638Jp4CS8kOr1KatglBF
	3R9w7EBw50NfWFEb9hgBnPuT9BaHQIZFPhB2jMXoEZ3huYvs7OIRy3tPYsy5B8ObbHGnDi
	TyVrTugpchgN/AZbFkfdZoFOSVIvWLY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uwgy9DxG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3moRIaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3moRIaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766360220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOdI/BEkQBQWXUHyCrchJg6ArfOE4J8nqe0nfugUeYI=;
	b=7ahJXH+JXiUsxlQ09+SEn9LbbZtWdkbP5TrCQBngv3ioDKwAj8WOl15nshPWaCqJO1/KSp
	LMPkzBJ2jend9E5RPvNoFQytoLsnFQE5EByLoUONjUsmjIKwGDAxGRAIwGjfpSgvBJlnxi
	YjH3UXmH1P082O1Z52RgCR7RJfpE5gI=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so93519935ad.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766360219; x=1766965019; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TOdI/BEkQBQWXUHyCrchJg6ArfOE4J8nqe0nfugUeYI=;
        b=uwgy9DxGkCkCONpooqFEee1cAut52HQa4i7HauJJ4lypVIMutZ2uzqH/Mgwe8//ysg
         dMQBPgXjR0vSjf7XvXq3lCxyPzkEp90tomKV5qqjPfQvUugdKVrIEMwIczPetqsViaM0
         gCJSTCk25EtoyfixhgWp9hKd0JDAbGu9t2pjPXEkeITKCI7q+kSgYkXxM6YlhwNGhjXg
         M7Yo46K/qWz/j+kdmBqK0JhgDGYxiqXMLxzPnJOz0Jd8pkFl8A7ST6ltvmMqqPVEJwjf
         84IqmxenwZTavhSGfo21So31vfdRPD0Ee8to7ZIPtc2ogEj5OukXJSPT35oLg+mZ+Eig
         wICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766360219; x=1766965019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOdI/BEkQBQWXUHyCrchJg6ArfOE4J8nqe0nfugUeYI=;
        b=vJP+6icE7550k3vHPvCSONuhG8cDkgnnXsL6GXy5V5mjuJly1gu552qjOA1fqGL6fU
         D35+9g2nEw+9RwK4wYk8awZp4K96MrU9HRtxtq3+xTiXYiUvUYJ6yMOOdBLmuWI5hr3I
         ZrWiVDZLN6hzV0XOXv4Y4q7Y6YmrVTw/CGjBFQkbvp/TE85+pYZxJnZyukyMQvCDj/0x
         LtrpZe15BvD//m8C+3GzD5DaqOffOpkLVyvuE+p/FUo4SbfFJyVciAT6ZGe/dYf5idfd
         GhVkGALX9mcVXOosh7jyRCBunjivovMR686f43NQ18rcWpNdJ8IcPnRaVvfAEgmVIE/B
         sPnw==
X-Gm-Message-State: AOJu0Yxoc1H30OhBjf7wlQGzzui555mG82A2deprN1z97qWqILppQQPr
	rIL77dvbHNbycv7GXGL5riYp3xgVsQrrsq/F4tHFFhEq1DmzVv+Y2DuAik25LKnkMyOWO+mAqNQ
	uR0XZtnd7uB7NNlk5nGEnxr8PtBIx46c/Dd5zRfHKWMOrPBUnMop/oc6Zp36Lxjmv3I+wHp8pM9
	CKst6nypYCvn02auwj+ilDTxqzIWh10fQVo32SRTr+Nw==
X-Google-Smtp-Source: AGHT+IELZQMOEJm89X4TKV9M7co9XdZ3YqAhkiRqGdD+0QsqFHoJCcLn4TvuboqvIUgaBTBeBhEGNHBt5S4NeA==
X-Received: from dlbtk5.prod.google.com ([2002:a05:7022:fb05:b0:11e:3ea:a127])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:3c06:b0:119:e569:f258 with SMTP id a92af1059eb24-121721acc08mr8626739c88.1.1766360218726;
 Sun, 21 Dec 2025 15:36:58 -0800 (PST)
Date: Sun, 21 Dec 2025 23:36:35 +0000
In-Reply-To: <20251221233635.3761887-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20251220061022.2726028-1-bingjiao@google.com> <20251221233635.3761887-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251221233635.3761887-3-bingjiao@google.com>
Subject: [PATCH v2 2/2] mm/vmscan: check all allowed targets in can_demote()
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
X-Rspamd-Queue-Id: EF3FE20002
X-Stat-Signature: yre7ankhog7prwgg7qxtmep9658dh3uu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766360219-319167
X-HE-Meta: U2FsdGVkX1+0XU944hctj8BqDMq50X3Oooe8pns0LJX2ZlG+6JMFMX35qtsLS2CECH5bOw7to8drx1KAlOOD6paeOFp6j0Rpmdr1lC4h10OOALtSER1Eyfpn5QB2TKQAm710tsKzX4Z5t/a5psox0OMVJwuON98JmAXJYeON3/SU9hahwdCo4XrBc5Kqt52ynPhs61wCPT+fW5ykxNJtF0hc14RIMhdc60xMn23ULaiL411L3PUwLdIqo5tLHusjDilkMoEpCdBzYJM4VA5hXTnODS+hpKnFNileGYJnxf0LhS64Bkx62NSie2CsdAWr0U93hjrZfzWFT4zh9YrDoEbvMRxcTOUFF1a2P/RLeO1oJANLJd61LJmu6vNI7cWWglhWhZeNeE1AHJ1A5NSRKCzHoWlXXQOy8qoXy5FSstPNUJxTMJx42G70EvQ7wvw1lZ21y7ujfTBCopdgYBi7Ml6fD2ULM5eA59HUyplnw4tV5KzSUOgFzDmSojEu3hOf+hOSOwaecULkW4OlL+ui308TrbJXI7mlehxQhQPlooEhrR+IYrZkcyZlObHeUMi7BH9AJBWvxH0vONWlNbcjyOVdUGKZky+DTnYJG+97pb+GgwSkpgTpuCoFXDLiWBuuSwC6VgJZjZ89hfsZlKdicLMojn9K5+Xq35Fz1x6emS0SL7hKp7tefSQVt1ulkcvqC5Ne3TLzTjIkq3WxRVy0GySo+8iyFODZPoWgv6Jk13QZBIdgd2MY0tgXVe8sYheCRkXnOQOrkp8WXXLFqKr/9jENbE2y4kWnXSsMRLzY3KCVi37+936Jx8LQA06YTAT/IaRUn8qFXCThjWnPsJZXBA8nsGaiRGuGFym14UGO7qDTC0XaAhwzaxJFOBCVavNH7hK2VFs4rkmsCfz9Jnb57B4HlHJGy26dTHhz20DS73Cc1N2ES0GjP3/MYBawBB1IOHs2lb5vVqRehw0002T
 5Xg7COzd
 h/XHy0IoHh1tRDVl7GWCq62u44wcnql02ZNKhyxJCOum2ri5ThQTlU5njtqrCPD3IW+Be8lSlW291FChViTK48prc1oBCzEDj5tIY+l9Kj61S1iDG1XwvHI6KLPpxZO2QzDAmewJDGXU6mz/nNB7ea1+dlazMOMsgBkuXstBYATMjbe6rFGAQF18plYWduTPrYQZiXvc7UE3CdluFbVq4wJdCF4thk3skYQKgVm9A7r3LEfbo9W8Nd57ldhVp3+lzXbyriRB9hSbqIsTAZbuDui8xivcCnSZ/mj4ou+08hcs0NpxWj7lOhmKX3I/67DMycEVfH6iKAOPuIqSLBd8dBsqaA3y8hu588eAgCb8X89CBlJCRDU9kRmciwJijLFeh76tBYn4xfKQx8hAX8PQvLvUnvgoRIQ1Ttkmpv7j0r9dSDfb2s43METqcl8uNjwyWo0ugFTowJaKnMePZQQ96cB5g+nHRNl33OrQaJ8CWlCnKh2PhilnG5aipgPrU3zvv99K0aBwcbbd5YwlRZ1X/IBcoHDj2f969/GMyl6ECGAkdBMW8PZbZ6rnMAhZ4b/vjOfCrqAZhS0w079oHIoeL/7ad9UPcT9Cl/ohVl41Sykg3fLwr4W4eQmWZcHoRaT/6St7+FJupjCD6FE8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to
can_demote(). However, it checks only the nodes in the immediate next
demotion hierarchy and does not check all allowed demotion targets.
This can cause pages to never be demoted if the nodes in the next
demotion hierarchy are not set in mems_effective.

To address the bug, use mem_cgroup_filter_mems_allowed() to filter
out allowed targets obtained from node_get_allowed_targets(). Also
remove some unused functions.

Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 include/linux/cpuset.h     |  6 ------
 include/linux/memcontrol.h |  7 -------
 kernel/cgroup/cpuset.c     | 28 ++++------------------------
 mm/memcontrol.c            |  5 -----
 mm/vmscan.c                | 14 ++++++++------
 5 files changed, 12 insertions(+), 48 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 0e94548e2d24..ed7c27276e71 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -174,7 +174,6 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }
 
-extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
 extern void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask);
 #else /* !CONFIG_CPUSETS */
 
@@ -302,11 +301,6 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }
 
-static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
-{
-	return true;
-}
-
 static inline void cpuset_node_filter_allowed(struct cgroup *cgroup,
 					      nodemask_t *mask)
 {
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7cfd71c57caa..41aab33499b5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1740,8 +1740,6 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
-
 void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
 
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
@@ -1813,11 +1811,6 @@ static inline ino_t page_cgroup_ino(struct page *page)
 	return 0;
 }
 
-static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
-{
-	return true;
-}
-
 static inline bool mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg,
 						  nodemask_t *mask)
 {
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2925bd6bca91..339779571508 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4416,11 +4416,10 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 	return allowed;
 }
 
-bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	bool allowed;
 
 	/*
 	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
@@ -4428,15 +4427,15 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	 * so return true to avoid taking a global lock on the empty check.
 	 */
 	if (!cpuset_v2())
-		return true;
+		return;
 
 	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
 	if (!css)
-		return true;
+		return;
 
 	/*
 	 * Normally, accessing effective_mems would require the cpuset_mutex
-	 * or callback_lock - but node_isset is atomic and the reference
+	 * or callback_lock - but it is acceptable and the reference
 	 * taken via cgroup_get_e_css is sufficient to protect css.
 	 *
 	 * Since this interface is intended for use by migration paths, we
@@ -4447,25 +4446,6 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	 * cannot make strong isolation guarantees, so this is acceptable.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	allowed = node_isset(nid, cs->effective_mems);
-	css_put(css);
-	return allowed;
-}
-
-void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
-{
-	struct cgroup_subsys_state *css;
-	struct cpuset *cs;
-
-	if (!cpuset_v2())
-		return;
-
-	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
-	if (!css)
-		return;
-
-	/* Follows the same assumption in cpuset_node_allowed() */
-	cs = container_of(css, struct cpuset, css);
 	nodes_and(*mask, *mask, cs->effective_mems);
 	css_put(css);
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f414653867de..ebf5df3c8ca1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5597,11 +5597,6 @@ subsys_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_SWAP */
 
-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
-{
-	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
-}
-
 void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
 {
 	if (memcg)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4d23c491e914..fa4d51af7f44 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -344,19 +344,21 @@ static void flush_reclaim_state(struct scan_control *sc)
 static bool can_demote(int nid, struct scan_control *sc,
 		       struct mem_cgroup *memcg)
 {
-	int demotion_nid;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	nodemask_t allowed_mask;
 
-	if (!numa_demotion_enabled)
+	if (!pgdat || !numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;
 
-	demotion_nid = next_demotion_node(nid);
-	if (demotion_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	if (nodes_empty(allowed_mask))
 		return false;
 
-	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	/* Filter the given nmask based on cpuset.mems.allowed */
+	mem_cgroup_filter_mems_allowed(memcg, &allowed_mask);
+	return !nodes_empty(allowed_mask);
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
-- 
2.52.0.351.gbe84eed79e-goog


