Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622F4606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v1qf0Ngn
Received: by kanga.kvack.org (Postfix)
	id 7576E6B0741; Tue, 27 Oct 2026 09:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FB36B0743; Tue, 27 Oct 2026 09:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C726B0744; Tue, 27 Oct 2026 09:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38FD16B0741
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:26:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9645809E2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:26:46 +0000 (UTC)
X-FDA: 85368481212.23.707E89D
Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 66FC220002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:26:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v1qf0Ngn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793107605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqw+TfDddRRG6oehvVdMMbadresy6pl8QAbpbcWHAzw=;
	b=5AQKKT1C2duiBbWTuZgtCyf1Ah3F6EwNUk4YoBZof1Y/6FGQe0seRfzyJtsmctrAYxzhh/
	b4xHy15h7H7t+2VJVTE9wHqCQ/h+lSYPszY5Uor9d3ui1bHy8UPIRtawXLjsfKK2dNP3oT
	Vl/eoH++m86wDfBVi0NSbN4l9uhX55o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v1qf0Ngn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793107605;
	b=oFxqFfatK2wl4xXDZgL3nTH22s+0Vps/8kdmXkBkaak/6nj/3au1cDdjzSOMN2GI76E354
	K0NA+V6JZSsI7XSg77iDFCbuzAdUiejhjAAa0/6/pVC+vpkpnQp31MN5NeCA/MlWeBnTiG
	k3qzN/tiqJQ5G5YQvgUcLBY9pGQ8Mfw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bVchNI6MPrPq2ISgrQi9jHRX7+8yy0AAnhLVZeK+Z7k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793107603; v=1; x=1793712403;
 b=v1qf0Ngn9OHSgT9zQUDtoO3QxMfR++VGO24HB3b4ODQIcAcXUm2XGZOUKA1yVmU9Hcm14L96
 MjR9ufZ0k12bRgmrywuOKIJ8mpxD+9b3GHMbmNdxTjpd4+wl9qhM87V/z0bOLwE6UoQiGNRZB/V
 o9DQb4k0PF76ae4CrDU+6kC8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 21122a2229b38990;
	Tue, 27 Oct 2026 13:26:43 +0000
X-Mizu-Trace-ID: 21122a2229b38990
X-Migadu-Flow: FLOW_OUT
Message-ID: <823d68e9-dda1-4458-94d9-fe4872832d7c@linux.dev>
Date: Tue, 27 Oct 2026 21:26:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 penguin-kernel@I-love.SAKURA.ne.jp, tj@kernel.org, mkoutny@suse.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhanxusheng@xiaomi.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org
References: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66FC220002
X-Stat-Signature: mr55cah3w5j5k6ywugns89fdi9bo6g45
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793107605-497264
X-HE-Meta: U2FsdGVkX1+owzijpl0ePKdsIuR7kWM2KoffNhQMrensrFQ2So3N2vnlB9TB5yH0lYnhEWvOTqqTSw3mh4OPGTutLTK4cChF8IEypjNQ8qnsdXJUZ0Q6g9+yyvSsari89Kb2mnC8omyDLjVgxPG8uLuWOk2EGkaPLHe5J2NTcBLIx+fh+4g9rjN8T5Uf9cMSvojux5qfuutRs8U9R8VL3JHh4Qqfp339YXTKYJERT2RhhpNq8ASHq9tN8vhsbxfNkILm1gHZfGXduvI8Hb9B4hloRHVXPdnrowg1hiSMtR4MZkcQCSXVPpBn7VEtTwag7Qz8zbqT3y01xc90Hf9MoiVutsN32q6nJQfxwTLnAokIqA3Ur2WAbJ/+Nx3rFfx0Ypuna+nKCeQJiYjh7NloJQx9CHdjTlds2kjbaUE6w0u+zncbVo5usQZD5u29A2GmcRxURUPqjLX0V+VugUT8+u/4ol+BE/zu6d+JfPnhI1mGrH98QIW4SxrpbbFlLWOPefvK0SRJ5uQcB6THOjhOzBLuYdK9lOMzNoS8GuXzJ6kn13nlVwIIcoRS1FB0PXwRfZORVs+RdPuaoe8Jnz1WxYk/4ib3HSlMvNlXqlYB5n2HVyLEzXxc+12Ohlbn8YhKhI6ieuKWyOjEKYf/V21YH0Pth2GPJyxAzyBUzmKFWvWsqZdyHVgM4Zi2SO0oSD+QZ3j0GUIiXetNND43HWyPsMjQfeV++qvU5CXVmNzmMbVN6Ll/On6MZCNvzm/2ALs586wvki3Ikt8Y4W+9ZPt9hnKCryaOhDHjxOSUNmlPDrE5zIE0SCkdysnlOLS+Dssgd/BGIVz4O3hOPNzJZcGY7/oOWkpWR7B7MjyfcXykvYa1iowBBPDIT0FZmh6HYo2sKbOE5TtKF+G8DFycZV7GO6BPMxkPOLd8fB4J98HbKH2ePmoKlgJsyhHWJ+Rzp9uXNeXbkcnFbvbcNzCIVwf
 BTZnvjDZ
 WzO3DbLGZxCg6fkuv3qqhx2Dt0sHKFSEfFc/maS9d3IxkAqofQachp5RzElOxzGyNMAw3m7QlMQjJZHfXHyOA6Uht0JHLwgFxVm+F2AJ7FNPj8AFxxw8Idg8lpj3yI/I8FUBvy+mPRqYMPPalkLNQML6IqtKKXTG/AwdXoSappqKwALAvZKzmg/9N1yZKd/fOQMTrez8ghefyRjAo4QTwZa+BYQ98xHT0/CjyLw6LyD9tssuizPKulJSXLDLb1/soucpYcXEyu0H1MtaOyf22ZHhY5ERbzwxkRoDfAgAz/CKQD/Jwx+u+46dadQGLak+BbHdFl2O1pqoMYwmYqrI6kbPvO4lNV+/bHZIbzOfJnU9B1JOM4k9aT05D618VOzEzbIcLwRJUcSroj+UTCyh3fjkzqsiH1xKljr0ONsmt23+95rA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, Xusheng,

在 2026/10/26 20:02, Zhan Xusheng 写道:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> mem_cgroup_scan_tasks() walks with CSS_TASK_ITER_PROCS, so it sees only
> thread group leaders, plus a dying leader that still has live threads.
> Moving a process whose leader has exited, by writing its PID to
> cgroup.procs, moves the live threads but leaves the leader behind, as
> cgroup_migrate_add_task() skips exiting tasks.
> 
> The destination's OOM killer then cannot see the process.  If it is
> alone there, every attempt ends with "Out of memory and no killable
> processes..." and the charge is retried indefinitely, and
> memory.oom.group kills nothing; otherwise another process is killed in
> its place.  The source's OOM killer still finds the leader, reaches the
> moved threads' mm through find_lock_task_mm(), and kills a process that
> has left the memcg.
> 
> Walk all tasks and take one per thread group: the leader, or the first
> live thread once the leader is exiting.  Skip exiting threads, which may
> belong to a group that has moved out.
> 
> Tested in a VM with memory.max=64M: in each case above the process using
> the memory is now killed, and a process whose exited leader was not
> moved, or whose leader is alive, is killed as before, with and without
> memory.oom.group.
> 

Tested on next-20261026 (x86_64 KVM guest, cgroup v2, 48M memory.max
on the destination group). Without the patch the worker thread stays
alive and the OOM scan keeps printing "Out of memory and no killable
processes..." (2887 oom, 0 oom_kill in one minute). With the patch
the worker is killed right away. A live leader and an exited leader
that was not moved away are still killed as before.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Tested-by: Tao Cui <cuitao@kylinos.cn>

Thanks,
Tao

> Fixes: f168a9a54ec3 ("mm: memcontrol: use CSS_TASK_ITER_PROCS at mem_cgroup_scan_tasks()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
>  mm/memcontrol.c | 35 +++++++++++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4d00748c8a5b..8823c549b6af 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1427,6 +1427,36 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
>  						dead_memcg);
>  }
>  
> +/*
> + * Take one task per thread group: the leader, or the first live thread once
> + * the leader is exiting, since migrating the group leaves an exiting leader
> + * behind.  Exiting threads are skipped, as one left behind may belong to a
> + * group that has moved out.
> + */
> +static bool mem_cgroup_scan_skip(struct task_struct *task)
> +{
> +	struct task_struct *leader = task->group_leader;
> +	struct task_struct *t;
> +	bool skip = true;
> +
> +	if (READ_ONCE(task->flags) & PF_EXITING)
> +		return true;
> +	if (task == leader)
> +		return false;
> +	if (!(READ_ONCE(leader->flags) & PF_EXITING))
> +		return true;
> +
> +	rcu_read_lock();
> +	for_each_thread(leader, t) {
> +		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
> +			skip = t != task;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return skip;
> +}
> +
>  /**
>   * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
>   * @memcg: hierarchy root
> @@ -1452,9 +1482,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  		struct css_task_iter it;
>  		struct task_struct *task;
>  
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		css_task_iter_start(&iter->css, 0, &it);
>  		while (!ret && (task = css_task_iter_next(&it))) {
> -			ret = fn(task, arg);
> +			if (!mem_cgroup_scan_skip(task))
> +				ret = fn(task, arg);
>  			/* Avoid potential softlockup warning */
>  			cond_resched();
>  		}
> 
> base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a


