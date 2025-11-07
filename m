Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D526CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 07:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBBE78E0007; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BF48E0002; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8258E0007; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB98C8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 693E21A02B0
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:31:30 +0000 (UTC)
X-FDA: 84082990740.25.7D12BB3
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf17.hostedemail.com (Postfix) with ESMTP id C20244000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:31:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762500688; a=rsa-sha256;
	cv=none;
	b=N4lTHlWWRVlAlMs3T8KqfqjmoeIXB2d00mqxu/u7cGtuh+NR46AJ7GhiBYT7fLLPgkn2oy
	4GJSwIjIWGaJSYIfTldWvd7wX9++rTW393475jvkdhg6JQSvC6j/SmX+V18gnrxnhfyHsa
	TD/J7hV+U3C2Op//aP/A2DXtTtHN4E0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762500688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=aHi0GSDWw+DFPzwz+Hy0dteO68RU8wWgdmOIcy+/qFc=;
	b=dqGOk+WvmS4jCSp1rwIItqaSPIz7E1kzaiMWB2Ps1pa3qErakUykMvOORac5bCJNv83CzJ
	HddhZmWQ2D/aw+5Zy5y7zM334hfTtqSksndZLc+QxlCNVMwnG6yGmr37pzNp6sDSwVXiii
	+c6yhrcLLciNAlhDdeMY6y/bxOIcI7Q=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-4332ad3179bso4615645ab.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 23:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762500688; x=1763105488;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aHi0GSDWw+DFPzwz+Hy0dteO68RU8wWgdmOIcy+/qFc=;
        b=Sz/xzkaA/mD2XIX8MeBobE2cjLAi9jOAuOV6FAffIk9H2aiOuQNVqCj8r3oPo/x5Rz
         //ZRQaiivWWMkerWODXA4ExNsZExCNDC4r22GmU2WFHFsX5BxfW7EePdbLw+VhiQuk0s
         OppH3xMRe/xrVUkEbcF8peiPyqa+okygt1XZo6aqsKa6pDutSlB44BVxqSn7bmdwFerM
         OuPpIU23GLex/uHixwWftDfC7RNMhSYXgyiYeKOE0JEnFpPnA3gBqA3f88nJ7Yyfc3V3
         IZ2pIcYElc+bFqgUyCf0/vdcM9m2H/bVio82XCgZE0q049Gv0jKAWrw/9Y5qzfQS5V79
         wRgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBUleusu6I2H1y+zguGOvlI9zF3lNAHWTQTmNAIpHmxhNKdSvYhqQEVlb4LYcNsYqSoy1aRhd5xA==@kvack.org
X-Gm-Message-State: AOJu0YxE5ymRVCi1xnkrdVXBIeas+68SqyDQAePahRXk4B3oeHSENel/
	ERHu+NmZyVB3sbFOHvQZ3g+uPoirFdo6CRSlnwLHCS/NMHnSMemaKf5Lw4AcSwjyoEsvwn9ngEC
	5kCzEZstXEcd2ZI3f6IKUn6IM93DB1X26ZE2HuiIzxXR9GqDFLVbYz0EW324=
X-Google-Smtp-Source: AGHT+IE8e6TZwBMJKL7y90nEbznBhuBiS/GtlVHJKR1ml/b1KG3VAoMOrpAzwKfMju3KxqSIT3PgxZH9QyyiaDLlAFUqlAPy4kZp
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3486:b0:433:3315:e9ee with SMTP id
 e9e14a558f8ab-4335f41dccamr34232925ab.10.1762500687896; Thu, 06 Nov 2025
 23:31:27 -0800 (PST)
Date: Thu, 06 Nov 2025 23:31:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690da04f.a70a0220.22f260.0028.GAE@google.com>
Subject: [syzbot] [net?] [mm?] INFO: rcu detected stall in rescuer_thread (2)
From: syzbot <syzbot+d5f7a5097c24c7c2dbbb@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C20244000C
X-Stat-Signature: 45fqokkf9t6fkkrut1ypz3q1hqokxosn
X-Rspam-User: 
X-HE-Tag: 1762500688-655271
X-HE-Meta: U2FsdGVkX18KIvbbWnM4EMpeJnPz2/b1F2fL4L9TcXYVhaPIvdzzfqmeFFtuMITDQar1Un5/CouDVyV05dev64+liJa59/l0xFMzKhWRxnWtH4AUcfHG5wm4g7kCwE1YbzZL5EBvAOq04JBTwmNTot3bEFPfHAdRlPtWCu1uErRC1Xb/tfUXrb1OpdNpp4s/QASA4QgZzRv59IIbehcLp5g2Ge02gwNGiPsHS5e8pBYwPC0fcF55NRuOqj+Q9acFJZIQrOUE8pYKmb075xLHFbWZACpoTaj9ceUoXN8GSSIKEJLpDKesC5II1Znbi/lfSHMSmD9rzlKCXbIRUSiaZf6kiEC1sY9o20ZTaL9hXPv6c051eiKzvaqm9KWX9TF+SvhSw91blIaAGm40P6VoxOpc4m//tONjq847qMTLWaKUD4RXxnUdxyzJItAKAdiyseMtyvebsq2EtjrBcYQ3hJyqylaqBz9PMVAK7nzirKBpErjJtypOPxjW+gN3ZMlW69w2XW1pWq163IYsUnW7/Wc8VA+3IF2Iqf26SefPw/A4BJwpu0AvfT8WCkdgOQg//MMe0wWLfFr2L0WsgZsdyo6OFMkJTftOGkcJhsdMv6vOAuAqTn7q48RjXFkorKWV98Q8Eud8+gUToIhoRqDGkqH/lSNZ6IUnQbw6UOC1DMB6BXCDaJe4NHenEZYn1Ohy6TnjnT1/xFdZEntfu92LbzWwsKVKud+Am+hnXfxoistl52X+PrXhbdAM6srTMLw0FnLC6QgZQ5FH3ufYvTecLUTHK09JDW5UyyZTvFDP7sAEz9v8R9PVAglUYFomknPrYFofGC0Ma6qTJ/4p/S89l+O2wNBhr5y8EWRLVo8KE6p2xzbURtKERjxlERP5g07zlZZ/Wxe4Zm2TjWt+GI6Ew5rRkxxG+GE3wFBi6RStEXPGsRr139s8/E+c1jPu4h71Sxtf8puo50QMOvT1/oD
 pRWF8L8i
 nCBNhcwTb7hqstbny1J4OqXBeGKsmwmqnEZOJkAv93xZGK2e5RIkq0BefESbRIpqLtcjv9SOv/ulWSX9qZHT9RUD5zRz0hoLz/bBWyedbW14YK+hRCFc1NIsKsjuHQvJ15WWhy3StMqvQB+AW3Tw071Vyxm++xs8uIPaRniGDPljJESey7AY5reHSuVG0yf1Gfw1mHPKLYTRDKQqDkUUGsSkv1PDB6jbcmZFkzSVduQFlNrY2A9QCHPOKLb/oC8MaXKRhFsz+sZTHMGLh92V+v1ujtue/ZpM0/q9GIYYelXFmY06boQm9qfbNxr/Rw2+/cYoog367AVloDRA9Mp1+Bo1SjjwZtSwwPeVixaY7LemZ3796AkGm0j1Lxd8ykZV5sU4mik5ungMka2odOHjgblAoNjTj9its6hS9DGprUDzEA53nax+3+81YHkN0CiBkY3CpJcJDRBn8ozIY1gRN8cTanJfJ+XMv1TgTxmBrupL9ON3f0C1F6RQNIUMG5fltitkahI6doWjD14IvjCqOpA1+VOjTFoG57HRH9jcR5YLsgtKBZ7p1yDTE3yIfKnNrwHn/zsAbJyLpx/ve0FUcQ297+bZSYgmRma2Y4SNs7+iBIgmqvGAINwyyQhZnyP8tiM1uzb7XXREzQHtaQHHeeJhfAGraE6OMU5qvBupRvzv/VUavXcKEHCgwWLSVq2owM2ew6pa4ntlp+T7a6uJyaDh7mK1tUAKvfWaGX1KV8k5nzAovtfgqPuAuGzKp7A/NYvjfiaIWRsaPp1FSa0lnQdMt+c5cUBmsqDp/tLIgpBBp3ODIlJnK5FYBN7ZrDrJmONEpE7zsmH1/fDnis4Ea4nHCTe8+bExbtYnWLbge2xJK0PefECuP6bg/GtxgLT0bKSrvBhdCBEXIue+nmcM7HgHwkM+2JC1Egf6PBG2iQs6AIVnd+INnOLbm6Ne/MRXsy+MzL4aizSKKVT87JhrcCdNNg3hc
 yKhSwdPc
 Uux0z50j1M1DiH3vMbEmKP+g4jXWRo1m7eSteNKKEeLqsrwTSdnBx4KZevLntG4hISc0ryAUH5T8jz4jPCulXgJu1ls0dpKwJSxilzHVkaVBDRstBX2SXWBtbwUerB64pEOp/tlAX4Cf7Aqre5EZkIbnHRmVRZoZZBilw49svpNLZyMbRJDV/VtW83vLZeuEOIx1lPKCHJSQVWYT0Vxnfi493F1ftxacFUlIY7n/3y5FDPJNm7HgVourNUQaGSkqq6RC6rQuTvc4maw9v/eiUiQEWbL0CRR/Wfyostrl/UWCrFNytNe3PIPxzOWaqpokd3kHWVGjI5MGopE2RAXa5P0j31KV4OlcFBirR3x7QbVzzJWm/ckbEAvozL5iD+dDmB1K0pD1+VBVYDUZ/Pg7oPLETdmibiJUFWhI+84cS+/I1xx4csi4OOVPItgQy3CdQ6jtfI31TUpvC1b6+BvXMNPV0Bz92p9Mgd4auZ9jzQSYpd3e/UQknDkJnxxA6aZw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b1d9154878ce Merge branch 'net-mlx5e-shampo-fixes-for-64kb..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15cc5bcd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e46b8a1c645465a9
dashboard link: https://syzkaller.appspot.com/bug?extid=d5f7a5097c24c7c2dbbb
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134820b4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bef31d61ceb8/disk-b1d91548.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/67c31be6c377/vmlinux-b1d91548.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7b9f62743e14/bzImage-b1d91548.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d5f7a5097c24c7c2dbbb@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	(detected by 0, t=12991 jiffies, g=11121, q=1246 ncpus=2)
rcu: All QSes seen, last rcu_preempt kthread activity 3112 (4294972946-4294969834), jiffies_till_next_fqs=1, root ->qsmask 0x0
rcu: rcu_preempt kthread starved for 3112 jiffies! g11121 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27288 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5325 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
 __schedule_loop kernel/sched/core.c:7011 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7026
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6005 Comm: kworker/R-wg-cr Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Workqueue: wg-crypt-wg2 wg_packet_tx_worker
RIP: 0010:rb_erase+0xb/0xe60 lib/rbtree.c:441
Code: ca 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 41 57 41 56 41 55 <41> 54 53 48 83 ec 28 48 89 f3 49 89 fd 48 b9 00 00 00 00 00 fc ff
RSP: 0018:ffffc90000a08ce0 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff8880b8927c90 RCX: ffff88801f7a5ac0
RDX: 0000000000010000 RSI: ffff8880b8927c90 RDI: ffff88807de66340
RBP: 1ffff1100fbccc68 R08: ffffffff8f7cdc77 R09: 1ffffffff1ef9b8e
R10: dffffc0000000000 R11: fffffbfff1ef9b8f R12: ffff8880b8927c98
R13: dffffc0000000000 R14: ffff88807de66340 R15: 1ffff11017124f93
FS:  0000000000000000(0000) GS:ffff88812623c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056323a462a38 CR3: 000000002891e000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 rb_erase_cached include/linux/rbtree.h:126 [inline]
 timerqueue_del+0xae/0x100 lib/timerqueue.c:57
 __remove_hrtimer kernel/time/hrtimer.c:1114 [inline]
 __run_hrtimer kernel/time/hrtimer.c:1757 [inline]
 __hrtimer_run_queues+0x364/0xc60 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
 __sysvec_apic_timer_interrupt+0x10b/0x410 arch/x86/kernel/apic/apic.c:1058
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:queued_write_lock_slowpath+0x125/0x260 kernel/locking/qrwlock.c:85
Code: 00 01 00 00 43 0f b6 04 27 84 c0 74 35 89 d9 80 e1 07 80 c1 03 38 c1 7c 29 48 89 df e8 e4 b8 dc f6 eb 1f f3 90 43 0f b6 04 27 <84> c0 74 14 89 d9 80 e1 07 80 c1 03 38 c1 7c 08 48 89 df e8 c3 b8
RSP: 0018:ffffc90003337300 EFLAGS: 00000206
RAX: 0000000000000000 RBX: ffffffff8f3dd900 RCX: ffffffff8b490058
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffffff8f3dd900
RBP: ffffc900033373b0 R08: ffffffff8f3dd903 R09: 1ffffffff1e7bb20
R10: dffffc0000000000 R11: fffffbfff1e7bb21 R12: dffffc0000000000
R13: 1ffff92000666e64 R14: ffffc90003337350 R15: 1ffffffff1e7bb20
 queued_write_lock include/asm-generic/qrwlock.h:101 [inline]
 do_raw_write_lock+0x1f2/0x260 kernel/locking/spinlock_debug.c:211
 ___neigh_create+0xe81/0x2260 net/core/neighbour.c:690
 ip6_finish_output2+0x1175/0x1480 net/ipv6/ip6_output.c:128
 NF_HOOK_COND include/linux/netfilter.h:307 [inline]
 ip6_output+0x340/0x550 net/ipv6/ip6_output.c:247
 ip6tunnel_xmit include/net/ip6_tunnel.h:162 [inline]
 udp_tunnel6_xmit_skb+0x68d/0xb30 net/ipv6/ip6_udp_tunnel.c:112
 send6+0x5ac/0x8d0 drivers/net/wireguard/socket.c:152
 wg_socket_send_skb_to_peer+0x111/0x1d0 drivers/net/wireguard/socket.c:178
 wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
 wg_packet_tx_worker+0x1c8/0x7c0 drivers/net/wireguard/send.c:276
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
 rescuer_thread+0x53c/0xdd0 kernel/workqueue.c:3523
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
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

