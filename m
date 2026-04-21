Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F28FF8FA94
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ECFB6B0005; Tue, 21 Apr 2026 11:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DBB6B0088; Tue, 21 Apr 2026 11:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8657B6B0089; Tue, 21 Apr 2026 11:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 726946B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:34:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C17513C12E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:34:25 +0000 (UTC)
X-FDA: 84682959690.21.0930C2A
Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FF8640013
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:34:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3_pjnaQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3_pjnaQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776785663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=LRuP+kKagoHrTdnYr51EPxRnKXTEHAevj5lSmoWGnQM=;
	b=YRwjNkiMS8+YYS1DHIG8a4iTj/k7NIkByaorSXJ09w2XF70Z+llDck7rh/m0i66Eav47+T
	KQ3Lx7SYL+1b52Zdc/4z34AOGn2YwNN+FSiUuqv9EKbP09KFPsMylBodRz9E990Ivb/5+f
	m09+0yEdI/uiF2W1FLnmWmvOlCYfP9I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3_pjnaQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3_pjnaQkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776785663; a=rsa-sha256;
	cv=none;
	b=gGhfKqeZ7qtma/2vb+/x20jKO5HKkcNS/ujGGi7/JL5LTYXcX8Zm32aICSjudiEZFmVOZo
	dizACOWXmkb/qKE30TGXhCotZnB4f+Z4fIqSXW+tvbiXbsG5mIjxw4v7KwV//AKh4vYkM4
	tb13z6oIbxMZNRDaUrwkqzMp1RvG85s=
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-40ad1c724daso6031764fac.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:34:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776785662; x=1777390462;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LRuP+kKagoHrTdnYr51EPxRnKXTEHAevj5lSmoWGnQM=;
        b=MgZ3x2T1EOuv8SeLCBLR9UNP1ML748AlySJ3qIgW+4AYPK1UmgqdnnmtJozS1qODNl
         JzNjAUHKs7W7NsTynMIK24VmcX6Yz/MF2vWyKbVYNzxPw8ZokhyASS9Xc1owuPEfYNWQ
         tZ99CQhDmOjUqbu8SXM3sTdHsBKNqL3m2nz8w1BwupI90k6Tku+bmoT0xDWgqdysShXp
         +3gSTXl7j5CEHPikDfpxHWo1VBiDkOsgBW42PB6498LUbwCcs8S/+LTMYlnnx9hyZ8KH
         p4+quKgSXE5PKpd6WIcpnAfrfgJQ0qV6IayQHDvm5hC3OsihJY8HyhSU6iLf9lLJzw+m
         btIQ==
X-Forwarded-Encrypted: i=1; AFNElJ82rBvLhwLL4oAMGB9SS31shSLFPuSiqVtFqJgO+4VpjLjbiGnO2Fjg41hE0tSot4rzRo1eS2ywng==@kvack.org
X-Gm-Message-State: AOJu0YxPBHmPQAQ49EOUt7fwDISN8OdDqZmRAcN/R2Dd/O0VH3Xo7+XO
	UOdODWVf7L7YDZkR8vH7cOXAM3EfyvnWuCB6ORTnJ2cYNIPT70+ij0TK8JeVITXX/uORnTLfYQs
	YFPxxc/PinXnqUCFZBHEgrN5eE24H4KCIUXAUI4bKMVZ3RgK3irQULRx9ClY=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:174b:b0:694:8f3a:3f31 with SMTP id
 006d021491bc7-6948f3a4350mr3429084eaf.26.1776785662338; Tue, 21 Apr 2026
 08:34:22 -0700 (PDT)
Date: Tue, 21 Apr 2026 08:34:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e798fe.050a0220.24bfd3.0032.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in rhashtable_free_and_destroy
From: syzbot <syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, mhocko@kernel.org, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5FF8640013
X-Stat-Signature: y1izqydgxrt5qn5xq8f9mym16ku8xejq
X-Rspam-User: 
X-HE-Tag: 1776785663-487209
X-HE-Meta: U2FsdGVkX1/29jODxE9lDw3yAytWxlwXLa+78BtZvxCCwOpVjzqRpm/7teiHT/XcFChPBuR6fIY6I1eT7JCdJkj3lP9cS3cdfX1gRa7lbTrrwhw1SJAAgPlpQ/U+SqpxeJgiwTO40ehU59jaxN3+q2xhEsT200Ic+xCpfUAu2/mANKJmEPYEiNfKBUj7eSg1UNfeclDkFzPUj3hbPxLeXpv1HMKUDmidHvIFvelx0onC8OdCUaG0oiPRTkMDouyG8aw5w3uQlRXdl11N4xOO2TvZi44alHeN/y+gd/34Tcbqeh7kQHB5054KJVvNHdWolZaWVMHS7C52M9RnC9P/gA2wntV4rlhv5EppCke22bPc//aUjElqa528UMLV2+AdmALYl6rpgQMP+BrJxcKAaMzGryxcLmGCDnFZCHjLu+xCUyd2NI6RK4xM1ZxqKJj/lMiUym5UgxCz/QD0ghlkZxTgDGZ+FgFBK/At4N0VyiajaxkO3zXTFXSyWcEamGfedijSHloJnOu2Owjq2VDEC5+OAku3oZj5V0VT/rJ9HSinsgBOwNfTVoFk4TiGM/trEiL/9xEiBxYW4WbRVjm3b1Ktb8/ZZuX7spkxakMIabLUMu++KIQwVGRZLCu7hQX+U0pm05OOOtY01xdxuvkVskv/ecvzxJndeKVKKyBSGiTZUc+ahpftZJg5B2/e+C6Ep4wr5PI3id/XHE2eEQgaM/1nMtTZvntcmTcNXMTnUkILX/MxGEreejD8P1BDEenwTHSfVATlHJsbH/us6W/rwKsNiDVIG3iz8Dynxba0Sue333H8CcnHD7DFMjrgejt0N3y113KV0Kzs+XrB+w5MmNUdpE2wfVGYmDpQjTTcHV23F/yk9Ta/eekLNykgiWYu28X/Z4VR4f7B64WLO+/s5JXGKzpFdpKg5kRFIrJLkrYz3R18TvfQHsgrFL4p6YyvBhyibKCHbO784yNqCm2
 TxbdxVTe
 TRCdk4hRS9Tc+tGLsYAlFpoqE0icWeSNU72MySYos/BPsbMo5Pj3K9/WWc7PEhV59fGaiv0r10euodA1VkHb7sGgGB1JB6CZZts1z3baSt8m/WrSksXCuYj2vE4ceRim+LbwSAA9RBGrSg4OgYa4RkyzX8AzdIYsHZefe+CasWpCi4D/32yxWqmiUkESDbhHKoxPzBmFVN4beU4H1tdfTP2hYJMYIDW+1evmVOtezmWBsFm9jZaG89mi5zrbAbAhB1CaXoUfSxIR6fpgeb+y14Rn9YZSHN8ahpNDj+Uo1ww+DRTi5HLc+kjdfU5oTWE+ig7suCQCoHNHDw7rMYEOLYKlmJzgc3m0Kl3RHmFtexq4vqItHqmAk44N/KXxJlh8wmgOmIZoij3LA3bjd0TzKxESk0Bsc38WlSeCpXCnHqnoyozHqKLVN6MA7cL7fKaMQW/4Lhn/2CBivTAsaxvg03JfOK8H91UwzH6ZwrEzjINHfURZmSD/S2xIYYU/dtoJB62k687DYUlg+IlYAEoilOjOlBUKbI4vZd2nC1+hL6qsoB/o8H5ecW/XvEEproJSHSIm2F7/L6MO4Lc0Ygc5oBdbItdCZvjDI7E4it19TTf0qXYUlxD/lGez3lznisos0rddj6FyQ/BjQUDB+l4Dvh29GlsmtqLYRIE2igZNYoGVV+t7CNEF1IySqXTHqzp9S9gKUkRHuSxC3oyxMTx92Cj7zcGGEFtRNDWjlXYsMIKGsiqkyj7JG7gZd7HdYFZaHsoOqaL5cdhA7X7ErKZ9i6/pflTSF6HKJ8dcjkbUsLtNeEK+qJCbhQesMG168mDAU6FODhWUGMPLjOJpzsR14fvkOpatjU/vJygJAymtHmvrYwfvZLkPSCcJDrkG11J+KCTqYQK7wVyaGmy3fL63LsB6Pw5cgcLKLHcj7EGGL2Huo7qoKjtWEKNPOCn5RweFkw9kOmXnu/OOjmxZTnLyzDMBROxXm
 bWA/tro7
 stwoq609HYmIHn+4LRsnb+374tLdHsuc5thTcl8+06BLuQ5gNm4z3wiRRARcUG2CkEovyd7KVDEuWOfTBPvjq1VE+dbllQcEX8ZOtPp4twbdAUcPbdtDLUX0gDq70UmReqtJiKkTu3kc+USUzTHadka+RcH09tLrDFdF55wxovfkxiI3nEKoVkJChfYEMtUXd3IPdyyY2qYQWKNsUJHXlJTrgLd6uEPqQuIhaKVM9SNv0cTtaVJrxzEv7FOrWIgel4YZMXxYRdY1/pL1AmArFSNisZy+y4XzzTRRc5nrGs4x2wyoAMFYjyjsQosa69cfDaFSzN5jKWbcERTvlBTo3flw8p7Ox+Zea7e40nVPHW9VKRJjHhkfXdSPfnMdf5RfLuSenN/BbY+CaX8ZTKFLhc75eh6ETXydyE3Nt1S/NM2zEvVrgOULeRKOT1OiPlhP5+dRzy832820W2sqQNlikids9vjJYkPj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8541d8f725c6 Merge tag 'mtd/for-7.1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15380836580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e54da1916e8d11f
dashboard link: https://syzkaller.appspot.com/bug?extid=5af806780f38a5fe691f
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8541d8f7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/22dfea2c37c2/vmlinux-8541d8f7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e2f93ad68fe3/bzImage-8541d8f7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
kswapd0/108 is trying to acquire lock:
ffff888056f3c4e8 (&ht->mutex){+.+.}-{4:4}, at: rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154

but task is already holding lock:
ffffffff8e9b0800 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb5d/0x1ac0 mm/vmscan.c:7102

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4327 [inline]
       fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4341
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4520 [inline]
       slab_alloc_node mm/slub.c:4875 [inline]
       __do_kmalloc_node mm/slub.c:5294 [inline]
       __kvmalloc_node_noprof+0xcc/0xa00 mm/slub.c:6828
       bucket_table_alloc.isra.0+0x88/0x460 lib/rhashtable.c:186
       rhashtable_rehash_alloc+0x68/0x110 lib/rhashtable.c:368
       rht_deferred_worker+0x1d9/0x1fd0 lib/rhashtable.c:429
       process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
       process_scheduled_works kernel/workqueue.c:3385 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
       kthread+0x370/0x450 kernel/kthread.c:436
       ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (&ht->mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:632 [inline]
       __mutex_lock+0x1a4/0x1b10 kernel/locking/mutex.c:806
       rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
       shmem_evict_inode+0x1ae/0xc40 mm/shmem.c:1429
       evict+0x3c2/0xad0 fs/inode.c:841
       iput_final fs/inode.c:1960 [inline]
       iput.part.0+0x605/0xf50 fs/inode.c:2009
       iput+0x35/0x40 fs/inode.c:1975
       dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
       __dentry_kill+0x1d0/0x600 fs/dcache.c:670
       finish_dput+0x76/0x480 fs/dcache.c:879
       dput.part.0+0x456/0x570 fs/dcache.c:928
       dput+0x1f/0x30 fs/dcache.c:920
       ovl_destroy_inode+0x3e/0x190 fs/overlayfs/super.c:217
       destroy_inode+0xcb/0x1c0 fs/inode.c:394
       evict+0x599/0xad0 fs/inode.c:865
       iput_final fs/inode.c:1960 [inline]
       iput.part.0+0x605/0xf50 fs/inode.c:2009
       iput+0x35/0x40 fs/inode.c:1975
       dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
       __dentry_kill+0x1d0/0x600 fs/dcache.c:670
       shrink_kill fs/dcache.c:1147 [inline]
       shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
       prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
       super_cache_scan+0x328/0x550 fs/super.c:223
       do_shrink_slab+0x416/0x1240 mm/shrinker.c:440
       shrink_slab_memcg mm/shrinker.c:557 [inline]
       shrink_slab+0xa7d/0x12e0 mm/shrinker.c:635
       shrink_one+0x398/0x7f0 mm/vmscan.c:4932
       shrink_many mm/vmscan.c:4993 [inline]
       lru_gen_shrink_node mm/vmscan.c:5071 [inline]
       shrink_node+0x2673/0x3dc0 mm/vmscan.c:6059
       kswapd_shrink_node mm/vmscan.c:6913 [inline]
       balance_pgdat+0xaaf/0x1ac0 mm/vmscan.c:7089
       kswapd+0x557/0xb60 mm/vmscan.c:7362
       kthread+0x370/0x450 kernel/kthread.c:436
       ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&ht->mutex);
                               lock(fs_reclaim);
  lock(&ht->mutex);

 *** DEADLOCK ***

2 locks held by kswapd0/108:
 #0: ffffffff8e9b0800 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb5d/0x1ac0 mm/vmscan.c:7102
 #1: ffff88801347c0d8 (&type->s_umount_key#76){++++}-{4:4}, at: super_trylock_shared fs/super.c:565 [inline]
 #1: ffff88801347c0d8 (&type->s_umount_key#76){++++}-{4:4}, at: super_cache_scan+0x98/0x550 fs/super.c:198

stack backtrace:
CPU: 2 UID: 0 PID: 108 Comm: kswapd0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
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
 lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
 __mutex_lock_common kernel/locking/mutex.c:632 [inline]
 __mutex_lock+0x1a4/0x1b10 kernel/locking/mutex.c:806
 rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
 shmem_evict_inode+0x1ae/0xc40 mm/shmem.c:1429
 evict+0x3c2/0xad0 fs/inode.c:841
 iput_final fs/inode.c:1960 [inline]
 iput.part.0+0x605/0xf50 fs/inode.c:2009
 iput+0x35/0x40 fs/inode.c:1975
 dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
 __dentry_kill+0x1d0/0x600 fs/dcache.c:670
 finish_dput+0x76/0x480 fs/dcache.c:879
 dput.part.0+0x456/0x570 fs/dcache.c:928
 dput+0x1f/0x30 fs/dcache.c:920
 ovl_destroy_inode+0x3e/0x190 fs/overlayfs/super.c:217
 destroy_inode+0xcb/0x1c0 fs/inode.c:394
 evict+0x599/0xad0 fs/inode.c:865
 iput_final fs/inode.c:1960 [inline]
 iput.part.0+0x605/0xf50 fs/inode.c:2009
 iput+0x35/0x40 fs/inode.c:1975
 dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
 __dentry_kill+0x1d0/0x600 fs/dcache.c:670
 shrink_kill fs/dcache.c:1147 [inline]
 shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
 prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
 super_cache_scan+0x328/0x550 fs/super.c:223
 do_shrink_slab+0x416/0x1240 mm/shrinker.c:440
 shrink_slab_memcg mm/shrinker.c:557 [inline]
 shrink_slab+0xa7d/0x12e0 mm/shrinker.c:635
 shrink_one+0x398/0x7f0 mm/vmscan.c:4932
 shrink_many mm/vmscan.c:4993 [inline]
 lru_gen_shrink_node mm/vmscan.c:5071 [inline]
 shrink_node+0x2673/0x3dc0 mm/vmscan.c:6059
 kswapd_shrink_node mm/vmscan.c:6913 [inline]
 balance_pgdat+0xaaf/0x1ac0 mm/vmscan.c:7089
 kswapd+0x557/0xb60 mm/vmscan.c:7362
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
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

