Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAFB6CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D1F6B0027; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E986B002D; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D126B002B; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 572D66B002A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0630D1A01A8
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:01:41 +0000 (UTC)
X-FDA: 84156550002.11.09F557F
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52B6EA001F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:01:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lCyyQzXj;
	spf=pass (imf25.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HrE4rUXPZp1XpbiyX6WwgbU4cqV3RKFH7cwbdgk9P1g=;
	b=w/alT86air7LyLalUMIJvrLMdzQHRpFu49NPMpO1Ve/26nB4NIMtHxnEg/eH6u2FHeFkMH
	z5i9XVVFGvgVnB9BEFQ/9tSM6LEnayLt2UkSQ8Xt+TCNQGTItkti4RGzNSQC7Z1K4h0Ltm
	k6J54aid3ex5U5bnUX+Kk5mzmYFY5Z0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lCyyQzXj;
	spf=pass (imf25.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252099; a=rsa-sha256;
	cv=none;
	b=0TzSYJFudI9qgIMsTnkQY2Fj8OnzEUI9T7rthXdxd/RhkzjQkrDdI66FfadtGNC6E7cx+T
	Heq8QmjYCqmoSXGqMnrZ3/YGzwCKGZVgOBOAVBcrvPCOXSYzda5F9P9LCio7e0Rhow8d84
	Q72S35Nk/MRhaumd0ldlMcnGEXhXyCM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HrE4rUXPZp1XpbiyX6WwgbU4cqV3RKFH7cwbdgk9P1g=;
	b=lCyyQzXjxE9WjklT4d7Hh0khMwXm87ExzrIDAJYID/dXzRDZatbnwFJAlsX+KsW8hqjPGoHmJ
	y3tTWh7ufpuHPtsBebWigWmZYt4HtnbkvXCmBvpmOf+IvABTdDLIU1MBKXnAMACcy93EHuF8inh
	flxzzjfU9byFcB/hveSW7TY=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dHJ2k53jcz1K96R;
	Thu, 27 Nov 2025 21:59:42 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id B60CA1402C4;
	Thu, 27 Nov 2025 22:01:29 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 22:01:28 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <will@kernel.org>, <nico@fluxnic.net>,
	<rmk+kernel@armlinux.org.uk>, <linux@armlinux.org.uk>,
	<david.laight@runbox.com>, <rppt@kernel.org>, <vbabka@suse.cz>,
	<pfalcato@suse.de>, <brauner@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<kuninori.morimoto.gx@renesas.com>, <tony@atomide.com>, <arnd@arndb.de>,
	<bigeasy@linutronix.de>, <akpm@linux-foundation.org>,
	<punitagrawal@gmail.com>, <hch@lst.de>, <jack@suse.com>, <rjw@rjwysocki.net>,
	<marc.zyngier@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<wozizhi@huaweicloud.com>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<xieyuanbin1@huawei.com>, <pangliyuan1@huawei.com>,
	<wangkefeng.wang@huawei.com>
Subject: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when handling with page faults of kernel address
Date: Thu, 27 Nov 2025 22:01:08 +0800
Message-ID: <20251127140109.191657-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: y5jojyrop1e1g8ouptoorcmeoq7adinp
X-Rspam-User: 
X-Rspamd-Queue-Id: 52B6EA001F
X-Rspamd-Server: rspam09
X-HE-Tag: 1764252096-186635
X-HE-Meta: U2FsdGVkX198PJlZ8KF8eLqMGW4Qax/obYHlhKxoSg0KG2RJBaCSzEew7TqAyrpi2Ib0FVA/JoCYxighxIFTnS37cOp8QSpytYC4J3etds9iRaFWsdgFZA/NbYugupRQLZShhAKvOMRA7LixpZHBMSYp6LEs5rDSGQbD2UivA0fbKDkTVYDv2wmWeBg4EKoukqMg2QwWbI8yJZMzpylPxhs05/ObdVVCaxaknHiUd5c0OjmiwWesR1ynwBYeAMawvi1nrMX7uf16zRvU9a8bA8OvylEYeK03jukJ4BMUJuuux/a6Hn7xttM+38evOhOFj6VlVmlYcD6hphMK/4w9NoduIEh4o8DGBhnfhXQEMTKJ6REqPlZ6eVVl1bGJ+szmZYpXdTSv+Xb6gGJxfkc0lzhUkekGLgADVcyz5zF45rcVMZCDOF6Rzt0FizXVo2zlOMmE59rr8HUiBCHTS8AKEmxYOeknEQoU4wjIr496RZLNKk0ucm37eq3S9+YThwDofOBMQf+qHb2P52I5aS9FG0kp5k/1NDpMEsEAhkVilTQ689JqqgF1rGMq9u3m475C040mLo2teKNf7bJdYbTMQszpOcRpxfCkA3WPPYvCQTi3jUEkg+Qr6KfwgfXEspJkr9wr7VrXxbYol43Lgit1j3Q5hVgD+coL7M43igYuhTWQjHQ8qBtHkWidX2yItExYBQp/JDPbhe2EDPBG8PlG/FU61KzjypPOjJezK83ESeuxQcugeQEAvtZ8sRxM0vCNcF1l+g3REZehwk7wK0DdV4H6TDwDdkU5r9mGK4m12mwIsCbB4xPA1IvlgLd+halMkOd9pOAB93dMFLU7bCS9JfWmDTrqtiMPv3oLtwyVopp1a942HYqD83TQGZGkzDH6jVmc5wCcTr3jTjtEQjPTkG1Cqvks1u0IDgSBCX43M2bqeAUCFWSC9Tij+Vt/1Km5IRhuDe6YAklOVvvCgIJ
 SKKzhPw7
 aNup7Fm8c9oLA/YRKFdTvX3TM8xLgd95/FHdeI5I0hs8UgwnUWs/CgD0EJsuP0fRszaLmIWhFt6XFyCCVFjlOGMUjZ41y4tmkxF8idBnbrACMXty85nSyJCPSsL3B8Ie7uQo4dOTX5J95QK+KTV+/gpG12/aO75WIjOc+9RoM+w57HWPSPDsq34xeCGMWF1qYARLnlv2OuQXInCDCJZYERA4aILYxl/h6A74MBb6tEZANhQSn6fushqAgtjukyRuGa+MEj4Q5MhF4kBICv9SrqaZdWTSjGmPtKbCLxEaGiox/SgVAXV5lKQ7EqGf47AbqXv8FYFDlN/avdGCg8xU04NI+sqxpX37KgjyJ6Uxer7ajmuKsIxb0+VeYvfnU4pmq5CIaAFIP5OPvAmfkhoToQd0B8MPUqJ9x9JTaUBrS/RvdNbcfl9v/SYrUP9wPLk18qNgsRfvco2BD3tU6FvJFOdrRhJCe+GrfdttYhc+Lu+1Jt3aOLs5gqwyrmrVwGhmNg8CVXR8QePnuCfNIkKM5d5cYrcZvGOTvC2y2IT+A5wKV5W2VLBGsT4D0kN7cuLR44G6ewpp84R2zWUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two bugs are related to this patch.

BUG1:
On arm32, a page fault may cause the current thread to sleep inside
mmap_read_lock_killable(). This can happen even if the addr is a kernel
address.

When opening a file, if the path is initialized with LOOKUP_RCU flag in
path_init(), the rcu read lock will be acquired. Inside the rcu critical
section, load_unaligned_zeropad() may be called.

According to the comments of load_unaligned_zeropad(), when loading the
memory, a page fault may be triggered in the very unlikely case. When
CONFIG_KFENCE=y, page faults are more likely to occur in this scenario.

If CONFIG_PREEMPT_RCU=y, the following warning may be triggered:
```log
[   16.923630] WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0x408/0x610, CPU#0: test/68
[   16.924780] Voluntary context switch within RCU read-side critical section!
[   16.924887] Modules linked in:
[   16.925670] CPU: 0 UID: 0 PID: 68 Comm: test Tainted: G        W           6.18.0-rc6-next-20251124 #28 PREEMPT
[   16.926120] Tainted: [W]=WARN
[   16.926257] Hardware name: Generic DT based system
[   16.926474] Call trace:
[   16.926487]  unwind_backtrace from show_stack+0x10/0x14
[   16.926899]  show_stack from dump_stack_lvl+0x50/0x5c
[   16.927318]  dump_stack_lvl from __warn+0xf8/0x200
[   16.927696]  __warn from warn_slowpath_fmt+0x180/0x208
[   16.928060]  warn_slowpath_fmt from rcu_note_context_switch+0x408/0x610
[   16.928768]  rcu_note_context_switch from __schedule+0xe4/0xa58
[   16.928917]  __schedule from schedule+0x70/0x124
[   16.929197]  schedule from schedule_preempt_disabled+0x14/0x20
[   16.929514]  schedule_preempt_disabled from rwsem_down_read_slowpath+0x26c/0x4e4
[   16.929875]  rwsem_down_read_slowpath from down_read_killable+0x58/0x10c
[   16.930320]  down_read_killable from mmap_read_lock_killable+0x24/0x84
[   16.930761]  mmap_read_lock_killable from lock_mm_and_find_vma+0x164/0x18c
[   16.931101]  lock_mm_and_find_vma from do_page_fault+0x1d4/0x4a0
[   16.931354]  do_page_fault from do_DataAbort+0x30/0xa8
[   16.931649]  do_DataAbort from __dabt_svc+0x44/0x60
[   16.931862] Exception stack(0xf0b41d88 to 0xf0b41dd0)
[   16.932063] 1d80:                   c3219088 eec5dffd f0b41ec0 00000002 c3219118 00000010
[   16.933732] 1da0: c321913c 00000002 00007878 c2da86c0 00000000 00000002 b8009440 f0b41ddc
[   16.934019] 1dc0: eec5dffd c0677300 60000013 ffffffff
[   16.934294]  __dabt_svc from __d_lookup_rcu+0xc4/0x10c
[   16.934468]  __d_lookup_rcu from lookup_fast+0xa0/0x190
[   16.934720]  lookup_fast from path_openat+0x154/0xe18
[   16.934953]  path_openat from do_filp_open+0x94/0x134
[   16.935141]  do_filp_open from do_sys_openat2+0x9c/0xf0
[   16.935384]  do_sys_openat2 from sys_openat+0x80/0xa0
[   16.935547]  sys_openat from ret_fast_syscall+0x0/0x4c
[   16.935799] Exception stack(0xf0b41fa8 to 0xf0b41ff0)
[   16.936007] 1fa0:                   00000000 00000000 ffffff9c beb27d0c 00000242 000001b6
[   16.936293] 1fc0: 00000000 00000000 000c543c 00000142 00027e85 00000002 00000002 00000000
[   16.936624] 1fe0: beb27c20 beb27c0c 0006ea80 00072e78
[   16.936780] ---[ end trace 0000000000000000 ]---
```

If CONFIG_DEBUG_ATOMIC_SLEEP=y, the following warning will be triggered:
```log
[   16.243462] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1559
[   16.245271] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 68, name: test
[   16.246219] preempt_count: 0, expected: 0
[   16.246582] RCU nest depth: 1, expected: 0
[   16.247262] CPU: 0 UID: 0 PID: 68 Comm: test Not tainted 6.18.0-rc6-next-20251124 #28 PREEMPT
[   16.247432] Hardware name: Generic DT based system
[   16.247549] Call trace:
[   16.247618]  unwind_backtrace from show_stack+0x10/0x14
[   16.248442]  show_stack from dump_stack_lvl+0x50/0x5c
[   16.248458]  dump_stack_lvl from __might_resched+0x174/0x188
[   16.248475]  __might_resched from down_read_killable+0x18/0x10c
[   16.248490]  down_read_killable from mmap_read_lock_killable+0x24/0x84
[   16.248504]  mmap_read_lock_killable from lock_mm_and_find_vma+0x164/0x18c
[   16.248516]  lock_mm_and_find_vma from do_page_fault+0x1d4/0x4a0
[   16.248529]  do_page_fault from do_DataAbort+0x30/0xa8
[   16.248549]  do_DataAbort from __dabt_svc+0x44/0x60
[   16.248597] Exception stack(0xf0b41da0 to 0xf0b41de8)
[   16.248675] 1da0: c20b34f0 c3f23bf8 00000000 c389be50 f0b41e90 00000501 61c88647 00000000
[   16.248698] 1dc0: 80808080 fefefeff 2f2f2f2f eec51ffd c3219088 f0b41df0 c066d3e4 c066d218
[   16.248705] 1de0: 60000013 ffffffff
[   16.248736]  __dabt_svc from link_path_walk+0xa8/0x444
[   16.248752]  link_path_walk from path_openat+0xac/0xe18
[   16.248764]  path_openat from do_filp_open+0x94/0x134
[   16.248775]  do_filp_open from do_sys_openat2+0x9c/0xf0
[   16.248785]  do_sys_openat2 from sys_openat+0x80/0xa0
[   16.248806]  sys_openat from ret_fast_syscall+0x0/0x4c
[   16.248814] Exception stack(0xf0b41fa8 to 0xf0b41ff0)
[   16.248825] 1fa0:                   00000000 00000000 ffffff9c beb27d0c 00000242 000001b6
[   16.248834] 1fc0: 00000000 00000000 000c543c 00000142 00027e85 00000002 00000002 00000000
[   16.248841] 1fe0: beb27c20 beb27c0c 0006ea80 00072e78
```

BUG2:
When a user program try to access any valid kernel address and attacks
the kernel, it may run into the do_page_fault(). Before
harden_branch_predictor(), the thread might be migrated to another cpu,
which causes the mitigation meaningless.

If CONFIG_PREEMPT=y, CONFIG_DEBUG_PREEMPT=y, CONFIG_ARM_LPAE=y,
the following warning will be triggered:
```log
[    1.089103] BUG: using smp_processor_id() in preemptible [00000000] code: init/1
[    1.093367] caller is __do_user_fault+0x20/0x6c
[    1.094355] CPU: 0 UID: 0 PID: 1 Comm: init Not tainted 6.14.3 #7
[    1.094585] Hardware name: Generic DT based system
[    1.094706] Call trace:
[    1.095211]  unwind_backtrace from show_stack+0x10/0x14
[    1.095329]  show_stack from dump_stack_lvl+0x50/0x5c
[    1.095352]  dump_stack_lvl from check_preemption_disabled+0x104/0x108
[    1.095448]  check_preemption_disabled from __do_user_fault+0x20/0x6c
[    1.095459]  __do_user_fault from do_page_fault+0x334/0x3dc
[    1.095505]  do_page_fault from do_DataAbort+0x30/0xa8
[    1.095528]  do_DataAbort from __dabt_usr+0x54/0x60
[    1.095570] Exception stack(0xf0825fb0 to 0xf0825ff8)
```

Always goto bad_area before local_irq_enable() to handle these two
scenarios, just like what x86 does.

Fixes: b9a50f74905a ("ARM: 7450/1: dcache: select DCACHE_WORD_ACCESS for little-endian ARMv6+ CPUs")
Fixes: f5fe12b1eaee ("ARM: spectre-v2: harden user aborts in kernel space")

Closes: https://lore.kernel.org/20251126090505.3057219-1-wozizhi@huaweicloud.com
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Co-developed-by: Liyuan Pang <pangliyuan1@huawei.com>
Signed-off-by: Liyuan Pang <pangliyuan1@huawei.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
V1->V2: https://lore.kernel.org/20251126101952.174467-1-xieyuanbin1@huawei.com
  - Fix the bug in arm/mm, instead of vfs
  - Update git message
  - Also fix https://lore.kernel.org/20251016121622.8957-1-xieyuanbin1@huawei.com

For this patch, the only thing I'm unsure about is `if (fsr & FSR_LNX_PF)`.
I'm not sure whether skipping this check might have some side effects.
This patch also skips local_irq_enable() when addr >= TASK_SIZE, but I
think it is ok, __do_kernel_fault() can be called with interrupts
disabled, and both do_bad_area() and do_sect_fault() do this.

Test cases for reproduction:
kernel source: latest linux-next branch, use default arm32's
multi_v7_defconfig, and setting CONFIG_PREEMPT=y, CONFIG_DEBUG_PREEMPT=y,
CONFIG_ARM_LPAE=y, CONFIG_KFENCE=y, CONFIG_DEBUG_ATOMIC_SLEEP=y,
CONFIG_ARM_PAN=n.

BUG1:
```c
static void *thread(void *arg)
{
	while (1) {
		void *p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);

		assert(p != (void *)-1);
		__asm__ volatile ("":"+r"(p)::"memory");

		munmap(p, 4096);
	}
}

int main(void)
{
	pthread_t th;
	int ret;
	char path[4096] = "/tmp";

	for (size_t i = 0; i < 2044; ++i) {
		strcat(path, "/x");
		ret = mkdir(path, 0755);
		assert(ret == 0 || errno == EEXIST);
	}
	strcat(path, "/xx");

	assert(strlen(path) == 4095);

	assert(pthread_create(&th, NULL, thread, NULL) == 0);

	while (1) {
		FILE *fp = fopen(path, "wb+");

		assert(fp);
		fclose(fp);
	}
	return 0;
}
```

BUG2:
```c
static void han(int x)
{
	while (1);
}

int main(void)
{
	signal(SIGSEGV, han);
	/* 0xc0331fd4 is just a kernel address in kernel .text section */
	__asm__ volatile (""::"r"(*(int *)(uintptr_t)0xc0331fd4):"memory");
	while (1);
	return 0;
}
```

 arch/arm/mm/fault.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2bc828a1940c..5c58072d8235 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -270,10 +270,15 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	vm_flags_t vm_flags = VM_ACCESS_FLAGS;
 
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
 
+	if (unlikely(addr >= TASK_SIZE)) {
+		fault = 0;
+		code = SEGV_MAPERR;
+		goto bad_area;
+	}
 
 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))
 		local_irq_enable();
 
-- 
2.51.0


