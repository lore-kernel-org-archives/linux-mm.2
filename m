Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A6A0C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692146B009D; Fri, 21 Aug 2026 14:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A476B009F; Fri, 21 Aug 2026 14:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7036B00A0; Fri, 21 Aug 2026 14:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAE66B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:53:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C59271C0990
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:53:35 +0000 (UTC)
X-FDA: 85126175190.02.64F077A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D479F4000D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:53:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLNXWg4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJOmipkwo3tYVSohjwj3sMGRCtlJv8azeHNSTZbC/qk=;
	b=ECLI1enBG5xeRa1D1hfZfgI5rN62DD7JTZkM6+yP1YAXdYbB63VOqbHzp75QHu3popW6J/
	Nec7Ks2gd7IgspL6vC0FhnMkTS5Hkf60IZRtOE03h1w60AyQ+YhD9kTRCU7JQq+9j6mayC
	vHLKL3vp4Hm80UBJltvytXYYP19M2mE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLNXWg4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338413;
	b=MdTd4oy5o9KnuolPpq4d4JJXay8DJ6UX1o/z/usQXdk+TzGDNNH4A4uh9FzI14aek9sFyT
	X94w+MFD6TESg72HtuA+Ucu8dsxqO2/z2rgbmrvLV5awKPY5klc+VoOJjoPKDlbq/Pd8Bl
	K/xcW1k5XmfKJXWxIwe8uspsvZ+DzT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7D2540BD6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F71F00ACA
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787338412;
	bh=MJOmipkwo3tYVSohjwj3sMGRCtlJv8azeHNSTZbC/qk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iLNXWg4t9eoGOZR0gPKJ6Tj/bMZUUatvX71nAYo3RB6uE+GPB8Fl9Dvo0uI6lISmH
	 FkIN7i4Z8WZoMoTIAyZnTAvCkoLqdWoaMe6X2DpOGou7qihxosgF7QSJDLo9b928mT
	 gQ4FoDb1GnoXc4Q1n3rdxNaWKCJeNpnvn8d2NNM5Ku8rxD5WjBujPLJfzMHqe/usn4
	 sg/25ch5AdFUz6LTSH7NAuPddPLnS89w92wVmUd/lN5XxRrD5DS2j1MoOcUNzv6/YO
	 67w4JGvg+OQ+pRI4CnmCoMz//muNYMnubf2D21wzfsGoOwoLYCXtVqsinLoajRZnFh
	 Z/YtSeJpoCz3Q==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-930f618435cso78999285a.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:53:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqBMdORAqPSW9jR1/Lq/NJusiBf7tqZet8nOupm63H3MXqpM8uc7Ne5C4zQPv61G75f8MFOuarN4g==@kvack.org
X-Gm-Message-State: AFuF++nxhXFmnWf5YSqRtbjwcNjLbTYW0T2kSw/MVyJT7S0vyIUZ2A2/
	dTXb55meUPDAKiKcqv6AVS1BQMWpZTPXAQkPY2X56W/NjgCrF5qQqml94AzaMeT0mkRo23ejoIn
	W44ldrNTDsDBt7OIy5/BYJAhs9ncmeCo=
X-Received: by 2002:a05:620a:4388:b0:936:dc16:206b with SMTP id
 af79cd13be357-93746948da6mr104676985a.26.1787338411895; Fri, 21 Aug 2026
 11:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260818225904.55236-1-baohua@kernel.org> <c8287b5a-8f8b-4110-ad47-996842f01bfe@kernel.org>
 <CAGsJ_4xT-Nga9yCa_QtbmFQ3tm0LJF0doCsV3pJpO0i+2z4yww@mail.gmail.com> <cade8707-26e7-4f8b-a056-95094bf8756c@kernel.org>
In-Reply-To: <cade8707-26e7-4f8b-a056-95094bf8756c@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 22 Aug 2026 02:53:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xPwZgzks2LBEPLU9KyO4yffCN5SuEdChxxD1UdJfi65g@mail.gmail.com>
X-Gm-Features: AcwNN1XPas0d-Jla5cIG3jxi1MqdXYJNqkTYIxBKPlRggMLZQprrbWtAm6MQBdI
Message-ID: <CAGsJ_4xPwZgzks2LBEPLU9KyO4yffCN5SuEdChxxD1UdJfi65g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, 
	surenb@google.com, vbabka@kernel.org, ziy@nvidia.com, hughd@google.com, 
	ackerleytng@google.com, usama.arif@linux.dev, joannelkoong@gmail.com, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D479F4000D
X-Stat-Signature: 34dzbig1zt8hadwgbeizabpbjj8thdp6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787338413-785953
X-HE-Meta: U2FsdGVkX1+sQxlbTtDFpjIORGE1UOedJwCdXZ08ScA7AsZybUazJsFpvxlC2zxPS2f/IRhg/DPFRsvvVRWyB2UbJblTuD7iO10gPGr47NEGfDI3LmjNTm7xcT/Wv7+ZuLeJqWzLubdR+d0Qv8+goppSi2DzFwQMoJoXblyo7PVScmBbd9qLdo2ydio4BAVt+Ht+CpvSS5TlODVV8waHVGULNbABfPgMVWKdb6GHfgi6R/naQrndgxyyhbq6YNU/2SWEKe76xIcvZD/dvuJCl25fnTN+GEjEnOqzw25WkPnB5Vg1iTX6UMOWYPsZz2UR7CNjxu9qeDVGWhUklPsftGJPAGMh68SYwHFDLznqD8riuQJZ6bNhnA9fOn8aww3xJWHQFs0IcMIN7xovkEjZ1jRDDQzxTs/wQfbSy5tCOkKl0IhhINGYEXmw6HZgE8wnPFFLushKBh97HaaFbdZEuUHSvk0hE1ma9olYsYnRDccoMCF/fgd8xiPnO8l6fnyUvHLWmWo02a1MOQMHCj3Xi9S2+QNpw1Anm8qsXvorZbp8iP27gPlJduQc0wCec6Lj/5pk9ZZrXiVtsueSFVH4liRsnoGbW3KgU2Jldwz8WKv1C3yN5k8AkJduqx+eHmouQOw1ZaUbvuePpEBGugeU8lvHtWi+4tRXY0ksk6K1sQ3BY4v5c0I3Xk2j2oA/E9oc5/SEAmLRPUFevcbNgV2l6Zbhcqxe11IGTrX0WcB9xGXDqxpXh/Mnkhur4lXn5EUR3iRrwzsvPd+6MhvMWxTcENxE9snzL7UB2eq8fbvdtCiTkW8Le7wvMR71vmLEDwpKcTPIuv8Wvbn+SreyZUnhAM7U7hjXVbYmvkVPLL54DmsVkgLbYXd5DerffxqcCJNvk8x6hLu+aiUuFaC4rrLbUnXDH2j7I6TifTuPrZLE7JkK2MPvxUDE7BQ4+J4Y4VqGr4yL2CRz2x7J2LifA8D
 6ynoeS7B
 2TC2TL7sNJMefkvyRt7Dt/YnGfTFMn+a0y3ij3toKKree/YbXP5omK8zpo7x5c736P4Pq6ztXVrgrbpHHkkNKeTjwhxRXc8eQ98y311C/tJRg8OlXW21aaLX2KOUcIMIRqfTTN+4UeI7JJHPaE1QMxIx43UqRsRZ8grk6YkX80bjikd1nH+Q6CiBhbb8EgMRdSUwAno9E5NVCCSkAd0Y0YVmXdQBDGt4B7+h3grMNOhfcx7T9NZemYXgu4ZpyeCX1OHbNSO3s9UaAjBziWb7dn+ez61Ed1jAr0X2fJTYwqwHgEezn9OG9up10Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 10:18=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/20/26 22:18, Barry Song wrote:
> > On Fri, Aug 21, 2026 at 2:23=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 8/19/26 00:59, Barry Song (Xiaomi) wrote:
> >>> This patchset enables the per-CPU LRU cache for large folios with few=
er
> >>> than `FOLIO_BATCH_SIZE` (31) pages. It also limits each per-CPU LRU c=
ache
> >>> to at most `FOLIO_BATCH_SIZE` pages to avoid negatively affecting
> >>> accounting and memory reclamation pressure.
> >>>
> >>> This is particularly beneficial on systems that use relatively small
> >>> large folios. For larger folios, the benefit is likely to be smaller
> >>> because far fewer folios are expected to contend for the LRU cache.
> >>
> >> As raised, there is this problem with collect_longterm_unpinnable_foli=
os()
> >>
> >> (see
> >> https://lore.kernel.org/r/20260806-lru_cache_drain_for_folio-v1-1-c628=
7d295e99@kernel.org
> >> )
> >>
> >> whereby we don't know how many refs we actually hold. Certainly not 1.
> >>
> >> We might have to wait for Hugh's cleanup to handle that cleanly (and a=
void all
> >> the other LRU cache draining).
> >
> > Hi David,
> > Thanks for raising this.
> > Yes, I saw your comment and took a closer look at it. I think the
> > best approach for now is to leave that part untouched until Hugh's
> > patch lands?
>
> I think we should not consider your patch set until Hugh either resolved =
it or
> we have a better way to handle draining. Building on top of this for larg=
e
> folios now just gets painful.

Sure, I=E2=80=99m perfectly fine with this. I swear I asked Hugh whether I
should suspend this job and wait for him, but he didn=E2=80=99t seem to sug=
gest
suspending it. :-) However, I agree that it makes more sense to
prioritize Hugh=E2=80=99s job before this one.

>
> > We might end up doing some extra draining in that case,
> > but that's safe=E2=80=94any value greater than 1 might not be.
>
> We'll unconditionally drain all LRU caches, which is precisely *not* what=
 we
> want to do in the first place. :)

Sure. Maybe because the test case is a kernel build, the
collect_longterm_unpinnable_folios() path is not really a hot path.
But I agree we can probably find some workloads where it is hot.

I=E2=80=99m perfectly fine with putting this large folio lru_cache work on =
hold
and working with Hugh on optimizing those drain paths first. :-)

Best Regards
Barry

