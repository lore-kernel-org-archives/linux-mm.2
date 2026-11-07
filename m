Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C54606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lXOXgSf3
Received: by kanga.kvack.org (Postfix)
	id 3E8036B05B2; Sat,  7 Nov 2026 02:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BFE86B05B5; Sat,  7 Nov 2026 02:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDEA6B05B6; Sat,  7 Nov 2026 02:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0906A6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:15:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 778371402A4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:15:37 +0000 (UTC)
X-FDA: 85407462714.24.0818BC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C3FAF20006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:15:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lXOXgSf3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794035735;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzXZdhnaevFG7m6vfikATmsg/E5a/qIjqv85ia5RRoc=;
	b=tNTaWzualLX+6VYmjJqmXHeEYm3aoG+LpbEfhIiaSQxHXBMnEfM/tGoKbs1nLkCuKmtTB/
	rzsQxWXPM75q4GfJjXPBcDHgaW6n6Z4gTbOOBsWCz++PLKSP7e9siUkkFCOhqfGSTclX/G
	bJuDnvIuc3ePoQt7Clz/pGygDiTii2c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lXOXgSf3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794035735;
	b=RBB2T5B10rHe+YpWGFzwgzOPTHWScnNVQiM1OBS8yZhBigiuuvjZ8/DFGSVnivSSw/Mcmg
	KKxHf3uzuOqGvRIFgAiQfSvo6FZHGLL5EvcBJE1v/8qM562jVGSegGXobgpYMvseOccbB6
	/lYKHOyRz1IjRDgoIhqKXCIF0vlUMCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9FAE437A3;
	Sat,  7 Nov 2026 07:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2352A1F0089F;
	Sat,  7 Nov 2026 07:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794035734;
	bh=vzXZdhnaevFG7m6vfikATmsg/E5a/qIjqv85ia5RRoc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lXOXgSf3CTPIOLuzygqugyz/m3Kblgh8MJs48+8iMsrQjzG/qreHEh6jO47pbs2re
	 3Uurw9Fnc9zQFse+AdXIM57kpmzdsdr1ooxzZqIvRiCYXeJlt07zQ8jYqlkv8E8OLB
	 BUay2w1iDEsNeXgnApmBVX/YkfaRTnV5iO8RYzy2pKRTix0uDbT98nUisN3fax9Vm9
	 AWVEq0WetPaNznRKVC8P1r3D+YP4JRnSVN+EpNFOKu1I600ottqeNwplAml/t5VSHC
	 N0BsVidOkEyx3RLTv4wvcJq0/hAHxAWeZytzszlFcTY2vEhrcSIW2Q919aFyhUE1q/
	 R2sd0rh6zc5tw==
Message-ID: <sashiko-outbox-202683@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] riscv: Add support for kexec handover (KHO)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Pei" <cp0613@linux.alibaba.com>, pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, shuah@kernel.org
Cc: guoren@kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20261106071459.2003-3-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-3-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:15:33 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C3FAF20006
X-Stat-Signature: bnm3wfawae8y13o4unc68d8m1ycfktgi
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794035735-527964
X-HE-Meta: U2FsdGVkX19va43jQYSlUItqt0jhKN2ZY0sNhYgojITsUtAT+GpV1xD9MchxNJ3YNM5cFGpudjxCcZ/lxNufS/gLtz3+3yFr5ilzm9ka+W+Yc3TgZ3jsd/RtXtqDr2jVCBjU4lS6+LaSF+bbMXTSlbt5MIzckkaLsrPjTXDGUKKAtBGgfUq3EYFxZfMmut0d5YzNSOPBYYGQ8PKiTyaBQhB1eKKI4FrXaBjyZ0Ed9GE0chjAndVPLB6iTatK0HzwZER39M9GOUGuH/J++A7eactH7FEYW/YJW4UBcYABV2OvDT0nzhn4w5ogR3rKCWWgj9DMrFfrrrgvmrnprAotp18ifGcavoINxSE6n7dNOSdapQOe7lrTsA2ufAf6k9/lxqv73Wpe4CgrOauvrfqYlavLBxFiyP/lMwtE/txNyGQ80Blcmxe8lswJsa+AwzN46SMXaBbEdIt1Az8awSKaXBZmozc7RSpiF1HsKUrDHduJwCXMAIOEEZz0+g+r/+ALKi/fNzIgx0XYUtOo4qmZUmxW/HN0OaFarkRVKq/wJm7ZcdpS97TCdt1ZtYZrEuUXuliL5Cb1CBfmFfn65klWeao2RKIr1zx1IqvZEtzOS+KYrHlf63cfH8ok5AmiCqBnH/CD7kAHTr9xg+z0eGQniKxzDTsDGohtJMjVrRYSa04Y9dCR2vUBm0cB/yF7bsFC6drZ3jL8SdcsO3Bn5uWicVHVS0OIlKF59Sch8foyQViMeuHf4HWMNGcFWbjHKE3fmeonTGfOr4Fdua6rFwNCpWAuQpHiL7kYRuUKBA6xGGlds0Air7cK76vu+PYz+vb0Oj+zsChtiPW6yLGjRSL828g6pYohyriJe61ylzd7//e3hiYJ45o4nfPGsUmtg12NGoab5CghbORElX0NsX08/7D6VupbINxCnwDjqXb2dyjKgznCl8jQbK/YE6x5JaR7o5ACxtltVnwbiS56Xmd
 mJ2c5c4r
 A0M9VpAJNhCatFeZ3cmKGumMrLOqY7V3rYSyCHW6BnzuRz/NUqE77grgDBXgrEIg+aX8LkLgvluMhyf+4KSCHwI6hKk4HD+cc7hUOyAceuN3n0Na9yelavkRk4rKc9DI4KvZ/KJtCaXKF3gI1sZiQMt+TLSIaJTfWeUqoKqLA/jLysfE8ILysUVl5c4JgoUVLStkEF294Nvc51AL+HlW3QthRE8v6H73Sjin55g/r+W9Y0Rof4PzKRNTQIKOmsKIDw9zL+pwchlPvmEciodu2/Iq8Zix0WXyZBOh0+QmIv6bMy3zgCsKGFvTbUdZaNkSnCdt6a4IQH5b0xHDItoSUUCNf3sPFOSWMLxmtod42UFrn4u3dn5xU2hL217Sn3fBr3MZ1b/SPWfF2pYadi171oVoJab70o+CePN3LpduUgXV/forN+SvmEZux3n/kB8ZTqc3rm6sVAZeiVbBnvjTG6h1reQlSlmaPZphHk40D+fW5MFrhd5++gN3z2jmPczV4neqlmcoeRB20Itscw5GX++hVBbwxMuD2f5WNBRr0DmTRcTdctGjqwdQKhwuLzeBll0o1xuqIyk08DiOTJbpNCfO9vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] riscv: kho: BUG_ON() in linear_mapping_pa_to_va() during
  efi_init()
- [Medium] riscv: kho: kho_reserve_bootmem() fails when DRAM starts at
  or above 4 GiB
--

commit 9359adbe095f746cadb4028ea618b75e0af09036
Author: Chen Pei <cp0613@linux.alibaba.com>

riscv: Add support for kexec handover (KHO)

This commit enables ARCH_SUPPORTS_KEXEC_HANDOVER on 64-bit RISC-V systems
with MMU support.

> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index bde1f1885038f..bffef6b903e13 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
>  config ARCH_SUPPORTS_KEXEC_PURGATORY
>  	def_bool ARCH_SUPPORTS_KEXEC_FILE
> =20
> +config ARCH_SUPPORTS_KEXEC_HANDOVER
> +	def_bool 64BIT && MMU
> +
>  config ARCH_SUPPORTS_CRASH_DUMP
>  	def_bool y

[Severity: High]
Does enabling KEXEC_HANDOVER here hit BUG_ON(!kernel_map.va_pa_offset) in
linear_mapping_pa_to_va() during early boot on UEFI systems with
CONFIG_DEBUG_VIRTUAL=3Dy?

In setup_arch(), parse_dtb() populates kho_in.fdt_phys, and then
efi_init() runs before paging_init():

arch/riscv/kernel/setup.c:setup_arch() {
    ...
	parse_dtb();
    ...
	efi_init();
	paging_init();
    ...
}

efi_init() -> reserve_regions() -> is_kho_boot() -> kho_get_fdt() calls
phys_to_virt(kho_in.fdt_phys), which translates to __va() ->
linear_mapping_pa_to_va().  On 64-bit RISC-V, kernel_map.va_pa_offset is
still 0 at that point because it is not initialized until paging_init() ->
setup_bootmem().

[Severity: Medium]
Can kho_reserve_bootmem() fail on 64-bit RISC-V systems where DRAM starts
at or above 4 GiB?

RISC-V does not define ARCH_LOW_ADDRESS_LIMIT, so it defaults to
0xffffffffUL in include/linux/memblock.h.  When all DRAM starts at or
above 4 GiB, bootmem_size_update() sets bootmem_size_lowmem to 0, and
kho_reserve_bootmem() unconditionally calls memblock_phys_alloc_range()
below ARCH_LOW_ADDRESS_LIMIT:

kernel/liveupdate/kexec_handover.c:kho_reserve_bootmem() {
    ...
	size =3D bootmem_size_lowmem;
	addr =3D memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
					 ARCH_LOW_ADDRESS_LIMIT);
	if (!addr) {
		pr_err("Failed to reserve lowmem bootmem\n");
		goto err_free_bootmem_desc;
	}
    ...
}

Because no memory exists below 4 GiB, the allocation returns 0 and aborts
KHO initialization.  Conversely, when all DRAM lies below 4 GiB,
bootmem_size_global is 0 and kho_reserve_bootmem() records a 0-byte entry
in kho_bootmem[], which causes kho_walk_bootmem() to build an inverted
struct resource with end =3D start - 1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106071459.2003=
-1-cp0613@linux.alibaba.com?part=3D2

