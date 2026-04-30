Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414E6FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C1B6B0088; Thu, 30 Apr 2026 03:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473986B008A; Thu, 30 Apr 2026 03:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B15C6B008C; Thu, 30 Apr 2026 03:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7376B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:55:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BE03C1E84
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:55:53 +0000 (UTC)
X-FDA: 84714463386.17.72F99A7
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id BD3DF16000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:55:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 3BgvzaQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3BgvzaQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777535751; a=rsa-sha256;
	cv=none;
	b=5bke3YPRtQF77QWN/UA7XV0CE4TSKFr1CS9kWgvGI26lgjdR1ZZnNkyKL+slQ8J4R05jPT
	sCU1AHy50lp6hx6fEXlxR1Z8wFcJgShazMz7Xn11VyvIv/y0S82VUXIYp4wVlbiJRoH4Jq
	yoCEYHV93ipDbiH8QUmXOb0Hp2WGCWc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 3BgvzaQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3BgvzaQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777535751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=rLjgKgMg3ZT7/gsCoAKf49qKRpiAqsFVHxvm1NfU+9U=;
	b=EmTH6dulZYeGrIUw9qklcqKQDSwgc0hpGKp1EOLlu+QH8U4muBuYhN7ps6V51rb/RgaX0Y
	9OdIc81XOVPL7ddakY67cEjL503RUeJBJeuCLoqlMxrrfZiQb8NUGYcxgB79lLuotnPAFY
	eT7rPTvpjnUYwbfyMIdjsDieo0PnBJs=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-46335278e7bso2580545b6e.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777535751; x=1778140551;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rLjgKgMg3ZT7/gsCoAKf49qKRpiAqsFVHxvm1NfU+9U=;
        b=iYm78NvD7aTN1EZj10QQp0Zeuet639kHroTpxHjmoZjSi/HfrGXE7pIOxcxyN/OH5U
         PoFuOmHhhYF2RjCQTnxJEVNfa5A/kbgYF0pxXjqFUaihyA4g3svyNjMyJsBqTcMWuTD1
         5s0pg3XJiLOHw/zOKNtGVN8PGvk4ycu/9gSW41l8R6EFUrFKccu2+ulLKpPbRxoWbXhH
         ZYBYhROkAhXhzsPcktBcRYlwSOuuSd+PmK6MneHA8nFfYDjAnCYOy5eZ2v6hG6D7YK0N
         5zff72G09c/dAazF4XMTfE7hPN5pUDbseOkhY4G8QOXoK0Hg+AngSvh3353NxLIITEzN
         z7Pg==
X-Forwarded-Encrypted: i=1; AFNElJ9SXeBmeP+ofAzdctclzM2uWLbtu9kFMB6fO/7hi8jGJCsvOV4EdlLHhAmN21HVj9BLefAitQ7Fbw==@kvack.org
X-Gm-Message-State: AOJu0YxMC+u7TiJgrMVT9rUEG8syWOw7uoyCpjh7bFxzjg+HbJsUbOQt
	szzdJEDvMM+AxkQyldsIxrR86IUHsI0+NmSwnsg7Mepa78JdwzSDN4ZLTUARfY/9wefNG7s4F2f
	sE4t43sFVVcYS1nuSOfxLvp5RkkYxjCG+m9DPUKTQnlMFWHcb6tsjAg8WtKU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2f08:b0:696:2b58:4ac0 with SMTP id
 006d021491bc7-6967bdc8fe6mr352233eaf.35.1777535750742; Thu, 30 Apr 2026
 00:55:50 -0700 (PDT)
Date: Thu, 30 Apr 2026 00:55:50 -0700
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f30b06.170a0220.3c4978.0018.GAE@google.com>
Subject: [syzbot ci] Re: mm: Make per-VMA locks available in all builds
From: syzbot ci <syzbot+ci0a2fe26d19deda39@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: iyh5dprwot3cejdesknk5jswc1jtwxe6
X-Rspam-User: 
X-Rspamd-Queue-Id: BD3DF16000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1777535751-169638
X-HE-Meta: U2FsdGVkX1+1jrE535Yq5O0YjhTNz+JWx6KKG1ol3DV0/vsBGypWJ+U53IDIM7MFCj0INahzRSYwUBfM2GMhAaNxTItoMOBAI9w3BZtIOInSnB/98oqTjDRWpj5EgZwd/zzVxsscnvMI5EjzYHPd96iq08VuRvVcqBnXpM0v/twdqJ2vg6tZ2XffvCHpVqy1djKm/8y8eX1sLDM6yfAj6KSJEw0c++CyuesbtS6ZYGgua7mf/1224ZHmROUbcnVHR0yGIJZGMbE+/zxcVXOK/8bmN7UYFWdzT26uGf9MFZWiyy9vmyTH3NtlNl5NH+sePadIs1nwbaLHUvSdDk45T7nkMCJtyhbTiRSEqWnIAAX+REtUuqbFtRWdoys8u02c60FMgxYuKDQrNWmKCgBBC0LfPvqUomQqYs73hCtiRgYeFYr1ByfbelHkp7OEDAy43n0RQY4+BKILJHKZryATmyv0MUr6xRZfOIfg53rNiMOmyMWhpLLQotLYqeZAq4IQ46Hff/kEYcGno58vMPUi7kq0osOp1Y1Yui1SIjZJd/Te7MfpkR3RQKD5Qm5v2qsoDxT4FBXQdzN+bELFPrQ87tMDmYZsKiktI7RplVvjC+InrFMGzDoRx1o7CCBK2CWJxlgcbiOFigmHderjYpQTsNwrCrylEKLeCAvmeEBE5ECz8GqYtRyMc+uRJnrM3C5Zb6RzrwEA2HpcK8Y85Cd1x+LiDDyEnPT5dY+KJMUVK0nsa4AfvrKvmzqiXLwmD5twhm/YBLfE7OzXDRpQRGgoiBzsWus3yY7c+4Vj8Ja5RQgJ2Ejf0k292DIccfHUixobHYpRlRhacUHQmk3yfsG4M24LfG5PUZsZYriBI9AD620lI2MuapV9LquQViy/pc4Ak0IHFnuI6M99Q60p1LOWozCUaDeT0ZLeJrGYC2vxIrjbdmz3mKMLpACtWI5ufK0/AS0GW2zvaENWz4Oh15m
 eH6vIOo2
 JzDQ0nw+NCe3OWkDlBAsnnql5S6455I17FWRB8HcVy9SQ9ulOfkw4qyrpweUYrM0//6iRTT8K+KMTNUMW45wUyFafr5FF3Y49osYFZAun6M20uHg9vK0NhvHIx24rXhK2HC9eZkHD0YcrXMfvI9cOvEUosdBgwQfwQ6hRqX1UKyZX9oTexeItHq7J8/4a7LFY1vIIhE5QjWNLhuDp6xjkZCjoG9u1Y1ejpRpRH1BJDLNrhAhdFaIrfRbScaYm3lKE7knts2RcD7rtrf9s/jOsFtct1WprTo8K6H4YAykqeD5YBS7ORdiVlC9MXv01OWRLaqw11um7QKKRJ/oI94oR5n8ybX+oe4kSqYGX5L1M1LFJqxbSoozOjZ0c7eDda7NyAWGN9LcbakDfeLsEk6c7lgERxVlIkJUhpc744jkwMn2KHq1QtmA6g319m2/13ITp/t0yWGxKQgJ+7gHjiCibeIsOQpeHSBg+wKZeeQfshTC8z24UMBo22UncukAewR9+O3qdaLtdAUAE4UM5UaUnv87WTzsmqXfsrqihkZ5oIZjj13BY7AohXDJpzJy+RFtu213rn6n2XYkHRUK8oxlgLfFlyTzANbs9OducHdyhzlIB0MU1hLrq8BqyQZvN1T9h83aJfIwg28ey3OKA4/jkRwFa7S78uTVeYJ97xHNLiCyhvHYs5d87hf2Vh3AnmT+xsYoBB7ZRygUtpnfkfdt3ahwntCYU7HvLkBqb40PvsL6TMw2duPJzSbGXSflD0rpYTv6m3EUCDW1M4JDL1eII1Bt19mWmw25GC8f887YBblgRMfX1sUuUeWNgpozRq/HPNxlwljH/pd7hBrsZCfk1guzHTUOXiNf5R6CRxL+Au+5R7gWOtVzY63pB26BdzCRRFlziWGuKCjuANjTNTrPuwZ87pErEDuoZLSCOeC9F1Z6RLsWkFlpI5syyh5C/3Kh6gF9Pz0Ign3MYJt976mIIbkthXcXC
 7ZKJlDCy
 +evuCLY9/YIfEX7BZ175vGZCxQ3Js0Kl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: Make per-VMA locks available in all builds
https://lore.kernel.org/all/20260429181954.F50224AE@davehans-spike.ostc.intel.com
* [PATCH 1/6] mm: Make per-VMA locks available universally
* [PATCH 2/6] binder: Make shrinker rely solely on per-VMA lock
* [PATCH 3/6] mm: Add RCU-based VMA lookup that waits for writers
* [PATCH 4/6] binder: Remove mmap_lock fallback
* [PATCH 5/6] tcp: Remove mmap_lock fallback path
* [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast path

and found the following issue:
WARNING in mbind_range

Full report is available here:
https://ci.syzbot.org/series/374f338e-4b3b-4645-871c-78964f944bbd

***

WARNING in mbind_range

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      57b8e2d666a31fa201432d58f5fe3469a0dd83ba
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/786ac31f-0f5e-4ceb-88c7-45f4bee79d60/config
syz repro: https://ci.syzbot.org/findings/4b270176-3e48-4ac7-8ddb-f326d6883d93/syz_repro

pgoff 200000000 file 0000000000000000 private_data 0000000000000000
flags: 0x8100077(read|write|exec|mayread|maywrite|mayexec|account|softdirty)
------------[ cut here ]------------
1
WARNING: ./include/linux/mmap_lock.h:332 at vma_assert_write_locked include/linux/mmap_lock.h:332 [inline], CPU#0: syz.2.19/5876
WARNING: ./include/linux/mmap_lock.h:332 at vma_replace_policy mm/mempolicy.c:1016 [inline], CPU#0: syz.2.19/5876
WARNING: ./include/linux/mmap_lock.h:332 at mbind_range+0x57a/0x810 mm/mempolicy.c:1063, CPU#0: syz.2.19/5876
Modules linked in:
CPU: 0 UID: 0 PID: 5876 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vma_assert_write_locked include/linux/mmap_lock.h:332 [inline]
RIP: 0010:vma_replace_policy mm/mempolicy.c:1016 [inline]
RIP: 0010:mbind_range+0x57a/0x810 mm/mempolicy.c:1063
Code: 97 ff e9 b2 fb ff ff e8 a4 4a 97 ff 90 0f 0b 90 e9 14 fe ff ff e8 96 4a 97 ff 4c 89 ff e8 0e b5 f9 fe c6 05 9c 2e ec 0d 01 90 <0f> 0b 90 4d 85 e4 0f 85 48 fe ff ff e8 75 4a 97 ff 31 db 4d 8d 77
RSP: 0018:ffffc90003bc7c78 EFLAGS: 00010292
RAX: 000000000000011f RBX: 000000000000000b RCX: a410c902b7e34800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000009 R08: ffffc90003bc7967 R09: 1ffff92000778f2c
R10: dffffc0000000000 R11: fffff52000778f2d R12: ffff8881012c9e00
R13: dffffc0000000000 R14: ffff888115b99bf8 R15: ffff8881162fa300
FS:  00007fa09187c6c0(0000) GS:ffff88818dc93000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33b63fff CR3: 0000000115bda000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_mbind mm/mempolicy.c:1560 [inline]
 kernel_mbind mm/mempolicy.c:1757 [inline]
 __do_sys_mbind mm/mempolicy.c:1831 [inline]
 __se_sys_mbind+0xad4/0x10f0 mm/mempolicy.c:1827
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa09099cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa09187c028 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 00007fa090c15fa0 RCX: 00007fa09099cdd9
RDX: 0000000000000001 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fa090a32d69 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa090c16038 R14: 00007fa090c15fa0 R15: 00007ffff596d0f8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

