Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A36C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 17:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9516B009B; Thu, 20 Aug 2026 13:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A816B009D; Thu, 20 Aug 2026 13:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531C76B009F; Thu, 20 Aug 2026 13:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE806B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:33:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC8CB8023A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:33:10 +0000 (UTC)
X-FDA: 85122343740.26.B3F6EE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D265940011
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:33:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxQmEyM3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787247189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKZbzHEs7LovNAK73CuUY9PodbupBOZ3Tf7iuO/vCJM=;
	b=yl+hRM/KrfvFyzcXNRHBJybDigL8URys9ud+g1pTQKTTGwZ2tN3hAkSmIiddhZym7SaiAR
	G2a4yP+mO05jIW0F6HSwz79IIlR2GRPvtS38OdMSxHvHzXubdv91rsNO25/o++zNxDNGMX
	5Jmcux1/4KUCkSw8mtXmdZM7f/7mdxQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxQmEyM3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787247189;
	b=mHnzXjHAYXnNLkSsS3q7G6QyyO7dqvSUWmvPNfH4I1qSGi6pGG284Vl2b1IgmwE5qbWL7J
	jPXizCRW+pgKnwM9VKxjCKiUHnjZuNQ8QpHxnqug9F06b206Li/3en5V6d9PqCKtmUmUGJ
	09rDjUapgkxFrPurl1n+gjju0rOGAxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 128FC42D78;
	Thu, 20 Aug 2026 17:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838781F000E9;
	Thu, 20 Aug 2026 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787247188;
	bh=xKZbzHEs7LovNAK73CuUY9PodbupBOZ3Tf7iuO/vCJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AxQmEyM337L8/XC13vNqg2pJ/asCDJblMcM09Fj0giGxOGzcQJrT72m510uGyz+Si
	 R7BAYktFs8f84fHzhqraAynMY+KEvnG3Hb9NGFIGlSucH8betFIvM4Q8yxKS5t2IKt
	 qkflSYIN0MpkMRupcyw8y8xG2RcQyg/1VV2Xx6nL/tLpgpWPRNj4yYuYP2S8juGNPJ
	 YNIWVdr71kwTXMYgCcfWBnKxzLTn5p7ttDkzXKMn4Z43z7nSIg3OzZzcdlaO8yZE1b
	 RToj3UnvuNBfO0C1rTJUA3p710gDr3q1xukkTFGFtqdL/cNOLsogfLkJpSJv9ZXbuP
	 ABak8h1qTcfPQ==
Message-ID: <e29e8bbf-5a10-4868-87f4-09d48625f6e6@kernel.org>
Date: Thu, 20 Aug 2026 19:33:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/hugetlb: do not dissolve gigantic pages without
 runtime support
To: Muchun Song <muchun.song@linux.dev>
Cc: Longlong Xia <xialonglong2025@163.com>, osalvador@suse.de,
 akpm@linux-foundation.org, mike.kravetz@oracle.com, mhocko@suse.com,
 linmiaohe@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20260817162039.1511838-1-xialonglong2025@163.com>
 <206cb1f2-b66c-4b7b-b0ad-14cca9d8e0bd@kernel.org>
 <F06EC17D-2A3D-43DA-968B-1DD4E1253EF7@linux.dev>
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
In-Reply-To: <F06EC17D-2A3D-43DA-968B-1DD4E1253EF7@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D265940011
X-Stat-Signature: 8hhbqj59sx4hpy8gqcu3xf1ajn88o39k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787247188-81308
X-HE-Meta: U2FsdGVkX1+p4C6PJ/8FL7bPClXbnzDas+p57TB8VzgFMp95wfJRBfuzsePocOQtogrcNCxFDgVHhTtofmkSzq3YfM0Lr9/d6bU3cc5U8BG47Ri8Wns5IGdifZPcTc4Bnh/plLjxgnSdRv+uVEc6VeH/32wJL6aIz4HwvHphs9dCYiKSX6EpX1GKPSr0epK9R9acND9a7hUQ2XvSj9n/wKSDbZlzWVToGBdraPBMW46OJQj0CiwIS4kd0qrHCMwmDQ+bW7Xvv5k1juB2KPfqouVV6nNcfoaQi7HCNb875gHa9FZWuT6Yq1TqOOnH/KpEn1BQJsAh91/Q9wZiGkqQv0VjKkhjfXaZxGUNSE6JDMqoKjCxzQlAO5l2XkaFxN83+t4e2NTJcw9X2pR3ywOg5bOiPq1UnaEDjzz9qtw64iwFPKzzpZG3hzRNYDUKlgfSi5+wRN0bvREmPkpt66ekujyTTaM8xyQAhFLZObtEQfdA6SWcNBIBO42DPpAYqGDOfKnxLTZ8QX65w375AWLdaMHCo/AkfZBGilPQRuVrNSSp7fg8V46dX6TBKTNzPiPGAXyblhaTJdiCtDLwrl1O1LqimwTDLVY/oITdhc6KtGXycKQ9IBwXP2qyKZBq4fqseywl3mwdr9+h1Qp13N1y6kXYuWi7TTQ1/aKpTAaSxnbY7wTlHMey6bJt71FIik8hnHRUFrv6WC2D7BsW6ASQM71a73akCUXPF/ZSNJ7gwg5MC3lbAIHz1fPLvl4rBMIUcrHCr+AwFJURBYARq2wd105VqXLtwohx943fQtuThoFxRizghT+qrZtNoEIrTvK05wCBCNWBTixu6YrAfgcVliGva7BxDQiwZoBz1PNiWHzilJOcThxUlylvs9q8de8IaUH94xlu7Z8+the/3CoYAJ23sWlkVrnF+Dx/8En4Hd6JKhB0+KTdY2FgTYUVlUFSC0UjKCSYo+j7PBj6cJ0
 jhvsFHou
 FqLbDgxOM24o7mDyF3in7STw6l4iJLQejUGSb/Ya1bHuC4ERSMsv3v6LvAC8wgog+5bfname4MvarsrCcpSsB65Fzx9KaDTw5zvbSAtLW6JGgS/bdcS+aI018ejc8b4aeiBcNZ6+G/bEpJWB9LL0JTPjg4FmGsDc8xamqlr6hpNHrcxFpHxhKwXWIbemRvLnlmL1gTq/454pcoqhi6aPjb0ddAdZDIte96PxOsC/RL/ISrPXhWyQWCdUnVAVVTbg1ddx6meF9eaShZVhP0As2ghHocw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 11:38, Muchun Song wrote:
> 
> 
>> On Aug 19, 2026, at 16:52, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 8/17/26 18:20, Longlong Xia wrote:
>>> From: Longlong Xia <xialonglong@kylinos.cn>
>>>
>>> dissolve_free_hugetlb_folio() doesn't check hstate_is_gigantic_no_runtime(h)
>>> though remove_hugetlb_folio()/update_and_free_hugetlb_folio() silently
>>> bail for such folios
>>
>> That's odd. Why do they silently skip such folios instead of warning that
>> something unexpected is happening?
>>
>> This screams for a cleanup unless I am missing something :)
> 
> Hi David,
> 
> Sashiko actually has a pretty detailed description [1]. So I think it deserves a fix.

That's not what I meant. I agree that its a valid fix, but I think the code
should possibly be reworked to not get silent rejection from these
functions--IOW, likely the callers should make sure to never call them in this
scenario, and then VM_WARN_ON() instead of handling it silently.


-- 
Cheers,

David

