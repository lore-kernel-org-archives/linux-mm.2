Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CA4DE9D408
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D5F6B009B; Wed,  4 Feb 2026 11:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4BA6B009E; Wed,  4 Feb 2026 11:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F616B009F; Wed,  4 Feb 2026 11:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64B056B009B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:14:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24041C11A0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:14:24 +0000 (UTC)
X-FDA: 84407271648.19.1CE8868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 49B191C0017
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:14:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H1vPGXhU;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770221662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQFqn9skdybOJ+mbSsHDDaYRySBPw+TTO7n8EyuKb1U=;
	b=LSUyCHhYws33e6TFoH9kEwe3N8DdAMFcFBtt2DJfoDBvthN/bDeNU5SiIqciqu//u0SREP
	0KkpUzQ4zkolS1YMLnTW1C9iuYVFpSMxqQaGLkmrefpiyUUJ6mnGBR9BzJSTIqTnUJx9qL
	NtrmWAtvF8uH6Al6YW5dkkKHeL/S0xA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H1vPGXhU;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770221662; a=rsa-sha256;
	cv=none;
	b=1Un3IbZ5qsx+w6WpY7LZu8hMXZwOSRBuklzQwoAY5RosN29EFGpOFr6HsSOeif1HphdmfT
	deIlz8xqoXJq7SzCoGODcIj8CLhTsgBj1/e2Sm/mD8OKZ5vEiPNG/g8PS9k05BvyW6aP8i
	Q9bl4oZDif2uJJwknSKOCZGOTWqHKlg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40EDE44194;
	Wed,  4 Feb 2026 16:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BC7C19423;
	Wed,  4 Feb 2026 16:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770221661;
	bh=fpIWi3ZlUU6GICbdztTffdwV8kcfmInvBOHJZpSmhzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H1vPGXhUwV6c5NaktCTjngbifuDhCiF+MY5C9rAm7aQpM5UhZIbsPHjKUaCIe3UbT
	 ZPan+cYjuPFcRTfiQwRp/Dsej0VELkl9kaMOIAbUzkJDkyGz4L2UiwDsU4b36C51v9
	 MhKrNeaY79muH+KxquiZQbjLHI1Qj3LOb13NqQsfOiWDxqSVlKUPgnxqy6QmZiuULt
	 Vg2X4M5Z2v2caTdEbzzI6mAwcTsbi7IWZPydTFK985L+WavMc0OfHDgPnUmU7HI5dX
	 WOWKlCW/gGBMqBOCbmtqu11Dwr8VTP/CMpea3GpAszgJcoyFcHseGtZXiUIxONMT6U
	 W6EDNps1rC7pg==
Message-ID: <a61bc0a8-cf5a-418a-aeb4-96553b87f043@kernel.org>
Date: Wed, 4 Feb 2026 17:14:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 02/17] mm: Change the interface of prep_compound_tail()
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-3-kas@kernel.org>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49B191C0017
X-Stat-Signature: 15kkdyhqpofccbnk6pboawuhzomu4muh
X-Rspam-User: 
X-HE-Tag: 1770221662-284467
X-HE-Meta: U2FsdGVkX19Z2D9N4fNZ2ViHMvpxlqZqins+TnN7f4WuyJ761h6sMUdBoHZ705b0KvfcUXUzdfMcZ/MROo5JfIdsJ3+famBENSGwUKETGa0DTS9MyMs9HlAAkdP3xw17Cyz4hOBfQBsmxWJHesrzX7UBUonk3fl6ozJoXNt29kcSoPqjbbcTredbyND1pqM/dxr/sT9vtI3Qby/jakx/819nC1Zdk+x+z9zXmWCG1ZyQE5xhyu0hq8sOHq/DVs7/aAzj3n3fJEPiK/gIqe2nJE+6aYAV65L5sx6p5S4Pl37gFHYmPW5VhtDzpr6pl/ykRcSaWXhSt4G9M1SFsUu9rA6KyrnUbnKSL1DG0gMaIeHUAIq9tn2YsvsrX4rMyxg85beqkJdRdnNew5tgKz0XtJuBolR1q5CAo6EWKr8FITh7A1STilu+89/MfC/OlA1GF/ETt3J0HWvTcnQRNl5mL1wiHN8Y4cPzVfLPgnO041sw8Mtnp7MksDuHM3jIjsnX0d5lpf1yyvZ9ZveXYuPSK+Y43R97aoBWF4hfGU4aZoZxSUK2NT171kc+o3RE4kPjFNE5K4CQ79VkNSRfU+Hy2vVPpCuEbuf2Y2YNAT46aPjOAPDeoRw01f54kZgYBOLTqxt6MMrZyUl4Rh66UZVw7VEv/cCke5R43w3QdyQmzuDmZWbE6VwngZrt23NfP5OUNcZuRo0pLQ5Gs0YTV2jDtDXGj1kVF0FOcWTHclRMeusq2YnwnT9OivXz1EqQ5E0dIW0BYqtZeBtFHdjpSOHgHPl74pw5HaY3pnGdN0LB7R1v5YN2mHTHaRvw6nqHazg3Qt1m6YqvSHbLGXYyB1IY2DqFBPCq9QNwArOPJqCpdmV+O3HuAyNVTJUTB+Ti5w01J0ujV4zI5R7flb1oAct8GTXWjCju+BjzPmQAueiC58heVp7PLIuuXE+Ze87lF7J8qz/GP+J1ROMyCVkCSw1
 uZk77ms6
 5zzrPjUZ/8IXFYR8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> Instead of passing down the head page and tail page index, pass the tail
> and head pages directly, as well as the order of the compound page.
> 
> This is a preparation for changing how the head position is encoded in
> the tail page.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/page-flags.h |  4 +++-
>   mm/hugetlb.c               |  8 +++++---
>   mm/internal.h              | 12 ++++++------
>   mm/mm_init.c               |  2 +-
>   mm/page_alloc.c            |  2 +-
>   5 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f7a0e4af0c73..8a3694369e15 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
>   	return folio_test_head(folio);
>   }
>   
> -static __always_inline void set_compound_head(struct page *page, struct page *head)
> +static __always_inline void set_compound_head(struct page *page,
> +					      const struct page *head,
> +					      unsigned int order)

Two tab indents please on second+ parameter list whenever you touch code.

>   {
>   	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
>   }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6e855a32de3d..54ba7cd05a86 100644


[...]

> diff --git a/mm/internal.h b/mm/internal.h
> index d67e8bb75734..037ddcda25ff 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -879,13 +879,13 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
>   		INIT_LIST_HEAD(&folio->_deferred_list);
>   }
>   
> -static inline void prep_compound_tail(struct page *head, int tail_idx)
> +static inline void prep_compound_tail(struct page *tail,

Just wondering whether we should call this "struct page *page" for 
consistency with set_compound_head().

Or alternatively, call it also "tail" in set_compound_head().

> +				      const struct page *head,
> +				      unsigned int order)

Two tab indent, then this fits into two lines in total.

>   {
> -	struct page *p = head + tail_idx;
> -
> -	p->mapping = TAIL_MAPPING;
> -	set_compound_head(p, head);
> -	set_page_private(p, 0);
> +	tail->mapping = TAIL_MAPPING;
> +	set_compound_head(tail, head, order);
> +	set_page_private(tail, 0);
>   }
Only nits, in general LGTM

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

