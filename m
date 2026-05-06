Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30072CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A5E6B0005; Wed,  6 May 2026 09:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612036B0088; Wed,  6 May 2026 09:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F526B0092; Wed,  6 May 2026 09:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 471536B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:57:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AB871C017D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:57:45 +0000 (UTC)
X-FDA: 84737148090.23.8C831C0
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3ACCF1C0011
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:57:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VPmMD5bK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 31Uj7aQYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=31Uj7aQYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778075863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bte2ikXfMH1X30UWHnUNHKf52jg/NvhErm9OVWL82Ks=;
	b=SY3NqLxCDvTCg/a93y8lqJbmDuqEwqThrkqDHJqo/Px4UGL5NV7VqwWOJdoMyeXBvir1VN
	RfYgeRdG7AGS4bWgKnoshwmcFJwjH5vykhWBm8ytv+EExzS0Hd9ahYxLPvZFNOAssce17e
	6PVBqqA8+q70jnUqp/x+lyHqgYnyIwI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778075863; a=rsa-sha256;
	cv=none;
	b=OizldVzhV+dst9EORlaxYGVECKjtHHmpnaUgN5QSJvtgBPOq5T82TfeauVelTekB5zK/oH
	AAxbBzJGEfHsVzQZ+ZTw7fGJIED0uPTglhEE5555B8jW4KcqtxxBjo7ndgf/azX/aTJA9a
	HgwahKYhh+RxQv0JonzVjNaHMiUaxtQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VPmMD5bK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 31Uj7aQYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=31Uj7aQYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3651991d0bcso7801918a91.0
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778075862; x=1778680662; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bte2ikXfMH1X30UWHnUNHKf52jg/NvhErm9OVWL82Ks=;
        b=VPmMD5bKrc77je+FgoIIsHMnDCcMZ+WIVM1SiRfLTfdBmSakr3rROSZw9GYMiPf8fG
         fYY8HhvZRebOLurgQ3OMBHKHbQ6JIEdlImyJI6nPHdknd/B+PFdBZoAzqnc1jIMDYTSX
         2g/FbvHfTeNL+BA88wBVMiS5WTW5bYKu1HULeDzajJurGZCw/VMmoPEsTzHr8vA5kzRT
         bC0Zmt9N5Jo1EGugcrD1iphIz58pyJqmxKZyL+Z5Asd15dvJOF8WJG3EzCfTGJRmH6dZ
         MryMwdXlWL48I2P5/E7803cboHrtq6YEbp4y6Xmtx4gRNpgZInT0vsXSRhM8XQR33qH1
         LclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075862; x=1778680662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bte2ikXfMH1X30UWHnUNHKf52jg/NvhErm9OVWL82Ks=;
        b=R1ZYZX0MHIe/lezvjJkiCgXb6c2BzrQu3wgJcMkpNltli1yOEVY8Ccvl7zSzSqCBL/
         OjuVQII09eJqDi7m10mZFz5Zq17OfHZBzHDxOchwEFwQz9Ll1jIgJfZc6MlJncxMYK7k
         aLJ0//poJMM287xmNmDqjr18Znn6z3t+giV/m02Ej+qGm2Bw33lPmIa3VsnqrMUnu3G3
         fq0w8RM5J3z4T517AfnnOVlUP9uelgDPVyNhh3x018EOGy2XDeIQBydbsxPbR9AMYOwK
         LI/4Qe8jdBiaxLaeWg0x6A+G8geGfHD10A78Aro/PdJlWeBMtm5vMHgPYpOjfFZ4sGxq
         7tNg==
X-Forwarded-Encrypted: i=1; AFNElJ84IQTicvCjCIRIJN6IWF+Vq5g/qBvaXHspB1S+WHRjF64wdIlYxWPVXA3vl0Pi4jkfX5lqnUvcxg==@kvack.org
X-Gm-Message-State: AOJu0YzKBh6nCOAj68uvS/FsQvF1K37Vut5c97Bfqabel0sc0QhIheOq
	7fOGTU3QJe+FNDEff1R7l/fh0lnKrAXEqU4jwXT8KTan5zeE3gMKU476v63l7AJPLMJq6UvklEz
	XqjTF4A==
X-Received: from pgbcr4.prod.google.com ([2002:a05:6a02:4104:b0:c80:2817:3a23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4314:b0:3a2:dbaa:82ec
 with SMTP id adf61e73a8af0-3aa5aae7ab0mr3951938637.32.1778075861517; Wed, 06
 May 2026 06:57:41 -0700 (PDT)
Date: Wed, 6 May 2026 06:57:40 -0700
In-Reply-To: <69f8dd59.170a0220.bb392.0004.GAE@google.com>
Mime-Version: 1.0
References: <6936812a.a70a0220.38f243.0090.GAE@google.com> <69f8dd59.170a0220.bb392.0004.GAE@google.com>
Message-ID: <aftI1Nt2PTptaUs2@google.com>
Subject: Re: [syzbot] [mm?] BUG: sleeping function called from invalid context
 in kvm_mmu_notifier_invalidate_range_start
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, dwmw@amazon.co.uk, kvm@vger.kernel.org, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, lkp@intel.com, llvm@lists.linux.dev, 
	lorenzo.stoakes@oracle.com, me@brighamcampbell.com, mhocko@suse.com, 
	oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, rientjes@google.com, 
	rppt@kernel.org, shaikhkamal2012@gmail.com, shakeel.butt@linux.dev, 
	skhan@linuxfoundation.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ACCF1C0011
X-Rspamd-Server: rspam04
X-Stat-Signature: s95q3ywp585pppt6kgwyuqdbyer795of
X-HE-Tag: 1778075863-373732
X-HE-Meta: U2FsdGVkX1/ycslO5A/7FWNMrx1gJZ93ljjgB2eGhkNy8FCkL0YDrqOeiMsjtljWovu1Xa/6556QO70RCuEWjNdDi7olYKYyFSp4m8O7VuFqyIWN3PfnBGzB5bSMQB4uDTbQFY4D7lMAAJvkH4cYpEqu/kaejaoxEkjNmnb4mTrsI+VvrhGrLIGbGT6CMcknnHfpIjsCWR/KzTA9rAE9bel8JXdoJ9TFwfW6+wIKRMHdfgs1/t32dcf3iR9IxvD4iCP/pJwp0vUufjNlqxF7/TxexvTU6/q98LTH9sct5XDIAicCDmlLRctYJxBRg7d9gAl0Wrf6d+NpZbeKD+HC27o+Vso+ELxtPvI457rXx72TYRRXomb8lzleXxCpzZQiM8DeSUPmomI0c0sjkaoQ0VAh/YAsEoNFIdFnP7+yFQFka/GdupDe7m9rpv3yQZDmVQiVyj716nkkk4ZpbJvdkuEjB2B6xXvtIlBqu0dJO62JWGoM2ZhcFd/gOERoIKuOBbP48PBiAXnoLW9l0E/HcBsnyCEsOSbi6tuWNYv4V5bNllWKIxFpdJcT+TRtk3QzHK3DMRznZrlYw513bD87Fz4sAI7v5tyfGJwkzRm2YSqJHsHMlczvBd6XmyXNPGPCEdbuhqdxXqmzMqcHzfEOl5ETVF0VJe/HKPu9mOf289AyppndEieG2E97LDMumBRP1ba6+fvr97psHLMJyWSibsqvWoVlStJWvGqsur+zAWeks1vNORdtTuwJWlsHHnDVw96vXRp9B68QQwRzpTBDc+fPgkIi7WwgCXFysw7qT1m2SWX3v8xvluFt31HBDvg+2JTf3CsYPTtSVGR6/tfj6rIsVlt59H3vtSDYIyU4YmzWvBsR2nn2GpqY/VVMwrOg6QoOSKYkkcvINKQk1qJ5mCNIoEWY4l2IqkbxM8LG4vjY8mG4UgDLJxBmTk+1ao8X9C0fsFWk0BKXOlLrxcV
 pIy61Rhy
 94+SOpkaRd0y8ftUnPzKLvs+1p4BJzu13VI6FxCo8T62OYdKOxYiJ2zUg2uEraR7Wxq5dJD+PUPAxplD5Uczfl6mwU7yp5VW4irAn/fgksNEkuk170TT+YCYYVwX/7n2e8z2HfFUD2Nn3s/KbR06ZOfCpLAdOeZLtOkyJV3gTKrV1Ucjufi3ZZRyGCiT7OHWXHK3fFpv+6smSRurjlyNYhOPlLXBkJgTHm61m86hlsyODVumx+tGsqSMFkeLnn2TBg3xgM/X7hmw+piy6rja1odY3J0e7+wWsOot9TToU/VtUkTM7kAywf4Pf6m0hfNoLP1khSv592jHiizDHCXqbQhQcdTQ+6dWZ8zzSLMblfIR5zwITWj7LCi5CBGwc5NOo4U0P8Tv5cS0pLu1dN8GRaRc84yidLuAQ4aUU/esMKs0hB6bYyapSQZLvfvg6zIZ09abOX0a5YzF4pz2cTjT+ymJxRdM/tIXtgd7GBx2E72RQllfJ7eqhaUfb2EfhGZ263w7EA3/oSbHlVXbqG05d+im9D5mX2jzqTXCpcWhX/RB2d2PAp+x9meNj1ICNA25i+GmYbht/4j2FQgyo+2r3OBUF+4NJ+a4iCkqsKmWLIItNBOTnxCs+WQsE74SOFpZEGzty53sr9wU/PIeMN8SJqAEpc0hsUDKbzF5S0LK2pcsgZUGGQHiR8HZvZOa9q5S6XwWpdSbTXKP1x/74yN7nV9Gc5fiSPuY6nAXv9yxtn+rbx7utc34l1T48Dn/bGJFkag8W8aZw9jlgUIDSAcKUUfWtWgMI76DnS4bVjOZm5CjcvwmQFW12xdjG3gbKDPwohppR/Qx6mka8+lOwZDwOIiAx3LksG5klvN9HkthY8JbxUMH7Scs65053eWa2SANH9DhXYoCKC15NKlt9BJ65l4clih+NPaHfGs4C8gbVyzOQi+Uruu/QYEeVios4PG0PAVLolZI89gKo8OpU1hg0358NSbMx
 p5+bnIsP
 qRF8BgvuJ53IuVNkSz9ZSbU2nW2HW3qi/4UGrfKNHBJLn/Fg6LlHw79OJsQLTq7hLtbYJGAM+emfhRMUMP6nnfzPci+HRJzWv7THHA4HYdCMbT1HT1yCO5uNo0WuJQV6plVOGzDxehREH0GKx1Jls8Eatze6sxEgh5gVozKTP0Pl9gL4Dk6r0zcp34a/atrZbp1e66T3+AVq2b011QOCFusAdZHj1AHW6LW/KZ+vUMy9xQNWEzKetLl7EmQ2XP7xddLC1Zkc/8Cpb3s5c01t1NT6nZ/iNqRO2SWXEo6xGHKmIX0Ykjrh9ythwyn4/xhSRv51Y2QiaT9iI5muN8ZfARMPkE/Zrhe10sSUHGoJpLCiYb+3A7r7Qs8HPM2yor5hCFnk7siLhlr3AfiiYrMGaQ9uj0k1eX+lUp+248zSRS4lMx7OncJQZP2sJF+x4ejI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    b9303e6bff70 Add linux-next specific files for 20260430
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13745dba580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5474e13c6d20d45c
> dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125dd748580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b3a0a2e50f73/disk-b9303e6b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d3d481b220d4/vmlinux-b9303e6b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d6e012913960/bzImage-b9303e6b.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
> 
> BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48

This is a known issue:

https://lore.kernel.org/all/20260429222502.25414-1-shaikhkamal2012@gmail.com

> in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 40, name: oom_reaper
> preempt_count: 0, expected: 0
> RCU nest depth: 0, expected: 0
> 4 locks held by oom_reaper/40:
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:611 [inline]
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task_mm mm/oom_kill.c:566 [inline]
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task mm/oom_kill.c:609 [inline]
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reaper+0x2bb/0xc10 mm/oom_kill.c:650
>  #1: ffffffff8e3066c0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:495 [inline]
>  #1: ffffffff8e3066c0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: zap_vma_for_reaping+0x193/0x380 mm/memory.c:2119
>  #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:187 [inline]
>  #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:294 [inline]
>  #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: mn_hlist_invalidate_range_start mm/mmu_notifier.c:515 [inline]
>  #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: __mmu_notifier_invalidate_range_start+0x5a1/0xb60 mm/mmu_notifier.c:580
>  #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
>  #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: kvm_mmu_notifier_invalidate_range_start+0x1b7/0xc00 virt/kvm/kvm_main.c:744
> CPU: 0 UID: 0 PID: 40 Comm: oom_reaper Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x329/0x480 kernel/sched/core.c:9163
>  __rt_spin_lock kernel/locking/spinlock_rt.c:48 [inline]
>  rt_spin_lock+0xc2/0x400 kernel/locking/spinlock_rt.c:57
>  spin_lock include/linux/spinlock_rt.h:45 [inline]
>  kvm_mmu_notifier_invalidate_range_start+0x1b7/0xc00 virt/kvm/kvm_main.c:744
>  mn_hlist_invalidate_range_start mm/mmu_notifier.c:525 [inline]
>  __mmu_notifier_invalidate_range_start+0x6e4/0xb60 mm/mmu_notifier.c:580
>  mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:498 [inline]
>  zap_vma_for_reaping+0x1f7/0x380 mm/memory.c:2119
>  __oom_reap_task_mm mm/oom_kill.c:548 [inline]
>  oom_reap_task_mm mm/oom_kill.c:585 [inline]
>  oom_reap_task mm/oom_kill.c:609 [inline]
>  oom_reaper+0x51e/0xc10 mm/oom_kill.c:650
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
> in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 40, name: oom_reaper
> preempt_count: 0, expected: 0
> RCU nest depth: 0, expected: 0
> 4 locks held by oom_reaper/40:
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:611 [inline]
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task_mm mm/oom_kill.c:566 [inline]
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task mm/oom_kill.c:609 [inline]
>  #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reaper+0x2bb/0xc10 mm/oom_kill.c:650
>  #1: ffffffff8e3066c0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: __mmu_notifier_invalidate_range_end+0x67/0x400 mm/mmu_notifier.c:611
>  #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: __mmu_notifier_invalidate_range_end+0x67/0x400 mm/mmu_notifier.c:611
>  #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
>  #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: kvm_mmu_notifier_invalidate_range_end+0x1d6/0x3d0 virt/kvm/kvm_main.c:814
> CPU: 0 UID: 0 PID: 40 Comm: oom_reaper Tainted: G        W           syzkaller #0 PREEMPT_{RT,(full)} 
> Tainted: [W]=WARN
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x329/0x480 kernel/sched/core.c:9163
>  __rt_spin_lock kernel/locking/spinlock_rt.c:48 [inline]
>  rt_spin_lock+0xc2/0x400 kernel/locking/spinlock_rt.c:57
>  spin_lock include/linux/spinlock_rt.h:45 [inline]
>  kvm_mmu_notifier_invalidate_range_end+0x1d6/0x3d0 virt/kvm/kvm_main.c:814
>  mn_hlist_invalidate_end mm/mmu_notifier.c:597 [inline]
>  __mmu_notifier_invalidate_range_end+0x23b/0x400 mm/mmu_notifier.c:616
>  mmu_notifier_invalidate_range_end include/linux/mmu_notifier.h:511 [inline]
>  zap_vma_for_reaping+0x2d9/0x380 mm/memory.c:2124
>  __oom_reap_task_mm mm/oom_kill.c:548 [inline]
>  oom_reap_task_mm mm/oom_kill.c:585 [inline]
>  oom_reap_task mm/oom_kill.c:609 [inline]
>  oom_reaper+0x51e/0xc10 mm/oom_kill.c:650
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> oom_reaper: reaped process 6034 (syz.0.24), now anon-rss:0kB, file-rss:64kB, shmem-rss:0kB
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

