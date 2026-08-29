Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B237C61DDE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 23:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14396B0088; Sat, 29 Aug 2026 19:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC59E6B008A; Sat, 29 Aug 2026 19:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3C86B008C; Sat, 29 Aug 2026 19:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 966426B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:03:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00154A01E5
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:03:50 +0000 (UTC)
X-FDA: 85155836262.30.058239D
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf24.hostedemail.com (Postfix) with ESMTP id C286C18000D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:03:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsBeDeEV;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788044629;
	b=ekV+7NWTP4GGXHPUgW67xK7Pz5XEw6s9zEw9ES2TclfLo7ON0yi+HISILtvGba3zlyHtDy
	CY41c2jm7CRv94MQoNNQs9qf75/M6hCNI+LFmeUk6pjSqHYuLw0/jlUeyCY5akkchH6bS8
	sRBlppJ3n7B1lIQJfDmXHZEOnqjw9Gc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsBeDeEV;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788044629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hR8htcywNyl74z63Lt56eEssUV3TeqsOUV8g1z48E+Q=;
	b=EFaBXy5HTFy88G+HVlg71EmjZdxa3cA6s6Cnka7v2IOE9xqwufqC3mznx+v4ngN3MrmsC4
	QSVmimmpRujEeyboi/Su3eOwZcZOVpULXy3vKAZP+KtnBczImixNfoHwx8F4CUkmlvYn5O
	7xUwpGsaCwjbbekSD5XZwWKjnji8Nk4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AyOm2TXQF+vHB5DKi+6/N1l7J2DIrOuqazhRuRGLwOU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788044626; v=1; x=1788649426;
 b=AsBeDeEVlmfgc8WVLE2UdivMUpZxpzJAJCrfqqB6bY5Pqxou5DQdrDH6TJ5k4wn5OVRAiu6S
 Uk3lrWpOxhX+5yO8dgMNBFRzrkjBl8co8ry7j6E5NSSPGlkhMYX6yqEYLksV4HuUOPiQbp8WtXb
 Ap8dpSw9lU3s0zighs+qxYm4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aa1b5c9235c53fae;
	Sat, 29 Aug 2026 23:03:36 +0000
X-Mizu-Trace-ID: aa1b5c9235c53fae
X-Migadu-Flow: FLOW_OUT
Date: Sat, 29 Aug 2026 16:03:35 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
Message-ID: <apNjw0HRyr1Oj7q4@linux.dev>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
X-Rspam-User: 
X-Stat-Signature: eyrz8dftpudobh93d3qo9wyhij77cxnt
X-Rspamd-Queue-Id: C286C18000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1788044628-540192
X-HE-Meta: U2FsdGVkX1/gFgRqIsyJen44jEkFRYpJcpVRYk5rUBK7LEFRV4ABsfDMUQFXRwoSg2Sy7hAz3Gd3+YJ0VFkCGDB607sQ9NRdSGaCaaTVol+kjg6eerL9uN6dJMEJ70QanIEFcsLupG7/3ACoULXXN/O9Gnfe4iB7PJwzJAre4AllUezK9Oi6IcFMNaK68/I7iEsyAVMp8YHia+yx+KopNjovI5gqQBIOAVs+eNdOt3gqc+RWJ7CxD4KkWa4jgcATWeL22j4FF6LFiu1pWSOs40+/YPT4CSdIpaSb9MlnpgkV312lrr7qWH41K4GGAeU8YNZzpMuAP3xoaGwq0iULpzVlOmZOC2Jz5fC8umfolTQEiraaLlmi7ovGCe99yfz6lCiEIKrGELe25NjEPKgj+17abSiBcWL9KS6hVv1I/Qo2LlXCaaiFWef1ghMduw3v5YGKpn64TZKPEg0Zm0ZxJhvByhH9wXQHqCgrIeOpEgAHJaZa2+HuGzOwnoXnJc1MPc2AgPkafMi3kNd3QP/yJ4+xF7QDChnFCJglxY2pKH+o6ZF/p7orBn1v/598tC8S1FQdgdsaqj66kGgj72YSgFZpFYHpErZWYre6rZqxYqvR+3C4XTZNMoOilgI9m25/X8Ux1/v3oej+QIXgsJBXYhnrCmiRSPDmAt6qLp8sAB56sNY1XCDFmIpL7LpLh/3vbUvZ25T49hHiWgNEwWbRKHHfYCavgUTOHl6n5AJUpbjMwatDnEDz3D0vV2RkpDwFjzRr/9tKRtnT3QEo3DB4uNcmIy1C26QPRTfaAaIiR4PnlUjb0CCdtxE4qH7gkQTcrP/d9fkB9B5bp7COZS6fkx1RjFvlUtQtipdCF8C7hOaK/8BRPl++HHmm0QsHYxrQUKPKkvx5k2ZX/nvbeOTqSFJDCrfripIGwwghzVGJWgnzIWbj08wvEIdJ/mv+anyVc/eZpY9xUPcaqvQU0YY
 lnUHPTOZ
 6FiscXqjscuUTxCDDzavnXgh7VFcRdN+emlTVTbNKOElXrgGMeCttbZtf6PRepOvmKxOC4KDXLhxCx7qOIeLXmBAlgMeayrTrOXhP8RXMQQBmqyyjcm0G2lLwWxxEX2uU/scrX+VQAZDI5ghrlt1vlBewQZ6aBeeMRJa0cCw/1W+nIvF9qGNVEEJV23/QNYk2Mfpiw5r+JLOCRwnQUklRQo0Frr1QbBb054SO5KzWL4PhIje79cLfNAqVcxW9ErN0xddrbZ8kFoAz/P9JP20kgzHpy9sGpqwPLySdS/3JBVL0eFc2EvddY0p7dT/Kr18eRLdXt7Ewb+LqVZVDODFwqKo1L+cuU8EK/jlOlbFbrbifRQ1sSJrIBn5/C1qVj0LasLBf1nVgtiIJTZaJOI61eLc2ofxdVlbVAs/+2aSynZ3M44dj0lCQthvUxfncXeBMv3d8XVnURAk0lfsHiuPSxZt2lITOak+AIeSOQOp9g5yIW4lXpWqADgUgRuQevWuMXH0QYnikpdH/ctn0wj9+h/v3FoeON67A1tv3Nh3LBIjUMcsJ45CbDqbcf7y4BgIkWSyv/YP7ws/t4AKvyZUyvH5oHltVBzE0gh8fuiLuTa3GSiDPUNr6OtJNVOFxXTkRbr4n6acAphGCmHcC04lUgTPZnItLbJd0Oqmsw3yClMfruxbPzOh+s27SorLFiq+YveMQcHVzIKD7wUKMmKQ7mwV4ZSarDksJNZ815X1Hfu1haLv6XR1jns+2idB9NCglOGcCUxTuIkk6GQbivx0ICxx/RN/mn990sHSDdAq3uyq9owSaXRMtQbPm6/QaiZGioFKGcpBNVNpgoNnhxTbokV+V5DHa9iggKt3mriA2MnTGuS7b6cr7lMppZWgxHg31YtC0yicwqm73UsmdmZ8Qlj8p0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 10:52:26AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> console output: https://syzkaller.appspot.com/x/log.txt?x=10286d79580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
> dashboard link: https://syzkaller.appspot.com/bug?extid=cd2073ee6d958a8d0fcd
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cf7625580000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
> 
> smpboot: CPU 1 is now offline
> ------------[ cut here ]------------
> IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() == 0 && this_cpu_read(hardirqs_enabled))
> WARNING: mm/vmstat.c:361 at __mod_zone_page_state+0x96/0x190 mm/vmstat.c:361, CPU#2: syz-executor412/6040
> Modules linked in:
> CPU: 2 UID: 0 PID: 6040 Comm: syz-executor412 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:__mod_zone_page_state+0x96/0x190 mm/vmstat.c:361
> Code: d0 00 00 00 8b 05 3e 44 ea 0e 85 c0 74 1f 65 8b 05 87 e0 2e 12 65 0b 05 d0 99 2e 12 75 0f 65 8b 05 d3 db 2e 12 85 c0 74 04 90 <0f> 0b 90 48 c7 c7 c0 e7 ff 8b e8 3b b3 6d 09 65 48 0f be 5d 00 48
> RSP: 0018:ffffc9000627f8e0 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff2287150
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88807ffd79b8
> RBP: ffffffff9489f448 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffffffffff
> R13: 0000000000000008 R14: ffff88807ffd7940 R15: ffffffff9489f440
> FS:  00005555785ce400(0000) GS:ffff8880d5da2000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005608d531ffb8 CR3: 000000002cb7c000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  __zone_stat_mod_folio include/linux/vmstat.h:410 [inline]
>  __munlock_folio mm/mlock.c:144 [inline]
>  mlock_folio_batch+0xf97/0x36e0 mm/mlock.c:204
>  mlock_drain_remote+0xe5/0x140 mm/mlock.c:230

So, we are calling stat update functions which requires preemption disabled
(because they access per cpu data) an offlined CPU which is fine but we have
warning that preemption is not disabled.

Let see if syzbot comes up with a reproducer. We can just simply take the local
locks like neighboring functions or something else.

>  page_alloc_cpu_dead+0x16/0x130 mm/page_alloc.c:6468
>  cpuhp_invoke_callback+0x3b4/0x9a0 kernel/cpu.c:194
>  __cpuhp_invoke_callback_range+0x158/0x1d0 kernel/cpu.c:972
>  cpuhp_invoke_callback_range kernel/cpu.c:996 [inline]
>  cpuhp_down_callbacks kernel/cpu.c:1386 [inline]
>  _cpu_down+0x523/0x1020 kernel/cpu.c:1457
>  cpu_down_maps_locked kernel/cpu.c:1483 [inline]
>  cpu_down kernel/cpu.c:1491 [inline]
>  cpu_device_down+0x82/0xc0 kernel/cpu.c:1508
>  device_offline drivers/base/core.c:4283 [inline]
>  device_offline+0x2f4/0x400 drivers/base/core.c:4267
>  online_store+0xd1/0x180 drivers/base/core.c:2883
>  dev_attr_store+0x58/0x80 drivers/base/core.c:2509
>  sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
>  kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x6af/0x1050 fs/read_write.c:687
>  ksys_write+0x12a/0x250 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f90996d005e
> Code: 08 0f 85 f5 e2 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 90 41 57 41 56 4d 89 c6 41 55 4d 89 cd 41 54 55 53 48 83 ec 08
> RSP: 002b:00007ffd7eb94578 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00005555785ce400 RCX: 00007f90996d005e
> RDX: 0000000000000002 RSI: 00007f90997150ff RDI: 0000000000000003
> RBP: 00007f90997175e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9099717578
> R13: 00007f909971509a R14: 00007f90997150b9 R15: 0000000000000002
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

