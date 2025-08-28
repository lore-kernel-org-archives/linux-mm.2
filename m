Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEE8CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860168E0014; Thu, 28 Aug 2025 05:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8106C8E0001; Thu, 28 Aug 2025 05:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700058E0014; Thu, 28 Aug 2025 05:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCD08E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:40:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32EA51A0A56
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:40:34 +0000 (UTC)
X-FDA: 83825671188.24.54FAF07
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7AA24A0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:40:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3DySwaAkbAGQUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3DySwaAkbAGQUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374032; a=rsa-sha256;
	cv=none;
	b=Y3o1O87Xmc4Yu4mtExQi1ZsVw4XbZn8iviFcTA8fEGQaCd7CDMC7sZ1DC7Vkk/8dbI9kwN
	/JbxhVyp/kqeXHQQIx1yafJHWk0uEsVJ4/2yW+J/o/4QU+vquvp78Ak9MrzOTWYlNfGPto
	gUGfo17tG9M9vDsidySg6y2psiM99uY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3DySwaAkbAGQUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3DySwaAkbAGQUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=+JQa2Q3RMgKoz8KLEXgRA8PGx4jpTO7vqVWF1zeuITc=;
	b=hoPLF49V/akH31j2lh1jFTVLXmeMqm4SwuwoL82BA9qljZRT7U0bwjOjjo15Hm5DjlsQzb
	U6O5WTSF6thGKWTX0o+5elFPL0Om5NpvUpeeYPaYMLMBj4nmMbQYqnRbFjz8+UWIrhJJPx
	2lylgCs9X4kHBv9D9ey1XZw5IiR3IdQ=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3f02c49973dso18591315ab.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756374031; x=1756978831;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+JQa2Q3RMgKoz8KLEXgRA8PGx4jpTO7vqVWF1zeuITc=;
        b=if9gzzru4vnvD3qQlZ/crknU0Ozfb5c5yvxfGzVkd57xDqfOZ2gVqB8XhmPiP1xIAX
         jlisfsinsk0RWBrhxy+1USFhi2/xRpH27P7K7y8xu4NALHciRjOsKLAib0KZJZqwfnPc
         cbZlM5L/KU20BEV7Xbj0aIC5svc+qsbAN/10LzVj1wOA62iDc8+aKeaUj7YK6RF3zRy9
         oGE+885YF+iS1tYIRwX2Y9sMIO6V6PLhx8j5NLwmvVeX3ck1Ya58jY6VO9gMbR5cTnnC
         UUHIfvghVkDsTNuHpx9u7ZFD3ZWf8VjX15/Mku/0Em2ayELaHRYTYr7LS/2DjpKz3JIV
         Caiw==
X-Forwarded-Encrypted: i=1; AJvYcCW8c7eOaKCcs3A8ckgh8hhUFOCpFN45NBex0wagL0ySw2w5GHH4GPuBrB4D73+U9vbKjw1s/VF82w==@kvack.org
X-Gm-Message-State: AOJu0Yx3+j0DxtkbsEQfRlUQsJcWq9Zev8NtSuwaq84WHAWV4YL/Jaqp
	1PHmX/+9vBOXjBZAKgC9v8HaqyDNHmhDfigZzSDmXH+g/82ljf8i34T5t0R3tAQ4HYTMRnP3VEU
	rAR0lMzB2uAQrSihPhNe0+aRovhCoui9f3hj6mg3qyqgOR7wt/ufhy6HrMUA=
X-Google-Smtp-Source: AGHT+IHFj13AhOz4c8+6RJ6E2HfOioGeTrqhki0cj2hLOJ/oEBldJxeb9JYvHPhzr3RDbZOf0t8BwSfgZU5cWX6MZAChLNbGRnkn
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170d:b0:3f1:ed24:cfa1 with SMTP id
 e9e14a558f8ab-3f1ed24d055mr4176705ab.27.1756374031605; Thu, 28 Aug 2025
 02:40:31 -0700 (PDT)
Date: Thu, 28 Aug 2025 02:40:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b0240f.a00a0220.1337b0.0006.GAE@google.com>
Subject: [syzbot] [gfs2?] INFO: task hung in writeback_iter (3)
From: syzbot <syzbot+1e3ff4b07c16ca0f6fe2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, gfs2@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7AA24A0006
X-Stat-Signature: abhpqyr8z5zqp9nytr4wjuu6yna7z3d9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756374032-482199
X-HE-Meta: U2FsdGVkX195GsSXvaw8Kr6A7DkChCujRPlS7BNvBDmoRsdo9Vp+gwCxdkqXNTQ5gtVbNEa0LkHJuiIcmeText5bOe8b7BowuU1rDNizQGpF4qf4YB8E+mk/SUnton1rsjCqmg+w3BzGEsDtu2oKJkjKDLeWlc8qU76dHYgAHC9RuQ/1JWu14MMlfe80WVOcD2zrBBWEuyBEz6onNox6n1kqBgbw6vDFhMDanR1FlJuNDcqtwawG8H98eRZMdT4CWH16ABKDs1Nk8gGfAfLqJ4z8BnBoCT3/RShQP887Imjf3I1dgDtSpAkCstVVfYjRwpRuJbbxweLCkHfTxzpZR1QGcPJ0YytOljW2Zj+PtD/iiATo9ngQufEHBaAl/jBoAFCWUBy0W7a5/vvD8C0mpW0Iu6vsjnh2radcNSL7Hw0+NpY4uA0myU8SDk4/c8WaTnYHxDzAvrtZGriniJANFKrstJlbuhkV1rmqgT31Bl4US3RArZ7ggdFd51SfQJdU25xFHM8vElsHGNU1AUhkHxE4AlF+eFBCypsG09bJECqD/ldgb9ceadfnsQEX/6+q1cDCNbZJw5qLsWqTn+ITbeeaiVZzqknER50nmvIcnbKBUPN3pxmiRI5zF0HaGydst+JN2xD5vsq9eZLLX8q9nKnJCNp4f1XfJjUtQUNBwYS4W+chPpEu5KJldOSGsqOCK6yuyF3WB5r++fr5PhMfRpAQNZKtLO2KFAJwHZ7344uj2aaJupb+sgRhslRuG7rjhaCn5k1UqFyK3zEHrtpIzBnS0XuR1zVUe7C5T2NtwxLyPaxB58X71rsXJqXmi6WeLzZILOJx97mPYdivzDHRx2PYkzs7+InvcqLSOd1EdCpMpOn49+8ea7hdXb22uodMi9xo3YdxuOKXu2dHuBY38Is0i4UP0NsauWZFqSAFaVnwFAmcizOO8ph7GnNXElwryw6SplNYwCMOfvFuP6y
 yDLXIjyP
 oOV8d14Ev1pn5Zrqj7TnEUcs15t3zIkZmpe8+zJ0uOmP5wrc0MFtC1vdT0a9CE1ylA+BTi9gseXc0zGicGVMYyL1xYlvRdak5qc0Xc7OwdN2CaEQH+kN8boxGyKK+f+HVH06mOl/i2XnDuClxl9+Ulwo1PrRnxjOp3FJjwVtPGUNuR4sYTJIlxVD1/IYmVuiBzEUO9qUxiCtAhZ3VQ9B80w3/rhcBl/ty5ymua/Ce6PSFdkmrQuykRBepKSfaM9Xe5ZiBSDArcUX3Rigd1v/CcQ6mo8elZOMAckBvtSsHKIcBxV0UBh1vTFeabF33fl5MybYt9Rv1Itoo2O/zDEUEZeveVrrTJ5FLwu6x2rERvuHdS6xJTg76IxlrAejaVXZIm2NMWDQXCBdZlPlx99A42vUYtf4UWD6sjzwZLpi3aMn8Ag8+WsaZfcpBD3+zvlGtUKX3u+vg02UDc//0fg2vOnJEDVTLc25caYZJvOd+S5aGLldNz0GfqERh7DALVHGg4EdZmXv5QKrP8e3I0jQqCcRpcNyu3IHpfCF6KqjA2TzKGRfQcbkGVV+dhGSc/WUubVaEZJp6gJ/Pt9Hyeg0/5xF3hwoezN5aBbv+FkGkKR9QPuqE1WJ9dLbbHKmDC2Wdp5oMAro2oAKij3pZJpr56X3p3rDl84RzQ8xZ9r2nLfvxnB6ujpYWgV2fHRLW8emwPxuAs6psrkgOK5c6WjHLY9MZR4SoKEpqh9Yet6G6FrF7Kr2JRBRyYTIXYmFfusKcEceNxacxUlrbVFUg/J7NC8a3GKIUBIEsAXSzNzd8Ej3hXFHg3znrXUVyA3jsLt1h40p/yLRsnJQ8B4afpZEk1Ex//bRwQ+gbYTVMfg0AHNUxZ53nMJj+k7wV1sgcIuRK+WSau5LcRpdHN7F1wwOzKkODzwyGjXL0X/yL95TSk95aUQeDa9c7tdl5uxo++aQTsz1dMLn8393j+Eqirm/vEO/Pzo+F
 fQOR2PXQ
 gk9AV7d0QdtQTtZwBeDvalI+yHnp23Pnh8Ghq3qODqEeC0uGc6pRWIBa4EOBSB4tLAgp2uMov3depsXESbsJ66dWKgKPhshDIeT3qPVKEJ8QD0sv6mJK3xxA+R7eiWiP855Kwc282yNZ+3pwyd+m3YkgWTQxyFUsqJc24UJmqLnfoQ0HyU7oMHOa92l+td+0VX7MKgwhN2YqURO6u0zeYgFRx3wK9/PNb0NFDx0hbJvfTSJKAuKrjpqpLyvDes1IRchsGT7jQ1n/v2O8O37vfYrLk4v4xN9rYLtinJvur8xGkn7h8Qu4jIlwQOSS7uVaZa9iGuxKlLBvnaFhwHdGpONC6vgMGr7o+pu2a77Lqif6FeR8WEgh/G0RahudOv2mqYKe/xxKf5tLHodNdqiKu69Q0TCFzbupAkl8kKyvcHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    7fa4d8dc380f Add linux-next specific files for 20250821
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=130beef0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d054fcd55656377
dashboard link: https://syzkaller.appspot.com/bug?extid=1e3ff4b07c16ca0f6fe2
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10339c42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1668e462580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a843be98ab42/disk-7fa4d8dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/17b718892b67/vmlinux-7fa4d8dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8939424b4b54/bzImage-7fa4d8dc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6c5d1c428942/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=150beef0580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e3ff4b07c16ca0f6fe2@syzkaller.appspotmail.com

INFO: task syz.0.17:6037 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:25096 pid:6037  tgid:6037  ppid:5973   task_flags:0x400140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 io_schedule+0x80/0xd0 kernel/sched/core.c:7903
 folio_wait_bit_common+0x6b0/0xb90 mm/filemap.c:1317
 folio_lock include/linux/pagemap.h:1139 [inline]
 writeback_get_folio mm/page-writeback.c:2468 [inline]
 writeback_iter+0x8d8/0x12a0 mm/page-writeback.c:2562
 iomap_writepages+0x14d/0x2d0 fs/iomap/buffered-io.c:1761
 gfs2_writepages+0x177/0x250 fs/gfs2/aops.c:175
 do_writepages+0x32e/0x550 mm/page-writeback.c:2634
 filemap_fdatawrite_wbc mm/filemap.c:386 [inline]
 __filemap_fdatawrite_range mm/filemap.c:419 [inline]
 __filemap_fdatawrite mm/filemap.c:425 [inline]
 filemap_fdatawrite+0x199/0x240 mm/filemap.c:430
 gfs2_ordered_write fs/gfs2/log.c:733 [inline]
 gfs2_log_flush+0x966/0x24c0 fs/gfs2/log.c:1102
 gfs2_trans_end+0x37c/0x570 fs/gfs2/trans.c:158
 gfs2_page_mkwrite+0x14a8/0x1910 fs/gfs2/file.c:535
 do_page_mkwrite+0x14d/0x310 mm/memory.c:3489
 do_shared_fault mm/memory.c:5779 [inline]
 do_fault mm/memory.c:5841 [inline]
 do_pte_missing mm/memory.c:4362 [inline]
 handle_pte_fault mm/memory.c:6182 [inline]
 __handle_mm_fault+0x1916/0x5400 mm/memory.c:6323
 handle_mm_fault+0x40a/0x8e0 mm/memory.c:6492
 do_user_addr_fault+0xa81/0x1390 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f97632550b3
RSP: 002b:00007ffef0bb04e0 EFLAGS: 00010246
RAX: 0000200000000180 RBX: 0000000000000008 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00005555685083c8
RBP: 00007ffef0bb05e8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 00007f97635b5fac
R13: 00007f97635b5fa0 R14: fffffffffffffffe R15: 0000000000000006
 </TASK>
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
 watchdog+0xf60/0xfa0 kernel/hung_task.c:495
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x47c/0x820 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6836 Comm: syz.1.269 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:dsp_cmx_send+0x0/0x1b40 drivers/isdn/mISDN/dsp_cmx.c:1618
Code: 3b aa f9 48 ba 00 00 00 00 00 fc ff df e9 09 f2 ff ff 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 55 41 57 41 56 41 55 41 54 53 48 81 ec e0 00 00 00 e8
RSP: 0018:ffffc90000a08b98 EFLAGS: 00000246
RAX: ffffffff81ae4d15 RBX: 0000000000000101 RCX: ffff88801d78da00
RDX: 0000000000000100 RSI: ffffffff8c035860 RDI: ffffffff9a057420
RBP: ffffc90000a08c90 R08: ffffffff8fc40337 R09: 1ffffffff1f88066
R10: dffffc0000000000 R11: ffffffff8879fcb0 R12: 1ffff92000141178
R13: ffffffff9a057420 R14: 0000000000000001 R15: 0000000000000001
FS:  0000555565d25500(0000) GS:ffff888125aff000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4ea15ff000 CR3: 0000000027184000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 call_timer_fn+0x17b/0x5f0 kernel/time/timer.c:1747
 expire_timers kernel/time/timer.c:1798 [inline]
 __run_timers kernel/time/timer.c:2372 [inline]
 __run_timer_base+0x61a/0x860 kernel/time/timer.c:2384
 run_timer_base kernel/time/timer.c:2393 [inline]
 run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2061 [inline]
RIP: 0010:vprintk_emit+0x58f/0x7a0 kernel/printk/printk.c:2449
Code: 85 32 01 00 00 e8 a1 81 1f 00 41 89 df 4d 85 f6 48 8b 1c 24 75 07 e8 90 81 1f 00 eb 06 e8 89 81 1f 00 fb 48 c7 c7 80 02 33 8e <31> f6 ba 01 00 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 b9 35
RSP: 0018:ffffc90004a8ed80 EFLAGS: 00000293
RAX: ffffffff81a10d47 RBX: ffffffff81a10c04 RCX: ffff88801d78da00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e330280
RBP: ffffc90004a8ee90 R08: ffffffff8fc40337 R09: 1ffffffff1f88066
R10: dffffc0000000000 R11: fffffbfff1f88067 R12: dffffc0000000000
R13: 1ffff92000951db4 R14: 0000000000000200 R15: 000000000000002f
 _printk+0xcf/0x120 kernel/printk/printk.c:2475
 set_capacity_and_notify+0x208/0x2d0 block/genhd.c:93
 loop_set_size+0x44/0xb0 drivers/block/loop.c:214
 loop_configure+0x9f4/0xe50 drivers/block/loop.c:1071
 lo_ioctl+0x810/0x1b30 drivers/block/loop.c:-1
 blkdev_ioctl+0x5a8/0x6d0 block/ioctl.c:705
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4ea958e7eb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffc529a9be0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f4ea958e7eb
RDX: 0000000000000003 RSI: 0000000000004c00 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000001f78a
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffc529a9d10 R14: 00007ffc529a9cd0 R15: 00007f4ea0600000
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

