Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D22FCD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F8D6B0088; Tue,  9 Jun 2026 08:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7426B008A; Tue,  9 Jun 2026 08:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24866B008C; Tue,  9 Jun 2026 08:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B34AB6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:31:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1961E1A0516
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:31:30 +0000 (UTC)
X-FDA: 84860309940.24.24B37EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 85E7E4000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:31:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGN3A0SD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781008288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0BaS54KHmvaXv/vxGfu2k/i8IbrbsOc/M3Rcwgq7Dw=;
	b=rSBYQ5/I26BqINRGQhoSmFy0BozSRUc20xImjHjBwbN4ZIXe4oGOT84S0bDg324nIkOGF+
	rWbRR5mUVU8s7JMwsjhzgUdSCviX2doiqxARq5WGXeciK/KtGt5pukgdRvDl+D8LbCC9AH
	lb0vaVrx5vJ7F+hAYhtOcaEMG3vGgRs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGN3A0SD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781008288;
	b=2yI8lw2gAawefj1Lust/9z+7Rs+jV/bwlDJBqS20oU04GGLHmiOct9TFnzhT9pXv+QZG7r
	wiI/iWwpZGzk6sofLpUWgQDzJdIJJMIlVOLHbE+1fLSuIyMk5uaNP66n4+bfxj0tLwf31x
	07z+2+9w1p4JFoOTkmCyBZRFBjGgN9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D7F7601D6;
	Tue,  9 Jun 2026 12:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490E31F00893;
	Tue,  9 Jun 2026 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781008287;
	bh=U0BaS54KHmvaXv/vxGfu2k/i8IbrbsOc/M3Rcwgq7Dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dGN3A0SDVSKqo2u1/wQ1/zVpc+14ph63BVOcD0I/vMtQr0hMIYhCoXkbL3y4aG7DW
	 V8KxpK4g9iEEMonj89HX9vwHYAGVSAtrcdef4mDz4zC6vM2OZyNv9qL7Q2HRAOnxlp
	 DDQzpPv8YcLrfItttOb0rtHpzrNNoHrV0WslXokKvznC1rvg9SC60g/b5luQgq9+PE
	 JEPqg0CTcCGWslG4Ll+E8a8u++cUTkflEOYJ+gXXZA81xJPvTJxi9DYl1ZrT1oNiHk
	 QZXLXVpk4LrgnJPKYn2yz81/1kKzPW2V2wEBgkYL/3Q34Fqo7uGPmNkWThn9pk7CaT
	 oDi6N6dqKuPig==
Date: Tue, 9 Jun 2026 14:31:24 +0200
From: Maxime Ripard <mripard@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, 
	Christoph Hellwig <hch@infradead.org>, "T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, 
	linuxppc-dev@lists.ozlabs.org, lkp@intel.com, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, Arnd Bergmann <arnd@linaro.org>
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <20260609-micro-pogona-of-wind-eab41b@houat>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca>
 <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
 <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
 <20260604135712.GV2487554@ziepe.ca>
 <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="o22bjoh6ffgpsyxy"
Content-Disposition: inline
In-Reply-To: <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 85E7E4000E
X-Stat-Signature: kw9kyamiz3bynjci75uw3pek6pqmggkz
X-HE-Tag: 1781008288-378055
X-HE-Meta: U2FsdGVkX1/RvBySRojlKR9eu0W90ESzcbYnD/KXfLTvDRaIJj5/MXDsbmGZJBRPRvilwi0HjmPBHs8h+iFCB48vNSiGLsjgF/eaEKAvLvCnUWJc49w/DtVyEv8ek03VpTF9tDyXp/1xUVSyjFBKvJt15cwaR3JK4/seblVx7ZU3+rfz19KuDF9O00Y2PCUASc+KAFPRo1Noju8+cBethpG4eWM2rEaG1Kf7NQn9740XjCgk6bAU0lclIrJnFUDjfPAYxG5tasUYVohIhkH6G/eZynaUK5v/RRbcJr6L2Ud7Igs5M6urvYJkAmhr3rWmLPeD1TXzCoPVS3BCadQ/tpknbUeyfeJI/tvkHTQf6NeoBURhxbVNSJpU4FoBtK9c/BxWjm+T+ndq2aP5tiucdsopC1JhezxSzTgrHweFMCQJanQ8p8murx4RBSoER62coseAeV7Fii9wRn9iLNAdmIcluI8RaFAnKVmtIilBbRrxUnCjaPmpY3rlwnDHMoVKi03z87KgpPIS9YHq0KLXFoYBcWMqrlMIDbcXDpknAe6ZBYEsKv53cXBkbZm9FGqRuqG3oOX2EPok58c9C3P1/POZ0X9LlFfPavbFZUxSKmUbIv8qUoJxqaJt/dHVpB4wXsEpZ0vrPfj9SFC1jyx6M26i9fB3/ixTNJHm6Kq+OkHQ9SJyNNcgHoPRJTOmTKzAZC5qQKfe734Z46SaBWgHY2Zpg3ectk7SygvUC1scTb+Nkc6hvW9waqG5wK57uIDMCzTJFbR15myoY1nyIvqc+o5UZlK8Re6HbEv3lwFUo31uWCfVQFkxjnipLwhCZrxNAr/x8t7d2jY1TDunZRGS4PZsM9yzi6dQzgVeDM0LZtODzE5jcc4/1RnD3sasq4mdfNAF5IE0EK2m9cen0SjNywxhMxRw1xDh6wEb51gm0irtpnE20fhCAafjPGKaBSs3FdA6lDglFmew7SoEWhc
 7SRIormg
 pmKpPFdHbrwa5g7Rd1f1GSEAN1OyYspa3lMLBgh8bY/ICjuW214tfXeh5b4lFWC1KGiiPseQSedFXSMXGUCRd6CNl2masC88PKGf55T2cYdCo418SREp78URy5VSKvnzaawkwBuykqhcEL/hM+7iun1+uyQajEjOOommae4xhLzCYm7Et7zAosH5r8ZuHKLJTHL8yWNz/8V7slcBq5gCiD4CUbUdqNgRnaD1hj8ZfRMtGpV+nhsCJm2JT76S9hsF7A7PypTWyb8sElmOimkz9/d/CaitphOALPKnsIEOilU+oFAHZ7rgdHiVmFmW6jT5/B7seQUX3nzZXiiktX3J9HmVpZHqOtN2J0lDp4EpXqoE3Mi6VJN8AzPN2IoDbofKd3QNYkvIXEJxhplQ1wAYuzA87N43C1l3yaGpuxGHq2ulLucle3x3Q66qp8gWWppIeuPUvXBSGCL35EPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--o22bjoh6ffgpsyxy
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
MIME-Version: 1.0

On Mon, Jun 08, 2026 at 08:47:15PM +0530, Sumit Semwal wrote:
> Hi Jason,
>=20
> On Thu, 4 Jun 2026 at 19:27, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Thu, Jun 04, 2026 at 12:51:49PM +0530, Sumit Semwal wrote:
> >
> > > Given that Christoph's objection is not really about the modules part,
> > > but that the set_memory_{encrypted,decrypted} should not be used here,
> > > one option is to revert 78b30c50a7ac until that issue is sorted out?
> >
> > Please no, we have stuff already using this so it would be a
> > functional regression. Revert making heaps into a module since that
> > doesn't have a functional regression.
>=20
> Thanks for your comments.
>=20
> To me, it looks like while system and system_cc_shared heaps share a
> lot of code, their user bases have different needs. It's apparent that
> system_cc_heap users don't care about it being a module while system
> heap users would very much like so.
>=20
> I also discussed this with Arnd, and he suggested we could rearrange
> the code so that system_heap_cc_shared_priv depends on a new Kconfig
> symbol like
>=20
> config DMABUF_HEAPS_CC_SYSTEM
>         bool "DMA-BUF System Heap for memory encryption"
>         depends on ARCH_HAS_MEM_ENCRYPT && DMABUF_HEAPS_SYSTEM=3Dy
>=20
> This allows building both into the kernel or leave encryption choice
> up to the consumers of the system heap.
>=20
> If this is agreeable to everyone, I can post Arnd's patch.

It would be the perfect compromise, thanks!
Maxime

--o22bjoh6ffgpsyxy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaigHlAAKCRAnX84Zoj2+
dvQjAX9ms+5hiJAqLxOa025CX1FKZOt3A7bbVhvzSW0b67H16z/faZkoRrXNZzHG
FzjVGG8BgPW0Xyovl2KeSzQ85rYqIeg+8H++YPYve/0/YEmMBjN+LF51bW0Wp/ZC
DU4p8h04Yg==
=jwe3
-----END PGP SIGNATURE-----

--o22bjoh6ffgpsyxy--

