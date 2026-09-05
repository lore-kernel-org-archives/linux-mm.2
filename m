Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC3AC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 07:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490166B0088; Sat,  5 Sep 2026 03:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441646B008A; Sat,  5 Sep 2026 03:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3558D6B008C; Sat,  5 Sep 2026 03:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03C576B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:07:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEC4A1202D8
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:07:02 +0000 (UTC)
X-FDA: 85178826684.05.CAE0EA0
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2302D180005
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:07:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3lL-bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3lL-bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788592021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=nnvwnS1OPKAjnbL2Ffg9wjdt+AOLqiiejT+aXhRtPlk=;
	b=xzNhpYyrNKwT3BHaY5xWCslOfRIWXuqf0JiXy1o6CyFdhjGJ+oXhg5AHjqiGTowKbJuV46
	WhnnUGaTJ2pdH9yohpPL0/A0VDEUbjGRlNFkS2P97moWtUNFkr8mOk1A79dyeLBaoIT1zx
	SNJFFFKmxFSO7qKJySFzYWZKPgWs+mc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3lL-bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3lL-bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788592021;
	b=1tMcfbkGkdQnguIGVmeSwOHJS3Cf2MaMBhuufpXlcvhfHHlDMpdmADkjGjna3WUr50ElfI
	4ONMIfgUHoGbLhh8SPBD9VY7vcCkNvZWMge/+ZIawxF9jnf2iDpyglroEMeWzpAuHnI2R4
	jMyLbgVm+2fvlHRMSnSssdoWQOYEiSE=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6b13ff9c9aaso2038057eaf.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 00:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788592020; x=1789196820;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nnvwnS1OPKAjnbL2Ffg9wjdt+AOLqiiejT+aXhRtPlk=;
        b=iNYggb6vUyLRTXx6KaQJhMKniF4gDgmPVuwAbYcLglPXzy+S9AJHR0eMOzNkEG7e6y
         uFBh/YdEV1podFxCu1efYu6/AUpRtADqtEuy/S+pyIMkSk8yKPsRvmnUkmF4HU4KCeKX
         rk6wbZCsDQnXggw7i8Xr/XM/jI7QQnqRjvOo0DPOrsB5Esfn6n55AjFxcFhqvWQ/AMsb
         ZdSvNhDWTT2aCw5yuTquFMa146Xvnc9WVIOMmwuHXG8y3kHx77lA5DR4og0BR9y8C6OG
         AxMWrjJL+GD+jk0N9Ausgf3LGt5gMOD5sLOjw2MH3GJl47CxDFj69pGxDRoGVnH4hVsN
         Q3BQ==
X-Forwarded-Encrypted: i=1; AKwUvByOFvaq3QO/GWb15LqywDKd56CV91ZXbp4Wtk1Mm7IJJwDjU9sh02pOteerAwwc62qzoADXJkrQhQ==@kvack.org
X-Gm-Message-State: AFuF++mFKOGuJQjCm8Cl3gsqnu6TqfIr5eQnyTYvuibr4VCL0h0NMwZB
	ZushN/Ii1xVWvpWkzYDIFkFTd+G20YLRkoFVZe+yBxdMEPDS9ygafpavODegnVDTSwO0jgAU92E
	UtvTSV5VBW3dhUVVRLNti710LZMyKzMNp7MzGCovb4+9EnbdCCO3jgcHhPl4=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4cca:b0:6b7:8415:d790 with SMTP id
 006d021491bc7-6b78415d8d8mr4693626eaf.59.1788592020180; Sat, 05 Sep 2026
 00:07:00 -0700 (PDT)
Date: Sat, 05 Sep 2026 00:07:00 -0700
In-Reply-To: <cover.1788438786.git.qiwenjie@xiaomi.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9bbf94.a5e650b3.26d8a.0006.GAE@google.com>
Subject: [syzbot ci] Re: f2fs: enable buffered RWF_DONTCACHE
From: syzbot ci <syzbot+cid5582b8164122eda@syzkaller.appspotmail.com>
To: axboe@kernel.dk, baohua@kernel.org, chao@kernel.org, hch@lst.de, 
	jack@suse.cz, jaegeuk@kernel.org, linux-block@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, qiwenjie@xiaomi.com, 
	qwjhust@gmail.com, tz2294@columbia.edu
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: aes51x8ia93pgxm5cha4g1o6h4is7tbb
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2302D180005
X-Rspam-User: 
X-HE-Tag: 1788592020-123492
X-HE-Meta: U2FsdGVkX1+OZg8hrqQxU7iKe2y2X749iwNqWn9FKN6Dek95q9Tj8uyatw5OqJN/pl5J3wnP77KLtNktwsPMM9gOuShnu9PHpgO4xr52aAtZtexk5j13p480W0e8YShpQIUhjAyezsn+iLkiipDiZpOByeGPTqkkaA3Hqo0PUuyuE0WRDZJFy+eC+727mAFPPTvUefB1nY7v/4B+DuNV9oL9m+r7gF1+l4BdN74kkSMQtYODQpQ+nxc/C1mz2AAdkJ5MjatwnQWpYV4xXKaoJejZGmduaZOMgiFlSu9gI7G3o1M7oy845p39eYJ4H0jXhAvS6PTXN+iiLWyEW5pbwXTzxt5GXgZGfaMImUxCBfKymDQZ1NfPIwxleJM0CM4wWCtEEtA9xcwhTX5ti5mDAQbpRmSDT1kIvu3/pqTiwSW1Js4SOKUiq64MAtRAoS8QIO9Ab1YUxbL74c18hKldDuh67+M5SzFQ/ZIs5FjKY/ym1BsCdeU++V+yzF57eSu+5JDEBY8eJQPpKkTTjnxbzBbRR65dGLEsJA11jEvg1B/NGEnEyHiLcU2Ohjcn5prn2akr+lJCSB893XKmIJxLETa4rlujJz/3zX3bWsl/bng9XxHherRzsKJM5y2WSThIerIEoNBXNoDzbOKSGm4L8HFsZytExDGzq+IoLrrmBpxFDMd69SgY+oHwiFvmmJ04yyZpyOifm/2TFHF0YIYx1/Amis4eShEGDuSubV8dSTL3uVoiH7J8tOGAGcb8e184ZaLITulWM+La4FJf44AdQ/yKOA9ge+Yd8gqfzreVDMYSKt759eNGe95LOg/kfq0Z2WNGv7NWERT32ceCoOVN+wgPlssXeeGDOdX4jG8HgC2hSIaeRVzTLZFHMQ932MrMI7lT9rFtHMtxt8YGy5UpKi8CwxYB/lU6k7DIXzGO/86dRKhl5FcuDJqbBlgUKtS/F7FH9ZK4Se3+ei1WLiO
 q2pkJg8K
 uSbWUQ6LynaI5XyVgusqfPOP8xD4yPcVonpkcbR1z/z5AoWhrhjLDrI8A9hvl+vDFr8jEqlIkNM88eAWlRHwWYCHOfV168+1k1Lwz6USld8vkJcND8JToM21E+uAyXscVRyIxWbcGU1ySi53MW/O98DyiOAULy+XbQLUQyVX14aJFNMjYfSYHTbUQBRGlzFSxUVvjXj7F8hVp1okIHw68+vQHO8bb9+XT1+jIzAdi2+BhDB8NLD8RcOZlyhO96JiuCv6fA3F8RW4kPJa2weDt4XYfAh7JokkgDT4bjstKn5Jb7ITZ6wN8RA9tHRksVi/L1Vm9/5L9h5mIsRJydlb/8mlW4p0ejSWKxQBhQpdkhXMPVKDxyzivgjSeSNxdjv1dAKFW5l2h8D5uXIvY1W+3YvjqRwXNgJX8M0ScTB9oEFCpnkF3t1wNrm9j+ySPuMj0yXVWOasn23TJHOywe+8QNAAlcSSsrwC/Bs0hhmLDo73VGtW9STP+6CzRU3ZZ2G9AzVg/cm+0X5eWowIQBgEXV9ARlJnEvya9c1sTv/0pszQDCUmaVrp92UJafvfBC3O7xtPevqtXmxq9jKzSH4U2Gjq5uOj1UDFB2uypyPXJD07M37vCGSjYdNM57MmJlL19bGD8lWmebjLib5otb91MGs/Lm8WZ0xXgvd7hm+ll3/LkFmlEQOfMcEzu+oGc21y6He9lf8f34Bbs/Sq9GNwWpcZmR6P+o6axIJCXpzDTVFn1gwZk6lq9IUxxyPZ7LU6GRtJewsOd3G9J7fIL1ynurY0qCJOfCEdI83Nq/CAjwohArP8XCVDPCZ1awrhr9++vKrslJKUEjm+JRDo1rOe+lTJQHAEsiCLpPuvu6YUkewcj+EaY/hdyuNJa09ddWsXChFUZ2MDL/BnaQo7Oqu4kNBL9hdBB+OxnlBhRSwrlLmhNHKboiwzQ2B8VpLq9bnsxSHLOuy2BPrIrplwqp6X4prZvqqRP
 MyaxB9S5
 JTWiLCw1NQ5bCLrmNsSMMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v4] f2fs: enable buffered RWF_DONTCACHE
https://lore.kernel.org/all/cover.1788438786.git.qiwenjie@xiaomi.com
* [PATCH v4 1/2] f2fs: complete dropbehind write bios in task context
* [PATCH v4 2/2] f2fs: enable buffered RWF_DONTCACHE

and found the following issue:
general protection fault in f2fs_write_begin

Full report is available here:
https://ci.syzbot.org/series/cbb9ded8-1388-4a7b-bfa7-44082b04025b

***

general protection fault in f2fs_write_begin

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/e5903709-6ea2-4b1e-9dfc-f073e36367f7/config
syz repro: https://ci.syzbot.org/findings/d05a5d64-e9a3-4714-9b41-43042eaaa82c/syz_repro

loop0: detected capacity change from 0 to 40427
F2FS-fs (loop0): invalid crc value
F2FS-fs (loop0): f2fs_recover_fsync_data: recovery fsync data, check_only: 0
F2FS-fs (loop0): Mounted with checkpoint version = 48b305e5
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 UID: 0 PID: 5791 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:f2fs_write_begin+0x181/0x28e0 fs/f2fs/data.c:3893
Code: e7 e8 23 21 d4 fd 49 8b 04 24 48 89 44 24 40 41 c6 45 2c 04 c7 84 24 a0 02 00 00 00 00 00 00 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 e9 23 00 00 41 be 80 00 00 00 44 23 33
RSP: 0018:ffffc900037af7a0 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff8881b465c918 RDI: 0000000000000000
RBP: ffffc900037afad0 R08: ffffc900037afb80 R09: ffffc900037afba0
R10: dffffc0000000000 R11: ffffffff8463a450 R12: ffff88816b91e678
R13: fffff520006f5f1c R14: dffffc0000000000 R15: ffff8881b465c918
FS:  00007f65b5e096c0(0000) GS:ffff8882a8cd9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f65b4e70050 CR3: 000000016a860000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_symlink+0x27a/0x440 fs/namei.c:6556
 f2fs_symlink+0x5fc/0x970 fs/f2fs/namei.c:714
 vfs_symlink+0x18b/0x330 fs/namei.c:5794
 filename_symlinkat+0x1cd/0x410 fs/namei.c:5819
 __do_sys_symlinkat fs/namei.c:5839 [inline]
 __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5834
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f65b4f9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f65b5e09028 EFLAGS: 00000246 ORIG_RAX: 000000000000010a
RAX: ffffffffffffffda RBX: 00007f65b5225fa0 RCX: 00007f65b4f9e159
RDX: 00002000000005c0 RSI: ffffffffffffff9c RDI: 0000200000000700
RBP: 00007f65b5035024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f65b5226038 R14: 00007f65b5225fa0 R15: 00007fffb6ecc0c8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:f2fs_write_begin+0x181/0x28e0 fs/f2fs/data.c:3893
Code: e7 e8 23 21 d4 fd 49 8b 04 24 48 89 44 24 40 41 c6 45 2c 04 c7 84 24 a0 02 00 00 00 00 00 00 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 e9 23 00 00 41 be 80 00 00 00 44 23 33
RSP: 0018:ffffc900037af7a0 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff8881b465c918 RDI: 0000000000000000
RBP: ffffc900037afad0 R08: ffffc900037afb80 R09: ffffc900037afba0
R10: dffffc0000000000 R11: ffffffff8463a450 R12: ffff88816b91e678
R13: fffff520006f5f1c R14: dffffc0000000000 R15: ffff8881b465c918
FS:  00007f65b5e096c0(0000) GS:ffff8882a8cd9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f65b4feb840 CR3: 000000016a860000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	e8 23 21 d4 fd       	call   0xfdd42128
   5:	49 8b 04 24          	mov    (%r12),%rax
   9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   e:	41 c6 45 2c 04       	movb   $0x4,0x2c(%r13)
  13:	c7 84 24 a0 02 00 00 	movl   $0x0,0x2a0(%rsp)
  1a:	00 00 00 00
  1e:	48 83 c3 20          	add    $0x20,%rbx
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 e9 23 00 00    	jne    0x241f
  36:	41 be 80 00 00 00    	mov    $0x80,%r14d
  3c:	44 23 33             	and    (%rbx),%r14d


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

