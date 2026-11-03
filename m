Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76675606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUJDQHxx
Received: by kanga.kvack.org (Postfix)
	id 8BEE96B05B6; Tue,  3 Nov 2026 14:11:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D046B05B7; Tue,  3 Nov 2026 14:11:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7370F6B05B8; Tue,  3 Nov 2026 14:11:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F99F6B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:11:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C9B171A053D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:11:19 +0000 (UTC)
X-FDA: 85394751078.17.CCBC9E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10A3A180006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:11:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUJDQHxx;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793733078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3QjwzbsFdeoVp3LN7SxevLjZAFhj9l1rD4OT4wwkMU=;
	b=SBZpLCa/nAKkVlft/wkaUwCW0qzXWekK9WjJhMEb5L/NDDPOHZL/k/SOnHVJQBv7OPDGxO
	1hZ+gKuw9jzSnKDL/stanQG+1EfcVrjOSj9E/8s+nPTnb7WaTssz5hCFLIlpq/vqpohiSW
	J0KFQU4AmW3RgaQlZO8iZ/KsJBEqckY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793733078;
	b=LOrUylma+tpfHUoV0cZKqanG8hWDmiDAsQm4BSSQcrGZT4rJyvhBoSA5VDtgCVHFmQ6SPv
	mOJt/W5TIUoD1mk+YSjzH2QeeiCvfyfPXRXeO8AmztPAZxoU7ygMB1Pnt/j6Vi7Uc87tBz
	49wqFm8J5P30h9M/nhmox/ydJ6SN96E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUJDQHxx;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40FE660609;
	Tue,  3 Nov 2026 19:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CDC1F000C1;
	Tue,  3 Nov 2026 19:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793733077;
	bh=a3QjwzbsFdeoVp3LN7SxevLjZAFhj9l1rD4OT4wwkMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kUJDQHxxQQf22ArBAZlAgbYiWfzYwIaC9MUZ260cmvU4xOvdTWva0gqQ6Fsc+ktgd
	 k3Ii8ClCfqPQZZNFkVQydDwe6bcL74X0FCdbyRfZbMUK96ji8sykhKLnBGeSmIrcTi
	 boXazygc4MDT4uukUCL4B6EOSSYN5iBrxey+jNGn5xcCNwMAsKufmomoqWoyAgMTVq
	 trudv+vwV139xtXJ3uhCWlDI+dJQlzkQb5gGfaeGN7WMCH66PqY3HDi2DqkfONGteC
	 BNXGTKqbQwkYBrJxfT9UZxnOERxAfxPBcVZOZh4zt/csUx/66O2HfQb5YbFRAaRWqU
	 WSy66sUTCkT9A==
Message-ID: <7c783937-f169-4b6f-92ff-17f8ef98ca95@kernel.org>
Date: Tue, 3 Nov 2026 20:10:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/47] mm: various (urgent?) fixes
To: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>, SJ Park <sj@kernel.org>,
 Chris Mason <mason@kernel.org>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Mani Tofigh <mt4022@columbia.edu>, Samiullah Khawaja <skhawaja@google.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <179344411888.15514.3120155844849052881.b4-ty@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179344411888.15514.3120155844849052881.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10A3A180006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: pxk7gmwwynwepstmhi8z8nzdy4pykqoh
X-Rspam-User: 
X-HE-Tag: 1793733077-200227
X-HE-Meta: U2FsdGVkX1+AGMiDwcB8lSSKSaA6OMaM50vB1CxnZOmu0/ogfU/hxz9jXQZCCAsBAR3fCJqny2Tl3NoZx8K7OyUk5WYtzmY3ZmT5heXJhY4VrSqdu//Et6elygIJeakuuwy98wSWLjhCGIz7VSCahefCZnTib+4hENxLng5tvNO0yjoGwndRiQdfCHkMlMdGN1R1yDpBGDiadouBA5+TcxtRaARUe/G8dPPJHP/qq7TeusAWkkNVCJ9TyvpOyhwoGBX38p/b7PG2Q9qG6PlSjxXGbtUiyshznPNpqsraGlJGZGccIQhy1S4bzaemGGn6S/zYo4U2cYLSLt0ZAap4rgmYYrK+UuTm+7GK0tcLKT2P6nerp9Fn4gGW1LhyCU1I8I3rn/gLU2mLoDP/F6xZ4uwd5A75KKcT03AGpWw6QSau8Esdvw+Kv9didONo8OQHzgq+EpAJwQ+R5WdLZwpOU3FspsCNJK/QkOoT/D69YzxprZJ+FYift6rRK6OV5d0DeeBJblNpcAG3jDRM8NAy3K2oXbrW3+ZACNAs8C2NUx/KyiSvvfhfMcllEO+On74YLSb1TIlnMMmiVC0GkA3EGfC6UNJCbbM49QFE7dxup/vBHNHs4ppeGCtmUYAzlDJqVUPHr2cDlulYp2VWlF+GyF2CXIO5Kbv/dzn3aJbV7ZzP18Bi6u1uSmUyZtVTn+4t5AwnylJ6uI9B9BQSEYHQi5tr8Ye+NUoZrczqBPqgUTdoyLWse2YR3eHgYSs6Nrm0kmUcq4sciafz6Au5jcyir2SWIe5cJrH72IjcdYJw5wvPbwYqUl4D4OcGrdHLEswjlcVbImMX00y6rLJnQi96XwzAAMSNn1qCt77e9n8l1Q7Zt2Vuq/4tObhE7EzGwfB1fONf+JlpwwgUONxqcq0ffJi05ZDJL8jGxoMPypU1FWblhwpkqImSNdVBGWwmvpxX9/TyvdC2ZNnUtl0vKVr
 qT4dHcZK
 jxeLo2c/QXpoZ7igDDnUvCaj0mC4QW/+3WMHRsQ/0+iY5S587EmY2sR8ZCsI+vhIWDDHQVZacx32B9kUvcIe7RZHYDCvy/p/YQUYJu/nQDmdrqeleLpfaPIrUJkmI+g71/aVInABCqRxfptAqJfrajTF+grrhk6oWm+zUjh4IlhYyUfS2EHIUNpSNv+W+8hnxxUG0yHLks/bPGCG6mR1fX364FvqkSNO3QNVcwJAK4vYxECe1gIh8zmKWPJNb1xCs7vHuYOGD2P8ctNPBMxZt1cDvbw5FBxoHn6Ijpx659sb225ya+HaXmgAAb3DLUanRG98Qi2Nt7pYB/MJYaP/GYGGcZJmdY1IDz9cwSOMB46gynVDVdkVEoAs6zcizk9ht26nzO4WjXhNdnQyTJTudidMahw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 11:55, David Hildenbrand wrote:
> On Sat, 31 Oct 2026 10:39:29 +0100, David Hildenbrand (Arm) wrote:
>> Thanks to everyone for the review! Hoping I can get some more? :)
>>
>> A quick resend, I'll queue these immediately after sending to get them
>> into -next asap. Don't let that discourage you from reviewing ;)
> 
> Applied, thanks!
> 
> tree: mm/core.git
> branch: for-next-fixes
> 
> Applied patches will appear soon in mm-next, followed by linux-next.
> 
> Please report any outstanding bugs that were missed during review, so we
> can either drop the patch series or decide how to fix it up.
> 
> It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
> though the patches have already been applied. If possible, patch trailers
> will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. Further, this is not a guarantee that the
> patches will go upstream. If in doubt, please check the listed branch.
> 

Small correction, I'll drop all that don't have CC:stable from the
for-next-fixes branch and queue them ordinarily for the next merge window. Which
is relevant for ...


> [01/47] mm/mglru: don't use stack pointers when walking PUD and PMD tables
>         https://git.kernel.org/mm/core/c/3922fe76
> [02/47] fork: take mmap_lock before copying mm_struct
>         https://git.kernel.org/mm/core/c/6cf33ce8
> [03/47] mm/shmem: make shmem_file() check the file's inode
>         https://git.kernel.org/mm/core/c/d6003145
> [04/47] mm/memfd: make f_pos accesses atomic
>         https://git.kernel.org/mm/core/c/b6638250
> [05/47] mm/truncate: look again if a folio left the mapping
>         https://git.kernel.org/mm/core/c/e7086d79
> [06/47] mm/filemap: read mapping->a_ops->free_folio under i_lock
>         https://git.kernel.org/mm/core/c/c9073948
> [07/47] mm/filemap: don't lose a folio lock wakeup to a signal
>         https://git.kernel.org/mm/core/c/c39c22f2
> [08/47] mm/filemap: finish fault cleanup before dropping the fault lock
>         https://git.kernel.org/mm/core/c/335429f6
> [09/47] mm/rmap: handle device-exclusive entries in folio_referenced_one()
>         https://git.kernel.org/mm/core/c/6324d435
> [10/47] mm/huge_memory: fix list corruption when deferred_split_scan() races with deferred_split_folio()
>         https://git.kernel.org/mm/core/c/be9ec969
> [11/47] mm/huge_memory: properly handle refcounted PUD mappings on fork
>         https://git.kernel.org/mm/core/c/1ef69272
> [12/47] mm/huge_memory: fix livelock on device private folio
>         https://git.kernel.org/mm/core/c/88ee4890

This one

> [13/47] mm/huge_memory: fix truncate racing with PMD zapping
>         https://git.kernel.org/mm/core/c/a63ff7ba
> [14/47] mm/huge_memory: fix zapping migration entries for device-private THPs
>         https://git.kernel.org/mm/core/c/2814cce8
> [15/47] mm/khugepaged: always recheck the pmd in try_collapse_pte_mapped_thp()
>         https://git.kernel.org/mm/core/c/17382ca5
> [16/47] mm/khugepaged: fix PMD table lock leak in try_collapse_pte_mapped_thp()
>         https://git.kernel.org/mm/core/c/bf852461
> [17/47] mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs
>         https://git.kernel.org/mm/core/c/299b8524
> [18/47] mm/khugepaged: check if PTE table is empty in try_collapse_pte_mapped_thp()
>         https://git.kernel.org/mm/core/c/22b08cd1

This one

> [19/47] mm/gup: recheck the PUD under PTL in follow_pud_mask()
>         https://git.kernel.org/mm/core/c/e04a9b5e
> [20/47] mm/gup: fix clearing folios in memfd_pin_folios()
>         https://git.kernel.org/mm/core/c/c6791388
> [21/47] mm/gup: fix out-of-bounds write for nr_pages == 0 in GUP-fast
>         https://git.kernel.org/mm/core/c/5b1b815c
> [22/47] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
>         https://git.kernel.org/mm/core/c/8791ac0a
> [23/47] mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
>         https://git.kernel.org/mm/core/c/35f48d65
> [24/47] mm/userfaultfd: wake all waiters on unregister
>         https://git.kernel.org/mm/core/c/9e4d60fe
> [25/47] mm/userfaultfd: wake waiters when registration modes are removed
>         https://git.kernel.org/mm/core/c/a9cba229
> [26/47] mm/userfaultfd: compare exact registration modes before skipping
>         https://git.kernel.org/mm/core/c/86de3945
> [27/47] mm/mmu_gather: fix flushing ranges with 4 GiB or larger
>         https://git.kernel.org/mm/core/c/61437375
> [28/47] mm/mmu_notifier: finish non-blocking interval invalidation on error
>         https://git.kernel.org/mm/core/c/ec3feff7
> [29/47] mm/mmu_notifier: set ->mm only after mmgrab()
>         https://git.kernel.org/mm/core/c/10ad9b99
> [30/47] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
>         https://git.kernel.org/mm/core/c/f16f7e7c
> [31/47] mm/mremap: recheck PUDs under the page table lock
>         https://git.kernel.org/mm/core/c/ae414aed
> [32/47] mm/mremap: fix moving PUD leaves
>         https://git.kernel.org/mm/core/c/262a6a25
> [33/47] mm/memory_hotplug: avoid races in pfn_to_online_page() with dying pgmap
>         https://git.kernel.org/mm/core/c/67782b68

This one

> [34/47] mm/madvise: fix data loss from MADV_FREE on a KSM page
>         https://git.kernel.org/mm/core/c/4fc80184
> [35/47] mm/memory: reject remote COW faults on PFN mappings
>         https://git.kernel.org/mm/core/c/99e96e4d
> [36/47] mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
>         https://git.kernel.org/mm/core/c/1ca84b58
> [37/47] mm: fix unkillable fault loop on MAP_DROPPABLE memory
>         https://git.kernel.org/mm/core/c/a4c8fb4f
> [38/47] mm: fix deadlock of mremap() against UFFDIO_MOVE
>         https://git.kernel.org/mm/core/c/55f62b5f
> [39/47] mm/ksm: reset the unstable trees of all nodes
>         https://git.kernel.org/mm/core/c/9c1d2a06
> [40/47] mm/ksm: fix use of a freed anon_vma at swap-in
>         https://git.kernel.org/mm/core/c/9c20c73c
> [41/47] mm/ksm: check large swap-cache folios before mapping them
>         https://git.kernel.org/mm/core/c/7fa9d8cb
> [42/47] mm/vma: call ->may_split() before a partial merge
>         https://git.kernel.org/mm/core/c/e0b967df
> [43/47] mm/huge_memory: split huge PUDs when adjusting VMA boundaries
>         https://git.kernel.org/mm/core/c/0653a27f
> [44/47] mm/vma: don't leak the charge for stack growth
>         https://git.kernel.org/mm/core/c/a8ebd75d
> [45/47] mm/cma: don't release CMA pages still in use
>         https://git.kernel.org/mm/core/c/d7950ad4
> [46/47] mm/memory-tiers: unregister empty tiers outside memory_tier_lock
>         https://git.kernel.org/mm/core/c/b6d7ad49
> [47/47] fs/proc/task_mmu: refuse addresses beyond 32 bits on 32bit
>         https://git.kernel.org/mm/core/c/021ea6d2

This one

-- 
Cheers,

David

