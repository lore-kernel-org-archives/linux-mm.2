Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36484C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03AC86B0099; Thu, 30 Jul 2026 05:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012BC6B009D; Thu, 30 Jul 2026 05:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B136B00A0; Thu, 30 Jul 2026 05:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEC3F6B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:29:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55BA080337
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:29:08 +0000 (UTC)
X-FDA: 85044919176.16.1E73563
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 89141180002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:29:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRnkjc8P;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785403746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qF85TGZj/niZ/mEGZlYzqc0cbtZ0CgIxmW9zrjZkIk8=;
	b=UsuT49L1HgcNkzJ7RmJT5io+lQ7Bzaz/FMblMw1mj5g+YSuV5KZ1QsfZKbc6SWxYvd1y7f
	FY2dBcZOSribsPvf7aNhe+YyqOyj6tok+SpzDk9X4hiAFUZaw/m9CAj/m+P3AumBIXKjBW
	qTuAi05Vu6HZwD8U+yuQLoraVgBeWFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785403746;
	b=PSZOEY3nrY4yJnDqC1VgDRwcstU3heFASUX89LNHFoxpYVYedxXKhHgDoCKs+Drw5A6lu/
	bf3eqPmkzyna6sRv6Y2qOMRFKQGMb5c3tBGt7ajSKl0orTUc5gSDKmKnZkhaDeV3vTmi+H
	ndl35wHcP89Pz0KTCTa+h1KT6xeIebw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRnkjc8P;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C11FD41FA5;
	Thu, 30 Jul 2026 09:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF251F000E9;
	Thu, 30 Jul 2026 09:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785403745;
	bh=qF85TGZj/niZ/mEGZlYzqc0cbtZ0CgIxmW9zrjZkIk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mRnkjc8PEzcdgLosKuDo9W5Ok4pnCQFFHZKl7jIH1MyWc5UZ6Z/M9+dpM8y0Loil5
	 Lf4IJRMSwIWFjqzPwylw3L5+M7v4ZbOBWytqAS+1Bz+vDriy2Q6fzncCPE1jIM03bz
	 efxJk4g2FEqWtJMOCVNbvH8zHvjQqozYIQk6q0Z1jpuvxSjADF2gT1XmrBUKutHJSO
	 cdPIwwKFEVz5UfiWVcaWSZL7N98QUM/BbGVlWIvZe8hA3/PJ++4PnJEK+fkDZtWk+A
	 DyjrbAh5GLzSIpBbMsm0beKvzr3yfHjXJ2njrCoYddtASaeLL0cfkwt4rWBvYUcssC
	 jUkZEpG13Phng==
Message-ID: <6a3bfdb9-7839-4f39-ba5c-5a0c55055aee@kernel.org>
Date: Thu, 30 Jul 2026 11:28:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/2] mm: allow smaller large folios to use
 lru_cache
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com,
 surenb@google.com, vbabka@kernel.org, ziy@nvidia.com
References: <229c3079-8fde-41b4-9d6c-f0e34f780555@kernel.org>
 <20260729222651.31321-1-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729222651.31321-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89141180002
X-Stat-Signature: 7ywf1pzk4sf7opajiujr3h9dsychjhda
X-Rspam-User: 
X-HE-Tag: 1785403746-29618
X-HE-Meta: U2FsdGVkX181l/GiSuYwMzu5QFACZAlrJEQhgj2oRSKvzgcaGq9adNbI0qM8FY3fUH4DZI1m45pFsodGfMXUMzgRmqAQYxI0oP46uvG6sAelwwlhXLu+1kclBPxNj+tpyOoRKgJOfVYdJ84RgZZtOZJWJsGweUnk1gjJy1XW83/sLxt48KOSzpdsN91xun/3AQOsWaN/d/ajcUMoHEoIeklrjTEIyaC3+Gjxj1Xe5sFZsA3cA3jwsNw6MXg53TtstfQK7IfBzvlSPjYHEK7n6UsVpo3KyqwmlLmSM+O5OtxEv1czCHg3tGQuk2j+jVNYhdCSf/yQH8xQqZoXf2Nf0gwiskxdZiFgI9kJ/GNhQkQnhyp7DMoDskeGKXw23XBiH8O7haeJEhIRVuoZpXqhMPIL/W3D2mOXJeVLDo5DYu6nLbDOV50ZRy19Gl6ljaVavLZWYfTDvSCVRW+qkEF3+tcz7Sqw4/dttO8MxAcPoC0qWhEOpaQkIUCPxNhpGxjwvelJotPx1OazzEXFLEP3FGySEb/VLUl/BUnSpgLwD0sUrpti00cpl2NOkGjthk+LTFlDZ8oa6AJ1AkAm4ClszGkKjC6cW0i6UcTxCaNjI1mbe4CKNYA7AQFxxCnY3Xrasc/JRyCn/C+VA0Hu9ii9gB5VsmSOUtVO5Mo+lz8QCgYE0ie9+ImBmYH7nIpG2WHxrDId4gzqtXqMUj1FDV+tkXiI/7IBYuCMUbH1RArUk3BKcrrjAZG4LqdX/zoE+cehWpLo5Pitsjl99Q+VtEyTJaFeLBV473x0kHEzCuCg2TdJj65ZNeO2ikgf1vT6CPqry9UPIK94Xldef/ZvBala/86y/n5XZmAO8h85r1R1WAoRa6ZghIp0P5lMf2W7wtJGL/AeiyatuvPUDTXLgAumzzS8blXTMrf/zegEaVZf3XwpfsiewhCUKyZMBOV/5w0KHEym1q19M0EPd6Tdjb3
 qxSjzB/m
 KGEYyAA7zvzPLylda5phcDFVYnaXMYmxSic6O7x6pzXZXLJK6h/6lWyOfdYX8dhAMcd1p0NZFdQNPMxe6gPAv1eabOTu12RNr9acRsQIpYUuWF2j+qtbH6qBrAdyXjHq8mtm7hwLRhbtqn2wuWPNJvramw/SK89s+dxMgTS23HOMrZQ1B9tsydn1l6dqXeJoprGbgFHrovXCqRLUqGLrtf35ylO3YKxjJQBl74NV09Pgzxk7wDWaRRs6TEeNF7W0RCA33lfvdf7SBbjghsd6u4keOkQGwH4rg4KpciK8LQP1xxsH0vBhxU10Ni+1sRcu1zJE94dKMgWdi9Yarl3ZwpelUiIVe959kxV2st8ziXEjP6FGwFB/e3jC9d0zQuk7iik/J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 00:26, Barry Song (Xiaomi) wrote:
> On Wed, Jul 29, 2026 at 8:13 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> [...]
>>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>>> index 8d19be675baf..9c5f7a11c7b0 100644
>>> --- a/include/linux/swap.h
>>> +++ b/include/linux/swap.h
>>> @@ -316,9 +316,9 @@ static inline bool folio_may_be_lru_cached(struct folio *folio)
>>>       /*
>>>        * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
>>>        * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
>>> -      * will be sensible, but nobody has implemented and tested that yet.
>>> +      * will be sensible.
>>>        */
>>> -     return !folio_test_large(folio);
>>> +     return folio_order(folio) < PAGE_ALLOC_COSTLY_ORDER;
>>>  }
>>>
>>>  extern atomic_t lru_disable_count;
>>
>> Sashiko rightfully raises that split_folio() can now fail more easily.
>>
>> So we might want to proactively drain (earlier?) on some more of the split paths.
> 
> Yes, this is a pain. I haven't tested it, but perhaps a
> conceptual model could be something like this?
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 04e8a6b55343..fcd449dec96b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4069,6 +4069,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
>  	enum ttu_flags ttu_flags = 0;
> +	bool maybe_in_lru_cache;
> +	int expected_ref_count;
>  	int ret;
>  	pgoff_t end = 0;
>  
> @@ -4154,7 +4156,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	 * Racy check if we can split the page, before unmap_folio() will
>  	 * split PMDs
>  	 */
> -	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
> +	maybe_in_lru_cache = folio_may_be_lru_cached(folio) && !folio_test_lru(folio);
> +	expected_ref_count = folio_expected_ref_count(folio);
> +	if (expected_ref_count + maybe_in_lru_cache < folio_ref_count(folio) - 1) {
> +		ret = -EAGAIN;
> +		goto out_unlock;
> +	}
> +	if (maybe_in_lru_cache)
> +		lru_add_drain_all();

The drain-all is nasty. In  collect_longterm_unpinnable_folios() we escalate the
drainining.

I think we recently stumbled into a similar problem in guest_memfd.

Ah, yes, there it is:

https://lore.kernel.org/r/20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com


-- 
Cheers,

David

