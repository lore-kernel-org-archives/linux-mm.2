Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A09EC1EAF
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DFE06B0005; Thu,  5 Feb 2026 07:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AC26B0092; Thu,  5 Feb 2026 07:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CE96B0093; Thu,  5 Feb 2026 07:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 045486B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:57:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6BAD13AF9D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:57:38 +0000 (UTC)
X-FDA: 84410404596.09.8B4D2E5
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id F389740009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:57:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zj8QiZII;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770296257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i0tXoxNrqUNprC5lHUC5uQuYgNL8rns6TAwpzkMzmW0=;
	b=QWX2jbjU23GLPxarmTxaNbKjIYWIC7oZGRYnV82lwaFNCrXnxHtquvfG0bFhRVgtE7zfSA
	LdLMdtu5HAtCgE88/br0VXqm+NAFiKmGH05lCIxcVv+omfLiJ7ak29ZwFuHhC9QmCS0eR1
	JsTWQdzNlkvZZhrcp8s5gyyb1khEJbw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770296257; a=rsa-sha256;
	cv=pass;
	b=yfAlEtJtOHVbEbUYSHnawKPU0voTSTwnrEbFwo4m5ASrZYgiN837aNxxrJ7gDiXoOF3ue+
	XKYX3hEM/fMRq2qkxFbohTdnixhtK3AGE5rxkvUNMaOj0iW7Mz9jNKfVzQn0cKoap2Xxvl
	Gsay6RRYOyA0JpkibEq3jgdPdESIC7s=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zj8QiZII;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c698873a1deso418988a12.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 04:57:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770296255; cv=none;
        d=google.com; s=arc-20240605;
        b=Xt+DxJjg/JFJzmohYpOE3ZH+eaMKUJtNT47eaMrhabWCDDWBl5gS1NyYnAN31vhjjm
         F8axMl2yLoUMjJpQeqGeGShj50nX/WE5hVx1bIWzgKHk4/WX7lbWAhYOTVJis97mRuB8
         0LMawPZpEIvOfaYMRkZ/ZeOsaE2sZyzLhhXoN/NVvjtNlnesxzzWw2fqPtnO+OTFEW7B
         Y10eoSxZXCF0p5xlC4vO6U59FzGOzG3ktk6JrTtNagxMmnHljk2Hj+s0de94piGb20oQ
         cj89y1wHtziuTyDURNfeatjMK2djwfa9M4CDYMZC3BdVRu4RkDz1YhDZigcIWTN7iitC
         xogQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=i0tXoxNrqUNprC5lHUC5uQuYgNL8rns6TAwpzkMzmW0=;
        fh=mYZb5B0ZKmQjwBJS+Y5L4TGDJ2/XmJZnfgOp8cYbSz4=;
        b=aTC3eZYWEPp2qfziKV2mS6QjzkkJ7NQ3aHwRBQFqNVTWXqyhWgutQf1xR2hdqHSCTS
         o3w8KEoZYiSuBVyIe/N8T4zONjwtJBqklVHGhRkXd3EKwmw+Dk7Tc6N0DyBfT5c4/xWw
         ghOuJ51uI9zVo87miA3LO0gApTDfqf1axbdbyfVg83t7k1V3svDc5CKo4N/qoARJJBWP
         nejx/Wl21yBiYYN5pj4bW3TwWdK/vBVifNBeSWocGZWXPGOqygmLB3XUWa8zSRxeJE1/
         jsrJtXNLcpWY+yexKo5ef5Mi5Zt2QLdmvE8JBq/nyqPQTtlbRj6PQlOI8BfxV+7MpAt8
         GpKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770296255; x=1770901055; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i0tXoxNrqUNprC5lHUC5uQuYgNL8rns6TAwpzkMzmW0=;
        b=Zj8QiZIIfvydDSK0HtHdt1JvEMFv5ZKPnN352cnGi6u62bkAs/q0ZPTG/cJQTNRk/B
         ZJW8crg6VnocAEimhXL74Jl2m2yQF018JDynvfDA58wmHajIdR7LtKdIdht7Def6qc5n
         uJDR9RVBdPxTV3ZifFZD6Gn/Nc9qdoTslVUgs/l30TZ6p7kUI7DTnvLKo6bLQWOfBm/0
         XhKgzRm9lfu36jAm6tRsjqhpd97IrSyiezp+4TWvthJjXdInfNkh9HgojZo3N0ulfbGO
         1/xTH3S/V3et23a+C7/2UPsGFbKLcZSveMeO18MGPVWM+Qo/Ip1I4mSg9oE8nmHpeN2P
         0jGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770296255; x=1770901055;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i0tXoxNrqUNprC5lHUC5uQuYgNL8rns6TAwpzkMzmW0=;
        b=fWSsZnvXyx4fteA6QbTfyaPy7qwERidUqF2dsKG0Ci867au7B3TpnBkx0/EQLLo9Ed
         JG5Jm94/TaXj/91KqSilEENAbwKtzqJkPkidjkGo5AMouBaH0F1jGENSbSMKleIoRJp6
         7Ja56KE1ylr8zfXFTxcDvaurpcPL+3xfExA67Qays0hL0ZpGpPnDvHueXn4EzGnyobL2
         ZW5UDLxH938qjCHmwzRmh5hoydZWMj+Vsi/G50gPR005q8CDx2+MLqYMGsYNEE/CRtf5
         rDezw1B8b/EuW1Pcza0UE98jvAOHRi8hvZPXs1P9RxC1Vvnzw7OVlARbPdelw+6HSloX
         kxpg==
X-Gm-Message-State: AOJu0YytvYNmLJl2uJiK5xhOft2qaov5BI+l5k353uQNildWMYNzc1Fk
	lc7tBkVHsYDDhKd4X7NRfIDAu/14VNx1U9o+g0fZ9jwJRTIM75Vp3ZAZ3T4De2gwttH5cX60gdi
	rVaoirudnVm4dn2krtCYlBtOXScDZ0Lyo/PeD
X-Gm-Gg: AZuq6aLXySP5H/gGHSnTch+0UOy/p4QFTj7Osg81lohBPHMwix57j7GQ3HCRd04VYcx
	QqAFv8HX7AWShwxwcRVUdS3SExOqqFgzog7dyVsdt3DLcOcarqHXcGmRTNa9QO03xa4JSQFzxmc
	6qyKec0y6nJ9HDre1yl94SYjOpiUzZxqCzV34wYRsqFIcruPFzGrhUauvHgQiN60OToZebTur8w
	yUmjuALxnl3aw6NNAFax2oNuyRq1OJHj4CPSSrHH76r6dIssdcfhPyzSCGWncx7zxN9Dx0=
X-Received: by 2002:a17:90b:4b8a:b0:32d:a0f7:fa19 with SMTP id
 98e67ed59e1d1-354871938e6mr7503600a91.17.1770296255414; Thu, 05 Feb 2026
 04:57:35 -0800 (PST)
MIME-Version: 1.0
From: Zw Tang <shicenci@gmail.com>
Date: Thu, 5 Feb 2026 20:57:24 +0800
X-Gm-Features: AZwV_QjDTHGRFN0So-_CCiElDZ_kjRQAvoGB44WIaGt4o6PEh2_5MuYnPtg2dJo
Message-ID: <CAPHJ_V+75SmoRQmoQmAT0GfdP-JotzwW801uPHZtHyynwdSOgw@mail.gmail.com>
Subject: [BUG] rcu detected stall in shmem_file_write_iter
To: "linux-mm@kvack.org" <linux-mm@kvack.org>, rcu@vger.kernel.org
Cc: "hughd@google.com" <hughd@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, chrisl@kernel.org, 
	kasong@tencent.com, paulmck@kernel.org, frederic@kernel.org, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F389740009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rw68x74oyo7tmxhrngwia5ynxyfmbztf
X-HE-Tag: 1770296256-986763
X-HE-Meta: U2FsdGVkX18HJV6kO078ju6vCiZm8OeK1DQN6LnFotF1oq1NJ78KtfPBNvQcknhNvz2flqCtQfV00EpWodpoGShfjT47zXDzhyPwh+J4gyRZdhhqk9Pbn0xqD8T5XGUCBVN6tJnQexoX8hinZ60oPuxgw9UPDR01HU+fQZOEZvwx/uGvfL4ZWireeyCVQWngzQcTNpdws5BNX0i6mfre9HkRoAXoobAXQWxijA5BmueUOawY4wERIT9BmbR26kbvrZpSsae7o3RnCpcP6DTygmq0m+pCPXTKiC+N3lYgYaoYGffGsh8zne1L8tx6bxmHwrggl+N7QkULQ7YD09JrJIMIy4HaXGllmvP+Eghj6YuON9sUyeAZ7OfoTPSsYJR+qdABGdLBENoIOYWS5kqj2tIZIiU4FKZ2d4ZeuKCFVgWT257Z1sV6XjfnLzpOFgDF60PD0QdVHkSAohSfDgUzinB4ySumEWudv0nLbQhinUg7rYouQheUpyK1/r8Rbp7k7y5TR1BkhPTflLVLxnkN7Rj3bTCfdleoxTqkehbSTSFPbhjl1++oD8msdaMfg/va4ccSoXhj0e+OQfpKf1DOX+9GRolI6V3vZvEHLt907a8DEZb63M71Ydsi5b+LK4dsEeix1caHQ5JH4dEg+8yx/+UlNzfoGjjcjSWb+vDSBO6nXMMazalrACqaETYh8cK50l1a5m6TVOkP6fOyj0lTnGBTYfmn4SJf6txwHZ3EzPRpDrMgvUa8B2rX18YtrNtotDwwLB635WY90hPlW3Zd/5aLcoRktr5ie1ZB798nUKaM/YoRcjiudhsZqNrXhdKFkkRlq9iy1qb1YG83XtRmVm8I4YE7/MfF09RsiE1c77sEWv4qoWDlUDjMK467RdxHdNB0WfsCKCVa6Z+sgk7gz7GD1uhPhC7XPIhSpKPczOgczOOF4C2NaEhUej75heM0x2GoaQuUaRs+FzU2cXK
 abdZQdkP
 ueucwnMA/IJH3Ldm84HaLmvxWPVrhnlacSbBcv8gtX7iq7YOWFdte9bl4AH7GEL1O8wzrIo7/7vjDRuQKavTaReYAa5748fzZXUH4qqM243/7O0paSxWAOaBzzrZrW8SPibCcgTcPUJXSuDColZed7d+ukqcNvObrvFu7MgfHy8xoPabw+0gydPn51VdULfq7Y729mJkU+pGJ79mUZcDT8mMfbEWQdoRDTXRUHhwN6xKTkkE52H97onf1gWp1L0wpnlnq69I54XGCXSiZEV7P4rCyHIeVG6uuf1CpWXOsY7YGsK3YA7OIRaTgJbkIMMGw6hOcXi+E7yR4EjxE2j0n6BK7tVSUvRTpJbrRrj6M7BD3pXxt0X1Arbu/EGsB9EyKwhKVuuIkYcGl3CUtxQ4Wd7USYxpwylh+Rm2jxjdA8Fiz6cuh3BfXrUj8jejzL21yBivqom/R0bdFRLJEAgvNCglyB4T9wdSYmwHK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I am reporting a reproducible RCU stall observed on Linux 6.19.0-rc7,
triggered by a syzkaller C reproducer.

The stall is reported while a userspace task is executing the tmpfs
(shmem) write path. The blocked task is a syz-executor process, and the
RCU report consistently shows it running in the shmem write / folio
allocation path for an extended period of time.

The relevant call trace of the stalled task is:

  shmem_file_write_iter
    shmem_write_begin
      shmem_get_folio_gfp
        __folio_batch_add_and_move
          folio_batch_move_lru
            lru_add
              __mod_zone_page_state

The kernel eventually reports:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks

This suggests that the task spends an excessive amount of time in the
shmem write and folio/LRU accounting path, preventing the CPU from
reaching a quiescent state and triggering the RCU stall detector.

I am not yet certain whether the stall is caused by heavy memory
pressure, LRU/zone accounting contention, or an unintended long-running
critical section in the shmem write path, but the stall is consistently
associated with shmem_file_write_iter().

Reproducer:

C reproducer: https://pastebin.com/raw/AjQ5a5PL
console output: https://pastebin.com/raw/FyBF1R7b
kernel config: https://pastebin.com/raw/LwALTGZ5

Kernel:
git tree: torvalds/linux
HEAD commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
kernel version: 6.19.0-rc7 (QEMU Ubuntu 24.10)



rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu:  Tasks blocked on level-0 rcu_node (CPUs 0-1): P51643
rcu:  (detected by 1, t=100002 jiffies, g=470049, q=86 ncpus=2)
task:syz.3.5719      state:R  running task     stack:25640 pid:51643
tgid:51627 ppid:49386  task_flags:0x400140 flags:0x00080012
Call Trace:
 <IRQ>
 sched_show_task kernel/sched/core.c:7821 [inline]
 sched_show_task+0x357/0x510 kernel/sched/core.c:7796
 rcu_print_detail_task_stall_rnp kernel/rcu/tree_stall.h:292 [inline]
 print_other_cpu_stall kernel/rcu/tree_stall.h:681 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:856 [inline]
 rcu_pending kernel/rcu/tree.c:3667 [inline]
 rcu_sched_clock_irq+0x20ab/0x27e0 kernel/rcu/tree.c:2704
 update_process_times+0xf4/0x160 kernel/time/timer.c:2474
 tick_sched_handle kernel/time/tick-sched.c:298 [inline]
 tick_nohz_handler+0x504/0x720 kernel/time/tick-sched.c:319
 __run_hrtimer kernel/time/hrtimer.c:1777 [inline]
 __hrtimer_run_queues+0x274/0x810 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1045 [inline]
 __sysvec_apic_timer_interrupt+0x82/0x250 arch/x86/kernel/apic/apic.c:1062
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0x6b/0x80 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:finish_task_switch+0x128/0x610 kernel/sched/core.c:5118
Code: 02 00 0f 85 67 04 00 00 49 8b 9c 24 98 0a 00 00 48 85 db 0f 85
70 03 00 00 4c 89 e7 e8 61 78 92 02 fb 65 48 8b 1d 68 51 5d 04 <48> 8d
bb e0 0a 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1
RSP: 0018:ffff88802d32f630 EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff888012496900 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff888012496900 RDI: ffff88806d535b80
RBP: ffff88802d32f670 R08: 0000000000000000 R09: ffffffff817f85a5
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88806d535b80
R13: ffff88800635c600 R14: ffff88800f630f00 R15: ffff888012497374
 context_switch kernel/sched/core.c:5263 [inline]
 __schedule+0x1293/0x38c0 kernel/sched/core.c:6867
 preempt_schedule_irq+0x49/0x70 kernel/sched/core.c:7194
 irqentry_exit+0xc1/0x5a0 kernel/entry/common.c:216
 asm_sysvec_irq_work+0x1a/0x20 arch/x86/include/asm/idtentry.h:733
RIP: 0010:__mod_zone_page_state+0x12/0xf0 mm/vmstat.c:347
Code: 89 ef e8 b1 53 18 00 e9 54 ff ff ff 66 66 2e 0f 1f 84 00 00 00
00 00 90 f3 0f 1e fa 48 b8 00 00 00 00 00 fc ff df 41 55 41 54 <55> 48
89 fd 48 83 c7 70 53 48 89 f9 48 c1 e9 03 48 83 ec 10 80 3c
RSP: 0018:ffff88802d32f898 EFLAGS: 00000286
RAX: dffffc0000000000 RBX: ffff88800c0c4640 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000002 RDI: ffff88807ffdcc00
RBP: ffffea00014a5a00 R08: ffffffff846c1c01 R09: ffff88806d53b6d0
R10: ffff888006278000 R11: ffff8880062785bb R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000001
 __update_lru_size include/linux/mm_inline.h:48 [inline]
 update_lru_size include/linux/mm_inline.h:56 [inline]
 lruvec_add_folio include/linux/mm_inline.h:348 [inline]
 lru_add+0x44f/0x890 mm/swap.c:154
 folio_batch_move_lru+0x110/0x4c0 mm/swap.c:172
 __folio_batch_add_and_move+0x27e/0x7e0 mm/swap.c:196
 shmem_alloc_and_add_folio mm/shmem.c:1991 [inline]
 shmem_get_folio_gfp.isra.0+0xc49/0x1410 mm/shmem.c:2556
 shmem_get_folio mm/shmem.c:2662 [inline]
 shmem_write_begin+0x197/0x3b0 mm/shmem.c:3315
 generic_perform_write+0x37f/0x800 mm/filemap.c:4314
 shmem_file_write_iter+0x10d/0x140 mm/shmem.c:3490
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write fs/read_write.c:686 [inline]
 vfs_write+0xabc/0xe90 fs/read_write.c:666
 ksys_write+0x121/0x240 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xac/0x330 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f9b5abad69f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 f9 92 02 00 48 8b 54
24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d
00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 4c 93 02 00 48
RSP: 002b:00007f9b595eddf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000010000 RCX: 00007f9b5abad69f
RDX: 0000000000010000 RSI: 00007f9b511ce000 RDI: 0000000000000007
RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000002f2
R10: 00000000000001ce R11: 0000000000000293 R12: 0000000000000007
R13: 00007f9b595edef0 R14: 00007f9b595edeb0 R15: 00007f9b511ce000
 </TASK>

