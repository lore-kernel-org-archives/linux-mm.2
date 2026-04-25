Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9B7FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 09:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3F56B0005; Sat, 25 Apr 2026 05:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364726B008A; Sat, 25 Apr 2026 05:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A636B008C; Sat, 25 Apr 2026 05:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 149CF6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:32:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2AC21C0348
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:32:37 +0000 (UTC)
X-FDA: 84696563154.22.9BE520B
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED3B8A0002
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:32:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3MorsaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3MorsaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777109556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=bA/GX3iTFBK/+UL89+u/hJNZRb5v6ZqgBIyssV+uBSc=;
	b=vVWN4+bPYp3e/rFXFdQqpCeU7cbcaUs1enOsUwP6yyEt4IosnV+WGww8CjLOVy4h5Dsvkw
	/3dOzHHBt7/jRMy5uLzX2WmD+ad3ByGk9T1HxFL36BHDgp9AasFy0at3H6Ootq5mld+VsM
	8kxtfnG0uGx/tflttUfARcL35sAgkEw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3MorsaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3MorsaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777109556; a=rsa-sha256;
	cv=none;
	b=nU5q/rDgAKRl0JY7vuYDAXN4Y4Uy0zMBrSpjK27UPxFE9Vn+xmbXICYGpk0g47hdYs+vrW
	wnuu4aqgMP5dwR6MPbW4ohQAOq8hm0nw5wXz1zbbmyi9qHjVpcgd2jcUMe2HF8PjZ/HOjD
	TxKPe3QMB2RvqV2ma6//P7t1QaQPU+0=
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7dcd9f8dbe2so7682936a34.1
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 02:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777109555; x=1777714355;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bA/GX3iTFBK/+UL89+u/hJNZRb5v6ZqgBIyssV+uBSc=;
        b=D6tEI5YiSCCVMis2/n4cDyp6u1QoNFrJcChfQC6f9VInHhrZy5mW3u6jxmIhumexZz
         /pIbAbaCoDNZA/JdMHnrG0iASqo8h6ila7CSHbW/T3U7ITXEdpROraS+t7te1MCuJAeL
         dWZcwneQ25sR4n9He92RQHpfOA0B6beBMgw+Wn9MfgczIimqOxOuI6+PodOwDOh3PqtL
         dr/DbjHfpVFFB1B8QxTMhquGObvDcN5bFrnta9TWB1gFQQ1oajZchkmKiGzeDVXnjVHu
         WYCZFfnKz1QgKynygieeqhEXshwxvCDV1iEmQ75Uhq4VEhqIp8qWETRwGYeEBSWSpIn5
         13og==
X-Forwarded-Encrypted: i=1; AFNElJ874JlyxS7pkqUFIx3n2ltYXl+z5nGpDXXXucLvGXvgaHk1tG89NRWz2Ec6aXvODBgUFXE0NTajrA==@kvack.org
X-Gm-Message-State: AOJu0YzUFIsiSi7rFWq2Awn/OXPS9rW+gPfXpt/6WXWv6AQkOGE+t/Nd
	cFEwipzzBS9vMY8CqkVRwyzxBvlGUK0v5sjMO3fX/wkaqFqG9J+LqAtk+P//S8hV2oLv1/vU3kx
	4dkNOSoJledfcERni1Z1qVkLCjaLhMkO/98oCuMbVKV1t6DrQm3/5gLSziIg=
MIME-Version: 1.0
X-Received: by 2002:a4a:e905:0:b0:694:8ba4:e3bd with SMTP id
 006d021491bc7-6948ba4ed63mr13751317eaf.36.1777109554897; Sat, 25 Apr 2026
 02:32:34 -0700 (PDT)
Date: Sat, 25 Apr 2026 02:32:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ec8a32.a00a0220.1901e8.000b.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: lock held when returning to user space in __pte_offset_map
From: syzbot <syzbot+2e8b7c8cf82134e81378@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED3B8A0002
X-Stat-Signature: fs8brewneftcsm6dryiafcgoquub1e64
X-HE-Tag: 1777109555-559000
X-HE-Meta: U2FsdGVkX18Wjkk8+ZM9ytrDl9mYmulDu0SHR3CnZXf3AQM0LHrgCEXBJW7Sd65eR7EMk3/rLcsQhJEC7GFWlCjHGfWT+oLxFFUyxyfyfCTh8GGOrtxmF+ed9gGWm2aMXFnOfuGY3P0wqFzJ0itQBmzADJ3kQPrmC4tN2ijR9rAsZwPR4VuhpyQc/fKNkxtw1GhRGm6UnBf3tN6UmN0dRM1oBseIKYDcquwYHM/K3yRxtfhR467lqOj1l4sENP46pnapduG4nOAjhQCjPLyJQugti1mzJqLU2CX90vx50iJ3ofPdJIUphut82AvZgFJOdt6PkzEKfdA64KKRKd6gqcUyWd7xyb2NvKqnbLfSmw2vbgMMoblGmy9zSCwN//ZBVaV/1LxMhXIXW/V9jUDUFpnCi3R5EGNr1Mqbbr1pShA4r2xyLXldJJJZVNg7gOy7mMRCFislbjmMJBiGj9GvHYi3sp7nSD5Sh6ZhFkWzOLkJOGTZ3pmFSzQKbpKtW5LKDqaB170smBBvM0eX7xITo4hpX/wD3wBDbpFemzeFKJJwxxCeym3aNBfQ/gmlGQhfgNu9aqYNJgkDC94nSS6JevYdvkYPudd8lFcNXbJ1rdAIGVC+yzYYug5HdXUnx4cRakTk080DtOgEVKb1stJYeiHC7CDdq5wWu5eRj4PWTbLHChudW+btuDF7dEUUsR6yfWSFnyhFHzgrlkFph0jyLaV4lKeR66bHyzwGzt6jpqFZ6hpsdDrEP6K3Et9mRGWngcOQn41Bmp9Gtl1Dq6H/DiN0rnaFO5kNvObI2vyy0WcnWEVZy2LPlngOpvrYx3jAwp0JF1jBgaqXJ8WNfUYx1vTmYOqip5rfe3odqkKYkrSPrWS5o1s+MFmQOby787ldrS4qI2sHvACUVZiAgOLIMYO4f6hhkz78MlFt3nSzns8A2n+QCMiLPNUECE2iUw6UardDvB2rBTikZVvhj4F
 w+bg+TGu
 xQwWM9TuBd+G82rZzn7onlvaPhkU/KQHZQed+ZlSDNHhd2BpFIInm9O46HgV84WlHfA2iOZcZpP3wh3ng3RF47mskjeXNZjQSok+tO7Su687dEpsQCHknqSwcnQpr+WdOzKMBfowT+CVZN4uDZrhFbLF0gjTKdE1+vvAGIN5vm9D6Kt+8nCHo7qlBIAzqAzJ97lL4wQMPz+aFLCrqUKELpRS2bISDp8Z9khZMqlEQW9XoMRfsNHcsX7omc5vAMvg9D9qBWCwr2hv/Iw/5Vbcqid8U2sV0bq75LzfjB/LtwIhFiKjXpltTl3BmBUJcKj/pOHeZPKJNuaZwcShIeI892uASsWlwHWjNFaccBoV8aa281WobrdARReFpeOLAF5PAFk6citZzdGC/oJhz3/GcrKXr18sIvaQSqoIBd+O0uLzKX3WU7ZeoqHRotwZ1dyStZQEZ2X/A2ojDKAzW4UfqeshkNlBfySwPTZOqF1ICYr1tvkzRhz1zWb//qv7HJXJ+ZjjCxDfbuwhvGJCiduZvr2FwALtV3rjaW/rsGBM+QpDFAKDg6WRTpGvffOA7+Kyn/d+Mg1VB8vK/6TCTAKtfQ0gUvCtWKK7JKYhNzgEMFdWyUz0p2x+UyssKFzoCqHbd5J1U5TheLnYad5aSjiTKKKsZFZn4X0/Gnl1vUBvAJzD+kt1aPwLYSEsCqnV4WpvgB8noCNfsBHL+N/+6eluxV9Jjt9OncMuMxFghc3rE/D2RG/3ocQ0x6Qu2EGoNDCJs3FWQK+tv8c/Nbu8ev3yg2/gItSnUxQweQKfUEkLfX6cAaN+yMkZH/+qN+UkmGpkkfo9UZzr6w6w5P4GQC+90fh8GPQuPeRQK7HWpKq0enrnYoh19Y2reeApmSZ31blvcvMpafvVWaBBlDDM5kDhdPJ5nB6dzz9Ygt0qTvXvD46HIxzJDyOmR95yAtG1YekuCLK9HJUEZm35AAtOR2wE9jKE1ZEv/
 7iTDplTG
 wb7ZxKxxiFdWGD2i+krgA7xSqyiAegtl10Li0r93thLBM8XIhbaXislF6ZxrgbfhdGdnyJO4j28iHg6XIl0Iany1JOkfRrdFIOwaAKOjYdWmV/Aa/2t6RmeNGxD0eoAOySmpQnL+b8Ys+Bbl23pxYsjw80S1KSpWiSlJBXP8TdYfChVovckLOcPerMIOKOYIgG6tVMqaTAjKTf8a9jPE9GOt+me27y7vc/yJNKNYWrMqcR0jZYn1EUnhlQ4OkDbpdbFfek+qdk3htDAptU7UKKRkOGVyBhgpAit9m2C1u0q9JbHPOBMJ2txVWi9fjTZkfsxvqsjEYUyVJGuvv0hZ42GC547qlrxWqi/yTuiUJmBTcsjX9bAW6JxQ8qjZL+rnAxD+Fzr0DpKz+1krUgPc+2LxbMZC4sDt1kOkwVELuYAtg9ZDJpZxV2JLCRpa/lLZzBzfDvuEs4/qdHAxsAkzpOKEAaHpgKvh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    dd6c438c3e64 Merge tag 'vfs-7.1-rc1.fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=145bec36580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9f32dc64d6a2f2
dashboard link: https://syzkaller.appspot.com/bug?extid=2e8b7c8cf82134e81378
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/926b34cf03cd/disk-dd6c438c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/020eae7c763c/vmlinux-dd6c438c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f652b84678d/bzImage-dd6c438c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e8b7c8cf82134e81378@syzkaller.appspotmail.com

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
udevd/5800 is leaving the kernel with locks still held!
1 lock held by udevd/5800:
 #0: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x29/0x200 mm/pgtable-generic.c:290
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!
WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0xcac/0xf40 kernel/rcu/tree_plugin.h:332, CPU#0: udevd/5800
Modules linked in:
CPU: 0 UID: 0 PID: 5800 Comm: udevd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:rcu_note_context_switch+0xcac/0xf40 kernel/rcu/tree_plugin.h:332
Code: 00 41 c6 45 00 00 48 8b 3d 21 24 e1 0d 48 81 c4 b8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 bb 5f ff ff 48 8d 3d 24 e7 e4 0d <67> 48 0f b9 3a e9 1b f4 ff ff 90 0f 0b 90 45 84 e4 0f 84 ea f3 ff
RSP: 0000:ffffc90004477b90 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff888039ac9ec0 RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffffffff8ba73c40 RDI: ffffffff8f8f4250
RBP: dffffc0000000000 R08: ffffffff8f8bd1f7 R09: 1ffffffff1f17a3e
R10: dffffc0000000000 R11: fffffbfff1f17a3f R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880b883c800 R15: ffff888039aca384
FS:  00007f74fc12d880(0000) GS:ffff8881260fb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055de63bc0d08 CR3: 0000000031232000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __schedule+0x291/0x54c0 kernel/sched/core.c:7043
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7282
 __exit_to_user_mode_loop kernel/entry/common.c:54 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:252 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:323 [inline]
 irqentry_exit+0x263/0x730 kernel/entry/common.c:162
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0033:0x7f74fc8d1a9a
Code: 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 53 48 85 ff 74 2f 48 8b 47 08 48 39 c7 74 21 48 8b 1f 48 39 df 74 19 48 89 18 <48> 89 43 08 e8 8d d9 ff ff 48 89 d8 5b c3 0f 1f 84 00 00 00 00 00
RSP: 002b:00007ffceb76a200 EFLAGS: 00010283
RAX: 000055de63bbd0b0 RBX: 000055de63bc0d00 RCX: 0000000000000000
RDX: 000055de63bbf070 RSI: 000055de63bc5ae0 RDI: 000055de63bbcf10
RBP: 000055de63bbcf10 R08: 000055de63bc5af0 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000297 R12: 000055de3e623588
R13: 00007ffceb76a2b0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 41 c6             	add    %al,-0x3a(%rcx)
   3:	45 00 00             	add    %r8b,(%r8)
   6:	48 8b 3d 21 24 e1 0d 	mov    0xde12421(%rip),%rdi        # 0xde1242e
   d:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  14:	5b                   	pop    %rbx
  15:	41 5c                	pop    %r12
  17:	41 5d                	pop    %r13
  19:	41 5e                	pop    %r14
  1b:	41 5f                	pop    %r15
  1d:	5d                   	pop    %rbp
  1e:	e9 bb 5f ff ff       	jmp    0xffff5fde
  23:	48 8d 3d 24 e7 e4 0d 	lea    0xde4e724(%rip),%rdi        # 0xde4e74e
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 1b f4 ff ff       	jmp    0xfffff44f
  34:	90                   	nop
  35:	0f 0b                	ud2
  37:	90                   	nop
  38:	45 84 e4             	test   %r12b,%r12b
  3b:	0f                   	.byte 0xf
  3c:	84 ea                	test   %ch,%dl
  3e:	f3                   	repz
  3f:	ff                   	.byte 0xff


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

