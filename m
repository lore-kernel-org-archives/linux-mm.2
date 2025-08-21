Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B5CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 02:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F776B00DE; Wed, 20 Aug 2025 22:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745EF6B00DF; Wed, 20 Aug 2025 22:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682606B00E0; Wed, 20 Aug 2025 22:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 582E76B00DE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:14:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80F5B1401DA
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:14:34 +0000 (UTC)
X-FDA: 83799145668.12.C6B4C5C
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf14.hostedemail.com (Postfix) with ESMTP id C35A9100005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:14:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3B4GmaAkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3B4GmaAkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755742472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=aQxHRgeChNTxbLV3131Rwb52VhDI/1dYJc8+5cwgx30=;
	b=MVi0ENA40PlxLhSmE4eHswVqWMulE9zL0PKnu+IzD2nq2EUrL7Ln+7jho08ORtjifId4z3
	RHy6n3jnzDH14mSV1N7WUmHdsPQ641yvw+tJnJy7tU5ixNGpuW2CZjSERHG9bpF/KJ8SDk
	doRbH7CLgyYhtwGTsaPjFWtKTfa8EM4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3B4GmaAkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3B4GmaAkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755742472; a=rsa-sha256;
	cv=none;
	b=D2OOAZ93hj3OutufXpK70ntgVVeBYnqdvHr6usUvq9nM/X5CRxhoMixLHqiaj84nuKfGtS
	CSWixgIoUhR5bJn5Qm8bSfIn2UWci1pyOwQmxj/eoIDvVWB3VunadiMG+6A7Yt1PoUgaCP
	qr49lqxIIKmewk6WwKsB7Uo9MvbUvmo=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3e6670d5bafso11650775ab.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742472; x=1756347272;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQxHRgeChNTxbLV3131Rwb52VhDI/1dYJc8+5cwgx30=;
        b=dILPrdewC6gJCMB+4mbAAty5rsAq1eAzuR8a4sAreLe75NTcrbinVRWYmYsX2/UJeT
         lRMbdT+X/YtTWCg1c+EZBIBKw4m4XAdbRRBs/i7wvJkI1k+6+SLssiEto7eoGQaxYc5p
         xOxeHoISImp3riPEajYvGGzcs7y7KPN5HBf4LddtRwQdQoSg3CrkVoZMNIXYzVevxHa3
         9BesrVMHaZsEOtIXHMdUM/hFK3yAeFY1tl9Z9zvkf7/mrTbbbpjgZerjJRwt6ic0OHa7
         KBWZEjhd3ASuI6skNF46ylxQDbaC+W7OOlabntnIaE9FGPgnGL292oFskf8XHBBis54i
         pKqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxsiljHXjQwwkVlf4yPH9cMQqOgGS+Kh4BbhL/5zjCReQeZY2fGbIMWZC+Z5xPi1VJPXrP8EmLrA==@kvack.org
X-Gm-Message-State: AOJu0YwXRiDUKxIWSeQaGWBzXyx3HlrxxvVmldeVw8DioD7cvUxwGoo8
	/2msWt1PhYIqvG9eHcIrdKUWOIXzjSZX91UPr8k89T5lJzUI7pv09U10yXPBgyPUuB60bymABoa
	1OmJSpIKF101QUCUNQOwFVIgEZuzHm55ynbLDzRyRGnib7ZOX3XWpZaHNZ5M=
X-Google-Smtp-Source: AGHT+IHGC44FrRLwYHhyTjthukMc8igcR3mKads8/zioUjdqWD2TAcdwPDOGULm4I7iJqaRzfo/oKWobKAXoZpW4bMxv5gyafIMf
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:158b:b0:3e5:8249:e973 with SMTP id
 e9e14a558f8ab-3e6d7b4aa01mr14110555ab.16.1755742471892; Wed, 20 Aug 2025
 19:14:31 -0700 (PDT)
Date: Wed, 20 Aug 2025 19:14:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a68107.050a0220.1f0557.0000.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in hub_event (2)
From: syzbot <syzbot+039eab266c6321a174bd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C35A9100005
X-Stat-Signature: 75kdofthht3oegyenfus8t9pu4u5twea
X-Rspam-User: 
X-HE-Tag: 1755742472-490811
X-HE-Meta: U2FsdGVkX1//+TtK+hnETVLSeBdg9attaPcJBOZmtP56wRnifYb+nI9xMcJfnIZwTQANK/R7I1t4eKZiA16YjOBR4G5Wr9RaarcCIF+I7M2kF4ysgdL/ulF1tvIbb5uMgLhvUZP9ABAsAuuSjoI9XW1hgXSZKyghbbuZgBOe+fgC73KkDXX29r+cTluCxCg8ZWBDLgQ7QYSvEE8av9nfl3+JVBSHsC9WiOgqfmpSClWycozwNlRidLo+jwHBcv0trPzNgnBgItwSEgHW+SUC+/iZ/0Ua7xqX/CezcmV7TMW4WWbamfSxZZtG7vD9+nUFz+VyS06kvi55McxxH/HPiwlmkbb/axj2aFz5P2Yl4nywyK11xvtz3ez8k1xa7o1sMYV4z4Moy+UYFDmlmtrMDQbUJTKf9RDBuPvAA+IepwxmMXmix1+VTmfV5VBqRAbGlqBVCNss3DmHEQcWtEtE0yQ+vdkMx2Q6zAaClRKaIK0C30kZIvBliOD2Prf5d4BoO5AuVlqrKxkN2hyU3OItq9LrQCcNJfmyBJJVYD85SryRbY+zpi4OGRGjn+b3rp42vLvDj9ML560QczFt1aJ3ldeyXRmGuAxhsgWwV6UcCyVGUFmMNMfQMrcBDYrbDhtFd7sZNPVHldCr30RLO/2lmX1lrDBAJQWireWV0AiK9F+1JVVEtCGhS0Wm9oAuUL/KrbQbbU1IswzsKBgaGy1gZZMl1/vw78bO9m3lz/hECKlfOgCOOje8CIIlqz1+d8vU7kEQuloP4dtGigi9yzI9lZKwO+aw8JI+MZfbYr3Bj1r28kyaRR8dDhjCqpVNNwh+EYHEDg4cxNAOO1B9sdgZGsJJFhfC4JFeA7aU0dH1yOPuIBRlrH4Ps30j5bavv25AKJtNNWYXlIjyrvW1DJSbqghGFGwzkJZEL4Q0xffVevcjCQILhtLSn97ddamt4Sfl0q80kt+8WPlj2cQ5DTb
 EkugMzDx
 ibYA7WRwK2nec37K6Kh0ODkw10Jj59j8rJq5Jb4+wxfRtVg5eo/0TaSRhVtIXnN1rJ4g0Nkd24LcW6Sd1pk3hCECUPcP52Xa2R98VObvMsV3dtylurNPyjn9IOfpH73NLZrob8GH/n18XTW7dh77/8Ael3wFdKUb2Q9BiDgrUqG5zrgJMXua/hisbjjmt7zMZsy3smpQ0YXKUVmqyYE/R9VOiJH8Q81YMeWoxgnqeIp9TULyVUGMPOqQ3vnQsQfxSz0wmmYmyjbP7QLmMVS0CX/M5GBpjgHMfKziB/LyRHkvW9wfJFQyiIdF2eGY67rcO5bO7yei0AFLQFYQesxnEvhOmoOQK0X1tD//3BCPSfwFZhuY+GqDuXrZeParhpurzfCLjMS9N7M+znKOSc7RCrhsC3dRophovOaB3l5b3jZE1o8GbjT4F9PPShe4ykfUoF83ySVsN59KNtRZ4lrxgSMMtLuzqb34yurWboib5p3aNuXcwPGFXnIZ7361WLy7lfk+mtUnGvWvCXjPXBcLbdKSY3y9ldtbHPVARl+4C/qyOAVwScawlIx/0k2lsRCTeBjlvgCip//NZBl1ZJQ/Re/XowGPzMHqiqkgzSGKwJcEYGltfAVsD/CVPoXQs/bJeH+IgxSnCrzJJIsBQv5O8I/OulPS6/gNB8tEph3vxnCCZYNP1LHwcE1gDnx356ctB/Uncsak/V/TWKGXCzycQNsskDyjaWgTVor51INcwi34iBY8WjUcBuveaQncgbOpHCVM7VzaWaFUPbn0BFZWpv996PoTt/xjSC9aJ3wY27NUwUxhzrRmuf+6Uuya07siAf+k3VdeC+aPRNe413SaKsIcUdWcwDamNoXw+nLbWBSZLQwwpXtzlKjbrU/q40+mJl30BTXikdUpxmx/0aKDGlLt0VWJObaLvXv27tAHA73KGKXhVM9onJjoKjTnomrZ4dKWLAWyKtgN5oRmUNqUFQSM2OvSC
 746wfukT
 AtyiuuLOtNd2C2218wN8f7YutcIbeg757RN/STtzoQcIjg+euEEA+XPJ2FLBVR0POPxeZDD33Hur9nSeo7urOYl2ETdOb2zXWX6zoYG1Egp40lJIrp47Ow5B1ChU1iXEkWN1lt7ZP3uaeyAT42HIRrH9WVT6UFJbwsColEz8As2fzipAZ4wl8zcCpwEwrzXxi3gpXwfisC2uyyN0ay0kKoO7VeRondg90isQGJbffvs9ydWB6Qoem+/2jZDJ1Vw2lV+uVBg3fd+DTT6AqKjCJikfkitpR22t+XY4IHIWwySAQ5ffCkndV2PttvFTdUCwiN3LCAP/8rpEwagPbZxRhUffhvjknIFIKWNWpTRtkWHs0VhVghIEaAXP5eeYpQn/1NK9dmUELdJ/GDelPNF2zfo2ZKqXT3bu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    90d970cade8e Merge tag 'ata-ata-6.17-rc2' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1193b3a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c5d01e11121d45
dashboard link: https://syzkaller.appspot.com/bug?extid=039eab266c6321a174bd
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/104fc9d3de89/disk-90d970ca.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/59eb5344d41f/vmlinux-90d970ca.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e0bed540b10c/bzImage-90d970ca.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+039eab266c6321a174bd@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P9643/1:b..l
rcu: 	(detected by 1, t=10503 jiffies, g=87629, q=1145 ncpus=2)
task:kworker/1:13    state:R  running task     stack:22384 pid:9643  tgid:9643  ppid:2      task_flags:0x4288060 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
 irqentry_exit+0x36/0x90 kernel/entry/common.c:197
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:check_kcov_mode kernel/kcov.c:185 [inline]
RIP: 0010:write_comp_data+0x3c/0x90 kernel/kcov.c:246
Code: 8b 05 58 b3 1a 12 a9 00 01 ff 00 74 1d f6 c4 01 74 67 a9 00 00 0f 00 75 60 a9 00 00 f0 00 75 59 8b 82 3c 16 00 00 85 c0 74 4f <8b> 82 18 16 00 00 83 f8 03 75 44 48 8b 82 20 16 00 00 8b 92 1c 16
RSP: 0000:ffffc90004fdf430 EFLAGS: 00000246
RAX: 0000000080000000 RBX: 0000000000000004 RCX: ffffffff822dbf07
RDX: ffff88802883a440 RSI: 0000000000000004 RDI: 0000000000000006
RBP: 0000000000000003 R08: 0000000000000006 R09: 0000000000000004
R10: 0000000000000003 R11: 00000000000082fe R12: ffff8880200096f0
R13: ffff8880200096ec R14: 0000000000000002 R15: dffffc0000000000
 __page_table_check_zero+0x207/0x5d0 mm/page_table_check.c:139
 page_table_check_free include/linux/page_table_check.h:43 [inline]
 free_pages_prepare mm/page_alloc.c:1396 [inline]
 __free_frozen_pages+0x7b7/0x10f0 mm/page_alloc.c:2895
 discard_slab mm/slub.c:2753 [inline]
 __put_partials+0x165/0x1c0 mm/slub.c:3218
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x4d/0x120 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x195/0x1e0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:340
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 kmem_cache_alloc_node_noprof+0x1d5/0x3b0 mm/slub.c:4281
 __alloc_skb+0x2b2/0x380 net/core/skbuff.c:659
 alloc_skb include/linux/skbuff.h:1336 [inline]
 alloc_uevent_skb+0x7d/0x210 lib/kobject_uevent.c:289
 uevent_net_broadcast_untagged lib/kobject_uevent.c:326 [inline]
 kobject_uevent_net_broadcast lib/kobject_uevent.c:410 [inline]
 kobject_uevent_env+0xca4/0x1870 lib/kobject_uevent.c:608
 device_del+0x623/0x9f0 drivers/base/core.c:3896
 usb_disable_device+0x355/0x7d0 drivers/usb/core/message.c:1418
 usb_disconnect+0x2e1/0x9c0 drivers/usb/core/hub.c:2344
 hub_port_connect drivers/usb/core/hub.c:5406 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5706 [inline]
 port_event drivers/usb/core/hub.c:5870 [inline]
 hub_event+0x1c81/0x4fe0 drivers/usb/core/hub.c:5952
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

