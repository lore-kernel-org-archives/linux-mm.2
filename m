Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04DEDCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044708E001D; Wed, 15 Oct 2025 14:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01BEB8E000C; Wed, 15 Oct 2025 14:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AB78E001D; Wed, 15 Oct 2025 14:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2BD48E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:47:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 579C91192D9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:47:20 +0000 (UTC)
X-FDA: 84001231440.05.D68B383
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B8BB180005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:47:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3NezvaAkbABwKQRC2DD6J2HHA5.8GG8D6MK6J4GFL6FL.4GE@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3NezvaAkbABwKQRC2DD6J2HHA5.8GG8D6MK6J4GFL6FL.4GE@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=tXhwfDe5x5DiOvEHEE1cuwjprX0AALWQhFCn8f5jiQw=;
	b=S/+BlYWGYeBrQwODh6ByOUSKiKhnLR+imn+6W2o3s50l3XyRnkVclTiA4Q9slsFp2hCMuZ
	h6fIUeWv9aKEWibM1qiNuhs4cUDj/N1fyqxpR4hrGoyTeTJSVPCC7tpF1MVD7mfkY+svQ3
	PZnlN7HSbiBQT9CtuBm29bb8gg6X6EM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3NezvaAkbABwKQRC2DD6J2HHA5.8GG8D6MK6J4GFL6FL.4GE@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3NezvaAkbABwKQRC2DD6J2HHA5.8GG8D6MK6J4GFL6FL.4GE@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554038; a=rsa-sha256;
	cv=none;
	b=qFZ05F1zgG/srWIPAH5qriNJRRyeBGPbkwuXkWry9BK6EIe74XOe9T3eSreCg4JMxANCpm
	PqCmkogzxSqkKRPwCkOq4CjaYpB304UploDQoWnp2fUbfntf/z8ySY7BbVdbZeCbqdMASh
	rRWBmyYmBaWO4vVyURjd31WUVMPOVjs=
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so1359171739f.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:47:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554037; x=1761158837;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tXhwfDe5x5DiOvEHEE1cuwjprX0AALWQhFCn8f5jiQw=;
        b=ezFZjdA6adjfuoaoKxKJvIyxTG/tmM2p5kPck7wd/PRmQR+H9bwUBUODn40wpOpQ05
         VggqITMQiVz4TiZZ4UDe2jJg3J4GaiCTmbuUCbMrvRxXuueWe4XfDWZTwwTyGSwaeXD8
         wWuJig5Fmhih43Mx+eMFnNlUxMNLIfbAcGv+CHFMOuPv/V1k0stxwy8epIxCvU9k1Ox4
         /JT0/L9aB6eSfjF2ZhtVJH4rGstBbHh6WEcLTkW8uywp59yH8UVaczNRIVaqnvao2ZaT
         Mc6aHSzG0avjOYXfCB1gVIHuxQmZTgpxmyJZC32wm4NX7U//GnOWVSHic9ftgwgnj8wd
         Y6qQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/JoYXAD0y2F1UgBZiACWj+ISfEXNZB1MbPfFjFCk7+9vYbEfESU2FzC6UDpOOL1Fw2ELrA3EQ6Q==@kvack.org
X-Gm-Message-State: AOJu0Yy0zYLJL4Q0kBx0GgAbMWcp7jvZWSuALMo1/lthKh96x/4lLxEB
	XYnqxgf0eMdG2K8+j+kXxAMJQb6vcxytF/N8DJB1icoIldZWIjnjc3r2XYivr3g7CDJOUCB9u8F
	jusmK+q9uU7T1OfaCkkmIf1nluBxVmpH3P4mZO2nX2hsDoVk0i8AIMcVLq90=
X-Google-Smtp-Source: AGHT+IG0/Sg8YvnECSK7GV2NJsTOXSLgXIRXiVuzVAgRUG1C8KfWcQJ5eUQr5G0dAEr10p0umA0y5+yLQeAuCnx18GqAJ1pXvjgJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2197:b0:430:b32d:c197 with SMTP id
 e9e14a558f8ab-430b32dc94bmr22039435ab.27.1760554037558; Wed, 15 Oct 2025
 11:47:17 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:47:17 -0700
In-Reply-To: <20251015125945.481950-1-hao.ge@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68efec35.050a0220.91a22.02cb.GAE@google.com>
Subject: [syzbot ci] Re: slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
From: syzbot ci <syzbot+cib7b0db858ede4f18@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, ast@kernel.org, cl@gentwo.org, gehao@kylinos.cn, 
	hao.ge@linux.dev, harry.yoo@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rientjes@google.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8B8BB180005
X-Stat-Signature: 75a96jy3dnhu4az61r5tx1fp9tjnrsnm
X-Rspam-User: 
X-HE-Tag: 1760554038-838898
X-HE-Meta: U2FsdGVkX1+aakTIZZWYhY+jC5SlhpDc1GmCFKzogjKUFoQUQ8mmZSplevuXCS6YkFQcxet4W01pWcwyGOR/PfvVqyD9Nj1igICedSA6c4g7aQhDyonSddK+wKYGj7mJ/t3qWnAIT07Dj+oUczNR7yKj4NqJW4iR9jdTY3z7/JUX8yNnkj+BxgUt5QKU3cmaxBD8R176VoYzD/KkPGqClf5PEiit7MxoZ6CnH6pfQhiiKeUi+QSPfODHqKCp8D3ptLy0JlKjT8ZS+UuTQ+YIKCT0+FjtsVIlHMuBcHFGE8+41Ok7nH2qgP66HOwhwn5ATYsiQqPnFggxPlrXHYLekCgMLgxMyfFRabkGTDyrbVJsJ47ProjTfZ3CfFf0h1I1h2qyY3fCyA899hfl1Ob381fPjWdMWMmuIGYW2i/lB+PW1Ke/JaHfVdP6WKCNz2Q0t7V0MOtudDa8Cj8pcDpl+GLfSpHexvqKeDnYMWa7AeKdxEg+SZMS5Ob2DxZoMqZrjM+2L1U/JOfor/V5GUIboYArqbW4su01FfMZg9ECwfgz9MAbwMweVxfSkVimsIvfIxujJIB0477n6mxFJrCfSxD5EWJwPxVHOEyvUTwecS3HYQvbixF8gZNplhjqCMS+3Qcs1jwF0OecKCV0TaNYcuLn4SDdiOwk4DWHE9dD970nIYjyTNDSDxtNrri0VfQkpIDvFsSCQZGHUf9VQOuTimfNkwkJHPDJcOEpgX1UKz4/4WRDlusIpSh9vKTWP6aiTJ1J9g+G2PZ80mHn07QF2wMhBAzEhQapBe/jRWwrp2BlXpgKStazLodi6hunNeFDQC0vwWhdLHo+f1SUsrFJiQSIe16BC5p6RDCscrDc5s78UJBuMdVtkYpz1IC5s5Qxg92ybrhmle7D/SqeE6q9g0VnwOE1dTdTi88/uyTv/ShkJxwK7JuSEmKC+HJukBvZJjyZMisAWNsV9YqVeGL
 e2ovR/A8
 hD0HI0vc3Aauq7MWECi4b5R463NekFNx9K0mOxpwFl0cnZIPtbsdzSmz2oiDIbOl0tc67EDws2KqTTr0hyXA+S94QKLjrWMlkLsnP7GaJecPo+7rjGFz8LxPJNfFuy0gibXwF/cqbaiv8JrrJIs7HayNMp0TstGWG74P0fK+can7xWoB8MW3ybbFfb4Zi8NhIUhODleNupZZ/0z9WnL900j/yGI+XVHqBJdwTSYJgoOwdMYHoRgmydhi9xBT0ETmVbXTrWRWGSj+W6kvbTqAn+u5D7qUacrN3pe/Ce4dJVar47+ga4nYsHwypG+yaWVyTF6Wg+/M1uhv23xuaxUCbsU4jKoKCjYvUGksgCtbJMp1vb7Qkj1dvXE90sLEmfiipL87yJhTM5X3HENz8r8Ib9tC4GCSDD/135YxR9qi64l+IFGneGkBHYhD+AwI8Tt480iaXRPLrShmHYcx1mBng2QRR3zYJm6fLXMhdy2/c6eivs6oPoNh0Fu3M8428rP7eJtIwcTDOV2Wx65C4C9G4iYrn1sru1ncdO/FWrSbPUMnnQUDTt81xJRSk/rUCWSqYhb99RUqGxCmBYXS5czj28sl9flBI8WB+zPpRxElPH3sH7QUJK2Wsjzy8OQlbhgdTInpz2RUoaUdSZLk6Js+cJUhj0Gi8zHMk4fvy5GrZFnQYniOqCvuN3M/BKfiNlMxpt3ZDAzYK1t7Cge17cZolWrYj264y0wPgA/BUfvfz3roMl4vB8Ggkiz1MqObBJunH/Bebej4kaeoMMhy+BmOc22hynV+Fw3d67/M1z/RT2AVtchJeocYewVkTwkRTqBl3g1JE4ahutW+v/JerdY068GeM5+W+3+OUyQ1n+tDmdkjlTo+Mp4HRJtnlp61qnBCRxugNYs6vxmbUvrO/WXViwDa+DXOVgCWO2biSUL9FbMODX8mcoJKDGJH9IsOEPeBAKMld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
https://lore.kernel.org/all/20251015125945.481950-1-hao.ge@linux.dev
* [PATCH v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab

and found the following issue:
kernel BUG in __free_slab

Full report is available here:
https://ci.syzbot.org/series/61ff4fe1-2e84-410d-ad85-42ead772d9c8

***

kernel BUG in __free_slab

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e5875084-ea86-418c-979d-5b00cded86ca/config
syz repro: https://ci.syzbot.org/findings/1f8913d8-6d9a-448a-9419-90b758c82c3b/syz_repro

 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/slab.h:544!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:622
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

