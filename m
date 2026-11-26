Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB0D606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DrBHLsji
Received: by kanga.kvack.org (Postfix)
	id B62E56B05B1; Thu, 26 Nov 2026 06:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13A36B05B2; Thu, 26 Nov 2026 06:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03266B05B5; Thu, 26 Nov 2026 06:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7876B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:54:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C11C1203ED
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:54:20 +0000 (UTC)
X-FDA: 85477112280.03.AFCBB0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 314C840008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:54:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrBHLsji;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795694058;
	b=xmRQ0LwBZLI/ccoTujz+YxzCdy9E41XK7y4uYRrAO1llcgN14FhhBZ3E9QMb7i6C7+EmHZ
	H6OKdeG9K6hbSwH0qeVT84wTNpTTtnHJDv/ZfMH63PWr3xQxlAU779k3gqb6YN3fGJ6JUz
	i28gyYDDAy/YB3LUrw0rtpQ16T0xjaU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795694058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wZDBpVktDTHbBjD03O9qHwNmcIBsVMnrElYfJgxz7k=;
	b=8AYVORngIBAYjm3/61/Qum5SWLo+E0MgFOfdp0UJXyhKRiYG8pvtLcUV4pMVtIc+V2pT3G
	A7z0WoHJcJ88asCde25poIurMqRRrgKm6aC1qDZlo8Q48diM3YIC87UftKDk1P8/Plwfi8
	EQVPs1+R1TH1QGrAg1T0/h1ZlkVezj4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrBHLsji;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D1CC442BD;
	Thu, 26 Nov 2026 11:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C841F000C0;
	Thu, 26 Nov 2026 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694057;
	bh=7wZDBpVktDTHbBjD03O9qHwNmcIBsVMnrElYfJgxz7k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DrBHLsji1TN9FSP1LGRoKVTCQ7cG2itqXbk7wFzBcG1gunzjVRNBSAg45YZ55ylp4
	 ay4Z0aKKB9RkqdOWjVCNgQHJRNFbJPuq4bsmIM6gSfOsIrJpUhZwf7ZKzB+GCA6iiX
	 lDy0qLzMTAyn2GqNUURmFJDSvURWfpytyUmuePlCcRNfRWPHxjRnXJRJYPfDdwg1UP
	 w/wD5QJl3sFafH2SOxcTeeFmhCXo8CMCVH1Gc8j/bAGp6m/jUApSL2AEJEzGHbchLv
	 ICv6Rx3o4xe/ISp6GC/ENxolVBv1BoC4/NpXW12vn1TpEReF43Df8mksYBZ3p66Y38
	 LZJ7mU1OUfSYg==
Message-ID: <bb5c7dd1-7348-411e-9bcb-cacdc1ac0097@kernel.org>
Date: Thu, 26 Nov 2026 12:54:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/8] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
To: Dev Jain <dev.jain@arm.com>, ljs@kernel.org, akpm@linux-foundation.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20261123053543.295467-1-dev.jain@arm.com>
 <20261123053543.295467-5-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123053543.295467-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 314C840008
X-Rspam-User:
X-Stat-Signature: 5wtgquee3ts8x1mmyrr4j6m4p63arwnp
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795694058-840044
X-HE-Meta: U2FsdGVkX19ZnIlzSPBYj0VgusWqxV0yVcNWu0oB3MEEvjEQ5ywDzfLuHsd49Cter1lFS3jRQBIfmQXaxKg8sXWYtIiV8SmBXQoup3mnpvPsr11z7TvQQJ8wV9OTs8jUzZ/PpFu2TTm4Sjhw3Y/UQVCvIlqiTayP+b5Di39Xtlwm8UE9C9AbhIp92X/lIS7Wvw+/leyKwuy+DxVvCfCFMXTcHFd6DrwvABjtgUBWpEQesro1Uo0762FBDHaNodmsIA4sBOxwNogV4RkTfqaYJ50/fh/42/ZEEB5PL3IxC6N3N+ZVXqdb6cXZQC0BqzEaKd0dO5+YRf+1EM2mmurGYAjLUuS3Y15gJQEfiC18dkfzxfVv1fa0hSnW0/dcCIpx4dM9oS1b1czS4nRlDJlPtggulkbl2Tb5lzFzQMglyyDobgllCF/GEfcdRvPLEFdbi/FQedWBZ+W41I8PXTya1AilJ7wntk2qTk81S4y7h+7PsKHL3JJ+dijPaZjMz1td03UtMf6F0o/wzG36Jf/OdjMfuw7xQygU9GL8l/ECVCMhnIXRYRrOvPrSvdZZJrSXlB2i6bwZ1e68s18pBlzpjsta7AxmtR9OZ84xwJxoy7yI8W/cPYVEZkYec3UtgeGQyxp00APvePj/fcIjHytxYw6ToXsLrYkcCV7Ep2vdZvENJHIQAwetbbNrhF+/FDrCjwDVNyqWgYoLSpEHydv8FGzoLYQMMDvNxDDs5vr5TvEzLWI41ws706qE17zRbfxecl/NrdewB9QY/EE3BmlPxV+g4rfE0Dk3Ny0wKDZY9YfjRaWXNVt2L6UAT5A2p9yXfQPV4Iz6QTnQMealTbjKqW9oLWz3//O8Yr3pNdB3f2xpS1y+JPcKr/37ErRiyJ91IIpF/lqwsbzmY2G12JqCgGY0UL/u6CPpe0Aiv+eINZTpf+N5sa2AavXFiF9ITTP/Bz7nD4PUAtjLlgGJgH4
 Wi7UmzWm
 qM1TqU0g1LUoyjg7OOv3dVq4eZRwkc/BROZVx7w+xFOV713STcG/D8EO9MvzkJi1Uk6symqCNSkjNB4Z+BY7mTh1coUIP+J5xHyFF9Ree1kPs9lV8aq4mQNeXAnjrp1mJYh+MvsSEyjPS36g+iPvogZhS1tiCRakEdGh6hwt5szxHvhJ+vOczcKrr3Wit1PgAVjutsiSU/0bu4QUcCzIQosEA2Wh9S9TyCLxbFAacqJ/vbuCx0bxsyvH0/i/JzwNNBwvgLrCV0s4N92hS+sX9yZK5EmLNqQZ78MIB4S9Q5m07tQpDTIoXGwOMf1wW4yFC8EuGq8uZEtekCrgKgWLMFxUZCdCwJ71C2nBGwFe5JmJ+Lh12bD+0WiX21hPY5zizaeJq+KdYyHXyT2r5W652ivNqRV86FV9bO0c3XiSbcWK3x905pKIU2EMFXiE497Md2/m12sC2ef9HqhkGUfiVEo19qgq49TgyRbcYoFUhX9EM/owqOiDXkQDZJFkyVNybEmHiq4iLEf0XgEDaqRwyxXT44e+42aHw/pTs/PFjizdVsYG7koIJv7Uy5y0kmkQTKBE43r/hV1VRw3S8BuDnQdNjiX5g/S3wIpV+ktj7ACLeB1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:35, Dev Jain wrote:
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
> Add two WARN's: check that the batch is entirely exclusive (for PMD
> callers, need to check only head page), and that there are only
> PTE/PMD paths converging into __folio_try_share_anon_rmap.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/rmap.h | 58 +++++++++++++++++++++++++++++++-------------
>  1 file changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index ec1e85855be1..d65de8184ecb 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -746,17 +746,25 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
>  }
>  
>  static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
> -		struct page *page, int nr_pages, enum pgtable_level level)
> +		struct page *page, unsigned long nr_pages, enum pgtable_level level)
>  {
> +	/* device private folios cannot get pinned via GUP. */
> +	const bool pinnable = !folio_is_device_private(folio);
> +	bool exclusive __maybe_unused;
> +
>  	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
>  	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
> +
>  	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
>  
> -	/* device private folios cannot get pinned via GUP. */
> -	if (unlikely(folio_is_device_private(folio))) {
> -		ClearPageAnonExclusive(page);
> -		return 0;
> -	}
> +	VM_WARN_ON_ONCE(level != PGTABLE_LEVEL_PTE && level != PGTABLE_LEVEL_PMD);
> +
> +	/* We only clear anon-exclusive from head page of PMD folio. */
> +	if (level == PGTABLE_LEVEL_PMD)
> +		nr_pages = 1;
> +
> +	VM_WARN_ON_FOLIO(page_anon_exclusive_batch(0, nr_pages, page,
> +					       &exclusive) != nr_pages, folio);

That's a bit nasty. Better embed that in a #ifdef CONFIG_DEBUG_VM block and make
it readable + throw in a comment.


Apart from that, LGHTM.


-- 
Cheers,

David

