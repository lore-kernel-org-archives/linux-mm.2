Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6C4EA4FD8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421506B0005; Mon, 23 Feb 2026 10:57:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9826B0089; Mon, 23 Feb 2026 10:57:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8BB6B008A; Mon, 23 Feb 2026 10:57:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABDD6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:57:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4A27C101B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:57:00 +0000 (UTC)
X-FDA: 84476175000.11.E97C63D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id E73E21C0015
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:56:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YmQ26XTa;
	spf=pass (imf20.hostedemail.com: domain of 00107082@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a99//l3K6zKrDpCm+Dc4DQDPkK2GepEOstGf4xuYHXk=;
	b=GMKy07K7CWRVDThEdHt5ep/XXOkMCYQyxT49GuPiOhKb+FIjdb5SiKrTuz+nV6vNaLtR3Z
	RzEyohcGxdmSrWGs/qeghP6UsmepEIny6XM3pVwdFJrw+qCA9RVQ6j6cD2GWsNexGcBUJz
	nEWKCazQA//BHHgb9OghtAes/cAknRE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YmQ26XTa;
	spf=pass (imf20.hostedemail.com: domain of 00107082@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862219; a=rsa-sha256;
	cv=none;
	b=fWf8NZWJxiRYq3tC0xJLqsKvjJ4qjsjHMP1u25BVb8KDerwwitMacT7puaZJcH/5Uw/jeF
	shnlOaa5VdvPyoIoiXBVgIkrlqIAcXebL5EBHyeOEA73gRjyBbBuUqy6vPRSjgad69yVxB
	dUHjSYECIFaj/jqJ3bqr1XAc1LfZVnE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=a9
	9//l3K6zKrDpCm+Dc4DQDPkK2GepEOstGf4xuYHXk=; b=YmQ26XTaC4SO3NDj8i
	WzEQQ4JsOP6B/nt/gC9ll6WyhhPCulq/h32D1v79FbNW/7hTG13XmZsKC8u9FCu/
	Z9jHKM7Nd2oNe2VR3ok2l52o0VhpyscMF8DjWtOgi4yWnCRxxtikEZ7+BZR03jzS
	/x/hK2bszbYyrMEjvAij+2anA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wAnIbiAd5xpgVgiMg--.34837S4;
	Mon, 23 Feb 2026 23:51:44 +0800 (CST)
From: David Wang <00107082@163.com>
To: surenb@google.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during boot
Date: Mon, 23 Feb 2026 23:51:28 +0800
Message-ID: <20260223155128.3849-1-00107082@163.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnIbiAd5xpgVgiMg--.34837S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxtr17Cry3uw13ZFyDGry3urg_yoWDXr4xpr
	yag3WUGr4kJr1DXw4UJw1Ykr1UKFs5A3W7Ww4xCrn7XFs8Ww1UJFyUArWjyr9rJr4Uuay7
	t3Z8Xw1Fq34UtaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UEjgsUUUUU=
X-Originating-IP: [111.35.188.114]
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbCxRKDLmmcd5IGfwAA3T
X-Rspam-User: 
X-Rspamd-Queue-Id: E73E21C0015
X-Rspamd-Server: rspam02
X-Stat-Signature: 3gpp887416fkz7nyy95rogehuty76jkj
X-HE-Tag: 1771862217-235119
X-HE-Meta: U2FsdGVkX1/A1k2ia3rZgz4rtEaWOEW5Kpq1rT4Z+DIbc7G6giiadxAJDguOx5pEn5u6WF1htyQ/b6UKG0L7vbrCNc/gqp8c2/B3sUYXXfvGVpht27UNoiUWelTaQot34iLBcyzahv+rkkT8QpXLxyqqK4ajNOqL+QKVzc4ba/PMixELDoRknXcROIu2/gm+itDUIVBDySOaNMrQSvSJQliYJpwMnLMkkZvnhgYbJxvq8Sk6ugTWKpFtP/NUVYmac8my0YPQvne+OFCOD/hr90itwvFrP7FMDZLlzMZYe1gK9ux+e4KZinIC49QIoQqRsExJE1wkfscCW+NQymIgwCwPcGM3q1le5ezufCXYYkxXzoa42G7gRBozBN+LpnJNMIbROeqT/ZvJs0l7yUxSJTrBvDJYu+f1MThhqVFUDjQHTDKOlQ1BVXdixl+cNxP6B1h0wUOczC7qpSa9naJORGvl8Tp9PsAzke95TYIUEkfgwblUbuxnMyaNCyTgo5mbJZ3XmouPi/pefW1mb/O4/58qkqrjVroG0e8U2grNqQyXwGdtFXGDiHiKYveleup831N62hpbmnqA8CtENmI9ySkKlUFxYiVG58O0PX7T2ht3cB1Ew1++R941ddj9u8RgE+FI6EpcyAR2rLRisLHiariwtnrzOuf6ivdm6lSErRuufZOIlujr0TN8dLvHvt4wK0G0prWly0YiHWI9OAnD53/csrd93QTPBOSFBDMQsc1/djYB09ZyMsLneYzc5si19uiA6dGwdLLy86Z16jH/jGy56YOYyabkGK0GeHqqemlmRjxIuu1ZYFngQr02N/GSO//xQQ9KupyrI13qTaTElyI2aCSkIt/fWCh9ZuaTh+m+TmZpu99HcOA3U4b12Pxw9TNyjjtS7BSOCyKD7PhFSEh/MFVvC6Sl1GGMXVPjVM32H2zf6CzurMmC1wgXrkIkr1AwE1UQyMKoGcw27Qx
 T3PBxr9r
 4kI8EFj1UtemGCyKAsh5bkrdRtfhl+sSAUmYdLl7tVSKH1I6k9d5wPmwvWM3NLileLS5kN0mQ6sFvwlRJZ3iuJPQsmOT3kmccwzEv3yX+MDWXSrgmhoxzbHn62bZLk4HdVjrGi7/JJrHAqEoXm2DPc3EBM4sAZp0BmTAsvMNwRyhdwkcBQ4fHSuq4EqbnyskvpUf4gexMkXJVnw3pn1aJaHWJf25giCrmwT0R0+pCy7hEuJzRh9bkUoU2Iz8YY/RfpgLpe6szoraDNEFLPoa1wWbrMO086Y/x+WKkYXwfknTfeUPdcw80cfkDOCdexfqX2FrSUHN4H8OYPw0F8bJnXD54MT9yr04rmlFFFLXPE4+6TMkdDHu5uZAKzl2atVkPhbVVYn3TgeOgAtfJcispDNOKPu7GCSv48a5fvvWUehk9Ttg90hJvwhGvb2ttMt3leRFCktYJY2vy8ZC6w+D+B+tC/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

When upgrade to 7.0.0-rc1, caught a kernel WARN during boot:

	 ------------[ cut here ]------------
	 alloc_tag was not set
	 WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook+0xe6/0x120, CPU#4: (udev-worker)/145
	 Modules linked in: xhci_pci(E+) ahci(E) libahci(E) xhci_hcd(E) nvme(E) sp5100_tco(E) libata(E) r8169(E) realtek(E) usbcore(E) nvme_core(E) scsi_mod(E) scsi_common(E) usb_common(E) i2c_piix4(E) i2c_smbus(E) wmi(E) fjes(E-) gpio_amdpt(E) gpio_generic(E) button(E) efivarfs(E)
	 CPU: 4 UID: 0 PID: 145 Comm: (udev-worker) Tainted: G            E       7.0.0-rc1-linan-0 #802 PREEMPT(full) 
	 Tainted: [E]=UNSIGNED_MODULE
	 Hardware name: Micro-Star International Co., Ltd. MS-7B89/B450M MORTAR MAX (MS-7B89), BIOS 2.L0 07/18/2024
	 RIP: 0010:__alloc_tagging_slab_free_hook+0xe6/0x120
	 Code: 2c d3 e8 0f af c2 4c 01 f0 48 89 c3 74 9e 48 8b 00 41 8b 54 24 18 48 85 c0 0f 85 6c ff ff ff 89 54 24 04 48 8d 3d da 4e 44 01 <67> 48 0f b9 3a 48 8b 03 8b 54 24 04 48 85 c0 0f 85 4c ff ff ff 48
	 RSP: 0018:ffffd28e40278e80 EFLAGS: 00010246
	 RAX: 0000000000000000 RBX: ffff8c36422d82c0 RCX: 0000000000000008
	 RDX: 0000000000000200 RSI: fffff352840bb800 RDI: ffffffffadc4aee0
	 RBP: ffffd28e40278ec8 R08: 0000000000000014 R09: ffffffffac80e09c
	 R10: ffff8c3640042200 R11: ffff8c364dca2480 R12: ffff8c3640042a00
	 R13: fffff352840bb800 R14: ffff8c36422d8200 R15: ffffd28e40278ed0
	 FS:  00007fa2ca8be980(0000) GS:ffff8c39c0c1a000(0000) knlGS:0000000000000000
	 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	 CR2: 00007fa2c9b727a5 CR3: 00000001158cc000 CR4: 0000000000350ef0
	 Call Trace:
	  <IRQ>
	  ? rcu_core+0x451/0x750
	  kfree+0xab/0x370
	  rcu_core+0x451/0x750
	  ? rcu_core+0x3eb/0x750
	  ? srso_return_thunk+0x5/0x5f
	  handle_softirqs+0x100/0x2e0
	  __irq_exit_rcu+0xb1/0x100
	  sysvec_apic_timer_interrupt+0x9d/0xc0
	  </IRQ>
	  <TASK>
	  asm_sysvec_apic_timer_interrupt+0x16/0x20
	 RIP: 0010:xhci_handshake+0x56/0xc0 [xhci_hcd]
	 Code: fa 8b 07 89 f1 49 89 fe 41 89 f5 21 c1 41 39 cc 75 22 eb 3c f3 90 48 81 eb e9 03 00 00 48 89 da 48 c1 ea 3f 44 21 fa 41 8b 06 <44> 89 e9 21 c1 44 39 e1 74 1c 83 f8 ff 74 2d 84 d2 75 3d bf c7 10
	 RSP: 0018:ffffd28e4045f9d0 EFLAGS: 00000246
	 RAX: 0000000000000002 RBX: 000000025354e082 RCX: 0000000000000004
	 RDX: 0000000000000000 RSI: 0000000000000df4 RDI: 00000014243ef470
	 RBP: 0000000000989680 R08: ffffffffc0741fbe R09: 00000000ffffffff
	 R10: 0000000000000004 R11: 0000000000000001 R12: 0000000000000000
	 R13: 0000000000000002 R14: ffffd28e40cc8020 R15: ffff8c3655ac1801
	  ? __pfx_xhci_pci_quirks+0x10/0x10 [xhci_pci]
	  xhci_reset+0x6a/0x110 [xhci_hcd]
	  xhci_gen_setup+0x201/0x450 [xhci_hcd]
	  xhci_pci_setup+0x50/0x1c0 [xhci_pci]
	  usb_add_hcd.cold+0x265/0x5d5 [usbcore]
	  usb_hcd_pci_probe+0x16f/0x420 [usbcore]
	  xhci_pci_common_probe+0x39/0x2c0 [xhci_pci]
	  ? srso_return_thunk+0x5/0x5f
	  local_pci_probe+0x41/0x90
	  pci_device_probe+0xd0/0x250
	  ? srso_return_thunk+0x5/0x5f
	  ? sysfs_do_create_link_sd+0x6e/0xe0
	  really_probe+0xde/0x380
	  ? pm_runtime_barrier+0x56/0x90
	  __driver_probe_device+0x78/0x120
	  driver_probe_device+0x1f/0xa0
	  __driver_attach+0xf6/0x230
	  ? __pfx___driver_attach+0x10/0x10
	  bus_for_each_dev+0x79/0xd0
	  bus_add_driver+0xeb/0x270
	  driver_register+0x6e/0xc0
	  ? __pfx_xhci_pci_init+0x10/0x10 [xhci_pci]
	  do_one_initcall+0x43/0x310
	  ? srso_return_thunk+0x5/0x5f
	  ? __kmalloc_cache_noprof+0x143/0x3f0
	  ? do_init_module+0x3f/0x280
	  do_init_module+0x91/0x280
	  init_module_from_file+0xc8/0xe0
	  idempotent_init_module+0xfe/0x2f0
	  __x64_sys_finit_module+0x6d/0xe0
	  do_syscall_64+0xf4/0xf20
	  entry_SYSCALL_64_after_hwframe+0x76/0x7e
	 RIP: 0033:0x7fa2cb41a779
	 Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48
	 RSP: 002b:00007ffe556d6b18 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
	 RAX: ffffffffffffffda RBX: 000055b03b330950 RCX: 00007fa2cb41a779
	 RDX: 0000000000000000 RSI: 00007fa2c9b9e44d RDI: 000000000000001f
	 RBP: 0000000000000000 R08: 0000000000000000 R09: 000055b03b2fed30
	 R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa2c9b9e44d
	 R13: 0000000000020000 R14: 000055b03b3242e0 R15: 0000000000000000
	  </TASK>
	 ---[ end trace 0000000000000000 ]---

The second time I boot my system, I got the same warning but different call stacks:	
	 ------------[ cut here ]------------
	 alloc_tag was not set
	 WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook+0xe6/0x120, CPU#0: ksoftirqd/0/14
	 Modules linked in: xhci_pci(E+) ahci(E+) r8169(E+) nvme(E) libahci(E) xhci_hcd(E) realtek(E) libata(E) i2c_piix4(E) nvme_core(E) i2c_smbus(E) usbcore(E) scsi_mod(E) usb_common(E) scsi_common(E) wmi(E) fjes(E-) gpio_amdpt(E) gpio_generic(E) button(E) efivarfs(E)
	 CPU: 0 UID: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G            E       7.0.0-rc1-linan-0 #802 PREEMPT(full) 
	 Tainted: [E]=UNSIGNED_MODULE
	 Hardware name: Micro-Star International Co., Ltd. MS-7B89/B450M MORTAR MAX (MS-7B89), BIOS 2.L0 07/18/2024
	 RIP: 0010:__alloc_tagging_slab_free_hook+0xe6/0x120
	 Code: 2c d3 e8 0f af c2 4c 01 f0 48 89 c3 74 9e 48 8b 00 41 8b 54 24 18 48 85 c0 0f 85 6c ff ff ff 89 54 24 04 48 8d 3d da 4e 44 01 <67> 48 0f b9 3a 48 8b 03 8b 54 24 04 48 85 c0 0f 85 4c ff ff ff 48
	 RSP: 0018:ffffd362c0137d48 EFLAGS: 00010246
	 RAX: 0000000000000000 RBX: ffff8b718006c610 RCX: 0000000000000008
	 RDX: 0000000000000200 RSI: fffffa5884001900 RDI: ffffffffa184aee0
	 RBP: ffffd362c0137d90 R08: 0000000000000001 R09: ffffffffa040e09c
	 R10: ffff8b7180042700 R11: ffff8b7183b47440 R12: ffff8b7180042a00
	 R13: fffffa5884001900 R14: ffff8b718006c600 R15: ffffd362c0137d98
	 FS:  0000000000000000(0000) GS:ffff8b750ce1a000(0000) knlGS:0000000000000000
	 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	 CR2: 0000560882dbc058 CR3: 0000000107e6f000 CR4: 0000000000350ef0
	 Call Trace:
	  <TASK>
	  ? rcu_core+0x451/0x750
	  kfree+0xab/0x370
	  rcu_core+0x451/0x750
	  ? rcu_core+0x3eb/0x750
	  ? srso_return_thunk+0x5/0x5f
	  ? try_to_wake_up+0xaf/0x740
	  handle_softirqs+0x100/0x2e0
	  run_ksoftirqd+0x37/0x50
	  smpboot_thread_fn+0x114/0x2a0
	  ? __pfx_smpboot_thread_fn+0x10/0x10
	  kthread+0x114/0x150
	  ? __pfx_kthread+0x10/0x10
	  ret_from_fork+0x238/0x330
	  ? __pfx_kthread+0x10/0x10
	  ret_from_fork_asm+0x1a/0x30
	  </TASK>
	 ---[ end trace 0000000000000000 ]---

Bisect narrows it down to 913ffd3a1b(slab: handle kmalloc sheaves bootstrap)

	$ git bisect log
	git bisect start
	# status: waiting for both good and bad commits
	# good: [05f7e89ab9731565d8a62e3b5d1ec206485eeb0b] Linux 6.19
	git bisect good 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
	# status: waiting for bad commit, 1 good commit known
	# bad: [6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f] Linux 7.0-rc1
	git bisect bad 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
	# bad: [6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f] Linux 7.0-rc1
	git bisect bad 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
	# good: [939faf71cf7ca9ab3d1bd2912ac0e203d4d7156a] Merge tag 'drm-next-2026-02-11' of https://gitlab.freedesktop.org/drm/kernel
	git bisect good 939faf71cf7ca9ab3d1bd2912ac0e203d4d7156a
	# bad: [c87c79345ea8ff917354e9223d44034e4aef2690] Merge tag 'uml-for-7.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/uml/linux
	git bisect bad c87c79345ea8ff917354e9223d44034e4aef2690
	# good: [83310d613382f74070fc8b402f3f6c2af8439ead] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
	git bisect good 83310d613382f74070fc8b402f3f6c2af8439ead
	# bad: [541c43310e85dbf35368b43b720c6724bc8ad8ec] Merge tag 'fs_for_v6.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
	git bisect bad 541c43310e85dbf35368b43b720c6724bc8ad8ec
	# bad: [1c2b4a4c2bcb950f182eeeb33d94b565607608cf] Merge tag 'pci-v7.0-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci
	git bisect bad 1c2b4a4c2bcb950f182eeeb33d94b565607608cf
	# bad: [61e629596fabd7f60cc3748a603703c5d9b58428] Merge tag 'for-7.0/dm-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
	git bisect bad 61e629596fabd7f60cc3748a603703c5d9b58428
	# bad: [148f95f75c513936d466bcc7e6bf73298da2212b] Merge tag 'slab-for-7.0' of git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab
	git bisect bad 148f95f75c513936d466bcc7e6bf73298da2212b
	# good: [41f1a08645abb5ef7d2a3ed8835c747334878774] Merge tag 'kbuild-7.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux
	git bisect good 41f1a08645abb5ef7d2a3ed8835c747334878774
	# bad: [6c2f307f30edbe2b18a35584f01854a27e375927] slab: remove unused PREEMPT_RT specific macros
	git bisect bad 6c2f307f30edbe2b18a35584f01854a27e375927
	# good: [f3421f8d154cc0906da145299c72f4a7f046ffde] slab: introduce percpu sheaves bootstrap
	git bisect good f3421f8d154cc0906da145299c72f4a7f046ffde
	# bad: [e323b52cf00ffc3f5ac79420af7ab340b4576a5c] slab: remove SLUB_CPU_PARTIAL
	git bisect bad e323b52cf00ffc3f5ac79420af7ab340b4576a5c
	# bad: [913ffd3a1bf5d154995c6cfab44994b07b3c103f] slab: handle kmalloc sheaves bootstrap
	git bisect bad 913ffd3a1bf5d154995c6cfab44994b07b3c103f
	# good: [f1427a1d64156bb88d84f364855c364af6f67a3b] slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
	git bisect good f1427a1d64156bb88d84f364855c364af6f67a3b
	# first bad commit: [913ffd3a1bf5d154995c6cfab44994b07b3c103f] slab: handle kmalloc sheaves bootstrap



FYI
David


