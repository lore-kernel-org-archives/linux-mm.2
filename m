Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E694ED262B7
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 04:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA546B0005; Tue, 20 Jan 2026 23:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DFE6B0088; Tue, 20 Jan 2026 23:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123066B0089; Tue, 20 Jan 2026 23:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F180F6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:03:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 850908C1AC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:03:10 +0000 (UTC)
X-FDA: 84354625740.14.09479AC
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id B7CAA4000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:03:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ensUz3Uf;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768968188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TekwQ3J0KyQkj/qQm3KrtJdP85jEKbVPLKoOFYK4/24=;
	b=iX7nNPygNkMa6ylC28YGu3l1ahCp0+XhAG8drzloN8f7WZGWPbU4+RM9dBKkfXeR2JgLlZ
	OX+OCsegF18j24YDVmcgMWwAKZXblBJoWUuhh0/qfMzpOeP+kNRn+5GIrcRacvxh8gHkog
	wuKa3wSuYqo/ReasbFYLPORwJXBHoUU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ensUz3Uf;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768968188; a=rsa-sha256;
	cv=none;
	b=E4yAcn0a1fbIRKAi+6k/34SQbwSh41sFZnK93HSjrspCUwwoYtA9bi7SKqalfLDYVleALf
	C6yGgP55ZIFM8UgJ9az8PmLjQdD4wgM4ZO5EmVs18p7IyGR5BL9ArR9SWs1C371o6NqjEo
	6apvnocTG24Fk9x7/puwg0Fo6Y8UA+4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29f2676bb21so61177485ad.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768968187; x=1769572987; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TekwQ3J0KyQkj/qQm3KrtJdP85jEKbVPLKoOFYK4/24=;
        b=ensUz3UfKcFVtOLSgLlEKfk/SRRZ9sLzrugglDBvN6yiX0/zeHW8tQH7LQ8v6U4gcF
         ueiY1FY+DpEf48moP100yldjjrOzEaY7oYJR/GUkeEFDqIb4EMFEYzCvZAqs9bc58u2n
         P0BLaCkDi2PQxQ9jmX0rk+Z1pOoFKwdKIMAmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768968187; x=1769572987;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TekwQ3J0KyQkj/qQm3KrtJdP85jEKbVPLKoOFYK4/24=;
        b=bQqhcsQtZWD93eJ3+MxeDubhvmTUB1BDQPmFFVHbJy6j0FxhyyE+QzDlVT1ma7BZgo
         vgC6stpOnPVrDlRXUb2MAIeCASTgKJTdzJGhCTfuurS2GogjcnuIN428YxM5FSQhCAGV
         3Y4WGi20edQ4d9fW8NIC+qP7uqSGPJt2IRwio4H5GMQdm6NN6upH4GDxpqj2kmOGS7m2
         aVmdJ9vqI9ZoH/WunsXgZPeTLMutOlF0+B26019OSPpmCq7yW2j2BTzupTXcCs1nFWHm
         T7bFvy61P8rreizj2AKF82hp6KKJoVy3ql3tdZKGUT74IeWICrBJxeEY23ZXb8aSo0Sg
         8vBA==
X-Forwarded-Encrypted: i=1; AJvYcCW0OnmDVSkTYlEi7Fe4di8K7JmP3ALyBP0Pw5Zpcwp3A+Y68ON5xbYP6kIMy20oZAAZdsICvh7+/A==@kvack.org
X-Gm-Message-State: AOJu0YxuyhzUIuvCPGV0ZEhkXpVvsEuaQt9gZb9cG79Ixcs4tMks7G0n
	diF5cUXZni0j0J9BxDYTlCP3zIGpTjPW1D3srlXR1M2MLCi/dzdYgQ76m4BC0P4jNQ==
X-Gm-Gg: AZuq6aL+ElnsQ/dLcr/pJlRNDNKSMCjFjFb4MgT3abC6lc1NZ2RQyRyhr8Uu8uy2R/3
	2BKrM0dgb2300F1qrCHHtDj3kl1XZN/n4jHuDBsnm3W+dNVQ4mfOKG6R246qk0z/fUEvr/DNJow
	n47GKTbYF6+adxJQlArAolfiw+P/7v/pNZ8UBy4pBqVm9XPcxnDFTRo/gtg5RQdn+2/J5U/9aH2
	DUK7JksH8E6Twq+08amvEyBgwzIY2J7EhLUTA94h0Ow53ddEFKWSOc2ePr21/2FdPlaRja8Bs/v
	DGPROpUwdyYlbt21/mwtoXZT19EDewAKVpl8YWXo/d1dHCzq6GYUSBaN2LbsuHwSL6rRtVpvPiK
	q32mSOey+MaPOllTn908cV+8CWKaNUHaqkSoTk0+IbCTPk8iYYZy3Zt3o0wgA6XqVxURDmGRNFE
	aNL7ZnbHOtG2Bd8mR/lN+hUYFfJ42BkhV947eKpnY77a8QhjF+llZYCdlEPdCJ
X-Received: by 2002:a17:903:2443:b0:2a0:c35c:572e with SMTP id d9443c01a7336-2a7188f91c2mr184314765ad.30.1768968187292;
        Tue, 20 Jan 2026 20:03:07 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a85f:a6d:c028:515a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a77888c23asm26026915ad.75.2026.01.20.20.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 20:03:06 -0800 (PST)
Date: Wed, 21 Jan 2026 13:03:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: [next-20260120] KASAN: maybe wild-memory-access in
 select_task_rq_fair
Message-ID: <sjs2vhhxipw2zl7kya5owkrtdvrmj52dlqwul3r4rlyuodqnux@4rjdigvqofcr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B7CAA4000D
X-Rspam-User: 
X-Stat-Signature: 8xqxamr7wa9p7nyhya9ufjifc4ugh96e
X-Rspamd-Server: rspam08
X-HE-Tag: 1768968188-557609
X-HE-Meta: U2FsdGVkX19TRyTylL1v7xUNwBqfe4FwR40jSl9y0y+FqhwaXgESRh447MoyuqheBXIYsxeIrerLpKDRAsDs37LiR6TxbbQKuSZdLgT5at8GaOsyPEH0R4imxkGIETRJZByk6bdd71o7Lg6kBpdevjq7RoPxrtFJA3J309u1Yhg6h3dJPcwNIJAY9NJziADqpF2DqF7kSjRsbHU+miBkqmTKHwPzvR/4Zu/V1SZUcoT5HlEjhuNTIqIWVeTr9QQAPsVJSOBtpQT3TDSgwxkMeb8cmbEK2ND1B4tq2Psu674K9K7b1dHLDI29uBFHy8Zoq3s7gTz7/d/e6UFkH+K+1/K731ywQCL7y6f94ahP6K6PoXOnX7a2zRWA+8QkQBhcaMAzpGs26FpIOJpCD2w9PTvN0QH5E8GOU/Q4LHeCQ3elqXxOkNDE0nfV5nVFSxOH71m/wruaWqWE7fTjhadLXq9b2Dn/n5Ftnp8Ge3Hb7FqwFATODEqBZhAJPDfQ8dxq++TBPrqAxLDTtriUecC/V4gGYY3a4v/uE262BUuzDTXj5oHzkjSwL+D2GgPEAVie/v7DQ3hYhsyKfbCol/QD7MPmO8A9DYAG4Q1LTboYKNlNpRZ7z0bwTBosvffTv544YHaGlZ/mdVxQ5v2ee2EH8+BXExH69ySUWuee3PTb1ZgoHv4yA9nKyJ7i6zHuLPHkZy8UIVQsfQ4Y5Or4JcHrR1PeTQageILjhMeCA0JCfI/yMjN/iltxCb1VuQZT6v+DEH1BT0TB30wv5hMbtnaKyfDdFvYV0AMsbwJXFoXiELfC5crcDw5EJMxJrTp8gijOBzB3dpTtvU800PliTvC6zJ2NG8/e1yv3iVo37/2tVKhhkr5Y2tjkBYseKjdVRFkzCMlajojpjZvWqb0XpKtfz6PReLVkhpmTLiYtZFTnOFdfxllWnUlJ3xZI0roGFW56q+x7WCy/4wfTjF6Iz01
 42m21fZK
 Z8NMXKUxsAzpzhr1kWmAJOK7FO8Q2oncnq2ri969uScYZ7pHIuwXZAqsKoqcCOe2cHU9xOa1BSWpAZUUWFZ0BjsnAZLqWRFSVqp4je5xa9g4qgZws/M7y0fAJ3BtUBbuL4vCieeA0GPJZLi7g/wAoPySe+xqOw7cbTLO4JtF39SGKOzZswLADS+xWlCd1R7B9FBGVl/HkEFcgWp6ox1UDjQRQ8GdjoCTyJFNzx5eESzFkrdaLvdxkzsxbEOfGM7gVLuGXm8WdS+JiRhqUOiMKO6iORzCXZ08t+K7HACGaxtUKENKx/kwKcEKSL1qfe5J5+I3WvSnH7DKn0fR+DL3vXpN/CQxmlpFjOJMlI0ue0fNzQ101v/jDng2W2YV60NVLVEnmsnh4agcvqI1pSx0uhRofHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I'm seeing the following KASAN report on next-20260120 (qemu x86_64).
There seems to be a lot of stuff going on in the call trace:

[    1.714941][  T136] ==================================================================
[    1.715713][    C0] Oops: general protection fault, probably for non-canonical address 0xeb1125008e9810b0: 0000 [#1] SMP KASAN
[    1.715702][  T136] ------------[ cut here ]------------
[    1.716702][    C0] KASAN: maybe wild-memory-access in range [0x5889480474c08580-0x5889480474c08587]
[    1.716702][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
[    1.715702][  T136] WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0xb6/0xe0, CPU#2: devtmpf.X/136
[    1.716702][    C0] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
[    1.716702][    C0] RIP: 0010:select_task_rq_fair+0x37b/0x920
[    1.715702][  T136] Modules linked in:
[    1.716702][    C0] Code: 3c 02 00 0f 85 9b 05 00 00 4d 8b 26 4d 85 e4 0f 84 5e 04 00 00 4d 8d 6c 24 3c b8 ff ff 37 00 4c 89 ee 48 c1 e0 2a 48 c1 ee 03 <0f> b6 34 06 4c 89 e8 83 e0 07 83 c0 03 40 38 f0 7c 0d 40 84 f6 74
[    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
[    1.716702][    C0] RSP: 0000:ffff88875ea08a08 EFLAGS: 00010003
[    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
[    1.716702][    C0] 
[    1.716702][    C0] RAX: dffffc0000000000 RBX: 0000000000000008 RCX: 0000000000000000
[    1.716702][    C0] RDX: 1ffffffff032f83e RSI: 0b1129008e9810b0 RDI: ffff88875ea37ed0
[    1.716702][    C0] RBP: ffff888100bf2240 R08: 0000000000000000 R09: 0000000000000000
[    1.716702][    C0] R10: ffffffff814b2ddb R11: ffff88875ea08ff8 R12: 5889480474c08548
[    1.716702][    C0] R13: 5889480474c08584 R14: ffffffff8197c1f5 R15: 0000000000000000
[    1.716702][    C0] FS:  0000000000000000(0000) GS:ffff8887da44b000(0000) knlGS:0000000000000000
[    1.716702][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.716702][    C0] CR2: ffff888005601000 CR3: 000000000387d001 CR4: 0000000000770ef0
[    1.716702][    C0] PKRU: 55555554
[    1.716702][    C0] Call Trace:
[    1.716702][    C0]  <IRQ>
[    1.716702][    C0]  ? select_idle_sibling+0x1490/0x1490
[    1.716702][    C0]  ? select_idle_sibling+0x1490/0x1490
[    1.716702][    C0]  select_task_rq+0x13a/0x410
[    1.716702][    C0]  try_to_wake_up+0x429/0xfc0
[    1.716702][    C0]  ? select_task_rq+0x410/0x410
[    1.716702][    C0]  ? lock_acquire+0xe2/0x110
[    1.716702][    C0]  ? call_timer_fn+0x116/0x3b0
[    1.716702][    C0]  ? hrtimers_cpu_dying+0x4f0/0x4f0
[    1.716702][    C0]  call_timer_fn+0x157/0x3b0
[    1.716702][    C0]  ? do_raw_spin_lock+0x124/0x260
[    1.716702][    C0]  ? __try_to_del_timer_sync+0x120/0x120
[    1.716702][    C0]  ? __rwlock_init+0x140/0x140
[    1.716702][    C0]  ? find_held_lock+0x2b/0x80
[    1.716702][    C0]  ? start_dl_timer+0x28c/0x4c0
[    1.716702][    C0]  expire_timers+0x20b/0x3a0
[    1.716702][    C0]  ? hrtimers_cpu_dying+0x4f0/0x4f0
[    1.716702][    C0]  __run_timer_base.part.0+0x4aa/0x610
[    1.716702][    C0]  ? expire_timers+0x3a0/0x3a0
[    1.716702][    C0]  ? tmigr_requires_handle_remote+0x154/0x270
[    1.716702][    C0]  ? kvm_sched_clock_read+0xd/0x20
[    1.716702][    C0]  ? sched_clock_cpu+0x139/0x4f0
[    1.716702][    C0]  ? lock_acquire+0xe2/0x110
[    1.716702][    C0]  ? sched_clock_tick+0x5f/0x240
[    1.716702][    C0]  ? do_raw_spin_lock+0x124/0x260
[    1.716702][    C0]  run_timer_softirq+0x128/0x210
[    1.716702][    C0]  ? timer_delete_sync_try+0xe0/0xe0
[    1.716702][    C0]  ? nohz_run_idle_balance+0x170/0x170
[    1.716702][    C0]  handle_softirqs+0x1c6/0x680
[    1.716702][    C0]  ? ktime_get+0x1a6/0x1d0
[    1.716702][    C0]  ? tasklet_unlock_wait+0x50/0x50
[    1.716702][    C0]  ? clockevents_program_event+0x1c5/0x270
[    1.716702][    C0]  __irq_exit_rcu+0xaf/0xe0
[    1.716702][    C0]  irq_exit_rcu+0x5/0x10
[    1.716702][    C0]  sysvec_apic_timer_interrupt+0x67/0x80
[    1.716702][    C0]  </IRQ>
[    1.716702][    C0]  <TASK>
[    1.716702][    C0]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[    1.716702][    C0] RIP: 0010:pv_native_safe_halt+0xb/0x10
[    1.716702][    C0] Code: 48 8b 3d d8 7f 69 01 e8 23 00 00 00 48 2b 05 5c 90 6d 00 c3 cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d 57 8d 11 00 fb f4 <c3> cc cc cc cc 8b 17 48 89 fe 89 d7 83 e7 fe 0f 01 f9 66 90 0f be
[    1.716702][    C0] RSP: 0000:ffffffff83807e20 EFLAGS: 00000202
[    1.716702][    C0] RAX: 00000000000038f1 RBX: ffffffff8381b480 RCX: ffffed10ebd463b3
[    1.716702][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff814e855b
[    1.716702][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10ebd463b2
[    1.716702][    C0] R10: ffff88875ea31d93 R11: 0000000000000000 R12: 0000000000000000
[    1.716702][    C0] R13: 1ffffffff0700fc8 R14: dffffc0000000000 R15: 0000000000014790
[    1.716702][    C0]  ? cpuidle_idle_call+0x22b/0x360
[    1.716702][    C0]  default_idle+0x5/0x10
[    1.716702][    C0]  default_idle_call+0x68/0xa0
[    1.716702][    C0]  cpuidle_idle_call+0x22b/0x360
[    1.716702][    C0]  ? arch_cpu_idle_exit+0x30/0x30
[    1.716702][    C0]  ? mark_tsc_async_resets+0x10/0x10
[    1.716702][    C0]  ? lockdep_hardirqs_on_prepare.part.0+0x93/0x130
[    1.716702][    C0]  do_idle+0xd0/0x120
[    1.716702][    C0]  cpu_startup_entry+0x4b/0x60
[    1.716702][    C0]  rest_init+0x1aa/0x1b0
[    1.716702][    C0]  start_kernel+0x37f/0x380
[    1.716702][    C0]  x86_64_start_reservations+0x20/0x20
[    1.716702][    C0]  x86_64_start_kernel+0xd1/0xe0
[    1.716702][    C0]  common_startup_64+0x12c/0x138
[    1.716702][    C0]  </TASK>
[    1.716702][    C0] Modules linked in:
[    1.716702][    C0] ---[ end trace 0000000000000000 ]---
[    1.715702][  T136] Oops: general protection fault, probably for non-canonical address 0xdffffc00f06bbbfd: 0000 [#2] SMP KASAN
[    1.716702][    C0] RIP: 0010:select_task_rq_fair+0x37b/0x920
[    1.715702][  T136] KASAN: probably user-memory-access in range [0x00000007835ddfe8-0x00000007835ddfef]
[    1.716702][    C0] Code: 3c 02 00 0f 85 9b 05 00 00 4d 8b 26 4d 85 e4 0f 84 5e 04 00 00 4d 8d 6c 24 3c b8 ff ff 37 00 4c 89 ee 48 c1 e0 2a 48 c1 ee 03 <0f> b6 34 06 4c 89 e8 83 e0 07 83 c0 03 40 38 f0 7c 0d 40 84 f6 74
[    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Tainted: G      D             6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
[    1.716702][    C0] RSP: 0000:ffff88875ea08a08 EFLAGS: 00010003
[    1.715702][  T136] Tainted: [D]=DIE
[    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
[    1.716702][    C0] RAX: dffffc0000000000 RBX: 0000000000000008 RCX: 0000000000000000
[    1.715702][  T136] Oops: general protection fault, probably for non-canonical address 0xdffffc00f06bbbfd: 0000 [#3] SMP KASAN
[    1.716702][    C0] RDX: 1ffffffff032f83e RSI: 0b1129008e9810b0 RDI: ffff88875ea37ed0
[    1.715702][  T136] KASAN: probably user-memory-access in range [0x00000007835ddfe8-0x00000007835ddfef]
[    1.716702][    C0] RBP: ffff888100bf2240 R08: 0000000000000000 R09: 0000000000000000
[    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Tainted: G      D             6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
[    1.716702][    C0] R10: ffffffff814b2ddb R11: ffff88875ea08ff8 R12: 5889480474c08548
[    1.715702][  T136] Tainted: [D]=DIE
[    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
[    1.716702][    C0] R13: 5889480474c08584 R14: ffffffff8197c1f5 R15: 0000000000000000
[    1.715702][  T136] Oops: general protection fault, probably for non-canonical address 0xdffffc00f06bbbfd: 0000 [#4] SMP KASAN
[    1.716702][    C0] FS:  0000000000000000(0000) GS:ffff8887da44b000(0000) knlGS:0000000000000000
[    1.715702][  T136] KASAN: probably user-memory-access in range [0x00000007835ddfe8-0x00000007835ddfef]
[    1.716702][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Tainted: G      D             6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
[    1.716702][    C0] CR2: ffff888005601000 CR3: 000000000387d001 CR4: 0000000000770ef0
[    1.715702][  T136] Tainted: [D]=DIE
[    1.716702][    C0] PKRU: 55555554
[    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
[    1.716702][    C0] Kernel panic - not syncing: Fatal exception in interrupt
[    1.716702][    C0] Shutting down cpus with NMI
[    1.716702][    C0] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

