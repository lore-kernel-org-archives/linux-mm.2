Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C65606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRpMfbpZ
Received: by kanga.kvack.org (Postfix)
	id EF6D86B00EF; Wed,  4 Nov 2026 04:13:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7956B05B6; Wed,  4 Nov 2026 04:13:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F396B05B7; Wed,  4 Nov 2026 04:13:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A92BC6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:13:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20F9216066B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:13:38 +0000 (UTC)
X-FDA: 85396873716.09.DF77A20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 602AE1C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:13:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRpMfbpZ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoVFgUlolmEAFzVK6w+JrxJ56f3iy7qOBFWwy6NZkbw=;
	b=tQ5ial5ZUKCvE39WrMrugRlaOWr7ncGGEDUnY5cYNw82344eqGpLrRx5YmDabbJk3uO/k2
	1O10T/yOlMyOuNR8sKAHsE9+7RFn4ESwD1VQPUxk7PC0fsauXcWSUYrOTYWTOH9bb6l/Fy
	kT9TDkp2HkIgJR8yFkEfqrxYLAInFug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783616;
	b=BKNlTv8hdIM6gv80v+gZQweD8nSvGqWIYBQZw3CwRZIad4hTBuT4q8qvsnQpYzODG2g6eb
	v09T+kIln6FW4NqnjqHW5k5lC/TR55y8sKE4dlzNI+37TZTdbmFZmr3LhuhZ8yGs/Rlssi
	IwLYHu8En9ZZixt4s6/b5mRD2Gz6mac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRpMfbpZ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4DCE602BE;
	Wed,  4 Nov 2026 09:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943551F000C1;
	Wed,  4 Nov 2026 09:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783615;
	bh=LoVFgUlolmEAFzVK6w+JrxJ56f3iy7qOBFWwy6NZkbw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dRpMfbpZeYPKVhajyjXkLtGaqpGPvrZkk4yFqG2ypBe4K+tDcX4rTCHEt04jW5/KG
	 2F+gxMEZuG9fPh97FKiWfCEdg8Jkd9hbf+LLNrRXCcKFvn8ZuFpn4P+uJKcQMwTJ09
	 rh79VO2vtKtrO/B+TP5cbe5rQcohMc86qrFv09zuy8OQLIMUXYdZHWE6CAu6WuPmYE
	 xfKiLlcRwOeZxwMqBPFoAG31ac8gFp6BGwX8n+2lfkFQTHQixGQd2zGd4yCTJ0vdqK
	 iCa7zTYm1z7zGE+0f4dAUL13T6KfHHlugQYFxBLi62Qg3c5Sl/7BCdxw3EpxOPHEG6
	 HvH2dL3dmOm7w==
Message-ID: <979fb046-32dc-4af8-b6a3-177c78f1e557@kernel.org>
Date: Wed, 4 Nov 2026 10:13:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/47] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
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
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-18-d6437171ecc3@kernel.org>
 <62268831-f6f3-4666-a32f-a77546b95432@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <62268831-f6f3-4666-a32f-a77546b95432@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: z8mk9z7wydjfzzixh6xk8s6umd7zi1w1
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 602AE1C0004
X-Rspam-User: 
X-HE-Tag: 1793783616-240634
X-HE-Meta: U2FsdGVkX18ao2fYgWxnHTYJOraXJdWcBk+AFXyhTwToEVdZgURg39WPwvMsVdWZyNacM13HuzDaJTFVY+bXmDWeZZMQFzPA1Zqw/Mno+NmnbZWFkLOuggNKCHJEXBXZ6+FNJa691+hjvNE7utW22ZRl4D4/fSKpKu3997/BS3teTHtJvE3392y/E2t6MkJ3GaaokmttXqHLi400uUk9KJXqlgPMicWUB+xNtZQ8yD4h/7ykqfRRifLzIgwZJ2FxinGU8LlKWwgHzO4KHpmqkVDw2XaiDqwUf4HVlzErU1/sFNzA6pP3+/Fey8ARBI2fQ7NruH2E3nwJ7eUEnlI3hu12cRAsdxRh7lDLCkiRjDJO7tOUXM0PJd9KVGz0Wpoe5teFiQYWLwGhcMpZZADNfuG/XxqXc5iHwW/Y2iVKiQhE8DXeAWZKxwlfWxsAM+oaXhZGDBpwLjA9PIf+cJ1i0QdxQPWrWceWw15SJxKVGwGK+3XPRuIbOKpAXHMCoQWeXARiqlhigEsV774epdPgzisSGGRcbuLg0hkoVHdEBLRrntwvE4rn4VsktKCl83Y8AirNux8x9pT1Ko1QVAt2ZCGrCBqdAZt/3ALjOA2VNgC7CnsFiyu0Cu9Z+JyAB9boDd/4QaK1ceXDSSX9J5DftooO1RH9zV/pPXRyo/r8/+jvDfRhJMeEeIvYiydtAjQKzSdOUsBEXGrDhZSyBex7eyzlV5Nhc06NzdT9H7nEMnvfq+ID4fQI0sePd5TjoqpHi7kzGu1QxJvyA88i6xH+T7XoQ6DmWHeUrS14sAl0TjcO9yXxynSZwfunPUQzoNNzRuK74SXG7m6OcWGEGfT9QpvlLRXR9sy2LRuOIAsviC6+cYrTxjXgUFbUEPDaTpZd1vCng1Bge4fTMgnkij/b1mzz9w5dr6ll2lK7tN5WG5g8axyfZf9c5c07TjRUiv55oNO6BibcEkPdKHV0hI0
 JCYC90in
 q91+aUw/08enFd7nEnL07aDVKBa7wCxiLiKv8BvJQySotLOdX/gWVfGyGgfUCJpljfjVn7yhYY3RDgT4R6Svv4u5zdYdCB7dMXqlJgLofc79rsoPafx8Nqae1Qlkhlu4YKowMdoYZ2tQ5rFEDpWGq8t3x0dfdM2HL9eIvrs4s5uoI5COumGU5PEwoI/arRa867/RTzSYOhh9SwjfacwK39r8a8RMAxE17IvxJtZP+zA9gluWr5mdOgSLTwEWewj/hu6W/wHGff04FpbSnlO3lar15yxxXaw2R0Xv7l9dNxZAFVRv0n9rLWClLLGiCloKCJwZcxqL6nthjV4GN35RJno2Vvkw0tE2W7U003OLUr1aludSQS19GhGyjByNS+7SbcKjbGvRPiHs9GH/kReiKf2JZS1tooru3zwzAHhP3ZU1SYaoZkdGuRlpw2LA/hMAq0DgRi0Pm4V/RMHqq2PTQYqBnqhQX5Rcix1Mtf+nBhqprHr2W411QwVEzAdpgZn28RgWT7cGUQr63RosouLzakB90fEHuPaH9pjohOWIDNeOmrqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 09:20, Baolin Wang wrote:
> 
> 
> On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
>> The existing code is rather horrible and already resulted in bugs in the
>> past: we special-case UFFD inserting anonymous folios by grabbing the PMD
>> lock early, but ignore any other markers (guard, poison through uffd) that
>> could have been inserted into the page table in the meantime, effectively
>> dropping them.
>>
>> Let's just unify and simplify the locking: try to grab the PMD table
>> lock and if that fails, flush the TLB, drop the PTE lock, take PT locks in
>> the right order and check if the page table is still empty.
>>
>> We still perform the heavy lifting (zapping the folio ptes) under PTE table
>> lock only.
>>
>> Include <linux/hugetlb.h> for now, as x86's flush_tlb_range() macro
>> depends on hugetlb helpers. This dependency needs a separate cleanup.
>>
>> Both issues this fixes are rather corner cases. Let's not CC stable for
>> now.
>>
>> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only
>> mappings")
>> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with
>> mmap_read_lock()")
>> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>   mm/khugepaged.c | 64 ++++++++++++++++++++++++++++-----------------------------
>>   1 file changed, 31 insertions(+), 33 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index ce794d9760a87..ad07c8caa3bd9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -10,6 +10,7 @@
>>   #include <linux/mm_inline.h>
>>   #include <linux/kthread.h>
>>   #include <linux/khugepaged.h>
>> +#include <linux/hugetlb.h>
>>   #include <linux/freezer.h>
>>   #include <linux/mman.h>
>>   #include <linux/hashtable.h>
>> @@ -1832,6 +1833,17 @@ static enum scan_result set_huge_pmd(struct
>> vm_area_struct *vma, unsigned long a
>>       return SCAN_SUCCEED;
>>   }
>>   +static bool pte_table_empty(pte_t *pte)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < HPAGE_PMD_NR; i++, pte++) {
> 
> Using PTRS_PER_PTE to iterate PTEs seems more straightforward? Otherwise LGTM.

As I pulled this patch out from the stable fixes, I fixed it up.

I realized that this helper should likely move to some header later and be
reused elsewehere (zap_pte_table_if_empty), but that's something for a later
cleanup.

-- 
Cheers,

David

