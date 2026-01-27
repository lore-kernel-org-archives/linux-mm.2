Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2F1BD19511
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 01:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D1F6B0088; Mon, 26 Jan 2026 20:07:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FAE96B0089; Mon, 26 Jan 2026 20:07:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C066B008A; Mon, 26 Jan 2026 20:07:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0A116B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:07:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D8711A09C2
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:07:33 +0000 (UTC)
X-FDA: 84375955986.06.7859359
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE8A920016
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:07:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 30g94aQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=30g94aQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769476052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=zGbj0dVfZfXuRnHtd36TSCbucFbRwLCDmK2viXS3NR0=;
	b=StwtRmegRb82hrqcxVYOkwGVuxzlFFmLczF4gjUcz26zCmrVxXbYGjzTorDMNsyVZcPEcE
	pEdrhQQ7BoS+tjdtLpqSHbLb9q2sP2itQG1aeC44Ba+xHOgXQTkVvEmtMbMdThnAOZZf2R
	sIE8ef/nsW1wN9pL1Dg0MESvkYiRTv8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 30g94aQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=30g94aQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769476052; a=rsa-sha256;
	cv=none;
	b=g9VrAa4r4VTY99/NBxtBSMD3acdko1RVF2j4MlHoXKQhUMyyfMwPF81Di52qlBx1P0r5P4
	lZO95iPm7UF19XoM55sAiXQ1KRJ9BiWGL6ZpuKGEUpBZF6bII877aE8M9OuTff258zY5au
	vvMYFmT+4UXeJZ3iyrwo/RqarQ8/qxo=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-662c6ddd80dso10113979eaf.2
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769476051; x=1770080851;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGbj0dVfZfXuRnHtd36TSCbucFbRwLCDmK2viXS3NR0=;
        b=RIFH5zHuXicPE6mfoyKXZWHb+mVdvdZttwnEu/WPMzMbmJXCm/UokmiEb5nUE3Hn1r
         kle6QND/vXJYos0m3A8yAHFaeTf4BNM5wxW9+nPVnuQJYP+Ow3YeqQY8IgHCfTv6OMYf
         VoeVJZoIIPFRysUtIZUQEi7Fw3SpEB3xF2ZVK99/LvovZON1amenZSjtCtdxU5ebmVah
         AYbRobjhaTnf2q+wyjNtEyeZvHS3AhGqh19N54c69To2KrxHixwmD3d025jzpewSMVUs
         7H2mrvo2QDndnfOXP/iqUkkIy9orzWgapeKOvLb0Fh53OhbEMKcEWiJ+ixgbFxYzStcv
         w8Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXeeTJubeRcz5hx0yCkKZ9jyuEZSNYrY5VeTypwCKvRZc9hHkyHeIxNZ7qbrrufg+vT6LztB8wcIQ==@kvack.org
X-Gm-Message-State: AOJu0Yyn4VUB4UIR9xzSr7QHsQ1Oe2tRpWYWCLHrlc7gFHJ5E4//Rotn
	prfwsTamhOhI55Tw6Oo5IXGpWMkSavUsWaqZm4rFecs8knhnqSb3szmwF/Mj3Ee0WjqnqBOWeCO
	6akpkVosXhyw5zmk37To5veSzvHQp5gGvFa7bYt1G+M1bRNrwoOVXmWexISg=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:206:b0:657:5629:2cef with SMTP id
 006d021491bc7-662e02c60bcmr3256128eaf.4.1769476050951; Mon, 26 Jan 2026
 17:07:30 -0800 (PST)
Date: Mon, 26 Jan 2026 17:07:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69780fd2.050a0220.c9109.000a.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in schedule_tail (8)
From: syzbot <syzbot+42836f91edd58eb82c6a@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: 78oir1ucz9qgf3bu6synyh75esgah8wr
X-Rspamd-Queue-Id: DE8A920016
X-Rspam-User: 
X-HE-Tag: 1769476051-76627
X-HE-Meta: U2FsdGVkX1+4PgsOusJq8YsNbjhRFXHaueeDVTLvGm6VLjn03NAX/ZFZrSyiLSyrYFpVhwZ+gBUZ6MzrOgD8EfZ8crNXUXzMEaP5KSK955GEWa0+vO+bgJkPTeZrrkBW1OtqiKr2eUSB5MXTCzhglnTVBG6ZXrHyrmighlYg5R0TwPFiRcqJXdap5+yS0OzyNylMg6llj5kRDFbcOoG0xfS/bnwhW7wXGO4eH18WZnQI58qlsT0+bXO/frCaVN9Dr7fjvGRN24IFw85VZ23zCWKJBDhpx1cbZopd8zRzY0UGRPhASTzUGyu5TcwJYavF7tTEE/CSbDfR0lS/HaXAHl69EgV/BFW+RimKdXPRv+vMOenJabUUvTY4OCovSpTiOagNKsNQQB1WFAv1+3PemV6ei5RuNxhfT2gwDvX4Jk9xUXtdY/DfDg8LF3fVLPztR/fyL/G28W0YCBwUacNnRU3j9j78Xg1E8N4ulbmoTbyc2Nm4t8g5AM6Gw8Y9jf4H2uaR1v9J1udtEpIeDg0Jxw1OVUB7J97c6y+CqE+iQ3VWAqFJbaF7PF+r/yJVxFTEUHWdmp74PEa/XYAeQPR4xHLnwy0SYZJCe1WCKdhPwVbZDon66HB5K75Jgc/r6JMFIm9Xroe2AK6JBnurBvo4AuKmDXt4buMEIDx0FQG/U0mxkXIsJcxe/Ww7jndsP0aDGCfg8ZAew2war5f2fdLG4G2VTPykTOH+vmS1Qg7UvaUSZbNyeNnD5JKjer3Y3/G1Hk8S46735CgD6skyxkeqLJfeEpVAA1cSYRhD87WiVm/6qvIHKIIq+BOBnSFr7plbudjyurkSDdWDXdI1GYb/haaJX22ZYDr5T01oetPZxvJdl1PdwwQaV6UtFMSGY8Z4+WiezjGEVyyzTAielFmOqi9Xc/P5wkD8w0lJqMYxpQw0CFg9UJhT/DELPeRVk6wh6GGc34OcZUXu3u/HwAM
 izab0CwI
 tvC8zaqItuAGUJX3Td7El5ESoolA9T1DjVFHKcezDjxX6H7lX7kDhYD83XI28qea1T+WjhbJw6kxzlA+SR6r9KTqwEuMuwpohKyjZwv02Q3rDKemEgFANqW7r17UcZj4NyfanR7bgBBWYgYlL7BpOc4jhL6utRaUaHUc1Lta/U83UqOp96mnjdFS7x8EjlLvvKgmNiBNVX60CU1RDsYQrkoXM4h1W1hHbgg4J0X/pUxKfoFZ1Jj9tyn2/6ysLwU8kmc9jVH18Pk+WSmF5CUVWDlsNlu3hLnWXxH0U6fxuJJZ+wQqbkO2zCFjId4L7iN1zF6sJO/MshxZGAJ3DG+R7ZYPp0W25wMywjHR/05CfmP0f+gbdJQkhNBuwsTy/NBp1DOL++fTp79GTZ7QIWMltQmW0vooAdpOeQgSM8TRzSfLovJ19251JtT5seuixXoUxq9hH8BSde7caydUpoB9F43CXjzNalQjIl1mWyQoPoOKw9rnQSakS4+N209rC9LFAK1NUxngxivKnF1McLcLMRsCq4fRm0mRwD3yzrNvWzE17I59bKFVKpBreaYjtSLV+HOXm53N7Wt6+IX00rB0F4pMCZw1jM4C16+EvYCSc5VpWB/8X89ccQ+PeoXc428Haa+fEBlGL0hm4DQFs+163loV1Pnl5ABUvhw1Pfzl28lQMOaMMShPIkQk/Tdrq8zvqhIKz0ck0IbKJnSk3MOs8TkcMjcY0puiwBCYraKePzGnuAk+u1kxbf7B5+T/JvvtN/hxTIbXJKEK/mBL8DVMbQZLdHF8Rm3+g6lGcZbxR1dnXrVZ45vcbUVFJa780YXC35AoMV+bCTzrgzuEh9GPR7p7ysi9+dea/Bsn0s13FzsH4zVtiTiuhEsArovE73L1Lx7eYsllolzouZB6/IZTSt/TmR7UwTPWHPxW6x58JMoO0x7dZX5n6WmSMeVUw/f3nc3XNM/aRyv0HBFllMq25mhf7dYbg
 5SWsFDhG
 pcDAN5AVGHpfLyvUMWKKNpoeW1J810B0CYf2sKvTCYemJO/xt+TTbYxBqUbQNv8LNyaZRVqzIEIaf1qWO28i//41xxF9csMdKqdkG4ImBBLOwx7R8D/QOAV9NV1Ts3qJWkZpXNzQEtPUJVx2pX+M7Wl+eCycwWEQW0ZeQNQDmQTviAmzdbMyQSy8VnaGYFeYsEFKLy0b2nAfR/Qjb/NJIl6kTm5jaqm1TkmnbGmviXSd5fXLaZfWHtUvLl3UTchdbGX/XTYb2mc2sd06DxXXTdoL/9J8rT2OldhYi2Zhl7jRb/nSzwifKEhc2bEKnCj97QIcpd7I/9guxxRtORSyAdsKfiniuslXNsiigbRdDvUc8gEz1hRfWUhY8978tw8PWt83FenOcPufSMVs7kSCMn55+Iw8x9sRmBMI21SmFAxaQU3q3GTb9fovLxv5cIsQEWGD6Qz59C8gHjlPFRIGuGYrXNztLIQf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    12a0094839d0 Merge tag 'timers-urgent-2026-01-24' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105cc05a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
dashboard link: https://syzkaller.appspot.com/bug?extid=42836f91edd58eb82c6a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14557d22580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d0105a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4ede6f8f9210/disk-12a00948.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/47f57ac656a5/vmlinux-12a00948.xz
kernel image: https://storage.googleapis.com/syzbot-assets/22586c0d39b7/bzImage-12a00948.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+42836f91edd58eb82c6a@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6967/1:b..l
rcu: 	(detected by 0, t=10503 jiffies, g=14029, q=726 ncpus=2)
task:syz-executor    state:R  running task     stack:29456 pid:6967  tgid:6967  ppid:6192   task_flags:0x400040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5260 [inline]
 __schedule+0xfe4/0x5e10 kernel/sched/core.c:6867
 preempt_schedule_irq+0x50/0x90 kernel/sched/core.c:7194
 irqentry_exit+0x17b/0x670 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:ptlock_ptr include/linux/mm.h:3240 [inline]
RIP: 0010:pte_lockptr include/linux/mm.h:3264 [inline]
RIP: 0010:pte_offset_map_rw_nolock+0xbd/0x1c0 mm/pgtable-generic.c:330
Code: 80 3c 10 00 0f 85 bb 00 00 00 48 03 1d 5c 91 92 0b 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 28 48 89 fa 48 c1 ea 03 80 3c 02 00 <0f> 85 c0 00 00 00 4c 89 e2 48 8b 5b 28 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc9000bba7ad8 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: ffffea0001ee7580 RCX: ffffffff825bf480
RDX: 1ffffd40003dceb5 RSI: ffffffff825bf3de RDI: ffffea0001ee75a8
RBP: ffff88807b9d60c8 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc9000bba7c38
R13: 000000007b9d6067 R14: 0000000000000067 R15: 0000000000000001
 handle_pte_fault mm/memory.c:6261 [inline]
 __handle_mm_fault+0xc0e/0x2b50 mm/memory.c:6414
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6583
 do_user_addr_fault+0x74c/0x12f0 arch/x86/mm/fault.c:1385
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:__put_user_4+0xd/0x20 arch/x86/lib/putuser.S:94
Code: 66 89 01 31 c9 0f 01 ca c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 48 89 cb 48 c1 fb 3f 48 09 d9 0f 01 cb <89> 01 31 c9 0f 01 ca e9 07 ba 03 00 0f 1f 80 00 00 00 00 90 90 90
RSP: 0018:ffffc9000bba7e78 EFLAGS: 00050202
RAX: 000000000000001b RBX: 0000000000000000 RCX: 0000555562a197d0
RDX: dffffc0000000000 RSI: ffffffff8dc45476 RDI: ffff888025b2a944
RBP: ffff888025b2aba0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 1ffffffff1cbde81 R12: 1ffff92001774fd6
R13: ffffc9000bba7f48 R14: 0000000000000000 R15: dffffc0000000000
 schedule_tail+0x9e/0xd0 kernel/sched/core.c:5193
 ret_from_fork+0x79/0xaf0 arch/x86/kernel/process.c:154
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: rcu_preempt kthread starved for 10518 jiffies! g14029 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:27368 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5260 [inline]
 __schedule+0xfe4/0x5e10 kernel/sched/core.c:6867
 preempt_schedule_irq+0x50/0x90 kernel/sched/core.c:7194
 irqentry_exit+0x17b/0x670 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:debug_object_assert_init+0x7b/0x300 lib/debugobjects.c:1000
Code: f1 f1 f1 c7 40 04 f1 f1 00 00 c7 40 08 00 00 00 f3 c7 40 0c f3 f3 f3 f3 65 48 8b 05 17 95 f4 0e 48 89 84 24 b8 00 00 00 31 c0 <80> 3d 7e bc c7 0b 00 48 89 7c 24 68 48 c7 44 24 60 00 00 00 00 48
RSP: 0018:ffffc90000157910 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffc90000157b58 RCX: 0000000000000000
RDX: ffff88801e290000 RSI: ffffffff8b92b940 RDI: ffffc90000157b58
RBP: ffffc90000157a00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000004 R14: ffff88801e290000 R15: 1ffff9200002af26
 debug_timer_assert_init kernel/time/timer.c:803 [inline]
 debug_assert_init kernel/time/timer.c:848 [inline]
 __mod_timer+0xad/0xca0 kernel/time/timer.c:1025
 add_timer+0x62/0x90 kernel/time/timer.c:1249
 schedule_timeout+0x122/0x280 kernel/time/sleep_timeout.c:98
 rcu_gp_fqs_loop+0x1a9/0xb00 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x21e/0x320 kernel/rcu/tree.c:2285
 kthread+0x3b3/0x730 kernel/kthread.c:463
 ret_from_fork+0x754/0xaf0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 6972 Comm: syz.8.313 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
RIP: 0010:__get_user_nocheck_4+0x8/0x20 arch/x86/lib/getuser.S:142
Code: c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 01 cb 0f ae e8 8b 10 <31> c0 0f 01 ca c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 0f
RSP: 0018:ffffc9000546fad8 EFLAGS: 00040202
RAX: 00007f4f28dcf040 RBX: ffff888021280000 RCX: 1ffff1100425033a
RDX: 0000000046505845 RSI: 00007f4f28dce5c0 RDI: ffff888021281a04
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 00007f4f28dce5c0
R13: ffffc9000546fb90 R14: 0000000000000000 R15: ffff888021281a00
FS:  00007f4f28dcf6c0(0000) GS:ffff8881245dc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555562a197d0 CR3: 0000000028f6b000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 check_xstate_in_sigframe arch/x86/kernel/fpu/signal.c:46 [inline]
 __fpu_restore_sig+0x836/0x12f0 arch/x86/kernel/fpu/signal.c:335
 fpu__restore_sig+0x151/0x190 arch/x86/kernel/fpu/signal.c:480
 restore_sigcontext+0x4cb/0x6a0 arch/x86/kernel/signal_64.c:95
 __do_sys_rt_sigreturn+0x229/0x2c0 arch/x86/kernel/signal_64.c:268
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4f27f9acb7
Code: 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 <0f> 05 48 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89
RSP: 002b:00007f4f28dcf0e8 EFLAGS: 00000246
RAX: 00000000000000ca RBX: 00007f4f28215fa8 RCX: 00007f4f27f9acb9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f4f28215fa8
RBP: 00007f4f28215fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4f28216038 R14: 00007ffd840d3410 R15: 00007ffd840d34f8
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

