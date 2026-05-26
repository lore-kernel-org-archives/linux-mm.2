Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61EBFCD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8676D6B0096; Mon, 25 May 2026 22:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817FA6B009B; Mon, 25 May 2026 22:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E416B009D; Mon, 25 May 2026 22:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB3D6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:49:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F22D18CF0D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:49:25 +0000 (UTC)
X-FDA: 84808039890.06.0D7A018
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5584C140003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:49:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3MwoVagkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3MwoVagkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779763764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=d5IKQPIE+zDIfK8Ygs1JNdK6Aw6pvqHNsQalC9jn+/I=;
	b=C8QNIaQnt6MCF6gFM9m5yI/FPaayupg/SajhOOYYjI7H6+aiIy0KxShfXRQqzNunDPBFhZ
	u4FvxQAw/ZdkE5SX5R0Fd9ghjyknQbHtBzbLadEnPwJehIrna4m9cY260KtSHJ9iVKt/jD
	B8R5kEL8R1weWLaTYVAgR5GcV0TeBUY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3MwoVagkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3MwoVagkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779763764; a=rsa-sha256;
	cv=none;
	b=FtvXbh44lROJGrTjS6zwzeudnMjZGWwpvyHML7a5103icCahYgh99UL/N1v6qe+lGm4n80
	kQ1p8GYNUyD/4OBWUgqEJi0x00fZp3lnjuVPEEkAW/9e9OS52igRbRNhHVTnltRW3E9HCq
	x4ofYHvspuzStzOyDWe5O9PcRbDMXkI=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-69d8cbefe6bso1780011eaf.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 19:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779763763; x=1780368563;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d5IKQPIE+zDIfK8Ygs1JNdK6Aw6pvqHNsQalC9jn+/I=;
        b=slgPhB2zlEdN8toAeJ1gysgaxBII7uDSTPUEyuhPqV8iKTP86Dd7kkYpynkqxiEUnG
         wRbH1XXuhtRs0HnTN/t3OplHs0Y23CsfA7frlIyo3nSnOyIfnksOeNvZ4f/SCIDlMLKe
         SA/leDuGy44fk99FMnc49W2eKRDb0NDcXOvsXGPbLgM/+ZHIjIlqtvZ6qwgyLUTXde7/
         e1V8xeQ4ADRIOzMpBs+HfPGy8KRx0Bkkn7vRShVEXh8iRhMTpufkK4VXOc29KQGmKEdn
         K0Ow2gPRvxkRFiFJkXVYpeXPgjFIwQUtG3FMy6IhauNCFIcZ5JhgUlGKsTbOJCwAlfn6
         Ackw==
X-Forwarded-Encrypted: i=1; AFNElJ+HfczeNufgQZcZenR833braNAF8gNeMPtiyaReJqOBufn4c4T60LT2adquXBOyAgsgJh7JaOOXRw==@kvack.org
X-Gm-Message-State: AOJu0Yz4ZPNDbvpOssALHEtJLQmsCdI7Nr5k1qeSCMGwdEc1hwBmnaME
	Y4fomL1U+ey4DUve9KcK7MafMt/0tB3Ri2mAOG7SFgU4CxdsDi9ak6eBoFd6/vZ9SSwPX4B2Wat
	brVZKcBvKOEsGKlJGpc/kQWW37mRVNaFTxTsvdkGADuKwHFdo+jqWP9KLhoM=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8119:b0:69b:93ef:f457 with SMTP id
 006d021491bc7-69d7e839c40mr8551972eaf.0.1779763763420; Mon, 25 May 2026
 19:49:23 -0700 (PDT)
Date: Mon, 25 May 2026 19:49:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a150a33.2b0a0220.185dbd.0005.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in alloc_frozen_pages_noprof (2)
From: syzbot <syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5584C140003
X-Stat-Signature: hy55hxdjzcx35o93ptd347z8imkokxys
X-HE-Tag: 1779763764-310688
X-HE-Meta: U2FsdGVkX18SfBlGbtUPVqlciBzZrRPGSTu95Ccwxex/jX5XSVWabvczF26fKzDdIhUa8iVNhJhys+v5b70w1Ic6ro/Ug4vTjzljyvlwCS+Axb5xWsRKsZLp7/qif5hP+U3omxnHc5ZGnqoDK/xNJk3SN5JUa0Z2vY46xfAe9tRnEfoG4nE7EtpuClkfnL4V2Y/6ZvbVuEQeKs2l6GdPH/Ew2jPBTVqawYLHSSX4rJSGFjD70Xcb+eg0xKLmHI3Vlq2XVyLOjyPnZiJWx9H0+Q2nU26QTBgvsDY2CgDaHKywe6Yg0sJblwkFei2xRwf1G6ZQcwnMwnRbhYdqvbP8IAacBG/fdBD4CahkxG4hfU+EVCLeRd2DeNcNQiQHy987zDA12AtxWk2bIwTV6GFY9CdRGiffPpPRciYBLIMkW3OQnTBA4PGh+v8KDdJJdBJVi3MJ/4WFNKwCjm3A1dn+/09qsfndNozn64czwIKJfstlZYjRurtQAK8EReCx21vpPExEGtKACdnWWYx+PT9Q91s+yrJ0r1VXRJCM8ElAWB9bv5CgC7At63TPDGj71F0+r83yaiFlLXhF5HvQ0/WhAO+bwpYrYOMg9Cj3S5ZeRbIsc1VGESh0i1ilSr9bkttrGXBDbIbIXV2xyk6d0jECSsoqz1vNQJTiyZcLAMz4PfiqASxxCZU6iUQu0e6z5MpNDEcQl3bbHYu53Xn4lvdeDtnVvQ9+t/KG2zhqxBxsj1bfC9HrOQkJeQk4dyUrIeuC3iFsQNKl54TVraYq7OcfJzau0sOV4VsdQbnoYQBZMe6iRlgTM/OXzRltvjbYvqxKZH1RY6SGUZmhUxJcODs4pepitlwHZmD/RJHaBbdOYIRfZnRviaeJJa/ggOMBd49KxVP4hjMDOaXkYa7r4jNLKusTwejrjNfbYNbsWcqVZvGU6ifHSdLSgbFCtGCW79BNTIKLYJVE7sLN0yYdG58
 dCbe25Rv
 FNTd1QTxYy7Sh6WKAZA/d3CwzJC8v+lZMKnplg6wxINUl/x6Nkzd8vGk2UNKFaGi4LUNqmlI7W7fNAdNrYef0js846ERiVblNo+8jkKtxFy6FlEvMJLvRvWXbiBQX0JtrvHG/E5tzgcR3W8VwMNs+MAb8Ygox2U4J1tpwAoEfg6dMGrwGBSn/xL4C8MCq0XxDD0y775kUl2zu80/CYACF3yyrim++5KJdKwjHPXASClBkz73CuGUDccMF+dbUSdUKm2YXdWjJtvYwveYaLn7d6/QaUgBvVaPFCd+pJ7aOWxV0PcWNp77eB5QdKpHBTTduxNCAM0ZwaZJEAlC7HXu+87ohkOd3SNWHT7MWIYXFIGkIIj2fNbOoyE13zACw2ewPm1VAbMrMoajtpO0F9D8MB0QdLjGvgzI0m5hRmK3jWaJzWdGcVUO2hNmNE2HDxuEAjQvL8E8uqds9fCP8Z1BSs4XH1GkiCMpy5GNrMzz908Hldjg170HwZ3+kyp1Qf2vcTZ7LKQcarbNcG+VHiDeUsWGrJEJxZowT+6LTbuMnMfecg/tVNZHfzQSNYQieYWwxG856poJNsiT+ubQwe82pc0UYa/JyOeOzm2iZ8caO9f+LAU9He1ddoDX98dteH4R5ebMb5jEHJ719kVn8QoZ+2H1O5eKdM8+CD2a3cjFsaTmGHX20KtdiZbs4vvTLyacHoyah+036x/CtknFvFYqlALW5tWrZpYN/2f5SQXdh3umbPfqBDQvR4f3oRYA7TZg4NKyDSugOZEiqNSrdnSj7VXQQwlnP/HQzTQuMPk4BM+/DCD5tHVdKAYsWLaoLBZ7PB174Cu29dlNKUYuFfubcH9TmyLZ8KLREmm2W1NWL3mLthVC5QfA0DJTqqqr/8YrQDzv9JtG0bGPo9EeGfAu9BoKu6kuIkiXVcKpd0YcwHHAp6+Tj8Eot6Wq18bPxbeXeiwKLqHUCzCNZ35Ykn4cBKWWSsqOP
 t8bhlR3P
 ikshEAZ40ZqJGtNhZMPZd9mD1eGUm0r8A5XeOVHrTmN2JcrJHetq/OiUnPdAp36nqM6Klhxx709EA5AYwnxnZvZL2+LSPNHhBLNj4M4zGOvoz+Qr3LB5oN1fGS+T5c74jiDOK2LDrRgM2NvPrCgOKvngm2ki3D7atBiaZW218Ko7atm5vOBVtbdX+mn+sXFVJQS1HJK3nnLG2wy3U1n6o2cPaKQoSwXcsRy05JPJXFMpW/050Zan7f1YNuPJVqPo3Ehk7PJ7d921S3tANjtordIqlFrQ1sPKy3bS1c73OrEeFWW2CY4aCgkE/TfKZgWLqwoEoi344FRsxKBvp5rXqSCJ801sju1c1KHCScEorAYWHcLA9pPOer3OlEtkMLaBGCc+0gfG/TXyKF76sOjyPGcZTy/KMCVcHJ41el9OE1qsiED6AoWu8eRwtYjqweOFHX/g+cX9Xs/UjEABWsR/rRy3x+ZH8wUVCGX06u0d8jsZvmwIbsX/c0fxr7ZjxlM1MLweX56mAbRR5u5QRNsUu/35nn/tD1TAXG4aewWMKgUOrI5ukQWcn4c6mD+Adyh+Tmon7O48u9G9iBCYsjIkK3RM+vNuLBS9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    4cbfe4502e3d Merge tag 'v7.1-rc5-ksmbd-server-fixes' of gi..
git tree:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux master
console output: https://syzkaller.appspot.com/x/log.txt?x=146c161f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9475bd041c93289
dashboard link: https://syzkaller.appspot.com/bug?extid=5d32c8bd82427f9c77cc
compiler:       aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11026336580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ab9796580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-4cbfe450.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e825a08fb48d/vmlinux-4cbfe450.xz
kernel image: https://storage.googleapis.com/syzbot-assets/55037c053ec3/Image-4cbfe450.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/page_alloc.c:5202 at __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202, CPU#0: syz.2.17/3592
Modules linked in:
CPU: 0 UID: 0 PID: 3592 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 21402009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202
lr : alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
sp : ffff800085d93900
x29: ffff800085d93a00 x28: 000000000000000b x27: 0000000000000000
x26: 0000000000000000 x25: fcf0000014c00000 x24: 0000000000040dc0
x23: 0000000000000000 x22: 0000000000000000 x21: 000000000000000b
x20: ffffffffffffffff x19: 0000000000000000 x18: 0000000000000002
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000020000200
x14: ffff8000828b2000 x13: ffffc1ffc0000000 x12: 0000000000000001
x11: 0000000000000000 x10: ffff800082b6f4e8 x9 : 0000000000000000
x8 : 0000000000000030 x7 : ffff800082e9b430 x6 : 0000000000000001
x5 : 0000000000000000 x4 : f3f00000065c90c0 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffff800082dfd000
Call trace:
 __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202 (P)
 alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof+0x48/0xd4 mm/mempolicy.c:2561
 ___kmalloc_large_node+0x11c/0x13c mm/slub.c:5237
 __kmalloc_large_node_noprof mm/slub.c:5268 [inline]
 __do_kmalloc_node mm/slub.c:5284 [inline]
 __kmalloc_noprof+0x450/0x560 mm/slub.c:5308
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
 drm_mode_create_lease_ioctl+0x184/0x93c drivers/gpu/drm/drm_lease.c:521
 drm_ioctl_kernel+0xc0/0x130 drivers/gpu/drm/drm_ioctl.c:804
 drm_ioctl+0x258/0x580 drivers/gpu/drm/drm_ioctl.c:901
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0xac/0x104 fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x54/0x10c arch/arm64/kernel/syscall.c:49
 el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x1c/0x34 arch/arm64/kernel/syscall.c:140
 el0_svc+0x38/0x140 arch/arm64/kernel/entry-common.c:740
 el0t_64_sync_handler+0xa0/0xf0 arch/arm64/kernel/entry-common.c:759
 el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:594
---[ end trace 0000000000000000 ]---


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

