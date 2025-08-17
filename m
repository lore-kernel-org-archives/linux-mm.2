Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE8CCA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 08:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B191C8E003A; Sun, 17 Aug 2025 04:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA5D8E0035; Sun, 17 Aug 2025 04:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07268E003A; Sun, 17 Aug 2025 04:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8949E8E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:34:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ADEC1DDBA4
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:34:47 +0000 (UTC)
X-FDA: 83785588614.26.A17980B
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0DD8C000D
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:34:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3JJShaAkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3JJShaAkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755419685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=/XbfEN1k/gSsBEABxdcrTawukqj9qiBDPSr2V37dmic=;
	b=IBqGIdCGl1NurguRo8H02BrjK8xraJP9+ycqqqePyHhuzdwrvj7fSqLzp9WWWUnuk/RT/c
	nRSMAbgJTNKsAQEpVK38rsmRtjU7J4jtNAbjsxkw8k+w3SHn6cggoixPDjr3e4cGtPg2oZ
	+aX/PyZXRoXsxYUrmtL9PWh2ZiHXxSk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3JJShaAkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3JJShaAkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755419685; a=rsa-sha256;
	cv=none;
	b=rREkgD//jHSLIenX+TPeW0+WH+kpKNHVhVhr20BEzjKRq2mm+A0Zo8cv6yjRTq4KTzhBKS
	4Jfvi3Y8rNmaC5oLe8YHb7RQPF0rJgdMfHszTeGlVVX55fWgIpNa3lBOaEN4NcRz/XiuN+
	3N2UHSEkznqfYGQLsSBrDnYqg/xlxSE=
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-88432cc8949so346127239f.0
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755419685; x=1756024485;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/XbfEN1k/gSsBEABxdcrTawukqj9qiBDPSr2V37dmic=;
        b=XvyXIoG7nnBZqcrIxQt1QasPG7oe7KyWq9otyKlBbRVQDNCJweVfaGwCTtHQNLM2Of
         InImB2KQjUlSUto3EvSr54fknIHqTT/jKqNyJ4VQ4thr8Qw7wnmB2pRLdjxXx01foB5V
         dgLmXyaN+m/IdPyCIvrUu0oSIBDcGgAfK3d0tudc13Akf44F2dAzTW+ZuqhkHMmpiXgn
         FAr5q++PtKowuWj2Sdkm/TlabDLmwM8AehKSBShlMDs9ZFLWLXCPTj2Zo9edoilSLDxi
         kmNK06KMZ1sPrcK90sspla/F3fl1NeAhKB5RRRcuBfkAb6UqUPeKyYiV32eXCAJMZoTr
         C9NA==
X-Forwarded-Encrypted: i=1; AJvYcCXiwjuec6mMhnn9AG6bpWct9l8PcPXFnT6vR7SESdJ1mZXX0zvqIi09/v3RhIYqOpcG0JrvIuMi1w==@kvack.org
X-Gm-Message-State: AOJu0YweSADA3BFFRNSZt3cj35YEIZLjR21mCd4cmKK1vnWQLBwUAULV
	gBnuL5FBU4nkgCGA+WhPFIlEK3MD4GwljcWBt15GS2BMLgWX/rgXdHxr8IgTiF+l/GGqq2zYLEE
	IzGfEQelhazufuDUvegVA+upg5PE+W0Sy1/FJrwd60AnR9Tlwec6BtBqfeHc=
X-Google-Smtp-Source: AGHT+IGiWqrm1nJEcVFM1ZVWdN0l9BXcpBE0JAq4jPEYdSb0wjl90ebdKLrv0nt+wJuydm1ouwQt+qpV+rodHXLfAEpOXkVHEmO3
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1545:b0:3e5:66a6:a46a with SMTP id
 e9e14a558f8ab-3e57e9c4a5emr131036615ab.17.1755419684780; Sun, 17 Aug 2025
 01:34:44 -0700 (PDT)
Date: Sun, 17 Aug 2025 01:34:44 -0700
In-Reply-To: <cover.1755300815.git.boris@bur.io>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a19424.050a0220.e29e5.0065.GAE@google.com>
Subject: [syzbot ci] Re: introduce uncharged file mapped folios
From: syzbot ci <syzbot+ciacf14517a343602e@syzkaller.appspotmail.com>
To: boris@bur.io, kernel-team@fb.com, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, shakeel.butt@linux.dev, 
	willy@infradead.org, wqu@suse.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B0DD8C000D
X-Rspam-User: 
X-Stat-Signature: kwew9no18z3mco91ij1qae4coiqmnab1
X-Rspamd-Server: rspam09
X-HE-Tag: 1755419685-282072
X-HE-Meta: U2FsdGVkX1/vCbahEuGwha52Vfah1K7Jbt9q+HNNfXbKDjsJBEiy3ZS9jHEIkFSa0TmPqyyZO05i8+0VV+QufRUqAywK0qUy9vSmn7bWvtyQBJ8zwDExC27NpuSkwbd8IYYccI1OmeFj0r4me24aDqoFiNNorjacgBknYzLe+UnxYv5FHBpQxVsehpxFzwfr7Stec3UH8tyCKR3IHecEsYKDkjayeCY2Z3FMB8PThDXR2asx1vlSoBl0nQswnkN3Iq8GG5Y+aAAIGfLouSHVYN8/P04OXH3LHyhcVzGw1o3ZChD7BzMuJ9Ln7awGxyVsqrbjc/yJ2oiMNoCmEpZt20Ldx8j2WQaOyLJBfrPMoIeOUJ/C8tQRo3nxc2k4K5Ht+cqGzWX3eRT0BIEffsOwHoMKh/sFCWuVCQI05QNRW7xe/+apXbVHdCK3ZIqXvUEO9eraaDoqeEX3vCRqPyONLjjixyKRsnLPRLH2MyeI00BgCEsDOQbKdaGyMwnyK4hlR5ivm8e3613GhoZmKNRbnTMnEeZqg8mF7/7ReBPWfO69RhgXXxFgmFM9VQEkeWNwTTKgVANsebt7ycmjSSDlOSJzvJq4Ij6H9GBB7aWj/6gNcvPo8G3HYjZ6IxmX+nlSnaNLyJJW/7B9WtiYuPxGNFmcUIrbt7aOWziUGEQ0px4KuTqCrSucF9Nw3WDYVkUwP3rpgw7c9SFw7Tl6daaLe427OiDNTdbqlnlnZ/XqnhyxICmKqJ+MZx0+XpsuPHbHx+rhi4LwOV5byhHAKmesxFOzXWZ8vmTnI0+NGolB+AG9iJgWBN4Ybcd4jLJVKMPdlUDWyWDx/lMgVyLwEyiLz0pTBrlvLKFW5b5ff/kT5RSnYyIlBPXDsdoG/dYqL3R8x9RmAYLm0Oys/SqbiFNDf724C5GWXzreabcGp4qs2abRIsk3ri6NeP36z5ppzSff3V0cso+ogZ4mRQK9cAG
 7ffrioZF
 hWnNaj1TG0kT3bIHgWDI2bhTG7lXoNTRduXBkq/tMIl3R6xuOXJDIEVmLp8XkUjN5zTUy4FNNH/nwU9oeOHiuH0QW0oRsD+7e62VJi3Fsa81csWRrKoroKwln85oYW9Qq29mQeQuAuCJmSU8z6RWAvmeZz+qqwRi+xWyjV7/8UOPOHUFaqVycJ4S9G8Joojx8+kooluPHVfwAe6iKS04F1n63jH7I3GMoFOwyeLe2LTNIF6SNn36H81mX15MbypkevaJKWE8hBm6cSJd+eq8uroCEm96Aflhl8h1dHaEx3d8YPi82xbVSbD7uGEAjow/a2xSCQBOTGCrYcMgmds2s1Nns3PXZ3VLXlf6+w+zmBQbFKwaYnGGyew8FXh7rBQuKj/6P9FOUcEeVJFUXCeGwRryxxoct4ZT/EXRvH1mrRUph1yKamxhBYkKCDQoUWB9oPgJc5cYCzF+c4PNr+rJRruGDQS6yocimozIgGlx1sX2g/9rJQqpv4nhYczq2nlmiMxBuh3G15e+VwPTT2zvdJr3HOEn2/SAzvzuwbQ1Eg0RdNbaTKGnNy4RDfkbbS3gO4U6FNhxvGCNddAZBc3ZFV6POy8R9/Up/ksi1SetPrZ67n9c/MLjCv72cvW9JRuAHoda2033Dr8kHcVS0TRo8Y8+q7wFlziUQEI0seYKSD/ZuXm38p9pG9LKPzAWLTJimC1A8SFOh5BzLMZL0PazRKyJObmlhAuT62HSDvpZScziePpvStLcxOBpD98xC7oPxI700D6LaI5zY55ZJlPisC5wzvIMzeVe5zGk/3lLOJXQB8iRKqhSU/c8SJGIz2TGg9fIsLvuroMuQjosfFr2Y6/TF6XMMaNZhkCdOPoSwa4F11R7Gwl1hAHdE+pL21Sng0HoMeVOsCKrrxEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] introduce uncharged file mapped folios
https://lore.kernel.org/all/cover.1755300815.git.boris@bur.io
* [PATCH v2 1/3] mm/filemap: add AS_UNCHARGED
* [PATCH v2 2/3] mm: add vmstat for cgroup uncharged pages
* [PATCH v2 3/3] btrfs: set AS_UNCHARGED on the btree_inode

and found the following issue:
WARNING in folio_lruvec_lock_irqsave

Full report is available here:
https://ci.syzbot.org/series/15fd2538-1138-43c0-b4d6-6d7f53b0be69

***

WARNING in folio_lruvec_lock_irqsave

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/5b3f7bc8-d0c2-4985-8ae6-d51ea4e2baed/config
C repro:   https://ci.syzbot.org/findings/f02552bd-e7e6-4c3f-8cc3-04a5a946771d/c_repro
syz repro: https://ci.syzbot.org/findings/f02552bd-e7e6-4c3f-8cc3-04a5a946771d/syz_repro

 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5951 at ./include/linux/memcontrol.h:734 folio_lruvec include/linux/memcontrol.h:734 [inline]
WARNING: CPU: 0 PID: 5951 at ./include/linux/memcontrol.h:734 folio_lruvec_lock_irqsave+0x184/0x1d0 mm/memcontrol.c:1252
Modules linked in:
CPU: 0 UID: 0 PID: 5951 Comm: syz-executor Not tainted 6.17.0-rc1-syzkaller-00036-gdfc0f6373094-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:folio_lruvec include/linux/memcontrol.h:734 [inline]
RIP: 0010:folio_lruvec_lock_irqsave+0x184/0x1d0 mm/memcontrol.c:1252
Code: 74 0c 4c 89 f7 e8 cc 53 f8 ff 48 8b 04 24 49 89 06 eb a0 48 89 df 48 c7 c6 60 4e 98 8b e8 a4 36 fd fe c6 05 52 a1 62 0d 01 90 <0f> 0b 90 e9 a5 fe ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 22
RSP: 0018:ffffc9000359f540 EFLAGS: 00010246
RAX: f0f9782cf8520600 RBX: ffffea0000807140 RCX: f0f9782cf8520600
RDX: 0000000000000002 RSI: ffffffff8dba6067 RDI: ffff888020a73980
RBP: ffffc9000359f5e0 R08: ffff88804b024253 R09: 1ffff1100960484a
R10: dffffc0000000000 R11: ffffed100960484b R12: ffff88804b032fe8
R13: ffff88801ba80918 R14: ffff888106950000 R15: 0000000000000000
FS:  0000555587fa3500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00003e720 CR3: 0000000029a9c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 folio_lruvec_relock_irqsave include/linux/memcontrol.h:1544 [inline]
 folio_batch_move_lru+0x20a/0x3a0 mm/swap.c:167
 lru_add_drain_cpu+0x119/0x880 mm/swap.c:647
 lru_add_drain+0x122/0x3e0 mm/swap.c:735
 __folio_batch_release+0x48/0x90 mm/swap.c:1054
 folio_batch_release include/linux/pagevec.h:101 [inline]
 invalidate_inode_pages2_range+0x889/0xa80 mm/truncate.c:707
 close_ctree+0x6ff/0x1380 fs/btrfs/disk-io.c:4408
 generic_shutdown_super+0x135/0x2c0 fs/super.c:643
 kill_anon_super+0x3b/0x70 fs/super.c:1282
 btrfs_kill_super+0x41/0x50 fs/btrfs/super.c:2114
 deactivate_locked_super+0xbc/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1378
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a78b8ff17
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe33fe80a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f4a78c11c05 RCX: 00007f4a78b8ff17
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe33fe8160
RBP: 00007ffe33fe8160 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffe33fe91f0
R13: 00007f4a78c11c05 R14: 000000000000f471 R15: 00007ffe33fe9230
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

