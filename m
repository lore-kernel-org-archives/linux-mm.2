Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A6A606A322
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 05:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=drTxhs0A
Received: by kanga.kvack.org (Postfix)
	id ADF0F6B00EF; Sat, 31 Oct 2026 01:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F5D6B05B1; Sat, 31 Oct 2026 01:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E076B05B2; Sat, 31 Oct 2026 01:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 796106B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:44:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02F5C1601FE
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:44:01 +0000 (UTC)
X-FDA: 85381830324.11.7B0671E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB07BC0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:43:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=drTxhs0A;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793425440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsdEHEUIdzvaQtRrVTZS/CJ+UHx0YM95KADOoQBI7W0=;
	b=ha1GBWDPoXRHj063FWHhLawL2aHIOW+LyuE7Ko44bB1oQuiP2DD8FqM8tC5RjBK3xvGHRr
	m0vhzuEe62Ovvhyw4+BUaGRmG3dxM2zVONQTdWGVDpj32ql5Rny+kOJr7g928OSfSLKNNn
	UJ10s+nlGFVbXHGX8zQ2MbIXlfjEJCc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=drTxhs0A;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793425440;
	b=nzRq7gPsM9ECgh2nlxShvoaYuvIBDXIqyetmgpyhvPrAPYjU+9CMfg1xLvS5PR6ktwYKFX
	8lOQusNHMulRk8GH6M1D8C0bIwnMNAZl48BmtFrU1qL2HKe0jpU4ccIwRZOsBrcTdu8Cel
	65TuX/YH2qDH1qqdV/F5fPh7j/F9VqM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CE851595;
	Fri, 30 Oct 2026 22:43:55 -0700 (PDT)
Received: from [10.163.156.83] (unknown [10.163.156.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 361883F59E;
	Fri, 30 Oct 2026 22:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793425438; bh=KtacfKJeh6jI8AxfG3p3xz2pRnGpmEm0kIOWdqIWDvA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=drTxhs0AqTGZ7XVX19T7iR5Wpu1UV25u4Ad+13uRGp8CeQcTHc9Y8PgG5JdarN6PG
	 ZnbRLSrZqvGCCXDNHjdA3mge//bTwwewRjTl5GRticQZAQtkrPWWJBvPaP03j2H3A6
	 hz1fGA/OFAF6GhrflAwkV7TSa0oqutweHyyrEP9U=
Message-ID: <9b5e22b0-3876-42d3-b58f-053120307a8a@arm.com>
Date: Sat, 31 Oct 2026 11:13:34 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Gregory Price <gourry@gourry.net>, Hao Li <hao.li@linux.dev>,
 Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DB07BC0002
X-Rspam-User: 
X-Stat-Signature: gndi9ncxksq8czzj6fskwfqtpufimtu4
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793425439-911505
X-HE-Meta: U2FsdGVkX18xlpk0EO0O3DNT/wwPGzTNUGKguVqzk2uGjQB6U1LLatIzirJogNzB7+72nv06GADD5hBrM4yHn54J3j86NmRpZ8EJBQeJN5mGZjeTBl5JnR1bft2lZKqeFa6rNeJhKS90lOBi9dfip1nFD2VswlxQfU1gpawpYMPV2rsMsMiB1B9OQvDIzpH55tI4pyMPEQcbdCt2UQoz8xmOVu5KZw1l1f1MpWgt9lBDvkm3PcrD9Ut7tiq1m8mChDXAZNmTAvBKYP1aqK+XV7uYYvzUuEgR00OU2PRfaU8wWL/0LPOMmBGPw1CqXZA4TTELtF0rKdrhrcAqfRzQIOdJK9Ckq6YpHP9gRNW4YQoC0YmZQi2I4PRASN5hlRW77J2xSikqhPkCt8os4mjP0leaVbrOCnpqevAwQ5Q0TekAP4+uFlIIIO/d7rLVj8xFJsvtPuA8OGd6S2J9aOvBDqyl0bYrNFgJJASCRBgeRxhPUs/B+rTrS8W2D34ROlgYp6PZyNH0XxvTZuava4nCazzOou0INw+8bE9cnI8pIaOHJsvdQXKUjc11uQ2jSThRH9YZ3xDrhMgLr9PHZcEUKSqbFbeWo1qtl+i6G82yeIGyYM33O10tXGx0kvSVADDQDEyb0xOg+IQcRzwA8Z9y3IgTG7r+02Xow2KLuJS8U7YYVtCRZ62p5tyan4B/tV53E9bveqdgOVNoavggIxuaGiwfvV55P7ziOa21FTE3aUNWod1A3+MveMNUABTdlyoJdBnnUvyXgIY38bpeiOCgBclgfiPjvUI2LhuJgD/u1mCUGlb4jGcdRjNHx4TpoGgek5oaC8HrdHt36JTJB/ijjGkg7P0umZGGDOktPJk8h3nmrODssy1GvzeEKdxzR3CgoF3X69HGIuM8e4FQ1gzZRVy6nXssuaRI2T8lkSqs7EmDM+SNS9yzYq7mdKg81T7WKpNQSRwPpa4f6FP/5bh
 r7zR6MOb
 xlRn36GkQIFx9vQ3Dl5pomHRAK/Ufu3lAuGN6BTMP0ysp3/IPYnWrlZBE5+93AmMFdkeo8hgfBYs+hY/Hap+eWb9O7UiKGgdnisL8zptIfQIPvJduPAB+FOAnU6ZrpkM/qj6Mr4zNHwDvURVyGZX0bF3q9mOJRibF42kxqurpPjuIQ65ia3Gi8G4tAv0RUKrVS09SDGbj/LoNLj6DvERS2rk95WHhRLkGqRuUlmTO/xClDOls6cEtRnuHp49oSwkziEgdQg0WO9xHmejhalwLCeLvpaIjeu4/JMVrEkSBU7gvZpV7FeaWGACTO5HVK6vrzZRmKG1VqTNl8T6pvoglic6KZlDgRwZosVjWj3pqQ0F3VkBhr42AHcQp1t/zWuMUq9ebwukTaBR64TeXkrJxWYd8in11NeyP7X4zUiDWyptC3N5AoepIhBzYFV40ZaODOvMGSD17JBH0OkZn9Xjvl24M8EwySrp1Jf7oTBS06YGgtLOVwThlHXjrtWopULkuZoA1Knt1OPLs36Q4qfuFMohsIbzPqqYXk6AynkPPCLxWLwE8v0ZgJiUloQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 31/10/26 3:04 am, David Hildenbrand (Arm) wrote:
> Zi has been contributing to THP consistently and reliably over many
> years and is considered one of our most valuable THP experts. As THP is
> an especially active area lately, having a single dedicated THP maintainer
> is not sustainable.
> 
> Fortunately, Zi volunteered to take on more responsibility by stepping
> up as a THP co-maintainer. So let's do exactly that.
> 
> His placement in the MAINTAINERS entry is very convenient to perform
> this change :)
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Great!

Acked-by: Dev Jain <dev.jain@arm.com>


>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0baeb37b0dcdc..02b5b542f81ee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17817,7 +17817,7 @@ F:	mm/swapfile.c
>  MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> -R:	Zi Yan <ziy@nvidia.com>
> +M:	Zi Yan <ziy@nvidia.com>
>  R:	Baolin Wang <baolin.wang@linux.alibaba.com>
>  R:	Liam R. Howlett <liam@infradead.org>
>  R:	Nico Pache <nico.pache@linux.dev>
> 


