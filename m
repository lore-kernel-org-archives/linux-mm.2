Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C4D0CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8856B00A5; Tue, 16 Jun 2026 17:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B09C6B00D1; Tue, 16 Jun 2026 17:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1B66B00E2; Tue, 16 Jun 2026 17:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB7A36B00A5
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:11:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECE338980E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:04:12 +0000 (UTC)
X-FDA: 84885945144.30.7FD895E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 05BD5140018
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:04:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=heS7qKoI;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781618651;
	b=r8wzUw/5uhU23kQ+RLlhWgkZ770jlWUwPX+E9Qxaxm2ILCtmfvKsrONnW72X4Wrz9cuWD+
	1zwnwJv48IEe9BSL8B38uiYIGuHSt7PHnEiq7APrajZQYeVmLE7F2RL4F3JbM6kevuwL1+
	pXKMrd8fA4jpxIslT+GThPFDLWEUu2Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=heS7qKoI;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781618651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cv4U/lCwTmC1Xu4fCZeo9kmaEne3SOba71hNwtJ2ZA=;
	b=nkxpnyca93GxxqhAwQASg86AO+EubQrFKKDIWIpxZ44ChYLwaMfqCwjmIM7F96ezqqhw9D
	zo1rE7/wk8AMUgACaw4fuWjSrnfwA9IgXzWMbfmBL4fG4Y5ZhLr+HkpqSxgZiGL+oyP8dk
	MPCgencdQ6a4R4T2PBDSS7zLt9Wwl64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 135CD43667;
	Tue, 16 Jun 2026 14:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DD41F000E9;
	Tue, 16 Jun 2026 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618648;
	bh=5cv4U/lCwTmC1Xu4fCZeo9kmaEne3SOba71hNwtJ2ZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=heS7qKoIs7GLheXLM0LdXqaE8U5e2V6+skaM9EFHXTFuQnZUHAUHupN0raqx6JJ+7
	 ankYbPAZkMcRuX7CWQOFcvmCNIVxRcM2282rFLaMN9+H73dTEeUilu8ioObWl128uR
	 IgUA+hzNWFZp4w1lmQrlY9zr6G+b1HqGV6Mkk2YrD1jGCuc0Qtcobc37xOLWAZRtuK
	 WLc79EguaTWIrTWqRgRXk4ENgaaLry1Hac44Oa+RscZEVFW3qzhJcqTPlbDJpdWNqo
	 LDDn116OjgilAu6yXDE5H1CGf2f8YmaTdJyLVNG2I+DIf5Iw2dO3Ly+pGc46UAAhQH
	 tbDTXSAhrYUgg==
Message-ID: <2a1781f3-741b-4073-b23f-f5cb3f0d98e2@kernel.org>
Date: Tue, 16 Jun 2026 16:04:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/12] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-10-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-10-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05BD5140018
X-Rspam-User: 
X-Stat-Signature: 7qwkipt8zfoosfckqdm9zjer4zhr9bk7
X-HE-Tag: 1781618650-610709
X-HE-Meta: U2FsdGVkX1/egUlqMWAeV8kvbdS2khLtxKV/GWqNb5yq/xf6HqG8nbOnTNDblCQIJoO4eMY2HHykyA52U8k7rN3p1r9Z4HpktYgXrzs2EMpVAXJY0YU839yNlJv87Q0oZHqEbHRCNQ5mV0ugDiHotPk55xzssp6wCG65vU8LbOggZtYMJrX5u9iERRKLSOupgmHhGmLI5B7uJaW2dzO+lAcu5ZX+oX/+kv18N9aV/FjrCmwRxDeyE3fthL0jkitoltFQmoslgIRleU4y6xHWlUUCVl8OeFVLbCf+UceNLeFR0ZBdIjZk/g/z7HADWzhlejF4epRLF6Z/iMUQXXapgZlHFGoGNEH2LHnksNU913mGR04MbNdfGbuo1BbGP5amrlW28rBc4TleLjP6SnZcviWxKdr+RRo4RH+sINokBA5Pl+oOAuKUGiMt4bMTHJSD0xI8Oz3jltRnzSxgERjGN9eNmFINOGwYfH44PNU0xIY50XlZIY0EbEfwA/sEts7agB6ElOeiC1TkdrM0oXIy71WRNaTqK7gX8JyHL4360BrniiacsBoyF9sataluoeL/zgvZ7QLWAQlM76AILoe+pvaFidM0ftNaIHgaONSp9kNARuuOwnK4hPJvS9tKWuQr9wRYUgXnWNESsXWgBTiWEI7D9EdQZFTpgHDHf8389e6N8K3tw/HS0C9qST7KDl9APlmU+Mw5hzYqh7NmNUFMFaXPMA9p9Gi+bxurOADdPrEg4Z8S9vJJiMImtLAUe0j4rgTRRz+NBxd8bOiU6gyjwnAf4mVzA80HEc2DCTVdfQC04uSB1qdk4a7W22upkdZ3UHumhZV1Ha9uwT1HrzLYtFn+rXKmJBnfydW1lVuhJx9w61UecA1Ilk6ByVoR1CgVgofGwenIq7exEAwRLf8tWkjqQoYFKD7BtLkVx/e5cfMucPJYKomGWh98ni183rBPQdYuq2AdVwCIS9wLSfc
 uR2ZoQ7a
 3HywYK2uEjRzi5yivYnA8h+9sQYBuEOuRFGq5JGsiktEiOp6LL49t2/AmkkbDzuQfUPeqjc7GLhwEWrsg0Gex60pdT4F+WiPK65EXynxFRMd9ruidEJoYQh35zGEpFXU6xTDxcSM+k837hk98QPj/w5xJVmsL0s2EnoVMq36FMkVzX8CxvD58bhsGUXiFpdL2m+dPY8xwOfYpI37SDNt7y9gCKtgByB/ZmjkNDyIKAOwwCJAbH+ChfHlBpBnHU6wWDC6VvMl4L8QVU4GM7wnzjuBaVT3QO++HPeqeHLE5ZBxR3jf+NMNCZ79HSTLSmfTvZqtKv70mrm9+Cct8kO/h4a6/JLjMqPVfwA/5sar253NKDi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> To enable batched unmapping of anonymous folios, we need to handle the
> sharing of exclusive pages. Hence, a batched version of
> folio_try_share_anon_rmap_pte is required.
> 
> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
> to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
> batch of nr_pages. Refactor the function such that the clearing of the bit
> can be done at one place without duplication.
> 
> Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
> from the PMD path, but currently we only clear the bit on the head page.
> Retain this behaviour by setting nr_pages = 1 in case the caller is
> folio_try_share_anon_rmap_pmd.
> 
> While at it, convert nr_pages to unsigned long to future-proof from
> overflow in case P4D-huge mappings etc get supported down the road.
> I haven't made such a change in each function receiving nr_pages in
> try_to_unmap_one - perhaps this can be done incrementally.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/rmap.h | 52 +++++++++++++++++++++++++++++---------------
>  1 file changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f001..64929490a7cfc 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -706,17 +706,18 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
>  }
>  
>  static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
> -		struct page *page, int nr_pages, enum pgtable_level level)
> +		struct page *page, unsigned long nr_pages, enum pgtable_level level)
>  {
> +	/* device private folios cannot get pinned via GUP. */
> +	const bool pinnable = likely(!folio_is_device_private(folio));

We don't seem to have a lot of users of likely/unlikely when assigning
variables, so I wonder if the compiler really uses that information then.

git grep " = " | grep "likely(" | grep ";$" | wc -l
32


Maybe clearer to just push the "likely" into the actual two condition below.

[...]

>  /**
> - * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
> - *				   mapped by a PTE possibly shared to prepare
> + * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
> + *				   mapped by PTEs possibly shared to prepare
>   *				   for KSM or temporary unmapping
>   * @folio:	The folio to share a mapping of
> - * @page:	The mapped exclusive page
> + * @page:	The first mapped exclusive page of the batch in the folio
> + * @nr_pages:	The number of pages to share in the folio (batch size)
>   *
>   * The caller needs to hold the page table lock and has to have the page table
>   * entries cleared/invalidated.
> @@ -797,11 +807,19 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>   *
>   * Returns 0 if marking the mapped page possibly shared succeeded. Returns
>   * -EBUSY otherwise.
> + *
> + * The caller needs to hold the page table lock.

Isn't that stated further above?

>   */
> +static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
> +		struct page *page, unsigned long nr_pages)
> +{
> +	return __folio_try_share_anon_rmap(folio, page, nr_pages, PGTABLE_LEVEL_PTE);
> +}
> +
>  static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
>  		struct page *page)
>  {
> -	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
> +	return folio_try_share_anon_rmap_ptes(folio, page, 1);
>  }
>  
>  /**

In general, LGTM.

-- 
Cheers,

David

