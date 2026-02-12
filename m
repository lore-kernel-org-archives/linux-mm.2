Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B469DEEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE5F6B0088; Thu, 12 Feb 2026 14:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C016B0089; Thu, 12 Feb 2026 14:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D796B008A; Thu, 12 Feb 2026 14:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A36896B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:22:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 076781B3A61
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:22:37 +0000 (UTC)
X-FDA: 84436776354.12.957997F
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C0831C000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:22:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3eiiOaQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3eiiOaQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770924155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=bWgXbboKH/QWaeqU+FjbN7Mh/hQ8JS+Sw4DhFt0IOxY=;
	b=b5hFgjR/XavIzJrzyaAvLN4O39mzZsYl1xkF6JMIQs/Qt6SagVDr29pdo2S30h79NBnFfZ
	LZLlJLSdakIVOS/3FdZQdkPhzTxZnwylqGca6axrNjcGOJAwobUfSvC7H59bWeNqCSsgJ6
	Da7mwXtBuDjql6I3ca+lLWCzMV1YBuw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3eiiOaQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3eiiOaQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770924155; a=rsa-sha256;
	cv=none;
	b=tmy8rhiu2Q7Wsr2hX+WwUtGkK8aQLo4hDiRIuqUMV9ibiUukfDntZz7p7DVQ/qZab7eAhw
	qcibw/vrGoh4lMkdyqfUhm13xiKIQ1C7rGOZwbc/8Kw/u5ZK6uvluS5amYFJv1EBw8MJTx
	ULVzku0xU4u2WpENIcqgVcU0RLb5Te4=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-45f27888d8aso333452b6e.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:22:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770924154; x=1771528954;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bWgXbboKH/QWaeqU+FjbN7Mh/hQ8JS+Sw4DhFt0IOxY=;
        b=KHQd7o1XDFJxsQxD/eN+Ow/Jy9vXByDURaEu1rBLurfWrrL2NHYRrDDWm6W29dTW+3
         J8tCcV8atuVxHf6fnW2YjVfYdBMsoLJT7QPBnPhcv9EjHT37fXrcTsgp6Cz0yMTkyy0o
         onr0vLVezyriN+GUg+bpu2iHu7CiUOWczSUr6hVJiI/U5j+x0W/Ut0uktxLDYZsIj6Hb
         Zs0HciutSNexRSVlDNbp/rEFmUNJSujWePv3la1f+QBUvgrwXLGrGvJCKO2jSx0dYWas
         EClHLUP++CE0BnNQ8Ez5wfFQlZOumkMMn1sq47XlVwOT1d6KdfVDf9UhZLXftMaYT2Vr
         0GSA==
X-Forwarded-Encrypted: i=1; AJvYcCVo9ppqf3EgK113IVQKSxwQmYRmCwzIrQ0/14wMn83+AyyxZ2bnuoWH2GPBXCryJvKZHLNtp9BMig==@kvack.org
X-Gm-Message-State: AOJu0YxK9s1g62s+q7OdPREiFP4xCNriary8xGhNsAfRCq7itueWRYkg
	GCz5AOfGPrzTWltso1NkMNIrBocawlmDsNrKVDK8K4KMzS7ImyxCowDzO31avLWT0RMX/x390Z3
	7qHCigp6qe6u3I3goANSfyFrtmJzcug1rG0J7xwMiKkJDOXg4hpcm8jPHApk=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ae6:b0:65f:7470:38bd with SMTP id
 006d021491bc7-6759b9b5adfmr1508090eaf.58.1770924154367; Thu, 12 Feb 2026
 11:22:34 -0800 (PST)
Date: Thu, 12 Feb 2026 11:22:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698e287a.a70a0220.2c38d7.009f.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: slab-use-after-free Read in mas_walk
From: syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C0831C000D
X-Stat-Signature: rqfwia16eyzogtwxiff47bjt8x7b4eq9
X-Rspam-User: 
X-HE-Tag: 1770924155-145824
X-HE-Meta: U2FsdGVkX1/dUQEN9eJZVEuOzE5pD6RLXClNgiyjgO7447rirwcWzKdOlcSEdEXfLRWLX/qfUcm9+4i0AacP7VLjfv6ei+lqBQHKtzgeq04M/e9pCQnKNAuRYRzt78lEyfPM5jfQTz9RxypALVjtGZBPWBI33Qj//pP/9s7HrkupWQeOx983ioSjeSQ4I9mQlbxkfli7qFMpiYJn0TsECsies6beRCRPYhBOyWUo+w5OR1Sd3rWJNUdVh8g0UMwnAXov1gF6ttDgKppBM5m+ciFfONodPd67qWd7A9WccUur/f2K1giwPHepChudfB1BaC3ZUlDDTwcML9T7K+mmMi7fomHLbi4PiQz+vMtyRIFCP1ruze7HBllRl9/RAp3vP35Qpk6y0l7wu+u+dmoZF2ddi9VDvvz1JPb07SA9w4d6kblVJzufirnqb4+LFRNQc9DulxFXNs0WJxy5Zr14g0bFwCOmrrcPK6VK+ppx0iaL0ZYwNP4go1rrncOUZ8AIF7/G4wwSCrOAm2VQZmjIV8YQquyDiGA/ZL26YwKvWOB9+Zf8BKo1Zt0i2InnUJ84fp2S+ncKbVBq7yhvRyUAn5wo0LZjXf9o9tTxoa8TO91oKbxrrBGj3pqCdvVx3RZoGrgUIRM1068RZ/1DgkfUiiTbrAU8hyXJOfJPIS2jf+bQpsYulO76IiK5WkKaYyQOzVGLT0x2SfSAKIwhDyysig2FXI04Mg5TtDeA1OA9Trrdw9dTMW09o3VjMftFAPj5l9yO1w4RPabup7ntfRzYcgNzEbQvAccasbU/6XjGyN35AWILHeH4bDv5dBzf7j5piv3AUpXp6E/HsgDIlqiR+IF5uDVHVuvyKYVWpo+D8yytCI32ZHui+zPNRn6pJQ49Q9148eZODgLv257q91lZxMv9SaZJ6BqM6DzyXTgHclUFwAZ1qJQ771T8mmUk1uRa7XGOYbEmcWvFquLAPdk
 w6wB7dwC
 yTFN2KUQDzQuhwzfStZjN97EaKM38LQYACjZ9qTaj3vd5f5a+FzETBwK03dhz06GpfeHfA/xTmWA4sMkRSr5q1lg5m1Y/69zpq7bS4/RuJsm2YHvDF9dBS7Ioia/0wNQ5vRIeFTw40VZta3TLE5RVeG6kc1my4CK2LCpOjNY72RWvGJ8s23D8N2relHEJkZWaCMQCMy7zYMfajAj3mpxX9mQYvh3859RawLckRPXVI4AtsT1VPQWTInQrdJ/AHVScpDj51gJ/wN0hGoTppU0mVDqZ1++ewDzRejeoYn+jQzp2awa1X/zCJtMyY1FPTTY+qWWypBzNCAgKlNJzP3eI+skbiYjsjamwIUZxRJT5aPphnE6KZGCz1hSc62YIVzhEwsvNYOqP6C78rJ3zPy0BJv/BDVWl/0UW4Qk4zkmy8Yjgn7D+Ii/P3EX62y1z3x2wdeQYTzR7F5DHqmivKS5hco0R42M6vMcy/8FNe8fvo5KsKU5viqqx6Mdt+beiy8Pt2qkNU6c3l4KMUxSu0Vgsz4G/5V1AkeLiPntDfVe37yzu4P6DKIaxfS+HQT3G7tZH+J/EC4WBpYsWYAxFxBS9jyMWIp3YVR1TjAEU3HJFaswHWtKd+YuFq8i7etLw5TvhOCLSQktHeeQw+0CNd9G8MdhWBOlBHKY3O6sw61wzRhJ3CAFH/CAh2V8Lu/0PegfpJa7fwwY7OT+OEeEazQJwTEzJHJH580KmHDZibxqFiqnMGuFm6UBIQQFnhTtZxD7m2xyGZnKllDPsuRuaTCq3w6x1eMQGhS5TT6pudVxBjK11wfsroqCdP8n/vbCf4Op4T9DsbXKdnvXdha3nfZW75M5tPOoRxEYfKigXcsNbvlBJdaWMillZC86zY1j4dAUtUq/p9fGcieAoXf2i/0DTX5qriVXjuRP8UTsDZq6ZQxji1f1Ucsr/NjoLQ9dRDqNgpQBdjZHatN1KZF0R9OMr8MxFQps3
 gcIwmE9D
 qATBxXz/k5hBiNQMkxH+ZjGLkN1XBI/56KbPc6rVjCIjBqhFFN0HETLx1g09T77cnZEzf4jWc4jmY8FXgqtV78OuKE9vYmz0IpJgYxbpqGuuIkYWW70w2YslzQ5JlOxU2Qqjrfq1TLn5GHPoCZ6EvSCO2xEBj9QV4IwtGhzK9VEOJnKoBt1T3vHn7V+qXtGVGur2kckQ/tA6Dmq9rHBX0D0DolbtdcFTqbN2+ppIMiGOG/AI5LfNly3PHZi99Bc2Bil+d4ddffTAPW9mtCBTWeGcjdX6YRutjjFW0eec0Jlq7BJFNdmi3VMsXaHUNxpbN3iZxeOZHeikXmCW7dKFZW4L+gGwFFuZFGqr/Rqza2iR4Y9pCqkd1zy+FIi2oeWFGZdsHdspzvJjeEVudmJULSTFuwmNlbojviZticFX+vrDrfkmlofx96HuTe8sV2+oT0VoHz3/hr44ynH3oIZAFnQa4sFqbJdH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    192c0159402e Merge tag 'powerpc-7.0-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1304cc02580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aaa1d655bee4457b
dashboard link: https://syzkaller.appspot.com/bug?extid=54245a237762e7cbecf0
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d40ffa580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1704cc02580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a42150718371/disk-192c0159.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4cda72c184d0/vmlinux-192c0159.xz
kernel image: https://storage.googleapis.com/syzbot-assets/404b09fd74ca/bzImage-192c0159.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in ma_dead_node lib/maple_tree.c:572 [inline]
BUG: KASAN: slab-use-after-free in mte_dead_node lib/maple_tree.c:587 [inline]
BUG: KASAN: slab-use-after-free in mas_start lib/maple_tree.c:1207 [inline]
BUG: KASAN: slab-use-after-free in mas_state_walk lib/maple_tree.c:3291 [inline]
BUG: KASAN: slab-use-after-free in mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
Read of size 8 at addr ffff888078907400 by task syz.0.18/6008

CPU: 0 UID: 0 PID: 6008 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x156/0x4c9 mm/kasan/report.c:482
 kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
 ma_dead_node lib/maple_tree.c:572 [inline]
 mte_dead_node lib/maple_tree.c:587 [inline]
 mas_start lib/maple_tree.c:1207 [inline]
 mas_state_walk lib/maple_tree.c:3291 [inline]
 mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
 lock_vma_under_rcu+0x101/0x5a0 mm/mmap_lock.c:253
 do_user_addr_fault+0x41f/0x12f0 arch/x86/mm/fault.c:1325
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x342000
Code: Unable to access opcode bytes at 0x341fd6.
RSP: 002b:000000000000000e EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00007ff2e4816090 RCX: 00007ff2e459bf79
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0002000020003b4a
RBP: 00007ff2e46327e0 R08: 0000000000000103 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff2e4816128 R14: 00007ff2e4816090 R15: 00007ffc4f622688
 </TASK>

Allocated by task 5934:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_noprof+0x2ad/0x780 mm/slub.c:5270
 mt_alloc_one lib/maple_tree.c:174 [inline]
 mas_dup_build lib/maple_tree.c:6299 [inline]
 __mt_dup+0x5a8/0xc20 lib/maple_tree.c:6382
 dup_mmap+0x36d/0x1e20 mm/mmap.c:1744
 dup_mm kernel/fork.c:1530 [inline]
 copy_mm kernel/fork.c:1582 [inline]
 copy_process+0x7371/0x79b0 kernel/fork.c:2223
 kernel_clone+0xfc/0x930 kernel/fork.c:2654
 __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6003:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6674 [inline]
 kfree+0x1c7/0x690 mm/slub.c:6886
 mt_destroy_walk+0xc0a/0xfa0 lib/maple_tree.c:5028
 mte_destroy_walk lib/maple_tree.c:5049 [inline]
 mte_destroy_walk lib/maple_tree.c:5040 [inline]
 __mt_destroy+0x2d7/0x390 lib/maple_tree.c:6446
 exit_mmap+0x5d3/0xae0 mm/mmap.c:1312
 __mmput+0x12a/0x410 kernel/fork.c:1174
 mmput+0x67/0x80 kernel/fork.c:1197
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x78a/0x2a30 kernel/exit.c:959
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
 __do_sys_exit_group kernel/exit.c:1123 [inline]
 __se_sys_exit_group kernel/exit.c:1121 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888078907400
 which belongs to the cache maple_node of size 256
The buggy address is located 0 bytes inside of
 freed 256-byte region [ffff888078907400, ffff888078907500)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x78906
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88813ff34c80 ffffea0000cd3680 0000000000000005
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88813ff34c80 ffffea0000cd3680 0000000000000005
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000001 ffffea0001e24181 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5699, tgid 5699 (rm), ts 81546835733, free_ts 81543034225
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1e1/0x250 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x111d/0x3140 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x26c/0x2410 mm/page_alloc.c:5240
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab mm/slub.c:3248 [inline]
 new_slab+0x2c4/0x440 mm/slub.c:3302
 ___slab_alloc+0xdb3/0x1cb0 mm/slub.c:4656
 __kmem_cache_alloc_bulk+0x20f/0x700 mm/slub.c:7439
 refill_sheaf mm/slub.c:2650 [inline]
 __prefill_sheaf_pfmemalloc+0x42/0x90 mm/slub.c:5328
 kmem_cache_prefill_sheaf+0x1b7/0x420 mm/slub.c:5422
 mt_get_sheaf lib/maple_tree.c:189 [inline]
 mas_alloc_nodes+0x2c3/0x390 lib/maple_tree.c:1140
 mas_preallocate+0x39c/0xf10 lib/maple_tree.c:5194
 vma_iter_prealloc mm/vma.h:505 [inline]
 vma_link+0x12c/0x750 mm/vma.c:1823
 insert_vm_struct+0xf4/0x2d0 mm/vma.c:3288
 __install_special_mapping mm/mmap.c:1460 [inline]
 _install_special_mapping+0x187/0x3d0 mm/mmap.c:1496
 map_vdso+0x1b0/0x560 arch/x86/entry/vdso/vma.c:168
 arch_setup_additional_pages+0x41/0x60 arch/x86/entry/vdso/vma.c:238
page last free pid 5699 tgid 5699 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0x822/0x1130 mm/page_alloc.c:2973
 __pagetable_free include/linux/mm.h:3197 [inline]
 pagetable_free include/linux/mm.h:3221 [inline]
 pagetable_dtor_free include/linux/mm.h:3325 [inline]
 __pgd_free include/asm-generic/pgalloc.h:303 [inline]
 _pgd_free arch/x86/mm/pgtable.c:319 [inline]
 pgd_free+0x3f4/0x560 arch/x86/mm/pgtable.c:381
 mm_free_pgd kernel/fork.c:585 [inline]
 __mmdrop+0xe5/0x750 kernel/fork.c:727
 mmdrop include/linux/sched/mm.h:55 [inline]
 __mmput+0x379/0x410 kernel/fork.c:1186
 mmput+0x67/0x80 kernel/fork.c:1197
 exec_mmap fs/exec.c:893 [inline]
 begin_new_exec+0x10f0/0x3840 fs/exec.c:1148
 load_elf_binary+0x8f7/0x5110 fs/binfmt_elf.c:1010
 search_binary_handler fs/exec.c:1664 [inline]
 exec_binprm fs/exec.c:1696 [inline]
 bprm_execve fs/exec.c:1748 [inline]
 bprm_execve+0x8fb/0x1620 fs/exec.c:1724
 do_execveat_common.isra.0+0x4a5/0x580 fs/exec.c:1846
 __do_sys_execve fs/exec.c:1930 [inline]
 __se_sys_execve fs/exec.c:1924 [inline]
 __x64_sys_execve+0x93/0xd0 fs/exec.c:1924
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888078907300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888078907380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888078907400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888078907480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888078907500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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

