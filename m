Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5950ACAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 16:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B7E8E0003; Sun, 28 Sep 2025 12:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C1E8E0001; Sun, 28 Sep 2025 12:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50AF98E0003; Sun, 28 Sep 2025 12:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35C9D8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 12:15:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB8931A014E
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 16:15:30 +0000 (UTC)
X-FDA: 83939159220.20.DB9F82F
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1976614000E
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 16:15:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3IF_ZaAkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3IF_ZaAkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759076129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=aGbgfhwMpGr4gh1CdQSVDcxkQ1HdlbBmKndG0v12cQ0=;
	b=jb/jSw0V+UF9hCUkBo2g2eJBswRzlOEsqiYl4BgiMqxtYIs7rWPurv/8Ac0e4ziMlAtEhn
	pbrXPaz8lloRCRaEjUeRKrON4fZxkyUrVXURAgOpS7yDOMNRVcJstuqX+eKqkWoDv5VmBs
	kXmU4ftKqtAoyVrckiwVtDeyfMJKeBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759076129; a=rsa-sha256;
	cv=none;
	b=YOqIXLBiFticfLurbgK5Pb7QIZopvJ2yyJxOEiyWIHujvpSkTR1Yot5CHJw+ivInLrJ0h9
	EaVJur7HwByZ3nVrc9+GXeRnv8nLEpk5LyWhoFqloWqKBVnzeP/+gQsMI2TAd9VmHHToAl
	FFQc5c63KfBcvuS1YMRbjsuWMqdnjuo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3IF_ZaAkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3IF_ZaAkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-42571803464so102408015ab.3
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 09:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759076128; x=1759680928;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aGbgfhwMpGr4gh1CdQSVDcxkQ1HdlbBmKndG0v12cQ0=;
        b=wH6m/PjLAD6xRyjUbM6rRonYIU9gjjEsF2tYBcKhiVtO5/8AOx8htMBo9W+m8X527T
         OcdVdrxmQSSUyzApB0jHfRvMVx4aXBR9qxxexnWqF5wK/at1CEJkxp7MAPfw5rV3uVKK
         iqlclI+Gu42FMIhnrOjvPk+f4uZSlEEppyQnf6BXv89drBQB3WTVkOP9Di0svroF38SC
         Kqh5HgcppWlZ0VbBazE52OLXrACPTMxjrZHuh9bFyBZl8VVVvxueJ2H6tbrpFEeEdeq9
         u2AIZxbbWI/GVBnLiGO9A6tNqCf3Q42CdrKlETxGSZzUtFB7sJaw+/RPvn8aWyR+By/u
         TDSA==
X-Forwarded-Encrypted: i=1; AJvYcCUxRJITeAn6GwhKMmevAgAhL/iRVC1OZWi0NGGeDhwQr3XijGZxwG7e1h3yVvA91aingmR4661IIg==@kvack.org
X-Gm-Message-State: AOJu0YypxV62vaKHg7+1K0uRCFWzgLdZO6aAEKL/C9Lc1sleXcegii4R
	pMJpDCwXhfSYqevbycjDvUSFedt5hYzaw2ftmxfBhGVq3F/JGMDq6dqxZW4QBRpDxf4RyBa+Oz/
	mLBagPsbzPSVxY/jUTkX1JlvuBxrtQx1JUz0brBcObnYKTOzUqtHdKWZD0ok=
X-Google-Smtp-Source: AGHT+IHhdXb+dcl08rUATGzElxAGtChrMN4HGtwjRT0MUea2Q7EH/jzKKNGQEnFZ8BV29B+vw0AIWaxcGPfAh6RAKF/ZwNez4v8F
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170d:b0:428:973:797d with SMTP id
 e9e14a558f8ab-42809737edcmr120311165ab.9.1759076128175; Sun, 28 Sep 2025
 09:15:28 -0700 (PDT)
Date: Sun, 28 Sep 2025 09:15:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d95f20.a70a0220.10c4b.0022.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in ksm_do_scan
From: syzbot <syzbot+f1b91395f2bcbcc8128b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chengming.zhou@linux.dev, david@redhat.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, xu.xin16@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1976614000E
X-Stat-Signature: ytg7rohsm4ipkf8r61ma5mkkekkrd37w
X-Rspam-User: 
X-HE-Tag: 1759076128-527911
X-HE-Meta: U2FsdGVkX1/j10IG1GZaLVRRW7wn+4AasWooIzIUFzP6kFcNWzSn/C5DCWpoHkWFzVYcu1DnmaVCSfTlEQX0pRz3rjkplcj5WeQgcVjBmbIvLW0cocvPhhtOJf1A/Ba6xenI9Cx68GacNgL1hUXsxMq0qlbvJ0IODWtHp/awgQkodx/XpLLxnkE4L3/zAkS8FkIkauYWBegrZzfcdDg6I2N4DghJLBEjCZKC32Gn0tvuf96wJIDx8tdMkddhU2j/O24fwEutSiXCIB+liG4gxcMPMCG3xCvnoyVPrG+kD8C1iRokaTkE+pRPo14XaYx5K36PUzH+WVz77KwA3AVaJq+46Qdn8Q7DkufGIaUY3DRSXzO/ShgneGOIWaR790a2rDELJaVw6G4xG5m++O3BJcZw2jYNUqXpnSp1UHI2WvhPFl58SUwiJ6u1Mo4cHW8jeZXJaWPMguBVBTYi3ZchrVz8sZ9f6afHhE547xcm65lmyQRBpAS6ALXXOlD3KxllcBe9d44FZQefN/6YIwUCcjkBjhfIIrwBF9OKWAB2Of7K3kmg6tITZovzRf1c/1jaag8wl5W1B4UMDtclO9L28HWo3iwtBLBoqtI4NXUCEc82oXS+Roa/aTUcfqp6D/LgChPuPtCRmlLkdd/5buWYg3feRNrQK8d3YwPRvIaBDaXnsZCV46faTNalvmIgdCFP6t11XCpxfNUEtkDryPkTQTk9d7Od2+H2zmmXbQzLSfmyb5SDI/WvD5L/3wtDUQGLW2r3/feUtQhiKSS5XjxSvpBwzrAf+5M+LaxNrTBRxeSHakYMB1EsaNBRsmLh6+7+TWACq9bWBsHfwyI8SY1yZbOcOUcCvltUQRNKvSsc6RxLCZxTDlHxmyFUC8yNHrAZhJF+9P1U18VXxSX62stT2ugulPlg4+3uUi/O7YO3gSFG4GdS19KJnHbqSWul8ms5bXVEzFdkwW8P5n4RQIY
 maQ6/a92
 ZdnLdO7ZcBOdVMfMX9e6BDlb0FUw9gR7GCgFYH2s39OAubEs3gs90sX4yKPMaCg7/T+1xpWNI3Si0WmVS2H7x9qSVxz/QQBgAHE3lFEsSodS4tOIkJTTbLPiMdousuQ/+2+05Co0ZlFCqfhZCKOpR7ItRvP993G05r1SR6RAktSPEBD+kODuPt0IR7Ih0+XgaXFsfDg/Ej27uGKUjAFk+4mBeHe/SITzYIsbZiUEcR3gWq0NC705BX+tqz/PQvrpwtLNP6TPy01kvXpgkPKIvTfC8BjmDcHpCOPN+WKn+GytkIElHs2nrSW2Yifiaq2NL6a1sHwmB2YtTncbd2Gd+o9STCzEb4l5dSYadk8VwmfxMiBuTTe4tSoc5J52jZH6WcSfv+PwTVzj4toiS7nmPiLCdOU3q9DuXOhtbT1NNPA5YzUnN3W5cvx5rxIEuoTQcqYr09lpbE/jxOwlga4QZdikddD57FukYSN3sLTyG8mqpsjCFKWGjYKrjUmFSdrJwxdLx8RYu/RC1LRmBIRm1hofZ1ofpMbzunpzN8AUSc84aM21VWqebxFQZN8WXPZtHlym8aK/o1PaJ0lSfIyc7eXB+Y82I1XDGZ3WZN3pIN0Wi5FojoivwOLj/B2xq8dHPobLPXlBIkIgBLbkjgBbdmMXszz13jakw6FmNJOTtDcc/et+syeSqWWagPdsm19iP/ewNopkxslMi0FMnj20AvsONt26fqZUJiS2Px40BnITVYpcY/HfH9vL7vMTcths2yIVWYhp+lasP9H2yYoCfN2Pn9PLHoAQRLpttY0b7CNPjRZrA3HAW/e+GC5Dugi9Qlmh518aRVQlyE1jE5Wqt58/tYjZdxFHEaOzS0GSRz2gtIpavuPhSFOeRYRzcSu0jXc0/kpu6WkN7yqBMy0Nu7HSNzW6/q3p4aEAatwnpQECl3IkKrzZHPqoVAopEAzOV4Uc1I26eZJoxIub4AaUBciIlnuSv
 B0+BvFxC
 cfB8HObKwAgGRKoSONIzgwEuDKorOX28LxWHO5h72SXkkaalIjkUE703l0AVEkZQ3Or/I20fTLbUQRNF346/65Eo6heKEzfgo96uJ3Es+Fa03PkKBNWg+QuDABPWqlxBQpFQCLfVTeQvldDJqZoyPRDUC9/YnPwbDCws8znOg14z1R52BPO36wKcVntMavBrvLx3BQcyFSY+cB7Vq09YssRA+gaxUp/RKQaOpJwCaKueoLJF9e6L+TfgUY10VL0TDrKfNXygyhG2fHIf5GIs22w+cNmDj+Kn2YkzQPMYTBL0FU1DAH4EETyeadSfc/773XEyOXnU7OX+rWw0v+Zxo5qKHZNzMiSWw77mNrtjitEubxn+kjY5dkWVXrhdPcx9xyj4pJ8cL1MfDBC8fbMh8QBzdYQ9HLSYu5Ls3o5HSEwP8ONJMEdtXqP9E1Nr1Jhjd0WvBAOQXPVuP+ra0DoxZxwftOaJG5wiLVnfIPuChQx6uVR75OuNMNmAFBG9SYCbt6Fu5EC7nu3y8e1SJwjG7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b5a4da2c459f Add linux-next specific files for 20250924
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15a154e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=841973c5ab4f4157
dashboard link: https://syzkaller.appspot.com/bug?extid=f1b91395f2bcbcc8128b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2d0e39514585/disk-b5a4da2c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c7c8001fe2ea/vmlinux-b5a4da2c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/807bea872f12/bzImage-b5a4da2c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1b91395f2bcbcc8128b@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
ksmd/37 is trying to acquire lock:
ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:318 [inline]
ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4896 [inline]
ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5220 [inline]
ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5251

but task is already holding lock:
ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:368 [inline]
ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: scan_get_next_rmap_item mm/ksm.c:2532 [inline]
ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: ksm_do_scan+0x602/0x6540 mm/ksm.c:2659

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __might_fault+0xcc/0x130 mm/memory.c:7125
       _copy_from_iter+0xf3/0x1790 lib/iov_iter.c:259
       copy_from_iter include/linux/uio.h:228 [inline]
       copy_from_iter_full include/linux/uio.h:245 [inline]
       skb_do_copy_data_nocache include/net/sock.h:2269 [inline]
       skb_copy_to_page_nocache include/net/sock.h:2295 [inline]
       tcp_sendmsg_locked+0x2347/0x5540 net/ipv4/tcp.c:1272
       tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1413
       sock_sendmsg_nosec net/socket.c:714 [inline]
       __sock_sendmsg+0x19c/0x270 net/socket.c:729
       sock_write_iter+0x279/0x360 net/socket.c:1182
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x5c9/0xb30 fs/read_write.c:686
       ksys_write+0x145/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (sk_lock-AF_INET){+.+.}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       lock_sock_nested+0x48/0x100 net/core/sock.c:3720
       lock_sock include/net/sock.h:1679 [inline]
       inet_shutdown+0x6a/0x390 net/ipv4/af_inet.c:907
       nbd_mark_nsock_dead+0x2e9/0x560 drivers/block/nbd.c:318
       sock_shutdown+0x15e/0x260 drivers/block/nbd.c:411
       nbd_clear_sock drivers/block/nbd.c:1424 [inline]
       nbd_config_put+0x342/0x790 drivers/block/nbd.c:1448
       nbd_release+0xfe/0x140 drivers/block/nbd.c:1753
       bdev_release+0x536/0x650 block/bdev.c:-1
       blkdev_release+0x15/0x20 block/fops.c:702
       __fput+0x44c/0xa70 fs/file_table.c:468
       task_work_run+0x1d4/0x260 kernel/task_work.c:227
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop+0xe9/0x130 kernel/entry/common.c:43
       exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
       syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
       do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&nsock->tx_lock){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
       nbd_handle_cmd drivers/block/nbd.c:1140 [inline]
       nbd_queue_rq+0x257/0xf10 drivers/block/nbd.c:1204
       blk_mq_dispatch_rq_list+0x4c0/0x1900 block/blk-mq.c:2129
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xda4/0x1570 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x348/0x4f0 block/blk-mq.c:2367
       blk_mq_dispatch_list+0xd0c/0xe00 include/linux/spinlock.h:-1
       blk_mq_flush_plug_list+0x469/0x550 block/blk-mq.c:2976
       __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       __submit_bio+0x2d3/0x5a0 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x2fb/0xa50 block/blk-core.c:755
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x599/0x830 fs/buffer.c:2447
       filemap_read_folio+0x117/0x380 mm/filemap.c:2444
       do_read_cache_folio+0x350/0x590 mm/filemap.c:4009
       read_mapping_folio include/linux/pagemap.h:999 [inline]
       read_part_sector+0xb6/0x2b0 block/partitions/core.c:722
       adfspart_check_ICS+0xa4/0xa50 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x75f/0x14b0 block/partitions/core.c:693
       blkdev_get_whole+0x380/0x510 block/bdev.c:748
       bdev_open+0x31e/0xd30 block/bdev.c:957
       blkdev_open+0x457/0x600 block/fops.c:694
       do_dentry_open+0x953/0x13f0 fs/open.c:965
       vfs_open+0x3b/0x340 fs/open.c:1097
       do_open fs/namei.c:3975 [inline]
       path_openat+0x2ee5/0x3830 fs/namei.c:4134
       do_filp_open+0x1fa/0x410 fs/namei.c:4161
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&cmd->lock){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
       nbd_queue_rq+0xc8/0xf10 drivers/block/nbd.c:1196
       blk_mq_dispatch_rq_list+0x4c0/0x1900 block/blk-mq.c:2129
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xda4/0x1570 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x348/0x4f0 block/blk-mq.c:2367
       blk_mq_dispatch_list+0xd0c/0xe00 include/linux/spinlock.h:-1
       blk_mq_flush_plug_list+0x469/0x550 block/blk-mq.c:2976
       __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       __submit_bio+0x2d3/0x5a0 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x2fb/0xa50 block/blk-core.c:755
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x599/0x830 fs/buffer.c:2447
       filemap_read_folio+0x117/0x380 mm/filemap.c:2444
       do_read_cache_folio+0x350/0x590 mm/filemap.c:4009
       read_mapping_folio include/linux/pagemap.h:999 [inline]
       read_part_sector+0xb6/0x2b0 block/partitions/core.c:722
       adfspart_check_ICS+0xa4/0xa50 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x75f/0x14b0 block/partitions/core.c:693
       blkdev_get_whole+0x380/0x510 block/bdev.c:748
       bdev_open+0x31e/0xd30 block/bdev.c:957
       blkdev_open+0x457/0x600 block/fops.c:694
       do_dentry_open+0x953/0x13f0 fs/open.c:965
       vfs_open+0x3b/0x340 fs/open.c:1097
       do_open fs/namei.c:3975 [inline]
       path_openat+0x2ee5/0x3830 fs/namei.c:4134
       do_filp_open+0x1fa/0x410 fs/namei.c:4161
       do_sys_openat2+0x121/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (set->srcu){.+.+}-{0:0}:
       lock_sync+0xba/0x160 kernel/locking/lockdep.c:5916
       srcu_lock_sync include/linux/srcu.h:173 [inline]
       __synchronize_srcu+0x96/0x3a0 kernel/rcu/srcutree.c:1429
       elevator_switch+0x12b/0x640 block/elevator.c:588
       elevator_change+0x315/0x4c0 block/elevator.c:691
       elevator_set_default+0x186/0x260 block/elevator.c:767
       blk_register_queue+0x34e/0x3f0 block/blk-sysfs.c:942
       __add_disk+0x677/0xd50 block/genhd.c:528
       add_disk_fwnode+0xfc/0x480 block/genhd.c:597
       add_disk include/linux/blkdev.h:775 [inline]
       nbd_dev_add+0x717/0xae0 drivers/block/nbd.c:1981
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2688
       do_one_initcall+0x236/0x820 init/main.c:1283
       do_initcall_level+0x104/0x190 init/main.c:1345
       do_initcalls+0x59/0xa0 init/main.c:1361
       kernel_init_freeable+0x334/0x4b0 init/main.c:1593
       kernel_init+0x1d/0x1d0 init/main.c:1483
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&q->elevator_lock){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
       elevator_change+0x1e5/0x4c0 block/elevator.c:689
       elevator_set_none+0x42/0xb0 block/elevator.c:782
       blk_mq_elv_switch_none block/blk-mq.c:5032 [inline]
       __blk_mq_update_nr_hw_queues block/blk-mq.c:5075 [inline]
       blk_mq_update_nr_hw_queues+0x598/0x1ab0 block/blk-mq.c:5133
       nbd_start_device+0x17f/0xb10 drivers/block/nbd.c:1486
       nbd_genl_connect+0x135b/0x18f0 drivers/block/nbd.c:2236
       genl_family_rcv_msg_doit+0x215/0x300 net/netlink/genetlink.c:1115
       genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
       genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
       netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
       netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
       netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
       netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
       sock_sendmsg_nosec net/socket.c:714 [inline]
       __sock_sendmsg+0x21c/0x270 net/socket.c:729
       ____sys_sendmsg+0x505/0x830 net/socket.c:2617
       ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2671
       __sys_sendmsg net/socket.c:2703 [inline]
       __do_sys_sendmsg net/socket.c:2708 [inline]
       __se_sys_sendmsg net/socket.c:2706 [inline]
       __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2706
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#49){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       blk_alloc_queue+0x538/0x620 block/blk-core.c:461
       blk_mq_alloc_queue block/blk-mq.c:4399 [inline]
       __blk_mq_alloc_disk+0x15c/0x340 block/blk-mq.c:4446
       nbd_dev_add+0x46c/0xae0 drivers/block/nbd.c:1951
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2688
       do_one_initcall+0x236/0x820 init/main.c:1283
       do_initcall_level+0x104/0x190 init/main.c:1345
       do_initcalls+0x59/0xa0 init/main.c:1361
       kernel_init_freeable+0x334/0x4b0 init/main.c:1593
       kernel_init+0x1d/0x1d0 init/main.c:1483
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4896 [inline]
       slab_alloc_node mm/slub.c:5220 [inline]
       kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5251
       alloc_rmap_item mm/ksm.c:565 [inline]
       get_next_rmap_item mm/ksm.c:2378 [inline]
       scan_get_next_rmap_item mm/ksm.c:2565 [inline]
       ksm_do_scan+0xbaf/0x6540 mm/ksm.c:2659
       ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2684
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> sk_lock-AF_INET --> &mm->mmap_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&mm->mmap_lock);
                               lock(sk_lock-AF_INET);
                               lock(&mm->mmap_lock);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by ksmd/37:
 #0: ffffffff8e659188 (ksm_thread_mutex){+.+.}-{4:4}, at: ksm_scan_thread+0xc8/0x4b0 mm/ksm.c:2681
 #1: ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:368 [inline]
 #1: ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: scan_get_next_rmap_item mm/ksm.c:2532 [inline]
 #1: ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: ksm_do_scan+0x602/0x6540 mm/ksm.c:2659

stack backtrace:
CPU: 1 UID: 0 PID: 37 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
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
 __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
 fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
 might_alloc include/linux/sched/mm.h:318 [inline]
 slab_pre_alloc_hook mm/slub.c:4896 [inline]
 slab_alloc_node mm/slub.c:5220 [inline]
 kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5251
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 scan_get_next_rmap_item mm/ksm.c:2565 [inline]
 ksm_do_scan+0xbaf/0x6540 mm/ksm.c:2659
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2684
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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

