Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4246CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181406B00E9; Tue, 26 May 2026 09:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158936B00EA; Tue, 26 May 2026 09:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EF46B00EB; Tue, 26 May 2026 09:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E616B6B00E9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:07:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DD90403E7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:07:28 +0000 (UTC)
X-FDA: 84809597376.03.13827AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C8056140019
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:07:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DdMWtKw/";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800846; a=rsa-sha256;
	cv=none;
	b=4DbdrLOsSQ6rnMPjCqGg2wXNKRb2RP/PdboyNGpC1fPzqKQC9K0C6YLU7mbEoy0hWdrHJ4
	Bj3h7Z4OE61k3FHtK9Ons6JN66WEhoDr3ure+lTeOtD/4l359LMtSPKJ/7mwHq8MjsZbcB
	ROKBw+84NLEQXRwcYwiUjfIUjBeWUVQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DdMWtKw/";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfMrJxWlZTw140adJbyAfHpWnHOrBMU5QPWLK/izTlI=;
	b=wJfR+YWpReIRN0hzSiO6hyNeh+qJZcJdW4nODSdEE+vg/1V+amX56sz4aSTg/vWbVfd7mU
	tidsMxd8xF5cFfMnBUpzJAcgtjFrRKn4+d7w055ppfcbv8NiARJgKxwJmAAEVmQPxAsZlf
	xo+G7iEa8bHYf72mMoiB1R9NT5YOabE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D6C360216;
	Tue, 26 May 2026 13:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7551F000E9;
	Tue, 26 May 2026 13:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779800846;
	bh=jfMrJxWlZTw140adJbyAfHpWnHOrBMU5QPWLK/izTlI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DdMWtKw/2jQ6UbDOdkxS/Q5TKvtI7vou1SU2tHVDUaghYdSSuNAroJs2brrK/EdFs
	 qKtHMc+UeXhdyZOv/lSslEaD7TMwepeHOE425V/97K15qu2kdDmp/ao+CPtHCbx9Cn
	 hIIiF/L5GXz78nkVdAsK8gDMu3HgLEbKKONWRcZfnnirKiAvrjav66tXEDnkyxqAUj
	 Ku3FbGiG6WdaumFQooq/AjrEhEJLcZFqvaAsvESwVKwvfEUQ51VE1Nkkn3B5iQFLcT
	 oNtn1EexFz1U4Aj/N4y9YUkIZuJMq9Hjx7MxXDELAMg0OWmBHsi7vvv4HpjSPzS4SC
	 nY77RlZmVMbQw==
Message-ID: <613100f3-b37c-4922-98f5-29108051567b@kernel.org>
Date: Tue, 26 May 2026 15:07:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 4/4] exec_state: relocate dumpable information
To: "Christian Brauner (Amutable)" <brauner@kernel.org>,
 Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linuxfoundation.org>,
 Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>,
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8056140019
X-Stat-Signature: 46ipxa3t54z69tr1edcpipiu3nkat7fw
X-HE-Tag: 1779800846-64156
X-HE-Meta: U2FsdGVkX18TFb/M2M3rM3T6Y2GpGk1JNcCHuYhY5zdQLefX1MyqY5gglkYB6VaXhl6wo6FmXLVU9SnAu0IpEhy4xbtRRvcUh8TGz41NYNtjVMhV9FxLah8+ZopFkVo2THhFI64y/KmG9iQl/7g+IxcW02boiESp4YXWlV7DmkSDkfai7/NsgnlznZK7DK4HztpuiUTNv8T64uSkYW/jtPAMPkjlfb9ydu0uLaJMs0OXq467qNvm2zCps1GpjMJHjA2lKSjEOU6QzHLhzYkEjpUMwTA8g+aHh5zP5AjznLrYMjLwasI6rkhIpykJJD+X3P3OhDJ0hoqcZqKb5Krwh+cFGgciPBYjc92KJbDCN/joJy/3HE2Pf4nrQN95WezBTL2Ar/TCjw+uaKTLIdVDXE/hz1HVfdS0XHC9Ncnz5iZn4mm7NZtupJ5pN6cDmhbxM073gPtZhSn3CBeKXmVsvQd+YUcnC9Z2x5x4Dps9NfeyOIVFvIxj7LBoUOFyvE4FdJ0aYlDbhZ3xXeQAjHJqHOAu2dmmgHBl/vpEjgCn77uQ676hHLETxCIYXEzRAFyVV6xUyh8bkp8oLtti7rloyIRyWnkRskJyhHUiMg+Yh8qr/BurYvxmu79kwIwC5LHiLWxOGcWjP4Mewt4N62OHhQzqXpjobRYixLiilalAiY80/Ux1eNuB1/cC6yhw4TBGft146tKQLMyKHSr5CycYmQ+Gyye7FbmTFSZpSI8N4Bv1nf54CqV2fsBstilMNxxzBe/m8JKdbZLUO4MkP2x7GOXyWZ5a/kQ1SwupIs5+yKNA8mZc1IszPyb4HNRrJI60ZnBk161fyy4qX+fLjlO0tEZ5rJZxHZw9tOhIifuuPcExtoxomYELXTbhXRBz7MoXwVQc28Sev/Px+5vRn619sj1XVOnNp6lBLL3ZP3VY/iCY7pGY10jxQ+kray7LLsAacPTwNNGEJ51E4YBr6fD
 XJcr1THD
 TdTqK2n4kU6ETI8SCElcD2niLTlzEMPHMtHHtP6/BakmDRWzDwZAvdt4CS5YNI4cQmMVVcsuBgUamChIW/Qab9sEleRQ0xdTuWKdED98H3PjlxIFSxBGU2jncjtwIHl/3ouuRU+rLV3FbqgiPpK4LN2XBtkGZMOPrlszUpcc0uGDJxl75NfNNrJyJrNj8vB1T758SS+xTG/sMGYGpmMeolvRx6JhTAoJeHFxCz7hremeAtpkz+9oPoBbAghZk+6SjKc0PxR1jnx5MmjRdyzV+IZoLoEIs+yoh5CffHIO082Bu79C2bvF5qMiTIn1ZCeAyI6Z7+dYlSmVKVomG7u3EvOz053u9EEqQ/OinVilANMjURIS3cjNVqyGS4m2Xtr/deqcm7mXDGYJEwzj6vgc5wf6qSl79FyM5mCbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 23:48, Christian Brauner (Amutable) wrote:
> The dumpable flag captured at execve() is consulted by
> __ptrace_may_access() and several /proc owner / visibility checks.
> It lives on mm_struct today, which exit_mm() clears from the task
> long before the task itself is reaped.
> 
> exec_state is anchored to the execve() that established the current
> privilege domain.  CLONE_VM siblings refcount-share the parent's
> exec_state via copy_exec_state(); non-CLONE_VM clones allocate a
> fresh exec_state inheriting the parent's dumpable mode and user_ns
> reference via task_exec_state_copy().  execve() allocates a fresh
> instance (via alloc_task_exec_state() in begin_new_exec()) and
> installs it under task_lock + exec_update_lock with
> task_exec_state_replace().  init_task uses a static instance.
> 
> The dumpable mode now lives on task->exec_state->dumpable.
> task->mm->flags no longer carries dumpability; MMF_DUMPABLE_MASK is
> removed, but MMF_DUMPABLE_BITS is reserved so MMF_DUMP_FILTER_* bit
> positions remain stable for the /proc/<pid>/coredump_filter ABI. The
> task->user_dumpable cache bit and its assignment in exit_mm() are
> removed; readers go through get_dumpable(task) directly.
> 
> coredump_params gains a snapshot field cprm.dumpable, populated from
> get_dumpable(current) at vfs_coredump() entry, replacing the previous
> __get_dumpable(cprm->mm_flags) consumers in fs/coredump.c and
> fs/pidfs.c.
> 
> The user namespace recorded at execve() is consulted by
> __ptrace_may_access() and by /proc/PID/* owner derivation. Move the
> captured user_ns onto task_exec_state, which stays attached to the task
> past exit_mm() and across exit_files().
> 
> bprm grows a user_ns field staged in bprm_mm_init() with the caller's
> user_ns, narrowed by would_dump() to the closest privileged ancestor,
> and consumed by exec_mmap() via alloc_task_exec_state(bprm->user_ns).
> free_bprm() releases the staging reference.
> 
> mm_struct loses ->user_ns entirely.  Initializers in init-mm, efi_mm,
> and the implicit one in mm_init()/dup_mm()/mm_alloc() are removed;
> __mmdrop() drops the matching put_user_ns(). The kthread_use_mm()
> WARN_ON_ONCE(!mm->user_ns) is no longer meaningful and goes too.
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  arch/arm64/kernel/mte.c          |  6 ++----
>  drivers/firmware/efi/efi.c       |  1 -
>  fs/coredump.c                    | 20 +++++++-------------
>  fs/exec.c                        | 39 ++++++++++++++++++++-------------------
>  fs/pidfs.c                       | 17 ++++++-----------
>  fs/proc/base.c                   | 39 ++++++++++++++++-----------------------
>  include/linux/binfmts.h          |  2 ++
>  include/linux/coredump.h         |  4 ++++
>  include/linux/mm_types.h         |  9 ++++-----
>  include/linux/sched.h            |  4 +---
>  include/linux/sched/coredump.h   | 36 ++----------------------------------
>  include/linux/sched/exec_state.h |  2 --
>  init/init_task.c                 | 10 ++++++++++
>  kernel/cred.c                    |  3 +--
>  kernel/exit.c                    |  1 -
>  kernel/fork.c                    | 32 ++++++++++++++++++++++++++------
>  kernel/kthread.c                 |  1 -
>  kernel/ptrace.c                  | 26 ++++++++------------------
>  kernel/sys.c                     |  4 ++--
>  mm/init-mm.c                     |  1 -
>  20 files changed, 111 insertions(+), 146 deletions(-)
> 
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index 904ac41f93bc..1a9aad6ef22a 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -8,6 +8,7 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/prctl.h>
> +#include <linux/ptrace.h>
>  #include <linux/sched.h>
>  #include <linux/sched/mm.h>
>  #include <linux/string.h>
> @@ -537,16 +538,13 @@ static int access_remote_tags(struct task_struct *tsk, unsigned long addr,
>  	if (!mm)
>  		return -EPERM;
>  
> -	if (!tsk->ptrace || (current != tsk->parent) ||
> -	    ((get_dumpable(mm) != TASK_DUMPABLE_OWNER) &&
> -	     !ptracer_capable(tsk, mm->user_ns))) {
> +	if (!ptracer_access_allowed(tsk)) {
>  		mmput(mm);
>  		return -EPERM;
>  	}

This reads much nicer.

But given that we obtain the MM before ptracer_access_allowed(), but don't
actually need it for the check, it raises the question whether that order will
be strictly required?

IOW, would

if (!ptracer_access_allowed(tsk))
	return -EPERM;

mm = get_task_mm(tsk);
if (!mm)
	return -EPERM;
...

be similarly valid? I would assume so, which cleanes this up further.



>  
>  	ret = __access_remote_tags(mm, addr, kiov, gup_flags);
>  	mmput(mm);
> -
>  	return ret;
>  }
>  

[...]

>  
> -static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
> -	struct user_namespace *user_ns)
> +static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
>  {
>  	mt_init_flags(&mm->mm_mt, MM_MT_FLAGS);
>  	mt_set_external_lock(&mm->mm_mt, &mm->mmap_lock);
> @@ -1132,7 +1132,6 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>  				     NR_MM_COUNTERS))
>  		goto fail_pcpu;
>  
> -	mm->user_ns = get_user_ns(user_ns);
>  	lru_gen_init_mm(mm);
>  	return mm;
>  
> @@ -1163,7 +1162,7 @@ struct mm_struct *mm_alloc(void)
>  		return NULL;
>  
>  	memset(mm, 0, sizeof(*mm));
> -	return mm_init(mm, current, current_user_ns());
> +	return mm_init(mm, current);
>  }

That's a very nice cleanup IMHO.

From a MM POV that conceptually looks good to me.

Unfortunately, I have to shutdown my computer now to go back to the beach ;)

-- 
Cheers,

David

