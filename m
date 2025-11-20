Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09714CF8564
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B456B002E; Thu, 20 Nov 2025 04:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6729C6B0030; Thu, 20 Nov 2025 04:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFE16B0031; Thu, 20 Nov 2025 04:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5666B002E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:09:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0159D89EC3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:09:23 +0000 (UTC)
X-FDA: 84130411848.05.6EFB3B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 35BDA180008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:09:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YFgfR4YE;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763629762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/7CCZ/XXGZeGECETGBByZpbkxlbNb6ypmeffAlwowQ=;
	b=X2nX4ayVtP9zGbxYisdfTP1ePFZX1bVHDgDWiZnBIPVKOxyzhp6vydyeJ9FzzIJmbxTlgH
	AY6i2CDogQEyy5sZmnZ/fy0R0R1yexRJCLTLTpnNx5ZscabeyuSUTOsUjTG50pruyW1CHf
	4mFPqvJdnecT9PCHO+l7nYnj6j0CAvU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YFgfR4YE;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763629762; a=rsa-sha256;
	cv=none;
	b=Wv/n37rH0cbs5n6mxDgLvA34uFJMUjPoJE2kDkgwjf2H4UmJFBMGBu0Mgl5YURjNIAlNZ7
	BgMY9KzvzLFBqSt/NVfaJm+KYpBbXjjcs0aEOlBy9P0coo7o3+8M4ESifsazhSq9WOsVTv
	aw2GkYOYg5bK7wLEFijKu0J39BFTykk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F328743A99;
	Thu, 20 Nov 2025 09:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71202C116B1;
	Thu, 20 Nov 2025 09:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763629760;
	bh=3LRBNuFqcIWNv6+llg0BKBD85RcO8c2uV+3xfhb2i7E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YFgfR4YEhqqRgIYW5R3th1AbIc7N4bMKYuIyuo1OQ6cSObvbe8AQcGnngD39IwZdr
	 ++v65KV1XOH9vDz4/dcQ/BPGftq92Q1iHqergUHm66NR3WzzIuWKPJyau97h29YT5z
	 N981+SHwilrL7xh8KcpDzkcM2lHZ+HWwnz9Jcp9KTn9Cqas7AKLACuhs/W3IXUeS/t
	 ji75XIawgZATeYoXZVyT3RP4lmzWOyx8moZ0jZRxAKY+Dcuwj+9F25LTDd/uQ6k+Mu
	 r63xXelNelaLHfk+75Fl8thTejwKggktdAEU3rQ/gXWAA4ygAbM/UeaREjq/g1fj0V
	 yNyTSc7Ygu6RQ==
Message-ID: <4b87bd52-5582-4599-8a97-38843e27d0a7@kernel.org>
Date: Thu, 20 Nov 2025 10:09:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fixup: mm/huge_memory.c: introduce folio_split_unmapped
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251120030709.2933665-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120030709.2933665-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35BDA180008
X-Stat-Signature: r8qzrw7guo5kp88sjuuqx7736br8akq1
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763629761-62108
X-HE-Meta: U2FsdGVkX1/IfVX/M140xz3b+eewxxfy2RJdxiKCLgcXiFVQdewOgPSdwz3eilAf57/I02jMKvctQDuvOfJGlWQ7XYLVK2GcnbX5x+fZaBy9gSTNSko8WHxSUMRkht0bP5fQuMmCawjrhaiFUfil/sq74eFbWvBztD3DrvA+vPPhrISgOCBLqTALOm98WNv4/5Jf6ox2l2kJ6ptZ5T09cLiA7vTTshlgCoGziVvRLQimEQEk0s3GN214pQJioEuvAfowqTvVqnFanay+UIeI0/5LEehVcs2vtbMDuJKUrbnKD8NoEcGAnrTZbWStgDK1m7BtcKKdzlCnmr1dnBA6yKyWqQyYc5HBZ39y4zTrFLeT0uYD9ESBoq8VE+5sgRHX7bTByJm6bADxJbVefD7YjQhvA+kQCtnLMBT7f6oegEngpIR3fWXfXviQUCJXVuABXb8p8+hn0CnvynxcN1ciQ7gZtCM0/STXivSduDirdf0aT0pas3WSzu7XuojZU2P1TCjNZlWq3fLg5Hjf5cL9Kz9QGjTn/GSx2wfdiGGjuL2v9O//sYVAKae+CbtivLvrsVtj6JG8yhTOqfUxKMdN70b2CFif+RrnMQdDKov8iEEesRZr8zf4ArmN755UF4/xziHIzQHIoScYRa07w30YYAxNJwZ18plQ3HpSXZhE0LwIbFxWnUxX8VPwb3vBdN0sh/GZ/hxIi98vreVTbrIKTpt40yvQvHBtbDWYejQoxa6GD0KaCyWfbifxrus0AY5RVksgvau3j+apvjhWkFsVOi6VZuNiwSIwiNr9JSt7REq62ztyh5Kf9e8Gyg8UB1ahiApzJAvF0YjCiNmsrIeCBqJ8np9WK0y3MMOuu8dPdNkJcYhkXU6TwzUjYCwsPOvoNotlvx0tBmGakSynuvbtjXCadKVK4HI7Yf+dU4C+9DzAAxatJGh+8RhiEEVTU4WJCgOQNQo1tUFxVMo8CrB
 TS1Jde+m
 h2AaLYjpSZLApqF1DZQA+tHqNU/Jnrdni7RmWktJAUrDnh4qcJkYHAYUK45CwNGdQtZybTS0ib6lolAvbTB+Gt2AabkCNGTcrW03vusz/jUbSeYOjRpBywva7IUQbMsVBiVasPpRy25LPtou1G7B/h6WGT7M2Fm60us2NGI8HR9MjV72PI0mvMpmfVhTh98CB2RyDh/HjNg7VT75XfcdUmxs9GXiiCshKQ/d15W8blPyP1zAEUNZcGx2QhiwhM3AGrTOnfVckBie61B/lluYJMrgOoMHyC6GvI+33Vguc7u3I2ViDD3Nm/mLJ5GYA1yilYV1VSS5EDcuHG6TaTQablna05LW0LmldM4Qv4O3r5B99KgEOWgfmpqNIM0njRu0nDO9hqUcwlaIQsE+v/WzJEp67xtWfV2IAMlUghFqT8z1pYc7rLtcBsE//pRPy22RUH6QPsvrPXKHBcj3sSgANl6me0mS5nbCeD/hIeUNhdcaWuTP7ynHq1CowSs7otSS8L0hE4aBSv0vyNenEQB+TOJYaHKPvG1mTzAyysoPEnsMDN2YMuXGRO+7fywCEi00pCwDKJgq03X3Ulb8VfE1W67n9E1TbKQIDMulOrsWt/AyzqzKItbokUWDQCxD53a9nLuBDrOtM1foIJ0xNTuwVYnejvTPUu8jgLsZ+6BBrAwDUulVvx/pwT7sTqnbGNPrQCYpXo84R5Gf5QnZolsVCb5nC8M53A8XzM/6cDKvhLAf1po0RIW0wxbwBXyPSbz9b05A8bjyWzqYe7agP+KUsY7QR4nAEoKYEPG95qxvjYIf9ST0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 04:07, Balbir Singh wrote:
> Code refactoring of __folio_split() via helper
> __folio_freeze_and_split_unmapped() caused a regression with clang-20
> with CONFIG_SHMEM=n, the compiler was not able to optimize away the
> call to shmem_uncharge() due to changes in nr_shmem_dropped.
> Fix this by checking for shmem_mapping() prior to calling
> shmem_uncharge(), shmem_mapping() returns false when CONFIG_SHMEM=n.
> 
> smatch also complained about parameter end being used without
> initialization, which is a false positive, but keep the tool happy
> by sending in initialized parameters. end is initialized to 0.
> 
> Add detailed documentation comments for folio_split_unmapped()
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>   mm/huge_memory.c | 32 ++++++++++++++++++++++----------
>   1 file changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 78a31a476ad3..c4267a0f74df 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3751,6 +3751,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>   	int ret = 0;
>   	struct deferred_split *ds_queue;
>   
> +	VM_WARN_ON_ONCE(!mapping && end != 0);

You could drop the "!= 0"

>   	/* Prevent deferred_split_scan() touching ->_refcount */
>   	ds_queue = folio_split_queue_lock(folio);
>   	if (folio_ref_freeze(folio, 1 + extra_pins)) {
> @@ -3919,7 +3920,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   	int nr_shmem_dropped = 0;
>   	int remap_flags = 0;
>   	int extra_pins, ret;
> -	pgoff_t end;
> +	pgoff_t end = 0;
>   	bool is_hzp;
>   
>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> @@ -4049,7 +4050,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   
>   	local_irq_enable();
>   
> -	if (nr_shmem_dropped)
> +	if (mapping && shmem_mapping(mapping) && nr_shmem_dropped)
>   		shmem_uncharge(mapping->host, nr_shmem_dropped);

That looks questionable. We shouldn't add runtime check to handle 
buildtime things.

Likely what you want is instead

if (IS_ENABLED(CONFIG_SHMEM) && nr_shmem_dropped)
	shmem_uncharge()

>   
>   	if (!ret && is_anon && !folio_is_device_private(folio))
> @@ -4092,16 +4093,27 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   	return ret;
>   }
>   
> -/*
> - * This function is a helper for splitting folios that have already been unmapped.
> - * The use case is that the device or the CPU can refuse to migrate THP pages in
> - * the middle of migration, due to allocation issues on either side
> +/**
> + * folio_split_unmapped() - split a large anon folio that is already unmapped
> + * @folio: folio to split
> + * @new_order: the order of folios after split
> + *
> + * This function is a helper for splitting folios that have already been
> + * unmapped. The use case is that the device or the CPU can refuse to migrate
> + * THP pages in the middle of migration, due to allocation issues on either
> + * side.
> + *
> + * anon_vma_lock is not required to be held, mmap_read_lock() or
> + * mmap_write_lock() should be held. @folio is expected to be locked by the
> + * caller. device-private and non device-private folios are supported along
> + * with folios that are in the swapcache. @folio should also be unmapped and
> + * isolated from LRU (if applicable)
>    *
> - * The high level code is copied from __folio_split, since the pages are anonymous
> - * and are already isolated from the LRU, the code has been simplified to not
> - * burden __folio_split with unmapped sprinkled into the code.
> + * Upon return, the folio is not remapped, split folios are not added to LRU,
> + * free_folio_and_swap_cache() is not called, and new folios remain locked.
>    *
> - * None of the split folios are unlocked
> + * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
> + *         insufficient reference count or extra pins).

Sounds much better to me, thanks.

-- 
Cheers

David

