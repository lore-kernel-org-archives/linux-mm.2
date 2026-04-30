Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F31CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 06:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F186B0088; Thu, 30 Apr 2026 02:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900636B008A; Thu, 30 Apr 2026 02:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8168A6B008C; Thu, 30 Apr 2026 02:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E64D6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:59:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9C171604C4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:59:27 +0000 (UTC)
X-FDA: 84714321174.09.0733F2D
Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	by imf11.hostedemail.com (Postfix) with ESMTP id 02D0E40004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:59:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 3zP3yaQkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.77 as permitted sender) smtp.mailfrom=3zP3yaQkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777532366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Oic2aoUcY1yLhBuBjt5P+WfOxcjr3hRGgf3oIt3GjXw=;
	b=RZ0HBZJOtQGV+4k5MOsQ2/8MEqjXXD4USHiiivXb4Pb7xQEJtsSFF3fGQ6KX2DA9seMUOB
	4Yh9lpsusfmBbazNHMRQnsI8L35dbCbb464am8zJftkNfEiTdhQmWWEbxi2ClL1VycQ2QZ
	J6jb/flkCUNOIIgpoHyUihS+tzlTVvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777532366; a=rsa-sha256;
	cv=none;
	b=tET/px5MHV7XB3oPPIOd5NxyKWHELp2CT+vsc7u8FUSrOdTHgBf0ZSK0YXS9DVSt60lTA/
	QGrthrncQ1chy578tgTCcBatf7i0KTsrO9aIAPVwtFYIGmByBIz5a5IiMr5eebGf87eNeD
	w8RX+4fyHjlKRBc+3MJGCN84bI5FmEU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 3zP3yaQkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.77 as permitted sender) smtp.mailfrom=3zP3yaQkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7dbd60b7ecbso1253273a34.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777532365; x=1778137165;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oic2aoUcY1yLhBuBjt5P+WfOxcjr3hRGgf3oIt3GjXw=;
        b=a6BXUNHwqhBOVwQAQVnraHfgLWNQvJb4ngmd+teQECjJ1hogkcutm3Kn4PbUb14nOo
         Ybd+ezS2DkfpWU/+zA0Y9B5zg6q/iuyiguYT8Qo+mjCBqsQI146PL9jVtv4YwFpC+puM
         y8+rN8Awhr2EubCe6RCfs6+ct6TkNeGjD7k5u+Xy52STB9T1m0s/EvLnR/sCkChn4W3m
         7nnmYYjIU+NAALDt+MBlseTnsxJFb02Bm9++Tl0tiEm/abZp8n0g4fyj84xS7Mzv6Jp+
         icKn+zU1QPdR75nBABmQpyVUKeNNFQLCS84Is8LSWoYMSrJqmw2Tw+dk7HEaXi2c0bJM
         fYxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Dfp/lt2tidycmRgG32BPU7S6DckrXxeucXr/KlTaL5o8qFLT2I3T2x7ja520qBMjq4RMuouIjVw==@kvack.org
X-Gm-Message-State: AOJu0Yygn7ayiyKT/GTahF2jqXslnxijsoJULKc6R/yvCtki+eJlX7dF
	W+kUhjWdZU+qFBORcOZ47N8aCJvFdu6rkmQwc11ed66fmtqyVr38gB/qmtRy3gzevmJ3vzlkArC
	qC3ontOGAyFXIYX+OJJ2T1aSAC+PUEMTcMPDh3FJ2/PxvBJV9Thn0d50ggio=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3101:b0:696:2a7c:40be with SMTP id
 006d021491bc7-6967a4c44abmr759064eaf.10.1777532364800; Wed, 29 Apr 2026
 23:59:24 -0700 (PDT)
Date: Wed, 29 Apr 2026 23:59:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f2fdcc.050a0220.11c491.000b.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in __page_cache_release
From: syzbot <syzbot+ba145f7f5f26bf2a11a2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, chrisl@kernel.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, youngjun.park@lge.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 02D0E40004
X-Stat-Signature: gdejf9cuadw3997by6z6qfc74gjiwb8c
X-Rspam-User: 
X-HE-Tag: 1777532365-662570
X-HE-Meta: U2FsdGVkX18D6j/YKBMzDP8zxDw0/UHMnkQq9J6DUqfdhfpSEBBsPKzXdXgJkFnRuXKvx+01RqXyMzHRPmqoa8quGmDbNncaR9Q6wz6C1ItX+ygG5R2burPTVSU40m4Ge7oF8kVA3zUkqz8v405t2kIvBqn2EmvfO9iJrY5VuiyfCg3UcxldfDcCsp7JhhkA2u4k8P/BTx9y7EyXD+hkQpa0bmaSBndyaZy8gBIHspt5DWBfpfX/QP48pNM+KCm0Pm8DLRzgNvhQBX2bQOjju3Izf1tVtWxRqQ/phRH3snc/06gL6fLGEubq749cNl1yS8hFB2lewvvnzB/+VzgPA0Y9I8JJoR8DHPLJo2tdna+xdLfTRPCug908keXObbC8sn4xM1eJXSPMTxBUW5kmrGwnHYGlPxCT5VdBwLE9EeYCOc2U9uAh8xXp3FhPO2R34CDG7JvBYXZg3AodPKIS10SFK7uLFfhnDrintR1KLE0Pk7KWRI7Scm8Jz5xrQYkYKdZbI6CJLeQ+CbQGK1gdDt1HW2qbs97yK/aQS/HC6PvSFp00wiX3dzns2cw8B88cYxg7PxUZewsKB718vbjBZoeklJbQkm4hkho02F8XFPoUUOzKpuJrK7DYqfwFmqRhdskDBpyrLh08pv6Mlquos7rCwIJVj2HgIXy8dspnKSIsDasSzU49cxVRGwWcohwhdUl9kgsGzXxqqrFWznPgdvXj1vXlZGjfeXvwJ0i4vh2N94o3i/8QnCAw279I36UZ8EarZ8yJWkkX+d+VCDxKm4WpF/4VQUF/mwZknugEcZ6N6rDB91kCxJvxILNGXSGEJQsa6RBlmRM9qjJKlFSsfIRF1wXAMg59Vb2pJMf/ZL6noXjfOAYsZHaEjaRgQAbSkp6697RrcXXDTvC5+qhx2S54nJDHM/c5wp2tzIqMqjzhS0gXf0b6YHJnLIcb+WbV5Jw4rBMLPgAc1Rxcedh
 L7pcuZxf
 VIi/iOjkEZWOxz3FcXTyANon0dufHuDkTCb9oCnM4C0RvsXcDKhKece2b2vRQxlGcDkVfKO5QntG/GUC8axnFFI02uH74dZKfnO7icGSOl8jA6DetgHcZGdEfRKp4QdrIEkMUsKcpWmVhT6eJNxIgtL1tJ2LIOVi+SNgTA2fkw0pzIyf0WdXqK45M3GZ64tkA2qfPDpV+SfesUNN3jXWg9tLVdxL/PkU9NQP6PsDlfzQHftEU5EYHKOVDYt2q7rAmuFPicfqXbvfCtkv7EGIOVBkaUP4sbEpTOBiwNM1TCsuXOhIqc/yPij09CX/3+D9PidxPwBjj9DDJWtCpppMP2NDBOoWeLdhMdxCgl+tpEBlr7Q9ynhj2LUf9FbkmjlhS1HFRyVn+tjjA/kUOBnoShms6tSiclwHa7SkD8gymKJGb8TLmEw/7efuyTXzi6AjstZvNP17y6Ugjt6HNY81KvNkKw4K3IPpDxb7gLSlCf81kLhWJ78kj/kfxGYgJtFgScM54A26C8imaAUcJ/6zEfguUArnMz02I2soR/64cFNbn6qD6F4U95kJcrHU3x3CHhMDayldRJWPhVrIH0p24A16fiAWINGf1NvkCb5RKhLk1dcKzcgsKPRIjXFj/NU4BDGXBthkOtRQTIAjBChxLZ/aQ9RBEkNiZrI6DPG2AxtKA3LWxAYBHlEF+L15wIdg23dPqmeHpQvGErOCfHl/HHRCBCK1qjEqCze9w1E2Co1mvWaCzGpqfnIYi4F5cxxXEwPQnamgF8aMvjNLgWExWPzOYnfdIwtv1zWQFt1ev3zll9LVQHWp+iD1r9fTG7d1Slv2Vyn3i4SjCaF+32/hhnysu2r3IWpgYdjQQzQERf6AtgVav0+/aKlDPEWC9QIYtkSv++jWAtVEXtMkSAq67qlJs7QGuGwzqaNaXsRSKzTdVr+a0JQECyZDsImHAEc9CxWOBiUqTLC2N6bHwcze1hx19O1d2
 bRsGS2WO
 CDlEdU4FeAhls1EHAoDWg/8aVXdo34HbRDy/8+SIjnNUEMkECmIoaV2418BwGAWkurRNddrcWhTfimhQGQ6Avc6u4DSU8UgA0qoIU29kQzFzTurallRws9WCNc03Gh+vNAwhviIWeGGInUq2j9gzpTzApWsu1vYPea3wpqH1bEDhAUAlO5DuY/n+x4pIx5qAesA35h7sBLYV5EoEGijOgYdhfI0A4uEn/GoSLZYMpcZu3NyNyGxOcti6UfmKSJ8pFIDpPFzmyIUhvG0IPCmScRHccUPQYj+UuQyNlBU82XMHWVK2eDKoRbYsZbn2jvhgewsxQTePI/7rSmzkjWopKEkSfS48jId7vDZ4MmysyA78eMSagPP9gVuv1oblWLVfXp+xHCgGviRzO6kGGJsIbMKPsEHVEYpiM5cvlzJ65PwAZ/q//U2LJNwFbHAk1yG23EIF4shyV9KLVH082mbc5KQaZzZbQtcF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    897d54018cc9 Merge tag 'fbdev-for-7.1-rc1-2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c712ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f0911eedbc130a
dashboard link: https://syzkaller.appspot.com/bug?extid=ba145f7f5f26bf2a11a2
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-897d5401.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/68d00820c9a1/vmlinux-897d5401.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c1ba47589ff2/bzImage-897d5401.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba145f7f5f26bf2a11a2@syzkaller.appspotmail.com

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:380 at obj_cgroup_memcg include/linux/memcontrol.h:380 [inline], CPU#1: dhcpcd-run-hook/5685
WARNING: ./include/linux/memcontrol.h:380 at folio_memcg include/linux/memcontrol.h:434 [inline], CPU#1: dhcpcd-run-hook/5685
WARNING: ./include/linux/memcontrol.h:380 at folio_matches_lruvec include/linux/memcontrol.h:1501 [inline], CPU#1: dhcpcd-run-hook/5685
WARNING: ./include/linux/memcontrol.h:380 at folio_lruvec_relock_irqsave include/linux/memcontrol.h:1523 [inline], CPU#1: dhcpcd-run-hook/5685
WARNING: ./include/linux/memcontrol.h:380 at __page_cache_release.part.0+0x1149/0x1440 mm/swap.c:77, CPU#1: dhcpcd-run-hook/5685
Modules linked in:
CPU: 1 UID: 0 PID: 5685 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
RIP: 0010:folio_memcg include/linux/memcontrol.h:434 [inline]
RIP: 0010:folio_matches_lruvec include/linux/memcontrol.h:1501 [inline]
RIP: 0010:folio_lruvec_relock_irqsave include/linux/memcontrol.h:1523 [inline]
RIP: 0010:__page_cache_release.part.0+0x1149/0x1440 mm/swap.c:77
Code: 00 0f 85 b2 02 00 00 89 c6 31 ff 89 44 24 08 49 8b 2c 24 e8 29 a8 c0 ff 8b 44 24 08 85 c0 0f 85 34 fa ff ff e8 68 ad c0 ff 90 <0f> 0b 90 e9 26 fa ff ff e8 5a ad c0 ff 48 c7 c6 c0 a0 bd 8b 48 89
RSP: 0018:ffffc900045af6f8 EFLAGS: 00010093
RAX: 0000000000000000 RBX: ffffea00014fe100 RCX: ffffffff82472de7
RDX: ffff888027be4a00 RSI: ffffffff82472df8 RDI: ffff888027be4a00
RBP: ffff8880404a0048 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc900045af7a8
R13: ffffc900045af7c8 R14: ffff88801b8ffe00 R15: 00000000000000ff
FS:  0000000000000000(0000) GS:ffff888097280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1d72d36368 CR3: 0000000052fd2000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __page_cache_release mm/swap.c:1009 [inline]
 folios_put_refs+0x780/0xa90 mm/swap.c:993
 free_pages_and_swap_cache+0x22d/0x3b0 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages+0xe9/0x280 mm/mmu_gather.c:138
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu mm/mmu_gather.c:424 [inline]
 tlb_finish_mmu+0x1b0/0x810 mm/mmu_gather.c:549
 exit_mmap+0x454/0xa10 mm/mmap.c:1313
 __mmput+0x12a/0x410 kernel/fork.c:1178
 mmput+0x67/0x80 kernel/fork.c:1201
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x833/0x2a60 kernel/exit.c:963
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1d72b666c5
Code: Unable to access opcode bytes at 0x7f1d72b6669b.
RSP: 002b:00007ffd91878108 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ffd91878404 RCX: 00007f1d72b666c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000003 R08: 00007ffd91878200 R09: 0000000000000002
R10: 00007f1d72c0cfe0 R11: 0000000000000202 R12: 0000000000000000
R13: 00007ffd91878440 R14: 00007f1d72d76000 R15: 000056441d2c7d98
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

