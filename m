Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD781C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 995BE6B0095; Thu, 20 Aug 2026 21:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D8B6B009B; Thu, 20 Aug 2026 21:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9C26B009D; Thu, 20 Aug 2026 21:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 652A96B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:07:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DCFC80329
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:06:58 +0000 (UTC)
X-FDA: 85123487316.27.9349B2C
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by imf30.hostedemail.com (Postfix) with ESMTP id 21A4E80004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:06:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwvmaNSx;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787274416;
	b=uqbyvGzofL/Z+B2jBVxFnhLO5p4TDvziDPX5LXGp2mvFs11a0vKvPndAvVWOebRr8UlnE0
	QTSMu3PznLbiqwfUEzN4r5qyw4O9Pak7lqTHj7Ehep3KWNOywVHBS+WymMGaIFMBbmryXx
	k9zFIZ2h9gzfKwxIKOWuxiM1lEGhUMw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwvmaNSx;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787274416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5dy139H1ZUOLqexBrPXKbtLeBED6p8c6CuLPrEsQcw=;
	b=lzG6c+njtBMNDPAh+Z2PIdA5bN22dazO9hVqSI8CrlZlXE/Ulwn3nAelN2pwDufgiyYNA1
	pDQrqE2flh0eg9MyqONj99qrNGVIRc/LaiKOlNa+UFJZVdojLe33/rNo+By5RHFbZk2fzY
	0cr+m+ctiI5rS+rZje6JQ+VPtDWhmS8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=K1iqVU8GuphpTpCTo1BVQZqa9SDJDP7wQUwvLAGhYkA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787274414; v=1; x=1787879214;
 b=MwvmaNSxVafRvY6i4zbXLlhlZgJe5RIkzrzTkGecESD3xDSVJdXHCvmqr477MMKz3x6R6BPp
 bfjAyNzoXVppc6IetDhWDYrC56HyAtNYN465sxxTSDLH/HpvQTNHtRP8o5NJaulQg+TeOsLyxcK
 Cdx+e3krQG7X0FCEIWhBSm+c=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.111.29] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 89f7e09dcf9bdac5;
	Fri, 21 Aug 2026 01:06:54 +0000
X-Mizu-Trace-ID: 89f7e09dcf9bdac5
X-Migadu-Flow: FLOW_OUT
Message-ID: <d477b226-cf6e-4101-9a4a-71c317a891d1@linux.dev>
Date: Fri, 21 Aug 2026 09:06:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in kvm_vm_release (4)
To: Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com>
Cc: brendan.jackman@linux.dev, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 ziy@nvidia.com, Zhen Ni <zhen.ni@easystack.cn>,
 Oscar Salvador <osalvador@suse.de>, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>
References: <6a86fe29.f7a79266.2f965f.004a.GAE@google.com>
 <20260820092904.7a2b43fff85ed0c13b9c74ab@linux-foundation.org>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260820092904.7a2b43fff85ed0c13b9c74ab@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21A4E80004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8cydwseroii4dkhcfwhmct3bz9dx75xo
X-HE-Tag: 1787274415-831029
X-HE-Meta: U2FsdGVkX18DxyxxE2R++13lR3XbMec+zVAMZWbhDE1/GW6x8OB8ylanTehs56DGrI8NtpQvbOw3BiMRejcXWX5NZ633MmSLBmvppp3kOKq0dMikdmGzVt1Wqw9Dy1/3XqFrLN9SYma4tV6DvLaGPIQKnxNCa5vOivEnqGo4xIeTzD9EO6uG6xMCipe5u534FdcE6iMvKd0dsmRtJeg2Ycog1aqhqgqm8UPwK2UC2bbM3pT5zBDqwZiTgDZhy9GnnE7IbFITrx463aBTYRNrbVytubZL3Zz/pbQJ2FVQk8WDJ4/6kS/T9fUSu2qjE+AoZuvnJFUJTyZhA8oHKO2lgnQPb5TajPQuZGko3BBLwdtW2XV4MUJTyjCALK4rcLbSse/JvcxqkbhjGwk9+mLbbXeN3zoVlonJLO1i6Ze4K1y6SIdGvt0LEKX5hsH9Wg/Ym/ppx/5TZUMCCqR97Y0jYoQJcKLiet39DoUdfZr8FPVYVDjJd1rgPTQrJEvp25CsORX56VSAhmNTJ+82sd3Rx6v5igIyLsOgT/tHE273LUlRA4FHS4pj27KTs5aQIb7duiYqFVSu+vK2s38HRWmgMrylW2zJiAjdbxpQ/+aDKS9s5EQ5WMvmd56LBw6/3V0JCIpA5QJILM7zC2ZivhzDRG5r1c3wgM0li5xy2avNbALsWckT2TSTwf4fpvpoV6/yvOAnxTvX4js2IpSRzLwoEqiPCfDms9tPgjI+e48sJktzR4ne43NzfnfhTiFTgpWWiYZRAE/mfu5FKaekxR9Iu8G5ISpQuus9xlgewTDRsQO7foz8JLZtLwDS6rW2I9OTxGp29M8supE6rPE0Lj6xzL7CH1+zalVHEp35ZBr/FZQ5v3azYNghT+y0VQTpt8ubDLYny/2vmvmMtGCzePlVrM4Ge3EmXo1DRPQ/o/ljeztcXFoiyG1Abp6/0XOkZBUWbl2fYCYDK/z7LMjz9Ej
 I8dZfizL
 eQ39XXGUaUhMnx/6F+rJvxOzfIsFRBweYWx5JSlgTI8i+OMmpqTk8SCPgjVBaQ/D6Lg1AcFzal2zOm8aA8c+9bF1Zk0+GIxcNTeg8q9oYIYVYgMSYmF0t/8a/xb1SRAVF5bJIkxSzGTxdtsFz0aEJtKdnbmy6UaKKKWcMjulsEksET1gaYHBYR6q4TnxZeEl+/NDgoFst5TVcGq3uID2zShkcLsjyLPBKTKM2QBwdCR5gRFYXm8Z8S4LWoS+OEJd23FAcUutgFGJIar50c+41z+1laTIFQs29hcqdb7YoqbvuUpR12eYChndlVUNGwCqJp3OdDum3Cp/6cOGgWSUxbBnd/KmUVjtPFF9d3xKvjNfhgREfCij2pj6Iye3ee+iuijmDAW2JrNEjNV91eXxzhwnZARPNjUdCtlETLLRLYD14GF8kPOrzLyID9Q+2KMis5QqmY9oEumhl7CkAUyKnYhE/KjYa3/mGAWWpsI7ifZKo3uAjcNTxx2CxZCZWsnotI3OFnKruNBCAISYRl/9JhxSmn9nDUroGHfiAPKfIA6IlNU5r+LbgMcdV9EkQevUfyCUmGS3VExa1ZGebx2+WS/WI1AI8hq8QcpYWEMZMtW6uBpBo5DxicKCm9ugA5E/wfbrqpuDKLocYSeVTQSJibSHmkYqp4L+UJ0wu0OZNZoS/AU+F1oRhijCAz4fp7aAeixw71SC9rlsjKHtUyqedsYxYTz4OTMKtuLOsNU2XIHTjULsCdUW64gFJjFSsfDMGcXjt1q9Wawb/V0SHQgF1TPEGA+JH0ESNNvMpfbKbrQYj9KZ6HlaJNdNkDHpYiBlQ5XsrwsuBb70BDCRYAZqtNgT61a34ZNiOvCBAM5KKAwoYULcUjdoRpax8wdDScedEab9S8NV2cYA/+TZf98Uh+tpkBMmaJOOOohqkXtvQWUwUqjgx+BY7XSztHwohm16x5Em8EJ7KOpdL1+PkXEZsGZnjyKGn
 TKbh+UxX
 3hXaoT/vETnblr+eQ5/VpOVZtjRDab3wbnl7bZzhta+/ZT2Msw6xE3mn1xZ5DBCwyGdW+SIJpcSxyDfl3cnq2ROXZtw3B/CHldoKjP4lUjz42fR+GNil55kKlGGr0UcIMACcSWU5nZA8AkwomlTp2nUMI/4ZB9YWwbIylNthu5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/21 00:29, Andrew Morton 写道:
> On Thu, 20 Aug 2026 06:16:25 -0700 syzbot <syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com> wrote:
> 
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    e8bf40d15402 Merge tag 'chrome-platform-firmware-v7.3' of ..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1434f815580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1941312e3e971b07
>> dashboard link: https://syzkaller.appspot.com/bug?extid=5f0b6e2e4195c75b5658
>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/7df7b958efe0/disk-e8bf40d1.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/cefbf90e524a/vmlinux-e8bf40d1.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/37a530b91001/bzImage-e8bf40d1.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com
>>
>> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P21500/1:b..l
>> rcu: 	(detected by 0, t=10503 jiffies, g=207513, q=1145 ncpus=2)
>> task:syz.9.4605      state:R  running task     stack:26920 pid:21500 tgid:21500 ppid:14397  task_flags:0x40044c flags:0x00080003
> 
> Thanks.
> 
> lazybutt pasted this into Gemini:
> 	https://share.gemini.google/9rAubqC4qNzf
> 
> : The combination of debug tools: KASAN quarantine processing + ORC
> : unwinder + page_owner stack tracing executed so slowly on the CPU that
> : it exceeded the RCU stall threshold.
> 
> (I think we've recently seen the same thing, different callers)
> 
> I can't say I'm terribly motivated.  page_owner is expensive and if you
> run heavy stress testing with page_owner enabled then such things
> aren't surprising.
> 
> Let me Cc a few page_owner and KASAN people, see if they feel
> differently.

Adding cond_resched() to the qlist_free_all() loop would fix this .
kasan_quarantine_remove_cache() already dose the same in its scanning loop.
> 
>> Call Trace:
>>  <TASK>
>>  context_switch kernel/sched/core.c:5510 [inline]
>>  __schedule+0x17d4/0x5630 kernel/sched/core.c:7239
>>  preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7561
>>  irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
>>  irqentry_exit+0x14f/0x910 kernel/entry/common.c:167
>>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
>> RIP: 0010:lock_acquire+0x222/0x350 kernel/locking/lockdep.c:5890
>> Code: ff ff ff e8 c0 0b 32 0a f7 44 24 08 00 02 00 00 0f 84 39 ff ff ff 65 48 8b 05 12 77 cb 11 48 3b 44 24 58 75 33 fb 48 83 c4 60 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d 57 a1 b8
>> RSP: 0018:ffffc900074cf260 EFLAGS: 00000286
>> RAX: 7db047bb98fc4c00 RBX: 0000000000000000 RCX: 0000000000000046
>> RDX: 00000000c0065176 RSI: ffffffff8e4b5735 RDI: ffffffff8c4bdd80
>> RBP: ffffffff8177710f R08: ffffffff8177710f R09: 0000000000000000
>> R10: 0000000000000000 R11: ffffffff8eb5a0e0 R12: 0000000000000002
>> R13: ffffffff8eb5a0e0 R14: 0000000000000000 R15: 0000000000000246
>>  rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>>  rcu_read_lock include/linux/rcupdate.h:840 [inline]
>>  class_rcu_constructor include/linux/rcupdate.h:1183 [inline]
>>  unwind_next_frame+0xac/0x2550 arch/x86/kernel/unwind_orc.c:495
>>  arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
>>  stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
>>  save_stack+0x122/0x230 mm/page_owner.c:165
>>  __reset_page_owner+0x71/0x1f0 mm/page_owner.c:320
>>  reset_page_owner include/linux/page_owner.h:25 [inline]
>>  __free_pages_prepare mm/page_alloc.c:1406 [inline]
>>  __free_frozen_pages+0xc22/0xd20 mm/page_alloc.c:2950
>>  __slab_free+0x274/0x2c0 mm/slub.c:5741
>>  qlink_free mm/kasan/quarantine.c:163 [inline]
>>  qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
>>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>>  slab_post_alloc_hook mm/slub.c:4584 [inline]
>>  slab_alloc_node mm/slub.c:4917 [inline]
>>  __do_kmalloc_node mm/slub.c:5333 [inline]
>>  __kmalloc_noprof+0x315/0x720 mm/slub.c:5359
>>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>>  _kzalloc_noprof include/linux/slab.h:1309 [inline]
>>  kobject_get_path+0xc5/0x2f0 lib/kobject.c:161
>>  kobject_uevent_env+0x29e/0x9e0 lib/kobject_uevent.c:548
>>  kvm_uevent_notify_change+0x300/0x3a0 virt/kvm/kvm_main.c:6335
>>  kvm_destroy_vm virt/kvm/kvm_main.c:1260 [inline]
>>  kvm_put_kvm+0xa9/0xb50 virt/kvm/kvm_main.c:1331
>>  kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1354
>>  __fput+0x418/0xa50 fs/file_table.c:512
>>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>>  exit_task_work include/linux/task_work.h:40 [inline]
>>  do_exit+0x73a/0x2360 kernel/exit.c:1009
>>  do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
>>  get_signal+0x121b/0x12c0 kernel/signal.c:3046
>>  arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
>>  __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
>>  exit_to_user_mode_loop+0x10e/0x770 kernel/entry/common.c:101
>>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>>  syscall_exit_to_user_mode include/linux/entry-common.h:336 [inline]
>>  do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fe3a1f5e90e
>> RSP: 002b:00007fe3a2e23f58 EFLAGS: 00000246 ORIG_RAX: 00000000000000e6
>> RAX: fffffffffffffdfc RBX: 00007fe3a2e246c0 RCX: 00007fe3a1f5e90e
>> RDX: 00007fe3a2e23fb0 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: 00007fe3a2035024 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007fe3a2226308 R14: 00007fe3a2226270 R15: 00007fe3a234fa48
>>  </TASK>
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>>
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>>
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>>
>> If you want to undo deduplication, reply with:
>> #syz undup

-- 
Thanks,
Ye Liu


