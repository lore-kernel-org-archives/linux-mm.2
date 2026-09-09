Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85CDC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1BE6B0099; Wed,  9 Sep 2026 09:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62426B009B; Wed,  9 Sep 2026 09:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51106B00A3; Wed,  9 Sep 2026 09:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92D6B6B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:21:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0C121C02AC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:21:32 +0000 (UTC)
X-FDA: 85194285624.05.70EE61F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 340AC14000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:21:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSZMaNiF;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960091;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et8Tc+zJYrlmS7IHYeOD4T4P7eMPWgKqQ5XzB6XXw7M=;
	b=rNskxsUnErvbbgNSrb10PAspu6NBV8ItZSLkpOptlkJHMVAD/xUgZ/sKr/abmz0FG3J3p3
	gUIUVIlsTtcbKpw7VTAebuS0MIX6IeEMQHaI2z3MLdgA8GSAQykknVmIK+qFW9TK/n5yLC
	mfYUoZmzJzPGhlJa8dtvRnlY0+FNNrU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSZMaNiF;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960091;
	b=sQ/sgkTmxFwPbPzOGRRtHzwoRSNYKswHyGYMAEgk8OzQCT+D8DIG2su1hUX2lU6+RP21Oi
	9IVPnUCqwLvE2OtbCblPvNbyIGcnF6gH9E/CfKwsXaEne8imf5BPKEYpBsy1GT/CdpqCkO
	b1LR7TQtQEo3uLLMNg8109wbHFS6sVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A7C041486;
	Wed,  9 Sep 2026 13:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4D01F00A3A;
	Wed,  9 Sep 2026 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960090;
	bh=Et8Tc+zJYrlmS7IHYeOD4T4P7eMPWgKqQ5XzB6XXw7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cSZMaNiFDM/iBbEtipO42XrDHprhWxCTfMIycSPNBvU57qYx7auTLKBkEex9w0WQv
	 SKXEtl/3ZYJyMM9IfTMl9feHqT1bnBoVu9ONikLN8FktK7fjmOAnJKTIVbtELsgJuy
	 TPdXsRaftBDkIpm7qDvNYomLzyPH1TPmwnH1PGdM12W6ZhNR+5Fnw1iw4t+TnvdC3F
	 NMmn/RKfetqFCNdf3nAuvQU/PsWuHEapuyYy2BRPB4Udq6FMVRXMTrVzQguhktAZzL
	 9lgZzW2BlYbgPpL4s3q0ps1mvZVlFFCx7QgDQ1MPp6UegTTYvLhQPoclSHHsMP2THN
	 z1OtfDX0svuIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Michal Hocko" <mhocko@suse.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, kas@kernel.org, "Vlastimil
 Babka" <vbabka@kernel.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, "David
 Hildenbrand" <david@kernel.org>, "Breno Leitao" <leitao@debian.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Borislav Petkov" <bp@alien8.de>, "Suren
 Baghdasaryan" <surenb@google.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Zi
 Yan" <ziy@nvidia.com>, "Thomas Gleixner" <tglx@kernel.org>
Cc: kernel-team@meta.com, rmikey@meta.com, harry@kernel.org, linux-efi@vger.kernel.org, riel@surriel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20260909-hwpoison-kho-v4-3-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-3-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:21:28 +0000
Message-Id: <20260909132128.AD4D01F00A3A@smtp.kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 340AC14000B
X-Stat-Signature: icumyyg8d7zntgw361efj66bohghzcry
X-Rspam-User: 
X-HE-Tag: 1788960091-568101
X-HE-Meta: U2FsdGVkX19SOHd+Pd/iYc/bRPFjiMDIxs3gAZmMRZHN49GsYXKBMtqC0QVynBdUAuFiAbLHL2kxxMmrtAcrIysuKQQgGcGrlEgUz5ksVfePXf+HQBoXDjsC1dWWkjEG7t4Zvf/IbwT1cZ5PIAFkl1syNSjQjppuSuICIyIPaK2CFXMmnPtMmM0+oI/o2Tq65KWTifcShYSg9tkGUp9idf3j85ZPTgu8ZjpKM6t8NKFpCzPr4cP66/Yhzu9PA/4NqQamCDSPHI7uKvC6eLbHJpIzF7p6yGpisZ/+bfbtiZe+0AxjFP5wPZ9mmiE/L8i43W77pkI7CHkpweSeXJATIVoALMOYSiYSjzQqzU8KkbFFEzNFW4TS43WIKw4lidc7Lc8aTdAl238ntSmUMLmAXg2oINGLW9WxgEFvuo4TzCVVI9kIMBpcyeqiFSN/MjOt3YWQn5/J2oPhihcIaok/KQ8iyXeoq0/X7hivgn0/dVjy8BlA4MiWtAs/wkd6LB5Ihj5BqQDKiQg995Q6b6SCRZyKKwxkhJmS7lut63OVm++/b4yCquZhplFYq5meLEYUP9Y292yf3GVFlzqDlANtDrCKNPX2notKCICzlv9gKnfz7vO7ybGpBi2Rs0lsveaOb1OMRTkX4rANb6Nk6nev8NSFzxdH8nR2sZri3kBpJ/ONnidqwOlnmE6XytucMmstSbaNimWtd7lRJu7hkrlgtzgnmHd61rb4GUwqPjF57o/KkVEpAuC6WrSWUJiinLs46V9ehit5QD3BJRPLrCOUdE95OrU7OIFNnzZA5CYU7ZYpPvqqJ5RN48uSspshZwV2vlIoc+jMaKfmcyza0oDZl+DS0C6TAV3sCJSP/mFI+/Gh+YBaNhFF6CGA45LvPCoxG/RYfwnRPTZh6kxSruNebk9XtHL1eHGB6UTfgcixzwb8My2vtaoWV97MStPAEA2Fx1gvL1Mf1k91cO2PFXq
 c1SeOpKi
 E2EGbkDX1FUlBL4RT/ZjZc65ENHX+FrjUnK/pkxX9F9OLMRnB9ApRnTvIb/xaftw/0uncwFJzkMZgMr5i4rCSKqTObrAyNvD9hVjf5zpVcu6lXaTvilq7A3heHn0/E4LdWa3HOrSY3mBgOc1umFZGuUy/mNY9co/Awj56y2h+XiK/ne3YzSgcR6zzUEVLeXJm/VqIhjY5Vq/vpI3VktqYRpABSMrrq8Ty515vhTbkaiLRyNml7ev7aWALMty/DLUshP8OtM0gbO7/wVY8ovOh0AaJ92eVWUi8vdTpX+Zqr8mftjOLE1xKAFgn/TIOnJx7SdzICVZ/KIvTeVpgNbIlRxIFFLDoKXqkhqH5GYC7peEvVLGHxr0hUE8H3jpcWaiIeABHOJBZ3R8ZqeWr83UXWpkRmBiaFD7FSIbEPTtHBOxNSCBKClww3czX1F0Oa5vTUo8C0UhugokgnWzRnYmck75LJzc/d5TN+gRLIYGsJNHe5ysqwMnpVPwotsG2sZusGh/dcaxk2cBNAfwcw+TUWgHdNM/YhS8dzmKCtll5RNqmKkQYcco2uqVi3HW/7OaQvPcv2P9cmiZylGmL0mfSNg+BI5aA6loCprmWD4yYZ+qGrSm0woWloIw7p7CPiERruVwXy6K/zp6MW4Ufb/KdgAMEN/WMDvK0mOeP1hgPKB18N50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing overflow check when computing the end address of the EFI p=
oisoned memory table can lead to an unbounded memblock reservation and memo=
ry corruption.
--

commit 7216d7e029930900ac5741a5f5bbfe7a2107b408
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-m=
emory table

This commit hooks action_result() to efi_hwpoison_record_pfn() to record ha=
rd
offlined frames in the LINUX_EFI_POISONED_MEMORY table, ensuring they are
passed down to the next kernel via kexec. It also adds early initialization
code to vet the table inherited from previous boots.

> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> new file mode 100644
> index 0000000000000..c18edf111c710
> --- /dev/null
> +++ b/drivers/firmware/efi/poison.c
[ ... ]
> +static bool __init
> +efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
> +{
> +	u64 nbits;
> +
> +	/* Whole words, and a bit count that can be taken without wrapping. */
> +	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
> +	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
> +		return false;

[Severity: High]
Does this validation fully protect against an excessively large pm->size?

While check_mul_overflow() validates the size for bit conversion, it appears
it does not verify that the table's footprint fits within the physical addr=
ess
space without overflowing when combined with efi.poisoned_memory.

> +
> +	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
> +		return false;
> +
> +	return IS_ALIGNED(pm->phys_base, pm->unit_size);
> +}
[ ... ]
> +void __init efi_poisoned_memory_reserve(void)
> +{
> +	struct linux_efi_poisoned_memory *pm;
> +	phys_addr_t start, end;
> +
> +	if (efi.poisoned_memory =3D=3D EFI_INVALID_TABLE_ADDR)
> +		return;
> +
> +	pm =3D early_memremap(efi.poisoned_memory, sizeof(*pm));
> +	if (!pm) {
> +		pr_warn("Could not map poisoned-memory table\n");
> +		efi.poisoned_memory =3D EFI_INVALID_TABLE_ADDR;
> +		return;
> +	}
> +
> +	if (!efi_poison_table_valid(pm)) {
> +		efi.poisoned_memory =3D EFI_INVALID_TABLE_ADDR;
> +		early_memunmap(pm, sizeof(*pm));
> +		return;
> +	}
> +
> +	start =3D PAGE_ALIGN_DOWN(efi.poisoned_memory);
> +	end =3D PAGE_ALIGN(efi.poisoned_memory + sizeof(*pm) + pm->size);

[Severity: High]
Can this computation wrap around if pm->size is maliciously large?

Because pm->size is only constrained to be less than U64_MAX / 8 in
efi_poison_geometry_valid(), an unvalidated addition here could overflow,
resulting in end < start. If that happens, an enormous end - start would
be passed to memblock_add() and memblock_reserve().

This could result in memblock capping the size to PHYS_ADDR_MAX - start,
blindly marking the rest of the physical address space (including MMIO) as
RAM. This forces direct-map cacheable page table entries for MMIO regions,
leading to system crashes or memory layout corruption.

> +	early_memunmap(pm, sizeof(*pm));
> +
> +	memblock_add(start, end - start);
> +	memblock_reserve(start, end - start);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D3

