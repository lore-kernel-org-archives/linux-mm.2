Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B0B606A33E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NNDOELm4
Received: by kanga.kvack.org (Postfix)
	id 7B0486B05B7; Thu,  5 Nov 2026 14:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7877A6B05B8; Thu,  5 Nov 2026 14:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6766D6B05B9; Thu,  5 Nov 2026 14:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 393C76B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:29:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6098160A8E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:29:05 +0000 (UTC)
X-FDA: 85402053450.29.DF1FBF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E173612000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:29:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NNDOELm4;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793906944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UknNxIDX0xm3f3sWMXk0B1mzbk0SggFrNXwmrmf6Ci4=;
	b=w02NAbZrvtQS3Nnp8PFOyOVKJ2aVXBuaahZC7bgZtIBCadlBL5BTHjOpJB5nlRonvbDMJD
	yD6TQnhickrBSo+tNLe75F4NaBTeERhbugkWd7SPOWa/3oo9NvEDDrQXvvfaFpEHuvvXHM
	Gp862z6uoYGL0s97PFCsrAiDoREIbmY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NNDOELm4;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793906944;
	b=ckA17rK9B0QHaOrso9SzFYhktkSvSCPnk/70N9+MvIbLa2ld6Lj5aEyM0ge0wiwXIkRh4X
	fbcwqxO8xTU/N/eeN5ZV5dCa+Ya/I/beosrAYOdYlFMJZgJSlV/aDMYAJ5LLe6ZqPIEXb3
	tXx0fPvSba5V3R5BVjSFW2BXGk2tfYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DAA2601C2;
	Thu,  5 Nov 2026 19:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F771F000C1;
	Thu,  5 Nov 2026 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906942;
	bh=UknNxIDX0xm3f3sWMXk0B1mzbk0SggFrNXwmrmf6Ci4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NNDOELm4Hz4N7CmdMhpohkpVr08q/PWYgov7+1gVAQr7+hSjjyLzwt+gc5JDB9zG5
	 EhQmvVv8/sV5hwSbQvW0eWj5i/tlTCKYhTXrjtBL9j/Pfg3nNa/7kieX07YgfOp0Oo
	 LZzp3hshTb3g3POqFSESr/VE7XC+DpFbf9BW/5f4rsslUVmQ2N4aoyOtnIPOE+OzAq
	 VfV0DVzFkIDjNw333I4qs6PsuH9SoLTSVH3+4+EwX5G6mLFMcvcj6S0xziDqU02Awk
	 4NoEyPx8h0+b1TBbewzfPHjJ1UavJLvFlKiB3/T2Uo0tSH0Clevgj2BnKuR8WUuKaQ
	 r6DiIWtj4SmIg==
Message-ID: <8a3827cb-187d-4c4f-84aa-5ad811abef20@kernel.org>
Date: Thu, 5 Nov 2026 20:28:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
 <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5h6ukk8w9hodj1xc6fw3kgfuktke4r6q
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E173612000B
X-HE-Tag: 1793906943-100317
X-HE-Meta: U2FsdGVkX1/pJAHJsHM26uZJFE4PCjV4e8CCB8+Ck3tElvRjC5BZRVG66pli4EGTn5bpUUfqAP9HXYBj7taJDpZ0V2qTc3i2ymjcJHPpdwk2j5f7TBbT/XKqgrYzVMk4qCQyIM9FhDz8BvbmnrTyFgpdLTeuKmo+J+gdpPhQk5J/UI9PrxCLe9OOW4w/r/VqlEU6LfOm9ZIt2Bb1r/nP1grgcY8bw+lhjY2epKnPOT3sBQN6vGP8Pp39XERU1JFbduckupkoAjvXyVAjAyyAgqBHHuoDvQMLo0mz11YrVAvPgewkuV7Ik55Fwzsvk7TaEwFBOXKfTU/e99msbITlmQrAjeJr5nhOB+R36jWy9L8nHY4A7jJuRTAzgFFERoHsHMkPdizBTC+4y2ds9SUAvCiMfuCnjc3RRtzrRzNTKob1VFRUZEfWqfKfyGrzfGSOSTJnueeQGUb3bj2bHbpKycdAyc88wDoM22oPSwipk7KNFgrBcYeFA0Yb8GQX6dDWoLxt9YmuCl0R18QbMiPeG+R0biVOdQX1NhcFztzYYNhzIlS3p44n7vEx59ccGnyKOq3xaL7P4l3fqEIdDE0j+5r5UsFOciegv9gDd/bU0szY1q7+XIucce0u/fWV1uWQZxHNLAq7Q6FvYnvJTzGTdBa9JCyNzHVr1YNHmW0VJcLwg1duM+AqIwolWbJ3mL+AaGrQthDnHh8YI3iVXUv1N7vJeetNFjmr9lkWv0GaCCD5T6/Zr+ROYcGdGvHjrINV435ZqabWotHEvI6QGRO5KtDLz/HT1EfMLy3xQ+i7DQoxuYMjNswATwzcNgRbIT0QCOYHKNoJQEa+yA1Di09mwAQ0MjCO4v091yq+mY+7m97NU1vIrxSoKmFhXPPE4vxa/oObxYeBEPU74JmF+P7qgqfyOBKb9bjLSv9+A/Vk+AdOlxsGmC92SBo1FGq3667NnpQG32btHnNWZtkiEvS
 1uaX3sYS
 9ZGoTBZyImafEdPLWIjl32vMxcMp1MGaPtCVWKu2xnLOPjtxcll1hXZyZbzjTDvFTkRy0JUYGAs0E5i6wGjTaLWlekFjmBbU/FEK4yMkHZkso75L1ugouHVtLQrwObw2VRsV+kpnxzARiiY6jYCM1aKe+oALYk5+LRKyUB5Lv80BxTt83ujlZiEUqa0ZozdvYrjVB73o5VKVvjX0XOIqwWmKOopTegc5/xsjC0dKC25x9Z9+BmPG5GKP9TZb3siVw6h4Ys2lYUXFI+KeT5CHGY5LhExq9HM6OwBZZPWbQ/7nr9tDle4GoXGS0M4rV2hHZXGgMlDhKb4WvPPXy9TM8SIniRgxEITqirbdKtYBYMizC0IzZzMyrsm44X5TQrq1zPc52ctANUfFaEaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 18:00, Konstantin Khorenko wrote:
> Device DAX maps its memory with vmf_insert_folio_pud(), which takes a
> folio reference, adds a PUD rmap and accounts the pages to the mm.
> zap_huge_pud() drops all three, but copy_huge_pud() copies the PUD into
> the child without taking any of them. Each child's unmap then drops
> what the parent took:
> 
> - the folio is a reference short, so with two children its refcount
>   drops to zero and free_zone_device_folio() runs while the parent
>   still maps it;
> - the child's file counter goes negative, "Bad rss-counter state" when
>   its mm is freed;
> - the parent's unmap drives the entire mapcount below zero.
> 
> fork copies the page tables of a device DAX mapping that has a guard
> region, and commit f807123d578d ("mm: allow guard regions in file-backed
> and read-only mappings") allowed MADV_GUARD_INSTALL there.
> 
> Take the reference, the rmap and the counter for a PUD that
> vm_normal_page_pud() resolves to a page, as copy_present_ptes() does for
> a PTE, with a new folio_dup_file_rmap_pud() helper. copy_huge_pud() now
> needs both VMAs, so pass only them and take the mms from them.
> 
> Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---

Thanks, I'll wait a couple of days and then queue this.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

