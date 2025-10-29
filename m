Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50080CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30008E00BF; Wed, 29 Oct 2025 13:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B077D8E00B2; Wed, 29 Oct 2025 13:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A448B8E00BF; Wed, 29 Oct 2025 13:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD538E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:59:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C73B140837
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:59:30 +0000 (UTC)
X-FDA: 84051914100.23.B831224
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf15.hostedemail.com (Postfix) with ESMTP id 958A7A000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:59:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3_1UCaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3_1UCaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761760768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=o0mfO4AUVtUNaslHQlnN9Noi7qHI+LCieT2isRfktoA=;
	b=MwqoXPmXdNrvqJGl/KuNiPv8Oy52TyzoWwUUK163GHjuuVavYY4WCDfv7EB/6tR/f4EzCj
	wI84c+0P9BbDvooLKOqIt9S+uJS/G+hAuhu38Pvc0FyDags9Ar8GgNzrEcQGD35DQm2XKm
	k6kB+d4hURPeIlQsGl9R0sNtAADREWM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3_1UCaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3_1UCaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761760768; a=rsa-sha256;
	cv=none;
	b=5KfWNIP88wUQXU/UWZUy1l6se91Bk506m8XfS0ZH0IbnWoEDfV0D+0XuYyWJyGe8xL7YsQ
	97X5rM9+oSeGqq8WMwDydEHPqj48PAhX8OoAhAUFCdTawW3UPglmtKRydJLaF3oYtOGH+q
	NhkOSXBQX/F0ofy+zR/+Yar+/vPsk5g=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-432fb58f876so1695985ab.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761760767; x=1762365567;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o0mfO4AUVtUNaslHQlnN9Noi7qHI+LCieT2isRfktoA=;
        b=fwZkKQBgN2WHPHfmI0C+riRJk0YQsSMs/GVpcEjzVzI/Z1pO0TwfSCLULLr4l+ZknY
         4qxuvPAywikSuINdq14nu9HzGi4O98xRar4D0Mm0vQc6GK28jAusvuMTYIZ++eS6Mrly
         8XPdFNzgRTTOylpOR1ywGQq72MHynNBmQSUjZmpCRaeXQZxOJ6Q1PRUOx4BRPMFvmL3n
         EDU7QTWjzJbXXjSF+AKCVvancFCE9kvymNaFPAYHpHR5qT+ExPlW4S0ifrKsj2xW4Wqt
         gAix6rLHfWRzclmdZKpNPuKicGANOGpoL8YcVcQMH+8bhpYqB8TnHujyY3yLe7Dtqy/J
         tNfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkBGMQkJeukMBA6sxggo1S1EuSMtO4pIZaagDiyUHy6O2BVBfGgu6M1gg0FHTwWtPn1HYQFIYalA==@kvack.org
X-Gm-Message-State: AOJu0Yx7M9YurlapK8YgrfSxmWElq2p2T3zIxRXYCBdusc+6NVzsehD/
	BQiqSHzWz7gASAjR7x7QlpbwO1sxpF42+KRAig15CAkh3G0fzkIUKPKzY9tMG66GtsybyWeBxjn
	DXCgIfDeZKVOosZFeDkHtUap5QmcngAcfHJVFnbyaAMk+Lny2gZubPqTELsI=
X-Google-Smtp-Source: AGHT+IHWHTapYXwG+QZsDG9gOligy56lMRNZxNzacUMpU0A/f+8QUABCo3xjrySms6k9ScgYzR4O69cW2l8fDAIkmC2lkrykLPyM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1609:b0:42d:b5d0:1930 with SMTP id
 e9e14a558f8ab-4330154fb44mr4660275ab.23.1761760767655; Wed, 29 Oct 2025
 10:59:27 -0700 (PDT)
Date: Wed, 29 Oct 2025 10:59:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690255ff.050a0220.32483.0218.GAE@google.com>
Subject: [syzbot] [net?] kernel BUG in filemap_fault (3)
From: syzbot <syzbot+85cfa48c1a69a20ba5ed@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 958A7A000C
X-Stat-Signature: t8s79kng1khr4yr8cwu51abg4odofuks
X-Rspam-User: 
X-HE-Tag: 1761760768-49221
X-HE-Meta: U2FsdGVkX1+TiPqs1RynXGjXqdSQ63Ia3qVCSltbWLCEe7sbQllh4QA8GLeaTnpeyhxihL+KPnrd7dag9Zxmlv25+DVB/TzplBdgDwt7Z6W9AeaXGk89IHu9oVAYUfjJQzrqyVCxrdblYVFlU7zIslQaM7T4anPFUoUZ0S5Xsi0WonfU1/GUATAa3Uo4MD+1JvKUdWV24Ljd1JvM1GWgmtiv+lV6pAjV3pu3aciC160RIzxWW9VaynTC06Y9fifIzY9tpdfpDP+vkSARn77z3SNwn4oyb78oORDDplZVW0Jk3V1WVF5+Y4/tpWEy8E62rDgezoJ4TEOXaiHZWL+n8ct1gONhXhh3pnuw5ItXGy0z9xFJibedJqLk4Xa25vBu8zlF7JB/92TxJSMR+X8w6tMxV2T3RqTqtzkAqPRDnj06rUx+GCM48AGu3H5OYqRgrdOtBlN7Nq8lEnJk43abKOo1O6O4wnKhbUYlgQ6RCZJ/vg5/u7nRLVlq1daBqaC7ReJN/O8hBpPHuIYDgwkY/OflR6dtXMT+vBI7UoDjgcMolw05hEFhxlsB+dNra6Vcti0wVd8WsUCmJ2cSi+2FQqNfvudQUMEbRxf0Bal9d5GlpZZUpLhp0qmkHFe6Dn75mqEynALt9kQCP5d2VPTuyxW7Q0rJMtdFxkEmgrgcUvaz5r2HewsVNnoG76TnKTQ5Gny3HWnHSkY9DFFq6RDUXQOY2rh7FQgYSDKWLg5Pl9bYKO/XpQZBqYCIHQzDzYfDLI4UN+dPI9JJzQMyxKMRJGsBBTlcXAQQ1QhdElfj7mc6qXrA5UjP+ZqNLOG5lSZpUPMSqICILrbLotHbZe0uAWaEcOa2ZrcpuCaqYjn8gizSERAaNu3o7r8n6mLpo/joc8GyHm5Kt+Ksr0B3sAFZlY6xfoexSWTJbmPx9q/o7fzp07udD5N1W8c4NVpIHW2PbnTjmTrWqEOmkYPKwUb
 3FRgoCHf
 wqxssw7v1QmGRjI4IKxo6a3cC7vu+gNcMjycSyHxzfEPQXkSbYROOJiYcpwEnfOuPGCml5BRSLUCmWWS4Kqs53lMkQ1KfNAIQtf6oQR6lM8F2S7UjOqs548Js9PeZfbvAwg0SbS21nMMrrQjkcUZ4rxw+zXMVAo2+KOseI/1R9j0k2RM1jGjESAi7UXcXtopUF1SJaOrxoAblPvZCkx89OZDGYJK3p1l/BbGfWSoVcT6uKrpGVBRH8ZxIYrJLXaJP2ccsJanOBtsy3TrfL0gXNEnT9FeXQGji8+S8awg1qIxfVMObPiCuT7IwLF3CrCUNvDsO+TywtO2SH5mObDGcSwbL9yA0qCTXzGF4t6DmthFiehDAeh0rSJMwEB3Kc7XdMUwGefTOamABd74oYAH+LqwZ4xemfPY6lcjDziY1m9xmpu2xrerOp47lgdcqrHosfXrZLcFY4p8FMDhgQrkmU78yMRlwolN4c8EXB0KaKNP36ly23/jELJ4AkNfBgtUT3vK2eQ/JLhzGA1ROP9k67kXs8ILZUCv+HyDOHTaN/rWKb5dlxYa/Dh0q821V0C7IfWWAWQDtUDJiuLsx+3DtBG6eRFU8Qyex26ULpey1i++H+WeUnMSIwPHG4nrW20xNYRInfRZqdTNtq2sKDizNXSbifLkpA4nEBYhRGdR7g3Ez/sLH2LlZe3U8frvOm56UfZyjY/XkXzGSd/JBwq0lI1YCKn9OnW/OpWRjarfllv2WPWy4TsR19BQI9OEuvOPYFIqsDhScupfNi3bQRv/PhNqPkzzi2dhwj4+svOnk9tp3lrhUDZt71TSAG6sUnCZS88l49cd2gooljgl16zGpaKEZ9YiFQr+eihMt2eeBPRFIZSBoc4ViwbhVDmtI0O3a0vuha0aCIv4BjeloS3ETH/dmpOK87N+OqlzItMY3JHVrGBf9WiF4CHrxIIQ6PaI+P0Z+4xt5b0JAGxeWyWc47RtGXCJT
 aSZt1IQ2
 9SnoTcPNwLS0VyxcI2PhHELhTnNIurj4WabYLLoRAvJgt95BGJaiCwbJctUETn5eSgU4RuHn5X6loO9zju/pFlMAmfNOWj3PNncactA3mhrH6NCnb/HD5ocSFfd4EuZdX8KpgNysPbDZEpUyGCUYj7LIDcl6WrhLV7d7kk0eON5IA08qz93dm5rzh/eFRVgJ2HTg7vXgFb+b0YvntI/nN3ozf4O0VE9c5znuvzi+VY+vjTiHCVIWD6OQ01jtFAMp1/Tqev8q+hASqaykupzABGpQ77UvLrnLmpl/YFwrXIeVvtXbx8RKMQ6ZIQJB/eYIYl1gLP9hsg1eLeDvBE73vcGjG/cKvvK2tmf5QtH5aWoJOjyjgKHzJs0sKpArH6gwzH+l9mTx7wt+LcUolMMp5tDnubTdgo1TjaZEw/jHVj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    72761a7e3122 Merge tag 'driver-core-6.18-rc3' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10241e7c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd5b960ad8a33100
dashboard link: https://syzkaller.appspot.com/bug?extid=85cfa48c1a69a20ba5ed
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7340e06c0904/disk-72761a7e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0391e601c303/vmlinux-72761a7e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7744957ba534/bzImage-72761a7e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+85cfa48c1a69a20ba5ed@syzkaller.appspotmail.com

 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 50 tgid 50 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 free_unref_folios+0xdb3/0x14f0 mm/page_alloc.c:2963
 folios_put_refs+0x584/0x670 mm/swap.c:1002
 release_pages+0x4b4/0x520 mm/swap.c:1042
 io_free_region+0xb4/0x270 io_uring/memmap.c:102
 io_rings_free io_uring/io_uring.c:2770 [inline]
 io_ring_ctx_free+0x287/0x4e0 io_uring/io_uring.c:2864
 io_ring_exit_work+0x8c4/0x930 io_uring/io_uring.c:3086
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
------------[ cut here ]------------
kernel BUG at mm/filemap.c:3519!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 9010 Comm: syz.1.736 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:filemap_fault+0x122c/0x12b0 mm/filemap.c:3519
Code: 38 c1 0f 8c 8e fc ff ff 4c 89 e7 e8 8e d8 2c 00 e9 81 fc ff ff e8 94 23 c7 ff 48 89 df 48 c7 c6 60 5b 74 8b e8 b5 0d 2f ff 90 <0f> 0b e8 7d 23 c7 ff 48 8b 3c 24 48 c7 c6 e0 61 74 8b e8 9d 0d 2f
RSP: 0018:ffffc9000ef37a60 EFLAGS: 00010246
RAX: 50465a4911af7d00 RBX: ffffea00012c8500 RCX: 50465a4911af7d00
RDX: 0000000000000000 RSI: ffffffff8d8f29fa RDI: ffff88801fba5ac0
RBP: ffffc9000ef37b98 R08: ffff8880b8924293 R09: 1ffff11017124852
R10: dffffc0000000000 R11: ffffed1017124853 R12: dffffc0000000000
R13: 1ffffd40002590a1 R14: ffffea00012c8518 R15: ffffea00012c8508
FS:  0000000000000000(0000) GS:ffff88812623e000(0063) knlGS:000000005671e440
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000080000000 CR3: 00000000301ae000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __do_fault+0x138/0x390 mm/memory.c:5280
 do_shared_fault mm/memory.c:5762 [inline]
 do_fault mm/memory.c:5836 [inline]
 do_pte_missing mm/memory.c:4361 [inline]
 handle_pte_fault mm/memory.c:6177 [inline]
 __handle_mm_fault+0x1847/0x5400 mm/memory.c:6318
 handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
 do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0023:0xf704df88
Code: f8 09 f0 74 1d 89 f0 83 f0 01 09 f8 0f 85 3c 02 00 00 8b 44 24 20 0f c8 89 44 24 20 31 c0 89 44 24 24 8b 44 24 1c 8b 4c 24 20 <89> 08 e9 39 fb ff ff 0f b6 4c 24 08 8b 5c 24 28 89 cf c1 ef 05 83
RSP: 002b:00000000f750fa70 EFLAGS: 00010246
RAX: 0000000080000000 RBX: 0000000000000000 RCX: 0000000000000007
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00000000f750fd98 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:filemap_fault+0x122c/0x12b0 mm/filemap.c:3519
Code: 38 c1 0f 8c 8e fc ff ff 4c 89 e7 e8 8e d8 2c 00 e9 81 fc ff ff e8 94 23 c7 ff 48 89 df 48 c7 c6 60 5b 74 8b e8 b5 0d 2f ff 90 <0f> 0b e8 7d 23 c7 ff 48 8b 3c 24 48 c7 c6 e0 61 74 8b e8 9d 0d 2f
RSP: 0018:ffffc9000ef37a60 EFLAGS: 00010246
RAX: 50465a4911af7d00 RBX: ffffea00012c8500 RCX: 50465a4911af7d00
RDX: 0000000000000000 RSI: ffffffff8d8f29fa RDI: ffff88801fba5ac0
RBP: ffffc9000ef37b98 R08: ffff8880b8924293 R09: 1ffff11017124852
R10: dffffc0000000000 R11: ffffed1017124853 R12: dffffc0000000000
R13: 1ffffd40002590a1 R14: ffffea00012c8518 R15: ffffea00012c8508
FS:  0000000000000000(0000) GS:ffff88812623e000(0063) knlGS:000000005671e440
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000080000000 CR3: 00000000301ae000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	f8                   	clc
   1:	09 f0                	or     %esi,%eax
   3:	74 1d                	je     0x22
   5:	89 f0                	mov    %esi,%eax
   7:	83 f0 01             	xor    $0x1,%eax
   a:	09 f8                	or     %edi,%eax
   c:	0f 85 3c 02 00 00    	jne    0x24e
  12:	8b 44 24 20          	mov    0x20(%rsp),%eax
  16:	0f c8                	bswap  %eax
  18:	89 44 24 20          	mov    %eax,0x20(%rsp)
  1c:	31 c0                	xor    %eax,%eax
  1e:	89 44 24 24          	mov    %eax,0x24(%rsp)
  22:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  26:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
* 2a:	89 08                	mov    %ecx,(%rax) <-- trapping instruction
  2c:	e9 39 fb ff ff       	jmp    0xfffffb6a
  31:	0f b6 4c 24 08       	movzbl 0x8(%rsp),%ecx
  36:	8b 5c 24 28          	mov    0x28(%rsp),%ebx
  3a:	89 cf                	mov    %ecx,%edi
  3c:	c1 ef 05             	shr    $0x5,%edi
  3f:	83                   	.byte 0x83


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

