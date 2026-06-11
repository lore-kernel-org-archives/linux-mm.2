Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B902CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D072A6B0005; Thu, 11 Jun 2026 16:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6E16B0088; Thu, 11 Jun 2026 16:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCCD6B008C; Thu, 11 Jun 2026 16:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD1BD6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:24:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 305731A0834
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:24:12 +0000 (UTC)
X-FDA: 84868758744.23.AA7D35F
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id 601881A0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:24:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3aRkragkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3aRkragkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781209450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=9grvKRD1snOVoU/w8AWVaOix9sWh6XIsSpdq1MW8cvg=;
	b=sjtamxjsSwpCFafSnMiAsoRFe0sCBDwa2OvTaeyEuUjdb0JPSU9rmX/xivtlgOidocXfv5
	NmkDUjlNNruHYDI6djy8PdN4lG0JUVb4KlKGOzrOsd5rR1Fhgi6eX4yWTbWRnMhS0NDgyP
	10nbR7b0kNKa22U66MJjR28jn0ddGjM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3aRkragkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3aRkragkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781209450;
	b=X+z/Xj2dOio0ecRf4kvwPVV4N91re9KoisfBp8VK7TbLWkiy8oGSZX6S0NMFtb8zl20XA+
	GMl2t6lfGZpDtYaTu7WvufOrICTwGoCHucnuuH0Qo4UqUfvXDTA8RGBj8/BCJpowA4NJAY
	NxM7uU8ebQokkgxMHjFOLZKiUp65oE0=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-486e64c8edeso386981b6e.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781209449; x=1781814249;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9grvKRD1snOVoU/w8AWVaOix9sWh6XIsSpdq1MW8cvg=;
        b=NaDq0+8pSCi7WHRk8fnqq6WgytpCJR66ZPpXcOXBzwmS5CQ44Ni5zS/raHxS7ZEfJ7
         M0A/2jgYkax4GkIkueIHVwM2BYnsZRshzDkuWmE3l3+8Uz0vk7saLIWGF+Frsc6FFPcG
         2acxbRpQOFNoh7PvqU0YPccrPGeboHIOwFMnRWZpfk4eDFlPXI1v8+JuCRXWGS2i4zKz
         FPMEzSIat199irAjVuS/uW2hQ1HidNWG5fDPWB5HreA//EtnVWX4d/D3yKvtt7qb/KMt
         xQW5cFJTf6D1nqrQWjBR3I3ZHyNWXPvBoUDcnjL9bl9BHXOscldSt58kJYWIBmvPQHE7
         xoXA==
X-Forwarded-Encrypted: i=1; AFNElJ8NEJdSZdOjkXg1q9jMYEhDIyx1UqWBZiM1MqALf92+Q/cKuZ7Pj6Lya7tyhVeqXKraiUdGJsnXZQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1Jl0gQ5ovaLShUFir3rmkuZwiiyveM9Pbu5vKeU458Pz/26F1
	2Wlvfyw/3p+DyAekgvcgRRrYNVPYpV2WL/UDTEiZuwhOZBtHqkMIg+BAvAvQ8Q9GUPdKVr2n0G7
	d1Aq51giD1k6B9prCLr/k+OG6nt39Yk5Qiqig0Ek6Z+ePPoXOaDYOBCftAjU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81c5:b0:69e:3dde:869d with SMTP id
 006d021491bc7-69ecae5274emr3358153eaf.23.1781209449321; Thu, 11 Jun 2026
 13:24:09 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:24:09 -0700
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2b1969.5d79d3ce.e8697.0000.GAE@google.com>
Subject: [syzbot ci] Re: mm: split the file's i_mmap tree for NUMA
From: syzbot ci <syzbot+ci1ee4d53eb174bb4c@syzkaller.appspotmail.com>
To: acme@kernel.org, adrian.hunter@intel.com, akpm@linux-foundation.org, 
	alexander.shishkin@linux.intel.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, 
	brian.ruley@gehealthcare.com, corbet@lwn.net, dave.anglin@bell.net, 
	david@kernel.org, deller@gmx.de, dev.jain@arm.com, dinguyen@kernel.org, 
	djbw@kernel.org, fangbaoshun@hygon.cn, harry@kernel.org, huangsj@hygon.cn, 
	irogers@google.com, jack@suse.cz, james.bottomley@hansenpartnership.com, 
	james.clark@linaro.org, jannh@google.com, jolsa@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, linmiaohe@huawei.com, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-parisc@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux@armlinux.org.uk, ljs@kernel.org, mark.rutland@arm.com, 
	mhiramat@kernel.org, mhocko@suse.com, mingo@redhat.com, mjguzik@gmail.com, 
	muchun.song@linux.dev, namhyung@kernel.org, nao.horiguchi@gmail.com, 
	npache@redhat.com, nvdimm@lists.linux.dev, oleg@redhat.com, osalvador@suse.de, 
	peterz@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bahp1tfjeybobkpkwdmb88148xbe5cog
X-Rspamd-Queue-Id: 601881A0005
X-HE-Tag: 1781209450-741196
X-HE-Meta: U2FsdGVkX19WaUksqhzLDLRx/UrDr8FdIpGcNibX6p80YmSBLP42mYy9qzOwSiJSArhZvE8bZt8OplnQdDdLfLfd34LW117FHnVcQlatY966DmSJM0of5WuZu9my/nF1eU79yiVAlsTn7FI2x9DBiEUJirPX3l8gHWspmNfFFI7rjjLDtUZdFT61X9u2p2PmgasZPuAPvoIlFL4ykVF2ONIElD8oe0qCLtVMGR3gynMj4M6OYuN9ku3tAyuIB5mBQrYLa2UtMhWdImf+WO+7pK1P994+6AR7S6CLd9vf709fnfUQdX32Hyb1tP8z2o2SD6iCrDl/jIsgNa4yMJgXanIyB5Xl/YQXqLC2Q+PowT8mOSxGICccSZXzIJp69qfRZaCWPdsRahvorrmT1EJe1gyTnyv/PLufnJaRcqaQhUtnROB2sAZurj+6jVTpob2iX/38n3cr6Pn1gr6VS+705U+2I6Gjpv1SpCV4FGFcepjY9jjRANvWI/ZtQepgq+6suEWHhrbzh05Pagy/8QVoBxHenIoI3/k84KFvFJwjbGl3c3hCu2bO+ezs2LxivtsjZeowEl1nZcJLrbZc0CdWftHJQ0FLJ/uORoYOpp5YHXtuYf4tPnHGIUTU8smPleWah6skmkWsKyi5TRNeMmstcSWXZLpLEr76QpxEfyz4SghlI4s4j+Mwm2S85LVBC1YXUxUju4Uu2ragdqQHmYXHnzeUcPWxJzZaoiFTkZDGutWZqOh/YTglPmgQ2PzDptECrp1e09MyQ3Jn4pcc2UVPaFYRnQ3eAZyg4mCbGPgtx6lWgN3uBtsq+0agxkAZzHwtgOvYudSCaIYSyjD8xOT78hBZI/ZE3uzcghYdU82oISgXMCktnIHng0UnFdqAieFzkO1JjjRNgafMo5sLScvDccNmVtUUpd8xGv14O70d4JXmTTQySoPWjolhZ1LKM8vacndISc6AzI8mzlKiu8R
 5Zj+nNUA
 ya3iWJJ9L3eAifnJUIAxv0vowbD2yNcpwLWz3ilFNd8bTPHBPhbF681BFBLaREdSeTH2/zJ54YUoMGK2SpOjtuiS/jpJsfkhDj7DmtPmzR0y2tbi1BnMk1cVF9tuCGCurNiFicP1j4YtBF06ave9yrBp0iwjbKJmuTDpR49qCyyMre1uFB1dVXX85Mu+iVIgr/1lmVtBXyUBKxa9sIxQLLu8nXqRP1741G7P4B8NZjXr8Q4oktm4UNSUzDUY9xCo9/kw8tfzOETQhX4jfLoYJLop5jvlqzdSe6n1hJca4I/0HoTCvYuP8SxJ8+EmdY060fdqJPgPMAPqJxMdXDQKHPOshM1fxTUHQx1L4ErgimEU17PfyyWLL2zKke4X6gPoZwBatm0q+W2WuGkP2XcrntQ4S6H2ObAjzPxWPOcr8EgxOhTRT94oWbGip2+azarWSRGaMtcfa1aTiHKyKeqbjT0GBd7sJLM3yVsUb8a6HYhIAiLSFAErW5RiCvgIyj3uyaofB7Rwe4PrBf2Fp2nrPdRBjYMWacxRJgucluRvUBX0D6AsoWmQZfB1O5rUa86R5qHr3AAYcw50UsYB8CkMR/e3p0KcQQvXhzYGPLBKdt/IWvJYRtY5MymEzhUEa7iTIamIS+t6T6JjpOOarIXM5ib58l0FOX2LtVL4+Y6cbxxU1uFttte74tqj4VbKo2RwvFI6ovZhlgiXDpAVrE485I+9HeHjR5PQDn0x0Zs/NlfOujtqcELcsW33vNnKv5Yca/YPawAzI9/FB1ILxMz4jDqdYxS9YrpQNNELOy6GcQNPfTFRazDyK6XwKq7OS93MOft8es9RhSwHzun5EkGxXysNPbuSBZCMLdV+2K6xF2b0u1jBV0LG9reW49MqCPygwQgl6Z5AyZZpcsPUXO/1Lyq5RdE0CUjzcW4usNaUBl5GsDnSvrGjgIk0Qvjqm/j2qzynbo0+HM6cey73id507PrSpbsjs
 0sk4rr6a
 SMUmuF5Neg9FKniFOheD6UgCEYDYuBMtjVpUL5dQY7dQkicTK8vltqSqWsW3Rajod1h8Iwzi47QQt4NtH546627E61Hvj8XNOwAfB33qO8tqNrjJINDaQqBdl7q5TOovvta31HO8M0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm: split the file's i_mmap tree for NUMA
https://lore.kernel.org/all/20260611061915.2354307-1-huangsj@hygon.cn
* [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
* [PATCH v2 2/4] mm: use get_i_mmap_root to access the file's i_mmap
* [PATCH v2 3/4] mm/fs: split the file's i_mmap tree
* [PATCH v2 4/4] docs/mm: update document for split i_mmap tree

and found the following issue:
INFO: trying to register non-static key in do_one_initcall

Full report is available here:
https://ci.syzbot.org/series/a9bada61-06e7-40d5-b423-5f2d69a60209

***

INFO: trying to register non-static key in do_one_initcall

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      14546c7bef6c1036fc82e36c1a200b0caccd339a
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2f92f704-660a-4108-9172-7e620e10ce46/config

acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug LTR]
acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapability]
PCI host bridge to bus 0000:00
pci_bus 0000:00: Unknown NUMA node; performance will be reduced
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
pci_bus 0000:00: root bus resource [mem 0x80000000-0xafffffff window]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff window]
pci_bus 0000:00: root bus resource [mem 0x240000000-0xa3fffffff window]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000 conventional PCI endpoint
pci 0000:00:01.0: [1234:1111] type 00 class 0x030000 conventional PCI endpoint
pci 0000:00:01.0: BAR 0 [mem 0xfd000000-0xfdffffff pref]
pci 0000:00:01.0: BAR 2 [mem 0xfebf0000-0xfebf0fff]
pci 0000:00:01.0: ROM [mem 0xfebe0000-0xfebeffff pref]
pci 0000:00:01.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
pci 0000:00:02.0: [1af4:1005] type 00 class 0x00ff00 conventional PCI endpoint
pci 0000:00:02.0: BAR 0 [io  0xc080-0xc09f]
pci 0000:00:02.0: BAR 1 [mem 0xfebf1000-0xfebf1fff]
pci 0000:00:02.0: BAR 4 [mem 0xfe000000-0xfe003fff 64bit pref]
pci 0000:00:03.0: [8086:100e] type 00 class 0x020000 conventional PCI endpoint
pci 0000:00:03.0: BAR 0 [mem 0xfebc0000-0xfebdffff]
pci 0000:00:03.0: BAR 1 [io  0xc000-0xc03f]
pci 0000:00:03.0: ROM [mem 0xfeb80000-0xfebbffff pref]
pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100 conventional PCI endpoint
pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601 conventional PCI endpoint
pci 0000:00:1f.2: BAR 4 [io  0xc0a0-0xc0bf]
pci 0000:00:1f.2: BAR 5 [mem 0xfebf2000-0xfebf2fff]
pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500 conventional PCI endpoint
pci 0000:00:1f.3: BAR 4 [io  0x0700-0x073f]
ACPI: PCI: Interrupt link LNKA configured for IRQ 10
ACPI: PCI: Interrupt link LNKB configured for IRQ 10
ACPI: PCI: Interrupt link LNKC configured for IRQ 11
ACPI: PCI: Interrupt link LNKD configured for IRQ 11
ACPI: PCI: Interrupt link LNKE configured for IRQ 10
ACPI: PCI: Interrupt link LNKF configured for IRQ 10
ACPI: PCI: Interrupt link LNKG configured for IRQ 11
ACPI: PCI: Interrupt link LNKH configured for IRQ 11
ACPI: PCI: Interrupt link GSIA configured for IRQ 16
ACPI: PCI: Interrupt link GSIB configured for IRQ 17
ACPI: PCI: Interrupt link GSIC configured for IRQ 18
ACPI: PCI: Interrupt link GSID configured for IRQ 19
ACPI: PCI: Interrupt link GSIE configured for IRQ 20
ACPI: PCI: Interrupt link GSIF configured for IRQ 21
ACPI: PCI: Interrupt link GSIG configured for IRQ 22
ACPI: PCI: Interrupt link GSIH configured for IRQ 23
iommu: Default domain type: Translated
iommu: DMA domain TLB invalidation policy: lazy mode
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 assign_lock_key+0x133/0x150
 register_lock_class+0xcc/0x2e0
 __lock_acquire+0xad/0x2cf0
 lock_acquire+0x106/0x350
 down_write+0x96/0x200
 dma_resv_lockdep+0x39c/0x660
 do_one_initcall+0x250/0x870
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x2a6/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>
------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON(sem->magic != sem): count = 0x1, magic = 0x0, owner = 0xffff888102a95940, curr 0xffff888102a95940, list not empty
WARNING: kernel/locking/rwsem.c:1405 at up_write+0x1e2/0x410, CPU#0: swapper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:up_write+0x2b1/0x410
Code: c0 c0 e6 cc 8b 49 c7 c2 a0 e6 cc 8b 4c 0f 44 d0 48 8b 7c 24 10 48 c7 c6 40 e8 cc 8b 48 8b 54 24 08 48 8b 0c 24 4d 89 f9 41 52 <67> 48 0f b9 3a 48 83 c4 08 e8 21 1f 0d 03 e9 b2 fd ff ff 90 0f 0b
RSP: 0000:ffffc90000067480 EFLAGS: 00010246
RAX: ffffffff8bcce6c0 RBX: ffffc900000677d0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff8bcce840 RDI: ffffffff90338290
RBP: ffffc90000067830 R08: ffff888102a95940 R09: ffff888102a95940
R10: ffffffff8bcce6c0 R11: fffff5200000cefc R12: ffffc90000067828
R13: dffffc0000000000 R14: 1ffff9200000cf06 R15: ffff888102a95940
FS:  0000000000000000(0000) GS:ffff88818dc9e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 dma_resv_lockdep+0x3a4/0x660
 do_one_initcall+0x250/0x870
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x2a6/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
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

