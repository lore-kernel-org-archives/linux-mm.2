Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3843EFD8FC0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7EE6B00BC; Thu, 26 Feb 2026 09:54:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C0A6B00BD; Thu, 26 Feb 2026 09:54:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800536B00BE; Thu, 26 Feb 2026 09:54:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61F2A6B00BC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:54:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE009139BC0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:54:29 +0000 (UTC)
X-FDA: 84486903858.02.C3980CA
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf19.hostedemail.com (Postfix) with ESMTP id 34EB71A0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:54:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3o16gaQkbADYkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3o16gaQkbADYkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772117668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=CjIxbpBO1scmAMZRw3qust2CYmZD1FB5uYSGVYcBLCQ=;
	b=HhyvvIyOIYa//zygX6uv4MSAEGDSlAZ/HwADYcHdf3KbSGCfeELv7Of8zDl2ClfgoX7uCe
	R3zv1nfAZXPFNzoOAdP2dLEHsycqk68UcC4Qx4QOKZ0ZOW+fxl3wzQv+W3N5LVnX2VpTbm
	O7YNecYYgXtYv0InaU/gElRVtKjnLy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772117668; a=rsa-sha256;
	cv=none;
	b=UGIYZpuo+Py6vBqimCcIgDVja8TQNJq7v+BBbaTXT27P6LxMYwMsP7G3Yvrjy5klgZSv8M
	Pq/D59ZVAKof9H3NcCsNjtbLrsJX1uRTdhOpoIgL+fA4ugvVJi2h66BqcjvCyK03JQOnaD
	75hEo+wUE+MURS3BVwoRGunYIwk1oNI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3o16gaQkbADYkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3o16gaQkbADYkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-672c40f3873so19164587eaf.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:54:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772117667; x=1772722467;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CjIxbpBO1scmAMZRw3qust2CYmZD1FB5uYSGVYcBLCQ=;
        b=VPJ+RKHVAoCDR3EZL6s3bfDuY6lexfFDCF+Mt567gSXxgDoHnqg8xl3IFV8TYPz/LB
         eJOvfgCkSiJybmx8DHY/Kvh9MVFL9eHaOcZSkkt9e9/f5j806oiuedVCfeyUB9VxMs+1
         jP/0qMWj5jUhKcfW+qba/U5vI3n5vZ3a4zu7gBOQvOgBgVZjncYgy2RpGNfB2nUU92Ii
         LTWhrm/xlH3Yf5cXVKW+drhorXHMpeJLiczU8FDTV2ZSlvqseUSCnsb+45DC8Cb/5iLm
         cYAr2Bjq50NvjB4LpoYCeeKhNZZbPydQ68Uf/bOuDuyXkXPkCB4JWSoZEGKK1MUI4Ugz
         3H4g==
X-Forwarded-Encrypted: i=1; AJvYcCWbohAzSUehv/CuQHO9dAHX1WcYxw8U1Qla3mOiEF/si3lPoTn9Un0VFh1jcmUBdIDJdduEFMFFZw==@kvack.org
X-Gm-Message-State: AOJu0YyR8SNsOQXmOCEnB3gNw86ux1KrjckunsP2WX1Rqxv9tbVET76J
	G9M5FRtoYiTN8wrTRzm1Hsjj4Zeve6AaxIl0RLzGM/5+5Gl8+okefmdpIEif9dvu+NpGyZvgJ7w
	oYibiGO4M/jkE9ZuSpw2+vGV9kgCVys76fWtGc8X7YiQjlQPtw+6iRcFkc18=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2916:b0:662:f91f:4a85 with SMTP id
 006d021491bc7-679f3da6b32mr1315227eaf.54.1772117667232; Thu, 26 Feb 2026
 06:54:27 -0800 (PST)
Date: Thu, 26 Feb 2026 06:54:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a05ea3.050a0220.305b49.0022.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in lock_mm_and_find_vma (4)
From: syzbot <syzbot+709f5ab0e03871dec50a@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 1qho8e6tm3mz34ui9m4he7no3uc3pd3p
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34EB71A0002
X-HE-Tag: 1772117668-294128
X-HE-Meta: U2FsdGVkX1/M0HN6MuxA8w/UsS2nIPU8Bjo2gtQsM36H80WUA+9tC6tABJFNO10U9ITsBVbfDfWSWX/dUP07hHvkmTrCEvo7iZHptcgbyC27KzdCymjVpeFK1o/TEGYNlQ8QvV4xMBHaQi9d5lzsmi8N1ELpoSs4AMnQjs3Eyxlwr+1U7OUj7NSbbMUKsDRQgunPsicyM1T7NcnYZraF8biXHWHV0rPo49irlils/do0+RpHuwbU02i2hUPHWCiM4gGtqxhY1DV9AHrqC21a+CabqiY/+0zUyFiZzZh8d2aYIdHXMfnCOqkiPiEghbYwJXYuQxLYE8trIwL55PM737GHrt7d4qfjPXHSatenkStnuyaMcx7ycQqVklDFU9xEhsXz2OHHU+doGiN0ZUvVcT2uE238dmKLe7NQq3RkcbyVaw/Ea8hgAmkOMV93lE3mCYDpPk9GG/e9bWVOsVKoMN55yPTby6f6RqcqSvmKgGQt8vhZ/QNFwE7+gUoP1yzHh7AvBSLVAl1CtTlDlcPoE5yUlwsctYXMRiL0yBoCKFWvK4SWxEy9osd1xMFtTghNiC4LhQRAGRM8DtsOWalfkTtrRPe09NPysGx6lPNKbrZCltTwFEweyySKz28zcyRF7bZt3hkDFyordT7bTMRfjzpABYYut4Tu4tvBFG73yQ2ECTE1q9eUiER/9n0sS0F+D+1OomNhm2NwxZDC/X1rEQkI5AqBEwjYI1ao7KoQx9qVgXW3q97jrf34jLozAh37yduw4M+VwAu2zeXLyF9KyUECskKXSxvusN8ittPlEPO6qFkiVrGViT7TQbFBWv7KQzfMep6TnGhO5t6UJ8BMocpPzAlZPsBCdTa6WQsSbwsVi4NLl9AzU57ikmxubHWpH7Gmqiu7kxh2R3jo3FfneCwuEqYMuV5TiFnzLTRsSV4TbZYHhyhU2FArh2lYS7/MZ1nsr89QTJRhtYMjekn
 O1VhuNKn
 96IfG8exx7QDdkd+phomsmkmxXF+V4IgwrS4NAUI/WbnnajvCkfJPZOJnqSrT0GqJ+NHA3jP+5tfvXnFrQTInlVsdtGpk11p7wOMrhTN7Y6ROrttYA7teu/y1ZMZ1ovtOTpkf/1RlNRoR3pzT+a/LadmOsN3LRrgg5If9+XShI57MSU/YlGa39Mh58Y7kmKosgtw7v/55rqaIpLtB+NjLu2bHdOhtfsxHkJIDkn7VQHkys9AG+i85KbO5emSrJH/HVa8RtCuAMC42l0wea0ESRA6ZP4p7dcrMOIJv2M74952QigLr2OgnO52AhoWmC/GE+7DHjahnPFp3VsSyyGxcSieOgTemEGeeQ8YyqR4qc0X8gQMEXI+p9MYI4NwVTzadUSfFUVTltxK6lwHyozbCeAL9ezpeTjHfp7oyOhnBkRR84HfmaGEMdY50SedG/XkN//KDmQNNff08T82xKIUM+l6UJIs14JqmgNp2AedqY4+9Dg9SGoYrSh3Z88Dfae4WRPrx/p3ok1Y+WdFWPyttIF2EfaSBKBEeAmeUCQZZCh7Ohqt3KyG+XvxjJtVR0nl2VIStSLMhoMap2NIqp0JKwDHtseP2qNkl81Qc5Cb1WVRPGyzb+04sWnr0vYXm5MDe5rwl9qKWmMNjnm3vW1z6wXdxYamk9bNTXz7mPxRlwfjIx1bOR0BtzzbNnFzXZmX4Hv2Kwbc3iaSu2zzhemBH4NKZc1AlQ7oxiR8qiUB7HXhUvQVi3w4O0tRspeS8sHnaxVZtRZuK6UBW+uI7nUwLK/UpdW4t+F/dexmnb0uPJZdhJI8P//tj7ZLjEcHHPNL7sDV3Hnc8+znLprU1JotRn621Ev2I11sArytcS93l0KICB15tQykEOjppCWbqqvxX0ylJo2NbiXXLMqfDn622jd+ZDTcAXx5IOcvtG+/JcGHrdXdhZJmrfUz5NPeZjdJegW04IOAIyNzv+o+xA1/2mEZ/Fyxm
 oh0mnbt5
 HNrbtyH3rmwdnmVVWBDiMElBiQmcRYHpyXUeOK2W33Lilhrd6Rz0oOwHfDPSkjpGKeBRUmPX+WBiRccEnyYaVdB3a1xjMxU938iZN3P1yEB7ixJ3M16sH3+RuSpqG9UBI0AWS1V3JAh87GpEFYAWnicc/P+Z6ye4fm74p0sGy73DBI7CQ1rIa6LH5n0H46kyY+Fpq4V6BqXw3QZBAM0M37yPvRfXpUbZtffd/3nW3yFPhGQd8PGZHv46ncq4tUsrvol9+W7OgOvKdiOmXWUHdvUQhW3nPaaZFgu1Cn1ScYRgIC3IH3N5cA9wLagWMS+Psn6exx5MSF009GNWIPpANj4P6JeVZoqG1XygqqJFaubQLgCdGl+iA6UlE59sp/LXYerS4fb8YaLU4Hyt7rr0wfght0Dl4bRGZfxRc7b63voMoNwWXLnM23vowhn0MaZqDuSXfh7X1Mxzy6/Q+Gh+W1iP53rdfwm2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    32a92f8c8932 Convert more 'alloc_obj' cases to default GFP..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13cd6f3a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6259cfbe2d15cac4
dashboard link: https://syzkaller.appspot.com/bug?extid=709f5ab0e03871dec50a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/64d473c704b2/disk-32a92f8c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/570c8f79c450/vmlinux-32a92f8c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b3d4ccd686ce/bzImage-32a92f8c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+709f5ab0e03871dec50a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.3.3387/17804 is trying to acquire lock:
ffffffff8e9aaf80 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:317 [inline]
ffffffff8e9aaf80 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x166/0x5f0 mm/page_alloc.c:5018

but task is already holding lock:
ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:611 [inline]
ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/mmap_lock.c:441 [inline]
ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x35/0x6f0 mm/mmap_lock.c:501

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault+0xde/0x140 mm/memory.c:7217
       _inline_copy_from_user include/linux/uaccess.h:169 [inline]
       _copy_from_user+0x29/0xd0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:223 [inline]
       copy_from_sockptr_offset include/linux/sockptr.h:48 [inline]
       copy_from_sockptr include/linux/sockptr.h:61 [inline]
       do_ip_setsockopt+0x2363/0x3200 net/ipv4/ip_sockglue.c:1294
       ip_setsockopt+0x5a/0xf0 net/ipv4/ip_sockglue.c:1417
       ipv6_setsockopt+0x155/0x170 net/ipv6/ipv6_sockglue.c:968
       tcp_setsockopt+0xa7/0x100 net/ipv4/tcp.c:4217
       smc_setsockopt+0x1b6/0xa10 net/smc/af_smc.c:3097
       do_sock_setsockopt+0xf3/0x1d0 net/socket.c:2322
       __sys_setsockopt+0x119/0x190 net/socket.c:2347
       __do_sys_setsockopt net/socket.c:2353 [inline]
       __se_sys_setsockopt net/socket.c:2350 [inline]
       __x64_sys_setsockopt+0xbd/0x160 net/socket.c:2350
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (k-sk_lock-AF_INET6){+.+.}-{0:0}:
       lock_sock_nested+0x41/0xf0 net/core/sock.c:3780
       lock_sock include/net/sock.h:1709 [inline]
       inet_shutdown+0x67/0x410 net/ipv4/af_inet.c:913
       nbd_mark_nsock_dead+0xae/0x5c0 drivers/block/nbd.c:318
       sock_shutdown+0x16b/0x200 drivers/block/nbd.c:411
       nbd_clear_sock drivers/block/nbd.c:1427 [inline]
       nbd_config_put+0x1eb/0x750 drivers/block/nbd.c:1451
       nbd_release+0xb7/0x190 drivers/block/nbd.c:1756
       blkdev_put_whole+0xb0/0xf0 block/bdev.c:737
       bdev_release+0x47f/0x6d0 block/bdev.c:1160
       blkdev_release+0x15/0x20 block/fops.c:705
       __fput+0x3ff/0xb40 fs/file_table.c:469
       task_work_run+0x150/0x240 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
       exit_to_user_mode_loop+0x100/0x4a0 kernel/entry/common.c:98
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
       do_syscall_64+0x668/0xf80 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1a2/0x1b90 kernel/locking/mutex.c:776
       nbd_handle_cmd drivers/block/nbd.c:1143 [inline]
       nbd_queue_rq+0x428/0x1080 drivers/block/nbd.c:1207
       blk_mq_dispatch_rq_list+0x422/0x1e70 block/blk-mq.c:2148
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xcea/0x1620 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x1c0 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x23c/0x670 block/blk-mq.c:2386
       blk_mq_dispatch_list+0x51d/0x1360 block/blk-mq.c:2949
       blk_mq_flush_plug_list block/blk-mq.c:2997 [inline]
       blk_mq_flush_plug_list+0x130/0x600 block/blk-mq.c:2969
       __blk_flush_plug+0x2c4/0x4b0 block/blk-core.c:1230
       blk_finish_plug block/blk-core.c:1257 [inline]
       __submit_bio+0x584/0x6c0 block/blk-core.c:649
       __submit_bio_noacct_mq block/blk-core.c:722 [inline]
       submit_bio_noacct_nocheck+0x562/0xc10 block/blk-core.c:753
       submit_bio_noacct+0xd17/0x2010 block/blk-core.c:884
       blk_crypto_submit_bio include/linux/blk-crypto.h:203 [inline]
       submit_bh_wbc+0x59c/0x770 fs/buffer.c:2821
       submit_bh fs/buffer.c:2826 [inline]
       block_read_full_folio+0x4c8/0x8e0 fs/buffer.c:2458
       filemap_read_folio+0xfc/0x3b0 mm/filemap.c:2496
       do_read_cache_folio+0x2d7/0x6b0 mm/filemap.c:4096
       read_mapping_folio include/linux/pagemap.h:1028 [inline]
       read_part_sector+0xd1/0x370 block/partitions/core.c:723
       adfspart_check_ICS+0x93/0x910 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:142 [inline]
       blk_add_partitions block/partitions/core.c:590 [inline]
       bdev_disk_changed+0x7f8/0xc80 block/partitions/core.c:694
       blkdev_get_whole+0x187/0x290 block/bdev.c:764
       bdev_open+0x2c7/0xe40 block/bdev.c:973
       blkdev_open+0x34e/0x4f0 block/fops.c:697
       do_dentry_open+0x6d8/0x1660 fs/open.c:949
       vfs_open+0x82/0x3f0 fs/open.c:1081
       do_open fs/namei.c:4671 [inline]
       path_openat+0x208c/0x31a0 fs/namei.c:4830
       do_file_open+0x20e/0x430 fs/namei.c:4859
       do_sys_openat2+0x10d/0x1e0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x12d/0x210 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1a2/0x1b90 kernel/locking/mutex.c:776
       nbd_queue_rq+0xba/0x1080 drivers/block/nbd.c:1199
       blk_mq_dispatch_rq_list+0x422/0x1e70 block/blk-mq.c:2148
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xcea/0x1620 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x1c0 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x23c/0x670 block/blk-mq.c:2386
       blk_mq_dispatch_list+0x51d/0x1360 block/blk-mq.c:2949
       blk_mq_flush_plug_list block/blk-mq.c:2997 [inline]
       blk_mq_flush_plug_list+0x130/0x600 block/blk-mq.c:2969
       __blk_flush_plug+0x2c4/0x4b0 block/blk-core.c:1230
       blk_finish_plug block/blk-core.c:1257 [inline]
       __submit_bio+0x584/0x6c0 block/blk-core.c:649
       __submit_bio_noacct_mq block/blk-core.c:722 [inline]
       submit_bio_noacct_nocheck+0x562/0xc10 block/blk-core.c:753
       submit_bio_noacct+0xd17/0x2010 block/blk-core.c:884
       blk_crypto_submit_bio include/linux/blk-crypto.h:203 [inline]
       submit_bh_wbc+0x59c/0x770 fs/buffer.c:2821
       submit_bh fs/buffer.c:2826 [inline]
       block_read_full_folio+0x4c8/0x8e0 fs/buffer.c:2458
       filemap_read_folio+0xfc/0x3b0 mm/filemap.c:2496
       do_read_cache_folio+0x2d7/0x6b0 mm/filemap.c:4096
       read_mapping_folio include/linux/pagemap.h:1028 [inline]
       read_part_sector+0xd1/0x370 block/partitions/core.c:723
       adfspart_check_ICS+0x93/0x910 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:142 [inline]
       blk_add_partitions block/partitions/core.c:590 [inline]
       bdev_disk_changed+0x7f8/0xc80 block/partitions/core.c:694
       blkdev_get_whole+0x187/0x290 block/bdev.c:764
       bdev_open+0x2c7/0xe40 block/bdev.c:973
       blkdev_open+0x34e/0x4f0 block/fops.c:697
       do_dentry_open+0x6d8/0x1660 fs/open.c:949
       vfs_open+0x82/0x3f0 fs/open.c:1081
       do_open fs/namei.c:4671 [inline]
       path_openat+0x208c/0x31a0 fs/namei.c:4830
       do_file_open+0x20e/0x430 fs/namei.c:4859
       do_sys_openat2+0x10d/0x1e0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x12d/0x210 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:199 [inline]
       __synchronize_srcu+0xa1/0x2a0 kernel/rcu/srcutree.c:1505
       blk_mq_wait_quiesce_done block/blk-mq.c:284 [inline]
       blk_mq_wait_quiesce_done block/blk-mq.c:281 [inline]
       blk_mq_quiesce_queue block/blk-mq.c:304 [inline]
       blk_mq_quiesce_queue+0x149/0x1c0 block/blk-mq.c:299
       elevator_switch+0x17b/0x7e0 block/elevator.c:576
       elevator_change+0x352/0x530 block/elevator.c:681
       elevator_set_default+0x29e/0x360 block/elevator.c:754
       blk_register_queue+0x412/0x590 block/blk-sysfs.c:940
       __add_disk+0x73f/0xe40 block/genhd.c:528
       add_disk_fwnode+0x118/0x5c0 block/genhd.c:597
       add_disk include/linux/blkdev.h:785 [inline]
       nbd_dev_add+0x77a/0xb10 drivers/block/nbd.c:1984
       nbd_init+0x291/0x2b0 drivers/block/nbd.c:2692
       do_one_initcall+0x11d/0x760 init/main.c:1382
       do_initcall_level init/main.c:1444 [inline]
       do_initcalls init/main.c:1460 [inline]
       do_basic_setup init/main.c:1479 [inline]
       kernel_init_freeable+0x6e5/0x7a0 init/main.c:1692
       kernel_init+0x1f/0x1e0 init/main.c:1582
       ret_from_fork+0x754/0xd80 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1a2/0x1b90 kernel/locking/mutex.c:776
       queue_requests_store+0x38b/0x660 block/blk-sysfs.c:117
       queue_attr_store+0x25f/0x2f0 block/blk-sysfs.c:866
       sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:142
       kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:352
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x6ac/0x1070 fs/read_write.c:688
       ksys_pwrite64 fs/read_write.c:795 [inline]
       __do_sys_pwrite64 fs/read_write.c:803 [inline]
       __se_sys_pwrite64 fs/read_write.c:800 [inline]
       __x64_sys_pwrite64+0x1eb/0x250 fs/read_write.c:800
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#26){++++}-{0:0}:
       blk_alloc_queue+0x610/0x790 block/blk-core.c:461
       blk_mq_alloc_queue+0x174/0x290 block/blk-mq.c:4429
       __blk_mq_alloc_disk+0x29/0x120 block/blk-mq.c:4476
       loop_add+0x498/0xb60 drivers/block/loop.c:2049
       loop_init+0x1d3/0x200 drivers/block/loop.c:2288
       do_one_initcall+0x11d/0x760 init/main.c:1382
       do_initcall_level init/main.c:1444 [inline]
       do_initcalls init/main.c:1460 [inline]
       do_basic_setup init/main.c:1479 [inline]
       kernel_init_freeable+0x6e5/0x7a0 init/main.c:1692
       kernel_init+0x1f/0x1e0 init/main.c:1582
       ret_from_fork+0x754/0xd80 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1cf/0x380 kernel/locking/lockdep.c:5825
       __fs_reclaim_acquire mm/page_alloc.c:4348 [inline]
       fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4362
       might_alloc include/linux/sched/mm.h:317 [inline]
       prepare_alloc_pages+0x166/0x5f0 mm/page_alloc.c:5018
       __alloc_frozen_pages_noprof+0x19a/0x2ba0 mm/page_alloc.c:5239
       alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2484
       alloc_frozen_pages_noprof mm/mempolicy.c:2555 [inline]
       alloc_pages_noprof+0x131/0x390 mm/mempolicy.c:2575
       pagetable_alloc_noprof include/linux/mm.h:3404 [inline]
       pmd_alloc_one_noprof include/asm-generic/pgalloc.h:143 [inline]
       __pmd_alloc+0x3b/0x9c0 mm/memory.c:6709
       pmd_alloc include/linux/mm.h:3320 [inline]
       __handle_mm_fault+0xa99/0x2b60 mm/memory.c:6406
       handle_mm_fault+0x36d/0xa20 mm/memory.c:6623
       do_user_addr_fault+0x74c/0x12f0 arch/x86/mm/fault.c:1385
       handle_page_fault arch/x86/mm/fault.c:1474 [inline]
       exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
       rep_movs_alternative+0x30/0x90 arch/x86/lib/copy_user_64.S:53
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
       _inline_copy_from_user include/linux/uaccess.h:185 [inline]
       _copy_from_user+0x98/0xd0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:223 [inline]
       get_user_ifreq+0x77/0x1c0 net/socket.c:3350
       br_ioctl_stub+0x23d/0x4d0 net/bridge/br_ioctl.c:409
       br_ioctl_call+0x53/0xa0 net/socket.c:1227
       sock_ioctl+0x616/0x6b0 net/socket.c:1329
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> k-sk_lock-AF_INET6 --> &mm->mmap_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&mm->mmap_lock);
                               lock(k-sk_lock-AF_INET6);
                               lock(&mm->mmap_lock);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by syz.3.3387/17804:
 #0: ffffffff905e2228 (br_ioctl_mutex){+.+.}-{4:4}, at: br_ioctl_call+0x34/0xa0 net/socket.c:1225
 #1: ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:611 [inline]
 #1: ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/mmap_lock.c:441 [inline]
 #1: ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x35/0x6f0 mm/mmap_lock.c:501

stack backtrace:
CPU: 0 UID: 0 PID: 17804 Comm: syz.3.3387 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1cf/0x380 kernel/locking/lockdep.c:5825
 __fs_reclaim_acquire mm/page_alloc.c:4348 [inline]
 fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4362
 might_alloc include/linux/sched/mm.h:317 [inline]
 prepare_alloc_pages+0x166/0x5f0 mm/page_alloc.c:5018
 __alloc_frozen_pages_noprof+0x19a/0x2ba0 mm/page_alloc.c:5239
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2484
 alloc_frozen_pages_noprof mm/mempolicy.c:2555 [inline]
 alloc_pages_noprof+0x131/0x390 mm/mempolicy.c:2575
 pagetable_alloc_noprof include/linux/mm.h:3404 [inline]
 pmd_alloc_one_noprof include/asm-generic/pgalloc.h:143 [inline]
 __pmd_alloc+0x3b/0x9c0 mm/memory.c:6709
 pmd_alloc include/linux/mm.h:3320 [inline]
 __handle_mm_fault+0xa99/0x2b60 mm/memory.c:6406
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6623
 do_user_addr_fault+0x74c/0x12f0 arch/x86/mm/fault.c:1385
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:rep_movs_alternative+0x30/0x90 arch/x86/lib/copy_user_64.S:60
Code: 83 f9 08 73 25 85 c9 74 0f 8a 06 88 07 48 ff c7 48 ff c6 48 ff c9 75 f1 e9 bd 93 04 00 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 <48> 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 db 83 f9 08
RSP: 0018:ffffc900044e7c18 EFLAGS: 00050202
RAX: 0000000000000001 RBX: 0000000000000008 RCX: 0000000000000028
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffc900044e7cd0
RBP: 0000000000000028 R08: 0000000000000001 R09: fffff5200089cf9e
R10: ffffc900044e7cf7 R11: 0000000000000001 R12: 0000000000000000
R13: ffffc900044e7cd0 R14: ffffc900044e7cd0 R15: 0000000000000000
 copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
 raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
 _inline_copy_from_user include/linux/uaccess.h:185 [inline]
 _copy_from_user+0x98/0xd0 lib/usercopy.c:18
 copy_from_user include/linux/uaccess.h:223 [inline]
 get_user_ifreq+0x77/0x1c0 net/socket.c:3350
 br_ioctl_stub+0x23d/0x4d0 net/bridge/br_ioctl.c:409
 br_ioctl_call+0x53/0xa0 net/socket.c:1227
 sock_ioctl+0x616/0x6b0 net/socket.c:1329
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9f4239c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9f432ed028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f9f42616180 RCX: 00007f9f4239c629
RDX: 0000000000000008 RSI: 00000000000089a2 RDI: 0000000000000003
RBP: 00007f9f42432b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9f42616218 R14: 00007f9f42616180 R15: 00007ffd31101248
 </TASK>
----------------
Code disassembly (best guess):
   0:	83 f9 08             	cmp    $0x8,%ecx
   3:	73 25                	jae    0x2a
   5:	85 c9                	test   %ecx,%ecx
   7:	74 0f                	je     0x18
   9:	8a 06                	mov    (%rsi),%al
   b:	88 07                	mov    %al,(%rdi)
   d:	48 ff c7             	inc    %rdi
  10:	48 ff c6             	inc    %rsi
  13:	48 ff c9             	dec    %rcx
  16:	75 f1                	jne    0x9
  18:	e9 bd 93 04 00       	jmp    0x493da
  1d:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  24:	00 00 00 00
  28:	66 90                	xchg   %ax,%ax
* 2a:	48 8b 06             	mov    (%rsi),%rax <-- trapping instruction
  2d:	48 89 07             	mov    %rax,(%rdi)
  30:	48 83 c6 08          	add    $0x8,%rsi
  34:	48 83 c7 08          	add    $0x8,%rdi
  38:	83 e9 08             	sub    $0x8,%ecx
  3b:	74 db                	je     0x18
  3d:	83 f9 08             	cmp    $0x8,%ecx


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

