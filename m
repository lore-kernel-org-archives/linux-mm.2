Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4595A606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OmJvHkyF
Received: by kanga.kvack.org (Postfix)
	id 4E9316B05B5; Mon, 26 Oct 2026 23:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499FC6B05BA; Mon, 26 Oct 2026 23:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388FE6B05C5; Mon, 26 Oct 2026 23:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1410F6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:06:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0282A0969
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:06:52 +0000 (UTC)
X-FDA: 85366919064.03.5222A42
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	by imf08.hostedemail.com (Postfix) with ESMTP id EEAC9160003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:06:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OmJvHkyF;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793070410;
	b=jvVlCzU6fseUfwDTr74ZZZH3v2KYk5I5YCFfbuuaJvXZI+C+lmYF6mm3SitV3Te4FKmMb9
	S0hlvZnnC4bxNPULq07CDIZdMomMsNOCQ6bLlf4FYMV4eCHzkN5j0BD3FXWG89A8EGtgT5
	+nZk+y7XUmZFx1LG3qRiK1JIpdvuZjM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OmJvHkyF;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793070410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfiBYouQ7SUxOIRjsg6uwpg+DvPUrarmQVPVZOSrssU=;
	b=6HNfrW35qiJ6C9CsM2Vn+CxixPRw2EE6iglI/2KceYut7TzvtvrNFAg6LjnC+k5VkR2ZN4
	la1+1PGtXNDi4TNzRLSqAvHTFuXhAHzr041yE2rZEfNgyoJ7wrwf6d1hqN0+vvg41XSi+N
	4vWp4wuDF41PFf6bQsdKzxwwPBgT0V8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AqI8n299OICKahJhyCKFqs0u3m8/ZWmCuQo8Rk556kA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793070407; v=1; x=1793675207;
 b=OmJvHkyFxsfeKypToUZ7LSGC2sUxdtwI3R9o6a19BnFlQ/VY2YusuFobH1ESXjXmdW4D/0v1
 2U+cDF/TlFIvOXWIa+BCKSj8lSkeCR2P5jwvU83YvE2C4LcKuDnPaa1N3Qp/AhtOyPyWtF6jp0r
 X5a1YWHseL+TPDdj7Y10H9cA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fa452c266040fd6e;
	Tue, 27 Oct 2026 03:06:46 +0000
X-Mizu-Trace-ID: fa452c266040fd6e
X-Migadu-Flow: FLOW_OUT
Message-ID: <b0f16e9c-691a-4ab1-9ac4-d76b92c58b60@linux.dev>
Date: Tue, 27 Oct 2026 11:06:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/46] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EEAC9160003
X-Stat-Signature: qfm7dtajjpxkzxkqfk1upxf66n6czqgd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793070408-803325
X-HE-Meta: U2FsdGVkX1/TE0LBl3MNgPDlWftk+U78LCUSPAiinz8LKxLNOE5CzMTQbLXBSPuWVEpz2S0QNHo69uWDLbw8BH+XJ1jTwubQ77a121KAk4ZzF9o+A8TrB4Hqv1XgmDEzvMDHVqUuA63HJ4axw68Iw3F6Y98jY1I/jL/65asrYn0xfzRQZ04Yk8p6WtwIMGp3+QEddQKfSZbaKhSO2PSUn6L7t08UH0sEJGfvk4feGeKWGAzCDS0UwNOx5wsYBwvh2XRReopRprd8AT7i/irDH4s2bvMJ1HaveFKyZtY99s7kW+myG5U68ee+UBq18igdznZ7Kf8mHCa6XM6jEizs6PtXD78fioCwtKRjXFL7z4uGw0HB/0r2pWi+RxJLBtqvIP+JjyqMQLhA1qvx3M6jb7JE+uJD4Ia37R9R6xh2zvMg/mGNJuF8dzFzShkSSmd63CCYVr2lZapWcGT1qTU+aY14IHpCdlziedSERtBkKNGjv6NeQ9y5JL7cbaNXyvZXwaG06eZs0IzK05DNS+RhdvSPmYNo3Ki8kod/n4c1CW23q5C60/7zK/WX4KRwUTvge/ag4LqfCmnvMzbv05z67LePJ1V5qZdIonmNjNHuEWFMNr2lAKIHk6neUuMACovMfCix3wG0uvm5byxczM1ztY3xse3Iezdf9ZIpVFm2rMBOB98Sb4Ar7LmDL4rTiZ7qwWCoSi6mlQkMlJC+lCJkkmJm6rrg7iMoAN6TDUvj3XjejO67JbF9E4LRGtjvoKNMai7b51yLRR+P8DFcne4UZoOmBoiOfwyecR2MSAQhJdBX6baushVNkK+6viNAiCek42IsB0IYIvDBs4FPepME7eYU4baFqS/GFa6rA8djUphIS3u5ZkGh2zpo06cZ1FozxuQuiCeTmvZXzgAUPGU6xuO9G+XPTZCSJpXVmT2gcVYp2bHjcs0vNsxDO5zjOLlN8nmrzaDfezfH8le9tT4
 CYfnl22n
 3wmqlOBvgMvoTO8cF0NK3wjlMq/6s3tt+CROFMJ8OL2P7iIXARq79Hw7WqtNqHv5OKRFxAYuzCzDaDwLBbh6Tw+pLssUL8+nbvtWLbliFalB2dCnj6mqXveNQ36Cab7tScvaLDJJFzCIqmBkC3QaFtt39+QLO3l9FZzdvzJTJOhDwUqrkg2KjrM1LqtD/oGM6MPgRv7jfcJKJtqT2MuCEIyrJWz4bXmhBBxZor5W76snxSDWYPB755RaFqJW0VM8CkQmC9j41kVn/xjheu7JTKbLMjzGEAgHTgpLEkjQ5c7jk89XDThUeJ5aoGTEcXGhBE6FcP6WAAyyy+Yu3kIuex/oOrqR/2+s+ed+P9K+vOlp0wqCupzcfsjnuvgXZvC9VGAjrMqY5rnh5VYj7jVYU+ptwqpKNq2+EXyLWeSZu/GzyxWwSF+TW7pX029iralbmlDnlSp6qDmif0hf7ufjOr1tKdzqGRfbp/x/t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 7:17 AM, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> __tlb_adjust_range() takes the size of the range which has to be flushed
> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
> and pass an unsigned long. Consequently, a range that is 4 GiB or larger
> gets truncated, possibly to 0.
> 
> On arm64 with hugetlb, a 64k kernel can flush 16 GiB hugetlb PMDs, and a
> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
> at least these two scenarios are affected.
> 
> Fix it by flushing the proper range instead of the truncated one.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: use two-tab indent, simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   include/asm-generic/tlb.h | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index fbe1114e9a443..3f4a180b48f3c 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -350,8 +350,7 @@ struct mmu_gather {
>   void tlb_flush_mmu(struct mmu_gather *tlb);
>   
>   static inline void __tlb_adjust_range(struct mmu_gather *tlb,
> -				      unsigned long address,
> -				      unsigned int range_size)
> +		unsigned long address, unsigned long range_size)
>   {
>   	tlb->start = min(tlb->start, address);
>   	tlb->end = max(tlb->end, address + range_size);

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 


