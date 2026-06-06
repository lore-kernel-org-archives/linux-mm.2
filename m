Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94C1CD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 20:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C9D6B0088; Sat,  6 Jun 2026 16:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D446B008A; Sat,  6 Jun 2026 16:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733196B008C; Sat,  6 Jun 2026 16:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1546B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 16:06:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 006631C1954
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 20:06:57 +0000 (UTC)
X-FDA: 84850571274.10.A2EE79D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 25E0F180003
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 20:06:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X8lRIOAC;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780776416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qa5POJ66Fhb7XWJUEzlpeoKcCg4M+FUsDrfjmTiyXQw=;
	b=aIuZUpZyU1EDkH/ymkgne54zB8RK1jN8wz18PnmP44VEvkmMBK1K0DgeZ9AIXQw0QA9fcI
	rO11Jsqjfjk+qdgVD+TnZiRjXKZzZ+nUmcj8T9Jtc2NA9+EfOQY0gJCAwZA1jK1e1aELQM
	BeQgvAvkMVqkM8RdhngwV5mHI2Kapfs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X8lRIOAC;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780776416;
	b=Ijsuq1hiDYXYoeXHo+nD5nfnWvI1gw2oTzeKgVWygClFvuklINQtJWssud1Xo6fWT8YYYw
	c6qdLAQQOtudhYGAGktPPGlrd/K1VqFtzeKgq+WF+opFaTMMOaALtNIFtFhvyfOSr2cfkw
	LjXBBm1BxVMu4D6gBSdija6ERzomlEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 127FA43E6F;
	Sat,  6 Jun 2026 20:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AA11F00893;
	Sat,  6 Jun 2026 20:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780776415;
	bh=qa5POJ66Fhb7XWJUEzlpeoKcCg4M+FUsDrfjmTiyXQw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X8lRIOAC/5y0jTnBZVDufh+G9szVlK547lyO8h5LcLyFWPzMzbDr8NZnDPF9kiZbb
	 Mnwrg9q6MP1QZJSTC6nSLG7euSQUI3jQiHnMWR9Ldb7T77pgOWlTCR0hVQDHFTk7Dl
	 pWpRmwrCmyTiHzqyPfbScM4kKOMyXPuH5baWctQo=
Date: Sat, 6 Jun 2026 13:06:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+8b331cede7bfea7c674c@syzkaller.appspotmail.com>
Cc: jannh@google.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org, Marcel Holtmann
 <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org
Subject: Re: [syzbot] [mm?] upstream test error: WARNING in call_timer_fn
Message-Id: <20260606130654.e4374528274cea6ec83397ea@linux-foundation.org>
In-Reply-To: <6a246fb8.c25708ab.1b19ef.0009.GAE@google.com>
References: <6a246fb8.c25708ab.1b19ef.0009.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 25E0F180003
X-Stat-Signature: 8u6sw8ddourqyc4sjt9gdajj4w6z9h6u
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780776415-971038
X-HE-Meta: U2FsdGVkX18w+yc6v4iNjIhtHbBM0E4A2J5aok0VqgEUVDEl0ZKx/zNF7wODm45V/R2Lj8FekkynLgr4bSJ65/krn4fhU8JW62vqj62nrwWFnAFVPQRvz5XAsYuf0dy33iGFBLbR0+CMS6GiEJuuRupE6ekBLlWlDlnYsrastRN+joQepi7ZJVh/HJv3OxxT0117QEH0ywPQ/Y6mNXhSJsZhle3YRqKqCPYAOh8pYLETvQJenzNyumthJKtFxXL5QcPguURSFb6bC1JMioO3BY0yTJwU7/1WvFbj8f1344Q1bhmdBKV3FI71b+Bvih9gaaJV+mjEDPXFRbKtHIeXKdUHTPLmBX2Kb72nlRa40ZWQnsiBdtRnxK+KEdMn4A3zC0CTXOTMfS4q+cmxYi95LjR0F2Av0tWQYlclMrA1utBoC/yqIm9uf/DGyKXPI2yAaym6Lw9rpjWKoyumjDhCOr97aA5IBopF6XK9qdwDMyFgr85qx9Fw4gv+vDZOA3njipSKg/q6eNskBIZZ/3Sd4Jbkkp34qtwPgHVdHllej9WIaAn6/USdcEicAof3NmaH/AoboIOHQUd8oC12BXqyHd+1lJwl7ITJe1ahJ/OQ8UyJbGBxf5oMm7KjFco86sN+VkuWgPGYtl8TfsEOqba0hXPRD4a/j842NGi8y1FdjbuFgCTqRuCjqHE0putG5yiFJZnwjqQeFs2w4/QubIO7qEdGNwEcaeOqdCApqff2zkBW95Q4N64CfWpbZatHWhNkSfTpY3c1SotZS0jleuSQfEWLvpqChBKHAVA5PdrDf/t4kC2NMhJpozo8DV3h0qY7WV7AINrQq/g+qf0gErgfb3ip/Xd6VOU/lKBw9eib52ccMv+3zmBP1Nx19/uRhPvW9cljFiPu8rTT+w7R6m2yZo31+UXCT24+MLz2QedPzzIhT2F+kmvn2/7oFGf/O8S//PFQMIdhEf2pEr9PmWa
 D2x7AzF1
 gzkCN3PwUR8pNBPHkw6YqWWo/IL1diWzt8DS1pVHDRenfIgEgFdiu59IEYSJYilLTdr5ZwCJtsBKEhmuCBD8De+cUyDN6t+u6hpQXx3FUc5YQ1jiUU3x7An8kiJanpjyqwc05E5/4OhGyg+r3bXurOXpTxWM86kSL8FRUNc0Caq2VNWgLuu4HzGBzK8KCATwWmU6YkiVxWVJt5bDxBTKPQk8KxtAJbvwC6lIQbusbDgofFzXhLVvamQGDuSXJ8coLZhWrTbCWBcVcsaTC0IJaw2foSRm1IjqpePmYbaZ2KpfQQX0FZ3RUnsTyfNKcA6t0FDKSYQWQNTqRMZZdqgYyMZiXLZTCO1HiDu4U5KWAet2Rowoyd4XHzuimDa20hKJTp3OnoAjAfXTfu4TrR//dDkmMSgTZze2Ur1IMpaCsBOtQOrYq2dQdfYWhXUs0uFVVUJpJyb59tt4FQLoBwainWfaO54L0ndA+7xICxRBc9KM9kV8zN3q5EicmONmxN97iadX2hjMAB8joYCzEBGIvBvCz0bPnzLWhG5Cv1cCghH5KMuqp/IwSN76jveK61snq7+OQwW6lkv9B2+rQRjsoj5IW3r2AXGJDK03hMoal12Gjqi8Ohycjz26mRv14+kLv1Elw3kIvxwx+LbxLBmBP+dmiC+t2XwWoUH6TEwrdIzaOF3YpgFd1XxHlW/CMYzEoZYORbYZVJGV4m5eG839oE649W7sVX73oXceAjssxf9ukkolyeCvD5I/BevgcmFFaFDmJsoAVn513BQK6oVrxm0iVhDF/Af5Bognsm6Xehl0zEKbpdEZrVoO30qxY0KzkiHeVsfrPXKq+GafGEs5zkWw+rOuV+Z8VDsfYhMqx3+I20l0REawSeQVtbxCsQvRlOOAmub0wNYaRP7iGMAK/7tE+NfOVVCQOzSXNcuYfKORFp7dPT1VO1qbw4dBON5Q9hPEgMHGvxMcmlLEzQPN1l7bQAN4o
 wvpcTfaj
 SBWmb3noXfl/BPJl+gOlFc9O2tg5ELEspcjCvnJvRuZzK0EqtzJe2k2e9CCyoV8gmTG/ORazfqPVe8DwUrIOYi5gzwdx/tHGsKz2rqtD2rpd/W7Ct2yfrjFPdl3M0njksTzyt/A1qVErd9CmFWxTmjN32qLgRAYvF1b8TiSljMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 06 Jun 2026 12:06:32 -0700 syzbot <syzbot+8b331cede7bfea7c674c@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ba3e43a9e601 Merge tag 'soc-fixes-7.1-2' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12180f2e580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b4166e8ea5fbf7e3
> dashboard link: https://syzkaller.appspot.com/bug?extid=8b331cede7bfea7c674c
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Thanks.

> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-ba3e43a9.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/721f1d5136ec/vmlinux-ba3e43a9.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ff33eef1aaee/bzImage-ba3e43a9.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8b331cede7bfea7c674c@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> workqueue: cannot queue hci_cmd_timeout on wq hci0

Looks like a bluetooth thing.  Cc's added.

> WARNING: kernel/workqueue.c:2298 at __queue_work+0xd3f/0x1040 kernel/workqueue.c:2296, CPU#0: syz-executor/5425
> Modules linked in:
> CPU: 0 UID: 0 PID: 5425 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:__queue_work+0xd67/0x1040 kernel/workqueue.c:2296
> Code: a6 0e 49 8d 7d 18 48 89 f8 48 c1 e8 03 42 80 3c 20 00 74 05 e8 7a 7b a5 00 49 8b 75 18 49 81 c7 70 01 00 00 4c 89 f7 4c 89 fa <67> 48 0f b9 3a 4c 89 e8 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 ef
> RSP: 0000:ffffc90000007bd8 EFLAGS: 00010082
> RAX: 1ffff1100259b94e RBX: 0000000000000008 RCX: ffff8880336a2540
> RDX: ffff888041425170 RSI: ffffffff8a9c7e10 RDI: ffffffff90334eb0
> RBP: 0000000000000100 R08: ffffffff90304ff7 R09: 1ffffffff20609fe
> R10: dffffc0000000000 R11: ffffffff818d37e0 R12: dffffc0000000000
> R13: ffff888012cdca58 R14: ffffffff90334eb0 R15: ffff888041425170
> FS:  0000000000000000(0000) GS:ffff88808c891000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2fa63fff CR3: 0000000012c0c000 CR4: 0000000000352ef0
> Call Trace:
>  <IRQ>
>  call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
>  expire_timers kernel/time/timer.c:1794 [inline]
>  __run_timers kernel/time/timer.c:2374 [inline]
>  __run_timer_base+0x67e/0x8b0 kernel/time/timer.c:2386
>  run_timer_base kernel/time/timer.c:2395 [inline]
>  run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
> RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:97 [inline]
> RIP: 0010:memory_is_nonzero mm/kasan/generic.c:115 [inline]
> RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:140 [inline]
> RIP: 0010:memory_is_poisoned mm/kasan/generic.c:172 [inline]
> RIP: 0010:check_region_inline mm/kasan/generic.c:191 [inline]
> RIP: 0010:kasan_check_range+0x90/0x2c0 mm/kasan/generic.c:200
> Code: 03 48 bb 01 00 00 00 00 fc ff df 4d 8d 34 19 4d 89 f4 4d 29 dc 49 83 fc 10 7f 29 4d 85 e4 0f 84 3d 01 00 00 4c 89 cb 48 f7 d3 <4c> 01 fb 41 80 3b 00 0f 85 9e 01 00 00 49 ff c3 48 ff c3 75 ee e9
> RSP: 0000:ffffc9000e2bf240 EFLAGS: 00000202
> RAX: 1ffff92001c57e01 RBX: e00006dffe3a8187 RCX: ffffffff8176f0e3
> RDX: 0000000000000001 RSI: 0000000000000010 RDI: ffffc9000e2bf3b8
> RBP: 0000000000000000 R08: ffffc9000e2bf3c7 R09: 1ffff92001c57e78
> R10: dffffc0000000000 R11: fffff52001c57e77 R12: 0000000000000002
> R13: 1ffff92001c57e6f R14: fffff52001c57e79 R15: 1ffff92001c57e77
>  __asan_memset+0x22/0x50 mm/kasan/shadow.c:84
>  unwind_next_frame+0xf33/0x2550 arch/x86/kernel/unwind_orc.c:621
>  arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  __call_rcu_common kernel/rcu/tree.c:3131 [inline]
>  call_rcu+0xee/0x890 kernel/rcu/tree.c:3251
>  slab_free_hook mm/slub.c:2653 [inline]
>  slab_free mm/slub.c:6251 [inline]
>  kmem_cache_free+0x462/0x650 mm/slub.c:6378
>  tear_down_vmas+0x312/0x520 mm/mmap.c:1262
>  exit_mmap+0x4b6/0x9e0 mm/mmap.c:1320
>  __mmput+0x118/0x430 kernel/fork.c:1178
>  exit_mm+0x1f6/0x2d0 kernel/exit.c:582
>  do_exit+0x6a2/0x22c0 kernel/exit.c:964
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f328ef57fd7
> Code: Unable to access opcode bytes at 0x7f328ef57fad.
> RSP: 002b:00007ffd7ad34110 EFLAGS: 00000202 ORIG_RAX: 000000000000003d
> RAX: fffffffffffffe00 RBX: 0000555594d02500 RCX: 00007f328ef57fd7
> RDX: 0000000040000000 RSI: 00007ffd7ad3416c RDI: ffffffffffffffff
> RBP: 00007ffd7ad3416c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffd7ad341e8
> R13: 0000000000000002 R14: 00007ffd7ad343c8 R15: 0000000000000000
>  </TASK>
> ----------------
> Code disassembly (best guess), 2 bytes skipped:
>    0:	49 8d 7d 18          	lea    0x18(%r13),%rdi
>    4:	48 89 f8             	mov    %rdi,%rax
>    7:	48 c1 e8 03          	shr    $0x3,%rax
>    b:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
>   10:	74 05                	je     0x17
>   12:	e8 7a 7b a5 00       	call   0xa57b91
>   17:	49 8b 75 18          	mov    0x18(%r13),%rsi
>   1b:	49 81 c7 70 01 00 00 	add    $0x170,%r15
>   22:	4c 89 f7             	mov    %r14,%rdi
>   25:	4c 89 fa             	mov    %r15,%rdx
> * 28:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
>   2d:	4c 89 e8             	mov    %r13,%rax
>   30:	48 c1 e8 03          	shr    $0x3,%rax
>   34:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
>   39:	74 08                	je     0x43
>   3b:	4c 89 ef             	mov    %r13,%rdi
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

