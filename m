Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A38D29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739AB6B0099; Wed, 14 Jan 2026 06:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA916B00A1; Wed, 14 Jan 2026 06:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A876B00A3; Wed, 14 Jan 2026 06:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 500126B0099
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:33:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20466B9A60
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:52 +0000 (UTC)
X-FDA: 84330359904.09.881E8AD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D6FF1C0006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OGrepS5E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390430; a=rsa-sha256;
	cv=none;
	b=ulVTn6D1WicqeB2C2mnM0d5yg3DKSXuiU4cYdBl86Eu2MYxb7QpFhuH8ctXdxV8DgF6lX6
	MwBIFY801ASBulYRgTRirIKu5IzZD1N/J40Ibiks7P2AqTBhDOK9QwHzMbmzO69274g/X9
	/SUV3e3eoacYSS61xT2tH2hX2J4BJBs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OGrepS5E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCcB0UGPb0CSzzkeBaE2CAurOVf6PC++ahaCYPhogr8=;
	b=jAR9e2V6auKYysi5ADBHhmiLjpo71idaOHLdiqnlWZ34/4257A9wwBwh1oNGPM7IvYf6d7
	7t6LcnIERem9zjBLX/rQxIA8JjryHeaWk/a67ccvrrTJ1wOuAC1rBeYPi0SJIVRNp79IYD
	hXPse7ZhsTtPlikHV97a9FKE+83Nxg0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCcB0UGPb0CSzzkeBaE2CAurOVf6PC++ahaCYPhogr8=;
	b=OGrepS5EADanSDbnfcHAHrI+1eYigZjnEBbgUYBgJdtCBcfId+muqORTBBvjhGmTBycGVz
	SB0/6P5mAPv56UDMtFN3er1Iz8WqARaPjEdd6X4Mir7G7xmNi3r/m67Mqb7d1FTfrKBXFG
	lKIcziY6h/BpCZGiRqLLKPO8jFCNZZE=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 11/30] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
Date: Wed, 14 Jan 2026 19:32:38 +0800
Message-ID: <1a9b3ffaa06c5e72a6853e3513aa6564164ed45a.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D6FF1C0006
X-Stat-Signature: 76trs8e5pqgnnd69udi9epthwuzxjutr
X-Rspam-User: 
X-HE-Tag: 1768390430-412567
X-HE-Meta: U2FsdGVkX1+71lNASiGcPUR4opjjOkWLusStxoR2GWEbiV6JTsvSke8WGDeG34p3qIEIKVAbEyC893bA8wLfX//kPkKjipBzlebAFvvvqDc5YxgwIDcykApjcWVWGJfTKz+sk4oxmIIaaDESKpcAJCLL+lMoWHOl5C83Bs9UUe34uEnO9Tk7q7nPOueo9rEl363SqbDc07fBiCEP/Qa0cKkTZtORVtAWaXJPvHVSzN7UvwhlH4WKhLFpqXkiDS2QjAU9wlFzOWz1aOIqAndMJCyLViqFm5LJzFeuNe13PXGfjsTmxWiEgdtuhtA0KwgvJQvZf1dypSZlYvB4FokXRsEg5eGcKYr+6iw/s6554vFc9saitBos+Glpgb3wAwlFTKR9FfvuQiQq/Dy1NOfTi5jYqB5Lzbr9/uSW/hVTX4gq7CLb7cUFDitVyLVfS6LwP2vCFrZmBA7Cd73bD6y0cTWjTUUIfWTAIF4pyej/ZzljQv3JPPHP8p7oZt3E3NtB+WngFoAMQ8YvVo9On13f2y8m4FH1Gx/oHxNaq+tSLbj+6PMJnIT7amgelQjhjr3P+d31i7t62M6jDpF1jIGFbfIWusQ8RB1JWZKwuKPpsriufJagGaFwH/C3zpB2WmElua6noeku2SrqWFt+IPAHxBbs/tNMvxiI6Hq+2fdgDe4yCvXZO9HvoF/6OI96sZ6Z0pGfNABuOvCXwIacAEMPaCmNhlriyYJyHvaBxTnhPrx8qqfesU9B7j1B0kbEeZwvfB5y1XfeKRADlrT9VVwzYPsK5nDR3L79rnI4I9Dy1Ot4P0uK3aElBncUC9Nk77s6npH48WVBWCQQCEXdNaUreWqUiw6GXVlR2QpQHrR5i9v+Lm93QUZp7kRaW0o9pSFXiFeB2X+259JXhg/ZccauXCgX2HYduZvrEZw8SVprhI4fFQK3u9di9jz4PdD10TB9eOluYnWiYqkSv7egmUo
 v6YDHvEL
 LlLi6lw3o8IwyM4GSvNsyGYyI9fanUhjrB1W5p00m/oSjad5rqgJuYyS8F9ScGj4iUtIgcQ9lLdoFSGfxuAZ+dEaC+xgFOhTYNEWH+q2luZ4hs7B9cJ4ZRoAeojKxE7BXdO5Qt3GOEag8T7n7ZQFiCwjozlXEvrJfvdSmC4Z1OCo9fEY15KP0zP94VTZt+E5rNn+Vyrgs+TApTvrWWmqcY6jz1nNBodZm1gdscZ1wY8OySvpSUp+ZKi63JzIwAPTCr0OOipDtPe4GrmMXbL7JXW44rWD3gb3Qzzcb5B9TC9BOkAPvyXO/T/ll/KipmuAlYKbIcDGATnNCiPgPvZGbJemtamSsXIuP93Qm
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
against the release of the memory cgroup in count_memcg_folio_events().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6b987f7089ca4..f1556759d0d3f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -976,10 +976,15 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
-	if (memcg)
-		count_memcg_events(memcg, idx, nr);
+	if (!folio_memcg_charged(folio))
+		return;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	count_memcg_events(memcg, idx, nr);
+	rcu_read_unlock();
 }
 
 static inline void count_memcg_events_mm(struct mm_struct *mm,
-- 
2.20.1


