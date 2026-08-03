Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1053CC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2309D6B0093; Mon,  3 Aug 2026 09:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2082A6B0098; Mon,  3 Aug 2026 09:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E876B0099; Mon,  3 Aug 2026 09:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE9126B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:12:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5DE9A0665
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:48 +0000 (UTC)
X-FDA: 85059448656.06.9019179
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 02B6C40005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+KN6TcL;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785749687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=382LMWt504+2jkfqSbYK7EUjiXjWZcpNaa+hKKGGLFM=;
	b=h9pI2X9r7p3Rg3hNPNahlIhRcU7dvuLULhZm2y9RUWP982Ew0huk2hG4o8ZfGJQW9owvG/
	z33xXIvznx0ePEYRD0oYDpUeEzXGG7duLyAd/ze+YUGvrHFRltAg+Dtim6K5SvzMrJQfzG
	QyNA8Tz3Aixf2WcStSrZhHBoNiQ+17w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+KN6TcL;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785749687;
	b=0TAYfkjdTlVeujZA8nhhk0z1ICN1KA+nBFmzwAJd01/j4bxTk95KqS6IHH4vruU6Un/Gov
	nSuUQTfIuP8KG/6t6gedDmAr7VzY3d/yCPp7vaZZus3R1GI6bAIAfAU4lZoN0Mj9vrB0jg
	pS8bkeRVcppWVZB6dq7S2q/lfdnmwWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56BDF60A69;
	Mon,  3 Aug 2026 09:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33121F000E9;
	Mon,  3 Aug 2026 09:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749685;
	bh=382LMWt504+2jkfqSbYK7EUjiXjWZcpNaa+hKKGGLFM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h+KN6TcLykHRka+xeosMd5gaCISdNmI1P19kqrM8Tiw/DcRiI3i69fuenkkHVrWei
	 0MNjjo7PEi7K5845/dexpfVKFQreJo0po2TUOeCK2AkgJISKcwhoWjIJDgNSlLpDt0
	 7/NTrTewIVEEl/PTE1KnTZ/CLia86wzMih+xie3c+pjQgHCZzu/sfdQxxcD+lmYFIw
	 yGYa+Y+hHDLfOwaiFpMYgVuMVx5oj4+WQxlsjtdseNBlApj0/+KVtrcFu+EOAKl+Un
	 4jzt4K/x0dWhJsL6siS6/oNjJ2HOHFXxXsH+rCfZgWkOYLpkQ8LlyVjhgDKPuaTBlF
	 LEGXV+7FKEcRA==
Message-ID: <e01ad01e-715c-486d-9a26-1126c666947f@kernel.org>
Date: Mon, 3 Aug 2026 11:34:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/15] mm: introduce linear_anon_page_index()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-2-e8ecfefea812@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-2-e8ecfefea812@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 02B6C40005
X-Rspamd-Server: rspam01
X-Stat-Signature: utef17d1jt9d41pcdimozzx7ohhpdd6f
X-HE-Tag: 1785749686-310305
X-HE-Meta: U2FsdGVkX19giWnlPPEZKGBGXsfjlE+iREsn95XwQEpF0lUap2Y2hAjrEssU4CJT00OU95gaLI3K0olVyM390T3iBqQlq+C7tB7ZZq0aySwZUcfpkv/fNg4Rt6wFFF78GXIjRHBz4j3lQtNKL0Nu4fJOzUSuWCpvQ59OuLac+qyRKyK27Ch5VL22Eus0WovJnOD9jZvoMO8OGAbmUB2EL8OgV5mTLJ/Uh/fYnXewMrXSmUt8gkOLIUfjdBO/EXkYCjNF1AtcM5otLRfE9uOCIRzOwP3BDDGhD2NKKQEinj5vA7UQ96tPLnUsJ96evgtgeu0rNlbsu8cr+Njo4ADIHIH2XnZYMnGmK9PyKtY5+sQsO44hawsNcGGh1DOmSlrHOnTlhrcYse35LSTaWp4Q1ChQtsL0/EvdNYBSTz6FzTh6ZJPqQ879kQRFhe1wba2W3gjnVPAItiRmncIpNmHHvH17O1IHF+TBPkuyC44M+QzbRJhdLgw/MI2hNi64MnsBg1RvuPbRKKc9rIoDlehlBBFOU1pd1lQrToLEHGT0hFaX99PVe0TdohjEbPhqz03adcfNK8NOLektHb8E0p2OjsX72eihFi/a98l0Dppk/SaRxR4tuNSJbTBjSXDY+mpGGOpcTROlba00R9Mx7nYr553q6JBXKYIBa+zP5ywem9DfunPsrmyhU4mmU1k9x9waYfZhBybK22qHKzbsy0ixtrkNTTAT6frWbW1Dcnqcw0fRyYz+g6vsBkf1vbtDgkvNtph/O6ytPR5aUsqbORNA1dn55B3B/YuCH50XxaoyiVsbR7K75BpbT+I3sCxEqOO/zUW0WqbwfsqYGtqJmYsEuQ/rptpX3dj8TNbgkhfuqikBhS2NR8VfxZDciXRa71bhkSykFTEqg1q1AWQAWNHwLZMx1XB46qF4syGpclhtoOGEFb+EhuhNzbAvS731QJIcqWkSLL7aL/F6XlNl2PI
 0uxq0+IM
 9EQA+fRPL5Xs96UvF9SJX8f0ga54fNiW6OQpgzw94bSE3fWQRb1oxtRipojdyYWb911u+4X78cvEpxQKgZW0SqAkBDoEcPi+6YMv5pHoYl3KB3NUZZPXPaD2YQaXz0rq3N7yV4vZOPgKgYFcR3AENM+Uk0onqOYIlYahYbpaSjoDq/IwzEq0dJQYtPt8ZhLbhjcebo/Ku4QJj5ezyxIKF1PMwaga/ZlJCLuaj+W/JpVIJ3ZuciA39pnI9fGm2TtjIKrfgM4zLlzY/W0b3QeDcbjxcbiwEZSf3l4Mav8ii0JxRe5Lu/cUeQ3Ad8tiYZgI5d7KYdAl7l9FKYn3+9FQsdrrPBFuSQqtgp0IS/s7lWwKjataKHAvKwMc7Bu3vaNE5gY4LLYsoPCOC6Hj3mZi4waLF+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> This function provides the anonymous equivalent of linear_page_index(),
> instead offsetting based on the anonymous page offset of the VMA.
> 
> It is valid only for anonymous or MAP_PRIVATE file-backed mappings. It must
> not be called for shared file-backed mappings.
> 
> For pure anon VMAs, this will be equal to linear_page_index().
> 
> Assert that both of these invariants are true In linear_anon_page_index()
> and implement the algorithm in __linear_anon_page_index().
> 
> Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
> but not fulfill this invariant, so when asserting this we check
> vma->vm_file to account for this.
> 
> We do not update callsites yet, so no functional change intended.
> 
> Also const-ify vma_is_anonymous() to make it compatible with the
> const-ified linear_anon_page_index().
> 
> VMA userland tests are also updated accordingly.

In general looks good, some comments below.

> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              |  2 +-
>  include/linux/pagemap.h         | 42 +++++++++++++++++++++++++++++++++++++++++
>  tools/testing/vma/include/dup.h | 25 +++++++++++++++++++++++-
>  3 files changed, 67 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index df78847f5f07..64214191e7c6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1556,7 +1556,7 @@ static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
>  	desc->vm_ops = NULL;
>  }
>  
> -static inline bool vma_is_anonymous(struct vm_area_struct *vma)
> +static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
>  {
>  	return !vma->vm_ops;
>  }
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index c6fc783aaee5..259177544b03 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1101,6 +1101,48 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
>  	return pgoff;
>  }
>  
> +static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
> +					       const unsigned long address)

Nit Usual "two tab" comment (same below) :)

> +{
> +	pgoff_t pgoff;
> +
> +	pgoff = linear_page_delta(vma, address);
> +	pgoff += vma_start_anon_pgoff(vma);


I'd simply do

	return vma_start_anon_pgoff(vma) + linear_page_delta(vma, address);

> +	return pgoff;
> +}
> +
> +/**
> + * linear_anon_page_index() - Determine the absolute anonymous page offset of
> + * @address within @vma.
> + * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
> + * @address: The address whose absolute page offset is required.
> + *
> + * This returns the anonymous page offset of @address, which is the page offset
> + * the address possessed at the time the VMA was first faulted.
> + *
> + * For anonymous mappings, this returns the same value as linear_page_index().
> + *
> + * For MAP_PRIVATE file-backed mappings, this returns the anonymous page offset
> + * of @address, which is the page offset the address possessed at the time the
> + * VMA was first faulted.
> + *
> + * It is not valid to call this function for shared file-backed mappings.
> + *
> + * Returns: The absolute anonymous page offset of @address within @vma.
> + */
> +static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
> +					     const unsigned long address)

Dito.

> +{
> +	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
> +
> +	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));

Could we test or COW mappings instead?

VM_WARN_ON_ONCE(!is_cow_mapping(vma));

Because we must never have anon folios is non-cow mappings.

[...]

> +static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
> +					       const unsigned long address)
> +{
> +	pgoff_t pgoff;
> +
> +	pgoff = linear_page_delta(vma, address);
> +	pgoff += vma_start_anon_pgoff(vma);
> +	return pgoff;
> +}

Same comment as above.

-- 
Cheers,

David

