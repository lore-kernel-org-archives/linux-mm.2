Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 397C1CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F65A8E0005; Tue, 16 Sep 2025 18:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE0E8E0001; Tue, 16 Sep 2025 18:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A768E0005; Tue, 16 Sep 2025 18:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F4C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:25:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DD55160356
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:25:30 +0000 (UTC)
X-FDA: 83896546020.22.CA09948
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 69CFF1C0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:25:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=oqzIvYd8;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758061528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpnzCP8uSc8b5yaT1O27jIs9rdJQpLF3MRQKCDW0kmg=;
	b=DLHO5lBE/ryjZbzv2IRFjFQR8M9K8h2crhVTj0LWyGL0SKd1qsTSGTNQhH4XIyE722Hvve
	0s29zTL5RaIdbo1mH5om6ViyJt6j2dy9A/SRvuftBIOhekUyhlL4VAuotnDTDcyE+72L7v
	5b15vCUso62M2+HMK8/egR+OR0POUsM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=oqzIvYd8;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758061528; a=rsa-sha256;
	cv=none;
	b=cXFo2uZwhu1+uGO55eg/fsbXgvvcw/n4xzUH1aD8OTUMCsYRH2EwOh/9NUN9BONsLTTOUx
	3Ql8WT1U/PeMxRXPfRgUFKTp3fF7K9YNHmsinV3aUhxRgmz+qweBcPSkcauDoeq0K0KY5A
	xZJwp+bgFwNylWfBkvsDUuUUlCvvqnM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EpnzCP8uSc8b5yaT1O27jIs9rdJQpLF3MRQKCDW0kmg=; b=oqzIvYd87kYcLEuUk2b2Qxsr7n
	qktNtNiL5V1ttnaxOOly/JG+6gQfKC/liziphY10g5MeQgS6OYWYLCvKz5uc5mnVr6Imi068vXEEe
	WA4dRGyWJn+PqxNIM1earWyF85v0IymWB5cmCx963Npz1oJRa4fuOf/VsM2LmK7fPsLMHTdQjJ2I5
	4u5IJETf+S+jhrYuUm85mc13kUAy1QMqtgzYx+RS6PUjyOGD3Pymb0c5nGcL6vEPag4iIVGwo7lil
	6TnO2KJFqJALrP+mtCFRNxUfnXaFOFcUur2ODFbYdSEg39ae9A/SRKsvbdTw3xJmX9dLqgfHqFDrk
	k4Bow7/A==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uye6p-0000000017J-1HX2;
	Tue, 16 Sep 2025 18:25:11 -0400
Message-ID: <40b0f059bbb62e4bd6fed33b3990def3d2aed124.camel@surriel.com>
Subject: Re: [RFC PATCH 04/12] mm/cma: keep a global sorted list of CMA
 ranges
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Tue, 16 Sep 2025 18:25:11 -0400
In-Reply-To: <20250915195153.462039-5-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-5-fvdl@google.com>
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
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 69CFF1C0008
X-Rspamd-Server: rspam05
X-Stat-Signature: jdct63ebj7xrtbtq8rp4tef5fw3uoxm7
X-Rspam-User: 
X-HE-Tag: 1758061528-67882
X-HE-Meta: U2FsdGVkX18ENTx7t4xOxvbfUHcGwgHE0nbSPF9QQyf5JkclRnNCF6lLoNrCFRzlF7KcySCf+dEJ2eTldgBZ/D77qO6WOa3mbe0kvsO+QdIaiK5mfEq6DlNFeMBh5BRWOcSQbGMmq9Yid9lqrdmLt/6E3zVJ4YvgULNxyewxLayW7uR8isyBz3Uq/nJwZNJo54tBbZJMzkTIqvl23RExo6oM75Gy05mSTsI1z+xhWjXJP6CDywcDc7EdKTbI1t1VbLtSc5VvmqSidxKRO6O1kUqozY4/4H44HRoChzhWq8oVttJ2Dll12ltNT7LicR5MHtMpuIFFQEGbeuP4H+sDxmzpI8By23RExeMRuryCm+VxR9oSW2yysNpV90INltKhCz0Nt+d5AylYiLfCB9H/o5Xpp1H6lgtPGVLg3oP19EXK0KATPSAwqAHIQQqjuBAlLNXPn1VFlFygWnBhlmFtmiWb/3++IN8xLK0Lp3nVFSyxwz4TF+Mfk+TmqYYwOJsKrcmFgzDFlqWeupT16AyUjeiIE2vNw4QI4LnIdq0LtkLnog6xg4tD2+uian4jSBtsLw+23Ti3Sa1O4oMyMkLLscF1n9fXK93fLmQTtILgFQJDTFsXE7A66HUMnLEyQJz02WxCnTe5cHa/L4uPHyOo7pvTySEC8wXF6waSswM9KrGrN24GIsxquoEfZ63MpodO6GcoCmcN5MbvsM8AIjs1wjc5sCnxwgcvf3CqZ0zEa+ZsGliJZ7TaLVt/6xxpAoc/B/Z75XoIj+utY7d2UaXegeiJILXMGRvU6vfEImi7FN6/1FX+JWREb7b9RHu/Ad8wkAX4YNUfKmMBB6mHtjB/MyPCh4k0LIHZ9r7H65tbPTQiy58lHKuScfmJRlWC/eGJwUuEyv+0DpwMxfDePXOt8RE9yBVTPxNJt4eFuVXc9ClSMEepI4a7xPSqAZhNlAsK4xGzGvWVgSz7vClVMH+
 6xNdsqih
 f9rK8FMCck/Nn7E/aJOzTfAyR27b3NPtDc/Bm0iaHK7y9QGOxMxVrnNPfILhHXVcco3HySvO8ZyGdX6C9ctv3Byqb4H6i5Y2ZXT3dBEFqlA04TZKtSnS5C+PMsmtXWL2bIvjqFNJ34W/N7JvNryAL6J4+jRIZd5MB1DewidBOlNg7c8SFWUZm5IJfSpN3PZtgmzpG3CopcX3qsnw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> In order to walk through CMA areas efficiently, it is useful
> to keep a global sorted list of ranges.
>=20
> Create this list when activating the areas.
>=20
> Since users of this list may want to reference the CMA area
> the range came from, there needs to be a link from the range
> to that area. So, store a pointer to the CMA structure in
> the cma_memrange structure. This also reduces the number
> of arguments to a few internal functions.
>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>
>=20

> =C2=A0static int __init cma_init_reserved_areas(void)
> =C2=A0{
> -	int i;
> +	int i, r, nranges;
> +	struct cma *cma;
> +	struct cma_memrange *cmr;
> +
> +	nranges =3D 0;
> +	for (i =3D 0; i < cma_area_count; i++) {
> +		cma =3D &cma_areas[i];
> +		nranges +=3D cma->nranges;
> +		cma_activate_area(cma);
> +	}
> +
> +	cma_ranges =3D kcalloc(nranges, sizeof(*cma_ranges),
> GFP_KERNEL);
> +	cma_nranges =3D 0;
> +	for (i =3D 0; i < cma_area_count; i++) {
> +		cma =3D &cma_areas[i];
> +		for (r =3D 0; r < cma->nranges; r++) {
> +			cmr =3D &cma->ranges[r];
> +			cma_ranges[cma_nranges++] =3D cmr;
> +		}
> +	}
> =C2=A0
> -	for (i =3D 0; i < cma_area_count; i++)
> -		cma_activate_area(&cma_areas[i]);
> +	sort(cma_ranges, cma_nranges, sizeof(*cma_ranges), cmprange,
> NULL);
>=20

I am guessing that this is safe because cma_init_reserved_areas
is an initcall, which is only called once?

Is that correct?

Is it worth documenting why this function creates
a sorted array of CMA ranges?

> =C2=A0
> =C2=A0	return 0;
> =C2=A0}
>=20


--=20
All Rights Reversed.

