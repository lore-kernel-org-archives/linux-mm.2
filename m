Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FB8CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448F86B0005; Fri,  5 Jun 2026 14:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3296B0088; Fri,  5 Jun 2026 14:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A916B0092; Fri,  5 Jun 2026 14:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19BBE6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:03:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3BCA40266
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:03:23 +0000 (UTC)
X-FDA: 84846631086.04.E86EA70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6FACC0010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:03:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+e1iPjf;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780682602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGzu0aXe6HFW26JonkhpJzsdo5T0zMBSmF+3OrFmmlw=;
	b=3YEhd6qH5cr1/eoJwPM2OftKHy6vDRK0O0n0Vbo5CEDFt1dYvhdDdX7dxC23VF43FmLdM4
	0Yr4AzUp13DncrvNWTp6DN+teN4JjpSRgYeP18C+URCtigwB+t5KIP7xCjqB2c4/hxyAKP
	czUK1eppjJvSgihDAmLMHX5o4BBQa6g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+e1iPjf;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780682602;
	b=W64tmiF7JN6O+x2ths0lohZteoR9hu15IxkzPREdrHUdr3G1Tw6Bq9xvcwM8S8DdXH40ij
	7qFPLGGotMqWp05B2NxHWYuVqp43VTK12PYM878Hs3psJZDncpJy/8aqFYbb7kCdyqgwCh
	Oyb2DZ0Oh/rlzTaSluiXK4T/HlOvpdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0AB340A3D;
	Fri,  5 Jun 2026 18:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDA81F00893;
	Fri,  5 Jun 2026 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780682600;
	bh=PGzu0aXe6HFW26JonkhpJzsdo5T0zMBSmF+3OrFmmlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z+e1iPjfg+9HqlR3h8DHfBgPQRE68RxUVv8D1XNuenBu9ZF2YKFA1VjR+VhNGmsjH
	 GFEsnohYRLoqPHInWHvAv+Y1P65hv1c/MMrxJSbBN+yOfJqPCciWJB5eDfz41GF86T
	 qMqtn3TPL6lAtshubXlzylKeK/mZnTMTuJ8OreQfyscHUNmR0JCN2NxoetsjDP9SNX
	 z6t2qhgbRR6iVRlYl5H6U92DpJ60wb1xEgXi0Mh5HIK/ZHtPmOapC6wlHz+l+codie
	 TgFnFCzdg4BQYDwbENybXouCX/1iPohb/lA5DoazHpV+yJs7xg5DN0jxXw7ub4HMGJ
	 C0hR8pP7Fim6A==
Message-ID: <d1f8ce4d-d4d8-4776-a9e2-de394dc81f63@kernel.org>
Date: Fri, 5 Jun 2026 20:03:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-12-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605161422.213817-12-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6FACC0010
X-Stat-Signature: yr5gjykgctgai7zebpetbejfz76nhoxy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780682601-845593
X-HE-Meta: U2FsdGVkX1+RkvVMp1rM3opzvlGE7xLQFMi7y6fwXAOLlZFzZ1PYSFOJrLwL2xHa7482iWP9flc6+udPhC3jMk2B8at9SO6YnLi86et3X6NzMHZ6SD6xjoyFMlG0YjjF73GJoWXjtdJzDZz3U0q9NmMeJTUt41wwljsdNJtH9iXhleDPDyx9V1N8Xl5XqiBd66n/MfZsovRbUs8ShWbmvfkPGDj9PsStLSNmwoin0xjq3cfoF04HfJ2JIHnw0w0UGTXrTGsVSJLZVvDAk0iiC+1d819/Fa2/uf0pZJiqLJwI6tOd4q2dau6JvlNH9MkG1Clnw/v12txMnxyiodk/X+zK6chmuZ/wOK8RCt6GKqXMI2ahKRKX+jQGbwCL4ZTan8nRNQEpMio68LU8zcbg3bB4LGe2qRrKf8iaZdVy8dz4w8n9R9evvdNogHLARMhjYxKA9H9GHABjfXhWm+TmF8pBNnoouO2dwQ0zqwX+Ol/8I0jAPyALzGFiysK2VLzM5Wo/YNCV/MxWm0XeHfwVcvXrNY3/5hfsHb0ntOhhRrm1bd+ecS7L6BrQ9cr1KS5ONVB2u3tGXoUk+A5GGUgE31uUauA8WUHNj7L3Uy/+E5vlQk2wwMpsv8lrAg98pb6y9pdDubWg4JyeHSmpOsu3Xe6s3ioPLs3jgrQPjMD4D0FamciAR26CkPnE6CGoJ/6hiT/XdNcLaYEdPxGIjn/Hg//MhjE6OKTKNPBmCl9QZgbghDHfS7U71ALaZCxFJCEnPhFDEhCoMJblwmw/zu51MBS7sTNRUIn4pY4A071dlOUeQmEaR7Ou8Bxw4r2U7SwaUtGptRrk68VoL2J9QHm3ymoMBlAC/oRvO7EwehNJSxJHNuSZFrJIFeuYEj6vVkdhbCxG9ddKj3Yyw5NJIvHnkThBy0vYlGCxjIv2Td7BHb6E6+3mMldDF1cyEpCFaDSigjIACN6I9B/UHNJIM49
 oCJSentP
 4P7iHzGGUnmHD4pxjG9tBoP9QAqN8PgappM9/ttAQ4fw1LvDYdpXctc67baOjAkcDdPTlIkSGfs0cums5Vjah64wSIx0qrNhXqY+ja9PJ6bo8aUSHnmSZS+1Rl2bnvoZ6RdumuHIdSbfTkBQHxuShClT1w1/+QgRjdAyCT5X+fDV8dNoCbyoZP4pjX7B/rnoZ4mLcWu4DRjSWpOU8rA5vRUO4HMUi3OkX6nbUTjepA0GmpEDKWml4ve+R1gLf+E1UOTfR1OwEWi0Mp5pfQRabktNGn5pgihWW1LK1axBkBRnjx8NWNWDk8xPnXPzX586r5F1kZ7N/9OkTMjLMIyHXDaeixSXpcf7EBax94Mi/f2fYU6Ack7T94WCP1VDkfrLXS0N4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 18:14, Nico Pache wrote:
> Enable khugepaged to collapse to mTHP orders. This patch implements the
> main scanning logic using a bitmap to track occupied pages and the
> algorithm to find optimal collapse sizes.
> 
> Previous to this patch, PMD collapse had 3 main phases, a light weight
> scanning phase (mmap_read_lock) that determines a potential PMD
> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
> phase (mmap_write_lock).
> 
> To enabled mTHP collapse we make the following changes:
> 
> During PMD scan phase, track occupied pages in a bitmap. When mTHP
> orders are enabled, we remove the restriction of max_ptes_none during the
> scan phase to avoid missing potential mTHP collapse candidates. Once we
> have scanned the full PMD range and updated the bitmap to track occupied
> pages, we use the bitmap to find the optimal mTHP size.
> 
> Implement mthp_collapse() to walk forward through the bitmap and
> determine the best eligible order for each naturally-aligned region. The
> algorithm starts at the beginning of the PMD range and, for each offset,
> tries the highest order that fits the alignment. If the number of
> occupied PTEs in that region satisfies the max_ptes_none threshold for
> that order, a collapse is attempted. On failure, the order is
> decremented and the same offset is retried at the next smaller size. Once
> the smallest enabled order is exhausted (or a collapse succeeds), the
> offset advances past the region just processed, and the next attempt
> starts at the highest order permitted by the new offset's natural
> alignment.
> 
> The algorithm works as follows:
>     1) set offset=0 and order=HPAGE_PMD_ORDER
>     2) if the order is not enabled, go to step (5)
>     3) count occupied PTEs in the (offset, order) range using
>        bitmap_weight_from()
>     4) if the count satisfies the max_ptes_none threshold, attempt
>        collapse; on success, advance to step (6)
>     5) if a smaller enabled order exists, decrement order and retry
>        from step (2) at the same offset
>     6) advance offset past the current region and compute the next
>        order from the new offset's natural alignment via __ffs(offset),
>        capped at HPAGE_PMD_ORDER
>     7) repeat from step (2) until the full PMD range is covered
> 
> mTHP collapses reject regions containing swapped out or shared pages.
> This is because adding new entries can lead to new none pages, and these
> may lead to constant promotion into a higher order mTHP. A similar
> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> introducing at least 2x the number of pages, and on a future scan will
> satisfy the promotion condition once again. This issue is prevented via
> the collapse_max_ptes_none() function which imposes the max_ptes_none
> restrictions above.
> 
> We currently only support mTHP collapse for max_ptes_none values of 0
> and HPAGE_PMD_NR - 1. resulting in the following behavior:
> 
>     - max_ptes_none=0: Never introduce new empty pages during collapse
>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>       available mTHP order
> 
> Any other max_ptes_none value will emit a warning and default mTHP
> collapse to max_ptes_none=0. There should be no behavior change for PMD
> collapse.
> 
> Once we determine what mTHP sizes fits best in that PMD range a collapse
> is attempted. A minimum collapse order of 2 is used as this is the lowest
> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
> 
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.
> 
> We can also remove the check for is_khugepaged inside the PMD scan as
> the collapse_max_ptes_none() function handles this logic now.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Yeah, overall much simpler and much easier to get. As discussed, we can optimize
this later to traverse enabled orders more efficiently.

> +	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
> +
> +	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
> +
> +	/*
> +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> +	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 */

I think it would have been good to mention where the check is performed for mTHP
collapse. Can be added later.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

