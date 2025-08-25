Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8E3CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 18:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A41F8E0063; Mon, 25 Aug 2025 14:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B978E0038; Mon, 25 Aug 2025 14:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5913B8E0063; Mon, 25 Aug 2025 14:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4463F8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:46:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E73931A0525
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:46:18 +0000 (UTC)
X-FDA: 83816160036.14.9188B6A
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 015A14000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:46:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oCpUZ7gU;
	spf=pass (imf11.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756147577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ux5pqSqp7hAlsWtwMgovrQ8ypY3OKI7YYVef7eLTz/k=;
	b=6iXgHd+sw6nZgUxcEWtxBm3EtvJBnSoKYaCpTbC1BuBlYy+DEEexZH4RsHwKm7mir1gnl4
	BEpxzWwququf9KhV+nYEHxwomk2uBY1WOPRzxgz4usPnF6iBOQulS2xdtSv+DY6r/O0HH6
	SvHF0fUK/ukJ5Agcd0FXw63TWge+bDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756147577; a=rsa-sha256;
	cv=none;
	b=VjmmrHI8rgHuSKxpQyxvr8DcH0sVYa+MdtM+8YiOjzy+jvp6cPa9FHR4YMbd8/xJvjndJI
	QvxDFcdG97Ne6rqEXXLVP76yQV7Gz8U9TkZIOpp77L0E6mCYqJJhsXyFNQIWLoq8JdcTqf
	nurm2hCvlxqaiwOaV+p3HHp/hN2rCRU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oCpUZ7gU;
	spf=pass (imf11.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61c386d3510so1917a12.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756147575; x=1756752375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ux5pqSqp7hAlsWtwMgovrQ8ypY3OKI7YYVef7eLTz/k=;
        b=oCpUZ7gUCZIWt6atnzEXRuuSbm8lJVVjfFsJbRr1Dr0X2emi4FiXXjZhYzc/Lyoc68
         /mY+cJ8R0wmFmvR+Dhj/towum4x2W5TS9ly+Dwo+CpZu4n/DKkxQiGPR2vDMl6u+nXaC
         n5cEz/A4BrnxIf6efhO2T/nyeZq+trmQqI+ZwcDgNFQjSzHE3M29CBWXTc0yoTwFb4j+
         BmVOR+bckXeWL4+VlHFrR3QoPwJK957e76/tSv6hgdlwB30PK7I0h6NjwWFMZxbxLWTR
         JcPK4RUTXoeUT0d0AwG78ItVaCPugPLf7sAgpZDuQeV3gmmKgaJw6YoxxqpstuU8JtPt
         56GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756147575; x=1756752375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ux5pqSqp7hAlsWtwMgovrQ8ypY3OKI7YYVef7eLTz/k=;
        b=tnhuTkVGdXHsGJRx8AsVKo6EBVUepvPWds/boBo46e5CYWzy56YVAGmVwrmH/Z66jK
         1sA2sTSz2CoVkGhYhmHaG3gRhSqn3pPSp5IQnlU3WTgWxjh0CI2+IyPDmdVPC+bHXwqn
         +5XTScHVIqtIAYyKGombskX2bsb5Rj8Gj56cIGSGx6yQSh9tciNc2l8dLIVbEYYs2Mah
         h+rx9REq/qL2QiP4edyCehglVFWY8f/hEzPsEiZfYDMnx0IuymVmFWZ06w/rjf4maLTL
         WsIH4GbcM0fn3fCO6z/ghKVLlq1ApHsgDe/YmKgxRvCJLnjrs5jaNy9QkSxQnF09TKTf
         5NWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY6W/hjqMJ4q4elRgs2TxIkOsEQjbZPn4k2V58bdpBPQRGfkskp9u+CmFus++UaB9DepdJD7iPRA==@kvack.org
X-Gm-Message-State: AOJu0YxSij0s08fWiOum1hFAjIAhlbJhYZeROpAQzo7zkz/+/epo0gkO
	Vk3zGxQNFKZnu8gOMHZ5DE0JefkrjwcM3ghbFD61Qt6sDZOtvx2jqJMpr6/EiEHrsoDZsFPaXK5
	++qp4gign6z4UclHbZV0hjtS1qjgRnQ1w5S1u3N6f
X-Gm-Gg: ASbGnctvrYYP84Q90TmObZ6jttyFrBMHFOqs44nKD+/YUhaT3TtMlUCCrzrMU40gfKN
	MGc3nwOiK7NZtfY0DRmwI87XGaqWJEbNnnUxN9wrLy4p6RfINyTsFcuBdr2ub1XxUN+BlNDKKvN
	zB7++exp0cZA9XNGWxlGoi2As8SJjEDkTCZ6kGg9FR0hf3Nj0Rw4TWTmb/t0YLbGGorhsAfCHE3
	5/dZZ6O54WQT4NAg2ylDplTbIPwZHDxRy5FcV8ku6/7
X-Google-Smtp-Source: AGHT+IFN9zeyztDK/DJYMBoWFLvCgU9cLZ58jhAV5frt/msh+5bP2f1s3CZwTmmQ3aTs+zi1KZm3UYRliuOoFyk86Pk=
X-Received: by 2002:a05:6402:2682:b0:61a:1922:32ac with SMTP id
 4fb4d7f45d1cf-61c8efaf08amr11498a12.0.1756147574955; Mon, 25 Aug 2025
 11:46:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
In-Reply-To: <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Mon, 25 Aug 2025 11:46:02 -0700
X-Gm-Features: Ac12FXyprwIn2v9rZSqr_G5ifLlee_clYu5PD3nxZlWW9msoXVKrPNU4V_wu43k
Message-ID: <CA+EESO5Phk1W64mNm=YG8E1oNEXENP94cd5FUuq0PhcUsOe7+Q@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 015A14000B
X-Stat-Signature: tu5niykiipijdywauhf8dg4dse16ubk1
X-Rspam-User: 
X-HE-Tag: 1756147576-727635
X-HE-Meta: U2FsdGVkX19loTg9bss0Q6x6uL4rXml/mJgcPpoOHD/3cLOGw91+/QGTyA2YXFj0YSETEk7P9nK3NggSXSwjhcGctZ4sx2wnIGCPCy/Ha51zS5xlA1UImZhkK/L7WljNwfB4qQbn8o7iGSoKyMmgIR9H4my3GBjPkabovX9pRfBNKAQH+Ua/6/MImZYHybC1cfE90cD9troABwJMKfopBanIwsEAkehF9N+i5L89AQo+z6i62WmIFsPFm08DCbYDnUg5BC2rZnKW/0Wqyo7TwnRUBMiHz38lP3ScMOa/uLKOe4j67y1jDhmkyiEYvrPGtXGlB4Ou2IpMyvQcGSnb7TyU4UiHuIGRWpgtVdZgnDzlJ4uOo2Yqs3u2APEuLkKCR+KUSGlK7B6MhjYp7XHH6bqSjX8Bo0ePM+DGMHS0jQxpiOt2HPJ43ATW75pvIpdctHg+dyMlyYwQarJsWXPlAM3BM/IMcqNwZg4WIEof9HSmnxC1kUmeShoE2kce6HTYuMOi+J95V9rbn2IYrUvvD1mHWaIJjk0Viwk3+jnovk0OBmzF+gy/Z6+2IAeHv3tTyNL8+ISQwbaB3OAAGgBhzaaQ2TUszgSvE5kn2CS8tDC4gOWVXBkhm99oBkHiCpQ7DoJV0RN4CpdmLB3kLzHOGZrSxDzKG4KBqIyJ22QxB6iJSZ0vlmiWJAinDvwjhctPUY11bXeqOnf8YDv4wFwNTE0rgESn/aPBsT5YsP1g6hVOBFyaurlJ9eM4hVEJgAPU5LK5CEYu3JGgiAhgwr0Kl28HFYyZ32G/oelX64n6U8tXuO8w0iu56G7MEEZ8OvhJZE3RE0JxBgp0KPrThRU5b46Ydv/82+NGa/gt8fTH2mFHLNGcrIIosKGxgflRSErfLOSxAlZ9PRHog6T4x70R8IyemZ9YlaZTxT3U9wle9475jLqNpN42b0Th8Y0f5z01JcD7bC9STSTpSqvZd55
 KB4xRh3m
 5pAMgyqfbQISwMVHaUjKcNpFrubYZfGMD09HVyPNTcZpcJvgPlX/ikmFXyubU5Hvhm798ZzOjq63IYktbGOHZGih7sRPiQWIaV+lWmoI8asZOGduAPoAycM4AGQPCk7+1FdQvTDy6kjScpsf5UzZIACUc2sDiCM4RN16//maTCu70/1cigfZpSNrJDbY4HqiVzH+oXIBTubKHWqCOwNUfSx5j/W92X1b9Zbg4w9kZUYKqM/PIEUWWvlFmUNhK3uBEAUhGDcsKOvYTUos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 8:19=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 22.08.25 19:29, Lokesh Gidra wrote:
> > Hi all,
> >
> > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > non-ksm anon folios. This necessitates serialization through anon_vma
> > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > involved in rmap_walk()) are to be updated. This hurts scalability due
> > to coarse granularity of the lock. For instance, when multiple threads
> > invoke userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distinct=
 pages
> > from the same src VMA, they all contend for the corresponding
> > anon_vma=E2=80=99s lock. Field traces for arm64 android devices reveal =
over
> > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > user interactions.
> >
> > Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> > folio_referenced() is the most critical (others are
> > page_idle_clear_pte_refs(), damon_folio_young(), and
> > damon_folio_mkold()). The relevant code in folio_referenced() is:
> >
> > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> >          we_locked =3D folio_trylock(folio);
> >          if (!we_locked)
> >                  return 1;
> > }
> >
> > It=E2=80=99s unclear why locking anon_vma exclusively (when updating
> > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > with folio locked. It=E2=80=99s in the reclaim path, so should not be a
> > critical path that necessitates some special treatment, unless I=E2=80=
=99m
> > missing something.
> >
> > Therefore, I propose simplifying the locking mechanism by ensuring the
> > folio is locked before calling rmap_walk().
>
> Essentially, what you mean is roughly:
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 34333ae3bd80f..0800e73c0796e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1005,7 +1005,7 @@ int folio_referenced(struct folio *folio, int is_lo=
cked,
>          if (!folio_raw_mapping(folio))
>                  return 0;
>
> -       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(foli=
o))) {
> +       if (!is_locked) {
>                  we_locked =3D folio_trylock(folio);
>                  if (!we_locked)
>                          return 1;
>
>
> The downside of that change is that ordinary (!ksm) folios will observe b=
eing locked
> when we are actually only trying to asses if they were referenced.
>
> Does it matter?
>
> I can only speculate that it might have been very relevant before
> 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_an=
on_exclusive").
>
> Essentially any R/O fault would have resulted in us copying the page, sim=
ply because
> there is concurrent folio_referenced() happening.
>
> Before 09854ba94c6a ("mm: do_wp_page() simplification") that wasn't an is=
sue, but
> it would have meant that the write fault would be stuck until folio_refer=
enced()
> would be done, which is also suboptimal.
>
> So likely, avoiding grabbing the folio lock was beneficial.
>
>
> Today, this would only affect R/O pages after fork (PageAnonExclusive not=
 set).
>
>
> Staring at shrink_active_list()->folio_referenced(), we isolate the folio=
 first
> (grabbing reference+clearing LRU), so do_wp_page()->wp_can_reuse_anon_fol=
io()
> would already refuse to reuse immediately, because it would spot a raised=
 reference.
> The folio lock does not make a difference anymore.
>
>
> Is there any other anon-specific (!ksm) folio locking? Nothing exciting c=
omes to mind,
> except maybe some folio splitting or khugepaged that maybe would have to =
wait.
>
> But khugepaged would already also fail to isolate these folios, so probab=
ly it's not that
> relevant anymore ...

Thanks so much for your thorough analysis. Very useful!

For folio splitting, it seems anon_vma lock is acquired exclusively,
so it serializes against folio_referenced() anyways.
>
> --
> Cheers
>
> David / dhildenb
>

