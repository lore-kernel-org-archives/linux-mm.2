Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC532CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 16:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169368E0023; Thu, 16 Oct 2025 12:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A9C8E0002; Thu, 16 Oct 2025 12:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009318E0023; Thu, 16 Oct 2025 12:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEE5A8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:23:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EF7C1403A5
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:23:57 +0000 (UTC)
X-FDA: 84004498914.25.B16BD25
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id C5B06100006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:23:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3GhzxaAkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3GhzxaAkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760631835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=uH9ncuVNWrmpKccRdCmFgVg8gN7Sa+FrJMkcgErOzbI=;
	b=uTKNaZPTExogODzWnzatWkPK/3pAi1qBUWUnPPZurnDQo2kjOaT7XhkA8FcYaiQBpzjQwM
	sLxDizToBKsb5ssDHoT+PCjP49WdrIdUtHYFfW7XoGqmdkYLs0tFoDYkusC86EIo/YA2YP
	VyjmdCK7y1YErEwiE5Ghx306+kYttL8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3GhzxaAkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3GhzxaAkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760631835; a=rsa-sha256;
	cv=none;
	b=lOtGkFxD2u7BtQc/esfGRKLqQXcl94KoZnznukW2kwsWKeGPKPeFt1j0bVa/qt2Iyul2Wl
	NgJMm5nZN0kpW8q69o2Gf/qOKaVUs16t5pErXqvl22Frl4G29NYmtCYG++5q2nbhhPmtO6
	m3ynJDeIQDB9gvoN1N0zB4GG4qWVMgE=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-425788b03a0so25775085ab.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760631835; x=1761236635;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uH9ncuVNWrmpKccRdCmFgVg8gN7Sa+FrJMkcgErOzbI=;
        b=vkt93Bo0Q7IGtd4M4E4/8t5Qqtw7bYw/WC07MIH2s2O5dCc/IznXL4IJB2aafj0wZp
         4c0vce0zlqHwlWlZ07glKwDOT3FDJcLqqg4X/JLN7xLKIJIe7Oemla7MwHCyFml5FIWQ
         I8VVXx6u/f58NRAVom2WQq+aqqQuF0KvymFLahsPJU4otqo5wufmaTPuBqtVa8DF+FoZ
         KAhgCfy+9Maq6n0x/E887ElEzq8IsGW9GXN77RMCeV7SbdC4IwaIhpUZsonNAoCTlGDo
         qDqY+xGeaTR2xfK2M523YYXFt3r2GzJcFMsj8qXjFHxQhL3f99drM4thEIQvzFz9OvtV
         PDRg==
X-Forwarded-Encrypted: i=1; AJvYcCUv9k1wyM5HVsKDic4C6GXGK1mS58Cvt0uu7d9siZ0Z32gtMmKi7WzpTQLyUpOfKXWPVBxFfDi84w==@kvack.org
X-Gm-Message-State: AOJu0Yzs7vzZgjc7uG5d1d8YJriZKdYmD04RK6lE7+fTIy7xPXg/v8Dm
	rmc8bua0BCf9Lrb8OVBgG/so94xAy4wBtCc4If+zWK4T+cSYhylVOxHW6b3UAt0F+1DJb7GNNvG
	GyQBegk9j6+FszslxUMPovst1XxHZCA1di/H3JJQhbY996RzpVDNWqMFrhJw=
X-Google-Smtp-Source: AGHT+IF0mVeBbeh6pgt7i0/MkOWl7EBWMggnxuS/B6V6XUo6s2UTse3jty2HFSlMCH44YjluTZGifEjNeS3+6UR8CA7xp8eCe2kH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148d:b0:430:b167:3604 with SMTP id
 e9e14a558f8ab-430c5209bafmr12878615ab.4.1760631834789; Thu, 16 Oct 2025
 09:23:54 -0700 (PDT)
Date: Thu, 16 Oct 2025 09:23:54 -0700
In-Reply-To: <20251016112704.179280-1-yintirui@huawei.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f11c1a.050a0220.91a22.0411.GAE@google.com>
Subject: [syzbot ci] Re: mm: add huge pfnmap support for remap_pfn_range()
From: syzbot ci <syzbot+ci290b7e46a3349a6e@syzkaller.appspotmail.com>
To: abrestic@rivosinc.com, akpm@linux-foundation.org, alex@ghiti.fr, 
	anshuman.khandual@arm.com, aou@eecs.berkeley.edu, apopple@nvidia.com, 
	ardb@kernel.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	catalin.marinas@arm.com, chenjun102@huawei.com, david@redhat.com, 
	dev.jain@arm.com, liam.howlett@oracle.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	lorenzo.stoakes@oracle.com, luxu.kernel@bytedance.com, mhocko@suse.com, 
	npache@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, 
	rppt@kernel.org, ryan.roberts@arm.com, samuel.holland@sifive.com, 
	surenb@google.com, vbabka@suse.cz, wangkefeng.wang@huawei.com, 
	will@kernel.org, willy@infradead.org, yangyicong@hisilicon.com, 
	yintirui@huawei.com, yongxuan.wang@sifive.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: knhj1mo3rgnpxzbnthw34d6x3qxng51h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5B06100006
X-HE-Tag: 1760631835-276703
X-HE-Meta: U2FsdGVkX19RsYdUzkEMqyDAoz3nG+5rsTr3xtGRzP6b24CkC66BC/nV0jWA+ktEt7u8SafzHOf44SiAhpIsC56HVP4NU5WZ5jn+LLuF1/Ablx8rm0+MVXM1hfFMw3Fg21dJtRDZZF9KwMbBFf2zlR6CwXV/ZXlDmSYj8cqI6BUEvO/GPra10FnWSuL+TfLKeHyvxnBA5wnOxLBEKk5m0usJ9/iuZtgqe6Bm4IJg/wI4A/bcgfMP39xABQC62wyP+sZZOYlZ/HPS7E0qZgTX8NPc2u8tEpOZUAN+5xmxg6kD905KFHqcQSLoaOs7OjsO+TmJyPCFopAfqaxRQwcwVYTiTIXxNT6mZPMCqHQdmftSh5D2be6/MOoBScaBlg65PYiU5lNA/iJEBetEUd98PMQspABk0ToCzgOjvaTPQheVpgjCf0If21T7iVbg8NyraI1HGF8Y8Qq1FUox+X0ltVa7LoMrjeZ2GHgjnAuvANlONo6hc5Hi/RvcTOA00Cm5RIvI3NlcmdbPYIbGQuiBA8jt2nzRUUJ6xUs8DRbs7XuQStdelwOX4EN4ucWIKi3m69quF2Wswo5931x6fnT2CGVcczAIpWNoFdKBuxkAZNJSgT0+lcbklllvYgkkSVpeJ9nUthAnu6bs1v/WSM0jVE2wAYBxdOE/sgCed7DHjfFME67I/qaPNiVs7M5GWlV2EplGF0F0kKsgWDTJbs1j4iCxuVf6e2PQwoVBq40KCkDQXctp/A1gGn4VRFyQXO+G/ShUJGQD84CG2TldJpGzSC5Y6EzfUfpPZogKPv2psYpJ4itovjqnZcP3wl/skDtubqCMiSPgE3dFcwrONgMavrdB1jwZm7yAcsB+jR174JoYIbaNuoZ2YWmezRdv4Vm8JHm1Zq1cdB8lDLuEIPavKGptSoORMnfd6wMr55ZpiIDEVeUwnw4khOT1nWBgcuvyF6I3xmgVTWXnYHumgmh
 A/xulZvX
 rmVQCDH66gtPYzJq06EnnE1MmPNVA5mGjHWZYSLBj4xQ57ND6JS21vy8LijuItDHW2xTxRdwOI9IBvmR92+dap7F1AYRrIabszJ5wUXLdIZpUHPIkSJ4EQwJVk5muVIE2uPKXUFRGcwpiwP+r6Vy7hOe9qYm7lrc5L3a/gctzS8COU1GJEFqQr5KahwTNcDdV+rJHmW6xY/uBPLq1I/ej8R63NEzY2rgxzEHToNrSTfb/25lotLya5eZe3PZqlpYAmi9T+nRLOGqnOOtsxYuqxOC2mZsLwPhdZLSSgKz1D5GqdyBxAwDPdUimoxhlss9GzUizGVldM03ZPNaMoPkPIsUlvTzQ4hLm6NuZk23QSz5okXGj4EmkcxcVNlCogDo6uOwlj+Y5KEKiWZEsl5ICQBCD20kN91GCeFWnGre4zdNemKEtEbOoBHk/3sTTS6d0IxDsBk6+rdox/qCy2+fwW6LjkUKHUfUDLkyB56Sv0ZlE62HHeGJ1j3xw++lLFHUK8E7/bSKn9PC4RTdYTL4pVo5GgNB5srjo8pynYqn200jn/G//h3ldMFM32xBQnDm3DI//xTIwy+3gJ5cVtoWjNrMVxawk6xjHoRT4pq/4+W8JiPOiHjZ96BdlWtsRgBV7u4S9HrmG9aUDLpczVO6rHJO2NUX8lSb4SO+YkQK8FKQ5+zqMxAsx7YiJwLfF+vDuy5t1+ysnjvt/RLSFmZ43pmbP5cT3PsGDxnl6QhgG1FSJJEQ5kOG+tnrGJbMtlM43Os9J/haxBAwdI1BTsBamZ6dxkO67y09DSKZfX4KO08QyMiegUZeZ6HV5Kw84VXumQ3bs4rmrOZfr+nzokoos31Lhxx1IReeJgAG83tNLQeyaiF7L+Nnj47SLPBiBhmAH3dDnvQdCJMF3u1O+MM1WunYzOEHUHGSSpNuQm43o8YTuiKX9ER/9jzHc01+3/hcjqiD7QumsMao41b09RsuiGz32iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm: add huge pfnmap support for remap_pfn_range()
https://lore.kernel.org/all/20251016112704.179280-1-yintirui@huawei.com
* [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and riscv
* [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range()

and found the following issue:
stack segment fault in pgtable_trans_huge_withdraw

Full report is available here:
https://ci.syzbot.org/series/d04c2914-0d99-4132-89d4-899e22abf904

***

stack segment fault in pgtable_trans_huge_withdraw

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d7864e5-ad3a-4c0d-b21d-86cfc476792e/config
C repro:   https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2c50dd/c_repro
syz repro: https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2c50dd/syz_repro

Oops: stack segment: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5968 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 13 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 00 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90003717300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001102a4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 zap_deposited_table mm/huge_memory.c:2169 [inline]
 zap_huge_pmd+0xa25/0xf50 mm/huge_memory.c:2197
 zap_pmd_range mm/memory.c:1926 [inline]
 zap_pud_range mm/memory.c:1975 [inline]
 zap_p4d_range mm/memory.c:1996 [inline]
 unmap_page_range+0x9fe/0x4370 mm/memory.c:2017
 unmap_single_vma mm/memory.c:2060 [inline]
 unmap_vmas+0x399/0x580 mm/memory.c:2104
 exit_mmap+0x240/0xb40 mm/mmap.c:1280
 __mmput+0x118/0x430 kernel/fork.c:1133
 copy_process+0x2910/0x3c00 kernel/fork.c:2460
 kernel_clone+0x21e/0x840 kernel/fork.c:2609
 __do_sys_clone kernel/fork.c:2750 [inline]
 __se_sys_clone kernel/fork.c:2734 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f946958eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc41c94258 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f94697e5fa0 RCX: 00007f946958eec9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000002001000
RBP: 00007f9469611f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f94697e5fa0 R14: 00007f94697e5fa0 R15: 0000000000000006
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 13 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 00 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90003717300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001102a4000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	c3                   	ret
   1:	10 48 89             	adc    %cl,-0x77(%rax)
   4:	d8 48 c1             	fmuls  -0x3f(%rax)
   7:	e8 03 42 80 3c       	call   0x3c80420f
   c:	28 00                	sub    %al,(%rax)
   e:	74 08                	je     0x18
  10:	48 89 df             	mov    %rbx,%rdi
  13:	e8 9d e9 13 00       	call   0x13e9b5
  18:	48 8b 03             	mov    (%rbx),%rax
  1b:	48 89 04 24          	mov    %rax,(%rsp)
  1f:	4c 8d 78 08          	lea    0x8(%rax),%r15
  23:	4c 89 fd             	mov    %r15,%rbp
  26:	48 c1 ed 03          	shr    $0x3,%rbp
* 2a:	42 80 7c 2d 00 00    	cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping instruction
  30:	74 08                	je     0x3a
  32:	4c 89 ff             	mov    %r15,%rdi
  35:	e8 7b e9 13 00       	call   0x13e9b5
  3a:	49 8b 07             	mov    (%r15),%rax
  3d:	48                   	rex.W
  3e:	8d                   	.byte 0x8d
  3f:	48                   	rex.W


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

