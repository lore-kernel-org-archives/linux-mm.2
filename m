Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93929C531E7
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 22:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48176B0088; Thu, 19 Feb 2026 17:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5BD6B0089; Thu, 19 Feb 2026 17:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9011F6B008A; Thu, 19 Feb 2026 17:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7DECE6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:46:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2803E14073B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:46:59 +0000 (UTC)
X-FDA: 84462692958.20.914DD33
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC4FF10000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:46:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771541217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NWJOhFc8ZWfGjk3eQ+uXyqYdr3CIP4cuSKl/DyEuGcA=;
	b=CoO+UclE4pyUOwp4OB0SUGsOZbpp3+IGYBfVJ0Cbx+sACOOWSqArf+zysQxXXi6MT4QvIc
	N1EGSKBu9tl0KKp5wUll+tbRaKkcL7/VFlrWaxRNfJG66pEp0n4PZY+NyS2E8NvbQ8wCeh
	wou9S5vD8hrhhCVazNKidwxKo0TyHFE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771541217; a=rsa-sha256;
	cv=none;
	b=ILqYkiFAZJ0MoAfnLS0iGeJQHoYNcP2y33RR13gu3+r7HzZljtpwCUz6NKoOEC7f6qHRHc
	J05dvpJbgjzKVbjidKR2TOxjDlBSvdON1mRor2O+c8UAbqnXjYUXz4RR00srKWeBag4pLg
	URdm03vkV80xxhEIA2lbOjJyQmN1BFE=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61JMkoFT619016;
	Thu, 19 Feb 2026 16:46:51 -0600
Message-ID: <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Fri, 20 Feb 2026 09:46:50 +1100
In-Reply-To: <aZbjCFqlqdFwKSHR@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
	 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
	 <aZbjCFqlqdFwKSHR@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC4FF10000A
X-Stat-Signature: 8wffp86nza6t8bgydxq5kfmpuyxk7drw
X-Rspam-User: 
X-HE-Tag: 1771541215-725896
X-HE-Meta: U2FsdGVkX1/dpvsVBOHvm+t/JxfoKxQO2OnB7wW6k1rRjo3YHs4MXj+tKMLdFKqy2hMDEVY6AovYcCAanz+LPtTZYwPTvAUFKwbcqw7RJd0dA5yQBgOuPPQh6mLOGn5uVsNjLCABBzQUZygFa+YUSz8hkeoHctdQRVD38aiPEvCDMKFkUxE8ILE5D63zALd1sEZ+dYkratx5Gwrm/LQkOCfnkwUUUuaK4L/zpfWFBjTEkbAisKHAOEMhHJpBZnFulxOXm9rLk/XIBnWeauunO/JfUI3WQj2U5KCVZO90afVvbz7fAO2x+YuWloqyerXR6NRwdZ9NkXh4mNQ9QNlA5ks9ieLwjHGU8SAgl5ynIeZjGYC43wZuzBBxtKBeH2lBeernQ8hMZzNAHiygp05jcis42VzJl4ob3onf3NQ9UL9SXkPAkkH+ktojvoGN13iUvpsmUEILfiDeq506C7o7RqO740sPRzkn/4MLM4fvQjNiOhd0zpLT6U6oszwkHVhVcoKTpYOjyUFN7vv1R51i3QekAAU689l5/2Tm+IfOT6Np1OZ2Xh1AXD+PTYPDnZHffPvb+tM1dM8v8MK1UgNpl2Cl8zondm+GFz9M/gKRyj1H3uIysaw+XtZvWKX7HqLv9LJCV2Dm79kQZ+xs4sBQsTyMpucEOwmDLR97hORoWFPZXX5wsekOBuGQRpIozVSfW8F5Lbx4zETphZfR+1BmKwOHW2gw2QSWUt436Sr8IPZ1XCZ+VCsAiqgDjI7uB1DrucBaqK2aS7TFnuweUSwgVVMeQhlnti8zb1d+SGvvVvxPjwtxZAXgmX19RgRtL2G6t0BAFBc6yb+NJExGT1Vs3wRnFN63UPEze6iV2QW7vG0IPaDD3of7M9pc28YkTtvHnCLdFsbD6G7gdp+/P4JCoyzsC8V3v8jsZoZTpKI5lphoEp4HPG5S154oHqR93yweCpiX2M3GJVx55IHqU6H
 2526CW5Z
 SKzuIlaU34aF0eKcVeW+V/aG+eSbWtO+5Ju7ZHN1naPeEZM/1FBEoiaiuHKU8RLYeebVZXaGYuhHNgk2NFTUR1/a8B9/Qd0yKZnRNNhcfit+5+igiDKyKZ6OCsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-19 at 12:16 +0200, Mike Rapoport wrote:
>=20
> Let's split it. EFI does weird things with memory already, like mremappin=
g
> normal memory for example.

Yup.

> Here's my take on the split. Lightly tested on qemu and recovered ~45M of
> ram with the OVMF version I have :)

Nice :-) I'll test this here.

> >=20
> +struct efi_freeable_range {
> +	u64 start;
> +	u64 end;
> +};
>=20

Haha, you went the blunt way :-) I was trying to avoid creating yet-
another structure with "start/end" :-)=20

> +
> +static struct efi_freeable_range *ranges_to_free;
> +
> =C2=A0void __init efi_free_boot_services(void)
> =C2=A0{

I was going to call it efi_unmap_boot_services() to avoid having two
things with almost the same name.

> =C2=A0	struct efi_memory_map_data data =3D { 0 };
> =C2=A0	efi_memory_desc_t *md;
> =C2=A0	int num_entries =3D 0;
> +	int idx =3D 0;
> =C2=A0	void *new, *new_md;
> =C2=A0
> =C2=A0	/* Keep all regions for /sys/kernel/debug/efi */
> =C2=A0	if (efi_enabled(EFI_DBG))
> =C2=A0		return;
> =C2=A0
> +	ranges_to_free =3D kzalloc(sizeof(*ranges_to_free) * efi.memmap.nr_map,
> +				 GFP_KERNEL);
> +	if (!ranges_to_free) {
> +		pr_err("Failed to allocate storage for freeable EFI regions\n");
> +		return;
> +	}

Do we still want to do the whole unmap dance in that case ? I mean, OOM
here means the system is pretty much a goner at that stage but ...

> =C2=A0	for_each_efi_memory_desc(md) {
> =C2=A0		unsigned long long start =3D md->phys_addr;
> =C2=A0		unsigned long long size =3D md->num_pages << EFI_PAGE_SHIFT;
> @@ -471,7 +486,15 @@ void __init efi_free_boot_services(void)
> =C2=A0			start =3D SZ_1M;
> =C2=A0		}
> =C2=A0
> -		memblock_free_late(start, size);
> +		/*
> +		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
> +		 * map are still not initialized and we can't reliably free
> +		 * memory here.
> +		 * Queue the ranges to free at a later point.
> +		 */
> +		ranges_to_free[idx].start =3D start;
> +		ranges_to_free[idx].end =3D start + size;
> +		idx++;

Do we want to make this conditional to CONFIG_DEFERRED_STRUCT_PAGE_INIT
or we don't care ?

> =C2=A0	}
> =C2=A0
> =C2=A0	if (!num_entries)
> @@ -512,6 +535,23 @@ void __init efi_free_boot_services(void)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> +static int __init efi_free_boot_services_memory(void)
> +{
> +	struct efi_freeable_range *range =3D ranges_to_free;
> +
> +	while (range->start) {
> +		void *start =3D phys_to_virt(range->start);
> +		void *end =3D phys_to_virt(range->end);
> +
> +		free_reserved_area(start, end, -1, NULL);

I assume here too the total_ram_page_inc stuff is taken care of ? I
haven't really looked. This feels like a fragile counter.

> +		range++;
> +	}
> +	kfree(ranges_to_free);
> +
> +	return 0;
> +}
> +late_initcall(efi_free_boot_services_memory);
> +
> =C2=A0/*
> =C2=A0 * A number of config table entries get remapped to virtual address=
es
> =C2=A0 * after entering EFI virtual mode. However, the kexec kernel requi=
res
>=20
> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> --=20
> 2.51.0
>=20
> =C2=A0
> > Cheers,
> > Ben.
> >=20
>=20


