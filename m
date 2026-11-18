Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2081B606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SQk6rADC
Received: by kanga.kvack.org (Postfix)
	id 1AC6D6B05EA; Wed, 18 Nov 2026 16:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158016B05EB; Wed, 18 Nov 2026 16:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045AC6B05EC; Wed, 18 Nov 2026 16:36:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C03636B05EA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:36:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DC9E1A028B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:36:44 +0000 (UTC)
X-FDA: 85449549528.27.8AB4AAE
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9CA31100002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:36:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SQk6rADC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037802;
	b=WExUzQ1nPDd9pjnadRZhzbk+PCLVuI8U5IUVPyoZMC7kmrIYZ0lJvtfaal8hXe/3bPA3Z5
	tk8TPPYKelI1jAFLOSRczdmRkGHBrnDh756aDHP6mIhmHsCPyqZjk+bztbEqU4ZRgQLs/z
	M4S+Q/kSGkqLUaMkc10iXAmJ8Ic4QWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PTc7ppHJ4lMykoz5PJpIQu+5Hn27M/f7qYx8yuQcu48=;
	b=rgjVBwli5FntU8B5NvKaAt6IibDr/geOOCM8zaH/LIkeCWYiuNKEqIaYtrF16sipKD8CqD
	VMmNahOaJgKEFPUp97S7yhndaaKwkp1ggtzB6tGGKI0bEbR3kilup5B/X4dn+OJweV5f6k
	Q9/SIKZy94YhHDp0alxwJcwsoAVA5dw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SQk6rADC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b4bc5b8de5so1881767b3.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795037802; x=1795642602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PTc7ppHJ4lMykoz5PJpIQu+5Hn27M/f7qYx8yuQcu48=;
        b=SQk6rADCBRvyHSbYPjtnJobmUg6GF89cy4tnxCx1PLjUA9bRYTzWdcdf2wV0tHzg9Z
         pOUDIvkYm9YIgX4fULMcqdSzFaKV5Gr7NMEai6vpBOvbOv/sbjx2GvI1Iz5m8+mcmPuN
         S6bCmHgpQmmfY3BDbvk77hHj4/zcvHqzghzE4t7ar0BOeNE+lKWGsm18IBa+3B4mrRJh
         CnRupZH4rQ2RMa8A1Dk0Qi5RGw0YR7aiMKnrqkFuRQswsQ069+HNyvLRt64rGaX9cjL1
         gF4qunoJkovNMLZMW4COl2xiuFiJHyNFZ0Xob9EzXOD2ctO5hTmY3Q48ulRwI+ZtXOP8
         0OJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037802; x=1795642602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PTc7ppHJ4lMykoz5PJpIQu+5Hn27M/f7qYx8yuQcu48=;
        b=a8PVHrCUt02tCkU6Uag1OIt+SwQuj+up0HPDuJ8Lyl6bAazgbMsFCVkibYkV0FBeSA
         MZ3LBIcVSwjZmfT4ujHUdBsVm2T2dgkMfKJBg8w9Bdbh8B0eFJLCECy6ZglspKKDC/yl
         Fuxc+DcP5YgciCIDaYbTkdVvbW3WtU+fT+JHu2JSaMw0Voe6DrI8dynimKGeXkxefVmy
         ZvVLXFshPnsKaaYehKgrWsq9g7t0+VC5j4S57doI8Dtp3JCpbqUPSkCYNKFHO0SxIoHv
         7S3HrdRsYUlb40bAsMGPFqYubE0YI3e2dFUOgFzv3C+qZMvZ8VSx81qbPicb2S3TcL9O
         +UhQ==
X-Gm-Message-State: APuU4Z9miQPeYTIVKe1YwicH/lYEywbvBbfcqzEHx3LweFbm7T4wGl5A
	lb435s067ZwUZ2BuZv90djUGNGJY9aIepGYqzLhHjL9epA/j+pzlfWpz
X-Gm-Gg: AZFdTZdOFWs4pJZ5c4femi68+/2bf3JA52PwRBqd+uyC3/eLWye4Eqgud0OPUhJZOd2
	z44n44DEPUEzQNjB/n3lWNtVB3mjDWsbqPIfA2ZJz6UdwERaJ8eE9yhXXzJxW2Ni/iRWsI4Y45A
	2AerN/zhwUulaN8ztRn9f6WWtv5AqftmNvTxK0v1LuKXUOKRWQKt32XTN4yIqZSSipmxt8bjgt2
	vnGDn6Ao0Hq3Oa7oEEE/4HE/lZjddDhfpMOL6N5N/eIwm7EhItFpvcaUGEYwn+FKDUeR6BnwN/G
	p5fNn2qDJT/YuDAzDS96IddYhMFvtqHAYyMNrk6IWuUTMBr8VgwegBkqSpsOZtl6Nl8u2lUivJ2
	iddKomk9xlG6CjZ0zilJlEAmuNzz2tbOSs6vh6w8gAWGqJJ4E9b3TzirAsThqYXOV2FtaodCF7R
	qHal4mEV/574IIy1IOwdgABHHOobQ9mmb3S6StWdAC3bN6bRnRE+tYylXsq8be+pMXT6SHgLtkn
	MBriiw63CjcSopnN01io1xO0eheEAJid/HVNeIVAXDFHzAJu+VyEWvdosn1E0c0Bl72bMuBxp0K
	KxuxtujOtb/JQBL45IeGtPRHTz5Atd9WiQpHBs57PLixOm9bJzQvXHA=
X-Received: by 2002:a05:690c:6b10:b0:8ae:b617:712d with SMTP id 00721157ae682-8b5104a9bc1mr3344367b3.13.1795037801404;
        Wed, 18 Nov 2026 13:36:41 -0800 (PST)
Received: from 5163NRD-SPrabh2.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe030be2sm24565697b3.10.2026.11.18.13.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:36:41 -0800 (PST)
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	viro@zeniv.linux.org.uk
Cc: linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	riel@surriel.com,
	yeoreum.yun@arm.com,
	hch@lst.de,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [RFC PATCH 0/5] gup: introduce folio-range interface for pinning user memory
Date: Wed, 18 Nov 2026 13:34:53 -0800
Message-ID: <20261118213458.377258-1-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1psu1n77apq1kucwaprkqmgzahbtde73
X-Rspam-User:
X-Rspamd-Queue-Id: 9CA31100002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795037802-890963
X-HE-Meta: U2FsdGVkX18mCyqgKSFZCdc+Be9esKK7wxU1A1PLYcmEZeo2JMK+QvMulP+bzw4Y2gRIt/vT1dcUboWZe7pYmNDfnrKEOyfgWmxVSsUA3wML9fG2GZoJzqKBsX5DPKGkVu8t05GRoFW70u/xKqgcI1nsisrCPdg5Ec0LQKclN1i/STqL8VbLJqmAnEKggfe80zb2xIlJubJrjo6A078qPeQpOY93SpTvfwf63R5jTeHtNzu00T5W9T7j5tRIhDSGNVHN0+s4OfyK52aI1T9oXsMzS912q/xmHTL8MS7nHl8lTM/Ndt/n8Rr5ohvqDNCirTtL9vYyWz1Gyr+++T1R5aJYmg/aKDZVjU0d3ZGvfUVA1yUsNgmdjv0FMMyJDbjMzs5SubR+nYMyMzkFxwabjdpJnGnrJNSNCSdgI2D3+ARIZ3Q/l+fJVAi4AVgDmsG85zTmGoZBWdAm4OcuTRZyxPY//xP1pzYAvsWHaZi7hJARKQQK4hwLIQA7CoAKPsdte1OzvpZP8Y5jl6nHUJN0PraSTWz69/1Fg9NCFEth35OG6O/eEVqjLOQxQ+iiMoxvxEWa2RCOsUjXhMeBkRBnOYH9uQh0F/XRSCbhEV0ecJ2UsfH5niIZpEYRhD08mvuzjwR33lRPJ5dzomhxxZ+OrEjfg0HNPbNuITpWFlcXVXIcGN7YrAfMpMznjc1CSJrRx1tqCl1NKLpoXxQYTJAsOy6DMjsLdes23XKShGbKj0i8Y5utVj/ocvf5/Gz1h7wnmyQo0VczNYoJjPtknHij5+O7uDM9pARhCh0rGBaVAi0hZadl8PnhT9UfEGWoJidG9Tc7Co4xGErVJrYVbqzZPJRXac9RG5mN3MTP1WzWOOjAtNKscJZzwBpvaHRV6oaWtKagxXoEOUKwtXK/6ZX8mFxH8wLjO50ZuIzaMjCYrDUTEzhAbh7SKIRUo634OtpeU8tbGj4fbMvccyAbVHD
 n7YRDSUC
 CKrChJAqhesrKgSzmFhLII6mmfI04oSDNS9dE/OZavDcdVoPN+oV3aeUq+JQdNYOr+zFzAf13tiNr12HSjyjjPMJd6qb9CLTDep+L2qMbudIbTjC4KAVSe1d6Wg9fcQunLfxF2l5U/wn/Q4MarPDA8SBaBkRxaXN64M0QjDlRUX3M9UOKNvGl8U8XFjuhtpJV6lqctK62bhawp8DVZpx4tqhPT7aG7qlvHM1bwOQUQFl92aR9nZA9PlxiqZcYURrkJ8CRrzRyZl8cV9SK+vpQXdQlV7YG0b0AorVJCuCjPy5+nk/dASlQkExs28sPz7czV+2Yb7dUrgtHb1d24yXbsaCvnYSIxYOdjUabVkHgAEPbeghdHasmuzQ2jJU/PuBEQilqYyZlaVXuf/UxfUqaA/dsVXzt6c430uguIuz4PYVMpBh4CGpxvF1OMbCGwFZzknNh7wcT5RwIUNahMyYD/tQ3phgrLKpIvB+DPiqDvSr3mLu8m3y0SfC28vEPuHBcQvOD3TowcAmKGa4xd++j+gb5ID1iyYveELqcyKUmeSV7zsedRKaPG5+rcoLzi6RTF1AFK5ENBJ2t3OM6jOgBZijdU5SRRgG14neVonymU/Qzb9ubxJJdRNavzbjQ//8J+Zfv3v5Dnk3URLW3QDgFBz2ruB8tt2IB/QFG8WfGHdzssWf+Nc7T53bFSwETRU84y300DEZx1xolJIpxGAFqCCLekj7bKX5pEiNFaCVQLoFEzJ5L2+X0suER6ynzeoNoKX2vcJ1hKwWyCfQKcPzT1cUJfK/7zLKKesw0ar92zflVGyLoLUQVczMc8CbGYsYI6i7z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Swarna Prabhu <s.prabhu@samsung.com>

This series is an RFC to gather design feedback to introduce a folio-range 
interface for pinning user memory in the GUP fast path. Pinned memory is 
returned as folio ranges instead of a page array: a run of consecutive PTEs 
mapping consecutive pages of one folio is pinned once and handed back as a single 
range. Block direct I/O converts each range into a single bvec, hence reducing the 
per-page pin and merge work.

Base and dependencies
=====================

This series is rebased on the following two series applied:

  - "mm: gup: batch PTE-mapped large folios in gup_fast_pte_range()"
    v4 (Yeoreum Yun; originally posted by Yuan-Hao Hsu [3]), applied to
    mm/core.git gup-7.5.ptebatch [4]. It batches the reference grabs for
    PTE-mapped large folios in GUP-fast.

  - "batch lookups in follow_page_mask()" v5 (Rik van Riel) [5]. It makes
    follow_page_mask() return a page count and record pages through
    gup_fill_pages().

    Note: "[PATCH v5 1/8] mm/gup: break out gup_fill_pages() helper" was
    posted just as testing for this RFC was done. To avoid delaying
    feedback on the overall design, this RFC retains the tested base
    linked in [5] and will be rebased onto the latest revision for next
    version.

This series builds on both: the run detection in gup_fast_pte_range() and
the batched slow-path lookup are reused, and this series changes how the
result of a run is recorded and returned.

Background
==========

Kundan's LPC '24 talk "Transitioning get_user_pages to folio based mapping"
[1] proposed a struct folio_vec (based on bcachefs) passed in place of a
pages array. Building on that and on suggestions from the community [2], 
this series exposes folio + index + nr_pages, where each range spans a 
single folio:

        struct folio_range {
                struct folio *folio;
                unsigned int  idx;
                unsigned int  nr_pages;
        };

Design
======

A "struct gup_out" descriptor in mm/gup.c holds either the page array or
the folio-range array. The fast and slow page-table walkers append to the
descriptor instead of advancing a pages[] pointer, so a single walk
serves both interfaces without duplicating the walkers.

The PTE batching in gup_fast_pte_range() is provided by Yeoreum Yun's
series [4], which this RFC builds on. This series reuses that batching
and its page-table revalidation logic. For the folio-range interface,
each pinned run is recorded directly as a folio range instead of being
expanded into individual page pointers in the output array.

pin_user_folio_ranges_fast() stops once the caller's range array is
full, so callers size the array in ranges, independently of the number
of pages requested. A single GUP-fast walk is additionally capped at
EXTRACT_MAX_PAGES (1024 pages) to bound the time spent with interrupts
disabled when the buffer is backed by small pages.

unpin_user_folio_ranges() walks the range array and calls gup_put_folio()
once per range, releasing the references pin_user_folio_ranges_fast()
took for it.

In iov_iter_extract_bvecs(), the pinned folio ranges are stored into the 
free slot of the bvec array and converted in place, one bvec per range. 
Block direct I/O picks this up through bio_iov_iter_get_pages() without 
changes to the block layer.

Non-folio mappings
==================

Memory that is not backed by folios, such as pages a driver inserted
into a VM_MIXEDMAP VMA, makes pin_user_folio_ranges_fast() fail with
-EOPNOTSUPP when no pages were pinned; such iterators fall back to the
page-array path.

For folio-range output, gup_fast_folio_allowed() additionally requires
a non-NULL folio->mapping, except for hugetlb folios. If the mapping is
NULL, it falls back to the slow path, where the VMA can be checked.
The existing file-backed and secretmem restrictions remain unchanged.

FOLL_LONGTERM is not supported yet and is rejected.

Testing
=======

Measured the time spent in bio_iov_iter_get_pages() per I/O with
function_graph, on the baseline and the baseline plus this series.
Both kernels ran with the performance governor, boost disabled, all
C-states except POLL disabled, and fio pinned to one CPU:

  trace-cmd record -p function_graph -g bio_iov_iter_get_pages \
    --max-graph-depth 8 -O funcgraph-overhead -O nofuncgraph-irqs -F -c \
    fio --name=io_uring_test --filename=/dev/nvme1n1 --ioengine=io_uring \
        --rw=randwrite --direct=1 --bs=<bs> --iodepth=8 --iomem=mmap \
        --iomem_align=2M --numjobs=1 --size=64M --cpus_allowed=23

Median of calls not interrupted during the walk:

  bs    buffer          baseline        patched          result
  128K  64 kB mTHP      13.08 us        13.09 us         neutral
  1M    64 kB mTHP      63.0 us         63.6 us          neutral
  4M    2 MB THP (PMD)  25.9 us         8.65 us          ~3.0x faster
  8M    2 MB THP (PMD)  49.4 us        ~17.0 us          ~2.9x faster

Note: the baseline is the upstream kernel with Yeoreum Yun's [4] and
Rik van Riel's [5] changes applied.

For larger I/O, the baseline's bio extraction path requests at max
256 pages per GUP call, limited by the available bvec slots. This
series instead uses those slots for folio ranges, each of which can 
describe many pages, thereby allowing the series to request up to 1024 
pages per call which accounts for the speed up observed in 
'bio_iov_iter_get_pages' for 4MB and 8MB DIRECT I/Os.

Testing: Ran selftests gup_test, gup_longterm and cow on the patched kernel
and no regressions were observed.

Link [1]: https://lpc.events/event/18/contributions/1773/
Link [2]: https://lore.kernel.org/all/f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org/
Link [3]: https://lore.kernel.org/all/20260917083747.786-1-aa9736195201@gmail.com/
Link [4]: https://lore.kernel.org/all/20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com/
Link [5]: https://lore.kernel.org/all/20261102193026.3860700-1-riel@surriel.com/

Swarna Prabhu (5):
  mm/gup: add struct gup_out output descriptor
  mm/gup: make the slow path walkers record into struct gup_out
  mm/gup: make the GUP-fast walkers record into struct gup_out
  mm/gup: return pinned memory as folio ranges
  iov_iter: extract bvecs of user-backed iters from folio ranges

 include/linux/mm.h       |  37 +++
 include/linux/mm_types.h |  23 ++
 lib/iov_iter.c           | 100 ++++++
 mm/gup.c                 | 695 +++++++++++++++++++++++++++++++--------
 4 files changed, 717 insertions(+), 138 deletions(-)

-- 
2.43.0


