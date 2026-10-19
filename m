Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8AECCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E223D6B00C8; Sun, 18 Oct 2026 21:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4FB6B00CA; Sun, 18 Oct 2026 21:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFAA6B00CB; Sun, 18 Oct 2026 21:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1FA56B00C8
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:15:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17684160664
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:06 +0000 (UTC)
X-FDA: 85337607012.02.A2EBB32
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 598061C0008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FHWOfB+M;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWlH64QVUIffog8q/xCBPliUXpBJWVHV3VkMcYCT96w=;
	b=TDupq54EtRbhDcSjVZHu99NSHhmjEGT1+VTxl9kwyNhYF2uCfqu94JjvtYummXpH0nXM0e
	VOCWUXy1BdLmqAYvTvBBb9ZdPAVyfU/IJtDmvh+q8KnIFyVDLRgUKkHoVJebaIVprSLyd5
	rZadwll4fH4q7TMOZiLBLZOLnhcdROQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372504;
	b=TLDCuvWK/ZAF9nFiBv0Eg7yMi1eW9tM/269ubjKWTJ+I50BtYJ+KRxQbVIk5pImerY9p/G
	xZUpc5xHcRXLau4NGinQrmrG+KxXw8ttUpF2Bx1mNtMeABJT3eoX3kNcbb0pYx2KZ9w3bR
	e0YBu6fD4PbSIvIzoWvG9x/a80ORErU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FHWOfB+M;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eac6c5f927so144246e0c.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372503; x=1792977303; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nWlH64QVUIffog8q/xCBPliUXpBJWVHV3VkMcYCT96w=;
        b=FHWOfB+MAFJyTjc53jFCz78CTflCaicY4MEAoyZsbeNLuG0CxEfKnG8ItcB0i+qoI9
         pShRFDykEuXYuN1E8aU4DaKHzEDy23m+EBiKtu/ubco48bY41cidrcJiH3hZnBGjN5Fq
         xS3tRF9AOovgAfWwhEq2raOuAV8PkiPXJcCc++3tBxThhGKLGjUF05FNG3WXREGd0LMR
         sTg2T/s0pWLGYDKsfRBshi26nOJw/xzryYda/hW+b6MoJBcT5RAK/jnMjqB/CWPDBprE
         8whq5B9joYWvwQDLT/dWbkm9hqt1mMlDhOJGKW7+pYcHod/C5jO9R5i3MoJcFgDL/tMN
         q4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372503; x=1792977303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nWlH64QVUIffog8q/xCBPliUXpBJWVHV3VkMcYCT96w=;
        b=C7XQjbi+zWbXAa2ac89LzhdcAEjQZyzj0Czb8KwCac3r9qM4xPeFJ0sr20AtSalnfg
         0B/arwmePFwN5j3IVccp7bgQfhqj/ThGxD1tnjPRBJ5hVZnJv3EZN2uSGKWglMQVOQ9L
         G7QOMB/u7I7IHcKJhoO0OsWL3oWeMpjLvXTrDj94fHtyXVgN+NrZmlv/BZFQ1rQAMYd/
         KIKdmrhPZdxTjePBwQdixkOOTxGi52oXwDnaK7Zom/O7NP3Es0jqR+YTo3zQgHpkEvgi
         241os+6VyHQT846OwI+2h5hWKoLshnPat7ogkDUiPbIrn2lfMdzDoep7aLljeJAlxJzL
         OKZg==
X-Forwarded-Encrypted: i=1; AKwUvBx4xJoSu1VGH+cLmEAbjOeD+brERpGAcXo50WyobZhpzd3eOzKr/9L1/o6m/a1w2H2m9UNFU01BKg==@kvack.org
X-Gm-Message-State: AFq9FYLSuRRKBMI/QL8XqHFahdHpYGX8lJhFDGSDluef1Qu+KoTJ/sZi
	PDJEh/fHjQIJJHGw5E6ny49yQTbJ8/uh+sYoFvKCqAxEEl8HtW7L1kGWF2/id9KsUBE=
X-Gm-Gg: AYBFou23XVOQbA5/Z6ZDmQZOMOGlbXdlOKE5HcfTAjyVwAU7r12WEc319DX3wMqgQnJ
	3mL8UuXfmsWpwhjN+7d4k+H79/ERzOjhrAh0mBDBMo0WBPvcvIamGVekaouL6ziHANY4xgOhtxb
	VNIwf2smwYwL5UkQh3ToVN82IJwW+euaS8zUVpArujuoTKWGLFbYSFiqjiV61FIgQs6yVKwkCIw
	E3TjRb8ZO57YKLsE1Ba/sr2ZYDeDpds5dMsm8gbfeJlvMymk9JiRPWEr1Lsqh8zfFKfp97OiCVi
	vTStK8hflPEyLGrlcXa7hj0deJ0cTXDwmxINybB0Q85r+Xglw4mxea2l8qYW1G1QiPO8+ZZfeL5
	lizrvbTMLlmjBXLTk43izWfWkcsHB3qqTK/qQPLJvc4eHYiGY9BB0oVEPyh2VPMxvTvghYqZEUk
	xYDvZq2IydOfXqz0Roqr041x+SnMpEH5J7j4+Gm3slTGL/cdtem0jpmyKQDxwko/rVto1WsHod6
	rwsj8DVk+u3rJe8YrBZky0ZIQ67ElYfu9jeT3bvkz9Yw9f+H+ZVDENCErrcD9CB15C8BMcELqjS
	4lFvN0aOZ9Zyby1dz8I=
X-Received: by 2002:a05:6122:4b10:b0:5ea:b9b5:8c43 with SMTP id 71dfb90a1353d-5eab9b59387mr1190052e0c.18.1792372503429;
        Sun, 18 Oct 2026 18:15:03 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:15:02 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 6/8] sched/deadline, topology: Avoid O(N^2) dl_server bandwidth walks during root_domain rebuilds
Date: Sun, 18 Oct 2026 21:14:44 -0400
Message-ID: <20261019011446.834487-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 598061C0008
X-Stat-Signature: mmo3esr1wa4x65eiegcarb1uptkbqm1c
X-Rspam-User: 
X-HE-Tag: 1792372504-744355
X-HE-Meta: U2FsdGVkX182p1O7+d5ETs8TBzrfYQ4FPS2EDxsJV6xkfWydfr3c4rHO2Ak//gLD/vy72Q20wctI1Lzrc3XdcorgD+sTxsVSZiBxetpJOnTVIE1ePwiaujILkkMCUDQ6JapKH0TKeRg82x1tZMR8T3vMnVLiBGjHamV50yLilifoBpy1MY/DFi/JUytzhGZlS0YqaEcE5RCw+CZAlz+OY6OCqD24t8tH7fCxijJIK9vfOuEIpcUy188UtLSyIiBkR/0qW+5fwnIVltIbh4xJB8buq8Q3VZbHGOUuelDzKtFtnljdHt6l7hwS4tVIpXjk2XUvzomDfzFhxQP8JXd1ebrMXF8e+nkhNP+L/rgbQgy3B72pL/XS+bti+k6wDGd//mmol37BjRtmnBPQ1EOa/9Zv8yfmnb55CWuCKuis5e6IP31Xx/hv5w79n1Eel2u6+lAFJCSh+0IbyHhtjQyCdZ6KP3mBCmSwBSF0JHsxUhoQaY2Da+X4yW6nMp5hIFGQUq0ojkfTgVxKAEsAPzcmBVfpsYY2FERavMGp0zZjzijEHPIjIN5xm7h7VGBjZl6aqd0FPNz2F7wjLdz9kPRNPtyh2g0k397/nSlO5UT/GO7qTIvoMJMQCg7OPJ0LQT7EBk8SDZo4oNvFsLqAYQNFfG1gMGdZS72LZ0/GZx8XSBPO95MSwfAu1+bzk6OrgkukHGAQk3cXEJdkA95/EBoSTGRVIJ8mZ+PwZijzeCvSoOAxGIu5OBrzMKBtLUyT31Hv/f+Fo3NoVk6rAi9AjEEou/HxiSRlwMJl1ZUpSsDeFzmdge4lwnTIzZTstptu0dX1FadbQR+hg/iCjDKPvOu3YRq3rRthQmkM9aVNAZZz/Oq7KMyTgWcokTNZk05a66PgcmPEWCjHt3hQvFakaIthf2j/ZgZ5h2JTdthG+ajtYMt7CcbLHpSYRiI1DZdkCRm1GjaVsQ5cOpSweC1lu0U
 xUls8zkM
 kPLiXIsiqTntt9BN29c+448sbl32TduBO5/ZDLLp9z3DDyRYowzDfZreoNnjsPje8kBhivgZc3EEZ1h6CmMWQmHa3dGn3gP4GwGwtFQyvcBO7JBa4XZmdOkrlArbe7vX+p35MsHqdlX2RVv6b1ejggoaAW4rjXU3ceNHNyX3BvXBt8E+8i67Z6N9oXIkaqeNXL8Sk4cLTGyspJTxzvHlBn/Js64+BRpdkWl73QM0mhWiZBmC2lp8/5AGji9uIcB+SOCjHDGn+YtkxfP+ArYhCj5+cAxVv7HZuwgcPJtadpHsyKa4MnDCoF4+vuwYZ8rjPaSkrn89BA/VQFWQKsSiuycASIsAn6vd2EoxKdgzRYhWM76fujIDKkh0tZG7RV8Cas1lX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every CPU runqueue has a fair_server (and optionally an ext_server)
deadline entity enabled by default. Whenever a root_domain is rebuilt on
CPU hotplug or cpuset changes, partition_sched_domains_locked() currently
performs three O(N^2) remote runqueue bandwidth updates across all N
active CPUs (O(N^3) across sequential hotplug of N CPUs):

1. detach_destroy_domains() calls
   cpu_attach_domain(NULL, &def_root_domain, i) -> rq_attach_root() ->
   __dl_server_attach_root() for each of the N CPUs. Each call recomputes
   cpumask_weight_and(rd->span, cpu_active_mask) twice and calls
   __dl_add() -> __dl_update(), walking all active CPUs attached to
   def_root_domain so far to update rq->dl.extra_bw, only for
   def_root_domain to be detached milliseconds later.

2. build_sched_domains() calls cpu_attach_domain(sd, d.rd, i) ->
   rq_attach_root() -> __dl_server_attach_root() for each of the N CPUs,
   performing another N*(N+1)/2 remote rq->dl.extra_bw updates using
   intermediate partial span weights (1..N) that are immediately
   discarded at the end of partition_sched_domains_locked().

3. dl_rebuild_rd_accounting() -> dl_clear_root_domain() resets
   rd->dl_bw.total_bw = 0 and cpu_rq(i)->dl.extra_bw = max_bw, and then
   calls dl_server_add_bw(rd, i) -> __dl_add() -> __dl_update() in a
   nested O(N^2) loop over rd->span with interrupts disabled.

Remove the redundant __dl_server_attach_root() calls from rq_attach_root()
(since partition_sched_domains_locked() always rebuilds root_domain
accounting via dl_rebuild_rd_accounting() once domain attachment is
complete), and replace the nested O(N^2) loop in dl_clear_root_domain()
with a single O(N) accumulation pass and a single O(N) extra_bw update
pass.

Also provide a !CONFIG_CPUSETS implementation of
dl_rebuild_rd_accounting() (using a lockless dl_prio(READ_ONCE(p->prio))
pre-check before dl_add_task_root_domain(p)). Previously,
dl_rebuild_rd_accounting() was a no-op stub when CONFIG_CPUSETS=n, which
left root_domain rebuilds without SCHED_DEADLINE task bandwidth
accounting and left inconsistent per-CPU extra_bw values computed from
partial active CPU counts in rq_attach_root().

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   5.15 s ->  3.88 s (-24.7%)
  Online:    4.05 s ->  2.51 s (-38.0%)
  Total:     9.20 s ->  6.39 s (-30.5%)
  dl_clear_root_domain() / dl_rebuild_rd_accounting() (cpu479):
    5,537.0 us -> 58.1 us (-99.0%) / 5,176.2 us -> 61.9 us (-98.8%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   3.26 s ->  2.77 s (-15.0%)
  Online:    2.03 s ->  1.53 s (-24.6%)
  Total:     5.29 s ->  4.30 s (-18.7%)
  dl_clear_root_domain() / dl_rebuild_rd_accounting() (cpu511):
    1,880.5 us -> 27.5 us (-98.5%) / 1,762.3 us -> 22.6 us (-98.7%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/cpuset.h         | 23 ++++++---
 include/linux/sched/deadline.h |  1 -
 kernel/sched/deadline.c        | 93 +++++++++++++++++++++-------------
 kernel/sched/sched.h           |  1 -
 kernel/sched/topology.c        | 13 -----
 5 files changed, 73 insertions(+), 58 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 914983387e95..b99f329551fa 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -129,7 +129,7 @@ static inline int cpuset_do_page_mem_spread(void)
 
 extern bool current_cpuset_is_being_rebound(void);
 
-extern void dl_rebuild_rd_accounting(void);
+void dl_rebuild_rd_accounting(void);
 extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_current_mems_allowed(void);
@@ -196,9 +196,20 @@ static inline void cpuset_update_active_cpus(void)
 
 static inline void inc_dl_tasks_cs(struct task_struct *task) { }
 static inline void dec_dl_tasks_cs(struct task_struct *task) { }
-static inline void cpuset_lock(void) { }
-static inline void cpuset_unlock(void) { }
-static inline void lockdep_assert_cpuset_lock_held(void) { }
+static inline void cpuset_lock(void)
+{
+	sched_domains_mutex_lock();
+}
+
+static inline void cpuset_unlock(void)
+{
+	sched_domains_mutex_unlock();
+}
+
+static inline void lockdep_assert_cpuset_lock_held(void)
+{
+	lockdep_assert_held(&sched_domains_mutex);
+}
 
 static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
 					struct cpumask *mask)
@@ -273,9 +284,7 @@ static inline bool current_cpuset_is_being_rebound(void)
 	return false;
 }
 
-static inline void dl_rebuild_rd_accounting(void)
-{
-}
+void dl_rebuild_rd_accounting(void);
 
 static inline void rebuild_sched_domains(void)
 {
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 273538200a44..6f03357f05c7 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -31,7 +31,6 @@ static inline bool dl_time_before(u64 a, u64 b)
 
 struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
-extern void dl_clear_root_domain(struct root_domain *rd);
 extern void dl_clear_root_domain_cpu(int cpu);
 /*
  * Return whether moving DL task @p to @new_mask requires moving DL
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c0ebdcde5fe5..c8847e1ea55a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1885,24 +1885,6 @@ void sched_init_dl_servers(void)
 	}
 }
 
-void __dl_server_attach_root(struct sched_dl_entity *dl_se, struct rq *rq)
-{
-	u64 new_bw = dl_se->dl_bw;
-	int cpu = cpu_of(rq);
-	struct dl_bw *dl_b;
-
-	if (!dl_se->dl_bw_attached)
-		return;
-
-	dl_b = dl_bw_of(cpu_of(rq));
-	guard(raw_spinlock)(&dl_b->lock);
-
-	if (!dl_bw_cpus(cpu))
-		return;
-
-	__dl_add(dl_b, new_bw, dl_bw_cpus(cpu));
-}
-
 int dl_server_apply_params(struct sched_dl_entity *dl_se, u64 runtime, u64 period, bool init)
 {
 	u64 old_bw = (init || !dl_se->dl_bw_attached) ? 0 :
@@ -3433,7 +3415,8 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
-	if (!dl_task(p) || dl_entity_is_special(&p->dl)) {
+	if (!dl_task(p) || dl_entity_is_special(&p->dl) ||
+	    (READ_ONCE(p->__state) == TASK_DEAD && !cpu_active(task_cpu(p)))) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 		return;
 	}
@@ -3451,18 +3434,22 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 }
 
-static void dl_server_add_bw(struct root_domain *rd, int cpu)
+static void dl_server_sum_bw(int cpu, int cpus, u64 *total_bw, s64 *extra_bw)
 {
 	struct sched_dl_entity *dl_se;
 
 	dl_se = &cpu_rq(cpu)->fair_server;
-	if (dl_server(dl_se) && dl_se->dl_bw_attached && cpu_active(cpu))
-		__dl_add(&rd->dl_bw, dl_se->dl_bw, dl_bw_cpus(cpu));
+	if (dl_server(dl_se) && dl_se->dl_bw_attached) {
+		*total_bw += dl_se->dl_bw;
+		*extra_bw -= (s32)dl_se->dl_bw / cpus;
+	}
 
 #ifdef CONFIG_SCHED_CLASS_EXT
 	dl_se = &cpu_rq(cpu)->ext_server;
-	if (dl_server(dl_se) && dl_se->dl_bw_attached && cpu_active(cpu))
-		__dl_add(&rd->dl_bw, dl_se->dl_bw, dl_bw_cpus(cpu));
+	if (dl_server(dl_se) && dl_se->dl_bw_attached) {
+		*total_bw += dl_se->dl_bw;
+		*extra_bw -= (s32)dl_se->dl_bw / cpus;
+	}
 #endif
 }
 
@@ -3483,26 +3470,33 @@ static u64 dl_server_read_bw(int cpu)
 	return dl_bw;
 }
 
-void dl_clear_root_domain(struct root_domain *rd)
+static void dl_clear_root_domain(struct root_domain *rd)
 {
-	int i;
+	u64 total_bw = 0;
+	s64 extra_bw = 0;
+	int i, cpus;
 
 	guard(raw_spinlock_irqsave)(&rd->dl_bw.lock);
 
-	/*
-	 * Reset total_bw to zero and extra_bw to max_bw so that next
-	 * loop will add dl-servers contributions back properly,
-	 */
-	rd->dl_bw.total_bw = 0;
-	for_each_cpu(i, rd->span)
-		cpu_rq(i)->dl.extra_bw = cpu_rq(i)->dl.max_bw;
-
 	/*
 	 * dl_servers are not tasks. Since dl_add_task_root_domain ignores
 	 * them, we need to account for them here explicitly.
 	 */
-	for_each_cpu(i, rd->span)
-		dl_server_add_bw(rd, i);
+	cpus = cpumask_weight_and(rd->span, cpu_active_mask);
+	if (cpus) {
+		for_each_cpu_and(i, rd->span, cpu_active_mask)
+			dl_server_sum_bw(i, cpus, &total_bw, &extra_bw);
+	}
+
+	rd->dl_bw.total_bw = total_bw;
+	for_each_cpu(i, rd->span) {
+		struct rq *rq = cpu_rq(i);
+		u64 bw = rq->dl.max_bw;
+
+		if (cpu_active(i))
+			bw += extra_bw;
+		WRITE_ONCE(rq->dl.extra_bw, bw);
+	}
 }
 
 void dl_clear_root_domain_cpu(int cpu)
@@ -3510,6 +3504,33 @@ void dl_clear_root_domain_cpu(int cpu)
 	dl_clear_root_domain(cpu_rq(cpu)->rd);
 }
 
+#ifndef CONFIG_CPUSETS
+void dl_rebuild_rd_accounting(void)
+{
+	struct task_struct *g, *p;
+	u64 cookie = ++dl_cookie;
+	int cpu;
+
+	lockdep_assert_cpus_held();
+	lockdep_assert_held(&sched_domains_mutex);
+
+	rcu_read_lock();
+	for_each_possible_cpu(cpu) {
+		if (dl_bw_visited(cpu, cookie))
+			continue;
+
+		dl_clear_root_domain_cpu(cpu);
+	}
+	for_each_process_thread(g, p) {
+		/* Racy pre-check; dl_add_task_root_domain() rechecks under pi_lock. */
+		if (!dl_prio(READ_ONCE(p->prio)))
+			continue;
+		dl_add_task_root_domain(p);
+	}
+	rcu_read_unlock();
+}
+#endif
+
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 314fcad94668..3225cda0f9f6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -418,7 +418,6 @@ extern void sched_init_dl_servers(void);
 
 extern void fair_server_init(struct rq *rq);
 extern void ext_server_init(struct rq *rq);
-extern void __dl_server_attach_root(struct sched_dl_entity *dl_se, struct rq *rq);
 extern int dl_server_apply_params(struct sched_dl_entity *dl_se,
 		    u64 runtime, u64 period, bool init);
 extern int dl_server_attach_bw(struct sched_dl_entity *dl_se);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index a5a5d1378ce2..b5dec7f486b5 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -516,19 +516,6 @@ void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
-	/*
-	 * Because the rq is not a task, dl_add_task_root_domain() did not
-	 * move the fair server bw to the rd if it already started.
-	 * Add it now.
-	 */
-	if (rq->fair_server.dl_server)
-		__dl_server_attach_root(&rq->fair_server, rq);
-
-#ifdef CONFIG_SCHED_CLASS_EXT
-	if (rq->ext_server.dl_server)
-		__dl_server_attach_root(&rq->ext_server, rq);
-#endif
-
 	rq_unlock_irqrestore(rq, &rf);
 
 	if (old_rd)
-- 
2.56.0.176.g3575e65682-goog


