Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1CACA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9161E8E000B; Thu, 28 Aug 2025 12:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C75E8E0007; Thu, 28 Aug 2025 12:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E888E000B; Thu, 28 Aug 2025 12:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 65C228E0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:12:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CB3D139788
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:12:47 +0000 (UTC)
X-FDA: 83826659574.20.8683981
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8BFBD40014
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:12:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tq9Pw6NT;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756397565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKrdECwCL/S2DsNGSmoGvfvwMbZyFm9pz9Oh0/KdiMo=;
	b=2FkRTT4301YIQR4wdnvw0RitJ2SIiks0NoBYZ6KtPqjLU0L+BH0ckjcHtBTsl6D0Crddx2
	Dgaa3E1B+IN7D73XEqPNGshuicdV06kSxeHV9IxS7g5n4FE/nXZ4NhaH7KJuI+cVJIRNpm
	LsExloc65rYkLMh5IzqFHIkCSPqYzfU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tq9Pw6NT;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756397565; a=rsa-sha256;
	cv=none;
	b=H/CBLBFBgmY+0QKA4KTcCSCRbwyhFDXArVhICCWBQk5LWk3xCxTYB8pR/vD9JeCwEIj6Xn
	y2nGHy6rDGGIb9tndM0XTmFS6cn+GLEvdkKs7PVegzfBZ5R70fJBgBFOhMdbwKEXbKO78l
	Npba31CFZNl773H2zlSZkOJIUci2pIQ=
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e96eb999262so714051276.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756397564; x=1757002364; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AKrdECwCL/S2DsNGSmoGvfvwMbZyFm9pz9Oh0/KdiMo=;
        b=tq9Pw6NTPdGXAcd3MSrF/mrdJxR6PwU3f29wyraeUwHNgxT5zd2Npu8wEo+Ay40Ny/
         +K/EAAJJMN6xoFSg89mLPYxiNfmY5yty9govPbbXiMUFnAJk0qUQnGA20LRu5P8P64j4
         07q/RFbqTY2juYPUBCD1hNpvXydJm3SZ6Gyxbjm5lp4W4TBSwQ7d5TNF3uIvGhid5aGZ
         by8QQxM0mAyX2xofJsqXHFFbdDYClqRuTKHQU2+a3daakOX27h5DsNq+DUdNV9i+cy7T
         ek6tCsASekvbXrby5NwGama7DyOemcXM4C3upSoMo68+CwMOHmxktfN4g3pynRCNCzfC
         kmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756397564; x=1757002364;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKrdECwCL/S2DsNGSmoGvfvwMbZyFm9pz9Oh0/KdiMo=;
        b=DUzGxXCa9MXSmEmnsPAOdprziavZJeveo56jd9MnchOyWmpcWhFYaiwPGBJTszJSBO
         L8viYlQ+zRepDbfoalkko06Mpyjcz4vGSX976RqPLPNx/2ZUp2zvN2juTH9dCmAZoAw1
         VLJSHbKDad60+T09xElB+dJZvBWXqP+HmqskkAZI5nIFNDwzh1vsAHzL6yrT2FLAGivv
         XF7mOvoYu0+M+fO/TjvTr62V5cgvwIdoECVc+dk9Y+yjUxEqRP4iWIW5IpED30LypOFw
         p4Jg7St4F8i6emq33ePkJj0QTU+gkeBlFotQIxWh3+LyFmg19EbV6zwtU7xTNU5NwRSj
         /ebQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBk0V5J6VWoYL9b8zpcbC/rs+yZGP1xFw1n4jRIoykFLa+ajGps787p/MBMhoHVXp3OQrt8ig/hQ==@kvack.org
X-Gm-Message-State: AOJu0YwpELge8SNvB56bmXbmRpYq8+013bV93lyMaI/+A15qpvEY0ib8
	gIpA7uuBtjQVL0kg+Ga6JceyexZHRhR/rVM5fd9PKYA9toFJB9nngKiJdo7dfHOPBQ==
X-Gm-Gg: ASbGncurQp8H3R6m1//G22ZCItuQKSjH8NJih/gUFg8+JP+yW/+shsHnyDz/PGXnDu9
	Oku31MBx7y7BCTz1ZvrBS3aN4jMrjKvexTImw6niX3VkIVsKU6W02DMNoaJvDjf2yQBJdXP/l18
	+PoiN8L40C4gP5UYJFFT7c6W3L66xL7wZflT5MlLYbjCAUlu1kycbwcqzXAablvsnU2MzjwSMAZ
	KgNR9vcPL94Avu6BecYVp9UZIFZmA3xAT0VylQXP4TxSMU6PNNE9E4jmYvRX46Dkcs/SbL6dlVG
	e/aeU42cx+aemKD0roBNAoLg+zJNvFMQoiQBO8E/thBjeE+o8Tov4m0QlHecZVURFvc3+xgAzVR
	Wz74kVuO+WzKxS+WQnWaqwor7F0IIHUeAvcT7ytXwoHLkKwvdzjdgti7dblJlwtSRQW4FP8Xsga
	xvSTcIo/5ixShwng==
X-Google-Smtp-Source: AGHT+IEs3OYNfV4fyshSQdcWOMf+X4BHAcpfnqkUSzdEGPE+H8y4jjrbJGNSYkDTCZ5Vd59EXR/FKQ==
X-Received: by 2002:a05:690c:9b0a:b0:71b:f712:2a2b with SMTP id 00721157ae682-71fdc40b326mr301211777b3.36.1756397564135;
        Thu, 28 Aug 2025 09:12:44 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-721ce5cd204sm295187b3.59.2025.08.28.09.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:12:43 -0700 (PDT)
Date: Thu, 28 Aug 2025 09:12:30 -0700 (PDT)
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
In-Reply-To: <a0d1d889-c711-494b-a85a-33cbde4688ba@redhat.com>
Message-ID: <3194a67b-194c-151d-a961-08c0d0f24d9b@google.com>
References: <20250815101858.24352-1-will@kernel.org> <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com> <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck> <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com> <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <a0d1d889-c711-494b-a85a-33cbde4688ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8BFBD40014
X-Stat-Signature: rhfy57f6sa84m4wpfhf3dhz7wzcp46tf
X-Rspam-User: 
X-HE-Tag: 1756397565-480593
X-HE-Meta: U2FsdGVkX1+fRF9HMVMFEkBCiK1K+jfzggUdIIOOlonxfqdqjDwXVRjgdP5wQbSMMc7yBb6mgV1IiskgwZtsB1TrbkuhBXM6elNaDtS/ZX8/5q4IQotwFOn7fFtJllKPkF51dBWg5oB7oatPIBONM4ncvnGC6e7At22J5CRFiL7Ne/Rl3AAks23v4TDD3Gl5lcTX5QGd4NBUD7IrVq7Tqbg7Z8WUyfCJKjNzZg6x2vdp9p4kicpjqA+iLA/oTO0lhNO+AfaBQd6vM48GiUHWCoAAWm+ebU2V+sB7xErDofj55mRy/MBaHmgf4KILNscrC6me+7lBc9uanGCqFTjMOUyj9vhpGkE+E+K+8CV4iPychz3j9lHiEdZ4tfDIsJbuV0AkNcFc5Fm7mV719Nda7danwkVy4wtoypDmKzrbhNx1eLSSl678FA30nrOLWEU0K1QvdC/tDPLg6qpk4rVLKfQMjjbZBLIquzEDgzM0ngg8GkCVMkkvQax0HykU6QpBy0YAa0/DnLPXPk1nF7JnCrAId+LDN9c34rdRB0zq4xBDj6LofiM4rch6q5GR3n2YCgoyMxQ17DLAFwjHyF7BTwR2pTNAb9colY0iSPMg9l3GnWxmoKnWEViBMFkJ9W2cwVGy6mz1gh5ARPFq6OdpOOn6xkzseDstOxzAYgRVyEZn+9T9TpMF4Kt4wp/IadRjnB+PlrG8wdzvK62QwV4cGlzCoCtkhJ9GCroixJ7i7cJ6babKCNkPZq5zStDDuA1f+ftNwF/871Ph6jGb+R1WwdDDZR6pJkw868YeFr9WFofD6jcPETGBPcBjQhycKE396binNQOywPni6dd6EhMKSFFDZBLYDJcDAMM3ZkeKCoswTkIWYSdqPW7H3bdGxvjMdMBf7zhQKRJ4zIyq8UEhW2Sdu+ivsVPkxBcmNZpmKW/N4mfAUPGueON3UXDcYlpdOyQKHxGcjVLAuhoWMYz
 MrA3orGq
 5Tg8JKcv0r2g5dhg/wT/9+kx6Sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025, David Hildenbrand wrote:
> On 28.08.25 10:47, Hugh Dickins wrote:
...
> > It took several days in search of the least bad compromise, but
> > in the end I concluded the opposite of what we'd intended above.
> > 
> > There is a fundamental incompatibility between my 5.18 2fbb0c10d1e8
> > ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> > and Ge Yang's 6.11 33dfe9204f29
> > ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
> > 
> > It turns out that the mm/swap.c folio batches (apart from lru_add)
> > are all for best-effort, doesn't matter if it's missed, operations;
> > whereas mlock and munlock are more serious.  Probably mlock could
> > be (not very satisfactorily) converted, but then munlock?  Because
> > of failed folio_test_clear_lru()s, it would be far too likely to
> > err on either side, munlocking too soon or too late.
> > 
> > I've concluded that one or the other has to go.  If we're having
> > a beauty contest, there's no doubt that 33dfe9204f29 is much nicer
> > than 2fbb0c10d1e8 (which is itself far from perfect).  But functionally,
> > I'm afraid that removing the mlock/munlock batching will show up as a
> > perceptible regression in realistic workloadsg; and on consideration,
> > I've found no real justification for the LRU flag clearing change.
> 
> Just to understand what you are saying: are you saying that we will go back to
> having a folio being part of multiple LRU caches?

Yes.  Well, if you count the mlock/munlock batches in as "LRU caches",
then that has been so all along.

> :/ If so, I really rally
> hope that we can find another way and not go back to that old handling.

For what reason?  It sounded like a nice "invariant" to keep in mind,
but it's a limitation, and  what purpose was it actually serving?

If it's the "spare room in struct page to keep the address of that one
batch entry ... efficiently extract ..." that I was dreaming of: that
has to be a future thing, when perhaps memdescs will allow an extensible
structure to be attached, and extending it for an mlocked folio (to hold
the mlock_count instead of squeezing it into lru.prev) would not need
mlock/munlock batching at all (I guess: far from uppermost in my mind!),
and including a field for "efficiently extract" from LRU batch would be
nice.

But, memdescs or not, there will always be pressure to keep the common
struct as small as possible, so I don't know if we would actually go
that way.

But I suspect that was not your reason at all: please illuminate.

Hugh

