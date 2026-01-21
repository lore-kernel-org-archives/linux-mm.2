Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527BBD262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 05:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E246B0005; Wed, 21 Jan 2026 00:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BB56B0088; Wed, 21 Jan 2026 00:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645366B0089; Wed, 21 Jan 2026 00:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 55CC86B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:11:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E51671AF7FB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:11:14 +0000 (UTC)
X-FDA: 84354797268.03.E9E945F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C38A80004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:11:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rzIZuWx/";
	spf=pass (imf02.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768972273;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ne86CKDqnkJjBz4B0ayNEWiIPON8UnJsoN0vgdn6nM8=;
	b=iHEc/heVQeieUofc9QpSll8UzrhqxD1gEGrZBiZ/ojgsvO3AC51ZjnWbMl/iszHAAbCENg
	+K2lX8Alezu7ZN/nwoWNlwThk3qVQWSv3O33ai8CbT8WMghj3ewXFCnJu8ejmpwV2o4Ryu
	4EsgZZfjSI3YZ6gIK0xCDrBSgOeSt6s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rzIZuWx/";
	spf=pass (imf02.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768972273; a=rsa-sha256;
	cv=none;
	b=zCie5ob39mJYE8JjCoC4m578nlVTuKDyLDyxN8jpK3Suid6iN4Tr8Sw2LG2qcxsL1YuITa
	7NZBRi3dZ1J8cNA7QUZD+lWR0Quv3jMSSyTWQw8kZYitGfyb0lpKYNSOblNO7RjPRmWazB
	jE4qduWSKPYRxL0mVCVsLzH9w8Nb0WU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E167640672;
	Wed, 21 Jan 2026 05:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5944C116D0;
	Wed, 21 Jan 2026 05:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768972271;
	bh=tXKw2Kfm7Hcj/r2mudz5RYjs1YO9anagvb806ehhVmw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=rzIZuWx/WP5TxFoM2ELx4gfrn08+yM4hnjCMRzKVG3GgKPJzAgqzk8ZbO8cfPhS72
	 WSs3GB2bNy17pO3Zxbtlkfe+Z17J8lRtklT9lTpicJV+e13fVh/J5flXW2dgs58E9l
	 3wK4h1eOuqmzo9fIlw1F98277j5X4Z6KTT6bXWI0pJLdvGSnmeR7EElSJphXQsxl2A
	 oND73PNApVAiHVcmkfv6NF5n975e0pXqRbF/Mpk3qq8u5Ouiq3PE4kF2NsctLH08cM
	 N+gQwt2gub/2S6mHmw11Vtt9FsRj2bO0qsGfRFUMZEYCw76l1AbHgNKbQPCVHErFqG
	 JxZoSS44dnv6g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 3ABF1CE0C56; Tue, 20 Jan 2026 21:11:11 -0800 (PST)
Date: Tue, 20 Jan 2026 21:11:11 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [next-20260120] KASAN: maybe wild-memory-access in
 select_task_rq_fair
Message-ID: <3e3af3b6-28fe-448f-90f1-4f2ed0c651f4@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <sjs2vhhxipw2zl7kya5owkrtdvrmj52dlqwul3r4rlyuodqnux@4rjdigvqofcr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sjs2vhhxipw2zl7kya5owkrtdvrmj52dlqwul3r4rlyuodqnux@4rjdigvqofcr>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2C38A80004
X-Stat-Signature: feiiysf6sicwwf83nm7jr3bnug7dmt6s
X-Rspam-User: 
X-HE-Tag: 1768972272-333000
X-HE-Meta: U2FsdGVkX19dju269kQv+Tsd0GDuXgtnln47h6gxtaUiQckPpVVIibHx3X9z+XM+0SdplRRuf70uoiEjKWsaf3GMIOi55SeK+ZPRSWHnVZ903bfwj5d0rJYOjSeF9dugbMvC/9UHYaBW2bD3KeegYfeG+IbwUrhg99gr1MZSkYK8x3tW/0cwSKCev06LoNDrCAIKiHaYpqTWPcR9X1evctOdE+JFfin3oghejCmpOWoLtvdJx5AIXgOCszeXI2fXvKcXR9saVQvD0ouPV8tgS6dAfSDguc5uwfX3pSDyiIGvV/zZ55Bj1jkoTeEyEjxsPtDr+h20p5Z3x8ieLOq1jQ9sTXZkDSzO5i1FNlGqS89tVx1ew1fsJbPPJ9qsfO84hOeLvplN8Ft/yhu3c+3m7IfB6hnVBWJGkdqtcL9PRVerqU38uCFLiJ9P8cblXC0dKUSolaql1eUcXr0E0DBrpMK75gNSkCzeTp0T8Jass+v44qZRsT49cc/V2qBMs8RnQLjlrAcVA2CDwcgpf2rtAJH1WSPh7CNT0GVOmf4284Ehg5DFar/1y0V00wtI/BoIcLDZgsSooykbsqFM1mlS0GIsYEdM2VNCn+XiwsAHyxJsWWTCtan/yGZypKZXI0TcAhHCo+RKdiqlQDETAhUCwp/DlORpKPFwpp9bOhHYXI6sRpS6piUMbbtTpiU/ZiIsORxnBg0/EN5Wh01hvmsZshTUiIPjA9YGkT29r5TCZhQbNC9NsiU2kLKSHsTogkC+eFI+KmJVqrDLACv7ijL5dq4ptRmo8AjPewYhRYGhTfuUaLTg3pJuyheskFxYbQMxVrHFPzs7MBQVZzF/yX8naGRBqjaHAh/rMgGBpA+a8psJYKsrfhMJT7lg5Bmu/klgugDxdzkg+AEtMsS7y/tWGwBmN9yEtnyJBoxuBgXYJnQ6WHeQf2LQI9PCHlqALDr+txR2BIpqQ9g1FlfOqhg
 rRrClRiF
 gYSelI646ISknauV/1vY+pLPNKjlNZCJFpGOsc9Qo5QZZk5vgTZER/Wx+YT4cP7V/LhRoebzIuOMjFu+8zJkfVYogJxfu2afB3JjnnZGhuK4h6FmuQY14YEba/iNHXLQTLtWDa51A7z9MkpZUctYnmij81g+YsM50jQYvPPe28P8mAd7zwYSWhsqN96VioRoTaVro2hBLQU/4z+wBqH5JFdNvEUJmS8mRlAQOa5g5kfohTUc/P7BTRIC2NDBbFGvhafS1qB6yIFsPCGtXpHQNsFCpdFlNywQAWawffhcKMPsOeiOvXZgTuihDsoKeT434ir9PJ99JDDseM9kPhASXLzijIEKYMShnHW5U2x3kIuvK813cpPvhv4Xa1aajvYF1CNRVaOVKLwy0nmLF1IadFr6UN8KkYrc1a6/O7iKkIsGIc4af0kvaLFB8a50knKheI3DI+kH0K+1gtE4qQYQK3YNZitj7mxzRXO01UhESlzo6Lvv0msQ1CRWVrnMRteAEMBEC0OTP88w8KajJ4ZyLNDpPMJNA7KHE0u0+JufZ8ZrmSL6BxFl2XrJWUi4JZicgKk/YLCXGDGmu7z8k7ox0eH4yITmw29JHAaNUde7H8Yv5ND2Tjyyd1urgzjk/PNSpvUqh88kT1WvDDc84VR1rngy2lDmpsveotsY5qIhuBVbRCZf0zCksLbFcEjW8NiIBOday
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 01:03:02PM +0900, Sergey Senozhatsky wrote:
> Hello,
> 
> I'm seeing the following KASAN report on next-20260120 (qemu x86_64).
> There seems to be a lot of stuff going on in the call trace:

I'll say!

> [    1.714941][  T136] ==================================================================
> [    1.715713][    C0] Oops: general protection fault, probably for non-canonical address 0xeb1125008e9810b0: 0000 [#1] SMP KASAN
> [    1.715702][  T136] ------------[ cut here ]------------
> [    1.716702][    C0] KASAN: maybe wild-memory-access in range [0x5889480474c08580-0x5889480474c08587]
> [    1.716702][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> [    1.715702][  T136] WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0xb6/0xe0, CPU#2: devtmpf.X/136

This is most likely to happen when you do an rcu_read_unlock()
without a matchine rcu_read_lock().  It could also happen if you
nested rcu_read_lock() a billion deep.  Or if RCU had a strange
bug.  Or if someone corrupted the current task_struct structure's
=>rcu_read_lock_nesting field.

Is it feasible to bisect this?

							Thanx, Paul

> [    1.716702][    C0] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
> [    1.716702][    C0] RIP: 0010:select_task_rq_fair+0x37b/0x920
> [    1.715702][  T136] Modules linked in:
> [    1.716702][    C0] Code: 3c 02 00 0f 85 9b 05 00 00 4d 8b 26 4d 85 e4 0f 84 5e 04 00 00 4d 8d 6c 24 3c b8 ff ff 37 00 4c 89 ee 48 c1 e0 2a 48 c1 ee 03 <0f> b6 34 06 4c 89 e8 83 e0 07 83 c0 03 40 38 f0 7c 0d 40 84 f6 74
> [    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> [    1.716702][    C0] RSP: 0000:ffff88875ea08a08 EFLAGS: 00010003
> [    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
> [    1.716702][    C0] 
> [    1.716702][    C0] RAX: dffffc0000000000 RBX: 0000000000000008 RCX: 0000000000000000
> [    1.716702][    C0] RDX: 1ffffffff032f83e RSI: 0b1129008e9810b0 RDI: ffff88875ea37ed0
> [    1.716702][    C0] RBP: ffff888100bf2240 R08: 0000000000000000 R09: 0000000000000000
> [    1.716702][    C0] R10: ffffffff814b2ddb R11: ffff88875ea08ff8 R12: 5889480474c08548
> [    1.716702][    C0] R13: 5889480474c08584 R14: ffffffff8197c1f5 R15: 0000000000000000
> [    1.716702][    C0] FS:  0000000000000000(0000) GS:ffff8887da44b000(0000) knlGS:0000000000000000
> [    1.716702][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.716702][    C0] CR2: ffff888005601000 CR3: 000000000387d001 CR4: 0000000000770ef0
> [    1.716702][    C0] PKRU: 55555554
> [    1.716702][    C0] Call Trace:
> [    1.716702][    C0]  <IRQ>
> [    1.716702][    C0]  ? select_idle_sibling+0x1490/0x1490
> [    1.716702][    C0]  ? select_idle_sibling+0x1490/0x1490
> [    1.716702][    C0]  select_task_rq+0x13a/0x410
> [    1.716702][    C0]  try_to_wake_up+0x429/0xfc0
> [    1.716702][    C0]  ? select_task_rq+0x410/0x410
> [    1.716702][    C0]  ? lock_acquire+0xe2/0x110
> [    1.716702][    C0]  ? call_timer_fn+0x116/0x3b0
> [    1.716702][    C0]  ? hrtimers_cpu_dying+0x4f0/0x4f0
> [    1.716702][    C0]  call_timer_fn+0x157/0x3b0
> [    1.716702][    C0]  ? do_raw_spin_lock+0x124/0x260
> [    1.716702][    C0]  ? __try_to_del_timer_sync+0x120/0x120
> [    1.716702][    C0]  ? __rwlock_init+0x140/0x140
> [    1.716702][    C0]  ? find_held_lock+0x2b/0x80
> [    1.716702][    C0]  ? start_dl_timer+0x28c/0x4c0
> [    1.716702][    C0]  expire_timers+0x20b/0x3a0
> [    1.716702][    C0]  ? hrtimers_cpu_dying+0x4f0/0x4f0
> [    1.716702][    C0]  __run_timer_base.part.0+0x4aa/0x610
> [    1.716702][    C0]  ? expire_timers+0x3a0/0x3a0
> [    1.716702][    C0]  ? tmigr_requires_handle_remote+0x154/0x270
> [    1.716702][    C0]  ? kvm_sched_clock_read+0xd/0x20
> [    1.716702][    C0]  ? sched_clock_cpu+0x139/0x4f0
> [    1.716702][    C0]  ? lock_acquire+0xe2/0x110
> [    1.716702][    C0]  ? sched_clock_tick+0x5f/0x240
> [    1.716702][    C0]  ? do_raw_spin_lock+0x124/0x260
> [    1.716702][    C0]  run_timer_softirq+0x128/0x210
> [    1.716702][    C0]  ? timer_delete_sync_try+0xe0/0xe0
> [    1.716702][    C0]  ? nohz_run_idle_balance+0x170/0x170
> [    1.716702][    C0]  handle_softirqs+0x1c6/0x680
> [    1.716702][    C0]  ? ktime_get+0x1a6/0x1d0
> [    1.716702][    C0]  ? tasklet_unlock_wait+0x50/0x50
> [    1.716702][    C0]  ? clockevents_program_event+0x1c5/0x270
> [    1.716702][    C0]  __irq_exit_rcu+0xaf/0xe0
> [    1.716702][    C0]  irq_exit_rcu+0x5/0x10
> [    1.716702][    C0]  sysvec_apic_timer_interrupt+0x67/0x80
> [    1.716702][    C0]  </IRQ>
> [    1.716702][    C0]  <TASK>
> [    1.716702][    C0]  asm_sysvec_apic_timer_interrupt+0x16/0x20
> [    1.716702][    C0] RIP: 0010:pv_native_safe_halt+0xb/0x10
> [    1.716702][    C0] Code: 48 8b 3d d8 7f 69 01 e8 23 00 00 00 48 2b 05 5c 90 6d 00 c3 cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d 57 8d 11 00 fb f4 <c3> cc cc cc cc 8b 17 48 89 fe 89 d7 83 e7 fe 0f 01 f9 66 90 0f be
> [    1.716702][    C0] RSP: 0000:ffffffff83807e20 EFLAGS: 00000202
> [    1.716702][    C0] RAX: 00000000000038f1 RBX: ffffffff8381b480 RCX: ffffed10ebd463b3
> [    1.716702][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff814e855b
> [    1.716702][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10ebd463b2
> [    1.716702][    C0] R10: ffff88875ea31d93 R11: 0000000000000000 R12: 0000000000000000
> [    1.716702][    C0] R13: 1ffffffff0700fc8 R14: dffffc0000000000 R15: 0000000000014790
> [    1.716702][    C0]  ? cpuidle_idle_call+0x22b/0x360
> [    1.716702][    C0]  default_idle+0x5/0x10
> [    1.716702][    C0]  default_idle_call+0x68/0xa0
> [    1.716702][    C0]  cpuidle_idle_call+0x22b/0x360
> [    1.716702][    C0]  ? arch_cpu_idle_exit+0x30/0x30
> [    1.716702][    C0]  ? mark_tsc_async_resets+0x10/0x10
> [    1.716702][    C0]  ? lockdep_hardirqs_on_prepare.part.0+0x93/0x130
> [    1.716702][    C0]  do_idle+0xd0/0x120
> [    1.716702][    C0]  cpu_startup_entry+0x4b/0x60
> [    1.716702][    C0]  rest_init+0x1aa/0x1b0
> [    1.716702][    C0]  start_kernel+0x37f/0x380
> [    1.716702][    C0]  x86_64_start_reservations+0x20/0x20
> [    1.716702][    C0]  x86_64_start_kernel+0xd1/0xe0
> [    1.716702][    C0]  common_startup_64+0x12c/0x138
> [    1.716702][    C0]  </TASK>
> [    1.716702][    C0] Modules linked in:
> [    1.716702][    C0] ---[ end trace 0000000000000000 ]---
> [    1.715702][  T136] Oops: general protection fault, probably for non-canonical address 0xdffffc00f06bbbfd: 0000 [#2] SMP KASAN
> [    1.716702][    C0] RIP: 0010:select_task_rq_fair+0x37b/0x920
> [    1.715702][  T136] KASAN: probably user-memory-access in range [0x00000007835ddfe8-0x00000007835ddfef]
> [    1.716702][    C0] Code: 3c 02 00 0f 85 9b 05 00 00 4d 8b 26 4d 85 e4 0f 84 5e 04 00 00 4d 8d 6c 24 3c b8 ff ff 37 00 4c 89 ee 48 c1 e0 2a 48 c1 ee 03 <0f> b6 34 06 4c 89 e8 83 e0 07 83 c0 03 40 38 f0 7c 0d 40 84 f6 74
> [    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Tainted: G      D             6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> [    1.716702][    C0] RSP: 0000:ffff88875ea08a08 EFLAGS: 00010003
> [    1.715702][  T136] Tainted: [D]=DIE
> [    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
> [    1.716702][    C0] RAX: dffffc0000000000 RBX: 0000000000000008 RCX: 0000000000000000
> [    1.715702][  T136] Oops: general protection fault, probably for non-canonical address 0xdffffc00f06bbbfd: 0000 [#3] SMP KASAN
> [    1.716702][    C0] RDX: 1ffffffff032f83e RSI: 0b1129008e9810b0 RDI: ffff88875ea37ed0
> [    1.715702][  T136] KASAN: probably user-memory-access in range [0x00000007835ddfe8-0x00000007835ddfef]
> [    1.716702][    C0] RBP: ffff888100bf2240 R08: 0000000000000000 R09: 0000000000000000
> [    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Tainted: G      D             6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> [    1.716702][    C0] R10: ffffffff814b2ddb R11: ffff88875ea08ff8 R12: 5889480474c08548
> [    1.715702][  T136] Tainted: [D]=DIE
> [    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
> [    1.716702][    C0] R13: 5889480474c08584 R14: ffffffff8197c1f5 R15: 0000000000000000
> [    1.715702][  T136] Oops: general protection fault, probably for non-canonical address 0xdffffc00f06bbbfd: 0000 [#4] SMP KASAN
> [    1.716702][    C0] FS:  0000000000000000(0000) GS:ffff8887da44b000(0000) knlGS:0000000000000000
> [    1.715702][  T136] KASAN: probably user-memory-access in range [0x00000007835ddfe8-0x00000007835ddfef]
> [    1.716702][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.715702][  T136] CPU: 2 UID: 62500582 PID: 136 Comm: devtmpf.X Tainted: G      D             6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> [    1.716702][    C0] CR2: ffff888005601000 CR3: 000000000387d001 CR4: 0000000000770ef0
> [    1.715702][  T136] Tainted: [D]=DIE
> [    1.716702][    C0] PKRU: 55555554
> [    1.715702][  T136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
> [    1.716702][    C0] Kernel panic - not syncing: Fatal exception in interrupt
> [    1.716702][    C0] Shutting down cpus with NMI
> [    1.716702][    C0] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

