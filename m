Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9EC3E9A772
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D28B6B009D; Tue, 24 Mar 2026 07:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C436B009E; Tue, 24 Mar 2026 07:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AD96B009F; Tue, 24 Mar 2026 07:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 222A16B009D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:32:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4786E0E07
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:54 +0000 (UTC)
X-FDA: 84580744668.11.5468173
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3572C1A0018
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZySGNuhi;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZySGNuhi;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774351973; a=rsa-sha256;
	cv=none;
	b=xoqPpTkNdNCBK5/W77/sT2ZhTfPO6QfRRM6UgZmvNbI+YRcbBHCywV9qnvcDqQPMcxe0Ey
	umpzNqQ+yxwV6MJwFmhth8/+dgShOI/HszL5vGq323M6w/tNv3/FSfTqf5gGSn73I2mF4u
	kfZrYxsSfcY8rYI4wASv79I2e4mgmwU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IejUNj93HPDOJC6LH22Ton+SsojJKZDf7R9i9HE2zFY=;
	b=GDPaehL3Cv9/EYSrRGQl+hdA1qDiQkq5D+TrU+4C6Fo2zSLGxxKB5qAL72mzDUP1MqLPn5
	wn0wAvhtg+UsNXfpsAqhsI4jj2BDLVa2SN/ewSjfj1xYSP9ZCBWAyEhyarU74jkqcAi7pN
	OW709Db3n8kUEFuDBP7qVOj4lf1GmJM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774351971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IejUNj93HPDOJC6LH22Ton+SsojJKZDf7R9i9HE2zFY=;
	b=ZySGNuhiaI0gngyRgkdvL6VmGn/2n+ANdZwGA29MAPaKAuouBVVNIReNd0r4uUeu7joaQY
	/TcRiamUigr7fvYSDTEdm4Fm+qyBz1vSV6AKx+/3LxrYKt/hRlOJHMcuoeoNQtHhCJ5E2J
	tf0jXJu9YX0f3plRIBycctMuakDmHN0=
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
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
Date: Tue, 24 Mar 2026 19:31:29 +0800
Message-ID: <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774342371.git.zhengqi.arch@bytedance.com>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3572C1A0018
X-Stat-Signature: tnqhmcy6hpy9s1x4tp337ngjri6fhbb9
X-Rspam-User: 
X-HE-Tag: 1774351972-486980
X-HE-Meta: U2FsdGVkX18Eu1B33+2lVjBl8ax87uFvUOFudZrZdIz4hjNLQd6HZt/y4jNkbUJPYLK3c+PadVuM9bObBQIq32Uzl7QRrl7fkC6roTLBN9zzPI1I5/vJAIiMIHfhRu1uBfFof/gSsgY+fiajJXDmgC5cCxWANiao6U4zdmqypV3jDOUeyc11NMz1qQ2BIDxCV05UsRF4Kgi+NwMy4CTPlQ8ame36LzjXTTm/neGqleTwGEO0fZAkSMFHcTmfHYx5CF0+ZC32Iqd3+cBjNxCWuWL9H67xNUIII8KjSajVWrudrEVHtVJ1f/Myz5tSEgoekv6CNwf5G9fobf6EaKN6w7ZLsK/mZ5vqRYQ69G55xniiO8V8cFxeO5NrTMN4o1auNLIuNa0pSIK9++9YnRJ0Ne0s9nP/pv7VGcu28U+LXR0ZesTF3apZr+XcWwekrHqNGOyA55x5aszFKKrT2MmFheETkY4SVzlKz3muKr+PSZ9UhErmN9XnWr49t+fALl7spqt9UE7tuSH9UzVNWUjsT8O3/7fKPB7TkCvek40rEq6DepxOTU1D/i3g5HhhFFXsFnLYcpWxDfyFItY6KhEOm3i0sIP9WvkbEgKXbJokIvd93xY/EBH7WnudZAgMZ4mnj3KPg0lsSdDsm7TTq6E5Wf5nDPLG6Ei7Vzs9scfzaN0735AFctHl118K4XwTplFzqiPghmlQYoS8svVIdn0WljAGCLjJ4FzT+lwVkuJlKKozKi9AkLV0OmhG+ptJT6OTyAJ1J9wBkCoDs/2tSkJfsTVou0cpPnQQUNWqvww23FOzUfsrKCYytzGDiXKXNsxl6Z0774oMZtusA//DCLPsrv8UjnHc9/TuRbCToG9fe/+qdTowAPWA1paS7jGclMwkxDNPsA2ra735pLmI2rMc5XVMso7fzXWElBSSoXf2JhaFiqbN97lMjRs16a2ga2iVRn03hpkUmFrHZFRd051
 VIkkOQYR
 sEGcWcugFqgJdg9xKI5ySFsLaRNVqFtxsQNPDw/ksgViIwvNZJ9hcoOOloGEBD7Jh2pAsGQaoXyLj3EJ59nOCW4AI04VJApfo1edXcwN3XlLtm3N7TVHqi4qdFYw4ZdKfw85HH1nAwY6IEinOTdfLrmyae2VVgo/3F3mdd5IIwPt6YrWcZoIn/dISko5v9fuUqUBlVLeaswkVjV4Y5aZWcZvIG4k6E+EnM1/SbvEXXQ2DYqlluWzD6rUeD7y8LhdPVHhVTUlHEk4goCA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The nr_pages parameter of mem_cgroup_update_lru_size() should clearly
be long instead of int, let's correct it.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 2 +-
 mm/memcontrol.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0861589695298..dc3fa687759b4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -878,7 +878,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 }
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		int zid, int nr_pages);
+		int zid, long nr_pages);
 
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a78550f6174e..6491ca74b3398 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1466,7 +1466,7 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
  * to or just after a page is removed from an lru list.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				int zid, int nr_pages)
+				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
-- 
2.20.1


