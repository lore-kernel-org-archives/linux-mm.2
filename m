Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34F5CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C5E6B0005; Thu,  4 Jun 2026 10:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133886B0088; Thu,  4 Jun 2026 10:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049596B008A; Thu,  4 Jun 2026 10:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9F726B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:57:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EAA789053
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:57:33 +0000 (UTC)
X-FDA: 84842533986.01.2D983F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 297352000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:57:24 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780585044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bix+GKowZd/Tu2/8AOiC5/xieOCPGmZRVo7G52Me3BQ=;
	b=D27f5PyRlB+Hw7sxRdlynCZKqGrEGDOR8ZUSJBT1zmUqiQsGzAfQq863ir589jwKIBpxyq
	+rX4UO3Jjat60o/9u91Cwk7QZBMxL5PkPSXeqe8eKQEBdp1qlFYIY6+WJX185Ja36Q49ka
	cV65xqf2k8UVp0WCjBhqso8S3dVKUcQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780585044;
	b=FdCQUVPyQMQSzC/yrJsUhv9roRFZNE/gmuzpmwEByG+mwMdp7ejFY9bs3BQffpeEUK6bgw
	9kkjzMLkqaQHFeG+pBefL4+tYzhsJiiHLmmuW4jPMYi8I0srFUeUFCSCXQxB2612CiUX1C
	kZiA5nITIOVwxjjySEYrMTazVVBrnvM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVtSEQgz;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B1B843751;
	Thu,  4 Jun 2026 14:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D951F00893;
	Thu,  4 Jun 2026 14:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780585043;
	bh=Bix+GKowZd/Tu2/8AOiC5/xieOCPGmZRVo7G52Me3BQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PVtSEQgz7nlEqg/mbJQSHn2Z4W2hlXLOOVzXFtr0xkZuNVyOitrIznvfPJuNh0V2f
	 G5agYFu8foKSxFtN3HaA7DvzuzpyxDocFMdOTb4Fpqi07h4GtdhHF1tOZ/SMxJTLTo
	 pSCmzn7IYBZzgA+h+z1aN6DvfEWxlKShFPv3JGJB95xSiKW9YtDod4le3tqPIGCIrW
	 gBqA3oOQyXm7M8Y2WI+0ErODeycyohEaDB7pvPhwu+sVd1PDraI8s8T9VM9oB+xceD
	 a23f8QWV2baOHxHzHyQ3Imcj9FbL2r+aHocWvydvlSvAZvAx/mxHia2v6VeHqIGJs2
	 enqpASk3WHs4w==
Date: Thu, 4 Jun 2026 17:57:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, akpm@linux-foundation.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com,
	ioworker0@gmail.com
Subject: Re: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings
 in direct map
Message-ID: <aiGSSqYNwDeqbZmq@kernel.org>
References: <db45414a-8777-40d1-91b8-a78789ed18bd@kernel.org>
 <20260604031133.56010-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604031133.56010-1-lance.yang@linux.dev>
X-HE-Tag: 1780585044-342844
X-HE-Meta: U2FsdGVkX19dJjvkYJudPE9xA07inUh9+/JmfxKuRht1BMB0cgYAs2IPV6fQypqXhX0YSANG45uj6Git94G+9Bjvz4boFTFwoM9XmWD9XViasW+uK0ZMWxYRI5fg7WDyQuTCuli+h+uAE3jXxlxHayZb2mx3Z8tduN7FRYPeykya20uIrkpTE6EO3eA7jfXZ2BfknPA779at+N2anAtQs32NRfhkwHjlsn/VjtcC8xzVfWthpnRqu9ri4ybiCDYlaL3trf8yqqLW89p4Sba314IcrbSd3CSXve6oqHQkXi+3bAMt6DIQkWmKtrfKmQeET6IuhY5yP8zdoTmlVm+Va51iqR+IYRK7/6C/iRspUE10PWTRH2i5SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 11:11:33AM +0800, Lance Yang wrote:
> On Wed, Jun 03, 2026 at 05:48:56PM +0200, David Hildenbrand (Arm) wrote:
> >On 6/3/26 15:09, Lance Yang wrote:
> >> 
> >> 
> >> On 2026/6/3 20:35, Mike Rapoport wrote:
> >>> On Wed, Jun 03, 2026 at 07:41:34PM +0800, Lance Yang wrote:
> >>>>
> >>>> Good point, I kept it separate on purpose :)
> >>>>
> >>>> Putting collapse into set_direct_map_default_noflush() would change the
> >>>> semantics of that helper a bit, IMHO.
> >>>
> >>> For x86 default means present + rw + PSE, so yuu can look at it as actually
> >>> better enforcing the semantics :)
> >> 
> >> Yep. One x86 detail though, default seems to miss _PAGE_GLOBAL today. Not
> >> sure if that is intentional or just historical. See patch #02.
> >> 
> >>>> I would expect arch_try_collapse_direct_map() to also be useful for cases
> >>>> where a direct-map permission change could split a large maping first,
> >>>> and the user wants to try restoring the large mapping after changing it
> >>>> back. One example[1] is making a direct-map range read-only for security,
> >>>> which I am also working on :)
> >>>
> >>> I don't think users should care. The users care for particular permissions
> >>> of a range in the direct map. It should be up to the architecture to select
> >>> most suitable mapping size. The splits are implicit, I don't see why
> >>> collapses can't be implicit as well.
> >> 
> >> And agreed, users should not care about the final mapping size, that is
> >> up to the arch.
> >> 
> >> TBH, my concern is making the collapse cost implicit for every
> >> set_direct_map_default_noflush() caller. I still lean toward keeping
> >> it opt-in, but happy to hear what folks prefer :)
> >
> >If we could easily do that automatically, that would likely be preferable.
> >
> >Especially given that we are getting other users of direct-map removal soon that
> >would face similar problems (e.g., guest_memfd).
> 
> Yeah. Makes sense to me ;)
> 
> >
> >What the performance impact of trying to collapse after every directmap update?
> >Imagine we have a full PMD range with directmap-removed PTEs?
> 
> Collapse can turn 512 PTEs into one PMD, and, if the large range is
> compatible, 512 PMDs into one PUD.
> 
> Eeah try walks the page tables, takes pgd_lock, and scans entries until
> it hits a non-present entry, mismatched flags, or non-contiguous PFN. The
> same kind of check is done for PMD entries before a PUD collapse.
> 
> If nothing collapses, it balis out without flush_tlb_all(). If at least
> one collapse succeeds, flush_tlb_all() is called once before freeing the
> old page tables, and that is probably the expensive part :)
> 
> So failed tries are cheaper that a real collapse, but not free.
> 
> Not sure how often the remove/restore cycles happens, whether automatic
> collapse is worth it depends on that. Keeping it explicit lets callers
> take that cost only when they know the collapse is really useful ...

The callers don't have any clue if the collapse is useful.

In secretmem case, it changes permissions of a single 4k page. How should
it decide whether to collapse or not? Or any other caller of set_memory_*
APIs for that matter?

Moreover, secretmem won't know if there are bpf allocations in the same PUD
that also hammer direct map permissions?

It's either we decide that large mappings in the direct map are worth
taking the cost of collapse or we live with the fragmented direct map.

And even though it's hard to measure, we'd need some numbers for at least
some use cases to get a feeling of what's involved.
 
> Thanks, Lance
> 

-- 
Sincerely yours,
Mike.

