Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 095ACC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70626B008C; Wed, 16 Sep 2026 14:05:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48F86B0092; Wed, 16 Sep 2026 14:05:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DF36B0093; Wed, 16 Sep 2026 14:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9E686B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:05:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D7DC14081D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:05:15 +0000 (UTC)
X-FDA: 85220402190.05.2CC19DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 90E9B180013
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:05:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBOn4oDJ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789581913;
	b=yIH69ZXmszCU3dO9wXY74W+xdiLvHvrCZCCHaF49hCrkJnQ/o6w0x0vmj/WJtjXHkWggkI
	x+ebwU8LJRfWftrQBqZskjfHR9yBw+kaTWpdpcoCyvIsnMMyklaRb7XMn7O3/8SO8V2CkC
	u2YJThuYb5LOHKliyJOhNz2Bw3RF6q0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBOn4oDJ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789581913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLavNa5baPsJJ8TTW5wCZFKvbxP4p6FhMLkehjF3Fac=;
	b=jiqvXddl5zKDkLpFzEbeaZxsSbNkwwcwrIKaJoZar8T0g4WPqBRLxcrAyscBeDZYf9IYTJ
	2DoOBR8Z9o4MZM0i8C/z+gMocjQ/2hR65jny5TsP2IEbS8mkjlpjXAwWq01Y/3jOQ2UXC0
	XRYTb+uXauDu/QEXl29DfRtwEdMcDKI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AE574050B;
	Wed, 16 Sep 2026 18:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8E81F000FF;
	Wed, 16 Sep 2026 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789581912;
	bh=hLavNa5baPsJJ8TTW5wCZFKvbxP4p6FhMLkehjF3Fac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hBOn4oDJU4DM0Q8Y8eUE9VLiSL+ysgK+OFWFO1vkwGi0Gdbo7DoQ+t8aUSgS1b8Yn
	 S+qk+mRxRsNwwge37HcdsqPSgElEB/Fj85B2uDJ8Z6b54aXOgIRBHAyiVirvU+Q7Fn
	 QP6iowl6AMIgACiS3kgJGsnkE/Z12rjSj88MWaSV+xt0FC4NJVWCAc8m5JJUlP2O56
	 f7dzwv8u2faEAerorAWJu+7f/I7JnAo7zj2nkNj71uCcOiUyW8TJG0kfylAfPw4QUc
	 /sy2sp88p66FtKyDwRjBfZTqq31kRqDcp8qLuD+gU6yjaHG2krjPZ/ZC1bEC8zTyLR
	 CYhOSiUKL/RZQ==
Date: Wed, 16 Sep 2026 19:05:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, bigeasy@linutronix.de, dwmw2@infradead.org, 
	dwmw@amazon.co.uk, kvm@vger.kernel.org, liam.howlett@oracle.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	lkp@intel.com, llvm@lists.linux.dev, lorenzo.stoakes@oracle.com, 
	me@brighamcampbell.com, mhocko@suse.com, nogikh@google.com, 
	oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, rientjes@google.com, rppt@kernel.org, 
	seanjc@google.com, shaikhkamal2012@gmail.com, shakeel.butt@linux.dev, 
	skhan@linuxfoundation.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Subject: Re: [syzbot] [kvm?] BUG: sleeping function called from invalid
 context in kvm_mmu_notifier_invalidate_range_start
Message-ID: <aqrZMReaQPG0M9oV@gremlin>
References: <6936812a.a70a0220.38f243.0090.GAE@google.com>
 <6aaaa2da.86093f18.33004f.0001.GAE@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="eq753chkiu5rde7c"
Content-Disposition: inline
In-Reply-To: <6aaaa2da.86093f18.33004f.0001.GAE@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 90E9B180013
X-Rspam-User: 
X-Stat-Signature: gukgt84wez1puype7c5dx4yti4ogyz7y
X-HE-Tag: 1789581913-557764
X-HE-Meta: U2FsdGVkX19xPEruq90BxlWK6ezpfafcxYGFlZJy2rHfuYrpZO0vMF69b+Ri+BLO/8Q6UputUKzgkN1Ylbew120MxHQH8SO1gKybecoJLwy9KMO/Z7e4dZUVp5PTcot7OgK8KEYqH2AqfPHdMwuc+Ydn3aWEvSGCl/o2w29712jNa7UD+bfWZyuAfBJ4js4ZHqBRFwWIdA2arRr/KOMEC56g+XTGkmOiNO8ZRwUK8k4JzwZxHAIglmR/xmajT1FwqyY8i+2kOyd+gdIeSOMl4BM3CT3dGuYvj6QetA0Uhkfx87HP6OW25kZ2y+4eczfN2ep73/TFd8i2Eoa+KxR3EyLZuScRYfKLqUWlqQFt8Ohpjhb4bTcXOiSd79YVUfpd9VoEuYEQW2EaXyyXZeCdY497Eg4HBskZOtp5bROSgvVDCaRGHNydvNeSo2trEkw0PlwfapQK//LWQdHu8ZabjV28Qs7vVdKeYFAQVt2fG9lGuKeseJ2a2H+AmoJCs8rclKisi/2qOl7htKyv+la/ziHp6Yh7GxcV/E8OyFQThBZB5f2/wUU/J21NTRIt/dJ+My4lRq1YC43OOtZ5oQpejNnbLs5h74sDhDG1dqbsqrV+Iq4wNm2DH/b6ZcC/mh8XEodSMtvbLRM/p76towaAZ+8IZTB7GQwaCd1fuFjDjwoOH9ataHEHvnoR2gfSNs4BL6+GPR/KTyqCgnv1k3WRo5LzMejUf2XFDyuvlRSqQ4nbl1H9SUPxyG/V4MVBVRvwgRwf0o2FprfOtrN0XGX3I9un65o+aUq/QwmJIpdqC6ySnRyBR7zSBfTc2+tudBrA+6vsHjBjHlrE8zBUj35HpXMf3TwNFjvO+NF1lhbvascMHL4BIRt2pFHXnaedauOjA9FmLCAfw4ULMZKPcj0xz01+/Uk0APMVth6z+ztqyN5uQckcgoRLi4bxm/HOAXCVhud+PxEeLbYNlIYGX24
 3Eq9eena
 ZXXkvDY/xtHAyM0U6cEomKCxqoE7sWYnBx1YTVm4tGWYO7TFIXroSINHEKeBPkeZUsPW50ixRJhSMzvSXOrYl0WH9HHF4CEPd5UhjNIQGJgqcq3tKwkdgqJ0VnWatYMUJmYHwuULkqP/BAFC7YAjnLZs75YWX3pKRWGoZejsUEsSptT4TqyYIcq+AA3LZd5kzSo/RM0nHovlmCt5stk4EgWl2WBkAU8G3XCOE1hitCz8wyQCNNcrhBM2JXTS+7ejb1ARBE9VR2RIe7IPThnQpNTwJ9BXuDuqbE00DK8YZbgf4LK19hg1BPqDwr1ZAzcYbpd04jHF/0oDFrQpyd0niPJQQFWjS5qubzSZ/cIRhZOn+bBfLYGGRX7f31noDGpGtPb/dMge1uy7Pt37ipcWvITeibk1dJPUOx2anj9iTuCzpIvZvoUI/JI4fJJ+jd2XjwJvfPhM/tLOWqdXWNUpYF/0C+nFi8IiqigLPx5u5zm4lBP5SZEV0cua0eLiAIhYpuwahhImSBWVkkG9m8tavmo+qYlDNEiYYiFZ7LDeRuSJPhBUEhgFiM3bYVWkL5BL0egDNRsU5nvN+KOOlOLDwxW+KTz3xaD3GUy5QU5w+ZQPb69zxgRArgs78XgyOUbrIyt+DZPEADE46oyBxsYgf+HTA56MoiwpIydPsRavt4t5kAWv0DFk9/CWZAOWSHU2zov2V2UZo3n0h20/flAcrJQMlJrZQHIBh6IwMoNHfw7tk/8eiITJ2p7Jd2HTAUgd2xb0YmJvI5PSIjQThd4VSaUIOuCVSDQSY37er+7N/zojj1CKkpo7YgpPmz+X+gzUVb4INIDR268sfBYNNQ7jEegZbtDAphXPiuRTrOsJtvBDckxRHd7y68bXYTc4wfym9pYcNgUrkBEe/sFFY6vZ/t1rUMjglU8rwl8MCX1W6NJscgHVi07ces96F+DUjmmKcEqAhNzixkxjsN9dpRRs0cSh0s0ve
 tPOreKyL
 wZfoHIl6zRKkSZaNivVJIiei5ttkTl5Lt6WegUpBGM6ZHSc1hf/d+q9qwlBRU0JXrtt9tPtdu2MZnhFOb08MhZjyUGb6hDzLrkofKg42CL+kisRaIgh0RD9wkEAa6EaWm3d1p7+215MK6S0kRcjzdPDFPLBLHDu57xc7JXdZT0cAzgDmtNctokg5XlDqmjrOdEdYZ5uXg3VT6/DXJ+jFpMtE2I51xmAqmK3aF+xtb3rU/kah5X1qE42VEVgeI5PvToG1WBw2W3n5Y9B1VakGfZ8ksOnUB9GBuu6RRhsV58bsxkTcFUnKa3nK2+hbuy/fSyoR/tH8Xyu79RfDwMDMHsHet8fvUz+Fe3tbNaoi+n3gf0GKSM2kJiYXGnUi8EUiyEbhQ8kksHkdHST8tnqhV/Ik0fNAofirfnsnePry5noOm44iIm0XZFHsYV2qAwEhyEIqW/L0VezsaDAktAarqX+cAYoGGKrynuGG4AGQrRbS9cXlzJ8P3HbU6r9sR3le7aWGi/AH75RPBhEFZax43WkXdYexgps8YCAzlHJ8zyLPMXB/4rSRIvF5sWxFqA8gNXRov9JS0XeHEumnZaJePQRjjHg9eqT/HqK727HL1L0NJ8o9QwzS1p2exYjl91T2u5ra2LlJ4YM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--eq753chkiu5rde7c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+cc Sebastian

On Wed, Sep 16, 2026 at 07:08:26AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    9b87fdc9af2f Merge tag 'sched_ext-for-7.3-rc3-fixes' of gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16f46bf9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
> dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f23925580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f23925580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d9d20c79bd3c/disk-9b87fdc9.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2a6a8f176798/vmlinux-9b87fdc9.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/db8864d1c812/bzImage-9b87fdc9.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
>
> BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
> in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 38, name: oom_reaper
> preempt_count: 0, expected: 0
> RCU nest depth: 0, expected: 0
> locks held by oom_reaper/38: 4, last CPU#1:
>  #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:619 [inline]
>  #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task_mm mm/oom_kill.c:566 [inline]
>  #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task mm/oom_kill.c:609 [inline]
>  #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reaper+0x2b4/0xc10 mm/oom_kill.c:650
>  #1: ffffffff8e30af80 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:495 [inline]
>  #1: ffffffff8e30af80 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: zap_vma_for_reaping+0x193/0x380 mm/memory.c:2266
>  #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:198 [inline]
>  #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:305 [inline]
>  #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: mn_hlist_invalidate_range_start mm/mmu_notifier.c:515 [inline]
>  #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: __mmu_notifier_invalidate_range_start+0x5c6/0xb80 mm/mmu_notifier.c:580
>  #3: ffff8880465ad560 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
>  #3: ffff8880465ad560 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: kvm_mmu_notifier_invalidate_range_start+0x1b6/0xc10 virt/kvm/kvm_main.c:745
> CPU: 1 UID: 0 PID: 38 Comm: oom_reaper Not tainted syzkaller #0 PREEMPT_{RT,(full)}
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x31b/0x470 kernel/sched/core.c:9257
>  __rt_spin_lock kernel/locking/spinlock_rt.c:48 [inline]

Seems like a false positive and an RT thing?

Seems like [0] addresses it?

[0]:https://lore.kernel.org/all/20260916155105.qDi2MiYW@linutronix.de/

>  rt_spin_lock+0xc2/0x400 kernel/locking/spinlock_rt.c:57
>  spin_lock include/linux/spinlock_rt.h:45 [inline]
>  kvm_mmu_notifier_invalidate_range_start+0x1b6/0xc10 virt/kvm/kvm_main.c:745
>  mn_hlist_invalidate_range_start mm/mmu_notifier.c:525 [inline]
>  __mmu_notifier_invalidate_range_start+0x709/0xb80 mm/mmu_notifier.c:580
>  mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:498 [inline]
>  zap_vma_for_reaping+0x1f7/0x380 mm/memory.c:2266
>  __oom_reap_task_mm mm/oom_kill.c:548 [inline]
>  oom_reap_task_mm mm/oom_kill.c:585 [inline]
>  oom_reap_task mm/oom_kill.c:609 [inline]
>  oom_reaper+0x519/0xc10 mm/oom_kill.c:650
>  kthread+0x38b/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> oom_reaper: reaped process 8617 (syz.2.1028), now anon-rss:0kB, file-rss:72kB, shmem-rss:0kB
>
>
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

OK I attach the patch, so:

#syz test

--
Cheers, Lorenzo

--eq753chkiu5rde7c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt_fix.msg"

From mboxrd@z Thu Jan  1 00:00:00 1970
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB2344A41A
	for <linux-rt-devel@lists.linux.dev>; Wed, 16 Sep 2026 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789573873; cv=none; b=dJPmBKlAMPVABCbPBWpBKZodIllr2d2QNabhtLlFDz9lyXv/N12uXWbjtq3jJIYMlBIAN5Z7cs0uUJ8LGHmMdIjaltl56jWI5NqOhDn+VcWYZloQ31yoTF36RedNsUiuy97JDp/7igkqMGqsKTllVFayZREXuia2WGMOSAWx0HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789573873; c=relaxed/simple;
	bh=bMIC0/VgzxgcdJMTvr5DMj9RkHg2F9CQ0MIQ8poAnTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UYjMfx04slUnRGBKyXryU+P462Rs3cPXRb5QqoKPyu9kUrATC+2IWh1IFPZBC2Rv6u+YG2bvaQMRhRtBfnpJWlhkkDEC8nDK8iln61SLtRkeHej9NtLMwG1Uv2P7g+yswVJntt7HCdVbi+lKUu5Kjf5fLRK+/umqAF16x+vNkLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=eXmX5pZ3; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GoMKDz3z; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eXmX5pZ3";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GoMKDz3z"
Date: Wed, 16 Sep 2026 17:51:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789573867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mV6UhFNULl/p2epmPanGCrS/5V06dPEqYq9UbXTjiR4=;
	b=eXmX5pZ3fxsJjqAcv+mJwxaldl1ueJr7KBhn0U7kSJ6wguIT6E/SZijiQ+5NT1cas9lmgD
	Oy7bRbCq+/fn6eNMD4xxQLgjCnGdYPNeTz529w1VMabqxjRnWfZRJCTX4rVbYY4YNwQhsG
	hfmHeyfr3xeaD5onr47Z3NsKkP/aw5P28PIcHWfSfzxU8k0pNNSe81jgDhE9EM1oV3plS7
	6d51tQzxjBxvEusoe7BudTXoaPEHzcR62IkhzGHpo9NQMeqecIzVm1xX7gSIEyTO5c2sn7
	mpWeKzCFD+p9SeL9rs/3Y8kNDQRmvkERlUlHs8YASOuMPp2N0MVoQLt1Yv5dZw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789573867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mV6UhFNULl/p2epmPanGCrS/5V06dPEqYq9UbXTjiR4=;
	b=GoMKDz3ze5L2J0XPU9UZ5pR8NoOfiSQXkcKaL0iX8wO8yl7OZtfRfyMhfvuJlIRQhW/aqm
	VSEwk4tF1BOyn9Ag==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: Ben Segall <bsegall@google.com>, Boqun Feng <boqun@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>, Sean Young <sean@mess.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v2] sched: Allow sleeping spinlocks on PREEMPT_RT within
 non_block_start()/end block.
Message-ID: <20260916155105.qDi2MiYW@linutronix.de>
References: <20260821095755.am1-Segb@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-rt-devel@lists.linux.dev
List-Id: <linux-rt-devel.lists.linux.dev>
List-Subscribe: <mailto:linux-rt-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:linux-rt-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260821095755.am1-Segb@linutronix.de>

Commit 312364f3534cc ("kernel.h: Add non_block_start/end()") added
non_block_star()/end(). The intention was to catch any callbacks which
depend on locks or sleep able conditionals in order to ensure forward
progress. According to the commit message spinlocks were excluded
"because spinlocks can't have an indirect dependency upon the page
allocator=E2=80=A6".
On PREEMPT_RT this leads to a splat because spinlock_t and rwlock_t are
turned into a sleeping spinlock which have a might_sleep() as they could
schedule() on lock contention.

Besids mm, the other used of non_block_start() is pwm. Here the hrtimer
can acnqure a spinlock_t on RT and I can't tell other user but I assume
it is not atomic on RT since it wouldn't be able to acquire its own
(spinlock_t) lock.

Since spinlock_t (and rwlock_t) are not problem, add a sleeping_lock
argument to __might_resched() signaling if this is scheduling request
is from a sleeping lock (true) or regular scheduling request (false).
Add the `true' argument to rtlock_might_resched() which is used on
PREEMPT_RT for both sleeping lock types.

Cc: Michal Hocko <mhocko@suse.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Young <sean@mess.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Fixes: 312364f3534c ("kernel.h: Add non_block_start/end()")
Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3Dc3178b6b512446632bac
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

v1=E2=80=A6v2: https://lore.kernel.org/all/20260821095755.am1-Segb@linutron=
ix.de/
 - repost with collected tags
 - Add Reported-by for syzbot

 include/linux/kernel.h       |  5 +++--
 include/linux/sched.h        | 24 ++++++++++++------------
 kernel/locking/spinlock_rt.c |  2 +-
 kernel/sched/core.c          |  7 ++++---
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 24414c79e59ab..c3937e081f18f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -70,7 +70,8 @@ extern int dynamic_might_resched(void);
 #endif /* CONFIG_PREEMPT_* */
=20
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-extern void __might_resched(const char *file, int line, unsigned int offse=
ts);
+extern void __might_resched(const char *file, int line, unsigned int offse=
ts,
+			    bool rt_sleeping_lock);
 extern void __might_sleep(const char *file, int line);
 extern void __cant_sleep(const char *file, int line);
 extern void __cant_migrate(const char *file, int line);
@@ -128,7 +129,7 @@ extern void __cant_migrate(const char *file, int line);
 # define non_block_end() WARN_ON(current->non_block_count-- =3D=3D 0)
 #else
   static inline void __might_resched(const char *file, int line,
-				     unsigned int offsets) { }
+				     unsigned int offsets, bool rt_sleeping_lock) { }
 static inline void __might_sleep(const char *file, int line) { }
 # define might_sleep() do { might_resched(); } while (0)
 # define cant_sleep() do { } while (0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 705970d07614f..bb4cbca8f7d69 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2173,9 +2173,9 @@ static inline int _cond_resched(void)
=20
 #endif /* !CONFIG_PREEMPTION || CONFIG_PREEMPT_DYNAMIC */
=20
-#define cond_resched() ({			\
-	__might_resched(__FILE__, __LINE__, 0);	\
-	_cond_resched();			\
+#define cond_resched() ({				\
+	__might_resched(__FILE__, __LINE__, 0, false);	\
+	_cond_resched();				\
 })
=20
 extern int __cond_resched_lock(spinlock_t *lock) __must_hold(lock);
@@ -2201,19 +2201,19 @@ extern int __cond_resched_rwlock_write(rwlock_t *lo=
ck) __must_hold(lock);
 	(PREEMPT_LOCK_OFFSET + (1U << MIGHT_RESCHED_RCU_SHIFT))
 #endif
=20
-#define cond_resched_lock(lock) ({						\
-	__might_resched(__FILE__, __LINE__, PREEMPT_LOCK_RESCHED_OFFSETS);	\
-	__cond_resched_lock(lock);						\
+#define cond_resched_lock(lock) ({							\
+	__might_resched(__FILE__, __LINE__, PREEMPT_LOCK_RESCHED_OFFSETS, false);=
	\
+	__cond_resched_lock(lock);							\
 })
=20
-#define cond_resched_rwlock_read(lock) ({					\
-	__might_resched(__FILE__, __LINE__, PREEMPT_LOCK_RESCHED_OFFSETS);	\
-	__cond_resched_rwlock_read(lock);					\
+#define cond_resched_rwlock_read(lock) ({						\
+	__might_resched(__FILE__, __LINE__, PREEMPT_LOCK_RESCHED_OFFSETS, false);=
	\
+	__cond_resched_rwlock_read(lock);						\
 })
=20
-#define cond_resched_rwlock_write(lock) ({					\
-	__might_resched(__FILE__, __LINE__, PREEMPT_LOCK_RESCHED_OFFSETS);	\
-	__cond_resched_rwlock_write(lock);					\
+#define cond_resched_rwlock_write(lock) ({						\
+	__might_resched(__FILE__, __LINE__, PREEMPT_LOCK_RESCHED_OFFSETS, false);=
	\
+	__cond_resched_rwlock_write(lock);						\
 })
=20
 #ifndef CONFIG_PREEMPT_RT
diff --git a/kernel/locking/spinlock_rt.c b/kernel/locking/spinlock_rt.c
index 1d5e1b3c60bfa..0a89e7f10af18 100644
--- a/kernel/locking/spinlock_rt.c
+++ b/kernel/locking/spinlock_rt.c
@@ -33,7 +33,7 @@
 	(rcu_preempt_depth() << MIGHT_RESCHED_RCU_SHIFT)
=20
 #define rtlock_might_resched()						\
-	__might_resched(__FILE__, __LINE__, RTLOCK_RESCHED_OFFSETS)
+	__might_resched(__FILE__, __LINE__, RTLOCK_RESCHED_OFFSETS, true)
=20
 static __always_inline void rtlock_lock(struct rt_mutex_base *rtm)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7885ff76e69f2..ff2bdc5a86679 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9183,7 +9183,7 @@ void __might_sleep(const char *file, int line)
 			(void *)current->task_state_change,
 			(void *)current->task_state_change);
=20
-	__might_resched(file, line, 0);
+	__might_resched(file, line, 0, false);
 }
 EXPORT_SYMBOL(__might_sleep);
=20
@@ -9208,7 +9208,8 @@ static inline bool resched_offsets_ok(unsigned int of=
fsets)
 	return nested =3D=3D offsets;
 }
=20
-void __might_resched(const char *file, int line, unsigned int offsets)
+void __might_resched(const char *file, int line, unsigned int offsets,
+		     bool rt_sleeping_lock)
 {
 	/* Ratelimiting timestamp: */
 	static unsigned long prev_jiffy;
@@ -9219,7 +9220,7 @@ void __might_resched(const char *file, int line, unsi=
gned int offsets)
 	rcu_sleep_check();
=20
 	if ((resched_offsets_ok(offsets) && !irqs_disabled() &&
-	     !is_idle_task(current) && !current->non_block_count) ||
+	     !is_idle_task(current) && (rt_sleeping_lock || !current->non_block_c=
ount)) ||
 	    system_state =3D=3D SYSTEM_BOOTING || system_state > SYSTEM_RUNNING ||
 	    oops_in_progress)
 		return;
--=20
2.55.0



--eq753chkiu5rde7c--

