Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446BF606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fDsH2EnX
Received: by kanga.kvack.org (Postfix)
	id 6020F6B05BF; Tue, 10 Nov 2026 09:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9726B05C0; Tue, 10 Nov 2026 09:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF7E6B05C1; Tue, 10 Nov 2026 09:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3172C6B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:49 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BFB61408D9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:47 +0000 (UTC)
X-FDA: 85419418014.28.054FE83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8E68240012
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDsH2EnX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320385;
	b=zhEOO09Ks1ox/rf+bb1knkOJFQfc7wUC4PlSUMc8wWvnoyb8+Nmhb+USkH/Cvfp/DGP4gJ
	G+vr7SNgpkBbUyk+1d5eApzXAEorISN4lZZBc+sEgwMcSUdNvTy1TrhUvgAsm/AeF8PNjL
	pDthBm/+UYIxFnPGFHBPlbgF9o9fJlo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POoseU5QwHuTaUUqTtUaCKWgFktdvvSiU7J4FyrRut8=;
	b=dS58TO4J6kcGVSWXTAMcMBYsFMm9mNDt93PbDGRYMZ4bE6euK4Dkci8hTw3tVKyXDXqguG
	ouLany49mKAQ7BEf3w0MRLmD1MKEug3K94iVTiEVw3YCGZlSfIakGUo5NDxUHONGsZ5226
	Zu+0X//KedW5vlu4hczHrR57Lzkglow=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDsH2EnX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCE8A401C7;
	Tue, 10 Nov 2026 14:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E481F008A1;
	Tue, 10 Nov 2026 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320384;
	bh=POoseU5QwHuTaUUqTtUaCKWgFktdvvSiU7J4FyrRut8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fDsH2EnXolC6lBYjERa8+hrs1OrXDOSShrHiB+D5vBvoOB+AmgDD7+mim8cvKWcNA
	 P6FgjtHvNXdz94wvEwC7NmaRIqO9GF2L2EY/FyN1xYiUWoc+xElEwJ/Rz4CwYcGs60
	 oqcqT4onDDt4km7S3u7oUc4+j5eLWjyXJ7wF7kmVfJ4BQHhgJ/1/Uzo3OPkFRX4y82
	 HhgI46xJX924YQhRzwrbBtcrFiybbUwONnsO9jYz77F8/RNV0ngWY6Bg+ZA5f+E3O8
	 CBghcxfkhqxr3u1DK77peWiRAaYph38WxyserAtZBNTNOZRRskHbOaWAAsggrsgIJu
	 dT/j4gTYagZwQ==
Date: Tue, 10 Nov 2026 14:19:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb+git@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v10 04/22] arm64: Implement asm/kpkeys.h using POE
Message-ID: <07b55bf9-e116-4731-9f84-49cd1b55fa50@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-4-aa6c4d9603bc@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gYHulBH5cftCD4rh"
Content-Disposition: inline
In-Reply-To: <20261109-kpkeys-v10-4-aa6c4d9603bc@arm.com>
X-Cookie: You can't take damsel here now.
X-Rspamd-Queue-Id: 8E68240012
X-Rspamd-Server: rspam12
X-Stat-Signature: t1atdhbxop1m1gecg4wq6419wtcmas3e
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794320385-9768
X-HE-Meta: U2FsdGVkX1+CvP8saGe5r3vAl/DyECnn2Iu8xAPS1rPPq13Pfqq7GAljaZu27aiwWt3YJG7CZdzxOnWXncEEnpIqVS3rWRjKEfSwJ3ZgEbWlpA1XGzPOmR2GNA+XDAd3sQ9CVB8AMi+0Nj1dGpHc6b6+tsV/RaGd1CLktOg5FiyoYrRDqxYNB6YkQl+iTftvqkehSbHRVrv0o8RzdXjuaavyRGWM4FXE8KtkM4n34Q94mXm25VJUGqW+aeyu0EZ+79fpXKM3gQazMJZ0qyd2S6j0uvw6VFyRTc9fZh92h++vErwc8vrof7JohNa8+BnS+4MhrZnTOlRLYgyHKMPDkinPepEY3ExBqEW1czmAhDVrItiZuU2TfRJWYqMccs+sDJiIrv67HDS0Zf1VLAcG/iJ3OPLggtAyxlHGjol0E4w5nkkTgkzDq1xo5vBsrEd2EnxYxt34kGJop0wD9ESjVTgGpUlwrczD34Gl7bMwCxJa3E9S7JVde1kL6FlvS9LAshNiNHE1N4a6LRfRoevXtdqhoi3IJZFu0+4ewwgTJwsi1S5kdKH3247QTfAzV6tstAfz1OFFOy3CvcFF3EuokyFMuAw+8qIZs8ff46MkuF5Z11Jri7saUj0CGLOnNIJuhqlX34btK8NNNGatiaJCtZESBd6nIluW+/3XxWgdHXEZ9/UcF3tp2aweiKX2EHFHo89WMywJwLLYBYMob8Ue2h+jGhR4lxecNhOfTPc/GE3jHlBmaU2LDGg0vHGAz1gLWOfzSuugD03QwgiDQoyMW51A1eDBmS5yhIEIkuFLrztACy6E4eTShkDvKbv3/ySg4c4Ll14oIj1ZAwwhlCAUNtvLtfZdPMydMOnfLGS0XEu+kYfmIRJp70qCXlqlaQ559m2NKb0LfzwAiJjKP9RUIUqPySsjIK7baGQmfOQjly3poOxy5vLtDD61hxo+H6i3PWOTom9CoEqAvGWHFMC
 ngLK7eah
 6Mx93cp/d6RFsog9e9BZnYiMGoewnex1Tfw0k05nDvVSxi2bx2hNuP9jRxZYVTM6bLoqiOj4Fkrsa4dcjZ00uYQ3zJv1xT5pT6uZd8bNbbw/OPC0Re6BSXj3xw95YiayEYqjFERe1iMQMZDJqgL9Ol0AxR6XdQ/8RcTsMD+3nvOUgDiO8iv4/asWWOlc0X4ZOd+ASfLge8Agu6yBfh5HAhAuKFIZiE32i2OZHHbwhV4COh1nOT/DI4HaTtcqQbhDjldCnv+Ku/Lwu54fePLMSCOaUgMZoFdLc5gkZOnXmwZ03DYWrxlDETdnIM7uI9OTN+e9FHfFyU9rLTB0lt8ZfhqGUtZs0uLAh1NRtSFBrM0z54kvlSIe/twL3iTnWSvHu94DNzrJWSV07P6PQr6ckoNdWiuzjRyFCV521+6j/glmbB7YI4VdLtTCMqQLlrWBlRTAjzukvsDtV5Fkwit4j9hC6/BgpbzDA9RYR9/eguh93lIfQ+Pxg+aSSJBU+QDRMh0Ag8Lm+Iq7QUlh0ZnLyJ7APOZjYlQ9KuYbM5X2bBfHrMqjtUlBsIr5241Rgzyek2mGf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--gYHulBH5cftCD4rh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 09, 2026 at 03:58:29PM +0000, Kevin Brodsky wrote:

> +#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
> +
> +#ifndef __ASSEMBLY__

Everything else in arch/arm64 was converted to __ASSEMBLER__.

--gYHulBH5cftCD4rh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrzJ/YACgkQJNaLcl1U
h9DrHgf+Ntv2EG47dQBJVo2dflFo9Lt9TsvYKLCqzm33JoYC/P26mYi/8633hQW0
w2L056Uutdlq/ierGicH8Fb1zQIA88/FnTKEh+j872XE9Kz4ZNVl6MpVbWxm5oq+
FFU/2s66n/vbRZUIEfoM1X2ux5jjIHqdDWq4BeaMI0BS5ZpXXqVxkf+xsiESskAa
GCqvb4bLfjyFI005vGSvrjzju9Wd99csPXt8fcqRlDlXZOAPkJC9lwEdFNCxkMcg
LxBzbT062ehMLTyTGLIvAxVbakdWlTWbp6CglbDCrddaKZz1/9gRQ0w6yMYej1vM
O4DSvBecyFNT6MVKzNIRtQqL3QrIRA==
=esSa
-----END PGP SIGNATURE-----

--gYHulBH5cftCD4rh--

