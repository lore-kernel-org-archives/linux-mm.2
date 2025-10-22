Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E0ECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 21:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB3C8E0005; Wed, 22 Oct 2025 17:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2D28E0002; Wed, 22 Oct 2025 17:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF9A8E0005; Wed, 22 Oct 2025 17:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0768E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:39:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F03F160988
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:39:38 +0000 (UTC)
X-FDA: 84027067236.13.9B3DA25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 959B8C0009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:39:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNWwA7uT;
	spf=pass (imf22.hostedemail.com: domain of conor@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761169176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wc5x1Gwl3C0XgAlO395LUopwk5B3TtKZafU21IA+ndQ=;
	b=FAPKO0gvB3TWGXi9qgW4TZ/KB1GaX7Zb+jmRcvBK2PZn7Uq55qRqkfp065nvSt8Ibz3xkU
	HoRfXIdbBVPt9ejSEgOJeGqexeRSkcXNr154CMF6yrPg2aDsvJkW1wBgghkjqN8OLaUszR
	E8hwc8SVGyOiHvYbdyn8MEu+iz56MEI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNWwA7uT;
	spf=pass (imf22.hostedemail.com: domain of conor@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761169176; a=rsa-sha256;
	cv=none;
	b=pnyCjoH5CxiKq5NK0h6YK/v0r9OK2d9Gr7XFxuvA/lGFe4s3+7tAU8nEJAzuW5wWzb374n
	jahaKeBHehx1fWH7+4Ui7tR3sg2Ywll8Roa6hKBlz1w9nBwK+qCwYr1mpLjRsFrW3XBYO+
	0HRm7pu3JLYgh8v/1XyYW69KekBIBF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C104663E1E;
	Wed, 22 Oct 2025 21:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0F7C4CEE7;
	Wed, 22 Oct 2025 21:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761169175;
	bh=fMnDUsh++hTRlW5dn4gfNo7HgWB7+StricBM3MTmevE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HNWwA7uT41H1QeC3nDJKzxGOAYopyZyz8wtaReHnMFNDClB7pEowhjPcwr/h555lQ
	 jVxtk2LwgDfOBrV2C1kpcI5K4L/QQTXZdNgUl0O4FXSwDIIJZ6hxJeud2yNdpiq/+M
	 8EJBosY1IHyBF2qbURoZ+X8CZjQ1U95UUYYKemkTqV1JzCIfJyset7oaAlrfKF4mF4
	 WbVDphXvbnCpZ3IipJhwoV0ZsefssffeUcgsW59U02F+Q8u5G2n+rXOzbnD6+eMX57
	 jtCI+BMlMh63VWOMWxICaIOtULATYu3+pTOojxsVyRsl+O/sHbxAPjROCsiuLpTAhk
	 +aIwx9oysP7iA==
Date: Wed, 22 Oct 2025 22:39:28 +0100
From: Conor Dooley <conor@kernel.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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
Message-ID: <20251022-kite-revert-2c2684054d05@spud>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
 <20251022113349.1711388-7-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Hs5fF3jxcDKPxATt"
Content-Disposition: inline
In-Reply-To: <20251022113349.1711388-7-Jonathan.Cameron@huawei.com>
X-Rspamd-Queue-Id: 959B8C0009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5ktp5mywhiedy6e3afqyytdah9ic8npw
X-HE-Tag: 1761169176-599517
X-HE-Meta: U2FsdGVkX1/sRkZuSi/ene04BT3JZDcD6G0z4Ps/iblhtwnK5i0I0axRG3BbabYSK+sakvEh5V11eonOvREq66Pq/YD8audhwJ6GjHYrLp3xiSLzo4WmYhn1927CWilyOgLogG+VR1+peknFL0b1kqKlEm43HtJSVOj3LHJbgxf1Ypq0WtIi+398m51wExY97fVVhesVnbS1FyTfeEIX1GOt2oriuH57Kq8mdKlmtMcgRxAyFDqsirKMfO8x1M7pXxgsppxSFgLqrvOxt784ko/MGoUgmPw6DXY8xTyy2NJOB5aFdUw0iJ7gdMTZ9N9nSl9YtKjGB+P7sQwOb8T/3kNY8+x3Mp4sUW+6uEaWgdPrhsbcoI9M0lrNgd44r6xsvh4tnnA7nxPwRSfKehevwx4ClZtn2VVrIbSNXHRLrtmlQBm5uPFyjJDQL6hge/kTJuy805lWlLxjEzx3XyMwtG87TXSZRVFLiwwer3p4JqHuv2WkYHQYGoSK8N+2G1npxthDbPerIn1k6/lcdHdG/trNqfZfOLdNVYMwdGZWnkiMAemLo2w9BOA7+I81uvCopct2aJTXgM932UG9BmdM7FlXd3+Bb4wg3/RbvrfmhR7G9yw1qEnWalFmjYteqQjsEKsxdAgCn0MWoWr4AyymZ0BXDcAXgVHwqCNn4LTbu4x9bd3DOaGx2vdh9N4sFxX0be8mxaePeSy9dJLF2yiGD8tV+zHWxYaXe0q0exKKWw/47I+CWgO7zoy6Xf1v4teYUYYmJa85USFiST/HEgtTwWGZcKHnjGemXrf/axW/lHTPFXH76nSxzEq6ZGWn46cSEaIBz7lfXXD/zxVSqznR/AkycH4zZ4dOIVZ9hGfXR4MQSGruy4jj1ebt3j3K7qwkw9dpCrEqGskgIRiDUUIlnAtyTSVmveVu6so/jF01yEi+GIWjJ2giEpUZEUwSEw7x4EXNdkdTs5xa3Tw6qhX
 vvi2PDCs
 Ee9juc2++KTZdYGyCVhKAMJE6PRoXV00E6aWrIeDGU3itfvyqBqD6t/mREosFcL42Gh2XXj9dQKrBEEz0KHnN/boNkCp92mAfIk9c76J/I9QPGysfFDchuQmfarlB9dHbe0jcZB00OF/8X+eMhbyWDb1VXnPW7v38XLSo1cexqSbljgmeAYzPuvpGieBBXH+25pW1VeSDJcbyH0lid2HlEhqjwgZ4RxSKIwt0ZFAZyQlrcpx/V/YZiUH/iDjYq6dQbMraVEPUULv5XyKjPQt0hDVvZHrnLl5BFTrUnN+bc2oUdRmIY0J0nVDSfWKSmaCAuf9P/mCILGH3Jtxsv6gv7sL2MMdlrcnkba86
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Hs5fF3jxcDKPxATt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 12:33:49PM +0100, Jonathan Cameron wrote:

> +static int hisi_soc_hha_wbinv(struct cache_coherency_ops_inst *cci,
> +			struct cc_inval_params *invp)
> +{
> +	struct hisi_soc_hha *soc_hha =3D
> +		container_of(cci, struct hisi_soc_hha, cci);
> +	phys_addr_t top, addr =3D invp->addr;
> +	size_t size =3D invp->size;
> +	u32 reg;
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	addr =3D ALIGN_DOWN(addr, HISI_HHA_MAINT_ALIGN);
> +	top =3D ALIGN(addr + size, HISI_HHA_MAINT_ALIGN);
> +	size =3D top - addr;
> +
> +	guard(mutex)(&soc_hha->lock);
> +
> +	if (!hisi_hha_cache_maintain_wait_finished(soc_hha))
> +		return -EBUSY;
> +
> +	/*
> +	 * Hardware will search for addresses ranging [addr, addr + size - 1],
> +	 * last byte included, and perform maintain in 128 byte granule
> +	 * on those cachelines which contain the addresses.
> +	 */

Hmm, does this mean that the IP has some built-in handling for there
being more than one "agent" in a system? IOW, if the address is not in
its range, then the search will just fail into a NOP?
If that's not the case, is this particular "agent" by design not suitable
for a system like that? Or will a dual hydra home agent system come with
a new ACPI ID that we can use to deal with that kind of situation?
(Although I don't know enough about ACPI to know where you'd even get
the information about what instance handles what range from...)

> +	size -=3D 1;
> +
> +	writel(lower_32_bits(addr), soc_hha->base + HISI_HHA_START_L);
> +	writel(upper_32_bits(addr), soc_hha->base + HISI_HHA_START_H);
> +	writel(lower_32_bits(size), soc_hha->base + HISI_HHA_LEN_L);
> +	writel(upper_32_bits(size), soc_hha->base + HISI_HHA_LEN_H);
> +
> +	reg =3D FIELD_PREP(HISI_HHA_CTRL_TYPE, 1); /* Clean Invalid */
> +	reg |=3D HISI_HHA_CTRL_RANGE | HISI_HHA_CTRL_EN;
> +	writel(reg, soc_hha->base + HISI_HHA_CTRL);
> +
> +	return 0;
> +}
> +
> +static int hisi_soc_hha_done(struct cache_coherency_ops_inst *cci)
> +{
> +	struct hisi_soc_hha *soc_hha =3D
> +		container_of(cci, struct hisi_soc_hha, cci);
> +
> +	guard(mutex)(&soc_hha->lock);
> +	if (!hisi_hha_cache_maintain_wait_finished(soc_hha))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +static const struct cache_coherency_ops hha_ops =3D {
> +	.wbinv =3D hisi_soc_hha_wbinv,
> +	.done =3D hisi_soc_hha_done,
> +};
> +
> +static int hisi_soc_hha_probe(struct platform_device *pdev)
> +{
> +	struct hisi_soc_hha *soc_hha;
> +	struct resource *mem;
> +	int ret;
> +
> +	soc_hha =3D cache_coherency_ops_instance_alloc(&hha_ops,
> +						     struct hisi_soc_hha, cci);
> +	if (!soc_hha)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, soc_hha);
> +
> +	mutex_init(&soc_hha->lock);
> +
> +	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem) {
> +		ret =3D -ENOMEM;
> +		goto err_free_cci;
> +	}
> +
> +	/*
> +	 * HHA cache driver share the same register region with HHA uncore PMU
> +	 * driver in hardware's perspective, none of them should reserve the
> +	 * resource to itself only.  Here exclusive access verification is
> +	 * avoided by calling devm_ioremap instead of devm_ioremap_resource to

The comment here doesn't exactly match the code, dunno if you went away
=66rom devm some reason and just forgot to to make the change or the other
way around? Not a big deal obviously, but maybe you forgot to do
something you intended doing. It's mentioned in the commit message too.

Other than the question I have about the multi-"agent" stuff, this
looks fine to me. I assume it's been thought about and is fine for w/e
reason, but I'd like to know what that is.

Cheers,
Conor.

> +	 * allow both drivers to exist at the same time.
> +	 */
> +	soc_hha->base =3D ioremap(mem->start, resource_size(mem));
> +	if (!soc_hha->base) {
> +		ret =3D dev_err_probe(&pdev->dev, -ENOMEM,
> +				    "failed to remap io memory");
> +		goto err_free_cci;
> +	}
> +
> +	ret =3D cache_coherency_ops_instance_register(&soc_hha->cci);
> +	if (ret)
> +		goto err_iounmap;
> +
> +	return 0;
> +
> +err_iounmap:
> +	iounmap(soc_hha->base);
> +err_free_cci:
> +	cache_coherency_ops_instance_put(&soc_hha->cci);
> +	return ret;
> +}
> +
> +static void hisi_soc_hha_remove(struct platform_device *pdev)
> +{
> +	struct hisi_soc_hha *soc_hha =3D platform_get_drvdata(pdev);
> +
> +	cache_coherency_ops_instance_unregister(&soc_hha->cci);
> +	iounmap(soc_hha->base);
> +	cache_coherency_ops_instance_put(&soc_hha->cci);
> +}

--Hs5fF3jxcDKPxATt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPlPEAAKCRB4tDGHoIJi
0n5pAQCCL4y7CHzVqNXyyDfhRrqw9BjDlYs8MpqKde1NNQMUgwEAqS1sE14/IdwM
Du1yl5LVFN+kra14elaLoO7/NifKDQg=
=PAly
-----END PGP SIGNATURE-----

--Hs5fF3jxcDKPxATt--

