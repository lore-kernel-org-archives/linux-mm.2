Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06713606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LnIYthTQ
Received: by kanga.kvack.org (Postfix)
	id 9BDC56B05BC; Fri,  6 Nov 2026 05:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9961A6B05BD; Fri,  6 Nov 2026 05:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837CD6B05BE; Fri,  6 Nov 2026 05:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 489B46B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:06:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1614E140CC2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:10 +0000 (UTC)
X-FDA: 85404263700.02.D5EBB6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 58DDB80004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnIYthTQ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Px8YGrUbpB2T2jEhenGoA16y8NMxi2MB1FLmbQ0eAMw=;
	b=3zHb7Vkb8rVcV3GwCSZ4P6rhQPnF4wrLvahywIHjw0epGR7dmfuwRfqIiax97WIEktgCCC
	34LvPLaqIlue9VQ4R+fl3/IygLN72eReXbZ5jfONN3bzPdQGjrAKMQBFo9v9B8rVQajKxh
	EerZ30+aJTjBiEhY8TpJFcdoiFeGJHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959568;
	b=g3itUqrguasF8etBYHdJeoVjLKqJ0ouIWVwSCbCJDckhOGhOxglyD5VOxDnOfdHuhGt+gg
	8e8pLRZ1BhF9uOdtfGJmOeE2PXL6LCfdYp34MP9qVGuNY9fAmWqigVxmzZmpphPJVOWLH0
	y1mKB3xP9K8X7OFg+LzdV0TGwOnohxQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnIYthTQ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFB7560232;
	Fri,  6 Nov 2026 10:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68161F008A2;
	Fri,  6 Nov 2026 10:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793959567;
	bh=Px8YGrUbpB2T2jEhenGoA16y8NMxi2MB1FLmbQ0eAMw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LnIYthTQJEXOjvvLs54ZGX/uUfr0klYw3b86wsbcnRnjMkpBZxFYk4+mow/6/uap8
	 Ivtt9RN/Kg0Vc9xqaRycTlEc2bPPJKnPZ6QatK+5uisGzt8lOls3vzsRNfvYPei+Gb
	 XU7CLMDzEh5hkUwM5oR8dSDjbO5AXhJfvwxMegtiuS3dtstOuW+UNGQgD3B/Z7aKDc
	 B/jYYug6sRFk+ZM0OhppHwhlPQCm4lPM5vlZE7T20ObUuqvApxXnI/Ra+UjDJ1Tram
	 cJlEkqKW0G6jBDB1Y5PPWZc6twszsfy5hzKboS8hBCJmh0OmA0vOHCV4OrE7HdLivD
	 BIwEstq14SG0A==
Message-ID: <086c3d5f-84cb-412b-b61a-8cb3ca3e2e28@kernel.org>
Date: Fri, 6 Nov 2026 11:05:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
 <528e3a0e-04fb-427f-88c7-63a7f4bbc505@gmail.com>
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
In-Reply-To: <528e3a0e-04fb-427f-88c7-63a7f4bbc505@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bib46k9q1h4surd3cicucyadhwuyiy1t
X-Rspamd-Queue-Id: 58DDB80004
X-Rspam-User: 
X-HE-Tag: 1793959568-542601
X-HE-Meta: U2FsdGVkX182IUYuxu+MEASHg8SqhKBgfxte9fa6TnaVp4iPozCXRpUuIs3+OJs/vwObKYG1k43FaKCXDNjNsLZWQNGiF7zJ4dzXVZKKnJwWlswD5sD76bB+C7dAhXrSJHsee4gxWG3zNsmxxpPsmAq2yLNpxJ/Aa2kLEAY5Y1fHWuxWTS1HpeoYL9x7X1RPgaLStN4MtXpSLL4l7B7E1d8Liq4vph0V4OE2VdbZ1g1NWWEdG6xPstynRHee/acS/5bboPzHwWmLo+iBvSMUK6VQxjNsBplV2F1kgPwJr63K324FTi9ismWtyfR7F0VZlcRvoZKzr2IYcNZEwzwjoQmwVTv1M7/i/eYE2MgaT6mXGLUUvDEb2xftfXwnBIA16q8xPlqFezsERfv0nvBVxqXTCA+umtLmCCO21gsiAPlC6EgBqQ6anIUDZaSKctCOyR6VTWe27Or7HYUsYUXjwxJmb4vZjvIdSB2MIahNRONaITY+eFFEbaHc9mOjI5lOvjby2us6CSRBQbyDrK6/KCmXV4SDNl1zcdW8SbJxUl5kZjNkfvGNslvnnY6n34JXX9CKn5eQ9hbMC6X1wflSI95gBIMGPed5Lz2DAAZsky+pBJ/KV6kHQFKqM8GbP/V/dYHy4CXHDOppzAVcVhxbzBvA2yPhPTYeOjei7zJa9Q5i4yOhuLf4fkNZswJjOyywO/73OqZSu8nIz8ITeXxOvXPlnGOtJIJLSyg4chFXO0p53zR8oK6bfKD0dHXw2fbxjQDajIIWD/KbrP74JKxEWBLM8hxJENiC2Pl1gOMxe3o99kxl6eKjLUR3jqNxXHZJb8OXJybTaF/9udXw9XqQsteVdle+2RA2DJBUPQ08NVTR6KQVZkOBOD3m8NHR8pbD+ksA3TgkHMPDjiL0xrMgeVEVvM5DmNIqUplFw2GVdmKNZRTHzuWxwGUkPZAdlccnA10i8Wsudl4u/OpO/bS
 dpUpQ4Hf
 F1KWF/1DA8eRKZvZ9Xts1J0Y1eiY19LyeMtyMia0FGfs/+TpenX6GjVgbLZN4ptM5gTwCFO4HXJH5YdN2kWXH7g5tLbJSoSAJXPMnsSu+BCRQsTja+AYdZdYkK9cZy3+b+P5P5mhA5qvH+UCJwceGa5RQUcyqm3Q9idtWEkL5clTKB+WUH8seqe3OArtHaj22wplaZoJYbMmIUBbJksYR2pqEsdFSqhDBl42PYugciO5ztOOJdVNr4STBsznUDr8KBAOMevgE5EpXL8Avbv8WOTzR5OXvugXlarqASMXmxzA5jn1h9ehrHKonsqx8tXlIhSP4qlXSovKhtRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 10:42, Jose A. Perez de Azpillaga wrote:
> On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
>> With large file folios, overflowing the folio mapcount and refcount
>> became possible. For anon folios it is currently not really an issue:
>> each large anon folio can only be mapped once into a process.
>>
>> That's not really big news, but it's about time that we do something
>> about it because some modern technology might find ways to abuse it :)
>>
>> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
>> refcounting"), however, file thp support was added later.
>>
>> File folios can be mapped multiple times into the same process, allowing
>> for processes to hold many references to the same folio.
>>
>> As a short-term solution, let's introduce two folio refcount limits:
>> one for ordinary consumers and one for admins. Leave some headroom
>> before the refcount goes negative, which we really don't want (having
>> the mapcount go negative is also not expected).
>>
>> Start reporting SIGBUS if we run into limits. When restoring mappings
>> from migration entries, instead zap the pte/pmd entry. We allow for
>> slightly exceeding the limit to keep things simpler.
>>
>> This is far from ideal, but better than all easy alternatives we can
>> backport comfortably. For now it fixes the big problem: letting
>> the refcount (+mapcount) go negative and cause trouble.
>>
>> This is only a temporary fix, we'll follow up with something better.
>>
>> While the refcount checks are not required for order 0 folios, let's
>> just add them for consistency: each folio_add_file_rmap*() and
>> folio_dup_file_rmap*() needs a prior check.
> in mm-new copy_huge_pmd() now does a folio_dup_file_rmap_pmd() at fork,
> since Konstantin's "mm/huge_memory: copy file THPs at fork like
> copy_present_ptes() does". doesn't that one need the check too?

Yes, that one will need care as well, thanks. I think I missed it when rebasing
on top of the other fixes.

Thanks!

-- 
Cheers,

David

