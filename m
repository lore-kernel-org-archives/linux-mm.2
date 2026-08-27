Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F247DC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062FB6B0088; Thu, 27 Aug 2026 09:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013D36B0096; Thu, 27 Aug 2026 09:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44156B0098; Thu, 27 Aug 2026 09:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 709586B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:59:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DF0FA3C22
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:59:45 +0000 (UTC)
X-FDA: 85147207530.01.48CCCD7
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 65CCF120003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:59:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3zUKQagkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3zUKQagkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787839183;
	b=Q7mqDkWdEdxCJQopSuye6B/24xF392dxhLyLP0JMD59V4w4u05LUNAW/HITMjCjkjNZcAi
	KWhesUYOsGSSST7H3ldZgxifq5WQQjhQAJFyvDqHlHNSkciKPWEzcrTcr0chhCsm68m+4p
	XrEDRR59KNbkTq5Ku1bjNZCMiVeXrbw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787839183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=6jlAodZTMdJ5oEqgjDXWKFeou0hDngy1iIMXLLJ7X7M=;
	b=rZqoC7RmKJ10umcs8c3Yl4kl1deNkzU5KXG9eGYHOIBMzfD2OMyVq8A4HaUTQOXQYe8mVY
	AFHsLE+GXDydNbjccQT2Vb8ThESrDVd/8dKv1SvIlgcAA9Hb5ZzH4mAThfzcuGyMtNWuMU
	MhdWJTJCPUgZiAXLFo9Dl9pcGDD5Tts=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3zUKQagkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3zUKQagkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e7624e584dso4407393a34.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787839182; x=1788443982;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6jlAodZTMdJ5oEqgjDXWKFeou0hDngy1iIMXLLJ7X7M=;
        b=iEHzSxPvzlD6wC88gJJROTJIiDFkIjoreY0+6MPHzwBXnO1+f2N/e+xyjqHhjQdhVd
         w6mJQgxl2Zvg5tKv5JtdFP0p1iolacIJH8l8+Lx2aX4sal5e0bWi7LNXHW26U7eR4TYH
         ADrURBSNaghfnA93HgCSjFmts2lDVEXJqIbAJXdsVvDJb/Z56vJPK14lcjsIOE1/9/ri
         7Jsb7riMNOUaMmT5PIe0Io5uT+znGc8el6BhK0rMqifywkWgvGFhSoXAV+0cJ/uSb3JA
         5WCPLlNGn1O3SsvJ813aFhjgOzY1BVJfA/N/cQ+qVMqsVMHvbswXNMLGpoYj476IX76J
         ugcg==
X-Forwarded-Encrypted: i=1; AHgh+RqhWzfyLelugHe6g8Yc3JQcM0qSOPr2YFPvMlepm0zImVskUmCx7hfKVJdkuEbifrY/EvwdH9Y9+g==@kvack.org
X-Gm-Message-State: AFuF++k8ls0Ii8R1CVW5Se5TXy4E5TKQaQxU3hw54vv3xpvgIrZm66rE
	tgp25gQDwoLisd8aAhXleK3+SB4zFVTLaUmMOpSsxWkCRUUE5RfJEO5l+guGp5Ha61xA+xeg7kf
	QgeQPC/bZTt/wKPINZbq+4wqdY6Tx2o2Gzt9PyP+85nO1f8Y3LVJoX0RBQYQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3090:b0:6b1:b946:bffe with SMTP id
 006d021491bc7-6b1b946dd1bmr3119756eaf.25.1787839181352; Thu, 27 Aug 2026
 06:59:41 -0700 (PDT)
Date: Thu, 27 Aug 2026 06:59:41 -0700
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9042cd.50659fcc.60cd.0014.GAE@google.com>
Subject: [syzbot ci] Re: xswap: extendable swap device backed by zswap
From: syzbot ci <syzbot+cibdf28e878344e870@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, baoquan.he@linux.dev, 
	chengming.zhou@linux.dev, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, hebaoquan@kylinos.cn, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, youngjun.park@lge.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65CCF120003
X-Stat-Signature: q9ezzfepfy7k39c6uorkdtrgy1smbwxh
X-HE-Tag: 1787839183-180936
X-HE-Meta: U2FsdGVkX1/8qsvmhfLb70XhJTWjQZIZSDw2L9z4pFocpGV6Aj5FdQoNfz0DlJMaaS1vPd1wNqW1zrnwzcePaA7Fid6KhxED/NylWH90hufgs7Xq/8YNIaQEESTQnPgB9rCrwIehPpSNkdvJQInyXE12rgvJxSdvoCcWT6pdgVBMMllIM6r3vSAUjfqKjFCmLUBBKQpKNhwVDbkLc5ZRrk38XxGA0lJmxf5bppzPqB6Ij9pGqhZkOP4JU+dloYaXz5aLBla2ErIInOAzLWON4oZP2Z2V1+iFKo0yj94sbXb5PdEVaB74T7w0SlKhiWf7+g/LA71PFztglumh5sFIb7p4Ut5+8gmLDd0Xpgh/VnJfV43hXpeKlepvY9+zwOhSFfDkR9lu259uOpn6W+bFlIsLjHNaicCrn9SO2z2gaK3EfMX7B/gCIaPA9CHgYQEAc4IwfhE9vPEYXoLCcUbSKa/4+ezaRz3w5yvolc3rUnNWPNPQRwtiFZcAqlnSmnCwoUPy4x8ke8zHsKfipENjVZkRrN2zT9Ppbie9T5zOjNe45sQXYG3BN3lh4Nm/7KA0UXVP+2z7+ceUMd8evUw6R5RfHfXgL6SghrmuDsS/PUUxYXbRkpu90XfDc/FjctaMb4bPJTVUUbIkc4mtBNoinoitLg/WhuAyNYugCJ5gM5R9vtE/cKuDe+Vz+8+saRzNV9vjAz2iqw94RUOYAHQYfa02YMkZzxF0eimc3qMC8zZ+u8aQraF1gz8gRQkgn4Don9rYhMq9oD2e7nIvuXhIEevReWXxdWKpeDcG2AMBJThf9nx0Oxd0Dku/sMHYqMt0mqJFP1ktiDfI9D3+IDukRz2Il400HeNYBItF5nofHWvWUOSH8MAlhxGaFNCn/jCDgBeL6HddLn6YnJF3ZFIDA7Fxf6R/RXpqQ0QJggU1yOVTkkEXn26Gpi+fK6UKNjcLvD/F5zmKdBSdi3ELkEw
 q5uKjvr7
 K6U2UwMtCcu8Y2JPRfjXetkosa4sf9xNvGZRhGhlojf7YUrJ3y5oZgMprz/mAtyUsQZcOyLTNsxXbMyZGFn2DRXLQuPOiebHy5sSkySed9R5HL2IlpIu/37BSxqqsEzdcn4EDBySAfhsvckKOL/oew050FtKieH8pqhAJnVTW7qysrNAOu+Q/cE5J2HGSPxNPP/5CX3zSnwN+3U64J0nOuLGdjuSZjJ/f7PDqjlTRDflWzhSaiJIMaRg+Z9QWmPivMhGA4yz7+vFHs+bajPgekVqdQE6LYiarhprb2Dddugh2i3pEq/M+8S6sydI0KUEaZYfd/6X3lCN5wbbLjyEqLUCFBJ01o7Ns0oVuG+tMw75FyZ5wWLXKf33QXHzrpqHoE+lfCCnoTIVbfcW78/vG6FTjDVjKiBniU0/W+U79NolnCMgotQo3tuFfAVb7sDtv3rJdPuIIOY+AZ5ytIBSsPfUQsAdrcwhzsi3PCwToVxSSrDq82FIF/mA0wdg1/dpoZ8v+SLEvm/rupOtO12fqcrKWuewqpB0GnkaGZC06vHjKZy9rwrVqFJXycAzy9DRLKedeckJLJAHkpKmDMa2S71Yb0u7/jLyWBdW5vm0GcF4YjSttJvxr9iC9zJlHLRX+edTs0uc2ugrR91hCMH/8k1TJ64A74oGH7undzTjEGb7p/6DeREaSY6gJ3hB3yBIrTnHGtt2GOkHkMZAEhmAn3lOjq1CGHP220zYB/TPet2U+dHION9vTO9g3vXrz8N4CQU2tyYZude4FXUc3CVoC5ZzQa6BX8lGOQSgLAN6BBndNUq7r0szuWX/xy/eK1qDbb6oYlJPgY4iAd8rfaKeN1+fusAm8FSxSTpgSM5b+/2yhyazCaORl+3TbLiMaS5c8Zrvf1+gU6AIClWhFiGKKPDt6Z/3w5AChzydIb3OVWYe4pyiQ3/5W1zxvMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] xswap: extendable swap device backed by zswap
https://lore.kernel.org/all/20260827094509.1016740-1-hebaoquan@kylinos.cn
* [PATCH 01/16] mm: zswap: return -ENOENT when the swap device is gone
* [PATCH 02/16] mm: xswap support for zswap
* [PATCH 03/16] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
* [PATCH 04/16] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
* [PATCH 05/16] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
* [PATCH 06/16] mm, swap: add sysfs create interface for xswap
* [PATCH 07/16] mm, swap: add xswap grow trigger on cluster allocation
* [PATCH 08/16] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
* [PATCH 09/16] mm, swap: free backing pages in xswap_unmap_clusters
* [PATCH 10/16] mm, swap: add nr_free_tail for O(1) xswap shrink detection
* [PATCH 11/16] mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
* [PATCH 12/16] mm, swap: add debugfs knob for xswap per-device cluster limit
* [PATCH 13/16] mm, swap: defer xswap shrink to workqueue to avoid lock recursion
* [PATCH 14/16] mm, swap: refactor swapoff + add xswap_destroy
* [PATCH 15/16] mm, swap: require zswap for xswap devices
* [PATCH 16/16] mm, swap: allow setting xswap device priority at creation

and found the following issue:
possible deadlock in console_flush_all

Full report is available here:
https://ci.syzbot.org/series/6e23a918-7d02-47ba-a61f-bcad82aebf14

***

possible deadlock in console_flush_all

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      169393fff5d1ec2690934067eeb95544ff5ebdd7
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/633d2731-0a5e-45d2-96bf-bd29305475b9/config
syz repro: https://ci.syzbot.org/findings/b9106c23-79f3-457d-bb14-c0cf63e4bed2/syz_repro

------------[ cut here ]------------
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.1.20/5854 is trying to acquire lock:
ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:305 [inline]
ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:428 [inline]
ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:291 [inline]
ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: console_flush_one_record kernel/printk/printk.c:3246 [inline]
ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: console_flush_all+0x123/0xaf0 kernel/printk/printk.c:3343

but task is already holding lock:
ffff88823c63a898 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0x7fe/0x10a0 kernel/workqueue.c:2358

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&pool->lock){-.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
       __queue_work+0x72f/0x10a0 kernel/workqueue.c:2361
       queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
       queue_work include/linux/workqueue.h:699 [inline]
       rpm_suspend+0xeca/0x17b0 drivers/base/power/runtime.c:688
       __pm_runtime_idle+0x12f/0x1a0 drivers/base/power/runtime.c:1129
       pm_runtime_put include/linux/pm_runtime.h:551 [inline]
       __device_attach+0x355/0x450 drivers/base/dd.c:1116
       device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
       bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
       device_add+0x7d7/0xb80 drivers/base/core.c:3772
       serial_base_port_add+0x18f/0x270 drivers/tty/serial/serial_base_bus.c:186
       serial_core_port_device_add drivers/tty/serial/serial_core.c:3275 [inline]
       serial_core_register_port+0x37f/0x2840 drivers/tty/serial/serial_core.c:3314
       serial8250_register_8250_port+0x16b4/0x2090 drivers/tty/serial/8250/8250_core.c:828
       serial_pnp_probe+0x56a/0x7f0 drivers/tty/serial/8250/8250_pnp.c:480
       pnp_device_probe+0x30b/0x4c0 drivers/pnp/driver.c:111
       call_driver_probe drivers/base/dd.c:-1 [inline]
       really_probe+0x254/0xae0 drivers/base/dd.c:706
       __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
       driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
       __driver_attach+0x339/0x600 drivers/base/dd.c:1292
       bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
       bus_add_driver+0x345/0x670 drivers/base/bus.c:763
       driver_register+0x23a/0x320 drivers/base/driver.c:174
       serial8250_init+0x8f/0x160 drivers/tty/serial/8250/8250_platform.c:317
       do_one_initcall+0x250/0x870 init/main.c:1347
       do_initcall_level+0x10a/0x1a0 init/main.c:1409
       do_initcalls+0x59/0xa0 init/main.c:1425
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
       kernel_init+0x1d/0x1d0 init/main.c:1548
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&dev->power.lock){-...}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
       __pm_runtime_resume+0x10f/0x180 drivers/base/power/runtime.c:1196
       pm_runtime_get include/linux/pm_runtime.h:494 [inline]
       __uart_start+0x171/0x460 drivers/tty/serial/serial_core.c:149
       uart_write+0x251/0x9f0 drivers/tty/serial/serial_core.c:629
       process_output_block drivers/tty/n_tty.c:557 [inline]
       n_tty_write+0xd49/0x11e0 drivers/tty/n_tty.c:2366
       iterate_tty_write drivers/tty/tty_io.c:1006 [inline]
       file_tty_write+0x509/0x9c0 drivers/tty/tty_io.c:1081
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&port_lock_key){-.-.}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
       uart_port_lock_irqsave include/linux/serial_core.h:719 [inline]
       serial8250_console_write+0x153/0x1ba0 drivers/tty/serial/8250/8250_port.c:3344
       console_emit_next_record kernel/printk/printk.c:3183 [inline]
       console_flush_one_record kernel/printk/printk.c:3269 [inline]
       console_flush_all+0x6ea/0xaf0 kernel/printk/printk.c:3343
       __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
       console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
       vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
       _printk+0xdd/0x130 kernel/printk/printk.c:2504
       register_console+0xbc3/0xfc0 kernel/printk/printk.c:4208
       univ8250_console_init+0x3a/0x70 drivers/tty/serial/8250/8250_core.c:515
       console_init+0x10b/0x4a0 kernel/printk/printk.c:4407
       start_kernel+0x238/0x3e0 init/main.c:1112
       x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
       x86_64_start_kernel+0x137/0x1b0 arch/x86/kernel/head64.c:291
       common_startup_64+0x13e/0x157

-> #0 (console_owner){..-.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5238
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
       console_lock_spinning_enable kernel/printk/printk.c:1902 [inline]
       console_emit_next_record kernel/printk/printk.c:3177 [inline]
       console_flush_one_record kernel/printk/printk.c:3269 [inline]
       console_flush_all+0x693/0xaf0 kernel/printk/printk.c:3343
       __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
       console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
       vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
       _printk+0xdd/0x130 kernel/printk/printk.c:2504
       __report_bug+0x349/0x570 lib/bug.c:248
       report_bug+0x16a/0x220 lib/bug.c:286
       handle_bug+0x9c/0x200 arch/x86/kernel/traps.c:436
       exc_invalid_op+0x1a/0x50 arch/x86/kernel/traps.c:490
       asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:593
       __queue_work+0xd18/0x10a0 kernel/workqueue.c:2385
       queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
       swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1893
       swap_put_entries_direct+0x94/0x100 mm/swapfile.c:2403
       zap_nonpresent_ptes mm/memory.c:1900 [inline]
       do_zap_pte_range mm/memory.c:1967 [inline]
       zap_pte_range mm/memory.c:2065 [inline]
       zap_pmd_range mm/memory.c:2151 [inline]
       zap_pud_range mm/memory.c:2179 [inline]
       zap_p4d_range mm/memory.c:2200 [inline]
       __zap_vma_range+0x1da0/0x4f70 mm/memory.c:2240
       unmap_vmas+0x390/0x550 mm/memory.c:2309
       exit_mmap+0x293/0x9f0 mm/mmap.c:1315
       __mmput+0x118/0x420 kernel/fork.c:1187
       exit_mm+0x221/0x2d0 kernel/exit.c:615
       do_exit+0x6cd/0x2360 kernel/exit.c:997
       do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
       get_signal+0x121b/0x12c0 kernel/signal.c:3046
       arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
       __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
       exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
       do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  console_owner --> &dev->power.lock --> &pool->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&pool->lock);
                               lock(&dev->power.lock);
                               lock(&pool->lock);
  lock(console_owner);

 *** DEADLOCK ***

8 locks held by syz.1.20/5854:
 #0: ffff8881bb3703b8 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:600 [inline]
 #0: ffff8881bb3703b8 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x1a4/0x9f0 mm/mmap.c:1299
 #1: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #1: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #1: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x29/0x240 mm/pgtable-generic.c:290
 #2: ffff88816d267f18 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #2: ffff88816d267f18 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x13d/0x210 mm/pgtable-generic.c:404
 #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: __swap_cluster_lock mm/swap.h:155 [inline]
 #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: swap_cluster_lock mm/swap.h:170 [inline]
 #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: swap_put_entries_cluster+0x109/0x4b0 mm/swapfile.c:1864
 #4: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #4: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #4: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: __queue_work+0x1ea/0x10a0 kernel/workqueue.c:2321
 #5: ffff88823c63a898 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0x7fe/0x10a0 kernel/workqueue.c:2358
 #6: ffffffff8eb4bfa0 (console_lock){+.+.}-{0:0}, at: _printk+0xdd/0x130 kernel/printk/printk.c:2504
 #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:305 [inline]
 #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:428 [inline]
 #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:291 [inline]
 #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: console_flush_one_record kernel/printk/printk.c:3246 [inline]
 #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: console_flush_all+0x123/0xaf0 kernel/printk/printk.c:3343

stack backtrace:
CPU: 1 UID: 0 PID: 5854 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5238
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
 console_lock_spinning_enable kernel/printk/printk.c:1902 [inline]
 console_emit_next_record kernel/printk/printk.c:3177 [inline]
 console_flush_one_record kernel/printk/printk.c:3269 [inline]
 console_flush_all+0x693/0xaf0 kernel/printk/printk.c:3343
 __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
 console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
 vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 __report_bug+0x349/0x570 lib/bug.c:248
 report_bug+0x16a/0x220 lib/bug.c:286
 handle_bug+0x9c/0x200 arch/x86/kernel/traps.c:436
 exc_invalid_op+0x1a/0x50 arch/x86/kernel/traps.c:490
 asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:593
RIP: 0010:__queue_work+0xd18/0x10a0 kernel/workqueue.c:2385
Code: 3d 7e ec b2 0e 01 0f 85 35 02 00 00 e8 a1 28 39 00 e9 82 f3 ff ff e8 97 28 39 00 90 0f 0b 90 e9 21 fd ff ff e8 89 28 39 00 90 <0f> 0b 90 e9 80 fe ff ff e8 7b 28 39 00 eb 11 e8 74 28 39 00 4c 8b
RSP: 0018:ffffc90003cdf1d8 EFLAGS: 00010093
RAX: ffffffff818dc2d7 RBX: dffffc0000000000 RCX: ffff888113955a00
RDX: 0000000000000000 RSI: ffffffff8c4bca60 RDI: ffffffff8c4bca20
RBP: 0000000000000001 R08: ffffffff90572d37 R09: 1ffffffff20ae5a6
R10: dffffc0000000000 R11: fffffbfff20ae5a7 R12: ffff888160408400
R13: ffff88810fdd7088 R14: 0000000000000001 R15: ffff88810fdd7090
 queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
 swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1893
 swap_put_entries_direct+0x94/0x100 mm/swapfile.c:2403
 zap_nonpresent_ptes mm/memory.c:1900 [inline]
 do_zap_pte_range mm/memory.c:1967 [inline]
 zap_pte_range mm/memory.c:2065 [inline]
 zap_pmd_range mm/memory.c:2151 [inline]
 zap_pud_range mm/memory.c:2179 [inline]
 zap_p4d_range mm/memory.c:2200 [inline]
 __zap_vma_range+0x1da0/0x4f70 mm/memory.c:2240
 unmap_vmas+0x390/0x550 mm/memory.c:2309
 exit_mmap+0x293/0x9f0 mm/mmap.c:1315
 __mmput+0x118/0x420 kernel/fork.c:1187
 exit_mm+0x221/0x2d0 kernel/exit.c:615
 do_exit+0x6cd/0x2360 kernel/exit.c:997
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
 get_signal+0x121b/0x12c0 kernel/signal.c:3046
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f46ce79e0d9
Code: Unable to access opcode bytes at 0x7f46ce79e0af.
RSP: 002b:00007f46cf6fc028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: 0000000000000000 RBX: 00007f46cea26090 RCX: 00007f46ce79e0d9
RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007f46ce835024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f46cea26128 R14: 00007f46cea26090 R15: 00007ffefd86c578
 </TASK>
!list_empty(&work->entry)
WARNING: kernel/workqueue.c:2385 at __queue_work+0xd18/0x10a0 kernel/workqueue.c:2385, CPU#1: syz.1.20/5854
Modules linked in:
CPU: 1 UID: 0 PID: 5854 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__queue_work+0xd18/0x10a0 kernel/workqueue.c:2385
Code: 3d 7e ec b2 0e 01 0f 85 35 02 00 00 e8 a1 28 39 00 e9 82 f3 ff ff e8 97 28 39 00 90 0f 0b 90 e9 21 fd ff ff e8 89 28 39 00 90 <0f> 0b 90 e9 80 fe ff ff e8 7b 28 39 00 eb 11 e8 74 28 39 00 4c 8b
RSP: 0018:ffffc90003cdf1d8 EFLAGS: 00010093
RAX: ffffffff818dc2d7 RBX: dffffc0000000000 RCX: ffff888113955a00
RDX: 0000000000000000 RSI: ffffffff8c4bca60 RDI: ffffffff8c4bca20
RBP: 0000000000000001 R08: ffffffff90572d37 R09: 1ffffffff20ae5a6
R10: dffffc0000000000 R11: fffffbfff20ae5a7 R12: ffff888160408400
R13: ffff88810fdd7088 R14: 0000000000000001 R15: ffff88810fdd7090
FS:  00007f46cf6fc6c0(0000) GS:ffff8882a8f5a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000e6c000 CR3: 000000010a5a2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
 swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1893
 swap_put_entries_direct+0x94/0x100 mm/swapfile.c:2403
 zap_nonpresent_ptes mm/memory.c:1900 [inline]
 do_zap_pte_range mm/memory.c:1967 [inline]
 zap_pte_range mm/memory.c:2065 [inline]
 zap_pmd_range mm/memory.c:2151 [inline]
 zap_pud_range mm/memory.c:2179 [inline]
 zap_p4d_range mm/memory.c:2200 [inline]
 __zap_vma_range+0x1da0/0x4f70 mm/memory.c:2240
 unmap_vmas+0x390/0x550 mm/memory.c:2309
 exit_mmap+0x293/0x9f0 mm/mmap.c:1315
 __mmput+0x118/0x420 kernel/fork.c:1187
 exit_mm+0x221/0x2d0 kernel/exit.c:615
 do_exit+0x6cd/0x2360 kernel/exit.c:997
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
 get_signal+0x121b/0x12c0 kernel/signal.c:3046
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f46ce79e0d9
Code: Unable to access opcode bytes at 0x7f46ce79e0af.
RSP: 002b:00007f46cf6fc028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: 0000000000000000 RBX: 00007f46cea26090 RCX: 00007f46ce79e0d9
RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007f46ce835024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f46cea26128 R14: 00007f46cea26090 R15: 00007ffefd86c578
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

