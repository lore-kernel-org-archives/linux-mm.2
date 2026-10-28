Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B79606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=U6zeJHOz
Received: by kanga.kvack.org (Postfix)
	id A1AC46B05B1; Wed, 28 Oct 2026 14:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CAD26B05B2; Wed, 28 Oct 2026 14:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1C16B05B3; Wed, 28 Oct 2026 14:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 598616B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:35:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BBE7A01E9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:35:43 +0000 (UTC)
X-FDA: 85372888566.18.42389A1
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id D07DC40006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:35:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=U6zeJHOz;
	spf=pass (imf17.hostedemail.com: domain of 3fEDiagkKCOMYORJWHNJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tjmercier.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3fEDiagkKCOMYORJWHNJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793212541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4eOYqPDRiAJM8WSK8cz84JY8oCFHe+0xhzQ90c4msyE=;
	b=XOhRE/cqTpywliIU4JcFxi5qmHRYG/bgKiNkWZ2SHtVgS4FUhZkb23izzzZ2u3RdV/4oDt
	mok13KXHjAQAbO1pDzDjY+XTmFqInfxbkGSzbFs85oGsRCgVCq8v5fg3XpaZiab88quwJi
	g2Xfb8M1MFavBry56PvdQrTcaO0Iiqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793212541;
	b=zPMSG6yjRsQ4sBFcBmf0ZXFXwGxB8g/o8qoKq/z7y1lPS/UNMC08sElfZbdXPzN7SBm2St
	YKT7+dzRYq9Ze3VRJp7qbYnO2WXyNuoJmRyaUsQa5VQpfItLpQxRjIwPB1RylySmurOwVY
	ZY+f59xFvhseAGm6hinEv2N2/MztlVU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=U6zeJHOz;
	spf=pass (imf17.hostedemail.com: domain of 3fEDiagkKCOMYORJWHNJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tjmercier.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3fEDiagkKCOMYORJWHNJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ab2395f104so1055366a91.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793212540; x=1793817340; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4eOYqPDRiAJM8WSK8cz84JY8oCFHe+0xhzQ90c4msyE=;
        b=U6zeJHOzrzgVmoZFvDfTbCLRzvJj+jIEWkYMv9lQuZVKlfqT6hJdo45PRe7e3dyNmX
         XQDwYBVCTq4ZuPtSPD7GGFlGtT9Op9SEZ1tremkC4/yySb42y62439QZRJOvvNHW15ru
         ZSVDSKsOOeAMue6p3Cdy8AQpsipLVOycpgHU7QupyZbyCzWliFZGBZuB4vfOO4Pyo8X5
         5P8l1NvuY4/vsC65Esp+8OTaTLXJcoblOIdCeRaY7v0bQj8R9WYeQ6oA2Zzj01pypDqQ
         TCbj2mthtlSyiavV8WzjDdscTUVsupD8Cn+ohHfCVJV4aVeaD6dyA+3KZdnKNQPyd5Fb
         bDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212540; x=1793817340;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4eOYqPDRiAJM8WSK8cz84JY8oCFHe+0xhzQ90c4msyE=;
        b=DuNda/7S9KuX3/JzilzttOXH8aKhlKDoWqMg38ya+Wr/htVg5NEpy/9TlhqPPnDICv
         PMb1criIu4TvHxzNfqWktE5Us24ipdcBm0p7JqfyY9fTgOGGflI+SwKqSuBMv8MNzJkP
         HXc05DEsybT3YjeqKKraExArHdZbCKQDWKEB0yPIO80E944QnTc2bRudPJq0Oy5CQ4uW
         NRt2rDfsBfJvO/rY7j2cQQcURZTRbfkmmyP0almzoGtG+pIh98fNWmnv7qPhMKmgSUto
         fzDFqpz4nEjERIGpzXV8LyLaK759kSk4dcfBnE9ekgdAIS8VydsIqED6xGiTxuJw2P9k
         WJUg==
X-Forwarded-Encrypted: i=1; AKwUvBznhfbcRUDhIc19+ETU2aR6AnMrt8IFgsUx+B9GxsgSFXIFwlRiF2wWB8KRTuBt76z23P/pFE4TKg==@kvack.org
X-Gm-Message-State: AFq9FYKskFSOBkQM6muVLhAZyd0JSZ3IRDjPzWrISxnX+iR0BwLJSFg5
	HWgSvzT4MB/8AJ1yXMQyrlqb4SQjl8xYl9aCXoc48CythyzwqjOLvRTKXkAnWoxu7FptwzED6oR
	RybNcJpDE1nJcCtweCg==
X-Received: from pgcgn5-n2.prod.google.com ([2002:a05:6a02:6a05:20b0:cc7:cb66:8df9])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5252:b0:3a0:516d:9f87 with SMTP id 98e67ed59e1d1-3ae580a9d39mr2315489a91.13.1793212540177;
 Wed, 28 Oct 2026 11:35:40 -0700 (PDT)
Date: Wed, 28 Oct 2026 11:35:37 -0700
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028183537.605854-1-tjmercier@google.com>
Subject: [PATCH v2] mm: memcontrol: fix NULL pointer deref from
 high_work_func() on dying memcg
From: "T.J. Mercier" <tjmercier@google.com>
To: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev
Cc: zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D07DC40006
X-Stat-Signature: gikfn7no8h4ppeqk5m5z4m96dnqbyoz4
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793212541-447207
X-HE-Meta: U2FsdGVkX1/dpTLrp/UGBfBA1tObNoBwcgviGLr6TbN+9WcLTL2X+6DYpluBDsNPNKN4gMBlNImeRI221T4VRPS5xlBb5QYGVVlihWBI1796lDssMi0V6+ox+DKmjcT3BKsNEGUL6REgH+QjI+/T0NdV3X8Zmb7YBZH2/l9idF+2WAgihUOCTZ/RRr0BgCjRbPqIWV51rvFGVt91aQWcaJvEUSQexj1RPsvLALO9+c6uur+CYiuYIEcGU5lSqWgyAB3lqHMcz3I2lRPtNGvcSu2RKzgTkJ4XazvYc+w7CjUxd46zJVRjVVO8Z90ZbhWYyVSFYPV+Xdn0zOMRC+ZBpo4OJluz2MCOwgXI5JtDBtrUwaDZ+fSaNW3Cmcc9mzoYfZrQXFTXJuS5pZjQsQFWMIIGOaRE9FLKeNYrYcU3wmCnWQAvWg85qiwWlsQ+PzSx1XroHeY6iao3YYKfNa1GyQT3CzkEyoD3A5t7gsZladqmLN3zrPVn8gm6w3N/+xhxSD4ihJ6TiIGDi9z9xKwXmzpKOqt+eb/lH+KW6CwQTWEMjIoTxx5a77XBq6LGtt0WkYcaMK/vfJy2fdNkSo6KJEWl4JBG1cIyPMRA1Mc2BXIyFUUQ9FhnkqVxQPxgG2dlewMpZNazKNhiCETqB2BC3SVfeM0v9Jc/e4WjfkOG2kv3wFCrc0KgrR1KE9zHXvFhCUk3ry+WTX2On1SFd4t5vsRH1xZcPMLit25O20ZpdOq0m7tT3ZUEpLXv1/kaJegJQkABJP/alwqet2RVlZaENc+zAQE9XOojyR9p4e0Pkpkyyefoe9Yms6SNWw1BHeHPzAwT0tyeu/F/7Z2QLjpoyRoK41Rm/Acg+WxVyWllmnYPgdmb6EagcYFqh4BuM/aSWQOQLkMT1DIA/Xz/fjSoLIIktgYxBDOh8JP0oQ0fc/GI6r4A48iDUUxzJ8vpbUYqxIDZJlJkI+cjEZs17s5
 hgSb5DW7
 9kF89J9eAx2CQSxOArwfSaa81zMWBPHoDtwCG8xWPF4FKRyDg9tbgLIFHAETb4GYx2E1FMzZ7gdkgOypgWezm0bNfKSSgsixwrJiGa0ekfMMj88UUku5XvOpzVodtuZzckhYNGE2R4Kdu717GluePCxm+4y5nnIeTLiBYF7YNj+2Jkvzi/fS4Kvy5lpjGFMvvq9jfNprqW33Ry8/r3Y5HWwd2+CCB4eWJXBUoux4HNb2nA0h6H05235kccbXfoFK5kYi/ztR6Jin4yFKCpXkHbs0Is+0uQAphOSVMHBf4YzN6rxSuv6BU39o4aWzRmwObyjh2W+DSz/eTUhVYwYkTW21mV33554E6nQwSrj+tpgCNLN5C86fOrZPHlvsItCXBrTvdphn6TmZjFF6f1s28/LPlyj3CcOJ+4DAjuN1CdmuVbdknMEfURStfJ7eIDGR/ch3hniDXHrcSCumkvDpaBamXgxFF8D0wIhPQ8kkCK1jlfK2xtt1NYT5mJI1dGhPXkh1ZlE7eH3AYyvRx4+zh2JyMBttWEwk9wauusHYr9HRXJ/0FKO8jO2ZMxGt8XwDghDWCsJemPSCC6s89I0d5WL4wlRc7Ed0cOL09eqiHs1R3oWXgoMwvUZtKLgg1zrBMYM0gcQ1dJdXLRjIYl0SNjtIVIp+NIvuG5lUU71h6j7DNpC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When memory.high is exceeded in non-task context, try_charge_memcg()
schedules memcg->high_work without taking a reference on the memcg, and
high_work_func() invokes reclaim_high() without pinning the memcg.

cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
mem_cgroup_css_free(), so high_work_func() can start or still be running
reclaim_high() after mem_cgroup_css_released() or shrink_many() has
called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
NULL pprev pointer.

With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
memcg/slab: obj_cgroup API"), objects charged to a child memcg are
reparented to its parent in mem_cgroup_css_offline() instead of holding
a reference on the child until uncharged. Subsequent uncharges of those
objects go to the parent, which can leave the child's memory use
permanently above its high limit, so any later charge on the offlined
memcg in non-task context schedules high_work.

This problem was first exposed when commit e4dde56cd208 ("mm: multi-gen
LRU: per-node lru_gen_folio lists") introduced the memcg LRU, and was
later widened from kernel memory to LRU folios when
commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying
memory cgroup for LRU folios") converted LRU folios to use obj_cgroup
reparenting.

Fix this by acquiring a reference with css_tryget_online() in
high_work_func() before calling reclaim_high(), and by resetting
memory.high and swap.high to PAGE_COUNTER_MAX in
mem_cgroup_css_offline() so that charges via references on an offlined
memcg do not trigger high_work on the dead child or skip checking live
ancestors in try_charge_memcg().

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
Tainted: [B]=BAD_PAGE, [W]=WARN <- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: events high_work_func
RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
Call Trace:
 <TASK>
 ? read_ctrl_pos+0x22f/0x3f0
 shrink_lruvec+0x16cb/0x1b80
 ? ret_from_fork_asm+0x1a/0x30
 ? lapic_next_event+0x15/0x20
 ? clockevents_program_event+0x2bb/0x6f0
 ? lapic_next_event+0x15/0x20
 ? __pfx_shrink_lruvec+0x10/0x10
 ? __pfx_clockevents_program_event+0x10/0x10
 ? _raw_spin_lock+0x84/0xe0
 ? __pfx__raw_spin_lock+0x10/0x10
 ? kasan_save_stack+0x30/0x50
 ? psi_group_change+0x381/0x740
 ? __pfx_sched_clock_cpu+0x10/0x10
 ? save_fpregs_to_fpstate+0xc4/0x2c0
 ? finish_task_switch.isra.0+0x1de/0xac0
 ? __schedule+0xf62/0x42c0
 ? __pfx___schedule+0x10/0x10
 ? __pfx___irq_work_queue_local+0x10/0x10
 ? shrink_node+0x626/0x31e0
 shrink_node+0x626/0x31e0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? kswapd_clear_hopeless+0xa0/0x150
 ? __pfx_shrink_node+0x10/0x10
 ? 0xffffffffc0000095
 do_try_to_free_pages+0x255/0x13b0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? reclaim_high+0x10a/0x1b0
 try_to_free_mem_cgroup_pages+0x1f9/0x5a0
 ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
 ? irqentry_exit+0xc6/0x670
 reclaim_high+0x10a/0x1b0
 ? __pfx_reclaim_high+0x10/0x10
 ? process_one_work+0x5ff/0x1030
 ? __pfx_high_work_func+0x10/0x10
 process_one_work+0x6e2/0x1030
 ? __pfx___schedule+0x10/0x10
 ? __pfx_process_one_work+0x10/0x10
 worker_thread+0x422/0xbb0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x2cd/0x3a0
 ? recalc_sigpending+0x15c/0x200
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x368/0x590
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x588/0xf50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Cc: stable@vger.kernel.org
Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
Changes since V1 (https://lore.kernel.org/all/20261023222313.3979455-1-tjmercier@google.com/)
- Switch to Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
  from Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
  per Muchun Song.
- Reorder and update commit message content to describe reparenting
  separately from the commits that exposed and then widened the problem.
- Trim the backtrace a bit.

 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..84f4a8fd4d16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(work, struct mem_cgroup, high_work);
+	if (!css_tryget_online(&memcg->css))
+		return;
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
+	css_put(&memcg->css);
 }
 
 static void high_irq_work_func(struct irq_work *work)
@@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 
 	zswap_memcg_offline_cleanup(memcg);
 

base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
-- 
2.56.0.313.g2479322e68-goog


