Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A47FCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6B66B0088; Wed, 14 Oct 2026 10:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BEAD6B0092; Wed, 14 Oct 2026 10:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FBE76B0095; Wed, 14 Oct 2026 10:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0496F6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:16:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 870D2120564
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:16:23 +0000 (UTC)
X-FDA: 85321431846.16.80A7132
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9AFE414000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:16:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kxehxrDm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791987381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zofpo5EL7jsJHnlm4AbGXzrSHnnpp2KmUnkGujKml18=;
	b=7dYYqi9/Ldt6G1f7gyxptn/Enwtb8UUiU5FkEX5cF4WeE9ggQXDmkM2Q+7EdSxI+3mnuFd
	CZLvlPz6TF1YJLRsGoygqao/jiY1Wu9AGtm2ATaEa6Evfq8ONh7ir4RmMJhO4iX1pDEyI0
	dEO4Z/4ZfWGdKQi6qCxdk0Ygi2wnKY8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kxehxrDm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791987381;
	b=YztR/vxJuZYiJWcC0jXrXBlLbmE0Q0LmoQbcid0jnzi5e80OG9lvIK81ms1QCxqmLGt6mq
	GeLZmeCnD6WkidTeHhw0Yf8chVupC8W3eaUA/TroBxmaKlqv2My61Z95NVm2R3J1Bv8+hc
	7Rozo4YcDUlZhtm4WfmwqoSMewq+xZA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3412A1570;
	Wed, 14 Oct 2026 07:16:17 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBF633FB7F;
	Wed, 14 Oct 2026 07:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791987380; bh=+gcTnytu6bg29DEP+Z2oFEapatSpXXzRj1ksbk8npt4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kxehxrDm3UjrSeH8mx0a1SGe+IcIGgxOr9On33ZZWq3Tj4LdEPkUYFFvr2SXVqzLq
	 3fQi006eqvaihoKsVwPFwMR3K++MZonmqTJje5Z2ew/8zm0hO78RsfkGwg2mDWbj3a
	 ywnzqZBIJeCgPJi5R/Y/R78erG0j3/+PzbLgstKA=
Message-ID: <55f51fb8-9777-424a-b45f-a6a5bd9a4693@arm.com>
Date: Wed, 14 Oct 2026 19:46:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/5] mm/page_alloc: count a merged buddy's pages under
 the merged type
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org
References: <20261007021250.1665929-1-riel@surriel.com>
 <20261007021250.1665929-3-riel@surriel.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261007021250.1665929-3-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pijtx76y1wbuo9gpryapox43initc7a5
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AFE414000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1791987381-871064
X-HE-Meta: U2FsdGVkX1/uwtRpYBCiVWfJ3PpwMP93MhodQqhQYG1IF0klU3iBql1NDnvmr5gvXuW7x1LtZd0QPA1rFpD1kmeSbQmRhAouyuF6tIIk13yNNEtNcjZchNoAIyeOPnSp1vNG5p2g9XufBO4W/z65qvwHlxU71Jc/zb4UTfYfPOHKc80QzVUQIOOS6QlvuKv+rubcOxNauVV7QEimKeUdE4TiGtps9nYung6bg1ZrZQEYbcZ7NfHMPS27GpWKIITeEThc9MfVTnfVpb0f0yxF4daFQXegpFeUyzhbjWLOpLFhJO8YZwWdXgisw7naymyxm1dYJkd3uiFXRzMIB+R3W6sF/K8BpzEku67/Dhutwx3UAWUfR5lOxyDUq2qbdN1E82JNFVy9OrDQGdBhbKmMl9J6u0GGWtewuLav8/5uZ3X0yud5DGhk4DxL//LN3p0VNjyeqwQbQHmrpqsog8XS088uhS5yXzEG8k7bfSXY+1y94rYSzS6Hq5ZVyjN3yN5712AdbxMdEzZW9qPpLtWshT9ZME1Zviwgvvexw32Sj6RyKG/+CAJ13O36LeFQ88YKBTyZqIpMHbgWLAzc/sQApdqskBizGyKacPMjzMundhXWmd3MAagD3ijIqqm529t+lBwh265/hNNoEs6oIieIkbj1v875oVygyPX5cww1oXsdS1KXdOjholrHSOM+Qi8ViF6thMOm9XKAURwsKHf330mPCMsNvwiOb7IiR41nciU6nzZuul3m6AhqsZJtJmday1ngneDOK3PcN5AryPsnekkY8nCvbc3+VR2Hgva1E9ZXjSogMlC3ImSGl7E/RznJqrkSAIPDA74cADteiOW84BXSmrFn0aCZ+pOKyPAEgATGq0ZmGJUjlViV7VD9t7yLRLhOoOoDPHJT6GTMsa/YUsamawZ8iS07PBELCyDzXN1HnAt9yhnJbxw6hlecDY/qIP3FtqcoWLVQ1MoYNir
 nBY12wEj
 CmTV3QrrVCdjaxRIHbGMuloDET2qU2KoaYSb1MbQ5MyUdzQ/HHWQPUDeiUB/6bn81Gey1aHGx9NXP5DUKTXGOl2T+9iG7DOIoRjTUmDu6BmyDWmhYkvzfUCRQVj+5mLE1S7gI7x6l6wCNcbDewlmUzxCRYGcMwvGbPf6n4yxnEaNtm2At+Fmq5qa3OvnbiA9PTWQ3ir84n5u1ezG0tzYa6V25hZb4K0cLMXSrxptNIaeDt4GVvcph36CZi1xwO4SRt8FwEGiEU6LvrhHg8LuzclopV9I6gk2s+yct6Pq7d1fCnSZ6Tr5Q5CHcokG8iqStRjU04o5dZ//bka0DGJv1YIfvTn+gi/oqphdxVkC+QNJ7cacX07YWcEwzGTpb+WRNtb2qXKXM64mKj36j4x7z9guH0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/10/26 7:42 am, Rik van Riel wrote:
> __free_one_page() merges a freed page with a free buddy of another
> mergeable type at pageblock order and above, and retypes the buddy to
> match. The buddy's pages stay counted under the old type: nothing moves
> them to the merged type in the free counts.
> 
> That is unobservable today. NR_FREE_PAGES does not separate types, so the
> missing move nets to zero there.  Any future per-type free count would
> undercount on a merge from the other side, and allocating the merged
> run later could wrap it.
> 
> Move the buddy's pages to the merged type in the count too.
> 
> Assisted-by: LLM
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/page_alloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4658af97be010..ae38e25971559 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -993,6 +993,11 @@ static inline void __free_one_page(struct page *page,
>  			account_freepages(zone, 1 << order, migratetype);
>  		} else {
>  			__del_page_from_free_list(buddy, zone, order, buddy_mt);
> +			/* The buddy's free pages join the merged block's type. */
> +			if (unlikely(buddy_mt != migratetype)) {
> +				account_freepages(zone, -(1 << order), buddy_mt);
> +				account_freepages(zone, 1 << order, migratetype);
> +			}
>  		}
>  

MAX_PAGE_ORDER > pageblock_order confuses things so much : (

Sashiko raises something:
https://sashiko.dev/#/patchset/20261007021250.1665929-1-riel%40surriel.com

Although feels like it is exaggerating.

My concern is for systems with a high diff between MAX_PAGE_ORDER and
pageblock_order. So on arm64 systems with 64K pagesize but pageblock
size as 2M (and PMD size 512M), the pageblock order is 5. We use this
configuration to reliably get TLB optimization from contpte size mappings.

Will we then repeatedly overflow the pcpu counter into the zone counter,
regressing stuff?

Perhaps I am overthinking. Your approach is clean, but perhaps we could
also do:

void account_freepages_move(zone, order, buddy_mt, mt)

	/* PCP-types do not have per-migratetype free counts. */
	if (likely (buddy_mt < MIGRATE_PCPTYPES && mt < MIGRATE_PCPTYPES))
		return;

account_freepages(zone, -(1 << order), buddy_mt);
account_freepages(zone, 1 << order, migratetype);


>  		if (unlikely(buddy_mt != migratetype)) {


