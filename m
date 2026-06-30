Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6641FC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 20:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298ED6B00B6; Tue, 30 Jun 2026 16:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270A96B00B7; Tue, 30 Jun 2026 16:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187526B00B8; Tue, 30 Jun 2026 16:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4E936B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:05:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58334A064C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:05:12 +0000 (UTC)
X-FDA: 84937658064.16.9853536
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E24240013
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:05:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="WMQ3w/3u";
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782849910;
	b=PdHNaumAJLD8zmVGwyn9FfcvIInqY/WVxibYV3m3GzXfh3a1U1lbufTdmV1pnMrp+u4Joj
	9QE5qdEZp4K+OSIaKuTdDXPJRjxi/Xs+t4kVz1GeZHB3/Yp8PO9Z7K1CzFnrP+X9lLZfN6
	EdvAUtZl+9uLvUaQqXqjcfJXzZj57dE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782849910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBntxfJjDeY6lbfZFcve9iM3vJRAJtRX1PiDvu17VyE=;
	b=dWGaIK7UgfIZUU2StuTU7WwLnVFCgYdLDGtevDCn8ybGwlsrzqXGcFQiARz4XPhc/WfldG
	aqoEP74EDypKfaSF+ajT9cTDiZ0ey5SYVyytgdpm65xBCJOI8G/DYCBEGEgFpYllvhIBAY
	V4T0BcMs7bXc9jNl1z7tS31K3xU3a6E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="WMQ3w/3u";
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e65e18969so115959585a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782849909; x=1783454709; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lBntxfJjDeY6lbfZFcve9iM3vJRAJtRX1PiDvu17VyE=;
        b=WMQ3w/3uiMNP68AMaIGD77s3wTFtANYPqBLU/3XTvPbNGhMACDs9vKRE5rBTmV0j/R
         3YJKvtN282y1AT3vZ3wZttwazZRnx8oCW9yskIa5zoIUNFA9yh3H3HgTkSdw6mkbUlbX
         Po03N9RuinKEj+nCpiUE6wFGd4pkIUUOfnwrjEKnLuuAYnvF+HmvLhYGYy22Ff3GORP8
         r4ttULhHgH/lcxmlm/K+EzWZuRNDllqzfMLGF6T9Y86iyaze44E+wKONtlqV0uhVqLt6
         4cSNxnQYcYldKJWxaNkXV0bagA5EWsnqYwZQgys36sPWUZwzflAPBkDxZfhN0YK2GR3a
         8X3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782849909; x=1783454709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lBntxfJjDeY6lbfZFcve9iM3vJRAJtRX1PiDvu17VyE=;
        b=V5RG4iNmtFH8/5UIjuznzGaw1H4fg5nuFDetKV9Ebg3GZZSSmqPWHEULeZs5UZVPSG
         W0PeK2NL/AWtwD/+jhObUKt9ZUEytS0QPCPl3nH3b6BWUfK6OqDe9Jh2lx8J1SQKoRsi
         vgfFewCmUUD6J2nmQG8+veVW+j2bf4O92SCmGZTV7tRidf8konTSAf6hoJkwy7JMkCKO
         Vfo00P1k7AYnN88SlWPT4Uzqz+4g8HRTc0aYp0s6FoXBQVsBVg2Pog9XLg8DH8NZKJ8Q
         /2M3MoHd3du11Otdd4Wdk0fwaUblP1TGa3CoTQmGANvW5uFbH85VY/4y2oCAIiXhqz0q
         3FOA==
X-Gm-Message-State: AOJu0YyuJhD6tQ3CrtbFiCpYbtAHJuLKApXgZpGab3VJfA0GDRHQiH2L
	Fu829o3NZHzeUWg4j5x2QLleDt8h9KeSsgvjgUWUF9Ot+tqUNwWLhRjxb+wzNZhh++I=
X-Gm-Gg: AfdE7ckuQDBnAxvtvwlJOuCjwP3CCyFArshvSWJsyIeZenZtk4LaDJxDdMKGOMIx5sF
	bgKn7wGYiT9BbpY2Qdcz5ZnMU9hjT/I6CDzfsaFr69+/g/NzDf9ALYUY4fFuPBGOPDJ81p7tFBw
	DcfVv21yUPcSKSpES2FgcU1mKCp1ztk9fIvZIzQcZw0lE54mPVHl9NVoI+2/FnL/Z6NNX5aY1sd
	zWgapXhg8he5wVQuR4FLeYumilwKO6BxWAE2HnTVCluXxRY+WpE4p+JUpMx6ZX1arGHytrY8iN7
	0XaCXP3aaAtzGd9Bj7zNFSEfAkxsEyXeinufqSXVAUosuBQACCEnC50dYjxZdudsJ006TaULIXE
	I0eUVfJDnZt9/yfj5ndf1L+T4rCQQIXRBFEPb/XtnEhivBe8RrSvvEkCfVUUrgHOFW5GA7mSjVk
	HQ4XUMUhULtmA=
X-Received: by 2002:a05:620a:4587:b0:929:7356:2e51 with SMTP id af79cd13be357-92e696e6c05mr450617885a.11.1782849908902;
        Tue, 30 Jun 2026 13:05:08 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e622eb9d2sm325891585a.29.2026.06.30.13.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 13:05:08 -0700 (PDT)
Date: Tue, 30 Jun 2026 16:05:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, jiayuan.chen@shopee.com, yingfu.zhou@shopee.com,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/4] memcg: bail out reclaim when memcg is dying
Message-ID: <akQhcC60mufcxVHm@cmpxchg.org>
References: <20260630012909.144372-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630012909.144372-1-jiayuan.chen@linux.dev>
X-Stat-Signature: zjzdhpwedd8bndxzdptbwarh8b95jtkb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E24240013
X-HE-Tag: 1782849910-281488
X-HE-Meta: U2FsdGVkX18n9EyMuSb0E1l85Dh6bhao+q+kndFi+/poqWq6YzPgQl40o6cUT47kzmh1RRYTqCpk0vvpzR+bgOu8pXL6yoPqoUW8mJeqqc4ILBVyMbrZ4CihDaWgXy0AXIsxLuFngWiWknmNIVXs+bRlsISp8XB//JzDOD/9tPRAYDI+15c3uCJU413cun0WA2Y9yy4RcbnMhtWEq3ezP/D4s7IQQb3zoXJWqvENx3BbdAT7VsWwl6BVRrLO1KHM4Vvus9lxMuvqcherkk5is5d4e+K4UmgL2PTcd3m90Wcig1sNVPrM8kFT5DfN9H5LeG3mh21veZ/me6m5hUxqv316/2BnLDyFb4DLoWZtN5J69qZF9KrfJvf7XD4YKSqDCK5lNSp2qeLlelGSpOC4V1VGzeZgNwWKtYIqrG0i2V+IFuSXKeZuFDg7Jfq1BXCsS4U+CPAffxUuracQsUsDUD5qq0G7wQGqshvL4sIByJT9aqJ4t939GOe5SvtcH6nouhKn57KQAEGISFysfuY/P3dJVfYHLZkxBwILHme89zxX09eHmpBRkvFu/nVoVcjSn7vvBtSIZfnO6pvewKnyVzEAOAd5JBbss5MQF2xvb2rcGeePzlk73kqBVRFlujnClxAkqNDPA8kUzXX/yu8dIkXQyWGMtGOWLJfT8rkwO7+bSq9DCERlxyEG9VfvG6wcgS/zF28a3qF/yE+h3xE0IlUF0C0dBGrFdDpL2G5relEKsYnRpmwk/rM6fRehz3eGHrC/L+1/kkP+BIPkXi/BaEmG9U8FS0DU9T55q0uxr3+GPa+PGAQXoO5+sJi8M1TaC4/otMddEAhsTwRBUbhJYcvwHSYl7OlqT3KW9EhQc7jiPFcQl5ZSy91ZwswOkLWXEccOQYjUAXfduhbvzVrMMm5mNn+7VyG3/sImvdf1GU0nk3FkssjlNg1BJeQr7si0j2IieF53UthVciEiRmH
 jHc7W2xd
 0Aq/be6bIEwfFefaX7InWzpyzqdVDrto6Fa7Te7MPF5gBq/o63FTnRKqavA7z9vX1IhziIXpmYYBMVWwkmsnuxdV8H7zexSD/ZCTO3+nWhotCbJsxiuGWdbccQa875GdC4Zj58H9GCQoQEy5icmvSFxX8i0iPvpKFIP1iQniZGj65gnTb7RKlAVEYa3rpjJzRpKvOJ3WetEcRCfJZsahcA89crM0d5Eneo7On0q+Z0Yz3or39WHBJfuH1eb5p5YQCkkX+8/t+p4svk4J98VikmsL/e66Hu2mL7H7DdEbG9GBLi4a3JoKmu1gt/bFi/2mavUL7xyNy2fXDR5Nq0WD6y9jr6syQjEcxPPzZlqzWiutS88KKxYhi2WoJmlb/C7dj8Z6dBo2HIzugfP2B9MuEjq0JU/AvvILgs9lfP5VotsEJlaun8ZUJJFz2kyUa3Zib/lf2gK1c+x07DhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series looks good to me. But please add

	/* cgroup_rmdir() waits for us with cgroup_mutex held. */

to these bailouts. It's a bit unfortunate that we need to have these
inside memcg. But decoupling this on the cgroup core/kernfs side looks
like a bigger project, and we should get this bug fixed.

With that, please feel free to include in your patches:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

CCing Tejun as well, full quote follows.

On Tue, Jun 30, 2026 at 09:29:00AM +0800, Jiayuan Chen wrote:
> Hi,
> 
> This series mitigates a system-wide stall we hit when a cgroup is
> removed while one of its memory control files is doing synchronous
> reclaim.
> 
> Problem Description
> ===================
> 
> Writing to memory.high, memory.max or memory.reclaim runs reclaim
> synchronously in the writer's context, looping until the usage drops
> below the target (or, for memory.reclaim, until the requested amount has
> been reclaimed). On a large cgroup this can take a long time. The
> latency is especially bad when reclaim has to perform swap I/O, where it
> is bound by the swap device write bandwidth, and under thrashing it is
> effectively unbounded - each round reclaims a few pages that the
> workload immediately faults back in, so the loop keeps making "progress"
> and never converges.
> 
> The legacy (v1) reclaim loops in memory.limit_in_bytes,
> memory.memsw.limit_in_bytes and memory.force_empty share the same
> pattern.
> 
> These writes go through cgroup_file_write(), which does not take
> cgroup_mutex and does not pin the css. Instead, kernfs guarantees the
> node (and thus the css) stays alive for the duration of the operation by
> holding an active reference. So while the reclaim loop runs, the active
> reference on the file is held.
> 
> If another task removes the same cgroup in parallel, cgroup_rmdir()
> takes cgroup_mutex and then blocks in kernfs_drain() waiting for that
> active reference to drain. Because cgroup_mutex is held throughout the
> wait, every other task that needs it piles up behind the remover - in
> our case the whole machine ground to a halt, with hung_task reports for
> the remover and for unrelated tasks merely reading /proc/<pid>/cgroup:
> 
> INFO: task cgdelete:366634 blocked for more than 159 seconds.
>       Not tainted 6.6.102+ #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Call Trace:
>  <TASK>
>  __schedule+0x3da/0x1650
>  schedule+0x58/0x100
>  kernfs_drain+0xe6/0x150
>  __kernfs_remove.part.0+0xd0/0x200
>  kernfs_remove_by_name_ns+0x75/0xd0
>  cgroup_addrm_files+0x325/0x410
>  css_clear_dir+0x50/0xf0
>  cgroup_destroy_locked+0xdf/0x1e0
>  cgroup_rmdir+0x2d/0xd0
>  kernfs_iop_rmdir+0x53/0x90
>  vfs_rmdir+0x98/0x240
>  do_rmdir+0x172/0x1b0
>  __x64_sys_rmdir+0x42/0x70
>  x64_sys_call+0xeb0/0x2210
>  do_syscall_64+0x56/0x90
>  entry_SYSCALL_64_after_hwframe+0x78/0xe2
> 
> 
> INFO: task systemd-journal:2352 blocked for more than 182 seconds.
>       Not tainted 6.6.102+ #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Call Trace:
>  <TASK>
>  __schedule+0x3da/0x1650
>  schedule+0x58/0x100
>  schedule_preempt_disabled+0xe/0x20
>  __mutex_lock.constprop.0+0x3bb/0x640
>  __mutex_lock_slowpath+0x13/0x20
>  mutex_lock+0x3c/0x50
>  proc_cgroup_show+0x4d/0x380
>  proc_single_show+0x53/0xe0
>  seq_read_iter+0x12f/0x4b0
>  seq_read+0xcd/0x110
>  vfs_read+0xb1/0x360
>  ? __seccomp_filter+0x368/0x590
>  ksys_read+0x73/0x100
>  __x64_sys_read+0x19/0x30
>  x64_sys_call+0x18d3/0x2210
>  do_syscall_64+0x56/0x90
>  entry_SYSCALL_64_after_hwframe+0x78/0xe2
> 
> The system recovers only once the reclaim finally finishes and releases
> the active reference. The reclaim itself is pointless here: the cgroup
> is being torn down and its remaining pages will be reparented to the
> parent anyway.
> 
> Even though we check signal_pending(current) in the reclaim loop, the
> typical symptom is that cat /proc/<pid>/cgroup gets stuck.
> By the time someone looks for which task is actually stuck in reclaim,
> the hung task timeout has already been hit. This makes the problem
> particularly nasty to debug from a hung-task report alone, because the
> blocked tasks shown are often the victims, not the reclaim writer itself.
> 
> Our Mitigation
> ==============
> 
> cgroup destruction sets CSS_DYING in kill_css_sync() *before*
> css_clear_dir() triggers the kernfs_drain() that blocks the remover. The
> in-flight reclaim loop is therefore guaranteed to observe it before
> starting another reclaim iteration. This series checks memcg_is_dying()
> in the v2 reclaim loops (memory.high, memory.max and proactive reclaim)
> and the v1 reclaim loops (memory.limit_in_bytes,
> memory.memsw.limit_in_bytes and memory.force_empty), and bails out early,
> so the writer drops the active reference promptly and the remover can
> make progress.
> 
> Unlike the no-progress guard (MAX_RECLAIM_RETRIES), which only fires when
> reclaim makes zero progress, the dying check also covers the slow swap
> I/O and thrashing cases, where reclaim keeps succeeding a little and the
> loop would otherwise never converge.
> 
> For memory.reclaim, bailing out because the memcg is dying means the
> requested reclaim amount was not satisfied, so the write returns -EAGAIN.
> 
> This is orthogonal to commit c8e6002bd611 ("memcg: introduce
> non-blocking limit setting option"): O_NONBLOCK lets a caller avoid the
> synchronous reclaim up front, while this series handles the case where
> reclaim is already running when the cgroup starts being removed.
> 
> Changes since v1:
>   - Return -EAGAIN from memory.reclaim when the memcg is dying.
>   - Add the same bailout to the legacy v1 reclaim loops.
> 
> v1:
>   https://lore.kernel.org/linux-mm/20260623062800.298514-1-jiayuan.chen@linux.dev/
> 
> Jiayuan Chen (4):
>   memcg: bail out memory.high when memcg is dying
>   memcg: bail out memory.max when memcg is dying
>   memcg: bail out proactive reclaim when memcg is dying
>   memcg-v1: bail out reclaim when memcg is dying
> 
>  mm/memcontrol-v1.c | 6 ++++++
>  mm/memcontrol.c    | 6 ++++++
>  mm/vmscan.c        | 3 +++
>  3 files changed, 15 insertions(+)
> 
> -- 
> 2.43.0

