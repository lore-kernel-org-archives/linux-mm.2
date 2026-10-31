Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC199606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OAjcKwVv
Received: by kanga.kvack.org (Postfix)
	id 21E9F6B05B1; Sat, 31 Oct 2026 05:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF466B05B2; Sat, 31 Oct 2026 05:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BDA26B05B3; Sat, 31 Oct 2026 05:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD7A96B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:23:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71F7E1608F3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:23:49 +0000 (UTC)
X-FDA: 85382384178.06.823641F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C9FE31C000A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:23:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OAjcKwVv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0h426OykB98s1wG0wb0t2Zst/pVDPvkwxrUgrBydKV8=;
	b=JQWC9L5Z3vc8LVnzs25lpY+UQSNVSMQ6VfgtJaKH+fyoUloLPAZQ1n7BFag1O47xWBbvwN
	wbSpchl+0gI7G6jaHnD6yUe09gMTioegHY/1R/uL5lSCKPI2OA/xEDwiGDTO9s9UNa1dcn
	ibdHTsF5TcLopob2ix6ML0Hi8vfAbOk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OAjcKwVv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438627;
	b=dj6Bc9zDhKsQwjH40zJCaeohQagY3n7gpBTrHG+16c/MpSP4xe76Cj/38kxn96c2hwUqaD
	MZvEdrqeSCiuhZe2V5EWjCVql481T12DkO5JXW4oZOqUu5tMuVa1TURgbv1gM3BDJYyjzB
	N/btLtXYBI+GMyj3vJrHOVze/IycuQ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0288C600D4;
	Sat, 31 Oct 2026 09:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C3F1F000C1;
	Sat, 31 Oct 2026 09:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793438626;
	bh=0h426OykB98s1wG0wb0t2Zst/pVDPvkwxrUgrBydKV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OAjcKwVv2M19YSSTu/+mP0QtRKNzADA1hWg6jYEgBO1Z16UXnsySppwh2cny9ECDf
	 bCnlAXm3y9qPZpTPxehmYm1D8e7UEwAtNRSwwgob2sqmAKDxW5bBaCGyU6wipvWGA5
	 15YqyB45I+jSQG6O43F/qBpIrBcLx+B29+hSyzjIzN2E+ysf0GHvwGuEKCa1ndj7Se
	 gS9vwHliLHtBgqKaKgJTAnk7YEgwbiVq7RfFV1s4yKG/Ov/n94OX9x1hvPR3Y7F9a1
	 z8ITgdofD3AGj7C9U2NfqdOOEYkKakJvSJj/SBJIp/iu3z3+FVW1epbN+1unXHi9o4
	 Q1FoK8H6RM+VQ==
Date: Sat, 31 Oct 2026 09:23:31 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] MAINTAINERS: add missing files to MM component
 sections
Message-ID: <auWwWRcoNhuuDOY5@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-5-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-5-97278f8a5f54@kernel.org>
X-Rspamd-Queue-Id: C9FE31C000A
X-Stat-Signature: rr54rqofy88qm458p7rj68a4k36hts4y
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793438627-934796
X-HE-Meta: U2FsdGVkX197N+GgKwXklVKRkeJ2jBEB4gmZKHl6b5F/kTsDUPAuLaVrMO8YAsAQ+3rt4K1Tswla3Q/XVbFQDwdgKDmbdj1oOyLzuDwSvJUCcXUDpcAuuFxu/JzqGyFZChWeDM5C+PdEB1ITNXp7xhJD+AAPbQSlUK2iwlFLAHaEVHw6sU6BSQ8IuC3QBvqZxfxSMvp/6hC653T6pmz/QlkBLJKlK272vPkM95B14+/8Kl9ymauika0X1B5lZbG0qvGuR41zTifQhDpItAulVnoEisOK+hiPznNglirFTgeOAeT7m8ZUhAjCmIy7E0s2ZIMn9x29Qpwpu7TsdyTSoouDXthsRhTLZ2WhVnljGcQ0zJLHpdQYe0aTM3ZPLthDOo9yuoIy6eo+OPjwKnvb80CfOCmRv+RVR0jsq6jMafFQvxd0LegsOAJz+O+ti0CUOIdoSmXyvNK6EJ4FdZfkZdIFwsJv5oTVIPJpoDtrIOhNeGl29jb0quXf4bfLtal1ISCztREXsZMoNZXFzjuVF2lPVhN1vsGc7mA7nqE6Z1bQu9eJnsWxb2+2HLK8VrfJkOHXQnBv7wQBeZ7KMDbX4wNYEyQlyElugdb7Q25dKYNewOG2VW6JpxtxOL+03pA9rMZXpHRUYKKBzyrkRoHD56gkb+ae5QLc9n3dQqh0M7UvnFvVGDTG3T5n86kBXAD9OWuAYyIMG5PgByk2fM3Qe5qk7iGIGOCaP3ZVQ2KzwE6OzZ7pPfJlmFin4QQ22K5qQdMPwp48xhHf2/KZa2GQ0iDXTtXpeuO4qaTHjyxeSI0NbtRypCkyJ7yAhw0kG67pDRCpMaKPvTzaSM4D3YGa9oYctHs8EM0laaERUQgwdL5vEuwWlaEdI48XQs7VxVftKXCNeZq2gvvLSZsBGgOiAIF0lv9+xIG87Eo2itEyJtZhEfdbYlN2Kmm8hZbZk8NvJCqPMNcKQS96xMQjsYG
 tmPD+rra
 6AlHmfinJBmxR+qpIxBQ7zVaCVFGFkXo4lulyqAv4DmZLs60j1+E+8+Yq8DxIzVgIr+zMdBplZtJ9C/ukkKLApBbsAJ2UHw440zEM88nAK9um8e/iR4Rzzr+3jCwXf4j676vhG6Tbjwg1MryI388D5AbwqZEtmT7yaVKbFRXsTgmdXkdjcfLlAsl/iE8TlX8SuAA8Qjw/bQczRaAFO4A1PI6zUm8nJZDHaKw1zP+PuAX/4FZtYrkGHM13FH9YFEJVk3ljfhh+WExrjUAtDzD/c4Qq5Sjk+gRHs60XhnVTlju7xkgPE2L1UibGZ0etv2v+pZrjmGwNL59W611uznlaKXl/tOxFiBvGg9KqDDuNaSEM9lh2kCHFD92LhM4i1CSa2cOPswSIU+7vv1hVH5tdS5GyDpy4xu/zehuctV09qYH/J//3NI+yygLhWwskZWe0atW4UZuBb+jVK68JCLBfSNabJuRQTDZMKbnn8gIpEn/IPH6QFni/EjUQEVMgSDAlm+1gmYseUOv/5XvxCQEcx0+ahhFHo1xZR02vAZYbfRE+KJHwTyMCHRJ+wigRR3GpI+oF/ukzXXN099hZs1luVpALuiHiV/F3FJjULuyN7nUBz0CvBJVzHepGDgDWgmxR11Vt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:29PM +0100, David Hildenbrand (Arm) wrote:
> We want to make sure that MM components cover all relevant MM files. The
> generic "MEMORY MANAGEMENT" sections will probably go away at some
> point.

You mean MISC or the MEMORY MANAGEMENT - prefixes?

Latter are useful just for tracking what's mm in general I think but I guess
debatable.

'MEMORY MAPPING' of course breaks this rule :P

>
> We have a bunch of files that are not explicitly tracked under MM
> components. Let's add these missing files.
>
> Split up tools/mm to the appropriate components, but still add it also
> under MISC, similar to what we did with selftests.
>
> Don't split up selftests for now. They are covered by MISC and some
> sections name them separately.
>
> Some files like
>
>  - include/linux/numa.h
>  - include/trace/events/kmem.h
>  - Documentation/admin-guide/numastat.rst
>
> are a bit fuzzy. Add them to the best fit for now.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Nice, finishing my work for me, I like it ;)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bc82ef545e0aa..98948d159173b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6841,8 +6841,10 @@ R:	Muchun Song <muchun.song@linux.dev>
>  L:	cgroups@vger.kernel.org
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	Documentation/admin-guide/cgroup-v1/memory.rst
>  F:	include/linux/memcontrol.h
>  F:	include/linux/page_counter.h
> +F:	include/trace/events/memcg.h
>  F:	mm/memcontrol-v1.c
>  F:	mm/memcontrol-v1.h
>  F:	mm/memcontrol.c
> @@ -12349,6 +12351,7 @@ R:	David Hildenbrand <david@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
> +F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
>  F:	Documentation/admin-guide/mm/hugetlbpage.rst
>  F:	Documentation/mm/hugetlbfs_reserv.rst
>  F:	Documentation/mm/vmemmap_dedup.rst
> @@ -12360,6 +12363,7 @@ F:	mm/hugetlb.c
>  F:	mm/hugetlb_cgroup.c
>  F:	mm/hugetlb_cma.c
>  F:	mm/hugetlb_cma.h
> +F:	mm/hugetlb_internal.h
>  F:	mm/hugetlb_sysctl.c
>  F:	mm/hugetlb_sysfs.c
>  F:	mm/hugetlb_vmemmap.c
> @@ -12379,6 +12383,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
>  R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	Documentation/ABI/testing/sysfs-memory-page-offline
>  F:	include/linux/memory-failure.h
>  F:	include/trace/events/memory-failure.h
>  F:	mm/hwpoison-inject.c
> @@ -17424,6 +17429,7 @@ M:	Oscar Salvador <osalvador@suse.de>
>  L:	linux-mm@kvack.org
>  L:	linux-cxl@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/ABI/testing/sysfs-devices-memory
>  F:	Documentation/admin-guide/mm/memory-hotplug.rst
>  F:	Documentation/core-api/memory-hotplug.rst
>  F:	drivers/base/memory.c
> @@ -17480,10 +17486,13 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	Documentation/admin-guide/sysctl/vm.rst
> +F:	Documentation/core-api/gfp_mask-from-fs-io.rst
>  F:	fs/proc/meminfo.c
> +F:	include/linux/cacheflush.h
>  F:	include/linux/folio_batch.h
>  F:	include/linux/gfp.h
>  F:	include/linux/gfp_types.h
> +F:	include/linux/highmem-internal.h
>  F:	include/linux/highmem.h
>  F:	include/linux/leafops.h
>  F:	include/linux/memory.h
> @@ -17493,11 +17502,16 @@ F:	include/linux/mmdebug.h
>  F:	include/linux/mmu_notifier.h
>  F:	include/linux/mmzone.h
>  F:	include/linux/pagewalk.h
> +F:	include/linux/pfn.h
>  F:	include/linux/pgalloc.h
>  F:	include/linux/pgtable.h
>  F:	include/linux/ptdump.h
> +F:	include/linux/sched/mm.h
> +F:	include/linux/vm_event_item.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> +F:	include/trace/events/mmflags.h
> +F:	include/trace/events/pagemap.h
>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> @@ -17516,6 +17530,7 @@ F:	mm/ptdump.c
>  F:	mm/util.c
>  F:	mm/vmpressure.c
>  F:	mm/vmstat.c
> +F:	scripts/gdb/linux/mm.py
>  N:	include\/linux\/page[-_][a-zA-Z]*
>
>  MEMORY MANAGEMENT - EXECMEM
> @@ -17536,6 +17551,7 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/core-api/pin_user_pages.rst
>  F:	mm/gup.c
>  F:	mm/gup_test.c
>  F:	mm/gup_test.h
> @@ -17613,6 +17629,7 @@ W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/linux/migrate.h
>  F:	include/linux/migrate_mode.h
> +F:	include/trace/events/migrate.h
>  F:	mm/migrate.c
>  F:	mm/migrate_device.c
>
> @@ -17636,13 +17653,20 @@ F:	Documentation/admin-guide/mm/
>  F:	Documentation/core-api/memory-allocation.rst
>  F:	Documentation/core-api/mm-api.rst
>  F:	Documentation/mm/
> +F:	fs/proc/page.c
> +F:	include/linux/backing-dev-defs.h
> +F:	include/linux/backing-dev.h
>  F:	include/linux/cma.h
>  F:	include/linux/dmapool.h
>  F:	include/linux/ioremap.h
> +F:	include/linux/kernel-page-flags.h
>  F:	include/linux/page_idle.h
> +F:	include/trace/events/cma.h
> +F:	include/uapi/linux/kernel-page-flags.h
>  F:	mm/backing-dev.c
>  F:	mm/char-mem.c
>  F:	mm/cma.c
> +F:	mm/cma.h
>  F:	mm/cma_debug.c
>  F:	mm/cma_sysfs.c
>  F:	mm/dmapool.c
> @@ -17655,7 +17679,9 @@ F:	mm/page_idle.c
>  F:	mm/pgalloc-track.h
>  F:	mm/process_vm_access.c
>  F:	tools/lib/mm/
> +F:	tools/mm/
>  F:	tools/testing/selftests/mm/
> +X:	Documentation/ABI/testing/sysfs-kernel-mm-damon
>  X:	Documentation/admin-guide/mm/damon/
>  X:	Documentation/mm/damon/
>
> @@ -17665,6 +17691,7 @@ M:	Mike Rapoport <rppt@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
> +F:	include/linux/numa.h
>  F:	include/linux/numa_memblks.h
>  F:	mm/numa.c
>  F:	mm/numa_emulation.c
> @@ -17685,6 +17712,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
> +F:	Documentation/admin-guide/numastat.rst
>  F:	include/linux/memory-tiers.h
>  F:	include/linux/mempolicy.h
>  F:	include/uapi/linux/mempolicy.h
> @@ -17716,6 +17744,9 @@ F:	include/linux/compaction.h
>  F:	include/linux/gfp.h
>  F:	include/linux/page-isolation.h
>  F:	include/linux/pageblock-flags.h
> +F:	include/trace/events/compaction.h
> +F:	include/trace/events/page_isolation.h
> +F:	include/trace/events/page_ref.h
>  F:	mm/compaction.c
>  F:	mm/debug_page_alloc.c
>  F:	mm/debug_page_ref.c
> @@ -17732,6 +17763,9 @@ F:	mm/page_reporting.h
>  F:	mm/show_mem.c
>  F:	mm/shuffle.c
>  F:	mm/shuffle.h
> +F:	scripts/gdb/linux/page_owner.py
> +F:	tools/mm/page_owner_filter.c
> +F:	tools/mm/page_owner_sort.c
>
>  MEMORY MANAGEMENT - RECLAIM
>  M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -17743,6 +17777,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>  R:	Lorenzo Stoakes <ljs@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	include/trace/events/vmscan.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>
> @@ -17836,10 +17871,12 @@ F:	Documentation/admin-guide/mm/transhuge.rst
>  F:	include/linux/huge_mm.h
>  F:	include/linux/khugepaged.h
>  F:	include/trace/events/huge_memory.h
> +F:	include/trace/events/thp.h
>  F:	mm/collapse.h
>  F:	mm/huge_memory.c
>  F:	mm/khugepaged.c
>  F:	mm/mm_slot.h
> +F:	tools/mm/thpmaps
>  F:	tools/testing/selftests/mm/khugepaged.c
>  F:	tools/testing/selftests/mm/split_huge_page_test.c
>  F:	tools/testing/selftests/mm/transhuge-stress.c
> @@ -17883,9 +17920,15 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/core-api/protection-keys.rst
> +F:	Documentation/filesystems/mmap_prepare.rst
> +F:	Documentation/userspace-api/mseal.rst
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
> +F:	include/linux/mman.h
> +F:	include/linux/pkeys.h
>  F:	include/trace/events/mmap.h
> +F:	include/uapi/linux/mman.h
>  F:	mm/char-mem.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
> @@ -18724,6 +18767,7 @@ M:	Peter Zijlstra <peterz@infradead.org>
>  L:	linux-arch@vger.kernel.org
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	Documentation/core-api/cachetlb.rst
>  F:	arch/*/include/asm/tlb.h
>  F:	include/asm-generic/tlb.h
>  F:	include/trace/events/tlb.h
> @@ -21834,6 +21878,7 @@ S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
>  F:	arch/*/include/asm/percpu.h
>  F:	include/linux/percpu*.h
> +F:	include/trace/events/percpu.h
>  F:	lib/percpu*.c
>  F:	mm/percpu*.c
>  F:	mm/percpu-internal.h
> @@ -25555,6 +25600,7 @@ F:	include/linux/shrinker.h
>  F:	mm/list_lru.c
>  F:	mm/shrinker.c
>  F:	mm/shrinker_debug.c
> +F:	tools/cgroup/memcg_shrinker.py
>
>  SH_VOU V4L2 OUTPUT DRIVER
>  L:	linux-media@vger.kernel.org
> @@ -25787,10 +25833,12 @@ R:	Roman Gushchin <roman.gushchin@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
> +F:	Documentation/ABI/testing/sysfs-kernel-slab
>  F:	Documentation/admin-guide/mm/slab.rst
>  F:	Documentation/mm/slab.rst
>  F:	include/linux/mempool.h
>  F:	include/linux/slab.h
> +F:	include/trace/events/kmem.h
>  F:	lib/tests/slub_kunit.c
>  F:	mm/failslab.c
>  F:	mm/mempool.c
> @@ -29842,9 +29890,11 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/linux/vmalloc.h
> +F:	include/trace/events/vmalloc.h
>  F:	lib/test_vmalloc.c
>  F:	mm/vmalloc.c
>  F:	mm/vmalloc.h
> +F:	scripts/gdb/linux/vmalloc.py
>
>  VME SUBSYSTEM
>  L:	linux-kernel@vger.kernel.org
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

