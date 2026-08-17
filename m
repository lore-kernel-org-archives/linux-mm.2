Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88EECC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83BB56B084F; Mon, 17 Aug 2026 12:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECE06B0850; Mon, 17 Aug 2026 12:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702ED6B0851; Mon, 17 Aug 2026 12:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E19E6B084F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:34:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C980A8080D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:34:01 +0000 (UTC)
X-FDA: 85111308282.14.12EFEA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B3FFC0004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:34:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVe0wnP6;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786984440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=yArJ3n0LedpZD7yr7DsVqSaiwMdPJtOBt5PMrcip4oQ=;
	b=p3yXrGuNAammC3YD8Jh5MhmCe2qOHS3XjyaAsCXmyIfuyAhqmruvcMdF4uEOjIPQt4hygR
	qWq6s3yMGnWVaCtzEfOvMLuKQ7kPFsCfObup8mgboiOpoIHL+yXKfPiyCQzhwvXfm4iJ8R
	JY6Z0l6CoTYGgHiD81CzjueyBNNszRY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786984440;
	b=lRciqRl7rdl1Ie7d5Fys+UAJ6YCcGKrQDlzjQDiBniQyNrzYIjAUxNlUFhH4JvLSxv1yJu
	BUPX+KqUi0VAOlSyJtzf29wRZ8sz7q2IBtEISU2AXOEkgg6Rhjq0MjTsfEFAGaYgOrMrja
	lTCL4Ori+TncdXTk9bUgBrsQVnIfzOs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVe0wnP6;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A75B7601E0;
	Mon, 17 Aug 2026 16:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21751F00A3F;
	Mon, 17 Aug 2026 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786984439;
	bh=yArJ3n0LedpZD7yr7DsVqSaiwMdPJtOBt5PMrcip4oQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=PVe0wnP6NQy5lHXwo+hOArsEWIzrAmBGS3XKY5dRqDHavILmjT/IFQ/1+yyQ4FGRQ
	 1nBrp2wXxv4EjfOQtWbakN3sN+mu/H5ziCgevGS8fbF+0EZBgufhbLQ/AOOTjg5qnI
	 LX02KkOu+3g8lWLRacPiebN0nOvk407RP/DOAI10GjVFOq7pVEPkjJubmLxwgFfDPs
	 zX18+rwFQ4Kkf5rvbhvksCcaRuwit2MkIBSJTl7/kWBRSvOzKnyQuhl7ZjtI/W8kxi
	 MW/gl+czNGXxExoHdOHIJyUM1/l7R0ZZVHgFF2aMwIrCXXMboOlYGIdy2BkOuezO3O
	 WoEAHc5YgmmAw==
Date: Mon, 17 Aug 2026 17:33:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
Message-ID: <aoM3BJE2mGmHZybs@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMynfFI2XK2UXXN@lucifer>
X-Rspam-User: 
X-Stat-Signature: 13pd98q66x99m4fg1csfku1ssb1dmc3j
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B3FFC0004
X-HE-Tag: 1786984440-565311
X-HE-Meta: U2FsdGVkX19kYDjgK3KEsvq08GXy7NvoMtFbpbv2MQ6DHyF3r/1+SPjshAwtc4b8w0gFIaOVDCmdKqMeUbgONuUY0Xoj/8gfABubf7ku7Vb3u6LKCSrlIqrX15l9gYUXsGH6JGGzNUjpgMjyFmWXD5poL5/bipWif45eonJwv0NzMLkITR5VQhEGGSyBXwjwPoc9RDVZseXypVkC7AhSUH3bWkgXVU6tqxqNE86osqevs3fGG9Mp9W+3Ylmi3CiCDsbc0DaZ+JI75Nwbjs99xn7xHcH6aihGgmmAlmrt8h974Y+owKB3HeE4KSNXUOcpW58oq4N3xMaCDfUGs08nNE0b60cRzWDOdUoElPgkgFJLwIv5fFM0w5AO8bQC5XSryJLFMoqtc0NXt1/Ds/92Y5fHcvaPfvEjaJ+NRlH693UR2d2JdIwEoXbwusm49bk5hfaPhEmntq1Q3megBIIh+YnkkXAcuyjRCnWB/Yq8gzE+HT334N/qLDAIDyA6dYUSYKOmW2H8q6ftzMlGujp80qtR9LKN5F1AZMHlwPxt9Jn8MnvrG/sfkcrS8DE5U8ZXIgA/9r/H+vyJjdVdkjTRA5w7wj92xxZGLgMljyz3rYAkdp1DVj97tDerKOnc03vQ5pLe+wgdIdmnwzwP6xjc33dxYM4qRkvsi0yoM9SIlY29AIigZqpf94AjZmrGm36WZgJkY2gomveSMccUHDnS0xvAPDcQUqwRkJWLiJlswB1QmP0Aschk/sJocjeGQCTtjy5a/K39q5brYNSPnJ+jld2K1dMmJ/Kvl+xDkZpb0FMr3mpe5hY/phSrjlufaP64x/y26EgNJSkhs4T/G6uGqupTgvzOjT7JFdxNeijBh0R07ez/DPzUZGDvRei7N5XS2svJ0xc4D2wSkv/EH30R3ZeshsTnrqCQQqBvjS3C6GS++HAew8gwFFprxpQBUNFER+6xiUZfb1MuDl3JM+u
 IJpSCZiC
 3i9Ap5bIQdpfP+5Y9hUFzO77hJx6wAtyJkGJwLaAw5TtZDEgp9gthLIL+20gQscirNXqXQjojSPqIgnJurEYoygt7OoRFvg3NHDLEvjBzerQmrONObsfc2mTo9U2ZzdmtVuFG7QjeChlPFDc3JuKrT5QlRMyzuEHt+dE30FsaSIaedajG7NnTm/sXhagAjm+h1xzzz9iolVVv/YpILIBEyei7Ik4jCrlsRfQopg84Q8uodCazPxDca9hHBnR785SHNn/Gt46QGu11VkKRVlCN8/HvHJn2KWpUmAJP2n2E/hdeGht/wMGWzw6pGKjMZMRLBqF4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:12:01PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Aug 15, 2026 at 01:19:23PM +0800, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > After the page table lock has dropped, the folio can be freed
> > concurrently. The trace_mm_khugepaged_scan_pmd() is left with
> > a dangling folio pointer.
> >
> > So using the folio_pfn() before dropping the page table lock,
> > closing use-after-free window.
> >
> > Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/trace/events/huge_memory.h | 6 +++---
> >  mm/khugepaged.c                    | 4 +++-
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index d3572d4ef453..5dc71d292f47 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -55,10 +55,10 @@ SCAN_STATUS
> >
> >  TRACE_EVENT(mm_khugepaged_scan_pmd,
> >
> > -	TP_PROTO(struct mm_struct *mm, struct folio *folio,
> > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
> >  		 int referenced, int none_or_zero, int status, int unmapped),
> >
> > -	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
> > +	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
> >
> >  	TP_STRUCT__entry(
> >  		__field(struct mm_struct *, mm)
> > @@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
> >
> >  	TP_fast_assign(
> >  		__entry->mm = mm;
> > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > +		__entry->pfn = pfn;
> >  		__entry->referenced = referenced;
> >  		__entry->none_or_zero = none_or_zero;
> >  		__entry->status = status;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index e7830761d3a2..7c8c48577408 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1603,6 +1603,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  	enum scan_result result = SCAN_FAIL;
> >  	struct page *page = NULL;
> >  	struct folio *folio = NULL;
> > +	unsigned long pfn = -1;
> >  	unsigned long addr;
> >  	unsigned long enabled_orders;
> >  	spinlock_t *ptl;
> > @@ -1778,6 +1779,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  		result = SCAN_SUCCEED;
> >  	}
> >  out_unmap:
> > +	pfn = folio ? folio_pfn(folio) : -1;

You already defaulted the value to -1, better as:

	if (folio)
		pfn = folio_pfn(folio);

> >  	pte_unmap_unlock(pte, ptl);
> >  	if (result == SCAN_SUCCEED) {
> >  		/* collapse_huge_page expects the lock to be dropped before calling */
> > @@ -1788,7 +1790,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  		*lock_dropped = true;
> >  	}
> >  out:
> > -	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > +	trace_mm_khugepaged_scan_pmd(mm, pfn, referenced,
>
> Same comment as 1/3 I don't see why we should be storing a pfn value used
> nowhere else just for tracing.

Disregard, I didn't account for lifetime.

>
> >  				     none_or_zero, result, unmapped);
> >  	return result;
> >  }
> > --
> > 2.53.0
> >
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

