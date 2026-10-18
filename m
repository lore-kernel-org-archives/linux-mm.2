Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD2F6CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 04:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997986B0093; Sun, 18 Oct 2026 00:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9211E6B0095; Sun, 18 Oct 2026 00:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8A26B0096; Sun, 18 Oct 2026 00:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 439F46B0093
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 00:37:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8A8B1403BC
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:37:24 +0000 (UTC)
X-FDA: 85334488008.30.F3D7E76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E49D740002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:37:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kA3anhgn;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792298242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9BtmiPUdXaKyy1Yxwr/J43UplsvVeIhpbcLZE0ZH2o=;
	b=pUj0Gr8VR+PoZ/7GMnb+wRiPuqyn28Gqzo6ovbOTO+vkZC77+XoXZ7CMGe7z1tTBEjQxFS
	slGR85OwHJ5zEUr51bBdec0HSiPYuo7r8I9M/6CLLLvJ4k51xFTczvTjArze5IknGo3er0
	ezkWjx2eqL6uqcLptSHsoTDSpo2VuRs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kA3anhgn;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792298242;
	b=oUWVR975g/u7YGhlNd3U4DVhqD3KRDMenjln+THCJmgIKIRUNqwhtNNwPczrvIVOtSq/FC
	0DjIUEyaIFXNnobMHOQHg7JUqrnAnf5FNspEFo7zPAt3+Tz26wImH8PpSnxDnDskV0SMTc
	vmMXQVVN4bBET2ZUZFj+W+RIOMwTbEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E08860142;
	Sun, 18 Oct 2026 04:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DEF1F000C4;
	Sun, 18 Oct 2026 04:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792298240;
	bh=X9BtmiPUdXaKyy1Yxwr/J43UplsvVeIhpbcLZE0ZH2o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kA3anhgnIbg8huv8B+zi9XeS9ph1nKGLhlku8EvIXLFMJ2JBxs7t94mE5wJa8QOy+
	 1pHVBECkOGC39HNNw8cZ8VFbuhKt92jrL7b7BieMeFAYoXyWjQUaO+Nsz8DeYmsEfJ
	 +mUGDScckDLtFEl5d3D4WWIm3ZCosyMH37636els=
Date: Sat, 17 Oct 2026 21:37:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+af37a78f810994eae641@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in filemap_fault (4)
Message-Id: <20261017213720.4f529d19d625743bba7a0e85@linux-foundation.org>
In-Reply-To: <6ad407e5.6814cce4.34c49f.00a4.GAE@google.com>
References: <6ad407e5.6814cce4.34c49f.00a4.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i7uafcoxk5sutn7n36ijun713aaoju8u
X-Rspamd-Queue-Id: E49D740002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792298241-832115
X-HE-Meta: U2FsdGVkX18MIWjH8mYAFCabR2NehPhfZxWNgVk7kVjgd5Ka11h4687Sh9JA/b37bFAJ56fbX3FWFlmW3TDQKPrZSozcxf64vkRupvRi6rZ15lOL0gKTNeZ3wX5VLDrGP/uSsoTTRQtkSbbjppTO8Uzhlw2qRb56Sl3ekm3EpBW77SZ3VjxruAm13nGSSUYWI4SqH86jcvVlrSC8p9x8cYGx8NMonsk50vXCDvPNU2EzbKzmAuWQiLMJMJxTMa2vHRX6ncnjBTBUClhQNEdQom1IBrK1mSNsVh9euvzITzM9xOUBMkyRCFoRkX2n3mAvbXpYu7j2CrgMy0inBtmVjcSykWEw5GrxtSRkvSS81ZTHVLom3cxzt98IsBXx8OLftKVckoSBPT90MQRFFC7WWsK5B9cDciy0Q3epauvX/vRyuOE0MEO+MiWuKcylqtXbLNgj4NicLw6Cl+6KsrIo8VrR3CY/XQjqUq6UeJz2VuBFatxMLAbMtNH0cTY2CtzmpQe7yDjXwvjCDGLu1MjUi2Q0IomoXl1s2ZirbIujJ5tLnJxL/EZpM3z2ZAv2Qim0jp97MmYDN6WZjEiapswd/Zm/94fN9LjZcTGYutp7ubgzlmbloie72oGf2IWKfehYDNkQ906FWK1EXLjEGI7r+o0507v43fVOYgtKOimTXqi63G31x5n6SrX0Se++ez3itFUgxWybiTPxi6Myryq3uQTMAzTHsjY7JFevcMIGt8z0uv2U/rMInpi2IRzb+OJ8bGotxdka3YS+y+mnuWPL52waq35h6dh+bIrNyr1zRKqsVx+tRN5pXbZsttOtrzuX0T31CL90XYoazNl/4Z1vctkPot7BLbQn+cXMCcuTAa8le57dcMFLEzTmagnTNy48QILhMlBSwog6kUkMXyJZWFHypiqAKzr4oyvO7lfhXvDX6ncKfqYpQdksYfHcVemMcRKx5hffWsi6NrrZr6B
 281xvplj
 I3/r0BThVbP+jyoI6l692CGqN+xLzJ66pG8JJ3eqACIrsr4ClxF9CHMTIF3PupkhyP7+itxXCpBJ6zQ2Xi1BjVzAtswy2Ytqfcv69AQuqUXQf88szLDFXMtDGkj499xyom/WYo8Zcm9YP9nTdsvj0qIDJ1RxeSFHvhmufuBccq4Yl+vGRIhCYS/4myEq2R5ECkESegQ43fZm8u9tWBBUAWYuAsrG8vg1q59wG5kL/mtYxMmgp77fgk81wfATmkV0pXmH9jjTIYVS1xHTGIPN3tWSbzjC/Kd/XUz+CxhOXijSXQ80wG4N98Mi195x9Kwik9yL1Aq1O66P/Sh08q9yuC+uCCTsC6EtYbhj9xyzAg+nXDD0uOl2pjyWBef15nfDfKINAMYwNuNTzvd1gjwHz8yTPzlJPvhxP+d+nLWUROKBxfHCorIRMRcYGwCp9iX20pg1YMUOQ21kCmDuvo8tZR7GJtxGNf84eeQ+PkpZpCt3lhJu8xyTBfKmV1V5s+PfXU9gcZcrrCIRuRMiEITjuL2dQ4xlW0D6foJF9qt2zPH323MtqXEBaVDZ+7j0jFPmWWlVOGPj22MsHmNbhXgVTY7qGuV0gNuBDm2lEQW9BJn6Yo5lyj4DVl+j7krGQxZekJo+BKtuMt94Uv3WD81zNldYgne+fyaVxno08utbHPv098F9I+qs14NnkGoU/K+NJBsnuSMTUYeZOz/rmxh7uD1OwMhR1757CteqQlgEwvkF5/oY/aX8phPc8CDgKewDq/aNDbef0SFXtk5h7t1uk/RNJBKR6LC8yau+Nu4fUnXwNp2s65Sr/mG4JDxKmzQbOGSQfhBk2XyZkbCCyBlAqhVN+S1dYBXAzy9Lnt9O5EMOoVHusdz6E9wuKs8Fjd3ZLxdOPpYEzKqpPZGrZB7Yfj1GO3reMfZg3hq59mbo/DIJffrO5mGx5C3NARZUKPb61RV0PSaX8mrocgsWUJc5IxllUGJyb
 Wj3/WK0Q
 T6qtYVqO+5HhbosG2uy0Muq/CzmKwmz4uLr8G4BQxs8QeYr7S5v4ng3Fm5sJdHB0UtovU09VIb9YvDm6jSKID9x/gplMh+PZKwD1LVJj5PAaeifK1VhtIGrzQTuLD62ISL6QRXor0/wb7G4J2YWPljYAxwxAc573U76bljdl5yu/U90lvPa2MSN+f0ZJSoqBxHgmkoccgdJAuab0e97x/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 16:42:29 -0700 syzbot <syzbot+af37a78f810994eae641@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    70dd4ee72eb2 Merge tag 'pinctrl-v7.3-3' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b2320d580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4ccb65e03706547e
> dashboard link: https://syzkaller.appspot.com/bug?extid=af37a78f810994eae641
> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10de5da9580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-70dd4ee7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f1d9bae25289/vmlinux-70dd4ee7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d8b2b9fc2571/bzImage-70dd4ee7.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+af37a78f810994eae641@syzkaller.appspotmail.com
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:

Thanks.  AI tells me "Yeah, this happens.  Don't Do That":


This looks like real-time scheduler starvation rather than an MM bug.

The reproducer contains:

    prlimit64(0x0, 0xe, ...={0x8, 0x8b}, 0x0)
    sched_setscheduler(0x0, 0x2, ...=0x8)

These enable SCHED_RR at real-time priority 8.  The reproducer
runs six processes on a single-CPU VM.

This can starve normal-priority tasks, including tasks preempted
inside RCU read-side critical sections.  The report also explicitly
states:

    rcu: rcu_preempt kthread starved for 1643 jiffies!

This failure mode is specifically described in the RCU stall
documentation:

    https://docs.kernel.org/RCU/stallwarn.html

The documentation explains how CPU-bound real-time tasks can
prevent preempted RCU readers from running, indefinitely delaying
grace periods.

The task in mem_cgroup_from_task() was interrupted by the timer
interrupt and preempted.  There is no evidence that it was stuck
in that function.  filemap_fault() appears to be an innocent
bystander.

Could we rerun the reproducer with sched_setscheduler() and
prlimit64() removed?  If that eliminates the stall, it would
strongly support the scheduling-starvation explanation.

I don't see evidence of an MM bug here.

> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P5320/1:b..l
> rcu: 	(detected by 0, t=10502 jiffies, g=61125, q=864 ncpus=1)
> task:syz-execprog    state:R  running task     stack:22864 pid:5320  tgid:5314  ppid:5313   task_flags:0x440040 flags:0x00080000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5533 [inline]
>  __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
>  preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7606
>  irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
>  irqentry_exit+0x14f/0x920 kernel/entry/common.c:167
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
> RIP: 0010:task_css include/linux/cgroup.h:548 [inline]
> RIP: 0010:mem_cgroup_from_task+0x8f/0x120 mm/memcontrol.c:1134
> Code: 38 48 c7 c7 58 c8 d9 8f be ff ff ff ff e8 a9 1a a8 09 85 c0 75 23 49 83 c6 2c 4c 89 f0 48 c1 e8 03 42 0f b6 04 38 84 c0 75 6e <41> f6 06 04 75 09 e8 76 f7 68 ff 85 c0 74 28 48 83 c3 20 48 89 d8
> RSP: 0018:ffffc9000e0ef610 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffffff8fd9f0c0 RCX: 0000000000000046
> RDX: 000000009a0f617f RSI: ffffffff8e6f5004 RDI: ffffffff8c6dec80
> RBP: 1ffff110061db463 R08: ffffffff8242ae78 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed10070f1e47 R12: ffff88803878f230
> R13: dffffc0000000000 R14: ffff888000f525ac R15: dffffc0000000000
>  get_mem_cgroup_from_mm+0xd6/0x290 mm/memcontrol.c:1187
>  __mem_cgroup_charge+0x15/0x80 mm/memcontrol.c:5226
>  mem_cgroup_charge include/linux/memcontrol.h:662 [inline]
>  filemap_add_folio+0x140/0x4e0 mm/filemap.c:965
>  page_cache_ra_unbounded+0x46d/0x9d0 mm/readahead.c:293
>  do_page_cache_ra mm/readahead.c:348 [inline]
>  page_cache_ra_order+0xb47/0xee0 mm/readahead.c:558
>  do_sync_mmap_readahead+0x75e/0x990 mm/filemap.c:3443
>  filemap_fault+0x7d9/0x13b0 mm/filemap.c:3597
>  __do_fault+0x138/0x2a0 mm/memory.c:5565
>  do_read_fault mm/memory.c:6000 [inline]
>  do_fault mm/memory.c:6134 [inline]
>  do_pte_missing+0x2215/0x34b0 mm/memory.c:4700
>  handle_pte_fault mm/memory.c:6558 [inline]
>  __handle_mm_fault mm/memory.c:6707 [inline]
>  handle_mm_fault+0x1a53/0x3750 mm/memory.c:6876
>  do_user_addr_fault+0xa4f/0x1340 arch/x86/mm/fault.c:1343
>  handle_page_fault arch/x86/mm/fault.c:1483 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
> RIP: 0033:0x46fe0e
> RSP: 002b:000010e09c0a5178 EFLAGS: 00010216
> RAX: 00000000015e4970 RBX: 000000000173a820 RCX: 0000000000000000
> RDX: 000000000001a058 RSI: 00000000015ca918 RDI: 000000000041db80
> RBP: 000010e09c0a51a0 R08: 00000000015ca918 R09: 00000000015cb3b8
> R10: 0000000001911ec0 R11: 0000000000000000 R12: 0000000043fdf3b9
> R13: 0000000000000000 R14: 000010e09c078960 R15: 000000000000012a
>  </TASK>
> rcu: rcu_preempt kthread starved for 1643 jiffies! g61125 f0x0 RCU_GP_WAIT_FQS(5) ->state=I ->cpu=0
> rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
> rcu: RCU grace-period kthread stack dump:
> task:rcu_preempt     state:I stack:27496 pid:17    tgid:17    ppid:2      task_flags:0x208040 flags:0x00080000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5533 [inline]
>  __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
>  preempt_schedule_common+0x7f/0xd0 kernel/sched/core.c:7463
>  preempt_schedule_thunk+0x16/0x40 arch/x86/entry/thunk.S:12
>  __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
>  _raw_spin_unlock_irqrestore+0x76/0x80 kernel/locking/spinlock.c:221
>  debug_object_assert_init+0x20d/0x380 lib/debugobjects.c:1072
>  debug_timer_assert_init kernel/time/timer.c:803 [inline]
>  debug_assert_init kernel/time/timer.c:848 [inline]
>  __mod_timer+0x4b/0xed0 kernel/time/timer.c:1025
>  schedule_timeout+0x14d/0x2c0 kernel/time/sleep_timeout.c:98
>  rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2122
>  rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2330
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> rcu: Stack dump where RCU GP kthread last ran:
> CPU: 0 UID: 0 PID: 5761 Comm: syz.2.24 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:get_current arch/x86/include/asm/current.h:25 [inline]
> RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x80 kernel/kcov.c:212
> Code: 8b 3d 34 de ab 0c 48 89 de 5b e9 93 fc 66 00 cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 04 24 <65> 48 8b 0d c8 9d ce 12 65 48 8b 15 c8 9d ce 12 f7 c2 00 01 00 ff
> RSP: 0018:ffffc9000d3278e8 EFLAGS: 00000202
> RAX: ffffffff8be56f10 RBX: 1ffff11006b094a2 RCX: ffff888034c90000
> RDX: ffff88803584a508 RSI: ffff88803584a508 RDI: ffffc9000d327ab8
> RBP: 1ffff11006b094a1 R08: ffff888034c9001b R09: 1ffff11006992003
> R10: dffffc0000000000 R11: ffffed1006992004 R12: ffff88803584a508
> R13: ffff88803584a508 R14: ffff88803584a508 R15: ffff88803584a510
> FS:  00007f0baa9bd6c0(0000) GS:ffff88808b0b4000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000058 CR3: 000000004004c000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  __list_add include/linux/list.h:172 [inline]
>  list_add_tail include/linux/list.h:206 [inline]
>  plist_add+0x420/0x580 lib/plist.c:111
>  __futex_queue+0xed/0x160 kernel/futex/core.c:866
>  futex_queue kernel/futex/futex.h:333 [inline]
>  futex_wait_setup+0x424/0x590 kernel/futex/waitwake.c:695
>  __futex_wait+0x15f/0x400 kernel/futex/waitwake.c:717
>  futex_wait+0x121/0x390 kernel/futex/waitwake.c:750
>  do_futex+0x3e7/0x4e0 kernel/futex/syscalls.c:133
>  __do_sys_futex kernel/futex/syscalls.c:210 [inline]
>  __se_sys_futex+0x3a8/0x450 kernel/futex/syscalls.c:191
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0ba9b9e559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0baa9bd0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: ffffffffffffffda RBX: 00007f0ba9e25fa8 RCX: 00007f0ba9b9e559
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f0ba9e25fa8
> RBP: 00007f0ba9e25fa0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0ba9e26038 R14: 00007ffe158db450 R15: 00007ffe158db538
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

