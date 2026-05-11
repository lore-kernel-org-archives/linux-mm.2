Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAD3CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5156B00E6; Mon, 11 May 2026 11:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475DC6B00E8; Mon, 11 May 2026 11:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D9E6B00E9; Mon, 11 May 2026 11:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7D06B00E6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:41:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E836A01C3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:41:10 +0000 (UTC)
X-FDA: 84755552700.06.890E366
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CFA6A4000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:41:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIGAlmpH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtPwDk1LtCmtOgSQr8qaWg4IrQiN1kWdsu0XWQyLzQ8=;
	b=ioz0uG10iN3MdG/squMtMUww2q/hHI8L+CF2zPn/Gk1UzK39ZOvPysaILEHwkip18WtuRq
	2aDduEJwPGtEw9fhEqx7lOf/h94Ms4IprOaXz9FB19HSPH7IfjR2UHdX3C2xxOQNW0s5FI
	cqP64Z7c3lGK3Q+403CvXrE87bmfOOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514068; a=rsa-sha256;
	cv=none;
	b=pmbUE4i3zg8ox4I+dTZI48tzFMOdZo6oOr1ONA+Z9Y/d7etXsNF4GGLYx80WgIiZmdWyK7
	6PIhgirbYEYi0XcPAe+rMWK+HF9/xWCIw7P1TLRoM3vUeeIDE2nRfit7B24TqpF9B87jZn
	A+zDt2DBZdmyh0QNOAGN+63xuHea1gU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIGAlmpH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C2F060123;
	Mon, 11 May 2026 15:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D113C2BCFF;
	Mon, 11 May 2026 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778514067;
	bh=3dAUWKuR756MvleFWo7H3QaP1i9/q+6aDhzkRJEueyI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gIGAlmpHQ9fwoE8u5/k2Wn6ewPPNyo9bpLGiPfe4Yx+72vLm6jy3DAwys7XWmOEOg
	 15M9n+MZKpYqs/Y+6o5BAWs1sKgu0bW0Eu5IdGEFNDurK+xU0KP1qVFJyvMBvK68/M
	 jPrkwgtA88YyuCqdOAWWXzZ+yY1fRhniMbb2XgIEy7Qv27ngxo20VY+7bTKEpihvTR
	 Dw2QIZF7BoQh1/2IhaH7Fsk8P2IBw13ZTGVcVnqM5RGQgX0gwp1oNdiO5kvNaWBST5
	 nY7bgQHPwxk92uwt0LBqbwUGnly3gCXxzd+2svXI4vb4FHgkqAfJBAYyZZwUXNX+QD
	 vIabhJVMgsswA==
Message-ID: <b7956894-86b9-472f-b2e9-bb50c0316c39@kernel.org>
Date: Mon, 11 May 2026 17:40:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/migrate: add batch-copy path in
 migrate_pages_batch
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-10-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428155043.39251-10-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CFA6A4000D
X-Rspamd-Server: rspam04
X-Stat-Signature: w3un7sbr95nc3qo5hjnbsc34oy545a1n
X-HE-Tag: 1778514068-421339
X-HE-Meta: U2FsdGVkX1+aWncFhnh8X7Dk4YYgG3Troe599kWm8oPP52dbUB5l1pkOZloDvPx9TnG9vnDad9GpVCIxGhszhVzS0hBb3WvRe01ZRRr/kAFyKIubQhgn/GqkDl4ayxGhReZ0AY8L68rFKsnzcVIUONQpsuY6yltlelqSrzWpf/wCq4kCv6jroaGCsInhpoxdT7xJYmMO0uuITxjWdAgN4pZVK2y9UOGOZFcw8LL2qdYY1DVZ9ai+QYYqDAJ9zLjFD2XgdJgg/eNxJBCVbB9V9apIcMqjULLHPJK06QuS/Yy++tqxKpEJ/gyibwRRJacUSyH6qUbX0M54ODRdxgYrSwqoFzVfph0WKHTYTUcEmjlg1XHwTcdL3LRZyIlFYe6LixrieQla0tXXoMwXaIdZSRKAk9gvisFAuDvtGQ21shETulkw16o8innWzYCS2HxWjDxZPZ9glUNlNijyN4yxdVCM702ZqxzwNDcKtgsarLxRPb3OSinuSdKJ/Ige102wgtKC1+1hvnX/A0kEixR+pNypP7o98u8B37D+zQYzmF6cEyOwEVYTaaJf10rP3RX36xdZp56eVN2AWGbp2UsGZ5TxiM3KgW0MdvvOM+Bi6ftsPlNgnlmEulq/E7aiGfaGoyff+ebfioflL1eo82w0GSun3wbwkue+eN3Zb0NNnRdM3ehlsG+U7e3d/2ruhtyIGe+3c0fKxkfVC9Y7Up5GSJQcsxMhm6CECC97uzSV3b1C1McAyTVKBJcX3RXzbDiQcNq/YWqBT2L8upQtRZE0CIR3Zr7wZkxXteo/SPNoUm1hghqi+kLwxd5bJKydcjrvWwhr2Nzin+/337q/zhxEfDQw/4QcRP4aAmLRGor1a33T8aoP6yFOWQtyAvT0uaTMH1reeHxwUQFwvE7z01xMF4hYUid2sJ+0sLeGR+ZI6xJCBR5nhGW2jGNNORI7ifzgvFE3nOySbrqjAY5AI+J
 P83OI4me
 Q8nWXfVqkahMEqSJHZ+uptzZmErUxpRKMbx1SCu89Ta/FHr4CnNPau/xrx+++WR/FJqdtOEof0BhaZnQrZ879YCqD/u25mByzRfzgmZNfYH85C+4JJFOvIlECPVi+P3p+6FWavkKSJnZSQ5C6n9kuvtCj7UK0uoA3Owmk4UiNLjPUZ5JGErK5srvy2T8a3IcbxHgdHXLqVFNncauVY4rembxdssopZhC1+jmv4Fr0DzeGFRvdjAVf7GermnW4ap744iZKIvNeudgEK0CTOZAySiZATAPu+Xeq/c4fSnS3Ej74+LkOiUWw+rlWvWeJX3mhDZjnOknKlQJPUZcCgM8XbikCqfxyfE6bR98AHlTEV0Y8LiB/EfwVadzMgGS9hM8Zfm4YybFpv6azlU6urMRmKodjaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 17:50, Shivank Garg wrote:
> Add folios_mc_copy() which walks list of src and dst folios in lockstep,
> and copies folio content via folio_mc_copy(). folios_cnt parameter is
> unused here, but is part of the offload_copy callback signature used by
> later patches in the series.
> 
> Split unmapped folios into batch-eligible (unmap_batch/dst_batch) and
> standard (unmap_single/dst_single) lists, gated by the
> migrate_offload_enabled which is off by default. So, when no offload
> driver is active, the branch is never taken and everything goes
> through the standard path.
> 
> After TLB flush, batch copy the eligible folios via folios_mc_copy()
> and pass already_copied=true into migrate_folios_move() so
> __migrate_folio() skips the per-folio copy.
> 
> On batch copy failure, already_copied flag stays false and each folio
> fall back to individual copy.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/migrate.c       | 61 +++++++++++++++++++++++++++++++++++-----------
>  mm/util.c          | 30 +++++++++++++++++++++++
>  3 files changed, 79 insertions(+), 14 deletions(-)

[...]

>  
> +DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
> +
>  static const struct movable_operations *offline_movable_ops;
>  static const struct movable_operations *zsmalloc_movable_ops;
>  
> @@ -1724,6 +1727,12 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
>  	return nr_failed;
>  }
>  
> +/* movable_ops folios have their own migrate path */
> +static bool folio_supports_batch_copy(struct folio *folio)
> +{
> +	return likely(!page_has_movable_ops(&folio->page));
> +}

As these things are not actually folios (and callers will have to be taught to
distinguish them way, way earlier), I guess you should make this

/* movable_ops pages have a separate migration path */
static bool page_supports_batch_copy(struct page *page)
...

> +
>  static void migrate_folios_move(struct list_head *src_folios,
>  		struct list_head *dst_folios,
>  		free_folio_t put_new_folio, unsigned long private,
> @@ -1752,7 +1761,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>  		/*
>  		 * The rules are:
>  		 *	0: folio will be freed
> -		 *	-EAGAIN: stay on the unmap_folios list
> +		 *	-EAGAIN: stay on the src_folios list
>  		 *	Other errno: put on ret_folios list
>  		 */
>  		switch (rc) {


[...]

> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -778,6 +778,36 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
>  }
>  EXPORT_SYMBOL(folio_mc_copy);
>  
> +/**
> + * folios_mc_copy - Copy the contents of list of folios.
> + * @dst_list: destination folio list.
> + * @src_list: source folio list.
> + * @folios_cnt: unused here, present for callback signature compatibility.
> + *
> + * Walks list of src and dst folios in lockstep and copies folio
> + * content via folio_mc_copy(). The caller must ensure both lists have
> + * the same number of entries. This may sleep.

This *function*

> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
> +		unsigned int __always_unused folios_cnt)
> +{
> +	struct folio *src, *dst;
> +	int ret;
> +
> +	dst = list_first_entry(dst_list, struct folio, lru);
> +	list_for_each_entry(src, src_list, lru) {
> +		ret = folio_mc_copy(dst, src);
> +		if (ret)
> +			return ret;
> +		dst = list_next_entry(dst, lru);
> +	}

Wouldn't it be cleaner to remember "already copied" immediately after we ...
performed the copy? (succeeded with folio_mc_copy)



-- 
Cheers,

David

