Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B32CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042126B0005; Wed, 27 May 2026 08:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34F06B0092; Wed, 27 May 2026 08:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23FE6B0096; Wed, 27 May 2026 08:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD6FC6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:05:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 912E51A05DD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:05:12 +0000 (UTC)
X-FDA: 84813069264.21.81AF618
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D337240012
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:05:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iV776Edg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb+nQUG5DZIwXW194zA/OGtxfBqg13OGT67u0JOBSdo=;
	b=r998wLotM0H6jLnyxxPN+DIKpjgTaPdKKhmiJCXYWAR7ijYDYway2NICzQp5DFt9DxCaAZ
	3jK14AtIFRZtOV9wY5P2XwkBtxsPk/ImOvpyBJumtS5CWfjUmsblnFtbQLtZwUsgc0khcY
	UzAYYrKnMR8BhDo+QugJuFYWZzwWEOk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iV776Edg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883511; a=rsa-sha256;
	cv=none;
	b=cdGgaj2g1EbqQQOwOEhBv4VS70L4sm2z7ba5KOQra9IlPHKUwkGjF3HUpZaW1pEsjztNjY
	7QxvMuM4aZxtQpeWy2eTGHPtSBA3aF+RYr6VPMEQu0YR0rVcGdgrbl0rP6rDaRy48wQ6Rh
	A3LhR0wbr4pqn1OQIaK9oawP61X9CXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB943443F9;
	Wed, 27 May 2026 12:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EDA1F00A3A;
	Wed, 27 May 2026 12:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779883509;
	bh=vb+nQUG5DZIwXW194zA/OGtxfBqg13OGT67u0JOBSdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iV776Edg8kbbFFPZFImy8PLyuTrEVAExqe/twlbP7u/sSmtJ3yVDDoHGAq7tBeHIt
	 4juj6R4QlA/kKD2lZGffm6rzicMp3nV7YbeVCKaF0UI2BKu69EzZR5yx33Baw7QYw6
	 yJEPO4w/ha3DQgeMnJ4+L0pQ/95r/Tuu77XzdOa+Hf83gV6QwSAiTDzecdFd5S6zD2
	 qGheJZsL6ikieRlQ43efmz641qVeEecyQUym61paQESzg1SNryVH4eoTvVwKFrsele
	 z749nZui7B5aqSQKpK5+ABaMdY3iTsG1oUT9iFMQgbP2Diw9qdJiGxCCP9lL3pjSJU
	 UPo55TRN57gHw==
Date: Wed, 27 May 2026 13:05:03 +0100
From: Will Deacon <will@kernel.org>
To: syzbot <syzbot+a169a27b0538ba43e5d3@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, npiggin@gmail.com, peterz@infradead.org,
	syzkaller-bugs@googlegroups.com, david@kernel.org,
	qi.zheng@linux.dev
Subject: Re: [syzbot] [mm?] [arch?] BUG: sleeping function called from
 invalid context in __tlb_batch_free_encoded_pages
Message-ID: <ahbd7_KaUn45GK3v@willie-the-truck>
References: <69f302ff.170a0220.3c4978.0016.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f302ff.170a0220.3c4978.0016.GAE@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D337240012
X-Stat-Signature: nqde11tgzxpjku1oy1pf91us7j3pi8ni
X-Rspam-User: 
X-HE-Tag: 1779883510-430433
X-HE-Meta: U2FsdGVkX189ky8fq1bouUCK9IMli6ixfHpGxOEQWKe5A7XOZLNYcqE7UpOglFyBXHE78zXtNzWWseshfn9ns3c2f3o4QzceOcUnPAmORZXXuOFHouXsPcYOKqNw51udMpAI7Yh21lD51UZh5jICqWhj1qYO9pibW8ZgD/LQFAbxw7NCavh5ufCa43B+guIqskzdsrjkIXos3KnhTAexgOFpXldFXPkWXMfVURWbkoPabtQS/bTdc9nGU7dwDkVllx950Q7Aayb3QgeqYZICYNwCNFCbQmv5H3nuIl35SzqNjKNNGygOmp/9Vx9Zdd5T68G2e6B4oJdmQs1Yp/I7TPJuGKjR7tGh1C3OQKpJ4sEKFmAtREm0AntGEWVgk4tfinUOIh7YCqF5S0c394+4z6wisSHzw2tU8ZrPv2bcl8R+YqRqT0zWGNgmjLsBkxAO+pKkG77BjLmteHu6kP6tkL5OAvT198daHOCI9WEijKqMOqGES559KLC48EIoOvzhq7WezKhO5KgV+Xyef+uuWt5BhOZ8Cu7Y8su9YDd7ouKfFvTMhayLH2i+8amijF7wltN6Mh1ZQhLAsSTbrG6oFqc8eEzmGoIj5OrUUiZPQZYYiTVsLnZ1u/gEKclFyBjrbClnVTMCdudtmB+550Yx4k0FPPbp5YlfxvotSodLDuOx0YmBy0L/pt7tsyNnZsMvJ3t9y8NGgq72obLqE6bJze+5xjL5B6otYXVSzr++zT9NFf2HTpfkRP2hwaZdGjO2ubor1Ha5DOc+1h0pUzPGHks+rjePDKt3d6WDwxdD3E6A8VZzzIJjaQAFmJ+6Szu0ZCz8pFPjFAaHpMv9qVnBaFiMkYnI2wJ+/mlIdKrZiwT20c2UuxK62kVHux4RHctCwgmKbfjvSx20zwAzxLQhUvIm4NMX4K1GemsMm1fxnYGrqnO+9AnnNEtktrq4rXvpDrnqkoTXWYqco2c+ed9
 Iyg0FeEh
 Xl1eB7PDVgK0mQoqKGMrQncD1vo+l1YgyiBMucjW+mE1kc9qomb7ennlPVbY6PpQ1r0dbSzcw5orhAmYE3At2YweKW1RPyypNHVGPYcxHvHMWLOlq8wh7Vx1VKV1ixLPM5J543NA0n+ePnn/GW0W3UQNn6KQx0qocLXsxi7tbDfsfFyKPfyKm56h/kevNMarBO7QUZixdic+s0+UHpF+GOiIXqQCWnVI1Y7FQ5FAAvyuzCZSP4E25ENsBxHj2Kt6fr52AvW+9jLKZ73e4+WWHhAdSly6TrjFW4nlRdopVCj3OxNO+yqNDOyesOJW8MSrZ3UCh95XOoPIhHOnBoCinOaMramigz8MT5+/YUNR18K7C7La8rCfZ0HO6KTwUcPPUoo+tgzC1HkjrLAEt2io9nNKu1VyWM1iyfSrX7WHGtR9VfzoVNFgGgVw2XNxsUDEjQ9PrUgPSY6CeW/ZC6dL8SeG6v1L8vZpD0KtEAILVC/IO0lxqfnsSsHn2ZsVl/YYP+0+xXxgLNo1uPa6U1fYUXxljlR1FFTO8rpBJxk61nyFDta2P/AcfN9N7MJ19VVEK5veecH8vmCY4O/CQ55wPMeZ3HnXS34+AEGbc5rf6r1y8iRUirP6yJ/3NmQOIOwtHPNdTQ9yVkC+thlHzpzEnNpzkV3gpHwXVK/3c4UwR8/EZH5Bpunm6OZStt234/KjNQVcOg9BxDZ6OG0lWz42+lhsCUMxJKkPfmQEpx2R5iYrZSMGyXoamWTco+VwSF2fIXYb8fipCyzScuSm/CnaCCjWuSlVcE4bZONFJg79nv4DVbVup5gIBPTOjXVk7Yfl2rQneZl2UCMq1AYmPmmM8bNHL8r0i9kVC4hAEwkfG3SXeY+8XVuhbu7ItDQT9yn2vYGjs0mnKUzCZfIcUZ70xjhllw01+soIu1xVFT0vzf6EFqmr1XAB8Z5pcoBHg14wItvXdNZx226agUKTottedRb7Bz4lZ
 sjeXjR9d
 6frcrIejYH4p3j0GE6pDv4ocRu3xcwIaSeWgzIQ2DnW5ZRZ4T3dgcil7hikBD+D015KgrfSRrC1ae6adLX/RdogscfcV+V6+wRCro4h/DFacOtzDX0jzfhCQhMyJvJFr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I finally got a chance to look at this one...

On Thu, Apr 30, 2026 at 12:21:35AM -0700, syzbot wrote:
> syzbot found the following issue on:
> 
> HEAD commit:    dca922e019dd Merge tag 'xsa48x-7.1-tag' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11cd6b6c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=59da38148f3a3d24
> dashboard link: https://syzkaller.appspot.com/bug?extid=a169a27b0538ba43e5d3
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dca922e0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7b447b1b93a9/vmlinux-dca922e0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/af7830f5dabf/bzImage-dca922e0.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a169a27b0538ba43e5d3@syzkaller.appspotmail.com
> 
> BUG: sleeping function called from invalid context at mm/mmu_gather.c:142
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5677, name: rm
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 2 locks held by rm/5677:
>  #0: ffff888022c20338 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:536 [inline]
>  #0: ffff888022c20338 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x22c/0xa10 mm/mmap.c:1308
>  #1: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30 include/linux/rcupdate.h:300
> CPU: 1 UID: 0 PID: 5677 Comm: rm Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
>  __tlb_batch_free_encoded_pages+0x11e/0x280 mm/mmu_gather.c:142
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]

... so we're getting deep in the gather code tearing down an mm, where
we free the unmapped pages but we're somehow inside an RCU read-side
critical section.

The last report on the sysbot dashboard is from 30th April, which
coincides with 99ebc509eef5 ("mm: memcontrol: fix rcu unbalance in
get_non_dying_memcg_end()") landing upstream. Unfortunately, there's no
reproducer available to test that concretely but it looks like we can
end up in there via the page freeing path. So hopefully this is fixed.

As an aside, it's a bit of a pity that the rcu_read_lock() callsite is
identified only as the useless rcu_lock_acquire.constprop.0() function
in this backtrace.

Will

>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu mm/mmu_gather.c:424 [inline]
>  tlb_finish_mmu+0x1b0/0x810 mm/mmu_gather.c:549
>  exit_mmap+0x454/0xa10 mm/mmap.c:1313
>  __mmput+0x12a/0x410 kernel/fork.c:1178
>  mmput+0x67/0x80 kernel/fork.c:1201
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x833/0x2a60 kernel/exit.c:963
>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
>  __do_sys_exit_group kernel/exit.c:1128 [inline]
>  __se_sys_exit_group kernel/exit.c:1126 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
>  x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9fc102d6c5
> Code: Unable to access opcode bytes at 0x7f9fc102d69b.
> RSP: 002b:00007ffd51104bf8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007f9fc112efe8 RCX: 00007f9fc102d6c5
> RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
> RBP: 0000000000000001 R08: 00007ffd51104b88 R09: 0000000000000000
> R10: 00007ffd51104a20 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007f9fc112d680 R15: 00007f9fc112f000
>  </TASK>
> 
> ====================================
> WARNING: rm/5677 still has locks held!
> syzkaller #0 Tainted: G        W          
> ------------------------------------
> 1 lock held by rm/5677:
>  #0: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30 include/linux/rcupdate.h:300
> 
> stack backtrace:
> CPU: 1 UID: 0 PID: 5677 Comm: rm Tainted: G        W           syzkaller #0 PREEMPT(full) 
> Tainted: [W]=WARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  print_held_locks_bug kernel/locking/lockdep.c:6752 [inline]
>  debug_check_no_locks_held+0x90/0xa0 kernel/locking/lockdep.c:6760
>  do_exit+0x13ea/0x2a60 kernel/exit.c:997
>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
>  __do_sys_exit_group kernel/exit.c:1128 [inline]
>  __se_sys_exit_group kernel/exit.c:1126 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
>  x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9fc102d6c5
> Code: Unable to access opcode bytes at 0x7f9fc102d69b.
> RSP: 002b:00007ffd51104bf8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007f9fc112efe8 RCX: 00007f9fc102d6c5
> RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
> RBP: 0000000000000001 R08: 00007ffd51104b88 R09: 0000000000000000
> R10: 00007ffd51104a20 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007f9fc112d680 R15: 00007f9fc112f000
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

