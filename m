Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B26BFF60D9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDBD6B008C; Tue, 31 Mar 2026 03:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4C46B0098; Tue, 31 Mar 2026 03:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5023B6B0099; Tue, 31 Mar 2026 03:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DAE96B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:42:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEB465C6C9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:42:05 +0000 (UTC)
X-FDA: 84605564610.22.7DD82A6
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id 343C1100008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:42:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3y3rLaQkbAEQy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3y3rLaQkbAEQy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942924; a=rsa-sha256;
	cv=none;
	b=DAMkm8taASFCQ0l2Fc8RdplKpnSWdI0+ov2VY40BoUduZhGkZBJ8+jOUXjUwwPD51i63d2
	E3jF8v20xj99cPH0Pt4ADDnYzY/pbxGb1LFPB6GlHNad3WEpFSrgaSTVoupnmJVt7lYlsY
	8Eb/LdymoFWA1x2dmlU052qqrorepv4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=kW/SphJaHT/+6fQIuBd3Wr/1eFRaQ4h0O20BveCN4m4=;
	b=wUN24uAWIAPE3s9riEFsPFbusx6L+vPIrLxQCzBO3Pq4qiE0/5UrBbnygpG7tXvyF2QrhT
	lYeIgvL8FFdj/ul61itASUsnKqokQZQslH7Yjk4rZEw3gzUlhsMicKKKrwKwlqFrJtFA7K
	ELdRJCm4YEGmi9aAoKnbi4RVBqBsaJ4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3y3rLaQkbAEQy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3y3rLaQkbAEQy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67deade993dso20437912eaf.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942923; x=1775547723;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kW/SphJaHT/+6fQIuBd3Wr/1eFRaQ4h0O20BveCN4m4=;
        b=LUV9dinvUMeQHhWKgya+5+arjfgItId38JrGkzl6nPZBviF001pAPrqov3zIY732HV
         EZMb5YYFChg4+myBInWzD5RD1NJLT/qeMMngBJTjSA+F7q2Xr99ElWQRsphwl7pGc8sg
         QSfidfKZY6LJKil7mepX8f6UQI2h4AgCpbaXt0je8Qab/uxWAqQXz4EljS1norLllVqZ
         4IQNjhGm3pAphrt5G4XC03I1n8E1IwjA1MTvfw8iw0Hm7UJ2S43NxzyMXXoGB9lebP1n
         GipK+hr11CRioqjiCBkytA9u6eW0OANo25taS0NYBq7kXSBMdhyU+OE7n6GgdQOUaE9n
         0cOA==
X-Forwarded-Encrypted: i=1; AJvYcCVSMdrVhZmbzxwIhU4HCwYo0YQK9uyD2n4SvE1nSTdYO+zL5Wt5VctivHXe7RXbXHZPQUj9/bA+zQ==@kvack.org
X-Gm-Message-State: AOJu0Yye+wSrss5T8KAdoICnN+ljTOiFMm1ZeWWx5qsA6Y88adf/ruKW
	N4T2b/M5LaCEG9sPwObIyiQwLyJAJqti7fQFaryy4N/KCeIpdb+tKa0wpNwutUGbaLjFQ3OGHRA
	rmDtzez4KV3uM3J7+itW0y6OBw9Rj+5oKkOL+s+J45rihUUx5auiP4Bxvmic=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:629:b0:67e:15c2:9d85 with SMTP id
 006d021491bc7-67e186330f1mr8627582eaf.21.1774942923216; Tue, 31 Mar 2026
 00:42:03 -0700 (PDT)
Date: Tue, 31 Mar 2026 00:42:03 -0700
In-Reply-To: <20260330175824.2777270-1-urezki@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cb7acb.050a0220.183828.0025.GAE@google.com>
Subject: [syzbot ci] Re: mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
From: syzbot ci <syzbot+ci3c65cfe4c9a15aea@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bhe@redhat.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lirongqing@baidu.com, urezki@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 343C1100008
X-Stat-Signature: zzdx3c6tq1789cm1zy4hbxoqejmrwkuc
X-HE-Tag: 1774942923-812608
X-HE-Meta: U2FsdGVkX18pzc1mf+Hyh5AACwTxTtf/zV0aXItqvBXJ6wlW6+imKeJMPmrVTv++1gs3stMw0i6wFLblfZnHDuzOfzlbZLJV56VjIOYGweHEAbJtd+OOrWm90P1eVUUvMt296igGS1N3TR16paxOeBndUqpG9Ha5RorIQVgRiXwzuyIVT4d0q4iqQWX1gnp+fQi4qKb2qiXc2x4sxq0Wly33kCIb1y86uxE3ZQk6V4jo0YO0apPDbYHJixav5QfY+XE9BfqaX0qEJ2I+NwIUZx+HlrDDjrD1KvEWIONMmEkk0eb1y1B66C/csfbat1nzsXiV++nnDxDMUYItVcJhUfrCaYXrxfi7V1X9AJMJr5qwr0ppuRQFGcy3ze2Fb8N/vQiQD6cVMJQm6UP5VK0ifeSN+1N0gNTfPKjH+bmLz5SY3ZfXj5F2rt7eQelMvjXyhPE8aKWFbswdE0cEX88OwgCdIZSlICsA8VydHb5gAaZfdwgDJJvBCm0/Y3T8LzM/Xqqa68ymR8o0OE8KUAeWKR56ybLH3Pz2p23BhShe1HGMkxJWZkq73tnVCHsrKuXMELGi67TFH72XoEt6KctTXsN9xqdMH0lZa+/BAdVQHJsuxmyUJHQPOOzX7I2WU+iZag4TAqIuaDQU7vNKvTeLntWl1zlMKMjBZQZEpqCinhBWpxUJ59e1ZK/txYwLIExPcG/whS5Ago551lfWOHpdM9qLlYmPv7tcDhI1ndCxs1sC/Tx7Gw3GyyCkC0xWhP1zqDhsjNntmmXNFZeDtrrE7Pup8S8YBCNrOWuy2t7I1BRmrZEfHoyuICZOuyr8DO3Y9lsMzjIEjJSJ0ajIX3jcahVyqy0MIFasT+gTkmj1pV1rolf5DVUYuRj+F5nUDTMRbIlyhXwEz1+PKjBeTSvyfQPjQnxFJZ44dowh9GyWzvhPuT33DIAvwbsMO2lfd3oYVxQsA3H83uSTcq1a485
 uyNgH0KK
 Z7Jt+8tOLdXgNxjt4D20DG9R+BcK4igUSoP3leMwUX8u0TrFgQmR8RWnbz0ZgoTeAbhaa4cQhOy97zguo5aplH7iGdZJoYiM6Yi26s49+LRn2Uh6GhHlOJmgWC/13QcvpOMzxSAePrAnJCOFMcsix+AtR9SqozaT55fBYWj8yRMfktFMCezjIkVwPOjn+yR/SdfjO6LOHXaOsIpXM22IRLCvIFIr3uO3AlxA0de0iIAG3sUJxKY8egiRGlsNEAMkZCkPbanhB/0g9G7dn3MsSjpUpK2G9U3hwzgBOWFroIRbejZ7fK09rD56bHMELcnHwkca4hcl08vuTck8/E5bfi691HFbh3994R81kSUNid1npt0Fbo6/XkSsdvKSxQF69N97HinVMSrjxTucTgEsej3Nn4P5yxlUWEl+uwUIQpCAZiujbFxTCdYqyNPMrHzFGr3a0IgdaQjNU5Ov4ya9wKfZR6F0cjwsffO0QfuUgg5WhvzgF4pyGHP1+0YqwePHq6eRaIfkAg9+sj0jUVjxy8w/CmZ9Toc77W/0nZEMJTVx+BeA6Ta3HoQhirP/Ui/s2wI+krPh064CUR8kocHSqnaDVnVJG6N3jWasTNfttxwrivULQ7+cuJKcreKIjbkamHdEk9IS8PBlU7mDLTs4O5Wx/gK7ojZXntkrXqzPi/AAJQ2f4CGc59VVWzjoH+hArihUEdyuPgokq+t1bHmwqcaYehQdH3Fvj6psDs06jDS6yW3Z6FPjjb7lLt4g5tysI1FqLMX40k5k4uZnDbnQt9Nf3B8p1HcFqZ6nEJ9CXlevcBKkjsGu/2qhpRE04J1U/Kx6viSgc7IYk8kBax1uY4WYnSPbGJ4GeHkUgBGi4MhBgbcp238XakUtRxfvjWgdnFaf2WB3i1C8lPOmMnZi7MGfRAzMG01wH/No61KgZDv3MXVfmVxLRw3FFRRCD+7ENbGpjxhKgY1by/2n9AE9wilevXiBE
 V9Dd3LG+
 BTmjjyELd9g8+XOblPSf980CTvdzc1mJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
https://lore.kernel.org/all/20260330175824.2777270-1-urezki@gmail.com
* [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain

and found the following issue:
possible deadlock in touch_wq_lockdep_map

Full report is available here:
https://ci.syzbot.org/series/4a8f638e-3a3f-4346-8189-2b5a0eb9ceaf

***

possible deadlock in touch_wq_lockdep_map

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      af42d6d3650b95295a3f08fc35189998bc26c2e1
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d94b1f61-6a69-4415-b385-b3c99018e8c2/config
syz repro: https://ci.syzbot.org/findings/01e4d436-e924-4ce6-8902-78c6000bf34e/syz_repro

============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
kworker/u9:1/33 is trying to acquire lock:
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: touch_wq_lockdep_map+0xb5/0x180 kernel/workqueue.c:3991

but task is already holding lock:
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((wq_completion)vmap_drain);
  lock((wq_completion)vmap_drain);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by kworker/u9:1/33:
 #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
 #2: ffffffff8e87ed68 (vmap_purge_lock){+.+.}-{4:4}, at: drain_vmap_area_work+0x17/0x40 mm/vmalloc.c:2443
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: start_flush_work kernel/workqueue.c:4234 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: __flush_work+0x100/0xc50 kernel/workqueue.c:4292

stack backtrace:
CPU: 1 UID: 0 PID: 33 Comm: kworker/u9:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: vmap_drain drain_vmap_area_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:3991
 start_flush_work kernel/workqueue.c:4272 [inline]
 __flush_work+0x87c/0xc50 kernel/workqueue.c:4292
 __purge_vmap_area_lazy+0x7db/0xab0 mm/vmalloc.c:2419
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2444
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

