Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A18AFEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A009F6B0005; Fri, 27 Feb 2026 08:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE5E6B0088; Fri, 27 Feb 2026 08:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACB16B0089; Fri, 27 Feb 2026 08:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 746296B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:16:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B57114067F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:16:50 +0000 (UTC)
X-FDA: 84490286580.29.9F865B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C0502000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:16:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=atCPtfbS;
	spf=pass (imf13.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xR8WkGwNViL/78tIXFN5QS/jFLNi5GoLmlrRAJwZAA0=;
	b=1YT/O9eFa/drowlJSDRFl98zfxZhUue16PRa3pod+BrgnTBtlzWIl7dnG+br7dxj0iPlqE
	IN9Rqx52Q6eLHJr2vMKZzTK5y4Uh++uVvY0kL0/QhQiSykOWyfT5xvNJMKzH5n5ClXY11P
	8tLyXb2fLiro+T37vGL03nghFTPb6Hs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=atCPtfbS;
	spf=pass (imf13.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198208; a=rsa-sha256;
	cv=none;
	b=rZVqrPMa9FM2ao1QWrfsfY7HKK+wLjM+qbC9kLDny+y6+dS73dyNMfptDUOcK1gs0vwRBs
	+giUs+zHZ/wLyEE7mtL4Y7lMxQ6Ym2cuI3EmPS7IE1fGvbXs+MG/UF7qYMk5R+vBrg/3nw
	/LLFuOZltsqKW/6xbTCtjrsrgPd0+mA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD99760054;
	Fri, 27 Feb 2026 13:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA494C116C6;
	Fri, 27 Feb 2026 13:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198207;
	bh=egCWlPm1x8iHr9PPIzoYHflwiSm/bh95WCzD6gZYC3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=atCPtfbSo6Zvk5tUFHE0DZyHYYrtBPlRAIDk2mxNRXEtPE0XaZAfWxmPGH2sW5M6S
	 eTxLV3zr0Lw2PBwhHycBLW1jVxNqhngWqtqMsPQ18NLiQjbwwCI3UxULojF/uzWeMP
	 29DUDUetMPpyNPFuJY6WE/1Cy3CdrW4wN7E197m9W5mDYZBwlSKlfiYxDXPNI5Il0F
	 5YHLwWvg3D5LnI5n9/gwS03rSP9SmZ3R0NmEo54rv7Yy6GfDTWHFKfl25+7ihDwaad
	 2ogx1sYQqiPPwmqMAny/6zTX+/QzVrDuZsC5Ok3sVSRq/FE+86ymrA83rm6vE87Laa
	 YWi8qZBOe8nHw==
Date: Fri, 27 Feb 2026 14:16:44 +0100
From: Maxime Ripard <mripard@kernel.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
Message-ID: <20260227-proficient-crazy-dinosaur-d2fb0b@houat>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
 <60ecebf2-a708-4797-bedd-588c3e9931ff@kernel.org>
 <20260226-impetuous-analytic-jellyfish-d4a86d@penduick>
 <CABdmKX0KZLGaJWBoo3tkCxLvby3f4Fn0nMCLyz4a-H-9J_CtPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="5ak2rz3ozdmtomty"
Content-Disposition: inline
In-Reply-To: <CABdmKX0KZLGaJWBoo3tkCxLvby3f4Fn0nMCLyz4a-H-9J_CtPQ@mail.gmail.com>
X-Stat-Signature: oc19ahfkrifkinrsencu18icfiddwy83
X-Rspamd-Queue-Id: 7C0502000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772198208-500362
X-HE-Meta: U2FsdGVkX19BTx2OF0Ml0PCpnNWKQ4+k6GDeDUko9SWxTKL79JrQi3kOLe95cgihAnMw3VMUVgm9KqGuNZ92ytG7bHn0lN24jIhABYO9P3HBzJ5LpuU5/KrhA5l7CLhMgC5WGZK704CxtJKoSElglc9FQsN39kcWnEgP5k6WAHf4mjG7YKef53u2Rw8YdLEYZMJp2HPp0sVub8VW92OAvhDiZPmAjUPV9hyLAkxxhhlYQkMQmUr12CDdrkI6HKTQnzb1dIpVK4zHrG1c1PidbCRmGU510+hdLVbvuatJPan8OyZtpWb0GGDE9zVbtUuqm6uU/qkvMoSnbXeIzXZfS3x3Ij/8DrxgBdOkD6hAQj8xsFXXeGPUSE04OMsc8pugBxycgsLJLak5COVJoGR2mph5ZS+IaJJK+ne2wUUsmRtE4UE+MlDRzAs7peIVy8jfVy8679BzNtQ+THnRk0SlzoJHanywe3DSeJt3AQcG+3MZ+fnUHBPX1od2fiP/qVb7uxct3V3NtZVzZfa2T0f+7xFrmVqqUl8E+xwUPrz0cdKpwSdPmsU+tSCsawRAmSIyMiNps/tvDENXAvl8XqEi8mar/8tSUHcD5HHBVbAhjDmX7ITVRuNCOsZdDohFH7PsOl411k05qT4Uck7BqDjvsqjEPTmEnIEJREZKfSYsFesc0z1+WEiaT2od7rL9MBGXVs1bYFBEK8U7V0iI3eC/vw5DJxQ6Ub1yDDGdAiyirta9fZaBQky17Tn7OkqnAxAERTz/+I7jakQuQcNIRQZxnGcgcLctum+cLCSiLAB7xLU+ks8+RHDmRgV2QmPeghWTugamMTF98dxNoN5OqB09+xA2rJRSObWfcgqKIbo0sybaCUfE1X3elcq1Xt2ILYR5+f8mRnOHM2I4YHUGFpULCfbhV+O9acUfuu0PPsCEbcWsG/PlFlXqkxO8YZba1wyQV+zNmEA3Sm7oubpzORD
 9t2IJZlc
 iaLRUNxKKDufx9UvafoUZRDoBruyqxaDAsWpPUMpEo5ClFyq30DXLU+3NHXrH9XdjeEv2hshO9lpP+utCYbWbguDKDw80282r/Rq71JR3aoayjCyfx/1SFmsI6UQVgrSypebBsJIROPRnsAqd+aohsE0J0I1pPzVvt08QZqmxbJVrCKWJMZBT2RPrTLYwTRrayaIdTZpRVkVighmwMKg0nH/N6NsZSBnECgnx3lKQuUdhSmpsD7LRskFcX61tMtoQOhcd9ARWRcxNE6Rm4ygkxAOPmIbbhyTIoVGLIDPk73asIkA847YFQLikbYwqD8JrvfVcEW268BLbqbQ0puWMpQ/W97w1p+SiwDmXYkZVFQ8PKtgjBzQXmHsfBBTRmWmcS8sX5slIR6U/011nDAOT5/QEs7ux/oWxk5RqRu2NDZpueHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--5ak2rz3ozdmtomty
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
MIME-Version: 1.0

On Thu, Feb 26, 2026 at 08:58:51AM -0800, T.J. Mercier wrote:
> On Thu, Feb 26, 2026 at 2:38=E2=80=AFAM Maxime Ripard <mripard@kernel.org=
> wrote:
> >
> > Hi David,
> >
> > On Thu, Feb 26, 2026 at 11:25:24AM +0100, David Hildenbrand (Arm) wrote:
> > > On 2/25/26 17:41, Maxime Ripard wrote:
> > > > The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate=
 and
> > > > free, respectively, its CMA buffers.
> > > >
> > > > However, these functions are not exported. Since we want to turn th=
e CMA
> > > > heap into a module, let's export them both.
> > > >
> > > > Signed-off-by: Maxime Ripard <mripard@kernel.org>
> > > > ---
> > > >  mm/cma.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/mm/cma.c b/mm/cma.c
> > > > index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7=
d8ba4397f018f6993d962 100644
> > > > --- a/mm/cma.c
> > > > +++ b/mm/cma.c
> > > > @@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsig=
ned long count,
> > > >     if (page)
> > > >             set_pages_refcounted(page, count);
> > > >
> > > >     return page;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(cma_alloc);
> > > >
> > > >  static struct cma_memrange *find_cma_memrange(struct cma *cma,
> > > >             const struct page *pages, unsigned long count)
> > > >  {
> > > >     struct cma_memrange *cmr =3D NULL;
> > > > @@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const str=
uct page *pages,
> > > >
> > > >     __cma_release_frozen(cma, cmr, pages, count);
> > > >
> > > >     return true;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(cma_release);
> > > >
> > > >  bool cma_release_frozen(struct cma *cma, const struct page *pages,
> > > >             unsigned long count)
> > > >  {
> > > >     struct cma_memrange *cmr;
> > > >
> > >
> > > I'm wondering whether we want to restrict all these exports to the
> > > dma-buf module only using EXPORT_SYMBOL_FOR_MODULES().
> >
> > TIL about EXPORT_SYMBOL_FOR_MODULES, thanks.
>=20
> Ohh, ditto.
>=20
> > > Especially dma_contiguous_default_area() (patch #4), I am not sure
> > > whether we want arbitrary modules to mess with that.
> >
> > Yeah, I wasn't too fond about that one either. Alternatively, I guess we
> > could turn dev_get_cma_area into a non-inlined function and export that
> > instead?
>=20
> I checked the history to see if dev_get_cma_area was converted to
> inline at some point for performance, but it has always been that way
> since 3.5. That'd be my only worry with un-inlining and exporting it.
> EXPORT_SYMBOL_FOR_MODULES sounds like a better way to me.

I just realised the new tegra heap is also going to use cma_alloc:
https://lore.kernel.org/dri-devel/20260122161009.3865888-7-thierry.reding@k=
ernel.org/

I exported dev_get_cma_area() like we discussed, but kept EXPORT_SYMBOL
for now in the new version.

Maxime

--5ak2rz3ozdmtomty
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaaGZOAAKCRAnX84Zoj2+
dqUlAX0VyCWn5CEtDD/d5NgnlGbw9KsIwryYjK5R5t6xQFatxl8VgXaPSTMj/TUC
FboTTuYBgI3AtXRp7wzZaBm9GIM0NkjXj8o4AB9rric8F0GeL82ApZqBGuoJreEV
DfrgHnsiFg==
=HATT
-----END PGP SIGNATURE-----

--5ak2rz3ozdmtomty--

