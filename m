Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64061073C9F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6A26B0088; Wed,  8 Apr 2026 07:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57AC6B0089; Wed,  8 Apr 2026 07:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D8C6B008A; Wed,  8 Apr 2026 07:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C64416B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:32:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAB15C3187
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:32:56 +0000 (UTC)
X-FDA: 84635176752.11.25E64C2
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45FBC140012
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:32:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 35TzWaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=35TzWaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775647975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Z2XunhiSil5M1NzR6tUGX9v+gDxArtgaNVWHEmuv5y4=;
	b=nb6RSiEHb+hZ8vj529Hrm6bBjuWtVTgX5xZhBz2hKm8efNXfbCeOwriNXCpJqA/ORTtJFo
	69u01M6HIaZZ/OXozoZnoZCkkQTg4GasJ1+gSKheR8qgV2PzLDNc+grVU836swVjNSYJGF
	YtUXtgDBClo92Lgig3Mh7xChHGaJuns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775647975; a=rsa-sha256;
	cv=none;
	b=k6kvatxnFStJ5PKZUwgrwf+eo/aO4gAxR4vR+VzQ/FvRf30lqcTuLE5MT844/xnZAntlVK
	Qe2WZFAJ+P7YIAC0lHxHY7wyABXkpYBzoU7hXg6aHRFUF8BqUO86JzJC0UCvvVO2bd61qg
	lXY6xIXKj3f/KqnPvEQjCY4ozcUG9zw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 35TzWaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=35TzWaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6861462170aso6596403eaf.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 04:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775647974; x=1776252774;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2XunhiSil5M1NzR6tUGX9v+gDxArtgaNVWHEmuv5y4=;
        b=lUyq2d4vdIT+dlV/gzI8p0gRsZKfq91cYkGgqrFKUIlxzsyDY3BCPflMvkaavUKwzJ
         IMr1RtWyWP6+lllmRbA/ZV7FL++qfOZqVuTPVU4mfh+sDXEE5OBKYGnwsdybripYE2Tl
         GJan0yml6c+4EIjZv1DDou9cHJxrroW4q0jMx0QfDDlOFjOyu15rdlHFrqDfNqJxRSpE
         26ZfDhwPYeiQjLt/4ujHyyEeLIazydHK6rqxD6O4PLLa/ni/+tRyEVVpJi2hCzNHNiJZ
         4N082GD4zP7um4fAo7vjqg/f/loOkjWOIcgWTC0yRUK1IHoI4AR22GQkXCHa7dKO7wvE
         +8iw==
X-Forwarded-Encrypted: i=1; AJvYcCUzOwQZlcYl/A7b0NXvf+esspZQZmH+nDhHmpaG4J6gDMS9fMzaer5f5kXADZXjWjoiwq8ts+Bjaw==@kvack.org
X-Gm-Message-State: AOJu0YxY+yimy3IT0GWv9TWbXZMvAlBiX0Nz7hr92k1KYnXOFcRqLTHX
	BBq/WrXqJB9ZB3rf6+Rb7eLQQUewYBpcEm6IPcVRVfcsjIq8macdKO9QBMeXQTZrhcYAu0uyh26
	kLsZkwX0hX+G/HYP6LGKbQ6y0q86/H6H2dZDNXJJMnxjrvoWgJe3jl23Ck5k=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:203:b0:67c:3142:b174 with SMTP id
 006d021491bc7-6821d53c55fmr11507527eaf.9.1775647973877; Wed, 08 Apr 2026
 04:32:53 -0700 (PDT)
Date: Wed, 08 Apr 2026 04:32:53 -0700
In-Reply-To: <20260408092441.435133-1-hsalunke@amd.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d63ce5.a00a0220.468cb.000e.GAE@google.com>
Subject: [syzbot ci] Re: mm/page_alloc: use batch page clearing in kernel_init_pages()
From: syzbot ci <syzbot+cie37157b0c03b48f2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, ankur.a.arora@oracle.com, bharata@amd.com, 
	hannes@cmpxchg.org, hsalunke@amd.com, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	rkodsara@amd.com, shivankg@amd.com, surenb@google.com, vbabka@kernel.org, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 45FBC140012
X-Stat-Signature: uym64mc16xaia3bo7ogjwspfwtw14h8w
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775647975-333183
X-HE-Meta: U2FsdGVkX19x0WmVh4zBtdbfsTXNfNhf9wmpMDMwaxdlhYHlS49aTakfdgKNm1h+rpLza/nz7XonU4Hvv8RDQykMANVvbWRFqeWZyiDM+OJRVJo4R2umXU1n9k2ABX0O9grL17s11SLS+fK/z3mmemq0//+VSxFboLadK92yuUqOo9l6qRvpT4OUuemZsLbfLRgI3iVl162O2BzTShxyQkT8WNgEviFGK9hAM2NTol/DtvpVHmRN/rwKhHjKEB0g3H1gC+xlFgWz8dExrBcVrsXg70yN5QKbK3rtSzXiAETqCtdaMKzYOWrbWly96Xp9SQAZs5B3uKJ8KY6vYjVFdvmCFoPXpCaS60TYmgxZ+sQMQRWnjzflWoYbZsK6X5lPChCmLqiyO2Eq5JDPMLhA9RtMEhZgnZVptsWggFVOj4vD2WzDJz5sk3JMIgmiR/1cZtxAOA0TaujJf2D2xsoId1JzvMHEb8ZQYjtpLqmmRJFhMJQeRC7CqTnzrxXc4FsruSgAla8w4XOQr1e95VZzm0f+CcJpSMsPfOO6Ikr0vxokdlCLvaOqtFu5pw3TdtjTTwdpqTCcJlSA/tmbw+SoFpUxl7xuLA8GmfXue7CLeEFbrWKH/n72E1Uc1xB0zznOvjl4v9rg/YNERWJhdhMSFGfNSLCpWM3hLU60sGCsdz8O0o4dGdYBXh6RVLvaaUEnTEuKAAqeBbsC0Hf5RNUE3CdY8DPOYUti617blfsPPajv3ipvRqSknYBdRJ+b+g9Vi3kdODVoQ0cS8iST4naWfiqyWwbWOsogwTrj8GrCZLuh+M3q3tTaEvdE/oEWoTyZSSCYncGSJk1LLsqO53n5nV9p92T2aNp/hVnxccj6z9XjHF+jQfWI0iwZBzp+0zK2ATuGbcKnfM6kSkDhTy/FpLP9wjycbyrv7amB1G5sYgVAuTOGutBSSDhR63dYTW+q498BUB4kT1hD/ARTTwh
 FLEsZ/SC
 d6yfcTcyvyTeJ1QMqjuIuAgIBWRPBYJi/YyMCP8hYmVJ0mnto85HTiUHdnujoEExVRpOweHxJcNcsLCGjK0jcQlECaVmzToL5MyY13LT3akA7XPi0zYgds7Dje91Ou6lAI9DupmRJjt8IYONElHDUpAryDEtcrjoP9OGh8qhAvIFa20opwkeTyfiznbmzdsCnxXWkZA5wQCHsr1ftEDn6oUgg69plpMmfNyFVZTnHONcSyk4oiO7rKEXAYHwn3uJKILTtXNHalkpJkK0XTiAmp8czH7WKi2zDaHp7eVCaQEyQA3y5mQKwXHzSM+mVKMfnk7l1mV2mn8CBQanUVkczoMHzFTIyxJ72GH4uq1uRtTKWtxFAjOA/KQ+9DcPp2AWyFyqKBfoM7CtL+z0dIyBPfDE93uT2ShsOzSSDd9q8JqSwp1M/w/Xvl2LMWbYysEsdjNrH0f+AbS6DJWYwhjHhZHmwIjiJGv9xxRPiC+EMzFckfaXM4H5p2KF7eBbBBwSECMge
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/page_alloc: use batch page clearing in kernel_init_pages()
https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com
* [PATCH] mm/page_alloc: use batch page clearing in kernel_init_pages()

and found the following issue:
WARNING in preempt_model_full

Full report is available here:
https://ci.syzbot.org/series/be6c0534-641b-42aa-8b73-ab8f592ec267

***

WARNING in preempt_model_full

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      0d90551ea699ef3d1a85cd7a1a7e21e8d4f04db2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/22cbd293-31c6-46b9-b8d4-2ff590ce406=
b/config

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
preempt_dynamic_mode =3D=3D preempt_dynamic_undefined
WARNING: kernel/sched/core.c:7743 at preempt_model_full+0x1e/0x30, CPU#0: s=
wapper/0
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:preempt_model_full+0x1e/0x30
Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 83 3d 35 d9 cb 0c ff =
74 10 83 3d 2c d9 cb 0c 02 0f 94 c0 2e e9 93 fa 19 0a 90 <0f> 0b 90 eb ea 6=
6 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90
RSP: 0000:ffffffff8e407a78 EFLAGS: 00010046
RAX: 1ffffffff1c359d9 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffea0004000000
RBP: 0000000000040100 R08: ffffffff8221aafb R09: 0000000000000000
R10: ffffed1020000000 R11: ffffed1024206961 R12: 0000000000000001
R13: 0000000000000001 R14: ffff888100000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0
Call Trace:
 <TASK>
 kernel_init_pages+0x6d/0xe0
 post_alloc_hook+0xae/0x1e0
 get_page_from_freelist+0x24ba/0x2540
 __alloc_frozen_pages_noprof+0x18d/0x380
 alloc_pages_mpol+0x235/0x490
 alloc_pages_noprof+0xac/0x2a0
 __pud_alloc+0x3a/0x460
 preallocate_vmalloc_pages+0x386/0x3d0
 mm_core_init+0x79/0xb0
 start_kernel+0x15a/0x3d0
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x143/0x1c0
 common_startup_64+0x13e/0x147
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

