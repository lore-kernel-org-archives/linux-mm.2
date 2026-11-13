Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0BA606A891
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NX6l4vlx
Received: by kanga.kvack.org (Postfix)
	id CF24E6B05C1; Fri, 13 Nov 2026 14:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2996B05C5; Fri, 13 Nov 2026 14:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAC06B05C7; Fri, 13 Nov 2026 14:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC226B05C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:22:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E39D8C011F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:22:14 +0000 (UTC)
X-FDA: 85431066588.06.171F93C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 380961C0009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:22:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX6l4vlx;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fdl4VOJT6zViP7jtfnU1Xg3aoOGQL41O0hxbPwDlR+A=;
	b=YSiaRcZ8djct/llyoQQH53FU5kOT5L5L+1XH/vlQFHBrDCxpQ91epulXVnMk8/TaUuDxAK
	6cE9pXiYcNlai7IFRa9HFETwa2+KW8LNSCT8/Y+04wd5NJrC85Y7IFBgtqu9RaYbwoXBFU
	+o6U9p7gBd8JvUwVwNNewqQySOXFF1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597733;
	b=wOvQRXVjnYvRqfSNbjgcTHvcy5WbYYotWmqjpaVnibxtuHl4fiNBIGO6m82hZipJNzQRFu
	3DeJs6AfFd1HDgOHWL3yTvdTSUPob+7An8xSia1bO5iTupIRE086Yf+MVNRBuS8gwSR34q
	meZ5pxNTfrK3yRXtQcgwDswZpBdBoU8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX6l4vlx;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EDE846062;
	Fri, 13 Nov 2026 19:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10861F000C8;
	Fri, 13 Nov 2026 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597732;
	bh=Fdl4VOJT6zViP7jtfnU1Xg3aoOGQL41O0hxbPwDlR+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NX6l4vlxAsFOjaj+ZundCIjebkwjdIPIUBB6r6xto4qN1LhAmxdOJZlzrDEKEFlHX
	 HE+RzVuSSPFuI5p/wzPEd1EWoL48luhiQrH5Fuylbug07Ef3zaiXlkH2raN+byKwcx
	 ETtjAefB4pa1W94nXtaIlrAAzMDf7b2jtwqGkoqUv3j2kS3nzrIYUPM0FCJ6ZQ/TUH
	 Pg9l/Ahp2pnUhstVIekqNTSYv5F0iZAVv+3d7lVWPZopB2q+jIlDKPVOg625y+x55w
	 2HbExloMEtf2bl5fPgILQoRc23yrhUKrH3yaVEEApNzX0fSs170YpwQdkw5kr35VOZ
	 TavaBPQLZKR1g==
Date: Fri, 13 Nov 2026 19:22:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
Message-ID: <avdjMNNkOXm2khTW@gremlin>
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
 <0e3e876e-c3df-4660-ad89-a5f0fd7dedc8@kernel.org>
 <avcNcL6svEOTg_3r@gremlin>
 <0d6e29f8-54fc-427a-a979-1a8c6f4e3f06@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d6e29f8-54fc-427a-a979-1a8c6f4e3f06@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qzmjxd9pc9xn1e9ps61b8shafepho7dx
X-Rspamd-Queue-Id: 380961C0009
X-Rspam-User: 
X-HE-Tag: 1794597733-686174
X-HE-Meta: U2FsdGVkX18MWDmmr137jp8JqGWi/hflf9uh7InBa4E7qPI0RB3VGIjrZdqacM4eUeis6YXKjMpsvNwNJHmAhdFFvwWykMVaswgLznlAZdTDXH+XsdU4vteaoddNadlUGBwcitDiDnR/IzqHmYRp+FqEK1dek7ahI6nAa5NMjhEPw1Gww8cDtikG6dHx8uOhPoZD4PD3uYEAztVQiQfEfqiVuu7jRoKNWJhOWQzRCGtGyWWkT8M7+fRRtg9X8l+MeL0NnQbH5rrcYkbleHMSgBsuoV2eZKg0hI7sh+4NObKZOd5gJZXMM4eZRopgbF1wqj67f8JbGzS8pgPVtJyx5cFYsomIjYNLBRB8+F2HnZzSCX94Cy66NckKS1lzHlAB4WCyZ2sSYi+YlgGtvjuqk6BZtDzkG+UfMuTnclk+mwwAmphim/iy4JKI/xp2XqdsDA5nsQdoz3ajJ0SrBNx4lxSD15sd7ZR0QG8sno9L/G/tS3Q+QAmU9m8vowbaEzXhnyyzyMDzNgScmaCCxb0Slcw6i9Bm4nfjJfLfBZgzECXs1vVILjw3lFLh7I+13GVSG0cLN7Vb39LCaOKtPWIM4YOVTzRZAbTmAnmzBCQMvuC/ulV2tclD+dpnjapcTu9pfTFdoFN3nZ+i6Th+XoooKhv/cQr4wz1O9mUZr4wAbPFo14AdgR7doKXUpd46yyaMBekWiwag5BZR0STpjzx+zqqIDAH2qpoRiZ3nRDLa4SS7HQnV1z+tBIZH8A7QuIIm2IDQE/oTc8ogKSVFR4CR6gCW3nHm3mZ69kY8qrsvVxodOBOdPaMNBBz3vTRz6eyS1ZWLYCSoVBZUUyRTrinmYEZWx1gt/0xNib5vw2ynghSyr187hDATL9M27irqgM6q5uozJHpmitZYrzFJAIA5kWIs5BjRM6Lm92GWqTKyDlc9G2zJpMsLdy07TOTwZS3acU71UwHrTHgNep3gZ4G
 5HBJnAPr
 YFawk0GeVQvezBUIeUpqh45iHW/Yl9yJ0A1DiS6QE3eY39AnFwzvAafObncKm+S1DYUGlDDmKBWk+EfZGjSOB/8WqNg7YPV8uDQF0mYM0Mv9jcH9TOsg/rmli01Qg3wCrxJB+V4gDUvVB9CIu/13ojwcznQdRErcb7iRPmatLGt5iTKl3/GWK4LIH5tZt23Oh/bL/YnhhbiG+8iYrNVqaGEgaNrMO0H620IH/Xgoy8MrX7t1ocgeXteRK/c/HIUK0PlKy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 08:15:34PM +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 14:59, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Nov 13, 2026 at 12:59:00AM +0100, David Hildenbrand (Arm) wrote:
> >> On 11/12/26 18:38, Lorenzo Stoakes (ARM) wrote:
> >>> In order to establish guard regions, guard markers are installed in the
> >>> page tables of a mapped VMA.
> >>>
> >>> However, problems arise when one tries to combine this with registering a
> >>> VMA for userfaultfd, as such operations may themselves need to install page
> >>> table markers such as uffd-wp.
> >>
> >> How does this interact with UFFDIO_POISON markers that can outlive even
> >> userfaultfd registration?
> >
> > The zap clears poison markers, as is standard. It's really horrible this logic.
> >
> > So the code path for zap used by the guard install (via zap_vma_range()) is:
> >
> > zap_vma_range()
> >   -> zap_vma_range_batched() with NULL zap_details
> >     -> __zap_vma_range()
> >       -> zap_p4d_range()
> >         ...
> >         -> zap_pte_range()
> >           -> do_zap_pte_range()
> >             -> zap_nonpresent_ptes()
> >
> > And zap_details is NULL.
> > > In zap_non_present_ptes():
> >
> > 	...
> > 	} else if (softleaf_is_uffd_wp_marker(entry)) {
> > 		if (... !zap_drop_markers(details))
> > 			return 1;
> > 	} else if (softleaf_is_guard_marker(entry)) {
> > 		...
> > 		if (!zap_drop_markers(details))
> > 			return 1;
> > 	} else if (softleaf_is_hwpoison(entry) ||
> > 		   softleaf_is_poison_marker(entry)) {
> > 		if (!should_zap_cows(details))
> > 			return 1;
> > 	} ...
> >
> > And zap_drop_markers() checks zap_details && zap_details->flags &
> > ZAP_FLAG_DROP_MARKER.
>
> Right, my intuition tells me to just nuke that thing by setting
> ZAP_FLAG_DROP_MARKER.
>
> MADV_GUARD, is just like munmap() another form of "zap it all and protect it".
> >>> This is especially problematic because guard region installation causes the
> >>> regions to be zapped first, meaning that the removal of userfaultfd-tracked
> >>> ranges will not be logged in this case.
> >>
> >> Again, similar to trying to uffd-wp-protect'ing a hwpoison marker (which will be
> >> ignored), and then zapping that.
> >>
> >> Isn't guard marker installation/removal just another form of zapping?
> >
> > I mean users being weird could decide to use it for that rather than
> > MADV_DONTNEED, but zapping is a side effect really.
> >
> > Really the idea is that you might have users who, for whatever reason,
> > faulted in some range, and now want to make that a guard range, so for
> > convenience we zap it for them :)
>
> I think not just convenience. There was this problem with faultaround / THP
> placement IIRC ...
>
> I'd just zap everything that's there. That's literally what the user asked for.
>
> >
> >>
> >> So to me this all sounds like "if user space does something stupid, it's user
> >> space's fault".
> >
> > Unfortunately, as per Tal's series, there's more to it than that (linked in
> > Closes: tags).
> >
> > You can get an infinite syscall restart (ugh) if you do this on a shmem
> > range (Tal's 9/12) so it's a kernel bug that _has_ to be fixed.
> >
> > The other bits are just about a user losing track of uffd stuff if they
> > guard/unguard, as you say.
> >
> > But every other zap code path does the uffd remove event stuff, so this is
> > still an exception.
> >
> > If you support uffd, you have to add a whole bunch of horrifying, awful,
> > terrible open-coded uffd crap, e.g. the userfaultfd_remove() etc. And you
> > have to drop the bloody lock and reacquire it too and make sure all that
> > works correctly (...!)
> >
> > Anyway there's basically 3 options here:
> >
> > 1. do something like what Tal's series does - add a TON of complexity for a
> >    use case that nobody uses to get behaviour on something nobody sane
> >    should care about (i.e. uffd/guard/unguard/expect uffd correctness).
> >
> > 2. Zap with ZAP_FLAG_DROP_MARKER, and silently lose uffd-wp state but
> >   'support' uffd. It does fix the 9/12 bug but then subtly breaks uffd.
>
> Right, that's what I would do.
>
> MADV_GUARD_INSTALL zaps everything.
>
> It already zaps swap entries, migration entries, hwpoison entries ... so just
> zap everything.
>
> [...]
>
> >
> > If you're really concerned though, we could go with option 2, which will
> > just make UFFD behave differently for guard regions.
> >
>
> Not really concerned, it's just the most consistent one for me. Zap everything.
> The user asks for it, like he would ask with munmap().
>
> > (I regret, obviously, ever allowing this for uffd ranges. And we _all_
> >  regret that uffd was _ever_ allowed to be merged in this state...)
> Yeah ...

Ack will send a v2 doing that then :)

Heads up that (naturally) the subject line will differ!

--
Cheers, Lorenzo

