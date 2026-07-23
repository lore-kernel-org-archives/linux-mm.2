Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3153DC44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149C26B00C9; Wed, 22 Jul 2026 20:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB326B00CA; Wed, 22 Jul 2026 20:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0394D6B00CB; Wed, 22 Jul 2026 20:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C616A6B00C9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:01:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CA57A0366
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:01:06 +0000 (UTC)
X-FDA: 85018086132.09.F0394EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9DA541C0007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:01:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lr/5uR27";
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784764864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMQvkJ7Cw2WB0bsUlcObjuqLrm1lLE+w/ZmTmCjIdEY=;
	b=ITsUqQTFaoe6ZCm/COUmO2l8b+HC3xFGiV+wFeVtseJdsaMaj20YOE2lSBXjbDvuEEwRj0
	2l7o34eEo33HF32q1PmyyZP0dztTETaN38x6EhtMVPR5srYZrOMHuQ48dHYrS7nOksVYqD
	0fOJe5xorTuCquBhfua1QJiXVNx9ZiE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lr/5uR27";
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784764864;
	b=Brl9gJs3CrL5ZraN8G1EnFsKU3hMRjVx41TSh7OG1mvOh+lMKZq4E24LQD4Yb9dq+dLRZc
	22tXIMMyFRnwVlCdzGF0OdOT0uzP7KF+JF0z2LtbGy+J+yjqNLzkcJ+wvfy76809ovhMQv
	CHR7OCncyzmzWeqYmGsZD8elE+lYqbk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D87C8440A5;
	Thu, 23 Jul 2026 00:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13B21F000E9;
	Thu, 23 Jul 2026 00:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784764863;
	bh=PMQvkJ7Cw2WB0bsUlcObjuqLrm1lLE+w/ZmTmCjIdEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lr/5uR27ht26s8Jpqr56y/74PfFqe4o1UKOsd02ekr1ZVfC5beh6kF6OLxvLMWBFV
	 Uc9i86xblf09mZnvGP00qRTqG3OyQsgpfs0ufBVcooFXYJcwNTWQs6CAWz2rH/SrkH
	 IdPOlYi0+efumds4q60vb57feZp77zJ2L/80eYw17y0lY784TY5/F+AyUlrnAjQjhI
	 opaZUiLkblNmOL7vwsWYVCu0Y1XRaDsVwVP3vnyqsusvAB/DUut6LbMZk6v5TxOZuc
	 UhTGfvigzP4x5cudrcuaTilJWoQ8QH9A8KxY0fcKFD7JhAKj0p1GTos3pep6dggPcU
	 lSwk7AO8Sdd9Q==
Date: Thu, 23 Jul 2026 00:01:01 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, kernel-team@meta.com, Alexandre Ghiti <alexghiti@fb.com>
Subject: Re: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio
 swapin
Message-ID: <amFZmtGHEZjXEw5R@google.com>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-5-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722152043.2273289-5-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9DA541C0007
X-Stat-Signature: wrg3u43j9hgg8r3b8eeu5u7z9anxwr67
X-HE-Tag: 1784764864-61772
X-HE-Meta: U2FsdGVkX1/LAScPBj9qYpop/ZhWAeRoTPQDyU7LIWNquDJuRsorKAA4MA+N2YQ2PgnNt3iP31c7ErstCMIPjFzjH95WkY6W4S6aJvtpXL5qqznCcph+RJXLIRKkp7h04A7AuhWmiSQIutcEFKWMqeC/SOgj+BLOsJ93Fe4gomDIltMd4YgwDOb5bJH3XntaKfISBsESvtR+yoCnLdAM5hI575oUgoctzoKc2EB6QsxuQeFdt7pTRNsD+vpbayYwCw0rAKnQMgXe65FSRTh54CE7uUCdV1RGXTyO+FHdqJgODb5msCzaOXW7XMvfktW3jMQw7CbIRY5C+boCbcJWt+9ZUMZr8KOGzLEQiMbSSmQPJb0ZPhlE15j+D3Y4MMQLoHy9KMu/E9wqTrxpt01Xg2ynnjPQGd87XRS9YEWvKmWquW2XYit9iUVpTtXXI03jHnQr3ksKyLvAxY6oD4idByB+FLsn6nekrBDWve7/ebDpn4HT67OOAoRiNnMcCYu+iN4YF394hYsCLohbZeh2RS5kEDocK2V9mp32kud6ayyVbHn+2QatX6lv2i8Y5Lbyh8QkNzMMsgvZZ3Dx9bfIS6S8YsfyN9dE8wboYwCkBO7Iaaz/XxVYqvvTY8VftfhJEcF94fAxC6HazYDzh+e2bey7Wl0w6z7Rd13CSrkZ84CddynH1rddbEIVN84ueBZpZoQdJav8ft5/QSBuotpX2j9w3aTUJAbACouIRfYAdeEcqfAY4+z698fdSlqb6Fx8hjTChU9YVJHBSaODdMfUC+mNt9ar7ORu0Nghcm8IcftavnhP/KukNK4fmXMJqA3J/Wc9c90f5rfRd8EtYQrlFkA2WdBqHDLQjWgAeMlk6GjXHMt4AHublAn2J9tnXd0rGREl37vZl78euqwnON6o3msawdFcmvyiF9HLW2jnAWif6aqMMFfHmtpzBmG2je2EvLvTUgVbgJUIKbroBVk
 jPMvbHPr
 kztkR5LRYw4iFg7RjrqwsgGMiNmBMxEQ1ucotjAyczMsjgi/VrhQWk9gT/q6y7VegpTn83exOA+tzx8B0CAX7KtIa9qUzoKQs3VxOlw5K+LU1eiVgeVwvynGkHUC9sqFkKOQZgK4KKgnWwlnATLpNni/LG08wwTDnp+CYiGxLSIUCutDXGNHkKen6//TCGfHoL+usXbn8ofLqSMCQjWfuQxo5tl08HOB1elw2GQrGvjV5dM6bwteu+xqtxzC02vp8h8Vw9tlqMfnVwMs34gMU9MrbFyqXYONP+yDFS2w+W6thQDRDzeLXUhIHSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 08:19:35AM -0700, Usama Arif wrote:
> From: Alexandre Ghiti <alexghiti@fb.com>
> 
> A large folio reaches zswap_load() only when the caller expects
> the whole range to be on disk. Zswap still stores large folios as
> independent order-0 entries, so reconstructing a large folio from
> zswap entries would risk returning partially initialized data.
> 
> Teach zswap_load() to scan the covered range. If no slot is in zswap,
> return -ENOENT so swap_read_folio() reads the backing device. If any
> slot is still in zswap, fail the large-folio read so the caller can
> fall back to per-page swapin.
> 
> Return -EIO rather than -EINVAL for that conflict. Large-folio loads
> are now valid requests; the error means zswap cannot safely satisfy
> the request from partial per-page compressed state, not that the
> request is unsupported. Existing callers only distinguish -ENOENT,
> so this is a semantic clarification rather than a behavioral change.
> 
> Add zswap_is_present() so PMD swap-entry consumers can make the same
> range decision before attempting PMD-order swapin.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/zswap.h |  6 ++++++
>  mm/zswap.c            | 42 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..cd9efcf9dec9 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>  #else
>  
>  struct zswap_lruvec_state {};
> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>  	return true;
>  }
>  
> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +	return false;
> +}
> +
>  #endif
>  
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4e76a4a87cdc..384492f1f696 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1561,6 +1561,23 @@ bool zswap_store(struct folio *folio)
>  	return ret;
>  }
>  
> +/**
> + * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
> + * @entry: base swap entry of the range
> + * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
> + */
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +	pgoff_t offset = swp_offset(entry);
> +	struct xarray *tree = swap_zswap_tree(entry);
> +	unsigned long index = offset;
> +
> +	if (!nr || zswap_never_enabled())
> +		return false;
> +
> +	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
> +}
> +
>  /**
>   * zswap_load() - load a folio from zswap
>   * @folio: folio to load
> @@ -1573,10 +1590,9 @@ bool zswap_store(struct folio *folio)
>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>   *  will SIGBUS).
>   *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> - *  do_swap_page() will SIGBUS).
> + *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
> + *  error is emitted (e.g. do_swap_page() will SIGBUS).
>   *
>   *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>   *  locked on return.
> @@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
>  		return -ENOENT;
>  
>  	/*
> -	 * Large folios should not be swapped in while zswap is being used, as
> -	 * they are not properly handled. Zswap does not properly load large
> -	 * folios, and a large folio may only be partially in zswap.
> +	 * A large folio reaches zswap_load() only when its whole range is
> +	 * expected to be on disk: PMD swap-entry consumers split before
> +	 * calling into PMD-order swapin whenever any slot is still in zswap.
> +	 * Confirm the range is entirely absent from zswap and return -ENOENT
> +	 * so the caller reads it from disk; if a slot is unexpectedly still in
> +	 * zswap, fail the read rather than return partially-initialized data.
>  	 */
> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
> -		folio_unlock(folio);
> -		return -EINVAL;
> +	if (folio_test_large(folio)) {
> +		if (zswap_is_present(swp, folio_nr_pages(folio))) {

Is dropping the warning here intentional (for the folio_test_large() &&
zswap_is_present() case)?

> +			folio_unlock(folio);
> +			return -EIO;
> +		}
> +		return -ENOENT;
>  	}
>  
>  	entry = xa_load(tree, offset);
> -- 
> 2.53.0-Meta
> 

