Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEEA606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OdCKsL2G
Received: by kanga.kvack.org (Postfix)
	id 18D6A6B0645; Wed, 18 Nov 2026 18:28:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13EDA6B0648; Wed, 18 Nov 2026 18:28:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0063E6B0649; Wed, 18 Nov 2026 18:28:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B99ED6B0645
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:28:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3915A160919
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:28:11 +0000 (UTC)
X-FDA: 85449830382.25.7B63BFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4525CA000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:28:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdCKsL2G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795044489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SK275y4VY/DrqFpnu9VZ7OOZ+0WJgDRv5haChjqDgDQ=;
	b=xHRYaZtyumcBiCMvBeYYGCAVX0TBUEPkZTqP0d7uaa6XNFDR+Rkb+nByA32xpFyEb6TMGA
	0zKEgxg5T8EgDddGvUzmv/P0cTH3iPADNBetR/KDjHaDikthSKyFW+3nA8T0z3/8zXETxX
	/Gc2nRhzcvAJdogfhQhIFlxsA/v0v4A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdCKsL2G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795044489;
	b=WCb7oCZO+yy4tzwYKfezVan8/P0U+Q4vFsQeuTwuxFk4qMWHZ+iB4aPPNbSqyT+V1abnGj
	6O37hA1MMCVgckYIsATfYPFmibDQ4X976DjV8yln4/Q2hkHW3gMRwT/RkWZizilLMwcZUI
	/g5snS8M3E63FFA9knreGdeBRs6XtWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7813343C9A;
	Wed, 18 Nov 2026 23:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ECF1F000C5;
	Wed, 18 Nov 2026 23:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044488;
	bh=SK275y4VY/DrqFpnu9VZ7OOZ+0WJgDRv5haChjqDgDQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OdCKsL2GIIGNLJhbAxvjZSqp0wzeB9wQR8No3dX0tnUzdCU1i6cyAR1zjVhmsH1SM
	 iIKSein6fRqoo1meqmjwFEUZXx+A2Tkb7yrmO5M42e4EgnNdDrXJJkdvTckyBt3dYI
	 PcrXSKWOo4a/Dpd0TBc5RQwxfGruyGxaax5pGpIpdJJEhGZLl7ZETNcF9YBeYPwcKU
	 BoWlaKody9kQUkgGtMmxwLgYWT4p5iOzm8UEVF3cd5X2hyxyeL2h/XUoMCox1kP7BN
	 A1LVassi1bpToxgBdXjzyYTq+ljz1NtVcaB4C3t9VMiMQJw8dhVfDoHwQ6QJ76kEsJ
	 GnVXlr48SNbBQ==
Message-ID: <e9391a34-1135-4474-9ef1-a0e86afaebf1@kernel.org>
Date: Thu, 19 Nov 2026 00:28:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] gup: introduce folio-range interface for pinning
 user memory
To: Swarna Prabhu <sw.prabhu6@gmail.com>, akpm@linux-foundation.org,
 jgg@ziepe.ca, jhubbard@nvidia.com, viro@zeniv.linux.org.uk
Cc: linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, dave@stgolabs.net, riel@surriel.com,
 yeoreum.yun@arm.com, hch@lst.de, Swarna Prabhu <s.prabhu@samsung.com>
References: <20261118213458.377258-1-sw.prabhu6@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118213458.377258-1-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4525CA000A
X-Stat-Signature: tobue8ixse6mbbzj8h66bf1ddm16y4wz
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795044489-637055
X-HE-Meta: U2FsdGVkX18gPiiFZKUeQyK/1FBfFwgUiU7OJJ2MJangCETV+SwGY579ZEZlUpAva9L15FhGEwlcC7UXh39XOq51iphh2KUz/CvTjJusDdBMrhsElLUfRIuoX2Hbf9JeJvG29TjUesDnMSmoSFgjWdzdBV6rzr/OSmZZSDoHqWV+AFFsBQbpqyEVqgixkeXovGWclcivRTd0WCZZqaZybvwz1cLaStPkxf25Ax3D7XYDelkOE9fC2AjR5CXvWH05nLAZ8ILHjMxwhhYn0gRipXTauKiYIjGs7FlBIa/s406hFtf6Qw4zQKzOcNqpMmUcjGMygdoVO/x+aPIlhxgaYuFfWc50AW89rycVggV8ApVhVSMh4Dvj5K70GnRrNBtBCvCsdDiM2sqzvYcdDQ8La9hOJtAF4xPzMgKk/k0czXe53Wjj2ejkTmDUigHkJYeRSLjyVwVF4oQ+uXm1S/lcevXxGciFeru2zcWlpREor97lPi1pTHnBAyAnnUktvSi0RTNtAKfL+1h/DCbkMbg/JFWk/e3NEZFVTTD9bcGMfF9dAEvhituk1DHByTdDLe7EV01rZMik4kMMEGsyZSwVlbV3v9roQPa2TnfDSrdHAz7OIBcL1dRnKkFWjxfStpZf81tnSffuih0HURZCrMV7CE0ShrV3Pl76BZEYTWnEkA0Z0Q+d5kB2eSdRxSpQWuGJOqZiTvvMup/bIosOCEdHnbjx6sad/iLSZ0oIJVqfkF9fnxcSI1CB/Ta2/IBhlivuDVj4tj8AQMoUYlg4c+iF/DOFPmcwYqHzU+vgwUHLJOcNGD+kMgnh3RSPhip8C6GnX5ezu9Rwxh+qMqePlxw44YK+xpevdIlcrIILWWqwRrSmVkOvHgyVYYB2OMOu4hHqpy7zbQazjBHf7A8GcjkQ4o6sBhh1XystfCf9wDqfR2Dvqh+FXF0D/DgC6tJnNkxp9tf9Y7OPqnZvCap5X16
 tuCoBpVU
 1OQy/KkeHbvWrbjPhht8wJrUvR98RFoPh89LWiVmLnOFOPvPfF/6xGwOoa1P9s77QcqINzyp29JYXisKwhc4zJ5gO6UN9qVY7aSkfsOaOEA6PV3HmApp7RStXWgxuvmJt4hqUPJgHwYw/aVsezWpcfXqwgpaHINp15hAMPLcIxdWZWh6iD2Ka8s8dN6f1vTtK5i/MHAx//eZLd+f3MOdibzSr2vM0tHfcdTl+q0TDG4neu3PsfPratI2p1EVChqyvFxRITuD+FsheAg6uTlD1iLUwedaSKxhh6dMbZJBTU1ammtSqCcqfoososnq26ysEzB5BdSa/DmusawrPz1IPIbnF7At8TRFRp6JKniHB/gHP/jDURJDbIm1qnP6JAaUR6V8RBjhASFxTpHxFRSMWDRmywmP+p/3I6Xr463gect4lq5cdLrloOCrE7+PhBgM58oP7CIo2iMqezNCcDPsSWDv88TCA9KRAN+l3g18NjYpC34tdbGaIEli2DuAHkez/FS1I+/kADJI5EE6Y/qi7+VFV8A+iF4X9A7/uFxDiSOPB0A1AxZAekUEgJFV4Dl8Osy7cO/cJAett0jNWr9FaNClRW7+epakE2Ui+SgccBhnp27E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 22:34, Swarna Prabhu wrote:
> From: Swarna Prabhu <s.prabhu@samsung.com>
> 
> This series is an RFC to gather design feedback to introduce a folio-range 
> interface for pinning user memory in the GUP fast path. Pinned memory is 
> returned as folio ranges instead of a page array: a run of consecutive PTEs 
> mapping consecutive pages of one folio is pinned once and handed back as a single 
> range. Block direct I/O converts each range into a single bvec, hence reducing the 
> per-page pin and merge work.
> 
> Base and dependencies
> =====================
> 
> This series is rebased on the following two series applied:
> 
>   - "mm: gup: batch PTE-mapped large folios in gup_fast_pte_range()"
>     v4 (Yeoreum Yun; originally posted by Yuan-Hao Hsu [3]), applied to
>     mm/core.git gup-7.5.ptebatch [4]. It batches the reference grabs for
>     PTE-mapped large folios in GUP-fast.
> 
>   - "batch lookups in follow_page_mask()" v5 (Rik van Riel) [5]. It makes
>     follow_page_mask() return a page count and record pages through
>     gup_fill_pages().
> 
>     Note: "[PATCH v5 1/8] mm/gup: break out gup_fill_pages() helper" was
>     posted just as testing for this RFC was done. To avoid delaying
>     feedback on the overall design, this RFC retains the tested base
>     linked in [5] and will be rebased onto the latest revision for next
>     version.
> 
> This series builds on both: the run detection in gup_fast_pte_range() and
> the batched slow-path lookup are reused, and this series changes how the
> result of a run is recorded and returned.
> 
> Background
> ==========
> 
> Kundan's LPC '24 talk "Transitioning get_user_pages to folio based mapping"
> [1] proposed a struct folio_vec (based on bcachefs) passed in place of a
> pages array. Building on that and on suggestions from the community [2], 
> this series exposes folio + index + nr_pages, where each range spans a 
> single folio:
> 
>         struct folio_range {
>                 struct folio *folio;
>                 unsigned int  idx;
>                 unsigned int  nr_pages;
>         };
> 
> Design
> ======
> 
> A "struct gup_out" descriptor in mm/gup.c holds either the page array or
> the folio-range array. The fast and slow page-table walkers append to the
> descriptor instead of advancing a pages[] pointer, so a single walk
> serves both interfaces without duplicating the walkers.
> 
> The PTE batching in gup_fast_pte_range() is provided by Yeoreum Yun's
> series [4], which this RFC builds on. This series reuses that batching
> and its page-table revalidation logic. For the folio-range interface,
> each pinned run is recorded directly as a folio range instead of being
> expanded into individual page pointers in the output array.
> 
> pin_user_folio_ranges_fast() stops once the caller's range array is
> full, so callers size the array in ranges, independently of the number
> of pages requested. A single GUP-fast walk is additionally capped at
> EXTRACT_MAX_PAGES (1024 pages) to bound the time spent with interrupts
> disabled when the buffer is backed by small pages.
> 
> unpin_user_folio_ranges() walks the range array and calls gup_put_folio()
> once per range, releasing the references pin_user_folio_ranges_fast()
> took for it.
> 
> In iov_iter_extract_bvecs(), the pinned folio ranges are stored into the 
> free slot of the bvec array and converted in place, one bvec per range. 
> Block direct I/O picks this up through bio_iov_iter_get_pages() without 
> changes to the block layer.
> 
> Non-folio mappings
> ==================
> 
> Memory that is not backed by folios, such as pages a driver inserted
> into a VM_MIXEDMAP VMA, makes pin_user_folio_ranges_fast() fail with
> -EOPNOTSUPP when no pages were pinned; such iterators fall back to the
> page-array path.
> 
> For folio-range output, gup_fast_folio_allowed() additionally requires
> a non-NULL folio->mapping, except for hugetlb folios. If the mapping is
> NULL, it falls back to the slow path, where the VMA can be checked.
> The existing file-backed and secretmem restrictions remain unchanged.
> 
> FOLL_LONGTERM is not supported yet and is rejected.
> 
> Testing
> =======
> 
> Measured the time spent in bio_iov_iter_get_pages() per I/O with
> function_graph, on the baseline and the baseline plus this series.
> Both kernels ran with the performance governor, boost disabled, all
> C-states except POLL disabled, and fio pinned to one CPU:
> 
>   trace-cmd record -p function_graph -g bio_iov_iter_get_pages \
>     --max-graph-depth 8 -O funcgraph-overhead -O nofuncgraph-irqs -F -c \
>     fio --name=io_uring_test --filename=/dev/nvme1n1 --ioengine=io_uring \
>         --rw=randwrite --direct=1 --bs=<bs> --iodepth=8 --iomem=mmap \
>         --iomem_align=2M --numjobs=1 --size=64M --cpus_allowed=23
> 
> Median of calls not interrupted during the walk:
> 
>   bs    buffer          baseline        patched          result
>   128K  64 kB mTHP      13.08 us        13.09 us         neutral
>   1M    64 kB mTHP      63.0 us         63.6 us          neutral
>   4M    2 MB THP (PMD)  25.9 us         8.65 us          ~3.0x faster
>   8M    2 MB THP (PMD)  49.4 us        ~17.0 us          ~2.9x faster
> 
> Note: the baseline is the upstream kernel with Yeoreum Yun's [4] and
> Rik van Riel's [5] changes applied.
> 
> For larger I/O, the baseline's bio extraction path requests at max
> 256 pages per GUP call, limited by the available bvec slots. This
> series instead uses those slots for folio ranges, each of which can 
> describe many pages, thereby allowing the series to request up to 1024 
> pages per call which accounts for the speed up observed in 
> 'bio_iov_iter_get_pages' for 4MB and 8MB DIRECT I/Os.
> 
> Testing: Ran selftests gup_test, gup_longterm and cow on the patched kernel
> and no regressions were observed.
> 
> Link [1]: https://lpc.events/event/18/contributions/1773/
> Link [2]: https://lore.kernel.org/all/f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org/
> Link [3]: https://lore.kernel.org/all/20260917083747.786-1-aa9736195201@gmail.com/
> Link [4]: https://lore.kernel.org/all/20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com/
> Link [5]: https://lore.kernel.org/all/20261102193026.3860700-1-riel@surriel.com/
> 
> Swarna Prabhu (5):
>   mm/gup: add struct gup_out output descriptor
>   mm/gup: make the slow path walkers record into struct gup_out
>   mm/gup: make the GUP-fast walkers record into struct gup_out
>   mm/gup: return pinned memory as folio ranges
>   iov_iter: extract bvecs of user-backed iters from folio ranges
> 
>  include/linux/mm.h       |  37 +++
>  include/linux/mm_types.h |  23 ++
>  lib/iov_iter.c           | 100 ++++++
>  mm/gup.c                 | 695 +++++++++++++++++++++++++++++++--------

That's *a lot* of churn from someone new to MM. :)

This will need a lot of guidance from MM experts given that this is your first
MM submission.

Sorry, but we don't have capacity for this:

https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/

-- 
Cheers,

David

