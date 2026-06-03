Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC134CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 22:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A99F6B008A; Wed,  3 Jun 2026 18:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A7C6B008C; Wed,  3 Jun 2026 18:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B746B0092; Wed,  3 Jun 2026 18:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 008646B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:47:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A8281C1E31
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:47:41 +0000 (UTC)
X-FDA: 84840089922.15.926DBBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6AEEC0004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:47:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bbQqIZXO;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780526860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7Sz/+Fr0suuQeg6EVNsiUNZZL7j8WmTr/VEGuzHW30=;
	b=g8mirMaf4nRpubDjkcG0YNGa4PssetIa3M5I3GiSmVoq2u7c4VLn3OGlr2Ow9A1Fj6dsAL
	196978XSCeXexDrybUoRAHJCnaAdSe83lxZfsmfRlZ81rhhSwy+wMmJ8P3zfFkyOc48apM
	PAplCic14uQF1Q+M4Fix4VrIFXWi0+Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bbQqIZXO;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780526860;
	b=iZaCZVmA/a8igZVIF1Yi39w5BGNXKiXfmxa5TDwt90b0EzFXC+oV0LjnKBmPZIZBNpRG0U
	5W49VlnXK72mzmoY/Ap8YIXnV+WQYmgj7x24kr0h42mUo1ciwXjTMcTg93PIHopx0YR1jL
	1g0a6wdIzRLKj+mvOIBqFkJaF6u4KyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37F47601F5;
	Wed,  3 Jun 2026 22:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F51F00893;
	Wed,  3 Jun 2026 22:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780526858;
	bh=R7Sz/+Fr0suuQeg6EVNsiUNZZL7j8WmTr/VEGuzHW30=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bbQqIZXOyyk7fzneEICQY56/lMcWDjClRrPFceC+/rWMhGEB8XAK3dziozHfdH17j
	 E1rwgyU6ZGwyFv/ZX4LcK+Irri7OE4WdDAFgP11VfB3U0LzlFzuLbUmz9064VNmFbZ
	 abaVMIlu4z9qNTtnU8HxF3YjN2Pdly1LauygKJdc=
Date: Wed, 3 Jun 2026 15:47:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-next@vger.kernel.org, matthew.brost@intel.com,
 rakie.kim@sk.com, sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, "Michael S . Tsirkin"
 <mst@redhat.com>
Subject: Re: [syzbot] [mm?] linux-next test error: kernel BUG in
 post_alloc_hook
Message-Id: <20260603154737.48dfcc19a51da03241e1af48@linux-foundation.org>
In-Reply-To: <6a20a309.85ccb786.283107.0005.GAE@google.com>
References: <6a20a309.85ccb786.283107.0005.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D6AEEC0004
X-Stat-Signature: nrbq8dxb51hpub16e7cgugwrkt5boc1s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780526859-22610
X-HE-Meta: U2FsdGVkX1/uNDONxwkoJAHDofNOHI51NTncW5xWsSC6q6oTPbpWUu6omkAsJ11Ob7g/YAWHqCIGn4VPvq0ZOKeLiVCM3HW9kQob3tD6UIjh1TEQKgekl2P+yYLmfuporZ+ZKK4eyD7sZ4S9uwJvezpgUqRsPUtdyMZLcKwoplSP7avI4wNAHfcXdxXwWar+z78GQ26zskioO+qupzz+rYG9ha9ZedxW5RNymjyHomkf60bDfHtp2Z4GsPcPc5rOv0odxfoyTK0yFDftI/Hn1z4SoX1DD0zP6U12CXWHLlPx/M3JAGGTrwn1ZrtcIjOr/VayUfnPCuUec2jZIGT9tx58OQULA2SYaNGbhjSvnaSUeE9YPT3YaUFweAVLhsVcZbBsa00F9YowrjD9NU2zPgy2gMaZPlBjVYnAkfsnWTz9NnXzO1b2xzyc2tQ8J1gr/FmK9EJtaIKREjp+cPIOaxPJZTs/qbdZgPE5XvBzz8Ryrcjco6aC+ryo1q3ynwq8m3N2ErrJKw4d5r3UVyIQ4Xa81nThxPf8pfeKeuHelWSKqMPP9yxFFFpsTyS1uAhDeUaG5l+kOUzqvmp4eVZ1phac+AFIKEYpSWtCZxW4tPmQeyrZxLhODLaKJhII975Plewfuu7Dc4LW+8bwKW8sIj0MHA6eXhzguacNKzipNHVPYJ8ZW+l1tkI2qXva2SsxRm2bwspHO7AdgoLAWRfokg2khS0Y5irUbvskmxe7tfS6IEI7PNQz5uCXf52Yx60fj75+ec9YmuHJDHfnL2FCI2bn8si9uUT5TYN37x6n3RlZLdIzPtChr2G+jyqtL7xMXyNAyHdXA3Qki873wmrHGbDLZmwisZUBVFtLLi+EhDsXJlJdgpDQTyhodccHWhUkh+GqzSDhjc1UbAbGUiPyIM5iq6X0eecSiyduKR+jR7n00EODWlsuHLpNQrfaOKphitHTy+9AUSrG93wZ4Ua
 2HrfzW+1
 K+KYoU2r+do9vHQ/P3XGYeLoY+/rqxJIe2jbk8VwB5S7jIaNlKlcuehIf96InKFXARQFa5HMlVoB2gxEi9iBt6Gt5WvWcgFT3SKW+4eyhDGl/LdxRy6PEi2QyI8Fesc7G2H/9US+JIkpdLZ+mmPIeyRRu38KvuX5TG2ho8dohJxzCtMhBpZCY/VffqZMBECH4CI0NMGLgetXNuGkzEjEPTJ9EGOomUqnYyZyVsZHhFXUBVTsMcBi23HfgOuscUw1giCLnj/o+sKOHCZd000I7wUtoXDEfZD9CiBmH780Df0eFmm98G4JTlrjpw4JtLTcuDrQW3LZ2HtpEAFK4Rxem95a3hy9pXw2uy0IB+2M0CLse99dDTW8D4t4r9+DU1jxrIlpOLUl11YxCz6riwI5V/hQ2jOrmRjTxoBqUavwr6FXr4DBCrDpfp3yaBb0KPSa/VoKZ6et3GlL5gJ6dVhSmjZ3L/Tte7KkZXJF5L54o3Cr+39GoNgabkJYx2kM1sljpQcXKGkB+O+3blx1WERJVUUk1EDNDjMFdKZPfZWlZaYs/8JNeyyddHWvBWv6QYiy+zgDwKUfsuZZmBQlMdkQe+mSItrtNVYLKXvlZZXXVxxrDtneS+6KF8RKRJIcpawR5Zkz6f7bfA2ryNa4p5lXfG8eBHjzIhohjdZwBdoImxTNtowYRQjMKJw8fU5M7RNo6Fyf9LgucCxrTiQ3CckI1egOS5YjB3He4F9joJcXe8+T7myNLqAfxEtFGq8WzN08XS2+VLcjSZvrF8IhSeLs/y4e0cjjMLcBpB63KnUe5vHWGfPSffyH0R3mkzM2Q1WgRkpvcn8W/whmq7k2+7lz51zRnz3yAr2KHuys90+kdWmh65noj3fDlO204KUWH978TlAUbZX9+CAbiDsEhAf2a0wI3tujxWlh4vo3ywUSa4wIKVEYFF+sLNkGf/mIwY4RDbunhZugZ8sOHaAZUE4+uaxz/qJTk
 2T97gJQk
 pQz5Oo/NUZckxjsXmc03Gd0XfxgUZS24HgVTVNe+ik/dzkiNJEfWUiCdVOy7eORPbHsiCnZ7Xkmqr/lQKquAkpS8SpAYfn1sUHKbPz1maBsenNipkpk4Y6Z4aFIr6XT8/WLJOKhYETLfV9BLLjLjjhPBDTbnpLbawGG4WWBgo9dysE7nPJELPgjEu9ofxrar0ZbTBfjS4PIqgulCXRtlzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc Mike Tsirkin)

On Wed, 03 Jun 2026 14:56:25 -0700 syzbot <syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a225caacc365 Add linux-next specific files for 20260603
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13b0de66580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=717edf2a5f9fc390
> dashboard link: https://syzkaller.appspot.com/bug?extid=8ffca916f3fa5455f9b4
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f799d07ea17d/disk-a225caac.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/72d0f0ff94e6/vmlinux-a225caac.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/99d4279e6fec/bzImage-a225caac.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com
> 
> ...
>
> **********************************************************
> **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> **                                                      **
> ** This system shows unhashed kernel memory addresses   **
> ** via the console, logs, and other interfaces. This    **
> ** might reduce the security of your system.            **
> **                                                      **
> ** If you see this message and you are not debugging    **
> ** the kernel, report this immediately to your system   **
> ** administrator!                                       **
> **                                                      **
> ** Use hash_pointers=always to force this mode off      **
> **                                                      **
> **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> **********************************************************

Geeze, who added that.

> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13fe38
> head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x100000000000040(head|node=0|zone=2)
> raw: 0100000000000040 dead000000000100 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> head: 0100000000000040 dead000000000100 dead000000000122 0000000000000000
> head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> head: 0100000000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
> head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000004
> page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/page-flags.h:682!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT_{RT,(undef)} 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
> RIP: 0010:__ClearPagePrezeroed include/linux/page-flags.h:682 [inline]
> RIP: 0010:post_alloc_hook+0x287/0x310 mm/page_alloc.c:1863

That's the __ClearPagePrezeroed(page) added by 504f40f6bda6 ("mm:
page_reporting: skip redundant zeroing of host-zeroed reported pages").

Was it intended that this series
(https://lore.kernel.org/cover.1779315441.git.mst@redhat.com) be
included in -next?  It's huge, it's late, review is minor.

<remainder of report is below>

> Code: ff ff 89 da be 01 00 00 00 48 c7 c7 40 50 4f 8e e8 ce 4b d4 02 e9 c5 fe ff ff 4c 89 ef 48 c7 c6 40 ef 7a 8b e8 2a c6 05 ff 90 <0f> 0b 31 ed f7 44 24 04 00 01 00 00 0f 84 8e fd ff ff e9 86 fd ff
> RSP: 0000:ffffffff8e0078e0 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff8e0fef40
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed10170c4903 R12: dffffc0000000000
> R13: ffffea0004ff8e00 R14: 1ffffd40009ff1c0 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff888125a79000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e1b8000 CR4: 00000000000100b0
> Call Trace:
>  <TASK>
>  prep_new_page mm/page_alloc.c:1925 [inline]
>  get_page_from_freelist+0x3081/0x3320 mm/page_alloc.c:4015
>  __alloc_frozen_pages_noprof+0x194/0x380 mm/page_alloc.c:5376
>  __alloc_pages_mpol+0xe0/0x390 mm/mempolicy.c:2495
>  alloc_slab_page mm/slub.c:3287 [inline]
>  allocate_slab+0x83/0x5e0 mm/slub.c:3404
>  new_slab mm/slub.c:3447 [inline]
>  ___slab_alloc+0x160/0x930 mm/slub.c:4485
>  __slab_alloc_node mm/slub.c:4549 [inline]
>  slab_alloc_node mm/slub.c:4925 [inline]
>  __do_kmalloc_node mm/slub.c:5331 [inline]
>  __kmalloc_noprof+0x140/0x7b0 mm/slub.c:5345
>  _kmalloc_noprof include/linux/slab.h:973 [inline]
>  _kzalloc_noprof include/linux/slab.h:1286 [inline]
>  __alloc_empty_sheaf mm/slub.c:2774 [inline]
>  alloc_empty_sheaf mm/slub.c:2794 [inline]
>  init_percpu_sheaves mm/slub.c:7555 [inline]
>  do_kmem_cache_create+0x8ae/0x9a0 mm/slub.c:8595
>  create_boot_cache+0xbf/0x120 mm/slab_common.c:717
>  create_kmalloc_cache+0x41/0xb0 mm/slab_common.c:735
>  new_kmalloc_cache+0xd4/0x180 mm/slab_common.c:982
>  create_kmalloc_caches+0x14/0x50 mm/slab_common.c:1005
>  kmem_cache_init+0x14a/0x1e0 mm/slub.c:8496
>  mm_core_init+0x7e/0xb0 mm/mm_init.c:2728
>  start_kernel+0x162/0x3e0 init/main.c:1034
>  x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
>  x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
>  common_startup_64+0x13e/0x157
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__ClearPagePrezeroed include/linux/page-flags.h:682 [inline]
> RIP: 0010:post_alloc_hook+0x287/0x310 mm/page_alloc.c:1863
> Code: ff ff 89 da be 01 00 00 00 48 c7 c7 40 50 4f 8e e8 ce 4b d4 02 e9 c5 fe ff ff 4c 89 ef 48 c7 c6 40 ef 7a 8b e8 2a c6 05 ff 90 <0f> 0b 31 ed f7 44 24 04 00 01 00 00 0f 84 8e fd ff ff e9 86 fd ff
> RSP: 0000:ffffffff8e0078e0 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff8e0fef40
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed10170c4903 R12: dffffc0000000000
> R13: ffffea0004ff8e00 R14: 1ffffd40009ff1c0 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff888125a79000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e1b8000 CR4: 00000000000100b0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

