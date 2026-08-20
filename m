Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F295C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 16:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB676B008C; Thu, 20 Aug 2026 12:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D536B0092; Thu, 20 Aug 2026 12:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4733A6B0095; Thu, 20 Aug 2026 12:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11CE76B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:29:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91FA7A294C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:29:08 +0000 (UTC)
X-FDA: 85122182376.26.589662A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A5D1C8000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:29:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gRMg0DUJ;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787243346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7rrQbjFWQhpgwvFpnffKqDVQwlj6CC5Ug8YTE0oB9o=;
	b=v/BIOD8JZqKuy05Ttct+HeigXqxSPuTruDCN4D1SFecy9ZUX0F2M7Q0UhpJSDR1n5+Nase
	0jjnMws14ue9P20M2shwfzLZrpf/p7ODLqRZQyjtg1KAhGS35GOujt7moJevQ3F5UiR1Nd
	RgvRWumrDBey9oQ4+ztgb+6fKNL2seI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gRMg0DUJ;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787243346;
	b=U5cK9wIXeaz0MKatJUWo2l0BAUwb4sToboT0dKBHXCk7uZV/4eRgk8THzi2GJbjfde2w3h
	nsQ7S/GUnCvD0h1BHv8nGVryuOKrnrznCwplCi7rWNIKffT/MH+85WVKpZzbLuvc09mfbY
	oo8s6rmMQdQWrXSNTDf1hWPVxKu/gFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64AC140AC9;
	Thu, 20 Aug 2026 16:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1061F000E9;
	Thu, 20 Aug 2026 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787243345;
	bh=u7rrQbjFWQhpgwvFpnffKqDVQwlj6CC5Ug8YTE0oB9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gRMg0DUJ3tfQx9yaJjqqz/k8cm0HkCmclts/fJksPlqXh7TFPvhL1zNv1uvgsPesY
	 vlHwJLcgx3slBNZiy2HKlrmV4m51r793suAbdK4j3H7u1s0pus8EftR1TrOjCy3jVz
	 I4O+3qjc01VsYkXTto6BOtFyWhW4f1xH9F5UCB3E=
Date: Thu, 20 Aug 2026 09:29:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com>
Cc: brendan.jackman@linux.dev, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 ziy@nvidia.com, Zhen Ni <zhen.ni@easystack.cn>, Ye Liu <ye.liu@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in kvm_vm_release (4)
Message-Id: <20260820092904.7a2b43fff85ed0c13b9c74ab@linux-foundation.org>
In-Reply-To: <6a86fe29.f7a79266.2f965f.004a.GAE@google.com>
References: <6a86fe29.f7a79266.2f965f.004a.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5D1C8000A
X-Stat-Signature: x5wzuhz175pyprxmmbwf6upzk9w4eytq
X-Rspam-User: 
X-HE-Tag: 1787243346-142696
X-HE-Meta: U2FsdGVkX195SV4hV2cjjy22ztysNSo43PmVndQnslyM8okX2mn+fvTT7F4VOVgKzm2yVsdrEmtopR2x6VylsY9FwAgetP6qTS+RYg5chAdo8EjEEo+If8z3nexwocW6+IizToost0hWnfBw4N14qbnraK/djub++dRjWbECpjIjCjR2zurGavDH/HJBQ+dyaXvNtp68Yr6oDBfYzzMcExiupxfGBAo9xPK4OVcZl1deGfh8Y2kAdqXUN/F/EN1uWEgLNvPrWb3OHLmiHqfCPzCQp2C1qsUXdh+M80aYGCoxwtrfSUXFGT2EV6q4EZprKQ3CsJ3xjSoZnXtKI4w7DWrAdd2OO3daYBAzXFOZzecleIxAASsEzBAMD2l4UXY5RecLl67/peqV3fASZfjYgSVb9iwNks/fFOniroTOuMOwFnAwzFk9jaRu4CHXb7zhpqOJZ4qKO3y3F6OnK2o4S6yA5PydKBGiOwwGZSrsU/3zy9Kf59rjqf72SOBz5pYwU5WnA69q2JO0UlBfnYHqWh+s8bB9tDYY9DITA00wSTiuYnJQ6z3NBsJah6e+NRZgYONWEDu99h4x68hAg3pvGfENxmAwHPgfw7geRp2XWrRY+G3UTL+AQsAcJzqaRsdDSmWIjAJcB9uKRhYE3yIIr4mta70ueaRuZNVEE7dP0Z+aVbO3qWpyX4Pcw8FWQij+NjBpeWOqBzBINGIvbaH1Z686cWfSs5glYbX3PJ/K29ERhEVpnN7c+vyo5RtQl/EQS1uhsYtNXSAkiRRJhKkZgHUavT2BDsofDF0ArYAmuKQ93vLuG9vUN5kGdqO/ql1l3I56+56xY8H/cKQCVz63CU0KNOD1wDXlnsrAo5ODC8fTBCw2B3VTunmI8Oycrc7soiQo9GDJxkWrJJqNa4s8anuY85rOBCH1Vuj6rSOuGpf4Y1hZd23jvTg6JvNCHpEgrCb5cU/U3hMDXAhdtVV
 ZRNmj0C4
 A6FXoPhPULcpLQ3yb2QgRtb/NzWfWBsx0tgzPAjJNs/vY0vYbf04uQknlOvQOe+LDxwAIosKJpRBVSryNBXPHb+vXVOzVDtOJ0w/4hVhA98UXwz7ZV1t5FWrG0hd2YmGh7qXIo7Uy2a+mSy1uxkKAEnWrGFpVJolfgA2IAeDUTRQfnEX/eh/DjBRmixsnxgkDx5jCuMcpC4GnM9IckAp8a9mymMcvbgv+wk2yEFpb5UC8gNY9+Dn1ojWi/LrsEtnI6fWxsYqMTc00y/nWQJWGLvdMmCTvg3Y4N50wBOByI7X8utC3bsD7MB3g8+q5WXiQzMzID0tXQ90A/FUg8xE74LVaL81XX0khDniGSAMlleqq4JIfL+PUVu4Syvtp6mBYktapDAVf2czwe7eHvuJGgg3Rm8as6q4SuyyHo8osAAtpbYsxAU+z2ZxNf2EpqxkJgWeYFuxCATKDVF4o+hBVgvTm4UqbXrRHKDAHnLYoHO1eG4cODyzkKqhkkWWipWAB4z+NA6/XnU+pMaTN1j3YoELlIAxYgF6ToCGHm3WAHzkyOKqTXDz0OHmQEOJzXlUFOwC5yL6FicVbwu/lTyc+/LA2kxWjPYVgHNWmq0xAqAX9ZjRdMDDIb0sqMK0MDiuAcQH5ri2J+LzqanQZN9gxRgUhGLyZ+UJkDtSahZIBNMhE/PyJupZR3G6U6eQK3F9fYn+yUH0X4yjyCx2bn+dNt499fqH27YyzhGHEnQunT3Py7Tg3WiT6JdQdC139KW2AGG1wr2siQ9WL/a7Ki0gRnlYaUgzXtO19hlInmA+ItJ6Y1eLVPf4PWMJS5a3qQMWb/wE/BBKmFIyix6MFS2AhzWU3OYhDLckmyAog108k1BUgZWuW8zJIVv7GFUrvqnPJ6A9H4ttwKtUxX9SON+hOfmVbXeVhLZhnb3Hz9LDWf2SeQdgFOAe2sS5kLtK0zXmGShS0YSn6H4kkeRMtnGc7xOJexktd
 9a/zR4dI
 2GKE8YtEREHJNT+qP7QEVwT6UPLf5g1iQYB90jasfL3GSaEJBXWtWRQ6ruQx19SLjsYmTD14/JzwDO96MZugPt8hl/Q6l3cwMiBlBfLalSx0dBLEtwTKl8lVTbPSuVKeaJez7fUhFiGx5iz/0vx3k0O3SSngZQnaBDgvqepTP7HrKNcpawl0BKLtg/Ni7WEMLr7TZWunsVG2Ncgj3iB2bsFXsqjeW9eC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Aug 2026 06:16:25 -0700 syzbot <syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e8bf40d15402 Merge tag 'chrome-platform-firmware-v7.3' of ..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1434f815580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1941312e3e971b07
> dashboard link: https://syzkaller.appspot.com/bug?extid=5f0b6e2e4195c75b5658
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7df7b958efe0/disk-e8bf40d1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cefbf90e524a/vmlinux-e8bf40d1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/37a530b91001/bzImage-e8bf40d1.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P21500/1:b..l
> rcu: 	(detected by 0, t=10503 jiffies, g=207513, q=1145 ncpus=2)
> task:syz.9.4605      state:R  running task     stack:26920 pid:21500 tgid:21500 ppid:14397  task_flags:0x40044c flags:0x00080003

Thanks.

lazybutt pasted this into Gemini:
	https://share.gemini.google/9rAubqC4qNzf

: The combination of debug tools: KASAN quarantine processing + ORC
: unwinder + page_owner stack tracing executed so slowly on the CPU that
: it exceeded the RCU stall threshold.

(I think we've recently seen the same thing, different callers)

I can't say I'm terribly motivated.  page_owner is expensive and if you
run heavy stress testing with page_owner enabled then such things
aren't surprising.

Let me Cc a few page_owner and KASAN people, see if they feel
differently.

> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5510 [inline]
>  __schedule+0x17d4/0x5630 kernel/sched/core.c:7239
>  preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7561
>  irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
>  irqentry_exit+0x14f/0x910 kernel/entry/common.c:167
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
> RIP: 0010:lock_acquire+0x222/0x350 kernel/locking/lockdep.c:5890
> Code: ff ff ff e8 c0 0b 32 0a f7 44 24 08 00 02 00 00 0f 84 39 ff ff ff 65 48 8b 05 12 77 cb 11 48 3b 44 24 58 75 33 fb 48 83 c4 60 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d 57 a1 b8
> RSP: 0018:ffffc900074cf260 EFLAGS: 00000286
> RAX: 7db047bb98fc4c00 RBX: 0000000000000000 RCX: 0000000000000046
> RDX: 00000000c0065176 RSI: ffffffff8e4b5735 RDI: ffffffff8c4bdd80
> RBP: ffffffff8177710f R08: ffffffff8177710f R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8eb5a0e0 R12: 0000000000000002
> R13: ffffffff8eb5a0e0 R14: 0000000000000000 R15: 0000000000000246
>  rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  rcu_read_lock include/linux/rcupdate.h:840 [inline]
>  class_rcu_constructor include/linux/rcupdate.h:1183 [inline]
>  unwind_next_frame+0xac/0x2550 arch/x86/kernel/unwind_orc.c:495
>  arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
>  save_stack+0x122/0x230 mm/page_owner.c:165
>  __reset_page_owner+0x71/0x1f0 mm/page_owner.c:320
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1406 [inline]
>  __free_frozen_pages+0xc22/0xd20 mm/page_alloc.c:2950
>  __slab_free+0x274/0x2c0 mm/slub.c:5741
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4584 [inline]
>  slab_alloc_node mm/slub.c:4917 [inline]
>  __do_kmalloc_node mm/slub.c:5333 [inline]
>  __kmalloc_noprof+0x315/0x720 mm/slub.c:5359
>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>  _kzalloc_noprof include/linux/slab.h:1309 [inline]
>  kobject_get_path+0xc5/0x2f0 lib/kobject.c:161
>  kobject_uevent_env+0x29e/0x9e0 lib/kobject_uevent.c:548
>  kvm_uevent_notify_change+0x300/0x3a0 virt/kvm/kvm_main.c:6335
>  kvm_destroy_vm virt/kvm/kvm_main.c:1260 [inline]
>  kvm_put_kvm+0xa9/0xb50 virt/kvm/kvm_main.c:1331
>  kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1354
>  __fput+0x418/0xa50 fs/file_table.c:512
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x73a/0x2360 kernel/exit.c:1009
>  do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
>  get_signal+0x121b/0x12c0 kernel/signal.c:3046
>  arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
>  exit_to_user_mode_loop+0x10e/0x770 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:336 [inline]
>  do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe3a1f5e90e
> RSP: 002b:00007fe3a2e23f58 EFLAGS: 00000246 ORIG_RAX: 00000000000000e6
> RAX: fffffffffffffdfc RBX: 00007fe3a2e246c0 RCX: 00007fe3a1f5e90e
> RDX: 00007fe3a2e23fb0 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 00007fe3a2035024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe3a2226308 R14: 00007fe3a2226270 R15: 00007fe3a234fa48
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

