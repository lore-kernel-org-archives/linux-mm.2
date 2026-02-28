Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23988FEE4E9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 11:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1A56B0088; Sat, 28 Feb 2026 06:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377A66B0089; Sat, 28 Feb 2026 06:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2735C6B008A; Sat, 28 Feb 2026 06:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 124456B0088
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 06:20:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BC6F140BE2
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:20:12 +0000 (UTC)
X-FDA: 84493621464.15.D1ECE59
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf02.hostedemail.com (Postfix) with ESMTP id D6BCA80010
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:20:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3ac-iaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3ac-iaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772277610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=kRhMowKcflxsR17ISGHfZ1IJzdddfU77+fgfBnAwVmk=;
	b=PvyNfGDKIhEEz1OfQG+IUH6trO6I5ZUiZpwxfondlESk+KN5VWbQ4JF4Rl1K8im2RbfPkv
	5UjLvaCK8yJQAVD2np4fmpZWBt6Mi/qjIHtLyD2FpYD+Z3AQnBIAKp2457sX3F+AD5JxpM
	RqyepByGmZxgYOGEgENU9GfFClNtkSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772277611; a=rsa-sha256;
	cv=none;
	b=U0CdVL1en6VAy98m7yC0cLoAtYR3zLsqhNS9xoweJOAx7shIrbT2Y/aiy7pfLAx5eIqtxd
	OOhuuIPDxM3hs2tTeUwxnI04EvzEd/Yl9GeAqTpYJMZCTE938yNbTZxHraJcQyEOtRxhwI
	dBuy7z7RnvEoXNofZ0+uComNspXtIII=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3ac-iaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3ac-iaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679dcf1f680so77405052eaf.0
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 03:20:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772277610; x=1772882410;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kRhMowKcflxsR17ISGHfZ1IJzdddfU77+fgfBnAwVmk=;
        b=PBwZgfi11RA1yHMN1Uah2uDBtO8TnqT+T5LjTpAyOxHamG8vG7i7+x+bkH4paGhEik
         HGkl1KJe19SRGvOZBCMfF2mRrc1pwX+yuZhycjqK+F7TKUipWGxNUQzNrw2EGfggjinM
         tpMj0TYlxeOEarKBe/Dam4KoJ14zYGxGbQiZOhgO3FqhBR6Bgbm0Matagco9eqP0u+Er
         1AOOCVh6/GGdGGSLJV3i9kq2uuAi0pLtsTxrRFSZegLDh/1MYwwM1UgqCgog9kQf5Ek5
         XQiS5uJrokpq1gu9UQ/8vSKHa6+2RcFu7/6KCE95FYzM8J5aS4+6qS5Y64eNr/43/an7
         Nydg==
X-Forwarded-Encrypted: i=1; AJvYcCWfRgSRZGVTs7VJqGBYiDx+SXlhIklKYPrEe3jrnngMnsAK4GuXrGsXPR8Cdt3sPGwIl1SH4I3MuQ==@kvack.org
X-Gm-Message-State: AOJu0YzGu9Eozf6XaIZsFV9jeleOwdT8aYpbx33sM9K0byBhqGCWELe7
	Xjh6kskwmzo1ahf3/fNwXsuvcUVDxfenVVYOhk/EdByDhsbfcfhyo4R3tWDjoSAtBHPZ/BATNK8
	bYPIypI1Sg9DxdBXNJtMwTyEpV9WXihRP+lP6a2jSFdmBUzzPcSmCrWoitOo=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1b10:b0:677:e168:3f57 with SMTP id
 006d021491bc7-679fadc3022mr3603971eaf.4.1772277609900; Sat, 28 Feb 2026
 03:20:09 -0800 (PST)
Date: Sat, 28 Feb 2026 03:20:09 -0800
In-Reply-To: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a2cf69.050a0220.3a55be.0037.GAE@google.com>
Subject: [syzbot ci] Re: mm: bail out when the PMD has been set in bloom filter
From: syzbot ci <syzbot+ci8d828f9cb74f67f6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, huangzhaoyang@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, steve.kang@unisoc.com, 
	yuzhao@google.com, zhaoyang.huang@unisoc.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: pbgih1xnn7tz796bskcac8gwpueybxis
X-Rspamd-Queue-Id: D6BCA80010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772277610-79227
X-HE-Meta: U2FsdGVkX18XhrplIaDK+GndmwY1qFXbqh7wIJlngj8A9mqe+7Kmj6r1Z4EdoJCn/Z9Re7D9SlcH7A0ihWsYgk5VjINpBBd/0whmFdxa3ztulHWN3usF5HaLvuWJ5IxdVBpkRFVSoxbp7lx6VAM8Por0IhTjavZppVZDmEqKHzP3oan5I6lEtU4N+pwyeFFyos1MK4cuGe8/4/8Gt0G8pKNQa02osSCFeJSk9UzPCDfbPLlUWnddGJeerGAwm3zuqH5x8lHjYN0de9mI9xiXqbvKpSMvbR3609un+8XjSn8bjHYqW3B/vuUgHktz/RssNTpu7R30Bz6QVip7pwDTkh33+BUeFXokCrTA7UI02jJ5sx2/LkYTaDIV9BFixBeSz2B0O6AuPIjtiIB9Wyq8Y9vYKSCz4cVDypKfYZbWyH5o+XYlSLbmN+gIYGJUILG4NzPfXACr6gj70L8VRz+6uwJ3K3mCTbp5llXGBpwKXYDEpPM5PniyxP93M1Fwt3p0HCHYBUk971DKiW0XA0aLqu7ZIV1llWx5d3LqFI5THWM3OUiaD59N7+dk/Kv3SrIvj8m6RKwwaJzpXW1XAnb+CrkpRwk+WDLtHNdBcZM0Ga7hNsMlQHutRD13008kHGtGhv5zBVIxM/SR9NMUXlFS+2mbdf8NoXqFxD8hGG4cCm8CtZ5AIMRo3/fRp3XYu1v1wKSasoS9m31lPTQfSyI+LO8r6cCHcb1pjMe9vSmte01r2BMT24+bYzTqZD3GH7QmV4awaJ7XV7whBZJ93ttZ9Z+rbAcvcZLhrVRFL1GN3GukJpfBXWEyMDDWA+SyE9qDdXz2eiHcyb6QSB3OAHeXt/BEjxMgGSBXk70K6DBchz5isgrmqroFCMlk+wpx30EMsTAv4dF33ZsVZIv7+kMeUfyHysdLUQ4iY9Cg3WOK+jEq3aYEUr9dgr6HBZErW0e1x020cFt1Kp+1K5MzrQK
 V1eAk1Ks
 oRAqgQfE91G28Q/Ivrr3iem3aqm+wxBwW43nD1HDqNUbOk3SCs6OcO69x0yYd6ugyyV+G3iA6zpvNQV/d+58ErEdiOWsVezFBm2Ekw2yUJ85F8+h6Ae44a9NdU5QF6VfBxnrj6cLXZ9iHCQghn7mvmVCnBHdFabNsyKGPfsUHI1binMozrnBNfEbN2UJf/4iNV3cxnJXDI6XYfiR9GBBOmxEiK1Wxgx7QftweE3M6eBzAI2DQODpaaUk86gJHh1GHvQ1kqcOhnbJDc95J9Mbg3ZY/o4s7Q3PQz1J3vU+xiHu57jzuMp9lJVgYJaBaZdGgnoM7xgyXS6dKKHiBGUE0tOaWZx4ehGT8jxoXwYmS2PX0ELZzo4AAWpp2VEhaIax1EMFAnkjSi94j2F5yWG8VEDpyCyx6IsIjL2cseGGC3RJSKzB4rNs5fRMIilpoujgg8qUrfQrSgsjmSMcqrPYhRgMNhxj1whhgTGttEWtk6INTftnRosTE7FaEvNrdxQ8mDKxUi8WMf4senav8RViAv42iNWbkyubJaDjTh09FUrL2Rb1rOXPFiX38GbMgLgDdnKsdkg+aTlWvbA6TnU+iHZ611TAHxIMGMnskWb89Lgrt8/PAkCIZVV9QdClYdiO9JIf16bVnvDJBWAAhp77wanPx4gSqO/I6AAA4Bbi9L3GzjkIF7AGKD9/8ZxkRxF268liSYuIkguRTAo2XbBD1h/LEEEF5PYf6ICcvSgoPLnc9reYHDeJZpt07rr9Rl/PF7E31ncAgm22BIm0je6ideVHzQkf6r488We5TkCmERXRcrt1V4rjhrS7OG1FVUpNsLEkAp2A0ZxiA4fSK1Vc9y/ZFTqrAgGG1Uc5y2lDLMo9sIT0Qdu47ezO+HDHVWY/aWYJRIYZ3ZvDUmVea6Msu4/XDDWe6eevfCfcjC/I/HvHlSBsPFzFHUCPVLBpTqmB/E6gUEJj9InLo1z3e89YwzIyU2vxZ
 ojFJKNDR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: bail out when the PMD has been set in bloom filter
https://lore.kernel.org/all/20260227075250.1128175-1-zhaoyang.huang@unisoc.com
* [PATCH] mm: bail out when the PMD has been set in bloom filter

and found the following issue:
general protection fault in lru_gen_look_around

Full report is available here:
https://ci.syzbot.org/series/78ce04ff-c36e-4bcc-a097-f457e3ed9e5e

***

general protection fault in lru_gen_look_around

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      8982358e1c87e3e1dc0aad37f4f93efe9c1cfe03
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e976d408-587c-416f-85ab-a60940674f35/config
C repro:   https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca118f9c/c_repro
syz repro: https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca118f9c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 5967 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 03 42 80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03 00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 folio_referenced_one+0x724/0x1360 mm/rmap.c:962
 rmap_walk_anon+0x5cb/0x7c0 mm/rmap.c:2973
 rmap_walk mm/rmap.c:3078 [inline]
 folio_referenced+0x3c0/0x5f0 mm/rmap.c:1081
 folio_check_references mm/vmscan.c:870 [inline]
 shrink_folio_list+0x1008/0x5240 mm/vmscan.c:1237
 evict_folios+0x3f82/0x5090 mm/vmscan.c:4853
 try_to_shrink_lruvec+0xb62/0xfa0 mm/vmscan.c:5008
 lru_gen_shrink_lruvec mm/vmscan.c:5157 [inline]
 shrink_lruvec+0x54e/0x2b30 mm/vmscan.c:5911
 shrink_node_memcgs mm/vmscan.c:6147 [inline]
 shrink_node+0xa41/0x3a90 mm/vmscan.c:6188
 shrink_zones mm/vmscan.c:6427 [inline]
 do_try_to_free_pages+0x6a2/0x1980 mm/vmscan.c:6489
 try_to_free_mem_cgroup_pages+0x2ff/0x870 mm/vmscan.c:6811
 try_charge_memcg+0x827/0x1560 mm/memcontrol.c:2642
 obj_cgroup_charge_pages mm/memcontrol.c:3084 [inline]
 __memcg_kmem_charge_page+0x32a/0x530 mm/memcontrol.c:3128
 __alloc_frozen_pages_noprof+0x1c1/0x380 mm/page_alloc.c:5271
 __alloc_pages_noprof mm/page_alloc.c:5288 [inline]
 alloc_pages_bulk_noprof+0x569/0x710 mm/page_alloc.c:5208
 alloc_pages_bulk_mempolicy_noprof+0x34e/0x1680 mm/mempolicy.c:2792
 vm_area_alloc_pages mm/vmalloc.c:3700 [inline]
 __vmalloc_area_node mm/vmalloc.c:3875 [inline]
 __vmalloc_node_range_noprof+0xbd9/0x1a80 mm/vmalloc.c:4058
 __bpf_map_area_alloc kernel/bpf/syscall.c:404 [inline]
 bpf_map_area_alloc+0x12d/0x170 kernel/bpf/syscall.c:411
 bloom_map_alloc+0x22f/0x470 kernel/bpf/bloom_filter.c:146
 map_create+0xafd/0x16a0 kernel/bpf/syscall.c:1507
 __sys_bpf+0x6e1/0x950 kernel/bpf/syscall.c:6210
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f475359c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff2e480d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f4753815fa0 RCX: 00007f475359c799
RDX: 0000000000000050 RSI: 0000200000000dc0 RDI: 0000000000000000
RBP: 00007f4753632bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4753815fac R14: 00007f4753815fa0 R15: 00007f4753815fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 03 42 80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03 00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	22 be ff 48 c7 44    	and    0x44c748ff(%rsi),%bh
   6:	24 48                	and    $0x48,%al
   8:	00 00                	add    %al,(%rax)
   a:	00 00                	add    %al,(%rax)
   c:	48 83 c3 28          	add    $0x28,%rbx
  10:	48 89 dd             	mov    %rbx,%rbp
  13:	48 c1 ed 03          	shr    $0x3,%rbp
  17:	42 80 7c 25 00 00    	cmpb   $0x0,0x0(%rbp,%r12,1)
  1d:	74 08                	je     0x27
  1f:	48 89 df             	mov    %rbx,%rdi
  22:	e8 97 b5 28 00       	call   0x28b5be
  27:	4c 8b 3b             	mov    (%rbx),%r15
* 2a:	41 80 7c 24 03 00    	cmpb   $0x0,0x3(%r12) <-- trapping instruction
  30:	74 0a                	je     0x3c
  32:	bf 18 00 00 00       	mov    $0x18,%edi
  37:	e8 82 b5 28 00       	call   0x28b5be
  3c:	4c                   	rex.WR
  3d:	8b                   	.byte 0x8b
  3e:	24 25                	and    $0x25,%al


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

