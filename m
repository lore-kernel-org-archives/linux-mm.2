Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8BACCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 06:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9EF8E0025; Sat, 11 Oct 2025 02:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1868E000E; Sat, 11 Oct 2025 02:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E7E8E0025; Sat, 11 Oct 2025 02:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3098E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:11:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D18DE594E1
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:10:59 +0000 (UTC)
X-FDA: 83984810238.26.BE114B7
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 465ACC0015
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:10:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aghkulEi;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760163058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHP1XZQy+SV/1OdcZbI2DFqnujggFteFRKNesltj8ds=;
	b=8FvZk8X/OswYK5e5sjwhKCu7GPkso4o/Ktfj1FUrMdmQvr7qUg1fHSz8pnAwAYC4QU/kz3
	MgEQC0C4IlVTBiHZEfcScx432KcCwi+jWgYDbl3msROVL+j6RvwvQfwHVDojbB9XRWDlMg
	ALJripNIiQYx6QEHpjxziLlhkxyQy7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aghkulEi;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760163058; a=rsa-sha256;
	cv=none;
	b=sO/C3dUfoamvtFbnEgVZ9yVgdJEQKK3wk/Vgk79MrjcODqy0XNwbYPWaOsXagU92/65RSD
	+w/gKlUJ4X9iiGtVQCnrs9+M6dR3M8aBtuTUpOwH/EPQdEI95DBRFsB+9pNVwMPQSAPwPR
	FbUJ6Fpggszerbc+DNPCGvknCq9s2CM=
X-Forwarded-Encrypted: i=1; AJvYcCVwB7LnSrHlloZfIH2jSBl0yEszwOEgKV00sS7JNo/LHDVL+QIEwspX77bO8XAbTUOrGi3ODaZP0Q==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760163055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHP1XZQy+SV/1OdcZbI2DFqnujggFteFRKNesltj8ds=;
	b=aghkulEiYPLahJhDEg8ZSkhfw082FY9NIQyyx8gjPFbQ5DHgVNXuNaAeKwCjvwtV3l4Isc
	/hfXaGvqiTFN6Tg1bj2CfazRp5dH5RjPRIgg9LlY1KqGMSsgAhw/8O6ty4z33EcHpdHlvF
	joouNprwp6cBWwsCAUAk8rVTy5ylm2w=
X-Gm-Message-State: AOJu0Yy+svX1tJoJkQst8cemV7IAqk2JfVGexNDtcvbACUui7xMXAsqn
	723F9YCKHJJHyxuGWAWgkj8+TtUFYwgp+lKK/Nw7hlL5xDGo+hAtfMYFj248UBrvyw1XqD40/9R
	woDdhBLU4DTq7jynQOkRUcneY44EwIi0=
X-Google-Smtp-Source: AGHT+IEqV0+6/tTiiaxG4YW9fI6qZ9QsqSfa8qppizIwZXIKuact4d5h18C494wqY/7YMp/YLKT+4fHLAVbaFSk0ulk=
X-Received: by 2002:a05:622a:5c0b:b0:4df:a1ce:ed0a with SMTP id
 d75a77b69052e-4e6ead91d7dmr223928951cf.71.1760163051853; Fri, 10 Oct 2025
 23:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <68e9715a.050a0220.1186a4.000d.GAE@google.com> <CABzRoyYLxqdQpLf5JBO2qjpw0G=b8diuHs6WA3Bn24_0Ynu9oA@mail.gmail.com>
In-Reply-To: <CABzRoyYLxqdQpLf5JBO2qjpw0G=b8diuHs6WA3Bn24_0Ynu9oA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Sat, 11 Oct 2025 14:10:14 +0800
X-Gmail-Original-Message-ID: <CABzRoyYzfgVW8EVzWRGyg17C00C44X8-JoNzcB3LZmMqWDoK9Q@mail.gmail.com>
X-Gm-Features: AS18NWB3ZwIyT8-63CAuT44UtzacdDklM5W5h5n74SXZGfr9_QSjL6H4DZx013I
Message-ID: <CABzRoyYzfgVW8EVzWRGyg17C00C44X8-JoNzcB3LZmMqWDoK9Q@mail.gmail.com>
Subject: Re: [syzbot] [mm?] INFO: task hung in __rmap_walk_file
To: syzbot <syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z4617djeo6syxaswku541z4px4ynwsg9
X-Rspamd-Queue-Id: 465ACC0015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760163057-653149
X-HE-Meta: U2FsdGVkX1/cfkaTgzE7My504xXUcKHLpBCAGix1BJV3aEny+nJwx9/K/N/QbTJuBCNhq7t1SjfG07HgEeYNb5gzK0b8ydzljB/CvhdLxIOx3ttwLvJb0LsLygHvYyMrOmk1kxt/itHzpcAg644Idt8EsCYApBh9qjA/WSe7nGiS+nbYaqT6v/tYmptDAh3De9z1HF72B/FJdjQYbrmXiXPpl0lyIEBgVziDPGY5FwnnIr/Syr21QbV/YA0BkTXMd1x5Krf5ltQYa0+fgYyULesCwYO7TvkDYRm9572IUh2h5KEW3taXo/S8vDxgEBPi2/N3E5NjYuTGKzeHZbgU0LMvhJjpZmHMtGCO7Rsv2WU+ltb0H84Uf4vIZ9yCBJ1Bx8fFmgSqyaCVwx8173llPa/Yi9Ej7aNn0nTCZmQuom4SKCz4Ij2UUCvJ4CZtKUAN78HcgYSUdcBUmMt1jo0wQKnO5bexILAd1OXBT6svDyzWn3UUyY8k7d1iM8hdpJLNgRP2ZoHz7kRaksEFGX3cIF8sotvo1GqBSoUeBEWS1NSqrvvbwPsX7QfZgWUugAcTm4RUheSvyhyhPIHzUC+9fYo7zauV+riYYPMwT81IEvQGuY1+npzQ6+Niu7Mu67l0rH8/c0GhGwcPB04VnEGqRFlfXSSH0vCTgtoeCy+lW8LXffCokpYGe9xwCG954G+lBY75avm4cGfmPFgQsz2/lu8ULyDguI8urzzilSYtGFHeGcQ0gqzh33pREASPDDhBehGIyFCIhNAGJFLVw6QhXVAbc7LPpNuDmdcnGs0CA5YBSX6eCKYxL6HVCfd0IUPB3N/lNqgMDLZKL/tftH6MWjnEU0EK2rJSrEyVagNOil4ngZGoEXsv57JYc2Ld1bWtqpaZbqP6m6G0u6pzVWSfIdbBqM/tpPWdOYQVXqGuoQ3gyovAl5RCs5P4ybwlzK5Riw01aaiAUCaFbKOYh5y
 bL0Bj5IE
 GIgeJkrCtQT8QMa2AAjV7vc1wI2toMb/+GcKI5eTS0XOstX8enQtUS31neZf3Z887elnII5hnIRJtKnvRNAl6aaMDm2j/OSiBIj+vlxp/YCLUG0cJuGb5eiKjhOnUF/sywhKJNed6P7yja6UTc6nDhig/hao6Rl0Bjfd6fd2h67wWoszEjENBAPUBpmj0uBu+lZXgmsJjzPDEwhsbKkr98w9HbLexXI+vKqOYCUp4yOK2AOULJ0V7LQ+N4EdpBMPyIsp08tBOoe3NW/rdrdn+VFDJR6zhNxYrUVnXH9oya2CcLZBgHuMpinomcMJyff14gxJWvywPv6zTHj5K3p7jnqhoCxkzlZLy96vm9CdzdRgIRAUp2SNZpskeY3m2X2QeioVqvDT21Xu9DajUIGuk/itdRo99wqxOc3pcMVHvUm0Ebs33edDBOJ+KqzVNve9hodjqq8CRW4MxLKRFxJLCawK7gQJGzpdm+AkOEn2Dumiv2Q5QQFJfdAua6lSWyLiU+R3SbX1q9izG46egT/bPwHFS4kMfUGUl7y/H/OEk0aOY3Q9/EY8EWWG8c0i2aXli+S9gSKCgPOsO0vCWbCnp2kKQmA7fnEaDlQ/9p4Zxo8uPayqzXgOM4WZiPW4qhcPXU3UQmxAqAztDIgCJDmx5L67U7rBIxBly63W5dK0EhhkkvocIatYS0LcUMAUhwNlC7uOvgYE7rDVB0G8x9WOal9og5f5BfnZzfy4JHbB+DvTiKQxQPoE/5lw/dmHvI9oPcZK+9lZPVxV68x8D/PhofS+W7n8OEoR2LvVj5kCrk8WOOug+cjv4/3JDcdFA3VNQdpToMIR+ResgVjRuUfpFnBaC+RBtgZ4zG9jXKuftfP0Qz7EmPBQE90eAjiBR3tyXKpJDHY6nn3pGvKU9ZekLfQ0QKGQMNFGYC9Km
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 11:11=E2=80=AFAM Lance Yang <lance.yang@linux.dev> =
wrote:
>
> On Sat, Oct 11, 2025 at 4:49=E2=80=AFAM syzbot
> <syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    5472d60c129f Merge tag 'trace-v6.18-2' of git://git.ker=
nel..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16d69304580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D5b213914b88=
3d014
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D2d9c96466c978=
346b55f
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D133e89e25=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17f3ba7c580=
000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-5472d60c.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/af61e8db8b22/vmli=
nux-5472d60c.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/a2c11e401d8a=
/bzImage-5472d60c.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
> >
> > INFO: task syz.5.48:5749 blocked for more than 143 seconds.
> >       Not tainted syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > task:syz.5.48        state:D stack:27656 pid:5749  tgid:5747  ppid:5477=
   task_flags:0x400040 flags:0x00080002
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5325 [inline]
> >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
> >  __schedule_loop kernel/sched/core.c:7011 [inline]
> >  schedule+0x165/0x360 kernel/sched/core.c:7026
> >  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7083
> >  rwsem_down_read_slowpath+0x5fd/0x8f0 kernel/locking/rwsem.c:1086
>
> It would be great if CONFIG_DETECT_HUNG_TASK_BLOCKER was set, as it could
> point directly to the blocker. However, the lockdep output at the end of
> the report already gives us the crucial clue :)
>
> ```
> 1 lock held by syz.5.48/5749:
>  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> i_mmap_lock_read include/linux/fs.h:568 [inline]
>  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> __rmap_walk_file+0x227/0x620 mm/rmap.c:2905
>
> 3 locks held by syz.5.48/5754:
> ...
>  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> i_mmap_lock_write include/linux/fs.h:548 [inline]
>  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> hugetlbfs_punch_hole fs/hugetlbfs/inode.c:691 [inline]
>  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at:
> hugetlbfs_fallocate+0x4b5/0x1100
> ```
>
> 1) One task (5754) holds the i_mmap_rwsem write lock for hugetlbfs_falloc=
ate.
> 2) While holding that lock, it blocks waiting for a folio_lock (according
>    to its call trace).
> 3) This starves the other task (5749), which is waiting for the i_mmap_rw=
sem
>    read lock to perform migrate_pages.
>
> From the report, I cannot tell who originally held the folio_lock that
> blocked task 5754. I hope this analysis is useful ...

I believe task (5749) is the one holding that folio_lock. IIUC, that's a
A-B-B-A deadlock:

1) Task (5749): Holds folio_lock, then tries to acquire i_mmap_rwsem(read l=
ock).
2) Task (5754): Holds i_mmap_rwsem(write lock), then tries to acquire
folio_lock.

# Task (5749)
migrate_pages()
  -> migrate_hugetlbs()
    -> unmap_and_move_huge_page()     <- Takes folio_lock!
      -> remove_migration_ptes()
        -> __rmap_walk_file()
          -> i_mmap_lock_read()       <- Waits for i_mmap_rwsem(read lock)!

# Task (5754)
hugetlbfs_fallocate()
  -> hugetlbfs_punch_hole()           <- Takes i_mmap_rwsem(write lock)!
    -> hugetlbfs_zero_partial_page()
     -> filemap_lock_hugetlb_folio()
      -> filemap_lock_folio()
        -> __filemap_get_folio        <- Waits for folio_lock!

Thanks,
Lance


>
> Thanks,
> Lance
>
> >  __down_read_common kernel/locking/rwsem.c:1261 [inline]
> >  __down_read kernel/locking/rwsem.c:1274 [inline]
> >  down_read+0x98/0x2e0 kernel/locking/rwsem.c:1539
> >  i_mmap_lock_read include/linux/fs.h:568 [inline]
> >  __rmap_walk_file+0x227/0x620 mm/rmap.c:2905
> >  remove_migration_ptes mm/migrate.c:471 [inline]
> >  unmap_and_move_huge_page mm/migrate.c:1520 [inline]
> >  migrate_hugetlbs mm/migrate.c:1641 [inline]
> >  migrate_pages+0xc98/0x2930 mm/migrate.c:2080
> >  do_mbind mm/mempolicy.c:1539 [inline]
> >  kernel_mbind mm/mempolicy.c:1682 [inline]
> >  __do_sys_mbind mm/mempolicy.c:1756 [inline]
> >  __se_sys_mbind+0xa47/0xc40 mm/mempolicy.c:1752
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fd36cd8eec9
> > RSP: 002b:00007fd36dccd038 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
> > RAX: ffffffffffffffda RBX: 00007fd36cfe5fa0 RCX: 00007fd36cd8eec9
> > RDX: 0000000000000000 RSI: 0000000000800000 RDI: 0000200000001000
> > RBP: 00007fd36ce11f91 R08: 0000000000000040 R09: 0000000000000002
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fd36cfe6038 R14: 00007fd36cfe5fa0 R15: 00007ffec3386808
> >  </TASK>
> > INFO: task syz.5.48:5754 blocked for more than 143 seconds.
> >       Not tainted syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > task:syz.5.48        state:D stack:26920 pid:5754  tgid:5747  ppid:5477=
   task_flags:0x400040 flags:0x00080002
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5325 [inline]
> >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
> >  __schedule_loop kernel/sched/core.c:7011 [inline]
> >  schedule+0x165/0x360 kernel/sched/core.c:7026
> >  io_schedule+0x80/0xd0 kernel/sched/core.c:7871
> >  folio_wait_bit_common+0x6b0/0xb80 mm/filemap.c:1330
> >  __folio_lock mm/filemap.c:1706 [inline]
> >  folio_lock include/linux/pagemap.h:1141 [inline]
> >  __filemap_get_folio+0x139/0xaf0 mm/filemap.c:1960
> >  filemap_lock_folio include/linux/pagemap.h:820 [inline]
> >  filemap_lock_hugetlb_folio include/linux/hugetlb.h:814 [inline]
> >  hugetlbfs_zero_partial_page+0xae/0x610 fs/hugetlbfs/inode.c:654
> >  hugetlbfs_punch_hole fs/hugetlbfs/inode.c:708 [inline]
> >  hugetlbfs_fallocate+0xb91/0x1100 fs/hugetlbfs/inode.c:741
> >  vfs_fallocate+0x666/0x7e0 fs/open.c:342
> >  madvise_remove mm/madvise.c:1049 [inline]
> >  madvise_vma_behavior+0x31b3/0x3a10 mm/madvise.c:1346
> >  madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
> >  madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
> >  do_madvise+0x1bc/0x270 mm/madvise.c:1978
> >  __do_sys_madvise mm/madvise.c:1987 [inline]
> >  __se_sys_madvise mm/madvise.c:1985 [inline]
> >  __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fd36cd8eec9
> > RSP: 002b:00007fd36dcac038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> > RAX: ffffffffffffffda RBX: 00007fd36cfe6090 RCX: 00007fd36cd8eec9
> > RDX: 0000000000000009 RSI: 0000000000600002 RDI: 0000200000000000
> > RBP: 00007fd36ce11f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fd36cfe6128 R14: 00007fd36cfe6090 R15: 00007ffec3386808
> >  </TASK>
> >
> > Showing all locks held in the system:
> > 3 locks held by kworker/u4:0/12:
> >  #0: ffff88801a479948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at=
: process_one_work kernel/workqueue.c:3238 [inline]
> >  #0: ffff88801a479948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at=
: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
> >  #1: ffffc900001e7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_=
one_work kernel/workqueue.c:3239 [inline]
> >  #1: ffffc900001e7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_=
scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
> >  #2: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe=
/0x60 net/core/link_watch.c:303
> > 1 lock held by khungtaskd/26:
> >  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire=
 include/linux/rcupdate.h:331 [inline]
> >  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock in=
clude/linux/rcupdate.h:867 [inline]
> >  #0: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: debug_show_all_l=
ocks+0x2e/0x180 kernel/locking/lockdep.c:6775
> > 5 locks held by kworker/u4:6/1041:
> >  #0: ffff88801b6f8948 ((wq_completion)netns){+.+.}-{0:0}, at: process_o=
ne_work kernel/workqueue.c:3238 [inline]
> >  #0: ffff88801b6f8948 ((wq_completion)netns){+.+.}-{0:0}, at: process_s=
cheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
> >  #1: ffffc900025b7ba0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_w=
ork kernel/workqueue.c:3239 [inline]
> >  #1: ffffc900025b7ba0 (net_cleanup_work){+.+.}-{0:0}, at: process_sched=
uled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
> >  #2: ffffffff8f4d4c50 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0=
xf7/0x820 net/core/net_namespace.c:669
> >  #3: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: default_device_exit=
_batch+0xdc/0x890 net/core/dev.c:12807
> >  #4: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel=
_lock kernel/rcu/tree_exp.h:311 [inline]
> >  #4: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchroniz=
e_rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:957
> > 1 lock held by dhcpcd/5017:
> >  #0: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock inclu=
de/linux/rtnetlink.h:130 [inline]
> >  #0: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: devinet_ioctl+0x323=
/0x1b50 net/ipv4/devinet.c:1120
> > 2 locks held by getty/5110:
> >  #0: ffff88803597c0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_=
wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
> >  #1: ffffc9000018e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty=
_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
> > 1 lock held by syz.5.48/5749:
> >  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_=
mmap_lock_read include/linux/fs.h:568 [inline]
> >  #0: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: __=
rmap_walk_file+0x227/0x620 mm/rmap.c:2905
> > 3 locks held by syz.5.48/5754:
> >  #0: ffff88801ebe2420 (sb_writers#12){.+.+}-{0:0}, at: file_start_write=
 include/linux/fs.h:3111 [inline]
> >  #0: ffff88801ebe2420 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x=
5f0/0x7e0 fs/open.c:341
> >  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: in=
ode_lock include/linux/fs.h:980 [inline]
> >  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: hu=
getlbfs_punch_hole fs/hugetlbfs/inode.c:683 [inline]
> >  #1: ffff888011d3f348 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: hu=
getlbfs_fallocate+0x3cc/0x1100 fs/hugetlbfs/inode.c:741
> >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_=
mmap_lock_write include/linux/fs.h:548 [inline]
> >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hu=
getlbfs_punch_hole fs/hugetlbfs/inode.c:691 [inline]
> >  #2: ffff888011d3f618 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hu=
getlbfs_fallocate+0x4b5/0x1100 fs/hugetlbfs/inode.c:741
> > 2 locks held by syz-executor/20402:
> >  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire =
include/linux/rcupdate.h:331 [inline]
> >  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock inc=
lude/linux/rcupdate.h:867 [inline]
> >  #0: ffffffff8ec74400 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get=
+0x23/0x250 net/core/rtnetlink.c:570
> >  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/=
rtnetlink.c:80 [inline]
> >  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/=
core/rtnetlink.c:341 [inline]
> >  #1: ffffffff8f4e1ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/=
0x1c80 net/core/rtnetlink.c:4064
> > 1 lock held by syz.4.7446/21125:
> >  #0: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel=
_lock kernel/rcu/tree_exp.h:343 [inline]
> >  #0: ffffffff8e142db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchroniz=
e_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:957
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > NMI backtrace for cpu 0
> > CPU: 0 UID: 0 PID: 26 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-=
1.16.3-2~bpo12+1 04/01/2014
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
> >  nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
> >  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
> >  trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
> >  check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
> >  watchdog+0xf60/0xfa0 kernel/hung_task.c:495
> >  kthread+0x711/0x8a0 kernel/kthread.c:463
> >  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> >

