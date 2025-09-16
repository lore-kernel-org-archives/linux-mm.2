Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B197CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 06:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73A68E0002; Tue, 16 Sep 2025 02:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24478E0001; Tue, 16 Sep 2025 02:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A258E0002; Tue, 16 Sep 2025 02:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF8928E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:02:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 437E413BD49
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:02:32 +0000 (UTC)
X-FDA: 83894068944.28.E06D7EE
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf18.hostedemail.com (Postfix) with ESMTP id 60DDC1C001A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:02:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3df3IaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3df3IaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758002550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=xHoQQoDNPuJvgyy5EVY3I5706DTA0AV8he9zFZIsxuo=;
	b=jQmXEZlb9sLvahax3hvVddCBZ9IUDMBrivQ7/rS7NF9S8XEY07/u/UDXu9QtagtjK4rrq0
	mPKcBaIToBXaDM7+hsXyPZHzq5AVOadb3EayzcMwNrLE/W4f7rG4F0gcPh3yVgBKo1Bn0q
	FnB+V5by5bbGuPriQrxID5CqGuC2vUA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3df3IaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3df3IaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758002550; a=rsa-sha256;
	cv=none;
	b=ZR3op3B7+UkFcAY/5gltwjsr+vajzOZ2e/jXQZF2lJ3Wgy69HeNnA2KZNVbnNyXQM0GNef
	iHehaHfmfzR+GBT4OlIngvs2nAt30XyN8Suyarpgs6anYsUXi5leOWY0ADbWFkkn/OBjk2
	Gn2a61k7Dg0zbDTCHpEFYuHX3r0CpSY=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-42351e83862so95957215ab.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758002549; x=1758607349;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xHoQQoDNPuJvgyy5EVY3I5706DTA0AV8he9zFZIsxuo=;
        b=W1cnE0JuvqCinjwACyBQ/IdCvUQMA+McIwc4cqtRtfgtS1CydcAPRJgWY7lKhaqxjF
         WlWn13c7goC+zSESykpJgeA/SBvn+4edtWisbCsTXfIFni1jHSuVWYtIb3zBUNp2fnUk
         sONHZFrofBbCA6/fGavWrxLgkaTS8nlP8MedFo4fvxP+mfqisZtfNN7IniyvV25Fc+z4
         nRpyVaTU3jk8THE53eetvoJqZ+/scygVO2lJH4rpPFnTrKlMLue36JFnivNl5T7zA5TR
         ls8O4OPjgbDRiQ5BZfe7lXtIA5BGNUnC1ZTUYxGxKTFMhh9Aon/n7iloUfseyqPQAovp
         Dtxw==
X-Forwarded-Encrypted: i=1; AJvYcCWUaWGCdB7Ms4anYx98AxBH3qwvDaDQNxMeRxTxT2HaObwR2MjBSCDQP8PmXHg+0iZjdYRv9pr6Kg==@kvack.org
X-Gm-Message-State: AOJu0YyhZOw6mzeh4Js0bSJ+YOx0uaP6JdbuKf5sGYcONLvaK52urdNu
	Bc07n/xOsX8y96sBQb2+YhnCauURxeMXKLxXSN+xElQwap+1pmawCZLF34PMoTeV+vQlW/tNC1N
	iHuXBy941/+tj1UrNEMM7G67pwhpZa6TXTO/afy6867MhZvA30QUTWsnhT2o=
X-Google-Smtp-Source: AGHT+IGzOMcA/obOHnSWSwAQ7aEaCSmLqVOU8ds27PyLqpwtWLvl62VXBzb8KxIFAfSP46/mh12Jg7Wjiq5Sl9aeGzfSKHnPgNzu
MIME-Version: 1.0
X-Received: by 2002:a92:cdac:0:b0:424:2b1:409d with SMTP id
 e9e14a558f8ab-42402b142ccmr55413305ab.28.1758002549390; Mon, 15 Sep 2025
 23:02:29 -0700 (PDT)
Date: Mon, 15 Sep 2025 23:02:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c8fd75.050a0220.2ff435.03bd.GAE@google.com>
Subject: [syzbot] [ext4?] possible deadlock in do_writepages (2)
From: syzbot <syzbot+756f498a88797cda9299@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 84cti3q43d8cf8zoaa88bp7c3zaafgb5
X-Rspam-User: 
X-Rspamd-Queue-Id: 60DDC1C001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758002550-647837
X-HE-Meta: U2FsdGVkX1+y1p0Y/+f9Iue+D9zGOLN72tPfL3I05eOh48e3APhU3EkyTe7iXc7o9FM6UYWEe30EN/5fXZ16p3xrmBVJqXg6Ny87/1P8Q2yTqsX65yOzlI20/W4c5mDEqkIezpWvNG3lgbDacyh/k/6K2+hZsA0qQVPRC8PrzkEQTMoEVuR2F/f6omXt6E5dNCal8ajW5GyoSaMFND0rCDxuDX/MzE5RvUqmlflNoBzmcKyi9ywx0JcpYz1W7r2wE13rvGnlgQc2ZtmHCbaJmj4ztJLx5Ifp14Z/45QxN0hMXt+Me1zDVvq96Nijs3hMnyi6R4QiBGiYSBlq4Cpnb7d9JtJP4y4EaHortPFNk9plsyFZ3dhLt1LQUvhRb2POLXWnI6+TPL105MUu8rzmn+kEhhotHMGacugLTVuU9TomALiZlPYzpAhn3Uqs3x8bu2eXr3XNe+O8AFnSXJye0RFdVGlOnFxAUkaQZTw0Qva4Bys8yF0My+I5dp8ryCss6pm6eh1y2krYgZxMEWfZX2tP2BIKayB/Ks6qGGwQmXj+M9UeNOaYijwJfyv39N3aAgesUw6Qbn6lc9E6jIjgKpvnWDk3RLdUeGNgaSfLI3NPefbfYhyOgizKwXNv59ngGVVU5Du+kaofQcmFqS68dX8Py3sDCJKj/8NJo3Pjr3C1uMt2ACk6cF5izcb9LlR93A4b/qa6Z4Gh+3c2czh7L/4L0bCwViK8E1iNGgBwpXo4cwJFiLG/BB1HsJ1hm1F+jslevkdIAOlz23M61+krYRIYaW4Rf9DxWh8kl/D8Wli49l6Jf58lK3+sA8OjW58M2ik/paQTdrQ1UoAXuqbCnHdq5oC+K+VUx70ZgkyjvYbeMHYrcRqCXV1DYZ3zjwChPFpBsRxfarHF9iIw8jAwN8ObUS2SA+wbfugJNbtNbiHxvGWHkXQykS1LPlpQxaUhFnQ5yojtAgyiImzQPcL
 EdOgqu8Y
 9Y6zcTO5xkNpE8Twdnz2xyCwdO2E4GVYDFasNHIpkaNPQwRJyo7vY0NcgUordln8zKPezK9v9o+Zvtw4FE2ZG3g92AtlhD2XKC+yALgZKhxmBCyeVX4Lph2SbDZ/Hr//b6iV9qDdB10c0kPdFL0yAX+Va38klwFjrtkrFuxNVMHRARGqNev3VZngeMjdXlAz5e3D8824xr/mpLdeH8oL9Xj+bO3G6bi6Kf+5bbmW4AOGw19IlA1eNW3ZfhM9TT+OjPyygpf3HUsLJZVH/sEjFf3louAKMCuq1UXa8ttmHuanCS5r+4Tu6BdnRug6DZwLp8AhCjxwQXPlV47o7vHNxzL0b+z7jPRoN2K38vHh1R4MI49OsQcyUP4EM11QZO9ZwP9/FVU5YRYUmGveBDyjdJXcXHme2TbgtL+pNDe3OdG+FDvPCCX/DbCwQvwuWUOiw1pX8kWtzXhRXh1tUOzUcWOP1Ja4XfCxDgcfMSrz1c9sJk87Q7PuztJwXP/VmcTNbMLZ5dBwF7/b6jri7SCQLAw8YUz+kWWqSqa9DLe40bFboPuoPEGks1NC4DNus4C3keprxFgVneHKtCVfX8C4zXn1i+hR7ARAkyP63I1wQ5S0W2XcyjkprRwNBmB1LoJ4z5ihajGLCC/JgjVv9MunfO52eH3d3D4sbblcukqU2K6Wcyb1KWxXscdyjwSYrJznuDh1l90dl/587Ukq3qjSoibdLE10oOBhS3SC3OJyi4ld5c8X/fYyHWKComh1ir0SjcFhVwpd2HJMqVvbpjo6UHmDH3QHtY7f/W2pXYwP2DC9XwUAanrUqP3Pwp4Ac+a86FmgGtGDu8VNAB4dn8X6pA5QRWuOHMCEbXZG+nXX37aI4dyYesPn4sAPaO01PA7gdwOHxi2QXgT8TkclkNcAS//E4rkJ7n8VVxeDQiXnOk4u3HGp17nC9YNzCJsP4m1pmIRGjQxH/IaIHDUXjKgkv0hUeWQ+o
 Lnqw4a/T
 G3i75GhJ1fnHxlCs9apAdzwBICj4XK0n4tw5Vxs2t2WAYqasT2dmrh1+EoaxVxHL4hpSzabG7CvGUpv8/7FgPtAN9QEoYP7yDRk2a6yMNX5zuVz5o8Fmue7+kyJLZBmgZAbvCZQhH6ZyRWFpK9XuYyXeDumUgKyViHOBd9NE5fXJIj2FMIrmwIAgqpXhOAEzfRAKimpVoht0p8iy655IywMaMJkPoWgISlCvGpstXcE5rfeQ+rc0JR6eQkkp9I1rKCtiIdxFbOz1Qx8jOZoN0CTkdzC699pghzMfqra6rJXps4HhIfNFJHjxNxfTtSLK9yu8Q40jRQxkx9MJbT2SYB9dWxwEtLXR00MS1y3xmzM0YKA4UKsf6y5e7X2Vh37mBqFHBN1MqTta200ew2SRB0UtcM1yPp4OI2VuJ2clrValHz0vumbi52sVTLCYqobPU/ZgxEY6d78sfGc+/MSWrEbEbeNZ1HRK3w5Edg/PqcgUlZQynIu+9edQTX4wBTGf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    f83ec76bf285 Linux 6.17-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168cfb62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=927198eca77e75d9
dashboard link: https://syzkaller.appspot.com/bug?extid=756f498a88797cda9299
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c6547c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e216eec2ed81/disk-f83ec76b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/51d6e63c8c83/vmlinux-f83ec76b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/497ee77f3c79/bzImage-f83ec76b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c319c427bb4a/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=116ed762580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+756f498a88797cda9299@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 512
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/6069 is trying to acquire lock:
ffff888033c28b98 (&sbi->s_writepages_rwsem){++++}-{0:0}, at: do_writepages+0x27a/0x600 mm/page-writeback.c:2634

but task is already holding lock:
ffff888075bd9d78 (&ei->xattr_sem){++++}-{4:4}, at: ext4_write_trylock_xattr fs/ext4/xattr.h:164 [inline]
ffff888075bd9d78 (&ei->xattr_sem){++++}-{4:4}, at: ext4_try_to_expand_extra_isize fs/ext4/inode.c:6425 [inline]
ffff888075bd9d78 (&ei->xattr_sem){++++}-{4:4}, at: __ext4_mark_inode_dirty+0x4ba/0x870 fs/ext4/inode.c:6506

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ei->xattr_sem){++++}-{4:4}:
       down_read+0x9b/0x480 kernel/locking/rwsem.c:1537
       ext4_setattr+0x875/0x2ae0 fs/ext4/inode.c:5901
       notify_change+0x6a9/0x1230 fs/attr.c:552
       chown_common+0x54e/0x680 fs/open.c:791
       do_fchownat+0x1a7/0x200 fs/open.c:822
       __do_sys_chown fs/open.c:842 [inline]
       __se_sys_chown fs/open.c:840 [inline]
       __x64_sys_chown+0x7b/0xc0 fs/open.c:840
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0x5ea/0x1410 fs/jbd2/transaction.c:444
       jbd2__journal_start+0x394/0x6a0 fs/jbd2/transaction.c:501
       __ext4_journal_start_sb+0x195/0x690 fs/ext4/ext4_jbd2.c:115
       __ext4_journal_start fs/ext4/ext4_jbd2.h:242 [inline]
       ext4_do_writepages+0xc23/0x3cf0 fs/ext4/inode.c:2913
       ext4_writepages+0x37a/0x7d0 fs/ext4/inode.c:3025
       do_writepages+0x27a/0x600 mm/page-writeback.c:2634
       __writeback_single_inode+0x160/0xfb0 fs/fs-writeback.c:1680
       writeback_sb_inodes+0x60d/0xfa0 fs/fs-writeback.c:1976
       __writeback_inodes_wb+0xf8/0x2d0 fs/fs-writeback.c:2047
       wb_writeback+0x7f3/0xb70 fs/fs-writeback.c:2158
       wb_check_old_data_flush fs/fs-writeback.c:2262 [inline]
       wb_do_writeback fs/fs-writeback.c:2315 [inline]
       wb_workfn+0x8ca/0xbe0 fs/fs-writeback.c:2343
       process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3236
       process_scheduled_works kernel/workqueue.c:3319 [inline]
       worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
       kthread+0x3c5/0x780 kernel/kthread.c:463
       ret_from_fork+0x56d/0x730 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (&sbi->s_writepages_rwsem){++++}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x12a6/0x1ce0 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read include/linux/percpu-rwsem.h:77 [inline]
       ext4_writepages_down_read fs/ext4/ext4.h:1786 [inline]
       ext4_writepages+0x224/0x7d0 fs/ext4/inode.c:3024
       do_writepages+0x27a/0x600 mm/page-writeback.c:2634
       __writeback_single_inode+0x160/0xfb0 fs/fs-writeback.c:1680
       writeback_single_inode+0x2bc/0x550 fs/fs-writeback.c:1801
       write_inode_now+0x170/0x1e0 fs/fs-writeback.c:2864
       iput_final fs/inode.c:1884 [inline]
       iput fs/inode.c:1923 [inline]
       iput+0x62d/0x880 fs/inode.c:1909
       ext4_xattr_block_set+0x67c/0x3650 fs/ext4/xattr.c:2194
       ext4_xattr_move_to_block fs/ext4/xattr.c:2659 [inline]
       ext4_xattr_make_inode_space fs/ext4/xattr.c:2734 [inline]
       ext4_expand_extra_isize_ea+0x143d/0x1ab0 fs/ext4/xattr.c:2822
       __ext4_expand_extra_isize+0x346/0x480 fs/ext4/inode.c:6385
       ext4_try_to_expand_extra_isize fs/ext4/inode.c:6428 [inline]
       __ext4_mark_inode_dirty+0x544/0x870 fs/ext4/inode.c:6506
       ext4_evict_inode+0x74e/0x18e0 fs/ext4/inode.c:254
       evict+0x3e6/0x920 fs/inode.c:810
       iput_final fs/inode.c:1897 [inline]
       iput fs/inode.c:1923 [inline]
       iput+0x521/0x880 fs/inode.c:1909
       ext4_orphan_cleanup+0x731/0x11e0 fs/ext4/orphan.c:474
       __ext4_fill_super fs/ext4/super.c:5609 [inline]
       ext4_fill_super+0x8a38/0xafa0 fs/ext4/super.c:5728
       get_tree_bdev_flags+0x38c/0x620 fs/super.c:1692
       vfs_get_tree+0x8e/0x340 fs/super.c:1815
       do_new_mount fs/namespace.c:3808 [inline]
       path_mount+0x1513/0x2000 fs/namespace.c:4123
       do_mount fs/namespace.c:4136 [inline]
       __do_sys_mount fs/namespace.c:4347 [inline]
       __se_sys_mount fs/namespace.c:4324 [inline]
       __x64_sys_mount+0x28d/0x310 fs/namespace.c:4324
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &sbi->s_writepages_rwsem --> jbd2_handle --> &ei->xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ei->xattr_sem);
                               lock(jbd2_handle);
                               lock(&ei->xattr_sem);
  rlock(&sbi->s_writepages_rwsem);

 *** DEADLOCK ***

3 locks held by syz.0.17/6069:
 #0: ffff888033c0e0e0 (&type->s_umount_key#27/1){+.+.}-{4:4}, at: alloc_super+0x235/0xbd0 fs/super.c:345
 #1: ffff888033c0e618 (sb_internal){.+.+}-{0:0}, at: evict+0x3e6/0x920 fs/inode.c:810
 #2: ffff888075bd9d78 (&ei->xattr_sem){++++}-{4:4}, at: ext4_write_trylock_xattr fs/ext4/xattr.h:164 [inline]
 #2: ffff888075bd9d78 (&ei->xattr_sem){++++}-{4:4}, at: ext4_try_to_expand_extra_isize fs/ext4/inode.c:6425 [inline]
 #2: ffff888075bd9d78 (&ei->xattr_sem){++++}-{4:4}, at: __ext4_mark_inode_dirty+0x4ba/0x870 fs/ext4/inode.c:6506

stack backtrace:
CPU: 1 UID: 0 PID: 6069 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x275/0x350 kernel/locking/lockdep.c:2043
 check_noncircular+0x14c/0x170 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x12a6/0x1ce0 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read include/linux/percpu-rwsem.h:77 [inline]
 ext4_writepages_down_read fs/ext4/ext4.h:1786 [inline]
 ext4_writepages+0x224/0x7d0 fs/ext4/inode.c:3024
 do_writepages+0x27a/0x600 mm/page-writeback.c:2634
 __writeback_single_inode+0x160/0xfb0 fs/fs-writeback.c:1680
 writeback_single_inode+0x2bc/0x550 fs/fs-writeback.c:1801
 write_inode_now+0x170/0x1e0 fs/fs-writeback.c:2864
 iput_final fs/inode.c:1884 [inline]
 iput fs/inode.c:1923 [inline]
 iput+0x62d/0x880 fs/inode.c:1909
 ext4_xattr_block_set+0x67c/0x3650 fs/ext4/xattr.c:2194
 ext4_xattr_move_to_block fs/ext4/xattr.c:2659 [inline]
 ext4_xattr_make_inode_space fs/ext4/xattr.c:2734 [inline]
 ext4_expand_extra_isize_ea+0x143d/0x1ab0 fs/ext4/xattr.c:2822
 __ext4_expand_extra_isize+0x346/0x480 fs/ext4/inode.c:6385
 ext4_try_to_expand_extra_isize fs/ext4/inode.c:6428 [inline]
 __ext4_mark_inode_dirty+0x544/0x870 fs/ext4/inode.c:6506
 ext4_evict_inode+0x74e/0x18e0 fs/ext4/inode.c:254
 evict+0x3e6/0x920 fs/inode.c:810
 iput_final fs/inode.c:1897 [inline]
 iput fs/inode.c:1923 [inline]
 iput+0x521/0x880 fs/inode.c:1909
 ext4_orphan_cleanup+0x731/0x11e0 fs/ext4/orphan.c:474
 __ext4_fill_super fs/ext4/super.c:5609 [inline]
 ext4_fill_super+0x8a38/0xafa0 fs/ext4/super.c:5728
 get_tree_bdev_flags+0x38c/0x620 fs/super.c:1692
 vfs_get_tree+0x8e/0x340 fs/super.c:1815
 do_new_mount fs/namespace.c:3808 [inline]
 path_mount+0x1513/0x2000 fs/namespace.c:4123
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount fs/namespace.c:4324 [inline]
 __x64_sys_mount+0x28d/0x310 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f65b239034a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd57a76688 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd57a76710 RCX: 00007f65b239034a
RDX: 0000200000000180 RSI: 00002000000001c0 RDI: 00007ffd57a766d0
RBP: 0000200000000180 R08: 00007ffd57a76710 R09: 0000000000800700
R10: 0000000000800700 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007ffd57a766d0 R14: 000000000000046f R15: 0000200000000680
 </TASK>
------------[ cut here ]------------
EA inode 11 i_nlink=2
WARNING: CPU: 0 PID: 6069 at fs/ext4/xattr.c:1051 ext4_xattr_inode_update_ref+0x4a6/0x570 fs/ext4/xattr.c:1051
Modules linked in:
CPU: 0 UID: 0 PID: 6069 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:ext4_xattr_inode_update_ref+0x4a6/0x570 fs/ext4/xattr.c:1051
Code: df 48 8d 7b 40 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48 8b 73 40 44 89 e2 48 c7 c7 20 03 c8 8b e8 7b 78 f0 fe 90 <0f> 0b 90 90 e9 40 fe ff ff e8 0c d3 31 ff 44 0f b6 3d bb 35 0a 0e
RSP: 0018:ffffc90002f07198 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888075bacf18 RCX: ffffffff817a4388
RDX: ffff8880348c8000 RSI: ffffffff817a4395 RDI: 0000000000000001
RBP: ffffc90002f07258 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 000000002d2d2d2d R12: 0000000000000002
R13: 1ffff920005e0e36 R14: ffff888075bacff0 R15: 0000000000000000
FS:  00005555929fc500(0000) GS:ffff8881246b3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563261a05138 CR3: 000000007523b000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ext4_xattr_inode_dec_ref fs/ext4/xattr.c:1076 [inline]
 ext4_xattr_set_entry+0x158f/0x1f00 fs/ext4/xattr.c:1714
 ext4_xattr_ibody_set+0x3d6/0x5d0 fs/ext4/xattr.c:2263
 ext4_xattr_move_to_block fs/ext4/xattr.c:2666 [inline]
 ext4_xattr_make_inode_space fs/ext4/xattr.c:2734 [inline]
 ext4_expand_extra_isize_ea+0x1487/0x1ab0 fs/ext4/xattr.c:2822
 __ext4_expand_extra_isize+0x346/0x480 fs/ext4/inode.c:6385
 ext4_try_to_expand_extra_isize fs/ext4/inode.c:6428 [inline]
 __ext4_mark_inode_dirty+0x544/0x870 fs/ext4/inode.c:6506
 ext4_evict_inode+0x74e/0x18e0 fs/ext4/inode.c:254
 evict+0x3e6/0x920 fs/inode.c:810
 iput_final fs/inode.c:1897 [inline]
 iput fs/inode.c:1923 [inline]
 iput+0x521/0x880 fs/inode.c:1909
 ext4_orphan_cleanup+0x731/0x11e0 fs/ext4/orphan.c:474
 __ext4_fill_super fs/ext4/super.c:5609 [inline]
 ext4_fill_super+0x8a38/0xafa0 fs/ext4/super.c:5728
 get_tree_bdev_flags+0x38c/0x620 fs/super.c:1692
 vfs_get_tree+0x8e/0x340 fs/super.c:1815
 do_new_mount fs/namespace.c:3808 [inline]
 path_mount+0x1513/0x2000 fs/namespace.c:4123
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount fs/namespace.c:4324 [inline]
 __x64_sys_mount+0x28d/0x310 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f65b239034a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd57a76688 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd57a76710 RCX: 00007f65b239034a
RDX: 0000200000000180 RSI: 00002000000001c0 RDI: 00007ffd57a766d0
RBP: 0000200000000180 R08: 00007ffd57a76710 R09: 0000000000800700
R10: 0000000000800700 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007ffd57a766d0 R14: 000000000000046f R15: 0000200000000680
 </TASK>


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

