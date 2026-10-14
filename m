Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56C9CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE156B009D; Wed, 14 Oct 2026 05:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E376B009E; Wed, 14 Oct 2026 05:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DEC6B009F; Wed, 14 Oct 2026 05:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 930C66B009D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:33:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14BB7A04AA
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:33:58 +0000 (UTC)
X-FDA: 85320720156.10.3699095
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3B4F9180008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:33:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cN7adbFr;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTAovwM5NakhSZ8t6853G2LPiZdnb4fTpPRL9gDgslc=;
	b=1K+ZizazmcKF7MujexPKrRWTaOpqpHiC9kgdjwvkFQgXYROmL2f5I1XTaBPxxoIrIozDWe
	kPe/b+Yw1IQjN5fgis4kqMYAVKEIgf6/JlPT05osS2bl0htJsD/RiEIXG9uP6P7CM6mjEc
	yW/jnlJOxy4pJ/gNUi6qgwJKTIpbzxk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970436;
	b=aPKT5aLj++1ujSEUuWlbFAsBT3IF1X8N73J/f5kJDe/SAXksqNAAm73qegFEunLMxYinJy
	oNGu/5hL1ESRWmZvfq6XUC5o3bJbXQEmirnSAP5ZyivoJSbHQajDTx5p6Pm2OwCWns/wp6
	FEXns12x0kjNEUsZdlBVKG62HufMocU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cN7adbFr;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C57B40823;
	Wed, 14 Oct 2026 09:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97A11F000FF;
	Wed, 14 Oct 2026 09:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791970435;
	bh=aTAovwM5NakhSZ8t6853G2LPiZdnb4fTpPRL9gDgslc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cN7adbFrZTGK/JSRVznn+2URCCBEUXKpo4f5MMrQd41o3lm5B4MGv3/Gq1h3B7su/
	 vpEOO0oMzfzlHiOK18skOOcFj7A0MS853y2x87PT3hms35iPZpks2zXEfNUdZkZhKm
	 D+D7BoGZh2NAKDPuna7GnGGAAiQlBHXKoEL76SH/tDa9T0OhxSZ3oq9UA9k+1B4kyx
	 yeBx0hJSPHGN9b3aELI4VFMA3YyLgMaGdoNC7whpq5H1R2HG69RtzMPI04+Gp3DAKJ
	 25w68Iiebni7Ou0LZBGqQTsFVFx0y893Kc+J4xwEXIQAV+LHUowdxmwpyXqTUKkV90
	 gvtO3EBDfewkw==
Message-ID: <3bd88620-c245-4fab-abb7-9091d9a1b649@kernel.org>
Date: Wed, 14 Oct 2026 11:33:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd() in
 its two callers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-11-kirill@shutemov.name>
 <b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
 <ar-nKHZ5hlbsXeFP@thinkstation>
 <dfbb4bac-0def-4e1b-87a7-91c9cd91349e@kernel.org>
 <20261013143839.832f1a4db51f801a2b95f850@linux-foundation.org>
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
In-Reply-To: <20261013143839.832f1a4db51f801a2b95f850@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B4F9180008
X-Stat-Signature: m13o57zw8sctdubgf3bhxx4py7ghbqpq
X-HE-Tag: 1791970436-579550
X-HE-Meta: U2FsdGVkX18DIg7DE9ij0JjyTq8doPOuYq5mHWkw0Y/HPjjvE7qLQI6dby00+ctbj+1GPic4/LRS808tWFRm/e3YRw36H1uhIZ0KnrY6Hy1gQmIvpbzCh9IS3ox+ZkI1BJglWmA62vqOlkGZR/5pAIRB9e5ozDb6SF9O7KMeAPK/HFuIJ1CdZ52LoowCb9PiTZjUxyl4T4104LPHPz3hxL7Q8BqxTeBRyrWHWbmFSSH+RKBWWpjd1Al2mW/xyQXP8PLL9RvH6a5id92aUsT2Znh7Zhnw8KW3iImf9mUmMIdoiC2Y6ggAR3tkEtw+oayGUgR2DztxfdHswPVf7ltk+zMc9TpW2pCZGE4DhCQgfBUCwelGECOcag0+Mm3PHT2OZc8xknkIbTWCTqfTvrtsCpskEaH1dtWUF0LzjmF2e+NQkewaMCyN9Zg2y/KqkRIb1/+yc0v+O/9isbDOm/RrrTTHfMJQ9v58DYB4psbwQozx4kHGbHcYGflsD77riQ5S4E6pFTZ6vPjG2d/bR/+PnR2c2c4ZDHcBOu6vjtsi8z1krEDru8K4lnalyuMyDIGnSJllN/MLY++MG34Se2RQQNJu9uH2sw2o+8Oa1EgeV49DhTzuBNdFe/s60wlkF2OKH3pvpIQOZ1JZUAnUu+8lVpPQ7MtIpWYsMHJowsZo/aW0mzuHrQXRXGqdgLve5TPS5jlUklJG6NVyuXMgH13DXtoIgdhyR4kaClGGqgGRAm+0MPxVdNwO2ePjTCyExggxLWV7NVD/EdCsHEDNFYdDeRfZdYzzZzBJaPca+5I2FRU8em35YAG8yGf5p9WiyU+bkVNs1ciVx90uE1LLNLUZmEeUa0XZEPyIfRhjAtNPGc7pBp21P6e2/MOnzILFLKJ0paWnf+1eHjxkZdch4QJcf+IGZxUKQnLCqClWkln+63symAgltrzh9sU8kqVB2f3kMRHfnbuF2DCxKar8rZD
 rTXcTxNz
 xVg4kvnlGTBGXVIdXw6d48e8KYz+nVvAKvSeCG50sFdWNRyRzxnCCRquyCwQgduC7RFMDBA9yTm4GRfPgtGk+OEWjtfVZtmQpaXgZoM1DWJG4XEbvePxX61DmDdIm8HwlNZGhC7GyOmlWXr6ZbgburoLuzoFRkbmyv+y6SRHy/kGDBgGF+ahn90AvFQ7L9x4dr/6APN/G9mKMPifb2F77pHrHVtgW88qcKYIcUsv94lcLkFlq8fLeYO6I9Llc/5YS/llrzxz59gEzBleRK6IG2pjTfttyvfeUXdnNqxTKNuNt3R4Tev1hY+2JfhMyRwKoOBU3ir2qzYwS+Pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 23:38, Andrew Morton wrote:
> On Tue, 13 Oct 2026 22:25:21 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>>>
>>> I see the appeal of the single entry point for the collapse engine. I do.
>>>
>>> But it costs us on both the locking picture and the scan rate. That
>>> does not work for me.
>>
>> So this is in mm-unstable and I want at least the first 9 patches to go to
>> mm-stable rather sooner than later.
>>
>> As raised in person, I don't like the open-coding here; it just results in weird
>> API. I wonder whether we can come up with a better interface, while keeping the
>> locking as per your requirement cheap (scan performance).
>>
>> While we figure that out, does it make sense to send out revised patch 1..9 to
>> move them to mm-stable while we figure out the remainder of the new API?
> 
> I've suggested to Kyril that we park this series until the next -rc
> cycle.
> 
> But I can bring it back - we have a couple of weeks, three if we get a
> 3-week merge window.

I'd say we move forward with the uncontroversial parts, and keep discussing the
controversial bits. Either these make it still in this cycle or we'll simply
have them for the next cycle.

But at least some patches that should be good to go in would be off our plate.

-- 
Cheers,

David

