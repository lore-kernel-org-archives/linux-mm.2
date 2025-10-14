Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE2BCCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DCD8E00EE; Tue, 14 Oct 2025 08:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06698E000D; Tue, 14 Oct 2025 08:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6C28E00EE; Tue, 14 Oct 2025 08:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD7F28E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:45:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56A64BBF5C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:45:25 +0000 (UTC)
X-FDA: 83996690610.17.792C8D4
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3AEF54000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:45:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=T7ewsMJ8;
	spf=pass (imf12.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760445923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEOQpQJo98QyfYnBlnV0kP+HUCRx4XT+4+xOb+xrqYg=;
	b=z1q8mYdKaOnv9SAiG29IwDAOC01hVTuPqPFl5GksVHjZVeQgkxdEYtiZak/2k/vU5/T7NH
	5owG8ClGvOTafqO/kR3o6o7+ZOdnaLCSPbM045pNPIC2w3awsT+qlAKWji2jHrdUIQhQy1
	Onq0WJ9vtSSAs+z1WpwuyGmdWB8f/yo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=T7ewsMJ8;
	spf=pass (imf12.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760445923; a=rsa-sha256;
	cv=none;
	b=VdtJbqewGw+uiuj5TDduv4Fp48bw4BLOsUO8g+5M/fHaUcv95TbFAZ85krZpTXZyz2WERC
	TUO/rbN+Qwta3aYXaiClfbPuZkUbIoEyBIcNy2ThLbo1QwLY4Rb//NIVjTcbueobBx/TzO
	dBQxHUnUjc2Joq48Iqsm3Kcd3QViwJI=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3c82276592so97102366b.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760445922; x=1761050722; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEOQpQJo98QyfYnBlnV0kP+HUCRx4XT+4+xOb+xrqYg=;
        b=T7ewsMJ8IsOXREu/sPQFV2e2BO8TyYnr27PdYe40Y7oJe/jMzN3NrGCgb0Yk08EuZB
         tiPAU4Won5Zw7E9493LGv2hdG70xBwWRy/7OZ5do0c5FbT56AmMsEDtz2SUMCcU6HFIC
         PKXLR1y5A1CXHgAGI2kFe7meX6jkQgl62iKXOmhZ5fDE9IRbR4LjWV/caEtsRWpWMwPp
         rIZm95M2Tp+jOsLafUci14Dy15SDR0OTvvLini4ewGB4RZgBs0sYyo3K9HSuG/x8B3Lz
         hGph5nIlHGN3F8cM8/3zrwYd98Zn96Y1U615hOCnCEToVVcBT0qLiUaUNZVm8XkE8Dhu
         l7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760445922; x=1761050722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEOQpQJo98QyfYnBlnV0kP+HUCRx4XT+4+xOb+xrqYg=;
        b=h6Qjy0LvBnPogGtTodzVs5TDMN3IjwQzhQLrB2x4Vmx4PUzkeTHG1LOTyhxtxdMndI
         R1k/lonVMdRNSqKp67OFuL0nE0TGQqW92ccKnJbDyxRXyuwwgWK4e+MrOCQl9gOz+SXR
         chOU3njG/TtaYr+lD8ty8Kbs/ac58+PUfI2hTWoJGjKZT2T5HOQ2TXYRktKGxaoOXmjS
         iSNWxgrRxNWZRlpJgLGEVd8KYcRUUZFQiYKg92cnFdIB3efyZ+igYmEGErn5nPtlkjNL
         S6PnONlszgZs2YgvXAY/CdxNm4kwykfUhMbK0M22Ey4tEzdFgZgmsPxWkZVZ5EFhVgAX
         QEsg==
X-Forwarded-Encrypted: i=1; AJvYcCUtND6Yu8KNAK1cjcwNWR3+WDTI5tIg0/3zrJAeHY6orPZSvByJweoWFskjTieGAyogazwqQZdgEQ==@kvack.org
X-Gm-Message-State: AOJu0YxvsZmH3V149VhnpdO0+TtTE2sUXK8ifSmzreak49exrT17uUX1
	RFjkAWZDQdJGpWH7q7bYkK+KeL9Zg3jgxfadAwjrQjtJnRgc4jqNEC33w9cpsIk0PPU=
X-Gm-Gg: ASbGncsaRGMCrWdAvspUL0mTHZPXK1T677vIt4NemHwWKeg310jjvOIo2Dm6SrX7Mh0
	v57+tZAUV65+MLwsaXtoErxMG7Bp2UwCwPleVeQ7kU12UHq/FSFDXx4XegLNYntcLQ8ndGYplud
	NrAyIgj4pXU0prtoxheOJyZALyH7+BVQ2XmzRvLNxeb3FJYbn2lVP748ZtSffeMeBkWB9EfY5UX
	US7S7RsWrx+Z4ob8LuGRUlHgkFQ7x4esI0rp2GZIpKTie6xuqBiHvxkBE6zT7V1pequFNHvIhZT
	a8mkYseml2bvk03/r2KETXJnzvZmtiltJ42yKWULshhS25ZLnxFX1WSJ6iQ/+4eSOosil2OvDT7
	WuucKGMZb/gEkTXcK6Sx4ak6hFIGpx9Cefqw0qU83Dt+5aSyi7ZElA2kvUrt+kELiAMSEdXkkhX
	67Lg==
X-Google-Smtp-Source: AGHT+IF98YZGXnc/a9+tF96u8G13aSwGmApwD+ogJyUi8W1JPjF4gTRZUKJnX0ICaKrlb9YoA4BxHw==
X-Received: by 2002:a17:907:7ea6:b0:b46:b8a9:ea6 with SMTP id a640c23a62f3a-b50ac6cd23fmr1429210866b.9.1760445921504;
        Tue, 14 Oct 2025 05:45:21 -0700 (PDT)
Received: from mordecai.tesarici.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d66cc4b8sm1150612066b.30.2025.10.14.05.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 05:45:21 -0700 (PDT)
Date: Tue, 14 Oct 2025 14:45:13 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Mel Gorman
 <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, Sumit
 Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard
 <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
 John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, Zhaoyang Huang <huangzhaoyang@gmail.com>,
 <steve.kang@unisoc.com>
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
Message-ID: <20251014144513.445a370d@mordecai.tesarici.cz>
In-Reply-To: <20251014083230.1181072-3-zhaoyang.huang@unisoc.com>
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
	<20251014083230.1181072-3-zhaoyang.huang@unisoc.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3zpobsrjcnah5hi6m8jrruch1oo5o1oz
X-Rspamd-Queue-Id: 3AEF54000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760445923-664948
X-HE-Meta: U2FsdGVkX1+n3N8nHfqxXvsBQVnxoUAx24tJmFGxWBTYGsKZ9qSnP+jcQVkc3ozLHrS/jKzrirlZwaLcXcsKd/JVSUWFWEAhrkQsGn3NrNsbaXrg0na1UfZ5O0EmrUadYyL9U8ywQ1qegjmApeDqkvUFLhQczNUgOPaxaM+oT1csLQPUOQD+sPPWXEaXYXY0xZz3cfSclSx2/wv10eA8Nbu3BJlwAfKicvuSzSkbwUIesShHwOaSHPzm5gfQOSQG2LuTh/5hP80Q2W1GMVIuKBqVIrEWNxf6iFk3W+jjM/r9Mx0M50c15XNrZzc6BAdm0KjAUmXzpjuiHNXEXE+SRhfa/TEvlTecqAG+KNOJgtDzIALoV45MNewwUW3MLvdsfw2H8YGrzXwF8TKf0qWLgkanqM7bb4oujDC4mg1LYQo4RXYpx4p0lEFIRPOIdeiFbRvZNuHx4XL/01+MgSR7FZI1KYID1BVHDGZg01vRVCfX4MWIICkb+Oc2cttiYirbE126HE+20LAB9bG52OO/PD8BvjUnp6rj56WRaMIKxAmmiAMlXOHWQ9bEB1GRiQWC+bPKrMbXmP5gfQxUis2+od37Y4Ix38CyLBmRDiTvZvOPmY2TzJQJUNcCXPDUjlE+ctWc+cpH0IMlubE8ZMxqm9VxwKTofOR5d05xieVlq7O+dPFoLuzHhKnSGIeyLFR7jzDu9aSj5pK4/L43WhMuuBek9/SpMuEkP3uQ7BGGxi0I4CKY3ey5TzkxyTYKAfjcTaUJpH5Y5kSbum7S3AtOlLvJ16c8o3GUg8RnKK3nniVFZ4nlax8y3/XrbOS4086NuNDfWaBt9eSm/xzxEWST3WBntcobLbZhxYBjjChAb8kVt8uJp8HkexVxmTFAaD9zjEpocXa23HCAYplyTfOECIfloX6/3UsXrjGduqUKXIxZw+JkE/a/XWMDz7ml28rYDGZQtVU6TX8JPL2eb71
 osPYqXB9
 VJVYcQFdwEm1y0/pQCYP9b2zgjvsI57UrLHtHN9YWAwYIDEmJT2xvB1SBscvWxN2R4KYq3RphvOCkR20EcRfCsayCwfeWY4pIbCfHCDeQtWUBef+miiZHx2FxctwrkI9vqQ7Osu46XOXNJMR/yoiR0D+QVL4FN8bDaghGI81ycIf8N5TcjwNT6EEFyD/GaqUuW4mlfLjzSg52FSZ3nZWmxBtR95KDDyG6wUj+uxFWmJRelb1pGBP4PNRQAblaSH5DWXW01Ws1pOFmwD5SjTyovuFlo6eFkZi2kwF+Jk3tLqVw2ZMRJRqAODh0WipCes6ktaAWVrWqdlEy3362QeG4LKOvVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 16:32:30 +0800
"zhaoyang.huang" <zhaoyang.huang@unisoc.com> wrote:

> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> The size of once dma-buf allocation could be dozens MB or much more
> which introduce a loop of allocating several thousands of order-0 pages.
> Furthermore, the concurrent allocation could have dma-buf allocation enter
> direct-reclaim during the loop. This commit would like to eliminate the
> above two affections by introducing alloc_pages_bulk_list in dma-buf's
> order-0 allocation. This patch is proved to be conditionally helpful
> in 18MB allocation as decreasing the time from 24604us to 6555us and no
> harm when bulk allocation can't be done(fallback to single page
> allocation)
> 
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  drivers/dma-buf/heaps/system_heap.c | 36 +++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> index bbe7881f1360..71b028c63bd8 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -300,8 +300,8 @@ static const struct dma_buf_ops system_heap_buf_ops = {
>  	.release = system_heap_dma_buf_release,
>  };
>  
> -static struct page *alloc_largest_available(unsigned long size,
> -					    unsigned int max_order)
> +static void alloc_largest_available(unsigned long size,
> +		    unsigned int max_order, unsigned int *num_pages, struct list_head *list)

This interface feels weird. Maybe you could return the number of pages
instead of making this a void function and passing a pointer to get that
number?

>  {
>  	struct page *page;
>  	int i;
> @@ -312,12 +312,19 @@ static struct page *alloc_largest_available(unsigned long size,
>  		if (max_order < orders[i])
>  			continue;
>  
> -		page = alloc_pages(order_flags[i], orders[i]);
> -		if (!page)
> +		if (orders[i]) {
> +			page = alloc_pages(order_flags[i], orders[i]);

nitpick: Since the lowest order is special-cased now, you can simply
use HIGH_ORDER_GFP here and remove order_flags[] entirely.

> +			if (page) {
> +				list_add(&page->lru, list);
> +				*num_pages = 1;
> +			}
> +		} else
> +			*num_pages = alloc_pages_bulk_list(LOW_ORDER_GFP, size / PAGE_SIZE, list);
> +
> +		if (list_empty(list))
>  			continue;
> -		return page;
> +		return;
>  	}
> -	return NULL;
>  }
>  
>  static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
> @@ -335,6 +342,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  	struct list_head pages;
>  	struct page *page, *tmp_page;
>  	int i, ret = -ENOMEM;
> +	unsigned int num_pages;
> +	LIST_HEAD(head);
>  
>  	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
>  	if (!buffer)
> @@ -348,6 +357,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  	INIT_LIST_HEAD(&pages);
>  	i = 0;
>  	while (size_remaining > 0) {
> +		num_pages = 0;
> +		INIT_LIST_HEAD(&head);
>  		/*
>  		 * Avoid trying to allocate memory if the process
>  		 * has been killed by SIGKILL
> @@ -357,14 +368,15 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  			goto free_buffer;
>  		}
>  
> -		page = alloc_largest_available(size_remaining, max_order);
> -		if (!page)
> +		alloc_largest_available(size_remaining, max_order, &num_pages, &head);
> +		if (!num_pages)
>  			goto free_buffer;
>  
> -		list_add_tail(&page->lru, &pages);
> -		size_remaining -= page_size(page);
> -		max_order = compound_order(page);
> -		i++;
> +		list_splice_tail(&head, &pages);
> +		max_order = folio_order(lru_to_folio(&head));
> +		size_remaining -= PAGE_SIZE * (num_pages << max_order);

This looks complicated. What about changing alloc_largest_available()
to return the total number of pages and using PAGE_SIZE * num_page?

Ah, you still have to look at the folio order to determine the new
value of max_order, so no big win. Hm. You could pass a pointer to
max_order down to alloc_largest_available(), but at that point I think
it's a matter of taste (aka bikeshedding).

Petr T

> +		i += num_pages;
> +
>  	}
>  
>  	table = &buffer->sg_table;


