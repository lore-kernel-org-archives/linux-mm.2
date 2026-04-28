Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03721FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDA76B008A; Tue, 28 Apr 2026 06:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E6A6B008C; Tue, 28 Apr 2026 06:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3949E6B0092; Tue, 28 Apr 2026 06:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 281F76B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:31:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9652A059D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:31:35 +0000 (UTC)
X-FDA: 84707598150.11.C12516F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf17.hostedemail.com (Postfix) with ESMTP id D467240002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:31:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VPcuSwBQ;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777372294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GfD44pvjIJQiloqBwDkzUp2PEMv63WqNX+o/AM5Jdnc=;
	b=iIlMEE1hJsCM1VNM8+vGhKXtPk9sRoFRzOiscAxjRmrtMvJQgcIhrMUH2Xzqta6gM97MvT
	obW80kZEF8GvLa+Vmx6/IFebc32LPHElHkPqLpouaBOP16g+Kh+76+eytkWb+CvNMCHeuF
	K2YbRxFkh6hMbGDnp59VSNncjHK3biA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VPcuSwBQ;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777372294; a=rsa-sha256;
	cv=none;
	b=thNsIuNcSb/Hg3EqcDiKkzvYVQblrMzk0bZF4E+DHI1SzpUOZ6+Zsep9klW4SuCr7QNJ5q
	aoJaYCMqowA7aTUENnUncY0E/S0hdUV04Ny24Y4z3F4b8UIPg2Svw/VYwzrrF1xy9ZstuM
	guEz3Ln1E4pz4qqL7YC6hd1Ia6ZsIyQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777372291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GfD44pvjIJQiloqBwDkzUp2PEMv63WqNX+o/AM5Jdnc=;
	b=VPcuSwBQvNR3K0qe6XdIc2exAZLvcygNpypa8DFTdzkJhnd8Jn1wWbqnSooLVIJwjdvrp3
	g+qSW5heuurHzYUsJtRmcPy3OtNwMVL/UitrMBd7lXT40ymkElYnTjqEV/RltQE72mFhak
	obmj/4CKJzwT4/n/uwgdXo2NebuFA4o=
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
Subject: [PATCH v2] mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end()
Date: Tue, 28 Apr 2026 18:31:08 +0800
Message-ID: <20260428103108.45719-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ub6rry8ecrouhrqydt7ksrbczh66ptz8
X-Rspamd-Queue-Id: D467240002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777372293-20009
X-HE-Meta: U2FsdGVkX18ShoNJe0lXi7BbwQXYGcELk2534u5JKV5z2iOEqNTNMX4z1wg+DxB5yCWdIz9LrNAJx6byUCG+XCCt0BTO3LyeL5pWh6D4BOAsFvm8hM0tQii0NlIElHpP9A80vxgn54vA8SjuyghoK6eiN4O0qGX0AVRy2ZqzekJeYZ4TvILTfMr0bzzpZ+2VliHnowosEpt0iQj7V3CvXxGK15XG3eaVgfqdjekFPFo2iA0lF6V17IbL8Peu5iI8i2LOVfa6ce+L4pUIUw1vJWkqGQ905ow7fR+2s1FBGlu/Tl+kjPmyef+7DtqBZDOzwBeJOia2Hyk9lk8tnGhjJjZiCe9t2ws+jTJsOCe6qCLPcM6CEpCEaPrsk5/C/brwqX7I0oqU82nOOtpqrOy9wyAmPZq8IccOE6GMSXVZeK6jrZa4U94EnKfiL+JSqw94GB0jUBWzD9gwcgaHabBMrW4zWp89S2NzhN7DRC/eegeyjN6HHjC30ETSjcgeXonHkfW9DSgM2pu0gMnuzVGHoZ+OKmw16ZtU703FrVk64gtoRc4kdEO1CnC4064ZwHimPB0F/ic/jRJLlHcUrOXPmXphrIZyImWHrZ8se7IFa3TieTNzt94aeHZp4/cmoqH3zaKbcO2dl5nh323q2L6G6NrraNFoPHUfvTETSI8LsTxzfajg4dS8vpLHoBXBjFnP0GkoRw/ITMZcsnf9Oo4AaTvP4H8/loHfSK9KOPLzki/SHlYG8OEqwLXFy1cYaUfznCdxkpQrAjhgJfIoTBdrK76MT3pHUDPfA5f1gEXbhOwg+fHo2GjVq1D/SOnzWU2hBlmr03aIW18F8iof3VfdCr8WekPn64Fn52INOxg2I01uIRgjqL3L70DZ6v9jsk7pQAufGIosv7Q/E/sgZ7Ip2ZUPUkZQTfYyC/N1qTfwhX6OCWuEL7ulupSAwBk6vPXHkjLoDG/u6KNCofOTgaS
 z4lMkO59
 GV6AU8W3FeMfzBME4nkcC4/4Ht153kXgChSPdgX+dbDPtN18AETVqUiZbZ9fZedQOJcxwrWhTwV9xP7ILgc7U92rk17WZ2+enVtbqB4vg5dRbBYd9094N6To+tcgKunBcaFIN0s08R62fT38wC3DotdYqQEBmWnRbSGrKeNUBYxgZFfn4Ti1Fz/mVtXcz2ds8Hum50zLW5C/9jyIna7Jeqg3iawB5lO/jcDIK+Ta5a+j2zO1bwVGhoQRCekNrFI19oAPJ6SJjYofHPTg+1mhuGDFJIXQ5E3jtZGwdf4lIWhjbndZGcGGJ28p5mA==
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
---
Changes in v2:
 - remove unnessary rcu_locked setting under !CONFIG_MEMCG_V1
   (pointed by Shakeel Butt)
 - collect Acked-by

 mm/memcontrol.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f1..eb55bace9f8c3 100644
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
@@ -933,14 +941,15 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
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


