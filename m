Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD57CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 06:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DB88E0008; Mon,  8 Sep 2025 02:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965108E0001; Mon,  8 Sep 2025 02:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A27F8E0008; Mon,  8 Sep 2025 02:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73DA58E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:54:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A1F0BC645
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:54:23 +0000 (UTC)
X-FDA: 83865169206.30.27D3D68
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DE3740008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:54:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3nH2-aAkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3nH2-aAkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757314461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=eeXrRPyIgejXCeJuxm3Ac4RFmbo1rm6MPvzN4tnj+H0=;
	b=q+POXkjCHv0P6wafktEBAfmepy/6b9ffBu8bvm/KmgU31UzV9XkEMk15DLWQ7s/iEcz5bb
	6TEuuESdaBvyhoHGklo3LT5yePgtUixXbN4NgDtYM4BBcoLa0jCDZPF8QDBMF7gkyWHL/W
	j3Pm76FVh871cFoLHGX9jmR+vaiheUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757314461; a=rsa-sha256;
	cv=none;
	b=BGYnwx6r5qdmhHCtUZHLwmcbMc5bPxPCAkJxVAL9oDQGpCnOCZhhmOUk5P+S8s0qBDLLtH
	rr5gGkCQuzaaULFNmDEgvySjtQ66K2k3vuIU5h55rZkgqtJizOyt2/YXF/nVBS9KULkL2r
	o/ivyHB57XzFPaSqRb+U49krCc77Rzg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3nH2-aAkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3nH2-aAkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3f12be6bc4aso52917385ab.1
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 23:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757314460; x=1757919260;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeXrRPyIgejXCeJuxm3Ac4RFmbo1rm6MPvzN4tnj+H0=;
        b=fvbO1GGITEZpXgxyKP/3VCKF1ayGTFmrECBE97UXfiAGxq+Y2N1uVvQrn01JobNElX
         Hrlc3CmfnYfEik9IwyxVWQ33Thbrbzpxz+UpUg0Vse83EW31GJR4LPrplop2Bn9xtDZZ
         twIKsXwJGv6isuogFhSHASPGt+oWeUgOgoszxzlxZIdrNk7g4SWaCdrT/TW9M9EWY4nc
         yF56D2BwnHXoVTAIkzY0FSgjJWW/AYMYH2PNFdjwNhmk7AufXv60800ATvlp98IdHSMe
         dtcA2JrvgFjmFIxgfK5B2l3Tvx8LEPohY5wf4TZ1dILcqAYHSqrraAHl5jYCkEY2D9O1
         xP5g==
X-Forwarded-Encrypted: i=1; AJvYcCXAQkkvudhc45in2FUTrzLv9i2xWdFgo7JDV/qIkIIik+XIAhozwDgYN/dStUr6UB7/fgu5zqGNSg==@kvack.org
X-Gm-Message-State: AOJu0Yx4wnzEVjuRML0OQAJ0CtacJ/REw2hQGdoR6eXswti8FVoi47Hp
	/fXmkQKatMKEePpA7CIbKJJsXGGmLZBrktkFL/zGmLElAAQDvLlTTDmnZdYpipejCebf5/uafeD
	9ZI0KUnKTEbT4cHsZEOqYLvgMBY7dsSbgtefhK6IXXZSnIgkuTm+WHeXUX7c=
X-Google-Smtp-Source: AGHT+IEHzVwxQ+idrbjlPpfSnJ42RVk67+cbnVu56F0ansDNYkV+viWueojAKjIWUsTglqs7rHm0m8C0piTahpr6RzlnJVbfQiVe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1808:b0:40c:50c:376 with SMTP id
 e9e14a558f8ab-40c050c05a1mr892635ab.26.1757314460533; Sun, 07 Sep 2025
 23:54:20 -0700 (PDT)
Date: Sun, 07 Sep 2025 23:54:20 -0700
In-Reply-To: <20250905132019.18915-1-yajun.deng@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68be7d9c.050a0220.192772.0853.GAE@google.com>
Subject: [syzbot ci] Re: mm/rmap: make num_children and num_active_vmas update
 in internally
From: syzbot ci <syzbot+ci787cecc1f1f83578@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, harry.yoo@oracle.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, vbabka@suse.cz, 
	yajun.deng@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DE3740008
X-Stat-Signature: mg8ptx35jzgowwcmdshb3gfb8w8aqugu
X-Rspam-User: 
X-HE-Tag: 1757314461-458712
X-HE-Meta: U2FsdGVkX1+YOgMB4slGRQpOFh+O0FMemMC5Mac1ipO5O6dfEaKt2l9Sqs4kG6H1eF/mv/iFHu/+pCry42rDm94bq6nrnZ5GuY9RizjYwxfQahPPTw/J6o3lk1l9QU6njNvG9AemTES61O8hcuF4P8Ab/ADSC243clkB/dpJMCxRLzSTnKqJCOelbUGSDuxKEAOFYGt33b3mRJ58lXh3VJlr448mvK+7KAdaXRC97AHf3h8cH3EpHXl6nrJEk8iTFWQAAldzSdI2Vh5bdEgAfWK2ubstjMR5K4BW3UgVKbVynWarkbfDQ85QVJo+s1ZzWcyCb2SyoXQtxJsi7LRRCekrCGBSNwkQVbShCs0sFqkhXzgu3TJyETQJr4Z9zlJYb+bjrZMh8K9Pgkb22KbOt2//tvXlDJAW9YEq03/KQMKctR+DE0FlsoTQnpDCxiqq6vcT4yGm0W7QhosnMVEyysaFlIe18oUtse9N+n3x7CvANfjrOFiNCXfOHcWFJa+3p39VDxM+XzxjnHqhpIWCU5xg5voxUol45mzFAe3clSZpwBo/igDhP43nViUTBMKHIIJwE44mnAFhjHTYfrG1YvFYiHbWUODvslw/z7Q0O+1EO2FfIyXLUNztT62sXYZVJlQJ752Pp2zAemJVapXmfORNE/eRQFpLK45BJh0/EH0rtQ3dk66ExkrXQDXRyP3JOkuW+S7WNW272R4g4yIxdFHFcR8GnDhOsMHnTHHNsaZQmnJADGxyhpVWjV7lU78XNaqIpSoEcXWUOl5fAK3idfVHKqSAEJRF4Lbdo02pBydf8Mn3ES2eSvTVupgtyp3v5eZA7VTouqxnoOaObMhbNyVCl1gERANJ/42mw4zbdQ8kgGAanOuhFVy/3VXDXz4wMow2o2I180KtCJ8UUcYXt89WpFccuU/MhxlO+zfibN9aR+co1UMmoo0PDqIhjOMtey87croXuf4m73b9oyX
 5yc+/zAa
 HKl7mEeZ8KKkkg5HtiqZQm8YWAaEK7oHtU7UqcXN/HDRqBOav9Ui7PA0VBbdkf1ITwEotb2tVGNQT481g/x6+lYB/Ypm1jxSfJ5cr9U9Xgc0q350MtI569tvzss/Hlkj7FS9NkmlluecXH0midWaHSoLEbB8O3vZf3Ni1x0WfFAvQpbkVvltujKrxa7pjWfAFE1/wiaxhaotvy8xPAOLINdVjIq4B0Imo/6J3NWJ8ZdMgp8yy2j+fjvF2i9tmyaiAeXVGOYVAArBLds47OSfGcCF929e2DtQ4eWPkbUkKWPsnA3kJiUa4FEnB4ISBV3bG2pr5YT83dXJgx8ALJa3RVelOarl3Vs785lo8C3mVWJhChF2ndunok/7mWFMxYaepw7+niWe7KeyuZ4oEkX5FnRhnbApjkK5X9676mOM98KYZQ0NH1QKf+PLWdC3mNhfbE17qDZH+HlgPTOqMyxi3m1o1nTR9yPDcGvECtKliw6oF3brkcIbCdZLfcKoQpawqieYqaA91BPMIGQpq8sjrUQpEu6AkpUKNKEcNK6mo+4DYtHMkppYhbR8w1hXWTxtnGH7GF6VuzUUsXD/AvAUvdfxb6GF021mRnNqI9+VY6YwIgUQlI5KHtuCZ+UwZV5TAXDBa/I1qcUoSXa8Bonp2QCxQSQWzp1v+H53zKFe570ml/TZalx0EpSk4fdGwVpNyoEyeRwiW+D8Y5m/bXWvJulGHo8ZvjKAjMosXZ0DCKOVVbZVj39foDuVTT99N2LTXGPLRoP6Ro228lixlNR+kq9twKAWF690ryfDTfrpY3hLFAg1TrP5CRyALafDQ1uYWH34A4zCl/usADNdmjDl+lbHLIgMZzhZGWaOpO0UC+MHoVXTy1Gm3YC2oKmgptx3OL/TR34WBJ+S0gnCuGAdQWZc4WnwwSb7W0kqdq5AQkqsnjuSJVeHZ/ZQAR6M9hDCmCbC6yxVhEAiCx3Oygv5lnnEoM0F+
 hKdpD2LP
 6MeZyWpovm1jHqpBPV6Zrm0hetpJ+Fy8/HpxXMto0l2GYlpUde+7pknXtRQOTOPU6943VJsn+hAVk+ok0YSLTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/rmap: make num_children and num_active_vmas update in internally
https://lore.kernel.org/all/20250905132019.18915-1-yajun.deng@linux.dev
* [PATCH] mm/rmap: make num_children and num_active_vmas update in internally

and found the following issue:
WARNING in unlink_anon_vmas

Full report is available here:
https://ci.syzbot.org/series/8f2c8574-826d-4951-a11c-201f9e6fa666

***

WARNING in unlink_anon_vmas

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      b320789d6883cc00ac78ce83bccbfe7ed58afcf0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6702bc54-be0f-4db2-85d2-1488a2ec7040/config

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5260 at mm/rmap.c:444 unlink_anon_vmas+0x63c/0x670
Modules linked in:
CPU: 1 UID: 0 PID: 5260 Comm: mount Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:unlink_anon_vmas+0x63c/0x670
Code: 08 00 48 3b 6c 24 08 74 29 e8 30 7e af ff 49 89 ee e9 d0 fd ff ff e8 23 7e af ff 90 0f 0b 90 e9 4e fe ff ff e8 15 7e af ff 90 <0f> 0b 90 e9 82 fe ff ff e8 07 7e af ff eb 05 e8 00 7e af ff 48 83
RSP: 0018:ffffc90001bef878 EFLAGS: 00010293
RAX: ffffffff82102ffb RBX: ffff888109476118 RCX: ffff8880215d9cc0
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: ffff88810f31e030 R08: ffff88810947611f R09: 1ffff1102128ec23
R10: dffffc0000000000 R11: ffffed102128ec24 R12: ffffffffffffffff
R13: 1ffff110212a6ce2 R14: ffff888109536710 R15: ffff888109476110
FS:  0000000000000000(0000) GS:ffff8881a3c18000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8adf7b0440 CR3: 000000000df36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 free_pgtables+0x72b/0x9c0
 exit_mmap+0x444/0xb50
 __mmput+0x118/0x420
 exit_mm+0x1da/0x2c0
 do_exit+0x648/0x2300
 do_group_exit+0x21c/0x2d0
 __x64_sys_exit_group+0x3f/0x40
 x64_sys_call+0x21f7/0x2200
 do_syscall_64+0xfa/0x3b0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8adf86ea90
Code: Unable to access opcode bytes at 0x7f8adf86ea66.
RSP: 002b:00007fffb8de8148 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f8adf95f860 RCX: 00007f8adf86ea90
RDX: 00000000000000e7 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007f8adf95f860 R08: 00007fffb8de7fc0 R09: 00007fffb8de80a0
R10: 00007fffb8de8000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f8adf963658 R15: 0000000000000001
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

