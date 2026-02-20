Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDA1C55184
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A058A6B0088; Fri, 20 Feb 2026 05:38:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D33E6B0089; Fri, 20 Feb 2026 05:38:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8CC6B008A; Fri, 20 Feb 2026 05:38:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79BAB6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:38:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 052415C909
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:38:30 +0000 (UTC)
X-FDA: 84464486022.11.36EDEA1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id F2E2D180002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:38:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771583909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5u3kQTrIq3O+jY5VJ1mU4yV9b3FE5af1/T9YCUCPeA=;
	b=p1ixoQmf5+C8Htbjlj9R5UgZpnlGtSpmdjnc/lze7cK4DxMWp299egGICGt6Ql2qw+bgmr
	qXGtcQEA1a+kdzExVTgBvk15H5Y5rOkmu6C7RBTwefEWEBO4j4/ZPRFR3uadXKNN7S04/w
	c22zRcvSObSDUinDaXL18cfz0aJGd90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771583909; a=rsa-sha256;
	cv=none;
	b=YOPe9D03myNzx12T/k9ERutreSkty7FQRGW3WqTZ3eBEBqHoJ+9rQ5zfhzxEoLVVV6c7JP
	g5+sUhG4xU9w4ylwdqEvQT4BtKpie88SCPPYI2G7itBBCgyrLujoTW6Fv76YGl3psPNGkN
	TKRxuyjXFwG4/48/P3M9a4MOyFpt1JE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64A86339;
	Fri, 20 Feb 2026 02:38:21 -0800 (PST)
Received: from [10.164.148.40] (unknown [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EB303F62B;
	Fri, 20 Feb 2026 02:38:12 -0800 (PST)
Message-ID: <784588bc-2071-4418-825b-9072cc3659e2@arm.com>
Date: Fri, 20 Feb 2026 16:08:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-3-npache@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260212021835.17755-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Stat-Signature: srenukbxwukuha54779uhsomfqtoq6h1
X-Rspamd-Queue-Id: F2E2D180002
X-Rspam-User: 
X-HE-Tag: 1771583908-261189
X-HE-Meta: U2FsdGVkX1/VkWgdnDvx15CaQLKYiv7AeFvHoEAe1Hm8uitess6IKCeNTGcbN2NqazHCwrqItx4UYVqVhV8sp/SwmDdtkg6+4lxDnG2X+ChPC1H2n7Nbo8UcGeJhDTeoi52MjTct84/GGyovS3kMW6CSdQqKJ4zUu9Kwq0Elgu2Yvf8v5rnayUUTmCr9w2n2CdH12ZbEr3Si4K7bTn4poqb7nVakt3RAnPBZ2hHV4jZvdDa84jwnDIH1q61i+ukQCGBOQa79t0ugPKWlqLeoFW9QP24Qzs+uv7JpJTXUnouXY9mkJdi5JPg5YCuCV3VY11BAQbkRx35Wl/mhghuYejknO1svkN33fuO0YyLQeHVYDhxJS9bRcYbVv6/dE9otfDcZCAbcM17T0blzKZYHtvJ9D+FfJWGc6sxEKr6RQwz3a8JrQaXOvHq+oZS/F6hQ6mZ/lYEUav+bpammiTT50m1znmkL/Sgs4vYOut5hCc3sAlhPFDwebmV4qgemu4+0VJ2jAOmlFvuifKeBD1GH4s0ASRXifBMiyqLuERVHgAvlHSPk/apyOST1gcEalWoSzm4gDVLJlixuWKzzCcNt7AdEMHqs2q7PmakI6vLKbwqdIa/mdAWX93Ch9gplCS3XiNgoD5odpvj2cuE+1OYCit3Ss5LQ/T6n5GuQhoFt0RH2H7L42Q1rBoAm6m7GG3Gv9ZAJEs/KFmZi2kMEQXQm5LJZxhZGnQGLC8eRXy4Dz0pYpWwle2Hnh6ew/VMbSXZjch3t5DIYf3dvZ4lFjs8bgpy5ok+MEItD0i56UaZcCjjFw0ogw4T5GzHw5KKLmGm88hKoK8i7jhi8Z+6oHGWhYAlnYISY5opEplWJxtV4yTgXGyER3HZRsA7ukoELkuObAsDfDb8xrLdF+6IpuwzmtF/udldGXmpVBF6taA7d3n6VaAZfViW1tYjwRVjJ80o8qS2C9fGMlNP1jobS90y
 J1MJXwmS
 n+xOh6vAGcVndIC9lQmw7VBgE+fgo73I04q7lppb1lqy/x0+eUNDK2hfZT0ctbkdVe1TyaZBH8w8Ao3aGpEYUI0idWtzvbJYFgEXlMM5xNWC4SYt0S3shSie7RPJhNlMnAA4lSTrwH5Wyk2K7haKWde1bSve5ZYn7SWx63F+1rTHiVBM1G3As286RMb4HhNT3xbBlyTrZ+kfkxSYvdXbvO5RlDNh7dI4Z4JQeVdMavJnEehS4u0weU5qtnWgIatH0foKWXJDg1HeRRpyJsk72k9+RUhrZ0Bk5nDRGgIEO54o6KcApKGdB3BfvdcpTtfNtwgLuM84HgCV4PNhT8B/SKS224Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/02/26 7:48 am, Nico Pache wrote:
> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
>
> arches#    pick b3ace8be204f # mm/khugepaged: rename hpage_collapse_* to collapse_*
> ---

Thanks, this is useful.

In drivers/dax/device.c and fs/dax.c, we have order == PMD_ORDER check,
not HPAGE_PMD_ORDER. Therefore,

1) Do we have a bug here, in that these codepaths are fault
handlers, therefore should be using HPAGE_PMD_ORDER since the
definition of this macro zeroes out on !CONFIG_PGTABLE_HAS_HUGE_LEAVES?

2) If the distinction between HPAGE_PMD_ORDER and PMD_ORDER is real,
then the helper should be named is_hpage_pmd_order?

>  include/linux/huge_mm.h | 5 +++++
>  mm/huge_memory.c        | 2 +-
>  mm/khugepaged.c         | 4 ++--
>  mm/mempolicy.c          | 2 +-
>  mm/page_alloc.c         | 2 +-
>  5 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a4d9f964dfde..bd7f0e1d8094 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -771,6 +771,11 @@ static inline bool pmd_is_huge(pmd_t pmd)
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> +static inline bool is_pmd_order(unsigned int order)
> +{
> +	return order == HPAGE_PMD_ORDER;
> +}
> +
>  static inline int split_folio_to_list_to_order(struct folio *folio,
>  		struct list_head *list, int new_order)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 44ff8a648afd..5eae85818635 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4097,7 +4097,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		i_mmap_unlock_read(mapping);
>  out:
>  	xas_destroy(&xas);
> -	if (old_order == HPAGE_PMD_ORDER)
> +	if (is_pmd_order(old_order))
>  		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
>  	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
>  	return ret;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fa1e57fd2c46..c362b3b2e08a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2000,7 +2000,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		 * we locked the first folio, then a THP might be there already.
>  		 * This will be discovered on the first iteration.
>  		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> +		if (is_pmd_order(folio_order(folio)) &&
>  		    folio->index == start) {
>  			/* Maybe PMD-mapped */
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> @@ -2329,7 +2329,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  			continue;
>  		}
>  
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> +		if (is_pmd_order(folio_order(folio)) &&
>  		    folio->index == start) {
>  			/* Maybe PMD-mapped */
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index dbd48502ac24..3802e52b01fc 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2450,7 +2450,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    /* filter "hugepage" allocation, unless from alloc_pages() */
> -	    order == HPAGE_PMD_ORDER && ilx != NO_INTERLEAVE_INDEX) {
> +	    is_pmd_order(order) && ilx != NO_INTERLEAVE_INDEX) {
>  		/*
>  		 * For hugepage allocation and non-interleave policy which
>  		 * allows the current node (or other explicitly preferred
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c2e96ac35636..2acf22f97ae5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -719,7 +719,7 @@ static inline bool pcp_allowed_order(unsigned int order)
>  	if (order <= PAGE_ALLOC_COSTLY_ORDER)
>  		return true;
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (order == HPAGE_PMD_ORDER)
> +	if (is_pmd_order(order))
>  		return true;
>  #endif
>  	return false;

