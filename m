Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A953CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38496B0095; Thu, 15 Oct 2026 02:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10FA6B0096; Thu, 15 Oct 2026 02:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27156B0098; Thu, 15 Oct 2026 02:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94FD86B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:47:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 106C2120903
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:47:15 +0000 (UTC)
X-FDA: 85323928830.14.0B70F98
Received: from mta1.migadu.com (out-229.mta1.migadu.com [95.215.58.229])
	by imf12.hostedemail.com (Postfix) with ESMTP id 582F240004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:47:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d7+//yCz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.229 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792046833;
	b=aXptV/nZomfU5GeQ5MNHF5+77WSJpAAtUQ1Ye+txmznifxe1VgjfB5w+Ahxeu6JftwpkJm
	v18o2RWdjIF3VujSNpTrcUT2sE7kf9z/mNKimTahQWLlajr2MypjXuQiyaYmsnLC6i7hR8
	CFsQveZoYLyZpqTIfHVdhImYmlxupow=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d7+//yCz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.229 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792046833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLoqpClj8Jf/SA4VgZbcpiWLWUgGyCUpt3NNcxXqIP0=;
	b=GA0xg4Ih8RvL0TYs1sAPzwjlNujyjTB2f87TdmdtIJmIgUMbOnUbUiCND+qwzkVAcrhni6
	B6001lSLC/xRWqJR9Q1VcAaPgs1Qo41Ojo4MEaGJFRZl4NC4AexiiTY1Gp2+Y9gfe7E7vT
	7ywpz8qanMDxn+Vcwrhfw093VnqZbw8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cRFYXOuxJbnONPtCDPz6tNF59JHRetwT44+akCuhaLQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792046822; v=1; x=1792651622;
 b=d7+//yCz3codMsbgwy6b/pAvIuIpIpamSbMHIt7FdW8azFH+tKc2UzLncPg3KlabqcR97oxg
 /d/wOT0Ra4yuVz53bjF9J+prrtYfgUJSV3h+SXAjnc23IJQkMVGCn11mwzWQQM8qpVLDjYWX2mo
 dxLsiVilZptEtbg1gYz3wax0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id ea0294c20a209d11;
	Thu, 15 Oct 2026 06:47:01 +0000
X-Mizu-Trace-ID: ea0294c20a209d11
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <wlrkqqvg.ritesh.list@gmail.com>
Date: Thu, 15 Oct 2026 14:46:45 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <872F3B5D-DF89-494F-969B-862047BA98AE@linux.dev>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
 <wlrkqqvg.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: z8n4d916gs95iikc5mywybwb4heybnw9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 582F240004
X-HE-Tag: 1792046831-540882
X-HE-Meta: U2FsdGVkX18LwbifxI0WkVKdNsHnk7RXAugcW/hal9F55JHaet/zQBBW7JsP03AG1a371rsRLBOQyu8Qxex/VeXHkYy9JS0U93SgnmY978QaP8GkFcEIsMZTTbIeLTvwJbJFhQR7agVYKF2Dchr1bHABnidqOSPQNnwG9/8JPhbV2YsmYdbvkEsNXD8cPAPJVAqJ8s2KtaeZhtv+xve1SJMFTwJuaEvNjewrvmfhHa+4WmwlIVbV80UfmwyASYKSMrpkHlAlPb866UORf3EpsNAGxJSNoTvHBdc4HMZRMlfNskcVhXLlUuj9y/54p04Ldtj78CiSaCRdFTcTizgjxgU5E0Sb8Hov3091lKTpHaNVUEcHCb6HGnIcpvC25iEFAkqzhnaiGCJZhLvYNj18nKxZNTKdMZ5/WmH4Q9tLX/3sU5EAY/zFJR0Ft23UJ83QBwFhw+z+I9dzKwMX+OnG3NDLwxMXlQKuFxSRHHtB94ZpCHjmjKVDIPYPEbma2zChBN3E9tdk489H/RvFNwLlCHOUxU68t35HfGUQB8ZjdwDVfxJjIdSqqsyvDsdhYRZWECy2gNjDlm4mOLAF88cK1hHkftzcaYNYMaKZUjpxTxP+tnFxNJ3Xs8qFjOfPK8w3dqauvou3htjb8Gu66R4WSM4g5kJTd6SUHLt7thURoLjf+UCwDLHKLNlAPJy6xFbU+iFgHI9bQxdvJXLkkNGT9tTY/Ut+KrnUCB6ZzPigl3lqV2lo+kRucxEl+Na26IhwHIHKxRH6pxKGG8Hc46sKZqThyUxgJEQGfaSrN6gYIuFH64Ji4lugFJ/TQx4UfPalBZE5t2DMrDRo5O8QhLnICSGsK5sZNE0nE6RXOE1l4abNAzg3ZQB9ZejppEWTyUvkpaQ7vJJijjJ5jqNAJB4SnZYbW4YY0M9qr6W/AiAP/Jm2QYG9oHHXLXuBQaJT46jEr3Syws3BK8i+lWp0S+U
 ba9gTyMZ
 4jCIanBYz1J1MiSDGpimSE3RqPgx0oi77UXiawZhHi5ARFgTzf8v8XB8IeAbRvxuWDeQGuC0F14QdYcp6+pCRk3Gou2eBCdwR9s4z8vjFYcLJ8WGqLGDLBR8OGB3fnLHGfwjUjw6botrDwT7G8eM+IlMO5KAG3oJ4aze/51L0NrmZpuqd2qUPqv0R8IeE12Nrmr7/7wINB0JnQf1uBJijhfVdndii7ioEW+db9g6UgoU7YfK+BRCf5LcVp6XMTSUOhQaX8Zgu9AcivR6giobGk+Oe0BbRjK/ZqGMrDi5ztQqOg3/Fi8EZbg/rYVFtrF2kTyPCK8wfOn/nVIhrKX6fAG9CM+pZGEL8H9cFGXNwgRY8koaw1P9E52YYedJEyEGOgpz0QKWGxlc6/xH9Hj4F9sZevLRcEqr0/FEoP87u1eNzjsKaho5M06sfn/Almi7qJ8VS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 14, 2026, at 22:49, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
> Muchun Song <songmuchun@bytedance.com> writes:
>=20
>> This v4 is based on mm-new commit d5207c6d152c, which contains v6 of
>> "mm: Switch device DAX to section-based vmemmap optimization" [1].
>>=20
>=20
> Hi Muchun,
>=20
> I was checking this patch series and seems like I am hitting an issue =
on
> mm-new, which most likely is due to this patch series.
> (Note that a similar issue was reported by Pavithra on PowerPC)
>=20
> Let me first give the call stack:
>=20
> [   79.930815] page: refcount:0 mapcount:1 mapping:0000000000000000 =
index:0x0 pfn:0x140000
> [   79.930833] flags: 0x0(node=3D0|zone=3D0|lastcpupid=3D0x0)
> [   79.930838] raw: 0000000000000000 0000000000000000 0000000000000000 =
0000000000000000
> [   79.930840] raw: 0000000000000000 0000000000000000 0000000000000000 =
0000000000000000
> [   79.930841] page dumped because: =
VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
> [   79.931043] ------------[ cut here ]------------
> [   79.931051] kernel BUG at mm/page_alloc.c:373!
> [   79.931109] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
> [   79.940576] CPU: 2 UID: 0 PID: 743 Comm: ndctl Tainted: G           =
      N  7.3.0-rc5-01065-g45f4c1453cbe #23 PREEMPT(full)
> [   79.942647] Tainted: [N]=3DTEST
> [   79.943190] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   79.945080] RIP: =
0010:__set_pfnblock_flags_mask.constprop.0+0xef/0x110
> [   79.946231] Code: 48 8b 07 48 89 d1 48 f7 d1 48 89 c2 48 21 ca 48 =
09 f2 f0 48 0f b1 17 75 f0 c3 cc cc cc cc 48 c7 c6 b0 9b 5a 83 e8 91 be =
fa ff <0f> 0b ba 00 10 00 00 e9 7a ff ff ff 48 c7 c6 a8 b5 56 83 e8 79 =
be
> [   79.949296] RSP: 0018:ffffc90011ebf7b0 EFLAGS: 00010246
> [   79.950179] RAX: 000000000000004a RBX: 0000000000140000 RCX: =
0000000000000000
> [   79.951366] RDX: 0000000000000000 RSI: 0000000000000001 RDI: =
ffffffffffffffff
> [   79.952562] RBP: 0000000000180000 R08: 0000000000000001 R09: =
0000000000000000
> [   79.953759] R10: 0000000000000118 R11: 0000000000008000 R12: =
0000000000000001
> [   79.954948] R13: 0000000000000000 R14: 0000000000180000 R15: =
0000000000190000
> [   79.956151] FS:  00007ffff7e36d40(0000) GS:ffff8880f7f22000(0000) =
knlGS:0000000000000000
> [   79.957490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   79.958464] CR2: 000055555572ce90 CR3: 0000000031130003 CR4: =
0000000000172ef0
> [   79.959657] Call Trace:
> [   79.960096]  <TASK>
> [   79.960487]  pageblock_migratetype_init_range.constprop.0+0x50/0x90
> [   79.961561]  memmap_init_zone_device+0x2fb/0x380
> [   79.962392]  pagemap_range+0x272/0x590
> [   79.963069]  memremap_pages+0x125/0x210
> [   79.963726]  ? lockdep_hardirqs_on+0x7d/0x100
> [   79.964488]  devm_memremap_pages+0x21/0x70
> [   79.965191]  dev_dax_probe+0x1db/0x300
> [   79.965870]  dax_bus_probe+0x6f/0xa0
> [   79.966495]  call_driver_probe+0x24/0xf0
> [   79.967190]  really_probe+0xb6/0x310
> [   79.967810]  ? __pfx___device_attach_driver+0x10/0x10
> [   79.968667]  __driver_probe_device+0x87/0x190
> [   79.969415]  ? __pfx___device_attach_driver+0x10/0x10
> [   79.970270]  driver_probe_device+0x1f/0x90
> [   79.970976]  __device_attach_driver+0x89/0x130
> [   79.971734]  bus_for_each_drv+0x86/0xe0
> [   79.972412]  __device_attach+0xb6/0x1d0
> [   79.973078]  device_initial_probe+0x40/0x60
> [   79.973791]  bus_probe_device+0x3d/0xa0
> [   79.974453]  device_add+0x4f0/0x6c0
> [   79.975068]  __devm_create_dev_dax+0x18b/0x3f0
> [   79.975830]  devm_create_dev_dax+0x21/0x40
> [   79.976530]  __dax_pmem_probe+0x1c3/0x200
> [   79.977244]  dax_pmem_probe+0xe/0x20
> [   79.977867]  nvdimm_bus_probe+0x89/0x250
> [   79.978566]  call_driver_probe+0x24/0xf0
> [   79.979242]  really_probe+0xb6/0x310
> [   79.979868]  __driver_probe_device+0x87/0x190
> [   79.980618]  device_driver_attach+0x47/0xb0
> [   79.981336]  bind_store+0x76/0xc0
> [   79.981922]  kernfs_fop_write_iter+0x152/0x200
> [   79.982715]  vfs_write+0x276/0x520
> [   79.983323]  ksys_write+0x6b/0xe0
> [   79.983900]  do_syscall_64+0xa6/0x470
> [   79.984543]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>=20
>=20
> also -=20
>=20
> [    4.426995] BUG: kernel NULL pointer dereference, address: =
0000000000000090
> [    4.428266] #PF: supervisor read access in kernel mode
> [    4.428266] #PF: error_code(0x0000) - not-present page
> [    4.428266] PGD 0 P4D 0
> [    4.428266] Oops: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
> [    4.428266] CPU: 6 UID: 0 PID: 1 Comm: swapper/0 Not tainted =
7.3.0-rc5-01065-g45f4c1453c
> [    4.428266] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS rel-1.16.3-0-ga6ed6b701f04
> [    4.428266] RIP: =
0010:__set_pfnblock_flags_mask.constprop.0+0x3d/0x110
> [    4.428266] Code: 84 e3 00 00 00 48 8b 17 48 89 d1 48 c1 ea 37 83 =
e2 07 48 c1 e9 3a 48 8d 14 52 40
> [    4.428266] RSP: 0000:ffffc9000001b770 EFLAGS: 00010246
> [    4.428266] RAX: 0000000000140000 RBX: 0000000000140000 RCX: =
0000000000000020
> [    4.428266] RDX: 0000000000000000 RSI: 0000000000000001 RDI: =
ffffea0005000000
> [    4.428266] RBP: 0000000000180000 R08: ffff8880093e1600 R09: =
0000000000000040
> [    4.428266] R10: 0000000000000001 R11: 0000000000000000 R12: =
0000000000000001
> [    4.428266] R13: 0000000000000000 R14: 0000000000180000 R15: =
0000000000190000
> [    4.428266] FS:  0000000000000000(0000) GS:ffff8880f8722000(0000) =
knlGS:0000000000000000
> [    4.428266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    4.428266] CR2: 0000000000000090 CR3: 0000000003aac001 CR4: =
0000000000172ef0
> [    4.428266] Call Trace:
> [    4.428266]  <TASK>
> [    4.428266]  pageblock_migratetype_init_range.constprop.0+0x50/0x90
> [    4.428266]  memmap_init_zone_device+0x2fb/0x380
> [    4.428266]  pagemap_range+0x272/0x590
> [    4.428266]  memremap_pages+0x125/0x210
> [    4.428266]  ? lockdep_hardirqs_on+0x7d/0x100
> [    4.428266]  devm_memremap_pages+0x21/0x70
> [    4.428266]  dev_dax_probe+0x1db/0x300
> [    4.428266]  dax_bus_probe+0x6f/0xa0
> [    4.428266]  call_driver_probe+0x24/0xf0
> [    4.428266]  really_probe+0xb6/0x310
> [    4.428266]  ? __pfx___device_attach_driver+0x10/0x10
> [    4.428266]  __driver_probe_device+0x87/0x190
> [    4.428266]  ? __pfx___device_attach_driver+0x10/0x10
> [    4.428266]  driver_probe_device+0x1f/0x90
> [    4.428266]  __device_attach_driver+0x89/0x130
> [    4.428266]  bus_for_each_drv+0x86/0xe0
> [    4.428266]  __device_attach+0xb6/0x1d0
> [    4.428266]  device_initial_probe+0x40/0x60
> [    4.428266]  bus_probe_device+0x3d/0xa0
> [    4.428266]  device_add+0x4f0/0x6c0
> [    4.428266]  __devm_create_dev_dax+0x18b/0x3f0
> [    4.428266]  devm_create_dev_dax+0x21/0x40
> [    4.428266]  __dax_pmem_probe+0x1c3/0x200
> [    4.428266]  dax_pmem_probe+0xe/0x20
> [    4.428266]  nvdimm_bus_probe+0x89/0x250
> [    4.428266]  call_driver_probe+0x24/0xf0
> [    4.428266]  really_probe+0xb6/0x310
> [    4.428266]  ? __pfx___driver_attach+0x10/0x10
> [    4.428266]  __driver_probe_device+0x87/0x190
> [    4.428266]  ? __pfx___driver_attach+0x10/0x10
> [    4.428266]  driver_probe_device+0x1f/0x90
> [    4.428266]  __driver_attach+0xd7/0x200
> [    4.428266]  bus_for_each_dev+0x79/0xc0
> [    4.428266]  bus_add_driver+0x127/0x250
> [    4.428266]  driver_register+0x59/0x100
> [    4.428266]  ? __pfx_dax_pmem_init+0x10/0x10
> [    4.428266]  do_one_initcall+0x59/0x3a0
> [    4.428266]  do_initcalls+0xdd/0x1b0
> [    4.428266]  kernel_init_freeable+0x16f/0x2b0
> [    4.428266]  ? __pfx_kernel_init+0x10/0x10
> [    4.428266]  kernel_init+0x1f/0x1d0
> [    4.428266]  ret_from_fork+0x244/0x280
> [    4.428266]  ? __pfx_kernel_init+0x10/0x10
> [    4.428266]  ret_from_fork_asm+0x1a/0x30
> [    4.428266]  </TASK>
>=20
>=20
> - I am hitting this issue on x86 kvm itself (and also on PowerPC)
> - I am able to hit the issue with the following extra qemu params:
>    -m 2G,slots=3D4,maxmem=3D16G
>    -object =
memory-backend-file,id=3Dmem1,mem-path=3D/tmp/nvdimm.img,size=3D2560M,shar=
e=3Don -device =
nvdimm,id=3Dnvdimm0,memdev=3Dmem1,label-size=3D256M,addr=3D0x100000000
>=20
>    # then once the system comes up
>    ndctl disable-region region0
>    ndctl init-labels all
>    ndctl enable-region region0
>=20
>    ndctl create-namespace -r region0 -t pmem -m raw -s 256M
>    ndctl create-namespace -r region0 -t pmem -m devdax -M mem -a 1G -s =
2G=20
>=20
> I am still debugging this issue - but from the logs it looks like that
> some struct page was never initialized which caused the VM_BUG_ON().
>=20
> Can you take a look at this once?

Hi Ritesh,

Thanks for reporting this and for providing the detailed reproducer.

I reproduced the failure on x86 with the same Device DAX namespace
layout.

After looking into it further, I think it is a pre-existing issue, so
the underlying bug was not introduced by this series.

In this case, the namespace-backed pgmap covers PFNs
0x110000..0x180000, while the actual Device DAX data range starts at PFN
0x140000 after applying dataoff.  The Device DAX alignment is 1 GiB, so
pgmap->vmemmap_shift is 18.

An order-18 compound page must be naturally aligned to 1 GiB,
independently of whether vmemmap optimization is enabled.  However,
memmap_init_zone_device() currently applies this compound-page geometry
to the entire pgmap range, including namespace metadata and alignment
padding.  It therefore attempts to initialize compound pages starting
at PFN 0x110000, which is not naturally aligned to 1 GiB.

The old Device DAX-specific vmemmap population path also used the pgmap
start as its reference point.  Consequently, the population and
initialization paths used the same incorrect range-relative layout, and
the device could complete probing successfully.

The common path introduced by this series identifies retained vmemmap
pages from the naturally aligned absolute PFN instead.  It therefore
allocates a private vmemmap page for PFN 0x140000, while
memmap_init_zone_device() does not initialize that page.  The subsequent
pageblock initialization then detects the invalid struct page and
triggers the reported failure.

I also tested the kernel immediately before this series.  The namespace
was created successfully and exposed the full 1 GiB /dev/dax0.1 range:

  start: 0x140000000
  end:   0x17fffffff
  size:  1 GiB
  align: 1 GiB

However, mapping the device as an unprivileged user and performing the
first write caused a kernel panic in the page-fault path:

  page does not match folio
  page dumped because: VM_BUG_ON_PAGE(page->compound_info & 1)

  const_folio_flags()
    vmf_insert_folio_pud()
      dev_dax_huge_fault()
        handle_mm_fault()
          do_user_addr_fault()

So the previous Device DAX-specific path only hid the problem during
initialization.  The invalid compound-page layout was still observable
and directly triggerable from userspace through mmap.

The underlying issue dates back to:

  14606001efb4 ("device-dax: compound devmap support")

That commit started setting pgmap->vmemmap_shift from dev_dax->align and
initializing the pgmap as compound pages, without accounting for the
fact that a static pmem pgmap may begin before the naturally aligned
Device DAX data range.

Commit:

  aed877c2b425 ("device/dax: properly refcount device dax pages when =
mapping")

later changed the PMD/PUD fault path to insert the folio derived from
page_folio(), making an invalid compound head directly affect the
mapping path.

The fix is to exclude the namespace metadata and alignment padding from
the pgmap when the memmap is stored in system RAM and compound Device
DAX pages are used.  The pgmap then starts at the same naturally aligned
address as the user-visible Device DAX data range.

The altmap path is left unchanged because memmap_init_zone_device()
already advances past the entire altmap reservation using
vmem_altmap_offset().  The 4 KiB-aligned static namespace path is also
left unchanged.

I also added an invariant warning in memmap_init_zone_device() so that
any future caller passing a non-naturally-aligned compound range is
reported directly.

But I'm not sure if the fix is reasonable. Let me think it about for a
while.

Thanks,
Muchun

---
  drivers/dax/pmem.c | 7 +++++++
  mm/mm_init.c       | 2 ++
  2 files changed, 9 insertions(+)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..938de88fa185 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct device =
*dev)
      /* adjust the dax_region range to the start of data */
      range =3D pgmap.range;
      range.start +=3D offset;
+     /*
+      * When the memmap is stored in RAM, exclude metadata and =
alignment
+      * padding from compound page initialization.  Otherwise, the =
pgmap
+      * may start before the naturally aligned Device DAX data range.
+      */
+     if (!pgmap_altmap(&pgmap) && le32_to_cpu(pfn_sb->align) > =
PAGE_SIZE)
+             pgmap.range.start =3D range.start;
      dax_region =3D alloc_dax_region(dev, region_id, &range,
                      nd_region->target_node, =
le32_to_cpu(pfn_sb->align),
                      IORESOURCE_DAX_STATIC);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4c17a892924d..2bbd56cccc5e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone =
*zone,
      if (!nr_pages)
              return;

+     VM_WARN_ON_ONCE(!IS_ALIGNED(start_pfn | nr_pages, =
pfns_per_compound));
+
      /*
        * Seed the reusable head-page template from the first real =
struct
        * page. The normal page-init and refcount helpers must operate =
on


Muchun,
Thanks.



>=20
> Thanks!
> -ritesh
>=20
>=20


