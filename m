Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A51F1C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983406B0088; Thu,  9 Jul 2026 11:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934846B008A; Thu,  9 Jul 2026 11:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849DB6B008C; Thu,  9 Jul 2026 11:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7376B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:59:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2CCF1C1742
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:59:18 +0000 (UTC)
X-FDA: 84969697596.11.2907D8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1918E14000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:59:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RC+SN67W;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783612757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJbh9LElbrEI7E/P7mvmoKpzdOlw1yDQ59JtSNULaUQ=;
	b=pqnNqfLXxJWgTOOaOPUomgZi91fNddNX/ndOS1PFWLgjxjMIut0HmrIZuGpC7Jf9yZ0VG8
	4RCevkdFtc3qrkC1Bcz0uwXKOU23Y6LtOBoEqgcwsgz7pU174NsOxFzoFeoT5Bu6gy+p+g
	kiPIHmgV3XZNU/Gb+K6g0CeIJ2aVnOk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RC+SN67W;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783612757;
	b=dt8daIAXwerC3n2hioweupNtKgaSJjiM6U+k48P351NPHVmoXcxuAPPlq9agXxU8LLCAc+
	i4Y8Abe1LxgZCYrhasXRe2rFRJxP1lJnZyS4+TwydFRqdJqdMogu/AQmkeqIYs8Bvydtab
	GrrHuzBYyStFqLUTbcMcLLECHmEjqwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53ED943220;
	Thu,  9 Jul 2026 15:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7221E1F000E9;
	Thu,  9 Jul 2026 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783612756;
	bh=aJbh9LElbrEI7E/P7mvmoKpzdOlw1yDQ59JtSNULaUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RC+SN67Wo1bRPHmk2A3aRNqpRIZs1vt054/wDbMqrDQX+h2TC1c2qOU/P+vZpdlhO
	 AGbczQTeBS/xYxBRav4immcCdk9NfNEvFoxtcbuJpR+9S08i4HqzmmxUf2mXM8hMj7
	 lXpkqf096CaOPzHCghkHjTNtD6G/fOZ8q4jHCFjUFlLP5HaCXiv4HJYAS5IZqtiACw
	 SFUrZULwFBv+H+0ToU32sDdtnyqRsHAorRSMSNXr8y2FRWFng0qncigrrOJt/3zqzq
	 3H/Ma20+f66D8Hr1nfijRAegJrkTFT+SYpIfq6Gx4gdnn9Z3ulZD77FcSZxNF6fYJs
	 u62hwfrMdO64Q==
Date: Thu, 9 Jul 2026 17:59:13 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
Message-ID: <ak_E4UxfnFJywJa7@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <CGME20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c@eucas1p1.samsung.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
 <3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
 <e212caac-6c30-448a-9e10-32fff8b842f6@kernel.org>
 <83e5e74d-7106-4e14-9d10-56438372f6a3@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j2boipej3wyu4mib"
Content-Disposition: inline
In-Reply-To: <83e5e74d-7106-4e14-9d10-56438372f6a3@samsung.com>
X-Stat-Signature: 5zt88qo9zrkq4onanjkzgim4y8br5pib
X-Rspamd-Queue-Id: 1918E14000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783612756-656602
X-HE-Meta: U2FsdGVkX189f93c7op9BkWsy4dyNcHMHBLYSgMmL5prUZybGwtDy7m3onnTrI02MnYvXWaJOi6bBiphYGxBHYoB+Ld2OGmHIsYJFbTTZaRbP/ov8egcSjss898g02s9zx/pwZPsqILXOG9IrqIdkoPCoHBKOdsrA6CtH76rx5dotjRc0v9Vl21smnymtR04CkSbCUUAmfItIjEkJT/LlgRPW2IULXSM4eylxYcHw+7NSYacvUBSZSMgCHxCli9p1NUNadbQ3uBkg7TBQSXqYW4RuO6LnFv2LefrNHKd0kSNer3kiQlWwV5L6HVRXSngviR2u6ZqAnQL3cl4xtW1rp6NYvuAdX3e/xQbXKdTYDysee3FQuVTbUB0yIpNrgVMXY2guaEp8JwIdkh0ZoZP+fD/jWl/jdrq68vwy3UxT0zMS4/TIMSLQazJQlQhGgihPMnkkw117uu304wL1sVRRVbX6jzVvyLqDZbfYtqE4W6iO2E8g/zeNFHYlTgjQsaMuT3arYpVELTk0HSpizjOQAkvwY0TlD+DpQ1IRUpkMk8wyrD6ICTO2Xxm58iPHDvls3+Cb4VfEYbZQtGWsu7oGZIhxubLY7ZlbO3LhLBbUxqTePTI5YfzDcTI3R0YduVZjT4QCllJN0W0mlng1i7INJJVVuwnyz5ucq9mFdBQ2uP9ZxxvSMB3kBcYXyFH/00XdAcoZf6qtLtMbP4i0C0tjWEn1L9TIjI78un+r9Ts9gFZC1AXpzO9co7+ttdv20Lakf1AdJ+zJ1y85P7ZzfnrRqIM8hGmr2TRNxrWaNcBqj8VGRTW5IHyU7Dnv4YMS422CeQZrPtVX+9UcvUTdATcUoHezZd97H2/6LcbAWD7Yoqfgl7rsG1dn6C25amzVo16EZ8glO3sbpobk8ouDEJ27/2JCqW6Bip/tqG/UbN/IlgKEU0URzYs69CG+nkPEWSx9Mq7VOUD9awIRdOCJXl
 E9tOC92V
 i1zEqSv3zkB47zQ0vMFhHNFY2RLVRw0RyMpoxw2FnOEtbOTdeyGV2A44iyCW8YieccPhNlwandEBTZvzChKmI0auAy8ZFuEkS2MUldqNKzgiSg+ExISahjeisbqQrWE7pj8lC+4hW9zTJ+ro08oDnvvQsdn0IMws8na+Qes5uaW1dxhwV1n9L040ZI40F+jyLw2Ze22pBHGjRcTVZsOl5c4ju3vItJZ9khdiaK3vmhVDcf2Cf0ivTPOV7/bSmGvxeP/mEZpC1j17jrqFhRg+0StNNBkGc8P3DBfHU/cnjkIMVHntPKj0z8PWGGi+1HPiICM/Y2kHBL4AmdPokd8K1c61OigVQQ7SeduaWL55eHtqVxEqJV7bq3Sy6MCjdi6yPbBU6bUs6UmFZanc5zMmoSn5xa7gQe/V76yE915YpLJopr9kwpdT8O2UUnHClV3Fw21fQYDu+VaSbsyk8Zz9jLmL7zw51OUDqRmNZp52I0iTuZPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--j2boipej3wyu4mib
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Thu, Jul 09, 2026 at 07:56:45AM +0200, Marek Szyprowski wrote:
> On 08.07.2026 10:35, David Hildenbrand (Arm) wrote:
> > On 7/7/26 12:02, Marek Szyprowski wrote:
> >> On 01.07.2026 18:08, Thierry Reding wrote:
> >>> From: Thierry Reding <treding@nvidia.com>
> >>>
> >>> There is no technical reason why there should be a limited number of =
CMA
> >>> regions, so extract some code into helpers and use them to create ext=
ra
> >>> functions (cma_create() and cma_free()) that allow creating and freei=
ng,
> >>> respectively, CMA regions dynamically at runtime.
> >>
> >> Well, the technical reason for not creating cma regions dynamically at
> >> runtime is that on some architectures (like 32bit ARM) the early fixup
> >> for the region is needed to make it functional for DMA.
> > Can you point me at the code that does that? Thanks!
> Check dma_contiguous_early_fixup() and dma_contiguous_remap() in=C2=A0
> arch/arm/mm/dma-mapping.c. Those functions ensures that the CPU mappings =
for
> the CMA reserved region in linear map are remapped with 4k pages instead
> of the 1M sections, so later, it will be=C2=A0possible to alter the mappi=
ngs and
> change them to coherent when needed (altering 1M sections is not possible,
> because each process has it's own level-1 array even for the kernel linear
> mapping).
>=20
>=20
>=20
> However, in the use case in this patchset the reserved region is only sha=
red
> with buddy allocator by using the CMA infrastructure, not registered to t=
he
> regular DMA-mapping API, so it would work fine. I'm not convinced that th=
is
> is the right API to use for this though.

Are you saying you're not convinced that CMA is the right API to use for
this? Or something else?

I certainly don't think we want to get the DMA-mapping API involved for
this because that always implies that we perform cache operations, which
we specifically don't want for this memory.

Thierry

--j2boipej3wyu4mib
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmpPxVEACgkQ3SOs138+
s6Eb0Q/+LDCagsX5c/5bbiHk3kITlOkkdqUCHLmicqkfr4LZXyuHnPZlygaoxrFM
pWQKdyKOOfpM0U1Z1cuOHjLwTv5iB98Ne5qANisu+FqK6xFJ4ccA5Y2pXRG+2cEG
YJS9S13i37EoR6iOHndhRxeZyxcx080fd7aAJdY9yKXL4+bAmW9W5/zS5XbLyBbt
9MEA8Ah3pUnnLdjfeEq0SH2diKgT9OHXRpP4MEEFJbBufctOLZKoBOBBYPuURxCJ
UxjR6KKyMObW2G6HP7fdgDzj5XYdbMEyHN+Cvom68auUKijpkjfOt5NUTQvxuuni
YbwzbmHnbB76VYY6E/4i8uUPDxlBxha2COauHTiiJvdhBoJtPWSKLEYRU7BFrqBr
SJY+OpLNROUP+oZLTyr7jmAoaJI0wLnBLxId6GjF0iID6w1BybeRRDX34o5+mkpE
TOQ703x0/ZpECHboXKqJgo9CX0XIWtiD+yEbn7/HnR/wvHjksGNrCGxYaR5mrIAv
N75RHCupJjA918YwITUGC0EtKUWOcwlVvLwS2G8gAUZd6goYWyEd/fV7G4VEj/4+
+GA2L/CzSK0TbN+Ktayav2Ec5EQy4mKHa47hkWmWGe+Lh22DNNiP2CS3LjnPGs2i
II6qTao1jGC6L0sqjSQAw8VxP4TpU/XHRW8zs9HCzUaNg0ZSnGs=
=xmpu
-----END PGP SIGNATURE-----

--j2boipej3wyu4mib--

