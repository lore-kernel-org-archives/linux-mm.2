Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF532D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 07:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B7A6B0005; Mon,  8 Dec 2025 02:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C4E6B0007; Mon,  8 Dec 2025 02:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61936B0008; Mon,  8 Dec 2025 02:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 924346B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:18:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DA69BC352
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:18:29 +0000 (UTC)
X-FDA: 84195450738.18.DE1F2B8
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf09.hostedemail.com (Postfix) with ESMTP id 91ABD140006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:18:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3wns2aQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3wns2aQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765178307; a=rsa-sha256;
	cv=none;
	b=o6RtrzIYiQ+8yj+2RC6uIfdc12oGug6xLsHTms8b6E65xryIcgDG+yMbGWTXBUT6Z0fM6t
	CzcyzvGCPladqPMrhCVDoTX2GA56YxS5PryeNnHKRx0Q3483vV/+ls2jPJTcnsYqsw4gh4
	Ak2ShUzmuH0W00Dcr0Zo0gWjcp/aZ+4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3wns2aQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3wns2aQkbAOMXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765178307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=jIinOqVwgE0m1B+fJuAGYu794SpoG6g4HIkbNJ3Np30=;
	b=8dQ1oqbWrOvJ8zLJTHm596q7NR/R82io5dLp3m+LLnVmdA6AXL/eAV9kxaiuZtQpohYmSN
	bmz9FcRwhGI3Q0kWENy+1vO19oCt3ek/EwUnMMJGfQymlCK1KFoGt6zYpjoemc9bTMAoCb
	eEzly+RTJqtN/T9SAAlOaxDIM4cUFBg=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-6574f3b6ec1so6121469eaf.3
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 23:18:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765178306; x=1765783106;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIinOqVwgE0m1B+fJuAGYu794SpoG6g4HIkbNJ3Np30=;
        b=YxtAFGy7ZziHy8ftnP1hqJV+YxnAjeUhQct1RY++X10MtlD05bTncIDszSMXqKS54R
         mhO9loUo3h0t0awVW6gsAbuUho6kicH1twrJkmXONLpwkbUmm4744Acnomh7i05fC2dh
         SDIbBteMjF+4OkLXiky95aD91CybB5alENVBN2KRsw8EZC4hJRh0NUSqK7YUwXkxZdtP
         59nJ/Z4fe1PWxDq7I9oFrodMFNqqHrKGNceVw7nVeKd7TVbLr+fZCygAw4A0OVie7XnZ
         5q6KavjstRuvxO4NlnCbvfQZuFWXqiFwI7El+2DUjIDBCWb0cZ/WbH0jlRbeeLePDfEQ
         fnnA==
X-Forwarded-Encrypted: i=1; AJvYcCUGGDuB1gCAcJ+Ty9M0VRZPHsEG9beXN52lWly2SX24c/ohlmcunFpoi3TsJsP6Mb7wCijSMPCB8w==@kvack.org
X-Gm-Message-State: AOJu0YwK16cmNWrz+2jH+Ar/GQAUq4g/hjK9jlLXr9GSF/v6NbPkw9Dy
	u+pdD+xjj3N29tcVeCrYUSkjTEHa4G7MymHDVm+PjSfyMg9yedI72qrPP2Nhdb/XI755f1vBfd0
	zZ2mAWucDRuMRunqxT0i5m6XFyyNYG43dlnnuDLUSfzJULypnPzz2+e655Y0=
X-Google-Smtp-Source: AGHT+IFAlIBsrcf7U1J/QwXBwMnChmQs2/uEkmL81SP7lVa+9RWb5xKi/Wlk0rxybf3mTO4G32lBWzqGMob2ZPELX+iiniMF1ERx
MIME-Version: 1.0
X-Received: by 2002:a05:6820:168a:b0:659:9a49:8e9a with SMTP id
 006d021491bc7-6599a8c7cc1mr2600412eaf.30.1765178306575; Sun, 07 Dec 2025
 23:18:26 -0800 (PST)
Date: Sun, 07 Dec 2025 23:18:26 -0800
In-Reply-To: <690255ff.050a0220.32483.0218.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69367bc2.a70a0220.38f243.008c.GAE@google.com>
Subject: Re: [syzbot] [net?] kernel BUG in filemap_fault (3)
From: syzbot <syzbot+85cfa48c1a69a20ba5ed@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, kuniyu@google.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com, willemb@google.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gmoorzhbnddji9cxp867jsewghi96bib
X-Rspam-User: 
X-Rspamd-Queue-Id: 91ABD140006
X-Rspamd-Server: rspam01
X-HE-Tag: 1765178307-73023
X-HE-Meta: U2FsdGVkX18pk4CvfroAbMqX/aQkHTbX5SEpoXi/bIhpbVNmjuqqsk/tiAHmre64X9FKDoPj288j2kZT+0FYvRc5dZDTyIavOP14QuVaLfNAh/90bIAQnjHEBB2Yoxr7RGy2RC+noZ4/SYrv1OSeqb+Guo7TjkfWmt4i6mP4Hf8/8+c5DAv/vGNFRWXmFwAjPmGRJ2+3NIa4MlRdjYrgr3G679R9kC3jsDK3eEDeqDNkTGin6njyORgqyLounfOuotXqjI9zA6hOXiweMH6atlHyPY/Qvo91XRMxS3O46wK/4WUHf6vm0UPltolO+b9PSGw3UgamaX1P/IbFu08H5t+Xm/n+VzP3AX/xvjY+K664lWCdzArstpyJC1FB/XUGi37bJ9seaNhx1SJ0I5mcef8NFw//4sLlgsbI1g+k9PKHlzhJh+d4dzYEVy6D6XGhoFW+KQiwizyyLQrFPiY8OJMGiriuAPuKPZFuEvlttHfqE/tzrvLxKHQcz2O8rnIKuKmBMtOvV6ftSb8A91BxAzUEVTgeskZqJglDX0MNJSfEEV2VhMMH7CSyC1uAT29Z6V/lwFw3uIB4drCYtJpbGmhuMLHwzCoyncGMcmlfCWASqpUuXFZWmyeu8jggAJLev/TA+bKnbnRuRiE3yokCNvNkl2i40vba+879uaLF/yEb5uSKmzhqXmhe7SntEXzw32rl6s0F06HWWLPgMOr9s+AYamGShpwSW7aXQcw2H5061ukDR5209XT8dMk7iy+SJLUhFJlj0yd2cEaZR2rDbm4IHLJFxLkPnOKHTAZ9kUbly60laOUNKMVZVJ8jMowKbiMSk+sf3HgSklHNYsFtnDvIDY0mI9soc9mrpCsmHP+upnH1Ar/hh2lS+RQsc/6pe2jDqQ9jt1EXaBL/7gcIdFiBxEJx2+f2H3FGDrpmyq3+4RZrNiNgFjTk71sWUbb0xwBCVCd4/DKMZI2xL4d
 kSBPSj4F
 Bl1/z+/efOMs2BjMaeBEypvp2g628BCJDsRqhywQ+S2Fh60O9B2qTF0/S1Go8KG7VAjN6/Eb5WCHXkKgNNgGpvoAcPrFv0RNxoA2qSb5hFoJUsqktZ1IGlH9/n+11EDA12cCxUwW9MVQkhsDtsaQAH8Amu5XEAh0b0aFZeBjPfAeEQd8zTxoX7jmPMdqCQyCYu7jwIsMBfHxFYvxEwVev81RRjFLX1w5IzCa+vZ4M5ANDRrvue/GiipJPoFhMHtwCGPURd8FVZ4FM0IH5ROwydyn+tYlxZTY4s5CvwkSxRCyOh896cj6XKy7RmexNDv2CVydFekgipPuJCVThtKGeTgHhrzJWXUDRYmxIWLq1CG5nT8AOLn6y9k6POtY27s1/D4KkWrDohd1khSk1vqSP+2u+r1sZc1P7qNv6DIvQER1FklC5s+EkprTBHUPK8PUW7T7wF8ieyR3C1kftI20IpmkCbYa18y5wZ5VQfJgDV8/SDEi4ZDijM4hXaG7oNe7OHGBBMzzrOGYjC1enN7Ir+wD8mQD3LSsHkqH31/7otSlq8aPPWGMXWwq+tyPpPu6Mhw6EO0Nc4kpmBNNvYJ9n2K56l/gvB5+tec0oWBhaItV4lrCQm7Xstm1IMqBqXfek07sy/au5tFcgjE3pmAxS00VfvoUi5m5LIb4AThYzINcG2ghIIu0/GeLEVfDe2RrCpxNu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    67a454e6b1c6 Merge tag 'memblock-6.19-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=125ee992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=675cacd7a6e90ec3
dashboard link: https://syzkaller.appspot.com/bug?extid=85cfa48c1a69a20ba5ed
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11988a1a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115ee992580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0720a50dee77/disk-67a454e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/69f7900759fa/vmlinux-67a454e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2f0fa3e38fe5/bzImage-67a454e6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+85cfa48c1a69a20ba5ed@syzkaller.appspotmail.com

 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x6c5/0x2310 kernel/exit.c:971
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
 get_signal+0x1285/0x1340 kernel/signal.c:3034
 arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/filemap.c:3579!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 7393 Comm: syz.1.310 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:filemap_fault+0x1215/0x1290 mm/filemap.c:3579
Code: 38 c1 0f 8c 8e fc ff ff 4c 89 e7 e8 b5 f2 2c 00 e9 81 fc ff ff e8 1b a1 c6 ff 48 89 df 48 c7 c6 80 a9 74 8b e8 dc f7 2c ff 90 <0f> 0b e8 04 a1 c6 ff 48 8b 3c 24 48 c7 c6 00 b0 74 8b e8 c4 f7 2c
RSP: 0018:ffffc9000c3d7280 EFLAGS: 00010246
RAX: c461c012ec26ac00 RBX: ffffea0001682000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8d7867c7 RDI: 00000000ffffffff
RBP: ffffc9000c3d73b8 R08: ffffffff8f817677 R09: 1ffffffff1f02ece
R10: dffffc0000000000 R11: fffffbfff1f02ecf R12: dffffc0000000000
R13: 1ffffd40002d0401 R14: ffffea0001682018 R15: ffffea0001682008
FS:  00007faedeecb6c0(0000) GS:ffff888125e44000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc2f31bef98 CR3: 000000007da76000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __do_fault+0x138/0x390 mm/memory.c:5320
 do_shared_fault mm/memory.c:5819 [inline]
 do_fault mm/memory.c:5893 [inline]
 do_pte_missing+0x6ad/0x3330 mm/memory.c:4401
 handle_pte_fault mm/memory.c:6273 [inline]
 __handle_mm_fault mm/memory.c:6411 [inline]
 handle_mm_fault+0x1b26/0x32b0 mm/memory.c:6580
 do_user_addr_fault+0x764/0x1380 arch/x86/mm/fault.c:1387
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:__put_user_nocheck_4+0x3/0x10 arch/x86/lib/putuser.S:104
Code: d9 0f 01 cb 89 01 31 c9 0f 01 ca c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 01 cb <89> 01 31 c9 0f 01 ca e9 c1 75 03 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000c3d78b8 EFLAGS: 00050202
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000020000005f7b0
RDX: ffff88801eb45b80 RSI: 0000000000000002 RDI: 00000000ffffffff
RBP: ffffc9000c3d7a30 R08: ffffc9000c3d7667 R09: 1ffff9200187aecc
R10: dffffc0000000000 R11: fffff5200187aecd R12: 0000000000000002
R13: dffffc0000000000 R14: 0000000000000000 R15: 000020000005f780
 ____sys_recvmsg+0x2ab/0x460 net/socket.c:2825
 ___sys_recvmsg+0x1b5/0x510 net/socket.c:2854
 do_recvmmsg+0x307/0x770 net/socket.c:2949
 __sys_recvmmsg net/socket.c:3023 [inline]
 __do_sys_recvmmsg net/socket.c:3046 [inline]
 __se_sys_recvmmsg net/socket.c:3039 [inline]
 __x64_sys_recvmmsg+0x190/0x240 net/socket.c:3039
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faeddf8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faedeecb038 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007faede1e6090 RCX: 00007faeddf8f749
RDX: 0000000000010106 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007faede013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 00007faede1e6128 R14: 00007faede1e6090 R15: 00007ffe1a004ab8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:filemap_fault+0x1215/0x1290 mm/filemap.c:3579
Code: 38 c1 0f 8c 8e fc ff ff 4c 89 e7 e8 b5 f2 2c 00 e9 81 fc ff ff e8 1b a1 c6 ff 48 89 df 48 c7 c6 80 a9 74 8b e8 dc f7 2c ff 90 <0f> 0b e8 04 a1 c6 ff 48 8b 3c 24 48 c7 c6 00 b0 74 8b e8 c4 f7 2c
RSP: 0018:ffffc9000c3d7280 EFLAGS: 00010246
RAX: c461c012ec26ac00 RBX: ffffea0001682000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8d7867c7 RDI: 00000000ffffffff
RBP: ffffc9000c3d73b8 R08: ffffffff8f817677 R09: 1ffffffff1f02ece
R10: dffffc0000000000 R11: fffffbfff1f02ecf R12: dffffc0000000000
R13: 1ffffd40002d0401 R14: ffffea0001682018 R15: ffffea0001682008
FS:  00007faedeecb6c0(0000) GS:ffff888125f44000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd80c2bd48 CR3: 000000007da76000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	d9 0f                	(bad)  (%rdi)
   2:	01 cb                	add    %ecx,%ebx
   4:	89 01                	mov    %eax,(%rcx)
   6:	31 c9                	xor    %ecx,%ecx
   8:	0f 01 ca             	clac
   b:	c3                   	ret
   c:	cc                   	int3
   d:	cc                   	int3
   e:	cc                   	int3
   f:	cc                   	int3
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	90                   	nop
  1d:	90                   	nop
  1e:	90                   	nop
  1f:	90                   	nop
  20:	90                   	nop
  21:	90                   	nop
  22:	90                   	nop
  23:	90                   	nop
  24:	90                   	nop
  25:	90                   	nop
  26:	90                   	nop
  27:	0f 01 cb             	stac
* 2a:	89 01                	mov    %eax,(%rcx) <-- trapping instruction
  2c:	31 c9                	xor    %ecx,%ecx
  2e:	0f 01 ca             	clac
  31:	e9 c1 75 03 00       	jmp    0x375f7
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

