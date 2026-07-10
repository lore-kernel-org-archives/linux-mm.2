Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE2BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8CE6B0099; Fri, 10 Jul 2026 08:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569D66B009B; Fri, 10 Jul 2026 08:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431866B009D; Fri, 10 Jul 2026 08:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20A966B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:19:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B29958E1B3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:19:17 +0000 (UTC)
X-FDA: 84972771954.13.D476D74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10EE380005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:19:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkbJr3bI;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N98wGrE707jKJzOkryDJ/4dyLXX5GEteh/ZxqKgllQc=;
	b=Lv0Td4C44kNkCMLzV4JEl0thBW9ebmaMOn0O1/NVobnxlF6UioHXotxgc7aZkIb/Ii3W2/
	FL5z/o7nNSsygNtAUItEWnMw3VQV+VFlggu3gIpQfc633Bpxd4gDV+bSWkFy6O5eQY/HL5
	FcIccSG77PLZ05AgLHNh+YHN3iqf/6Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkbJr3bI;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685956;
	b=TODgsunuCwOagn9A9GyQzrjsMAYV6Y7SLq2w+eGN9zaj9JpJipptEvc4U7Zy92LJXYWsZ+
	Mu3vGMw1si8Y6zSk0qS2qR3bJ5YNjzQnBpRHIiZhIB72liHQBIbtPLX3E2rmXk9E4bezTW
	7+kmYLNS0b83HODebAQq1jIIW30JPvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EFA460051;
	Fri, 10 Jul 2026 12:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181F61F000E9;
	Fri, 10 Jul 2026 12:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783685955;
	bh=N98wGrE707jKJzOkryDJ/4dyLXX5GEteh/ZxqKgllQc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jkbJr3bIFfjEmW31xuvFvY+BEyMHKDjY+fC/HxDZwaSaFarIAhQQycjm9MWTz/hyj
	 xq1I764U/dckWfiI21cQUCjXXh40c/ukIkYnol20vyGJWlKA/RQCJQ2cVRxqbFJA65
	 IqUNrLQFtByl8b35x3WNGT+ZZaD0f8G4ABQRvvPV/jVN7W70Da1M3qWYZ8kDlLxXVq
	 Un5Y0Ih84E2YhGvA9aUxuhNn9cpfTLVJLP84SzQdy7ivoGDp9V7GOF51D90nlxVidK
	 pL+kOeVK75CVmLWwoDzpO0qWL4ceXd3udufW4S1uiS0+FQz9cxHkOCPizjtbgC8TZm
	 Lg+hEGqxmDj+Q==
Message-ID: <17de0520-5297-402a-83b7-9d8c3af61994@kernel.org>
Date: Fri, 10 Jul 2026 14:19:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm: mincore: refactor mincore_page()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-6-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710120052.103886-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10EE380005
X-Stat-Signature: qaxipj1h5uoeirqn3e34ouwpr3z6znbh
X-HE-Tag: 1783685955-527778
X-HE-Meta: U2FsdGVkX1+qrNXPsw+ux1+34JiwLuVHd0BVxUWrhFOwy2mmWI9BOpdjeRTHk3ouvcOylBS8+SKx6CRtrVcVCYiRrdo2cmYJuZK+LtfxmOACQKDDgNac3s/CFuU4qjD30c3tMRBUHgKdtpg5SZCbym51caobHor23PQgQ5shg2Zm7jnDjc9Fga+MiKOheKhpLVQ8j3SD7SwEs/agnUyBZBVPXynHTwl7xuVcce1hqQ5U5yJ9Ns0XFkF4N47U7FxlYsMqq4adcr7i9ViVZb3fBag9jy6qP+xSTs+toj4jBdS9bvbnnogsNKLOQMT4cVuSZUc3E4qYttQGmeihgo+P7enDzKKs1/2TFGn/R2kIytH6Bd/2rDN3SMeUDsZ1kcc9349yfih9YGu0kUnqLsFJtCSk7VcnV3NRFJXAj+BcZlCfCOR1mrff5UzinWjCsixUAYzr+qGPrY7oYNtRbaK9LFjlj9xrH35ONNzJa0OirjgIiMCzmcEmDjQxMiddw/0BLgxD9s4SSHVBVYi/WeK80JhXW+NNbk7ePP5kGV8y8wAUAqCpp6kLE3hCwkazkTl58daqNdWQuhxG3K5tT/lEesxU1o5zl4VYiLimrfbzdRv74akS/TnjXDnp1mtDUU+BpHRugyN7gerMd4aYFvuKSopcyarSrp/ntir9xXz+M58ZbVAqgo6p8S3r69eRoFry621oj4cI3gbWTaVe91I1XTkBrHsQoqX+5a7Y8HA8Ng/wtTogQrR+bhDufvTAHI+HGGOAcWFxMwQs1W7j2QkP/355uQrhn1VeC+gSmYTahnxDRDuYDsfB8UeB7eQDYBs1cbnj9VhgfaZjpAshmwG55Bw6/Q8Jg0I8x2b90RpALF95DW9x3JCJ7qkw3y0HGGZSKyINiYtqLSABEWWXyU/mXKoIgTdOLlUmz8d+9KrfvrtR2BYzxzN21uX7wTAcW7hzVOvfqQmij/nfqQQf0P2
 +YqyqqYp
 tt0TqiMA3atMoO3tTgwwTBn4euz0VqAfrjesFnyrzgR+JXsogx+2BDcqhel1jieT306ZijjfydirzIbWoR4L5QgLKbmbGMz8HE0NiHq6fYQgVGRr2Z6kiH1rAu7pfD5c0NeC9DJXPIJOZVHI0MRrqcwwLU6zL9ZjmSTWEvHCXBRk3mhR0WTURjMbvzejdQwq1ENDtsCoNOil4CdZdnQU/KjuoqISFlhLCsqTRV8MJ1Cb48dnnE9eq5PP6T/akLZxEtY8mF+iBhTpHxFrEzRrHJXrSZN0B8l4NPXNSVJEFnmJ5pRl5wNtQJXetIo4GcmGgBB9xXMvp9qM9pGD2Fz7G631M11/t7c/wAUa3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 14:00, Kefeng Wang wrote:
> Use early returns to reduce indentation and improve readability.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 9952bc3edf76..30a3317082d1 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -94,7 +94,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
>   */
>  static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
>  {
> -	unsigned char present = 0;
> +	unsigned char present;
>  	struct folio *folio;
>  
>  	/*
> @@ -104,17 +104,16 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
>  	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
>  	 */
>  	folio = filemap_get_entry(mapping, index);
> -	if (folio) {
> -		if (xa_is_value(folio)) {
> -			if (shmem_mapping(mapping))
> -				return mincore_swap(radix_to_swp_entry(folio),
> -						    true);
> -			else
> -				return 0;
> -		}
> -		present = folio_test_uptodate(folio);
> -		folio_put(folio);
> +	if (!folio)
> +		return 0;
> +
> +	if (xa_is_value(folio)) {
> +		if (!shmem_mapping(mapping))
> +			return 0;
> +		return mincore_swap(radix_to_swp_entry(folio), true);
>  	}
> +	present = folio_test_uptodate(folio);
> +	folio_put(folio);

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

