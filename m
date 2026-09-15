Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608D6C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8486B00A1; Tue, 15 Sep 2026 04:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7836B00A2; Tue, 15 Sep 2026 04:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F026B00A3; Tue, 15 Sep 2026 04:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 309016B00A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:35:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 448F480363
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:35:49 +0000 (UTC)
X-FDA: 85215338418.06.079F47C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7749140005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:35:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMoCyjgy;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5PMVhNm6w7vScOauxt2sn2fqUvvMTkE5qtbt52NA+c=;
	b=0JOXpZ8uDqe+20iA4LqAKYayd+7AoZFLhLUfvLcPLhC2lEpEwzxlL+9E5qtzEiOrsU1NUo
	ISzHzHMD/8qtblZkiigvv/Gcw5JmdAQtLZ3apR7Bo4farwIkhdDyR6Ngnm5J1fOlENJFKj
	hohBKdWCn3EJClPvECgo6sw6NuPxplE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461347;
	b=k4KXXKfbPIU8YMBopO+hityZIgKGw+JXtqlSOuA1Oatt9BN4m0ft3+Mx11qXWqw+qgBYpG
	pvflXOxuXkwQ4RxECB/xBicYWfOvJ5oeUr6UopocZOsmRI5WY/Jumq5hfgOIMCyc3Jlj/3
	6/64a5bWFcxKjqMz2VXat3A3PGXs76E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMoCyjgy;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E39BB600D1;
	Tue, 15 Sep 2026 08:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D6F1F000FF;
	Tue, 15 Sep 2026 08:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789461346;
	bh=V5PMVhNm6w7vScOauxt2sn2fqUvvMTkE5qtbt52NA+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iMoCyjgyoF5Aia27jf1t2O0HSyVcKcUmOQA/DJ/7kOdR2uRikSSQXjTu2T9pU4uha
	 WMSv5gbH4lyfFjgNW5IWEIW6Yqgp/hG4upDDmYllejUuFHCb9MymHWCulFEl5OV+UB
	 0CLv6Lpcn5UoRCe0pALkn6kSC1v3joIYQJ0m0EiGmLQEd4uHlGixLo7WD8p7EcBsf8
	 wzYjmPtTSQVVzUGXkicNIDUp4Hp+LWYY7YLo0TXOljiQta9Yov8CimRzuw8PrTDqA2
	 dXFOfBtc2ZHOfngDM/5Fr9y8NhFVhovxz4qGp8h9M3X24ARuL9Wrmj8mhNuAlWUbt7
	 imvp2N00pk2Hw==
Date: Tue, 15 Sep 2026 09:35:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <aqkCXW12QFi03jX7@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7749140005
X-Stat-Signature: 56359yttqny81kxm49r1k36ueqyy15fs
X-Rspam-User: 
X-HE-Tag: 1789461347-348694
X-HE-Meta: U2FsdGVkX1/zi63YypjjxGZjAfBBfTYk2f1IDbovE5wlZdfAO6YK8OefXShGFMRbuSn2War5PbaDaUwctgGyMnnZKVzoI0evQnHTnaBmyg/WcV3ns4WTVCJveqyn1r/DzwmiLqjBYNOEzPp9CoHqEUW2oCBXBrX5wnDOVvIQbFACnwzJbIzrYHd795Xwkf+KFxxNy5RDnxfpvRg3CG50FzTbk/O4Hphs++GNpX0mDHWrLZEuEH6RQ72sYzHb4Edpp4ORSH4gpnyYH+miT4eRbd3zp1tvpSJQgiQsgOSUnwa4SknojZjuWulXWpbZ7klVTDUiVRMeClVNAnQZtcDY1zQZ/MYjlpYGv7SmS3oHK3fHgfqQrXnYyVXtU8WlfpPrB/8SbM/qkcoD+oQgVjoQcBPDdQmr9IVxjzNA1EhGOmkxoUS7b9gbFchUWOtvaTd7Rj54YHZzXm0LMo8B5Z8Faun50XPmmC5eom64E03/2R8yWEZGqk1wg47zATWkX/xE++8a9pveH5lbzYCfaSfRcyqQlpfjMYxNZ3e5Fc7ouuS/6RylM9alH7WRY90jUJw0+GAe2UZMnmtYlk1xpHScrwPB43OtheqDEa83apFVn0ezMUWjtJ3SePD6o2+l+MO/fRNJKur0xwR6Sx1B1rA/ODaHcc5vVr22WJ3mSa8FvPRm/mUtQaDBTJbgQ/4AXKuHXgE25sOrdn89wQw8JIjnhMBW7XtKXmkf2HJZ65ncesz9OOxCaTR1p/cldfdPWLSIdP6i45wQN4zDVrOzkrbj4GWzTWK56h/PhsFrKCsygiTg3VtgDfn+HEDOXDCd4sXRvr6k4ejjQB5tONTiF6l0+e+Qy7NCqM0EWrxybvVoTAKvDqEyd/C8fLs6+W5nULN5ruyvhEVkWwYUdKUhINfEin+UMaqBZV3A98E3ipIuPe5yqoLTRDCh68to8oQ0Zlgppoo/6sKQzPL9IHJg+ZH
 wswKlSY9
 U/ZzMwUTb7OkC9p6oHvbMBCvzWxHKeSJzmbw6JdDngfM3cs757kxSYnaPcqcmO5uZT3wwivCijYkzADfTPpGx3xWhUD2Xe6KNJ4tUmOR4vyCNV+36dlIjcGOHbXh1MAoFHoecdCTQ8ktbVTv5VJde6p4ZZ/edof581wVBtcoaIj2oePzki8jIGklUGaqzsptdquebK0SVEZiUUCkB4QXw6b95wm/aWxhjImo5WEqM6T/fTekPylJyo6I1RGeN6oGZFxewekR6dvNqTWx1LROE3VcDaQ77loYF1EHtY1QIYZNMxaokeP4zl/pRxnQ3op3tzKgW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[excise cc- list to mm]

On Mon, Sep 14, 2026 at 06:08:11PM -0700, Andrew Morton wrote:
> On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> > properties:
> >
> > ...
> >
> > It's all rather a mess.
> >
> > This series brings some order to things by both limiting what drivers can
> > do with VMA flags and switching to using predicates that describe
> > behaviour, not arbitrary flags.
>
> That's a lot of patches.

Yeah I know :)

I held this back from last cycle to reduce workload, but I can't keep doing
that :))

It's a lot but each patch is relatively easy to review.

>
> Review is thin and I expect this won't improve a lot.  Lots of "no
> functional changes" changes.

Well, I think it will! Had a meeting last night where Suren committed to
going through, and I will nag people.

It's a very busy cycle I realise but this is mostly fairly straight-forward
to review.

>
> Perhaps it would be helpful if you were to identify those patches which
> you'd like to see reviewers focus on?

The mlock stuff is probably the most sensitive bit. But in general that the
semantics are what we want.

Already had some review on the driver-specific bits from relevant people (I
fixup a bunch as part of the changes)

>
> >  1153 insertions(+), 582 deletions(-)
>
> It's funny how often cleanup patches do this.

Well it's not just a cleanup per se actually, I add a whole new
mmap_prepare() action methodology and add a bunch of mmap hook validation
so it's adding functionality to the kernel.

And there's a bunch of kdoc documentation too (plus a whole bunch of
additional _actual_ documentation added to the mmap_prepare doc page), so
there's good reason for the additions :>)

>
> All queued up, thanks.

Thanks!

--
Cheers, Lorenzo

