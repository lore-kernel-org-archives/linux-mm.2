Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88EE2CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 07:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A788E000F; Sat, 11 Oct 2025 03:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801D28E000E; Sat, 11 Oct 2025 03:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EC48E000F; Sat, 11 Oct 2025 03:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F90A8E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:41:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B79F9879EC
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 07:41:26 +0000 (UTC)
X-FDA: 83985038172.02.3B6A10F
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf30.hostedemail.com (Postfix) with ESMTP id 01F8E8000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 07:41:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3JArqaAkbAC8djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3JArqaAkbAC8djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760168485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=nWuIqc/0zJGOLb+8dYLjY02do3cnq49EH2FPnh9oElY=;
	b=ln0KJpMuVNZzAmPyukQAgm34btn4sXDb7Mhucn7cDxLR7Cd5jvlBKNaHUkiL7DowSZNYOl
	LEPtHlQiD1VQBorQeW5IhU/YwEeENt5zc+jWmK37/XSiHWJWpnTCk+A/QueNTcC1bd3mDE
	TJ11/eOUj3tecvWN4JCFRVgw7yjiH4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760168485; a=rsa-sha256;
	cv=none;
	b=IBj8waSnIZcUCrgvM12++d2yO9N/5Qo5TRWnTuBk7OgHgQVPncyYgXOAh3SYEQy7SYDVBP
	pbhHOISRr3z9RJr/89herp1GgPqdgIzZfmFKTTsU5qB/n1ZCgb/dN9KcHFwmN1BFs09bij
	ZvX+mUWuK9+XPTm/f51M95WNkJJ8pko=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3JArqaAkbAC8djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3JArqaAkbAC8djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-42f94d321a5so198846335ab.1
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760168484; x=1760773284;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWuIqc/0zJGOLb+8dYLjY02do3cnq49EH2FPnh9oElY=;
        b=WjOheoa/851hmDnTooiDCJ1thI9JwxnRCgqHRvr/VHDK+L6OKkiVI14z0tnXAdXFYZ
         P0xBEbzc53qWGGajq4gdozbX8y2tc1VKp+BiMrL1uu8qKT3rLI/mMiGYxuxF8W8P3Sdk
         9bgK3gRGefQtrZV10mrWbqfwu8U9mBdpvZmzWvMS9BNzVRVgImF1ee8EowwllZZ5HKLU
         DNQhdAOTvbnPM9ShptFLAWMOqJ37Z8ddQUKWcJYADhIG1faercbqOX0WBaA9Bkok/B6Z
         VHOd+K6feUudlv495o0TzTdgxsLQRShCxlVlWdV+IsntSs+JJNuJi1GYYw4ONVBvZWIE
         PFiA==
X-Forwarded-Encrypted: i=1; AJvYcCVMuVEw9lK+/uGRsZGu8tQslKYkbMIN3wiv7BILTW8Lr3rHcABBIgpTE1iJ6rt01bH99rzX5N0TUw==@kvack.org
X-Gm-Message-State: AOJu0YwGOHII2t2qi6pFMPEnyJlGjxGb1sdEAxf1sVfgQoAIRbDYLvTd
	3hb6d0d7NawnUzcxKrNOmSpVE4MP9ensKrd657I9etGIaFz0HH6xGA8FLJSb5sHwTAKt7yRq2xQ
	72Ih4R1sROL3xuy1AdxktuBPMbZMHLv5+rlR4otCmIARtvG1Ky+kRsOtG0uo=
X-Google-Smtp-Source: AGHT+IEaHgOk+hcnpLNjCLvzHAVDmi8xOnlZJWvJ4LF4EeGkOu9Z/a3C/IvUMn+OQHpDUGzgp3Os72pjRQUmulOZjdXBXC33px3X
MIME-Version: 1.0
X-Received: by 2002:a92:c264:0:b0:42e:452f:5321 with SMTP id
 e9e14a558f8ab-42f8735a25amr170283275ab.9.1760168484125; Sat, 11 Oct 2025
 00:41:24 -0700 (PDT)
Date: Sat, 11 Oct 2025 00:41:24 -0700
In-Reply-To: <681a1770.050a0220.a19a9.000d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
From: syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	hdanton@sina.com, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: z3rx5oic3aqpr49jsdstky9ybxiuyogx
X-Rspam-User: 
X-Rspamd-Queue-Id: 01F8E8000E
X-HE-Tag: 1760168484-792479
X-HE-Meta: U2FsdGVkX1+NgTYrNBo3beQAcHEyHR2sZAwVnpOGTqeOR921CW2whVnbWIX1gd3aVCM6vyseQVD9zcxLoO7yPupGmQVroah4DgyPfxuNg9XcHehR3uMHzF8ZXneMeh4UG7TzH0+nOzf1smuhs3lQ0x11iiME2VEwWlkyP8+JWd+QUFkNLAk0IcF3gklKgSwzM3DSBcGKzONs9pOTDkCVEWdSIAEnjldvtCcICDPtdyQOIOAr/INwAHA21tTGNNqsH6jyBZVmf6X/cf+ncFrvwin2R+e9mHTwHT8pQ2Otn8vVb1hWv3Yoqe6Fs8G+Yt82hqgUtuEb7/1q/MxZKtdICU00ei9dTDg2s0IvFcR1HSTtmY+sxQbkk/v2AOl67qJuFQiY2DM+Oh1GwkXLOOE/N8f5kGqvnMdwP2MbW10dHbrAYPqrh9KVu61j1P80z4KmivjyJx9+n6kZYzMf3CrMnOjI/LvnOJyies4BPTzrNyfE28G/KaZDHfFCvsxclBrAUKW5bwgSSuJgenmYpOQOHzLKu+o+t5Ldhc9oxXmEPsbdp2sOtUSLOVEZAZZo4Fs9LSBBNDKjulM3m47AwWVQFmUICGt/00+oloMOyjQYoNeQOsqqoDFcNy9b9uEMnn3gqMa7fxtvAe/BNQhJdtTTIWXOhcFbjvN2IpBL2I6XJFKUueCWN6llu81aNA182BlchQdqJHjOqqabw0xY1Iwtco8Y+6qL0vL+whKyA3dKL0V3veVJ01D9Ewoj23TViPq4sz0tW8bkpp/q3noICENKgJeEmztjrxMIYpA1JMU4JqaCkFmgCCE2ubb0p/eL2F11F+nhJkO5p2LTiEot+3ORbIkmukxaElhh5fvYS5/e8+1B8Eht+ywtyvfbgTqWONROPrLs5vExeHgdFXM9uc9ep1dYtgFVbKIy7QkpM/MOH0kGnadNs88KGrrJwgjliVIJ8ek3xSYwru16vrlgs4a
 JMZ/5/jX
 4GcVazNuFPWSXUQpyPDM/Je7GJQSKL4SyOYYTMcq7gaiUN1q6IbYEVp3Ese2J+rnyaINQb2ma8K2E/XkYPJBMsdGfjnM91ULH8yFsuaVw6GeEB42xneKgYrCTrqExSC7yyyRuqoOPK5YsUg+PFyUA57top7mfsXv1CoSLPbAketLkI/+ZgEHhiFUC89Jwu5yTO4NSIyvYoRndsPrxmo5Tx45eRD2MmRcBQkkkg0dHmGcBDUjdXZrrTJA/DaPxTq8pOKhtsSpqB7QdhJReJ+Cam1R3zFeKaPXIoqz0OXqP1tvEjG2t6gqOGfPcGEq/K+UPTMLq1b00Evuw+Bmh3e6e6Xvf67KVdjDR44Jp2ufTtMkTqWkGLCDHsxaYr1pGj5m5o1lII2SEeULUxrrpKe1bxFRiq9VFS2IENBJMlgETBB4wDG/n4tWA/z90g3mLHytUZt8dBA9/utp+Az4NuxlckZoIHxB3pVKq6AxOBMhTVWKBqU6dqfMNyonIiiZvt+nQY4vwanEv59k3A9vb9MHk1d1mFAQ5WCANNJsmBtf66/VGg0QzaW4oGcVBYWJeWC4paU2xp1XeegBckNgT856RZQAH7t4Gg0M2GoLNN/pk3mFoSpiaBrgAq7EzLW4X0gGb3jqqXRP0tqcbvOCEjNbfmhfBzH0bPzFDz+dduSjtUep7f3uvBFCPZ6X2VCFqJSJxCIYGmfzXO0Q35Xzh9+h8wToh9PspVB4dc8ckH5mexq8jxzyWK8Wa3cDmLtISDQ48YTpsqIYzhSm/sBoZ1x+PwoW5r62ToppdkktCj6Uouf3CCCRBwfTgE1J8c+ATkx1c6/kCn/lWov81yXWVp3QNomD7u/7NZv+lm9iG8jVqUSu466QEW+0pyZIFgdr1u7CthsOWnRi4ZWQ4azIWpklk0HoyU0e0c8ssoqRVtS6ke2OOWKdaAJNU9n24rmj7dArOrXO206gTIHx2v95ujoqZuL53Oj1M
 Bn2DwqMA
 Vil2XQIo7XFhwfHnyjas93aCdUS/d+C95Oj1/Lroac76DfceQuuL2XYJM97SlA3v+qg3jI5PVctHpjmBmBvc91dxP3udm6iqXH93IRkAHQDoDRSQWPh8tji0x78VE+LxSFIUBBCwWSEyubI6g1/sFIaQMrzRR0SkAWk2ipnXYN7XdY84OBxk2A9FbN3LoegXc3EmEHJBanfolXoQghHjyZa9uwCUKMJk3Y0sf1zFnnwrszl0QgP7JP+U42EtDi7vNOxNk70sdfin8sBGq4bv7TX2ffKbz0/bmXU8m7G6KRYMMd6F2Jht+fpKgXlcL0dqDYLoM/Vt7t+Z2tmT8+9UsjJ8kJtFWoeZpiVlGNK0GHnVrNiHfFh1xwCR84zVuVHe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    18a7e218cfcd Merge tag 'net-6.18-rc1' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12504dcd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61ab7fa743df0ec1
dashboard link: https://syzkaller.appspot.com/bug?extid=51cd74c5dfeafd65e488
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d2a542580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142149e2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7a01e6dce97e/disk-18a7e218.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5e1b7e41427f/vmlinux-18a7e218.xz
kernel image: https://storage.googleapis.com/syzbot-assets/69b558601209/bzImage-18a7e218.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com

sched: DL replenish lagged too much
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (2 GPs behind) idle=7754/1/0x4000000000000000 softirq=15464/15465 fqs=1
rcu: 	(detected by 1, t=10502 jiffies, g=11321, q=371 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5948 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:rb_insert_color_cached include/linux/rbtree.h:113 [inline]
RIP: 0010:rb_add_cached include/linux/rbtree.h:183 [inline]
RIP: 0010:timerqueue_add+0x1a8/0x200 lib/timerqueue.c:40
Code: e7 31 f6 e8 6a 0c de f6 42 80 3c 2b 00 74 08 4c 89 f7 e8 7b 0a de f6 4d 89 26 4d 8d 7e 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 <74> 08 4c 89 ff e8 5e 0a de f6 4d 89 27 4d 85 e4 40 0f 95 c5 eb 07
RSP: 0018:ffffc90000007cf0 EFLAGS: 00000046
RAX: 1ffff110170c4f83 RBX: 1ffff110170c4f82 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805de72358
RBP: 0000000000000000 R08: ffff88805de72357 R09: 0000000000000000
R10: ffff88805de72340 R11: ffffed100bbce46b R12: ffff88805de72340
R13: dffffc0000000000 R14: ffff8880b8627c10 R15: ffff8880b8627c18
FS:  000055557c657500(0000) GS:ffff888125d0f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000600 CR3: 000000002ee76000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1794 [inline]
 __hrtimer_run_queues+0x656/0xc60 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
 __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.c:1058
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:pv_vcpu_is_preempted arch/x86/include/asm/paravirt.h:579 [inline]
RIP: 0010:vcpu_is_preempted arch/x86/include/asm/qspinlock.h:63 [inline]
RIP: 0010:owner_on_cpu include/linux/sched.h:2282 [inline]
RIP: 0010:mutex_spin_on_owner+0x189/0x360 kernel/locking/mutex.c:361
Code: b6 04 30 84 c0 0f 85 59 01 00 00 48 8b 44 24 08 8b 18 48 8b 44 24 48 42 80 3c 30 00 74 0c 48 c7 c7 90 8c fa 8d e8 a7 cd 88 00 <48> 83 3d ff 27 5e 0c 00 0f 84 b9 01 00 00 48 89 df e8 41 e0 d5 ff
RSP: 0018:ffffc900034c7428 EFLAGS: 00000246
RAX: 1ffffffff1bf5192 RBX: 0000000000000001 RCX: ffffffff819c6588
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8f4df8a0
RBP: 1ffffffff1e9bf14 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: ffffffff8f4df8a0
R13: ffffffff8f4df8f0 R14: dffffc0000000000 R15: ffff8880267a9e40
 mutex_optimistic_spin kernel/locking/mutex.c:464 [inline]
 __mutex_lock_common kernel/locking/mutex.c:602 [inline]
 __mutex_lock+0x311/0x1350 kernel/locking/mutex.c:760
 rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6954
 netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 __sys_sendto+0x3bd/0x520 net/socket.c:2244
 __do_sys_sendto net/socket.c:2251 [inline]
 __se_sys_sendto net/socket.c:2247 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2247
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faade790d5c
Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
RSP: 002b:00007ffdd2e3b670 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007faadf514620 RCX: 00007faade790d5c
RDX: 0000000000000028 RSI: 00007faadf514670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffdd2e3b6c4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007faadf514670 R15: 0000000000000000
 </TASK>
rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiffies! g11321 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
rcu: 	Possible timer handling issue on cpu=0 timer-softirq=4286
rcu: rcu_preempt kthread starved for 10500 jiffies! g11321 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:27224 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
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


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

