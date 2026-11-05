Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A645606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C57A6B05B2; Thu,  5 Nov 2026 06:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4783C6B05BA; Thu,  5 Nov 2026 06:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C6B6B05BF; Thu,  5 Nov 2026 06:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10E526B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:22:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C56AA867C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:22:38 +0000 (UTC)
X-FDA: 85400827596.26.3CA4D22
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0103BA0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:22:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3_GbsagkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3_GbsagkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0HDImICxJh3jNrQBVW5054s3CUghVutij9O/9PEuBwI=;
	b=2NsuD7W4lBvM8gnr9l4hv92IIqa/gr1uk4jIoT3v8uwLW6oVFljbHyLi+qVW/nRmuOxbhv
	6s/brHBcsicspGl0FQN6sVaGSsvrvC8hpqf1hr4dlZ/jDiNRYlrCKkAN5TCBeyXIL2cYbO
	IW4Gw7vxusf8w/PLqXAGcfBVexR8wmw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3_GbsagkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3_GbsagkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877757;
	b=K46zxhPAghrTkwdvmIEwCt5pwIuk+V2SPkPkctFRfy6DLLbLi9+S5NptYbnfhg9cbSosNO
	VNn1ZDGyuj/qjBenwGkB32oJBd1KwIPzUjzorpYOHRxAfSv1voWYIIpoY+/mlN6cLK63gh
	2eo9LoOTkt/oKzsQmXr6nzpT9cBV0JY=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab4f652f9bso1343627b6e.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:22:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793877756; x=1794482556;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0HDImICxJh3jNrQBVW5054s3CUghVutij9O/9PEuBwI=;
        b=RmkseUCII8aPGW0GPzx8FGX8OG3i9XnJCN44fALyLwGyOhekLMa7cwAiliKixNE1CI
         nQrJILcGtaHNz4/TNmDF6/U1dbJDxSgIZLd8fVbw9pErdWricAHHF2sQczKPTz7ta67N
         0CgxOmVi4KThuBXQhZTe1vtuWrHlXkPQmtHj12Y1KPKgkERiG0az9ZGt3nSbsnO9ztkc
         zzvitHZjD8x8D6M3PDfmqa81PiSS3j6i5Vq9WD2EpH3aVmI/CKENjsqPh0AuMgSLn4KR
         kjgg/hkECUplh3lkOMs79wLFG1Ax3ORk9ZgNp+jHhxVECg4V2LEGwGHqYmaEyiYh4JAq
         jnwA==
X-Forwarded-Encrypted: i=1; AKwUvByXjeMJ+A6tjT6rGTGgSz+ClzoDs8DmUTPSHLVzboDboHi6HwPiTL35htrasyI9ntjF01poIogKrg==@kvack.org
X-Gm-Message-State: APuU4Z+tDMx/7IeN48Diu6DgNsNYM+BmiffJ7gUOcmZptpYeelad82WP
	qgC1RjGwqCjaPpdmbX8PXtZSr7dLVc1CQlQUoFpKDamYaw9KzD4eo3OllCHDmmL/xN0f9Hvu2g3
	zSFK8Eh0oWwIaEn+S45COcAOD8nHPFfOjl7vsFkED69uxfQa0Wzmp0Fst65c=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b2c:b0:4e5:2f2e:45b4 with SMTP id
 5614622812f47-5640dc2a7a3mr12521050b6e.21.1793877756067; Thu, 05 Nov 2026
 03:22:36 -0800 (PST)
Date: Thu, 05 Nov 2026 03:22:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aec66fc.059f5055.2712e4.0001.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] possible deadlock in hugetlbfs_file_mmap
From: syzbot <syzbot+d7d72f3d467710442af0@syzkaller.appspotmail.com>
To: david@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	netdev@vger.kernel.org, osalvador@suse.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: p9fnn1ki66pdcitf5qpcmamnguad9gu5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0103BA0003
X-HE-Tag: 1793877756-550278
X-HE-Meta: U2FsdGVkX1/YCQGqFNA3+ccsoaiUfFr4D+hM6s4vMhehFU2A53ZlifyyU+sTtB2R9Mm+C3JCHf6Rb1ICtXDDQULnUTxHXtMg5gKOGnwYPfPhoZYsoLEkKAFeFnoc/bZYlXbFRH7vlCBItSyp9M7stvdhxPe1MtX5xOTIGvy3x6ZWYhVFsrEQLhmIty9bCSX8lAyJAfeYmtqADY1KZr8voww3bPj5onsf7Rw/LI8fITMS6Mp0OFW4mxxreCLwCgwSitvA+PbrZ0kz6is23/jzrjXTpKtLsXOeDsnwJv5SRVHrvNjJeoz0QUw7GYY7zDIN0YruA6mFWDy8LfiGATIukomnJ+qNoX2EE6XV4oKzte+SdLV9adPrDDY2PHmbeKUq3Nk8apg5DIr2Nar7OF+/kFkoRyntLFAYJ9J3HlGjq2/Aihkqxy8iE1jjsokPpx1dKMQlinWXcMi2mzEL3ay++Voac5GI6uyHEQPVmT8//NahXvev0qVaiE1j/N73sRvZbEoxpwJ64LcxKe6g9U3ZL9NHXlKUkKT9Pd3ladPR9kfGlGMMtIB16L2siC8+u1EAQ5ltBvhWAJJ0PHdKhnIhKOigoQik+9u6wF5wS5w75ohLJOQVFWBSV6WtH2qB9IWhFcBmIg3ICK2wkwduwdlOEYWBuCHmz0fUDZQ0wj/Si+fs3yiPDTGSUFRZyr7pRo5FsO5cSKIneskC9m6pVK0QQDoS3cKeZO6X1OMEU0/elxokNVSdbcOy4j0VLXhOByRzZ3WvDmpcT9juLPHo9uZMy2xBKIMH1DhZosc8ETi9fFXpRq2kxJY8XFMJBvrQPKkiBmXrWxGDD1lyf49HjqwoYbexLGx38ciUilc8e7R+7FhAoOamCUmfPCE61pzE2vPCHNZwIwQ5CFvBfg4dfWlFWwD0xFRLQrmkCDLi+Pu4gV4Y77mTiZJ9x4xekVDT5AN2ENWh38qDdCZ4tm1UM3P
 fnhcHEn9
 38M4rsT6HiiUYDPhwJ8QrRs8VFFSpsltTfOUjfGf9qJvBKJ9scYzhhSZMPWLpZZCCXUw7kEUOLejy8B6dLgHPc8DwHFPKtYg0ZwigYp5+N1fbXJ3XlJjRUacNCxirP5+6/WELcDu4JfSde3s5dITmwA5yirdiJ0ttwDSMVKIY/NGqWqM/rIzatiSSzTJukgePRWz/mMkwI/xeoWop6mY1PUp3PEluGzWcmJJjRWC/dddf9jwKerCyaKrIJ6WgwBUI8irAnA9NSzBdWvIWgot9T+E4/vzz4tawAz8F4v3aPvBRWxqqNrRNjuPIaP8jipqPpTu657JCsZ1ZuktcVQbCHEaWiZHyL8Hq9o0m0HPDBLbjCgeiZUyowjufcrmKX7jgRDk0PJxIlRMlI0Np3R11/Gw6y32eDxSOJCs/Rt949n7mpM3VsHrqngSlJZiVBIuapbj3dTlnrdoBeBdYSrKr98Q8FHv4TKQy95xFbQtV5kazzYJKQMadauGEA9fyZYSu/VGnb/35dBzy4FJl3hh8Lsq9q1bQj34doLYGMN4hmpRQdHFyIOkp2rfw2/GFr3ONZojCnTn4twdbD1mKTtR4QQkG4n1uMo8Bi5KQv1Fb3rA8Zfh8t25Yekhbb0UtHUokwm6qkD6Zg+oIcJcsfwnc3QVJ4HCC58PjKvOThc4NHbD8Z3f2kFIHmvJH0piSo58SYK5yU1qy0AK0ZNDe905VbGo70I2W5jnPvhI1i6omVMVOIG4eS/A/NDAGwGuQ3NtlB379RFqD8LJAj0UggOTxqOOOq+EbR+aq0Whr2oGsYkNhqdXYhTCiJvOF2aJRa2+wlbMpadStCDh1uDk1D3lfmI7ex9x5XWJcdKkkut0QHg9qQQduUopaxHBG1I7iiPPMG5m1BAZFcgzgmKkampJ7lLQrLOvwvL7ZoHmPkjxN9qpgQRM+p9JC5AFkh9h9AD2fcU5fnGA2MOCgksvAiMZ87RjNb8dt
 tKoy+l64
 ahJFGLXwl/vTVXiBj9E8N/TG9NKAkt0Jk+NOxb7vrQUxPuqP0ySWT9u+gvDxd6kFoc9Q9XQokZC4FsDpaEHQ0awlD9HErCj5cZIA7b8+Vh5TDTaYO3Q2TvtaeLstVl1n65inhI167+6EK4263iLec+AlsB/qdNyOFa/WrzRkd92NaC333UO63yOrTzXh7QjPQwXJ6bzCW9lZ4+HybEPzpT0nCuPskTok1zibjrYx4BOyWfbIKpOrABn6Yd1cEDNhOgw5tBopUm1kDeWEggFtDzbObwecowsx5xemrSwKqTmCLy4N+I8UHO/tn8Y+NRv43lWHbU1wdjve2XhgeyJdT0kEVUlLGHLSx81FqJm7/rmFcU+KsiAKuOac1X5SuPSrDHQgi0PQSqhZBXbbFb4BA3P+cGU925PcW+MiPiPo7KCIKsDfcdJjQjUJGeGql22lN3fGUUdM6Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    c3e67bd82b9b ipv6: reject wrapped temporary address prefer..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15c1162d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d30e1495ee3ac817
dashboard link: https://syzkaller.appspot.com/bug?extid=d7d72f3d467710442af0
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e07bb7d41be1/disk-c3e67bd8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d44a4b5bff57/vmlinux-c3e67bd8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a7ebe221505e/bzImage-c3e67bd8.xz

AI-generated root cause summary:
In the Network Block Device (NBD) driver, sockets used for block transport must
be reclassified to dedicated lockdep lock classes (sk_lock-AF_INET-NBD) to avoid
false and real circular locking dependencies with userspace network sockets that
acquire mm->mmap_lock on page faults. While nbd_add_socket() properly invokes
nbd_reclassify_socket(), nbd_genl_reconnect_sock_cb() replaces dead sockets
during reconnection via nbd_get_socket() without calling
nbd_reclassify_socket(). As a result, the reconnected socket retains the generic
sk_lock-AF_INET lock class, causing socket operations like
kernel_sock_shutdown() executed under &nsock->tx_lock (e.g., in recv_work ->
nbd_mark_nsock_dead) to register a dependency chain from fs_reclaim through
blk-mq queue usage, elevator lock, &cmd->lock, and &nsock->tx_lock to
sk_lock-AF_INET and mm->mmap_lock, producing a circular locking dependency
warning.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=d7d72f3d467710442af0

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7d72f3d467710442af0@syzkaller.appspotmail.com

netlink: 8 bytes leftover after parsing attributes in process `syz.2.139'.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.2.139/6452 is trying to acquire lock:
ffffffff90094cc0 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:316 [inline]
ffffffff90094cc0 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4673 [inline]
ffffffff90094cc0 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5011 [inline]
ffffffff90094cc0 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x61/0x600 mm/slub.c:5676

but task is already holding lock:
ffff88803e6af1b0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff88803e6af1b0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: hugetlbfs_file_mmap+0x2de/0x630 fs/hugetlbfs/inode.c:138

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
       down_write+0x91/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       hugetlbfs_file_mmap+0x2de/0x630 fs/hugetlbfs/inode.c:138
       vfs_mmap include/linux/fs.h:2068 [inline]
       mmap_file mm/internal.h:256 [inline]
       __mmap_new_file_vma mm/vma.c:2623 [inline]
       __mmap_new_vma mm/vma.c:2720 [inline]
       __mmap_region mm/vma.c:3054 [inline]
       mmap_region+0x1d5e/0x2840 mm/vma.c:3136
       do_mmap+0xe0a/0x1300 mm/mmap.c:573
       vm_mmap_pgoff+0x27a/0x520 mm/util.c:581
       ksys_mmap_pgoff+0x57d/0x760 mm/mmap.c:619
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault+0xcb/0x130 mm/memory.c:7530
       _copy_from_iter+0x100/0x1680 lib/iov_iter.c:271
       copy_from_iter include/linux/uio.h:236 [inline]
       copy_from_iter_full include/linux/uio.h:253 [inline]
       skb_do_copy_data_nocache include/net/sock.h:2333 [inline]
       skb_copy_to_page_nocache include/net/sock.h:2359 [inline]
       tcp_sendmsg_locked+0x214a/0x53c0 net/ipv4/tcp.c:1321
       tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1462
       sock_sendmsg_nosec+0x10f/0x190 net/socket.c:801
       __sock_sendmsg net/socket.c:818 [inline]
       sock_write_iter+0x2de/0x3e0 net/socket.c:1269
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (sk_lock-AF_INET){+.+.}-{0:0}:
       lock_sock_nested+0x41/0x100 net/core/sock.c:3908
       lock_sock include/net/sock.h:1717 [inline]
       inet_shutdown+0x6a/0x390 net/ipv4/af_inet.c:911
       nbd_mark_nsock_dead+0x2cb/0x550 drivers/block/nbd.c:319
       recv_work+0x1d14/0x1e30 drivers/block/nbd.c:1030
       process_one_work kernel/workqueue.c:3495 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #5 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       nbd_handle_cmd drivers/block/nbd.c:1143 [inline]
       nbd_queue_rq+0x373/0xff0 drivers/block/nbd.c:1207
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2131
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x167/0x2f0 block/blk-mq.c:2546
       process_one_work kernel/workqueue.c:3495 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #4 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       nbd_queue_rq+0xc1/0xff0 drivers/block/nbd.c:1199
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2131
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x167/0x2f0 block/blk-mq.c:2546
       process_one_work kernel/workqueue.c:3495 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #3 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:225 [inline]
       __synchronize_srcu+0xca/0x2f0 kernel/rcu/srcutree.c:1662
       elevator_switch+0x1e8/0x7b0 block/elevator.c:576
       elevator_change+0x2fa/0x480 block/elevator.c:681
       elevator_set_default+0x375/0x440 block/elevator.c:754
       blk_register_queue+0x404/0x4f0 block/blk-sysfs.c:992
       __add_disk+0x6b8/0xdb0 block/genhd.c:531
       add_disk_fwnode+0x100/0x3a0 block/genhd.c:600
       add_disk include/linux/blkdev.h:801 [inline]
       nbd_dev_add+0x733/0xb60 drivers/block/nbd.c:2026
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2743
       do_one_initcall+0x250/0x870 init/main.c:1419
       do_initcall_level+0x10a/0x1a0 init/main.c:1481
       do_initcalls+0x59/0xa0 init/main.c:1497
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1732
       kernel_init+0x22/0x1d0 init/main.c:1622
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       elevator_change+0x1af/0x480 block/elevator.c:679
       elevator_set_none+0xb5/0x140 block/elevator.c:769
       blk_mq_elv_switch_none block/blk-mq.c:5114 [inline]
       __blk_mq_update_nr_hw_queues block/blk-mq.c:5159 [inline]
       blk_mq_update_nr_hw_queues+0x5ef/0x19e0 block/blk-mq.c:5224
       nbd_start_device+0x189/0xb30 drivers/block/nbd.c:1530
       nbd_genl_connect+0x167d/0x1cd0 drivers/block/nbd.c:2310
       genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
       genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
       genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
       netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2584
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
       netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
       netlink_unicast+0x8ef/0xa80 net/netlink/af_netlink.c:1361
       netlink_sendmsg+0x7f0/0xb20 net/netlink/af_netlink.c:1920
       sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
       __sock_sendmsg net/socket.c:818 [inline]
       ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
       ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
       __sys_sendmsg net/socket.c:2801 [inline]
       __do_sys_sendmsg net/socket.c:2806 [inline]
       __se_sys_sendmsg net/socket.c:2804 [inline]
       __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#49){++++}-{0:0}:
       blk_alloc_queue+0x544/0x690 block/blk-core.c:505
       blk_mq_alloc_queue block/blk-mq.c:4439 [inline]
       __blk_mq_alloc_disk+0x194/0x390 block/blk-mq.c:4486
       nbd_dev_add+0x494/0xb60 drivers/block/nbd.c:1996
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2743
       do_one_initcall+0x250/0x870 init/main.c:1419
       do_initcall_level+0x10a/0x1a0 init/main.c:1481
       do_initcalls+0x59/0xa0 init/main.c:1497
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1732
       kernel_init+0x22/0x1d0 init/main.c:1622
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       __fs_reclaim_acquire mm/page_alloc.c:4360 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4374
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4673 [inline]
       slab_alloc_node mm/slub.c:5011 [inline]
       __kmalloc_cache_noprof+0x61/0x600 mm/slub.c:5676
       _kmalloc_noprof include/linux/slab.h:991 [inline]
       resv_map_alloc+0x51/0x2c0 mm/hugetlb.c:1096
       hugetlb_reserve_pages+0x36d/0x1160 mm/hugetlb.c:6813
       hugetlbfs_file_mmap+0x475/0x630 fs/hugetlbfs/inode.c:152
       vfs_mmap include/linux/fs.h:2068 [inline]
       mmap_file mm/internal.h:256 [inline]
       __mmap_new_file_vma mm/vma.c:2623 [inline]
       __mmap_new_vma mm/vma.c:2720 [inline]
       __mmap_region mm/vma.c:3054 [inline]
       mmap_region+0x1d5e/0x2840 mm/vma.c:3136
       do_mmap+0xe0a/0x1300 mm/mmap.c:573
       vm_mmap_pgoff+0x27a/0x520 mm/util.c:581
       ksys_mmap_pgoff+0x57d/0x760 mm/mmap.c:619
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &mm->mmap_lock --> &sb->s_type->i_mutex_key#24

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sb->s_type->i_mutex_key#24);
                               lock(&mm->mmap_lock);
                               lock(&sb->s_type->i_mutex_key#24);
  lock(fs_reclaim);

 *** DEADLOCK ***

locks held by syz.2.139/6452: 2, last CPU#1:
 #0: ffff8880375bccc0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:550 [inline]
 #0: ffff8880375bccc0 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x1ed/0x520 mm/util.c:579
 #1: ffff88803e6af1b0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff88803e6af1b0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: hugetlbfs_file_mmap+0x2de/0x630 fs/hugetlbfs/inode.c:138

stack backtrace:
CPU: 1 UID: 0 PID: 6452 Comm: syz.2.139 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 __fs_reclaim_acquire mm/page_alloc.c:4360 [inline]
 fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4374
 might_alloc include/linux/sched/mm.h:316 [inline]
 slab_pre_alloc_hook mm/slub.c:4673 [inline]
 slab_alloc_node mm/slub.c:5011 [inline]
 __kmalloc_cache_noprof+0x61/0x600 mm/slub.c:5676
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 resv_map_alloc+0x51/0x2c0 mm/hugetlb.c:1096
 hugetlb_reserve_pages+0x36d/0x1160 mm/hugetlb.c:6813
 hugetlbfs_file_mmap+0x475/0x630 fs/hugetlbfs/inode.c:152
 vfs_mmap include/linux/fs.h:2068 [inline]
 mmap_file mm/internal.h:256 [inline]
 __mmap_new_file_vma mm/vma.c:2623 [inline]
 __mmap_new_vma mm/vma.c:2720 [inline]
 __mmap_region mm/vma.c:3054 [inline]
 mmap_region+0x1d5e/0x2840 mm/vma.c:3136
 do_mmap+0xe0a/0x1300 mm/mmap.c:573
 vm_mmap_pgoff+0x27a/0x520 mm/util.c:581
 ksys_mmap_pgoff+0x57d/0x760 mm/mmap.c:619
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14e739fb19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f14e8278028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f14e7625fa0 RCX: 00007f14e739fb19
RDX: 0000000000000000 RSI: 0000000001400000 RDI: 0000200000000000
RBP: 00007f14e7437b70 R08: ffffffffffffffff R09: 0000000000000000
R10: 00000000000c3072 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f14e7626038 R14: 00007f14e7625fa0 R15: 00007ffebda95258
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

