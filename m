Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB634FC5927
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D036B0088; Thu, 26 Feb 2026 05:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2DD6B0089; Thu, 26 Feb 2026 05:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFED16B008A; Thu, 26 Feb 2026 05:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD3026B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:38:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C3FF1A0AFC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:38:51 +0000 (UTC)
X-FDA: 84486259662.24.E3E17F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DDAD940010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:38:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IoUxF9Ix;
	spf=pass (imf17.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772102329; a=rsa-sha256;
	cv=none;
	b=jM0p7jWOh4Uu/faj6sXxfa15FdcPPqiTAG7x+2WWWLfN31470n+PxMcjX29o01lAGZkd2D
	6/L/u6FahDkjRDyOxchgAHQkWI1s2IrJWl96llfmSi5RYzyJgd+xnspxYrNckhd1neH954
	1zHeTqBiKjb6DI+gxt1Z9909COyeKyQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IoUxF9Ix;
	spf=pass (imf17.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772102329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzdETfk1/rH8Q4u5UfAUK/lzdcfpsH5IbB8f5XAtcJg=;
	b=rePIfhPg9UOkW9Mu1ri6vWtfjfQnArl4xAxvmeke/HPq4s9bt3mxQgXoY/PfqPbE82XtVo
	1USF1xJa/N33OjDVJKvkGmfosRE6eFH6vBNjypc5rMjjpIlgmrJaWKtvF671zQMXBxheP7
	vvub/8v1LfxA15f90ja2g6AhMYjDfCg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29F0560054;
	Thu, 26 Feb 2026 10:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD58C116C6;
	Thu, 26 Feb 2026 10:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772102328;
	bh=3cOwLR1yuzDPYHdlDaDVoK2pdPAwkELvu6I0P5vN37I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IoUxF9IxL7VVwAVoDntFnPAkfIWSHLhW91I1Vc9LOXHqb0Uv5XdMWsOeuNxkKOlnd
	 p3Sff2GOZ5ehabP7i/+BXiG0zYbPB6Arb/3mKU1+a/mWv5bIGqvClieRUtEppXthcQ
	 0H1WxNy4vKo21HkfKSYGPedzAB3nFwQ5J9qq0GHfEVX3acOJCbuDcs22o9CnL8xt/E
	 Fu3qNKVpZNdN/+9W8xTGnDVmZijhJcBEN+zPVPD/jByqSvdOseSF8hY0L0kC0Jh1cX
	 Kwd//qtejF+Wfw2gU6Db0AKwqmLV95mktrlNEV5tSKpS/hpQXsXe73uO29EgtHgVcs
	 RRhzUDaq86Bvw==
Date: Thu, 26 Feb 2026 11:38:45 +0100
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
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
Message-ID: <20260226-impetuous-analytic-jellyfish-d4a86d@penduick>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
 <60ecebf2-a708-4797-bedd-588c3e9931ff@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="4m3wi7hiurafpqag"
Content-Disposition: inline
In-Reply-To: <60ecebf2-a708-4797-bedd-588c3e9931ff@kernel.org>
X-Rspamd-Queue-Id: DDAD940010
X-Stat-Signature: r94ir8gnhp88nikqet5z5pteqamgezze
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772102329-322745
X-HE-Meta: U2FsdGVkX18XvlEvfVhCuqDWR7MFODYR0Jxtw6ijmYI80LBuTVdlkVbFNUwnO2vTRDor1yPvRoTh4QVhuCU/qZig+PoFmByhXl38KW0A1CTBOTmrpl+VpmCjYQq/p+tjdzLOPqLuosZxByYVtuF3OAtV1N+lwSGFJN8aBHE2KqLAL7EJXzoDtgSMsO/4yt/EloV4nf8CmgQxj3Noc8wwBo0bsrgj1oXuOZO/xZPdTaHvY3LRQTRaWg8/AT7dOugH4PK4zAa4yLHenlvSZBZlLIESOL0obLRMYCTBcvpdW9+YBZk40mhB7hnYjhrUZykcLgOLsI0FfjItDlh5l08lkx8ISb0uc3Zq8lkMvtDAE6O58YPMar0ICAiAAQr4UIDROPaVjN3ULZgxmc0stJpX+3yh6zG+kuHNCz36CrskHJSPWjBDuFqdMTSiUzd4h1J+ZXWqzCZP6kFhOkJfsyQizD6kfOE2D/lUNckPz6PGC367ORNB+TyfFC8FNu7Dn9+rT/jkO8Zu2MbluntnOWD9DnTI7Pm0pHTcW212Czhc8WGuXeYKh1O5qx05l/gmQ00P9DXduJgnKmsd4eSAI4cZPl1DoZaCPaziF+3hD7PlYLbfY2/6PRDI6ZrrrfD4I/VPcalYRYZnTM8mrjLD4VymXJxBhXBd7HfKIN0Xm2B3+VZ8Is8JS/lu7GfcvLLVnQunvMWqrt4saSgdcj6yLxbsp3ckXSoKK275bMMjMBNJ+rHHyAgiueP9gAaPl7tyVMO1kj2VI6WIL2lzIg2VyZToB3ACLEb9VlgeNNXrQvX/1m6zPUzwxybk8rlqiRHytmr/LMWszm5Uu+pUG32vLTFgDmEGCIYVG5aNxoKnEYY9SZ1cirl2ZBHB2Jn85Ug/qOOE0ATRYyoXmWa8qrI2ABaQB2YpZloF2dSYefNlWSYpqrKzmOXQwyRdxCHixDYdQXfQbaR02ajksbz5jNwVHbz
 OXeoRgu3
 PwZcvlAuwzSjgPvrAY/OArQGbiBg74Oua8FgmyuW4FBzvGXQdy1yDAUNEDsE5sWI9GBsXvUfxUEgFVKISdLK3IASc9xdZPBfbdPF9XFnVqLjhjoebzgUllB4u3p9Wb9eXW0d2OJmcopudoxPToEmp4OUHt0xDFfRFGiVojHYX7rCZMyAvZv87rtWG/0kfOiJ6UzWoM9qbyhAXFVWvgKVVhGoViqKZ4udo35Hf+g6JtosJn2odgV6SJv+hdIAXZzcTHE9ZbPPIaf6eKkopMEmPYZ6VbeMDpc5FN9YFyl0qdU5fHK5DM9yHDPPQb50uSR9QxRwIiWm7OtG4Cd8AMgyiOPniSOS3XHpTkugQTZJ+G6G0QY/Q7+1Z4MFZAp3NN/n8yNNMvPw85oSe5riq29eumNF84DYtDmIksFTitCMNSD/Uhsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4m3wi7hiurafpqag
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
MIME-Version: 1.0

Hi David,

On Thu, Feb 26, 2026 at 11:25:24AM +0100, David Hildenbrand (Arm) wrote:
> On 2/25/26 17:41, Maxime Ripard wrote:
> > The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
> > free, respectively, its CMA buffers.
> >=20
> > However, these functions are not exported. Since we want to turn the CMA
> > heap into a module, let's export them both.
> >=20
> > Signed-off-by: Maxime Ripard <mripard@kernel.org>
> > ---
> >  mm/cma.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/mm/cma.c b/mm/cma.c
> > index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7d8ba=
4397f018f6993d962 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsigned =
long count,
> >  	if (page)
> >  		set_pages_refcounted(page, count);
> > =20
> >  	return page;
> >  }
> > +EXPORT_SYMBOL_GPL(cma_alloc);
> > =20
> >  static struct cma_memrange *find_cma_memrange(struct cma *cma,
> >  		const struct page *pages, unsigned long count)
> >  {
> >  	struct cma_memrange *cmr =3D NULL;
> > @@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const struct =
page *pages,
> > =20
> >  	__cma_release_frozen(cma, cmr, pages, count);
> > =20
> >  	return true;
> >  }
> > +EXPORT_SYMBOL_GPL(cma_release);
> > =20
> >  bool cma_release_frozen(struct cma *cma, const struct page *pages,
> >  		unsigned long count)
> >  {
> >  	struct cma_memrange *cmr;
> >=20
>=20
> I'm wondering whether we want to restrict all these exports to the
> dma-buf module only using EXPORT_SYMBOL_FOR_MODULES().

TIL about EXPORT_SYMBOL_FOR_MODULES, thanks.

> Especially dma_contiguous_default_area() (patch #4), I am not sure
> whether we want arbitrary modules to mess with that.

Yeah, I wasn't too fond about that one either. Alternatively, I guess we
could turn dev_get_cma_area into a non-inlined function and export that
instead?

Or we could do both.

Maxime

--4m3wi7hiurafpqag
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaaAitQAKCRAnX84Zoj2+
dn2RAX40ENhBNNnA9IVK7i0+qn5IsVH8v3M4faEFfo9IBr96Q8kfaeEhQLPJokV5
OD/rbD0BfA29oWhRpf5wZDuyQy8g1598nXD4qkmluGfS3ZE2BbGta/gjBRP5O3kl
YIcJ/SmxPQ==
=LmIK
-----END PGP SIGNATURE-----

--4m3wi7hiurafpqag--

