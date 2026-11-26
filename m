Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26910606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A69C6B05B2; Thu, 26 Nov 2026 15:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DF16B05B3; Thu, 26 Nov 2026 15:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293776B05B4; Thu, 26 Nov 2026 15:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F184A6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:09:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FA86140284
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:09:48 +0000 (UTC)
X-FDA: 85478360856.26.4DB0062
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id CB0944000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:09:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3CpIIawkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3CpIIawkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795723787;
	b=olD9kTQlTa8P8ElScwfCvCAdgAqGShTwshWuQnu+47AAfy9bmMPx3PuwFn+N61PAMgQoGU
	7ycy6/LqA+FH040FOhtG1/eqGECHRBJdhvQUH56aS/vKYYJ+ruTZsgPAcCdFMJYewjAFio
	L4YB4sfLjca0Ggl5ZUJBwTLcI0QdClE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795723787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=9YJ8pmD/Ot7blvuVP4Nw0qrBD3/CKWOEVow4nZhx2LE=;
	b=gMylc3kfJWYLaje1rJsh0lR5oNkk7R5pJgI/xCBJWYMAhicCf8ZSqDa+vIHVzzsXQEEjkP
	ip7VDCkGmN13DGyQQyhWqi6fZ5ycMf8VMmSHx7AY3WMkza6iR1MLZp0aAdrUIyqOGKB49c
	Nx/cwx1AI4GgI729Vgs7oPopZatFdj8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3CpIIawkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3CpIIawkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cc89e86e4dso8476191b6e.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:09:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723786; x=1796328586;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9YJ8pmD/Ot7blvuVP4Nw0qrBD3/CKWOEVow4nZhx2LE=;
        b=USKHO6+XjBDQhL2YfCg2bTcL4dHdBEB72pm2lx3PYiuspUEtNUliwV0ZN8Mgy7Yncx
         uj4xAxKYbOFtStOOFSTJyvT9ypmAztqOJ63ZehBpYKulm6fgvyTmT/TQbefjD9bLDREk
         pbXfTA+FQmZHmwWCZXZGWiaImvDWDH+ncUCdj1voxtiqZKrWuNNXJmz8Uu5IFP2ul210
         Pw+M9XLmmbDmA+I6UJ8MCZSa7aZi4KCiJvO5CfuuMlCckYvqdZQEUDvb7uKIZZ1kjm/j
         KA6Pv/AziNwfn7LC35mgZQDCFV7Wl17b0Sq6j68wLRz1G2gC505NSorIkEOHGaU5ZDiw
         C3bA==
X-Forwarded-Encrypted: i=1; AL+hErG8gebzKp1YomY0y1cVU3LQ/wYUZzJCMNBCHphgutRBgNFRokfiEbyRhuMvE46G3QgZM5yPNhJ6Aw==@kvack.org
X-Gm-Message-State: APuU4Z+Ge466gb0ZBmVmnd98zeZvCKidfDAAfCNKTqaXOssrEHYJ0F5I
	mtIHoaiG/f1LDVGtCiLbHUDV1/SynsAKeM9U0nDN+P+mx1OiSS2p9UeKUGWysxH1FLWpTAIncuN
	TPFb/B0bboEgaWj5qN77+hLnEQQRfd/gXOHaml7MAShvDfzqym0vP+mYA7K4=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3189:b0:4ea:18f:64b0 with SMTP id
 5614622812f47-57a0c19af8amr25081179b6e.67.1795723786040; Thu, 26 Nov 2026
 12:09:46 -0800 (PST)
Date: Thu, 26 Nov 2026 12:09:46 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b08920a.28411dd9.2968b4.000b.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in ocfs2_evict_inode (3)
From: syzbot <syzbot+00969d07ff718daa64c0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	muchun.song@linux.dev, qi.zheng@linux.dev, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: a39f7m1fa9h6k58ua9wfxw68fgtd84rr
X-Rspamd-Queue-Id: CB0944000D
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795723786-175263
X-HE-Meta: U2FsdGVkX19Luy1aBLOSa6VeOEatTF/B10xXwK3AUV7NfMsWspMsGHRxWP4132U5+fQ1DTfABcScqFabXSlTD61c4d1md5p4mjztUWNxZsPMd+GSnWd8oV5gCpivuAI3DAT6gZMxbtRWMEbudClJYXQhgxuL8fIi3fgLSQa7cBFgOQRHswv4kyHEvRxxHVk583k3udD0oYZZ1Yv2NdVMoFWx1bcUkU6LWuk8dGdpwK7ZgujsqtnzoTrDe2Jxs1+KXkESMmdFs4zhEfI9HW+6sRlmBzoZzRD6m7SbpldHBFqqGwChZGBe9sDM+Z32kurb/ofmieYGV9bglXAm3npJk0V7zV93Ow9n/DXrB9HjiBx9t2Etw6oNtKRZgc1TfkztkojSPhZ8GrBtnE0VWBx9GGNXwnMV8JFObqIftV6EBSlxN6Jx4QYY9VTFOzG0CspUnTVnkzz6aVdIzXvnwFf351MNsHILWKPpiRGmxogUXC/2suNZuNcuy/MqBQ4dU8EB+SBxGsDEITH4HAHsAkWS86ct3Zb0wa2QfPK/wruW4sUQkzzhNFu1QtzFs9DQHezQ9IpMGCHooCYLqCdGJIKQTg8HbMlmwb3ZxVjGKZTdEYA3uS7OHBC+FZckllq0pcQ9AIvLmPoApgVqnupIu/JqhmnSxzgy4Nyx40+XA6AlI8KRgs0oSXB/VqompdELauECd8xI2a69HYK2swC2i61kD3fzwx4gSGBqJYQ6iP5Fqan/28i5yGDlIDWjLVPwSLbcXGLbAb0EQU/xV5ZQfXORNwAAtNqiakbPEwQl3XuNnJQg86y2I1k0Zk94L+C8phxL+KqCoR+SXkO/veRJ6uCwGqCjr6WdDuC/K9krXJ41jIHfuwPDU2vrLR9RGcYhz8y/J8qtcSnp0HqbhJRHHSUmerOuvT9N3mvhqsDIlWRockUt1/oe7j+qm/z24fdABrvYCnV6+r+d0lTu1gFeH6e
 d6YfNwBH
 yDLuKuxxE8tX4vNdqShHRuqw95z3HqsEZHEsbVwLmB1iRzuBgU362qNDzS6D9cxKyhb3Cy+F8bux4lYV80sWyIEdits+jiVTYt/p+U1NLGi1KdzsUDDd99zYYzCeX+SkFkOU67lQriOffh7SPbO+b+LhNZvFp+p3tu9cP0W5Wvj9aqiOxIJ3VqfqBL+r/TK6HnSnlBfK5FGcv0UEw3KpeAvDfy2ayxEI3N0PiHiJKBpA+AKEHf4ISobvRaB5K+IfNXY0UlFsHg58C1q5eIYf525WWxL1kUsU53z7AGPUkSyY3oP+Ix661C+Qwo5s3lUSHyqXUeO/5TDbhTp/4TtRPNIaUykZfsNl+y+8kMql2xEtnSno+R/xhwQs8fW4jwWeig6iqFhBl9sLC3ExmIGVA2yvaGeCdbw+Henr/thoI4fFBKEw5y44LLKe0KvXYHYSPweR8giGjAMiQ7AhPA5mFwCTPDnPRMtHrznDS4jrvlIZn+zpWtKxlEv2kNmzGm9ZlV2IgfkNPdMqye2tPA6rzMClIcAkgfsenzQo3NJ4vEGHjzYuy8Je7+MvW8/BOxK/g1oMj+0cDoz1BrVM5eyiqUOGCEdBwUMVuFe9EWVTn4qTHoiGXOUF4Ktl2inepQ4X+HkpAxKFuyAnFiPrh4CWs0/KPaiywTtbDOe7ptB3bWhiFKgA1gYKCZNG91oCw2TiGJE1taYi0nY1Ly3aGP6zCPYgTdtRPE4k55Na2aRVBUfd3q4oOj5BwgsOwHTIeCVGFuxkFkm5deG1yDhFxAGbK+glrXTmJYFWqRGEP2kWC+1IM3Nuki7YVxpnlricDYkbldp1+9qQQ8S7R8wldesGfQSkPaM1RYr6wq6cOX1HI/BH+5ty2WKB5zt4cTTjVYE7pHjGq2VpzqpyorrdLxzaSB0OMvBAD8w+lsDez7tRGHovojDd2CJ2sZIQ9UYdrO/9qT3+ye4I+j9+bwrvQj5aWvJIBJELx
 tIQ9NX7C
 QGgL49869uhFuh5WrvSED+IiraujPfZrwLzHtT27dEiTkw/NXdgi1jOxhU+Da3THCZ3EoQJjIVoA4UnIXK9WqEUEcqMfPqL5MaC5tvgNV79WzG3wClGjCBn3sRcdCUSWP0CvmSOvARB+q/tlZ1ej9aw7ObUYf37kGD/vyCCWxCmvs/vJr53JOG24ZL+8OCPxfquwqgJAwFXDX3ee9A6HwpRYKvqlBriV6MUUhk4EJok2jIOMHneKaypWU177mlD+ssTk8lqPRJSEWWNx9whd1Vt0UlaiXV5Rzr6/29h5nujUAlJhjCCrhSSh7mh4G9Dx6/OilItxhguemXHWSZ6p7dOMIkCBtThemVaJCgEVEUFYkrqtLaWuD3FOhBz3od0OURoChiqNlthpNcDuT/eOtc4nqk25Ml5io7q0Qnx7L2QMh3Olzjh3+sAPzU2gVGzj1mNFDoeM87lplMFPaqayIlH1orq7BcEMsm0BFvehAmFH/dLRA9udliydfDJLxxavIu56gRqXszAIda+vVMHORe3ItVxZKwxJsI3yeTl8uyCEa2Jdbj7cmrfZcQbsvcDd6bpaTUVSZhJ0eytSYCJ1UJe8Aht4TSb4DkTF+cDotshVskrX17JwzGd15SDLKlQ+573SBMspGlnr9zlWOmRUJeBPFeEFTmw0e2fjWOEjCDkSP9uWQ/c2MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    4dce97c6c265 Merge tag 'ext4_for_linus-7.4-rc5' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f089d9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbd0fc734eea62ed
dashboard link: https://syzkaller.appspot.com/bug?extid=00969d07ff718daa64c0
compiler:       Debian clang version 22.1.8 (1~deb13u5), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98fce4d0b21b/non_bootable_disk-4dce97c6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98e797b034c7/vmlinux-4dce97c6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3e9cb100aab8/bzImage-4dce97c6.xz

The issue was bisected by AI to:

commit f277230d002d03ed98b814b735f9d3d01b42020a
Author: Cen Zhang <zzzccc427@gmail.com>
Date:   Fri Oct 30 04:48:56 2026 +0000

    ocfs2: serialize inode journal access with shutdown

reasoning:      https://syzkaller.appspot.com/ai_job?id=b27b6c0b-8dab-4c8c-85e0-28d030057ea0

AI-generated root cause summary:
ocfs2_journal_shutdown() holds down_write(&osb->journal_shutdown_sem) across
jbd2_journal_destroy(), which invokes shrinker_free() and acquires the global
shrinker_mutex. Because mm/shrinker.c acquires shrinker_mutex across GFP_KERNEL
allocations (establishing shrinker_mutex -> fs_reclaim), while
ocfs2_clear_inode() acquires down_read(&osb->journal_shutdown_sem) during inode
eviction reachable from memory reclaim (fs_reclaim ->
&osb->journal_shutdown_sem), lockdep detects a circular locking dependency
(&osb->journal_shutdown_sem -> shrinker_mutex -> fs_reclaim ->
&osb->journal_shutdown_sem).

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=00969d07ff718daa64c0

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00969d07ff718daa64c0@syzkaller.appspotmail.com

The bisection result may be wrong.
If you agree with it, please also add:
Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")


======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/83 is trying to acquire lock:
ffff888034e6c2f8 (&osb->journal_shutdown_sem){++++}-{4:4}, at: ocfs2_clear_inode fs/ocfs2/inode.c:1326 [inline]
ffff888034e6c2f8 (&osb->journal_shutdown_sem){++++}-{4:4}, at: ocfs2_evict_inode+0x2dd8/0x43c0 fs/ocfs2/inode.c:1343

but task is already holding lock:
ffffffff90297ec0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7332 [inline]
ffffffff90297ec0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa53/0x3a20 mm/vmscan.c:7705

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4388 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4402
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4673 [inline]
       slab_alloc_node mm/slub.c:5011 [inline]
       __do_kmalloc_node mm/slub.c:5530 [inline]
       __kvmalloc_node_noprof+0x134/0x820 mm/slub.c:7143
       alloc_shrinker_info+0xe9/0x400 mm/shrinker.c:101
       mem_cgroup_css_online+0x84/0x7b0 mm/memcontrol.c:4396
       online_css+0xbf/0x310 kernel/cgroup/cgroup.c:5903
       css_create kernel/cgroup/cgroup.c:5983 [inline]
       cgroup_apply_control_enable+0x9ed/0xda0 kernel/cgroup/cgroup.c:3474
       cgroup_mkdir+0x1220/0x14b0 kernel/cgroup/cgroup.c:6188
       kernfs_iop_mkdir+0x213/0x360 fs/kernfs/dir.c:1304
       vfs_mkdir+0x411/0x660 fs/namei.c:5428
       filename_mkdirat+0x284/0x550 fs/namei.c:5461
       __do_sys_mkdirat fs/namei.c:5482 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5479
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (shrinker_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       shrinker_free+0xdb/0x3b0 mm/shrinker.c:809
       jbd2_journal_destroy+0x606/0x7e0 fs/jbd2/journal.c:2204
       ocfs2_journal_shutdown+0x517/0xb40 fs/ocfs2/journal.c:1125
       ocfs2_dismount_volume+0x3c9/0x860 fs/ocfs2/super.c:1874
       generic_shutdown_super+0x140/0x2d0 fs/super.c:723
       kill_block_super+0x44/0xa0 fs/super.c:1852
       deactivate_locked_super+0xbe/0x110 fs/super.c:558
       get_tree_bdev_flags+0x454/0x500 fs/super.c:1823
       vfs_get_tree+0x92/0x2a0 fs/super.c:1881
       fc_mount fs/namespace.c:1282 [inline]
       do_new_mount_fc fs/namespace.c:3910 [inline]
       do_new_mount+0x325/0xb00 fs/namespace.c:3986
       do_mount fs/namespace.c:4350 [inline]
       __do_sys_mount fs/namespace.c:4563 [inline]
       __se_sys_mount+0x31d/0x420 fs/namespace.c:4540
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&osb->journal_shutdown_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       ocfs2_clear_inode fs/ocfs2/inode.c:1326 [inline]
       ocfs2_evict_inode+0x2dd8/0x43c0 fs/ocfs2/inode.c:1343
       evict+0x6bf/0xc20 fs/inode.c:829
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       dentry_kill+0x1b9/0x910 fs/dcache.c:857
       shrink_kill fs/dcache.c:1317 [inline]
       shrink_dentry_list+0x209/0x310 fs/dcache.c:1334
       prune_dcache_sb+0x119/0x180 fs/dcache.c:1416
       super_cache_scan+0x362/0x4a0 fs/super.c:225
       do_shrink_slab+0x6d0/0x10d0 mm/shrinker.c:452
       shrink_slab_memcg mm/shrinker.c:569 [inline]
       shrink_slab+0x838/0x1210 mm/shrinker.c:647
       shrink_one+0x396/0x10f0 mm/vmscan.c:5320
       shrink_many mm/vmscan.c:5381 [inline]
       lru_gen_shrink_node mm/vmscan.c:5459 [inline]
       shrink_node+0x631e/0x6c50 mm/vmscan.c:6465
       kswapd_shrink_node mm/vmscan.c:7258 [inline]
       balance_pgdat mm/vmscan.c:7429 [inline]
       kswapd+0x1ff4/0x3a20 mm/vmscan.c:7705
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  &osb->journal_shutdown_sem --> shrinker_mutex --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(shrinker_mutex);
                               lock(fs_reclaim);
  rlock(&osb->journal_shutdown_sem);

 *** DEADLOCK ***

locks held by kswapd0/83: 2, on CPU#0:
 #0: ffffffff90297ec0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7332 [inline]
 #0: ffffffff90297ec0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa53/0x3a20 mm/vmscan.c:7705
 #1: ffff888043d2a100 (&type->s_umount_key#52){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:642 [inline]
 #1: ffff888043d2a100 (&type->s_umount_key#52){.+.+}-{4:4}, at: super_cache_scan+0x94/0x4a0 fs/super.c:200

stack backtrace:
CPU: 0 UID: 0 PID: 83 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
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
 down_read+0x45/0x320 kernel/locking/rwsem.c:1574
 ocfs2_clear_inode fs/ocfs2/inode.c:1326 [inline]
 ocfs2_evict_inode+0x2dd8/0x43c0 fs/ocfs2/inode.c:1343
 evict+0x6bf/0xc20 fs/inode.c:829
 ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
 dentry_kill+0x1b9/0x910 fs/dcache.c:857
 shrink_kill fs/dcache.c:1317 [inline]
 shrink_dentry_list+0x209/0x310 fs/dcache.c:1334
 prune_dcache_sb+0x119/0x180 fs/dcache.c:1416
 super_cache_scan+0x362/0x4a0 fs/super.c:225
 do_shrink_slab+0x6d0/0x10d0 mm/shrinker.c:452
 shrink_slab_memcg mm/shrinker.c:569 [inline]
 shrink_slab+0x838/0x1210 mm/shrinker.c:647
 shrink_one+0x396/0x10f0 mm/vmscan.c:5320
 shrink_many mm/vmscan.c:5381 [inline]
 lru_gen_shrink_node mm/vmscan.c:5459 [inline]
 shrink_node+0x631e/0x6c50 mm/vmscan.c:6465
 kswapd_shrink_node mm/vmscan.c:7258 [inline]
 balance_pgdat mm/vmscan.c:7429 [inline]
 kswapd+0x1ff4/0x3a20 mm/vmscan.c:7705
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#ai-bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

