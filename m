Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFD5CA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 21:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6736900025; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16A38E0151; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C89900025; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8678E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:56:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E9DEC01E2
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:56:38 +0000 (UTC)
X-FDA: 83769465276.09.0731C76
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5F9D91C0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:56:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755035796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ZQmTebluP9FJNCSa1bCTc8yuvAKN2vsJUbc85QAend4=;
	b=Wr5FslJoKmcxBeKrilDzvNDiNoYpjK2+lkxnPOp9pGTb+fvohUtW/NcoWEPsM09v1Acnzg
	/N1bS6c2TK1CPAztDzjDCWzlw1NVq+6zZoEurrXjUZNOOte930AvzI8QO5kmOjINJ515Me
	lYf0TZbtK5XHXbkD6d3xWKWtfOVgu6I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3k7ibaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755035796; a=rsa-sha256;
	cv=none;
	b=7iUkcwjTRibD4tIDrx0HZC3T14UZMcQymWW4emswoc+PCwADX0A5rrXV9d7s/H1HkUiQts
	brpnxAXl4lBotmp7MXGZdC3I4N0oSIwU4xr8zHV2zW+EpPyTGCUj8uRGfpcxaAEsnZrr3M
	+0fN3sq7MIM/5rtYTUeJq42bTjuEVi8=
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-884030b4235so634425339f.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755035795; x=1755640595;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZQmTebluP9FJNCSa1bCTc8yuvAKN2vsJUbc85QAend4=;
        b=FU1H5U147nSZ7x5EpPnQyf8jNf8BW0ILmsUnLo0CTqwjsAtLazGMYcaJ0bsFoDYZ2s
         GHU1cIgew9hCWjZbXnMOJL+IcgdM0BbcLNoQHeHfwa828dxK0fOW9KWmYEDV8U2FxoAz
         HDXnb813UOa0BcRhq3cQ7L1EJiP5ovFUfXAsmRItOMq0yw3HW+FQ7EFHpivsdSwiLOHX
         C+p99YmpIisEPuVnkdJqQRnoBv3pjPP/mhT/6W1g7lQ38p27x/WHBvdDVILZjx61LQxM
         G36Gh3qDXfz50vgo5ZBtaXMUGFzorbvF0JJBc7UGGm5Nz18SnaEj/3Z0k0b5PksFpRcH
         S17g==
X-Forwarded-Encrypted: i=1; AJvYcCWSyCwubDrWirwr34FsSIhIo5L937ACyfU3wYX0QxLl6WmFVYMq46IBrd205JbvDht3HsGY5xohxQ==@kvack.org
X-Gm-Message-State: AOJu0Yzm7k+wrg9FCfrpTyKkqhIq3zlmk69kTjYXQrhuq2BELMqLECd3
	juNeWr6BkUQ/qFxLr6Lpxo2KKTN5Bk4nk5Fef/p48Vkl30xtz3miLcFWVc22VuriPqy701v1s57
	726479lkJuekTtuQOBaQKtT9DrUvK4NTTwKP/0BRF2/IylmQqw8fTmND5Uhc=
X-Google-Smtp-Source: AGHT+IFg8CeUDC9PGszt9X5eS6h5GIdvQkUvv8UskUP0E5fnXopNHUdPrXkMJqqRTKDsuI88w1w7/P1d2EEIMjlf+jrNqC2x0ohk
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6417:b0:876:7555:9cb4 with SMTP id
 ca18e2360f4ac-8842960ffdemr136283639f.1.1755035795424; Tue, 12 Aug 2025
 14:56:35 -0700 (PDT)
Date: Tue, 12 Aug 2025 14:56:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689bb893.050a0220.7f033.013a.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in move_page_tables
From: syzbot <syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5F9D91C0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: nkj3tymieb7waepsdgrcdmk4peabarhj
X-HE-Tag: 1755035796-453415
X-HE-Meta: U2FsdGVkX1/uT+a0LsblGdI2jmPxMaDmu8vUrgr3Obh022y1UFHZ7AjEWCuLHE79/KjE2tlaEk/tWUnBEbbW5lTpaDSdxlg3AAkOtA9Ksiyh8qRPX+Ml44RjPGRl9oU/FY+eMfl/AM+Y3jfXiIs88zpOnngChV1J6Hcuq4dzntt4tKI/DxOo6y48nLjaichrvvsD9vJzf9IDP8Vb6rQ3bbqPmU20+fIpLmJyO8XPzrRz6zgqU6v9q0X1Yvp4e3Ha8mLnaEbc7Wo0VL6oOAjaz0JLv/Tk+Nxc8Fg2x50D7rNKD1wL+2Re2Y39amEpzncyN2WlozPpaNgtinD91BILmTHZ7NPrKjnLw6oBBRjqC+aL55bCWrc6GrkYb2WCzyd1r+IwRjHXkomyV0Hk+M9SDarO0sNFTYb8yDLIbxY/TtfsoLc2S7a2aRS3fyB/9rSgamtP2pAfbV7YRd3ytBEsfm3cjZYNJ7x8IwrmkH8N5UDl0JRktq2mOiYu96GF6S+GDgdhZcMqwC6eleIt/odrxng3BGrnupoQDtzTyVDHx21On6n7QggdPV7JrBTHncfX3r4C9vG/tQ0qvtTCzW/WtQy570+gZyi/5bJjD9CGQggkYlHhEU8FenMV+q6sFpCC6zUfl5KnMEL3UDjWGh7lSQ2bdsScAsADMM7V3Rday50HPycKzUVpoMGM8N/Qip571xsE4ZwWmdGYbZkUopqOZkY1sf6yZacHw/geznMYmp0Y0SbcTGikMlYUATTLCE+/xe2CCDpgK4TnMlLWggCBpZYcV8CkLS9gKwo9yoZkV2ARoeYmVYIc+M897MiyTKVZKdVS73Kys6+luMViDQb7SWXPqOi+cuex0wQXJ31aALTXHuiJ5AK3BL2mLsypfT4RPuYCejkpFcnW27+eOE9+CSljkF15vfCd1ANlNs5SP4FNx8orGmTnE0iEuGMjB3XZCLpJJ4h3JBbxRaQIQyI
 IDu6eQQ4
 9pieRQuTBxP5dGK6kVbvuW1Wdt9uXaLfkYMpqUNm5tgQNdUYJ+szehZNVnNi9HIL/Z91nKgbhrJ2GrHWMVhni9WfPFmXmjB+vaO7s27GimUHJZR6nNPuEUJuv31R9sd47TuOZW60D7I/wzyDhYMI/jTIS25sl5KCYD+a7hD5bkBOeQ45SUQHcFh4x3XigQTR5HuEZzntjPVd6HLdCR8ma5VPtwpXJxmmEPuazJSi25wWCRlxhajcxgBq1CxsqRpxhHHLLKLGumyrLtOqYl2LY5rairmjgzLswD1AY6084lPEoCGEevPMLMgK5rc+SnFODmePQ6bqQ82azpAy1tzVoDqjGR2s4AIXZnnsurHad4fQHqeWfUS6Dc9mvBOeQO9w8QEwaIwfPjZRIy6xqKfIZaXFzntRc9AWnTNPp9SBVpihIWTcs8ll8J5oO65ZNz0gdXi2dvhkdv14kZI09O873V9NNEZJWoXrQtxFK4RKGCK/R2req0Z9a6C6bBfzpRb8UVyu4iYwwmx0z3bt2EtSuSxkfME5l53NTNo24/O+apZnBFjOhZRDCblFYrfNHQSvgd0xXszuEE1jCqlTu8U22TrAdPR/Zml59oUYB5wPraRMumkE6FwV7/rK5Mu9l9DE37EGFE46xBi8RZLwy3JZzHZAod6YeqmeyS/MuT+cOoRRRXCo675kUVR4JY60n5mB7RGx6xikrhq8wnfKzFwHmCk4dVNIAukfudeWRB5Pn4W5OaPH2Ljtku8ySWYNr83iYao6eyR9x/8U3DklrvJIIOWir1djzECX52BXmRz61mwfZBgg13ep3+zZuk/F2Lm5r0SJEMm5XvruQPVtLMDPzS5hPnQB8ruk0Jq8sJdkpJWSJY1IspB3M4ADBvsTBb3KiejLkGt7TXZo28mo6ivRnZUb0dMgfAAdngGVoCirjUBtTwMr/AD3R117PeL9wX4RblG+28MNCg0/WTk9z3saBErbYdzef
 fjDxUx9I
 Zz19TLgSQDEiVw1vlCRv7HNAXOUHsak8CBJBRDqJiSlgdWcWsOfEOpqOcRL7f9hPKe50dQivMEWnP2V426wv0Ze3oIj06y1eTVuVMIjtByVj/NLkLmbyudbhvskxD6b+LKrxZYbbO9/VF+7hgldcfrEGT9rcmUEbOX7T5r0uZAvjlAa205HsNbADh4/ZMt8tevAN2Stq/QHohXuD3T1U3hLAAO024coujfniR264h2u8wIZEmFLbEGQRtXZUpovh9rNItzYfTlfIYHtRBTGQujova0HzAce4++8LU4zUMckvSP5hjCav32sNxj2qcql+9oU8HgIrIc0xntgYwoknAK/Jw6cUPur5ZGo5mOP0g3YcsLhkcGoxsjNlGdagRlUwBDkGGaQZW4AR1b3GFnMQsGcNs8LR/PVDXZdum8xbou4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    53e760d89498 Merge tag 'nfsd-6.17-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165fe9a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9319a42cfb3bf57
dashboard link: https://syzkaller.appspot.com/bug?extid=4d9a13f0797c46a29e42
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14172842580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b04c34580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-53e760d8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/584b4139c7e3/vmlinux-53e760d8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4d2474607300/bzImage-53e760d8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com

R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Modules linked in:
CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Code: 02 00 0f 85 b6 03 00 00 48 8b 2b 4c 89 f6 48 89 ef e8 e2 1b af ff 49 39 ee 0f 82 d5 cb ff ff e9 0c cc ff ff e8 1f 21 af ff 90 <0f> 0b 90 48 8b 44 24 40 48 8d 78 40 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
 move_vma+0x548/0x1780 mm/mremap.c:1282
 mremap_to+0x1b7/0x450 mm/mremap.c:1406
 do_mremap+0xfad/0x1f80 mm/mremap.c:1921
 __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f00d0b8ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
 </TASK>


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

