Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099B4606A322
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZVih8RK
Received: by kanga.kvack.org (Postfix)
	id 2CD906B05B3; Sat, 31 Oct 2026 06:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F046B05B4; Sat, 31 Oct 2026 06:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E5B6B05B5; Sat, 31 Oct 2026 06:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCBF46B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:55:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C8A7808B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:55:36 +0000 (UTC)
X-FDA: 85382615472.01.6020599
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2C24120002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:55:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hZVih8RK;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793444134;
	b=V529XIU2SwMCrNsCySZ4SVQqoGH+oIXK+V9J/e1Ulwq+FfZKQxEdxcsZ4ESQrkyWOco19a
	FZe6kh9SCmbIH73uCLqnstK/FLAemue+yRv5J2T12scgu/u/v4pMYwgysQ4b82Q82TSzTL
	QxaiutVLSsEdc3gKen/kDjU/UR2x9WI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hZVih8RK;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793444134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kf7DHW+HPMG6HKkFPWFn96X9OnxzATvopEw39adSoAw=;
	b=Srs15wuvAi7vIpGFy2+qc//rpTcKqfowSeMcTxYRhrMi9g89d4Anl+VIO8t4I9z7DcK0A6
	H/OdiMwaDcpLF+Qk9WOJ+n0m5vvmCkz9jFxVaZaw0LmGUrSW1mkWaKWhhjB0K0TTyFzwAJ
	JRmPHgURGKjvVqgHyyf73WuoGiuFHbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1489600AA;
	Sat, 31 Oct 2026 10:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E14E1F000C1;
	Sat, 31 Oct 2026 10:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793444133;
	bh=kf7DHW+HPMG6HKkFPWFn96X9OnxzATvopEw39adSoAw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hZVih8RKW7+5gqeTqGdWFckbkE1fBUoRpN0Yf0ztRjkuk4YcZRZ4SSexv/PHbbF0M
	 Iw/MDy6ZJVau5vIvy4d9TQWjFHxgzfqg7bAxcQxHH7309wEJ+KyA/WF+gb8Ma44Loc
	 9wYsFL/TYaZFnAgSNIladW1t5k5pX9s2HV/slhp4sv/yPogd5Np88XzSI7K6yxbGiR
	 U+XWdtKEx3lD/aDZfVO3Mxo7uGmn9jDQqnBS3Zl7IX2O1Y8pWhA/5Ptf4nkgq+Aof7
	 Kos1TmRXkKGX3i46dfJQXPVPBQJTav6JodXebp2iYW9yajnhsPGigGBu9AbiWXzfC9
	 hTLYOZQ3crkbA==
From: David Hildenbrand <david@kernel.org>
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, SJ Park <sj@kernel.org>, 
 Chris Mason <mason@kernel.org>, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
 Mani Tofigh <mt4022@columbia.edu>, Samiullah Khawaja <skhawaja@google.com>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
Subject: Re: [PATCH v3 00/47] mm: various (urgent?) fixes
Message-Id: <179344411888.15514.3120155844849052881.b4-ty@b4>
Date: Sat, 31 Oct 2026 11:55:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Queue-Id: B2C24120002
X-Stat-Signature: eramrajhp1zb3hngkkenxpguyxdab7u5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793444134-152436
X-HE-Meta: U2FsdGVkX18+uf/9UxTMtSWS851IbJ7tey2S8gz1tc4TdDqF0Ff0kj+e88ov5q5c6QR3VF2JUBW94vhRP7AuQ8iHor/sdQ3c+7rGxzAh4mPgZnCFHgitym/UglGuxtadb4kXXDv/CNxTqGQ5lqoM1ZDJGCvMGAZxlI2UbVwWPQfvBC3ThQSnT4W0zd92sPJkfY+ZEZurekieX74F9VamxhdA7Wr7yELMM+OLyTeD2uembgROwx/iOcPrWTegbCzvok6iaLMd0HSCenRmt5N9GQahEjDwsGEdbqJGjwL5hzhrAlOR1cVfUh8IUUSCCXcy2+agK/FlPf6+tB8UhLcaCjCIfU01iYVIF2M8Yjzu5edg4+9SjnXjxftJoEB42TtBXLuGhGP9sY6qXtk+Xt9ddVWDuFjnFYnmN7BhV2ZNnvXih4hLK7UJ7Hu6zoGDjf1+PUXVmWl2zVDpqu3C6jT97osnb9bB3hOj5uC36bvQlmvRvxEwYRNDzAXEaO7hU6wOFOkbyFvdCG0MVfr17zpVeS1cAGIHMCA7/1w7S65N51PVHY1EycZ0oFLWzy8M3V/sE2YXZBNIKR5A/ANvo1NywRT00S5ffP30lvgUWKfcGgsrFWJgIdY58fVslcatVgkq7lCsey5mb96xTLtJuremlT9N8YlEzwMQMdB30XYwwkZlcDXbDabaUtNzBlKAmaNS/A9aqYDn+AwCgx9JX5Vqw86p6O68q70FNK3ie5LTTk4wMvSGJdMFn8Fq97FRBAFGY2ZH7yJZNmEpAdSedlZUuQo2Y7JTh4p0AFfRcIOsT+q9NHxGpZEY8RHh4niyKPOEx3Bl1AIvokRxZeLmTB12Pf8KeX5Q54pYz1oAecqHCksjK6+wRv/9odG25OwJ6eixgzdesFU7L1eCjuqtN3oeczp4x9Zq+4EEO4w9pEW670NsDhLbRmWTQUVZJ3q0YbelQKltYKOfBK4++4s7jEt
 xvuuq2J+
 hELBgbeUYl4tHuLZCwMnjyG4A7I2jmr5NWM1xwvv9Endr0Se9yMdru/VsLTOqwB+/Yfi2XZGwOqsIdG2YiJxsJtPmvKd96rMM5qlKPSPACTOxtbdzR8Pecb2Se6XqSSYDrzNLR5v8Uy4E9ZTw8kEjCTbWn6PqiGGtGkNC3EMBZRZOQJvmgh0Ntg704Hi7TvzNd3RNArlxNydreb0zcjsFeZmc8Xzs5qywEpuPcr9wj5fcpF5Ot0WlqGhsavvgTzI79M15v2XTtsr9mdphq182MnmZAqOK1wJGwErS7xmAxjye1HkGUfPsubq/XkbNtqYckTc4ZZYfSyoaLiS6OIcTrsrvo1h028ezqThiVpC0Zclp5Vs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 10:39:29 +0100, David Hildenbrand (Arm) wrote:
> Thanks to everyone for the review! Hoping I can get some more? :)
> 
> A quick resend, I'll queue these immediately after sending to get them
> into -next asap. Don't let that discourage you from reviewing ;)

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[01/47] mm/mglru: don't use stack pointers when walking PUD and PMD tables
        https://git.kernel.org/mm/core/c/3922fe76
[02/47] fork: take mmap_lock before copying mm_struct
        https://git.kernel.org/mm/core/c/6cf33ce8
[03/47] mm/shmem: make shmem_file() check the file's inode
        https://git.kernel.org/mm/core/c/d6003145
[04/47] mm/memfd: make f_pos accesses atomic
        https://git.kernel.org/mm/core/c/b6638250
[05/47] mm/truncate: look again if a folio left the mapping
        https://git.kernel.org/mm/core/c/e7086d79
[06/47] mm/filemap: read mapping->a_ops->free_folio under i_lock
        https://git.kernel.org/mm/core/c/c9073948
[07/47] mm/filemap: don't lose a folio lock wakeup to a signal
        https://git.kernel.org/mm/core/c/c39c22f2
[08/47] mm/filemap: finish fault cleanup before dropping the fault lock
        https://git.kernel.org/mm/core/c/335429f6
[09/47] mm/rmap: handle device-exclusive entries in folio_referenced_one()
        https://git.kernel.org/mm/core/c/6324d435
[10/47] mm/huge_memory: fix list corruption when deferred_split_scan() races with deferred_split_folio()
        https://git.kernel.org/mm/core/c/be9ec969
[11/47] mm/huge_memory: properly handle refcounted PUD mappings on fork
        https://git.kernel.org/mm/core/c/1ef69272
[12/47] mm/huge_memory: fix livelock on device private folio
        https://git.kernel.org/mm/core/c/88ee4890
[13/47] mm/huge_memory: fix truncate racing with PMD zapping
        https://git.kernel.org/mm/core/c/a63ff7ba
[14/47] mm/huge_memory: fix zapping migration entries for device-private THPs
        https://git.kernel.org/mm/core/c/2814cce8
[15/47] mm/khugepaged: always recheck the pmd in try_collapse_pte_mapped_thp()
        https://git.kernel.org/mm/core/c/17382ca5
[16/47] mm/khugepaged: fix PMD table lock leak in try_collapse_pte_mapped_thp()
        https://git.kernel.org/mm/core/c/bf852461
[17/47] mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs
        https://git.kernel.org/mm/core/c/299b8524
[18/47] mm/khugepaged: check if PTE table is empty in try_collapse_pte_mapped_thp()
        https://git.kernel.org/mm/core/c/22b08cd1
[19/47] mm/gup: recheck the PUD under PTL in follow_pud_mask()
        https://git.kernel.org/mm/core/c/e04a9b5e
[20/47] mm/gup: fix clearing folios in memfd_pin_folios()
        https://git.kernel.org/mm/core/c/c6791388
[21/47] mm/gup: fix out-of-bounds write for nr_pages == 0 in GUP-fast
        https://git.kernel.org/mm/core/c/5b1b815c
[22/47] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
        https://git.kernel.org/mm/core/c/8791ac0a
[23/47] mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
        https://git.kernel.org/mm/core/c/35f48d65
[24/47] mm/userfaultfd: wake all waiters on unregister
        https://git.kernel.org/mm/core/c/9e4d60fe
[25/47] mm/userfaultfd: wake waiters when registration modes are removed
        https://git.kernel.org/mm/core/c/a9cba229
[26/47] mm/userfaultfd: compare exact registration modes before skipping
        https://git.kernel.org/mm/core/c/86de3945
[27/47] mm/mmu_gather: fix flushing ranges with 4 GiB or larger
        https://git.kernel.org/mm/core/c/61437375
[28/47] mm/mmu_notifier: finish non-blocking interval invalidation on error
        https://git.kernel.org/mm/core/c/ec3feff7
[29/47] mm/mmu_notifier: set ->mm only after mmgrab()
        https://git.kernel.org/mm/core/c/10ad9b99
[30/47] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
        https://git.kernel.org/mm/core/c/f16f7e7c
[31/47] mm/mremap: recheck PUDs under the page table lock
        https://git.kernel.org/mm/core/c/ae414aed
[32/47] mm/mremap: fix moving PUD leaves
        https://git.kernel.org/mm/core/c/262a6a25
[33/47] mm/memory_hotplug: avoid races in pfn_to_online_page() with dying pgmap
        https://git.kernel.org/mm/core/c/67782b68
[34/47] mm/madvise: fix data loss from MADV_FREE on a KSM page
        https://git.kernel.org/mm/core/c/4fc80184
[35/47] mm/memory: reject remote COW faults on PFN mappings
        https://git.kernel.org/mm/core/c/99e96e4d
[36/47] mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
        https://git.kernel.org/mm/core/c/1ca84b58
[37/47] mm: fix unkillable fault loop on MAP_DROPPABLE memory
        https://git.kernel.org/mm/core/c/a4c8fb4f
[38/47] mm: fix deadlock of mremap() against UFFDIO_MOVE
        https://git.kernel.org/mm/core/c/55f62b5f
[39/47] mm/ksm: reset the unstable trees of all nodes
        https://git.kernel.org/mm/core/c/9c1d2a06
[40/47] mm/ksm: fix use of a freed anon_vma at swap-in
        https://git.kernel.org/mm/core/c/9c20c73c
[41/47] mm/ksm: check large swap-cache folios before mapping them
        https://git.kernel.org/mm/core/c/7fa9d8cb
[42/47] mm/vma: call ->may_split() before a partial merge
        https://git.kernel.org/mm/core/c/e0b967df
[43/47] mm/huge_memory: split huge PUDs when adjusting VMA boundaries
        https://git.kernel.org/mm/core/c/0653a27f
[44/47] mm/vma: don't leak the charge for stack growth
        https://git.kernel.org/mm/core/c/a8ebd75d
[45/47] mm/cma: don't release CMA pages still in use
        https://git.kernel.org/mm/core/c/d7950ad4
[46/47] mm/memory-tiers: unregister empty tiers outside memory_tier_lock
        https://git.kernel.org/mm/core/c/b6d7ad49
[47/47] fs/proc/task_mmu: refuse addresses beyond 32 bits on 32bit
        https://git.kernel.org/mm/core/c/021ea6d2

-- 
Cheers,

David


