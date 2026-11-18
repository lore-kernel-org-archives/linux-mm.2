Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562E1606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=chBz4N/n
Received: by kanga.kvack.org (Postfix)
	id 7A2BF6B05B3; Wed, 18 Nov 2026 12:00:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704C96B05B4; Wed, 18 Nov 2026 12:00:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F41D6B05B5; Wed, 18 Nov 2026 12:00:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30B506B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:00:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2DD71C4230
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:00 +0000 (UTC)
X-FDA: 85448852160.25.82E93E2
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5F6FB40003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:59:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="chBz4N /";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmykihLdEl417Yqq8+SUekklXJBePiqsz7TxF2IOgG8=;
	b=tGq6HNvCtzQ2suamlxiEYhbCT//VsIeY9/EYGV9/1fGJLLDz+obU78kcPkdIGAfavVNpeV
	L3IzD6EIgCVh/oCaBHMHXtxkSYIXgszwlCtX+WJJbjlKx0DCninEyCxNer8tyRIbusJysw
	+rpwH0O0LTuwAg2Ixz+FSGUrN9UNRWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021199;
	b=2Qo542fF7SIfDdpOS7taN4vRHP29qpl2EnlkkOaViWO6xkWr0Va9jJvLS6rkZfByw/ehwP
	CxWPEqYl+dc4+sd5/Zgc2V4n5ixwAjIMsvupwktI15J0K++fb0q6hYDwlPUaukL1qr/KY3
	H7hURM3exReTPZa9Wd29VBPOURrGvQQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="chBz4N /";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=SmykihLdEl417Yqq8+SUekklXJBePiqsz7TxF2IOgG8=; b=chBz4N
	/nOzcmyr3skH7cAiIL2It27iQWIht7GIM8+r+zsU8a4wbxSRHigyHABtqiuPxR3YpVihnDSwqmMkn
	x5BJ36TGzuPRlrYfK4yg1T+buyyb58DYDqOpwPyASonZ9TdX5cFiRyrQZKPikDkeR9g+RiSPhIepB
	EBuHRgompJdLIQqnhfYvkl2lKED83gWYX/ty7oCuSzqrnnMA+krkM2dCwV5/vEfynVd3NwXgEJntA
	IU57h2f964WjBgTB+NnWFcdqz7wiRzcOfZ8DcLZ91ldpmKcUkg8Qa6aaWqBd3gzc9h8AbnNGlUuO/
	mZ6brHmdem91j5DiDxCVVr+9bZsg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xTj0e-00000000Xb0-487f;
	Wed, 18 Nov 2026 16:59:49 +0000
Message-ID: <5f26a5a1e72fc999823bfac94f33b3c06465e519.camel@surriel.com>
Subject: Re: [PATCH v4 3/6] mm: gup: move gup_must_unshare() and
 INTERNAL_GUP_FLAGS to gup.c
From: Rik van Riel <riel@surriel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand	 <david@kernel.org>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Date: Wed, 18 Nov 2026 11:59:48 -0500
In-Reply-To: <20261110-refactor_gup_fast-v4-3-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
	 <20261110-refactor_gup_fast-v4-3-e779a7674274@arm.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F6FB40003
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: gywjigdww8n54936pfj1ftic6qokw8fi
X-Rspam-User: 
X-HE-Tag: 1795021197-35468
X-HE-Meta: U2FsdGVkX18k/PVw69DkMZBoqQpDNqc9RtUECUVRQjBs8VuPr+74DAQkOQ6TvZVHpPqKvmgfKDWrGCm0qz1J8L83x2T9HTa5t11CXMs1N2fcrwGbHOai60Ykfp3r04ALt6MdPIG+aAohNtrwtSE02L/ljwECHW/31Mts2PQMNjP3V1LafM22JParY9XemM97M62yNKIIcEBDVuTes9GOow98zqNG4+FursRxVIZgW604G1IZ3zgLEYNY9U147SpY+hcau+r86kga5/1M/97f1Xr0+2mRb63UT9QHFUWRncphJODpJvYeyAZQjayZuzv3YiQvFusCtqVFYCegmD9m6miHkLGdJtwNjpKW17qKBI0AkemiF2Y++Bn74yclmQ4KFWG18A7J57wFDudswjPXqWCXk9WjDEFg+/IGEwtYs9qeFNHAcP7/EscAr+ZN/BDKG4RwizXVWWYStflfhogzCQxXjAlWubD+JhyqGUv2u98OY264R6hd4KzKd359WJWQpFcJt41Oh182hyT5lbI6lyUllOEfg8pRkX2HxiAdgpCF1Y7i+3TMVLGV36mLVAR9jnIC2WpEs/mtQYCVUJ9+5EapNhoxMhkiw7BN0imrpukHWxOn/naIU99o1NG69IiqZq31gkNp/yBIcO0QVms85Fgabx3bNdVZLgaWzxizUfH/d9MYMktpuMggkENWcaWSwkSJBH8Bgjdzqf4qftF2XKsD+YbGw9nA8pPylAWXIYiUj+Ij1zmYkeHgNhWcUalhRL/jAjpqH5nBv5+zlYv1Hj2NWtPmHi/0itcQ8mR4qADDH8wRrPEjiBs6ZU/s57+pRNPDEICJ12nqyWyzJ29FdStGYHeQnuHg28eMXY6L0ucVX715utVXsRocMSJmYMbwB/bKB6aip6ngf/E1p6NSRMWU7+weVIH0A36jGwIGd1X8sB4DoNNYJ0NawcLZBDjHJDHljDK/ARYKJ4ayqxV
 tx9Kk1py
 y8LnEZ1pJNm7zZWm81Y9elYMJM/i7aHtMI4diGxY/CrUjlj6GLuciXTpFr7bh3JfuaCWWzM6/ioknSHuZMBsYykDvs85OcfC2963tpKQWozD1aBSfRLH9aDkNAiKYfgP2gewWtiH0K21lZoA+qmOWWDoie9/luL4ZaIDwck4N/wuW/nEVUFfgD43M4+oNMwxknwATFQ1FR7A/P5Jo6tp0XqUkkZt7eD36pXLUYrrl6TrItfthdzPcrfE619fhzBJM43tfplsN6GcB7KejNM1F4pkcerTKtxFh3adBKjaeHUUA1thmBczfivm2ZTkSuJe72aHz5hlgOBkSYHQeF+d+4oKWK6gFfDDrLZQw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 22:52 +0000, Yeoreum Yun wrote:
>=20
> +static inline bool gup_must_unshare(struct vm_area_struct *vma,
> +				=C2=A0=C2=A0=C2=A0 unsigned int flags, struct page
> *page)
> +{
> +	/*
> +	 * FOLL_WRITE is implicitly handled correctly as the page
> table entry
> +	 * has to be writable -- and if it references (part of) an
> anonymous
> +	 * folio, that part is required to be marked exclusive.
> +	 */
> +	if ((flags & (FOLL_WRITE | FOLL_PIN)) !=3D FOLL_PIN)
> +		return false;

While I was playing around with some AI loop to
automatically improve review-prompts, one of the
AI engines (out of 6 different ones) spotted a
bug with this code, as used in this series.

I have a reproducer to verify it, and will send
in the fix with v6 of my GUP series later this
week.

--=20
All Rights Reversed.

