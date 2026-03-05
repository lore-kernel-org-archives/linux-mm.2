Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13E2F3093A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFFF6B008A; Thu,  5 Mar 2026 06:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D266B008C; Thu,  5 Mar 2026 06:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C876B0092; Thu,  5 Mar 2026 06:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E69C46B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:18:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B6CA1A08DB
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:18:07 +0000 (UTC)
X-FDA: 84511760214.21.FBB2A82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD51118000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:18:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BLdgHSvv;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772709485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uNUbriXSbVgb/fak/RxVDrkl6xj++qJnk29AgNW/o0=;
	b=CZis0BPxeCHhCFZk/vsoHotPox3JJoUjbyibh/UB9EEwoYGa2Q2ALvzfw3yC8CAE2p8RY6
	jxwOr2eCmdFmaiIlGS9PMIpmhWzSjL+AmUTzfGQkLpVBn1xRDzA9L/z5szTUwGwP3YbtSg
	cZThAKZX35fW1Wp3kbN7AxCEfTivsrk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BLdgHSvv;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772709485; a=rsa-sha256;
	cv=none;
	b=HBuvaZDPWRLtuavXQPkHrCaOGnIXaK5ik0+mn9ecEeoDSzFRCJUfy62D9ue8P6mknMDD4c
	hkVxtvHPgW1i5n7zJaXOapRAtsxX54beeg2j+qYMIx7Zp4Pjblbmom0jaE6Nu1eZWXF0rE
	YS8G1MDaJjHDyr6Cis7stO3VSdLgTRs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 215CD61339;
	Thu,  5 Mar 2026 11:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51011C116C6;
	Thu,  5 Mar 2026 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772709484;
	bh=I/0ioJgwLkAZGL/7+xILcMhpWM+cWRqE4WHGVhKN/dc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BLdgHSvvuY+qaV0avAwvO1Y/Es8wsbs146ya1z+9XYQ63Z+MGEbgzl+P1JELjLYKe
	 3sh3dnCCYqA/1muX2WqZvpgLVEeg/C1DxxYgugNVhKmsrDTZC+GrbnQpf1L1xnRbcg
	 VIfynYQGkqSSpjk+sLrpNgjcSV/dOjVUoTkzBI/TTsRBRulcDCqrksL9WbFHmOwYIe
	 onUptG8i6z6czuAnZtCV2BV9XDBZbX3/612bGc1ZlXIZUB4EyY3Wp/AApHrvxku0U3
	 tXMaE5c9PomdGh3WgwZe7jociAhEAHAiMPc9MTqFBp1L5KnxtrZBRar2wzI4oYSolU
	 MOpR+PMmMfpvg==
Message-ID: <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org>
Date: Thu, 5 Mar 2026 12:17:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 Jens Axboe <axboe@kernel.dk>
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
 <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
 <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
 <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD51118000B
X-Rspamd-Server: rspam07
X-Stat-Signature: a95z5fuedcpghxu4r6cqitf93f187zmx
X-Rspam-User: 
X-HE-Tag: 1772709485-660560
X-HE-Meta: U2FsdGVkX18w7fMKv1/zTuRvW9ZpnpeVi1yubLFQ/8X4ZtLZPnL6H6T+XGDC6XM1k6GKQojsKUHS9EhD5CZY1mLBfxrn9Tli1q8JeXko024RcWDC1qAw6PfGIp/sz8grX7z/efhKZi8EmqLdpWoSoe2HpXXorQ23PCWluenrPN2ABelENScx7jQ7ZUybzZYoFQS9kQnD8apuMnVfqfXhOnRSDLeIT9vzlLVTvARvY98FPN4k2ZZo+5Y0GGwHd72U1CB8mrhiJN/mjJY+9yHr4TlaO8s17vmFudjppWRLm+PZpIuG/DP6t95KupcVrkRP34+EcpBstei+dirRxXUPuWZutndI0Una+cYOhjmv0+lJnV3P3T0xhxpD656T8DVgWYkhk9CnWmZutLEP+nDaSxmGTHb+Vqvcq4NxA6S0byVogM9S9UX6S10gYEu/cvLZzcL9OuS9epRrdC48VqAl3tFffb432O6p1OJtWZuX2ot0ZN0xUKboZ+do2C/DiOpa++3abn0bAS7mK2w/34yfEeaBbV1IEZ9LaSMbaXmhbuuwfGw4wGGYMVmlDAwPRu59U923N9rQVwOvODNItZ4nBr+6+nakxjpjP87LsBV+bI/WNzR0l0gi+YFttusDjQ82jJcii0ybAWI44dN1XOpKqVQP1O4XKDwsfkLA+vUH8bxssaDMFwiTxu9eERa7NBnHthvK5a91jBZzrQTA+q5Pfb0OMkE3qg6T3QilvwlLEVMxaXRzbNDGrDM2O2S2XJoCAhjM1S16YGdaDB/e7prM7orGjYY3ySldep0ZKwvJ246JOBm6tKbjVaZeoFV9NeNpkOH/9Wi8lRLtMno7wtdzk05Xa6HuXqm9C/21prWSrvAUhBfs71gydvwWuZH/KOu804jjRvuLxSJjbDawBwRtym49BwTyuamKMHWUpba586BAYeR98uUKVDrMlnMRqMpc1XX+Va2bnDglMkbQwlT
 2U8I4Dr0
 9Lse71AXDFg0UCObAgBXDr5OALWRnbhsmZqU0l06KCgYzOs94drpqlmERzI0f+E6K5PpNWv651i0wob8g5UrNI7sJ1/UbyNPtyKhwvLAEgE54RQBTOfgpsFHzXmBEOMpAOi+FsfRTgfdjP09+AXQbBAKGRcsTbvOmVucZLdhv+Sn70X/ceFvdUQc2Ea/SzIPyWZxXrvpa0nFtxEWRkRZfdrX0KLUSUPyEC17YlYNS3DniYvxgV+sRIpYRM6YTCMIxHixGJvUACZ849qRGZAgITSiMklv4Rbjk4TLbpee5v/TASTMNGanc+8Qg3jSsutnBAUMYXoPVwgnfkFIIdiQifOnFcRZV+dRtsETq2fEXXjlw9nI55lQVPPQ+gXgn5KAZ4uqGyp7ru5oTZgqUxtIOSt5iMwEhfnd/IR/QMF1VuB1yP45RZx0kW5Dt1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 09:11, Tytus Rogalewski wrote:
> Hi David,

Hi,

let me CC Jens.

@Jens, thread starts here:

https://marc.info/?l=linux-mm&m=176961245128225&w=2

For some reason, I cannot find that mail on lore, only my reply here:

https://lore.kernel.org/all/5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org/

> 
> This is strange but the issue stopped when i changed io_uring to threads.
> Would that make any sense ? 

On the screenshot I can see that "Async IO" is changed from Default
(io_uring) to "threads". I assume that changes QEMU's behavior to not
use io_uring for I/O.

> We did also few other smaller things but honestly issues stopped. 
> Was it fixed or maybe Async IO could cause it ? (The qcow2 image is on
> fuse mounting).
> 
> I am not certain but if that makes any sense, should i report this to
> someone working on io_uring or it should have nothing to do with that bug ?

Good question. It seems unrelated at first, but maybe it's related to
memory consumption with io_uring (below).

> 
> CleanShot 2026-03-05 at 09.08.15@2x.png
> 
> On all those kernels i seen no such bug for few weeks after changing
> async io.
> 

What was the latest kernel you are running?

> CleanShot 2026-03-05 at 09.09.03@2x.png
> 

Looking back at the original report, I can see that the system has extremely
little free memory. Maybe that gets eaten by io_uring somehow?

Do you still see that memory consumption when not using io_uring?


Let me copy the original information for Jens, maybe something could
give him a clue whether io_uring could be involved here.

"It happens on multiple servers (less on 6.18.6, more on 6.19-rc4+).
All servers are doing KVM with vfio GPU PCIE passthrough and it
happens when i am using HUGEPAGE 1GB + qemu Basically i am allocating
970GB into hugepages, leaving 37GB to kvm. In normal operation i have
about 20GB free space but when this issue occurs, all RAM is taken and
even when i have added 100GB swap, it was also consumed. It can work
for days or week without issue and 

I did not seen that issue when i had hugepages disabled (on normal 2KB
pages allocation in kvm). And i am using hugepages as it is impossible
to boot VM with >200GB ram. When that issue happens, process ps hangs
and only top shows something but machine needs to be rebooted due to many
zombiee processes.


Hardware:
Motherboard: ASRockRack GENOA2D24G-2L
CPU: 2x AMD EPYC 9654 96-Core Processor
System ram: 1024 GB
GPUs: 8x RTX5090 vfio passthrough

root@pve14:~# uname -a
Linux pve14 6.18.6-pbk #1 SMP PREEMPT_DYNAMIC Mon Jan 19 20:59:46 UTC 2026 x86_64 GNU/Linux

[171053.341288] BUG: unable to handle page fault for address: ff469ae640000000
[171053.341310] #PF: supervisor read access in kernel mode
[171053.341319] #PF: error_code(0x0000) - not-present page
[171053.341328] PGD 4602067 P4D 0
[171053.341337] Oops: Oops: 0000 [#1] SMP NOPTI
[171053.341348] CPU: 16 UID: 0 PID: 3250869 Comm: qm Not tainted 6.18.6-pbk #1 PREEMPT(voluntary)
[171053.341362] Hardware name:  TURIN2D24G-2L+/500W/TURIN2D24G-2L+/500W, BIOS 10.20 05/05/2025
[171053.341373] RIP: 0010:walk_pgd_range+0x6ff/0xbb0
[171053.341386] Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89 de 49 8d 9e 00 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39 f0 49 0f 43 dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41 c7 47 20
[171053.341406] RSP: 0018:ff59d95d70e6b748 EFLAGS: 00010287
[171053.341416] RAX: 00007a22401fffff RBX: 00007a2240200000 RCX: 0000000000000000
[171053.341425] RDX: 0000000000000000 RSI: 00007a227fffffff RDI: 800008dfc00002b7
[171053.341435] RBP: ff59d95d70e6b828 R08: 0000000000000080 R09: 0000000000000000
[171053.341444] R10: ffffffff8de588c0 R11: 0000000000000000 R12: ff469ae640000000
[171053.341454] R13: 00007a2280000000 R14: 00007a2240000000 R15: ff59d95d70e6b8a8
[171053.341464] FS:  00007d4e8ec94b80(0000) GS:ff4692876ae7e000(0000) knlGS:0000000000000000
[171053.341476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[171053.341485] CR2: ff469ae640000000 CR3: 0000008241eed006 CR4: 0000000000f71ef0
[171053.341495] PKRU: 55555554
[171053.341501] Call Trace:
[171053.341508]  <TASK>
[171053.341518]  __walk_page_range+0x8e/0x220
[171053.341529]  ? sysvec_apic_timer_interrupt+0x57/0xc0
[171053.341541]  walk_page_vma+0x92/0xe0
[171053.341551]  smap_gather_stats.part.0+0x8c/0xd0
[171053.341563]  show_smaps_rollup+0x258/0x420
[171053.341577]  seq_read_iter+0x137/0x4c0
[171053.341588]  seq_read+0xf5/0x140
[171053.341596]  ? __x64_sys_move_mount+0x11/0x40
[171053.341607]  vfs_read+0xbb/0x350
[171053.341617]  ? do_syscall_64+0xb8/0xd00
[171053.341627]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.341637]  ? strncpy_from_user+0x27/0x130
[171053.341649]  ksys_read+0x69/0xf0
[171053.341658]  __x64_sys_read+0x19/0x30
[171053.341666]  x64_sys_call+0x2180/0x25a0
[171053.341855]  do_syscall_64+0x80/0xd00
[171053.342029]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.342198]  ? __x64_sys_ioctl+0x83/0x100
[171053.342367]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.342532]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.342696]  ? x64_sys_call+0xac0/0x25a0
[171053.342857]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.343019]  ? do_syscall_64+0xb8/0xd00
[171053.343181]  ? seq_read+0xf5/0x140
[171053.343341]  ? __x64_sys_move_mount+0x11/0x40
[171053.343504]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.343662]  ? vfs_read+0xbb/0x350
[171053.343819]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.343973]  ? ksys_read+0x69/0xf0
[171053.344126]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.344280]  ? generic_file_llseek+0x21/0x40
[171053.344432]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.344582]  ? kernfs_fop_llseek+0x7b/0xd0
[171053.344730]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.344873]  ? ksys_lseek+0x4f/0xd0
[171053.345010]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.345144]  ? __x64_sys_lseek+0x18/0x30
[171053.345275]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.345407]  ? x64_sys_call+0x1abe/0x25a0
[171053.345535]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.345665]  ? do_syscall_64+0xb8/0xd00
[171053.345792]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.345919]  ? irqentry_exit+0x43/0x50
[171053.346044]  ? srso_alias_return_thunk+0x5/0xfbef5
[171053.346169]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[171053.346292] RIP: 0033:0x7d4e8ed61687
[171053.346417] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[171053.346687] RSP: 002b:00007ffdd7c76000 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
[171053.346828] RAX: ffffffffffffffda RBX: 00007d4e8ec94b80 RCX: 00007d4e8ed61687
[171053.346969] RDX: 0000000000002000 RSI: 000061ff84297ce0 RDI: 0000000000000006
[171053.347111] RBP: 0000000000002000 R08: 0000000000000000 R09: 0000000000000000
[171053.347253] R10: 0000000000000000 R11: 0000000000000202 R12: 000061ff84297ce0
[171053.347394] R13: 000061ff7d3d62a0 R14: 0000000000000006 R15: 000061ff842478c0
[171053.347542]  </TASK>
[171053.347684] Modules linked in: sctp ip6_udp_tunnel udp_tunnel nf_tables bridge stp llc softdog bonding sunrpc binfmt_misc nfnetlink_log amd_atl intel_rapl_msr intel_rapl_common nls_iso8859_1 amd64_edac edac_mce_amd kvm_amd snd_pcm snd_timer dax_hmem ipmi_ssif kvm cxl_acpi snd polyval_clmulni ghash_clmulni_intel cxl_port soundcore aesni_intel rapl cxl_core acpi_ipmi einj pcspkr ast ipmi_si spd5118 ipmi_devintf k10temp ccp ipmi_msghandler joydev input_leds mac_hid sch_fq_codel msr vhost_net vhost vhost_iotlb tap vfio_pci vfio_pci_core irqbypass vfio_iommu_type1 vfio iommufd efi_pstore nfnetlink dmi_sysfs autofs4 btrfs blake2b_generic xor raid6_pq mlx5_ib ib_uverbs macsec ib_core dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio nvme mlx5_core nvme_core cdc_ether nvme_keyring igb mlxfw psample usbnet nvme_auth i2c_algo_bit usbkbd mii hid_generic hkdf tls dca ahci i2c_piix4 libahci i2c_smbus usbmouse usbhid hid
[171053.349092] CR2: ff469ae640000000
[171053.349269] ---[ end trace 0000000000000000 ]---
[171054.248409] RIP: 0010:walk_pgd_range+0x6ff/0xbb0
[171054.248750] Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89 de 49 8d 9e 00 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39 f0 49 0f 43 dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41 c7 47 20
[171054.249177] RSP: 0018:ff59d95d70e6b748 EFLAGS: 00010287
[171054.249392] RAX: 00007a22401fffff RBX: 00007a2240200000 RCX: 0000000000000000
[171054.249820] RDX: 0000000000000000 RSI: 00007a227fffffff RDI: 800008dfc00002b7
[171054.250036] RBP: ff59d95d70e6b828 R08: 0000000000000080 R09: 0000000000000000
[171054.250253] R10: ffffffff8de588c0 R11: 0000000000000000 R12: ff469ae640000000
[171054.250471] R13: 00007a2280000000 R14: 00007a2240000000 R15: ff59d95d70e6b8a8
[171054.250691] FS:  00007d4e8ec94b80(0000) GS:ff4692876ae7e000(0000) knlGS:0000000000000000
[171054.250914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[171054.251137] CR2: ff469ae640000000 CR3: 0000008241eed006 CR4: 0000000000f71ef0
[171054.251375] PKRU: 55555554
[171054.251601] note: qm[3250869] exited with irqs disabled

-- 
Cheers,

David

