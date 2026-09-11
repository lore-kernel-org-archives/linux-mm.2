Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5AB5C88E59
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE146B0096; Fri, 11 Sep 2026 13:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4926B0098; Fri, 11 Sep 2026 13:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A3A6B0099; Fri, 11 Sep 2026 13:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A16BF6B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:10:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B29C01602D2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:19 +0000 (UTC)
X-FDA: 85202119758.22.B78D7C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D784E18000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijM28yeS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789146618;
	b=5F9Ylk8bUPSUi90cuno0jBKR+3/rCp7/t1Juj4WmP1dfyctw4sMbRkxjVZLjKLpVsSsMBe
	RpE4qIzHIjl9TUHuRhyHegmH39KsujFjW1QDwqVc4eoH+Uk/htpI/RV7ZYJLKdykVjNvfW
	4HD8qTxlqujwCVn5w2Iul7frwUUJC7M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijM28yeS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9/6KbXsN5PKvzZs2esn/AhPtSfdFVVRLNXzVuGAieA=;
	b=YjCZnY+d34btY068s6IRNYJHc4OQY7NKsvWR1EpKQGdwprxtTjaZjy1qKWTCbUVJmLaMUt
	UK2EezD/i6M1ChLCCHYSxwFIvUVa869zVHvhpImZCEmQlOkE7iv1SVmQY5k3M0goJ/Yz0Z
	6y5GG4A512BCruBfhkQtz969QkZDFEs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8DCD4067A;
	Fri, 11 Sep 2026 17:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF04C1F00893;
	Fri, 11 Sep 2026 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789146616;
	bh=s9/6KbXsN5PKvzZs2esn/AhPtSfdFVVRLNXzVuGAieA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ijM28yeSeyX61csI7of/aYV6Iu23+fQwE2+XMHuORDOd9Q58+YKhljzXl+IBz4Fum
	 GTMuOS39dD0b/3zG27EdOqjAkusXj6vqwIKDQom13aNYWLtWjARY8yD4Fc6x0WSfAd
	 5HAYNkwusAIKERa3WHgLnp9dbK4wyC6PAL6LjnODK0XIQGto7t/yd8GJT72smbQhyu
	 OzZ3q1/AtOHdfG+oKc4RjaNN9Ctxu4fwIB3/CiLYKdFCtFfw3NRb+woAMvc191s+Fq
	 6WOJgh4F2SXLfO/k1FpUXsN9xExTqEQkHaoouynhFq/HctD3ifs1J/7Tb6gKYO0V6p
	 uNN1MzB53btqw==
Message-ID: <0a4fd9e1-3e7d-4910-99ee-6f6f89b5ca93@kernel.org>
Date: Fri, 11 Sep 2026 19:09:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] mm: use hw_pte_t for generic PTE table storage
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <20260903103002.1091859-4-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903103002.1091859-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D784E18000D
X-Stat-Signature: dni8n1gbbybsqoet8r3tz51so3r9brt7
X-HE-Tag: 1789146617-826727
X-HE-Meta: U2FsdGVkX1873180tIHUJfnN9S20rREZJ77Qlii/de06JBu3A7UsUYR39cRn3BESUUvFfDCTNMxJlrPQBjHAU/9b/uvb0artvmTnXHSSc59PqX93bZs3QW/RnnXDAdz0y61IsbSLLGcigNvavefY4YjKU/1jHNRVwVpFfE38hXrwc+L3Oe0uhHwCHUr9DCloPc69tqWzfaY/VZMz7JIDA6t+/TqqW6DxEZUEX7XinHOShRrdTOT0BYGO7Wx3SXWruQn2h2lXjm+eE5jr+p0h96RZIotpIp9BSx16RKD5tbwPYjohG8bOakpnojVVIbf6eSHfMCym17CGvMwRH4IcaSNVyvQSbQcjOCOyuzbt4qm9IiRG5QftdKPuJ5FfPG6qtOa0MViRy2QLbXVjg6Kittv1bFwCXyHnGxNu4fTrga5IiG/eC7SN+YexUedrKNPqnmKnLVm8QpbzPGyue0wGF6kpeP04qxbDfDZwH+mXdnA6wAdHzIUZNQF862OtjNQZiPuM8GRqnR2zdkUjYRqBP2LguhSSESKBjrdqvLEGp0af1hcrg13tuAC7245AwqAwxOF4K0j2MQrW5wgeBDRRpz01zAglKBkFhPIPjPyYZuNqqmNHQeqzux1TeB8zTLs9Nh9liYM0h8f8HeUDNcfBguNmfPNaMQqIvsV7aL+QqYEZYAUqRai2Y3UDLCGzxFYEiWp5sCX3i97ATaStE3onZF9suKGsgRrL0CqG1rTKpnmgfA3ZEO0oeWaiY3K/nJAweuC0j/P5bnQuguZCmbbulx1U5tVZ2EadrLMMRhrqtwjwtrTLdKq1zIOhcd4NJRVCAkJ6QnhFLSTb/DcYB5Ojl4RRtCGhfh138PDmEpHWw/nDLlOd1DZhKiH9tuQUZCsCMRqo7LzrcPdjuP1jxlBtYZBigUB7gByrXHnd9DmGlGkbx48ZDhZgxTIIIHkbvq9vAqLODFdacijVIRb6tyH
 xHCZY8SU
 YRrEjumptB/EhvPjZ/0WXUa47T8AriE/xCmPCqagTFK7CxPaXIHUzqSRFnQygcUMybmVOYOubHcMQq4+ry2oZdBsBHInite0dYFbPvgntdSnlM4pbLnb6+s1mX3Bp1GzTkhGH3MVg+CJ0JOA6orI24w3qnbb1j0VwTRzAZaH6guFaxLYsKbVq9IKmZ9ciVObd9djOVRa/zoQJv876rzyopTojGG1ghhy+d7/QYglmrdt1Kgb6ClhIaBzYnjGNsk8nNRFUw3N7129jcNvKtILca7X2e7r+UgKQAVclHfzp/BN2zHVYoFQrnIAmizrWJAGH2rxo4WAF7ZQuckE974XanEdzcNCjSqAOkk4HOs3wC9ZfM1VS3z3li6bSZs8m0TjNORXeWDuft02WqoihNmZ8pkE7+x8lmWD3IvVnGMDIxe3nfHZsWQVvHl50c7tZbZ1jaGd7GXPTIhD+MDPEb4g4T/lWEY34Hcue+lRL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 12:29, Muhammad Usama Anjum wrote:
> Generic page-table interfaces use pte_t * for both pointers to PTE table
> storage and pointers to software PTE values. Convert the generic
> declarations and their MM, fs, and kernel users together so parameters,
> return types, callbacks, and local pointers that designate table storage
> use hw_pte_t *.
> 
> Include linux/pgtable_types.h from headers that expose the converted
> interfaces. It continues to provide pgprot_t to vmalloc.h through
> asm/page.h.
> 
> Keep software PTE values as pte_t and retain pte_t * for value interfaces.
> 
> No architecture selects ARCH_HAS_HW_PTE_T at this point, so hw_pte_t
> remains an alias of pte_t and this changes the interface vocabulary without
> changing representation or behavior.
> 
> Most of this mechanical conversion was generated with the Coccinelle script
> included in the cover letter. The script deliberately ignores pte_t *
> pointers named ptentp because they designate software PTE values. The
> result was then audited, and sites the script could not convert were
> updated by hand.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Fold the header includes into their first user instead of keeping a
>   stand-alone preparation patch.
> - Rebase onto mm-new and rerun the Coccinelle script.
> - Use software PTE value terminology.
> 
> Changes since RFC v1:
> - Clarify that linux/pgtable_types.h provides both generic hw_pte_t
>   definitions.
> - Clarify that the distinct generic definition is activated by an
>   architecture opt-in.
> ---
>  fs/hugetlbfs/inode.c             |  3 +-
>  fs/proc/task_mmu.c               | 33 ++++++-------
>  include/asm-generic/hugetlb.h    | 15 +++---
>  include/asm-generic/pgalloc.h    |  6 +--
>  include/asm-generic/tlb.h        |  5 +-
>  include/linux/hugetlb.h          | 50 +++++++++++---------
>  include/linux/mm.h               | 26 +++++------
>  include/linux/page_table_check.h | 10 ++--
>  include/linux/pagewalk.h         |  8 ++--
>  include/linux/pgtable.h          | 79 +++++++++++++++++---------------
>  include/linux/rmap.h             |  2 +-
>  include/linux/swapops.h          |  6 ++-
>  include/linux/vmalloc.h          |  4 +-
>  include/trace/events/xen.h       | 10 ++--
>  kernel/bpf/arena.c               |  9 ++--
>  kernel/events/core.c             |  3 +-
>  mm/damon/ops-common.c            |  2 +-
>  mm/damon/ops-common.h            |  2 +-
>  mm/damon/vaddr.c                 | 20 ++++----
>  mm/debug_vm_pgtable.c            |  2 +-
>  mm/filemap.c                     |  4 +-
>  mm/gup.c                         |  9 ++--
>  mm/highmem.c                     | 15 +++---
>  mm/hmm.c                         |  6 +--
>  mm/huge_memory.c                 |  4 +-
>  mm/hugetlb.c                     | 60 ++++++++++++------------
>  mm/hugetlb_vmemmap.c             | 13 +++---
>  mm/internal.h                    | 16 +++----
>  mm/kasan/init.c                  | 12 ++---
>  mm/kasan/shadow.c                |  6 +--
>  mm/khugepaged.c                  | 50 ++++++++++++--------
>  mm/ksm.c                         |  7 +--
>  mm/madvise.c                     | 14 +++---
>  mm/mapping_dirty_helpers.c       |  4 +-
>  mm/memory-failure.c              |  6 +--
>  mm/memory.c                      | 78 ++++++++++++++++---------------
>  mm/mempolicy.c                   |  4 +-
>  mm/migrate.c                     |  4 +-
>  mm/migrate_device.c              |  4 +-
>  mm/mincore.c                     |  4 +-
>  mm/mlock.c                       |  4 +-
>  mm/mprotect.c                    | 19 ++++----
>  mm/mremap.c                      |  4 +-
>  mm/page_table_check.c            |  4 +-
>  mm/pagewalk.c                    |  9 ++--
>  mm/percpu.c                      |  2 +-
>  mm/pgtable-generic.c             | 20 ++++----
>  mm/ptdump.c                      |  2 +-
>  mm/rmap.c                        |  6 +--
>  mm/sparse-vmemmap.c              | 22 ++++-----
>  mm/swap_state.c                  |  3 +-
>  mm/swapfile.c                    |  5 +-
>  mm/userfaultfd.c                 | 32 +++++++------
>  mm/util.c                        |  2 +-
>  mm/vmalloc.c                     | 11 +++--
>  mm/vmscan.c                      |  6 +--
>  56 files changed, 410 insertions(+), 356 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7611a8470ea26..ddaab714c3e02 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -328,7 +328,8 @@ static void hugetlb_delete_from_page_cache(struct folio *folio)
>  static bool hugetlb_vma_maps_pfn(struct vm_area_struct *vma,
>  				unsigned long addr, unsigned long pfn)
>  {
> -	pte_t *ptep, pte;
> +	hw_pte_t *ptep;
> +	pte_t pte;
>  
>  	ptep = hugetlb_walk(vma, addr, huge_page_size(hstate_vma(vma)));
>  	if (!ptep)

This is interesting.

Assuming we'd had a hugetlb_hw_pte_t, we be able tojust naturally catch things
like using

	ptep_get()

instead of

	huge_ptep_get()

That caused bugs and headakes before.

But I'm not actually proposing that at this point, because it would make messed
up infrastructure where we hacked in hugetlb, like page_vma_mapped_walk() harder
to use.


Regarding this patch, I guess we'll regenerate it when the time comes. We
*might* have to do this stepwise.

E.g., merge patch #1 first, to then convert individual MM components. But we can
discuss that once the time comes.

-- 
Cheers,

David

