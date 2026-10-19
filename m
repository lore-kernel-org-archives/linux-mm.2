Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75242606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC596B0355; Mon, 19 Oct 2026 15:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B48F6B0356; Mon, 19 Oct 2026 15:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F20C6B0357; Mon, 19 Oct 2026 15:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4754F6B0355
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:40:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C62D71A0874
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:40:35 +0000 (UTC)
X-FDA: 85340392830.10.B23367F
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D0DCC0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:40:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of 3MXLWagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3MXLWagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792438834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=PBifRyIrgHNKeJNMg4xWZbwNbxc9hE/18PM0weTakxA=;
	b=7wtihVKfKavTmIgaYXjlxxGTBHGojMIikYO+H/1Bh47gawngE8FMmslzaixN2bHNZf9EQV
	W6n7cX2T2TxN5zRCkDsIoCpoCOmzKpgwNnx6hcmyPahSUC0pQF8xyChPNb0JeDWYzTAr5G
	v0CFJy532qZjSsM6NoLzvLYMU8kPkWo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of 3MXLWagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3MXLWagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792438834;
	b=K5abnN++hNXCVOgpLUWn86ErTO7ZJo5OHRKnXRv0MqCB/8VnO9k1NQN/gRiQlXcmoUGWdh
	nbG9xAbG3LuYMRPu7N8ybnbu5r/xz26yd/J+KnHe9zZPNF5MvwrD2+T/F04sUsuSkHIwaG
	DhC9T3K75k8ZokQAVwwhlYCX+fa+lVg=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-540537f959fso2858877b6e.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792438833; x=1793043633;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PBifRyIrgHNKeJNMg4xWZbwNbxc9hE/18PM0weTakxA=;
        b=hAXY31AXqkC/Ppfv6t1vDUlwDkRMXmt5IN71Q4glUyJwdVJ7s+2r9HHMt2vL8OJy5B
         jjzdYJz5kj2eukfpQAictxegQZ4Pnk3BCoOCGIdTZpSRm7QwRCewocbze9w4FaisVw1b
         8TDjf8OwioVD1r1wqXQRn/5BbLsBTtT9Pe5pj8MpIcQCMHOJ9kGgqpx7BmmKwHATqheI
         npzflEuwIdZ7zzi0x5Kt+ede/gjhSA/tOhqL494daWP16gmKu4aI9caVVzrRSKvhdtMp
         5F2N3K1q7hnIktDQKNwMpOFAe5yG7pf+L9D79S2q7JT+4m6Elp7WXC7uQNdRNpen8Cah
         x91Q==
X-Forwarded-Encrypted: i=1; AKwUvBzbb/oAVMzMqwsYxNkeOWdOc+fDZ/k1EZFtAu/Z+ah1fmt/VkTsq1vBlTbt9kn5JnOVtVkl8h/xww==@kvack.org
X-Gm-Message-State: AFq9FYL7cyTETqoE2YJXgrddfbDquTgh9V3w+Ig4/1eGJqGqfWlvH/T2
	+0GE3Rx0/wxDHgrAf741gQ+sPHiwxeIQAvAnbu/3ljkdhilKkSacy1Zne5hiYdEobcHfJS83dGt
	O/6H0Fdut/zBaGsBApa68BnRUzVyhdT99kKS7RhC8XKK/IzPUecUkjJI75I4=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1784:b0:4e6:cc78:edc1 with SMTP id
 5614622812f47-53ccf0036fbmr8290767b6e.42.1792438833300; Mon, 19 Oct 2026
 12:40:33 -0700 (PDT)
Date: Mon, 19 Oct 2026 12:40:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad67231.a20cb897.960b0.0042.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in shrink_one
From: syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3D0DCC0002
X-Stat-Signature: d8e3axdy3rdkzrjzz4d9psghkako4xh6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792438834-295082
X-HE-Meta: U2FsdGVkX1+2xs5l7PxZfOfl/oviwgSO8oTDZ9jjoWlj/hK9c7kJDD007JLpf3EvTM7NUmZcpxsxrdve/p54ENDcLKeb9VhE1rscpR8C62wiQjOngf8b7z7Ge6iSZ2f1DfuSbF8J0uYdE5rThs4+f4ec6wOiEIIvpFV2edtM+vbPFC72Sdgn+R6u7cot0ydxnIxLxCYC2h8IR8HhQaiGdJ6Y7SxucUUgh0GXRIrxZ2Udj3ieciTN6QPWGmZbLg/d0DkWdjHEcBjEbnU+fPI7QMqfR50qjS1l8PBc4bCaWfmSKk4R9IqiOeihranC/oa/kREvGKkhgwRPzjP0yXmtGTVI9Ehem75z+I8NFXhR4j2mqXUwHI4j84EKHT1H+J4fk3wHjrotv8/WLBSJ9ZdGwGFDskuPE6g1cFBUDoIRympqwblPn9D3JTk0GocPjAb8avKRKm3oz57h9/PZrcYJluFPLU8CGPJsg3zUwGvqexJonNPH4mN3qhoQSO2QDKQ0WyXVyyqneDvN8XYbwO6w84O7rwIG1h2l9pmWdwAaS6iBDtfygUMfy9CJkhphOyZABpT6zWVE0CIha8V9HJ7Tgw8fliWsG1ym5lg4jUHTbpd+x6dsUha/RgTP4B2OLcRNIN054cwdbEut5Jmt1KwDTS0GYMOrQmNw/zF7g3Pw8GK+y/CA2W+7UbSoG0zQ8Y2f5yn0fm80fpTar7KfMpZbj0wZHFJNlJqVqvQU8gt9kgdnoVy5B4G4xlHG5S/sDdSHV60CRB8ooOTpmzf3yrOk6iRlnFC7xLtCCvf24BUZzetEfJte+d5GB0Mzvz2Hv2yn6qZCiY8W+4pEdRId2ZYl+Z+9YuZMRxJOj7KKyRIwZ5cdhtTk/byhK0wI0V/mYBrn7tL88R/2iZULmM0XNJcCSnbwNJaf9zQhYP1PlA8sduvNwHQvRns9lPb4nP+sXExRPEgTk+ACxKlr1dtmGD3
 4VQJ7y0y
 U8DYoTui0NX6/J5e8jB4QoWlS7vI8MzPH0yKjokfEHjnGkOYc4AM3nOAA7Kg1TIHmqcng9YC69kInwRatBHWrV+fSouxA30T3asY+DWjWyCx8Szyt5+K5hgsdp03RfwB1pztqbRh6B8z5cfTF3QXhajeiMemISoL+XT2o2yilCPVVVO1RoLJo779ySz7OPYWGXCG5LmxrLKI8dki0b0dZ3PWRAnH+qBUaT7IJCy38AlRysoGZ6TeADPafzo7IZcZjsqD/DTFWpcdWaoRKUn50i3X3hGlJh6FR7yYh4SBgAUvUu6uS1vOh3hNnfg85C+sazok/j3F1z8/pygmf5YQ7uPwzaGEp+2h2QaRrKayHaIoeYmuXH8MSPEKCLySI9a3moE/MySCSRWonCcG3KRqkjxj5mpGNA81kKhS6Lof01v9kqjoemJpZv7zXDhL46TBjFIyXbYe83bbZ/gHbgiKHM881INDNrZnSy8oZMKhXoCAHQrZeOdxjbiggVpXRtxHPn0Qp9/tVaU4c2JlHizm6lsEjTiP8tLRNh0m6a+7dKC8KVFjzOtbon9KbmCgagUkWJLcOF1PPKoJTghciFH/ZcCIQHMjAjdIN8Rpr77uV69TWvL2tj/ryQIqppEH5R/FMpJwRy5gbUk9217MBUk/XPYqzXl/RZ3TYxeGBtFAARU4Fb+/kxHrwfZyvgdp2/Cyz17D46snwUVuDcl6KlIXCIjgPwp5IwcItwdQq9qs5yYEth9EN/AXD+AW/hAnEfrbdvLwBqch1UBs1tl0g4Kg8gJ7UMiXN6hpxw7qDY5UCycf5eZcrRmnNnxK2hGGpnJARgqXk74mWznAXetDRBK6jz6GQJW+eH4NqUgkIoDsih+xpYDw6keKfX6oF6pGvmusAWBrk/FZsRpEfzCmqXUU10C4SIGJQ4WrTMRU+tp1rrwaES1coT3mioIYMRwkmLLH4hq/ATPs27jk8qMf+/Y4gnot4p9ew
 sjp22rnM
 MPA8Hzv/ok3w86LqUvLSYDAZaJ7X6mvcrawY20MibzvY+4c4EoCM5MrSr0nq78wE9W7cFKYyiMNBViqGY4dIOCwXu3psG/RjTsr3qdxshNRMfuPMjCYClAAWZu1tkoigQF5cqIKaTa60MmxLOV87ejAwEOTiR/9O3cILyVaBu/bmIW/lS1Hho9RnH+fyYjAZQ8Kjls7xWznYdSnpK1amm1VOdxuxxgn9cDIKRCXVJjJ0HolrQ5YkbgNCSJ+gVoW7ERziqz7NYFm0m7b84xCWqUQ7R3bjo8D9ufSwzgdad/I4ZA/r20AjZrX+lmVr9y00ywCPmwdolb7Mcp/+CSZO2Hkuk27b/Cj66qq5KBYZ30NyrTmAP3isZsX8OJOY9qHt7JtJAQJSx1K7dMTvNuYCqxrKmUN0XfiO/mKGz0tCdVfP4XLSOtd5O7/ZI6/rOM3fVCGQV8UyLh81EMESu7Mw6kYPw/clF6Be6os+8uHEQcXlpc/Mf4ge7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    a0ff06b3a7bd Merge tag 'firewire-fixes-7.3-final' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12cdb20d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=44ac479246d4559b
dashboard link: https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a0ff06b3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3f4bcbceb92e/vmlinux-a0ff06b3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bf4df8252e54/bzImage-a0ff06b3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com

------------[ cut here ]------------
current->flags & PF_MEMALLOC
WARNING: mm/page_alloc.c:4816 at __alloc_pages_slowpath mm/page_alloc.c:4816 [inline], CPU#3: syz-executor/5706
WARNING: mm/page_alloc.c:4816 at __alloc_frozen_pages_noprof+0x1eac/0x3300 mm/page_alloc.c:5449, CPU#3: syz-executor/5706
Modules linked in:

CPU: 3 UID: 0 PID: 5706 Comm: syz-executor Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_pages_slowpath mm/page_alloc.c:4816 [inline]
RIP: 0010:__alloc_frozen_pages_noprof+0x1eac/0x3300 mm/page_alloc.c:5449
Code: 38 d0 7c 08 84 d2 0f 85 de 12 00 00 65 48 8b 05 c2 6c 1c 13 c7 84 24 94 00 00 00 00 80 00 00 f6 40 2d 08 0f 84 ba e7 ff ff 90 <0f> 0b 90 e9 b1 e7 ff ff 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03
RSP: 0000:ffffc900045465e8 EFLAGS: 00010202

RAX: ffff88802a07a580 RBX: 0000000000000000 RCX: 1ffff1100fffad29
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88803fffd938
RBP: ffff88802a07a5ac R08: 0000000000008000 R09: 0000000000000001
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000048c40
R13: ffff88803fffb900 R14: 0000000000000000 R15: 1ffff920008a8cd7
FS:  0000000000000000(0000) GS:ffff888095a4a000(0063) knlGS:00000000567714c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7159f10 CR3: 00000000265ed000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 00000000000f000e DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 alloc_pages_mpol+0x201/0x550 mm/mempolicy.c:2486
 alloc_pages_noprof mm/mempolicy.c:2577 [inline]
 folio_alloc_noprof+0x22/0x250 mm/mempolicy.c:2587
 filemap_alloc_folio_noprof.part.0+0x3db/0x440 mm/filemap.c:1019
 shrink_one+0x398/0x850 mm/vmscan.c:5119
 shrink_many mm/vmscan.c:5180 [inline]
 lru_gen_shrink_node mm/vmscan.c:5258 [inline]
 shrink_node+0x2b20/0x4320 mm/vmscan.c:6247
 shrink_zones mm/vmscan.c:6503 [inline]
 do_try_to_free_pages+0x33e/0x16d0 mm/vmscan.c:6565
 try_to_free_pages+0x2a0/0x740 mm/vmscan.c:6804
 __perform_reclaim mm/page_alloc.c:4451 [inline]
 __alloc_pages_direct_reclaim mm/page_alloc.c:4478 [inline]
 __alloc_pages_slowpath mm/page_alloc.c:4939 [inline]
 __alloc_frozen_pages_noprof+0xf8a/0x3300 mm/page_alloc.c:5449
 alloc_pages_mpol+0x201/0x550 mm/mempolicy.c:2486
 alloc_pages_noprof mm/mempolicy.c:2577 [inline]
 folio_alloc_noprof+0x22/0x250 mm/mempolicy.c:2587
 filemap_alloc_folio_noprof.part.0+0x3db/0x440 mm/filemap.c:1019
 filemap_alloc_folio_noprof mm/filemap.c:2033 [inline]
 __filemap_get_folio_mpol+0x653/0x1280 mm/filemap.c:2018
 __filemap_get_folio include/linux/pagemap.h:761 [inline]
 filemap_fault+0x879/0x3130 mm/filemap.c:3607
 __do_fault+0x10b/0x440 mm/memory.c:5565
 do_read_fault mm/memory.c:6000 [inline]
 do_fault+0xb3f/0x1830 mm/memory.c:6134
 do_pte_missing mm/memory.c:4700 [inline]
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault+0x150b/0x2f60 mm/memory.c:6707
 handle_mm_fault+0x363/0xa20 mm/memory.c:6876
 do_user_addr_fault+0x59c/0x12f0 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0023:0xf7159f10
Code: Unable to access opcode bytes at 0xf7159ee6.
RSP: 002b:00000000ffdf10b0 EFLAGS: 00010283
RAX: 0000000000000051 RBX: 00000000f73ebff4 RCX: 0000000000000050
RDX: 0000000056792cf8 RSI: 0000000056792748 RDI: 00000000f73f2760
RBP: 00000000000005b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
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

