Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE45606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 02:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vXNZMZ8C
Received: by kanga.kvack.org (Postfix)
	id 0E9E76B061B; Wed, 18 Nov 2026 21:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D996B0665; Wed, 18 Nov 2026 21:05:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9CDB6B0666; Wed, 18 Nov 2026 21:05:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2EF6B0664
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:05:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 521FDA86DA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:05:23 +0000 (UTC)
X-FDA: 85450226526.29.98C3FD1
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	by imf19.hostedemail.com (Postfix) with ESMTP id E8B781A000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:05:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXNZMZ8C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795053921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tgWbt2Z1SnQ+uqrEBj9Epjmo8yeetyzDn0kN1B/Hto=;
	b=UcpZHmuHypJZGqBZJ8/B8IrlGYnIrdxZpYVRJiV7Vg9RgkAEfEXvglBiLY8ZdOdP/ELpQH
	tf6IcfBvPI3fivl9iSbqdIZoLNXHcEKnbDEtmyTB9PCLT5zWA2DIj3pGqyB+cj4gDWzLNi
	HczDlUqOHRWBguSZLJ/fBGeMXajyz4E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXNZMZ8C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795053921;
	b=PkkZJlushU+MWFgyHxAVMeAB8SO1NiRhK+xEFDufXtcXoKEruKICoSWAiguRsrXHRpxq31
	Pa3e530AUTUx3+I5ry/uRd6OS1tdp7LwyllvEB90KRALbj6FSI6J199d7xadgP665vY5Bo
	bloucKP41E7iCDcBbS4O8rAbkUrxEI4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bDmNCJobEh3kLoFNq205gwpfko5U2ASzt8zgMKTUjKY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795053919; v=1; x=1795658719;
 b=vXNZMZ8C96ZXrS+cOPJ/LiaKBfRy+NFncMsZeB+TkOvtEhnQcFdqI13phRE9o4MHBHa2BcLk
 tRqon18yvq718CTWV9C03z116i6ETIDLM7sr9pGy+IAKRs+0hbKmOOk7n6iC+xfE30GZiFC/QXC
 HYsKqJHUnuiG2wbwAoT6wTL8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 09ad55c582dccd0b;
	Thu, 19 Nov 2026 02:05:18 +0000
X-Mizu-Trace-ID: 09ad55c582dccd0b
X-Migadu-Flow: FLOW_OUT
Message-ID: <ec86fecf-0919-4da7-b675-3a9be49b50f5@linux.dev>
Date: Thu, 19 Nov 2026 10:05:13 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] mm: hugetlb: fix CMA-related issues
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev,
 akpm@linux-foundation.org, osalvador@suse.de, azpijr@gmail.com,
 lance.yang@linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <b1c1c835-180a-49e2-86c0-bc3f65981728@kernel.org>
 <7e733c3b-2aa2-406e-a5ca-cd9a2c872f9f@bytedance.com>
 <bc6ffcff-3aaa-43da-91b4-82f27513c761@linux.dev>
 <1e0aa28d-f81b-411f-92a3-6038c3961443@kernel.org>
 <c3906ff3-c5ee-4672-8bab-2318185268c8@linux.dev>
 <3e4b8ed8-c435-4fb6-ac74-b3a9eb40504d@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <3e4b8ed8-c435-4fb6-ac74-b3a9eb40504d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E8B781A000A
X-Stat-Signature: 8uuzkx8tmnfggcf1t9dmpkapx43nxen3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795053920-683243
X-HE-Meta: U2FsdGVkX19I/rMeKtRkuYtn5Ln7PxbFfYFEyV089mzootfv2XTP4rtz7WJPzofPF7DNTdcEzZisoFEy6F4Os6fETQRRWQfuTyJ2r8nz+eKjoH0uwqSPvJ14hjtwz59YXBfT/MtctSaxsPMiuz81U/K9IFHDwW/bbq3Nd14fI8sN75Yho9fqCz3pyfGtZhYhLAkGak8wiACfV9wrYGOqMn3SXKQavYyHD+xkvTheax0XciG1UzSqFJauFnsTjy4811osJL+uN0vH1pm31ZuME9Kc0yDMzvKv6vhxdUN1K1zxKwW7x0AGicO/etrUb7YET0FaBTe+qEYdqER30aByFuNb090DBaTytspgmviUy3daxiUNfOOhwz6+43CD1YCJA/JpejmhpQJfsvwhm8aMxH9BSYjdnvL4lwgTfXMOUJWe6KIkz57mhlUbwIcFRWzPRDo4I4UebFP+4LVoZMX12YU4VF6gyfzZqlZeKsM6DEnjotn7sZGGdiy3MaanP8jhs/chvonq3QOhwZR+vGbigICb2PKan65tjvownMIBYmnFmmRDpkRRVBsxTRZWnGgttKsh3W3tHFO2xhOqu1M4Zs+6dW1XR8lIWm4eqQW8HaAM39S1CexAv+dVWvhwzHVQ+bhCvVHqXgDVKJ2v7Ec+XbMf9vPcoqo7DfFT5jTNFL6RSkbsEKtQL52mhF9JnTD6s98O+5xhZOhfunTWu7oe7HHYxjspdm3K+mB59j+02dJ88LNxC7N5zoyLUADcz7ntaVf4LCL8NFtemgfA5C+xJgR71hC4pIroEbc52P+iLFn8IzTPWi6MvM9HcjDL6KThaliRJBbEa7vIehR0E8aYJjvUFewXyWwwZaIVmnr8jFM6Bt0JXWl+Y29Eulr/hewNY9uLRSdbOeDTpLpWcXtpdLzoQHc21ihPtMNJS72WsUQw7gBPhH0vsw0UN7ek8q/GZGl4ko8RAnbwyoeAZJv
 k3T4zWx4
 YdTsnLgb0/b8BAmF3fzUIwfyUaznAq72s4EWLA73Hnam6tuAX9vrzB3wDyGN3u327y+TgO1qndn0uCtucyfN6qlPdgbHaY1RBtoiU1GR64UIZIu9yHGiwacPa2cwWC/0ffo2qJ5Fogeem2nz3XAjXhmHbEocvf5k1qotOhn6A8Grc1oyLC9AS57woY3iJrvTCdnqDi0lgNXz2YInIrgR9DCLmCQxxZ5Cv0DIf0vL6pe7dCrlR2ANRuB0Ig7xACST84HiDfmZfUJd5TNhnJ3SB9RrSjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/18/26 11:24 PM, David Hildenbrand (Arm) wrote:
> On 11/17/26 07:55, Qi Zheng wrote:
>> Hi David,
>>
>> On 11/16/26 8:07 PM, David Hildenbrand (Arm) wrote:
>>>
>>> Hi,
>>>
>>> sorry somehow I missed your mail.
>>>
>>>
>>>
>>> Ugh, what a hacky mess people created.
>>>
>>>
>>> That would be cleanest. Would it break existing setups?
>>
>> Yes, this requires an existing user to explicitly configure a 32M memory
>> pool.
>>
>> But in practice there shouldn't be such a user today, otherwise the
>> misalignment issue would have surfaced long ago, wouldn't it?
>>
>>>
>>>
>>> Another quick-fix idea could be to always allocate larger folios first.
>>>
>>> That way we should avoid any holes, right>
>>
>> Ah, this looks feasible. How about the following?
>>
>> (If that looks good, this could go as a stable-first fix.)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 6fba92b0f6749..32e65ce347c90 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4556,6 +4556,22 @@ void __init hugetlb_bootmem_set_nodes(void)
>>    		node_set(nid, hugetlb_bootmem_nodes);
>>    }
>>
>> +/* Return the largest early-CMA hstate below the given order. */
>> +static struct hstate * __init
>> +hugetlb_next_early_cma_hstate(unsigned int order)
>> +{
>> +	struct hstate *h, *next = NULL;
>> +
>> +	for_each_hstate(h) {
>> +		if (!hugetlb_early_cma(h) || huge_page_order(h) >= order)
>> +			continue;
>> +		if (!next || huge_page_order(h) > huge_page_order(next))
>> +			next = h;
>> +	}
>> +
>> +	return next;
>> +}
>> +
>>    void __init hugetlb_bootmem_alloc(void)
>>    {
>>    	struct hstate *h;
>> @@ -4571,9 +4587,19 @@ void __init hugetlb_bootmem_alloc(void)
>>    	for_each_hstate(h) {
>>    		h->next_nid_to_alloc = first_online_node;
>>
>> -		if (hstate_is_gigantic(h))
>> +		if (hstate_is_gigantic(h) && !hugetlb_early_cma(h))
>>    			hugetlb_hstate_alloc_pages(h);
>>    	}
>> +
>> +	/*
>> +	 * CMA ranges are aligned to the largest supported size. Allocate larger
>> +	 * sizes first to keep the early reservation cursor aligned without gaps.
>> +	 */
>> +	h = hugetlb_next_early_cma_hstate(UINT_MAX);
>> +	while (h) {
>> +		hugetlb_hstate_alloc_pages(h);
>> +		h = hugetlb_next_early_cma_hstate(huge_page_order(h));
>> +	}
>>    }
>>
>>    /*
> 
> I think this should do. Best to send out a proper patch.

Okay, will post a proper patch.

Thanks,
Qi

> 


