Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82822C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9035E6B009F; Wed, 16 Sep 2026 04:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B46A6B00A0; Wed, 16 Sep 2026 04:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F026B00A1; Wed, 16 Sep 2026 04:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 546A06B009F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:32:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2EB3160611
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:32:41 +0000 (UTC)
X-FDA: 85218959322.18.1C61FCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 33698100003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:32:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OE0zVRHy;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kryuK3liGiOsrOQQb3JdRd/XrDBXKZJdf0bb5gTtXVA=;
	b=UaoTv41JCjt1a2lFumm9eDbnOtOInK3D7kaoj/uAmm1CZh4Fo9uAeE2+OuceV+51+2qJH5
	MSx1MYqUmnXeFw45ouYJtHrO6ZGypRBZkHjEy+523SexSJwJOT80JiUKSVFBDDVyyjnfkK
	/1Mw+GOrxdTn9Vg7VE/F47oOFAr89zo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547560;
	b=iRYQJHASe/CXa8+rec3le4jkD5W/ExZNtAYwQEJvNLkQiWuTBueRJGcnL+F2HmB8CAuf13
	jmKbXPklMCoqnDuIqfrZDHxH266743B8aqaEndY2F82JRcZluqBW7hwYlqaUbKJ7lJ2xiQ
	y/erod2PW7hkJErOMw7Di/p2sdd2R/g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OE0zVRHy;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A8414131C;
	Wed, 16 Sep 2026 08:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211411F000FF;
	Wed, 16 Sep 2026 08:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789547559;
	bh=kryuK3liGiOsrOQQb3JdRd/XrDBXKZJdf0bb5gTtXVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OE0zVRHywwZPRGzw7YjRr13x+B5BhcawMFrUjOnZ6UYVh2xMHPClEH7eMMRLHg1Ta
	 7383xDBAZx8aiTXPifqvkjz/Mzlzyu/vPr1sVy0IqIqgj914UgaLVVLse6c+FvxiOe
	 q/DsaHka4dg6nsJp1DoaOSMXlppy3fKbwLJsq+dhGQvACllR4eeE0uahd5SMJtHU/D
	 Ip7/c+4nt3hgP6HiJhggCs8ScgA8TgUCedPyHUKgHP4POlPRNovh9CZHMb1C2g+Tk7
	 tb0CIBNryPjpn7Njm5gW8fRbYiNZx1lPnJSzJsR/pj6WuKcX4F2sttv1kZw9KwyVEr
	 1XcJsl3KPxL0w==
Message-ID: <3c663c66-70ab-4c9b-a490-67deac9a572d@kernel.org>
Date: Wed, 16 Sep 2026 10:32:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] mm/memory-failure: keep inherited poisoned frames
 out of the buddy allocator
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 kas@kernel.org, kexec@lists.infradead.org,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33698100003
X-Stat-Signature: ac3sr5qsbxnbicbr9d879zo9is6j15ua
X-Rspam-User: 
X-HE-Tag: 1789547560-686522
X-HE-Meta: U2FsdGVkX1+J4OPpNwUIZHFh0ahtmeLYO4RJorVlL04yeX42HdG53Sd3hCoseMBhSbqQtmjeynduC4/na/HyLrC9VwU4RvIFt3MQd+pH8OWav209gDrbR9LG7aGlZIAA6Hs8yp2JHb9/FUfXBS2sct2zMZCXkw9W3+3giDlHzxwkmgB3bNAvUeUD2x1nWDVZ7zckF5vdMQjE0xhLJSm1cmB92zhQh/sV27kSbFgn33e2aa5uw/1Xp3tjIoVA/LKIIcYrqsx5OjAfL8BjjWHEvJk6Jx1zEshJwaB3aLJDs9LWa1oVST93u4o64bUGkIWjDoR6jVZkd06/eCf+uRMRugdF+KrQKH6A1OVA+j2Png3YZSbrcyB0Iwo5tNt2gKEwpjO0zIQG/0zlhfqA8ZRv3LjRNPNMdg1Xx1iEYaC+RW8s66iUF9bmGSAgX/BpvT3GX7biGUbrjPSR7QDeNxYkmEJEos9kwcAgMlvp3b5DzuCtEyJ71T0pLajFH9coHs9zpTjJKJQ3vd9Fp/idBZqBu2fEarf+IkPlzdNjoBI7xb056XBqKNqb2gOoUcEAHsRrnFr88QJUJzNoklTuGt20ehXLMZYMwq9r8Hv/6+Z4D89qV4h2nw4dzIAWzr/gbdlnhLsU4DrXM7C12SCmrq7j0Tv7Bvft7wJWB8iLTvDa9E1xBbpHq3cHuDcEAcAqUZfcehS+y4DKqox+0BLAlkWd1EIkm1HeVIlx8cXMBuZ9OGa0caUNc/6snVeNN2bnTmSirSTTtR6NzANOtrYWGAbGj7zMF1ReEApP8Gb0l0lPzjOCHI6KU5yjmOaSp66uOGtZZpx7s1zW3aCRtpPcsQwyf7EKoXXN40DQrno3KUBd6Nfn9b0BLyZw9aaGUxrVTZgZdR134vE5spnDsnrEome6u3CP2JjQCAvAe/n+12rCzIlla2RnK/HziN64fM6FFhfXe18D9Vfreskt/8R9DjI
 Srsy9m/y
 zZdgnyP2U2KB4HTAIIaiEO3bjjc5ydg4PrMSrVHh2/2Sp6uboAROt0DvHTm3fRLDLPXZcp0rTqo/hzuLJ5bg4j8BI6P1ak7uIGZU+sGHXpJe/zG8z9e6nkaE+0O3o1PmTjHrENVnZpsbiHRbD1EfAUi9d6KTwITBVKakdM2S/PldWn/wBah7CafQXA4048syZ/R5LrvIKi3LE3pRbFKWvP1fs2wCBw08iVO9YD08oNiLVVqOsb2BRvrrqMXpm54pCxonrRSH6D//qYy728G9/iQalCYfU8FQ8GJ2Jfxk5sWAH39Au+LA3LyCiB2j8lUutPaxzOOeQdevv5mfW3ySzIixorCDx7Wbxur9nwN8uk7UBvPuXa3Yq9sehuXJgOAn3UfHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 14:53, Breno Leitao wrote:
> When the pages are being given to the allocator, check if they are
> poisoned, and mark them as such.
> 
> Similar to unaccepted memory, hook it in __free_pages_core(), and thus
> the frames never enter the allocator, rather than being taken back out
> of it.
> 
> A block runs up to MAX_PAGE_ORDER and a unit is 2MB, so hold back only
> the frames the table covers and free the rest one at a time. The
> allocator merges them back up, so a unit costs the frames it names, not
> the whole block.
> 
> The frames that are freed go back through accept_and_free_block(), so a
> clean frame in a block that is still unaccepted is accepted first.
> 
> A frame is flagged before its memory block exists, so the per block
> counter is seeded from the page flag when the block is created rather
> than incremented here.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b07b5f4751cb95..cca67a2702a421 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1597,6 +1597,25 @@ static void __meminit accept_and_free_block(struct page *page,
>  	__free_pages_ok(page, order, FPI_TO_TAIL);
>  }
>  
> +static void __meminit free_poisoned_block(struct page *page, unsigned int order,
> +					  enum meminit_context context)
> +{
> +	unsigned long i, nr_pages = 1UL << order;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		struct page *p = page + i;
> +		phys_addr_t phys = page_to_phys(p);
> +
> +		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
> +			hwpoison_boot_page(p, context);
> +			continue;
> +		}
> +
> +		/* this part of the block is not poisoned */
> +		accept_and_free_block(p, 0);
> +	}
> +}
> +
>  void __meminit __free_pages_core(struct page *page, unsigned int order,
>  		enum meminit_context context)
>  {
> @@ -1631,6 +1650,13 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
>  		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
>  	}
>  
> +	/* First: a block parked by __free_unaccepted() never returns here. */
> +	if (range_contains_poisoned_memory(page_to_phys(page),
> +					   PAGE_SIZE << order)) {
> +		free_poisoned_block(page, order, context);
> +		return;
> +	}
> +
>  	accept_and_free_block(page, order);
>  }
>  
> 


