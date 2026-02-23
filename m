Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60E5EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458696B0092; Mon, 23 Feb 2026 07:33:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4308E6B0093; Mon, 23 Feb 2026 07:33:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305BE6B0095; Mon, 23 Feb 2026 07:33:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2FB6B0092
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:33:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63C921B2B86
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:33:06 +0000 (UTC)
X-FDA: 84475661172.30.14D9213
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7F42CA000C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:33:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cHNQ1IAe;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771849984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYNB6/pZb33YeAKubCBWRXUx4k4dpplKbNpn3dWK4iI=;
	b=AW2IRl2vIcfHoMG2aVE/k5efuAW5u9P6T4ySV3zCgh0X7ZYL7R2W4aLahTZv3QuevYU3Op
	R9Jyl1ucGWxW4Z9QxSWMzs9xzWg0o7hvXWcbyVjaXiPy0QyBG12JnXv7u6Rnvo0g7TVYmz
	M3iPGg3UpRPj0diDU1XzR0bTeIOC45M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cHNQ1IAe;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771849984; a=rsa-sha256;
	cv=none;
	b=T+h6AeBE6TP4qoIM8D+VZk2i0FKsqJsQ7Os5Zl3AoHi+XX/VBNvO7553sZQ8t/pcaH2XZL
	hQZyM3lxm+h3Gd4Pu5OZhKqK1MkV1g25MYLaVDoa9dXmrd1k+NHXdv5WSvzMfQHFLx1P3/
	3wtr6CvuV0gYiIMG9pMzWctznrL0Edo=
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-c6c444e89bcso1510439a12.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771849983; x=1772454783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYNB6/pZb33YeAKubCBWRXUx4k4dpplKbNpn3dWK4iI=;
        b=cHNQ1IAetJFuDRNum5Jg5SJLRkGozyvS24odWYULWcLusS4xvkbAKolPZPTFtH6CCo
         /cQTK0DcWnU0Ojp7S+4c10aFtQyAnpg5JGqRh8KTuBabEUB7buwUPA6geLAsOFvvGD/q
         GRtBkofIHOAIELSrCY8Bg5BikBF+7m2ET+wE83ZBxEYG2cFT2UZ+7ZbZlxZZCOHRVDDh
         M2qUgB7TMIz4T0UGYApo1fuQFdtASq7bMzb0qrCUjcVxX+46Xq7ddCWsccEDGVcvzrTa
         3olm06ii89xcZC5qhhme4FiA7ys0z3nZjDDsuzotWcIz6gx5rBKP99S180//IhutRlqb
         uSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771849983; x=1772454783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GYNB6/pZb33YeAKubCBWRXUx4k4dpplKbNpn3dWK4iI=;
        b=iX2lgBR/FcmSIVEA1hnacScNLnhy73MVz41WKcH1/JienYrMASAobrrewZypWJNGvV
         NMo2hZTkz0zlhyTvCaLsG4OtL388LFC4TwDdo+me171/NFpUdiH7PCegsxQO9VgBDYYS
         xODUS6I9JQ9XEG5R1CSceTIZkx8x7OziA26HSoi9M1NLWadsxOORjOGuh/zAeNHdkMIq
         8CC5ARNxd7hlqzokCqxagrilmnDVvmuvHGLBZH6hsczYnRjj4v0x+RXiVRsRlYH4NSPh
         fXOnXUbIs5viRanJotRrjI2JDrwhOVsYCUBItGOD9dUk2Qd7WxqehL8vtvjJR7Auw5ml
         AxxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH4+J02C7gO9yHORUSrsromumsJ4yj397UcSB08ttqijsXWAuUaXV7vNVhFHEB3uDkyMpbW+ydXQ==@kvack.org
X-Gm-Message-State: AOJu0YxQ1qPKjmeQ8rq7lh1DftIAPA4Losrtypekc4MgiMMVd/NYMyky
	GHNfCb2GAttjgLax8FmKB0rmYeQA02mehN1mIPPThNkEU+koAMFUEgI=
X-Gm-Gg: AZuq6aKJEDmFgN8dBNVJWzpBvhUZBeykDRZxtKM4NID4Kjg0hL6Wv5xff+8qUMIiHS0
	dUvgfGYSXWRFt14StU7Z5OQWx8USPI6n9/gFEW7NYCuNIqwtrwjfNn6YQnlCXUvhZfDtOMgL4um
	+SXo+iqMGNoJKGgwW9jas4oNALSegI5pFvBhCPiPt1Y+bMQ3hK4s6BVk4WYODkZzoJegcJS386W
	C69YdB60xtsQEZDgUo7dopAbyHcOSC+VHAVotFzdXbdo5WVbeAPWqcsqjYZ+gTypfQZR79K1Cme
	zfT/lSpxwdICMhSMGAyP0h+9pI8fdP+K7KVRyXVdvpVKQXxVY3kRVaN/GRr/+RxO7VWZ4FTlXoL
	lp3ffqtKTV8NOYPh4TVaoum0VAijYYINW6+y120oO1kFiJY9EkXLQ65L1CXyhRdEl2qteS8EvDx
	X/GK/43KJSThbuqhVWkqwRtlTxH6mDZWxmKaJSYbJMRj79
X-Received: by 2002:a05:6a20:cc97:b0:35e:11ff:45c1 with SMTP id adf61e73a8af0-39545ebee1cmr6462789637.18.1771849983299;
        Mon, 23 Feb 2026 04:33:03 -0800 (PST)
Received: from LAPTOP-FDBL0TVI.localdomain ([49.37.157.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b71a73e1sm7454739a12.13.2026.02.23.04.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 04:33:02 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH v3 3/4] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Mon, 23 Feb 2026 12:32:31 +0000
Message-ID: <20260223123232.12851-4-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260223123232.12851-1-ravis.opensrc@gmail.com>
References: <20260223123232.12851-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kk7qwq7x51q6sehg84ps77mi89m77tp3
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F42CA000C
X-HE-Tag: 1771849984-558674
X-HE-Meta: U2FsdGVkX19NLdRjSeCS0l1msd3YYXNkH537WAqzWyu7xLNFGXjcUF9WXPIR4RiDGSZfk+KFRMQv0iCYe6tm65Ptkp4aQzt7ZwgPUaHl7LGMEcLmDWgK3mB41ZzbgSdqkfHFNQMmonFvdx/FLnRsn1h8A78ZJtAvVxQBBtjFw2rpw8isRt9NeUvT2Vmjyvrlwphl3QO3nvErpulMlcixmdQxXEutGPHCEuARJh3BV9vjVe+xzC5oBloiatfgzdzhnZt+A/g/xP2arCwrpy6uJgYFqzrWtRx/QFSWsLQjd8RzURkWa/b/8LpshbDrrV568JroY9DUWC1EYg3hSaxyN8JDdjlkPbFbw83ZIy2ikN2R97eW/rgGos03UQD9UvPtZia3buOaHz/hKG1CKlsCXkQyFeOIDIhYeYInbMWS0LOgJ0jVH61nRvNACCx2FlRHMFCLuYAtL0YvYEMjxWOzD3zskDGGfDDmgwC/IrULKZqc8Raid/tOzql8GeybyhYWSq1Ibd4KbwSMHBGnwma5O35Ve/7lleMy9Vf+iUnknedFZWzu6PA9ykuzDsNU0pMnR4YtHh2of2vRZeuYhyc37A0zlHoa69svl/VGn+cjPKn1IAxSgZHZvrmgt552QcupbZj9KvgzcyvxvSPgG7vwyJNERXmKoHUKqnrBNwc5PCLNULMDZ9oFnEuIBPkpWhtViJHFK+f7j0+fn/ZuHr9oaDUOhIOXWkSB2EkQEgxB3lSMX6/8dkCEVMuKIUQ6SJy9dWxlSDlvedNWeZ5jx8PTh4rP+OH/sWVjOVModgrd6L0YArE+CRSB6iICSjiymQwi8Vl8blyNsdW+pzRWIp2DFbA0NvJAQKpTz2kemR2qI5CNJDw7PmRe0xrvIYeNEvacpczLPzcRxy24y7qu1a+UbXonhV/ME7ML1bIpNFogaoqFp5hxPKsSZRJKX3wZpuoBeK+ThPAM3A3T3mYSf3o
 WQ9kU9il
 T3A4LiFrwTGSYIQEHtZ/XXXhNqmZo7pdM4YqhZOuB5ERbcdppLbA/9SbXxsH26RrNloyOxDPz46+I46uHPSj1U88NfB6pwRKpSvwzSV/VeNGlSoAS3dyxsEPrzXS9ePiU07D9GqNehfyhMNfFvD5G4nTCMwK6v26P8v4TO6Muy9+juImYwsK/KC2a/gumIiZApXku2cdBdnf1c05PUkTMfWdVT8lpWUX6oFVLcr/YJ/teVT+OGs4nmok2eojQlt+xb5sCQo/0NqOiU4LJQqfBOnvopwmUoyZBMi0HlUeuTHLn0BPRR1bVeIzK1QOZ5O0ID4EF5FqBHNA7+mGNGGMW+sHtiZq57iL/2qlHD7ZDGFmq+Pi1KUMU0WzX5MrE7+P43rQryaF/v/Jw65wepMKTUfwZAwsxak+wQGDBRdhfkUv3d+x4j/uViqy4Hfb7nM4QN0JFRrEJ2RTUFYq+NaDUi73l0omfTmDku/PDBGKe63wN/HArtuL5KsRLxGUTHKBOCfcT/jQg1M1gLXitqeomvPvYisp5PrqLYeYTMWWYK6i7dyVO8vUBrPvAYTTTx0DjaV6iP0ouOjqvgzWhPbQDagMjswgh10O7p9JBW38SjF3CpCb5Lp1f476H0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new quota goal metrics for memory tiering that track scheme-eligible
(hot) memory distribution across NUMA nodes:

- DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of hot memory on a node
- DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of hot memory NOT on a node

These complementary metrics enable push-pull migration schemes that
maintain a target hot memory distribution. For example, to keep 30%
of hot memory on CXL node 1:

- PUSH scheme (DRAM→CXL): node_eligible_mem_bp, nid=1, target=3000
  Activates when node 1 has less than 30% hot memory
- PULL scheme (CXL→DRAM): node_ineligible_mem_bp, nid=1, target=7000
  Activates when node 1 has more than 30% hot memory

Together with the TEMPORAL goal tuner, the schemes converge to
equilibrium at the target distribution.

The metrics use detected eligible bytes per node, calculated by summing
the size of regions that match the scheme's access pattern (size,
nr_accesses, age) on each NUMA node.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h    |   6 ++
 mm/damon/core.c          | 123 ++++++++++++++++++++++++++++++++++++++-
 mm/damon/sysfs-schemes.c |  10 ++++
 3 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index ee2d0879c292..6df716533fbf 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -191,6 +191,8 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a node.
+ * @DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:	Scheme-ineligible memory ratio of a node.
  * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
@@ -204,6 +206,8 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
@@ -555,6 +559,7 @@ struct damos_migrate_dests {
  * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
+ * @eligible_bytes_per_node: Scheme-eligible bytes per NUMA node.
  * @max_nr_snapshots:	Upper limit of nr_snapshots stat.
  * @list:		List head for siblings.
  *
@@ -644,6 +649,7 @@ struct damos {
 	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
+	unsigned long eligible_bytes_per_node[MAX_NUMNODES];
 	unsigned long max_nr_snapshots;
 	struct list_head list;
 };
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b438355ab54a..3e1cb850f067 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2544,6 +2544,111 @@ static unsigned long damos_get_node_memcg_used_bp(
 }
 #endif
 
+#ifdef CONFIG_NUMA
+/*
+ * damos_scheme_uses_eligible_metrics() - Check if scheme uses eligible metrics.
+ * @s: The scheme
+ *
+ * Returns true if any quota goal uses node_eligible_mem_bp or
+ * node_ineligible_mem_bp metrics, which require eligible bytes calculation.
+ */
+static bool damos_scheme_uses_eligible_metrics(struct damos *s)
+{
+	struct damos_quota_goal *goal;
+	struct damos_quota *quota = &s->quota;
+
+	damos_for_each_quota_goal(goal, quota) {
+		if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP ||
+		    goal->metric == DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * damos_calc_eligible_bytes_per_node() - Calculate eligible bytes per node.
+ * @c: The DAMON context
+ * @s: The scheme
+ *
+ * Calculates scheme-eligible bytes per NUMA node based on access pattern
+ * matching. A region is eligible if it matches the scheme's access pattern
+ * (size, nr_accesses, age).
+ */
+static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	phys_addr_t paddr;
+	int nid;
+
+	memset(s->eligible_bytes_per_node, 0,
+			sizeof(s->eligible_bytes_per_node));
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t) {
+			if (!__damos_valid_target(r, s))
+				continue;
+			paddr = (phys_addr_t)r->ar.start * c->addr_unit;
+			nid = pfn_to_nid(PHYS_PFN(paddr));
+			if (nid >= 0 && nid < MAX_NUMNODES)
+				s->eligible_bytes_per_node[nid] +=
+					damon_sz_region(r) * c->addr_unit;
+		}
+	}
+}
+
+static unsigned long damos_get_node_eligible_mem_bp(struct damos *s, int nid)
+{
+	unsigned long total_eligible = 0;
+	unsigned long node_eligible;
+	int n;
+
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return 0;
+
+	for_each_online_node(n)
+		total_eligible += s->eligible_bytes_per_node[n];
+
+	if (!total_eligible)
+		return 0;
+
+	node_eligible = s->eligible_bytes_per_node[nid];
+
+	return mult_frac(node_eligible, 10000, total_eligible);
+}
+
+static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s, int nid)
+{
+	unsigned long eligible_bp = damos_get_node_eligible_mem_bp(s, nid);
+
+	if (eligible_bp == 0)
+		return 10000;
+
+	return 10000 - eligible_bp;
+}
+#else
+static bool damos_scheme_uses_eligible_metrics(struct damos *s)
+{
+	return false;
+}
+
+static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
+		struct damos *s)
+{
+}
+
+static unsigned long damos_get_node_eligible_mem_bp(struct damos *s, int nid)
+{
+	return 0;
+}
+
+static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s, int nid)
+{
+	return 0;
+}
+#endif
+
 /*
  * Returns LRU-active or inactive memory to total LRU memory size ratio.
  */
@@ -2562,7 +2667,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal,
+		struct damos *s)
 {
 	u64 now_psi_total;
 
@@ -2584,6 +2690,14 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		goal->current_value = damos_get_node_eligible_mem_bp(s,
+				goal->nid);
+		break;
+	case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
+		goal->current_value = damos_get_node_ineligible_mem_bp(s,
+				goal->nid);
+		break;
 	case DAMOS_QUOTA_ACTIVE_MEM_BP:
 	case DAMOS_QUOTA_INACTIVE_MEM_BP:
 		goal->current_value = damos_get_in_active_mem_bp(
@@ -2597,11 +2711,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 /* Return the highest score since it makes schemes least aggressive */
 static unsigned long damos_quota_score(struct damos_quota *quota)
 {
+	struct damos *s = container_of(quota, struct damos, quota);
 	struct damos_quota_goal *goal;
 	unsigned long highest_score = 0;
 
 	damos_for_each_quota_goal(goal, quota) {
-		damos_set_quota_goal_current_value(goal);
+		damos_set_quota_goal_current_value(goal, s);
 		highest_score = max(highest_score,
 				mult_frac(goal->current_value, 10000,
 					goal->target_value));
@@ -2693,6 +2808,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
+	/* Calculate eligible bytes per node for quota goal metrics */
+	if (damos_scheme_uses_eligible_metrics(s))
+		damos_calc_eligible_bytes_per_node(c, s);
+
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index fe2e3b2db9e1..232b33f5cbfb 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1079,6 +1079,14 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 		.name = "node_memcg_free_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+		.name = "node_eligible_mem_bp",
+	},
+	{
+		.metric = DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
+		.name = "node_ineligible_mem_bp",
+	},
 	{
 		.metric = DAMOS_QUOTA_ACTIVE_MEM_BP,
 		.name = "active_mem_bp",
@@ -2669,6 +2677,8 @@ static int damos_sysfs_add_quota_score(
 			break;
 		case DAMOS_QUOTA_NODE_MEM_USED_BP:
 		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
 			goal->nid = sysfs_goal->nid;
 			break;
 		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
-- 
2.43.0


