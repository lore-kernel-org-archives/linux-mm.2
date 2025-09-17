Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC9DCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7D7280006; Wed, 17 Sep 2025 13:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8829280002; Wed, 17 Sep 2025 13:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2821280006; Wed, 17 Sep 2025 13:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94196280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:52:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3206013B799
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:52:34 +0000 (UTC)
X-FDA: 83899487028.12.2F2A8A9
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73D1BA0006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:52:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3X_XKaAkbAMI067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3X_XKaAkbAMI067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758131552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=VKdkRqXOfqsbwonmuglVQhE0k2V9Y7oKPdzSUG2IaPM=;
	b=IRNjGdx5YPf4H6Y40fWOyHcue0enGPJ+QmLB8YKLMA9sCyfcl/Tx+9YpfTOcl1t4i4bIxv
	1I+A5DbWtHQoYHaxM8OOaRiG0ScfTkRMBsZCxSaP1GGUCCzXYvR2VENJ8HIqvMvUfDBggi
	6UmtWQrcc19LTxS9Ra26Opc+Z6mzInk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3X_XKaAkbAMI067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3X_XKaAkbAMI067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758131552; a=rsa-sha256;
	cv=none;
	b=cYdB0qWP7WVXT4d0QTIeyrz3DWe9bgVZcOb8tdo/5+H9RkWEFSNNIQBrKGKPM5cTR0I5Od
	/PB0b7eX4ymRWUZAQ3J7qxAWFDedwa6iDu9do5S6d6AKkF5C7Ihu0w0HVCMLMYF65siXWp
	jA7uFZhTs/GQluPjJrkIW0CLzBeRxVs=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-42407a5686fso112575ab.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758131551; x=1758736351;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VKdkRqXOfqsbwonmuglVQhE0k2V9Y7oKPdzSUG2IaPM=;
        b=bRUKxuJDUWrehMQkA7wKbFZePhvKeH195Lp9VWCMC8jCMUySrNdn8EqLb9+cMVp7rl
         s24xpiMQ6cK5WibuXNzMjVSuOGFU7dg1VnMASHW5/nYC0l0l/CJwo0Emo2ZUWTTPFje5
         am4xdP1uj5lwSRFAc841bsWu5Y9tGT09ne3BRMnRO6av/USdpQsj3UQ16Tpnd8KqidDg
         wwmZvYTKlAl3Entb8t9nxcLDRrRwN01v7YgTdPq72slKq2iLVlCv4KpeAzeJypSnPxau
         IExHi/Qz9J8tpIV3T4XJT+ar3CprsEQuf55zO5H5yu3f5cjksKBUjhgnUKU7ClgyauNn
         nGCw==
X-Forwarded-Encrypted: i=1; AJvYcCUqxfN3IGW7iE0dqIr775gyQRgYBTE1ZkdoJkyKT5ugAy3P0nTxxMAmAzslgxWsBZtv8/f28x7Qiw==@kvack.org
X-Gm-Message-State: AOJu0YxLjuu0eQkRMcmyGDaqVAfUZBvCAJxgJnwkg8ks7tETRb83vbtu
	qvt3aDC3E/eYqim/w/OvE1SXwUJGYyM+BrzQy/ipPaovk67bx5Qb8VP4D29jQWebGN1yebg7Ink
	wbpAMc9rLCK+jXopBKXjVDFaX1K/XOiq9CZSlWdEt2eLJ3tFi4wYn/+2ruFc=
X-Google-Smtp-Source: AGHT+IHdOsDwqHjB6bQUG/kICQZd+7SskboIoBWqqN9f4kYkBgFRUHhRIXiAAUNj5YsGa0rjMnjtQpfuqpdRaUoBNVXYO/BJMNPM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6f:b0:410:cae9:a083 with SMTP id
 e9e14a558f8ab-4241a4b998dmr44657175ab.3.1758131551065; Wed, 17 Sep 2025
 10:52:31 -0700 (PDT)
Date: Wed, 17 Sep 2025 10:52:31 -0700
In-Reply-To: <68a68107.050a0220.1f0557.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68caf55f.050a0220.2ff435.0596.GAE@google.com>
Subject: Re: [syzbot] [kernfs?] [mm?] INFO: rcu detected stall in hub_event (2)
From: syzbot <syzbot+039eab266c6321a174bd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 73D1BA0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sesnbc6kp7636njjnwry34indgmuejxc
X-HE-Tag: 1758131552-785768
X-HE-Meta: U2FsdGVkX1/v8vTUG7eHuwy4y8u1uReNIebxADu0r09pxRxh2ofyOJoywPaJH/yCLJsTxmlB6L8RAMsz0sfIA8bwvP+ZCNYG0bG6q/XhRvn6FCKJyKi5UN4ewbkggAalVpUwLHW30zhpR0odPjKXk2PZv3npqlLq/5snvEORTKW23loyOoMNghpPd6AT4b4zriMuZc3NR/i1v5K7dhZMYIFOR1cGuQpyWvorwFL28dyASvQWbkKVytdbJNDwoAsWsJ9AiI/WLnPKy01BCZiFPGZqM03+9mn8X+vvRRPDGEAbWlGuOLQ8PrkSbgUQ012cUKlX7AjHu53A+mBgkiHAwJK3YP1Q2XH1V4/6Xyu5O8WzlkJWsTwRqwvnBizym+7oHPLuUYMsES5vT+9lce4Jh6Un6d64kwNVmUpp5mvNuQTzHWZi5Fn3sA6ETuqRxLeh5AuNGopvCOx2vRACjaWo9F9rbFKuB9KgfTdIVQR7ujsKbjR0dBqwldS/jArRY0mGZaWPu7MhjC+e8XijzuH6aKKsXdkVspsmze7cAKCUfNBTxSErYmjdOAjBh3JlDEp6PMMH1uG2IvX78g2lCfTF7lwFQgm998Mnk5Qsu7nsmWCINCCF6khh4bgbW3DDa+Dc/H7XgnUFkgnZNv9xVTA9xs8a9UntuXPtrWKtvr3FpWQUYOAeITxH/Rh0Leepj+pZKYYGwdtwjvkPgK/2SEWDEo9gjNnmdtXmqi//J8fxd6mOdYf7CdYUdRkAHQ1eZpcQeuVZWYfJzmc0nUjNm4jgMNMUXRmgO9dMQEVtpYmax/xRz0XFeCFeAvZ1vxgDDxn+dHQJ5UJabk+i2RX11SrAQgfVa8A9xSBSHirHqpKDcWKPLFtw3FXiRHd3FsODuFV4fvFc6g4dmdMDrw4R8xKUIfHgx7gF1aeN9lhTw9onqEMj9JZ33c/piJU1++XpJbwwKScbmhHRt3OQGgMiZoi
 MqXxeBBO
 IrYPRo/KgQFCIHHPEcjK6xfU5dzE146DBYTDiszLC6aEWjdHX/0HC7jPhori6oE7zEdV3vA83/NkscZ1z3EMGxs+mWTPqBozYw3aECcJqhyg42YH0AluilhRe9tA7h9/3M9OLAQjDhT06H8UHFa7VcDWYHX7UqbWsn4AVgfk9IEitV25O1GgMrZ/ECtOvyU/JHgHm+uLzcUVDq7nJxpNFI6jaF4mv8uOSH5Z3j4ZT5sxWRYU8cQ/prhAUYD8K5yKJeIwlebtZzkvV8WWQTR0TSwIOG8u4tfweBdcugmkVrgZArFTvd7eMZKPmARaAVgzIeg8MCTkx3Wk52eOQuCbhl1sW8LDAbdS6ZfwEQhAX8hbSXI46EajL6yLGHsrJi1EL9gHRzJnSp+de87gSofmuYzeNPga2pCWcCMpdmqwM6ZXv34CTvKarvsBXxWIZ3ZGuLhQyLwpV+SaOXgjwqAjTIFwzn231VOr0JmZFqhySkBUyrG0YjcFSWylT1YAu8Eab/SpBfs6rw5i43KinIll1UkBmcnF8f7nFlOu2UmBQ6P5nAaPzhr7+ZGMbzoDA8/eQIWDNA2nRDoV/x2W1qRFqWcCXSjWWssSg1xOQNGXZgAX3C8ZiPINfq0bFxhlyOmriXV3wOXquzimF3flP+Uqq6oJ1svSWKZrrdY99t1BkgmS+iRpL9P9Z0CVmK07fsBTyB85u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    5aca7966d2a7 Merge tag 'perf-tools-fixes-for-v6.17-2025-09..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13e28f62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f01d8629880e620
dashboard link: https://syzkaller.appspot.com/bug?extid=039eab266c6321a174bd
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126e9f62580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178c4c7c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f191b2524020/disk-5aca7966.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5aa02ba0cba2/vmlinux-5aca7966.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b9b04ddba61b/bzImage-5aca7966.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+039eab266c6321a174bd@syzkaller.appspotmail.com

yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P976/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=9573, q=31864 ncpus=2)
task:kworker/0:2     state:R  running task     stack:23864 pid:976   tgid:976   ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
 irqentry_exit+0x36/0x90 kernel/entry/common.c:197
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:deref_stack_reg arch/x86/kernel/unwind_orc.c:406 [inline]
RIP: 0010:unwind_next_frame+0x15f1/0x20a0 arch/x86/kernel/unwind_orc.c:648
Code: 0f 84 b5 ed ff ff 48 89 ef e8 0b e0 ff ff 49 8d 7d 40 48 89 fa 48 89 c5 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 <0f> 84 cb f9 ff ff e8 f4 f2 b6 00 e9 c1 f9 ff ff 48 b8 00 00 00 00
RSP: 0018:ffffc90003c7e6d8 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffc90003c80000
RDX: 1ffff9200078fcf1 RSI: ffffc90003c7f688 RDI: ffffc90003c7e788
RBP: ffff888022a87000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000006 R11: 0000000000051787 R12: ffffc90003c7e798
R13: ffffc90003c7e748 R14: ffffc90003c7f6b0 R15: ffffc90003c7e77c
 arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:330 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:356
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4191 [inline]
 slab_alloc_node mm/slub.c:4240 [inline]
 kmem_cache_alloc_noprof+0x1cb/0x3b0 mm/slub.c:4247
 __kernfs_new_node+0xd2/0x8e0 fs/kernfs/dir.c:637
 kernfs_new_node+0x13c/0x1e0 fs/kernfs/dir.c:713
 __kernfs_create_file+0x53/0x350 fs/kernfs/file.c:1057
 sysfs_add_file_mode_ns+0x207/0x3c0 fs/sysfs/file.c:319
 sysfs_merge_group+0x1aa/0x340 fs/sysfs/group.c:376
 dpm_sysfs_add+0x237/0x280 drivers/base/power/sysfs.c:704
 device_add+0x9a6/0x1aa0 drivers/base/core.c:3649
 cdev_device_add+0xc2/0x1e0 fs/char_dev.c:556
 evdev_connect+0x3a4/0x4c0 drivers/input/evdev.c:1383
 input_attach_handler.isra.0+0x173/0x250 drivers/input/input.c:993
 input_register_device+0xab9/0x1180 drivers/input/input.c:2412
 usb_probe+0x10b2/0x17c0 drivers/input/misc/yealink.c:928
 usb_probe_interface+0x300/0xa40 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:581 [inline]
 really_probe+0x23e/0xa90 drivers/base/dd.c:659
 __driver_probe_device+0x1de/0x440 drivers/base/dd.c:801
 driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:831
 __device_attach_driver+0x1df/0x310 drivers/base/dd.c:959
 bus_for_each_drv+0x156/0x1e0 drivers/base/bus.c:462
 __device_attach+0x1e4/0x4b0 drivers/base/dd.c:1031
 bus_probe_device+0x17f/0x1c0 drivers/base/bus.c:537
 device_add+0x1148/0x1aa0 drivers/base/core.c:3689
 usb_set_configuration+0x1187/0x1e20 drivers/usb/core/message.c:2210
 usb_generic_driver_probe+0xb1/0x110 drivers/usb/core/generic.c:250
 usb_probe_device+0xec/0x3e0 drivers/usb/core/driver.c:291
 call_driver_probe drivers/base/dd.c:581 [inline]
 really_probe+0x23e/0xa90 drivers/base/dd.c:659
 __driver_probe_device+0x1de/0x440 drivers/base/dd.c:801
 driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:831
 __device_attach_driver+0x1df/0x310 drivers/base/dd.c:959
 bus_for_each_drv+0x156/0x1e0 drivers/base/bus.c:462
 __device_attach+0x1e4/0x4b0 drivers/base/dd.c:1031
 bus_probe_device+0x17f/0x1c0 drivers/base/bus.c:537
 device_add+0x1148/0x1aa0 drivers/base/core.c:3689
 usb_new_device+0xd07/0x1a60 drivers/usb/core/hub.c:2694
 hub_port_connect drivers/usb/core/hub.c:5566 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5706 [inline]
 port_event drivers/usb/core/hub.c:5870 [inline]
 hub_event+0x2f34/0x4fe0 drivers/usb/core/hub.c:5952
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c2/0x780 kernel/kthread.c:463
 ret_from_fork+0x56a/0x730 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
sched: DL replenish lagged too much
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71
yealink 1-1:36.0: urb_irq_callback - urb status -71
yealink 1-1:36.0: unexpected response 0
yealink 1-1:36.0: urb_ctl_callback - urb status -71


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

