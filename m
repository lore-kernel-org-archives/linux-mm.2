Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F92BC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED756B00AC; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4E66B00AE; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1F96B00AF; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5566B00AC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58DD8A1756
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:59:11 +0000 (UTC)
X-FDA: 85041063702.28.D44D478
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AD235120002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:59:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S29AilxB;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785311949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwdqGxoAPhOYLSWy/uzYKxVIQs4IfOX5AH557+HHvqo=;
	b=r1ont+2i+wJ0PmFxDZmSoYF1WSqK0o0OwqkAgQ4EcMS2qlMmnrNVXlzvVMLzNA68CZWgUj
	OqgebFe7FelzaoMwlCiTLbyV2TpvPmlo/mBee90bb3WwDH/qPrKm7esx7yLrnRm25V4tHM
	NUv1GjzBscF//NrBs4aA97NkJWCFCuE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785311949;
	b=OS+2aSoBWTuOVVOrlcEQFRg5Yt9D1dAopRft3R830JkivksAh/H7bZCWpc3EEqt+8c/oxt
	3kYE+/Df3zJSNYJbktn1hwjo/OKH0xd6o+memFH63MSaDAPkhpabnEaMCJREaHzK4d628q
	G7X5giD1nziEqWcbGQPGWJL4cueQoQg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S29AilxB;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40315600B1;
	Wed, 29 Jul 2026 07:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8739F1F000E9;
	Wed, 29 Jul 2026 07:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785311949;
	bh=pwdqGxoAPhOYLSWy/uzYKxVIQs4IfOX5AH557+HHvqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S29AilxB7ZYEuEQEBUPp/AlNNOt2daTApKlw+99njsgIoqxOfPvs3yUUe9HcxSss2
	 MCfxtrM/LX12LidqBsG/63ISGmIkFzxVCJKDgfr7hYTYAdiQrct7TMWa8nZTYinuT+
	 n+AH6zV4wza3gwRgHnzByxkKHZLq6+ccP0GF/4ra7XrmWi00nOywyKHpWDbTLyswaF
	 PxbFKR/W5kiLge/AiTuNfUDcAGYW6BXpLIYt9JZJm+Q++ZHgdDh3xOxDCTrRXkXM4y
	 BfvbijrNWzikLVVOD4UgrH/c8F01WzRBCXUDnBQTB4ey9x2T90XTEyxz3+8HKlUiHc
	 7GW2HTczJwx9w==
Message-ID: <a731993e-8258-45f5-951f-b32b90671183@kernel.org>
Date: Wed, 29 Jul 2026 09:59:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] selftests: Add missing initalization of pointer
 passed to getline
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Gellermann <christian.gellermann@codasip.com>, brauner@kernel.org,
 liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
 <20260722130246.2135563-1-christian.gellermann@codasip.com>
 <580fc92f-f146-4d76-85ce-6555cc3bc47c@kernel.org>
 <20260728172712.c21b2959d36f3e2d42cb73a3@linux-foundation.org>
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
In-Reply-To: <20260728172712.c21b2959d36f3e2d42cb73a3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6jwxz1k3okboet3ydg6iyck5nkzrtn4i
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD235120002
X-HE-Tag: 1785311949-239547
X-HE-Meta: U2FsdGVkX1+CA5Mtpqf+u2JR7J40x+5Jh8cSR+pR/YTRgzSVSbOAssV0Y+klY2FDURzI+ENSlhsRVfqjbi3FLwVaGFLoySTCPAzQvrGfveJgBBCHjPdBM0v5j9oCvKcqdoZWcSrMuDsQ3KQjtasnLqdWtulgtgdSoDvL4vmt2q3Q5g86xcTzSLpwRsE4CbRYk0Erjm9qq7qfcMlhiMVCJ9VoetKn2YwNtrffFwgNev3AkG54mzRhdExGR+bZ5YPD8+o347EdNrTdML8dLm4ngEjd01QOBgB2GGXEzI3qFsavL5bCPMG3OqLiun8vLv5kGZpxUcXaqILPWkUPodHM/wFuOx5xodCh3ZNw9Zw6h5ziypcwEuTWXIfw1AzfW9i2VXNoYUrMn++Ve7MYiz9xs6tkK8GxxDWKGaMPd0xGw/t328n+vsTwqP+k20hyhPLYFKsp8W+WXO2DuqJUMYQV+su8TgjE3nnKDbtpy4An3oUueJXJYppfg4S+F2TazTsH/G4gQTsUjFw0Y4yKcBWKYpclpyallSbOT8lc7F0+Broq4o+3QSJKlr6YJqf8T1yWi/NV55cU0I5jSOVg1OqOz7A5iu8EbGqtgq9zfphXYwcx7En2aZ8fSVmFEVPglDkmGIvbszVGy90AfQK4PTwVW4bmxQOtZvwvnJpvgbIGMnbfDcFYxmsbCI+jD4fLyQrdclAS64xygvvyfk/h79P5cnEzHHbo7HzuMdUgnLqSXrtPC4zSxVWvsjgiIVzZDta0jqRqpFsvD8ixiqhIZ2robKbH/K35boB1hho7jFmjHk/unHXpvH+T+GwgAaHn+uPhLWWdMNeTYIc8UGZnRhX/aIwod0A0CC1CexVThwpACx8sXj9QGsb+vxUBmkZf5EegS+dNdphoNS7Cc9eB8tTk2Sf+Fuhn9jDAsfhliwnO773SD89xQECwA1fyXfd4Aa+17GOkCE3a+leiYepmRcO
 m14mmad5
 xipgWH/x+WGyw9BX5qVX2Igo1lCpGmCDOsmkksXBowHRqoy0nudgeqYlRiVVcOh7Gusbta9aSz45O/h/bzRYiWcQtCRJnrBAr9Z4p06/dQ861X/4rEx0vC386IuA7SqxVUqpGjWwXAsfqqXcId6c8mTw8q30DIFAYxsa0L7KD0xMkVAzRfTgPxSbv8iczhrpyyD1PvnfX3ZhXGoQoleZvbn+l8MZP3jpOxqXZAwZZD3ooygVLD7QDW5bRKE5KpDrM2qw3L3Zrm95kBY99BgFXCQiAtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 02:27, Andrew Morton wrote:
> On Tue, 28 Jul 2026 21:31:39 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 7/22/26 15:02, Chris Gellermann wrote:
>>> Hi there,
>>>
>>> just a gentle ping on these patches. It has received an acked-by from David
>>> Hildenbrand (arm) and a reviewed-by from Lorenzo Stoakes.
>>>
>>> I'm resending the patches as reply to this cover letter to clean up the previous situation.
>>>
>>> Let me know if it needs any further change.
>>
>> Have these been picked up in the meantime?
> 
> Yup, I added the v2 series to mm-hotfixes-unstable on Jul 22.

Thanks!

-- 
Cheers,

David

