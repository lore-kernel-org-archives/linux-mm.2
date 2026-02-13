Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C0F6EDF15C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 12:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C80D6B0005; Fri, 13 Feb 2026 07:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476686B0089; Fri, 13 Feb 2026 07:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374F56B008A; Fri, 13 Feb 2026 07:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22A8A6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:26:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB7188BCE7
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:26:33 +0000 (UTC)
X-FDA: 84439356666.30.80B1946
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0AB391C0003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:26:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3dxiPaQkbADgmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3dxiPaQkbADgmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770985592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=+o9xcW5Jo0mxLv5BBQLNSiDt1MMXbDDyqrVXsz3ZSCI=;
	b=d2IcYFVCefMp5Wp77XhjiW1ZF5CEPFBysWV+L6JfIKgIeX9mo4AeK1fZgM0pfKH6XGZ9fD
	dm/M/BnakCBCE3p32mOlqFE3+W3jmfPDLBZvSq7ArGHkOdxrRYeaCqCel7ZHxee0yRrhMa
	jBvWCWWY571xXiw2OZRjXCkmouwz3kg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3dxiPaQkbADgmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3dxiPaQkbADgmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770985592; a=rsa-sha256;
	cv=none;
	b=QuJFUxkHzog4mnytaKRi0NjzSIJJd7ZDrMGthvuXajzCskoMJYf5NxPiz6F/A1BgkdZHHF
	guP4V1/6mGttjdIGLDLCrWaJxukDI9hRNc5d6KWPY1w6VHvxqL3IqhK0lwVimnmvi2clpq
	buvFcOMs1b00Yscd+HdWVI3NIG9C1P0=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-673fd19a29eso6674013eaf.0
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 04:26:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770985591; x=1771590391;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+o9xcW5Jo0mxLv5BBQLNSiDt1MMXbDDyqrVXsz3ZSCI=;
        b=sBMEEMGpQo706Nl+cY1ISLg5T10aB8HlmtT58ZWS+rJ9KB/ikZ76dxmuess2zqFKN3
         7OzuKP2MlMd9v+9/dfP2K2OOauVkfwJLFKuLxUjq46Rh9ROg4R0x2JG3iKzckUmb2v8q
         WMrWWHkHrovUsdWcp/KGE8M1JcakQ6LCVI86M/u8X1Q3VIzFV3l2pzJGISBrwoOH4Gq2
         eQo+ftSIMkyx6z8xUon+tDRvQOPFY2holhajwAFfTMuaWWYkAq7tI3y/3nsXTWeOqt7P
         dGxiV8ZLWrl6SUDfPBiDyrL9tS7TjF3NSHdaUSAus3cgCQ1DpdBfI1xaslA8O3cDItyH
         Se0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVuo9IQrpnvhoQkrf2h7m+uGpvSTao1HB3RtUUXlEaEGTTBhqFRn+G6IoyZpwBA5GyfzvzO7Vning==@kvack.org
X-Gm-Message-State: AOJu0YwPp3wXL2ZftoH0UjgzulxP95J1NUKPO9prLOVe5Td0nJk71nmQ
	OTAvw/0CdTn1nKdzikfOAg76+ExzzTYSa1l+IJrcdChmKszYReKRglmqYlyKf/Ika59U83kPDgQ
	XG0l/8Y5sojnOwq/1SG9/b9ChMt+OO/9F/U7TH36IqZYgExuLQu7ySVoAtng=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:212:b0:676:b0d8:6324 with SMTP id
 006d021491bc7-67769e70b8bmr517498eaf.77.1770985591180; Fri, 13 Feb 2026
 04:26:31 -0800 (PST)
Date: Fri, 13 Feb 2026 04:26:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698f1877.a70a0220.2c38d7.00c2.GAE@google.com>
Subject: [syzbot] [mm?] KMSAN: uninit-value in follow_page_pte
From: syzbot <syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, 
	jhubbard@nvidia.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	peterx@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AB391C0003
X-Stat-Signature: 9ab8ti7h18ugq7bcmztuj9pk3uqp47uh
X-Rspam-User: 
X-HE-Tag: 1770985591-993332
X-HE-Meta: U2FsdGVkX1/lit7ErmWat/aiE2gnbo5Hjpwmn8kDdc93Qm4khauXf2/u1pjN4H6+veHRLnuwgPyWAvlTeMAogSqOkS5t0+QzjlSGkAA+AKri2CPoQLWvSKRkeESkfAMPYDjPsg5yS0aEzR3EHkFOhgJuFgMEQaQNrzNfjEugkpF1ny5gcELd8LFy55Tarsppp3CacDICj2QFiBqLox8pE7RDj0tI2TRGys12gnb/BXS76CaGE0+d4APil/oFSBbsXoKvovJ5jjGaQmWfzlADFiWRRKU9z/iT2o/5cmihiFLroX977WmDWfXKTAsuIw4fZp/DaVtkwBWLwlVFa1zbw7jk4O2l5R90oxKIveV+xaA6xsAsrQ2tsusRQ49YLIvb4sSyTqzI4DBTx40g4GolgF9J1BXjn5FLc7eN4D5l4pRLyNbsnBG3Jik2jaA1/BsfHzGv0kfSR14QnnPlZ1RhKeNzs33G8CtEFBWCAF9eHCb4477G32weYrYfWNERLY7DZ8fcfey1LE5VDxqrOwYi3qF3OJUXIC2fmlCdFINR8YzWXOyuz6ax5r6cJwj6N4NWaVjdhdTegn96jhz2VVW8RnZcsJVVEkd/iMpzdBu77oQA6ghXmMBkzhEDmF4ISl34plos0vpKJr7U9FV9ggG1sw8QUjW8dyGSlAyamDjGSUk3dDrTBFqG0VUzlx+RX8We/g4KZcrfIdTK7k7+02A8tMjzrpz0KjitGfivJ4Ii+ghKKLVemMwOEcRseBy+AnzuaRQ7kCiAjGufWtjJTGI1aH5vz4ycuumObTY6+gETvEpOj3epgo6RfVTcPjhW+SN7M4UfLPDatrLbI46lcsZRugrtfwcYhiEFxTx7CwGqeKWfXOVInvo5oJzKTscriTwK2auYv1OV+PaFGIvib7l6KjBOHrLeyO3BzHJQh/lh4nwIVe/D5ZDq5U6rawzJ5GpWTuAVwwDcK/u9UbjPKeH
 IM5sxW57
 tU/aD8wiYTnlPogIOH8Eeh99dcTVzQDLE+iXAozNhxmRtcLHBHnWUpaA2ZJFaxQmcQoTy9q0qxpR/4wXQjvRQZtUSI/GOFWw1fGlWm7S6Jqssdvz9HoICT6xG+ju5cehY1BEcSGp/RgM4Jtw4zHjK2qYo9uQeNR2YpaFI9P4B+FIbyBc82fTwNrj/zTxEv2oDBHf+3Ze+K+PULUyf8ZZTVqwacM/yb6La9X7hTsAwy+tdvOAqUzg1YbrTXF8FFAIcDdaLzXePXIdtDSow6xOyhiFcLWAEdshau3Rq+BeQ+0TLVlJWiXonMAAm1Szykg5b7rphZsNEbYOI0Xgm+97p1WLReI+vM50psEQdbFsTZlxgMfIr29AdTd0JsmYMHswSsRgDTG/H+57FfBqsqKmeqUfKkRnE4U7DgYzRF1OllvzyreSBt/FJSCAPAxXgN7Otb4JuOnx/ck520g0bBABrsYz6AGKYI0bSxR1s6Namc6jWNblss+lLQi8BO/Ppi156rNDkV5fKKDoNauq43S3QtSnJBPL8DpJ5zik5Bdk1O4zgkHVxhqh54v0YfxIBWU5KlnXh3E/DlA0KSDo9f8aWiLUr6NeiPK5tXufEJVKpFMshD5aQR0dbm1/A3xhscY1qqVqAAsmZ6pIOLrbV+F0x86B6FOpIJiW7WC4pplRWwGkSm0p46sZfcdky6ywfEwiRiistaNM9ds5q2X3zE31f4h99Q8aShJcj6s1QZk8KF19rzvqG/E2vLjq85RZTmGGrvvYArnGd7Dc6OWut69LefN1IsOUkfwdmbac5BDAMGzEKKGML6bymv7Wfgk+rGCZhDsQjCVLi8fhjiz++YEe5pkTiOcDzGl+ousjXgrF7thTBMiXmawvCeJFJNXXKi0/p/BhoIlx6GWfIvUIsJh6M5d16oDMRmZHJkVddDE9VA2q1KVqx4wHqNoeGyCH3U46vVIX74FcWXj72ZsvHckkfBfO5yPBl
 luA95pe7
 6bN90Ps9hLbzJOMOD3yMOaICnkOWwWOSHoerUkleqCxBr7Jy4IPlEMf0xQQXkI2AXY1s7R/kmxoAUEYIuu82XMs8jDtF8DAAiRj9/3iwF3hEOsZYHvUulXPgBGoFI3sQkdO+pwn+Eu35RKaBdkEetlWC4GjjBdTfitHvXhFvG0g0Wg2vZiJl+0yhR1Mw6vu+SYkduRJS7TCCsduJDCd1Cgtpd/TPLmZWenabHtAYi3pKRqAasN1aoTYLbA5bydft8Jh21yPV85kNH20+bN1KajYRbrBqNLcWBPFjbFvWNktEWzDbE3+Q2cBpgo8yAAH72CblVv/lYNo8rjJ+nl9B29lA8+q1Qx3Iw9DIb8kfFXEtinPQ2wa0Qp+DQCoLTEuxjJ/RQmWr8EazkKwQT0OUKpwn6rPkOQ2Uc3MGz0l4N8ES4wJizXNHn6+34jayG3LBMapRYYCNCIBcNYAzZXKPnY8fTN/ZXHnr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    05f7e89ab973 Linux 6.19
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c324aa580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9682a42d8ec8b05c
dashboard link: https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b9c0cdc82aa9/disk-05f7e89a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e43670d95943/vmlinux-05f7e89a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2c8401722932/bzImage-05f7e89a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in follow_page_pte+0x385/0x15b0 mm/gup.c:816
 follow_page_pte+0x385/0x15b0 mm/gup.c:816
 follow_pmd_mask mm/gup.c:915 [inline]
 follow_pud_mask mm/gup.c:967 [inline]
 follow_p4d_mask mm/gup.c:984 [inline]
 follow_page_mask mm/gup.c:1023 [inline]
 __get_user_pages+0x1524/0x5f00 mm/gup.c:1426
 __get_user_pages_locked mm/gup.c:1692 [inline]
 get_dump_page+0x142/0x570 mm/gup.c:2192
 dump_user_range+0x26e/0x2230 fs/coredump.c:1366
 elf_core_dump+0x697f/0x6c30 fs/binfmt_elf.c:2111
 coredump_write+0x209c/0x2d30 fs/coredump.c:1049
 do_coredump fs/coredump.c:1126 [inline]
 vfs_coredump+0x7a08/0x8d90 fs/coredump.c:1200
 get_signal+0x2068/0x29d0 kernel/signal.c:3019
 arch_do_signal_or_restart+0x53/0xc00 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:75 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:270 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:339 [inline]
 irqentry_exit+0xef/0x6d0 kernel/entry/common.c:196
 exc_page_fault+0x7e/0xb0 arch/x86/mm/fault.c:1530
 asm_exc_page_fault+0x2b/0x30 arch/x86/include/asm/idtentry.h:618

Uninit was stored to memory at:
 ext4_xattr_set_entry+0x1312/0x3440 fs/ext4/xattr.c:1740
 ext4_xattr_block_set+0xc74/0x5040 fs/ext4/xattr.c:2030
 ext4_xattr_set_handle+0x1e25/0x2b10 fs/ext4/xattr.c:2457
 ext4_xattr_set+0x2ff/0x5a0 fs/ext4/xattr.c:2559
 ext4_xattr_trusted_set+0x51/0x70 fs/ext4/xattr_trusted.c:38
 __vfs_setxattr+0x742/0x840 fs/xattr.c:200
 __vfs_setxattr_noperm+0x224/0xad0 fs/xattr.c:234
 __vfs_setxattr_locked+0x43c/0x480 fs/xattr.c:295
 vfs_setxattr+0x28d/0x650 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x3a4/0xcc0 fs/xattr.c:665
 path_setxattrat+0x6c8/0x7c0 fs/xattr.c:713
 __do_sys_lsetxattr fs/xattr.c:754 [inline]
 __se_sys_lsetxattr fs/xattr.c:750 [inline]
 __x64_sys_lsetxattr+0x103/0x1c0 fs/xattr.c:750
 x64_sys_call+0x3c8b/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:190
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __alloc_frozen_pages_noprof+0x6df/0xf50 mm/page_alloc.c:5263
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof+0xf6/0x200 mm/mempolicy.c:2557
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x1ea/0x1700 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0x1048/0x38b0 mm/slub.c:4656
 __slab_alloc+0xa3/0x180 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __kmalloc_cache_noprof+0x9e0/0x1710 mm/slub.c:5775
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 sctp_transport_new+0xb2/0xb60 net/sctp/transport.c:95
 sctp_assoc_add_peer+0x440/0x22b0 net/sctp/associola.c:617
 sctp_process_param net/sctp/sm_make_chunk.c:2546 [inline]
 sctp_process_init+0x11b0/0x3bc0 net/sctp/sm_make_chunk.c:2366
 sctp_cmd_process_init net/sctp/sm_sideeffect.c:712 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1395 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1204 [inline]
 sctp_do_sm+0x1719/0x9b30 net/sctp/sm_sideeffect.c:1175
 sctp_assoc_bh_rcv+0x88b/0xbc0 net/sctp/associola.c:1034
 sctp_inq_push+0x29d/0x350 net/sctp/inqueue.c:88
 sctp_backlog_rcv+0x3ca/0xd80 net/sctp/input.c:331
 sk_backlog_rcv include/net/sock.h:1177 [inline]
 __release_sock+0x3fb/0x7d0 net/core/sock.c:3213
 release_sock+0x6b/0x260 net/core/sock.c:3795
 sctp_wait_for_connect+0x451/0x810 net/sctp/socket.c:9393
 __sctp_connect+0x1483/0x15a0 net/sctp/socket.c:1248
 __sctp_setsockopt_connectx net/sctp/socket.c:1337 [inline]
 sctp_getsockopt_connectx3+0x7e5/0x8a0 net/sctp/socket.c:1422
 sctp_getsockopt+0xd9b/0x14c0 net/sctp/socket.c:8174
 sock_common_getsockopt+0x9c/0xf0 net/core/sock.c:3946
 do_sock_getsockopt+0x3a8/0x4c0 net/socket.c:2383
 __sys_getsockopt net/socket.c:2412 [inline]
 __do_sys_getsockopt net/socket.c:2419 [inline]
 __se_sys_getsockopt net/socket.c:2416 [inline]
 __x64_sys_getsockopt+0x32d/0x520 net/socket.c:2416
 x64_sys_call+0x3a97/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:56
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 9815 Comm: syz.4.1167 Not tainted syzkaller #0 PREEMPT(voluntary) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
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

