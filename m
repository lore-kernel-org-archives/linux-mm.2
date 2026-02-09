Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EBAE81BDC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78FB6B0089; Mon,  9 Feb 2026 11:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D508F6B008A; Mon,  9 Feb 2026 11:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FD36B0092; Mon,  9 Feb 2026 11:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B10196B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:01:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 581D81A01CC
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:01:12 +0000 (UTC)
X-FDA: 84425382384.01.483B9DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36144180020
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:01:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jbbzMACV;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770652870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uRiDOWZ3sVeWfXXlxUFibKmPf8Lk/ejUz5ZPmaLFj8=;
	b=MAReNPcYYA6YFAD0Qry4JgPousQY3j/QoLSPPGf0ifxsoARInzpIxY2IDX2A5N2tggaok4
	Kvtv0taBKPh/0o3gGKE3IXw9TZdfOzzhMrsEgKxAZWCpOmKaCOxOmJ0YdqZOEzQbynIJAk
	ycloW4p5GiL0JB9O6FLEFrQ76aSHukg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jbbzMACV;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770652870; a=rsa-sha256;
	cv=none;
	b=1rwMb0qPTCdkGTPqvi7/wEtUUcEjZYBCY7ffBKGlO6neWoqzCpD86iTj5stn8POWXpNO9B
	mXZDjvbyZhYz0Zasplpu4XyGbrMHth5qs/M+8AtR/gmX2Q9LDUMlvhUJLqYuVPJw8tTs0R
	xdXWsC2T257vWx+34m2lMR4TMTTY/TI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 264CB405A3;
	Mon,  9 Feb 2026 16:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15987C116C6;
	Mon,  9 Feb 2026 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770652869;
	bh=DeCQWTbVo27s9msB334lUp7jD2Hs0FC3zBs7qbX4DIE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jbbzMACVn99lMmRtfHxd8dRIY/LAYmUKv2EJEsS4iMgpb0sGFq10tw4uQQIgwE2xh
	 FvkZvSNwSckvuCTm/4sHtWBfH1WJy1Wc4RwEg7JubwkjzZOb0sqPWPzDcXHQm6ZYN8
	 QbMUA+1u3hCZrYwnFPxCxfMqSL15rWtHogHjEMujqcfAkMrKv2QU0iQflTu075VtTG
	 e6jTmNFIWyVyN8BBPGnFiWawAyJETEkPZeSWplnQLfWRtxDOf9gk2xKUIDLjwumeaB
	 4FjTg1hZ1eShOOpIXdM5kE5e6fk166lF42LoYPkrrcW9Zcw5MDxJt72wMhsoAcfnPm
	 bcLsjUKXcHAlA==
Message-ID: <e73bdf49-0a6e-4e82-9727-3a241fa9722c@kernel.org>
Date: Mon, 9 Feb 2026 17:00:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 11/16] mm/migrate_device: add THP splitting during migration
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, Zi Yan <ziy@nvidia.com>,
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
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-12-balbirs@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001065707.920170-12-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36144180020
X-Stat-Signature: 1ypd3747zhwcnoh4s9nehxr8dhqn7ogz
X-Rspam-User: 
X-HE-Tag: 1770652870-279985
X-HE-Meta: U2FsdGVkX1/POdol4vMrhOxsP2w+xh/6lLmKDFIwWjwj56gO4R0HcYIIL20ZK8zkehuiZf4PFDszfKF/OZ3fOxXEYPNY1qLnJtBJj55zHeN2MWcDFbXCyUJlODEqZH167+zx62yrCYTeOF5D6Ypk2Z9DuvZOt/q/Lt8STxSHrkWMAGwRKiDm9/nJkoaIn4ojDdKLrSN8BwnqwrFc9cBJkFJDhhY+bxb95tjHlN6TAQANvvj6uUBo5YSVgCk2Bh46yMHDJ1JFuvGGtX6ezPxfR427YxqNPqN5BF3Kd3xkoaEq51etOVMCzCxab2vWcDrxfnN1yM0UjEMjvjwapmpH4NRe0wIJeYUf6aRsEDDS3Uy6iPpx6OCa7LelVvhngIm7ata+bjCTZOWCCHkY/Qx32CquMn/LRzUTxypMThmFc9XTB3YeZeyCalcj+v6M9AzGkmBHC37dFbFU44F+7+rqRMLX1wMBCXR1dsoWX9m6KPFgpRrZbVksh0tCjtfRiqAVdQ/3FfNTg+EvNSXmYRZ8cxpJTKFIaBVLc79TzYyXkOlFHL1jt+rSO2EZszmGCAGm+k2DuOFKHSez7rAVRzALGATASiZ6wm/0TYvIfh01fJXPzqKmlRG6ePmeJX3VvZXDHqEflLst310qq3rfMwJvbIBCDlFz0fFKI6yKrNzMpuwHeYP1rhGjMDyjjmS6u7J138sZZNjSgws9OA0Oqz4z9Uca06WKAzFSHq8fdcht+3h0lFVqMDWTm0KD2MK2vpeI+jKvTIU/hfbRzx3v5Y6mcQyRfUepxKqhiK8hhxX+2XZLwl37ZEXaJxUdRTnjMaTbYM+IVnHezxFG6CFAppQu6s7a0XrqhqJhHpgHfGVGRufbI3omJspT8ueDjCqR+ThcjLOAfJm3ZRUSrq/fyYD2IW7j1TIPLlpibsOKObrBtBrraJA3aYyB9ZZi6DGsIAIMutHjCRO+3lck8wBu3z+
 +p2LzVwU
 bjYjJde9/4M66J6kStzv9JUbPt/Cv73NJ8Rk/FPe3/AfOgaW/WUO5gOvGUD/Uclu5E4uyXIp2uG93zI855zkg0JUzrTzGFy0U7kEMmk5Xxis+4TRzADTtujUcKB+Y9WQGFOoPmsfynDfqhPYvV3RVCjtmd3uV8FDbtW5jX4gE6hxUiKJvCwrI2apDQQQ7zrKbpWO2rBeXjjVxmGIjzupSvjdyi6DQLkLDWT2sWCl94/+ZbDtxHesmQAfM7B0X8ifC7Z3wSuVFNqx9+IEY+Kx02VFjbgPAb495Bqbq9uPu55qSP8pHAPGV6gPXM0TNOu4RHD85b7DuMYoE74c6xnkogg74kg0mG7sAxTj9vNXkALKXqRqIrdCMl492sdUWW9iI8yRz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> index 8c95a658b3ec..022b0729f826 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3463,15 +3463,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>   		new_folio->mapping = folio->mapping;
>   		new_folio->index = folio->index + i;
>   
> -		/*
> -		 * page->private should not be set in tail pages. Fix up and warn once
> -		 * if private is unexpectedly set.
> -		 */
> -		if (unlikely(new_folio->private)) {
> -			VM_WARN_ON_ONCE_PAGE(true, new_head);
> -			new_folio->private = NULL;
> -		}
> -

Balbir, why did you drop this check?

-- 
Cheers,

David

