Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A693C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335B76B0088; Mon,  3 Aug 2026 02:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6A46B0093; Mon,  3 Aug 2026 02:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD7C6B0095; Mon,  3 Aug 2026 02:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E13EE6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:40:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFF15405F6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:40:35 +0000 (UTC)
X-FDA: 85059009630.25.76E45D6
Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	by imf01.hostedemail.com (Postfix) with ESMTP id 36D9F40009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:40:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 34TdwagkbAGwcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.77 as permitted sender) smtp.mailfrom=34TdwagkbAGwcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785739234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=kmLfTeX2LuB648xyXziPrOINmokEfv+YjIM+g9GaVWQ=;
	b=qelJZSRAlR34tCZj488c/KHgLPF0ZTktYgE9527U7lUEsGjP1AoocmHHTc7NmGqVWm6atj
	7hu1Ixsw5Q22w3P62Z3aiYlI4SjmSUQPlo1mo5V6R6GjDC0/fO3fegGpNRze+/ztZLGF9k
	38oxWMbwJUUY9YjdQV1sZetGYivvn+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785739234;
	b=GAUMwrHs4Ak3lyijK625oSpQSHZVw9Sz/OR5AdkRoe8f75nlCu2bgkO574dXsNHIpUFisX
	otEcMHQvz8QQe7KxcNADou3GEtg5gMtWo+xQlgUL6JgOFfabqzUNYlzFXlqt1Y9r+dkDRL
	uGcd6cTTCQttdzVYxGLUO+U6acj8IY4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 34TdwagkbAGwcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.77 as permitted sender) smtp.mailfrom=34TdwagkbAGwcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7e9ee20bde0so2066337a34.2
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 23:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785739233; x=1786344033;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kmLfTeX2LuB648xyXziPrOINmokEfv+YjIM+g9GaVWQ=;
        b=Vy65eRscSoJKGeYaqdmdXYKs5S4W9grH089/6Ywi+Y8rxBaDvZ6QZdyLj3ADuL/3Kv
         E3Pjx6x2KBtLbNbl57t1pGrzCDvjPuJ+AUDrTMuqIRRzOo4kUz5lSKGatVuV3PP0Ngkm
         gfj1jgDsf1BIgucJtDvz3L15AduuUtSxPCCkzB8Q0J/ohl4GifcyXKhTWwutUTjJXeoN
         TxxrAyqm3mSk2I26vr9CynLsy0Tjadl6SDtAA8Es8Xq5odM+QQwzByURUqbfcpMNHstV
         HyE3eZMb7UkDgk7fQ0b/3NthpBDT0d1SGXXRnTgam0DsoVwIcT5+XF46EoWzIpHNSmGd
         puLA==
X-Forwarded-Encrypted: i=1; AHgh+RozPUjjQLmI3fQ3E7Gr6uND3w3wd6z69vNuHVKiDI50wBOgJcfPmYm4fJ7a1bH/QFE0tD3wt06BCA==@kvack.org
X-Gm-Message-State: AOJu0YwPLX34gT6ZO1xK//V4ALEeTpo6evyEtSHYDhnd/7lrB6vnbar1
	M4qOwj/9yaldhbj5cBLf6l8GXpchkz6hoeQhYW/oEGzumi4XAD9FrxjemMFS+HgeDwD2s+9QfD5
	Jf7LoWPAJYU1VfmJ8GZ5NA9x5sL2/e2t0IJh8ad9pYrl5e5JOboE2N9kL+rc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1614:b0:6a3:e11b:c44 with SMTP id
 006d021491bc7-6ae4320bb54mr12057715eaf.14.1785739233041; Sun, 02 Aug 2026
 23:40:33 -0700 (PDT)
Date: Sun, 02 Aug 2026 23:40:33 -0700
In-Reply-To: <6a470486.52c20a74.1f8b39.000c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7037e1.2d659fcc.1d46f5.01e6.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in update_rq_clock (2)
From: syzbot <syzbot+681e729b2cf0d4860042@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, 
	mingo@redhat.com, nogikh@google.com, peterz@infradead.org, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 36D9F40009
X-Stat-Signature: up4ugqrowjh7911bgorpyjci9mqwix4u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785739234-130247
X-HE-Meta: U2FsdGVkX18NY2pFLwLqPZwT2BZPyvKSJTFgZHRc8lPYCx5TNzW1Dc9M9tXN+kGDtD+TwHClPMeIyaHReJim2o7kFiLY7QCi5xIL8jiB+TcYDCdWQzgtfDDsCiAl5+Tv8i+GKuNMN1yeSKuiw4ZQ1qRX1wVWrftRn+oRW30lGR9OSPcbvEPokp6zIHb7DoKIhkVxvHU/OLhH8tsWuJGrj/JbbC9oPbRvaFd7Tw5EAd8mJgxmOrQHA4vQHntvRaXvdhmwwHsv841fJ5gQ5hlbKECwY3gQvJDJ2acz/UCkwCXjXRuHkzNscHXbcU+I2MpVPTW4g/wJP80YlOrlo+QZ8lFMhc+dfGTfj4zruuLOoLCDkA0Qmcx7iWrLMptAxJfOmedt/aoFLOLmNt84SOheMjTO+9d0UDBkeU+4+8gkl0jNP81G/GjRAY5YLBDk/YowIxCXIY0tMzQB0bXDp4Hw2sj2gPy5SgWWRatWEO3n6Zioh/qFmGKi0LtliF2A/1aeq4vmJ48+NGJGgHDMhqq8dJJ7ib4YtNIQILeJKZlqJL8e9EwqgMoDGnz6v9QTbV8heltHBp00YlWpWYCTbw7EF59exp5oCu90KcsPXuuBrDVkN8g3+BlITiAoutNYz499w22RNV8sSpLvnyG5b8v7wgVWH+ogOWVhaY2RLzxbZV7WCxS3kY3PBpwgtoKY+DL6PYajWyJE3vLCwxCILDhrzeBvPotdq+s6hlagbFXBxFOD/icutx/447qbIwJgU+5G3/QA0UOqsjDuDvWCg47bHXOZ5H8pKwZCLGZK9Y2xs4a6NntBGKuZbex34YK0wj/amDacenyCVJDdXNL6ujuCSXtmdHA3lDl81km8d+D0cfYRcWQnSBc6VEnuA5Ng2YB1iTlYUYdtZLlA0qevjrlI0e2LjPkdQsOVjhI31AUs9Vx7EPQI3IxV+DZmAHvQ7Sw1HVWbSa7Fp9vqDYkd8fB
 +JktlvhZ
 tVDlaqqd4UUipyU+ng3aiFt82E+ZqVTyXOAn50hBULdDBlIthk41l92u4sJB77YV41epOthUtT0L3JE9dPOYVOeCTE3KD1IufdIrPrb7DIrdSpTxAd1a0Qh8lP4daQNtxxDixybxQlissDEmpEdWoL4wbbFN0oYZglJ//eyvObjK18ww5c6CRVVZ1mC4xWSLjB2SJucKuEgCqKWvihnSTHTja64gzMJvZ2EkFhz2JLi+FfXBcG4sCXBu2Yc76LOo0bQZZvpkRamiXZ9yV/dwa+cmU6liKeLD/vxyiGkMyouIm9LCdGTbADkinRsFz/vnzejLaTAw4cFfPAhg356ylaQDbrPUw6hQUxtWCEN/yC/uts5uhaG/dy5V75i5EAJ3ljoW+Fgtef+E2nO2NXVi/RiUZHeMGEImUsVUoGlh3Z2Zp16+lXHHLtQ8njb1UE0VWetCmwVYanlwwGS7jIsWlLwrKRQzmI6Ok+leBX8B2dc0ozSpnmbPTGVsr2skErThdUq6gPKiL+1TRxx0I/DwgLgADp1KaT/nmERJ/kpkvUSqF6nRG3m/xAfq5/jrceJZWV5unA+eN5BrRLN3We2LyLQbpApRap1zwziH//s7NxMKRnjzQHUpcsQDx4egNoFbESIYQqVDJ9q0JMxS+/eJ+i2LFvqV3rzjN2myaOlOTsbY4SiXoF0qk5CheNyt9GaJ7Rm/uAwx+DayTw+4mmW1kWd3cyQK5qf5XoBe/Gw6XgudOAdlUQTx3Hj/cSReW90M/W1aDUWVpx/3Y7ruUWaDXrkzU/HsQXIWe8N6JGO8wbpY4dqPXtPicvmMcvPX1uuyUGww8aV6FbQEFnq3tC3btu/lPHMkyLK8i8xY9t1zII5/VFPJgGRz8USf6AE4UYAVZP66t9yJHAstG8IJ1qOwKIUw3/t1KZ91iQSUkIHtvhr70vOTGYurIen/Zpa2jcsCygkC6oY9NPvLg7wJbHZFHeKK/dMop
 G4JnpgXw
 wpi0TJryeDfbLOUo3TzutYsfMxcCVd24GYMLfbKPyBs3jC9TWO7UzBfcky9mJY4ePo9ytrEDcJ81sFFJciycdbyhgtpcPiMzHBjDJh+JD7azlQbt+fYYljYs80xZ1si6R1BPgBv0g5Y+tf4AsYgG9ccSBKlSv4XtF1+Z5acazqyDpGg4XImZmVvGviWoHKFqMfqJA/KwgEQJptG2yaZbXQZPRGdpvpA2UOWTUP27tLZu58Kur1xDAIG5vSTUYjkGjDaxFJ198FsCi201C0e//+mbzYnFHqsgw5axvGqum4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    cc2b5f627e8c Add linux-next specific files for 20260714
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17122649580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2290ccbf984c524f
dashboard link: https://syzkaller.appspot.com/bug?extid=681e729b2cf0d4860042
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11908cc6580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1042ec9e580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6836f8efb1da/disk-cc2b5f62.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0109d3477cc7/vmlinux-cc2b5f62.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c2e49e350bbf/bzImage-cc2b5f62.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+681e729b2cf0d4860042@syzkaller.appspotmail.com

------------[ cut here ]------------
debug_locks && !(lock_is_held(&(__rq_lockp(rq))->dep_map) != 0)
WARNING: kernel/sched/sched.h:1652 at lockdep_assert_rq_held kernel/sched/sched.h:1652 [inline], CPU#0: syz-executor108/5647
WARNING: kernel/sched/sched.h:1652 at update_rq_clock+0x34d/0x560 kernel/sched/core.c:865, CPU#0: syz-executor108/5647
Modules linked in:
CPU: 0 UID: 0 PID: 5647 Comm: syz-executor108 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:lockdep_assert_rq_held kernel/sched/sched.h:1652 [inline]
RIP: 0010:update_rq_clock+0x34d/0x560 kernel/sched/core.c:865
Code: 48 c1 e8 03 80 3c 28 00 74 08 48 89 df e8 8b f0 9d 00 4c 01 3b 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d e9 85 e6 bf 09 cc 90 <0f> 0b 90 e9 42 fd ff ff 48 89 df 48 83 c4 10 5b 41 5c 41 5d 41 5e
RSP: 0018:ffffc90004e9f618 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8880b873b880 RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffffffff8dbfaa0e RDI: ffffffff8bcbd080
RBP: dffffc0000000000 R08: ffffffff8fd0c47f R09: 1ffffffff1fa188f
R10: dffffc0000000000 R11: ffffffff819e4d80 R12: 0000000000000001
R13: dffffc0000000001 R14: ffff8880b873c748 R15: ffff8880b873b880
FS:  00007fb5334a16c0(0000) GS:ffff8881259f2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5334a0ff8 CR3: 0000000034948000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 pick_next_task kernel/sched/core.c:6335 [inline]
 __schedule+0x3774/0x5530 kernel/sched/core.c:7146
 preempt_schedule_irq+0x4d/0xa0 kernel/sched/core.c:7553
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x8f0 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:__outb arch/x86/include/asm/shared/io.h:22 [inline]
RIP: 0010:rtc_cmos_write+0x13/0x20 arch/x86/kernel/rtc.c:97
Code: 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 53 89 f3 89 fd e8 51 9f 59 00 89 d8 e6 70 <89> e8 e6 71 5b 5d c3 cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90004e9f970 EFLAGS: 00000293
RAX: 000000000000000f RBX: 000000000000000f RCX: ffff8880350e3e80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e3c3880 R12: ffffffff8dc427d8
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffff8880b8723f90
 smpboot_restore_warm_reset_vector arch/x86/kernel/smpboot.c:162 [inline]
 arch_cpuhp_cleanup_kick_cpu+0xbf/0x150 arch/x86/kernel/smpboot.c:1129
 cpuhp_bp_sync_alive kernel/cpu.c:449 [inline]
 cpuhp_bringup_ap+0x90/0x360 kernel/cpu.c:843
 cpuhp_invoke_callback+0x434/0x810 kernel/cpu.c:194
 __cpuhp_invoke_callback_range kernel/cpu.c:972 [inline]
 cpuhp_invoke_callback_range kernel/cpu.c:996 [inline]
 cpuhp_up_callbacks kernel/cpu.c:1027 [inline]
 _cpu_up+0x2ce/0x5b0 kernel/cpu.c:1674
 cpu_up+0x1d2/0x220 kernel/cpu.c:1706
 cpu_subsys_online+0x67/0x280 drivers/base/cpu.c:61
 device_online+0x181/0x1e0 drivers/base/core.c:4308
 online_store+0xd7/0x1a0 drivers/base/core.c:2879
 kernfs_fop_write_iter+0x3a5/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x17b/0x530 arch/x86/entry/syscall_64.c:85
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb5334ea0a9
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5334a11d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fb53359ab58 RCX: 00007fb5334ea0a9
RDX: 0000000000000001 RSI: 0000200000000180 RDI: 0000000000000003
RBP: 00007fb53359ab50 R08: 00007fb5334a16c0 R09: 35203a6b63617473
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb53356c378
R13: 0000200000000100 R14: 0000200000000140 R15: 0000200000000180
 </TASK>
----------------
Code disassembly (best guess):
   0:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	f3 0f 1e fa          	endbr64
  1b:	55                   	push   %rbp
  1c:	53                   	push   %rbx
  1d:	89 f3                	mov    %esi,%ebx
  1f:	89 fd                	mov    %edi,%ebp
  21:	e8 51 9f 59 00       	call   0x599f77
  26:	89 d8                	mov    %ebx,%eax
  28:	e6 70                	out    %al,$0x70
* 2a:	89 e8                	mov    %ebp,%eax <-- trapping instruction
  2c:	e6 71                	out    %al,$0x71
  2e:	5b                   	pop    %rbx
  2f:	5d                   	pop    %rbp
  30:	c3                   	ret
  31:	cc                   	int3
  32:	cc                   	int3
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

