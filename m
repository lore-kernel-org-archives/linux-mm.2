Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40864606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 03:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XCevM6i0
Received: by kanga.kvack.org (Postfix)
	id 279606B05B0; Wed,  4 Nov 2026 22:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229F96B05B1; Wed,  4 Nov 2026 22:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118A76B05B2; Wed,  4 Nov 2026 22:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1B6C6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:43:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 478891408B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:43:36 +0000 (UTC)
X-FDA: 85399670832.29.CB10320
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf09.hostedemail.com (Postfix) with ESMTP id 88DD1140006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:43:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XCevM6i0;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793850214;
	b=df8hwfcJX5V9JVr5BIruV5dqYVhbBdzb1O9ynnW7a/SUfjfnM6tOGOH2FKHh4mIrBvfBo9
	ikj2JF03GCNmE5EWi2kXHYqH4iIyqekneI2RAUerbHWkeUWYLBDrcUhXNwBSTKq0F/ogzx
	+W89noVCYrs+bURcreTpVWW6EQ1fZpk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XCevM6i0;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793850214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPL6FGJI6mYbfWVdagRDwQTQgREcZN8JpaFK/cgIs8Y=;
	b=mPI1cabr1EPvdYqabrD4mYntIpzhw3Rpm3J0GVTwcw6rYl0ZggnFZaWzHfcelvoGVyiEWH
	RWKoXMTuJ6Tntlf5TbOg35gSroMIlUkxi0pw9HbhFreb6IUFQAVgzXC/GZ1paLAMGQTdl0
	HGbX8vOK5Li+wgETM4TA2pwjeUVixvk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793850208; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VPL6FGJI6mYbfWVdagRDwQTQgREcZN8JpaFK/cgIs8Y=;
	b=XCevM6i0pje7urS0yRu8hs6ccSWgXhKWUrNSTJscVXRnD7c7hFWmNmYNYRyuk6rYtY2vpmwPsEbBA3JKSXOaY9KA6pPicWrECBRzWq4+1iL/msUYBBBaaxEcnoMQsdlYkFTT1Z4tPLVVhw8V7TH1YWxxLLUdEx8/vm4VxmbbsAA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=64;SR=0;TI=SMTPD_---0XE7Nmrn_1793850203;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XE7Nmrn_1793850203 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 11:43:26 +0800
Message-ID: <d0f78f0f-c883-4919-a416-fe738eb7323a@linux.alibaba.com>
Date: Thu, 5 Nov 2026 11:43:22 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/47] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
 <979fb046-32dc-4af8-b6a3-177c78f1e557@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <979fb046-32dc-4af8-b6a3-177c78f1e557@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88DD1140006
X-Stat-Signature: dosk7xz8oswpmqaziorboqy1qzcrdxwe
X-Rspam-User: 
X-HE-Tag: 1793850211-866280
X-HE-Meta: U2FsdGVkX1/7J2Qeoysr+3JdmzXvs20SQD1ABE/KeXibLJiSVgNT2ZgVPmK0lNQKlUMwrU6QpxCDHZO8drljNGudG5fs4Im/p55j7wPrR5gCnFQoYAEAd6z9gTf3mmpkJCtVtaVBlhh2vlnmELn309zrG8ZTLHV0dh0EBxPAP3S4FNfS+D4Up4rRi1oc04LOroHJ8XALWaEj+OX1toykqawqAWkEko+40eIo4ZryC6t5UV9cBSVu1GYV8K/jUCM+yG713iWJSUHNobw5DFvi/4ihCP3mq6csR+MJ37OD2Glgdkct5jMXUH7X8rlFNiHmp6PvsKcjZetdaohiANzfSLuXeODueOaj1ynUU6yE6PRQloTQFHSstHkVEWwPNEgziN1a3ATYzHjR/jVS6B0yOlEHUebQdXkjs4xlG5zqe/MT+aEdFBPRZmfugDQhjf3a4mldOvjPuuny3lqTuB78IiqYa9QfVCgfwHVghD2YP0eNOHg0uLT0/yYeWCyyzie7z126B2mPH4xUOvqafapP4gUn/bh/npJx12mj+ANaedpL0Cs33OIo1vjpwi+dSmZlPmyXt65ZPHhI2Bf3bQ7zm9ZR6T0TCSFdxZ4QgDmaeZN7n9aoDMm5s/NPNlqLqVWdAAc6xPMtIzzUBwu8zm5GHh105U2lSKQUB2KRzo4FztbykHuVtc5Q25nWAJJZO6KzdpspOY+nCRtZqU3Zs9z3H05/G5F2T7gvtezsFU8V6HenWYICMWlY/suhfUIdC5U5j+LzsnOU2Wj++k5VLP+8QuXs3dPyyvYc75nDC6SEPVQf+aA6mDQJj4jT7NixZYVry4S9Zvz09xV6nFXNcS0GlGSFm3uYK4DPeZOAmte9A1tpfg2kL7F1+FXQJKISTQTYG9lqdd1dsMseclMOm2+ZJbR7ZiAFWh7vrHqU0vNjjk8V2nYTxQwIfNDDyI65y7+xVh9eJPlDH/qU6mVFpYM
 TV8XzjSc
 sShY/lQy32wuDTfoTw5Yyl2lu7RS4ml/fePPF5KU2RIUe/7gkWUvVfEt/iV9J6LR9wNMul+s9ZGWL32DydbCzVal5SmuFpf5TzBrmTgZaN0cN4SAoeWtX/9sMFgns7tPxSHprtYhfI5QVOGiPquDM0n495kK4V9h5kh6c+d1dBmJjxgTElm7e4/k2uTDehbu3yYW4hQ5HclQmg7ENdTHNiVb5mMklwJ2OVxsMNEwScN9i2E4Q902F9siQlVubPqR6h3FXAqp1gBl1MJt/HoN5U4/G07AJkJNBPeX8z198DpLdTRLngpx0q853AErePbK6WcduPYD2x8/nsDh2j5F3SydwGInDURFTEutetrHpSmg8KC57Box284erzcVoUqf1wmO/y2YgK/77XVhQgzlTG2DqJyTHaZY9p37POxrGLdkEIMv1TVTYoZkBv2VFuzvy6qXrXpoELby8AII/wY/FfK72MRtJeAXrGfQlabLnsVbHFg9T9+MmwE2Wh4rxTZKifL77tm3GTzL5ITlQcGgb2zEtD1b4kHKzvHk15gWfyJz5w/nIXrISErrER3HoqwzbMjZELVhGwnaZDD0BK96LQQ1WuvbAVFLElRF+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/4/26 5:13 PM, David Hildenbrand (Arm) wrote:
> On 11/2/26 09:20, Baolin Wang wrote:
>>
>>
>> On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
>>> The existing code is rather horrible and already resulted in bugs in the
>>> past: we special-case UFFD inserting anonymous folios by grabbing the PMD
>>> lock early, but ignore any other markers (guard, poison through uffd) that
>>> could have been inserted into the page table in the meantime, effectively
>>> dropping them.
>>>
>>> Let's just unify and simplify the locking: try to grab the PMD table
>>> lock and if that fails, flush the TLB, drop the PTE lock, take PT locks in
>>> the right order and check if the page table is still empty.
>>>
>>> We still perform the heavy lifting (zapping the folio ptes) under PTE table
>>> lock only.
>>>
>>> Include <linux/hugetlb.h> for now, as x86's flush_tlb_range() macro
>>> depends on hugetlb helpers. This dependency needs a separate cleanup.
>>>
>>> Both issues this fixes are rather corner cases. Let's not CC stable for
>>> now.
>>>
>>> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only
>>> mappings")
>>> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with
>>> mmap_read_lock()")
>>> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>>> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>    mm/khugepaged.c | 64 ++++++++++++++++++++++++++++-----------------------------
>>>    1 file changed, 31 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index ce794d9760a87..ad07c8caa3bd9 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -10,6 +10,7 @@
>>>    #include <linux/mm_inline.h>
>>>    #include <linux/kthread.h>
>>>    #include <linux/khugepaged.h>
>>> +#include <linux/hugetlb.h>
>>>    #include <linux/freezer.h>
>>>    #include <linux/mman.h>
>>>    #include <linux/hashtable.h>
>>> @@ -1832,6 +1833,17 @@ static enum scan_result set_huge_pmd(struct
>>> vm_area_struct *vma, unsigned long a
>>>        return SCAN_SUCCEED;
>>>    }
>>>    +static bool pte_table_empty(pte_t *pte)
>>> +{
>>> +    int i;
>>> +
>>> +    for (i = 0; i < HPAGE_PMD_NR; i++, pte++) {
>>
>> Using PTRS_PER_PTE to iterate PTEs seems more straightforward? Otherwise LGTM.
> 
> As I pulled this patch out from the stable fixes, I fixed it up.

Thanks.

> I realized that this helper should likely move to some header later and be
> reused elsewehere (zap_pte_table_if_empty), but that's something for a later
> cleanup.

Indeed.

