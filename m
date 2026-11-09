Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12EC6606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102B46B05B0; Sun,  8 Nov 2026 22:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA366B05B1; Sun,  8 Nov 2026 22:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31EA6B05B2; Sun,  8 Nov 2026 22:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC5C36B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:58:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA9CD140532
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:58:39 +0000 (UTC)
X-FDA: 85414223958.07.2A24698
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf14.hostedemail.com (Postfix) with ESMTP id 133FE100003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:58:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 37UTxagkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=37UTxagkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794196718;
	b=XzMw7ldeitjtG/aGAtzTB/A4LSdKAIztkPJHjQjMlElK5s7ifKfpwJj9kP3FEhhXHTjksb
	hTIqtYu4BihLNxnL9baAm/hK9B1eTqM3ER1ntQS2pCR9jMHxF+DnhOfnyl/8RxsXdDZ/CA
	qLt/DhjQn6SmoJuHGUJ9sB18RpLv5t0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 37UTxagkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=37UTxagkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794196718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=FmcI/wMjxKRabbUMuhYcTv6IrsP0rncRUcBSJiu7240=;
	b=GtjbgSQ5fUQCdPoFHAgd7WkPPYVs9Tif+rN/lBcutt22UzRJzyhBlCsi9gEo77rHYA4TUN
	3wYSdmQwJesQDAL4ijUjfZcp8KlTbs0K7feZYT0YVK+3nWcxEbas1ZnJ8TDT5ePWZi18fB
	WpYlzQ0nDM24n81hqg/bESnDgiF2mBQ=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4dc57e2a3f2so726070b6e.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 19:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794196717; x=1794801517;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FmcI/wMjxKRabbUMuhYcTv6IrsP0rncRUcBSJiu7240=;
        b=EUAoUHJTOhs7i6/50gZ9s1BtuZZNQJFpaaG3G+MM3KxuDmwfCNi5tBHKr7V9uJrv9x
         gArlfSPgymYW9pKTm/TJWHnqri1LdbaqOJVCoZxj9l3Z1VAdk4rU1hnCydqI3pX9ih/d
         Vs5ii6MveJqhOQXl5fbyJXWDGfk7i8eK+F5mSXieb9P4myjHbQo9vLKKTLuip8/r6Rq1
         DpeW3XvObO2TO9y3aB4KNELiddlxKlIFbOgNK32OZdPC/KngUyC6oM/jZ8b7lSgZXvDY
         YIXN0FphvbIfyxYrzAAmx7HT7GbrlcZHGBZjgA/X0XAnVx6eIsDEPiR+RnAh6A1G+cqK
         2xmw==
X-Forwarded-Encrypted: i=1; AL+hErFFLribL4qkScc7Y/3nivwtkN241IQP5eKJLSXAnOUqYY5pnE1tcyXNkl2r9qZ706mHODMTV+SjQg==@kvack.org
X-Gm-Message-State: APuU4Z+SlEM+X38AhPK8BJmLcR1mRmS8JGiq5u1+u/1WOjUaW428g0FF
	MZ/GenvAR109wV8rcgVgZfFeLNYGHGLm02DM63QT7nyGEvgYBJ3MKzfRuIyoxEaOa7TnVynsfR/
	hTWVT6PB44r9ruaLDxyatAwFNNHpYndSh1MneHsEzp7UKRw7AiMRExdQLv5I=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:318b:b0:4e6:9390:e153 with SMTP id
 5614622812f47-568145f2896mr2071786b6e.24.1794196717188; Sun, 08 Nov 2026
 19:58:37 -0800 (PST)
Date: Sun, 08 Nov 2026 19:58:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af144ed.f50b2b3a.2c0de7.0010.GAE@google.com>
Subject: [syzbot] [mm?] [bluetooth?] BUG: unable to handle kernel NULL pointer
 dereference in __refill_objects_node
From: syzbot <syzbot+73e34786d639a8eb1324@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bsegall@google.com, david@kernel.org, 
	dietmar.eggemann@arm.com, juri.lelli@redhat.com, kees@kernel.org, 
	kprateek.nayak@amd.com, liam@infradead.org, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	luiz.dentz@gmail.com, marcel@holtmann.org, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: waxe3i3txopsdmofg3a413ogyoenj7xi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 133FE100003
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794196717-829807
X-HE-Meta: U2FsdGVkX1+OU8Jj9AexvsqPmxS7hLCVSRrG8U+ie+Rak1SmEODCONfdVAZbTn275Spq2FcriqB9bC2yLwyIdN8LerbwrwI0S61OmfVVrcvd4sup+DaL7Ne4dHZZUsfdUGkFHJ3cBJ40bwh6LpiSoH6G7r5W+d94AMAr4OQyiBLJarLcuHQZhnb+UhjQBCahAbMcxUTXEPSP00fbe2xnnudcpfZ0X+y+XAZqvl/raqeVte8Ne2wcnWOKXo2kMIPEySaadR6SaARUAs5MYujDHutSvQEeiLFAJGMcOoKunUV572y3ByIQ4y4PQE2aAOvww5dEHfuXd+QiJ/khXJvqjUfpMPNDtBYg76LVEaym+oWe/paQCJva22tRKYdDLHyO3sCjhGyZxeFYHuXNTpKpn1lrvGYUrQWsJ1HDPfCWr6xfEhwgYA5p7icNdH7DsUYdmw8sTbJVAObkE1+NyihiOScAmvZpTU/wktgLQrWZvXRGeLEa3Q4vwqeZkcd4T+JRPG+dKcTso0I5P3NP2vkAOeOoyNzbxCqiNa+Odac1BkVqldHxYY8zXhIFB7/b3CYXD7QnNgLoIubrIVhs/UNsD8boGs3LEKg1xwPxkrlH7PRa1zkEPF2kYOULOZTtDgibjfm07DerbHaOyibCiGOBJnorFOaRa0HTSx7iKzEVuMwFWh3VtYUbHyMqNNkSRcH/LkGDXYLqiAuj3QZujX2pqJ5WV7b0vhUVQRs6b4rE8rPs4BPHbEwLWA6iP/M4A35VNskxTYSSGpmUdkwL6f0DNkxmn20eijjM4RLPJ7lHavYsUdAMYeqMc3xwylLlVAIvpJy6uaguJp+nogflkK3jdvLfOFopqmFUVpaWDVfIcuUwIE7YJI2oBZOv3O5cWyjQ5X3ZK2DsIel8KLbIozBRqGS12/QOXavLZJAHE1u5DSGvfSSvTvQG2riIVS1RUBAkYZHOsUY83EqcGtLNRKI
 mJdt0+OK
 4fdplFW+E6/crM9fhERoA9H4HUj69BAWjch2viGh+8bUV+h6+vrv8WaRVl6y3ocoEz81pD5JrGkao3wc/LptTJs5B/jjZHuFLXWOiIujPfOW4RBKFZcQnf3R5WSl6x5XypH3A25jIDh9O6z7MbSZBEYVNZ63seoHkiRTSB+kzz3e+Rr5rvY8T6WuF8tfU/IPDoWBsQ5yBMawpklTGA98XiwcQXXcGyFvdBKd6PdZv4AHQ82R3heycU7CNe89IvsWelG4/ANQAPOekZ5uSql12LeyKTbYvRRxoD8CaZyrAhBkj+kpPznkAykRLKk2gLSs4/TEjw5Xuw7w8+fT/NTgtW5fJZ9HrNzCHK3OEqdFGmDyuVtpyaEp9AFgvjcSb5/a9kMdBTO/5OaS0BTzlvTRgxRsFxVfsYZuVZbzQutZfjSogEmVzkBCUCSJhIxJ3erVNsWFsOkarKfk8UOvtqtcG03TNkLsnDSIQbutC4c1HtyQ48hJo0UxDsWTEpRA3QL3qeKynarxGnXKH2+KFtnwMj300yLa9PRiFMY4Iz3lS6b0ErvOJGZTo1mFs8Ibk85LBGpor3jb26IZSNx9FDsjT/TqiMU/lwdOiwpmitI0rVp7icci/DpNnswTtcmMQCPZnFjLhaszavdJVhXl8q0UFjy/xMa5jauJulkuQqsp8IHJWIk3unWLOUmwwVFBGnVzmiZPPWcC+GF3YeYyKs89IuEivQzb1lBYSdyPnqkL/Y7ovXrkiAeARAST0O+w7LzNzZRvrIUQslbakE+8f72F/xCGXpIMWg5K5wxWiXixTsGDmpakdJq7PyFhrme2JUCoBHT+XSKdRkKnNIsN4kH8U0fUL24Ooth7yP74ncvV5YedzIcrk8h4jkXhovHJ6P6H1BsyskQqf2ZDsizd7uIZc6TYp6QH3UsRhOP8znMFpeYtyXj31JH91jvWnZsU/7XKVDeIF4lWwA1rVNil6dODsZ9037aZG
 OZkDBwhJ
 7Hjjjk/tNFnlpTeGtTEeKnxI1dIUTe9pPwxh7wWKQ9npQ7DUh1iEAhMB3C6JjeFDaR1fNA8QBtEIzf0ore1FVzM/GSf6Gk2dyw0c68Kn2hkn5R6hvFrZHdvJ2CqaWz4LUlgAlNupNfgwQk8wk57Dwe6K6nrNcN/QuOh5XLalyPmF59CQ/CT0L6WtHJKbzB4PmYAXtSwiMLp8BiJNsm9Ms2nBWZccH1qZsFyAioKUD/Bai7pcMWjM7c7eRGWbLAb4psJ9EkzCF6LkG20crhbgPpyjrahZ16ldPswE2Xfy9fBZB0M23eW2tboKuu2ZNTbzE1xXZRNh2R6LAWVJNiMw0KN4vgXhYdA/rsXps8ZgZRyzVEF/BD9r4jHQ9Vo6QAVdFVhT6jVDSGrAz6BR+fXFMvxHEW5CD7pDWAzDv7nXZmLf2VVu+9RtiQVQMHiukmLLDZO7bceXVLv8c3BOLxdh60rmFWb5jLaB8wJze/R6fInfSIvWoaGotGSX9OIhbNyM/xH12fduyQHWbcfHwVlyCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    58c1eb84e977 arm64: sdei: Preserve the interrupted context..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=12d1d369580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a58b6b4d667e7a61
dashboard link: https://syzkaller.appspot.com/bug?extid=73e34786d639a8eb1324
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1255c1a1580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b1ec47537e12/disk-58c1eb84.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3bca0c2b1169/vmlinux-58c1eb84.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0a7c49594d5a/Image-58c1eb84.gz.xz

AI-generated root cause summary:
In mm/slub.c, __refill_objects_node() replenishes percpu sheaves by detaching a
freelist from a partial slab via get_freelist_nofreeze() and iterating through
the freelist pointers in a while (count && refilled < max) loop. Because the
loop condition only checks count and refilled rather than validating that object
is non-NULL, a prematurely terminated or corrupted freelist (where fewer objects
are linked in slab->freelist than the expected count = slab->objects -
slab->inuse) causes object to become NULL before count reaches zero. On the
subsequent iteration, get_freepointer() dereferences NULL + s->offset (offset
0x400 for kmalloc-2k), resulting in an immediate kernel NULL pointer dereference
crash at address 0x0000000000000400.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=73e34786d639a8eb1324

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+73e34786d639a8eb1324@syzkaller.appspotmail.com

Unable to handle kernel NULL pointer dereference at virtual address 00000000000004e8
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=000000011857f000
[00000000000004e8] pgd=080000011cba0403, p4d=080000011cba0403, pud=0000000000000000
Internal error: Oops: 0000000096000005 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 4870 Comm: syz-executor Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : get_freepointer mm/slub.c:596 [inline]
pc : __refill_objects_node+0x308/0x510 mm/slub.c:7413
lr : get_freelist_nofreeze mm/slub.c:4494 [inline]
lr : __refill_objects_node+0x2b8/0x510 mm/slub.c:7409
sp : ffff800094587600
x29: ffff800094587690 x28: 0000000000000000 x27: 0000000000000000
x26: 0000000000000006 x25: fffffdffc3256e00 x24: 0000000000000003
x23: 0000000000000006 x22: 000000000000000c x21: 0000000000000001
x20: ffff0000c0022138 x19: 0000000000000004 x18: ffff800123625000
x17: ffff0001ace953a6 x16: ffff0000db9cd894 x15: 00000000000c8000
x14: 00000000005c615b x13: 0000000000000001 x12: 0000000000000003
x11: 0000000000000000 x10: fffffdffc3256e20 x9 : ffff0000c0022120
x8 : 00000000000004e8 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000008 x3 : 00000002000c000c
x2 : 0000000000000000 x1 : 00000002000c0003 x0 : 0000000000000001
Call trace:
 get_freepointer mm/slub.c:595 [inline] (P)
 __refill_objects_node+0x308/0x510 mm/slub.c:7413 (P)
 refill_objects+0x78/0x320 mm/slub.c:7526
 refill_sheaf+0x44/0x6c mm/slub.c:2917
 __pcs_replace_empty_main+0x22c/0x4f4 mm/slub.c:4811
 alloc_from_pcs mm/slub.c:4887 [inline]
 slab_alloc_node mm/slub.c:5021 [inline]
 kmem_cache_alloc_noprof+0x35c/0x5d4 mm/slub.c:5047
 dup_mm kernel/fork.c:1532 [inline]
 copy_mm+0xb8/0x328 kernel/fork.c:1594
 copy_process+0x1698/0x35a0 kernel/fork.c:2320
 kernel_clone+0x234/0x8e8 kernel/fork.c:2790
 __do_sys_clone kernel/fork.c:2932 [inline]
 __se_sys_clone kernel/fork.c:2900 [inline]
 __arm64_sys_clone+0x168/0x1d4 kernel/fork.c:2900
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
Code: f9401fe8 f900029b 2a1a03f7 b9402908 (f87b691c) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	f9401fe8 	ldr	x8, [sp, #56]
   4:	f900029b 	str	x27, [x20]
   8:	2a1a03f7 	mov	w23, w26
   c:	b9402908 	ldr	w8, [x8, #40]
* 10:	f87b691c 	ldr	x28, [x8, x27] <-- trapping instruction


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

