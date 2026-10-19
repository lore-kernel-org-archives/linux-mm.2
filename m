Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23655CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E006B0160; Mon, 19 Oct 2026 03:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE4F6B0162; Mon, 19 Oct 2026 03:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F3A6B0163; Mon, 19 Oct 2026 03:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C36B16B0160
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:21:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58EE6A0675
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:21:38 +0000 (UTC)
X-FDA: 85338530676.16.4344BFF
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by imf07.hostedemail.com (Postfix) with ESMTP id 188CB4000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:21:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3_8TVagkbAD4x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3_8TVagkbAD4x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792394496;
	b=Al5/EsTbgf3Zt+FKZ5Yj8a33V47gmTH1x7Udm4VbQGJ2/HI4oxux1QhO+sdqa4xQv+a1WU
	nNLM6fnfJWly9mmuixUKlClYR/xitr5MtuWRKehDzdF8n0utH5d/Qoq5QENj3kQc1reQ7B
	0besQImie4tLTkK04I9uEKmf0ytT/s0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3_8TVagkbAD4x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3_8TVagkbAD4x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792394496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=OJ7gNhisstK80w1yLXNMpjgzLEQFy1c/FvTLYsrhiV4=;
	b=y/y6O3cbR4RCdAx9vuYnKgh13OP5StvP7K9aZtX89a6z6DJLUlBQYYxYv1Jq4vEhj1e/Ql
	pEADNVsaaZrzXkjPxfXdBm3zzME696cRL+zfFtduJfTEI5CcN/SZTyVFNga4qyBWtg3GLE
	7d1H7WE+JX2tOZvd7QNkukqMJcbKdrQ=
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-44899f99756so3802259fac.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792394495; x=1792999295;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OJ7gNhisstK80w1yLXNMpjgzLEQFy1c/FvTLYsrhiV4=;
        b=n5XA4f+lstHC5XKCN7ehR/1q4cTY6qUe9f28rRE0BZByiYW0yKOW5T7v7BcFt4oEYF
         WEytTPZjtIzeeNfKz72UDoHX519r7Dxoyb393GcbQHVzJZifFcNaLahc3PCxLN28Fj8P
         O9J+gxWJ0CdneyxQpozyOvMBCL4jdJNJIRPmVqoz3YBkH2dWAqdOW/4bcByOohh6nwWq
         ee7hUSB2XZuVyN6IdYaUQ5LZB20DG4Vnh3g2bnIWTKf053oN8RbM9IP/B0qn0xTP7BPO
         h5kAvYprR3j6AjHasPazDKwfhor9AvFgKlP2hdUPka5JQWNsLgtJzzErzYestFrNnOcl
         LXzw==
X-Forwarded-Encrypted: i=1; AKwUvBz7mrErLu5E6ga6y50CjM1RZG/rdxOx+hgPmEH9LViUy39RiKHJDDWBfhorWXx+0/Y6MgQZcuwuWg==@kvack.org
X-Gm-Message-State: AFq9FYIAblB9C1i6KmNlw9HF8U2ODzoTxsB85DR45P38vAT29T1nP7JJ
	FRfF/oolheSkP+JpszhFkpITqLWytxlfUV4gqUMPs3WOOUCnWVObSVke87zIVbVmT1Vh9AtHYQT
	TYNEBm5O1uJ2Ji1nmX2mOhOy8X0JNBYvfkj5z9ZIMr94RhaAzGsfxbWQcVSI=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fde:b0:4d5:295c:a82e with SMTP id
 5614622812f47-53cd88053b6mr5513312b6e.59.1792394495177; Mon, 19 Oct 2026
 00:21:35 -0700 (PDT)
Date: Mon, 19 Oct 2026 00:21:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad5c4ff.a6d1a155.34a93f.0112.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in chrdev_open (7)
From: syzbot <syzbot+899fe9063fef5929bd90@syzkaller.appspotmail.com>
To: davem@davemloft.net, david@ixit.cz, edumazet@kernel.org, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org, oe-linux-nfc@lists.linux.dev, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 188CB4000A
X-Stat-Signature: xsncw9npzyfiw4pdgi4d5rzynsakmyjx
X-HE-Tag: 1792394495-604390
X-HE-Meta: U2FsdGVkX1+h8/hZ3Na//zIHruhbkQy5ebcEVN7UdXyq4Gr7lVOx83zPSVzdbh1nJ4uZBcM6z+UlUyF/I2IFwTrdb6n/ZnnSXQZmsci5UlpuRjFBq7uMY5xXgrmxKinvecrv0SzVsr07IwNWznMv8xCKWi5FrBtspI0XvGo2us48bmFabGlRWDDcB9Jh6mGMujXsxaAK3eFw6GsQ+adt6g69QvULsh0akr8J8SQUtsXwa0HybTz31AuwXSyFtGAr5K4vzyYp1YsklDIZ0ZDl634xqPxWTVOk8cBm0J+/5Lna1GsVrHX5++5WDdLLNdIDF6W+ZgLm1PEJywigoFNsXg672O6zqpuBOQncanNntJSXMhAiKJJ+Fvw4ls+zSRxAUJl7S+PWlaLGYRYQScQhySngB29tI5oeyGcq2czY9AvJzmM3MND6dZOCB7FfCvPj8DLdNd7Cun/LGb122kBlwFx9QrACGArueiqLR21XCQ6Sl/27kWpUqV7M1LBrgtDdH9xnDpS5QWw7HA0F8A1qaUQRetlusobHOfFLpIlxmb82mMJYdHaYpPqvgTOpgszIj0EIsAfm3/LKaKHEu3QZuEK8RcUCjLbqeR2bow1KDOK17nw+1LbM5xvJTxM2uC4PPvONs6ag5J8gKaR6oAN2ON/p1CAB5EXyNkgRHeWk7pxAHqaBf3ByF6qVMQ/imwWiqt2mWHx4fsJyrYjfafaAucRz+pRVaFkGin6Y+ZTc3/VwJwUnHkKFQ/aqAZoFpFq9+naJzscJsXpRCEZNRQLuSoysuL9K+c4u/zA1zItd8CRLkiNhX8wOCzpDarvkpmGEPZTzpAYoIZiNajBLFfj30SPPtCgUjjr4xoqLpKjQ2ve9MAPGZ5vfJAI+DkBiimisWTr0Fmp+DUKZw7y/2U/2al95UCZEYahiGHADkr+BAsQBP06z4m7Zk5XeV0rj8cWUHRrF70EZhX6IgUMBvRX
 LzPZLAsF
 iljDKoQD83G4U98ItDQjqdi2vS70fUE3LQOwLBnRFG7onsKTTYw4MUftub66dEtY/0qM4lQQZGm7rWhHN3XrJUvVqJh3pncrRVnBJaK2E5i93CXI87Nu30ndK3CsNfBcIrnR2xYWF+8lBRrIJA25/U6YtrawTcLfK0/Vpl9UmISDAI1VpUkMVMd2vvg/PTokPp0Rb9QoDRrZcTa0qOAalQLHZsYvN9w40Ie43LbkOZHo7Qbs7XB861FAky6Jpl+tRPyZ71YBOi+tpWFzRw2djBKIIrYZm/UubkaJ27h0YSvaEm/ZYPtNs2miqefIm7bO/I1Y27xyWwNaWHXhA6Xhjn3OVL/q1wusGby4arefuBwvoHrOBhE6o57t6R6XXUWBfVb42kodI5l59MBumJmA+l0QvS3rffe3v7RjQkeuOXqHBDivQPOKRXfn8m7r4+8S7KwnkzjLjr7b+hhAuvJL0hqsqDAF8FEu3KQtZ2Or5JMzN1UVJZhXeqEDUwNvgdZXbpsQ3Jam5DAzQLZ2gfrSjA+IJZGLkfZOMQJv2myiIAVX14FsoBnL1cfrkQBYkSzvxOjAsU6PNbhBbH1TyNtt+efniBmu/Pp/m3Mi3zpLCb4Cd760PLtz575y7LdzPobEdOHufjhGIvjaXxU7LeMwCZ4ZYvGOHgvrN70ZNCpQbplzRc3z4MRjzFsj4G+HxzaNZmlSw5XIK4hkbrvkTlDyKw+q3ks3HpuaYKjulW4LCgrgeZ7eXhcFqZqib+F1fHTTE4++GJ2eJzEfHvYXPgV7L7iwvNzppHC39YptgInnHqGmuQ5OCTyf4OiqAy9kDRvnBFbKWWTXn2ZoD5qHRXwr8aMNvPU6IWHZogFSv1mSXTfuaF5tButnDdvjmoKAXvX/WN+XdKkmxWSBwG59wX0pRgRkA/yfyACDVDsJO0PGX9r8CkQ2JlSeFyHhA5HYKUAtZGKwmqK6IdTsX4mA60vaci41r67VX
 BgG4Xxec
 kx+k3VO5WqCzPOwHuaEUbXEz542AMB/3AX0U4QWJo7QHcGkujVvF1g/Kqt/zMut83n095Cs6BzVzjcso/yVwl3ZmJ6NdAJ18wMsbscH0cliZ6pjYyw4Y4oofkOQCva6IMdZfGt+17VJEGhSrWsjcUKXgteRNzSwplPPwUTJSHcmtoj8z9HsXPdXagEFRFoXw2W6TFQYJuBNJNIM3kmfggbpEUyXjFRH/DXe2DZEQ9VC55LXpYbZ4NKalO+FWyaurO+XLAh2P8Kpk+To9Ejyhjlo5LglmkZ6JzeHmOsxnefLmbIHXTirgYCI+SGe3VQhGcbNYiYkQB5+nnGjDzsEIU5GeEj60O14YgpuM7Y9awY/sJC7w4H4JDQ2rKc+x0cgYWlYlpTByHruBGYLyD8MYkbNf4ukOq+gpD1bUD3xel6b++JiHlObIrxBeAea93NyxTBEZj3gWFwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    24a19b953e2a Linux 7.3-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16656f15580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=129d675874dbf896
dashboard link: https://syzkaller.appspot.com/bug?extid=899fe9063fef5929bd90
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c36b6926be3e/disk-24a19b95.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/413d898eaf27/vmlinux-24a19b95.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ada3e66b70fc/bzImage-24a19b95.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+899fe9063fef5929bd90@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P12985/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=76689, q=368 ncpus=2)
task:syz.0.1823      state:R  running task     stack:27232 pid:12985 tgid:12984 ppid:5600   task_flags:0x400040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x1259/0x6920 kernel/sched/core.c:7284
 preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:7606
 irqentry_exit_to_kernel_mode_preempt include/linux/irq-entry-common.h:468 [inline]
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x205/0xa10 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:unwind_next_frame+0x17a/0x2090 arch/x86/kernel/unwind_orc.c:510
Code: ea 03 0f b6 04 02 4c 89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 24 0a 00 00 48 89 e9 41 0f b6 45 35 48 ba 00 00 00 00 00 fc ff df <48> c1 e9 03 80 3c 11 00 0f 85 01 18 00 00 4d 8b 7d 48 3c 01 49 83
RSP: 0018:ffffc9000679f268 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc9000679f320
RDX: dffffc0000000000 RSI: ffffffff8c625500 RDI: ffffffff8e6af928
RBP: ffffc9000679f320 R08: 00000000c7ee03ff R09: 0000000000000007
R10: 0000000000000200 R11: 0000000000000001 R12: ffffc9000679f328
R13: ffffc9000679f2d8 R14: ffffc9000679f30d R15: ffff88803569cb00
 arch_stack_walk+0x94/0xf0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x22b/0x6d0 mm/slub.c:6802
 apply_wqattrs_cleanup kernel/workqueue.c:5592 [inline]
 apply_workqueue_attrs_locked+0x96/0xe0 kernel/workqueue.c:5590
 alloc_and_link_pwqs kernel/workqueue.c:5731 [inline]
 __alloc_workqueue+0x9a7/0x1950 kernel/workqueue.c:5984
 alloc_workqueue_va kernel/workqueue.c:6033 [inline]
 alloc_workqueue_noprof+0xc7/0x130 kernel/workqueue.c:6049
 nci_register_device+0x394/0xb80 net/nfc/nci/core.c:1269
 virtual_ncidev_open+0x141/0x220 drivers/nfc/virtual_ncidev.c:153
 misc_open+0x26d/0x450 drivers/char/misc.c:163
 chrdev_open+0x234/0x6a0 fs/char_dev.c:411
 do_dentry_open+0x6ab/0x14d0 fs/open.c:996
 vfs_open+0x82/0x3f0 fs/open.c:1101
 do_open fs/namei.c:4866 [inline]
 path_openat+0x19fa/0x2440 fs/namei.c:5029
 do_file_open+0x20e/0x430 fs/namei.c:5058
 do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x12d/0x210 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f697c79e1d9
RSP: 002b:00007f697d6ac028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f697ca25fa0 RCX: 00007f697c79e1d9
RDX: 0000000000000002 RSI: 0000200000000080 RDI: ffffffffffffff9c
RBP: 00007f697c835888 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f697ca26038 R14: 00007f697ca25fa0 R15: 00007ffc729ea0a8
 </TASK>
rcu: rcu_preempt kthread starved for 10502 jiffies! g76689 f0x0 RCU_GP_WAIT_FQS(5) ->state=R ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27560 pid:17    tgid:17    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x1259/0x6920 kernel/sched/core.c:7284
 __schedule_loop kernel/sched/core.c:7361 [inline]
 schedule+0xdd/0x2c0 kernel/sched/core.c:7376
 schedule_timeout+0x127/0x280 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x1a9/0x8f0 kernel/rcu/tree.c:2122
 rcu_gp_kthread+0x17a/0x220 kernel/rcu/tree.c:2330
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
Code: a7 96 02 e9 53 50 03 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 93 48 17 00 fb f4 <c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0018:ffffc900001a7e00 EFLAGS: 00000242
RAX: 0000000001ea4ae3 RBX: ffff888020684b00 RCX: ffffffff8bd47235
RDX: 0000000000000001 RSI: ffffffff8e3e3486 RDI: ffffffff8c625580
RBP: ffffed10040d0960 R08: 0000000000000001 R09: ffffed10170667bd
R10: ffff8880b8333deb R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 1ffff92000034fc4 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888122a46000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f38c4787800 CR3: 0000000036854000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:62 [inline]
 default_idle+0x9/0x10 arch/x86/kernel/process.c:768
 default_idle_call+0x6c/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x3ae/0x5b0 kernel/sched/idle.c:355
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:454
 start_secondary+0x21d/0x2d0 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x158
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

