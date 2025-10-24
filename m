Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B834CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6A78E0098; Fri, 24 Oct 2025 09:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767058E0042; Fri, 24 Oct 2025 09:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EC68E0098; Fri, 24 Oct 2025 09:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD6C8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:58:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D18B1A0EC0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:58:05 +0000 (UTC)
X-FDA: 84033161730.20.D9BE8CA
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BCCEC000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:58:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cvO4gcJr;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761314283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qb8JXmt3CN5uxM93KzjvrKeVVtejTDlP7Ge1CaHpbPQ=;
	b=ew5MaqlmSim+zDcvPUDwGkpYqqyJ/KbVBiLJz7scZ21xkjHEt6qldqQI+tXe8kQiDZ8Yrb
	m+AhRYRpS/2FcWe3eiANhAaG74s3zCKb29vrBFZfYX4mRCFvJHjAHj+aRTUzbBAZrzhTcb
	P8nZn+AhxQ0p/0uYSmqscHRx/dM7+mk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cvO4gcJr;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761314283; a=rsa-sha256;
	cv=none;
	b=PTcCRfdpula3zw30b2gc7dkarnndyhcY17XIl8icfgKwoejFcOBdSdaDwWqvefCJ7atbG0
	uNfoPqTk2mvJNeO1j+wnNDPX+e4e/R5aFzsi3j6+ykFTQoz9Bu7UvCdRsb5/NiaQjKCONQ
	bskCwN/WBWrgbHnEQDbCHgmzH2u2rz4=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c4c346bd9so4086783a12.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761314281; x=1761919081; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qb8JXmt3CN5uxM93KzjvrKeVVtejTDlP7Ge1CaHpbPQ=;
        b=cvO4gcJrQ+ZoZZGv00JjImZFS4FXyWHqPSTePrMKsy+nHzoMi5cyDxU+QnOGJ5fp3y
         /by4m7SBytDU25QrphM30j2X7YT365BpaX6qwYDIGKcKqBODOljjKhefgt7L6nRqoOrM
         K/caoZBHSGbgv2UbEPG9U+tgYgRcVzFIAsPIClg9r1xjZeMKNsaTm0vZm0siPKJMgwrR
         MotiyHLBkL3aDmXR6M/epmqU6OY9ailanKFrquXWGwaJZIJ2M2wp+6zqhYjhF6spW4rS
         z8qbe6arszLuTH77m5swvAh42VQcS0sshaa7+in+MJ+hui5noi+vkUH1KZihSoR2dIRD
         T8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761314281; x=1761919081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qb8JXmt3CN5uxM93KzjvrKeVVtejTDlP7Ge1CaHpbPQ=;
        b=VijizvdbqyxNWyQVdh7Op2T+sdNvL6ZyKSQhdlFnWcwZR45353BBcqhneCVI9N2DgM
         CKf9HziOJLykD7v5NAiPYq7C5GSQXakyErp+DjhlaapyQ4QMYAfB9PVVz4jsPcuWWIFA
         fzqM2sgqo6piZGdbjiWlgh/h3CeYbpmLr4+e723F21u/DIXJTcqVDdugYWg3JZcq8hAs
         fbVpsKvXgSEF46PDa810yq/VgEEWdG4AR83ANbGiB/s7jgeF6zNUIV+94/8kpQMJDqB7
         S67/1N/jORaCNiblPsoy79MMnSKCtrBBdQWAj+zxKt1zHe3Y5eAVS4RSvcUPOUpEEYsZ
         LmDA==
X-Forwarded-Encrypted: i=1; AJvYcCUJF3uO1wPlWd//LSY2tcnm2ucmOKMgGUont8K9RmKbZ/J2sMTYf8KJk56kSvMnEqE4aJw/nCAo5A==@kvack.org
X-Gm-Message-State: AOJu0YziZMhduK0gC9lu/5lmnuvMd06XCGz3SmHtko+0WCBx2eEw8T0A
	6RqoIYVsFl56pQFLqRnUri/r7mdc7ZUshsQcLWJvCN101zn/y8CzJMeaxB2RoPNeXF2pxz25K5Z
	8mvRe4rRYixg7ocXLLGOtrvdBQqvrB4/Tan1hkDjgDA==
X-Gm-Gg: ASbGnctmibdq4WWqXMeSs96686XnauyRez4BOSaEtMCSRkyWKlc0YhCgwRrl0IabU9L
	fW3h9cG0lDVtS2DbXwkYu+uF8hHqKDUW9hc/FRGJ+l4DrOBhEHaglPn6NAnAjqcnpwnPPLlWtCL
	aYQVd4pIDwBAJAgKymB3PXVG9E5Aqe7Rl1BK1XfK7qxd84txiprAhawEa1W1cvJd5+x8CaSWtOz
	n06zAXFySt8IkUHnDunFtJ32Ozb6buoJd9w4kARA59klXNvGbgzBlitfA==
X-Google-Smtp-Source: AGHT+IGPZvY6fQtYpWdkCyVf9zr3LEiwL9z5kpvIR+uzM68lrE3k7xdjWb85Betn3HUBNcScbWokGmgQudK/7sh5h8E=
X-Received: by 2002:a05:6402:44d2:b0:63e:abe:711d with SMTP id
 4fb4d7f45d1cf-63e0abe71c6mr8941213a12.37.1761314281487; Fri, 24 Oct 2025
 06:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com> <mafs0v7kgjoxq.fsf@kernel.org>
 <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com> <20251024132509.GB760669@ziepe.ca>
In-Reply-To: <20251024132509.GB760669@ziepe.ca>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 09:57:24 -0400
X-Gm-Features: AWmQ_bmzgVBN6dVwpAuI8-pyXN2jvCTQCCKwN8AyXWnXRMNuvq3-OooS2e7d9eg
Message-ID: <CA+CK2bA_Qb9csWvEQb-zpxgMg7vy+gw9eh0z88QBEdiFdtopMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com, 
	glider@google.com, elver@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a7x57z5yzcc6ed43c8p9df64k79ugjry
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1BCCEC000C
X-HE-Tag: 1761314282-725685
X-HE-Meta: U2FsdGVkX18yEGe9VFhut0S2pXJAX5f+7Sc+Ey0XCoPUG2+RCg9oI76ALgirPknfeLi9P1mr9HPm/iSAJmvIcbocXbYVD8sTKZRk30T9wjyU2mSZ5oMRtziNCq2VaUQHMay+gft4F1NMZ8e0orRPmBgz4VZXP9AksuCj77lyLOiSYtk/xo5bKdH0bZXDWYkJLXiv8tHdf87wT5yUjEr7czFjQJvubs5cp5GDWNvxoCpnSYwA3jWcOcFFxK4AhhcWz2XwIZqhrwuoFlwKRjS+rOIS71WAEBU0poQgcR44aBwYvgClbcJvQRKQqLjWNfuaA6O8MKT/rGYhMtwUzG754dcJDYMjGlo5AsFf+FyzY8wfINJCGHm2go2Fb696tH+M1zcKOQKozzElTXp+e5lBhrPJScSS8gvGauhR/+gyLXpyZD4VGQWtWzJreX0ZuvGieGxA3xz9zR4aCalVc7P3Gj5vu620GaJogVM12aqkbEj2rFVbItPW5hHS8FkcLB1Gs/5e1qTMApB9q2hdW/pG12J7xAdPZ8IkS46jf1rrJRDWYoVLcHslU9IYjQyUzC+KuSl/8Ax4W12XDUmxsjJ66DKJO21PSEUH6OvIRZvZk70aDhK1Ui5TSHGuFp4fFWf74FSDXOWXKjhMEssn00ihJX+Rn39Gq9QjZ9CNlpeCO8W8o/HA86/GOL8jYwfwaHqotc87P//PVDKaRcyZt12xJQ/dIlpSBFJQydWzBhtiPaCzm/ORl1+0mmBv1C2I3vLr5iMqwP1j31pyPN66Mx7Ms7aHu41ip8nS97MpvfTaY6fKLErHtM//RaKdYuTRwopVkIpTk284+VY4/KQhGReYlklpJejCTjcrqnUfD9XXdUguQB1CHs30kmcqiHkO30t7NEUHb7+kW6ugI0UqNxu0Rvkj9O8JuhakqTOsHcPy92dWZ0jTAJthhaNsGI2wyVcRfu3f1i/3BGeCtp5JKV8
 1Fr0TyLf
 zPXthi18BShrk5ZzaP6ESbF8I11HrcHfv7Nd9w3CPywDwjrx6ERMuL+5Szz1ejTxinijyUHV7zO3cKxSbr1nX4NZ6cla2RIPE0/N9waolkK6ixcatxphly8WifBSkC1JywszNmTj7SpqHSdtkNKzUN8l5IugAISS0zWIzgsrHZ+seT751ILprIGqFS6r+WCWuIpUhEratYvg8Z/r/HLPzKGcmZ7qgo+PlKSB9Ww1GsvptKDDeGOOgMuvCU8yp46IZWHACzDe52nXNuJG3MTYenPY9XA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 9:25=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Wed, Oct 15, 2025 at 10:19:08AM -0400, Pasha Tatashin wrote:
> > On Wed, Oct 15, 2025 at 9:05=E2=80=AFAM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> > >
> > > +Cc Marco, Alexander
> > >
> > > On Wed, Oct 15 2025, Pasha Tatashin wrote:
> > >
> > > > KHO allocates metadata for its preserved memory map using the SLUB
> > > > allocator via kzalloc(). This metadata is temporary and is used by =
the
> > > > next kernel during early boot to find preserved memory.
> > > >
> > > > A problem arises when KFENCE is enabled. kzalloc() calls can be
> > > > randomly intercepted by kfence_alloc(), which services the allocati=
on
> > > > from a dedicated KFENCE memory pool. This pool is allocated early i=
n
> > > > boot via memblock.
> > >
> > > At some point, we'd probably want to add support for preserving slab
> > > objects using KHO. That wouldn't work if the objects can land in scra=
tch
> > > memory. Right now, the kfence pools are allocated right before KHO go=
es
> > > out of scratch-only and memblock frees pages to buddy.
> >
> > If we do that, most likely we will add a GFP flag that goes with it,
> > so the slab can use a special pool of pages that are preservable.
> > Otherwise, we are going to be leaking memory from the old kernel in
> > the unpreserved parts of the pages.
>
> That isn't an issue. If we make slab preservable then we'd have to
> preserve the page and then somehow record what order is stored in that
> page and a bit map of which parts are allocated to restore the slab
> state on recovery.
>
> So long as the non-preserved memory comes back as freed on the
> sucessor kernel it doesn't matter what was in it in the preceeding
> kernel. The new kernel will eventually zero it. So it isn't a 'leak'.

Hi Jason,

I agree, it's not a "leak" in the traditional sense, as we trust the
successor kernel to manage its own memory.

However, my concern is that without a dedicated GFP flag, this
partial-page preservation model becomes too fragile, inefficient, and
creates a data exposure risk.

You're right the new kernel will eventually zero memory, but KHO
preserves at page granularity. If we preserve a single slab object,
the entire page is handed off. When the new kernel maps that page
(e.g., to userspace) to access the preserved object, it also exposes
the unpreserved portions of that same page. Those portions contain
stale data from the old kernel and won't have been zeroed yet,
creating an easy-to-miss data leak vector. It makes the API very
error-prone.

There's also the inefficiency. The unpreserved parts of that page are
unusable by the new kernel until the preserved object is freed.
Depending on the use case, that object might live for the entire
kernel lifetime, effectively wasting that memory. This waste could
then accumulate with each subsequent live update.

Trying to create a special KHO slab cache isn't a solution either,
since slab caches are often merged.

As I see it, the only robust solution is to use a special GFP flag.
This would force these allocations to come from a dedicated pool of
pages that are fully preserved, with no partial/mixed-use pages and
also retrieved as slabs.

That said, I'm not sure preserving individual slab objects is a high
priority right now. It might be simpler to avoid it altogether.

Pasha

