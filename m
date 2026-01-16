Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6482FC982D1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EB36B0005; Fri, 16 Jan 2026 11:13:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6486B009B; Fri, 16 Jan 2026 11:13:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F216B009D; Fri, 16 Jan 2026 11:13:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D43B6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:13:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39E791401BD
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:13:40 +0000 (UTC)
X-FDA: 84338322600.28.2CDC4FF
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf21.hostedemail.com (Postfix) with ESMTP id 664A21C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:13:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3sWNqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3sWNqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768580018; a=rsa-sha256;
	cv=none;
	b=yoVRnpEv76ChQmhCZoZ/eyWN26EswTiiqusfQg831FXExaeygIpOQEewSWZEA8lGRdOPhM
	E0mkdhQHx3ZYZzk+0D+7bGRzV3OtwA6PyTZzXgM4452FGgfdTsR5G8Qe5Ngw3U1JhKb4S6
	DCm4A1Rh4k93ecJJGfsEhzp8x3bJP1M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3sWNqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3sWNqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768580018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=GW18BJd0jSvNLSBLK+5GeIvUMjj5PFq3we5kfaKyLBY=;
	b=NozkAIIL8wP708iAgPOJ7ScrePq7MMQoWgY+oq69L/AHQRoNO36zGPPkm1jKvlBcWu4idD
	HDnhhAJmgZ/xmtT0rdjBAP3ZtvtOEQgvplUu1lG7yl6gzBrevdIyMwP7WwA2S3xysciEqC
	tX8gtBkrKj+k2bkoErYswmtojvczJLs=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65f6e15ad5bso5424359eaf.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:13:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768580017; x=1769184817;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GW18BJd0jSvNLSBLK+5GeIvUMjj5PFq3we5kfaKyLBY=;
        b=LFIB1xRQ4AmrGc9pajmvRMf7viuKWVY0NGa/d37cV0X4J7hFIDY2LWv8p74iw4RpoA
         veG8ZHBqRW1B/36y9l05xKNmQ8iso4wisjmQElLEZomh2PLHyD5YJ6kTfLN42CawMq63
         eR80+8biGKXxBv0XwjmPysTnJMk5BvFG/Xyb7UcpP+eSAnPlytuG7bzOZ4wZeMJkiREc
         0QJfv9ZWKlsOZmZoMKT4p2joVIHcESugYRB6BKHdxMPK9giNu0rvp8Aw01XjIo3pKmUK
         /U/3uTNt8MCGWzShbkV23o6wSK5/gu/MQSIP1vdg6vpQA1B8qnlrkgQM1inN6Z3H7/hy
         JXwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL9B6uBOzE2A803shl3ApfAZlTyR0c2vbF3KGG5XiMDfuH/GCJZEmf29uhe/48/0SMIzoPxsz2RQ==@kvack.org
X-Gm-Message-State: AOJu0Yyrxzu1CEa0IdgH4Q3uUBoWhvkMTwccS9/9q9DaJCACM9igyxtl
	ZykSUEiAfoZjTZQjzxHKATnxPrA6rshXcSOS4/9+6eUWLn1I81w0MtjIAPC3DT8WOzOOOJVU99d
	DJulQfWSamS1RPI5jCwJdv3YcSaUNut4v18DLAQALqe5oPG1Jj7G9TusIIr4=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:498e:b0:65b:2935:f935 with SMTP id
 006d021491bc7-661179c2396mr1433844eaf.44.1768580017428; Fri, 16 Jan 2026
 08:13:37 -0800 (PST)
Date: Fri, 16 Jan 2026 08:13:37 -0800
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696a63b1.050a0220.58bed.006b.GAE@google.com>
Subject: [syzbot ci] Re: AG aware parallel writeback for XFS
From: syzbot ci <syzbot+ci4e530c88485a9c60@syzkaller.appspotmail.com>
To: amir73il@gmail.com, anuj20.g@samsung.com, axboe@kernel.dk, 
	brauner@kernel.org, cem@kernel.org, clm@meta.com, dave@stgolabs.net, 
	david@fromorbit.com, djwong@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	jack@suse.cz, joshi.k@samsung.com, kundan.kumar@samsung.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	mcgrof@kernel.org, ritesh.list@gmail.com, viro@zeniv.linux.org.uk, 
	vishak.g@samsung.com, wangyufei@vivo.com, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 664A21C0005
X-Stat-Signature: 4zdbmmhr8reox7e7tr6hpsz15y3izu6c
X-Rspam-User: 
X-HE-Tag: 1768580018-917429
X-HE-Meta: U2FsdGVkX189nxxQv/yQXaU+vWDz7X8kXAaHmQPLwR/BtD8zZidLLMezTtiSNOF3atVWy3HSoaa3AzKP7icTYqiQgc466ix3Dx23Tm+s4XILOH5aRPXNrFKgRcRctKe7xWf+Vav8P1YqdpC6QA7hlrgGImUj81fPSccESAVQzOf/6fdzh64VC67DLIXWx5j8pJBHW0nMyMSkOu8Uk3H8lwGXICqad19GwDFtgxufbnT6vBN7Hv9b7DCIAPtA6XD4q2h+B7KeHXbVgt4krRgDc+jC16SxuvnNIoQpXLLgRXgdn7hj57O+Q5kWnUgEH3esqqy0hJ2X9FSzpxsRKm5Za7ZPlEVpAaFc65whZxzYgsuL5kS/Olwg7kl20c1sxNUE9UUKfgyZQlMIOIwQs/aWMuR86KAplMwpSREGgvDU5vSdsfG9DrdGGsth+SUjtEaIQ2EXcFqn44psQJnI3BaIVb82SsB6Wfakevgp9QP96uUQ1VzHe/MilseueJc7DyVdG9fXZjuJLJkFOQu0ZDrnuMVw5M8INBv0P4zHe2d2imMwn7ZQWmPINIkBuIrycMNIIW9XEGW4VrMyNO9BFjDm7CWfIizGWUy8pLDhI949gYMAtN4NQEfq03NQC18ntBjW6oa+0DD7aQutg+cY5tEUhShaYlVXBdWgYFOvfG6yXue7GWYZfrEwbg3lFBCDlK5Ug0iBdJ6fjsxy++Pdlr7KpSQyUqfeDLyxd4HJTwL+mxIXHto1MTj3Eg1/qqh3s3UQxVOd7u+qkOmZFHB6/VW2cquEcqzqCQbpyEG2GqXJdKBl0CydaVLh2EUdNaTGc0/vJkVSYuWG4REY71oaLvsqyEzgAdRiLyHX2usvB0Z4WLyGK4qHxCdvn+ZKcm8DXx3dMScUOleg7jI50uRc8TuVvWB2YNz0AkJdS3uGKlA/iTO9uMmcNIGhGmf1lOw3SUQLOmYWSmG+rlFRwcU2bv5
 mHyPK3SK
 sUodXLhbJSgzUn7MlQZLknIr143XRRJXUmFSg/HJ9cBlStPhARHW1fm/yXZhWqE8T4z/C1Fpgi3JTCmId0yblgSFGws6X0KVpI7vZ1h1PiEn+39v7VXqPuSMJZE/v18KFQ71NG3p93J3Q+lEtXzHAOB3ZOcZFs/tuT/FROCtKz48pm0Exfenps5KxnNf+4UlcUhvJSjfMxIDxoKl3tQLF2L5dX70LaCN690nrSOa2SQCCygnBczchnNCMbN/wErvcJ89AoJtYfshr9UrrlLbgv0i+5d/7mC15w8ufvjIDNKd5mg4YTzyv/I4ZA8haxbzTYvV73aKajgxgZkmUM5LSgj/X7/gq3RvKkrO47X4O4XdAaPYQ13uYIvFOkl3zCGwj5lwHvROi9HPDoOjnNxkzz0x/woiMulYr5P+05qp4c5ykjKucEWAhWf6AsH52/tfmX01vO+scu8UwAUs4CYx6s3+Vwlsr+EX0uI58jojDlgRnpB8FbcYvVsTqiIIDps/8fig6ycUHIW3iIkFwbM4kB47ToXvqs5psczTSMM2DOozCLLbcYJ8qpxPC0C2dy7axv/RucCm4mgT9Q7225jwtfEZQ9ILpJgIpOgFBQD4KpEYhdaE9eUmCeBbyy8pdbSyMuIYzgjwhHDPoSvrWBLm6lcKA9ElblD7n8DbZXpk7XmjyMYsPybYv40Rmm3dkX5Uc/NiIfQLbUdTOxeg3OTvRw1f+sKILADl7b34pxfM5MmXbdVS1GUC6GiIRuiaAXsTyX3CQHCH1+cf56ZQAX5hvvftxLu4ORBcmI5S1X0b7KoImhFZnk3DyPA4GbyTDUowQ28CHlo3qsOkOsVaHpAJn1Nry7Umhp6oUptzmuNjfIveMHMO3fAjsI+DP7sNqrWCSjPF9VNTmMx5gsjJx03pTZ+v+ni7TJXLhTUqJ+SkogPKW+ZA/czV4yk/JazIAV4P1lzNiGOI/QuqVR0VlLgsd5osrlSoz
 AxtnX6f2
 G1chNqGB2kQAXcEOPl94k8mQSY0la8lBxRYGLG9foEvqi5iRrl+wI4VLrcOwufvjEuxO7AsBBzIHzbSMHILa0f/JEaGfq4jB/ePDKpX8bd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] AG aware parallel writeback for XFS
https://lore.kernel.org/all/20260116100818.7576-1-kundan.kumar@samsung.com
* [PATCH v3 1/6] iomap: add write ops hook to attach metadata to folios
* [PATCH v3 2/6] xfs: add helpers to pack AG prediction info for per-folio tracking
* [PATCH v3 3/6] xfs: add per-inode AG prediction map and dirty-AG bitmap
* [PATCH v3 4/6] xfs: tag folios with AG number during buffered write via iomap attach hook
* [PATCH v3 5/6] xfs: add per-AG writeback workqueue infrastructure
* [PATCH v3 6/6] xfs: offload writeback by AG using per-inode dirty bitmap and per-AG workers

and found the following issue:
WARNING in xfs_init_ag_writeback

Full report is available here:
https://ci.syzbot.org/series/0e34236b-3594-400f-b9cd-6f59b196014f

***

WARNING in xfs_init_ag_writeback

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      eeb33083cc4749bdb61582eaeb5c200702607703
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f21aae46-4d21-4410-9132-190ad8ae3994/config
C repro:   https://ci.syzbot.org/findings/24ec6312-5e15-4750-aa2a-08d381daca26/c_repro
syz repro: https://ci.syzbot.org/findings/24ec6312-5e15-4750-aa2a-08d381daca26/syz_repro

loop2: detected capacity change from 0 to 32768
------------[ cut here ]------------
kmem_cache of name 'xfs_ag_wb_task' already exists
WARNING: mm/slab_common.c:110 at kmem_cache_sanity_check mm/slab_common.c:109 [inline], CPU#1: syz.2.19/6098
WARNING: mm/slab_common.c:110 at __kmem_cache_create_args+0x99/0x310 mm/slab_common.c:310, CPU#1: syz.2.19/6098
Modules linked in:
CPU: 1 UID: 0 PID: 6098 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kmem_cache_sanity_check mm/slab_common.c:109 [inline]
RIP: 0010:__kmem_cache_create_args+0x9c/0x310 mm/slab_common.c:310
Code: 43 8e 4d 8b 24 24 49 81 fc b8 78 43 8e 74 20 49 8b 7c 24 f8 48 89 de e8 f2 c0 67 09 85 c0 75 e2 48 8d 3d f7 ca bc 0d 48 89 de <67> 48 0f b9 3a 48 89 df be 20 00 00 00 e8 92 c2 67 09 48 85 c0 0f
RSP: 0018:ffffc90003817a08 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff8bc734a0 RCX: 0000000000000007
RDX: 000000008bc73406 RSI: ffffffff8bc734a0 RDI: ffffffff8fc6ee40
RBP: 0000000000080000 R08: ffffffff8fc26e77 R09: 1ffffffff1f84dce
R10: dffffc0000000000 R11: fffffbfff1f84dcf R12: ffff88810b7a7300
R13: ffff888115440000 R14: ffffc90003817aa0 R15: 0000000000000190
FS:  0000555567cf7500(0000) GS:ffff8882a9a05000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f049ffff000 CR3: 00000001b9726000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __kmem_cache_create include/linux/slab.h:384 [inline]
 xfs_init_ag_writeback+0x41b/0x570 fs/xfs/xfs_aops.c:890
 xfs_fs_fill_super+0x7e3/0x1640 fs/xfs/xfs_super.c:1759
 get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1691
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3636 [inline]
 do_new_mount+0x329/0xa50 fs/namespace.c:3712
 do_mount fs/namespace.c:4035 [inline]
 __do_sys_mount fs/namespace.c:4224 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4201
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f32c139bf4a
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd30494b68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd30494bf0 RCX: 00007f32c139bf4a
RDX: 0000200000009740 RSI: 0000200000009780 RDI: 00007ffd30494bb0
RBP: 0000200000009740 R08: 00007ffd30494bf0 R09: 0000000000004010
R10: 0000000000004010 R11: 0000000000000246 R12: 0000200000009780
R13: 00007ffd30494bb0 R14: 0000000000009768 R15: 0000200000000300
 </TASK>
----------------
Code disassembly (best guess):
   0:	43 8e 4d 8b          	rex.XB mov -0x75(%r13),%cs
   4:	24 24                	and    $0x24,%al
   6:	49 81 fc b8 78 43 8e 	cmp    $0xffffffff8e4378b8,%r12
   d:	74 20                	je     0x2f
   f:	49 8b 7c 24 f8       	mov    -0x8(%r12),%rdi
  14:	48 89 de             	mov    %rbx,%rsi
  17:	e8 f2 c0 67 09       	call   0x967c10e
  1c:	85 c0                	test   %eax,%eax
  1e:	75 e2                	jne    0x2
  20:	48 8d 3d f7 ca bc 0d 	lea    0xdbccaf7(%rip),%rdi        # 0xdbccb1e
  27:	48 89 de             	mov    %rbx,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	48 89 df             	mov    %rbx,%rdi
  32:	be 20 00 00 00       	mov    $0x20,%esi
  37:	e8 92 c2 67 09       	call   0x967c2ce
  3c:	48 85 c0             	test   %rax,%rax
  3f:	0f                   	.byte 0xf


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

