Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 888ECC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2AE6B00B8; Wed, 12 Aug 2026 06:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579B66B00D2; Wed, 12 Aug 2026 06:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F5F6B00D6; Wed, 12 Aug 2026 06:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 213946B00B8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A90704021F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:59:04 +0000 (UTC)
X-FDA: 85092320208.20.1185BBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F30DB20005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:59:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C4c/VyOS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVDEOvc21CteZ5TMBNcUHD+Aeyjv25kv7zM1vGXS/tI=;
	b=iqxPzbnYj0IVEeHS9NrzP1VObhmj4Vdo48r075CIJipImxzD52aZXq5knmsEXcQLFRaB55
	nL0UfkEC/nTLQmL3yEXcTPPkfyJpZrfNzQsM3EdXQQdpJ2CVHjK2Buvehf4YB+uaEP1i1m
	YKu77fwDRe/tOoxIiC822W6nq1NR5no=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C4c/VyOS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532343;
	b=pARgaskIaT1f6OOk89yERiKrInque1H9e3TO3ozD4w1u35+mN24gtawdS453Rmv6EKpMo+
	H39T8ifv6HIZVefLQJHT3IDIwPCD2sZ3jFd6/JHAUQt+pN/c9vgcBqcnINQ/CgAp+bmkE9
	6zc44X9BKUtkQoZ5mB4L4f3xL7HVGhk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95FB760A7E;
	Wed, 12 Aug 2026 10:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6195C1F000E9;
	Wed, 12 Aug 2026 10:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532342;
	bh=YVDEOvc21CteZ5TMBNcUHD+Aeyjv25kv7zM1vGXS/tI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C4c/VyOSbx/e8pqmJX8RzB21kZ03+KBHnAksmzw6moWobIT7bciODydX+z36ca6hE
	 4FPD567diHVtHzyUyPHzONlNFx/Ug+YY6T5ec/VsHg4mBX7Ves2seh4q+gBRXBj6nV
	 cwMzwbDP1l9k4GVtZNgtd5VoY9IRnLK/z2TNXVmHK4g8t4QqcbNcuqwOtTfcIRVGCA
	 6O3hFi6IXLBatCirocmQxsLeT+3+Acjo+2q7eGfULmmwwm5G80nU3Yw94bRjZtRbvm
	 JACTkexpoadnBW4w//HQdIcHeXkOulYxBkOTnuMTPj8OM8P38QFPZZOyUENTvSXZ9d
	 0fhBKy9YM0zDA==
Message-ID: <aa00ab8c-6c8d-484d-807e-0305ce190e0f@kernel.org>
Date: Wed, 12 Aug 2026 12:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm, swap: ratelimit bad swap entry reports in
 get_swap_device()
To: Pedro Falcato <pfalcato@suse.de>
Cc: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-1-375ef0767206@debian.org>
 <a2e220de-19d4-4177-9703-0e8e5c57f269@kernel.org>
 <antOPhsllDia-UVh@pedro-suse>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <antOPhsllDia-UVh@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uoubfazoq1c64py4i9wced5e6u8kqwi1
X-Rspamd-Queue-Id: F30DB20005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786532342-181524
X-HE-Meta: U2FsdGVkX1+HZNU6b4y9T6SjvNGSwRP94vvhBP7YJUIknPtut86DwGU5wxhCK1JN1taQ3mQ8cdYX+QPMrvk7WQGvqc6CcSZbTUrNwu8tztGI5avPfQTeUZWD2hlkfC0nAK1np/bWe3/cufCp7d4p8+aBzcjnQXBUGLIADifxGSmRR6hI49gN/HmclpwxgzfapR+QLejOJ+Qdmg6hflI/3YgdXumtR8uW5g+EVRt4iB0yqLTuhZXH0D+vDOlXuMF8YRbrv+zS4aNDuNZFX+AsRXyozG5bJe5JjjdccOflLtrIlz4RjBPaEzyafRmM4cYNiRR5Cd8hrhnMAtxinwNSuJZ+7JzvQzRBpuaYzXeqV2WFIG7MkdQY71sXPh8/hCL4dJExtxv1d6Ta0lBbCGKxvzqzbLf8FYnBAhvsLNCUFor3XQ+alY+kBPhNpJ19WTRupdJPfo4kJ3bZHCWUYGNHCfWcDAyCOC/EhrENcHBkFrcxyQZk79/EU9zQsBj8N4rHtuJ9WOJsRzrT7I4727h5xaisfntWvWScbf9kQd6WqiUl1A/clHM61Xd8Xkwh+uE+RHtRb6JHnwn4wUGNg0tnq12MesU7FGDd51MgE7AZo+N196flC4iHtYUSGw030k45ZjebboFbbDiI7WxeA1TqUbeRmMR8C+gLrrFVubHeoA3un1Yz/2Kxmv4VT7y/oa+oZbauJR8xxYYaTkE9DPYOX/jcokHUugWhJXmJPom1WIcXJ+WNGWMUasAb9ihOjxB+qNtlmYsSCxndwUfRUwufI0mik0glpuBE23AykCeNiegX2ZFD9cnnP38kTuiOCh/5+LYSKd89WPXpJfUjQPxqdRpV4riNGf0BB/5eQa1vxPg83UgxeNt6e0BJZsoqV8FyGfR67azZLDrJ+2OExOtq/7rdnv743OQjal7J6pTyQw0VWusal+knAiI5HRRx53A95i4gnyQun5uPzSeaFuU
 GvFlANtp
 h6Ot7lA91axiEcpq4QMponvBVeCwODP2HNyW8ug0qTQwiybXLVegoKZNw8bq60NrcIcc2sK1NC9dxqTNS2nMHnc8yF+L/nmb1jI21b7BKEwuyFiYtb1cwAVh0ctmTIiQ0MvKgtmT24HYlC7j88UmDqUGBumw4z3ca9gO8+raeLNu9cfK6m0MveP9Lj1MLoerRi2wxcvij6Fu0iPtYPr/7T9nU12tGprVySNxP6eyzQS7Q3+22Hw2uC2y9aVZH74uNwZ7Db4oxFhYbALZjfYwk9MOu9cz6hGFXMphu2mI5MDamAmIlSSwdUmV6UtJAEJT0No8ZzIXjKRdObPJagd09JWnA1kgAeY67WaXB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 18:48, Pedro Falcato wrote:
> On Tue, Aug 11, 2026 at 05:33:54PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/10/26 18:26, Breno Leitao wrote:
>>> A corrupt page table hands the same bogus entry to get_swap_device() on
>>> every access to the mapping, and every rejection is logged. One machine
>>> logged 6185620 copies of the same line in a few hours.
>>>
>>> Rate limit both prints.
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>  mm/swapfile.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>>> index 4d4e3e3059f6b..9ab11dc24e4f1 100644
>>> --- a/mm/swapfile.c
>>> +++ b/mm/swapfile.c
>>> @@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
>>>  
>>>  	return si;
>>>  bad_nofile:
>>> -	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
>>> +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
>>>  out:
>>>  	return NULL;
>>>  put_out:
>>> -	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
>>> +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
>>>  	percpu_ref_put(&si->users);
>>>  	return NULL;
>>>  }
>>>
>>
>> In print_bad_page_map() we use something more advanced
>> (is_bad_page_map_ratelimited): essentially a burst of 60 followed by 1minute of
>> silence.
> 
> Is it more advanced? It just looks like a handcoded version of __ratelimit.
> 
> ... I hate it now. I'll send a patch I guess.

Thanks for cleaning that up!

-- 
Cheers,

David

