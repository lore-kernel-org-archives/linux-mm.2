Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6E3606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KoojDrfl
Received: by kanga.kvack.org (Postfix)
	id 273DB6B05B1; Wed,  4 Nov 2026 03:10:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B3D6B05B2; Wed,  4 Nov 2026 03:10:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188E56B05B3; Wed,  4 Nov 2026 03:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E913F6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:10:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FF75804A7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:10:27 +0000 (UTC)
X-FDA: 85396714494.19.2E21F16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 82FF4140003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:10:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoojDrfl;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793779825;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pw1RA8b/0wqWpwAG8rn8nMbI8/CS2La9EFhpCnYgEt4=;
	b=TGvrCtaNQo3YucK9Ymc5yURpv4d5MI01gJkTygc4IzbYT69XXh5HVODpFr7iBvz7oZ9yOS
	B4lgwsHA8n7/MmWcs1H2orZABzLd2WZo9orvemsfx3I34lfITFqB4dgwDsBYVOsmAdvszV
	TuDhIiv4kp8NVs37d0UP4kUondHGqzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793779825;
	b=60GPtK3KTlUcd0dQITJ8xD2/fNRrl5tQQyuG2cOEjrwpBqkLQLNQc4i0ykUOyTqJSbrKD7
	PMORfgScbiRU+NVBNDErlE2xD+4Ine+B7xX84syLMqkyadS/2FEyenujAnyYFNj/FIJuag
	Kitwtux5tviUdJSIJpO7Ble0ZNrx41A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoojDrfl;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 008D260D9B;
	Wed,  4 Nov 2026 08:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178811F00A02;
	Wed,  4 Nov 2026 08:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779824;
	bh=Pw1RA8b/0wqWpwAG8rn8nMbI8/CS2La9EFhpCnYgEt4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KoojDrflsyT352+kmH6suq8he+NSQ6/q6xmVHkGlSicSPJjOeWsqaXFoQ7hIB8OFX
	 YVtkEK9bOARfkuo/urulh2JSAXw612CS1tUEjXQASxf4obq5lilY4IgBXG+6HiwOld
	 scTQVVre6Gq0jzmFai+h55fzFB+XejmC5wDvDkSLWOG8m4PKVItjB5l7OVULSarR+p
	 UeCaVPkVzinfoYpzgwd6QYJh+6wQpXEv9zRRSrZBUtzhGirQWWP4kZt8sVtKps5k/E
	 4A41XuinKlgZwFv63c37Rml1ZcF07flt71FjoPVGLVW6u28r6GLh6x5UOvrIEy7yV2
	 hjIViDB11k3jA==
Message-ID: <sashiko-outbox-196857@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/5] riscv: Add support for kexec handover (KHO)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Pei" <cp0613@linux.alibaba.com>, pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, shuah@kernel.org
Cc: guoren@kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20261103080926.2079-4-cp0613@linux.alibaba.com>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
 <20261103080926.2079-4-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 08:10:23 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: nyq1npsdps49tj67rqkazfacndashihm
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 82FF4140003
X-Rspam-User: 
X-HE-Tag: 1793779825-991652
X-HE-Meta: U2FsdGVkX19w32e4ZSYzwz9oOZlsCCnObUeCnVTWUCzm2lWIw8stpfOd/oncxmy3lOeL+nFDsFqfotvNHYVR0IHJesdwG16IqrSlIbIS+AdYQT7p/IeCdvXICZ4qyeDx8nzhD/8eUtqDUGxfARLDZr/pW6xj9niRI9C0Ntm8qCGoE0CDmgqz2QJ/rDucW4qkztXNw7FEHd8g905vecJ87hJP8n2dOl7B3lWMMwAAQBW22HquouYbdVoPmlHd5rNVNQuVD5h5d14J3xea6BV2rPxh2IIgBmQ0ajGyE74vEeYgpi9TZ7Bl+8r7NX1rFjDlyPeJC9glBGXkUj/fsYtF4qDr1ynvFZH4UuZZAaN7XlotIPiRrImA1AoM0svGtEPJ6okmRH9qybQyA1FkE8ux7MO1bIj8rIiMNtjBFFMXUt99WbbxSlfzN46tpzaB2CQZOxk0PknWxJzgJLyOF0FqbtqLqwC2RXgRoVqzE5ZEyp6u3mNFuT/j5T+0adKSZS2ylfNP5Sk3yt4OufcJN+7wUg8wVMP8vaytKl9pF/d/bu/IXaziEFAoOy3gOQMGjqe3c/5Es4Nf5HWXyE2iTrHyRQs0j9oAqcLmPqx3UTYKyAue/iZTt7T9fL2+F4+1p+T3RtGPRGbr9eBRLNyunWQJFXS1nEADTC4hkaRy5GQ3nK7baxhBnrt58zUdHcW1Xps6WlSZGt/2j31Jf5TK1PTJ7djHJfhiz4gud753s++rARQn8DELdWNdfh0cr7N3+XTzG6wARikGaM6bT7BHzpPTEooaDXcEmSypMo4yArjYQV6wm4moEHijoC+HNlnouex/RKp+nwPMjEzk3qNKuQ0UCZ/6Hmup9aTe7kCs3grgi7mSCrwFPJ8odAQl4arwU6S7lJ9FpX3g2nuLOsDd1+IAS7IAsxQZYAd9fgUqxstmDkm13IP0rqQdQRRdzsaMyf66YXdLwUpt2UzPHOoqX0h
 p6T+QcC1
 Ih5bX/4LPAhMmm9M9/mIkzlo5gETHd5B1lMfcgeiDMR6/8FL4Nu3ivkAavp1SjCWQL/1MldeHwklTfFrnC70nv+si+mJgtspEc1rZ8OhFcBZN99wDXLVyrn6IR04FwqFHdgUbezfuaULDN4KVq+nREoKCqmqkng23E4xRqkWQm/OD5kZb0MBLX5TWCxSa5neFYyfwdTgZAKI/vSxicZtPdytQdnZWrnj6IS6HrGSx4h3Bfdt4DIixiTwV/j1EKcQIrCQXjkCJ79uQx2790F4SWoZg5+bS/sAwcAnAyXy2oEystfmxdoGUvQQ0MxZcDyyOThS6KVoKAOYrZ1DhP0aVAjoyoFt8mJNu0byQyVogy/4qeZG+sZcBuxjx3GvVDro9uPkb4Ue+jrjkxVACzo1Sd+gSFY1rIw91/9u8OtfqMwFhvIE9/JsZj/ywUfZbIIp+1cdHMwYm6gfEVU55K/vo1mlr/wdxey7TILZoo3gZq+EQUa8RN28mQk6s2GUdno2fvhlIqyfwbNnxkJniHhOYoJgj1ZGbTjiscGgRkf3CEc7Vmj0BuLdBFBHEDqYM0MQw18Gt0Y30X21mdfHlZoZnZRRduIOeUg9OffJQ1tvmx1tEC/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] riscv: kho: bootmem reservation fails when DRAM starts at or abo=
ve 4 GiB
--

commit 25f3cc12aa8edcc1fbb1363f837f61e462a57ad6
Author: Chen Pei <cp0613@linux.alibaba.com>

riscv: Add support for kexec handover (KHO)

This commit enables kexec handover (KHO) support on 64-bit RISC-V systems w=
ith
MMU enabled by defining ARCH_SUPPORTS_KEXEC_HANDOVER in arch/riscv/Kconfig.

> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 435da07132437..e11463a923a32 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
>  config ARCH_SUPPORTS_KEXEC_PURGATORY
>  	def_bool ARCH_SUPPORTS_KEXEC_FILE
> =20
> +config ARCH_SUPPORTS_KEXEC_HANDOVER
> +	def_bool 64BIT && MMU

[Severity: Medium]
As reported by Sashiko on v1 [1], will kho_reserve_bootmem() fail on 64-bit
RISC-V platforms where DRAM starts at or above 4 GiB, or record a 0-byte
region when all DRAM lies below 4 GiB?

Unlike arm64 (which defines ARCH_LOW_ADDRESS_LIMIT as arm64_dma_phys_limit =
- 1
and clamps it to memblock_end_of_DRAM() when DRAM starts above 4 GiB), RISC=
-V
falls back to the default in include/linux/memblock.h:

#ifndef ARCH_LOW_ADDRESS_LIMIT
#define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
#endif

However, 64-bit RISC-V supports platforms where all DRAM starts at or above
4 GiB, as seen in arch/riscv/mm/init.c:arch_mm_preinit():

	bool swiotlb =3D max_pfn > PFN_DOWN(dma32_phys_limit) &&
		       memblock_start_of_DRAM() < dma32_phys_limit;

When KHO is enabled at boot, mm_core_init() -> kho_memory_init() ->
kho_reserve_bootmem() unconditionally allocates both lowmem and global boot=
mem
without checking whether their computed sizes in bootmem_size_update() are =
0:

kernel/liveupdate/kexec_handover.c:kho_reserve_bootmem() {
	...
	size =3D bootmem_size_lowmem;
	addr =3D memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
					 ARCH_LOW_ADDRESS_LIMIT);
	if (!addr) {
		pr_err("Failed to reserve lowmem bootmem\n");
		goto err_free_bootmem_desc;
	}

	kho_bootmem[i].addr =3D addr;
	kho_bootmem[i].size =3D size;
	i++;

	/* reserve large contiguous area for allocations without nid */
	size =3D bootmem_size_global;
	addr =3D memblock_phys_alloc(size, BOOTMEM_ALIGNMENT_BYTES);
	if (!addr) {
		pr_err("Failed to reserve global bootmem\n");
		goto err_free_bootmem_areas;
	}
	...
}

On 64-bit RISC-V systems where DRAM starts at or above 4 GiB,
bootmem_size_lowmem is 0 and memblock_phys_alloc_range(0, ..., 0,
ARCH_LOW_ADDRESS_LIMIT) finds no memory below 0xffffffffUL, returning 0 and
disabling KHO. Conversely, when all DRAM lies below 4 GiB, bootmem_size_glo=
bal
is 0 and kho_reserve_bootmem() records a 0-byte entry in kho_bootmem[], whi=
ch
later causes kho_locate_mem_hole() to construct an inverted struct resource
with end =3D start - 1.

[1] https://lore.kernel.org/r/sashiko-outbox-183678@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103080926.2079=
-1-cp0613@linux.alibaba.com?part=3D3

