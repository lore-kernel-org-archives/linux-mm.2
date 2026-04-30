Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDB9CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815096B0092; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA726B0096; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663186B0093; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1C76B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDBDE140466
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:21:37 +0000 (UTC)
X-FDA: 84714377034.29.003BACF
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2EC6E4000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:21:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777533696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=tj5be/vz078Ksw2i/CCD9yJb0B5aXAIaoedvEJnz1N4=;
	b=6GZ/xSkv/PxqPpJzJHIwvjm2jaZzSSyfaAUxoqQR2oixV6T/4dlZCXHXziulW0TojGnNt2
	JGU7/4YKrYfIiSNiJVPmpSpJvcHIPLbAfla+T8du3kxcroMoyW+uJvwTedJ2ynlvskKe9R
	YUtg4q6mqhzanLmbnRKK+g+FP3wkhgM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777533696; a=rsa-sha256;
	cv=none;
	b=vWneE1dZhOO4hZ952tm4SgFU0l9R730SJiVS2ge8xzrnSugD/pr0HnoMTM4P2XJXCZyulQ
	Obiw9wA/l/BiK3XAFbElB97X+xFmj1zyxUaeO5UGZr/z4MY9FxT63BYs6ote9kOfY1WgKO
	UWcOnhamjJ/NVWugI/mgNbkvcaBwZFw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-696307c7ee0so717501eaf.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777533695; x=1778138495;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tj5be/vz078Ksw2i/CCD9yJb0B5aXAIaoedvEJnz1N4=;
        b=GgOHL13Vn9YQK4ps3hvGMCYhdye99QiMOKrygWTEbO6JhH6bStPchMzo0qf6hyHTM0
         corcxRAi/drJ/6bFmogBa+wbunSjwL+yogbA2mzIAuUic2IYhOTGz/c5KbQk0nunlBRK
         yKT6LakBGGV4+oNsElog/0gKGUj8szlLxzi2BJpDK2kXHf+jbbwGOEEzvfCOLun0LGvX
         OCBqYL40poXXym4cr7w64M/xb+GVMYy3XDnZqIvWonhKw7sc/7SPR/bGe6/jBqtd0Xw0
         N4RsahV6Cmr/ySK445wCYRwiGdGX/v90dtx9Tlyne9duT79FuTVDsXXENMlHs3Nnib62
         xtTQ==
X-Forwarded-Encrypted: i=1; AFNElJ+gNa4YmiuptggQUZ5zCYTBeoSRhVcJCmYBkRXgkm9Mtx2yLO0gD2fvAd8q6aAez85HtFwak9jSrg==@kvack.org
X-Gm-Message-State: AOJu0YxnXVgolLfKxb0VFei8AwEOlFNMTmog0z+Z4VMB2QWLvhyl712j
	bg7j3PFQ3IB938FVFMCFuciZ40+D2j5h4dnMMK1O6wTr4el3nYMdhMd6BiePVtAmfkbk5wjBLx2
	jEnIWoi80hMZi9WiCsl3vUZS+abV4wMmaFVv15pWLNtqXGOrnqS7OCASJKhU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:99a:b0:695:66d5:6a72 with SMTP id
 006d021491bc7-6967a6254cbmr761567eaf.50.1777533695038; Thu, 30 Apr 2026
 00:21:35 -0700 (PDT)
Date: Thu, 30 Apr 2026 00:21:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f302ff.170a0220.3c4978.0016.GAE@google.com>
Subject: [syzbot] [mm?] [arch?] BUG: sleeping function called from invalid
 context in __tlb_batch_free_encoded_pages
From: syzbot <syzbot+a169a27b0538ba43e5d3@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, aneesh.kumar@kernel.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	npiggin@gmail.com, peterz@infradead.org, syzkaller-bugs@googlegroups.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EC6E4000B
X-Stat-Signature: 8myd5s1kggpnwbgfnkozhuhe7ewpqx7d
X-Rspam-User: 
X-HE-Tag: 1777533695-512360
X-HE-Meta: U2FsdGVkX18eG19xcvPRo5xB9LZrnM7+2K3XzGofUkLjKUZ6PsC7YSsAjqNvDNkrD6+yCXxD3Z2qCUtlcFgnwft+sHqFZElP+KEdNDrl63KTRYimiZTrvzxWUFsP6KgkRM5Qr0Fw2nduByoga+Rew+uq2LZQdVdAYj1v7Z8yHMprEHPOIibwsHpDFO1cQ9JteV4/B0MbI1ipBEmaQg3BhT0P7vzUi4Ehy/82XNxE7CajE3gqDCCD9CwyHxHfL06ey2O5aRUT2KXm1qNFVOxJ/3F8jfnjJ2huCtRla5RyYgJb1NB4s02A9Z4eulhPNZvAFvTOok2AtArgTteUKFPef7mXTM4zb4VnH2bo7cbNdBwLsIVEoUIo99B8nLFHMdglTWxPGoSNFPDvZuJSHis/h0MiWouxoUfPDePr//uUSvwnr103DGEH1Ljbty1/+UfwvqIM3HRg6m9K7o92J3jFr/VAPnW3XlSVx9nTMZ70b8lrtfD6MrbzQwtPuuCp7a5zTwiwDJ8vKu6xo2ggOTkYMnMSKnQ/xOW9TSVvuQxGNjdecFqU9n5avl9oqfKRCHOKiXgvwgRbkUqi6YBZk9ka7niqRzX938PWpgFVea6aBnFB+KOGoxtdefdj/ZVIva8IIua5r0K5GspQBRKLMXFK162N0rAPXo0bpZ4FO6Hgl5f7ZSZMe7iyfWq0gGLks4g8K9DC8LYjD2BHAo9DIVJ+UAT0GDLWJ8B5KwNaI8fQC1unjD20QyFTYuAsEqWv6ynhwKtvfS15qxdao2B/4WVPNUFYKp3gZg0elkA3PMPALq4QbBlfkaZZOpnfrIfUXiJujDZ6Nj0rIf2yWQgaUm6mBM9YTmvQhY2hNsaoPHi+N4Hm+FYM0cUtBfOTAErq7XS8Goc2Pt5Rnm10l5IXUQBmixWjCnXSFqwoYnMPGJQhvWLvCKUOpK5EVqtg4tJcKQ2dlxAMLhjolskhe6VxTH1
 qGJTAFNw
 rEFfjdgnbeD77AyMokGpiLSWwFbmRDUNhCr7ZnSjNtRPq23ZlaHXQz4qtcYKbyTbYwI4Ye6r7KifRezpx4tbhzx72CjevOiheiiHvlYmuFJlTJGHRkAdMc/PNYhW90zj6ueuBtEZuc/W5kW1ozb1Mt+Hz+P6FfOby8dCPUkBZdjl7CDmbzU1RLXNkSDWkA48Tg0aJbX+o8cV0Sok1e78v8IckEW/U0UUtjOpMMX3EIF4+reyvf13dPg1hw9HXbU2heUz1DJTR86o/NNiXgG1oxC+64/GAST20sal1u42w6j309F20+9yerrryhIGPMqWO07CMO77jHJhh9/Pt/n3l4VmxpGMgiiB95J0uOltH1ywJ/OibOflnrAAZKeMrhgF5sPpqg7C9IMLXlOfqzfscWiH/j37SbCgtdVpLDICg4JTUKQ/oSy/qBwUgmwL72/25QZRPKkFjVZvZ8j7LDzV3G5LDPicgduBP6n/oaiDDy55k5sVK/TT81rIwZrvjSMLxGdRNpyBYv044i9huJt8cT6uv9V/2dVSsjYqnWU1q5glIB3gDISQ6bJW80S+dxYTUSjqQxUsQbhVXtfbltsCVg4TC9YwepOWvAtDUAsEEOvU1rC9WaFs9rWTtaypluj1gsDF2DG7DDHfoh/K5rPKdPl5GtOFpjXLbqD/8fZsgEs7zo8jIoW7HxDuUuUcibCgU1+XPPpLXtHHgrBXkIpcyRIu5bKm304rIjsKDrEY++Mb1SI86WbMrwgTWxMH6lihjyd/BapBjHBZM6B8b1CxQxP/FY4D90zMxK1DGkNlRlDJ5MvQ19JFxn/KIUx0j+mfaoPCx3cCu/Df56qXWb1IKknOWl6Es0fEFo5x+VT3FfEPLkaTJbIAhZGXGOhrsQmk33oJf9m/L4NXn+uNTklphtOhFKCOABEhYvPfp5+eQRUGRKM4YL13Nznw9DZWT3Tu3n7VPXnGlwPMQSQzXOFJ4u+bA3yKX
 H6YrDqQ/
 WaYy7LbFSC9mlw/iTt7ZTHQm6KG5jpgUQJ84o6hfVfTLr5ibLUDlVlGvINDbKmsJmXhUWDVt5jmxwKMOXauX6kLFbksrDCdv1EkQQdc7SnltUvEtkZQxL5Q2JGJyTsHTmVmA3tqs1YAYKFMUiTT6I71kw2uUguSiEOtm0XznXeWHNxDRuYrUFJtWOgAQaFpREGtUzx4kJqcle1dYEQoRidlPqih6lQ8mIiOS2gY4+aR0f8x7mGqEhX+Ov/moN52fCP31SwLlkYDDHmQEZAqMx6P+oa6EsYHk2LJWti8O1Qd4F40y4LBxNoDXPKVMCxavg6XWpFXLWWb2GH037sSBRNJ3BHR9ALNOvKBIabk4UhQPKc5Uqx+AcvjkdNKR9/3/upANFroWWK09kE6l+rjzqRuP/e925/56x1949Lz5xdUaQ0kij2heI6ekSjOX9jZn+a3dUs74GbSlhsP27X4Nuwayd6HstShl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    dca922e019dd Merge tag 'xsa48x-7.1-tag' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11cd6b6c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59da38148f3a3d24
dashboard link: https://syzkaller.appspot.com/bug?extid=a169a27b0538ba43e5d3
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dca922e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7b447b1b93a9/vmlinux-dca922e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/af7830f5dabf/bzImage-dca922e0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a169a27b0538ba43e5d3@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/mmu_gather.c:142
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5677, name: rm
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by rm/5677:
 #0: ffff888022c20338 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:536 [inline]
 #0: ffff888022c20338 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x22c/0xa10 mm/mmap.c:1308
 #1: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30 include/linux/rcupdate.h:300
CPU: 1 UID: 0 PID: 5677 Comm: rm Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
 __tlb_batch_free_encoded_pages+0x11e/0x280 mm/mmu_gather.c:142
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu mm/mmu_gather.c:424 [inline]
 tlb_finish_mmu+0x1b0/0x810 mm/mmu_gather.c:549
 exit_mmap+0x454/0xa10 mm/mmap.c:1313
 __mmput+0x12a/0x410 kernel/fork.c:1178
 mmput+0x67/0x80 kernel/fork.c:1201
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x833/0x2a60 kernel/exit.c:963
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9fc102d6c5
Code: Unable to access opcode bytes at 0x7f9fc102d69b.
RSP: 002b:00007ffd51104bf8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f9fc112efe8 RCX: 00007f9fc102d6c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000001 R08: 00007ffd51104b88 R09: 0000000000000000
R10: 00007ffd51104a20 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9fc112d680 R15: 00007f9fc112f000
 </TASK>

====================================
WARNING: rm/5677 still has locks held!
syzkaller #0 Tainted: G        W          
------------------------------------
1 lock held by rm/5677:
 #0: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30 include/linux/rcupdate.h:300

stack backtrace:
CPU: 1 UID: 0 PID: 5677 Comm: rm Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_held_locks_bug kernel/locking/lockdep.c:6752 [inline]
 debug_check_no_locks_held+0x90/0xa0 kernel/locking/lockdep.c:6760
 do_exit+0x13ea/0x2a60 kernel/exit.c:997
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9fc102d6c5
Code: Unable to access opcode bytes at 0x7f9fc102d69b.
RSP: 002b:00007ffd51104bf8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f9fc112efe8 RCX: 00007f9fc102d6c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000001 R08: 00007ffd51104b88 R09: 0000000000000000
R10: 00007ffd51104a20 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9fc112d680 R15: 00007f9fc112f000
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

