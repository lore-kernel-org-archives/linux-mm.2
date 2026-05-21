Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B7B0CD5BA6
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BB36B0088; Wed, 20 May 2026 23:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BA86B00A7; Wed, 20 May 2026 23:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E1B6B00A8; Wed, 20 May 2026 23:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 296046B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1203C1D83
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:32 +0000 (UTC)
X-FDA: 84790059984.20.B6E62A7
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf16.hostedemail.com (Postfix) with ESMTP id 507ED180002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 39oEOagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=39oEOagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=LJzWxU5HwIwKulug+XUtwahdRBoxkSCgeN8FtBwRh9Q=;
	b=tWXUipPN1PqfiY/gi4NgT7XNpzoxW+mqd4Njx+GH0/T7q7jckP+SoDi/nH+Mz/+UXcmLiF
	CHuX7Zgq0CzgQ3ZHbLT24gP7GSmYzggNx0XTYAmOegB6FcnXPJE3L5558kSo0P2WW86qra
	Sk9JaXakDU0uqN3vbz36EPWYSqhzKCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335671; a=rsa-sha256;
	cv=none;
	b=EyoXQTbJ9h9qQ28l/ncXq7eV4XSBKkBqdfLKzcOsJX+Vz/mJOrhH9aed8+Xt5PdI9lIed6
	01gvUUDgM+xVExd0d81tT6Vyn64/Zvv4qRVAYAuRVqKrQpesBZGrARyhVrkws/tg6M7YNG
	etQPFbJx1q5vfDBFqVd8PlIOtTXDSn0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 39oEOagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=39oEOagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-69b91d4f9b1so13277361eaf.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779335670; x=1779940470;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LJzWxU5HwIwKulug+XUtwahdRBoxkSCgeN8FtBwRh9Q=;
        b=g2SLsOKiQGUyQHNjSuaSMM5iXZFwGXAfl219yvpVM3j68gToQNyTdy6mR9WvnxexPX
         yEmwDSsK8CnuP6WU1Ma6TERho/HRltLIoacTLL2WLVSPpFAdD8yo+lDUg2Ly0q9M7BbB
         CjnYW4jW7Dv7lyCctr+BPxoftatSjXiCNxgT2x/zEAmoLpaTcF2zopCL+brXA8R8K2fd
         5vEk5u8NT4FnOB/n6AgfPi+OQgwVBJslQ4p2U1gqAzp3Vd0+27NZDD7SgDA17YyHL28G
         QT3c5H8f0CI3lG3WDAlVOFjchVKdW3oX4Sr6zygnY3PB9pM3qnFUnQNtKpKU8K78lvbc
         Q59g==
X-Forwarded-Encrypted: i=1; AFNElJ/64rjetJAIe5M9pnp7mUWAOLk1ZUQc7Aum1ZZXZ+wYHuWgd9E0JzYAQba1FU+2SxJaXIL8BZLFWw==@kvack.org
X-Gm-Message-State: AOJu0YyYklwPj8UMeNcOhsaovkM38VcmmVqRRhogWPLFnUD62dmlA8ZT
	YUe/ZVwqcu/9Z1hvGnQsuK1zlReauT2ehj+PceBEb8eLkDJTO2xPcciH7/Q5Kafi08mWSMd7oZO
	SSvXbW/HMuPf26Jo2fLp0UHsJrkLmcZTJRl3dp2WFxzN8L39pRRCLfVAINtE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:168f:b0:696:8cf4:a117 with SMTP id
 006d021491bc7-69d6ef07503mr467687eaf.51.1779335670388; Wed, 20 May 2026
 20:54:30 -0700 (PDT)
Date: Wed, 20 May 2026 20:54:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0e81f6.a70a0220.c4b15.010d.GAE@google.com>
Subject: [syzbot] [mm?] [ext4?] BUG: unable to handle kernel NULL pointer
 dereference in qlist_free_all (10)
From: syzbot <syzbot+741fee3eb7f4c4e6992a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, pfalcato@suse.de, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 507ED180002
X-Stat-Signature: dngoezpd5baf5kkeb66puyj6ttgqn6og
X-Rspam-User: 
X-HE-Tag: 1779335671-945663
X-HE-Meta: U2FsdGVkX19ah/za9aeDk1atkhmNB1Xai3a1bY3elkPNLb5BI6ZzBi1ruhg6/3CQjUSO87oFohz77WPPagUAdrglXNqMm9S08wz2Z4LXr8DqRxpj6i9bVrr9lowQGMdDoa+UShYePLv24NuPxnbOqpSpGPtPUjBJD2OX6PthLx1p/0pxGUVkPprFfd5PYfFyURZY2/4Yc2zHzFXFJhfPU3PcAzdRHXwhE8QFUZpZch2mgTvLm+DpnfSSNJIcOJWvLBAFll+7dUV66yTF5sVY2D74U1yapUyN+HUsE91lsy+I4o97Cvpgk8qHQ9+dzJiPFsGNB2FkxyCD/EVTGqfPXXe1KqwhhSrQiQmQrk0Kyvu6aD/LIfBxsLuQHTSG+GE6Qh1ny5ZRT2+/ZSWN9Imp45CnWLY8WjeSIO+TfheQlyG9BTXvmXq0I9AYPIMHGff/Rt5zjaKgBEVcI3fTzTJcfGGGof7uRX/FutU58Qm6A4rgXSrYOIM4FLBzPDmyb8Nnl6JghFR3jA6toeC05nqr8KwzeoVcBpGf3v7Yw2JQzuGpdRzZ7l6TfemXBGjmEjpCpoSF2hYPTpNuvaof4aSEx0bec0gc5TcPac0nOr7JFMRYyWRPCM8GcKlNFWklFhvEJLMSzHKPYIXDKeK/Xz0QEX1enDw5lBJyLPGbJ6nwuVvzdoQcIsUbEWvkjksZ/x21Qmxq1SxdGA8YpXtc8CfJE9xNEmBP8Bzii5DR7CGi/VooxpWTa+JPV6IX284WRNjEGbN3pZxe51Lh3mN8Hq/A+lRPtMcprV90lKgHgZBhKbkPzFn/uIMKI3Q5UH085ElvAzSo4e0TPsJaWvEdUrS+mVO2tNxtM9hoyBjHMy6GrU8TqdXyWR2+jEHfyOgVzs/FuuyE/CM9lnqEfxtoEgXYVqb71dR3FtsVHA3yi53RqqZbfmxOctIwWtgF4Nx5F9S0dob59Mm7FJD3BuqzPv8
 JaYp/je9
 UTp6Y9xtNIKQ6iBQDtQbwD0mPFX7rIZI+E75B6rdNJVHKJmezhDhC/l1UZNt2NpuWNlAd6RGLEst5lmNNMP/GcixAbNas3qrJWBmNumvulV8iB29AqUHxaI4MkEB4DF7wMukzh2VmOlqVNLWVv2t2b/ZyZAgOsamb7AIAuS8umLaZ1Rosnje66dOvZJUa0JGq293L3OWNxPJ8wni0UQf2+nJprIxPDzf4mmmW1dCSP8t2sONPVTaBmacDoGItXvL3nsaqB4jNdyJ7YQuxzYew90v7NlGnfKmVpCt2yWmmiYE7QzcMv4m1Oc4otk28tRsiDGqw4XXXUuoiYmRZJHiDI3xSr/euQnqhBt8qta8ezkT6aNYfSOxexPzuuAD6//64JJjKoYeHgxONlzjVsqEuTB+0yF8zbEyuWt0w5SbY74+W/WBbPAPAILv/qi8Gxt5qt5WjldWp469PazKIJNcCcuSxhy6iQyzgRUk4zZCTU1EFJl4jSe7rFBV1YPTDseJZfrZ8STX1hB7pSjeYRt4/GO7P8XCC6f765LI1WtAU+kEtejvpI6M4RyS+5cIgME/4Rwg4GkeFzG9/MQbc/3tgKrgrVfKEvLkMFJxawmVhUxmNf6rQbeb8XuVA1pShHzG6QPfFrzn3NoE8TlwU5jqEWUg3NjpXU+a6enLx2XxRge+/lFBGcHjEdb1CMwmKu/waENIs9GXbqhjLv6++SJ8kOxCNpTQfwlfpHWUkuZz9BYHPWbx/4FAl+VnyjkoyIu/212oF0nmR6ER7VdTbeuKtr7dfuLN+12SS4KlIc5aG9tQ2iROrSsKx2GSJR/tEps5Y/NZybKt9CdUSTUqZDPdq7QGOkoAe9CsO0Sml03vxYr+4cMQdPwanSzjsn9Yw5PiHxRiXZe0ER24PRr2DsFGH1Jm+Sn4hQejXJR0T8dlCNgiKlU+euotVNO1AB/6zwkPB3Uuh+JU5Z8iFMG0QhsXipEHlsPKP
 mtl2Nqsa
 +4oFxbU7KQLRoWS6u1jeJDdwqRyAaa7eMzmSenOMFJD6iAodBN3EONqx/PyHygfiSjMeRyQ/sMtLiHgeisJPRUdQ8km/7QrStIi1BO/GXimmA1U+sDknjr7kdJsaE7D19Di85LRHD0BQ4qJAEFIOJrl50eLoxTKJS2hS90lgH+YEmsmba6QLW+LNzYkNaucOwP45EZ7aCpA2DrkBWel+cbpCQoYAPvXcxfnh7AmKNfRtCccaTfDc7L7ZSS2ytSkOWTRkK3RshqULz9+PvNlkn4Zf8IET1PzdxS1/cKFnMGN/dgqQoGjZWNDFnMxoQGIzZTTYuJ8H8lGsVHb9nPuwe3PraTtZqMFdQn7y9pZ1RfM1bFNhMFKnsay/hxOXSVkfQrT7uaaLObsgAce2YHxulnGm/jzyg+Qbo7ZSdYcPvwvcxMy8FpShFLNtGUf2+LmMAoKSGUgkrpHefOiUH0Wox41VvvRf5pOQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    df685633c3db Merge tag 'rcu-fixes.v7.1-20260519a' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17beec2e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f0911eedbc130a
dashboard link: https://syzkaller.appspot.com/bug?extid=741fee3eb7f4c4e6992a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110e6b06580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146b4c2e580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/90074e46cb62/disk-df685633.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/691247547753/vmlinux-df685633.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e1c705a2acac/bzImage-df685633.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+741fee3eb7f4c4e6992a@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000008
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 800000007c8b6067 P4D 800000007c8b6067 PUD 0 
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 7032 Comm: syz.0.224 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:qlink_to_cache mm/kasan/quarantine.c:131 [inline]
RIP: 0010:qlist_free_all+0x8d/0xf0 mm/kasan/quarantine.c:176
Code: 48 89 c2 48 c1 e2 06 48 03 15 1f 8a a7 0b 48 8b 42 08 48 89 c1 83 e1 01 48 83 e9 01 48 09 c8 48 21 d0 80 78 33 f5 49 0f 45 c5 <48> 8b 68 08 eb 88 48 83 7d 40 00 75 9b 66 f7 45 08 04 02 75 93 8b
RSP: 0018:ffffc9000654f428 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff88802c2a8000 RCX: ffffffffffffffff
RDX: ffffea0000b0aa00 RSI: ffffffff8df1f2e9 RDI: ffff88802c2a8000
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88802c2a8000
R13: 0000000000000000 R14: ffffc9000654f458 R15: 0000000000000100
FS:  00007fa39d6a46c0(0000) GS:ffff888124374000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000000757fe000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4569 [inline]
 slab_alloc_node mm/slub.c:4898 [inline]
 kmem_cache_alloc_noprof+0x241/0x6e0 mm/slub.c:4905
 vm_area_alloc+0x1f/0x160 mm/vma_init.c:32
 __mmap_new_vma mm/vma.c:2547 [inline]
 __mmap_region+0x104d/0x2da0 mm/vma.c:2771
 mmap_region+0x35d/0x620 mm/vma.c:2857
 do_mmap+0xc63/0x12f0 mm/mmap.c:560
 vm_mmap_pgoff+0x29e/0x470 mm/util.c:581
 ksys_mmap_pgoff+0xe4/0x610 mm/mmap.c:606
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa39c79ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa39d6a4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007fa39ca15fa0 RCX: 00007fa39c79ce59
RDX: 00000000000000db RSI: 0000000004020009 RDI: 0000000000000000
RBP: 00007fa39c832d6f R08: 0000000000000401 R09: 0000000000008000
R10: 0000000000000eb1 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa39ca16038 R14: 00007fa39ca15fa0 R15: 00007fffb789fb58
 </TASK>
Modules linked in:
CR2: 0000000000000008
---[ end trace 0000000000000000 ]---
RIP: 0010:qlink_to_cache mm/kasan/quarantine.c:131 [inline]
RIP: 0010:qlist_free_all+0x8d/0xf0 mm/kasan/quarantine.c:176
Code: 48 89 c2 48 c1 e2 06 48 03 15 1f 8a a7 0b 48 8b 42 08 48 89 c1 83 e1 01 48 83 e9 01 48 09 c8 48 21 d0 80 78 33 f5 49 0f 45 c5 <48> 8b 68 08 eb 88 48 83 7d 40 00 75 9b 66 f7 45 08 04 02 75 93 8b
RSP: 0018:ffffc9000654f428 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff88802c2a8000 RCX: ffffffffffffffff
RDX: ffffea0000b0aa00 RSI: ffffffff8df1f2e9 RDI: ffff88802c2a8000
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88802c2a8000
R13: 0000000000000000 R14: ffffc9000654f458 R15: 0000000000000100
FS:  00007fa39d6a46c0(0000) GS:ffff888124374000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000000757fe000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	48 89 c2             	mov    %rax,%rdx
   3:	48 c1 e2 06          	shl    $0x6,%rdx
   7:	48 03 15 1f 8a a7 0b 	add    0xba78a1f(%rip),%rdx        # 0xba78a2d
   e:	48 8b 42 08          	mov    0x8(%rdx),%rax
  12:	48 89 c1             	mov    %rax,%rcx
  15:	83 e1 01             	and    $0x1,%ecx
  18:	48 83 e9 01          	sub    $0x1,%rcx
  1c:	48 09 c8             	or     %rcx,%rax
  1f:	48 21 d0             	and    %rdx,%rax
  22:	80 78 33 f5          	cmpb   $0xf5,0x33(%rax)
  26:	49 0f 45 c5          	cmovne %r13,%rax
* 2a:	48 8b 68 08          	mov    0x8(%rax),%rbp <-- trapping instruction
  2e:	eb 88                	jmp    0xffffffb8
  30:	48 83 7d 40 00       	cmpq   $0x0,0x40(%rbp)
  35:	75 9b                	jne    0xffffffd2
  37:	66 f7 45 08 04 02    	testw  $0x204,0x8(%rbp)
  3d:	75 93                	jne    0xffffffd2
  3f:	8b                   	.byte 0x8b


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

