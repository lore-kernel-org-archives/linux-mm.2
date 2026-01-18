Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FADC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 07:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF866B0005; Sun, 18 Jan 2026 02:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D476B0089; Sun, 18 Jan 2026 02:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C3A6B008A; Sun, 18 Jan 2026 02:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 467CE6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 02:30:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6F20D1E32
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:30:26 +0000 (UTC)
X-FDA: 84344261652.09.B6523D7
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4286DA0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:30:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3EIxsaQkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3EIxsaQkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768721425; a=rsa-sha256;
	cv=none;
	b=1AQ+TsPjYYQF8hRAbij+Qojzw9PxStbXE+6f+6Qno/XaC3JwBLoDWLDty+SSZUEFh3oJOx
	clVKJZ95EgnhTVejafhEWjYxAZXQA5aS7bpHGjWS52F+N13og4pwru4SQyhWKx16VRcmfv
	HKqS7Y9V22y9ES9U/qww+MLG+rJeOuI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3EIxsaQkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3EIxsaQkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768721425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ZFGRjSoiZTvO0TvprJvjeQHPFQiQ4Oflp3kwXlSILTs=;
	b=fuA7xkqG7MatSjJzJB0L6E2i/DrAweQ025Mz6Vxf5zX5RZZGxE9uE/B9YjNaT6Ci5Ip4Pz
	igqixHiZem0vsVGm8kc17fba4Q9gP2DQs98sMgjoYnjmvGDVdyY33052Gu865sPS9u6Z5V
	nMhcf6AexEsYB8NGzNIqiFifdUdbtiI=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-65f6e15ad5bso9089245eaf.1
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 23:30:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768721424; x=1769326224;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZFGRjSoiZTvO0TvprJvjeQHPFQiQ4Oflp3kwXlSILTs=;
        b=COrNGhAWWrihHLhj3LkI9wLcaiLczcKe7pX/eRvXzAGMKlGdZeGAneD+WLBtr7fvi+
         rRK87TlUeLemd76d7o+vbP9jy4y6jYJ9T3AHSSFHTtOYbZqwWIIZhQSA897Jbe4oupJ0
         Jukm8t6BAi1oEz6OmemlNGfzmvHlobIFc8wkKobpgU/tHgWnl+DLuBVjOWLBduqFjNNN
         KH4MI1ueD7NrFprkYyKxmjSn55+TgGjuLxj2R4jH205oDJXhefr3j88R+/0lPUkCt6OT
         gaFdu1av0YmylPdBIvMiSDKw5qhfLG6McjFWxRUgXjqRq206V6WyI5eZetygUo9o5+3g
         mTYg==
X-Forwarded-Encrypted: i=1; AJvYcCUhdNW2f01Bx0SlpC3PB/h7OswTvJCC+poZOEnCM3PkywiLFeiVvthVbwkKazQYIJXg9LyJcGRnvA==@kvack.org
X-Gm-Message-State: AOJu0YyYSnYvsVANRrFD2T3BCFcGYfslzr3vM58rdNOArnOYw/P5btaq
	q+hJ7LQfpCRH0vBY6P1QHLIrkYiek/eCpJlh15ePcC+18x7TVLkNh8jmQNw319H2dPvcwAVp4t0
	rmH7kLtpNsJDgVP4Sc9BSSmAXQC3igvs6dAi1dU8x9FHS3JOFqNGRev0kGcI=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1b08:b0:65d:c8e:840a with SMTP id
 006d021491bc7-661179ed553mr3705580eaf.65.1768721424332; Sat, 17 Jan 2026
 23:30:24 -0800 (PST)
Date: Sat, 17 Jan 2026 23:30:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696c8c10.050a0220.3390f1.001a.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in unlink_anon_vmas (2)
From: syzbot <syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: ccp6q35s65k8b8mmnhcrjmk97p9iejqe
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4286DA0005
X-HE-Tag: 1768721425-159428
X-HE-Meta: U2FsdGVkX1+OJ9I0qwQdemoQzJBpG7Lt5DpPWrYsNRCLIgudcTl9kjlYSUdGkOUc2GTuxpuWqbCSeFoFzlW1EFR3b9B2RHs5ue07Wru0nkoXAKqDdhs6PNznJGyT2doKkEewbpbD6Z3Q7Wh0vqmNWwQDo3p2z4YFLaNObj3JA/VHZmhhixJY0UywPuAqhnTsW2FjZqJ+xRmittNUfrDtTFSmkySEO0/01Qjxm+8H4JD6mvgjIuZpr9aAK2b7fFnpbkWeSPtTeO1JZSJrnOU90cnXkT+uYAXOieFKSv/faY6Wxunn1Fp2Fc6GSIkBkBMEWVUvoM6SjjV6idOaBvSq5XKeRu49zXIVrtXBuJwjhUoVLCwHjL7IAou59Ys1NSBZ9nrHv3zzU23mI80eS4TBrUOk4OpaAAUbhEu0EYEG4Y49ZAdZr6gpy+2sB5c2QRSlZcqM41WkKh3bSekhoB8YbfvI7fLORuMbTrVU8PXheLxBwqM4zSZNhjj/Kge8dNSsNqVF3rpL2QD38GJhYi+xQTdZtChYIi1ljYt1zWiEVc6/SMsorkB00YGtZeQYRAs3/sLxxAxLMIrjjLGtmcaUIrq5R0g9aPj5lWkiw5fZeS5b09/wp6FqWJ+GPENB5Dt+vIL0aSUxgsu/MkCV2MC47QxxH4a1HE1UJVJDZG2lD2Mal0LHaEZnRYDO7fhVIqLHXnU8E+nwI5/fJqNwdMR28fPA6Lny8hq9LHdcLkR1EFMlR57Dv4InpX2d0ot4psQsi1vU1VUT7LHdR86lmVi67DM0oVFrqaJu+qQXnrKSYJba2QRQTFC8HTckFJX6BeOs3Yy0qVOwuV+VgMqddK+HD9WbM8wfAWgzh2rVQywPIlm5g0Y8GHNcDgUBZ3KYRvJTUGGBsZG/4j4LP03YKO1m89Z0ZTA7qcFVneSHLLITYV2O83xEpjSGwzianSIqKdptyJNTpN9sU5BO7hA4HBN
 vWPa+5NT
 ey6v+jb/KBtn5iYERZQSwsE+bAMqmy3HtdgIVADszVf4mvPluer9IvtPJ4TBJ6L8kyUAIAKDfpKakaZFtWNAjj2gVZGgL2XC6hOVn8ALnJ2FNq69E9G9ouaqhTpQFsPX471tj19fnrZDH4fnQtZ00XjZA+KBmXmAH0OsMrn/dEqZqMzUIykp2jQzGBvPY1qyJS2GPmlCVC38F/S8A3O7h6xKSnWLBKWN9XpxAe16MpymybbBrZQ+3GJG6Oi45L8EWHKnkjs9qd43X4zNTDIsDdd+G6Ska5JrhcMhiEQZ4kvndLheprUue27hYqVhCBbLRdNWj4BiqvpH1669LVzgpoh0ISqicWBtlIfKUt0ov0WDTDwfTnSurMFdTQahkoVd8ivKjjNEAKPu+JX5r59h78jAhHr2TmU/sWhxxiBfanlDXshg6syOdJlxAwFdN/hoEmnAV1pOfbNIan3NM5zA0A3H5EadNMhgT3jQ6UWJBZDRls5bgerpA/ePpYrp7hmZV3eI2uIIn4fBpUlJDy4xckU73zzSKn2LkyPu+5tI5ljMnYGbp7jBdIts4280yPkiQQd+gyOi6keQnpkYX/wmmHmyjniXtxT7O52PYL2WVqFEuNQ+YkohN31aH9QDScECLH5dIfzcWMZyz3Ycv9Du0x+SC2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b775e489bec7 Add linux-next specific files for 20260114
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15dbc444580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2dcf53f0a51185
dashboard link: https://syzkaller.appspot.com/bug?extid=c27fa543e10a45d4e149
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17070522580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1683f99a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5e077e7eafdc/disk-b775e489.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ea69aef6ee56/vmlinux-b775e489.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b8b6986280d1/bzImage-b775e489.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com

R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f16655e5fa0 R14: 00007f16655e5fa0 R15: 0000000000000002
 </TASK>
------------[ cut here ]------------
WARNING: mm/rmap.c:480 at unlink_anon_vmas+0x701/0x730 mm/rmap.c:480, CPU#0: syz.0.20/5987
Modules linked in:
CPU: 0 UID: 0 PID: 5987 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:unlink_anon_vmas+0x701/0x730 mm/rmap.c:480
Code: ac ff 48 83 c4 40 5b 41 5c 41 5d 41 5e 41 5f 5d e9 84 df 56 09 cc e8 8e ed ac ff 90 0f 0b 90 e9 e2 f9 ff ff e8 80 ed ac ff 90 <0f> 0b 90 eb d3 48 c7 c1 10 ab c4 8f 80 e1 07 80 c1 03 38 c1 0f 8c
RSP: 0018:ffffc900033676c0 EFLAGS: 00010293
RAX: ffffffff821460b0 RBX: dffffc0000000000 RCX: ffff88802a773c80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff8fc47af7 R09: 1ffffffff1f88f5e
R10: dffffc0000000000 R11: fffffbfff1f88f5f R12: 1ffff110062fbaa8
R13: ffff888027aad900 R14: ffff8880317dd510 R15: ffff8880317dd530
FS:  0000555592787500(0000) GS:ffff8881259ad000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f166526615a CR3: 000000002f0cc000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 anon_vma_fork+0x4b9/0x500 mm/rmap.c:438
 dup_mmap+0x954/0x1b80 mm/mmap.c:1790
 dup_mm kernel/fork.c:1529 [inline]
 copy_mm+0x13c/0x4b0 kernel/fork.c:1581
 copy_process+0x1812/0x3ba0 kernel/fork.c:2218
 kernel_clone+0x21e/0x820 kernel/fork.c:2648
 __do_sys_clone3 kernel/fork.c:2950 [inline]
 __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2929
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f166538f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe55f4df08 EFLAGS: 00000246 ORIG_RAX: 00000000000001b3
RAX: ffffffffffffffda RBX: 0000000000000058 RCX: 00007f166538f749
RDX: 00007ffe55f4df20 RSI: 0000000000000058 RDI: 00007ffe55f4df20
RBP: 00007ffe55f4e090 R08: 0000000000000000 R09: 0000000000000058
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f16655e5fa0 R14: 00007f16655e5fa0 R15: 0000000000000002
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

