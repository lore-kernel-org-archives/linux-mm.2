Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0FD0FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 20:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385AF6B00A6; Fri, 24 Apr 2026 16:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3368E6B00A9; Fri, 24 Apr 2026 16:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D876B00AA; Fri, 24 Apr 2026 16:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11FF06B00A6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:00:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB49B1C0323
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:00:37 +0000 (UTC)
X-FDA: 84694516914.09.F617648
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9323F20020
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:00:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 34svraQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=34svraQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777060835; a=rsa-sha256;
	cv=none;
	b=aTKXOcPuE8PAke3ekZ5WaBDahtxymreqK2wgXonT5MLpWaGd8a9Chxn2P0dr9It1VQ6AGz
	IkhVi7112shBRLCIaOaIfpgcYUzAClHK0Txd32KywrFXQ4kZwjZtaBb2zHU46hGFD8E8dI
	BSDyCWOAB9ezh2gNFCb3cmVQmrhleNM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 34svraQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=34svraQkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777060835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ggGX+6weTYqFFNdLkFPYeANYaSekrOHoGD6NL8WI18o=;
	b=kxSGvk0i+Czjb0BdGq07uVZn7ensczIQ4KnduGHX3ijZjDuEoJNVUvRDy+u1sPBdKDZWH5
	Ez5rs1rlGrrA6c2v9s0Z7Kl2ecDY9YB/JBzZ1g8TBYpD6sfO92y83JeSvIrCD/e2HiFGEx
	P7eBCM/kADSkj4ByVnSHnB+6GTmfMJ8=
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7dbd1866b66so19712463a34.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777060834; x=1777665634;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ggGX+6weTYqFFNdLkFPYeANYaSekrOHoGD6NL8WI18o=;
        b=pk4Et32LK7ykNEjd25D6LJKtTpR8E5NKeqIzSCz8re5jPELFiuQfH7n60KMpQ74vtI
         GYifZLDMeVw3UwzMPxeobdZaDvtFSFVnzWpiJFQrTvEnf2hpyDmgD4t8qsDoNB1zI3V/
         HpXFS8ynAXpdQjOwagx0i1DT7V6Ip+esI4ore8dxpgxLcZGAkdBVuPaA546yGba9UiQG
         xbGy6sBBgRf3B+PriW2qz5/vmyW4Kf0z5LR8M/zwHL9paJuNU02Sga0FMLbUuSnbBtZc
         qY4nJtFecXdX1GBL5zpm6jMvJdzQbVQTTLcMMbOHvHY2hkY3Y2A1lbpneFJ1DfKYo3B6
         BRKg==
X-Forwarded-Encrypted: i=1; AFNElJ+SrayqBqDINIw3lK3PV9fv5rbGSXro4swNOYD4qPLCIEY/qzQh4hOhhjMOIUwxQwk8wY2JUE/nlQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9Sx9ukG4nd4EGhUz3dLU9KDsgkZY39c7P6dacphMSQt/i/5gH
	N0bxWUFSy4EfIqwssYMnczRR23sywp4Wd8uhbklm5cCxmRT4hXV9gGR+DfQyn517x2gXoilN/y6
	yYImml0NdZb10loj05o2Riprdy7t1L717I2Q2Mrb44O0RgQ9+uqj2HcgBEf8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f024:b0:694:9d60:99ab with SMTP id
 006d021491bc7-6949d60a6d0mr9785179eaf.6.1777060834437; Fri, 24 Apr 2026
 13:00:34 -0700 (PDT)
Date: Fri, 24 Apr 2026 13:00:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ebcbe2.a00a0220.7773.0005.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: bad unlock balance in __zap_vma_range
From: syzbot <syzbot+d2be42d723da59b38697@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1pai8k56naitpekmcunbrpra5qabop76
X-Rspam-User: 
X-Rspamd-Queue-Id: 9323F20020
X-Rspamd-Server: rspam07
X-HE-Tag: 1777060835-914268
X-HE-Meta: U2FsdGVkX18BckflSpIzbw95/8Y8rwi3hKb6lpchU76Qdf4uT8PlJr7gLrqOV7iRLBrIDoClyyRUYjocjRLtDWrk816jPzjZ/GadMI8sLP0eSYaqUGHs/5/xfMEFlvJdIZbs5wdJTJ8ij1Ha7XfnCVOhVkeSEKQ9bibWeanMLhLOlnHnZOwKB5rN+vC2ZnWcqQ141kDX/tLDORUVrsMmMIzuZxt0YWhDMWWFy3DDqOqLmna77DDuQTrPMP1/V3oedUT/hm5QlmxP4h+qKELLTbLINkdIrot1FXmek0wZ9qbK3Z2q0mQ3EHYwF7IqP0bINVSxp/GJASST89CDxRTAe92WaUdVQT17e+aq6cNvMJS74f2s8F+Qx2ziq9NY2DZ/uqaC7zhR1WPIHO8qtt19y8c4C/ddKgJmynmbKAMX1gIVUX8zf5ItJCmdysfpgTErtiLWSLXS+jhGhuBFCm8G6MFXWzpPiYwznLpHPFh3cUSnq61fWDPyXBlIMKJ6DPSj0pq2mYKE9pJ67HeDjKq3L/rrF6IcKWH5oxmfLffi16RPfsPTCRtbYZt7+dcijLQJFSzxec132ukz0UdvKV1oLeRWoDmM98zQZHJWoAMI0ZMlrCmmNGqSMFLBz2LqSFqhbisof0I11HJ0QZIrbZxwh/WrYzasawYypTIS1OueBysa/xb4c+qbc5yUUfA5DIRC7z8cv/LyCbTWWSUACcSP4cVIXVQJYmmEZZZH3i1XiBmt1RDjhtUHYztJ2h04aZ1vKfAH6yR9+lYIBX6mKiFxsZ0OP8jxGvMoWamvA/U3pdKnjBOSyUcL1KA5aBDofEJwFcff2Ip2QgZakdactlai4rGaj4+eGZo8MUWlmAG/aJZ6e6MswFDr031BJ+4g2jBu8Su5TjkbKPYso1PxTv8FK2cFkzS20D1b8fyVSbU6OB+27ajePMoUZn+uUtfiEMJdr1WVTnDWcrDmOEBp9xw
 Fo4EpI/r
 9i76PQJmij14Smcxw4xg0fbEA7Rr93i5eVDg0SfIYVqQFsLGA5iB35t+IEkx8lfXBe+ZH6Nab7/I0LbWdg+SzZV/lWg06VIUdMa6niUEV9D/ln70Yn/yrkxOcvGyx7Of7l7bMeNvdMVaLpumN6VL7AhnEzSAnDszXEw/sTXy1Pg9zpNuz5kph8JMiw3zmZ8l4Ewn0rgh+pa46fkrsEP52Dhy2UCP0EUuLx0MWPOCV+NUuxYugJPKh2nTFU7T/18VaiQkfOm+EzvZvKAyyhvqFFLbMl7msqTRE/C1VtYR51HriF/1UPsD3VsHAT/8ksOFm3PpMFlgOViRwrq49j50tCXxLsCsLuiGGu6mPBExM1lKYPo5L5btYdchMQ6hx0rii99l39xp8DwmGWfRTWpEa1OrqtqM3XJL4CbvoxBsHpeTzc7LU7cbKCS5jjgaGEiumfq7PZy8SehczhiWA5lJ2Mitn59mGU/8Li0dalioLW2cX8tsM2tvbM5UF8z9yRQAHgAaBItQj4sEm5BmkEAQzrJ4v0XL9fhKTMY198IB8uufoPf4xg3X3kKun2hIRhLlC13iAQKWTPKAAb1bDHDqQjItOgvaThN7BQhSKu5x1ojrbPZkZKxFqMqOa/JnSiFuwLQYHjq6h1RUMNbG5U52TIlMwwv8nIMFInyqx9sCey6Uvh+eYpMxZlz3234T9zTLG11ugD3esvDe9dvYE4NiGvY56UvR1uFli9l1Q32agEFtmDIgPP4WAKbBcjlgX58B0z+0eO4XCKrZaNzgjEQS5apOE+uMQg93IgXhIJDChba/Ltuhttr3acLqqTw4LAUMZMz1LjGcPmqRFlC095KvgXnrATga2NEP77+zYha+wZRwJl/o7bVMEBuBwvcRX5xVtxhiFN6FHSluaUrvpyaq7vK+SD5LWjebzgrFTrwGAIo/3PsToOCNku6YzqdDHwjMu7br3i5bwU8i31p8EF+2y1pgYMvPj
 kBYqprhY
 8nlRUd4VIgwnFy7mhtO+cv6TFnE6Eef3bNIhJ86g6R+voGqM0teolTTngkrJtZL7aykq+mJDKJILp9mLjU5e8/ilbjHIQDgTyCtHthXmcpTE+iOUI1ZESx3Iea9+dbB/XxSBncq6NeLdC1ewEp05PFHbYQtu8VZFniy3x+clMD7cgMPs5k4feqxzniTOlNZ9tDtIG0+onaiibkuQvR6+xjKOY4rHg3xUEKB12YjC4ActXCMpBR76aerXNTV1lHKq9O4ltBulQ0KJ9Q7y1N/CKWl25E61R12fIt0+EdY0ExO4NQ34Ts88n7MHSZ4ZHVb0DYRY98mRIfGxctYN3JRt9YIjvnikSCYsohFsJbXsB15njpPLDaQkAgJHKHRPb9BFEaCdO8S9E3Qj9ULKoduszhH2M8cW0IEKC9zMu0EUpKRgl/j0FpJImgn+Tfor77xcu65qBYW5GUuVFe/GPzmHXD/qGn4KwZ4D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    c1f49dea2b8f Merge tag 'mm-hotfixes-stable-2026-04-19-00-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b09f16580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a29a582d8ced859
dashboard link: https://syzkaller.appspot.com/bug?extid=d2be42d723da59b38697
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c1f49dea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/402c79548d6e/vmlinux-c1f49dea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1bc39526d7f4/bzImage-c1f49dea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2be42d723da59b38697@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
dhcpcd-run-hook/5886 is trying to release lock (rcu_read_lock) at:
[<ffffffff825b687c>] rcu_lock_release include/linux/rcupdate.h:310 [inline]
[<ffffffff825b687c>] rcu_read_unlock include/linux/rcupdate.h:869 [inline]
[<ffffffff825b687c>] pte_unmap include/linux/pgtable.h:117 [inline]
[<ffffffff825b687c>] zap_pte_range mm/memory.c:1948 [inline]
[<ffffffff825b687c>] zap_pmd_range mm/memory.c:2004 [inline]
[<ffffffff825b687c>] zap_pud_range mm/memory.c:2032 [inline]
[<ffffffff825b687c>] zap_p4d_range mm/memory.c:2053 [inline]
[<ffffffff825b687c>] __zap_vma_range+0x22dc/0x4bf0 mm/memory.c:2093
but there are no more locks to release!

other info that might help us debug this:
1 lock held by dhcpcd-run-hook/5886:
 #0: ffff88802b94b438 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:592 [inline]
 #0: ffff88802b94b438 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x124/0xa10 mm/mmap.c:1284

stack backtrace:
CPU: 2 UID: 0 PID: 5886 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
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
 pte_unmap include/linux/pgtable.h:117 [inline]
 zap_pte_range mm/memory.c:1948 [inline]
 zap_pmd_range mm/memory.c:2004 [inline]
 zap_pud_range mm/memory.c:2032 [inline]
 zap_p4d_range mm/memory.c:2053 [inline]
 __zap_vma_range+0x22e1/0x4bf0 mm/memory.c:2093
 unmap_vmas+0x299/0x5f0 mm/memory.c:2162
 exit_mmap+0x1ef/0xa10 mm/mmap.c:1300
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
RIP: 0033:0x7f4a27bab6c5
Code: Unable to access opcode bytes at 0x7f4a27bab69b.
RSP: 002b:00007ffe0faf6ed8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ffe0faf7104 RCX: 00007f4a27bab6c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000003 R08: 00007ffe0faf6fd0 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 00007ffe0faf7210 R14: 00007f4a27dbb000 R15: 00005576e2150d98
 </TASK>
------------[ cut here ]------------
rrln < 0 || rrln > RCU_NEST_PMAX
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline], CPU#2: dhcpcd-run-hook/5886
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430, CPU#2: dhcpcd-run-hook/5886
Modules linked in:
CPU: 2 UID: 0 PID: 5886 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline]
RIP: 0010:__rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430
Code: 74 11 c7 45 58 01 00 00 00 bf 09 00 00 00 e8 d2 70 da ff e8 cd fd 22 00 9c 58 f6 c4 02 0f 85 dd 02 00 00 fb e9 57 fe ff ff 90 <0f> 0b 90 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 a4 74 88
RSP: 0018:ffffc90003387778 EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff888025320000 RCX: ffffffff81e8a36e
RDX: 0000000000000000 RSI: ffffffff8df30d5f RDI: ffff8880253204c4
RBP: 0000000000000004 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffff88802b94b9b8
R13: fffffbfff21b8360 R14: 0000000000000000 R15: 00007f4a27cba000
FS:  0000000000000000(0000) GS:ffff8880d64e7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe0faf6018 CR3: 0000000037c7b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 rcu_read_unlock include/linux/rcupdate.h:871 [inline]
 pte_unmap include/linux/pgtable.h:117 [inline]
 zap_pte_range mm/memory.c:1948 [inline]
 zap_pmd_range mm/memory.c:2004 [inline]
 zap_pud_range mm/memory.c:2032 [inline]
 zap_p4d_range mm/memory.c:2053 [inline]
 __zap_vma_range+0x22e6/0x4bf0 mm/memory.c:2093
 unmap_vmas+0x299/0x5f0 mm/memory.c:2162
 exit_mmap+0x1ef/0xa10 mm/mmap.c:1300
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
RIP: 0033:0x7f4a27bab6c5
Code: Unable to access opcode bytes at 0x7f4a27bab69b.
RSP: 002b:00007ffe0faf6ed8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ffe0faf7104 RCX: 00007f4a27bab6c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000003 R08: 00007ffe0faf6fd0 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 00007ffe0faf7210 R14: 00007f4a27dbb000 R15: 00005576e2150d98
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

