Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D30CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46BDF8E00FA; Fri, 24 Oct 2025 16:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41CFA8E00C9; Fri, 24 Oct 2025 16:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BB18E00FA; Fri, 24 Oct 2025 16:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3F18E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:05:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBC4E1A0684
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:05:51 +0000 (UTC)
X-FDA: 84034088502.01.051276E
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE14B1C000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:05:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Exbd5bsf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761336350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5kibUrhGEIh1wdjnl8ZsspLMeFM7U2onbljFtVXAgg=;
	b=2C1ITpD6fsT8xiXoTJr6GRT65nBN8mpCGsLQys+/32OAqslRuB90swH7YUjOSE5AyN/eoL
	zXsPK4IAmbhn8gy9nknf6b59ZV3O8T8P08sp4sAbcGHEjONGv6rwtLvzUEPE/otVTX1AJc
	oncDi6YBwd2n34epTX1HO9Q616UJvHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761336350; a=rsa-sha256;
	cv=none;
	b=fbivBXM6+wOOk1NRIw8jmjyw3Phwv83gIHir9KFGXnQGZR0OvocgayQEfif75fzCNXTEEo
	SRsr1EQkXe+5Q4/7m1aoS5L6IKNyymP7gMn3DyV9FXgS8OAX1WcA35atBP17oi8isJ71hB
	5/CxsvXs5CxvS1zmV96oKsXAjBDRqYw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Exbd5bsf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
Date: Fri, 24 Oct 2025 20:05:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761336347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K5kibUrhGEIh1wdjnl8ZsspLMeFM7U2onbljFtVXAgg=;
	b=Exbd5bsf/Tm5LIy+8QoVhG42/C0IUQp5OSAWxcboh4tanMCzpIkUQ79onbMEOK4YPdqCxs
	RjiNuyVFWKVgZL4lbRM0JP7q7nY9JQ3TVoH9vTDnZdiRfZFmye8OrvBUrGHwzOHyEGFvdP
	PEQs8k/CqVsM8cf4HYazoKCaJGZJVOw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <7tjpibvbt2nwkkrzcbrsw3t3ehxckjrro6vxqukh4ld4memodx@cxfpmwbr3fo6>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: uax716jmffpz1pcwmwkxnymfq8snhx3p
X-Rspam-User: 
X-Rspamd-Queue-Id: BE14B1C000C
X-HE-Tag: 1761336349-979148
X-HE-Meta: U2FsdGVkX1+PxqkusZCQw2wDizSyXRxzW0MfBTVLfXx3WrD1xkpp6BYf7rNDWO1rEtmirrp9TvPeXN90K83SL1vBdaW8AmxRhwEzZIpKERhUaERf81lMEDkNau0z4ibxcVHRJeFYajXbOTjyiUe9RqUoh41sh78LtyZKS9P5QSz0y/MyxmUsV9hqzDOJeB/72dauI5C8/n3aj1dLGZtvPsv1UrqkCm94DtOkkdLRfwkYgnXhh7tqmqa6ZWVwOTm0uePeTyfO6Y2PgSV5JFgWz+z/8uNooRrAbDXIhzsyhM/zXmy9DLfED9AmZuZCrl48EnNy9jbxS79Bb/WuIADrseaNb07hcc0VIIdjl7vNuFx46oTkRjVt8nBR4xqPl45xJM74h1K4pTC8c56oOKu+D14532u4KwUUKsDogpjtN6dR7thKHAegeMo/PLfQOBL/RhBh92U26BR0fpu9mWWh7FjG6W3bWr7iu5D0OKoQzYMvTMA0bd46ZCxcPaqK5OwZQQThiDiSNdkW29qtng+cQKThaKoU9jYn6JiaOM39pyvgXKofJXNy5TtphxGh8uAX7q1ot83oBHcSamg6dhxO3+annJvX3zC9sZE1W1o9ivEvPyG/LqPQ+GO7NEmaNnI+bJFDfLVpdxZv1EtoPP2fcyDURoct6ZS4V6jHzH3NDZNyEIIbzgaNp1ajO8naFK46hVumoRAadne8B68yt4fA+UCwuI2E5HKtb3bJTKNl41AW4M0graxhIAOlZn6PYtr7gIN68bPo28MPd04+qt2VZogZwBI+ANBScBa9/6bxhlyfU47Kl7ClT0mboNz0Y85MWg4qjA1jzPiAX4CHEnXXFFVK71MsRXS4moXE9Lg40BZFU7h2LZwasIjiKOQ/J6WpDEBn3WLItBwPUG/5wziyL93PDMxOAf9K5QT5KviPn6FFRWT29VsaprrLoMlOzUQkwUMxukBGknMgU51BKzY
 W5+wfsmy
 BO7fqfyvpXHKFUtg5G+TOdeO0BPEnC9jdrcZ+Vt/WHDL2TAf5Ff1TDMS663dOY26Lpxxjao5LewUszjQ5uD3o2nXr0nuGXs2pJyxl2GyRCwE1eb+8k2Iw5cxvHiiFCe68cMp/j3gVTAK94qb0c8KbVR3t+cTG4G3wAcrg+Q3kboN5m3derrsr/DfhtqMxpbmzvzU3REOT1lilOZ1gJkUQxWIrKjjD5qSmEObnAawFDZkNuDy7iQ3RCuXIzLXUDwXRO2E4CdQGmmc94qzkXwnSeNDXybC/qPJEguGT8vGD1RECHW3I74ZmzQumqPnDQNG+sfLr0CMNy8BfAhc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 08:41:16AM +0100, Lorenzo Stoakes wrote:
> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).
> 
> However, at the same time we also have helper predicates - is_swap_pte(),
> is_swap_pmd() - which are inconsistently used.
> 
> This is problematic, as it is logical to assume that should somebody wish
> to operate upon a page table swap entry they should first check to see if
> it is in fact one.
> 
> It also implies that perhaps, in future, we might introduce a non-present,
> none page table entry that is not a swap entry.
> 
> This series resolves this issue by systematically eliminating all use of
> the is_swap_pte() and is swap_pmd() predicates so we retain only the
> convention that should a leaf page table entry be neither none nor present
> it is a swap entry.
> 
> We also have the further issue that 'swap entry' is unfortunately a really
> rather overloaded term and in fact refers to both entries for swap and for
> other information such as migration entries, page table markers, and device
> private entries.
> 
> We therefore have the rather 'unique' concept of a 'non-swap' swap entry.
> 
> This is deeply confusing, so this series goes further and eliminates the
> non_swap_entry() predicate, replacing it with is_non_present_entry() - with
> an eye to a new convention of referring to these non-swap 'swap entries' as
> non-present.

I just wanted to say THANK YOU for doing this. It is indeed a very
annoying and confusing convention, and I wanted to do something about it
in the past but never got around to it..

> 
> It also introduces the is_swap_entry() predicate to explicitly and
> logically refer to actual 'true' swap entries, improving code readibility,
> avoiding the hideous convention of:
> 
> 	if (!non_swap_entry(entry)) {
> 		...
> 	}
> 
> As part of these changes we also introduce a few other new predicates:
> 
> * pte_to_swp_entry_or_zero() - allows for convenient conversion from a PTE
>   to a swap entry if present, or an empty swap entry if none. This is
>   useful as many swap entry conversions are simply checking for flags for
>   which this suffices.
> 
> * get_pte_swap_entry() - Retrieves a PTE swap entry if it truly is a swap
>   entry (i.e. not a non-present entry), returning true if so, otherwise
>   returns false. This simplifies a lot of logic that previously open-coded
>   this.
> 
> * is_huge_pmd() - Determines if a PMD contains either a present transparent
>   huge page entry or a huge non-present entry. This again simplifies a lot
>   of logic that simply open-coded this.
> 
> REVIEWERS NOTE:
> 
> This series applies against mm-unstable as there are currently conflicts
> with mm-new. Should the series receive community assent I will resolve
> these at the point the RFC tag is removed.
> 
> I also intend to use this as a foundation for further work to add higher
> order page table markers.
> 
> Lorenzo Stoakes (12):
>   mm: introduce and use pte_to_swp_entry_or_zero()
>   mm: avoid unnecessary uses of is_swap_pte()
>   mm: introduce get_pte_swap_entry() and use it
>   mm: use get_pte_swap_entry() in debug pgtable + remove is_swap_pte()
>   fs/proc/task_mmu: refactor pagemap_pmd_range()
>   mm: avoid unnecessary use of is_swap_pmd()
>   mm: introduce is_huge_pmd() and use where appropriate
>   mm/huge_memory: refactor copy_huge_pmd() non-present logic
>   mm/huge_memory: refactor change_huge_pmd() non-present logic
>   mm: remove remaining is_swap_pmd() users and is_swap_pmd()
>   mm: rename non_swap_entry() to is_non_present_entry()
>   mm: provide is_swap_entry() and use it
> 
>  arch/s390/mm/gmap_helpers.c   |   2 +-
>  arch/s390/mm/pgtable.c        |   2 +-
>  fs/proc/task_mmu.c            | 214 ++++++++++++++++++++--------------
>  include/linux/huge_mm.h       |  49 +++++---
>  include/linux/swapops.h       |  99 ++++++++++++++--
>  include/linux/userfaultfd_k.h |  16 +--
>  mm/debug_vm_pgtable.c         |  43 ++++---
>  mm/filemap.c                  |   2 +-
>  mm/hmm.c                      |   2 +-
>  mm/huge_memory.c              | 189 ++++++++++++++++--------------
>  mm/hugetlb.c                  |   6 +-
>  mm/internal.h                 |  12 +-
>  mm/khugepaged.c               |  29 ++---
>  mm/madvise.c                  |  14 +--
>  mm/memory.c                   |  62 +++++-----
>  mm/migrate.c                  |   2 +-
>  mm/mincore.c                  |   2 +-
>  mm/mprotect.c                 |  45 ++++---
>  mm/mremap.c                   |   9 +-
>  mm/page_table_check.c         |  25 ++--
>  mm/page_vma_mapped.c          |  30 +++--
>  mm/swap_state.c               |   5 +-
>  mm/swapfile.c                 |   3 +-
>  mm/userfaultfd.c              |   2 +-
>  24 files changed, 511 insertions(+), 353 deletions(-)
> 
> --
> 2.51.0

