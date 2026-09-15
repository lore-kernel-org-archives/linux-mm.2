Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF8CC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37616B009B; Tue, 15 Sep 2026 11:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10C96B009D; Tue, 15 Sep 2026 11:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF9F6B009E; Tue, 15 Sep 2026 11:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 868C46B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:03:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 249ABA0445
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:03:29 +0000 (UTC)
X-FDA: 85216315338.28.FB93658
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 628BCC0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:03:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hms2AIv0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hms2AIv0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484607;
	b=pNr+tNbDAjwJTEnQT2k4niPu/QNUKNpn0ctqTznEv78VFXAU/Y5k6eA3Vdh3nRqjJ+035K
	Ra/igoH/BrVI80rEpEGEAGTqeJ2CDQIch2BN/dvvSjpEBkruokDzcLb2w10SfhU0Ldhy/1
	/qGxJX9Ob1LtZuaZBlFDXtGrxv4hPJg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3oWpYtarkgkFED8rLFP9I2go+4dZqhBtgLXgfVyojE=;
	b=zvjx/vq4nbkHXsYwIuut8x0WMSeLu7/ABbXt7wiooZ9p5D57389x3uUWpIA8DqYaHoFX38
	v+ze6Gm1cqUoZvpRGBXH7g16N9uIEzWhET1wcZ/So68dyY5pigdOhKzlC2uxEvsXvCtU+l
	x6hk/ATbt/phNWfGSxK+2UOWtAgdsb8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC4F5600C8;
	Tue, 15 Sep 2026 15:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00571F000FF;
	Tue, 15 Sep 2026 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484606;
	bh=i3oWpYtarkgkFED8rLFP9I2go+4dZqhBtgLXgfVyojE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hms2AIv0m4LISt7wOVbhf6MXwbbQMMTVdw1L8qqFzp6tFpwLxOnoR7yJaL6zHcDAy
	 aKKVZobhqPHORNsQA8Iz3FLecoAhSNSMQ4wn4CPcXSHchaje3096H5wuxsDBqidko1
	 30Kq/UUVaTsNQu/56x9vizsgAoCAXplgRDkTCvMjPIgAL1ka23CWh0IWSu3+p1ccNI
	 DVV5l7rGJNtq1s1rJpBT0S6G+/mOQMglyEMUPc8aZYwY4gIHjV76LmtQ5DG3YCrjQU
	 d2yE0P0/x6JIAFn3RR7wmcphmKPeemShDqXC5fUu9CWSEeDnB0PRbPXr9cV6g9HwG8
	 qPJCsWMutOy1Q==
Message-ID: <1bbac1b4-b03a-4626-b509-c9f3ae36a169@kernel.org>
Date: Tue, 15 Sep 2026 17:03:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
To: Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, ljs@kernel.org, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
 <20260913072312.52111-1-lance.yang@linux.dev> <aqfRCPheDYTgTdAk@thinkstation>
 <f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org>
 <20260914111940.f7e2c72eac4a2df97a646793@linux-foundation.org>
 <30bcc70c-be07-4237-9bb1-554aa5b5c5c2@linux.dev>
 <aqlMvfIhr8nD9RHB@thinkstation>
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
In-Reply-To: <aqlMvfIhr8nD9RHB@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 628BCC0005
X-Stat-Signature: nymdc86cfagj35yizga36so7w1j66q6o
X-Rspamd-Server: rspam01
X-HE-Tag: 1789484607-934748
X-HE-Meta: U2FsdGVkX19OylUH/nBgT0t31oKSffXg0C8irgxdz/rKntZKd/zGEGCdwkRJQF3J330veSH/nE2YI8Vg0zCQ//gtL/tkef5/mgfYPjwvNnp9DVjwfsLuAIOIt2yT0iPzm7vlIDKXCDZjhYF/E26gvYa9n7GN7cP0iz0aXGG2dk1x1EGANc2A8Ey5xm/j8QjRN2Hn+7Dah+1fgRhvmNl2K7j1Md/ErZ35s2Bed5PhksRUdAVp3LfD5iu16q+ysJNfJhvoBFCbWrSXHxdA2NdGXhv00xwlieHnr18OHHFZXhBxShiNjEm8JcGUNCOj2AtmxtLg1xjjqdSMikeQBAasdKFzqPLODLBmT16gS6JgzULHtsB1+CFLIRtOFdAwkF+LfRLLBoeBy573hdf3T1+ukY1s9Cc9E05TEGKs5CsC+AHVLEZQEOi3mfcp1sNBYZ7rU2G1Hy390uSyWVMIN8f9zPm6PdEqCKjQLKoWztc7Wr1nQsxolPObCawQVVVRHM5FigfoTjWx8FpkZQQGaqXkKxc4GZB8P0kt8m1VNpeCNKk3uAwYDZcPTdxZbFs8tZDHmYCp0cLNsAo/vzWQWyWRNFqgTMjwfkKNug1yjpUhtZKrOef2+0da0IiUWIxFmX2gcVdEKFojC6Ccp8fb7jZYnVxSMmQcyyeOxqRVl22THUxjioi/LSlJBeiUmOyiUYdwi/3AobbjrMPXgNtJ1om9eG6mUSlXJyjwYaDRk6T3xCJ5JB1hudxJ8IEJILI9306BbPRE09K2gSK1vcxHiO1xX9w8EoAjWfEgGddS3mCi9QxEJSno0J1DN0DxQYLK1K0JoZvwBVkUsO4e/zFlwBYluA9EU0Zc1MKZ4EzndNqjrQPIXxaIUs2cqLv8EpLjE0jHmshT0yuSp05FOZDUZy37IKntCLOxeoGYP0J6uGrL9SDaWNJfgGwCFNlA4564yJ7PdLpgJ8zr+VBabYxX2IZ
 e+2TtGsB
 tJ/HqQUkMqbCGAZlZupKRxNK4L3kNu3NEAg8laex306Fr0f8bu5QmxyMcXDNYBBwLvwbVt31AZINKLSSVtBnwAino3XYS/FfffrJOsp1CMuEz5YhCPUEcg4hAojJI6vIabpiW8OFIxSIL/3vh5rChu4+NQl0TJ0HL78m/KM5mZFLJlAj4IqShJm2HIWEVeA7ZADrigCny9AAu6Ukgp1PNEJI3cvpAVJHtVc4g1gdWUcJKjYVfWUiQJ7w/jvsdT6wy0m6Z6gkP7GRgO3rFdwYn8k5zeVMuEowJLLHO65SWIMRxEwDPO7pNIbr+lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 15:52, Kiryl Shutsemau wrote:
> On Tue, Sep 15, 2026 at 09:43:15PM +0800, Lance Yang wrote:
>>
>>
>> On 2026/9/15 02:19, Andrew Morton wrote:
>>>
>>>
>>> Thanks.  I'll remove cc:stable, move this into mm-unstable as a
>>> next-merge-window thing.
>>
>> Sounds good to me, thanks, Andrew!
>>
>> Kiryl, David, would you prefer the validation for raw-PFN mappings
>> of the huge zero page as a separate follow-up, or should that
>> validation replace this patch? wdyt
> 
> I think this patch can be useful for graceful recovery if we somehow ended up
> with a zero page in a mapping where we shouldn't have one.
> 
> A separate patch with validation would be great.
> 

Ack

-- 
Cheers,

David

