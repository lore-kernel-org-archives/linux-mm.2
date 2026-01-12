Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFEAC9EC8B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E596B0088; Mon, 12 Jan 2026 08:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB4C6B0089; Mon, 12 Jan 2026 08:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2886B008A; Mon, 12 Jan 2026 08:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE216B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:13:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF44113914D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:13:04 +0000 (UTC)
X-FDA: 84323352288.09.68509A3
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C60D1C0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:13:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3XvNkaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3XvNkaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768223583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=W5/8R+KlDWyHQK+wX8OpQ1/dDuAPGFVgWFkUGH+s94w=;
	b=Qu388f5U/piY71T8HWw1AMYzletI8OHYCZNBIy0PN/C0yBFFM1KQLC1bOkDjGpDEEOJqbv
	rUppVWBXq9CCSMjdkyP+M18CjB1upCvoM044E8CySvv8+Gpubet7bX9EcxosKIdX5+WsMz
	ihYdIFzd/WQlfLMjVfQcEDwxHLcfIa0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3XvNkaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3XvNkaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768223583; a=rsa-sha256;
	cv=none;
	b=Xa6GnMxsfN12vC1lzeiQ9T+BAA/VU9kw1SC0uyYp37HGERovzH4olP0E99VyJzzDF3KAsr
	2O9UsPsct1aVU+g/tBCmIYkW1tX9iIUB1vMDb+TQgKprPjiLkDnEynuLlLo00YrhvIaRl3
	x8uSME6PvGLCeKUqzCVWX+BcySO3kXE=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c75663feaeso13819360a34.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:13:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768223582; x=1768828382;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5/8R+KlDWyHQK+wX8OpQ1/dDuAPGFVgWFkUGH+s94w=;
        b=eYXKmmWQBqaNt0AriCuWbDsDZkAVKGtKJQ3hFRiB/fHvLB+RNbRccP6LGBj0+hivTs
         RPcWcHLBgPWolznH5HTmu/GkgfM+E27fiZ8s4BpOX0c2boi1c9jPKuBd5qYj0gZmesw8
         rrh55UI6X2+OpiPHc39aB7TEbN2msLRBibw0rzpQfPoOxcDUIw7pB9Qesf3HgH3uWgQU
         aTChY+tG6DYQfogfWqiHtsVcqjtLimGTcKYer926/mhiR6L8m27Oq3RTuhY4/BXDVajW
         uGTqdJSi353wML2+YV+GTyHJjsqqq8zhrr7CLSGNHs4HeO9HwgEioHMcrfSoCt0HY5a1
         oLHQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+mIrjSxdRSyr30vgvow9wAHpF7QQ6Klo4ltv+gbQ3YZu76Gv3pQ42YVkg/bK1IMKOyjxP3LaOdg==@kvack.org
X-Gm-Message-State: AOJu0YxhBZ1ONJ0suPPgiAo2vnyq9AJ8Gxa7SdZDSzzbBsZmbs9exqSh
	oOfm8uzylPJf6hqd0OR8KtPVpaspZoKynFKfEyjgY0XGKtzZ9EPwZ3mNsM+W/bjGHzmx420DdDp
	8plmFFmMwJkF9Yy/S8kGevvYtM4IdT8jdi+QaX9RoQsWqdvlRumY1Mq/0sIg=
X-Google-Smtp-Source: AGHT+IHRqp70s6c1iXYsBtxoUC3pW/IUji0xTkcsjIPSBM0NVQSFb5X+KNBvGWJJKVH9AntJ6P1bWs1GVG+PQmUl5atWGWvWzCWH
MIME-Version: 1.0
X-Received: by 2002:a05:6820:22a7:b0:65d:7e5:d49d with SMTP id
 006d021491bc7-65f5509e346mr9171331eaf.72.1768223582167; Mon, 12 Jan 2026
 05:13:02 -0800 (PST)
Date: Mon, 12 Jan 2026 05:13:02 -0800
In-Reply-To: <20260112120904.2172-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6964f35e.050a0220.eaf7.00a5.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in purge_vmap_node
From: syzbot <syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hdanton@sina.com, kartikey406@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kgiy89qnbmh9q98rfjqbt1n95hxmqjpk
X-Rspamd-Queue-Id: 2C60D1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768223582-607705
X-HE-Meta: U2FsdGVkX1/tMEykZjL9gP6+eTkZvLW33jtf62o2cPZCVOGOoSHgqrP/GVCw2jKARHd1A1eNffs0JZRyyJu89aYmAd6y0f8flgadHkwSI6U4IA6SqNvPHzhmoF42VDhec/k44yf6lwufYCAa1mmMbd+0BFphOMl75W+ogr0nrw5nsyzKG05w8oIbiw5g0UTXOsboKWedtNHCGbaCcwHDxi9Zo0HgIkQpyD2yQiNUdQNNwkvKVoI9TPc5JkbSEbGpnXpZw/hCdtWCQ0n64MnbtfdlElLGhXPZ773Col0h1N+5QcFO6cUaY1WlvIPDn0owZTtyNZzE3T9KiF2Koz8JXWJAAyYLfD6Loulv7yv0SkhJqJasyiBk5EB4tGasfGuqrFfBcjDYzfFEacMUcgOIYHPUPG3ImMLVeiUaPb3MqlpwmUff+uqmP1HbPzE1cpZ9HDwzCyzk97QreHlCY0MojMqjzvrYh+KdoUYDMtbLXAmGgLArieLQFm0NqJZIaAJe7E/Eau+cLIb2fYHvAurIzj1XgapJ8203CkRBDYYHah5BNkAOiQY8NqoT7uBb4jz27b7DOdeGs0+Q7BQSROc7Rq7O2wvyNWkprKz7OQgYcDQYMWSTcfUtnns+Bbg5NVipEFjGIgqJLiA21sZqkKgED72BuC8evET3q6+mUl/veIab3NTHILBIanWsB9dtjIutFsP9DtkA7lnHyV8zVutmLb20/uanQ2HntEz4xyvvJSaQwBGW/kLynijm0guitdOqW3SXafScAYe3CZUSt+f/8NUP+GufHN0jlDJEVRqA4ac8aeuk1LHfVDTrvDu5Hog05oEjcGuBPVc/2h/hET62IjEZAuLakeojiQ9kJXNY1IfHeVspZZLu4XWBDnXhmO89C5bp944pPMhZtci/qLViMkis9idUdCfdlIAD8HB0QKKx4ul2zBpHjBNxXNlzIbV9GdTWeK4PEH1oTP4VUeu
 2Y+u7fj+
 ZNsLVjaDl7WxX81ABXtIh7G0r2jGbt6hn6dBX3bx91LcfBNq3G3AcAnTVpJ0GArwj+SN1YATwWuN2z7N5kbspcehzgI+JmfF1ivh7UDLjXVf8tlEPf+TvccvmvrpTMWkYnSdFBLVkPTPi7dC/AyFJj58uzmwMhGVDOe3e6F2XQzIRJmn0znCfnMXyntfVe4GxoqOzpapMjqWDZ8RfNoWLeDW28Xp2u6MjCWgNfScDquQ2mR5asIJGj1rPW95uerEKxLrfTTLu3eWjoqEhYMzb74xHJNRIrnE82z1GYOx2/Li8Bo3c4pHKrlBOf/4WHtI5/5DDsnlP34hA7obpGis1SV+YVG262eFyksFf/0dZb1PH3uCvB8mzQP1y4zfq5V/AY/4b3GZPLAhHX2+WeL2T7rbqJKgde4CI6WvqKdcNBRnwUvwE1PCx8RhgELJN9jNKq2oXBU2GHCN9yqd5kNCGue2pUnq4czL2cZLaDqjwJNvf4WeOJ+rGFBExM5+quITpcqvL1szCO7Cy9MlUE7UGhb0ySoV7sBKj8mwH6XKNj0Ttn6l3VtOHR2NUPIb7JipvuyNr/52TPYZPknke/lZEMGsWUCuj+4NKt+BFxe6TDD1I03DuY5L6mRTxVTymnFlpjtVwG1La+ceXPonG26IOfRyKnwSP43UFBbfNmaQzGJTTq6a8kFOnIFPQ+RVrGT9LWlqMl6u1cxdSXjV5v515qNUkOagPio92UgNaLh/YtmB/EHlQ/gccMk+BtTcOYU/3DRKEpXMUV7ZSeex6Xk3qyzQdrBMWfXM61cqD3r+sztR+MV/LUiI91gOX1Rc3OIkO3TZwGzhvmp+Npc5mEQ2KbsyPN6Am6ib5k9xoI/21XfDTtAqSfVTszo0RgxrOTH00TEvMBTSnjo6I3Sd7dBWF1lrrbCM4PuQW+vqShdLKWw5ObPxAJ9GgZLoe5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: rcu detected stall in x64_sys_call

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6717/1:b..l P5934/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=15885, q=682 ncpus=2)
task:kworker/1:4     state:R  running task     stack:27080 pid:5934  tgid:5934  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events cleanup_vm_area_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7190
 irqentry_exit+0x1d8/0x8c0 kernel/entry/common.c:216
 asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:unwind_next_frame+0x14e/0x20b0 arch/x86/kernel/unwind_orc.c:510
Code: c0 74 08 3c 01 0f 8e 20 0a 00 00 41 f6 86 88 00 00 00 03 0f 85 71 02 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8d 75 35 4c 89 f2 <48> c1 ea 03 0f b6 04 02 4c 89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85
RSP: 0018:ffffc900033477a8 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 00000000c5fffc65
RDX: ffffc9000334784d RSI: ffffffff8bf2b380 RDI: ffffffff8dd7cf28
RBP: ffffc90003347860 R08: 0000000076218ff6 R09: 00000000676218ff
R10: 0000000000000002 R11: ffff888025fb54b0 R12: ffffc90003347868
R13: ffffc90003347818 R14: ffffc9000334784d R15: ffff888025fb4980
 arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 save_stack+0x160/0x1f0 mm/page_owner.c:165
 __reset_page_owner+0x84/0x1a0 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0x7df/0x1170 mm/page_alloc.c:2943
 vfree+0x1fd/0xb50 mm/vmalloc.c:3474
 cleanup_vm_area_work+0x4c/0x100 mm/vmalloc.c:3771
 process_one_work+0x9ba/0x1b20 kernel/workqueue.c:3257
 process_scheduled_works kernel/workqueue.c:3340 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3421
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
task:cmp             state:R  running task     stack:25800 pid:6717  tgid:6717  ppid:6660   task_flags:0x40000c flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7190
 irqentry_exit+0x1d8/0x8c0 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
RIP: 0010:rcu_read_lock include/linux/rcupdate.h:867 [inline]
RIP: 0010:class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
RIP: 0010:unwind_next_frame+0xbe/0x20b0 arch/x86/kernel/unwind_orc.c:495
Code: ea 03 80 3c 02 00 0f 85 5d 18 00 00 49 8b 45 38 48 89 44 24 10 e8 c2 47 36 00 31 d2 45 31 c9 45 31 c0 48 8d 05 00 00 00 00 50 <b9> 02 00 00 00 31 f6 48 c7 c7 a0 96 3c 8e e8 1f 45 2d 00 e8 da 80
RSP: 0018:ffffc900032e75b8 EFLAGS: 00000246
RAX: ffffffff816cb66d RBX: 0000000000000001 RCX: ffffc900032e7584
RDX: 0000000000000000 RSI: ffffffff817b2e92 RDI: ffff8880338ea944
RBP: ffffc900032e7678 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000007b2b R12: ffffffff81a96170
R13: ffffc900032e7630 R14: 0000000000000000 R15: ffff8880338ea4c0
 arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6670 [inline]
 kmem_cache_free+0x2d8/0x770 mm/slub.c:6781
 anon_vma_chain_free mm/rmap.c:146 [inline]
 unlink_anon_vmas+0x173/0x820 mm/rmap.c:420
 free_pgtables+0x212/0xc10 mm/memory.c:414
 exit_mmap+0x3f1/0xb60 mm/mmap.c:1288
 __mmput+0x12a/0x410 kernel/fork.c:1173
 mmput+0x62/0x70 kernel/fork.c:1196
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x7d7/0x2bd0 kernel/exit.c:959
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1112
 __do_sys_exit_group kernel/exit.c:1123 [inline]
 __se_sys_exit_group kernel/exit.c:1121 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
 x64_sys_call+0x151c/0x1740 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3b0dc696c5
RSP: 002b:00007ffe72640248 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f3b0dd6afe8 RCX: 00007f3b0dc696c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000001 R08: 00007ffe726401d8 R09: 0000000000000000
R10: 00007ffe72640070 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3b0dd69680 R15: 00007f3b0dd6b000
 </TASK>
rcu: rcu_preempt kthread starved for 10573 jiffies! g15885 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27720 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6960
 schedule_timeout+0x123/0x290 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x1ea/0xaf0 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x26d/0x380 kernel/rcu/tree.c:2285
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:82
Code: a6 5f 02 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 13 19 12 00 fb f4 <e9> cc 35 03 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0000:ffffc90000197de8 EFLAGS: 000002c6
RAX: 00000000000e7bab RBX: 0000000000000001 RCX: ffffffff8b7846d9
RDX: 0000000000000000 RSI: ffffffff8daceab2 RDI: ffffffff8bf2b400
RBP: ffffed1003b56498 R08: 0000000000000001 R09: ffffed10170a673d
R10: ffff8880b85339eb R11: ffff88801dab2ff0 R12: 0000000000000001
R13: ffff88801dab24c0 R14: ffffffff9088bdd0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881249f5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555787857d0 CR3: 000000003ccf6000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x6c/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x38d/0x510 kernel/sched/idle.c:332
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:430
 start_secondary+0x21d/0x2d0 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x148
 </TASK>


Tested on:

commit:         0f61b186 Linux 6.19-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102239fc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1859476832863c41
dashboard link: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=167a399a580000


