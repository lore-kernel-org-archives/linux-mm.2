Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47D6CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 05:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50076B00A3; Sun, 23 Nov 2025 00:30:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27896B00AE; Sun, 23 Nov 2025 00:30:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65976B00AF; Sun, 23 Nov 2025 00:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3EB26B00A3
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 00:30:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46E23C0AEA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:30:32 +0000 (UTC)
X-FDA: 84140746704.27.B521865
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8ED441C000D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:30:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 39ZsiaQkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=39ZsiaQkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763875830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=jPzc/TfZN/zL0MztFggai4/UVHbQjHlfPgYe+pBtAHo=;
	b=kDeCUn0g8YVAK0eSth0LApynV0EeymBy0RaVmN958x65kJDRjb1+SF3MtC9IUIYM6ayfcU
	G/sYki0/f2nmgJoVt/fdrMH24xKWQTbOA0Zl3DFeMJnR1t7oDmzsElJdwFKb9BCCZmDbX+
	ZIRH5OtD43ssuY/WrIbati7S9RWAq0s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763875830; a=rsa-sha256;
	cv=none;
	b=eMjY94OR7OpZVwoXfY/69r5kpuN0UYY+4X3PINDJcVCCsfsrLnJ3LvWROV44ZkeT5Y1dOE
	deDkuDGbbiMJys/84t1aOZhf8lDO5PMrVFsqPiRBtmd5NsEfGaFdioUqEZKNFvok+xzfm0
	jutH4q2k1+u549AG13oIZccdy3v0Edc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 39ZsiaQkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=39ZsiaQkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so311776239f.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:30:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763875829; x=1764480629;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jPzc/TfZN/zL0MztFggai4/UVHbQjHlfPgYe+pBtAHo=;
        b=uNPijPNKWqZX0q1zJpSIxmcQfXDHCCd7fpvWW+yR1wPkdJUep6A5sBrtZ3e42gugiy
         mmEhJNcD1/CC3+dJdYYyMkmOjDhQwPvkkG/CbkbFLJGIWYVGJi9ZGOpDbGRZNqn4Hu3w
         Sqs3vdra0LLqizy+c4OJ/x+bQStBBd1a0CIXmX8Gr9kQI88W7mXMpYBVXWvuF75Jj1Wo
         AJXadbnV+WJ4g3DGWGPLR7XMKk+HrQBJwmtzbNdcPpxdZL/Z+PdV7otg9NUDnSlN0ePA
         KANrcWA+tQt7Y3rBvM7O+92b6/dJCKpNE9J+OLMj/OcL9dyla4uotJ91CKqSnM2ift+s
         tnLg==
X-Forwarded-Encrypted: i=1; AJvYcCUabWrZl8FMhaQOmBxl4QumrVZbmE+1WaPsJgPof1tOucRqA7JLFHYGao8qEI+eqBT61wP+DLTm0Q==@kvack.org
X-Gm-Message-State: AOJu0YyUAp0W7LcKYwER/1CSxGyXOKu9CRqKq2BLiK7Zy7ZiynKvydu+
	pkhibKwq2W6QPxersgVkCsGkeOIJ4t7HzH+5EUT5Kx6bf5OaU/JnVJVkoNw1OAOBMTKZ/tPejZm
	FP3ACOSEsc0JXZRHZv2Nsp2mWQjhQ9jHjOLCNdxiGwMYk3GbVlQfokbGLW/Q=
X-Google-Smtp-Source: AGHT+IFnBMQ05GThqt9JPH4oTmAMAziT5uppAb139v5tHJFwbyma6pxO8WwjCcs3D4AJbLcUW+6g8DAspQfSs+yk8rfmvjNEitEr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2218:b0:433:589e:294f with SMTP id
 e9e14a558f8ab-435b98d009dmr57803445ab.27.1763875829680; Sat, 22 Nov 2025
 21:30:29 -0800 (PST)
Date: Sat, 22 Nov 2025 21:30:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69229bf5.a70a0220.2ea503.006d.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in vma_modify (2)
From: syzbot <syzbot+3e03c904429660114599@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mcrapqagndjtsjqo78sfsxzszxg1g61e
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ED441C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763875830-784181
X-HE-Meta: U2FsdGVkX1+ZsZCUJuZtjV5j36m8K4V45DJdvDKlpC5MqcSFDSieVmvehk/480ZkEJZBVnB27Ghl8L79Cov+LtVpzbVi+9WxPxJXDl+pWMJuZ8UNOPyVJO+zzedVc2EIumoMIIhCT3jggVFU1OWQhgBpGv7Kt79831808VmySxrH5r5YOGlxL/j5sZ1d+On2IzdYcOV9CarJ6yRSjWbKmDTtrg4KNROPbXsj1mT8BN2AIsbQoT1a+cw8DgEsmazkY3BMqasUMCgyXJBl6rOHaLJ+DWZblegQMCoJ27WRrcaKRxuAn7Q7MBKZW4qAg4RsM2GyfDzYFGrCOous8LMM51ZtHhuofsBrqkuskg3bcBFpBMBV9cNsdudGb4fS2Shq1saqIgjjfC+ny9NuEB1C6vFhHil3RfXi3HjAysLycvYe+JMV5AGOGHYR+XAn90KbAA+1ek5tdxbqfLNTEx2oEHefEIBlp253EIlwKSHoVE8L3sLk2J779G02cdQSOtNMJ4bIPG/a6jVlVhHyrF0yVvwLFcVDaoVo5ZqsrLX4PAF5liQUfwCo/hnf0I9BM/pwOmHpByHIRxytrAbsQH8iJaOXhL2G6+PIzLk0ttLbJcNd+/e5mbsCEiriq3h7saCP0r45pn1BfMtNVAI1fnrljtjRyYnink6lzEs9ch6zYVeLFkWl2VEgTqM7QD1craswIC+CKVlk8Da1cx4aR3FU9y3DAwJsVUPluoetlSppudD8gY+3cwAcCjbsBTSsMpYHXdS46NhErHzPM+nfYZIYyorORkq+2kZM0e77EPLvQeaFFiTXCL4EmesoktkxGV9aiYDFqWeQxaRik5xdtecQmVX4T013stgRODyx4puq94IQA6wSUKAq29tHHLfurzk7WDC/6SNxli7Fu8eFRbJD7mc0tOVkclGkGzuHtXqRLVWzVtjxpYXdKSwT3iRB85WOhQ3+LwGJBt341cejNQe
 6vh8vew+
 inFHI3nx86+C/z8IjbSJzPhXJHrqDnaS7FEGuh8v3NUAfEaHNROrloT/sg8LqL8t4Goj2+VF4sZ8WoSXC6JWi5C6Hx63kr8nGJngG0fF6yYwNUJOH/nQV51ibd6BkQ79sWDhJIRPqVzXbuB2wwglzQrM0gcu25V8v6TxW7cEVyM66Jj94n6C0yGZwkIngaOUq/b6v1wYYLqTVz8hYuxGajRjeTnMF+RX71EQ2sLm57YIWuNvkLABdptpMHY8pnxab4RtYkafmZ0Z8vABg4sdARDHaPPMvrqS7Kn5mQv7LimfKsZ15PPzBmt0UHNb644wCHCxEITQvmZaleHMoO5c+5Mki++3Qst3TTu9MWVE4SOucwMs35oJYvP9kJCYtbqSXHozhUgSeOFTdLYE66rBN/Uld7/STu7agyvc1eUbATFSTxd3SoRZBrp5LcjbKXj3h7/bn53U9kxsKnDZfUSSJTmmQSXbGV4aFv1OIeYhTCEJBCZKPsIF4/LsdRqZdAaPVSsEOjVohY31TNer7e+GNjm9qPbXqjNtSgmACE4sgLrBohYtARY+gMDQbX2TnieWMxNOws1VN5i0U+YmgzsC1NjdSUy+1o9udMDnm1+HaCIg8T4CfmBUkYjQ1hcnI81zVqDSz9b7hwv1+3EDDM2Tn/M2WTGmcwa3v42mQNeiQEvd1ZMUOFtMDkk2E5iwvwKPAKNd0OeD3mYILrZ8eHIHq20gOy/SYy1rxXhgyXVuwN7ClBqlp4xqrzEN9+MAVof+r0jMNTDxudNZJt0/fFkAcJ8ONHrH5ZAmm+dPMyCO5kooAL5DnasfJqy5D4FPUg8+A/z4nZjoKwJDW+O1qHguJV67hVc+ErIXmQj4zx0TjISfnUnK0kApTqlzOqGaSamogmbiaHgOd8kLlkY2M5iQALNwUW1Vdln9lnbw83kV4jK9xnF5Mzgl0B6Toj34ElN1CXBNCFjRDx85xrVLEHwedhX9sbQdK
 Koxnu8VY
 9pUdxG7R7Yk5xHPdwFBVGl1+E1C3t9Fgn6JF+oAbtgYPo2lB21GGCNFuItXpCilcGNlmatqd55WWQGjSk8RaVvs8UOdYfbkhRDZZc0E/+vI7met1JInYP8DLLUDPl7usHgUgn8XZAi4ulwgjRuhTfgVJPQ/DuzNHx5MAdghsS7LzFsl/6K658LGLvIA2Q/48iZpHnCQCVNR5+iskmwsrgixCeMME+WfDRp2NqlLtjH2io8Agzt7Utc/fliIUeumst7aimgeZ7tE3xP3DZgMz5x40tVm24abes5SI5cR8lcI8lq8RL90cRGKa2deBrNzI6BHCM5j8VacX2rDMM20Cq/A7xJZwyAzQxOhZlkGyp8DQSDwxAr+bSzGeTH1OVsn3lFTYncM/3IjjbEueWlFuBROJ86bUilxcdWfOzwmSpFetXSswdxPrA1804Qz1VyFSxucqY/hTXe2ou6ozlT3sXvs3OUYyd7h3PImn50OmY7b9L26kIts/hOWrzyBFoWUq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    fe4d0dea039f Add linux-next specific files for 20251119
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1011b212580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=151bfd5098f42253
dashboard link: https://syzkaller.appspot.com/bug?extid=3e03c904429660114599
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ed9658580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b0f884580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8ba50fe0f8f3/disk-fe4d0dea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b6fd6a81a075/vmlinux-fe4d0dea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/78cb38ef15c3/bzImage-fe4d0dea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e03c904429660114599@syzkaller.appspotmail.com

    7f6714fc0000-7f6715b1dfff: ffff8880734eea00
    7f6715b1e000-7f6715b8dfff: 0000000000000000
    7f6715b8e000-7f6715b91fff: ffff8880734ee8c0
    7f6715b92000-7f6715b93fff: ffff8880734ee780
    7f6715b94000-7f6715b95fff: ffff8880734ee640
    7f6715b96000-7ffdfe1f0fff: 0000000000000000
    7ffdfe1f1000-7ffdfe211fff: ffff8880734ee500
    7ffdfe212000-ffffffffffffffff: 0000000000000000
------------[ cut here ]------------
WARNING: mm/vma.c:818 at vma_merge_existing_range mm/vma.c:818 [inline], CPU#1: syz.0.17/6004
WARNING: mm/vma.c:818 at vma_modify+0x1614/0x1a70 mm/vma.c:1611, CPU#1: syz.0.17/6004
Modules linked in:
CPU: 1 UID: 0 PID: 6004 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:vma_merge_existing_range mm/vma.c:818 [inline]
RIP: 0010:vma_modify+0x1614/0x1a70 mm/vma.c:1611
Code: 0b 90 e9 c4 ec ff ff e8 ea e5 a8 ff 90 0f 0b 90 e9 04 ec ff ff e8 dc e5 a8 ff 4c 89 f7 48 c7 c6 60 e6 96 8b e8 5d 85 f2 ff 90 <0f> 0b 90 e9 6a ec ff ff e8 bf e5 a8 ff e9 59 ed ff ff e8 b5 e5 a8
RSP: 0018:ffffc90002ee7ae8 EFLAGS: 00010282
RAX: ffffffff8b5d946d RBX: 0000200000ffe000 RCX: ffff8880326c3d00
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: ffffffffffffffff
RBP: ffffc90002ee7c20 R08: ffffc90002ee7667 R09: 1ffff920005dcecc
R10: dffffc0000000000 R11: fffff520005dcecd R12: 0000200000ffe000
R13: dffffc0000000000 R14: ffffc90002ee7c00 R15: 1ffff920005dcf84
FS:  0000555555b5c500(0000) GS:ffff888125b72000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1609b292d0 CR3: 0000000073528000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 vma_modify_flags+0x1e8/0x230 mm/vma.c:1652
 mlock_fixup+0x24b/0x3b0 mm/mlock.c:481
 apply_vma_lock_flags+0x285/0x390 mm/mlock.c:554
 __do_sys_munlock mm/mlock.c:691 [inline]
 __se_sys_munlock+0x150/0x270 mm/mlock.c:680
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6714d8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdfe210298 EFLAGS: 00000246 ORIG_RAX: 0000000000000096
RAX: ffffffffffffffda RBX: 00007f6714fe5fa0 RCX: 00007f6714d8f749
RDX: 0000000000000000 RSI: 0000000000003000 RDI: 0000200000ffd000
RBP: 00007f6714e13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6714fe5fa0 R14: 00007f6714fe5fa0 R15: 0000000000000002
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

