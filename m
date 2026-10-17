Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63166CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 23:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CDC6B0088; Sat, 17 Oct 2026 19:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D796B008A; Sat, 17 Oct 2026 19:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EEB6B008C; Sat, 17 Oct 2026 19:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6FD16B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:42:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F271AA03C0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:42:31 +0000 (UTC)
X-FDA: 85333744902.21.8326DF4
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5753B80008
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:42:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 35QfUagkbAKIUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=35QfUagkbAKIUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792280550;
	b=lj6J7CDJVFdZp7OQ5qmCECa+8luKsRaIMWphdI/tX3HHBQ3eSlIWG0u52rE6nX2MyF1Rhp
	MMrQ2HJR+WmxWojAUh5E7Ry6ukfjdxJwQRSRywaMcSLaE6lEeB7fg3JiNzj9PWDAhQWal5
	bHGhie3nxQIq5L2qI4ia6hkrrht3UoI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 35QfUagkbAKIUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=35QfUagkbAKIUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792280550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Ulz0XGKnxhl+8qtO3fftNe3Z7GVcPt33pyCT2Um33DA=;
	b=QSB0IKvK4M/og3/PXpZ1RCylfzL/ZcPt/dHyZmZ1tFfjGA4iuqjMaFl3+IHGyCidG2gEbg
	I46h4Td5I4ndDDwTxltYReBM2zmPsrGrD1lBD1hBNptmzfSS6k6lIoxS0iVx4rhx1TPPLT
	PBma6XaQZxfw3CH8Rck+IB9VGi1HFeI=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-807383233b9so669044a34.3
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792280549; x=1792885349;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ulz0XGKnxhl+8qtO3fftNe3Z7GVcPt33pyCT2Um33DA=;
        b=wVK5dNgLB/17mgZhMOQMExppXMj+9UhSlPidaM9IHflsGG3J7tu1hyOd8PX2/Ca2Cx
         PCq7n9lspH3FMCSmAjJnP4OsVmTjzJYf/2VF581KGIPWEpJ6kr9U+IJK3vmoHJtBd/KZ
         IcdyxCddP5N2AJu94pAq79/jiMaouYp0iMPHgn+ulxA8BlwVmabMe730VeKO6T+jLcIK
         cIlLvUta6XyofSDC5k/0YwPB8uqXZbgqC1iW/pUhnieH6khT11G1fpWEPiihFBCv709E
         WAj8XPDw0lFBS0EmBj0UrkqGZVDyv9jQJWS3Kd7zwt/xp8ZXsT9Jq4/iJ63iRgjWT1UE
         bSjg==
X-Forwarded-Encrypted: i=1; AKwUvBwY2/hGfBBYys5AGWLs3p4xdB6gFRTRxPS+5GkQV3tBhkwsywta4cefSWGC0Db2a3IINluRRZ43Tg==@kvack.org
X-Gm-Message-State: AFq9FYIsT6Psbb34AvyBd9jPVAXMdA3jRwqTXNuUZgtPowWbbdcR/Vrq
	vNUnzhaVPStIpTH5eP6x1iO8yvbiTQxDx84jDUkfsLRJj+EKrOIl48yNR0UDbCs7LbDlZzurKTa
	Oz/MvflY23ZVceG6jtjvrG5EaiucRrFT94Sw6NWsY47XoPBBFWl0jckTqVLM=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3c49:b0:53c:7298:35a9 with SMTP id
 5614622812f47-53cc3e3c8bbmr2979416b6e.8.1792280549338; Sat, 17 Oct 2026
 16:42:29 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:42:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad407e5.6814cce4.34c49f.00a4.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in filemap_fault (4)
From: syzbot <syzbot+af37a78f810994eae641@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5753B80008
X-Rspam-User: 
X-Stat-Signature: 41193djkd98myhs4cnca8gkrpgzqoo65
X-HE-Tag: 1792280550-550239
X-HE-Meta: U2FsdGVkX19PyV2MkaW4R3Cwlj4nKPJek/8LZz8igaXsUhyr5jqt+I+V+n2XQ9SFTdAsfdXsLrQmRx5rYda2Wp23PHuliwxaECSP5TJ8Y+L801/E0IYJNbaeX+AgsKRjsAIQUO+8J4Tld1qB6DhflFeLrZH577RL3PQy3fLsOB0hVEcd0buxm/lFNAJRuN4z2lXrUGbSm/qbOPCYxUqHezCNVoiFUpkY0yT0CRYcbgXK5pcVhE/MQBkC1oziFjvy1y/pQvY2CajAuDqnMCSFOdbgfPZvoIuP4odljJCk55iAZFWiT44wYkSQo7+W9XmTF388DAd1WGDUTdAyKiQLxxvqkWe5nam+OvWv8rD3OHACfkvDKcytsm4lmF5WmmeVG2mHPRJk4OUqXP8dT/PI44P9MTXjPT7r5+gwbLytgnBoxTcEC6U7EZJFHyCSQMM8HetHQw7/eqe0W6a5JVGNZW1/RHJazEGNk4nAgy+PDMzsiL8juqCd+oCE7HPoES3ekou5SyMHTGZdYrevDpxHxeXqMqelg2uNCYl+tVGm8V3RZd0khVrlu0KfUWNl6l6loqNzzvtj67VCwUPJMeFYZkInEghlAqHM+kx9rxwWKwcrNv2s6mcajWm+b8yty7fFsEAZ50a6WV0GUmkDvXms5iYkB1ot7fmBTQi2wvboMvdZ6dNSk8wOlq87zkdUDa7ourMKUDlUSVdKL5JupRg4pArXkYoC0d0W+0jHY/jjrt3S/7OGDmGO+5WEi1qvUJOVgAFSKj6vej/0kMiJDgCx/GIXnuyYa9eGpw5B6bEoR4yzMvFNbsOLZg5EgUfuhMw9ZUD7dmQivzFNcQ8wS4jmt1Y+Ap7Kl6SdzzRDarD0sqn5MmE61cpEDLvLBxLmU1yLifxRuB0rr2OIiK10k/R1Klr7FavrZzrAEpqB3nrui5Wa+lwykev+J4+z4QIqcl7Kk2bhZP0SRO98b1nUuDh
 ykQyNkL/
 bOfnc1GKeK1h0EDZjkQLm/Bec1fpXLR1APoYfKDkxTOfXEmqviX0W0V0E3EEXUpahIsF+P6FnCFX01d5LSG+CqiYCu4t5jDBNHnf/0TznpR9YE6LgfURVlD6y0rm7vHuYAKI8ZnogrrX92ZGaOIA8YZ6eSXhYwrIUhERKFIRyj+wF0uqWREzzothAYLfzns7T7z7jTBCpXRZ1iFDolWgv5t+0zqodW8X1UjbudEJ9JIcabLppOUbJMr8+9PbC8c5yi87dPN76IR5vPqQxuB1HqIJD7SDBA47h5bqFe2tN1+f+RICrwU1KNpuMe9WgGXvl8zOuVnOqIBLMRSPvaJ5VOy+cyLcXt1P10ICZSjaXYi0xIQnQVbHfdMAEOTazpwlooWi5A1d5xbFsSzmfTAk6860W1lg7ZxBrdhw853cRv60WlSmPV6SBj0jVJJc8/SeOGysOMakZ8cWYz5Ozezs8VdhTJ73c4oIz32A5OXv3jMuudWNnzIlJTsTuVZtD/F6vE3O8iMcnI3PJpUkN0PxqRjuoqioOJokELq4eiD9WBC91pw2pZb9Svb8ELuMHAN2ZGFRqLeghBAAJvHAPzi5LT1pblIrGL8cRv0rTWppTNRTGyXaVXquddV8UARFcC3Q7lSoBXWzdyhg+HCmOn2sdtyPf6lBd+v3KdLSQlv62j1274RzmAWTykmIMVEuYXUBAMk9sIwV2AwuOLLwaXKPeo7U+8rdXAjBFSdgudAoeftAIqxo86Ja3FccElWPJCuEBRXPwFy+YZMAa3RI17Y5ldduv/jfHbrz9rQYGfRbFRunz+5o7wVgdl2k7L3fwbmYeQTYVE6KDsTPu9ghkYlb/GGXjcwDhVbYlai0eX3F4FAdffdp4PvlV11GbY2pRvs7cPz8dUOgyQUkLaS8dyn4tywDvlnkaeGnY1KV6voZ32WDXlWbU7xKX4U1Ll6mKgRncqDYlqggglwu9FjVR4ygasGYUiR1h
 PFwzTvC5
 FEXGv7T7LfVJEHq0iy2DdbCGJUG+gip4U527zgQHA3geDfYTxAJhASSRcq/DvWO4b1eNnuQKEPcMjpwJH3fdGtbmQhlxoFLhcLEL7zxG7KhX/m75Sv6oeXdfhTfDnnFpWxA77FBxdWHzizCWWY8XIdj+pI/RoaZP9YVOukpR8vL0q1fLYFK3baskZ450FTdAIOQFV4goxHAT8K4wHjiiwIBBAYy98wr4eMeHlDa+DKNXaoPy9Zzse0GPARs3IlERV6HMCMIFXppQh4bgfU7Nekv4jQiiZQKWu2pntrlcGqy3c8bhhVbeStMvbL+jAmBPfT7Bd+nPXYhdZDcyVysrmcctJ789avsV6FTcqstvibT6STy80pTVQyGB8n88IE30fJKuBqWrkV04e14NE+8yHPb/JTYmmHx9dwqnpsXmRu51i5WeTWNgonIwu+bOwVijpWzDfdGALU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    70dd4ee72eb2 Merge tag 'pinctrl-v7.3-3' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b2320d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ccb65e03706547e
dashboard link: https://syzkaller.appspot.com/bug?extid=af37a78f810994eae641
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10de5da9580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-70dd4ee7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f1d9bae25289/vmlinux-70dd4ee7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d8b2b9fc2571/bzImage-70dd4ee7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af37a78f810994eae641@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P5320/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=61125, q=864 ncpus=1)
task:syz-execprog    state:R  running task     stack:22864 pid:5320  tgid:5314  ppid:5313   task_flags:0x440040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
 preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7606
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x920 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:task_css include/linux/cgroup.h:548 [inline]
RIP: 0010:mem_cgroup_from_task+0x8f/0x120 mm/memcontrol.c:1134
Code: 38 48 c7 c7 58 c8 d9 8f be ff ff ff ff e8 a9 1a a8 09 85 c0 75 23 49 83 c6 2c 4c 89 f0 48 c1 e8 03 42 0f b6 04 38 84 c0 75 6e <41> f6 06 04 75 09 e8 76 f7 68 ff 85 c0 74 28 48 83 c3 20 48 89 d8
RSP: 0018:ffffc9000e0ef610 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff8fd9f0c0 RCX: 0000000000000046
RDX: 000000009a0f617f RSI: ffffffff8e6f5004 RDI: ffffffff8c6dec80
RBP: 1ffff110061db463 R08: ffffffff8242ae78 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10070f1e47 R12: ffff88803878f230
R13: dffffc0000000000 R14: ffff888000f525ac R15: dffffc0000000000
 get_mem_cgroup_from_mm+0xd6/0x290 mm/memcontrol.c:1187
 __mem_cgroup_charge+0x15/0x80 mm/memcontrol.c:5226
 mem_cgroup_charge include/linux/memcontrol.h:662 [inline]
 filemap_add_folio+0x140/0x4e0 mm/filemap.c:965
 page_cache_ra_unbounded+0x46d/0x9d0 mm/readahead.c:293
 do_page_cache_ra mm/readahead.c:348 [inline]
 page_cache_ra_order+0xb47/0xee0 mm/readahead.c:558
 do_sync_mmap_readahead+0x75e/0x990 mm/filemap.c:3443
 filemap_fault+0x7d9/0x13b0 mm/filemap.c:3597
 __do_fault+0x138/0x2a0 mm/memory.c:5565
 do_read_fault mm/memory.c:6000 [inline]
 do_fault mm/memory.c:6134 [inline]
 do_pte_missing+0x2215/0x34b0 mm/memory.c:4700
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x1a53/0x3750 mm/memory.c:6876
 do_user_addr_fault+0xa4f/0x1340 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x46fe0e
RSP: 002b:000010e09c0a5178 EFLAGS: 00010216
RAX: 00000000015e4970 RBX: 000000000173a820 RCX: 0000000000000000
RDX: 000000000001a058 RSI: 00000000015ca918 RDI: 000000000041db80
RBP: 000010e09c0a51a0 R08: 00000000015ca918 R09: 00000000015cb3b8
R10: 0000000001911ec0 R11: 0000000000000000 R12: 0000000043fdf3b9
R13: 0000000000000000 R14: 000010e09c078960 R15: 000000000000012a
 </TASK>
rcu: rcu_preempt kthread starved for 1643 jiffies! g61125 f0x0 RCU_GP_WAIT_FQS(5) ->state=I ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:27496 pid:17    tgid:17    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
 preempt_schedule_common+0x7f/0xd0 kernel/sched/core.c:7463
 preempt_schedule_thunk+0x16/0x40 arch/x86/entry/thunk.S:12
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
 _raw_spin_unlock_irqrestore+0x76/0x80 kernel/locking/spinlock.c:221
 debug_object_assert_init+0x20d/0x380 lib/debugobjects.c:1072
 debug_timer_assert_init kernel/time/timer.c:803 [inline]
 debug_assert_init kernel/time/timer.c:848 [inline]
 __mod_timer+0x4b/0xed0 kernel/time/timer.c:1025
 schedule_timeout+0x14d/0x2c0 kernel/time/sleep_timeout.c:98
 rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2122
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2330
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 5761 Comm: syz.2.24 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:get_current arch/x86/include/asm/current.h:25 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x80 kernel/kcov.c:212
Code: 8b 3d 34 de ab 0c 48 89 de 5b e9 93 fc 66 00 cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 04 24 <65> 48 8b 0d c8 9d ce 12 65 48 8b 15 c8 9d ce 12 f7 c2 00 01 00 ff
RSP: 0018:ffffc9000d3278e8 EFLAGS: 00000202
RAX: ffffffff8be56f10 RBX: 1ffff11006b094a2 RCX: ffff888034c90000
RDX: ffff88803584a508 RSI: ffff88803584a508 RDI: ffffc9000d327ab8
RBP: 1ffff11006b094a1 R08: ffff888034c9001b R09: 1ffff11006992003
R10: dffffc0000000000 R11: ffffed1006992004 R12: ffff88803584a508
R13: ffff88803584a508 R14: ffff88803584a508 R15: ffff88803584a510
FS:  00007f0baa9bd6c0(0000) GS:ffff88808b0b4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000058 CR3: 000000004004c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __list_add include/linux/list.h:172 [inline]
 list_add_tail include/linux/list.h:206 [inline]
 plist_add+0x420/0x580 lib/plist.c:111
 __futex_queue+0xed/0x160 kernel/futex/core.c:866
 futex_queue kernel/futex/futex.h:333 [inline]
 futex_wait_setup+0x424/0x590 kernel/futex/waitwake.c:695
 __futex_wait+0x15f/0x400 kernel/futex/waitwake.c:717
 futex_wait+0x121/0x390 kernel/futex/waitwake.c:750
 do_futex+0x3e7/0x4e0 kernel/futex/syscalls.c:133
 __do_sys_futex kernel/futex/syscalls.c:210 [inline]
 __se_sys_futex+0x3a8/0x450 kernel/futex/syscalls.c:191
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0ba9b9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0baa9bd0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 00007f0ba9e25fa8 RCX: 00007f0ba9b9e559
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f0ba9e25fa8
RBP: 00007f0ba9e25fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0ba9e26038 R14: 00007ffe158db450 R15: 00007ffe158db538
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

