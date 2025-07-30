Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80557C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBF58E0005; Wed, 30 Jul 2025 05:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BB78E0001; Wed, 30 Jul 2025 05:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081308E0005; Wed, 30 Jul 2025 05:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBB628E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:37:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97E4FC0355
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:37:26 +0000 (UTC)
X-FDA: 83720428092.30.E0B6D5E
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf18.hostedemail.com (Postfix) with ESMTP id 43AF31C000B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:37:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753868245; a=rsa-sha256;
	cv=none;
	b=sLJffSRIt01+miAOOL4QR/aSN7bLOUjz76hbaF6qnHxm0U/5gEY8pG/y9zlMY/8Nt4j1m8
	pZWN1ewdWdd7sVwqPMFpZcKNf0n53xoibm2UVtapMWB3JotiYZ1gfz87vnwDUglZ042ky5
	RSGtHjXjHLN9aiipKsMjGPFRZOB/Yyk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753868245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=t4Y+TCE8rqlttGHiY7c8uINll71TiFgjRGSMVbS38yg=;
	b=DcXeQwIws9+KNCXDyzwwARA1/AU70i5MFVLUN42Nx7YQrnmc8anv4ZDVLmsa1V+Zeh/DDS
	PTeA85Z3cZxO1kCZ8eohKAV4EtkJSBKOUCLrqoL+ljv4yUEQzzJpSkhfgteV9F94gd2+bV
	T8Uk5ql+x9CwhU/EzBpsmzh0H+jm5bQ=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bsRpT4k5RzphTk;
	Wed, 30 Jul 2025 17:33:05 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id E9F8B1A0171;
	Wed, 30 Jul 2025 17:37:18 +0800 (CST)
Received: from huawei.com (10.67.174.33) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 30 Jul
 2025 17:37:18 +0800
From: Gu Bowen <gubowen5@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <stable@vger.kernel.org>, <linux-mm@kvack.org>, Lu Jialin
	<lujialin4@huawei.com>, Gu Bowen <gubowen5@huawei.com>
Subject: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Date: Wed, 30 Jul 2025 17:49:14 +0800
Message-ID: <20250730094914.566582-1-gubowen5@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.33]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43AF31C000B
X-Stat-Signature: y9y1ewohbx1soo9cx4wpme4jgtow9xqk
X-Rspam-User: 
X-HE-Tag: 1753868242-157379
X-HE-Meta: U2FsdGVkX1+1+kXEi/U29oJFXIV8hl0+zPlpf0mzA+gNGozCfAUWa8PjmtwsZGIc+LC4sgtrpffJzspDqgm2R5p5DkhTns/ENOE6bA9GEkVgxawETaWncqNcHmzvH7AM2wjDDf4NToKjV8BCDNRwKNbeuSzec7zRMBecuZqv3tVTXB5BIhHaLdCLYUOea1+MctVqjRb9TaSLD5oQOYYSi+mQ+j6nwRTbjVG+jdC5kYn7y+4rdSaM8jdniwuXmXdvw3sAlvh4tasGsZZN9kBlbDCfrAra2L+l2KyP4HUJQ/cKeLaatIp3FXiNwYL9ENuJOpcYbivgQMqnd1j6uOftRHERQxs1SvynGi5HJffAPHOYM2xTXRS+E1jeD0TssB4NbjdagcwLhoLRGB7Lr+4NcRAYfHIT+1x+53W38oBygRs/a8erv4DIrcP/UZryt/23UYvNlaNVD6x8G5mm7K5iTwX+VdKFh0grH7OJCpfID55viNNAWX4x5s4bdm/yEPIQiHLB+g/8xf7aUfbrTnvmLP8N2167yLQyTL6PklBGE/pJmKM+bejo/CyjaBEjzuLp+ne3MG168F3KjjnD/8w8HLGpF3UDsZHwvkFMs9CwHaTstkAAV1zGFXWz1JwUr1NFA7sErsPeptKbaRpObtvguRMza9hswnBmlMkfC0rp+KjRI5e8kMDnryz8BR2hqSDNjGzVHNpZnnY6fV3bOtxNB18ACmI18eNz9Qfc3dwCE3U837hu/UU7vLRrzSljBsXVl2ZxHlo6b+us/khjwosAQUdA+xBZ4i4w5JoPYrrqY42p3I2YRQC7nM+4YJKn7HDgkVeo+3KwCSaV43/uEpxe/5vjfZ9QO/hQw4kiFvDycZlcEmB/y4Au144SF3HupkYFpKHJF6ss30khKtynHD8JOxw7QkC+Bs8NLVC9Q7RHk7K5VNMPXFHvWr8d5Bcf83OaB3TqZhiqBobmYVhscdp
 E47SsfJD
 zKGI5jknDZZyYrxZTHek0hsgcF/H1cMbCMmh1zeXSl1ahS9riSfPWxDOTLDVheC51TyxGnW4MFkoNG8kUWkM2ipIGYgHBSpZjDMpQCl2inMHD1DL/uaHLs85/vIABCCR4M8F96MRLXj3DqcceoENmJSMrxp9i7w+G5U6/Yg5LA0CO1orqEUw+DeVOIe3ucZ34MobzHcugA6CnnI0Hc3E0nVlk9OUeaFSo6ur7fsgzwj8fsqzLe0zf1fpDnCQCVQ/WC+YA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemleak_scan_thread() invokes scan_block() which may invoke a nomal
printk() to print warning message. This can cause a deadlock in the
scenario reported below:

       CPU0                    CPU1
       ----                    ----
  lock(kmemleak_lock);
                               lock(&port->lock);
                               lock(kmemleak_lock);
  lock(console_owner);

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided.

Our syztester report the following lockdep error:

======================================================
WARNING: possible circular locking dependency detected
5.10.0-22221-gca646a51dd00 #16 Not tainted
------------------------------------------------------
kmemleak/182 is trying to acquire lock:
ffffffffaf9e9020 (console_owner){-...}-{0:0}, at: console_trylock_spinning+0xda/0x1d0 kernel/printk/printk.c:1900

but task is already holding lock:
ffffffffb007cf58 (kmemleak_lock){-.-.}-{2:2}, at: scan_block+0x3d/0x220 mm/kmemleak.c:1310

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (kmemleak_lock){-.-.}-{2:2}:
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3b/0x60 kernel/locking/spinlock.c:164
       create_object.isra.0+0x36/0x80 mm/kmemleak.c:691
       kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
       slab_post_alloc_hook mm/slab.h:518 [inline]
       slab_alloc_node mm/slub.c:2987 [inline]
       slab_alloc mm/slub.c:2995 [inline]
       __kmalloc+0x637/0xb60 mm/slub.c:4100
       kmalloc include/linux/slab.h:620 [inline]
       tty_buffer_alloc+0x127/0x140 drivers/tty/tty_buffer.c:176
       __tty_buffer_request_room+0x9b/0x110 drivers/tty/tty_buffer.c:276
       tty_insert_flip_string_fixed_flag+0x60/0x130 drivers/tty/tty_buffer.c:321
       tty_insert_flip_string include/linux/tty_flip.h:36 [inline]
       tty_insert_flip_string_and_push_buffer+0x3a/0xb0 drivers/tty/tty_buffer.c:578
       process_output_block+0xc2/0x2e0 drivers/tty/n_tty.c:592
       n_tty_write+0x298/0x540 drivers/tty/n_tty.c:2433
       do_tty_write drivers/tty/tty_io.c:1041 [inline]
       file_tty_write.constprop.0+0x29b/0x4b0 drivers/tty/tty_io.c:1147
       redirected_tty_write+0x51/0x90 drivers/tty/tty_io.c:1176
       call_write_iter include/linux/fs.h:2117 [inline]
       do_iter_readv_writev+0x274/0x350 fs/read_write.c:741
       do_iter_write+0xbb/0x1f0 fs/read_write.c:867
       vfs_writev+0xfa/0x380 fs/read_write.c:940
       do_writev+0xd6/0x1d0 fs/read_write.c:983
       do_syscall_64+0x2b/0x40 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x6c/0xd6

-> #2 (&port->lock){-.-.}-{2:2}:
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3b/0x60 kernel/locking/spinlock.c:164
       tty_port_tty_get+0x1f/0xa0 drivers/tty/tty_port.c:289
       tty_port_default_wakeup+0xb/0x30 drivers/tty/tty_port.c:48
       serial8250_tx_chars+0x259/0x430 drivers/tty/serial/8250/8250_port.c:1906
       __start_tx drivers/tty/serial/8250/8250_port.c:1598 [inline]
       serial8250_start_tx+0x304/0x320 drivers/tty/serial/8250/8250_port.c:1720
       uart_write+0x1a1/0x2e0 drivers/tty/serial/serial_core.c:635
       do_output_char+0x2c0/0x370 drivers/tty/n_tty.c:444
       process_output drivers/tty/n_tty.c:511 [inline]
       n_tty_write+0x269/0x540 drivers/tty/n_tty.c:2445
       do_tty_write drivers/tty/tty_io.c:1041 [inline]
       file_tty_write.constprop.0+0x29b/0x4b0 drivers/tty/tty_io.c:1147
       call_write_iter include/linux/fs.h:2117 [inline]
       do_iter_readv_writev+0x274/0x350 fs/read_write.c:741
       do_iter_write+0xbb/0x1f0 fs/read_write.c:867
       vfs_writev+0xfa/0x380 fs/read_write.c:940
       do_writev+0xd6/0x1d0 fs/read_write.c:983
       do_syscall_64+0x2b/0x40 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x6c/0xd6

-> #1 (&port_lock_key){-.-.}-{2:2}:
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3b/0x60 kernel/locking/spinlock.c:164
       serial8250_console_write+0x292/0x320 drivers/tty/serial/8250/8250_port.c:3458
       call_console_drivers.constprop.0+0x185/0x240 kernel/printk/printk.c:1988
       console_unlock+0x2b4/0x640 kernel/printk/printk.c:2648
       register_console.part.0+0x2a1/0x390 kernel/printk/printk.c:3024
       univ8250_console_init+0x24/0x2b drivers/tty/serial/8250/8250_core.c:724
       console_init+0x188/0x24b kernel/printk/printk.c:3134
       start_kernel+0x2b0/0x41e init/main.c:1072
       secondary_startup_64_no_verify+0xc3/0xcb

-> #0 (console_owner){-...}-{0:0}:
       check_prev_add+0xfa/0x1380 kernel/locking/lockdep.c:2988
       check_prevs_add+0x1d8/0x3c0 kernel/locking/lockdep.c:3113
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       console_trylock_spinning+0x10d/0x1d0 kernel/printk/printk.c:1921
       vprintk_emit+0x1a5/0x270 kernel/printk/printk.c:2134
       printk+0xb2/0xe7 kernel/printk/printk.c:2183
       lookup_object.cold+0xf/0x24 mm/kmemleak.c:405
       scan_block+0x1fa/0x220 mm/kmemleak.c:1357
       scan_object+0xdd/0x140 mm/kmemleak.c:1415
       scan_gray_list+0x8f/0x1c0 mm/kmemleak.c:1453
       kmemleak_scan+0x649/0xf30 mm/kmemleak.c:1608
       kmemleak_scan_thread+0x94/0xb6 mm/kmemleak.c:1721
       kthread+0x1c4/0x210 kernel/kthread.c:328
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:299

other info that might help us debug this:

Chain exists of:
  console_owner --> &port->lock --> kmemleak_lock

Cc: stable@vger.kernel.org # 5.10
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
---
 mm/kmemleak.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4801751cb6b6..d322897a1de1 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -390,9 +390,11 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
 		else if (object->pointer == ptr || alias)
 			return object;
 		else {
+			__printk_safe_enter();
 			kmemleak_warn("Found object by alias at 0x%08lx\n",
 				      ptr);
 			dump_object_info(object);
+			__printk_safe_exit();
 			break;
 		}
 	}
-- 
2.25.1


