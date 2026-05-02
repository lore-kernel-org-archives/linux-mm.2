Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA8ACD3423
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 11:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922E16B0005; Sat,  2 May 2026 07:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB0B6B008A; Sat,  2 May 2026 07:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837DF6B008C; Sat,  2 May 2026 07:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 768F96B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 07:25:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B281A1C0533
	for <linux-mm@kvack.org>; Sat,  2 May 2026 11:25:35 +0000 (UTC)
X-FDA: 84722249430.30.22DB164
Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	by imf12.hostedemail.com (Postfix) with ESMTP id D63A940005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 11:25:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3LN_1aQkbABkHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3LN_1aQkbABkHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777721133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=HtmaSIHLoot0vOXzcU/27GViHD+QoZG2kMWciMiygUE=;
	b=B8Fptkx0SE1eqV1NteE0qmojxXFpmLjPS+wW0HtgRrtudFtAEa5jOXjYTzq13ya7m5hs1w
	m0+5qupUg3X8B5cxhiFwhhbiPUtvTIa8N3g17avsNnhQt/ZQEqpBsFunsBw/s3PZCyjtBv
	ldax/fPGN7XjyDjsHSh+lA4WdI5DTI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777721133; a=rsa-sha256;
	cv=none;
	b=SqXcDvFdOk882yO7Xy4QWOY2FMj53j78qMRtNuRfOeFEUTnkG/6VgyVWcir3S10lIEELmp
	SCXofske1Kpb+dX9E0LNcVuvHx/a0RiVUtfqj3mly7eRIcQgnPxLbo3Dd5PRMzxL+pCT7r
	OxtWdlerTvsezArY+3Ifk8L9zCVProo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3LN_1aQkbABkHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3LN_1aQkbABkHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7dbe0e914adso4867119a34.2
        for <linux-mm@kvack.org>; Sat, 02 May 2026 04:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777721133; x=1778325933;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HtmaSIHLoot0vOXzcU/27GViHD+QoZG2kMWciMiygUE=;
        b=QwuID0O9txEsMTz/K1d7zRKFLksy5Yhn4LZFn04gOB8FyQaPLNShBtzmwqw6cPa4Ah
         B7J2Df3iarxcTRU620BCHQGc4TM0rJsdFlnmVCNnVzsmgq62EIts4OvhqVPmwGuJ0Po6
         Wcu4AfYTfZK689WfwDT0pLF7Dy7nsMEts5o684d8ozMN02o8jcB8LC6JyyEuPRd4VA+N
         ThNW5vRczAPwRzGIBL8jnBmvvAErJH/MqK4xeNMMlF381whmZeMuOVSbPFfkLQUGu/+6
         S4PY787Qb87AmlvD5mNgNzR5ByQxefDtqQf4q6t2odpii1QOjvGhjkLFG4QFwAOyCv96
         rwAg==
X-Forwarded-Encrypted: i=1; AFNElJ8Hfbb5hiXVvytoaUDiE+n45baHi53jUemNkvybEkVhw5br9ZJDTh37CGQowi7UgxOKwSP/lKTpYg==@kvack.org
X-Gm-Message-State: AOJu0YytzBkxyxYSuivctjiMbeFR4olRYivk8gS0xJuKkEn2ZKozU8tr
	FoE5hpge+NKGcoD9Hk4PwTrYk9X01WYCicU0ZnF6du3mCfuenOaFzXWlP3j83CGwGWNWIvBM5fq
	PvhlqhV9+l8v1dNtqNgHKxfgmhGWMJhipDqPoCwMp3AZmCsTyb2+emoYRgMc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3109:b0:696:6440:9e33 with SMTP id
 006d021491bc7-69697d89d8cmr1270626eaf.43.1777721132959; Sat, 02 May 2026
 04:25:32 -0700 (PDT)
Date: Sat, 02 May 2026 04:25:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f5df2c.050a0220.3cbe47.0017.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: bad unlock balance in do_fault
From: syzbot <syzbot+c4f59f1ba89c777b77d4@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D63A940005
X-Stat-Signature: oqmfqq1fqyahj8fgqkdg8jnud4mwm7w7
X-Rspam-User: 
X-HE-Tag: 1777721133-664880
X-HE-Meta: U2FsdGVkX1/Fxzves0KicvoJ1+j9rJSLg82YSKdcYjlJGAR+OY0AZHdE/oEqFG+ObOS5cQISipkvncfYZRROusmZT5bvFjcSpxDpSh3mc8mHorI+yVHrw//OQN5k/EK7KjOEhn+c5bmZ94foom75w2o0MeZ6TJW36WLkGbwMQ2otHpgGY9w3gbSHzdQZkQvWfuJsVI0L6WJluDasSOCuRhL+xvVIGy/z1DQfZzH+93HjA4T0J9qjVEOgYPoqrcX+1w+nsl9rZo2q2fCG4unWDxad7pvk2CHCFynoAYrg+Ntb0jjbTJh4zkW2t0R8zgcr3h1lq2hHVamatqBRNj7RjmAJBEGFM7q8Dhd3Pet7RQsDKAApfXFtoQSQBK7BjQX4fL6VEsO7etks6FI9YbmU6ljh0ULGzObg6fvb41NQUVlvXn71No23Ax10wisluIvS42kc1KV/StWXKgDFHCIbrZuG3cPXy8pKjf77zpru+kU1CAXpGWnD9x5lwMvT8O1QwuzlvDRO8RvOlBBYiENe/Jg5z9NPf/BmWU4XrB38L+FB99K56YY2WOpSdHzEAN8ALq0KSeJ9noaKG83/bwiXBNSOEElIzgDsR7X9kxnVySCmbdw2N9GdD0Ym8GDBkTyWdWKNkNUs8dw3U1wTWaTrxzki9gCAh587PqXCrS5e0ycJ76foKMPdHSJbQKAmFr4imODaz51Nr8M+moHnz5FyqeExoiNZIAxnpQ9YzCdGb6/adQbR+jBc7gGixXbKP3FDqa2xf2iTdhzFODv2M8XEc1L5vGgAh6G5FBqQo7COppQWaUXTWjbFsFEIqWZmzBz/EU79udddYzFaZ+VJd5W9M0wX29W5JunGEoRy1EchXjcHLr+Oco76ZMmS8HWsWoHWbsrqr+DsOMNhs25seO0czy6l6g9+96KMyaAQEQXfPpPG5D5FhH6NcgP3NyMs6eppUubWLgviIE2OFMfuIt+
 /MYUMhWm
 qyGNiJFDz2yDVJ1Y44zHQBl00Ux1NNBzSXPHU0GmsulNlHgJu3dy1nxYpt/DszbO69QwXQMDB8Eo5RqD0k7O/c3pELgAKjsFOl1EMvgU73viLV3jIqu+mf49tBrxFFyZieiqrzJES5GT5YpUl9sTJ0VwwWdklPNpyPLKsWSB5eR+BCn+q/keNlYTkvAtY9voxXjTR+H2ck5wV5MJNb5PRonbZbI4tPxW4SOWPlTxBwW7ARECATzUesZ60PBaKrfTDl5z0xc1XbRt6l97fzMiDGYHFk87kvHJU5/7A8uHkjv+LyTZvXD4B61Cdt9FDbcLFsv1vYUtPImF0JMmc37OVafwU7ie7eMez6PlCLiurMJTFKMpk7ywYnakbOiuuP7iNZd7reEzGwoTXTSvoaWEuOGkiuoQiI9399gMliY0NO59VC49ncKcq9FKxxGlbIkD+/+iH881+2qbmw3l7+A5HOC/HacA1EaCMrNqINsI3OTmf2SQgdgFoK1P8u1aoWfT9lVluTlwp3ptI4Lq3HajHPv8f8M+b4opT81KH0alBKmB3tTXhT6XXzQ3JMoJoHS4wi0UTAK3XgMZuCkpy102yKo9vFWoPEU9xzCGTokqpr+lTpCu/tQYxAbazgodZOKcW4/qUaOBdGVK+Ww+/NxSk8DEDsZemcQRkTzyI2AeBpLUqJyDuFp/BOtQYUEJV00cJjBrdlmg9qI0e+3fMYOfklNrm83KrA3DYfITT1nce19pbfE5TduzLiJAfBNfOhQm4dYcNV0CJZzsL3bTq8y6tFyIoU6m+AiENwqb2mUjJg11vKyHJmTLSuBfGL+TgxAQs9YQHKjODRE8aVonuwgJv/1yWtC4QnoA6kIKpdEB/MwPjlVyeWAowONmyvQu12V1prEycWyE6TBa4BH0fGWwADja1nNDKStbvpCSx6PpoIPkzdwYlKpwjuyJyyx/SPRxD1yQsT57869iHsk1c/2eRp3Tyb3EN
 83ECdq84
 AetFyPshcKvRQb7zw5qnMU9Jbjlssn3waIa/H65BxEf6i1a7YR2PVKjQcUQ3E5QbtZ0ieIfOeK5kNkjiHpVrAsuVs2jGa/rRsItgwTEGpZHJuRwPXSkGWEgVShsmxvU2aqAwefncUj3X4RzLY5oFbjDBMYVF6kP9KR15H8w/rEDOEFGoXcIqRQowts0aUiRhsAmi/NIrty8aLz29sewMgE1clLqqKjeh1mww5Wt9ejLk1EGGBjvfDwhHPbzN6mNCXvq46fdyToe1zWiKCxc5e4nAOJqZiIBH3142WTBz4FTtlntkK9wIHRy5IyYgMSgBSIHQQEz+d8J8ukBfENYeN8Ed5lhOta5Ssf4ZdQh2ioS0wS1CHHIkRUDNVCvlJHhGMD8LrKMxCNBpsrjNx3vTNzrJ7uqUkzGATsInvsxEJex3IZHVdgP04AuZ61ioAlI7e9xblPOlh4Xc44+m+eNnju3UnTQp9x24
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    3b3bea6d4b9c Merge tag 'cgroup-for-7.1-rc1-fixes' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11dbb326580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f0911eedbc130a
dashboard link: https://syzkaller.appspot.com/bug?extid=c4f59f1ba89c777b77d4
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3b3bea6d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/90f65aee39f9/vmlinux-3b3bea6d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9c44f0af2bac/bzImage-3b3bea6d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4f59f1ba89c777b77d4@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
dhcpcd-run-hook/5691 is trying to release lock (rcu_read_lock) at:
[<ffffffff8259a4e4>] rcu_lock_release include/linux/rcupdate.h:310 [inline]
[<ffffffff8259a4e4>] rcu_read_unlock include/linux/rcupdate.h:869 [inline]
[<ffffffff8259a4e4>] do_fault_around mm/memory.c:5854 [inline]
[<ffffffff8259a4e4>] do_read_fault mm/memory.c:5884 [inline]
[<ffffffff8259a4e4>] do_fault+0x9b4/0x1750 mm/memory.c:6027
but there are no more locks to release!

other info that might help us debug this:
1 lock held by dhcpcd-run-hook/5691:
 #0: ffff888024e92a88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310

stack backtrace:
CPU: 3 UID: 0 PID: 5691 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_unlock_imbalance_bug.part.0+0xfb/0x106 kernel/locking/lockdep.c:5298
 print_unlock_imbalance_bug kernel/locking/lockdep.c:5278 [inline]
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release kernel/locking/lockdep.c:5889 [inline]
 lock_release+0x28d/0x310 kernel/locking/lockdep.c:5875
 rcu_lock_release include/linux/rcupdate.h:310 [inline]
 rcu_read_unlock include/linux/rcupdate.h:869 [inline]
 do_fault_around mm/memory.c:5854 [inline]
 do_read_fault mm/memory.c:5884 [inline]
 do_fault+0x9b9/0x1750 mm/memory.c:6027
 do_pte_missing mm/memory.c:4550 [inline]
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7ff2e82ebfeb
Code: 08 48 8b 78 08 48 89 13 e8 5e f9 ff ff 97 e8 bb ff ff ff 48 09 e8 40 0f 95 c5 40 0f b6 ed eb 04 48 83 2b 08 48 95 5a 5b 5d c3 <55> 53 89 fb 48 83 ec 18 48 8b 3e 48 89 74 24 08 e8 a9 e7 f9 ff 80
RSP: 002b:00007fff321b8cc8 EFLAGS: 00010287
RAX: 00007ff2e8336190 RBX: 0000564f23c56910 RCX: 0000000000000002
RDX: 0000564f23c56910 RSI: 0000564f23c5f120 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
R10: 0000000000000040 R11: 0000000000000000 R12: 0000564f23c5ee50
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
 </TASK>
------------[ cut here ]------------
rrln < 0 || rrln > RCU_NEST_PMAX
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline], CPU#3: dhcpcd-run-hook/5691
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430, CPU#3: dhcpcd-run-hook/5691
Modules linked in:
CPU: 3 UID: 0 PID: 5691 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline]
RIP: 0010:__rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430
Code: 74 11 c7 45 58 01 00 00 00 bf 09 00 00 00 e8 92 a3 da ff e8 fd de 22 00 9c 58 f6 c4 02 0f 85 dd 02 00 00 fb e9 57 fe ff ff 90 <0f> 0b 90 5b 5d 41 5c 41 5d 41 5e 41 5f e9 d9 f0 9c 09 e8 84 60 87
RSP: 0000:ffffc90003f9fbe8 EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff88802a16a500 RCX: ffffffff81e7203e
RDX: 0000000000000000 RSI: ffffffff8def466d RDI: ffff88802a16a9c4
RBP: 0000000000000100 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000012 R12: 0000000000000001
R13: 00000000000000e0 R14: ffffc90003f9fd68 R15: 00000000000000f0
FS:  00007ff2e7fcfc80(0000) GS:ffff888097480000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff2e82ebfeb CR3: 0000000050d47000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 rcu_read_unlock include/linux/rcupdate.h:871 [inline]
 do_fault_around mm/memory.c:5854 [inline]
 do_read_fault mm/memory.c:5884 [inline]
 do_fault+0x9be/0x1750 mm/memory.c:6027
 do_pte_missing mm/memory.c:4550 [inline]
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7ff2e82ebfeb
Code: 08 48 8b 78 08 48 89 13 e8 5e f9 ff ff 97 e8 bb ff ff ff 48 09 e8 40 0f 95 c5 40 0f b6 ed eb 04 48 83 2b 08 48 95 5a 5b 5d c3 <55> 53 89 fb 48 83 ec 18 48 8b 3e 48 89 74 24 08 e8 a9 e7 f9 ff 80
RSP: 002b:00007fff321b8cc8 EFLAGS: 00010287
RAX: 00007ff2e8336190 RBX: 0000564f23c56910 RCX: 0000000000000002
RDX: 0000564f23c56910 RSI: 0000564f23c5f120 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
R10: 0000000000000040 R11: 0000000000000000 R12: 0000564f23c5ee50
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
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

