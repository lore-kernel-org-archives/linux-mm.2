Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5753DEF071C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 07:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359196B0005; Mon,  9 Feb 2026 02:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307686B0088; Mon,  9 Feb 2026 02:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9156B0089; Mon,  9 Feb 2026 02:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF4E6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:35:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CCAABAAC5
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:35:28 +0000 (UTC)
X-FDA: 84424107936.23.84A6870
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0326B180012
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:35:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I9ZvPmnU;
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770622527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07wIgpCXfR6MNOgOcnr2yuUc+vuyJ/1xwxeyDL7AyDU=;
	b=F1hgKyTJ1/KHROt8jkOQWTi8KetEKhVEYZjp3rZOkdBlIabaZuLpRdowXcqAw3AJ/9QAWB
	BgWg71GYb5bJ0SxJyTR+USPlpMGqd0nId9u23iCxoeKM6aEjRh6V133h1F5HR71uQlNIcR
	0dQvDkFBbipyIscYr+BvTl1kI0l236g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I9ZvPmnU;
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770622527; a=rsa-sha256;
	cv=none;
	b=O8BQ6jPhfQl/TaZXXzBXm5vuvgOPaTXrB2MUVHPCDgQuoksjksRB/3rtsDKs5M/RIVUDa/
	cqcekjDgtpTf30XKmu6IPM08H8MHnbpWsLhXdmqnZFJH54GDUCU1D5/KYuw7j5hJDmjVCr
	p3CF1orWKXnvOX1lNjpHEsP5XoLjEnQ=
Message-ID: <e2752b6c-b690-44b5-bf58-806de5941c46@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770622521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07wIgpCXfR6MNOgOcnr2yuUc+vuyJ/1xwxeyDL7AyDU=;
	b=I9ZvPmnU3cz6hBU2XxAPJqsNw5Mps1HimyGw+E2fdS0mMkhYcbzFV+1DVEs/ThkbyCwpov
	5SVK6+cjmde/EGqJyiEXrTlqInGv/MlB66wQJyvr3MaVnz5aH0wCBTw46Wvoj45qG2Hj+g
	7/WNXEO3iZyr+DL7rJ/UVb3LbNvx5lg=
Date: Mon, 9 Feb 2026 15:34:08 +0800
MIME-Version: 1.0
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW0JVR10gcmN1IGRldGVjdGVkIHN0YWxsIGluIHNo?=
 =?UTF-8?Q?mem=5Ffile=5Fwrite=5Fiter?=
To: Zw Tang <shicenci@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "rcu@vger.kernel.org" <rcu@vger.kernel.org>
Cc: "hughd@google.com" <hughd@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>, "chrisl@kernel.org"
 <chrisl@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
 "paulmck@kernel.org" <paulmck@kernel.org>,
 "frederic@kernel.org" <frederic@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAPHJ_V+75SmoRQmoQmAT0GfdP-JotzwW801uPHZtHyynwdSOgw@mail.gmail.com>
 <e5ae996b-b5de-46cf-8c1a-532e4852a412@linux.dev>
 <PS1PPF7E1D7501F6FE46DF307FFB8086E2FAB66A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <CAPHJ_VL=PVuevdXQC+XTRv9c_JrRDFeCZ8+z7qFvXE9nxHcFeQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kunwu Chan <kunwu.chan@linux.dev>
In-Reply-To: <CAPHJ_VL=PVuevdXQC+XTRv9c_JrRDFeCZ8+z7qFvXE9nxHcFeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rk8y54r4qo6mqaefcgzemgk9jqpcfkr6
X-Rspamd-Queue-Id: 0326B180012
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770622524-51269
X-HE-Meta: U2FsdGVkX1+R/nTHg8Q5hJ9uj41CuYPdBJ1A0hD6e+HzCMHwPNBecB4c9PtRaZr1tbxX5DN9MKIijKN2RCDfCSSnXESjRp+jABDrrA2Zrm803JfXz4xIOLshSdOUAVfZDx64QQOnkaeqY770+o34eHx07a2Zg18z8FViYTdRwEOe+yLMpYdsfbojl8sYXtwHDvwSJ8HdeSxbYbhXlO3szMKOf58oCDDD5pcLhTJm143yqupQ3s9HS3+ofrcCyUgDlfpgq5fFL27ct/rgas0Gd+mqbhZaz9g7thA4u9+vsXFk6zOgvPWhZFEZbWx+rm05tJcrlMi6AxXp9KQeRYXKDU9jAShGRMM8wxJdbaQx1Bn2N62Aej6FPXIiID1ga3nSIhw+swy+GV/mBljOL72nQgpAZQWTC5PFdcMEcNpQ20/HY1V/m7n8hQoRqaRKLGBOUnkPPvjerU7XMNyo2VV2a7+Kz8qY4say3wKhUwSeBNt1A7HlvFEh2Dgq9LXp77T/OZrgq633vnG5GFFTLd/OEVjOrBR+M5zpslLbroveQT1RsTl3YQdo+kNEjFD/fJDQd7UUZPN0LN9deXnch1QOn7MM/1PAveTlgU+DkLvlDowbYxtvc4mFiaYjV2T3lhYo356llOK1DrtKBeSRSjCTFo1eAhLPIhWGKl8m2BpnmP+03L9zVI6w2j535P+5mBcFhghlTQTQP9ZgKb169qs9xK7mTgZby5kSg7cTcXi6iccK4PAggDw78ghK7PNEL7lizHI5IO9LhXMqm/dY68rQXMMBSjZ7E/kKGBp/ZclAtSL1+io5nzrEQQl3uSkMBuGTtvdvz62KT+rsW53XulTrdp/7w5VS6YFN5jrBloKJnU6h1J2xS64F88DYZ1D1qVrWfvwDdQEnK0CT6YoSioLevt8FDq6mmPaqzPTYiK0GCBj1jly08LD18KszbXJjL8DsWW4gMs6kOZIuU5Ho2Ct
 iYkbZdyK
 oztdtWjcH6b0hrttP9WiLAHJqAImNaINazMVSmJd3/82FRjBLJ8stYtioqda8O4v4N4MYzLb+OYlP5IfdLuAvC7O2hHIsWoab2z9hiAuB0pCcD9XjvV+zF650W0Tn2okym8AfBn1YevsE5ilYACkndmWnqsqU+UqhHDTISM1xfR50R4Q8/adTfm4D6TYIBmfodW0DSRid+5KkkFOFmjm/k3FVILnhGbM2jQ1FY8vSK7FKmEI3Wmeen4iOG9fn9i7QUlRK7R8DrFvHSAt+7OJrwscIlC7dF1JJJmobADUKiJLDEeUHeU+/n0ZPhtivAgYf0543alBhoZ/4FAU1f82Dis9kOp0D3Cm+VY0/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 20:16, Zw Tang wrote:
> Hi David, hi Kunwu,
> thanks a lot for the suggestions.
> I reran the reproducer with
> CONFIG_PROVE_LOCKING=y, CONFIG_LOCKDEP=y, CONFIG_DEBUG_LOCK_ALLOC=y enabled.
> Based on the lockdep-enabled run, here is what I can clarify:
>
> Lockdep does not report any lock inversion, recursive locking, or
> circular dependency.
> The samples showing __mod_zone_page_state() do not appear to indicate
> a blocking point; this frame indeed seems to be just where the task
> was sampled.
Thanks for the lockdep-enabled rerun. Agreed that
__mod_zone_page_state() is most likely just a sampling point.

> From the timeline of the reports, the earliest problematic behavior
> appears before the MM/LRU-heavy paths.
> In the first hung-task report, multiple repro1 threads are already blocked in:
>
> down_write()
>  └─ rwbase_write_lock()
>     └─ __rt_mutex_slowlock_locked()
>        └─ rt_mutex_schedule()
>
> via the do_vfs_ioctl() → perf_fasync() path, and are in D state for
> more than 143 seconds at that point.
> After several threads are stuck there, the system degrades further:
> other threads remain in R state, spending long, uninterrupted time in
> MM allocation / LRU paths
> (alloc_pages(), get_page_from_freelist(), __handle_mm_fault()),
> without hitting reschedule points.
> This then leads to RCU preempt stalls, and eventually workqueue lockups
> (e.g. vmstat_shepherd, do_cache_clean, wb_workfn).
> Lockdep’s “show all locks held” output does not show the blocked repro1
> threads holding any MM/LRU/zone locks themselves; they typically only hold
> the filesystem mutex at that point, which suggests the contended RT rwsem
> is held elsewhere.
> Overall, this currently looks less like a single blocking bug in
> __mod_zone_page_state(), and more like a PREEMPT_RT-specific
> starvation scenario,
> where long-held RT rwsems in the ioctl/perf path combined with long CPU-bound
> MM/LRU execution amplify into RCU starvation and workqueue lockups.
> Below is the earliest hung-task report from the lockdep-enabled run
> for reference:
>
>
> [386.499937] INFO: task repro1:2066 blocked for more than 143 seconds.
> [386.499956] Not tainted 6.19.0-rc7 #4
> [386.499964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [386.499970] task:repro1 state:D stack:28400 pid:2066 tgid:2066 ppid:293 2
The earliest hung tasks are blocked in perf_fasync() at inode_lock()
(down_write(&inode->i_rwsem)), 
which indicates heavy inode rwsem contention. 
However, the waiter stacks alone don’t identify the lock holder.

To move this forward, could you capture a SysRq-T (and optionally
SysRq-w) at the time of the hang 
so we can inspect the system state and help identify the lock holder/CPU
hog, 
plus any PREEMPT_RT PI/owner-chain information for the underlying
rt_mutex/rwsem (if available)?

Thanx, Kunwu

> [386.500022] Call Trace:
> [386.500027] <TASK>
> [386.500037] __schedule+0x1198/0x3f00
> [386.500069]  ? io_schedule_timeout+0x80/0x80
> [386.500088]  ? kvm_sched_clock_read+0x16/0x20
> [386.500111]  ? local_clock_noinstr+0xf/0xc0
> [386.500125]  ? __rt_mutex_slowlock_locked.constprop.0+0xecd/0x30c0
> [386.500148] rt_mutex_schedule+0x9f/0xe0
> [386.500171] __rt_mutex_slowlock_locked.constprop.0+0xedc/0x30c0
> [386.500197]  ? down_write_trylock+0x1a0/0x1a0
> [386.500222]  ? lock_acquired+0xbd/0x340
> [386.500245] rwbase_write_lock+0x744/0xa80
> [386.500266]  ? perf_fasync+0xc0/0x130
> [386.500284]  ? rt_mutex_adjust_prio_chain.isra.0+0x3240/0x3240
> [386.500304]  ? kvm_sched_clock_read+0x16/0x20
> [386.500329]  ? perf_fasync+0xc0/0x130
> [386.500344]  ? local_clock+0x10/0x20
> [386.500364]  ? lock_contended+0x189/0x420
> [386.500385] down_write+0x6e/0x1e0
> [386.500405] perf_fasync+0xc0/0x130
> [386.500421]  ? perf_cgroup_css_free+0x50/0x50
> [386.500440] do_vfs_ioctl+0x9b9/0x1480
> [386.500457]  ? lock_vma_under_rcu+0x7ee/0xd90
> [386.500475]  ? ioctl_file_clone+0xf0/0xf0
> [386.500490]  ? lock_is_held_type+0xa0/0x110
> [386.500506]  ? handle_mm_fault+0x5a6/0x9d0
> [386.500526]  ? kvm_sched_clock_read+0x16/0x20
> [386.502053]  ? local_clock_noinstr+0xf/0xc0
> [386.502073]  ? handle_mm_fault+0x5a6/0x9d0
> [386.502092]  ? exc_page_fault+0xb0/0x180
> [386.502106]  ? kvm_sched_clock_read+0x16/0x20
> [386.502129]  ? local_clock_noinstr+0xf/0xc0
> [386.502142]  ? exc_page_fault+0xb0/0x180
> [386.502154]  ? local_clock+0x10/0x20
> [386.502174]  ? lock_release+0x258/0x3c0
> [386.502196]  ? irqentry_exit+0xf0/0x6d0
> [386.502213] __x64_sys_ioctl+0x112/0x220
> [386.502232] do_syscall_64+0xc3/0x430
> [386.502253] entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [386.502269] RIP: 0033:0x7f62f7922fc9
> [386.502351] </TASK>
> [386.502357] INFO: task repro1:2072 blocked for more than 143 seconds.
> [386.502366] Not tainted 6.19.0-rc7 #4
> [386.502373] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [386.502378] task:repro1 state:D stack:28400 pid:2072 tgid:2072 ppid:294 2
> [386.502427] Call Trace:
> [386.502431] <TASK>
> [386.502439] __schedule+0x1198/0x3f00
> [386.502463]  ? io_schedule_timeout+0x80/0x80
> [386.502483]  ? mark_held_locks+0x50/0x80
> [386.502505] rt_mutex_schedule+0x9f/0xe0
> [386.502527] __rt_mutex_slowlock_locked.constprop.0+0xedc/0x30c0
> [386.503218]  ? down_write_trylock+0x1a0/0x1a0
> [386.503246]  ? lock_acquired+0xbd/0x340
> [386.503269] rwbase_write_lock+0x744/0xa80
> [386.503290]  ? perf_fasync+0xc0/0x130
> [386.503306]  ? rt_mutex_adjust_prio_chain.isra.0+0x3240/0x3240
> [386.503327]  ? kvm_sched_clock_read+0x16/0x20
> [386.503351]  ? perf_fasync+0xc0/0x130
> [386.503366]  ? local_clock+0x10/0x20
> [386.503386]  ? lock_contended+0x189/0x420
> [386.503407] down_write+0x6e/0x1e0
> [386.503427] perf_fasync+0xc0/0x130
> [386.503442]  ? perf_cgroup_css_free+0x50/0x50
> [386.503461] do_vfs_ioctl+0x9b9/0x1480
> [386.503476]  ? lock_vma_under_rcu+0x7ee/0xd90
> [386.503493]  ? ioctl_file_clone+0xf0/0xf0
> [386.503508]  ? lock_is_held_type+0xa0/0x110
> [386.503524]  ? handle_mm_fault+0x5a6/0x9d0
> [386.503543]  ? kvm_sched_clock_read+0x16/0x20
> [386.504012]  ? local_clock_noinstr+0xf/0xc0
> [386.504049]  ? exc_page_fault+0xb0/0x180
> [386.504312]  ? irqentry_exit+0xf0/0x6d0
> [386.504330] __x64_sys_ioctl+0x112/0x220
> [386.504369] entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [386.504464] </TASK>[386.504470] INFO: task repro1:2073 blocked for
> more than 143 seconds.
> [386.504491] task:repro1 state:D stack:28400 pid:2073 tgid:2073 ppid:292 2
> [386.504540] Call Trace:
> [386.504544] <TASK>
> [386.505300] __schedule+0x1198/0x3f00
> [386.505347]  ? mark_held_locks+0x50/0x80
> [386.505369] rt_mutex_schedule+0x9f/0xe0
> [386.505391] __rt_mutex_slowlock_locked.constprop.0+0xedc/0x30c0
> [386.505464] rwbase_write_lock+0x744/0xa80
> [386.505988] down_write+0x6e/0x1e0
> [386.506042] do_vfs_ioctl+0x9b9/0x1480
> [386.506301] __x64_sys_ioctl+0x112/0x220
> [386.506340] entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [386.506434] </TASK>
> [386.506442] Showing all locks held in the system:
> [386.506447] 4 locks held by pr/legacy/16:
> [386.506456] 1 lock held by khungtaskd/37:
> [386.506464] #0: ffffffff85041540 (rcu_read_lock){....}-{1:3}
> [386.506503] 1 lock held by in:imklog/196:
> [386.506513] 1 lock held by repro1/2040:
> [386.506522] 1 lock held by repro1/2066:
> [386.506532] #0: ffff88800784bc50 (&sb->s_type->i_mutex_key#17)
> [386.507276] 1 lock held by repro1/2072:
> [386.507284] #0: ffff88800784bc50 (&sb->s_type->i_mutex_key#17)
> [386.507321] 1 lock held by repro1/2073:
> [386.507328] #0: ffff88800784bc50 (&sb->s_type->i_mutex_key#17)
> [427.459692] BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0
> nice=0 stuck for 40s!
> [427.459779] workqueue events:
> [427.459809]   pending: vmstat_shepherd, e1000_watchdog
> [427.460020] workqueue events_freezable_pwr_efficient:
> [427.460020]   in-flight: disk_events_workfn
> [427.460052] workqueue writeback:
> [427.460084]   in-flight: wb_workfn
> [427.460231] Showing backtraces of running workers in stalled
> CPU-bound worker pools
> Message from syslogd@syzkaller at Feb 6 10:27:59 ... kernel:[
> 427.459692] BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0
> nice=0 stuc!
>
> Thanks
> Zw Tang


