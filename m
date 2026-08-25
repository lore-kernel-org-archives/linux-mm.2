Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476C3C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9586B008C; Mon, 24 Aug 2026 20:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A9D6B0092; Mon, 24 Aug 2026 20:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1E76B0095; Mon, 24 Aug 2026 20:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA13D6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:03:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51C3212028A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:03:37 +0000 (UTC)
X-FDA: 85137842874.02.3EB6D29
Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB34B1C0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:03:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 31tuMagkbAB0LRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.192 as permitted sender) smtp.mailfrom=31tuMagkbAB0LRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787616215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ghidRltZKHo1k7fmy+IdUK7PxGwGYHFGIq/aVrSbUhQ=;
	b=RhmPlaOMz4K9nJdio44cnFnwYL2mWSwUz8O6eT56xL4K/7Gb2uJL3wPwEfiX3lKTuoqwH5
	JO4YMHchWCWJuLUWyoooFRG+EUhrKPSw1i+PnxfXvDBWCcMwFHd3e4HfNHcyLN9rFnLz0P
	/xqPLDZybG483DvJV/1i77LGusn08QQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 31tuMagkbAB0LRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.192 as permitted sender) smtp.mailfrom=31tuMagkbAB0LRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787616215;
	b=1bOsHLpCazYDEEdbdmGMXyewViLE2NsVRKggYKiMp8kYyiPKl5SHqFzYoaspOqDx8Ig7Pq
	9huntcAI0R9i8/Hg+fdabyeMKH3ddZOPeGaYUa5nGexleA9lvcj6ntlYqcL56wh50D1bCV
	je3MkwToPN2uIqeTaltxHHUsLaQ/nmU=
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-4a41b6fb855so1559161b6e.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787616214; x=1788221014;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ghidRltZKHo1k7fmy+IdUK7PxGwGYHFGIq/aVrSbUhQ=;
        b=NjhRnNbZ7Wok7g7yKzP7rD7/XTLMcDDavgU++Fo5url8P7AD466nBsynBylhYCqtSb
         HzqN5nAcHtCRC2AA8qeld3kY8xpkwZDnEokQEdlattYGBJgLya6qETgrHb42xebyYtI2
         1GJCb13EcXJAx+XYHhG0XT8f9aKVG/lWs53dXVqLPgvc/2kf16d/x+obRGq51vrFRzC6
         3kS5PoJqIDqB1SlDZ/pJpsOVhE/dhqAXw85Sp+Tnfm53bnHit6HWxAF0UUG46nRDSu+7
         q35VSKC0D0Pube93XvVv+DUs57J6vHNbd3JtUhmRUtUIbHOAPrEH3PvuTL/FAHD4D3RD
         hTOg==
X-Forwarded-Encrypted: i=1; AHgh+RpDYykv6ON0QHp8Kkv738Hu40lmZ3klMr0u3fGAGWHNSzAeaxlj96gqNS37Ur75hW2lU+WboJslGA==@kvack.org
X-Gm-Message-State: AFuF++kpcmI+mGhGmUjov84jl0wK9F+1ka8SXKdUWzHUCyQmLlVqt8ya
	7DSDT2UsNW8F835vFa5nGcSmSM1iad2ptZOJLEvki7Hz9Lyim17Z6pRX5hq9gNjoZOIMw/k6gsi
	M5hWdLBORlMgGdn8wAlqKNe73CvpGzBS/DNm7X/ffxlAayFhA2/2x9CdjNZQ=
MIME-Version: 1.0
X-Received: by 2002:a4a:ec44:0:b0:6b1:7ee2:da31 with SMTP id
 006d021491bc7-6b17ee2dc66mr10382010eaf.11.1787616214704; Mon, 24 Aug 2026
 17:03:34 -0700 (PDT)
Date: Mon, 24 Aug 2026 17:03:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in setup_conf
From: syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB34B1C0007
X-Stat-Signature: tehxa4hszy1cdxut4k4k49t3rugqpa3e
X-Rspam-User: 
X-HE-Tag: 1787616215-510844
X-HE-Meta: U2FsdGVkX1/LBNtqFGvf7Y1FP9PrduYMAOO35u07T/TZuIRcL32sL/6TMNhyvSWiE+NvhhJz6Sg2sPHQwXeTYzf5abjv88tbqlrPdKsa1p/BGvUddaoNAFTRYHX7fENLrVjUqTraoPxejUWxxDE1nxCcbhMekXg+o7DBeqfYHbiw6yuMi7WzxV69oxLHpHIBMn6iE/9XyIjS3NlkAdkMsmDcUtHjK1dzT7zZjssDxaiyZSgLEHJxUMef3GTVhVGVFOTjWILTLRYrvi4pHje/7acFtgVmIvql5xtovUDkXETgcegSI5FswZzxeeqE9Xs+MFYbyHLFafj15TROxIEAY5RlHP9YzZy9a8SybpDJs/7AGQl3mznHJnvXqXr29O6ww+ZdKFt+7DolRFZ4U8Kq1M6xu9N25OUrE7SoI51RHxAJtoGuN8ApgCvpcNKnukvo7tsQchtvtSFWZL4lVB1bkgGt+7tN4NOkRrgEwCtY2GdXrfk36KSAmt0bF6KH8ukEdvzY85LWfCV6XmOTvLhcERNUhfcDameGiuuI6KX1EaulfZW+aeFhEHPdLPDaVAr/i5x1r4CFOYAps9u+r45tT44O0svnlBKwWQVa0kqf10zqqI2/h2FgLUOLyacdJEMimanFCVvCwyd9EAZvJmYUs2a+CUFjZVnjD5cXK2qXRF0Cj3EJx2q8hyegx8SKm2WD8aWUXz3oiZWvDVr/EVGjz7si8d6aXQmn4wsLi89F5eiEo+w6dxvxUqBzaeieoorR/sOMPJQ6s2NK6+iQruG2hp0558/p9ROu4rm7T7R2HqdNRo3cq1lRA9oo87nwb87w5oxQZMsstleYqINYVSkbwGZ41pkdjSoZ+Omv7CZGnS/xyxBxPiuQ3zDV0Nm93hx1srgVWvgPCntZwWh9JmbfyOiP2fkzjRSqgWR+vW+ik74WQm8hI6UdYdVbxR/fHeImFiYfa6R6ozw18ClV4BU
 w5EYT/1x
 mO9cSNyA+aceDbHds4HqXkzIPRGugMrxtbmLM2asJy4QV0Xwr4KrQYpxhJj9fzHViSosQaFCHXqRsOVMCwwYyJgBMCtho7C0Q/X18jvY52+kn14Fku0+umextTDy4mVdtNERFYr3eJzDWOQRRrYCYY381yFOw9GyQZATp4+Tmp3Q958s/oLnJUHxH1pqawcDTQ8socFmKBS8LkH3z7fCz8zAEtEjk4dz5SfpQ20Y/gSTYdmPco8L6VdNwqqHPuu2FGlHcEvanPHj/CNnOkJqvB8JNxBihFlSjt2k8yJj/017Gf+J5A9Wx3DxHUzFOFwZHSeMI2lSepunNduT+0/cwDs0XhzrU0g1lqruBUXlykiYQNW3ojDR4PgkW5YmwsDlf12fVkMgeYGYI+bKTV1ghyfbjVEeQoQWky7Fyk5RYP0lSiGk3FhTat6kG9VOYzLrn6Uxu3I9EmJsTyEvWgxKFhhSUBr66eNggCDRGNHVO9zmI14KH4o+ZKqlo6e9PTrcV2W6Suvat+GDGdUuk87/ozA6wd7g63dJg6ntdgcGqrs/+aAkVCpG0VaJEpinDIo9RWTzJj5TguBL5dbceNSfN3VzWQ98yC1JJHGuX1jTEZyuHL5emg69AeXNBuHENYNXqF6hkZ+X2gi7ZIEtf//z9WPdPfwnMYuJBmxFtd+odbmI8dGdlDJx3tax5WGFSLVS+VZ4kfPZiwKpo7qO7VC4vDQdBcCzq5Y+87HWLXxZyLSBSdksD2dY51w7MyTJbHWoRxZv7zQryFGilisAOoLfp4bzV1Po6sGU4MgAuRRfcKMr7okLaB4cUnY7yCAjU8XtFC01ZHQfIaoshVo7cP2ZTGX4O2LVpxnHDs/9E+r3Xwk1l/Z9nKYhZhC4VkQYJ98i7KFd3rwSxbft5Bz6Zha9d/WfK1ybWbaihs4g76XXZNuwjp3GsMvxICn6DqtlIkj11GXp0n3S2Yk9hAK8NArnmmXAhCjW8
 s+awZ71N
 tPXOkCNt+QWkxr1McfOYfYZcCYZ8hGmEeubVcH5iOHKnGM+fO0fXSJj8Hu6eoxI4FvaEYeGOeWX+qzwkIxLMADM+jof9IQiPG2ytCNevuj5lWfIIfunOoBFJ6eYYZ5+nSenSQjYU6Fvwq9fI+DNTxyNlYxUZGfYtni+X02WmrezkfJa1FTD54jwVY6nbD+YqF75O1k/twPXkCi8CggzE1LZZtxNg3Amcro42IDOU8Rz1xjnXbVMoIlIJ4z4UWBFN9g4TaCYQQp7vkFCFPZubSWUDnX0PbEw8pDd8FUMLTl7vMB76WgMOTing61XE1JtS6H7Kdt9CfdcTax3EZ1goWYFCO542OUdiH5JMUsPrmVYWUG5CFkq1qySgCufxXj7aFb8c18QjTkZKbN5cnUQz5/vzqMsLpU5aBfUTsawTzvi+rIKc3TZczxeXYOYD4GuVp2H0oDUgAIOnghZnkD/hlnaH+W1jz9wPnXgalIwS4W8FSjIVIoH1RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    9d2ed026f031 Merge tag 'sysctl-7.03-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1124919e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6e414d6e0a79e71d
dashboard link: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9d2ed026.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/89c0c0c0f535/vmlinux-9d2ed026.xz
kernel image: https://storage.googleapis.com/syzbot-assets/80d7adeb0e7d/bzImage-9d2ed026.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com

tipc: Started in network mode
tipc: Node identity 2007ff, cluster identity 4711
tipc: Node number set to 2099199
md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5310
Modules linked in:
CPU: 0 UID: 0 PID: 5310 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
Code: 74 10 4c 89 e7 89 54 24 0c e8 8e 2d 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 74 6e 18 0e 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
RSP: 0018:ffffc9000d50f520 EFLAGS: 00010246
RAX: ffffc9000d50f500 RBX: 0000000000000015 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000d50f588
RBP: ffffc9000d50f610 R08: ffffc9000d50f587 R09: 0000000000000000
R10: ffffc9000d50f560 R11: fffff52001aa1eb1 R12: 0000000000000000
R13: 1ffff92001aa1ea8 R14: 0000000000040dc0 R15: dffffc0000000000
FS:  00007fe2b9aac6c0(0000) GS:ffff88808c519000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc93d2c090 CR3: 0000000044100000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x212/0x390 mm/mempolicy.c:2490
 ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
 __do_kmalloc_node mm/slub.c:5322 [inline]
 __kmalloc_noprof+0x409/0x720 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 _kzalloc_noprof include/linux/slab.h:1309 [inline]
 setup_conf+0x28b/0xce0 drivers/md/raid10.c:3883
 raid10_run+0x1d2/0x16c0 drivers/md/raid10.c:3984
 md_run+0xdbd/0x1e00 drivers/md/md.c:6760
 do_md_run+0x35/0x720 drivers/md/md.c:6861
 md_ioctl+0x1c58/0x2580 drivers/md/md.c:8492
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:797
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe2b8b9e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe2b9aabfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe2b8e25fa0 RCX: 00007fe2b8b9e0d9
RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000009
RBP: 00007fe2b8c35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe2b8e26038 R14: 00007fe2b8e25fa0 R15: 00007ffe1ca65d58
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

