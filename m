Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF8FCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 21:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7718E0151; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0079900026; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA14C8E0196; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1F78E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E98F3B6D12
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:56:37 +0000 (UTC)
X-FDA: 83769465234.17.A4CDCC4
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B44F120011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:56:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755035796; a=rsa-sha256;
	cv=none;
	b=SghA7gF2N6hmUEsWTT25uCVGK123hALXXLGG9Q/khWxg2Y0BZBRQkDM83FYvfAN8UIWbBL
	qBXfEwvNDSnRQLS1qo8BZ5rwED+IeSMZkoXgVvhwXfr2X7ej6wq+H01O268CfovXrHrh0L
	V2LS9tJq5p66K2RWFtPvT9pz/KpQ5GU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755035796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=s948BEEvRcc/uArh6KDeaDqAh8A68ZPiEwhKz7MmlQ4=;
	b=bQgaY/aWnx5UKeIuvKV2kRr7Q0JUmVicGAASnQ/cJQN/Jy1kh4DJcpxSip4XCHx1XToWCi
	jltW8E57jabCZgu0RBmdgnwzhBkA3CctTGCHwYNP33a6d5oIrpFzCm+mfXGvXGfJ/Rr4MJ
	2MMR3ypbcVimc1b1YJhyB49vWmCvABY=
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-88178b5ce20so1206520539f.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755035795; x=1755640595;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s948BEEvRcc/uArh6KDeaDqAh8A68ZPiEwhKz7MmlQ4=;
        b=Lh7h7Mb3nr8WOokDuUpQkFwlCVheMuk7R8u4aHxHVXoyBxcc6LSKh6Ue/v45K+YUGC
         LW7gT22kkU08BgRNtqWr97+PghrOT0A8+ADfivV/KTxosk2ne5FnKUbKix9QckKIi7cr
         xMAk7Ou9B7F7XPX0VasER7hJAcYE3fZG+I5J9nwv08BpHf0eUtGFpJOkXJjYXPcVt7Mb
         ngmOMq48jXOoFL+6wlIfLjhJzGiV5ZIzHi8XsEdxwbtVBRTZ4dDbCZPRY6K0Xg/osjgP
         NKPZORs1z6+rQdZYHkgNETjOWprPtrZmTcaf/E/4qmVrxOnVtz+Tgg3/6CnsNMVWipqP
         VEYg==
X-Forwarded-Encrypted: i=1; AJvYcCUsK50arBQYji17HWWhYZwiRzdrkuGbLYCeSyk1/HG6goQ1DgtajBUkudhI+GN0JDw5uRCcUpztWg==@kvack.org
X-Gm-Message-State: AOJu0YzKpMB/AzOEBXYiAwRtswVv9CQysS4N9cKg1u54wQkMI3rHPb7S
	zma7u/4jZOQREl7KHDCCnsIeoV937VXCZyrD2FF9nvO+kQGNts2ZpuJd71I3cTNorhqn+omi6f1
	kyXK2A7mPnvIgj2/psBavuoiNMcPYf4ir9owzR5bGjT34DSbFxtqWHw7pQdM=
X-Google-Smtp-Source: AGHT+IGKRhGHEcoOe7azehPWKa/W0V5pGAhIBJ65HDvvFACzwf6m1h82XEXRxgPfULCYJ+PS/kEbQSqCAZaHeZAcG1WRYUk33JFf
MIME-Version: 1.0
X-Received: by 2002:a6b:e709:0:b0:873:1c2d:18e7 with SMTP id
 ca18e2360f4ac-88429689784mr108620539f.10.1755035795654; Tue, 12 Aug 2025
 14:56:35 -0700 (PDT)
Date: Tue, 12 Aug 2025 14:56:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689bb893.050a0220.7f033.013b.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in alloc_frozen_pages_noprof
From: syzbot <syzbot+3f9768ec54c86997ddfb@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4ap36mmbj6935ji1esfmium74pitbpx1
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B44F120011
X-Rspamd-Server: rspam02
X-HE-Tag: 1755035796-186321
X-HE-Meta: U2FsdGVkX1/zlm7SLJb2cBkwo6G+CpwZwnOLwO7/9uzpkJU9t9ik6sWVE7plLG2iJo/l8bsvKb2CWE+iBpJQ9MNsxgzwlzb9re4d0gUQ6Srbugo8gBe/0CGivf2LOUy3kRIBpkqqUg+8C2/5zKyXsABjqlHQQJnkPPPs4H3XghZI0jxxGUcOfLVwjswegOc0m6d1GeTbB5oO/d47/KpdFJb05GjcHCPs9tLFZufmgoKUbopqDQkUzzejIcHSZFDYC2JzPP98C5EEXYgvnpd47iNsj0YcHtYuX+BP6awHFHsg3N0Xacx/rTTxBr1RAYX74e+vcrRNG8cRyf3ih2qlNzOfFuGbzx+O784hVrAHE/CrDp1r0jVdTVX706JRb+8qiOBOVV5r7Bnx+x0hAYFLsloU2YmZwwA0LBV8JsBhHmJ3C1f4yNAN5MoUG2pX5zIQpAY5Aw2iVGvFIwl9Ucx50vRmSXfGp+eRQ+xKLZr0/qxZQEgAT9h6lz+paQMVyW3hFdfnyewdo31r5EMHUi+mA/FZsYGiJ7hig6ZKOtwsKT4djGh8XpCg/tC9cSoAhkhwF2kSHLIJNEvbMVTp6MI0at4ukEcI8vwth46PaP2VW90NLm2QMUiPK2RSzT3UrzVP9HFzQUv2OnZQNKVoHNf7T2eLPdThDLMHtNoph9YQPT35wRIwyX+yDqOoK3btCh5UhTPYJDKb2AFyG35mqlX11thm2QZezCVwHFGXdUTeCm5/SsjIwPkL50WzTCHyaYpAAt9LK25LehbApbapb+CRIhDiEDzxhEERE3OPpvl1XWvuepo58emksq/3quySd1HMEHbu00y4bjUMhcMtA3rqUQaRHn0lscNe4LMC+i66xUlBuOLuCK4xVI5F4x2awXvknuB8mq8cB0ebTy4oWLIV+24+MSGi90pimIjI0+x6Uj7d74DIBR8QS9iPJUqztjUgOscWsosXfizOA9zjmK2
 /UV8Ia6o
 2+7KxwufXeUqji2wulqY9vXcX7sXrDUTWKt69ubbDVQ85YpbWg/6FO3EEf/aFAgZkUdSJFWmkTNKp8Hz6NtIMLh8eUfvGYpxvjlgjKonDdpjAdqTB2005zPL48HIkoZ2YbY33GmGdv+b0vrSW81z1FUMFuG5hoCYLVgk0NrmGZcX2C0nCUyBN8f5pK/r/VKCTLHJpcsWKgY2Cq9uQ2JcgD5pxyZCAOzx/sjpdCC6HsCFdfKLg+Ro/juanzaZQQcCPvxO7EcIvTrZ+Dx3yzxUQjQAm3B9HR6Vrn9KdKWs2g/R3fOckGn2RMstaU4oN1owmDiPsS2DvyEmUvhIw1d0dg7BmhWxio/mkt56Pt8PhqdA6eXXZQmzIPYWTNkd+0VbL2F50+2vSn6s3NkgZ8EnGTi2MzmVeS2zzlKZbei+O2hyMxkOyc3Mnny5XDr+RlJ3+v2BU6cZpGpE9Ue7ziMuHku1aJnK7ED8o84EEA7XIlJEPZyEVd8MIdTLsxZ0cu7azNOnQCh+swrW6fzUXOQ4NmJ+FDx9VgJ9Yw8CYXhibXAARZmc1LIePu0c1rDeacFfX0nCpr5SZTBPdXX3jPerRhzW5cXmhvCqzlm1CXi41uFc8RMBpUcDlkJL5Z8MHi16x03ViyqD9/QegiPFKFIP0RpGf4fOTuaLdNc7tFdYfv+NHCfyTtKABqYcU6IzP85vRmTj0YWbMBR+CItdhXU0FNhdrbilSGToyjsJA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1568cc34580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=3f9768ec54c86997ddfb
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132b19a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164da842580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f9768ec54c86997ddfb@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6777 at mm/page_alloc.c:5124 __alloc_frozen_pages_noprof+0xd0/0x318 mm/page_alloc.c:5124
Modules linked in:
CPU: 1 UID: 0 PID: 6777 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/18/2025
pstate: 23400005 (nzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : __alloc_frozen_pages_noprof+0xd0/0x318 mm/page_alloc.c:5124
lr : __alloc_frozen_pages_noprof+0xac/0x318 mm/page_alloc.c:5118
sp : ffff8000a3d575e0
x29: ffff8000a3d576b0 x28: 1fffe00018f73d00 x27: ffff8000a3d57980
x26: 1ffff00012eb431c x25: dfff800000000000 x24: ffff8000a3d57600
x23: ffff7000147aaec0 x22: 0000000000000000 x21: 0000000000040d40
x20: 0000000000000000 x19: 0000000000000024 x18: 1fffe000337a0688
x17: ffff0001fea8c8b0 x16: ffff80008af6de48 x15: 0000000000000005
x14: 1ffff000147aaec4 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7000147aaec9 x10: dfff800000000000 x9 : 0000000000000001
x8 : ffff800092df4000 x7 : 0000000000000000 x6 : ffff8000802312a4
x5 : ffff0000c7b3db38 x4 : 0000000000000000 x3 : 0000000000000020
x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 __alloc_frozen_pages_noprof+0xd0/0x318 mm/page_alloc.c:5124 (P)
 alloc_pages_mpol+0x1e4/0x460 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof+0xe0/0x210 mm/mempolicy.c:2487
 ___kmalloc_large_node+0xac/0x154 mm/slub.c:4306
 __kmalloc_large_node_noprof+0x2c/0x8c mm/slub.c:4337
 __do_kmalloc_node mm/slub.c:4353 [inline]
 __kmalloc_noprof+0x3bc/0x4c8 mm/slub.c:4377
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 v9fs_fid_get_acl+0x64/0x114 fs/9p/acl.c:32
 __v9fs_get_acl fs/9p/acl.c:66 [inline]
 v9fs_get_acl+0xa8/0x3ac fs/9p/acl.c:92
 v9fs_qid_iget_dotl fs/9p/vfs_inode_dotl.c:131 [inline]
 v9fs_inode_from_fid_dotl+0x1d8/0x26c fs/9p/vfs_inode_dotl.c:154
 v9fs_get_new_inode_from_fid fs/9p/v9fs.h:251 [inline]
 v9fs_mount+0x5b8/0x910 fs/9p/vfs_super.c:144
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:666
 vfs_get_tree+0x90/0x28c fs/super.c:1815
 do_new_mount+0x278/0x7f4 fs/namespace.c:3805
 path_mount+0x5b4/0xde0 fs/namespace.c:4120
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount fs/namespace.c:4321 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4321
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 3156
hardirqs last  enabled at (3155): [<ffff800080c6f5fc>] kasan_quarantine_put+0x1a0/0x1c8 mm/kasan/quarantine.c:234
hardirqs last disabled at (3156): [<ffff80008b001bfc>] el1_brk64+0x1c/0x48 arch/arm64/kernel/entry-common.c:574
softirqs last  enabled at (2974): [<ffff800080aab748>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
softirqs last  enabled at (2974): [<ffff800080aab748>] bdi_register_va+0x534/0x7e4 mm/backing-dev.c:1114
softirqs last disabled at (2972): [<ffff800080aab534>] spin_lock_bh include/linux/spinlock.h:356 [inline]
softirqs last disabled at (2972): [<ffff800080aab534>] bdi_register_va+0x320/0x7e4 mm/backing-dev.c:1104
---[ end trace 0000000000000000 ]---


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

