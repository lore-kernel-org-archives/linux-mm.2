Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D37AE91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CA86B0088; Thu,  5 Feb 2026 04:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDF46B0089; Thu,  5 Feb 2026 04:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3126B0092; Thu,  5 Feb 2026 04:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFFA6B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:02:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2273158FC1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:13 +0000 (UTC)
X-FDA: 84409811346.06.E161E1D
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 44829160011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dk4DPTIq;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gok/w53D1QZxQSSXx2OlMZE8/juZC59RiuuDAMJ7kJY=;
	b=8q7PbE95b7nvlEzuEvoGyKND+E2dtAQW9btPjKNTe4o2ul4pB+YuqTOEvt0+gVrEYHGyvq
	HxUzM1n8HZrGBp5s64rG4V1OR5TzBJgOT6ipQXmGRbYScqijEpRQPtA3cYbedc4AHykeBD
	upbh0GumY3wAFR/5fChgrZlZrV4f/CI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dk4DPTIq;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282131; a=rsa-sha256;
	cv=none;
	b=rE6YkgvLeIGpeR/SIFWF0W+Z+6Q1Ff1YrGkvcsLEXnnQzqx932MlTS4yDXtHYj2rMbalG7
	lNb8hzcLiPKnGDKeKwboEAS8EKpCQvF8ax6SzbcBQmtuYQGEy6dLxxSxCgOFoQ8HaGwNP5
	iHx/HG1d/sXyxDqmB9gNkWhynn81Gd0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gok/w53D1QZxQSSXx2OlMZE8/juZC59RiuuDAMJ7kJY=;
	b=Dk4DPTIqYdy81yvOV5kdlf416talo3dyPs0MfQaXzaDe5ybLplNcdp4FZV8tB1P+UZyQUj
	ofUyTY0uPInDGvWXqBQh63gIq+LsUrDcU7Z5JdphaFdyiOUbjxlvmCc/PJTtdYWzKTxqZ/
	HFwMLiIP7udwzuEPcKdmwPec7LxuiI8=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 08/31] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
Date: Thu,  5 Feb 2026 17:01:27 +0800
Message-ID: <b1875dc5a94f66c384eda1cfa0b3ff1f7930c406.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44829160011
X-Stat-Signature: tbdh5a4q47635ornqeua6qoag7533pyt
X-Rspam-User: 
X-HE-Tag: 1770282131-339619
X-HE-Meta: U2FsdGVkX18EQrYIWMrXo+u66hcUFhOEXs0uSRwS4eFkoanWMd3ICrQP/alYumeClUn4OG+6VJWabpunH3MHoGk7xsU5dXVDyDqNNLmIYVv5nunaV2MB/AtbUpR8RNJpq4cLNeQRQk5hbac1r+08/K5hy0JvfwQDO6/NXEmTgZuhw04zgSKTAjv2mJ/DkwilC80p8w/j4eZQQQUcF0GZ8vc2tpQO6g+HwaNm7Ro4eVdej4VxTgDJlFQgFhiDA2PBx5HGpgPE4YGIB0j1B2HUaun86V81Ci2n8ZAibRC5ZVTV6k5eZAx75rOmmjce21ZqVJ0c3+LBBhWFRGMpm46I/7ChLa7HlyXInyL+lXs3c8eLeBu5F/cV865OfW3yi2DrZLHm4tI+J+249DlcXChMZV8CAqhDvvAnOSIvu6FQrziKNuVnAKEUcvC5g/ftlN3/ysWwKCbfrfDl5meM382chnaidKQNKwPPROblLNr4ogoRzr0iCV0/WR+XsvcpAJapC0gODDkizuypH4ueV+ru7YvMvNbDId23UlTsOom9sWlbkCsAZRlRblUPKXiIIq8V3BpI9ZveZid+ZugsMHHpN9Y5iIUNTUAOntR1bl+mAeHV+nQ6+Vhdakts80BBGfHijVVXwiFT/zdd1CHCG26Wt7D7q0bGw7cCzthYYVEYZe9w7Rfeq5cLuxYTIqI2ge3hCrAfihg1VRmoF9VstkZqejb938mdo3fWf4Nsg4uXPxJRQP4TTDA5Qdqc0GGACw3wu+7ncGoLhCQcN3Eusn1mS+majG0tPt8sWv/k0NJtQYw/C1SkK5f5ADEiRn/B3J2g7Kj8zKzT8o62n4hzgIz/RcwBUN/sdIJOkmkW11aRV02yIvb+a+U03IsPaXqC1fly/m80wLlBCW33k2Xwtq0kF5RuFdYFERlBAOmptWF4xMRKu8DbRh1PkbUs2ntWqYRKKXkJKXy5EItcWpul/oP
 RE09UCxR
 sAs3Dnq3KfAbHT9ClU+u6enn9bjV8P4GVwVoKuTWpa5LiEoggZTBUeuwJRllaIBU8c/7J/nvJolRi1BMmKBvzr5o1r+wGNDDJ1QT2yUQPfAYR8SQScWKwoKa0IQ3U4GFCTaMMumShpRk+TCTyXmXGVILHRND6rlD/U4w6LR+YUsdmItNixT7/Y1B5CUUO7vHoqKfRDArQg/9qI4foA4rzYl6yPaBNjJ9HORHpYGNSOWAKU+UduwEvR08kxSZ45AZ5ITPS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in get_mem_cgroup_from_folio().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac75e48f144c1..9e7b00f1450e7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -991,14 +991,18 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  */
 struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	if (!folio_memcg_charged(folio))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
+	do {
+		memcg = folio_memcg(folio);
+	} while (unlikely(!css_tryget(&memcg->css)));
 	rcu_read_unlock();
 	return memcg;
 }
-- 
2.20.1


