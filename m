Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6323D38FE9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099C86B0088; Wed, 14 Jan 2026 11:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D0D6B0089; Wed, 14 Jan 2026 11:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B4E6B008A; Wed, 14 Jan 2026 11:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D51C36B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:32:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98158160558
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:32:26 +0000 (UTC)
X-FDA: 84331112292.15.65463E8
Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE48240015
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:32:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3F8VnaQkbAJIEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3F8VnaQkbAJIEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768408345; a=rsa-sha256;
	cv=none;
	b=0D3NL8XWm6DUAf4mDgBv0cLiT+/ZUrGohp9pYo4WEZQsdQqibLPPpiHBU3VV6DL3+jrUv7
	fRFLHdsR5xI7uOSWwteHvHHe6SIxC0dy9w/9pcKpUD+P0FSeyKHWUZ+qZIJUZK3ad06Dqu
	s5LP5PaugCrE8k+LiGalDmYnZ9LXigs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3F8VnaQkbAJIEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3F8VnaQkbAJIEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768408345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=3NDxiqbP2esx68zAkMDEgHgnGAOZ5U1LmYaSTqlT+gs=;
	b=GvNM22CAWYQR7+BO4CFtC8IcQCPntQud/0718t5x2xhAEYrRmVU2cvsWmpOzmr89wHHib0
	TRkVocNea2ENsNwviqFQVsMdb1L7lriaYrmDfIJ4pkxBnVipUkHqxRBcHto65WSJ7scORB
	1I6Ll4UA7TJwGU+0UApnTBZOGM/nRz4=
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-450b5afd932so10708080b6e.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:32:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768408343; x=1769013143;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3NDxiqbP2esx68zAkMDEgHgnGAOZ5U1LmYaSTqlT+gs=;
        b=sWfARzHeJMQm8ttUjLdGYQ68BdFDGXXOIYp8xkb1+qy8pGdgDfkL207NRlr6COWEnh
         Pcg0FgCgWKCwWR4tHoCSubMTwp4/5Reti7FkjrvxN9LrWirk9MHdY0VCWrNuHDMVMxns
         /czTVL7TWPJCtYjo0d/KjUzqA0gq8s21UKvgpSOP+sq39HPulvaFcnGf7AMY9vTjqf8p
         wrX68zwI5rT6sevxleXDwu4CkSlTQeEHwzHHab8f+QTgkY7jKZqu5IBnqvaBxCEZ6xSc
         83d3lZkvW8q3XjXEBkJhN0pmc4G6xr53EMqx/hOB9CVKOYc2gbDvD2R7En4TQ1XBdNuN
         R15A==
X-Forwarded-Encrypted: i=1; AJvYcCXsWdDGyrbqEzBzQIZgg4z0ebIpRi0Kzi3U7jer9uUTPKZY5RqFppjdEXYiMv0epQkAXdhzdk9cgg==@kvack.org
X-Gm-Message-State: AOJu0YzyF3pWaZNsQkwlyDlXnbKf89ROmSeECA+TQ7IaFLfp+a5sTqDx
	yIdWHZVqUpTtG5GsGQqvSwonkR9ZH1NFZWI4k/fi/0lN9k7foZNJNmgcWoiwbpIotLmxBTJC6MB
	97/Vycv4rRll89R1g1zLqFtQvHaNIlDLk/Hb+/w0crQR+9lub/a2niL+d5dg=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8312:b0:65b:3376:a8a7 with SMTP id
 006d021491bc7-66100739b62mr1429416eaf.80.1768408343549; Wed, 14 Jan 2026
 08:32:23 -0800 (PST)
Date: Wed, 14 Jan 2026 08:32:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6967c517.050a0220.150504.0007.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
From: syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: yuiz5mtctbmj9odhxrr6gfajrfo9zeum
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE48240015
X-HE-Tag: 1768408344-553931
X-HE-Meta: U2FsdGVkX18V9DI/tv8lsNG2gS0pJmmGjq6Z4kMmTr+aYfHaiLPpqMD9FZ/t4hg+uan4NxmDeQP/nvbBrAyMIhRuLn3wewmX9DrE9aKvZE+c/lKpriX5xrndf+gAtO78M6tKpcZP9KM6bCGgQWwjtbaqZ3AJHx7FlvjREaLIu44HFJWrtus09HN9xnnlIVla51k0zsGO0JrnZAwmtoRJq/pshx2wVeVTFUPtM8hQ71j2DgCL4Z41Lqnlwm1uljyDhYT3yBL3xDIdWt/6Dp7Dwx0gzZruKqDv/ehhaMAUVYFdRYYy/a84fqdDhc8+P7NX1sPiGQl2qX6T/AZYsfVqP6syjTUpB89mPgh/HLuxDP+1iao/6MieoAmhyiHU3xy8PPVHYRrJScN9QtSj3zbSsARtFoxP0+ZUZ9yewziOkz+ghSQXn8ib6r5TLNIz73WeY3/VusEZVtIdMRpOecgCNVBnaDI5MhZ0oghuPiWBSy86mwmnw5CnmHJSFiildjqpv6Gj6qf5kjjrgySwzAwBS7Ptf4X9UpAN8EBWrHG5J7KBbDneFYNH8JNdb3UTl4KiIcGIY8C/+RQ9usp9nv/pOXVnscVByTbsUHIlasuZ7EmaIkWIsEgKHHIxyXjMbODyM81Rjf0qUjsp++W5oQ8puaIbTdzwa3tS1+7DIhiVD3xeiPvuEFU7g0zk6lDwbDrZWDslbv4ZukVQ0xqXSAlpMb8/nfnVPx7wg1250SrGOa6HEIv2ECPyB/PfB4+UBy6eVdrh0SfYZoveWMXlq9bpxbhhUe2tBUycTlQNiRVrwJsVCtZFuyrQzBk4ZMCLtEw0xhZQRBrcsE1R0KDOUt3xFlgyn5yVNoEEmp8RBACZCe/tB1SEKOLhwxuCSesk1OO7rLHk2HHSBsMSQfyYwsRbaXQNw5UaRAr1WuhFZOIKxUEYuQKNPy6c/y5vKoAimEi7azPXjkimZsgh2kqpVG4
 698R3Ldv
 g7s+p7LGHSfJ5L7WTVOYHa9Pf/+hlOJMTtQAHbXHtic+m5qpbEgP1p6tZl9NPSTOBY6AzC2SmVrKIONGIf9/cAXRINlaPBqhCrDD/QFw4xhhJo4UiYOFKFWvy7GOssW+MlR25Hxqg9c8e46M2eGLUGC0xkA+8Eag1PsL/rWo6EC02S5p4SToTOeR11OpU/g3il+mb4kbq4ek5D/e98ocg6g4wwbV66lDcyjxAWN71oSoa4XpzIjg3Vbk9sU7hI1vn20v0jCy/hteOm0GsR2soipQbEZbWT429h6Yogb2TX92dVzsywVEU2oRiBWnotPCdAC8llpH2rEnccHWzgAZNImV3DCoa7m9QaBb9EyHRyQMvdsvspt4zpu3CBFS6UQiqVBRe3aC/6U986jNjvj9UBYUDfQzJ4fcTV1D2Hjan2lVGoAxD97UmapGFYnmg1SUt8c8PqjVaTXxwINtbWFQkXLlZoora4A6RROD/T464exfw8dwaqXxA3H/WMaZAZUIfHNmh3ftpCy4aU8uDoJ/ZzC+0KLR6NNCsJgnmmnc/ZDgq4UWlVoVGbrHrkiylIODTRIFNHgRDOEmE6IUJPcSpMgmCEXIcXoXXV6vpKwt5lHLLZUeqk3rZp3qQ+ijSG1ZCO6xeKTGne/6wcSlj9zDHhR6qbKsO0ukelrO2UTkZYV+VRmFVaXZR36QqXgQObvTK8NzTYYHN7aYT9nAUPmo1Z3nFDeGQOLFjS7lBtyJLof4kh9VP4jqMN3tKK/VdXShd2ZL5XYdRmyuOVYcPzMiVd3OE4eSOC5DXcnH2egSZmZSP8UvO9qY/wQ5utnJ8BBoFqV5Wom9qJWXQvtUcomYfZxkbrk/FJSoepYrs4PWn3suKCYjUY0TfNiGgaA6RFv/wu/DJWi0mbPP1zjssxwxSn+Rm7SuoreLkUUH7r2+vnZUGPbQS4RzKqGq64YpmDqw11HX5e0yO5enzslXZOlxiWdk5+QXy
 h0N+yr1a
 OjGjaJfmgbyUEhrKP5nIvurpFy6IYRWB0ysqzOFsRjNgzJ3tCvTcsJx/U3aJiiTyw2IgfzUZiJ94QGupUVMBJ4XDTW5/2w33a0cMxaJCuoZwAqv5uKPc637DSwi9paCnnvN8NfpF20Cb1Yvn19hEwxa0c/n2SMn4E+FAodmjH1znc7YPiWnVRoSRj3C58L0p7WoPbEBOD8h4gWrTOTyE3S0p4hC8ich0YfDBuAk79bOYoceVObG4n85abqSIwG7KzKMIAAgRTebH7aAg+JmbsaZ3f1OZztZfTwcSWxAMAR7JAXn7Ldut96WJ2xVTA6obbR4xMOYGlQzXPpl5BC3waY5STDRttSnB3ktjMdXpFhHG1P7Nh171I2k3AnDbbI9E+ZwQPxiebZPHAHtWw6nAyWsVBPTDPTBG6u7Z2UJOQ23R59r+v25gZIEX6bnAChse6syf3o+ryDe5KFmTr991Qi55qM5CED1G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cfd4039213e7 Merge tag 'io_uring-6.19-20251208' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1554d992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3201432211be40f
dashboard link: https://syzkaller.appspot.com/bug?extid=f5d897f5194d92aa1769
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9f556ae6e3c4/disk-cfd40392.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/efcf53c1d459/vmlinux-cfd40392.xz
kernel image: https://storage.googleapis.com/syzbot-assets/858f42961336/bzImage-cfd40392.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare

write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
 __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
 __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
 hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
 hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
 handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
 do_user_addr_fault+0x3fe/0x1080 arch/x86/mm/fault.c:1387
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
 fault_in_readable+0xad/0x170 mm/gup.c:-1
 fault_in_iov_iter_readable+0x129/0x210 lib/iov_iter.c:106
 generic_perform_write+0x3cf/0x490 mm/filemap.c:4363
 shmem_file_write_iter+0xc5/0xf0 mm/shmem.c:3490
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x52a/0x960 fs/read_write.c:686
 ksys_pwrite64 fs/read_write.c:793 [inline]
 __do_sys_pwrite64 fs/read_write.c:801 [inline]
 __se_sys_pwrite64 fs/read_write.c:798 [inline]
 __x64_sys_pwrite64+0xfd/0x150 fs/read_write.c:798
 x64_sys_call+0x9f7/0x3000 arch/x86/include/generated/asm/syscalls_64.h:19
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd8/0x2a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
 __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
 hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
 hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
 handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x1024/0x1ed0 mm/gup.c:1428
 populate_vma_page_range mm/gup.c:1860 [inline]
 __mm_populate+0x243/0x3a0 mm/gup.c:1963
 mm_populate include/linux/mm.h:3701 [inline]
 vm_mmap_pgoff+0x232/0x2e0 mm/util.c:586
 ksys_mmap_pgoff+0x268/0x310 mm/mmap.c:604
 x64_sys_call+0x16bb/0x3000 arch/x86/include/generated/asm/syscalls_64.h:10
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd8/0x2a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x0000000000000000 -> 0xffff888104ecca28

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W           syzkaller #0 PREEMPT(voluntary) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
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

