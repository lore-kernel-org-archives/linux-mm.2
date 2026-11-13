Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881DB606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bR7oYPNx
Received: by kanga.kvack.org (Postfix)
	id 70EB06B05BB; Fri, 13 Nov 2026 16:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E55F6B05BC; Fri, 13 Nov 2026 16:09:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC176B05BD; Fri, 13 Nov 2026 16:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411636B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:09:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C82AB1C2A0F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:09:52 +0000 (UTC)
X-FDA: 85431337824.22.CE9045E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2A49F100008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:09:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bR7oYPNx;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794604191;
	b=wEt/UN8pnxrtS11GFBl4f4tBytKJMx4Da1hf4XijNqY2oiqHSK4CNSsQFMaSLtswpz9yqQ
	4mFTog/VZPEQq1nMd5Cnni3hkJDy9/QRo5/3bRFQAPrX1UpNHYYaZkrjUOWEXUI1P1yQAz
	m925wO8zRVrPEsDa28lv8ilQwR/bobM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bR7oYPNx;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794604191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wtd2KDMKHjgdTYZDJFa9BcqH5dMoFb2/KH89jf9oLn0=;
	b=qok3+suQha0/FlI1cdtGuRBfBmpGDm52gV6UidQSy6qM5zY47crcWPKcLDEX1PmZlH9dBT
	Gm+4okTQA55BuE/jCL3NyoCbnlstMl8AsRDfLVnk8J8X3FEDxTRQpHjZBdvpNAp+WP+DZW
	vgqHS9bJGT2GcibJBmXtHp0cOdtMNQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA91C634D5;
	Fri, 13 Nov 2026 21:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2591B1F000C4;
	Fri, 13 Nov 2026 21:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794604190;
	bh=Wtd2KDMKHjgdTYZDJFa9BcqH5dMoFb2/KH89jf9oLn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bR7oYPNxZlKgNdYEqiHrDBRrMaL2b5ONCmZ8lutbhmVhxtVH6WRk6YYJf42ZC2F7k
	 WgZP5cHcDlKZ1Lfh6e3d946/KzOAXUgEUimc4GmgeO964LUTL48WkUwTYvTDilFhlZ
	 InlQLb0ybNidY57Kk8+TjP/5L8I5ZSSb755JzsRL+9y0XhABWI5FsU2zQTE7bymW0x
	 5oy6xCBnqrV+m4hM7mpNS+2SAnZFo8sdVxbiiO/pI7f+6EXPGHG1zYhF9ckvZuZRtf
	 5q+WOwORKzCiqMk/+15c8Q0VXJ4SjcUCq1b7uGTybOYprX3I/upShUcBc0CiegBCq6
	 rywkHZwxP/kmA==
Date: Fri, 13 Nov 2026 21:09:44 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
Message-ID: <avd6XEHndh30hyc-@gremlin>
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
 <0e3e876e-c3df-4660-ad89-a5f0fd7dedc8@kernel.org>
 <avcNcL6svEOTg_3r@gremlin>
 <0d6e29f8-54fc-427a-a979-1a8c6f4e3f06@kernel.org>
 <avdjMNNkOXm2khTW@gremlin>
 <f53458fd-c268-4dfe-aa99-b050f63af728@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f53458fd-c268-4dfe-aa99-b050f63af728@columbia.edu>
X-Stat-Signature: 63sfmfdyght1d1mqgzcy1x8gd3i3578j
X-Rspamd-Queue-Id: 2A49F100008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794604191-437828
X-HE-Meta: U2FsdGVkX19GynOhJSRonGScCALwkFv/aAi12XmSZGCOrGrCub8PEk3AGkXhFHwjfk84lsTQl8Sqe/qkiBiovSVraQuRTAxJn2iXaj8dzgWqJiaWHG6szVmVv+glJmrN9an1H1ZmoXIiLyEwLcQT3mKOgpw8Dw4QzXfgGlcpgIVTn/DRv9pMSbOckYO6O/+TUhURZk7ZFJ74MpDV1EWyPGq0dWLOLgET0X4NrBvYJb5O3I/c0XeL+e/aGysEt8otQ6WGfVFa87A0/WbpxosYpLo8d14yHL5/GT7ykB8LkxGtRJsXXDi/NJPPKhSLtbGhix9z+C6NxHj7F6TooWRHUFZrBnMwsQc1LJPQ/NPX6iH0U60Znf7MlWoPqhrdUFSZrqNi7K3JRCKpKTpeW0ltX1Dqq4VlHE2TlVm01jiHAT488Ni/2O+NTDumuMltre2JYrgS5Vp6PGFwEex5gkmjTsaKrVXiYY6O4kKGiwZ8eWRMhdMBlIWvsnhyN4Uz3RLhDdUpOYNxxtsn+D5Z1wbK7ANW8AryjjjeirZggRk8VfnmUXcguKzIBbXluHTpuWcPZYy1EHAIaaLXht6cDZpo7P3TXdylyPVWohlXhvda5WjwckqrQ5p+1rd8zTUVi85db14KNSgvIn1H0eyvG1QPwl9BD5x3cgEKStoM2R7hT4lXH/8tQKcgJlmP9Dna6h/x7WvK6IsOqSOpk1sm7xTpSDf4RBFxJVUV5jMmJmcR+oqMKvYj7l96gQVIZx9eGkLiK02zGQ5/abB7PR8gFENEiP7gggNDECW90dgoZVwApB9vPDJKvFhaMFQTM64vRRg2z1qbdVQWPuFhjQffMPuxb2AfWeZw/CKUh9Kcz7jQHDf7F7ZPNmnUseU9FJ9lOn8ripLDjAOiiWvPdefkf0ygDcq0ES5pvmKBgz+aJj8Q+N++MOaiUhjFehAWTvNhM+zfrtNhvEDB+yMiJ9EEZ7E
 IE8SCeIm
 mep+GO8F/P3Q0G6M3oY7jx1dEsXckqUdrY6PeggCJ4tjNMtvyqETRNstxbSQk52WaZjUStz/TDjHRQQBq8wSMuZytj2Lev68Ea12E1xSfsv23h5B50vv7/92mAu25QRRDRfLw52vivdtZcEJwRlJSLWKqHfVFE05eXZn9cRjdkLgzg2OPCn33dM/zx6ifQhsnUVX0QZdiyEkS0lokHef+QLmDUoyjHZXTLxAhVJQPCkM2E2Ip/wQc4AzKYtmghrTqwxzcS+VD9X4p6bhsHTATv/meXrnO3QFw/eyunpRaKE03Umb9UVFKTSYGTYvaSRcg2h1K/aB0VaGAqpTHzvq2wWcf3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 03:55:41PM -0500, Tal Zussman wrote:
> On 11/13/26 2:22 PM, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Nov 13, 2026 at 08:15:34PM +0100, David Hildenbrand (Arm) wrote:
> >> On 11/13/26 14:59, Lorenzo Stoakes (ARM) wrote:
> >> > On Fri, Nov 13, 2026 at 12:59:00AM +0100, David Hildenbrand (Arm) wrote:
> >> >> On 11/12/26 18:38, Lorenzo Stoakes (ARM) wrote:
> >> >>> In order to establish guard regions, guard markers are installed in the
> >> >>> page tables of a mapped VMA.
> >> >>>
> >> >>> However, problems arise when one tries to combine this with registering a
> >> >>> VMA for userfaultfd, as such operations may themselves need to install page
> >> >>> table markers such as uffd-wp.
> >> >>
> >> >> How does this interact with UFFDIO_POISON markers that can outlive even
> >> >> userfaultfd registration?
> >> >
> >> > The zap clears poison markers, as is standard. It's really horrible this logic.
> >> >
> >> > So the code path for zap used by the guard install (via zap_vma_range()) is:
> >> >
> >> > zap_vma_range()
> >> >   -> zap_vma_range_batched() with NULL zap_details
> >> >     -> __zap_vma_range()
> >> >       -> zap_p4d_range()
> >> >         ...
> >> >         -> zap_pte_range()
> >> >           -> do_zap_pte_range()
> >> >             -> zap_nonpresent_ptes()
> >> >
> >> > And zap_details is NULL.
> >> > > In zap_non_present_ptes():
> >> >
> >> > 	...
> >> > 	} else if (softleaf_is_uffd_wp_marker(entry)) {
> >> > 		if (... !zap_drop_markers(details))
> >> > 			return 1;
> >> > 	} else if (softleaf_is_guard_marker(entry)) {
> >> > 		...
> >> > 		if (!zap_drop_markers(details))
> >> > 			return 1;
> >> > 	} else if (softleaf_is_hwpoison(entry) ||
> >> > 		   softleaf_is_poison_marker(entry)) {
> >> > 		if (!should_zap_cows(details))
> >> > 			return 1;
> >> > 	} ...
> >> >
> >> > And zap_drop_markers() checks zap_details && zap_details->flags &
> >> > ZAP_FLAG_DROP_MARKER.
> >>
> >> Right, my intuition tells me to just nuke that thing by setting
> >> ZAP_FLAG_DROP_MARKER.
> >>
> >> MADV_GUARD, is just like munmap() another form of "zap it all and protect it".
> >> >>> This is especially problematic because guard region installation causes the
> >> >>> regions to be zapped first, meaning that the removal of userfaultfd-tracked
> >> >>> ranges will not be logged in this case.
> >> >>
> >> >> Again, similar to trying to uffd-wp-protect'ing a hwpoison marker (which will be
> >> >> ignored), and then zapping that.
> >> >>
> >> >> Isn't guard marker installation/removal just another form of zapping?
> >> >
> >> > I mean users being weird could decide to use it for that rather than
> >> > MADV_DONTNEED, but zapping is a side effect really.
> >> >
> >> > Really the idea is that you might have users who, for whatever reason,
> >> > faulted in some range, and now want to make that a guard range, so for
> >> > convenience we zap it for them :)
> >>
> >> I think not just convenience. There was this problem with faultaround / THP
> >> placement IIRC ...
> >>
> >> I'd just zap everything that's there. That's literally what the user asked for.
> >>
> >> >
> >> >>
> >> >> So to me this all sounds like "if user space does something stupid, it's user
> >> >> space's fault".
> >> >
> >> > Unfortunately, as per Tal's series, there's more to it than that (linked in
> >> > Closes: tags).
> >> >
> >> > You can get an infinite syscall restart (ugh) if you do this on a shmem
> >> > range (Tal's 9/12) so it's a kernel bug that _has_ to be fixed.
> >> >
> >> > The other bits are just about a user losing track of uffd stuff if they
> >> > guard/unguard, as you say.
> >> >
> >> > But every other zap code path does the uffd remove event stuff, so this is
> >> > still an exception.
> >> >
> >> > If you support uffd, you have to add a whole bunch of horrifying, awful,
> >> > terrible open-coded uffd crap, e.g. the userfaultfd_remove() etc. And you
> >> > have to drop the bloody lock and reacquire it too and make sure all that
> >> > works correctly (...!)
> >> >
> >> > Anyway there's basically 3 options here:
> >> >
> >> > 1. do something like what Tal's series does - add a TON of complexity for a
> >> >    use case that nobody uses to get behaviour on something nobody sane
> >> >    should care about (i.e. uffd/guard/unguard/expect uffd correctness).
> >> >
> >> > 2. Zap with ZAP_FLAG_DROP_MARKER, and silently lose uffd-wp state but
> >> >   'support' uffd. It does fix the 9/12 bug but then subtly breaks uffd.
> >>
> >> Right, that's what I would do.
> >>
> >> MADV_GUARD_INSTALL zaps everything.
> >>
> >> It already zaps swap entries, migration entries, hwpoison entries ... so just
> >> zap everything.
> >>
> >> [...]
> >>
> >> >
> >> > If you're really concerned though, we could go with option 2, which will
> >> > just make UFFD behave differently for guard regions.
> >> >
> >>
> >> Not really concerned, it's just the most consistent one for me. Zap everything.
> >> The user asks for it, like he would ask with munmap().
> >>
> >> > (I regret, obviously, ever allowing this for uffd ranges. And we _all_
> >> >  regret that uffd was _ever_ allowed to be merged in this state...)
> >> Yeah ...
> >
> > Ack will send a v2 doing that then :)
> >
> This sounds better to me. My concern in [1] with completely disabling this
> was that it could break a uffd manager that doesn't control the task it
> manages (e.g. CRIU lazy restore registering the memory of a task whose libc
> uses guard regions), but this should avoid that.

But they were completely broken already? So we're 'breaking' an already broken
user? :)

It's moot, but still!

>
> This still leaves guard installation as the one zap path that doesn't send
> a UFFD_EVENT_REMOVE notification, but for CRIU I think that's fine, since
> guards would mostly go on memory that didn't have contents beforehand, so
> there's no stale contents to restore.

For one, CRIU is userland software that relies on kernel implementation details,
so we are not obliged to keep _kernel_ implementation details stable for them :)

For another, relying on uffd state remaining consistent across the
install/remove of the literal 'put a hole in my address space' feature is deeply
dubious.

>
> I could imagine this mattering for something like a userspace far-memory
> library [2] that registers a heap with uffd MISSING mode. If the allocator
> guards a page that the library has paged out, the library is never told
> to drop its copy, and fills the page with the old contents once the guard
> is removed.

Previously: broken
Now: Not permitted.

I think that's fine ;)

>
> I don't think anything does this today, so it's not worth adding the event,
> but I think this limitation should definitely be documented (i.e., that
> MADV_GUARD_INSTALL discards the range and uffd state without notifying uffd)
> for the sake of the poor souls that work with uffd and to prevent any
> spurious LLM reports in the future...

Documenting things doesn't prevent spurious LLM reports,
unfortunately. Nothing stops the schloppers... ignoring is the only answer,
long-term anyway.

But sure, I'll try to update the manpage for the few humans still reading
these things...

>
> [1] https://lore.kernel.org/linux-mm/f76cb2b0-0090-4554-9169-5cfff6a6ca53@columbia.edu/
> [2] https://www.usenix.org/system/files/nsdi25-yelam.pdf

--
Cheers, Lorenzo

