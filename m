Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D4E606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 04:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534256B05E9; Mon, 23 Nov 2026 23:45:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C606B05EB; Mon, 23 Nov 2026 23:45:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44AC36B05EC; Mon, 23 Nov 2026 23:45:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E76A66B05E9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:45:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76520A8356
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:45:56 +0000 (UTC)
X-FDA: 85468775112.14.84C4514
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id C860240002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:45:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3ghYFawkbACMRXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ghYFawkbACMRXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795495555;
	b=GDJNJcMHNCS3NVFu9dFm1qR7rH5KKl6Fsw9qu+lHVuiPa5h0KsKERwsURXTxQX30vlkHn+
	bPEoksD6dmNIPfFhRI9iEOE5PdW+1G+3l2LzepCn93b3MuZl3BNQUahReiGDHrPgMloCka
	LMR74YcV2yU667UR86kXq5kMiTY9NoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795495554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=uyV6ROrO1CtSDtUiRySsm1MrJZ9iaX3jNj12OZgR3iU=;
	b=tnoRUzEhdMsvTT/63pFEK4TrtTJdMaNCtmT4Hoq89Kj+qzgrbj/zUy8gX4XfIWQzKGcbvF
	JwNrUlrlScibWgKtRBq9nR7J422Aity1SXywh7Pe2+YE9Y6scaJjD1v0aNpoGZv7ZQ4uD5
	6/PmqEOokjE+zgjeeI8a5wiLdAgB5YQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3ghYFawkbACMRXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ghYFawkbACMRXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b37620eb73so5522473b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:45:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795495554; x=1796100354;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uyV6ROrO1CtSDtUiRySsm1MrJZ9iaX3jNj12OZgR3iU=;
        b=czpmdehGdZ/svNZ9lHjeVnteuyF0hlrJyNW9+kr71tFPi53OT+eh1q+HmVTpgjepke
         656GD8JS0OFeEFIdQwx5JjHOTeeBrNVzmYvOe2Fdx71ktEfYpwamBUrXHTtsPKVhSQ5S
         DIFFG74hshBhfdVzbiGlxfsbxbXtlPXRm/vF4S85BC8Z8BF7QhvM0caBDDuolKpEH6uA
         e3UF0N3824VOqMwSpapYjFVfMoYZGKb0TDvWRh70ZJ6UbejkAG2w2iBq9Qv38VTWPaNk
         9bi7MI787Rwj24IFN/hvsPpMLlKpE8m1k/xHd1fm5VfZi15K2AuvURaibGUb+qT5QPcD
         lg5g==
X-Forwarded-Encrypted: i=1; AL+hErGjVX2DLZazLFcIRM0wk3ORYf5Ix3JxK5xhhqMKGbYTCbCGO2uhd5tzyQK1D0lpHAH9+KSgztpaeg==@kvack.org
X-Gm-Message-State: APuU4Z9pszOr1FWH7b1XBRsief6lB7MwD7fz5+xsPfOIFg54pU26rVn+
	WHXgEZWOawDKWI2W5CsFuplNBSfAQquhwDl+8jelEggUkn7eC3wx/Rh14tYoSrJs+LiEwH/Rzp7
	bGxfSp5waOvzcanU0qBWPYTium35Frj4ITIYGLJsCgL5CFCrIv0HCFrRpDxA=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f07:b0:4cb:f21b:6f91 with SMTP id
 5614622812f47-57a0a719e9bmr15482730b6e.36.1795495554014; Mon, 23 Nov 2026
 20:45:54 -0800 (PST)
Date: Mon, 23 Nov 2026 20:45:53 -0800
In-Reply-To: <673fdc18.050a0220.363a1b.012c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b051681.58b41460.7037.0590.GAE@google.com>
Subject: Re: [syzbot] [tomoyo?] [mm?] INFO: rcu detected stall in
 security_file_ioctl (9)
From: syzbot <syzbot+b6f8640465bdf47ca708@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net, jack@suse.cz, 
	jmorris@namei.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	paul@paul-moore.com, penguin-kernel@I-love.SAKURA.ne.jp, serge@hallyn.com, 
	syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp, 
	tomoyo-users_en@lists.sourceforge.net, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C860240002
X-Stat-Signature: 9rdf7wyby5tawsx9t9szqsda57879bat
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795495554-743611
X-HE-Meta: U2FsdGVkX19YiJgHwU3A8Bvb+BSxkXLagXopoE43nAMqg+DrOwtJaXlmMkJzmWtSKm7LPI06xhDO8gNOZ1Wp9JBvWokEJVHO3b3BUUOhEPO/zZbQD8LgVOB1hb1YfhGRfuyREmKU3N+LEqz01Y/hp6xXRCFZWy5wGPbFCEgdClY090f14CmrJBwgK/uJ22byWDUvyOOVcAL+7O+A0FFi+3AVtsXpZsZRdiBNZtr42ghhhMgUY8zWJanWrh8YfL+E2RqmrJwzjsYufV+AbzH5y0gbNWDZ4pjl4fO+ItX+2opKJCV1+5jPrWQPoUhSGLl9HVbOiAlthTUC14MpQOZ0uX+AoRRhJGCPQyZnNAFYY5ol9S8vtB/+5RtPg7I/6uyzjfkpA4+B6gH0NUSy6IQ/fbASCwuBe3/YXyJFeh1jmHGWb762yrRgvbH7KxktoWMNlfL1w7F0qNXGBWYMWqB0R4yuI2VIOyOZ/nQRHDVr9FDASSkQ9imYsqG8b6oO6ukGX9YgHMi8+fvbVndTwd/cKA+suTUk2ygVEbtSxh4FLpGWLs5TvTr1RswRJpAQQA1TqUfRNN7Nr3HF+5yFcOnTyZ2EXJNKLQeRkSQcAnKq50/PK5mTKU2YWf1cSpZ4GU7jsnp/6mAHrCQGxEacV9HRiKMydIvlLEm13Px4539JZ+ebSNSHdfn70V1iBSn9eIBcQNwl48umd/vg9Bz3wRMK7ce6NuYfJg9cV0oTfowwmQ3Q7HI3342ndf/0WTSdjU6VVvpAZ8AejKsZABXvXN9DOilhbE29PIsr1EkZ81hSSveix06Y0KH5OGc+iGTTK1pnnQr1TwRM/cWqOJC1Tq41+vZe4K5aeDNwt9KDemr7IlFHMuI3YhzMF0jPPJkse6Azntj1uYbjTKYF6OSibJ84G92W/d8cMWQQ2oEnuMysjzTD51+pys5ikuhg7x8fRpv5PXZBRFF+SvWHWLSptk9
 G89DZf7O
 MvBYy/iQ0+4ObTwKv50VrtQkkHkuHoFuMV2CXL5agMYvuWEFNS4g88oJb/Fq6O5sMFTLWzivnTwc/biwgDjIvUJ0gp7XZMzPXQcag5+42F3ABeDSj66LoyuZNL6/wL7BJ0I7ZezN9y/1l7GSphzS29S23GcLBl30tQnU8P0y5vgMCujjRi4Fvo2YXpfXfWra/X9KCeIF3lNDx/QzAf7ZvfpcGZRIP4Nu3Dg6IrWQzdTQx7AbIN9wJnfkyy86JGHxEsQv5Dt9sqRR1toc5Q8iOsMW7PTxlG8/AtgsX6yKzFXNQWPg2dg0pODWoFmZN4d/ZNpHEJlzFAJhyWs5gebz9pYpUXj9IhjZgD5/5o08g+jTfesSOQyxMZ/1VskWnLncNnRUvkdN34ejKqpw0Kh9FqYa3g59zPttm9aJcg3XclxXWljdL+vM9noITSHz5t8KBpYbDtk8KV2cW4aur6KjfDuo6Kno6PKo49hGwz5f/yowTR8B258lBBKfomvIGODa2AA+x25nwOWPX7BoDPYRmLaPjQ/nwrDF8mC1axg+1Zrb9GEueF4/9bhokLA2PRJUzASwyRxg3V1lmFM2q40rvUrEhULAQNtXs4axA5BzvF1LnJDu2wRQHSfhJswuhOFasur9bEtG4QvjdkxvBeSjGZiY69xJLAHaOJnmFTPBfrofk/BFg+rNXPSyygSV64674DRq7Hsppg3PSgTaltV7M1NNWlfTnxGZWgoBIlConbMUEO7oLjMrdGDFjCkmwjwaXjb92ixxoiae149WggDljB7UNTswbZI5UO8rZM/YctOyrNUguKuVF7c66ZHeXcBgz+or3oeovDo31Btcz85gozg9/qMaNwFbOSlA3vFQHnWg6dlX/mcmMBAFgeaOqjg2pb0l8t8ZG7+mLxr8+cLvhhvTEq8OF1X4we5h5AkKmLOXldHjKf6Tgr3WdEHqb/s+mssltFr9pRuC3ewOkqztgncdoMZFj
 Dp/Hzx6l
 ENA+/1K4+kik3Ga0dLxGe5MHMhln3SQE2w6/TmfAQti6sKrD7YmmWkXzKAcIF2T3E1aEziADdlSw9i7l92DybK1zaEz846YGlMk1ZW2j3+ifveUMni2qDnJkIIQ4g54WmiMhnfJOIEvtYb2gJ0BrJ6ygO7zsK5hTE+PTVxQUGcX6YO0gPOptDBxZumYqaMr9JA4hXUI0jRMKSqDveEB80fBsTycvDSsCh3F83vyDogW/VxcIv9GkN7709uyPOOozaScrkz3TfSfKIo2GXwp0OLhiZKntU31sHEHvSmQwQTyW8age04bjDcr+FgQz9jqcXWz6xKDy5BQ/En2Nj6dRGN2Q+QGrOWoky3Tt/5/I84RAiAnvH983A7iK1J+RszMcy4w/K0R35Xj+BKTp9yVJT8TvbNOXxX5bhD7/uPZZkyuTYeOkZnIOYqnnoSK/JOAQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot has found a reproducer for the following issue on:

HEAD commit:    3896ae4adf5f tun: complete the zerocopy buffer of packets ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16305bbe580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d44b06612b68f56
dashboard link: https://syzkaller.appspot.com/bug?extid=b6f8640465bdf47ca708
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1740f363580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11305bbe580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ca6f81eb80f4/disk-3896ae4a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e88582fee6d7/vmlinux-3896ae4a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a978638f7ba7/bzImage-3896ae4a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b6f8640465bdf47ca708@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (10499 ticks this GP) idle=f474/1/0x4000000000000000 softirq=18751/18751 fqs=4770
rcu: 	         hardirqs   softirqs   csw/system
rcu: 	 number:     5264          0            0
rcu: 	cputime:      138      52351           25   ==> 52490(ms)
rcu: 	(t=10500 jiffies g=18789 q=10129 ncpus=2)
CPU: 0 UID: 0 PID: 5837 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x47/0x80 kernel/locking/spinlock.c:221
Code: f7 e8 3d d4 99 f5 f7 c3 00 02 00 00 74 05 e8 10 79 c6 f5 9c 58 a9 00 02 00 00 75 29 f7 c3 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> c4 c4 8a f5 65 48 8b 05 8c 0d d7 08 48 85 c0 74 18 5b 41 5e e9
RSP: 0018:ffffc90000007e18 EFLAGS: 00000206
RAX: 0000000000000002 RBX: 0000000000000287 RCX: 0000000000000101
RDX: 0000000000000003 RSI: ffffffff8e6a85cd RDI: 0000000000000001
RBP: ffff88807ed35538 R08: ffffffff91be1bbf R09: 1ffffffff237c377
R10: dffffc0000000000 R11: fffffbfff237c378 R12: ffff8880b8228600
R13: ffffffff89fd0480 R14: ffff8880b8228600 R15: 1ffff1101704514a
FS:  000055557acc5500(0000) GS:ffff8881233ff000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005612e0743768 CR3: 0000000077760000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:2075 [inline]
 __hrtimer_run_queues+0x2bf/0xa10 kernel/time/hrtimer.c:2136
 hrtimer_run_softirq+0x1e3/0x2e0 kernel/time/hrtimer.c:2153
 handle_softirqs+0x265/0x8d0 kernel/softirq.c:669
 __do_softirq kernel/softirq.c:703 [inline]
 invoke_softirq kernel/softirq.c:542 [inline]
 __irq_exit_rcu+0xc6/0x220 kernel/softirq.c:786
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:809
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:lock_acquire+0x232/0x350 kernel/locking/lockdep.c:5947
Code: ff ff ff e8 50 07 64 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 65 48 8b 05 12 e1 3d 13 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d 37 27 1d
RSP: 0018:ffffc9000326f700 EFLAGS: 00000296
RAX: 3c7ff0ca9698f600 RBX: 0000000000000000 RCX: 0000000000000046
RDX: 000000000e8f2ff9 RSI: ffffffff8e936150 RDI: ffffffff8c8e9880
RBP: ffff8880281e8000 R08: ffffffff817889cf R09: 0000000000000000
R10: ffffc9000326f838 R11: ffffffff81b3b880 R12: ffffffff9015a2e0
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1216 [inline]
 unwind_next_frame+0xac/0x2550 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3f/0x90 mm/kasan/common.c:79
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:599
 poison_slab_object mm/kasan/common.c:267 [inline]
 __kasan_slab_free+0x70/0x90 mm/kasan/common.c:299
 kasan_slab_free include/linux/kasan.h:239 [inline]
 slab_free_hook mm/slub.c:2780 [inline]
 slab_free mm/slub.c:6637 [inline]
 kfree+0x1c7/0x650 mm/slub.c:6930
 tomoyo_path_number_perm+0x4ba/0x5f0 security/tomoyo/file.c:741
 security_file_ioctl+0xc3/0x2a0 security/security.c:2534
 __do_sys_ioctl fs/ioctl.c:592 [inline]
 __se_sys_ioctl+0x47/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2e4e9a91ab
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007fffff379100 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f2e4e9a91ab
RDX: 00007fffff379160 RSI: 0000000000008933 RDI: 0000000000000005
RBP: 00007f2e4ea394f3 R08: 0000000000000000 R09: 00007fffff379470
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007f2e4f764620 R14: 0000000000000006 R15: 0000000000000000
 </TASK>
sched: DL replenish lagged too much

