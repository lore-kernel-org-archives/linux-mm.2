Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26F0606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nzLGiReq
Received: by kanga.kvack.org (Postfix)
	id A9B346B05C0; Thu, 29 Oct 2026 23:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD6C6B05C1; Thu, 29 Oct 2026 23:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C2A6B05C2; Thu, 29 Oct 2026 23:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 595196B05C0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:05:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C72618034C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:11 +0000 (UTC)
X-FDA: 85377801222.18.0FF0904
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 28C1B20005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzLGiReq;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329510;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TMqRh8AjPgynXNlMj8JMQpf4n3lJs7duboOETf5IoI=;
	b=jI4UnaX1K/v91cuY2aqXmQP9bQ6c42zMedBvkr1X+PYn2CKbbnzeFwEoiD1n49Jg/Ojblx
	x9NFS1rX/tVko0ptzf1y6ZuCK3eE//5Wrqb6HtMwBmoB7c6bPmYdgOpncZ5Pu78nWDdQgR
	eKCjpuMgCvwARmp2eqtEC4dx8J1Fg3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329510;
	b=c8GpEngR2sdbLW6FnyanfO1SwP6/rVR2fMJPqZYymevsYNVbXT3JD5TjXjlkFSp/FiCZfp
	c3HEWWYuXJ8PwV8ZqavHk44LE5Z7Cq9NPvr+TgA19mQMIf1rZaXV1UpHHv0sWFBCZZoj3+
	jwt7t0eH2olSwdhBorsznS8QVxsYG7w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzLGiReq;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8044E44046;
	Fri, 30 Oct 2026 03:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1F81F00A02;
	Fri, 30 Oct 2026 03:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329509;
	bh=+TMqRh8AjPgynXNlMj8JMQpf4n3lJs7duboOETf5IoI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nzLGiReqfEZYEcu6a5r9o4Ef55tNYDaqPkbA3YaiYbyFJBOlXuw+033vgfM2e04uH
	 S6fpmGsGnKhTyi/fPoQz1pvpdR9Ryy9u8SFNHgqTzWJtw76YFalBfZvVWbE9QKyZO2
	 P56bCotW2klJX7hdV9oTcoT91sUFXeJpw9Q1BBfoD5yi3hyjxrwt6pkylNa4RXkPWO
	 1pzdlPdmkqNaaSNkR7cX6hVKASNY7ooVKsQwSZNWtKWaC18yluC71JK+ZDWVLMAscO
	 ZRtWiu1CDrM43orq//AvEYVF12rgFdmKYbLjVNI5y1sHv4fwvY5rjriC6A2l07rOae
	 MkgctvgTSXJ+A==
Message-ID: <sashiko-outbox-190210@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 16/17] sched/cache: Drop stale preferred LLC
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jianyong Wu" <wujianyong@hygon.cn>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Chen Yu" <yu.c.chen@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>
Cc: "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Ben
 Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>, "Valentin
 Schneider" <vschneid@redhat.com>, "K Prateek Nayak" <kprateek.nayak@amd.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Phil Auld" <pauld@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, maddy@linux.ibm.com, "Michael
 Ellerman" <mpe@ellerman.id.au>, ljs@kernel.org, linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn, huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn
In-Reply-To: <20261029025829.4005192-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
 <20261029025829.4005192-1-wujianyong@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:05:08 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28C1B20005
X-Stat-Signature: nbcmcg4fuazhykdiajiqejrki1rfg7s4
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793329510-458383
X-HE-Meta: U2FsdGVkX1/4B9DaDh5zThCSQwUqdH/InugYrkSrcKWIBQNTLoj03DsGe+qGkbE0h6a+L19qKOCoBNdCnDuIjvLkGbEVFBag1FFdqHExrWSZ3yOos9psb2KLbz85LlggyMF9YSQIyMcAgQaO5yfxCWQUFlLy+X7SbcDT8riFcohnrRw75g+NtD5OIy3KZAKYcMvk1quCNW7DCAKMvzRzXRkVAkDJ1YxYl5m6l8aHDNh0I5e8VYYjVH9vnf1EzoM/0imMAl+3WxLwIyMdbXddu7xBhD2bB/0JuJ6e9GUgmPR5Ow2Q6hMenzSeLTOwZjDHSd1MN5xEZo6OS/S8mTA98JSnOC1+tCAjBF9t2MxoGJT/4rktWhtY0wcyrfidiV8T6s1qGZEVXYkBTvn6lnsIgJH/5P1q01Z8e14LWLX6gKHrAnLZwRy1EDxEtDV1vLg3qQiB8WDfkt98CXMr91otApOfgYEPTxGZ6njj9h/wwV+ljt0TD9E/5XFsfsUeE7VYkj5WSvWb3jhOYJ2SvM46rKL4tUXrnuBwPu0e+O8byUznSG+hWtK1b83iktOZQUg6cRDIKzYNBW8ybqks2HS2kpmLQzhPF54h+xqBiyDY1DP/MIMtM+LTuoTe1f6a6/hfYAdhdZhh7qOxuA6QpN3c+Z+MXW4pvLbUYLFWYsHy4udbj9QT/Cr4hDGdJ+//hh+4B5jDg3dAL6DvuQ2RK0Riwn6GOXP2eG6dzDCOV0YYq4cQnIe481FRzXN9gj/grelSJnVQaHcTr8JaRgodPOK83b5uvZ5rIwlLp8AGfa4zVI8B7Ofc1qQDIsbF4lle1NRbB4SKmRErGsg1nRP/tnG0yTjdPdCGqjgNA9GG4rvwh8gPNKPxYyly6tlZC4g8GHC/AdFdj3pVFcrRaNVZZRGJD804/1dWX0EweQS5apP23JjdCl7rmp+lmHO5MRQRr9lk6XleURGtKGETUtYZLBB
 oy7j0hC1
 Zy1UrKx7R2czimJl5qAw0gxa8t6v7T+TYgHcbbPDtU1hLaOs5KhyJsP0y6lDDbmi5CmcnA89vWPcCRGdH/yr4CzXU4K32i5iLfWnLOUn6LsP7tIhYTaHxKWa7mAV47rt9uvLxqfa3zu+8ml6MfNl413AtjOaVMb5U204dgXj7o85Z8K7Ubri3BWHeyLn+6prXnUkNQWV1lKBssZEgq5LSn/c/5gFRxVLm9FdLwQX4jl/YG4FTVW0ih5q2Xu+R0WCkMXR+GKU/6djdRmRTAGAy0L0DfDxNaVZwzetsmd504LOjN+xJ15Thk52YrqvoyyXANl96+gYxFocwKuJPNqi/QXjNBB+oZrAV7RB1oAyVnxwS/F98RlXu5ZhkqTpL0w2UdPVFDJMqRXPqeQQVTSWLfLYosNY1P42fPtLu3mtQPPBFi0cku31OniypiuDStb2hKeCaQqbbDM170RC9zRnPMOs2cijHDXacSbeAAYQ3SlDkJrkG6gzKbywxXMI2R77DplfM6v5VdvEdn40RIix/LgsLPiuApjYPyvD0F339LjNQ96X2ejcHmhiI+aWcxZ7khDbn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] sched/fair: migrate_degrades_llc() allows unrelated tasks in mig=
rate_llc_task
--

commit a6df5e882c3ba89fef18f6405775608279e27938
Author: Jianyong Wu <wujianyong@hygon.cn>

sched/cache: Drop stale preferred LLC checks

This commit removes the NUMA preference check in get_pref_llc() and drops
the exact preferred_llc check in migrate_degrades_llc() so that
can_migrate_llc_task() determines whether an LLC migration is allowed.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b93b6e6c9deae..5d11f9b7f685f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
[ ... ]
> @@ -10898,15 +10880,6 @@ static bool migrate_degrades_llc(struct task_str=
uct *p, struct lb_env *env)
>  	if (env->sd->nr_balance_failed >=3D env->sd->cache_nice_tries + 1)
>  		return false;
> =20
> -	/*
> -	 * We know the env->src_cpu has some tasks prefer to
> -	 * run on env->dst_cpu, skip the tasks do not prefer
> -	 * env->dst_cpu, and find the one that prefers.
> -	 */
> -	if (env->migration_type =3D=3D migrate_llc_task &&
> -	    READ_ONCE(p->preferred_llc) !=3D llc_id(env->dst_cpu))
> -		return true;
> -
>  	if (can_migrate_llc_task(env->src_cpu,
>  				 env->dst_cpu, p) !=3D mig_forbid)
>  		return false;

[Severity: Medium]
Does removing this check in migrate_degrades_llc() allow detach_tasks() to
pull unrelated tasks during a migrate_llc_task balance pass instead of the
task that actually prefers moving toward env->dst_cpu?

When a source group is classified as group_llc_balance, calculate_imbalance=
()
sets up a single-task migration pass:

kernel/sched/fair.c:calculate_imbalance() {
	if (busiest->group_type =3D=3D group_llc_balance) {
		/* Move a task that prefer local LLC */
		env->migration_type =3D migrate_llc_task;
		env->imbalance =3D 1;
		return;
	}
}

And detach_tasks() stops as soon as a single task passes can_migrate_task():

kernel/sched/fair.c:detach_tasks() {
		case migrate_llc_task:
			env->imbalance--;
			break;
}

Without a check restricting migrate_llc_task to tasks that gain LLC affinity
by moving to env->dst_cpu, migrate_degrades_llc() relies solely on
can_migrate_llc_task(env->src_cpu, env->dst_cpu, p) !=3D mig_forbid.

However, can_migrate_llc_task() returns mig_unrestricted for kernel threads
(!p->mm), tasks with mm->sc_stat.cpu < 0, single-threaded tasks matching
invalid_llc_nr(), and tasks matching exceed_llc_capacity():

kernel/sched/fair.c:can_migrate_llc_task() {
	mm =3D p->mm;
	if (!mm)
		return mig_unrestricted;

	cpu =3D READ_ONCE(mm->sc_stat.cpu);
	if (cpu < 0 || cpus_share_cache(src_cpu, dst_cpu))
		return mig_unrestricted;

	/* skip cache aware load balance for too many threads */
	if (invalid_llc_nr(mm, p, dst_cpu) ||
	    exceed_llc_capacity(mm, dst_cpu)) {
		if (READ_ONCE(mm->sc_stat.cpu) !=3D -1)
			WRITE_ONCE(mm->sc_stat.cpu, -1);
		return mig_unrestricted;
	}

	to_pref =3D if_to_prefer(src_cpu, dst_cpu, llc_id(cpu));

	return can_migrate_llcs(src_cpu, dst_cpu,
			       p, to_pref);
}

In addition, when to_pref is false, can_migrate_llcs() can still return
mig_unrestricted or mig_llc. And when env->tol <=3D 1, update_sg_lb_stats()
and sched_balance_find_src_rq() only count affinity_score for tasks with
p->preferred_llc =3D=3D llc_id(env->dst_cpu), whereas can_migrate_llc_task()
calls if_to_prefer() unconditionally.

If any such unrelated task precedes the target task on env->src_rq->cfs_tas=
ks
(or if the target task is currently running on env->src_rq), won't
detach_tasks() detach the wrong task, decrement env->imbalance to 0, exit t=
he
loop early, and also prevent need_active_balance() from migrating the runni=
ng
LLC-preferring task?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029022036.4002=
331-1-wujianyong@hygon.cn?part=3D16

