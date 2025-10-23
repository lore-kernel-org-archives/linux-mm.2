Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A16B5CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 17:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFAC8E0012; Thu, 23 Oct 2025 13:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087F58E0007; Thu, 23 Oct 2025 13:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06A78E0012; Thu, 23 Oct 2025 13:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDB328E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:58:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85ABF890CB
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:58:49 +0000 (UTC)
X-FDA: 84030139578.07.4CA0100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B81D6180006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:58:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDTdakLd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761242327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Om9jVeVFdyMuLOP4QsIv5RTSgj0lNSoXOFL0vvdZMWw=;
	b=npBb1c9OYLPaZ2nHJtrbMMgQvHSjfC5Alf8dMeuX+ERWphxeHP+P4v9bqvqXgp/g0vwZbX
	UNNXiGydyGAoEj+kjHViqqe9rTulvMK7xCJWUu7Bpw4V5D97t1ej8b3DGxqE8SzY2BYj+Y
	xSKZhdKsyjrwT3NdjCLbCuE11fLgKsI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDTdakLd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761242327; a=rsa-sha256;
	cv=none;
	b=L68rF93u6CK1yBdFqrGvYcbf7v84b8a75i7gMXr8NmvhY6/slKf6H9S0lzs/qRu3uE3V4f
	P9Cj91MpIDJsTyvh1kR92DpSQ7zxj3bGW/yuicyd4JbkCAdlEYa4R6k6O1aaXDZ/nrZx0t
	7dq50+7S6D4iDZRJ6uiZZwHGwIr3dS4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A98A48FE6;
	Thu, 23 Oct 2025 17:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA94C4CEE7;
	Thu, 23 Oct 2025 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761242326;
	bh=5hAOPFF31Br87tc4UVkXvHPCgDvT6CIduQTFGMHxSPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uDTdakLd6r4OY/6r0TYwuTZhmdhNg2OhLQDP2C3uQ3XUgwySj+IJi+7+CmAL5hQ6w
	 y6iUK4JWwKvEI2UdtHgJS0luBhA6IuKpfjvOWBV/FuZkVajJupWdcYmMuw5As5SXG4
	 Br7la0e/j6E4l0QNp+6JsNe0yQj+pkGqBdGQwV1EqWmr40nMP/gRxeAGk7RaajnoOF
	 PweXScgF8r5sbFjuDud1HRNrPLLDYY5oHcORI5tcULj793gfN9R9ApMEijRBQLkhHy
	 2q9jr+HBXGRsm7/oSBXylk+xwb2ytkiIsneSJymDHwSgstU9gGPFylwtMl0Pq+oYtL
	 qpEn5iNE7k9sA==
Date: Thu, 23 Oct 2025 18:58:39 +0100
From: Conor Dooley <conor@kernel.org>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-cxl@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, james.morse@arm.com,
	Will Deacon <will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
	linuxarm@huawei.com, Yushan Wang <wangyushan12@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v4 6/6] cache: Support cache maintenance for HiSilicon
 SoC Hydra Home Agent
Message-ID: <20251023-deacon-freedom-91064dec93de@spud>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
 <20251022113349.1711388-7-Jonathan.Cameron@huawei.com>
 <20251022-kite-revert-2c2684054d05@spud>
 <20251023124914.00001005@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wGeFqUtAjCRVjVMX"
Content-Disposition: inline
In-Reply-To: <20251023124914.00001005@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B81D6180006
X-Rspamd-Server: rspam03
X-Stat-Signature: cmg19876f4j4pwjbc53icqgjwwz9kqbi
X-HE-Tag: 1761242327-253972
X-HE-Meta: U2FsdGVkX18EVnljSdXQMM15uFhLUN4tMPy4F0nT7tl2YOim+ggB2sFesQ7Kn88KIGIb/vPuxZTprEgY948rwI9FNy4SsACYszHme/U38lv82hMX4Z+B49Rmxpnpr8JpRqC9kbftKE4mtS+BtNFKbti1SIzz4eC5CVdfydc0/46vUCqYgSwCoxsAMvkER5IVK9+2n/VPc1oelr2z+AJySngnc0KdqqO94QCWZ927As+7PkzPfIFOnvDpazMTwnuuXZZRiNQ4/dA/ueadmoFXFiGykB7d3PsfvfGh51WB3tMIel/oQSgVkR9Aargtd8BcPiwGUf59S9U/xBsce9cEqK0lVN3J2CWtFhq8ldEGYRC79hJx+OFLnf6ZsncYba0BmUpujH6eQoLM7k4c6mRjFBsMBWZvxmfbDZ1jRfvmazMBs5xd3EnEp4XrSVsjmBx7VOjaMezGUaZlvtOuwc52ZIS5+BJ3o/a9GWtCwqzOe3Olqw0aA+hNN0dJxeZTOVlcr5MHT0rAOkpknppmsZhRDmKrkbItZekuLMiX8X6GNCG2K51LBFfM1HDzWjDog0Hfl6bi1vfrg+K8XgO6OXCHp3+xIq6PFXuFQqtPFBy3bG3zTS1BUHM9jyPaZLD2pUUErXpZJoK/V0ViW77sJq0SRwZ1nmo1dZUiWGAQ9Z3P+mQncum5Xx8+hYG0BC+8U6YRilBH+asWWRjx46srQMg0TNP0oOGSAwDPFu668h6KQvCPQDRlzFN+1ximdC9cdtGQDY5Sa4YSj1QXKCyFTTFQOkXC6M8yMI30OBbIFOabgqkzEq7DzFeYZHPjzEtUHvFWVbQDjxrDkOp+F+FsSLEusB8/Lru9rrhQO7ULsqTEEp03NlKbMVfEgNDULKZf7u93zfUyICjOeKk5quZQyjEvajKq+zQkO17yRjImRecM8CqyaR9mVEVSZuLUei6vqgfzi+8taCtqDOn4ilcbCXo
 tn5zloBU
 N6r9dA0Z9hHAD15LOmrH6yT0/cPLd5G9QpvkFsBg7trwVYlaLqiQmyXu+a/zDInD0LT9vxxKIBx69UtgmgJHVuFykdi0UG3pb0ti49iHsg/LonZwE6dHQD4YwdHcW3bF92jhiRYLWK+Q1TIC4hTFJLAr8WcrY0zAFikAOyKdnL4FjLZU7d16E8W1rYq+kOqbe/FZC6cRnP9UBMv9nAi6Jh1vkDcKGYPczDi0kpuCIgx0fgbHIxCdNkgBtrQ7LHq/R3YYijzOloUjikBtm0q/AoPuOt3mfGKWAX2fCkH6xv+6tad6yGONuHeqeCwy1bbtJmD/tcyjpE9CgA3uNZyD7WV6gdNYA3fbU28U0k3BKdo85DwnGre1BtbZfdjczM/hqOZXF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wGeFqUtAjCRVjVMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 12:49:14PM +0100, Jonathan Cameron wrote:
> On Wed, 22 Oct 2025 22:39:28 +0100
> Conor Dooley <conor@kernel.org> wrote:
>=20
> Hi Conor,
>=20
> > On Wed, Oct 22, 2025 at 12:33:49PM +0100, Jonathan Cameron wrote:
> >=20
> > > +static int hisi_soc_hha_wbinv(struct cache_coherency_ops_inst *cci,
> > > +			struct cc_inval_params *invp)
> > > +{
> > > +	struct hisi_soc_hha *soc_hha =3D
> > > +		container_of(cci, struct hisi_soc_hha, cci);
> > > +	phys_addr_t top, addr =3D invp->addr;
> > > +	size_t size =3D invp->size;
> > > +	u32 reg;
> > > +
> > > +	if (!size)
> > > +		return -EINVAL;
> > > +
> > > +	addr =3D ALIGN_DOWN(addr, HISI_HHA_MAINT_ALIGN);
> > > +	top =3D ALIGN(addr + size, HISI_HHA_MAINT_ALIGN);
> > > +	size =3D top - addr;
> > > +
> > > +	guard(mutex)(&soc_hha->lock);
> > > +
> > > +	if (!hisi_hha_cache_maintain_wait_finished(soc_hha))
> > > +		return -EBUSY;
> > > +
> > > +	/*
> > > +	 * Hardware will search for addresses ranging [addr, addr + size - =
1],
> > > +	 * last byte included, and perform maintain in 128 byte granule
> > > +	 * on those cachelines which contain the addresses.
> > > +	 */ =20
> >=20
> > Hmm, does this mean that the IP has some built-in handling for there
> > being more than one "agent" in a system? IOW, if the address is not in
> > its range, then the search will just fail into a NOP?
>=20
> Exactly that. NOP if nothing to do. The hardware is only tracking
> a subset of what it might contain (depending on which cachelines are
> actually in caches) so it's very much a 'clear this if you happen to
> have it' command.  Even if it is in the subset of PA being covered by
> an instance, many cases will be a 'miss' and hence a NOP.

Okay, cool. I kinda figured this was the mostly outcome, when yous put
"search" into the comment.

> > If that's not the case, is this particular "agent" by design not suitab=
le
> > for a system like that? Or will a dual hydra home agent system come with
> > a new ACPI ID that we can use to deal with that kind of situation?
>=20
> Existing systems have multiple instances of this hardware block.
>=20
> Simplifying things over reality just to make this explanation less
> messy.  (ignoring other levels of interleaving beyond the Point of
> Coherency etc).
>=20
> In servers the DRAM access are pretty much always interleaved=20
> (usually at cache line granularity). That interleaving may go very
> different physical locations on a die or across multiple dies.
>=20
> Similarly the agent responsible for tracking the coherency state
> (easy to think of this as a complete directory but it's never that
> simple) is distributed so that it is on the path to the DRAM. Hence
> if we have N way interleave there maybe N separate agents responsible for
> different parts of the range 0..(64*N-1) (taking smallest possible
> flush that would have to go to all those agents).

Well, thanks for the explanation.. I was only looking to know if there
were multiple, since it wasn't clear, but the reason why you do is
welcome.

> > (Although I don't know enough about ACPI to know where you'd even get
> > the information about what instance handles what range from...)
>=20
> We don't today. It would be easy to encode that information
> as a resource and it may make sense for larger systems depending
> on exactly how the coherency fabric in a system works. I'd definitely
> expect to see some drivers doing this. Those drivers could then prefilter.

Okay cool. I can clearly see how it'd be done in DT land, if required,
but didn't know if it was possible on ACPI systems.

>=20
> Interleaving gets really complex so any description is likely to only
> provide a conservative superset of what is actually handled by a given
> agent.
>=20
> >=20
> > > +	size -=3D 1;
> > > +
> > > +	writel(lower_32_bits(addr), soc_hha->base + HISI_HHA_START_L);
> > > +	writel(upper_32_bits(addr), soc_hha->base + HISI_HHA_START_H);
> > > +	writel(lower_32_bits(size), soc_hha->base + HISI_HHA_LEN_L);
> > > +	writel(upper_32_bits(size), soc_hha->base + HISI_HHA_LEN_H);
> > > +
> > > +	reg =3D FIELD_PREP(HISI_HHA_CTRL_TYPE, 1); /* Clean Invalid */
> > > +	reg |=3D HISI_HHA_CTRL_RANGE | HISI_HHA_CTRL_EN;
> > > +	writel(reg, soc_hha->base + HISI_HHA_CTRL);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int hisi_soc_hha_done(struct cache_coherency_ops_inst *cci)
> > > +{
> > > +	struct hisi_soc_hha *soc_hha =3D
> > > +		container_of(cci, struct hisi_soc_hha, cci);
> > > +
> > > +	guard(mutex)(&soc_hha->lock);
> > > +	if (!hisi_hha_cache_maintain_wait_finished(soc_hha))
> > > +		return -ETIMEDOUT;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static const struct cache_coherency_ops hha_ops =3D {
> > > +	.wbinv =3D hisi_soc_hha_wbinv,
> > > +	.done =3D hisi_soc_hha_done,
> > > +};
> > > +
> > > +static int hisi_soc_hha_probe(struct platform_device *pdev)
> > > +{
> > > +	struct hisi_soc_hha *soc_hha;
> > > +	struct resource *mem;
> > > +	int ret;
> > > +
> > > +	soc_hha =3D cache_coherency_ops_instance_alloc(&hha_ops,
> > > +						     struct hisi_soc_hha, cci);
> > > +	if (!soc_hha)
> > > +		return -ENOMEM;
> > > +
> > > +	platform_set_drvdata(pdev, soc_hha);
> > > +
> > > +	mutex_init(&soc_hha->lock);
> > > +
> > > +	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +	if (!mem) {
> > > +		ret =3D -ENOMEM;
> > > +		goto err_free_cci;
> > > +	}
> > > +
> > > +	/*
> > > +	 * HHA cache driver share the same register region with HHA uncore =
PMU
> > > +	 * driver in hardware's perspective, none of them should reserve the
> > > +	 * resource to itself only.  Here exclusive access verification is
> > > +	 * avoided by calling devm_ioremap instead of devm_ioremap_resource=
 to =20
> >=20
> > The comment here doesn't exactly match the code, dunno if you went away
> > from devm some reason and just forgot to to make the change or the other
> > way around? Not a big deal obviously, but maybe you forgot to do
> > something you intended doing. It's mentioned in the commit message too.
>=20
> Ah. Indeed stale comment, I'll drop that.
>=20
> Going away from devm was mostly a hang over from similar discussions in f=
wctl
> where I copied the pattern of embedded device(there)/kref(here) and reluc=
tance
> to hide way the final put().
>=20
> >=20
> > Other than the question I have about the multi-"agent" stuff, this
> > looks fine to me. I assume it's been thought about and is fine for w/e
> > reason, but I'd like to know what that is.
>=20
> I'll see if I can craft a short intro bit of documentation for the
> top of this driver file to state clearly that there are lots of instances
> of this in a system and that a requests to clear something that isn't 'th=
eirs'
> results in a NOP.  Better to have that available so anyone writing
> a similar driver thinks about whether that applies to what they have or
> if they need to do in driver filtering.

Yeah, adding a comment would be ideal, thanks.

--wGeFqUtAjCRVjVMX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPpszwAKCRB4tDGHoIJi
0jkxAQDKgL4QVcRIzCo6G66R++ICwhllMamNHAZf8jmI/CO/EQEAmiVSOKVdfzt6
NvldkccfoWmDymH3aGdE/6ZlJtdghQg=
=K+jA
-----END PGP SIGNATURE-----

--wGeFqUtAjCRVjVMX--

