Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E02ACA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E726B0012; Fri, 12 Sep 2025 20:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5A56B0022; Fri, 12 Sep 2025 20:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BC26B0023; Fri, 12 Sep 2025 20:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3EB6B0012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:18:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D957E873C9
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:18:42 +0000 (UTC)
X-FDA: 83882316084.26.877DBCF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7ABA81C0006
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:18:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZKvfCmJp;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757722720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4ajafdB1+Zc4Os2K0LLf6LEAhTUjLOoNJPPBfIa9aU=;
	b=sIwbK7Mq7/0wd6my/A34d7hpEkSP2jngMPUVpdURCvxm7zK3EWhEXbftmVevK60Z6inzFA
	WxDHPfZHp2kVnc6yYj6ot/x6CJpyTclmvwNuzktRL+UOzjR3nXzMwDxwLzSt+ZeWAsxUwG
	RyBAGB/cVc5gdig8hyrv3r32NAwMHvU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZKvfCmJp;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757722720; a=rsa-sha256;
	cv=none;
	b=1Hba9jhKZUfg+axooKbpDUJBPGMFas1LXhAJ/t2CFoznkTfVzuMILnbDUaurI/pXihb2LS
	cxpdXWxKd4bcBXQ/cQ+0GLAGKQiNkIKWAVsCulLW64WXXz6gJpTBAqA4mFoQ0xHWWSNyrm
	E/RbFBXQuuV7WZ4u4a+Tun05opK7rWY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757722719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4ajafdB1+Zc4Os2K0LLf6LEAhTUjLOoNJPPBfIa9aU=;
	b=ZKvfCmJpz2oatio5+BcPv5cMrcBuk9ZNvNL026FPKNuOIGg18PeTvEn0RAMn+PKK+EDrYN
	vVjfgWOUwbV3GfXT5J10RUiSfW0OITbMYpgZr/4t1RX8QbNTFz3ffhlm1I0nXvHW2op9VJ
	eyf+Zv//vzzmsj+rIfwMLtwHwYinzI0=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-r2MQwv0qOzSYqurj5MFWZQ-1; Fri, 12 Sep 2025 20:18:35 -0400
X-MC-Unique: r2MQwv0qOzSYqurj5MFWZQ-1
X-Mimecast-MFC-AGG-ID: r2MQwv0qOzSYqurj5MFWZQ_1757722715
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-731572565c3so10059987b3.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722715; x=1758327515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4ajafdB1+Zc4Os2K0LLf6LEAhTUjLOoNJPPBfIa9aU=;
        b=xHUBFYG38QwyGxJb1WQFm7l8xlrrORe+ftd4Tv8izQoVkPrIcvg6XxzUDX8BxZ6H3N
         i5gd2xprinwJfkle/B99enCv23HGuHyZ5pA69s1FL2e/I3xTurfJDklUuIRDT4Extfas
         1CBhqqhHeb2xfZix35BTUbXznMwjU2UUNHbJA5Mys2Y+OWSGBMlUIA/07tKXdEfbKiGF
         4tbvXmuU7gdXAuJLohcIt2mRguF+pYGhE/mxhBEGO6Qckng5XGugQ2n3AvIQRm0IZ5z0
         Mj6fVpIw69lxLjJv0jGyMicg3nz7PU7NiH722UrRUsq6SEjAOar62O35QCGyj4MWr/6A
         t29w==
X-Forwarded-Encrypted: i=1; AJvYcCWcXcMpRBnNMR83y+9pmt1qKXCkX2443QFzJ5LzIbBT3+MubXOuYZsV6LWbpMiferATQbC6uuvVUQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2andJQDSN3w2jrYPTPHKKY3u8rCp44s9CAY08v7MeVvSEYWdx
	nCVZy52dMbWBNTAqww4CHwZckGk3ZAbW2/lhuPm4YIh9KkPpBnuZPzpFrd7mcekGZv7qwBOCxaT
	mYM1JZQ3Mrr14kVSyDMmG3aY7I4+6H/rMqjg+sAVg1wa19ZOjL380vftX/3zwNJUl0qZXS15hWP
	ol8crdINYV4IdJ3/a6egNhCBAx/GY=
X-Gm-Gg: ASbGncu4PrSyiWzT77cWRfmhEjud7Tpg0WrqbjL7tcW9neuGsjk7dUyK0cZdP0iA+50
	MsOCIQMjHNdYd7Yir8RIuH7rYFm5ZWR6cSzQ7kClcnxgDbO60Wvw4y/qL4DEMzRZDB+cvQ2jl7f
	2l0JuDSKMEpT58HKdbYCUUHTzNW1kONdn8YrU=
X-Received: by 2002:a05:690c:9688:b0:721:e87c:8c33 with SMTP id 00721157ae682-73064b0d05fmr42486077b3.42.1757722714767;
        Fri, 12 Sep 2025 17:18:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbHcwYvFm4L2fdbefOJomRceVwWpbQwHhmonPQcrjsF8ec8coXUMU+h3EdJ4sn6nutD1Tcv7kHs6OwIFQ+2cI=
X-Received: by 2002:a05:690c:9688:b0:721:e87c:8c33 with SMTP id
 00721157ae682-73064b0d05fmr42485567b3.42.1757722714282; Fri, 12 Sep 2025
 17:18:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250912032810.197475-1-npache@redhat.com> <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com> <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com> <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com> <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
In-Reply-To: <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Fri, 12 Sep 2025 18:18:08 -0600
X-Gm-Features: Ac12FXy0N5FtwbsBO2SqhUxuddBI79Z6-L0KsGN5hICFyqJ2VbVlnALj3j-diZ0
Message-ID: <CAA1CXcCwsQ4U95jEjvN63+915=8dfoTQboHnWRF=SApUssGMww@mail.gmail.com>
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c-JLPDHxIj5WCRlwSxzuYTe_SN9qpbdjsz3HdrY7xmc_1757722715
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7ABA81C0006
X-Stat-Signature: nucs178wf7n91jjpgx8axeqob1jxx8uy
X-HE-Tag: 1757722720-122619
X-HE-Meta: U2FsdGVkX19hYn/BmVgHYLO72icGT74JzQgYwozS2SsN9TZCxN5zhirFOItvLZri+0Wk3A1fvSIUvleW5eN8pchRKkJmHNpyirPpGlCYFOkLvt0khhjTbmEXsqPqMtzNNC1/ShndF9rOwILbPAznjQj+0nuHbaNJmCgV4GeMg1Db6oWzxjY35BjoAC+/1RgT+GFU9jD8vhplymL9fy6pXK3vQqL0LhDAYdhBooJO1N9lLIOTWWclmWIE/ZTx9pYjtR8ZvKAaGGGH1ohbvQvmG94mEYvi8BUhUf6vm1fSpcIczBuix8lA4TSb4zh4bN7h/B8t/Q9g3ncp+Av0+VhmfnSN6B+UEQ2OH+aA3z4iyXG492TFyyHVhgl9MxLcZSpClanTyGSICx77V8NfY5sVrWJAuEwz2YaZXjJw/pozmmrZGl/Y+nFHTzG1aW+ewdC1E+mCiLom/DWsp/F6J5Raox8Q54wWZKCdsIjYtcltAKL6SYvvd4HpWfdAtL0nXddMbcFI1ybJCR6aM70q1H4cQ+NOCcy4wcc0FLGjnhIqvz49O1e4qjB5kjTjH0qwatC3xv+clL4rtsy74BkjzaqDwDsnskNZ/DR/MVPnD7TR5kc1zbfNcwsHOyjexp4ruTPeCYg7XUlfjhqQVwTIA+xuBOz03F0sS2d7URtgK9C8HdDKSLV64SvsyNnXI86qVSB27VwRo8RcAO+KME6W52rcgIgPHz/YulF9EHS9cLU1dJdiSX2zmdHtg/ncGesywHlvsXNGqKry4kb3MZE6ycZajb02rkOQkcz4tS3sCxdrrwAzNM7v9+z442KNKrDJnKpKgtGXNsc/OUlNIsnH77xUaEBxK9+rP/56wLpOgeWdvo2oayawOc/cPPEKvxtHcCH0Gj5DxDxB6Sldl3W4zJvB++FJ99DD+MkzrP3Vh5yOArZqvXkptzioktiZhhL9K9LftS3inclJAWgNdbsHAOW
 eTYrLAPO
 U9lHGjAE7LRRmas4iT2gXkVsdtVKXPADuSkx3/AnbW33/G2GCe6CN6t6w87Qci9k1x8SFZOqQawMFQWfn4unQODsGCZIFpRdcqcRHGMXYTflKOvsXWX6rqJ6Fp8LWXe/zs0aKtlJJlzJTNxJh2GsfZ6sXmXlr31etwmRvh0qhQBlt65gaxbhsQNFFXESQsKIfvafUWRS+ueURunxPkxpHm1mFLJYckPN/AQsxgL1D2d5Sa5ibljbPtLe/VAYhWUn5efe4zkO8AOzAotqLQRaW56OA3nGveifnpPbsu2p9c2jQ9UPcdvi/ILN88vILUGg/4gQpf16hxrdiFyh9oupEfDMcXrxkqpy5NyMg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 11:53=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 12.09.25 17:51, Lorenzo Stoakes wrote:
> > On Fri, Sep 12, 2025 at 05:45:26PM +0200, David Hildenbrand wrote:
> >> On 12.09.25 17:41, Kiryl Shutsemau wrote:
> >>> On Fri, Sep 12, 2025 at 04:56:47PM +0200, David Hildenbrand wrote:
> >>>> On 12.09.25 16:35, Kiryl Shutsemau wrote:
> >>>>> On Fri, Sep 12, 2025 at 04:28:09PM +0200, David Hildenbrand wrote:
> >>>>>> On 12.09.25 15:47, David Hildenbrand wrote:
> >>>>>>> On 12.09.25 14:19, Kiryl Shutsemau wrote:
> >>>>>>>> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> >>>>>>>>> The following series provides khugepaged with the capability to=
 collapse
> >>>>>>>>> anonymous memory regions to mTHPs.
> >>>>>>>>>
> >>>>>>>>> To achieve this we generalize the khugepaged functions to no lo=
nger depend
> >>>>>>>>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to trac=
k individual
> >>>>>>>>> pages that are occupied (!none/zero). After the PMD scan is don=
e, we do
> >>>>>>>>> binary recursion on the bitmap to find the optimal mTHP sizes f=
or the PMD
> >>>>>>>>> range. The restriction on max_ptes_none is removed during the s=
can, to make
> >>>>>>>>> sure we account for the whole PMD range. When no mTHP size is e=
nabled, the
> >>>>>>>>> legacy behavior of khugepaged is maintained. max_ptes_none will=
 be scaled
> >>>>>>>>> by the attempted collapse order to determine how full a mTHP mu=
st be to be
> >>>>>>>>> eligible for the collapse to occur. If a mTHP collapse is attem=
pted, but
> >>>>>>>>> contains swapped out, or shared pages, we don't perform the col=
lapse. It is
> >>>>>>>>> now also possible to collapse to mTHPs without requiring the PM=
D THP size
> >>>>>>>>> to be enabled.
> >>>>>>>>>
> >>>>>>>>> When enabling (m)THP sizes, if max_ptes_none >=3D HPAGE_PMD_NR/=
2 (255 on
> >>>>>>>>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/=
2 - 1 for
> >>>>>>>>> mTHP collapses to prevent collapse "creep" behavior. This preve=
nts
> >>>>>>>>> constantly promoting mTHPs to the next available size, which wo=
uld occur
> >>>>>>>>> because a collapse introduces more non-zero pages that would sa=
tisfy the
> >>>>>>>>> promotion condition on subsequent scans.
> >>>>>>>>
> >>>>>>>> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> >>>>>>>> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> >>>>>>>
> >>>>>>> BTW, I thought further about this and I agree: if we count zero-f=
illed
> >>>>>>> pages towards none_or_zero one we can avoid the "creep" problem.
> >>>>>>>
> >>>>>>> The scanning-for-zero part is rather nasty, though.
> >>>>>>
> >>>>>> Aaand, thinking again from the other direction, this would mean th=
at just
> >>>>>> because pages became zero after some time that we would no longer =
collapse
> >>>>>> because none_or_zero would then be higher. Hm ....
> >>>>>>
> >>>>>> How I hate all of this so very very much :)
> >>>>>
> >>>>> This is not new. Shrinker has the same problem: it cannot distingui=
sh
> >>>>> between hot 4k that happened to be zero from the 4k that is there j=
ust
> >>>>> because of we faulted in 2M a time.
> >>>>
> >>>> Right. And so far that problem is isolated to the shrinker.
> >>>>
> >>>> To me so far "none_or_zero" really meant "will I consume more memory=
 when
> >>>> collapsing". That's not true for zero-filled pages, obviously.
> >>>
> >>> Well, KSM can reclaim these zero-filled memory until we collapse it.
> >>
> >> KSM is used so rarely (for good reasons) that I would never ever build=
 an
> >> argument based on its existence :P
> >>
> >> But yes: during the very first shrinker discussion I raised that KSM c=
an do
> >> the same thing. Obviously that was not good enough.
> >>
> >> --
> >> Cheers
> >>
> >> David / dhildenb
> >>
> >
> > With all this stuff said, do we have an actual plan for what we intend =
to do
> > _now_?
>
> Oh no, no I have to use my brain and it's Friday evening.
>
> >
> > As Nico has implemented a basic solution here that we all seem to agree=
 is not
> > what we want.
> >
> > Without needing special new hardware or major reworks, what would this =
parameter
> > look like?
> >
> > What would the heuristics be? What about the eagerness scales?
> >
> > I'm but a simple kernel developer,
>
> :)
>
> and interested in simple pragmatic stuff :)
> > do you have a plan right now David?
>
> Ehm, if you ask me that way ...
>
> >
> > Maybe we can start with something simple like a rough percentage per ea=
gerness
> > entry that then gets scaled based on utilisation?
>
> ... I think we should probably:
>
> 1) Start with something very simple for mTHP that doesn't lock us into an=
y particular direction.
>
> 2) Add an "eagerness" parameter with fixed scale and use that for mTHP as=
 well
I think the best design is to map to different max_ptes_none values,
0-5: 0,32,64,128,255,511
>
> 3) Improve that "eagerness" algorithm using a dynamic scale or #whatever
>
> 4) Solve world peace and world hunger
>
> 5) Connect it all to memory pressure / reclaim / shrinker / heuristics / =
hw hotness / #whatever
>
>
> I maintain my initial position that just using
>
> max_ptes_none =3D=3D 511 -> collapse mTHP always
> max_ptes_none !=3D 511 -> collapse mTHP only if we all PTEs are non-none/=
zero
I think we should implement the eagerness toggle, and map it to
different max_pte_none values like I described above. This fits nicely
in the current collapse_max_ptes_none() function.
If we go with just 0/511 without the eagerness changes, we will be
removing configurability, only to reintroduce it again. When we can
leave the configurability from the start.
>
> As a starting point is probably simple and best, and likely leaves room f=
or any
> changes later.
>
>
> Of course, we could do what Nico is proposing here, as 1) and change it a=
ll later.
I dont think this is much different than the eagerness approach; it
just compresses the max_ptes_none from 0-512 to 0-5/10.

I will wait for your RFC for the next version.

Does your implementation/thoughts align with what I describe above?
>
> It's just when it comes to documenting all that stuff in patch #15 that I=
 feel like
> "alright, we shouldn't be doing it longterm like that, so let's not make =
anybody
> depend on any weird behavior here by over-domenting it".
>
> I mean
>
> "
> +To prevent "creeping" behavior where collapses continuously promote to l=
arger
> +orders, if max_ptes_none >=3D HPAGE_PMD_NR/2 (255 on 4K page size), it i=
s
> +capped to HPAGE_PMD_NR/2 - 1 for mTHP collapses. This is due to the fact
> +that introducing more than half of the pages to be non-zero it will alwa=
ys
> +satisfy the eligibility check on the next scan and the region will be co=
llapse.
> "
>
> Is just way, way to detailed.
>
> I would just say "The kernel might decide to use a more conservative appr=
oach
> when collapsing smaller THPs" etc.

Sounds good I can make it more ambiguous!

Cheers.
-- Nico
>
>
> Thoughts?
>
> --
> Cheers
>
> David / dhildenb
>


