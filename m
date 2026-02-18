Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED636E9A04F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 21:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310FD6B0088; Wed, 18 Feb 2026 16:59:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BEE36B0089; Wed, 18 Feb 2026 16:59:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F2C6B008A; Wed, 18 Feb 2026 16:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C92A6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:59:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28D4A8B4BF
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:59:34 +0000 (UTC)
X-FDA: 84458944668.17.2AC5352
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7655C40012
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:59:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3QzaWaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3QzaWaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771451972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=GW4Ocoxumxoq9rGVwk3byPUBA9fwWdC8c7Fz/FXOR4o=;
	b=hG6HX30LDMHZFPOjoVmbFRD1tldn8KvHcBdiQh849vz+ELvvWm1rcZswlMGTZhroq3QvY5
	74XI6z4DdznUrSl3NQmiUuQQbDo9LzMr1tETiBHjSRX9tpePgp/6vv9Q8Ix5CXQQh+JDrJ
	9DC4/1uy9EC3yhOJY07unxU54pYye0E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3QzaWaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3QzaWaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771451972; a=rsa-sha256;
	cv=none;
	b=HvIQo4q89yjmkbo3fuPDbEH5irUeVLL2awVzrNHWOxWLIDnKiiOnvVPK4qBV0r5oG7e4H4
	fleHfehNxVLJqH5pkgfzVacrBalIEqxReWEWjdTa7PEulBLdDjJHuGck8O34pJor6x/q+5
	C0HYXhUb8Q6bJw+INNLW0RHN9C60CXg=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6777b1ac383so4953136eaf.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:59:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771451971; x=1772056771;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GW4Ocoxumxoq9rGVwk3byPUBA9fwWdC8c7Fz/FXOR4o=;
        b=bqbHGkLK9ztGze+b74zam/5OMc3CNMIMOC1LmKBipOY2desXrYB6oq3khydGIAj1cw
         vpSvAWT02NAcqlEWxA5yry7tMQwSgpqAYCjxkQBNkbGNzO7KTi3/KRHnHop6a6Aw6k/q
         wcxA31vi0EAAOQmB4Bq6aweE/wgiO4HHgOx26Kqd2zT4VRIHw5cO3zGQeypexNk7RSz0
         z2Pfse9t44Mj3WPZNzX5aU7Zn4mNXgGNbxu49K0OoAdLwrwcGyWtYgKNsbAG2k+C21QJ
         SJc6i1CMWgI3a9Q3jdqNccGuKarUVesaTlv10bqSvzSIng8eupOXABNXkyhRON/lIhd1
         bz/g==
X-Forwarded-Encrypted: i=1; AJvYcCWFY6l/GPGv0ehG24gcTLLrE0dnvsrmUWbNvnZ6957Y/+mbgwpCjW06h7WF2ddyWshWL7sgO1davQ==@kvack.org
X-Gm-Message-State: AOJu0YxfIQ+FkR9kgXiqK9iEYxWwBM0RTyJvQ8QXSjlBSyBB4KvJQeg/
	wSTAINUSQ1KXyNUeLq7NKBSp0ba/PmBI6gO1XfLqacuVC3QNs6gCO22e4uyRFNIJe2JCT3DC9Dn
	TN0VvHycCPoHf0RfKWZfK5MopzW2T8JKnNrz9KUcOz9SOMoZGzr+LZB4ocdg=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1886:b0:677:cb1:37fd with SMTP id
 006d021491bc7-6785bb676d8mr8341992eaf.58.1771451971502; Wed, 18 Feb 2026
 13:59:31 -0800 (PST)
Date: Wed, 18 Feb 2026 13:59:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69963643.a70a0220.2c38d7.0120.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in __page_table_check_zero (3)
From: syzbot <syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7655C40012
X-Stat-Signature: kwze91hisk5u8oy1dgcb6tcmy9aud451
X-HE-Tag: 1771451972-718637
X-HE-Meta: U2FsdGVkX1+qSNVRsm/LiFjgh2SLj/jQVscE3mEt50GKYMCuCan6eZxE505TeFBafJpVHXDy6NbXyBtGK0xMTK/PVmuIar74U3SodeIL7Vx0q9/eoDRr5pYXVs8U3NHjqJqPhr1VxiFdz8sNTbmCOv56AM1PpaK6BVPARXNsJFxkb3PTyQw3hpk1nxJbqgcL/fgqO5MoQKlsOqQ8d/S7aKLtyEyEOuyP52F+7rBZsR0Zy9tWwhigCwUQMddkPlXfj9t6VzjrVOBkSLBvwZE8JfvSNn+Y494Rakxs+QLAjuE9170TF7U3cclJ/na4NmhwHF+Km2EuRynTk7kzLzLMGrZMSLMNVMsybJFFzQIDpOgIzth49gaoNZvAql+lT/k7Xe9Dz5FTwDGz7jih9jbDMOag3AKx40pH8wkvPw0uWz+OeVrLWUmlZ70HhqWBwB5h///QuXe6cf4aTPANh1LcfjMIX9q3Ps7A6yms7TfTzGRo0yApBPfVgmutulw6Cycm2vt8thwUbFCyQq5cRrh+R1cJ9qVfTnSC815stSGR9Hjj6nnZQRTe7TaawyAerIhE02oZ54OA/f+GWIr6NiWOhoaJUN7Vy5Ro6hD6PMWCpWNlochceDxjaw4eYaqsH1A618/zMf2hr6HkQDZdGtWkksjNUwJ6vyn4gGa0bH+cZjnrUKqBcf2cywVrOIvKHWNiW9VCxGwWv+ncpt9uAsSM2hppXVez1B6WbxZQmt4SrWl8v686gS+HHbJcCgkfMFESEuLJpSJZ0HfXF1cVaqvlEMX6MfbvmqwaUy+qydMM7RsdnAoB+1NOmSPny9WtMI6jSFimJJ5Udxq8dIWSZpwQKAHH0OAPP+uBT+ED1lG4VJRvI9CtTP95DaKvacejI+OxvKMxMLM7ClmKk2d2qIkDoQjXMWL34rXdOBDEmUaaT0L1T+pIpvuD2RTRmgRq2LaG/1OwGjBx1BxpRjKb+i5
 4NL3RdLR
 xbSaJwIenKc+cPkCGLMNPTVbBn560EBkVZZ2Az0LeQooaoHhD1bkZ3BsqlBh8K/oWg+P8m7/K+f8zIKhzKo7jo+1BAWPnBV7G8zLzW+busf9p/o9s8n50XaXWRxn0+TVe5zPyIxPfhs4sVAaR94xqGZKwLE5VX3JdM7AmEtbX/74R+s+/s392bRugpnjurrtOSQcgs+7Qx1ScrK8Q/U2TpCMskMfE4fDI2wHnHdUVUY0Xo4xryanuCn9AgtCkIJu/himqjfLthuEkQRqyfJ78Sd8VjBgWj6OqTMozBx9sTpgLi2ds9xqIkceGrzsCh99OiInjEIScp1vK/dvhjKYrLh+tZDIpDubv7zdmlf55zOZNpQOBE0rCl2+LSpabARGAzhWYBf0/xCwznuAqfqHJ7onq++IpMk4FX2ht5VVoPVWObOvaIFhSzLdzafb8QjBlMFPjTl+mB7/ZkhV6z4yB9CI9S9rfEAL6+QDHqoDHpIP2bMy8D1n4jSwq10Xc1FC4ApR4spjVIeUFWt17TSNnjNtb4duxxbJYBE1tOCMa+RKObsagTnkl5AJO1ndNY3MCT0sYEL+1A93OEOzVctTGE+4Xr6lUGa2B8Wuy9lJx8OIAdD/ttwNuXh7fJMAuWT7ZAkHA4ZkjNxv0LTCE6/Zg5eHg5e414SYbCFCcTi2AHDO0SHZcy7n40sAaW+kw0h8KyqJJrYFIk3AdyWHxsiyhFeKlzU71CoqUrYLsO1qPilmIDTdAMgdN5Ak1FE3PCBW7lFZ5+OkdOQkGy0P4MhO4Tbp9wJ3Uw95e9C6eIKIqKniMdD0SqL55hD2blbXLsSE7TJDZ/TF7aRR2YCRdPhYXlDgnsA0NndH2bV09nhkgKueOEx6fTscExHnzfBv7FOuPcZ3D/HUHOrXxGz7+td3dqCmcgEp+EeueBOx95rS1TpumkX2FREKeH0+4m/iiHqq7Yql7J6xiDNKNkchdEpcSeQpqfDm4
 0s+GcE7B
 1kr3rwQ/4dG/enVkal9/r7APvDQM+u9yXwkLykLyVlxE0BjD1BG5RIteXeFyHIaMjqjXMCQiU8zfRmzxeDO4L71FUGm9h1I6XuKpUw+rz4SDOAafS1k/g5LUwF0PjAhyLH8faYoVJ5oYT8/GGluWqmLvbSbisOWRII8IvgCzpnv+/ROGytoKU/8p1feAq0osIj8TJT6d31sqFqhlx66GL2iHryp0F0REReUrckTozREiRYesHa8938lNOrFCV0qv6dCLJSYmmpi/Ovh8pd8yCFQ1J2h1GmdyfyjQz4a7L8FchpGUV9VZyvyJO6v9QvuTIv3QtP1Mvmu05unD8+PnFvHgK9SqHhQq0sq4qaLfE4L2a2Oo+nDpmWghQSbE2FrCh80IikiB8T21IIJE3em9SmmSB3dp9af3eLnc/N/K3DsISarEMAhPBacEBVO3KVTnyiUrWrhhO1V/CgaKtFYGQY/YW6YubfaiscZvPS05lSmR5c8a4E9vDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    18be4ca5cb4e riscv: lib: optimize strlen loop efficiency
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c59b3a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=781a4eb07921464d
dashboard link: https://syzkaller.appspot.com/bug?extid=2b5fe617654be3d8848b
compiler:       riscv64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/a741b348759c/non_bootable_disk-18be4ca5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c6b87a8d77c4/vmlinux-18be4ca5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d5126373321c/Image-18be4ca5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at [] mm/page_table_check.c:142!
Kernel BUG [#1]
Modules linked in:
CPU: 0 UID: 0 PID: 3940 Comm: syz.1.16 Not tainted syzkaller #0 PREEMPT 
Hardware name: riscv-virtio,qemu (DT)
epc : __page_table_check_zero+0x396/0x544 mm/page_table_check.c:142
 ra : __page_table_check_zero+0x396/0x544 mm/page_table_check.c:142
epc : ffffffff80bfdcce ra : ffffffff80bfdcce sp : ffff8f800af273e0
 gp : ffffffff89f9df20 tp : ffffaf8013f64f80 t0 : ffff8f800af27380
 t1 : fffff5ef0269a409 t2 : 0000000000000000 s0 : ffff8f800af27450
 s1 : ffffaf80134d2048 a0 : 0000000000000005 a1 : 0000000000000000
 a2 : 0000000000000002 a3 : ffffffff80bfdcce a4 : 0000000000000000
 a5 : ffffaf8013f65f80 a6 : 0000000000000003 a7 : ffffaf80134d204b
 s2 : 0000000000000001 s3 : 0000000000000000 s4 : ffffaf80134d2000
 s5 : dfffffff00000000 s6 : 00000000000b2a00 s7 : 0000000000000200
 s8 : 0000000000000009 s9 : 0000000000007fff s10: fffffffef1416bb0
 s11: ffffffff8a0b5d80 t3 : 0000000000000001 t4 : fffff5ef0269a409
 t5 : fffff5ef0269a40a t6 : 0000000000000002 ssp : 0000000000000000
status: 0000000200000120 badaddr: ffffffff80bfdcce cause: 0000000000000003
[<ffffffff80bfdcce>] __page_table_check_zero+0x396/0x544 mm/page_table_check.c:142
[<ffffffff80a775b6>] page_table_check_free include/linux/page_table_check.h:43 [inline]
[<ffffffff80a775b6>] free_pages_prepare mm/page_alloc.c:1434 [inline]
[<ffffffff80a775b6>] free_unref_folios+0xa22/0x1dc8 mm/page_alloc.c:3030
[<ffffffff808aac84>] folios_put_refs+0x41c/0x61c mm/swap.c:1002
[<ffffffff80ac4cec>] free_pages_and_swap_cache+0x29c/0x480 mm/swap_state.c:358
[<ffffffff809e9980>] __tlb_batch_free_encoded_pages+0xe4/0x25c mm/mmu_gather.c:137
[<ffffffff809ec4e4>] tlb_batch_pages_flush mm/mmu_gather.c:150 [inline]
[<ffffffff809ec4e4>] tlb_flush_mmu_free mm/mmu_gather.c:398 [inline]
[<ffffffff809ec4e4>] tlb_flush_mmu mm/mmu_gather.c:405 [inline]
[<ffffffff809ec4e4>] tlb_finish_mmu+0x188/0x824 mm/mmu_gather.c:530
[<ffffffff809e631e>] exit_mmap+0x396/0xca8 mm/mmap.c:1290
[<ffffffff8013b6aa>] __mmput+0x106/0x3d0 kernel/fork.c:1173
[<ffffffff8013b9e8>] mmput+0x74/0x88 kernel/fork.c:1196
[<ffffffff8015b08e>] exit_mm kernel/exit.c:581 [inline]
[<ffffffff8015b08e>] do_exit+0x792/0x2828 kernel/exit.c:959
[<ffffffff8015d578>] __do_sys_exit kernel/exit.c:1079 [inline]
[<ffffffff8015d578>] __se_sys_exit kernel/exit.c:1077 [inline]
[<ffffffff8015d578>] __riscv_sys_exit+0x48/0x54 kernel/exit.c:1077
[<ffffffff80078192>] syscall_handler+0x92/0x114 arch/riscv/include/asm/syscall.h:112
[<ffffffff86391c0a>] do_trap_ecall_u+0x3d2/0x58c arch/riscv/kernel/traps.c:344
[<ffffffff863bb61e>] handle_exception+0x15e/0x16a arch/riscv/kernel/entry.S:232
Code: 7f80 8526 c0ef ec3f 8a2a b791 6097 ff90 80e7 7e60 (9002) 6097 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	7f80                	flw	fs0,56(a5)
   2:	8526                	mv	a0,s1
   4:	ec3fc0ef          	jal	0xffffffffffffcec6
   8:	8a2a                	mv	s4,a0
   a:	b791                	j	0xffffffffffffff4e
   c:	ff906097          	auipc	ra,0xff906
  10:	7e6080e7          	jalr	2022(ra) # 0xff9067f2
* 14:	9002                	ebreak <-- trapping instruction
  16:	9760                	.short	0x6097


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

