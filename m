Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C059606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fOfeMSw0
Received: by kanga.kvack.org (Postfix)
	id 4194D6B00EF; Wed, 18 Nov 2026 04:01:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9026B05B0; Wed, 18 Nov 2026 04:01:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF7A6B05B1; Wed, 18 Nov 2026 04:01:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0A86B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:01:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87E8C160690
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:01:25 +0000 (UTC)
X-FDA: 85447646130.24.FE53692
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E01A9C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:01:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fOfeMSw0;
	spf=pass (imf10.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794992484;
	b=3edC+WqLoHfCk1Te55YaRixImUdFt1/QaX19iikn/7J1iNNIT9dNL1g0D7/J+rHIGYTIt8
	ZfE9SBr4SiJ2kS+nSkzj899tDMp3lC7jkbMjJOehTP5yxCoKH3g5bpRqjfQbjgTQ5myxiD
	uOXFyijlKgOYf7hKQ+pLG2+Mb/1rTX4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fOfeMSw0;
	spf=pass (imf10.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794992484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3zKqF+kTssGoSAglKwaVff1yakHy07R69gEEdogQZI=;
	b=rLdGw0qtxLYJxMBFMkuznjLX0vRHsz+7ryJ0vD8reCt27Ib0h7td0nPXZMOEllTkIA5Ad7
	OoPIvI9QqWBPrMwN43LurZdFC2V4aYrbWN6UR22IdGaTcPIRXoRj2DD66gLkv4/tzcUAgX
	t/wE2Yv9JqsiBJCjSi2+t1O9W+yUHx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 533DB61FAD;
	Wed, 18 Nov 2026 09:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FF11F000C5;
	Wed, 18 Nov 2026 09:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992483;
	bh=r3zKqF+kTssGoSAglKwaVff1yakHy07R69gEEdogQZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fOfeMSw000DsM9A69Oli12bUEKPpD/X/XKxt/LB8/e357NHtOSWRFyQzYkzDeHR87
	 XPi6EI22BdpJ5u+QsVeCPZG/YoLcdMwq42Q85DcDpnfiYQ2vJp71xxVh8wAl9iVs5/
	 xKfx/pQepXEI2isOmHqlVgWhSKlgPftdJnAybpFWZWvqED5PDisRhL3hUckZQqQ7Su
	 7RQk36bKKUsNorsTBAhk85iO58854iR1HSnxFh0L42vALOoIhUyq4sHJIEnw8ijRoE
	 d/HzpOLB+C0l7pEFc1ZU74iKvRkljEn2qzsXd0tjhoNr9+bN3dCopLwl/u2J9yy/pK
	 M/kqh8c1Y0FOw==
Date: Wed, 18 Nov 2026 10:01:06 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>, stable@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v2 05/15] mm/hugetlb: keep surplus folios when the pool
 shrinks
Message-ID: <av1pUsRqz3qA0UGi@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-5-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-5-4dd9e94ea9ac@kernel.org>
X-Stat-Signature: hno1y3tdg4kcpgdnqox4yc5oxu4mb9ab
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E01A9C0009
X-HE-Tag: 1794992483-214869
X-HE-Meta: U2FsdGVkX1/i0r1FaqgH54Y2UyCbmrdnfgv/PA1A2hP1sud1SAS//er+86O3rFDZWYBssbsg2GNQD852ecrzPoQakImJ5raipC7GrT3pCEzyuQlWFTxDFKQFFgSJqPylIvzNaolTQ2joClkg0u+Ea8RJ9pzJ/6W97nrVTFon0XUIMtgORSbRsZvmu88/h95XgC6wUpEfdgQEiX4lHu/vCyuaEVtFUlCb8X+q3LK07SaQlDeQF2kaYlk4oRor/l6mR4CD8wsgGktcgxf87Fg5dFXDW8CPw1wez3HLKWm7B4GynluSwUxF9jxEOmeRGd5+1DTvY/0hdL9hzfEri0wmuiZbz6YOdrqblBM6w9LUasQIoAl/gXJTMxAJrTPjakyXNS9PebrpkX5SZYd+6sPz8k4fsuN9Gd+I29DC+cxJBOQd6vXFLFnZi28gBa+1aKx278OhgywlHxvgUJ3qOb1y4BZpY3gIpL1m2LAWFQ/bz0WwHY7sHtWQxyKWTJqE1CL3BCReu+bCQOmp0PqPzySyJ6r81Hk/HLrpCWs2eIXhkMnmF6nOOGt6lgyspdycvKY2Lwr4SVya8W/jGqSJlEo9wRMpNnLlBXeyocpuV4iwSxW+7e6RJc8l+qgWcRt7m2CSJqSZX3lqqRAQvg6MCWFvWL0gH0caL2bwR4bxDHQjesQd7kkvsS98/rwixGUxnNagAT9L8m2dWBf6fgECN6aygM3giFEWVmQa4xrdrt8Fqvr7n80naiYqQvLRhoA/XYhesapp+Yu5ryOg4EGJVMBnNF+dRrHNFrI0mNps6j5VNpuCllr9QL8RicpolOeduoDg4NHKbaLkcquu77rz2EERtvH9kY55f1By+oYvA6IOyr1NKP9+5ODbtiBgUlW60styUYFxRhwZ1nQmALPCCz1AmH9d+CGHSQWMMH4ju4jkzl2zBVt+EMJ4VydoSmmjAyP1CO8jzGs7244VTpwTwN+
 ExeLSFqX
 JvKBhOOhdTi0QHiI1mDYTBVEASVW4OraWRpl+mx0sqezTC4hxclCsefk0Sz+MsMO9VeH9IWQkUJooFJ8DcIkPVvpplt/U/bbT1QS76F0fPH1rzlZ9ybttxWfnTD14pipCkHkrmCWZDtSXGPnqS/YbpzArG1PSXuB7X0JT8JnUCh1bUydyJPqenojaVLHK38BYU+Vms0afNpKe7Taf5bsQ0DbmyC1CyTEw3riSslTwW3L8sNlVrasNiGbtGk0gtg8PikHztD/zhQvkT0tmSEIj1nvURi12Eu522IPqmYOJ0zTqsI3CtoV0CjIRB1qrT3jQCtjahJegivTuhMiuL+Ui2sf+lzqKHvyvuu/hnT0n11j2N4RMxLxH8OV8U3YeaKCkDboFGjORiGrDsYUCY/uFumS+ldB1mRO6d3jLquU7DryYE0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:26PM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Surplus folios are accounted per node. When shrinking the pool,
> set_max_huge_pages() removes free folios through
> remove_pool_hugetlb_folio() and accounts them as persistent folios.
> 
> It can select a node whose folios are all surplus and leave its surplus
> count larger than its total count. Free surplus folios can back
> reservations created by gather_surplus_pages().
> 
> For example, with nr_overcommit_hugepages = 8 on two nodes:
> 
>   (node columns show total/free/surplus)
> 
>                                       total free surp   node0   node1
>   mmap() of one page, bound to node 0     1    1    1   1 1 1   0 0 0
>   node1/nr_hugepages = 7                  8    8    1   1 1 1   7 7 0
>   nr_hugepages = 6                        7    7    1   0 0 1   7 7 0
>   munmap()                                7    7    1   0 0 1   7 7 0
>   nr_hugepages = 0                        1    1    1   0 0 1   1 1 0
> 
> After shrinking to six persistent folios, node 0 has no folios but its
> surplus count is still one. Releasing the reservation cannot clear that
> count, and shrinking the pool to zero leaves one free page on node 1.
> 
> A later write to node0/nr_hugepages underflows the unsigned per-node
> persistent count: 0 - 1, resulting in allocation of many folios.
> 
> Use persistent_huge_pages_node() to skip nodes with no persistent folios,
> as adjust_pool_surplus() does. This also excludes temporary folios.
> 
> Fixes: e4e574b767ba ("hugetlb: Try to grow hugetlb pool for MAP_SHARED mappings")
> Cc: stable@kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: cleanup code and description ]
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

