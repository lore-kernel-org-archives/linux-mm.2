Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53834FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939AF6B0088; Mon, 27 Apr 2026 23:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C21C6B0092; Mon, 27 Apr 2026 23:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A166B0093; Mon, 27 Apr 2026 23:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60FD96B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:07:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9C968B82D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:07:14 +0000 (UTC)
X-FDA: 84706478388.12.D42FB45
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3904C40002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:07:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R5+J33wq;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777345633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lj79AkiwhWz5e6xPBu5nsEPq2wpNV8VJo+9BmZxFVVE=;
	b=pzzZWF6G12LKTCljCYqESrVzhWOyXGr1SiD3+vvvsSsQAoQ00eIt4hsh/sbDVL/0xWHI6j
	Gd99s76qxz7Jf8mKQMR43rtuLAd26+YmR0hBT/3/o4SrYcPpl+PHid/qn7xfNWO5oyo5M/
	0i4xeKg3uHXFYpnqQk8Nk1YUZsx+0pc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R5+J33wq;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777345633; a=rsa-sha256;
	cv=none;
	b=i4Qz8XsgXc/HZGil2TKWmRBkHJdXzUbyJFK+zTBTSRcZhU8RhFFGVh+CgVmojcXoV+f0Wm
	ji5Enk7V37CncVXaGaJEtmarhu01/6nUoYcU+P63cHBenmT8c52VHh6oyXtypZ4jU42UBU
	LdPqp5Bs1cQlvW1uUL6Fy8ugUYajsCo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777345631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lj79AkiwhWz5e6xPBu5nsEPq2wpNV8VJo+9BmZxFVVE=;
	b=R5+J33wqgrfyTP7mprG8tRtRvDSbVvl+WagRmGAVETaKc5A1vuK870hHrRk0d7yCYitD4Q
	t7cTXJJke6zsYX3ufm93nuVu/aYQ3FdD8nkQxGfTzRRtgoc+gzWg3wEfXsFwWkEzWXnpcu
	BE7eHp7UYSi+Wfp0+VcFtTWHF2BxzUM=
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
Subject: [PATCH] mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end()
Date: Tue, 28 Apr 2026 11:06:21 +0800
Message-ID: <20260428030621.94470-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3904C40002
X-Stat-Signature: xg6e5ycppzwarkeckppnjr3k59xiqah3
X-HE-Tag: 1777345632-307838
X-HE-Meta: U2FsdGVkX18Q0J1qTn1r5ZA/BZgYdhirFT+XZJwLvt3YLWTOHh9JzS9FtswSAlmzNarfz41iZhRShINj3jmALg+iJ7/IxGT4AHtOATW3meVdFMMPQKTbZPbSRsEmP+WZo4mlnjK9Keug5mpMxT8kqXkZ1YBhqzjVrBBylwaNtb22lfgz9tQosWvBn500fCQHVtLsTGXT54aHgoPtWbPOVMqg3nWMXO+xR/zATB8k3O6BPOm/Gi95fDx0Ssh3qFNkEGKFNNTbb6zBBV7BYtx5vQ8k/ek36wiG1RWefedlOmf9MZ7WLow+7PsO8i4yB9pvNYI22+Tz/LtGUEGYJTi9THCitsmZ2ee/TH3GPmL82jgHiDCjdBFNNRnhZVcq15A2PtNsdfJn3fkWUFbaZoCxglpze4Kbu+q5YNlPX/YjRdA8/vK98bb3KwiZVGTcv1+kjUc6oky/3Zo9+Pvtnp3zbd9XQzKybQbUzjTzbj0MWmM+MVc6SnibS40TF4LaoSqM2YkNjp3Y6RuPpEguDXJpPa4e9xF4nqb0BYFY99/g2RfwOiI7TZJUV15vHVTsUASTszQSwZeDtCQNeTRwE2z2qisLYUPLhFaK7ZRhUkzmVn2zwQKYVDFA17eBiankyTjXRfuKRQhnlUXIpMP6YcIp7AS7WzYKmmFdswTHChIejUkil3v1vwkSykCjqNee6haY/vptq9otMDq1P8d7fxRMnB9gNM7TfZ9qY2YGNiu5XfFdpCiP8zRtjzvK4G24LX3UdUmRmUo/APJR9Fs+jRJjDmGg9/EmgQw1/LxVFoTn7++uPFQgCeDti9wwexPpfp3oK5jU1trJSrjnoTmdNpcC3Jwgzd8JZNEXGc8OYlxHWY/utcObfGZtwQ+CThQVvuGbd/ZR9PWb38byucjSR9dpDVk3VzvLm3JEZ1zo3hB4z66GPLV/sVf0ScTsiP1edU1UApLaGLN0ZmTwkCocEdw
 JFh253rP
 80rl9dYkmlftEhoOsq/nHE70cHyhZMiN/4wG6ow0GNlMEJ3Yw5o0S97a5WBmFq4lFOYuC+r9FoYi7pGG95nrrYIrqbkjHY2xKkwWxTlZ1MEPU2Jbr6q1O44n79y1+TA1yczXHLVCBukAxmFJ+BQl5jy0PUec+lr5BKpbb7ckIfsKInb5rbrMF10Yv01hfaTcfUzmnFDkutVYohKbTag5PG+VyRFo8cPviFkFsluD13Am0xUbgcBD5xCvxZbUj6Yd86XefW07rlB3J4yng7PfwyGnFCN4aBuwK5UFPy+1KpNHLq+A=
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
---
 mm/memcontrol.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f1..38f48a45b7ae5 100644
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
@@ -818,20 +823,23 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
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
+	*rcu_locked = false;
+
 	return memcg;
 }
 
-static inline void get_non_dying_memcg_end(void)
+static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
 }
 #endif
@@ -865,12 +873,14 @@ static void __mod_memcg_state(struct mem_cgroup *memcg,
 void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 		       int val)
 {
+	bool rcu_locked;
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
@@ -933,14 +943,15 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
+	bool rcu_locked;
 
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


