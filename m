Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA22560A2628
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h50fosA7
Received: by kanga.kvack.org (Postfix)
	id DADB36B00EF; Tue, 10 Nov 2026 09:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E986B05B0; Tue, 10 Nov 2026 09:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74BF6B05B1; Tue, 10 Nov 2026 09:04:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5D826B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:04:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35B4B140206
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:04:25 +0000 (UTC)
X-FDA: 85419379290.28.0FE5DCF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53C791C0011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:04:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h50fosA7;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794319463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5IAnWVHADA41IJuShMaFvKjUoEC1wrcq61K/G7feow=;
	b=otGjLbxCJVV4K3eUinFpiJ6xa6R7FiH/uTvGzJcChdiHWq+cj7M/Gvq5djkKIziUEtlMIz
	hFpwHKyJCES4U+MIUn5utSzJ6x/FYO94GyxFKG9fc7xVA6ekJNfaY44ckLwrheyMrUcqyK
	1bFSrowA0UfN0LwwdyCwkxj2NBbUxU0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794319463;
	b=kjAoymoSSs8iUsFYTKmixtFu409nudTmLQk1PmMYy/t+CuszqivAh6XJOZh+1gCR4l6HW3
	bx6PRibrtCkLKRXgjcfkFn2/cHNiG5igEN9e8+2IF2myZh5c4OqWHSSIZ/BiWXjWGlQSr5
	GyF8/w14uMbAiMaEiNQhVC84Ql9iRck=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h50fosA7;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4313B143D;
	Tue, 10 Nov 2026 06:04:19 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F10A73F632;
	Tue, 10 Nov 2026 06:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794319462; bh=+mA8U82Dmu9ftVLfB1lXmShJwdTcBL6ay0MsAqkBT58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h50fosA7PBG4YTWLL2nI17X7drceGdTlskyBQyQCe42PX4wOMVaPPoFfRqzRp7csX
	 0t5A4Y1a6CLZdWWA3+/e6tdAPTaOpEMvk9eM5mVMNqFXkYUeCzRFr57W9z6+S8wLmA
	 aYveBropJTBpgFFmbc+I6I855XbnB6DsFtCmhE88=
Date: Tue, 10 Nov 2026 14:04:17 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v3 6/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
Message-ID: <avMkYdbCetaQc_Jl@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-6-2aaef02df0e1@arm.com>
 <529b409d-748e-4f47-bb21-77b3237da39f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529b409d-748e-4f47-bb21-77b3237da39f@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: u4mwsqwdc4akzoeym4igibgxy5xbco5e
X-Rspamd-Queue-Id: 53C791C0011
X-Rspam-User: 
X-HE-Tag: 1794319463-697281
X-HE-Meta: U2FsdGVkX19lBNImhStHuSROnzo3uevpKWmCS9L1RhBgdOkmXdpQalYy4rONCbcU0YKfs6/WbFfOwLBvlUEsilfW0hjOCN5y1vtwMyou2L2rUVgqRilzY0dMWgeoffN+0Xx8jA8uJnpoLGvACEcuyDTmPOJHW1ib3GRMGZQwgoBo4K/pe3jV9U4DuM4cMY3rgOVDQznPcaDTFhXOZljJ6MkDlRfDeKq3AcJjXEAtUhP5LQMi7GO2b0lfwpUcZU5mJ/5HBWuBD/tMLxecrSjCzsYUVt1SkxmdVcoqrBJhZup6DvIpMS5GFHPntq9KrmVzl2F3sEBDfUuZPoCYHcuP0SydEISxoAnmeVhZYc3mUPIksCG1+ab5DT/FnTzGDzWwWPKNXdtgiiQtPGfyjQnXKwW9Rv+aDyeuIPyAbNH2Bz9qYkHKorFHpYDEdHmaPg1axS/KEVma2OKJpPOqCt4g+/EWPKk8kJyWrAGELjlh5zkz4gVY1689r+pfA7UyUX8XHt/gHF0En2AtCAQLnEdwweY2wFLenp1/LaVY3ooxP+OL0t+97u1/GMHBvYQX+yeFQqJrsdwlsGlsa7e/rxOcG+VcdlrwIJLDcZJXH2DZBqf3lvWa9QgZDEqeiD+ymNmf5bux3lBuEVBOAIqlnqCBTVhUML+hYpKl9oIYp06oKXwOStaoFEcW2xDDOT+wH8JkUVNt/5xEvIoOeAjtGhs8UiRVj6VHnycX+zbQO9G0HFbb5oly/XngokdVHoQWvX7hAwAkBhyj2VLobbVbQUj+N8Ugaf29yBHgjncDx7Wxvt+k7Bw+pbZ/UxmAP2N+F9lTD3hamTbcATrpeEE0wRsqEK7QyWdE+A5cNLHk9q/hh+rXTW9K/nr1VwWNb5D9MYfkFurwTgQcj8fZB9656kf95mw5V+3KyJIc4rkCCL5rKQvjRQaOJqZxnewuYvrukJyre1eZAz6JsdKK9VkGuzp
 Rx2dtOwB
 4kITaboUGxRZrq8qyB7jycTPng14EVQjYqbPLguXMyP3kSLnxyo9skQpT0xyJ7ipjKm3mTXMxE8G7dOCsqPRaBqXXohzLrbw+9UBqCefy4Z1nk/6W6FggDj6aYZg101Jtq64zomPXDR/aruJnuXbqr+vEZYSG0Y0T8VbKLqd0wq3Y12x0rpr/XuDPRgSRPO6d4tYFMaMMH/ok75C0z3aduVuSM3mBSvxqmtlqakqFe28MaYZG2SAW1hh8bKEP6qA6jOMhENswDFzfDC/Y511P9EeP5bML/KmbkKsC38FcIclGxDHv4RPDClUEknwRBB5HAZ+SDeydpZ/zqRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:09:32PM +0100, David Hildenbrand (Arm) wrote:
> On 11/9/26 13:32, Yeoreum Yun wrote:
> > GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
> > costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
> > atomic, a full barrier and a node stat update for FOLL_PIN), a
> > gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
> > pays sixteen of each and a PTE-mapped 2 MB THP pays 512.
> > 
> > The users are the hot ones: iov_iter_extract_user_pages() pins every
> > O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
> > buffers through it, and so does RDMA memory registration.
> > With mTHP those buffers are PTE-mapped large folios.
> > 
> > After the head page has been grabbed and verified as before, extend the
> > run to the following PTEs that map the next pages of the same folio
> > with the same protection bits, take the remaining references for the
> > run with try_grab_folio(), and fill pages[] from the run.
> > The PTEs of the run are read while the reference on the folio is held,
> > so the folio can neither be collapsed, freed nor split underneath the scan.
> > A read-only run of an anonymous folio stops at the first page
> > that gup_must_unshare() rejects, so the per-page exclusivity guarantee for
> > FOLL_PIN is kept.
> > 
> > folio_pte_batch_flags() does the scan.  It reads the entries with
> > ptep_get(), which is not safe without the page table lock on
> > CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
> > and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
> > Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
> > site, so the other callers do not change.
> > 
> > The order-0 path keeps its instruction sequence.  The folio flags are
> > tested before folio_set_referenced() on purpose: a load of the flags
> > right after that locked instruction cost about 25% on order-0 pages in
> > the gup_test benchmark below, and reading them first brings that path
> > back to the baseline.
> > 
> > gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
> > per call, median of 15 runs, two baseline boots / one patched boot, on
> > an x86-64 VM:
> > 
> >                        get_user_pages_fast()   pin_user_pages_fast()
> >                        before       after      before       after
> >   4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
> >   64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
> >   1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
> >   2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
> >   2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us
> > 
> > fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
> > buffer in 64 kB mTHP, median of 15 five-second runs:
> > 
> >   bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
> >   bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
> >   bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s
> > 
> > IORING_REGISTER_BUFFERS of 1 GB, median of 15:
> > 
> >   64 kB mTHP           6179/5998 us  ->  1599 us
> >   1 MB mTHP            5790/5801 us  ->   893 us
> >   4 kB pages           7173/6741 us  ->  6763 us
> > 
> > Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
> 
> There should likely be a co-developed-by? (also in the other one?)

Okay. I'll change.

> 
> LGTM, thanks.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely,
Yeoreum Yun

