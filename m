Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7026DC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6115D6B008C; Thu, 20 Aug 2026 09:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C26E6B0092; Thu, 20 Aug 2026 09:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5000F6B0095; Thu, 20 Aug 2026 09:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6756B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:16:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5604A1BE4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:16:29 +0000 (UTC)
X-FDA: 85121696898.28.E1ABDBE
Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1F369C0012
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:16:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 3Kf6GagkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3Kf6GagkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787231788;
	b=P7UaPbHfJavj8zZ9EEa0JbO3yyakDcfD1HvYuuRqOEkmEsbd3uEkI9awQLzZY5p363ah63
	+32/DMUkKY5tAziTaanSMGKM+BPkIjf8uAIcDZ9JGQ/TKZPjH6gQbrEZWHCPdoxJnyxXae
	W8OkizPUpCHANXKC3PxhtOsLY5c5cxo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 3Kf6GagkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3Kf6GagkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787231788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=uuFM6LXyhIkC2ZJ6Ic1X2ISVjrG91bmgnkWS6oOihGY=;
	b=NsTvRDDoLnuiCgPgWUdvBUZWOwJRgKimvLZtEytuJDvNWUuI5GHLsBlOif8lDNQ4QYjIoH
	dutsn3EAvOfxMPUT3kbt4FaYATECrCVEERL9+q8HnbZoE+qzF76pME9JKTGUiPOAHrK9Yp
	El3CHdrWlMmbey25t+F24vriSDDXRx8=
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-45a07949855so3008066fac.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787231787; x=1787836587;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uuFM6LXyhIkC2ZJ6Ic1X2ISVjrG91bmgnkWS6oOihGY=;
        b=mIDKGCcoPG0+i/aQTrlylCU5dSz8tc8ac0NJv728kR63/kwbDWMqfI0NSBV3vt0RBd
         J/0ymTY0YGZjWwWBVhAPWFOmPhOsUfZb5Yfi5kNMwMgkLwqoHb58jbWTUDyCvQhplFCX
         wzfClsvofHooZap7TogvdZcLK0Wz0iyII3c9rU+vkQBUV/Q6h56pEdE/+jlALNeRQAvn
         Efo5hputiwQhABG6vFGVUETDBhUYDdJ19e7W393lgJZXnnFlouZ+FQnHFhDgf4VzvlaA
         kYVEyYVApnfWE91yTmo7pKngCJInZ59vRsTTS+igspf0CvJ5pKLNr726LKEvNPOCbaoF
         9tRQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrcv8462FG9Vsrx+OA5aUEKtpYMw41BMbBmZQQ08BWpyMaWsCrPF3wXEUnah3C5PFxVOjDZoREmZw==@kvack.org
X-Gm-Message-State: AOJu0Yw5Wi5m/AaSos+v+zl0tUeb31DVxIQ+OHkWRXW9jpJw3PJtvqUR
	dftKHnk46olNGFqD44uQiOFSF+WQxrW0qt0gnorl3PYbjxoRcB6Ux965w1QR8CXilb9rVQlQby/
	xvd4SG6lUFE/hhRPHMVrtXw855HY7cIFhwZhHssZlkbhFFdu5oB5RHACOV5w=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:60f:b0:6b0:5233:f69a with SMTP id
 006d021491bc7-6b13c683544mr10382558eaf.30.1787231785981; Thu, 20 Aug 2026
 06:16:25 -0700 (PDT)
Date: Thu, 20 Aug 2026 06:16:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a86fe29.f7a79266.2f965f.004a.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in kvm_vm_release (4)
From: syzbot <syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, brendan.jackman@linux.dev, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F369C0012
X-Stat-Signature: n5jmr5qdu9c6znxn6nnz7zuhdjjwszj3
X-HE-Tag: 1787231787-439723
X-HE-Meta: U2FsdGVkX1/I0EEJHEdsjE5G6kmmkMozS0eTqy2g3lTkH6Fx3IPyov2JZZuwbyMuk9S2U67p7RyFZfHIb7z5tc14Tmm0eNRWz44tnJ+rg4hTEZZy1y6nLocoPoHyYs/M5pANymoFOzu2rmVsI5nMHlsVhVjYGx6sXL0PhWg0yQ6OT24gUWRciEw3VbOE58Ck2l/ccKo704Xr31ttsUymra15UWW1SCLMNb0RVdF0H68GUnDX3yakLSziDFnTD9UgwyI8+aLr28r7IWC9DxbYkwq8ocvB3/MIQAC4TjX0KOqKqEDyah8RvKZbdfwAXr+j69STY4X4kPFDlrILM8WpYHmEI99DBdNgTNVUUOKQ2tSsWCHi5mPkKXB6vulyS3Bo1vPyMsO288R+P2cZca9Z3ukuAAvxlSKXsB4Q00qa0pSYdCXElPIteY2qG6bcDgpdpnCORKxyQ2gjr+Kt0R23/fwpN6ktoX+iealnwn8u2beqyBW6FnvMRj8mSMlwkbhmYtjfDzjF16SsjJbpW26xpXadJaHeC/3MkYJjKf822gHcxPqyRzOl1HZqPSjvnNLfC5CjfqglZgxXRgYy5iMkrO46bU5i29RhixGETvzQf8XdFVXZbmkvr9scO3PfskqRk4ZbY26nl/wb6rPjmxqoJT8B2fOxABzn8bdMvtyj30+zQQLA4MEVKDsO0n2jgUT2VXfNvQPsIFSFrqW5GNNP+o3cSwVmLB5u8SgO5Ex7OQc5eIKAZScllIn3HoLS82BB85uBPopMrfVm5b2d39fhY6mr/l1TpuBMdowHBR14HVESA6krwiI+CuJLBiCBgoVu15eQtX1qKaaif1XPueFDJwMWiwbKKbUKe7YgBmSNseaiyywfq7lCG5UjH4HuYK0kOxdbXEFy/Kv7jEC6A1UZ+NYkmn/HcQs50Q6YI28qiIjZolFA2RYSARD36EB+H1m7FqAA0S9dAQmI0QOI5jS
 8LmHTFCb
 RCuSwywhg6xtwxoUC2xrBiIMjbhC80pE0Z4f2pdHK6nC1tkGB2jNHmDbZ1bfnqDhNIxflmuiH28vyTxSCVvsQASdM1BPq9iFkhanDe/05VLYz2EUWZKeXK/xVKrEyKNH0JsKLJOEmwhIXg/0TgWap+BdVWD9kRAiZUZ3p6yYddXHODHyNlTgdEkRY+8R//ukoXJ42/YQJiC1n3NdPrR/tr9B7zsMsIkVxB0N61/mzt8RBpbW/5U2g/fQPN95kt3eWuoBi5GsxDVBDER1YHU+c+O7qu+KBXuT36qmvQEqLPu69RHgUKB8J0C0xWiCq8i+VMxiR3NmHVrtTpZ8WxeUSRrKLMDAqkgiNc0sahA9oCuNxqq+4CXvVgsvhqMAQ2vK1xBNZScYkwZuNiCHRU2W3OhwhGvxTQ/4aXJB29P7+AdJNdHOhCejmDSQV7YF7jEd7LiLVqVZYybPQB9q/g0eE2y+n91VgS6h1wemZU4s/gSnI1PUxIOgyMOtIIvMOq5+pT9Cgzobbv07pplRynDoWaQ8S+y7f7Zd2B+b8KQ5ULAQuFbhzkPwYI7T23jPTap6ZUH16k2qbZJXNzcxAUbzmqu4wba71Oygb2gnTl4d/6YBHP/YNRCzzmCcrVQH1cDrOyFmVcTmIw/Jfz1xLSNwx7pXYZNeXJ27tOhH94o+Q2xuX1o8AdJmqUMy0/nt+8OlBH5DPXWHfIcPceSVBmlJYbtPy6TYM36CpnK3gmc1IVD/n45iY5bxcnjlfAeFaADdS0URT4vNHPu2lukzXOy6TR0gat/X+TzIF6AhZniuq78M1bRVuOFkjG1Bi0GP7m8XsCBxJ9XNIUizSSsd7A/Y/LlKmb35ITX+qkgBIZfRH2esmB8KxamFG9i1Oq5+znm139UVg/jDntrQp3zVsTKCOZKdiW00K3URrLRknImkTWQ+S7Xj+zVBMqzvfDnOjU/97UdgjMklaP7x7mz2i5exoq3EKNida
 9rRMlNeg
 qrOCRgU1csKgMZoRHCS5Ydv7tXXfMFSCyxUloF4bjpcYEm3hjIGla/2LkYnhfMxOLDh/v7NbIu0U7VvT4+wNvI/PnaQdFYmfasVfjb2yIruk6vGdVLrtsp748V/9KtgEwZXGJu43kFtiGo+Kk2WS0LSeqhvcPGMSqhyuf7ZpK3V1eqy0sopugX16l95k4BnQnHucxNBF9OC//bJi9Utjviwot55cPhQbjyv0eDg9O5G+cNplKDd4cjbVZjepynL425D9mMEnNU4glq5JH3Gc1eFtz6U/u/Xx4BDgwq7i6+xY6UHcPqTZjSEFjUTWe1bYjoldWkDbKVl+wp8GT7gfheQfrzp2vZ3Ut4IAePx9mlxsMoxZNm04KDZ/7/Yko1Wwz07C6sS2XT6B4nUKBx53H+DRY83/KmL6eM686QtsUmW2RqaUIxccwwoI5j7Zud0RVQJ9t67+QsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    e8bf40d15402 Merge tag 'chrome-platform-firmware-v7.3' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1434f815580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1941312e3e971b07
dashboard link: https://syzkaller.appspot.com/bug?extid=5f0b6e2e4195c75b5658
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7df7b958efe0/disk-e8bf40d1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cefbf90e524a/vmlinux-e8bf40d1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/37a530b91001/bzImage-e8bf40d1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P21500/1:b..l
rcu: 	(detected by 0, t=10503 jiffies, g=207513, q=1145 ncpus=2)
task:syz.9.4605      state:R  running task     stack:26920 pid:21500 tgid:21500 ppid:14397  task_flags:0x40044c flags:0x00080003
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d4/0x5630 kernel/sched/core.c:7239
 preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7561
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x910 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:lock_acquire+0x222/0x350 kernel/locking/lockdep.c:5890
Code: ff ff ff e8 c0 0b 32 0a f7 44 24 08 00 02 00 00 0f 84 39 ff ff ff 65 48 8b 05 12 77 cb 11 48 3b 44 24 58 75 33 fb 48 83 c4 60 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d 57 a1 b8
RSP: 0018:ffffc900074cf260 EFLAGS: 00000286
RAX: 7db047bb98fc4c00 RBX: 0000000000000000 RCX: 0000000000000046
RDX: 00000000c0065176 RSI: ffffffff8e4b5735 RDI: ffffffff8c4bdd80
RBP: ffffffff8177710f R08: ffffffff8177710f R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8eb5a0e0 R12: 0000000000000002
R13: ffffffff8eb5a0e0 R14: 0000000000000000 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 rcu_read_lock include/linux/rcupdate.h:840 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1183 [inline]
 unwind_next_frame+0xac/0x2550 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 save_stack+0x122/0x230 mm/page_owner.c:165
 __reset_page_owner+0x71/0x1f0 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0xc22/0xd20 mm/page_alloc.c:2950
 __slab_free+0x274/0x2c0 mm/slub.c:5741
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4584 [inline]
 slab_alloc_node mm/slub.c:4917 [inline]
 __do_kmalloc_node mm/slub.c:5333 [inline]
 __kmalloc_noprof+0x315/0x720 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 _kzalloc_noprof include/linux/slab.h:1309 [inline]
 kobject_get_path+0xc5/0x2f0 lib/kobject.c:161
 kobject_uevent_env+0x29e/0x9e0 lib/kobject_uevent.c:548
 kvm_uevent_notify_change+0x300/0x3a0 virt/kvm/kvm_main.c:6335
 kvm_destroy_vm virt/kvm/kvm_main.c:1260 [inline]
 kvm_put_kvm+0xa9/0xb50 virt/kvm/kvm_main.c:1331
 kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1354
 __fput+0x418/0xa50 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x73a/0x2360 kernel/exit.c:1009
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
 get_signal+0x121b/0x12c0 kernel/signal.c:3046
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x10e/0x770 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:336 [inline]
 do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe3a1f5e90e
RSP: 002b:00007fe3a2e23f58 EFLAGS: 00000246 ORIG_RAX: 00000000000000e6
RAX: fffffffffffffdfc RBX: 00007fe3a2e246c0 RCX: 00007fe3a1f5e90e
RDX: 00007fe3a2e23fb0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007fe3a2035024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe3a2226308 R14: 00007fe3a2226270 R15: 00007fe3a234fa48
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

