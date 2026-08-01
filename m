Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92497C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881B06B0093; Fri, 31 Jul 2026 20:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832756B0095; Fri, 31 Jul 2026 20:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771F66B0096; Fri, 31 Jul 2026 20:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 450E26B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:01:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB7911C023D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:01:37 +0000 (UTC)
X-FDA: 85050746634.09.B308B3E
Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3309DC0009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:01:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3XzdtagkbANwQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3XzdtagkbANwQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785542496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=SDtC7w2DUUNBeKHMoZNoYUveZ2NrA1LkTh8dACFYsq4=;
	b=diHHckftmcDOojg2ulF4G86ORggyIrhMGJGPCJIkebjsfUfZoGt9TkXvgramW5/VreJjeS
	1P6CRei+/pag89d4ByKxeiUh+qadNYQgEqCyVtOMfOAOtGbvA87LRwSzz9qaBS7Jjtu+89
	uSyjEjelyXGdNK4EZ9V4BNhql4WTFNo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3XzdtagkbANwQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3XzdtagkbANwQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785542496;
	b=s5lI4GaLuf4k589QLStxu2giz5tc53YtXyrqJl+M1n6Bu6B06v9z6JyfpcZCL1xvY1JKC6
	XUDQG75B4ydkzYZGXX/kLtwuSSqYffYq/q6lB0AjTPZj0uFWVAS8HclBl5MOTJPOMIjSmE
	6gETXdDYrNZRxfRRDcnAUgZK+0i02R0=
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4ab4ca7ce3fso1410096b6e.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785542495; x=1786147295;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SDtC7w2DUUNBeKHMoZNoYUveZ2NrA1LkTh8dACFYsq4=;
        b=dbN7vE2w2ubaH2EMzUBGsg6GyNrjJ2mxp48IBuPxu0G0LcdKJDJVwK5BFoFYKllAFz
         b6tV8tcK1PhFsRwpAD7291WVd4thc9INRVqb91ATu7SZIsemb7yJcjDJm6awDlIs6Gg5
         vDFSLjxByArAI4Zg4ijUalSKwR76xjlZusva+KVfo5Y+nWFFXcKaiLhSGwi6hWEGqrTS
         Azow+vN+vdo9oHRcoEBzlD3z2ykYmJaZPjqbpyN8swi1+jzxJw1QfcaQlQ6RdRTlcoGH
         ebH+vPiuFFFhJT8uyHja4L5RHn1AvWZPca44lNmgGmECvo6fvOr28uTRfeuyMd+7/rSt
         RfCA==
X-Forwarded-Encrypted: i=1; AHgh+RpkrnB5H5VoUgGdnnSl1tbR95tzm41xPaTxq9mUXBCWF29VVN41WSyXGkz4w4mMqFDTCiiyrF+0AQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+IUPYOXlrqSacK5Zg35OcRpsJpxOiycVeMfe7spF9/DIh2inW
	7ehm4lkW0qABMGruLIoccESl6aoDrRKDQ91egcpY47mUU7z4EAXnvnqLf5ZCz3KSqqK2xv/Ohzm
	ubp0E7k4JJTV2UHcMZ2VrXxsjlAbK54j/7/XKlHB/BQDI7xOgSHr5autzlU4=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6903:b0:4ab:2c58:4514 with SMTP id
 5614622812f47-4af5dcd6472mr3164059b6e.0.1785542495176; Fri, 31 Jul 2026
 17:01:35 -0700 (PDT)
Date: Fri, 31 Jul 2026 17:01:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6d375f.2d659fcc.1d46f5.01a5.GAE@google.com>
Subject: [syzbot] [mm?] [kasan?] INFO: rcu detected stall in filemap_read
From: syzbot <syzbot+eead920cc4166b2530d8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dvyukov@google.com, elver@google.com, 
	glider@google.com, kasan-dev@googlegroups.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3309DC0009
X-Stat-Signature: m4nx7k8onted1d71etwpwer5s8drzcd1
X-HE-Tag: 1785542496-298057
X-HE-Meta: U2FsdGVkX1/Dn/pkD4OvAoH1QOUFAvwVLrDmkH7pBun5VixTETVIRc17rCWRn1y4taBBntQZpwByB7JA/pAD9ZF8m/3EoZkRuPIgQuzy9G6U/LZOHooPeWmcqtvGYlCgHPbAwIdxxjX834RRZsxzt1e+MH1kP3jn2i/Dj94XkSTSLJSHThutxrwLGsz8JBef2wTJLOaNolhhWR8He8fJI/5e/ZsL2GWellhtIgE1rdBUZeLhZMDEbeIQlidWDAm+Qtm1eEpOSm1QRi2nJ9UHIjZFlpJaiDnayfgwRm06BZ4+/BNE9DTYk+Nf5Ayrof6MrKD9ZCpdZAt1m+0q38tptbuO2YoYIpN2cSJ3mkEPjVVoSvU1h/A9UrQi4l0DNTqilWIGQIRc/woBW51+Mppyx4QBWkN3FDZUAklvXVVAeyALUltuUga/OjJul6ww75uU0jQEiAv1fKit11DmAwEM1jg5rSciGtOIMSiM9d992OgrepERvNHaD2NEphpjDdcX/5hIcGp9qblgK77vtwx7HBUPNq2VKZKufg+vgbFzT+MsEE4OkV8BQOamVqQZyNWEzgRdRFUXBH+8VIoG9eyG1JhrqQ7lUT/MNr/ddTD01CViYyNvOXDufkqAcjsQ5qyB3WpyrBwAQQEkbC9iIEoYxNANb6pEvlE9EqPXyW7pgvRwMvkw5XUpxhXqyEn5IwlDXvkv/bYCCvbnSdYyDuOjnauk5iXhKbKnCTuP0HRVBgvIOmMbSARffXifGl42c2VC6XNkwENdLMrRa8hUJtHnvUjlG4tWhJsfU5TjRcV3exQ1n+4phuECsYAlZkQqJE6HfoLM3/gvPnld43U49yJVAaZ9fBef9/3lGqV/JcJCWc0W2EVdZ9rtvJANN7p8AInJFDr/H0r4kzdwKfL1v6z1Zbi9YQ6c6Nqo04+BS5rgC7+6pgRtWj0yXfoaiV9nLYCswAZX2YGvfV+BNNGMhMI
 DhlaXwel
 He0+YDH5pC5hYglQr+AF81FcW0GPj0z1mv5D8qr24juLP/gUoBlUq68bXAwk4vjjiiwpwn3ioNEcdve40mDGaYz5m74sYszD8/TsQQSQPdY3n7zF0SKopKuqHveyY1fWUM1TvowXupgqD8r8SG6787i3B1dfRiOkgG0sEkr+LIsfp4/tgt4ISru9XLZPqLy7xGCsh9Vx/QvwL9IdivJq79UA/27scAr5uk60gZYGgGhu7DwXQacrWeX7iRxoPzF1oGcVr6MrcX2rP3ue9jYIZsjlekujn+jhryfhCRZiUVTAxK8L9ULHNc1SWhcwKmw0smCj4O/Zau9SkdE8Z8zeLl4NyIcwOmu6ZAimQtjtwyqzGtBIS+ZIV/s7cG/4ovbJpQ0lSSjhHW7BvJxRMlaAxA3QgaBlN2q/46lCNkzpUcSbAYkjB25WeeUByuGNt5lxJgmIP+UUz98haCFVt/kA1SCx2JcfBQ7zGdhDAAIoIGmIHgzDhNO3U4ht9uiunvgijwZFpqHix1PhjjaYSbV2tUpkjVRCvb6DlYkldSMiO6mBUrhh2J5BBgAmRRayJrKnm7WIV4kemzHshcvfBI8Ra0c/AoP8xKYzmmH77703FgQKbEzIViVpoelIWoX7bn7S471nmV+kIQC7snHepMm77ZAixYRHiBk219+BkJvHyQJyI903jGrEjYNIgV63/iofpHh0IoYUnq0ZC+/xYgx0R5sc0dLnjcoi2kQjlDmWA3uz0xwh1jX3cwAaFTdHN25K9vCatBf15qkgV71tRuHaJTpoa8YcwqUiyS2Ohs2arm6VPlI7FOVnXcZV2TQVaP0Z3JHZjgxWg803z2eE/ZBDB7mamKYCs2xmW4CQlmYwmSBIjU0rVv6g8Pq+dLIp7zT5bxVyEgwnZ8tMB0PVPpR8f63p5727hfTSLkzQbToyiYXaZxxeAsTlmpGWtHmY2pyOkj5OBalcE3D+ITy2L5LrQauN0nw7T
 2dqRXjxX
 K+ghhpWMvLCSelME0U/LPq/DC6jqfZKiUzs4wqJVHlWZacq+B8ZY9qkAsqKeUmDdoIyS5nhmvuX+UudRPd5pxADscFwXhFl7NMiueKbsn4mSdat7m/hsVHifm6DiE4fB3n9RqXJZf2FNuFC4peJnlGvoCuWee91snSVTZ+Zcxfc/XXMc0po9ylPvEjRQtvSV/SAynYZAdiBwCIbmYZn7vEqh1Ru08GpXQ01gW+Ns1pgFuuHVoHEzFhcXsVgTN1nguBdKXM2B6elg854saAcIH6t3/0R4WS70N2NSP92BG2TY1CWb6WsPaAjKHnSkYFtWwLEYgEtkZCkjhWvnGOW2RzRyvQWUeTU5SBNWsi7NZ/PcOS3FiFV1kfpViz5H16zMhsXhqf64THgS1mQTh8uVYFrP81YNEAwX+Uguz8s461wwlL2GWsSrj2RkESbRU6Hbyns6KDcEOUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    4235cb24ec1e Merge tag 'vfs-7.2-rc5.fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e3bfde580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
dashboard link: https://syzkaller.appspot.com/bug?extid=eead920cc4166b2530d8
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10dde6b9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/906b09e16f16/disk-4235cb24.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2cb120bc3818/vmlinux-4235cb24.xz
kernel image: https://storage.googleapis.com/syzbot-assets/880615d1b5d5/bzImage-4235cb24.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eead920cc4166b2530d8@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (3 ticks this GP) idle=ff84/1/0x4000000000000000 softirq=18226/18246 fqs=4
rcu: 	(detected by 0, t=10502 jiffies, g=18401, q=1937 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6111 Comm: modprobe Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:__kasan_check_byte+0x14/0x40 mm/kasan/common.c:573
Code: fa ff ff 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 41 56 53 48 89 f3 49 89 fe e8 3e 15 00 00 84 c0 <75> 16 be 01 00 00 00 4c 89 f7 31 d2 48 89 d9 89 c3 e8 f6 04 00 00
RSP: 0018:ffffc90000a08c58 EFLAGS: 00000002
RAX: 0000000000000001 RBX: ffffffff89de25b4 RCX: 0000000000010001
RDX: 0000000000000000 RSI: ffffffff89de25b4 RDI: 1ffffffff1d6b38c
RBP: ffffffff89de2598 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100f925c56 R12: 0000000000000002
R13: ffffffff8eb59c60 R14: ffffffff8eb59c60 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88812504e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa1a832efe8 CR3: 000000002d63f000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 kasan_check_byte include/linux/kasan.h:402 [inline]
 lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
 rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 rcu_read_lock include/linux/rcupdate.h:840 [inline]
 advance_sched+0xa04/0xc80 net/sched/sch_taprio.c:992
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:lru_gen_inc_refs mm/swap.c:442 [inline]
RIP: 0010:folio_mark_accessed+0x2e0/0x8b0 mm/swap.c:501
Code: 84 24 80 00 00 00 0f 85 86 01 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 56 00 06 ff cc 48 bf 00 00 00 00 80 01 00 00 <4c> 8b 64 24 40 4d 89 e5 49 21 fd 4c 89 ee e8 0d c8 bc ff 48 b8 00
RSP: 0018:ffffc90002edf920 EFLAGS: 00000202
RAX: ffffffff820a3fcb RBX: ffffea00004d6f00 RCX: ffff88801dbd3e00
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000018000000000
RBP: ffffc90002edf9f0 R08: ffffea00004d6f07 R09: 1ffffd400009ade0
R10: dffffc0000000000 R11: fffff9400009ade1 R12: 0000000000000004
R13: dffffc0000000000 R14: 1ffff920005dbf28 R15: 1ffffd400009ade0
 filemap_read+0x61d/0x11e0 mm/filemap.c:2843
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x595/0xa80 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa1a8600134
Code: 48 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 f7 d8 89 05 80 41 01 00 48 c7 c0 ff ff ff ff c3 0f 1f 84 00 00 00 00 00 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 04 c3 0f 1f 00 f7 d8 89 05 58 41 01 00 48 c7
RSP: 002b:00007ffe14a46718 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007ffe14a46790 RCX: 00007fa1a8600134
RDX: 0000000000000340 RSI: 00007ffe14a469a8 RDI: 0000000000000000
RBP: 00007ffe14a46780 R08: 00007ffe14a46987 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000340 R14: 00007ffe14a469a0 R15: 00007ffe14a469a8
 </TASK>
rcu: rcu_preempt kthread starved for 10494 jiffies! g18401 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27496 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_timeout+0x152/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2123
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2325
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 3319 Comm: kworker/u8:8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:csd_lock_wait kernel/smp.c:342 [inline]
RIP: 0010:smp_call_function_many_cond+0x11eb/0x15f0 kernel/smp.c:912
Code: 1e 89 de 83 e6 01 31 ff e8 e2 22 0c 00 83 e3 01 48 bb 00 00 00 00 00 fc ff df 75 07 e8 8e 1e 0c 00 eb 37 f3 90 41 0f b6 04 1c <84> c0 75 10 41 f7 06 01 00 00 00 74 1e e8 73 1e 0c 00 eb e5 44 89
RSP: 0018:ffffc9000db97700 EFLAGS: 00000293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff888032c90000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000db97860 R08: ffffffff90579137 R09: 1ffffffff20af226
R10: dffffc0000000000 R11: fffffbfff20af227 R12: 1ffff110170e81d1
R13: ffff8880b863c448 R14: ffff8880b8740e88 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888124f4e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7fdb89a000 CR3: 000000000e946000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1077
 on_each_cpu include/linux/smp.h:72 [inline]
 smp_text_poke_sync_each_cpu arch/x86/kernel/alternative.c:2773 [inline]
 smp_text_poke_batch_finish+0x5fd/0x1110 arch/x86/kernel/alternative.c:2983
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 static_key_enable_cpuslocked+0x128/0x240 kernel/jump_label.c:210
 static_key_enable+0x1a/0x20 kernel/jump_label.c:223
 toggle_allocation_gate+0xab/0x290 mm/kfence/core.c:911
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
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

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

