Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E749CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 19:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983998E0003; Mon, 10 Nov 2025 14:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B508E0002; Mon, 10 Nov 2025 14:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898678E0003; Mon, 10 Nov 2025 14:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7542D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:22:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29B41C0241
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:22:29 +0000 (UTC)
X-FDA: 84095668818.23.6ABB5D1
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D6EE2000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:22:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3cjsSaQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3cjsSaQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762802547; a=rsa-sha256;
	cv=none;
	b=yEk/7B5p9eqGeaF6hGkpxlTF/tGo4PWYXIzsFeOhLMrD5/TXInlAwETNFM2s5igFwIcxTJ
	vZwX+ATY0eXVULQjpDrprgcoyna+ihXiVnErceESbyjc0InO7GU8+acpEUV1r77jUD8Irp
	hf762xG6aWw0kEcGvPg5TnTxYLdn5gE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3cjsSaQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3cjsSaQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762802547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=wl+H9Mj/MNZGwgtImdJWrasH0O/1gigXnZt/x9DQ9fY=;
	b=CHyT/cicVE8kTiehSFCv0ERMBaLVUDVXNXn3Bkb+Y4c92T/iI9QKLjTKdi+O1zvdfLtiti
	9GqwjFnT+CStWfSjvFY4577lGlPulYjRQmM3ILnotjPMVu2Q87rIiJ8MZTuB5RcP/24ZxS
	/A8SklmiQx3DbCdZ+iQDoIl921R6jwU=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-43321627eabso114806215ab.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:22:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762802546; x=1763407346;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wl+H9Mj/MNZGwgtImdJWrasH0O/1gigXnZt/x9DQ9fY=;
        b=ey9mwwV6lE2Xx8WnFcmlkO7QN7doznda7SwXwl1uRtvtgJX8SuVlkjkcVF0dglveNk
         tqIPoCaA3pREYE738liAXTQLd/QOojGgXk8M0ZC9lnnmLWd11sAc97NVdzidjaU0Fe99
         5ydxe3LCrVEZ6nqhmAsFvA80rYlClWzShwhfIBSnH6mce94mFyLjh3PLzpGowI3NzS0b
         lcLhxCjCvLWMSAOsdVZ+ka87OOHL3YD5m+HiuiUXl+39lEOtMwWyIfD7G5Y2TDsLWnMm
         bkH4y29PDGWJ8+OTi1/tqNOW5aGdcSG0vqejD60s6s6EYztBIevdxrdPmq+B0tMWgK0W
         oHCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR8CQiuNvWNk4isl5/vzGyDdeUcC2/aUXcvX+ZjOSXyBo3sc/xundYu6O6kHavW9FX7gRIUbRXfA==@kvack.org
X-Gm-Message-State: AOJu0YyE8Wh2rxZIYnIAnMYNMcaDbrDxc1/5+a1Yli+DANgImzrvg71/
	SQ9zxyKau5JdvQKNC4aoWJhDngpaiuVFhu3UH2Z5IroR2LF5eFoYr7mzVBw7qhVatTNidBx15eX
	+tKeBb0gSaX8Pi93rEwjWAeX3mHe3W/dkDhMsGnaFnLeRMJ6tXylCl/m69gY=
X-Google-Smtp-Source: AGHT+IEbPdtGfgRJqMVL2hawbUBqJT/8sv4vcnWwmm+eidH11LbtU0FVRNEsxsMeyGyMPxe7lShMhaEsnQrv4B9yHqEap8KA1zuM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:248f:b0:433:7a5f:943a with SMTP id
 e9e14a558f8ab-4337a5f94e7mr79790175ab.19.1762802546481; Mon, 10 Nov 2025
 11:22:26 -0800 (PST)
Date: Mon, 10 Nov 2025 11:22:26 -0800
In-Reply-To: <20251110160457.61791-1-vishal.moola@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69123b72.a70a0220.22f260.0105.GAE@google.com>
Subject: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
From: syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hch@infradead.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, urezki@gmail.com, 
	vishal.moola@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D6EE2000A
X-Stat-Signature: x64cnfdzif5bdi8tadetf39te7w7un65
X-HE-Tag: 1762802547-853965
X-HE-Meta: U2FsdGVkX1//2TVbCUbbzWAfdS9an0M5vk41dSCSuhnxhRCAQ5VJizS4Jo4yEr0ABMnUFos1f/vALuv2Lk8mNloo9w0R/Wdz+rBEdnlzj77XWWcjgzR76imRfq2fnkBv2k1/O2Ss/4z3IgqBzrXKyRBcIBxZ1JaSW1C4D64rvb1Cg1WLdFRyv0EiOw3gqqMl1yKc9kgAGb/DQELj637ahe4w3ZoL+51U1L+ufCnISkMvEME25JfjdLScRS2hHH5UY2CKkaJ6Z8mjLz6HQuLYZLmGaZUkEAk6dNPRfvQ0kH4ZB1itTaCUIFe2hsUV5GsLx4cOYxCJomWX4xmX/RNjvP/DWfEwmKo2E19eBhKfFFc1hfyEux03Khkem3QQih33bTScusHQcu2fxz+qq03t+EFPzVBNNRoM079UUHmUucvbsySW4DZ2zmldLhbZludC24OVhXXOppjmnETKT7MdU4bcsT8JYA7vlGkhkArkk4asuIUjs5YwO4dXnE8ZIlnD/LuwOD5WCwIdbifDT1OMQb1ltMA6DM+zQOkCvNRJid4TvWH/IPSVTUQoROYt9CWakAAFLw36Q5EczIzzviO4swAGaauYsjXJEXB9OgEbQFuwcS0GvjSwzWJrXaH7SGAN0Y6f8959kDJurHJXeAL6Lt4+5j6OePpolPPAxN+SPv8vteSrx/qs1iq+5yqYnrQHPSmhwIV1dQskWBkXD/01co3Rdz3W02ei8IHNJAbLbGSRrUx/l2QEIZBY7Fw/RLHuYHEJoruzE7dPfuSL58al2dn3cuq6wmBD8zjsWaAtg6ULaYf2oeaAsSXCTtfD+e8c4/bQux87aiHkyrA2FiOnRDrKwhJtmSqzaX4nHwTxW6uL9LJDMOXvIu4AqdcN0A5xc6zbcFlGQ9ZQ/MF1aKXX0zgMPAxL3QgyA6xrW8nbNURYl03ErM7Nz8ndCufkta+w9YeYqbPjaUqwuV87ruv
 zlEk2Sdn
 3NIEp/LkDjSm/mya/47/D70vSPREtxDa011eTDqNdlVQbESw6UfuIjhXYMuCrJ51UXSzCyVzpxacpohNBI30tkrdjg41GSfRX2OkxOAhOCKCFzP8sTATBHFKRSm/qHYjwkJzFwTd7XDUyPSPVZ+u2MjehobsIV3nD5FSaXi8dWleb/w7O0jbZQ3v96mlLy294RPUYaLw9TSjQh05H+gNKRAGEuGZW1dWnA+4im5nJ7uLnzXtRMXSClG6DycbllI7hXAlKFeNmgQLQAxKth49iTwl0SEnqM7rVvFMPQ69vWOXD2ZpmGKbT6dg11Ck/TveHlTROWEkD0OdcQJydNVafHZ1aDlDXYdebQMPlFMeRWyfvYefKymLJ7Hm7sea9zJi/z5ftJhTkSpMmiKy4egoWHqoLMJQGydc67GL/seARPbNQOv+0aslRQqaytfgNGmSM1dBTFSv2T3BrV1HWxNSpygb02isM+aqn5HnUiy3LDFiUsxz+20eRJTirrvBy4TErFENZqZiZf9NEX1iO2xt7ymYhmlkY3PKdpHlYDVxZ4hjDf2d25+KwZblULfroLv59XcX9NlB64fj1iDcfZ18KdF5kKXLnUWVJfdPx+Lj0coSOXKpQ+cyLa6tPeguiUQD+25b4De4dlR6eUcCgH62D3XK8w0TIcXbUYQbzDZy1/ulGOVDlmykGYxRsMFwKrUuX1H2Z1fCCJHd024hWjbwm4YnEzXeju95gKTCoByix906Xoeh0gHV3PcRZomHVxAoOlte2OpQgO6+cDEBQBrsephFv6QqV1Hs5KyENNX1JSG1wgL/8HNljlB7K1CCOtKKIWMsMY7h1J55GPND0nwO0duokk6BIi2HV5puNSuL1rgJQoiGrHLrSSxRKblpsZNHJwS2qLW9utUjnmiXFazRqGRTEIXMsSRA1dxebe+iB18p6/+yfvkGU2XP5c6q5pkHqFR3XvUpXmmDhHkSe5aZEgt6YSpU0
 ABqAdq74
 KkiqM/hip0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] make vmalloc gfp flags usage more apparent
https://lore.kernel.org/all/20251110160457.61791-1-vishal.moola@gmail.com
* [PATCH 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
* [PATCH 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
* [PATCH 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
* [PATCH 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/488ab7c0-de91-4749-bbb2-ca76c3fb798b

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2334ae39-552d-4ca2-8562-7adc18ce2cb0/config

can: broadcast manager protocol
can: netlink gateway - max_hops=1
can: SAE J1939
can: isotp protocol (max_pdu_size 8300)
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
NET: Registered PF_RXRPC protocol family
Key type rxrpc registered
Key type rxrpc_s registered
NET: Registered PF_KCM protocol family
lec:lane_module_init: lec.c: initialized
mpoa:atm_mpoa_init: mpc.c: initialized
l2tp_core: L2TP core driver, V2.0
l2tp_ppp: PPPoL2TP kernel driver, V2.0
l2tp_ip: L2TP IP encapsulation support (L2TPv3)
l2tp_netlink: L2TP netlink interface
l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
NET: Registered PF_PHONET protocol family
8021q: 802.1Q VLAN Support v1.8
sctp: Hash tables configured (bind 32/56)
NET: Registered PF_RDS protocol family
Registered RDS/infiniband transport
Registered RDS/tcp transport
tipc: Activated (version 2.0.0)
NET: Registered PF_TIPC protocol family
tipc: Started in single node mode
smc: adding smcd device lo without pnetid
NET: Registered PF_SMC protocol family
9pnet: Installing 9P2000 support
NET: Registered PF_CAIF protocol family
NET: Registered PF_IEEE802154 protocol family
Key type dns_resolver registered
Key type ceph registered
libceph: loaded (mon/osd proto 15/24)
batman_adv: B.A.T.M.A.N. advanced 2025.4 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
NET: Registered PF_VSOCK protocol family
mpls_gso: MPLS GSO support
IPI shorthand broadcast: enabled
sched_clock: Marking stable (21550045890, 115271513)->(21677757748, -12440345)
registered taskstats version 1
------------[ cut here ]------------
Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: CPU: 1 PID: 1 at mm/vmalloc.c:3936 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 fe ff 89 74 24 30 81 e3 e0 ad 01 00 89 5c 24 20 90 48 c7 c7 80 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 85 31 6e ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0000:ffffc90000066d60 EFLAGS: 00010246
RAX: 50a201fad922ca00 RBX: 0000000000000dc0 RCX: ffff888160a80000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90000066df8 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba678 R12: 1ffff9200000cdac
R13: dffffc0000000000 R14: ffffc90000066d80 R15: ffffc90000066d90
FS:  0000000000000000(0000) GS:ffff8882a9f32000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000dd38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120
 bpf_prog_alloc_no_stats+0x4a/0x4d0
 bpf_prog_alloc+0x3c/0x1a0
 bpf_prog_load+0x735/0x19e0
 __sys_bpf+0x507/0x860
 kern_sys_bpf+0x17d/0x6b0
 load+0x39e/0x940
 do_one_initcall+0x236/0x820
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x334/0x4b0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x4bc/0x870
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

