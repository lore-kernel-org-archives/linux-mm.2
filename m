Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CFCF46446
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198636B017A; Mon, 16 Mar 2026 06:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CDA6B017C; Mon, 16 Mar 2026 06:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B206B017D; Mon, 16 Mar 2026 06:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E15926B017A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:22:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 703E314012C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:22:49 +0000 (UTC)
X-FDA: 84551537658.08.B57D015
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf11.hostedemail.com (Postfix) with ESMTP id C59D440008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:22:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 39tm3aQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=39tm3aQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773656567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=hH3c+Gp4ivLrCpLOJPCjZZpSkkhRXUH4jhppXYc5kC4=;
	b=DCSA8C/96lkXUgs4Wf190Nc2IlJvX2mYAH27n8cXYZPt9SJFPTaXUBay1n3t6cEJkrqBRu
	wCERzkgNhN/FuisCETPdfBt63a6DSzPySl46II+EufM5iRV/MLR13R3cI4bJgerK+lnKnT
	sp4fBzrixJMyoAF3JYLdq+ImbfrpkVc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 39tm3aQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=39tm3aQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773656567; a=rsa-sha256;
	cv=none;
	b=LWrueoB21bsBm9yWhbcKqCa7T3cEHCsd7BnygSsqHattrYPuwWwZ0H0vw5G864jiFJpadb
	m3qRPcbUva2kHbAOZ7EJp1IGUQRQ/jxZxop1RZ6dD0tvKVCC/htQwRrlXmT8GHCGnI8RzB
	mZ6bYwyyDCiGkghZ5ixdXrJLwwVzcgU=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-67bf2b72878so18077535eaf.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773656567; x=1774261367;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hH3c+Gp4ivLrCpLOJPCjZZpSkkhRXUH4jhppXYc5kC4=;
        b=Xt9Er6CMNNsogi4YQvJkR1yOCl8Rgo/8RvDL3gwZfL8nHPAMkgkZWQT1PqpdHzbElv
         oz/fUG78Alehyd6DDPUVi2+pyU2/OXi7qaeD+VcARY5vqYniOMcN4mTO/QTpRihO3kFX
         dTKXjwpHW5pxQ1WwVDfp5uHnFa6K++jmkdJO+G/sBRCbkznONMBn/WTmKsUbo7ioOqYL
         VGXH6KEpN34i1OtFuFtKaCP4xFpfqkjpoly0L8P88Hsk95H8T3dwWYwFZUb9ohDKlvRA
         483DFqf1gRb6nJc2gdGm2VerUmcsPTmaFecCWaYae6fzWYeBjBztwTkIqynG2nNoYLej
         gcUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgVHjtm7WiCI+t1Z1JzNCcVtunkQfzEdX9SbaPYeBSlhMxCHDPX6xp9QLj/m2mA9I/0GY52QQwRg==@kvack.org
X-Gm-Message-State: AOJu0Yw62xpli6DJ3wr77zAQ0f+bnu8A73Sa4x4Z3dtvfYL3l6dTedPS
	pWA+tTb9eiQT6bDipzICwD4G50Yx4KsKAvxBwViAIJ5XN/+DvxrDoBa5FYf0qgtOf7LGfN9BWml
	U2D415NlS43UPdkUn0tzL9XMu/qPkslcalU/qTis5LUWFG9JsPR8wBPGOpcw=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:98f:b0:67a:405:7ffc with SMTP id
 006d021491bc7-67bda983ab1mr8550309eaf.5.1773656566684; Mon, 16 Mar 2026
 03:22:46 -0700 (PDT)
Date: Mon, 16 Mar 2026 03:22:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b7d9f6.050a0220.248e02.0112.GAE@google.com>
Subject: [syzbot] [mm?] KMSAN: uninit-value in copy_from_kernel_nofault
From: syzbot <syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C59D440008
X-Rspamd-Server: rspam07
X-Stat-Signature: zxsdy1cbfx3atqhwpc498tqzds97emck
X-Rspam-User: 
X-HE-Tag: 1773656567-518091
X-HE-Meta: U2FsdGVkX1/Y85X72WF2fQJzQuMFyuGE/qwdr0IoBEb8A0UQObpeQOY/N8lOv4sCOAD34Xp9REPFLVZcwr/kMOt3BbxGXfDvI+OwjBrZLra0dmpIgetU/6EXooco2qlv90SI+OKB93PiKeekKcV1E3edI4aa0TKcLYfRXXfLfZkFe6l7q7eDcKjfrOfBUbyNh+OzpVDVrQtZxMgD1UgqSjMHsInwNfq13V+0uT+Z+Oe4c5P6GSdsPE0uGT/6NjKC5SsUof/wa+7RxBF/KXaPCpcNJUvtedhww8zFAJu9+vJBUfkYXmEMsY0Xp1IPbtmzNqCKYOjnB6jX8fj/EHMkfaG2I3PBhkzrsaA96V4bvWkuwVH1JzaMqXsHAZMfuW2WrcYwfryLqtTbQ6ECw+/0TH/7FP8MaT5Qe5CuHGFXIWBxuO+GxJ3lISPO9prijvOfu5XWqy1yFYJ1BEcdDrVf11psOWQlWpC1oESwiBtcPbwhAh32xNDxNy1QyIqYPcB+SZrE3tmYOYY6a5j4yR2N4C3zTO2iXu5vocRUVdW9+dtMtVOltlkR8howX0RcObEllwMh48uRFBMH8XPsGHLICRSzYstoFvxQswwiLrKi7i/TNC/txNWnIE1j8u23Sstb4vlcsk1ZVe8Iozw2u9wEOOphLofNCxdpGFQobfR+ghRKTcsnh1Hbalsor0O0542cRclHZ5kvGT7Vm86VyNaTeIUVpoCOoALxcrUqGVeuqQYkfPOZI+4AS6vfCzBRLCE0Bw/MPeohxFmIWZvaSAUh+3hsbjLq0MQuBH8bCknsRA8eRgrio0A9fK2XBmQlQ39aKggrIMqm18sYMm33t9ISZxrnx3aEXVWl9Dv8NgfRiv5aR214Y6WbnMC+TJNtPT4jxjnp8wiC2Y5X/SpyD1eX7jqXFdy0MRxjExMJ43hJPwluPq5tjjEQYSn9mOjtw+AxwwgFKijuH4sHfrDQ9y8
 XGJsTCv+
 9nRps43s3q5VwKGb/3N+EXTU6dWgYNZGOWEl5gJom2CjpHmh0RIPhSQnB0pf0CzNdA9WyWL59P4ZDonJxJNo8NQuWi1RMbaPkDupTr+jQZB4sW4WWWHhqkZgJG6hLCnCkxZ1rJXzszP2qm3s+DxAtq/3mIhwm1QEIuiZK4dljsP+lDdbhEcIimfMwfeDkL/ZQn26MDB0myTkQH9lyl9Vtu3RNOv2FI1h/wFFdcGUgS2yKbKRAs74n39olQjbKemNm8zwNcQbwJJkwIUaWZKeHpWYG6Lkxb7e0+qUUy1AjlXwm9SmKw34Np2dVLN1UWHaydn3pyaij6hItF4ZSjMIDTjEBZ8RN/dagZRas8Zy82xFFSQ8KXyV+VtkISpqQAz1l33D3GYuaXTTw48mQuq8q8MO4x/kSxZ1ybBTeVteVK7kT2KOdMbZiaCWm9K6V0HvubDqcYFaVIXeAj8vGzyf3EuNrrsaKMlxHXFwhcKs8MfYtrXWLOUwjou+RqWj2rfXhJ7UARCdk57XDfXe8xvXDoBAdPcvd5jNJ7b/qobGFGBZ2EmvsWFFPGEagJG4GWkTWmQrXRvVvVFKFl4Ah4XU2mLWvCLCUpzQKZ7RLNSTXHE0+rbjabE+mfCMFGmlNu0rZHaMqRL85mStvgWJstg3US+R6FsC4KkYDeLSiS/CXeh514wQd7uOdXnKPx2nB5jhm5+uq2oCJ8L7+xs4SL7BXSwes83gJmPbb916mL37UB1vl0sQFVEcpBQnp8G971q9rF1+XJuMzZzt+VJ6IYvrL8fLNaX+JtQ/sjmFRX9l2f646dx+yb5Bhk4O1/j5Ivm4hs0LvEPL6272pIv4OS8MNbunMKUTJZXuPQ7wQ+hE+iHJKgF01cJA6VRtatuF9YZnqzhAppHHosj5cvbreRNVAbmzNL0xRyW5Q1DY1o0SKflmjNn8yp+okXk5YWfFTiuQzqYPTExFbsSKXmObQRHq7mZDKaBJq
 oWYIpdoO
 ZrPyhAfFEGJ+Uah+cmb7uCGzxWk3x5cbESkIsGqQKM3ogf08tc/b4b4MJulzI1ZeyDRQoReXh5X8SmhOg32aoCwc8+bgX2Uk7x+2nXHEacfS4F8iBUpB/ulAt+KriMWc8k/r9FFdpcJ8U01TZ2PLZaS4uL+Eht0bsSwHWqas7e3yKO0PKGRLg9jSFolH82kIZ6yZmz1EXJUIJJY/9HOg7LORYdL9eL7BsfuspoxTOgboMnFjleyuhww2wx6z9lha0m/TjG8nPDjhnk2pady5j2gcbfmgk5UEO+fGm0Cjfs6Yw6qXWWtN10cELcsatctk8Ynky05MJC+ImFKig0CVw4cJwrt5Iv33Dcbe2mlPMULgqa8Rl1ysZQw2Lmbisrc9kU/8ARyCdv+HAHU0IuJyvRbPASemTf9EUUMsADTjVClng3CevtnjtdUqB0E9Gm5Mh1TiOvY8mbec7/NUo8Xhj1wcqbvHIHq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    80234b5ab240 Merge tag 'rproc-v7.0-fixes' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1474cd52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=242f02fcd3fbc8f3
dashboard link: https://syzkaller.appspot.com/bug?extid=c18de0ad13d62f18469d
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a0d037332dff/disk-80234b5a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0a1f7f8b54f8/vmlinux-80234b5a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/83eb68ee6421/bzImage-80234b5a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in copy_from_kernel_nofault+0x15f/0x570 mm/maccess.c:41
 copy_from_kernel_nofault+0x15f/0x570 mm/maccess.c:41
 prepend_copy fs/d_path.c:50 [inline]
 prepend fs/d_path.c:76 [inline]
 prepend_name fs/d_path.c:101 [inline]
 __prepend_path fs/d_path.c:133 [inline]
 prepend_path+0x64e/0x1090 fs/d_path.c:172
 d_absolute_path+0x11b/0x240 fs/d_path.c:234
 tomoyo_get_absolute_path security/tomoyo/realpath.c:101 [inline]
 tomoyo_realpath_from_path+0x4bd/0x9f0 security/tomoyo/realpath.c:271
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x249/0x9a0 security/tomoyo/file.c:827
 tomoyo_inode_getattr+0x35/0x40 security/tomoyo/tomoyo.c:123
 security_inode_getattr+0x16e/0x590 security/security.c:1869
 vfs_getattr fs/stat.c:259 [inline]
 vfs_fstat fs/stat.c:281 [inline]
 __do_sys_newfstat fs/stat.c:551 [inline]
 __se_sys_newfstat+0xd5/0xa60 fs/stat.c:546
 __x64_sys_newfstat+0x78/0xb0 fs/stat.c:546
 x64_sys_call+0x2f28/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:6
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

<Zero or more stacks not recorded to save memory>

Uninit was stored to memory at:
 copy_name fs/dcache.c:2861 [inline]
 __d_move+0xf72/0x2aa0 fs/dcache.c:2930
 d_move+0x71/0xf0 fs/dcache.c:2977
 vfs_rename+0x2510/0x2650 fs/namei.c:6041
 filename_renameat2+0xb7f/0x1260 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 copy_name fs/dcache.c:2861 [inline]
 __d_move+0xf72/0x2aa0 fs/dcache.c:2930
 d_move+0x71/0xf0 fs/dcache.c:2977
 vfs_rename+0x2510/0x2650 fs/namei.c:6041
 filename_renameat2+0xb7f/0x1260 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 copy_name fs/dcache.c:2861 [inline]
 __d_move+0xf72/0x2aa0 fs/dcache.c:2930
 d_move+0x71/0xf0 fs/dcache.c:2977
 vfs_rename+0x2510/0x2650 fs/namei.c:6041
 filename_renameat2+0xb7f/0x1260 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 copy_name fs/dcache.c:2861 [inline]
 __d_move+0xf72/0x2aa0 fs/dcache.c:2930
 d_move+0x71/0xf0 fs/dcache.c:2977
 vfs_rename+0x2510/0x2650 fs/namei.c:6041
 filename_renameat2+0xb7f/0x1260 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 copy_name fs/dcache.c:2861 [inline]
 __d_move+0xf72/0x2aa0 fs/dcache.c:2930
 d_move+0x71/0xf0 fs/dcache.c:2977
 vfs_rename+0x2510/0x2650 fs/namei.c:6041
 filename_renameat2+0xb7f/0x1260 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 copy_name fs/dcache.c:2861 [inline]
 __d_move+0xf72/0x2aa0 fs/dcache.c:2930
 d_move+0x71/0xf0 fs/dcache.c:2977
 vfs_rename+0x2510/0x2650 fs/namei.c:6041
 filename_renameat2+0xb7f/0x1260 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 copy_name fs/dcache.c:2861 [inline]
 __d_move+0xf72/0x2aa0 fs/dcache.c:2930
 d_move+0x71/0xf0 fs/dcache.c:2977
 vfs_rename+0x2510/0x2650 fs/namei.c:6041
 filename_renameat2+0xb7f/0x1260 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4549 [inline]
 slab_alloc_node mm/slub.c:4869 [inline]
 kmem_cache_alloc_lru_noprof+0x382/0x1280 mm/slub.c:4888
 __d_alloc+0x55/0xa00 fs/dcache.c:1740
 d_alloc+0x57/0x300 fs/dcache.c:1819
 lookup_one_qstr_excl+0x1a1/0x7b0 fs/namei.c:1801
 __start_renaming+0x38e/0x870 fs/namei.c:3862
 filename_renameat2+0x735/0x1260 fs/namei.c:6119
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0xc5/0x5d0 fs/namei.c:6184
 __x64_sys_rename+0x78/0xb0 fs/namei.c:6184
 x64_sys_call+0x329/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x134/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Bytes 5-7 of 8 are uninitialized
Memory access of size 8 starts at ffff888014109578

CPU: 0 UID: 0 PID: 5966 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/27/2026
=====================================================


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

