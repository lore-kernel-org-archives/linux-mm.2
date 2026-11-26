Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAB6606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=bt4LY3tt
Received: by kanga.kvack.org (Postfix)
	id D2FF36B05B4; Thu, 26 Nov 2026 12:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06AD6B05B5; Thu, 26 Nov 2026 12:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C5B6B05B6; Thu, 26 Nov 2026 12:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A50426B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:41:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B560A058D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:41:43 +0000 (UTC)
X-FDA: 85477987686.01.CFA7D1B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id EBD88140010
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:41:33 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795714895;
	b=NVtDFz+vYAzh74yhqceK9udtnoKmUilzfF/3fvrEdwp/dLNowHdgoRzMmGRrNwDpie8HWf
	DDVcD6SWRhYLLNkiThfPK4yWfmR99RV2DaVWxVTtKUG1AQgG8K2J1zlzSWznBxUX6JbU/e
	hwrq8sGbqdmb5Pv7GyZrNWlex5ibD/U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795714895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3IE4ahtHNeYXKAbhohuMqg1ApMu7OpkeIRKUByF/e4=;
	b=qYlQwQU/WUU9kokJDd02INs4aMTnlI9OXE3Y2OQoWshH+7jriWQQ7Wz7O0DCODLtEq4xl9
	ODLSbt7DDgInZMoYZs5XO6T5DipNBuJWeQkHV+vVUNPWRvLXOp2+CPU9+WPrdF6tH/50AP
	RX6FArp38tISipvciFGIKh97ZuETe74=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="bt4LY3 t";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=+3IE4ahtHNeYXKAbhohuMqg1ApMu7OpkeIRKUByF/e4=; b=bt4LY3
	ttXGwKIWVDxUCAN49/2bPwKm7HHkslLRWJ09XHY3pl8TZ0APiaR+OLHJ7MGTIubXmINEIyl+97LII
	hq+oKxGK+W0Qm21VFO8Iml0ke+Z6s1m0fxTvzNc7KHlDh0wL/XSKjLeuP0dNHEjIIEHucKghwGDHu
	4hnw/QRx8FCDx5tGPTFmHBl0fG3JIpC87vv1+P4dPosbmospOy9rSD/YO94eiaCA14ut/w5M/N4At
	YH4uVa3Ql1Iupj4uWoGIi6NOP28uZ+hXUfZz0t053DjYR4ZZLhBj3J0GW834lLzUpleNWRsFtiZNl
	lQUD/bqgdW3AO6IIGgNtbL4DImBA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xWdTJ-000000001aw-3srZ;
	Thu, 26 Nov 2026 17:41:25 +0000
Message-ID: <8e6d0de214bf930e14a53fddbd9bdb23d12410b8.camel@surriel.com>
Subject: Re: [PATCH 2/9] mm/gup: break out gup_flush_pages() helper
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Christoph Hellwig <hch@infradead.org>,  Yuan-Hao Hsu
 <aa9736195201@gmail.com>, John Hubbard <jhubbard@nvidia.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Peter Xu <peterx@redhat.com>
Date: Thu, 26 Nov 2026 12:41:25 -0500
In-Reply-To: <4fc1e334-16c8-440f-aa83-ae27f8b8d3d8@kernel.org>
References: <20261123195609.4115244-1-riel@surriel.com>
	 <20261123195609.4115244-3-riel@surriel.com>
	 <4fc1e334-16c8-440f-aa83-ae27f8b8d3d8@kernel.org>
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
X-HE-Tag: 1795714893-725695
X-HE-Meta: U2FsdGVkX1+l3mtzyQvS64yOiqQLxf0tSw4GmI56N8g+7Ka7jxCW1fIIGtU+7MajNvq9woDVvVmVEFbNAGr7BhuLd/hSr8PvdtVcIF5feDSpZUWIAjyCRGg/B4zO8OTr0CE0GD6XHxCcMFf3Ux48Y9F5ZEHpaCLXUycZ9VOSFmlTvg5HdbhzeZPm5JMwGGjfrVKG9aK64dyk4hHL+n7TBTjA48Yu/uaUjc5oDXh7znieS88EMlUUlWL8MoWQ5gmzSjBE3RHkiZF7Pqa4ci+CLQQHRm236TVfFuctMawb6B3MzmHqQWoRSdo/0887+tooknIGaYonZoLxwCXrdpfNxs4c0bRf6/G5MUYjbZUceN6Mdgm2q+TI4+E5/uQk8x3AR1/obxvYFTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 2026-11-26 at 14:41 +0100, David Hildenbrand (Arm) wrote:
> On 11/23/26 20:56, Rik van Riel wrote:
>=20
>=20
> > +static void gup_flush_pages(struct vm_area_struct *vma, unsigned
> > long address,
> > +		struct page **pages, unsigned long nr_pages)
> > +{
> > +	unsigned long i;
> > +
> > +	if (!pages)
> > +		return;
>=20
>=20
> Will this ever be called in this series on !pages?
>=20
> If not, remove it.

The splitting of the two helpers means this is
only called from one spot now. That means we
should check for !pages either in the caller,
which is already long, or here.

I'll remove the duplicate, and I'll remove the=C2=A0
unnecessary comments you pointed out both for=C2=A0
this patch, and for the others.

The comment above the gup_flush_pages call
could probably be shortened, too.

--=20
All Rights Reversed.

