Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDF8E9A772
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0536B0092; Tue, 24 Mar 2026 07:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B604C6B0095; Tue, 24 Mar 2026 07:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F3C6B0096; Tue, 24 Mar 2026 07:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9474D6B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:32:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66B0D1BA139
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:32 +0000 (UTC)
X-FDA: 84580743744.11.3B91D0D
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1CA4C0010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ieg4jbYX;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNYpUOaMZIeZUWxbOHw8FLcvpCl6K8p2fZA9SJluFcw=;
	b=KVnHPOZmfIFUWbe34DRSBOrJb1QgcINzVG1MOxlmeMN8JSXsIffMjc9EGz39tzxnFBA0rY
	JY4xCCLuD6V2wb4tGV9J40dj+F88XPNiWVKqgMLp4nUXjzTHQgMiZcPNRZ7CpdMWfKSNgH
	CMUTm7fm4B+oG08EWaP9anvukSQxieA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ieg4jbYX;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774351950; a=rsa-sha256;
	cv=none;
	b=dUKUquzQ5hwPZSkWLZCbGmWQYv8NgzcMJ3cejsAg7X3xKkLiOqgdRVQ/0Hbnw+q+DRvsAw
	LZ3Mb2f2vKdU9KU7yelTeGaqt8g8mB32XeBQwleJH/yIVD8fvM5pD1kBNFYHaKbqVYm2Vv
	C4WVOntlN+oj5t/UitrBMyeZMAIvXH4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774351948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yNYpUOaMZIeZUWxbOHw8FLcvpCl6K8p2fZA9SJluFcw=;
	b=ieg4jbYXQyfGbDByIxQL9Y6ghz7w9XESh4i7xYz6KL8RXyVjW6kO6tWU27EiTzzHjzwLZJ
	khFvHaxvCXrzVN5ss/OceXPXFAoV3kqiiMHZpHVSPjL9nAZk2AzX2q9C4wMUUeGBnt5Thl
	/Q4ckhoHwiyoKQewfEMysZU4TvgXFDk=
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
Subject: [PATCH 1/3] mm: memcontrol: correct the type of stats_updates to unsigned long
Date: Tue, 24 Mar 2026 19:31:27 +0800
Message-ID: <74022705dc8d5209ff7e603a178044fe4cfbae09.1774342371.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774342371.git.zhengqi.arch@bytedance.com>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B1CA4C0010
X-Stat-Signature: fks775yd8k1dey3kmreg1zzgtqnc3bmr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774351950-345429
X-HE-Meta: U2FsdGVkX19kw0IfXYEbCDxhuh4HzIoGUF/Ux5kG8IRZaQWyt1b6xKEBSpeA6KS9Q2RX6VL9IPOmIir11Qn8l4v4X5JixLoLwSH4jbFGxzG4XNHN3CEFH6LBS84MNkEYUL6dW4WqSBuGzYshFMVki4fFcborv/Ua6gJc7Ggg9VEuynbSKafnLexKQUDamJARWQKbO3ZEnRUNb3U0NhF6kxdqkN6RrYrjXx3/fahPS/MmXSsyPJle9yGaoEPvDuSnnMZuczgGmJBBIbCxeuAWbUlS3qfb1AFbSgqEKOzww3cK7xG6AV+Ekjso8fXPsxZcmx3YOfXlq1Vkb62otNzdEs5qUL8Sp5aZbKE3OtFbKlMLEnQTz4B9G90KYEzRHk0N59P9M9iaIPUULD40mYvN9V3Q4qkeZbnoFjM+BxqC0KGTSe7Y50WfMWaYw+nS49AN7VWjAEXJtujFhJuaIXy4Hw5YOqEEkKk6UUxDZiz9qykPixyMQnlAAH2I1REvqNsuqdENMlt+WBGxFRJZJY8lz4X7laSE8NpQUxoknI0GPsarMKJ9dgh8NW25bo3pBgupdkaND3esWCO9fdroumc8stNsHsETQoNGwTF8aJF4O2Io7wkY7mHLy4dRNb3jrsW3twgWriYwkOm5AsCK5MBOwXXu8i++uMptNw1BH+FGC5qGiivcxaBLZ76yChDWffW7mnGXEseRQr11Ljd5HJvfAdxweERsT6sH8XrUIvaXdOnjgDF31cQ5N/Z4HTbX34yz/HjiIoCH8fxpIxGGknNVTqvz1831V6epTWyiNZWEdfmCScNRSv6RJdi9lRv9VtSXNmzrAVBhTyrdf5RQHOjoBnWkHM2yKew5RS+86vdEgpr9z9rK6510GX0XnrnTsY5MphkJt/Li2V8cibRiVVn7DBlYL/FdByvyUR/mlteh5ADWbZKXJqzkYFYumhWngWXwlPAm6nkD1MLU7FCRmXq
 G23FdI3T
 31NU6gZPjsZbll3mKHUXCbatnYzmnsVZ8RunHa/KTG1ZNKDkfY4fFhewR6QArD/wsIgu85W/76f0FamPO636VePFGLmB2k4UtnwIWoT2dx/+Q1L1FMe9Q8+VFJeQMn4Ygo0zwWfheZpuKyAfl96Q50oaEz/b3KnVkCtAr8dyGw6fVUSXuxTHoqxm4eGtDOJXbwr7/hx3jV44rpu1bBMkmBeK47EUNxnDz0GgBYqIBUqY1sgEdhHYjjaSRtr5fvaZWAY5z4Ser8iV0Z+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Now, the memcg_rstat_updated() is for vmstats_percpu->state and
lruvec_stats_percpu->state, which are both of type long, so let's change
the type of stats_updates to unsigned long as well.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f1..7fb9cbc10dfbb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -608,7 +608,7 @@ static inline int memcg_events_index(enum vm_event_item idx)
 
 struct memcg_vmstats_percpu {
 	/* Stats updates since the last flush */
-	unsigned int			stats_updates;
+	unsigned long			stats_updates;
 
 	/* Cached pointers for fast iteration in memcg_rstat_updated() */
 	struct memcg_vmstats_percpu __percpu	*parent_pcpu;
@@ -639,7 +639,7 @@ struct memcg_vmstats {
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
 
 	/* Stats updates since the last flush */
-	atomic_t		stats_updates;
+	atomic_long_t		stats_updates;
 };
 
 /*
@@ -665,16 +665,16 @@ static u64 flush_last_time;
 
 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic_read(&vmstats->stats_updates) >
+	return atomic_long_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
-static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
 				       int cpu)
 {
 	struct memcg_vmstats_percpu __percpu *statc_pcpu;
 	struct memcg_vmstats_percpu *statc;
-	unsigned int stats_updates;
+	unsigned long stats_updates;
 
 	if (!val)
 		return;
@@ -697,7 +697,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
 			continue;
 
 		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
-		atomic_add(stats_updates, &statc->vmstats->stats_updates);
+		atomic_long_add(stats_updates, &statc->vmstats->stats_updates);
 	}
 }
 
@@ -705,7 +705,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 {
 	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
 
-	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
+	trace_memcg_flush_stats(memcg, atomic_long_read(&memcg->vmstats->stats_updates),
 		force, needs_flush);
 
 	if (!force && !needs_flush)
@@ -4406,8 +4406,8 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	}
 	WRITE_ONCE(statc->stats_updates, 0);
 	/* We are in a per-cpu loop here, only do the atomic write once */
-	if (atomic_read(&memcg->vmstats->stats_updates))
-		atomic_set(&memcg->vmstats->stats_updates, 0);
+	if (atomic_long_read(&memcg->vmstats->stats_updates))
+		atomic_long_set(&memcg->vmstats->stats_updates, 0);
 }
 
 static void mem_cgroup_fork(struct task_struct *task)
-- 
2.20.1


