Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85743CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02B36B008C; Thu, 11 Jun 2026 16:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB34D6B0092; Thu, 11 Jun 2026 16:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1336B0093; Thu, 11 Jun 2026 16:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD5456B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:24:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 757091C2D43
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:24:42 +0000 (UTC)
X-FDA: 84868760004.03.C1C38A8
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id B03A7C000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:24:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3hxkragkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3hxkragkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781209480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=aJ0XVG+J6ePfnG2Ysl3vzXgB33Kh11LqKEd4gUXQNEg=;
	b=rARuZB7oIcEbeUhkm5VpBMQ5RwZ0DuzKYlnsi2Th7xU/nguknRxh6OelCvRW0R2MoBOuZ9
	ljiX8/sM3cMXwi3guF+by+DBwBdO1QaX/FFde3+uJhUK1w1LwwEYS3aCM+C4a22BCWOLej
	/z4Ygu+2309KL+eIrreQVeP4d4uSL44=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3hxkragkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3hxkragkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781209480;
	b=bHeeyB3xXHr194E6BEIR8+591lZbctuy3E4Ec1NeeWOTtuUd/LDGz2voqr726+W49or+F5
	ASg7vqUePIKn9NOHu/zq5Of+YGLT6E2Tq/6OVFCTa0eAQx4Q7tu+ZyQExWCvJxpYEkH2V/
	puQmVENX7wUcKszfymoMNDFI5DH4MIk=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-69dc9cb3663so487200eaf.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781209480; x=1781814280;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aJ0XVG+J6ePfnG2Ysl3vzXgB33Kh11LqKEd4gUXQNEg=;
        b=mOy4/6PpJ1IhkxLqoL0FQQ64coZH4bL2+EK/PXve6qgjq4l1ieGN915zm71EgZqDEf
         pWJ/WxmxC5g48e1EEm98LXVY2j9hR55Z2jpjOBm5hUiZcwhi2HyUiLvJYw/v0TmhyF4Q
         lfxwUZeuDAXkbY7oyBc62xFbtz79NUi4XM2Ousbudofo6jCZR9nYPprE24wgNQWjeN+a
         4p2ls60ZYKe57e/ZX3xgBgsS/DXRic60hdx2wxG2wCCBUk2iBWJZxA8Q36qx11w2cMZW
         HDqr7Ju7zeMw2lyOste5NvF5yzkUfeRfPshIMDwf+x3XAQ5yrHed3MWkg7NFoybmaXbJ
         Vqiw==
X-Forwarded-Encrypted: i=1; AFNElJ9SttWQTP9Ewp616rJpRHzc38qt/2ZO+uw4rXQ33hVN7iXmzZmaYqa/m9oupNCdkBlYo2afv5T6kw==@kvack.org
X-Gm-Message-State: AOJu0Yz1ID5fWOxGIRH5tWyz90CH43RA7QiWoc55mD4DMcUZwStN0n6i
	cTcLOVpruu3fT/gy1WKDqcTfMVvBaoe3fVHm6BzMeqwpr5aF4coEy77Hd4bXOYiBy3LFU/5JmUh
	tLXyuE0CwCRTkQkVMLdvLrgJxn2+9qrD5/uX/E+v8OEr7faRDUPX7X+x5eJ0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:608:b0:69e:390e:b98f with SMTP id
 006d021491bc7-69ecade914cmr3250855eaf.4.1781209479754; Thu, 11 Jun 2026
 13:24:39 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:24:39 -0700
In-Reply-To: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2b1987.99669fcc.12a77b.0000.GAE@google.com>
Subject: [syzbot ci] Re: mm: Unconditional per-VMA locks and cleanups
From: syzbot ci <syzbot+ci9dd46370954d5c77@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, aliceryhl@google.com, arve@android.com, 
	christian@brauner.io, cmllamas@google.com, dave.hansen@linux.intel.com, 
	davem@davemloft.net, dsahern@kernel.org, gregkh@linuxfoundation.org, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, netdev@vger.kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, tkjos@android.com, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B03A7C000C
X-Stat-Signature: x84rnbe1ywba1h6agkht64z9jqto6csz
X-HE-Tag: 1781209480-187834
X-HE-Meta: U2FsdGVkX1/m8+zahdI8Og24TAVNfWe5g/KB8jpyajD0t/meGTkpbblgtp6qKY0SnQTh8id95eLYInNuDvVu/3iEzCc6fJKZ2o6dtxt7gdUFNRvGY9hgyJc+PMQGGGxuNg2HW9Qz/ua4XkeGCfmZdiINMhO+gO10JLe7TpDy+c8R16v+hnnPIpD/gyxkBEcXuwW5vMjeIQ4yTtdMC32MiLVzgDz/p3hlgDvDOBTxsrPLURIl8GmrXaeIi17a2Tnz3uzWvP43htblH+wlJd86GPEMO43xMERLyjQ2SLd0lT6QoQSOj+oBLapCdx1vt1oyg+IcPWPaZtY9X2tvy8rDSMJOFGKMd1EoDN/1TBsEO4j/Zypl1mvh/LtMzN1WzjP5FY+4a29s3Rx9OUhk3aUNN5vFwSwSPDqsjUoJieYvtuzgxnqFf30LiZrHqLKwml+IzYanuNQPrMESwYq++LY99ZLh3KNaqR4BPG0iODcNmACbXvLeyyHez+ur6eyv1NdgVuCGP2oL8OWX2kbFz3nAeQWbWFAUtSmf/32E9TtfP41LGRYMsYsTlvEAu86e4YNQpA9UDguHU72gWbRQNtu4SW0CZHLv/W1TVLSJm206Ol3hmHDJKPC5Qd9cLe4eG0uxzmFNSdx8Qr2V4aHcltYjvUk7IkS/8pxytHapM7jryfrjfApgD7N71hikp4seAbmNfP8v+doihbVQ5+qz9QASSSpjwVogefoW3/1dD9mBqA7ZibhezPq9F4bSlNG9/0vWebufHzFynnhFMVREFCpv2PJteq+jsm1qyhl7zosrI/6Da47acXkr+wEYKkE8cyIwrsVxMlD4X37FwFZ+eP7JMPFRmWkKCYwPSmtGzhznWVzzWq69QJcv96D7JXvujd0WyyZA62KgcFErJHbz2CB3qjcxUnlz1MuIFup1WP/Oakwjqk763V146/Oqn+V7WwgYI05awzXHE7FAVnsBoR4
 TyiKptUt
 n9NZXOKUuC7naiMKMB5xi3+PyHPeHaU/FQnnAXmUO07BMR1GH6ky5gwZ39qg5KP0t6eXgtVILHv9EEzHEYV82M1GKwzvz10LQaNEFOBhWWQvGzzpBMLh/a7ub4Qe29D94QCsxte68dP0G1gwZ3yJGBZCiF6oaj/Nx0sBi6F2DEtOIZHXPcKqjWMW0aYiMh3vBsdSExJ/SO1GmSv+xoBxb3Ble8s+JJULrdJl9sj7Pg+ag0s5SQRcsYS334iau2qWgcnZFkz5T53T79FUSvt44vk2DzWsnkaKni7THg8nn91gKZbtyu80PcpPu/hRYKE/i8xL++qwNKVjbq0ScQXyQ+A59U4/+RrzZvLmdrdLAHwJ+TJqQ4O0W/RI+uW9fqZxK/fYJg/yrBEODoto5EfdiibM2C9efPurs3iqgjj1FHeA7P7Gwin9Gc1+5HNBRM7YyHdsqS401qzEwMzFaQHLhgJuVqJcutr4YrVMZQqkWJuCRurzrAIlhxgSmJCcjuC9Ozp+faFGii53xvANYp2vLCYwGasVaoGuJZKcqnX51N6iI8gMZ0eFSu14Hp9geTTXVnEAguH7f1j8kkQVL6VfwDDvhvU+L04iw3+oVLpdlcaenoVQZmVVwWaxIknClWfvk/MA7vUVLSTcxkEX4253Jl+ZLcNnAZ3ES2otRnR+UsvSSuWvzow2ZtJod/9y2LjN2uQINZsmFFRcZXWgvVMlRRRtGHrz8cLtZ6mBSWJAeOiqigw1xvG+fW7EiuUpH1nPwT18EoOzs62ONgdt5IgR+2bdOxAiUJa/za2z8PRtUGHKYe+W5k25cKBLmyqlz2pIWAq/vxU2m9l5NbguuwhT0BZZx+ZwgDsnWPdcIcCEBkUDvhTBMnWMeXTrcih4xbnXTQGjMUskzV40qKI+4jtQPd+WFHQouhhRM/fEhK/U7fxmhOspMYsFKy/x3QRSJf1AImFZ6akNlKFUwpYPrDeaeAP9xN3BV
 15EvAHrR
 u+EzOp8gfZPVImOh5b9rY4yZjLPU6cB2gRn77SGeaGeE1JJVlOYrEn06B+fgHPX+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm: Unconditional per-VMA locks and cleanups
https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc.intel.com
* [PATCH v2 1/5] mm: Make per-VMA locks available universally
* [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
* [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
* [PATCH v2 4/5] binder: Remove mmap_lock fallback
* [PATCH v2 5/5] tcp: Remove mmap_lock fallback path

and found the following issue:
general protection fault in tcp_zerocopy_receive

Full report is available here:
https://ci.syzbot.org/series/3e6d125a-b2ae-49a4-b833-babfb8bc9150

***

general protection fault in tcp_zerocopy_receive

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      c8459ee2fef502d6ef6c063751c33d9ac7943eab
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e7d66981-7900-4c3d-b992-664ccd13a57e/config
syz repro: https://ci.syzbot.org/findings/59d09544-f280-48fe-8ca9-a2fd8225e9df/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 UID: 0 PID: 5876 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vma_start_read_locked_nested include/linux/mmap_lock.h:240 [inline]
RIP: 0010:vma_start_read_locked+0xa0/0x300 include/linux/mmap_lock.h:257
Code: 28 84 c0 0f 85 2b 02 00 00 44 8b 35 ba 0d 1b 0e 31 ff 44 89 f6 e8 c0 e2 af ff 45 85 f6 74 48 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 b1 37 1b 00 bf 38 03 00 00 49 03
RSP: 0018:ffffc9000399f4a0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88816d558000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000399f538 R08: ffff8881076c64df R09: 1ffff11020ed8c9b
R10: dffffc0000000000 R11: ffffed1020ed8c9c R12: 1ffff92000733e94
R13: dffffc0000000000 R14: 0000000000000010 R15: 0000000000011000
FS:  00007f4866b966c0(0000) GS:ffff88818dc86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000011000 CR3: 0000000117c8a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 vma_start_read_unlocked+0x3f/0x70 mm/mmap_lock.c:362
 find_tcp_vma net/ipv4/tcp.c:2173 [inline]
 tcp_zerocopy_receive+0x762/0x2200 net/ipv4/tcp.c:2227
 do_tcp_getsockopt+0x2079/0x2940 net/ipv4/tcp.c:4758
 tcp_getsockopt+0x83/0x130 net/ipv4/tcp.c:4856
 do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
 __sys_getsockopt net/socket.c:2518 [inline]
 __do_sys_getsockopt net/socket.c:2525 [inline]
 __se_sys_getsockopt net/socket.c:2522 [inline]
 __x64_sys_getsockopt+0x1a4/0x240 net/socket.c:2522
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4865d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4866b96028 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007f4866015fa0 RCX: 00007f4865d9ce59
RDX: 0000000000000023 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 00007f4865e32d6f R08: 0000200000000380 R09: 0000000000000000
R10: 0000200000000340 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4866016038 R14: 00007f4866015fa0 R15: 00007ffc748de268
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:vma_start_read_locked_nested include/linux/mmap_lock.h:240 [inline]
RIP: 0010:vma_start_read_locked+0xa0/0x300 include/linux/mmap_lock.h:257
Code: 28 84 c0 0f 85 2b 02 00 00 44 8b 35 ba 0d 1b 0e 31 ff 44 89 f6 e8 c0 e2 af ff 45 85 f6 74 48 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 b1 37 1b 00 bf 38 03 00 00 49 03
RSP: 0018:ffffc9000399f4a0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88816d558000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000399f538 R08: ffff8881076c64df R09: 1ffff11020ed8c9b
R10: dffffc0000000000 R11: ffffed1020ed8c9c R12: 1ffff92000733e94
R13: dffffc0000000000 R14: 0000000000000010 R15: 0000000000011000
FS:  00007f4866b966c0(0000) GS:ffff88818dc86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4865dea540 CR3: 0000000117c8a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	28 84 c0 0f 85 2b 02 	sub    %al,0x22b850f(%rax,%rax,8)
   7:	00 00                	add    %al,(%rax)
   9:	44 8b 35 ba 0d 1b 0e 	mov    0xe1b0dba(%rip),%r14d        # 0xe1b0dca
  10:	31 ff                	xor    %edi,%edi
  12:	44 89 f6             	mov    %r14d,%esi
  15:	e8 c0 e2 af ff       	call   0xffafe2da
  1a:	45 85 f6             	test   %r14d,%r14d
  1d:	74 48                	je     0x67
  1f:	4c 8d 73 10          	lea    0x10(%rbx),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 b1 37 1b 00       	call   0x1b37ea
  39:	bf 38 03 00 00       	mov    $0x338,%edi
  3e:	49                   	rex.WB
  3f:	03                   	.byte 0x3


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

