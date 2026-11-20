Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F104960A2626
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iouf88jv
Received: by kanga.kvack.org (Postfix)
	id DB84B6B05B9; Fri, 20 Nov 2026 13:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D886B05BA; Fri, 20 Nov 2026 13:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA9D6B05BB; Fri, 20 Nov 2026 13:39:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC6C6B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:39:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFC3F160141
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:44 +0000 (UTC)
X-FDA: 85456361088.16.2508290
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 504EC4000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iouf88jv;
	spf=pass (imf17.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199983;
	b=tmOC57btonqSABsBRGvj5Nq57kILrcRog3akEchrf3YhFZ2dXA6mwHoXdW2/NSHbpD2fjz
	7NovBjBmyGR8KAzvaYxgtX6EAxWtCatJ6ZezIyoFAbTRLOT9+/Jp2YUx5XK4CRj7ktZnW5
	B1YBLWfGLWpzewSq8WvHeJzF3Msl1U0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCc6FMGDt7ajCqVzDVfnvWK7RnujE3EoWW2vegspg0s=;
	b=EkS0uHZzTMNqJS07q4AUnTqaZhT+mDSYM+fkGav8zc6G33+mpqh6v3eX+ndzg5bq2N7LkF
	eG4uhO39c+rpIRrxq5IuNS5fIXxF91hwMc6VNgk53K+7ZJJorTpExuRCwRLOwawfQSkydF
	+OqT8xPqN59o3qXnxucm5WO/R59t04c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iouf88jv;
	spf=pass (imf17.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199982; x=1826735982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1dL6aXlYz0yRzNYuphh0tfaAWKCvv/mw7lzaNRZIq/8=;
  b=iouf88jv/VX3YWEJ596R0CWU6EnNGCSrhlByT2DVGGFkY+8TMiQCtlZq
   DQmIj8GfCM3+mLZHLzxBmRfxtTTfhA+a5wWKyH0MZ9tAFrnptAPNQKmQm
   dksSz8z6Z6/AeGono3dmP7xEsVjLWgI1Ap22tpzgP2cRSCRHYQBpoMVGw
   e/5DKBurY/1pJyijZcjDenVGYqFbEcAQyDF/ecIi259Ce267aF6YIlSsj
   sm/TvhYNxIOhiOlJIYWUPDzTUxRckL9Z8ZPVhEkkQWQWSCuU0Of7CDBBC
   VGGmOyNzIUvq9NZcGoRqiVTUvFwzFyCtHj9tx75zI/723ueMQ62USk5LR
   Q==;
X-CSE-ConnectionGUID: Y9ER+bQeRCKt8iNS8Zfz5w==
X-CSE-MsgGUID: JJipNO66QBqNeSVFMXbFQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931837"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931837"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:40 -0800
X-CSE-ConnectionGUID: MLb54DnqRsC9YOdVnHv6PQ==
X-CSE-MsgGUID: PDpUp96QRhu8vbGjLDHQgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590715"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:39 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	tony.luck@intel.com,
	ben.horgan@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource group assignment vs copy_process()
Date: Fri, 20 Nov 2026 10:39:30 -0800
Message-ID: <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795197419.git.reinette.chatre@intel.com>
References: <cover.1795197419.git.reinette.chatre@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 504EC4000F
X-Stat-Signature: rbxxzsco1hkkftn6qcbnry6nb5uprzc1
X-Rspam-User:
X-HE-Tag: 1795199982-837091
X-HE-Meta: U2FsdGVkX19LpkWdH1pBv50shWzX5GJSRMu+L7wG5GytuaZnOunChGZXmCUrOKdaTLqXrO7cqZYHW8GNMp3/fStyuK6BncX5tQWJObNnJmJcsrjiyBfAxhtjUYFPpLH0o449zCQGNRUBalZpvkesS8E9lgzgnMAveEjxeW+d9F08rcavf0F1dDrPz3aDnkwWZTwTWVYrPDvmeH6BjRqP3KcrETzKWvCusklDycKMDDn+Utc3srULkZ+6SkHL8j8z6r9VLLojFSrUJaIRp5XmVwnk8OBNqAfjoQSPUL0OaDgAV4qhDXweO4UlmmJjV9Bfh1LHMkaASP/SvaHTZNM88A9+a758GjRYgphy2ROpmWStgg9CJiqYwhi7fC4eCTxZLwheS4D57nSeeznoge797CB4Vw2ouoCq19QzmHv9gHO3J9Kg4vqYg3c/Bd6gvOpeRnfMf9WFyUsRmuJw9dB+XoIZ6tKCbapMIQCwUFgKeq0ZDBCrkwQ4Tj8i0cV1ngO66JQbJrcnitA0zUpCAAPouDxQXIHtOEdhZjnmF8ildXwlf8OQdHDmMHB9uhyb9X8+/WX9E+3YCg21J8RF7lyK/huT/mrWeCRerbe3pctKOZnn3pui4SFwishz6QPfMaTofiJwvnJyW0h3JQLBjQR1i4ohszYnNdfZH2j2xkoFH3r1vfbAE6an9BVutBd0la/0c84PW5dZH502pNQoLuZGR8cWnOKw34d5Pxlk0R2IE8/LFPtwWAKsuGfYRUkCXTtkRrCODVDYruKEM88VOIwGawMZnw5cyIfeaTgyQKcZouwu+t39XddFb55scVD5NQ76yCMfET0j+0H/EZw2gm3cu/jr80mbJDBhStwLYJcxtL472pzOhH3i/aehSXsSrwCIFfKPs4myvVX6yLInWz6H+sWuFLaL3QL/w4uZ2gzNO2kGJTFcvtlp5n+VH07ThPQ8S2lHwddhf4asV9ZgEPL
 h7jmXWfw
 wMazgXaPwG7sbo4IzNW0wMay1sb1OuNLymz+8byF67bzCDLgr6xmERdzFn9nown/CviikA0ezFzsY9cl0vo9SGadYH/FutgYNeHRxcO+uQRLCtcVHRVomPLYVOdgWITDHmYAkzaLotrKDJopEd8LAYpIyEXZnydhaehR2WZox97ErQnlF+2oiJnuslpsjEB0zMbRvnPccqu1MXpIqVJF6Pr88ZN8OIeTneA/7wYu/2d87sUSLYAgrBXhu4F3kPB3ApfSXY25NnQ55D/CArPhnOvTpBvef0PnrryFLrfmKJueeG/GxZByIcBYcM3DwZxXkSN/tsKdE9+0xrNyMsC20Mnk3NtxIo/pGJL+Cko89+NAMxCH4orKZZEGWS5n2MAL2ZHJlibbPIF6rZKR7Jqp7WWY/IBjd3gG/RET8oP1U1LzBX42b78WlagFBJft5eRjAHD1L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

During fork a task's CLOSID and RMID are copied into the new task by
dup_task_struct(), early in copy_process() without holding tasklist_lock
or any lock that resctrl takes. The new task becomes visible to a walk of
the task list later in copy_process(), after it is linked onto the task
list while the tasklist_lock is held for write.

Removing a resource group moves all of its tasks to another group by
walking the task list while holding the tasklist_lock for read, and then
frees the CLOSID and RMID of the removed group. A task that copies its
parent's CLOSID and RMID before the walk reaches the parent is missed by
the walk: it is not on the task list yet, and it cannot get there while
the walk holds the tasklist_lock. By the time it is added to the task list
the CLOSID and RMID it was initialized with have been freed.

    CPU0                                CPU1
    ====                                ====

  fork()
    copy_process()
      dup_task_struct()
        /*
         * New task inherits the
         * parent's CLOSID and RMID.
         */
                                    rdtgroup_rmdir_{ctrl,mon}()
                                      rdt_move_group_tasks()
                                        read_lock(&tasklist_lock)
                                        for_each_process_thread()
                                          /*
                                           * Parent is moved out of
                                           * the group. New task is
                                           * not on the task list
                                           * and is not moved.
                                           */
      write_lock_irq(&tasklist_lock)
        /* Waits for the walk. */
                                        read_unlock(&tasklist_lock)
      /* Lock acquired. */
      list_add_tail_rcu(&p->tasks, ...)
      write_unlock_irq(&tasklist_lock)
                                      free_rmid()
                                      closid_free() /* ctrl only */

    New task and every task it creates use the freed CLOSID and RMID.
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The new task and every task it goes on to create keep using a CLOSID
and RMID that resctrl believes are unused. Once those identifiers are
handed to a resource group created later, the strays appear in that
group's tasks file, their memory accesses are counted in its monitoring
data, and they are subject to its allocation policy, while the group
intended for them does not control or monitor them.

Introduce resctrl_copy_process() to copy the parent's CLOSID and RMID
into the new task from copy_process(), while the tasklist_lock is held
for write. The walk holds the same lock for read for its full duration,
so the new task is either already on the task list and assigned by the
walk, or the copy happens after the walk completed and observes the
parent's new resource group.

resctrl_copy_process() reads two values that some architectures store
separately. __rdtgroup_move_task() assigns them with two stores while
holding only rdtgroup_mutex, which resctrl_copy_process() cannot take,
so those reads can fall between the two stores and leave the new task
with the CLOSID of one resource group and the RMID of another. Assign
them from __rdtgroup_move_task() while holding tasklist_lock for read
as well, so that resctrl_copy_process() observes both as intended.

Add an architecture call to perform the copy because CLOSID and RMID are
stored per architecture and cannot be read and written as independent
values on all of them.

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Reported-by: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to MPAM maintainers:

resctrl_copy_process() runs on every fork(), so
resctrl_arch_copy_closid_rmid() is a static inline on x86. Doing so is
perhaps not required as fork() is already expensive.

Even so, I attempted doing same for MPAM but ended up with solutions
that do not seem ideal:

- A static inline in arch/arm64/include/asm/mpam.h, next to the other
  accessors of thread_info::mpam_partid_pmg. Nothing on the path from
  include/linux/resctrl.h reaches that header, so the definition is not
  visible to resctrl_copy_process(). Making it visible means
  arch/arm64/include/asm/resctrl.h has to include asm/mpam.h, which
  does not seem to match MPAM's intended design?

- A static inline in include/linux/arm_mpam.h, beside the
  resctrl_arch_*() inlines already there. asm/mpam.h includes
  linux/arm_mpam.h, so the reverse include would be circular and
  mpam_get_regval() cannot be called. The copy would have to read and
  write thread_info::mpam_partid_pmg directly, which no code outside
  asm/mpam.h does today, and would need a CONFIG_ARM64_MPAM guard
  because the field is only present when it is set.

The out-of-line definition this ended up with matches
resctrl_arch_sched_in(). Please let me know (if this is a change you
agree with) what kind of shape it needs to take for MPAM. We could also
just make x86 and MPAM both be out-of-line - doing so may not be felt by
the heavy copy_process().
---
 arch/arm64/include/asm/mpam.h  |  6 ++++++
 arch/x86/include/asm/resctrl.h |  7 +++++++
 drivers/resctrl/mpam_resctrl.c |  6 ++++++
 fs/resctrl/rdtgroup.c          | 21 +++++++++++++++++++++
 include/linux/arm_mpam.h       |  1 +
 include/linux/resctrl.h        | 28 ++++++++++++++++++++++++++++
 kernel/fork.c                  |  3 +++
 7 files changed, 72 insertions(+)

diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
index 70d396e7b6da..0746e5d7cc2d 100644
--- a/arch/arm64/include/asm/mpam.h
+++ b/arch/arm64/include/asm/mpam.h
@@ -63,6 +63,12 @@ static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
 	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
 }
 
+static inline void mpam_copy_task_partid_pmg(struct task_struct *dst,
+					     struct task_struct *src)
+{
+	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
+}
+
 static inline void mpam_thread_switch(struct task_struct *tsk)
 {
 	u64 oldregval;
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 8f6edcdcfd87..199ca9af0089 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -153,6 +153,13 @@ static inline void resctrl_arch_set_closid_rmid(struct task_struct *tsk,
 	WRITE_ONCE(tsk->rmid, rmid);
 }
 
+static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
+						 struct task_struct *src)
+{
+	WRITE_ONCE(dst->closid, READ_ONCE(src->closid));
+	WRITE_ONCE(dst->rmid, READ_ONCE(src->rmid));
+}
+
 static inline bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
 {
 	return READ_ONCE(tsk->closid) == closid;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 5468367776e2..7aea58fca85b 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -345,6 +345,12 @@ void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
 	}
 }
 
+void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
+				   struct task_struct *src)
+{
+	mpam_copy_task_partid_pmg(dst, src);
+}
+
 bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
 {
 	u64 regval = mpam_get_regval(tsk);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 57ab090072c2..ebf780fc5fe9 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -657,12 +657,28 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 		return -EINVAL;
 	}
 
+	/*
+	 * Hold tasklist_lock for read so that resctrl_copy_process(), which
+	 * holds it for write, cannot read the CLOSID and the RMID of @tsk
+	 * while only one of the two has been updated.
+	 *
+	 * Hold tasklist_lock just for the @tsk update. A CPU running @tsk
+	 * keeps using the CLOSID and RMID that resctrl_arch_sched_in()
+	 * applied when @tsk was last scheduled in, so
+	 * update_task_closid_rmid() below has to interrupt that CPU for the
+	 * new resource group to take effect. Leave that until after
+	 * tasklist_lock has been dropped: a CPU waiting for tasklist_lock
+	 * for write waits with interrupts disabled, and @tsk's CPU is the
+	 * one that may be waiting, because @tsk may be forking.
+	 */
+	read_lock(&tasklist_lock);
 	if (rdtgrp->type == RDTMON_GROUP)
 		resctrl_arch_set_closid_rmid(tsk, rdtgrp->mon.parent->closid,
 					     rdtgrp->mon.rmid);
 	else
 		resctrl_arch_set_closid_rmid(tsk, rdtgrp->closid,
 					     rdtgrp->mon.rmid);
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * Ensure the task's closid and rmid are written before determining if
@@ -2959,6 +2975,11 @@ static void schemata_list_destroy(void)
  * If @mask is not NULL the cpus on which moved tasks are running are set
  * in that mask so the update smp function call is restricted to affected
  * cpus.
+ *
+ * Tasks created while this walks the task list are handled by
+ * resctrl_copy_process(), which tasklist_lock serializes against this walk.
+ * A new task is either visible to the walk and moved with the others, or
+ * resctrl_copy_process() assigns it after the walk completes.
  */
 static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 				 struct cpumask *mask)
diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index 002f56e15362..b605e9771c32 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -56,6 +56,7 @@ bool resctrl_arch_mon_capable(void);
 void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
 void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
 void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
+void resctrl_arch_copy_closid_rmid(struct task_struct *dst, struct task_struct *src);
 void resctrl_arch_sched_in(struct task_struct *tsk);
 bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
 bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 10dfdca7f4bf..32d8bf9ca9ba 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -7,6 +7,8 @@
 #include <linux/list.h>
 #include <linux/pid.h>
 #include <linux/resctrl_types.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
 
 #ifdef CONFIG_ARCH_HAS_CPU_RESCTRL
 #include <asm/resctrl.h>
@@ -729,6 +731,32 @@ extern unsigned int resctrl_rmid_realloc_limit;
 int resctrl_init(void);
 void resctrl_exit(void);
 
+#ifdef CONFIG_RESCTRL_FS
+/**
+ * resctrl_copy_process() - Give a new task the resource group of its parent.
+ * @child:	The new task, which is not yet on the task list.
+ *
+ * Call from copy_process() while tasklist_lock is held for write. Serialized
+ * against rdt_move_group_tasks() and __rdtgroup_move_task() that hold
+ * tasklist_lock for read.
+ *
+ * dup_task_struct() copies the parent's CLOSID and RMID into @child before
+ * @child is linked onto the task list. If the parent is moved out of a
+ * resource group that is being removed, that group's CLOSID and RMID are
+ * freed once the walk completes, leaving @child with stale assignments.
+ *
+ * Bring @child up to date with the parent.
+ */
+static inline void resctrl_copy_process(struct task_struct *child)
+{
+	lockdep_assert_held_write(&tasklist_lock);
+
+	resctrl_arch_copy_closid_rmid(child, current);
+}
+#else
+static inline void resctrl_copy_process(struct task_struct *child) { }
+#endif
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 u64 resctrl_arch_get_prefetch_disable_bits(void);
 int resctrl_arch_pseudo_lock_fn(void *_plr);
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..8344e0d27b78 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -105,6 +105,7 @@
 #include <linux/stackprotector.h>
 #include <linux/user_events.h>
 #include <linux/iommu.h>
+#include <linux/resctrl.h>
 #include <linux/rseq.h>
 #include <uapi/linux/pidfd.h>
 #include <linux/pidfs.h>
@@ -2491,6 +2492,8 @@ __latent_entropy struct task_struct *copy_process(
 
 	klp_copy_process(p);
 
+	resctrl_copy_process(p);
+
 	sched_core_fork(p);
 
 	spin_lock(&current->sighand->siglock);
-- 
2.56.0


