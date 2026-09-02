Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8640C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9035E6B00B8; Wed,  2 Sep 2026 17:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7436B00B9; Wed,  2 Sep 2026 17:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA836B00BC; Wed,  2 Sep 2026 17:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 480F36B00B8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:35:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D70ACA3E52
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:35:40 +0000 (UTC)
X-FDA: 85170129240.19.C5DF467
Received: from mail-oa2-f10.google.com (mail-oa2-f10.google.com [74.125.231.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A782A0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:35:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3qpaYagkbAJUHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.74 as permitted sender) smtp.mailfrom=3qpaYagkbAJUHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788384939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Z/JGNWxV8bK25k1HiaGt3SwTKzs4RSXT7cEloNky6KY=;
	b=1G0xtC9PGyNnyPxEd2s+YJqtCCd+HTUZVrerP3aL9LdNVY3fOduE9v2ynK2zcQyiP2RKw1
	6eUzMUseS8uj/V0tc/DNlKpxoLCWGaewSZ2da7855cJ3KpFdraNJgziFZjklf/UuaM2ljq
	LSaW8bl5pQUCe5P8kSuRUQ4seBxrscY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3qpaYagkbAJUHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.74 as permitted sender) smtp.mailfrom=3qpaYagkbAJUHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788384939;
	b=PTDTTQMqSa/tUIGe/ThFgEuFvHd7vc0R0Nsp/uGRYkHhHDPQJRwIEyGWkJ+DGvLgve7Lty
	w5VzZcEetTes9vRXGwnqFdeRvrb42ZusmYtznrwfKc888IUpzI8KgG54cD3bd8A9E1NylL
	6FMcZkkwqPLmHGcBmUk+WdkMl6hyL/I=
Received: by mail-oa2-f10.google.com with SMTP id 586e51a60fabf-46abf222dc3so197918fac.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788384938; x=1788989738;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Z/JGNWxV8bK25k1HiaGt3SwTKzs4RSXT7cEloNky6KY=;
        b=b8x7l6M/PNVrwRi0vCOMNJkmMWjPywVEelzsSkAt+cXV7lPSJba1+UcKrcFyYu2mKv
         iK3+J/vQdXUUDQnhwGtcC65mNmec0GXE8KNxubV91R9Tjqtl8SXSGt1X16JDZDB7m3Bc
         KHn3F86h2jCT9Mq/Mv8YZgg0+qTEV05+LrMLDl8ZRaD0AQGK/PZxC7MddWPDiMmFkjHg
         okXBLiwMd3dlSxUqg9CvpKYlgEIRr2codk5ojfbALsDdDv1RUMdDZ5Ocf/r4Byc5nSRm
         QyBejkkcadJXP0a4tgSo9B31cS5IOJ6s7HUaOYPibBhi0UG8G8VTGkHIjZ/TaOW8An2m
         X0vQ==
X-Forwarded-Encrypted: i=1; AHgh+RosyJ21sQ4j+Ms4Rt8sMeFh57qO8repdVRB4wh036qe7A2615aXkcegg7VZzY/V5k3vuLKgjG/leg==@kvack.org
X-Gm-Message-State: AFuF++lH8pUqMbWeU07tD+4P8PPaIjpdS8Zo0VWhRUAGbyQU/+GQJq8E
	uObl7VPz+LTtrkB/EsTyDuHfqKQI3D5QvZYiyZ6VU8P0jmose/lcq6PsAcenNdMZ7B+se1kwSWF
	3eOOR/nS/C9+jBVGMG/6cVTGcN1avaEoh+jU55KU/6KCKoLYouYtQUufYt58=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81ce:b0:6b3:60cc:6add with SMTP id
 006d021491bc7-6b47dabc8f0mr6234814eaf.13.1788384938263; Wed, 02 Sep 2026
 14:35:38 -0700 (PDT)
Date: Wed, 02 Sep 2026 14:35:38 -0700
In-Reply-To: <6a87853b.ae6ddae5.3da009.0023.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9896aa.e163c37b.143a1.000d.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in vma_set_pgoff
From: syzbot <syzbot+f12658786a4153df5113@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, kunwu.chan@gmail.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lixinhai.lxh@gmail.com, ljs@kernel.org, pfalcato@suse.de, 
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7stwjz68orhzpzge4oyprgffkkm471p8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A782A0004
X-Rspam-User: 
X-HE-Tag: 1788384939-497106
X-HE-Meta: U2FsdGVkX1+bEUc2NfnVsS2ylEsSpNWe/v+EwlZ/XrJ4hduUfLd4yzk29XPCXnEzWKIYL0oetoCS+wEHpbEs5ZscMcvqpqcvB3M13X3woDaP3GMGLaSLVo2e7zFPc1Rw8BYmir/aR4sD6qPYVlVAjtm9cUwHrXFyB15DCUbzN3A/dzJkOz9LlKeBWXrsgg2YM5KsfJphxHxNm3Cid9hFsQKDnvKEKh4wxexT62NDLv9yHgX7v71dvEsDxGgut+4LHhrDW6clFDdzH7ASm8rQ1wL/B6Bo8ktXZCj7BsClcq8yqPpJjmoM/g+29G4OuRKmRTRKGJ9JfZKLgNQAM8HnyxjOnghzw2SLWB+A+ip/5BtlRUBeELrxaa8Vi4aT2cr2CJNlwF+Yy05Cknu+rskIki+KDFAWIIajzTG0kQNuD0J2lfiRvIbslXmWGXjqcp+f8y8iMf2toqpKm1KEqoPYJuAjKSIvE7sKoeWBcTu1xcW2gJIHBMmr/ggRydnyDW2pml+d63/fF2oKehtfG2IoLmeQIXeYKYB5SzJ6x2JKEjfq2Emp46RLlCzFh4DsB9aIAl2Uzx6tW0jIvk7dzc+5fKEHuKvLYwSBeIXzRqR1EAw8fQCvTCquKoOziypMHfa3wxl5PtVhyEZTs8bUxDnQIWTKlj5Cc+GsIV+Zbg5hTrdGfx/EHW23LksAe3C101JAFYMDOGpygveIu09S7tzwE30kznZ1/n1O6U56/SMxdqczkzjdfbGfA7RPhUP5+NJ7Q9YXNLk5uOaJqtQvILExkKTyAqGRl6Zv9I3k7U/u5Qbn6VrX4m0g0wABktaYPCeCzoFiA9EW6eOTU/GMbRfkRGo9LMlb0u8Lag8GDO+kDpSRSbXuWIdYcnUec6wIprV0x8UsbwFclR2IbDXcR26joc2XCQBQ7Jg2Dy8pB1G8nrAR4HtZgmpfd2aZZ5ef6Max3fGmI7ADy9rroJkyQiD
 X7+ZrKc2
 K/RHeE19pzU1b3NdDcozdoZYH1Z4ohPv/pxTcBRRyQuMsILnhg5gkl56wd/jfrBnqWd/u7RVlBRNDfxlyomlr2O6GAmKNBVSrBckPmrabVi1f/Tx9ECZJA3d9Df8nmXlLkwaqv6AN/kOCLm8y9VAHqxltykvszwtBLSWXHdMnB+SD5uW4vkHyFVPi6UIrihuA3eZx1AbxYFvJ+ALqeQX0TvuNRpQ78icRtdDCls2kqnCIMiaJQtrpsRaUU8QiSWhaCRud6dqq7uRMyAYIYjDoz/gRsmzmSN9+1hfhauRVnyp8XJ0GTOQCzqioVMg3BVFK6Z97WJsqvGpq4FfJwVRDISp64Po91szhonrNcZt86a5ers6Jz8uj8mGb9AkEbf4T9TXACuMOdv1sDyOC6TvcKZGfVsJFkPWttgqWAUjiPugp/FdOQ7h68aI1/dqB4mg18O3aLBy8yjHRvRfk7nnm5embyqyfNG99jJy0GcFyz0DFhgMKvKpqYIJWsd38/RwhsUhRvPzWSApgpALZJ0R3DILiEekdgOFXBDaWJLJXXTd0KBviusRlOXklK/xcTzgnVkmT6+mZ1r2U+C8NfUyDiq75sRh3JWWBo2J8IAtrzuz0FfxvXG7C6CWY2HYznWO2j4tY6EIhESVhpCVEaKufTQogJSpxc7ECDzTK1/KtJC03s6mtdV+gTZKFSt24n/u4Plt9c3XfhGrbfg5HbLSENeqXGQxqXOb981SSE9bYVsvu8GA0EIGlBE9aCnZq+EPzsJxBWNJxGtr1THi4j2Tkcm22EGI2MWuwZYlq77qoKFT9p3yUH2pxJWFAIMmzz55+9Ozr1RT89qNoh8Q4Pedmf0o2AQq0JXPo+oGxvQLWkpoKT04EUnOBVjoHQ3tm1bsP7+qj/iRwHNTGoz+3wc3xMTicDSBph99gX7w6jd5R+rD4n4HhQ7qgyvyqM23BPx8fGFpzI8DZ/GNLCmdzZbVt0LGtmVwh
 ucyBEDTu
 WPagmWlyuhHFITpCOaovXj5ZwqRKHFtG6KVedO/EGrkP+L2SrLvTCvvtYViCiWGpcegotM1fNVVjawcOELFkfHO3pw/DiksVmkYq/CD5eNcWvnB4ph3pvY12gvVLaUkOhDwzYB0SSmxj4AR3VGHKxQRekOcQscYRyXd7jawJi2RV/SF7PWveUBMWSIrEIN9oYZXPko5zCTqUaVJYz28GJ2TsclsEv3KdE+HNPJgWpzj1SHdlMH6DPW6PycyokJxo20N8dBuw8bYhvHHWjVsNFrXNxyrBE5A6tRG62tLxfAZzAAKjLNql+kmuZGzZZzHZSTLspUMS0rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    89a312991dc6 Merge tag 'cifs-fixes-7.3-rc2' of https://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=101ab0f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=f12658786a4153df5113
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=151ec39e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1761ef79580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9e57f69218a4/disk-89a31299.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c6ae7c71d018/vmlinux-89a31299.xz
kernel image: https://storage.googleapis.com/syzbot-assets/82fb8eee8abf/bzImage-89a31299.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com

------------[ cut here ]------------
pgoff != vma->vm_start >> 12
WARNING: mm/vma.h:277 at assert_sane_pgoff mm/vma.h:277 [inline], CPU#1: syz.0.17/5876
WARNING: mm/vma.h:277 at vma_set_pgoff+0x246/0x2d0 mm/vma.h:283, CPU#1: syz.0.17/5876
Modules linked in:
CPU: 1 UID: 0 PID: 5876 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:assert_sane_pgoff mm/vma.h:277 [inline]
RIP: 0010:vma_set_pgoff+0x246/0x2d0 mm/vma.h:283
Code: 0b 90 e9 d5 fe ff ff e8 d8 99 9f ff 4c 89 f7 e8 30 09 00 ff c6 05 5d 78 3b 0e 01 90 0f 0b 90 e9 fe fe ff ff e8 bb 99 9f ff 90 <0f> 0b 90 eb 9d 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c eb fd ff ff
RSP: 0018:ffffc900032af448 EFLAGS: 00010293
RAX: ffffffff82282165 RBX: 0000000000080004 RCX: ffff8880124c8000
RDX: 0000000000000000 RSI: 0000000000080ffe RDI: 0000000000080004
RBP: 0000000000000007 R08: ffff8880734021c3 R09: 1ffff1100e680438
R10: dffffc0000000000 R11: ffffed100e680439 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff888073402140 R15: 0000000000080ffe
FS:  0000000000000000(0000) GS:ffff888124dda000(0063) knlGS:00000000576bb480
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7203200 CR3: 0000000079238000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 vma_add_pgoff+0x1a8/0x570 mm/vma.h:314
 __split_vma+0x89e/0xa60 mm/vma.c:607
 vms_gather_munmap_vmas+0x322/0x1370 mm/vma.c:1507
 do_vmi_align_munmap+0x2b4/0x4b0 mm/vma.c:1675
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1732
 shrink_vma mm/mremap.c:1421 [inline]
 mremap_at+0x233/0xba0 mm/mremap.c:1652
 do_mremap mm/mremap.c:2008 [inline]
 __do_sys_mremap mm/mremap.c:2064 [inline]
 __se_sys_mremap+0xf9f/0x12d0 mm/mremap.c:2032
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
 __do_fast_syscall_32+0x27a/0x6a0 arch/x86/entry/syscall_32.c:291
 do_fast_syscall_32+0x33/0x70 arch/x86/entry/syscall_32.c:316
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7ff70ec
Code: 90 85 d2 74 0a 89 ce 81 e6 ff 0f 00 00 89 32 85 c0 74 05 c1 e9 0c 89 08 31 c0 5e 5d c3 90 0f 1f 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 58 b8
RSP: 002b:00000000ff97fafc EFLAGS: 00000206 ORIG_RAX: 00000000000000a3
RAX: ffffffffffffffda RBX: 0000000080ffd000 RCX: 0000000000002000
RDX: 0000000000001000 RSI: 0000000000000000 RDI: 0000000080ffe000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	90                   	nop
   1:	85 d2                	test   %edx,%edx
   3:	74 0a                	je     0xf
   5:	89 ce                	mov    %ecx,%esi
   7:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
   d:	89 32                	mov    %esi,(%rdx)
   f:	85 c0                	test   %eax,%eax
  11:	74 05                	je     0x18
  13:	c1 e9 0c             	shr    $0xc,%ecx
  16:	89 08                	mov    %ecx,(%rax)
  18:	31 c0                	xor    %eax,%eax
  1a:	5e                   	pop    %rsi
  1b:	5d                   	pop    %rbp
  1c:	c3                   	ret
  1d:	90                   	nop
  1e:	0f 1f 00             	nopl   (%rax)
  21:	51                   	push   %rcx
  22:	52                   	push   %rdx
  23:	55                   	push   %rbp
  24:	89 e5                	mov    %esp,%ebp
  26:	0f 34                	sysenter
  28:	cd 80                	int    $0x80
* 2a:	5d                   	pop    %rbp <-- trapping instruction
  2b:	5a                   	pop    %rdx
  2c:	59                   	pop    %rcx
  2d:	c3                   	ret
  2e:	90                   	nop
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	90                   	nop
  33:	90                   	nop
  34:	90                   	nop
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	58                   	pop    %rax
  3f:	b8                   	.byte 0xb8


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

