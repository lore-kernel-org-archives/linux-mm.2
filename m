Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE2C3C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C407C6B00A4; Tue, 11 Aug 2026 16:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA2C6B00A5; Tue, 11 Aug 2026 16:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06DF6B00A6; Tue, 11 Aug 2026 16:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8718E6B00A4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEAE2C015A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:48 +0000 (UTC)
X-FDA: 85090137216.18.6A1387D
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E70080008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tjWLYDoX;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Q4GswXsYa23HjspIYsiXDi4Yy+VY6y3TioX/Zf5Hfc=;
	b=CycKaqiZ4EqdojEBZqPzohf12ma/QatZtcpSsfR7ETm7ZtEHAuOoABI8FjY94sYpEXTnAP
	y/KUD9Cdu4/EuFhZzK7NQt6N9f4CTnQM2/mApzONnulsHFrtoGvPwJdaIPJOHHxJiHw+RK
	T6V+Y2dx5r7rGIzEACiqk+In4faHs5Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480367;
	b=YhXDt0PrBP//ctaB4FGFaduyVhtePFMLXQfhIuJd/tpE/Fac3RKdD2acXL/KdVlht8OHlh
	i4ZfDpr8oXlDceYsubMN51PBmNs1Xde4xi9sReecgi2t8Cca+4S8y07sQ7ylmUcu1gS6Ze
	j3Xfb50Scy0RMLzNjVZU8GyiQH7sVKk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tjWLYDoX;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Q4GswXsYa23HjspIYsiXDi4Yy+VY6y3TioX/Zf5Hfc=;
	b=tjWLYDoXNvQDIAuW73cOM4BIp4z0OlAyBGCwh4bxtqlJ2fpxssixILMpQuX6ySxZ9dsGWm
	t0/Kmbh9XwTL5oDehABSwwMvkVmGStIVxebzieS00SwnrQ5eUz5rJet0XjbwZp90GrwcOb
	9/zoKxC2UKg06CoyX/oIWVH1BJFijFg=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] memcg: remove the per-node soft limit tree fields
Date: Tue, 11 Aug 2026 13:32:01 -0700
Message-ID: <20260811203203.3456029-8-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 797q9saxdmdsgcuy8wwh685wukbos8su
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E70080008
X-HE-Tag: 1786480367-66026
X-HE-Meta: U2FsdGVkX18XT1nP7tKD5ZFaWs+HBD8zqsC6LZIwS+T4cmKd6AS+isQLw1IXU9hQDlWzpOTe21IFiIlfAsGAMgv/9ShJTSprkltJDqD3KqY4IIRYg64T4cva7UbLOoqpOvRVWyYIklWwDHqCV9lUaVFUQkTQGFW6FJSzlvkxis4ORPnAHqpfQWyJ4uHzD8tpo3fnMDGzce99pSkrbiKPCnXa4gnBLNbGCJT4TFwA8C0HvncxpeGarAazHtf6NN6HXm3705CaNGD0Sp61gBHWDigg/hZhqDLWF3RwUuZetZROfyJW9oHH6Zyl/e1QDGa1SACBePjIYv+6vRnLM50Lvu3G6he7pbqwiQM6XZ2tJiXSn0vZAUEnMcXRxphKwkCUJdV/TpE4MXlQ7zPeuf3mT31jVLPiBzbDQ+g9WhL+5cgTGjZ1CK9Rf4s4a2y73DF4XRaLs7ODx6nMu3sknAU1TF94F+15ANYHcl594/9nn4YBrpiyPE9tzMr0rE0MyXm1zpWjmDV3OFSA9DAG8k6giwTIfXofgS1A692JJECTqaqcrgOeRQRrcICkMjk2HEDO/M87Dj0LSKT5oXH4g/URAr/0S1mJyaAsTu3XAmCS3Zolbdeu6kksyMXEkhyGuVvXF9tRa+yUKv3fZIxQnGgsrwvnqdNRUA6QO9PZUZjJ+bcL/uUKIG7qQ7q+Cdl5q0FD5BvNalpqoJeWCQHI0sIKA3DjpwKq3++2fBtq8/17N8bTmbf+oZv7lJ6hBxdYXPaWb6P01lFqP3TIpWtqZWQIJPwpH5/2/5dH31/UfH6PAd9n0+2BCG6g9efN1HIP7hCLLYhjQBv++fPxqVzGgxyPjGTaQxYWQCR7vuO/1rNhIUgPvraK6E8DYhGesh0RRhIcDBo4pxMv+bpF5xO3YiNUoH1LCt1mRYru8cQcKH4mrVRqUOfPpdxadNYz7ILCkAlWsHAhpYukRY5aETX41lZ
 r0Olstww
 3+lBb8i0WF32gOyoC/bJ6miO6pv+y7kw6LVG4FZgYLUB1QbkUm9LM3jU1BWQS3MZp++XCx++5A1TOr0SWd/VOZ5r2vPurzZgDHrRswy9zwdayfE56l3EW63/15dpXrMIbhdjjbvIN4DTlStqWpLyadmaTA6QCGLJOCTG12hxgV4UvZvL6ONAcFFpU930o0Mvz97odJT4r5O5x26s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree_node, usage_in_excess and on_tree only existed for the soft limit
rbtree. They also doubled as the buffer between the read-mostly head of
struct mem_cgroup_per_node and its update-often tail, so replace them
with the explicit padding that CONFIG_MEMCG_V1=n already used.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7b02f1b3bb88..ce24e04967d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,20 +95,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
-#ifdef CONFIG_MEMCG_V1
-	/*
-	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. If v1 stuff is
-	 * not present, an explicit padding is needed.
-	 */
-
-	struct rb_node		tree_node;	/* RB tree node */
-	unsigned long		usage_in_excess;/* Set to the value by which */
-						/* the soft limit is exceeded*/
-	bool			on_tree;
-#else
 	CACHELINE_PADDING(_pad1_);
-#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
-- 
2.53.0-Meta


