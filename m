Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B3410F995A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2892C6B0088; Wed,  8 Apr 2026 13:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212CE6B0089; Wed,  8 Apr 2026 13:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA716B008A; Wed,  8 Apr 2026 13:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3A2A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:01:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74843160216
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:01:12 +0000 (UTC)
X-FDA: 84636003984.08.631FB4F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5772C0020
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:01:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ikjTaqfk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775667670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWlcN0d2sqnEz/Q4L3iF8sYk4gtZDkaL7FX/NnHp/cg=;
	b=SI4na1ywRYbpgmMPOH36thAs7tkPD3rfdkU1FbtGdpBaoZudrK5/dYNutIQxwbm4dkZRLj
	FXyDormM1Rfu+z+RLXUW2x6wQk7FiMx1+UNOSMLSHrYJgoxf2cVQ2gUIWLNuYVhg5wRUNp
	hudyuBvrLtQDsob0F4PwXticlhInJnQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ikjTaqfk;
	spf=none (imf28.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775667670; a=rsa-sha256;
	cv=none;
	b=tfvG/ocFcwj+whOVI5TPczP4dUNS72KdlpXwAM/vhfdohFSU10WMsdnUv2fIxBgMGAyD0R
	7HMzrz7cKZIi87/pNBbpdu0dHOdUyltBnubZraaJ4CW7FTbtYntebB/49AHCfKiXG4vkAr
	vFmsDuIWE7IT0cpPPqbcX3SiQi0OBZY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=fWlcN0d2sqnEz/Q4L3iF8sYk4gtZDkaL7FX/NnHp/cg=; b=ikjTaqfkDuOZYFxSWfbAxa48aT
	gydnE7Ecs8QhVeEDKO0LHEKuIy97O3gA5L91knIiLs6Gfnn2rorBY2WBC1Gwdpy1ql7tcZ/nHGkU1
	rzlPCzrz1MMlXb5bPHiHjkR/3RwgxQ3pGyKJn0D7SKW/hV351hp3WJDl2GeZ/s45HRuIpufu9HSUh
	LXZpn99OiD+WtQCLZtL+Q+k2uwsJKZEptZGOFk2K0MurqwvP/4JtuJxBx9VRQulA1fiy+Pkjl9QsZ
	BjSoWkBBme+Sv7ohA67A7m75kuHcV5cq4q7z2BCGDFqkc9QWl9iyzXtq9qV8zrFs5yIB+fqPUtSOQ
	/VojlE2g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAWGx-008ZGd-2R;
	Wed, 08 Apr 2026 17:01:00 +0000
Date: Wed, 8 Apr 2026 10:00:53 -0700
From: Breno Leitao <leitao@debian.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kas@kernel.org, shakeel.butt@linux.dev, usama.arif@linux.dev, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <adaGcf2hKNGHwVPd@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
 <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
 <ac5urCFeEB9oyUiD@gmail.com>
 <adUhtrhU7c1TJQww@gmail.com>
 <a9129d39-f9dc-4f09-b951-203c8e28b600@kernel.org>
 <adZopu5wjXIR5HOR@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adZopu5wjXIR5HOR@gmail.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5772C0020
X-Stat-Signature: mbfgo94yc9j96uumhm76y5mxenb191mu
X-Rspam-User: 
X-HE-Tag: 1775667669-48258
X-HE-Meta: U2FsdGVkX1/VWxt2aTELA6o41mMYUWW5nX0cYFus0JrGvZ5OBUqYDITK9oKmHabpseJnDtb8+QBn81IPP4PEBOA4Yrk5e8k1usAEYrym9GVdDjLHmTd+qtGkF6OLM8cN0FpfMn0xF8MG+jzjVrQmiD7eLdawR38vtKkpO9e/Fq4C52ZJ/D3mOH0YngR5k5VzyawI84nI+7R/ywoGIP21Dyg60nkIkwOAhOs0QHpl2c1PH7MGvwC7+oxPDoWrZXvDjGz8nbhh+lLmCUhGgcDsjFFNtB0rnYNt8bCh9bwO8KAQxDLskvzu0FmugnkOhjthIkxAvGVIqz91X6gBMi2dNY0tXUeydjSOMlffrTZ84uEmbCF49+2n3PgS0SlBXA7Skvp8SyRL3pkHkrFZGk2VOosizWpR2wESunk/9kKW5VvTj1tX4m9OBOak2ibXwTo0XaAj6005ySHlhyLfctnhP0j/Az+zxXGuWxLH4wFGJi+AmLVAPwVHVhHvAWbSTFh9lpYH7cz/xUMCqaO03yJCb5zUTnkXLvEumTbAlOYed6QGEBGv+2Izyjp5vZ49z8Ko7NjPX2kGBbj/Kt8TnVj4ydIWtmJaN/8c4v9IiGzl271GhCqI0+fKaT47EAN3ZpYNvHEae865f16LqhVo9mz6713jPnOs8zgmg9oEYyPxrTCKKgDqsPyo0zoPPfzdschvKKXjJZhB1sKsB3hFvNeVGLR7KxPEreiWW9lmkCk3I0Uwt0o2gfksZKavm7DFuz8PciUPFGW1yds3mM8hO6ru0gqMBauCsoEOfWd5MEitjEke/flwlE/EU5By2ZL2GUiD8o+A+Fuz8q9sqlRCxG5ggl2ZDqpRFOWLBC36qxlgNTlH1qcluQ3Ue53LvJsXvCX2q0th0ZvWBi7+5g4b66uZ6dPSN/ruszGvxrgAWc5zFITvfEQL9ox8TxoyZlMfdkrRAhD1zdx/RuBelFh4ZZh
 CAeCzB/W
 rMnGbXFSrIrPLsLDCGwMm6G+sPtlaeYTG78KBqrpXXQx0XS6kmu/7nAcrzLzva3bqcqXHYbDtM4/Q9EuZVGbnZDkk/FXlBfG5HWqzNODK3FyhRWMmyGXy8Bj+hocQHnFsc4n9brg+ViUT+1N2vvr+9qsvXfkoyiojkWKKhgx0ZZUCgN7e+f6ta47HH8fIAHBbkj7SGeI2GoH94F8FpgzursPgW1ebLw+LxtSQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 08:13:43AM -0700, Breno Leitao wrote:
> On Wed, Apr 08, 2026 at 12:13:04PM +0200, Vlastimil Babka (SUSE) wrote:
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd6..8d53242e7aa66 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2139,8 +2139,12 @@ static void vmstat_shepherd(struct work_struct *w)
>                         if (cpu_is_isolated(cpu))
>                                 continue;
>
> -                       if (!delayed_work_pending(dw) && need_update(cpu))
> +                       if (!delayed_work_pending(dw) && need_update(cpu)) {
> +                               WARN_ONCE(work_busy(&dw->work) & WORK_BUSY_RUNNING,
> +                                         "cpu%d: vmstat_update already running, scheduling again\n",
> +                                         cpu);
>                                 queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> +                       }
>                 }
>
>                 cond_resched();
>
> The fix is a one-line change: !delayed_work_pending(dw) → !work_busy(&dw->work)

In my testing, this race condition occurs more frequently than expected,
likely due to the timer configurations we've been discussing throughout
this thread.

I developed a diagnostic patch to monitor vmstat_update worker scheduling
frequency, and the results show consistently low values. Avoiding
rescheduling a worker that is already also reduces the contention on
stress-ng test case.

commit d725f0664b70aa5c677215b0fc1abc0117aaf114
Author: Breno Leitao <leitao@debian.org>
Date:   Wed Apr 8 09:01:02 2026 -0700

    mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update
    
    vmstat_shepherd uses delayed_work_pending() to check whether
    vmstat_update is already scheduled for a given CPU before queuing it.
    However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
    which is cleared the moment a worker thread picks up the work to
    execute it.
    
    This means that while vmstat_update is actively running on a CPU,
    delayed_work_pending() returns false. If need_update() also returns
    true at that point (per-cpu counters not yet zeroed mid-flush), the
    shepherd queues a second invocation with delay=0, causing vmstat_update
    to run again immediately after finishing.
    
    On a 72-CPU system this race is readily observable: before the fix,
    many CPUs show invocation gaps well below 500 jiffies (the minimum
    round_jiffies_relative() can produce), with the most extreme cases
    reaching 0 jiffies—vmstat_update called twice within the same jiffy.
    
    Fix this by replacing delayed_work_pending() with work_busy(), which
    returns non-zero for both WORK_BUSY_PENDING (timer armed or work
    queued) and WORK_BUSY_RUNNING (work currently executing). The shepherd
    now correctly skips a CPU in all busy states.
    
    After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.
    The remaining early invocations have gaps in the 700–999 jiffie range,
    attributable to round_jiffies_relative() aligning to a nearer
    jiffie-second boundary rather than to this race.
    
    Each spurious vmstat_update invocation has a measurable side effect:
    refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which
    drains idle per-CPU pages back to the buddy allocator via
    free_pcppages_bulk(), taking the zone spinlock each time. Eliminating
    the double-scheduling therefore reduces zone lock contention directly.
    On a 72-CPU stress-ng workload measured with perf lock contention:
    
      free_pcppages_bulk contention count:  ~55% reduction
      free_pcppages_bulk total wait time:   ~57% reduction
      free_pcppages_bulk max wait time:     ~47% reduction
    
    Note: work_busy() is inherently racy—between the check and the
    subsequent queue_delayed_work_on() call, vmstat_update can finish
    execution, leaving the work neither pending nor running. In that
    narrow window the shepherd can still queue a second invocation.
    After the fix, this residual race is rare and produces only occasional
    small gaps, a significant improvement over the systematic
    double-scheduling seen with delayed_work_pending().
    
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/mm/vmstat.c b/mm/vmstat.c
index d59eff1582547..5489549241b51 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2156,7 +2156,7 @@ static void vmstat_shepherd(struct work_struct *w)
 			if (cpu_is_isolated(cpu))
 				continue;
 
-			if (!delayed_work_pending(dw) && need_update(cpu))
+			if (!work_busy(&dw->work) && need_update(cpu))
 				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
 		}
 

