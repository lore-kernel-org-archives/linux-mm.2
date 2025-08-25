Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3D96CA0EED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 03:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AA46B0008; Sun, 24 Aug 2025 23:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2725D6B008C; Sun, 24 Aug 2025 23:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF496B0095; Sun, 24 Aug 2025 23:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 054106B0008
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 23:00:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F5B8138AD5
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:00:27 +0000 (UTC)
X-FDA: 83813776494.24.D8C3FE7
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	by imf27.hostedemail.com (Postfix) with ESMTP id A98364000E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:00:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3yNGraAkbAGcXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3yNGraAkbAGcXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756090825; a=rsa-sha256;
	cv=none;
	b=QrXTey8mi6MkN0f1jLXY/uB5QEP6ZAXXPPf7gTnApax/+St1X7W/9GNYHv/FbemYn09YE0
	PpJ+ZHayETOXAvZuy2yn45Tdr2UjyGc5XENG5coXV7RYJQOdfgHemi74IoBN5LO8A8XDXb
	a89fRjRfxFLMjzO2/tlt1UXc3jWs890=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3yNGraAkbAGcXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3yNGraAkbAGcXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756090825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=tmrcDEBilQc0uWyoBAIxRFxht9mBBW+yjQf1/xXJYDU=;
	b=MnDc8Fp0qloOnlsUpRHXExREqomem9Ossq0aIXz/H8muw3brZsi6lotAPPccqtgSuO1uhL
	idNyVrJ1vHcND+/MP/HiBGVnPfGh2L/zztFgUODAMBqlF5NjwEAQcvn2KgVmaUYfkoleaE
	H2RTPHOU7gA6mnZ7+Dz38FI42Cs1laQ=
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-886e2e808d0so10502739f.3
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 20:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756090825; x=1756695625;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmrcDEBilQc0uWyoBAIxRFxht9mBBW+yjQf1/xXJYDU=;
        b=FvIc9XmXxgfKgqBokGFCe8KWeOZqyicLxPchYmUNh0EMJ0WCdCxYFJhll6FdC+MbXz
         c7tD9sWIf8kXAQza7jtb0FX0hq/ftg8xiPJSJTe+y3tNPUsFu67VVOIYKK5NcHLKgwQN
         tjyUp1XSIv24F+vjJSMbMslzj+Hgmyee/7e9l35WLzXso4QvXLhiPqa4Ox0lu//77bCD
         2wZLn64bwPEXSQO7fsN8doleT1NxisgqMZdQWlSuQyMAU4fwiLXMdpDCl73QE/77uejA
         nQItFbAkLUkn2/Uug5fPWpqvL9KstFPhiWbb2ksvV9G2PIC6KmpWq0SkeVxmC2ucWFeP
         DxIg==
X-Forwarded-Encrypted: i=1; AJvYcCX/MCCy9ECX9QJwkKcszN5uhowBlcgZB8ERKUMHvgIvJiSPpFSTBCja+w8Yu81WvPKSZtkQrEgyOA==@kvack.org
X-Gm-Message-State: AOJu0YxDA5OcFIQxAH8UkB4FOUZjMJVHDDfbcdPkyMzHco52eT8V/Wv/
	qlsNmmoNW6dn4oZsFVoZq1T3qx+I8IWKfFsjactuysJxTF/chPfi9RBg7qQ4jltQeAnyHGrItNp
	HLwhOYeEmSrm43gY3BaGptCJXiu1QW+xkwiYGkvv5kX+OyiuWY6lN2GMmLnw=
X-Google-Smtp-Source: AGHT+IGbyIv5d3/3s3gokcpaIbNdipPWCOYcMgcaz6q5tQHLSuKntrkGcUJM1rnLVeKtP9yYYFE5fw+4uQjgep4npvZZqhoDv0kX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a43:b0:3e9:e4ca:4aa8 with SMTP id
 e9e14a558f8ab-3e9e4ca4fe2mr125602185ab.25.1756090824779; Sun, 24 Aug 2025
 20:00:24 -0700 (PDT)
Date: Sun, 24 Aug 2025 20:00:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68abd1c8.050a0220.37038e.0083.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in copy_process
From: syzbot <syzbot+69c74d38464686431506@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com, 
	david@redhat.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com, 
	kees@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A98364000E
X-Stat-Signature: m13q49dp89gphmszf7h3488qn9hff3ct
X-Rspam-User: 
X-HE-Tag: 1756090825-902329
X-HE-Meta: U2FsdGVkX18vtQfCUJLqI0d+8gCmSn/lky0K4fBavXyJ4zHSlMS2nfetd7dT+2GgbaHyROohZWseiVaSll3tWhKAGMa/6V4Cdc36QMrqAfRpRibTKSYEJJiFMb5zPxXYuobDjvIlSPL0FmWhc6ISZpGT4zFwkPpxXRdBESJpky9+8zT4J2mfRgDkp/UXnrzKLyh+jFyJc7DLynlNyQErWOUApJ80tHxC/2Y6aHrolsTksWM3JqjxwMiXSOJaSWF6J2gOrZ0KBrjoC4kXKFlWqxkYlwkMgLiWOvSO8tXBRWAFBybVJSZ1otPlU0iB8862f/Cc1vn+qZTf6FEX+uMEh9uI7fOImwoFIbWYQSBjGqDozzwx7TmkJ4vpYOnNA1SYGzHOyDpUiWDe0PIww+xIN9/aBigZeR3DVmpNZDta5D6d3C7cfoFK2JHxj4dZTbe+WLgL0i7M5eJURtJKuDKWkGZ42uFwVh60gxTsDoDuybcq8bDHn2EK8XcruxbAkfLJQ0eHGt6VIST9/s2AUOKZfCVKl8cZXk4w15MOo00J3+5Ql6GxapcQYEhJTUZOaSiKz9Hl1u40mXI3DeoWNjMiVYXBlrJ+d5sEbf0EY/89JK9alU3ZLWMh6ciBh4y70ZW0lA+8rI+C/aEpzd2ohWpBJNzT5qSAQWagbgEqWzXp8AD2Y9UJITrNLtvunlXTbb8IiB+WVKRs//SZOQUivZ0nOtqqNxNBXbHa71qYKTfqndmU6CwwhkSG+HKOyj3FcrOhUQyARuJ4avy2y+HFseJxkNiT/9tlD9Uitgl+0GwxdFghn1YiTxlPMjG22Qh0JHSpoJUU51UsHADbPuFi8f+IYB7hv73JhaqzM8LV2DyxnWLiBDr/3lhAD/MkvAscc44Yvbwkvrr3XsyIAn3dP+B84mo3gdUADX65yOPggv/lo9jXB59nk+5SUsjPHr89l738K5qOqRxPjviz84Seh06
 FPyeL2Cy
 EnFiK/+SjOYEwuhnpcYiukHzhx5hoWQHb1gQ4TC46wr+gfskNjVLAWivyZrCGSBS65A9z5ruXUDVm29zjLe5RVbPd/pZaQTwD/5T06fR5XiXd9gre1VEYz5+KXGbdjmQG79xPJL8EP5a75fR9V0zZRLhKk68HIkfCxh0HyKB8h8VctyrykTNGx15QWS/sKsvOh2CcEZXM1s7zBPWsJ/Din3e096aZpv68y6k68/FTTMj0OunWL05vfZypNHJJKaw7fhy7S9guPgnLAmzqi4e3y4WxH9Ry2FwmksmsDZbL7YfSf7kCgjevormwnspfiiLyD7WvGCNmkrO2s733VvZxSj9C9kQUVZemimuGWZbHt+Lb5+TmX96ZynfaDxoSfGUTt/go20wCbzObyeSuLv9hHSr9IpmSRKIo/4VjW8IiXm4Zhg4h4O2YmQr+ywMzQk4exP+q5FzZpSzQl1DteWKpDMcN52Q2jT+bDFfF7f3iqwyUS/SRj8lHGgILWL+8WRJU+aWvlvAQXnZQ2rbrTv98f7hgt1me+63WCFD3UsvSPpwXIHLoHfE1RS6E85jEWT6EqdTvpXT6lHgbHEbXpOfNrYUZzUYBE43JOc8QeCHHfYdBm2a1qmL32gVo/1renKuhkFyvFblzwosLFNQB8rUWo/xeKb6dXXDdNIYytHOHos/ACp50mwA8myCkPSRfT5RRuQv49twpBTMWirL6dx5TfjybnmuiIu5RYAwsgqrKz1c7vDlFIV4h3hxLt6IQ4EQdJpfcOPJq0QYwiP18VDrRXWQQsXEpH3o9zUYhnEXCZpKWGjzXiL0ClLr1CTKwQsQ+aQst4Ig9ikpjlzOSbqTunvqYVWT3vEwjprVkc8ZWh9jO0RNY/xk3yI4Z2pExnd+CsKKjB5CmMBb5ASNPTG07n57XWjwik4B2LfinXfamwISJRXySJD3KMHfAJhPP246nuJjoFzcZKkFwb3nfzxPwaNtmuvIb
 P+4pKDOv
 w/PU7Ktnic1XRh9PBWcYBOb5RtX0NXduOhu7oFAWpRxW9W5Lau6N3nqQJPo+XHK4rej1Z3S3NADSM/QJRwx+4Cbke929BzL2chYVTXQ1E00lgSljL7lWmj4S4ZfgtULyLBe38ymTbji5VroaXj/9DYDsF2j+OlGFsb1/4Hnh08aZv+gzVq2Xqt420DVAUZMAHFoCesSU4TUY8X9jmtQ0obY2rKSVjXJPvSu3VCP8Q8vQC4JgzFhY6/qltNqMvQb/jmKrN7MK3+9m4GswJeTMM6tvttNPz/UJcHQd5h44QGpU/gLS0wLDA+ka3sbcVe+Vx2Fu9RZiz+aZIORhrdyMw4m6/XSzwOuLZ/FhfYG3VKuOnlfFA/9pHD6AG90hf2MoMTkB2HGXdINOfktdQKdziFRlb/P+l20Gzn+Ron6qEtA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    41cd3fd15263 Merge tag 'pci-v6.17-fixes-2' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d8b3bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fecbb496f75d3d61
dashboard link: https://syzkaller.appspot.com/bug?extid=69c74d38464686431506
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea83f558e101/disk-41cd3fd1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a35b75cdd97b/vmlinux-41cd3fd1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/37d76e9636c2/bzImage-41cd3fd1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+69c74d38464686431506@syzkaller.appspotmail.com

oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0-1,oom_memcg=/syz1,task_memcg=/syz1,task=syz.1.3237,pid=23388,uid=0
Memory cgroup out of memory: Killed process 23388 (syz.1.3237) total-vm:101828kB, anon-rss:940kB, file-rss:21532kB, shmem-rss:0kB, UID:0 pgtables:116kB oom_score_adj:1000
------------[ cut here ]------------
pvqspinlock: lock 0xffff88803512c0c0 has corrupted value 0x0!
WARNING: CPU: 0 PID: 23388 at kernel/locking/qspinlock_paravirt.h:504 __pv_queued_spin_unlock_slowpath+0x237/0x330 kernel/locking/qspinlock_paravirt.h:504
Modules linked in:
CPU: 0 UID: 0 PID: 23388 Comm: syz.1.3237 Tainted: G     U              syzkaller #0 PREEMPT(full) 
Tainted: [U]=USER
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:__pv_queued_spin_unlock_slowpath+0x237/0x330 kernel/locking/qspinlock_paravirt.h:504
Code: 03 0f b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 67 41 8b 55 00 4c 89 ee 48 c7 c7 00 81 ad 8b e8 fa aa e6 f5 90 <0f> 0b 90 90 e9 64 ff ff ff 90 0f 0b 48 89 df 4c 89 04 24 e8 71 15
RSP: 0018:ffffc9000e9c79c8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88803512c0c0 RCX: ffffffff817a02c8
RDX: ffff88802fa9bc00 RSI: ffffffff817a02d5 RDI: 0000000000000001
RBP: ffff88803512c0c8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000000d4550 R12: ffff88803512c0d0
R13: ffff88803512c0c0 R14: 00000000003d0f00 R15: ffff88802ab43c00
FS:  0000555568154500(0000) GS:ffff8881246c4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f86cc8e86ec CR3: 0000000060c0e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __raw_callee_save___pv_queued_spin_unlock_slowpath+0x15/0x30
 .slowpath+0x9/0x18
 pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:562 [inline]
 queued_spin_unlock arch/x86/include/asm/qspinlock.h:57 [inline]
 do_raw_spin_unlock+0x172/0x230 kernel/locking/spinlock_debug.c:142
 __raw_spin_unlock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_unlock+0x1e/0x50 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:391 [inline]
 copy_process+0x6b72/0x7690 kernel/fork.c:2432
 kernel_clone+0xfc/0x930 kernel/fork.c:2605
 __do_sys_clone3+0x212/0x290 kernel/fork.c:2909
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x490 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f86cbbc3449
Code: d7 08 00 48 8d 3d fc d7 08 00 e8 02 29 f6 ff 66 90 b8 ea ff ff ff 48 85 ff 74 2c 48 85 d2 74 27 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 18 74 01 c3 31 ed 48 83 e4 f0 4c 89 c7 ff d2 48 89 c7
RSP: 002b:00007ffe52a9ff08 EFLAGS: 00000206 ORIG_RAX: 00000000000001b3
RAX: ffffffffffffffda RBX: 00007f86cbb45850 RCX: 00007f86cbbc3449
RDX: 00007f86cbb45850 RSI: 0000000000000058 RDI: 00007ffe52a9ff50
RBP: 00007f86c9dee6c0 R08: 00007f86c9dee6c0 R09: 00007ffe52aa0037
R10: 0000000000000008 R11: 0000000000000206 R12: ffffffffffffffa8
R13: 000000000000000b R14: 00007ffe52a9ff50 R15: 00007ffe52aa0038
 </TASK>


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

