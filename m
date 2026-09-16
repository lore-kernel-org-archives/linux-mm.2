Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62365C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537956B0088; Wed, 16 Sep 2026 10:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEA66B008C; Wed, 16 Sep 2026 10:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D69A6B0092; Wed, 16 Sep 2026 10:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5866B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:08:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98ECE14074F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:08:29 +0000 (UTC)
X-FDA: 85219805538.11.918CAC0
Received: from mail-oi2-f10.google.com (mail-oi2-f10.google.com [74.125.231.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id E04D740008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:08:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 32qKqagkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=32qKqagkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789567707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=htUCy0q7FG4YSd/XI01PpxHhl9O1HtPtmWa1pKHUGLE=;
	b=WL1pyru/yGAlq+SUEjwSqeG5l2roM6X3yLR0YhWW6IGXBiaNx1QSYWEDoPXUYSpGCBNxwh
	bezvbNnSGmiSZb8/jfIrGIGGLuWQ7pWxmx0TOIlNKeAtbgWCkT4nBsJih3dHYHs5KQ7ZRr
	M1JAyegebWPpsoPe0TZ+oJ98Exic++I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789567707;
	b=cS6TqCWJHhNEBB3ab3MuMXATsPqAjf9hbjw6IsUkeZ9aeFaMMAyL4t/DzSkuIPP6nuZscz
	SROq/5jrAM6xQxo4ACqiE/J1WldAak1XsoL/KlVzYdlSTYxsmfMokg+N/xQbXE43fyDS0G
	QLJHqDZLOADamTl6LwDJEIXYDQ1aTs4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 32qKqagkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=32qKqagkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi2-f10.google.com with SMTP id 5614622812f47-4b94bb43008so924854b6e.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789567707; x=1790172507;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=htUCy0q7FG4YSd/XI01PpxHhl9O1HtPtmWa1pKHUGLE=;
        b=gvnJNzFBqXkrG2hu4jQQUlVkkq1zm6g1c5psNt0LNEgtPJERpJwdyZcaS6PhgT6yTF
         e15je4v6DYSdJaup4jU2w/1732gvd0dXkF7g+eOoUDIKGjSB0Ocqdf2tp6gkESurTGkA
         HiF3rSdsx/sDXx/3OPzMSjLIE4iyPmC/ORXj/UleipCIGtQDny274Wl3Uo0MIrey+c2x
         q5VkReSrUvwFTqAUADtauvq2EnylMe/an4OXb9tbZbOxcGZ2yuHB4RLZE0mZkiMlmNQ4
         fkMiahllk8+kfFUGmURwJ7pspir/3YbUDOkkemKnUbz6nfQy7chH6TFSj3za9GyK94QW
         iSYg==
X-Forwarded-Encrypted: i=1; AKwUvBwJvG/UcJaz66rnaGtJEsLgWW57RcAnqEfv1aXTVuLp3/6p/VCDHPsiSYhM576vKE5qapK2ldOvuQ==@kvack.org
X-Gm-Message-State: AFuF++nisSQ1MO51jm3XkpbMKZOBKfePb1oOu4WqvqVzNZR9eG2J6UY9
	CMUmkBqqfzXZ7aFV8nCJLE8Xg1hmtsXo4P9AWeZkUWS9GAaGY+TnFJizGZiUebZKEo1LdI7QRGM
	OwHG3ZT7l+REazPjZweWxVgLH8CWT6Ijsc5M909L9wyo9N79NKP1jdNxNR8U=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81c9:b0:6be:4eb3:e1c0 with SMTP id
 006d021491bc7-6c7d3fe744bmr2517440eaf.45.1789567706922; Wed, 16 Sep 2026
 07:08:26 -0700 (PDT)
Date: Wed, 16 Sep 2026 07:08:26 -0700
In-Reply-To: <6936812a.a70a0220.38f243.0090.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaaa2da.86093f18.33004f.0001.GAE@google.com>
Subject: Re: [syzbot] [kvm?] BUG: sleeping function called from invalid
 context in kvm_mmu_notifier_invalidate_range_start
From: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bigeasy@linutronix.de, dwmw2@infradead.org, 
	dwmw@amazon.co.uk, kvm@vger.kernel.org, liam.howlett@oracle.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, ljs@kernel.org, lkp@intel.com, 
	llvm@lists.linux.dev, lorenzo.stoakes@oracle.com, me@brighamcampbell.com, 
	mhocko@suse.com, nogikh@google.com, oe-kbuild-all@lists.linux.dev, 
	pbonzini@redhat.com, rientjes@google.com, rppt@kernel.org, seanjc@google.com, 
	shaikhkamal2012@gmail.com, shakeel.butt@linux.dev, skhan@linuxfoundation.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 557hbanbkuon16zbxaywtg5otr7sws4z
X-Rspamd-Queue-Id: E04D740008
X-HE-Tag: 1789567707-178999
X-HE-Meta: U2FsdGVkX18mDBUIyQrYKOcK7NBGHQUAJhsHoSkn9MpuwKKQdt4AC5W34nHnPC7tnPEj6KFwrd/zz9X2uVBw3cULHgPsbaXP+nfwoP0j6twGb2pKzDB5O1Jk/EpwpdVfpkIVZDtF85udDHOHOpkNtAVutym/DHNwEo6oxsu5GqTqvBGba1BFeS6jVN2aC4TaMLuSS08ObTZr5suuEN0Eud8Ob8Y9r4I66xRulwVJFhso6uvEvltnw5LIfRrD9Jq4SeWJLi93S9G2JdMQWxi3wYuRXU0tRVDKYfD+Y55fqdODpoKZ9TCUtJ7B1wmiPbytfxNPDY8NpqW0jkJVYUUFOGuKQdD8SSrLJ29H5eZ0cNmQLLwRf61CWFk1pNVXq3V//acmM4oyPaiyXVUyZN6sC+NByDhxujpbi7NfJhrVCGiy6KlKMCu1xtBD+6YzNXK6z6oteL8Ggz+T61dD39Fhsnw/WzWylRxSWQXKNOLEMQrKE1fYqCsSB8kJl0ZKaKZ4krlslx8lVQTvTpXBqg32l+SAnXloUMc0HRLTqW4uVNj6o9zBdlkP78nN8lQVzAvj946WJr/WxwsRZPLHQAbmRYJYbJTiqo34Db18+U2BMFNyhXWt2cYwWP9ZEur0Sk5gT2VYukuVF3wI0Bpjt3Qa/ibQKYAkZuMUTXuUfPMoviu9hPzQh/1OatYTjRgVW5A1uWYL7nbvhjTMwYJ9WCJYsj+pvE2bIe58AjPFbkY34uo6XAEolhZLddrBfmoPVrnn7Gfvm6Avnav8cYIIAQxXcRTH7JFjyKuXkZljTz5bqLR26hvf4Io1GC1oVmfrAJreNCj/8BxeZTtuDQbf1wTNDZbOv55CWY5BY68io7khD9+ZAHP7Y8ZOw1Ajv+oFtEbFj1Jd4sDvVGE1LoyWOSJvoKg03YWE6U3yLe4KPYpMn3Zj2w97jVo/0zHXqUKRqoDQDxaCDA2LzlrhbJ4CTS7
 bR2j2fqT
 5UkNrbhbDmv5NBTYs34vlSuF7Gcay1qpe9iK0fsssysi+j6FGOYTBd7+WYIe13CjeWhIZrL00DAjjJw3AA364tUz6qE9WoJkp/JqIsKJlynlSLI3i9uHp7sQ0pHW+rQCrW7pDTIBGPZgnV80HdGEFcuyktBfqg4DYUJjWHqU6B9kzqjG9BeuYjCo2tgct8ZY/eY4ewi7IzlvwTpDn6SQRl/x068vSoNq6pl7hOcJCgdOxhkcQGoSPfx9MgXlfLPz9RACGIUePBbyVlaCWLsAnlpQfPLpfvN8rOL+V9855f4mNOoWV5JvOwGiXtY03cL1HVP/cliGe/Fo/dup5BfJkD/UuyYZKMOcDOBalMBbVK3wnQ/o+CFQpwNEu/dPthn6VmketSunYTokfvuYGP+OhXD00Xei+0QuGarjTfx5KH5u8f/MuQRzTkB29BssV3JkopLUucEssVE8v7tBnNJ383cQ/pYe4PMM91EzgJ//WTSvAwNLM9oOQNKckaRJm2aY6H1mO+5/zYEKg3mqqY4tNMafjYDY5ZRWxbz/40riozgIGOszB6IXcfC+01y1Q8qoWaNEZX2KMme+/qPYQKN+IL98IMbPiZOXLdJk0NW7Iafn9fxtTTxK9/ZMpBSGosZKo7TNUM0jo9jvpHidRFYktTmgMm1XWKDcqwPZOU18q0O2b+txxQvlDgPdixh4BTdR3hB7Vj7y3rnh9vZmc+N0ktww1Qr8VEXHnH8wLPFtR3OLlhiDtlRuGj56GEesmBlFXJKgmE0oK0RoIKUhQKWftiEwFiiTRt0rueZ3C2HEfkVhCLsTUtaevPJjnq5+fwXmJ5AoGMLXYzxRnEEIeiUDHvScmm3XuQLZ+bSXngCXVZe6PsRLAIlhEIun0o4fBBocsk8QTYedfT31awzuDy4xUv5tNybYAFapnp2jSJG3wKR4D8QLC+wEOFHslNiLoIXQ6RCPYUlJrmMyCu1opD9JAUrjbeTuu
 EKdcEBEm
 vo5JegwuEglzfi+QEJ28MV46jrvvjrgLIyhgpaqjRQ9rugD5y7jWS9+ZrGh+EnyL7w6k9gQTJfcMpSfokhD73QnCbO6tCb8FM3AjcNmft8lH9ZrApxmBanikDwrHFTaY+B6XoAdbllvr91CSugxryEYJwXK0a0l9K4VogE5JjpuzvPLTqR7uewsaUzK2mjbTLorQyNehDgg76LLJ+LL+DLZnV9RzkuRKzxuQ0r/zBNIS7JD5dm/xXO7vFZrENxvq12hBGKL2RLlb23JLy4XDL8CzTsVxprGQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    9b87fdc9af2f Merge tag 'sched_ext-for-7.3-rc3-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f46bf9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f23925580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f23925580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d9d20c79bd3c/disk-9b87fdc9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a6a8f176798/vmlinux-9b87fdc9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db8864d1c812/bzImage-9b87fdc9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 38, name: oom_reaper
preempt_count: 0, expected: 0
RCU nest depth: 0, expected: 0
locks held by oom_reaper/38: 4, last CPU#1:
 #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:619 [inline]
 #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task_mm mm/oom_kill.c:566 [inline]
 #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task mm/oom_kill.c:609 [inline]
 #0: ffff8880370147b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reaper+0x2b4/0xc10 mm/oom_kill.c:650
 #1: ffffffff8e30af80 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:495 [inline]
 #1: ffffffff8e30af80 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: zap_vma_for_reaping+0x193/0x380 mm/memory.c:2266
 #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:198 [inline]
 #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:305 [inline]
 #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: mn_hlist_invalidate_range_start mm/mmu_notifier.c:515 [inline]
 #2: ffffffff8e30afd8 (srcu){.+.+}-{0:0}, at: __mmu_notifier_invalidate_range_start+0x5c6/0xb80 mm/mmu_notifier.c:580
 #3: ffff8880465ad560 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #3: ffff8880465ad560 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: kvm_mmu_notifier_invalidate_range_start+0x1b6/0xc10 virt/kvm/kvm_main.c:745
CPU: 1 UID: 0 PID: 38 Comm: oom_reaper Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x31b/0x470 kernel/sched/core.c:9257
 __rt_spin_lock kernel/locking/spinlock_rt.c:48 [inline]
 rt_spin_lock+0xc2/0x400 kernel/locking/spinlock_rt.c:57
 spin_lock include/linux/spinlock_rt.h:45 [inline]
 kvm_mmu_notifier_invalidate_range_start+0x1b6/0xc10 virt/kvm/kvm_main.c:745
 mn_hlist_invalidate_range_start mm/mmu_notifier.c:525 [inline]
 __mmu_notifier_invalidate_range_start+0x709/0xb80 mm/mmu_notifier.c:580
 mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:498 [inline]
 zap_vma_for_reaping+0x1f7/0x380 mm/memory.c:2266
 __oom_reap_task_mm mm/oom_kill.c:548 [inline]
 oom_reap_task_mm mm/oom_kill.c:585 [inline]
 oom_reap_task mm/oom_kill.c:609 [inline]
 oom_reaper+0x519/0xc10 mm/oom_kill.c:650
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
oom_reaper: reaped process 8617 (syz.2.1028), now anon-rss:0kB, file-rss:72kB, shmem-rss:0kB


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

