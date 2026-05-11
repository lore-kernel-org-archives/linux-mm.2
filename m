Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D712DCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E266B00AE; Mon, 11 May 2026 09:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEB36B00B0; Mon, 11 May 2026 09:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A77F6B00B1; Mon, 11 May 2026 09:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9E336B00AE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89EBEC2563
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:03:21 +0000 (UTC)
X-FDA: 84755155002.20.FC05BB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8F6E5A001C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:03:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMdWgIVZ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778504599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6O8TW9FcEE1KNfkifpAqL1mVaUGZsIYVpEZw7U9v7U=;
	b=i7Sbkujt1MyatFayw3mHes8Guq4uP4hlxIa8WG80zzcTk9dsHv05PuVg3GxyGk32twzfFR
	cFxEQBimSNfFW4OJrE42LJ+e9OGZ9rAry1yfa33yrwDLvosWRP1TKntooarn6vvmRAdWcs
	QosID3JtTireob/Xz9dVzgQLUQ331Ao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778504599; a=rsa-sha256;
	cv=none;
	b=1UoSMVJ5YgPxGN1o1Vm3Pf8x9IQN5NGJEsqiT/aDdRxaqU3H+cayDZIwyuK0upm3eMLcoC
	Rn8Cuaa+emDcRl6XnZ5NtnM1zPvzBAD4xgfF1NNC5TqCJ/9ZW2Di8IDL8aimwPUlEGfuLq
	aBHuK95vvEqTRDfG7Hsz5KuAb4vELTs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMdWgIVZ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05228600CB;
	Mon, 11 May 2026 13:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830B2C2BCF7;
	Mon, 11 May 2026 13:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778504598;
	bh=kQwSfNCCLbUhti9udnSk7pt8oY35FAkzLyI7ofDZFwg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uMdWgIVZkHHB8pLI8a6wy8l2UtNjohCfS4udur4TYvZI+6hgM/SCtu3TMmbt8W1Oq
	 9/7BqjCUhPdbLlhv9AZIL8bcTT0c0lJgQkjCmHghkh6p7C5lrFp84dFqA7tLaqVyrC
	 II41nrIt02dHlHV9sOsvZHjRsMWz97TpDCVOIMRsdkOOpqgaVeeCSTUK2YUsOIBEnh
	 CbpQkdTELCzO4rdWW5Vn3+7jOiKiaLqiyjskP3xRe5+chEhnqFiYBsey5tvNGscfZa
	 uzIAtCR5mJoeV3TVdj2Yo0mHwpJDSq8kYREQso4SIsMHQTACS+z1TqLsMKBp48llkS
	 AqktpPLfYjMAg==
Message-ID: <24edd9d6-99f2-4d3d-83eb-69b406f4a9a0@kernel.org>
Date: Mon, 11 May 2026 15:03:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/5] mm: swap: fall back to order-0 after large swapin
 races
To: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
 Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <tencent_CD11FE9B4A0B362E95E776C5F679598FAA07@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_CD11FE9B4A0B362E95E776C5F679598FAA07@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F6E5A001C
X-Rspam-User: 
X-Stat-Signature: 5a67kk57z1i5nunqwr4ednp1xzsz1c1c
X-HE-Tag: 1778504599-521462
X-HE-Meta: U2FsdGVkX1+TtwG2DjI12vIJkPJVJesv9ZYR4NYSntM+znPazw6kulozGSPCMLlFCfo96CQG0HXm7bSgtEFl9SX6uMBxT970srlAKivULULmd3Bv3I8XrqP5wXyXv8lAsRrnTyOfw0hMMwvT6GYjzPSWOKC66uMxAXR+3Xhi4wG5QxDl064s+JOM1nE/b+QHF/XVd67rIVtd2iq3EAFTN2OltsNenX5rQAemAs90d8HBKj5CIcjnRvsCwEX3wt4RYHJ4hb3dl9kI9s1hwm3wsARe9L1aQB3uqcqY7If/qc4jyosK9Evk2NevVU4eUmFl4ujzjkWIUVcBzCtwZX4omH1ViL6+xKstO5LscktsvxSTtlYaBcRwSfRjFqLr5oDG2Wzsz6wkbo9/Nez/u/aQN8FwOcVwppqcZbxXpbj2PLAMvgbkMcYkNDvSYi83WkTUFBKywS/rmwzEuTxqnyp3RhNLfGlnlZS1vgGJ6u5s+dfMoNGzhge4WjumbYTJWHoouWn/uES7A3aXW+1ddaf8j/oXKnPSwnuNVhGn8SysqwWnQlUcojThhzoR7dlsJ0oP86+FZfpesgT0XyjrL+f8UxzNLxULejwqZrccvw3VaUj6zSTkqLWapVjWU2du1JEpsOla4tg4YcpyuAT/c9rqASxj3OTuryM4hEu3xwg6+KJhcEzxPh2qvCraDnMZIr5Jw3Vs1ygQ7+XuDR5dHD5Z1xxkhjNhsc5pcweDSb4GUQrjG6H+2C3JURitTCsIyoi4gQs/+ZN7lvgw0jz1HWd9tSUsk9ka5kFYely/HAM2z70iCoyAOyOc8AafnYhWR8aY44rlLCMe7EeKqtQ3Ll9p+qv6l/lpQpFKTkfKW7mKc+m/3LG7Iss5lgVbyGQJN3JO0sRFQoFa2exQWJXv964Fmn+1mx+lgF0L9qQj5R/2qETuexdZNQ6pfJOUl+Sw0dYPWq0Bg3WTXOaUNRAYhuW
 hP32gaWj
 LB0sk/TlV/jYdAXTcJfXaKL69vYlF8vZO3oEXrmfrJxBW5kmF7n3TFoc4oMIHFUboejPDb4QrAKD6TvXmwCj6vXpAQnx44HbR9Q1jKzN9EIc31DaFPLaUq850ClS+cW2rveHF9w6BHORQBCPL4g4bZNuQWX1lEZV7ZsCCXTkB0SFlKzvbppNXEz1xdULfUhNNX3Ad8Pc+dypdxuFOseYBCx0qNs+jmgitMjsxNKWzO705Ou7cfaMsP2cVE2gSHWUPw9/T3Qb4aCvuE8IKjRngf4tl+9O8w2Tk2GVQ306eHCWTgj8F2XN7gsBgzhyt9pzq95bzUGz/jCn7UVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 22:20, fujunjie wrote:
> swapin_folio() documents that a large folio insertion race returns NULL
> so the caller can fall back to order-0 swapin. do_swap_page() currently
> turns that NULL into VM_FAULT_OOM if the PTE is unchanged, which is
> harsher than necessary and gets in the way of rejecting large folio
> ranges for backend reasons.
> 
> Move the synchronous swapin sequence into a helper and retry with an
> order-0 folio when a large folio cannot be inserted into the swap cache.
> Count the event as an mTHP swapin fallback before dropping the failed
> large allocation.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/memory.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 39 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..84e3b77b8293 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4757,6 +4757,44 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> +static struct folio *swapin_synchronous_folio(swp_entry_t entry,
> +					      struct vm_fault *vmf)
> +{
> +	struct folio *swapcache, *folio;
> +	bool large;
> +	int order;
> +
> +	folio = alloc_swap_folio(vmf);
> +	if (!folio)
> +		return NULL;
> +
> +	large = folio_test_large(folio);
> +	order = folio_order(folio);
> +
> +	/*
> +	 * folio is charged, so swapin can only fail due to raced swapin and
> +	 * return NULL.
> +	 */
> +	swapcache = swapin_folio(entry, folio);
> +	if (swapcache == folio)
> +		return folio;
> +
> +	if (!swapcache && large)
> +		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> +	folio_put(folio);
> +	if (swapcache || !large)
> +		return swapcache;
> +
> +	folio = __alloc_swap_folio(vmf);
> +	if (!folio)
> +		return NULL;
> +
> +	swapcache = swapin_folio(entry, folio);
> +	if (swapcache != folio)
> +		folio_put(folio);
> +	return swapcache;
> +}
> +
>  /* Sanity check that a folio is fully exclusive */
>  static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>  				 unsigned int nr_pages)
> @@ -4860,17 +4898,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		swap_update_readahead(folio, vma, vmf->address);
>  	if (!folio) {
>  		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
> -			folio = alloc_swap_folio(vmf);
> -			if (folio) {
> -				/*
> -				 * folio is charged, so swapin can only fail due
> -				 * to raced swapin and return NULL.
> -				 */
> -				swapcache = swapin_folio(entry, folio);
> -				if (swapcache != folio)
> -					folio_put(folio);
> -				folio = swapcache;
> -			}
> +			folio = swapin_synchronous_folio(entry, vmf);
>  		} else {
>  			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
>  		}

There are some upcoming changes with:

https://lore.kernel.org/r/20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com


All the of that logic you have in swapin_synchronous_folio() should ideally not
go into memory.c, but into some swap specific code.

But

https://lore.kernel.org/r/20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com

Already changes a lot of that.

-- 
Cheers,

David

