Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B542606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SqVkgSqH
Received: by kanga.kvack.org (Postfix)
	id 6BD126B05B6; Sat, 14 Nov 2026 06:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E636B05B7; Sat, 14 Nov 2026 06:33:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584506B05B8; Sat, 14 Nov 2026 06:33:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 393816B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:33:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC89340392
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:33:54 +0000 (UTC)
X-FDA: 85433515188.23.F83CECE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 25F44180002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:33:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqVkgSqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794656033;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOohzSTuBgrSfk0jf37SnktRbQ4WRgnCUv6nrKxrSi4=;
	b=iVuR8PvmoiGdzMWBScCLRHzErC8RUQELPCHytnlglbOgvqdBki0FqbQjlOUKsx83vlL7Yc
	0wkEvB1dvdBy6F1izjDCwPjlgP2IgW79p8y3alHlwoSZRorKPUEDH9f19zKFx4rfbWnRDl
	8Rx5wYMw7ufGEn7jeZ8q1ofEoNfDZKI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqVkgSqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794656033;
	b=7S/oqFm3xPWgIktKBXJsrnWvMoC8ihP5IslXpbvkaeOzl0j1+cCQADxcg1AE95D58Iw1Cm
	bYnDvIfrQqZ3+OjaZciGrpJ+hY8xa9oqmIKKjSiKyQWY87Ls1/MvoXk2oKgtOfiFZ7h2Kn
	xQSdlXaN1wofDYil98RTd+KMAXDheKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB03260E22;
	Sat, 14 Nov 2026 11:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51111F000CF;
	Sat, 14 Nov 2026 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794656032;
	bh=JOohzSTuBgrSfk0jf37SnktRbQ4WRgnCUv6nrKxrSi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SqVkgSqHCr+86lKgqZHxDXqljji8NEnM9TBsv95upQudlE4cf/gCMtfwBdiQSe9lG
	 GAaQgDdsrQjHcVQjQk57Z7CrTKCTI0m9y92zJMhiRkkpzKj8jzFIBdyYPbIIfQh06/
	 Z4k7rpfD/0joKsbQgWG+88j+ydNSyEcu1NbGGg8mBdzYS5WJhu5e0KYkvjXhfqSoDS
	 Z+cYoLk8jMH8nbD5QYmyo6d6i7WwGiZaEWuhtBc6k53EGcEn3it3yyHxPzu8i7dqBc
	 oD0krgmQBSRNmM72Tne0gRBNi2K/gxAPlHQMPgB/NwmaTi6dw4BU30WIGVOreYxlAO
	 z9cu0itUO3O9A==
Message-ID: <sashiko-outbox-214406@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] x86/unaccepted_memory: Do not accept ranges that are
 no longer E820 RAM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pankaj Gupta" <pankaj.gupta@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Kiryl Shutsemau" <kas@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Mike Rapoport" <rppt@kernel.org>, linux-mm@kvack.org, linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com
In-Reply-To: <20261113105554.199912-1-pankaj.gupta@amd.com>
References: <20261113105554.199912-1-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 11:33:51 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 25F44180002
X-Stat-Signature: 9drm5w63mandhgx4w7yoaem1yssm49jt
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794656033-548593
X-HE-Meta: U2FsdGVkX19TQBbihzQ8ON263N+dmg4F5tpvBuWNiMPG8DJWC0gZPHduB5tQu68YjazWfdhzezLa9Z2/pRFz9t+j6WKE4O4i9krMDqDi6z3NmAXLtPDNepJVq+phy4n9yIXPSbc0ZIYwY4tpSAR97qi+vcNOa48VogmKf7OGZS+gLFG5qkopVKWMmoxb8jgsaMKXWExz+eYMcbZDp2SBHxK2rEpXbBKidataIGXgLHQtxGaCUH/TvS7pDf3xlXSa05nNLfW1UeI5W8pdbQM6hY+X+1KWabqhsQStuiCoL2aPKObua/u9cMxWCQSOYCQhHaLvKdvcxiXOVZac0V4XP+DCMmPGjduZqlYEsR0obz2Wmia72mJUPSbPXJ+iIYP4Vt3uEvXCMMW3PAUubgazp9rKwa9jM014kKAtGHP5lG2nmth/BP6LnA82CqLCmbQf13CQXtUJF4BOmLvZrwqkAwfnBMvGX5wbTLq1f39RHy8rntFIKDzm4/imFhp7/DWfyhxSuAyl4WXu7S3nK5/QNLxG55TTAidr1R7SZuxX639qK9diWJut8MHECm8zqbdnud9z+FqlSASeeeYDaq/NB7p1kdXA2/F68sO0adfhoR7F/B9mtixu06hMp97Zc92c+iKNIHfRJtcxioyKMzp8FjCQLASa883MpTwMa9KuQiT7hCIyoi17vK3qQ0Xao7MFMdYU9CQ4V/fv8zidCAwqNolq6DBCtLBOQFUf+1SjOYcF2F8u97gKFKnz/7N7lvOAo3BS3OJKSAC7mQwy2HvO+rtV3s7qXY3fmmou2Kg72LRC/MNSVUhjQwriZ846yJ5o6M5E8Cpsy0G9ZaEcaNcYmmAJB/Trn/uIi8mwTf9d0iZty976V0ZmMQkYWXlvoBHawJCkHN7juKDfKh4mz/bPx9LGKWWQ2082N5XXUWmr3gzfNlA6pYTNMqT0FQzbbUV+kQICjfmz+/bfhCjjZpQ
 6GgMi8u3
 E+eAHvoxrN7sMi/uUCrBlYwxJUiui+Oqpv5wMO+3crYZBjxnDubvj4S/v3E8mHgr02YmTR7B3QaiJsr7ZPcL1FoFHxNktEmAP5SNAjhQruOil6Bcd4obUKhN3N4oBRhW9pXvvXWlX9A3mO8Py4YCxkCsp+EG0GJv3qeJd8H7uiezxGFwPfW0lHbKHIh+DXb7iJnHYrD2gq07NmjR9QZiahJg7ZzfjeQLiCC2FA+Ou0dVu4NxIhp0kJCuYxFYkhRvACpB+9ehCFMpVjEM1kOCNgKz+qJglx11+GrTc7JvnMlTOykM5JDTBacqQNlbzmNrShpoiceta61TTkFgAGuFc21yw735XIqil1LCEHIS5diLDPEIHSKtXKLeSAbF/pDo+DMAdEVz/m2Y9nmbTfSrYVPOLI8lelVWAhTCG+2Bk/88hTV1bMEz9FqzSkiLZMI/ZAnnMLQCJo1XjGDvvXFPX1uZ8Mwg7powelA4QXR872aIU3DRO6bXJ+6qQQglOx3X1d+EI19XZqIESsJe667Uv0WOoBACi7NiUES0cn5e4M9rXvGQ4A2F8uNh9vgooWNTt67HVF3tjc1lTTkD+NSLiIx6Ne0nLvuTdukDtPhjU1bYWKttl5dWB5FiH7J1/y6yg7WprE9OzvVdVfrpP/K/JVZHUzSIaVhyD1bP/qjMABDd7safmKxnF5Lh598Q2H0dIZ11+Tk+cpx/tDYfvkhLwvjlB0U895vSxbc+/GxS28SGXCDihgVaHGPxliOyH6IA0lVKouebx3DK9ar0=
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
- [Medium] x86/unaccepted_memory: uncleared hole bits in
  arch_clear_accepted()
- [Medium] x86/unaccepted_memory: outward unit rounding in
  arch_clear_accepted()
--

commit ddcd20a91b6aa10c63b863069cf031e61f95c5fc
Author: Pankaj Gupta <pankaj.gupta@amd.com>

x86/unaccepted_memory: Do not accept ranges that are no longer E820 RAM

This commit restricts x86 memory acceptance to page-aligned E820_TYPE_RAM
ranges and updates accept_memory() to clear bitmap bits via
arch_clear_accepted() only for ranges that were accepted.

> diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/=
asm/unaccepted_memory.h
> index f5937e9866ac1..9e27a9953dd83 100644
> --- a/arch/x86/include/asm/unaccepted_memory.h
> +++ b/arch/x86/include/asm/unaccepted_memory.h
> @@ -2,10 +2,11 @@
>  #define _ASM_X86_UNACCEPTED_MEMORY_H
> =20
>  #include <linux/efi.h>
> +#include <asm/e820/api.h>
>  #include <asm/tdx.h>
>  #include <asm/sev.h>
> =20
> -static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
> +static inline void __arch_accept_memory(phys_addr_t start, phys_addr_t e=
nd)
>  {
>  	/* Platform-specific memory-acceptance call goes here */
>  	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
> @@ -18,6 +19,47 @@ static inline void arch_accept_memory(phys_addr_t star=
t, phys_addr_t end)
>  	}
>  }
> =20
> +static inline bool e820_ram_pages(struct e820_entry *entry, phys_addr_t =
start,
> +				  phys_addr_t end, phys_addr_t *s, phys_addr_t *e)
> +{
> +	if (entry->type !=3D E820_TYPE_RAM)
> +		return false;
> +
> +	*s =3D PAGE_ALIGN(max_t(phys_addr_t, start, entry->addr));
> +	*e =3D PAGE_ALIGN_DOWN(min_t(phys_addr_t, end, entry->addr + entry->siz=
e));
> +	return *s < *e;
> +}
> +
> +static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
> +{
> +	phys_addr_t s, e;
> +	u32 i;
> +
> +	for (i =3D 0; i < e820_table->nr_entries; i++) {
> +		if (e820_ram_pages(&e820_table->entries[i], start, end, &s, &e))
> +			__arch_accept_memory(s, e);
> +	}
> +}
> +
> +static inline void arch_clear_accepted(unsigned long *bitmap, phys_addr_=
t base,
> +				       unsigned long unit_size,
> +				       phys_addr_t start, phys_addr_t end)
> +{
> +	phys_addr_t s, e;
> +	u32 i;
> +
> +	for (i =3D 0; i < e820_table->nr_entries; i++) {
> +		unsigned long first, last;
> +
> +		if (!e820_ram_pages(&e820_table->entries[i], start, end, &s, &e))
> +			continue;
> +
> +		first =3D (s - base) / unit_size;
> +		last =3D DIV_ROUND_UP(e - base, unit_size);
> +		bitmap_clear(bitmap, first, last - first);
> +	}
> +}

[Severity: Medium]
Does rounding first down and last up to unit_size boundaries clear the
bitmap bit for an entire 2 MiB unit even when only part of that unit was
accepted?

When a memmap=3D reservation or mem=3D limit is smaller than unit_size (2 M=
iB)
or not aligned to it, arch_accept_memory() only accepts the [s, e)
E820_TYPE_RAM sub-range within that unit and leaves the remaining pages of
the unit unaccepted in hardware.  Because first is rounded down via
(s - base) / unit_size and last is rounded up via
DIV_ROUND_UP(e - base, unit_size), arch_clear_accepted() clears the unit's
bit in unaccepted->bitmap anyway.  If a new kernel is later booted via
kexec (which reuses the EFI unaccepted memory table alongside the
pre-cmdline e820_table_kexec map), it sees the whole 2 MiB unit as
E820_TYPE_RAM with its unaccepted bit already cleared and faults when
accessing the unaccepted pages.

[ ... ]

> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/=
efi/unaccepted_memory.c
> index 4a8ec8d6a571e..b8a0c0d1d2891 100644
> --- a/drivers/firmware/efi/unaccepted_memory.c
> +++ b/drivers/firmware/efi/unaccepted_memory.c
> @@ -130,7 +130,6 @@ void accept_memory(phys_addr_t start, unsigned long s=
ize)
>  	for_each_set_bitrange_from(range_start, range_end, unaccepted->bitmap,
>  				   range.end) {
>  		unsigned long phys_start, phys_end;
> -		unsigned long len =3D range_end - range_start;
> =20
>  		phys_start =3D range_start * unit_size + unaccepted->phys_base;
>  		phys_end =3D range_end * unit_size + unaccepted->phys_base;
> @@ -150,7 +149,8 @@ void accept_memory(phys_addr_t start, unsigned long s=
ize)
>  		arch_accept_memory(phys_start, phys_end);
> =20
>  		spin_lock(&unaccepted_memory_lock);
> -		bitmap_clear(unaccepted->bitmap, range_start, len);
> +		arch_clear_accepted(unaccepted->bitmap, unaccepted->phys_base,
> +				    unit_size, phys_start, phys_end);
>  	}

[Severity: Medium]
If a unit_size-aligned hole such as memmap=3D2M$0x1ffe00000 leaves its bit =
set
in unaccepted->bitmap, doesn't range_contains_unaccepted_memory() permanent=
ly
report the accepted RAM range immediately preceding the hole as unaccepted?

Both accept_memory() and range_contains_unaccepted_memory() extend any
unit_size-aligned end address by one extra unit_size to cover
load_unaligned_zeropad() across the boundary:

drivers/firmware/efi/unaccepted_memory.c:range_contains_unaccepted_memory()=
 {
	...
	if (!(end % unit_size))
		end +=3D unit_size;
	...
	while (start < end) {
		if (test_bit(start / unit_size, unaccepted->bitmap)) {
			ret =3D true;
			break;
		}

		start +=3D unit_size;
	}
}

When the valid RAM before the hole is accepted, accept_memory() extends
phys_end into the hole, but arch_clear_accepted() leaves the hole's bitmap
bit set to 1 because it contains no E820_TYPE_RAM.  After that, calling
pfn_is_unaccepted_memory() on the valid, already-accepted 4 KiB RAM page
immediately below the hole (for example PFN 0x1ffdff before 0x1ffe00000)
has end aligned to unit_size, so range_contains_unaccepted_memory() steps
into the hole's unit, sees the set bit, and always returns true.  As a
result, read_kcore_iter() zero-fills that valid RAM page in /proc/kcore,
unaccepted_memory_vmcore_pfn_is_ram() omits it from /proc/vmcore, and page
freeing paths repeatedly call accept_memory() on ranges ending at the hole
boundary.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113105554.1999=
12-1-pankaj.gupta@amd.com?part=3D1

