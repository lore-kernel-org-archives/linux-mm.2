Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F60606D81A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=cITr+3C2
Received: by kanga.kvack.org (Postfix)
	id 6BAC86B05BE; Tue,  3 Nov 2026 11:42:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B4A6B05BF; Tue,  3 Nov 2026 11:42:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55AA66B05C0; Tue,  3 Nov 2026 11:42:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3636B05BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:42:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B434C1C3CB8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:42:32 +0000 (UTC)
X-FDA: 85394376144.03.E78A6FF
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id 105A2C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:42:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="cITr+3 C";
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793724151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KBTYiCTGi2sfHFb+ylNKvCOHc/5SD8paEIRVfvfyPA=;
	b=TwNNiE9nthduUbJXlaJ0qlU3XuBY2U9FsVT38YsIlUE0DbdlTSzVzdIPprt8JHLwslFFCt
	gB1VqP3rMaH1bjbb4U4M12pveOme2hy6LtbPsJPa4Keq1iWYmbI9Qx2eodAaAaQhD2SSc1
	c4nJrlExgMsMEyOFRGpNMW9gMnC4+jU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793724151;
	b=o2kZR2cXbHgDIMMiH3NU0FRhOGgekLjACvifgnhlE8AB3jvQNeFrDs21h5epCUohjwiMXJ
	xh10SPWWQi7L+/1+RQjx2fV+xAF5nyn2drxM70OxwPA5sQsO85pTy0FAfNHoFStGmGkS/5
	gpPkL1xKhiI8cZXvONb7bVA43uKEPRQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="cITr+3 C";
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=+KBTYiCTGi2sfHFb+ylNKvCOHc/5SD8paEIRVfvfyPA=; b=cITr+3
	C2MeIecJ/GpGBDjLBPpEl0hTxQgHVowYX59sIFLnQC0arsUPQt3PkxoUtuGut+r1X9e0JaBJ1zyJF
	Kkf/BTm/rUNl5y/wgy85Fb0mHm+PG4Sj25eTy3xbXfnjE3T4T1MDMP2+uJdpnkGKklkiC9JJ7xMEz
	xPaCrvem51fKdX2lxrgwxf49ZzU7zq1CZE7+t8mqOt2IWoluWYyUjU4bonTY+zUEc7q/3lUYyuudP
	27kyxe4SPuD0p06Tzdc2GiWTcHIad3xEV7iW97pBWjHqKhk1lKIvLCFawqvc0c5A04OEyPPQGzZAH
	X1U5Ru73/2ytyNnRLGMmoQoFfnyA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xOHaF-00000001jlZ-1oMy;
	Tue, 03 Nov 2026 16:42:03 +0000
Message-ID: <9d1572bd5e868d3c9d953aa5fae81967cc81ba55.camel@surriel.com>
Subject: Re: [PATCH 8/8] mm/gup: batch contiguous same-folio PTEs into one
 refcount grab
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>,  John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,  Yuan-Hao Hsu
 <aa9736195201@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 linux-mm@kvack.org
Date: Tue, 03 Nov 2026 11:42:03 -0500
In-Reply-To: <fa017227-448b-468f-9797-33c02854f018@kernel.org>
References: <20261102193026.3860700-1-riel@surriel.com>
	 <20261102193026.3860700-9-riel@surriel.com>
	 <fa017227-448b-468f-9797-33c02854f018@kernel.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: 7nhmrmbryoqgiu443gwsnc4wyxj9hthz
X-Rspamd-Queue-Id: 105A2C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793724149-742787
X-HE-Meta: U2FsdGVkX18M7rBSjr19IJuBQ0faFf7keOw6atxYvdTZenIOq8nRfv7D0fTGirF/ml2lk3WVIfFaNh3zlfVEXT+GHxXBQCcivtHJEg1LCYxbD3JG3dO7mY5K4OlxKcDVQOcSynU94jH5m+Id0rPUFaHd+R6p2nUBvX7T7Y1z2BDSePjWcxjkik/Q0US01Hot4ALd0T7LZYrEIQmMyPaK4GbtDou4Y3mk0CcsRQZ2BxK9LYw5P8FasNchaSDZ9sUiGOvfVxZVtp4EaPg8KcPpXUeXQzxZGArgFpxRqP5mnwRbUmXVS64MFAl6JMHnTAeeaMEjavszvkBu7fPHb2VyeCabBF05hUE/bNmEc0lVsAK1xDO2/kJzNtMjlrDgDIiybz9G96X4VMGechGkMfUkUsrmqxcFUlLZ7omObLUmxjqA22ntch7hGEUnlD7gGdAquqrUAG3RuX8VR6pVNuNzm3NeuzD7jBVk5q3GborrrK+DpnC2S0riXc9/pf5vrjNw9lXnfXHdvHcjiGAKh1ayW7ZR//ipA0T2e3d9d8mpPOIEVUGnNi4kVis07eIfyKmjpz/SMlovbpoQE3vSvXeb/GEb9f2dtmRmzSdZc3YIe12YnYzEm7egqAYwOqJTcBtmp/iRMayC1tuF6AXGpa3/VCmMr2iPi/Mj0ARvk0TdJKRL9m3SdN6nl39Rw3dnx/bBPvFHqSuYwMViSDXcS81QSyampBGHAOk8Di67vxnxXutXDzitREcROB9gURKua+kgbiuIxVUqtLadXEkDhU+HwyU/kyvCnVNI6+wMW0+TcSGZzKxfowOsLA4dnH2MPGwXmuTqp6EP/fXVx1onhNQgGhuNFL+WGkBpdzAwZRs/a1Dg5IyHGJQkZl4rBBsFJlm8ofpY5/FBQhkneA+aZBH0zUCPbzRup/HF1O27wgI4geuk2pu4/Nb8JXa/N9i+pu9o0c8Nxkt3mhabb5OaZcD
 gnnhtOaz
 v//MZLU6cA01/OqREoHBV9nJTrTnwo7QDZjAaBjG4KwNhzCY6vYiNOh0UAJhYhriwUnQyVwf/1rhb9n1ySwDzcMCKtNe9bNjfS3HkBcGkwGd4/8WvByJPInngRvpEs+d9trYfzqZV4LYOGMMhTnm6XH6PZdTKPI1V7M4BQa2jaQAtRxSLdGXuGFcZSxYzF6BPFZIatzDvvkpfRolrTrjJnYu852jVUYL0PZ8F9oNK4ViczM6jcqLAXWDGre+KFlpTmErWFALFI99BsBtuiQ4wT2p8iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-03 at 09:35 +0100, David Hildenbrand (Arm) wrote:
> On 11/2/26 20:30, Rik van Riel wrote:
> >=20
> > +/*
> > + * Return how many PTEs map consecutive pages of the same folio
> > and can be
> > + * committed as one run. Always at least 1.
> > + *
> > + * The write-fault and unshare checks in gup_lookup_pte() are per
> > PTE, but a
> > + * writable run needs no repeat: a writable anon page is
> > exclusive. A read-only
> > + * run under FOLL_WRITE or FOLL_PIN does need the per-page check,
> > so it stays
> > + * one page at a time.
>=20
> That's a clear indication that this needs more work.
>=20
> I'll try to get to it soon and see how it could be done in a cleaner
> way, likely
> it should be based on top of the gup-fast series where we will have
> helpers to
> check for required unsharing of multiple PTEs.

I'm all for sharing the same helpers.

How would you like to sequence things?

Do you prefer to merge both series separately,
and then get a follow-up series that merges
the helper functions?

Would you like Yeoreum Yun and me to combine
the series, merge the helper functions beforehand,
and then send you one larger, combined series?

I have spent enough time in gup.c that I would
be happy to get rid of some more of that code.

--=20
All Rights Reversed.

