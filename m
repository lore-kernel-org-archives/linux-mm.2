Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6361EFED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41F56B00A9; Tue, 17 Mar 2026 13:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF34B6B00AB; Tue, 17 Mar 2026 13:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B089E6B00AC; Tue, 17 Mar 2026 13:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 961396B00A9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:33:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CA518A9C2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:33:28 +0000 (UTC)
X-FDA: 84556251696.30.0D2E8D7
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B540100012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:33:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3ZZC5aQkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3ZZC5aQkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773768806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=OipRQ9zxvTmfpMfkIU9uvHVnNwcyXRRqK7vPZDKQeZg=;
	b=VFnTZbZ4dzf0kxzOURY47DpOSgTZz6xkkcBBDCCGeVwsxW/aOIQYLuqFyQDSczxyXgyzPH
	1NXZqkO4TJzDHeJlHX5V0+v5l2D905lBV54QuVrbQ6Z0XCrOcjqIufCyUe9LfNnF1VQYqU
	pXwTf78ynKZsjgDHHHekA6sNQ/pcCmg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3ZZC5aQkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3ZZC5aQkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773768806; a=rsa-sha256;
	cv=none;
	b=ldqdPbwrNkCoyHAZ8g8d5OIqj1eTUWj3ir5ZjG1PMtw6QWZZ6KAikJNriu2fQPL2X3+JYf
	l49wRtVPRMwdCGT7078IS1AlHQptU7MaXvYV7etFYK2Blg3Rne98PWZ02l5NjHiOW4TAHI
	kp/SIFAFsYEzxmmU5wGt9AexdNJbGlc=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-67bd1b31789so50162957eaf.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773768805; x=1774373605;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OipRQ9zxvTmfpMfkIU9uvHVnNwcyXRRqK7vPZDKQeZg=;
        b=TWWyXE1hbKyrTUm/2q1iEPryVoJCK4bhMr1+e6XjABSfAs95H7DnkTYK36nf2pIyub
         HnnOKQ5hmkCcFg+gPMEtqlzXpc3tTK8o7vgPXeVG/CXjjRQFLjbPMpp9WyUlo+uvrjpO
         4FxTh0inriEqSlgCpL+9d5ZEN17ZOnd1cKL/gDmFtkAmy2tKbUSwKaszObZ6t2zKrEDI
         /kcEIaZtoA0k7MIZSsqIjOQS1LEwrxD9ew/OyU+fzryheeQQw+b+aNNqNTUPY5eiCj3O
         fdx0O3mdYmSfFITCzjzepJjFOr8aw2OPGIxGsYIILZCJ05RA4Oormh95AFg3R6mKtmd8
         XSdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtnrlfVGXt4erxItADWXmSQLaM5i13swCPPvvgSds4UZ0YpexTKbtL5cofnlfdGbxfo51vvGL75Q==@kvack.org
X-Gm-Message-State: AOJu0Yxc4ev7C2Z/Zr/6bB06UndWlCw9o1YqFl7Ee7kSr/yjz/HVhMIL
	pXMZ0ocU9O4yrbAHm1TD5QHwyy2b1aDWrgoZlCXW1ZQ8w1bAp9mQ/F39NN9frLRaWJe8V1qJv+z
	oVRwuQiMaI6ROoyJDZRPSn77jDME9G71X9ZAI5oxuu21t7YM4wwDhtscirCI=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:823:b0:664:86ce:df65 with SMTP id
 006d021491bc7-67c0dacf554mr97455eaf.32.1773768805323; Tue, 17 Mar 2026
 10:33:25 -0700 (PDT)
Date: Tue, 17 Mar 2026 10:33:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b99065.050a0220.248e02.012f.GAE@google.com>
Subject: [syzbot] [mm?] [fs?] general protection fault in rwsem_mark_wake
From: syzbot <syzbot+334054c6077f3a88ab3a@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5B540100012
X-Stat-Signature: rmdpmpfbuj5y6m435hpjkyqzag4uhk7o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773768806-166060
X-HE-Meta: U2FsdGVkX1+s5Hdphg7I5sdbPmuNZdIP5P+5tne7kU0WbRnMCwMR9rFWb0bBzd6BXYAiVtucUfQ5h3pNuPw1bkWP1tKkUZ3bBFF7CQR73BPFLzFsvn9rblPiXUOqCQXWKGFaEeRg/IwRXrH2DpyQxmc+27GrwbtiDU+MFiUzHnCn0+qB4Ms+lXEUQa7NxeOg6ii5zXW/FxphUfx8CNExZTX/HSkZFpT5eUA9KPqvvqBxpwhFSdytJMPNOCnEHWaiS5M3k5nmNBQRwj+pIE+USK2WyGjXZbvfiT0AvtMiKaQBJxdPFQkzp8tQ3f1IKqHKbDcYZcwzTetDTb8I0LXcs1YqUyrCmEfiAf/6cKM0IY+90PLAZwnW5GQfV/L1APaYndJVDj/pFvsN4NzqrNObA68B36ibD1Vka2Fcgz02SYINIrUrjWJtGaQ1r3w3HoDUWfBe9qYyTTuJqQuxvCjmWdBNwouIwyH5BctKytrNhGnl0qPVD4OHdLqbXm9Pxq8wdESOlSqwsGhRbcpL/tqFo3OfWnxTHUhzP9ppdoIsJKneSlODHdH3hrOSoGSc+TSnXCnCqrRFgXqM66fflbZKMrFwf7tVHzNTYIyUO0iq5lArFXBQA+h6xHjpYAMivGUM267SQUzUEyefthu74igNmENEYsY5nZw96CJYy67ZqvyZ569FgxF+TA8/yk30+OYORHQu9YXzDJM3KmN2zIpER2NEl4CYHpMwA+PUu3v8Qedwk0HPdwl8iW3okrNXIplvVbaG04Bd+mz3my4d/eTggDmfax0Ipl9xJul9g7BoQjG904l5YOcCqOpcXQKbTGlzQ/u6j6PRgFn2A1Bemhgat62bn17rMjjbL1z46ivCM9FaThZCzEZ8jJtdlwmwjniYWvhOmtKv+bN3C7s30RatBMtUjBrl18X3yEjcR+GwjtnlI9ILEREFQuVWAnMzfVnXFKGN45oATtBPtvxecqC
 QIg0i/O8
 bZrMw9/R9nowH7rB8NZWoYF/9+ZeiaI+VftlzSMPJC/26udJm3H4J+pXrZmWhdYh5m2AdHmebwAs9Met0Tgz8V/m71S30+nT4SYgwyeAjhRQLvbURlYwTixHVbKmNwnskBqPp2LO4KBYDCs+0dCojXINtHIg0zPt+omTnsr3r1EBLZI5KGfqlZSTdH8/hFzTkd6xMDjbUUQ7nOqeRdtLtaV7XC7whhTr6m1Fnx9vIVfsktPi0a1jk5sv0ma5W9MEoV73iykhg5VY2NWBYtfkMzDzS+terLFno1k+eyTTT98iNYEly5OGa4BMfprDytvkxxctoaFmrleeDw7ULxzg8Dkx4HC5wJgcl9u67FWWX071tHzQRdNW8i/bALcSLJ04tCoNEtO/1JzBe8fDKfps0xsAohESDKPncvsc4ycXOLFNOPrtfeaFGv4PBRrusCRcjdp2isx5T0xM3gRHwxyp6uwa1e210Ms0n1P97i949HNLY3wlZI7+LWMkuvmVYqg5+ua6CfJfMVPNkHjv7kX2hOrJiQPHxvuUOx+deiTHE1QHhBEgfkXX3ypB/tne15HqDdtXQOo8N9tBipV2MuHQBm0W9zco2kVnov35BGbT8cVXmiIlCkm67BcEP5F34Px7qwPLRl8f6/QtT/9xaExJaHxiGJu5ZQTppZvPO+fKK6SlCmsh3l4hBKYcdPG9X/Ktwx3QLUB9vnzbYnSw4XlzDzXm17gNIKPvKEKNc24k/E+qeqvlZqmDbK4GALqsQYV35vX4EMYkLjd+B5hjwIzkjPoxF5HaEmro/mILtZjiwdStLS8exp7C7mQ1NcltvjeuhF+HeBNj5iXH7xvQ61Po901JoFKLEoIKEyeTu6q4pkhgcminlVLpUhA08ir9AS/wDyLP4oX0R4eOX8Ja2N2W5EFa/EklxrA80/XnzxE+6Cvsv4uAen+/7+kthiD5BLDf8phtADgTG4yVYQSIdt9G+085yGsaY
 G4riVYVL
 tbo0+qNWZgcW4YeYV9Y1KE4M7X0xebIMSOZMWwH4gjErUqI4dJRih3v+wjuPjTYQNrATfYg/3TfWDrCOySASPB6E6McsuZeQqb7hVsHK7KQnBXv3ofTmvUJM4UwPj5rARyNRVtsQrhNuy1pEILdO3HwV/w2/zG1kdQwV6JTxrg6v7duUwtpHcYPq6d9g922YQx1aZPJU/j4QI8Niv6lY81lFkGupnwRXiXVA+xwg5aYFOpYFvvTeSEiSVzVPkVzv6APdrkpYCDLlYqDchiX0a8QhBFywpegNnmKNw4HCHK0bnHeJ7rDIEMDqax8H1vJ3aKPCOLT0AGDSuQeGO2m/5KsMAPR+2EFw7sAW3UcXK26Mg1R9jM24tYE+4iXoM4xaXrkGEUAIP4I0bcPAUs259eSy4wlkTuUjZb9esMksQLD4IbjtpKPfYRM3EjxXzmYdBICM1FQA54Tsp2E6KBPvGP7mfmMye8JF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=159fdd52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
dashboard link: https://syzkaller.appspot.com/bug?extid=334054c6077f3a88ab3a
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ee4216580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b478da580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/09145161a8a9/disk-b84a0ebe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b64c254e474c/vmlinux-b84a0ebe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a7c33f5f7f45/bzImage-b84a0ebe.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+334054c6077f3a88ab3a@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 UID: 0 PID: 6080 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:rwsem_mark_wake+0xfa/0x7c0 kernel/locking/rwsem.c:445
Code: 01 00 74 08 4c 89 f7 e8 e4 c2 8d 00 4c 89 74 24 10 4d 8b 26 4d 8d 74 24 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 75 06 00 00 41 83 3e 00 74 64 4c 89 ef be
RSP: 0018:ffffc900021cf9a0 EFLAGS: 00010006
RAX: 0000000000000003 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: 1ffff92000439f40 RSI: ffffffff8e4a660a RDI: ffffffff8c4a5c80
RBP: ffffc900021cfaa0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000439f50 R12: 0000000000000000
R13: ffff88807da38f50 R14: 0000000000000018 R15: ffffc900021cfc20
FS:  00005555890a6500(0000) GS:ffff888124de0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000605000 CR3: 000000007a580000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rwsem_del_wake_waiter+0x25d/0x2e0 kernel/locking/rwsem.c:612
 rwsem_down_write_slowpath+0xa6f/0x1080 kernel/locking/rwsem.c:1234
 __down_write_common kernel/locking/rwsem.c:1347 [inline]
 __down_write_killable kernel/locking/rwsem.c:1361 [inline]
 down_write_killable+0x1eb/0x240 kernel/locking/rwsem.c:1639
 mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 vm_mmap_pgoff+0x234/0x4f0 mm/util.c:579
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6cd219c502
Code: 4f 01 00 0f 1f 44 00 00 41 f7 c1 ff 0f 00 00 75 27 55 89 cd 53 48 89 fb 48 85 ff 74 3b 41 89 ea 48 89 df b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 6e 5b 5d c3 0f 1f 00 48 c7 c0 e8 ff ff ff 64
RSP: 002b:00007ffdcb93dea8 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6cd219c502
RDX: 0000000000000000 RSI: 0000000000021000 RDI: 0000000000000000
RBP: 0000000000020022 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000020022 R11: 0000000000000246 R12: 00007ffdcb93e010
R13: ffffffffffffffc0 R14: 0000000000001000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rwsem_mark_wake+0xfa/0x7c0 kernel/locking/rwsem.c:445
Code: 01 00 74 08 4c 89 f7 e8 e4 c2 8d 00 4c 89 74 24 10 4d 8b 26 4d 8d 74 24 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 75 06 00 00 41 83 3e 00 74 64 4c 89 ef be
RSP: 0018:ffffc900021cf9a0 EFLAGS: 00010006
RAX: 0000000000000003 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: 1ffff92000439f40 RSI: ffffffff8e4a660a RDI: ffffffff8c4a5c80
RBP: ffffc900021cfaa0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000439f50 R12: 0000000000000000
R13: ffff88807da38f50 R14: 0000000000000018 R15: ffffc900021cfc20
FS:  00005555890a6500(0000) GS:ffff888124de0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000605000 CR3: 000000007a580000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	01 00                	add    %eax,(%rax)
   2:	74 08                	je     0xc
   4:	4c 89 f7             	mov    %r14,%rdi
   7:	e8 e4 c2 8d 00       	call   0x8dc2f0
   c:	4c 89 74 24 10       	mov    %r14,0x10(%rsp)
  11:	4d 8b 26             	mov    (%r14),%r12
  14:	4d 8d 74 24 18       	lea    0x18(%r12),%r14
  19:	4c 89 f0             	mov    %r14,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 75 06 00 00    	jne    0x6ab
  36:	41 83 3e 00          	cmpl   $0x0,(%r14)
  3a:	74 64                	je     0xa0
  3c:	4c 89 ef             	mov    %r13,%rdi
  3f:	be                   	.byte 0xbe


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

