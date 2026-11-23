Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4596E606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TpQZw53a
Received: by kanga.kvack.org (Postfix)
	id 64BA96B05B4; Mon, 23 Nov 2026 09:14:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCCA6B05B6; Mon, 23 Nov 2026 09:14:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511946B05B7; Mon, 23 Nov 2026 09:14:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 296206B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:14:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADA6B1C3D91
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:14:52 +0000 (UTC)
X-FDA: 85466580024.03.09B68F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8131240014
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:14:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TpQZw53a;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ben.horgan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ben.horgan@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443291;
	b=7y20OR4UGxEn/SfMNuvx1KoP5zscO/Q2mmkuSIFK3w2lztqIe2uFYYO/fVJTkkVJtGRFDf
	9qR4g/0MfGZ7O2onVyEbp7CU8uJ+aolFmk5ueN49dTJSdWm16bOkr2VA+JyklyHx3anrPs
	F82UaEgJXMJgfWkFxNBCOmosKdqrjXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzWlJypFH0JBdyX3v3gI3tSAws9JaPsiAy4GuzyD5ZA=;
	b=m0S/vVWmhw+Bf5SW89lH1v41FoPsejMdijc0cXdZRieN/bXv5tSNWAKTPe1jviOjyrf3A4
	UhzzFMCqRpzsw6RTf2FslI9JJULZGMm+IGxFTPrZ48xZvdQ8QA0D/bcgN0lPvJPNWXQulb
	PgWyeh3/XVCj0saWvBRsVv3a+S3RmVo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TpQZw53a;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ben.horgan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ben.horgan@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6767D143D;
	Mon, 23 Nov 2026 06:14:46 -0800 (PST)
Received: from [10.211.55.3] (unknown [10.57.19.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85C483F632;
	Mon, 23 Nov 2026 06:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795443289; bh=13+dL+2yU1ST0Gj3ZErbeUJoSIXiq2YVvfbO1TbDWFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TpQZw53aO4s2CGwpt4CspTd4evdvoct8/Xd6AMv3lVDPfLwuP1n9VgLyar/Yv0L1g
	 i8auUfjTyeM5tev+x0ZUJ8vhTZIinVGgUt/LwpuaOjG66TyqxN0O1hfPIueITCccsB
	 yj4Mzrg8OqqUI0kueXe6Fz3NArQudEjfPYlEiKJQ=
Message-ID: <17fe3497-b887-4dc1-a8f8-3b647c1880a6@arm.com>
Date: Mon, 23 Nov 2026 14:14:40 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource group
 assignment vs copy_process()
To: Reinette Chatre <reinette.chatre@intel.com>, kees@kernel.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, bp@alien8.de, tglx@linutronix.de,
 dave.hansen@linux.intel.com, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, babu.moger@amd.com, fustini@kernel.org,
 jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com, peternewman@google.com, yu.c.chen@intel.com,
 x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8131240014
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: r7s7965r4e5i9rqre4kwbam3gmct6df6
X-Rspam-User:
X-HE-Tag: 1795443290-271333
X-HE-Meta: U2FsdGVkX19wgRettr/zP/bMEF2157GcsEA9IvlFp4295pX34lPWM0co+ybtCp/vkDZWd0A5Q94DIWukywEH9+4Iuwi+iU2j9ScEKh1qZMemKGh0Yka2BMnClHZ22r/oPtsfBojHANAnytILro6Qo4RzPH7C1wQYuuqDEi6JL7/ILQm7j3duJ8HZp4dzs5Seec9lqNZGxPdQeDwFNISlpJsP8z3uwo/N2MTNdx1OCdwvFoIRarN6RtPMv9OmO0s4FfGS0P2pdePzEKQF3SX8uQD6CLBUAfB+inFkCd73OIHi6jy16P0O5fJaMMTSAAgMgcIer9Jriq+3/G6rNBHHKq+v7hPhafxVXoLHhQ0XcyB48epiJs+dSTFwh/84+FOnoZIGF6qg+VYzbMHUp/idvAukQNdCGrj1BOet3Sc7F73Bp9jkS5KE6L2L7VkTI4NMnNtsCrShQON2VvaxP027gLWJPG0i5tC+hm6rJT9r8N05wotGY6wXhNpTIQaSdKSYBH90AJS9vW1nrgQQx1YQIxfMoytjrBo4Xnew4FstFEPpjBMVXtkbY9unxB8irfPw29CBl6SNIFJ3dMel2iBOigO74cjWH5tY+9oLYxNHwaKHXqLDbPu8lFi3SdS0iF3Qmc7IFt0Ha8api/zDAtRSRcT/M3hrPb7K1lu2cvkSSYgwJfSIFYhhbNaqSJoeKqFndf1KTvLQh6tdIeUfiiQ5G9lu8V8Ji7hyPYN/arLCo2PPFP7Ry103IVPNRs5CO95u0cdZVwo4sZT+ppc+pZ68sieomUKvQpcqyyQS2r4UY9J1kOt5xI0ZeqAs1LY3po8XTFmUw/xvVj/oOJRLu2wffBl5gnjvxigM/ZryUH5tfD6Z9of/k11KuApYcTVhEA8RrmFlJNnYx+NFDydlFzIRtlbpPee3J+Kv3fBGxIc1hxBb5Eu8k24V0LsK0XtXdH+zVoTZ8yl6b7e7dWjHhPk
 BYVa28Ma
 w+cg/dD15AVHMraFcHa9/s8D5X121QlPAkSu83aPDNL7DOf6bNBx8f66TP0MOcu1ML3yO7AgAvkd3f0o0N2rbkJAEwZLBhZmwO4IPTWkOdXoTRXas5gJ0MapCEOtB+4In4oQ8Vs4JtvWZYZ1Yw67+9ihi5389wvdifw6gC8lg4aKZLrEK9wOgHGd04d6poCZIhOKgNgnUNrOO6aBLZUHwItJAzF5NxlAdTG+676OV1iYZpJJ91HpFAel6bfLcmI9wL3+K+x2wcnOQ7giBlAnHeCzZDc0dkw17yC/bUmZ8hA/UuAmW5tS9eius1HeHwOQKOuDeUP3IvlVVwYtErBRYLlmFBQiw2wgbZvYFOEAk1UWvIb36RRrGoV+d8waULwultuSD7NFIKaX+m9vCsXXW7VxpW93J2j/9hxk7G0RMGbIKZHSitRTxSB2QubRo9LIQNKfFuVn2woqpnRwLvIgEISSrP86Lok4yOQ4Jk/0Fw9GqqHXu771Qf6VqcqO+BmcUVsL6ZKphGZhImeu6PV6K/5hyEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Reinette,

On 20/11/2026 18:39, Reinette Chatre wrote:
> During fork a task's CLOSID and RMID are copied into the new task by
> dup_task_struct(), early in copy_process() without holding tasklist_lock
> or any lock that resctrl takes. The new task becomes visible to a walk of
> the task list later in copy_process(), after it is linked onto the task
> list while the tasklist_lock is held for write.
> 
> Removing a resource group moves all of its tasks to another group by
> walking the task list while holding the tasklist_lock for read, and then
> frees the CLOSID and RMID of the removed group. A task that copies its
> parent's CLOSID and RMID before the walk reaches the parent is missed by
> the walk: it is not on the task list yet, and it cannot get there while
> the walk holds the tasklist_lock. By the time it is added to the task list
> the CLOSID and RMID it was initialized with have been freed.
> 
>     CPU0                                CPU1
>     ====                                ====
> 
>   fork()
>     copy_process()
>       dup_task_struct()
>         /*
>          * New task inherits the
>          * parent's CLOSID and RMID.
>          */
>                                     rdtgroup_rmdir_{ctrl,mon}()
>                                       rdt_move_group_tasks()
>                                         read_lock(&tasklist_lock)
>                                         for_each_process_thread()
>                                           /*
>                                            * Parent is moved out of
>                                            * the group. New task is
>                                            * not on the task list
>                                            * and is not moved.
>                                            */
>       write_lock_irq(&tasklist_lock)
>         /* Waits for the walk. */
>                                         read_unlock(&tasklist_lock)
>       /* Lock acquired. */
>       list_add_tail_rcu(&p->tasks, ...)
>       write_unlock_irq(&tasklist_lock)
>                                       free_rmid()
>                                       closid_free() /* ctrl only */
> 
>     New task and every task it creates use the freed CLOSID and RMID.
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> The new task and every task it goes on to create keep using a CLOSID
> and RMID that resctrl believes are unused. Once those identifiers are
> handed to a resource group created later, the strays appear in that
> group's tasks file, their memory accesses are counted in its monitoring
> data, and they are subject to its allocation policy, while the group
> intended for them does not control or monitor them.
> 
> Introduce resctrl_copy_process() to copy the parent's CLOSID and RMID
> into the new task from copy_process(), while the tasklist_lock is held
> for write. The walk holds the same lock for read for its full duration,
> so the new task is either already on the task list and assigned by the
> walk, or the copy happens after the walk completed and observes the
> parent's new resource group.
> 
> resctrl_copy_process() reads two values that some architectures store
> separately. __rdtgroup_move_task() assigns them with two stores while
> holding only rdtgroup_mutex, which resctrl_copy_process() cannot take,
> so those reads can fall between the two stores and leave the new task
> with the CLOSID of one resource group and the RMID of another. Assign
> them from __rdtgroup_move_task() while holding tasklist_lock for read
> as well, so that resctrl_copy_process() observes both as intended.
> 
> Add an architecture call to perform the copy because CLOSID and RMID are
> stored per architecture and cannot be read and written as independent
> values on all of them.
> 
> Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
> Reported-by: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Note to MPAM maintainers:
> 
> resctrl_copy_process() runs on every fork(), so
> resctrl_arch_copy_closid_rmid() is a static inline on x86. Doing so is
> perhaps not required as fork() is already expensive.
> 
> Even so, I attempted doing same for MPAM but ended up with solutions
> that do not seem ideal:

Thanks for considering MPAM so carefully.

> 
> - A static inline in arch/arm64/include/asm/mpam.h, next to the other
>   accessors of thread_info::mpam_partid_pmg. Nothing on the path from
>   include/linux/resctrl.h reaches that header, so the definition is not
>   visible to resctrl_copy_process(). Making it visible means
>   arch/arm64/include/asm/resctrl.h has to include asm/mpam.h, which
>   does not seem to match MPAM's intended design?
> 
> - A static inline in include/linux/arm_mpam.h, beside the
>   resctrl_arch_*() inlines already there. asm/mpam.h includes
>   linux/arm_mpam.h, so the reverse include would be circular and

Hmm, the existing include of linux/arm_mpam.h appears to be unnecessary.
As such, that include can be removed and resctrl_arch_copy_closid_rmid()
could be a static inline in include/linux/arm_mpam.h.

Thanks,

Ben

>   mpam_get_regval() cannot be called. The copy would have to read and
>   write thread_info::mpam_partid_pmg directly, which no code outside
>   asm/mpam.h does today, and would need a CONFIG_ARM64_MPAM guard
>   because the field is only present when it is set.
> 
> The out-of-line definition this ended up with matches
> resctrl_arch_sched_in(). Please let me know (if this is a change you
> agree with) what kind of shape it needs to take for MPAM. We could also
> just make x86 and MPAM both be out-of-line - doing so may not be felt by
> the heavy copy_process().
> ---
>  arch/arm64/include/asm/mpam.h  |  6 ++++++
>  arch/x86/include/asm/resctrl.h |  7 +++++++
>  drivers/resctrl/mpam_resctrl.c |  6 ++++++
>  fs/resctrl/rdtgroup.c          | 21 +++++++++++++++++++++
>  include/linux/arm_mpam.h       |  1 +
>  include/linux/resctrl.h        | 28 ++++++++++++++++++++++++++++
>  kernel/fork.c                  |  3 +++
>  7 files changed, 72 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> index 70d396e7b6da..0746e5d7cc2d 100644
> --- a/arch/arm64/include/asm/mpam.h
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -63,6 +63,12 @@ static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
>  	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
>  }
>  
> +static inline void mpam_copy_task_partid_pmg(struct task_struct *dst,
> +					     struct task_struct *src)
> +{
> +	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
> +}
> +
>  static inline void mpam_thread_switch(struct task_struct *tsk)
>  {
>  	u64 oldregval;
> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index 8f6edcdcfd87..199ca9af0089 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -153,6 +153,13 @@ static inline void resctrl_arch_set_closid_rmid(struct task_struct *tsk,
>  	WRITE_ONCE(tsk->rmid, rmid);
>  }
>  
> +static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> +						 struct task_struct *src)
> +{
> +	WRITE_ONCE(dst->closid, READ_ONCE(src->closid));
> +	WRITE_ONCE(dst->rmid, READ_ONCE(src->rmid));
> +}
> +
>  static inline bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
>  {
>  	return READ_ONCE(tsk->closid) == closid;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 5468367776e2..7aea58fca85b 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -345,6 +345,12 @@ void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
>  	}
>  }
>  
> +void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> +				   struct task_struct *src)
> +{
> +	mpam_copy_task_partid_pmg(dst, src);
> +}
> +
>  bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
>  {
>  	u64 regval = mpam_get_regval(tsk);
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 57ab090072c2..ebf780fc5fe9 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -657,12 +657,28 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * Hold tasklist_lock for read so that resctrl_copy_process(), which
> +	 * holds it for write, cannot read the CLOSID and the RMID of @tsk
> +	 * while only one of the two has been updated.
> +	 *
> +	 * Hold tasklist_lock just for the @tsk update. A CPU running @tsk
> +	 * keeps using the CLOSID and RMID that resctrl_arch_sched_in()
> +	 * applied when @tsk was last scheduled in, so
> +	 * update_task_closid_rmid() below has to interrupt that CPU for the
> +	 * new resource group to take effect. Leave that until after
> +	 * tasklist_lock has been dropped: a CPU waiting for tasklist_lock
> +	 * for write waits with interrupts disabled, and @tsk's CPU is the
> +	 * one that may be waiting, because @tsk may be forking.
> +	 */
> +	read_lock(&tasklist_lock);
>  	if (rdtgrp->type == RDTMON_GROUP)
>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->mon.parent->closid,
>  					     rdtgrp->mon.rmid);
>  	else
>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->closid,
>  					     rdtgrp->mon.rmid);
> +	read_unlock(&tasklist_lock);
>  
>  	/*
>  	 * Ensure the task's closid and rmid are written before determining if
> @@ -2959,6 +2975,11 @@ static void schemata_list_destroy(void)
>   * If @mask is not NULL the cpus on which moved tasks are running are set
>   * in that mask so the update smp function call is restricted to affected
>   * cpus.
> + *
> + * Tasks created while this walks the task list are handled by
> + * resctrl_copy_process(), which tasklist_lock serializes against this walk.
> + * A new task is either visible to the walk and moved with the others, or
> + * resctrl_copy_process() assigns it after the walk completes.
>   */
>  static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
>  				 struct cpumask *mask)
> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
> index 002f56e15362..b605e9771c32 100644
> --- a/include/linux/arm_mpam.h
> +++ b/include/linux/arm_mpam.h
> @@ -56,6 +56,7 @@ bool resctrl_arch_mon_capable(void);
>  void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
>  void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>  void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
> +void resctrl_arch_copy_closid_rmid(struct task_struct *dst, struct task_struct *src);
>  void resctrl_arch_sched_in(struct task_struct *tsk);
>  bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
>  bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 10dfdca7f4bf..32d8bf9ca9ba 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -7,6 +7,8 @@
>  #include <linux/list.h>
>  #include <linux/pid.h>
>  #include <linux/resctrl_types.h>
> +#include <linux/sched.h>
> +#include <linux/sched/task.h>
>  
>  #ifdef CONFIG_ARCH_HAS_CPU_RESCTRL
>  #include <asm/resctrl.h>
> @@ -729,6 +731,32 @@ extern unsigned int resctrl_rmid_realloc_limit;
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> +#ifdef CONFIG_RESCTRL_FS
> +/**
> + * resctrl_copy_process() - Give a new task the resource group of its parent.
> + * @child:	The new task, which is not yet on the task list.
> + *
> + * Call from copy_process() while tasklist_lock is held for write. Serialized
> + * against rdt_move_group_tasks() and __rdtgroup_move_task() that hold
> + * tasklist_lock for read.
> + *
> + * dup_task_struct() copies the parent's CLOSID and RMID into @child before
> + * @child is linked onto the task list. If the parent is moved out of a
> + * resource group that is being removed, that group's CLOSID and RMID are
> + * freed once the walk completes, leaving @child with stale assignments.
> + *
> + * Bring @child up to date with the parent.
> + */
> +static inline void resctrl_copy_process(struct task_struct *child)
> +{
> +	lockdep_assert_held_write(&tasklist_lock);
> +
> +	resctrl_arch_copy_closid_rmid(child, current);
> +}
> +#else
> +static inline void resctrl_copy_process(struct task_struct *child) { }
> +#endif
> +
>  #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
>  u64 resctrl_arch_get_prefetch_disable_bits(void);
>  int resctrl_arch_pseudo_lock_fn(void *_plr);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a7..8344e0d27b78 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -105,6 +105,7 @@
>  #include <linux/stackprotector.h>
>  #include <linux/user_events.h>
>  #include <linux/iommu.h>
> +#include <linux/resctrl.h>
>  #include <linux/rseq.h>
>  #include <uapi/linux/pidfd.h>
>  #include <linux/pidfs.h>
> @@ -2491,6 +2492,8 @@ __latent_entropy struct task_struct *copy_process(
>  
>  	klp_copy_process(p);
>  
> +	resctrl_copy_process(p);
> +
>  	sched_core_fork(p);
>  
>  	spin_lock(&current->sighand->siglock);


