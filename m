Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF21BCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302F06B0006; Wed,  3 Sep 2025 12:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DACC6B0007; Wed,  3 Sep 2025 12:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217958E0001; Wed,  3 Sep 2025 12:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 110226B0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:05:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C000713B888
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:05:42 +0000 (UTC)
X-FDA: 83848414524.08.76B1ED3
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id A07E14000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:05:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BfC5fqrV;
	spf=pass (imf04.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756915540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLCSap59X655LjRRdRVDlno90QWSbu9XZF5TPpJulw8=;
	b=hErn6hfO7O2yXpJn2VeYRnkjpYUH6cYTpLSiso4pD36uVrugq/+v3AT7aLLMoEomJrYDuK
	aTEl6cebbooHrWwRfixHKNR3x6tBWBo9+XpWJxw6XM+L8EiQSVz+djBxsVezKqq7XJBPS9
	ADXgsabmLiFp0h5hK8EoWGTRLXlxGCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BfC5fqrV;
	spf=pass (imf04.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756915540; a=rsa-sha256;
	cv=none;
	b=S6gzgjHtuLjW/jxIExHZHwiAaz+uZoFCRMgwBNNHdtfXdXrRHtJsl6yDQDGkTuSHcGWU7X
	8QKTgZj5nsmnIAEWJ49Er9+WzwraBep8nZLCdvN7rnnaCfFin5iPcHak778a+DIQZFUa5p
	mtnC/OfMmYRIcueTEgXofcKNwUN86m4=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so72781f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 09:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756915539; x=1757520339; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLCSap59X655LjRRdRVDlno90QWSbu9XZF5TPpJulw8=;
        b=BfC5fqrVO4xryL3NW+9XjOYJx5uZy7AAil4jRI597WX1gt5ap8l/saEI9w8/KONwW4
         mHdtLRxkV0rjYn98seZ++MurE85KZW2sL3zv/ltaF/u9bBq5O6/fRcLNWch2mkpBHxQj
         HyMnazSSMl8jIXcFIfA8c4s8+Xn96dFbmoWIipAoLDGgY9tS5qd8hL0AUwNpzTS2JhKd
         KGFGPTb66w1zcGeuq8eG7R7QfJ/WYGdiylms+teyYhR3sNSzxkFlTYRHGmKMsdV7Uo3f
         CmjB40xBF4z9/08CyAw3Q30JkJ8I1/GxuGPFikDXeGWYROCE9abJVfHleGPq1PWn79nP
         hEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756915539; x=1757520339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLCSap59X655LjRRdRVDlno90QWSbu9XZF5TPpJulw8=;
        b=oQG5lcAxKl7OBenCfkvR+2pnvUQQPIsrfxBk4y5zmAjpKdW1Yw5V2zoNy9eC+z4OZi
         GacBO6mVaKFS2BL3P6XArUOmgGcNGgo2qU5R5vXWKu3Q6eBJ1zKb1Pz+0ibeWdgZ3IHa
         VNuw8otYQIrbmdPPngegQsO+c+X/T7OclrmiOdgf9MKVtv/ttJTYPb8IOe8iaThZltp7
         CqZTCboCdyoNQsvBMzQbSiEqPA/HhCm5KY+Kd+Q0UUAP3s0OIe+zueyNn6TXxYWOUg8g
         t9FWDj3VGKOgcr+V1PqFfTeT5ei7Fg9h7XBl1M6y7Xv7DJEHyYQ7DMI0SP5hT/MiosGg
         HzpA==
X-Forwarded-Encrypted: i=1; AJvYcCU4yoPlv0q471EoQPu3NAm+QfiDP0Q0eUPnNhokyH6urGEj63R2X1BiW7PzmMR+l5+7Z2R3U8rVew==@kvack.org
X-Gm-Message-State: AOJu0YxMB8sh/FE0LhR+rKGcRW0qRNpyhot2u0B25Ym3lcjmKn6qi1u+
	oX4Fnis2liGo39NKP84qaVxpaoQ9mM+E9v23a1MXi9OzGnaJWcpTgdX9
X-Gm-Gg: ASbGncu2JT80H0q+M1WSnCPnfrlNBJPAWBhwnoC71Qd8rLPUpYTj9sC4VSB+pgMJnES
	0mmyuvGSHsH1GsbVuW0yUG9LWyGYDkpjCFPVKv63u292MaokCu1SbwpslKV56bWmrilAjmk89Tv
	jUicnvJNwmXemcYaT36ubMZfLrqjPkZkBDVxqIFF0Huapn2n1DAWQ44ZSPdM4iziNJG0IECyGdG
	t6ZmLbe2Atray2IluujK28sr13N2ASTsMTqqvhzs2XgntS9ZCCnph06qErbuX3T0VQdJ9oEcgq9
	suwdopC2U0X5ZdggXFt7T110gYIE6ZURV6BQ2p+3LUfy2/Zb8Ln08+0nlfsGdLC7kFxYZDvRZnC
	jtF332qnQNPCSzlly/s3uL0r7pbZ8kD+Jz3LsKfUjDtGY1ZZIKaiUmN6TE/+4FIVTT059SFyp5l
	+/42WU/kkv
X-Google-Smtp-Source: AGHT+IEK8F7kNjGc7W/OtAYN0SPufkeKfdMjFea1WYfcRndMdqBIHchu0H33lCxAbsFDmGMqVedfpQ==
X-Received: by 2002:a05:6000:3111:b0:3db:c7aa:2c4a with SMTP id ffacd0b85a97d-3dbc7aa304amr3472709f8f.42.1756915538938;
        Wed, 03 Sep 2025 09:05:38 -0700 (PDT)
Received: from orome (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d66b013b7dsm13160799f8f.28.2025.09.03.09.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 09:05:37 -0700 (PDT)
Date: Wed, 3 Sep 2025 18:05:35 +0200
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
Message-ID: <v7zrmrhvemyymq6qamz6wbgzr4cijfe4n76ivwyadmltadlot7@3csy442wfasf>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-4-thierry.reding@gmail.com>
 <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cd2jrjiunyvxx6e3"
Content-Disposition: inline
In-Reply-To: <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A07E14000E
X-Stat-Signature: 9fqxmgdb5rwqgmm3famzmomw6sf1y9o4
X-Rspam-User: 
X-HE-Tag: 1756915540-631570
X-HE-Meta: U2FsdGVkX1/5fEXLmlkbV85hkGCBHq8fqgC+jzP6FEMKB/FmWz/XKUBcvofTICltg/g0yI1ElkvTiJ5g6O5Eyy4BnM9hs8eVugWPr3CwgR+7ncUjfke4OYYzR9zrBSspCwEJNKqIwIj+s3qwuF19v/QhNPaDTusEoZjthTj70jD69Tnea++ILckk0HIyh1LfrHizsdDFSehkTzecgCLoOAaq+oj0Yh2EhvZxTDEvoLPlAZT2jhUb++NK2sbX4NvHbtfLqKeBqwzbHC7AWSghIMJb80o0kWL70GLdgeXwU+OXmKbtX7ajVTIGXpi0w/l9hMQezAI9iqGLKLDddY3wmI0eyGcGQUa53+x0GD/qROs+vftJxOA9EcE6k3DHvSQ9CPCPGJIEQl/9VwCiP/aNxcgI/jwJDC3UKu7nYo1WhqHsIE/50db8USQR2VKALjOUDcgMYSjRn8K5q/RsrID+51n49StJy58FDwaFnKYt9g3W9AhUslH9A6W3CoHn3TAkAEXD013ElgToo0eljUbp/04H8wSLYML3Eq+lcuVXfqANUrJVLZfpTGcPvIYI8QPNXJJOX8kYNHi5F8NBI+L0zgVNli2MKgyK5v4edZlPwaWT9RPT2gfurUGHh47qG8Ad5WkwiCv54rjL85/J2qj4HnD+ALrVyMMYHN0k2yiugKffuZmdirVkpdIJK27fRfsvfmEJ80dVPSpTRcwJPRJKMz94XwCr/e+2Hy2ex+qEWdOi7GRz8X+WCRcbauAFYDV2I4iX/D/8fWTnj/O3F3+ELRw7xZOrcXqYrNTkJzC03/1KX0u030FoATnYNUwC8Wbm7DiDr1L3I+Q8lyUlv749A0LmUr+EVfbDTQIN3Fz9cYt11jIepyeY0CQ6UEWyaUkWsrzCiMDTzrLNcU19/OQNs2QiS31FKKtqYEHSGlgt6dU2cuI274iPWbLFNXNMuGP2KaZDHIlc8rfrPf1xCkn
 SYQjlM80
 /lMFFqplkSDLElDnEVRvi+9W2CL24sXh278gZQWjd6cWFMWuMuINVDETiFcEaHBm92HZttwS/OOhSj0JcWlt5v7z+Cwh7CsKPwzOeh8/X0BfVPWjbZZe5oF/Gh3Usnnbb28bxw2xv1YHZb1qpZfYZsOa/sLgSZhsx1ndvh/4dFIVODpWe1X/zJmAzyOt8ODe7UQztTCjB0UcIRlEG+4oP+HNQKhU+9blaSI306fk4o82FVElQkay+gczhvafiCDHJC3A/YjmvYWxD1eWWqQ6p7Oy5K4v1pVonNwd29LAJv0jQ3N2xtwm2RApldmx/E15IvIiBQO0IHnylEH/uSuHEST8vdkVL01pos0EZfbMz3RQq1ENW5bK0QJiTCtGPrbH+NUSk8B1qeyPVu0QmkB5Qb2LuwoUcM9iYf7PjIBnKURfvQKjz5FP6UD7U3PNOF5KLITqiumiJG16xG4L41y3vB+TVnytM0bwE28sFAmzOs6kHJYiKDP7RzZuYlbio/WHYdwcArtgdX+3MIWXO6yWKTEwf0L2rwxXdg9AZtzGZfIW+erjYocUParjazzaPPDwBKZ4kovyOldO9aJwbpGqskjYmCkko+rhc356lPRsy23xcRP52oYCqoPqXtl1N9JFXaMBxxTs9Hg2N7N7RDaYmSumwu60V3TUIzjWzOD9dHL9dTrJ1b8BK5GkOA4N6xZJTFofc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--cd2jrjiunyvxx6e3
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Tue, Sep 02, 2025 at 10:27:01AM -0700, Frank van der Linden wrote:
> On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding@gma=
il.com> wrote:
> >
> > From: Thierry Reding <treding@nvidia.com>
> >
> > There is no technical reason why there should be a limited number of CMA
> > regions, so extract some code into helpers and use them to create extra
> > functions (cma_create() and cma_free()) that allow creating and freeing,
> > respectively, CMA regions dynamically at runtime.
> >
> > Note that these dynamically created CMA areas are treated specially and
> > do not contribute to the number of total CMA pages so that this count
> > still only applies to the fixed number of CMA areas.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  include/linux/cma.h | 16 ++++++++
> >  mm/cma.c            | 89 ++++++++++++++++++++++++++++++++++-----------
> >  2 files changed, 83 insertions(+), 22 deletions(-)
[...]
> I agree that supporting dynamic CMA areas would be good. However, by
> doing it like this, these CMA areas are invisible to the rest of the
> system. E.g. cma_for_each_area() does not know about them. It seems a
> bit inconsistent that there will now be some areas that are globally
> known, and some that are not.

That was kind of the point of this experiment. When I started on this I
ran into the case where I was running out of predefined CMA areas and as
I went looking for ways on how to fix this, I realized that there's not
much reason to keep a global list of these areas. And even less reason
to limit the number of CMA areas to this predefined list. Very little
code outside of the core CMA code even uses this.

There's one instance of cma_for_each_area() that I don't grok. There's
another early MMU fixup for CMA areas in 32-bit ARM that. Other than
that there's a few places where the total CMA page count is shown for
informational purposes and I don't know how useful that really is
because totalcma_pages doesn't really track how many pages are used for
CMA, but pages that could potentially be used for CMA.

And that's about it.

It seems like there are cases where we might really need to globally
know about some of these areas, specifically ones that are allocated
very early during boot and then used for very specific purposes.

However, it seems to me like CMA is more universally useful than just
for these cases and I don't see the usefulness of tracking these more
generic uses.

> I am being somewhat selfish here, as I have some WIP code that needs
> the global list :-) But I think the inconsistency is a more general
> point than just what I want (and the s390 code does use
> cma_for_each_area()). Maybe you could keep maintaining a global
> structure containing all areas?

If it's really useful to be able to access all CMA areas, then we could
easily just add them all to a global linked list upon activation (we may
still want/need to keep the predefined list around for all those early
allocation cases). That way we'd get the best of both worlds.

> What do you think are the chances of running out of the global count
> of areas?

Well, I did run out of CMA areas during the early VPR testing because I
was initially testing with 16 areas and a different allocation scheme
that turned out to cause too many resizes in common cases.

However, given that the default is 8 on normal systems (20 on NUMA) and
is configurable, it means that even with restricting this to 4 for VPR
doesn't always guarantee that all 4 are available. Again, yes, we could
keep bumping that number, but why not turn this into something a bit
more robust where nobody has to know or care about how many there are?

> Also, you say that "these are treated specially and do not contribute
> to the number of total CMA pages". But, if I'm reading this right, you
> do call cma_activate_area(), which will do
> init_cma_reserved_pageblock() for each pageblock in it. Which adjusts
> the CMA counters for the zone they are in. But your change does not
> adjust totalcma_pages for dynamically created areas. That seems
> inconsistent, too.

I was referring to just totalcma_pages that isn't impacted by these
dynamically allocated regions. This is, again, because I don't see why
that information would be useful. It's a fairly easy change to update
that value, so if people prefer that, I can add that.

I don't see an immediate connection between totalcma_pages and
init_cma_reserved_pageblock(). I thought the latter was primarily useful
for making sure that the CMA pages can be migrated, which is still
critical for this use-case.

Thierry

--cd2jrjiunyvxx6e3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmi4Z0wACgkQ3SOs138+
s6HhmA//SMOIdCPTIhm9/2hI6bIiP7AY1j6GdkcEqHRdfrj9+7vySjIRju4hKC3/
YFfr1tCxniYIMxmH+EBUK8bZT3ul0IYLIAO0WA2a8Tc2MypvKL7bvvo4lf+ecbUE
Nsu3LO8MVZQTZ2KFR6mFiXKVi4MTs7XD05csQuvxazvHixU+AueWaKsSwhL1YWmK
yZ14mjJNHFwVJrZ+4Pj4nsmjQw6Qe9D8eZ+d1gXMeTyPg+RJDay+EJBxM7/Vs8Sy
T0m/UudLZIle+EYXBzhlKyHvkFDuUuutaZaYESuiRvts7iwQnhLYaIheHIj9x2gG
VC1vjkFeh4RhbB1srxB71CzyJPKbwJ5oIdvnA1kBeDUlPGuFGm1wM+FygAwoKXvR
HHCF+FaX4H/FeFz0y6z0fkvhfLm+LLuBBuj5KHTCblCLk3cYfVha+Lr4msWjbI4I
51F8NtxQehBsHWv1F2JOguGRE4lv3svHyb3yuQeJC9SPdN12/2gmY85xnm3knlhB
hq9a/y2r622vqFwgPTg5kKhBdjIwWf6tdxefR230K+Qw5ypbrNQQoPhFR/4lG2IX
n/BX8IGEoVCHH7OC3/JfinZyE2td7+xKs/GF81elCfACdkeCRJhL4EWSGVRTI/TP
3OcUwmEbp+Cr0gdYspxD0nxw7bP5SUuAIZRRBEH1KfamNw5DEcE=
=TbFN
-----END PGP SIGNATURE-----

--cd2jrjiunyvxx6e3--

