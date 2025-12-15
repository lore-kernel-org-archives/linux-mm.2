Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01ED5D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 04:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673846B0006; Sun, 14 Dec 2025 23:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC636B0007; Sun, 14 Dec 2025 23:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C45D6B0008; Sun, 14 Dec 2025 23:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3602A6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:03:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9041D5D5FA
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:03:42 +0000 (UTC)
X-FDA: 84220361484.30.0B2DCC4
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE2D0C0004
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:03:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3m4g_aQkbAPou01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3m4g_aQkbAPou01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765771420; a=rsa-sha256;
	cv=none;
	b=SfWeNr45t9RpTfn6yYFyrf4kqzAvw5q+cdOiekqzo5q+M9LE8zuv/J01BHK/1CZuzAciR5
	2OQ2sv6+wI8K6myUHKExv8mywwT0aYadunzC7MCVrZVUIf2+vK6xI0qn/HRXHIlP2yLLlj
	CGVopHXKCWiwunjr9d5Da00OePd9tlQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3m4g_aQkbAPou01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3m4g_aQkbAPou01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765771420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=PkSbrs5dWbzcr85ayz/EvCdoLhYVeQHZyr/kJEzxiIg=;
	b=wkSjBAa6bvqTUKaowqcTLMNpPUnyVcD/CU6QCs9eN7UY2xj0phMBObnyUYVxCdYT2Q5bVQ
	2CKgLKiCaWg4ZJv0aPsnG9m3p2jci55308l6n1cOrXeFdgFlMLgnICtgQzT3WU3xl3lhay
	Zwe7I9IZucuY3pLnRbUDwA9kfo6xtqE=
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7cad3d056c1so5587143a34.1
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765771420; x=1766376220;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PkSbrs5dWbzcr85ayz/EvCdoLhYVeQHZyr/kJEzxiIg=;
        b=rTHH9q3N3E5TUlzLn4t2gBEiWQpcaEJ8p8i7hTcFrVlEMjfDJAuNE6uKJGetHa+jrR
         yjIZhBJ7/xacuV9BtxMXUp6to3ur+cE4cYL/8OqSWr/MJHpsG5Eahe4iRDGFMV7boyO2
         t5511k7VVTCE7Fv2oB02l4REerW58n65wapqLyUkFBwRceXfq4fmWqieKmscOwZZAuDU
         O807l/UcqEqXnNrbH1bt1xNf9vIsNwGLzWzc3rWjqrY+nTB9RR04iWOh1+M/TEtAjd3a
         xMQ0FRRtSONLH5VLcaVF3ThMEuVL08t5AnELyVDOF4l4iR3MK/skuDSdnVsps0uTNRuM
         2p3w==
X-Forwarded-Encrypted: i=1; AJvYcCWsBTmJ9SzTXr8QUGGcdq8RM9wbUwdZJ0prAA2MSv/CpMXnYDuFg2al/VohDzy+V2nVqvnIYbVXXw==@kvack.org
X-Gm-Message-State: AOJu0Yyas/CXffnjFN3gFr4/ts5QI8NB/JjLT0OvxkTLZHs8f85Y7NCX
	p/zCRW11fWTaXxJNe3Ghx57dwguPbkx1xRJeJ+HqxtRB2Tm7wkMK7T7kc19uKFDveMhESzpVPhe
	qqKgkXgatkL/hDMzBH6QKwKvS3kd0anaI47CYhLHb+fxO9LuYqp4QML274Gs=
X-Google-Smtp-Source: AGHT+IHf8Xguwy4O0kGe7gTqrDJnNRejRcDPnJvKMFBjNIC27FEAlfxiyFzVnDd7cyBzlqmWv7KLj3NID6dhKk6KveQl4mLmDr26
MIME-Version: 1.0
X-Received: by 2002:a4a:b5c6:0:b0:659:9a49:8e35 with SMTP id
 006d021491bc7-65b37fcbf4bmr5262417eaf.39.1765771419804; Sun, 14 Dec 2025
 20:03:39 -0800 (PST)
Date: Sun, 14 Dec 2025 20:03:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693f889b.a70a0220.104cf0.0335.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in finish_dput
From: syzbot <syzbot+d1b2c58262854b97eb1f@syzkaller.appspotmail.com>
To: atomlin@atomlin.com, da.gomez@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org, mcgrof@kernel.org, 
	petr.pavlu@suse.com, samitolvanen@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: CE2D0C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: ygktp1o18u4tptpagywwao4ky8ic4mjk
X-HE-Tag: 1765771420-200476
X-HE-Meta: U2FsdGVkX1+2f7FFceW2UAr5InKCQ6rcNgtTRCwLtnCiJl6iRNmk+a7eEjdj9vvqJnImDn7DAvJU8mi+BQPQadSUmKb4qJgOCHjOnja4AZHCm3fqymkjYhc863aZXEI5QAlgfNeHhvvkib6njuo6J7wJ9HkakIllvKgclqw+Se55aKWRjsC0MPoQg0ijuo4vrSvwRwH6fzU6CFlpgCYVoKXes2klNHvwdKtSk0tBJThvRjXveMy03wsIrV8K+r7on0OZ//TJ2QNKk8hR7P7jpYwcvSJZcrixUEk6oUN1E4qON4HKuCCR2siAIf+j/XIRnXl1xcVaudgJB3oPALkgenWXL62dlKIvJRBesbn+SwDyGlHqlIJmqCWYne7hUMxtPMIjE89YFuyp1h0VrLiAwCMzMK7WR2Kh9jgrtWoME+jsWTNHLYydP3YZnnKNiA+imIVldmxg6FdBCIWWe/VeA3rZzo9vRztwyYHC6K8+CCCpxzcw+5RAegZQqPV0I7oAK5xvPhJmtZT3bqeNz2miuILzhTBCEMcW9smPbOvrmc8++Du8kOViOTE9YG2fvF+tKAh8YnGatJg1EjswqSTJcwu9wI6SpO3dsxsnHJwym+Aqh3aS6AEDRgkrQbVFYKxqTRgdT9j6Gj0Ru45kZduqbxtncXBlM4cYcHWxuO1JIaopszeUnCc/OWuPTVtCCxpUORKfM1PURo8R2f1BjHZkG4GzoKv16KH/YqKaZoLkjqiHCF0W0ezx5EHVMJoj44NMABsOOs2vCUnbDQRXxX4ho4kb1whgIFAMI5UaBiCg/8iKSDe4s9Ecar8xMEZ/8n8iy8S6vmfSx0qDQw2nB6O8I3vhA/MwOf3bsx6UFEQZKREHkcSRyDUkdy3ClFnX2bmRSiiMuyOvkp5t76QfCNK4N60aJcCokX/mFl7mTsX/PdyEmc/cT7fUIl0y593ew0i0LJI6tpm6WtYpOmREshE
 azCY0YUg
 ry4CDvDB4lpHj27sZEeK++uD8/UNhfuz5XUEmf0J+9c0dHOmCFe19tW+DuZDGtYRfTTK1Ebz51AfP7ka4wlvWY/PXiMRzt4/2PnCyRdskSZpez3TCfNisqr5NPvIFAanJE0/0L2Inl3Q2lWisnOIpiwuSIfc2DAz1vAN61xB56Vm56VyVvWqfuvy1cEX577F7i7O9htp1hTO5GO2fHRTwZty0ZPyhDD7YBMBU/DByeOCV1j696+fnsvthfVQY2M0P93oxYqGyB5WawxWJ6963YvZ0I2j3LzOwnWHthcF5F4d1XDciVNqbAwVA9ImdPnd7sMse/H19GeDxcsaT8D8X5NVIPNywkhMHTzF7m81Jw5o1DFkEDDMOLPcvYaBy64Si8vwkKADBc5kLSfh2MvFpK5dWR7BUhR2pfVjNlPM9b+DPMrWPOsP5C7eYPqt9EY430911kT5RWFNg/4FXHWBdqQtGAQBI4jwsTdbZrg4Q3AwR4G81K5edQqUzn+TFRAsNMd49a06hmofIRu3LRuzCMt1Cd4kvRLaL/I9fCAAGOD0rDzFBt5BGEc+AZ43sLge+ovHEJqaTeltsLvsQk8afegkhHKf5JLduj5IGm7D/rgNRhEWKXOD4fm+eO6RlufJ++fTqIaJJQIOb7f/PwgAseGSd4wvVLKQ3vtGoreOmbUidnUhMGGdQ1Dpekf5JwZBJIo/tIXE8Sif2xiM0n6Rkp/r2b/5jPPkTgVM/Cg7CLGwZTvsbzBP8hrc6NZ1TymGF+C33evP1/Ej8jJXVY60+0h3qDXAnRbnCaVnwrk6/irAkr0USOHz7RZgT9mSGLmFRPnxdU8lo6ubBD5BsrKvTu1mBo49oMGFaTpP0yvwVm19fXfF95fNJeCrUc4w/vB8bBlsnSudrW+Y1aERmQ2rRHAAnLl/CweCHyR6Rd+yhQpLlBZgekNiMmfBJcPv8CmUXOKW6BJemyG0EMNx0WuCxBpIIg7f+
 h1+GUtUk
 jT9dzheKqtO8bcT+QHkjEPTvgZNTau+G8TM0WPmzyJHC+MUmSQdOMbNs5HTyNr2SmJj2R3+dFyuHxxt8iHnYqfXreaxzKFe4eX/2TusbazxcbQGICN8LG1PfJK1Ov9N5IVckovjm9WYAa1Xtg5y71xxERB3FJHHxE2ICLogtQ9lJcyby0ooFLyBhc75UssyVoSAG7dkFwN9WnTdH23sNbN8xlk0uetX137Is0QuI7ivMS3yd2ha/INzJdrei65n2l5O81NDnBgjlmBdNGYuRWQKtztZmPb4nYkGVkderVABvYo7MuxDiYgGsbVxnefyo+p5XbBxhrdikpCl+/OxHJdgMxU1DUZUAYMaDHEa7FPaArpmLBhNCZh6MCtAP4g5wnIiS1e2hXE2edzsZXsCgE+M7LsKuhQEEnSfxMx77Du77im1pti93YJf13qhFIXJpitJGp+IvMVW/zeOANXkEMxR6DlVq7fuu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119d511a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
dashboard link: https://syzkaller.appspot.com/bug?extid=d1b2c58262854b97eb1f
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d38d92580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2b5022055115/disk-8f0b4cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/17c3669e328d/vmlinux-8f0b4cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7e72b5dbef4f/bzImage-8f0b4cce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d1b2c58262854b97eb1f@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6163/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=13717, q=383 ncpus=2)
task:syz.2.19        state:R  running task     stack:26480 pid:6163  tgid:6163  ppid:5961   task_flags:0x40004c flags:0x00080001
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7190
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_release+0x2bb/0x3b0 kernel/locking/lockdep.c:5893
Code: 00 00 75 52 f7 c3 00 02 00 00 74 01 fb 65 48 8b 05 da 07 e0 10 48 3b 44 24 28 75 75 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d <e9> ab 98 71 ff cc 90 0f 0b 90 e9 70 fd ff ff 90 0f 0b 90 48 c7 c7
RSP: 0018:ffffc90003b8efd8 EFLAGS: 00000282
RAX: 670f1dcbf9e62d00 RBX: ffffffff81ac174d RCX: 670f1dcbf9e62d00
RDX: 0000000000000000 RSI: ffffffff8d978ed0 RDI: ffffffff8bc08360
RBP: 0000000000000000 R08: ffffffff81ac174d R09: ffffffff8df419e0
R10: dffffc0000000000 R11: ffffffff81ada000 R12: ffff888029131e80
R13: 1ffff92000771e38 R14: 00007f810118f749 R15: 1ffff92000771e16
 rcu_lock_release include/linux/rcupdate.h:341 [inline]
 rcu_read_unlock include/linux/rcupdate.h:897 [inline]
 class_rcu_destructor include/linux/rcupdate.h:1195 [inline]
 is_module_text_address+0x18b/0x1e0 kernel/module/main.c:3858
 kernel_text_address+0x94/0xe0 kernel/extable.c:119
 __kernel_text_address+0xd/0x40 kernel/extable.c:79
 unwind_get_return_address+0x4d/0x90 arch/x86/kernel/unwind_orc.c:369
 arch_stack_walk+0xfc/0x150 arch/x86/kernel/stacktrace.c:26
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 save_stack+0xf5/0x1f0 mm/page_owner.c:165
 __reset_page_owner+0x71/0x1f0 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 free_unref_folios+0xdb3/0x14f0 mm/page_alloc.c:3000
 folios_put_refs+0x584/0x670 mm/swap.c:1002
 folio_batch_release include/linux/pagevec.h:101 [inline]
 shmem_undo_range+0x49e/0x1490 mm/shmem.c:1137
 shmem_truncate_range mm/shmem.c:1249 [inline]
 shmem_evict_inode+0x26e/0xa70 mm/shmem.c:1379
 evict+0x5f4/0xae0 fs/inode.c:837
 __dentry_kill+0x209/0x660 fs/dcache.c:670
 finish_dput+0xc9/0x480 fs/dcache.c:879
 __fput+0x68e/0xa70 fs/file_table.c:476
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x6c5/0x2310 kernel/exit.c:971
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
 __do_sys_exit_group kernel/exit.c:1123 [inline]
 __se_sys_exit_group kernel/exit.c:1121 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1121
 x64_sys_call+0x2210/0x2210 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f810118f749
RSP: 002b:00007ffdda280538 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f810118f749
RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 0000000bda28062f R09: 00007f81013b4280
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f81013b4280 R14: 0000000000000003 R15: 00007ffdda2805f0
 </TASK>
rcu: rcu_preempt kthread starved for 10546 jiffies! g13717 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27128 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6960
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6168 Comm: syz.0.25 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:rdtsc_ordered arch/x86/include/asm/tsc.h:57 [inline]
RIP: 0010:read_tsc+0xc/0x20 arch/x86/kernel/tsc.c:1135
Code: e9 e8 fe ff ff e8 e4 c7 f2 09 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa e8 e7 c7 58 00 0f 01 f9 <66> 90 48 c1 e2 20 48 09 d0 e9 e1 57 a7 ff cc 0f 1f 44 00 00 90 90
RSP: 0000:ffffc90003077ac0 EFLAGS: 00000093
RAX: 0000000063ea710f RBX: ffffffff8dd73ac0 RCX: 0000000000000000
RDX: 000000000000008f RSI: 0000000000000000 RDI: ffffffff8dd73ac0
RBP: 000000000000b122 R08: ffffffff81af6795 R09: ffffffff998e3508
R10: 0000000000000003 R11: ffffffff8168e910 R12: 000000399661b39b
R13: dffffc0000000000 R14: 00000039b4a1e637 R15: dffffc0000000000
FS:  00007fd54d67f6c0(0000) GS:ffff888125e35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000001c0 CR3: 0000000033588000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 tk_clock_read kernel/time/timekeeping.c:295 [inline]
 timekeeping_get_ns kernel/time/timekeeping.c:404 [inline]
 ktime_get+0x97/0x200 kernel/time/timekeeping.c:826
 clockevents_program_event+0xe8/0x350 kernel/time/clockevents.c:326
 hrtimer_start_range_ns+0xd8a/0x1080 kernel/time/hrtimer.c:1323
 __posixtimer_deliver_signal kernel/time/posix-timers.c:321 [inline]
 posixtimer_deliver_signal+0x1cf/0x410 kernel/time/posix-timers.c:347
 dequeue_signal+0x24a/0x370 kernel/signal.c:660
 get_signal+0x55e/0x1340 kernel/signal.c:2914
 arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:75 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:270 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:339 [inline]
 irqentry_exit+0x177/0x660 kernel/entry/common.c:196
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0033:0x7fd54c78f747
Code: ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 <0f> 05 48 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89
RSP: 002b:00007fd54d67f0e8 EFLAGS: 00000246
RAX: 00000000000000ca RBX: 00007fd54c9e5fa8 RCX: 00007fd54c78f749
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fd54c9e5fa8
RBP: 00007fd54c9e5fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd54c9e6038 R14: 00007ffeebd71e40 R15: 00007ffeebd71f28
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

