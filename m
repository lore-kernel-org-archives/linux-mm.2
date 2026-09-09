Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5789C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1C46B0092; Wed,  9 Sep 2026 05:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89BA6B0093; Wed,  9 Sep 2026 05:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0446B0098; Wed,  9 Sep 2026 05:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0706B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:36:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A6981A016C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:36:36 +0000 (UTC)
X-FDA: 85193718792.21.EEBFE73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id ADA6D140003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:36:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qb/l7rzW";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61cn5W91VBgvdwAX5AGeN1SkiyX6gawVNp1MxJrLTEc=;
	b=fDKAwuRiiR3JbGIscMIR+W9L68E+s9Ycm+ZLg8dNBUw6W3maHWHUDT0uvXdeZdlmnU0ezU
	+Z0JcT6aGgxhujOdrhYKDK7B97kc1Z++/pUDB5V5poiWSoz68Q8uNOtzffQpmAZ3r147M9
	9733BlqNR0Stumuekhi+4YH4uiIFLUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946594;
	b=Xv3oWn5J3iZjQTxcXCF3Nsi00Firtd+f9R1Y5pxVOHkJw1/9N/gUxsr6OQrDxjMyN6uV56
	ggRaUc9JN2jUfhjPXkwcZhPJiYbKfizbmNVceZ+R9mSqn/RXNgQRFCwQ7W+R9n05XmFTaJ
	LJJeiMo37TP352xyxUHKMgo+JJORgxE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qb/l7rzW";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7D7043825;
	Wed,  9 Sep 2026 09:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518AF1F00A3A;
	Wed,  9 Sep 2026 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788946593;
	bh=61cn5W91VBgvdwAX5AGeN1SkiyX6gawVNp1MxJrLTEc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qb/l7rzWJ5jbqv8kKCDnAS6EuQ3N4KRM9M6u68pQwe2chd8OrgoTZKKpb5eQ3HzPY
	 erNvfk1LZ29flRIIMHMsdmRijv1d2gQ/CFcYqnFXcWFwmUqxwXAr00M5yPw+jENdHr
	 mitXp+TI8vZtJbOyiHFndFgJzr8q5gJ/0+7g0kMOC9V033D9F7eVTUQfSmh31yFS7t
	 Z3QLs6LyQWRUfP78dzT8o2Jg9a34VdGDp7iVITbIZMg53eWsLhCzJ70VTZ9FBfLxI4
	 /rPy6rxpcFijryXs3wqZ314cxXvJemCNFAcWmib7LWrO9UGG9bHDmdNzngJhp70/Cd
	 EjUwamppEjhlw==
Message-ID: <c465c8e8-c789-458c-8053-4f0db90069ed@kernel.org>
Date: Wed, 9 Sep 2026 11:36:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: psnx8j5so9zmuqmdg9zn95h91rhdhnbm
X-Rspamd-Queue-Id: ADA6D140003
X-HE-Tag: 1788946594-244436
X-HE-Meta: U2FsdGVkX19AP53g5/6E5PGe1mUHpBILGEEfWnxLliB/uz9aYER75Py2EBEUtdZrc7d2TVkOpw/YT1LG3ynYi23KAkIJqqeJOQyrVecNecuoH4w4YWUhaQtNjTk6nx6EQudYEs64Sj96qHVd6213xxo3YTzwgG4uYb2fVlnpd+Eo33/OKZTDi9nJ3gxtE39e/ytUTJ/YiQ7MkQkTuBbC4xeY9pj7HcQxs/KEwNxMfhrqdPO87uL+RtQXxEk9HcVVhC0jcteaXbqZy92hx6mxb6dOUNHlAeVRFLu6s3Iom0Lc5YOv45cm3FJsZUx8hhOh59/q5suDHqMj60dhNnGmc3g+xKsm2cB8Fxk7uA12jPRERwa4UumwC/5yKu+Fxrn4wrPy0i0X9kQapCce+Ote2WYQ65mfMMlEE3jeux4B+P1v9AbXaP2gQu7D6aqIwVtaChfithWBFnScB4GFQKZt6UE1L1skeCF4EUsWgxz0dj7XMAstF5pnm4NBigZbj+cnmqDiCxvzBKpJfC1Yr094nDThlIW9JUAQsPIGKfX4ylvrPW23n5JRCa0RMVU7V6RTz2CpwHj38mMmhGkUg43hA1feBExDil+zPC9ftMyU0frhq5BrfU6zhJokkDvS33Xsr26RPW6QAvoEWzyzu7Y7F+mc6Ilir82zHud1zvujlGOh8Pn//vYqIzcZ6p7IWP+mo2uwPhP9XYJZkSjHHxyhOZVFt67z7uKBfJEJ/Y0cj0b8cE/eLlrWAUNMk7D28sO9MyMbkMuHn9piBC5V8PCXrJldnIW4ZrjO1dbpHlEjCHVyRYz+g9J5mqxVaxYQaSi76ayN0QXm8OD1lwTbutSqtwnzWMpTHam+tKWmgZlTnfAChoWe6T5TbC+hia0du1iDta4/I3HK33rkePg7+K9WM0F3dLMUcTUuUEMU8LPb/IK1z5HgpLgTXQ66BWeI2T5+QwVY0wmecQkseU1lzQT
 YnkilWlP
 xRCmXCdESRqzosmtcGDuniY+OTydHo/818cisu8MVN7ZsHNRh2UHP/nr93sswD1pRlTfcxF93p+idBTLl3Dcg6Rl/xeQvZm5+CpYyBBeweEg4fCwVoGuLsLwejSqkqOE5L5bxMqWtUTQLjSvCuUW5b6DQN4cx3tzZoZwXqKf4FpfB+OBwiGhfLRrh6zpstgtfLmWPJ4GdQ7F6Tm9+lsCa7ZbKzuP4iuYK0Z04ZucZgI/kT3qGpTxSrPno5loHmourNfmVLeHNwsRJcUAkmkNXk/YG5okuoU6pCVoymTO0K1DVKOulEdnDnQ53RLYjj2Jz8FaU/X2+6XityjCvLsLheqyaGjlIExuWKafdvfrJyUuctrAv5on8r3Mhluvyaqv/Yyfc03MOYln8cuzpOdd0Ud1gWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:45, Muchun Song wrote:
> memmap_init_range() initializes every struct page in the target range.
> For compound pages with vmemmap optimization, the tail struct pages are
> backed by a shared vmemmap page.
> 
> Initializing those tail struct pages would overwrite the shared
> vmemmap page contents, requiring users such as HugeTLB to restore the
> metadata afterwards.
> 
> Track the compound order for HVO-backed sections and use that metadata
> to detect struct pages that fall into the shared tail vmemmap range.
> Skip those shared tail pages in memmap_init_range(), then initialize
> pageblock migratetypes for the processed range with a helper after the
> per-page initialization loop.
> 
> Keep direct mem_section access inside sparse helpers by exposing
> pfn_to_section_order() to users that only need the order associated with
> a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
> without exposing __pfn_to_section() to !SPARSEMEM builds.
> 
> This is a preparatory change for consolidating handling across users of
> vmemmap optimization, and it also avoids redundant initialization of
> shared tail vmemmap pages during early boot. That early-boot benefit
> appears only once HugeTLB is switched to this common handling, since
> HugeTLB is the early-boot user that creates those shared tail vmemmap
> pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v5:
> - Add comments for pageblock migratetype helper callers and shared
>   tail vmemmap skipping (suggested by Mike Rapoport)
> 
> v4:
> - Rename pfn_vmemmap_optimizable() to vmemmap_optimizable_pfn()
>   for consistency with vmemmap_optimizable_order()
> 
> v3:
> - Replace the !SPARSEMEM __pfn_to_section() stub with
>   pfn_to_section_order() (suggested by Mike Rapoport)
> 
> v2:
> - Fold section order tracking into the first user instead of keeping a
>   standalone API-only patch (suggested by Mike Rapoport)
> - Rename page_vmemmap_optimizable() to pfn_vmemmap_optimizable() and
>   pass a PFN directly (suggested by Mike Rapoport)
> - Initialize pageblock migratetypes from a helper after the per-page
>   loop (suggested by Mike Rapoport)
> - Use a 1G PFN chunk for cond_resched() in the pageblock helper
>   (suggested by Mike Rapoport)
> - Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
>   it returns 0 when HVO is disabled and lets the compiler optimize the
>   code as much as possible (suggested by Mike Rapoport)
> - Explain why the !SPARSEMEM __pfn_to_section() stub belongs here
>   (suggested by Mike Rapoport)
> ---
>  include/linux/mmzone.h |  8 ++++++++
>  mm/mm_init.c           | 40 +++++++++++++++++++++++-----------------
>  mm/sparse.h            | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 5fb9b37819d5..df31cac12311 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2022,6 +2022,14 @@ struct mem_section {
>  	unsigned long section_mem_map;
>  
>  	struct mem_section_usage *usage;
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +	/*
> +	 * Normally, sections hold regular (order-0) pages. However, for
> +	 * sections with HVO enabled, this tracks the compound page order
> +	 * to enable deduplication of redundant vmemmap pages.
> +	 */
> +	unsigned int order;

order is a way too generic name for this. page_order? compound_page_order?

-- 
Cheers,

David

