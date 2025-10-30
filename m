Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECDE3CCF9F5
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 09:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A66E8E0137; Thu, 30 Oct 2025 05:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DA38E0112; Thu, 30 Oct 2025 05:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BAE78E0137; Thu, 30 Oct 2025 05:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF7918E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:00:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CF9F8930C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:00:26 +0000 (UTC)
X-FDA: 84054184452.16.21787B4
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F4CB1C000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:00:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3JykDaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3JykDaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761814824; a=rsa-sha256;
	cv=none;
	b=GSweOiA+uuc8kb2bZwXK4qkWEY2jBw3ZBOZ1LXsea7JeYvBuN9jJz5dZVTikKIgd3R6nJa
	QQTTGc+18lph75zoMIak4Qqv4VkZuofd9B7P3vuCN4c2fS9jzcF/ajO9yMbB6iAfwTNwqP
	XEN9bkn0/GQa80EjpNgBY8N4TSAJHcM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3JykDaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3JykDaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761814824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=oAXnFKVGkjCBGElDSK9+UPI3E+qrPmrN+/Ky3nzJInU=;
	b=UNDo9KuwygOk47kAgKYTWzc4YhTT2CdSvPyg2dNqHrM7fNf0i5ImPl5KXNjD4XXiaGgx3d
	wzDQEWlc3USUy6m76FTTTXB8a9cFLLmFIf+Qc4GfQ5YfW46CN8+ZK8HGQoW+00cWXgKL13
	ebGRTs1DMOP89pPXUK1DzPiEf9L+oZE=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-430b0adb3e2so12281065ab.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761814823; x=1762419623;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oAXnFKVGkjCBGElDSK9+UPI3E+qrPmrN+/Ky3nzJInU=;
        b=VPlwfte+uqu2hEOuW2OvqQTD1jmpydHc7OoCVWkl/olRiTrS3Xqp1b9sfkNcT84JCs
         AIUcOnZszO4NU9bYxXWCedCvbWeRQIRNnXLeEuWWJdsvfZ5KfeGalP/6+S9ki/nMvkcV
         +yeipWf5F43s2ITFdT7FkScVZvOU2kRsWQvoxtQTyNHgAbgKjNqO20FIO0UFtiF+0ja9
         991x7tYHR4MxcxXGkdza1baRa92h4L2WPxv6/8De+Bf7GD440EQjWDCNSxCrNNiI/fWO
         E93gGNg7H+j5/oBX3oRqjGhgoxfquuSxszJWncEIiR/Cxq0EhtChEfeLSabUF0uTlre4
         TsiA==
X-Forwarded-Encrypted: i=1; AJvYcCVRNxl6R9Nd+gvH3JSuVqtm1lnXS6fz381U2dT8zAQyFERoBXDL1+AjMnb4WbdtRxQXMmAzXo+Cwg==@kvack.org
X-Gm-Message-State: AOJu0YzSv8zKILcCvSFADhEVjBIiMowbGmjTdLXLA0sbaNObUzygpq4Y
	wBNE7J19l4fFiKAhTsGtgrp5XRzuTW1kTQ7nbBo4P5EfW6zPh0qDThkDDP9AYUO5fJjUBQK9S5H
	ksCYjrbPpMqfD3WqTrfcSiJdTxf2mNL984lyDMrLgb5bdN7j3Cb+hPm4RUro=
X-Google-Smtp-Source: AGHT+IG1QRW9boT2a3Fkq1fUjCGza5c6f1ooy4dnHlmKtFFzp1OnU0W8pMbSZuggZ0TRb2MrkFZOTsVYkUL7/2XgXXRzF406b5u6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c23:b0:430:b2a8:a9eb with SMTP id
 e9e14a558f8ab-433011d6fcbmr35273825ab.1.1761814823515; Thu, 30 Oct 2025
 02:00:23 -0700 (PDT)
Date: Thu, 30 Oct 2025 02:00:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69032927.050a0220.32483.022a.GAE@google.com>
Subject: [syzbot] [btrfs] possible deadlock in page_cache_ra_unbounded (3)
From: syzbot <syzbot+d7230f03206380ea0908@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, clm@fb.com, dsterba@suse.com, 
	josef@toxicpanda.com, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F4CB1C000D
X-Stat-Signature: aoswuej9ses5eomgypxkizkua6hdr3fk
X-HE-Tag: 1761814824-473154
X-HE-Meta: U2FsdGVkX1/OCYXWvD4Z4f+rmWx2RY2N1dsHES4o5w1VYlgJEW3Jc8JwTICzdIkoCqiiZw3zz8h73EY5AFFhfN7PnuhW8Fd+0gTZxVvCA/P8hKEYXpJhZ2eJlspwvD1RLaEW/EAaxMj+RdQOQgHa3ZLsYb1KGHvX4l7CfP+582bQJVnLSz/JFW9Y4GVgH82PUztqLWpSEu1y3o4JUDXtQgw7Oyqa4+ECxYeUzFqYWTZ9uZZW1MEAqNsP+xI6z2+DIicW1YPIi9S12UF/90ur5bBM6N5WYu/Z34C9mbQnX4J4g5tOc2eolMLJyjE419E5tB2uzPaimPA0Y0PAT4BZisSb3VNlM/83M5GowTilya9im5SsaE1UKrsmRvGGiDlTC7FGXNlaE8mdVSj1mvZesT0Fm5uWUwLamk6ckERB4rnSzqynlA5pbqvVkCo0vj25RCX2UWtPuRBpqvlFpQoDgwz2lDlVxODTDdLuvinBefR7PXkD2e6a9gDz5Kb84XrETLoEgys2fnvkrPITzbxXeo/uXMWMDScCdRwVPO+Zm1n4S5+0UwtzLcxjvZ2EIVwfeuOIvrHgoj4PYTxCNwKTHwdzanueQ8k77U0MlPdj451LZ/BPHF5mja3YxOn3AEOloPaLpA0sjGfmmZzNyLcH/6Fk+FPFqqTgjxiyGQ0lspQkxBxbiovK7SegMV6NxRu0NOuAmf5TMdWwtIDtLzUsxOwWwCiVQQJzz3gZBgX1Jx1oBzridYm9FvX+EwFOb+6+zSPaPZWg6dCWeiAI2At/O0gpnedj6/5mX5B0xoivGE2u6Uh5wpQI3hr3tTdXUEo5L7eXiZ74thXbOebSUllt1qMrviGJUchi91Yw3zwreUt0GIGTP+NpXimw2LiAu1MJo9aoi9RiXYAUBTfqNzzGpCKY/Cwy+sCh/SnTNGetG9RFaLbeUkZ3KF0a+UDEvYEc6TmOvuIbtCl272JIrHO
 SINCDD8G
 Y8QjGZ5eaB8HlFTJzkC1vWELQcCYDesWl+TZ1X/pYAm1i9517+GBd7NoZfXaToMilUIXiDcXhkby/QviRuupQ4ZQclOOwFcKo9MAnX31TSIkpzosqJ41dQybrQFfvn1AUjqlLs7+PiX0yKchYCOGrXpCryJ73ALSDQ0FvdRnuV1v0RuWEeRufqeqhzgs8L9X15HIPYW+/VSUtcGEQJrK2UCS5LmYeUjCCaAdLkSUxUdw26MA34Qd/VaUy5uQEcfMTpKlxerdyJDeRNN8/DpZWsYL3pT/C8wnZugSN1Qn5KltrEzjuJSEOOrkLzOPt1jR8Aqe0mpQp65ogrHSaI6GjgNKn7SXTKByVAWyuOBxNU5h2rkYmy24GegpuGECgv98LCPmNLc3qPp0EhUMRmHIV9QvPBee0s9cRVY78mKtoYOtfhHjozxmHGL/E3Jy8n7/xq5YKFmyhSAFlisxefc1dFNOBmj7r0Pjkd3NHn8uuFisrseDIQByvRluQwGF8tkAA0Ic8nEGk3LQxEwUFnbVIwX+VnrE9iUchft1cKMbW0ltInVVVEzt8koGfgqC4mkF7jovQZgvHjbFJkngX786lF+i7Rsz8NtH1k/wuOaSleZokgu+hT/m9wP/fYJCvtOgEZ4TCAEoC6jkxYu/Z8twekzPVteEv2uRHB1Tgdt3iLxgTbci8mGsJ8bEJXn7hzBwfCx5WvOyC/mdzcK3H959VEfoKW23g/s3PsjirEATqOCrDBZYb2mV0TkNXSaKfXNiFn/zyMCgcg6eRpG757RKIKYrzA4RrzoiZm3msU+ZUbf5rKPuKhvd5xOdhKE6effzqGEbfeWPuhcOWgLLA2Jiw5ktfe4nkmMGOqpy7hzu9XjuHh2L2yxqVqR8xA0KxubBRczJWAQSAXchchBwG8UuqS9ywOGfdqoiQWm6uFGxgkvH5WhwAuWsBJ2LcYTgCo9vcZEizGILTQVTs2JKULLoETYZHobhA
 h1meWWxd
 GDROdD1PDZtoYTMka4I8fVhewVWedapTnc/SeCPMEFPC4z+prE8VXYgLGzTgi1/idiU6Kar+EN+UMiN5yuyDB8B9CLXTkX74GAnk20IlUMvIsZG6Hc0bQhIys9PDd092dLhM1Dbbee3Sgx5mmm9oITRXJsyJTgGs8ask5tG1rsvbkPDJWaActmfBXmkDwhghTx0/qsvZcnvxkley/BYNzGaBi+jYrJLbjnpoqbfhm4tF/SM/8Y/Kx22pqxIhvYhz6Fe7paJJdoCMt10k/K3o/gTJI5RSiRv556zBb2I2jtNNy0/yQYoxsVU5CCu4bPRuy+v7p7p0DgPAuDpl/JbEAlHCLKB+63I9sOe2ayUfg0cCocFZa8vDrS1zszMlWfHXh6/ih55CLTsmd9ZxFd6qPaM9yG9KNzDTvNcNDTn6DDv+cQJ1480bpbiHCdtv37Y81i4m4Pkk1sNJ5e83huUk/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    72761a7e3122 Merge tag 'driver-core-6.18-rc3' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=123dee7c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8345ce4ce316ca28
dashboard link: https://syzkaller.appspot.com/bug?extid=d7230f03206380ea0908
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/733feb854771/disk-72761a7e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/94891a491db1/vmlinux-72761a7e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1dc1e26ee843/bzImage-72761a7e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7230f03206380ea0908@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.7.719/14515 is trying to acquire lock:
ffff88805d893bd8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1045 [inline]
ffff88805d893bd8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0x1a3/0x8e0 mm/readahead.c:233

but task is already holding lock:
ffff88813ff74238 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs_fop_readdir+0x267/0x870 fs/kernfs/dir.c:1893

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&root->kernfs_rwsem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
       kernfs_add_one+0x41/0x520 fs/kernfs/dir.c:791
       kernfs_create_dir_ns+0xde/0x130 fs/kernfs/dir.c:1093
       sysfs_create_dir_ns+0x123/0x280 fs/sysfs/dir.c:59
       create_dir lib/kobject.c:73 [inline]
       kobject_add_internal+0x5a5/0xb50 lib/kobject.c:240
       kobject_add_varg lib/kobject.c:374 [inline]
       kobject_init_and_add+0x125/0x190 lib/kobject.c:457
       btrfs_sysfs_add_qgroups+0x111/0x2b0 fs/btrfs/sysfs.c:2645
       btrfs_quota_enable+0x25d/0x2920 fs/btrfs/qgroup.c:1022
       btrfs_ioctl_quota_ctl+0x186/0x1c0 fs/btrfs/ioctl.c:3667
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&fs_info->qgroup_ioctl_lock){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/rtmutex_api.c:535 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:547
       btrfs_quota_enable+0x29c/0x2920 fs/btrfs/qgroup.c:1051
       btrfs_ioctl_quota_ctl+0x186/0x1c0 fs/btrfs/ioctl.c:3667
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (btrfs_trans_num_extwriters){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       join_transaction+0x1a4/0xca0 fs/btrfs/transaction.c:321
       start_transaction+0x6b6/0x1620 fs/btrfs/transaction.c:705
       btrfs_dirty_inode+0x9f/0x190 fs/btrfs/inode.c:6270
       inode_update_time fs/inode.c:2117 [inline]
       touch_atime+0x2f9/0x6d0 fs/inode.c:2190
       file_accessed include/linux/fs.h:2673 [inline]
       filemap_read+0x100b/0x11a0 mm/filemap.c:2820
       __kernel_read+0x4d8/0x970 fs/read_write.c:530
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:480 [inline]
       ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
       ima_calc_file_hash+0x86a/0x1700 security/integrity/ima/ima_crypto.c:568
       ima_collect_measurement+0x42e/0x900 security/integrity/ima/ima_api.c:293
       process_measurement+0x112d/0x1a40 security/integrity/ima/ima_main.c:405
       ima_file_check+0xd7/0x120 security/integrity/ima/ima_main.c:633
       security_file_post_open+0xbb/0x290 security/security.c:3199
       do_open fs/namei.c:3977 [inline]
       path_openat+0x2f32/0x3840 fs/namei.c:4134
       do_filp_open+0x1fa/0x410 fs/namei.c:4161
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (btrfs_trans_num_writers){++++}-{0:0}:
       reacquire_held_locks+0x127/0x1d0 kernel/locking/lockdep.c:5385
       __lock_release kernel/locking/lockdep.c:5574 [inline]
       lock_release+0x1b4/0x3e0 kernel/locking/lockdep.c:5889
       percpu_up_read include/linux/percpu-rwsem.h:112 [inline]
       __sb_end_write include/linux/fs.h:1911 [inline]
       sb_end_intwrite+0x26/0x1c0 include/linux/fs.h:2028
       __btrfs_end_transaction+0x248/0x640 fs/btrfs/transaction.c:1076
       btrfs_finish_one_ordered+0x139a/0x21a0 fs/btrfs/inode.c:3236
       btrfs_work_helper+0x39b/0xc00 fs/btrfs/async-thread.c:312
       process_one_work kernel/workqueue.c:3263 [inline]
       process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
       worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (btrfs_ordered_extent){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       btrfs_start_ordered_extent_nowriteback+0x39c/0x6e0 fs/btrfs/ordered-data.c:896
       lock_extents_for_read+0x151/0xb50 fs/btrfs/extent_io.c:1314
       btrfs_readahead+0x183/0x730 fs/btrfs/extent_io.c:2686
       read_pages+0x17a/0x580 mm/readahead.c:163
       page_cache_ra_unbounded+0x699/0x8e0 mm/readahead.c:302
       page_cache_sync_readahead include/linux/pagemap.h:1379 [inline]
       defrag_one_cluster fs/btrfs/defrag.c:1313 [inline]
       btrfs_defrag_file+0xa02/0x2eb0 fs/btrfs/defrag.c:1455
       btrfs_ioctl_defrag+0x389/0x490 fs/btrfs/ioctl.c:2572
       btrfs_ioctl+0xbe2/0xd00 fs/btrfs/ioctl.c:-1
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (mapping.invalidate_lock#3){.+.+}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_read+0x97/0x1f0 kernel/locking/rwsem.c:1537
       filemap_invalidate_lock_shared include/linux/fs.h:1045 [inline]
       page_cache_ra_unbounded+0x1a3/0x8e0 mm/readahead.c:233
       do_sync_mmap_readahead+0x554/0x670 mm/filemap.c:3340
       filemap_fault+0x6c2/0x12c0 mm/filemap.c:3489
       __do_fault+0x138/0x390 mm/memory.c:5280
       do_shared_fault mm/memory.c:5762 [inline]
       do_fault mm/memory.c:5836 [inline]
       do_pte_missing mm/memory.c:4361 [inline]
       handle_pte_fault mm/memory.c:6177 [inline]
       __handle_mm_fault mm/memory.c:6318 [inline]
       handle_mm_fault+0x117f/0x3400 mm/memory.c:6487
       do_user_addr_fault+0x764/0x1380 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
       filldir+0x2b6/0x6c0 fs/readdir.c:295
       dir_emit include/linux/fs.h:3986 [inline]
       kernfs_fop_readdir+0x53a/0x870 fs/kernfs/dir.c:1910
       iterate_dir+0x3a5/0x580 fs/readdir.c:108
       __do_sys_getdents fs/readdir.c:326 [inline]
       __se_sys_getdents+0xe4/0x250 fs/readdir.c:312
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  mapping.invalidate_lock#3 --> &fs_info->qgroup_ioctl_lock --> &root->kernfs_rwsem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&root->kernfs_rwsem);
                               lock(&fs_info->qgroup_ioctl_lock);
                               lock(&root->kernfs_rwsem);
  rlock(mapping.invalidate_lock#3);

 *** DEADLOCK ***

3 locks held by syz.7.719/14515:
 #0: ffff888050799528 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x253/0x320 fs/file.c:1232
 #1: ffff88806622d3f8 (&type->i_mutex_dir_key#4){++++}-{4:4}, at: iterate_dir+0x29e/0x580 fs/readdir.c:101
 #2: ffff88813ff74238 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs_fop_readdir+0x267/0x870 fs/kernfs/dir.c:1893

stack backtrace:
CPU: 1 UID: 0 PID: 14515 Comm: syz.7.719 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_read+0x97/0x1f0 kernel/locking/rwsem.c:1537
 filemap_invalidate_lock_shared include/linux/fs.h:1045 [inline]
 page_cache_ra_unbounded+0x1a3/0x8e0 mm/readahead.c:233
 do_sync_mmap_readahead+0x554/0x670 mm/filemap.c:3340
 filemap_fault+0x6c2/0x12c0 mm/filemap.c:3489
 __do_fault+0x138/0x390 mm/memory.c:5280
 do_shared_fault mm/memory.c:5762 [inline]
 do_fault mm/memory.c:5836 [inline]
 do_pte_missing mm/memory.c:4361 [inline]
 handle_pte_fault mm/memory.c:6177 [inline]
 __handle_mm_fault mm/memory.c:6318 [inline]
 handle_mm_fault+0x117f/0x3400 mm/memory.c:6487
 do_user_addr_fault+0x764/0x1380 arch/x86/mm/fault.c:1387
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:filldir+0x2b6/0x6c0 fs/readdir.c:296
Code: 87 73 02 00 00 0f 01 cb 0f ae e8 48 8b 44 24 50 49 89 44 24 08 48 8b 4c 24 08 48 8b 44 24 58 48 89 01 48 8b 04 24 8b 54 24 1c <66> 89 41 10 80 e2 0f 41 89 c7 42 88 54 39 ff 49 63 ee c6 44 29 12
RSP: 0018:ffffc9001aed7c58 EFLAGS: 00050283
RAX: 0000000000000020 RBX: ffffc9001aed7e38 RCX: 0000200000001ff0
RDX: 0000000000000004 RSI: 0000200000001fd8 RDI: 0000200000002010
RBP: 00007ffffffff000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100a568001 R12: 0000200000001fd8
R13: ffffffff8aea35e0 R14: 0000000000000006 R15: 0000200000002010
 dir_emit include/linux/fs.h:3986 [inline]
 kernfs_fop_readdir+0x53a/0x870 fs/kernfs/dir.c:1910
 iterate_dir+0x3a5/0x580 fs/readdir.c:108
 __do_sys_getdents fs/readdir.c:326 [inline]
 __se_sys_getdents+0xe4/0x250 fs/readdir.c:312
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45faaaefc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f45f08cc038 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
RAX: ffffffffffffffda RBX: 00007f45fad06180 RCX: 00007f45faaaefc9
RDX: 0000000000000117 RSI: 0000200000001fc0 RDI: 000000000000000c
RBP: 00007f45fab31f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f45fad06218 R14: 00007f45fad06180 R15: 00007ffe1c9c7da8
 </TASK>
----------------
Code disassembly (best guess):
   0:	87 73 02             	xchg   %esi,0x2(%rbx)
   3:	00 00                	add    %al,(%rax)
   5:	0f 01 cb             	stac
   8:	0f ae e8             	lfence
   b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  10:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  15:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  1a:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  1f:	48 89 01             	mov    %rax,(%rcx)
  22:	48 8b 04 24          	mov    (%rsp),%rax
  26:	8b 54 24 1c          	mov    0x1c(%rsp),%edx
* 2a:	66 89 41 10          	mov    %ax,0x10(%rcx) <-- trapping instruction
  2e:	80 e2 0f             	and    $0xf,%dl
  31:	41 89 c7             	mov    %eax,%r15d
  34:	42 88 54 39 ff       	mov    %dl,-0x1(%rcx,%r15,1)
  39:	49 63 ee             	movslq %r14d,%rbp
  3c:	c6                   	.byte 0xc6
  3d:	44 29 12             	sub    %r10d,(%rdx)


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

