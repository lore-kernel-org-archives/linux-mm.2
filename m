Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44D6CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0678E0009; Fri, 29 Aug 2025 12:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098BE8E0001; Fri, 29 Aug 2025 12:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17588E0009; Fri, 29 Aug 2025 12:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B258E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:04:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48AC1119B4A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:04:44 +0000 (UTC)
X-FDA: 83830268088.12.E943C41
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7712F1C0013
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:04:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3W8ex6R3;
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756483482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3ieh9vXd2rGxldog2/NrBq8T9491db7QVgaiuI0n0k=;
	b=UNqy0qwr/ldNG9O6rfL6GilGxTo4S9+Sq25AydF+5yISq3DG/YcyOenIPDLHgmy/w+kOaY
	Q1ZadAz+9mTdyZ5XH/g1t6lTdZPF4Gwb736b3E8OjBiU7I5xm2yiRUUydbyp74eaf4yKqw
	q8hVSYGwWByaiAzxInA2Zi+RjIKOCLs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3W8ex6R3;
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756483482; a=rsa-sha256;
	cv=none;
	b=T08KgSdXzYnpMkHC9fBNnyFpkQHiXXZA3u4HA87T+4hsTpTkt1iZX8HiKdLgbluJXuW9zY
	t3mi2G+PFoXexi0NDB99jQ+efWEwPA38NIeshEpORq4bx4A5jGjlahG8WGsYgUzWMDhvKl
	w+Tqm6gtZNe0DOuK5U4edzVgaE9C2cs=
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e951dfcbc5bso2104700276.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756483481; x=1757088281; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m3ieh9vXd2rGxldog2/NrBq8T9491db7QVgaiuI0n0k=;
        b=3W8ex6R3hLbpQpIcBOt3VWvhviI94k3XzTDR0f6zjfJSJgqhH7aLXz8fcH8rsml1pT
         A4X5rHmEEo20oBIbJNNn4zm6iZBXgfwzzHYOWH8E1JyebCV2PrnR/YdlB+aKDjWwM9bk
         pV+w+rEDAUytqwt0ape1CfwNkuA5EKNyN65UY8Ae6dh/+lRv1VhJlLWCJGSvgWI0dURq
         R7q0iLn4AXwlwSoG9/wqzmWi1Qw7Zg2cG8wuG9BAB38KpYf0fxYm82LrmJIThyyAnHrB
         LJtpkqaqT5OSs1ZxaDxj671t268iqVRg6xpAZ23nQXr3bPiT7DklDVMKGje+oIo0DNqA
         ursQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756483481; x=1757088281;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m3ieh9vXd2rGxldog2/NrBq8T9491db7QVgaiuI0n0k=;
        b=rhDvxG9uGRkVF4Qa2jHVVM7hO09LNbf5RvSHGiIqfOj1GiqUm6aaUtEUji+PkWcd9u
         n7wFXjAYd7oJ/0cL6xyvCGTihb3aWPMlYRcJQs7Lo5Ez7kFJKawXyF3eD364+AZSNv+X
         aXrYgRQWnig5Lje0ognYz3CifRFf7mkV/OaeESsX3PZmj3t/7uTEkfFjmbioXI3KFnpX
         ZAwhEIMN+rZIKSUv1LzJ+XmNqCqqJSQl+e0oWR05egK4r9A2F5NWFjTCQG6ZSSh7z1Pf
         DQtY3TYmIkLmvnP8bxQi4hPx+jPpUUdhQWVTqJZbhuXubvK6cmX6ayPj5R9FQZ8gcL7p
         SzZg==
X-Forwarded-Encrypted: i=1; AJvYcCXchtifo2/SdTasbQnkrRCIDprzbe/fswGGMUgiNyfWjW2a9n6m+zLoOzi5Qfex7L9hrUGwGlHn/g==@kvack.org
X-Gm-Message-State: AOJu0YxRzxo7F0h2POfJfYi8BAZfvL2jgqcd+e+lWkQlQ34Wtq1vyi2Y
	Qf1LRnxUQbh5S/iTB0iJCKdOYyzJ8uuKyV5z1408ZrY+5TdhaBiC/GxZSO7s+q/T8A==
X-Gm-Gg: ASbGncs5UDxXLnqrCwz1w3rGqkD2fauP1brS3KAjHbYDIPqsuvED+MRccEbfYpiSxqR
	MNjcCnxI0Xu/KQUvtcM5Om6z+THwLbZtQDNNNFRsKjKmpgF1FQXElehlBN1dbfZAV82LI2CA6ZH
	c/4bQ9noDLoaRHAAK8+QYPac2ma32s+AOnTYMofO5xrjmTk9OyGtrekmEMxgqpkldrB1FUqsHH/
	M5ASWIXq3gUUSow2U0yKo+Pjcn/6OUkw0JI2yEGb5HelTE7+7HVg4hmGKmAjNroo570YXfsxeGC
	bSWiXGBxBW6O6Khj7xJfldyJpKg75oTZjKWObA4lWRcLcm6oytm1WmH10mPthErr0hQczdyyhAm
	taoldDCrMqjii5bHJLBaBj3iDWbPT8i0S7Tv4urQXq0I8qPXc/7uH6Hf2WOYn5aJ5UZh21zO1dE
	nrXDgLkaKD50QIgA==
X-Google-Smtp-Source: AGHT+IEkokJ2crbrTEMsTpOoqwCtDYr7v1QWZ6l7POfXkmk+aYp5QMOEWlSlYjumwDq798JtyHHbGQ==
X-Received: by 2002:a05:6902:210f:b0:e98:10e8:a8de with SMTP id 3f1490d57ef6-e9810e8bac9mr4221714276.34.1756483481001;
        Fri, 29 Aug 2025 09:04:41 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9847dd4494sm836125276.30.2025.08.29.09.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 09:04:40 -0700 (PDT)
Date: Fri, 29 Aug 2025 09:04:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Will Deacon <will@kernel.org>
cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Ge Yang <yangge1116@126.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
In-Reply-To: <aLGpcOSTGiJIRQda@willie-the-truck>
Message-ID: <24905f30-4a7c-e627-a272-80977204ed68@google.com>
References: <20250815101858.24352-1-will@kernel.org> <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com> <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck> <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com> <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <aLGVsXpyUx9-ZRIl@willie-the-truck> <aLGpcOSTGiJIRQda@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: o6ad3e37zhnrn4ne8wun75nngeujba7e
X-Rspam-User: 
X-Rspamd-Queue-Id: 7712F1C0013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756483482-628267
X-HE-Meta: U2FsdGVkX1/EwVYN6Pp8JU6eVQkKsudXk+KXtzSHM/V0GchhKvR54mB9VLm65vqAroEFOldjqbD/lFdMEcfGuFyl20PpOKV0SkZRdXjATNnR0GuqQ+ENSNHM0veaygiTRAwSbcZernF7x6VeZ7UI6oDHH01gc2ABCeTYjsjHYGSSRCr8y8Wvrd1eOaneGDkgpeWFdeIUTIIygv9rUVedNZhWFMgYzZFIPMxqMBUeGFoT6lFTDj9Lc6GuuUY1Fj2EaPTbkpZufVoUpO4jd1vi70zRulIs1icoSSf6V/T9Wvm0VAfIVD0jra/jhAWZeLA6EHi+6XYWbLV6z7R6wCzQeKx2pg94Q5N3XYKY8f15UXtu5BevssJ6JqO+Ljw0RIwA7O+kHwBDVzl/M1gaXarMonpmL4AmnvvCVkvby8mTt5CZzCJg9jIkCZW3WOpVoTrmS0+d5a9uBOwYXVu3cg4LsKzFLKL6M70bp/Q8F+FNqaRJQAjYKyDWMxjxy1Ydy6W1ScJ8yK22kZgGYsWXpwTRba+DPy01vuRaJQGvT/TTJ7KDaV1oR4S+9HrW6uBAD2tLd3mKXRuaYoinUKnU5nomnvCOfjqIm1qV/IkJVI691dBTLm8a5CiUiXi55wW/VVqI6xQo8+DsgYGFwhHYC/C5vjYXeJsnyRuUv7+jPdd9kDWsiMdGAiiiJrd6k8heIKaSO6B1MKD71HSgtV8QL8roOITAoWkPxr6b6oB/xLNWYWcjOKT0d7M0ugGjCEs45hWsm8FjpPezVsr+ZV8kvGKynG8byek+Pca8KSgRGiUx/0XsVT4dfnq8nlwLad9HPQgUqGPzqLhFuAH/BELU7kAEtiskq+REQKP3J1VPlQBYUIaSqkXmw2XPIsOvJY5sWmP7eAou2SNoRaY6p9hirWm8EWeQRgnNoRnsIJtzECquVWzjPK20DnkRUY/1HLKOG2Of+J3CUxUwadQ2Ddkz1cE
 ImhclQeR
 yyJtmG/KZXsAGXfr1YtZJ5x9L2ZJ0ym818PrezDk8CfGNLnAQFXVa+H2SM4WVW2wcnRRBFYwWnAAn0Mve/D3CjpqC5k3vqewL4GyoM7W/IM0v1KNLLzHRBtFP7PJ9zBEH8QnIUXwln+5ybTeH/XbYy1/iDxIrLvAVQ8prinNmii9bqwVWO9apHj8w1bRO1km2a5mTURvRmH64tZI/CYFjTxAU7vmjtjDtduKpIjotYDWZX31BV80QgwauQ0FOHkQvlVFnkTyAMoSAD5nW+axQpABXfbO51L8/GJ+0B8cqzoqcMFVXMySh4/W2HEpp5cMKQU/P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025, Will Deacon wrote:
> On Fri, Aug 29, 2025 at 12:57:43PM +0100, Will Deacon wrote:
> > On Thu, Aug 28, 2025 at 01:47:14AM -0700, Hugh Dickins wrote:
> > > Patch is against 6.17-rc3; but if you'd prefer the patch against 6.12
> > > (or an intervening release), I already did the backport so please just
> > > ask.
> > 
> > We've got 6.15 working well at the moment, so I'll backport your diff
> > to that.
> 
> Notwithstanding my question about the synchronisation, I cherry-picked
> 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count
> calculation") to my 6.15-based Android tree and applied your diff on top.

Yes, I cherry-picked exactly that into my 6.12.  Not a big deal,
but a word of advance warning: the first patch in my series will
(I believe) be a fix to that folio_expected_ref_count(), to allow
for PG_private_2, which implies +1 on refcount (I've not yet
researched whether it's +1 or +2 if PG_private and PG_private_2
are both set - comments I've seen imply +1 but I need to check).

I thought of that when doing the cherry-pick because I thought that
PG_private_2 had already been killed off by now in the latest tree:
but was surprised to find that it is still there in 6.17-rc.

> 
> With that, I've not managed to reproduce the original failure and
> haven't observed any migration failures on the GUP path.

Great, many thanks to you, Will.

Hugh

