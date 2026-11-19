Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532A3606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5i7Q/+h
Received: by kanga.kvack.org (Postfix)
	id D484D6B06A7; Thu, 19 Nov 2026 11:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FAD6B06A9; Thu, 19 Nov 2026 11:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35186B06AB; Thu, 19 Nov 2026 11:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95C946B06A7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:58:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D78D80BCA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:58:51 +0000 (UTC)
X-FDA: 85452478062.25.92D784B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5173C1C0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:58:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E5i7Q/+h";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795107529;
	b=SFqhriqMDYAN4s1zO3c0OqO9MYr53rZEi9ZUrM9L8Qy0YCWu18tQTzfBfJ7tQqUB1CEPZe
	m0eeShuHI5CFIhroGvkVKJWJ1EwwiYNS/OChX/3125Yot5dqwoPijgSSx43m/3TioNZkI1
	VCmTApsrdQ2BMOK/4ibhm11GaYaV2Vg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlwPBqQep+gKK2qUpmm59NmPvSqltf2AvxyET+CzK7A=;
	b=rs1xJquu+UB//G/WVDKM2ap8Vgt+6guI8XiAwZVxkFZKa7wKbde7DozpGiCZ3t13atoWJd
	tJ31YOZMpHn4FUrsb7JhGhEa44hEN7oTQ37eJx+DqyQopol/XIII3CZkuSvHm/p/oDs0ef
	vLuE9UWnGE0trIGFPUxhrz6IijCuKw4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E5i7Q/+h";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B85A463F1;
	Thu, 19 Nov 2026 16:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369D81F000C4;
	Thu, 19 Nov 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795107528;
	bh=zlwPBqQep+gKK2qUpmm59NmPvSqltf2AvxyET+CzK7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E5i7Q/+hFAt1BZyoYv9K52aBMARN3gdGsb5Hd0fQ/Ncp/+zhT8G31FoYRdlEw9Fn3
	 Sv+XgjLp3xuNMNpx/Os3SmlGfvIIHLdH2mYwaI5iELfsOsLyTUsARWkPokMdfVW/en
	 O8PK7XTxuWnoNq6GZCrKl3UAB2U73P0rQH5Vv1pscf1jAgHlAzkIgcDmTiAouU5CTh
	 UxDrMliSDGsiwiNVD/eiUXHfMjCrQxsGij/ugStyy/FnDo2XBORIHEmScDx9CtuoBS
	 jMnqM80TV0xX8lLL7RBdcUfGHKDvlixfkeVj8vxoCNAl/wCagQrid6mczsIKjX6PWA
	 rASJf86jUOqlA==
Message-ID: <68dcdfbc-2755-437f-bf58-d175b1740afd@kernel.org>
Date: Thu, 19 Nov 2026 17:58:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/15] mm/hugetlb: serialize page-cache allocations
 with truncation
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, stable@kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-8-4dd9e94ea9ac@kernel.org>
 <av683B0FDj-xB-7w@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <av683B0FDj-xB-7w@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5173C1C0004
X-Stat-Signature: pa75n9uutfrazfq7csxzuh1epmp8d4ht
X-Rspam-User:
X-HE-Tag: 1795107529-309950
X-HE-Meta: U2FsdGVkX1/xjjvC4jQoDDsHDhWpf3twE6zRVbQAUItciuqrnWGKhfCnt6bBpnwsZMN+jsz8GPFPiJ5dmN2Frf5wY8Is63vblYuKUL7fJGcKiq5JyAQizAcRhmwx/BOJpZVAYQvblJ14rITtdMTBOaqN/gC1+wiC4zZP6hQ4cC3pBRFmhO1MneuAONYqSxifjYSgXp7YkEDgoBMdTsGcTHkl5PjzhffMDW13vIXSeE0e5EmN1kaLNX8iErqm4L0PsrjC5vPFptnjB3KsedZvRG8jn+TRppACNbZrpR01EsrOTJvaXwS3WDxDQIqo0mTETm5/ReZAY8eTBEG0J8MNsPgacbKjRLhaD2Y3R5PIc7WsCFrAnn1jlUhr/pyY5mgG3cmNhaqThB1pGqr/rFFt2T9DBIRKzR/VwhFoWeR3MODnOgoYNzzZSjcXwOblrRdze965yy8ybHSLCE0qEiK8ftxiHJAzZmzK7+p5SPkswMbvy0XI5ILKM8PbkAGbKFI3cnW2CYl6s2MSXRfJLBzhoGRHV237OkdLYb96Z8r1yZkUtjOVFhOOQaQfmSwkS2eL8G6zX6iWqwZUoTCa5ml/LVzm/CMaP+2SvzEQIXbgEouISyRTcr8T1jEJPI/XwAM3CCsCLjUiHjpTZkgJ/Az2ZAc5Fhf5p8G3XafD8olodPEhGFLlolqtewho1gBVnNmiLYq5gnKILranmixPD0F1xsBNJZpdNbQ9C3YZ/tdmwWlNDRLFa4qHIObmbA0m8jymm7LDFx9mAFJfNBzTZqBOZQWmuRQ0meA4O2LTMFlmmnbO/wCdapo/hR2lX5oV9nCo+Q2IJn+7kSuP6/wNTUjZx9Z8w6oUjZ5yJh1jJ9gu/wtozQt1bUOMxm6Qbw0qAIHPLoYDq4bHYPTBcnKiBVQt7OA9a5D+FN8J1jqtjX7ZXUfmslxdBWbPgFfX+9MCpTN2Psr59buzjyJROUAKoBD
 FLp9x2Pl
 GOSEDykmTD6r13ON1l464wXRFF+FkasVU3zDEbv6nov680wL+43ZSJofoP3EYbCJoPDjNYQRztW27iitYtLg79nmBBLfgmBjhgA1T3+Y1PPkiHb64Hqz5QDfFeFg553DgVmqMfhbzo2OJRCOFN6AxgeQDIiHOH9ik4txLM5ewmZLP0zYA+iLogXndFU3OQX/RF8esXRJBA8mt8jgjXGzSiMM9A5wPsQ6GH7CEUCvAivejltTjF7HqG0j/bLjwNFQuM42bdkS2o1al7y/pj/V6Q7RDTZWHBspQFShH2FtJyquHh5MFWvft21YWG9U/r6XNfTqr4L1erQV+X/jzzfSNXuSuB1yd0+sv5MiQdTFZHjj3j8bboxP7Ng0zyopAHjT2VrX9APznDDZanHjmK6pAJCGB3NNv0CEEp/46bDvzOHWJdRNb/egassdbfHF79upTehIvwNm+RtrYGqvmykUNYVWyL9aNfLbLf0T1wSFY5ZLU6qsQBOUvXPBuIXnqmvpm/9PmbbVIUtKR8xPb1m3wTQgdA6+LIM7hx0gWCY9gzpu560OMOyri0QWQym4L6/2CXqnTx1Kq7K56G/UraRdtOYMfkUoEy0SYcf+BdMJ/K+onm1b3qbZU6CX2Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 10:09, Oscar Salvador (SUSE) wrote:
> On Mon, Nov 16, 2026 at 07:29:29PM +0100, David Hildenbrand (Arm) wrote:
>> Truncation can remove an inode reservation while a fault is still
>> allocating its folio. UFFDIO_COPY and memfd pinning can also consume
>> reservations beyond the new i_size. This can underflow resv_huge_pages
>> and leave folios beyond EOF.
>>
>> The main issue is that truncation takes the fault mutex for folios in
>> the page-cache, but it has no clue about faults that are still being
>> processed concurrently.
>>
>> Matthew Wilcox raised mapping->invalidate_lock in a different upstream
>> hugetlb locking discussion:
>>
>>   "although I wonder if we still need the fault mutex array, given that we
>>    now have mapping->invalidate_lock?"
>>
>> While it likely cannot remove the mutex array entirely (concurrent page
>> faults have to sync ... ), we can at least use it to fix this problem.
>>
>> Hold mapping->invalidate_lock shared across the size check, allocation
>> and page cache insertion or reservation rollback. Truncation takes it
>> exclusively around i_size_write() only for now: it waits for concurrent
>> allocations to finish updating the page-cache or rolling back reservations
>> before changing the size. Subsequent allocations see the updated i_size.
>>
>> Let truncation release the lock for now before unmapping and removing
>> folios to preserve the existing lock ordering. Cached-folio faults and
>> private allocations do not acquire the new lock.
>>
>> Use it to synchronize with truncation, keeping the fault mutexes to
>> serialize allocations for the same index.
>>
>> Locking order is now:
>>
>>   fault mutex -> hugetlb VMA lock (read) -> invalidate lock (read) ->
>>   folio lock -> PTE lock
>>
>> And on truncation:
>>
>>   i_rwsem (write) -> invalidate lock (write)
>>
>> Add hugetlb_pgoff_valid() to not repeat the same size check multiple
>> times. Memfd needs a bit of care, as it traditionally allowed partial
>> folios to be pinned: the size check in memfd_pin_folios() allows for
>> that.
>>
>> Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
>> Fixes: 188a39725ad7 ("hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race")
>> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
>> Cc: stable@kernel.org
>> Reported-by: Josef Bacik <josef@toxicpanda.com>
>> Link: https://lore.kernel.org/all/ajMfdQf-Fspwmstr@casper.infradead.org/
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
> 
> Just one thing:
> 
> mm/rmap.c has a description of the lock ordering for hugetlb:
> 
>  "
>    * hugetlbfs PageHuge() take locks in this order:
>    *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
>    *     vma_lock (hugetlb specific lock for pmd_sharing)
>    *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
>    *         folio_lock
>  "
> 
> We should update it to reflect the updated locking order, right?

Indeed, thanks!

@Andrew, can you fault in the following:

From d050587df932067bcadb618cf8b72604bc9af58e Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Nov 2026 17:57:41 +0100
Subject: [PATCH] fixup: mm/hugetlb: serialize page-cache allocations with
 truncation

Update documented locking order in mm/rmap.c.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 0faef46806e5c..a452db02826e8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -48,8 +48,9 @@
  * hugetlbfs PageHuge() take locks in this order:
  *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *     vma_lock (hugetlb specific lock for pmd_sharing)
- *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
- *         folio_lock
+ *       mapping->invalidate_lock (when allocating page cache folios)
+ *         mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
+ *           folio_lock
  */
 
 #include <linux/mm.h>
-- 
2.56.1


-- 
Cheers,

David

