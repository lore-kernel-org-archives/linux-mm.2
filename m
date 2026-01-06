Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A7AC47BE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948CB6B0093; Tue,  6 Jan 2026 06:05:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909B86B0095; Tue,  6 Jan 2026 06:05:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836D96B0096; Tue,  6 Jan 2026 06:05:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7469E6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:05:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C9F813B106
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:05:05 +0000 (UTC)
X-FDA: 84301256970.15.2C2362D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 349AEA000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:05:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767697503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JejsjZJvbAfHxtKMeP8Pob7aXb3PhxAVpY7X2JH2kKA=;
	b=jhHgwomgMCsxTTK6JcqO8xTlbwyCXA65Lm2E0utYyBN8uJbHr3bXP74+CPvjzoCQm4WYJF
	MNVUAETe7hlwCqQRv60FEN/qgagp19BLuL1/jPHOpgsVnlCV1cBhYzhb0l6avRosU0NhEO
	aOjf8bq8u5FvqzHyeJ+w9QSv1kcdcQo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767697503; a=rsa-sha256;
	cv=none;
	b=oqLNqKSwmmZmGWWsKodGlUrttqN5Ae/zqtxiyspxAc6rwmto3U+9ap8CTrHenU20z6oMdI
	nWy9yYmC24XUQV8JQapswK/BBf6oXyGcEgqtSdlSKXrMwXCVhOFzBdJDNg5obbWYlDdWL/
	CGq7u2er+EeaZFP2Y2/qjox/fguHxnQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F067C497;
	Tue,  6 Jan 2026 03:04:54 -0800 (PST)
Received: from [10.1.39.162] (XHFQ2J9959.cambridge.arm.com [10.1.39.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C4FF3F5A1;
	Tue,  6 Jan 2026 03:04:59 -0800 (PST)
Message-ID: <bb4a2b21-b864-4afe-8aac-963e55c9d74d@arm.com>
Date: Tue, 6 Jan 2026 11:04:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] vmalloc: Optimize vfree
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <20260105161741.3952456-3-ryan.roberts@arm.com>
 <aVyRR2-fdvJ_9JNy@casper.infradead.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aVyRR2-fdvJ_9JNy@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: sa54udtmgntib8myqppjngxd6hniocqn
X-Rspam-User: 
X-Rspamd-Queue-Id: 349AEA000B
X-HE-Tag: 1767697502-34148
X-HE-Meta: U2FsdGVkX1+KGW48qJnId/QFdiKZVht3OMVi26eRX3OaKmUBteaRPloZseuHixvkG6qGlU22tkTU8buJ6XM7upQ9hS9RpkS7gRG0AOSSNsWUEA5M4H31vwfgDsRxvCce0aONN9dJw+2o2Kh+fCPuUKw2HiMQUQFD2vg3rOZn7Lo2f8cEguX5fCHfiGEzQBHM+CsqDlmyT8dIDZqa+0TxC1UXhvdV4dWA38fzb468XydV3omEWlmumAwmKNDibWtvccu0Z6dUD5tmqwBhUM8R83ujnoghyZ6pn9yLc11clMh6deJoBiyGbj+6mXb7wcCDR11rVU6qpancIsq8grEpXRLwbRJAAJPqyA6++gn73zWXXE2TgdNQSCepHoZZipQaTGm6Rq7PYqFx+ChvFEb0GSYnmSWDdlIKw9g+ZXZZCp+JlrVrsMO+WmMb+luVGdtRMG8NYNrWvvTrn6LntoIuIUXnvYEMS1CnJ/QnAYmtJmJELJHKIg/h676KJ34SSvL8iz1Y+eu4J0aN2IzQ7TCrS9pjTP/Wwr03ot+X1tAb82slw1uO+bGL9pzO87/oDZThJP/A7A2OBQ3pW2P2UxVw7O4DytFmCTN/r+R+Spn/JuOzfGaLKFuBmX/OOay2jE4NXzAQZJb5iztxqpSEaao6KOooQ5hKHIIh2t5ih0KoHvO7HG+lIdCdzzj9qRNC+xR0jU+wUI4aPO5aEkYfk86VOssYBkYoTqnNhpfENZk/HpZx05viXpX0iww5hcOc+08Okmykb50swmdzd9TN6Wl5/h0SRiaSswpOFc6/V/d4tvRQUhk/sTOCjZ86ow5wIuo9a5Vo591JSUvx2M4hVNP+l4FL0FZTINtlj0/8DBUOgQ8MgCKOEkKkXpqmxtGhVY0/qihwPTtJ2jB4TfCt1P8yjzoGo94T3oP2qyioi1EbF8tp1D+ahgYjmuSP6oOssxRhICCSN8akejC5BoUwQHw
 vX+WQMWf
 bI2ZJRZT72DpHC1VnHWoRUEVVo9aFFucCGjYkU3d+Rhg1DJLVDa3955iRf7S/zSLzmelTOwmN0rFr8Hj0y8Y7wV7RhwiAIoytlTWJcCI3Ep9Ao0KZUxBTl+gnZXXMqiXXwQAT5eS3mpv0m39oYI0p7ZoHQJHGQkOwGEGgL3+EoLjef7PUsFzZUHrKAQqjEcXeiRrmPIsqict7IpyzAKAnO84klg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/2026 04:36, Matthew Wilcox wrote:
> On Mon, Jan 05, 2026 at 04:17:38PM +0000, Ryan Roberts wrote:
>> +	if (vm->nr_pages) {
>> +		start_pfn = page_to_pfn(vm->pages[0]);
>> +		nr = 1;
>> +		for (i = 1; i < vm->nr_pages; i++) {
>> +			unsigned long pfn = page_to_pfn(vm->pages[i]);
>> +
>> +			if (start_pfn + nr != pfn) {
>> +				__free_contig_range(start_pfn, nr);
>> +				start_pfn = pfn;
>> +				nr = 1;
>> +				cond_resched();
>> +			} else {
>> +				nr++;
>> +			}
> 
> It kind of feels like __free_contig_range() and this routine do the same
> thing -- iterate over each page and make sure that it's compatible with
> being freed.  What if we did ...

__free_contig_range() as I implemented it is common to vfree() and
free_contig_range() so more users benefit from the optimization. If we move
put_page_testzero() into vfree() we would also need a loop in
free_contig_range() to do the same thing.

Additionally where do you propose to put free_pages_prepare()? That's currently
handled by the loop in __free_contig_range() for my implementation. I don't
think we want to export that outside of page_alloc.c really. Zi was suggesting
the long term solution might be to make free_pages_prepare() "contiguous range
of order-0 pages" aware, but that's a future improvement I wasn't planning to do
here, so currently it needs to be called for each order-0 page.

> 
> +	for (i = 0; i < vm->nr_pages; i++) {
> +		struct page *page = vm->pages[i];
> +
> +		if (!put_page_testzero(page)) {
> +			__free_frozen_contig_pages(start_page, nr);
> +			nr = 0;
> +			continue;
> +		}
> +
> +		if (!nr) {
> +			start_page = page;
> +			nr = 1;
> +			continue;
> +		}
> +
> +		if (start_page + nr != page) {

It was my understanding that a contiguous run of PFNs guarrantees a
corresponding contiguous run of struct pages, but not vice versa; I thought
there was a memory model where holes in PFNs were closed in the vmemmap meaning
that just because 2 struct pages are virtually contiguous that doesn't mean the
PFNs are physically contiguous? That's why I was using PFN here.

Perhaps I'm wrong?

Thanks,
Ryan

> +			__free_frozen_contig_pages(start_page, nr);
> +			start_page = page;
> +			nr = 1;
> +			cond_resched();
> +		} else {
> +			nr++;
> +		}
> +	}
> +
> +	__free_frozen_contig_pages(start_page, nr);
> 
> That way we don't need to mess around with returning the number of pages
> not freed.


