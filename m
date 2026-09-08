Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5CBC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25A26B008A; Tue,  8 Sep 2026 05:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCAD6B00A6; Tue,  8 Sep 2026 05:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3AD16B00A7; Tue,  8 Sep 2026 05:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3A406B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:27:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59B03A04C2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:27:28 +0000 (UTC)
X-FDA: 85190066976.10.F0D5199
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C860BC000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:27:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PaF/fX3J";
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859646;
	b=rxKnARkDD73FyVsmxHHtxS6J9Z1nHCZdgWl3GNQjwgjFWgPvOXGYVkvEEB0rsoJlWBb2b8
	IvONlm7WKVtmYqPqgpbGpqeI6iuSKgOR7emv7SFc6s6dOsFA4aWBhqfxpWqwbczf8Td0zi
	3wyXID5o62XfJW0sisaPExx02Mu4yqk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PaF/fX3J";
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9S4ei21MKUHBJjiz+ftl+IF+EunK9f6ULHxYAUuV7M=;
	b=t5NsJeJo6kyloXIHalmk9xvBSlzX8U0K/c1524g5oESsRDXfHCJSuqylKInjG2W72K4EmB
	/1qyPV2/hR6S/7xsWwPeYErRRtoaKvHRPtproGOG1uPHrLxpX2MJggKj026uPVXEeioPKX
	FuT8ZUL/9pZVDfdv/wOqK+EgNTI4GKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F734601DB;
	Tue,  8 Sep 2026 09:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6661A1F00A3A;
	Tue,  8 Sep 2026 09:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859646;
	bh=e9S4ei21MKUHBJjiz+ftl+IF+EunK9f6ULHxYAUuV7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PaF/fX3J0DRupK9yZ8ExzCVv71/WO0ICJ28j+TyvKhtF/hisGFrPp6LKseCIVXv/Q
	 Xv4AshCcIwMNuKbb8+dxto3+mGjz5rMUQq/QJ2IgqPw+dooCVV2iDULjBmGXzLbgLD
	 rOSVB53nuuWeM8HFhRcmKqJ/CyAipkyYFgAjsw9QpuZe6RgVyP8fpuVv9HwLu6uVex
	 jfAohxfE8UZsnlwsbHyRf8t1dccvI1hCQ0fCo8vMvs6meWiOVcd2Pq0AedZDxTHTkm
	 5hC6JTFuW4s0Eu1Yb+f0+8bQC6rJCaK0bT+r6tHPo6xivVUvui4MB6MkT/727ZDg1r
	 unFw927J5uwSA==
Date: Tue, 8 Sep 2026 11:27:23 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org, 
	mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 07/10] arm64: Implement __set_direct_map*()
Message-ID: <ap_UYjvpf1sXBXE-@orome>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-8-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="43scnsiptq6igc3p"
Content-Disposition: inline
In-Reply-To: <20260902104712.2399797-8-vdonnefort@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C860BC000D
X-Stat-Signature: k4z8j1w9hgduaxgnggik95ckn554bb7y
X-HE-Tag: 1788859646-603639
X-HE-Meta: U2FsdGVkX19xcZ5g2eaVpyY54NX+CKz9ggt6KNq1QDV8PTPq/tXALRwFbY01nNEV0+0xVEaQ57gDc4KdCZ6eTRZsd/UqlBCePXEVMjR5uuxrSUkGoy+g/G0HkF4t5zann7wVAT8rnNFtjw65j3bXYAmnZNs0gGnex4Md2Pnpc/t6TwdMfLH0koIvRR82679ag2S22Fy6DmQKdDioHjJV0qzZm1p3ecs49iOs2gntumtb12UZjZ1lWoVKFg2cjIUB/czgSkz7e7j/5yXxzI9uqYqnLouER3Ak0QIsnOBdCAHuQc2ctg0+Nnan/YifFfhadU8Lf5J4MmOTVn0/w2K8U//GoIK33LBuegi7qDrAywAwoojYEtxBNvmOBE6oDyra+/LCbx/oLWXtqTq6qNsOIYYlIAqJo1+SqzAcMortnZ8leL4YDgrOpc2HM349ZzE7agyWqJdk04JkcRDjjjN2E/S064kRmr38J+PjFu5OdWX70tXEkFoQ7El7FqSEzaY7S2Yhy/kVoIvGK4UKGtNAvYhgPytRQlBaMZ8rvZPVLlJbpPQu66mbJlVWGSoKUIQhy4FuEDof/fNPbG5HnMEt/pRGLa3gDSQn10WU8mV4wOFg9ieXf1H/OlYPdU3E1uSrTaQ8LAWlhsoYSLpk4oIgWzxrVqrzk0niPXqjPLE3lA+rC4Ulx4cnuQc+yOLjdWM2rCb47snxOx8o/CrIApx08rjirYOaC9uwyQbHOy8aWIO6a9gDuDDnfd4tBeMvB2xNo67yTNIufy7xiD1TtEftxS7ZpSLoXW9jttAr94/HBtn+guCXNhw/0L+z9UmNku/Ltig8OVNX4WD/3X3PnqFIsaRBQ1hPumoLBEMp0qr6kJzETNMxov+OOtIdn6VEjkgy7zoe1PajF4nQlhEBIjZOf3GbgT8alvCUhpg+acibRbq102UV2dDIoOrQLZ7RZC+tq2/E6+p94a3ADGU9uYs
 04e/KIh8
 44JJkpVpd4MW10UbhBz9NZ2B3xEibxJPZf9XEYnAUU8JXJb/jfxDCY2UQfRdp4pUi1eBY/r3M2OPsC2h2Mx5xwN/R6DRjwfar3AKB9fOb268HxmdmV5kOm/Mn97Stn30mYTnU9KQT2OdP4hDKDwNsKDniyiK40N/8nJ3JUc2bco9ulkQavFyu3Dqg2ApfSxOpPujK6AcPHVV5HJ+Oh1vej+ojSt4fDftS5C3pclk9byWAwRIzjbD0wQ/F/1s7wRqRK/UBzasJ6X2eySKcYq4Ha23hSI3IW82Kqc3JF7+uL4RYPYJE6kvK2uzmdP91b072cI4m+N4uTSQYZUn9wPmWJavGRmgpHbU9nU0Mrj0IQSrkhp2FMUswqkQj9RFmlam9KW/8lYe/95d970dM0h3lJQIuCk34WJUgiYsWa0uqwOtk/SA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--43scnsiptq6igc3p
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v9 07/10] arm64: Implement __set_direct_map*()
MIME-Version: 1.0

On Wed, Sep 02, 2026 at 11:47:09AM +0100, Vincent Donnefort wrote:
> Add implementation for the unsafe functions __set_direct_map*(). They do
> not verify for can_set_direct_map() and expect the caller to do so
> beforehand.
>=20
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>=20
> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm=
/set_memory.h
> index 1a37f4ef130b..080a40846bbe 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -16,6 +16,10 @@ int set_memory_valid(unsigned long addr, int numpages,=
 int enable);
> =20
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
> +int __set_direct_map_invalid_noflush(struct page *page);
> +#define __set_direct_map_invalid_noflush __set_direct_map_invalid_noflush
> +int __set_direct_map_default_noflush(struct page *page);
> +#define __set_direct_map_default_noflush __set_direct_map_default_noflush
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool va=
lid);
>  bool kernel_page_present(struct page *page);
> =20
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index c59ef17eb0d0..28adab0edace 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -294,28 +294,38 @@ int set_memory_valid(unsigned long addr, int numpag=
es, int enable)
>  					__pgprot(PTE_PRESENT_VALID_KERNEL));
>  }
> =20
> -int set_direct_map_invalid_noflush(struct page *page)
> +int __set_direct_map_invalid_noflush(struct page *page)
>  {
>  	pgprot_t clear_mask =3D __pgprot(PTE_PRESENT_VALID_KERNEL);
>  	pgprot_t set_mask =3D __pgprot(PTE_PRESENT_INVALID);
> =20
> +	return update_range_prot((unsigned long)page_address(page),
> +				 PAGE_SIZE, set_mask, clear_mask);
> +}

I think these would work quite nicely if you rebase the series onto
linux-next, which contains the patches that add the number of pages to
these functions.

You can then keep can_set_direct_map_range() from the previous patch and
call that from the set_direct_map_*_noflush() functions instead of the
simple can_set_direct_map() (which is a shortcut path in the _range
check anyway.

I've used that locally in my tree and it seems to be working just fine.

Thierry

--43scnsiptq6igc3p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqf1PsACgkQ3SOs138+
s6FbJhAAq7rdW+WQpw2aS+4U2xEYrsJtjGRTj94QjexotpKa2p3eyw0SLesuF9zU
+2u/FbYsoxer4kU3QDhJC96FhLS9GwWuldwvOy3tXj+Jgim+5vBbEqynCr0nEGqg
nQCYWjZXMgSab6kJdxEjcywIXZ/noCDsK2bqF5PN1dz/4lhTVuDGHaxmbf3yV/oR
TebCIeTN5gSrIxZLAC9yWHu+1QVl4v5+06tJOJdtuIIiS+V/AKr9MFHxKRw5O4st
ElIm7uM6goaowuUnByavL3kZ1Vm56bc8k2rDqQ/7gcqoJfqUfqH0jPxAzpLsscQO
vXxM6OoEqPLB0bFou1KWnLPvxjQIAtjWjous+w7QTthjSgnwkbsW5UcrOZWw9o1Q
VPc3KGvB/1djAVyBUmV4I00sfrvwqqS4wMAcXkffhZo9likAZCQJG3dNp/su464N
X9aN99o2iMMqCnOzSedwMh9t7i422FTUpUMl4m+hCnqIHqVG7VUVI32s2nx1S5n2
5RBZckCoNgL2LgG1tgsnTpl3My/l+AhW3OwRTqdXIA/b8h6+/DonZVNIoeAcAEeu
0IYdOPIOnagFiYOCWzkMNEl6ce/Vd2AOl6JQ3ZEaIdS2FUMumXbdnbtLftgj9RtP
BB16Tsr/sbJb+A3+9MeoYl9ASll6PDapN/3qICYTCK0NkSRK+S0=
=54Zj
-----END PGP SIGNATURE-----

--43scnsiptq6igc3p--

