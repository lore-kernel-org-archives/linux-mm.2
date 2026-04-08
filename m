Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D67FD5F94
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB956B008A; Wed,  8 Apr 2026 04:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BFC6B008C; Wed,  8 Apr 2026 04:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2436B0092; Wed,  8 Apr 2026 04:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD7B36B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:09:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5376C160A6C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:09:30 +0000 (UTC)
X-FDA: 84634664100.03.1AE81FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C80D180003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:09:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMtAd4XN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775635768; a=rsa-sha256;
	cv=none;
	b=d3JMhimZ5eDTr+jwR7UJLn+0wuqJ7RHMMjQa3q7Ws9Cc7pHsQF55XpeWdhmWZN9ckb8SQ6
	wXuzBqLA8ksBMkH5mrkj15BJrmIXWf1BAPKUVhvPUWpWzYZFWhRKLg+3N1QxeF6Oi9/nNe
	lvtx2jjlLBhWmZIq8w8IZiNhNVmVK5k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMtAd4XN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775635768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUrNOYunrZqrgbPg64J4Jqz2LJTx1j/Fg5ySiYmIszM=;
	b=RVhCGO1IpybVZ/BLALlmZ3R5xEmTLH+wTNfegUDYcK1J1f8tkfPQ8V1AbhmFB6h3zvUdK+
	cdDrLMdCGuHd5bBzjkyZ9u0N3JjRCgjQULfMkHZ7gSzyUSIDAGpmEeUokhzmLNdu73kzds
	rDEvl8s4xTJJUdEiK1gc6kQLo0u9jtY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 03D6060121;
	Wed,  8 Apr 2026 08:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D96C19424;
	Wed,  8 Apr 2026 08:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775635767;
	bh=hqn72j02DwcWfAb8Mcx2xMW2lIxmfO9NFn8z+gg9roo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OMtAd4XNinTdl0ZHL7hrsbszQfcdUCVDQz6iSJEQFW077NCCWoGFNnn5EyfGSCgef
	 0IUMIjbGQpUS6Iw14HaV6M0arD2+BV0E9ZC22WmRgBw2mxL05ilrv4EgV4iO9KK7gS
	 x0PvEJj4dsyHkTCZESkJNOBrOWb+XwxGRTRmMRlswxcvPQjiCvLzJMOY3/ocx0oJa9
	 ejGzo0+zsG47oIYbCyV7a/wr09t1f1nUws4BnQlFN1iqkugPxMwOqQ+zEXuUnQq5ly
	 pJw8pdefr0UNpcjOtWE7R27NkrYxJ2YnIUclTviqktLYYv/JwVVoyackpSGmFofWW2
	 L1owvXGehD+Ag==
Message-ID: <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
Date: Wed, 8 Apr 2026 10:09:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
To: Pedro Falcato <pfalcato@suse.de>,
 Joseph Salisbury <joseph.salisbury@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
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
In-Reply-To: <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C80D180003
X-Stat-Signature: imsosthkao77yc9sb6931wn5q6nkamdb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775635768-902355
X-HE-Meta: U2FsdGVkX1/HIZqLZbdFxgELVfzkdP+WzgS7D7L99t55fTvwOmFPL2JAx5Z+yEULanNOiVkADtmXV/7RT8YKMKbr1BS7MNzc34a0frh8UDJO/+jczIlCVxzgh7ApExPwM5slk+VGJ4eRWkNP/LXLdXdKa7tNRkrtibcSjmvh/BerUjkwvAGfWYyEKwhDVksd2IJKyWOb7nMp9csQUc4sNknprSTR6AH15fRyrd9kScxCiMK+DvBQ5nCapbjV3YI0cVaWWrwD6vbRjB5L1ytzZQ6C6lF3rnnAOVErmHjI/DNnkvxY3UEkD/tBdlRz2kvg5EP+UCPX5d53SPl5vZusEJOwgtAklrR6bH4fAkqFGW9cd+taoWg2elyK4Ux0sTk2sDKrMt77JPS5Cs3qdk1pviBKr1/HX5ISD8YLxz3yifivepimmSbmAy1n64/Ee85L2MkZu7/3KjCInxqcSH89+cXr8VlIhh7uOvkYQHgpczCY+bfNJwRmP6GgiSnzXZN2edbUqJuS01QvbAhvFvdDhr2G4XmzQQcObwmcWZr3MD3p66DqbusEWVnBLaSdRPVs8ZcGuNYe4csssKtn//EUOEoBVzOx33RjIDKAuUltj7FwmPqZH/VgtRbJhqQ1werBQPSG8OGTEzw/dCPDaqhX+KdZtCAFeJeN3UV+dQUlIblpYp/L/kfY6iJBSJxa0McAHSCQsvRsEFCKYv3xdYIwqIlka4YTRoTxPJ5oVPE0hBZbcVJ6itV0XXIPNQUvdaYO7H0egf1/yzvjmHgE0ByMRnMw2RmFpH/iwgutG6jtcUcSPzIjzbVIOeYkzNAr492wdHo/7IgDFB2R6aDo82D4wKGPV2ue3vNdd2I3/EzQQDODfkdJeNAvlfmjj1yJbPHoLT7pAuTHhwYLmpNNnhfUR9r+2Ru/20EqgPhZW4tGaWOYQBgPAcgiwwWpnOzJG5mCmV1yj10ypNxg+TYHxFo
 yw9M96g5
 3tOLzkDjP/qMuQoSfRs8CNA4EJYk7gfrhKBm8BM2h39BZ6/rUymTXOagAx5O2PdWR+9ec7GEPPn4uYUlKhITxp1oZt6Vx1ITXChfbR3bGAgx48HKfSf0DDsCARuFMaUO70l3KPlvxiDW7nnNOi2npQjXeptR9lw7cBFhMt1mqm5mmwww8jzMKrgk+F2CG7lFDard5W/DDnS0PrOvTXR/u5hZLNgHNlMjGFBpc6B6iiNpuMD19qDQT0MPi/QvlqQBZKn1c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> It was also found that adding '--mremap-numa' changes the behavior
>> substantially:
> 
> "assign memory mapped pages to randomly selected NUMA nodes. This is
> disabled for systems that do not support NUMA."
> 
> so this is just sharding your lock contention across your NUMA nodes (you
> have an lruvec per node).
> 
>>
>> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
>> --metrics-brief
>>
>> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
>>
>> So it's possible that either actual swapping, or the mbind(...,
>> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excessive
>> system time.
>>
>> Does this look like a known MM scalability issue around short-lived
>> MAP_POPULATE / munmap churn?
> 
> Yes. Is this an actual issue on some workload?

Same thought, it's unclear to me why we should care here. In particular,
when talking about excessive use of zero-filled pages.

-- 
Cheers,

David

