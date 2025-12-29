Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E26E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 09:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47A76B0088; Mon, 29 Dec 2025 04:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4EB6B0089; Mon, 29 Dec 2025 04:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7796B008A; Mon, 29 Dec 2025 04:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8536B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:29:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C156B140E29
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:29:29 +0000 (UTC)
X-FDA: 84271985658.05.3609552
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2483E4000F
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:29:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 390lSaQkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=390lSaQkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767000568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=4V5os5N56d4yyyFmq0PFU7V1UlQ3pWUZC3tYwP4xdo4=;
	b=XhfZEnJS2V36OuveABPIU1ODnIZrXZANDosLKg4kKoBOqmQbNVrKIeHdUNEKi1ZjXZvE85
	hMz6nXX6+hlp5QVmgjbFMYD9hTgu1LW6z+RI7aASn2fy2WgXroF3KZOsUVLZQYOWTJ/AGM
	hL7OIJtMZL/N6vzyVrIEFh9EMMOWcW4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 390lSaQkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=390lSaQkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767000568; a=rsa-sha256;
	cv=none;
	b=TDznUHsDY13oXE+Sq0iozBAVCBUdLZlSts66BFav3Va6ZwdqzLG2YBRRO537aUELdvW8BQ
	CZBrzumOaGoqHd+XrMadtCnroQqpWcVJqtqBHR8hIUsQYtvPsYYCTCrJaQWYG6O7zV09ZI
	mqZvvqABxFySX1w+GJRgPmRlmVH0PeE=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-656ceb0c967so8416972eaf.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767000567; x=1767605367;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4V5os5N56d4yyyFmq0PFU7V1UlQ3pWUZC3tYwP4xdo4=;
        b=HP6qJjtylAmQ+oYMuurKWaw3M83eX1FtIR0NgCozwal1cBMtpu9zqwX0I68BMp82LQ
         MtFJqxZxD9R/t/Kkt+jHOdS6wIL1BK2jVV23N6bOAHsgI5jvKl+5hy489Lb3eHav85al
         qp40uOX8plzEBN6oxmC/wmNxoIlsTNbF7AhDyTKH1hFHuEupA5MRNeFgHUUntGfmY8ry
         gFNJrUG38Cl/jGShp536CMXstMk2LZfC26Xyi9j1GJqGzru7eRNYEuP+0oym6BBCdIej
         ci2qzOGR+JPPeo5/PbbT7MjLjxjO7bxNd49vkFgbrf2vmqE2dO+B7nSfH1gpsyPizmCl
         oT0g==
X-Forwarded-Encrypted: i=1; AJvYcCUBeeVHJMoRRfXXD4S0hCmgaI1boOV0kh3OHE2V0nTsYU+qesjmEK6hElnYC0q9T7eBD21TcTHm3Q==@kvack.org
X-Gm-Message-State: AOJu0Yz926QqxtUnqoNwJqmuEBE1h2yc8dR4jbTMz3eNaXcGVBz/9vuW
	WM4Oy4VNg/ZDqIh80N9tfRHkF5LvMPJgtL35Rr++p1ENC4HcJ6uxZsgaMZ4w+pEzITSEuxPbqlD
	gcapuOJ9dOGuyeJJyzXbxUcn5Kmu8dxtj/ePeILUTGTtaUChSCpJfjswgLLw=
X-Google-Smtp-Source: AGHT+IHybrkf2tte334BKTttlZzZCy8Cn1CmBYqlYLc4xxHdUJbFlUkjQWFyUepzAAKrGZ++uSyqRin5RUGD12A1uB7t05YGRjJL
MIME-Version: 1.0
X-Received: by 2002:a05:6820:162a:b0:65d:163:407 with SMTP id
 006d021491bc7-65d0ea47594mr13255234eaf.22.1767000567228; Mon, 29 Dec 2025
 01:29:27 -0800 (PST)
Date: Mon, 29 Dec 2025 01:29:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695249f7.a70a0220.c527.0025.GAE@google.com>
Subject: [syzbot] [cgroups?] [mm?] KMSAN: uninit-value in __sigqueue_free
From: syzbot <syzbot+6e04171f00f33c0d62fb@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: 74ghq3h37fa5itfghyiu336qqwccyk7u
X-Rspam-User: 
X-Rspamd-Queue-Id: 2483E4000F
X-HE-Tag: 1767000567-957420
X-HE-Meta: U2FsdGVkX19reyypqfmJ7eCqCZlY1hKE9LzK63Sc5i0Y8hOs2EVGukM8zmiiwnrl3yngUU0U56rATAaGJhQlu3b/VVrUK9GyVwgrsiCSXMvSLv4MFeb0pKIwUCH8UmRoSjVgxkFTsLLuCUlOylIszYRPl+r5d1YKj+vAOTUbRIKzDkmbnktdzwsbJjN5UCSPSZtb3ApVyUx3OFCRGDXxkLIlFDJI//FCizMjHwN1MiUGBMy8MC4Rt/OtU5fzSa4kRYwXUzjGUw/Xu6/9qQeJBNaX8Nrh+g2R3m6ay0806QZGesYvCnm1QBTzmlGRsvD3Wop4xZZDBzW/MZTQM6evFzAgnpzTy7OpsvN+qpDrr31hKg4XvsZHK58BQ6mxfE8wCDS1ctV1mAmLF5NgsO8Quh4YXFzA9IKT4aPOPji9j/VKlRXoy5YGPe2I1UupWorItH9pqrUsT8QD50YOKSKhslK8izv7yDB9/tUXaO/O79Kxc1eGtR/RIKNCzJg4J7bLTSY7uX34FJXYQGHU+MNNkVnKU8IJL8my/EQt66NEt5kkBwqmx5DWpoxTvvXgLR4eH0CC0Hev1qxFnX/SCan83uBhClWmrahYAUdaq+ae/JAJcqM8mqYFDQDy8757fxQgu03R3Zu6/YUzViOH7/4oMAygmLV/XbBhW4eAkaW1Y0qr+BLBWMupTTZ3aDFizhw2DMlzMugfyEqH/MlmpAAkXsSaIhPmZhZK/B9KiMHOosvTxp32I5M1mjFmsMEx9pwY3L/0MZaWQRxcdEBLlPFZ74g4+fi0U6JiQr0wfgATPhHEgooRgR904porAaVxUom6MibkdKI20SThSdocG+PGcceQU5fwI4FpKIpWijhA4DMHoe5SKPKJEmJ4DnY9mtMCkB5f6BHg1AAYfMBG5t3Oqcmc5/K9MFSuDVHkE5af482OjBl7D7Kd6YCiE4Lfc9t1i5dWff2TcHMUVH5F2SW
 wDNjqu+c
 d6U6qyn+CK/+vnjOOUp1XWe5ebzws4pMkdtxJuJcR0AkyxjV9hS7aKj0ppMwEmP3u7YsIYXv+3cjY0U2qTBHW+DV4Is778ow6sLJKlWName+svctm0QKLOYD5hlF3zYMQGOpcvVFeL5cKHqNIRp9LJ/NvoHcT6MbPn98ZOf1o8RD+FQnRZmRglB9MdQBnRUw1SkiJT27PI6nrUpFqxv+TR9n5GEfDxSz7Jj+w/5CQ9qEBZ9981P3lnCbK2FrvzyxHNKsCxHuNPade4WAw+yg8c3eUjU45Xn5+elc/FJ2AzkoCMPXr9R1++LQv76bYQ7atFETAQZ8iPIS7LHpl4o1yU4tbfXBzzh0PjWPrMf55R61MOsSpAN8fSVKig5Pp/XysZiijEl8i/VAZ6Q6WVa5DWKt2PcumoRvVyazndghEmkMbEY9+ksyfEWHiA8H7vOO8JRnLekvC5uqA6w135omOSvxiCIvBNayWEM4qqBNUMDi+32Clq9d4+p1i/Tt4odHEPBfl6/lroH5EUzShkOTA90RT6GeFxaIlT2o0K3kIA3lbBk3310CSxl6zpgsopoMrF50WEQ7AI9UnGP2rjmBwo6VgzxuoS6T495JfHnz1C8dQ/5rap7riLw7f5DqMgeW3xTWtwloYdlNVeu1vB+aOHuOgZBXz0sA/rO75WOZ/kJp4n80h/ouKOMscMaY08imgH2sOoTjbgXu+Dyb591ZYGUNuP0v2+XuvoyTC7Ttk1LBGYayERCB/SQJpIShd5CCI0UVWxmof0Nj/A1Wo54sbPW2W2e+wYVdtemcT63xYIMdGihmYdOeM7cyNYcSdTFzcJGoI/ewvJmqqvOTo0aJnE/8s04nsu3eSD+MmDw+hZDPcYVBkMka436DEM+Ifiu1olocW5hwGGZRNwWrIHsqEpbzpvMR8IPVtyyE6LOw7Cc+I8uGCdScU9nYk8fDlJYOLUCJJdSIQt4x/Q2mYSSaYE2zqNb2p
 OC2IHVYR
 DipgJe+kgbaa/J5Xd4z7qoi+3tT/x0MLr6qjnJtcjhxxmSKRSlg0oeG4/V4jnR7vzq2h/8ueulGhYDCZ8NEYz3fzJu2OuYr1XkjHeA/MipQI79z6IEwduEoPmGyfrS6N6IWlPH29sSdM+6kY0X9btZLgnas9scg795MPBeueXvmLyPXyJU/4tbTFvVF5PUCXKAV23vdq+ib8CxGaBALY1Pa2y97QQSwucv01VEgPdy3uQN+lHb7GGGSxpX6097BfKFMPLr2oRFcad27Oye3ZiMOW2GZ/1ekpgjzrCsbzD1ACFvJIs2WJe1LEha6VwWA9U78bik3vDFXNZGu2GvK6D/8bB/QX1CQSM8Mz/nembpUubw17ydtWDPupc4OE7vFlrIa6d1feb8Tgp/GlQGdLFcKDNisnQgPBsfwrMoX4Ifk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ccd1cdca5cd4 Merge tag 'nfsd-6.19-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100e9758580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3903bdf68407a14
dashboard link: https://syzkaller.appspot.com/bug?extid=6e04171f00f33c0d62fb
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a243709d75f9/disk-ccd1cdca.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8eb4fcf14c57/vmlinux-ccd1cdca.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5bb3fe154e48/bzImage-ccd1cdca.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6e04171f00f33c0d62fb@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __memcg_slab_free_hook+0x466/0x5a0 mm/memcontrol.c:3235
 __memcg_slab_free_hook+0x466/0x5a0 mm/memcontrol.c:3235
 memcg_slab_free_hook mm/slub.c:2364 [inline]
 slab_free mm/slub.c:6667 [inline]
 kmem_cache_free+0x812/0x13c0 mm/slub.c:6781
 __sigqueue_free+0x23a/0x270 kernel/signal.c:475
 flush_sigqueue+0x1c5/0x3f0 kernel/signal.c:486
 release_task+0x1f33/0x29a0 kernel/exit.c:305
 wait_task_zombie kernel/exit.c:1274 [inline]
 wait_consider_task+0x28e0/0x3e00 kernel/exit.c:1501
 do_wait_thread kernel/exit.c:1564 [inline]
 __do_wait+0x206/0xdd0 kernel/exit.c:1682
 do_wait+0x10e/0x470 kernel/exit.c:1716
 kernel_wait4+0x2b5/0x480 kernel/exit.c:1875
 __do_sys_wait4 kernel/exit.c:1903 [inline]
 __se_sys_wait4 kernel/exit.c:1899 [inline]
 __x64_sys_wait4+0x148/0x340 kernel/exit.c:1899
 x64_sys_call+0x31d7/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:62
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd3/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof+0xf7/0x200 mm/mempolicy.c:2557
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x1ea/0x1710 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0x10bf/0x3930 mm/slub.c:4656
 __slab_alloc+0xa3/0x180 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_noprof+0xbd5/0x1c20 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 neigh_alloc net/core/neighbour.c:522 [inline]
 ___neigh_create+0xd55/0x3b90 net/core/neighbour.c:656
 __neigh_create+0xa6/0xd0 net/core/neighbour.c:744
 ip6_finish_output2+0x160e/0x2d30 net/ipv6/ip6_output.c:128
 __ip6_finish_output net/ipv6/ip6_output.c:-1 [inline]
 ip6_finish_output+0x903/0x10d0 net/ipv6/ip6_output.c:220
 NF_HOOK_COND include/linux/netfilter.h:307 [inline]
 ip6_output+0x331/0x600 net/ipv6/ip6_output.c:247
 dst_output include/net/dst.h:464 [inline]
 NF_HOOK include/linux/netfilter.h:318 [inline]
 mld_sendpack+0xb4a/0x1770 net/ipv6/mcast.c:1855
 mld_send_cr net/ipv6/mcast.c:2154 [inline]
 mld_ifc_work+0x1328/0x19b0 net/ipv6/mcast.c:2693
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3340
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3421
 kthread+0xd5c/0xf00 kernel/kthread.c:463
 ret_from_fork+0x208/0x710 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

CPU: 0 UID: 0 PID: 1 Comm: init Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
=====================================================


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

