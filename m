Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 481F7CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 20:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4588E0005; Tue, 30 Sep 2025 16:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A99F8E0002; Tue, 30 Sep 2025 16:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFE68E0005; Tue, 30 Sep 2025 16:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6413C8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:17:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 024585B893
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:17:36 +0000 (UTC)
X-FDA: 83947026954.26.F47313D
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5033A40009
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:17:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 33jrcaAkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=33jrcaAkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759263455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=imYVyFLoW8Lx5IenAuDtwzh/rTjhBRKJiMfcM+p+yW8=;
	b=41I3vuUeM3xa+rMlCSuE84wvll+04hiS5uOL+9cmwv8iIXD++KIIEmNfl5GunMU7uzeXtU
	T5kllWJRhIkZIrwSUkAjHgst5gGxstp6YhtkA/Li2kq0PV+g+FUEy6XIU2ltW6anCod3QT
	h/ci5+5e3kH3E8AS2iA4B7DV2uGa+54=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 33jrcaAkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=33jrcaAkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759263455; a=rsa-sha256;
	cv=none;
	b=eMsnqAsxWxdLNsSWJQ1TYf75fUYePguZ5L4OnoCPCJH9I4s3iEBOj6lnzjIm+3fVdDVzh9
	eR99bYg9byZe/lhRdzuY8EzdYLw/0e929/wNZtdzy3V5t6U3Kgl9g16VftVyxwX4AJaG38
	NuPh41qbvkT7Vfk9LEq5KVeGeDk0tz0=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-4278a8ecfa0so143789405ab.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 13:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759263454; x=1759868254;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=imYVyFLoW8Lx5IenAuDtwzh/rTjhBRKJiMfcM+p+yW8=;
        b=GoqG1pLCPvQd2CH7iAd5Buu2jjW9BIc7EcFgJcU72EobNwsicSGawXGIKwHrWt+xYX
         Z0Jye8ttdjNjfglq9vX034SgeNIRRPzahWoWYM55EPnTozdWOusW/+GMSIEatg5sEdmC
         UUNrpZpHWQuhdrBqdkStUAkAEXLvDcwYqRQ17GvXAlAMt7WA3+mthkv7rBJxlMZLD5Q9
         v9WVez2UWQ/JL1/mH1FHWMlgpWW+XUvu3mboysagHlFUKVnasE+9lkHO935DniDgvppx
         eGFoEyUbGhkgaGTC3MX0i76nkteoL6Xtd4Ogcz6//20C309/DDIOtyrZr+bmzBTxj4xK
         64RA==
X-Forwarded-Encrypted: i=1; AJvYcCW4XJSJ5lEhekekoB5/1EOMKVG3faQZTp3K8nCoazIgGeShK8zifOYX6WRKAGOsBEVMYel71aIkMQ==@kvack.org
X-Gm-Message-State: AOJu0Yx72lBvBXk1Gb9AZXMJwmPvgLllpITSZjcUYpfbFftnE4Og3bLK
	yV7i6/dEsvs76JdY0JoQ89ZGefJNq6t7RqVzDpMDZlyNGZ/gn3rBdXa1Ky3BfLp0Ed29QLaIcy0
	UuBNpqMDWR0LFCjmx59lYPXrM8vGlwl9fYZ+VicZ7DiqdQPA5Qs+RGlfyixc=
X-Google-Smtp-Source: AGHT+IEvi3ZUUdgyMCecZ94IYWbSb9OgCzFJ4lzc7VTcsbHz93zWE4mlXeuyyGAd5BE10k9YRhgghfauZkiLPJjoX5Zi+AgOjOcb
MIME-Version: 1.0
X-Received: by 2002:a92:cda7:0:b0:427:6510:650b with SMTP id
 e9e14a558f8ab-42d8161957amr17936155ab.22.1759263454279; Tue, 30 Sep 2025
 13:17:34 -0700 (PDT)
Date: Tue, 30 Sep 2025 13:17:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dc3ade.a70a0220.10c4b.015b.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] WARNING in path_noexec (2)
From: syzbot <syzbot+a9391462075ffb9f77c6@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, kees@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5033A40009
X-Stat-Signature: y5k7jxibnjmiuqaes3bmtfoj84bc43d4
X-HE-Tag: 1759263455-32208
X-HE-Meta: U2FsdGVkX1+rS/q3ny+aXJVWUyr9/MfgbQWQ1MPrTpxgAdml4LHxNgdI7tEM9fa11wDMgwkzXpqJiw6MO+4dOqZziLjh4dOCIi8keHMnOA4rta9Vhbjo8egl8tyc0GF00tgpDXbk6DkaNIv5Ufl9QVG9hADsFvi8I+0GW4vgs+A7TJ8hwYjuw4KcfHtfCZFV64v4mSSSGmDczDlPsROv9yz3BjZlMw9xqzuYOHXR+0qB0JZyVFkb1AChU5TcLJuCVMJ8WGalGD2ydlEcNIonS1Wc90zWg7HqzB3U8IzlR90/eaRV3Acnzsge2Czc6AoytdQPP1vePzWLKYrV60lXJpH+vpCIxcWG+w6FJjoRutZM2+KEAhGd60U73jwLz+Na+EFZeFJD1U7MwFMR+ybhJ4Rhil9oz+Cz6jj6KkVvx9GosxkqK9QDP+aM6gguZAaK6/cp8XqVToOJezXFkIL+O29wPewcyAQyZf67lYqfa2V74Y8Jvv4Gug/3n1U4vEvtRTkTJnGHLBzkv0ieXFV6kkFY3yb/JisyTEp+mNduzge8FGMRxbIPGuhNoEYzl+6m32956ItDjhBXcwhwotRCrSNW0DzvxJQsLmhqhS+K02ih93Q+E5mu+TFPQV/xDdYn2vbBv8CfbJYci+rB7cxipWpeWdsC/fvY3K4ctDgi8gbMtZX1hrFcGsbMaYIEG0S81NsgF4foYhi0vXgdPMpLaT++YsCQTNGUEvNDBJbZb0TDKO+cNQ6/bbdgeILXxYiakLsnVXA6qMvGh/XOQKrT5bhvthutLrMEU/7Su/uYNOH11Rj8VXq2PdXXzYeqGlm4TVZaZgkr0sMGzaV78pV1JxJhNNNxXaqW05EDuTimJsro8nqrkgH6xmH2n9CO7y5IN8DjVNdP6G2kuT/9gEA7u0gTFWp3hyyhQCU74r7NDUwWD3PpSbYk1nL9CJpWPkaLTnLheNdyi+JKxZJxzP6
 JdyL3fhr
 lAZE93A/uDIqZlzgjYUCCKbV0EgyByZj5l6OQa6xl5X911xYVKkVSSP3pJ58/iXFPkSQIc7MkIZrb+nOydNFejKhHEt9Bdj+UEu/+nRbpqzclQSomUWIswRXaaKC6ASRZw2D6YJ8stupBocbrXwztB2hUZWLjAOc5G4tEAXgZApcD9yDIJBcWs8jpV9Q1NtE2SbRfqnFqvzSppvgRkGtEtCJ4FQr7IJbX/CNknPN8RBfFrrjVIEcvzyGyb7JofMZ8qGZ5Bc94a4ziJBIcm3rFm58CiuHhWxrx/K2qBnNSDoxa6VWYrRCWMee7ExNkHmg1jD4xuqUczWFY8n3kewuxqXAU7nVZgB82Z05GGIw/9qdhJRKMekbVcjnPuSkpibUMNV0RweQB5KtN+HxEoVzW80LgibDVjK6X37fOPu89xBnZCBDN+CD1sESDJSYuhqpkc6fV3TO2LYiEU46YBcmP9J4CmRJB+3QPMQ3LJTEqPMpU+jEc4O0/gSrfRdFID8jN96BH6cWnwMpaR2nIa3IqGOQo5HlyxPg2PmWSH+sCS6xPZjX5AyLJ6OEUWZKCJoUg5R8e54bWGhdXKa+1EPlC5lywBypVWJ6ufsm6Zrp/bYHrWyiaYHYKCoeOLiBm4AeS8NkOL6joTO2y7aCp57xhYg1U13RKJ3REsnlkjN9PlWRqkSF19YX/nEZktkVluxSq6YXMue8u9l1b3PoHTPvF1XiGYV0ivcZnbtnSyKo5PRZMlHi5GoROwJBLzSkIzztxKN//Y9QylgeRWENGaIE6Oox8d2zs0z8c+DxPjg3Mm2s1Y6mqDJdvRuhG02kaiq3xri4Pg7Je4WAIWwYNL+2s4JX/xGJH2MszrlpKI82WFNyKJdN3+DHeRmuEJhYgyWbl6ue43wSveuVBt4cv6Uq7ce7xI/Si7S24rtmkGVlA0V4yhhm7kU08RfJYjMLZLZ8ABOiT8pbXPzZx3g2Fni9PZh93yMpV
 ueQA6EFJ
 54GWQGjqJTnsfySa0RNh00ippwJAyfVHIdCVm/gkY5ONfMNN6nooCrwCqwGRWnryFrLPdepISsNib7eOESu04cGMMVM5vwRGn7qtOcvPbJ6eDyZNv0RlXK4XP3YA5uaigWdbSAVTCImjWg0h892z/HPtNoM1Q+nBYXbt9HbQJgpZh+WwRW2rX2+nCZRZPNWUjZWHdDseRvPRR7Iv0YDSR2sZ8NBjwZE8weKN7eaV6cm3q4suW1mDE2uuqJ9RxegwW2Q+VHFJ5mDCa6+DYuS8NoF3T73SpSXv1WnOD90wO1bMiId7mrpq8XT3FLK/nFZotDJsFacPb5+Np6oDlMvvPXV4Kjnhp1h0bpc5CP3kPC8WqjO/3xZQ0HRvHwbdW96xhypzuJZbXFScpsnleMLLBnatSwAfBwCc5ZeQsWJ0fqkNPo1KV8cgI2NesUKua2QLiQOKYiMk+0H+emN4Zk/Ai4YPxQkjgSfKe8TH63ElnMvLDnQEhbqTmuFZZ8Akwr/Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    30d4efb2f5a5 Merge tag 'for-linus-6.18-rc1-tag' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f085cd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f17deb9fdc33e902
dashboard link: https://syzkaller.appspot.com/bug?extid=a9391462075ffb9f77c6
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175496e2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e5fd6f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d3e36b0a1279/disk-30d4efb2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c964999afe48/vmlinux-30d4efb2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b49e62d3fb02/bzImage-30d4efb2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a9391462075ffb9f77c6@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6000 at fs/exec.c:119 path_noexec+0x1af/0x200 fs/exec.c:118
Modules linked in:
CPU: 1 UID: 0 PID: 6000 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:path_noexec+0x1af/0x200 fs/exec.c:118
Code: 02 31 ff 48 89 de e8 c0 e2 89 ff d1 eb eb 07 e8 d7 dd 89 ff b3 01 89 d8 5b 41 5e 41 5f 5d e9 98 51 04 09 cc e8 c2 dd 89 ff 90 <0f> 0b 90 e9 48 ff ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c a6
RSP: 0018:ffffc9000384fbd8 EFLAGS: 00010293
RAX: ffffffff823437ce RBX: ffff888077b40780 RCX: ffff88802eebbc00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000080000 R08: ffff88802eebbc00 R09: 0000000000000003
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000011
R13: 1ffff92000709f90 R14: 0000000000000000 R15: dffffc0000000000
FS:  000055558a5c5500(0000) GS:ffff88812647e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30b63fff CR3: 00000000213d4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 do_mmap+0xa43/0x10d0 mm/mmap.c:469
 vm_mmap_pgoff+0x2a6/0x4d0 mm/util.c:580
 ksys_mmap_pgoff+0x51f/0x760 mm/mmap.c:604
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fea4258eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc0d346898 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007fea427e5fa0 RCX: 00007fea4258eec9
RDX: 0000000003000007 RSI: 0000000000003000 RDI: 0000200000000000
RBP: 00007fea42611f91 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fea427e5fa0 R14: 00007fea427e5fa0 R15: 0000000000000006
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

