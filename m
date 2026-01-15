Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 881AFD46623
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B576B008C; Thu, 15 Jan 2026 15:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8C56B0092; Thu, 15 Jan 2026 15:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF88C6B0095; Thu, 15 Jan 2026 15:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC63C6B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:48:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 521CC1B9EB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:48:23 +0000 (UTC)
X-FDA: 84335386086.23.DE5CD7C
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D808A0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:48:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3lFJpaQkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3lFJpaQkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768510101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=GD/RuU5EoNrflnI+a0Wb0KVlwFSd36TYhdXaFuoMDO8=;
	b=OCm/iiYoWD0bsDmZnUc91bPMCgmhSNARINwXU+0GTI1M6r3gPn8gaSDFzNyHtP1In8f9bz
	ulK6FfhH4ZgbsJc2cZkrBohht17CeZJSxWwatTGdIuQBRHgsdTboB8sDe9leetokLtTlfe
	H+rxUzKcGkxeAFpNHaoM58jyhuT0/g4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3lFJpaQkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3lFJpaQkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768510101; a=rsa-sha256;
	cv=none;
	b=gK2dBxcL5VjniRYAwkTW/Bl3jkR1yXiVr8XxFRszbg7G8UWURvXmPa4cMWm5w0+vxkqOrp
	vZNaEFyNx/ATxv1QKqQOvHcHrwETj8gQeDvcQ1YnHDYW/1Y1zRW4tbDNlSUiNjwCJufIRe
	q9WlpdTSRJ3aWcSRFa8yXTpZLSfM5p4=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-66102e59148so4675911eaf.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768510100; x=1769114900;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GD/RuU5EoNrflnI+a0Wb0KVlwFSd36TYhdXaFuoMDO8=;
        b=bV9sXbLJ73eTng6dBA5gvZJpSpOanKuhQV37EE5U8k3OyV9OUqr0N+ng2tIWBf2qG3
         ojY01l+KLhWDKJ5TOBUmmBFzp8pGA9k6C6sEZaU8sFhz5MbFWyvBfaG5m/HDHtsG8QQh
         cEcCh2AYlFgr0ptXTCnl30+7IogbgRycx2Hluv1l8FlRXJY3KWMRyHWljrQAE6cGpPJE
         pId5dx8ya+7XJcLE+Ed+alcA7IM3ATb4p8QP5f7qVsmND5vKL+Lpzaf+Ri/2Et1gBzgz
         ob5oG7SgqI8mMFT0Z6pcGCf0XS3NtRkrkvhe2EXq93etbeBX211dTe4fWqMeg1IqOmpO
         8E0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUibuRee1nGTxjNrogu/WBP4NKcG967CtBn0A3+9OZ5bnOleungHAzAm+Y4pppB1pDAuxotI49z2g==@kvack.org
X-Gm-Message-State: AOJu0YxhBydzW3NR5qO1R7kBr7+i8nPRdh0ZswIs3eEuSyiC+JTKxRYP
	EoJ2hhATbBI6NBA/lUkwkclR6VTlTkZRB9lLv7sLNYXYcQAAy2x11WYlLwnaM2cM+4C5M+ENP8d
	3x2sMFufpnJq9wgfTs9dvHFJz0LkLerK8RgWdO8Wscj4XcLxS8xy/hKQyDI8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:229d:b0:65b:f0da:31c0 with SMTP id
 006d021491bc7-661179faf4bmr532414eaf.55.1768510100572; Thu, 15 Jan 2026
 12:48:20 -0800 (PST)
Date: Thu, 15 Jan 2026 12:48:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69695294.050a0220.58bed.002c.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: slab-use-after-free Read in lookup_object_or_alloc
 (3)
From: syzbot <syzbot+62360d745376b40120b5@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: nfeyeeip6makroyogygk9xa5c6ezhb5j
X-Rspamd-Queue-Id: 9D808A0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768510101-550163
X-HE-Meta: U2FsdGVkX18qshZOvAmwBWinYu6LULqL83LOf3OSiFrKntttevjaz3Kor+NTZ4V357IT6CGdaiN8QU2ozjRW0wUHXMdK6XpLaRLdNyVe93T/UjBwEfqIS0uwgCv/7gIUjmJZ7aNQXe1GtS4dBw5uWLNW3r1La3vo63DV1N4GQ/EsFfTwRbsxb2U8oTlbzcU7DXVjIxgMDSgAHW7S7lsLMPmCZLu4Y8RwxIZLHP239MXGUMoVLz2yMTGIKpBGJYasT9MlVzJHFRc3xUWvV7HBCQ3t10Dm2t9VrbnfBc0pyllAEHcnfX5aAgk5OAL5RlzQYTMSo+jK0xPGv9O7fTuIUKflG9efWiAW3KigAHspysOSn9nQC3sDtJC6YY9acgnfwDrIvVaUgsMYB1z+3AC0oGx0f0H5EGsSdqaNfknaMsZigq5taAaB5BWDtozoliTVUT7XbI3bRCRXxH3DzQ8VGLEbYWlpf4RIgjPVk+7vQukNvY2tqoq8YBQv5Hh1gJUidsl0BvRQEUbJJ0H8yHyAbIFTSuj9YqxIIVW1aNechbb1gAqMhHMXO/d9gTJ6dZfOeoiT8Of67p8m7fB5hok+6R+qMSgf6fl/cACMaVWAIfxnE5B7kSNthTARYxTD4JlNtg4bu8ab6stQsHzf7Sxdxx0fJp1b33fb8m5JJROtLdaarEzpUoVSdW1MDBe4A5MmH+IBw+8Lw4GQ3uvbgVIYHABoQlTVMBNPnTVtz6XkxHagEV7x1nQhLd09EeDcnfon0Ix/+As4LIrLhAMaXUgzwtQpHdIY92gN6Y0ULl/9AijY9yOMz/ngTyK7TghiMCmwc1p8CJId7L3uySXFU3lKUq6VWpbT/MdaJN/W4nULkrWxZ3oCtT1Op1IgpHHso26i1cRzl6kl7hPngdeUBJPN2AX/fpzlGXRC6cnvWUaqfHhB9bpJ+1gpA7GkvLsDKsIhIHkBZ17eyZoSKFgXIQi
 WHPR7XBQ
 4S2wncBEk/53MClIVZlpxta8k/4MeVHU3oYwmSBdiDOT/BzqQwqTCC9JOJ3f8TeHCoVNM+9sTbGXr3A1ft1KWriYAGycHC/nJ2mmTtoqURbSEi98WN0guo+qN6IHRpboA68DnuHFsUpYrRuSFy+n/KAasM+DpbTXHnUOkiGgTJb/yMugmQPTmaVdgiUqC4FYhQ6esp5vqb+Ndw3xCBynhJdkEBQVlIK229rMQnVBApfgdKcBwaP2T+vQkLKbXGPcPHEiM+ZQOy7fGCvjpLXOoMwhmG1Unsrc0tX3UCXwKlKfzDK+pZt5EnJ64qMwqklBtFN7UGj51g6wIj5Vy6SDBj+O8FmbV1ATuZQYzXD2gWVIEtTqLlAjYOjUmm9PhfbD9EWHRAG9thhNeqsflzeaaTAFX8aPsN5bo5tsIUgZU7k6XSkrN0k0I3wGZWEBLTMkmPMjZo9hnuWBQDjPOLYt0PU8gu4QzaDs4CLESnGBttUi8C4S98QFb+241cR7NoHr+g73yUfy4ZMNV++X9xNKXWt6jqkTCiSciLLVfr5WEj4GlM5ImNRyyGZ37o8zRywnZwsz8YecYmncfeaPSqSHsfWcPpLptKOr6anwZ2+LzPFBTexUN0qqVrconupVY/HXdYtRA2lQqW9YV+2x5EmhDOQeOdnIUEarfiIeOwq7lB1Aw3pmARSR7i2Yqmm/yB+P3rwjy6wP17leTz1Dm1Gh9+KTAxef2Bqv1VAUS05nf12D9pHlhK48nvgV4RBzhMmQDV9M6XrtCb616TppApKsCGxUiHzrKJeyPpxH6Dj9d4aevZFWUhhqJCsxe9ufLqbI7deAKYEs7SmOcSEAETLntcqF8LbI9Jv84DfgP26e9gx1fyv4ew/3mptOFJ3zZZEYKGAetV8v9AGkwPRfPiEEtcCc5Sg9bZQ0CfV1oCErOpVXDBvUX1kdOWriMj+l3DsftaiK6So1dsIiPD8GWyzT0YYRSlZ8n
 eAZ73Kxe
 qZbNF3p8iA3asKMssHDTvNzzXasv4yjK6OApeeAJClqXcFMugcQqAUhe3IU2bg2v9cO+37Js7MU3iqpKxpHWLYwDOv9ZMciJXfFNr0idObuHoH97PHArrTYTxqj6HCVrIUHA8iE6F6eEPcvHgTpl1hnj3SugDmllsQzRYsAVkLZwH9G9slDZmZNeXGRB8vDOzBWhvjJZSz+0lSID7db+hW1ODj2odi6iNwvWjzZziNkJxKHf8PH2zl6PfRwIX0RSfm0TUwQDIno1Zx/cP3mFDLL5JGWwVcQY5k/vaL2PCiV32+P49wKsWMqypUQfFNGCFTTNTHdJaUZZXnmVUg3FT09WmIodQvhCi4/Jjic6Oun3KqIejf5vvp7CVoLwwuuSOejg4Gq958Hs+/N9l1B3O7mI9Qo6Abq5p1WIK5uLE2A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    79b95d74470d Merge tag 'hid-for-linus-2026010801' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11895f92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
dashboard link: https://syzkaller.appspot.com/bug?extid=62360d745376b40120b5
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4d234fb6afe1/disk-79b95d74.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bb336424f007/vmlinux-79b95d74.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e8dee85fdda1/bzImage-79b95d74.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+62360d745376b40120b5@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in timer_is_static_object+0x80/0x90 kernel/time/timer.c:691
Read of size 8 at addr ffff88807e5e8498 by task syz.4.6813/32052

CPU: 1 UID: 0 PID: 32052 Comm: syz.4.6813 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x630 mm/kasan/report.c:482
 kasan_report+0xe0/0x110 mm/kasan/report.c:595
 timer_is_static_object+0x80/0x90 kernel/time/timer.c:691
 lookup_object_or_alloc.part.0+0x420/0x590 lib/debugobjects.c:679
 lookup_object_or_alloc lib/debugobjects.c:665 [inline]
 debug_object_activate+0x326/0x4c0 lib/debugobjects.c:820
 debug_timer_activate kernel/time/timer.c:793 [inline]
 __mod_timer+0x814/0xd30 kernel/time/timer.c:1124
 add_timer+0x62/0x90 kernel/time/timer.c:1249
 call_timer_fn+0x19a/0x5a0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers+0x74a/0xae0 kernel/time/timer.c:2373
 __run_timer_base kernel/time/timer.c:2385 [inline]
 __run_timer_base kernel/time/timer.c:2377 [inline]
 run_timer_base+0x114/0x190 kernel/time/timer.c:2394
 run_timer_softirq+0x1a/0x40 kernel/time/timer.c:2404
 handle_softirqs+0x219/0x950 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x31/0x80 kernel/locking/spinlock.c:194
Code: f5 53 48 8b 74 24 10 48 89 fb 48 83 c7 18 e8 16 fe 1e f6 48 89 df e8 ce 50 1f f6 f7 c5 00 02 00 00 75 23 9c 58 f6 c4 02 75 37 <bf> 01 00 00 00 e8 d5 53 0f f6 65 8b 05 2e b9 37 08 85 c0 74 16 5b
RSP: 0018:ffffc90005137760 EFLAGS: 00000246
RAX: 0000000000000006 RBX: ffff88803400d880 RCX: 0000000000000006
RDX: 0000000000000000 RSI: ffffffff8dace187 RDI: ffffffff8bf2b380
RBP: 0000000000000246 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff9088b8d7 R11: ffff888046ec54b0 R12: ffff888022b76000
R13: 0000000000000246 R14: ffff88803400d868 R15: ffffc900051378e8
 spin_unlock_irqrestore include/linux/spinlock.h:406 [inline]
 __skb_try_recv_datagram+0x172/0x4f0 net/core/datagram.c:267
 __unix_dgram_recvmsg+0x1bc/0xc30 net/unix/af_unix.c:2576
 unix_dgram_recvmsg+0xd0/0x110 net/unix/af_unix.c:2675
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 ____sys_recvmsg+0x5f9/0x6b0 net/socket.c:2810
 ___sys_recvmsg+0x114/0x1a0 net/socket.c:2854
 do_recvmmsg+0x2fe/0x750 net/socket.c:2949
 __sys_recvmmsg net/socket.c:3023 [inline]
 __do_sys_recvmmsg net/socket.c:3046 [inline]
 __se_sys_recvmmsg net/socket.c:3039 [inline]
 __x64_sys_recvmmsg+0x22a/0x280 net/socket.c:3039
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdc3eb8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdc3f959038 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007fdc3ede6090 RCX: 00007fdc3eb8f749
RDX: 0000000000010106 RSI: 00002000000000c0 RDI: 0000000000000005
RBP: 00007fdc3ec13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdc3ede6128 R14: 00007fdc3ede6090 R15: 00007ffd6a8a5748
 </TASK>

Allocated by task 29852:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kmalloc_noprof include/linux/slab.h:957 [inline]
 rose_add_node net/rose/rose_route.c:85 [inline]
 rose_rt_ioctl+0x880/0x2580 net/rose/rose_route.c:748
 rose_ioctl+0x64d/0x7c0 net/rose/af_rose.c:1382
 sock_do_ioctl+0x118/0x280 net/socket.c:1254
 sock_ioctl+0x227/0x6b0 net/socket.c:1375
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 32051:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6670 [inline]
 kfree+0x2f8/0x6e0 mm/slub.c:6878
 rose_neigh_put include/net/rose.h:166 [inline]
 rose_timer_expiry+0x53f/0x630 net/rose/rose_timer.c:183
 call_timer_fn+0x19a/0x5a0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers+0x74a/0xae0 kernel/time/timer.c:2373
 __run_timer_base kernel/time/timer.c:2385 [inline]
 __run_timer_base kernel/time/timer.c:2377 [inline]
 run_timer_base+0x114/0x190 kernel/time/timer.c:2394
 run_timer_softirq+0x1a/0x40 kernel/time/timer.c:2404
 handle_softirqs+0x219/0x950 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

The buggy address belongs to the object at ffff88807e5e8400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 152 bytes inside of
 freed 512-byte region [ffff88807e5e8400, ffff88807e5e8600)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7e5e8
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
ksm flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88813ff26c80 ffffea0000a54f00 dead000000000003
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88813ff26c80 ffffea0000a54f00 dead000000000003
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000002 ffffea0001f97a01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 29165, tgid 29165 (syz-executor), ts 2066518998187, free_ts 1956315063990
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1af/0x220 mm/page_alloc.c:1857
 prep_new_page mm/page_alloc.c:1865 [inline]
 get_page_from_freelist+0xd0b/0x31a0 mm/page_alloc.c:3915
 __alloc_frozen_pages_noprof+0x25f/0x2430 mm/page_alloc.c:5210
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab mm/slub.c:3248 [inline]
 new_slab+0x2c3/0x430 mm/slub.c:3302
 ___slab_alloc+0xe18/0x1c90 mm/slub.c:4656
 __slab_alloc.constprop.0+0x63/0x110 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_noprof+0x4fc/0x910 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 fib6_info_alloc+0x40/0x160 net/ipv6/ip6_fib.c:155
 ip6_route_info_create+0x14c/0xaa0 net/ipv6/route.c:3820
 ip6_route_add.part.0+0x22/0x1d0 net/ipv6/route.c:3949
 ip6_route_add+0x45/0x60 net/ipv6/route.c:3946
 addrconf_add_mroute+0x1dd/0x350 net/ipv6/addrconf.c:2552
 addrconf_add_dev+0x14e/0x1a0 net/ipv6/addrconf.c:2570
 inet6_addr_add+0xfe/0x9b0 net/ipv6/addrconf.c:3032
 inet6_rtm_newaddr+0x1619/0x1c50 net/ipv6/addrconf.c:5059
page last free pid 27669 tgid 27669 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0x7df/0x1170 mm/page_alloc.c:2943
 __pagetable_free include/linux/mm.h:3200 [inline]
 pagetable_free include/linux/mm.h:3224 [inline]
 pagetable_dtor_free include/linux/mm.h:3328 [inline]
 __tlb_remove_table include/asm-generic/tlb.h:220 [inline]
 __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
 tlb_remove_table_rcu+0x2b2/0x390 mm/mmu_gather.c:290
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0x79c/0x15f0 kernel/rcu/tree.c:2857
 handle_softirqs+0x219/0x950 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

Memory state around the buggy address:
 ffff88807e5e8380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807e5e8400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807e5e8480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88807e5e8500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e5e8580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	f5                   	cmc
   1:	53                   	push   %rbx
   2:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   7:	48 89 fb             	mov    %rdi,%rbx
   a:	48 83 c7 18          	add    $0x18,%rdi
   e:	e8 16 fe 1e f6       	call   0xf61efe29
  13:	48 89 df             	mov    %rbx,%rdi
  16:	e8 ce 50 1f f6       	call   0xf61f50e9
  1b:	f7 c5 00 02 00 00    	test   $0x200,%ebp
  21:	75 23                	jne    0x46
  23:	9c                   	pushf
  24:	58                   	pop    %rax
  25:	f6 c4 02             	test   $0x2,%ah
  28:	75 37                	jne    0x61
* 2a:	bf 01 00 00 00       	mov    $0x1,%edi <-- trapping instruction
  2f:	e8 d5 53 0f f6       	call   0xf60f5409
  34:	65 8b 05 2e b9 37 08 	mov    %gs:0x837b92e(%rip),%eax        # 0x837b969
  3b:	85 c0                	test   %eax,%eax
  3d:	74 16                	je     0x55
  3f:	5b                   	pop    %rbx


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

