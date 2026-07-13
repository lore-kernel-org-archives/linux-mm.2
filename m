Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B182C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0989A6B008C; Mon, 13 Jul 2026 05:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048AA6B0092; Mon, 13 Jul 2026 05:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1016B0093; Mon, 13 Jul 2026 05:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C94416B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:00:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50B911C43BF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:00:40 +0000 (UTC)
X-FDA: 84983157840.11.D13D41E
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87EED140006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:00:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wLpg6rxP;
	spf=pass (imf23.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783933238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ioPagpwFTzNhXNYobwbUxjWhxbMrCA+AnLrRpW24boU=;
	b=DEJQ8EWr7IyMPsiuJlG7JS6el/LR2CjIVGMcpJ5Gg9epsEb4ksAMH/l3gnvbKsxZBPifuX
	Hdb4IGv9tUQsFGp1UMTuDk2MqCdDjuqRhiPLrwi5G5lHA1fCXHCAbc6F3Dhy7wdPmyTtUy
	I1JXdbGTyKGR0huAZc26jc7/WndIppA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wLpg6rxP;
	spf=pass (imf23.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783933238;
	b=Fx4Od7hwV7wlN4I2+CyX4U76OOetg1He7oH5xMQJEcm0zv+LMZ0q3ik1VHtuLh2PHrVwl1
	BeNdnXu2DGrcEH8sRG0ZZUI5f3GmOv8/IW5FJ7B+2F8PRvoaxnidIFclBuzDLcdI5PZZWO
	yaMc2qCtREGoV/oxGMqXOg4B1xM2PVE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783933237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ioPagpwFTzNhXNYobwbUxjWhxbMrCA+AnLrRpW24boU=;
	b=wLpg6rxPUtfwOyQVfL2Js9q33etD4FyUadaKjSztAoGnsIdTn4pC0n1JcIqDuc+pj97Am9
	T2IicbGvIvptI1eR2hi+k4KtVZRKqplZG2+h5QqWOYGfoUScieHCo0trS8+v1e9M3qlm5t
	zosLKgCrRF+HDHSGNm9pb9p1hq7cdjE=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcontrol: drop unused cpu argument from flush_nmi_stats
Date: Mon, 13 Jul 2026 17:00:10 +0800
Message-ID: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 87EED140006
X-Stat-Signature: gokrz8xwo9pj7sneoihzjaig4b6qdkkr
X-HE-Tag: 1783933238-645836
X-HE-Meta: U2FsdGVkX1/cE49uBpVQwHpkeeKGKkGhHTrkG4Qtz9PaEuZah7djPZvD5MluNSCQAy6KS4R2Arun3gRkysiDI789WHe1NsjM9aZD8jw2KstleRc14MyoCALczf4TtTAIcllkuTqWIEQdpU/vKclpYVDoo4fnWEEEdp11f6zLANZDBYlCppQs4XSN8pHbDd0Av5C7A4wjKuqDBRK00tTTBBunVKe+dep6L5dxxEBM6mxvx3ZC942YJO3rFbnUhiyKzjJfVUQBGboCufhQiPk3cB6OZFVJMvckdGmLBUIDfgXNj+4El6dOOOrppf2ZMh5InGLOgVzqT+NoibuleEg554Ak9bhTLk1MaiMhczw/BbayMPLhd6ZfEZVH6Ow19L2pbNO7bT2HwyPSenqNRiatM5Q8mJzCfZLu10cWxeIHXnc6pnLkt6hBSXX5d9MKx2u+d+nfjJ7FBSdj+Vc7CAmCu2GtKu+Hy6RbMbCAOG2btJGgVHPNP5Fn1TgYpq8a4Suo8WXPX47P3zd0XdLwMVY3ByvpFEksdhJx1PA/xa+PUc9cT/XhVBztHV864JuUC5T9vXS60TnZptgBsB/u9CNC3zAeCfd+2pEtjNauP9KL1VGYn2IT1VSvweoF9cIVT74WB/jugigOgH7ZfPgJleRy9Sae8z4ONeV8FTq7S8qCzAP/1mrDE7sQPuqbfmEggCZ/vBFtiB/uSjUm4cSGDxqjy0NPbHBrJMId+woSX8P40YbSZqg5cwHoIDYwZEEzL4OpZvRElqAMUwEbsaq2SZX3qQ2TePW3hXYSAKX+qMQh2nriZIhUwjCGfm0Fn+JWJupxiLmv4Y7dqs8bcQEu9nwX/v1EtWQeiBxT3n/V/P2iVMkPO/9p9XpfwtL4u11qnq2r9q/qX+jALP24CbNlaUNA2kWFg1ZjczsdOpKMyjdUoWgmlyYZBtMKHiW/sz4BaxyOgJotvWjHsUfypWynxEr
 ZsunNAy+
 E5E1APt6Nwm+NiZKyqAuDtR6v9/p1/g9Ox12aM6u2diibe9qVTf2HV3h5NMs1C2RXAvndenSUMFw52rqKrBehyu+ENidxSjM0HCiTxLcd9eh/tvP56qnz3V9HNuD1JHwQkhb2WYuktaXyjCcQBtxX3MmqLUOydEtxeE4//LAvI6VtLyxJpLMBfK5bS/dReqHvRyBXf02TGPujv1YUvGkQhDc9mQW2Pkr2O6s9o7UVWJlLn/bEiIfyRd+1bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

flush_nmi_stats() does not use its cpu argument. Remove it from the
function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
caller still uses cpu for the subsequent per-CPU rstat flush.

No functional change.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22f55aeb94f3..86ed741cc5cd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4433,8 +4433,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 }
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
-			    int cpu)
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	int nid;
 
@@ -4480,8 +4479,7 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 	}
 }
 #else
-static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
-			    int cpu)
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {}
 #endif
 
@@ -4493,7 +4491,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	struct aggregate_control ac;
 	int nid;
 
-	flush_nmi_stats(memcg, parent, cpu);
+	flush_nmi_stats(memcg, parent);
 
 	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
-- 
2.43.0


