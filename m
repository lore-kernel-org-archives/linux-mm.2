Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A5ACCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1562B8E00A1; Thu,  9 Oct 2025 13:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E5F8E002C; Thu,  9 Oct 2025 13:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AF78E00A1; Thu,  9 Oct 2025 13:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3DFD8E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:30:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88415C0A56
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:30:30 +0000 (UTC)
X-FDA: 83979265020.27.1097968
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf21.hostedemail.com (Postfix) with ESMTP id CEC1E1C0015
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:30:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3M_HnaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3M_HnaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760031028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0/lGww42l94fi+CyzoEPT8joNPHXoCvF/8ee2MY6onw=;
	b=aL0AHznIM6ORq9uVAMQ2iKV0dbtiMQZ8SOMpFajH6IokQRhoiy584aikt4/+xZ3fxy3726
	a/0+6Pr3axebHMQk6T4bfhqqIhYcqGZXBMpDHOCzd84ZeIEL20itcBPph46kE0t1DBNllN
	aEXA2EHgqUbsy1fc5f4ciNnK7O2qnZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760031028; a=rsa-sha256;
	cv=none;
	b=ZKNlOQuMl4Omcxx+9RovzYzlgpnnps+rDE5TI+O/Lw2G8oNCIRC1YB9ZQ2hp5e5+1OUkZo
	HkVz8OEXT9pJx6oxf8usBuITIecgK89znhmnaE6cAVo7+Q5al6vZgZZ5TEUg3IO17h8QwR
	2mk/6VlElzV1E9F/fbR04z8NMaunERI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3M_HnaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3M_HnaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-42f9b476ca8so1699215ab.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 10:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760031028; x=1760635828;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0/lGww42l94fi+CyzoEPT8joNPHXoCvF/8ee2MY6onw=;
        b=rU3SS7eMgtHh+WcTuwZGmI76xKVB0b8l5u95FYTX17e/mFK3LWlViAwDAB7rMtRSGQ
         LgT4HeRjKxukh8aXEEPUow5o1aswFC4NR6+Xe6Zk7rm8T4v8sjdbFYOjU1uZZJsX83c8
         Inswt+28z683SA4iZJvsSXcJN+cyJxcpcTRsHy1nbC0NK6X1Szry45/myw6gbb+35daV
         oLE7VS0Ej3OS+fKRXwc5GLopf2CWGggFWrNehywFDjZKO2WOKlErlgFrz64z7RoHjQFS
         U4ytR0J0+U/gBHmC2noHnq/udpDaUO2gxzrtl4qROAqw4CDhsz2HJbWt+5/mx5Yn48xI
         g2+A==
X-Forwarded-Encrypted: i=1; AJvYcCUmVJ0nErtX+8lpEiVWVq5AkAXsVcm2LKV00nZWYaSQfXO0YCeqc2x/UQaSRIm4zDoH+AgWIgXjFQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+bs8pYFbUjbL4ERRaKYALSFPg6mkDS++LljvcN/XTOilK7+nF
	hU2f3poAkWZ5n7wQ1D8bzhUFkGnflaYGg3Iqdp1oAsPn+nt9pmcssPmmW9THfqC/NITtcF2g511
	BrRTKNtqkPrzIDIt8UdM7FW3Du6O/oHeBivNKbKhWSxwkObwJvg+Na3ra+1g=
X-Google-Smtp-Source: AGHT+IHUUXjA9ovsDluQrrPku8Wr46g+OZlO6WEpIswc8ztnKRizb6djrRCR+QzDFru+AUeqDLPOhhNJSD1Yhmrf5kvS3KvAhLzO
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:23c3:b0:42f:8afa:326f with SMTP id
 e9e14a558f8ab-42f8afa34damr71624925ab.19.1760031027931; Thu, 09 Oct 2025
 10:30:27 -0700 (PDT)
Date: Thu, 09 Oct 2025 10:30:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e7f133.050a0220.91a22.000a.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in hugetlb_vma_lock_read
From: syzbot <syzbot+1ad78f6a1785a2fceb88@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: CEC1E1C0015
X-Rspamd-Server: rspam02
X-Stat-Signature: 9ykuw7kryacjrpbj7fuuq4jintker4hi
X-HE-Tag: 1760031028-939911
X-HE-Meta: U2FsdGVkX19jw4LYGH9DKjVfLW5Ziy3624uob/UpzWdLRag78hAxYclCWOgPcF57JbTF/sjZm/soAXiJpf+ytbw942eieszcci2FTEJJwzYHS7Y7XT1ekxLHrMBv18EKutkVDrrV90QYOa9R/7ayRY/oXBJHEhXUZ5uj2MJ4hkf0g8DxECakch/Ka2FE8/MmrGgy1FN2RUePa7iiZI8nuxdc9+vdWZ0mbYcJz5h3HiHfz7ilW6MCapy3KgAprWGxrNoQeiecS3TRkSZirdVfbpCc9P9lC9zOuAO1XpHEdqhe9VV2xIEHVGeJsq3cVCH4he8BYrzE2VarcmT8bHYcJ+4R6MxIbV6AS17F2yJ4MMvhk4aFvlLS1vNl4IHggEqFvEVFuN4VouIbp5W2PSRqtpBKIOTwFabZIqcDxhPWZcfbka8BmNv5kRxLckfwjpSJ5wJMsmF+kagIEXs9XdMi1Y5WcuLykmzPsjoWstLqKsYTXoCl0WcmyBjAEg9GgK8AbDzfjxRzgM3KCKXwkeia27SvrU2OG7YspR8WOmbYpQCu6nUUT34u9RoniDaQCudZyF3nxVdE8a505I80xcfWxm02bf918wZA4ElqYVAx+CFYN7dArTZPx/KygXvLRo0UQo8okXTvs1jy1g76kBv950BZZ0ljTiI0OovvF0oxTWqA0nb2vQ+y7brpE9OdsC2WaSsblkCxZuCbGJ4VPluJa/jwm5/mpXS8AlXdvhvgKuBCbI9TYjEPkTqAfbFxC3GvtC48EmqT5XkYBUg3S17FY/fa6ylUCPmtrCye9SzAPmdn+i6+axkzi2KGu4iqIgP+V0pUx8qH8OBLX+wvh9fj5tzBfbE+tSlFd7biOQwIDwWwi+TT01BKE6Hbe0GgS91WMkqj23V5xY37UJlkZ5h4KYideH7cB4PolAq3rNVMwyCwiJMDw1uHTnAZkksKykEnkmRkOfnsfu69U7RD/I4
 J6R6O3Up
 qwi23yhJRpmBQp3bhQMk5H/Tr9a47fVSDslJxJmQsl68+e0K7+jqjwchoY6JRZlRxWoQZ7km1hPlUp5UCpEHUfiz60Ta7dhoPEgiR3NShJ7W3r0Txd5tkOIQEfFSU2okVcJ5LcgjZRGs/wVPFaR+ahKpgQ+WviKLj12SqnO8NlPcfUlbFRpqxoyU9S4NaYjK8md/8GLIgAuPof1QAAY8iC6pcDfMb9tOm3SOc84k59T5bGHQWHE0VSN6x4Og3cA6m+Js7wuMJ79DPE31tgzxJRf73EnbnYpw3mXCARoe0u+9fYpqX7ChNWWAVWufSaZjF3ZpfD9PXncb74aebhD/Om5wAcLgv1T3KNbRuSmMNzzXLy8JdwuOookCZyXc/5DyPjxB2O0K8DTMC5j7N3yDHoDHoRf/uLOevgV3O+QSuRAGnx6flEQtrfLQr9nW0w0bmOKR6nj6N2IeV5B5p4Y6B8d+U+lcbsXyJ3uueaFxC+q31v+/+BAvmQw4mxRiMZk6wlYYbopgXyVSA3bm8GlI6uSc86Qm+2kG1INkwYVrc451n45tXsJ9EnK/FPc8dBPaKyJT2tTmHZDpw0Ey3K/6+SpGA1heKLwov1JSyRWee9CRZqy90q9H4XXnxZ+EawpsX5I1v2KjyPZINmq9N8wxzUvHdEK/0k9mVjI7YC+ehpCCiVdu4ZI7edfHN7vhhecRUa/aKOluBw3oL3udj0spuwVSTzE/d4LCPNWaTFL6b9AF5aCp7tVD/2VX6ykqQ70R2teTw4yyfGBioCqdmc7RdfjZIVPH6wPwy2443UWMt1tAYGrVcjfVD1iq9k1EEKK/pWeHepuNd5ubGrWKIuq7Roh8CYEx59CRTowxw4ikyjxVMixf+9Hdp6Z1MWwYVgIvJ3tiVfCLVMsV43QiCZnS9e2s8xUMalYSLtWiPVJabXSEdHyXvEztwbyomcN/htO2oV4mdlRqTf/POsUAcf15NsXXOV2y7
 af6s9v6W
 H4/z6uxoL/JrEzH674mpJL5B89oZO8vrTkPxbRm9xRZ2nquwQ0oFGv8yw0NmNm707C6CSZh35U1uBBGz8lCqdG+0oB/7tqCjS0EhV2wpIla7a31n3mXZKWKhekalj0WjaZdJSxMZsimR89kD214i1roKinLtzuWYqkWz/aAr+9m3xURFLo2V6S0pwtERW42WJ00uVl6XrmULPznB7BoCK3HgD7kVYMno87wiMbtncVE42uSaH0BZtEexUTHbTvuIPpe5V16bnURN/7yBo1TpAgT0qtJ9Je0WQV37vikwdMJNCTzlluPbP6jF2CDGzJb9aDN6oIIcoGlzK0MrZZDTu3QE/tBamHwEKwznm2+jgrtN7fouhamNB+6zOx4VrgKctAZH0KAjEeJmEE9MiQfkF4Ca+mOtw79JMcU7zkFCPj+D3HwxTZy5FKt/Gh0NWkDhiat4vv4sd1W3DdKhjBWPUulG5fNDC6jRiuI1+zrv23GQRAvKlsCbUEc3CjAgALfq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    fd94619c4336 Merge tag 'zonefs-6.18-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134b9a7c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b33053d3e8155ed
dashboard link: https://syzkaller.appspot.com/bug?extid=1ad78f6a1785a2fceb88
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5e204fe6bdd8/disk-fd94619c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5e94719fef3e/vmlinux-fd94619c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1ec4d60a3bf9/bzImage-fd94619c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1ad78f6a1785a2fceb88@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.3156/19232 is trying to acquire lock:
ffff8880721c60e8 (&resv_map->rw_sema){++++}-{4:4}, at: hugetlb_vma_lock_read mm/hugetlb.c:305 [inline]
ffff8880721c60e8 (&resv_map->rw_sema){++++}-{4:4}, at: hugetlb_vma_lock_read+0xff/0x130 mm/hugetlb.c:296

but task is already holding lock:
ffff888143ea6728 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: hugetlb_fault+0x302/0x2f40 mm/hugetlb.c:6699

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       hugetlb_fault+0x302/0x2f40 mm/hugetlb.c:6699
       handle_mm_fault+0xbfa/0xd10 mm/memory.c:6485
       do_user_addr_fault+0x7a6/0x1370 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       rep_movs_alternative+0x4a/0x90 arch/x86/lib/copy_user_64.S:68
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
       _inline_copy_from_user include/linux/uaccess.h:178 [inline]
       _copy_from_user+0x98/0xd0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       csum_and_copy_from_user include/net/checksum.h:31 [inline]
       copy_from_user_iter_csum net/core/skbuff.c:7328 [inline]
       iterate_ubuf include/linux/iov_iter.h:30 [inline]
       iterate_and_advance2 include/linux/iov_iter.h:302 [inline]
       csum_and_copy_from_iter_full+0x21a/0x1f90 net/core/skbuff.c:7340
       ip_generic_getfrag+0x170/0x270 net/ipv4/ip_output.c:942
       raw_getfrag+0x22d/0x2a0 net/ipv4/raw.c:479
       __ip_append_data+0x34ec/0x41a0 net/ipv4/ip_output.c:1172
       ip_append_data net/ipv4/ip_output.c:1378 [inline]
       ip_append_data+0x10f/0x1a0 net/ipv4/ip_output.c:1357
       raw_sendmsg+0xeee/0x38b0 net/ipv4/raw.c:651
       inet_sendmsg+0x119/0x140 net/ipv4/af_inet.c:853
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0x973/0xc70 net/socket.c:2630
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2684
       __sys_sendmmsg+0x200/0x420 net/socket.c:2773
       __do_sys_sendmmsg net/socket.c:2800 [inline]
       __se_sys_sendmmsg net/socket.c:2797 [inline]
       __x64_sys_sendmmsg+0x9c/0x100 net/socket.c:2797
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (sk_lock-AF_INET){+.+.}-{0:0}:
       lock_sock_nested+0x41/0xf0 net/core/sock.c:3720
       lock_sock include/net/sock.h:1679 [inline]
       inet_shutdown+0x67/0x440 net/ipv4/af_inet.c:907
       nbd_mark_nsock_dead+0xae/0x5d0 drivers/block/nbd.c:318
       recv_work+0x671/0xa80 drivers/block/nbd.c:1018
       process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3263
       process_scheduled_works kernel/workqueue.c:3346 [inline]
       worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
       kthread+0x3c5/0x780 kernel/kthread.c:463
       ret_from_fork+0x56a/0x730 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #6 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       nbd_handle_cmd drivers/block/nbd.c:1140 [inline]
       nbd_queue_rq+0x423/0x12d0 drivers/block/nbd.c:1204
       blk_mq_dispatch_rq_list+0x413/0x1e20 block/blk-mq.c:2129
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xcb7/0x15f0 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd8/0x1b0 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x239/0x670 block/blk-mq.c:2367
       blk_mq_dispatch_list+0x514/0x1310 block/blk-mq.c:2928
       blk_mq_flush_plug_list block/blk-mq.c:2976 [inline]
       blk_mq_flush_plug_list+0x130/0x600 block/blk-mq.c:2948
       __blk_flush_plug+0x2c4/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       blk_finish_plug block/blk-core.c:1249 [inline]
       __submit_bio+0x545/0x690 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x53d/0xc10 block/blk-core.c:755
       submit_bio_noacct+0xbbb/0x1f60 block/blk-core.c:879
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x4db/0x850 fs/buffer.c:2461
       filemap_read_folio+0xc5/0x2a0 mm/filemap.c:2444
       do_read_cache_folio+0x263/0x5c0 mm/filemap.c:4024
       read_mapping_folio include/linux/pagemap.h:999 [inline]
       read_part_sector+0xd4/0x370 block/partitions/core.c:722
       adfspart_check_ICS+0x93/0x940 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x723/0x1520 block/partitions/core.c:693
       blkdev_get_whole+0x187/0x290 block/bdev.c:748
       bdev_open+0x2c7/0xe40 block/bdev.c:957
       blkdev_open+0x34e/0x4f0 block/fops.c:694
       do_dentry_open+0x982/0x1530 fs/open.c:965
       vfs_open+0x82/0x3f0 fs/open.c:1097
       do_open fs/namei.c:3975 [inline]
       path_openat+0x1de4/0x2cb0 fs/namei.c:4134
       do_filp_open+0x20b/0x470 fs/namei.c:4161
       do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x174/0x210 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       nbd_queue_rq+0xbd/0x12d0 drivers/block/nbd.c:1196
       blk_mq_dispatch_rq_list+0x413/0x1e20 block/blk-mq.c:2129
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xcb7/0x15f0 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd8/0x1b0 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x239/0x670 block/blk-mq.c:2367
       blk_mq_dispatch_list+0x514/0x1310 block/blk-mq.c:2928
       blk_mq_flush_plug_list block/blk-mq.c:2976 [inline]
       blk_mq_flush_plug_list+0x130/0x600 block/blk-mq.c:2948
       __blk_flush_plug+0x2c4/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       blk_finish_plug block/blk-core.c:1249 [inline]
       __submit_bio+0x545/0x690 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x53d/0xc10 block/blk-core.c:755
       submit_bio_noacct+0xbbb/0x1f60 block/blk-core.c:879
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x4db/0x850 fs/buffer.c:2461
       filemap_read_folio+0xc5/0x2a0 mm/filemap.c:2444
       do_read_cache_folio+0x263/0x5c0 mm/filemap.c:4024
       read_mapping_folio include/linux/pagemap.h:999 [inline]
       read_part_sector+0xd4/0x370 block/partitions/core.c:722
       adfspart_check_ICS+0x93/0x940 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x723/0x1520 block/partitions/core.c:693
       blkdev_get_whole+0x187/0x290 block/bdev.c:748
       bdev_open+0x2c7/0xe40 block/bdev.c:957
       blkdev_open+0x34e/0x4f0 block/fops.c:694
       do_dentry_open+0x982/0x1530 fs/open.c:965
       vfs_open+0x82/0x3f0 fs/open.c:1097
       do_open fs/namei.c:3975 [inline]
       path_openat+0x1de4/0x2cb0 fs/namei.c:4134
       do_filp_open+0x20b/0x470 fs/namei.c:4161
       do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x174/0x210 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:173 [inline]
       __synchronize_srcu+0xa1/0x290 kernel/rcu/srcutree.c:1439
       blk_mq_wait_quiesce_done block/blk-mq.c:283 [inline]
       blk_mq_wait_quiesce_done block/blk-mq.c:280 [inline]
       blk_mq_quiesce_queue block/blk-mq.c:303 [inline]
       blk_mq_quiesce_queue+0x149/0x1b0 block/blk-mq.c:298
       elevator_switch+0x17d/0x810 block/elevator.c:588
       elevator_change+0x391/0x5d0 block/elevator.c:691
       elevator_set_default+0x2e9/0x380 block/elevator.c:767
       blk_register_queue+0x384/0x4e0 block/blk-sysfs.c:942
       __add_disk+0x74a/0xf00 block/genhd.c:528
       add_disk_fwnode+0x13f/0x5d0 block/genhd.c:597
       add_disk include/linux/blkdev.h:775 [inline]
       nbd_dev_add+0x783/0xbb0 drivers/block/nbd.c:1981
       nbd_init+0x181/0x320 drivers/block/nbd.c:2688
       do_one_initcall+0x120/0x6e0 init/main.c:1283
       do_initcall_level init/main.c:1345 [inline]
       do_initcalls init/main.c:1361 [inline]
       do_basic_setup init/main.c:1380 [inline]
       kernel_init_freeable+0x5c2/0x910 init/main.c:1593
       kernel_init+0x1c/0x2b0 init/main.c:1483
       ret_from_fork+0x56a/0x730 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #3 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       elevator_change+0x17d/0x5d0 block/elevator.c:689
       elv_iosched_store+0x315/0x3c0 block/elevator.c:824
       queue_attr_store+0x268/0x310 block/blk-sysfs.c:869
       sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:142
       kernfs_fop_write_iter+0x3af/0x570 fs/kernfs/file.c:352
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x7d3/0x11d0 fs/read_write.c:686
       ksys_write+0x12a/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&q->q_usage_counter(io)#62){++++}-{0:0}:
       blk_alloc_queue+0x619/0x760 block/blk-core.c:461
       blk_mq_alloc_queue+0x172/0x280 block/blk-mq.c:4399
       __blk_mq_alloc_disk+0x29/0x120 block/blk-mq.c:4446
       nbd_dev_add+0x492/0xbb0 drivers/block/nbd.c:1951
       nbd_init+0x181/0x320 drivers/block/nbd.c:2688
       do_one_initcall+0x120/0x6e0 init/main.c:1283
       do_initcall_level init/main.c:1345 [inline]
       do_initcalls init/main.c:1361 [inline]
       do_basic_setup init/main.c:1380 [inline]
       kernel_init_freeable+0x5c2/0x910 init/main.c:1593
       kernel_init+0x1c/0x2b0 init/main.c:1483
       ret_from_fork+0x56a/0x730 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
       fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:4283
       might_alloc include/linux/sched/mm.h:318 [inline]
       prepare_alloc_pages+0x162/0x610 mm/page_alloc.c:4951
       __alloc_frozen_pages_noprof+0x18b/0x2470 mm/page_alloc.c:5172
       alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
       alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
       alloc_pages_noprof+0x131/0x390 mm/mempolicy.c:2507
       pagetable_alloc_noprof include/linux/mm.h:2975 [inline]
       pmd_alloc_one_noprof include/asm-generic/pgalloc.h:142 [inline]
       __pmd_alloc+0x3b/0x8b0 mm/memory.c:6573
       pmd_alloc include/linux/mm.h:2932 [inline]
       huge_pte_alloc+0x41d/0x5b0 mm/hugetlb.c:7682
       hugetlb_fault+0x373/0x2f40 mm/hugetlb.c:6707
       handle_mm_fault+0xbfa/0xd10 mm/memory.c:6485
       do_user_addr_fault+0x7a6/0x1370 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       do_strncpy_from_user lib/strncpy_from_user.c:41 [inline]
       strncpy_from_user+0x147/0x2e0 lib/strncpy_from_user.c:130
       getname_flags.part.0+0x8f/0x550 fs/namei.c:157
       getname_flags+0x93/0xf0 include/linux/audit.h:345
       getname include/linux/fs.h:2921 [inline]
       do_sys_openat2+0xb8/0x1d0 fs/open.c:1431
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x174/0x210 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&resv_map->rw_sema){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x12a6/0x1ce0 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
       down_read+0x9b/0x480 kernel/locking/rwsem.c:1537
       hugetlb_vma_lock_read mm/hugetlb.c:305 [inline]
       hugetlb_vma_lock_read+0xff/0x130 mm/hugetlb.c:296
       hugetlb_fault+0x30a/0x2f40 mm/hugetlb.c:6706
       handle_mm_fault+0xbfa/0xd10 mm/memory.c:6485
       do_user_addr_fault+0x7a6/0x1370 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       rep_movs_alternative+0x30/0x90 arch/x86/lib/copy_user_64.S:53
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
       _inline_copy_from_user include/linux/uaccess.h:178 [inline]
       _copy_from_user+0x98/0xd0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       user_termios_to_kernel_termios+0x21/0x30 drivers/tty/tty_ioctl.c:398
       set_termios+0x233/0x880 drivers/tty/tty_ioctl.c:467
       tty_mode_ioctl+0xbd8/0xd30 drivers/tty/tty_ioctl.c:826
       n_tty_ioctl_helper+0x4b/0x2b0 drivers/tty/tty_ioctl.c:982
       n_tty_ioctl+0x7f/0x370 drivers/tty/n_tty.c:2509
       tty_ioctl+0x6fd/0x1680 drivers/tty/tty_io.c:2801
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __x64_sys_ioctl+0x18b/0x210 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x4b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &resv_map->rw_sema --> sk_lock-AF_INET --> &hugetlb_fault_mutex_table[i]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&hugetlb_fault_mutex_table[i]);
                               lock(sk_lock-AF_INET);
                               lock(&hugetlb_fault_mutex_table[i]);
  rlock(&resv_map->rw_sema);

 *** DEADLOCK ***

3 locks held by syz.0.3156/19232:
 #0: ffff88806262b0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffff88807daf01e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:387 [inline]
 #1: ffff88807daf01e0 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/mmap_lock.c:368 [inline]
 #1: ffff88807daf01e0 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x35/0x6e0 mm/mmap_lock.c:428
 #2: ffff888143ea6728 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: hugetlb_fault+0x302/0x2f40 mm/hugetlb.c:6699

stack backtrace:
CPU: 0 UID: 0 PID: 19232 Comm: syz.0.3156 Not tainted syzkaller #0 PREEMPT(full) 
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
 down_read+0x9b/0x480 kernel/locking/rwsem.c:1537
 hugetlb_vma_lock_read mm/hugetlb.c:305 [inline]
 hugetlb_vma_lock_read+0xff/0x130 mm/hugetlb.c:296
 hugetlb_fault+0x30a/0x2f40 mm/hugetlb.c:6706
 handle_mm_fault+0xbfa/0xd10 mm/memory.c:6485
 do_user_addr_fault+0x7a6/0x1370 arch/x86/mm/fault.c:1387
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:rep_movs_alternative+0x30/0x90 arch/x86/lib/copy_user_64.S:60
Code: 83 f9 08 73 25 85 c9 74 0f 8a 06 88 07 48 ff c7 48 ff c6 48 ff c9 75 f1 e9 cd 23 04 00 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 <48> 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 db 83 f9 08
RSP: 0018:ffffc9000e307a08 EFLAGS: 00050206
RAX: 0000000000000001 RBX: 0000000000000038 RCX: 000000000000002c
RDX: fffff52001c60f63 RSI: 0000000000000038 RDI: ffffc9000e307af0
RBP: 000000000000002c R08: 0000000000000001 R09: fffff52001c60f63
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc9000e307af0 R14: ffffc9000e307af0 R15: dffffc0000000000
 copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
 raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
 _inline_copy_from_user include/linux/uaccess.h:178 [inline]
 _copy_from_user+0x98/0xd0 lib/usercopy.c:18
 copy_from_user include/linux/uaccess.h:212 [inline]
 user_termios_to_kernel_termios+0x21/0x30 drivers/tty/tty_ioctl.c:398
 set_termios+0x233/0x880 drivers/tty/tty_ioctl.c:467
 tty_mode_ioctl+0xbd8/0xd30 drivers/tty/tty_ioctl.c:826
 n_tty_ioctl_helper+0x4b/0x2b0 drivers/tty/tty_ioctl.c:982
 n_tty_ioctl+0x7f/0x370 drivers/tty/n_tty.c:2509
 tty_ioctl+0x6fd/0x1680 drivers/tty/tty_io.c:2801
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18b/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f733818eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7339054038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f73383e5fa0 RCX: 00007f733818eec9
RDX: 0000000000000038 RSI: 00000000402c542b RDI: 0000000000000003
RBP: 00007f7338211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f73383e6038 R14: 00007f73383e5fa0 R15: 00007fff2c7f4708
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
  18:	e9 cd 23 04 00       	jmp    0x423ea
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

