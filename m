Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAD1CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 21:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B1A6B0088; Fri, 29 May 2026 17:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC236B008A; Fri, 29 May 2026 17:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E25B6B0092; Fri, 29 May 2026 17:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 607426B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:34:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 253671A029C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:34:24 +0000 (UTC)
X-FDA: 84821761248.21.9C55CE7
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6ABBB40006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:34:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3XQYaagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3XQYaagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780090462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=B6aPnpvyAVuQFC8Pl1asar8RzwoQlcJgQai84S0/104=;
	b=uxQ4lGOm7AP16/B95RHjgRDV14i/WD1OsIf/Ph1Tz14gBKVb19jSZDiiWkN8ICYTTnkh9b
	lYHtsvtTnasGOf1fhMA7bBZHnL1z2GBgltDqtnTDvKIZhuqLW7NSqbM96OWLLG5OOuIjT7
	JS33g06HqN7mkye3veSoEaQdhrn2w8w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3XQYaagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3XQYaagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780090462; a=rsa-sha256;
	cv=none;
	b=X2011d+8SXOSXCAwZ7M4PIZX8DkoA0RtlUkpQxdbWVWB8lcgteTDKNISmQB2gzrVOphnP8
	PqLSZCm2CcKX6tX2OF+Ui+m7U4819PhdS7oH+pGbMYxwHUswrBqjBRRUNH3DnRPZuEb1WM
	kB1tpmkcUCH4KO1gJ6CsbsljpNEjjaM=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-69e0a282136so738913eaf.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 14:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780090461; x=1780695261;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B6aPnpvyAVuQFC8Pl1asar8RzwoQlcJgQai84S0/104=;
        b=nhyGJYvGQ+u4yHDHiPYRTx7w4ct3YjgtYUW6ZkEbYy7eyWJNJulbHuxMkt9ejc55o1
         uuoncus8JyFZtS9flFcdICSRGwfEb81Hy9F533m1XylCIAuX2S0qK3Llc8xeGcE1CGSA
         39m7q4Bdbl7UdNZ+BgmoeVoDkWlMnrBeWxpoilyQDXDsOa6xYDu4nG+6DyRAZP6lBMyH
         Dq+r1iAc6ZUxWVkGZu4axXP0sPpRpAMV7m977G956zyQJgigYjido+TX3DWdUbyNoWSg
         hzJejEUpwfB7wGgjAH/nOMEZFe/AePlxkLSwynKVpuhbO8ZL3jBcUwmCjkD3oHbeBswi
         b6zQ==
X-Forwarded-Encrypted: i=1; AFNElJ9zUnwVYt/bdF47ZoBGeu1bOz4UsdZEFei6/859Mue2bWVBFiEQ42xOln3SnGXa7fGvidEkUiApOQ==@kvack.org
X-Gm-Message-State: AOJu0YwwyFm7ypoiab9bMy+P0Fmra4UicaE3gRHeJhdttJX/SOwCnDTI
	U769bVLMRPmOf+OCgmEB67pT0xhSSrG6C5wVXLy/YfKKFz1qXFEmPR4DeRJ98W4VGZrK0DM3eCE
	CKlJEukSz7kFoyFn10w9w1OlAk+mMbW3Ed0NlDduYejrdHFFDsKYP9oIg0qs=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ac2:b0:69d:eccd:e5a7 with SMTP id
 006d021491bc7-69e10403fc5mr507800eaf.1.1780090461483; Fri, 29 May 2026
 14:34:21 -0700 (PDT)
Date: Fri, 29 May 2026 14:34:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1a065d.ba3b1513.1890b4.0004.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in _copy_to_iter / _copy_to_iter (2)
From: syzbot <syzbot+3058ff8dcc2e370c7572@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: rtye77in51co9irerix9g73bkoryujgw
X-Rspam-User: 
X-Rspamd-Queue-Id: 6ABBB40006
X-HE-Tag: 1780090462-731424
X-HE-Meta: U2FsdGVkX1/rFAB9O8Ge7avvc+c6Z9bQAT3T78w06mwNlPFFLwjudYBblkyf97uiokWGhxZqXpJGvFtFeA/3ugKWgnDah+Ez8ecRBBVOzx3EDPLzyN0CXZwIOA/YX2BGF9Ai+NOenJKSCp0IAKV9vPLLblbDWig8bjfc0JpDVaWBklBYcH66Dq97hD2hByk7y/jS0/AgM/9HzlPXjxD9yaid2Bt3EdTbDwLzr470ALoNt+X8GN6phvEVOxKxrkbEVsroce4LZfzQt1qkT33GEGNtNXlI9I4a02lC2k8hhF9se0hZnq4T3ChJKzv7B4QrLApCMWqCZnykmkpKRhOktT7XAuBEIZmBqSGoq5hwpt42k7IA0we48jECZYNS96kTbULPWSF683kW+94MaYRt1pvUnYnpMhGGHH8eQ31FrXUJWRrUik0hx/9XZPNWD1SIaJjv5+FFJpNhehYgFqu/mpAbqvL71ZQQ3VY5Q0UCRxiimpxJkmyfuicx5u0KH3gcYMkdHElb5uRa3mVy1wtyjXVg8Doh8PuL0Ix3YikBlx+Z3rDPIQ4uqAP/U8M0DzbylR5TR4loKHHQBGrQAQmI++mBoVIU+6KBCeV6gWteIOsMhUFrdqxeau8qkLGTdjkOLC+K/7Cush+k29n09TOatfNdha3vBLq2aEhYd8o4nwMAoTqpYqanDL+WOTV80dmwG2YbtR3XXms3gIHGeJl4N6hvJ8eJM+WDVu5Lygq4Ic58Uv7lUpQNV+g+Wn6v90CAaKAU9GC/rLHhGBsMIJK2qyt8ie772h1GUAHzUXcyuw3T19OE2B+Ki9YsKUl3Q78gd7E/v37rEIheVJ8KFTZSmbw25RvTnaDJnJv+C/pOIk6hp/l+znpC4koQZbD9CkuDgcnv1kxXpgzqai4BlE3dNCvUkRs7GYdoQQM5LFIa+atlhYOSAnFEj2SUWa3s9s2WehliWWaZcb+f5XqXDOI
 RuwcXkFQ
 YsUy8joUvTFQ0UerrJCltX+87wCIScLlXwVwLcZyo23juYeMp/wvhfR56wKm5Zu085h4Z5Uq0xeQLUJY1nVijNyRM/JfEY2vSb32/xA/LQIL6u1+6v9j7jjr9WH41mFGvEQgfNC7mSb/Puybolx9AUirM+Qw6gpF1HD093spaCfuq+nD+ODWHxj5hds4x8zB1u9RVNmkyJFFktiN6MndavzMZx3BlnnBd/M4fFnKoH8aD8/g7n397mcHkr9VYOY/eoQyIRQYgQbzBTTnsdTVUR/IIvoUe/j/TqWkBOiY+82gu0Rn+PktdSb+ct+CVMU2NqaUlYrwRtGifE7AKfUiWEmUpZpTfc1T7yelXptohG+q9J7GuynLd+/nEqb2FBqhAPmXlVTzEkshbhCFk4i9u/19/Mn0RkaESCn1OZJ7xIcwu1Bt+0qzv6yZmajNZ+joxrMKB6Vub87aFi9OKE4iLpGXEdLzuKrsX5WL6HSMcSw+VMjwt31lTJ1GC221M6K26kNoHRXChOyEzYzvG7mKbHYgshITZEfX/3lSVJMMML2b6ontZignESdH9UO/9G/2DzTJW53y/HDIYQgu1Z74UASVDUS/OScmCc3snIecZR/Ld0GszIzhnKdlRmVJ24TYuDiO5EleHHM8tgucPIzKsO8l8r3vy7WzeXna0n/NeJvcZbnYp46y7eHiqQIfi1zCHWuariIb3V+YKLSGOObbIcehaLjgvFXgdQyAggSA6/ObD06fCB42JQfIQhwaKXNCDLIoOmLlQDDUd/9+SEMlYK1pvIh4xq3wntDmUk1mFTlY+BshxML+ICN5qfDQU/5IAkjjxVmZzPRrmXUe5uONApPKQHFCzkgscYGyjInwnwOy/zFw1gh05aBqFvnNol5UuG7+hrAtl/d7BzVACd8viqR1rDwyiM+N2KVielllGCd5O5lVHw7IzZP7+SGtUVNjbWy1/UW18cMvBwA+QhnbE7khfjPQr
 rTn3owKU
 paHbRmQxWoCFjWLlkXsvnnDWBbhYbYvJm7Min6toHfPT2pDcx30aDfQPFY0qaopRksWrBV8IV5JQyqKy1Nbht9v7zWs/tfnI8IRvgVa+ewH7/NsVdJf/AF/2xnExSEONd0yrHLmLYE+P6n1c/0USBkmZ3X3Eps1bWxwLzY8X9TLpnWUs2V79nTTSgxGmZU+BvkEO82lUdA0at18EMrEi5CvPIEX8IswHnXIDdAdgcFrf1P7PssPJ1tnGbB8m7SCkOPqRYdMtmbWxAFJ4n7VSNZo0oBlNZblpxD/JsvcswOuUPy9xyFNcWXmxHkBLvkmdguiM0jVbg70vDW2CIFM7DrmcoMfHDNG/EjxCepd599tQyQJ/PKKpNutUPWQv/sv+pnWUEQd20YDnCd1mgRPsJipEVf7PDRvuDZtn3+xs2Gnh4V2pad5zPqM3g5vEhFqgQSTQ+3vsWHbxImHzbZJPZO2pGrJ1dObH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    d60ec36cab33 Merge tag 'mm-hotfixes-stable-2026-05-25-16-2..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=142ce056580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d830408e2d151f21
dashboard link: https://syzkaller.appspot.com/bug?extid=3058ff8dcc2e370c7572
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bc5554f13e6c/disk-d60ec36c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d0317a873b98/vmlinux-d60ec36c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6ceafe75f601/bzImage-d60ec36c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3058ff8dcc2e370c7572@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in _copy_to_iter / _copy_to_iter

write to 0xffff888131894000 of 1024 bytes by task 49 on cpu 1:
 memcpy_to_iter lib/iov_iter.c:77 [inline]
 iterate_bvec include/linux/iov_iter.h:123 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:306 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 _copy_to_iter+0x602/0xea0 lib/iov_iter.c:197
 copy_page_to_iter+0x178/0x210 lib/iov_iter.c:374
 copy_folio_to_iter include/linux/uio.h:204 [inline]
 shmem_file_read_iter+0x29e/0x4b0 mm/shmem.c:3426
 lo_rw_aio+0x67d/0x730 drivers/block/loop.c:-1
 do_req_filebacked drivers/block/loop.c:-1 [inline]
 loop_handle_cmd drivers/block/loop.c:1925 [inline]
 loop_process_work+0x56c/0xac0 drivers/block/loop.c:1960
 loop_workfn+0x31/0x40 drivers/block/loop.c:1984
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0x4f0/0x9c0 kernel/workqueue.c:3397
 worker_thread+0x58a/0x780 kernel/workqueue.c:3478
 kthread+0x22a/0x280 kernel/kthread.c:436
 ret_from_fork+0x146/0x330 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

read to 0xffff888131894000 of 512 bytes by task 3290 on cpu 0:
 instrument_copy_to_user include/linux/instrumented.h:130 [inline]
 copy_to_user_iter lib/iov_iter.c:24 [inline]
 iterate_ubuf include/linux/iov_iter.h:30 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:302 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 _copy_to_iter+0x130/0xea0 lib/iov_iter.c:197
 copy_page_to_iter+0x178/0x210 lib/iov_iter.c:374
 copy_folio_to_iter include/linux/uio.h:204 [inline]
 filemap_read+0x407/0xa10 mm/filemap.c:2857
 blkdev_read_iter+0x22d/0x2e0 block/fops.c:855
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x6c0/0x7f0 fs/read_write.c:574
 ksys_read+0xdc/0x1a0 fs/read_write.c:717
 __do_sys_read fs/read_write.c:726 [inline]
 __se_sys_read fs/read_write.c:724 [inline]
 __x64_sys_read+0x40/0x50 fs/read_write.c:724
 x64_sys_call+0x2886/0x3020 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x12c/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 3290 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
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

