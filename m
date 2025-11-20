Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87208CF887B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A106B009F; Thu, 20 Nov 2025 11:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA2A6B00A0; Thu, 20 Nov 2025 11:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8C16B00A3; Thu, 20 Nov 2025 11:41:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5F3C6B009F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:41:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4ACE2577E8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:41:34 +0000 (UTC)
X-FDA: 84131551308.18.7E911D4
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8AC371C0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:41:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3u0QfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3u0QfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763656892; a=rsa-sha256;
	cv=none;
	b=cAen8Q/Iiwia3gGxI5M9y5HG5F19Ipy+af0MYy+XIHvjwhWKCo7+aFrgrBb/F/RY5946IK
	8ksYLe2iGVizWresELz7fw5jl9NmmQqymJHOF6GfXBkrGnZGM3RR5wSM+qmB28vwIBjEMf
	LcFpcPFL7bw2GFP219mUED1AyuPrO7k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3u0QfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3u0QfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763656892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Y7iRowFGRjjOjAPTye6nCdxrnXCPwf6zOpBlOyrSH6Y=;
	b=afY3thxTDHnPaVdTKAAf4VQb/CXCwu1LR4xwKvey0ZhwF2Q9oNgod4Ey/J+UIyCXd+jv7i
	ukWEM/EU8ms8L7HCEBsoHDVE6tD4uJLOoFZ/6Tg04N0BD1PuwkfLf4KQUI+8TA/It2ElNO
	et2972q95D94q0ZM/9FZQj5OGVrk7tE=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-4348db9e727so10837095ab.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:41:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763656891; x=1764261691;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y7iRowFGRjjOjAPTye6nCdxrnXCPwf6zOpBlOyrSH6Y=;
        b=pu44OFrcKx5/qpcEBftAiJ8qe4hrCSU48y6R2LzJeXAl8ePxZZNWFDkxzq5sZCGOei
         284wlF6KNi9WKe8yIEsQJdrePJVlXlZkYNHAjfceSSx0tc2neDFoZGMIkhqpLIuT5t2G
         QZdXJUsk7kc5KYM9AjW8krYDgLfNAu4j+hCrcMYEKb0fFeDE8YTBVSSjQlOtMJAZpco+
         irpOZEi1KT04eqECKUhrNE/lmof6B32Q9R/dK0BUzG5y+bC/kb+e/QcUeV6Yeh9Qg3uB
         oamhlEFa9669wP+G7+DIJ6DZFr6Nai2AWoiSuYMgtMmD1jq3D14+bjLYj/XywyB24+Gn
         26bA==
X-Forwarded-Encrypted: i=1; AJvYcCURqixjuQLD919bZxGqfuafb6lf2ntOYQomM9lKhLUwY/J6P0BmVQnBayVSBqTQKvsqmfkh+fws7Q==@kvack.org
X-Gm-Message-State: AOJu0Yxrx2Eg+SQyRC0qUMBeCuPoeg2fx3ToNV8qxXlXuXmBu/3wSfq4
	GbGV49UumnqE/2NVZO3GuIpvLP5ayrMbx38WUeNl1fkNTfwh9zsKcgGSrpmZPTisgi9TgzqSJM4
	wLWoCBPzJkRvkuZ6P1BzMD8WpthFzMSLptRb3fmyReENNE2OeIeqNgt7EQ+4=
X-Google-Smtp-Source: AGHT+IHomvNmuHjgaEEmUek0xiXlaU4iCMkSx4FQrkEX2c0/bL9WA4OeZT3a6ENP0aquXhKZqb1EkyKpSBLYaq23iYJvj5sdZ+ME
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3789:b0:433:29a9:32db with SMTP id
 e9e14a558f8ab-435a9073140mr31086985ab.24.1763656891668; Thu, 20 Nov 2025
 08:41:31 -0800 (PST)
Date: Thu, 20 Nov 2025 08:41:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691f44bb.a70a0220.2ea503.0032.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in __folio_mark_dirty (3)
From: syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8AC371C0011
X-Stat-Signature: 9n69mno3571jwp9eqoe9673t9w99zq47
X-Rspam-User: 
X-HE-Tag: 1763656892-362183
X-HE-Meta: U2FsdGVkX19IvayZhwHkg42g11fub+SqtD9cwi/LE0ibxxImylH0VlOedkb2874W+Ci6kZ1Lmg/jj+YP3Sf1zeR+BrHZWwDIgN1Km1fLVfqoDaE+RhxnZ7XyQjQdNagzGH2dSoCrH+ERXPYYdQETa1kWubeOvZ1bPlxBDiiNmk56yDIqrwl89pzVpE6ysEcs6q7aVxH4WL2gGldzwsGlngG3poJ1EcuBIiIHyH1qo40cMVNvgbkG5WbIROU56MpEriWKmu9BiWlnyPiBdeVEmWP84lDsAnDPHALp/UdgqLi7qB8QObk/p7BbHwetQ1KwJfzrPeJtUDTGN4PI/gyKl6aAI94/f1B8Tx4dhg7cgX4xIA/NA0Fax/HVLBcaEVqn4EuvMRBGwmD7+wE1J0liAQWUDHaLWtqk401KWF9OoIO4Ya0CBj4QiC3PCt1bwqqnERCkunO2n63pfH27pcooUtxiP6AmrLGZnWosxKi/Oa+CU6iOndwbZCFBGL+v/DHPE8lnfSn0lE0dJ+C5T2z1HqynipfEsqZwSPGkp0QF8oeqkqbAaLxHfo3Z3fLTezum/r7q/qJGhc79tMv+FLkZU/gCqpiauDIesuAu8cDiNivWJbVndAyBJDgB2l8Q7bp2O5iS9ygJBkihVqRkyEcKlp8+XUlXpdeXLfxhQ+1m33qtsRx4tOoY+MDxUItrir6NJyvv4nX3o0WJVYfDMSdPYtMV/xuiB1Ykr+8BponzcB/MkCXVFAMUnxrdP/jkOgybxmIyGFckgrSa3eLsrPpnHMr92JNSdcWwrC9anAG0nm9CLclmDG41Hp+GLrOrbpU9/OVgEfxXvnC3yuXPEB941lujF9BtGjqWZyNvASA3xWm1NKIwtXyTLk6i26Rlkop5h93tD8CikVe2qjFyfmp3P1yACMWNCB4mHYLU0G1nhovC/3z/bEIiBR9xOlEM7+F2iviMcOxdMW9M1a9L9uk
 94Z36JgY
 ESg6L3ty4T3X9K35osUEHfY+jMHvVhk41iiCJTRaJSLc9r20ql7MVSEOSOfLCXuMxMsq/8ZdAGAvxh5GDiJR61H5dhEB/6+JZNfq4Rd995htzM5781y/0srJIfKu+sxrsRtEZXvIjFi1QvtDv68PH3KST/ZVKP5AEweEUTxcBopPrjv2kZ9+tXJAkvslawfQTEbhSs3aARYasjcV+e5PBGxZyfkTNLmdLBRu6/M4diJwNXd3EMplUQaGTYsDfuUS0d/cMRMkdQnX4NpSf+PKF5gNXd0JiNF/cQCxV421mdWBx0c71ScUvpYx/X4sOTp/rQWF2ftm+/B2qEz0Ud7/gkMLorJ6Pdbv53NRHaiUa/Hg6VJAz6/EOysP6byNuVG/r1aKeWRcpHDyCH/XCehu2Sm5s1CtAeQ2b4+QjtvXgp1O9zSNPuN82HJgKt+YysBlbMOK/2Uj5EFWHBRwxPxYWLHWew/A3nRjGoH5o6r0w6MvjwEqd8FzQ/AW3pEYVKpqrwKyqifpNBK+iWKeufkQe472mRrDZ+ukXfiDigcEQDXzY9ho+hJ+5sAC7Vma2Q+XnyF7R/q9NKfUd4oV9WS2WnNszoqPw0c6FHStjJK9bCYlSOmxflA0tStMyjvnKISyCFCX1nrN0V9gLon8llIgqg3d1QAB4R9c7tGlnmi8OjtLJswwnF00FPxSXmg1H4mldJZeoizas84r2HaPHsb5povHLbzRKtUoFujXCsQm4bWLVa4Dciikvgw7cS9ZQGGHUUDcLeGnV+m/RB8uU4QFPK3SSSwhWdxdnkzzqzoUmR0TD6Exp5U5yilkHvXCPpG7gkJ3DfNm5aNHgJwn4kzBljUr92AsEQqIGf9TSKdOzEjG8CU+5aHrbhiERC3WiH5KOu8CnL8+omvDJPoig3jCaMQ0/CIHP5uZlr7f5QodNTWS1N4srWmOOp2foiL/0BwdQvRF+0/7vhwBtY942IFrAx9arGjk3
 drnR4Dwi
 0wYkxvmgbQT0D/1SQhIYV1SODHeaAyAeRF/CSzA8acVhLndWItdJPUU9VWI05wb824RC+72/yz4IMM63b3Wb2BlE9pQc4hhq6z5WDh0XpgqROi3KNu+DyfUgId+hfVxPlwNOtV+0xAgoM3o+qttkgjOntH5xQMxOL7hQsHtbK2kYQjj12aFZXZ5LEyZcFx6YLJU4vrkj289ao0gPtFk0+6o8Y0q2qjz7kkAPE1UOZ1aNby+zLeWSluKUCJdkQrFySzRzlQyE6on6Z+wKa8iE3JxQj0E/08HR0DPjyh8q+JDLRxelXg/yecM8VqrqIUFu/Gi11vU60FdctRFdwe9M8gMo1nO8XJxQpeekokb79Gw9DV9etSVdkvLe7zMWJlZwH+tfKiEDmqzJbT8W91sqgrl9WdRSKPDgPEN7qTRoOYTyzvC8ppVxwoxSQYy/UGeSA5KogldAdEsGvJ4S802ximW8++yNDJyHaRGv/SVG9ohagQWzxr5HaTizqQA4NhY5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    23cb64fb7625 Merge tag 'soc-fixes-6.18-3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1287997c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
dashboard link: https://syzkaller.appspot.com/bug?extid=b0a0670332b6b3230a0a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172cd658580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15378484580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a14ebce6c664/disk-23cb64fb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7703c3032e2f/vmlinux-23cb64fb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a16c5b94924d/bzImage-23cb64fb.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4fa9525269b6/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11d42a12580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com

EXT4-fs error (device loop0): ext4_ext_remove_space:2955: inode #15: comm syz.0.51: pblk 0 bad header/extent: invalid extent entries - magic f30a, entries 2, max 4(4), depth 0(0)
EXT4-fs error (device loop0) in ext4_setattr:6050: Corrupt filesystem
EXT4-fs error (device loop0): ext4_validate_block_bitmap:441: comm syz.0.51: bg 0: block 112: padding at end of block bitmap is not set
EXT4-fs error (device loop0): ext4_map_blocks:778: inode #15: block 3: comm syz.0.51: lblock 3 mapped to illegal pblock 3 (length 1)
EXT4-fs error (device loop0): ext4_ext_remove_space:2955: inode #15: comm syz.0.51: pblk 0 bad header/extent: invalid extent entries - magic f30a, entries 2, max 4(4), depth 0(0)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6107 at mm/page-writeback.c:2716 __folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
Modules linked in:
CPU: 0 UID: 0 PID: 6107 Comm: syz.0.51 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
Code: 3c 38 00 74 08 48 89 df e8 52 a7 26 00 4c 8b 33 4c 89 f6 48 83 e6 08 31 ff e8 d1 ed c4 ff 49 83 e6 08 75 1c e8 66 e8 c4 ff 90 <0f> 0b 90 eb 16 e8 5b e8 c4 ff e9 7e 07 00 00 e8 51 e8 c4 ff eb 05
RSP: 0018:ffffc90003a079d0 EFLAGS: 00010293
RAX: ffffffff81f9c4ea RBX: ffffea0001213400 RCX: ffff888025260000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff94000242681 R12: ffff8880416cb4f0
R13: ffff8880416cb4e8 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000555587ebe500(0000) GS:ffff888126df7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000440 CR3: 000000002e288000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 block_dirty_folio+0x17a/0x1d0 fs/buffer.c:754
 fault_dirty_shared_page+0x103/0x570 mm/memory.c:3519
 wp_page_shared mm/memory.c:3906 [inline]
 do_wp_page+0x263e/0x4930 mm/memory.c:4109
 handle_pte_fault mm/memory.c:6211 [inline]
 __handle_mm_fault mm/memory.c:6336 [inline]
 handle_mm_fault+0x97c/0x3400 mm/memory.c:6505
 do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f385fe87398
Code: fc 89 37 c3 c5 fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5 fa 7f 4c 17 f0 c3 66 0f 1f 84 00 00 00 00 00 48 8b 4c 16 f8 48 8b 36 <48> 89 37 48 89 4c 17 f8 c3 c5 fe 6f 54 16 e0 c5 fe 6f 5c 16 c0 c5
RSP: 002b:00007ffd3b8738f8 EFLAGS: 00010246
RAX: 0000200000000440 RBX: 0000000000000004 RCX: 0030656c69662f2e
RDX: 0000000000000008 RSI: 0030656c69662f2e RDI: 0000200000000440
RBP: 0000000000000000 R08: 0000001b2d820000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000009 R12: 00007f3860115fac
R13: 00007f3860115fa0 R14: fffffffffffffffe R15: 0000000000000004
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

