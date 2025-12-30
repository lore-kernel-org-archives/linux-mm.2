Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCA5E95A98
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2F36B0088; Tue, 30 Dec 2025 15:51:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70AA6B0089; Tue, 30 Dec 2025 15:51:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A316B008A; Tue, 30 Dec 2025 15:51:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 814546B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:51:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 392371401D2
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:51:38 +0000 (UTC)
X-FDA: 84277333476.07.D96CACC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 203AA140004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:51:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DjLjN4Lh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767127895; a=rsa-sha256;
	cv=none;
	b=ugZ1AuHKZKwCIxdZgpyfpzcelKoAnFuNiEaGcY6+LX/Qzf/Ej0RCAkI2PtxrXqb0YyBXoJ
	tJCQPMpey4Nmo5tbRaX2m1kFE3HvvPqmT3GN6qoWbZAQJJmK3VDbBsRyVggNs+mkrJ0auP
	a41/ysIFGS0aQsgf+LmvN/4jzQCogPQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DjLjN4Lh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767127895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYV0wr0w15SHChxlTYhGXZJaFt5zZ5x2zyP4i+7jSTM=;
	b=DG0FVp7Ls/EvG7vqH4R89DLvccEeVgPLP4UuCN5whwvR9ejEECtGkOgZkR5HQf9X7Hb9SJ
	uDNKZMmXVvLO5r+CnbrafweY9V/v3XAe8THAvLjUesI6Oid67eTczvzsyY2Kg1fZO9VmaS
	/akU+njJ+UrboIxiJ2T+3BiUjhsTfHk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=LYV0wr0w15SHChxlTYhGXZJaFt5zZ5x2zyP4i+7jSTM=; b=DjLjN4Lh2e7QhxY6Scy+xxes/8
	61PoCx1nXnUXVJomvyzkK1LS8vB4YklbjjRn0LEGAbJqAdoWgllDJbi+6xTIoqsrwV3yCdOtoJVY4
	hzHmEKmobxE5/zphTyna/Nyp+aT0k7Wi8URiOg5uZeurZcV631dmyy5HmESkJu7JmSBmrpkQruYIw
	VFThfIzW/sIA2jMKV++ntrpNr9OEe72/3aDz4nNC4a56WaOmRMbU4FzeM9UWo8abBm1NzrDNVuoSc
	r4Fwlq+bE/Jy7tRK0HOPQksOla6slgLgira/Cv4wyvhuAaRHctNXnVXKXgKx/ayymPzt/qXuVAn1a
	mwgI2MpA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vagga-00000003Og9-0Cod;
	Tue, 30 Dec 2025 20:51:20 +0000
Date: Tue, 30 Dec 2025 20:51:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Chris Mason <clm@meta.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	mhocko@suse.com, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <aVQ7RwxRaXC5kAG2@casper.infradead.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <7ia4ldikrbsj.fsf@castle.c.googlers.com>
 <1fe35038-abe1-4103-b5de-81e2b422bd21@linux.dev>
 <87tsx861o5.fsf@linux.dev>
 <c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
 <krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
 <03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com>
 <slvvzxjhawqb5kkgfe2tll3owxjwtq2qkwd7m3lmpdslss73lo@hkewnkbik3qr>
 <59098b4f-c3bf-4b6c-80fb-604e6e1c755e@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59098b4f-c3bf-4b6c-80fb-604e6e1c755e@meta.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 203AA140004
X-Rspamd-Server: rspam10
X-Stat-Signature: xdnu5nfnkgwuwje6pf6rfd3syds9d3ef
X-HE-Tag: 1767127894-515993
X-HE-Meta: U2FsdGVkX1/bKqiMPMscJrGtFGTy1ZhzEOf8LcMfdRv4RAkk9Uf/vYLLa2YBxXaDRVBypDOvVPeUbUXGLLGWZb0K72Qtvtj3YV/IQQ982LCxsW3cOQi7d9mW9q5l7WBVBiPSM9fSyihqbejh+CjJr+R1IjxX/F9L/jE9ImuBLtsa9Gz8VhdsCew8xDjuI5fNDtW894+TwJX24c0iP+guVh6yV721NZgOe8joPQjPfgcHF47cYL3f2qSfTmJZl2OzOVqp5odCgVuIIMEqOmZBriKebJu2swcnC6hbyC4krmycDrdYlnTdq/TDOHnPhwndl2n3eXOHsBNWQlSjEpGg0nFCs8QbQCYgEgxOxcpZloAxCl5gTMZJN2e0hI4b/3YisS+VuIU45iokX6rH7L4zJwFZp1DI/qb25hZyPlQY4MWPOdD5H+vQSd6mCLE82MYr0+vRsgsaQ2hmfGnh+y/YWLu2nv42jJQGc85TwEmPa0u0aa0ht2UGay/yqeJCwXrVYKb+cb57j/qG/CqGypVZ09yoGVn3WfKo7YfPDHIiCRm3SH1VwQGI1m2lNeffTUOK2MwSD7ppw8gOCM0pyi0pnAc81I5VV2ibjEirhR/WiVV7CEhpvQB3Jyut4jGal0qFtbq5Azuad9whw7ayF1HQBXzgtbxBSpdxAllcB2BifU+o0BOYu6S2MTipNVNuTFWMd1rZxLulVnHfGL96AV+X7U1Xf2xEOqN4vBLhe1JPydzNAfVYmTvZtcMYoI16XaMJfW/Ev9dnD8WgVEFhVF9hXjtDBp/GST85uco4qc5BLcdx5X620P4+xMM/ca0Sn/YHBuA5r9BI/u1d/Oo7d4W1OvlV3/mrO1ZB/AUo3r4G1Em/kH4L4sQ/TuKAynR1Kmf7h4CZP2d1SYcVGprrv4DIYfFCDbJqNXCHeUqlPLTtbm9s5qdWl/v8bZcl2UzLQvS4MHvZ8B9TlUHz72yhniA
 XGZRnDhZ
 Rui8lFshvWL3SP3oa1rk2z1V7AX8UAWzj7exZVAETsXO3NXasfG1boWjSgS2QcXxVIcITZQiHfYZzwGPyVwfs3yrkGFTc2UbdQKNxA5aBJcl4aX2iA+RrRMpd9Ge1Hf9VHBgLM7VFPZxIArj//4HC1/nSGDouyiNJiMlmvO3SDzhQtewABtkvp4JCKrKEyQwbBb4GuIZTkCc6MnsObLLJNl3i5zXKl7LLpTCImBAVQuRabOMDCkidPi+StF7djlUhyAGhVflojF38ZaKpyivXDdnn4ZRJ1mBZOO9y0P3rdPAkXmi0AJpcKs4tuLwYFNjwm02y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 02:18:51PM -0500, Chris Mason wrote:
> >>>> I just think you should do a preliminary review of the AI ​​review results
> >>>> instead of sending them out directly. Otherwise, if everyone does this,
> >>>> the community will be full of bots.
> 
> I do think it's awkward to dump the whole review output for the patch
> series in a single message.  It looks like there's a sudden jump to XML?
> It's better to reply to the individual patches with the comments
> inline, which I think is where Roman is trying to go long term.

I don't know what Roman's trying to do long-term, but his email
that started this thread was so badly written that it was offensive.
Had it been sent to me, I would have responded in the style of Arkell
v Pressdram.

> With BPF, it looks more like this:
> https://lore.kernel.org/bpf/?q=AI+reviewed+your+patch

That's actually useful.

> >>>> 2. Looking at the mm prompt: https://github.com/masoncl/review-prompts/blob/main/mm.md , are you sure the patterns are all right?
> >> 	a. Page/Folio States, Large folios require per-page state tracking for
> >> 		Reference counts. I thought we want to get rid of per page refcount.
> 
> Early in prompt development I hand picked a few hundred patches from
> 6.16 fixing bugs, and I iterated on these adding subsystem knowledge to
> catch the known bugs.  That's where that rule came from, but as you say
> there's a risk this information gets old.  Do we want to get rid of per
> page refcounts or have we done it?  (more on that at the bottom of the
> email).

There is no such thing as a per-page reference count.  Any attempt to
access the page reference count redirects to the folio refcount.  This
has been the case since 2016 (four years before folios existed).  See
commit ddc58f27f9ee.

We do want to git rid of calls to get_page() and put_page() for a
variety of reasons that will be long and painful to write out.

> As an example of how I'd fix the prompt if the per page state tracking
> were causing problems (and if we didn't want to just remove it), I asked
> claude to analyze how it is still used.  The output is below, I'd double
> check things as best I could, shorten into prompt form and send to the
> list for review.
> 
> Per-Page Tracking in Large Folios - Analysis
> =============================================
> 
> Based on analysis of mm/*.c files and commit history, MM-004's claim is
> still partially true - large folios do need per-page tracking for some
> bits, though recent work has significantly reduced this.
> 
> 
> Bits That Still Require Per-Page Tracking
> ------------------------------------------
> 
> 1. PG_hwpoison (include/linux/page-flags.h:118)
> 
>    Defined as PAGEFLAG(HWPoison, hwpoison, PF_ANY), this flag is set on
>    individual pages within a large folio when hardware memory corruption
>    is detected.
> 
>    The folio_test_has_hwpoisoned() flag on the second page indicates at
>    least one subpage is poisoned, but does not identify which one.
> 
>    When splitting a large folio, page_range_has_hwpoisoned() in
>    mm/huge_memory.c:3467 iterates through pages checking PageHWPoison()
>    for each:
> 
>        static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
>        {
>            for (; nr_pages; page++, nr_pages--)
>                if (PageHWPoison(page))
>                    return true;
>            return false;
>        }
> 
>    Used in rmap code (mm/rmap.c:1990, 2070, 2473) to check individual
>    subpages when unmapping or migrating.
> 
> 2. PG_anon_exclusive (include/linux/page-flags.h:146)
> 
>    Per the comment at include/linux/page-flags.h:139-145:
> 
>        "Depending on the way an anonymous folio can be mapped into a page
>        table (e.g., single PMD/PUD/CONT of the head page vs. PTE-mapped
>        THP), PG_anon_exclusive may be set only for the head page or for
>        tail pages of an anonymous folio. For now, we only expect it to be
>        set on tail pages for PTE-mapped THP."
> 
>    Used at mm/rmap.c:1408-1416: when RMAP_EXCLUSIVE flag is set for
>    PTE-level mappings, it iterates through each page:
> 
>        for (i = 0; i < nr_pages; i++)
>            SetPageAnonExclusive(page + i);
> 
>    HugeTLB stores this on head page only (see PageAnonExclusive() at
>    include/linux/page-flags.h:1153-1162), but PTE-mapped THP needs
>    per-page tracking.
> 
> 
> Recent Changes - Per-Page Mapcount Removed
> ------------------------------------------
> 
> Commit 749492229e3bd ("mm: stop maintaining the per-page mapcount of
> large folios") by David Hildenbrand (March 2025) introduced
> CONFIG_NO_PAGE_MAPCOUNT which:
> 
>   - Stops maintaining per-page mapcounts in tail pages of large folios
>   - Tail page mapcount is now always logically 0 (-1 value)
>   - Removed _nr_pages_mapped tracking
> 
> This was a significant simplification, but it does not affect the
> per-page flag tracking described above.
> 
> 
> Flags Stored in Second Page Only (Not Per-Page)
> -----------------------------------------------
> 
> These are stored in the first tail page (FOLIO_SECOND_PAGE) and apply to
> the entire folio, not individual pages:
> 
>   - PG_has_hwpoisoned  - indicates some page in folio is poisoned
>   - PG_large_rmappable - folio is rmappable
>   - PG_partially_mapped - folio is partially mapped
> 
> See PAGE_FLAGS_SECOND definition at include/linux/page-flags.h:1218-1220.
> 
> 
> Conclusion
> ----------
> 
> While per-page mapcount has been eliminated, PG_hwpoison and
> PG_anon_exclusive (for PTE-mapped THP) still require per-page tracking
> in large folios. MM-004's claim remains valid for these specific bits.
> 
> Key source files:
>   - include/linux/page-flags.h (flag definitions and accessors)
>   - mm/huge_memory.c (folio split handling)
>   - mm/rmap.c (reverse mapping with per-page exclusive tracking)

This is pretty good and yet dangerously wrong in some missed nuances.
Which probably summarises the state of the art nicely ;-)

To start with, all flags marked as PF_ANY are set on individual pages
rather than only the folio.  So that's currently:

PAGEFLAG(Private, private, PF_ANY)
PAGEFLAG(HWPoison, hwpoison, PF_ANY)
PAGEFLAG(VmemmapSelfHosted, vmemmap_self_hosted, PF_ANY)
__SETPAGEFLAG(Head, head, PF_ANY)
        return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);

Now, PG_private is a flag we're trying to get rid of -- it should be
identical to (folio->private != NULL), so I haven't made any effort
to convert that from being PF_ANY.  I'm not too unhappy that your chatbot
doesn't talk about PG_private, but a more full answer would include
mention of this.

PG_hwpoison and PG_anon_exclusive will remain per-page state in a
memdesc world, and there's a plan to handle those, so there's no need to
eliminate them.

PG_vmemmap_self_hosted is a very, very internal flag.  It's OK to not
know about it.

PG_head has to remain per-page state for now for obvious reasons ;-)
In a memdesc word, there will be no way to ask if a page is the first
page of an allocation, so this flag will not be needed.

I believe there are some subtleties around PG_hwpoison and hugetlb that
are not fully captured above, but I'm not convinced of my ability to
state definitely what they currently are, so I'll leve that for somebody
else to do.

---

Looking through your prompts, there are definitely some conditions that
could be profitably added.  For example, pages which are mapped into
page tables must be PG_uptodate (we have various assertions in the MM
code that this is true and they occasionally trigger).

