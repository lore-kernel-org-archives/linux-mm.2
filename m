Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CFECFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 22:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975F86B0008; Sun, 30 Nov 2025 17:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926C56B000A; Sun, 30 Nov 2025 17:29:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83CC46B000C; Sun, 30 Nov 2025 17:29:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8496B0008
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 17:29:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4CC45D8E5
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 22:29:26 +0000 (UTC)
X-FDA: 84168715932.30.50CEF93
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DB5F180009
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 22:29:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3RMUsaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3RMUsaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764541765; a=rsa-sha256;
	cv=none;
	b=iow1fFgLSM5lbbJAmxSMp9ILRsVYsUDaATB3FKsPxwmPVEprncxZQAl6rTVWtoIkFRU85Z
	qGQPBlgt8RH9LFxEVfxa18UumwLJ+VZsqEZNYsxVTa0GWGkjDLnPdCMLC3/mwI86dB+k5J
	lKdXkoEMJa8+jlZ9rRfndj36ZUkDIt0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3RMUsaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3RMUsaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764541765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0tQIxWMwtjUTzNXL2DYXt5WIInwcYueysSs1SBuxJU0=;
	b=2t/ILPRImCwFTx4UUU/ZjQuVXdaFVDoZQZPfxNKb1tR4WqmjOOErmgW752kwnOTnQArhRv
	90kEYOUt6FzqQXMuPI68ouRH0DtP8Be3paisy8EUUbO1AFUoz74LI/1kq+pO88vZzzputs
	AWprck+RUQgeq/aOE1J1SxwIf1/bFo0=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-4337853ffbbso27938985ab.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 14:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764541764; x=1765146564;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0tQIxWMwtjUTzNXL2DYXt5WIInwcYueysSs1SBuxJU0=;
        b=U4ka+nvhl4LiLzxYMKJ65HwDQoNSjoGP3hhz4SQsoAOfeE4iIvzYSMOAd6xQ63dSNe
         9eLhMkFKxheA4pvrLdv1RM/JBCCjCQzuICsWLqEuzWV+0gbYcFnqBcMfvdnDhu7Msbwq
         q8vhvx66QzkpxcjiemfVIS3oVnqB7jKNbl4BJUvh3f8xdsBmRAkN4nvOfhD4nRnEdSB+
         L6JgEiyAFNMpIZI3IxWWzg9jKS9eZ3QZa79b9/JR6gmqu7lKu2i0bNB86+++qC+683Mm
         FRJI7wJyPnsk9uoLXcu1JYd1M8WhD9F5BQQkyQcUaKCLo2OC7mgTWEshu8GsKBaAQLaD
         zB8A==
X-Forwarded-Encrypted: i=1; AJvYcCWm9cR5WYqFhkIKaeeCavBsVLv6B2b03MkdzMBQJ/wDtnbtEJphOjN7e7SoOm1JKNHblsG9g9B3Xg==@kvack.org
X-Gm-Message-State: AOJu0YyDIvMeWoQkvwCadAQMigSQmFp01kTCWBpvOcVbbq+6cDSUUF+e
	2lOXGV5Jl8PW781WvCxF/EvuIjFqnViunLO708CfhcCDcfg5SbgHqtYk77lvTL4fF7qOiyyqFd4
	IC2dxz8d6vZagf5XrjP2tcMd3HPvIurk7t8tl8N63GmrXWogOPtB5VThlS0A=
X-Google-Smtp-Source: AGHT+IErikNbPKmXHbvpIbQKtPgDrIWbcLTKFEEi/LrBAD+5olBi1Fbsg7X7UGjIWphevZAvYI/CUnhPZ2SsFi1B36qP7YSwlYus
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6c:b0:433:7e2f:8393 with SMTP id
 e9e14a558f8ab-435b8e694e0mr262220295ab.27.1764541764205; Sun, 30 Nov 2025
 14:29:24 -0800 (PST)
Date: Sun, 30 Nov 2025 14:29:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692cc544.a70a0220.d98e3.0174.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: slab-use-after-free Read in __list_lru_walk_one (3)
From: syzbot <syzbot+046b605f01802054bff0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0DB5F180009
X-Stat-Signature: x5qonik1s6q1xhojnkz7jaf9g43thp46
X-Rspam-User: 
X-HE-Tag: 1764541764-788745
X-HE-Meta: U2FsdGVkX19DmqcsqfqzmD0VU4qCmXR8WrTPQHYKDKLZNl9taht/2PQPafpN8DVol7VL1ufi/2X9rgJ4ngMG97X96utjde0DyaJKvgTlBOcE3724xZfKJlZZprRukvoJufxvwTF+nn4hM6Wp1FEkz0ez5nAdvrcaJFh0PQGERukMrzmpQ5shMC0RJFchG+RAWr6a9qJixHetsxriZsuetupeT4wy5POh/PlHUqPn576vLrZ1Y56yWPCIuYfSXVvu7KWndSDFw7RjSZcMB77IyURXke9e80ut5MtAheI1/agtrgBysYImAQOe8zT6iKp7649DP/Z/BTNkUjFlgeFVqo01Wbz//xeWTpNMgXXL+Tl4IkT8e61O0TFgPQ4oKdQn3eq1y2dT8oGU6gaV0EqKrgihtHErQpIucZxPK3chp4+iM9JUWL6iCYElbLfWALNBwakhRgG3DvGvqE7XFhh6D3SPq2/lcwQGOSEJuLE1rS9SpSqAN18uC9NQqTiOjWdEZedCoGN1aRdKdAx4Wa+uMd9urlqHUdpT/Y4jnS40B1zlHnT32bMDoRLQcy6esvT7iUpFqV26vgxqsoWcXm+7Tre+6l4O3DnNgpaEfeVFm7zxV7svdCT9y2KBykgDkR8/RhE5ojEpVP3pTb+rmbfrof3hMsp/J9TUgDqlhkcJdLVE7OaJCki4P95eQMKsmiXyZh5RSB9+Ck76JbMzOXH6qfoEow/SyDFL8o1F8JZU+5fvdbA9MvITL4ldbbI50OHkbxOJZcjrJtzHwgmn20KOIqoYMeeATGiDcNQk0t/abm7wcdwahvnCm5dVIoDSa2At2dEojTfh5AML12TElgHUc3otXmL/gDBCa5uZdYuB+kO/h6ti73Rqq07a1robH41h1C4frLgjQ4JhKws3zmhcuL2VTEAlXtRY4Bwiu6DYcZcEnsal3B3FczUTxrsIK9fNynV8JmDPCY7rSy74oCk
 zi1FR5TC
 OTirU95otUJdyPOqf1B66g1Pbi5joSTqZpMc84d8U9Hutr2IS0AvrxGVKYBPr1U3/xKUxtq/u2N+AeywUW5EjLTfnPIpI7lJJRd55LL1J6S3gXqScw1F4CPOYmMcMspqpiXp3P6wWJDc08N4Z1uESvIhg+cgMflPYRsyw8trw2NZ5S29+A80Jsh7FZ2el4TnNT0vRvXdXNClHtcquswJLteuaX3POq/VSl6i+IyvKDqgsMIrIN/fPDmgl8gAwjmz6B+a+OE/6gCbI6ohK0cWbNI7Y6yJOIyTdYgTjaiuTjYT8IMeUrNAEXwZFWJH/LfX/mLsysM2TjGRpHEYdOJyG+dsJWX2cFSkYk2clpNSAVTtYVvYT+Uc4YaXmo+GMSjbojpWzsknp1iqr9fEQhDBAbhQCd0jrbKwImFPlxJX8aPf/FkmTRa2elUtPFxfeVpDVEdUWQ6QIQtdCqCQX4tBeW/kwMIXuEozAYzqnKHjFc756gfBX2VAjnPdyoWla9WJ1lQfi5G9I3LWwpsdMsMBByV5REuWFy63XLpC1EwKIcwqPy7sCLJq6AaDe4RgdKKYFRV58af5ZacezeEwVidZY0GcXT3QhXg6eJulOR1/1KBmb7R3W2DU1K2rBJvEnuYNJNfoJu3cmrNKjEuTKcsXh8zBwyWRuLJVnSCYp7cUnZPSkg3UIt28ErvmpCkFFAUC9M2XHyOV3T5PiHlJ+QI5YyMejlMTtdkiLwrt+F1nR0EPoOC51Jk2qVyd9RVXfIVxGT3Esw2HbEOqZTy50KhTwsbMRcSwp2WVDZKsBLi4cNygZz4mJ7A3ZRxdPhzO5P1L5n3XFpQzDzlmDuvUPcLXY93E/524u/IA4qLidl5CSS2I3V1blka+BnF5mhmDRirdBG5SnQJG5IEMKsA4tUQOAxNohyX+LQReR28lnW7WAHPj96ZQceho3iul1XzMyyL0CkeBJ9XEk14loEACE3jWqAdk+Bd+u
 kunNnr24
 fWGmjXfCNiLoOf+Kq0GGdG/4qxt2aLxg+96RNWHjeXcXIAE94f13edp3rcYu0nlL21a/ZJ86upTl1hXHcr1INsQJjcTHz0RpXJs/TZH1HJ6E03ZNhJdmkWlxf7jXtdwXeVxe2EGm2FpH8t8Viy10tGYZS0nlgwUQJzpuM4vf2wIXhCl4ijK1NVwJM2eQm4ii142a7mVw8WqD3d02XmCoSEAE1buwi8ELKcPlrPne2FOSss2Q1OeA+398rPYjudRDDJY2B7N513/T9ga2HdobjXgk7PZIeD4iyr0za2omMEWmdnPEk3r8O4HK9inC/9moPGlq5dPbpA9euPRSOQW2sMohMyVgyfgP695tpaB+Q7mZ3u2ydEW8JfpkTzFZdOaPKKrp9yWLJ+Alr+zQS0KkxnQBQhc4FOpRq8tSXWMo8nc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    e5f0a698b34e Linux 6.17
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1120c334580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=046b605f01802054bff0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e5f0a698.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c024c1509688/vmlinux-e5f0a698.xz
kernel image: https://storage.googleapis.com/syzbot-assets/28d9bfec58a3/bzImage-e5f0a698.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+046b605f01802054bff0@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
gfs2: fsid=syz:syz: Trying to join cluster "lock_nolock", "syz:syz"
gfs2: fsid=syz:syz: Now mounting FS (format 1801)...
gfs2: fsid=syz:syz.0: journal 0 mapped with 3 extents in 0ms
gfs2: fsid=syz:syz.0: first mount done, others may mount
gfs2: fsid=syz:syz.0: found 1 quota changes
loop0: detected capacity change from 32768 to 64
syz.0.0: attempt to access beyond end of device
loop0: rw=12288, sector=18720, nr_sectors = 8 limit=64
capability: warning: `syz.0.0' uses deprecated v2 capabilities in a way that may be insecure
syz.0.0: attempt to access beyond end of device
loop0: rw=12288, sector=18720, nr_sectors = 8 limit=64
==================================================================
BUG: KASAN: slab-use-after-free in __list_lru_walk_one+0xfb/0x420 mm/list_lru.c:293
Read of size 8 at addr ffff88804450d078 by task syz.0.0/5360

CPU: 0 UID: 0 PID: 5360 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __list_lru_walk_one+0xfb/0x420 mm/list_lru.c:293
 list_lru_walk_one+0x3c/0x50 mm/list_lru.c:341
 list_lru_shrink_walk include/linux/list_lru.h:262 [inline]
 gfs2_qd_shrink_scan+0x155/0x330 fs/gfs2/quota.c:182
 do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
 shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
 drop_slab_node mm/vmscan.c:441 [inline]
 drop_slab+0x14e/0x290 mm/vmscan.c:459
 drop_caches_sysctl_handler+0xc7/0x170 fs/drop_caches.c:68
 proc_sys_call_handler+0x509/0x7c0 fs/proc/proc_sysctl.c:600
 do_iter_readv_writev+0x61c/0x8b0 fs/read_write.c:-1
 vfs_writev+0x31a/0x960 fs/read_write.c:1057
 do_writev+0x14d/0x2d0 fs/read_write.c:1103
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2be338eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2be42bd038 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007f2be35e5fa0 RCX: 00007f2be338eec9
RDX: 0000000000000001 RSI: 00002000000000c0 RDI: 0000000000000007
RBP: 00007f2be3411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2be35e6038 R14: 00007f2be35e5fa0 R15: 00007ffed4696f48
 </TASK>

Allocated by task 5360:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:330 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:356
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4191 [inline]
 slab_alloc_node mm/slub.c:4240 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4247
 qd_alloc+0x50/0x250 fs/gfs2/quota.c:234
 gfs2_quota_init+0x777/0x1230 fs/gfs2/quota.c:1448
 gfs2_make_fs_rw+0x181/0x2b0 fs/gfs2/super.c:149
 gfs2_fill_super+0x1a7b/0x20d0 fs/gfs2/ops_fstype.c:1278
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1335
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5360:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2422 [inline]
 slab_free mm/slub.c:4695 [inline]
 kmem_cache_free+0x18f/0x400 mm/slub.c:4797
 gfs2_qd_dealloc+0x70/0xe0 fs/gfs2/quota.c:111
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xca8/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
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
 gfs2_quota_sync+0x3c4/0x460 fs/gfs2/quota.c:1361
 gfs2_sync_fs+0x4c/0xb0 fs/gfs2/super.c:658
 sync_filesystem+0xee/0x230 fs/sync.c:56
 gfs2_reconfigure+0xbb/0xb20 fs/gfs2/ops_fstype.c:1555
 reconfigure_super+0x224/0x890 fs/super.c:1077
 vfs_cmd_reconfigure fs/fsopen.c:262 [inline]
 vfs_fsconfig_locked+0x171/0x320 fs/fsopen.c:291
 __do_sys_fsconfig fs/fsopen.c:467 [inline]
 __se_sys_fsconfig+0x78e/0x8d0 fs/fsopen.c:344
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88804450d000
 which belongs to the cache gfs2_quotad of size 272
The buggy address is located 120 bytes inside of
 freed 272-byte region [ffff88804450d000, ffff88804450d110)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4450d
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff8880326ed000 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Reclaimable, gfp_mask 0x52c50(GFP_NOFS|__GFP_RECLAIMABLE|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5360, tgid 5359 (syz.0.0), ts 76532803072, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2492 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2660
 new_slab mm/slub.c:2714 [inline]
 ___slab_alloc+0xbeb/0x1420 mm/slub.c:3901
 __slab_alloc mm/slub.c:3992 [inline]
 __slab_alloc_node mm/slub.c:4067 [inline]
 slab_alloc_node mm/slub.c:4228 [inline]
 kmem_cache_alloc_noprof+0x283/0x3c0 mm/slub.c:4247
 qd_alloc+0x50/0x250 fs/gfs2/quota.c:234
 gfs2_quota_init+0x777/0x1230 fs/gfs2/quota.c:1448
 gfs2_make_fs_rw+0x181/0x2b0 fs/gfs2/super.c:149
 gfs2_fill_super+0x1a7b/0x20d0 fs/gfs2/ops_fstype.c:1278
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1335
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88804450cf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88804450cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88804450d000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff88804450d080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804450d100: fb fb fc fc fc fc fc fc fc fc fa fb fb fb fb fb
==================================================================


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

