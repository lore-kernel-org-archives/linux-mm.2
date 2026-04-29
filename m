Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02142FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F996B008C; Wed, 29 Apr 2026 03:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616F06B0092; Wed, 29 Apr 2026 03:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554616B0093; Wed, 29 Apr 2026 03:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45E0E6B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:31:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D86941A02DB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:31:31 +0000 (UTC)
X-FDA: 84710773182.01.AFC208C
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 10ACC20006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:31:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0oDga2E;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777447890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ba1LXb+IR29BnqyJkHs6D8UuBSkwHRvSb38v34WKljk=;
	b=BIDpgr1FZSaysftSfoFFgzkmnuWb3XwPp+qXjUSZQ4Sb65y5uKLKMt1TFh/5OhaVhESL0w
	wKkfAQMHmoeG1taLKnOhy4n0zqNaq/gaXIVLZvMQjeByzrEjufEzpD9mTEFmjAG9AkkuA/
	54AZ4zvmu2Dkq8PJUUvhywEHme40HuA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0oDga2E;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777447890; a=rsa-sha256;
	cv=none;
	b=XQ+0Lij9HumWhqb4ixO2VuNgP5ySfJgpyc/jsXzBYXCLX2q4LEeKVGmqa+XpbkFPTZ/8IS
	QEVCtsZv1cH53cCWPIIVtOvNLKSITF+KWeXFOwdUIr8+ZPDVdbrVuoKiLVvWx86vx8Z5JA
	1/8/i69RixdXJt0KQxv+Fm0q84jpsP0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777447887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ba1LXb+IR29BnqyJkHs6D8UuBSkwHRvSb38v34WKljk=;
	b=P0oDga2EeBVjBCpvBe1o82imEYp5QLXUHXJZic1IoN2Eh6SeNpSzcrcVW16/okCxYCWw17
	Wt5/+k7+K5PbfkfsbZfjV9y5qLUy5+YLYNVSlfILmMTu9JoejlARkoF8a2YIdK7B98NldS
	5DeHAI+clLgNOUHojxRkOyESm8PLEhs=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	yosry@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3] mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end()
Date: Wed, 29 Apr 2026 15:31:05 +0800
Message-ID: <20260429073105.44472-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uzmawroeko7rgwkxaj6qfd5i7bkipxdo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10ACC20006
X-Rspam-User: 
X-HE-Tag: 1777447889-448804
X-HE-Meta: U2FsdGVkX1/j+m2aqKP353azwIJatpQwfosb8gSZYkeyorZyWs2a+irU/FjZ/FB9KJDJwZdbe73G7Yi4yxSi6BqqIYwwev80c0E0jdHfKQd5q8rt/PISqZtRldmAkGpaKoTQas1byHV6jT7rUDr6W1Dw4SGsceRGDPVlg2LrP15V9FwQfY5D4/yZblhPXtJ43bGFBQbtzzfTdyx5or1Uos80JYi87ISysc4IvOcMdmW7XeiP4uL15rc35UR8S4NZ6eTD7fyn1SXjjM9tPmKds8yNUE71e1RoO+VMOI7EiVwx0HfSaEmGf1u1ILADrY7S8FTSdnjS7hEvI8qGiarG6qRS7fIWFFOzhUycF/7g0xtBeqyYFLxnNYxNf4aBEJ7aqzh8kAd/mFoVDQJkyJK5HOxFBTGiRyqSeEHHbVp1tRBpKOp2CNG9991tImMWTMlsCg3FUzopVqfIxoAx+z5xRhgCViMsFnRDRPjZV917KKMNoO7pTmM27eWAH5liJ3/dirf0w/RhY8N3F/l9ieKvBTMzqPhaQD92OifupzVvVE1pD/RpMkbLcx+GKliVS/j19FLkhYu4jlU7xSd3EdGHGPj4OoyCdswLsc5FsbCbQY0rVS57utjW7oGlhYP9i2DSx/4Kuoj4T8P7zQBxqCxzXhwNmssHwK8/gj68EazxKlq1qzBGYxUGGg7za/OJnd3Qjb2Okclv8q/ks+vpUqbgvYCsUdGUH4u4hiZ30wRZqQz0PU7E50MPlUowjPb7hT4xr15Mq9JS878X/1FZpot0M6jSdwcRycxcxOIE6hFWaCcj3AcRmcsVV4FhA3amDEo3mET8FyYg6w41Qd/f1aaRbCXAjDhHTcW/Q1LKqYXGmQh7iTMby1npzxempSgX7imZc6p0W/omT6YhylBNlYMSc7AqzalFjF/azRl1GNsojG4I0ferdA/vwZ2wNY1Y+9OhO6phV0WKMb40b3cviJ9
 lKbxQgPg
 n9+usfK9hCSEcK4gZwM7Ly7+Zwa/kpLjnA49G/rPj+dXqePrs/NVs+bOOi6lA2QxEKUGT/etbDpvH3SPO7HYEFb51rzZA7hUcgKyn0e9Gia+hfDDj/g/yxAOiuPMIldvIxhu1/sFVChXcCWn9soTV2KnC0uLaes/Y0e8ka9QauRF4Y58PNtdlYSV8Bm/LUk+adX9McVRsyirb3cA7c6igF0Vy98+fPthM1/wIAJDAskU4Hew3e2nsJE7vLc1UuP+U7PvqPK7UGZP18zrMmd7fkGayjR5l/+f9JMlfesc0N6hVloP2QTm+bzvNAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Currently, get_non_dying_memcg_start() and get_non_dying_memcg_end() both
evaluate cgroup_subsys_on_dfl(memory_cgrp_subsys) independently to
determine whether to acquire or release the RCU read lock.

However, the result of cgroup_subsys_on_dfl() can change dynamically at
runtime due to cgroup hierarchy rebinding (e.g., when the memory
controller is moved between cgroup v1 and v2 hierarchies). This can cause
the following warning:

 =====================================
 WARNING: bad unlock balance detected!
 7.0.0-next-20260420+ #83 Tainted: G        W
 -------------------------------------
 memcg-repro/270 is trying to release lock (rcu_read_lock) at:
 [<ffffffff815f57f7>] rcu_read_unlock+0x17/0x60
 but there are no more locks to release!

 other info that might help us debug this:
 1 lock held by memcg-repro/270:
  #0: ffff888102fa2088 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x285/0x880

 stack backtrace:
 CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: G        W           7.0.0-next-20260420+ #
 Tainted: [W]=WARN
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
 Call Trace:
  <TASK>
  ? rcu_read_unlock+0x17/0x60
  dump_stack_lvl+0x77/0xb0
  print_unlock_imbalance_bug+0xe0/0xf0
  ? rcu_read_unlock+0x17/0x60
  lock_release+0x21d/0x2a0
  rcu_read_unlock+0x1c/0x60
  do_pte_missing+0x233/0xb40
  __handle_mm_fault+0x80e/0xcd0
  handle_mm_fault+0x146/0x310
  do_user_addr_fault+0x303/0x880
  exc_page_fault+0x9b/0x270
  asm_exc_page_fault+0x26/0x30
 RIP: 0033:0x5590e4eb41ea
 Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 66 0f 69 e2 66 0f 6f d0 66 0f 69 d4 66 0f 61 0
 RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
 RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 00007f73c474d44d
 RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 000000000000000f
 RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 00007f73c483a680
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 00007f73c4869020
  </TASK>
 ------------[ cut here ]------------

Fix this by explicitly tracking the RCU lock state, ensuring that
rcu_read_unlock() in get_non_dying_memcg_end() is strictly paired with
the lock acquisition, regardless of any runtime rebinding events.

Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
Changes in v3:
 - fix -Werror=uninitialized (pointed by Sashiko)
 - collect Reviewed-by

Changes in v2:
 - remove unnessary rcu_locked setting under !CONFIG_MEMCG_V1
   (pointed by Shakeel Butt)
 - collect Acked-by

 mm/memcontrol.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f1..c03d4787d4668 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -805,12 +805,17 @@ static long memcg_state_val_in_pages(int idx, long val)
  * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
  * reparenting of non-hierarchical state_locals.
  */
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
+							   bool *rcu_locked)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	/* Rebinding can cause this value to be changed at runtime */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		*rcu_locked = false;
 		return memcg;
+	}
 
 	rcu_read_lock();
+	*rcu_locked = true;
 
 	while (memcg_is_dying(memcg))
 		memcg = parent_mem_cgroup(memcg);
@@ -818,20 +823,21 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
 	return memcg;
 }
 
-static inline void get_non_dying_memcg_end(void)
+static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!rcu_locked)
 		return;
 
 	rcu_read_unlock();
 }
 #else
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
+							   bool *rcu_locked)
 {
 	return memcg;
 }
 
-static inline void get_non_dying_memcg_end(void)
+static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
 }
 #endif
@@ -865,12 +871,14 @@ static void __mod_memcg_state(struct mem_cgroup *memcg,
 void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 		       int val)
 {
+	bool rcu_locked = false;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	memcg = get_non_dying_memcg_start(memcg);
+	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
 	__mod_memcg_state(memcg, idx, val);
-	get_non_dying_memcg_end();
+	get_non_dying_memcg_end(rcu_locked);
 }
 
 #ifdef CONFIG_MEMCG_V1
@@ -933,14 +941,15 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
+	bool rcu_locked = false;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg);
+	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
 	pn = memcg->nodeinfo[pgdat->node_id];
 
 	__mod_memcg_lruvec_state(pn, idx, val);
 
-	get_non_dying_memcg_end();
+	get_non_dying_memcg_end(rcu_locked);
 }
 
 /**
-- 
2.20.1


