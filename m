Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A290D1A61E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B206B0088; Fri,  9 Jan 2026 08:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27FC6B0089; Fri,  9 Jan 2026 08:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A166B008A; Fri,  9 Jan 2026 08:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAEA6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:19:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 413771A07B1
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:19:27 +0000 (UTC)
X-FDA: 84312481974.10.B54C2BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6C2C980010
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:19:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YUSONdW5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767964765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ioXowgmpNI0UKX6q4o0eJgu7Lpuu95sk8b6raaeg3Qg=;
	b=G8+fMTp6/Ww8j7VrhRae2HJYuTqgvzG/L24fxlzcGoLGLBHfpHmFN9swRoFvkYIBVh34RC
	8HW2ZHMz6vUYcRUBOkSwLJ1PZVfahiPC2+oT0hQKkuw6pVNLtyCNoKrbVzSkpsMjc1uFqo
	VZCXI5yO/i5G+7ZBRhbxr4Hfk2UGZ9U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YUSONdW5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767964765; a=rsa-sha256;
	cv=none;
	b=EHzIADYE6mupGI7eiQVNHs2QYGgNAiULDsJa1l7WnVYiZeY+481Lfogy1I6kEwPiOUnuTq
	cuW70D8yBQ9SiUMfB9q8Y5k/YklIjl9mRhVqhEomWb+00vZc9ZQMDSPaZ6ctFR+qYFc6jh
	AMbNecADE/augKXE18BBOPBBpL7IzvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4757643A0F;
	Fri,  9 Jan 2026 13:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83ADC4CEF1;
	Fri,  9 Jan 2026 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767964764;
	bh=dOxdIeEYnf0HHhRSlCVN+8qvKXOjd/cuc/y3jSDfBf4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YUSONdW55AHnI3b6E7AM+H4ziSAbRNNojnS9YaKKU56OSEAVcyjGNmbj6ESfHJ3V5
	 xf67oZKNsHgnOLFuemh01jIB8kvlYYLup79S+W+UOwzKpa/XM91lGXBwGEr91CArqJ
	 dNtKCj7HeuNPuSE9dlKijCprNkLxX5uoFRilwErcAEIWAGVj9sNDdAxO7DQ6ZhTPZt
	 04mQOhkgpmVlqbCRpYUPBFRYvsMqel6SzBsAaCB4Fs/b+9EZ2xUWtLOpD8sdViTUGx
	 nJJw7wuj4MIEt9ouViJadObqt9nlWeGsYHnGauTsWRL37Gq9GujZHd5hFuHKr1mB3C
	 Hn3TsHoXRQ0FA==
Message-ID: <59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
Date: Fri, 9 Jan 2026 14:19:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] mm: Add folio_split_unref helper
To: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Balbir Singh <balbirs@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alistair Popple <apopple@nvidia.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-2-francois.dugast@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260109085605.443316-2-francois.dugast@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ba3wbps4to55e8zrw13kcyaeipmf44tk
X-Rspamd-Queue-Id: 6C2C980010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767964765-921542
X-HE-Meta: U2FsdGVkX1/0wPtriDnDxMwJCgFrePOATKibhkxsdYdD5PKhghDED7Vh+Kkq3CJGJ6EVRlBySclOk/3GOqGnqvMzcFt4CKjbhK93BTHYUN4EzqlerLXfKHtZzRUrTZfJZA8S47lkeqvBR3mqURdSnCVjO2905dfNwit5oAiro14SUR9LRgonl0CpP9CmhtAGB/cIfgWuFPJ8IZ8QN/YFFzcSzP0yw1FehbXE7vxX7vSvCS+r15za6I4gNMKeG1MvQN8APQTUkvK+dlL+drkPocgmX6S3FRG7C06G0RcWGEPUOZTeiP4xB0JBrU4+EsbA8BH2NZUrbnXD4xF1byfIi9TFIpGkDl40sjjMEgyS2qcA1Hw6egkfm6MLWxMUY8AXwJeQf4uGvhKYYq/JxBpMx9RXuO4agGsvymIP1p8vq5Ml9Y3vDXVfNM1hGFMXrU8p4ZL/jGO4Ph7iL/osL/64c0lGmyIAfdOfu0Yezu+Dt4vCgfEnUsYYw3IQxbO3+sD0iqEVjQhhuiXLToo2mh6uifGr9iq6SVBDOIl6L+nfs2xlROUGLHJnXluZE78I0vrNsa5Iemyjbgmtv7RPr8ncRg0rA4W4qfv4twPoApyqLvpmHwUvVmcRFXyHTKNWX0nmHOckpHaDEvOVjbc96Oeu9Xfhs5Rzm9EsuH6JoLWJqM+XLJUxOLe190C1QWfNIhUyALz3UdegmQRRbnG/QucFCCTbLv07bfHTh5Cchl90B3gc65y4L4IbgRbSa3JFXV3fAz40RIdbwoXq3MOrTgmm0Hrsgl3lP51busgqNd6pdf66dTYoUEI7XGpY3mteVGEALpfM00f85n9ruHFOzZYM7yt1pH8takI47uDKTZIwh+78rc/9S3smbo5OKO2XA1/Iunr2tHwu4rBbvbIXpoI1oNIUfmr6FrLYRlZEpfhCElVxsbbxsRoYBRLNY0R8T1p6ugEsnPkJlbeQG+gUkMQ
 v0/1kB13
 /tIMtdLwt5eBvV2YvHseaSPAcyzah+u5CgPvoKbZYUOfVMNda6ROdmzI6yzWMGOCPEKY21OstjDJoz5ktbW4W7rGYsDVH5N8QgxaFV6HWkQTwQHsNHFEwTzrpe6t5N7dcqeiQJDL7A0TbiYpaf55Gfan231iTMbp/QVHAPsEIZyS/YTgGj/157SVHMuZEmWSv+wFTZSGrIWVGb67/v7PSNN9KAJKmGZb66LHvLe0NkW4bKxDhoCvw7E6UMLbGQqfssM9f8CggRxXUm0BfGrB/7ri4D6PVku5vwRwPbLwWLVSlhP9aYaMNywlF8VD6qMJ5ZxYN+I76kcukGF+u2AYqEhg0ZRiEtmxGfZmjJvIzb3F1VEQtwUy7+ECmnm5ctpDv20dox4ZsqBpirLgwWKAVRA5rt7uJQJd9Rr8aEXjkBBdz9vcYNBoQMpXtocbub/B/oyGvNpUY2BI3xxPezbg+oznNe1Lhb4EqVDo4JT7+wBe7qSKoHg7dKK/SUeNoZWjn4aC+Ic6ZeZzcRTs1jpmEfxhEBl83AZDPQRoeZiEGHFFAVf3Pc4+ku9no9Jvp2H8rMPkpZ3H6zuaAftmhgTRBB86/qu5IcYM7M+YZFUKbdsRaqEOy0jVnsA5SoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 09:54, Francois Dugast wrote:
> From: Matthew Brost <matthew.brost@intel.com>
> 
> Add folio_split_unref helper which splits an unreferenced folio

split_unref reads like "split and unref".

You probably want to call this something like "folio_split_frozen" ?

The very definition of "frozen" is "refcount = 0 ", so you can simplify 
the documentation.

Are the folios you want to pass in there completely unused (-> free) or 
might they still be in use (e.g., migration entries point at them during 
folio split)

So I am not sure yet if this should be "folio_split_frozen()" or 
"folio_split_freed()" or sth like that.

I'm not CCed on the other patches in the series or the cover letter, so 
I don't see the context.

You should describe in this patch here in which context the function is 
supposed to be used in later commits.


> (refcount == 0) into individual pages. Intended to be called on special
> pages (e.g., device-private, DAX, etc.) when returning the folio to the
> free page pool.
> 
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> ---
>   include/linux/huge_mm.h |  1 +
>   mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 40 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a4d9f964dfde..18cb9728d8f1 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -369,6 +369,7 @@ enum split_type {
>   	SPLIT_TYPE_NON_UNIFORM,
>   };
>   
> +void folio_split_unref(struct folio *folio);
>   int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>   		unsigned int new_order);
>   int folio_split_unmapped(struct folio *folio, unsigned int new_order);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..0eb9e6ad8639 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3580,6 +3580,45 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>   		ClearPageCompound(&folio->page);
>   }
>   
> +/**
> + * folio_split_unref() - split an unreferenced folio (refcount == 0)
> + * @folio: the to-be-split folio
> + *
> + * Split an unreferenced folio (refcount == 0) into individual pages.
> + * Intended to be called on special pages (e.g., device-private, DAX, etc.)
> + * when returning the folio to the free page pool.
> + */
> +void folio_split_unref(struct folio *folio)
> +{
> +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> +	int order, i;
> +
> +	folio->mapping = NULL;

It's unclear why you mess with the mapping. Usually, throughout a folio 
split, we populate the folio->mapping to all split folios.


-- 
Cheers

David

