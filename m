Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC59D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 22:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301D26B0088; Mon, 23 Mar 2026 18:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B23D6B0089; Mon, 23 Mar 2026 18:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7F96B008A; Mon, 23 Mar 2026 18:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE7A6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:37:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B026F140D71
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:37:18 +0000 (UTC)
X-FDA: 84578790156.03.61DB987
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id EEBCBA0002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:37:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3m8DBaQkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3m8DBaQkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3m8DBaQkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3m8DBaQkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774305437; a=rsa-sha256;
	cv=none;
	b=lbNpZDlThH7rqE6n/hKW6xNcdB2HgK5/ZHyPQp9i6pl0BOU3Wh8Dvpv1TCjlGFoMgnhPrx
	ck6nujfRM8uXjs9FMtttD7Em3z2WZns+jgF8w42Ipx0PLWiy9J1oOabiVUNEn3pQx3T6Ts
	ub5d0JsO2p91BfzTq9K5VgTOjK5lfb0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774305437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Oqjmh2SrD9FfDowoOONetke0bC+WpW+XYQbNawQm8vc=;
	b=q+3ICZozjjj3pI38zvE1HJivRJSEpNNRGzOqsYf+yBiblReJydwPtYPD5hIGJTQbvUm9Wb
	W3GHl0JpRiYaEZIu5esMaK8ALEpSWmdBaADYLcNM8eMwxH08X7efTQ55SX2bUgzrEyE7A2
	UDRy1QQLHchQRJAx7ZUlMVccz7XlVlA=
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-41c5c1675c9so9179977fac.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774305436; x=1774910236;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oqjmh2SrD9FfDowoOONetke0bC+WpW+XYQbNawQm8vc=;
        b=ifRQPJMlKp9ydL/Uy9Gj1IgbSWbjB/XWk5D7w0wRpQVQ/JdaSatd0GkKhAh079EYCG
         SFbh6SF+QwYvp6XzyHYmMpHW/S3QZfNeyq6RAqtefuEAzJNgFedlo6ioUC66SsXzu57M
         /wRhPY9bRMTyeA5xIhBldtYf1IWwx1lbfyPhIm5Y11xax6wKD490jp62RE6kKOzjUm6g
         yqf8wz3Rxs546Tqvd4w6+Idix0SxtCE075BSLDcyHriLtJEPfcyeEQcIpy4Zu1DjHjhB
         WwNs1kTLrXOT/sFuRuNXHDTDiYT/TCuClHQ7TSu5v7msJTGwv1Fc5siPokS0Qv6QtDt6
         gF2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQb0PlBTPJDqRvmKvbdAxygG9GaKwm4w9VYO8XEcXDXJE9IMQVHW7tVYrpeWxQHcbpHBnSUmWZuw==@kvack.org
X-Gm-Message-State: AOJu0Yw5/DwrI1wr7BbOchnQG/2AD2Me1EaxbHnXP0czlgEuATMe5HsV
	3WE+quKKLenHOSUE3m5teKT66jW+5wNMI2GeweUYDa2XhxL+n99IbtV40bsLlvBh0fQJjmxQC38
	VCV7ufbTOpH37xN75/jFyfWowW6oOtNZF/ag48e47zGY9Ayt4qShRx7ptxUY=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:152a:b0:67b:a8f8:f68c with SMTP id
 006d021491bc7-67c22ff3dc5mr9608160eaf.70.1774305435967; Mon, 23 Mar 2026
 15:37:15 -0700 (PDT)
Date: Mon, 23 Mar 2026 15:37:15 -0700
In-Reply-To: <20260323162617.2421-1-jack@suse.cz>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c1c09b.a70a0220.59f55.0001.GAE@google.com>
Subject: [syzbot ci] Re: udf: Fix race between file type conversion and writeback
From: syzbot ci <syzbot+cie6df483244df2ff5@syzkaller.appspotmail.com>
To: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	luckd0g@163.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EEBCBA0002
X-Stat-Signature: wnr47x45rmgfca8xem3r1atzogzujz77
X-Rspam-User: 
X-HE-Tag: 1774305436-234313
X-HE-Meta: U2FsdGVkX18/Mhc47yNOumoNGBhTLZC6D7cUKgmSjxsN90yGY6A452wCX8J5PpgQGfrveeUHB2GCk8aRGIoUDuq93h3k9Z6D+Ns/xdC/RWv5lFaXaGnTOEdAsS9Q7hm9ginxQYmSWkS1jBG9Lq6I0qRHqjb6B885qI7y3FSSK4lIQFwqNJxUZsoK1DEB7ZKryda44YrXhdlmahTLpu/QGlBetn8EtIoIb1mlibMPRqKIQxn4VWtdrTOJzf+8mx4jHELXaLsc3OnS8eQ49VxmbLr/ZqGW6KNvJuU7p5+wAqN6OFAOBwXqG2LuBtH90dzH52nY2HUc+ezH0arrEY0ofwlzZfwjkDGPyIGxFeTdIV2ILpdsLXtiDhpcl30U8Jv7NOuUffuYznZEx0z6Rzp7mNZiy2W4j3lR/3J+LwKQFV8TxkMUC6KWTUuk2gc7DzFOtPIhRFhRwrISlvHzK7ikJ7UWrD5aREFOc4GOo+VRpS34W7mYqNmpv1Ay0gM2GWwkMxftPUqJQAbjcUBvnN9JjH4bZYEUJ5zDec4vtNoLr8ZS3o9AzsNDf9tnU4UGeJdmwNLH5XCohvYyiF8CtiYV/ye4AsGn98GKDWXVP1qHr3xiUsr06q+JUk7DdJWRd6ERulYEdRx9BNncG9cMEXpzpaXTffbkYATKZwHwhX2eKFmGNylkZe3uZRPlJJAXOuFPSNz9FD5cF7moyd5zb08oFOgZU7AKPgSCyjqct4MrpqUv7KtTNdBPY6kybOCrbddElAWCI89y21tHrOAiLxhrRA3suUMCPwLZd4R+31brBNa1z5i1ZCLVJtt1xUoqVVDLrUz8OAdUDJLozOqFIR2uy1QZUzNHyb93KnnIQC/KJ+DT7hzqCZhlfN4dIQlPmBIIPsHt5zB+8XdEMUE8CfZjI6x7AfJF1/qwwLXQhCT3ZZxaRk1SwfuwSxUNNoRSLXjBtKSBunQXtkNyvzs3I9j
 FgJxfgvw
 DVcQrQcgXsG2ra0nJdnVnpP+RSo2h2ZeUg9EDPIGGZJpQ7zcKxf5onSXUuUevyIwyOLQxA2lpyBLdsiVbkKgvc4UOKAIf/Bnx3tRL3L4mX0NfWakflaiqLq3uyhArU3MNPvfzwGeAnYCM5jW59LzwG2bkkmxlUPyln/+xisKSoAqjx+K9BWtDoCZq2FJXNVifvDT/W60fXvLng/6LKJQ5XBSyjoFUuvONvp5Jj90IUZ0qLz/wmcXNG8zXZm5pXZxCuN4g4C/uSPI+iw/qifp20+cV8Cw0MuAf76ZY7TMqBIoRAFMtKH4UmTU4OOZwbAAfJluSGko9LxLV9eVxCTpEQpBKDWGitBFhCceg4V0/5Wfd/LR0y2C4nifW9py9w/N/oeSWLsIvUrv9idWIFI7GAIC3b80ReUfxxoCuWpvrDqcr3K01IUqrerGwdu2AB6gZm/fogV2PsgSqL/H/3wMajfVIBm7c0acaMozJlxuzSyE8LrCmjfoJmlvmUlfRymfFyh2OgxlwXHiPtgEhLunub42yEM/iFstF9etnpU5d4M+OFtuRx9LIjcZnMHuG/HM1Ds6zDKeG9tEC+DzOMAagnKAmBgNPSVeuEsQca5N+PPevqORmCbahPuE8Yn2MHy4OabmRskTP/wLE9OmGfRtmajCzrV364v2dacVVBAc7htLQb06TGFgWYF8iDCHkMNwBwAq1zZFK1dmdfFGkD2Y7aMLVX58uASVJmwGe3s90Jq1uYzi5BLUEj+BZkVVKhyKAuo0fwyfyQQPlAycBqrKu+uM4oQlbzpGcyRBN/eamW3Gx6WDWjm7CUnZmcPiOEpwlvE3DBUcBNUGoFC8fvTxigh2enqq1PkWN8mp7pMCi0Wt4O0nmn/teln3diqrqjnRTwEuS9LzRsH9VGoABTUhE1xGO7I3k/WuIQ0EJDvk/2hQJT0YpTMvyPyNjPoIOqPRofTxwn+0Ix7vrTuQnb82tICQ2f5Ve
 IPU86t/I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] udf: Fix race between file type conversion and writeback
https://lore.kernel.org/all/20260323162617.2421-1-jack@suse.cz
* [PATCH 1/2] writeback: Export folio_prepare_writeback()
* [PATCH 2/2] udf: Fix race between file type conversion and writeback

and found the following issue:
general protection fault in folio_prepare_writeback

Full report is available here:
https://ci.syzbot.org/series/03e405d8-f247-471a-8469-f544c8393300

***

general protection fault in folio_prepare_writeback

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      af5802cff33fe3c557dff87cd3897d14241a7c6d
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d1944db2-4f63-4e26-b642-d71f55382c9d/config
C repro:   https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/c_repro
syz repro: https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 UID: 0 PID: 1860 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
FS:  0000000000000000(0000) GS:ffff88818de5e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00001b4fda9cd4b8 CR3: 0000000110906000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 udf_writepages+0xce/0x3b0 fs/udf/inode.c:205
 do_writepages+0x32e/0x550 mm/page-writeback.c:2554
 __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
 writeback_sb_inodes+0x992/0x1a20 fs/fs-writeback.c:2042
 wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
 wb_do_writeback fs/fs-writeback.c:2374 [inline]
 wb_workfn+0x414/0xf50 fs/fs-writeback.c:2414
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
FS:  0000000000000000(0000) GS:ffff8882a945e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00001b4fda9c7570 CR3: 0000000173314000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	56                   	push   %rsi
   1:	41 55                	push   %r13
   3:	41 54                	push   %r12
   5:	53                   	push   %rbx
   6:	50                   	push   %rax
   7:	48 89 d3             	mov    %rdx,%rbx
   a:	48 89 f5             	mov    %rsi,%rbp
   d:	49 89 fe             	mov    %rdi,%r14
  10:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  17:	fc ff df
  1a:	e8 f9 22 c2 ff       	call   0xffc22318
  1f:	4c 8d 63 18          	lea    0x18(%rbx),%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 e7             	mov    %r12,%rdi
  34:	e8 ef 6a 2c 00       	call   0x2c6b28
  39:	4d 39 34 24          	cmp    %r14,(%r12)
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	bf                   	.byte 0xbf


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

