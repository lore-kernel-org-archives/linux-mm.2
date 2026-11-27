Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C777606A683
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396646B05B0; Thu, 26 Nov 2026 21:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346B46B05B2; Thu, 26 Nov 2026 21:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236146B05B3; Thu, 26 Nov 2026 21:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0A086B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:57:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72F5E1A0157
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:57:38 +0000 (UTC)
X-FDA: 85479388596.25.9B3A7A4
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 947A81C0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:57:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795748256;
	b=m4N83oKM3M5GSL8dCh4FcHmt/16mY+4A4ZZSpp8FCba+/dMVlXfDEmySC8Y94oTCJAaQ+0
	etm+g5YefCwV+G7nIR8fwUV4EHJ1V6hcVSaKL/M/X1fMT1SqmY3XyPdmPvW1Olp7c5mSPj
	5S1ENUbYWzIEAZW5hBh+XN3D9FTmMwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795748256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tg4qRfSFSCuwByGCIKkrRpncxEd/8U5VOu1pZIeOQpE=;
	b=UFzsH9fJ9YrzV6pgWsXiKJu+7MtkE45aqLGx8WjxEBpLQsz9ECFwY4ChJLoE5suO10nTk8
	fCyAtlZOOuyOBQmoyHLjOcEqQgekggroYXg1m44ZjvZecYdEJ+BfevyP1qV9TwjYf1F8Ir
	kDPR8139CBQdUKorag6/pL2/H/IkBqA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 465e87ceea0e11f19a56ed5b684f684d-20261127
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_MAILER_MTBG, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS
	HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED
	IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:fe400225-ab86-4ed8-86fc-c3217e05a7cc,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:fe400225-ab86-4ed8-86fc-c3217e05a7cc,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:afe9f5a28457039939e8bb79c194937f,BulkI
	D:261127105729JSGRYN6M,BulkQuantity:0,SF:10|38|64|66|78|80|81|82|83|102|12
	7|153|841|865|898,TC:nil,Content:0|15|52|99,EDM:-3,IP:-2,URL:0,File:nil,RT
	:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP
	:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 465e87ceea0e11f19a56ed5b684f684d-20261127
X-User: lihongfu@kylinos.cn
Received: from [192.168.43.7] [(114.246.238.190)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 2003433835; Fri, 27 Nov 2026 10:57:25 +0800
Message-ID: <411be3f3-4b35-4bd2-bacc-af5596aa98b3@kylinos.cn>
Date: Fri, 27 Nov 2026 10:57:20 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] mm/hugetlb: free surplus folios of other nodes on
 free
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dave Airlie
 <airlied@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>, Wanpeng Li
 <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>, Guillaume Morin
 <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org,
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>,
 Hongfu Li <hongfu.li@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-5-db27fd2f71a8@kernel.org>
From: Hongfu Li <lihongfu@kylinos.cn>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-5-db27fd2f71a8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 947A81C0003
X-Rspam-User:
X-Stat-Signature: 7ierq3sqsr3mo53ozcwehzzqmapzyawo
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795748254-967606
X-HE-Meta: U2FsdGVkX18TKNzVNAXrGpJHkxvg9bftCaYu7IJttzwHQcSuxUjnEiLtXvrWf8zez4kHlyOFrTmaGJKgRN9I4dEgC9aG6HGsL5W/j88ep13YvU30gtP7vOuW9jucfvKHOYcQrbL/7nVWALHvRjwJzMw1fdzjFje2mAP5VvG9y7pz40uFilTm8DuOB+t6DX3Pjqt12kLPJk2bruN/9Xn8gEjC6SutOZl4iibp2Iq/LULPCpEZVoJDwa8FTUeIpB0ur8+XILecWU7LWb5h1iNibbte2M7tpuwqrgkftZJaPwsXTHR3budA9bxKrzDKqT39MAqfYbI4xsdVCrEuFHZyb5GWb+zYc70i7EU9euQYKmELDeIYHPotQe3fgURsATkexAMpQ8dgmr7Ji/R+N40mYPOfcMT6quDqJbrRBo/P+TdtqWyj7LHV0fc25uD3S4HS+Bq39ll38M3jH58NN7bJqXz3tjav7uFfmGtdN6OllqzlEOAlgnWg22XJscxeLiUv1kbvOUXEiTEoBHzyOB8kedp6zNU5aAOFAwanQ6jdvC8wduvOYy+ZOIrrrr++Mw/88eyHfmDYX86lF+20pXHZW76kmHFif+1ZNBwOSpyjuMZ+i5xw17oojGq8QBKtEueMszrsod/iVz7x5d15vgXp8f/MNEgbA4l7RlgPnQ/nYWzsLlVwtCkRS2FpGQnwixDJ1+f2G7OZBX14LE02KtNLKRL2IysLiSG72iQbQ13ltg5lzw8xKPBfTzaDhgo4RgA5EOM7d4kjRABsNQE8A9jpelvzUPw0n5mrmT2z0EeqBNiZNYyO7fHStrqDZzlWwYTzqjjE3w3olSryABMpTH6Ax6ppZGUH2hndWT2fKQSZgB1hGrdwiupnGU7m9ZNzHNHy9Ys6NMHiOdOUgdynEJ2A76w4ww113bSgV/QydizksmnEffxL7IGB+c+mlbomLnaWqUzdYBCjN3y89NqcIA5
 kjcxY1Qd
 Shryw5ci9zJFeV3QGd9xei7mntAqXrQyNxexmyhwuQln/rkvFD+0e7YarKLp0wak9jC14u5SnNfnAElB3SUvqVzcNlXD7ZVec3I0OaK6G9717SyLuo1Kji8jB3Qu0kT6aV913zmc+TbUjVgTyBwqXh3gqNCbcUXYO2WDBa1qRexGK+1NFNMMT9SbvW1b2Gz007hVWGuTh/dzcLSzpKmWKf8FLMUjsoUaFaEaHQec3UjlkfsIFrslRvelUFpRK9z7KCio+jjGofCVwrpsasJgXvvsTSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 11/26/26 06:33, David Hildenbrand (Arm) 写道:
> Surplus hugetlb folios are accounted per node, but reservations are
> global. When free_huge_folio() frees a hugetlb folio whose node doesn't
> have any surplus folios, we currently keep it as a free hugetlb folio.
>
> However, we might then have surplus folios on other nodes that are no
> longer required for the global reservations.
>
> This can be reproduced with two NUMA nodes, nr_hugepages=1 on node 0 and
> nr_overcommit_hugepages=1:
>
>   (1) Allocate the single hugetlb folio on node 0 from the pool.
>   (2) With MPOL_BIND to node 1, mmap(MAP_SHARED) a hugetlb memfd that
>       needs a single folio. This will reserve + allocate a surplus folio
>       on node 1.
>   (3) Free the folio from (1).
>   (4) With MPOL_BIND to node 0, fault in the folio of the memfd, which
>       consumes the reservation and allocates node 0's free folio, and
>       immediately punch a hole, freeing the folio without restoring the
>       reservation. Node 0 has no surplus folios, so the folio is kept.
>
> The pool ends up with a free surplus folio on node 1 that nobody
> reserved:
>
>    HugePages_Total:       2
>    HugePages_Free:        2
>    HugePages_Rsvd:        0
>    HugePages_Surp:        1
>
> Let's fix it by freeing a surplus folio of another node when
> free_huge_folio() keeps a folio whose node has no surplus folios, using
> the same rule as for the folio's own node: the free folios cover all
> reservations without it.
>
> With this fix, the surplus folio is already freed in (3), as the two
> free folios then exceed the single reservation, and we correctly end up
> with a single free folio on node 0 and no surplus folios.
>
> Note that the freed surplus folio might have been required by a task
> that was bound to that node. But we don't care about that: reservations
> are inherently not NUMA aware, and anybody who needs guarantees on
> specific nodes has to preallocate, like QEMU does, for example.
>
> This has low urgency.
>
> Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings")
> Cc: <stable@vger.kernel.org>
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Tested-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Hongfu Li <lihongfu@kylinos.cn>

> ---
>   mm/hugetlb.c | 31 +++++++++++++++++++++++++------
>   1 file changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c67f9bc3fa3bc..0f3db932266d7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -142,6 +142,8 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
>   				unsigned long end, struct folio *folio,
>   				zap_flags_t zap_flags);
>   static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
> +static struct folio *remove_pool_hugetlb_folio(struct hstate *h,
> +		nodemask_t *nodes_allowed, bool acct_surplus);
>   
>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>   {
> @@ -1760,6 +1762,7 @@ void free_huge_folio(struct folio *folio)
>   	struct hstate *h = folio_hstate(folio);
>   	int nid = folio_nid(folio);
>   	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
> +	struct folio *surplus_folio = NULL;
>   	bool restore_reserve;
>   	unsigned long flags;
>   
> @@ -1808,19 +1811,35 @@ void free_huge_folio(struct folio *folio)
>   		folio_clear_hugetlb_temporary(folio);
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
>   		update_and_free_hugetlb_folio(h, folio, true);
> +		return;
>   	} else if (h->surplus_huge_pages_node[nid] &&
>   		   h->free_huge_pages >= h->resv_huge_pages) {
>   		/* Free this surplus folio that is not required globally. */
>   		remove_hugetlb_folio(h, folio, true);
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
>   		update_and_free_hugetlb_folio(h, folio, true);
> -	} else {
> -		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
> -				    -(long)pages_per_huge_page(h));
> -		arch_clear_hugetlb_flags(folio);
> -		enqueue_hugetlb_folio(h, folio);
> -		spin_unlock_irqrestore(&hugetlb_lock, flags);
> +		return;
>   	}
> +
> +	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
> +			    -(long)pages_per_huge_page(h));
> +	arch_clear_hugetlb_flags(folio);
> +	enqueue_hugetlb_folio(h, folio);
> +
> +	/*
> +	 * This is not a surplus folio on this node, but we might have surplus
> +	 * folios on other nodes that are no longer required, as reservations
> +	 * are global and surplus folios are per node. So free another folio
> +	 * instead.
> +	 */
> +	if (h->surplus_huge_pages &&
> +	    h->free_huge_pages > h->resv_huge_pages)
> +		surplus_folio = remove_pool_hugetlb_folio(h, &node_states[N_MEMORY],
> +							  /* acct_surplus= */ true);
> +	spin_unlock_irqrestore(&hugetlb_lock, flags);
> +	/* We might be in atomic context, but freeing might need vmemmap pages. */
> +	if (surplus_folio)
> +		update_and_free_hugetlb_folio(h, surplus_folio, true);
>   }
>   
>   /*
>
-- 
Best regards,
Hongfu


