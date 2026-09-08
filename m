Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC151C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7DE6B0095; Tue,  8 Sep 2026 12:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941BA6B0096; Tue,  8 Sep 2026 12:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3AC6B0098; Tue,  8 Sep 2026 12:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 423DA6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:17:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8DB41C2919
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:17:14 +0000 (UTC)
X-FDA: 85191099588.24.CC865EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7B66614000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:17:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N+56EXQe;
	dkim=pass header.d=redhat.com header.s=google header.b=fx4E82OP;
	spf=pass (imf26.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788884232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biebLiR5oHGYPmQPO3uT20qG8Uw3pA9q7i4FEjIutYc=;
	b=PjGv3GUQojmev2MwRjpSjLTuJvZSY/ytoncwm4mOhADwXsBPepku/fsPJI2aDIKCzZkMBo
	hpoxfeIS5LfkJpgRI2MNJOhXT1GlH2KfOlWga94LF55ttr2Vcy+YdxI9HNbJg3zfiejc0J
	IvZy6xes9lwLzzBsoojY6czxr3dO8Xk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788884232;
	b=aa4VfPvTrZeIVzBxJDIeW8OCCbIKefohNdArcEXbG40scwPrcYxlSQSzuF0ZCaTcMw07mG
	1OSbbjcFTOqhc9KhHTqyiZCzvWiKFYx9LngajKYXecYzGzrl19hYSX4usbDHzJ/fu8GCYe
	7DrzIQyNP7ihlIpuKpWFqlJrhK4zlvg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N+56EXQe;
	dkim=pass header.d=redhat.com header.s=google header.b=fx4E82OP;
	spf=pass (imf26.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788884231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=biebLiR5oHGYPmQPO3uT20qG8Uw3pA9q7i4FEjIutYc=;
	b=N+56EXQe4v8OdEw+LCtYioMwybp2wESB9AL08dzmOKI3CTRDfw+nKFukqiAmQ4ecP8b11e
	L3PYwNORgNORcmiHHo2CCJgm/vjaJzvDPWPqKaqUfOu8prm+G1BTzglMizyfVzNA1b5nnw
	GM6Z05OHJDSZmnJYTt23q6TMYEn5l18=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-HuLFEB92OgykaFsE8gU4Eg-1; Tue, 08 Sep 2026 12:17:10 -0400
X-MC-Unique: HuLFEB92OgykaFsE8gU4Eg-1
X-Mimecast-MFC-AGG-ID: HuLFEB92OgykaFsE8gU4Eg_1788884229
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66f81a0f5c9so5780397d50.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 09:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788884229; x=1789489029; darn=kvack.org;
        h=mime-version:user-agent:content-type:autocrypt:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=biebLiR5oHGYPmQPO3uT20qG8Uw3pA9q7i4FEjIutYc=;
        b=fx4E82OPTBDCkn4s/mIBYjBojLof+OzP3Mx3aNF61i7ggLn6MymmAF02IHKOeIKmOI
         JpNKe9tWuXktpAmJkm2t57/xmhyPJd8yCUTdzw63xLgLm2145f5TX0aa7Vh1iFAGrtk7
         RsoVHpoO+mOYnX8hOxFDVRog5gkwSyFn8lml8mH79s+IutDxnkYlSQ1nWT/FXdtYizMh
         hMbgtBEiYsOBX/7WU79zkVMLQKA/lvRVcCB1Z4Qn7GzE4b/U2ZShLpJTtDvNDhjcV220
         SMVPAks3Zfl1gafrcaGEqyOn8barngJ0KbbQ0bcxh6PsDKRoCqE2ER5xqX6hvZHLu1CO
         bHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788884229; x=1789489029;
        h=mime-version:user-agent:content-type:autocrypt:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=biebLiR5oHGYPmQPO3uT20qG8Uw3pA9q7i4FEjIutYc=;
        b=CxXI4NVsWMs4socr0rZiTDxOiAGzEqk+qeriMesIDRKoOZTQ0NikCNoDEd8EoGM1++
         ACl8DtXdIiYxE0fydlznM3h/H2fVtosU1scY4C6zZQ4hIDd/k6TMmyxyDQxSz3eMql5q
         ciQSm7UezsGiqjqiiVDYbcnCLJYxksa3beHDIBx2Ho2IT8b69HoHGeYbOCerkMA1vTfw
         wqnT3R/yFOjMNLWpF6FrPRuo6iLC+7cdmJ84TYLg20X8yFMTIGxpvLQZ8ZLaWdLH47tT
         R4J5ayOhzJJTfjVR/PKTuLmBpjvXNE7UVwzl9oYPJPuStlXbANFeAEsDPGNlShDuIp7g
         2Ycw==
X-Forwarded-Encrypted: i=1; AKwUvBxIWQQ/DcceVz5acO8kihwt/Tw7yDQa53KIftHpYRiGhqEJ4SiCWeHTdD8ctujxO1xt7JfPvSCFNA==@kvack.org
X-Gm-Message-State: AFuF++k0/nvubucxRZq0YqsnO5YjP/N7u86UqxmAntlM9HCVSSqIuD+g
	P6rz1mHOFMvpMWEHtqhpPNz2wRuz/NMh9/Xg5b20UU0yKC2vYoyo2sveXu6tp9i18OZRbrshikx
	odsqtj92MU/Cm2B1E5/XBkFF6IQwZd7fg281Hd/8kXm/wVyboBQei
X-Gm-Gg: AYBFou2Xphx17yZZl3h5ctw5WLyapWK9OKgsiOPBfqtSPVNkoxcSRaaRQAJIkhgTGWN
	1LCdchqskP/dB0/GJysh+F4YjBkq5eUKj5/h5Y8jlaTR/rw24ERZNjjCoB9S1IdA+45aXjnX/gr
	da2dWWE+KEMHrym9JntN+mv859m54FPQ2cqttyEB8tYHyue6qtBfM7KLhvyiF4YxOmEyTFpVCUR
	IN/50fmOXPDa9y31EJFPFp8YRDkBySKcjKsGNd6oDBbMxPWCUXig9rlk7KviWKvZ1CX0NeGnjSw
	22d/kEpkO0VZvJwXoQ3FFS+7OjBvhZ+cdHydXOQi63dNHD31m6FGjGr/3yvMnZMYD2k0Xxs45IV
	mMOkknNKXXWHLGKMbUH7Xd7fOWkUDq/RWlOpta8gDt+r/1Za5TTkLyWFM6uvAb1ltHb2ikb7VJW
	+Qlmat4exUeenqisNCK4yD
X-Received: by 2002:a53:c086:0:b0:66f:c1bc:c09b with SMTP id 956f58d0204a3-66fc1bcc6ddmr4966007d50.99.1788884229315;
        Tue, 08 Sep 2026 09:17:09 -0700 (PDT)
X-Received: by 2002:a53:c086:0:b0:66f:c1bc:c09b with SMTP id 956f58d0204a3-66fc1bcc6ddmr4965972d50.99.1788884228782;
        Tue, 08 Sep 2026 09:17:08 -0700 (PDT)
Received: from chaithco-thinkpadp16vgen1.rmtusco.csb (184-96-189-144.hlrn.qwest.net. [184.96.189.144])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040663a87sm123734166d6.19.2026.09.08.09.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 09:17:07 -0700 (PDT)
Message-ID: <0f3340facc968f1d911c637ef0d305c9282044e0.camel@redhat.com>
Subject: Re: [PATCH 0/2] mm/hugetlb Try to respect mempolicy when
 calculating surplus huge pages
From: "chaithco@redhat.com" <chaithco@redhat.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	arozansk@redhat.com
Date: Tue, 08 Sep 2026 10:17:05 -0600
In-Reply-To: <20260707182900.483757-1-chaithco@redhat.com>
References: <20260707182900.483757-1-chaithco@redhat.com>
Autocrypt: addr=chaithco@redhat.com; prefer-encrypt=mutual;
 keydata=mDMEapCVehYJKwYBBAHaRw8BAQdAORXHCioh8sg4JScf3G8JrmX1nUt+teTWsqlbk67dr
 va0NkNoYXJsZXMgSGFpdGhjb2NrIChXb3JrIEdQRyBLZXkpIDxjaGFpdGhjb0ByZWRoYXQuY29tPo
 iTBBMWCgA7FiEEoln/+dhdP2hiiZGQ86/NNaAhFjYFAmqQlXoCGwMFCwkIBwICIgIGFQoJCAsCBBY
 CAwECHgcCF4AACgkQ86/NNaAhFjbm1gEA9t0Iaxr6IkGONOjD7eB10PjTYyDGVd4QdJYPohP8xRsA
 /0OETJIGSr5rxRqG23AGUdlnUfzFlgm3QuyfNpGHcv0C
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CmIuoRvvvnKZ0ZKUUcy9"
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bkynikp449zn933prys4amr4ci1a8u7i
X-Rspamd-Queue-Id: 7B66614000C
X-HE-Tag: 1788884232-90741
X-HE-Meta: U2FsdGVkX1/C6vYFLRdlnU20wuPHHkZq8EZU+O7JH1OtMT16EOcOji31t6DbkGRL5UDFhkLKHmc/cy1QVeI5q/Ko22ZeCaMqvFu5btiwF7oFqavbFAQhnPFiJoTUa5ndJxau6FlTU0aUOoX7leBCX6FQgla/gWrla+KYeVhG7EFZWIDXHs13LBzYiUDikk1GtkM+r6fn+AVrFBAS2Bp/gtDtd/8aM2b6NKtKV+i5H5PPwr9X4bQgPyAPPEG7vXOSt0sYXaMy21VOcyQYUDPp1Ljx4LsKgQTQR5/RFeF67TxH3DMSop6lRosg5e56reqEsZDD7dk6BH9hveJxEXWJuSkSxA0urMMNn0Yb/cMUFrjDTy085z208qGOSMd8HAcBCJ+IVaFdt7KdxDS3OG9uzXR7kSwFtFiCc3hDmjXB53Y1WL0lB8BIm3gPlbU3DIQFFAZqvoY8hxi/HtlzEp7K0u/4EXA1fcOywmxk8Bap2i09o6hCJ3y6YjRT+uyu4t5EY6OcRBccdCdEWsCU+eNfzTBdvqj1kUoXcgnL0BsGmS3Asu3Tl9v6KRWpfFVbFCp/vh6n2QhGWlbO4KlaA68Pdor98JrZtl2S3AJAqPOslCnQUPS+AwDyBfD0oZ6xwc33BUTz+GRz2HQ8ZqEqJRjGAQiEsFzFNFCg9dvnOkPjekfnYM6bwOPrADycf3Yd1AdODyBwIzBlSdaL8qZ/PzvD3EpWbeHIueqh2+qgaeCO61VXP71pEyGPtJGkEUpEn/kp8dw6TtzbwE3j0rXhOxpzBeLBt+j8k2lc1WPEU/Z2PH7I6dxciMl1k0vqz/zGEg0pxr7YpvIl43x+UrrIa6R1oL4emDXvG+yK5n827hfVT5dAu/sm/8m0njvB7qt2O08nKrM/oE5Ufr4hKi/8C9+HyJYxtHTTM7Uo3fXkJ37r4VMs3ePXdMioq+g87gCHsqAZNFR9nKAJih3KXSD67NY
 EBt0pCYG
 76ZLH8F4fkVV4BejTdnE4bk4i58B+V/YWSH8QU7vzYbYasCnLBmmUexNl5NKSCPqqKYPsisjMkG8TMWcXz65/k31Ig2GdwcfdvqWJ1U9EES6UMQFE5lkbLEkoo/NwXQvgfUphfDrEfx8AQZZRUYczg/1TI/ZTgPdbe2VK+ZdQRRvB6VrXUAohXAeywUSA5YC3snpSTIW/6LnG6zMoVZJVMz06muusH10sdDdUtDUCXSF1bwFsfMmDhzRDsl/vxTQRBtzLzn5/C/Phu8xW0ml/hFbZu3iphrLA8nXIBS0iTBMysZFEL0yzyZIASdMQYrKhyMGIwaX7ZKNlcV0mShMLtMywUOYijlVQACgwUKgbJhwjJ1AEAmzAHoTb4jUHQdtEtIDultmkFr9uqKGHOEAQ5/EyoaRiGXkIRCRO2xU93DGzLZX56N8FoOtoq5oYfZ1WNkKefHUjW3Gs5Kv8nR+efW7ceAJBIHF2eX2xFJ1wWtZjU4HjhNmgBkO52w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-CmIuoRvvvnKZ0ZKUUcy9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-07-07 at 12:28 -0600, Charles Haithcock wrote:
> Presently, when calculating how many huge pages are needed when
> reserving surplus huge pages, the global count of free huge pages
> is used. When reserving with a mempolicy, the global count of free
> huge
> pages is used even if some/all of those free huge pages are on numa
> nodes outside of the mempolicy.
>=20
> Reserving surplus huge pages is ultimately best effort even without a
> mempolicy. Restrictions from cpusets and mempolicies further
> complicate
> calculating correct numbers of surplus huge pages to reserve and=20
> maintaining which nodes those reservations belong to (see the comment
> in
> `hugetlb_acct_memory`).
>=20
> However, we can do a little better when reserving surplus huge pages
> with a mempolicy. This patch changes how to calculate the necessary
> amount of surplus huge pages to reserve by considering the max of
> either
> the amount of free huge pages on nodes in the mempolicy or the global
> amount of free huge pages. We may still attempt to reserve huge pages
> outside the mempolicy, however, we end up being more likely to
> reserve
> from nodes in the mempolicy.
>=20
> - v1: Modified `needed` calculation to use `allowed_mems_nr(h)` in
> order
> =C2=A0 to consider free hugetlb pages in our mempolicy.
> - v2: Folded in Joshua Hahn's recommendation [1] to further modify
> =C2=A0 `needed` calculation to take the max of either the available
> hugetlb
> =C2=A0 pages in the mempolicy or the globally available hugetlb pages.
> Allows
> =C2=A0 allocations to prioritize nodes in the mempolicy but can still fal=
l
> =C2=A0 back to offnode allocations. Also added selftests to check only fo=
r
> =C2=A0 the edgecase which caused this to initially be reported and sanity
> =C2=A0 checks.
> - v3: Split the change and tests into separate patches and clean up
> code
> =C2=A0 to better align with kernel style guidelines. Likewise, fold in
> Usama
> =C2=A0 Arif's correction [2].
>=20
> [1]
> https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.=
com/
> [2]
> https://lore.kernel.org/linux-mm/20260624144600.8159-1-usama.arif@linux.d=
ev/
>=20
> Charles Haithcock (2):
> =C2=A0 mm/hugetlb: Prefer mempolicy nodes for calcuating surplus hugepage
> =C2=A0=C2=A0=C2=A0 reservation
> =C2=A0 selftests/mm: add surplus hugetlb mempolicy reservation tests
>=20
> =C2=A0mm/hugetlb.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 42 +-
> =C2=A0tools/testing/selftests/mm/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0.../selftests/mm/hugetlb_surplus_mempolicy.c=C2=A0 | 491
> ++++++++++++++++++
> =C2=A0tools/testing/selftests/mm/run_vmtests.sh=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 1 +
> =C2=A04 files changed, 517 insertions(+), 20 deletions(-)
> =C2=A0create mode 100644
> tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c

Any followups on this? Please do let me know if I need to do anything
else to help this patch along! :)

--=-CmIuoRvvvnKZ0ZKUUcy9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSiWf/52F0/aGKJkZDzr801oCEWNgUCaqA1AQAKCRDzr801oCEW
Nh2dAP0RhTUkLY/ZXEagxLRS3qw+NmM/NsgO63pwcBk6CqLfwgEAuV6RgVQFNBd7
xyJ4ZSiOAN4LL3qxSB2uJu7LCTUwFQk=
=WurH
-----END PGP SIGNATURE-----

--=-CmIuoRvvvnKZ0ZKUUcy9--


