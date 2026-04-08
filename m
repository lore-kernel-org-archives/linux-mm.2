Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E07D10F994F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3826B0005; Wed,  8 Apr 2026 11:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB776B0089; Wed,  8 Apr 2026 11:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E81C6B008A; Wed,  8 Apr 2026 11:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBA46B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:14:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8F655647E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:14:03 +0000 (UTC)
X-FDA: 84635733966.07.70AB8BA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id A1A2540015
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:14:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=q1pg2Ckv
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775661242; a=rsa-sha256;
	cv=none;
	b=cuC8aMA1+QKZQ0Rf11dEsMjLRAypN4F+uwk56hmeQYFPYqSo1546gu28bo6pUbGb3YysdH
	693TV1fIgx4AdmfYygQzFVaaNE97TiJC+i2NR82kzC/l0wr6FvWOVRXNW/vqMfI2hHx5ma
	k7D39j9uUlkhbefzqONCWduZyudRt30=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=q1pg2Ckv;
	dmarc=none;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775661242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qFmuP/MnKK1BHIb03/wMrebmLz+b5nfHur0r4Fia6A=;
	b=wiNU6ceEzN+R+QF1z/NHRCpo2ZUnxaQgfjqJCHRYfWEaDD0twbVuzK962Iwy3py15mUiLe
	VydcSrue+1k1HNXqklXwAXb0Xw0RqaPIKz1oTrp+CbSqCVRyFa/LF3Iz2DdEny5YpYMSL9
	Hn9eFsdkeb7kXHeaXEbDNsxPQUaMDFo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=7qFmuP/MnKK1BHIb03/wMrebmLz+b5nfHur0r4Fia6A=; b=q1pg2CkvuUVpDz7OpwXLAlQsNe
	YOaQN8KYTe04O7+Ge8xDiSjUw2cHQdic8sSmgVly2h+sywnL95YbHfEIDl6lFBeyTMBUF6N1lHK8j
	QnHpB4/TAq2Kw8rHr/d7gd4r1OHSAYSfUIZ4tLExqDIldJpYbBEw9VUwAgmkkrIngHk6YRDBc+bZm
	0DctdYt88yBtmNq7ua8m7fEnf28Jyn7Ool1PxbIT0qITqlm0geQ0M0QjOYPv1HS/P4WC7AsJcR9Qk
	khHnLebIEUV3Zj+8Ch2mi3oWrZu5zvMH+upTPxmZmwneAaFX4p5EDha+N6Z3HaMIPqATd7nEVPmio
	6J3Z6Uag==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAUbG-008VWe-0T;
	Wed, 08 Apr 2026 15:13:50 +0000
Date: Wed, 8 Apr 2026 08:13:43 -0700
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
Message-ID: <adZopu5wjXIR5HOR@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
 <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
 <ac5urCFeEB9oyUiD@gmail.com>
 <adUhtrhU7c1TJQww@gmail.com>
 <a9129d39-f9dc-4f09-b951-203c8e28b600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9129d39-f9dc-4f09-b951-203c8e28b600@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: gamfms4o9om3s3ay8x5gsnozhzer6msu
X-Rspamd-Queue-Id: A1A2540015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775661241-367509
X-HE-Meta: U2FsdGVkX18HCqt5t8tQ36FAbkKSY3TMfA5A/VP8xIcbkH0HKlTTqEML9iImPNzE/hShO5v6oXs15g99uHILA4OWlJ2ZAq5tviUCjXGJtriS+JcYh51uGlwRM0ay5c1VUPP0mvFV0QWR1akENtX+e7XQZUojUmBuKoG6wciRYRgxisNxWJge8QUrp+z/c/IjHj82YLdh83PqEzEJb1e+v+xjJwEzb5Fxiw3BwvRGsBv24z4SHKGfdU6+kj5brOHKKTeVqksan2Yjnap2eM0uVqIOGQOTDmcSbIPGWjnFcryjsNjJzE1lFUUrUFfb49w30rmUDstEz3XYgf2vfrtxzFC83m4nsI/RNNzP5xPTteo/T0/G8o9+QCQXiIf3xyOg/WIOf2AQbE9FxSzzc3ZrTYatj2tGmyCTK1R3ayJJrQIE9gjR2GTHeFoIOnGkx3YN7Hgss/AVCmL6c8H9ApN/m9D7IORe7DyDiTCvGP58NpdLjqCVuw8fIG7w/Z/cRscbmmPxWxi2rszWTQZE9nItWF22AqcBYgrzxNPeX0Tn6NiT+MkPwnNykZwUFP698skMVicThdB0uJ1glLGExDOhaMWKZPsqPGfy4mGOoavJspqpQZ6SJxSZUMd+tMQykKNppFKI+NO7zlV2U6tcUcea7xkb5sHT10UONRe8zJ7rbDgkt6ODta+/7t1v0DxtZCudxFO3fP5fPCA60+2gg6Aubh+UdNFZzrBD/SretilFe/MLnBQgx7URMzr2/NgMZ78+ZOLhwTA6a69qmgCdn+sEKInyalELC8WdARZJEVJtMUqUK4rELB/ewQAKZz/PKh5BoRY1Oxe7jBih178qwjEARx5/WO/sp2RNtLW0ZlqgYN5Ufp1xX9gO5bYFhYyxNcEOBvEIiogKI7FAquTeD2bhimQaw+Fo0UgXvCNvoi/OvLULDSJRmUo+5Tkv1PRfG3NqkKr6izupFi2JVfEVOjW
 +7jrJWYt
 g6iFDOtWeHzDCa9ggW2dKZbEY+Z4uvNwEcIl3p1PPCrLRXPp5XQg9hqM0wf1+sCQ1hLy3Wvumd5gLLRKT1wpKGqREaVAtV6wFKX44vGugI0j8woeyeIReOlBX2SoF42Y6g/m6xi8988L+J7LVf4PIsTViKrfpkuGlv/ciSVkGSJr1PDRDPS8tqXU2OmBfuKovF/rMOuNqkhjEi/5VlNQz8/qqGRoXvKceHUdXib2dYkif97TRtRjYH+5N2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 12:13:04PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/7/26 17:39, Breno Leitao wrote:
> > On Thu, Apr 02, 2026 at 06:33:17AM -0700, Breno Leitao wrote:
> >> 1) The interval duration now varies per CPU. Specifically, vmstat_update()
> >>    is scheduled at sysctl_stat_interval*2 for the highest CPU with my
> >>    proposed change, rather than a uniform sysctl_stat_interval across
> >>    all CPUs. (as you raised in the first email)
> > However, we certainly don't want scenario (1) where the delay varies per
> > CPU, resulting in the last CPU having vmstat_update() scheduled every
> > 2 seconds instead of 1 second.
>
> Indeed.
>
....
>
> So you have 72 cpus, the vmstat interval is 1s, and what's the CONFIG_HZ?

Yes, CONFIG_HZ=1000 in my configuration.

> If it's 1000, it means 13 jiffies per cpu. Would changing the
> round_jiffies_common() implementation to add 13 jiffies per cpu instead of 3
> have the same effect?

That approach would increase the spread in round_jiffies_common(), but
it brings us back to scenario 1 - each CPU would have a variable
rescheduling delay, which defeats the purpose of maintaining consistent
timing.

>
> Link: https://github.com/leitao/linux/commit/ac200164df1bda45ee8504cc3db5bff5b696245e [1]
> Link: https://github.com/leitao/linux/commit/baa2ea6ea4c4c2b1df689de6db0a2a6f119e51be [2]
>
>
> commit 41b7aaa1a51f07fc1f0db0614d140fbca78463d3
> Author: Breno Leitao <leitao@debian.org>
> Date:   Tue Apr 7 07:56:35 2026 -0700
>
>     mm/vmstat: spread per-cpu vmstat work to reduce zone->lock contention
>
>     vmstat_shepherd() queues all per-cpu vmstat_update work with zero delay,
>     and vmstat_update() re-queues itself with round_jiffies_relative(), which
>     clusters timers near the same second boundary due to the small per-CPU
>     spread in round_jiffies_common(). On many-CPU systems this causes
>     thundering-herd contention on zone->lock when multiple CPUs
>     simultaneously call refresh_cpu_vm_stats() -> decay_pcp_high() ->
>     free_pcppages_bulk().
>
>     Introduce vmstat_spread_delay() to assign each CPU a unique offset
>     distributed evenly across sysctl_stat_interval. The shepherd uses this
>     when initially queuing per-cpu work, and vmstat_update re-queues with a
>     plain sysctl_stat_interval to preserve the spread (round_jiffies_relative
>     would snap CPUs back to the same boundary).
>
>     Signed-off-by: Breno Leitao <leitao@debian.org>
>
> I think this approach could have the following problems:
>
> - the initially spread delays can drift over time, there's nothing keeping
> them in sync
> - not using round_jiffies_relative() means firing at other times than other
> timers that are using the rounding, so this could be working against the
> power savings effects of rounding
> - it's a vmstat-specific workaround for some yet unclear underlying
> suboptimality that's likely not vmstat specific

I believe the issue is that vmstat's current use of round_jiffies_relative()
fundamentally solve a different problem than the one we trying to solve.
The round_jiffies_relative() mechanism is designed for a different
purpose, as documented:

 """
  By rounding these timers to whole seconds, all such timers will fire
  at the same time, rather than at various times spread out. The goal
  of this is to have the CPU wake up less, which saves power.
 """

Backing up a bit, let me summarize the problem:

1) vmstat_shepherd() starts all vmstat_update workers simultaneously
   (or nearly so)

2) All vmstat_update() workers then reschedule themselves for the next
   second with only 216ms of variance across 72 cores

Upon further reflection, issue (2) wouldn't exist if we simply avoided
starting all workqueues simultaneously in the first place.

That said, I created a hacky code to find how often the vmstat_update
is called, and it is not uncommon to see cases where vmstat_update is
called a few jiffies after it was called.

Debugging further, I found a race between vmstat_shepherd() trying to
schedule vmstat_update() even when it is already running, which happens
a lot, given they both run at the 

commit 86e27727b6cc9fbe8bf67818a065105fd30bc7e8 (HEAD -> b4/vmstat)
Author: Breno Leitao <leitao@debian.org>
Date:   Wed Apr 8 08:11:01 2026 -0700

    mm/vmstat: warn when shepherd schedules vmstat_update while it is running

    vmstat_shepherd checks delayed_work_pending() to decide whether to
    queue vmstat_update for a CPU. However, delayed_work_pending() only
    tests the WORK_STRUCT_PENDING_BIT, which is cleared as soon as a
    worker thread picks up the work for execution.

    This means that while vmstat_update is actively running on a CPU,
    delayed_work_pending() returns false, and the shepherd may queue
    another invocation if need_update() also returns true (which it can,
    since per-cpu counters are still being flushed mid-execution).

    Add a WARN_ONCE to make this race visible: fire a warning when the
    shepherd is about to queue vmstat_update for a CPU where it is
    currently executing, i.e., work_busy() reports WORK_BUSY_RUNNING
    but delayed_work_pending() does not prevent the re-queue.

    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2370c6fb1fcd6..8d53242e7aa66 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2139,8 +2139,12 @@ static void vmstat_shepherd(struct work_struct *w)
                        if (cpu_is_isolated(cpu))
                                continue;

-                       if (!delayed_work_pending(dw) && need_update(cpu))
+                       if (!delayed_work_pending(dw) && need_update(cpu)) {
+                               WARN_ONCE(work_busy(&dw->work) & WORK_BUSY_RUNNING,
+                                         "cpu%d: vmstat_update already running, scheduling again\n",
+                                         cpu);
                                queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+                       }
                }

                cond_resched();

The fix is a one-line change: !delayed_work_pending(dw) → !work_busy(&dw->work)

