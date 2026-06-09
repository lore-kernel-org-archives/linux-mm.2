Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A740CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7446B0092; Tue,  9 Jun 2026 07:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF0A6B0093; Tue,  9 Jun 2026 07:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49DCE6B0095; Tue,  9 Jun 2026 07:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 376596B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:58:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C50DB8F219
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:58:11 +0000 (UTC)
X-FDA: 84860225982.18.7E22666
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com [209.85.219.65])
	by imf26.hostedemail.com (Postfix) with ESMTP id 02CE1140010
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:58:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S8FS9/jG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.65 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781006290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iZeRKVQ5LbVTuXoF338pmAKQHGvQwIxz8tAlACAULxI=;
	b=lkd+w9CImSz3gNYRtCjFnlSfUdrW0M7m0/Ac5+kR1r4doutZySEWveuJoAsyJcWT566uj0
	Tah5YEmKRZNny9JQ5JqJMqdgFj3SPKjmss8IcosdDvlGKkxR/sUzG7dGAHZWOUO53w0E1+
	9pqDqvnBUx5DGZURy5vtydZqCa+AYGQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S8FS9/jG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.65 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781006290;
	b=4aO3EBwK8FlhFn/qtlsod64ZMyZVU3eMdtMVqcp8hMKjvxP6rVVnOgwF3po2d6xOLa0XJN
	5WNWNQm47VRi30Tvo/vZFMiMc4JOkD3vSo2J719S28TWOnNIeSqw0o5C+zCjQish4bj+2H
	EmAKbB1BgySvav4tJYBB30x0pVHU9oQ=
Received: by mail-qv1-f65.google.com with SMTP id 6a1803df08f44-8ccdef9f3d4so62018946d6.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:58:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781006289; cv=none;
        d=google.com; s=arc-20240605;
        b=A7hofXePCK6DO1KO6OLHRH1JhqMWcUsiNhuJgEFYZTOyOXtTNUQW2u8A3mD2NosE7H
         cv4e0phy2w6vlqZYOiYKr+5u/2vC3jruxzxRfv+TroXzaAw+o/CU5oegYzBJh/EoCceF
         olZaxwTAGv3N+WX6k3vy+IkU3S8XrBHM6eC/QzVEP0RHl9ftaCMQLQLxp6nj/RqbrTSF
         pLsf3OGNVTutxoBjbhIvJcKNMxYleWftfkm0Y3tsleiebAo0+8/OTLioe8Ql4QBVSheI
         mNZs+UVZDG3TiiZ/FG0ysJq4jo0aQSRxf85kSmqzLgcJ0kVDuEU8yvRmOf30+ti+kfZS
         CBDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=iZeRKVQ5LbVTuXoF338pmAKQHGvQwIxz8tAlACAULxI=;
        fh=IHlVoEwhj4G56weJPXWRZyetjXnIlExTX/KuDHiG7kM=;
        b=V09kVghHsq9LJMtBy2pmG4rmOTJEwK9XgolOnvzvuizscdPreiI4eYyFn9bdPXpgfE
         tkfs/pWR0q/37CbOapI45jiPpS2EksXHoAbEYZUe3zTUpI3zdPfSShjogC2GVmhgoXDu
         S0SAM7gHx3LtpQ3VpxY9WhoamCCCtXrwNhZd3J7i0IxhHsmvWXsgighK/Lmq/f2fA+QL
         BVZrTV/2QpJInHmWTZgAJB0QAzlo8kAXEQ4/AR7xBYRcaZJFS9Aj7aBQTuz1A5X/gdPf
         O4NrV3KE7fegQYnbIzejSHTxVOqMaIde/PuS0JwuelwUyeRm1FZXXsetlNCGqhf5oGmQ
         BjEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781006289; x=1781611089; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iZeRKVQ5LbVTuXoF338pmAKQHGvQwIxz8tAlACAULxI=;
        b=S8FS9/jGfSsBkKjll+gqK/KOZerGv1RQLM+Vfj4zWYFmhW4MkQgNrEaRo+PUVsy8kd
         Rfw+juZEPLBlx2OxVp23CbtevE9yir2akjayTvXC8Hi5bXVWDh2d9GgpapIiIRpyIPJj
         3uXmoSfn+4uM/1HIkZRl/4+RWlJjDvJh6xJXmDBcUmkHpOJODUeOSysObA0A405womfy
         ktHzE85Wa9jgvBVmOOwF8b76wkds2JXDGtdvxcTb7uMtTdWCJCAMuSBJVWuxkrReLZf1
         teROMJfixF1MUdBzx1hKQ2JpFqlvvmmNP5vXmDTSxHSwiBckLFPqRkVc+2zGSbx5ug1P
         /A7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781006289; x=1781611089;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZeRKVQ5LbVTuXoF338pmAKQHGvQwIxz8tAlACAULxI=;
        b=Tv6z55m2J4aIpl2Tv1ebYi7H4O7CUNOD1XazbD7Yxaig5woeU/TwNuhvJkVOANc9DM
         Zyz95HUW6h1YyQWEDZdbrL+UNUeq/oLlwxofeXq3c/ueD6+Q6+YAmazOfZ4BMi2HgS/y
         /jiae0cy30BOOWCImm0uQOYwi14rOa/Wmccg7nxUpvYxCe0gwcXV1wlAI0U8FeZc4pmM
         2MAcuA2JO2xXBiMNaFNIIqktiCPCFZ8oSrzuM4J4uXk6Ueq7GFFO4jFlyUEqfl0f+Axz
         30zdnT22tKBYIL/flZOp7/yVr1uNXO06BD+rIDRu0aVc9C2wTp6SxfBf1fJFS8Xzzwcr
         xYiw==
X-Forwarded-Encrypted: i=1; AFNElJ/+KDYKXQrfhfxtaPRH4Y1ZJ851fZyBOmmn7NL09sEY8KBQCu2q7uzWnYdpKDwcrJfvMzk4onRhrw==@kvack.org
X-Gm-Message-State: AOJu0YzVzjjGpS2+xMy2F2IR9zlBt9yIH66qa53smOHdS1p/v2Nsg9Zf
	7TNqMqHVar4MDjE9GDT5UdpcX2PNJIKAy26hF0GLZUbReyypN0gyXmh9wd5ci1JTt+GX1RkPgrh
	q5zYUUWHiWE46l3K4LY+nkBTzezoTMPE=
X-Gm-Gg: Acq92OHM9tZu/XOBNLFF1u5sa+j1Wez1hUP8QBO/+bAoyt/LYSC0oRryWQMC1n1SGFU
	dhD/zEtze/zBjZtqjQgt0RGwoF32aQA9IzgrbupXu5C77SAFh/fqFnUcPHwpVjbEpXZTA7DviW+
	klEVU3EehcUb0Ry4XYle/tN2/8lEj2DbYwQ+5wopr9BAb8wFeMErWbgOql+uffQH25TWi7XuRC4
	JOptj3xOWKBkQLB5F/Qtt2f+jpBo4QMoyl7jd38+XOxQo6D9pCb8xgwtwDradxqUKtKtcw4U4X8
	fmEui2UEv20PCSBUvQ==
X-Received: by 2002:a0c:c304:0:b0:8ca:f1c:6493 with SMTP id
 6a1803df08f44-8cee5fb6e13mr208831746d6.1.1781006288937; Tue, 09 Jun 2026
 04:58:08 -0700 (PDT)
MIME-Version: 1.0
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 9 Jun 2026 19:57:56 +0800
X-Gm-Features: AVVi8Ce3ZhIf6vufvLeXykI-E_VWQgIfFmK9P2r5yIKN5OfCTKyW7Gf1NkYAYlg
Message-ID: <CAHPqNmzgCY+sHOOG8YVrCFO-7oh6TBeL4SCHEcfVvH6J1SUVdg@mail.gmail.com>
Subject: [Kernel Bug] INFO: rcu detected stall in count_memcg_event_mm
To: syzkaller@googlegroups.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02CE1140010
X-Stat-Signature: n1k3fpiefu9srf3551rjnn4c8gf3ptpm
X-HE-Tag: 1781006289-152282
X-HE-Meta: U2FsdGVkX1+HlWmsUYuc1Db8rvdk2G1wz0JniF/jgS92HuAJTDBKqT7aNpnDxk5B8cDojw3jiHigLne8Kwt9V914F/s1MIAQCownwRJRVPz0V2JpkjRqQz0QwRJrgTfG2RrLUTrCsre3VANheDi+8cgxC237v6CIAqLnHKm6W+qYpIG/t5ntGl4GL83DapKmimjFAirqNoVgb7wvNgXBHlaCdhwEnOWfZHDuKObUrPzmmcJbMMxJVFt3YNarZjcvNrCOw7q+GW+dd6Gu9Mp3ABtaLwnTZUOu+RaFu11pF1sb4LMTOvLBa1GmHzIn1rYHVyrFw6f/GXpbvG8GKu9WrezcTnzFtUEY9xNQZg3IoIJJq62nAyJSVp6zY65YX5MjC1OyrGl3gNsMOfZION8v4LmiOEUQu+J6zAFZiWHYJjHtlWP2SlVerrauFFn1xEmJ5mR0OBCsmxtjXwH8q2xfXnDRmtnew+vADJtJgtyl1px15UCmK/tQToJTwAIBweoxiqsB8BDMNxCCtsZ0WpwBAFrJuURj8LAkPcexXckj8pIPzhudjLBocixX/kSQiTHTb2fij4bsLbmsIi95QTVaCzfDYyHd1f+v3LJf5OSKUL7UWMkShc74ye68mOO0RC7Nip9xNchlUUQgwXkJyrZvTdA5xC8x8Hvvvts9PeJ3a3jGuA9OekcmAsLe6ejdwpc7+W1zBxYjUm09T+xvz7GExrNzQnJOcQVD2XssHETIE1esHb1fjQ32DsAiB4M37XSxv0MVp0xeKaZphtGI84o1B//J/NluNFQ8vqiA4ec4tJowPcGxFLf2PQcOiOuJrj3Uda026FJvYz8azpiNLUsxQGoFggydEKAzreEHoHmTAR/1wK61YXeu3r/7/I3FnXQDfvAWeXosC8x2kOaGqsjuqzKm0ViIhsHT5iyhMCjmUbEzX1eQ1MBF3mQSQb8R67V6N8khCF/YQAoUe1LBSAM
 MqaH0oHP
 etl1G5cs07WVehy0JW9zElK6MaYRl2n4q8Ld2RtfZ2ZhIK1USfbf9spSHbRnbzDKZlL/T+2AET0mXYzReCIXBQDipEFEJ+l8Y34J2jbLvf5CPK+WnTwHVZHIwQo1wf1X/oj8ImPwbd2sq5i0Q7/e/NuOo5+H2KFopccwgjCkK95+odZU2DE36vy7bTquywnv956yWZHuFxeKLKF2MHs0TlPvXSk2wTH+QmEle+XxDOPlFo4WV/WYNhIck9hGs+nS/1a58jRjW4ccbOiUh6wKQALo96LVoeeys2ltmKIAW3V/END43kl7UekbGgKSfBbk8cnzNEeqvnD9ZJHirAEGFR12CzCJ8jOZDSP7CAJnYhAb8ku/VPxKSXSThcST8T8OrGhP4n5MeXtytIK8NJ1EMml0yBZmYPasapCJsSNUTUHfOxBHU8V0YQS59pXEW6riuBzW/TOkdNaqkI0m3k6Np6dhTHyNob8B6fjURgW5aOKVXN6ZBUDbRd9jmQQR9+lury1tFjLNIl8nDrT7CylDDIpv/XgnQIgxOxO+XValQfJZ+yaf8pPtgle8E9g/678kmn1y6saCJvyTJUG4jH6boYuLyV4rgsxcqJ2X5D3sYAecabaHIi561UuT+g/1vGgJe2QI1TFc3Fe4VRO7SGGSHRqm4FmmsGfM+zombTyK//GObHY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. INFO: rcu
detected stall in count_memcg_event_mm. Details are as follows.

Kernel commit: v5.15.189
Kernel config: see attachment
report: see attachment
Syz repro: see attachment

We are currently analyzing the root cause. We will provide further
updates in this thread as soon as we have more information.

Best regards,
Longxing Li

==================================================================
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: Tasks blocked on level-0 rcu_node (CPUs 0-0): P12059/1:b..l
(detected by 0, t=10502 jiffies, g=18873, q=1488)
task:systemd-sysctl  state:R  running task     stack:28320 pid:12059
ppid: 10470 flags:0x00000200
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5030 [inline]
 __schedule+0xd98/0x5b40 kernel/sched/core.c:6376
 preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6780
 irqentry_exit+0x31/0x80 kernel/entry/common.c:432
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:676
RIP: 0010:task_css include/linux/cgroup.h:496 [inline]
RIP: 0010:mem_cgroup_from_task+0x9/0x140 mm/memcontrol.c:935
Code: 0f fa ff 31 c0 5b 5d c3 b8 f4 ff ff ff eb f6 e8 3d b4 fa ff eb
be 66 66 2e 0f 1f 84 00 00 00 00 00 48 85 ff 0f 84 0f 01 00 00 <48> b8
00 00 00 00 00 fc ff df 55 53 48 89 fb 48 8d bf 60 13 00 00
RSP: 0000:ffffc9000dbafe58 EFLAGS: 00000286
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81ae3af8
RDX: ffff8880209d24c0 RSI: ffffffff81ae393d RDI: ffff8880209d24c0
RBP: ffff8880209d24c0 R08: 0000000000000000 R09: ffffffff93062a27
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000014
R13: ffffc9000dbaff58 R14: ffff8880209d24c0 R15: 0000000000000010
 count_memcg_event_mm.part.0+0xa5/0x340 include/linux/memcontrol.h:1079
 count_memcg_event_mm include/linux/memcontrol.h:609 [inline]
 handle_mm_fault+0xcf/0x770 mm/memory.c:4863
 do_user_addr_fault+0x4a5/0x1150 arch/x86/mm/fault.c:1357
 handle_page_fault arch/x86/mm/fault.c:1445 [inline]
 exc_page_fault+0x58/0xd0 arch/x86/mm/fault.c:1501
 asm_exc_page_fault+0x22/0x30 arch/x86/include/asm/idtentry.h:606
RIP: 0033:0x7f7a1e783970
RSP: 002b:00007ffeabd9ad48 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00007f7a1e464608 RCX: fffffffffffffeb8
RDX: 00007f7a1e4661a4 RSI: 00007f7a1e45c8f6 RDI: 00007f7a1e45c827
RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000002b0 R11: 0000000000000246 R12: 00007ffeabd9ae88
R13: 0000000000000001 R14: 00007f7a1e464610 R15: 0000000000000000
 </TASK>
rcu: rcu_preempt kthread starved for 10466 jiffies! g18873 f0x0
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28656 pid:   15
ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5030 [inline]
 __schedule+0xd98/0x5b40 kernel/sched/core.c:6376
 schedule+0x115/0x250 kernel/sched/core.c:6459
 schedule_timeout+0x153/0x2a0 kernel/time/timer.c:1914
 rcu_gp_fqs_loop+0x1c0/0x980 kernel/rcu/tree.c:1972
 rcu_gp_kthread+0x1e6/0x330 kernel/rcu/tree.c:2145
 kthread+0x3d0/0x4c0 kernel/kthread.c:334
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:287
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
NMI backtrace for cpu 0
CPU: 0 PID: 12075 Comm: syz-executor.6 Not tainted 5.15.189 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xfc/0x174 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x22/0x16f lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x23e/0x290 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:166 [inline]
 rcu_check_gp_kthread_starvation.cold+0x1ca/0x1cc kernel/rcu/tree_stall.h:487
 print_other_cpu_stall kernel/rcu/tree_stall.h:592 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:745 [inline]
 rcu_pending kernel/rcu/tree.c:3936 [inline]
 rcu_sched_clock_irq+0x21a2/0x2610 kernel/rcu/tree.c:2619
 update_process_times+0x1c5/0x280 kernel/time/timer.c:1818
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:254
 tick_sched_timer+0xe9/0x110 kernel/time/tick-sched.c:1473
 __run_hrtimer kernel/time/hrtimer.c:1690 [inline]
 __hrtimer_run_queues+0x64c/0xc00 kernel/time/hrtimer.c:1754
 hrtimer_interrupt+0x317/0x7e0 kernel/time/hrtimer.c:1816
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1097 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x430 arch/x86/kernel/apic/apic.c:1114
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1108 [inline]
 sysvec_apic_timer_interrupt+0x4d/0xc0 arch/x86/kernel/apic/apic.c:1108
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:676
RIP: 0010:unwind_next_frame+0xd03/0x1d20 arch/x86/kernel/unwind_orc.c:545
Code: 20 84 c0 4c 8b 44 24 28 48 8b 4c 24 30 0f 84 56 07 00 00 48 b8
00 00 00 00 00 fc ff df 48 8b 54 24 08 48 c1 ea 03 80 3c 02 00 <0f> 85
16 0a 00 00 48 8b 14 24 4d 89 4e 38 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc90000007568 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: 1ffff92000000eb5 RCX: ffffffff8e89bb65
RDX: 1ffff92000000ecf RSI: ffffc9000dccf678 RDI: ffffc9000dccf678
RBP: 0000000000000001 R08: ffffffff8e89bb60 R09: ffffc9000dccf680
R10: fffff52000000ed3 R11: 000000000008e07d R12: ffffc90000007688
R13: ffffc90000007675 R14: ffffc90000007640 R15: ffffffff8e89bb64
 arch_stack_walk+0x87/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x92/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x2a/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc+0x7f/0xa0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:604 [inline]
 dst_cow_metrics_generic+0x48/0x1e0 net/core/dst.c:202
 dst_metrics_write_ptr include/net/dst.h:118 [inline]
 dst_metric_set include/net/dst.h:179 [inline]
 icmp6_dst_alloc+0x4ee/0x670 net/ipv6/route.c:3281
 ndisc_send_skb+0x10b4/0x1570 net/ipv6/ndisc.c:493
 ndisc_send_rs+0x12f/0x690 net/ipv6/ndisc.c:707
 addrconf_rs_timer+0x413/0x810 net/ipv6/addrconf.c:3957
 call_timer_fn+0x1a5/0x580 kernel/time/timer.c:1451
 expire_timers kernel/time/timer.c:1496 [inline]
 __run_timers+0x75d/0xb20 kernel/time/timer.c:1767
 run_timer_softirq+0x54/0xd0 kernel/time/timer.c:1780
 handle_softirqs+0x21a/0x950 kernel/softirq.c:576
 __do_softirq kernel/softirq.c:610 [inline]
 invoke_softirq kernel/softirq.c:450 [inline]
 __irq_exit_rcu+0xed/0x190 kernel/softirq.c:659
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:671
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1108 [inline]
 sysvec_apic_timer_interrupt+0x9e/0xc0 arch/x86/kernel/apic/apic.c:1108
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:676
RIP: 0010:__preempt_count_add arch/x86/include/asm/preempt.h:80 [inline]
RIP: 0010:rcu_lockdep_current_cpu_online kernel/rcu/tree.c:1170 [inline]
RIP: 0010:rcu_lockdep_current_cpu_online+0x21/0x150 kernel/rcu/tree.c:1162
Code: 00 48 8b 14 24 eb c8 66 90 65 8b 15 39 81 9e 7e 81 e2 00 00 f0
00 b8 01 00 00 00 75 0a 8b 15 f2 2b a2 0c 85 d2 75 01 c3 55 53 <65> ff
05 18 81 9e 7e e8 f3 fc 53 08 48 c7 c3 40 b5 03 00 83 f8 07
RSP: 0018:ffffc9000dccf660 EFLAGS: 00000202
RAX: 0000000000000001 RBX: ffff88801cdf0000 RCX: 0000000000000001
RDX: 0000000000000001 RSI: ffffffff8a640000 RDI: ffffffff8bc7b8c0
RBP: ffff88806b299000 R08: 0000000000000000 R09: ffffffff93062a27
R10: fffffbfff260c544 R11: 1ffff11003dd908a R12: 0000000000000cc0
R13: 0000000000000001 R14: ffffffff81d2f5eb R15: 0000000000000000
 rcu_read_lock_held_common kernel/rcu/update.c:112 [inline]
 rcu_read_lock_held+0x1f/0x40 kernel/rcu/update.c:309
 task_css.constprop.0+0xc9/0x130 include/linux/cgroup.h:496
 mem_cgroup_from_task mm/memcontrol.c:935 [inline]
 get_obj_cgroup_from_current+0x120/0x510 mm/memcontrol.c:2926
 memcg_slab_pre_alloc_hook mm/slab.h:283 [inline]
 slab_pre_alloc_hook mm/slab.h:497 [inline]
 slab_alloc_node mm/slub.c:3134 [inline]
 slab_alloc mm/slub.c:3228 [inline]
 kmem_cache_alloc+0x76/0x2f0 mm/slub.c:3233
 __d_alloc+0x2b/0x8e0 fs/dcache.c:1749
 d_alloc+0x4a/0x220 fs/dcache.c:1828
 d_alloc_parallel+0xdd/0x1c70 fs/dcache.c:2582
 lookup_open.isra.0+0xb06/0x1660 fs/namei.c:3387
 open_last_lookups fs/namei.c:3532 [inline]
 path_openat+0xad1/0x2c00 fs/namei.c:3739
 do_filp_open+0x1d4/0x430 fs/namei.c:3769
 do_sys_openat2+0x185/0x4f0 fs/open.c:1253
 do_sys_open fs/open.c:1269 [inline]
 __do_sys_openat fs/open.c:1285 [inline]
 __se_sys_openat fs/open.c:1280 [inline]
 __x64_sys_openat+0x171/0x210 fs/open.c:1280
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x34/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x66/0xd0
RIP: 0033:0x46a4e4
Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 06 d9 02 00 44 8b 54 24 0c
44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d
00 f0 ff ff 77 34 44 89 c7 89 44 24 0c e8 48 d9 02 00 8b 44
RSP: 002b:00007f2a6d102f60 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 000000000046a4e4
RDX: 0000000000000002 RSI: 00007f2a6d102ff0 RDI: 00000000ffffff9c
RBP: 00007f2a6d102ff0 R08: 0000000000000000 R09: 00007f2a6d102e70
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000002
R13: 00000000004e9478 R14: 00007f2a6d1035f4 R15: 00000000ffffffff
 </TASK>

https://drive.google.com/file/d/13nr1pPRHCrZqYxz08ngNiCvmcRe-d_oK/view?usp=drive_link

https://drive.google.com/file/d/1RHa5bKm8YN-h9wRh_dJH0q1ZBF5mzYOh/view?usp=drive_link

https://drive.google.com/file/d/15HyqruIzxnkYVh4FXjmU-yY_zTB8kwPI/view?usp=drive_link

