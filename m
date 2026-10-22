Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3A6606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C6F6B02C6; Thu, 22 Oct 2026 06:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D886B02CB; Thu, 22 Oct 2026 06:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54AC6B02CD; Thu, 22 Oct 2026 06:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 853436B02C6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:01:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1588BA83B2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:01:26 +0000 (UTC)
X-FDA: 85349819772.27.523E2A0
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53888A0012
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:01:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3897ZagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3897ZagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792663284;
	b=6/gaXueJvPyrCtX9pTr22gmNkv+qRrI6DExTzIMDBLmw7YeVAySMTR9OKwugSeSu0Hfkni
	53zUtrqGfy5UvFG6JsitNV87Xq8S94dV6NJcHycwWLQnAZrf9SAednpSBuh8v7xxuQScTj
	yAHPRTWZxVwjMPPduyZQhc0V50zoFek=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3897ZagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3897ZagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792663284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=BWI3Lrcifhq07nHl0S5uej8tCbV/Fgv3NaO9h++jNTo=;
	b=7CPESNvl/PikuTzxjyju14qGH6Bn/K/OPHrWYm3yccS9dWSMuLbA03SFaH6MSMj5/PAaBN
	m6zq296cbxw+zK/phg3QBatw7+CwCB15wWD8N5Sa0GQmMcbhxgWl6Yd8QuIV/8EHhG75ce
	oCwLsKNQbZztIs0IUItx1dLq0YawpV8=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab4f652f9bso1236609b6e.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792663283; x=1793268083;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BWI3Lrcifhq07nHl0S5uej8tCbV/Fgv3NaO9h++jNTo=;
        b=duN+Ijsmq2RPrAmM9+w1xfR9b23wTesjPSQ4r4ASVJ9BxG04IVS9zzofGErqBwQd7m
         BIvc9NwzQl2z36IoTFm0fGwT9AhvdMJJE2uW/RiyhovBlxcT+R5xBIbn/dp9h7ALU/3k
         bxFq/q8dFytBLNg8smEgsDyD2ORKJrhlvcxsx8ZsJAhrRre/zcfnC8BafDaWVsKytuNa
         Khvp03acyMPvNf7U8OWD6fJ/4UNa4Q3newh3xJZHEwQsWUVvDy7e2xUk4d+IWUWhGMY8
         o1UfQfPTPxduEra/KZa36re3sDoMpjb6x5G/qnOEyXXWLqPYeA09/CcDF2KVYCrjohKa
         p8uA==
X-Forwarded-Encrypted: i=1; AKwUvBz573x4q/hlOeMZjjp/qdt5EaVL9oj2pcqM7DddxbEGJTLgHyMP28pSs8nSs7soUHSaAUfiZPECQw==@kvack.org
X-Gm-Message-State: AFq9FYLkrv5SipFGzYbh2uJvw8m0ri0JNM7S4++eVf0woIDMMIAzyukX
	ponUnJSotVpIXfVAfoDsO0II8aSojUUf0IuYpvT/ppLmk/mZz7c/U6FG5wnQvvHNKLjo7ovw0sU
	mu1MgiywfXJSiLw85nL1EooiuKTdI9t9RtcsKl8xAU/sm4U6E0H9t2amZAZE=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:152a:b0:4a4:744:a4ff with SMTP id
 5614622812f47-5534f045a74mr2683712b6e.4.1792663283371; Thu, 22 Oct 2026
 03:01:23 -0700 (PDT)
Date: Thu, 22 Oct 2026 03:01:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad9def3.3ebfcf67.79b0c.0095.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] KCSAN: data-race in xas_create / xas_find (10)
From: syzbot <syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1wrzxj4hf63dymrn6zdsfkahajyrwr1p
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 53888A0012
X-Rspam-User: 
X-HE-Tag: 1792663284-924731
X-HE-Meta: U2FsdGVkX1/+gfT2aJ27K2Y+cGTXt9Er1ZL6oh9l+X6H4uNPTFzOxIja/iVkroo1ymBPu3yyZuctFEhYGR0FnohvGbWEb638rri0rk+Eyq1X5DAbSQPWhExGat9I33YIpYAsUXwueEvzBiABdzNhM5IOcOQ6T/+tG/B3rsheY7KecuUMQlfgaSPtvsFBmoKtOH3sLNNz7rY6mlKo7kvvoLWKtatyVoqiW9uImbTxF9rtWIG0JqfIk2YqFggA10eN6ouyfUH9zQ1pB0Mj0Am/EsLqc8ks83D6as2dQ6G67gytpjadyr78alqMlzoTevZqNwS7h7QM4WnnY91DQGyCcdie24zNZRII0FFKtGNoaGvis8dlWIjSSlDXv8sInybnRRW+1Ean7AmAj39K5w28yixk7YNeXm0uBhqLEfD69RKqMkn6R5neeLcb+6pGlLUsDyxLYusCyM3EFt5BL6YqSJC7xJyZrvEuZJKNDnz8Bla3Kpwk0NRaFc+8FUsWcEfv6B531CozqfVsmGGLTzrQaGzXVYUq6yg5rvvKvEUh/Ojpvv6n3A7H0xB/b3torSbWQqx8XvUV3vdYNuWKdI7G2EbCgv+7DovyMN17KFeslhetif51dmsFUGaL4De2bUrlsyog4caQtkB5ofdqWmoTlCzL4cX2KMjmPSiYReccA2xpOKBfi1Du+5rxUF/cMmTG5uuK02eEy4t9K4eJJ7MpR3jOQSWxwV04RZsbPOfXc64pmf59mkfpqmJYTPL4c6UJlOoMvhZy3n2+qRoW5A2erI4pCRlPPdDIKElpNaQwr5VguzKwqTQhiH6Zo2jma4I11AbqRTLqXphLU80hAMCTuKMoJz7kmaR2pNiUg1+G5tj+5G/CHgF3sFkfEdkkHIrxY+8l1AjmCt92iUgu6Un/scY6jTmUedJBT4JHi6HriwrndI/CYgry8UPMwraD37efKYXYyqL07jB5qbePQyn
 FiTCiOO3
 Sp94Wrw8WbfzmD72t0Rh89jY+C0wDMB+v1Cx/v8RaI60eSckHzLr1hqbv1mQYxFsjvFBY5mDcR7OaC3aMqh8/c/RRdH+MANfkj04vZVdDSlnPdDm2wDT9SqMDNr3v5mFjZGLdNIjCYY5ecXfvl6MJL/P76oK6a64AD8VWyRvGv2NCpCZNRUpmgmajoQSPQSj7gyTCAiyjLWQTDyyRRsCC/hrPE8SzJ4ziIUp7oUOaya1igb9yVtT8Fo2njwtwworjdwhh2rmaZB82dekih0PnTt4ozl/CXwHMmbScUKPfLT0o0ZEMZ5HQXTbXp1l+1vuNwxlWly70KwWK7ivDhv8mwI1plnOtoazD5O7+bz00ll7nzE870pfEWCaHicZNOQgMAq3Y5BrK77ftrrRQqgHO7xblMw3+jlDVNNfD1DpEmuvkRq92NeyNQmcEjk0u5s7jgg3QKNxoIREGQQQ8PDot7/LpIdil9EIkNPIZTU0DB4qRdLYer5M1g07ZCoFTQhi2fsF8jqoOP9J9uw252Vie7p92SCUDAWrHOI6LFHrXma0aQ3sVdwNM7raPOtJXxTSgPV/j/EwxzfiIXRqDvXI0iXl1q+GLeZMIT1N/FvEMmVHsgVxSCQLM/GP5eu517OrQPJW5BOIaIZsrhjpydeDcXQChtllobkNiRUQKkY384DYW5kaQJjLMpg1uuY0Hyq0V3dQ2I+uRlF8xFGDLNRmyH0UDfVyQGYZv1ZCOVJg1sUgDzByba0qQnyhujQat+y3dtdGAac7GxozzYo1lPCWGf+veBSelOBSnqm1mZ1bgTfhZnbQk4mq4gW3QQ1S17Il5yrW0ULOeHTP8q+Ey1awLIuLuWh5yFwxaU/xZ00XawJ4CqrqR9/fa6ivX3MIZz/SgzE6mz85LZ4o+IuoeHcdeEDhJqCI3sxhFiWCLi+aDtUhfKDkNwUMIZp4N9f7aYAyzottg4uYyomUwFM4iEIrLnhDuoj6S
 PPogu6rI
 8yqB1tBXhp9MDx6kdSZNpN0YGudt2mfUmjuWLD5nJ3imL0OOPez3n5JEm5d6mmmZc5qin3cHW75s455rK56V4t4DsmfsmkYX2gtTXjdER8alGnDsPD7gRY2pRjGokUOjQErYgGHy9zaaxYFTbnLRJH1r4OMUqgx+6X5/SDp7RZqoTKI0g1ioJkH2SQkySLF3UVtgmHtDo/8uv7TBb4Jkuk7uCkaPst/R5yDVLlEULNsNvrFAooUXWTHR3+PpHpXXzrsC2sgPmdnHGilP4TJEF7x5LLNjGAfMK8OLlXAEgca2DiTsIbOYh9US68rSnlpBFx8u50qzprJM+VN69Trb5PfUPX6SLjeMkqAYCUHnQWi9CokqeZUtltz2zk4gC4h2JnIf2CIfs/dmj2wtZ5vzSnlNFV/s7OObBpFQ2WdFGi5aW0hoHahSvcAHy0SJBuwwLBwabo0Pz8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    a804c5742bff Merge tag 'lsm-pr-20261016' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10762231580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0a09745349d136e
dashboard link: https://syzkaller.appspot.com/bug?extid=73641b60a3bc11dfca8c
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/171f09113e28/disk-a804c574.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0f8812b149fb/vmlinux-a804c574.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6349a85938ab/bzImage-a804c574.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com

loop6: detected capacity change from 0 to 1024
EXT4-fs: Ignoring removed i_version option
EXT4-fs (loop6): Unsupported encryption level 6
==================================================================
BUG: KCSAN: data-race in xas_create / xas_find

write to 0xffff88811a8efda9 of 1 bytes by task 6715 on cpu 1:
 xas_expand lib/xarray.c:620 [inline]
 xas_create+0x685/0xbf0 lib/xarray.c:661
 xas_store+0x6f/0xce0 lib/xarray.c:795
 __filemap_add_folio+0x647/0x910 mm/filemap.c:915
 filemap_add_folio+0x1cd/0x380 mm/filemap.c:972
 page_cache_ra_unbounded+0x1a4/0x3a0 mm/readahead.c:293
 do_page_cache_ra mm/readahead.c:348 [inline]
 force_page_cache_ra+0x190/0x1d0 mm/readahead.c:378
 page_cache_sync_ra+0x11d/0x560 mm/readahead.c:602
 filemap_get_pages+0x2f2/0x1360 mm/filemap.c:2714
 filemap_read+0x21c/0xad0 mm/filemap.c:2824
 blkdev_read_iter+0x21e/0x2d0 block/fops.c:838
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x699/0x7c0 fs/read_write.c:574
 ksys_read+0xdc/0x1a0 fs/read_write.c:716
 __do_sys_read fs/read_write.c:725 [inline]
 __se_sys_read fs/read_write.c:723 [inline]
 __x64_sys_read+0x40/0x50 fs/read_write.c:723
 x64_sys_call+0x2135/0x2550 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88811a8efda9 of 1 bytes by task 6813 on cpu 0:
 xas_find+0x360/0x3e0 lib/xarray.c:1421
 find_get_entry mm/filemap.c:2085 [inline]
 find_lock_entries+0xd4/0x6b0 mm/filemap.c:2189
 mapping_try_invalidate+0xc7/0x430 mm/truncate.c:545
 invalidate_mapping_pages+0x27/0x40 mm/truncate.c:602
 invalidate_bdev+0x58/0x70 block/bdev.c:101
 __ext4_fill_super fs/ext4/super.c:5840 [inline]
 ext4_fill_super+0x2cd3/0x37c0 fs/ext4/super.c:5865
 get_tree_bdev_flags+0x291/0x300 fs/super.c:1883
 get_tree_bdev+0x1f/0x30 fs/super.c:1906
 ext4_get_tree+0x1c/0x30 fs/ext4/super.c:5897
 vfs_get_tree+0x57/0x1d0 fs/super.c:1943
 fc_mount fs/namespace.c:1282 [inline]
 do_new_mount_fc fs/namespace.c:3910 [inline]
 do_new_mount+0x288/0x730 fs/namespace.c:3986
 path_mount+0x4ad/0xb90 fs/namespace.c:4337
 do_mount fs/namespace.c:4350 [inline]
 __do_sys_mount fs/namespace.c:4565 [inline]
 __se_sys_mount+0x28c/0x2e0 fs/namespace.c:4542
 __x64_sys_mount+0x67/0x80 fs/namespace.c:4542
 x64_sys_call+0xc3b/0x2550 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x03 -> 0x00

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 6813 Comm: syz.6.569 Not tainted syzkaller #0 PREEMPT(lazy) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
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

