Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D54B0CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E756B0088; Wed, 30 Sep 2026 06:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5B66B0092; Wed, 30 Sep 2026 06:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BC06B0093; Wed, 30 Sep 2026 06:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCC36B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:22:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6837C06E8
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:22:12 +0000 (UTC)
X-FDA: 85270038504.26.2113C1C
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33D48180006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:22:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 30uK8agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=30uK8agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790763731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=5ciPoU9g0L9TxJi7K6B543D4kgHHCBTjDma4BORePb8=;
	b=VwdaT4YEtH4CHIuIL0gCeJ/x3Ehtq2e518fmIBugIHvFcW/HKH60vh2qLENNwE3Sa9YmQp
	rqXHG0GGJM3Qra2eIheQ557MAyHccS8LnJ2xBh2r0/UI5hV/3d3Kh4GZvXrvjD4YVYsObo
	rGfJOBi+bJ+ea7ioERZawrWgMLL4Ij4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 30uK8agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=30uK8agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790763731;
	b=CMFGZT80DnysFw6dSBoQ0wZp55aPeBcOYwOafjVtjsM2Q9bn4Do06DT1dHI6Tz7hKd7ljw
	LE7i/7IaBZCItJ44qtuio0h7tmaUZXUynROVixODHqproJOqbX6cvgzQOmOopdhocXQErO
	UAhd7SLyGIhKUzRBb5eLu1EQiZXp5eQ=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ea4c979030so5098447b6e.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:22:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790763730; x=1791368530;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5ciPoU9g0L9TxJi7K6B543D4kgHHCBTjDma4BORePb8=;
        b=KDnroSTAkWXmmHqXHoE6lVLaxd+Vs2SKvUvQnRcjXRw8f2tGpTyL7vNrl8XAAqWj2w
         rQ6NeiwzbXtx4pEuIr4hWnDeRxL8sH9/wZnRfeTvkTCP4mRsqeqYuadsxYddaTzuJaAD
         3RQMbcz4ucdv8qTPD2o1PAyBf/AbqLcbGTTFen4ExOCz0of1CGL9389JlCnBdzp3uAml
         UiRCMPh/D0JhxjGvCH9FNlrlPxxNNhcV1tpzHWeOi0rdDIrPsQLw4WN77UuX4m3fjzXo
         xAvwcVieW2VKqW7RqoP4zbs053U8CDmG6mld1ku0cdvrHnwvjP2YZZojl6ApEwBaX7Lz
         6sMw==
X-Forwarded-Encrypted: i=1; AKwUvBx4zfEIZ+snsPp9lxAMtm2+vdO7kHv0rnV44uE5s480jii0DyIbuP4dHKw8pL5GFZyKLUKN2+ERSQ==@kvack.org
X-Gm-Message-State: AFuF++mJPYrLejZ5Uql7bcMwBvCNaqcQ5cBzqB45/wnYW8kL7sIHTyRq
	8LS5L6/xHt35cTZIKEheGBAfL8LSA4BK12GPcmh/MDomcpxtoakJD9vSEhYo/KUFKUvJzZYDmVU
	PxhjcbD2cDCfnlwNRUQRPWWcF/wMovzyGtuqxAbrhIuKXI4ZqMdhWqylInHc=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c3d7:b0:4cb:f21c:a794 with SMTP id
 5614622812f47-4f1b5dd6029mr744708b6e.28.1790763730224; Wed, 30 Sep 2026
 03:22:10 -0700 (PDT)
Date: Wed, 30 Sep 2026 03:22:10 -0700
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abce2d2.64639fcc.9812d.000c.GAE@google.com>
Subject: [syzbot ci] Re: multiple-filesystems: prepare for changes to VFS locking
From: syzbot ci <syzbot+cifa06034fce36fce1@syzkaller.appspotmail.com>
To: a.hindborg@kernel.org, amir73il@gmail.com, anton.ivanov@cambridgegreys.com, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, cem@kernel.org, 
	coda@cs.cmu.edu, codalist@coda.cs.cmu.edu, fuse-devel@lists.linux.dev, 
	hughd@google.com, hyc.lee@gmail.com, jack@suse.cz, jaharkes@cs.cmu.edu, 
	jlayton@kernel.org, joel.granados@kernel.org, johannes@sipsolutions.net, 
	kees@kernel.org, leitao@debian.org, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-um@lists.infradead.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, miklos@szeredi.hu, 
	neilb@ownmail.net, ntfs@lists.linux.dev, richard@nod.at, 
	viro@zeniv.linux.org.uk
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33D48180006
X-Rspam-User: 
X-Stat-Signature: u1jtnfy1azg7fz6id3z7qzd989p539wj
X-HE-Tag: 1790763731-75257
X-HE-Meta: U2FsdGVkX1/IYlJFy9iuKO4ghGW9ixDYzFI/8Or7d7e/oAMGTbmvB+ZCWXUO9h7glygl76PM2FOApmjmhKAhXxxDuayTBq9QoZNwQny6wF+sSqjnavSm+ASIrrmxrAJG/ihzZ8XowbVmXwD/J1bgDPGMBCQRVVWf4MnQvRPLTsiEFK3Fo/Bt+0n3gQg4AhzD6AcefUeHc/KfGAJfKxy6sdynrEkVaeZgsK+MVGi3x3E5viaOs+bbeq2zA0tyuCG5vGWpDsbo6Cv2UCBkiwLYXMDulhoCS0MkNiBITkSAa+bz6m1slNSKHPgl+/RXvohD4OgR3wPW47QkjV59XJsI1atZld+FQbqpLjXSNVFX7fOODaWdV6pgUCAQRv7NI8NA2zoS6o5058SYtYpVFRw9dMPOT0x5HjZRpyS/pmNOsYlA71pkZeNPIimH9cxCygoGZkX3OQJh8D4+sUH7zzwvX19o60EyEABkZ2V4gIoU323+Cb1QyTnE9ZRdDjePerPzd8mhTkFQ3BcrcvM5P3P2qVuSjuLofrtjW4q+DAjXsukBNMo2Gx3Ue0wgrllKmLC3M2kskMuSVq5D39APzjUI0a+rnve9nNCWM3KfObKpWXVftQugwKHDA70g9AgzafMjrYDZxXH0OlOKba0k+RuI1E3pSrDVhddNQmRw16tc4oPAY/FyQy16LC+9X+4BQIDXiWHdUjr4pkiRYBWaTZl0KsRd1xckR9b9E/duiUhOe4gOwUb+rpOGXF3HLY21B28ii451UPJ7rOn0W+BFWVObS0u7/mrc8w6S2Wx7s3+B8C0sJX/w233PDRgb4qG2LQ1S3v2yCPV/lo7aqKm5G2P3WrM3VrUd5pv4lL5N7hLi1b+X/TXMLzGjKga+YhLeVY958ING+UTQqr0+Td0v7TL0/+tCWynnRzqK5RjdIaQBOrRDgsqQt2syzcFKE1sRL9UhtdrASDbm9UdhITSQkQn
 OjxE2cvI
 J22h+lnkz2q5usDXv11R0f8/atdfTezoHTTYM5AxNflzkyDtNn3qZLhBspsgYk14osa483YK/rAwrO02XmctdVqDSVU5tCb52PPRsn8pKe1fBRbjPielnU6wsO6zhM9ORQCxY0hVINh8lm3eevC/ofarfInFAZ1quhoSJa/FF8EF6q7YVgqz3mgb/ndZ+wRWpU6TdROVZBnilsRJ1F1Qw+6+ZuEv+ZqFu7plQTEYIHEiSg2BZ8YcyWWaghgmvIaqKA68/FUIbcObrQglE9FmAyc/8/i3rkV73sa05Sc/pn8PSyJZzIUw4VMBxuOpF3AY4xdA+VYxI27k+GWRpx78X7R1FCjBnQGLG0uSMx2hPOsm/hEb6DEpO7flUEJFUA3Lzw3/T/w/l1ssN+6SPankKS4u32/Vetz7mKhg7MHgQEDiNqReenAz0QyUxY7GUyjE14Il4ivuQzCa/YtgehtcWv2DkvAQF8cpUxFUNSqbdbW3fhba6nieUi8pk49/9qcr2l1UBMK7drE3EK/eN1ocBpPfV6XLmhgNufwiv9e18FP41OVI1/Rd+wHt/tVvrvHByo+cLiEQjxDS1buawMBG62ZSpkzTds6E7OYYr4XrWnT08IX4k7hFi4GVjwd12v8oXNe0vr1tLHIp3BmNkKOcAaqO8LyUo2COdUzaozT35H1hJVB7vPlSCQCwfgkbCTtwnnApSWegmiw/Nl1B+uZT2ry6R7TvFCX5JyNR3ayXa8xBnweKzf8Fmb0JxSCnPv3CGbrM6f9OYxAHxbD6ufv/NzJQdL2xUJrYO/cgHr1pOQfssj2ISJ9cDpL/i7oBWoNQhpVdHO9p7c48mcCt/NgNm6OmKDaDeMfjU/zJmf7PBvLI3jnyn6bBlK6OayNz7OF2bYk2JGkwe2EKDKMdkuhux4kszGCvgu0JiQnkpvgSscfftu7NYmUM4BS0NyLgHWmDXhZEkvXPbJfDy/kO2op+SsLw55vmS
 W6RbjSn2
 WY6DumRvuInedQxQXhW9NQqBcc54qWOXEbaV4yIVA0wzv23BizLpag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] multiple-filesystems: prepare for changes to VFS locking
https://lore.kernel.org/all/20260929034158.1455429-1-neilb@ownmail.net
* [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel() in d_add_ci()
* [PATCH 2/7] shmem: use d_duplicate()
* [PATCH 3/7] coda: don't d_drop() early.
* [PATCH 4/7] configfs: remove d_add() calls before configfs_attach_group()
* [PATCH 5/7] hostfs: don't d_drop() before d_splice_alias() in hostfs_mkdir()
* [PATCH 6/7] procfs: drop parent lock for d_alloc_parallel() in iterate_shared()
* [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().

and found the following issue:
WARNING in __d_instantiate

Full report is available here:
https://ci.syzbot.org/series/b87296ff-c49f-416e-834c-a886ea8bd6c3

***

WARNING in __d_instantiate

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      3879f51857325da9bf3cfb073280257cd16ae067
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/dd8fcfa5-13f0-458f-bd3b-9c06d4d67a78/config
syz repro: https://ci.syzbot.org/findings/fdffe42d-ac1a-40d9-b05c-014808f5b0ec/syz_repro

------------[ cut here ]------------
d_in_lookup(dentry)
WARNING: fs/dcache.c:2197 at __d_instantiate+0x3f4/0x700 fs/dcache.c:2197, CPU#1: syz.0.17/5823
Modules linked in:
CPU: 1 UID: 0 PID: 5823 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__d_instantiate+0x3f4/0x700 fs/dcache.c:2197
Code: 03 41 80 f6 01 41 0f b6 ce c1 e1 0d 09 c1 89 0b 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d e9 03 26 96 09 cc e8 0d 84 75 ff 90 <0f> 0b 90 e9 7f fd ff ff e8 ff 83 75 ff 41 81 cc 00 00 01 00 e9 34
RSP: 0018:ffffc900038d73a0 EFLAGS: 00010293
RAX: ffffffff825242a3 RBX: ffff8881b4eef380 RCX: ffff888169801e00
RDX: 0000000000000000 RSI: 0000000001000000 RDI: 0000000000000000
RBP: 0000000001000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200071ae6c R12: 0000000000280000
R13: dffffc0000000000 R14: ffff8881bc29f3e0 R15: ffff8881bc29f3e4
FS:  00007f15d1af96c0(0000) GS:ffff8882a8cc9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 00000001bd5c4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 d_make_persistent+0x8e/0x180 fs/dcache.c:3139
 shmem_mknod+0x2d4/0x340 mm/shmem.c:3851
 shmem_whiteout mm/shmem.c:3982 [inline]
 shmem_rename2+0x267/0x430 mm/shmem.c:4022
 vfs_rename+0xbd9/0xef0 fs/namei.c:6219
 ovl_do_rename_rd fs/overlayfs/overlayfs.h:371 [inline]
 ovl_check_rename_whiteout fs/overlayfs/super.c:593 [inline]
 ovl_make_workdir fs/overlayfs/super.c:713 [inline]
 ovl_get_workdir+0x93d/0x1980 fs/overlayfs/super.c:836
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
 vfs_get_super fs/super.c:1405 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1424
 vfs_get_tree+0x92/0x2a0 fs/super.c:1947
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15d0b9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f15d1af9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f15d0e25fa0 RCX: 00007f15d0b9e159
RDX: 0000200000000440 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f15d0c3506b R08: 0000200000000080 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f15d0e26038 R14: 00007f15d0e25fa0 R15: 00007ffe9e1b3308
 </TASK>


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

