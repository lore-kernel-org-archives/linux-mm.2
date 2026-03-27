Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89D710BA421
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE0B6B00B6; Thu, 26 Mar 2026 23:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E6B6B00B7; Thu, 26 Mar 2026 23:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EEE6B00B8; Thu, 26 Mar 2026 23:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E533F6B00B6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:34:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B364D1B960A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:34:51 +0000 (UTC)
X-FDA: 84590426382.03.339B55C
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3FF314000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:34:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/gT1eEe";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TWDsxV9lU7FBIa32CWnztZa9knkN9tMw44cGL5HLts=;
	b=iXFeHpJOMZ1iMtB6X8p8gh20JjCid/WTqcy80XXOgeYCh8rRjRDQvdx4B56wR5K30TvYmd
	zi7lUCGpwxssAPg9uWozv2p2UdTGbBjw9FXdcHkViY8wyH6HppkPjNr7mFspJybW2jS09+
	b6B6Fz4kAcPISE9yPyhTkguwPM0Y2Mw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582490; a=rsa-sha256;
	cv=none;
	b=ld3AJ0WCAjwGmOIxrhPQssNbzcBEbzHGjStRfY2Gt3SBnDNd0mDp2KdiAZqKh73CAv0GAo
	qBn7PEEIkMEKvsZk0qDcAq2DRjvw+YoKM72vgiq76GqLZP8ERjtPyG2B9Eh8OkfgLUQbDw
	os/3h4N2nWI8qViwx9d0Qf7z2IixwIs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/gT1eEe";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1dcba0ef-372a-474b-8d70-23459f0f6511@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774582487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6TWDsxV9lU7FBIa32CWnztZa9knkN9tMw44cGL5HLts=;
	b=I/gT1eEeSyEToxNlVnMH/CCJCSe05HzFNgWKQFUlGhY6scwL4X6yf7paHgq/7XyJO3SNPM
	295kl4/TYQ1HT/bNr5evjmY0CbL2ZHx3LQvJ1UqEEUBKvShJ8GXELPnoHl9VJkxfs9m3WN
	p1t7HX2dffY2d9jJKwB6QxSFpOXagm8=
Date: Fri, 27 Mar 2026 11:33:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 07/10] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-8-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-8-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A3FF314000E
X-Stat-Signature: nkqp9z4f9d66ihspb6hck9dzpq971uxj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774582489-779907
X-HE-Meta: U2FsdGVkX1+8fWqtw/H7EFm3BQJUtjjFdySB6Xb5G1wTDyFUMViL5Vw2lOoG9MHUB1UoAQdaZY1Tl65GsAhI1d+B0/zcfigfNZZWvORjVMv78I7GnTIJ5inT/Uum0pOsV36bTKWG0ue5UpzH1LHYzjmP7KuCIldWu0UAtyuPfyaN58AkF7NykqysGGI36g2eOHqFJTlNaijU+ot9qHYlcKPpPwEqdQcEB2Edf066nesCN/D+Xvk3O4W5M7n0v+OB0J1s7I3FJoJajMLvXwNmSO3c7o65q7uufMRYUixdc3GcUs0z+fdh1S1lblFQ71K4cNwz/asVG/IQ8rB5N3OYRNree6Bx+8cybMzidvVQfwaZE+AcX3mBeU0DUzb+PkeIcm7Zx9aLt4LTHlGjNFfGzhId7BhlzZwRk8+oNU3DHpMHwx6kwVea9qG+03brR3O3coWOCxseuQvGylBV94dQfQe41WxGjD2Vd2sBpbGoyFyr/A4pKks9yKHFpNRNduyPx3LawdrcZIY+M/lMUDqL7w+45vugEvfVLADZQn0dZXdqoVDuA6a2l4daP6ojooCkHJMDy4BO4KgV4SFtdtlfDHuMVtviq7O9S6m7Yt0eysX6oyKi0hpSyC3ftBnt7772jPZEg85XpYIEfEyNSSP0w1hCeyHopo9p/YCM9T09EZWhp5askEUR0LSPSbVEHDwf89LYLL1xSMljupbRamX/nTTHq3L/rE5xtiKtRTtAb8Z+UKb+NSMDHw7nWwztwJUtu8fSRPxfIFOq5FYVo9ayZeadfWk2jiKH/4PxybJqrUc1VfndOJe3AgyN9lywsXsYqcDvba3Z5zprJ8MvEsupi34W3Ho/0Q9TXrlRhlcbTWoArTwfDAmPG6xBgA/dvldHU0KL/SkNXq0iAlt4oPm87XKbIepOMgxN/2vuGQjED58IHyf9zhLxhbeqLF+KOyuLSc91H8i+m0lv4Xw/aAI
 FGIwoNrv
 bw6C6pEdrF3igWg7S8vXjvQ4TKbPLV5jI5S7aSKHcU2Fp3fUAts+ChhFWHTZ21xSK8xKYkXuKDmq2JhIOudwNJT1Fwxw/Vo3rkDSVx6Jyi8CXFdXolNcs6Wc7Fpu8XZKwI33aHVrOxUy59flexSXiM+F4huapSRgo1ZmoYIfXW1FIzKdvXSYGW80V+1jHI8x/aSymbruvLZUUttMQ8mDVXFQGrtToF5PmaAhbayJM0waPPxJ5gbu5Vf0e+cjRH2FrtUY0GozcHgFKyRfrMExlSoUnAFXG1rP81G+Vfe07qk6/cnPSTaqyTkovtZKbYtmp3Tqo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/27 09:42, Zi Yan wrote:
> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
> not. folio_split() can be used on a FS with large folio support without
> worrying about getting a THP on a FS without large folio support.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h | 25 ++-----------------------
>   mm/truncate.c           |  8 ++++----
>   2 files changed, 6 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1258fa37e85b..171de8138e98 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -389,27 +389,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>   	return split_huge_page_to_list_to_order(page, NULL, new_order);
>   }
>   
> -/**
> - * try_folio_split_to_order() - try to split a @folio at @page to @new_order
> - * using non uniform split.
> - * @folio: folio to be split
> - * @page: split to @new_order at the given page
> - * @new_order: the target split order
> - *
> - * Try to split a @folio at @page using non uniform split to @new_order, if
> - * non uniform split is not supported, fall back to uniform split. After-split
> - * folios are put back to LRU list. Use min_order_for_split() to get the lower
> - * bound of @new_order.
> - *
> - * Return: 0 - split is successful, otherwise split failed.
> - */
> -static inline int try_folio_split_to_order(struct folio *folio,
> -		struct page *page, unsigned int new_order)
> -{
> -	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
> -		return split_huge_page_to_order(&folio->page, new_order);
> -	return folio_split(folio, new_order, page, NULL);
> -}
>   static inline int split_huge_page(struct page *page)
>   {
>   	return split_huge_page_to_list_to_order(page, NULL, 0);
> @@ -641,8 +620,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
>   	return -EINVAL;
>   }
>   
> -static inline int try_folio_split_to_order(struct folio *folio,
> -		struct page *page, unsigned int new_order)
> +static inline int folio_split(struct folio *folio, unsigned int new_order,
> +		struct page *page, struct list_head *list);

Ouch, that ';' wasn't supposed to be there, right?

