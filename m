Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890CAE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 08:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA0B6B0088; Mon, 22 Dec 2025 03:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87C36B0089; Mon, 22 Dec 2025 03:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69F46B008A; Mon, 22 Dec 2025 03:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4C036B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:35:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3956E1396D6
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:35:01 +0000 (UTC)
X-FDA: 84246446802.06.93F14D6
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 52101180012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:34:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jDn+ac/N";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766392499; a=rsa-sha256;
	cv=none;
	b=v5KBcxADHy4+Svd9g/ZhPVDNOqNNQSAPaG1A84Zk4zNTCAH62Rr+qKNiMBuJOOgv05Hym5
	XtfwA8tAIL9IEQJiXewaJ3xYJ7BoEBsTotHVRcH4jZLrFLi7Jzebbq3R2ecE7C6HbPO0N6
	cj77VCp0d1EXTWkgW2xRjfZ+a7OW+lU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jDn+ac/N";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766392499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PRh51T16nCJuabLwN7Opr84pXwH4nCR12V2Dg0ZqfY=;
	b=S/0YAZeJcg6yOhcCs2o9TSyMg2ip6DuafxZcABlFrhmeQ2lv/xaQeOLE+GCyx1OjkmUXmv
	9G+90rsAlWz+z8PBKBrGLu4dUxUSwW+wQ4fJbCOBWdKU7Qjs7ffZjFncZSsGmCByaQ/YUu
	R+QT+sXkbq00rgEXsI6lc9LBhIMkVHw=
Message-ID: <430d554c-840f-4813-b715-5191d74571a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766392492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5PRh51T16nCJuabLwN7Opr84pXwH4nCR12V2Dg0ZqfY=;
	b=jDn+ac/Nr+VRGnnw5XTkr1JE4nLu78ku2s6wnDFuQAYHlvBnlSw8vDc4Y7yOIG4MRhjjC9
	+GGKlxU1W4OSt3feZKSYrOi0ZjJqNFJIpTOFsmC+k2KGLfCkjou1xH9z6Dogp6OuvjzSi1
	pmzmYW9QCsQ1ptZJaBi4BI4wZJNouYU=
Date: Mon, 22 Dec 2025 16:34:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-3-kas@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52101180012
X-Stat-Signature: u13gh3h687tbd4z3kft6wriwuc5soewh
X-Rspam-User: 
X-HE-Tag: 1766392499-678889
X-HE-Meta: U2FsdGVkX18zX9k+qVEMDt93xTyfPtqJmZx8TB0MUrT8FP2SNDgdcmjgUSvmeOtzekISL+zGUHM4HL8DrzI72GAM4+8V0Tt7Yqyd/v57NqIig8/mlutDh1QTUj54C6WhWmovBpXENZbWbq1J9X88rlVfO7DLa6Qo35zajCT/8wYlQfG30RQgjibiRrLKXXMFn9GdchP95b44AB7nf1jgc83GevCMbP2lhZzWlEekEgxmMpP1IrclqVSkm2kA6c1MfUS9HFWs55W1m2kA/uomqs/lv06Hq/EU7mp181ZydfIsmmmfUxbDEa16VGB7gkFVIIi5KhMRF3+OL9wBz2LtzRevStQ7OJDFd3pHOvmbswVj0w4vB+fNMohohXjegez0sxKM/aBzsk5gLA+JgGqGGt4CDy8ND2WmOunryBXhjO/6LtBWrbMGYMC68IWYE+d2AI82EQ2ZzQ+IGVTVcPJtmmq2Gdwlcpu3snjkip16sQBZXLXc9t+1ihkMWSUCuirnHTNrYzjdqywzoraw36gi0fclbB0S6VOOg6UfRSqyBEOIHjjvif9tCIjG1r/2XEZ2qM4duO4ixN9e1Euid0y/9PWjMtnuLw+4ZzVvhyvIoBp5LXNetubhg/QXTg+xku9X+R+itE4XGkI6aQxSjTFObtXlfLVv7nttZbPjztlsQudhiesB31+rPUjpulMZ6o4OBVa3+xlROiV/yJ2M63fb6JHSIQ9xXQVOS4uIXAZwnN8Ry4y+ME8FUC4CKY1Aev2DzBP208SwPGCgavZ4KNy0f+L1KMdUzwlvbXQyu+qMyndQ9KmluH9d1uQG5Ve0kEjZr/s9U7V9dkSaUzDs+pXUf76Qs0BR6/ly/qCYNO3i+W8woV0hd6UmQoCxqSFetKb/+Y1eFiTc3vmGJrsVmj6kfOqIg4FIKwA1U2VCcODdLgMITLnFXdRD3YKi5rK2ynaqyMyJfhpmJCRZtm4KKlT
 oVYTHSkK
 W2e4xhugq3mQc3lPnfoJ9vNj7yVO5bS800iz2Ri3FypkPLzlHwiJc1yliU4flAwcBDbywvX3Cka1lu2V9CzOt6XbR8VWK4vYTZSSGsLig82cPtVQP7aGaN2usKfsEIWdJNdF4qQaRgIddU93FO+3DAfyjXQoe6mAvoqUQa77VznPQNF4cfyLITqfutsmQmXoL2wFTWmplptw0DO5g7t/g6NtkFxzgLcJ4Cwzks8WyWW3W2WIH7EbCZtAKe1Q/GxLkfqchnD272Ht3nTdoDKAiLiWIZapibDhV2GHMT1Bj3Nh3L/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 23:09, Kiryl Shutsemau wrote:
> The upcoming changes in compound_head() require memmap to be naturally
> aligned to the maximum folio size.
>
> Add a warning if it is not.
>
> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> kernel is still likely to be functional if this strict check fails.

Different architectures default to 2 MB alignment (mainly to
enable huge mappings), which only accommodates folios up to
128 MB. Yet 1 GB huge pages are still fairly common, so
validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
miss the most frequent case.

I’m concerned that this might plant a hidden time bomb: it
could detonate at any moment in later code, silently triggering
memory corruption or similar failures. Therefore, I don’t
think a WARNING is a good choice.

>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   include/linux/mmzone.h | 1 +
>   mm/sparse.c            | 3 +++
>   2 files changed, 4 insertions(+)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6cfede39570a..9f44dc760cdc 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -91,6 +91,7 @@
>   #endif
>   
>   #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> +#define MAX_FOLIO_SIZE		(PAGE_SIZE << MAX_FOLIO_ORDER)
>   
>   enum migratetype {
>   	MIGRATE_UNMOVABLE,
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 17c50a6415c2..c5810ff7c6f7 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -600,6 +600,9 @@ void __init sparse_init(void)
>   	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>   	memblocks_present();
>   
> +	WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> +			    MAX_FOLIO_SIZE / sizeof(struct page)));
> +
>   	pnum_begin = first_present_section_nr();
>   	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
>   


