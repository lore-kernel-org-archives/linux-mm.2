Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086A1606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXVQUnfR
Received: by kanga.kvack.org (Postfix)
	id 1CF066B0165; Tue, 20 Oct 2026 09:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8956B0166; Tue, 20 Oct 2026 09:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC1B6B0168; Tue, 20 Oct 2026 09:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D77C86B0165
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:58:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 621421201D8
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:58:38 +0000 (UTC)
X-FDA: 85343159916.16.A004BE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AA4E640004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:58:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXVQUnfR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792504716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KbcahdPnsareS4RJrUZQnfYvFwQkIaOnUakAWhA8PE=;
	b=bYKbzEp8YCy1Avx1I25anzr21tuMNtKDa7cwFyUUuwpAA6hwBGKOjUA6ASMODtbjgSU5Up
	dZ4zWQfCV5sXovX+IOZpRi8JUxC9BvfBauA02aIPsQcntRWdv4INLta5v4r3yHeb4uQ4sv
	lrIg0QH0DAEPatXkB7LLUIPunkab5Do=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792504716;
	b=HxzOD7OtitjaednQxhYrap1b7mGG5e/qKhimWyhjkbBS1ZmrbSzNPOsah5uxYNQ72QMs5n
	uFngOJyjN8SNE2NbG5aetEPti9YGL1QxVf1frYFkmxldWzOeSZytsxZ4FYJAhL9Z534Zi2
	q45zJf08Ngl7cClfGkI5SFayeImYkSM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXVQUnfR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3549460DCB;
	Tue, 20 Oct 2026 13:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0778B1F000C7;
	Tue, 20 Oct 2026 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792504715;
	bh=8KbcahdPnsareS4RJrUZQnfYvFwQkIaOnUakAWhA8PE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WXVQUnfRcR7QdAGNfG4lqnfdEi+SDlj6/QuImGNa7kvBBiZ5esx0GfFWj9JMuMO7P
	 DTRH4vXPH4TLoQIAc1qpeEMQHmyrs2QY8I6pDSRLKRvd8gL1VyDAtPdhAXxqoYwTuc
	 IQvgObBgcPtisgB/q9If8emoHa33ifGcpMd9ZjuLIFUGguYQpR7kRwjf/0DQJhZ1xn
	 WCJ5JBWs6uHoF2AaZOjC5RkW2R8X08O0fgNHofo/HYX3qqJLLGWfY+PgpRnlss/uSx
	 UFoh2CaNO8JnRAp2w9JMW3Hh1TemKaAg75UwTJcLK6bj/8LG8dBL7A/8zOFw9jN/vR
	 ySa87WI8zNYgQ==
Message-ID: <9da90d76-031f-4211-b9de-439cbf7bc63d@kernel.org>
Date: Tue, 20 Oct 2026 15:58:30 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
 <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
 <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org>
 <23d3756c-1a87-402d-80b4-c838dfc29f4d@linux.dev>
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
In-Reply-To: <23d3756c-1a87-402d-80b4-c838dfc29f4d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA4E640004
X-Stat-Signature: 3a7uteicsthnheyzuzgr96ugxtoco4tf
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792504716-3774
X-HE-Meta: U2FsdGVkX1+TnmUPilV0s2+N5xvhw9kcVgyjtv+ewjdjozSZck+7lDmz71ZIOPyMpKgdD8KOs0Qyi1YmQn6xZGC8XY3qsDcRIYjbxAsSk/FBER9Sah2ygd1MSmW78T1s4/+eoNg6SCWbG2VkqCFxL9JnTm3HYHEuYKUoW076L8m+5Jlzna14HdDJ1ypA3pjKmTeFLw+70nVQA4MfLXu1KtqrF26xwzhRrvv/Z8+nDVMGF1sBhesBWCt/m+zhZUePJi9isE5kOd9IUwrD3KZ3yjCwPuRyY9tY46PiH+FyA0uB+ku0kvr18Dg0mJmxnLxkHOPK7L0hXO8prTBP1hw5jwf0on7D9dD3Bw2XSTPvoN9mCTbn4l/hGZ6BYCQtAvFTyP7n5d0Q8Fg68EzHNNpQ7cF3E/ZIOr9FBqWzEun6e/Y5WQ5BK2nJNPEt5xwSYQELHwvF3XfsOmpnBySjsPGU68Furx+2bHiXFWBWG07/s44dYyBnUVaulNcOzXXnsldh3g52/VTzAoUpZ5GC+Dhz0D1aj08LY5rCEb7xfoA/6OOw1T8/EFjYcz6RVbOQZWz3wlmEoWCXD9uGJX3qsUt6gMmpfrrvkEK8N4d7+XfM6LTfSSXp61fcxVpCQbiiM+39D8QkeQH5Fs60aolr2XygvQ7tykK15gVBmWh2L34K+0C29Aqwf3597VXYc7woYMyLy1zllJcPgIDkNrgvWPLXfQy0hy1VB6Pvm8M8P12ftzZ3WYWNTz9Z6eJu7q/Namg0h/m5XcdzW2ho6AWxMX8xlhDgIIjpod3shSaGnP1iSeahnwXESqi5BR+x2gLJ9vr1K82iphEucP04KJSGgQl/SOwRSjj01kRH0TNrj1h2lW+97dKGkMRYmPOdab1rI7d3yo9Hcdd4wG0Npx2YGJlwU7EwDHJEXn7EN7UPrX7xdOHDfaZhxmUjE6YMKO4f3n21qwE9WKmPycYXWlaxqLg
 cHnDGGz9
 w3IdudtXLV1lYRH5g/B3rxamFKId8phnPcAZSV29Bz1rmqA8orp1GyNsNkxxrFg1Zyl5scLD/jT0CdJZMhPADTcSGUQeFtbdyygR624eLzbfX7RcrS5+OEFqRwXWtwzYldv4jzb4+DimyVD40Sn8G3GxK54325weVbHidVB5rwxbGjCLN466LCNJP3Y69VA82ltxnq56b7cNRsFhW8wNwm1pvsxA+chViyf8n5LDa7l2W2x+rkGsF4+P8xD2PxX7uyuBQZOtJ8NS318RV5PmmAyPD4aRqOEkfKZ9XGCteluZHGlGpOGjz+cyQxfEb1FGlDQgZbSol10em7bnkgErUZNQ3fe+5jHeXpU+Zf62k+rOLtz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 15:31, Kaitao Cheng wrote:
> 
> 
> 在 2026/10/20 21:07, David Hildenbrand (Arm) 写道:
>> On 10/20/26 13:27, Kaitao Cheng wrote:
>>>
>>>
>>> 在 2026/10/11 21:14, Huang, Ying 写道:
>>>
>>> On architectures with hardware error correction and exception recovery
>>> support, accessing faulty memory automatically triggers an exception,
>>> which itself guarantees atomicity.
>>>
>>> On architectures without such support, even if we implement this logic
>>> in copy_mc_user_highpage() and copy_mc_highpage(), checking the hwpoison
>>> flag and copying the data remain two separate operations. They cannot
>>> be performed atomically, so there is still a race window between them,
>>> however small.
>>
>> Yes. And you need proper architecture support to fix it?
> 
> It does require architecture support, but that doesn't seem practical, haha.

Well, but that's required when an arch wants to rule out all races.

> 
>>> Moving the hwpoison check after the copy might address this issue.
>>> Is there anything wrong with my understanding?
>>
>> Will architectures that are not prepared for copy_mc_user_highpage() not simply
>> crash if they trigger an MCE during an access?
>>
> 
> Do we need to check both before and after the copy? This feels a bit
> redundant, and I'm not sure whether such a small race window warrants
> an additional check.
> 

I don't see how checking after the copy makes any sense? :)

You already crashed if there was a problem, why check? Or what am I missing?

-- 
Cheers,

David

