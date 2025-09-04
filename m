Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E267CA1016
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814A48E000F; Thu,  4 Sep 2025 08:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5168E0001; Thu,  4 Sep 2025 08:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DADD8E000F; Thu,  4 Sep 2025 08:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59C958E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:07:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 206C9566C2
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:07:06 +0000 (UTC)
X-FDA: 83851442052.10.6B14550
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26FF1C000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:07:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O7aleYw0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756987624; a=rsa-sha256;
	cv=none;
	b=wkPkDE2pJA/6T1ZcoQlo/GJvmEkKYKQ/j301IccvJc5LQKyEV1ZMXACiGVkhqwKC4qXKq9
	m95uGM0iuStrura7GDSBzqskl5zdenWU0AjycoQQXCpCR13t3ZJfI7GQ/u/1EU75vczrjs
	W+THpS3o1cUo2NZOLedCpsaumUM2b4s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O7aleYw0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756987624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLld95qjRcnXUupD3eIzFa+wkQsC9TBTtZNr9c2tK1s=;
	b=5ePyYJwBodF77OvA4FP4sO9IMeuGIub+R/VKI9egxOW5gu8ZOVvHLT3sItCieUmQ1xjPQy
	zJhnxTHx88T2eau2D9FG8HRvAuoSPVhaN7BxZ+06yXKfeoArTYy8uNALaRYAoLpIWiWec0
	tfYlbbNd7bCXfO4U000FtGIId/IyCSM=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3df35a67434so538702f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 05:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756987622; x=1757592422; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PLld95qjRcnXUupD3eIzFa+wkQsC9TBTtZNr9c2tK1s=;
        b=O7aleYw0gwYb931rodUmCgP44G2h2ubIAy6WqM6YFA32TPidtKfAD629vCQ2mIlByW
         dJE8WOpuvlXJtspCkKmyA/Cg66X7BN6fVtI/iobDEEUpXaRYSkUtS//KrUJhGuyv9TQy
         H7OofJIlKL3SPWpv2bboiRP3d4cK8tUn7TlGyaaEUL+PP+p9IWX7Fi44UiNW9Iv/rtgc
         GagYMA9DGOM5cZmIs5Fta9sDmpV8nAjAhpg/j5MrPkAnCQaQFEvcXDFPBLyX6C9daURI
         vtpeqtOLryASUfulcxldhSleYUlJsHKaXIdSaj872RdvCu64G8CHz+In3v30ab74dg9C
         9QKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756987622; x=1757592422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLld95qjRcnXUupD3eIzFa+wkQsC9TBTtZNr9c2tK1s=;
        b=p9ahYNZUMfd3CQOg1MfOlxvpTvnDUoHpcT8QJ/cvF6VwFhI6E+dBiBMZgqsdTzRH/a
         GK2TJnDtGI2f8IuTWKUTVULtUyZDk7c91yehkwMyT2rGFh3aNops2OPeKzhfXiQy4sry
         Y2IqfmO7XBtRIAxuAGc2RBjZiZHmJQmBe6Aym9Qak55RtRK0NnKkpjNEckuqDKky8An+
         TpPrhGAG0dvUsWyD4fByquPUReS85drhxgMtEI1xagQP94+fj8+BYCIQTaGa8tvU38du
         5lp3/9Xy6i5SOX66If3bFD15ApmKpnWBHnK1bjWFir4n2RTaSPlZ7hU5RmVsH+8Mjk7h
         cpkA==
X-Forwarded-Encrypted: i=1; AJvYcCVmyqGFl0iqn03s3CzNgcjLf4izLZaxEsWPZDzOUNq8ZEqaRi7tO9w89m0LSem8zQhtrkvHTUsPZw==@kvack.org
X-Gm-Message-State: AOJu0YzslKLIVJnju+gBZRZYWBaA8zWpX8H7U4NpAiWqnoL1y3y57cP+
	eaMZK6enDfkWQo5hSmLKWfnFpU0lmv3YSvFAryENpAh8h/cC45qzs2KA
X-Gm-Gg: ASbGncsfO6VJwh2LCJufRq7cR1ciA/Mjyq1ylbn/U8JJCctSyLznJhQXMtR1dVgjcxt
	6bckbeshlkjRvpxgUEPw67KSbDOiE0SBHR1P07rO5vcYsSpiOwDelGtbpbb0NhEVcHEjGOUNe3C
	d+gsKTadYBMglXzUG09ixetjZSQZvjATWifr1D9BMHujnELfSNlnlCbyvFN6xJh7w1NiIvS59oG
	3ocnoAATkE5Batg9YvY2ba1S6yvLLarCbKES1Z8zdvBZ/AVvlpKAjmUpvJYJxjo96IhlpST6OYD
	u/Am1H1Sd5bmVtOlZi7n1dWOewtEt+QlSXRAE0ieBxCLYDSNxjv7euZH7iJcjVq66dTsxQWeeji
	Ir4aQlYOGXEMq2nY/9z0QQrbZehqYGvqtZbodhwXbK6ta/pxmdAKrP5InHQsZ42cKQ/MSx5KAKV
	ZdlO64Ij9Y
X-Google-Smtp-Source: AGHT+IG59eYhocU/Hh7asCkInZg6kFlAG3r0FLBdaakyF5gvjtdvhWnDUh6z/r89PFN/6r5wlaCujQ==
X-Received: by 2002:adf:a406:0:b0:3e1:7964:2c17 with SMTP id ffacd0b85a97d-3e17964361cmr922214f8f.62.1756987622170;
        Thu, 04 Sep 2025 05:07:02 -0700 (PDT)
Received: from orome (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3df4fd372c1sm5436504f8f.29.2025.09.04.05.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 05:07:00 -0700 (PDT)
Date: Thu, 4 Sep 2025 14:06:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Frank van der Linden <fvdl@google.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
Message-ID: <zmsn3bdqj2eclrm3xehnp27u57orqiq74ki2qn6aahpiamp4sn@wgalbnbpzmr4>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-4-thierry.reding@gmail.com>
 <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
 <v7zrmrhvemyymq6qamz6wbgzr4cijfe4n76ivwyadmltadlot7@3csy442wfasf>
 <CAPTztWZJqzbR7Y6jE6NM1qQOumYz-ckzSfGDfUcsgMVU7SBb0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dxmjpjrjb5ukagg6"
Content-Disposition: inline
In-Reply-To: <CAPTztWZJqzbR7Y6jE6NM1qQOumYz-ckzSfGDfUcsgMVU7SBb0Q@mail.gmail.com>
X-Rspamd-Queue-Id: 26FF1C000D
X-Stat-Signature: s59hjyfwxcbk94trz47i94hgizywiedn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756987623-785470
X-HE-Meta: U2FsdGVkX18byt8rBgy+nL4iBq3F5SBQRehqDfVvawp2OwOuAFfIU1vzJ3MofaqOgKdUGQbkSA05ufWSZ8cRX5Q/RJi91Py5sZz4JlAq3jlYzha7mntI7NA+8mCUg3h94fOK8u9AfZICLss4kxtKyonbL+Qp8hlbyqkatZguboE0FQzUbxAvrE8asQkH6SgnHw0z8mWicY0wsguakpSXbsT+6+tTmqWElfRvyDdwxmpbt4xspL+mB0oJbQlwHd7w4fW7K+KdN62M9teRR6H+fd0cgn7LNrB4NTY2Ngw99jIukj0ULUUq992olD7b8OYspqaJRByN70SNUk9LbQDRI3V0sPkqHx/LJtHsHG2hVJTJSadkD7H+Z7nBfww1MGu3qkQB7zvNeAAocI85NiIBlL3sxw0A9cRHrpky1SLw07x0jjqFM+wwhrOQEMOvhKKhBgPCmld6HaTZwQjv3LH5m8EZaQxY5sm0RVf7qO70MpEYdq+QbNXEGM9zrn2lgOyEHQawb+lJKVcLz9rvgP4Ro0Z50NnFctwdj6Tx8BIR2ephM9RwP74YgXtRNrGWsietw8gsrIVCy5gv8uc5QOHjmklo8xTsxnj8jOl6kTCubP6CpUHiLuBvRDgxol5KuF3ALe3/gIfr8elb8xRWaje3Rp7i2NXEugXXwHEtc8eJwrGQoL/Uq1MV9UAo0oQqG4oZn7AcP95Brko0QbMlS4AvYn9ordTSxTz/0gdEwGJzeKlQHPn0K+oJl0OP0OU92yKtlBqQLreVF16zM8OYBpxAFEa/dPL6+aJO9kvq5iUXwf5B9Cp0YJ8JedS9SrCOrAa04Zy4OqH6sE0w5BORrtMFsuPgKJr/I9LqYGf7XkGDgwqO45/oz0nTYr5aKqXXWVcZfjsq93Dv4YZDa6RTmO/HECpvM/AzQxxCJG0iH78qkq+xA/zLQfTHc4PkQzY3QuF14MJhmbvaMygjqO4FdyL
 gTQdNHQh
 vO4q0nqbDrbt4jjqzlwPZW8pZ3Jlaea9BIFTJi/vUyLUPTXAQ/jDWYVe60clknfS/fS101dg9JCSs6c5DeiWh8M2yvRSczEBrG6ql9MuXoyyuG/zZnQEgwW+v9/3Sr5Uxld/MZG9yM+sRBQP5wIl15nkG3wuUW5FZJPhmyKX6encb5PMzdv/ahpBQBL2oZr1jzCGo8BwEOx+VZXyOTiFsjQ6j26IU2HxfpUOH6rJ66+Znq2fJZCd1409iXkKzTD7Md8Ne6x7ejJsYtSwJpq1DcT+TeVK95Hj82tisSYMy3EcEYrt3XemKEJYm6IMYpIRvxZIJ14n2os5Bu3lmwH1tqyMTGdgXpx2WgvYPZF6EFOPttE8v5hHL9YZZeOCXHJ85lnc9WqBtyHYOhX4+PcoYfnCBsJiFowLEi7TCOyoqbJBy+rERNEDAJ/iQ3Jldi/9zdjMRcly7eGCMSJfezQnfmF3z2if7Q1NkaQKoNgR570Ah6Iyw/gGmhJTRu81dCja1he37gr8HUKIVhttMEZxpGO0cuihlZDn0aw5P0q3vr/6tm1eUnvUcTu+xO3l3nwRzotcc6peElBTv7KangNzted0Xu8EjI1ccGXRJ7O32/5LxH+xVrNBXfGXHE5+epteu2LGuy92JBBCRpw78gfa2phL7Yi89gop1ZvDKYSLNfkxYFf9RRO8Mg5/SE2mY0f2BuzxS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--dxmjpjrjb5ukagg6
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Wed, Sep 03, 2025 at 09:41:18AM -0700, Frank van der Linden wrote:
> On Wed, Sep 3, 2025 at 9:05=E2=80=AFAM Thierry Reding <thierry.reding@gma=
il.com> wrote:
> >
> > On Tue, Sep 02, 2025 at 10:27:01AM -0700, Frank van der Linden wrote:
> > > On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding=
@gmail.com> wrote:
> > > >
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >
> > > > There is no technical reason why there should be a limited number o=
f CMA
> > > > regions, so extract some code into helpers and use them to create e=
xtra
> > > > functions (cma_create() and cma_free()) that allow creating and fre=
eing,
> > > > respectively, CMA regions dynamically at runtime.
> > > >
> > > > Note that these dynamically created CMA areas are treated specially=
 and
> > > > do not contribute to the number of total CMA pages so that this cou=
nt
> > > > still only applies to the fixed number of CMA areas.
> > > >
> > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > > ---
> > > >  include/linux/cma.h | 16 ++++++++
> > > >  mm/cma.c            | 89 ++++++++++++++++++++++++++++++++++-------=
----
> > > >  2 files changed, 83 insertions(+), 22 deletions(-)
> > [...]
> > > I agree that supporting dynamic CMA areas would be good. However, by
> > > doing it like this, these CMA areas are invisible to the rest of the
> > > system. E.g. cma_for_each_area() does not know about them. It seems a
> > > bit inconsistent that there will now be some areas that are globally
> > > known, and some that are not.
> >
> > That was kind of the point of this experiment. When I started on this I
> > ran into the case where I was running out of predefined CMA areas and as
> > I went looking for ways on how to fix this, I realized that there's not
> > much reason to keep a global list of these areas. And even less reason
> > to limit the number of CMA areas to this predefined list. Very little
> > code outside of the core CMA code even uses this.
> >
> > There's one instance of cma_for_each_area() that I don't grok. There's
> > another early MMU fixup for CMA areas in 32-bit ARM that. Other than
> > that there's a few places where the total CMA page count is shown for
> > informational purposes and I don't know how useful that really is
> > because totalcma_pages doesn't really track how many pages are used for
> > CMA, but pages that could potentially be used for CMA.
> >
> > And that's about it.
> >
> > It seems like there are cases where we might really need to globally
> > know about some of these areas, specifically ones that are allocated
> > very early during boot and then used for very specific purposes.
> >
> > However, it seems to me like CMA is more universally useful than just
> > for these cases and I don't see the usefulness of tracking these more
> > generic uses.
> >
> > > I am being somewhat selfish here, as I have some WIP code that needs
> > > the global list :-) But I think the inconsistency is a more general
> > > point than just what I want (and the s390 code does use
> > > cma_for_each_area()). Maybe you could keep maintaining a global
> > > structure containing all areas?
> >
> > If it's really useful to be able to access all CMA areas, then we could
> > easily just add them all to a global linked list upon activation (we may
> > still want/need to keep the predefined list around for all those early
> > allocation cases). That way we'd get the best of both worlds.
> >
> > > What do you think are the chances of running out of the global count
> > > of areas?
> >
> > Well, I did run out of CMA areas during the early VPR testing because I
> > was initially testing with 16 areas and a different allocation scheme
> > that turned out to cause too many resizes in common cases.
> >
> > However, given that the default is 8 on normal systems (20 on NUMA) and
> > is configurable, it means that even with restricting this to 4 for VPR
> > doesn't always guarantee that all 4 are available. Again, yes, we could
> > keep bumping that number, but why not turn this into something a bit
> > more robust where nobody has to know or care about how many there are?
> >
> > > Also, you say that "these are treated specially and do not contribute
> > > to the number of total CMA pages". But, if I'm reading this right, you
> > > do call cma_activate_area(), which will do
> > > init_cma_reserved_pageblock() for each pageblock in it. Which adjusts
> > > the CMA counters for the zone they are in. But your change does not
> > > adjust totalcma_pages for dynamically created areas. That seems
> > > inconsistent, too.
> >
> > I was referring to just totalcma_pages that isn't impacted by these
> > dynamically allocated regions. This is, again, because I don't see why
> > that information would be useful. It's a fairly easy change to update
> > that value, so if people prefer that, I can add that.
> >
> > I don't see an immediate connection between totalcma_pages and
> > init_cma_reserved_pageblock(). I thought the latter was primarily useful
> > for making sure that the CMA pages can be migrated, which is still
> > critical for this use-case.
>=20
> My comment was about statistics, they would be inconsistent after your
> change. E.g. currently, totalcma_pages is equal to the sum of CMA
> pages in each zone. But that would no longer be true, and applications
> / administrators looking at those statistics might see the
> inconsistency (between meminfo and vmstat) and wonder what's going on.
> It seems best to keep those numbers in sync.
>=20
> In general, I think it's fine to support dynamic allocation, and I
> agree with your arguments that it doesn't seem right to set the number
> of CMA areas via a config option. I would just like there to be a
> canonical way to find all CMA areas.

Okay, so judging by your and David's feedback, it sounds like I should
add a bit of code to track dynamically allocated areas within a global
list, along with the existing predefined regions and keep totalcma_pages
updated so that the global view is consistent.

I'll look into that. Thanks for the feedback.

Thierry

--dxmjpjrjb5ukagg6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmi5gOIACgkQ3SOs138+
s6HoXw//XNrWJmAMVCgR+fCzlx0zoU4zdXoaxEp6EQWJKYjG//X6xi10kqOs2jVR
uu5knOytKBYAZxrbGlElM3YDTUvN62voCXi2dgvDZ53e0xVNnz+JbhGvA4FRpqU4
57ax3pJqEz4nWK7WnYrovlUSwMEPyzXb8KiRydUchOAr/QQfaCQKP1+HUgjsNsi0
0JgzT2LrmkZJvzpYS1gK7Kyb7hnGh620lWwILWeiB8Y9XvtuktdxcuTqvt3hp3TF
d8WHkQgF591iqMllbP1UFBd4zh852n3wuS/NutP4F2xH87BvkL+Az3uo4oAkqRW5
ihpe1fdjufRrSa8j4he62obtU3HQUFzXH+1nktOYrN+NGtqvRm6FJGjbg9MgAN+J
NeEn2yAIbCOT7Xhv/tAPSlB86nJVG3mmbWkfzVQhMdkeQrrTOkE7WHVH8YsDKF0x
fEnOR+NpJ5NAe74DupV116N6YvFBd7Za9uHVPW4Xue+vqShxRl0H3/mIpmZg0JHf
La8GRnYptVZoHP7YncT7rIFLmvBwf98uE+jUpHPrYbnrvBoXzECCg9higjZ/6faY
X+rx5NUc6BRVTVncIvdiKwTR/g/F/9fFBAlDx3ie4MEJgtL6yvEIuCyw58N3X/uu
UZmj3uvPk4sZILsIZO7+65qLprdN/o+T1UBAL8aWUo7bSNflcKw=
=jDv8
-----END PGP SIGNATURE-----

--dxmjpjrjb5ukagg6--

