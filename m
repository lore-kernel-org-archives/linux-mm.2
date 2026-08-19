Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD9EC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C78F6B0098; Wed, 19 Aug 2026 02:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079516B009B; Wed, 19 Aug 2026 02:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1BD6B009D; Wed, 19 Aug 2026 02:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B783D6B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:50:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 285321C0919
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:50:39 +0000 (UTC)
X-FDA: 85117095798.20.7952799
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE338C000B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:50:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qd6JsvZR;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4ctjB3/w3vT5kTPDD7B+zd7eRwflmO6cSm8OC9rye4=;
	b=YQw1K+rr+C4b1oIQO1dGOhs8IQRMoXkrEo6pLiYsZ+QkROIC60iejFgdZn7gjJ4FD8W2Xq
	r7ZG9WfG5dF34GkTpFVy6EaI00FD7EqHv73NaRug3+Kwaeqd2m4VVsTiVJgxBfsLXFvvCR
	Q0o48uydVeBhtJT53zFEvGcPaALio6w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qd6JsvZR;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122237;
	b=R+cm2d7XLYnPvQfV2wok4rQFhw8Y2IM0l4ztpKiLON3PmZKASl8bzbRUeezVf4h7Ic1sWj
	K0Fpq5wwcOV23R+LzjQ+Pwqiq4wHsb3OQGmMMdzllhl74lKwMrCOprOYhRmgTYJoCt/+KI
	VPe1gjVU1ivv8lycKzYXuLRKUxj23Fs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF72514BF;
	Tue, 18 Aug 2026 23:50:31 -0700 (PDT)
Received: from [10.163.138.181] (unknown [10.163.138.181])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 201FF3F66F;
	Tue, 18 Aug 2026 23:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787122235; bh=hzyGyhdGrUBLrpKdCTeSQJcY1CtIsQebRKlFpcJXqno=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qd6JsvZR1+bVNlqKjQsejmd57DcATLi+C5moZwtk0ZQv8bPuz2aLXiXQfeAwWX2h5
	 +kHySCsMVOUow5PJOaR9MCUfjK+hEB5fuyM+BT3YQIi9O2FzCv/JHhoytWiZOt397j
	 l8NRF0u4evNo9er1Itl7gN+C3BIaQaVVWt6QxyrI=
Message-ID: <80632d25-df40-475b-b7d0-912d657a977e@arm.com>
Date: Wed, 19 Aug 2026 12:20:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Optimize anonymous swapbacked large folio unmapping
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260723070905.3422276-1-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DE338C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: pu44daxydp1c74fk5rxwnz3rb9t8zbs3
X-HE-Tag: 1787122236-710895
X-HE-Meta: U2FsdGVkX1/NpLHclWNnt1NVDXfivYABFEB+jrvby/sET81p1wjzGppPjRsmXiTiRJfvhT43orcxe6MtNJU+7GS6wYDNHCUYk3X/icjzaOexYZMeCvJ78kXBx+NH1Pj91dLIV9Kn+x2WzV5iqmH/h1CsXLVaEQ5eapC4YSmDrJ/BV9/C4/MIZBOWwo2FlXsQ3RGCBKk/t+CCkwIFaULLEzTSkq4wg5Ru/Xdt4N5mOvwLBjPcPsj02JXLZdpGSurGs2rdqitYAoJbUqrHox93qq4lnzAVUnr4+ZR2naxJ4wSPsVQpJhsjIw773RACuFkhLwGh+FlHu2QX1RlFZ37rJAKsUzb6qgBqJWX+Ze8J3DSVtkfYaloJyCGKSgEOT7BEHbdvGv88IV6jTb0uOR1Nfvn6EfuwNxAIPnenQ2LRK/6RN22gYuE2mgE/PiL3EvCP1BB90zz5UzquXjBOGXnZPd2Xu2rJeTCuDog++Y4eKQPg8doa3fBIux27gbdO+rKd3dtr/DETq1CeZGkzJ1Dcx/xIEF6Y2LqU+LqQYWhU4kLiYEevsU4G5IehHUe+s+On+oCivp7teTbF6FdXRJyqrmsNmkzPASVUyK1dRZShxmRElQikp6uEKc4YtkYEYs40WdV4EXEKcIuVpk1SgFbOWl4Vk3HZulMZ8PIqljNBVZo7SJROd7yvODkTe7ubPku3lGoA3zwhEZe4ZXO+vxfbrYMV2Qvnk3ZPBke0Lvr08JyTOf/J2ZW0nILroydvguQfK2Rtm0JPU4tX0go8quvKTQi+UPzZWmKvhZeoYsI4D98AGPe4bju4YzJ52QfwU/uPqWjlWsQ0iLzzE0dKw8IgKGk6GeYPUAoqp0BMvxM3o7sjT3UOAqEMVM4uduik7r/Efq2uIX+ka9k4vlC8AJvDczm4AyoDpJFjecdsV0RwHbRcvdCEuhe2loPYJ4EUuFcE36AGXubHdc14nNh/VCs
 4egOWX6T
 8kA2T3e77JQl1p/ubuvLvyilfcD0zcOqfrU4jClqzJyRzMocsijZ7QeTZ3QRK1CsI7nnxUAYKPLKE8FB3i3HdtkKpg/vdJ0W80SlUAg7QHpootqLUCkNDwHHYmPOfIfpEMW430/uXkheJty1q4QIa2aEe8kG4RD0FlR/dyoB6BFRIl6MEwjNZ8wgLIROKQVP+t1lGFC/0h0iX3aR/VJ05jH1mSZw6T062PeewAIFOSmfpinQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/26 12:38 pm, Dev Jain wrote:
> Speed up unmapping of anonymous swapbacked large folios by clearing
> the ptes, and setting swap ptes, in one go.
> 
> The following benchmark (stolen from Barry) is used to measure the
> time taken to swapout 256M worth of memory backed by 64K large folios:
> 
>  #define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <string.h>
>  #include <time.h>
>  #include <unistd.h>
>  #include <errno.h>
> 
>  #define SIZE_MB 256
>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
> 
>  int main() {
>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>      if (addr == MAP_FAILED) {
>          perror("mmap failed");
>          return 1;
>      }
> 
>      memset(addr, 0, SIZE_BYTES);
> 
>      struct timespec start, end;
>      clock_gettime(CLOCK_MONOTONIC, &start);
> 
>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>          perror("madvise(MADV_PAGEOUT) failed");
>          munmap(addr, SIZE_BYTES);
>          return 1;
>      }
> 
>      clock_gettime(CLOCK_MONOTONIC, &end);
> 
>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>                         (end.tv_nsec - start.tv_nsec);
>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>             duration_ns, duration_ns / 1e6);
> 
>      munmap(addr, SIZE_BYTES);
>      return 0;
>  }
> 
> Performance as measured on a Linux VM on Apple M3 (arm64):
> 
> Vanilla - Mean: 37401913 ns, std dev: 12%
> Patched - Mean: 17420282 ns, std dev: 11%
> 
> resulting in more than 2x speedup.
> 
> No regression observed on 4K folios.
> 
> Performance as measured on bare metal x86:
> 
> Vanilla - mean: 54986286 ns, std dev: 1.5%
> Patched - mean: 51930795 ns, std dev: 3%
> 
> I tried magnifying the difference on x86 by using 1M large folios, but
> can't spot an obvious improvement (looks like my system is too fast to
> benefit from batched atomic operations!), hinting that the benefit lies
> mainly in the reduction of ptep_get() calls and the reduction of TLB
> flushes during contpte-unfolding, on arm64.
> 
> No regression is observed on 4K folios on x86 too.
> 
> ---


Hi Andrew,

I am not sure what is the current process in mm regarding sending patches during
merge window - would you prefer seeing v2 after merge window or shall I respin?



