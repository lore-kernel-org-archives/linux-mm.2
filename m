Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7BC1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6CF8E0017; Mon, 17 Nov 2025 12:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E858E0002; Mon, 17 Nov 2025 12:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBDA8E0017; Mon, 17 Nov 2025 12:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEF2B8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:12:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9235C1601DC
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:12:14 +0000 (UTC)
X-FDA: 84120742188.09.C6002D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD769180009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:12:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X38QDWbx;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763399532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2r1usUXXtySj602qTx0jfIDfzoRFhbrQSq4T9w+Ee0o=;
	b=ivQHj+W8WHIr3dCWqSGoWGK8sgRjhKz5Nv1KvypArk5D4aa29n3eCP5wjG68BGGSqDQSIJ
	SyssogUdjhDbmpx8Y4MM1ttzfL5CSx3UNhTMIKhYll3rwVdQsRkBVEeu7vh7A6+aznBbFg
	tzf+Pa0UXgkOOkxnUSS7i24JgDTSCzA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763399532; a=rsa-sha256;
	cv=none;
	b=5Q1Nd0FRol6fTWcbx6ZDmcN4j8nJhmJUEWfZAyMvhdeqZkpG7dj+z4qYkOzN3yREZEzcOh
	TxIfzriLXmhq8ZIY9CABQzfElnfTJ3yz4a1dfM7oktAXAG5kfv6gErnErMPeicRK5HHPeQ
	oYqcUa/zOoLeb/NMm1ouw3d8L8p0Diw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X38QDWbx;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62B8A41882;
	Mon, 17 Nov 2025 17:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F953C19423;
	Mon, 17 Nov 2025 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763399531;
	bh=d5Mnypq6wDJc2sGNmVWWVeUIAR/ILc0h228u/LGZuww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X38QDWbx7NnvZpofmhjuhcucQQctW3dwbl33jMr22mYBTNe4W4yMzWmwXqeZ+TPYx
	 18Zd7RdYuMtJC6b1Ova/QprEbncPpveX8fWmPw3S2CrQ+xAlVjGgyGeML8t6+O7NWd
	 qEnw0hmusYTbsvVwUN6U3Uwyj6duJsHM2Yrwh8SFuYot/p09AjApKIeS+Dxbk26X0O
	 +PARQdPUaQbJYCdgJIW4hvdIchPfgtu3yFfHzSMtY4E8Xd5LuQBFmDh70p+Pkb7CDF
	 VqbrAwAWrAYiIhnH/d2y3hbtm92KfhhvqP8GCx8CPiD7Xdt/mjgCxAHbsZAN51k3I2
	 O+N2LrxCNknHA==
Message-ID: <5f1e139d-cd6f-438f-8b5f-be356314d9aa@kernel.org>
Date: Mon, 17 Nov 2025 18:12:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce
 uniform_split_unmapped_folio_to_zero_order
To: Jiaqi Yan <jiaqiyan@google.com>, nao.horiguchi@gmail.com,
 linmiaohe@huawei.com, ziy@nvidia.com
Cc: lorenzo.stoakes@oracle.com, william.roche@oracle.com,
 harry.yoo@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 willy@infradead.org, jane.chu@oracle.com, akpm@linux-foundation.org,
 osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20251116014721.1561456-1-jiaqiyan@google.com>
 <20251116014721.1561456-2-jiaqiyan@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251116014721.1561456-2-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: BD769180009
X-Stat-Signature: 34dqwr8m9ohdz53m3q81ez7bew7q8juu
X-HE-Tag: 1763399532-137584
X-HE-Meta: U2FsdGVkX185samcebILgPBs2nIsBKxeRrJE3/rH5F7wff7AQMZFoVGUtYVZatkauSs0Lff08h7pjeWqqto0k+lvVrpNjtIa8PJUHOFcJslJx0k7WIsxEZADMrpg4R6btvCjvyj4gQwfqWEaUyMniZo37znAAHjB9bEptaIpjF6CpA7isZk/1HFZ9FXpRt67ZeynbbjizTbYwcMJOsT6DLZgyCGEN1gHG8zWNGPmvwLCttDFiBPqOJs8U+wBqG8kgb6Kzs7X8CaaeDIUB3Qbhn5hk1gX5v2Spnlt4MrdjEYAGczzadR5PuzPdxJ+NsjQD+MIeLuzyDx11q/1WPSF5N2Ffdrw8zNVVXrFWHBlzgySfN3E+ueELDFDZePqkobTphYkRermEseqoXUeTQFFltt5a9sQI5ogB2Cy42nfzAWwfdij/D+MACYV+JctFQSsYMBkb/BAjo50GmOlpKe9oyX+ewUF/1VNM7IWfDrU79NSw9JB+Pl5fNdMIvYGfAFim03Rsni/WNfWZZsklBZJzh2VjM2NcVSD3yqC6fka2ikgiOAW6yvJhNQVPtVnT3S+lnVg8+DKFnHRrgCK2Sv6HaoD+9W2XgCNfth46HvsE8PdGpMQtg93CD8PnkdsBg9k+Dyq8WPRxU1OizuNJRlvWBsfTTnn5iIKGWsLXEtgAsvkY27OavAzZcae2o+vXFXnLnv8yHiMR6e+GLNSKwZl562JcfrY9Lts/m4RQXsdX4BYx0o5Qp1kul7jb6uY2pQwpjN/yNKxjBZqkqDayv7+fW4tSnO0k06sWE8DAjXBqTVOThU7pt4DsGmaTXdt8a0JbU5uT11HS7/KXCQqQyhLSOg9FhZqSzTmLBNYJZ99UDuuqcQ91XZLZtK7BHh2Q0/Ar0V3+gLQG1Uad+4YW8qt9+SvpVBGY+08lnLny4QQerCgIRcSWtVbz+LsgUhA8RYnRsvlLxUdeKigtu8MM7X
 PnDuUJfm
 OEbdpLL/vPXN9x6OrHm76Z3WIF2jZNs/8IrRFp0ToKfUIKjMLNXqmfozoh+CRgKKlfEfCvAyOd5u9IiNeDbgfE5cZfkSyAJdoxrg0JeHHPFyyXDo9YfdUqB0agSohpgDQcXmd3+BnmLKb+iqzF//WVvE4dw5BbCVdJa8KG+gZ41oYTqpJxce/Dupte1cb4JjlrvrMFMdW0LLvyxMFHpy5jUs5WkBgK/w7TgC3mqoVH2Rhrfr3t7G63hZELOv9BiPRnD+V8AHPIyrm5fEsvMHgWCH4TMOjKvfus1mIjAsSagMP1eyfIRYfL2FTUgmbsTCsmZFrJm4rvjCW0BuvvK35CYL4n+4Vabr55vNmfIJelKmf3tf3Ap2ZFn+1V1pIcyx0ewVqHwvpfSYLuEkScuVPSxmqow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.11.25 02:47, Jiaqi Yan wrote:
> When freeing a high-order folio that contains HWPoison pages,
> to ensure these HWPoison pages are not added to buddy allocator,
> we can first uniformly split a free and unmapped high-order folio
> to 0-order folios first, then only add non-HWPoison folios to
> buddy allocator and exclude HWPoison ones.
> 
> Introduce uniform_split_unmapped_folio_to_zero_order, a wrapper
> to the existing __split_unmapped_folio. Caller can use it to
> uniformly split an unmapped high-order folio into 0-order folios.
> 
> No functional change. It will be used in a subsequent commit.
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>   include/linux/huge_mm.h | 6 ++++++
>   mm/huge_memory.c        | 8 ++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 71ac78b9f834f..ef6a84973e157 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -365,6 +365,7 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>   		vm_flags_t vm_flags);
>   
>   bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
> +int uniform_split_unmapped_folio_to_zero_order(struct folio *folio);
>   int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>   		unsigned int new_order);
>   int min_order_for_split(struct folio *folio);
> @@ -569,6 +570,11 @@ can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>   {
>   	return false;
>   }
> +static inline int uniform_split_unmapped_folio_to_zero_order(struct folio *folio)
> +{
> +	VM_WARN_ON_ONCE_PAGE(1, page);
> +	return -EINVAL;
> +}

IIUC this patch won't be required (I agree that ideally the page 
allocator takes care of this), but for the future, let's consistently 
name these things "folio_split_XXX".

-- 
Cheers

David

