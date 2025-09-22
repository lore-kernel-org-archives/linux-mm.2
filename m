Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E505DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 22:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABD28E000B; Mon, 22 Sep 2025 18:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83BD8E0001; Mon, 22 Sep 2025 18:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D996D8E000B; Mon, 22 Sep 2025 18:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7D058E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:02:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5510313A13E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:02:21 +0000 (UTC)
X-FDA: 83918260482.03.EEB86A4
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2292AA0013
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:02:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZIesPBQ0;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758578539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LvQMnsu791EG1tpjwy9I3544++reF65dwLMnGRELwws=;
	b=qkvfKMEuAtwqe6jjyl1IsqS0+QJLi7F/+Tn5PFpADbWst1K8lHbKCR9o/jAd88xQqIS+r/
	5UlhE9ZoSm++p/HRsk0u52VoiAt69EYNjwbp44Ro/o2lJp0VqQCUtLgQPsVpp5spWbprft
	yR9jkeOfBYOZydIhZC/+QuYK0b1l2qs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZIesPBQ0;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758578539; a=rsa-sha256;
	cv=none;
	b=0H30EKJ9t5Bq3KVGerGVN2pGMOwDBlo5uY47Y/7xQoZaOpIxBVSj8fTrB91rhAym/+iWtg
	HBU7WhiaX3Kj+ElTZPVfJbjpr3ftCJSeUpu66RI6FUWCtb8DUyCFebQ6RkKmo2dNiHrQNd
	C/OMZT12HSPxEHL3gW9cKquz9Lh1nGQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758578536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LvQMnsu791EG1tpjwy9I3544++reF65dwLMnGRELwws=;
	b=ZIesPBQ0zAl1Vmukqxmtt0XIK/MVh1ffyqQa8stAcXpFk9CsnyvK3u7hKV5bkDVd50Tz9d
	518QauXNlAT2j4sE8owNxzkvVG0kvid9zfQUuEIbqqYr7Or6i+wsuhQ7AAQ3ymIsoYuF80
	BhhlByeyTe56tg6TFdwmWHKUtJCGNNw=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Peilin Ye <yepeilin@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not allowed
Date: Mon, 22 Sep 2025 15:02:03 -0700
Message-ID: <20250922220203.261714-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2292AA0013
X-Stat-Signature: ujnutmh18c5upgrez5ddeawknijfxfmh
X-HE-Tag: 1758578538-164821
X-HE-Meta: U2FsdGVkX19ZztogkluKVVrkrmfC7aPWfg7NENvnCp1jTEb4+FdvQhcc6IcC+ATvEh+fFO4vMg0MnU1iiD3CQTnfHRNQs1/FjbVcUtC48mIF8qJtXVOdQLvyXyAzWvOpMtu/2prOf23tC81cWytF04nN3/N6kuwkDMXKPdomdSQdEZ1IwgZzVPXooUJ5NEoFsjlxUweuWJfTLFJTEECeydaqxuBhhStp73tP3yavG2Z1bG1CEEfvXxbcAxENW+IpPVTtkT6wSdff3Gp8jfKdfJZ87Jswadx7UhxwXdaEES8U36AplsFztaQ0zycaMv+fOIKPtNn/oJJhnSWZ9yKp2qsTssNOioY8kjISY+Yf3fJtCl7pEdhJLrOkLtJaWwrjs2tCcbNJtbZPs8SHuDnEkbod1UMZ/V3vZMprH7gueWrhnPu65tfRvwe2HhgiH1Vb+FgP39cb+zPmxnHe5LdRMyKgy/3N8IiRBTZuj/uid+9TSSjzLR3bnp3A6b0vAOUYa+zJy0RivbFADmw83BrbWkBlQFoC8+2TQt6HUkA2HLAG5S8OC/uNpYJXxZJm48ieModFdfaP6hn/xAIWiixE9vDoceTpCxoHBK0Jxqr1VnSGpSOzKyCXINu92Zfd6s+cnOaz3NHZ8PTlyO7TbrOHueABKcNgM+T2trzoN/AdmsrfPoAjDY2x0RWYJ7t8spxfzatpPv0S+z1BWjSuXJCLrQQF814nmruoI366IIb7tGK/TTl3rMGaZCup1l4A/W5dRC8rV3jr8yO6yfe9ITSPFOedy4vJd9FAgrSIR8iXDrSzMJrh4LhCpvgIHClApwq7X82gVx01pvdB2jQDik+vnwsf5RIsTZtyZopkftKsOiP2P9YubztR9LackdpjuJUMTkqyfNPOeR4160nG4qlcgQD+YGK9KJj/5Zm17OWRFNgejMBcwEKGYvIo+tJkI/4A3R0ci0rJWujg7SS3OwE
 0YJMk8JU
 hYjw5TtrA/i1gETXl1SyhmPzYu2bIFe1OLu9BeJF9ShfnSJj/XjgVXxY8U/g81esGCnAYtiDwHarSXTAX3NWb2rinzB/bJHNxkXJ9MUTBROX5SGN00rovIldFgKnYrwxTKbXc4WazVwaOyhs4IaDmW+M7QqQKBggdpl8k5RvfPDD7jUsoW3J/n9ZOgP9MF4rqFknYkrWcuaEl9VOcpl8i99jQFJRLdTKjIogNKbBq4vMSR+e9IxJwFiwxIv7TdlHnbLzCG0l68TBE5vdcPj5XsM2HcDi0JzLUkTVl+VaiZUOZPfZN4/7mJHU7vo0VUu2yYDuFH5fBvBtTiEFfutVhXv0LHDYZRHJDbLNjXxK5M2ToItg6cdO/NBARRg6aFm0dYkoDC/56dKzN/KebUqtFxpoQHuXsHI1u0KGR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generally memcg charging is allowed from all the contexts including NMI
where even spinning on spinlock can cause locking issues. However one
call chain was missed during the addition of memcg charging from any
context support. That is try_charge_memcg() -> memcg_memory_event() ->
cgroup_file_notify().

The possible function call tree under cgroup_file_notify() can acquire
many different spin locks in spinning mode. Some of them are
cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
just skip cgroup_file_notify() from memcg charging if the context does
not allow spinning.

Alternative approach was also explored where instead of skipping
cgroup_file_notify(), we defer the memcg event processing to irq_work
[1]. However it adds complexity and it was decided to keep things simple
until we need more memcg events with !allow_spinning requirement.

Link: https://lore.kernel.org/all/5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
Changes since v1:
- Add warning if !allow_spinning is used with memcg events other than
  MEMCG_MAX (requested by Roman)

 include/linux/memcontrol.h | 26 +++++++++++++++++++-------
 mm/memcontrol.c            |  7 ++++---
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 16fe0306e50e..873e510d6f8d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1001,22 +1001,28 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 	count_memcg_events_mm(mm, idx, 1);
 }
 
-static inline void memcg_memory_event(struct mem_cgroup *memcg,
-				      enum memcg_memory_event event)
+static inline void __memcg_memory_event(struct mem_cgroup *memcg,
+					enum memcg_memory_event event,
+					bool allow_spinning)
 {
 	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
 			  event == MEMCG_SWAP_FAIL;
 
+	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
+	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
+
 	atomic_long_inc(&memcg->memory_events_local[event]);
-	if (!swap_event)
+	if (!swap_event && allow_spinning)
 		cgroup_file_notify(&memcg->events_local_file);
 
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
-		if (swap_event)
-			cgroup_file_notify(&memcg->swap_events_file);
-		else
-			cgroup_file_notify(&memcg->events_file);
+		if (allow_spinning) {
+			if (swap_event)
+				cgroup_file_notify(&memcg->swap_events_file);
+			else
+				cgroup_file_notify(&memcg->events_file);
+		}
 
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
@@ -1026,6 +1032,12 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 		 !mem_cgroup_is_root(memcg));
 }
 
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
+{
+	__memcg_memory_event(memcg, event, true);
+}
+
 static inline void memcg_memory_event_mm(struct mm_struct *mm,
 					 enum memcg_memory_event event)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e090f29eb03b..4deda33625f4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2307,12 +2307,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
-	if (!gfpflags_allow_spinning(gfp_mask))
+	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
@@ -2348,7 +2349,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
@@ -2415,7 +2416,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * a MEMCG_MAX event.
 	 */
 	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	/*
 	 * The allocation either can't fail or will lead to more memory
-- 
2.47.3


