Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACA9CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9DAC6B0093; Tue, 23 Jun 2026 06:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E3C6B0095; Tue, 23 Jun 2026 06:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D496B0096; Tue, 23 Jun 2026 06:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 708BB6B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:05:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC7B0166DCC
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:05:30 +0000 (UTC)
X-FDA: 84910745220.12.61A2986
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1E3912000E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:05:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iXq0M+bk;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782209129;
	b=I13dPi3NWzisFCFNexHONR+AggF6hfmebdIOn6HAY6albRRP2CQpXqZeD5gnR/xBMrxbqx
	d7LP/IgV6G22kyrrVqzY0ymeTwiUb6G0dNUR5vxFWPaj6UN+/3QCeGRZCtceG8lZoLVkCQ
	Vj10zJM6p1VyPO9HdnEvLiOPWQ8hEGM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782209129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3u1SRP8WX2qvNfRNBLXT6gUaHrTTwGTqNbq02MorydE=;
	b=UMuwv0ftdBHiy91QIWeB6Q5ukVYNbQYF0HZ6UjQ56r/89b3wz775IEo8wfZldCZe47GEHA
	FaQmc2fxlZiUz9kugsn11DvZY3oaliHInxKovwc75v/63cU4FYVJX1J21RxVp6XEqhFT/R
	/Et3Jw5KIJ1zxdkJ2dRzeOrp2Xy9sZE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iXq0M+bk;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85E0A1A25;
	Tue, 23 Jun 2026 03:05:22 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFEAA3F632;
	Tue, 23 Jun 2026 03:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782209127; bh=iCAi4kghzK4zKgQDV+QmVx1z4g6L/JSiiDzsaIfIioA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iXq0M+bkRbXaLZQCmiCkj8WpNZ/Usqvwrkt6+n/60955gaN/J4rHZ0YTEueZa2S0b
	 01YBisTnjFIJm7PScsGEomxLX4Qgk7odBt/1E9Q809URtPSf8oTt8gVaPCKGw093BZ
	 W6+vDV1IdhKpFm6hx25sUQxsoSYjOKbXOkUfcsxc=
Message-ID: <a969758c-1c0b-4f38-8528-e17810638c7f@arm.com>
Date: Tue, 23 Jun 2026 15:35:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/12] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-10-dev.jain@arm.com>
 <2a1781f3-741b-4073-b23f-f5cb3f0d98e2@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2a1781f3-741b-4073-b23f-f5cb3f0d98e2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5bmcci9frzikm867yqwsm5qwfscx5oze
X-Rspamd-Queue-Id: C1E3912000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782209128-407389
X-HE-Meta: U2FsdGVkX19NWsEhOd+GNI3n798j+R2IZumyhOMRNjk+nOl68H6sq7uy87l2Thna4RaGlNioA+kZtEiwUPulpviyVd2+GHPg2QWgz3j5q5NkrBqTX1OKBeI8OZWHzX98gPA++C69Vd1a53WckQsdv6qh5vg147VfffyLnFyTnh9JTi5nlgPIqmBe2nn5FlLY4rq0grK+IcqC6r0tIu8YOmK84A/8tkzsM0et4XN33qsVS7qxFN7zQkG4R9woFYAOh6y8Q7S/zWopuRYwjceCO3mK9amhfOARk51z79CiRnxPBiMc22xyGY1fE61UZNz9+PrOWJsTE2X4LJbZR9Y0x8sQUYA3qfK3jVWah0e1jA66/ofCM1HD1ncYYrWNYYo6fPJ8Kt+edyozKtnid9fklSvMrnZkNcq5uvhmrqpjFUpPNxhXKvRU0JyR6lrtIR9lC3FHGX41VQ1WHnMCP7hCgj2D4vMLHY92h46PovFJV6XjN9eWI9HyRRUf1lQzXjyaFTFyOZV9PTLj5Tokc+yLzICx0ZIeJ1WSRda6f7Mwya1z+svVl/dX/rcKULumoX8Yja3ImiFLuA9qRzX25rRIFYV/Fr8TUMPN8NyQLUMiEZkOW1zX/haVQIcyfq1zp9ETBpLwKGvmIm6RXdWIbSYtt+rvOt3TZyXrDFNmf49HJovykBzISA7+cZe/ir7f50zCWI4vMYLOSLbrZWVmL8ZQfJtVzN+WxUcKJobeEqv4hLqYFufddQGxMAi4QmHtrpAtV6x7UHyw75CdyrVxcJIXIzEpIhpZf9vMK120QuhqBRrh/pu6/eBD1v8WBqsgaMICOfcA5iSiRfF/8/UEqv4tEcXKNEux5Ktximjgo6HlQDj08UWn6m9HZzmVzUna41uMAUFM5g8vWQS9e09p8mOE7LgN6Upwj66DueX3h+sqhQnWK1s0yAHJwSbXuFi7gLxXj7lW9CH1o0C/viVHs5b
 Zl23+Zx9
 UCASS6xQo5WibNCeYRmMPQhbWabEuqogRZHfciwUl5XAxdFVp4d1bR/keQluoFuJbj9uhLx0pglYdLUR2Jy9EDLoBJ3Rb/ZGPTrgy11Q0zHMV+S0kfcWb+C6qYM3KTLWvheKy/rD1gof+C6BZSjDovR8nXXlyFokMz+l06hor/BOu/DhEri9Pe4S+ko9k6TLoSG3g/bmadPBSnYAqRWCBd1bCutOrsHdAPJKISX6QY4SnxulMkq96XUt4oOpLkQGR9XDZgz1SnGPGtZ3U++H3UXxBX518QFnwCKSOWhsGZhVIFioIpayrlB0HfkM+1GTOpLAb7J9CH5I5yAWpxf3awVpElw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/06/26 7:34 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> To enable batched unmapping of anonymous folios, we need to handle the
>> sharing of exclusive pages. Hence, a batched version of
>> folio_try_share_anon_rmap_pte is required.
>>
>> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
>> to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
>> batch of nr_pages. Refactor the function such that the clearing of the bit
>> can be done at one place without duplication.
>>
>> Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
>> from the PMD path, but currently we only clear the bit on the head page.
>> Retain this behaviour by setting nr_pages = 1 in case the caller is
>> folio_try_share_anon_rmap_pmd.
>>
>> While at it, convert nr_pages to unsigned long to future-proof from
>> overflow in case P4D-huge mappings etc get supported down the road.
>> I haven't made such a change in each function receiving nr_pages in
>> try_to_unmap_one - perhaps this can be done incrementally.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/rmap.h | 52 +++++++++++++++++++++++++++++---------------
>>  1 file changed, 35 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 8dc0871e5f001..64929490a7cfc 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -706,17 +706,18 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
>>  }
>>  
>>  static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>> -		struct page *page, int nr_pages, enum pgtable_level level)
>> +		struct page *page, unsigned long nr_pages, enum pgtable_level level)
>>  {
>> +	/* device private folios cannot get pinned via GUP. */
>> +	const bool pinnable = likely(!folio_is_device_private(folio));
> 
> We don't seem to have a lot of users of likely/unlikely when assigning
> variables, so I wonder if the compiler really uses that information then.
> 
> git grep " = " | grep "likely(" | grep ";$" | wc -l
> 32
> 
> 
> Maybe clearer to just push the "likely" into the actual two condition below.

Ok.

> 
> [...]
> 
>>  /**
>> - * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
>> - *				   mapped by a PTE possibly shared to prepare
>> + * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
>> + *				   mapped by PTEs possibly shared to prepare
>>   *				   for KSM or temporary unmapping
>>   * @folio:	The folio to share a mapping of
>> - * @page:	The mapped exclusive page
>> + * @page:	The first mapped exclusive page of the batch in the folio
>> + * @nr_pages:	The number of pages to share in the folio (batch size)
>>   *
>>   * The caller needs to hold the page table lock and has to have the page table
>>   * entries cleared/invalidated.
>> @@ -797,11 +807,19 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>>   *
>>   * Returns 0 if marking the mapped page possibly shared succeeded. Returns
>>   * -EBUSY otherwise.
>> + *
>> + * The caller needs to hold the page table lock.
> 
> Isn't that stated further above?

I'll drop it.

> 
>>   */
>> +static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
>> +		struct page *page, unsigned long nr_pages)
>> +{
>> +	return __folio_try_share_anon_rmap(folio, page, nr_pages, PGTABLE_LEVEL_PTE);
>> +}
>> +
>>  static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
>>  		struct page *page)
>>  {
>> -	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
>> +	return folio_try_share_anon_rmap_ptes(folio, page, 1);
>>  }
>>  
>>  /**
> 
> In general, LGTM.
> 


