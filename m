Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BFA606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vYnG9HPG
Received: by kanga.kvack.org (Postfix)
	id 9C2A96B05B0; Mon, 16 Nov 2026 12:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973A86B05B1; Mon, 16 Nov 2026 12:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889496B05B7; Mon, 16 Nov 2026 12:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 622076B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:47:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD558120246
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:47:31 +0000 (UTC)
X-FDA: 85441714302.28.707FF73
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id ECF4A40002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:47:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vYnG9HPG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794851250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7iCEiFpv+CdXdPGzQ8NPnC8q8s1WCxNdXeEH57RWmQ=;
	b=qlo5J2PtJEAry9NYtLxnoCYH419SBTyLruOlt0UroJBqfnL4V8Crojj4nIe1Mi27wGtoWm
	P6IrIGVE8oI98W1yfy9RJeYzI3jqYqBn+Auk88RoKeZ9PW7E4jbxQMK4I7yY5DKYHLkqnq
	8phDhFCJaxMwnqRQaBMHm//o9jA8Ing=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vYnG9HPG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794851250;
	b=P22oWaxJ3ZA8OH1Bbs4GogbLfmyZMgwwmI1YserppNeUNOe6b/jo/DMICFDgEvmHfwqD97
	KOztSG+aYHwfRAUgj9zFJY2SzUYsIcrpc6dX4V0c/djqJyj4YvWMGgEgyMdJcIfUtHOEaU
	OqQNlsbRyMDeC4OWoPT+JJry4bYpH94=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAE411684;
	Mon, 16 Nov 2026 09:47:25 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3E043F632;
	Mon, 16 Nov 2026 09:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794851248; bh=AMcVcxQVMD8gQwXV3KWCBleRurgDxWCU5KOA98CfOm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vYnG9HPGhGlMj4NF/A7S1WFcpdAcpXq+tGwhMoQfaRtrBE4FpWOUeGjdwOo/SolZF
	 /2WhztN1v8chwHpSnJEjAk9b+lmTbMj2GftsHtBIGSIu0n5IDE4RO0Ji1a19m+NyUT
	 NxRbqtlgPeNFzWxD7nEDFakiMyl5mNeBaibC1HnU=
Date: Mon, 16 Nov 2026 17:47:20 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
Message-ID: <avtBqGb4R2y9QJM8@raptor>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor>
 <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
X-Rspamd-Queue-Id: ECF4A40002
X-Rspam-User: 
X-Stat-Signature: xp1s7cwu46dgjshw8ap56c5uimgux8ma
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794851249-854045
X-HE-Meta: U2FsdGVkX19KOLLPc2P1qRtqTfT2Vr3dr6cXteyw5qe+vYsd0e5ijo6ETohN1cie5IQDX+tPZTxSMNiJbJSDecPaGHyi7FFnlirzI7A8HSQQxImppdCqVc0TQ7PeIBWXf36tc6ESCAiIa8yCUNILMEWWT7WR0DWvmusz/KbuU6fMCgK9/rsaMSHR8zG4hZLJFTYOIrMqfi6TwhSrrrlYgpgcRhnALzKlMHk9ym5RVv18aBDyX1vEB8YrR5c0iY/QRrg+UXIKXUyku+pBhLjZpsm18hmK/hY8WvaADUlbFx7BS/+PPHS1eYyj3bGXe3/bO3WyITRW+ItNIS1yMjnasaWVk7TLawWJTJrWJJCkycn9HbdGMu8z6sp8B3Q5VwsQ3V6lPB7klGdMEms7BB43fFboNFt9HQieqmP+UnAX4G7MWLVigakOsALDOHxFtgQu85ePpvTLsyPsvo3HJH7g7SUw1Tc8poxqTyCDe8xZw19EHC63JUqeGxR02FpcVGNqlt2Jxfc9+M9s1ve0WpxVS4wq5MmbzyzZ9OcoeNLCpfLeCOpjmAdrM3pezDl2CqFWf5b13pDi3vYiH6ojGqahoSRcFZwUQNGnUMuTggBV5QKikUX5rgFaFhZF8Lgm5GG8jJJ++8MeqcdWGHLo6Yl7lEnW+na7P7nPMyVG7gu/Ao/vgcAQj2qJYNdj+6gM1yHmeTzEIszqjIavpBFeBiUVQJPeAUvVGCKYYi8jE2Hea39N7bdILFhEWahUR09FajXfGg7uumdTcdNlOPlCZikC8DWRqH72T/5Nr3feGvNs90utE1of96Gw5TMADxyuOpQHibA1NgxnoC6w6rgJPcZRp0ZB5qzgUUVSvc+aacgxufVnyDjodKmE8gZxlN9p+kND6TuEjkaCdl/oVaYVrYukRVhEtRgznVDy1PaaieOH0EXdMZ+4m6klbV01g8ao6fMoZ7r+HZ8aroagyI74bhZ
 z2+4J4Rd
 ET4buzpqslYrn4Df2chfBqW9ax1mwc0/XxhsSpEpd3Flj3qSqGz6DmoE9MW+ae1VprQRHSHz9wotAbf7nyXwUNLyPaTJWTvM8hQ82g8Hj8097DRXivje1ljwf1s0RT2Xl/M4S0iZy4034P0IqF8Hz0xP8vjZ39ZSOqN/55KmglDQ/9mOCHd7Ume5pWob+m3kKBqzh09tQPJHswiYtRHe5pYmeUXad9vbxIH0wSMjv9vqAHBAc2xtGeSXP2zHFSiPdi3xJFUEBCET7L4KE6HDNhWUx5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mika,

On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
> Hi Alexandru!
> 
> On 11/12/26 13:56, Alexandru Elisei wrote:
> > Hi Mika,
> >
> > I want to help getting this series merged, and I've been familiarizing myself
> > with hmm and device migration, please bare with me if the questions I'm asking
> > are obvious or downright silly.
> 
> Thanks for the interest and willing to help! I am preparing a v18 of the
> series and plan to post it early next week.
> 
> I try to answer your questions, there are quite a bunch of them!
> 
> >
> > On Tue, Nov 03, 2026 at 08:16:17AM +0200, mpenttil@redhat.com wrote:
> >> From: Mika Penttilä <mpenttil@redhat.com>
> >>
> >> Currently, the way device page faulting and migration works
> >> is not optimal, if you want to do both fault handling and
> >> migration at once.
> >>
> >> Being able to migrate not present pages (or pages mapped with incorrect
> >> permissions, eg. COW) to the GPU requires doing either of the
> >> following sequences:
> >>
> >> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> >> 2. migrate_vma_*() - migrate the pages
> >>
> >> Or:
> >>
> >> 1. migrate_vma_*() - migrate present pages
> >> 2. If non-present pages detected by migrate_vma_*():
> >>    a) call hmm_range_fault() to fault pages in
> >>    b) call migrate_vma_*() again to migrate now present pages
> > Regarding both sequences, I'm trying to get a better understanding of what
> > the issue is. I assume the caller wants to fault in system memory, and then
> > migrate it to the device. Is that correct?
> 
> Yes that's the common thing to do.

Gotcha, thanks.

> 
> 
> >
> > In my analysis I'm also not going to refer to THPs, since that would make
> > things even more complicated than they are. I think we can come back to
> > THPs later if we think it would be useful.
> >
> > For the !pte_present() case:
> >
> > Sequence 1: hmm_range_fault() -> .. -> hmm_vma_handle_pte() handles
> > !pte_present() pages in two ways: faults in swap pages and device private
> > pages belonging to a different device, and waits on migration entries. Then
> > the migrate_vma_*() flow is used to migrate the range.
> >
> > Sequence 2: migrate_vma_setup() ignores !pte_present() page table entries
> > After this, the caller follows the same steps as in sequence 1 -
> > hmm_range_fault() faults in !pte_present() pages, and migrate_vma_*() is
> > called again to migrate the pages that were faulted in/waited on by
> > hmm_range_fault().
> >
> > Now, for the CoW case that you mentioned, I'm going to assume that the
> > caller wants write permissions otherwise nothing needs to be done:
> >
> > Sequence 1: hmm_range_fault() -> hmm_vma_handle_pte() records a fault
> > (hmm_pte_need_fault() returns HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT),
> > handle_mm_fault() -> .. -> do_wp_page() breaks CoW and maps an exclusive
> > folio with write permissions, then the migrate_vma_* flow will take care of
> >
> > Sequence 2, migrate_vma_setup() installs migration entries for the page,
> > then migrate_vma_finalize() replaces the migration entries with device
> > private entries.
> >
> > Looks to me that for CoW pages, all that's needed is migrate_vma_*(), and
> > the subsequent calls to hmm_range_fault() and migrate_vma_*() are not
> > necessary. Is that your conclusion too?
> 
> For  a device fault: the driver want the data in device memory with the
> permissions the device asked for. Your !pte_present() analysis matches;
> note that pte_none() in anonymous vmas and the zero page don't need
> hmm_range_fault() at all, migrate_vma_*() populates them directly.
> That's why the common case is cheap with sequence 2, and only swap
> entries, other devices private pages and migration entries need the
> extra walks.

Yes.

> For cow with write intent migrate_vma_*() alone is enough.
> migrate_vma_setup() doesnt break cow: it collects the shared page
> through its read-only pte, so there's no MIGRATE_PFN_WRITE, and
> try_to_migrate() unmaps all its mappings, so finalize installs a
> read-only device private entry. 
> 
> The device still cant write; a write then has to go through
> migrate_to_ram() and break cow in system memory, and migrate again. To
> get an exclusive writable copy on the device, cow has to be broken
> before collectin, i.e. hmm_range_fault() with HMM_PFN_REQ_WRITE first,
> then migrate: two walks.

Makes sense, something did seem fishy with my analysis of the CoW case.

> With this series that's one walk,
> HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE | HMM_PFN_REQ_MIGRATE (or
> MIGRATE_VMA_WRITE for migrate_vma_setup() users), and only the
> now-exclusive page is migrated.
> 
> >
> >> The problem with the first sequence is that you always have to do two
> >> page walks even when most of the time the pages are present or zero page
> >> mappings so the common case takes a performance hit.
> > This is the first mention of the zero page. Is the caller specifying
> > HMM_PFN_REQ_WRITE? That makes a difference, because it triggers fault
> > handling for the zero page, and that's an extra walk. Can you give more
> > details here?
> 
> Good question on the zero page. With a read request it need no fault:
> migrate_vma_*() populates it like pte_none(), and the HMM walk collects
> it the same way. With HMM_PFN_REQ_WRITE it's write-faulted first, in
> sequence 1 and with this series alike; the difference is that the series
> faults and collects in the same walk.
> 
> 
> > Let's count page table walks when a page is mapped with a valid entry, and
> > with the required permissions. Let's say N is the number of mappings for
> > the page (equivalent to the number of VMAs that map the page):
> >
> > hmm_range_fault() -> .. -> hmm_vma_handle_pte() does one page table walk,
> > migrate_vma_setup() does N page tables walks, to replace all valid mappings
> > of the page with migration entries, migrate_vma_finalize() does N page
> > table walks, to replace the migration entries with device entries.
> >
> > In total 1 + 2*N walks. Best case scenario, N == 1 (PageAnonExclusive()),
> > that's three walks.
> >
> > Do you have any data regarding how often the best case scenario happens?
> > That's what you seem to be referring to in your comment.
> >
> > Now let's count the number of walks for a !pte_present() page mapped in P
> > VMAs, where P != N: one from hmm_range_fault(), if the entry is not a
> > migration entry, another walk in the fault handler, then 2*P walks from the
> > migrate_vma_*() flow.
> >
> > If it's a migration entry, it requires 1 + 2*P walks, PLUS waiting on
> > migration to complete, which cannot be skipped.
> >
> > If it's a swap entry, it requires 2 + 2*P walks, PLUS waiting on swap.
> >
> > If it's a device private entry belonging to a different device, it requires
> > 2 + 2*P walks, plus waiting on the device to sync the memory with the
> > device in migrate_to_ram().
> >
> > To summarize:
> >
> > pte_present()	1 + 2*N walks
> > migration entry	1 + 2*P walks + waiting on migration
> > swap entry	2 + 2*P walks + waiting on swap
> > device private	2 + 2*P walks + waiting on device->memory sync
> On counting: the 2N (or 2P) rmap walks that replace the mappings with
> migration entries and then device entries are inherent to migrating the
> page and are the same in all variants. What differs is the number of
> page table walks over the range: sequence 1 allways does two
> (hmm_range_fault(), then migrate_vma_setup()), sequence 2 one if
> everything is present and three otherwise, and the HMM walk one, with
> faults handled in place and the walk resuming from the faulting
> address.  The saving is per range walk, so it scales with the range.

I think we might need to define what you mean by 'saving'. Normally, I
would assume that you mean that 'the total time of migration is decreased',
but the fact that the benchmark that you offered doesn't show this makes me
wonder.

The more !pte_present() pages are in the range, the smaller the amortized
cost of a walk per page in the range. For example, using sequence one, for
512 !pte_present() pages, the current code does an extra 1/512 page table
walks per page (for sequence two, an extra 1/512 * 2 walks). At the same
time, for each page it needs to do a fault, or swap in, or wait on
migration, or break CoW, or put migration+device entries in each VMA that
maps the page.

I think the worst case scenario is the device wanting to fault in one page
from system memory. Is that what usually happens?

> 
> I don't have data on how often the best case happens. The motivation
> came from earlier prototyping of migrate on fault on the current
> interfaces, where the extra walks showed up in perf traces. For the
> typical SVM case of private anonymous memory without fork the pages are
> exclusive (N == 1) or not yet populated, but I haven't measured a
> distribution.

Got it, that's what I wanted to know, the typical case is exclusive memory.

> >
> >> The second sequence is better for the common case, but far worse if
> >> pages aren't present because now you have to walk the page tables three
> >> times (once to find the page is not present, once so hmm_range_fault()
> >> can find a non-present page to fault in and once again to setup the
> >> migration). It is also tricky to code correctly. One page table walk
> > Valid entry, the page is mapped in N VMAs: migrate_vma_*() does 2*N walks,
> > best case scenario (PageAnonExclusive) two walks.
> >
> > !pte_present, the page is mapped in P VMAs:
> >
> > migrate_vma_setup() -> migrate_vma_collect() will always do one page table
> > walk, regardless of what it finds, valid or invalid entries.
> > migrate_vma_collect() ignores !pte_present() entries, and they will not
> > trigger new walks in the next steps in the migrate_vma_* flow. Worst case
> > is that all the pages are !pte_present(), that's one walk to find them all
> > which I would say it translates to zero extra walks for an individual page.
> >
> > For hmm_range_fault(), it's the same situation as above: 1 + 2*P or 2 + 2*P
> > walks.
> >
> > To summarize:
> >
> > pte_present()	2*N walks
> > migration_entry	1 + 2*P walks + waiting on migration
> > swap entry	2 + 2*P walks + waiting on migration
> > device private	2 + 2*P walks + waiting on device memory->memory sync
> >
> > I agree with you, this second sequence is better for the common case.
> >
> > I think it would interesting to know:
> >
> > 1. Is there a relationship between N and P, and if there is, what is it?
> > Are they equal, on average? I doubt it. Is a !pte_present() page likely to
> > be mapped in more VMAs than a pte_present() page, or fewer?
> >
> > 2. What is the likelyhood of P being equal to 1 (PageAnonExclusive)? That
> > would be interesting to know because the larger P is, the contribution of
> > that extra walk (or two walks) to the total time becomes less and less
> > significant.
> >
> > 3. How does the time to do the walk compare to the time spent waiting on
> > migration, or waiting on swap, or waiting on device to memory sync? How
> > often each of them happen? I have a hunch that these will tend to dominate
> > the total time.
> Yes, when a page needs swap-in, a migration wait or a device sync, that
> wait dominates..
> The walk saving matters on the common device fault path, with small
> ranges (one page per fault in the nouveau patch) and present or
> unpopulated pages: one walk instead of two, and without sequence 2's
> three when part of the range isn't present. But the main point is one
> call that faults and collects consistently, instead of two with a window
> in between where the range can change.

This is introducing another variable into the mix. It's not just the number
of page table walks, it's also the fact that in between walks the mapping
might have changed. I think this is why it's good to have a representative
benchmarks :)

> 
> I don't have data on N and P. For private anonymous memory without fork
> or KSM both are normally 1, but I haven't measured it.
> >> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
> >>
> >> We should be able to walk the page table once, faulting
> >> pages in as required and replacing them with migration entries if
> >> requested.
> >>
> >> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> >> which tells to prepare for migration also during fault handling.
> >> For the migrate_vma_setup() call paths, new flags, MIGRATE_VMA_FAULT,
> >> and MIGRATE_VMA_WRITE are added to tell to add fault handling to migrate.
> >>
> >> An extra benefit of migrating with hmm_range_fault() path
> >> is the migrate_vma.vma gets populated, so no need to
> >> retrieve that separataly.
> >>
> >> This series avoids the problems in current collecting implementation,
> >> where racing MADV_DONTNEED could make the collecting arrays overflow.
> > Can you provide more details here? How does it happen?
> migrate_vma_collect_pmd() drops the pte lock to split a large folio and
> restarts with [start, addr) already appended to src[]/dst[]. If a racing
> MADV_DONTNEED zaps the range and frees the pte table meanwhile, the re
> start takes the hole path from start and append [start, addr) again,
> writing past the arrays. "mm/migrate_device: don't collect a range
> twice" in Lorenzo's batch fixes that instance; this series collects into
> the address-indexed hmm_pfns and fills src[] only lastly, so re-walking
> cant overrun. Also, the correct pages are collected with the re-walk
> with this series(rollback takes care of the old ones).

That can be accomplished with the upstream code too, this series isn't
required (just off the top of my head, keep a local counter for the total
number of pages collected by migrate_vma_collect_pmd(), use it as an offset
into migrate->src and migrate->dst, and reset the counter on the 'again'
label).

> There are couple other defects the series fixed along the way.

Hmm... the size of this series might put off some people who are interested
only in the fixes. Have you considered splitting them into standalone
patches/series?

> >> This is achieved mainly by having a rollback mechanism and
> >> populating the collecting array as the last step.
> >>
> >> Tested in X86-64 VM with HMM test device, passing the selftests.
> > Have you tested that this series doesn't regress other architectures?
> 
> Only tested on x86-64 (VM with test_hmm, and nouveau on a GP102). The
> code is arch-independent, but it isn't tested elsewhere.

Sorry, I'm a bit confused - what do you mean by it isn't tested elsewhere?
x86-64 specific code is the only user for the arch-independent code?

> 
> 
> >
> >> The main goal of this patchset is to provide a new feature,
> >> migrate efficiently on fault, and not directly improve performance
> >> of current migrate_vma_setup() (which is now routed thru
> > I'm a bit confused by what 'on fault' means in this context? Userspace
> > accesses a device entry, access that causes a fault, or using
> > hmm_range_fault()? I assume the latter, but it pays to make sure.
> >
> > Also, can you define efficiently? Usually that's related in some way to
> > performance, but immediately you say that the series doesn't aim to improve
> > performance.
> 
> "On fault" means a device fault: the driver services a GPU fault with
> hmm_range_fault(HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE) and migrates

Got it, thanks.

> the page while handling it. "Efficiently" was the wrong word: I meant
> faulting and collecting in a single walk, instead of two or three calls
> with a window in between. I'll reword the cover letter.

Ok, gotcha.

> 
> >> hmm_range_fault()) callers. That said, the migrate throughput tests
> >> from the selftests show that there is at least no regression for
> >> current migrate_vma_setup() callers.
> > If the premise of the series is to reduce the number of page table walks in
> > the !pte_present() case, then I think benchmarks that show a performance
> > improvement would make a compelling case for this approach.
> >
> > Some thoughts, if I may:
> >
> > - Perhaps the existing test is not the right test to highlight the
> >   performance gains?
> >
> > - Perhaps there are other parts of the migration process that dominate the
> >   walks? If so, maybe we should be focusing our attention on those?
> >
> > - Perhaps the series adds overhead that reduces or cancels the gains from
> >   reducing the number of walks?
> 
> I don't have a benchmark showing a gain: nouveau had no migrate on fault
> to compare against, and the selfftest throughput tests use
> migrate_vma_setup() on present pages, so they can only show there's no
> regression, including from the extra work in the HMM walk. Also, any
> help with new tests is greatly welcome :). My primary focus atm is
> getting the final corner case details sorted out in the core and
> addressing sashiko; with v18  i hope being there. 

This is how I see this series, please correct me if I got something wrong.
The aim is to reduce the total number of page table walks over the range by
one or two (depending on the sequence of functions used) when
!pte_present(), or when pte_present(), but without write permissions.

From our discussion so far it seems to me that the total migration time in
the above cases depends on a number of things:

- In how many other VMAs these pages are mapped, as each mapping needs to
  be replaced with migration entries, and then with device special entries.
- How long it takes to swap in the page, if the page is mapped using a swap
  entry.
- How long it takes to complete a concurrent migration, if the page is
  mapped using a migration entry.
- How long it takes to migrate a device entry back to system memory, if the
  page belongs to a different device.
- If the page is CoW, how long it takes to break CoW.
- What happens in between walks.

The code touches 2,600+ lines of code, with almost 1,300 lines added.  It
removes those extra page table walks, of course, but it also offers plenty
of scope to add new inefficiencies (or bugs), and if that's the case, we
don't gain anything other than complexity. I think having a benchmark
representative of a real workload, or a real workload, that shows a
decrease in the total migration time will be great to demonstrate that we
are on the right track :)

Thanks,
Alex

