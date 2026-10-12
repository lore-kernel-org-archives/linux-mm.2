Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AB2CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65AF16B008C; Mon, 12 Oct 2026 04:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B646B0092; Mon, 12 Oct 2026 04:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA216B0095; Mon, 12 Oct 2026 04:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8DC6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:22:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94F8EA09E8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:22:56 +0000 (UTC)
X-FDA: 85313283552.08.670847A
Received: from mta1.migadu.com (out-57.mta1.migadu.com [95.215.58.57])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4468D14000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:22:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QSToD6HK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793374;
	b=JLq7q37sInTtcr9e8R4Lh0hzkZUWNZc+RrCxfkDHCXm1QxPHXGXrW58WaQIK9Y5DFScfwp
	E7xCVm+VBV7cNW0sQxwXq+A2DVK9UsAoWwUnJB/TZ9mzW0VL9nt8XBDt67aRISKdkEJytT
	4+wI18JFqWrEL/XT5D9SqtiLvkXv40U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QSToD6HK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uH4oGR3Zob5tLzhwnmpq1irK2KTESVDNUNhVdPzhSTE=;
	b=eNMg95xejwzF34ptWDdUk74Yb6TMkHD3RSyaoFDWR26njCYmczeY+92OM9Svzw5eGF7Zv7
	Q8UFyZudr43C6oW61fbQ884UgUX3gO2kBMfdKlIrzwNmx/A4odFsNBUOc8NdpNAsWr4IuW
	LcfXndreMxToHDaoYfhKRAyj7vPstE4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2PZG4oBTWctUcn47EeBywXvnSBFOGvbeX9RPvQyatEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791793369; v=1; x=1792398169;
 b=QSToD6HKA3NCTTwZ9qSyY1JuKFbS0Xrl1KSPgDfdybTEtL7svlFfizgNRi9bMYJJLdz5uwFv
 zKTE2Dvew1+JQFHrwTsHUx0F3rjJWiYORX0GtB/xFsO2qn2bkdk5bC35+4p29ZKjSLxjdZ5944z
 h0H1HJxt7RGDEKK2SUs+X/oY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 85626153b49a7cd1;
	Mon, 12 Oct 2026 08:22:49 +0000
X-Mizu-Trace-ID: 85626153b49a7cd1
X-Migadu-Flow: FLOW_OUT
Message-ID: <7842535e-ae71-4de3-b16d-14d55b514df5@linux.dev>
Date: Mon, 12 Oct 2026 16:22:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/15] sched: introduce for_each_process_rculock and
 for_each_thread_rculock
To: Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ye Liu <liuye@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, =?UTF-8?Q?G=C3=BCnther_Noack?=
 <gnoack3000@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 SJ Park <sj@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com,
 x86@kernel.org, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org,
 pmladek@suse.com, longman@redhat.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, dietmar.eggemann@arm.com,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com,
 james.morse@arm.com, babu.moger@amd.com
References: <20260921092101.89285-1-ye.liu@linux.dev>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tdxhw18uakqffr4wg3sny6n6rfixkr5o
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4468D14000D
X-HE-Tag: 1791793374-162096
X-HE-Meta: U2FsdGVkX18fafwO7h2FQ/1nf+ukNoWfo5Ub+gG3mgtbV9ld+0o8pltQHOz0reRC97QdDO1yU2yoF2ricLivs05vakpaK66MZaqJH09SsGqHzUDbdUgoHn4xDCs+pfNNJ/PXXE2wSNxl1avZhsFHZiQf8t7I7LUdsyzKuYy9syRzSwztfCkbvttqEgxza6cddZ6ExhdH13GuscuY9vyjbeOSaY60nFkNgIwWjQaaD5u7t9CnA2GUY62+c+kXMKA+KKIWguJr8WLr9pkiU6qK4KnUiB5pp+4WvwoGSKrKHcImTcbh47qKalMfgb7JklMcc0eU02AFpFxUWAptWQPwYszI2IRVgSE8/kjcelDUeMdJhapWltlGiroTRE8/tlvjxHu3SNg5fMYeYMoXwYvw4nclt8P7rZdlHY8NS9Rfu/uWjauYTymROcFpYIfcBhG7TNqijFLpUBn+cIgmzn8XjdvrZ8JiYSDF1WO0AMUcDTwY4lQ9AG4p2lJUmMUjNwr6I3ENGtiIoaC+gOKJ6aDEsg/YbxbCTxrFNgvjwuifvnILKj78JuvdQLGmMoBANtjPjtiz0iB43Xp+XMz2rxHXn1jdYXk9hERGoxZd9PZxLCTO4ZkXBWpYQ9vm5lvv3VfswPM2xGTLrToAYhcVr/H1BdYWKdNsa9bdTF1cvyp70gMaHsPLmg5Yo6l79gynmqIDqcmA/12fuvdZ6IYJElb+n5+L8n5tIzYmMjnBQiXdTXITrEXYjJxwyTsKCMvBjJMIu/AUEtBj+cUsIFKznnK9v+YWpzimgdZYePW1Jbkg2aO4D6qj890VSEbm8bECY3yB04f+Q6FwdtDa1wny/9y0ujGUCBANn0gy/RxiVXDq51C99PvjPvKlZ7qjLr26HRTp01dXQMoXJvXMtvnHfyEIB02iEZcqqDbdL94i9ZNaZ5NBrOHVfFiB4Iqj7AjhRe6t+NIQGytrFaj3G6t+LDa
 nZdRzfLr
 UEwJsuqS6AF6eFgWPRdnu9U4IBPeN/aXlmfIdR6rRDKu48daNNS80bKr27T9nLm6c6rXgllmvHCMNgViHrW27x0y57UKhrZt6gNAEQEMhhsyQk/ROngDDcr9bUUa87Ls+f8o4ISZOLysWh0Vr6O9N0QgvQNOrUDEp+CnxtyDkyU4Om2mDMi7tfVoFbVhC7ndwiGDKKPawfjlPnzktc0VDnZsieHy+dG9JuYTeWJu7xde1KVpu8yBkNkJpgEMjG+MF/DoP5ppItK+Yb5Dn135hmodoHpDY2547miDOvOH/XAqfMp3CpAYEf27EmWudJQ2FBWXVAOZeHQqd58yE5akKeVNwysziqzj80N65Q6GzoU4igEvP/srnSWE5iadeKA2fFrlNac7VN7YUqaPE2dVmYB6I1zSV+srGftm5wn+VDX9RO7KViuchGZXHtdeFQQN7rcxK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Peter

Friendly ping on this series, posted three weeks ago. You previously
requested splitting the combined kernel/ conversion into per-subsystem
patches, which has been done in v4.
No rush — just want to make sure this is on your radar.

Thanks,
Ye Liu

在 2026/9/21 17:20, Ye Liu 写道:
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
> Suggested by Michal Hocko for the oom_kill path [2].
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>
> ---
> Changes since v3 [4]:
>   - Fix patch 5 (cpu/hotplug): title and commit message incorrectly
>     said "thread iterator" and "for_each_thread_rculock" while the
>     code converts for_each_process() to for_each_process_rculock().
>
> Note: Patches 4, 11, and 13 received automated reviews from sashiko-bot
> in the v3 thread [4] that were verified as false positives:
>
>   - Patch 4: claimed the folio lock is dropped before collect_procs(),
>     leading to a NULL deref on folio->mapping; the lock is held in all
>     call paths.
>   - Patch 11: claimed mixing goto/scope-based cleanup in
>     alloc_retstack_tasklist(); the goto free label handles memory
>     cleanup, not lock management.
>   - Patch 13: claimed mixing goto/scope-based cleanup in
>     __set_oom_adj(); goto err_unlock manages oom_adj_mutex while
>     scoped_guard(rcu) manages the RCU read lock — different resources.
>
> Changes since v2 [3]:
>   - Split the kernel/ patch into per-subsystem patches, as the
>     combined patch could not be applied (Peter Zijlstra, Steven
>     Rostedt).
>   - Move changelog below the --- separator so it is excluded from
>     the commit message (Lorenzo Stoakes).
>   - Indent loop body in macro definitions to show scoped_guard
>     scope (Lorenzo Stoakes).
>
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
> [1] https://lore.kernel.org/all/20260904083001.553587-1-ye.liu@linux.dev/
> [2] https://lore.kernel.org/all/20260813092933.562028-1-ye.liu@linux.dev/
> [3] https://lore.kernel.org/all/20260907081334.1152889-1-ye.liu@linux.dev/
> [4] https://lore.kernel.org/all/20260911075800.491472-1-ye.liu@linux.dev/
>
> Ye Liu (15):
>   sched: introduce for_each_process_rculock and for_each_thread_rculock
>   mm/oom_kill: convert process/thread iterators to for_each_*_rculock
>   mm/ksm: convert process iterator to for_each_process_rculock
>   mm/memory-failure: convert process iterator to
>     for_each_process_rculock
>   cpu/hotplug: convert process iterator to for_each_process_rculock
>   freezer: convert thread iterator to for_each_thread_rculock
>   hung_task: convert process/thread iterators to for_each_*_rculock
>   locking/lockdep: convert process/thread iterators to
>     for_each_*_rculock
>   rcu: convert process/thread iterator to
>     for_each_process_thread_rculock
>   sched: convert process/thread iterators to for_each_*_rculock
>   tracing/fgraph: convert process/thread iterator to
>     for_each_process_thread_rculock
>   unwind: convert process/thread iterator to
>     for_each_process_thread_rculock
>   fs: convert process/thread iterators to for_each_*_rculock
>   lib: convert process iterator to for_each_process_rculock
>   security/landlock: convert thread iterator to for_each_thread_rculock
>
>  fs/proc/base.c               |  4 +---
>  fs/resctrl/rdtgroup.c        |  8 ++------
>  include/linux/sched/signal.h | 26 ++++++++++++++++++++++++++
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
>  17 files changed, 55 insertions(+), 81 deletions(-)
>
> --
> 2.25.1

-- 
Thanks,
Ye Liu


