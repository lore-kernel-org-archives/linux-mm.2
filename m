Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA350C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E7F6B009B; Mon,  7 Sep 2026 04:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6AFA6B009D; Mon,  7 Sep 2026 04:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FE86B009E; Mon,  7 Sep 2026 04:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85E756B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22CECC0694
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:24 +0000 (UTC)
X-FDA: 85186284288.27.172591E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6D1384000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ICur1IhM;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769582;
	b=m+H7IOm4b483enXQrqgIKTEA8IIziM9luO/arUqq6ByOSg/1IQcWi+2NnGrxkgGoU+/6Pc
	m2j9v8ABl2lva7L3hMfr5+kx3qRxUvcJUeweBODve5xjCOXX1NMR4q3TUsippTxOn97oIL
	z96lxL0e1KC8ynY/wY56/V2EHwxwUC8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ICur1IhM;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aO6wg0mymQg3x/3sbOQTgRafHt9X06kvzyNxg3k6Uj4=;
	b=3WJSkOjnJHZlVjdUO/bCG1tCcfjBU5R9ItzTE5vAAVRSgd1vAeQ6VqBekzH6wU/T470b2E
	2DBa4+RWgoGAD5HDaiCnvBCXG5GJi57CLWUHdVOZ3w7DXM/HTgkqL93HNdGeG3LXKOsXbB
	OZuiPfTown3WLVUEBrkkZkf4AaeLsJY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A6EC60D8B;
	Mon,  7 Sep 2026 08:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1701F00A3D;
	Mon,  7 Sep 2026 08:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788769580;
	bh=aO6wg0mymQg3x/3sbOQTgRafHt9X06kvzyNxg3k6Uj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ICur1IhMUSpSE6fcJQklY1JjVK0yR4xNQ89iJLicxz+OgQqZ/38m/VMenPeE9Fgjh
	 3zZp4CFJQSZEmg7Cbb3c8Gmr4KKJmPxbjlJ6S91dcleSo3lhxvHVr2q/52m4SVe1hN
	 V0YoGoCpoceNgZJ2iM4e1quy1vUZ3U9jOJIeZ7ws+u8AoiCy33KtG7j7l7erQjRCGh
	 XK/Y37JnMPpsax/4NRvrf6fB7S0+P8MMYA913T2RiBV2xDxmXPXAT24GsFvLbVTay+
	 XQn4yY4wu+PpYTh+CR6uz+68WNVDgYiBNWJ9aW3Mw0l0R7jcdt6C+0lvjItoYHKsB2
	 CXBW4FIWwsdSw==
Date: Mon, 7 Sep 2026 09:26:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Peter Zijlstra <peterz@infradead.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, Oleg Nesterov <oleg@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ye Liu <liuye@kylinos.cn>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack3000@gmail.com>, 
	SJ Park <sj@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, rientjes@google.com, 
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, 
	boqun@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org, 
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com
Subject: Re: [PATCH v2 0/8] sched: introduce for_each_process_rculock and
 for_each_thread_rculock
Message-ID: <ap5yw-Cwb41FymNd@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D1384000C
X-Stat-Signature: pqfef6pg13n4tj8cc6qogbtg7ide3gm4
X-HE-Tag: 1788769582-532598
X-HE-Meta: U2FsdGVkX19LJhhxa5Ln+ciBl/RzY/WMlD7zysdkaF/UGDmNddjxqipTwsqHWo3bO88e2HfmMD7pyZc/ZTU+e8hytw84nq6V2bQReoH8T09hUJm5QeYOtV2DlcmtE0o7PM4php6pWqdnm6u5vAzkoY2b+oCPukeVw6bvJf5mJWveBLjfG9AI6yD7KgaIbtXkp5LdF07ssr8diPAF5PpiiLdN3v7Dt64qkJoSoF99HWeczGY/qDtKl1l+zdhkBYYlZ+MdiFqcpm5Micdt6vlFekBZZMZv4Jg++OabDnA5EFVOIrGf2TAi/62ANcGnBDumz/73pIAxR0YVTqTXN7ooX9jS4oexiRvo0FXgf15c0Wwe6Mayjf1ZjIY1Azuqjdau1mJm1dveg0uc4gZSG80J15R3Uss+ta4Is/3mjLV9n/2gX5mq1lXaIGxnWvoO2NcuwHmuUlUVHCMW+he5ysEs0qEDUaTRMO2mAVFPvntR5n87T4z+/qE1sXACqkXkNhVVOgUTS7khQlBHSxaLolyx8EmnrE0fOEaBQeMbiPya+NZVQ1uFLdBJao1x1NUdjSpnNRj4WmKGoDtNR3/jAJclPjT8uWK09nqgXT9PracrapqDor226b/mF5irQKXHFxYE29ETLCrK5HgVqdVRyz/4D1r94CK7aQQUrH2l0FYAruV6pY4XjF3IwgChgirHAgZ01TI6ctyUZrNfWJElN15n+dygEm/IcvfsP3+Fl+5GEkcPzFCmMi8QrO1yGRfgYeseU2w/hZDvS0gJdxMhbWnpg0egBfVat/lIE8Gwe0jt5ATOosYFuVGldvwGi0ZMvTw5qd00lGiLiyRIHrKt/lmix5q179FzwWji2yFPRALoMMdvyNt0Av3C+FfvMl1ZcETWVqMtprDKLYr6TjoCETJA7uUbd+1nPJRCHLwJMyuSzf8xOW7DsVTgLO5sRlxqgiDQk7x/xUYToodLlf7ASZA
 NHcdv6tx
 wUSkwladI5jVVhf1sPWVy1zU4NZlxpanbJFNpx4SMqNKvXcI1ChT7WrMDjEhOzwX+Wf0xuMy+8g7QpIJL/PE4HQSEHyvR0n8EngE2j0np1cu3QyYqpgcokzxIWgx0UUQGhwd4a0s09mEfvKAkHA/NSDghjR5CVylOOyIiV6lZoKTSTxsOvM6nqt9oLk9oAkCbPsBhoprMYSPZ7fh3+OnJddr8h07gEQVZK/mewurQcZri4X0pvUnN/5mWvmf01VdTO7VTFIbLv6lmVXavp4P0k+owwmn/hLikqqawhFqvPE3/qhlyuV/oS7RF6caStZR8y8KOJeVmWUpSyMTM4jZiZ1yUDEVZlDaEABmk3L7f0zNu1Rm3CKMHX1WHIWi89lA/gWXoqDurwgHc88qh/bXfvKnWmg5DdtvyQ4o3Zyi0d7Zkwas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:26PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Introduce for_each_process_rculock(), for_each_thread_rculock() and
> for_each_process_thread_rculock() macros that combine the existing
> iteration macros with scoped_guard(rcu), so that the RCU read lock
> is automatically acquired before iteration and released when the
> loop exits — including via break, goto, or return.
>
> The rest of the series converts manual rcu_read_lock()/
> rcu_read_unlock() and guard(rcu)() pairs across mm/, kernel/, fs/,
> lib/ and security/ to use the new macros.
>

Andrew - just a note (assuming Ye Liu is in agreement) I think all of the
below should be excluded from the cover letter that goes into the commit
message, including the checkpatch thing.

> Changes since v1 [1]:
>   - Rename macros from *_rcu to *_rculock, as suggested by Steven
>     Rostedt and acked by Thomas Gleixner, to avoid confusion with
>     existing *_rcu() list iterators that expect the caller to hold
>     the RCU read lock.
>   - Improve the comment on for_each_process_thread_rculock() to
>     document that 'break' only exits the inner loop and 'goto' is
>     needed to exit both loops (Thomas Gleixner).
>   - Rename the stale 'unlock:' label to 'out:' in hung_task.c, as
>     noted by Günther Noack.
>   - Clarify in patch 4 that page_pgoff() is safe outside the RCU
>     read-side critical section (SJ Park).
>   - CC all relevant maintainers on every patch (Lorenzo Stoakes).
>   - Drop the mm: prefix from patch 1, as the macros are in
>     include/linux/sched/signal.h (Michal Hocko).
>
> Patch 1 may trigger checkpatch "Macros with complex values should be
> enclosed in parentheses" errors.  These are false positives — the
> scoped_guard() pattern is a control-flow construct, not a multi-
> statement macro, and the same idiom is used elsewhere in the kernel.

While it's useful as a note to reviewers, in general checkpatch is taken
with a pinch of salt - it's a master of false positives so usually no need
to say this :)

>
> Suggested by Michal Hocko for the oom_kill path [2].
>
> [1] https://lore.kernel.org/all/20260904083001.553587-1-ye.liu@linux.dev/
> [2] https://lore.kernel.org/all/20260813092933.562028-1-ye.liu@linux.dev/
>
> Ye Liu (8):
>   sched: introduce for_each_process_rculock and for_each_thread_rculock
>   mm/oom_kill: convert process/thread iterators to for_each_*_rculock
>   mm/ksm: convert process iterator to for_each_process_rculock
>   mm/memory-failure: convert process iterator to for_each_process_rculock
>   kernel: convert process/thread iterators to for_each_*_rculock
>   fs: convert process/thread iterators to for_each_*_rculock
>   lib: convert process iterator to for_each_process_rculock
>   security/landlock: convert thread iterator to for_each_thread_rculock
>
>  fs/proc/base.c               |  4 +---
>  fs/resctrl/rdtgroup.c        |  8 ++------
>  include/linux/sched/signal.h | 25 +++++++++++++++++++++++++
>  kernel/cpu.c                 |  4 +---
>  kernel/freezer.c             |  4 +---
>  kernel/hung_task.c           | 11 ++++-------
>  kernel/locking/lockdep.c     |  4 +---
>  kernel/rcu/update.c          |  4 +---
>  kernel/sched/core.c          |  3 +--
>  kernel/sched/debug.c         |  4 +---
>  kernel/trace/fgraph.c        |  8 ++------
>  kernel/unwind/deferred.c     |  3 +--
>  lib/is_single_threaded.c     |  5 +----
>  mm/ksm.c                     |  4 +---
>  mm/memory-failure.c          | 16 ++++------------
>  mm/oom_kill.c                | 20 +++++---------------
>  security/landlock/tsync.c    |  8 ++------
>  17 files changed, 54 insertions(+), 81 deletions(-)
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>
> --
> 2.25.1

--
Cheers, Lorenzo

