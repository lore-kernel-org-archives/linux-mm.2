Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72754606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IpPZXKRG
Received: by kanga.kvack.org (Postfix)
	id 412A86B05B5; Fri,  6 Nov 2026 15:54:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CDB6B05B7; Fri,  6 Nov 2026 15:54:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23EA26B05B9; Fri,  6 Nov 2026 15:54:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 075E16B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:54:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C7EE40204
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:54:40 +0000 (UTC)
X-FDA: 85405897920.10.0FABD05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D63302000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:54:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpPZXKRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793998479;
	b=h5HsEboyAQ/RZQGqZQiApupYHfnG9Ahf2lqL4sVh66CdMvKPHiJcHuxicooVzKFb8S1CKV
	S99TFjHUFrTsPC8M2FOcvGyJR4BDtZ7PDDrYgxUxM4KgiGgIRY5Ywi3sZKC3PE0I8PjY5X
	AKlLGT28OVmE43+q2n9EtLdOwbSX/pg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793998479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsX+TMzFckS6UeZpPD2RTOIgXnxB2VhmQ+PsRFL5QKo=;
	b=ZCyDscgzdY0SIzbdRY/V8pAw3CKJMBJtQ3lUHfJ+sRYo/fKGQtwqomgttUsYjZE2rZXx7r
	XOVkIJJ8oXQnWr2i9MYqUWW1KqxYqt1F8oYCEwpNsllZuXfn7i0P8sM70EEBxr2j1IWJ3i
	/oXDojn/cGsJow3nLW9lLIuavK3BgyA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpPZXKRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5676D601C0;
	Fri,  6 Nov 2026 20:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC9B1F008A1;
	Fri,  6 Nov 2026 20:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793998478;
	bh=AsX+TMzFckS6UeZpPD2RTOIgXnxB2VhmQ+PsRFL5QKo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IpPZXKRGpf9khfm1NTYYTBT+gxgNZ9uloqpY/GSHjqUrcXTJzZoR+hUq/DX2K7bh9
	 KIJjq7S0jJSkgper9xghQon8ZNFYo5LokdvH3ByRrO2r4RiqrjLdbT0dCNUJKrJRWw
	 zZQkusqGT8tybUC3V/CG5LSebX0f9dwUH/MmI0cZOYC3lTOmUiwp+q8Qr/Ni/YSGZQ
	 x1ZBdGNvOlz3u4N9kdHSIDNl0do2E4dd90+t4IOqsvA9fq+b9GE+mpz2Ag8RF76v6m
	 NkL+WdGxAeY+tzEn7JJhTScK+oN4/V8Zg1dz+VOq9yDQOZVYo/zZQ9et+604MSVHHr
	 XHUUeOum6FIXQ==
Message-ID: <323500a7-ffca-4285-929e-f667415589a3@kernel.org>
Date: Fri, 6 Nov 2026 21:54:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
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
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
 <au3JT5QXbcOFXCp0@thinkstation>
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
In-Reply-To: <au3JT5QXbcOFXCp0@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D63302000B
X-Stat-Signature: wkrfo7iic4ztjobaw7zkimznydhxe7eo
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1793998478-681852
X-HE-Meta: U2FsdGVkX18e/1Vpt+byy8fzaYUWy16kXKoPziOfV8LcX49iPOqUiHkMbKifsfAP2HswPYdZpzxcogVZyMw+iBPrRB4W3vsOJIeACqjEFhBOAHAxRXL3qgiElfAUzJnIanIjljoKz5tOPG4pVpmXK6cfY3SEv2kjlOlcrvilz94zymlAg/CsGwYEEF9NlGE+uaACb2L4tI11lCebkZnofAyWMRNcN4S7vepzfUbvVtCYs0JCpPglw6Ggrh2nTyZX4tcyABJw6DuhNPwi1Lyrnn8FeDAy5eQ1i/ouorUTaMI8+YTM2u+AvEssZAoQCj5JI+eizrgcome6t3+ybJcjMbDA0jhq9h4WP8IeuehxwSkYzvT2OPc0fFCdg/2G5FTE0IlmO33M0g3qZZ86A1xJ2gcD/gL8yGYV/8Dx8MXrqZTydFgFmoCu4kQDxj1vmT0iVkByuLB4EEv/3N3WwfphmqohuFgEaSzgS09PFb2aZ4AK/bqTI7E5O7ZFoXi1G0axXYmMZzEM7Fsn6td82X5YhV3gQpdENM4aySERWSIDCq6oY4NgEttN/+hRK1jxxwMltCfD+KRfXsJuAWDAiaNixnPj9xju1YLk+jv5PeeyvI1OvEcvlliBL+ZOiYGhXRIzyYZUqLvv621DkcOhjjJkJl7f/TrsBTC4bZwHJgMYmLc5IV4z6i5UrN6KNsgCsSOWDmp/W3eJ6AcqGpuKSbYFE21iVssqSnWlU/zQ29Ydz9w2dSbYYB3MaaAk2fgqcdIiq9GLjA/LqjNnSRrvWzfHt8/Ydj8kz1iCuic5tPI5XaeVzI0Mg3dV9RmzSuk1IcSCZnsnvBRod0e/XN24A7RTrviLji3rABuiX3MFGJn7smGW3VVrNFXu0EsqWHPgxsQ6rGf4c7u0jlU2il1lqgM8PMc7HJCwBr9xEul6hvRuggmkfDYzMsMO7axrBkV4yWKrMWc4sRZvzM6WGLUWHUV
 vlIs0EUr
 wbOec0+j5oMykx3zkNo+lgFsLzeXeF8WlJ/eP1HbaMLenpRYufwQjczgzs/8k/9C3UgxoEhI6j0C32oqp8EEkCnqnQIyMb4/Ve/z4juMaQLyPDimqC06snkGRQOuu5lYV+d2ID/pbrHHltuBy9TTnyJI7ANpt+jdQzDKV57iYY9aWhdVHAbDLEoGd7aymAnr+j0Xs6ZLdW+marGOkv1w/4J3RaAHyIcZRTsz+xaRWmxayiPOO7qrGmuCQRhLcq4B01kwl3KqezowvLNO31E+Ju9RMQLOwtRQSVmNdyZzwyLmfJ7WcDFyX0rl6D2rpsFIEW+DaHHVweBzXy86n9RdUkAjdwRXpU1aVuZxpOuoyvH9WjkWMkhS2HZVA49MEhQmoa9jQNlTHM3xocZ+YVqfhr4cKnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 13:38, Kiryl Shutsemau wrote:
> On Thu, Nov 05, 2026 at 02:10:10PM +0100, David Hildenbrand (Arm) wrote:
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
>>
>> Also, just document -EHWPOISON for copy_present_ptes() while at it.
>>
>> Reported-by: Chris Mason <mason@kernel.org>
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  include/linux/mm.h | 33 +++++++++++++++++++++++++++++++++
>>  mm/filemap.c       |  6 ++++++
>>  mm/huge_memory.c   | 24 ++++++++++++++++++++++--
>>  mm/memory.c        | 23 ++++++++++++++++++++---
>>  mm/migrate.c       | 11 +++++++++++
>>  mm/userfaultfd.c   |  4 ++++
>>  6 files changed, 96 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index a2dd76cc5bbfe..79ae8fc0d6bb4 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -8,6 +8,7 @@
>>  #include <linux/gfp.h>
>>  #include <linux/pgalloc_tag.h>
>>  #include <linux/bug.h>
>> +#include <linux/capability.h>
>>  #include <linux/list.h>
>>  #include <linux/mmzone.h>
>>  #include <linux/rbtree.h>
>> @@ -2228,6 +2229,38 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
>>  #define folio_ref_zero_or_close_to_overflow(folio) \
>>  	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
>>  
>> +/* Leave separate reserves for administrators and concurrent reference gains. */
>> +#define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
>> +#define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
>> +
>> +/**
>> + * folio_ref_count_over_limit - Check whether to refuse more folio references.
>> + * @folio: The folio.
>> + *
>> + * Relevant for large pagecache folios (!hugetlb). For these, we have to check
>> + * before adding page table mappings or other significant refcount users whether
>> + * we are close to our folio ref count limit, to avoid overflows.
>> + *
>> + * Checking this for other folios does no harm but is mostly unnecessary.
>> + *
>> + * This check is an approximation; we leave some headroom such that concurrent
>> + * increments, batches and temporary references are not a problem.
>> + *
>> + * Return: True if the caller should refuse additional references, false
>> + * otherwise.
>> + */
>> +static inline bool folio_ref_count_over_limit(const struct folio *folio)
>> +{
>> +	const unsigned int ref_count = folio_ref_count(folio);
>> +
>> +	if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
>> +		return false;
>> +	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
>> +		return true;
>> +	/* Background threads must not consume admin reserves. */
>> +	return (current->flags & PF_KTHREAD) || !capable(CAP_SYS_RESOURCE);
>> +}
>> +
>>  /**
>>   * folio_get - Increment the reference count on a folio.
>>   * @folio: The folio.
> 
> Does the slow path need to be inline at all 15 call sites, GUP-fast
> among them?

It's not a lot of code. Do we really care?

E.g., in gup.c, the compiler is free to not inline into each of the two callsites.

> 
> Maybe only leave the likely() check in inline and move the rest into a
> function call?
> 
> Something like:
> 
> static inline bool folio_ref_count_over_limit(const struct folio *folio)
> {
>         const unsigned int ref_count = folio_ref_count(folio);
> 
>         if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
>                 return false;
>         return __folio_ref_count_over_limit(ref_count);
> }
> 
> bool __folio_ref_count_over_limit(unsigned int ref_count)
> {
>         if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
>                 return true;
>         /* Background threads must not consume admin reserves */
>         if (current->flags & PF_KTHREAD)
>                 return true;
>         return !capable(CAP_SYS_RESOURCE);
> }
> 
> Also, should this be capable_noaudit()? I am not sure a refused
> reference should leave an audit record. cap_vm_enough_memory() checks
> the admin reserve with CAP_OPT_NOAUDIT.
> 

Not an expert, but capable_noaudit() sounds good.

Not sure if that fully resolves sashiko's complaint in the last commit.

Thanks!

-- 
Cheers,

David

