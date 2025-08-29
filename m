Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91915CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 01:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D6C6B0007; Thu, 28 Aug 2025 21:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34D16B0008; Thu, 28 Aug 2025 21:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B715C6B000C; Thu, 28 Aug 2025 21:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A67B96B0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:59:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7912E11923A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:59:11 +0000 (UTC)
X-FDA: 83828137302.15.EB601EB
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id A84674000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:59:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VHzrqAvH;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756432749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2COW9GRehLN1Rw71nV3+qwPFU4I39/TuLY9LVp8AUA=;
	b=5iAfFvw7qj5Jqm/zqBlw5Hwc+cHtbuIlipvF0XCnbV40uAAI0ZtPd7XhWbTKliKAusETDs
	ccDJ4vWIjjt0fym9y04nuBIJ97fwgL5/4XLMVuGLc/DwlUEQpOHqXfjyPeCZP9QW0KmvUD
	hHeraftEOXEyyg02Chdt5lERuWQbziw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VHzrqAvH;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756432749; a=rsa-sha256;
	cv=none;
	b=KamXneaFcfq/WOBkLXcONNdihBubI9SylGMoHTK2aMGFUn0BCqqcF6Gckd/wCIYbh6Ex7J
	58OO+UVfApIqvkq0dKnbE5wmqOe2SMaTtAM7u/vWEPRVbIAQU8nVLAmFFSCXeUXW2a7Tud
	yQbanEeO4H9XLDrSTOanDaYt5ZN+hcw=
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e931c71a1baso2407693276.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756432749; x=1757037549; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f2COW9GRehLN1Rw71nV3+qwPFU4I39/TuLY9LVp8AUA=;
        b=VHzrqAvHw3k+D+x0FZVE/nHe5itT45SKWNNHgmsOnkBe//RsR16+WHshqjxO4r7ZCs
         2Au6T8eZEaWqRbgFju1Qxt4xUcJygRhCXa+h18hdoeM7Q9FO5fsjP6y5X5grpDBPUxkx
         JszvS8om5WP3DocIMVzTqLyuQUEmdRvdEM+Xnlr0saPib2lQ5UdQ7ehqEMyJbsxKBfvH
         r6AS05nE41qH3PtbqBvyPuuD6pqxApWz39hRCiz+depqmjD5jnNAPrhd0lmGCm1bT8EV
         xF1s+XC0m47/CWPHOFwi1UPa1uie7mJ2O3tfbfQEXUomf4JZegeAOQN94Z11T0KuGTMm
         dFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756432749; x=1757037549;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f2COW9GRehLN1Rw71nV3+qwPFU4I39/TuLY9LVp8AUA=;
        b=awfc7lWRhp+KHDg7e0paHSgfnRVjiF/DCYSavr9kEIaXfM54R/D7ZYEoI0Yc1d2tAZ
         yri/a4EK49cqFHgk8bjD6EDsuJQaahb7cbdW/tRj7Q22OnJALcamQB/ptPw7p//cw6B0
         2qxWzaUKa2xr3zQ5V4HO9XES2LBM4K6y+aK00Cy4mTJyEvVExczUtiRx64agd6pWk4fs
         c2O2jXzwdIpnJb1TgJpyDhpSlfytHI8TwUPzbAwC7jKOKbOd4xnvvbxIbJtcU5AweJfP
         G52dUdvY1gt6+Z4ohcCiVoWYVTafsE5Vj6LXhX11C+2RUSIoGQC8nQbQvsM36G7DPZSN
         cnTg==
X-Forwarded-Encrypted: i=1; AJvYcCWMf/eCXID3kCiQ9kf50/NIoR3cYqYBMt/uPfqaM77iUzl5eyMjWV04dM0doPzdBiwCvYtRBc/fTA==@kvack.org
X-Gm-Message-State: AOJu0YyKKo9wufau377BrS5lGzayxRY5jB4KUmFik79U2iFxgq8KkVhy
	pH7BjzwBQ5yrZmAZ11rujrVME3S5FxSphc48ZLnRI+Ca8hXLyo07DYnTBfWU6iARjw==
X-Gm-Gg: ASbGncsC8iuqleYNi+0IdeVD9mmkb7lvkchsMPdaDRMFjyd9E8QqWEUeIoQj0heUxNg
	f/a4VCHTbM+EoE7kxk28biH4nhNM64Exf33mvO9fgxFZpEWtAlYDxrDwj8eY6txRYJ/EFjpkWWc
	aKDLXmgd7Xa2AJp/wBHBIS8wa8nUf6Adcu8zfWR25ya9f0qwFMJO8rELcibrZkHm1XNUv4uwZS4
	Ffjltt5loKjkwEE8cOh7nOAxAykjmomeRtbFP4mOZXfKtU7jlHR3HiLP5l7QDTykT+uSL2O8xCi
	TmFG1RPUUs5Q7uqg4SwaIVkAIq/gDLWnyv8YuY5mQEoQsvp6mAq7rEy24CNhDXElp5kWO6Kgf7N
	l9btMvA0k2L2TY0gynYsnWh/CoCmIDY/oWCzIabYTwNn8xQ0KWYUnjbUjeFBZAKBaXum3mKnmpU
	VT4fUNhB6Q6zcqTaf2+QzjeJBR
X-Google-Smtp-Source: AGHT+IHcBYe66tZLxB/j8oJQs3219sGFGexK9vlvbc+FVE0SpTBxpt+xDgszhd512yEOk9EVq+DAjw==
X-Received: by 2002:a05:6902:124d:b0:e96:c456:46a5 with SMTP id 3f1490d57ef6-e96c4564938mr16531885276.26.1756432748319;
        Thu, 28 Aug 2025 18:59:08 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9847dd8814sm341339276.34.2025.08.28.18.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 18:59:07 -0700 (PDT)
Date: Thu, 28 Aug 2025 18:58:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Ge Yang <yangge1116@126.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
In-Reply-To: <56819052-d3f5-4209-824d-5cfbf49ff6e9@redhat.com>
Message-ID: <d8e8c6d9-2b58-a1e8-d3cb-3f578f3f5889@google.com>
References: <20250815101858.24352-1-will@kernel.org> <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com> <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck> <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com> <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <a0d1d889-c711-494b-a85a-33cbde4688ba@redhat.com> <3194a67b-194c-151d-a961-08c0d0f24d9b@google.com> <56819052-d3f5-4209-824d-5cfbf49ff6e9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A84674000D
X-Stat-Signature: fwaccmfst3ua88ybeakgp8ffytxuksj6
X-Rspam-User: 
X-HE-Tag: 1756432749-121738
X-HE-Meta: U2FsdGVkX18MffxgR72lHcFjFAi4km3wwxs/10v3SPJl8AeEnbkfn3RbNwbA8FLMITdi0KKObH/lcKy5/r2Qewu4ekAe7Ny75vGY2KPkWTyZnQU6gvIu4lTHzPYZP2HwMQOOPLbf2BOcJoSocZbcJ1ZG6t1iIPxlAIkMnIcpsf2YUy2ACANLW+604j6AH3G7gJevpXqyqZ3bf2aNmTngGcTVFC4aFzni0drAZO+Xblg68J+/xL4EIhY6PQiBXPgTP9CDoVIwBo2459ufBoQVZziR2+swaSVW2d8aUi+qvGlmfJpWtA1GUOQlwWWRcnGcsAr1P43MExXqkb5AWEd7L1UimbltCFNRIVAO2gOQA/FOze2+6zpwtuTWLHjkHWuw5SdwPoBR53Pj7eWU/a/cWCwJsIBFRWC/+cjTJgTaN6VSr+6hvq4Aql39AQlwla/064HObAJX6QxV+5IULKOcoLIjqVw7X1v044oUnf3Gcd+6E/yUcoy7dpCVGhGcUTJtFJd1+qR0CBULzEmD4E4qoDMWIUS8vGpcJimauUMKHnOgVwIQc9OFM/borQyvUZUHx7JxfXLH0lK/y0VwX0JBtaTnULvKjl0HMH2L0mf4OlwYSOc19yBArm/YOzbf5o/L/PEmKTVnwUln4PNp+M7WBJd4ZUy14OzhG43oJzW4Ge4pwiWCYFE8iPErstS+QwC0/ZVJqJCtbd3XwxuEvgn9dbAlPUsYS16B/57u0a25mtPirUG71QCtgF8BLPKg2d+VIPta9vxlr9uuP7mhv+J9Y5IE3VFolsQdsA2KQDgqoXzfO5PYkKWqebSt/KfWgr3GwAIrA5gyo9AYtAe7gncGQ7tYKwvsa2Hg34IiseoUFd7veC8rEpya9C5qTdxEirAU3LdamQSgEiPToKMt+3vAKo8GAeCt60dbXCdOGIo7VjFcic0ld9x5GFYxaZTRjmPXAG3qfEFekbi+dHdp6xx
 cMzkoHFO
 T3WS3UzrvhIhVpDdDXH6NuYLJCXGrNwxK7hdbMM4o8J3WI5gy+hdtVy0zqpHL34M+NwWm5cYyhejqulW130nR7JVIElZlDYo+GgoCrkRfexD2CLVlPXlRZu2Ff0oFegs4e+yONMlm6BSqcLU0WaqXvcGhrROme/RTzxYHoZPv7C4/8p43GEb2W2K+9fheTJCs0Sp5l+orJJTynbcUnOQ2b6/AVJhnXY6hlPsU8D9o/UDK2RKjyGDY7FgioHl9w37bCBqikQRqJS+sytpvUyW+2lyjjkouyGxaPgYjhiVvHVrKhCader7PPG5ZJ51OawcERZ+y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025, David Hildenbrand wrote:
> On 28.08.25 18:12, Hugh Dickins wrote:
> > On Thu, 28 Aug 2025, David Hildenbrand wrote:
> >> On 28.08.25 10:47, Hugh Dickins wrote:
> > ...
> >>> It took several days in search of the least bad compromise, but
> >>> in the end I concluded the opposite of what we'd intended above.
> >>>
> >>> There is a fundamental incompatibility between my 5.18 2fbb0c10d1e8
> >>> ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> >>> and Ge Yang's 6.11 33dfe9204f29
> >>> ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
> >>>
> >>> It turns out that the mm/swap.c folio batches (apart from lru_add)
> >>> are all for best-effort, doesn't matter if it's missed, operations;
> >>> whereas mlock and munlock are more serious.  Probably mlock could
> >>> be (not very satisfactorily) converted, but then munlock?  Because
> >>> of failed folio_test_clear_lru()s, it would be far too likely to
> >>> err on either side, munlocking too soon or too late.
> >>>
> >>> I've concluded that one or the other has to go.  If we're having
> >>> a beauty contest, there's no doubt that 33dfe9204f29 is much nicer
> >>> than 2fbb0c10d1e8 (which is itself far from perfect).  But functionally,
> >>> I'm afraid that removing the mlock/munlock batching will show up as a
> >>> perceptible regression in realistic workloadsg; and on consideration,
> >>> I've found no real justification for the LRU flag clearing change.
> >>
> >> Just to understand what you are saying: are you saying that we will go back
> >> to
> >> having a folio being part of multiple LRU caches?
> > 
> > Yes.  Well, if you count the mlock/munlock batches in as "LRU caches",
> > then that has been so all along.
> 
> Yes ...
> 
> > 
> >> :/ If so, I really rally
> >> hope that we can find another way and not go back to that old handling.
> > 
> > For what reason?  It sounded like a nice "invariant" to keep in mind,
> > but it's a limitation, and  what purpose was it actually serving?
> 
> I liked the semantics that if !lru, there could be at most one reference from
> the LRU caches.
> 
> That is, if there are two references, you don't even have to bother with
> flushing anything.

If that assumption is being put into practice anywhere (not that I know of),
then it's currently wrong and needs currecting.

It would be nice and simple if it worked, but I couldn't get it to work
with mlock/munlock batching, so it seemed better to give up on the
pretence.

And one of the points of using a pagevec used to be precisely that a
page could exist on more than one at a time (unlike threading via lru).

> 
> > 
> > If it's the "spare room in struct page to keep the address of that one
> > batch entry ... efficiently extract ..." that I was dreaming of: that
> > has to be a future thing, when perhaps memdescs will allow an extensible
> > structure to be attached, and extending it for an mlocked folio (to hold
> > the mlock_count instead of squeezing it into lru.prev) would not need
> > mlock/munlock batching at all (I guess: far from uppermost in my mind!),
> > and including a field for "efficiently extract" from LRU batch would be
> > nice.
> > 
> > But, memdescs or not, there will always be pressure to keep the common
> > struct as small as possible, so I don't know if we would actually go
> > that way.
> > 
> > But I suspect that was not your reason at all: please illuminate.
> 
> You are very right :)

OK, thanks, I'll stop reading further now :)

> 
> Regarding the issue at hand:
> 
> There were discussions at LSF/MM about also putting (some) large folios onto
> the LRU caches.
> 
> In that context, GUP could take multiple references on the same folio, and a
> simple folio_expected_ref_count() + 1 would no longer do the trick.
> 
> I thought about this today, and likely it could be handled by scanning the
> page array for same folios etc. A bit nasty when wanting to cover all corner
> cases (folio pages must not be consecutive in the passed array ) ...

I haven't thought about that problem at all (except when working around
a similar issue in mm/mempolicy.c's folio queueing), but can sympathize.

It had irritated me to notice how the flush-immediately code for 512-page
folios now extends to 2-page folios: you've enlightened me why that remains
so, I hadn't thought of the implications.  Perhaps even more reason to
allow for multiple references on the pagevecs/batches?

> 
> Apart from that issue, I liked the idea of a "single entry in the cache" for
> other reasons: it gives clear semantics. We cannot end up in a scenario where
> someone performs OPX and later someone OPY on a folio, but the way the lru
> caches are flushed we might end up processing OPX after OPY -- this should be
> able to happen in case of local or remote flushes IIRC.

It's been that way for many years, that's how they are.

> 
> Anyhow, I quickly scanned your code. The folio_expected_ref_count() should
> solve the issue for now. It's quite unfortunate that any raised reference will
> make us now flush all remote LRU caches.

There will be more false positives (drains which drain nothing relevant)
by relying on ref_count rather than test_lru, yes.  But certainly there
were already false positives by relying on test_lru.  And I expect the
preparatory local lru_add_drain() to cut out a lot of true positives.

> 
> Maybe we just want to limit it to !folio_test_large(), because flushing there
> really doesn't give us any chance in succeeding right now? Not sure if it
> makes any difference in practice, though, we'll likely be flushing remote LRU
> caches now more frequently either way.

Ah, good idea. with or without my changes.  Maybe material for a separate
patch.  I wonder if we would do better to add a folio_is_batchable() and
use that consistently in all of the places which are refusing to batch
when folio_test_large() - I wonder if a !folio_test_large() here will
get missed if there's a change there.

Thanks,
Hugh

