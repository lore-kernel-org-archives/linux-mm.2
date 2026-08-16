Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D24C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 19:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952F26B00A2; Sun, 16 Aug 2026 15:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903E26B0357; Sun, 16 Aug 2026 15:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819346B035E; Sun, 16 Aug 2026 15:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 536FA6B00A2
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:25:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC53D40594
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 19:25:50 +0000 (UTC)
X-FDA: 85108112460.08.E1633F2
Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23F90100007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 19:25:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3vA6CagkbAD0rxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3vA6CagkbAD0rxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786908349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=PkLfJOtZCJUEYqKnEJPEBIbrj4TsjKobwYXChdt+4cI=;
	b=Ny+cA163xG0iwlmSERS9nv9GRmXbGmRt5vwqJEJveQvEPefnmQAO9VyNwrUPzn+ZNYNkg2
	xshLht2XegNZLO4IymDnfX8fZ4ktR1ctMcRA0HPAcJZbRDfb87QTWnkjqXMjLoFndyDayO
	vzAqwWtoMJQSbUVc1ZnKKh6df5A3JY4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3vA6CagkbAD0rxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3vA6CagkbAD0rxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786908349;
	b=Bh1veT6LSn9fui6wk4PGV/UkTc3NhGqzEFbqm2dBezp44KAUfTQKTFs75D/YU9z4td6gZL
	SqnY0cIuhm70drQrxMUnvH2wn2WLfE7jpEAFenVjdlTbS9WBznnjC2YLCbkQYMjiX0CN3x
	WLepBjQdTlUex55MHmVEVpC8HnGSbxc=
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4ad778bacbeso3350977b6e.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786908348; x=1787513148;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PkLfJOtZCJUEYqKnEJPEBIbrj4TsjKobwYXChdt+4cI=;
        b=qcD0wYNeBrH/wf2R8HI9wIA2pib5SXirIQjhMGC36oSheJOFB+kjSvQEJ1pNDZ7qQQ
         bKry1wrGdcFZFOBdRUlkONpuwOs/wr8NSBEYLw91VcJC2XyuMxP7XD5osucSE55mNkAe
         CEose+Pxq84KlkL0mg/nACbbnZJQrjrLp/0R5huPDCCkqXdOzMFihSHlgUdxHyA+O+S+
         Lv0HvLrlQQONIO+A5aIOD9C15nks23x+JrJXVkuorw/gNiLBqNeBRttRWEKZWjpCsFgL
         nxa1MiC6oxF2DyI3t+ozVv/GgDOHKaCUbCO1JRh0vbfeuqB188R4hLQFGjtGsjz4tfu4
         IvFg==
X-Forwarded-Encrypted: i=1; AHgh+RpIHTM5i5yoREvOigUZuM01cEidQNSIn71b3IsiGg9xcKdf7AWya2EzLROdxUcuLhEbBWoyps1GvQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+QJC12RHhtFLigdUv4oecRK5E0nekK//Hpi7NxDSMoQW9nzBm
	jsuXse6EMSSoOZ8PczlFqldlsu1TDYHvZVgJlEGc7n9m1MerXZagLuKZ/U9wOl3oWrCfCJ+hQPQ
	G1FhAPJ2CUdtMK4FaMljpXTHaLQle6swBN4Fc7k6xfas7uPRfPufouU8uakM=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3502:b0:4a4:adaf:5570 with SMTP id
 5614622812f47-4b2412a4b5fmr18581659b6e.4.1786908348223; Sun, 16 Aug 2026
 12:25:48 -0700 (PDT)
Date: Sun, 16 Aug 2026 12:25:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in ep_write_iter
From: syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: dcwm5iqfzpaacq9epk4y441ieiziyt8c
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23F90100007
X-HE-Tag: 1786908348-610728
X-HE-Meta: U2FsdGVkX1/AW/YwdJ8N1Cp/RSHMabFxHiqmQuLIK4KxnC+b8vk4t0oerKwCpr9xm8tBNuknJ2/iGiodZgLJs2s2STeOu4aZEOgUF/YfxRiGQr8X/0DSE9LhbuDddTd3rwgkFsOvuYPp3TmQICf2B0z4p3FaThMlJn4Ke/zoktgvGJxEUt5RO5CkZPlj7lWSiuBnYjRtOLGKiNcsxkispLi03Eea5+CGb21zQDwrnb6e9FCOaHEjfBYi7+AfU94GDNnrF6VOpYtRu6w8FpC+XHBQBs9iOWo4mYc9iTBI5qRw3bk4Ji/Gn6cBtZqhvN3SRGYM3ezZ9w64Pwkwx38+3kT99GHj8HzT+V+/HgQjTFf9QiCKffF7Q50J56IZY88w74JVhPJqjxBjlz/5mltqFn6X+iIf7WUwi8bVT4V3xevJAJL17y/1UJXTekd2dZrqT81xKl/Lt9svXLG0v7WZygLsvW1BKl3wxJrQHJA3yFhFjp2n76M9PDwpf6oVkYCrw0vLF1dzH57c4FirbSRiQOzCqpLu56T298LRzJI8p3faojMm7WqOxVwUxTcs8qc0JGuvApNyDq8jApTGmc2rSgAweSKEJDglhwLtMtJDrQINn4da7nu7wdgXTufmAo60MNAzGK63IXO3lcbd7I20r20BVfbCPnB+V3m1F3MIxTQCxhvbVI1zvmFm6n8DXcQRsoYqPT4qE8vZ0Ymxn4baxLbj3iWHTR9OSn6q+Pb3aetPJYZp+13XBJInNHZ03A3kA2H1ZyaFxnhyYszcfBjvVRADFqX4HbcwINu8dMRX6GNjY5HTCaEx89NdcY479Lz3Ztg/rdrrem3OdY+icjaRkaf/GeK/gVDMiYFMP1Bk8syumsC/JC406+eKW+R6EhdaGpnGriSnBMknU0kEH+rvczAGrZXdgXTiOR1pM4bNmfQF/W06lBMTZeq2EoG6pZMAbWOdu/bA85PotWFHymy
 Vexy9a2L
 hdGOBm4wTT0adh3Bdmq0aiOiGRa+eabfOFN/r5uBW0Z1lMvl0YcPiHc+QeB0+2yS++SKQ+OoZSpqQRaCFLZwEbAwn+xKDRg+QaNUpkctHAG6npghOmyCYBHwY2Ab0TPBPoFkC2vbnBTN1VYNHDz/QxKMepfN76uo6KoIhegUX5Y0f4LYzAF8jGYkN7MfpzSmLkxUF+Uj2K7HUPj68pxO/dxO0219ZUj8ZYkVLwOwgDcKBNyPPKe13cEhdvgbbKetzyJ3tdOsYo3BsUpO8WatMUprDpuHKXLDVCG/pGjVNn/2Wap4edXcDhXU0OdtOVXjk8mlaWAkQfxgDjdEUbZNUrQVN+//dYj5P9w5yJ9sFmYf9SD3b/p9q8bnJIQZr4FIkZtyv3Aux7EROUN2tGmtVuDSPR+G7N/jcbKAT4ZaIGgqxd9zgNubhniPcaGlgbCPkLOaiAvGQfkbC4Mj5VDoe0NwQaer3/4L5akgbiP9M7gDJtG3s3aMgNHgaA/2hBcg1IQApwaj6UNbzOtncP6DQlyPGDWXV+udklXFKzYN+91jrZc/H8cWaFw5NZBVtS7vd0RFi182f/8Nwt6i6kjOj1RWr4uFEy+99HMHEOF5x+Ms285Prjc5F76rZ6X7FSJlmUXAly7hnlAA/zijzaBQ5yqT1rd8gjD80EOenT1jskBD5vb2uiUvFERupkh5YulPJwpFgYkykGcvtauwBaKf9KNCKdbFkf9zlcQ1dVkgRURLCPVJwSLXSyAeWvvbXg2WZhxvLxIh19Qu4pUQnPykDnslkHdYmd0Iu+v3pVNwz062BMGzddfHagkZ0FxP6vorwtqS7HFWgq5rCdid0z8sGt3jusFihUqnFOUCd6W2YTks9D1++WwpBBQWJdGBOKebYFQGpeZl4UrtJ8bjHZeI1tplymsVUVUO8OHkTfSO/2iCSEc+5zdlBwCHVg58YXwbK5Zm1+T1NaTCj98EbvKj52oPo3AKK
 oo8EXM/g
 bxmtB8tIMW4woHzJNhky30a1CHVz11PKLB0iylMA/3q8k3zTQGwfpjGv42fTrf7bcsHQPxcBDjtpt6FpR9uDytKVtGBLqf5N3uAv+kknI2qiO0Z5FRzpcgInvs731rT5m9VSInw9z5CG2Mg0ikzOg5+Hk6fFbmUWUSjPo4Eq47lPWA79meDM74W9P003S/va/Y0A6QencDK6JwUQLG06Mhjp78OtLgZ5lD68HHULRlI8erTlZAQuV/MToM6LjkpS6E9smz1Dg3eBbhMsz5PjtTZANm7NUsRw6Fjmi0zXYBfNQCzB4JpVIS125N1K8lgAmHTjF79Qz76d8pguUucv2nm5Oy/gPeGmKkh/tSdcOYQtoHebQVDTJGPGHYFt1jB2+7yYW3SxfvyG6mvwwx74mVoPM8Ww0YUgzYlCNmt3G35tMqx22/nJnVHVrZQVuiMN8MTKY2F6P+1DUwAVmJQX5nUYaQ4VSb7iv5yZXJR6p8wf2LsHu/ueZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com

gadgetfs: bound to dummy_udc driver
------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
Modules linked in:
CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
Code: 74 10 4c 89 e7 89 54 24 0c e8 0e 2c 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 95 d2 18 0e 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
RSP: 0018:ffffc9000e13fa20 EFLAGS: 00010246
RAX: ffffc9000e13fa00 RBX: 0000000000000013 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000e13fa88
RBP: ffffc9000e13fb08 R08: ffffc9000e13fa87 R09: 0000000000000000
R10: ffffc9000e13fa60 R11: fffff52001c27f51 R12: 0000000000000000
R13: 1ffff92001c27f48 R14: 0000000000040cc0 R15: dffffc0000000000
FS:  00007f6f4a58c6c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000010a0 CR3: 000000004323d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
 ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
 __do_kmalloc_node mm/slub.c:5322 [inline]
 __kmalloc_noprof+0x405/0x720 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 ep_write_iter+0x1bc/0x500 drivers/usb/gadget/legacy/inode.c:669
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6f4979e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6f4a58bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f6f49a25fa0 RCX: 00007f6f4979e0d9
RDX: 00000000ffffffb9 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f6f49835024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6f49a26038 R14: 00007f6f49a25fa0 R15: 00007ffc6cf49328
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

