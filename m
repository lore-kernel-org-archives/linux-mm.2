Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4851EC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271616B009D; Tue, 22 Sep 2026 10:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2497C6B009E; Tue, 22 Sep 2026 10:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186316B009F; Tue, 22 Sep 2026 10:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E713D6B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:08:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8029D140501
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:08:46 +0000 (UTC)
X-FDA: 85241579052.02.BCB81F3
Received: from mail-oa2-f9.google.com (mail-oa2-f9.google.com [74.125.231.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id C899614000E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:08:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 364uyagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.73 as permitted sender) smtp.mailfrom=364uyagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790086124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=FPxij3GIKryjcXEbmMsQS/qbe8XwIFxlkyNJU0nRpOY=;
	b=KKc1t36b+Ttr50Em/EZgnLKfo+ne/D6FGIiLuHU9m/PlCHzAcmBljCiDMkXStWHJWamC55
	gS+4J9zekiXttmbwwaWINrZ7dFpYZ0VHtQpndsePRm8NE9dyN5XWq/EaopePy9u8XPaE2B
	23+/31kpztlJkeMP7ojC9lWNzJkpD6A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 364uyagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.73 as permitted sender) smtp.mailfrom=364uyagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790086124;
	b=g/TYDfr1FyDUpkoEF4g5K5QoCKwDDCNd0oie2STCJgk8eSNOKugYfqdZSF07U9F5WJZZV7
	9f7YwHo4cxEXkBDpzXynjFAgHQchYN3u9kY8zwgwYIcbTFty9lH/SIRrJdPHaVUrRWtSS5
	QNgCMH67nU20ZCRIK8hXrR6c8MwzHbo=
Received: by mail-oa2-f9.google.com with SMTP id 586e51a60fabf-48e45c35a8bso342677fac.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790086124; x=1790690924;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FPxij3GIKryjcXEbmMsQS/qbe8XwIFxlkyNJU0nRpOY=;
        b=0yOixswkS/BMaeRELz5oxJY1+Rqj+sqFiHRXHQ3bzu9SKhlcLlbwNhqmc4vrDyRkPz
         INpPmDm6q2Elgq6pyYTyii2VjnxNb1e2xjpK5oYrF0mhHcGEhGawX98tJUl0GQqiEcAk
         0Wo78YIegSyKIEC3+OIcge4GYppcte9+Xr4BHkhDcl2pDcqnNdlWbjF7S1ZscXDgqU+B
         tZJgDjqPWIp74xO5/UvrQCpd7zqEpRr322rflbAQWpuhGXe2tEjwoU7AfLP0MxEYqH7q
         P5+/vKfHu6Wcwuy7Y0JreQ4zL7MmgRyWpFTFADvqOs3Kyijd8SFH1mgmVesasq9hHZPz
         YOqw==
X-Forwarded-Encrypted: i=1; AKwUvBzl8+haOs6gQmejGVwtbKys/2HViIm7WFlA2OTvm/NS1zpWI/qvJhK+DkiOnbMervNmTodbLpst0Q==@kvack.org
X-Gm-Message-State: AFuF++m1eyTZer7ZEPGYekwT1XNK/xUl04Ldc9k/WVn31FJ19nScGhxN
	2mGyBmFJ3XDmxZiEPUykgwyH1/zDs6K8JrJFJmBNeCtCjt3nV4iAk0HpeaIy8qQSi6cXmcQOMsj
	YjX5a95RyaKYVG6uF+CbU0FB4lYkAY0uTEocJEAaQF9nR94FD6RezsOgN1cc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:178e:b0:6b7:46e9:96ff with SMTP id
 006d021491bc7-6ca9c84d60dmr11904743eaf.47.1790086123743; Tue, 22 Sep 2026
 07:08:43 -0700 (PDT)
Date: Tue, 22 Sep 2026 07:08:43 -0700
In-Reply-To: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab28beb.a6af0033.177e91.0020.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in setup_conf
From: syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, matthew.brost@intel.com, rakie.kim@sk.com, 
	song@kernel.org, syzkaller-bugs@googlegroups.com, xiao@kernel.org, 
	ying.huang@linux.alibaba.com, yukuai@fygo.io, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ywy9ob5eumchq9tq9dg5nrsjfmedat17
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C899614000E
X-HE-Tag: 1790086124-447844
X-HE-Meta: U2FsdGVkX1/GnZZADYjcqSX0n47a4Zmk07jUV4KCfeb5utOtyut8cFcGDdy+QqqfO72Zi1Md1mAO8cUVqTrQjlygM42ETb6Go/VRZLJLz9hCjbLlkRjjTY+p5tclIUkuQ6+Wr69dwd/i8JBRsQVZF5UjtCVwdmc/XTbxU/ZCIt1XU8AXOoFbOj0PekP0dNwZ2s7B1Df6mQGmdByBPbiCU1pA1/2zKkGogOQ2bY9ohngbP0O6xtFxzj6Wn74zbC4alioDd9FzMZqGMbHoV4hqv8h5yxywUFPyhuckc1igD2V1vq4s/DmK3rbwqDCy8yY/58HUs1ZvLiDmETzDnn+iPPXOjtRstJOJ/b7gnpfQBIhZyQwXmxAf03fgqyEjq1I5XJWdRXHOHS8AaL+1fQsqPLz4GSMkZoCoZSzY5Dq+NiyZLwQvrCo807ggEyo/UoQ7T0FwHvAEEskLFCa/TBCoV5KZqX7+7jb3vpYC411JZy3ExBsAx77hnoeVFLLq6hBqPw2UZ3kchyBwvWCGBMMqMRZpBde3TMxK1ew3ce4L1JxBIiXpeS5gPZr8lGFMqfo24cbUV47tNs3GDnGRqlOM7nNJ2ovfCH4K3GC8WWepjTErWq5ATq8ZA/TBp5w8xFEMx6hNm8YEkQQaQJZZRu+D0dWzYB5zcW2ID6raBnWt4hBByQXgEraS8ANB6kQ3zPQ+YHnGq5m36+NTljpV9MIBH9wWyXtEU2PcinnVjpKIaI1zQ2FgNhZu3DoPW4LlNhhfNqOF6IuwTgmB9iN5sfWTrBoFgwjYjJkBCV7sObDOfMTUEs0JJYibu9N7jfvGWZReiKQRtzt5zz3CTgRXH5CgtaLvG4nGm1ClSzcNq1vdWsgb48eqrB5H2zAprSfifO5p1lzrzkVlSKQmzRMV5MLPUP22P7NFbUMAyugwVhEa9y4wWGUnzMjDki89cFx7tvAxycpzqa3q7X6wFeoTXZ1
 x2q3EtEb
 H37ZOhaB6ee4zcLbe+7I/2lR2GJ+dNSoRuZD8dO4kjbEwRwZXhudrANzUfgf6oixhSMBSoGe/HFNhV6XCAsFz8rgPvqE4LuvLZSpGG8U0ypTVOfr85PCp2yq/cFfS/rEAOtY6wQ/xSSPobLnU3uyCZnNJLFL7r7Ml793ev7bv0JEsMxE8DSofhSD2v5kZkUZh9tCd5NnDT18zFy8f93u9l73EaalBzZKe3JIJYPYoTTQQxF1IebWzlw1BxM8ffsyq1xu8o7zsny5YPyyhCk77nno8pwsha+oRH0FWjiE4Y/Mbi0heG10ZcGm5StkRmhLMmNHHz3EUhzIVLFCNYwhEOsLFUbnJfE93ZT5EHHXPxO/onnqUDVmyrR2gnOjnzYd4hSBvXBXLajJZUHzIRvtjAqqXcj5P6w9czlYqIIbvgy9xsEtQSWK//eKgrl+jYSJ1kWLcgTWdf28g6Z1PG4UGE4VhqMEybVSwr6Ap8D2cTZcTLQWCgGvy4SwndJbF8XimIl1ufesFXIzzAZ7uqEmfq2pn8ecEnCFql1tMl25uji/9/8Y8wwNWIb+l1xlzesQfXw2D14PrU7wcl/h5FRCexwuu6VrK4IOPEZ3AKUcOdu+CKk7/Gf9s46x8s0KiNhQFgFPk8Ca7aFWWwglvcOnKkCtIvY0WKxZa981N7OTkIxa9tOcaCXOG7L+tswXxGvlWgynTmqwOTA53onIxKKjR2O9fgqax2kvSoz9DN/F3FlEUennaS4H90qehTogHIfdmwPeZGezEO5tJNC29cweFDthUD/YGBfi9eZ9ZeKNm6wbRFh1c/q3LM8C+RjulNlL2gzcxu9qwpDY4SBkCEsWE6pqeBzM0usKF60RlNAggLFBMZ273n3P3VLAvO8WWVFSknJMUZ4rmyoYgJJ43GHe4+9NIbQ74yf3tnK2MzT4NzOAAi58KXwvuFXbcEgeVNT4UTCTvNMimJPNRimWVWdfEVAy7h7cO
 Go8k2W0B
 CMx4z70cB1sfkU7ObHQCHCI3RFSWq6FEVJMrFHtGkQjqlIx7/ZHoD8ueqX3c4kiz9iI06U5iblPWgI7f+LTk8WPcpQ/TjKzS8rYiYS3DJCrG2Z964wju624ZaD/JaCdiEDuONAlMJJ+PpBscP/81QLC8xBD79i2hd9DwyLhpU1ZCvtxyiWVghDFaLLJWbiKJ2K7oFq21/c0IjBYdgjQY8SLBXp7Mg4AwRLkJtR7CiEnbzTfY7WqxbtMOpP0vl6MIBYII/hO6flyNC0NcCeX1sfoYRSxjE9JqiZa0whgi2Wn2I5fR1QhsuHtbxyoR1XN97r0AllgIwSmKEraZdWc3PycbChV/02iz5H1OinASbDI2ZPLC/hl3PTGHegzqH5OW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    f0100363d8c3 Merge tag 'xfs-fixes-7.3-rc5' of gitolite.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17971805580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
dashboard link: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b20c5e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10720c5e580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f0100363.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/18fb2734cddb/vmlinux-f0100363.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5737b586e7bc/bzImage-f0100363.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com

md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.0.17/5462
WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397, CPU#0: syz.0.17/5462
Modules linked in:
CPU: 0 UID: 0 PID: 5462 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:alloc_order_allowed mm/page_alloc.c:5340 [inline]
RIP: 0010:__alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397
Code: 90 e9 76 fe ff ff 41 81 e6 3f ff ff ff 44 89 f1 41 83 e6 f7 a9 00 00 00 10 44 0f 44 f1 e9 45 fd ff ff c6 05 2c 98 38 0e 01 90 <0f> 0b 90 e9 8b fe ff ff 48 8d 3d ac 09 54 0e 67 48 0f b9 3a e9 68
RSP: 0018:ffffc90003b87520 EFLAGS: 00010246
RAX: ffffc90003b87500 RBX: 1ffff92000770ea8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000000e RDI: ffffc90003b87588
RBP: ffffc90003b87618 R08: ffffc90003b87587 R09: 0000000000000000
R10: ffffc90003b87560 R11: fffff52000770eb1 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000040dc0 R15: 0000000000000000
FS:  00005555836a7500(0000) GS:ffff88808c2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4a2c07ae9c CR3: 000000003bff7000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x21e/0x390 mm/mempolicy.c:2486
 ___kmalloc_large_node+0x4f/0x120 mm/slub.c:5353
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5385
 __do_kmalloc_node mm/slub.c:5402 [inline]
 __kmalloc_noprof+0x3fb/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 setup_conf+0x28b/0xd30 drivers/md/raid10.c:3855
 raid10_run+0x1d2/0x16c0 drivers/md/raid10.c:3955
 md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
 do_md_run+0x35/0x720 drivers/md/md.c:6880
 md_ioctl+0x1e2b/0x2610 drivers/md/md.c:8515
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efcb939e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd8c37e488 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007efcb9625fa0 RCX: 00007efcb939e159
RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
RBP: 00007efcb943506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efcb9625fac R14: 00007efcb9625fa0 R15: 00007efcb9625fa0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

