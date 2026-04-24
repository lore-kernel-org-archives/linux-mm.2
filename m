Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7194FFB44A6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 05:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6926B0005; Fri, 24 Apr 2026 01:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7C76B008A; Fri, 24 Apr 2026 01:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3E06B008C; Fri, 24 Apr 2026 01:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B40E6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:09:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34570A0BF9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:09:37 +0000 (UTC)
X-FDA: 84692271594.25.AB29F57
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7707DA0004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:09:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3DvvqaQkbAAcz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3DvvqaQkbAAcz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777007375; a=rsa-sha256;
	cv=none;
	b=3X4o2dhQ66ZPMzNDG5pnEz8eDso9iY+opMk+o0VTwxTluSX4N5s/nuJpiGCjogtmhd7TpY
	QWARyvc15D16hk+5tzuyJILu8Z9mICPqAV00WLxYWewURarySJsy+IjK63knU3vBTuy4+3
	PdXDsnOX44nu5u1jVaAItc5FYmAqmUE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3DvvqaQkbAAcz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3DvvqaQkbAAcz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777007375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=TGSO3ahEc0c0N8cTVgjQ3/FQCivWnlbeOFkHgcHPRLc=;
	b=37MwQjF1/LaRfMtxT7MLJRwBizSU4vf9UA+CaTBaTen82wOgjIDAyfFdzNFOdFw7aroJoD
	cZTt8LWB2IVuyFxkJ/PWjUhhGbBEx9x0FJ4f1oxbB6jI66+pc5LQQyJiDmHKxQoNAg8hZd
	hY4jab0xgVh7aiRZjL6kuTKqHICmdmg=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6949ebccfcdso3940864eaf.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777007374; x=1777612174;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TGSO3ahEc0c0N8cTVgjQ3/FQCivWnlbeOFkHgcHPRLc=;
        b=KkJyPJPZ1LNbA1ezxn61N2dt9/X8Zr6D+oYmuyYhWrXaZkJLiaAibG1wib024vqLGy
         arik4jMOVNgiZV3mC8NAfUzghzZUTliDHhVDx5b4lnFFg7z+CYoGpXJwS5g+I4JgkY4Q
         cAIa7HovTdMpTV8WFHpFB+xILJwNsfP5enHCmCtqAHgFBKIOat6AbwX3UQLHZkPm9aMU
         awcW5RNF98UElDS5pLP/zLwtSESSfGH1wsb8LYp4BbblZowyl+Oj5oHrdg2N6OrofF7E
         wDm59hmPkggkZIFcPa6d/wCQj6gCV//H1KssKrhAJUpecwJGni0Q+ceUeH2Ms8G4+AcI
         HgBg==
X-Forwarded-Encrypted: i=1; AFNElJ+E7ICTEkbnkp38p+DIHqxOd33TJEjIo78tE7Futl/UoukdTDOd8H/hpo43gReccjaA0sjApdgang==@kvack.org
X-Gm-Message-State: AOJu0Yxjf0W32ZlalsiHpWJmS5b4fxxgJOqponDHgbq0NXYik8iZ47SB
	vkAOYdYqF8q4ZixnjYjx6wfu8wfmr3TRMq9m0geNge4XiN7WkMMGjUfyZXhTuy4/Bg+8sPc3Uml
	DsimmgrFHbhICjbdxi3PWQEUlJAcHes5U5xpWfzosaVm0AZ2cBhZVbG/lsVQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c06:b0:694:8f3a:3f41 with SMTP id
 006d021491bc7-6948f3a4683mr9280211eaf.41.1777007374371; Thu, 23 Apr 2026
 22:09:34 -0700 (PDT)
Date: Thu, 23 Apr 2026 22:09:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69eafb0e.a00a0220.9259.0031.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: bad unlock balance in folios_put_refs
From: syzbot <syzbot+c4f8158debe41f3bca37@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, chrisl@kernel.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, youngjun.park@lge.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Stat-Signature: 199sm93kkz1pikjhri5oj5t77tkpmw8t
X-Rspam-User: 
X-Rspamd-Queue-Id: 7707DA0004
X-HE-Tag: 1777007375-403172
X-HE-Meta: U2FsdGVkX197NXmoaACFPOJ1aqsYufGjMD1QCs0Bb+Nqb9aAhD1whyCbjZein7gUwyXpMWfEd2IzgaER/wPyCFIVlEYUkMIt0DZjOsOGfp5aJasxIC5sYQhiizgTaaricVbhP7tv1kwff+aQsOm7tq86f+/Z/cLt2U5NntGfjm9/HKc2yAGZ0cTbPAa0k9CpSbQZu6xsuCU+t/YxsYPLACO/qvhrx0cefZBwx8RszyaxRKYHIGNyNQ/0ydX8Eb1wOCxRTB2RznIqKUwE9VkIsGcCMxB85qX6sdCj3+0q+XckGyhD1aIyLQ73kuCLaPk9MkQ8riUjYiblaD39nTOUt2nUXVkgM/DtBMBqCSJuk4X4nZtefv5ax/2DrnkGAKbn4sRm2HWG7HDgt1Bp2aiJ51d9O4KpWnT6SrMtRfcW/S6fbpqFZUQIriqlWz3lHDUCw/v/WcZKpjxwPxkNJI7VMpDsIONyPJh/nTDSomyXjp+d3/aptesR+NcrBHEofJPiuC+6EeVZgIrFJWKH04eCIjd9xFLFvBB6XjVv6G1Pp4Zqp5icP1FUpqv2z0JWkrBQunoN9Dq186UsCfSFqztwP0mR6lRKbipCavw8JjLveJnxXYDFvPowrKmKTpm26hc++DBLjBbEBgZ+EeY6E2xJrRDjRikVDLO/5nDUipMcfS0jXcLQtsw03o/MEyIIe5x+8F8dLCU+4iF3m2NWKUDQMXU0xOyQInOSY7UIBJqMjBl0doxW2MQt6Oc0wJ0bf2N28vTxVwpAJl9LuvGFFEps3KT37Tf+YevyEEV4SgCOSi1LqwxFH30anuxmM8FhnvVJYlJ7zFSbQjceAEPS7j6+4e1xfUihGWBbUnkDmwu6u2MNPkkQ225Rhh4EPa+ODvbLKFWxiiXFgDQo6ASX/et1eHuwx00JGvM+U04XAJAjiBIGJurbmV4BRkqFi5LgwQNRHONsortpBquFyh0M9u1
 ATty/Mst
 Q1NdJRF6V6/cdCEWlIQtBPEwN/RqgRTfzVgNyR3lIHJoQPKf/4Zg/5wpnoWp5FEWAyfPdjacPq3avMhfFxoN/JzlQpsjyWzKYmt//uROKJ7YKsa2bZXlJQsZt5DQYJmmXixuSa2/opdsg7VnqWfR4DPU+2pixEqqkbipE7gQiJHMd9jH3sbD6Prk+e+i1VZEQ+bGlft2OS25QsY/QkNRNN8KEQfCbkTLLowhRaEYOiWUbSwnUYykMYxhTb3cdt1ngjXdnJqiuG8gphqGKRd8hfu4f2tzGq20dZLaoXnq08hu4Jw5WTWcZ35UYc9KnGHtguF6trJ0Ez8olATJ10P3jPKpd6O/aAvDSmD19UUJjjywgs9S4Cf7fQjpD7znsAlTQ3bK5H98G291sjqeRg3T3hfIxLGaLqIh9pI03VDSYdG6Uijd7pgcNrKDy2kCJO7r4RXPkmsNee467/mWBHiPcQ6QEmwG1EmGY9xia+JbKRRLTy4ns/jh0O9YbY9lRYs1hT/IxRVq1qhy08o+3WnVJUJF2lPNI/I4fJQShICHh1cKbGglrPhN9VrVV4Ngpi2oyDy106PMN7eBdyMI25ME5NFNrFU59CoQI2BQ/++gHjBQDh7iJ/1Tpa2Eqk3CotqWe/yaMFqSDLhXNTOrgv373quRjOTwVHWkuK+VewzL7eTjAhupwbmIT4roEZHUMZoFLCa8guV13vC8cWAktqWdIoiU/basV8om7U39Uiop1JXnXhtjgnmiohwK+U0hDdYaPAIVMyRloJQAf6dT4AJ8nKay3IyvT+QJddhVApvog6u0zMuPpnAA6LZDBcA4KSMLAociG2Q0A+FcGPMWIt+IkS4AO4P0x97UH1cGJlfNLj3Ow53luCixDLJL6psVfbEA4oWokhcsSYoXivrBRKgKhFuwLX4VdNAzEz8E/dS4css+hPf8ZgztSiF32DOYZ0vlqOkBcpf6v+jTkA+mPXB/bz8lBxKaH
 SuCBsPzv
 2fnPYSmfv0F137SvMvsMlm/zZBmuX2pYn0gr33LdVeycCUc6LuJgPT/VfPJdFqQ+7rfz3pKS20RFJa0f1NjLyhK0WYz0Pi3bnHXY4rRdSnR11KeP1CFNn3zm4y7CuJ20eDLhW+GxdB9Fd7mp9pyhRfpeVsUs9my3YhpXd/14eXUZIymyhDRtG+8qbB6S12zlzmZ+1C9jkY2Fkbs+8J4HHUtCrP//jqNFErAaVTRxaDrj18INtr84kD5u1HhjnQkqlV8Y1UuP3SkHc2KDpp7iXo/5axKcp1kqnt0bwwL1Oxq2HW9d3AqiHF5y5aXr1C2Ek4htMtCseABE7cs+fpUMV9S+14heJnPsgxvyI/sMfUip8sSIdd5o35I9MfLZUHrhwtkaVsMW87tCksBjnwSCJI60HXSNIhRTrbYc5NV00UBTfNZVfNmBJKRo/arzb/rSsYoGwvE00ldi5brCsPAhqWHNN0xuxiJn
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
console output: https://syzkaller.appspot.com/x/log.txt?x=140711ba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=507c1c0a12a79510
dashboard link: https://syzkaller.appspot.com/bug?extid=c4f8158debe41f3bca37
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c1f49dea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98ce9fed1a97/vmlinux-c1f49dea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b02e163ec959/bzImage-c1f49dea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4f8158debe41f3bca37@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
dhcpcd/5934 is trying to release lock (rcu_read_lock) at:
[<ffffffff8248262a>] rcu_lock_release include/linux/rcupdate.h:310 [inline]
[<ffffffff8248262a>] rcu_read_unlock include/linux/rcupdate.h:869 [inline]
[<ffffffff8248262a>] lruvec_unlock_irqrestore include/linux/memcontrol.h:1493 [inline]
[<ffffffff8248262a>] folios_put_refs+0x50a/0xa90 mm/swap.c:1000
but there are no more locks to release!

other info that might help us debug this:
1 lock held by dhcpcd/5934:
 #0: ffff8880134bf178 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:536 [inline]
 #0: ffff8880134bf178 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x22c/0xa10 mm/mmap.c:1308

stack backtrace:
CPU: 2 UID: 0 PID: 5934 Comm: dhcpcd Not tainted syzkaller #0 PREEMPT(full) 
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
 lruvec_unlock_irqrestore include/linux/memcontrol.h:1493 [inline]
 folios_put_refs+0x50f/0xa90 mm/swap.c:1000
 free_pages_and_swap_cache+0x22d/0x3b0 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages+0xe9/0x280 mm/mmu_gather.c:138
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
RIP: 0033:0x7fc4db37a6c5
Code: Unable to access opcode bytes at 0x7fc4db37a69b.
RSP: 002b:00007fffbd1b3848 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc4db37a6c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000001
RBP: 00007fffbd1b3e58 R08: 000055eb8d7db2c0 R09: 0000000000000002
R10: 00000000000000e0 R11: 0000000000000206 R12: 00007fffbd1b3890
R13: 000055eb8d7dc8a0 R14: 00007fffbd1b3ad0 R15: 00007fffbd1b3880
 </TASK>
------------[ cut here ]------------
rrln < 0 || rrln > RCU_NEST_PMAX
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline], CPU#2: dhcpcd/5934
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430, CPU#2: dhcpcd/5934
Modules linked in:
CPU: 2 UID: 0 PID: 5934 Comm: dhcpcd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline]
RIP: 0010:__rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430
Code: 74 11 c7 45 58 01 00 00 00 bf 09 00 00 00 e8 a2 a4 da ff e8 8d e0 22 00 9c 58 f6 c4 02 0f 85 dd 02 00 00 fb e9 57 fe ff ff 90 <0f> 0b 90 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 14 62 87
RSP: 0018:ffffc900045df718 EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff88802a092500 RCX: ffffffff81e80bfe
RDX: 0000000000000000 RSI: ffffffff8df2c0ea RDI: ffff88802a0929c4
RBP: 000000000000001f R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffffc900045df8fc
R13: dffffc0000000000 R14: ffffc900045df920 R15: ffffc900045dfa20
FS:  0000000000000000(0000) GS:ffff8880972ee000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc4db4814c0 CR3: 000000004fd57000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 rcu_read_unlock include/linux/rcupdate.h:871 [inline]
 lruvec_unlock_irqrestore include/linux/memcontrol.h:1493 [inline]
 folios_put_refs+0x514/0xa90 mm/swap.c:1000
 free_pages_and_swap_cache+0x22d/0x3b0 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages+0xe9/0x280 mm/mmu_gather.c:138
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
RIP: 0033:0x7fc4db37a6c5
Code: Unable to access opcode bytes at 0x7fc4db37a69b.
RSP: 002b:00007fffbd1b3848 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc4db37a6c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000001
RBP: 00007fffbd1b3e58 R08: 000055eb8d7db2c0 R09: 0000000000000002
R10: 00000000000000e0 R11: 0000000000000206 R12: 00007fffbd1b3890
R13: 000055eb8d7dc8a0 R14: 00007fffbd1b3ad0 R15: 00007fffbd1b3880
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

