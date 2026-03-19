Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA859107526F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34766B0411; Thu, 19 Mar 2026 03:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A977F6B030D; Thu, 19 Mar 2026 03:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912596B0413; Thu, 19 Mar 2026 03:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 737DF6B0411
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:20:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31A631603FB
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:20:35 +0000 (UTC)
X-FDA: 84561964830.03.0C97390
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9010940009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:20:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3wKO7aQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3wKO7aQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=9aR0bqkLCoE8PHisrJQXhVoZ6+9vbPWrqpSwj++hyjA=;
	b=e8y8bpdBmnwYOMYKQPs+fAGwr+3C5fFuBGC3EarFxSDmu0HZkW7Z3zOiFdlGSPDtclwtru
	+dT+AExQ5VwArh0PlQecjhDhpiLumdZ75pc7YfbEvgbUzhZw/i8nRCkxCEU8u34mSU2IWu
	X6Oxm72wtEhLOwEGTynM8JTjbKJxlSM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3wKO7aQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3wKO7aQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773904833; a=rsa-sha256;
	cv=none;
	b=wCBv1UHvChvQRGDA2ME6e1Of686C4SBOwMhhCBeehs1yirOOw0crDr0mkrhrc7PQiBu/ou
	Ew/xPTKNGrP7HmMl+F7W/Jadl9SYhxzOU6LsrLcgi+a3cCFWm0JcnlaC8HhRKNINR7dnhG
	b+of/XsJTosdF8Wf4kQ2hhum2rXuFwE=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-67bd1b31789so6624621eaf.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773904832; x=1774509632;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9aR0bqkLCoE8PHisrJQXhVoZ6+9vbPWrqpSwj++hyjA=;
        b=lISoIOLlulCAAOGmSNFZ4/NSLtYIXelb5PYDeXcScCE6RdcEoo96EreBvmW6HKNtlo
         A/1Pw1t0NEwtAoevmeTXhUwQjh7w0ciOUcXnVleImRLxjawjEzhr4ugsu2eb/odC6OJm
         jn1P8e6aU3BuIzAhBQrx1zJ89tQ2x5TjL9y4OC9z4EwedzJ7p0oRxX9efn/hh6qDhB9s
         cLSkW5Jl3AMbqvSEkvbGUyFBPkz27LHQ8oFSzHTFOR4wyK0IkYBNogz1M7L3mnV2sYKR
         CYhVdcRBbpYkOrfTCAR/LklzvWl+lsS8wGDxanZv6z2O9yyMtlqE5nRhPkDCpO3qzefQ
         loBA==
X-Forwarded-Encrypted: i=1; AJvYcCUO96bvZzy78kG8VAwskP7quYPrZ7dlvwR/kFgbdFx4QwhRNhucHODS8vUBrViZS1DvkDUbxe3ZnQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+eqlX2QaASZKneTRnHg53MLQVv4xFpNlE02WWvVVBkUHMevZX
	yWfoZ39mKLJ8iUUt9x1Ae+xR0eajQTGGz6E1FU3N2a1oG9HZEqxo3jVUJfgDuqtbYYXhU7oanUD
	3T+SvmImQStUi+vlxUnUcxxUNgPCakwceMaEmfbwc9ArDJkZLmx8ic15aUlk=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d08:b0:67b:ba75:3e96 with SMTP id
 006d021491bc7-67c0da958b8mr3876705eaf.7.1773904832592; Thu, 19 Mar 2026
 00:20:32 -0700 (PDT)
Date: Thu, 19 Mar 2026 00:20:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bba3c0.050a0220.227207.002b.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in collapse_scan_file
From: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9010940009
X-Stat-Signature: 666a3thogxnh9eukxs79oa8wqwia5j1n
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773904833-929047
X-HE-Meta: U2FsdGVkX1+Yk3zCndKZ0wBfv358pOrYbFXckZf1JL7DxNF+GpkqwaGOSxusbAoS8NdQsDSdPY1d1xJOoq/j7rFAx4PY1L47hjiEBQ/IGWgTvH0Ky58ZRgPvjLkIkyP1JwG/Igqzj/QshzEBV7efSJfW6/5placd6qK7j+4ZAZ2NPUViSqHjHTwcDCRA+wS3mufX83hB4fMPXnoHKmwrzvaqUbpPF63V9gCOXuPUAKRIU9xFwIFUMd9IpWVnKxBrg3TsiR3jE7C/6vQIBrDHADKAyBDz8uoZva3p5KzrssWM4fuRwhXeTI4ei45ElLdsdtFFxYjrL31CzO400bOL7EpbtJOTR3vry2EtD/beBi+9FetnZFVud3gqWSoBriafTdNhUYI2drdZJfW//t0j/pe3/E9bFI+BUFQHSs3nv51q+ObLmOhCYNLcVeQ78ewwsevZMX0prXOJa7NzO+P0z/HXAwBdKMBERzwwICKFF1+ombGJiP61gsZ3574a9UfPcsLmL3Ks+n3Ps8WlBu2VxNilvdj7ZdATRQDgAMpFa5HQ+TEV+9UDJwTc3sflMK1po9ZgScfiTVhidqOM7wwj7C/JdspA5Cbsx55Hbl4TA7pOHTl+FPK5Hez5hWUCK0QVhvWEbaU1YX/FHnziWmRUuphJZ4q6U1/YM16/qOEKXg1z7Qtw7DU1HHlpsc+4ti2ld++B0BLolEfImcrue1MPnMnUByMKCl/VfvVyHjjH7gaBpT1jcZNHk+poTpNsRJD5c5hAJujKZhaF2vaG+1Rkp5kk3s6j9LdAAoYvrkVzwghapo6Iu3jHFi/subvItKmXOW6A3oQ9WaVemCAHkcG0rExert1brRZq4G56zaxpg4dOg99ul9625VU1TJvLRP1sRXfkY+z+oTkIde21j3DsqAlJQlikIluFeHaeRlcO/JEvSB1MvHBU4zcZJW8F97gfCXeZez9bIUJqHufkjGe
 SNZh43eN
 gCJVibzMt7yf309z01a1oIs16ZHnLdiJgKGudMUs/H+AlpabOF1IkqwSSZyxE3tGmLeR2MwKQoyd21qC0Vrp6bbV+NU28XvApVmjiPNj+iGIK56HyK4txk395V7iwb/rkZxQpkDnOgqtj1rM9vyUkbPTn9eiHriLR9RUwZ2uhAGsddRrkJKbY8sAltrW60dNhwRTUzaUox/GZgmkT5ExwPM738jocWLgGme5gEY8jCy/UDLYh9QJ0kz7dmRikFzbYti0J/1AIFJ9CcMiQzqf2zCvDsL8aktONvOkwc1LQbKuRmei0aWyygqnlnl3wNg2EEAPP8kgKWfRLZ2OaHgx7mUq6SViYV2brt1gHsDldpxeXk6OYwTF+eyqO7R4DJY3s2e5EJUfm9QSyDIQvxrQAfV5iLW4+x57uVPi0xyEn4j77YckvFj6ZezpT/5hbSADMPTE19yzDdAZExbCCQe2YZ/ydI9CKzz0ZO1OjxvSQZvudLqmBmjWRd8cT3syOIEO4tR+n+I/IBnSCF7a+x/dLcGvqZ7DCW3/G9OLNYK/CqGPYaPW1gtCsbXViA38+CMyZsrohWQVPSf7jelvJzM1M6OXPwAzYJQqBNeo6Kk+X6pXmCBk3Bgfo6sZF6VjNUaslzNPLaK10uwq5V/exF1W3TT1pjuG9vKpXmoYm4WpsOmQPm51cTUJRGUdYuMKEwYytSLokRk7rebpFuD+2iAoKyqgprr1dFVlXA+mBXx/v4J+MrPWXP/PSPaq6TMXFVikfN9LnePo3uxFlC6EcydYhrTdoqqvbI48NXOgcKttufpQ/CRdZmr1y7QdC8Fsh9fyiTcffgmoCbc7WEhOeQg7YZBkpRM26N8u1bnp/yM1TDWeszRG8lbSA4+7CtUsk7vSJyrNG+wgbqxHfQcK+yWIy7hAkgxC0fj8uUuYFdFhyOBmX5HSIplqrkY9yLNWsxk3UhUdmjtUp5LHmI0IQZ5FgcrLApYLZ
 HYRSdmJ+
 UQHBEy7mkazSQ81ONuSLumyJGUakh9+u0+SCavXisiXzD6JIrS+JfVn52tlvRRAKg8UpazG5QRr7JCCmT1tLukXW6hTcL6fDR+eT10Qtn0dCXk9oWn+32E3/2/wnRUqN45DbI1X47gKoHGKVfRHD0Qg1CTjVLOwn1P+u4VIrUdWSFDfcGttoUPrSxpgMe8Om0zqdJNvaX3TtWxXyyAMqA8VWYjpAztTQ4i7P7MTiQkyUzg6f20rpgkyL8/GWRLOQK3kALfKwOfBR8wonYwkLdnFfw/xOTRHHCNbW5Erl0FhQtjks2hSYkdDjqvCv7RSnaPMwcaOjpqFnLpuXCgoXQJE1zvRYiBfxMz/kqe3D2nOTkojDqbqR550Nd2ezWDIPqQD1HZE0q+w3uOgyvWgfTm5V+NGGNPg4bF9B5XTk5aoNgvwCyICwyhhbvd2sw0iP1a4EWfQIX2Mp8SahgxT/HBL+qvQ7WIOV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    95c541ddfb08 Add linux-next specific files for 20260316
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15ccc216580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed431987028345c6
dashboard link: https://syzkaller.appspot.com/bug?extid=8961cb270ae74b4129fb
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f778da580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cc006a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c40f27ad73d8/disk-95c541dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bd811888f684/vmlinux-95c541dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3b72363d7dbd/bzImage-95c541dd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com

node ffff88805d558b00 offset 0 parent ffff88805d558840 shift 0 count 3 values 0 array ffff88807a8195c0 list ffff88805d558b18 ffff88805d558b18 marks 0 0 0
------------[ cut here ]------------
kernel BUG at ./include/linux/xarray.h:1441!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
FS:  000055557e3c2500(0000) GS:ffff888125437000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000b000 CR3: 000000007ac66000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 collapse_single_pmd+0x22b/0x4510 mm/khugepaged.c:2437
 madvise_collapse+0x34c/0x820 mm/khugepaged.c:2859
 madvise_vma_behavior+0x1094/0x4460 mm/madvise.c:1362
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
 __do_sys_madvise mm/madvise.c:2029 [inline]
 __se_sys_madvise mm/madvise.c:2027 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f90d419c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd50711398 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f90d4415fa0 RCX: 00007f90d419c799
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007f90d4232c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f90d4415fac R14: 00007f90d4415fa0 R15: 00007f90d4415fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
FS:  000055557e3c2500(0000) GS:ffff888125537000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8156602000 CR3: 000000007ac66000 CR4: 00000000003526f0


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

