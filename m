Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78257CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 06:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6EE6B008C; Tue, 19 May 2026 02:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877BE6B0092; Tue, 19 May 2026 02:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D476B0093; Tue, 19 May 2026 02:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65A6E6B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:58:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC6DC401A3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:58:39 +0000 (UTC)
X-FDA: 84783266358.29.89322E4
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by imf28.hostedemail.com (Postfix) with ESMTP id 194B7C0003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:58:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3HQoMagkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3HQoMagkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779173918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ZFrB8cafc/UDPLZPmOmG8rNv10MH4VFhRr3sj9GksQk=;
	b=AK70GpYItBZnrLhIS4Q/hewyggU+NAzj2R9yEdXmKxyMzeBpmAN2YhR8fCYim61fEVslW5
	Y6TmLScs+tT7s/T51KophnoOM107RJp82UVVB6wbdVUBQJH9lCTYUJbO2IUqBQtk6EMvNa
	CdaOgZGxQSy1hoMGiwlo5M3PoEAOSR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779173918; a=rsa-sha256;
	cv=none;
	b=oDrbmGIZWYNJ4wS/SdQruUpTdT5pOeZdm5xYJcYIKawRc++QQA/E8dSpoN5CHkMOepWm9+
	C9WF3ldC5mDYIDIHF7Nz3XpFHGZLmD+d1owTePDhyV0lor2SoLKB56Yw3wdeEGRzF99HXS
	rUq16QDyfEBVTAnlqTbn9db44F/msUM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3HQoMagkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3HQoMagkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-439ad1209d4so7428462fac.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 23:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173917; x=1779778717;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFrB8cafc/UDPLZPmOmG8rNv10MH4VFhRr3sj9GksQk=;
        b=IRu97AZBRYfvjCUs/RS0mNAKI0rRH0ZLn1WpqcR5ml35i4kY4KX1udZbH/A9Ydg1wk
         urHtOx9g7yuRoTgMccw73Rn/uEzDukXtdRtKWoJHJZbkAteVm0PnMQgCZ4r5IniAyM+D
         7g0QOnxpiNZjDjr9EZfJfebAmb+K5+4yb1zTzUjf7YzLo7VnAHvFmfun98fLeyd5OpFd
         nRBhwodhN0mMCOIVHUirvVeNwhV7rBYiWk0eFCDHRNH3thvt779SrTyo+lISjVhBFYbb
         TmVoDIcZX++ugrCXv9mkhwcWrpSUZliLQ8JPrLQab+1sAxwJUR3YFwXHZeg5HSyZrM1r
         Gc1g==
X-Forwarded-Encrypted: i=1; AFNElJ8oINx3rdexjOIGLEO5k2Kg2B99J21EUq/fOuOsYUNoN3fHfmfJb2uQS0VR1sVF96j3JyRhiTq/Pw==@kvack.org
X-Gm-Message-State: AOJu0YynNSgFPab3M5qONZaUUPvdzgCpq07Q2d6OolbYAr/6/+SMnaDC
	LMiPMXZbLaomW6EeuRQV4G6jzptx9OF9bRmIQOSmb/yT/F0zkBxY+1c55J9KTFn1pPGsJmBdf2w
	bI+HvoTTx4h1wHGYBWzpwSCh7k9xijwHjchyRCIQClHAdWEF/5lJleC2hcd8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f06:b0:694:8f3a:3f3d with SMTP id
 006d021491bc7-69c94375246mr11683344eaf.35.1779173917016; Mon, 18 May 2026
 23:58:37 -0700 (PDT)
Date: Mon, 18 May 2026 23:58:37 -0700
In-Reply-To: <20260519012754.240804-1-leobras.c@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0c0a1d.050a0220.154e79.0003.GAE@google.com>
Subject: [syzbot ci] Re: Introduce Per-CPU Work helpers (was QPW)
From: syzbot ci <syzbot+ci1f8633521f2ac20d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, boqun@kernel.org, bp@alien8.de, brauner@kernel.org, 
	chrisl@kernel.org, cl@gentwo.org, corbet@lwn.net, coxu@redhat.com, 
	dapeng1.mi@linux.intel.com, david@kernel.org, dianders@chromium.org, 
	ebiggers@kernel.org, elver@google.com, feng.tang@linux.alibaba.com, 
	frederic@kernel.org, gary@garyguo.net, hannes@cmpxchg.org, hao.li@linux.dev, 
	harry@kernel.org, jackmanb@google.com, jannh@google.com, kasong@tencent.com, 
	kees@kernel.org, kuba@kernel.org, leobras.c@gmail.com, liam@infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, lirongqing@baidu.com, ljs@kernel.org, 
	longman@redhat.com, masahiroy@kernel.org, mhocko@suse.com, mingo@redhat.com, 
	mtosatti@redhat.com, nathan@kernel.org, nphamcs@gmail.com, nsc@kernel.org, 
	ojeda@kernel.org, pasha.tatashin@soleen.com, paulmck@kernel.org, 
	peterz@infradead.org, pfalcato@suse.de, qi.zheng@linux.dev, 
	rdunlap@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 194B7C0003
X-Rspamd-Server: rspam04
X-Stat-Signature: ob97yprfm61n6m9pu554h73fgxrk6qe8
X-HE-Tag: 1779173917-649995
X-HE-Meta: U2FsdGVkX19wmPzehOFcQldABAwEQQAgbTLt5RpULRqyrFJUeQ7+0DM5U9OMX9Yqd6fOhs8Pk5leLn5fBC+vkoXYacVLd9gYixeHF9o84CWk+h/ditw69zS6+w4HEQwwv2cBEdamRUgn69O9bSeHJIXPxBFvOHH4GVm11JXrTbFBgeHp0zwwznbtzCX5EIL9dyjWVJTNv+gQ9rlXFnCAkQnnNUbZY6cf82XoMoLa9B27I9jX3/NDqGZXqT4uxB1tk1oQrEQ7qjwL5CR8htM9cFS9a29pgd3kap/yRNpdAWxiFwggnHMdJOILkdVRovDiE2ODcwZ+vWQ6G3Z+ScVJCW6xC35krCzKaLxoleCzN8DBKnnmhhVuEmXlaXL3TltfIt2tCZ75KByW0Y/uDxgwMGASV1XRIgxwTazMQlj71JlgpDFCebgDZLKipGUDlOHsYU2TJYEHJgRWGwvASQukqjhg6dNjFXRRUMDkaZ9yZDeL4zVoJX0o7zS0P05Lrx73CQs1OL1nrQc883JsbKP57xJUzZmAciPOWW7C6cZC5BMXGBWI1QVDgZ1N1XXhIqyS3DPmxOB8hrfqm5KQkJ63f2jz/Mbuz55ACyrSao5XpMvQoBEDR+6w5GqHR2aMVssScHtbMKg/VNvConFPm9jRqfwpOeEf7al2Ya3bsaDGWIVk1oCbFeHl6CqgHBp2BFSs9OMWOAGM+WzpF+MZGvCYAWKvH3nSpc5f5coXwQOnlJajw91VC0904BxAF0HBNQGFqyuJevACNrTX1/Ua7qX9N5AOmD8PFBwUMwI6lAj/09dMdddo1whrSFwSBWYDI48BDo7JjgK+30Bd/IrGOBiAVb2Q3hF7yWJK6MSwwgsizaLu11GuXaBtrhrgG+uPvsnFl2VzmMIGN8CZPR0Od3kAre7shgkkMq8yrtWAegkF0ORS92aHbCRVkHreUc10pAZQFrmJc43gfnjJ2+b1h+o
 C6087OVk
 zi+GaI6Cx0a2f9+7iN0fF1aICMzSlxL4D7wb9Ds5Q6aZlXAhNPBGzJCkQyGrI3qXGv3895Q7qYQd3Qdg+4MOzfceArwYAcfgKP381WTFeOYq/ejGKHrfefe/im3TTRXgA8KErYPwfBqBh6G1vr6d7b/N6w8mtU2szc8nlwrPfKuKUFF60qCvewCiE2upES15MOlJW7hTCsntGDYkuxaw3+BMIn8jBVgYKT/bnFyUEbcU/I742z7t+TxEzjCZd0OqyWuB22XiLskUzXQPB7FpBte1ndqju0ib6dcgOOWxEkqVgd7Efw4+aAhNNK/BmeSxc77dlZIapb8meIHCNh/9+CONKYudCMFM1JZQ8PY6TMbN0af1gOFs09p0qlMMFG4DFr6vf+twGuX9EFf6+fyh7jWZlGNEinbBnakwpUd6yUIDsillUvNdNxcpUFl62yHGyP+1fX8SDoMxSU518L9SLZN1VZDCuyY14iLTiyWdVZhtpAMthtQcFe9AuSyA1gleg7AsI2ForMQZCVShr5fxGvdD+VNEQQxYRbk1VUG6jDoAk9xcOIzDwFSKVJLDgLDIbePSkne6Tc3tnIWrzMY12qBhp2ML0383f7UZZwu4GuQW5lrZ949Dg+QburkNPcWDH4BW68oZ8LUDT9pd6+IEjj34Q54o4yBH/zIkAd9SfwfY4TeuQ6Mn2stYDtQO/sg/VhRpZPehhAQ6J4ClIqPoLfjkihESrMuy6f0Ws7G+f0zJkzdk4ld1EGeA/LIvQXlwEyN2cDJHTSvG72fFdABdJKRspxsHB0/WXx7QDj0W5Xv0uz47cpJWT1R5EmgKLYPFisiVfz1w2kS3ZL0UgECaoODgmyvKvpAqbR0jDw+lAg7v5C2HW1r9dJGbGpUnRiIzznzuzgM4dNiutYZbycTWDzdtES5YkJQdJyvZkyKz3O6Rt3MMhySTURRMzbluvyY9N5r/DU3v2HMOTCepqDZbj4Sctqt2j
 9dRpvMhZ
 jIl2gVuezIOYhIN31MC3UGY8ylJmqPy6m1Gs31Zad4X9fE8TZy/Sblopo0ytf5lbNn1nrFvLa24zNEHasghUKZ8+/jmQf0dyJxrGKHhcIgGPSRt80bcduThCJuZBuPVca85K33se0PkAsnWXGcfzOiBMHgbJKIZa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v4] Introduce Per-CPU Work helpers (was QPW)
https://lore.kernel.org/all/20260519012754.240804-1-leobras.c@gmail.com
* [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
* [PATCH v4 2/4] mm/swap: move bh draining into a separate workqueue
* [PATCH v4 3/4] swap: apply new pw_queue_on() interface
* [PATCH v4 4/4] slub: apply new pw_queue_on() interface

and found the following issue:
WARNING in __pcs_replace_empty_main

Full report is available here:
https://ci.syzbot.org/series/804f81bd-77b4-490e-bd57-6345ad2aa923

***

WARNING in __pcs_replace_empty_main

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/3ea80958-13bd-49da-9c64-6deb788113f=
8/config

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
percpu: Embedded 71 pages/cpu s250632 r8192 d31992 u2097152
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
**********************************************************
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**                                                      **
** This system shows unhashed kernel memory addresses   **
** via the console, logs, and other interfaces. This    **
** might reduce the security of your system.            **
**                                                      **
** If you see this message and you are not debugging    **
** the kernel, report this immediately to your system   **
** administrator!                                       **
**                                                      **
** Use hash_pointers=3Dalways to force this mode off      **
**                                                      **
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**********************************************************
------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&s->cpu_sheaves->lock)->dep_map) !=3D 0)
WARNING: mm/slub.c:4601 at __pcs_replace_empty_main+0x51b/0x6e0, CPU#0: swa=
pper/0
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__pcs_replace_empty_main+0x51b/0x6e0
Code: 48 85 f6 74 15 4c 89 ff 48 89 c6 e8 af 5e ff ff 4d 89 74 24 38 e9 36 =
fc ff ff 49 89 44 24 40 4d 89 74 24 38 e9 27 fc ff ff 90 <0f> 0b 90 83 7b 2=
c 00 0f 85 23 fb ff ff 48 8b 1b e8 20 cd 82 09 41
RSP: 0000:ffffffff8e607d58 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffff91bb8398 RCX: 0000000000000002
RDX: 0000000000000cc0 RSI: ffffffff8e21ec94 RDI: ffffffff8c28b160
RBP: 0000000000000cc0 R08: 0000000000005e00 R09: 00000000477ac845
R10: 0000000047d13f7f R11: 000000002fa01ecd R12: ffff88812103f308
R13: 0000000000000000 R14: ffffffff91bb8398 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818dc8a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000000b0
Call Trace:
 <TASK>
 kmem_cache_alloc_node_noprof+0x441/0x690
 do_kmem_cache_create+0x172/0x620
 create_boot_cache+0xbf/0x120
 kmem_cache_init+0x11a/0x1e0
 mm_core_init+0x7e/0xb0
 start_kernel+0x15a/0x3e0
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

