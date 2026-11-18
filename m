Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6AD606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=p0UjN81h
Received: by kanga.kvack.org (Postfix)
	id 06EA86B00EF; Tue, 17 Nov 2026 23:32:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F8E6B05CD; Tue, 17 Nov 2026 23:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B2A6B05CE; Tue, 17 Nov 2026 23:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAE5B6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:32:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4099AA067B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:32:29 +0000 (UTC)
X-FDA: 85446968418.04.0AA4B53
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C67CC0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:32:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p0UjN81h;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976347;
	b=iK3oaQP04LGnLnEvFp0tFwjIAPBB4AVsAk7tny9o9uCcGwWbyPCxIj4mvoDul9C/9hDb7d
	VlAguXB98iJsX2rufxmnHFdF8nlMKC9kQnprqpiw2dTXYtUD5GJn4lJ9NSfn0Mcz79xZnz
	VWtw2lbK97R6xxmJCL380pba8lmARno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MS9sX+VwlIh4X9xAEq10Tl8H83Ldhcl5BWCWkiO/T4=;
	b=AnY0GjMqH06jKIbXdCffpUnX2pRYz4vjPf7IxBJcCSicW7ihFjTSt9qZLsZWDpSyv79dED
	zJx6XjJ1gANuUB6bIiGcIqpB4topfehZ/itPZAA0dzFYcBUC60ktJxtFW8bV9LniuiClvR
	uTP5fk1U6zaykWK5/Jt1TL5W/a2iwKg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p0UjN81h;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECCCA1596;
	Tue, 17 Nov 2026 20:32:22 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 339513F882;
	Tue, 17 Nov 2026 20:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794976345; bh=mGDSNtodI21bLq4+K4VQm6Lw0wUHcWZaLpeVsLI8sl8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p0UjN81hgfNuYJHbl7yquDsT3i72OvHpwNBMIyqfWFMgSGo89/71Q7Sok0hzEiMaq
	 j3LGaIu8n7IHqWAPU+8tkD0AKEx6AzV6qY543089IEqaaXTn9ZLFgAKQvXPDiKD3RS
	 hA2IEUpDwaPsa3QUdfrIDnEp4BPvA6DqnJzyyFkY=
Message-ID: <a45d7c1a-08a8-4f18-82cb-535b6d1d3aab@arm.com>
Date: Wed, 18 Nov 2026 10:02:12 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] Optimize anonymous swapbacked large folio
 unmapping
To: "Garg, Shivank" <shivankg@amd.com>,
 "andreas@gaisler.com" <andreas@gaisler.com>,
 "david@kernel.org" <david@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "hughd@google.com" <hughd@google.com>, "ljs@kernel.org" <ljs@kernel.org>,
 "chrisl@kernel.org" <chrisl@kernel.org>,
 "kasong@tencent.com" <kasong@tencent.com>,
 "davem@davemloft.net" <davem@davemloft.net>
Cc: "geert@linux-m68k.org" <geert@linux-m68k.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "nphamcs@gmail.com"
 <nphamcs@gmail.com>, "shikemeng@huaweicloud.com"
 <shikemeng@huaweicloud.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "harry@kernel.org" <harry@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "anshuman.khandual@arm.com" <anshuman.khandual@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "surenb@google.com" <surenb@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "youngjun.park@lge.com" <youngjun.park@lge.com>,
 "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jannh@google.com" <jannh@google.com>,
 "liam@infradead.org" <liam@infradead.org>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "mhocko@suse.com" <mhocko@suse.com>,
 "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "pfalcato@suse.de" <pfalcato@suse.de>
References: <20261115143905.3045084-1-dev.jain@arm.com>
 <4c351ae2672a817df071b5a8b6b402846b897a75.camel@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <4c351ae2672a817df071b5a8b6b402846b897a75.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1C67CC0009
X-Rspam-User:
X-Stat-Signature: 1h7e5jked7wjxotoxoczbk56wqnbtodr
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794976346-874717
X-HE-Meta: U2FsdGVkX18aA+beAaUOxYPoVnR+cTnOS7MTStVnNF4x/+lrLMtVieCKdZptdCywD2dirWUkNX69wQXrUr42QyasI5ppU0ask1rRNeluuIQA8OuhmnhU4/2jGn9TW0gGqjK514r8+nBfdtKi5Az8ajxl6gXI+A9v7pJrwPmO66SdnGWWO67BURMjtE6Y6MmvDYl1jhxoDpje9SAy2RgMmQkaoBq4z+BsVo/GcF+82WDODYpXNOTxFxi3T5VDjaWFX0xr/LhmXfLboB8gQ9PRi0aePJvGlMjKZFdxWjfrjZD76/D3J4+66jpJm88sDeiGXg6OChl0OIIl9wHN7f37TdV7UlaBqeG6LX5IlW7yxIcrLKrK4ZvADSAtVTfG8y7uKtR9mo3fvbWCbQxzp0MypaR/+5NZeieGqckiUSVw+Uxc0aqNnZtK9khnlsORj4ctrXL10ubB4jLiTrTGryRUHhxtkeF/D1tbtb//e7cFqbAoyU7kaPNXVGYWrO8EUOAGVh/7xd7M0FyJX0eR9Ud0YxAm7AE2hg7VgKsxLs8Ngc4CAMiooYk//8UTHVidWQ64cXHbddH2jU/6uWhxSpdi4ovkdqfX1t1M/3m1iRFPWRpYP8ke/DG2270w0UOD/jErgkc6fTto//ndqa2Wjaak0L8N+9gK7wnNQLNZtAjZMXP7zc/YHSzgNVPF+eHu4g0r6+0u5F1PG7ZTbhlHhU8Z5enM9xt90HGhA3MbW5tITS9hAd2FZAn0vZ20RtMlLCfdP+cS1/hp5EgwNC6vYo80EMblnCZVTaMIrbO4LPrTeaVZRRdJI1liaFJqqOJjS7SWmRXUvUIrLXIrdv1VjGFzXYLPPYMVJHvDGhSIJWAejjA5ThW9+o3ak58rCs9uJ3SqVHnQSL87FfgvtgxYlUL/ogf0R81rMGt8U/fKQt0qBI2CwzUDWI/BpGcZAdrrgNYLQVJPpHzfww3pfN4GER5
 +tio+gtR
 NAPbsylFQidtfqATKS56JLUZ5Ttim9bsGk16pLeutThRvEZw9EDbxRy/mzA/eincEP7Exuc3i0tdaHG9e+5EJIf2lFTBVnsKemeuGyKnCtnQyWs0M6kY/qkhAERADFf4teaR8kHD6ENDDPPsRAATdP44Zj0NmkgOHuq94xZFlPkt3eRXFd46+H1LBehJMO7+gjuhb3WYSAg+fdtJZ7mcsOgRoaMnE0PCNzYvoIUCcAWe7FdynqdNc7rKmSfMOv5eoMDmOv2qGKlJoJWopdYuNKbrlT7ezydTcQJSr+fKC6tfliRKkxVzJ0tqu0F8ZgAsbSuLVRtOFAaImISLdaSneHcf5gBaxTDQmsL0KsTQ1f4z9UlxmmTNM7rdlrs7ZgDtTFykUs39Gl7B9O3AbEV8K4Y5ftbgnlq7NFDKVtbGr9aM9MERk9rDa4hvu/KrnE/P5mswe7muKS7+EL0Bh3hFdbbhhCH7VpkekS9pT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 10:19 pm, Garg, Shivank wrote:
> On Sun, 2026-11-15 at 14:38 +0000, Dev Jain wrote:
>> Speed up unmapping of anonymous swapbacked large folios by clearing
>> the ptes, and setting swap ptes, in one go.
>>
>> The following benchmark (stolen from Barry) is used to measure the
>> time taken to swapout 256M worth of memory backed by 64K large folios:
>>
>>  #define _GNU_SOURCE
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>  #include <sys/mman.h>
>>  #include <string.h>
>>  #include <time.h>
>>  #include <unistd.h>
>>  #include <errno.h>
>>
>>  #define SIZE_MB 256
>>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
>>
>>  int main() {
>>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>      if (addr == MAP_FAILED) {
>>          perror("mmap failed");
>>          return 1;
>>      }
>>
>>      memset(addr, 0, SIZE_BYTES);
>>
>>      struct timespec start, end;
>>      clock_gettime(CLOCK_MONOTONIC, &start);
>>
>>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>>          perror("madvise(MADV_PAGEOUT) failed");
>>          munmap(addr, SIZE_BYTES);
>>          return 1;
>>      }
>>
>>      clock_gettime(CLOCK_MONOTONIC, &end);
>>
>>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>>                         (end.tv_nsec - start.tv_nsec);
>>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>>             duration_ns, duration_ns / 1e6);
>>
>>      munmap(addr, SIZE_BYTES);
>>      return 0;
>>  }
>>
>> Performance as measured on a Linux VM on Apple M3 (arm64):
>>
>> Vanilla - Mean: 37401913 ns, std dev: 12%
>> Patched - Mean: 17420282 ns, std dev: 11%
>>
>> resulting in more than 2x speedup.
>>
>> No regression observed on 4K folios.
>>
>> Performance as measured on bare metal x86:
>>
>> Vanilla - mean: 54986286 ns, std dev: 1.5%
>> Patched - mean: 51930795 ns, std dev: 3%
>>
>> I tried magnifying the difference on x86 by using 1M large folios, but
>> can't spot an obvious improvement (looks like my system is too fast to
>> benefit from batched atomic operations!), hinting that the benefit lies
>> mainly in the reduction of ptep_get() calls and the reduction of TLB
>> flushes during contpte-unfolding, on arm64.
>>
>> No regression is observed on 4K folios on x86 too.
>>
>> ---
>> Applies on mm-unstable (24231596edf2).
> 
> Hi Dev,
> 
> Most of this series touches rmap and core MM code, which now go
> through the new MM core tree:
> 
> T: git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next

Oh I just saw the update in MAINTAINERS, thanks for informing didn't know
about this. I'll send v5.


> 
> So, it would probably be better to base the next version on this rather than mm-unstable.
> 
> Thanks,
> Shivank
> 
>>
>> mm-selftests pass.
>>
>> This breakout patchset is the final completion of
>> https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/
>>
>> The extra addition is the generic set_softleaf_ptes() helper.
>>
>> v3->v4:
>>  - Make page_anon_exclusive_batch return the exclusivity instead of
>>    computing that in the caller
>>  - Make ttu_anon_folio() return the number of unmapped pages, to simplify
>>    the code
>>
>> v2->v3:
>>  - page_anon_exclusive_batch returns unsigned long, shift to rmap.h
>>  - Drop a para in description of patch 5, use softleaf_is_swap to gate
>>    pte_swp_exclusive
>>  - finish_folio_unmap -> finish_folio_unmap_batch
>>  - Add patch 9 to do batching for sparc
>>    
>> v1->v2:
>>  - Add WARNs for folio span in folio_*_swap_pages
>>  - Trivial changes to page_anon_exclusive_batch
>>  - Add two sanity checks in patch 4
>>
>> Dev Jain (9):
>>   mm/swapfile: add batched version of folio_dup_swap
>>   mm/swapfile: add batched version of folio_put_swap
>>   mm: move anon-exclusive batch helper to rmap.h
>>   mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
>>   mm/internal: rename swap offset helpers to softleaf offset
>>   mm/internal: add set_softleaf_ptes
>>   mm/memory: use set_softleaf_ptes for uffd-wp markers
>>   mm/rmap: batch unmap anonymous swap-backed large folios
>>   mm, sparc: batch arch_unmap_one()
>>
>>  arch/sparc/include/asm/pgtable_64.h |  10 ++-
>>  arch/sparc/kernel/adi_64.c          |  21 +++++
>>  include/linux/pgtable.h             |   6 +-
>>  include/linux/rmap.h                |  76 ++++++++++++++----
>>  mm/internal.h                       |  64 +++++++++++----
>>  mm/memory.c                         |  23 +++---
>>  mm/mprotect.c                       |  25 +-----
>>  mm/rmap.c                           | 119 ++++++++++++++++++++--------
>>  mm/shmem.c                          |   8 +-
>>  mm/swap.h                           |  35 +++++++-
>>  mm/swapfile.c                       |  39 +++++----
>>  11 files changed, 289 insertions(+), 137 deletions(-)


