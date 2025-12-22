Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E17AE67496
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA546B0088; Sun, 21 Dec 2025 22:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E016B0089; Sun, 21 Dec 2025 22:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CCF6B008A; Sun, 21 Dec 2025 22:48:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 512F86B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:48:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC4E113BB47
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:48:30 +0000 (UTC)
X-FDA: 84245724780.23.2BCA05C
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3CEDC14000F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:48:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf23.hostedemail.com: domain of 3jL9IaQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3jL9IaQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766375309; a=rsa-sha256;
	cv=none;
	b=kNkc96Kisk+ebwDXVt3ER05e7W18ZaurqKdjood8TK4nxgmvI92NbhufAoTIrBIScvOed4
	xKhVMzGOEPujC5Z16YMXpvWUR+JIzh4nHpsVXTXcGnSBDxjtvlehmbfv5Cz5t7LZJyxU4h
	MyfXavVc+ilolcyeu/w2LZPjgXiM9cQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf23.hostedemail.com: domain of 3jL9IaQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3jL9IaQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766375309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=JJA07a07liZblpJBhg7XvJrBqGLeculdtujgTcOdXjs=;
	b=PKoYHJzHXKJx/knztxF3iNgcmmoAhHBbRvqB9lxlhCpd7FEjpnQaJDZArnEN2SOEsb6FkM
	a3ng+1+cYdKynTFZrpsVA8BPV4iOlM3FcKj256TfNtVwA4OFej+INBWV6Os0JuM0KRFW2U
	oEcx9DadF9pnZd8w6ie5qMWecZ8iyDo=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65b2d43a899so6053783eaf.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:48:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766375308; x=1766980108;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JJA07a07liZblpJBhg7XvJrBqGLeculdtujgTcOdXjs=;
        b=UH2SalETEycU3tY9ToQmfwrNwRXKE+9E/B+f8F6du0PcflNfLuSwi7bkhFpGUxa57D
         jZNIX8YGkkzIHEHpwhCLYelwa3P94y8VH3FFcNR81HSslamtF9Fxm2hshS0ae7nz0WQ4
         DmWBWVJ8zgFwSEnWEQRHFqi3MVoiVMXfA8YvUxqB6T0pEDeOy7vpzx/0lY85z72kjU2q
         B60XieBunMKf5JiNRwn4P8Lpqjcl4oC2dmRAl8yKzmyvVDGde/geYCGQ0etT2lWWCrpZ
         D9HoHuADpQE+6gPdbBdX3UUJIRlGXEG4l1bC65u6sBtwbtxxeddu0FVS6f+HgWCRCukq
         nvMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlf8X3eCfurHYYHWCcQk8KnYitplZ9+Qq+UysDIcAOC0y3tCUE6eDQiPjLIKS9FtvbuUQTfNJj7A==@kvack.org
X-Gm-Message-State: AOJu0YxYByWWm4xOOzBt8PUTaIyKiE18Rf0SZkvgvRbAycWtGIVE+wrS
	S1utdsUMu0Honas0NBUwC+9UJbJ4o5WVIbzGRp6oSaDpBBNmyw47tg2VbUhg6OAfVJmFZuOqbbJ
	SyqWunH+jmtmFzSZs48zOS85h5V44n+DMwTieImsQirEIcnxXpKE6U3iAxKM=
X-Google-Smtp-Source: AGHT+IGbzVJ607gESXPYbhG5hho8qrQLZDAS1oMVh9aezr3pY6F1cpSguyWBVXiSuqRYJokCnuyOcK2wAGzyOemQxx7O/FoVe/Y3
MIME-Version: 1.0
X-Received: by 2002:a05:6820:330d:b0:65d:762:749a with SMTP id
 006d021491bc7-65d0e94d689mr3139229eaf.7.1766375308236; Sun, 21 Dec 2025
 19:48:28 -0800 (PST)
Date: Sun, 21 Dec 2025 19:48:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6948bf8c.050a0220.1b4e0c.0030.GAE@google.com>
Subject: [syzbot] [tomoyo?] [mm?] INFO: rcu detected stall in sys_newfstat (4)
From: syzbot <syzbot+5fb7dcd004f42cb418d7@syzkaller.appspotmail.com>
To: jmorris@namei.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, paul@paul-moore.com, 
	penguin-kernel@I-love.SAKURA.ne.jp, serge@hallyn.com, 
	syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp, 
	tomoyo-users_en@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CEDC14000F
X-Rspamd-Server: rspam10
X-Stat-Signature: c5c33e9kaxuyggmtirc3gw8a9hmo54fo
X-HE-Tag: 1766375309-378706
X-HE-Meta: U2FsdGVkX18qkv6ikwZKgRKCknVWZUfl1Z/lvyG/t7KSuBKsi/2StIF8j8z8dRvJeOBPw8/JIJfrXuS8CmLSGK0+uDuiATLIn/yP2EPbuNNWcxcy181haiWRDOAnzUE4HoOslJ8K8LWY2pFjt7brMmi82FWqnIrXL2fODr7vDYxDPjsp0w2LjDpmMq/FOMbs3XXks1AKDultrysRjfQazKMn/c6wvDeCCXYkkTnmS4ridfgYSsjzEALzB69fIisChawHrXlSQ9McvAeBD6nJh3HjjH9fmNFSwtnDpnO1PWBz0CN5ka0vTsV+M+tE7tIMfjwmR3c4V6MSBULEwWGLkbf0UJe4m6oDLIZKDKHqHTzZfMhxuAmYe1eZUCf7Q6U+nrtqvnuLuaML381bcklwgf01Fm9h03qcoh1lDBNPPsC7OXUYpF5AJPv7f34WT/va/QvouYEXrSIk5v6kuzbLjsfSzORBcRRl61/TbJmbfWg6frd+6uFUkHjE0tLuHVwZcsM2lNuRVj/MwfgdV6fwhmhZT2aNXJRb95kh5W+e8WHwzLahGC2EslJ8Pbh5cgvV/w4zWfGX+6CY7DGtetcCcNNEQZsOi+WHQ784unjVQk18Tx5hmVDT7KP7wNQDkpFdmGD+LXaTDFXRUvFgZTV5sSQvKKiSncK82+dCFdYgcCDRvMAzzyJS+PJiAkTLfFWSlxo8gqNbeTWSY5R+fywlrCgL/P6K4zn6m9ykBWguwZlod/Gv23JG8sVzAx1jE0Ohwok/GSkCkwdfJo+iCoVregmroP2dqMDSSlpDwxARxD5lGXAAZG0/tklocSp9Uj0ixQNiWWL0TJIbZnjWOjwL6jxTbiXZJ7VSDYPMcU22/e5Ffth8av2qL/Y7Hzr8NpE8xytB0VqTdjwD02CuZ1QlVD4Q7BOS+JYDZLiZvIf9tK7E/6gERiePymktfvUCo6vb63Pi3AzVws/D6bGgUN1
 ZD5GiAu9
 L4sf+f03+lHfgKWOrgcfjEwmXmj00qXdXXhYQrWe+moSeYsJWtDDKLesuw6upDr+y9X6AdRjE+JFhmacMje5KsxtBDhQg1/ieTCdW4TAQfMPMF4DApqc8qbKYDjdkg6gKHOAOQErk2ZbWCU/B7fPMgdPqZJSai6w/E52x073cvA7t8kNHADx5mvjA0tMXLdL/MdwQHzw9MQel9ZQlM3PbTX9QQxdR1ficZw1TaU7Rn2aRvzLF3XJdjHzXc/y2Yj+qig0pU+2ek5OPQdKrlvMBmg1HjnHkW8jXggW8PNMK/AjiZshJRxd9DaFHtLl2mLn0NdNND4RD8TPkcTNeNIvQUmw8cO8uQpb1JW9AbCkJ0Obs7kHTqZLK30sNvO1ong13FhzyFW4Fae59ksR8kchRMEAS1y9bute6zoZIjHF73Ca2fPlARNjSWf7er5mZW1QGvlRtiNmFDfNW0SLPeC5C3fgqoZdzPEuOErCivssAFPCxMF6aza3i/5Meq5fF97WoMi9ZEk/nTDDhZGzWOCOGRAXG8AMgcYtQ6try0Mn7DExHdeoaFfoYPb2+3HrfKmNLe+CZpV/Gf5UOxaM8rjd+dBIqHPmzXRPPwwNX2nHJGv1Fta1J0nIYeY2gtHOVeGphta4TrngRUCtLwDprX3Cml50cSAUDao8LOze1jYDsBqzOybbFnJcltqTL6GKpZ5SuDZv6kGjSPoUeQzkCbJTjLrTrsKJjzOHk3s1Z+cLa4cpFXTVeErWd8M91Xm269w2Wx2yNMlH9OPvCDw3uu2l5XwcN6fWyP93J8Fa9LIkDKlk1i3csqFsZObyu1k2ZbLMIM5W6JLXWX68gkKp77tPMEfz8ikH/Awu1k7sRMapFpQhkGOKG0F7GiqjPQgpwFbl8p7AacVYbPKufani+sOE5EgewAkT1l5+3pJUtl6tQM3F0gdxOStZx/UcugHoiabyTLWhjc8V1J4p96b/FdRfNBq4JqW08
 x3/+9Iq7
 YF4o6vO2dzIJTx8G3I+g0qhXjOK5S6EK743+Jh0tyjpko4dRbHuehNm3ECLsUMBpmSFChkppGiHR5SJHimCNGsSUM3zIK3VjRVj95Ps2eGHTqvD7wGuigTyr2m+/N25Ju+A9rP8n5IDAM6hIgSyp20sZrWPiObHpCQLMz4SU0ampWzMe/GjDfI240qv1ZQikfOmi2sYNUrTMYLI0doAVLQ5nRDVqcT6SHCuiWED/ypO8saHtzRfT4EmAUiKWtIB+bEGwb92IwcXIAZ8AFCP4ibo34NIwCIYBV8RJt+34CPUxgh4yyR2eG8PHVKT0DbnzVdpRl45Fj17TLLjWR5Q4IHai+yqYRHacwZcW6oX0hsG3SjVN9DKbvhSyvwajSJwzhGjPnf67QzBibYp4Y+m78ML6p7+mkKj+y7ix2xn/Ges=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    12b95d29eb97 Add linux-next specific files for 20251217
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16bbd31a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9b53f0e28d100777
dashboard link: https://syzkaller.appspot.com/bug?extid=5fb7dcd004f42cb418d7
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11355d92580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0264b4454f47/disk-12b95d29.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/72a383625b53/vmlinux-12b95d29.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6499b25d444f/bzImage-12b95d29.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fb7dcd004f42cb418d7@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5966/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=13749, q=681 ncpus=2)
task:udevd           state:R  running task     stack:24376 pid:5966  tgid:5966  ppid:5200   task_flags:0x400140 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7193
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x16c/0x340 kernel/locking/lockdep.c:5872
Code: 00 00 00 00 9c 8f 44 24 30 f7 44 24 30 00 02 00 00 0f 85 cd 00 00 00 f7 44 24 08 00 02 00 00 74 01 fb 65 48 8b 05 74 3f 25 11 <48> 3b 44 24 58 0f 85 e5 00 00 00 48 83 c4 60 5b 41 5c 41 5d 41 5e
RSP: 0018:ffffc900035174d8 EFLAGS: 00000206
RAX: 550ae36b7d32a800 RBX: 0000000000000000 RCX: 550ae36b7d32a800
RDX: 0000000002aa642d RSI: ffffffff8dc9133e RDI: ffffffff8be243e0
RBP: ffffffff81746f85 R08: ffffffff81746f85 R09: ffffffff8e33f8a0
R10: ffffc90003517698 R11: ffffffff81addf20 R12: 0000000000000002
R13: ffffffff8e33f8a0 R14: 0000000000000000 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:867 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0xc2/0x23d0 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6674 [inline]
 kfree+0x1c0/0x660 mm/slub.c:6882
 tomoyo_realpath_from_path+0x598/0x5d0 security/tomoyo/realpath.c:286
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x213/0x4b0 security/tomoyo/file.c:822
 security_inode_getattr+0x12f/0x330 security/security.c:1869
 vfs_getattr fs/stat.c:259 [inline]
 vfs_fstat fs/stat.c:281 [inline]
 __do_sys_newfstat fs/stat.c:555 [inline]
 __se_sys_newfstat fs/stat.c:550 [inline]
 __x64_sys_newfstat+0xfc/0x200 fs/stat.c:550
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcf92911ad7
RSP: 002b:00007ffe4ab44048 EFLAGS: 00000246 ORIG_RAX: 0000000000000005
RAX: ffffffffffffffda RBX: 00005558e4439050 RCX: 00007fcf92911ad7
RDX: 0000000000000000 RSI: 00007ffe4ab44090 RDI: 0000000000000009
RBP: 0000000000000001 R08: 0000000000000620 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00005558ba62e95f
R13: 00005558ba63f660 R14: 0000000000000000 R15: 0000000000000009
 </TASK>
rcu: rcu_preempt kthread starved for 10446 jiffies! g13749 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27728 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 __schedule_loop kernel/sched/core.c:6948 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6963
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:82
Code: cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 be 21 00 f3 0f 1e fa fb f4 <e9> 48 ee 02 00 cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffffff8e007d80 EFLAGS: 000002c6
RAX: da29ab50f81b1900 RBX: ffffffff8197c88a RCX: da29ab50f81b1900
RDX: 0000000000000001 RSI: ffffffff8daa76bd RDI: ffffffff8be243e0
RBP: ffffffff8e007ea8 R08: ffff8880b86336db R09: 1ffff110170c66db
R10: dffffc0000000000 R11: ffffed10170c66dc R12: ffffffff8fc3b070
R13: 1ffffffff1c129b8 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881259e1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31163fff CR3: 0000000077280000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x73/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x1ea/0x520 kernel/sched/idle.c:332
 cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:430
 rest_init+0x2de/0x300 init/main.c:757
 start_kernel+0x3a7/0x400 init/main.c:1206
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
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

