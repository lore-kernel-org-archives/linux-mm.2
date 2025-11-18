Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2423CCEE350
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0B16B0031; Tue, 18 Nov 2025 14:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0746B0062; Tue, 18 Nov 2025 14:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690456B007B; Tue, 18 Nov 2025 14:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52A5C6B0031
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:26:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8C1756838
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:26:42 +0000 (UTC)
X-FDA: 84124709844.28.C9616D1
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id C9386100007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:26:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QZT3lVSJ;
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763494000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GA+zLGNQzKnu3qorDuQDpitiUTXEO0YlCfq5W/VFuZU=;
	b=xzjDdYOcMfeUwVev1L8J7B2ANPUAPTAeR2LcP4o20f1u+feCIkuBMAkaI3/qvEpY8FetXu
	MFNNj1TbOR/eRKet0L9K0Tzqps+JBCiICcarwnF2fOy/UddiZZ1VicuwlN19zEGy6Ucxmp
	Wyl1XkmLTx+mpqX9QL1UCck91nviOpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763494000; a=rsa-sha256;
	cv=none;
	b=sWJky7mPg3xjckeEEqvLK9a/MbsXAGZQ1E4UPlvSvtB4rjw0TUTIBnijS7iPr4Y2H0HrfA
	smrXxuFWW5PZQywvLRu3Xw1CcXm6gAtGjJztT56BYa6jiuI6rC/0P5haSkCCaAFp/E6MjI
	s8VbFEBxYmf2uE6u31kTIHlbDq43s8k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QZT3lVSJ;
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779a4fc916so9325e9.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763493999; x=1764098799; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GA+zLGNQzKnu3qorDuQDpitiUTXEO0YlCfq5W/VFuZU=;
        b=QZT3lVSJnyOZNjXYE7daFDRXHSl4Rba35xXOoFd/XhFD2leb1OOeeI/WWOWgdRNU84
         ZBpnbTw7S6kNYaO2x9PiRXbRjUx3kk+aJKpfgB67bbG98cxy9ItWwMtESgcPVK5FSGEJ
         LJPH4+R66SZHojDWhC0aBbeHjn30VCd+3nkfFuwLCC2+KrkXmNGdZWMDl0lLhUUgYskv
         LqkUon3sxn4BwqMuBzOaehVSJrXbvxRmkioXGBVc1CiLrmqRkP0B+X8WYBS9SL7amaoa
         2uezWxxqso++edBF1jE/aTt69QuPM4aECgpXBpPzH6z4PEhBpxUlRPx59XgJnmh1uv/W
         VP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763493999; x=1764098799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GA+zLGNQzKnu3qorDuQDpitiUTXEO0YlCfq5W/VFuZU=;
        b=ftUfYfbls9fdWLfiAVTTKKImj248iUEy2JycFA+LFSiZvdHr2aZCDDx4VZMQ/mrqDs
         87aMu6dh317aWPoxx/b55iIuLI0knKiYp68BAAc2x4A3tQ28DYs/PJds8U/5lXFo/mbR
         DD7aQISEJvzxw+rbaE7skfAsD289roimoidFCzoHOGYi/jA6NMXJbygrdfse5uwpdED6
         1R4ffRiUM/Ve+FopEJ6K6k5dt74IEAa7J3lGBR3MFMyKqbsONJWzwd0BSFBmaMDl1324
         GkVpWg70EhDi4GKXnA7k+H6gExfT6+3pxTrGYocLKBwgEc47/TbPU0lYYQ3+MiUjENmv
         nP9A==
X-Forwarded-Encrypted: i=1; AJvYcCUvxmRvvA8tkE1pY/YetiF0by25Vsv/8+PZ7kXjDjiYfkpb+IMAHEIOor74OpdB2Ye4wLv77MbJXw==@kvack.org
X-Gm-Message-State: AOJu0YyL7qZFe1Kpm74Z02sTdZpNgHkZjWiAdnc5qo7vWYJz4gbJgwSh
	6qn4FVaN4+M7kxSyPtjAj/fk5sXzZv8HCfeQWnt/xy6YAi49KvhSwCjd+wTIJ+Txj1xiBJZvLT7
	GzaYrBu7baA/GrdrrIRWOyXUS7iCVnMpNQEFK6Qn9
X-Gm-Gg: ASbGncsIqGEI4QvNrJmO8tdTuL0ZIAd4nxdMfwK/WHOaGLA4Fp1uU0lw8FB2/I+rhnQ
	A8ggqDD41mwSfGTdiLQJdDvk8vR3cjO7Fyxhy1tUXqIwYO6mxbpIUTxJcYTW8YcbzdWi8MkiULJ
	MGdCON98LEIAZD/RfnGjTWv/4dtHzjeonthWkI/x3aOAE9N4pBt0qj0LzQojTXtJPXD/39K5Rtp
	nCc1CR66ltrmkraV/SSkaiNY3CPcQecJY5JDeY6MnGSk/O0Y7mlBJwxP3ZQyoj0o3lx0+SB5VYJ
	5NxwLQmaF0TWXwg4onf457+TiA==
X-Google-Smtp-Source: AGHT+IEysZiub5Ivc8ctKaVMpHOPlPVzbnxwgaM/P+IFAtMIvhAI17rSqBiFsAeJl5PaeklqKb5lCjoXEtjGGtmWDSc=
X-Received: by 2002:a05:600d:112:b0:477:255c:bea8 with SMTP id
 5b1f17b1804b1-477b1243673mr111675e9.7.1763493998762; Tue, 18 Nov 2025
 11:26:38 -0800 (PST)
MIME-Version: 1.0
References: <20251116014721.1561456-1-jiaqiyan@google.com> <20251116014721.1561456-2-jiaqiyan@google.com>
 <aRm6shtKizyrq_TA@casper.infradead.org> <aRqTLmJBuvBcLYMx@hyeyoo>
 <aRsmaIfCAGy-DRcx@casper.infradead.org> <CACw3F50E=AZtgfoExCA-nwS6=NYdFFWpf6+GBUYrWiJOz4xwaw@mail.gmail.com>
 <aRxIP7StvLCh-dc2@hyeyoo>
In-Reply-To: <aRxIP7StvLCh-dc2@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 18 Nov 2025 11:26:27 -0800
X-Gm-Features: AWmQ_bkGjatHcvMvfv8N94vNdxa0KML4Ogn8iSmfd4AKJOPSCC92qeDqRDaPVwg
Message-ID: <CACw3F53Rck2Bf_C45Uk=A1NJ4zB1B0R1+GqvkNxsz3h3mDx-pQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce uniform_split_unmapped_folio_to_zero_order
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, ziy@nvidia.com, david@redhat.com, 
	Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com, linmiaohe@huawei.com, 
	lorenzo.stoakes@oracle.com, william.roche@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rqxkenshgmfayopged6ibzeox5y5bgf8
X-Rspam-User: 
X-Rspamd-Queue-Id: C9386100007
X-Rspamd-Server: rspam01
X-HE-Tag: 1763494000-304854
X-HE-Meta: U2FsdGVkX18EOySrwX7+KX+b2SKWa9KQrxsRuJcyKl+Tdm2KzxPyu92CgbtUHM9nOXbigZD7iY2QO04jPUmTWm8O2kjyyJX5qe9DwmB1qAe2MSt7h+mHOIfCFTbqbkR1j7yaDJ16PbzM+Ba5Je3n1zeOqTUc8d9Ld3cHXchnAEEWc9vd7yz0Pw1BGxSLmYlW2TQVFU5DMdJrE3fHqkWOTxbSoEn63hvJoYycisGGsSts45eulkn2pugaNtH4XsP4owzN6n/oibg8ViI0Gy4zzjBPCM9E8hxzmDtKwjuosg9DRF2obQ4+6EgkyLmj2ld04gxpPWo7Ih5DuDG3htombsNMYEysngiwZ0AU+u1ELCnSeMPSKCgoV/sAlHEWMELrot5Fie1mlsUUk1jkGBbVg5jin5b0HLjirJTpdcZFfLhLCBRJlSrowoPN+M3WlLfsJKcOdWpipcZBpKoqYMq8DgL/7NWDXqAr94HvvA/klqpXO45j7SAEStomjrGYuinm2OXt7705g2hoYv+p9Pw4Uv2C0MfTKah3+gkcTCsvUYgCsnynUx7jCG6ovqYCMU5FPgsNn+JO7d0fuogBeinNobLWPEAYaQLezSs6b8r5gtvt941gWGczVz/C19LgEfeGJp8ynJ+cinSfatIoge/1tF4mCIhbDjUXG+9wsBmXG2emtCncfXZ3pxDP04bIH1wq8urFwNw+ESFg8xdKxFM71VUV1laUQaIekR9T+HtCZ+NNOGt8Le3+A50YTrEStZwmxEGqjq60ysdZTvzSV61vxzH/q1eQ8REgMbmWmdeB5l359nCtv9WCyLdW6/mPmrZx4syfy+54JzhFirsG0kvSvUZFjV3l7mHXRZ8KIABLl9H9xQyEl0+E0QveftkFloOA2VKCPl4tpJYCYbjLAaglJ3ezHL5x0Ly8IFSo0GLDxp5INJa9lZVlzVXazBQoIwrCIaokAtxj1eQYAhBopsR
 zpg1BL0y
 duCHZ4BH3CInpVZwH/JElXTNA572pmVmFB4pM2IeAldh1AHZevxlZ4SEF/r+T/6XhYEc2wjIIo1+APZMN/7ZFxZziZyqa/Piwf8QMGJxL1hBmYfcDYpx+cdzLIprF8AAHqeFRo/i0yIQsrVPGkLz7AN3Ygl0n2leJKbsIUFeH+OrvYiEungxS1oMvrpArUaPC8WkY24s8O+paQQiiKw3JX2sCsM7xWn2egMNf9mL5f0mTln5FPjid72JhlFEY91moTpLJKF7ccv9jU4tvrXhtWzsfRpcudUZ50QMeLEBW0gtreRbSLa5m4KK4jsHH1Y4JjSHPuYrZynQFXpmYI6EU+kuP+LAvNzIT66br7mJuRVGKAaSGlZWCPhRWDVT6a3O5LDTFNdCmFFNP1os=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 2:20=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Nov 17, 2025 at 10:24:27PM -0800, Jiaqi Yan wrote:
> > On Mon, Nov 17, 2025 at 5:43=E2=80=AFAM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Mon, Nov 17, 2025 at 12:15:23PM +0900, Harry Yoo wrote:
> > > > On Sun, Nov 16, 2025 at 11:51:14AM +0000, Matthew Wilcox wrote:
> > > > > But since we're only doing this on free, we won't need to do foli=
o
> > > > > allocations at all; we'll just be able to release the good pages =
to the
> > > > > page allocator and sequester the hwpoison pages.
> > > >
> > > > [+Cc PAGE ALLOCATOR folks]
> > > >
> > > > So we need an interface to free only healthy portion of a hwpoison =
folio.
> >
> > +1, with some of my own thoughts below.
> >
> > > >
> > > > I think a proper approach to this should be to "free a hwpoison fol=
io
> > > > just like freeing a normal folio via folio_put() or free_frozen_pag=
es(),
> > > > then the page allocator will add only healthy pages to the freelist=
 and
> > > > isolate the hwpoison pages". Oherwise we'll end up open coding a lo=
t,
> > > > which is too fragile.
> > >
> > > Yes, I think it should be handled by the page allocator.  There may b=
e
> >
> > I agree with Matthew, Harry, and David. The page allocator seems best
> > suited to handle HWPoison subpages without any new folio allocations.
>
> Sorry I should have been clearer. I don't think adding an **explicit**
> interface to free an hwpoison folio is worth; instead implicitly
> handling during freeing of a folio seems more feasible.

That's fine with me, just more to be taken care of by page allocator.

>
> > > some complexity to this that I've missed, eg if hugetlb wants to reta=
in
> > > the good 2MB chunks of a 1GB allocation.  I'm not sure that's a usefu=
l
> > > thing to do or not.
> > >
> > > > In fact, that can be done by teaching free_pages_prepare() how to h=
andle
> > > > the case where one or more subpages of a folio are hwpoison pages.
> > > >
> > > > How this should be implemented in the page allocator in memdescs wo=
rld?
> > > > Hmm, we'll want to do some kind of non-uniform split, without actua=
lly
> > > > splitting the folio but allocating struct buddy?
> > >
> > > Let me sketch that out, realising that it's subject to change.
> > >
> > > A page in buddy state can't need a memdesc allocated.  Otherwise we'r=
e
> > > allocating memory to free memory, and that way lies madness.  We can'=
t
> > > do the hack of "embed struct buddy in the page that we're freeing"
> > > because HIGHMEM.  So we'll never shrink struct page smaller than stru=
ct
> > > buddy (which is fine because I've laid out how to get to a 64 bit str=
uct
> > > buddy, and we're probably two years from getting there anyway).
> > >
> > > My design for handling hwpoison is that we do allocate a struct hwpoi=
son
> > > for a page.  It looks like this (for now, in my head):
> > >
> > > struct hwpoison {
> > >         memdesc_t original;
> > >         ... other things ...
> > > };
> > >
> > > So we can replace the memdesc in a page with a hwpoison memdesc when =
we
> > > encounter the error.  We still need a folio flag to indicate that "th=
is
> > > folio contains a page with hwpoison".  I haven't put much thought yet
> > > into interaction with HUGETLB_PAGE_OPTIMIZE_VMEMMAP; maybe "other thi=
ngs"
> > > includes an index of where the actually poisoned page is in the folio=
,
> > > so it doesn't matter if the pages alias with each other as we can rec=
over
> > > the information when it becomes useful to do so.
> > >
> > > > But... for now I think hiding this complexity inside the page alloc=
ator
> > > > is good enough. For now this would just mean splitting a frozen pag=
e
> >
> > I want to add one more thing. For HugeTLB, kernel clears the HWPoison
> > flag on the folio and move it to every raw pages in raw_hwp_page list
> > (see folio_clear_hugetlb_hwpoison). So page allocator has no hint that
> > some pages passed into free_frozen_pages has HWPoison. It has to
> > traverse 2^order pages to tell, if I am not mistaken, which goes
> > against the past effort to reduce sanity checks. I believe this is one
> > reason I choosed to handle the problem in hugetlb / memory-failure.
>
> I think we can skip calling folio_clear_hugetlb_hwpoison() and teach the

Nit: also skip folio_free_raw_hwp so the hugetlb-specific llist
containing the raw pages and owned by memory-failure is preserved? And
expect the page allocator to use it for whatever purpose then free the
llist? Doesn't seem to follow the correct ownership rule.

> buddy allocator to handle this. free_pages_prepare() already handles
> (PageHWPoison(page) && !order) case, we just need to extend that to
> support hugetlb folios as well.
>
> > For the new interface Harry requested, is it the caller's
> > responsibility to ensure that the folio contains HWPoison pages (to be
> > even better, maybe point out the exact ones?), so that page allocator
> > at least doesn't waste cycles to search non-exist HWPoison in the set
> > of pages?
>
> With implicit handling it would be the page allocator's responsibility
> to check and handle hwpoison hugetlb folios.

Does this mean we must bake hugetlb-specific logic in the page
allocator's freeing path? AFAICT today the contract in
free_frozen_page doesn't contain much hugetlb info.

I saw there is already some hugetlb-specific logic in page_alloc.c,
but perhaps not valid for adding more.

>
> > Or caller and page allocator need to agree on some contract? Say
> > caller has to set has_hwpoisoned flag in non-zero order folio to free.
> > This allows the old interface free_frozen_pages an easy way using the
> > has_hwpoison flag from the second page. I know has_hwpoison is "#if
> > defined" on THP and using it for hugetlb probably is not very clean,
> > but are there other concerns?
>
> As you mentioned has_hwpoisoned is used for THPs and for a hugetlb
> folio. But for a hugetlb folio folio_test_hwpoison() returns true
> if it has at least one hwpoison pages (assuming that we don't clear it
> before freeing).
>
> So in free_pages_prepare():
>
> if (folio_test_hugetlb(folio) && folio_test_hwpoison(folio)) {
>   /*
>    * Handle hwpoison hugetlb folios; transfer the error information
>    * to individual pages, clear hwpoison flag of the folio,
>    * perform non-uniform split on the frozen folio.
>    */
> } else if (PageHWPoison(page) && !order) {
>   /* We already handle this in the allocator. */
> }
>
> This would be sufficient?

Wouldn't this confuse the page allocator into thinking the healthy
head page is HWPoison (when it actually isn't)? I thought that was one
of the reasons has_hwpoison exists.

>
> Or do we want to handle THPs as well, in case of split failure in
> memory_failure()? if so we need to handle folio_test_has_hwpoisoned()
> case as well...

Yeah, I think this is another good use case for our request to page allocat=
or.

>
> > > > inside the page allocator (probably non-uniform?). We can later re-=
implement
> > > > this to provide better support for memdescs.
> > >
> > > Yes, I like this approach.  But then I'm not the page allocator
> > > maintainer ;-)
> >
> > If page allocator maintainers can weigh in here, that will be very help=
ful!
>
> Yeah, I'm not a maintainer either ;) it'll be great to get opinions
> from page allocator folks!
>
> --
> Cheers,
> Harry / Hyeonggon

