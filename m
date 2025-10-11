Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D5ACCD187
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 03:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF4C8E002A; Fri, 10 Oct 2025 23:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F948E0011; Fri, 10 Oct 2025 23:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E1D8E002A; Fri, 10 Oct 2025 23:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50D2D8E0011
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 23:12:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB11213B218
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:12:20 +0000 (UTC)
X-FDA: 83984360040.16.AFFF0AD
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id 90BC540005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:12:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sspQxzAv;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760152339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luu98aminM5AVaUeuQ2zVnLv5uEAc7jLUrqA8djWYIc=;
	b=eEBD474ynz09/jCWVrYdjKkpC2h2aBnELD6xAuV/RQX0epxIljRfr/FmM2jSeySKvqL8TH
	5gpJZmGmumTabFZCS8Pzu/SazARa+6euXCKfgPCTo2kARJWZN8GOzZ/whLN6J4TiVUy+8X
	7dUMufWcGyYzxeY7PweJdfB8cx/KwNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760152339; a=rsa-sha256;
	cv=none;
	b=KKSDM1EQ+fvOsbw6jovXUtWydzGbFBCDH6R7ngOCyoveF0Z1yFP2+vXjlMf4avRg3iKise
	Z4C3J//5xrwEUneCzWZ+KEaKAm9qjr68tl8sDN3ZQwFYj8VuisD2QOCdjFBh8L5YnuV9nx
	MBhEC23RQL4yqLeqXumHJ72XKDMvt+0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sspQxzAv;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Forwarded-Encrypted: i=1; AJvYcCU+QDMBkC+O5B/8ZGnN2ScnnSl3t4vE9ZZw/OgUe8+mTthKQSFbUT1Ke/2PQQFDWN8feijKpcG68w==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760152336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=luu98aminM5AVaUeuQ2zVnLv5uEAc7jLUrqA8djWYIc=;
	b=sspQxzAvbUZVh2y1xfw1Mvb8GnS9xGdDEG6h3tjvXtvBGOTpIvclGXFvQP2SqOLyCqgqlD
	Lz2bYQQF/LIJKy3OR1s1iw3Ae50e2iMxmCloXhp2lxqX3h8w8ou+ZOdKZ7GWqN2PzbogTZ
	pNNc3a5NijFFFLF5/bnoBdRZjMeeTM8=
X-Gm-Message-State: AOJu0Yz9MSPBr3HYTGdiaXzhnEfaB21sdwd/uamBBXbzcuvcq+gdPw9X
	YYX9Fwoylprmoh73QebTwOjxgRlXRIY+h5R0tGZgm3kJJaDJxSgX38B7g+RLntFIVZa+OK1u453
	bd42yKkDFoi01uoS4nERXVssI+3Mas9A=
X-Google-Smtp-Source: AGHT+IF8qCViy/e3uSoedOoUJrkcGkDYMISHGKLHQTp5VF67lBfjNba8yQRCYajXdpeDQdk81u/Y+lI/XYON3LgxqfQ=
X-Received: by 2002:a05:6214:1cc5:b0:77c:9e3d:672 with SMTP id
 6a1803df08f44-87b2103c549mr197373726d6.5.1760152324538; Fri, 10 Oct 2025
 20:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <68e9715a.050a0220.1186a4.000d.GAE@google.com>
In-Reply-To: <68e9715a.050a0220.1186a4.000d.GAE@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Sat, 11 Oct 2025 11:11:27 +0800
X-Gmail-Original-Message-ID: <CABzRoyYLxqdQpLf5JBO2qjpw0G=b8diuHs6WA3Bn24_0Ynu9oA@mail.gmail.com>
X-Gm-Features: AS18NWC2mXrVE-1qVFD2VI_0cIzg0JgnOLSbGp-QL9DFB3pqfvwUCHee6g3s8wg
Message-ID: <CABzRoyYLxqdQpLf5JBO2qjpw0G=b8diuHs6WA3Bn24_0Ynu9oA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] INFO: task hung in __rmap_walk_file
To: syzbot <syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: gsjua63xhpo8yu44jeoi1g6p9peipz97
X-Rspam-User: 
X-Rspamd-Queue-Id: 90BC540005
X-HE-Tag: 1760152338-539557
X-HE-Meta: U2FsdGVkX19x6c/GwEKWdu/aPRIyVSTTVJJvhSHi2Js77ADxvtSx1q5l3oOykXnBI9JRyWGTNpWMG3J513xiMf9s/fgahD8v6ZppDt9DDVqtqnYjEJpVCgEtYGsIRFs9VeRs2Jw8r+51WOLQguZhGe6Zj3UYimXmEORGvQVypYTa/17bxtkzqnnnf4aDqHicGM9aU//G65JNmbFdun1voj1tFjiPy+lIVZ/5s5dsUaweC+Drjsbnvy7kfFG18zrYDbmVQaizB2fpCYrWfEtufwapccgvqN8Sl0Scq5Enk8ny1NGs2PepRemEvLEeZwkua+Q9n/gvWemVcjemYvsFGkiVb0iJX8ZJK9Ir3DchI+Alsh9IVux/+FsEvZmooZLNommEQ0fRX4KW7MkCfAOUHhfozv0cNEz2fEq2O5cAfnKmJQNLg8p/VQqOs4+TOYCMyNI4ZSoV3suzXj5Qjtod+bFsG+1ddJlN4FHRNo8kbH7y4j2fmp/e4f6irqt4HOtYc29Jo8f13uMgFyQQsMqA4Nmy4sJgTCkdAL8yJ1d4bM7xWB0NSuBfrn55NLK2Y9TVs4Wg3B+cbHa+v3J2a9mKh5Ijy5WOUtfOJHqwtz4vhzt6WnlUtNCj5Q807Q0Im4upXMpahzLY4MV1YQRm4PVpgKy6K8JX2KKVhCdGnQnTrcdynWaw/aCqTKUlYo7y7Snfvfl8AJP9m0TdjjZU7mVIWiP7ACXGU6haWsbYHeesUlQ3XduMg0bMeG7AE6soXQcxIVlKX2yKvIKe1fgMvvmbtie/X1y3hlUyaTyQW9eY4+bTz209vMi4BwP7ZBb5ALTboHNzhvkC8EtenASSkMfKPL3XtIOOSJVz4G1ZqYU0qYdePUx6bpzrcctAa1U3Mxl+mEQ5Y8igrBTo5E0umzhO6A70DVWj5Q0BRsF/595OuiGa5HgioszB3n3oBbtty6JIONzhH5WQ3rBsT3JY4Jw
 NdvRTqzF
 X64ULXc6ia1sbiWgb1RgtdZeu66BDHngqdtbCxivTPSJOg7oPVVLuyckHRQ11jceuFuXCNVNRUD/nsQDo9Xqwhb1JklRCGh2KiVlxxbKwNb1M7Wma2dmSC+M5x1Rpk971iPdZ0Oo7JtKe+AiSzfNhtxDt5ErIYcHJiYU0PJfDMzhvMitBi9AKCBsqKdnAG2yoia6o+mKSQv+tckDoUYMZ6BOlyWcZjIk090NgHmM75gE5sJHF2KFMruspJlP4EZE1rcZhOcohbg+px9NnK/wHQCYBZLdbJVGP4QXG0TshfD5am/LjvwJgv7NYQz+Xptf5i7gSzZBwP1ctzhZ14zAA82nlWhAM0PSTrTzUiGnrvpZs4XnEkqVyHtVWJYr1amt6r7EPbzIYxeY4R7e8BX+sQNQeL2VZZsGrMOHAq8rQHcIWTA+jvpp+rGAUmw2G8tE5LyxWeeAEkt3RlGCEJOoScZxVjW0Xo+fdx7+XB2ByMQuUCT7iyJCgYLSYgBOX3OExLLZY9GFCUhB3JCebC7Lq9yvM4M4djxzj1xwQvva9XkHlKqla0GQ1jVfYPQcEPB8gAZdVObjx34PM9szqIV0IEvxbFyJWRANLCanOcKpME2qgd7PMuL18dsnaAMutbUs3O9kvtfrWN4VUBwza8jcUT6ZXF79Q6UGwpVvRG49PJ3JryF98OwLg6lhTE5qQyydRG2r/dfZ7fC5RyqmeZxHUiK5lkU9mM2QwCmbKNDarH3VbgFDTjsOk/Zo8tR0Bj4+A/0ElsneetW5Q2DXQRI+Oe52wKO/duCvLvVYEhuxJWvWtxeReiZ8zJeuaYx7o49ZF/NmVq4M1HZ2cH94AHxta/1ws9PxRxZZtVBQMjMzY/qqf3G8dwOBqJjwqfSB9G4GBghFHa7IoOF0u/VeVzbFEZGWC/7ZRrCEarMTu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 4:49=E2=80=AFAM syzbot
<syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    5472d60c129f Merge tag 'trace-v6.18-2' of git://git.kerne=
l..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16d6930458000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D5b213914b883d=
014
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D2d9c96466c97834=
6b55f
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D133e89e2580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17f3ba7c58000=
0
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d=
900f083ada3/non_bootable_disk-5472d60c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/af61e8db8b22/vmlinu=
x-5472d60c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a2c11e401d8a/b=
zImage-5472d60c.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
>
> INFO: task syz.5.48:5749 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.5.48        state:D stack:27656 pid:5749  tgid:5747  ppid:5477  =
 task_flags:0x400040 flags:0x00080002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5325 [inline]
>  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
>  __schedule_loop kernel/sched/core.c:7011 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:7026
>  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7083
>  rwsem_down_read_slowpath+0x5fd/0x8f0 kernel/locking/rwsem.c:1086

It would be great if CONFIG_DETECT_HUNG_TASK_BLOCKER was set, as it could
point directly to the blocker. However, the lockdep output at the end of
the report already gives us the crucial clue :)

```
1 lock held by syz.5.48/5749:
 #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
i_mmap_lock_read include/linux/fs.h:568 [inline]
 #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
__rmap_walk_file+0x227/0x620 mm/rmap.c:2905

3 locks held by syz.5.48/5754:
...
 #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
i_mmap_lock_write include/linux/fs.h:548 [inline]
 #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
hugetlbfs_punch_hole fs/hugetlbfs/inode.c:691 [inline]
 #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
hugetlbfs_fallocate+0x4b5/0x1100
```

1) One task (5754) holds the i_mmap_rwsem write lock for hugetlbfs_fallocat=
e.
2) While holding that lock, it blocks waiting for a folio_lock (according
   to its call trace).
3) This starves the other task (5749), which is waiting for the i_mmap_rwse=
m
   read lock to perform migrate_pages.

From the report, I cannot tell who originally held the folio_lock that
blocked task 5754. I hope this analysis is useful ...

Thanks,
Lance

>  __down_read_common kernel/locking/rwsem.c:1261 [inline]
>  __down_read kernel/locking/rwsem.c:1274 [inline]
>  down_read+0x98/0x2e0 kernel/locking/rwsem.c:1539
>  i_mmap_lock_read include/linux/fs.h:568 [inline]
>  __rmap_walk_file+0x227/0x620 mm/rmap.c:2905
>  remove_migration_ptes mm/migrate.c:471 [inline]
>  unmap_and_move_huge_page mm/migrate.c:1520 [inline]
>  migrate_hugetlbs mm/migrate.c:1641 [inline]
>  migrate_pages+0xc98/0x2930 mm/migrate.c:2080
>  do_mbind mm/mempolicy.c:1539 [inline]
>  kernel_mbind mm/mempolicy.c:1682 [inline]
>  __do_sys_mbind mm/mempolicy.c:1756 [inline]
>  __se_sys_mbind+0xa47/0xc40 mm/mempolicy.c:1752
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd36cd8eec9
> RSP: 002b:00007fd36dccd038 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
> RAX: ffffffffffffffda RBX: 00007fd36cfe5fa0 RCX: 00007fd36cd8eec9
> RDX: 0000000000000000 RSI: 0000000000800000 RDI: 0000200000001000
> RBP: 00007fd36ce11f91 R08: 0000000000000040 R09: 0000000000000002
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd36cfe6038 R14: 00007fd36cfe5fa0 R15: 00007ffec3386808
>  </TASK>
> INFO: task syz.5.48:5754 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.5.48        state:D stack:26920 pid:5754  tgid:5747  ppid:5477  =
 task_flags:0x400040 flags:0x00080002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5325 [inline]
>  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
>  __schedule_loop kernel/sched/core.c:7011 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:7026
>  io_schedule+0x80/0xd0 kernel/sched/core.c:7871
>  folio_wait_bit_common+0x6b0/0xb80 mm/filemap.c:1330
>  __folio_lock mm/filemap.c:1706 [inline]
>  folio_lock include/linux/pagemap.h:1141 [inline]
>  __filemap_get_folio+0x139/0xaf0 mm/filemap.c:1960
>  filemap_lock_folio include/linux/pagemap.h:820 [inline]
>  filemap_lock_hugetlb_folio include/linux/hugetlb.h:814 [inline]
>  hugetlbfs_zero_partial_page+0xae/0x610 fs/hugetlbfs/inode.c:654
>  hugetlbfs_punch_hole fs/hugetlbfs/inode.c:708 [inline]
>  hugetlbfs_fallocate+0xb91/0x1100 fs/hugetlbfs/inode.c:741
>  vfs_fallocate+0x666/0x7e0 fs/open.c:342
>  madvise_remove mm/madvise.c:1049 [inline]
>  madvise_vma_behavior+0x31b3/0x3a10 mm/madvise.c:1346
>  madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
>  madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
>  do_madvise+0x1bc/0x270 mm/madvise.c:1978
>  __do_sys_madvise mm/madvise.c:1987 [inline]
>  __se_sys_madvise mm/madvise.c:1985 [inline]
>  __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd36cd8eec9
> RSP: 002b:00007fd36dcac038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fd36cfe6090 RCX: 00007fd36cd8eec9
> RDX: 0000000000000009 RSI: 0000000000600002 RDI: 0000200000000000
> RBP: 00007fd36ce11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd36cfe6128 R14: 00007fd36cfe6090 R15: 00007ffec3386808
>  </TASK>
>
> Showing all locks held in the system:
> 3 locks held by kworker/u4:0/12:
>  #0: ffff88801a479948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: =
process_one_work kernel/workqueue.c:3238 [inline]
>  #0: ffff88801a479948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: =
process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
>  #1: ffffc900001e7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_on=
e_work kernel/workqueue.c:3239 [inline]
>  #1: ffffc900001e7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_sc=
heduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
>  #2: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0=
x60 net/core/link_watch.c:303
> 1 lock held by khungtaskd/26:
>  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: debug_show_all_loc=
ks+0x2e/0x180 kernel/locking/lockdep.c:6775
> 5 locks held by kworker/u4:6/1041:
>  #0: ffff88801b6f8948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one=
_work kernel/workqueue.c:3238 [inline]
>  #0: ffff88801b6f8948 ((wq_completion)netns){+.+.}-{0:0}, at: process_sch=
eduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
>  #1: ffffc900025b7ba0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_wor=
k kernel/workqueue.c:3239 [inline]
>  #1: ffffc900025b7ba0 (net_cleanup_work){+.+.}-{0:0}, at: process_schedul=
ed_works+0x9ef/0x17b0 kernel/workqueue.c:3346
>  #2: ffffffff8f4d4c50 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf=
7/0x820 net/core/net_namespace.c:669
>  #3: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: default_device_exit_b=
atch+0xdc/0x890 net/core/dev.c:12807
>  #4: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_l=
ock kernel/rcu/tree_exp.h:311 [inline]
>  #4: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_=
rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:957
> 1 lock held by dhcpcd/5017:
>  #0: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include=
/linux/rtnetlink.h:130 [inline]
>  #0: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: devinet_ioctl+0x323/0=
x1b50 net/ipv4/devinet.c:1120
> 2 locks held by getty/5110:
>  #0: ffff88803597c0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x25/0x70 drivers/tty/tty_ldisc.c:243
>  #1: ffffc9000018e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_r=
ead+0x43e/0x1400 drivers/tty/n_tty.c:2222
> 1 lock held by syz.5.48/5749:
>  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mm=
ap_lock_read include/linux/fs.h:568 [inline]
>  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: __rm=
ap_walk_file+0x227/0x620 mm/rmap.c:2905
> 3 locks held by syz.5.48/5754:
>  #0: ffff88801ebe2420 (sb_writers#12){.+.+}-{0:0}, at: file_start_write i=
nclude/linux/fs.h:3111 [inline]
>  #0: ffff88801ebe2420 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f=
0/0x7e0 fs/open.c:341
>  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inod=
e_lock include/linux/fs.h:980 [inline]
>  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: huge=
tlbfs_punch_hole fs/hugetlbfs/inode.c:683 [inline]
>  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: huge=
tlbfs_fallocate+0x3cc/0x1100 fs/hugetlbfs/inode.c:741
>  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mm=
ap_lock_write include/linux/fs.h:548 [inline]
>  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: huge=
tlbfs_punch_hole fs/hugetlbfs/inode.c:691 [inline]
>  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: huge=
tlbfs_fallocate+0x4b5/0x1100 fs/hugetlbfs/inode.c:741
> 2 locks held by syz-executor/20402:
>  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire in=
clude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock inclu=
de/linux/rcupdate.h:867 [inline]
>  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0=
x23/0x250 net/core/rtnetlink.c:570
>  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/co=
re/rtnetlink.c:341 [inline]
>  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x=
1c80 net/core/rtnetlink.c:4064
> 1 lock held by syz.4.7446/21125:
>  #0: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_l=
ock kernel/rcu/tree_exp.h:343 [inline]
>  #0: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_=
rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:957
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 26 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
>  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
>  watchdog+0xf60/0xfa0 kernel/hung_task.c:495
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
>

