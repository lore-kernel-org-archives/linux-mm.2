Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA03FF557FE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 10:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0BA26B00CB; Mon, 20 Apr 2026 06:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC0B6B00CC; Mon, 20 Apr 2026 06:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1C06B00CD; Mon, 20 Apr 2026 06:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB976B00CB
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:07:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B6611409E3
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:07:17 +0000 (UTC)
X-FDA: 84678506514.08.F9D8589
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6EEA21C0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:07:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 30vrlaQkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=30vrlaQkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776679635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=DjpMJLyJHTl1mKAWHq8djAY85Ht0d1iy4vRhA/ss9Y4=;
	b=ShW7I86atSXQ/RHHsusFfunfuY875Wvey1vMUwvHIQ6Ah6t6cfHxbfQ2QqdJK8isl7WMqh
	VioHTWSchBeG95ITEPeGSoZ4JiqmWjuKN4d0Ld5LNCuNYd/MaQzlHeyOB2lfnmBUPiwxPx
	WDrFvEaTe7jwrErQC4mtfPKeCYcLTBo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 30vrlaQkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=30vrlaQkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776679635; a=rsa-sha256;
	cv=none;
	b=qIuANQg/ucfsDPJG+oQPS+sXOfOpuKUFNmwpiia/D3FKsz/2ITSgqRPh5Rb9MeRk6ePw7O
	7mW4BSHayouuKj891Qbf0zzVoqa/nACydILtHLFR5yRbID6xZC6cLum83wLJIYD2P8PjDN
	rccsWvf7eUzT6W+XKW3DBktNpJTDYew=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dbb4a976adso3168597a34.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679634; x=1777284434;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjpMJLyJHTl1mKAWHq8djAY85Ht0d1iy4vRhA/ss9Y4=;
        b=PpCxyZyt4F1TjjWklRO6YiR/8VYrLamJVFi4RwmXocXbNB+B36LoMpAo/7FwfvcFuN
         ydez7aAyTBe02DrLTvT6G4p3QGcqEdJjix6M70lE4bgoF9yB+Hsidg4cIHKk5sZ79slC
         Fmz+wPLulP3grK5IxGn4sYT6zZ4SoCcEk8fIEfpZA0zJ/5KUWardc622NMoWV1oDtnFv
         Kq/O/5fS+UY08gshUGWcLeq2FSpl2b6jGhnbbQ644ifFIlkboeJB8/sMmajiE9kOpdn6
         nWTOSIdhOO54SWQuELk/cx08L8YMdv5/N1I6MuFtpiuwxubktu8GqW64BNA185k6lS22
         hqTQ==
X-Forwarded-Encrypted: i=1; AFNElJ+N3li/HsmPr8iJM2+AsvZuR/m5bPX/D6kVB6RvTZXF+ZiedivBZtUIRcpjAGTZTa24CHG9kHyF7A==@kvack.org
X-Gm-Message-State: AOJu0YxlSr7jX1rbhiOUl9rT0YdCRUx/RPlUgE2dIHm6x6+o9krqE1s9
	gY0JzdYTGVsaEfS/Ti3mqBumEBom+yMmiNQdLHmca2eRWCCkhKIb6Trv04q8mZjMqjvXKAD4Zif
	MpoRRpv7duRisFb7QBSMXjDxb/wOLt1CYgvsL1tEYUPQY9OaP4BgdaZZ+CFY=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c06:b0:694:8f3a:3f41 with SMTP id
 006d021491bc7-6948f3a4683mr251846eaf.41.1776679634403; Mon, 20 Apr 2026
 03:07:14 -0700 (PDT)
Date: Mon, 20 Apr 2026 03:07:14 -0700
In-Reply-To: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e5fad2.a00a0220.9259.0002.GAE@google.com>
Subject: [syzbot ci] Re: mm: improve folio refcount scalability
From: syzbot ci <syzbot+ci8b1ec3de7de22731@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, artem.kuzin@huawei.com, 
	baolin.wang@linux.alibaba.com, david@kernel.org, 
	gladyshev.ilya1@h-partners.com, gorbunov.ivan@h-partners.com, 
	harry.yoo@oracle.com, kirill@shutemov.name, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, rppt@kernel.org, surenb@google.com, 
	torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org, 
	yuzhao@google.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EEA21C0005
X-Stat-Signature: ed3ywghiry6ooubx3n4r7jb447iie35s
X-Rspam-User: 
X-HE-Tag: 1776679635-376385
X-HE-Meta: U2FsdGVkX18sz/jiUD4yBshMu+yRYeI9vyD2FPnJuVcGbW5M+9SCZl4ePTK6WTV7lRHY2PfpM722ZXrFzru6rZlSSv8W6aiYfVHGzvgT+DqC++t6gvW5tYwRO4HqidTZMZFLDRqoKLzWQI8R2M8NK5YIUpVASow2YBfW7SsI2ovBXOVHAMICySiaLiTBawVsKBtNBK9dLCSaXoAyfLfwzEdJWdvAzJebrOUMjYKMWK4O/ATZr+ed7G9gaLbS9XQjDjEFEdOcJWxzJwYhmfLMQJmwqMtM8xiUrOFmvHWXNO883Dh/KTLmCAqElPaL8mAMBiXs2Sfb9cmYM97NqwfVXH1je59T/46s+skXx3a1Th5EZFwQQEfz7U34hcob41JRkH+K5az79WC0zx1Mx+1C0qip8wyqgLGUjf7pumrsnBwxH/nIHmSbj+5jvPdtKNlJv/3STBrsL3yK5jZSoNTLc+7JK2pNmP9k7qMfp97DqeqzhRdS3G9PHKwevu6rS4F/zle7ldD4aNLYEfW814nJfB6VLd0jDP0jThRSCu4DDzEn3ArLHazQEN+m+JV7nMlC5I5Un6Cz62R5nbqqbzTL7TlusbBLIL4yHOUwtqj4ximnFCtN+MeaBzGE7DAg1NZguBpFV9R5cRUDW0HcbTKZSKth1C4bCODvylsB7PZt9CxsEmOcAHjP1raE48yxLwFKzwJbtDTIA0gL2AKjGvd2XPDyePXEuUSZO11bILw3xaDLUnXUg0uFvVwtBXce+h9zXBCzBiftCS17/XYHzIpL3cJp6BXUyNqwgmhGDJCDmvvBw4J4fTAwL26dN4IhH88B2G80lRm55yNeAZj5Be92KCAsIEEv88/0j3XP7+YqU1jJD/Jcrq4kRCBcYLlEdaOEKMFg4qlMWM8JsqOav0G+d2tKNPEesDmZ781VkzCktzvip0j2Cu0MUlxoCEdLvqd6vLUyYhQwIn7OOV5T6MU
 irISna3l
 ewBafa6YnlpxFO2wxNY2vEeATq4YH0JTERSevhe9+9ygCnuN1xZR2Wa1bdoo0DS3AVo4oWpRueViL0z71BX7OAElwVbzUvDcWWE0eXVu9l0RQWkEQXVeFh8z42AwN1xvMH7CnKHb72faAeeg7w0b80TlmLPWnCO8bS/T9UATKXc18edSBBdh5cWiVw1MNvLSJ8IkrONQaZELRS5qzBufv9mg2g6l3QDoDqT6hLRMQWw8Ty8Zcp8ViHbJilCCK00dg3kLWyzvCrGYTOfQgtvcW2iN28f1bNPJvKiaFvQQyraZp+I/4b95F4ZQpG2wBRM0H1AGkRiNkmqqojXqaH91N5ESZohKAYtAMuVTgEn3A8KeM4UKCv1UdWRdHOFFdJUaKve1sQ0cbXa59ZBEjfLYyivQarlrOB7MQKNyYFW6GZW72A3FeZqFGno5E1JUhE0zGOiSNqm+NSpz4tQG1O1AIJ2xzsfDkwCmYZRClMPs5fOnQQOjV/KG907qE1ZJK3NFk1Vj7xG2xLuE1GU5skLDlv6nZu7rNVvkKngOeaHj0qHpcZI9lWsSuzNtMl6cJoceAwbexhOuzlJ39QKCaLX7cdbR5jSAhMpuLJHznF62+PIBY/GHJxpqzm8l/FrunG4GqLFSwuzER/IHLRVOIKCPTbhXXl0T36pPgYxMXJlbcvtqiD6zmwhUEazeOABIQstX4CxF+t6S7S1DVEC4Yuz3M2YTwu3waUWzJABQMql1JKwPBMa7tO4IR4mU4/IwSuordRw3tgNUJk//EZ9OD1Cz8EPBg2/JbCKzEnL7JGdml8bQN8t4kOUwQQ+qXS9PdjyLrbd1WsA/y/08GW2Qr23ECp1YhhAUthvgdzVJ/ESu7zh72Q8r8exQ0AyN6tzhkjL6sHPSJfzqwDCLdRJIbGEf5I0PyEh7id+ah2TQwpKa3sV4Doe5wLjPLMUDfr/lUrJpPwLGD93MaZ46L2wXhFyWpxUaMIiPn
 KQBTAwAQ
 EO5Y1s+O+Jr0NLAnKsMJlhQudF/UZ8dXeY9gP29qYrr5GdoFsDvRTMQjbP7RaJG9KnFQIJ6BxABDEROmrtvz3JtcmhdmRotItuRVczRakbm23lWa8PI4xbQ1VhHNTvuO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm: improve folio refcount scalability
https://lore.kernel.org/all/cover.1776350895.git.gorbunov.ivan@h-partners.c=
om
* [PATCH v2 1/2] mm: drop page refcount zero state semantics
* [PATCH v2 2/2] mm: implement page refcount locking via dedicated bit

and found the following issue:
kernel BUG in get_page_bootmem

Full report is available here:
https://ci.syzbot.org/series/eb14b73a-c461-4be5-b5af-91864e939f4c

***

kernel BUG in get_page_bootmem

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      f4279f87cd6c82ebdaccdc56f38e7b80ca7fcc03
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/60ced5f4-8c33-43ea-a4ee-92d9b2b8f94=
9/config

ACPI: HPET id: 0x8086a201 base: 0xfed00000
CPU topo: Max. logical packages:   2
CPU topo: Max. logical nodes:      1
CPU topo: Num. nodes per package:  1
CPU topo: Max. logical dies:       2
CPU topo: Max. dies per package:   1
CPU topo: Max. threads per core:   1
CPU topo: Num. cores per package:     1
CPU topo: Num. threads per package:   1
CPU topo: Allowing 2 present CPUs plus 0 hotplug CPUs
kvm-guest: APIC: eoi() replaced with kvm_guest_apic_eoi_write()
PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x000fffff]
PM: hibernation: Registered nosave memory: [mem 0x7ffdf000-0xffffffff]
[gap 0xc0000000-0xfed1bfff] available for PCI devices
Booting paravirtualized kernel on KVM
clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_=
idle_ns: 19112604462750000 ns
Zone ranges:
  DMA      [mem 0x0000000000001000-0x0000000000ffffff]
  DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
  Normal   [mem 0x0000000100000000-0x000000023fffffff]
  Device   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000000001000-0x000000000009efff]
  node   0: [mem 0x0000000000100000-0x000000007ffdefff]
  node   0: [mem 0x0000000100000000-0x0000000160000fff]
  node   1: [mem 0x0000000160001000-0x000000023fffffff]
Initmem setup node 0 [mem 0x0000000000001000-0x0000000160000fff]
Initmem setup node 1 [mem 0x0000000160001000-0x000000023fffffff]
On node 0, zone DMA: 1 pages in unavailable ranges
On node 0, zone DMA: 97 pages in unavailable ranges
On node 0, zone Normal: 33 pages in unavailable ranges
setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:2
percpu: Embedded 71 pages/cpu s250120 r8192 d32504 u2097152
kvm-guest: PV spinlocks disabled, no host support
Kernel command line: earlyprintk=3Dserial net.ifnames=3D0 sysctl.kernel.hun=
g_task_all_cpu_backtrace=3D1 ima_policy=3Dtcb nf-conntrack-ftp.ports=3D2000=
0 nf-conntrack-tftp.ports=3D20000 nf-conntrack-sip.ports=3D20000 nf-conntra=
ck-irc.ports=3D20000 nf-conntrack-sane.ports=3D20000 binder.debug_mask=3D0 =
rcupdate.rcu_expedited=3D1 rcupdate.rcu_cpu_stall_cputime=3D1 no_hash_point=
ers page_owner=3Don sysctl.vm.nr_hugepages=3D4 sysctl.vm.nr_overcommit_huge=
pages=3D4 secretmem.enable=3D1 sysctl.max_rcu_stall_to_panic=3D1 msr.allow_=
writes=3Doff coredump_filter=3D0xffff root=3D/dev/sda console=3DttyS0 vsysc=
all=3Dnative numa=3Dfake=3D2 kvm-intel.nested=3D1 spec_store_bypass_disable=
=3Dprctl nopcid vivid.n_devs=3D64 vivid.multiplanar=3D1,2,1,2,1,2,1,2,1,2,1=
,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,=
1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=3D32 rose.rose_ndevs=3D32 s=
mp.csd_lock_timeout=3D100000 watchdog_thresh=3D55 workqueue.watchdog_thresh=
=3D140 sysctl.net.core.netdev_unregister_timeout_secs=3D140 dummy_hcd.num=
=3D32 max_loop=3D32 nbds_max=3D32 \
Kernel command line: comedi.comedi_num_legacy_minors=3D4 panic_on_warn=3D1 =
root=3D/dev/sda console=3DttyS0 root=3D/dev/sda1
Unknown kernel command line parameters "nbds_max=3D32", will be passed to u=
ser space.
printk: log buffer data + meta data: 262144 + 917504 =3D 1179648 bytes
software IO TLB: area num 2.
Fallback order for Node 0: 0 1=20
Fallback order for Node 1: 1 0=20
Built 2 zonelists, mobility grouping on.  Total pages: 1834877
Policy zone: Normal
mem auto-init: stack:all(zero), heap alloc:on, heap free:off
stackdepot: allocating hash table via alloc_large_system_hash
stackdepot hash table entries: 1048576 (order: 12, 16777216 bytes, linear)
stackdepot: allocating space for 8192 stack pools via memblock
------------[ cut here ]------------
kernel BUG at ./include/linux/page_ref.h:171!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:get_page_bootmem+0x188/0x190
Code: 86 ff 90 0f 0b e8 98 52 86 ff 90 0f 0b e8 90 52 86 ff 48 89 df 48 c7 =
c6 00 e4 dd 8b e8 51 d7 e8 fe 90 0f 0b e8 79 52 86 ff 90 <0f> 0b 66 0f 1f 4=
4 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffffff8e407e50 EFLAGS: 00010093
RAX: ffffffff823f42b7 RBX: ffffea00057ffec0 RCX: ffffffff8e494ec0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffea00057ffef7 R09: 1ffffd4000afffde
R10: dffffc0000000000 R11: fffff94000afffdf R12: dffffc0000000000
R13: 0000000000000000 R14: ffffea00057ffef4 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0
Call Trace:
 <TASK>
 register_page_bootmem_info_node+0x88/0x410
 register_page_bootmem_info+0x77/0xc0
 mem_init+0x5a/0xb0
 mm_core_init+0x79/0xb0
 start_kernel+0x15a/0x3d0
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x143/0x1c0
 common_startup_64+0x13e/0x147
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:get_page_bootmem+0x188/0x190
Code: 86 ff 90 0f 0b e8 98 52 86 ff 90 0f 0b e8 90 52 86 ff 48 89 df 48 c7 =
c6 00 e4 dd 8b e8 51 d7 e8 fe 90 0f 0b e8 79 52 86 ff 90 <0f> 0b 66 0f 1f 4=
4 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffffff8e407e50 EFLAGS: 00010093
RAX: ffffffff823f42b7 RBX: ffffea00057ffec0 RCX: ffffffff8e494ec0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffea00057ffef7 R09: 1ffffd4000afffde
R10: dffffc0000000000 R11: fffff94000afffdf R12: dffffc0000000000
R13: 0000000000000000 R14: ffffea00057ffef4 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0


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

