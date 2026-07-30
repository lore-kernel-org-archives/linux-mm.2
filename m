Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D55C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023736B0088; Thu, 30 Jul 2026 11:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EDC6B008A; Thu, 30 Jul 2026 11:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BD86B008C; Thu, 30 Jul 2026 11:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB6E66B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:54:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C3461401EA
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:54:10 +0000 (UTC)
X-FDA: 85045889460.15.3101AA7
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 868B016000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:54:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=steffen.cc header.s=MBO0001 header.b=ABZbzREX;
	spf=pass (imf08.hostedemail.com: domain of lists@steffen.cc designates 80.241.56.172 as permitted sender) smtp.mailfrom=lists@steffen.cc;
	dmarc=pass (policy=none) header.from=steffen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785426847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zksK9+idUghCnssEho47J7vh5F4rjyXM/CYHhLvbBuI=;
	b=vP75fIOuFsUaMG7TK3Q3mbKRykwtRzlV64RKHBOwmziEEQQ2cimwW5d/8aIF2Fxx9eo2HH
	1HdTcUlSgvlURkCgNQYdUJNrVRBiJDvu2BUgZ1F9W04fkqu9bmWDTO6Fu2zxEkt4N9HBWr
	QWmDKISqwmiEeljVRJVrnX7lLQNeAEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785426847;
	b=6gUJCFJikB+0EUj0NREAEsLU3IYCln/ninMoIqPt2JN9RrO00FV87aXlOjeQ7K84bCJhjV
	mOUq5wXpv4iQqrCfPPnpsbwl7LexcxYLcMg5vmzqYxgh6n72BStj9QGoUzhMjDJWUcDuol
	mqHPBeXjX/MSUZeS3gV9tEunrMzK+5Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=steffen.cc header.s=MBO0001 header.b=ABZbzREX;
	spf=pass (imf08.hostedemail.com: domain of lists@steffen.cc designates 80.241.56.172 as permitted sender) smtp.mailfrom=lists@steffen.cc;
	dmarc=pass (policy=none) header.from=steffen.cc
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4h9tzb1p9xzMlLY;
	Thu, 30 Jul 2026 17:54:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=steffen.cc; s=MBO0001;
	t=1785426843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zksK9+idUghCnssEho47J7vh5F4rjyXM/CYHhLvbBuI=;
	b=ABZbzREXVJlaEcXgHG6Q5/DFAD8yXognsvS9ozhwczAK4KfoCrR/A72xRMgHKDC8YIEHLe
	Xn9qtIxZSPiNPKquwlhB7/1Gk8XTwi+J/r4tMfnpBk8xvYMaNwPIfm5PordRc43ww97P00
	Jlrtk6YZxv7VAyXc4t/t4Of00EpMpJPiV1bC2yiM0VkDlHg5kd84sxdZjKKVFFm+ryM5F5
	gpZQ+9ahyq7YOxjG1mAXkh90nWU5n1iyir5FMhbDOuJ9g/if5fIUcTwCcw6hoKXwSm8boK
	9O+X6szUa5iUHT7GicwTLGH+AVMEvUXawnKwHceK1hVijvcn2WaBoaByTd+shQ==
Message-ID: <555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc>
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
From: Steffen Dirkwinkel <lists@steffen.cc>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Dave Hansen
	 <dave.hansen@linux.intel.com>, "Denis V. Lunev" <den@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>,  Borislav Petkov	 <bp@alien8.de>, David CARLIER
 <devnexen@gmail.com>, David Hildenbrand	 <david@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,  Juergen Gross
 <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau
 <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,  "H. Peter Anvin"	
 <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Shakeel Butt	
 <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Thomas
 Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>, Vishal Moola
 <vishal.moola@gmail.com>,  Vlastimil Babka <vbabka@kernel.org>, Will Deacon
 <will@kernel.org>, iommu@lists.linux.dev, 	linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org, 	x86@kernel.org,
 syzbot@syzkaller.appspotmail.com
Date: Thu, 30 Jul 2026 17:53:50 +0200
In-Reply-To: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 868B016000D
X-Stat-Signature: e6gey6s58kccan466e3w9m1r4dexnqxr
X-Rspam-User: 
X-HE-Tag: 1785426846-862010
X-HE-Meta: U2FsdGVkX18mm/lpvym2WYCX0UYefVFbh50kWK/jnYRpUWNhdNhohVgZQa7O+slO388yjD8zPcmvyYtydaPOlfUboqvB2/aUzCsk4o1XHvpPhS6l33SoPZzqhvbKLFsYAxTDoogShQoFxYO1xe34j4zDNXvib8fChNtvBHtkUBFqFBZC6jHKaUq1kS9oVU1SyFG9OCWPcpGK8AnWZeqYfXZ7cjvkF0S3gMBwQLwnPkNMExDUZwopaKcdiBZm2mAvzhorO03dm9rL/3J3eWxmAnvDFmLorvnK0gYk4M8qWcsj6k+susk+CH7S+vHL0TVMHxbDO8+MvwnZ4udtxgsXOwHOtJ+2Pxko+aiXa4afihwQ4gZUeeA6v2K7IhWZZp6CsAqrtpQdcyJIe9JtfMY7F2xa/5I6c3Ls957K/vsq87lJkYDHUjxD75S/quKM21RhxWpTaFP5QVtdENPrDITWAhClH0Uqn6M6oTLWqPDpBToNnPDf2cIzx0b7uQgctmEGk+Dnc+S4+tW/e1HBjJcPsqfS2XCD3AIHJ3b5IXEpZ1vls/93RBTCdApgfcktnuEuM1yktlpAM19cc4KVWDT4X9McbqOgPzfYLTPEDymscMNKag/RC061tG0BwhSJD5+S9bkuacoNWwlBIGG0lfmnllHn2fLhwYNsJ4sMZXMgAtKNuRnsI1S7y7bKYKlNBFZmhau0ErE1tdSU62I56Sqy7duIdmh9mH/IsxtG1t8X3Va/NUP9FL99JIlKLO2EGz81wxkbErInJ7WMA4ge5h95n7lpn7WniSju9ebrsXWJtekfqGqW+Jq/AA2Vh9rIwfXmyUZELVuzFCy5YupHW+fHUNIR4wxE/BcIlPTi6qR5MfPRk5KJ1xDzh/R/uPK39uDRi+NJW5iqdEdjOeVdkha8zlkDVZg7UWiqieLuRHvvO02IQyNJiTUz4VS1Kc8l8K40ChHtyanNDKkxOMwKDTZ
 Z2VB08qJ
 WwlYk5tq7e5TEixqSoeSjGk91uN+URWc3xngnenXq0EBrVSvk5Eh7izonUl9SBNE833C7of/X+rBC4+W9seEQWOycvWYOh5fS31Ey52mmdyKUkWiK9LcdKOB8PAWfbgF3mUOTtNNU8FGjn2SLiwcvisuWD7mcrXHAFO7PKWo8KkagWHUQAYm5ypqik6Yx+MGpFcbyNNtjRQadyo67K7t0+VISw5sjqrKpoF51uyYLXOVz7MGGeDnRoj+mW07JxNE0QZOuWZIqd3CarcInCfsmXSOhcOpDwpyWSHAWQIYlytck1AdAYtXfyouUSmq+tDH88mZWlnptH39XbMV3PKlbm3L4IVuqpfgegt66lDiwinonYPrkO0LUfkxFyt9O32ODfOohqQ5v2a7JVO2Uyfx0QskRTcdw/uIZL8b8qFMhyATjQmRS9rwl6uDzR2SE5OxBjHH4nI7oPkAnMYA1QG0izT7qM9PxAxGn6Ldz41GFS15M6xhf6Jo1uQ4qirhimkW7ccX5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


On Tue, 2026-07-28 at 16:07 +0300, Mike Rapoport (Microsoft) wrote:
> There are a couple of CPA fixes floating around:
>=20
> Denis Lunev fixed races between split and collapse of the large mappings:
>=20
> https://lore.kernel.org/all/20260715183453.2381141-1-den@openvz.org

We saw the error below and I was wondering if it might be related to these =
fixes
or a similar case that's unfixed still. Seems to have happened during concu=
rrent
kernel module loading of kvm and i915 (similar to the case in the patch fro=
m
Denis Lunev). But we got it without KASAN and the stack looks a little
different. I was not able to reproduce this with a ~16 hour concurrent modu=
le
load unload loop so far.

Kernel: v7.1.5, PREEMPT_RT, tainted because of /dev/msr access
CPU: Elkhart Lake Atom X6214RE, 2 cores, isolcpus=3D1-N

------------[ cut here ]------------
kernel BUG at arch/x86/kernel/alternative.c:2644!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
CPU: 0 UID: 0 PID: 559 Comm: (udev-worker) Tainted: G S                  7.=
1.5-
rt1-bhf-369933-f1a4ee1dd787 #1 PREEMPT_{RT,(lazy)}=20
Tainted: [S]=3DCPU_OUT_OF_SPEC
Hardware name: Beckhoff Automation GmbH & Co. KG MC6015-0030/MC15083, BIOS =
Bxx83
- 0.11a PxeFailTst4.2 01/07/2026
RIP: 0010:__text_poke+0x356/0x3d0
Code: 00 10 00 00 77 26 48 85 c0 0f 85 74 fd ff ff e9 2d ff ff ff 48 89 ea =
4c 89
f6 48 89 df e8 22 0a 33 01 85 c0 0f 84 90 fe ff ff <0f> 0b>
RSP: 0018:ffffa8bb010afa70 EFLAGS: 00010006
RAX: 0000000000000088 RBX: ffffffffc07402b9 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffffb793166b RDI: ffffffffc07402b9
RBP: 0000000000000004 R08: 0000000000000033 R09: 8000000000000063
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffb435e470
R13: 00004b8f944092b9 R14: ffffffffb793166b R15: 00000000000002bd
FS:  00007f205444c9c0(0000) GS:ffff9964b8518000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc66a0ed18 CR3: 0000000106551000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 smp_text_poke_batch_finish+0x1aa/0x3a0
 ? vmx_switch_vmcs+0xc8/0xd0 [kvm_intel]
 __static_call_transform+0xfa/0x1f0
 ? vmx_switch_vmcs+0xc8/0xd0 [kvm_intel]
 ? __pfx_preempt_schedule_thunk+0x10/0x10
 arch_static_call_transform+0x57/0xa0
 ? vmx_switch_vmcs+0xc8/0xd0 [kvm_intel]
 __static_call_init+0x1aa/0x230
 ? __SCT__tp_func_kvm_mmu_split_huge_page+0x8/0x8
 ? __SCT__tp_func_kvm_mmu_split_huge_page+0x8/0x8
 static_call_module_notify+0x11f/0x150
 notifier_call_chain+0x60/0xe0
 blocking_notifier_call_chain_robust+0x64/0xc0
 load_module+0x1bc7/0x2000
 ? security_kernel_post_read_file+0x46/0x110
 ? kernel_read_file+0x2e5/0x2f0
 init_module_from_file+0xc8/0xe0
 idempotent_init_module+0xfe/0x2f0
 __x64_sys_finit_module+0x71/0xe0
 do_syscall_64+0xa6/0x690
 ? clear_bhb_loop+0x30/0x80
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f2054faa7b9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89
d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d>
RSP: 002b:00007ffc66a14c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 000055f431ad34a0 RCX: 00007f2054faa7b9
RDX: 0000000000000000 RSI: 00007f205375b44d RDI: 0000000000000021
RBP: 0000000000000000 R08: 0000000000000000 R09: 000055f431a72e60
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f205375b44d
R13: 0000000000020000 R14: 000055f431ad01b0 R15: 0000000000000000
 </TASK>
Modules linked in: kvm_intel(+) i915(+) drm_buddy drm_client_lib ttm
drm_display_helper drm_kms_helper cfg80211 cec nft_ct nf_conntrack nf_>
---[ end trace 0000000000000000 ]---
RIP: 0010:__text_poke+0x356/0x3d0
Code: 00 10 00 00 77 26 48 85 c0 0f 85 74 fd ff ff e9 2d ff ff ff 48 89 ea =
4c 89
f6 48 89 df e8 22 0a 33 01 85 c0 0f 84 90 fe ff ff <0f> 0b>
RSP: 0018:ffffa8bb010afa70 EFLAGS: 00010006
RAX: 0000000000000088 RBX: ffffffffc07402b9 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffffb793166b RDI: ffffffffc07402b9
RBP: 0000000000000004 R08: 0000000000000033 R09: 8000000000000063
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffb435e470
R13: 00004b8f944092b9 R14: ffffffffb793166b R15: 00000000000002bd
FS:  00007f205444c9c0(0000) GS:ffff9964b8518000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc66a0ed18 CR3: 0000000106551000 CR4: 0000000000350ef0
note: (udev-worker)[559] exited with irqs disabled


Best Regards
Steffen

>=20
> Lorenzo Stoakes fixed UAF caused by races between CPA and ptdump:
>=20
> https://lore.kernel.org/all/20260723-series-vmap-race-fix-v6-0-8cc77dcc00=
18@kernel.org
>=20
> and an issue with stale page tables in IOMMU:
>=20
> https://lore.kernel.org/all/20260721-fix-cpa-kernel-pagetables-v2-1-2b255=
deed710@kernel.org
>=20
> Mike Rapoport fixed a check of RW attribute in lookup_address_in_pgd_attr=
()
> used for the verification of RWX:
>=20
> https://lore.kernel.org/all/20260715144519.934289-1-rppt@kernel.org
>=20
> Some of the fixes got merged into x86 tree, some of them got merged into =
mm
> tree and some are still hanging in the air.
>=20
> Beside the fixes there was a supposed simplification of cpa_lock locking=
=20
> that looked like removal of an optimization for DEBUG_PAGEALLOC, but it
> turned out that it was not an optimization but rather a correctness
> guard because with DEBUG_PAGEALLOC the locks could be taken in an atomic
> context and couldn't use plain spin_lock()/spin_unlock().
>=20
> The changes here are collected from all these fixes into a sinlge coheren=
t
> set on top of tip/x86/mm:
> =20
> * update to cpa_lock handling with DEBUG_PAGEALLOC
> * fix for races between CPA and ptdumpi causing UAF
> * fix for stale page tables in IOMMU
> * update to the fix of the race between split and collapse of large
>   mappings
> * fix for effective RW computation in lookup_address_in_pgd_attr()
>=20
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (3):
>       x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
>       x86/mm/pat: acquire init_mm read lock on attribute change to avoid =
UAF
>       x86/mm/pat: allocate split page tables as kernel page tables
>=20
> Mike Rapoport (Microsoft) (2):
>       x86/mm/pat: introcude cpa_lock() and cpa_unlock()
>       x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_a=
ttr()
>=20
>  arch/x86/mm/pat/set_memory.c | 95 +++++++++++++++++++++++++++++++-------=
------
>  include/linux/mmap_lock.h    |  2 +
>  2 files changed, 70 insertions(+), 27 deletions(-)
> ---
> base-commit: a5a162fe1ae130e3d2ceefef3f43afe3773c1d56
> change-id: 20260727-cpa-fixes-d3c73c075672
>=20
> --
> Sincerely yours,
> Mike.

