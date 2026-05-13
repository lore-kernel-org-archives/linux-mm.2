Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02869CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669766B0096; Wed, 13 May 2026 03:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6407F6B0098; Wed, 13 May 2026 03:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556EB6B0099; Wed, 13 May 2026 03:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46D096B0096
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:54:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14FA21C1853
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:54:31 +0000 (UTC)
X-FDA: 84761634342.04.F417533
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 291F3140005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:54:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MMSb57Ve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zrdPFwI2a/D61cHlqK6/UJztOUHiruNDJJHYsI1008U=;
	b=S5vmGzqr/sIocOT9SRCXSIL4GYqfnbBcoaZAFr7c6xFqbOOEfyZ/tGntRhQyg1R06p8z+R
	dcdsvHmnPyJWQS2OLlIlPpAeg/EhixATRoPyrJsGJszUS7gY6Hu/Vw2r5Pnuo0uu2JqT7D
	07brc/bE+kjccMXc1xkHXVDpfpuX0JQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658869; a=rsa-sha256;
	cv=none;
	b=xsZ3Ixh1DflRZYtzewOZZbYU7CEbeXF1qpSxCoII4yeUyzptgJvM/zd/kBry/n+cVSAvna
	5vQ7QO0FP2uCQu8Vbbh30NjN91S+84MXMzvHPnYlgIe1yRLizz+M1hRGAosSVgDycwpg6V
	LIF5ix9nGr5SAG/EYz3F71Tos8ecEy4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MMSb57Ve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF32341760;
	Wed, 13 May 2026 07:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399DCC2BCB7;
	Wed, 13 May 2026 07:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778658867;
	bh=5fkTxaVzV67Mp0x6THoCadQuwmPOJZaYcb+VcvMagmI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MMSb57VeWOdXEwlbRHF4H1wJyw7LzX8e2zt39PI2tcH5khVQ/JKO0bzfWh+hgHTy/
	 /f2AnrsyQvgXBfNReRpAvGpe7P6Iba3WDMzdxgabnfwgwWqOfYq+QeuCIKIfw82yOZ
	 SbpoH+qAjPOALH5Pu5Begy9Whtf2B9RzbCSoXxxHUdwiAt1hZ8nNx8SZvbZDGghdqJ
	 9uEGk97TUCdjSh/lbRaAMjoMNm36B01uDz7I8kCrAdiclBC0uoNDwJM9+YvC76Z/p/
	 6Zt4xHhoLHShLkd9bbEK0Un+0sxAF9MWduSGYLr2P7a9Eqen3WyM5qcjEXaL0L/eu+
	 OyDj4h0l+avrg==
Message-ID: <bb0e5af8-3b24-471a-856f-2284a90a380c@kernel.org>
Date: Wed, 13 May 2026 09:54:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
To: Lance Yang <lance.yang@linux.dev>
Cc: leitao@debian.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net, skhan@linuxfoundation.org,
 ljs@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, liam@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <9504c193-8c01-4d03-8f62-c50fd7fbdbc0@kernel.org>
 <20260512124837.38883-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260512124837.38883-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 291F3140005
X-Stat-Signature: t93crtj7akd6u3o183s47oj81ogzn985
X-Rspam-User: 
X-HE-Tag: 1778658868-789197
X-HE-Meta: U2FsdGVkX1+2MND57MhrmgSPUVTMvE8PVezn3Pb2/Bbmaf8om/Fx9njVylbEY4z2BWXFRmieT1aZ0ylg/5YW4AZNpoHktFkbjltd8EzmWVxAwMCQd4uE8IRq/szi4jbnw2wvzKkBybVu+MVSYtMpdIgjCJTQwXV9eVfA7M1YfxWJzvaMzBm7RiYreK3H8DrLzdbs/NaBqfSb8erWea+lNyp1FIJ3HHAg5XF+jMEZ3mEXpPticpWvvShe+xbuP1IN/vSSu2NUGCR2tESxxeg1jyIeUX7DUGJkTHLzLEwRt4Dl1olj8PsIB1Wad7TYTVzxxnlXW1KOJ2GtrY1f2xfjwpbnnCsfB5Lo33ACTK4hOL67+JJ4zO+rhX8PQjWgS2U2jHlTKj2/Xt03zKQ4GFwNhXF1gEh9oLsu7zCFr0Rx+SB07dbvIeyuYHGF2jFLdcSOTElKb0eO8oHvomlqHFmh/AKNuq9ZWV/8GEpn8nq5gDFh8p3gc3m9JSWtBakaxXHXAaIcL+wMtmjKutlet33SZ7eSOopZeKa9+PoffhlOVc6JTwWRNDl1jzZZ5CfqK7M6tuFKUyKqP3LnkiXbq/rzqGmZfyS5C5MwCRxQzTRfDJZjEbAItEgibl9okzYmHT+Pvs/SKab141byTurTY5ZjLSxHpVXw1q16JQByaUAFKXwY2iSrvVnezzguKDP4osMynM9m9qFsb7u74aHHHoUaV53sl9KdQNmMS0Kqe/qfLoqJOKs3WSK3fwbACPPi53jTLw3jWuzlhHFyw/KWWw/Gn93PW45DnrX5XZ4Bx4GwNBdaqlgVvMJmu06SxWKVWJVQnu712eRFN4FZahnxYf0IEXrwcLNxRM+9Oo5dZR0T7i3kyNSrVy4ZPMIj6VzTejZxqwDxD2Avo12AxPDaisqeiN+qToziB1w2H0xSUhPfIdHG9UAI36o4GlburK/VGktpa4zDxvO/vRkfqnRq74o
 XGDdNLZ8
 cxnhwtfk3VeMsqcsRtgj7XedSuOPZvlX+c4jqPNQhCkm8F179lFmTRcqwDxkyLuSUKie0Yywaq7eacdOCZY2hzADbSSfejG7d9Rgc2fOM+3B1xDzPzW+NGY3pjNPiIDfc4YKRSHqoBAranJ3d3UYKATIYLasj+qcAQjkMOttx/QNjfrWIgZ1afcKxBrkuhMVVlFUzFwK38ilaVOzO22L/dYQjs9J9lw7S49E+OuTCIieWda2knEuZ+/HGbxyCMORs2Jc6eHlwzlch5gCpEZuKc7/EaMHQuAbCpYTZgIwQFy732hsoZFlgyYLjyuykcoqW3Nq9AspOeciY31X/DWF7gahmtQDathJAwOXFPWa8roicXVraHFdOvpGca9AhmmHvYzepcp9NTiNVhxi+lXTbbdItdH20rFiB5v99oOuPLKMCu90vM2EKwTPczdlqU9Tz3ABPRvQf6XkD7maYYSFwJf8922FmIL0TvUoq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:48, Lance Yang wrote:
> 
> On Tue, May 12, 2026 at 10:17:00AM +0200, David Hildenbrand (Arm) wrote:
>> On 5/11/26 17:38, Breno Leitao wrote:
>>> When get_hwpoison_page() returns a negative value, distinguish
>>> reserved pages from other failure cases by reporting MF_MSG_KERNEL
>>> instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
>>> and should be classified accordingly for proper handling.
>>>
>>> Sample PG_reserved before the get_hwpoison_page() call. In the
>>> MF_COUNT_INCREASED path get_any_page() can drop the caller's
>>> reference before returning -EIO, after which the underlying page may
>>> have been freed and reallocated with page->flags reset; reading
>>> PageReserved(p) at that point would observe stale or unrelated state.
>>> The pre-call snapshot reflects what the page actually was at the
>>> time of the failure event.
>>>
>>> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>  mm/memory-failure.c | 19 ++++++++++++++++++-
>>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index 866c4428ac7ef..f112fb27a8ff6 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -2348,6 +2348,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>  	unsigned long page_flags;
>>>  	bool retry = true;
>>>  	int hugetlb = 0;
>>> +	bool is_reserved;
>>>  
>>>  	if (!sysctl_memory_failure_recovery)
>>>  		panic("Memory failure on page %lx", pfn);
>>> @@ -2411,6 +2412,18 @@ int memory_failure(unsigned long pfn, int flags)
>>>  	 * In fact it's dangerous to directly bump up page count from 0,
>>>  	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
>>>  	 */
>>> +	/*
>>> +	 * Pages with PG_reserved set are not currently managed by the
>>> +	 * page allocator (memblock-reserved memory, driver reservations,
>>> +	 * etc.), so classify them as kernel-owned for reporting.
>>> +	 *
>>> +	 * Sample the flag before get_hwpoison_page(): in the
>>> +	 * MF_COUNT_INCREASED path, get_any_page() can drop the caller's
>>> +	 * reference before returning -EIO, after which page->flags may
>>> +	 * have been reset by the allocator.
>>> +	 */
>>> +	is_reserved = PageReserved(p);
>>> +
>>>  	res = get_hwpoison_page(p, flags);
>>>  	if (!res) {
>>>  		if (is_free_buddy_page(p)) {
>>> @@ -2432,7 +2445,11 @@ int memory_failure(unsigned long pfn, int flags)
>>>  		}
>>>  		goto unlock_mutex;
>>>  	} else if (res < 0) {
>>> -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>>> +		if (is_reserved)
>>> +			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
>>> +		else
>>> +			res = action_result(pfn, MF_MSG_GET_HWPOISON,
>>> +					    MF_IGNORED);
>>>  		goto unlock_mutex;
>>>  	}
>>>  
>>>
>>
>> It's a bit odd that we need this handling when we already have handling for
>> reserved pages in error_states[].
>>
>> HWPoisonHandlable() would always essentially reject PG_reserved pages. So
>> __get_hwpoison_page() ... would always fail? Making
>> get_hwpoison_page()->get_any_page() always fail?
>>
>> But then, we never call identify_page_state()? And never call me_kernel()?
> 
> Looks like we never get that far ...

Right, likely that should be removed+cleaned up then.

-- 
Cheers,

David

