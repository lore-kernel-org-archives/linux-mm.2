Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD1AC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2F86B0099; Wed, 26 Aug 2026 04:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353586B009D; Wed, 26 Aug 2026 04:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269B76B00A0; Wed, 26 Aug 2026 04:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05B136B0099
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:09:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 521A31C0DE2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:09:06 +0000 (UTC)
X-FDA: 85142695092.12.4CAB03D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 914F140004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:09:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZRK+pzh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkemYfzUAnDUUW7Woq3Ll7nAEHIuINdgKAIVWbxWrjA=;
	b=SO6m0x6GsYUf0yIYhNvdusHNjUch09k0bGp2x1quHjvQy6Jk9nO4cCEYRQu+Z7AZKEmfey
	8sZcgvd+L1P+NuoM9fEo+yvHftNTeX2iG1JkD+AOA87Zrr3BrgkOUY5bJtPvIeDQuaTc8q
	yqbjho1DqSWv3GJZQAZzxv1iBaizpXg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZRK+pzh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731744;
	b=hdzJwEENCwFbCq4K1ncF1a93Q+rADfRkmVy5KvpaosFUvUXpos6WNoeFbHrCpbtI9lD+0x
	ipWA7NZtojas7HHRl7QbpPBrEehDt/nHDyg+2zvgqiXSWvDrM0n2z08mfDeeTD2cgrwjKz
	TnWxVlXreNRxCquYggUSqo0niPzZxyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BD18600C4;
	Wed, 26 Aug 2026 08:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F361F000E9;
	Wed, 26 Aug 2026 08:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731743;
	bh=zkemYfzUAnDUUW7Woq3Ll7nAEHIuINdgKAIVWbxWrjA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fZRK+pzhRc25aW/wW0SKbu275nX+soOunXyesHz5tvU5vabsaNBeX6xxGODZJ107b
	 qxr6bX6XbTsQSvbiAkNRlYarsu+qCsfbihRwrcaDV0r3fciz6bayHa0eGO8mC9JdSC
	 ERElfHyth50mNYfJi44HGvoAJpIv119eMebycDMLpVZDdmOOhWfG8hq7Dtl1d8676J
	 2/kwux5Ywtnjzy1h1PODGDkQUIxdd8CGx6j3bzNCKnHT9MjlmhLW4W2Cp6YthzFF+7
	 0fHFnG5KKNGc1Lqp6bWWK21JmNqagFj8A8KULuq9/TDNZ/Wl7vWyb6xy7N5eQzm2je
	 5CR1v5k+e93dA==
Message-ID: <b6fbf952-c619-4fc7-8a8e-62a0ae64ff0d@kernel.org>
Date: Wed, 26 Aug 2026 10:08:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-2-vernon2gm@gmail.com>
 <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
 <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
 <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org> <ao6c6Oe_KV0O1LJn@gremlin>
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
In-Reply-To: <ao6c6Oe_KV0O1LJn@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 33c1y41benwwtmuwph1hg4sjettde64i
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 914F140004
X-Rspam-User: 
X-HE-Tag: 1787731744-560257
X-HE-Meta: U2FsdGVkX18P0/Sjl4CAWy051d6xKZTZ3clKFndl9lBpCnXJr5V1/xnBjxM409lXFKM1WsSQytd7SfrNiO4pkZIYlLIYS04MerWAAXcXGuf2OzEQkFUEgfVo931BQ/mS1auLh6Dr65qPxTwDtZye74TZ1eL+izeTWIhxul9waOxquitRV/Vpz8aU0I38IuXyKELla2AD8RoGvUYCofwvScghAfkKCVDBhFdBzFRMI3WO1OzJ5fXn6MHuM3M22VHkUvJxGMKzbaXtAbOMw27FGaJk7Aplehb/7hYwpPDmUunFwYKSNlgSPqo31df1hs6S7p43A/auL3n/Ycc8QboKnJJZPvl2y1P5OaYugeBqZ6zmg6GmxJep9qFFaZXOnmJkydDKgfI/Mp2TcwhwVtQms6eW4oqz4OIJPlYJTLP7fjcdXx4N31I+lrRQt9TZHZWV7R3JHn0vRCDfplPf7xGM+wpXq+EMetR38zqHi11IwcXKNyFgCmuYvvNB7pVYUpz5XaQKgmzkx7PH/F32U+uFv+0fBtKbrLTfNS9LMvjVPqDrVi1CFslEbM9KX4cuG0d3JWkJEbbQhADZE2v1ODEM3G/mIaIhlYgk5SFf3GZourJjaB0RWf1bvefrsTcPS7OccAyj1c6R1XpRMjrxdLCq3FEi38/wwH6XdyoIXHvJkJ3IuoNh3fPyLSmN0OtJNImyndwCizSwchvD6fGo4+smGLitZhyQ5bm2vbPKyjKdv/GKXVcaToksloqvhT8qEX6u6tXGWKl5MJMCwScwNGzQ5O2d1kSMPYVn3kMixB7yujZmzUTU8JS4tMyt2jrUao3GmQsGv3wGe0spR7d2lQm/KTtBlLETno1WkRJ0QlrzGsnu3OSCy71G4mnc9RJX2XbspDxSOPrgYd8kgt6xiHFPigmEYhYPcvC+3cQHGzfeFI3jUN0V4sVdMi7eHftob51j8mFzGxurOq4A2BBLnvC
 H9h5VN4O
 r9dIpOIIF1hRzn0RY62QoDm6tli156uONp6D/0Vz25MZ+3RPtO/Fpu5etJ87azRr/7cxfAvLgXtejUneI4C3ei/5/UGfetKa+v9iCTb0AFudSaqA4DaPMLs9JBq50NSAVsY/pTXR1HpBKUxn2tKn+D3x8c8IwS88WcEweVct2TNFIMwIut+sC+RkuZjdOKx3NTw4Up2SBSyd+TDTovs/1za4TyK/HWZUO4+BgWEH/9ev+mTUjuzNH7fehvqCrRumwGHWFwQJM2wSIZqkOEFQIPz24rO4Xo5H5K00hKQtcNYYOyJvAbz0MkmH2bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 10:07, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 26, 2026 at 09:57:05AM +0200, David Hildenbrand (Arm) wrote:
>> On 8/26/26 04:44, Vernon Yang wrote:
>>>
>>> When the `xas_for_each()` iteration to terminate and the folio operation
>>> preceding is normal, but pfn will be incorrect.
>>
>> The PFN is only relevant when a folio participated in the failure. Maybe the
>> following would be cleanest?
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 75639298efc27..371ee0b16d10c 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct
>> mm_struct *mm,
>>         int present, swap;
>>         int node = NUMA_NO_NODE;
>>         enum scan_result result = SCAN_SUCCEED;
>> +       unsigned long problematic_pfn = -1;
> 
> I find this name... problematic :)

Elaborate.

-- 
Cheers,

David

