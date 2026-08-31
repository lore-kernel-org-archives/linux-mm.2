Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA31C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69606B009B; Mon, 31 Aug 2026 05:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41046B009D; Mon, 31 Aug 2026 05:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FE36B009E; Mon, 31 Aug 2026 05:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 770D66B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:46:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AAD3A03E3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:49 +0000 (UTC)
X-FDA: 85161085338.20.4BD36C4
Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	by imf31.hostedemail.com (Postfix) with ESMTP id 31D6C20003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R9okeS85;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788169607;
	b=rvNd7mWtu2eP9oOS/MXP2rKHsI2xpQL2OqH7GmpqkQy3G0DKVPf39YXtUBRfppew8+kysu
	XZS+pC90Nne34VoPxvg8q3QbwDQ2+R25FyE1oANbLu0cqF7uzCSUqtzlgqA8y7WCSRH78B
	t9r0UmHUvMbIjYy9mpXI2K0jaf+7io0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R9okeS85;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788169607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIS9Ot1Mt8Mugjw08/u2wRJivxgb7JgzvGqihQuXeJ8=;
	b=4+lhlBYPItPtM+V/NR1MFCuqLF020CapsgZkKhZJnSfCSrNg/v135k/5wG/Qs1x9dZcYT3
	sy+x65ewHjBDVH/j1IueLTASEJfQN0YUWMvIoIEi0sEfjc1OzJdDEJ97I468bSGzQaH7Mh
	7vD7/jkij5EAJqwjy7sPQ+zPW2I3cqU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6jhXtJO17DBB7qI18ikslI33Zv8zYlXSXdj+9tIORRU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788169606; v=1; x=1788774406;
 b=R9okeS85NqmAhuuAI7UUSUA+gI3T5d+ERJZYJiOBuYL1RLp2wbwHaDrtH9fIzOcPPCJEwwUC
 Bq3X5qSfk2XzEJTjavH521qet+xaV7O9xvZirr1R7J/vof1BjLxK1T2bH8n5vD3/qhR/d7n1/jm
 6ogAeuxtWZVh6jibxEKal1WQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8bffe5621f7da27d;
	Mon, 31 Aug 2026 09:46:45 +0000
X-Mizu-Trace-ID: 8bffe5621f7da27d
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2 3/3] mm: memcg: skip the RCU lock when the memcg is not dying
Date: Mon, 31 Aug 2026 17:46:11 +0800
Message-ID: <3fc10f32131097bb57efaec72d049d635b227cf1.1788169145.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788169145.git.zhuhui@kylinos.cn>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 31D6C20003
X-Stat-Signature: y5ttcggw5m1n9jrgsudof4yyyjj3twd9
X-Rspam-User: 
X-HE-Tag: 1788169606-865492
X-HE-Meta: U2FsdGVkX19zMRrySFUurduW0hUGinM6qB2hIZxFxfuYqJaAaEKtsp1YjhODPTyWoXIN0W1B+6x1L3R9wkK2gGqkz5b+YtQRCpaVUkfxJ+P5nv/qZqtDemrh+CZepiLCBuKX+GFZDmEtrakRv8ZpxUo6CXhlind0qKFWYJtnQtebecWNGBTHuzuW0vCZ1YsiZ+OuJimJzEx9cVotDk+sQXWKbRpspub3ypTwtJ7Qu2z9QMRaoVREkphsyqwVh9Ha4byd/9cWD11impap/E1Fybgt578p5ogMJXvDI0kS/VkexOQ0esecHpZIa94JqvqK70X9ywpaXtf7uBLnkalgFqKgcntwD/ilHjO8QWb1AQjplsBR8W1kgoDQZaFph+BBv1gCcIQ5K2NYkY23SU07C3XLrQgufqnvJIkgCqlXwhroDbJU17MyjHixe3ue0OG6a2utrmBfdlLebrXsKYRoi5UOgjLONVxyXen21+W11GfJ4tQp0E/HoQ0zpH9nLfj9dl6BlPSW5K43wX9iH/9atkmNIM+sMvhKVbZyDkz53amCw6W9udMUL9moiabvEoJ9eigZMmxjSC6nKGw8QGBY2lssp2zLPTNmk40+K640EE5MqbMlgGDa4jnnuf1eZteRDyMh9BHCTVxymkDI32hh1kOfb9Ncsq8C5+cMq32ChVk8g9bdPQyx/yXAm8yOB2HNuDPbWA3tE8F5oRStvuIab4NfuPZnvl1B6VjBmJ1ri58TBvNCj1OMGG07mqwnefbamiJsgWhauwNtxuiDKjdDd7oWdUO95w9IwrS2JpGdI1Hej/OFgGQQNl3mYMzmD6jvgi8n+MEOfN4sm76+yy4xMFf3rT3i+y1adqkwfzXjOxeyqsx1/S5/RNdDzDivc95dXv0RpTIr4RKg1oyyen93AwIcVQVd3gT3YVwrO4nPU4xWV2rh7erMkHzTqbQ0t/8Thq7jm7tllPf8d7TwxTI
 yNNnb0mT
 hBeEdIYXD2+pPL42ODcIGUHSQn4u2hagzfF/ssa/0jmRG1I3Wh2bnB372VRtaJ1DnDohSe1yREYdEMjTJhmU9sPdXJnZtNd/nU91orcUewQ4ZgP5AJocwUwHBOsvC3UQSzUcEOlEI3WV4khfLUC1tWiP+513e9Ohr9zuTR4pWun6Z3G9giOn70oi4jXIMpWMkv3+ZZY+oArLS9OfoAa6kKNqhuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

get_non_dying_memcg_start() takes rcu_read_lock() on every stat update, but
the lock only protects the upward walk to a non-dying ancestor, which
happens solely while a memcg is being offlined.  The dying check itself
reads the CSS_DYING flag of a memcg the caller already holds a reference
to, so it is safe without the lock.

Check memcg_is_dying() first and return immediately when the memcg is
alive, taking the RCU lock only on the rare dying path.  On an anon
fault/charge churn workload in a memcg this recovers the ~0.6% overhead
added by the previous patch (4368077 vs 4343159 pages/s before, back to
~4377000 pages/s after).

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b3d1ac3fe0aa..f454d02746e9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -813,6 +813,17 @@ static long memcg_state_val_in_pages(int idx, long val)
 static inline struct mem_cgroup *
 get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
+	/*
+	 * Fast path: the caller holds a reference to @memcg, so reading
+	 * its CSS_DYING flag without the RCU lock is safe.  The RCU lock
+	 * is only needed to walk up to a non-dying ancestor, which
+	 * happens only while a memcg is actually being offlined.
+	 */
+	if (!memcg_is_dying(memcg)) {
+		*rcu_locked = false;
+		return memcg;
+	}
+
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -824,6 +835,9 @@ get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
+	if (!rcu_locked)
+		return;
+
 	rcu_read_unlock();
 }
 
-- 
2.53.0


