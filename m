Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A64A606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJisxV5H
Received: by kanga.kvack.org (Postfix)
	id 029916B05B4; Fri,  6 Nov 2026 02:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40EB6B05B5; Fri,  6 Nov 2026 02:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DD96B05B6; Fri,  6 Nov 2026 02:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF52C6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:46:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F42BA71FA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:46:11 +0000 (UTC)
X-FDA: 85403910942.13.DEBE54D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id A0DA140009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:46:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJisxV5H;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793951169;
	b=UG4hAnR+Uwxa8RRJf/suxQWNdgTtmK2RUPF4pXiPRjy88RYBo5NkL2CIRLGWbL23pB6QXa
	JKMehY8U3A/GMzZV0pD/Bwkl23vqQnxyOkw/y60X1jvQNue59HiELagEpLXK667KEVjgz9
	R3oJwnGzi7tGRu/8S1xPfNPpu+S6kHQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJisxV5H;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793951169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B36/ZsdGutleD8J5+kbIsSO9kqw7hQIWF34UjDbj+Dw=;
	b=xiVy4U4v9UE/ixomiMDreAYqj1bsvjWeEvF9QLwJC7WiC48LBbiLMD5/RGuUbyXy4OJ9Mc
	huiE162CfJZdYpPVz90KrCTqM3c1MFGGzQRFrfgzvjNfv+V+7ArbWtFdK1EVAW2PtvJNYu
	hIpli3SgMzqg+rfbiNWB4HfhY57Rgg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 274A060204;
	Fri,  6 Nov 2026 07:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B5B1F008BF;
	Fri,  6 Nov 2026 07:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793951168;
	bh=B36/ZsdGutleD8J5+kbIsSO9kqw7hQIWF34UjDbj+Dw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XJisxV5HHX1VKvCMoi5vz7V0yjxq/edVSIF/dck0PFwaq1sd+RYaqmaNkkESJhcjm
	 I1Pc1g8IZGfMOQanWx80VJOpsrqLwBr8GTrwGNAJNBph2XqkIQDs6eqD4oJZKyZI6h
	 3Lj7Raq4tcXElzbUvbFlEuS2QZ6xXASISvReJKgHQVmRg0SVJzSyw/nr6+vDj22Xtt
	 odsbkyCq9uXzCsZ3VQxMrbmwHXV3mv9CsqzF4ftTB4Q7oQzUBn7aTFocZyjxy2Wz43
	 dfb0R1sISKiNrrDg9elL/mXA9pVl0PmLhaAjmJfNO7DFpGfT2hm+u/bw8oO+Sj1eBf
	 vUGifFoNQDJgA==
Message-ID: <102d29bb-f6b6-46f9-8efa-b5313918d813@kernel.org>
Date: Fri, 6 Nov 2026 08:46:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15] mm: replace free hugepage folios after migration
To: Mark Bundschuh <mkbund@amazon.com>, stable@vger.kernel.org
Cc: linux-mm@kvack.org, yangge <yangge1116@126.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20261105070206.3094675-1-mkbund@amazon.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105070206.3094675-1-mkbund@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0DA140009
X-Stat-Signature: wj9ighayt4aiy4nqjybjjp6z9c7ziucc
X-Rspam-User: 
X-HE-Tag: 1793951169-311745
X-HE-Meta: U2FsdGVkX19gZC1X6CP792heeOC7rqclty6abU+6ZU5RjsS2w0G7EHHepylvRecScapn7L30XYbmW7OMG5GvYAfvzbQz/285Jfry3clOJuy6BvOc7sN0arfuesAAhFNQE8+lzq9+0rwyush42YqY5WnG0raTu6R63A421Q4MRSU4C/aXVKGv31iwZNybdRdyntCyPactpZt1mF9aEsYvTxzsdPU8IvwslICh5YgUgiWW265gvWPzGu+hO9ZgMtdlqLikXTMoMEXHRzRFXJwAhlCMUgM2qDjloJ2EUnA6Y44rwT0NGk8XKGlPyz5iMC4F6Di2g71Xj7tLkGfHCx48sdXsw9ld9lJ71AH2vL9ZkJpAqvFJXpm3shpy+OWfe77OC8sgCH9IOu7vehru4y0BCESpQiyQBJ8gLIv4psoPcmYNjWhr9KhckXmOJCDcxyapwy6fbt3Y56H4Vgee4qJx/9aWFUI/z6rUXTDXWBAT13SeO95RbqpuNHL/STMTYZt2FlDSWhDvhN5gicDPoXYpbJfPvMIJFrDYjQGZmKMLPxcZKhRxTesHqK0602C1CryGbbYRXdmMpKLK6Ghk4PeWS7Pw5n/zG95mEbUsFg8MrBs5XOOoXHfXkHfx500yrI82q94OMpmOd6/4aLn1+c2tPqoxxks67FcugSTsCl57ZZnRMnuoUiXnYa+LvezkaTOwV8d/dj5AmZNYvXa2vj+2znNzkOHiRJ0r5V+D32T+tZxaawqs9NoLM6phziOtPTsK81PDbImrk5vGaODP1Jq8/Mm3GQlvnXIa2mRwhDCykVgRTQjkTD67GG+IXFcBOCMtwb/1oEzUE7NdAOUpn45naj+29MEgRn2GBetQ4STYsNfB5IPP6CSsQ5zzW9ZhqvNNRGzW+lwtmci/1qTgMImdFwvs/BkdgS8XsG2z5J4cVtCv7pwooXMDe+KiyYGS6XUOIQN5CCtTNvx0bu88Jlj
 JQAAR50D
 nQyokkfoBrM0InzloJ5sXpnRWPlBVn2DJxRA/lRoUDE7uarWR2t2wAazupqgD8Vu4BfWcztMLKXhglMxJnwaf7P/B0HxbJ8tkFjd4CohDsj5K5B2UPi5HdyjS+f9mB2NKHrFB9HtsLeNTE2J5N0r8hC7uarf6sdcrbMBR2hugSrPsTATaMR2H7SSSgX+pXJ6BzdCi99aYBhMmErParaxanDu4OVLlKk55kfAF4oHK2w4H8g33MZP2HD995E6EZRiMaAowIDOaCRL/SF0LwqtQiWHl+SHglqapj+DXfwX551ZAx5XnVYpuD9fAUWpXIQ1KdGRVd+vDeLpBOmUjPGatSEu+xSfLjJcT1OBxYhLTn1X4Xw2jPIIIwYTEASSyYTVFgqJthEiPkRTJttOWQfWKwczotyAsVjbk7u9HFl/LgKiZEdCkAH5AwZ2aDqIyseVqzxv8Oh7dHoN42AJ5t2E4yFnez1sG8KiQKipCoPdDXYulB28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 08:02, Mark Bundschuh wrote:
> From: yangge <yangge1116@126.com>
> 
> [ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]
> 
> My machine has 4 NUMA nodes, each equipped with 32GB of memory.  I have
> configured each NUMA node with 16GB of CMA and 16GB of in-use hugetlb
> pages.  The allocation of contiguous memory via cma_alloc() can fail
> probabilistically.
> 
> When there are free hugetlb folios in the hugetlb pool, during the
> migration of in-use hugetlb folios, new folios are allocated from the free
> hugetlb pool.  After the migration is completed, the old folios are
> released back to the free hugetlb pool instead of being returned to the
> buddy system.  This can cause test_pages_isolated() check to fail,
> ultimately leading to the failure of cma_alloc().
> 
> Call trace:
> 
> cma_alloc()
>     __alloc_contig_migrate_range() // migrate in-use hugepage
>     test_pages_isolated()
>         __test_page_isolated_in_pageblock()
>              PageBuddy(page) // check if the page is in buddy
> 
> To address this issue, we introduce a function named
> replace_free_hugepage_folios().  This function will replace the hugepage
> in the free hugepage pool with a new one and release the old one to the
> buddy system.  After the migration of in-use hugetlb pages is completed,
> we will invoke replace_free_hugepage_folios() to ensure that these
> hugepages are properly released to the buddy system.  Following this step,
> when test_pages_isolated() is executed for inspection, it will
> successfully pass.
> 
> Additionally, when alloc_contig_range() is used to migrate multiple in-use
> hugetlb pages, it can result in some in-use hugetlb pages being released
> back to the free hugetlb pool and subsequently being reallocated and used
> again.  For example:
> 
> [huge 0] [huge 1]
> 
> To migrate huge 0, we obtain huge x from the pool.  After the migration is
> completed, we return the now-freed huge 0 back to the pool.  When it's
> time to migrate huge 1, we can simply reuse the now-freed huge 0 from the
> pool.  As a result, when replace_free_hugepage_folios() is executed, it
> cannot release huge 0 back to the buddy system.  To address this issue, we
> should prevent the reuse of isolated free hugepages during the migration
> process.
> 
> Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge1116@126.com
> Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge1116@126.com
> Signed-off-by: yangge <yangge1116@126.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: SeongJae Park <sj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [ 5.15: Take only the dequeue_huge_page_node_exact() hunk, so memory
>   offline stops migrating huge pages back into the isolated range. ]
> Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
> ---
> Without this, offlining a memory block holding mapped huge pages keeps
> migrating them back into the block until the offline is interrupted.
> Reproduced on arm64 on 5.10 and 6.12 (stock AL2023 6.12.113): the offline
> was still migrating after 60 s. With this patch on 5.10 it completes in
> 0.15 s with the data intact. Also sent for 5.10, 5.15, 6.1, 6.6 and 6.12.

The simplified backport was really only the right thing to do for 5.10, per my
other mail.

-- 
Cheers,

David

