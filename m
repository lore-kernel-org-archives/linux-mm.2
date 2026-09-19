Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389A0C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A2D6B009F; Sat, 19 Sep 2026 06:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101686B00A0; Sat, 19 Sep 2026 06:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0402C6B00A1; Sat, 19 Sep 2026 06:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D037A6B009F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:14:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A4651401C8
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:55 +0000 (UTC)
X-FDA: 85230103350.15.1CCF46F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BDCB20003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fU7P5hvl;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789812893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3mRO5ERFF12rfldiKsN3k3k/U09VMaw91+ycHm3ZBY=;
	b=oWRgMhfPu3V2RsHp68aWuQpSXIth+/h9SdVDKNPLDrrdPH0EWSY/8n0IC35l/FjCphjfSu
	SFhOZFE8fWjZNeej8Vm6QKpy3fu9uS+bXqrWh7pWQtI8+8barVWnbR6x2tYQ3yu7T1BVlx
	j2LJmkJfC+T3053lrlNgr43dSzkTQl0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fU7P5hvl;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789812893;
	b=M6RYel8fArmn+jCYBbbA3U2+JJJpk5hbC/Fsjs3Sbtee4naPJO3+SabCZoveIT3bkOP3cI
	pvPH9fHZYFTXlTJUveOiaKzsgY4pFTiU0LJtWlE/XlUhQ9EJc27YPbpYOSF1InvZ+Fu3P2
	eujc9lLzHacXoTiS/GA+EWG88AS3qYs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C8996020C;
	Sat, 19 Sep 2026 10:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BF81F000FF;
	Sat, 19 Sep 2026 10:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789812892;
	bh=P3mRO5ERFF12rfldiKsN3k3k/U09VMaw91+ycHm3ZBY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fU7P5hvlyzPCxY6+8WAOrz7kIDuHS7R5xBi8PF1o/RcU8TR/pSjvKrKWe4MV8j2FB
	 xbhMnLSpGoNWs0OMmpserI9R4qidz6WsRWoMusJJFlLT1XCiVU/23EfmSbeoq4insJ
	 1CJx1nA5/aYGpVyfF/nNt1O0+FeqecHABdnPcJh8=
Date: Sat, 19 Sep 2026 03:14:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+de6fd6789748a8aa64a0@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, Christian
 Schoenebeck <linux_oss@crudebyte.com>, v9fs@lists.linux.dev
Subject: Re: [syzbot] [mm?] WARNING in v9fs_fid_get_acl (2)
Message-Id: <20260919031451.3f47a8da8405e88fa1ab5398@linux-foundation.org>
In-Reply-To: <6aae188b.71f81b7d.15fa6d.0004.GAE@google.com>
References: <6aae188b.71f81b7d.15fa6d.0004.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9BDCB20003
X-Stat-Signature: 53a1ofwoqkxk3xgdq67appdbr1b5hgqq
X-Rspam-User: 
X-HE-Tag: 1789812893-740841
X-HE-Meta: U2FsdGVkX19G06GJulFsb+0NMZpU4B2FYH7QT7bukBRoRH+ZXbA51QlOVBOKikDR0V2YqqhOgTrUMglewR+rILqcUJmWH5v4KdMojshxkKlFWOKtvTdWQSLmqJBM/Uy0KgCYakL7e1jUWU3Pm+tJri11wEOgWYWAr/19ctpdfnRRQGl3QLfCt/Gf2+W9IN7ZlcokS33ahpfLawZZn6NPlZEtZjF5bQo3MmMxXv58RL0J1g+UZyncShelZcvPpn4qMIs2Q4Cq3n6NFsaREd56RYMX3jcMNs2fAOhgZh/FNh/WWdUJEVLZJ7NP12bhQoknTeC/zmaEP5KP/n2HrAotT2y5T97WpDVDYVeUw4UZsrrgkBxU3Po1mrz2id4GZXHihn4RuBG0xdRZD7lg3dLgd5a1DNDuaMSK2zyS+olxxvxpma2EF+MR4bxJ0kdXq9d8LBquvkZYlosb4rGnZ2X2c7WcbeyalXgo5XQbwI4povzNUe7c5cp/PWXET1gKG5IvDxMcX/UBrPzmL9jvHF2/OmgKQobe8aZmTOshLQfofPIZ8yKkMS6ErokKMQhPxIMJUP9OgdKGXqAbXm6S/EzJmorpiN3T/TNuFAinq31BQdSTf0zo9GhK5RQVp8UZfOVuHLsBQaPHOemKfjuRoDj2JUMMiSAdTT1ZNKRvST7wa8mP1aMqQUdL6k0qum9cPEOpbU4g0Vqe3RFaVILiz58Zzjs0A9EufFMGflrJZ8G9Z0cBROoZPTfVJAUNMXdWE5s8OBXGm1QOlIVkOlHzzw6unRlVUO1ex9snoAUa1rOdSjKfL6s2KTu3qBb88ttxMuVMf5ugTk1FOa/fZy8tQn72sh5Era5gnXMcU2jKVWLF+GfMrEs/yFOhcdzjjMTwoCSCJEjyRDOyHtYs7wtAGTelwr1g/4T3DjxB4gMCKSSECUgZvovOuUEqHQcjJfmmvPrgPN6gFJfuK7+cphopAoS
 X9nq39vM
 Yqbfv3zfbr6ITkT+3+eGSbEBdx3NXzOfHr4iTvqWNYnL6QSoHC5oexnKuz6Hl/SnZPke355gTXTqNdb1PQD/yOVe6vgRvSX3len/pp5QBJAWCEeSEozV20JMq5X0mI/OI+BFDhniUZJHO0E/0HkRvshkAVSmnphpDTqMsGw0CTKFR8hQpzj5BVQdl2+HBUSWWxtGZhoS5EJDT0jCfSxN4oWgmZReRDqKf+I2Xu+xFAXY7PjzvqmukHL2b5Ny06hEVXUH+v+3KBk37/sVAhebLKQ4KlRMWNyll0tPQi2trw1THcyjJtr/9i6hn2WEMPuIK0XTzFQXSYwA29TCgX1hT2DtwmJjPbE9MK27pNttHp04Oa7Or5WxIZ+vAWpMrI5XfYMShJwk2ym+rzul7nEqavSfFcFpgKClqK3Tv2sxaPgX9z3B5lkeg4SsR9xYRIJgH4tjBQ79CmK7ynGUio6s+Jx93YaukEaqB0O4yBOpdP1+fUsUWkEuwzSPKb/ztSI+FTdlWCIOJPr4RsYLedVdOh531gNcwFy/cg+M8aIWupukRjGSUoF5fGcqc/FvsYDQKWIWSbCCpzaoeMNJsgmisWyiAoHM+NXsSrtVusJEiRULjHurT8oSmBq65ocE+/hiDfYbllxe3TxSrM7DU/i+T/uIk9yHPS1USeG4c5EEoEsMRN/RD8QmC3N4nSaQ8LmRQiH8znWBaSflZabQMY7XVZjfvt5A4se7dB/XH3r8iRXu/+iZ4GNnjWriLCR8o9iW/t1BHZ2FgLkuj8za3Y9bZnwjJ+oPVuKcyZHxyX2IzHqU9ujquKxOn7WRyyEoGX1q7ui9HSQ0g+uzABjcu3bG0yCrtRDdoQOmRUrxebS4TObQydh3kb4dQwiU60k+pfzmKUchEL/EEzPpFKIzI9tTOmjBQzQPvoo4hf5Dz+lbz/xxzkCm27EwyJhC2C3umNei/SmS6C+7qKQBMESvatmGxFCa0R+0+
 t153GuZm
 ISkYpH6IzrFoqgE+rHzxk0mT4bXyinsl1GbgqgCZzqjofz/X8eEU8V5jmdeF+Zh19+93c9DycAanXGCyR9siw2JVHcmoFRhpH3rAtWCzieTZ5nSvqBoHLlKDwC9rit2FyQlbKRA/jfpVUZA4RThQJNHwTC5oWiR2oUVs/je6hTmkh387cQLqMDxyhq+xPUiuSobCiKD9sW7ap3fF5WRW2AtbQV8iGPYXzF1CuHXJPLPu62Yzgl/WAjKjz4ShSQuUvJiSuipWzIjwUuSFNPzXKBZnIK186l6K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 22:07:23 -0700 syzbot <syzbot+de6fd6789748a8aa64a0@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    587858367581 Merge tag 'nfsd-7.3-1' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1361a115580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
> dashboard link: https://syzkaller.appspot.com/bug?extid=de6fd6789748a8aa64a0
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f64df9580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e1a115580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-58785836.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f8460d7438eb/vmlinux-58785836.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/551bf08b9af2/bzImage-58785836.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+de6fd6789748a8aa64a0@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> 1
> WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.1.357/7872
> WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x2137/0x3300 mm/page_alloc.c:5397, CPU#0: syz.1.357/7872

Thanks.  Caused by an old v9fs bug.  A fix was proposed but never merged:
https://lists.openwall.net/linux-kernel/2024/02/02/806?utm_source=chatgpt.com

> Modules linked in:
> CPU: 0 UID: 0 PID: 7872 Comm: syz.1.357 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:alloc_order_allowed mm/page_alloc.c:5340 [inline]
> RIP: 0010:__alloc_frozen_pages_noprof+0x2137/0x3300 mm/page_alloc.c:5397
> Code: 13 00 00 39 84 24 98 00 00 00 0f 85 4a fa ff ff e9 91 f6 ff ff 80 3d e2 93 bb 0e 00 0f 85 9d e2 ff ff c6 05 d5 93 bb 0e 01 90 <0f> 0b 90 e9 8d e2 ff ff 31 c0 e9 5f ec ff ff 48 8b 7c 24 08 48 c7
> RSP: 0018:ffffc90004df7758 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000029 RDI: 0000000000040d40
> RBP: 0000000000000029 R08: 0000000000000000 R09: 0000000000000009
> R10: 0000000000000029 R11: 0000000000000000 R12: 0000000000040d40
> R13: 1ffff920009bef47 R14: 0000000000000000 R15: 1ffff920009bef05
> FS:  00007fc8804026c0(0000) GS:ffff8880d5b59000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc88037dff8 CR3: 0000000037685000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x201/0x550 mm/mempolicy.c:2486
>  ___kmalloc_large_node+0xe8/0x130 mm/slub.c:5353
>  __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5385
>  __do_kmalloc_node mm/slub.c:5402 [inline]
>  __kmalloc_noprof+0x5a8/0x840 mm/slub.c:5439
>  _kmalloc_noprof include/linux/slab.h:995 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  v9fs_fid_get_acl+0x7a/0x120 fs/9p/acl.c:33
>  __v9fs_get_acl fs/9p/acl.c:67 [inline]
>  v9fs_get_acl+0xe8/0x480 fs/9p/acl.c:93
>  v9fs_qid_iget_dotl fs/9p/vfs_inode_dotl.c:131 [inline]
>  v9fs_inode_from_fid_dotl+0x26d/0x300 fs/9p/vfs_inode_dotl.c:154
>  v9fs_get_new_inode_from_fid fs/9p/v9fs.h:264 [inline]
>  v9fs_get_tree+0x55c/0xb50 fs/9p/vfs_super.c:120
>  vfs_get_tree+0x92/0x320 fs/super.c:1933
>  fc_mount fs/namespace.c:1198 [inline]
>  do_new_mount_fc fs/namespace.c:3772 [inline]
>  do_new_mount fs/namespace.c:3848 [inline]
>  path_mount+0x7d0/0x24c0 fs/namespace.c:4168
>  do_mount fs/namespace.c:4181 [inline]
>  __do_sys_mount fs/namespace.c:4397 [inline]
>  __se_sys_mount fs/namespace.c:4374 [inline]
>  __x64_sys_mount+0x293/0x310 fs/namespace.c:4374
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc87f59e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc880402028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fc87f825fa0 RCX: 00007fc87f59e159
> RDX: 0000200000000240 RSI: 0000200000000200 RDI: 0000000000000000
> RBP: 00007fc87f63503b R08: 0000200000000180 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc87f826038 R14: 00007fc87f825fa0 R15: 00007ffeeb3b2c38
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

