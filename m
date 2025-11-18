Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3B1CEE351
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 20:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229666B00A6; Tue, 18 Nov 2025 15:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D92A6B00A8; Tue, 18 Nov 2025 15:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8D56B00A9; Tue, 18 Nov 2025 15:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB3276B00A6
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:36:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C2681A01B8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:36:39 +0000 (UTC)
X-FDA: 84124886118.08.3B9D6DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3BE7A0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:36:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OA/cnLrT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763498197; a=rsa-sha256;
	cv=none;
	b=mAq6iWvjSd3IYGinetobVsZC/Kyx0c4L/Q7oxMd3aGOGiR8xPfiTIW0yPPeUi4QssLmh18
	iWJm0YhceqijQE0vThknRhyV135kMN0MmTYt/BlpXQQ8PMms2ZIf5062771dCppHMpH45a
	Zoq6BgmXD3To9H+jX/K46RpvvuOKQV4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OA/cnLrT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763498197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8N7C6rB69q8FunmB9qwe0IeDVlVtRt9/bw30Wm+R2g=;
	b=WbgjOc58PZP4iqPxji5O1kPL3UhQTfPDkZgQ2i6cUwAh9RvtTI1cF3xe5LMS5Q0She6xHJ
	do60/onZP0y0OU/c7Q8YpIaaN/eAvhJfwGYj06d0uziTI2eOsf9seYdjZdqbRXiH5WPiQ1
	AOOs/L90OdZurFWTEK+Xa8y34AdbfTg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A4B7601B0;
	Tue, 18 Nov 2025 20:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A977CC19423;
	Tue, 18 Nov 2025 20:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763498196;
	bh=h+3BwWhhIvXtH6CqYR0CGMuK8HiVDCd7iIzIP1+nrQ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OA/cnLrThWTLOpG3iebN2/Maw8mLicbQREvhvWlciL5iL9KlyIZmjvRiHJeDwx14v
	 6/77qdoTVyYvAAFyVpuPLFaNAFFWAxjc3ZhGWQANKGOffN4Emf8T6QiMV/Wr13n8Br
	 PhjOTUh+UGpbcIGIrs3cQ9m37KmfyIw/AH0akSjhnOpfZ1lCpRzWBMfAOND1fkBusG
	 MwMvM0qKnV2toUXlBIayW4KlQ6esfqJqDVxg257CWMfLd2aF/2zDrfnED3sT/3T4VW
	 rPSOZeyx2qrQQ+vyziYw8DQ+MG+P4u9Opwp2Hfnlap23UCFx9/5ODXA6ye9d8osoCb
	 zzYB42uDNvYeQ==
Message-ID: <5e864bfe-6817-4ec5-819f-9648a23abfa3@kernel.org>
Date: Tue, 18 Nov 2025 21:36:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/huge_memory: introduce folio_split_unmapped
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
References: <20251115084041.3914728-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251115084041.3914728-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3BE7A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: yqfya7o3e488j4mht77r9q8bezac8j4i
X-Rspam-User: 
X-HE-Tag: 1763498197-364198
X-HE-Meta: U2FsdGVkX19T48aXHCtMnQbl1I4Jctq0af8oiC89GD0RCRBSKL0x3YsEyqA94VpKt01kFsGj2snssj4k+AHCz1F986dq8PBWtBkbcYbtwFkr82BdvuOVpY4tUnY8l27gBY1v0kf385efy9rzDw0zxUGKlH9+kJHFTaQ2lxzv2NdYlFXv59ubYChqsgPabVhGuRqPrzeddhMPnWZo5grcdoXkluXo23WH3Lsyf2zm5Sebmgfr7X0a2RH+ldrnX4uLMA9UihmdxXKdQcQmgzusWJI9MNiQlC3jcDzkWWCgz5UULwXVj7/PbYKTAlE6P6JVbImiBAjgG7Bp2OwB5nxlCArpkYVR6Ycj68pmhaB31+h76+hEbohojW1KwFXRjcGkkCtJD4hyWG6X0dLX82ewHceMCcbQx03ngynXhlzbRb1k27/79W0bHBfqKl6dASBjfC8E4R5/03NyjtO82bZS4CMQOMTzY9plIjILWrur6Xoq9HJeLTx6WcMj6NDS6VpWfjFyhp1y/HNZP4gVMAILy/Zu671tSivCK8F/oefe8Owx9LR287E0XoT0bWFXiNHGIlShmkdsH/eeGbqpvbfJ3vp6qDxoy1D1BV+RNnnclNs2zswwPjXHPH9HEw8JdHM4sdYAdiuI1k4OF4J5zAr/e6VpPr3UrXIBLv/i6GSISU8Q3p1oP1ARe/Me40UmCSO5eup0X92dptbQZzeqJcJrY7PAA/w5GMebWNrIR7qCGM8NHJSMp27YQKfrDfjZ9MnCyW/6LqRIZLlaDoY7U4AboeooGhdurpp8yttvnWU3961NhqbTP5UKC3v/iq9eDVXg/sQaa78HgOK2k7MSOYvKdppGUZkTWSQBhQLe1WY471btRcl6VW8DQCPgD6hRaCm1bpaqOvGD+jctfxyhgsRtnj8IkWiy9a5x4VPA7+S1QhTCn0qTj8nld/BKZW++prtFP5/XzOCykc4DS/fofW1
 elTFvB38
 F7lQd+1JFRTxDXvOPc5NXwENpUqO8TyW7aZ/6xuqXV+D/V1a6gRfM+wcgMQXkEe/g++QJv8xHC9LYu2Hxt8+K8yMQfZtSQWccjXSlS0S9c7zwuN1FAbzB1T5RnCOCPcPbK7d04kbNJPgZayaeM2M8ecVISFt6yUltOG20NUlBzApZ/P0dlNVIAhd3r+Cw5zuhfU177TMLkkRvojQCdU01QhqCLnvS/z4r2xReSyZ6OGNcYYAQKGkJDhvoldMFpKsY2jdPW6XIaUHXRg9aZpJvANO79BuHDTYY/MNI9A31KtW8LL6+sI/4PkVL4lWsO5fcEu6zRu7Og7uXEXBIf8BgMXpO9cBPzLDkiF4cK7H+c7wehzEylWN1v6/shA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.11.25 09:40, Balbir Singh wrote:
> Unmapped was added as a parameter to __folio_split() and related
> call sites to support splitting of folios already in the midst
> of a migration. This special case arose for device private folio
> migration since during migration there could be a disconnect between
> source and destination on the folio size.
> 
> Introduce folio_split_unmapped() to handle this special case. Also
> refactor code and add __folio_freeze_and_split_unmapped() helper that
> is common to both __folio_split() and folio_split_unmapped().
> 
> This in turn removes the special casing introduced by the unmapped
> parameter in __folio_split().
> 

I was briefly wondering: why can't we just detect at the beginning of 
the __folio_split() that the folio is unmapped (!folio_mapped()) and 
then continue assuming the folio is unmapped?

The folio is locked, so it shouldn't just become mapped again.

But then I looked into the details and figured that we will also not try 
to remap (replace migration entries) and focus on anon folios only.

I think we really have to document this properly. See below.

[...]

> +/*

Can we have proper kerneldoc?

> + * This function is a helper for splitting folios that have already been unmapped.
> + * The use case is that the device or the CPU can refuse to migrate THP pages in
> + * the middle of migration, due to allocation issues on either side
> + *
> + * The high level code is copied from __folio_split, since the pages are anonymous
> + * and are already isolated from the LRU, the code has been simplified to not
> + * burden __folio_split with unmapped sprinkled into the code.

Please drop the history of how this code was obtained :) Focus on 
ducmenting what the function does, what it expects from the caller, and 
what the result of the operation will be.

> + *
> + * None of the split folios are unlocked


Looking into the details, I think this function also does not

(a) remap the folio

(b) call things like free_folio_and_swap_cache()

Which locks do have to be held by the caller? I'd assume the anon vma 
lock and the folio lock?

Would this function currently work for anon folios that are in the 
swapcache?

And I assume this function works for ZONE_DEVICE and !ZONE_DEVICE?


Please carefully document all that (locks held, folio isolated, folio 
unmapped, will not remap the folio, anon folios only, etc).

> + */
> +int folio_split_unmapped(struct folio *folio, unsigned int new_order)
> +{
> +	int extra_pins, ret = 0;
> +
> +	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
> +
> +	if (!can_split_folio(folio, 1, &extra_pins))
> +		return -EAGAIN;
> +
> +	local_irq_disable();
> +	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
> +						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
> +						0, NULL, extra_pins);
> +	local_irq_enable();
> +	return ret;
> +}
> +
>   /*
>    * This function splits a large folio into smaller folios of order @new_order.
>    * @page can point to any page of the large folio to split. The split operation
> @@ -4127,12 +4171,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>    * with the folio. Splitting to order 0 is compatible with all folios.
>    */
>   int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> -				     unsigned int new_order, bool unmapped)
> +				     unsigned int new_order)
>   {
>   	struct folio *folio = page_folio(page);
>   
>   	return __folio_split(folio, new_order, &folio->page, page, list,
> -			     SPLIT_TYPE_UNIFORM, unmapped);
> +			     SPLIT_TYPE_UNIFORM);
>   }
>   
>   /**
> @@ -4163,7 +4207,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
>   		struct page *split_at, struct list_head *list)
>   {
>   	return __folio_split(folio, new_order, split_at, &folio->page, list,
> -			     SPLIT_TYPE_NON_UNIFORM, false);
> +			     SPLIT_TYPE_NON_UNIFORM);
>   }
>   
>   int min_order_for_split(struct folio *folio)
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 46dd68cfc503..05ce95f43ab9 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -909,8 +909,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>   
>   	folio_get(folio);
>   	split_huge_pmd_address(migrate->vma, addr, true);
> -	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
> -							0, true);
> +	ret = folio_split_unmapped(folio, 0);
>   	if (ret)
>   		return ret;
>   	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;

This is clearly a win.

-- 
Cheers

David

