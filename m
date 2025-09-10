Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC41CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9B28E0008; Wed, 10 Sep 2025 08:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A628E0002; Wed, 10 Sep 2025 08:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7514C8E0008; Wed, 10 Sep 2025 08:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8298E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:35:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0102FBBDD8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:35:34 +0000 (UTC)
X-FDA: 83873286630.14.3927767
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf23.hostedemail.com (Postfix) with ESMTP id 47DA6140002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:35:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3lHDBaAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3lHDBaAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757507733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=yf3HksuGDvdFhsxx6nkK7e8YHDdD/H22VcMIwJxIl2w=;
	b=pAYQ8q27n6fgC3mLjXR9jxGH433iE9rQNfyvpC7lN1iJdqXpFFpVCZU4SRIWEOvS2BGsZh
	TClq/Twnw44X8UeHxHo9Jpagsf/jS11fzzc/ACx4elJNnMi6RfwKETW7mzKhiMLPmPfhfL
	5Yy7JrCIIb3K7sGWep9sw9Kwi1xsBig=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3lHDBaAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3lHDBaAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757507733; a=rsa-sha256;
	cv=none;
	b=G1LxNPcgJaOODtAGM1pjQK3GTHVgKVIDQLvpqpWpZ7HBw7qp4SUErcyKViBhjEdcxOcAwR
	5K96ZKc9XywpzXNl3aQ/ma0nocCYHPeV7HjwkNncI4y2+38Ek+hBEbGkpIfBcsZR00xpCp
	xEYOOjmFQdrK80ZFrdd9QLOdesBcCgA=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-406f47faa7cso50013405ab.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757507732; x=1758112532;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yf3HksuGDvdFhsxx6nkK7e8YHDdD/H22VcMIwJxIl2w=;
        b=wlsdVpz6b/u7JTuSFIvvdY8sn/BGHF2hFFunw2JM43TJf8BwHx85iv20KOklQRWjhL
         adgTldw7HN//ZvdezetgTaPWPvzSBM7Mc0ejlXm82gFcft8i5NCje7pzM5b88TVKoQP3
         yteM0aB5WdUOh9KtL1y2fizb7FiA0SiidJ6Qawze39sPZeqHexeH+kIn2QwUkWBceKSV
         iJBD5b/ykjficuWx9v43gwF6EEGFwECAc/uNVwl7WtZK3560REXb8pRtihgy3Ix92RaK
         Pkm5/Y0Ilk/3KPXjVEaOivOOhjg5/zffli+aYM4dYQM8vUA7Ui1Nq5Tq4Wu/C1Jiuj6o
         WzLw==
X-Forwarded-Encrypted: i=1; AJvYcCW4ixjjzYqR9XkRPTkbJkm5Cl03MkSFcBAkuxHOy6xX93SG4JPmGj8kwAz1lckd8gBmY4Dv61pjnw==@kvack.org
X-Gm-Message-State: AOJu0YyfHY6/BZGz7rGbLVJu3HG3oBka91/Pj+696MT06iGmKbJ1uA0P
	bv1HpQ5ZoEYLObltOZwizXP3AFjoFE5H+dAYphrqJ8/OXrOfBXiZmgc/ATU186FMTCG5fptE+Qh
	0y/8x1akMhqY+71SPlYTiOSDdD9RRoeaFeuUB3hYpGkVY3j84t939RCUxGt8=
X-Google-Smtp-Source: AGHT+IFZFxaZPS26lp8nYaF+DSjAOMPPpTFrsM3kQdmD9U2BfhAjHIl8KXRacMIRmk6w7XNFvXb93y1ZFL57FpLJZVZECw1WyCBL
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184c:b0:3f6:55e5:1914 with SMTP id
 e9e14a558f8ab-3fd94458067mr235498475ab.18.1757507732292; Wed, 10 Sep 2025
 05:35:32 -0700 (PDT)
Date: Wed, 10 Sep 2025 05:35:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c17094.050a0220.3c6139.0021.GAE@google.com>
Subject: [syzbot] [mm?] KMSAN: uninit-value in __run_timer_base (2)
From: syzbot <syzbot+7d660d9b8bd5efc7ee6e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, chrisl@kernel.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, syzkaller-bugs@googlegroups.com, 
	weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47DA6140002
X-Stat-Signature: o9cufpiyizw671rk5onskake761rqcfj
X-HE-Tag: 1757507733-685132
X-HE-Meta: U2FsdGVkX1+2HTWscXdQX6UVvnnTTwZqjkbufQK9U+/z7H2oPkaEDmliQvgzvblLFC9FUlHiJTZEJml8WRJ8M59DX27j6aBll1UAhQFjgYrY2KVYjaDrrUMSOCxKGsI8fmVxv6tbAcFeDG0GaNuH8W9OXMXaohMtyI3bYsUCzjBbA/U0SrMu3Jqi4MbSzkkXnSCSdp/kXogkQ7kRt1l5SWhyp7n8I42unJ9LYtGg4usOdY//ept0H8qjf/+ZkiI+wS401ln10J4GSbOJ3ZlkcWip0IVXDRxsDiGmCiPIshbdFe4DQWTDg7s3SanzAHDbbIbiqwmQayxyGEWE6gdPhzJlmRu90n8wVqDGj/iNdYP9nUNJYj/3LOqxLhkY0NpCtFaPDzOOps86GV0rWJl2dCpWtIsCtrnMh52wVHl5biB22mixNngK5XXZ1t/eWqtUMHYGU0qp141N7A5vYDXW8GxaZHTb0dh0MG9HNrTCbPJNQcac/+IXe9fylHfYDyPbqpD6ByYCBmv6b7U2NsquDOlN5TZRHus+FuYiIHsAIkr5wgzG4Md7g5vmRXkrnW5VdUpfZWxY2Czos6LLLwQKpFOoF8hR5xE7adcn2rIPFqWDC65qnnmi6Ea6CJa6jUcNW1AZC+OYKKZ00DueBi2plfaLcvpPTJN0BirJYwz8rwdErepKeSgS1b+GXtK0G6Ta1hxE4fLmRjyeZ+GOGA8ENA5B3L6f4ZOR7wXpEKgjAb2d5wwSkFHj3N/I+szutkdCYcrCzlRKFMhRbhai69wPE+uOmtYTPXw/DVNK8kXbVDWr6Tad5X/NWytuTFKgaADQC0w54+RiLcxXeVuiaModxS8VlGnpy3xxOR0tBtSbDCXWuEqqkMCCg5pzlxyYmmafQmfdSNtlcCj7kP28kQa1B7YicUmeQtOc2blKJKRY9Hn4MF/ju2WLZEnMCktoTt32b/dgWt3hj0sXy8N7GT0
 ucc1Pndw
 92Kpjk5jEYyoAqjmGrh5kKa9kkiL1VqasSQnI+PsthSBMhkkD3JrqgwMicoVkpAR0D56V8kv3YAJSrHQQB98RaaQdkEl2Ba5AW8YmzDGbF7hSXw+qR+S5UsSVv11CTMiBCD9yEOFemWch8wZq+9itb3am/tmoibc8iNz+MIKASGdR9pQPSKJSfM7fShYc/rScQY3htKpkKrqz+D358WVCNAoc8ufVLRFs213MHKlO2E+7HjfPfp3DXxMXSvWJge9x3AgNxDMce1i6z20exd+AudsXRH+T50PY+pr+e7hgwg8KwNz6K1URaDOYQ5DcrHKtO7cLu7S/+PtgfNZCfMJCxCwECSZEYyGHtVVFojHvlh1oF1w5gJ6DHy0rbgmuHI/fhzBSiZ7MS5TIxzIcMXKx3tIUsnrepK8vBXcCnIZjyf+7bBdVSHCtw8GUO5NSAEbedePZ8lNzE5HuDOYJv80ZfP2tzrkhkQ59+051jlhu84LggFb8ibJXzn5bmJX3JS11AdQww5Z7hf3LpuFsgrMGYvt7CAV0A49AwFM7MfOV4Qfc9lU8+OjeLtBS73QxxBHK+VP6b84y9Q2Eu8E/3zUkCXgTeNvFr84MzaHi4bGgd66bFuO0wJQFPzi9UdLFjJdrRRRv7m1XYZs0CV85yA2GAC90F5mwF9JWA88dVfSAuvbqr8dZv6PDEL3ZOGYns0HXJ++DRaAe/4/ZK8m9qxeTPP+1lxvcbZxq1lfYG83kIdD9MnPfYpmj7xTl03R+mVLAvbnep6uXkJ03IafwPvmkzHXAAq0oavSIF4MlGVj+jQxkUHpgkR8LAofWY8fQxfJq/3MHSVRv8YU33NcpfA2+PsC+x8igi3r6UrKbQTr0NGwyvclfTZ43/fBh9NosHpVVnOlrvJPuGFL0lrDiuWmzhh+D26r3yldTR9MQv06DOyywlfX2JOwslrgtp0ljmwh4/NQ9PgSzksGTTJ1vrUIRaF5VXNOT
 TYhv58zb
 eqDXh7rvowpiW6w2rahnt4nVXiHfup8wOt7PQ34kE6FJf90Eg1txz6wYy4qHJ9rze6zSm2cL54W2gWss59Awghao+ct0H69+AOlLBGgqvCnd3Fcd5BO85/C5jFcSmZ4rLUNJEHglxEDlTdLRO29UFvcrHFJIxeFJ+ls9CQ1M6ZCk391iu7I5UIg04tMid0KJwkRFLOKF5i5s1XyfIEJ7411RVS0gQegEvGCTjHHsqfqseqQLO4WDrvy8hqEBF1qN+Q3jLCzbx6sYS8xkZ0SD+qtZp4n3BY+ib7Gw052AHr2colOsqxpAGhOO+jdOWgedOUh+WwVUkl4uQ/gEMn8EZ/Fwx/cxFmP6jRLxU22gn+huruCD0r3aYmJ/e8Pzndzd8JI8zSEX2QQcKX5sR73gZ2NC8k3zrXsb4ZXbpGchqgE5/PbT/8QiNNjuseMcX6pC8wEtDiOt8njHD4p6wRb1kfrNLNXy3Gdj6pjRCmnW7B9XwSnybrT2cui1Z55iwqc1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    d1d10cea0895 Merge tag 'perf-tools-fixes-for-v6.17-2025-09..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1583ba42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ee07385471829e7
dashboard link: https://syzkaller.appspot.com/bug?extid=7d660d9b8bd5efc7ee6e
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b803befa3a5f/disk-d1d10cea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9f37cb94f110/vmlinux-d1d10cea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/68d1d6d1e102/bzImage-d1d10cea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7d660d9b8bd5efc7ee6e@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __hlist_del include/linux/list.h:980 [inline]
BUG: KMSAN: uninit-value in detach_timer kernel/time/timer.c:891 [inline]
BUG: KMSAN: uninit-value in expire_timers kernel/time/timer.c:1781 [inline]
BUG: KMSAN: uninit-value in __run_timers kernel/time/timer.c:2372 [inline]
BUG: KMSAN: uninit-value in __run_timer_base+0x690/0xd90 kernel/time/timer.c:2384
 __hlist_del include/linux/list.h:980 [inline]
 detach_timer kernel/time/timer.c:891 [inline]
 expire_timers kernel/time/timer.c:1781 [inline]
 __run_timers kernel/time/timer.c:2372 [inline]
 __run_timer_base+0x690/0xd90 kernel/time/timer.c:2384
 run_timer_base kernel/time/timer.c:2393 [inline]
 run_timer_softirq+0x3a/0x80 kernel/time/timer.c:2403
 handle_softirqs+0x166/0x6e0 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0x66/0x180 kernel/softirq.c:680
 irq_exit_rcu+0x12/0x20 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0x84/0x90 arch/x86/kernel/apic/apic.c:1050
 asm_sysvec_apic_timer_interrupt+0x1f/0x30 arch/x86/include/asm/idtentry.h:702
 kmsan_metadata_is_contiguous+0x10b/0x1e0 mm/kmsan/core.c:-1
 kmsan_get_shadow_origin_ptr+0x27/0xb0 mm/kmsan/shadow.c:96
 get_shadow_origin_ptr mm/kmsan/instrumentation.c:38 [inline]
 __msan_metadata_ptr_for_load_8+0x24/0x40 mm/kmsan/instrumentation.c:94
 is_last_frame arch/x86/kernel/unwind_frame.c:87 [inline]
 is_last_task_frame+0x2e/0x370 arch/x86/kernel/unwind_frame.c:156
 unwind_next_frame+0x60/0x350 arch/x86/kernel/unwind_frame.c:276
 arch_stack_walk+0x1b1/0x280 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xc3/0x100 kernel/stacktrace.c:122
 kmsan_save_stack_with_flags mm/kmsan/core.c:73 [inline]
 kmsan_internal_poison_memory+0x4a/0xa0 mm/kmsan/core.c:57
 kmsan_free_page+0xd5/0x160 mm/kmsan/shadow.c:210
 free_pages_prepare mm/page_alloc.c:1317 [inline]
 free_unref_folios+0x270/0x2a20 mm/page_alloc.c:2952
 folios_put_refs+0xaac/0xb10 mm/swap.c:997
 folios_put include/linux/mm.h:1419 [inline]
 __folio_batch_release+0xe1/0x100 mm/swap.c:1057
 folio_batch_release include/linux/pagevec.h:101 [inline]
 shmem_undo_range+0x926/0x2100 mm/shmem.c:1157
 shmem_truncate_range mm/shmem.c:1269 [inline]
 shmem_evict_inode+0x232/0xed0 mm/shmem.c:1397
 evict+0x6fd/0xd00 fs/inode.c:810
 iput_final fs/inode.c:1897 [inline]
 iput+0x996/0xdd0 fs/inode.c:1923
 dentry_unlink_inode+0x5ce/0x6d0 fs/dcache.c:466
 __dentry_kill+0x340/0xbf0 fs/dcache.c:669
 dput+0xdd/0x240 fs/dcache.c:911
 __fput+0xb0a/0x1040 fs/file_table.c:476
 ____fput+0x25/0x30 fs/file_table.c:496
 task_work_run+0x206/0x2b0 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0x2a6/0x330 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x1e3/0x210 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4197 [inline]
 slab_alloc_node mm/slub.c:4240 [inline]
 __kmalloc_cache_noprof+0x7f7/0xed0 mm/slub.c:4402
 kmalloc_noprof include/linux/slab.h:905 [inline]
 rose_add_node net/rose/rose_route.c:85 [inline]
 rose_rt_ioctl+0x1fc7/0x3b30 net/rose/rose_route.c:748
 rose_ioctl+0x4f8/0xc60 net/rose/af_rose.c:1381
 sock_do_ioctl+0x9f/0x480 net/socket.c:1238
 sock_ioctl+0x70b/0xd60 net/socket.c:1359
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0x239/0x400 fs/ioctl.c:584
 __x64_sys_ioctl+0x97/0xe0 fs/ioctl.c:584
 x64_sys_call+0x1cbc/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 30968 Comm: syz-executor Tainted: G        W           syzkaller #0 PREEMPT(none) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
=====================================================


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

