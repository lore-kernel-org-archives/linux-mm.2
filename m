Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC77FD172C6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED546B0089; Sun,  1 Feb 2026 23:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE486B008A; Sun,  1 Feb 2026 23:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA0E6B008C; Sun,  1 Feb 2026 23:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDA56B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:49:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1F91D492D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:49:17 +0000 (UTC)
X-FDA: 84398287554.21.3D81B15
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF5BE100005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:49:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Q7ylHw/J";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mattbobrowski@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770007756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iI1Ccr3tQDh02EONmID1TL3UlMW3pFDSOrDm5zM+CFg=;
	b=Pzag5dJnK2apvrLrvkv/olBuxiQNwfdI1yFkkYhGFxhA3ravOQKHw+fw4vY9GGluUfWKRp
	CbYdQD5PjONxd77vxIE6kkyR7DN3ptBXXBgkz6uFT2w5R62V2i11lUaYmxRSyLc61W24lV
	VU/lQOUZeI4O6mPMPBXdR16q1/y47S8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770007756; a=rsa-sha256;
	cv=none;
	b=rEJbYPzVgZOfD1b+WOjsM6//7xkInQwjtQK58wWeifveICu+Q7e7513ntlk44tsTpWzqPs
	Tu2GnmJ3FHJ9/Dmw046GWabBRYnWdGZ7hUQr3gKj6ZdTRLn7CSm5TIIlQtXHfYpocjUqV6
	tT46SYtsXUU99AG58adWx4s0wF9P6nw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Q7ylHw/J";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mattbobrowski@google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso7114619a12.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 20:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770007754; x=1770612554; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iI1Ccr3tQDh02EONmID1TL3UlMW3pFDSOrDm5zM+CFg=;
        b=Q7ylHw/JqRhabxq5Bct4g/ltRLLT1tT2CkdDcGIuw1TIIgwRrNSreA8EK+st1o/5IE
         MqbCPyCNWFFo8mSnxz2SOyac7QLkhuEPS0EeLVYszdiZ8Eb7Bp4P5gnzdquSlKn2aqz7
         xK1G2lKhVqMbNDbfLcURrNBdfA6IhRRG5Xqpa48nWM3bup11CfDHyyXTBi7jvZwxnane
         DFeZxp4FgUTAhfxuu0BInZ4Q91AIbsPOcieoUD4lCKJk+O+prYfl2UcMd/Gawy+R1dG9
         ATJu36j1oY4fVWyP5VGMZyU7T8NWxiVLuDwrhvGD7BbOB1leagk15vxJp8DfHQl+lI2J
         PuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770007754; x=1770612554;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iI1Ccr3tQDh02EONmID1TL3UlMW3pFDSOrDm5zM+CFg=;
        b=uGqxKcNqI3ccQXaaCsRg/lk6ipExXuaydyDxA6/XssLqiWn1pgmbkc7SNTa8TGoMYr
         l1jna9E8OljYqW0jvIlARRMF2V1t5FoOSSaWkX8ES4d2UHzoLMQ/w/vu3igKgd9jNCLo
         hfftODQ49Ji5dA5j+iLCx/rKab3KzdlETkhBOcZH0HouWKdyAoAMYZJNCrwGX+8uHdoU
         6rQL+h7cRHpgQL43q+JKXcdlGqxZSMz7W8FB2JjwiirDFK4IkfO5L5Q2iF00lhMzooPA
         Ac8/PUWJ26qZowfpXVVt4tIvBExf6Cl3JGlL/uqhEV2FVWNyaRRJlS+dOg7O+2SiIrsF
         50DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe/Y6dtQdN80CU51qJx7CzDAayUgm7LGcE+xHgA6R6j0Z3Yv4Tr+VyixYQxabk/4Kn3TiusoxCQg==@kvack.org
X-Gm-Message-State: AOJu0YwG+QX2hont3tAKIh1cHCdm96BSHz6yw4K+lSVeqH23ds8rvx+N
	Sp+UCzthrPZzCntgeE1wD4+1Y4LIYRVikEn5CYw9mkeQ7MXfwzCUgoJwEh/lbgxXkg==
X-Gm-Gg: AZuq6aL7BzTH2NFcOgkDzKRl1zjOxZzHFfC/7hX6x712bTLYuToQrrIuSYriDd3bBBS
	CMy84XzlpYvxfNy+NMiLm0My4uQ6HB+tDQYOIhdxgCzIo+S0D+3CBo47JNawu5x03Wmm/8q7P46
	lEclD4CNWRT03sGLUeFg41beN0ODO7VPqZVBTluOlfcs60egmg09KyEniw5mo5+TSm15pX/338L
	vIndqBPkW6QCmJO9eCd/nbeL2TJEjJvesQaT37IZhAlSDIeLWh6t+6LhJ77G60LxSvmm5hNuqAT
	ETaEm2DFRkUjtgq4q/ziCU7y/YvIIcIAJ3iU+r2jtL6PoMdlETpHd48OhKYFjuvzi+ubsBv6qVC
	HYr88eLn+aWYHtkYPA5Kovajj68bp0CPb+6UKw06FAirP5AvNhL3gli1kYohuJDIyDvgiY9CT6H
	KHzX2bQnPPt9onzDfDWd58dzKmd+RpwjH2SJVNcn7BEBNIeI5J700=
X-Received: by 2002:a05:6402:1646:b0:64a:86db:526a with SMTP id 4fb4d7f45d1cf-658cb1cc407mr6482647a12.4.1770007754306;
        Sun, 01 Feb 2026 20:49:14 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b42563dbsm7592239a12.3.2026.02.01.20.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 20:49:13 -0800 (PST)
Date: Mon, 2 Feb 2026 04:49:09 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 08/17] mm: introduce bpf_oom_kill_process()
 bpf kfunc
Message-ID: <aYAsxRI2JGU9KCeO@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-9-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-9-roman.gushchin@linux.dev>
X-Rspamd-Queue-Id: EF5BE100005
X-Stat-Signature: qpdmdfaaneeduix9944x41ni5cftf5hu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770007755-381002
X-HE-Meta: U2FsdGVkX183vIhuPMxmY8e6CK9bpOTPnDrn0RHgNzqoBqbJYgRk/S8Zr3/7yDoGONnKfxg4d2isTPJGUA05F4owwbJstwVJUhojCM5R2lUzdIrjd5ua3aiAXllyQl9mGDszNX6gjlANUVygRi/iRT9iQ1gekZoomLKM8mrJqDRaMzGVPS0QJSPOdm51YHbFZ1NmXyszUiU2T6QfH7iYqf0+dEB/Uo5N8sgm7IQrhG2tz28NURTjRqGhaxLV77wSftdR4e920e3XX6nZJ6uqTqmptic40/Stk3Osa4V14gGnxlB5+Es1d9yFq/FG82dANVVP0dVDpmgNqsiNwKdGcWVxK/O876r+b9bWVljmbV4tsf6gNLAhhhHov34M61IznqC+VgVLYTMRdQqLf+ik4jxpJY7peJcHWfRA5SbNrBNuI8EpcJTIB9g08dz5AcjN1hNqt6DAHSgPCgo441DHcBrRO5Al32ZHHTuU6wmZ9vjVQWa3nBQiL7Iklb15WUqlWlfqwn2XaWoBoP6RQcr6n5ZuzdNpx6eQUxE4oGwQiZTjtHmgEzpyJ/zbfAX7fXU6ZT3Af1YPllxeDNlQKW/jNwJPoxgHYZyry5AZxXnfS1ipx8NwNQTa7Dmb5Z3FOFlCtKM/eGJg/0hl3C+L4MJGPGFsmnOYwrQb92KMBIRSvCGjT7M8N40phOZztKTD+9L/IAt/SbIg4mta2lau4vLtxf/KSBn3c/00/ofov7vYN5ev8Bh77qt4pXbj/0Gvn1LAE4vDqdFx4vTsUb/Tm7McieDwZfoEJxIv9cIuwmPmHWplv2hKBaFvjQZQzyoPULvOWdnSzzoBnGaJkJxruvBEzbivkLCJv9atQxmo+UFZiiXfF4Zrx+wALjAj2cVtDhgGWw7MCxzr6EcgLBfHrQvYxjgVYMuc9EDvsZbZtNXXbLFewkENSXKypc45G32GjaU+q0c+xb3KGfmJvJTHMjC
 jd3m1tyl
 pX2jhppe1cKwh9ix9V7kU8WR6JooAVggGHg3kLkAHJ19j9L60Wsf4C1cDuYfT0vKN6eP0gsp8pcKUoCDys8kdzX+k0v+ihABL4ZlrytCb0OVIzPYp7Ko1akbedOpqInCI/Ba4qgdbNiJ0aaKgJn6E6gNjfdRFLh+0SjuT0eSTUnvkLUHDLfA/rCSKkp26ooAk85nMZjknr3K6prWCQT5NI4XeU9fNqPXx2kZt3Dv6I2ofERcDvCZS1JIGpOksIjNbNNVHy1lalXX9tBhis3y4zixneKFdg4J8lIRcVBep0HpDCcIdM/6NdKcaub0ZIXbjBBnzdtpWFI46/3KQ5fPflsQaXvCMfNRqY7c5sJhjnN24Y90LHtwo2F1uNaQvzqbwdNti9YzIeYiovF6tYG2qsySi/x4kUnPIKZXj0KSGLHML4M8FbH/+4gdo9YDpGq+ebLPiv91qErcWIXpf+diWhMu1DOmlZmfaOgsOtwmuxZzqN9Xz+3mO+wQnRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 06:44:11PM -0800, Roman Gushchin wrote:
> Introduce bpf_oom_kill_process() bpf kfunc, which is supposed
> to be used by BPF OOM programs. It allows to kill a process
> in exactly the same way the OOM killer does: using the OOM reaper,
> bumping corresponding memcg and global statistics, respecting
> memory.oom.group etc.
> 
> On success, it sets the oom_control's bpf_memory_freed field to true,
> enabling the bpf program to bypass the kernel OOM killer.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/oom_kill.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 44bbcf033804..09897597907f 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -46,6 +46,7 @@
>  #include <linux/cred.h>
>  #include <linux/nmi.h>
>  #include <linux/bpf_oom.h>
> +#include <linux/btf.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -1290,3 +1291,82 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	return -ENOSYS;
>  #endif /* CONFIG_MMU */
>  }
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +
> +__bpf_kfunc_start_defs();
> +/**
> + * bpf_oom_kill_process - Kill a process as OOM killer
> + * @oc: pointer to oom_control structure, describes OOM context
> + * @task: task to be killed
> + * @message__str: message to print in dmesg
> + *
> + * Kill a process in a way similar to the kernel OOM killer.
> + * This means dump the necessary information to dmesg, adjust memcg
> + * statistics, leverage the oom reaper, respect memory.oom.group etc.
> + *
> + * bpf_oom_kill_process() marks the forward progress by setting
> + * oc->bpf_memory_freed. If the progress was made, the bpf program
> + * is free to decide if the kernel oom killer should be invoked.
> + * Otherwise it's enforced, so that a bad bpf program can't
> + * deadlock the machine on memory.
> + */
> +__bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
> +				     struct task_struct *task,
> +				     const char *message__str)
> +{
> +	if (oom_unkillable_task(task))
> +		return -EPERM;
> +
> +	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> +		return -EINVAL;

task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN is also
representative of an unkillable task, so why not fold this up into the
above conditional? Also, why not bother checking states like
mm_flags_test(MMF_OOM_SKIP, task->mm) and in_vfork() here too?

In all fairness I'm a little surprised about constraints like
task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN being enforced
here. You could argue that the whole purpose of BPF OOM is such that
you can implement your own victim selection algorithms entirely in BPF
using your own set of heuristics and what not without needing to
strictly respect properties like oom_score_adj.

In any case, I think we should at least clearly document such
constraints.

> +	/* paired with put_task_struct() in oom_kill_process() */
> +	get_task_struct(task);
> +
> +	oc->chosen = task;
> +
> +	oom_kill_process(oc, message__str);
> +
> +	oc->chosen = NULL;
> +	oc->bpf_memory_freed = true;
> +
> +	return 0;
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_oom_kfuncs)
> +BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE)
> +BTF_KFUNCS_END(bpf_oom_kfuncs)
> +
> +BTF_ID_LIST_SINGLE(bpf_oom_ops_ids, struct, bpf_oom_ops)
> +
> +static int bpf_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
> +{
> +	if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
> +	    prog->aux->attach_btf_id != bpf_oom_ops_ids[0])
> +		return -EACCES;
> +	return 0;
> +}
> +
> +static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
> +	.owner          = THIS_MODULE,
> +	.set            = &bpf_oom_kfuncs,
> +	.filter         = bpf_oom_kfunc_filter,
> +};
> +
> +static int __init bpf_oom_init(void)
> +{
> +	int err;
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> +					&bpf_oom_kfunc_set);
> +	if (err)
> +		pr_warn("error while registering bpf oom kfuncs: %d", err);
> +
> +	return err;
> +}
> +late_initcall(bpf_oom_init);
> +
> +#endif
> -- 
> 2.52.0
> 

