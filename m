Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21968C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 22:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026746B008A; Wed, 19 Aug 2026 18:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F409D6B008C; Wed, 19 Aug 2026 18:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55C86B0092; Wed, 19 Aug 2026 18:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD3AA6B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:49:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4D1780393
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:49:44 +0000 (UTC)
X-FDA: 85119512688.07.C364942
Received: from mail-oi2-f10.google.com (mail-oi2-f10.google.com [74.125.231.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50A16C000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:49:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3BjOGagkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=3BjOGagkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787179783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=RCqoDLhjf0Dkjduz7a0RBFwdjE6QzDXkzBRoNUdCo+U=;
	b=kqkD/9Rpi5pORYF0s7wdnoQf0JdUWZHxUzAKnvOx+ybCQ86n02UQucOVLLCmwYRQObNOxn
	1r6v+M3Kk4vnt1VnKHQLMwgp+Se7A08zY1EVH8z/wuJYseTOkW/FLmXqFkefPvs483YHXB
	6mm6+FALXlv1UCy+1Lsk86YNgk1dY/M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3BjOGagkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=3BjOGagkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787179783;
	b=GTJRGFcwH+6ZudMroQAJW94AVS2EmWK+g4UfnZtIx4nBU/a+GmahTEw2/NJgtWl1LQ/Y3y
	Q8kLKA8Sxuc0JezsKEq58FpW0SBdYyh6QGZKTiNioLesICHth/ySfjD4gpDFnasimV2CWU
	b8bXExiDOwPoxk8y+OXGjYjKA/I/1lM=
Received: by mail-oi2-f10.google.com with SMTP id 006d021491bc7-6b13752e134so411754eaf.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:49:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787179782; x=1787784582;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RCqoDLhjf0Dkjduz7a0RBFwdjE6QzDXkzBRoNUdCo+U=;
        b=r54UEyP5X7xMIlsmqZghB61F3bLc8Ljtsl7Ij9YfyHnEOQbgEvKkjfSXIPhSgggN3r
         VwJR1FXmuqREXHr2RmTOMztSrcTNipBw/KQnveDRMQBgXYo8/iuBnc9V/511QYKea29Z
         qrG7W8Lzs1Se29YGAqK6heXmwEc0odVQobXQFCIxyPRS2uzQ3ccmoYqRgEjZTESS1Ye2
         AnOfULaQFzJlW6n1Z0BZjM3LucudsgNAAJPCIBxZiDBt3PWqvdpWPX4X4bmr9dTOjjd7
         rFfYiPevCb4pc1kD2YCy2ml67XcgMbvJHAO6YSz8MyO55Kf1KnTs8mVLEDZikBkN7zpw
         s63g==
X-Forwarded-Encrypted: i=1; AHgh+Rrd4CVXajvVvVHw8tXpPUWYOp8I0HJ7KfyKPg5oZzf2iI+UrmF9We7o8Oc6dt+x2IokaTPXVLhVwA==@kvack.org
X-Gm-Message-State: AOJu0Yz+juzlBLobiFud1z8AemoS1SBLo/IPzXfbJHQeR3sqVxXNml+z
	h07piAPLZ/2IbWiLGfpBlmO3zbELsinz5IdTwFA+quFtnvk8u2AubVb9GCMnxkyuj+pozlZjCpb
	Sv4nhcX5LAiEBeEHykv6houJTBPVmeAyGFR79oL4lmfIKAj3wn53tgijG3zM=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6aca:b0:6a3:a335:1ccd with SMTP id
 006d021491bc7-6b13c35fcb9mr8149031eaf.8.1787179782340; Wed, 19 Aug 2026
 15:49:42 -0700 (PDT)
Date: Wed, 19 Aug 2026 15:49:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a863306.ae6ddae5.3da009.0013.GAE@google.com>
Subject: [syzbot] [mm?] [gfs2?] WARNING in read_rindex_entry
From: syzbot <syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gfs2@lists.linux.dev, gourry@gourry.net, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50A16C000A
X-Stat-Signature: 8mbigtb7dfa4fm3w7r7gsu39859bhrum
X-Rspam-User: 
X-HE-Tag: 1787179783-276888
X-HE-Meta: U2FsdGVkX19RFfGh87akBibpaaQJQnK9zl+i3sZYy92qxIeZIuHW1j7Xqfseqy6l9AoCjrn2slGHvVrI0GT6Lcng/jajmk5gAxZQfsXQezmlas1ZquNQQY3fzdrby3EMeln0+NQTe41T61vILQgCJSue4ST4dTRsWer3nDtWrOCXEZiyBVrwJCTk6SoyI6uTmWpGIr5JANd5h5aWsRNblYedVJjhlx5vGc+M+e3TPgHIzMlKGfzRskRCxXi7aZuQ8qA1NJQLJGpRHM3/LxvMwFLJ0i5G6iO42sSqRDSBvWEj2sY8QaXVGVbbUlUN0mhjxaDizXkqJljVlV0vIJqmPXgq8vvth25DXV81kzf5eJIjSVzPeCdPZSQjWeh4Elwz2L+UBj09cbc3GG/thPpYUbaWs0qwIwB8QONqmqsMQR5ibNu5s8Urwyrg55fpKGqDXPxIUBEUTr7JkAPfQGHlneL7slrDGbH2tw1UvetBvZYuQp7Z+ZY4elwN7iVifZfDiH9mvf3MEB4s146jX1kNExnZoLbrItI/9Wjhxeh2fpdsMufG0uKyjV26HlEZXadS7O/fwyD3SwP/eXTqXQqg/zDwTe9trLDAyyGUz/NgiAP9qXmDgUsFiJVLp8ys4Y4w+jnHiPhmmlff3zeg0Kxc9KaQoOt0JZO5Pz2oLSysH4jHrgd0aA0/GlEnbkOLm6BsXDHFibqecxnCdDBlUEuiV5S94SF9ccIqlaR9WR7BxAvzKSxMpcvRhLf2Ek/gBiq/yxlmw6IXsMN8gi6IInVbXzKGiKUmdraDNE3gZQRjzlA0XNR4HrhOr3DGn2hFSK7ykQRdlclC5Y0wENhIEBRfV6Qj0owsnW1QXfQmiKX8nJ4Fh+gT0uGIqTBC8tSvkyis8VQ6WGwT7bt1iQPqFc59CMf4LXHUluRn7tbWB2xZxW2m1/OdFiAoFobcW8GLS5FvMox/mCgolsSBAU+iIC5
 x+NYQiUl
 F1H5KuCqUtbmbNI8owb3iLYX2puaj7wtMbkXpm/SnfZXGhr8ZIkUAh9/B+gs4G5xz8vVT5zJLdjQU815QE1FuO/P46DnQhXyHaVqwaAYXBcgvVrl8sFN0VEPJ/+iHiSMeef65LsPX6evWKU2Vj+6R4ZG18Kqkom6nwLuXerjXqO0SEiJx8LzJ41/LT97jgjv+FDmd/wOipbzrtPAJ5ae2bB5HvXYVld3GTOAbzRjX4XUhljslBIwsryLpaM7jgluo/oGOc0FZ6r/Lpuw7Wa/iuymOYNU2qEJXaIT0wx8NrFS1knM/21jUCYXb/1zzzC/rrM+6FjY2FErHiAEmGW7j0oQvXZI50pyutTfPsIMAmMHZ2fAVbveQ9wqNHI84ElSLfw8UcVMidp23w9n76rQrngHNagKdLRF6c8tyZqwvYZWUaqmxrQ2a+x1kZJmU+v8vwh5H32Z0avHnR+XcOdOXrV0F6y7jmSVYpmA1W6wuzffjxJzivOIs4kRS9dvF6D+bR2pF1kuPWX1AjW8MvG3phzuAaj9WSPytoTXqhm58Adf9z343che7QPaV7eBFBTJ8+T3Qn6fD4lFPLoRKyXbY5BXRqoSffRgZeMYNWH8qB15yTr55dO52ZJ+9mgKBf4xc83U4042fT3S/UZM22s1Xzsg1ElFPGqDtRONzMqZwLtr4o/KUMtRBdb4MFWwS8e+R3znzJNRXKldzf2vXfXr/NmPf4gJagNAxs3jodzSOntX2pgQZLUx70ibwS5YTQpIstol7Rv6yE0KplX0kwOrdWkRaQJ7DYQKB+N0hTe/mH6wDHth5TTOFHXrMDsnArtmzxF3bHkKGfInT4viYDvfMYbV7QCs+2PdrMwkfQ9uFsGg5IUYupl6icz7v8gQInvxy3Ommz4dzFngGcXhGurDoe53csxlfdpbqxReRQ3jGC6IP6y+oK0TZrB5bqlpBj1RAAUlJr/tYHPmSvpDeXZZhPLj7QXnm
 hSsu/YdP
 kToJ6RVi/ucJ4g1k+dw4v5UrV8QLdxcKn22fkezpIheBIsI0r6gO7VntiQAGoYEq3Da3rCLo2vZKYcFKGKLQAmQAe7Nq3j8iW9LAwsd9Mcmf1zmWKiw3IT4AvVp79Ov+m21t7AvAyoeuM4SUxB5KQhIPq6WgY2z1QrKkBlzHzepxp5j9R2Hs5hRU7zveH82ePptIy6R5zQk876zwjT4MnnH11h06epDv93kfcSZHbRfWf5p9Q0yB4utwDe4nAdIvPWR5vugRpIgOWVFckh2XLY9v4m5QewcDTLHVjiVE9zHPNhH6P1yx30aNXBH6xSTaQfL3gfvycIXRE8WQgSq3hQTrlLg9iOizZYa8frpgSE60kKfxYHI0RxYsZ2eMM/RyvJ2JgPl+vdaHKxUlmPOxSrUlnPcvtIe3uaBXvdvkzu1woaaGURHsZBA1GlL2UFV52oyF33Dfr9OqgnPEZ+6K4SHeg7l9RweTvMKTKP3Xesga26YHEAOYDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    15ef2f78c49d Merge tag 'input-for-v7.2-rc7' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10871279580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0fdc3b566746377
dashboard link: https://syzkaller.appspot.com/bug?extid=9d20c3ad7d29227de28d
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14871279580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100d2a25580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c2a8c7d3a889/disk-15ef2f78.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2da78afed345/vmlinux-15ef2f78.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c4ffd97e4708/bzImage-15ef2f78.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/eaa4120812b6/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=17f52a25580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com

gfs2: fsid=.: Now mounting FS (format 1801)...
gfs2: fsid=..0: journal 0 mapped with 18 extents in 0ms
gfs2: fsid=..0: first mount done, others may mount
------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2427/0x2dc0 mm/page_alloc.c:5280, CPU#1: syz-executor256/5629
Modules linked in:
CPU: 1 UID: 0 PID: 5629 Comm: syz-executor256 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:__alloc_frozen_pages_noprof+0x2427/0x2dc0 mm/page_alloc.c:5280
Code: e9 8d fb ff ff 31 d2 be 28 12 00 00 48 c7 c7 a0 64 e1 8b e8 5b 8c 69 ff 2e 2e 2e 31 c0 e9 02 ed ff ff c6 05 54 c1 9d 0e 01 90 <0f> 0b 90 e9 6f df ff ff 48 c7 c7 80 ae d3 8e 45 89 f7 44 8b 74 24
RSP: 0018:ffffc9000345f0e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffff9200068be36 RDI: 0000000000040d40
RBP: 000000000000000b R08: 0000000000000005 R09: 0000000000000009
R10: 000000000000000b R11: 0000000000000000 R12: 0000000000040d40
R13: 1ffff9200068be74 R14: ffffffff9b759444 R15: 0000000000000001
FS:  000055556d263400(0000) GS:ffff888123ee1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055886dbe9978 CR3: 000000003394d000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
 ___kmalloc_large_node+0xe5/0x120 mm/slub.c:5274
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5305
 __do_kmalloc_node mm/slub.c:5322 [inline]
 __kmalloc_noprof+0x5a1/0x820 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 _kzalloc_noprof include/linux/slab.h:1309 [inline]
 compute_bitstructs fs/gfs2/rgrp.c:766 [inline]
 read_rindex_entry+0x4a1/0x1250 fs/gfs2/rgrp.c:931
 gfs2_ri_update+0x6f/0x3b0 fs/gfs2/rgrp.c:1001
 gfs2_rindex_update+0x40b/0x480 fs/gfs2/rgrp.c:1051
 init_inodes+0x1f78/0x2790 fs/gfs2/ops_fstype.c:872
 gfs2_fill_super+0x1d3d/0x2cf0 fs/gfs2/ops_fstype.c:1250
 get_tree_bdev_flags+0x38c/0x620 fs/super.c:1640
 gfs2_get_tree+0x4e/0x280 fs/gfs2/ops_fstype.c:1332
 vfs_get_tree+0x92/0x320 fs/super.c:1700
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3765 [inline]
 do_new_mount fs/namespace.c:3841 [inline]
 path_mount+0x7d0/0x23d0 fs/namespace.c:4161
 do_mount fs/namespace.c:4174 [inline]
 __do_sys_mount fs/namespace.c:4390 [inline]
 __se_sys_mount fs/namespace.c:4367 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff9e8de99ea
Code: 56 53 b8 9d 00 00 00 0f 05 83 f8 ea 75 a2 c7 05 a4 30 0a 00 00 00 00 00 eb 96 e8 51 05 00 00 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc770eecc8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc770eece0 RCX: 00007ff9e8de99ea
RDX: 0000200000000040 RSI: 0000200000000100 RDI: 00007ffc770eece0
RBP: 0000200000000100 R08: 00007ffc770eed20 R09: 0000000000000000
R10: 0000000000008cd3 R11: 0000000000000246 R12: 0000200000000040
R13: 0000000000000004 R14: 0000000000000003 R15: 00007ffc770eed20
 </TASK>


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

