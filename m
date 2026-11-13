Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2F7606A883
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CA5BO0L8
Received: by kanga.kvack.org (Postfix)
	id 2FFCC6B05C0; Fri, 13 Nov 2026 16:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0846B05C1; Fri, 13 Nov 2026 16:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F816B05C2; Fri, 13 Nov 2026 16:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE9CF6B05C0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:18:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A3A8120295
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:18:09 +0000 (UTC)
X-FDA: 85431358698.14.5A294E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92F80120005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:18:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CA5BO0L8;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794604687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TI669XTmYP7FbcAC88TL2XD6yh6R2SK28TzCrSk5RdA=;
	b=d76i/QNd6cqoKQtNlgaZ72hkKYBWZwcpGqjR7KclIBDd/JnYJEvR+WSt2/cJs/dwjfEnPY
	epkEZWRPRFZ8JKPKe7P9+HD9rJrHF53lhes3N463Wdg7rqHMpC+NszsYC8islxqgy9zAsD
	8o15o/ydZyV4Uqcs7BiWt6V+PDT+2iU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794604687;
	b=HK0AI1O5aP6/KLq28breu2Nsb4a05M5+n0L4/0BxyiXRNipr6oReaM+BVxOWp5ODpP6zbT
	y8ReqlFCxhbf4NfdLXyUUfj+TQbdP2lETYSMm72OuQjWan1UqF5wMN8QWN9c25CxVptHvJ
	wyce241wrtqtAa2kk7bJUhF8TulAcXk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CA5BO0L8;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8B0141341;
	Fri, 13 Nov 2026 21:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0BE1F000C6;
	Fri, 13 Nov 2026 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794604686;
	bh=TI669XTmYP7FbcAC88TL2XD6yh6R2SK28TzCrSk5RdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CA5BO0L8AuZJgiguVAwnoShvwd2dDWCM4Smhq2jprJ2ZQf5ZGyzU1ewh/5Tjb3q20
	 k7IOtFLsKXE8IlRHoj4LB4HODq8+Efee2OEhZqxBuwMRE+WiCzgQLybkuj40BM9lGN
	 s3VzfvS2uSEeJtJBTYzVyo1aO62ZeMQcdDPTLif83E70x/itvgTwF1+1xb2zRrQ3yp
	 lFgi7F7pfcEQ2nmkmQGI3D/H1hyiBstL2qqGOHA0x81fDfKHIZoP+9m992+RV3fNNW
	 lmuaN0sBGsx6+IhqPPixS9D+q32mVi6H7fuQNvRe1t4ECiLW0saKF17LcPvwIcUAkF
	 N0RCQRFabjEHw==
Date: Fri, 13 Nov 2026 21:18:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
Message-ID: <avd8-uVPf6BSqwEQ@gremlin>
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
 <f8b0f20d-90dd-496d-97e9-9a232124e3e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8b0f20d-90dd-496d-97e9-9a232124e3e0@kernel.org>
X-Stat-Signature: f6qfe76q4eem315iidzrcoy1o3gpnpeu
X-Rspamd-Queue-Id: 92F80120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794604687-113356
X-HE-Meta: U2FsdGVkX1+2M+t24QXh43xCpFx5lZycSqxUbqlAOJRzY+/D5THoreH8AyuZuKxyelo22com+vDCa1+yKyZn1esmR1HcNeES1VMUckPyDJSGpO9R3U7C7DPjlzHEUirc/smcIsysidy7crEMKG6Bg7vvLqq22bGOOnEmhnOqU2W3RF6EYODKRADjV5Pr5hNWezvljhHXbP9I17u15/crVZkFZA1QpWIE7o2XSGnY2VJcMadrZDNVAfIyMMopCMUGhkRAGTPDOAvKiFcZztzsqPW45SVk1blblxxu+N9gAgjPa7aCL1Y+p7uMWuiReXY3LL6DVzYcrNJCydOgWRFJffs3150D2rwUhBniABm/ktTi1jXeZxkml792NrGh6T60Vyy+wp0NgrF5Vnntq70RoI/6cK9KDjPEud2rSSJrkEAR0cNJtVgrAsoh15HSyJyJiI4uSq1umaL5/SAtvFeGtNIULikouSkUpm+RTbcgd5n/El2eMiVyxKMpFtsxMXKRV/i4LIkjIEZDpfPwWKnsnqvkuPVPep//P2BduYPuF8oP9DY0YJQtWIHJWTZ4PEz//ozN6HPr1VDRkfhcTEEDPLXzMYPgCo6GykoxDnWjICSnjMiV7lTCn2ZDWv5oJzp/N/JdNCscPWp4ZI6YMso1RaxHHj/hAXjQwDNltBPIK7oRIulFmURvTYp6EATP99g0SeBqetFNNGlF7C4TxFWA3g+XXdEtLrvqEmhI8KNZn4NMYfKixa5eybQfrsMp6vM7ouwOdngP5tXbczAqavptsyYz7XBCzaEsE8psXGSugDAPjVfc3wd9Lbkq1gv0k9oCUxotHV0QrlpqqTOlfWFaYqWfI2lrEAAudISDbK8pwImlGpsRnfv1k2yeNId+VePlPCXgbwmd6PH9Wxj1fsA4uZEcuHp7i6d7D0oIc0y0XETMqjIcmQ7n4U3gnBFhPQ+4+SdH4xZpxkBGJuSjHEN
 fdrtNlCc
 zLG8KTMoJHJOVErfUATVNwFpNzWe0YwPRrLmem6v+JyCZ5GMEw3cH3a9TRFSel/KgBRXnLRl96+SQ45fMst1fh3fLvTH6l6drkLAhZopdKWAKDDZEqzlvqSWdnQN/+0Qo8+9Z6k3M6Xg7/sKdJVlkqjbNcB6jcQqGZUKR0wjTXh4QUCbswnn5peA8s6zToHov8BSkYRYffdJTwLcjfE9OIAxQG/HDJz9/tpsMkqM6knit7Ca2lN7pMRDEJS0Z8qgQuyj/4Oz01hXaadmRl1EhD/0KVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 10:10:49PM +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 22:04, Lorenzo Stoakes (ARM) wrote:
> > In order to establish guard regions, guard markers are installed in the
> > page tables of a mapped VMA.
> >
> > However, problems arise when one tries to combine this with registering a
> > VMA for userfaultfd, as such operations may themselves need to install page
> > table markers such as uffd-wp.
> >
> > When the installation is attempted the guard marker prevents these markers
> > being applied, which can lead to unexpected results (especially if the
> > guard regions are later removed.)
> >
> > This is especially problematic because guard region installation causes the
> > regions to be zapped first, meaning that the removal of userfaultfd-tracked
> > ranges will not be logged in this case.
> >
> > Additionally, the uffd-wp page table marker will be propagated regardless
> > for file-backed mappings as the zap being performed does not clear these
> > markers.
> >
> > This is problematic, as it can cause repeated failure to install guard
> > markers resulting in an infinite loop.
> >
> > Therefore, update guard region installation to invoke the zap with the
> > ZAP_FLAG_DROP_MARKER flag applied.
> >
> > Both before and after this change, uffd remove events will not trigger on
> > guard region installation, nor will write protect state be propagated after
> > guard region removal.
> >
> > This makes sense as conceptually, guard regions mark a part of a VMA as
> > effectively unmapped at the page table level, and removing the markers is
> > like mapping the VMA again, over which operation uffd markers would in any
> > case be lost.
> >
> > A survey of open source users indicates nobody is relying on installing
> > guard regions in uffd-armed VMAs. Software including glibc, android,
> > tcmalloc and CRIU were checked.
> >
> > This change means that any already established guard regions are removed on
> > zap. These will be overwritten with the newly installed guard markers on
> > success.
> >
> > However, if this fails for some reason (fatal signal likely the only
> > reasonable cause), guard regions may remain removed, and concurrent faults
> > may succeed in the interim in the range.
> >
> > Since the installation failing guarantees nothing about the range being
> > installed into, and since success overwrites with guard markers, this isn't
> > an issue.
> >
> > Since MADV_DONTNEED does something similar, abstract the zapping to
> > zap_range() and call it from both places.
> >
> > Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> > Reported-by: Tal Zussman <tz2294@columbia.edu>
> > Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
> > Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
> > Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > v2:
> > * Updated to just zap everything as per David + Tal.
> >
> > v1:
> > https://lore.kernel.org/r/20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org
> > ---
> >  mm/madvise.c | 28 +++++++++++++++++++---------
> >  1 file changed, 19 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 0214efd2a014..4f7728583207 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
> >  	return 0;
> >  }
> >
> > +static void zap_range(struct madvise_behavior *madv_behavior,
> > +		      zap_flags_t flags)
>
> Two ... ;) But maybe it's consistent like that in the file, didn't check.

I'm a bit exhausted, can you or Andrew just fix up whitespace like this on
application?

It'll be easier when I have the VMA tree.

>
> > +{
> > +	const struct madvise_behavior_range *range = &madv_behavior->range;
> > +	struct zap_details details = {
> > +		.reclaim_pt = true,
> > +		.zap_flags = flags,
> > +	};
> > +
> > +	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> > +			      range->start, range->end - range->start, &details);
> > +}
> > +
> >  /*
> >   * Application no longer needs these pages.  If the pages are dirty,
> >   * it's OK to just throw them away.  The app will be more careful about
> > @@ -872,13 +885,7 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
> >  static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
> >
> >  {
> > -	struct madvise_behavior_range *range = &madv_behavior->range;
> > -	struct zap_details details = {
> > -		.reclaim_pt = true,
> > -	};
> > -
> > -	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> > -			      range->start, range->end - range->start, &details);
> > +	zap_range(madv_behavior, 0);
> >  	return 0;
> >  }
> >
> > @@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
> >
> >  		/*
> >  		 * OK some of the range have non-guard pages mapped, zap
> > -		 * them. This leaves existing guard pages in place.
> > +		 * them. This also drops any PTE markers in the range,
> > +		 * including existing guard markers, which we reinstall on
> > +		 * the next attempt.
> >  		 */
> > -		zap_vma_range(vma, range->start, range->end - range->start);
> > +		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
> >  	}
> >
> >  	/*
> > @@ -1845,6 +1854,7 @@ static bool madvise_batch_tlb_flush(int behavior)
> >  	case MADV_DONTNEED:
> >  	case MADV_DONTNEED_LOCKED:
> >  	case MADV_FREE:
> > +	case MADV_GUARD_INSTALL:
>
> Huh why that change? Not spelled out above.

It's just the established way madvise interacts with TLB maintenance.

Anything that uses madv_behaviour->tlb has to return true here so
madvise_init_tlb() and madvise_finish_tlb() do the right thing.

(I didn't really want to spell out something that's just a code convention
in the commit message, esp. when I get feedback about the messages being
too long...)

>
> Apart from that LGTM.
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

