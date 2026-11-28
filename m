Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE36F606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 03:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81416B05B0; Fri, 27 Nov 2026 22:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32536B05B1; Fri, 27 Nov 2026 22:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948426B05B2; Fri, 27 Nov 2026 22:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 479746B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B25D24058C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:27:33 +0000 (UTC)
X-FDA: 85483092786.21.58B4381
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A292120006
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:27:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 3I0oKawkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3I0oKawkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795836452;
	b=E3TGAVJ5b+ibFZ7a/IhzaJT7laJpKJgGYqVEck7j1WpEryTXnqSvJMwCVlARK9B+y0peye
	JJL6KB28+zLguv1si80b0C8jalmQyZHelB8OMsRvn5xl1qQNFyrKfxuCzspiQ8do0MLZFZ
	jZGigMu1csH8nxvKovNEq81TJq14MKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795836452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=V6yd2WiMQDnkgmWaLVy9/F+hOxiOeH3B2t22ru+0YjE=;
	b=5+DIbGeaRp7n5qhLbq3DQhp5U7bY624XRYK27XPrt2Pjnu2E+OYNe5UxpAFj3WSUeP6I7y
	QKPa4HfL7o0av2O3r3YT7E7GXJIIhJ97rq4PBdl1Z1zRL9LCKFvAwoML1Wf5+Xbe0tBpOK
	MecXasPa9/7E4SP43FU0nkCLxBSe9ZY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 3I0oKawkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3I0oKawkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-57ce46ad0c1so7305064b6e.2
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:27:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795836451; x=1796441251;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=V6yd2WiMQDnkgmWaLVy9/F+hOxiOeH3B2t22ru+0YjE=;
        b=A20zkCRGHIzxSrDGcDJfBN8AuWr5HQQI4Hu6vb+CQf1ZAXklU9ws818Tekd/Q6cbBs
         StKAxUXajvOV2sGFkcZJ5WNqAcIbXxb96oxW4jjQ8pmXorSNot2a3eY+Uo8PnUviHm2L
         9RIpoLHQSp+6Nd2kFZVF3JdB4NlRHL9JaPazxgNrkolc3SdC0RT0jv9IM3PHW+GPOUvK
         lq0gKkZhZaLj7CMC4RI3A6KrbAVet8H1mnJ+T3nz/3iorUAU2/Yb+WgvIK9UWW+cxhig
         /lPxUyI292vZxRr5QsjdiH0HhIzI3Wb7exIlg6YdsbpITz4gJXwLxoWxkPB7rtKxvHBo
         X4sw==
X-Forwarded-Encrypted: i=1; AL+hErH1+GbuEKJHlfB52WfXS/KENzbX30AY9YABZzxVOm4NbSdLCr68ezpIjU8bKRCFoYR1IoQHKgsIMg==@kvack.org
X-Gm-Message-State: APuU4Z/SnVnC4tz4xRWxgn7nuVG+Pg/J53dbuh5xOILz3+Pi+v+ZjXg7
	VAVTS3s5g4Rq45iqrXXKhS3iuFdd+PADUtpUcCCrKs64WUcaiHhFA+SWTcJFF/pzCq4hmw72I+3
	DxeUYam/PgAivrf+t1+IO7JiHVXUBetp2S391FAYnZii5JoGHkvf4o1Lj6Po=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1394:b0:510:7dc8:5ff7 with SMTP id
 5614622812f47-57a0a40536cmr30024229b6e.19.1795836451226; Fri, 27 Nov 2026
 19:27:31 -0800 (PST)
Date: Fri, 27 Nov 2026 19:27:31 -0800
In-Reply-To: <6b08920a.28411dd9.2968b4.000b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b0a4a23.8ccee5ca.1045fd.0285.GAE@google.com>
Subject: Re: [syzbot] [mm?] possible deadlock in ocfs2_evict_inode (3)
From: syzbot <syzbot+00969d07ff718daa64c0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	muchun.song@linux.dev, qi.zheng@linux.dev, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4anyk48m5kgswtotwoszokor5hwtiabn
X-Rspamd-Queue-Id: 0A292120006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795836451-438010
X-HE-Meta: U2FsdGVkX1/t65h6gYRme7qjeDjbAlsDTbhjza9adaLpgjMyng3GoVk/IB6GPPqzFmUeToL7DE7lqAR3K6SC6I4FWJBN2QUppdmP9/A7I1jScoa48I9qSExIBKSWJJqO8e0o2290q7pJMQcwvvwaHFIyN1g1aLjmXFFXYytUx2qiXw9t6pcPEhi2xSGqUOFBbmv5tK7hbRWlp+Z0V3TOZX5w2qufL0LivVRxG2TAVm81sMqI03amURiEoaZ9b0JLvNHqpRAIg579Q9zeNImCl3NS1PpsH4Hp2F1NNSyessFik0rTIqN6inWjXwCTqvkLv94pxdiYjx0d2J4WOjID/1HgOwn8/d2J6TIM3oT06Re/z5B0oXtI5WW7eM5FohIfcPuCUS/TDgrHQaM7J8XiZCqQhhAe2G4lGy1DsbC7BLNrHSkBhbj/or5fPGxiejC/op+kmnbgml5F+5btIfIgpJtjYa059lTTFPJYrMPlLT2ExFlslF1mMvSxuYhQFyf8rCQKk7EG+7uMevQES448JB1LLbVrKxSchvGpLmi9TC0B53+d54ivW9wCm0nazCzIhBEFLURekXqprLlOSrB9fBTQYwSmFNzKkUAWI/Vq2FS53VNMvAhA3nqSwf0LeVE5vBui+Q+FpJG8llyJHMlOK3XQN+IfaiNWArAnK1R82pLT/aFAQCqDFl9+LnCqtz5UEQHdYoGQGqAsv3n5VxsMO1LpjjrXLlFnMw60nTJGxqMXcwJG+LAMdZ6RtC+fg1Hu3cbu8vMcemMrvdEinDC6pizaVFkX8XnSIkeqB/teYF3VbHdtxwEZLIeYri9Uqy0GXWf/Yl26MCO8O2tQhh0cVu+KHJbqfMZqMIpnZAMFkSJJj79Y1eprfTUFlFi/4CwHg8smjORIWocO5ImGvKKhhaRDuGFXQ6HZAGCAz7Mco1M1tAT5rmOYM2v+u6NkQRlVWMTwl5hs6o3hWZAs8we
 1/ELyafz
 WD0U0nXOiZpxvEmiRTd9UIjAhTQMKLdMyWUKrFVrJY6j/22WlpsRTdiYD1847NCPnsXNH6vyzWyzOrKBM2f33gQ+mx3x2za/col9BUDFg+XlNT5f5UQgW3pv7Bu8cqnqBmmNJedgcU0py6M8I8lPdX3FWWpdEUcW3/Quh/JsE7btqVpYEMKZwSK0tokVXBM/TK3vLaCn3BxD0dpOsyYomT2HNuZZbhaCXGeVA9imgOoGwvPt+w393Q/g2JO/vHjdFluwrG9zSgGWhtQUUG3+n8Uc8D8swXSwkjadCixswmj+m8O4mRWF6K5nRJy2MBzWo4YaQo0A4py9ESTHJ3ikF7sSrdM1pNe4V2bJz+pzpL6gwLdhMwyjUJYIJ0XZgojBUQpgXdv9TAdj6BDhqS6kPNcnZy86SsUcTTgblI9L9ojX7/auFANaNRdnDidJaCHBDOhxxH1m7Mr2sHcDjnZ7VmyLVUOMyO/ruZtqJXIQaE0zz++dL7crE4oy8FJ5xkRIADoXFuIjRJLBcGdIRI+QNzC+XuneZds3RdTKdUqlgXR+vRtNmjT/+kSh/RnAmXqE/qC5OFoJFZm0bcKqxCuUhgT8F8obHrgBO4WWkbIvdHWA//jsHUGLVQ9mc3OtzJhNNglzkxwhVqQlmP38gMes9K76InCbBhgCrsFb+mAhvCTN9f5oUISXnnlhZPuUeOzfj7qjQ13HW9UuwWWm4Q2dxKnYCjXUSRvHDiopmmWOUWQWClUQSIWnPKGEfv05+iLnQ7pQDsqNItx+YsSWtsjabgu8KeE8MLGItG0hKWUXXRNpzbHhi3jGBLKVDXfy7mjopUhPKcwCmbUXjPMWT8d5ZVR7r2bCzPzZE5Xtr9Bdvng8wEZQ14DO98RMDKL8LZIgaaICEP/D4iNtALu58T1wcGUVg33N2Yn9FE5C84L8RmaRhn6olxnrvIF7B17BPkXmvu03hypOvchL4OWjq+QgDZcw8s6/p
 XVh4khyl
 Kq9iMZQkKB4UX1Cnc+XyX7WsAQWt4WQXY/EnjVffW15+23/vsZp0/1ay261I6FAxPje0UibRAMeyCpXm2VHZJ7V9hOY6vjgh7Z/gqtq8iuy82Em71WNz7xNzqKTgpe0/RP67pPwBKQEkYjfAIMxycjttwYa5xENN0Q6v+HVKOhitKCCIhBLdE2PjYquzsR8GM1UCbtatddfAEjNHpxae9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot has found a reproducer for the following issue on:

HEAD commit:    822ba3a89c78 Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1126c1d9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbd0fc734eea62ed
dashboard link: https://syzkaller.appspot.com/bug?extid=00969d07ff718daa64c0
compiler:       Debian clang version 22.1.8 (1~deb13u5), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1326c1d9580000

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
kswapd0/84 is trying to acquire lock:
ffff8880434b82f8 (&osb->journal_shutdown_sem){++++}-{4:4}, at: ocfs2_clear_inode fs/ocfs2/inode.c:1326 [inline]
ffff8880434b82f8 (&osb->journal_shutdown_sem){++++}-{4:4}, at: ocfs2_evict_inode+0x2dd8/0x43c0 fs/ocfs2/inode.c:1343

but task is already holding lock:
ffffffff90297e80 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7339 [inline]
ffffffff90297e80 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa53/0x3a20 mm/vmscan.c:7712

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
       mem_cgroup_css_online+0x84/0x7b0 mm/memcontrol.c:4404
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
       cleanup_mnt+0x204/0x2a0 fs/namespace.c:1396
       task_work_run+0x1d9/0x260 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
       exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
       do_syscall_64+0x336/0x540 arch/x86/entry/syscall_64.c:107
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
       shrink_slab+0xea4/0x1210 mm/shrinker.c:683
       shrink_one+0x396/0x10f0 mm/vmscan.c:5327
       shrink_many mm/vmscan.c:5388 [inline]
       lru_gen_shrink_node mm/vmscan.c:5466 [inline]
       shrink_node+0x631e/0x6c50 mm/vmscan.c:6472
       kswapd_shrink_node mm/vmscan.c:7265 [inline]
       balance_pgdat mm/vmscan.c:7436 [inline]
       kswapd+0x1ff4/0x3a20 mm/vmscan.c:7712
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

locks held by kswapd0/84: 2, on CPU#0:
 #0: ffffffff90297e80 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7339 [inline]
 #0: ffffffff90297e80 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xa53/0x3a20 mm/vmscan.c:7712
 #1: ffff888014a04100 (&type->s_umount_key#56){++++}-{4:4}, at: super_trylock_shared fs/super.c:642 [inline]
 #1: ffff888014a04100 (&type->s_umount_key#56){++++}-{4:4}, at: super_cache_scan+0x94/0x4a0 fs/super.c:200

stack backtrace:
CPU: 0 UID: 0 PID: 84 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
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
 shrink_slab+0xea4/0x1210 mm/shrinker.c:683
 shrink_one+0x396/0x10f0 mm/vmscan.c:5327
 shrink_many mm/vmscan.c:5388 [inline]
 lru_gen_shrink_node mm/vmscan.c:5466 [inline]
 shrink_node+0x631e/0x6c50 mm/vmscan.c:6472
 kswapd_shrink_node mm/vmscan.c:7265 [inline]
 balance_pgdat mm/vmscan.c:7436 [inline]
 kswapd+0x1ff4/0x3a20 mm/vmscan.c:7712
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

