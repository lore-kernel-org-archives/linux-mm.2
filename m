Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005E7CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 10:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE546B0005; Fri, 22 Aug 2025 06:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5596B0006; Fri, 22 Aug 2025 06:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB346B000C; Fri, 22 Aug 2025 06:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFA36B0005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:09:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0032F1A06F6
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:09:29 +0000 (UTC)
X-FDA: 83803971258.29.34D6BE4
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54860A0010
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:09:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 310GoaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=310GoaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755857368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=VRc3xIFCTnSdLY/FderHjqmKE6fBYoDej+8lK7B2w/Y=;
	b=DeXL6S+WZAN3AprGAx69USf1YSSy7/CeAUBBAGqbaYW8B9ilvBHrkHMr7wSlKbsC69MaZM
	kZffMMJ54lTVpNTz1rhCcXX9bzGbmKYAfA9+2YuY/ZK9psCZ2QWP4EhYzqwueE3dy3bCxE
	MkV2yjwqgZhVfO7ZJguoPblH3Jt0h5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755857368; a=rsa-sha256;
	cv=none;
	b=NcOJoD70vGVUEOVsufsHRZmhaOhb7HjN1ABghntFtLrh8FtJz1i2WKVaXOUmgJz9ZX7nga
	aMm1DAHUgppQFtAXvAteZ5EP4GoGzoZpDe/g172nq3C2GkkIzzoqkzLgSntnAAE7f/wAj1
	lMhHDX4djyYZuuMEsv74ly4ANUy21xk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 310GoaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=310GoaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-88432e140b8so192842539f.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 03:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755857367; x=1756462167;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VRc3xIFCTnSdLY/FderHjqmKE6fBYoDej+8lK7B2w/Y=;
        b=BcH2wehr1drglNMqRfyokUiHQJb5atmd2kGtNdQwVO3cRiaNLcmIsGCF1ytRS54d8O
         bFQmnW8TAmeO9SjqJAZZMfPTvYU+O3+lMb9UZtruC3fJVQHvlY9IGooqPSczlwCd/aJX
         eIWxtp2p9SbVYHY1dbL5NfeGTax9+QsVbEin/pcQ5bgD4f+9dRvkgXmWd/mkSdY7perr
         jJuMRaORauQHkmGwPScSHEGN4Ox3aHay4tbx3ZFsM2KNbbFv6kh7GDe2Ajiv3daB6UY5
         V3CpyFSP08uZg5Ecu2MwC+JEt4cdy0KmJil5MxxXMvBFJFWruMuEUjHgQD97NkhEX9of
         fY+A==
X-Forwarded-Encrypted: i=1; AJvYcCWXpE4E4OXYAznluq+U2BCHJMgGdPnsFUWiuuxJjZhr+r/qdt8Ifal+quwc0vNuRjZWqqwsej8rAw==@kvack.org
X-Gm-Message-State: AOJu0YxJJ/EDDXk/PFX57PsyeWzVdnlMrDfEifc6/cRuITPKJCrL3+k/
	0rZyNqHQMu9BYqqRvRiF2cHIFj4EeUeeIkJMCUEIs/IZ10yMfhvQCmHgQl92SjnKpbk8q5HAt+V
	T7o59wsfEV2ROlid3dS8vKg+gbtYkS7ZVMPJ0n0vOZTKtORAEq85vcYIEvbE=
X-Google-Smtp-Source: AGHT+IEMLm27wvZOVdNUPQaksCYCLLv5JHT+qmWWsl120o7UXyJbn/3MaL4zxA8MZvdeNNKsO1umGhqr7ga7N23ZAe1QhU0QLrqE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c5:b0:3e5:4db8:2f1a with SMTP id
 e9e14a558f8ab-3e921a5cce4mr36780815ab.11.1755857367275; Fri, 22 Aug 2025
 03:09:27 -0700 (PDT)
Date: Fri, 22 Aug 2025 03:09:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a841d7.050a0220.37038e.0051.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] linux-next test error: WARNING in __folio_start_writeback
From: syzbot <syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-next@vger.kernel.org, 
	sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54860A0010
X-Stat-Signature: 4iku9w5nkd68ac6d9fnbz3hrzusnhc9n
X-HE-Tag: 1755857368-706664
X-HE-Meta: U2FsdGVkX1+7K+mCFNLATo9+yL7hdTHPucKk6FTXaP7Bz6sNXfNjv7Mq08Aka+yzEfTzc4CM1OzWzSeeEewKpL2X+FJL9/ACVK/iBW35tHc/lO/h79xNiJuEdJyRqCrURCyzVmPWKw0LYMkCG1JBQ3SUB3ww/lKqWAW7+ZQIEGg6pvjhMIDYD+7u4iAdRyAc5e9/+6PrI/B0yrR/kT5scxT8fQPH6rNhJ09XMMTg+IRffmqMykzv2o+HqOXCQn1h0yGW5u9tonxzzk4HiVQ9cyqmsya2oCx75IFCcAUl5CP9NuNAliF7mKZrIiU0V9In0PA+JbU45Hhch2zT9TnXdUvJdmUvDcxamUTghuPtOlhbglokRwsV2CshuNIM+0Rtvst/mRabrhrutBqh9W/TpQKopPBJuSdSlICvZp4FsnzXLha8oOMWvNUvvOlnupjBFet5nbOYLNiNiSvEvdS0B5BBjRgodHIPbEmklYTxIm1GOfUA7F/OEsPkcm3XtqGxa0CwmiYW+gx2WXUC7SCnYx4p8td/ig5r/x8/rAQ24rayfbd2dLkQaFIBZFQmXUrBLCcNB3J9+62k5vMyNCu82K8UfIQHxuMcztZ+mUEbnijl5pjSySGYWy7waR5LjsCAKAvhYRWx2j4slznmuBNv9/4OlpXynquGBdCgl8jYMm189wtZXrJj6qyKlq2zb4pXeButEccp50h+VRpVxJ4Z0z2lRHPILdKDjsd0aCZ8IWgobCAhcsMUU38gwtHJG2aayZjH6W/TsYro9mPl4vlDNi2to160/dD76iEnb9IVwnc1yxKjSbr1CNgUBHpRO99Zkw8JxJI9qb16jfGQhXkdgydl1jGgMwzDYbUHYyZ4Jdh2conL5EXIY4wqzwSJDULwzAwiEePGbuqsxdP75VCwGH2TukNV+m+vedkHUiI+3sgtcR6NvZBT50xI+/oKaIO5Zf29tcIMEQTvWrTqvWD
 EroLNCDO
 UbDfmzRjn506bw9k3dhNVcxIT4c0e62B5t/UjmrxycvDZ5pVCTHkZ8bBc7MU+HfnHfFvUIsmpc9+4bJ0Vzh7tNpEMQeStgyBKSfjNf/YsAIkodOOovHgVRiWp8Nj88S9UJsWiAuDf63llhq15IWx9QrMRuohPmcwhU5a22F82Do00DItev++A1N1RLjt5c+NMl6HqkJcy87Ts2fBGOEVv/vAKouWcGm/hDVg5fksWLtJDnVANuDT6aWHCssoZHMkO1zvERRLFwKWdssCB/QQXdTcBEUTz1CE+bCFqNcPRlUZQgVGNbJAF6ZRR6SVSLyT3M0OKC8dZlBlByn2iKMvidLxLvEkJ72UeMjbe85qOwBuzzUhw33Q7ryTCTeuULeGkAJeG7PPkaF5EMfGtO3782qj8bbks8UbsbFIU30vLGSK8fNoC+E+YOo04W40EgdkS/BF1C23Cm3BD4ATU+gbJq4Xh0UPZZ21203hhglAXQudAwXe2derB+lI6TH3N3Q6CvbS+tFZil5GNHYgVp938kI2LvBRtMFz6PJN6R45uREpFE0aHWgtWs04BgSjg5MhMvpng6zXj+3veJt40gN83oTzlW9dUXR4caLXIpYsL+FqRYB5ofBhQU01ehbdlcUTCKEkhCB0alz+dPA/S7tgGxcnSx9IUeyoc5gx/p8mrlz95DsSsyxQXEGQI7ZdTrYv7SbiTTwXw9UqgM6AP2jhq8D8rzBzQ0ibbVebVArNw8yLj+OtuLmVNoDJV0I/a5DxKePIZWPTUQttySl7Lo+OITITiP7JwDFBRx1SaO4ZTRLifge2o10aRYp9rN4nLLY64jxxYt1fCsFu0Ww2BceayzomqN7QPMtaZV4SHM2xMNTb/D/R25DYp0+4hnCrfMbGpmVZE1XOomqBFH9zT47OhDly4tl+NFphTxh4Ftkl2McESj+M17YoAZi85a7NG3AYHIvT113S0ZAp79jkMpQdo0GWmiMYe
 r3f+Cosu
 lEegcj1UvZ10UOOZ41AO5z7kibqhdBX41jn2vc1Dk7UGREiCNx7AuYNZNM/0+pMv15WTss4DrNqIrPS5P5S/5/tQA2/wGo18bJIIIBGcjCuUA8xAqqddOUA7gHhm23NelNt1D3nhBF+7JR3HrnKLPu9wnk/qxCYqAYPibgWb9O1QBS4BiaSFUNzWHZjPdS6DYRnR+omkedxsn2+Qu9wlu+BsPpdp/rWYJ162cWNptPqPCVtpO3p1P+rSGSsXsvxlYAH8KzFxsh1/3IbcZOAf+5zaAhF1ovpcRHGcZwzzdgNIEz/ME6lNDUyooP3ZCzYl2z0aUVy1Mz6HF+8yjADn0wvoEWo/Qt8ax30XwKxCaU1S6LoYrktUzgGpVnmfqcQOKypOvwyrR7GzPVUd0xIkEo+/sC2ZtOxPBzl2a4IVeBU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    0f4c93f7eb86 Add linux-next specific files for 20250822
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=172c07bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=21eed27c0deadb92
dashboard link: https://syzkaller.appspot.com/bug?extid=0630e71306742d4b2aea
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/669ede8f5d66/disk-0f4c93f7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/50feda89fe89/vmlinux-0f4c93f7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/317a0d3516fb/bzImage-0f4c93f7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: ./include/linux/backing-dev.h:243 at inode_to_wb include/linux/backing-dev.h:239 [inline], CPU#1: kworker/u8:6/2949
WARNING: ./include/linux/backing-dev.h:243 at __folio_start_writeback+0x9d5/0xb70 mm/page-writeback.c:3027, CPU#1: kworker/u8:6/2949
Modules linked in:
CPU: 1 UID: 0 PID: 2949 Comm: kworker/u8:6 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: writeback wb_workfn (flush-8:0)
RIP: 0010:inode_to_wb include/linux/backing-dev.h:239 [inline]
RIP: 0010:__folio_start_writeback+0x9d5/0xb70 mm/page-writeback.c:3027
Code: 28 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 ce a2 29 00 49 8b 07 25 ff 3f 00 00 e9 1b fa ff ff e8 7c 04 c6 ff 90 <0f> 0b 90 e9 d6 fb ff ff e8 6e 04 c6 ff 48 c7 c7 a0 f8 5f 8e 4c 89
RSP: 0018:ffffc9000bb06ea0 EFLAGS: 00010293
RAX: ffffffff81fad344 RBX: ffffea00050de8c0 RCX: ffff88802ee29e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000bb07010 R08: ffffc9000bb06f97 R09: 0000000000000000
R10: ffffc9000bb06f80 R11: fffff52001760df3 R12: ffffea00050de8c8
R13: 0000000000000000 R14: ffff888023060880 R15: ffff888023060660
FS:  0000000000000000(0000) GS:ffff8881258c3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7354907000 CR3: 000000000e338000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __block_write_full_folio+0x75f/0xe10 fs/buffer.c:1928
 blkdev_writepages+0xd1/0x170 block/fops.c:484
 do_writepages+0x32e/0x550 mm/page-writeback.c:2604
 __writeback_single_inode+0x145/0xff0 fs/fs-writeback.c:1680
 writeback_sb_inodes+0x6c7/0x1010 fs/fs-writeback.c:1976
 __writeback_inodes_wb+0x111/0x240 fs/fs-writeback.c:2047
 wb_writeback+0x44f/0xaf0 fs/fs-writeback.c:2158
 wb_check_old_data_flush fs/fs-writeback.c:2262 [inline]
 wb_do_writeback fs/fs-writeback.c:2315 [inline]
 wb_workfn+0xaef/0xef0 fs/fs-writeback.c:2343
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x47c/0x820 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

