Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219BFC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D286B00AD; Mon,  4 Aug 2025 12:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B753F6B00AE; Mon,  4 Aug 2025 12:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8AE36B00AF; Mon,  4 Aug 2025 12:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 955B86B00AD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:51:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F7FCC01B9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:51:31 +0000 (UTC)
X-FDA: 83739665982.19.A334F5A
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by imf28.hostedemail.com (Postfix) with ESMTP id B1F9DC0005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:51:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3EOWQaAkbAGkZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3EOWQaAkbAGkZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754326289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=T+SWqhnRSwH3R1CzBxQyfEv4bNSSoW82skBpvyoxCSc=;
	b=pyzu0kinuh69hQK+MLL9ZcwWg6yzo3oGT+T3+8XIBL/fbhQS/ZHvy6898QHvlaBkFu7EMY
	hzjeR/MflzHrlvwSdiUjmk3iYDDRUO6vxPIZlv0ly04Zvdbh4RX42W4muTlj/+jNH++3f8
	o+HZuVXR0wwEsHH/pRULY3s55tH9Sk4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754326289; a=rsa-sha256;
	cv=none;
	b=YPgfpA+Z6kfcGfEYkscvZzUoe7x1aYaTrkQ0Rd1R73SjZyhlzR+WrNKPw+NN3ENwbanCIA
	BwfrlC5Ki+zxId4Zoy/j/8uZhJ+W+vG+4WBNET3sGeC9CPnJYByP8rHp4bOp3qRuEmpIYz
	u3HQ7DpZc9IXjPI2vSL98LMRlQGa7h8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3EOWQaAkbAGkZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3EOWQaAkbAGkZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-87c306a1b38so243209939f.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 09:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754326289; x=1754931089;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T+SWqhnRSwH3R1CzBxQyfEv4bNSSoW82skBpvyoxCSc=;
        b=MPxR/s+DbNldKxRTGHojSTurSTnF4xSEIHocNHlv1DqivBbqepNp9/fCfTkUNxlIVo
         U1S5hGMC27dg+TEmRT6ymPEHgtzLG0c4N1fhcT0Gqc7ewM9QXRjgUq4NONZ6qSxfOd0s
         LEq6PyhD4pG09o2wg57gvWANorbUQC2G7P+vze9MUFYud8YxYuo+5bMZof4/kqPgudbM
         f8Jl5NEJNsU3LCF8A7Idps8aryiOyJa11FDUWIubtc5TefjTxYtLlvT3TrY4L4pcpjhO
         9XGAdhaLbsAmmSOQysX6GZI0J08HCdXzZ42xcd+Fnnx1Sg+6g0lqJwBjfW94PMJhrYc7
         wMnw==
X-Forwarded-Encrypted: i=1; AJvYcCV4+iJ7pO4BaWNh3zFHxkC7M8zj+2p9tsM+x0+ulCuZRv2wtjY6HA56/L+nzYA+5WpsQjuxP6u7hw==@kvack.org
X-Gm-Message-State: AOJu0YxkwrvPGOgxEdPpa0bayYD1Ss0YAEad/sKgZfxBWrPI9OYrC56c
	vp/mSjlOFU8QLzfgmAhnGKZMzDcXeQt2QK4BolpO5CjkrkEGbwyu8IlujP6A1igtuOhzEZvnAQo
	qP+fu6NbKfb9QL5CrrWmFID/VuendoWQBB3OR6DGdlMQog5qmdyQT/CQ23Ag=
X-Google-Smtp-Source: AGHT+IH04Bq8MVGpwIUoBtycOOr7vPMxx24HVA0oKBXHAheqzKXH3rbQlrqpS7k9as0bBK2jRst+SxKgq4Sy8a4NND7+3pAMIAuf
MIME-Version: 1.0
X-Received: by 2002:a05:6602:26ca:b0:87c:1d65:3aeb with SMTP id
 ca18e2360f4ac-88168318805mr2137993739f.2.1754326288731; Mon, 04 Aug 2025
 09:51:28 -0700 (PDT)
Date: Mon, 04 Aug 2025 09:51:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6890e510.050a0220.1fc43d.000e.GAE@google.com>
Subject: [syzbot] [mm?] [gfs2?] KASAN: slab-use-after-free Read in lru_add (2)
From: syzbot <syzbot+8921d5debffa05b33b27@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, gfs2@lists.linux.dev, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B1F9DC0005
X-Stat-Signature: qji39i64b64swxx6a1swx13cm3mnx1a6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754326289-554160
X-HE-Meta: U2FsdGVkX1+SgTw4Hriq8U28Wz3ehzgfEMSV6fa7LIkW3kt4jf8CM73QO9vtD5t3eVPhtjvmcN18OT/ltYmjIBXC7C8kyFbA5lmpb6/zLoR2iSFa1tXN05uJqk/CBvDcEwZyDJ34+ARmJ+kf3kXB8Tuc2gpS+ANsaEVuww0cR7cYHGYi43pYYv0b0MF93e9WyIdGcepGbyp5Hbg39PVZ86GLlJZ+0XYWzN0jD0CmEN9VdZN0/fmf5igCx6rPK0G29aIblAxFXu2klR0KGwnD28wn3FwpNNiMliXncd0K6HV+m53KrtqAABQsFmVrpi4S8vExos2q8MhqKBks+hhIcZP2xO78ZNIDuvFrlbeMhRTrvfp/50hTuFHdP9Cugbgm9XLSPQsUxSmUwN+LXCLcESJ+Z8cYxniJXIs45Qa0AvBMBqjLU/NLW6nuWPMWbn6bFVmLqGFVmPpJjWqxVkUL0pZNbJRnQWvVLLj5Ql1/hbRfatkQujDV0+HJJpBjq+0/q0uDSLfzqI0RT3VT32knKRxmMv6PSYQ3oDHAQbHPLcmJ7YSZVEvqkWF69a3Dvg0HLlQuYWHZj2ju5QBeU2nqKa4VkEFruCuyUXzNMLincvV8W2sUsPEDfcimWsp15AHp0nPH4HQX6kW+dsGbp36+VMccf5DWGKI6S8On+Lyk39gtuHuaFo9KxjBpQJDAPJtXz2bIXc6Ykv9spm2ucOREeoJiTfRd3Rf5WBPFhituGiCnCAZT7ZicNH0W+LNqMnkzILTjYsl9ugpZ7ofGlW/2aLas/CikamQ/RwDaa0hpS2TxZ5o8AmqecYUoGCatwxEPAhvZwErvWpn7KDl55/3jfAxUNlWI77yErqO4cWhV9QjJgDoy8W1nROs1P33QghJGYObRI3nHsheGGXCX5AnJSFEuz298Oy/9hsxBatk8jKNZUwHJBPRNRP5d2iMblz5vLVH+HXQMDgMxXieBH9u
 tbU/+sHD
 bJKsj5wPY4Cd16VqjWo8Pdql43LRp27DSAcLPRvJkfCxJh50iyainwbIbJu7iho8mGbU/ezW2c99S9YPnSSgyTDaUM6FiqOn1nIMQWT+xSPNHAO1xFIt9K0pDKaqYlzjjvLoDEVOMa8HUKZpK5oC+VXPqhc0nxlXzzkbC0PfrEWqx0Qmb0P+9c90hozh2wAXJ1zMjOu61CKeO6IL6zQKHnHJnk4RgiCDPC/a8tyfKqyLcwXT8bjrZCmCpY/gP+xje92fKLAx43H/esPfZY2Gd+nx/b5x7ouqR8we3V8LVBj+d5ZLNf9MjXaEahm1uwKspAOX9tXGcWqlRYGqox1tqeI8AIGKFITpkHxnd1qoFy6vLqxyv18ccK2S2gF2oYo5eBwiUVE9UnkEeFPR0gX5+GMrKY47R9hhNdjsPQZsuQiWu3Enf/BSo+p2cQKeY7B86nvlmEmjVv1YBCeqZ6+YRuVFqQJmg/N3Bt/s+x9qOLUhwJf2zW5HlDMxvBgSIBUJnWxLW368uZ3uIKndb2jwqHM0Iu/Itkfl3KqKxYVDNzlp0gP+s2TYSg9BoGC5Be2ZSvFmPJvqb/2U3aTeD6elwgDbz7vJF0QaRxKjmeVoKWQerrI5yHJc0JDkg1BfmrSMVcN2Di78qPE0jt2U1TxwslgRkC8B9JqaApMs418vBhNFFKQIuOCjZImQDAAJrycKzyolujf89jLrdXppdY1rb0nlV3okdzGPHUN6Yz/nbmp8UPuaBpdN0CpG4iSr5aZQWQ35tyP7vMJUO713bjuBU1cb4/1bCkRUd4Tb/v3rW7WqA5cnDXUa4iZPEnK0SJ436bBk0+JjFxkKqragExlPcMRhfFrYBZ/V18RzaX0vBzxz/qbYiE8npPA85/XEwyhWBcK5ly8DKffcUatZJaG6k5SK9y7/DVmjVIFnoGILzLWsI5Y0cAaLo86E/IfxIRQIrOBHuKqWbtJUdwkEaPNOubRQfTVj5
 ihMub+JR
 YYeYYzaIsDlvPy/hyJzYkucrSJ5L/G+ACRasZUEFncf5B6fuq4Dtfcb7NGopIKA/i2L6ElhMrvZr1YLFn0nLXLGdVUloJlUsAA0KeehDQ8gLXmEPQ/ujbr2yetXijsniyvScm+yqXZ817QHgjwY9sFdNTfZceotnJ9TBVN1JC0MxmLy4VNFEOvuQbkTnvldMjnuQiGqHTCQzhMt/H1iY6g/yxFZE/kv99Eln8ABzHzpqM5ULtPngf4GDmz1edTDH7qO3xOIUChZaXl49gUdVSfQz5Z7zJhWA2efZ2JyP6VRBlQjAAUoywQFBWINC7PXzduPsjpJs+yqqN9E1liYgnmVxqZ+D1GkAjHEEg5meo+bQTUVq6l+p23tcx6yyzrKlTCxrqdtAU9fKsLiim3jHpCTjNS3dwKtbZl8vTQstxFrASFeGs7GdE/3IazjwubP8ksfCIbTKdDMKsSTgyFUMJUEAEFgQOBE+DYGZtdVEszsiWZ9D7uOfdq3W/v0Al8Dj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5c5a10f0be96 Add linux-next specific files for 20250804
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12ce82f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f4ccbd076877954b
dashboard link: https://syzkaller.appspot.com/bug?extid=8921d5debffa05b33b27
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e0c042580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ce82f0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cb2134de7be8/disk-5c5a10f0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe8a36605e0c/vmlinux-5c5a10f0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/12df22603d55/bzImage-5c5a10f0.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/9e49622389fe/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=14ce82f0580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/c35702228966/mount_1.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12e0c042580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8921d5debffa05b33b27@syzkaller.appspotmail.com

R10: 0000000000200001 R11: 0000000000000246 R12: 0000200000000400
R13: 00007ffd8687be00 R14: 00000000000125bb R15: 0000200000000180
 </TASK>
gfs2: fsid=norecovery.s: Error checking journal for spectator mount.
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-use-after-free in mapping_unevictable include/linux/pagemap.h:270 [inline]
BUG: KASAN: slab-use-after-free in folio_evictable mm/internal.h:499 [inline]
BUG: KASAN: slab-use-after-free in lru_add+0x25f/0xd80 mm/swap.c:136
Read of size 8 at addr ffff88807e517898 by task syz-executor240/5932

CPU: 0 UID: 0 PID: 5932 Comm: syz-executor240 Not tainted 6.16.0-next-20250804-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 mapping_unevictable include/linux/pagemap.h:270 [inline]
 folio_evictable mm/internal.h:499 [inline]
 lru_add+0x25f/0xd80 mm/swap.c:136
 folio_batch_move_lru+0x21b/0x3a0 mm/swap.c:168
 lru_add_drain_cpu+0x119/0x880 mm/swap.c:647
 lru_add_drain+0x122/0x3e0 mm/swap.c:735
 __folio_batch_release+0x48/0x90 mm/swap.c:1054
 folio_batch_release include/linux/pagevec.h:101 [inline]
 shmem_undo_range+0x49e/0x14b0 mm/shmem.c:1157
 shmem_truncate_range mm/shmem.c:1269 [inline]
 shmem_evict_inode+0x272/0xa70 mm/shmem.c:1397
 evict+0x504/0x9c0 fs/inode.c:810
 __dentry_kill+0x209/0x660 fs/dcache.c:669
 dput+0x19f/0x2b0 fs/dcache.c:911
 __fput+0x68e/0xa70 fs/file_table.c:476
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 ptrace_notify+0x281/0x2c0 kernel/signal.c:2520
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x1d0 kernel/entry/syscall-common.c:111
 syscall_exit_to_user_mode_work include/linux/entry-common.h:173 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2ad/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f575cc3f840
Code: ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 80 3d 41 d8 09 00 00 74 17 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c
RSP: 002b:00007ffd8687bd78 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 00007f575cc3f840
RDX: 0000000000000000 RSI: 0000000000004c01 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ffd8687be00 R09: 00007ffd8687be00
R10: 0000000000000000 R11: 0000000000000202 R12: 0000200000000400
R13: 00007ffd8687be00 R14: 00000000000125bb R15: 0000200000000180
 </TASK>

Allocated by task 5932:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:330 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:356
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4236
 gfs2_glock_get+0x263/0xec0 fs/gfs2/glock.c:1182
 gfs2_inode_lookup+0x215/0xb10 fs/gfs2/inode.c:135
 gfs2_dir_search+0x168/0x220 fs/gfs2/dir.c:1665
 gfs2_lookupi+0x3d9/0x5a0 fs/gfs2/inode.c:340
 gfs2_jindex_hold fs/gfs2/ops_fstype.c:574 [inline]
 init_journal+0x54a/0x2260 fs/gfs2/ops_fstype.c:716
 init_inodes+0xdb/0x320 fs/gfs2/ops_fstype.c:851
 gfs2_fill_super+0x1923/0x20d0 fs/gfs2/ops_fstype.c:1253
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1335
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 0:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kmem_cache_free+0x18f/0x400 mm/slub.c:4782
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xca8/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:548
 __call_rcu_common kernel/rcu/tree.c:3123 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3243
 __gfs2_glock_free+0xb44/0xc90 fs/gfs2/glock.c:172
 gfs2_glock_free+0x3c/0xa0 fs/gfs2/glock.c:178
 gfs2_glock_put_eventually fs/gfs2/super.c:1183 [inline]
 gfs2_evict_inode+0xae7/0x1000 fs/gfs2/super.c:1458
 evict+0x504/0x9c0 fs/inode.c:810
 gfs2_jindex_free+0x39c/0x440 fs/gfs2/super.c:79
 init_journal+0x8f1/0x2260 fs/gfs2/ops_fstype.c:833
 init_inodes+0xdb/0x320 fs/gfs2/ops_fstype.c:851
 gfs2_fill_super+0x1923/0x20d0 fs/gfs2/ops_fstype.c:1253
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1335
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Second to last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:548
 insert_work+0x3d/0x330 kernel/workqueue.c:2184
 __queue_work+0xcd2/0xfb0 kernel/workqueue.c:2339
 queue_delayed_work_on+0x18b/0x280 kernel/workqueue.c:2559
 queue_delayed_work include/linux/workqueue.h:684 [inline]
 gfs2_glock_queue_work fs/gfs2/glock.c:250 [inline]
 do_xmote+0xce0/0x1260 fs/gfs2/glock.c:838
 glock_work_func+0x2a8/0x580 fs/gfs2/glock.c:1095
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff88807e5174d0
 which belongs to the cache gfs2_glock(aspace) of size 1224
The buggy address is located 968 bytes inside of
 freed 1224-byte region [ffff88807e5174d0, ffff88807e517998)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7e514
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff888140b3b500 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff888140b3b500 dead000000000122 0000000000000000
head: 0000000000000000 00000000800c000c 00000000f5000000 0000000000000000
head: 00fff00000000002 ffffea0001f94501 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5927, tgid 5927 (syz-executor240), ts 116383259321, free_ts 115796234787
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2655
 new_slab mm/slub.c:2709 [inline]
 ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
 __slab_alloc mm/slub.c:3981 [inline]
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 kmem_cache_alloc_noprof+0x283/0x3c0 mm/slub.c:4236
 gfs2_glock_get+0x263/0xec0 fs/gfs2/glock.c:1182
 gfs2_inode_lookup+0x215/0xb10 fs/gfs2/inode.c:135
 gfs2_dir_search+0x168/0x220 fs/gfs2/dir.c:1665
 gfs2_lookupi+0x3d9/0x5a0 fs/gfs2/inode.c:340
 gfs2_lookup_meta+0xa7/0x170 fs/gfs2/inode.c:280
 init_statfs fs/gfs2/ops_fstype.c:617 [inline]
 init_journal+0x10cd/0x2260 fs/gfs2/ops_fstype.c:783
 init_inodes+0xdb/0x320 fs/gfs2/ops_fstype.c:851
 gfs2_fill_super+0x1923/0x20d0 fs/gfs2/ops_fstype.c:1253
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
page last free pid 5868 tgid 5868 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 __slab_free+0x303/0x3c0 mm/slub.c:4591
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:340
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4236
 getname_flags+0xb8/0x540 fs/namei.c:146
 getname include/linux/fs.h:2918 [inline]
 do_sys_openat2+0xbc/0x1c0 fs/open.c:1429
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_openat fs/open.c:1466 [inline]
 __se_sys_openat fs/open.c:1461 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1461
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88807e517780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e517800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807e517880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88807e517900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e517980: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

