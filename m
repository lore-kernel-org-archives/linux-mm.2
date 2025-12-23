Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8096CE6FE24
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 17:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B306B0089; Tue, 23 Dec 2025 12:51:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCBB16B008A; Tue, 23 Dec 2025 12:51:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF83D6B008C; Tue, 23 Dec 2025 12:51:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA7DC6B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:51:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62BB68A43D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:51:02 +0000 (UTC)
X-FDA: 84251476764.07.E606EFC
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9308680009
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:51:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3g9ZKaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3g9ZKaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766512260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=mwW/6sJQ0iBm/W5F2BR0R56wsyjr5B9PRL23bKwGSP0=;
	b=lyJtJEIo/0RpEQ5k3TEs2TB4FQnr5v4gDMPjz6z22oyZFTkGxbLvlX2WOjlCQmOnmo6tnq
	AFu6UZN5xPwzaiNlooZD65/QHrYqMpOi167R348zr0K8Mj1VDekeHKaj+40P9z1kZjwE3M
	WRzobpzBNaBq6YZyr07XD3MmvfZn6cs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3g9ZKaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3g9ZKaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766512260; a=rsa-sha256;
	cv=none;
	b=aCnh6onDbRBBP1Q2eOSS/yRP84Zk/PwZrk7L6e8wYF+wMWvWc/kYgDU68DD3/MEUIp+OXV
	qUhlnfGQ2zuuOfkTxL2g5W0gOGrE9vOZFO6kf1cZmSOrrjXKsY/XVH3i5MbUcOHyEBjJwX
	WAi4dx0T9ikO89etBa+Zrz9Lfk4sLp0=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4501735f488so6952278b6e.2
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:51:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766512259; x=1767117059;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwW/6sJQ0iBm/W5F2BR0R56wsyjr5B9PRL23bKwGSP0=;
        b=lCXiAIhpKqxZqdEx6dnqascCzGbp6UqqOm0psGdr4NUAeUpENkK7lTo15OzA8/n3kL
         A20LUG1uQaWyqraY+skOZrZR5zoTWT6NcBIZ6eCOSPdaMjOwLTXyPoQut/Keetth6i+a
         V5WP7vb8g6T4/5snktHmyWurhGLsO5dFQx0M0VvmGuH60lMnHGcIevJaj8tWHOlYQ284
         Mg1ASwB0kR3LjLKvvuXrglBaLMcpu8+fBLkoB701qZhFmjUeqjju4xhIrEoHiY4Sq6Xb
         xU/O4Iqc1QYMDWxU1UPDYoIeHdCfGAGJqw2SdrdQg1Sdl6/dkZr+bWBIcgsOOqOeEvQU
         BjZw==
X-Forwarded-Encrypted: i=1; AJvYcCU7UEfzsJ0xw5CPJUvM5ZmtfZJ9Z5RIG2ZdoJpOW0z0cd6s+3ai6aa8wIVGw+a2VzUGCojs4pdzFA==@kvack.org
X-Gm-Message-State: AOJu0YyhQR9ApPFrwAt7uSKHDKvHCCk2bz+lJ0ed8Kq76v4lqzoaFzN1
	MzpVHf0/JbkYfgGdvNUCeqjsft2eMDxGo6EuyKH3sYSNjugNbuaQ9jQt9C3l09/G7e1ZaLKpk15
	YQvZ+8QFV4FT4VNNPCHQR4aaAOiz/3WoMthWKGnwHMEVbQckexiNLqPT3S/I=
X-Google-Smtp-Source: AGHT+IEaUWdkY2pa1Ziiq7hjGtHuN4V6dROmOIZErMnnE/rfQXtpgkNktKXLyHDpXp1cJFT7ib6EUG/QWK5m8Xb04QmhAXoKAz/k
MIME-Version: 1.0
X-Received: by 2002:a4a:bd0e:0:b0:65b:33ec:1bb3 with SMTP id
 006d021491bc7-65d0ec33893mr4579322eaf.80.1766512259503; Tue, 23 Dec 2025
 09:50:59 -0800 (PST)
Date: Tue, 23 Dec 2025 09:50:59 -0800
In-Reply-To: <20251223122539.10726-1-richard.weiyang@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694ad683.050a0220.35954c.0004.GAE@google.com>
Subject: [syzbot ci] Re: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
From: syzbot ci <syzbot+ci4ae4a31c44c6107f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, npache@redhat.com, richard.weiyang@gmail.com, 
	ryan.roberts@arm.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9308680009
X-Stat-Signature: ek7x6b4x61pp6pnwoc4x4yneu9fh1mru
X-HE-Tag: 1766512260-386573
X-HE-Meta: U2FsdGVkX1/qKNTti1wp8VT9ntgmN1VtyGw1YTpD5zItJ4NuKjttCu8Hj4jLqrJEQJoOr/ocGXeuDtWOWo0r6JKepxOaXU5okJrn/bSIiyMrX5mjoiVqPAwAyzRU2IKWzsynbs87iCRlSUSzAzmifuTM2PGjKZOludwfQj67gNDCHQNHgMeJ7MY7ZdcDBeAKAXLK1C6qe0IPU4ikHHoQSuQDKX/vKrFTS3mw+00HQzPzXeFSFhNOavtXN/e+VBuhWwTi663uHH79o+m1fTlG7beY3Hw9EubHxLTuASGIqT55II6LnKYGhTzevpJINOQQmznxGKf3L2pY2NdJKEUsyp7lTppciFiy6lJ7C+wUvVddUaWpUSFLUCpMJ0CW/DlqdZY17nlRIvEy2uJCEv90R1P+yTpo4AimjFu5ulhkv+UKaYM/g/KYbQL88+Xidhedm1HW09s9sKVLCS6926eIHv5GQiQhQ+E7M+NVrBFoyi/0TenH7Wz1L9YHSwV6QY1AwDtQmm1xXEXyrEwqX234FCoy7sd5qMRLLGDNtUTEXt6Y5hJEJI1e/fOHKZcItbSQQTbxiTE8aJsbWV7TsYeIkG2W2QCm1D7TcjfGyhfn32qlRgY56fsmITqK0MVg0kMOJYegdEA4TZH4HQYlG6blHtsoAXZYU+TqN5FTmfhh2t4KBYRevskXhprNj0iweoqYSOvFCMErA2ilOGzYWf3/T7Wjp7mePG1CHZWfG3imdrtMe+9YM+46zizZegukk7bT4g/Khl542NyqUmFjP+FnJ6DjpUN91XgoblXjMIrrxq+b0LtT8GFPKOnbQ7WDDeC7qfe2CZKDiky4TSQfeUbkJu06DZkA+NeE5sOcswesoxvH4aKJf8Lsd200lCn9XorI1DRTYTLYFa926tB9svYzBHZefNuHOO/XaVQExCkX/9j44yijyrBl4KDRyf2EAcm8xHj57rIERSU1Ek3RemJ
 GfRmlXtY
 G8k8z/Ew40ae860nBmcozr+nYFeA41JTUEWLKd/EsuaQOutf5Z1MtcygahKllTKEZeFzGbUyRJnn9YXsa+D5wO9qeOaegB5m+8TC21Hnce2uhr4c/RJFq4BaD94UXPvHx0sw6bYAJ4lCYjjlDhCdhUUFFWK7oJuSyIUQcuY4WDdvjAjx7Wu9/p4BwVAbJEN9QW5Bx02rg5d/PyTuNZbJ8bTxk8mnijqBPB35A3Oh8dtX3vp7+zZqjC4KbSsgyI5TbzqhDPjG/qFTBvmtH9v3MaVAaqYGXkD8Owi2dHWCFtv+i2puNgji1NavwMkOvGF+r8mnnKNIrmUsTaqTWj63ee61uGeHhpX/u6HvZ69i1aaYPKXA7rWCTg+N0QeOAkHo77kxdSPh/NIBWVoef//lDvOPv/uPXIDVyKxL3tAncoH6oF7miU1rRdg1vh6IKFuI3ttH1KbxI8m37gDzC99y41j3XTaWV8q4o3t3iukzuGqI8BUvGPF0z9GpGwVftVGDSDmi+Llm2uHM58Xe0THFiS4Yi6bUmXbE/vXsmvaG/M5OpuiYL1IoYBGqpMEKfFxZOekbUHz5XNF7DuQ1/lC6nqNLA2Cx8TdUO9wXPfuyMeYRHQNZ5Jwq2UFyoMIcU50kmW/Mf5GVq4b5q2kzulavgzsgFOrNi2GrvEDvRt6+RyQlT/qjZ7lEdR+2zXsWZ4hs5B7LbZTtuS4qlCIIPcLIh9MiwSm1wFHDVz5G8O+SoKMg5tndhOQLqMA4md+qRia1D/7O8YOxIG9bBeWdFYV3wPDg+A4wE0iMhc/OPQoxlSpT/3hRfTy076ZorLDHY/HIiCP4p6LyvgAdZhmGaNvjGfY4TegB7r1/GzD8IOpXgY6Uj9Ac9icoDrSxc1/0CSV6idahZ7T3UKghlOPj38R+PB3rqOjEMET9WWm08e5XUP1HYFRcnj/T0QsX1oRuCIBGIqMdggTzHZ1Da8V82T5L1zssFPcTs
 wJF7lsuF
 1+1EIsALTtla9BcvFMA5WtncPnZtgU0PxSkVdTEhfZ4Z5NglxM6X3mRcDG+WrlNDcylrdOfFD0DlnMgVTWVarpOkcFCZ8r96LNbV6wnacitxyP/yU9ojPwoE8+NGLp1zQvUS0vpCeGeGy0Mkzbxxbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm/huge_memory: consolidate order-related checks into folio_check_splittable()
https://lore.kernel.org/all/20251223122539.10726-1-richard.weiyang@gmail.com
* [Patch v2] mm/huge_memory: consolidate order-related checks into folio_check_splittable()

and found the following issue:
WARNING in __folio_split

Full report is available here:
https://ci.syzbot.org/series/7e34013d-ed08-40e1-99b7-8fd118dce84f

***

WARNING in __folio_split

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      c642ecda5b136882e518d8303863473c0d21ab2f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2edb2dc5-42c6-4557-a194-921c57fd9eb1/config
C repro:   https://ci.syzbot.org/findings/8349b674-5790-4507-97cd-03697ec93cb0/c_repro
syz repro: https://ci.syzbot.org/findings/8349b674-5790-4507-97cd-03697ec93cb0/syz_repro

------------[ cut here ]------------
Tried to split an unsplittable folio
WARNING: mm/huge_memory.c:3970 at __folio_split+0xfe7/0x1370 mm/huge_memory.c:3970, CPU#1: syz.0.17/5997
Modules linked in:
CPU: 1 UID: 0 PID: 5997 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__folio_split+0xfe7/0x1370 mm/huge_memory.c:3970
Code: fe c6 05 a5 f8 3e 0d 01 90 0f 0b 90 e9 0d f4 ff ff e8 4d 78 94 ff 49 ff cd e9 d1 f4 ff ff e8 40 78 94 ff 48 8d 3d 69 47 5a 0d <67> 48 0f b9 3a 41 bd ea ff ff ff e9 7c fe ff ff 44 89 7c 24 34 44
RSP: 0018:ffffc900036d6d60 EFLAGS: 00010293
RAX: ffffffff822d4360 RBX: ffffea0005a4b008 RCX: ffff8881047fd7c0
RDX: 0000000000000000 RSI: ffffffff8e06e540 RDI: ffffffff8f878ad0
RBP: ffffc900036d6ef0 R08: ffff8881047fd7c0 R09: 0000000000000002
R10: 00000000ffffffea R11: 0000000000000000 R12: 0000000000000004
R13: 00000000ffffffea R14: ffffea0005a4b000 R15: 1ffffd4000b49603
FS:  0000555591a60500(0000) GS:ffff8882a9e32000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30d63fff CR3: 0000000100f30000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 madvise_cold_or_pageout_pte_range+0xbf3/0x1ce0 mm/madvise.c:503
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x1037/0x1d30 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x34c/0x400 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:622 [inline]
 madvise_pageout mm/madvise.c:647 [inline]
 madvise_vma_behavior+0x30c7/0x4420 mm/madvise.c:1366
 madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1721
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1937
 do_madvise+0x1bc/0x270 mm/madvise.c:2030
 __do_sys_madvise mm/madvise.c:2039 [inline]
 __se_sys_madvise mm/madvise.c:2037 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2037
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff69838f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff82001dd8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007ff6985e5fa0 RCX: 00007ff69838f7c9
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007ff6983f297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff6985e5fa0 R14: 00007ff6985e5fa0 R15: 0000000000000003
 </TASK>
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	c6 05 a5 f8 3e 0d 01 	movb   $0x1,0xd3ef8a5(%rip)        # 0xd3ef8ac
   7:	90                   	nop
   8:	0f 0b                	ud2
   a:	90                   	nop
   b:	e9 0d f4 ff ff       	jmp    0xfffff41d
  10:	e8 4d 78 94 ff       	call   0xff947862
  15:	49 ff cd             	dec    %r13
  18:	e9 d1 f4 ff ff       	jmp    0xfffff4ee
  1d:	e8 40 78 94 ff       	call   0xff947862
  22:	48 8d 3d 69 47 5a 0d 	lea    0xd5a4769(%rip),%rdi        # 0xd5a4792
* 29:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2e:	41 bd ea ff ff ff    	mov    $0xffffffea,%r13d
  34:	e9 7c fe ff ff       	jmp    0xfffffeb5
  39:	44 89 7c 24 34       	mov    %r15d,0x34(%rsp)
  3e:	44                   	rex.R


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

