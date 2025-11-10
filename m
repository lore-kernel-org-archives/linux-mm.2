Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487B1CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D66C8E000C; Mon, 10 Nov 2025 04:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586D88E0002; Mon, 10 Nov 2025 04:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3EC8E000C; Mon, 10 Nov 2025 04:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 327F58E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:15:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC5464CA32
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:15:38 +0000 (UTC)
X-FDA: 84094139556.21.BB35E4F
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1DA1140010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:15:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3OK0RaQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3OK0RaQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762766137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=/Zw4H4q2wOKBy+vIN+Jq4WgxmoSs6+RdPp0F0J5oQVA=;
	b=ojRXO+LkckTZoBL5YCHEag7FGSq3UxV1SxBfM0cwfLd0cYo/P8EOMkSWcCiBY8cH4CcDYX
	6YIAYCsw6Tz1HEDg5ZRDWbjnEQHeGUbpszs21wTOmps3siWzaqUF1H9mwqiCnZwIKhFAF0
	1QJX9DWP5i5M3qoOdys7/ajOITskxi0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3OK0RaQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3OK0RaQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762766137; a=rsa-sha256;
	cv=none;
	b=rXN3P/Z+sm/bjwU6C0UXWw+8BqBdRP5s0xYKOit+Px7/LDq8nST1wB3J1/MOowhlh+jXSA
	wRgNDXz/9HGC2tSGTnLWAKSGQg7rbJ3Bk07gLHpKy3w2+jGy0Duixe9nxCCbx+PzwFyV0r
	FQUioMN0FEoNdYgN/sF15oOFZuLChdg=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-432f8352633so82767165ab.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:15:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762766136; x=1763370936;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Zw4H4q2wOKBy+vIN+Jq4WgxmoSs6+RdPp0F0J5oQVA=;
        b=CbSUELyiWtynunlSRJIBMCQdolDiRNS1x/WK7XmtRmywT0QMq+0kMby7svLKmonvDd
         z0jcl/FT7AGFemyDGJ60nowDV0sORjtRqMGY4szBpKnrMPolkpTf5qt4iziYv/SXv9bY
         1nqc+3CEG5//UGRfJJ17KVsTqhPgRuA6tmCpdMpNpubi3drOAc/Kg2o4WYXfRsj+PjdS
         8YDH+B9eOKtrhJrqltnsLeYUAKqlOgV0myGJjrT5aqx+Ljc4uyOVGzTzX0TdpXnlalky
         gafCss+yTtFlHoVvCJY+ev8MwOvp083ezXhObVMQtclKMVo/rSLsuu3Y7wKvV7ePFmND
         0x/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVqxIjCGwqRAemZRWdOd8M1oPvfMxULa0vQZqvbt+7EsyqCRV68jtO5nLnJnoR1xPC08CwdSxe/6g==@kvack.org
X-Gm-Message-State: AOJu0Yx31zoogZF+jg8rSuA4QUqPk1LR0WtCtwB5EEtNO6PvSYuxkjCz
	Q8Wh3SgFTQXiW+ihy91YESsGDnDh7V8A3Vvjk9eKxM7sRJ3QSDEKhr6l/lXQm5Et91hBZJj45c5
	uV03HOoDZXMYar0uMOJqbO/qX/8rSAeJOpQPSuDAOWF/uG6ygrkFIirzdE44=
X-Google-Smtp-Source: AGHT+IHBCoFZPdfHSvccEotJwuRN7ReNCGqsEk4vmPlEZoxUKaupb9OrzE1EyIqSrZrxtzUhGESDVa3gH6isQrfDR9UMdSlKzbVK
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:248f:b0:433:7a5f:943a with SMTP id
 e9e14a558f8ab-4337a5f94e7mr54740005ab.19.1762766136212; Mon, 10 Nov 2025
 01:15:36 -0800 (PST)
Date: Mon, 10 Nov 2025 01:15:36 -0800
In-Reply-To: <20251110051421.29436-1-lance.yang@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6911ad38.a70a0220.22f260.00dc.GAE@google.com>
Subject: [syzbot ci] Re: mm/hugetlb: fix possible deadlock in __hugetlb_zap_begin
From: syzbot ci <syzbot+ci5a676d3d210999ee@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de, syzbot@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1DA1140010
X-Stat-Signature: ofrgi53ta61e6tuinj6bz3ndnwyczhro
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762766136-751396
X-HE-Meta: U2FsdGVkX193e9eXonW/mQvovSNzF2Ot//BMiEuIbbIcuItO+YGqll/9ICOLk7cFWxBE2SbGc9gbDMbMruuszg78UKuu1LynhcTKML4WzQPDOfvQoNtZjuiSgH3nfkzUzNZJWWQ3Stz2/+DQC86IDFq/KcjojQyAxWbGttIJtW55N2gIul5tII97Eh6mba+yXFZ2kEUdBXaHdwInad9yFQCszBOgIGaP6RizqwKfqCpTYOj/w3gZ6wo2csOWzB7hZs4UZgAXzxuORj8Lkmv12OVV198mf07lBRkgEb58p9OtFJ2tqp31NJ5xgQzvj/VUSKWUqXha/a13U0ab88Ea5iRwu4g/TTE797xcFxKoMWrHGKYPrzI59eI6Snh5L962Cbg+sGMidWqKgbbCPMkZ/j3OM7H+RzCUfeH5oPz5fO3qM2xKtIb0/9J2D6gYHw27ruIoTfzt9/BLvwMop1gHpYneOeain8olCsC3LsKVi5uWfP0MDTlCYJ1hxI+IWtkK1NeUilYIOQDBNGRD/sB18hUYn6WJpg1c6tFXUdFSZsLoWxp1O/SdKmj7zObf8Ol6bnn64CoIjeqeUg0Rd/aYshDM9xUjMQK8gQYMnt3SJBOr1/33NiUk1zIjb8oPl4cpFhlhNQohAy/juw+p+qnDBY2LA6zWryBSiwkPZ2WzZ7evbphjgC3Dfimh9NtuYLNN8F3f07SaVko6fR90d2dh86jB4pyoRmHs/FoAyGjwyb1ZOtY5dN/wNGobgY4Cq0ReoMlJE4ue5e2HtVcO4hZ5mUivIhSCwyMC8JUruJ+bvK0pVrsO9GwSSzNVs3khkrATk/g/LtrWitAAw0gKq4YgpLU1RBnjRMaQtyNTg7JSsS14LoURoRWIa+1PxktdorYDoYzy00QSbqg5M8f8KzpHjYAk52mIpUMITaxVOXtazmq1QcGQi7FfpolFm2Ywik7hNn5ahQG0vipMtrBprWD
 BFIEL1OD
 SP7sFL3wnicE7mo5aJd3Hc0obwgsCj4aV1MrVsjINl3RnjnPIvfUgo4PXawzMo9auZSD5oQ4IfrUkzYEtg+Zi/980dgghomRLk/v2EQ8zjOdGZSZc0Z0D6iQ3zC57+rH978z2rkVBX0h5AR4g2W/rpuKQUJG22Dhj6FVK1HH6UUw6tMDAaU+4vy2FNAVPjTON9wNDYVHVkrAa4wC/pgMtxVICTsiF7088YNleRx5V/KZ9c3OlvB2758xlP7XIA/aHGS1ByDmCbOxWnJV3vxrv6D3jlh09gWDqtwKW7AqCa1aZ0CQObCUwkjPMAf2us+ZmXVdPN2qM5Qsaarap8wGKJW9445G7mfMwiCX0/as/o53dGuIcU7I2f5mxNsnjeLw+qs3P413saYWt55V745+DzsFH8AZo5Htx+RL+Paml6etMC3QdNQ4vrGakwjdAiU1pnaK9B4ShH088YzCRcPaIaR4UZlgVDWSFaucMm3cjtzOSf4GNYXEgp9kxdNE3gZh8fcFA05Zde5x3V1o0/foABX1/HsGgXVAzL/ah
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/hugetlb: fix possible deadlock in __hugetlb_zap_begin
https://lore.kernel.org/all/20251110051421.29436-1-lance.yang@linux.dev
* [PATCH 1/1] mm/hugetlb: fix possible deadlock in __hugetlb_zap_begin

and found the following issues:
* possible deadlock in move_hugetlb_page_tables
* possible deadlock in remove_inode_hugepages
* possible deadlock in unmap_vmas

Full report is available here:
https://ci.syzbot.org/series/4162a577-196d-48cb-908e-f31fe5f186e2

***

possible deadlock in move_hugetlb_page_tables

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b444c811-3577-4885-8522-093253539e5d/config
C repro:   https://ci.syzbot.org/findings/118b63ad-708b-4ada-abd9-4d6e18a8384f/c_repro
syz repro: https://ci.syzbot.org/findings/118b63ad-708b-4ada-abd9-4d6e18a8384f/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5959 is trying to acquire lock:
ffff888167d5c918 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
ffff888167d5c918 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: move_hugetlb_page_tables+0x5a5/0x1560 mm/hugetlb.c:5114

but task is already holding lock:
ffff8881b5f35e78 (&vma_lock->rw_sema){+.+.}-{4:4}, at: hugetlb_vma_lock_write mm/hugetlb.c:-1 [inline]
ffff8881b5f35e78 (&vma_lock->rw_sema){+.+.}-{4:4}, at: move_hugetlb_page_tables+0x589/0x1560 mm/hugetlb.c:5113

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&vma_lock->rw_sema){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
       unmap_vmas+0x23d/0x580 mm/memory.c:2098
       vms_clear_ptes+0x353/0x530 mm/vma.c:1231
       vms_complete_munmap_vmas+0x206/0x8a0 mm/vma.c:1280
       do_vmi_align_munmap+0x364/0x440 mm/vma.c:1539
       do_vmi_munmap+0x253/0x2e0 mm/vma.c:1587
       shrink_vma mm/mremap.c:1340 [inline]
       mremap_to+0x21e/0x790 mm/mremap.c:1394
       do_mremap mm/mremap.c:1940 [inline]
       __do_sys_mremap mm/mremap.c:1996 [inline]
       __se_sys_mremap+0xd45/0xfb0 mm/mremap.c:1964
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       i_mmap_lock_write include/linux/fs.h:548 [inline]
       move_hugetlb_page_tables+0x5a5/0x1560 mm/hugetlb.c:5114
       move_page_tables+0x35c/0x1c80 mm/mremap.c:806
       copy_vma_and_data mm/mremap.c:1211 [inline]
       move_vma+0x942/0x1820 mm/mremap.c:1291
       mremap_to+0x6ce/0x790 mm/mremap.c:1415
       do_mremap mm/mremap.c:1940 [inline]
       __do_sys_mremap mm/mremap.c:1996 [inline]
       __se_sys_mremap+0xd45/0xfb0 mm/mremap.c:1964
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&vma_lock->rw_sema);
                               lock(&hugetlbfs_i_mmap_rwsem_key);
                               lock(&vma_lock->rw_sema);
  lock(&hugetlbfs_i_mmap_rwsem_key);

 *** DEADLOCK ***

2 locks held by syz.0.17/5959:
 #0: ffff888172d8d7e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:327 [inline]
 #0: ffff888172d8d7e0 (&mm->mmap_lock){++++}-{4:4}, at: do_mremap mm/mremap.c:1927 [inline]
 #0: ffff888172d8d7e0 (&mm->mmap_lock){++++}-{4:4}, at: __do_sys_mremap mm/mremap.c:1996 [inline]
 #0: ffff888172d8d7e0 (&mm->mmap_lock){++++}-{4:4}, at: __se_sys_mremap+0x42e/0xfb0 mm/mremap.c:1964
 #1: ffff8881b5f35e78 (&vma_lock->rw_sema){+.+.}-{4:4}, at: hugetlb_vma_lock_write mm/hugetlb.c:-1 [inline]
 #1: ffff8881b5f35e78 (&vma_lock->rw_sema){+.+.}-{4:4}, at: move_hugetlb_page_tables+0x589/0x1560 mm/hugetlb.c:5113

stack backtrace:
CPU: 1 UID: 0 PID: 5959 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
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
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 i_mmap_lock_write include/linux/fs.h:548 [inline]
 move_hugetlb_page_tables+0x5a5/0x1560 mm/hugetlb.c:5114
 move_page_tables+0x35c/0x1c80 mm/mremap.c:806
 copy_vma_and_data mm/mremap.c:1211 [inline]
 move_vma+0x942/0x1820 mm/mremap.c:1291
 mremap_to+0x6ce/0x790 mm/mremap.c:1415
 do_mremap mm/mremap.c:1940 [inline]
 __do_sys_mremap mm/mremap.c:1996 [inline]
 __se_sys_mremap+0xd45/0xfb0 mm/mremap.c:1964
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f043598efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe808cfc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
RAX: ffffffffffffffda RBX: 00007f0435be5fa0 RCX: 00007f043598efc9
RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007f0435a11f91 R08: 0000200000c00000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0435be5fa0 R14: 00007f0435be5fa0 R15: 0000000000000005
 </TASK>


***

possible deadlock in remove_inode_hugepages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b444c811-3577-4885-8522-093253539e5d/config
syz repro: https://ci.syzbot.org/findings/e3555fcc-3852-4e88-aea4-f3445e8a6ffb/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.2.22/5989 is trying to acquire lock:
ffff8881bc18d318 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
ffff8881bc18d318 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: hugetlb_unmap_file_folio fs/hugetlbfs/inode.c:451 [inline]
ffff8881bc18d318 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: remove_inode_single_folio fs/hugetlbfs/inode.c:535 [inline]
ffff8881bc18d318 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: remove_inode_hugepages+0x972/0x1110 fs/hugetlbfs/inode.c:602

but task is already holding lock:
ffff8881ae823178 (&vma_lock->rw_sema){++++}-{4:4}, at: hugetlb_unmap_file_folio fs/hugetlbfs/inode.c:450 [inline]
ffff8881ae823178 (&vma_lock->rw_sema){++++}-{4:4}, at: remove_inode_single_folio fs/hugetlbfs/inode.c:535 [inline]
ffff8881ae823178 (&vma_lock->rw_sema){++++}-{4:4}, at: remove_inode_hugepages+0x96a/0x1110 fs/hugetlbfs/inode.c:602

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&vma_lock->rw_sema){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
       unmap_vmas+0x23d/0x580 mm/memory.c:2098
       exit_mmap+0x23e/0xb30 mm/mmap.c:1277
       __mmput+0x118/0x430 kernel/fork.c:1133
       exit_mm+0x1da/0x2c0 kernel/exit.c:582
       do_exit+0x648/0x2300 kernel/exit.c:954
       do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
       get_signal+0x1285/0x1340 kernel/signal.c:3034
       arch_do_signal_or_restart+0xa0/0x790 arch/x86/kernel/signal.c:337
       exit_to_user_mode_loop+0x72/0x130 kernel/entry/common.c:40
       exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
       syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
       do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       i_mmap_lock_write include/linux/fs.h:548 [inline]
       hugetlb_unmap_file_folio fs/hugetlbfs/inode.c:451 [inline]
       remove_inode_single_folio fs/hugetlbfs/inode.c:535 [inline]
       remove_inode_hugepages+0x972/0x1110 fs/hugetlbfs/inode.c:602
       hugetlbfs_punch_hole fs/hugetlbfs/inode.c:725 [inline]
       hugetlbfs_fallocate+0xbc2/0x1100 fs/hugetlbfs/inode.c:751
       vfs_fallocate+0x669/0x7e0 fs/open.c:342
       madvise_remove mm/madvise.c:1046 [inline]
       madvise_vma_behavior+0x341a/0x3d70 mm/madvise.c:1350
       madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1673
       madvise_do_behavior+0x38e/0x550 mm/madvise.c:1889
       do_madvise+0x1bc/0x270 mm/madvise.c:1982
       __do_sys_madvise mm/madvise.c:1991 [inline]
       __se_sys_madvise mm/madvise.c:1989 [inline]
       __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1989
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&vma_lock->rw_sema);
                               lock(&hugetlbfs_i_mmap_rwsem_key);
                               lock(&vma_lock->rw_sema);
  lock(&hugetlbfs_i_mmap_rwsem_key);

 *** DEADLOCK ***

4 locks held by syz.2.22/5989:
 #0: ffff8881056ac420 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3111 [inline]
 #0: ffff8881056ac420 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f0/0x7e0 fs/open.c:341
 #1: ffff8881bc18d048 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #1: ffff8881bc18d048 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: hugetlbfs_punch_hole fs/hugetlbfs/inode.c:693 [inline]
 #1: ffff8881bc18d048 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: hugetlbfs_fallocate+0x3cc/0x1100 fs/hugetlbfs/inode.c:751
 #2: ffff888103e8e4e8 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: remove_inode_hugepages+0x332/0x1110 fs/hugetlbfs/inode.c:597
 #3: ffff8881ae823178 (&vma_lock->rw_sema){++++}-{4:4}, at: hugetlb_unmap_file_folio fs/hugetlbfs/inode.c:450 [inline]
 #3: ffff8881ae823178 (&vma_lock->rw_sema){++++}-{4:4}, at: remove_inode_single_folio fs/hugetlbfs/inode.c:535 [inline]
 #3: ffff8881ae823178 (&vma_lock->rw_sema){++++}-{4:4}, at: remove_inode_hugepages+0x96a/0x1110 fs/hugetlbfs/inode.c:602

stack backtrace:
CPU: 1 UID: 0 PID: 5989 Comm: syz.2.22 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
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
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 i_mmap_lock_write include/linux/fs.h:548 [inline]
 hugetlb_unmap_file_folio fs/hugetlbfs/inode.c:451 [inline]
 remove_inode_single_folio fs/hugetlbfs/inode.c:535 [inline]
 remove_inode_hugepages+0x972/0x1110 fs/hugetlbfs/inode.c:602
 hugetlbfs_punch_hole fs/hugetlbfs/inode.c:725 [inline]
 hugetlbfs_fallocate+0xbc2/0x1100 fs/hugetlbfs/inode.c:751
 vfs_fallocate+0x669/0x7e0 fs/open.c:342
 madvise_remove mm/madvise.c:1046 [inline]
 madvise_vma_behavior+0x341a/0x3d70 mm/madvise.c:1350
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1673
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1889
 do_madvise+0x1bc/0x270 mm/madvise.c:1982
 __do_sys_madvise mm/madvise.c:1991 [inline]
 __se_sys_madvise mm/madvise.c:1989 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1989
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fca36b8efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fca37a80038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fca36de6090 RCX: 00007fca36b8efc9
RDX: 0000000000000009 RSI: 0000000000600000 RDI: 0000200000bc0000
RBP: 00007fca36c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca36de6128 R14: 00007fca36de6090 R15: 00007ffeef05aaf8
 </TASK>


***

possible deadlock in unmap_vmas

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b444c811-3577-4885-8522-093253539e5d/config
C repro:   https://ci.syzbot.org/findings/0f0a7c70-e594-4359-9971-50a723bbbd7a/c_repro
syz repro: https://ci.syzbot.org/findings/0f0a7c70-e594-4359-9971-50a723bbbd7a/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5961 is trying to acquire lock:
ffff88810be5c178 (&vma_lock->rw_sema){+.+.}-{4:4}, at: hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
ffff88810be5c178 (&vma_lock->rw_sema){+.+.}-{4:4}, at: unmap_vmas+0x23d/0x580 mm/memory.c:2098

but task is already holding lock:
ffff88816a110418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
ffff88816a110418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: __hugetlb_zap_begin+0x2aa/0x3a0 mm/hugetlb.c:5331

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       i_mmap_lock_write include/linux/fs.h:548 [inline]
       hugetlb_change_protection+0x56a/0x18c0 mm/hugetlb.c:6439
       change_protection+0x386/0x38c0 mm/mprotect.c:655
       mprotect_fixup+0x6fe/0x9c0 mm/mprotect.c:774
       do_mprotect_pkey+0x8c5/0xcd0 mm/mprotect.c:930
       __do_sys_mprotect mm/mprotect.c:951 [inline]
       __se_sys_mprotect mm/mprotect.c:948 [inline]
       __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:948
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&vma_lock->rw_sema){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
       unmap_vmas+0x23d/0x580 mm/memory.c:2098
       exit_mmap+0x23e/0xb30 mm/mmap.c:1277
       __mmput+0x118/0x430 kernel/fork.c:1133
       exit_mm+0x1da/0x2c0 kernel/exit.c:582
       do_exit+0x648/0x2300 kernel/exit.c:954
       do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
       __do_sys_exit_group kernel/exit.c:1118 [inline]
       __se_sys_exit_group kernel/exit.c:1116 [inline]
       __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
       x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&hugetlbfs_i_mmap_rwsem_key);
                               lock(&vma_lock->rw_sema);
                               lock(&hugetlbfs_i_mmap_rwsem_key);
  lock(&vma_lock->rw_sema);

 *** DEADLOCK ***

2 locks held by syz.0.17/5961:
 #0: ffff8881151362a0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:365 [inline]
 #0: ffff8881151362a0 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x126/0xb30 mm/mmap.c:1262
 #1: ffff88816a110418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
 #1: ffff88816a110418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: __hugetlb_zap_begin+0x2aa/0x3a0 mm/hugetlb.c:5331

stack backtrace:
CPU: 1 UID: 0 PID: 5961 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
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
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
 unmap_vmas+0x23d/0x580 mm/memory.c:2098
 exit_mmap+0x23e/0xb30 mm/mmap.c:1277
 __mmput+0x118/0x430 kernel/fork.c:1133
 exit_mm+0x1da/0x2c0 kernel/exit.c:582
 do_exit+0x648/0x2300 kernel/exit.c:954
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 __do_sys_exit_group kernel/exit.c:1118 [inline]
 __se_sys_exit_group kernel/exit.c:1116 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f470758efc9
Code: Unable to access opcode bytes at 0x7f470758ef9f.
RSP: 002b:00007ffed0f73318 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f470758efc9
RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 00000002d0f7340f R09: 00007f47077b1280
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f47077b1280 R14: 0000000000000003 R15: 00007ffed0f733d0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

