Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34923606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCgZy5qf
Received: by kanga.kvack.org (Postfix)
	id 5577C6B05B4; Wed, 28 Oct 2026 10:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509356B05B5; Wed, 28 Oct 2026 10:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ED76B05B7; Wed, 28 Oct 2026 10:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18B2D6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:40:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5ED7140CB0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:40:39 +0000 (UTC)
X-FDA: 85372296198.23.EA8603A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0109EA0008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:40:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCgZy5qf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793198438;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UO6RmKcJE10QTH3ZadoMY9QD4yuWfH2RUsJYv6CYdk=;
	b=XqqljbGiX8kgdA5ZrilsbKPr1zPiN9e+muM4vMOyfGIARdkn/Tyuhx32QY/yLA6CYyAa2A
	qXbTaYLVF+oYr+XxCEfHPdjXF4s4XNRKUEa3SzKHZPDEE2pfjtXyJ8Zu76JpRgERY4xAeX
	Dv8F8mUoGDx3N2uLHPnVzotIxe3o/Ws=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCgZy5qf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793198438;
	b=PD19HbXtgiPDk3Ily6l/LEF9JeWJG/OtnzubXi8lPt7HgSC5H8caPyoZY+ZHUgMTVAJibi
	Cq7J7unPg10xW0tv5+3WXDZfaa3usAxTUQkK0SgpsCH0X4g/otxmAgq4WTPZ5Df88hCJPA
	rSXv6YcssroeY3rQ+mYCreM5qaIX4Fg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A8054056A;
	Wed, 28 Oct 2026 14:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3681F01825;
	Wed, 28 Oct 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793198437;
	bh=4UO6RmKcJE10QTH3ZadoMY9QD4yuWfH2RUsJYv6CYdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GCgZy5qfnGDfZ++KI0lfMBbpJfDL2VTbFJJzaJ2q2Zp4VgRytYKHhjxxSp3MXNRwj
	 WqPsqrxMVn+vJQ4QeWC93UlmzQiQUTOOTFOhu+7GneU/tx/Tdpj4QmVV5ouBFI7eNP
	 pRETpLQxfsblLohG/omvEgxYF5+XAb5EE7c0aioqqc7XuDm2S3umZKHC6zKGHS6OMF
	 ToPoQL4UKPQbEJB1L15sNTxtHOaLRiykIR3LfMR2HcDFbFOvLJ40sY6Ha2+Kn3XkKK
	 CxizmvCZF6/dN4tfRtgWNfBEclSJXfifSL6zUUD374FeOw8m6CpKstUeFxxBBEbfnh
	 cgsgCPNmuhhwQ==
Message-ID: <sashiko-outbox-188003@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm: memcontrol: don't miss processes whose leader
 has exited in OOM scans
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhan Xusheng" <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, penguin-kernel@I-love.SAKURA.ne.jp, tj@kernel.org, mkoutny@suse.com, cui.tao@linux.dev, linux-mm@kvack.org, zhanxusheng@xiaomi.com
In-Reply-To: <20261027144016.2582880-1-zhanxusheng1024@gmail.com>
References: <20261027144016.2582880-1-zhanxusheng1024@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 14:40:35 +0000
X-Rspamd-Queue-Id: 0109EA0008
X-Stat-Signature: 8x5udazymew55fcgy7mx3pp9kj74or3q
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793198437-104962
X-HE-Meta: U2FsdGVkX1/bDsocKOKEKtiWVF5OthUg5iZEb/LJCdDtPbNBZHdKDUgrhmCFf3QFrdYQdwQH7R8CVMryTP6XPjZEb3DBLK9BxRG6/hQLdkUrQlH91AmF96NmBmx3jrtoh6IEpwmpSL1gro0xDhtVa9nNgaEBDNJV1XBwBzY0w0p9ei+6oURl3qr3dH+lF3tpf+cR1+fRgQkHkqNknySGpbTf+eviYEfx9IptFpfNguFv9X3+V8nL5XvktiLLzOQHg8BgWrG50iHTxh9Vg4/FbpG2vN07ksr82JR4LOnLdGD0yHkgAk1gDFR3ktcSIEGJzPsqPlMUGXP6Sby4wvaeQoXvfYlQyrIgPkKD+9J0FCDbME/MoPxXB7AsndoaP7scZLNh5/Dh7raEnhzooBnaGBbJlwnA4TQ6C6YKk4kLIeQCXXvJkDThUhLR0inSZhCa63ObO+vfIQfCDDdOFChexiGIymxPzR5vq3BsXClVygiXFXExH3atLMOT+b1+1qAbocT62R6YaGJiUMcmOD//m6ovWJusdwKFgsYaXBelH2Mf8nq13A4CHcSYCLXLk+BG1z6JDzSa62gCbut9B2aBXzQ9fumsz7It+qIB1CtoMTRHWWEqZv0lqk9c2rdzP4rWSG9Zz4tQN/isTqyUAG9RSZRmNSEqsOMyXGZCOfo44J+D/0cyf4ciLkwpRmEo9vfnZRb5EIG8mrZ9D9bGEU/lHd51euCON1pvhDq9fjeJ3E19D6PB/3GmDcxh2nh3q4f1BB1SUaK5ARS/o0bf7ChJHtlR1VnXbRgzZsJ1Sq7d6gRoZbceLtAEB49alGPY+tfOK2l9C/uycp8OTgYmvvBdnTc/+CzAL3l8kDUjycJ5QP9xTi0HYrUIYUVEXPK0tkIJOJs2iyv2rDpHulHCBq188z4MiEK2O6W9k8W1/bqhvZVoUNP18t2pdHR0lY95ZAKUMB72AOCuBAqcgbGlJzF
 r5qenhM3
 wU62Y891myYAXUw0LynciFz7x2wcQ/aYAhCu7NqqDA45cOCjWbqhPw9j2ejQrtvxI4zHwCgcEXurwebr2WOZJMe5uohGcVRVgh/DRAvk+8SURF/AvqGwBov1yD9OsKm6UFB1MLE8fcUMOL14IhTUCb2DwfWPqmg7/y2HxKAfMx00FADnq3GaN8E7BKtc2egxsrisgM+BIg2FZOjOfX7ETMbEc7TXbLM/UURLsqbncnTPNTwFw5sneGcD0DQ/rkZWQpDsN3INTBJbtAYfbRXh2lv3raoXMN3r1+figFXYU5WZhAakCUde/YdKvPNbB9uJWL6g7jv7RMIFLa/iE1hSn3t28liN3Uci6FSDAvS2FE/xseNYhfhHkjV2VGzyWY8T9GlPt1i3DLJwEZyPrjzVHhMH6KKjl2I3mCVU7/aXPcv/NR1RSfbVtwvBmFiyjol7fjpfB8jvm8bt9mi+UZCKqfvini5rZqpPTxMqrNdvywQIY3S2P/hKVgq5D2hmxBLDQXKM5S3+O+93ZZzbPzZ1APHtIJx1YosSOrLFJlBajq5GDghGTiR9eSshn5JO9HTdyieV0oHZP5e4owEdLyzMI/YW326Bbsxl4vYBKgpiKusteqrgIbViJWsYAsCkHemg+7PqvDbcfYqKgImCp388Y169okxb7w5KAT2YyUg1yiCsYOOZvGAmGgakttw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: memcontrol: missing CSS_TASK_ITER_WITH_DEAD in mem_cgroup_scan=
_tasks()
- [Medium] mm: memcontrol: mem_cgroup_scan_skip() exposes left-behind exiti=
ng threads
--

commit d38ecbf0e3676dcb916e1092ca97674d2480a1b1
Author: Zhan Xusheng <zhanxusheng@xiaomi.com>

mm: memcontrol: don't miss processes whose leader has exited in OOM scans

This patch walks all tasks in mem_cgroup_scan_tasks() instead of using
CSS_TASK_ITER_PROCS, adding mem_cgroup_scan_skip() to select one
representative task per thread group in the scanned memcg so that thread
groups migrated after their leader exited are still visible to OOM scans.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4d00748c8a5b8..cdb8ca4d4625d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1427,6 +1427,38 @@ static void invalidate_reclaim_iterators(struct me=
m_cgroup *dead_memcg)
>  						dead_memcg);
>  }
> =20
> +/*
> + * Let one task of each thread group in @memcg stand for the group: the
> + * first one that is not exiting, or, once the whole group is exiting, t=
he
> + * first one that has not exited yet, so that an OOM victim stays visibl=
e.
> + * The leader is not enough: a group whose leader has exited can be moved
> + * without it.  Exiting threads left behind in @memcg do not count while=
 the
> + * group has live threads elsewhere.
> + */
> +static bool mem_cgroup_scan_skip(struct mem_cgroup *memcg,
> +				 struct task_struct *task)
> +{
> +	struct task_struct *t, *dying =3D NULL;
> +	bool live_elsewhere =3D false;
> +
> +	guard(rcu)();
> +	__for_each_thread(task->signal, t) {
> +		bool here;
> +
> +		if (READ_ONCE(t->exit_state))
> +			continue;
> +		here =3D mem_cgroup_from_task(t) =3D=3D memcg;
> +		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
> +			if (here)
> +				return t !=3D task;
> +			live_elsewhere =3D true;
> +		} else if (here && !dying) {
> +			dying =3D t;
> +		}
> +	}
> +	return live_elsewhere || dying !=3D task;
> +}

[Severity: Medium]
Can mem_cgroup_scan_skip() still expose a left-behind exiting thread in the
source memcg once the migrated threads in the destination memcg also begin
exiting?

In kernel/cgroup/cgroup.c, cgroup_migrate_add_task() skips any thread with
PF_EXITING set:

	/* @task either already exited or can't exit until the end */
	if (task->flags & PF_EXITING)
		return;

Consider a thread group in memcg_A where thread T1 enters do_exit(), sets
PF_EXITING in exit_signals(), clears T1->mm in exit_mm(), and has not yet
reached exit_notify() (so T1->exit_state =3D=3D 0 and T1 remains on memcg_A=
's
cset->tasks).

If the process is then migrated to memcg_B via cgroup.procs, T1 is skipped =
and
left behind in memcg_A while live thread T2 moves to memcg_B.

If an OOM scan in memcg_A advances its iterator to T1 while signal->live > =
0,
and T2 in memcg_B then enters do_exit() and sets PF_EXITING before completi=
ng
exit_mm(), mem_cgroup_scan_skip(memcg_A, T1) will see PF_EXITING on all
threads. Because live_elsewhere only tracks threads without PF_EXITING,
live_elsewhere remains false and dying is set to T1, so
mem_cgroup_scan_skip(memcg_A, T1) returns false.

Wouldn't that expose the migrated thread group to memcg_A's OOM scan in
oom_evaluate_task(), either aborting memcg_A's scan if T2 was marked an OOM
victim in memcg_B (via tsk_is_oom_victim(T1) checking T1->signal->oom_mm) or
reaching T2's mm via find_lock_task_mm(T1) and killing the process in memcg=
_B?

> +
>  /**
>   * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarc=
hy
>   * @memcg: hierarchy root
> @@ -1452,9 +1484,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memc=
g,
>  		struct css_task_iter it;
>  		struct task_struct *task;
> =20
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		css_task_iter_start(&iter->css, 0, &it);
>  		while (!ret && (task =3D css_task_iter_next(&it))) {
> -			ret =3D fn(task, arg);
> +			if (!mem_cgroup_scan_skip(iter, task))
> +				ret =3D fn(task, arg);

[Severity: High]
Should css_task_iter_start() pass CSS_TASK_ITER_WITH_DEAD here so that the
dying-group fallback in mem_cgroup_scan_skip() can actually see exiting OOM
victims?

In kernel/exit.c:do_exit(), a thread sets PF_EXITING and almost immediately
decrements tsk->signal->live before tearing down its address space in
exit_mm():

	exit_signals(tsk);  /* sets PF_EXITING */

	seccomp_filter_release(tsk);

	acct_update_integrals(tsk);
	group_dead =3D atomic_dec_and_test(&tsk->signal->live);
	...
	exit_mm();

However, in kernel/cgroup/cgroup.c:css_task_iter_advance(), when
CSS_TASK_ITER_WITH_DEAD is not set in it->flags, any PF_EXITING task whose
signal->live has reached 0 is skipped by the iterator itself:

	if (!(it->flags & CSS_TASK_ITER_WITH_DEAD) &&
	    (task->flags & PF_EXITING) && !atomic_read(&task->signal->live))
		goto repeat;

When a concurrent memcg OOM occurs while an OOM victim is unmapping its mem=
ory
in exit_mm() before setting MMF_OOM_SKIP, css_task_iter_next() will skip all
threads of the victim group because flags is 0.

Doesn't this prevent mem_cgroup_scan_skip() and oom_evaluate_task() from ev=
er
seeing the exiting OOM victim during exit_mm(), causing out_of_memory() ->
select_bad_process() -> mem_cgroup_scan_tasks() to kill additional processes
instead of aborting the OOM scan?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027144016.2582=
880-1-zhanxusheng1024@gmail.com?part=3D1

