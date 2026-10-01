Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF4DCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 14:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7B46B0088; Thu,  1 Oct 2026 10:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8559E6B008A; Thu,  1 Oct 2026 10:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E076B008C; Thu,  1 Oct 2026 10:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 563486B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:43:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6B0A160443
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:43:03 +0000 (UTC)
X-FDA: 85274324646.23.697D142
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A8E716000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:43:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ATQ8I74B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790865782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mE8ugBn4aBPJ3MiNkA50lNnSRYdI1uITSgWQ30TMfOk=;
	b=u6w86xrbvhhLeHnYj56BtxL3HZYyn5If9QIons6VM8KCHDZcKaMYnOUo23vriUr/lHjneo
	9OS+DUhCBEInRpvXuHNBsd/Tf4yhKIr2Sxd7dCpIzmrVlwRqV/ouSGZjXXl+ZpGXpc0eIS
	iVt59a28K8rRwmXpN9f7Fw1/kNlu2HY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ATQ8I74B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790865782;
	b=NKdJF2DaPQiA7uBrbPh71UiDSBma1XXjd97y59JCkHQdHSa1caFLV17jig+WfME+PXBuWt
	SPGj6ZieNsAM9w7rd14Xy7xCrS30dyYTI1JVlSZ5Zm5jILZ4k/7CUKC0mz1Ck17u8fHPzh
	hmt+VS3sDvRAuycnrxnAGtJnLWI9n9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DB916022E;
	Thu,  1 Oct 2026 14:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AFF1F000FF;
	Thu,  1 Oct 2026 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790865781;
	bh=mE8ugBn4aBPJ3MiNkA50lNnSRYdI1uITSgWQ30TMfOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ATQ8I74BR/BF6dUU++SXaq7I6Ck1VUK8xU6ciYD+3Yq9OVtY7acRBm1+vz/B65lHl
	 DF1YRe85C4R5RAMbAtbtHRrR80IEigqMuLFCyhcR+AaFk1VSlQYZZu5BQrNbBURuMG
	 syBdLUPqfXrl80oACFAlymuTJazq0Cmj7BieKQYbiPoqoedYOIm/PDYpnFoe8B0WJn
	 z84v0wjUNNjYIsznTbXcj79Q1zEf3omB7I/CvLt4BkMPUk1Kv0LziIJUwOuu5NevHH
	 aHlJHZZutXIab/4oxymEt5BTLNWAW1l1MJHo/BdxL+viezsQ9ccvB921pMRlzrwjff
	 MLpY18Z/6cO9w==
Date: Thu, 1 Oct 2026 16:42:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, muchun.song@linux.dev
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
Message-ID: <ar5xbQsUpSQZg0wO@kernel.org>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929053231.66085-7-songmuchun@bytedance.com>
X-Stat-Signature: znwzitstmjr5wjju5tnz6cwa89n6m6sk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A8E716000A
X-HE-Tag: 1790865782-963840
X-HE-Meta: U2FsdGVkX18U52aLCmA2LOQlrklhD7Ek+R59/mItagGMYQ8nlXZ3xHeJwo5Pw+pIkiwOwJ7Zbv6mi8JGVh6Z1rOFw+MONTfy8cMuJ0ocgZmLKnC0dQq4ngn8U/szY3c4MwB46yHsX4U+M6drPq9IupUMX+GnuCQwg29KVWHkHwlHmgeTu3cM2SIXU9lkmpHyINTgMzklO6SzvXqHk4tiyjsvRiIqT8fFDMX4jUOV2nMIbJ9017zZcO8lwr4Vk9TtMKZY0URsVvOP8r6vOSQ2whYFGHIPrw8x8+o6YQBZ+Rjgl3dpZwtFhBLWkQT0zHXgGe24WFmGUsKK3rGE/9Hzj5QLxAox+YbWd3uOLfY7WW66cXWGwDIZFwRPDmxxr81xKXROBDSj1RAGRrjPaC8ta2ygZUjWg59jf2rLuFzSXqILRiegEK2yB3wnpt7H6vvVSzLdnX12CNSDD0mFBWnxZ03As5aN3753NUm6SQy8eWTjsYNyG5akYCeRE7bn0Q27xZda01SEvzGTo5gwdEh/NzsXWCKOlNv6ACSqb/NmBg0RKAzxUwgeBgYkci6j1X78kMvN0Liq6hYh+sDVzcP1YtBtuGfvD6EU9QKfk4Ss4vWQvZwifJlnY6NOP2wa06RuWeXLqs4t+NgT5aVv2dZspU59CR1ObKDnK+20qWcrU5leWpN5ru+l3/5cHxLhPDQHgIFh3pGAOPRemEMCldwEh95XZ4a3G0QiV1wCSuSPAy3L1kR1OyJXt6qxrIdw0QdvOTdmP/EVIUB4VbkyjPur+uCycuR6F/dIbtqcfBch6RZ0lZipw6BmbFhjl8X/LBf1P7AJv3QBcBBaBjJOyE/dvk6mNaWTlAgsughQlAXOkuYBGxxC241SFWJZOzVkcHt19OkooWL2heKJMISvrV0nwxoxuubO3HrcW5VVnzJkqqKme/F5eWwgNz6Mtq5n26wCoicBUblJYy4UqQ2VBq1
 HdbTvunB
 lSeBUe+o4yvhfUne3m/ZOOe+fQ57ifEX7nSNTjM0xXBPcbGc66ujlL6YIirkeqYDiamYiyuHk+BADwwAmJ8GNcVun/Eh2Ukuvp12Odp9Y5PaViQZXzLvyGRm+OZVq2vKvJDbv7wugvhU/P515yWbHo4ky5qzgj72+XaHRzd0rVR+ird+Rov6Kf/czru2j4adOZVHI6aHzykRc/BHZx2HvA0l9kFbu14gh6+B7aM7Ns/APVoUtWFzWNl3AwyKou/F2HUs+5nQ6zm0eO3hhQO9BvVBqR6GEqst3wD6NXizZhdicIflF5FNNpLbEB5Y5+k8+sGWitESqUWOWsfm9cD/j3l/s9p6+UeIiR2VC56gjlB6nJ9Ly1GOc5Cqmq2u19TdRwHlYlzOLjXZ/1bIrAOAUl/0SiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On Tue, Sep 29, 2026 at 01:32:31PM +0800, Muchun Song wrote:
> For vmemmap-optimized sections, tail struct pages may be backed by
> shared vmemmap pages. Those shared pages must carry the same page zone
> ID as the struct pages initialized for the section.
> 
> Warn in __init_single_page() if the shared tail page has a different
> page_zone_id(), which would indicate inconsistent initialization.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> ---
> v3:
> - Collect Acked-by from Qi Zheng
> 
> v2:
> - New patch.
> ---
>  mm/mm_init.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 1650d6bc1211..bd02e8d06965 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
>  	if (!is_highmem_idx(zone))
>  		set_page_address(page, __va(pfn << PAGE_SHIFT));
>  #endif
> +	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
> +			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
> +			page_zone_id(page));

Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a tad later
than page so it'll have stale data in the page->flags, won't it?

>  }
>  
>  #ifdef CONFIG_NUMA
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

