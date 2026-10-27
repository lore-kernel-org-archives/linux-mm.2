Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8873D606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ShPz/LB/
Received: by kanga.kvack.org (Postfix)
	id A3C256B05F1; Tue, 27 Oct 2026 03:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A145E6B05F3; Tue, 27 Oct 2026 03:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929D76B05F4; Tue, 27 Oct 2026 03:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB476B05F1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:35:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 017C3C0927
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:54 +0000 (UTC)
X-FDA: 85367597070.27.4D5670B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0816540003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ShPz/LB/";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086553;
	b=os1pz6Do9vhGu6F97jcXJx4EqPJ3ExM1vUxQxwCLTRTUfC3x775Xt/0yCmn/Ut2MvlsVOi
	JU4n+ILnZoV+OXW+7O6/Z32XAJ3vOxaAQS+c4GowqWGkViMRoU4ETcJ8LGtkk5RUyCx38Z
	dfzLGzGy1xK/no8Ojqn05SmINNKv88c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ShPz/LB/";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jc2ZtnsslhTBje2qQpVD7MrTZfTUlL74O4i/llDB/M=;
	b=CHZFbe1WSbpt+HpYNmngjq/bVT76qyx/zyAhTN6eo4M1nhvmTTKTt6uTM8oxrhu9gP3jeq
	2SUxl3kfnNO8y5Chqkt65E8ElpxdWfFusCh02gXsoxSdxToPLMxSI+dLll9xzHrWmio2ZJ
	rz7l/SXmqayBcTR1dycLWu3U0TImGRE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB8F81477;
	Tue, 27 Oct 2026 00:35:48 -0700 (PDT)
Received: from [10.163.152.160] (unknown [10.163.152.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 316693F673;
	Tue, 27 Oct 2026 00:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793086551; bh=n2WrtA8FsjLacOwP70K0qkcnkliELHh0b55ywQMgrm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ShPz/LB/JTXMSaXWoN89wpg1R0MFhTQ3+OYAWgQenVr07qFiwcr+BtH2v6xKKQfRM
	 QrYTx4Q3mPU1qcZAPdg41yN63hG8hPH4qkEAk45cxkJ8LLmOSK716gyfQv1IvIJqjZ
	 R/89T7N51QEEo+TuFrpiXNQLA0t0iBWtwxXvK0jA=
Message-ID: <21091d4e-0afb-4b5b-84ac-b36bac58e40f@arm.com>
Date: Tue, 27 Oct 2026 13:05:27 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/46] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0816540003
X-Stat-Signature: e3c8qnus9hp7dbzhzq7gf6o1aeyetju1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793086552-743909
X-HE-Meta: U2FsdGVkX1+wgrNmJgG3x6ZBN/xSK6JUlezju9ZalC7jCqkpex1klGmuXAbp6Hpiad1r401dTy/uHUrCmRITeEhaloTMvzUAIS6niqVRX5urPDN3KiunIQ7ugUNA/bN3EILhWluoclRLN/DLzTYBSJPk1sU/6SWwlToRuX5qLqn46ijegDvoS8vsMJ1KkW3Dc3ZZwQgK02xyLG4ATfk7ms75t2+3WSXLFXiy1RyTxTd++6WYr+rRWG7Z6qqp0YOVVZ1/5V02yt977hNQh0zHX0/p2lZz28AI50VCaVmfscHwIHdNuS9ZUdvswAIi0Dp1cWL5hXjhYJV0/Tv/d9Cti4sb6V/rgsGM+8Al8paWkiSyyRt7itaQDrV5T4uD9zZXCo4JCNWXPPgGbBjLPwcjBTaTUmBIxyOzCEQLjBbG9e5UnBvqCVz4s0CRKZp+zNTWvrGPHiVtF+Vf0HnQrIh53RI+8g2BL4ZoIYdhMuU5VJ3D4ZzimcTZRrTS2E3lmYlW+/PGZgCCWo45Fex7d3a/ICHl+4ssHc975P7+qFWIobvt6WAgdJ4R+Y3zlzQLj/HklFHS7tRzNuSho6ZOo6m/bmEm9Pay7FdKjd7EOluBVgcY7QkK8Hxl2d6RktL/CeFuPF5FlT7RA18BxqxC7rLdIgFp1EtbA+bGnK3bZ5V+qzXkoDWoaYGErI/sUc2jGlE0Hh2oOiuLoM0anXT1PtoXjiA1UB64sMaNTcH79MdTcQ/Aqu1Ot8j2JRAAuvhiv4ZiYDoLh2xMycuZPwIS/jg2DBxsIKYzlbV2k05vIuFCB0jtUd2mI4+BsCVwpCCaMT1yUFP4LWi6k9rtv15uQlRXSlvTjfthzsSj7gCvZQkFDCkeUZbOWjhjDIYveI9Vu8AbIC3FURudoso1nkjYCM0nyhUDEOdbZB6W9SAIXZbjHC7kvg+Cwj38OhFG/sMZFZ4H4d4j+nrp0qQFI9C/UAE
 GGCB+MV8
 W3xLfdeu/ciUvyoEb3b/YiXY6z4PBSk/0GKaJO+oe4sk56Zno82WcJXClml4N+iNMrTlhPMuG6EFDqNXv1Hmlo9qVafRUUFlvf9CjxXpIvf43WetDEJqggSyCpIJ+dYr6Qkxdq7bRMAN4jG8EuEu/mPdzNGhWiQ+tQtQkWAiH7hiorkxNObghvHS3zy6ncnHGtdKMdqgBQs5VDGFI2JGCzY9D0wj+V3+5f4dGx0o71haJ0LFBs0x4NNfudkLIF61HgSa+cbZpL53BTvvcJmRgtRjhXXmNsnM07dgbcaj/9T0oa44SVsp5u+ncxlGgoDV3xtLT2OB7EZu+LWQ+nDtD+Bovj/39G3YvH78VKCr9DjpbPRVQy78z7OVf0j0Q84iCllBvpnY3PnucK13bdx5mtez+XqnVtnc1+L9y4sDvhVKUXRkg4IYRvKd63v6HzpOFWvQ2wSNIt8K9zZNT47dbEdevpMhY7fHyVkl6Hbb1euCqIzi8oUwVLY/yfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 27/10/26 4:47 am, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> __tlb_adjust_range() takes the size of the range which has to be flushed
> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
> and pass an unsigned long. Consequently, a range that is 4 GiB or larger
> gets truncated, possibly to 0.
> 
> On arm64 with hugetlb, a 64k kernel can flush 16 GiB hugetlb PMDs, and a

Nit: this wasn't obvious to me. Better expressed as:
"a 64K kernel can have 16 GiB hugepage mapped contiguously at the PMD level"


> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
> at least these two scenarios are affected.
> 
> Fix it by flushing the proper range instead of the truncated one.

Nit: after reading this I thought you are passing some other parameter now.
But that is just a type change.


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

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  include/asm-generic/tlb.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index fbe1114e9a443..3f4a180b48f3c 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -350,8 +350,7 @@ struct mmu_gather {
>  void tlb_flush_mmu(struct mmu_gather *tlb);
>  
>  static inline void __tlb_adjust_range(struct mmu_gather *tlb,
> -				      unsigned long address,
> -				      unsigned int range_size)
> +		unsigned long address, unsigned long range_size)
>  {
>  	tlb->start = min(tlb->start, address);
>  	tlb->end = max(tlb->end, address + range_size);
> 


