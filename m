Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A6BF5A8C5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 21:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD376B0088; Mon, 20 Apr 2026 17:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E196B0089; Mon, 20 Apr 2026 17:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3116B008A; Mon, 20 Apr 2026 17:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 458FB6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:14:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77D59140B4A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:14:31 +0000 (UTC)
X-FDA: 84680187942.17.49EF3FE
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf24.hostedemail.com (Postfix) with ESMTP id CDECA180003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:14:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3NJfmaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3NJfmaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776719669; a=rsa-sha256;
	cv=none;
	b=S+v9bw+AhFvQnpixomqkFwQ7QnhCceAo7J1upXG6SR9IekIygYpHhM9yCrP10WiNsTo75N
	/ItY9dEOQ2tCZKC7+0ALrrzNmAfVFR0JTciKuc8lKjATsXLhPFoPHDaUE9y0ZGOBm0uxsb
	/lwozMUAbg9XaK39VOcszhXK5beQOnA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3NJfmaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3NJfmaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776719669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=7317dhF9wsrPDBqyRZOPjIWQZQvZppHM5OBcaxZNfAg=;
	b=GCfyOWLA7kpotlejvszZgy3dqF6N0ph6TTXS3dxS+kqs/2+DUWgFuSwKmTvp/KO1k5FaZ4
	0KTkdptkIr1Hj/GMt9KqZopMOk8fKa6JTwR2TiJGvCu6fuue51aEANahkJUnGt47Wc1rSX
	lNahpFdbgqBludlrUE4Y3hCVkYC+Osk=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-67a1e063795so8148795eaf.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776719669; x=1777324469;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7317dhF9wsrPDBqyRZOPjIWQZQvZppHM5OBcaxZNfAg=;
        b=tFYCZ2jOB6Jc3jqpOZZp4kpXXQXHJNpKLwc1aE0sWUIy+BVfDx/c1BBlNOQIl2UIXH
         AitKYaVAhD2G625sXSQJ/ZLjiGZvsdB2QxZSUqYKT1lCVRi6jNMmbh3tFvrO18qDBris
         jWgJvJ7vSzaHzheKkUxlCMEBKlXHd6PelBnfV+3pb8im9QJuO3+7IUGrZBfrY313bzL3
         BjHFEgjQqnRXHgnBVl5QrvD/liIjLmBDw6f7F6m9UhVxd7HUaOb3QlosbOx+gOqBZhWZ
         kL+SEGt8impwFML/tlsmni0kt5G5tpGAfPSeS2LlTH/Mn6LsOnzrIoPE0P9dweGrfgnq
         L5WQ==
X-Forwarded-Encrypted: i=1; AFNElJ/2O0tUCP2u1+G3OSd6y4Z/AFJEfnaukjXa/yh9UQAb+eHoXOQfP5U8exisifyc0Fo0zUGdb/pguA==@kvack.org
X-Gm-Message-State: AOJu0Ywd6Wy9I2wek/Q2j1TGuodoMyyiwaEDU/Hqot2kwf1aEr1nMXnF
	r2TzxIkJfO0ZHkxMa9N5tbaW9kP0I85eutseD1kt5cMmxTpt4Y3F5NazjMDgmpIPIScqGpVT9eb
	N9KrT+8Ue+XXeqVPy6OF0UkEWsmGDrMyjbRA9EsNdeNO4mVg2U3ifyKQ0Yek=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:188b:b0:694:95ae:c546 with SMTP id
 006d021491bc7-69495aec7ddmr939021eaf.2.1776719668897; Mon, 20 Apr 2026
 14:14:28 -0700 (PDT)
Date: Mon, 20 Apr 2026 14:14:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e69734.050a0220.24bfd3.0027.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in vma_mark_detached
From: syzbot <syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CDECA180003
X-Stat-Signature: eyus8feerj3dod81tp5xm5zg9eccp191
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776719669-638500
X-HE-Meta: U2FsdGVkX19MD7Jr/SW38xyt0yzuo9eLrU25EM1ncshlXuGI4fmmIa06KA5C+H4pRLioNot2BIvlpWnaGg29vg8AidFFDiudq+0Co8ILR+e+A7ID+4HOLjoqc17Byk4cYV3MK9BCUGAB80fmvn/5qxOj6TbLOyBZput8uMfxKWtElFeXHqHkqD9tzi0e34xgO1f0P26jAx/qsLRgpslqfyjLJWaEriG2LoWVrOvTIvK92C6ARoo66Yd0ZZ2qtjrH8vLAkpbbtA89+Kk2ZpS1YPpCN6sHmjIsw2EuA6nYk3Q+a6JI93WyYcz2Z4vzyveNbr1MimzLj9Hm6rkWj7A1V7qymFS9g2vPBWDshwQGQbHqMm3HcIGZqkHT57waN7njORf7aH9ABQ1mwYoEdCq4ekjV3kIf71eeajxGnKznchVepMbyZZmsXvVwQ/mFwgHSyToaCxEJb3oivQF2ohO30gnGraB6qukRWURz2zAsrcs6z9f5VkOXMVT+0aIrkAl0DQpBPYj9WYiyRp+htlbaDFOFYRtGuYONA/foL3Hl8FjfZfhybTAnFN7osC0KIi5tBNMzc2v0ZzcUb88W/pm/HKusyCfwcuqKyeH3qRFNl38gUQOcVV0mswC0NzKs02E8mLmcfiFiUIJGGRkaW1cnvz9UVH85Vhns2c5ShlxWwNiP0X7iW1NUmGlF3RMKGgwNTzCNTkZ+akwwnK+V9o5qfQeK1tpexKFJSH6Y7M9jFkm8Jd4i9r/+pt/fCnojNry7wU1d88ZzVJHWF6MWj05H7bV/GrFZP1CYTaFnncgujrHdVET9aUf2biHXflYg5lpmFWM049VG4v7dKm5IYbRJsguP5B4bsUfwZdH/72BYRIh7Txv8363y63ecfgYDsMuxVeWU3dUtvtj8cWfzsMg3qt9K9DBg+V0HvLDA9hjLrMqGl4ySai95R3+7sw6xZ4mYqXGrHREPj66EJXzNZUY
 U84kkp/E
 oYQqfrzQOQbVsrohbvswSFLCu9F8Kbb+spHKBuuGzaNRWHNU1YaYcmRwhdoZRDiM9muRiVlTGjQMzlD2K6DGNO2R+1Dbbu/bgNVrxetQmlHfEqxbAoolEG3X4PBfdHdcnophpi9WjwNkWjsArKNrjB1hZcQDZiJGWSFDCRoEch0QG9W9yZhUVC7YyMRbzqAbfMAXsVU8LyOnpquaKeC/T1vGxiM7vpDKft8omUI4f17dAFNYp/uPgKVMVGGP9jh/b5S4idPCqcbAFhBwwyE3kjEHVhNqfRmuHCEHAcsAqC1xuB289KWj25Biz5TZ/aofwZDRfvyRPfRACIlx4b4977V5sgLafU3xYmUrjDc8p1RcAiKmBU0EZwZdRpAUTctf0Fc9UapLvaelqPTiWMmMhe6kSekahiuigw6dm7OXHmkYctWGfRWRH3ut4BLcYTcT7e2ICRS9VQJxQ5Lf8KaAJlFdEtd+AU6CToLJkp1XKp+UmA4I6aVr1BtCfKYxmJ9Tt/yEo+q9grzvmaNQTZmTnCV4tGn23RT6K17vX/w81PU7XuMURF5N13BEGTO80LYBmP4e+ISlgd5eAcBgEP5dVoyoUW3HbGKowWOx8k7HHrXNxndF27YM1j6gKvz8Fb1zho03UgBShrSkkIWw5XJMs9fP9sJNw/yOT/ZyFHDBwyPE4Hog3ZbgmRaEUpBNPcHGZbI2WGOOmKV6Tt09/cpswyJwtfe09mydSRza+YP0wjub1oryVp4i03c8TeaUaeVa9ecDFBjsger1WssmGIvyIP5vhHydcssMdbiMOcwe2cYkuLYbh1JEccLOKETn2VIApWfMFP8JhNyvTJtOJ0rx7X2G43+V95SXCcS6oQvj85KsymfhNqR3CpFfdaCNftSTFAnh57cxs5qieKGxdn/AObaiGhR0UAf6dhaJQIJ7VEWaGMw5ctZErhXHDJJ4SNON0w5f/AANLrcWUEMVwkIKC4wOaZbGv
 V0yPsk4B
 ddQMS4TePlblvgvPtxljSvGjQZKzvKenYdOaflDFJ0YZr8Wl3Oj8kSViBo+eefxbtRX11AEKyGfJzM7QqHn/EZgf6HtL2B1SldWvvIG5MXaSCpno9Ep0aHnrdaoBbignTCAP/9SFlsFyP1fMVfAEHvjSfkWGRc7ACZHU0k3MgmmlwW/zHnsERsPmI7hZD6G2a6sWzCjOxDeSgMD5Nbbm7c/FG+LK/QRgi+YxzkuESVzsSRxTxPl2GqTBWBvQhcsbCVNmdwQErdGVT1OdqugnaH95tCdmZxFe+qPti9xUfPxF52WETV9416dDEooDhz1ncvhH+L0TkiPDotEpiY67B4w5m+yUvekNBVLMgQHtUiWIs/cyR6lVnPT0JINZG5Ttgc1tJpSaBhPcJ2jr7bNQF1ReiWEygYY/a+rmDM3pXBkYk6I/m4XYdfhYt2NNsJhtNiaQ56bOM7lMCYWfvwSBidp0nedMqLET
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    43cfbdda5af6 Merge tag 'for-linus-iommufd' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17711906580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8195c5b22e79c2cf
dashboard link: https://syzkaller.appspot.com/bug?extid=db390288d141a1dccf96
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14cd78ce580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161f82d2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/848e46852283/disk-43cfbdda.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/24283dbdc318/vmlinux-43cfbdda.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f91b3fadd31d/bzImage-43cfbdda.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com

RDX: bbdccba4532b703b RSI: 0000200000000000 RDI: 0000000000000000
RBP: 00007ffcde93cf30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fa5dec15fac R14: 00007fa5dec15fa0 R15: 00007fa5dec15fa0
 </TASK>
HugeTLB: unable to allocate vma specific lock
------------[ cut here ]------------
!vma_is_attached(vma)
WARNING: ./include/linux/mmap_lock.h:435 at vma_assert_attached include/linux/mmap_lock.h:435 [inline], CPU#0: syz.0.17/6011
WARNING: ./include/linux/mmap_lock.h:435 at vma_mark_detached+0x198/0x260 include/linux/mmap_lock.h:455, CPU#0: syz.0.17/6011
Modules linked in:
CPU: 0 UID: 0 PID: 6011 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:vma_assert_attached include/linux/mmap_lock.h:435 [inline]
RIP: 0010:vma_mark_detached+0x198/0x260 include/linux/mmap_lock.h:455
Code: 01 00 00 00 89 ee e8 57 5f a4 ff 85 ed 7e 4b e8 0e 5b a4 ff 48 89 df 5b 41 5c 41 5e 41 5f 5d e9 7e db f3 ff e8 f9 5a a4 ff 90 <0f> 0b 90 eb 95 e8 ee 5a a4 ff 90 0f 0b 90 e9 04 ff ff ff e8 e0 5a
RSP: 0018:ffffc90003396df0 EFLAGS: 00010293
RAX: ffffffff8220ba17 RBX: ffff8880536f8500 RCX: ffff88802baf3d80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff8880536f8583 R09: 1ffff1100a6df0b0
R10: dffffc0000000000 R11: ffffed100a6df0b1 R12: dffffc0000000000
R13: ffffc90003397130 R14: ffff8880536f8580 R15: 0000000000000001
FS:  000055555c863500(0000) GS:ffff88812522b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fb63fff CR3: 00000000325d8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 vms_gather_munmap_vmas+0x6ab/0x1380 mm/vma.c:1458
 do_vmi_align_munmap+0x2b4/0x4b0 mm/vma.c:1595
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 do_munmap+0xf9/0x170 mm/mmap.c:1067
 mmap_action_finish mm/util.c:1422 [inline]
 mmap_action_complete+0x480/0x590 mm/util.c:1491
 compat_vma_mmap+0x243/0x2c0 mm/util.c:1280
 vfs_mmap include/linux/fs.h:2072 [inline]
 shm_mmap+0xda/0x200 ipc/shm.c:607
 vfs_mmap include/linux/fs.h:2074 [inline]
 mmap_file mm/internal.h:168 [inline]
 __mmap_new_file_vma mm/vma.c:2496 [inline]
 __mmap_new_vma mm/vma.c:2562 [inline]
 __mmap_region mm/vma.c:2771 [inline]
 mmap_region+0x1ab2/0x2280 mm/vma.c:2856
 do_mmap+0xc39/0x10c0 mm/mmap.c:560
 do_shmat+0x8d8/0xc10 ipc/shm.c:1662
 __do_sys_shmat ipc/shm.c:1698 [inline]
 __se_sys_shmat ipc/shm.c:1693 [inline]
 __x64_sys_shmat+0x9c/0xf0 ipc/shm.c:1693
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa5de99c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcde93cec8 EFLAGS: 00000246 ORIG_RAX: 000000000000001e
RAX: ffffffffffffffda RBX: 00007fa5dec15fa0 RCX: 00007fa5de99c819
RDX: bbdccba4532b703b RSI: 0000200000000000 RDI: 0000000000000000
RBP: 00007ffcde93cf30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fa5dec15fac R14: 00007fa5dec15fa0 R15: 00007fa5dec15fa0
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

