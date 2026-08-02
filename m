Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7315C5516F
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 00:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCC66B007B; Sat,  1 Aug 2026 20:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156D96B0088; Sat,  1 Aug 2026 20:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DF96B008A; Sat,  1 Aug 2026 20:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C95616B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 20:00:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45329C03E5
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 00:00:36 +0000 (UTC)
X-FDA: 85054372872.06.5F29108
Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99D40140015
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 00:00:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3oYhuagkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.205 as permitted sender) smtp.mailfrom=3oYhuagkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785628834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=rcjUvSgLwh50//vBrNZydN3/5lJfhx/xxmZpzcHLEYM=;
	b=cHPtUZmNxn1YGyByXIsOBHif+JAfTBpyRIzocP3C1BcALrknEcZabdbhpg++a2fJyG1l1t
	11OSxJuvrS+HhOmSWHX94qNq21WBHC07KpBH7G8yoKq/GpmLpFWE/09WvGDfJMPQdpmuev
	XiNqIQOqIZ9w9/RYYn1jUOj2cZND2ls=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3oYhuagkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.205 as permitted sender) smtp.mailfrom=3oYhuagkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785628834;
	b=Tujtsv9K69o+rAuxCTxSCFNbHQIhDzSTSw6IcRUNwfIkDhUeANrCg2ldPXQuKQXD1Yq7pd
	ikhyI6qFWR4dVx1Glv6sZvBNN4yk/GC9QtyUcdqmHaRhrFeRxm/4hMBlNrzE/9NsFB6ta4
	YuTLgS0FEtwehojCVbbVWJtQLCTUcrY=
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4ab8b4887d4so1574991b6e.1
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 17:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785628833; x=1786233633;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rcjUvSgLwh50//vBrNZydN3/5lJfhx/xxmZpzcHLEYM=;
        b=cXjYTSWVu8ZjQiYfS83dwVp5jkSuYEe6qGXFkDsvfL+ffBzOx8+kTTxxiEIV/GuSKz
         3qtugFwGcv5puS54YFZv6kapdqFVu8vQZ4p+cKH63xhz5WOatpKt3aWJaMftL8Mf04vL
         pIgkzUtyr4Y0DNHGIZ7LOCVTmqok73f/GjJClTXb3j/gkNLx/on1q/AZUxk5Msbj/sob
         La+Yu/T19n0OWlwgiFAjrBrvUiaOMOR9WADWUJ++wWGbpIcbhynf3zaxtQMW5pemCemP
         PrN8oSiAvGy9RnPK4ODjwHcGic1v3MwHo8BeTEb7FqidqlVMPxsL18+J+ul4li4pNRIP
         Bwxw==
X-Forwarded-Encrypted: i=1; AHgh+Rp/6seFfLlEftulk3RQTsX5S8EwZWb8ab95MzbqpcUEsrdDMxA/ZZBqc+JhJZBJlarBZP+yy9sy8w==@kvack.org
X-Gm-Message-State: AOJu0YyWUm23D8Bfj8UW/mC6BHFbscCI7ufOAU7Sk32QVV28fw7Kyg2P
	skCixRabY9A7rHvLvJEpakNZpA6tWwUq/oZTBwLGbP22pGEC6kF24aitsSuSxy9G4KegM0c+0Eh
	FxyWS7LQoT3FOFTLWYwzhmvG7HLAPNMLbGgKuQoXRrIZ9WrieRLAs2Zpr0MM=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:238b:b0:495:ce61:4e0c with SMTP id
 5614622812f47-4af5dfd106fmr9779571b6e.3.1785628833595; Sat, 01 Aug 2026
 17:00:33 -0700 (PDT)
Date: Sat, 01 Aug 2026 17:00:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6e88a1.13bfb6d0.1ecdd5.0260.GAE@google.com>
Subject: [syzbot] [mm?] [kernfs?] INFO: rcu detected stall in netlink_sendmsg (6)
From: syzbot <syzbot+508388c85f7a82cbd79e@syzkaller.appspotmail.com>
To: driver-core@lists.linux.dev, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 99D40140015
X-Rspamd-Server: rspam01
X-Stat-Signature: jhnxs8ma95wh6sakfujx5goio4so5rjm
X-HE-Tag: 1785628834-132649
X-HE-Meta: U2FsdGVkX1+ZDu9WMgEd10Q//6TnZb+Ck6+UyuGrwW4tHe+XJ0wrc+TcMorGZBrBwWiN59cnMCDTP7nAF5tmPostny1pe5mMiLe7MkvcenXbvh99eeO3itdvfRbL4JIY7vWABAqEonGoA1PhsB8Z5amwqs510hYWodWnQDxigS/u18qUQ0mjn7sY915IkOyRyavXo7kKZUCU4vCzWyZ4dGl7ElfY8+AnVraSxwOlxezObmQ48DXG2PvyiUJhXWUC+MvcsC38riJbwBf1uC9MoMnQ2Wi+evx96UflT0I+g6uCBygFVQNPmVAsi6zjQeX9OW6F6n7Ar4WiH3C16qnXA+HxxYMmwE6rMOl57SBMhWrzFlO1nZQQP30+fC2BYl/wID1h7apnntfOpx/yKSn2/FopzwFRMXXLXK1tqTpEWuAAYp7GhO7PRi6wqAqxHAnTf20eBxR8WRLsLBIlkPuKfhncxevjaVuXzPtmA+EccPKirinn7muae/buFq2XZjsLmx9ikilarFDIccB7i8JmB2ysuiYQ5gkCezPXRBfiP4b3mYjZIg7yuF398anyXHVT+Sg6SLm2nKf2DDFr9OJRT9GUc2SR54ZOhAa7M6wVs2lnRrBhU/0issh1Mk9kJ6Klc3oMgPEsqfyHbLvLYEYxOQBjxi9l2wIQea23l6BMdq1kFRtbvxYoalZnzRvK1draUfrtG30K8vzLzo002p4FvmLZM8ZcEts0nw+K7+USa42UDdXKBmGOBmTbnATqDsmhXMZr6RGjx6d2Dtt5+xvz/UE39HeMgl7DccKK7qKKTN8mjVbHiDh+E9vGoSk9x7W45TWArLs/Gqa1cyjvb3EoimYyw0d9gqf8WsxFXdzJnO81RTeE5gKnni/H4nFfFsHm0kMeeqxBcQszU9NV0RWNWb6aKN2N+GKj8OcJwzNbhGu/uCzdk+8051udGV4xwtjWmZMZ1gOaNi7fnmCX4GA
 UgXz88jt
 DxbUw+GJ47JjoJCjv21dE0Y7KnfwBis3EPvQ2ttN8hEENNXoJDM8xJaRbAPxoU+YcP2Qa1Mc96TBIf5flWs/gZN/sehwmJ6h8FCIsVNZN5u8rv//ulKoreRSf4B7qQI1tAXBIZi6NTZsIJH6LkvZq7Dnb3+KLNfXKKoGcdNfjEOzIn0GYh+Lz/uVfwU14JvpUCH2EAjLhttJlszAEvq33rSGmaK/BsZ19VU+cmoaWcv3QN0y0q7FeXw8p2xycyAfegd8w68hSJLOnpj4GX+AzLzYNJAfqNR8KQXAlB0OATNocxbmiBWvU89AqM8ie+FKeFRkj/PG/3MNtkPQNNTdr7K8Bz0qrNXp4yKpnE1ctv+h7jFcxqk55IvqzCUnPLrpef8wNAwstIomZcnHtTpYbQ/8ls6y02R+bvtZGNNS8K8u4lQb6QmPpUUxx1zhuIcHUQrhMpcn8t8730YFnDR29OwmHidIX9BCGJZFiZTqcMpExA93fcjwW18Pr875rY/mNp68++FOLxmQG32D3+3rVqfFlqQiI5e/3xseqmHv0FfKNRT0TbCIw+gicgqi9VC7oPg87F1K4Wa4e+vaIjW2fTV99qq4/+/zGpwSIGsYMj/XWGO4Z6D+CRypLmFyF0Pc18NOfE2jar+kM9BMZ5EXvLlGPuO2l9QfWKTiNq2jjsZaYBWlWH+o3sS1X/i64Z7LLJ+NOErqE8CRdWzLaw68dxGeL0DojIYfZFxqEhilmn8DakewKBThVgPjJbX6Z9tmvXtnQk80AQGEZXaiXV/o3W/WxTZyg4PUMDzOq5cD/Sbnb/mMu2jPlR24DiYTzsnrNV0q3SDSWBdyxPiOOtUt/ca7cFoS5QJdYssG1Fqkfq3mTnWrT5bFD+hnVVKTp3xLsPm2Y8hNbs9ne318r2qTj+w5MNITAN9zbMs71pWBhBzTk4ebTMCpymGXr6k30EFX5yG6iY+kM6Brh2W8FSMx/X/2yf2Vm
 N6U1A4qz
 JlZFWDSV8/dsobZR4bHpZa8Mp61siHxzcQVCnnQNDdbdeRtS2FpqwD861O7Z5bxEt2J+nevF/JNVGY4io0eygNEImS9m/fsPuFqH9EbjLqOGEuBApFVnKPeR/pZ3gwPDLmguyUlnMyi3g03s6luZp0J78as+FL3jd+e5VjYdKVBmoyS0MBxUaOPg0HSq+pWzUAHeuO5t89Nlx7NdkNJCqUbyWtyMMo17rc3MJgmJ5TxOJaMuWDMborqhc453Npnj1M4ZaU3fB6xzt8DCr1QiKi+okD5RD9W7PuG3kxHNtdYftTPg4qYuf1+Sfc7mDwGbeYXOSg8HxStR1ZNPxOSegsZhPIYmywgIX1HpMm1naBoSV3Oz/xRRE1A+RqR+9mtf/VlZnD3AiGKheyZ8zWLj2IxyxB5Fq3/bQSHhWL2JwAl9k/pnWNY8FEyFEkVtrl1LbZ2ITdRdG94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    9c88929cc18c Merge branch 'vxlan-fixes-for-skb-header-pull..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12e316b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
dashboard link: https://syzkaller.appspot.com/bug?extid=508388c85f7a82cbd79e
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113de499580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c10aea580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c839a5778222/disk-9c88929c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7d9c12119e13/vmlinux-9c88929c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f0189c8f6aad/bzImage-9c88929c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+508388c85f7a82cbd79e@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	(detected by 1, t=10502 jiffies, g=15149, q=760 ncpus=2)
rcu: All QSes seen, last rcu_preempt kthread activity 10502 (4294966187-4294955685), jiffies_till_next_fqs=1, root ->qsmask 0x0
rcu: rcu_preempt kthread starved for 10502 jiffies! g15149 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5666 Comm: syz-executor142 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:__lock_is_held kernel/locking/lockdep.c:5601 [inline]
RIP: 0010:lock_is_held_type+0x89/0x150 kernel/locking/lockdep.c:5940
Code: 9c 07 41 83 bd 98 0b 00 00 00 7e 48 4c 89 eb 48 81 c3 a0 0b 00 00 45 31 ff 49 83 ff 31 73 24 48 89 df 4c 89 f6 e8 f7 01 00 00 <85> c0 75 2a 49 ff c7 49 63 85 98 0b 00 00 48 83 c3 28 49 39 c7 7c
RSP: 0018:ffffc90000007d68 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff88807e8aaaf0 RCX: 0000000000010001
RDX: ffff88807e8a9f00 RSI: ffff8880b86281d8 RDI: ffff88807e8aaaf0
RBP: 00000000ffffffff R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000000fac R12: 0000000000000046
R13: ffff88807e8a9f00 R14: ffff8880b86281d8 R15: 0000000000000002
FS:  0000555577b834c0(0000) GS:ffff888124f50000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7bc378eef0 CR3: 0000000070652000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 lock_is_held include/linux/lockdep.h:249 [inline]
 enqueue_hrtimer+0x79/0x2c0 kernel/time/hrtimer.c:1107
 __run_hrtimer kernel/time/hrtimer.c:2048 [inline]
 __hrtimer_run_queues+0x4ce/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:__orc_find arch/x86/kernel/unwind_orc.c:101 [inline]
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:238 [inline]
RIP: 0010:unwind_next_frame+0x4d0/0x2550 arch/x86/kernel/unwind_orc.c:510
Code: fc ff df 4c 8b 7c 24 10 49 8d 6e 38 0f 84 8a 16 00 00 e9 ee 01 00 00 49 89 d5 49 89 d7 4c 89 e0 4c 29 f8 48 89 c1 48 c1 f9 02 <48> c1 e8 3f 48 01 c8 48 83 e0 fe 49 8d 1c 47 48 89 d8 48 c1 e8 03
RSP: 0018:ffffc90003ace660 EFLAGS: 00000202
RAX: 0000000000000008 RBX: ffffffff9073eec0 RCX: 0000000000000002
RDX: ffffffff9073eeb4 RSI: ffffffff90f35a48 RDI: ffffffff8c4bdb20
RBP: ffffffff81b1f9a8 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8eb59c60 R12: ffffffff9073eebc
R13: ffffffff9073eeb4 R14: ffffc90003ace708 R15: ffffffff9073eeb4
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4612 [inline]
 slab_alloc_node mm/slub.c:4945 [inline]
 kmem_cache_alloc_noprof+0x2a0/0x5f0 mm/slub.c:4959
 __kernfs_new_node+0xe6/0x980 fs/kernfs/dir.c:665
 kernfs_new_node fs/kernfs/dir.c:751 [inline]
 kernfs_create_dir_ns+0xfe/0x230 fs/kernfs/dir.c:1120
 sysfs_create_dir_ns+0x12f/0x2a0 fs/sysfs/dir.c:59
 create_dir lib/kobject.c:73 [inline]
 kobject_add_internal+0x622/0xcd0 lib/kobject.c:240
 kobject_add_varg lib/kobject.c:374 [inline]
 kobject_add+0x163/0x240 lib/kobject.c:426
 device_add+0x3fa/0xb80 drivers/base/core.c:3695
 netdev_register_kobject+0x178/0x310 net/core/net-sysfs.c:2337
 register_netdevice+0x1433/0x1eb0 net/core/dev.c:11446
 cfg80211_register_netdevice+0x138/0x2d0 net/wireless/core.c:1690
 ieee80211_if_add+0x108d/0x1600 net/mac80211/iface.c:2397
 ieee80211_register_hw+0x3e79/0x4a50 net/mac80211/main.c:1644
 mac80211_hwsim_new_radio+0x3238/0x5680 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6113
 hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6904
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2252
 __do_sys_sendto net/socket.c:2259 [inline]
 __se_sys_sendto net/socket.c:2255 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2255
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7bc370bc2e
Code: 08 0f 85 25 ed ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 90 41 57 41 56 4d 89 c6 41 55 4d 89 cd 41 54 55 53 48 83 ec 08
RSP: 002b:00007fffcb9d7168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000555577b834c0 RCX: 00007f7bc370bc2e
RDX: 0000000000000024 RSI: 00007f7bc3791990 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007fffcb9d71e4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007f7bc3791990 R15: 0000000000000000
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

