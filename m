Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36215E7AD73
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8276B0093; Thu, 25 Dec 2025 18:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968346B0095; Thu, 25 Dec 2025 18:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E716B0096; Thu, 25 Dec 2025 18:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77C196B0093
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:22:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C2118C123
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:22:01 +0000 (UTC)
X-FDA: 84259568442.25.FB4B7DB
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6839CC000D
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fZjyiY2h;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766704919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVIJLlIoVbyUjgLSsqavcZQWB6x8jtRLfTLva9jt/vw=;
	b=6zfR2gU3uE3+wB3FXQrVUDOjQAzmZpL+i7EOJSIUluNT9LeRco1LpmTJoOIVglSA8ZHwh6
	ktLtawvTOFBMc9PBvbzCHsTC5RcbyysqUoHmNfWzLhwYo+IARIV2Jz6DAO7HLx5VeUlZGb
	M/o9YFm94TV5EYGUNWkWb23wznSDUHM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fZjyiY2h;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766704919; a=rsa-sha256;
	cv=none;
	b=fqdQCpgt7QAXNY+Ua5DQMCkcUUhhMHh7K7Xhay8O63HdcWB1Ppy7ngKqQe2+Am+zNVvfOj
	8s4bTolUJ0aJ7ULHpLV6SYZZFCbWNYZTPz1yUHPuDPq42GzbJCrcpRMuPRzvxsCKVXaAe5
	nwUdHsAZXi+omKtDkj6G4g+e+4iaO/Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVIJLlIoVbyUjgLSsqavcZQWB6x8jtRLfTLva9jt/vw=;
	b=fZjyiY2hlAllu5kswXjcYSVUkUmBMWZCRsfjEqoVAjBblu5dGNfXelxww+eCnEshWI70uw
	b/2xwUsmF3rHJrEjUhxXwBBbuAWCNXmH26YcV+Wfwc6l2oZEEZmcISR5N+INT3oxtY27Bp
	vkF++kZgRyutqRzDdIJyUXsiWdhq5XQ=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] mm/damon: use cgroup ID instead of private memcg ID
Date: Thu, 25 Dec 2025 15:21:13 -0800
Message-ID: <20251225232116.294540-6-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 6zfubij3dc5djwd8pxkhz1ykt63cmib1
X-Rspam-User: 
X-Rspamd-Queue-Id: 6839CC000D
X-HE-Tag: 1766704919-654391
X-HE-Meta: U2FsdGVkX1+OEidA4npQsu2penF5dn97V47iOnS1QQI2JjT2N1+EtAmdaXZ6EvvmhjG49Cfuu9el96JkCuhTbOJodqHpryZgQqYmR+/Q5Rf0Vqo0/71xk0UEBakVn19fcEMCMfoma2d3Qnv1+XfZpM4WHxLddkF9QZPZyB6yh6WOMb216ZEuRjug+8HVXtqSwhpW0C+kc2Sy3MG8air5bpll0v72qtEv8bygbHM83TO+h2aYw2WbHcraPTGWEIXOqFy0aDXLUaLIuGYrs41AeA/zw5g7Thm0SDcgOqiPEtNN6ENT2ZdSSmBXqGksnSKKwEiN5AnkemI/1CRqsNt4gTS1zxebe5+dAt0KEmyAb3abluponuO8EIwCKxIkgMMxEkOfCAUeGUNDomBfIU0m1ipNiukJpUubuukFCq4gzXMsmep6dDBqXfBvtN7+Le1SXLKvyL8zeuy1NPY3bXOCjIqaX5fXVfROVvsvqm350Kkv8xl6kvLI9S05BEwJr0AUnW20kuuiyN4i5aPX8UGQBIkEbttxXin/eSGgyvPFDPhMYm7t/+WqWntaR63HlOFul7J1zqfShJyJj2UVcFBQvIX5eONM2c4IGgTVpnzc7Mt9Fj7Mo0Ws3sbq6GPM7wHccILxx2LCP8cs9B8Dx3d6u9N+OD/KCBjIEdJEkAcpFfWkjsaKAAaEWcL+ciHtJWbbMK38L+7kWOms3qAx2StmY2He/AiO2Oz1dq5CmE27pYj1jwyFY8wsJRyN9tCRlnOmTIIIUYhhwBSV0Cfnnl7bDKkBBsbDT6belANTkoOM20PPZAJaRvK9OK9iDKzAkd+PGP9xTXxoPXLBHTrEdYf0VB8RJmrlnSxL5drBCPmqk6gvjmcvOmfP6VSGIUEnFqjpqDqtgnBwrAiqFtp7pMiUFNU+ULByvjYw9ebVfji9UcBzFB7Rise375hSvScVVEuLi1Nk+g4cv4/9am4L4TJ
 0F164+/d
 NhLrMj2m1dsl68ERJq8TWvXcRIV2P1yOUC7NxRJ91RACpsj47xffj+7DR9U26YFhiUuMomBlNgWOS432UQ+NuLdNuw4RnyWU+MddldP4XgHCdkTZz0eYFH5Qy/KmGsDrYdGz34TYNXnAirlEE0jECNwHCB8FtImQg587G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON was using the internal private memcg ID which is meant for
tracking kernel objects that outlive their cgroup. Switch to using the
public cgroup ID instead.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/damon.h    | 4 ++--
 mm/damon/core.c          | 7 ++-----
 mm/damon/ops-common.c    | 2 +-
 mm/damon/sysfs-schemes.c | 8 ++++----
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a67292a2f09d..650e7ecfa32b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -203,7 +203,7 @@ struct damos_quota_goal {
 		u64 last_psi_total;
 		struct {
 			int nid;
-			unsigned short memcg_id;
+			u64 memcg_id;
 		};
 	};
 	struct list_head list;
@@ -419,7 +419,7 @@ struct damos_filter {
 	bool matching;
 	bool allow;
 	union {
-		unsigned short memcg_id;
+		u64 memcg_id;
 		struct damon_addr_range addr_range;
 		int target_idx;
 		struct damon_size_range sz_range;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2d3e8006db50..23c44811ff7f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2065,16 +2065,13 @@ static unsigned long damos_get_node_memcg_used_bp(
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
-	rcu_read_lock();
-	memcg = mem_cgroup_from_id(goal->memcg_id);
-	if (!memcg || !mem_cgroup_tryget(memcg)) {
-		rcu_read_unlock();
+	memcg = mem_cgroup_get_from_ino(goal->memcg_id);
+	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 			return 0;
 		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 			return 10000;
 	}
-	rcu_read_unlock();
 
 	mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index a218d9922234..dd81db95f901 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -274,7 +274,7 @@ bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio)
 		if (!memcg)
 			matched = false;
 		else
-			matched = filter->memcg_id == mem_cgroup_id(memcg);
+			matched = filter->memcg_id == mem_cgroup_ino(memcg);
 		rcu_read_unlock();
 		break;
 	case DAMOS_FILTER_TYPE_YOUNG:
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index e198234f0763..79aa917ab3c0 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2492,7 +2492,7 @@ static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
 	return false;
 }
 
-static int damon_sysfs_memcg_path_to_id(char *memcg_path, unsigned short *id)
+static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
 {
 	struct mem_cgroup *memcg;
 	char *path;
@@ -2507,11 +2507,11 @@ static int damon_sysfs_memcg_path_to_id(char *memcg_path, unsigned short *id)
 
 	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
 			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
-		/* skip removed memcg */
-		if (!mem_cgroup_id(memcg))
+		/* skip offlined memcg */
+		if (!mem_cgroup_online(memcg))
 			continue;
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
-			*id = mem_cgroup_id(memcg);
+			*id = mem_cgroup_ino(memcg);
 			found = true;
 			break;
 		}
-- 
2.47.3


