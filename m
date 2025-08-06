Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E868C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 07:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A856E6B00A3; Wed,  6 Aug 2025 03:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35EB6B00A4; Wed,  6 Aug 2025 03:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BB96B00A5; Wed,  6 Aug 2025 03:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81D556B00A3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:32:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4320CB983D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:32:36 +0000 (UTC)
X-FDA: 83745515112.18.4EBC0A1
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8376140013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:32:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3EQWTaAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3EQWTaAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754465554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=lb9tA21seyZSy4XhKxCHf9LJoOjlvOlQuRKxHDQlfRE=;
	b=UBBo7VHUYMYdYbUWOFyZAhs5ZiQC5WZHnaJmatScjaVvnBvqzF6P4rJc+vaGp/B3Tvqs6N
	km6EA80qt/tiikIVWXkj9pSBUjFSuCrG2YBbsu+FycZsVNUKeZ+BfOvBhgwHmkm26L3SAQ
	9NX1/aGHJgWnZBprTBsvfafQzdJMQY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754465554; a=rsa-sha256;
	cv=none;
	b=z6wFkMsxd1B9FAbv5Zu6xSuYkdnRbQM/LaF5ZPbIRfvwy1Bwi1us9uXLq3QnVE+M6Dn13u
	gDigUT0Jw2H+kgwupCQD0IHgdrntLU3TBAXeuLiohAwXGrp46Nfbqamh/mdSD80L8VsWCq
	0ok5h7d7vf2bO/wSWO7j7myeEemS3Hg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3EQWTaAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3EQWTaAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-88193bc4b09so312445839f.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 00:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754465553; x=1755070353;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lb9tA21seyZSy4XhKxCHf9LJoOjlvOlQuRKxHDQlfRE=;
        b=aV4yoQ6abvMjUvuKtTT1C2hV40l4JIZly7RnLNW7MTnFfD1OjXQ/eTS+H6osF1say3
         S4e8LXbuxEfi12eFeTPBdeHBmv1C8x+n3b93ZeL5My4KK0mj1BraYxA0oU7npslHcMei
         +4bWzoZoiWYU8JUS2cTls1pKYHWMVz4VFmx1CzCqprkgrmr5bYVek1qibhIiy1/UyqDo
         ysqaLHXm6bnS1XnWyPAM/p2kqUnOLwIXv6ftRdlm2z7/hj4OO/KYM5LxR2k8o2+iT/XT
         FYDpVcRf8PZVPvoaAWMkpy6wXplXjAjievWC22hA4ciC9h0YjBkw+HnObnRZGTH1PoQ0
         8ySw==
X-Forwarded-Encrypted: i=1; AJvYcCXHHqGVVRP6mCEH3wjVdi5YG/FpUY3wDzmpV62hH4XajYAokCxuF1ZD9V0c/IIgYkwE8P/Sbt9USQ==@kvack.org
X-Gm-Message-State: AOJu0YwPf6KWDd7FCH7523HfJF8I6BjQHbiBr8rirANG/rS00W5vXUtV
	lEahw8KLlYeE95bL6FD1LUJ9K2LPRfPg0T+wKm2mFtnC+xOAyS9sLEU0ZHPmZM9tilERWg64iJ9
	e9NyE3dIYryHFP9PGadbEvTMrzvGLNkI5mwjvhWAzBrKxYFiy1Jvc60Ee1EM=
X-Google-Smtp-Source: AGHT+IHgMkj4ehltobXHJlvSAm1aoN3egrOJIG7HfILy/IDX3U6of4rQHz1yGGGKmj/O/EjJEf/tyMnbW6EkkcHnEkidxuwKQNhA
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6b07:b0:881:81b7:1058 with SMTP id
 ca18e2360f4ac-8819f070216mr349259439f.7.1754465553553; Wed, 06 Aug 2025
 00:32:33 -0700 (PDT)
Date: Wed, 06 Aug 2025 00:32:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68930511.050a0220.7f033.003a.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in follow_page_pte
From: syzbot <syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	peterx@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8376140013
X-Stat-Signature: n3qsycir3uimw7w8kssinhbk78rx9mh7
X-Rspam-User: 
X-HE-Tag: 1754465554-996610
X-HE-Meta: U2FsdGVkX18rpijmcqG5Hna9ukHXn26a6IRAgQ3cvzSVswAKuXX8dTjBakWBlilVIZwD1LoutpmJhtPD/TyDP+3+q2m4Rue7YIxtfRbR2+QNBCfwEgukO7pJ176hVwjTI4HM51gqTgx1ww6N/Y+Db5xdenkI5VYhKtLbDNrkER3LpFhBnwU2AIp5ylcUBxIqArY4aJvxZwm0ZIrtWcuCWmbK88T1OHo8S8Dpo8UtsHPYvTqkk8c1mrzra4vbiN5/gUBgjcRgrLlonR7fbciJh/53S4YXOsVTetKY0P6jWfCQxA54n/XvNgBiqpPeSuAmj8NJq2x0q1/yP8l9wLzpsFD6Fp56ayHTAXuImbvDbfnoD2sf3MifkpD+OVzaujNBtpxKuryL5ZDnGx+6KxS8Oz3SoArZ58fIAtww6H2nnHQpbmtGvwLjywC0QHU2M6MiK8Ir13yFrg0mz0SOVdKkVK2qL1HD5wlt3utiKy63SSuL3BK9vTOKZC9JOzka/Ro8QaWbTDwteVlEFJOJFlMNZYEh4P6sy0fKl91K+HUKA3028rAoWmh3C8VWdH63Fd3/rkmb/glcQp5+0/p1wGBV/3yonXZK27g0/AfXLCXdOBcb3G7wglatt56S6xBG7qeW/ck/Z2sABAk/jNS0Uo4/4b7drDwxpH/CbS07YHxnIq/76ADchxZfkUFRovz9VfTj+ZqFv5a9TMrFA8FXvMkI13Nok8qVPu2tMdbABKC5wlfz3j5KeUdhaSqRdEGT7T9D9bCTgkYtv+D/QlxARBAuwfe/K0eDKv1caB/mj8/cnI9rXI8YSH2DF+6h1D5dz0eNTsapi2tVPo/YEl2/xd5Wr8lPDhQIgVsZYI9ULlCYZ8aop+YTCVAoSs8DVzQQYZfMPjFAebhNaR7ksmO9evT4uSYquONJnn//3convyJwkp5YPmZ1v2daW5A1TWwPHSdNtOL3GndeWUMOFE6rHhC
 DgFzQmOJ
 EC+DWenyWRmmZFsn67CeJDRNWRx9gd1uZGap1VjV8P3b4Kfb1RtdX6uZOIWnCU5W0Bn2bRAe2eNdm6qn0NpdfEerzQgnKN/sn7ENiC2x3UJ2VCl7k+X0zz7q/Dz5sk/JOVxrRreNDZiwgi21H1ZKEu1i39baeFqE+RE2Dm1uYIX9sGjo0/Kizac3R15ofwsGRHDJKS2XPn27vwRh3S8h3TUeD98zjHGo3+NcmOrrQcsNvKdGHayd/rwProrJjQORQPH8GDNN8MnS8EwEMcwvi8XS3ZbdllU/WVCNQFSFUhFd8ok6+8MEY8/PpOOj9PnSWhLwN/hw7pGlxzvzGafHL+tB6SP8vsCZlWBORrIiK4jBAbXxTULa2qr98bFrQl+U0Ag+quqFHt3VCZe4LDIa7ghz8tqO88N6hJvY16MTbACou8Wp4C117n4REFExLKoC5CETKshVL/y2mE9usC8M8cusdIsJogAlmViuURNKqdudm7/GzQgltTj2SIhvIUpzLPD0GoYRIXs6I6K44YLQznI/GvRa2q24zI655FvMp562005Q6LW7Vb2xLY14VIcgNnQl0WnGkEWKB/tJJ0FczFIKE000P6AVO+9JqL07mQBUJ02RWSoK+EX6WPRzU8VpTOMvZ54NBY5uZA2FctL5h8rYC2SboNw3PkylemUhLqrbbiRsdjOiSFJB0KlukQ4u801Ffn2c0nHLpPdIXJ/XuzsFtv7kXKnPZSrPYMoMVaa8BoNSt2XvuwGMvpDSPvLFZ9fusZNwVAbUPvc+z46QT7JoY7H6hFsGE9k625FhlyS/naAOJhPY1LAH2LpZ7X5t2nAduoMWrB6sFhaj97eO/M4Xj3/g9z8FAyLVclEB7R9pX+VmdpS2f8EpV4eXdfrCwyZ9OuWUDU/ARFyC/H3AVJ/MiqAcBZ0ROpQveLhVrhVh26fU6IF82LpgA47qLlq08+b7Z9y3ig+/A18i+LsQYZrANgLTo
 K/i4D94L
 8E20CdrjaifdDVQkMLv06DXOfjoYSjIwGlqLxVjyEZhVncwPMabX9AC1S6la8wNTbqmnzfjEeznTX4kx3P9Uw+XL8Q/HpUBri5TNTDO6x484WnnDujo+cdMpsRzDPNhfT934MP3nCJQ5egsh7NH1neMsgq3yHiWUoxZTwa18M3WFJOTLxq+k8hlmZqPvizpHX1uwk/s42Oh2XGYcKnEGxSrqtPKDs/wWOI5otpe0SrRJo53bjd2wxNJlAXEElFPPzZVCHF+PTluA3aP+WRUNRPlsb6/1h8XrAJrIU1ngTcMnjdP8di+9mKMLZYHqu6/qLwPCRpBrJNjrEN1cAAoGqlihHKY3jS+md0P8AagRtA+bTvism59YqXYW97+F0j8/aGdnNKotrqA1HCNVYwn7uYzzoYVaf0B3NXtrnxBgQ7W6oXN7K1bgT9oP6kQZeCCoJ9c9l46xyVzU7/+6odJDie4QIAUKOFmGBJbfGJLOlpOkU6Q2OGw9qwN7vuty3k7H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    7e161a991ea7 Merge tag 'i2c-for-6.17-rc1-part2' of git://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16d385bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75e522434dc68cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=57bcc752f0df8bb1365c
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fa96a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1083c434580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/85ce789ac77a/disk-7e161a99.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d1fd8fed61a/vmlinux-7e161a99.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9bd5f709ed6f/bzImage-7e161a99.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com

 do_initcall_level+0x104/0x190 init/main.c:1331
 do_initcalls+0x59/0xa0 init/main.c:1347
 kernel_init_freeable+0x334/0x4b0 init/main.c:1579
 kernel_init+0x1d/0x1d0 init/main.c:1469
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5866 at mm/gup.c:869 follow_page_pte+0xe3c/0x13e0 mm/gup.c:868
Modules linked in:
CPU: 0 UID: 0 PID: 5866 Comm: syz-executor302 Not tainted 6.16.0-syzkaller-11699-g7e161a991ea7 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:follow_page_pte+0xe3c/0x13e0 mm/gup.c:868
Code: ff e8 f8 7a b7 ff 48 ff cb e9 a2 fc ff ff e8 eb 7a b7 ff 4c 89 f7 48 c7 c6 c0 11 96 8b e8 5c cb 1f ff c6 05 75 f7 84 0d 01 90 <0f> 0b 90 e9 0c fd ff ff e8 d7 46 70 09 89 d9 80 e1 07 80 c1 03 38
RSP: 0018:ffffc90003ddf8a0 EFLAGS: 00010246
RAX: 308c9254a9bba300 RBX: 0000000000000000 RCX: 308c9254a9bba300
RDX: 0000000000000004 RSI: ffffffff8dba2d77 RDI: ffff8880322c9e00
RBP: ffffc90003ddf988 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bfa1ec R12: dffffc0000000000
R13: 0000000000080101 R14: ffffea0001c20240 R15: 0000000070809867
FS:  0000555557f15380(0000) GS:ffff888125c24000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000004340 CR3: 0000000072ff4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 follow_pmd_mask mm/gup.c:-1 [inline]
 follow_pud_mask mm/gup.c:981 [inline]
 follow_p4d_mask mm/gup.c:998 [inline]
 follow_page_mask mm/gup.c:1041 [inline]
 __get_user_pages+0xa8e/0x2ce0 mm/gup.c:1444
 __get_user_pages_locked mm/gup.c:1712 [inline]
 __gup_longterm_locked+0x3dc/0x1660 mm/gup.c:2493
 pin_user_pages+0x9e/0xd0 mm/gup.c:3406
 xdp_umem_pin_pages+0x117/0x340 net/xdp/xdp_umem.c:105
 xdp_umem_reg net/xdp/xdp_umem.c:230 [inline]
 xdp_umem_create+0x677/0x8e0 net/xdp/xdp_umem.c:263
 xsk_setsockopt+0x7b0/0x8d0 net/xdp/xsk.c:1409
 do_sock_setsockopt+0x179/0x1b0 net/socket.c:2344
 __sys_setsockopt net/socket.c:2369 [inline]
 __do_sys_setsockopt net/socket.c:2375 [inline]
 __se_sys_setsockopt net/socket.c:2372 [inline]
 __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9ea1cc05b9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc94f86308 EFLAGS: 00000206 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9ea1cc05b9
RDX: 0000000000000004 RSI: 000000000000011b RDI: 0000000000000004
RBP: 00007f9ea1d335f0 R08: 000000000000001c R09: 0000000000000006
R10: 00002000000000c0 R11: 0000000000000206 R12: 0000000000000001
R13: 431bde82d7b634db R14: 0000000000000001 R15: 0000000000000001
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

