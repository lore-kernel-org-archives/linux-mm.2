Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7A7C44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 22:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DED6B00E4; Fri, 17 Jul 2026 18:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5326B00E6; Fri, 17 Jul 2026 18:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4926B00E7; Fri, 17 Jul 2026 18:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC2B66B00E4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:38:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C36B1A02A6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:38:29 +0000 (UTC)
X-FDA: 84999733938.20.0A093F9
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf25.hostedemail.com (Postfix) with ESMTP id C0029A0010
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:38:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm1 header.b=Q6ij4R8I;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="k 3p91yg";
	spf=pass (imf25.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.151 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784327907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzde1ha+q0b3f53Hnca6aQ3EBESk3P8v7XvgdM60Feg=;
	b=GQA51xFymz0RTHQnZ0gm7Dsed/x5b9H+S41XDwMOYS1VtYyaPqxoKNgGYibphqmJVM3Wqo
	LoMLOyGI6Gm/zpDJzL9W9Cq4eETsocrAISYCoK6d22qYa+tMYtV5Idiltt+5OwRFIRRD5n
	12s1Z5df3avh3XmMCmQ8MEOh7qGZaY4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm1 header.b=Q6ij4R8I;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="k 3p91yg";
	spf=pass (imf25.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.151 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784327907;
	b=RoG6mdwOSbUNq5WCKw0APUVpKs2BQR8Gi3vWDGbfnTro24I8zQQM0shGNEofaudv2F8rQ1
	PRLx4xg6W5/Bd1dkJuIp00Pe1RST6UGrifUqzsqPhwka4SbqCb7AQHwJwXUxuLn2MBe1/u
	26HgEobnqlqzPaIMlPZn53V/D8RIg7E=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 49F5F1D000D3;
	Fri, 17 Jul 2026 18:38:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 17 Jul 2026 18:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784327905;
	 x=1784414305; bh=lzde1ha+q0b3f53Hnca6aQ3EBESk3P8v7XvgdM60Feg=; b=
	Q6ij4R8I96GjEjcUD1qZKp+MktX/se/U67ruWFXVdRaCcuep0Hzsq0TptKEBdQ1k
	BbaUQZRd3kGFDFShK3JAyN3CAJUZp05WQeRgrsX+oXSmhODXf+gmzFO4k73+T8IT
	tvb++PH3ocHu7i8+drrSM9PqIL3/VN1hpPpn2GK6PX0YZMvjW2PleKtFfCpa9JZe
	ZpNKYcI/9DNAFjMaGR5zfayIPxn4VeEap2uoS7UqtigbgKNKLQEevJ6oDpBn4H7d
	W+91wm1iw1CnWBmsL3K03cMVPEtuErgCy6wNJ3yuTKZqeyBM8v5DZFRajTzN/Rr8
	SVl/ZSWu4nmtD96mnaTE9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784327905; x=
	1784414305; bh=lzde1ha+q0b3f53Hnca6aQ3EBESk3P8v7XvgdM60Feg=; b=k
	3p91ygZHntREhMvwRvvg1Nd6p8Yy82IesJEqGKKmouz8AY0GCqunTdJNaAoK2Izd
	gX27XhdWtrEcbyyF0b5ULRVNOb7NpiEF+HkGuCPh9a+vNP/Sml4kXsVaN6eGL/DZ
	mDYTKzZvsESQnYGnpAkYDcJrenv4en0xKRqT1fLLK9Kq0zSyXztvFMzjviSKEnKn
	f2v+DgameSBhsyR9gRn7L0cDQ4jt4kBnavidzvmYjwPmmXT4kOcEAQ1jLYEQyFkC
	Ps5fKiVy7O4euSm2Cp3A0jsFzlbRLwx2NrHGGRxz3pX5knstd90i/L30mwsPfmrU
	x0f/mfqvnulJfzMswgjzQ==
X-ME-Sender: <xms:4K5aasDFJxf8OJ9HwrQvkbL3nz_k-D9y0ERPa60Chq_o1nrerKIHOw>
    <xme:4K5aauqSodIH1QgfhPde-nISWSQrkHiq0g5aTcSniaa3Loa2yP-GiSAHAkVxM4OmS
    QETNl2eUvDe8v5EXh_tXC3K4bgcN0IkAVlz2poE_In7Ox0V_S7rxf8>
X-ME-Received: <xmr:4K5aatYnWC8LdcmOZrSzhCBQ4J7_G7UsMC1yNED7CRfNG5NR66QFF_xVA3s>
X-ME-Proxy-Cause: dmFkZTGm3qs5+aEcYkfakpq+2uLa99h4ajh2qJDjfxZgK/kLOg+NCtE9Xvz+Bhj3dMCVeG
    Iw9OAvLLQOBef102C9CcWY9KFqr31YULKXWz7tTVH/9L0r3O8EFnXB6mx22NULLeTdT4jR
    7YyhGf/7/zlHCdn9qcNeEbW1dGitA6XPDqWKaKaSLfsRIHa47ZmRAwCu/HK0tLf9EzcH6J
    mrXjVXzFge3aTWOYrJ8BV1WW+FlEXo356jBxCU/ddBc45zydnrQ/OFaKikfgE5MXr2hUSm
    qivErpgstzhVNhWpsbEp/HjC3trwdQqnxIg3F3fBPXme/bWnJbnRbmJ1IoE7xjyGX8ciMn
    NLkqwZEJY9vN1jLTYco6vz9m/oKknXVpe4cimgXmyi71Tz3zw90wQLPatMv0uythQlAFHI
    siDsOq04rZ8KC7P/N5IKixERGDlXwr2nDee2QXJL16P5A97LDoe8ij/WvPHOdgqQErQBp7
    2qh1L4FEcxl0oRjEIbc1cA5156yEJIg6jz/FUFOOeYSqKIqgBCiY/BjgF6d6eJhywXH2Wb
    di7DE9KTauaQKU2jiAMqCMesbMe93WPD0RH+Ko6ZJH9eORiCm5lho/LYAMlGyQv8Vd8D7s
    Dm3+bOx2kd0cxpUZNVlu21VpRgek0q9oT6X6hbADH6goWPsiBbg3eWlEy3qQ
X-ME-Proxy: <xmx:4K5aanB5kD0EYGoIaM4DDZ0vTQFilDsP--MwNer7HMw1YyoSd9BfsQ>
    <xmx:4K5aavcC-HAX6KVYAQS0nIgyIJxU4jrz27bJGCe6jG_NyrEAL-QqFQ>
    <xmx:4K5aas8gfYkzLwYExzLPNBb72kPXQsB3BzGO0uaNxonp5Bj0P9CzEw>
    <xmx:4K5aanEYB5o6L-2-emvdTEbuBXbU4hevweZU1IYJCUEHLrpOQro-0w>
    <xmx:4a5aakPRm9ooV6NOF6i9FVYfpIf8SW4TZedXWnnZEgXY4Zo8wPg2K4hV>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jul 2026 18:38:22 -0400 (EDT)
Date: Fri, 17 Jul 2026 16:38:20 -0600
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, Jacob
 Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon
 Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike
 Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, William Tu
 <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, alex@shazbot.org
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <20260717163820.6bc8c13b@shazbot.org>
In-Reply-To: <20260710212616.1351130-4-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
	<20260710212616.1351130-4-dmatlack@google.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0029A0010
X-Stat-Signature: ufc9cmshom4dn9scb63br6yhej5i46bd
X-HE-Tag: 1784327906-760578
X-HE-Meta: U2FsdGVkX1/QYtzdCNChFSz/arxjzZCr5qTdHUaIqEO4PLvnLlaXXXck2SFrvKZNyyI5FAaldU+thRDhK6Bjs85qMklosVp4YLudrHoag0LuSO4H/4N1BgNNytlw7/GhR3si1r0ex+9LCrVdwP0YP8VR6LpbOb1j0P9HzV0UBv2QWE8qxrdwL/1j2neR5BWxaix4Rx+eMDs1RYlvADftBqb1lrZN0aK1d+BoS7+HyQVJVBH72KhaaOTZNYIS+euVuG0hPbvT3Yfn71QbU4sFQRWkqpX8CGo4b/5Zb1OU8KdBUxY5FyX0RoyEL9k3iWZIrG33sTEJlL3krbEB8uXIfTJFb5IJG0fi2745uyI1suljRGcqrbKBmJF8uC/EM5yWjJMflmTeHeHW0cyOjeB+xfypWTQslC9hojwM1vTwlsoSLADkrtf2CFKGKQRL+ukjxVdRM21qkkzIwPhoNIExe5V/FIVe3TLS6Wh5Cf1zZl5rWuOWGDM/wQcTPwGbI/9/0lvVVH2Mb60VHq6cskLEGBsH3nk7+oHGBXPtdeC2Cte+ztC015HwNckBWoC8erY/cFxHJwdXgSCCDF0p/b6yJHhSBCkGWd8lsmwe3CYWUhPVfpaCP9cZKIGWjedbP2V2s3EI99BE11WUR2K4C+fHydzyYGE8coqHxCY5A/aKf58Epd93K5VVHV815OT+YVCyW2WcPNHkWRKlhbHxIj1zKDe7BzQRRAWim1lsyET3klUykNnQP6EDDD2JZyD9DIpJwdFJlwwmzusBPkcUCaUK3hP3AiiYkR8lihi+oB2P47D+/CMiyZJvEejRTlWQgBc8QrKKy2HOxGObFeddcTKkXy7pj4KbvNqe9Wvim9p2JFKuc94ac8+Sj7aM4fcLDi+6FLJE1c6YaoUmQeI2SYRnOI3b7p9VVnKyGmVi+9xB5Y9TZxOjhsgRnMaTvYm43JByVaSAJDTuF9Nrfwik8Re
 RFLOzXKg
 piDGdVuf5rfQ6Y9xpH26Mm/zTrsW5r2ZqYxd5srEZvrFzOBtN9fEKlxyY/eznHVCtNXDCM368oEfyJoOEkWaeTbdOBVomLK8/36c8oDYPgz1PHD+9xROL/JpfCOTfTT1oKAIx8845UKHuEGgKSfB+N8WUYE8lKqXKNKWSXSpLyEwd2YKa3XO0yYZeflFguWqeitWExCdZZA6f14xiCFiIaBfugHZIr2GG3Y+x8LmrShqh/xk9oK+OAA256gwcGaE60T1MBGxNLboGGgLfMtRdmInqCKsRrprDel41T+m9tLUDcAlU0Zk8HMHbwov0fbz3H+RmSiCx8Ayv9JwKA/pfw2M/PkpDERkelMWF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:06 +0000
David Matlack <dmatlack@google.com> wrote:

> @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>  
> +static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> +{
> +	struct pci_flb_incoming *incoming = NULL;
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incoming);
> +
> +	/* Live Update is not enabled. */
> +	if (ret == -EOPNOTSUPP)
> +		return NULL;
> +
> +	/* Live Update is enabled, but there is no incoming FLB data. */
> +	if (ret == -ENODATA)
> +		return NULL;
> +
> +	/*
> +	 * Live Update is enabled and there is incoming FLB data, but none of it
> +	 * matches pci_liveupdate_flb.compatible.
> +	 *
> +	 * This could mean that no PCI FLB data was passed by the previous
> +	 * kernel, but it could also mean the previous kernel used a different
> +	 * compatibility string (i.e. a different ABI).
> +	 */
> +	if (ret == -ENOENT) {
> +		pr_info_once("No incoming FLB matched %s\n", pci_liveupdate_flb.compatible);
> +		return NULL;
> +	}
> +
> +	/*
> +	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> +	 * but it cannot be retrieved.
> +	 */
> +	if (ret)
> +		panic("Failed to retrieve incoming FLB data (%d)\n", ret);
> +
> +	return incoming;
> +}

I'm having trouble following the error escalation here.  What's
fundamentally the difference between FLB data being provided and not
compatible (subtle log message) versus FLB data being provided and
compatible but we cannot access it (panic!)?

Don't both suggest devices are running but we can't get their FLB data
to continue letting them run?

The errno interpretation is also slightly different than the comment
above liveupdate_flb_get_incoming():

 * Return: 0 on success, or a negative errno on failure. -ENODATA means no
 * incoming FLB data, -ENOENT means specific flb not found in the incoming
 * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
 * live update is disabled or not configured.

Thanks,
Alex

