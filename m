Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB9ED58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87AB66B0092; Mon,  2 Mar 2026 03:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844D96B0093; Mon,  2 Mar 2026 03:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744396B0095; Mon,  2 Mar 2026 03:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 636B66B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:01:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24EDD160A4B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:01:12 +0000 (UTC)
X-FDA: 84500377584.01.D40DA11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6CD091C0011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:01:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CXozVL06;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772438470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sv10HSeJjqxeWamiCfY7evLjvxMX2W6zZShwxzAv2uk=;
	b=WP6jTyuy2AG064OnSdyW5gcU4DB10k6IoxwnV2sykCbBwoXs1f+gRjPQ6DsRqEjFvuEzWw
	tASlUNJlQqNaW7J9by9MqqqD80tFwOuz2N9jMEGyR34LTli7MZqUr5VR7xxnbwp9JzDRoQ
	V7kP9XgjH99zomCCb4YusYI0L8/R7es=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772438470; a=rsa-sha256;
	cv=none;
	b=G0546fv+hfM76zQDbFHvpt7FCd+5UrNfZwrsiMkqGYxskXvzlBO81Mj5zJ12/plDsPU8R4
	FbgMlk5ypZfP3Ax6dfNUM8/YiA4o0ZhYbXE7DyHcjDahwN6QlxOFhJLUyEdbX+bJANobgU
	EAvYSqRTAT9Nt66ViaTGGN9d+3nfSSo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CXozVL06;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AAFD560008;
	Mon,  2 Mar 2026 08:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E106C2BC87;
	Mon,  2 Mar 2026 08:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438469;
	bh=6OVW2lcCCZK0yzTjbSWwQS8UnKWyGcAyks9MvNfnlGw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CXozVL06H6mQtJt/dPZugbcY1Wtz5JKZQhkY9wPHbHzhpadD9uVQw8ANnVwcPYBfc
	 eV/gEI1zXwdtDRwPB66saJHit184PIr5iWqgXui1Cbo4jJEdt2Gt9jVob3PWe/jWK5
	 9Dp5IrsO15DBRbm9qJEygWyrs2mB3UGulU6C+jC/6nmKodXch7dDt6FUiOWWlZsmEF
	 4LkcaMIrJvFX4EIZYyqxXa3AaMGzwVAre8KVHG9UvmgBTqxrGto0hABG34/zUa68sW
	 r2uEgZ3cFTzI8ZI2lzu9vZLKIqOXverboFWe8qcGSpfYsXUxmwrhHk6Putxj+4XAjc
	 LNOo9o6oCu6Fw==
Message-ID: <fdff3384-d62b-403f-a89a-f32abdaabe63@kernel.org>
Date: Mon, 2 Mar 2026 09:01:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: A potential refcount issue during __folio_split
To: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>
Cc: Linux MM <linux-mm@kvack.org>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
 <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
 <20260223115948.sbylmtqhznmabcth@master>
 <097A507A-C60A-47AF-9590-1D6CF712B1FE@nvidia.com>
 <20260301235902.duqcfrymearzrpds@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260301235902.duqcfrymearzrpds@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dj1f33hfns9oztwz1ek7xffh7cub47a6
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CD091C0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1772438470-661446
X-HE-Meta: U2FsdGVkX1/kZYm/6YLWlb4Vi3MlP+agETVegRUo8h5BYzyBH+mL4GJDLKhdorhfiO1q22v2lMJC+TLArIHB5C2Bf3qBOzN/NxSL8S4H+Ac5HPH8IXyFnDFz9xe7gHxB5o3p8J8YmDyvDRjfUH79bO/5kiFsc45B04KlkfAl6fGz5/7v4ImfoXMDpm4NWXVojWhjgKne9qra2aWg9VYY4Trr07an9lC5rumcGvjb85zDbZeqXpMsawkA6/gLIaZCbVriRA24o5SGSCXiU7zG+XaDq8Ta8m9KTmLnPdOsOOHw1sjDyiJjEkNmB+SHFLhNf/rLEapLWidkV5I6A34+a43Fwxhj5EQ3jFAJ2LsYQe3jRkEiAaymz2iU8W8GFNgX2000tjKudnulVasWkz2Rnj10G08HOBxHnIjYio4fo+hOX8SOy8YZDcamq6CL8ay8t9iyxfA3M3CoNGlSryTHqq16JiLptFARNY/YwpXh166w5uAzJJOwQgPCdCN/jzLW3yeDSOlZb2MZY381WGzVntix51WFU3uXmaRQi+TcAiwpx7PMidXuX9H7k8rgsYZ/ywnb7EpywVXiG7vbk4TJAj2D+MnBcdo7dOsaRYFJgSe5e1WcLJpZEOKqhoYC374WeZAQ/g0Puf4D02IrLr/lKMepAYXPKd9OArPj92koACR9mE0qGVO990cDYxpkETKXq3+SLCFIOEyAAH/b4CohRxkqu3Sob6GQg4U2zyNZRoiSJiU0uaMSsr4QuJidotwwpuymvN6dgT7WmCew8dvZfcVH+BQis3fS/6JTP90cs2n2a70ZeKNsUahRfVm4rSksGxLEnfPMSWsdj6ht9zu616Icvpg4/C6JIdITPl9U5J1/QdVVpzv553tcxMePTAdv3Mot585STwTOpQYQTTXs8MN0Fwa4x9Hl0exfNLwe5/BNC7opC8XiRW+P3YyUlfUIx6dFjW9V+2JxhRILxZA
 eZo/b/s5
 ys6D0EhnwO7S7nr4OvmJ8zc+MB+joyI1+8VITLL4bQrUWSMCxfOr/a+G6QGfX1oK1BuvKPk0qL/+CV83JQdenE3PpFZNkZhW05sfkPogxiq9TidhhdgNyr6TKO0U/wW6FrWxCykjqWmMUnCAZmUBxEcGomy3A/h8TPYmEsXkGIY7Vn2/LMfEg23bFNvrk4Rvq/NPfQgawwCG49z9WcwosTj4jZ8Lis37xrxBSIKmOlloevcXmZLs5a2kBAZGEqmR3j9XqzMPczFDCUbQYa3BFjbEyrMzzf7VoM3EnIqkpZ1sRKjjb6LIZvbdsTcLokWaR7NdGVKamHuJpSIdhTs24fVGEewgf4BRg9xLEbPCdPYEoZRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 00:59, Wei Yang wrote:
> On Mon, Feb 23, 2026 at 11:00:01PM -0500, Zi Yan wrote:
>> On 23 Feb 2026, at 6:59, Wei Yang wrote:
>>
>>>
>>> Missed this. Agree.
>>>
>>>
>>> I am afraid it would be complicated?
>>>
>>> Well, we don't have this usecase now, could decide it when we do need it.
>>
>> The patch below should work, but for now, since we do not have any user,
>> it is better to update the comment and add a check to make sure @lock_at
>> always points to the head page if @list is not NULL.
>>
> 
> Hi, Zi Yan
> 
> Just want to confirm what we prefer to do now. We have three options:
> 
>   1) update comment and a check on @lock_at
>   2) fix it as you proposed below
>   3) do nothing for now

I'd go with 3).

-- 
Cheers,

David

