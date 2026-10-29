Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D275606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mZaVnQee
Received: by kanga.kvack.org (Postfix)
	id 444AC6B00EF; Thu, 29 Oct 2026 16:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F56A6B05B1; Thu, 29 Oct 2026 16:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B5A6B05B4; Thu, 29 Oct 2026 16:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E35586B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:19:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 520A7160477
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:19:11 +0000 (UTC)
X-FDA: 85376778102.24.975CD47
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAE0018000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:19:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mZaVnQee;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3PKrjagkKCH0uknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3PKrjagkKCH0uknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793305149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DgH2xCOp/6/mNmEP4Z/0nXSnHkQBtLx+MyyZJMoK6oE=;
	b=PoxxJwoNQubSCz3qZ6Lrz8J2QGj+XCrcA+2Qux9weWetptRQ6BJaMAse28iXdPOzYMYtaF
	Lfza/CVKiptC1iWRIGlqRqov+M90LbMHOUQDe52swTD+QdOCchGseYSYkSE8q2+Q98G7Nw
	qhZXaajPEfTPbrdRn+25dFgp7YkqwAk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mZaVnQee;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3PKrjagkKCH0uknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3PKrjagkKCH0uknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793305149;
	b=IpmzVcItp2tO37NvIruWHw2L1w4oZ8dVnG45Av0VJZjcv9k+Vh00HM0UztEwerwzQMjBj4
	YdjgfRBmtSHkBBK+taHqHfSMHqtQwORd/O4RNnzQxddj6Q4ot3FoUoOrCOGD7CdGbRs/A9
	q0M3qVuZVcuJEqaT5Pb3Uhugg5X7BUw=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d5dbso1391a91.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793305148; x=1793909948; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DgH2xCOp/6/mNmEP4Z/0nXSnHkQBtLx+MyyZJMoK6oE=;
        b=mZaVnQeezi+e4MG1FEDv04zV2n4z1Nh3QXNrrQDzl3irXLIFRQj42sJGWvL76y/uMG
         6fuEVnc3OAxU+SSX5fTYN4+kQEVBknxOZPx1weVsr/8mrnwxXPnSW9U/fQomFf9Pm61S
         XWaew7Vt+FxqEMkBM8OKItIbi2b26rM7wBecjC6ZhbM/vGsP6mbSH4CwFQrGe9MlOh2Q
         0BezcJlVlru/tWlB18eszp+0dnSUI5SM91BjPeN6Y3qxmStgIJe0Y1ubB4Q6VCIMelXG
         lf3j0LP2VTzDWlGl7p8AdDRNUC4jTg3Y5NRFu4pF0wBCkj/w/Od4hnCpmG1epDXPjGj4
         jdig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305148; x=1793909948;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DgH2xCOp/6/mNmEP4Z/0nXSnHkQBtLx+MyyZJMoK6oE=;
        b=TO2+s4W8q12HFBLiOiyojmZKrAlVk1TMi+E13RGdBzXT0uAeo17WicA8eEq9BfmLYU
         cu6t2ZWggnvID64k4sPq4prLPfTiG9Kz0gKrIhEGgkk1K8fvUwO8XTo50KlnlEzQNdtg
         NceA0xyyKD8grxG05RWpVrXMgyYe/F4fNxKQAugMq+R4BoqSeTI+8RWDrxQDXFPIeHuj
         sBifXCIghh5XlufGMTScIygQN+HRQzD6HT3sn+kADf0+nyofBF+2rb6wBbCf9cBgbAga
         ULLAVeLoe/jbK4KBp1FEzaDK1VKhEkcPC1xTZRM0QczSp9UHtcfxAOt1XRl443Wp2vSt
         LXTg==
X-Forwarded-Encrypted: i=1; AKwUvBxROWEVSAUvK/mxY+hnp5l0IeCqhsC3UxcSbRrlhWepsER0ASjVSx7DhAZRoGf78jc7+S9EJppWPw==@kvack.org
X-Gm-Message-State: AFq9FYKTCRv2a4beBrq4ERsA4WwRy/ut0v7T3w1kNakyc63h+TymxguE
	lmDV/1dXRS0dXA+vhmd6swAlVaqFeARC3zIIq6WouJHidcnaPhckbnHqpizOhSyVyieCnc1Q7Ev
	6Iy7/mPlb67wU+s5a1Q==
X-Received: from pjig2.prod.google.com ([2002:a17:90a:5782:b0:3a8:7374:19e9])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:35c8:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3ae897aa7aemr68937a91.49.1793305148283;
 Thu, 29 Oct 2026 13:19:08 -0700 (PDT)
Date: Thu, 29 Oct 2026 13:18:58 -0700
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261029201858.2932905-1-tjmercier@google.com>
Subject: [PATCH v3] mm: memcontrol: fix NULL pointer deref and UAF from
 high_work_func() on dying memcg
From: "T.J. Mercier" <tjmercier@google.com>
To: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev
Cc: zhengqi.arch@bytedance.com, jp.kobryn@linux.dev, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAE0018000D
X-Stat-Signature: 9ngzj4d5z4863empg8wzespdogrjopwp
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793305149-228881
X-HE-Meta: U2FsdGVkX195AnrRuH0oj2ovUuE1BEgWnCV8e7Q3qle4/QHmygvaErDHjnlgN+l4YXt9wXZ4iv+A9tZTi3I08oQMOeT9XFSA1W+ucjHrFrIpW6TRclx9yVZ1nrJFQyO7yWIurfCJ4ervnfVtTpSORiaMG8IteEh9rgU1ax3R6yRYx4piom58g9RVpy0jufKmBJCIUUlYpTC7vmax7n3qrYzey0PjeDHoMkqdBCWPxFPc/L/qmluEI1/x6P6HpxfVwpdewLDQcL6NXYeTcCJFOw1pCvKILKpCKjfaCcIjFFGVwPaoHucZ9ApcxaJa+aq7YlQqblFvFOl7c8aBXTh+fXvvo8t5UFJ+0T7vK1rgO5eBK7YvInfB6JdZqN28EhyXNks03IbPwW01MxyEEIDweHJP6/XIkT+nOLJgkLMDe7eRYtRVy+0bNZjoA3H9k1AqJ1OpIBs6CHaM6+c2vbA+0xIGveOQjET7vqspz/X2hwNPRzPuntaXG6RQnXwX4dT5PH2u1PZdYmOyT7yyQfiGokm4OJ3u8sPfWXuKlzOofO40/giFgHp0BRyMVk0PcqO5fS3day6rHLGaRAdMABEGwYUg3ntANpW6xyrEStL7c9lnc1HVGustHL5okzpozvkq96OstOhrQx18a1q2NZBg88GppW7outOxsN31v1jv+skA+kGH9LyO7EJgPyZ6iS8X2WBgQneBjJ8lk9UDMh805JjhKvcsbbBV6FhH3gSs9UBio4yqvj5qAIZJDc5Cv6P8JS8pF8Fgt9jBRc6PHNvZ/YKJ7J6/4RTZHIKHaWzGxdaViT7ufOF9g187hg6eVPvfb2rZNhNT7bGR3SLw/PzHnDP9xDCAWbwEd5BkaAwv1HMUkojT7JCJ7+tCi32lPKNSBnc7r66tlCnXDezufQ4ZmKAlqF5jmvNejtEPkjizO6UPMVQo5xnAaVJGUlL4eRsft4Vgnh3J866BO3A+Wxv
 nanqe26+
 yhi8KLq66oVVbVbROfu+UnGz5TK3zxfwPtr8ocFoE2KPZhMsHOQLBn5JJ+hFoIqyHDwPOHZn0fJYSQ/zbCkudo+ZZRIBwWgsKfVkwoGEnGgrrPLahfHCCUl87COE8JPUdRKNFJ7yCFZa4AzUtqAtka/W7Zm9ojAP8zCJa5b0qHYrp+lN9c/QQTN5QcirZIEpIFxCWMG+CwYv+M8e0XGqyZkj+zAs3icwSbIJ0gknRlXE2xy3EolfTHx/1Np0FOpin2VhnEbL2ldgO+LJYQIkv9+4FYh4jfVosabimMngMHQ+yHL/lcLsev/a6uLDlq9tTu30uzDJhLe2EHIan/Y2yBbuTM3w/4brV2ztGRx9VNDmfXMX8ksBf77bN+7YQ8YaSih8LZF3d/VdJgapjhYEOqDaEPsSEj+NP207c4me5vVbUfAp5FHIlf+jkuoMB9ZTbudaJ0sa5OmTvFpcuoTpZUM/XU8Z+2Jku0vPYqk6fx4/jDZa2vHRXi5gS5abg5GAwlsauv4D2vfBaNwL04VtcQp0WFdkNpGZ1lmP/cjtH1PjK1Ny+hIT+nfC6YkYQCGLopwP9qQs8mmAvPkHvn0XzM706q0ecR0E8cudMPO/+gbentvC1rem4c/H41F05TmwSMVH11Cq5P6iayqHxbH5va1dqfjX/1hLKbe+NG+EXuQ3ia3QIkTH48Tua5A3oMLiha7m8v5M9MwfWMp4fgQz7WaVZkY+38PNc6Is9
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

With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
memcg/slab: obj_cgroup API"), objects charged to a child memcg are
reparented to its parent in mem_cgroup_css_offline() instead of holding
a reference on the child until uncharged. Subsequent uncharges of those
objects go to the parent, which can leave the child's memory use
permanently above its high limit, so any later charge on the offlined
memcg in non-task context schedules high_work. This was later widened
from kernel memory to LRU folios when commit f1cf8d2f36dc ("mm:
memcontrol: eliminate the problem of dying memory cgroup for LRU
folios") converted LRU folios to use obj_cgroup reparenting.

cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
mem_cgroup_css_free(), so high_work_func() can start or still be running
reclaim_high() after mem_cgroup_css_released() or shrink_many() has
called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
NULL pprev pointer. This issue is specific to MGLRU and was introduced
with the memcg LRU in commit e4dde56cd208 ("mm: multi-gen LRU: per-node
lru_gen_folio lists").

With either traditional LRU or MGLRU, css_free_rwork_fn() calls
css_rstat_exit() which frees per-CPU rstat data before calling
mem_cgroup_css_free(). If reclaim_high() is still running, rstat updates
via mod_lruvec_state() -> __css_rstat_updated() cause a use-after-free
on the per-CPU rstat data. This was introduced when commit 5da3bfa029d6
("cgroup: use separate rstat trees for each subsystem") moved
css_rstat_exit() ahead of ss->css_free().

Fix both problems by acquiring a reference with css_tryget_online() in
high_work_func() before calling reclaim_high(), and by resetting
memory.high and swap.high to PAGE_COUNTER_MAX in
mem_cgroup_css_offline() so that charges via references on an offlined
memcg do not trigger high_work on the dead child and skip checking live
ancestors in try_charge_memcg().

Acquiring the reference in high_work_func() rather than before
scheduling high_work is safe because mem_cgroup_css_free() calls
irq_work_sync() and cancel_work_sync() which cancels pending work and
waits for an already running high_work_func() to complete before
mem_cgroup_free() frees the memcg. css_tryget_online() uses
percpu_ref_tryget_live() and is safe to call after percpu_ref_exit()
before the cgroup is freed unlike css_tryget().

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
Tainted: [B]=BAD_PAGE, [W]=WARN  <-- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
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
Fixes: 5da3bfa029d6 ("cgroup: use separate rstat trees for each subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
Changes since V2 (https://lore.kernel.org/all/20261028183537.605854-1-tjmercier@google.com/)
- Add RBs / Acks
- Explain why css_tryget_online() is safe in the commit message.
  (Shakeel Butt)
- Update the commit message and subject to explain the cgroup UAF this
  patch also fixes. Add Fixes: 5da3bfa029d6 ("cgroup: use separate rstat
  trees for each subsystem")
  (Michal Hocko, Johannes Weiner)

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
2.56.0.385.gac671c819a-goog


