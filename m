Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640D5E98E0B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 08:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB1C6B0088; Mon, 23 Feb 2026 03:40:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F206B0089; Mon, 23 Feb 2026 03:40:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B4F6B008A; Mon, 23 Feb 2026 03:40:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C10E6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:40:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4EBFC2C2A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:40:10 +0000 (UTC)
X-FDA: 84475074180.11.235460C
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2AAB64000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:40:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3aBKcaQkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3aBKcaQkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771836009; a=rsa-sha256;
	cv=none;
	b=1BUl9fRIyzzqVBqAO4izh0bR+tUg7I5CJKgMvHO+XXB+a9IBg5hlEPomuMjQk3Ngf4rwJB
	8wfw+5862dfHNzaq69G0+kp+f5rgu1zsfUywQix928rfZZvkyWSYYxCrI0u/ASjdM1jYJr
	VqN/ziJEse9uey7wr5Jc4TBr/afws1w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3aBKcaQkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3aBKcaQkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771836009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=nUp2sLsTQG2be743RxBuEK2iTbA/TXBt6KIKc8LeryU=;
	b=8osJNY88SMXrPvjH0EvhYlIIzWJiJo69AZUGhzshdw8V4vn4jl+71r1DPlIIOdGqMiA53u
	TZeC7nE66D7N37W1pk7dMw9Z1H68gtj90QdEb1O549wTbEVded7rLXQcMYM0wcVWOOMb6d
	YZmRdk/uMIy55G2gWpBV1ZMr+JnOddk=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-66b612efb4aso51781759eaf.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 00:40:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771836008; x=1772440808;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nUp2sLsTQG2be743RxBuEK2iTbA/TXBt6KIKc8LeryU=;
        b=Oj6Jb4FLlCdrDxZtdzCijjQLKBRCwOngHqGjuFXVPQYDOwxBOgyLhcl6WNd4wTQRex
         e1RS0ccu4jsvb1q5FDpNN0Y9tqdhBstjkDWKNTK1zN4Z2Jwitspx6c1ieu1/+xtiA4Iz
         v//awHLnY4Lqj41JBdthz96UZBABFn4A5bWfiiDC4mBEWKEq8txI7GjLsfC6XPfHo39i
         1W/Yztsg8Z0axOxF3rm2AFojX9I9C3aRssK83okIUjM7jOHBlxLQm5WGaU16STMbIAix
         yxD2zClLQhwMpt2K46OTi2yWMbPJwSMl748Su4uQ73b9L/neuxCFYqSLJqVsOKHZopMl
         zDEg==
X-Forwarded-Encrypted: i=1; AJvYcCX6BOfSVaRrYMQxu62meVRqLGzg9u8MAGL/XyQezoOEWL+2le+oUr6Q8Bcl92MNGFgy8R3rk2gtGw==@kvack.org
X-Gm-Message-State: AOJu0Ywpqs1EZPV1lt3vuo6eFoSyY1Gv50Phz4xWIOODvaEpy3bnYENQ
	LELv9ZlGoz6LZWIyr9tiJVmabVRIf/S9jKJFanyMl5TrB0/wV2QBR0x8FlM+/g3DFHBS7RTmt6Z
	FlR2ebO34akaes/g0IaZgaFV08nooxey6x9+cyG7QWAVmyLcgmrRox3Dt/FU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:468c:b0:679:c41f:edf with SMTP id
 006d021491bc7-679c41f0fcdmr3630394eaf.29.1771836008198; Mon, 23 Feb 2026
 00:40:08 -0800 (PST)
Date: Mon, 23 Feb 2026 00:40:08 -0800
In-Reply-To: <20260223032641.1859381-1-ziy@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699c1268.050a0220.340abe.0d38.GAE@google.com>
Subject: [syzbot ci] Re: Zero page->private when freeing pages
From: syzbot ci <syzbot+cid1b0d4bbb448f87c@syzkaller.appspotmail.com>
To: airlied@gmail.com, akpm@linux-foundation.org, aliceryhl@google.com, 
	arve@android.com, axboe@kernel.dk, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, christian.koenig@amd.com, 
	cl@gentwo.org, cmllamas@google.com, dave@stgolabs.net, david@kernel.org, 
	dennis@kernel.org, dev.jain@arm.com, dhavale@google.com, dlemoal@kernel.org, 
	dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, 
	guochunhai@vivo.com, hannes@cmpxchg.org, harry.yoo@oracle.com, 
	jackmanb@google.com, jefflexu@linux.alibaba.com, johannes.thumshirn@wdc.com, 
	katrinzhou@tencent.com, kernelxing@tencent.com, kprateek.nayak@amd.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, lihongbo22@huawei.com, 
	linux-block@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	maarten.lankhorst@linux.intel.com, matthew.auld@intel.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	mripard@kernel.org, npache@redhat.com, ray.huang@amd.com, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, sandeen@redhat.com, 
	simona@ffwll.ch, surenb@google.com, tj@kernel.org, tkjos@android.com, 
	tzimmermann@suse.de, vbabka@kernel.org, xiang@kernel.org, zbestahu@gmail.com, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2AAB64000D
X-Stat-Signature: 9hn4d1kjbzrz5ft7sctnqawgr86wfzrh
X-HE-Tag: 1771836008-473671
X-HE-Meta: U2FsdGVkX19/7ftq4hhFZbyCTBmVORBmtV3UsotjbE10g77w4ld3o7UXURfG8fgNRDaB9D1gA9ytjMLI2bBhFcs/oVpQ7dkTmRm9aZgc8OjXvYD9OOgt8HxhvFhgCKK0TbYI5SQ7Nrz66zYXNEuvFE5sh6azCyrHxtWgvJe7iaYMoZeNpK0uThbtQQBQHM9rKUN1yDBMZRAKlJlN2rPrB3dam+7rjuAMbOZpLYq/eZ0E7spt/5NSEBCe32EssWdTQbgNbGJWP2C3plns+4MpwV4ARm/SyokkxhS+yi5Xd0FBlVBrwRRPywHj3wE2PwYxq/TUuc5eM7FoEBEJ1dPM1O9Zc/QIPGY4Buy/biGlEZXJaE1309C2ntIkYEiIxArE0H7iT65NmDP5valdM+nimoGg3Skf2aCcMbZuq5P0o9PO33+ZOcBQkjJjD0zxcSt0l1S6JxgsHt2blbUmXY03HKT5hGxEH9U2atyIiuPgXx14w53chId0xZCjHKWcj7YT6BxUxKTb/SYZ8XNdTdlvFYBbjo73sqDZ5T9E6Cnjk6NWYMHoUeGiz2oA4clKID4GBvQlT8sSKqwEOtsQYQCL3XFVmFfJhUGmP9IkpBtRBXTkPlgThsBIuSbpi5rq9JjPgL/mmWfeOOikFHYAB7h734z598BAPVo19iYSEq9izayYPF1K7IdICSa1f8rnvGP+XjKg1It9VXkaV5my7MXSnEbZ1kcdFQKiaKXUSdVY+JKwqARF8Nl/5CRS1aVEBucEyRVDnDSAS0DHtxMMFeq4XQWl2tlPHR2igjsX3lNScqD8HaRUa1v6NZsxvEoe6iQE97eBxLiTbTv1NCd6SeD0gWGLDzfp9mrkoYKu5iwtyKPIG6Culmlr1nJCUmAiBa2wlqCCHqDcXeh46bi4O+rgjRBL0n4+fqRiSdvyPHnWkSKky/mJIDAuzFxNoDa9ox0MqRHvbwuymIdnB2DB+fa
 SPtfuyrJ
 ur1qWhlysX29zPt5iHk3AkRNNR9TU9xmFVlKsjAQP9K3Y1L+CCyqB6TZ3iFdxQzzydP8mxupv/y9C4N76jhtZgr3k3csvzySLHkaoxWmnkuDKchZl90CUc1fOWnnYP+QxhX3kY/2jnVXZjbQmRZzx/Cy14zUOezcYfPJiqv0Zt56bbXw9O40PYEneStGHaMzehSD/zuridbej3jF6Dm5KWaqjh+xyqCVdodoiM4j4Z4qlg7UbPmZFBGY4C7l1dzzeB58mefcOOiESxmQng1KWNKRvE38lTXiwPtufxyKucN9tJnwUYOYGbAQFhmnY1WWdtqGfgedFFPlrsFJI3QKJc4gOiEOtWi2EuT3kHqzuA/kEWSUJvAJsd+rPr3dy6BIaR6p+6nFiNTQRl+gHid4fryo71LU4kIRQVnBs+UfzPOOiha3BhMBqRPrtjt+RY//4N793kEi3j/ojxpkUTntFtra3WIRprLx8C5pO3EFSntV9UkaK+GY2iuZtu7SHW2UoyaOPB9mFSO7uD7XzzlqrUgmMZbalGsbgPSoHL8YrtX1YAQzECMiu5KcSCkgrE1zrbaLCTwjs0QChrdVtrGaouc38vLx1bMf7f7quhNHNZ1HqvDeZka0Haj2Y9PqLNKq1mA7aXJPXN4WZc6rF7j/KaMDEUTywoLa47hzEPf7e3UA4j7QP+URozP2faXWOJru5AHNlD3Ev9dRgWsjzhvBSKpFDpel6y454YeC8ihvNZczdMU08FSzgKw2B5h4gu3p4ADZGQ3ymJauwpFXxTtQHjlDJNL8kqiRp39NsIFs1tKnE4Vz84QdQImg0MTj4YU7yqbOPV/jwChUgw0wZpxmEew2zQ4ZxxEz9xlha+d+NXYi1J/kH6a4TBTbE7SVK5oCRM0pWUM6o+LAbi/6tckmKNJi6h2+z2x4iXSgVTjLepcILAre68FkPYCjgLkhugRintTaxsu+1f0JFiIpOr50AavNzSDGs
 00hp6ynK
 thI7Kz0+TWZiksSybcm8GWHJgOCHuwqa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] Zero page->private when freeing pages
https://lore.kernel.org/all/20260223032641.1859381-1-ziy@nvidia.com
* [PATCH v1 01/11] relay: zero page->private when freeing pages
* [PATCH v1 02/11] mm/slub: zero page->private when freeing pages
* [PATCH v1 03/11] drm/ttm: zero page->private when freeing pages
* [PATCH v1 04/11] blk-mq: zero page->private when freeing pages
* [PATCH v1 05/11] watch_queue: zero page->private when freeing pages
* [PATCH v1 06/11] binder: zero page->private when freeing pages
* [PATCH v1 07/11] null_blk: zero page->private when freeing pages
* [PATCH v1 08/11] percpu: zero page->private when freeing pages
* [PATCH v1 09/11] erofs: zero page->private when freeing pages
* [PATCH v1 10/11] mm/huge_memory: add page->private check back in __split_folio_to_order()
* [PATCH v1 11/11] mm/page_alloc: check page->private upon page free

and found the following issue:
WARNING in __free_frozen_pages

Full report is available here:
https://ci.syzbot.org/series/10f470ac-46ac-4e38-902d-dc86ae743494

***

WARNING in __free_frozen_pages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      a6fdc327de4678e54b5122441c970371014117b0
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0586347c-8ef1-427f-8a9c-7f6c08b616a9/config

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
batman_adv: B.A.T.M.A.N. advanced 2025.5 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
NET: Registered PF_VSOCK protocol family
mpls_gso: MPLS GSO support
IPI shorthand broadcast: enabled
sched_clock: Marking stable (19970046340, 93374727)->(20073238384, -9817317)
registered taskstats version 1
Loading compiled-in X.509 certificates
Loaded X.509 cert 'Build time autogenerated kernel key: 98092a222e11368da223b039d625e21c3e2e069c'
zswap: loaded using pool 842
Demotion targets for Node 0: null
Demotion targets for Node 1: null
debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
------------[ cut here ]------------
page->private
WARNING: mm/page_alloc.c:1433 at __free_frozen_pages+0x78e/0xe10, CPU#0: swapper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__free_frozen_pages+0x78e/0xe10
Code: 5f 5d e9 05 1e 00 00 48 b8 00 00 00 00 00 fc ff df 0f b6 44 05 00 84 c0 0f 85 d7 02 00 00 c7 03 ff ff ff ff e9 22 fc ff ff 90 <0f> 0b 90 e9 8d fc ff ff bd 01 00 00 00 83 f8 05 0f 85 bb fe ff ff
RSP: 0000:ffffc900000676e0 EFLAGS: 00010282
RAX: 1ffffd4000bad935 RBX: ffffea0005d6c9a8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffea0005d6c9b4
RBP: ffffea0005d6c9b8 R08: ffffea0005d6c9b7 R09: 1ffffd4000bad936
R10: dffffc0000000000 R11: fffff94000bad937 R12: ffffea0005d6c980
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818de64000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 destroy_args+0x15d/0x570
 debug_vm_pgtable+0x3f8/0x410
 do_one_initcall+0x250/0x8d0
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x2a6/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x51e/0xb90
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

