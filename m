Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6011C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98FF56B008A; Thu,  9 Jul 2026 05:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9194F6B0092; Thu,  9 Jul 2026 05:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1F46B0093; Thu,  9 Jul 2026 05:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57FAE6B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:27:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DADBF1C39FB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:27:02 +0000 (UTC)
X-FDA: 84968709084.25.46A217A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B32A100002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:27:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThzPRSD4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783589221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVgp1U3V8Ogs7mMUncRvXIZbvBv3g8G6cE/3dB8ZnwE=;
	b=ASAFnWCAxVEUWHvo4Q0zHrpE4d6Ucc48E5mt7l0V6hxChhrG2jqjjgehMy8YC/BOlJ/Odt
	UAJyriRFrAuI2zQ2HJfDVJt/crurY6t5uJeRqmuZwjSC8mTdlurSUDpGaAghOrkK4MlqGj
	nfXOeB2TzjiIivPDhjK2dKCFYkO2Rbc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThzPRSD4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783589221;
	b=EiPzHm/pAktDlJdrf37tao5LpLJ5SO2AaPZlSlP22++SUS44saY85pXQBBX5iK1+LZe9Zr
	HEW5cwX8r+Of7Y093PmsJSDWclZVX6drqfYpm2DzRxn7OkQEDbtoVG4fXeQhui+7JcTImP
	8IVTS0Kdlc0EnjkIKj5rn1acY1j8je0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C929414B2;
	Thu,  9 Jul 2026 09:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86F31F000E9;
	Thu,  9 Jul 2026 09:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783589220;
	bh=NVgp1U3V8Ogs7mMUncRvXIZbvBv3g8G6cE/3dB8ZnwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ThzPRSD4wcWH+IJwCStCXe4VDHTda2KwzWfOfu60cu+SFpImEvOhC1qjq2/1RRc1v
	 Y6BrTqXi4LMcj5rNk8cUtfwUhFi9DeeoxBQg+Kaaj1m7iCtt8b3F982BcAXVNI6k+w
	 YLgOgmU/bDZAPormrmPyibbVBz2JQB+s57eXbFPV3tUJvXWgDsFyFLCEGe5s6AOzq3
	 ECn5LUdwuZgp5pPy7If5r767OyDJVQ5IUnYycXrL7emwwepyK7M0hmOWBrfDC0Lvuq
	 0hz6x0ABMBpj3LsrjByEhoJ7qHCBR/lLVt53R52EfCgRurpc8UsJpxerGqOreoyPPi
	 3lUHmBngXmnHg==
Message-ID: <afe80d38-950e-44d4-a729-61aa65d3c117@kernel.org>
Date: Thu, 9 Jul 2026 18:26:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [harry:kmalloc-no-objext-rfc-v1r1] [mm/slab] 6bc21472e7:
 BUG:kernel_NULL_pointer_dereference,address
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Danielle Constantino <dconstantino@meta.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
References: <202607091002.cdfe5a08-lkp@intel.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <202607091002.cdfe5a08-lkp@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VQSX66L7KmfdDn0HtaW8k5y5"
X-Stat-Signature: yuzt1cbxh8hky9e7cnuw3sm53s8oy681
X-Rspamd-Queue-Id: 2B32A100002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783589220-755810
X-HE-Meta: U2FsdGVkX1+P8m14+ARwe7WliKlhMdCxx2sgofTf/MZw0AXHW8mslRgm7gN0aad9LUzj1KaxBOdnLHFu2IKzA4/bgbgf81hvidnoojF/u+Q71ZkbnAt1WJnWPF57niKTmi4v9DA+0NT3dRLa6fgLglVJbfhpSCaNvhA9J/AveL1fATN1UhLJcvt4lgtxxRABj5aIJ582nlp6lAynoeg+VpVPGsxoVIkVLFuDhczgr0Pef4mftltgcJVsHW/xIDzUEBanZBT1PF3s7Yk6vOY1GVCMSgDqslD3Dv8MeL1vZFFxfedTJj9SNcrzzZWau9ZhjQFXIFb+xMwVzRTxC+OixvdyF6+vHlbZ6o5keRxFArfNSgV5SLbRbmpWtbPwZfVwpf3QX6k638BF1JfQP3UioaJL43r1sDVDFGHUgURsgJH6b8wZDXQyaK1blD5jDx+QV7C15Io9eM1FSWz355Wt00dCBv92G93kfGSdDi5e9XOUOnJ07L7K7lDPLXA4Wkgcx+9MRXk/QTxooRiHazS+DVX0JNOe8m+DbMJytAM7deLWiSseC7pk+lI/au4P/A5hIoKN0iBuZc9Iyua1M+MScL2tZJv1Kxd7P/+eFlflP7uuHfxUsiScT6W/Kutm8JgdzuN6RkFbNVItX2yLj4VviOZlTETQGJjmQ8pof5hv5KN/IUk5qVvG48TK69KN/vDNrIockFM9sw7hZEVo3jitHKWJXrUfAZj/pF7VbrNXod3LQ6XN8jZ80eyxZrUH7RrR+/x1LYIG27iNqTtg/BbqzjmGHTkqsT0DVITPvddU++RfhT6Gue4akYFUHpNkfjDl1ttBwh2sJWuPRqB4GD+vjFaPXpgKLNJddURjuO/YGbO2nr7wS7JRKUcF+0qE4kA7AzBNlze11acOrKsfB0kY/rAIEdy3b2ZlEJL1Y4HDg6h7OgeC42yxLNk7t4TAJ0xrdoQj8Cuki57bO8LAsyi
 nzohuddn
 GMfcLTcLL43XlvdyHMR7MpUAaoSC+18Z+Mbjc3yrf24IwEjSoG/JizUju5L98H/eDnXeIzXuIbLFDBc3hZiSIHLhzDL9CB0hw+V35275PBfM2Jl2icAXEilc8xvQWgjeoXBL9nsvC4t7PDgngLkCAASiVjzMsgNRd7D0SgR5yW5Gkqayp9TOryPdFYCY3B69BRomJbKdPYioLaYGnP+O5uF1lazU88GQoZjEF8ziKz5DqHQlm6JGOGcQC1YkJeIqZnnEXtqLEHfpvKrwnQXYOKxVqTsv2R1MSg/34TDqigX+SaCZzIN8zG6vKN9j7UX1KsXjB9eN8UAQ4GzMiJKdpbWOhMXXolb0UGQS7VzoDjxybWrdzCOQpCL0TjS8tlW86rPCQm52+OkA9u1OHvq59SUVFbg6YXMMpTEF8PXVZVmhZTFty4soK+bYdEeP3N3hxtfNNivudiuZ/DQn0nesoFZuwni23DCr0R3WL3xj+AdYBKw7j8vCZO6Q2ib+AB447BrLtaWOzO162HqqWkJriDwZC+D1t27HvQCy0g3oUgSA3NCoN560gaOC+TnG4g1g0T/Yr/41V2yn3f4gyENrRAl60sil876rfU0MU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VQSX66L7KmfdDn0HtaW8k5y5
Content-Type: multipart/mixed; boundary="------------ISDC9IqOF8dPHjSJEm9wYiFT";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Danielle Constantino <dconstantino@meta.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Message-ID: <afe80d38-950e-44d4-a729-61aa65d3c117@kernel.org>
Subject: Re: [harry:kmalloc-no-objext-rfc-v1r1] [mm/slab] 6bc21472e7:
 BUG:kernel_NULL_pointer_dereference,address
References: <202607091002.cdfe5a08-lkp@intel.com>
In-Reply-To: <202607091002.cdfe5a08-lkp@intel.com>

--------------ISDC9IqOF8dPHjSJEm9wYiFT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/9/26 5:48 PM, kernel test robot wrote:
>=20
>=20
> Hello,
>=20
> kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address"=
 on:
>=20
> commit: 6bc21472e7eb9f8c771ffdf86266aa6d9dcb1dac ("mm/slab: prevent unb=
ounded recursion due to obj_exts in free path")
> https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git kmalloc-no=
-objext-rfc-v1r1

This is v1r1, and I posted v1r3, because it was bootstrapping sheaves
for normal kmalloc only. This crashed the kernel but was fixed in v1r2.

Apologies for the confusion, I discovered bugs after exposing it in my
tree (force pushing isn't great, you know...) I should probably have
deleted that broken one, though. :)

Will be posting v2 that fixes false warnings w/ memalloc profiling
debug shortly.

> in testcase: boot
>=20
> config: i386-randconfig-2006-20250804
> compiler: gcc-14
> test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4=
G
>=20
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202607091002.cdfe5a08-lkp@inte=
l.com
>=20
> [    0.183091][    T0] BUG: kernel NULL pointer dereference, address: 0=
000000c
> [    0.183772][    T0] #PF: supervisor read access in kernel mode
> [    0.184312][    T0] #PF: error_code(0x0000) - not-present page
> [    0.184851][    T0] *pde =3D 00000000
> [    0.185186][    T0] Oops: Oops: 0000 [#1]
> [    0.185561][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7=
=2E2.0-rc1+ #1 PREEMPT  27a7cd77b6ab41253c0455bf8bac7f75db905e14
> [    0.186647][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    0.187601][    T0] EIP: __kmalloc_flags_noprof (slub.c:5311 slub.c:=
5506)
> [    0.189928][    T0] EAX: b11c8b96 EBX: 00000000 ECX: b18bdac5 EDX: 0=
0000000
> [    0.190574][    T0] ESI: 00000000 EDI: 00000150 EBP: b1e17df0 ESP: b=
1e17db8
> [    0.191220][    T0] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFL=
AGS: 00210046
> [    0.191925][    T0] CR0: 80050033 CR2: 0000000c CR3: 0253b000 CR4: 0=
0000090
> [    0.192579][    T0] Call Trace:
> [    0.192877][    T0]  ? alloc_from_new_slab (linux/spinlock.h:408 slu=
b.c:4416)
> [    0.193350][    T0]  ? alloc_slab_obj_exts (slab.h:39 slub.c:2149)
> [    0.193823][    T0]  alloc_slab_obj_exts (slab.h:39 slub.c:2149)
> [    0.194280][    T0]  __alloc_tagging_slab_alloc_hook (slub.c:2329 sl=
ub.c:2358)
> [    0.194833][    T0]  alloc_tagging_slab_alloc_hook (slub.c:2381)
> [    0.195372][    T0]  __kmalloc_cache_node_noprof (slub.c:4596 slub.c=
:4893 slub.c:5482)
> [    0.195903][    T0]  ? init_kmem_cache_nodes (linux/slab.h:1192 slub=
=2Ec:7732)
> [    0.196400][    T0]  init_kmem_cache_nodes (linux/slab.h:1192 slub.c=
:7732)

Here we're allocating kmem_cache_node for KMALLOC_NO_OBJ_EXT, but
kmem_cache_node itself needs obj_exts array.

> [    0.196882][    T0]  do_kmem_cache_create (slub.c:8646)
> [    0.197354][    T0]  create_boot_cache (slab_common.c:717)
> [    0.197788][    T0]  new_kmalloc_cache (slab_common.c:735 slab_commo=
n.c:996)
> [    0.198237][    T0]  create_kmalloc_caches (slab_common.c:1019)
> [    0.198701][    T0]  kmem_cache_init (slub.c:8555)
> [    0.199125][    T0]  mm_core_init (mm_init.c:2728)
> [    0.199533][    T0]  start_kernel (main.c:1034)
> [    0.199939][    T0]  i386_start_kernel (x86/kernel/head32.c:79)
> [    0.200368][    T0]  startup_32_smp (x86/kernel/head_32.S:292)
> [    0.200791][    T0] Modules linked in:
> [    0.201141][    T0] CR2: 000000000000000c
> [    0.201513][    T0] ---[ end trace 0000000000000000 ]---
> [    0.202004][    T0] EIP: __kmalloc_flags_noprof (slub.c:5311 slub.c:=
5506)
> [    0.202522][    T0] Code: 7d d7 00 74 0a 84 d2 74 06 31 c0 89 df f3 =
aa ff 75 e8 89 da 89 f0 8b 4d dc e8 47 28 00 00 59 8b 45 e0 89 da ff 75 0=
c ff 75 dc <ff> 76 0c 8b 4d d8 e8 00 da ff ff 83 c4 0c eb 16 8d 45 e0 50 =
ff 75
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:	7d d7                	jge    0xffffffffffffffd9
>    2:	00 74 0a 84          	add    %dh,-0x7c(%rdx,%rcx,1)
>    6:	d2 74 06 31          	shlb   %cl,0x31(%rsi,%rax,1)
>    a:	c0 89 df f3 aa ff 75 	rorb   $0x75,-0x550c21(%rcx)
>   11:	e8 89 da 89 f0       	call   0xfffffffff089da9f
>   16:	8b 4d dc             	mov    -0x24(%rbp),%ecx
>   19:	e8 47 28 00 00       	call   0x2865
>   1e:	59                   	pop    %rcx
>   1f:	8b 45 e0             	mov    -0x20(%rbp),%eax
>   22:	89 da                	mov    %ebx,%edx
>   24:	ff 75 0c             	push   0xc(%rbp)
>   27:	ff 75 dc             	push   -0x24(%rbp)
>   2a:*	ff 76 0c             	push   0xc(%rsi)		<-- trapping instruction=

>   2d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
>   30:	e8 00 da ff ff       	call   0xffffffffffffda35
>   35:	83 c4 0c             	add    $0xc,%esp
>   38:	eb 16                	jmp    0x50
>   3a:	8d 45 e0             	lea    -0x20(%rbp),%eax
>   3d:	50                   	push   %rax
>   3e:	ff                   	.byte 0xff
>   3f:	75                   	.byte 0x75
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:	ff 76 0c             	push   0xc(%rsi)
>    3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
>    6:	e8 00 da ff ff       	call   0xffffffffffffda0b
>    b:	83 c4 0c             	add    $0xc,%esp
>    e:	eb 16                	jmp    0x26
>   10:	8d 45 e0             	lea    -0x20(%rbp),%eax
>   13:	50                   	push   %rax
>   14:	ff                   	.byte 0xff
>   15:	75                   	.byte 0x75
>=20
>=20
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260709/202607091002.cdfe5a08-=
lkp@intel.com

--=20
Cheers,
Harry / Hyeonggon

--------------ISDC9IqOF8dPHjSJEm9wYiFT--

--------------VQSX66L7KmfdDn0HtaW8k5y5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCak9pXgAKCRCGXBN6rc5S
1mmYAP4q+ZLftQXDL73RGcpuRZTmgZHuTv49mi0GkAGvjVCYMAEAvjOwjFBuBE17
rDy3tmeOsAX4ILXAnWYbT1HWj7HBlQI=
=yJEp
-----END PGP SIGNATURE-----

--------------VQSX66L7KmfdDn0HtaW8k5y5--

