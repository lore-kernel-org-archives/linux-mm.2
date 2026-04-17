Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5FBF43686
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24336B00B9; Fri, 17 Apr 2026 05:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD3B6B00BB; Fri, 17 Apr 2026 05:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C9A6B00BC; Fri, 17 Apr 2026 05:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5B826B00B9
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:12:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 714111A0B76
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:12:24 +0000 (UTC)
X-FDA: 84667481808.04.2571047
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	by imf06.hostedemail.com (Postfix) with ESMTP id BCBCD180002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:12:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3dfnhaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3dfnhaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776417142; a=rsa-sha256;
	cv=none;
	b=nfZm096lGAuVw6YvRLxSItYXvjeSdkruh2aRi1YzPVOknkOwog1KsOFjA2l9CnLTWyRD6V
	KiTfWJnRW1LChQ2Db5e98swZ7rdpO+MMuRKHh57+deeWlsoxsKGzFhTt2f2V/MBqzSw2pd
	h+rfgdjEneJMJfyJ39kCcXUCGvgXXcQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3dfnhaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3dfnhaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776417142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=a/KbQkE3F+9rowducc7K95ONRIPvyXcoib07wiB0EiI=;
	b=W44VAMAQ9OJJQ+QyxD0X8E1rN59W7qzQPfyQvSx8fQPfq7UxhzFqHIekcZ1GQb+JLtXMH7
	AlJ6mpZvuaEn+10rbIIXozcIcOOYtDjXZ1SgAi2MftfyG6KtwN23sHTWL6QkHS4PDsghl3
	1StVw35+FQnA72bHOOQEMVaQL/fXRGs=
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-46ee4a74741so316512b6e.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776417141; x=1777021941;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a/KbQkE3F+9rowducc7K95ONRIPvyXcoib07wiB0EiI=;
        b=Xasn2VfR4q8s+FfraemhT0eQGIC2EiJsCwhqXjLkPbmfAJngzQpmzRk8FXRmGkqeo+
         F3WXf5vnqFlkUmT0+ZK05eyec+YeWPPDFH5pV+mH2A6NwTroEcQSJUxxQnnFglTCBDMu
         uoXFSXoNNl4N6S3Gf3wvAxmfWN3UxhmvoJPNLwpT3lJCVYELGIhUfnnHkeP+M5BupixS
         zpfvA9vYKqY2l+JMRvtiAHJdW053ogbNcJFKAf5xtmCndcfkrslAU3CFeYO9JENbiLoP
         aGb+suSRqmrlPAutWEeT31Kqqsj6F7Lu2VRLSaQh7t0TlcUxts2OT058kEnS8ZLOxIYC
         Bwdg==
X-Forwarded-Encrypted: i=1; AFNElJ/x5az7JiSxltbflwlLUK6qhWbrwCGCJ4jy6IcgnWhQSzOnoJWnTlcAznqmyjezy3D2IuQit0DQCA==@kvack.org
X-Gm-Message-State: AOJu0YwD7lWa0otRi/uUvrWHzighyU8RZ+ZWQRpZVZQkWrz1cFLRLAte
	yShk+E5VMFJCfykrsZ03KNEtxZCBV5f0kKpIsxqZPFF4gpjTBOKcHrzLiUnORh35L9HOUU0RPZR
	H7U5gLX8SeTpFfPXXwQXVU4l+CS4fe8VZnkENYO75dWGk9u1CG2VZIGQravE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3092:b0:692:9c90:8e9a with SMTP id
 006d021491bc7-69462f2036dmr956132eaf.45.1776417141711; Fri, 17 Apr 2026
 02:12:21 -0700 (PDT)
Date: Fri, 17 Apr 2026 02:12:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e1f975.050a0220.1de265.0009.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in mas_wr_store_entry /
 mtree_range_walk (2)
From: syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BCBCD180002
X-Stat-Signature: sbxhnfigjtnm8u6sbx54bpwchsbu1khz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776417142-704605
X-HE-Meta: U2FsdGVkX19ZfSA6XLNcVk2Beh9CIcBUz4AurIroAJtXQU2d9Bbez7ES4/BIRklYIa8btgT/Dafi8MSw/e/W9EfK2QGtnoZufd/BbzzmbSKR0Z91GeYyZBcqcmW8mXTkMpyZHubxX+5UawXnbJIq4NAgPV6m+9tokOCg2r9R3ocfGyGoLTNLUoN3JKTMhWZgJ7M94P71djuTDFmX0PVqD64Q9rY/xcRhCHdRJMg5oVziOCZNxQ1UlbUG93Qm2vyKHmmN35lZMQUh4h9HBP5ABzZhDSa3t51O7mVfHHNBGhrlKKjNek7+eTR9Rilj+rATDoxgybfDAWIByp65/u8VbGEwA9FjEeTXQtkSUDADKUz0PJKuZcgI+z7yGRoSdZLo+vVQvrj3X7ZXPkaDsFQ//TPZp4VqNSSkP+CKqCZQZO8t1wPFmUfltf5Dndtv6uLOJ1lg6vyPLcJFVFvFzmaFGOKCc43JAXWjmSRdVO5Z/6AzlAg+pwBi3KtCrOpCI97fJJauxxrx2eSnv/LBtV77UGYXPR4p0QVfz9T41NEdBb3qIlMJ/0rhccJ1lEb9IAOqDbQX8W67SPEcjEsdpkH9vXHuSrAgm8eLE5BmcKInRZjWW+/h4PtLvIjINTq7Vi4cbt8eDF85iloqEuaKSmpPZicaH1C1QW9Er+9TC2G/QYzozb+pqvcxVVkcppa4LaIli8Mv3fzpwXEm8hLtdaWLi9Yv+cdtCQ/WhNhuPhmEiwa1SrfD6GjlCGie6Sv6h59Tcuk37ySs5Xppa+L6s3LQhfP4b9Asqx5WirXjJP17On19t6rhoQ9Mnhqy0BUpAlh0VyOpU6FJwUTxSPPVVQvl6S0RK50t4ZEke6XBqiq04pXk8hJvyfYK14U6giBwe542USpGwt6aNkhvdZo1+dQKksquIrQDfCMgBupQpVIctcz10grlhSQJN4nmVU4W/aFLikhVHpI0iH6D/6UIawd
 Bl6Bnq3W
 2bXnqTKF40/VwtXjhc54penDlprlM0nC80diwxhU4gkgCdIymbJZ1nzh+VjSuUKAeLpLoVlqJudO/FfQYgWiVFu/pDc3kV54+nX4xOI/dGBNSzvQZtk4VCkCuwPE8nJFJh1Kp96QHMw9XLuzvRSTt7I9FfrmkpdzhHXMb8vuLCugr1O09AH4OjaStUsYn5LO4sebB5/aEkovICORtiZQxQShnW9XubYA7Pn2GDwsBQXl171C7IprYojuk4WVHqkvRgUl9gPCeJkVLd3D2TjVZepAHNmFTcoFhqKbAlYp5Yszxm0w6MAghJj60o/r8O5d5I7yURMoDno9S+Hq8pQUsFiVqgL+JG3ofv2iAQXHnQkNcPRJIPPEj71lnW24ZXHGL1+k2LtuGptrlwM0x2y2B++9agAvL8DOVCfVKNbrMenD3SgJgEBribDi5U+moFKASh2/ZNeFg91m/jwXG+9Xyc9sb8tMaEaaDHGUXCcAfgDGKLy70UvYxV/QrqAhOYGnJ6aj/URrjZB49dO/vKFSQoH1GorRho4s11CCPlMxIY4zmC/meX9WF7GQmDb6SklEETASedB4QvPQ2N7khbCrg05ow+t6eiiCwQtE8PElTS3ZEKf/cHoPQ/0gIKAbDVR6gtWvlKnmi4PJPmuI7qIxvpePCceiagOfE+nmlrGbA0iBer7OBHXVWVYLKN+7r7opPpQVJmneV1rlUHAwFYuaL5k5yPgF2dlvd59mQ0w2yRuDgrkSQv5FnGpd6wBo07ZVnjpKa0Y1r39TWmusYlzf0RBEy/UAD37ySa9P1hQcqCPagPqqzgISMhGmwWEqI4tny3MJ5AfIRj4a1duSLkCtG/s+/HMlDGpc9P2Tlk6/n89QaWBhjLCAcGbGVseqZzE2/A+duZDY63cl3N27EF2/DLFSJZ0RMUhWZLWdzN4edF2twM4XCpnFk97IV+agI4LXXmAoiNhhExWG7yiLI2gQWWK160QFq
 p1UVrJwa
 +HDo/M+XfULQW0g1CbQc1IiumU4K49uIEMlIsgyODCWj2dXcGGd7eH0a2NSM8wOfF76Ko1WITR6yub57fklQoTnAheuGxvsOHVTyAv2sSR9QD8QOLLfZTNyo7yoXHQa5W6rDKrXW+yG4W4mvr6Vs6QbPh6u02ySmzLkF9eEdfUko3TnDSCeezR9oMaSIQ5wccnHOfe6ZjvKr3e/eQv4h29qxHldvxHgewMBaflB+dYyTeMuC6rAeXKaOx1Bv/RMu3OIJemJs15T2f0mR3GFCCbccwITGOGsBh2FxEhKGBAiURwHmGlcBpnIg8OePX5cN/Kpnbia+UV7dNrg69nyvquwzIArbgYwPp4p7O+snXEMAnpeZQpJ1HUvBmP90EjPM+vJ1VEiyGZ4f33vPWeCf3mNzbj+vypkqEOaMk91firYxLXgMI97weWZeb5NRJd9ZcTMBWZzDByVznhME0nxQx7OJjys4CHmKtr98dJn/91hF6WJHz+a3mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    1d51b370a0f8 Merge tag 'jfs-7.1' of github.com:kleikamp/li..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117dc4ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f207c4b1fbf85a3
dashboard link: https://syzkaller.appspot.com/bug?extid=38a879f4a73497f2dfef
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e08ff8d2b0e5/disk-1d51b370.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c11d4b098bbf/vmlinux-1d51b370.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6a4691f32e3d/bzImage-1d51b370.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in mas_wr_store_entry / mtree_range_walk

write to 0xffff888104f71d08 of 8 bytes by task 4757 on cpu 0:
 mas_wr_slot_store lib/maple_tree.c:3232 [inline]
 mas_wr_store_entry+0x3405/0x5ad0 lib/maple_tree.c:3528
 mas_store_prealloc+0x43e/0x690 lib/maple_tree.c:4936
 vma_iter_store_overwrite mm/vma.h:616 [inline]
 commit_merge+0x6a1/0x720 mm/vma.c:766
 vma_expand+0x301/0x460 mm/vma.c:1219
 vma_merge_new_range+0x29c/0x320 mm/vma.c:1112
 __mmap_region mm/vma.c:2766 [inline]
 mmap_region+0x1073/0x2110 mm/vma.c:2856
 do_mmap+0x9b2/0xbd0 mm/mmap.c:560
 vm_mmap_pgoff+0x183/0x2d0 mm/util.c:581
 ksys_mmap_pgoff+0xc1/0x310 mm/mmap.c:606
 x64_sys_call+0x14df/0x3020 arch/x86/include/generated/asm/syscalls_64.h:10
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x12c/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff888104f71d08 of 8 bytes by task 4759 on cpu 1:
 mtree_range_walk+0x1a6/0x490 lib/maple_tree.c:2032
 mas_state_walk lib/maple_tree.c:2952 [inline]
 mas_walk+0x1cc/0x370 lib/maple_tree.c:4366
 lock_vma_under_rcu+0xc9/0x210 mm/mmap_lock.c:304
 do_user_addr_fault+0x232/0x1050 arch/x86/mm/fault.c:1325
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618

value changed: 0x00007f68dc2a5fff -> 0x00007f68dc284fff

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 4759 Comm: syz.5.348 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
==================================================================
netlink: 64 bytes leftover after parsing attributes in process `syz.5.348'.


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

