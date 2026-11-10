Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3735F606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=MRkMaR8E
Received: by kanga.kvack.org (Postfix)
	id 558D86B00EF; Mon,  9 Nov 2026 22:50:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530DB6B05B0; Mon,  9 Nov 2026 22:50:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4466C6B05B7; Mon,  9 Nov 2026 22:50:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20D986B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:50:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD356408BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:50:47 +0000 (UTC)
X-FDA: 85417832934.19.DAE27CB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id EBF0F140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:50:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="MRkMaR 8";
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794282645;
	b=djNF7U+D9HilqQ0iRkv11qvM2FrRc9By/CBf6FI+HyRjAU1NZHANjoE0Te9Dim5Oh/kOJT
	RFLo66gksVf1Hj2dwNcPLXvjlc1CTbv2jvF4uRnguN4kfliSQ4fddWeLkE+WCcmBtN24ky
	TW5Gyn0EXlGCoWJRzeJ+Mk589vem/3o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="MRkMaR 8";
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794282645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28EHKTd5g7GgnDMc0iqNKE3KenijVI7p8oAI1MBlUbA=;
	b=7hOs76NtcCL4JrCDwoMirashvpjC8uU1ZIP+gMiNEYg03dTiGwp8lsV76iNVMrO3mhMOHL
	9xdt2FPetvxyeCQPCooMAmt0ArLj+NytFBXHLCDQjdHI89/mLgjmzFAhsxBAqbwDLBaP5n
	880B9ZZzRvNkoBYNJ8MP43ZN5PjJsQw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=28EHKTd5g7GgnDMc0iqNKE3KenijVI7p8oAI1MBlUbA=; b=MRkMaR
	8EV3mQT04NyuGBfJ4GAxJ318uyqe+jfErfFX7HXI3DsXV/m6bxcNJttQHm8ZR7Wm0ry9obhmmMMg8
	9JckodjwPv+QuYrUqgFbRoK/IdP5Zwskijnn6D1KiUkg7Vt4mu5d8PBo2Jos2qvWGh3EROvnbTLbZ
	2tnESEXqm51BVywMepAa94NhznjvnPINpCZvZ6uHkiyRh5waAJdixK6XYhzOle7Hx+17Z7GBqDhs0
	gL4AnR4rDDat4NF/0aznKRrQrw9vj3zJqanGhjTr8t/2N1vqXwZotGh+Dl4k1Ro+CUcyAOZ8Cesoq
	Zr822Qng/IF7Y0x9x0I0+ILG8yHg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xQcsS-00000003Vwm-2DAC;
	Tue, 10 Nov 2026 03:50:32 +0000
Message-ID: <a6d539cbab73091647fc2308b69fdab3069b0fe5.camel@surriel.com>
Subject: Re: [PATCH v3 2/6] mm: gup: clarify a reason to check pte/pmd in
 gup_fast_pte_range()
From: Rik van Riel <riel@surriel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand	 <david@kernel.org>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Date: Mon, 09 Nov 2026 22:50:32 -0500
In-Reply-To: <20261109-refactor_gup_fast-v3-2-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-2-2aaef02df0e1@arm.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EBF0F140009
X-Stat-Signature: ro6sysog9dkajuuf7rinp6rsssuqeifo
X-Rspam-User: 
X-HE-Tag: 1794282644-292496
X-HE-Meta: U2FsdGVkX18HZeIkemQ+jyupvpRBdKS72kCWN/9aZ4xyGdI4POOQDySYBfJZUPweMwEy9fhlfhpp73+vrRUnww5IOBLW02bKkcBagkUrxzh6nwH4nyUMTd9DonnMVek9RpHEj/2WzRHO3j0e5U8ZyoyAqbREvXJwHbjBcZWDKA6sboXTgntWJt2cFsoeEFTSbi5D5TTe1RKYodBA099hw3yXADpR28F+9KNwZdBx4DHZBt9dKl3E6s81bUvZWa09AdD0xaa0GS2bE/wguOj/2V5mI6udFJ/WFriagZL7J4hWw33KWFapBy2qjmv48dQCAHIGEy3jkjf5sjcr8t7nFQdH+CBPFaDWnkw7Kq+nxh54AFEyxx8RNnPyGa1bIUvKnPmMLMWoBn9MKevN4PAeYipp11W6IHpPaa+SzJhCjqhbAs2W7y1r4ablqwty8nbqi2k+frkZ/ce3VWwBY2OVOz0n2pMo5D8kcne4uAvBGSeZAycSjL0RbccHjsHl0qdxOBtRv5j0SpeZIvcnjsdQsfWbfwT7v74d186phB35YBKYgx3uAXO3nBeoRK+rUrxTnRdl3Cyuz5FEqmBr367cOS46xtHfQbc/o6Qvhb4Dgt/LX4KzHvLPLn/97nicY5PUa8u4AUHimT6cR9ydOoCUh+9qGa7T6Yvj6By9G8WPh60M/7HCvMngyfxy9g/SEUKbXu3Gy3bBoqRU1TUFbwvttXQCTZTWtjyPVdFxDtd/UPu7FhJmz23QMZgkJJts1TEhK2oFNgxN6c6O+YNXORikIF6eE+O3LsfNFnK3zCOT5bOcCLitAH0x/uFRzOMI70rMOEiWZj/QgkPs+o3j5UkPydaY2nhaf2SraKiELaysg92GDADdhz2EQpLJmt2/gavajDCmPCVhyB+ICaoruais5T+zRhnH2oXjCew7sWpJnO7sbj946awNugfvsdghaA/oWNhMCNSxjft5BFq5qDi
 4+8owghj
 Ke6dw44HMQHVLSRuHcccw4lHjz+gS+VNcoprDPamOA4DYZMBK+eFXNx62gqK2ZC5ga7GMBOzbFByuJdDI3mdXzaXE3jV0E0CLPJ6Ad1AVd5MQHKDoLeBSd+Yf1DIjOfNx9eoD2/reCidCRg48SLjRMvfDuEDcUHRdXHUKHv7YwMCCCtnFL+gj3qB5QPsursuP0Sp32NO2QJ24sdGdVbAzTpoWkH3Wjp+K6qksRVhFFzreU+DIBIuax09pbVyrkvBw3eoaMO6kzoCW6J/UpN2SVwL7PGiOC6RdfAIPGUDD1bZAR7g9cpws4TYwLTvNvr5y68myU4/XWziEKT/VfCazR4OxlDIW1rTXnIGMc3OnJrHM0fIWfbQDePl674l5Q+pTfYnMeAajvv+AOhJKvcy1ndQHaiNN9N7ywel2RjGPWcO+sMqz6mNj5MCEz/67tUKvKLw3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> Clarify a reason to check pte/pmd in gup_fast_pte_range().
>=20
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
> =C2=A0mm/gup.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
>=20
> diff --git a/mm/gup.c b/mm/gup.c
> index 7d43ce717b246..7f9348c633d58 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2881,6 +2881,14 @@ static unsigned long gup_fast_pte_range(pmd_t
> pmd, pmd_t *pmdp,
> =C2=A0		if (!folio)
> =C2=A0			goto pte_unmap;
> =C2=A0
> +		/*
> +		 * Recheck the PTE after grabbing the folio to
> detect concurrent
> +		 * unmapping or protection changes such as by KSM.
> +		 *
> +		 * Also, recheck the PMD: THP collpase can detach
> the PTE table

collapse

> +		 * while its entries remain unchaged. Checking the
> PTE alone

unchanged

> +		 * would not dtect that we are walking a detached
> page table.

detect

Other than that, Reviewed-by: Rik van Riel <riel@surriel.com>

> +		 */
> =C2=A0		if (unlikely(pmd_val(pmd) !=3D
> pmd_val(pmdp_get_lockless(pmdp))) ||
> =C2=A0		=C2=A0=C2=A0=C2=A0 unlikely(pte_val(pte) !=3D
> pte_val(ptep_get_lockless(ptep)))) {
> =C2=A0			gup_put_folio(folio, 1, flags);

--=20
All Rights Reversed.

