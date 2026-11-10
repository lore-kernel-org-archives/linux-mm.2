Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F60A606BFE1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EhfGcWss
Received: by kanga.kvack.org (Postfix)
	id ADF1C6B05EA; Tue, 10 Nov 2026 08:13:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7D46B05EB; Tue, 10 Nov 2026 08:13:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4336B05EC; Tue, 10 Nov 2026 08:13:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 695C86B05EA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:13:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D0E5C0779
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:13:01 +0000 (UTC)
X-FDA: 85419249762.24.21E0F38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7134C4000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:12:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhfGcWss;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794316379;
	b=IGHYtu7i+vWkmx5+635ZBg6ICMC3dSMdGkhms1hlsU/Hej6rOf0RaIENGdlSYPn8+YDtqF
	vwa2Gc33/MgKQS+rsjD/iCfk8dNaEo/yEGCN+I9h3EQpiSdpx/CqSKmUdVp30hjYYM3t8E
	Fs7qDvqR0f/fIRdX9d3oAMGcKIlmgW8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhfGcWss;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794316379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lH5RrpAfhToS5Cr0qmiZUZ/9Gvt2X+LmFZ63KOZlNtw=;
	b=rmek+hG+3Tdxkaui6pqMXh+Uzsc6ofD7PAEstz8gVJmR0PuMDA6nFAHHJBIxwIQgUSHe/F
	+jD6pUX2l8Ca6KsH3ULGn8x8543mMKaECjysWPNyjzZfwdW0NGqrlx3QA1xA2hKhdA+lud
	Tj/J3G8CWPzoMnObnQ1Y5nYTKOB7NNY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5D2B40204;
	Tue, 10 Nov 2026 13:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A291F0089F;
	Tue, 10 Nov 2026 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316378;
	bh=lH5RrpAfhToS5Cr0qmiZUZ/9Gvt2X+LmFZ63KOZlNtw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EhfGcWssm5mwvPcP15MxRq+AxtbzI5vLg4mmjoRb7xKLF3nKLwweK0YB3gC1L78Wp
	 x5UnJlOr1WAqWxD6/lVGjWT7ZjtZRVG5IBBdfWXdvle3UUKQ+/Gy74m7AJBpL03k57
	 W5eDyuhxwC6legwnJhYuJTiK+l/xpNxK1ub5LJpu32u2uNHF0pPCwZrLS78/jpqIn5
	 TgZsjd95BLT1oWkyiqlsjuSZduYzdHJbRs855JZQpV05NXWT0tpNngKUFP2eNGCJO2
	 WWM2VcKzb25WC6D6MnDN+7YyzVxAWqcl0VuLLPSGxQcjFmv/Dc/eoZ2Pb37fXQbEFX
	 SbHt67W0pTjpg==
Message-ID: <529b409d-748e-4f47-bb21-77b3237da39f@kernel.org>
Date: Tue, 10 Nov 2026 14:09:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-6-2aaef02df0e1@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109-refactor_gup_fast-v3-6-2aaef02df0e1@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7134C4000F
X-Stat-Signature: 5y35gsb876kau7gw3g5hi5edbms96rqe
X-Rspam-User: 
X-HE-Tag: 1794316379-925009
X-HE-Meta: U2FsdGVkX18tXjYvLjq9mKlq4rHpkDq1eZhkcqXbTHKL4q4y4E9wyKKnTxQ8x6epGR30HIUDTP0S4vS/D0HMjS0hF5+MyBgzW+B9c8b+IGMob9IKt7VWvj8hp/ZjKyn+s+sPrfIi9JoyFRl5csZdng/2EA83xSIR8Pf5faMZ2s5Qg/6NCLUHYsFaf9jHGR7gV50rE4B6FIPSri6dxrgGVuKdbpwXSw0FeKiaJSJmGdS3g38GrK7HrCufMfoE2NesurvThKNxrG9qz+E2fc45KvAPixCyI+LTZ0SshdSTVtpkvw9oI0DeI0DGOyixybZxVvV+hIshu1JyFUFt+vDo4WVomgFx0kfk9fJv9sZkoP9L9FOKQ/D+OUN892nENNj5ssFJNxl9jE56kEUnLo8wcxwII+XreApgZ27PoCoWiV9Mev43Vro6jIXf9IGEiNIMOH3BrSZJRWCIBOnyXSkckWwtI0XIIU7pDs4GdCZpI9L0kbMRbmCxxdVq0GZkZJHaxzwnfBUYk5wfSFg767GjL4/NuoMh/uzqRif9gtaBqJqTQbjinnnMV1o3cqzk6msvwSY4pBdV0VXgeZ8xhO9CGnLrW1YxdGwNbc8FVzsvTmoCvKwq4juVzHMFl+443RUNJ3uhZRbwts1erq32DjV0f8CAlgOYpYbKV5NoNBYZQHnCjbkw0xT6yj8UZNx7mE3yQtPkBhFg7WAnZhUY5Um+ZkzDaqPqutlLbXQNeg3wV53Sx2iYuPecnLdAqx27huphppbXCuhZryXNXMRBUlrSfizx2vWpCCQRHx4LPqxNlJf5Zh5hpEO9gP04mu0ZTxOX/AbVHMTF0sO/jXOZ4/YxdOTQH6Dbr7nhHyBG/rYsGWG4sAGu1xHZ1lbJwhoD1PowCcH8JMkVBZ9kGR061JA+Qnm8EYCIFrSRb8/004THDqaD+mpDX9+2amLbBhntIeWEBRTznj3Wybx3f6zLdho
 uxEq+ALR
 dQjDdc8G0Ef1HT0E254XgJ10ddLn4Qm8ZuDr6eVVz8kEFdAX+n55+53hHjSIgAFcFcjO9K6XUbHIenh4W2eHMtVVTBg88/EoCVGkhJ9i1kRt/Vvj28egEKoItGS7IuVPkT2z3TXpCvsnf8x3li/W6ykcvztrzHITL2C/DhLRnl6qVaUHgA2jTGZnF4sI0ns3C4gU9naekqhMh3zTtsUVQUJ8Di8r92GQNqh+zMbFzJgYTLf3OsE2+oGJQGQrsTrYZoHdbMiXi6DzdJkMNPcHu4mRzreXpG/9/GWZUpetJWvLHl83yyhKNpyJMMzGjyiiK9l7GWY9tVHXrhkgySwzQzIL3bVVM/KJ/MNLv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 13:32, Yeoreum Yun wrote:
> GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
> costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
> atomic, a full barrier and a node stat update for FOLL_PIN), a
> gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
> pays sixteen of each and a PTE-mapped 2 MB THP pays 512.
> 
> The users are the hot ones: iov_iter_extract_user_pages() pins every
> O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
> buffers through it, and so does RDMA memory registration.
> With mTHP those buffers are PTE-mapped large folios.
> 
> After the head page has been grabbed and verified as before, extend the
> run to the following PTEs that map the next pages of the same folio
> with the same protection bits, take the remaining references for the
> run with try_grab_folio(), and fill pages[] from the run.
> The PTEs of the run are read while the reference on the folio is held,
> so the folio can neither be collapsed, freed nor split underneath the scan.
> A read-only run of an anonymous folio stops at the first page
> that gup_must_unshare() rejects, so the per-page exclusivity guarantee for
> FOLL_PIN is kept.
> 
> folio_pte_batch_flags() does the scan.  It reads the entries with
> ptep_get(), which is not safe without the page table lock on
> CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
> and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
> Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
> site, so the other callers do not change.
> 
> The order-0 path keeps its instruction sequence.  The folio flags are
> tested before folio_set_referenced() on purpose: a load of the flags
> right after that locked instruction cost about 25% on order-0 pages in
> the gup_test benchmark below, and reading them first brings that path
> back to the baseline.
> 
> gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
> per call, median of 15 runs, two baseline boots / one patched boot, on
> an x86-64 VM:
> 
>                        get_user_pages_fast()   pin_user_pages_fast()
>                        before       after      before       after
>   4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
>   64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
>   1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
>   2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
>   2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us
> 
> fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
> buffer in 64 kB mTHP, median of 15 five-second runs:
> 
>   bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
>   bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
>   bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s
> 
> IORING_REGISTER_BUFFERS of 1 GB, median of 15:
> 
>   64 kB mTHP           6179/5998 us  ->  1599 us
>   1 MB mTHP            5790/5801 us  ->   893 us
>   4 kB pages           7173/6741 us  ->  6763 us
> 
> Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>

There should likely be a co-developed-by? (also in the other one?)

LGTM, thanks.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

