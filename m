Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97779CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC718E000B; Tue, 30 Sep 2025 06:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D878E0002; Tue, 30 Sep 2025 06:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9A88E000B; Tue, 30 Sep 2025 06:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6D518E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:56:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 451E15961A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:56:57 +0000 (UTC)
X-FDA: 83945614074.18.3846571
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 66D13A0016
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:56:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3drfbaAkbAKETZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3drfbaAkbAKETZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759229815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=A9s5lKvKDABnlyPv5FHzfoj0kZjQ9BrH1NHlxob5owg=;
	b=cZ4yO6IsrdQZuJRdBB1l14SV84fE+1vEt6rPnaZddi9GG1ncl1kv5nuDevdx17OKqhN2Tb
	pVSLMEley6lrS7boPNXDdTWHqMyCPvyQxS1bNRMv69rHscSigCubiv4Zmao4uwdbHkM0eN
	sxVpd29tCj+Y0EcxUO+yNMyJLqCW6ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759229815; a=rsa-sha256;
	cv=none;
	b=1TxwaKTG3QsIPSH94S3G3beQjzjC2R1/9mS4+mKYS+YZZZdK8U8bS9Gbl7/h1D3wlbVkq1
	T5jdy6d61neDxTKRDLwr2fEokVUlLBhOZklpWAnBpgK0chw5L1ykc2ZBqRPuo4xx4REsEW
	NFA0bm5m6tTBd3JtUKvWin13gnhnoAE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3drfbaAkbAKETZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3drfbaAkbAKETZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42721b7023eso48798615ab.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759229814; x=1759834614;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A9s5lKvKDABnlyPv5FHzfoj0kZjQ9BrH1NHlxob5owg=;
        b=i5ClkqzrmTFO3W9CRSJxmluFmvGiF4wL+PgOq/Q+Wt+NSDVRsbryB8nnm23HkMILjO
         1340v8toaRvczpKTG4R6sq10zcndG1lkxolmSl8J5qnZpSZdPQh7t7juFvqLYRcRQbMH
         p6bZU3b4OJsjUlktSBPWmZ452ubo8yCf5SwnvUAa+prAE3bSI3tV5Av4BtNmTa0cHMcE
         bKRF0zoEKj//5xEJd95g+4VMtFD+BrDWnu39c7cjPVB6J5zyvQl9G2C1YdDUppj/LidZ
         Aqi3wa7GJO1SepwNZuMB2wKwdjw8cD1mJM0k4dDh1V304D0QF0tW6HaqRJiydErWfrDo
         qfbg==
X-Forwarded-Encrypted: i=1; AJvYcCVC/t5L6/ndnMY9BgPpu4MppuebuCsO+CukrIHhlpS2W6tFxY2/EMtm/Pnc/RLj874xwYjS9Kd1xA==@kvack.org
X-Gm-Message-State: AOJu0YxN2vmrqDgvka4V7VR2mE5QJ2421pD7ft+BI7Le+2nSOz+92NCx
	PcJdCLJH37wt4yHhDTYv/C2rRF/e8QF3BH4o0TS5+I7D9qKpX/G/M4Wly+VDBBK43C3JXNIfwF2
	06WfZ7TJGXbkV/pHT3TygarTScYpBneT54WICwBEBMKsC3riIGUo0wb41WWM=
X-Google-Smtp-Source: AGHT+IG6+NqI73w0Zf2L+W4izG5fN2n5MZDwq2eoASlJ8ucEBVdNMpT8OCeevvkXqn2u90OpDt97HulPwwihv4CG2Zc/ccRnQoLa
MIME-Version: 1.0
X-Received: by 2002:a92:c26c:0:b0:425:7466:624d with SMTP id
 e9e14a558f8ab-42595654e5cmr282606945ab.26.1759229814315; Tue, 30 Sep 2025
 03:56:54 -0700 (PDT)
Date: Tue, 30 Sep 2025 03:56:54 -0700
In-Reply-To: <20250930060557.85133-1-lance.yang@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dbb776.a00a0220.102ee.0046.GAE@google.com>
Subject: [syzbot ci] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
From: syzbot ci <syzbot+ci80449aea3ab57787@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@redhat.com, 
	dev.jain@arm.com, gourry@gourry.net, harry.yoo@oracle.com, 
	ioworker0@gmail.com, jannh@google.com, joshua.hahnjy@gmail.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	npache@redhat.com, peterx@redhat.com, rakie.kim@sk.com, riel@surriel.com, 
	ryan.roberts@arm.com, stable@vger.kernel.org, usamaarif642@gmail.com, 
	vbabka@suse.cz, ying.huang@linux.alibaba.com, yuzhao@google.com, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66D13A0016
X-Stat-Signature: dr94j7p56jwj86ys3r7h4ceibptb346a
X-Rspam-User: 
X-HE-Tag: 1759229815-212902
X-HE-Meta: U2FsdGVkX18oJZoLl5T/GYLZi3BlpiDU+BUN01ks29eBdW4TgcIK6QJZvswZCqR6yn9bKl9ypC71Sdh8DGCsixVeCB41/RhqjwQflP6hlY9aYwHqzpGE8itDkycvamNshE7IBHkCcL8YdC2ganr2MY6hPz8fOIJTTzrg3FDDl2nXa5U5/QbrIuWTxNqJavn7k/+nAm5Lob68qT0M7GYN/m4hyH7DIjL1dIewqpeVF8MgLvpehx/r4pSfbqhT/jKAohO45rIoehd87pepav8wdYfwzRvx+N1xITAz3A8CqoZK/ZI2eaXqiLurvJOETEOBznjnZ/sHa2dGYdpK/jA39Sp10qUbFy4Hdo0KJWKXPBn0Xo+Z2mgnFxrxwOrHcBEQEubmPxh9yKXLT6bOxv3H/l5oE6zpVPQIutTFnYADHdkK6oyOUhe+BEypiV0fuUBNivZ51fAyc/VOEalNZgrWO/yAlwBJ9K3VNGUCpIXIr1Ij5GrnpP/7i6oA7qGvkQ7k/bT3ca0/r7qJQYBLht8F7oHEiI2TrMvi/NrUCsYMFHaMsBX4aUZL1LM2LJlQAIRSpyxccysNcXJpylEs75ypHVnmWtH7M+taw+IyN2iGkj+0jLcMQDlX0oYW2p4Jb6vpbIwIfzxGyDxbs+eH0e1qjSrFLhh8pMAgpGiejhCUzSmPWqDVaJssQx/+PsgaIdILMWkxYuwaPSjbgtRjuBTNIe/Wi47HXUvOfrAKdPdjcq+vjUs7FtRkKbJzeNR1zq+0MQnh0t3Af95M0jCdSIWA5N5wxS0SXyKmePh9pErEG1vamt7YqDQISBAZ/g2QZaUAHlqRZMlCcKy05Yn6p6cqIlZtpI8KqgL27qlF42abDjXWZoUufylhBe4f8KrNZ3jMwvKIRFNmLrEVJezNTPM/r1by5JNfG7iBguai8X9B6Pb7xHB12766b1E1meu4O1fta+s6k+smxmu4fVJ7f6F
 4jHgLYUy
 z0B8lqZGbiIu+fKXmEMNVgmeQcGVS1RjyCw6b7fXJ5dI11mmFIN5peRphx6JooUcpg+qSOaoWb0dMSM85A7EnHBakWLubdf6xJ06qaxrOHpEiVyEM/YoPWoVKc/n2Oh9F6D22REZBWKIzQR/AtwrWkQOVUuoGlbKlO/R2B17CG+A6n9bXLE5XoxWRRebJjV23TElnOOpfY6OpRXiZPhzIPLvpmS9EpDO71Kor+svFTFVXaiXFOhixEYVME1j3cyZjdkBe/esTUQ/ScJj9p9nYKul8hnRB/JxkdEO9EypjEBygUIuo1SBo39bea8oHdlgeAzPmYhrVAiVzdA/qO+GwTmVzLYvXjWoBwYAP2Ejjj6G+ezAKR/rrQFvO6wjsJnfVRqnEDn0+p8J5trfH+gUQBsiC4NhglaH8AQh+UHzOulyHhdNe6xVp83SD6qNTdrxBSDbgsLFRPnEKyCOXi8g763kCShx8jPNmZvqV5MILrtIoqFD4awjhIVF1Xq5IgGhbU66sQmEVJvYxn+FfKtmNRKGa9XxfCNAKtnyLZDE9EkfHmwZDdIgCEENLmDxmoJ/9q+ADc20rI42lgrPVeHgP26gjrPgWWUz6OgbBFSsbIJqaWZhvWGVo0A07q5TQyrDvzB2x91NRQ0pwgl3INJ9RhiRrIwbDZOxUL9yT4NAUGGY8XaQ/bP9htN5aPmA+ID9XLZnTtGMd9w5tlon1sBwD5npcAKWhxPJCv0630UlJ9AMcdNk/IVNJvslE41yipPacQNj9QHW6cjqu1YCm13IuwI90W5mqj65fuBrkKbDpPu5MdEVasztwh3zszwvJ/CQGoMZyMwUjJjJX7s+qHQqCThjYmAkWL/+yXXcGoOLkPFxokvX1Na/uFz9ES4deCkPDS4W3iqFMhxLmbbRzttVEGru8tjYX7YNZsMruQC+ggPrd5bY9KY/kJb06FgtnnpwOmF3n4QKTvuo/8k1eN1fS0wlPaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
https://lore.kernel.org/all/20250930060557.85133-1-lance.yang@linux.dev
* [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage

and found the following issue:
general protection fault in remove_migration_pte

Full report is available here:
https://ci.syzbot.org/series/a2021abd-c238-431c-a92e-cc29beb53cbf

***

general protection fault in remove_migration_pte

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      1896ce8eb6c61824f6c1125d69d8fda1f44a22f8
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/84a2085e-d609-43ea-8b19-f9af8ea3d54a/config
C repro:   https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-15076499b001/c_repro
syz repro: https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-15076499b001/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5985 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4c 89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rmap_walk_anon+0x553/0x730 mm/rmap.c:2842
 remove_migration_ptes mm/migrate.c:478 [inline]
 migrate_folio_move mm/migrate.c:1394 [inline]
 migrate_folios_move mm/migrate.c:1725 [inline]
 migrate_pages_batch+0x200a/0x35c0 mm/migrate.c:1972
 migrate_pages_sync mm/migrate.c:2002 [inline]
 migrate_pages+0x1bcc/0x2930 mm/migrate.c:2111
 migrate_to_node mm/mempolicy.c:1244 [inline]
 do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
 kernel_migrate_pages mm/mempolicy.c:1858 [inline]
 __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
 __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f922b98ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffccaf966f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
RAX: ffffffffffffffda RBX: 00007f922bbd5fa0 RCX: 00007f922b98ec29
RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 00007f922ba11e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f922bbd5fa0 R14: 00007f922bbd5fa0 R15: 0000000000000004
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4c 89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	43 20 48 89          	rex.XB and %cl,-0x77(%r8)
   4:	84 24 08             	test   %ah,(%rax,%rcx,1)
   7:	01 00                	add    %eax,(%rax)
   9:	00 49 8d             	add    %cl,-0x73(%rcx)
   c:	47                   	rex.RXB
   d:	40                   	rex
   e:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  15:	00
  16:	4c 89 64 24 50       	mov    %r12,0x50(%rsp)
  1b:	4c 8b b4 24 70 01 00 	mov    0x170(%rsp),%r14
  22:	00
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 22 3e ff ff       	call   0xffff3e5b
  39:	49 8b 06             	mov    (%r14),%rax
  3c:	48                   	rex.W
  3d:	89                   	.byte 0x89
  3e:	44                   	rex.R
  3f:	24                   	.byte 0x24


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

