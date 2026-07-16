Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14400C44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E9D6B0088; Wed, 15 Jul 2026 22:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2FAF6B008A; Wed, 15 Jul 2026 22:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A455F6B0093; Wed, 15 Jul 2026 22:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE396B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:27:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C35531403A0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:27:18 +0000 (UTC)
X-FDA: 84993052956.24.F0184AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2737F40009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:27:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNB2qd3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784168837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTnja3mZ0ImeY04f+91Rp6cBf2j7fTHFXCcGP0nDhGE=;
	b=YgtLQII3am22fcUHEGwnFPw/WrdCUpR09m/C5ZqNQjcbtnqB+XdSXQb9aAP6SN1T4A/+4F
	U/kROX4Cxpj/rENDHBmbq7JXDFPtiqn5JtNoHyAv2dcx0pY+kuM4lKdXxT53AR9gqj/f/1
	Z93Cb+Xrrw/G4zO4t+GqM442p0XvyL8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNB2qd3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784168837;
	b=ys98rUw2b1ocGpg+25kqNSfoIyfI/yiSWdiYcDl7WQlKVaJEWU3r+IeZU2BpZZ8iQR1eVa
	3Si3T+i204IKbXfk6MmE7rOwNnU8UuKwqXh6M/FTpsYYPzGPO1ggk+p0OwzsAjrQ3rAQ0K
	qGeIzy7cbTV9Hq8I+RvV/ezytjd/zPQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9358B6001A;
	Thu, 16 Jul 2026 02:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616BD1F000E9;
	Thu, 16 Jul 2026 02:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784168836;
	bh=CTnja3mZ0ImeY04f+91Rp6cBf2j7fTHFXCcGP0nDhGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eNB2qd3k0O+UnjA+L5SDJP/XfpYlTd9PcJ1C4v/f1IxZN4GOY04c87xbqTxENVLto
	 Li1PFK8sqO4445lHFacDWpNgl4PrSd1+85sl0DrtkFWut49xySigYsrt7/rsv3HUYQ
	 9YJl9E/qnVKzyQmAGYKD+EWgaFV+CjhbZHf9ufipdhzbCKboPaP3K08hOUFsVGfXNi
	 aNIAQ2ogP3RWNM2OluMdgmOphYw33DwEI/PBTcHZo+Aa9+RG5kvNxnbAyzRgTf8REG
	 +2B+1VeA9NuBKxaa/o2lDjuwaQ3MpDOHF0EuFdxhzOicaW6lFGEzM9DbA2XrL3Fepb
	 rc4ygBgQEoPUw==
Message-ID: <7bdfdc92-7e75-4dc6-9549-e75b46218b93@kernel.org>
Date: Thu, 16 Jul 2026 11:27:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [harry:kmalloc-no-objext-rfc-v1r3] [mm/slab] d6967566f4:
 RIP:mark_obj_codetag_empty
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Danielle Costantino <dcostantino@meta.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
References: <202607142131.f70bbad3-lkp@intel.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <202607142131.f70bbad3-lkp@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wHkUIB4ELmmhRpV9tINOU1eM"
X-Rspamd-Queue-Id: 2737F40009
X-Stat-Signature: oxizqptou8ehxnj7ddr4yc847dtsdbmg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784168836-684645
X-HE-Meta: U2FsdGVkX1/7foBE2kxBOJYBiDZbEVrpqsCRbnMkqiO60MlAvppiUyw8qrqEm5JpRyURfmbE7bn9Ckdx1WiASWfKH78xCnWWv2KIpYLKsbHdU3MBvKnID81TrNaFRk8CWzENEECCc09oOeOwyTY/oEcwO1NvLC1q4hfdHlRB+iWzBISqX8byxPPUL9FLykjGTY5cg7LlokEBqoT7Vn7FF65T0xQu9q6X+NuBnjuUbLUiJGCPI+2qm8PzadLkWL9YI9nI4EYYdwseuk6AOKDUZGH4kdOjtKqQK764gHf+XftZrdNiIromk8P+nOIiHejObHl+VF6nNHvmAl1Z2YURAWt12/Sbzemxp0/vnEbaY6WYwbCGGu1H3uTERgXjXKi5+/XnDAqSQ4pVOC5dqEOZqtL1yB5ayshXxKSJzPlOlrHO5oAYVbaSBC6Ee4JTzHWMpGc2ZqrcFMw8nkL5/tDmqH3wFDbZSvH92CVMA/9OXOoyufyeZu8bAQdRLFT0a8FCKmuUD69nw392vl09ohng8gnAW8KlORO68g6+0mqEHb3Ub3T1hOFdzAnIhBQjNbArwNu7v6wpjLCfU68/rqK6pR0+C1Cjxssc+rTHeBE+CUEXtVkP67i04hsnspnlwuc7KOCZRYKn1bpbBvOqlwnydYtJ4+Hy26BASRWokPGmpEikxGPjYMDMAjv+U/ptApg3E0H4khaMRFiGqj0udsT+YZF4aFf+qZhO6icmDYI/6IzDSqt2pGjT4PSdaJMQx+0H+C783B/HMNxV6rcrFOpI2uo7c1uG1G5R+hDimMu481DJHOAT/ch1fMv2SNVvX2kU+xm4TsoPbq5HcdLKSWgVMZVLeQcUlmUUx3FmGG0sBPi0asQLlqAAknJsHasWet7Bj0guXWpG/l0DfQ1SE3XCFNUaMs/si7gSyzBBPjWNv+I3JDuaZYOnKL5LzS07cMEd3NxHuOJwW4nqUb1baNt
 MS1c4u4y
 9KGVMv5pOx/ubAOU90iYhbjG6LOss2+4GThsv4/YP/bCvylapSuYurpXocJWPnBMMptgjHGHPgpsjqhhWLE5P1+12g87FdYDbELyi2ME91K9T/CorXPA/uLkG/GJih0j3YFx4c1xEquSM/2JD0ZSRE8GAFWrdH/ip2oiP2SvIEO3JRrkr0w8FLGMINRcq8k8RZH4IYkgCchfH+KtwwUSqGjvKLuhkE3vRMcCz5iNnpSF/zszAv6drdKIpxSXYnxYPWYzrAMeBFszWAHQ7hmisP3MMXk+duuNmta/Xj2u9p07iJ5sUHVb/R2Hli5DBESFdWMbCcDjheP86ZHMAnV0JGMIXeQcOAG06S0SpiDYeEWCG6gDlgdieHB5gyfc+bWmZjIFvzmbwZArd/anRaxAHgG9lv8FbLeObseF0vSnMHa1LWFAmTBbaScoHAWJpGx8W7FDNeaOpouUiToZHc4DLzgT0bEe64n5wS5X2SCDtvINtBeBOxJSGo7m2PBfj/0k7iTsCyKMeZ0QS0ZswNx1V34d8HTc+l2c9XDe0A7y/oVlU06hUlIOjnqxXuwTYsTN97BSWFNmY9XWVNuDRMIZLl6D+4RjTbe+i5cnP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wHkUIB4ELmmhRpV9tINOU1eM
Content-Type: multipart/mixed; boundary="------------jUyNbDSOZ26IDnD3L0wPmVkN";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Danielle Costantino <dcostantino@meta.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Message-ID: <7bdfdc92-7e75-4dc6-9549-e75b46218b93@kernel.org>
Subject: Re: [harry:kmalloc-no-objext-rfc-v1r3] [mm/slab] d6967566f4:
 RIP:mark_obj_codetag_empty
References: <202607142131.f70bbad3-lkp@intel.com>
In-Reply-To: <202607142131.f70bbad3-lkp@intel.com>

--------------jUyNbDSOZ26IDnD3L0wPmVkN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Thanks for reporting!

Indeed I've seen this false warning and it was fixed in v2.

On 7/14/26 10:48 PM, kernel test robot wrote:
> Hello,
>=20
> kernel test robot noticed "RIP:mark_obj_codetag_empty" on:
>=20
> commit: d6967566f41090d5e58861f3b5d3d9b1293ccb0f ("mm/slab: prevent unb=
ounded recursion in free path with new kmalloc type")
> https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git kmalloc-no=
-objext-rfc-v1r3
>=20
> in testcase: locktorture
> version:=20
> with following parameters:
>=20
> 	runtime: 300s
> 	test: cpuhotplug
>=20
>=20
>=20
> config: x86_64-randconfig-073-20260706
> compiler: clang-22
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m=
 32G
>=20
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>=20
>=20
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202607142131.f70bbad3-lkp@inte=
l.com
>=20
>=20
>=20
> [    7.170805][    T1] ------------[ cut here ]------------
> [    7.173964][    T1] ext->ref.ct
> [    7.173973][    T1] WARNING: mm/slub.c:2085 at mark_obj_codetag_empt=
y+0x12d/0x180, CPU#1: swapper/0/1
> [    7.180958][    T1] Modules linked in:
> [    7.183435][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Tainted: G =
               T   7.2.0-rc1+ #1 PREEMPTLAZY
> [    7.198751][    T1] Tainted: [T]=3DRANDSTRUCT
> [    7.200585][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    7.204811][    T1] RIP: 0010:mark_obj_codetag_empty (slub.c:2079 (d=
iscriminator 256))
> [    7.206959][    T1] Code: 31 c0 31 c9 31 ff 31 d2 31 f6 e9 6e e6 02 =
00 5b 41 5c 41 5d 41 5e 41 5f 5d 31 c0 31 c9 31 ff 31 d2 31 f6 c3 48 83 f=
8 01 74 cc <0f> 0b eb b4 89 de 41 0f b6 d7 48 c7 c7 d0 01 0f 87 e8 fd 56 =
87 01
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:	31 c0                	xor    %eax,%eax
>    2:	31 c9                	xor    %ecx,%ecx
>    4:	31 ff                	xor    %edi,%edi
>    6:	31 d2                	xor    %edx,%edx
>    8:	31 f6                	xor    %esi,%esi
>    a:	e9 6e e6 02 00       	jmp    0x2e67d
>    f:	5b                   	pop    %rbx
>   10:	41 5c                	pop    %r12
>   12:	41 5d                	pop    %r13
>   14:	41 5e                	pop    %r14
>   16:	41 5f                	pop    %r15
>   18:	5d                   	pop    %rbp
>   19:	31 c0                	xor    %eax,%eax
>   1b:	31 c9                	xor    %ecx,%ecx
>   1d:	31 ff                	xor    %edi,%edi
>   1f:	31 d2                	xor    %edx,%edx
>   21:	31 f6                	xor    %esi,%esi
>   23:	c3                   	ret
>   24:	48 83 f8 01          	cmp    $0x1,%rax
>   28:	74 cc                	je     0xfffffffffffffff6
>   2a:*	0f 0b                	ud2		<-- trapping instruction
>   2c:	eb b4                	jmp    0xffffffffffffffe2
>   2e:	89 de                	mov    %ebx,%esi
>   30:	41 0f b6 d7          	movzbl %r15b,%edx
>   34:	48 c7 c7 d0 01 0f 87 	mov    $0xffffffff870f01d0,%rdi
>   3b:	e8 fd 56 87 01       	call   0x187573d
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:	0f 0b                	ud2
>    2:	eb b4                	jmp    0xffffffffffffffb8
>    4:	89 de                	mov    %ebx,%esi
>    6:	41 0f b6 d7          	movzbl %r15b,%edx
>    a:	48 c7 c7 d0 01 0f 87 	mov    $0xffffffff870f01d0,%rdi
>   11:	e8 fd 56 87 01       	call   0x1875713
> [    7.216881][    T1] RSP: 0000:ffffc9000001f700 EFLAGS: 00010282
> [    7.218936][    T1] RAX: ffffffff87f3cc38 RBX: 0000000000000800 RCX:=
 000000000000000a
> [    7.226952][    T1] RDX: ffffea0004151200 RSI: ffffea00041524c0 RDI:=
 ffff888105448800
> [    7.229430][    T1] RBP: 0000000000000000 R08: 0000000000000000 R09:=
 0000000000000000
> [    7.232919][    T1] R10: 0000000000000000 R11: 0000000000000000 R12:=
 ffff888105448410
> [    7.236484][    T1] R13: ffffea0004151200 R14: 000000000000000a R15:=
 0000000000000a01
> [    7.238648][    T1] FS:  0000000000000000(0000) GS:ffff888795e7f000(=
0000) knlGS:0000000000000000
> [    7.241013][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> [    7.242973][    T1] CR2: 0000000000000000 CR3: 0000000006b26000 CR4:=
 00000000000406f0
> [    7.245167][    T1] Call Trace:
> [    7.246092][    T1]  <TASK>
> [    7.246905][    T1]  __free_slab (slub.c:2244)
> [    7.248085][    T1]  ___cache_free (slub.c:6436 (discriminator 1))
> [    7.249275][    T1]  qlist_free_all (kasan/quarantine.c:163 (discrim=
inator 1) kasan/quarantine.c:179 (discriminator 1))
> [    7.250498][    T1]  kasan_quarantine_remove_cache (kasan/quarantine=
=2Ec:364)
> [    7.252073][    T1]  kmem_cache_shrink (slab_common.c:604)
> [    7.253337][    T1]  acpi_os_purge_cache (acpi/osl.c:1622)
> [    7.254628][    T1]  acpi_purge_cached_objects (acpi/acpica/utxface.=
c:237 (discriminator 512))
> [    7.256086][    T1]  acpi_initialize_objects (acpi/acpica/utxfinit.c=
:250)
> [    7.257334][    T1]  acpi_bus_init (acpi/bus.c:1503)
> [    7.258535][    T1]  ? acpi_init (bus.c:?)
> [    7.259714][    T1]  ? __kasan_kmalloc (kasan/common.c:398 kasan/com=
mon.c:415)
> [    7.261025][    T1]  ? __kmalloc_cache_noprof (linux/kasan.h:263 slu=
b.c:5474)
> [    7.262488][    T1]  ? kobject_init (linux/instrumented.h:97 linux/a=
tomic/atomic-instrumented.h:67 linux/refcount.h:134 linux/kref.h:31 kobje=
ct.c:201 kobject.c:352)
> [    7.263709][    T1]  ? kobject_create_and_add (kobject.c:798)
> [    7.265173][    T1]  acpi_init (acpi/bus.c:1592)
> [    7.266287][    T1]  do_one_initcall (main.c:1347)
> [    7.267461][    T1]  ? acpi_arch_init+0x40/0x40
> [    7.268701][    T1]  ? perf_trace_initcall_finish (main.c:?)
> [    7.270254][    T1]  ? do_raw_spin_lock (linux/instrumented.h:55 lin=
ux/atomic/atomic-instrumented.h:1301 asm-generic/qspinlock.h:111 locking/=
spinlock_debug.c:116)
> [    7.271619][    T1]  ? find_held_lock (locking/lockdep.c:5350)
> [    7.272891][    T1]  ? stack_depot_save_flags (stackdepot.c:728 (dis=
criminator 1))
> [    7.274356][    T1]  ? _raw_spin_unlock_irqrestore (linux/spinlock_a=
pi_smp.h:178 (discriminator 2))
> [    7.275877][    T1]  ? stack_depot_save_flags (stackdepot.c:728 (dis=
criminator 1))
> [    7.277336][    T1]  ? do_initcalls (linux/slab.h:985 linux/slab.h:1=
302 main.c:1418)
> [    7.278561][    T1]  ? kasan_save_track (kasan/common.c:58 kasan/com=
mon.c:78)
> [    7.280348][    T1]  ? kasan_save_track (kasan/common.c:57 kasan/com=
mon.c:78)
> [    7.288349][    T1]  ? __kasan_kmalloc (kasan/common.c:398 kasan/com=
mon.c:415)
> [    7.290315][    T1]  ? __kmalloc_noprof (linux/kasan.h:263 slub.c:53=
17 slub.c:5342)
> [    7.292347][    T1]  ? do_initcalls (linux/slab.h:985 linux/slab.h:1=
302 main.c:1418)
> [    7.294211][    T1]  ? kernel_init_freeable (main.c:1658)
> [    7.296477][    T1]  ? kernel_init (main.c:1548)
> [    7.298274][    T1]  ? ret_from_fork (x86/kernel/process.c:158)
> [    7.300206][    T1]  ? ret_from_fork_asm (x86/entry/entry_64.S:245)
> [    7.302217][    T1]  ? __lock_acquire (locking/lockdep.c:4674)
> [    7.307839][    T1]  ? _raw_spin_unlock_irqrestore (linux/spinlock_a=
pi_smp.h:178 (discriminator 2))
> [    7.310305][    T1]  ? parameq (linux/fortify-string.h:218 params.c:=
99)
> [    7.312115][    T1]  ? parse_args (params.c:153)
> [    7.314076][    T1]  ? lock_acquire (locking/lockdep.c:5868)
> [    7.316041][    T1]  ? local_trylock_acquire (linux/local_lock_inter=
nal.h:53)
> [    7.317915][    T1]  ? parameq (params.c:99)
> [    7.319735][    T1]  ? __kmalloc_noprof (linux/local_lock_internal.h=
:53)
> [    7.321920][    T1]  ? __kmalloc_noprof (linux/local_lock_internal.h=
:53)
> [    7.326225][    T1]  ? trace_kmalloc (trace/events/kmem.h:57 (discri=
minator 6))
> [    7.327722][    T1]  do_initcall_level (main.c:1409 (discriminator 1=
))
> [    7.329722][    T1]  do_initcalls (main.c:1425)
> [    7.331702][    T1]  ? kernel_init (main.c:1548)
> [    7.333605][    T1]  kernel_init_freeable (main.c:1658)
> [    7.335051][    T1]  ? rest_init (main.c:?)
> [    7.336248][    T1]  kernel_init (main.c:1548)
> [    7.337273][    T1]  ? rest_init (main.c:?)
> [    7.338461][    T1]  ret_from_fork (x86/kernel/process.c:158)
> [    7.339695][    T1]  ? exit_thread (x86/kernel/process.c:138)
> [    7.340878][    T1]  ? __switch_to (linux/instrumented.h:82 asm-gene=
ric/bitops/instrumented-non-atomic.h:141 linux/thread_info.h:133 linux/sc=
hed.h:2087 x86/include/asm/fpu/sched.h:34 x86/kernel/process_64.c:619)
> [    7.342110][    T1]  ? rest_init (main.c:?)
> [    7.343300][    T1]  ret_from_fork_asm (x86/entry/entry_64.S:245)
> [    7.344579][    T1]  </TASK>
> [    7.345444][    T1] irq event stamp: 29481
> [    7.346581][    T1] hardirqs last  enabled at (29495): __console_unl=
ock (printk/printk.c:347 (discriminator 3) printk/printk.c:2932 (discrimi=
nator 3))
> [    7.348686][    T1] hardirqs last disabled at (29510): __console_unl=
ock (printk/printk.c:345 (discriminator 6) printk/printk.c:2932 (discrimi=
nator 6))
> [    7.351184][    T1] softirqs last  enabled at (29232): handle_softir=
qs (softirq.c:468 (discriminator 2))
> [    7.353729][    T1] softirqs last disabled at (29227): __irq_exit_rc=
u (softirq.c:656 softirq.c:496 softirq.c:735)
> [    7.356197][    T1] ---[ end trace 0000000000000000 ]---
>=20
>=20
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260714/202607142131.f70bbad3-=
lkp@intel.com
>=20
>=20
>=20

--=20
Cheers,
Harry / Hyeonggon


--------------jUyNbDSOZ26IDnD3L0wPmVkN--

--------------wHkUIB4ELmmhRpV9tINOU1eM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalhBfwAKCRCGXBN6rc5S
1jnVAQDt5FamH3hO4DZzMBaYydNZuY94ty72o0UZZEFCD8OurwD+PXZpHEPdjRE0
1P+9kwgyaNF33tmh7/hBXJd9MpnApws=
=lXxv
-----END PGP SIGNATURE-----

--------------wHkUIB4ELmmhRpV9tINOU1eM--

