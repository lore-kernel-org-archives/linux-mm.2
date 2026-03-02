Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4906C624C2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275FB6B0005; Mon,  2 Mar 2026 04:19:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D5E6B0089; Mon,  2 Mar 2026 04:19:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177366B008A; Mon,  2 Mar 2026 04:19:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0736E6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:19:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A472C140A15
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:19:22 +0000 (UTC)
X-FDA: 84500574564.30.3B1333F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E85E91C0008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:19:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jy20L4Id;
	spf=pass (imf20.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772443161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mk3y/x9p2TtRVwmH53jJsXhWae/fhVJ1P+9vbP73RSk=;
	b=WO0zn4uvFV9iY13Si91sNKL5AjxahI8nvPJhXgZ3Y3dtH5wg0SkEWWq9qeD7EcxPV/Er/C
	daQrVqkQGEPDmYesWc199+Z8kReIJL7lQlagbcv47JAIFKQwFitliqprzKVf6U1pEqCmit
	SuQ7nH1GfuxKYq/iS2fJGRKtopRb9r8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jy20L4Id;
	spf=pass (imf20.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772443161; a=rsa-sha256;
	cv=none;
	b=BgLTlGAWDqMlgS7Y7J45w6oqi/twqDEGcIGVQYlYT0A99Leo8zUJZmVI5DXiGGBAXf7JhF
	EZ8qpdoG5Nkn2G2cO7DnPf35MVCP1imXainj0tavE1B/DaDsXI3//CdoLCCNvQPDLXwdej
	IZsNwCINOH+FZua1kgojtYF5ySpml3Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D58443220;
	Mon,  2 Mar 2026 09:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F036C19423;
	Mon,  2 Mar 2026 09:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772443159;
	bh=TaaPRzIzsiJYCDrLVRH+cpv6R+qksPRRJnPucWJCJnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jy20L4IdLKDTKoVZQQplQ52NEMl1acstjLIcsyA3F/3VBPZyXDttoIxL7TC7C3Y15
	 LweIa9LyHH5q6gmi5/iRz2CC7fN1udYPQ2OiopniwlmgyNilUn1QCMSmXAA3ccbXP6
	 lYbf1HjVAKSY5skXVBd2hIYCLZakSEZ8Z98i08TyYdKTDLrSYLOcWwPFUCSueJrh9M
	 w1vKDzKQfBn3fQZV4WHHsA29DaNZGgH1yHACqbLunffygCzcVFlm0fuGorhxSYtezw
	 DFlln5IO18wQ694ztJi0IbbdJJZMlZd/lsPfOmWBaBtOW+S+FBLm/vkSRIITObml5Z
	 dMQNK4sJwV4AA==
Date: Mon, 2 Mar 2026 10:19:17 +0100
From: Maxime Ripard <mripard@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v2 6/9] mm: cma: Export cma_get_name
Message-ID: <20260302-unbiased-chinchilla-of-honor-0df03d@houat>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
 <20260227-dma-buf-heaps-as-modules-v2-6-454aee7e06cc@kernel.org>
 <ca2ada49-08cf-43e6-a857-85994374549d@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="b3uwsakrtltovl2y"
Content-Disposition: inline
In-Reply-To: <ca2ada49-08cf-43e6-a857-85994374549d@kernel.org>
X-Stat-Signature: w1m4fmowkhtxhq3puu6dez43sgmh1yep
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E85E91C0008
X-HE-Tag: 1772443160-629071
X-HE-Meta: U2FsdGVkX1/1P1v3TwA2Z6jBgfJVynuCenEro8hangC1SWkD1E/nv/VhRNgdXd8qGorx8I+p59B/wz1B5dPUeueMtCcFQvOcLGOMgZm94N/we5pi64GzM8Jl59R+sh91P0WZyw3r5e1pblAcCO4HmAoSMhyDu25h98L1iO9OeDAEB7fPnGgn+gPRkHBmE1lJKW6YCGtYUHtNOAF7z9smxpWkMwc2obivTe5MwSB5I2ewREwf+ybPYL3fiAKCsVild1Vczd99shHGyUIKGyysMeyyTL3QZnymwA/eTF2cRh96qtaEiUpyxOm4X/2sAloIISWoC3VFFRkSyv5lKmNcS08yZb16lGUfo1fniG1E3I6vKF3CYASIwJQi/8HnKSqRCqcCgCA+L3hGzk/+Ymm5E25mAx0LKQF6lmj3jcazlb9NH26/ldGKMg4gmvj6a3qoCgn/7itqJehBETwcyo5iLpQ7NkMmBORwZYabTrkKZ9YionvlkkZcRbA9JtLFDpMyaBFNk9JmMEOt/gRSJWsSxlV8pwriZFLbp+6zGPM7UvxbaYmewbKtsQaWY6l3lkxGyMDMrvfL44WvuS1velYMgwMkqcqyeITeCPh2I4xmrwabCud/PXY6hjJUW0olac4Y+pqGS4XVC9+TBsd+93POP9YRw86dGfvJCtyHLQ541qqmpOt/eGin1VqJ6QJsJsFfPrtBPcCHkKgtJeKmOTLqcndulIqPJnvcq3peoJDYd2mTnDhvS1QPxUwWrzu5dmE8pwVToG68Ked2tI7h8IEN3Uzq+lS50iVmPnrIJ4CauN9TKMFhs3GgHp755GZRd7dDnRRJuxsormLW7GDsrxgNtS6N06KRCXjonhm427F6WD2dznd7nloaCoGbRIO+VFf2WDUxMVaoVugX29BDgBbiROldzH/qLDICtxqT6pUv2FCXDdUeMcIRD7MDsZs1+Q3Em6cVk+2Pvesfgac624z
 DRnh9eqt
 MYvccYckXBvF2P1NPCeyFfz0IPfmcNrR1djtQaOgHFOGthtNVnFIeoR4jp7iVmi8MwSEVPRrnFJ/hwQrT1FxQ4/pE9AeO4C6FMVpj3Rkc1RRP1RKN5d7u10mKEYq226U9dVkZ3zZJnZYPOgbC3WwdqVWqx0S9MSlVoQLKDDNv+F0ScCt7YvhiZUlpy+uG31xUxTNN/UzRjFsIGg0EH3s5iRHIXgI84mqWypb5XXkvL3gJKAJR6GIJ5HAeCkwOlDOdKNlBIflN1C/kGJ9XKqoDqU9Pjs+0QUOczkxlRbSEqbx0THGYwHRV7LMR7P1XeqxZIQTsGfHga6NS3pgkFJlq0yJxijpZnGp8lFmj0S2A9MCdzIV+xOsJ4+jTU1YlTHnBrxlsRm256+s54OsKTJ+9R1Tm3/Wo3oHpVmJ/LOPbOny8U1xVApt5UF2X4VWJyFUJuE/s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--b3uwsakrtltovl2y
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 6/9] mm: cma: Export cma_get_name
MIME-Version: 1.0

Hi,

On Fri, Feb 27, 2026 at 09:43:12PM +0100, David Hildenbrand (Arm) wrote:
> On 2/27/26 14:15, Maxime Ripard wrote:
> > The CMA dma-buf heap uses the cma_get_name() function to get the name of
> > the heap instance it's going to create.
> >=20
> > However, this function is not exported. Since we want to turn the CMA
> > heap into a module, let's export it.
> >=20
> > Reviewed-by: T.J. Mercier <tjmercier@google.com>
> > Signed-off-by: Maxime Ripard <mripard@kernel.org>
> > ---
> >  mm/cma.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/mm/cma.c b/mm/cma.c
> > index be142b473f3bd41b9c7d8ba4397f018f6993d962..550effb9c4e01cc488b5744=
fe61d55a5b70a6d6c 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -50,10 +50,11 @@ unsigned long cma_get_size(const struct cma *cma)
> > =20
> >  const char *cma_get_name(const struct cma *cma)
> >  {
> >  	return cma->name;
> >  }
> > +EXPORT_SYMBOL_GPL(cma_get_name);
>=20
> No real reason to not squash this patch into #5, right?

I was assuming it was not really the same "category" of the API than
alloc/free, so the reviews might not be the same (like they weren't for
dma_contiguous_default_area). But I guess it also makes sense to squash
both.

I'll update the series

Thanks!

--b3uwsakrtltovl2y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaaVWFAAKCRAnX84Zoj2+
dlFeAYDD9X9Vv/iM+aCL1lvTjD+K8ui/7OeGWlPDYDEF5o8UD5uVMHs3IY6BHmA1
KoFaDiABgJ1s+qzY07V4RNSom5YMw3yvdtgLOkUoHeCUwOCbz2vqhwSWpT/dAmyd
6eWOH1SckQ==
=KM0Q
-----END PGP SIGNATURE-----

--b3uwsakrtltovl2y--

