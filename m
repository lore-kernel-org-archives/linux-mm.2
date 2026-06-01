Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B6BACD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34186B035D; Mon,  1 Jun 2026 08:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE48B6B035F; Mon,  1 Jun 2026 08:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FAFD6B0360; Mon,  1 Jun 2026 08:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92A9C6B035D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:11:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E9654065E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:11:02 +0000 (UTC)
X-FDA: 84831227964.29.757FCD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2764A40006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:11:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amfBpJiA;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vv/L0eZsDq0D8sZRZhipOnEJD/BPkSmc6I1YKyTT+7s=;
	b=ijfA2DPvVAU2JcR+9vF3Z+yAAy1ivcGQOsuAloh/QmnMmrIj/Pi6IoOb02868JfQJg9O6/
	9XjgjnUgprFah93xOEQiOHwyli+423WPfXW+3yfnZt0yE5b486YmB61iFFhlq31iEfL8DQ
	yP7sjgf+P7PI5+w6d8Q7VkEJZIu6m3o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amfBpJiA;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315860; a=rsa-sha256;
	cv=none;
	b=dnFzg+aNgMP/I/YL+P4+fhbvfx8/l7eYk4MYiJ2MDoNtxrP1sFYiAr8WOcgjbhJeOSRK5v
	ZtNaUKEAUUYKvlYxVFWzhBnynAKkscafnBQZpbALajGlo466YM6i1DtbNEttXEINVOqbI3
	+Q3drbM4NwS9FRILg3rdrjezGodDGN0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C0EB40C21;
	Mon,  1 Jun 2026 12:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C211A1F00893;
	Mon,  1 Jun 2026 12:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315859;
	bh=Vv/L0eZsDq0D8sZRZhipOnEJD/BPkSmc6I1YKyTT+7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=amfBpJiA8UWsnzbzOXmQY/kIEg6eeOeaN2QJe7DGfVrVp1qnMpfpyhcEf17W49DAC
	 dMofOOX8s73YhLvCk0O47w8SB+udHD6CTY1MD5x8P49s6FNj4DbJoUpOUlEng4qocM
	 t/X/8A3S312Cy2csgXvr1HwRaUGCxMDH/XzjihVfA94O4lghkWz0s8Sq4ENTEfwlQ9
	 9DP7vkAXqxx7aLcfvKOrKHY2WIVtiUtGjZ6qOqkeXutkoAzuABOQKBSU7NDrwzUmD8
	 cAwUzOLU1GHO+XGfWuFHnFPZqNqxyNfYCY8MPPB59F9TEwjvTWgb3lVhEubvxJTyEa
	 3Lw+9yecSFWBg==
Message-ID: <66195af3-2fe7-40bc-933b-0d17aba7226f@kernel.org>
Date: Mon, 1 Jun 2026 14:10:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260528075507.1821939-1-agordeev@linux.ibm.com>
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
In-Reply-To: <20260528075507.1821939-1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2764A40006
X-Stat-Signature: 5x175dpjsp8r94ho8nx6gn4s3134afis
X-HE-Tag: 1780315860-325131
X-HE-Meta: U2FsdGVkX19XvntnWCPOLcJAgLd6kx/twP0ueaG9idcC6CQ5jEK+h8Ck6ZlQo+kBhnOnYZdpONlHq0FX4H9mi+t/LsSP8ltYgfeZQtgt8zHhm3tbaq0Fs5A+yZ6hyEidEsPCoWgUf02yY98pTyBxUAQ2W7exUoiVyA5xyftwPJ07DuXJmb5FbxefSOZ4agHoucwIVKUhpkPbLKDC7FoZ1W7MFHsh0I0acVRcD2coqVJ2/jMOKEcesfEswce4u/bzPqsomi0LKHGs6zBPu6FzfVVX7HnWLIHwnvAgR72zWrqcgVuB8r18g6LKrlQq6iaCLSapL0HwZke7NykAM4+XLuGkQbYIEAQ36dRBTmcLv2VNMnzdhwzxS1ozqmfo5CsmgLBYfG8uXE0SRpiGn/BY84KopyiqvT/BM/x192nwUEAJRv8g661ewiBum40/HrhDcvR6mT865qPvRF2sMNsCrmmUgNQZa1JZuSI5tSRwn4RTNIqpD7ZsBVpoyc+OIabEbc8hiBsE97ZuVbWaUPHnmyPFkRkyB3vWmpoeSMCMz+q2FnJ14a2pAEkSl3PrG3VTTwO2qSWaSUIpKD6wGtp7YAmJm7MKVhLtD2k8e7wndDGHdkn+ukP6QWIvsqsjgay8blWIDUonvEzhU0XMVnCYf/D6GtXWxn/oLWKyOvVwVKVPMwAg8GUZOyNo036z7wcQl4tdCCDplayCTkGSZcew1IRQ4yMhaJbRXfqZ2PoFsYLWAnuUFnyE2MOcUDp/8MAf1iXJ1r/kEW0Vu/pYO6SD4APqzyzvuBI0D46nWaXnxLNrwuYkSiKTNBkdBs7lD1koA8zS9jrjtkvACdwuxwAXKmx+W2rhjxNSlMmFrkqTRBZquL5IC3UCmZF4R9qFHOHDdcfCRCNIQmg3+oz5MzOtjZIQbZXIgQ93ZpY/aBkOes5MTyJf5SC612nvLVOcRpPvrn5p22YcZDWkCZ4TAX1
 nC5FFhLA
 3g6lFYahxF6ecWpoUbyOGXssxEb+HIDf56QGISWfRIYhZgsMkEKeSZ4fko1UOSaTO1jJ1/CMBVO0Axo6nQ9J2e4eVWZsbqNKhajppCpi/rRN/wBImL3ZxIzcABepyK9UAEO8CixjPPkYeTTRHWo5CgwMsS+qqRinRgUrW6eLbfVT/ajr+BwcBQdj4CaVnsHOo2ea44hD437EWd6tKKHsgPiwNzVOPOWqKbTHNsoncH9sgCIU8B/fnpeppg3n/SGTAcCYqmzqZrDcSgoF4GVXX8ZRjFJ53C7NL9rsj5RgOJUZyKsV8DYphwRn34Ms9RMiZiqAiSvZeMJzC5YijC1h6jzV65CtYofOWgudeXr+vSxlECJgKdSsQs5BOhNrqGBNl3pkNJo51cPeIO3OTSJ2y9JB+NGhiRHY8oB+mKq1bTk9Hhw/Wh9wA+WZWQvjW9uHowx/8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 09:55, Alexander Gordeev wrote:
> Switch from ptep_get() to ptep_get_lockless() accessor for
> PTE reads when no lock is taken.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

