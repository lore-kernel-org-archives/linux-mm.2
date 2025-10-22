Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD41CCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA088E0014; Tue, 21 Oct 2025 20:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A7C8E0002; Tue, 21 Oct 2025 20:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798A58E0014; Tue, 21 Oct 2025 20:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68D348E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:59:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32FB61406B7
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:59:45 +0000 (UTC)
X-FDA: 84023942730.14.960DEF4
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4658340005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:59:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iKBLyhYA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jasonmiu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094783; a=rsa-sha256;
	cv=none;
	b=agKnC2M8OMkwu4MwpMBOerW1qbqOIhtd1wMChP4fsWt4yf3tJu7+CN0o8oU1zjalOPsts8
	CtoOCrTQYclN3BTsd7/XVyuF7ffd0CQB4Hcp5QfWlyGILoF98fnnLAlGWrdFt3nv9t7qcI
	7ZcDLPOoivjTQYsG8RxgKuJSYcMLEVk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iKBLyhYA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jasonmiu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xEV8oP7/LJpDk2U5jLeRfggXS9CoYgLq/Xr9trinnw=;
	b=ei/bTAmI68hiHklT+3HtGP6C5gCzYNlueUKgsoSfN3hbMHcZ037o9JgkvE54K1rQ1sdK5v
	1v3Lu+bFeS5MiEmSrWg19uZhOaJRQYrolhk/T2jmPiItEDY84hCLaVxfpTiIXvnBjsjE4V
	XY2oXKyllYV+Co1pVfrb0XYHL6HO25Y=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4711810948aso43334625e9.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761094782; x=1761699582; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xEV8oP7/LJpDk2U5jLeRfggXS9CoYgLq/Xr9trinnw=;
        b=iKBLyhYAdMv3elqraW6wOz2QXxhp6vSZPcMxxRFR24T+sN0lDtNsxmGEgQRDRc5I67
         elzyttRQaLqOuP6RmNs7ApUSHTf+Y1ItajBeK036ddFQc0u3Hlzq0BACv04+diHJZXB9
         OT8hGYro5UcChouXB/2vmK6XmJ+Um21oQ3KiKC5yCpu8nLgiqvW9jmhPnrTO1kt98xUy
         SrhmYaxM/ba8Oo3WybUBQ85r2wIl3yjUw9b2D79kM1TWKwUpC+E7FM5nSgg1OJHemFOM
         s98W58EuGonSkZ7daY65vQ28tltWdWLlyYjND5OyMj2nejptQSCCNN9PwHURu+6y6lCE
         7T4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094782; x=1761699582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xEV8oP7/LJpDk2U5jLeRfggXS9CoYgLq/Xr9trinnw=;
        b=rBtHsK27eMNdcAYlORtEjeCKUhBQlGbKhOJKURmm9di+4dmu90VZ0/uunBPyZG4+Bx
         iJLFpq9Un3wK/x5E5c5r2pGuUIjqsPNaFMlTh+RZBrcbDawChi/gKpYUrFK0+75YiW7J
         AmdcW9fXl1xrlvLAiL4tkAwVw4gXwoTLnb+Ur8pjqodayykvzpPLX2AKU3eL1Ojms4fc
         lxUZpoEoaaGq76Wi8VdHVXbjRghYWm4o135LbnkChRZHOmV+upcBIyOdlN+7avan5MZw
         ue8YiZXzWvAjVB0zBUPO2TMY2kCi3yHMIRrWePZzSUZsUxhdnDDVK6kAgVH/Atk/v2+o
         3Xpg==
X-Forwarded-Encrypted: i=1; AJvYcCXFRjDLCTBi9dngte7SY4V4W3b47cRn1o7pHf9ylVaK6mdcXj+CQ0Dlmz+TUkAIoCVum6gcGqdPfg==@kvack.org
X-Gm-Message-State: AOJu0YzZ50fCHSS+0ZHke6AJd4SEKN3kVzoADKFf9d2j8aWL04DTC27O
	PQVvuy4emWc80dCLuN5UdqHzAwTCE0s5d/5DGmXZijoqZWQTSDl+QxqetnH86RXofHy0eC9vxkD
	Q5CD3pWoRP0Bbiz7H8XjAbmPps/DSs3Ru9h5ZwUXw
X-Gm-Gg: ASbGncvsa7DxoK454uVJoyaAo511GmTkjV//8lMS7bEx2b24uFGoSkLW2XRhKbcWH/B
	V+ngNrNse8cs0gVJKyxHLI+0epLFlsMWNm/MAnm5cj/bmK50an5kVzF4MCxza7OOMfeQhl9ANWE
	dQuVeXKIyA68AMlcF9JdWnq0nw49qBorGKmiB9kIcWXrU7b1g+hwomG2K/xFDtBwV42kexvP8GI
	Yk74WYrnCkdXdXLPyeaU9NA4ns5KEVjVTPeTnASWDkNJhi7QEv7jfRMZh4=
X-Google-Smtp-Source: AGHT+IGx3Qzgr+9yTFCdhHfzYJR0ao2Q/u8VvpEx6LPIGJlsEQvV8faBYF79WSejez6shY/tdzi/USdR7Q8GO8tc8zg=
X-Received: by 2002:a05:600c:4507:b0:46e:376c:b1f0 with SMTP id
 5b1f17b1804b1-47117876744mr147970965e9.7.1761094781549; Tue, 21 Oct 2025
 17:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251001011941.1513050-1-jasonmiu@google.com> <20251001011941.1513050-2-jasonmiu@google.com>
 <20251006141444.GN3360665@nvidia.com> <CAHN2nPKjg6=0QTcSoptxvQW9MpP0YwGUTx_gQDBxgCtSzxY5Pg@mail.gmail.com>
 <20251009175205.GB3899236@nvidia.com>
In-Reply-To: <20251009175205.GB3899236@nvidia.com>
From: Jason Miu <jasonmiu@google.com>
Date: Tue, 21 Oct 2025 17:59:29 -0700
X-Gm-Features: AS18NWCV7ujd1_nk4jzUplOGzOVRDyy3XvJOMidHbQL4TGXpAjE_MJA9mRNpbHA
Message-ID: <CAHN2nPJbXeSzLuznWcV+vo80rtk5odd+2GDW_NVDUGPG1KO-Gg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] kho: Adopt KHO radix tree data structures
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4658340005
X-Stat-Signature: pjozmerqge349thmsxwhtbyjdotietuo
X-HE-Tag: 1761094783-437334
X-HE-Meta: U2FsdGVkX1+dkP48SAzO59mLLy6dQlZ4q2mcoYRJB+bTrCk3XNNgw7z4kE7mssLDe1nNKuHd+oCdd8ur/17TKfDRudr7tsCKHGa4AYrUA4bnhS0Jry9AqP6WfJIM+Hh8PCjVxOP5vsD5zm4Z+qYKilVmRxjHGjnFLdsRZ3DDliZv/fsc1q6VQ/IragvL0p8SqHmAs3MMcsau+Tv9t4q1GWX0ouu5mTaf1AdY0IJ6BKyvewH9p2cm6CErfGeYzRXSSIe7FWN0+g8eufcv5plNgYDvk2P2Gny7ofnW6rTq6quy4EwnbC6UO2seclRc0n37OHjwxhe0okIKocFT4Tt9gJYUrBxM42i3zy7I4DTtfqygRCi662oEvqUWwv/5u4/4dVjLsxwKKxmBAuXp2SRIMtROtpMHQ66eGpv8mcx0zgefnIMxxB511enqR8io9WNMWOZwavGOJ8dMZbwbuzaJ1X22SlHtzGP0qOI2twqhAjibAkzSBueELdrtKO6/H5M52A/rln09cptNWVwgLYAsGQpVVGif7oebicj41Fgs8/awFLTq4JgBdZZxXFvr7CPc/S07mpicvR03l/bsAj8/dmQi1U96rQo/UPMzBeGDFpqzwnvFkME1S+Aq3gY2mRa/spkYN3s5fO3qW/RHRiEG69CBZaHQ+Zr5c/nOXqG4C+abOVU513Ormp8iWK/1Evb71uRlg05I0KR1eV6kM06BRBuG6fMoEFnCBsQn15nykGIvRptIIt/f8TV2Vai+9s7+KF514Qn32Q9/noWoGZf0v7Cvryyqm7971OYtua/w/H7HDY39ef2n9xKgsrQTn8OxO3bwGpIcWRax3qRUCZ+eEWNH9CDjczr+qz2y6e3sh5rpeb9Q8xIMXd3j5VGH97oHDYJ5ysdESQ291GsXpoRV2WpQ0CBi8zOWpeaiRvXK9tb2PKg9pQjQTb2Tohdi9DHImLppHDS5K945ctLJ8ud
 Le7jVqzj
 J2doI5IKts1ouningfKYT5I55emTdwBvBpMXMr5bpA6G/V0aemVxdwxvUG41i5gsZrm4zAHyM/B8Q1T8NqmC34JzZ5Kvmbp9MGgDotcULzKX8qJL8aorzUPFGLh/liR86zoiE/QLUo7OgtWlOjU/cxV9lWy3lO6TLZug800dI36lcHfzMZeGu5ZnA5Egt9L/oU1DR33DatdVeer40V62OYshedDwyeGD1Pdmx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Jason, I uploaded the patch v2 according to your feedback.

On Thu, Oct 9, 2025 at 10:52=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> > > > -#define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
> > > > +#define PROP_PRESERVED_PAGE_RADIX_TREE "preserved-page-radix-tree"
> > > >  #define PROP_SUB_FDT "fdt"
> > >
> > > I'de really like to see all of these sorts of definitions in some
> > > structured ABI header not open coded all over the place..
> >
> > Do you think `include/linux/kexec_handover.h` is the appropriate
> > place, or would you prefer a new, dedicated ABI header (e.g., in
> > `include/uapi/linux/`) for all KHO-related FDT constants?
>
> I would avoid uapi, but maybe Pasha has some
> idea.
>
>  include/linux/live_update/abi/ ?

Yes, moved to include/linux/live_update/abi/.

>
> > Agreed. Will change `u64` according to Pasha's comment. And we use
> > explicit casts like `(u64)virt_to_phys(new_tree)` and `(struct
> > kho_radix_tree *)phys_to_virt(table_entry)` in the current series. I
> > believe this, along with the `u64` type, makes it clear that the table
> > stores physical addresses.
>
> Well, the macros were intended to automate this and avoid mistakes
> from opencoding.. Just keep using them?
>

Sure, added two inline functions `kho_radix_tree_desc()` and
`kho_radix_tree()`  back for converting.

> > > > + */
> > > > +static unsigned long kho_radix_encode(unsigned long pa, unsigned i=
nt order)
> > >
> > > pa is phys_addr_t in the kernel, never unsigned long.
> > >
> > > If you want to make it all dynamic then this should be phys_addr_t
> >
> > Should this also be `u64`, or we stay with `phys_addr_t` for all page
> > addresses?
>
> you should use phys_addr_t for everything that originates from a
> phys_addr_t, and u64 for all the ABI
>
done

> > > > +{
> > > > +     unsigned long h =3D 1UL << (BITS_PER_LONG - PAGE_SHIFT - orde=
r);
> > >
> > > And this BITS_PER_LONG is confused, it is BITS_PER_PHYS_ADDR_T which
> > > may not exist.
> > >
> > > Use an enum ORDER_0_LG2 maybe
> >
> > I prefer `KHO_RADIX_ORDER_0_BIT_POS` (defined as `BITS_PER_LONG -
> > PAGE_SHIFT`) over `ORDER_0_LG2`, as I think the latter is a bit hard
> > to understand, what do you think? This constant, along with others,
> > will be placed in the enum.
>
> Sure, though I prefer LG2 to BIT_POS

Lets pick LG2. =3D)

>
> BIT_POS to me implies it is being used as  bit wise operation, while
> log2 is a mathematical concept
>
>   X_lg2 =3D ilog2(X)  &&  X =3D=3D 1 << X_lg2
>
> > > > +                             kho_radix_tree_walk_callback_t cb)
> > > > +{
> > > > +     int level_shift =3D ilog2(PAGE_SIZE / sizeof(unsigned long));
> > > > +     struct kho_radix_tree *next_tree;
> > > > +     unsigned long encoded, i;
> > > > +     int err =3D 0;
> > > >
> > > > +     if (level =3D=3D 1) {
> > > > +             encoded =3D offset;
> > > > +             return kho_radix_walk_bitmaps((struct kho_bitmap_tabl=
e *)root,
> > > > +                                           encoded, cb);
> > >
> > > Better to do this in the caller  a few lines below
> >
> > But the caller is in a different tree level? Should we only walk the
> > bitmaps at the lowest level?
>
> I mean just have the caller do
>
> if (level-1 =3D=3D0)
>    kho_radix_walk_bitmaps()
> else
>    ..
>
> Avoids a function call

I see. Done.

>
> > > > +     for (i =3D 0; i < PAGE_SIZE / sizeof(unsigned long); i++) {
> > > > +             if (root->table[i]) {
> > > > +                     encoded =3D offset << level_shift | i;
> > >
> > > This doesn't seem right..
> > >
> > > The argument to the walker should be the starting encoded of the tabl=
e
> > > it is about to walk.
> > >
> > > Since everything always starts at 0 it should always be
> > >   start | (i << level_shift)
> > >
> > > ?
> >
> > You're right that this line might not be immediately intuitive. The
> > var `level_shift` (which is constant value 9 here) is applied to the
> > *accumulated* `offset` from the parent level. Let's consider an
> > example of a preserved page at physical address `0x1000`, which
> > encodes to `0x10000000000001` (bit 52 is set for order 0, bit 0 is set
> > for page 1).
>
> Oh, weird, too weird maybe. I'd just keep all the values as fully
> shifted, level_shift should be adjusted to have the full shift for
> this level. Easier to understand.
>
> Also, I think the order bits might have become a bit confused, I think
> I explained it wrong.
>
> My idea was to try to share the radix levels to save space eg if we
> have like this patch does:
>
>   Order phys
>   00001 abcd
>   00010 0bcd
>   00100 00cd
>   01000 000d
>
> Then we don't get too much page level sharing, the middle ends up with
> 0 indexes in tables that cannot be shared.
>
> What I was going for was to push all the shared pages to the left
>
>   00001 abcd
>   00000 1bcd
>   00000 01cd
>   00000 001d
>
> Here the first radix level has index 0 or 1 and is fully shared. So eg
> Order 4 and 5 will have all the same 0 index table levels. This also
> reduces the max height of the tree because only +1 bit is needed to
> store order.
>
> Jason

Thanks for the clarification. I updated the logic by keeping the
encoded value fully shifted and adjusting the `level_shift` according
to the current level.

And yes we are having the shared pages on the left side (zeros in the
encoded prefix) while having the order bits shift to right when the
page order increases. I hope the updated code makes this more clearer.

--
Jason Miu

