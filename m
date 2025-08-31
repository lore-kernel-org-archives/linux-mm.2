Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17DA4CA0FFE
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 01:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB968E0002; Sat, 30 Aug 2025 21:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3618E0001; Sat, 30 Aug 2025 21:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E00B8E0002; Sat, 30 Aug 2025 21:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C19B8E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 21:38:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBABD1402F8
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:38:35 +0000 (UTC)
X-FDA: 83835342990.15.92BC299
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf21.hostedemail.com (Postfix) with ESMTP id 27D341C0002
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:38:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3maezaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3maezaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756604314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=kXqKf1TodalArSEy9nNNji7pCJZUrhjs0Hbrg+c0Ztw=;
	b=uRK23KWJUoyYpTLNsGz7bWYV0FOBTNerBL45Anrjvbtg38Gb3tQi0kMAt4rVwWXiaR6W9y
	Dnpxu3b0zT5hQXzN1aZSHRgIRafz2JYmms5j5mSCvRKNGxwK2ssHndfMBV8AEhje8wwUI4
	9viyIbIfXlqoRKzZNuxZOLG15T/7aw8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3maezaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3maezaAkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756604314; a=rsa-sha256;
	cv=none;
	b=avitetvrF4Jsxm4aYyh08QzpogsalFH3DegSWG+unffSXkSJWZ0hb52jmFmIXe6c//h0uf
	UL76HZM1N6QXNP01iXwsuK9Pn0b/57t5pf8O7loztbl8oTDQPHnJU/1aHGBJtjule29wy6
	CA2e+gNlu3O+HxiayRP2lbWvEiXBsNY=
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-8870219dce3so317666939f.0
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 18:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756604313; x=1757209113;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kXqKf1TodalArSEy9nNNji7pCJZUrhjs0Hbrg+c0Ztw=;
        b=MniHRBsqr+2F6eTYBvQKQI6X8A0g2IDDUDRyUok77HBGDHswA3f7aVlbnLSop9yLLE
         TFry/H5x9IWqpb1Yo3iVaH2d4yvCvAmCzPl4aBCHVikF63UxJsQg+GiYexHHdr2ULdRx
         Hmx+P0as+uKaBpyQ+PuGs34Td6RiGpiRH2Ilr8GeXtYnx+4CqZ5I7CFjG8tc4MVG7aP3
         rCxcONPNBmAvayvrYJ0qI22x9oCw3WEGIeFibuUZ+gdVOueueWyn/xlIDi8HFV4qByxD
         rz6Zn+S6F+AL2NFw+dLX+3kdOzJP2jjaCqNCvlQOCn0G4JrXfOxNTkuDYgSFDiLhxwdY
         0Kog==
X-Forwarded-Encrypted: i=1; AJvYcCWYNcRXmM+1K8GSL+jF4dSvggXwWREBzfQynNn/Sm5kYrCLRuFN17qloJPM/hYVGJn/8GPZNfgbJg==@kvack.org
X-Gm-Message-State: AOJu0YzKlp7Kpmcpn3/APcCzv6WMulpGOu9k8W7k/G5/+SeCHVjzntQb
	PuPY76UaTLEczl1gbbkxftM92zsIQcq85+LWW+mX9uCrmM/FEY1GB8zdXmLwUkV3FvVbbJIxX0R
	WbikdbA7krBLoXpWnCuBch3vcW7QstNKrtgvJCQVoYSM2/mDWCUVC9B84Hc0=
X-Google-Smtp-Source: AGHT+IHkVUDaiB0B/+kPsj41ewvQD1QXEUiG86vYShQceSKNjVoO+xB73ABpgh/j5KKO4yQ07Oi4JvYnMu3zIys4Jc0vdX61tmGS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c81:b0:3ec:d2db:9381 with SMTP id
 e9e14a558f8ab-3f4006752b6mr85022255ab.11.1756604313183; Sat, 30 Aug 2025
 18:38:33 -0700 (PDT)
Date: Sat, 30 Aug 2025 18:38:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b3a799.a00a0220.1337b0.0029.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in new_slab (2)
From: syzbot <syzbot+2f3c8569e4b7486452ae@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8p44rw81bzahoc8yujdu9xfs56ft7rf8
X-Rspam-User: 
X-Rspamd-Queue-Id: 27D341C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756604313-845997
X-HE-Meta: U2FsdGVkX1+D6nmImx9K+7+NaQIgZGT0MRedEZ/7zG6CQ7qaHza+5rOCmUZ4jt61QUj5rnR9JAM8XLb6mzHiIPf+3lDVuB0IiRJVQpj0Hhb8SIbnngfjWaOwC0DWIqeYF7qFUNl5QoQ37B7GHmCCc3rew4XhZvvFALPKEr8iHAfbZKEjUTXt+VaIJ6jszvlOXefilLg3V7lThkTxTlvnznAsbIV/6xsWfF8cMbRDwlsaN/Q6WjegSq+eEFJ7HnxfTWvyaThvPV+8dbboV2pzexoKjkUu6Mvu7/LxzXj45W8B8v04xWd4dlKxX00AaTJjHOoRCtstcbAR/iFVAvhSP/YzR71P0rJUdrHMyRf19MvJ2TXoVjeia4dyoMndiEd9DTIiUrJoNjxiv6/21e6WPDuJFYMD/sBh3AHvyTmV7Rf29JPC5AeupIDHjJprisa/KpTCEso1KneaJIA8jDA0yYqUetuLCTZO4NqnhL8pr6V5ayoFmhAzTy+NyK2SHU9323oabRWgn7lAKdz7s78k0oIX6R9dHkozmW7yMLglcX8z6K+xGBFlmZmoW2XveAT4A2ISyPN4ZNAW5gBO03YP/OrUljBc4BU/2xow1xlYglReKq5OAy+cKrqbwxKFE5N0GMDf5ADWMufYqq5QLxn83efxDiyPFGFqqzNdgd0gHqeC6veP5EY0EB2RXOV5O0cALI33UzXIFlWOc4IYRZfI+A/LZgn0bGzgn+n5BAPHmzEcCnWAoxAo2f2yTevBoyB8S4kVKtD23cfAsNVlNaievtDNylfT2tcqctieUmfWJQuGiFGEaK2i8Nzu2Rt9M9nmLP85NklEk/DubGx5eAujuRo5gpUPg4TmTAZgOVFOxFtt9kNZDMJiXW9tVM3runJjEYrsx6+1NHXSI6G41LCgKZJV0uz0bpbCSlmzpOQkw6Vu/I+qLXSKj8bNRMJTS/QNT7SqYZckeJUCShn08v1
 bNc0ya30
 7cYvdVxiy+Ge81gCOf0xLxzj48WAq+1GbxDAkCsVQFaDJCxt+ly1eg3+Yrvel9QIdMmcKexRpsEDVhe7NO5qLYjjOmf6D1oLTSIt1bGSHATAX2nTibOrCcxrbNh3xAxr4e9ntHswQKQS5PtNQbz0CLUK3e2kdHKS0x5/6wPTQuNVrsiKTa03uvGNg1mhVfbzmaqIWecqN3y3PD0SVRc1Bk1MEDQsTtyDr/b9gdzwE+dCjAN0zCsvxLDvmeQiSeDoRsku8EJJ2SWys1oJHt7bEcNWVSu16xFZt7ka2cJIoCODQmxLpkIv1mHlroq1p9uPhpSc5MEU65jE1UQ5lqmUzNxuFwrHrIsSp/3yQZb0TYhYYIg44L6CzUna47MIo/pKZuvxIL2PccfsWhok+GEl+n4kkO0d2NJ0WXKXdWWATS8FXBVCnBrCQx41lmwUBG58A0D79Na/nB370jxWoAu8I1wa1zNkw3/KZWfl6x23RSRZg2MYqaEePWZ5eP3EmhGTi0gt+/vN8x9J1eYAmVdToyFAMI1fZUDVxt0+SLk3hLYvel7/toVnU3iYrzUFKBQPPWrkuTBXgwowYJy5guP6qGojt+sVFwNT3UOz6TqwDamKAOE9oDjRQ+L+Y1p24/NwAIm/JqOfr5aInSzCi3aReOLOq/P3ILk9bZztMuLSIyxiHU6WcDmjELT6HC1GtESzwZAkO7DwCSWSXr49IJeb91ej187dLzElkE2VCtKxbP7/KB2wTEw5ozXNC2to9h6DqxL7xJJU4eOoqMDtqiQIh7CIJPSXNVqoDjEXE109uYTSafL2irnikhfJ73A10onMuVPOvqJOTOYOIax52DLSuqa739M1f+oxMIUTNxAE/Achno7tZYJ0N4bjdUp56cL6vQxjTUjhRHDPKGD/hVCxHbVREH3qQGm3xAxLnV7NODrLsISDBLvEce6aKu0LjWUMB1BWl36iPYRx2+ZX4WQn7nbgJcVwY
 hsXz3Pgp
 awsdn/zte5jN/A2NJRCSaYZNSf7gqpjFqNx7JM8+XiW8SilSJX7Ap/Gip2x5gHMmLpQ2c+74X8rzf4/1zXOmbma47D0RB4uKlUlNYRKQxXflXML4T40s+mL59BcXluqF3kMY2isN0WP1m+5HkWtoCwCNvJvdvOapgVlf9vp6bMEycR4ebJsJzXOf/gZqTTwPGypvHdPrA7V/UDyiTJZYh21QYNEely7IzDA6Xn+FIplHFPFWaH8I0y+R3E9jBs69dS+6IVtXpmlSzrpq4WUEUfSBKOFz5ghTfWmT3B4Fc6de2P9tj48ry43mBLJs34+XFm0qGLnKzSxJuBCvqI9j4Qk3+b6FNiiMJJ16wYduqzGdRwbswvgz2/zwFXxbI4yzRKuwqW/9HOX+ewsNjtzsEP5kHrQ5ImvKBL8HbyC6LpK64c5suygzrbvOiWa+KJz+vpQOH4FpmhVnI0IlGu2aLerASGWSCto8dRk+sJc9zIuUsRUapI/a+SNzbpa5OqCl85NwxCVt35cuLFmXJ5ivjFPtrMSKm8sc5b7qemz0MzMManWRLgRvweVHEdhPUcDGUBsW+G7Um4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    fab1beda7597 Merge tag 'devicetree-fixes-for-6.17-1' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ad77bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fecbb496f75d3d61
dashboard link: https://syzkaller.appspot.com/bug?extid=2f3c8569e4b7486452ae
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-fab1beda.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/813fdba24db0/vmlinux-fab1beda.xz
kernel image: https://storage.googleapis.com/syzbot-assets/12a740d2c9a6/bzImage-fab1beda.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f3c8569e4b7486452ae@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 10417 at mm/page_alloc.c:4619 __alloc_pages_slowpath mm/page_alloc.c:4619 [inline]
WARNING: CPU: 1 PID: 10417 at mm/page_alloc.c:4619 __alloc_frozen_pages_noprof+0x1f21/0x23f0 mm/page_alloc.c:5161
Modules linked in:
CPU: 1 UID: 0 PID: 10417 Comm: syz.1.1147 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__alloc_pages_slowpath mm/page_alloc.c:4619 [inline]
RIP: 0010:__alloc_frozen_pages_noprof+0x1f21/0x23f0 mm/page_alloc.c:5161
Code: 90 0f 0b 90 e9 0d f9 ff ff e8 bb d6 0c 00 e9 43 f1 ff ff 4c 89 ff e8 ae d6 0c 00 e9 1e f1 ff ff 90 0f 0b 90 e9 3b fb ff ff 90 <0f> 0b 90 e9 24 fb ff ff 89 b4 24 90 00 00 00 48 89 54 24 50 e8 56
RSP: 0018:ffffc90003a477f8 EFLAGS: 00010202
RAX: 0000000000008000 RBX: 0000000000000000 RCX: ffffc90003a4792c
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88803fffd9b8
RBP: 0000000000048cc0 R08: 0000000000004f8b R09: 00000000000043f1
R10: 0000000000000000 R11: ffffc90003a47920 R12: ffff88803fffbb80
R13: 1ffff92000748f14 R14: 0000000000000000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880975c3000(0063) knlGS:00000000f5484b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000326f2ffc CR3: 0000000070630000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab mm/slub.c:2663 [inline]
 new_slab+0x265/0x330 mm/slub.c:2709
 ___slab_alloc+0xcf2/0x1740 mm/slub.c:3891
 __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3981
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 __kmalloc_cache_noprof+0xfb/0x3e0 mm/slub.c:4391
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 xfs_init_fs_context+0x45/0x5e0 fs/xfs/xfs_super.c:2278
 alloc_fs_context+0x54d/0x9c0 fs/fs_context.c:318
 do_new_mount fs/namespace.c:3787 [inline]
 path_mount+0xbdd/0x2000 fs/namespace.c:4123
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount fs/namespace.c:4324 [inline]
 __ia32_sys_mount+0x28b/0x310 fs/namespace.c:4324
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0x7c/0x3a0 arch/x86/entry/syscall_32.c:306
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/syscall_32.c:331
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7fa4579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f548455c EFLAGS: 00000296 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 0000000080000140 RCX: 0000000080000040
RDX: 0000000080000080 RSI: 0000000002208004 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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

