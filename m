Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981A0C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938BD6B009B; Fri, 18 Sep 2026 17:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9109D6B009D; Fri, 18 Sep 2026 17:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FEEC6B009E; Fri, 18 Sep 2026 17:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDD36B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:04:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEB8240806
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:04:29 +0000 (UTC)
X-FDA: 85228111458.23.BD2FB56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20A13C000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:04:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qyeb3hJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789765468;
	b=dNPbjp0nXkHl/JPM+4J+YGCuBnghxR37JxNRS9PxAlaeWqSssN+0kul2BKOuwXS+VdQEVW
	sMy36oVYQmM0AJa2hEiXSnweuA9Py9T44OmF0JCpDlWKeFQSJtsNM4jxrq2d5+ZRHXOLfA
	ej9c2IKE34aHomUgN6uTQhzf4MOOYZU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qyeb3hJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789765468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmK0KPLqBJNRqNK0GfYnXw0oy5TGIitYZkOcLtfdbHA=;
	b=mKjEpUT1gIz4ykCbKF9XeVcIuoa/sEFhsD7vWLZgKM9Tr+UGkfPP2RiQ9cOrIiqeWYxtuf
	rIgm5kBPxdZWvNjFOj4QYZJCOr0oYkY5TEt+lNmp/4/wK0hnSf3uoeTLxQO/mXnbmCkpyf
	UXBy+K/nn+bmeRGv1mySL1dxzuCP5B0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DAD843B4C;
	Fri, 18 Sep 2026 21:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC9F1F000FF;
	Fri, 18 Sep 2026 21:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765467;
	bh=xmK0KPLqBJNRqNK0GfYnXw0oy5TGIitYZkOcLtfdbHA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qyeb3hJXGrrBizz+7pv7Iqz+Qdf5taO7C30duKJQGlzhq0MvoZI/Y4XbVI9B6L4CA
	 7EWqTpGNyugWKhXU+3k5fpciZG/T6adlZxQKs7dhfVbA0UNRGhHTMZ/cpUj4RCV6gV
	 hWQecF4dZHxMzNPM5oai8xh+YAe/IZVl2LvVsu6ODGsT7se3LpYL1wo/MRWn0yRzJw
	 9zZQrZZLSUsyBUfVaEe05iZWsK6TCGhDPPPReIlb4tCkN1hhuOvGt3dUsUc7fIMyrE
	 ps5zjstPreSRG/BM3NcF+4rqNdcNQPtBP6MKEWnW60Dn995KBl97yTlnp5iXQiXmfw
	 6Q+apIvY+73sg==
Message-ID: <f7a4484b-24fb-474d-b41f-fa0a9a084a55@kernel.org>
Date: Fri, 18 Sep 2026 23:04:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/17] mm/huge_memory: drop the redundant mapping
 argument of __split_frozen_folio
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-17-39878b37dfb0@tencent.com>
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
In-Reply-To: <20260915-swap-thp-cleanup-v5-17-39878b37dfb0@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20A13C000B
X-Stat-Signature: tr5ukz1jb4wu4zeu7844qic6ru4wafcx
X-HE-Tag: 1789765468-182612
X-HE-Meta: U2FsdGVkX1+ISarNgk6vxz9pxjyslKTw68pcLYTD2JCxb+i2Rd7xi1GWrirTkYpCiFk11Ovrg6QXF9/Jk8jpI0AI6Fo27oKzebYWY148Uzg74DriuzB1iz/VVrrWzGwQ1lgREGu9FJHx8AUyaCbRURB9RAaUVuEfXj5lYCAPr36vjGm5nfhWYwbgCdVJU+iK9h+En43inmDIbUCT7fOKJfPmXYAiJPjMEUwqlXRr5GhjzFzpYQXNPylKFJDNI7fknYFuPG3aTUDEJerpsqyX8jKMH/7aZUPxBLrhwgiK5gEpaUFItOczFJdAJIGtkhSa1/kWyP/c8WwPIBvsPMRFugARotX7XwBjMjiOPCIB0q9grERk8kenFqlFgIZZWlTU4LXJFT7Z4kJF9x5shwpdtlHo/qc9J/I/KepTPOwqhUcPEWGOQhOzVENGputqfXMdsQvlL/CxSByIhH25d7kt0bG8k+A+oPvLzRG6Q1bkTXyp1e6K41BOVaV4l6K1JK5o8Nnf36wzu9h5wf51WAoBmEYMsLX1fWFk6a/m/IGxLZCPPAv1AEfvm6PiP92vx7WTwyQi1IlsvA1JD+GBaOJSZG6IvD0VEpqwXtmPXZAfKkQzvEPwD0J+uD5oLrnUhOUDMtunZWNNnlHhO/zB+ZkgF3BZoX3+M1jRSEVYWN9xjtl5/lE36/yV492gAix8dTCqSMLaxl6G18Ened4kSLVyE7ET2LIUkfMtgxdj/Zk47DHWWCqAzht+11bpl1lB4n2wSNzJHjSHIIl6W9ahxy4CJrVKlAHHVdvc4g4pSjCHpKiJWEEcbFxBtZBMoH2qTU1UmeoWFvfqgyL+1BcHlL3A15E+ymB23pZbAAYeOE2FDXvstceMF7tI6mKMdrolSflk94XD3znvVNswf4g3ecmdoFGjfT4b24cwrCmmkfTfA0m0VH1s2k0tPtNsEsUoX3n9SVypFtj61OXd396W30b
 SatJmTqi
 yJU7ySIZAomhWmJP35SewDN+vnY9MUeAFX9SE32e3ezVe8mSKysu0Jwqm3XWN6VqbpZUhGS4jkM4BGlWC/+oqOZR+9aTa//hylP5DnMiN6TCucppa3K51qL4OOLi9BETTpRUwVsh4HoLvlecCUkvPR+k/wzolxPCgESYk47Z8IzLqAkgeD1wlhRtN+SkngUhJHnyTrIPRSgBqPxJhIYoHKEey9ASKv/QlimAPwOu6Z4+I+PQGpnvYlQwCO9nyZByepSOpkrdG7Nd9gM8JII8oXMLrqYoCzLSeAQ4SbiSzBATpx/vmnBX6844J18SghzZvyF7QxMhgQM1ak/EslKHJCuM73OHVpgPPIifP2r/ICdSFsloyjHaAJnxNdx6SD4wivaLyizUO6Rjf1lvfAL8bL5zYbxdPb3UtXxo1FJrWsnJwMcgXmkyqJOd5KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 19:14, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The mapping parameter only served as a non-NULL check to detect
> whether page cache entries need updating.  The xa_state pointer
> conveys exactly the same information: the anon split helper passes
> NULL and the file split helper passes &xas, which is non-NULL iff
> the folio is in the page cache.
> 
> Use the xas pointer instead and drop the parameter, along with its
> kerneldoc entry.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

