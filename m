Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C457C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 20:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1716B0092; Sat,  9 Aug 2025 16:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4892E6B0099; Sat,  9 Aug 2025 16:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F8A6B009B; Sat,  9 Aug 2025 16:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 263206B0092
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 16:36:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADED51DAD6A
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 20:36:40 +0000 (UTC)
X-FDA: 83758377360.30.FA24B7C
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10B5380014
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 20:36:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3VrGXaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3VrGXaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754771799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=nDf+bc2+oc3YTV8U7966QRgfXOKnldRn94ktsfY5qq8=;
	b=di9VZnDqQ2unFuo3zcnJAg5dF/TXsS+t21yZRtraudaQOGODDuj5PHP8imCgI6Ev/lyfMb
	G+ohLUZMnhpNSo9PL6GZ3EhduX4/vWc/RDtIohtuWE2rVFZ56hMTFg8dP9UwEQvCOi4Yec
	EYkj3fD5F7cnOTxwqeV7RgIYZIj8WcE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754771799; a=rsa-sha256;
	cv=none;
	b=Qir5oizMLigV2VAYr2rFBBjJSueZue7ODjQ30uc10OjM61POLjzBE5edFZayUn4/ZcVbZ/
	kwoux8NY2bzp0pH2FN2/pXnuN+vm7AunzVCDI59DpnKuc6pjpNUSqvNEQiLEBTb1Mp8IDb
	/Q+OG5kTfSugB44tANiMXsrQc/GOZ8U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3VrGXaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3VrGXaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-88178b5ce3aso288423539f.2
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 13:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754771798; x=1755376598;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nDf+bc2+oc3YTV8U7966QRgfXOKnldRn94ktsfY5qq8=;
        b=GwlnGmKBsowGEV39a2ah8pZKLdyj2O4UyfhMWprHmwZtFzfpn4tw39RCA/hLQkVHxf
         NQsq+Ok6YjWLZKAGLq1BRkncKVlkp/ch+liLQZfC/wkso4E9tu6xz29dwtp64m+COmDO
         SRxudEsUpzP0XGvitU8QzBZ3F9XarmXeahX6hR3nFkHV4l0i3qOEzSElwuAnN00D4Evm
         r/Lpka3WYuwDgP0goo/po51JsXHFhJIRWxK5aH31ykwUvATvNMnZ0XNtPs6LkRu3z2fv
         e1ghIAl073/CiH3Dj7FTNsGTFTDjUyT8/XepfdQKF2jqn1mZaG3BS7qSDGWi9F2J/xqL
         rbEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlqtvM5pp79CVusz3w85h+AIivh21aaewD9wZV17BgcrRQ5pNAbcBNc96jHpIMz6Dm5ubeFlDrsA==@kvack.org
X-Gm-Message-State: AOJu0Yz+YKuTQ94FETfO/sdpq55lI5N5Ucd+Sgf9NxslGBH6OInriGqJ
	IBwuJQ6aeTx3Y122eRCqM3muK25vx/VU2OZqG5iYVIdHYkXSE/c1KjwwoOXHkHldz3hrmxNoNSg
	ti79FU3ux4dQB41qOeeYU3b3DgYywo135XPcwMtdLUvrxbKp+fjZmp2xu1EQ=
X-Google-Smtp-Source: AGHT+IHQFSE7PgibGZc4mzG1dSdRxoqjCvuZgmSib2uDKcmIvOxU725MhB6gux796mLIQFLeNrEgF5YK72ntKpk+dtHeTPBYqXIC
MIME-Version: 1.0
X-Received: by 2002:a05:6602:21ce:b0:86a:84f:7a45 with SMTP id
 ca18e2360f4ac-883f11ee752mr1129689239f.8.1754771798098; Sat, 09 Aug 2025
 13:36:38 -0700 (PDT)
Date: Sat, 09 Aug 2025 13:36:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6897b156.050a0220.51d73.0082.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in try_to_migrate_one (3)
From: syzbot <syzbot+63859a31071a369082b1@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 10B5380014
X-Stat-Signature: j1yy5mmiuiifsiotbmcmg418fcjdsnkk
X-Rspam-User: 
X-HE-Tag: 1754771798-638598
X-HE-Meta: U2FsdGVkX18qCrd9617SnQwqhqKfh3kU8PgRixlhxYQGKN009m6/ZL/1x9Pwqh81DMWUXgbFgELBQbdfw2O4PpZ09WI0oUgofVUJ1KPqA9EPiPt39xkgpI4AFcczDT8et7fYFpvdV3jPc4XbiEuJ8nCdkWGJFuk73ayVTO1ZH7HA4HYKpbceMc6IONFjGtam+vbjxNkYBaH1brIIFN8E2cSxSN2uCh9DNauUsFe87evApy9n7Hhmv6inbOasILKDTUtgvaCfhA3hsp60Mbd/p901cGzRJDCgUGNAeTX2CdBdqxRo7NckHIRhrtMcJn6wBMSNn2X8YR7T2L4DIB5Fg04jG3P4vVCC/sxvGiHnKYjD8OlEHRDzgCLOkevKXsEIMW6RW3zh1hWy3pccGjvSXRGTJ0knuhfIROIL6X9UKBWJb/Ex8ZcTgqc1r0/m1aIGwEQj3jM6ZxyuEoOpSyXfzwmJGIzssQ8znjYiGI1Gyc9K6m11C8RDx9qni+yOlh/nUAKcAlr/tZotPyMpazxp9PrZRRC6uv9Im7Uk+9IpbjLbVsMwmo6T/UhE9UFqdKOAqj6r1RfIEh5IYMboNZ86T0zWF9PttCwS5Xdt04BUqU+LoLRAScz/lCNu3cq9XttrIUkPxItSL/muo7UGXLMVXOPWeteqd5hMNpnY6lKVIrOPobEkYzehm4sqMAjO9eeMX6I4pbsAp5EufItuu9BUTQA07XB8ZOjXuaPk4xR4KmDHlEA0Da8O1qF05zXqeAXWLKMyJkIYWHVLmddBHVcdtStxJUlkupM2PAhlMP39ocUfrJc214gPlTB99A5HJjfudguuIdNvNQoSe75jGcDO7rXJEzEWG9Up9N8wbT4hyd5UEMLjCqp9nrp/iuBPuE0hXiNlaKoifSvf1eUqnyCVLN0VwSbF7K2TetyBI5r5AzqU29mDzobsobMkqjFrfT+aO+Mn8QJIMCrvo2TxfBP
 /nmciiP6
 tuDt+gmXpUQZrbp4FEnzze2Ei2Pz9cwRZJdlOE7iiJ3ZWLTyaATR9TGjXkEYKhvHI9w0sbjPZxJpKWuVsWUBya+wReJxDfx/LpNjIoaF0el5AQ7Pf0AxOav0uZcg95p4yKyCcRF/7akS3Xu6bhxWWXaiThtfkv3u2zTpwVwV59IB1SRXXulmf1Dad5kJIGYillkgvcM1kZbkOiGK2xfYzjcqq1g4G4gqUp9qtaQgGY3ddwrBST1FN6X+QwAOyt8iXVag27TZWssvn4zLG0oYAt4/EAfHjcb+cEH3jDV46thPf4fhAf0PuMLOSdStmWEDM9Kc0Ww4MduJfsbezhySRUFnEALrT8P1yV5jDmAVGdJ39m9qiCFx0Brdt52TBcKHNvLhBL2kR8dQyT0yrdMO4R8F8Bnhfr/9yEJWFOyx8bnaQu98ZW9Ao5XIrnOtj4VqME/Wza9Bq4ATOeOA3Wk6iBJLJzMzM4jYRewfK82deaZyH5Vx9i2/9wAPGRhKrvxBce94q4vNTc9EH25JAac6ca6VJd0qHgD9AJ6kAXaK6hPtvC9y+gyOGXr78qqLdKkWFi0tg/iynSlaS8hv3+gMLwiLBYDCpFMcIzXJ67qi6BWHJE1cIPHefHFpE7rTI5Ol7tuZXeB/uUMWHWYOt7fLmZx6UuU83h2LFpYZKfw/kR+K5ZLG1DGarhwZkc/nM8wj1E264fEZ9hyzYwxvY+XMV3d+hQZi0L5WoYVbwVyeMW5AwfH4RIUcxRZh9sRf8mRBW/TeHNIW/x/TqoRgXkULybH/7MX/YBCAiDLjYMXDOakL+Ewo4f8FVjSEGv/8LiAZVJ5N2At1x9IJXwGOdNPdtuQTpRtznSUgfBs+bwHHwtQiCKkcS1elc8Q50HV0yKkVJZWDHCGwV52Tgt3sf8JdlA+/TrAv5ST45V+2gJKV+Xal2LKpe6H0U54cvQsIPTVDSa3Aeb7P3y/F94hCsz9X1LFzQBAeG
 Qqoj7uWA
 2er/6D0aV084+osPxKVVqTRt33amu0mP6lbvn0ElOsi7x0wKEeI3eSYiGZaxQ+IhldsN2DVCEQX2KxVYlbzHBQFAZVD3koM24UcUcdv176XFl2WLWfnM7QjG9IaWAgCmsFXw8kgUwBG1JikVs9GS4NS566HwXfNhERQELqxScUihU2hMmsmQyfshQs/PERtgKFiETZzZ99a+1WvTWNVAdGHgR+0G38ftv4Die2x5JuvNaYssjnS0512qP2unQB/FzSHSbwWIefCMg3tt74CFhQZlGH4f+X91Ud1E0peZE18C/o18bhRylkaiMRwji2Hi/ETUcbscXJTHkGTQyWqexDLhIPVqFg7GCMs24yc2js+W8Ym2ZAzKYqbsMk9/sTvN7XxWk7JzzSgiR5gD92TEQ0TNz+xsYarJr/3wCyZEXC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    0227b49b5027 Merge tag 'gpio-updates-for-v6.17-rc1-part2' ..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1422d434580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae1da3a7f4a6ba4
dashboard link: https://syzkaller.appspot.com/bug?extid=63859a31071a369082b1
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117c72f0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ab7ea2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d0d0622733f6/disk-0227b49b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6a993871f113/vmlinux-0227b49b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0f07823c6782/bzImage-0227b49b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+63859a31071a369082b1@syzkaller.appspotmail.com

 do_initcall_level+0x104/0x190 init/main.c:1331
 do_initcalls+0x59/0xa0 init/main.c:1347
 kernel_init_freeable+0x334/0x4b0 init/main.c:1579
 kernel_init+0x1d/0x1d0 init/main.c:1469
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5866 at mm/rmap.c:2452 try_to_migrate_one+0xf27/0x34d0 mm/rmap.c:2451
Modules linked in:
CPU: 0 UID: 0 PID: 5866 Comm: syz-executor265 Not tainted 6.16.0-syzkaller-12187-g0227b49b5027 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:try_to_migrate_one+0xf27/0x34d0 mm/rmap.c:2451
Code: fb 00 00 00 f4 0f 84 35 0e 00 00 e8 f3 41 ae ff e9 73 f8 ff ff e8 e9 41 ae ff 4c 89 e7 48 c7 c6 00 79 96 8b e8 0a 92 16 ff 90 <0f> 0b 90 e9 60 ff ff ff e8 cc 41 ae ff 49 ff cf e9 3e fb ff ff e8
RSP: 0000:ffffc9000401f120 EFLAGS: 00010246
RAX: c3d51769d0dbd500 RBX: 0400000000000000 RCX: c3d51769d0dbd500
RDX: 0000000000000003 RSI: ffffffff8dba5e25 RDI: ffff8880115dda00
RBP: ffffc9000401f370 R08: ffff8880b8624253 R09: 1ffff110170c484a
R10: dffffc0000000000 R11: ffffed10170c484b R12: ffffea0001cd8000
R13: 0000000073603867 R14: dffffc0000000000 R15: ffffea0001cd8018
FS:  0000555590a54380(0000) GS:ffff888125c1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045ad50 CR3: 00000000743ea000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rmap_walk_anon+0x550/0x730 mm/rmap.c:2842
 rmap_walk_locked mm/rmap.c:2958 [inline]
 try_to_migrate+0x3f5/0x670 mm/rmap.c:2619
 unmap_folio+0x191/0x1f0 mm/huge_memory.c:3137
 __folio_split+0x90d/0x1c60 mm/huge_memory.c:3711
 try_split_folio+0x13f/0x310 mm/migrate.c:1550
 migrate_pages_batch+0x653/0x3620 mm/migrate.c:1819
 migrate_pages_sync mm/migrate.c:1974 [inline]
 migrate_pages+0x1bcc/0x2930 mm/migrate.c:2083
 do_mbind mm/mempolicy.c:1539 [inline]
 kernel_mbind mm/mempolicy.c:1682 [inline]
 __do_sys_mbind mm/mempolicy.c:1756 [inline]
 __se_sys_mbind+0xa3e/0xc30 mm/mempolicy.c:1752
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb95004e539
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffa7b144d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007fb95004e539
RDX: 0000000000000001 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fb9500c15f0 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
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

