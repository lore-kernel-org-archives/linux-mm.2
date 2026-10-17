Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7280DCCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 11:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7E16B0088; Sat, 17 Oct 2026 07:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179D16B008A; Sat, 17 Oct 2026 07:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F406B008C; Sat, 17 Oct 2026 07:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA0B36B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:54:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5510D1C1933
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:54:23 +0000 (UTC)
X-FDA: 85331960406.14.B813DD5
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9891140005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:54:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 37GHTagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=37GHTagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792238061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=N64X2OcIzS9yPUZflO6NWWeuTGYK2vLbz/Wd34HgXaA=;
	b=1mCCo/rtmHaDgLp8Pgnp7P4lclY4yU2k0l7tfy9rQWERd52qVoKu91GCZp40eCMBAHE2hu
	+HO5oemvMCUB/db06UCJKEqJlr7cRXVqu0pCK3dPGS4rGOOmiamOVNosJiGNjfT/bjhdKo
	z+jm9IA5Z84ixImvz+G/D2fk6RLD5RE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 37GHTagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=37GHTagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792238061;
	b=M9kGDFJpZqBYOHm7JhxnqEF1H83NQolqZHlkYxP6QwnZ2wCOo5Ir6sq5W9JbtSe653EyxU
	+YCqhXbRWC7q7o+XdQeURDutCgzcACyXI3Eu0Fw59QrdZscLhlaXZiQGllhqVYVl+XkpDQ
	MscrOne99E8dSxpyc5kmtkM/If7tjpo=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4cc89e86e9eso1246793b6e.3
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792238060; x=1792842860;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=N64X2OcIzS9yPUZflO6NWWeuTGYK2vLbz/Wd34HgXaA=;
        b=d+/S4078XDSsQdCX//Ywoll4TkcnVBeN0PYoUb02t41cafLvsN40wWx4UVUGBikYrb
         u3z3euBGRuAiNDwVLPFcbVqYFhfeU5Uw1YEqTgUtbVBPJC/zEfW9kL8Eb/z7gJgUDiU0
         aF6w7N6W4iG9jnh3g/BMgrS9qYLjewBMOdjZZOTz6sbDVdELiCTWOiFC2M6aIR/scD2Y
         8Di0ktg1IUVuushu/5U6xXm5Ke0oAxiQRBckXjIvHgXMg1kszdf/DQCnZ+lnYv7AkkSn
         NfSvXyJHj0rNKpNf9xlfHDja5rx4nMBpXUOHWHJdJBQeArNMn8AV9S0+gMf+IVZ5XXAp
         EDVg==
X-Forwarded-Encrypted: i=1; AKwUvBwprTVyHKO2KvFe6AwRkWzdrEQYCofmEWQWsuxmROgHvGS4RvdB/Vx6BusKYqAFyqYUZpsc36IONA==@kvack.org
X-Gm-Message-State: AFq9FYKgkVBeeqANPqyTJXNfgvHIKE1vyw62p8N1qqR1/lRqbpbE+DlI
	eYa08ZqEPHdZUBa7K/OJ1/hi9MqvP4/aLcs0tx/8Yma8YUlZT/BPklxo8+rdLOkXnVawTQzbYWy
	uXYw+/lMBURyHrIMYgAye23F9lPDaGreNqjog0omFT+hT321tNq4vsGAXS/8=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:11c5:b0:539:a2c2:aba3 with SMTP id
 5614622812f47-53cd7b4bca6mr2040286b6e.52.1792238060691; Sat, 17 Oct 2026
 04:54:20 -0700 (PDT)
Date: Sat, 17 Oct 2026 04:54:20 -0700
In-Reply-To: <6a2c6f6a.be3f099c.2836ae.0004.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad361ec.7952420f.283480.0361.GAE@google.com>
Subject: Re: [syzbot] [mm?] KASAN: invalid-free in rcu_free_sheaf
From: syzbot <syzbot+60332fd095f8bb2946ad@syzkaller.appspotmail.com>
To: alex.aring@gmail.com, alhouseenyousef@gmail.com, andrew@lunn.ch, 
	davem@davemloft.net, devnexen@gmail.com, edumazet@google.com, 
	gregkh@linuxfoundation.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-wpan@vger.kernel.org, malayarout91@gmail.com, 
	miquel.raynal@bootlin.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	patches@lists.linux.dev, peterz@infradead.org, sashal@kernel.org, 
	stable-commits@vger.kernel.org, stable@vger.kernel.org, 
	stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com, tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9891140005
X-Stat-Signature: o41xpsust5ebzen64y3ckmykrauta5tp
X-Rspam-User: 
X-HE-Tag: 1792238061-888741
X-HE-Meta: U2FsdGVkX1++ysWLHn0nZnAEiICDglH4Z6OHvcFTwWOoa9EvQpo53CwiGtkco6v15eMKgWeIq/VVctlot+4EITt2MUg/dZlWn4J38mGh9wGLhAWXjLYW60t5qXKyG9NyY2pxHdvN0Q0/XDA6C6EGDPupLUBIT6A7bsKXYa4HbhEPS26u2bAh0jSsBa72xdD2Wp5nPLTTIh7BSuDzY+ugZScD6sAPrPtWQJyeBRMqxHKzrwuS7Ghd+0qKHm6/z5W3EDmcLE4V02QOeXLHZOmfJOtjXxYLyPq6jKCcqELAWD5arWLNxBUAKmR77cAnQWU3gqgplsH8tZDBR4ddag8P06ECBGm+dXX6+VyYkF26CIgrV1X4FGHqMQXYrA6UghQ4mA9lMix/VVe3HLIEvomiuRll7D4tBu0HYNPI0ZwnN2sk1lRijHGRRJF7NUkFqwj+AvPWN02Mi4rXrtphwIVElqNiDN53YnKZ+K9gTN7+4rt2njSnMpMPTEs70OYATAq0wfVOP6QQ4Rf5ZOpBY+1zV4/T0TlOnAzngglMo/Dtaqy3zfKl8ZSkefCQmQJgYfObXOhG16i7B37/yZx9LoF0jpVJu6SsNQKRpWooizObaXY/+geMVipsa++mcfk7+Q77YSLUWh6+J7djEeoAOdsq15306Jgf7Ak25m06CZ9fpajr5yCUSrtmBJXJvKm/dxx1vdZ9+uSYbj6MXNecYrTX9gXt7q3K0zTKipwvSiiNmT0iDlPBcdf1cxbXA5jVFNMbAs+72RIf3PYT7GCKXFEY+d6BPs8KoGAl1HJVpRWJB47cVdmCygcI0/v1kQF9txHcVyH9QKB9tsTxbfK1qWgljOtat0iZFfSRmqTWNDlFp46pcrKZ6haapkhXzE+3aTnr8g5fuPtJ2U3XHhbaOkY2DkVEI9cLnfVNVbXAc1kLvwVGcUYFgtP2r5VaXvvqlFOeH95lwfiEKlLXmrTcZLm
 yuBsk6MY
 cBy70jcqpmhPxUNJGjIzi7clRHVA3UyiJB0sIBrTa5itJzw5tcXZ/aHjYWl/nFn4txgP9L6NKfZWicXEd0CBeDBazCTFEAXvaHqTecEk3K1LyoZwI4k/dpLoC3e1RfTCBk22L4NVHpDIsmg2vspxBSzxDzo+fcwUP4qXAsz0ZGihzIxPP/aFscFKDfp7a3QAp4y/oBNjTi6AXkEqnHgmlZEToSsO/dTj7w5bbJTztkHMj9y3ERiMsgBMkL8vwCAm3hDIZmcRgurx3UcfBtHraN4VFVcPZRCUG+bh8wvMI82In0GxwXKd4vC0J3dHKRLupUwzNNGZ696PHeaYer/chzsflzzMZe9e3vIfSfM1O7wyrUJ62sc+Bqeu+CUgFv1BMonpPISF+/tFcN7V5dV7sT42LZwUNAKCjPMOoRmy5xO3AqoE9NHefaC4YLzbS8JSPPr5E3jYdeKbC5+A+HOrz70LZqMxSRRJgXqQbVNTm5CL1PA2xcWB8gZZ28bc+/MmTBrPDWWXiCo69aKPTTkDHHgeYdVzbWCQBI0Vl0AWm9IvdY5eE6a5vfkLsHqmvrgFrNkDEFTEssufq3z9COExZuqfVcm3fmhtFREJSO64+yITmp3v83D0a2DuAK6VowBcHiJGA37z14xG2HU6F9FQmxZlGNna66rzPLaRX0IM2WViN3sqky894AmcaX15713wcG6kuswevZYqT6MlZ68+XDcvK6iOdkgcZC/FLsWTNTuaTTM12n3hq1k/ADHt9MMfB6E5WTLg6kfxkIqZfw40CpzRRj+fwmo3bEf7R13BAKV+42zySkgTH/bb3MGJnutPHVnpMK2dDrqFYi/VOeFz3Q41atoxw3ECAc1WavJ6mUcP8lgy6EB435qkD3DsQHzQOkcD93I0ws/6FqkQn1JAqwmSh6c8Zy0KMJ1qmjajeA2TEEog4/99YU0Jcz7uGSbS+mwR+sueNkzlJX5uZlv2vuiGmEZYE
 QRD0qW4u
 /O1q7imQl9ZLcTg8RT2Nj2kUn5JgmDga16LpZVvz+Wq5u1t2ksO1x10jItbXoakJNLmMqq5ClxZ2NdiYyO6cHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    00accbd9d502 calipso: update payload_len when removing the..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
console output: https://syzkaller.appspot.com/x/log.txt?x=159a8121580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c4b098695335c89f
dashboard link: https://syzkaller.appspot.com/bug?extid=60332fd095f8bb2946ad
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1599960d580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60332fd095f8bb2946ad@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: double-free in rcu_free_sheaf+0x31/0x200 mm/slub.c:6061
Free of addr ffff88803149d500 by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report_invalid_free+0xea/0x110 mm/kasan/report.c:557
 check_slab_allocation mm/kasan/common.c:-1 [inline]
 __kasan_slab_pre_free+0x104/0x120 mm/kasan/common.c:272
 kasan_slab_pre_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:2693 [inline]
 __rcu_free_sheaf_prepare+0x10a/0x2a0 mm/slub.c:3009
 rcu_free_sheaf+0x31/0x200 mm/slub.c:6061
 rcu_do_batch kernel/rcu/tree.c:2650 [inline]
 rcu_core+0x926/0x1260 kernel/rcu/tree.c:2919
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 __do_softirq kernel/softirq.c:679 [inline]
 invoke_softirq kernel/softirq.c:519 [inline]
 __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:758
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:775
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
Code: 0b 8b 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 c5 20 00 fb f4 <e9> 8c 08 03 00 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffffff8fa07ca0 EFLAGS: 00000246
RAX: 00000000000a9303 RBX: ffffffff819bed20 RCX: 8000000000000001
RDX: 0000000000000001 RSI: ffffffff8e469bdf RDI: ffffffff8c6ddb80
RBP: ffffffff8fa07d78 R08: ffff8880b8433a1b R09: 1ffff11017086743
R10: dffffc0000000000 R11: ffffed1017086744 R12: 0000000000000000
R13: 1ffffffff1f51e00 R14: 1ffffffff1f40f9c R15: dffffc0000000000
 arch_safe_halt arch/x86/kernel/process.c:767 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:768
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x2e0/0x540 kernel/sched/idle.c:355
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:454
 rest_init+0x378/0x3a0 init/main.c:732
 start_kernel+0x392/0x3e0 init/main.c:1190
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x137/0x1b0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x157
 </TASK>

Allocated by task 977:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 hwsim_update_pib+0x7e/0x400 drivers/net/ieee802154/mac802154_hwsim.c:103
 hwsim_set_promiscuous_mode+0x196/0x2e0 drivers/net/ieee802154/mac802154_hwsim.c:326
 drv_set_promiscuous_mode+0x159/0x2e0 net/mac802154/driver-ops.h:127
 drv_start+0x4ea/0x1010 net/mac802154/driver-ops.h:167
 mac802154_scan_worker+0x8e6/0xe60 net/mac802154/scan.c:248
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 0:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 __rcu_free_sheaf_prepare+0x12d/0x2a0 mm/slub.c:3009
 rcu_free_sheaf+0x31/0x200 mm/slub.c:6061
 rcu_do_batch kernel/rcu/tree.c:2650 [inline]
 rcu_core+0x926/0x1260 kernel/rcu/tree.c:2919
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 __do_softirq kernel/softirq.c:679 [inline]
 invoke_softirq kernel/softirq.c:519 [inline]
 __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:758
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:775
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674

The buggy address belongs to the object at ffff88803149d500
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 64-byte region [ffff88803149d500, ffff88803149d540)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3149d
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88801c0418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 977, tgid 977 (kworker/u8:7), ts 26471963378
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_node_noprof+0x54d/0x720 mm/slub.c:5426
 _kmalloc_node_noprof include/linux/slab.h:1200 [inline]
 __vmalloc_area_node mm/vmalloc.c:3893 [inline]
 __vmalloc_node_range_noprof+0x5b4/0x1540 mm/vmalloc.c:4104
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4165
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct+0x2c6/0xa00 kernel/fork.c:930
 copy_process+0x7e0/0x4400 kernel/fork.c:2134
 kernel_clone+0x2d7/0x940 kernel/fork.c:2771
 user_mode_thread+0x115/0x180 kernel/fork.c:2848
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:169
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88803149d400: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
 ffff88803149d480: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff88803149d500: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff88803149d580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff88803149d600: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
==================================================================
----------------
Code disassembly (best guess):
   0:	0b 8b 02 c3 cc cc    	or     -0x33333cfe(%rbx),%ecx
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
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
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	f3 0f 1e fa          	endbr64
  1f:	66 90                	xchg   %ax,%ax
  21:	0f 00 2d 33 c5 20 00 	verw   0x20c533(%rip)        # 0x20c55b
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	e9 8c 08 03 00       	jmp    0x308bb <-- trapping instruction
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	cc                   	int3
  32:	cc                   	int3
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

