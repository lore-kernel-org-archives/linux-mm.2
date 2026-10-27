Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34B3606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftRU37dy
Received: by kanga.kvack.org (Postfix)
	id A977F6B08B7; Tue, 27 Oct 2026 15:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EC86B08B9; Tue, 27 Oct 2026 15:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934CE6B08BA; Tue, 27 Oct 2026 15:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62EA36B08B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:23:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A487A8859
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:23:12 +0000 (UTC)
X-FDA: 85369379424.10.C2AC020
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51308C0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:23:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftRU37dy;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoOcwxnYW5BPsnbBpyOUUjSJrZpAEuBUDQ6Rytj43SI=;
	b=dbwI+R4Y+uyQ4QNlgaAdSurYQlPE9T34DMicurrLcP9RhWKlpyH15oj8eFK4MVJ9B+SNiu
	1PQzMX9+8LSUDdnipWJGEkpqY9/38dTNKehzU1S01NBSqAAFRsTjjRz8Lf58akhSVz0yKq
	zgGFgqA5g6d3B78WS6X4tEf3K0YsIuQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftRU37dy;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128990;
	b=eRCyTTktaCifUjo2HPJbCY62qYXjB2qxA/OYpb41i94Q6lAGNs2Has3znvY6rSC/1dQBX+
	PW9QcWQ/8CRYSknENti+txig3gEO6rncfSDm4iqKHHzOmAOAMgDLsgF0ndqSefWoEGuYK+
	Zsw56X1SpXv21W0EP7vlbIoUYutAIBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD91E6022E;
	Tue, 27 Oct 2026 19:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331471F031E6;
	Tue, 27 Oct 2026 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793128989;
	bh=HoOcwxnYW5BPsnbBpyOUUjSJrZpAEuBUDQ6Rytj43SI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ftRU37dyB4p0fpCveWi8u9OzVVMH+c9jVXZBnjJEcbX+3eUtHh0Bpvj0EPoUXVaPi
	 0QIZG6aMCRRp9b8cz1jyaC4I/RPv5oyxP0gLO6UnDAB0wFu8xZJKIBLAV8TY4tp2Zs
	 V90tZ5gdhOHNZIuy4O8LU/EauDhEGQ1e41/XKUoUv+VeND2ArLOaAradJIZSY1HXf1
	 4HUN70NN0Glr6awt8YHNGO19R2ozNFjPj7mGG/v7TegGd0qz55IDN87LZJ/bb9e51c
	 XNnTusUt2bSy/KdE3hQfe6e0wG0LfmdjZ9rOOnLn6PNHQxl3T0uu0eA167PkncXzMF
	 vWwdNA1FTwpXg==
Message-ID: <ec55c760-f099-48e1-900b-9f8e2e5315da@kernel.org>
Date: Tue, 27 Oct 2026 20:20:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/46] mm/gup: fix clearing folios in memfd_pin_folios()
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org>
 <2vxzbj8fp4sn.fsf@kernel.org>
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
In-Reply-To: <2vxzbj8fp4sn.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51308C0003
X-Stat-Signature: skpa3k8zgwety3u37cggmtru7f5fjxqt
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793128990-228129
X-HE-Meta: U2FsdGVkX1/1lSGas3LpSsCUnspOlbsbKcfhl60kPfkCGlzRMJevzy3lb6i0wpXs4hGW1vLG7bEnbyTJGMnQsISChjJGyo4RllgiH+o6qcjrs/pgCAv0N0//bBNlOqBvur4cHdg6JG6JOHK+O0L9xSVYd1MnNyy+zRsqqAVH9wLTDnDG+E2veqVmwgoRl5s8ReWR2sEWo146l33BWKbQuqX+PItcQaSGWa/RyTPWWwOga3foqwZM0AtftVlI/U50gOUYF3Z8SqbUrfagwGGJ2cPGKorAahq/nwxdRudigKoVbwBTgmuMnlxNV1ZIzRA2QgiJpRmQJW8SppoUKUCkiHW2lobugvgjBvuqpCxSDqMLy6c8WFgz92JQTUgJnbY5LnPr5C3KZOsPQZsYIAU/rAOomzFph26GQ6E16cjfeu7EEuTH0vjYDQyMNKvHqRtIHWnCs7cuRbtspysvKTw/aQvWJAea4/1uey3DSiobJWZj29kV1M6/CK0XRltbtX8Zj4kIv2gZ62BhbEZcQPaU00q9t1H0IhV3lLdRcX1vbdPVGy2FCy/eoY2WgCtnLCMermfv/fBHAx0LTx0wQ39HPspjHM/pwpLMcwNAIvyhcFmRb9yIAhQ/klWiieOqsdPTGIEztE/VjHlfYPy7CF8ky8hVlUcNpASKnYfVIv7lF+FofjTYXfZm8s0JSqVLg5HH2gen0b7Ws2SNegypXJSPGHJk0yrFjavWiRHPjCtC986yvucmk7Prwxt2W3dzgCylX0nTg5ewFVQ+e6qNjwHbXL5MNE0W/XN7707soVMkoqtM2osiwFewLuuGueNvHvU0M45cda7AuwGk8Inc9/9dZpxpbAEAjRf2loMqfDRxBOyM1BIECtggZGD5gamoTcyMeJJsAqxiCeH2V+DkjHR0zmqdmEe5WN7lM2CqmAYd8oQbjK6FkAFwEHbZatAIlJQMuwrRxwmwM967/SnZqQ6
 T9ynBcaz
 RiTvYG923+jCS5z8BZCsYKx5BIA4GrK33kaxceQUytdZnyK5JvxWJoY5h4NzumhVDm4lTOYIPrUY8yylbaZgDJvDHf9wxS+E4sa95RWq0R5fpZMg/51OLQeEd3LsSjUJv4Pheig+2qUlKbmrFMzLg+BptZETgB6sMKcsFIz9/eC3hOGlV/9rdK6JuR57XovQ+AnWdwPdQmnm0Kzw9ckZPvVS+QwkHZCDmM2fbrPjMhTScYRPCWEsTlMwnGwDoEHhTHuBekc971uzocsGkXnVGx0DrF+u5Vc7EF1u4fYkfpxBIV6J1kmhJYD8e6TW9nYkL5X7lDh2XPASyTvFf89c0OHxKMMJQzWnohCHeD2zGANUav3lBC++MOf923QYy5nUupdnSdBMoIXKx2MC4/FXgfq/VRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 16:00, Pratyush Yadav wrote:
> On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:
> 
>> From: Chris Mason <mason@kernel.org>
>>
>> memfd_pin_folios() pins folios obtained directly from the page cache
>> without checking whether they are uptodate. However, shmem fallocate()
>> can leave newly allocated folios uncleared and not uptodate. Callers
>> such as udmabuf can then expose uninitialized memory to userspace.
>>
>> Clear non-uptodate folios and mark them uptodate under the folio lock
>> before returning them to the caller.
>>
>> Fix generated by an LLM and sent by Chris Mason in private.
>>
>> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Mason <mason@kernel.org>
>> [ david: simplify description and comment ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/gup.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index efc9aa2654625..47e7ae152cdf1 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -3516,6 +3516,20 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
>>  					goto err;
>>  				}
>>  
>> +				/*
>> +				 * fallocate() can leave folios in the
>> +				 * page cache that were never cleared.
>> +				 */
>> +				if (!folio_test_uptodate(folio)) {
>> +					folio_lock(folio);
>> +					if (!folio_test_uptodate(folio)) {
>> +						folio_zero_range(folio, 0, folio_size(folio));
>> +						flush_dcache_folio(folio);
>> +						folio_mark_uptodate(folio);
>> +					}
>> +					folio_unlock(folio);
>> +				}
>> +
> 
> Nit: this logic is repeated in a couple places in shmem.c and in
> memfd_luo.c. Perhaps it deserves a helper?
> 
> Anyway, sounds like an important fix so don't make my nitpick stop you
> from landing this if you don't want to bother.

Thanks! yeah, I had the same thought when trying to improve this. We should have
an easier way to just not hand out unzeroed folios outside of shmem core
functions in the first place ...

-- 
Cheers,

David

