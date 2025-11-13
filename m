Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1701CD8CA4
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6038E000C; Thu, 13 Nov 2025 11:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555DA8E0002; Thu, 13 Nov 2025 11:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445478E000C; Thu, 13 Nov 2025 11:44:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC208E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:44:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3A2A1A0A55
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:44:35 +0000 (UTC)
X-FDA: 84106157310.09.E1F8EA5
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F0A4C0016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:44:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of 38QoWaQkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=38QoWaQkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763052274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=4hWwj6fy0/rB4RTGq3xc0Fnf3TBZ5FQ1+cI6MAHTftw=;
	b=b8qRqg769ZZqNH6kDfIXZp51tfxXfsnZzqEjSBF4xFDb9zIV250vjFVC2AiJHYXn72pkPA
	qNLBI/3PGRD/b9FNWhFal4Zo5Q/npIK+GVUVqrZeYG08UK56KUHTgoDWs9lgZ3Q68ZpzZF
	kYr2mNnoMtkvDEe/VHeVJUbOAUwy5WI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of 38QoWaQkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=38QoWaQkbAK4gmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763052274; a=rsa-sha256;
	cv=none;
	b=5qQUCt/V01lhUxPhbj9qi1he1GL/P7Btb3QDSgKL6NeOTBhnQbo3/l3z5+l8QN7J2Z7jFa
	kAuNBuP6AC4BMqmQ8zlM6RLD4I1bb4EGisWWMj3pen0wdCEZCv6jbDsUmF5xLRmdL3lWss
	Wq/cAhbl40ht8qRMIR2NNh7kpons0oU=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-43373024b5eso12600545ab.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763052273; x=1763657073;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4hWwj6fy0/rB4RTGq3xc0Fnf3TBZ5FQ1+cI6MAHTftw=;
        b=BxLvEY8LAi1z+AtHipAJwE/althw/Ut3jgcyxUhb6ndf9a4W8HxLCaiVF4N8bUpuhO
         iIW3xaPZJK5HMXEMXEMXjZURtMZIWoJrKcULuIQ4dcj1N4T9+/oP+FXxgC9UG2xnSIox
         MZN0zOHCXSgOaBT8C8tr/4pQXaJ18yAOLzz/t4n83NOa6S3reHEytwf77rcwT3lSy/J5
         1GcbBqSK49mwcY5mDCLZ8X1UnktOQN0n/vOth2Y9GAYO9g5MJHZFipPttUfCO/866K9Y
         33oVtSEtdmkvHa/V6bcAO6pl4ApPncF+KgzfcERb+aJpaQJ9IKB3avvq7yuFUwvQq9V4
         EHCg==
X-Forwarded-Encrypted: i=1; AJvYcCWlQxc7Dfqi6C1PQNR3winc4c5xdB6+tCwNeo5m9woD9L93XHM/evPhAtxOUvcvy23OxCCgHSREFQ==@kvack.org
X-Gm-Message-State: AOJu0YxHDSExl4Kl3Qm5ChtyWPtsK9Lzh/RS57WaUUWE73sKAsholY1t
	+QKrMyv1EYwE9fTcNGpy7SQG3MINgEO7Z/KVm6lSoQwpetHKpkTCazU+z8AXNApyVgVXmdPEMgN
	/Vb+vdx7c3V7C70KPeCjve1czNwj5NdrRDfoloeWRJhYJHXOjYIWZBt+wxds=
X-Google-Smtp-Source: AGHT+IHre4HCgG9GhvCzJ0gFY0mlLiuN0+e+eYoIL2GvRl8FPVjZMC7Eur1YKvNmwVrxt2BFGjOPilXW+o48jPUq2OZKPCwspRhH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a61:b0:433:6c42:1817 with SMTP id
 e9e14a558f8ab-4348c878307mr2690715ab.6.1763052273319; Thu, 13 Nov 2025
 08:44:33 -0800 (PST)
Date: Thu, 13 Nov 2025 08:44:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69160af1.050a0220.3565dc.002d.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in __page_table_check_ptes_set (3)
From: syzbot <syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2F0A4C0016
X-Stat-Signature: qqtnza5dekhoo61umqrc9h3o9cwfwn69
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763052274-476450
X-HE-Meta: U2FsdGVkX1/M/D0VzWlZ4DiWuj8ukajo2qG4DNw0ZY+xYKfqI4ygfQrvyVpPwH3W/84TLfcZb8dfwNqJix4Ym96kgpfmgKVFPuhXD/U3SB1JDLeiR0jH/qgegNzOdDp475JYMpyoirG3mnMU2vp2pMCak2IHIDu9kTJWc2lV4TUY8tyBpjmk//CLSi7BofqqXtAN7Cf7Sk50SRtcz8CnFmQ9daML8igroEaHs0pejfNvts95ttOnyum9FmnSNjEn1HdmAtmkZt60sFIQtcoidJR4SJ08hxl6/f4iBPrwp1mmQ3ReWW96LwhFL5yHJcfRndBjEYFits9TN9K+5b29B+jTvrFIJV2H9839J921dES1TldEqDmzSL4iW4MC8r5Fc2+Dwu2jBePvQsd2U+1Ogkwd2Jr2eh+OY/TF2rV3/6fHNQyApSHT2Gqd5/u/BcZuFxDvPL790cZaQ+iVWu/yIi2mAzAcPDZnCGQyhxeUH/lXR2FjSrK4merv+XD0X8cqXp4ExJ+S3r5rmaLUrFCX5wqFA9STW0FuIb7aCr67wXf0LYrWpXFiQDiPSNX9OqecpBiz6S2Y4g4oSFtTAEw+rjyBk8PmL0U9c4vPnOIStrIppD+kf2GV1SZ5USBMD85Yj1Z/PXiCp4qUUvmouNDfVNl/cBj/9guLMFg5DFq9QK6USsvV+V0FhFyB2OavoH3gHuV0hUeezhL3Oyx5gfvvCcpngbi1ybnSDoZf9PWDJyWwkpp0J1W8/Ecb38KC4AtC+0EKEDzPBMOrQ6MzCgWlc/qj1/JZExw+J+Zbp3Nv9sYxaeD1RW7b3N+jdkOuTjtAuCnXQaniTgX6KBDQe3BxrHkc1ii2GrlyOdH1b2mIn6tz+yRNUj8AbcyBx+WgtdWqFmpj2GoRrFxBUJCopcQZI19XP4lHxY7yLwE82eFD6Cw/6U31D+aJrWCb7xVg3BUqKSd/LNHGpsJIi74cHV5
 nMBT7yE5
 10NtugyAVGwux1fTEL4s5HJn94TzMMW6lSVGCY6LjNZ5seD1fo4i1OCR47fxUiRrKGx0u85bnB+FbFihmt5Qflw240nF0RabslsQd5rfEHI2cZOR1WKUOhOnv8rbbB+fWweHjcJYM5Nt5r+KOmqhM1EIqWfQ7F/pWg1n+Y4/G3x52i87L9bRNWMu4//suf3MiID3NUILE76ETPGmoT+8p5wB7Z8RAUjlJcgZfgXjZQ76ccU+fQsjvljq7011wCN9viBkdGtTCZZPVmXCLsJC+7t1DLroerny3Sd8zKsJ0aeQLVM0K3Sb9UKOgTCUUnMiAL/HuQ9bmNPgIymnqbYYrhvkguxJ63g4BEMqslICZQhj19QhKttxua86n1OyPmIpFQtJuEi02zpSyu4+sRX7RS9pN0vqMNlX8/xPC7l/N/lJ7CIM4IiOt7Q8Cs5Uoh9UFydVgdbzBkA657KGF+DxEnCNTmHwcj0cr+f+uPTbyjG465ihAFBDe03ma+KQla/ZYPBEO5GeVSmId6SMH8kEqjeAmdc8d9Qc9JUaW0BaYnV2RLR0ne802MleOwev/zeDw6jEIgGerCnE2tcb2lbicREcsTpeU+G4JMmkJlPk4k8k/wEWFUlO+/SyuvlUIYVav0lIxA7yCYFuNDQyT2seixNYMMtNZ7vZkYH000wZlzZdCmoulAo+TywrdNSzF0Hc4Ow1Z7dfKFTgbSbNns/tq8lDTPhbujtfXpMnrSFRe5Haa8mvKHRdg54HQX4ESjh4V2am1p2YE1Jwv9McDKEi4RGgFUX2ql6CAqz2798cQA2W/WfFeylVjDhoo7CfeEfR1OmMcE4yKD/+VPru5IKxq+F3GSb9cfZnvjNUFdwoB40LlmLzheJCy6wOWW0N1LjTDx1j4AwrN7ea35LXWMPeoUvw0dNYbPKTekydEsb7rjwGSyIesX9qFY5wnjbP2cOZsIgiljd1HxMx5cg7zotWSnMBLLcPj
 zuS4ih8G
 xOEF5eF9S6wKJOjfQaFHfoxQ5cerCGa91UaE6qTs+g/cQJz2XlNJD6KzjZr1qCH28ES9C9MDHyC2Xs3CsWu3dXtVGTpwUX8wx0uDKUle8XZMX3jjdtz4dR5VmIVdAy8wn/LCUELClvjC9kNJLNJeqiZx0wRCkjqnB2AOaOZrbRQz5XF/m2C4HpA8rdnNi/YxL8fC8g6icmURAJqZRrj9YOulC4efCsYm17PHrgnwV4PR6zLdd48kM7We93j84hTr8vTwPjlJb5jI5CNqII0TH95Dj4nAGkytoP2JZe3/zPxNndLGmJi11xOq2Vc7iKYlSEHWUuh+kXUAPzvq3nbjJoR1yvsExADFwnTmcbe9F/tVhGLzNosgUIE5ATgEitvaYg9ukJZUvbUVIWNz90hDxrActISeUp2hHy7jp8z7Zx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    439fc29dfd3b Merge tag 'drm-fixes-2025-11-09' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15484412580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e46b8a1c645465a9
dashboard link: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/87634fccbb6c/disk-439fc29d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d7897eed027/vmlinux-439fc29d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/388814b7d484/bzImage-439fc29d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 23212 at mm/page_table_check.c:191 page_table_check_pte_flags mm/page_table_check.c:191 [inline]
WARNING: CPU: 0 PID: 23212 at mm/page_table_check.c:191 __page_table_check_ptes_set+0x13e/0x2f0 mm/page_table_check.c:204
Modules linked in:
CPU: 0 UID: 0 PID: 23212 Comm: syz.0.4613 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:page_table_check_pte_flags mm/page_table_check.c:191 [inline]
RIP: 0010:__page_table_check_ptes_set+0x13e/0x2f0 mm/page_table_check.c:204
Code: b8 00 00 00 00 00 00 00 70 49 39 c7 74 21 48 b8 00 00 00 00 00 00 00 6c 49 39 c7 75 1d e8 3a 29 8f ff eb 10 e8 33 29 8f ff 90 <0f> 0b 90 eb 10 e8 28 29 8f ff 90 0f 0b 90 eb 05 e8 1d 29 8f ff 31
RSP: 0000:ffffc9000fd27990 EFLAGS: 00010287
RAX: ffffffff8230ea9d RBX: 00000000397c2c67 RCX: 0000000000080000
RDX: ffffc9000c8da000 RSI: 00000000000042d3 RDI: 00000000000042d4
RBP: 0000000000000001 R08: ffffea0000e5f087 R09: 1ffffd40001cbe10
R10: dffffc0000000000 R11: fffff940001cbe11 R12: 0000000000000001
R13: 00000000397c2c67 R14: ffff8880525baff0 R15: ffff88801a05ab00
FS:  0000000000000000(0000) GS:ffff88812613b000(0063) knlGS:00000000f54bdb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000080ffe000 CR3: 0000000077a7e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 page_table_check_ptes_set include/linux/page_table_check.h:76 [inline]
 set_ptes include/linux/pgtable.h:292 [inline]
 do_swap_page+0x5248/0x5b20 mm/memory.c:4970
 handle_pte_fault mm/memory.c:6180 [inline]
 __handle_mm_fault+0xe55/0x5400 mm/memory.c:6318
 handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
 do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0023:0xf70ef1f0
Code: 50 6a 00 e8 c2 10 14 00 8b 5c 24 2c 8b 4c 24 28 83 c4 20 8b 55 40 89 03 03 11 85 f6 74 18 31 c0 8d b4 26 00 00 00 00 8d 76 00 <89> 02 83 c0 01 83 c2 04 39 c6 75 f4 83 c4 1c 89 f8 5b 5e 5f 5d c3
RSP: 002b:00000000f54bd540 EFLAGS: 00010202
RAX: 0000000000000800 RBX: 00000000800000c0 RCX: 0000000080000000
RDX: 0000000080ffdfff RSI: 0000000000000efe RDI: 0000000000000008
RBP: 0000000080000140 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	50                   	push   %rax
   1:	6a 00                	push   $0x0
   3:	e8 c2 10 14 00       	call   0x1410ca
   8:	8b 5c 24 2c          	mov    0x2c(%rsp),%ebx
   c:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  10:	83 c4 20             	add    $0x20,%esp
  13:	8b 55 40             	mov    0x40(%rbp),%edx
  16:	89 03                	mov    %eax,(%rbx)
  18:	03 11                	add    (%rcx),%edx
  1a:	85 f6                	test   %esi,%esi
  1c:	74 18                	je     0x36
  1e:	31 c0                	xor    %eax,%eax
  20:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  27:	8d 76 00             	lea    0x0(%rsi),%esi
* 2a:	89 02                	mov    %eax,(%rdx) <-- trapping instruction
  2c:	83 c0 01             	add    $0x1,%eax
  2f:	83 c2 04             	add    $0x4,%edx
  32:	39 c6                	cmp    %eax,%esi
  34:	75 f4                	jne    0x2a
  36:	83 c4 1c             	add    $0x1c,%esp
  39:	89 f8                	mov    %edi,%eax
  3b:	5b                   	pop    %rbx
  3c:	5e                   	pop    %rsi
  3d:	5f                   	pop    %rdi
  3e:	5d                   	pop    %rbp
  3f:	c3                   	ret


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

