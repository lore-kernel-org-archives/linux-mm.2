Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E1AE63C81
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 02:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3E36B0005; Sat, 24 Jan 2026 21:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB256B0088; Sat, 24 Jan 2026 21:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1B06B0089; Sat, 24 Jan 2026 21:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA3D6B0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 21:23:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A92A0140404
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 02:23:31 +0000 (UTC)
X-FDA: 84368889822.10.BDC498E
Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	by imf12.hostedemail.com (Postfix) with ESMTP id 03C8D40008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 02:23:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3oH51aQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3oH51aQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769307810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=At1cEBr3ulEVWtp6VYDeLHEdLnVmvNt/QgU1kB8+sZw=;
	b=ABVH70DLebA5XSLKotHGASuBPbqUMXGZSgs/KoF7L2QWVHCvNnU7dOAVq3V7FCZHtSSueY
	nOsOKbc/6KxgyicZvc+m5kRAMmS6fxKuY+8TTKwrjxogGvxVJZnlVEopDCOUZjmXT8ABfh
	XEeITV/wpKpjqN9i8ohpmUoFDjzI3hY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3oH51aQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3oH51aQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769307810; a=rsa-sha256;
	cv=none;
	b=XCcH/kcBj3MnlmAU3pSG91zD245IYFfXfywBgMq+dVkwaISD7WWW04jL1JG4PeyL8Rtwka
	iHCPlkmHsF7gXPqJLK+zQqE7z8r0Jj+o/Y96zKJynMW58939zQakrm1omqhHlBgV4WmRsS
	BeWFuv67UWQBnpM2D3UqfFnLqVsdiGI=
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-3ff2af9b23aso4500563fac.0
        for <linux-mm@kvack.org>; Sat, 24 Jan 2026 18:23:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769307809; x=1769912609;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=At1cEBr3ulEVWtp6VYDeLHEdLnVmvNt/QgU1kB8+sZw=;
        b=LGZK9hyHEzb126x4SaE0nTq+5EsWNudErnfL7sVDWevNES27JsuTsueLQm59l4uLCy
         AjWO/PSZBPkDGaimlPGsBVSzS56wUOxBRfWFU954xVOwteZ+QEnc0nc31zG6kjUuTfJC
         qfbej5VM4gZx5FZWkDly8udma1E95fQVBbFQDSyOhTSRK5k32dfewzOngDzphKDGZn1t
         Ti7wUxnNLIL4NDPnvrNgZ6m5tfxKVIjFTRPxFwCk+zEWuy5DCDHGUjYSnZBi5YOWOzN3
         iV71NOeWNDhQ4o2eZFh3bjaGXV6miUxa/VOG9THysrGJnA4HF8pDdWWw5GizH1b1Bgiz
         NjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiPGOv7dvQb+qg27pEbnMopilvybM6N5Uvr5S1H/SG/YQ/ZrfMcjOia3q1iajVvBkzanBeujc+JQ==@kvack.org
X-Gm-Message-State: AOJu0YwbzJBx+K8VsguB4539wtJMorgOMZ12i/gyiV317l7ewwUWfo2j
	DM0aDM+Zorsy9OMy1jQpx+KKV7cR/0UzJYXj7w0g/erlg5F0eDNukfB4vuiQQpPRUf+yWmzRCpy
	vAs0vHFwRqSxk2s2K40PKbGH5BuyTPfST4R+K64R3SwDTtWyzO4Yto6QDqDQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:460b:b0:65f:1038:1312 with SMTP id
 006d021491bc7-662e03e4d0bmr226806eaf.24.1769307808980; Sat, 24 Jan 2026
 18:23:28 -0800 (PST)
Date: Sat, 24 Jan 2026 18:23:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69757ea0.a00a0220.33ccc7.0017.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in hpage_collapse_scan_file (2)
From: syzbot <syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3du6pcafwk85dayzuiu5tuzaaosrh16k
X-Rspamd-Queue-Id: 03C8D40008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769307809-265393
X-HE-Meta: U2FsdGVkX1+3fUN0CE6/BCS8LgHX+FKem3V90bzkyBOLImFZdGoRyG4gNI1Qk2g50JzQbh0kaeuGpHtRxj323eYe44F/SxI+QcsHBxnqnyvO2ElesZ4Xi/lpVF0w7YNz0bAD9ScVHIiESh/yHQCnd3oCu8B+OVYlHAsEoYg8T+K/a0fhcxRlWiHBFJylHg5FCKYO4RtvloyJ0jCugkBgUzmRh+AlLsAPif0HnXff+WwOikh9KAOUIhnG98teBmMaoAOIKkoXCdT8cq+XH6LmDwwJTeaqHmtA/Hc0UCdx+DMhxOkRtGB+yE2cZTP30vgF+gdMrJ2nFbjEFB4b++z7CJcRQRgapxmxZBkxRaxrNzhIFL0sZRBBWZszrHmRj8TY2Hb+ZSJy2AFAtXJVHuJ9rRkjcVTBDqkNYQP58XfEMa9C6RkXvN5zDxd4POLLmb9/AkcTsyFcxWufr4uy7i5YrHW6NaMRCrVMsTNYZVVVO3jgQPeS1GrSW8TvPeKuIACrSxkfhO3gq6hjeRkNEOBWi6c5GP390kBzNLgOuwCklXN4NxdDIw4TviVPFoou6pZYNTKTDZBdaymfAiaFNsr1NEl+ETLgdCiPSWzoTHaKcWiPhx/gk0mo4c9THmjxRSmG/Z9sFgaUlpDXVtaI28mNea0KuaZwLGOD8W/Lt+KMwuttzsXWCKPPRJABpgbRW/wPEHjxbrP9KNGHDrYTiOn97DdCuCMOQTBIU0W9vnTiW8tonkczfa23RsnuZtX6sMFFGKJsC331s7s8eyAnkprgqxOIIs6Klx5V5OLT+ImljJMWFqGwu8hOX4j/j0nOPrne4uniWqX4Xk/jqcQO0XHsyr4YR0jQ87OsTt8VJq88INAVdC6/K5cq0huGJ+Ek1fgt1TbN6hXej1GiJflJWRS3khGOEcaSsfjRcYKdDhaEIdd2PH+q7553QMFh/pzJFkAzi0wYS8tTH6v+ABnvJ7b
 NMONoDb5
 rSVXFfjjGDG4mK2YEzsLWAsheV0h1tbAbf74NSKIcYOKIKwz8+la26UhT1DcYci6nYPyDVjnD5ZjuW6PnjSoQcR3fTwTkBhNApscuTLFJc2IVcjH/J2ZkuDO3grFVi2TNUJLyd8VrrLQMlDLH9du8YTv9XLuUsTD7oZVtY1NqIouT4aQMAOcgax7IzehjMFOGSNsFsN0a/CHUIfCP6doiiStkNF7mrtgrT4eX3/ihcC2d7AN1qXJ9P2CPZip8FFRQX68XI2PDlGBFJptaNCIAWmpLVowjXu9rZKaGZDzKvTdFY66N/6lpZODfB9KSk2qzIz2zwK/ml/r00wJyv5i9Okm1yxRrPDQmB96dQw38Hbcm2/CM4F22YHjOufBJJ2G09SCxm9OZca/5LSrJqKD6CF3+Ljw8jx7pKmiOhWd2npPyMxlWH4JFpDnKDLxml1ySDmHcSzWWa6h2pWmJoe7GLJagEMtFkIhUgPTIErfaHxzSDW/drN0+eGxOrfg+AgAuo1T6IBVp8BBfRLWGo58XQw1VR45WGJzHDjcsMo4rqkID6nqz7M20Ywv8INHwn+h/cKES9+7uA4YZchmm9YkbvLjx64pOZX4JckbzP6vb5g1M7siAhxF73bst6V9koOfyiKmGfH5mM66TF73oJssyWeQ5BXg9ogJ/pgS2F5siVEbV0xGvIvG5Wwl2AGVfEzC5UujNXSUjpMCx3ZlttU9WvoQcfkwTtgPTH1Sn/2/PkRNRfq+t2OAvy0c1t/3Y1uPHR5Df/6cfgctqZQT/oICS9Yd6rwLKuNGXS0ZSM4NRbfI8J5WSDQc8pFQXcFKtU1RBlcOqeXWMC6lusNpg+MKp1/oDhzBhu2DSlZlehu5RSOP8wi87/aJuoTTGA0JWkdFjQlBoNsmZ1akNhRdMSFapU0+XVc304kzWbmyOyzs+DZsHwi085yzJkjJFccux1Q8v6i6cMRy4IbaJ8gARChZvJjP+Rrua
 wlwuIH1M
 z6NnXU4LMDNyUAE2ONg9rw5ULxj+krnXeKcXSsCsOynee9V2GQ1qRaepmnuA2UXPjJ/CmSEKybmzP7KfbZ23y1DAUe/dJO/DzMDXMSASs9tzGn0g0zEt/z7qxIdnzkRtdQFi1nysOvcDALwnxkzU9+7WsY6B+nPtaUcL5Ada190d81duCQcekStYR1l5qz5qlvIMGv6m/zHRqid6xhIOC9SDNsTfmTuUApDHYOpYTBXBxSVXAmfOdIuzuMD4YfOAEOvFJoW6gkkf5+asL7DqNc0Kz1xU3ORivqwgllhx8R48nLPxm7/xj700qtXqm5et+M06wj8YRWuGKKGq6q2vJSWyCrA0IWk2ohYD7QZAXLaYGDnxY+pBDYRXQC0i1A8dJIMZXfRQGus2kdq1Pc/uIpqfDdgwICm9S2bdKjjtpezEhiZxiPMNlfQmw1HztBiYXtK9iJYDo7SVdwScLT2hAyT1bq+EhJFD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ca3a02fda4da Add linux-next specific files for 20260123
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c42452580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=10f2b64f8f12b9a4
dashboard link: https://syzkaller.appspot.com/bug?extid=bf6e6a6ca143afea5ca2
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f7cbfa580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112d405a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/291ebca63a31/disk-ca3a02fd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b2112a214b54/vmlinux-ca3a02fd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/77d1ae437e07/bzImage-ca3a02fd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com

node ffff888148816ec0 offset 0 parent ffff888148817700 shift 0 count 64 values 0 array ffff88807be6b0f0 list ffff888148816ed8 ffff888148816ed8 marks 0 0 0
------------[ cut here ]------------
kernel BUG at ./include/linux/xarray.h:1441!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6017 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
RIP: 0010:collapse_file mm/khugepaged.c:2041 [inline]
RIP: 0010:hpage_collapse_scan_file+0x4e0c/0x50e0 mm/khugepaged.c:2387
Code: ff 48 89 df 48 c7 c6 c0 8c bc 8b e8 ee 6c f6 fe 90 0f 0b 48 85 db 0f 84 29 01 00 00 e8 bd 34 91 ff 48 89 df e8 f5 c4 4b 09 90 <0f> 0b e8 ad 34 91 ff 48 89 df 48 c7 c6 c0 8c bc 8b e8 be 6c f6 fe
RSP: 0018:ffffc9000422f120 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888148816ec0 RCX: 6c90c8cc739bf400
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000422f428 R08: ffffc9000422eea7 R09: 1ffff92000845dd4
R10: dffffc0000000000 R11: fffff52000845dd5 R12: 00000003fffffffc
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000555592982500(0000) GS:ffff8881256ef000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30363fff CR3: 0000000031994000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 madvise_collapse+0x42f/0xb30 mm/khugepaged.c:2817
 madvise_vma_behavior+0x10ad/0x43f0 mm/madvise.c:1372
 madvise_walk_vmas+0x57a/0xaf0 mm/madvise.c:1721
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1937
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2030
 __do_sys_madvise mm/madvise.c:2039 [inline]
 __se_sys_madvise mm/madvise.c:2037 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2037
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f948ad9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd1ef477c8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f948b015fa0 RCX: 00007f948ad9acb9
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007f948ae08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f948b015fac R14: 00007f948b015fa0 R15: 00007f948b015fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
RIP: 0010:collapse_file mm/khugepaged.c:2041 [inline]
RIP: 0010:hpage_collapse_scan_file+0x4e0c/0x50e0 mm/khugepaged.c:2387
Code: ff 48 89 df 48 c7 c6 c0 8c bc 8b e8 ee 6c f6 fe 90 0f 0b 48 85 db 0f 84 29 01 00 00 e8 bd 34 91 ff 48 89 df e8 f5 c4 4b 09 90 <0f> 0b e8 ad 34 91 ff 48 89 df 48 c7 c6 c0 8c bc 8b e8 be 6c f6 fe
RSP: 0018:ffffc9000422f120 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888148816ec0 RCX: 6c90c8cc739bf400
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000422f428 R08: ffffc9000422eea7 R09: 1ffff92000845dd4
R10: dffffc0000000000 R11: fffff52000845dd5 R12: 00000003fffffffc
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000555592982500(0000) GS:ffff8881256ef000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0001002a0 CR3: 0000000031994000 CR4: 00000000003526f0


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

