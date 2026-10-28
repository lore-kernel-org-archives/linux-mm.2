Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA6A606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EC56B05BB; Wed, 28 Oct 2026 10:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18A66B05BD; Wed, 28 Oct 2026 10:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07CF6B05BE; Wed, 28 Oct 2026 10:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6BB6B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:14:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 115D81C42BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:23 +0000 (UTC)
X-FDA: 85372230006.15.C957028
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id 048E640009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3PAPiagkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3PAPiagkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=4Q52fWlYWREVmSOBokAnR5tOe0/mQLTOrcLglNmV8PM=;
	b=x1Kv6N+sDfm1ij7y/IgtfCCjoFr74ckkfXyNdUa7ioq2Rg9ggCLEXo2xR+zaHTvlVbvLjU
	qbQSHlMQtvcrpt5tVtP8Ky4PUeR88W6rC8LrXXPoTTl/zvdrSrOySV2UmbebYS9awq5MJR
	GztZrsu87hLGnNekLPJcaXD1ymm+ZNM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3PAPiagkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3PAPiagkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196861;
	b=gEAmI3sIBrcgBBtBoD/Bt4aJZ0WD1Kg4FZh8Mqrr/cfg4JrR5y9KaOrGFLiOHt+414EiBe
	FsaqQuFEXtKTVepByXBWlp9Ms1xSALktS8FxZxMbnz3IsHk+ABwfvJ3o0q7gbcAhERmptU
	Ms2dU3EGJhTeDlqYV9mHgTldgWI8r5M=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4e937c5bd4fso1024755b6e.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793196860; x=1793801660;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4Q52fWlYWREVmSOBokAnR5tOe0/mQLTOrcLglNmV8PM=;
        b=o4HenJpzLOJXxQjUE5FkWH6WbEe5XF5wJoVlRsxZOEyMo3yhgBjk6trxmoUqQ2VpO5
         1Ir7dZxV3d5zVhbg/THiS+ufC7Os/tghCUJ+1thGPNzt4TWn7qIiSEi7nEOmwESV+fJJ
         fLoQM0Ph+CCZqtNd3JveYl9WLjs5nYHFNDoujVKDYJAwDIsk52KnCPYbRYn6Vo5cak+g
         Xi/vQEYAXYvQOATHX9yKtj1VV7FMEx6N2hi91bMJoYLonu0wxbdVTzd4xhYNm0aUqXiE
         89oe6NuV0SI94kZA0q04LDLPMJbjohdTR7D14z9CQkuiUQCzqH9IjkUA15SWsu7ubOaC
         aEaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzmgVuM5G6kgzh+qHblgm09J3BXDIo45eiS/SUGZ3zrpvWOsY83FgcDdcwO0ul2zVvvm+Ql1mKENw==@kvack.org
X-Gm-Message-State: AFq9FYInLLSALkVxg325ZobANSyd8gcZviYqe0ZnvMJ0sNqCvmh9LS3y
	GdvE/wYEavPhQSG0HHEl49mGLhlTOPih/Sc0zFtZ0PFcHdsSm4FOYGYRp7J8WXgzce3LIJdW2Oz
	N0LVOt7AI+tkC9C6RoTpVE8aKM3bwJ3dvsEMICTRrcXL4BCA5K28DWuk5mUo=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3198:b0:4f4:b5ba:a241 with SMTP id
 5614622812f47-56383c8c833mr1760704b6e.39.1793196860050; Wed, 28 Oct 2026
 07:14:20 -0700 (PDT)
Date: Wed, 28 Oct 2026 07:14:20 -0700
In-Reply-To: <20261028041528.269829-1-eadavis@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae2033c.b269e7d3.3ea0f.0032.GAE@google.com>
Subject: [syzbot ci] Re: hugetlb: supports unmapping private mappings
From: syzbot ci <syzbot+cid535899c573f38fa@syzkaller.appspotmail.com>
To: eadavis@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mike.kravetz@oracle.com, muchun.song@linux.dev, osalvador@suse.de, 
	syzbot@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 048E640009
X-Stat-Signature: kad4he14xn9kh66wkarxnrojyuhwbf94
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793196860-474149
X-HE-Meta: U2FsdGVkX1/+YTds5WM5V6Scjbc3Ya3qRWj5YqkkexmnlQledWlAkUsqXfFf+pM+99oU/NDpVdONVsmdYzEKG5pUPmfWIbStDyF8io9gzwEhScpVi2AAH/4a7l8w4SFKBPS34wv/gmRCamuKYA7fbQyZ+4DWwJvA8UIrGTE5i4ENB0FiVWBUlJSajer6+ZL3C9FOn5qmPpiO5wE4Wsivm1KnIMWKApOTNExBemPtnnghx8OUcfr4jWsAT9uST0fhzfCdC7guCLOtxj9RuXtyraE0TOAe60OXVBxc4tmxqo9oJaXTLcdiv/0a4VMU/n+P0s8iYzv2+KRckIzVEh/Y6y4e89uLfo2d2FhfhwhLFqBYzeRkRZZsc37suvfcTB0zetZgX4LxSMIeCY2wY+mYMbeHlcj4KPqzT7glL0+qQPIKQ67V82RfEl4SHSAQ7QhmJLnGu2EsOi1P7XMMvLaHz/mp/f4DC1udANt+Zpr2G5ovBHnitpFYsFkefcPdO8taNEzwDXQWSU/HEB7SOEC1j9qWD7Ovg91kNLoj1K3s0B1fL7niUpkLm+oq5qHaXnvUJGYGgwzZawOSYo/2aC/GzWVl5KfR6j1kXcOYTnAONVdHZX8/2u1u8slfMvs7LfxVI0nSXw85Vda3o7+OWZVF6IEsXTYNT1K9EWVX4EQhpaAexf+LVto7VAWPbxRRTUDpbPrj2N2T48d3llOl4Qx/XPUkUfl/DZdgaRA1UjXbp++T4ybctbH5KvbrP1BcOu4XpGjb1bBlYqpg6mIFbDXcT/LgVqCqvkMZ8K8Wnoz2yt88rZVG8gEf5zripU0tlLkeazBwtkD4UgEeQCNiVu5EhkGvDrF2F+R8wqjJnFDFbUlOn3tGgtEBy/Bwp3hWK5+2RYOdG7hMCFu7paRvxgEbtmYiZgjztnvEJGX0z27Jmf0yxj+VwwVpoOjCw0gFUoPXjj2zD/PF9Cbe0s0SVP6
 8XiGctkd
 ePPunMTQFoz44JyNTtspv5sZsGv7yS42gJ5aoMKuwU5oPNWLUN0Z5GvnegkFh9rn5eO0kLQUiXpNbfXOvxlAF2/5bQ2hXOi58g4s7BkssBHUJNyuWoRkCFgoF2s4o08m60YGI0bYmxkThuFATp5vRO9wmV1RCZ1VgXi17BSoAXBuHqjf8EVLqz+U3YwbipbGjA2UHEif2nzgU33SFKbufiex05m4vobaL9Wmr2V2BuJKfIlYPqI8kVqUmkuE4nnMr2xR29g/0HzsUPTDKKK81yEFXdamA7Lg0onlW50ErFFzktFyWxAsGDtyMQz8fJSY/brTR4AllVjNw97g2+buEkkAcJ2sGgCkqu6SLdjNAayVphZMsWYZJbJFrQhoXIevXfNe25u45WGgXZKyeKMZYTh2wDgYwmgWDS4KiO5wTxL97Uf+9qcR3z2Q9FpTTNaTGCbzGsqHxiEPXpxpHlGu1uPPxYykkfjkDWN3Cww8n1WCKhEhD5MjrcIc2CeaafU/yHhneqpYMW/+vKaw9dtmslFMxoYWOwCPvsk7Ew8bA23TgDE1zz8e4TuIvcSN2I96VWRi/2vP7IuyRgycptFBLzNPZ4FAX8UO3MgJLthCqkXV7POyUzs0ve2ExSAYq5Wu244SmD+VN7FgvKMJFPn1NUwYxT0lsmz5YJgE2bAVA9DUH8yZTEnGpeEPpbnGPWEKpAQ4+fxd8BxJoU3ga7vrVGdV4yjy0jpwBxHt2NHYy9/mIe8YiPqBePBYf6ihQhDYpm3t5jSBtHl2gR32TmNicaK3tVpNMBK9hTC0SR96qwF3IqYocOaQx+HrCVc7HaItf9nbDp2MJMUZOZIuPb9h+ZWJYSrdtOyLLqDKhyia7ocdfWGLJKkmfULZe4mL0VIe4hmcrJqHlQ0W9CeE6rH3D+NaE8VSzK7fyKKivAf3qCv+s8YlfTDB4S6FQiqXpV7oTM+/99GLhoy65APs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot ci has tested the following series

[v1] hugetlb: supports unmapping private mappings
https://lore.kernel.org/all/20261028041528.269829-1-eadavis@sina.com
* [PATCH] hugetlb: supports unmapping private mappings

and found the following issue:
WARNING: bad unlock balance in remove_inode_hugepages

Full report is available here:
https://ci.syzbot.org/series/bf349aec-df0c-48a8-ab82-9f71361a3830

***

WARNING: bad unlock balance in remove_inode_hugepages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7d19c5c0-63db-4726-978e-d863eedfb488/config

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.4.862/12304 is trying to release lock (&vma_lock->rw_sema) at:
[<ffffffff82b5a0e7>] remove_inode_hugepages+0xc57/0x1220
but there are no more locks to release!

other info that might help us debug this:
locks held by syz.4.862/12304: 4, last CPU#1:
 #0: ffff88810729e460 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5e0/0x7e0
 #1: ffff8881aa537b00 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: hugetlbfs_fallocate+0x3f7/0x11c0
 #2: ffff8881683dc638 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: remove_inode_hugepages+0x370/0x1220
 #3: ffff8881aa537da8 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: remove_inode_hugepages+0xa44/0x1220

stack backtrace:
CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 print_unlock_imbalance_bug+0xdc/0xf0
 lock_release+0x252/0x3c0
 up_write+0x2d/0x4a0
 remove_inode_hugepages+0xc57/0x1220
 hugetlbfs_fallocate+0xc51/0x11c0
 vfs_fallocate+0x65a/0x7e0
 madvise_vma_behavior+0x2cf5/0x43b0
 madvise_walk_vmas+0x576/0xb00
 madvise_do_behavior+0x385/0x540
 do_madvise+0x327/0x3a0
 __x64_sys_madvise+0xa6/0xc0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c8dd9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
 </TASK>
------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff88810b4c2608, owner = 0x0, curr 0xffff88816ff4bc00, list not empty
WARNING: kernel/locking/rwsem.c:1413 at up_write+0x35c/0x4a0, CPU#1: syz.4.862/12304
Modules linked in:
CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:up_write+0x40f/0x4a0
Code: 0d 8c 49 c7 c2 80 33 0d 8c 4c 0f 44 d0 48 8b 7c 24 10 48 c7 c6 20 36 0d 8c 48 8b 14 24 48 8b 4c 24 08 4d 89 e0 4d 89 f9 41 52 <67> 48 0f b9 3a 48 83 c4 08 e8 f3 6f 45 03 e9 d6 fc ff ff 48 c7 c1
RSP: 0018:ffffc900040cede0 EFLAGS: 00010246
RAX: ffffffff8c0d33a0 RBX: ffff88810b4c2608 RCX: ffff88810b4c2608
RDX: 0000000000000000 RSI: ffffffff8c0d3620 RDI: ffffffff917dda70
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff88816ff4bc00
R10: ffffffff8c0d33a0 R11: ffffed10216984c3 R12: 0000000000000000
R13: ffff88810b4c2610 R14: ffff88810b4c2660 R15: ffff88816ff4bc00
FS:  00007f0c8bff66c0(0000) GS:ffff8882a7c83000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8981484378 CR3: 00000001ad2de000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 remove_inode_hugepages+0xc57/0x1220
 hugetlbfs_fallocate+0xc51/0x11c0
 vfs_fallocate+0x65a/0x7e0
 madvise_vma_behavior+0x2cf5/0x43b0
 madvise_walk_vmas+0x576/0xb00
 madvise_do_behavior+0x385/0x540
 do_madvise+0x327/0x3a0
 __x64_sys_madvise+0xa6/0xc0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c8dd9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
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

