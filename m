Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B12E3CA1013
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 03:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5946B0006; Fri,  5 Sep 2025 23:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DA16B0007; Fri,  5 Sep 2025 23:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2B26B0008; Fri,  5 Sep 2025 23:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 869BF6B0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:05:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A52B1A040E
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:05:34 +0000 (UTC)
X-FDA: 83857334988.14.3EF6233
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6EFCD1C0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:05:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3-6S7aAkbAIAw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3-6S7aAkbAIAw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757127932; a=rsa-sha256;
	cv=none;
	b=TazHDcByA1+dfGYhTs9ecKp981kbN4/JfgnxOE+Qis+6bTnG1KajCeHkbHCsXJJDELq6dc
	DC/KEdZ7ib1bbrfdmDuudawo67GGBZEPx4GBg7Qw0rtuVNkvmILVirYeepk5gs2WUwcEY0
	wkgD4cM0sku9dUsjp/xAl3G3WHHTys4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3-6S7aAkbAIAw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3-6S7aAkbAIAw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757127932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=dhbeaXnx83Fb2lfzAWcOqLQld5cNabOaz6o4t5ofhkY=;
	b=JemjuhCA4nrOPVahRZknIeCFAsxOR90WQ/Tt4YYtLZVpc1qvu5GxiIwfduBjO4FjnKPQzL
	92+w+Yfi/SbJqVsXj7DBCYufsTc3+4+P0LZctdAvCSFQ6p7vcYnqZvHwR+pIm5sE7Zpy+w
	veL3EEWXgz1ozjaSuYiFaQBesArKy2o=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3f761116867so51100735ab.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 20:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757127931; x=1757732731;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dhbeaXnx83Fb2lfzAWcOqLQld5cNabOaz6o4t5ofhkY=;
        b=a2K5VaAnPFaDHQaeMVWGvulgdVz7xi3VRtsngHCJL6snctOvAdI/G7Spnau7/Db7/u
         Tl542+imVA07iR7ZONBITRcW4qftRlUMqxbzSfZYUExuchstUch8xbGwLSlUHMHbuRwI
         iqKFfkaPUm3Zb+qd7dTUxVblMHm1rjZbdWK9rAlNyvByex5F9BTiFNJvvFzOxUFvoc5X
         mVmg48ilEnK5A0OBoH2IFUjyhLKgCaNypvYuguBOjtnRtoOrkulEvJhxg7OJfqhXpMwP
         uPVbLRnXYCp8FMSoV2Aia/+TVbWxM0FJ0RIrEu6vkJKKLD576qz5xPbz6uvMI33YSfXF
         azuw==
X-Forwarded-Encrypted: i=1; AJvYcCUKiKvP0KEXCXy0R93bxdYtyO3sz3KhOTAeGDjD0Yv/IMZ9sPQKHPNGZelzDqCtht4I5k0568Ylag==@kvack.org
X-Gm-Message-State: AOJu0Yxz7Tj1GPx0XyNIASkkuZXAtBFyFLW8UUQ4Qxv0wOeaA4RnRs0Y
	Q2AXvRkRX/voDPf6lxypU2iZz8Qtj8ITIYGHml3Cqm50UVQF5nr325DrHJGLMF4Zw/OG/Vc2VgI
	yvgbyaeIQ33Lnl9J9AU2+4rJUWCNIM9SNWpWlGrF3wb2v6uuzlvQ9OAjbtiw=
X-Google-Smtp-Source: AGHT+IHbLSjCSpzMa1FxgbReZpAP0Xo4NYYl3cezd64zahz4WtpKwVLFOU20wOS1n20JLubTlkCny/zOU5yqSvW5GxCYCiY1+Ej0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a61:b0:3f0:1ad0:2c17 with SMTP id
 e9e14a558f8ab-3fd8981ee41mr16611315ab.23.1757127931615; Fri, 05 Sep 2025
 20:05:31 -0700 (PDT)
Date: Fri, 05 Sep 2025 20:05:31 -0700
In-Reply-To: <68a68107.050a0220.1f0557.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bba4fb.050a0220.192772.01a4.GAE@google.com>
Subject: Re: [syzbot] [kernfs?] [mm?] INFO: rcu detected stall in hub_event (2)
From: syzbot <syzbot+039eab266c6321a174bd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EFCD1C0006
X-Stat-Signature: ekiwbhbjxgn7ee59au56ah61ud4r8imi
X-Rspam-User: 
X-HE-Tag: 1757127932-673078
X-HE-Meta: U2FsdGVkX1/T/blAiGtOLlZcRZiZsw+0i1ttoTAROwFMP9DxYigtGhuP8ZV3r7YaYvg52TZTd7rV44iKTsQJVaDXGG/HUBcE1RKAndIH/ilcDmH0NYwXt2v5N/RsgboPJPYScbAUmjv+V9+6+nUE+YrWPNudYLZMocUOuYvO08mw4lC8kkBUWLZckZcbDVEjZU+8tj2K+Feaeje3pR1hBy9ZJN6eyPI+BeWT7mztde6WnlJqC/J4FFErQjWyKDqZ7814C8B1r3IoS7wsmwTiKf6DMNByIQ+Na4OWRHCM/FnsIFHtE1Z4hKHTBRkObvZ3xY3c+Gtp99xAjxNwqIu7q7Nm7VZlwVgbYUegUoNAsfuoP0cyr9K2ajsIpMA9CUmxVhrxPuKtL46VY+PlQ9MTGA3X5YQPCUcoFA+1WY1nckvaxtSgl+dWKHJBKiX4B73duIWdFyMytWvJKAvz7qz9xmbATIPrDm+p0zKWRcxHkgM2QykrpDLBFi1xxRltL0YVwKNno0ptsKMMV+0WUNHf3KtkdYKWaCjz4DGCqlD33vZPs8wOkqNNIUj0eQs8HCjToadAf/0BDrUCd5TBARBS6TDZI7vj5FvAaSJ1Y7+dxGQYDHfht+fjapO/gqdpRV6OK/s07v1pHSOkRukIJiMan4FF7+C9q6IH6L0AvLILST7hIPQlwRYqd+mNhab7qvHOsYdwmEb/LPM+KpHDj4MKDe2CnHUdn5za0WhtU5StEhCkQffF2Z0B5+3pDh8d3wjkZ30NaM+fpSuEBwgD/D0y9haehk1oH1PMCeldVEG3A68e2WLiMknm21Vto/HLV34M6EGHmcA43MrqC8feduN1NOP5TXMok0ZYOkevrVEcawA9cadj6xFNoc7jDkZizUk8A/CYvSKTDd3+KeUNkWhibC2ZD5fdnh2tMLCZE+R29pGogTSd+0yZUWW6ki/ueGGC8Ej2fD6S8JIMeS4lh6b
 HL7njHRB
 j8iyVvI+370W5g3O8660AOuYLcG5/SpguYwksFnUGqOQ6+0zPDY9kTkUnGcayi5NuMt0x7HhueXpqMuDj8oMZgxj2nWqvi8cFC5InmttxpdN+VGzwY5HqTO9A9cogax3OyMfV7fkr+hnQjAAQ34OovPIodNwbjMb5eC6u1fPfW+p82IIQgrbWeOuXa0ciSdlSJNFXzKsh2C5QIduVCBt+bTB+QW5Z30zXrTExzlEBRFrD9Wrdak1HazGoyHl3rSQKHNUqEeUZnV5bK9telM/2MsmldBiCOQ+ZC6CmvWdFlhAcNkt1UYqWHAHcH21Qaa5NaphXmXvsdC7pD57qnfVUj1JZqGJRcX33b7m0PRCzggqtuZZofAlmtu+8x1gfONjom7LIuDkGGuI6UGynhPuShcnPBXmC+kAIhfZd2+yR8VaoxNwd1HFvdzQzKSWA4IzaHtzhPmtldaB3MdadftWcyLusMqVek1lWTP4hNlLCzvtOIuq4EqvWHhMUJ5ygqbTAFkVzaRMTZV0gYV8oOTSppd4xyKQ5ifmk6sDtEiKgi5WbNlEmDOz4VoDAgujc8zeEKsUiRaocyVba3TCm19SUIxQGmWK95Z3LCGPWGrRXHJ6fJNa8GsgIYwgt7fYxVdLqWk7RBx6qXc6RgX4GqQonKM2kwssm7sTzxJF7zGuNBYOEkLaFvnUcyTy/iJFVUQg7YF5QwZhaY95WXu3RW8jtpWCcPG03vsHEoUSrj5H60ng1HR0wf6EfC34mtnN8yk9ORAMKmcnmCuVDEdViVovNXyzYWUns7uxS8n3z2rXYHAbVRQps29vu73h3pvKsdgevyayv72BIPwIWg1gHtKC/1J3mgWL42Ui9E7cBOgffPklsnZ+LBHU7IsA2EKrhzznbCPA8iTANG2gRDpywczb5Rtdt70k+tSVqJQHyrz3FlJ7QeaaDMdH9JDIxqY6zqXJDy5MpGlFWjTfgG31hhI7G39RUNnE7
 5G29bpx8
 YUUkp9MWeg8smaLDp7b7ejy2DhtnRSTMMGcp5A5wG2w3HgzOSzLJnqqw0M5IMK/T4QhuUUgl9Pj3OhIdJFPjnVHrkP9oinOUgob0KtGcipkUz7D8Vr6jokaVIluQbCF/mPzCzrEoknNv/2dWUv1kd2Ld1cPTXxcIF4JPd7XTLSVe2nHKdU3Z2nQGTYnvwpRVd/pcGzwrA0DHbc8vWf+Mxu4N48FeTNf2xsML3sQiq0zlj0bOpV3OIq7eyxDbleq1Atj3FL3KoYYPjskFZJuyHF5kbvCciF6A9jOnBBVpnVJwMgS/Fz3atkR0Qp8GCFIODSVt1dy8hvfnHc3en0/sa/NtOmy2IoRhswg9X4m7uvYPUEEztsSHDOzZJz5j1i6amagWemJENDS+oZWldoGqqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    c8ed9b5c02a5 Merge tag 'drm-fixes-2025-09-05' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11bd5312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4703ac89d9e185a
dashboard link: https://syzkaller.appspot.com/bug?extid=039eab266c6321a174bd
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e32962580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/692cc72cb948/disk-c8ed9b5c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9b6b3b9063a8/vmlinux-c8ed9b5c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c1e4adfb8df2/bzImage-c8ed9b5c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+039eab266c6321a174bd@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6120/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=10197, q=29931 ncpus=2)
task:kworker/0:6     state:R  running task    
 stack:24872 pid:6120  tgid:6120  ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
 irqentry_exit+0x36/0x90 kernel/entry/common.c:197
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:kernfs_root+0x189/0x2a0 fs/kernfs/kernfs-internal.h:76
Code: ff 48 c7 c2 c0 58 c3 8b be 4a 03 00 00 48 c7 c7 20 59 c3 8b c6 05 d9 b6 32 0e 01 e8 a1 9c 36 ff e9 c9 fe ff ff e8 67 b2 5a ff <e8> e2 ec 3e ff 31 ff 41 89 c4 89 c6 e8 96 ad 5a ff 45 85 e4 0f 85
RSP: 0018:ffffc900039cebe0 EFLAGS: 00000293
RAX: 0000000000000000 RBX: ffff88805d1fd0f0 RCX: ffffffff8260dac6
RDX: ffff88807be50000 RSI: ffffffff8260dbc9 RDI: 0000000000000005
RBP: ffff888074793960 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
R13: 00000000000041ed R14: 00000000000041ed R15: 0000000000000000
 kernfs_new_node+0x11f/0x1e0 fs/kernfs/dir.c:713
 kernfs_create_dir_ns+0x4c/0x1a0 fs/kernfs/dir.c:1083
 sysfs_create_dir_ns+0x13a/0x2b0 fs/sysfs/dir.c:59
 create_dir lib/kobject.c:73 [inline]
 kobject_add_internal+0x2c4/0x9b0 lib/kobject.c:240
 kobject_add_varg lib/kobject.c:374 [inline]
 kobject_add+0x16e/0x240 lib/kobject.c:426
 device_add+0x288/0x1aa0 drivers/base/core.c:3627
 cdev_device_add+0xc2/0x1e0 fs/char_dev.c:556
 evdev_connect+0x3a4/0x4c0 drivers/input/evdev.c:1383
 input_attach_handler.isra.0+0x176/0x250 drivers/input/input.c:993
 input_register_device+0xab9/0x1180 drivers/input/input.c:2412
 usb_probe+0x10b2/0x17c0 drivers/input/misc/yealink.c:928
 usb_probe_interface+0x303/0xa40 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:581 [inline]
 really_probe+0x241/0xa90 drivers/base/dd.c:659
 __driver_probe_device+0x1de/0x440 drivers/base/dd.c:801
 driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:831
 __device_attach_driver+0x1df/0x310 drivers/base/dd.c:959
 bus_for_each_drv+0x159/0x1e0 drivers/base/bus.c:462
 __device_attach+0x1e4/0x4b0 drivers/base/dd.c:1031
 bus_probe_device+0x17f/0x1c0 drivers/base/bus.c:537
 device_add+0x1148/0x1aa0 drivers/base/core.c:3689
 usb_set_configuration+0x1187/0x1e20 drivers/usb/core/message.c:2210
 usb_generic_driver_probe+0xb1/0x110 drivers/usb/core/generic.c:250
 usb_probe_device+0xec/0x3e0 drivers/usb/core/driver.c:291
 call_driver_probe drivers/base/dd.c:581 [inline]
 really_probe+0x241/0xa90 drivers/base/dd.c:659
 __driver_probe_device+0x1de/0x440 drivers/base/dd.c:801
 driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:831
 __device_attach_driver+0x1df/0x310 drivers/base/dd.c:959
 bus_for_each_drv+0x159/0x1e0 drivers/base/bus.c:462
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
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: rcu_preempt kthread starved for 2845 jiffies! g10197 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R
  running task     stack:27784 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:7058
 schedule_timeout+0x123/0x290 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x1ea/0xb00 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x270/0x380 kernel/rcu/tree.c:2285
 kthread+0x3c2/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 36 Comm: kworker/u8:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: events_unbound toggle_allocation_gate

RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x70 kernel/kcov.c:210
Code: 66 cf 55 00 48 89 df 5b e9 ed 56 5b 00 be 03 00 00 00 5b e9 82 fd 27 03 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 48 8b 34 24 65 48 8b 15 d8 11 1b 12 65 8b 05 e9 11 1b
RSP: 0018:ffffc90000ac7880 EFLAGS: 00000202

RAX: 0000000000000000 RBX: ffff8880b8442000 RCX: ffffffff81af8ea1
RDX: ffff8881436fa440 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000003 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffed1017088401 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881247b6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f829e1729a0 CR3: 000000000e380000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 native_pause arch/x86/include/asm/vdso/processor.h:13 [inline]
 cpu_relax arch/x86/include/asm/vdso/processor.h:18 [inline]
 csd_lock_wait kernel/smp.c:342 [inline]
 smp_call_function_many_cond+0xdfb/0x1600 kernel/smp.c:877
 on_each_cpu_cond_mask+0x40/0x90 kernel/smp.c:1044
 on_each_cpu include/linux/smp.h:71 [inline]
 smp_text_poke_sync_each_cpu arch/x86/kernel/alternative.c:2653 [inline]
 smp_text_poke_batch_finish+0x27b/0xdb0 arch/x86/kernel/alternative.c:2863
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 jump_label_update+0x376/0x550 kernel/jump_label.c:919
 static_key_enable_cpuslocked+0x1b7/0x270 kernel/jump_label.c:210
 static_key_enable+0x1a/0x20 kernel/jump_label.c:223
 toggle_allocation_gate mm/kfence/core.c:850 [inline]
 toggle_allocation_gate+0xfa/0x280 mm/kfence/core.c:842
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c2/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_ctl_callback - urb status -71
yealink 2-1:36.0: urb_irq_callback - urb status -71
yealink 2-1:36.0: unexpected response 0
yealink 2-1:36.0: urb_irq_callback - usb_submit_urb failed -19
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
yealink 3-1:36.0: urb_irq_callback - urb status -71
yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

