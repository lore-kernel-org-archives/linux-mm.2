Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B05606A8AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=kNeNtKLR
Received: by kanga.kvack.org (Postfix)
	id 4B4C26B05F4; Fri, 20 Nov 2026 13:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430036B05F6; Fri, 20 Nov 2026 13:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283066B05F8; Fri, 20 Nov 2026 13:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2236B05F4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8287440149
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:24 +0000 (UTC)
X-FDA: 85456289688.01.88479B9
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id AFD0C80004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kNeNtK L";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795198283;
	b=rzEsVoMb2TH3yhvj2zi1MCnBpiz+uY5uR8pr+Y7lScRIobjoccp45FcVa1hAsZfPJ6K6ZL
	Z+wOFAbo0l6gE2EKcTiXggrhB5K/L6pweJXMnzHN9R8ypVANDci4dBzTC3uZko7w4qgmW/
	5VqAPQhYmEd6IHK1bLx+oHDygurTPIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XcKJMdHlJfeRGtBDKUfgdRC3VDDPooY0HWY6IktVMYE=;
	b=sDDxWfuYmzXCsjeoAn5FNclNQL6NyYsj1kYHnqFE3YUZGJatrJj2edE3ttqPCiK1Cn8tEV
	dC8Os2KoV9a9BQNEtQRHcUMo+rCx4io865eQCSdy113meZhFWdxXcCVq6cPtKT1hN6+dvg
	ZB/iIv1F5KB20JfDOsCCKXwrnAfRVwI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kNeNtK L";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=XcKJMdHlJfeRGtBDKUfgdRC3VDDPooY0HWY6IktVMYE=; b=kNeNtK
	LRXTV8DlwIG2kwNqXfn856WnUegT3g/UHb9EJz3aA1cHPb4cAb6icf0Dk8LxKpS4iMpKtsuEQoao7
	VEc+sJ0H6R9PTFxeMOCD3aY4x//Jom+8b2QKRQua1xxkBfhsFONQrA06q7pnVpppGywF1zMdf74CT
	r8knGnQSJH3F04wAy427qFyeCT3DVJNfi63a7Ji0KA6gbEClMFDz6/tRdcDxAv9IHDLhCtUv8QZaQ
	tu4TIpoDRsWFaT5VYkBThFpGdnaXt5eWbmTA2QfP3OfXXVZaX6szAqtBK2X7c1BeO63i33YxSwZUf
	GnLX7Ddy4xLbU3kh7yZf5wROkDJw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xUT4R-00000005iWQ-47pK;
	Fri, 20 Nov 2026 18:10:48 +0000
Message-ID: <5f18488c8234ee28e9c638abacf4961311d866f6.camel@surriel.com>
Subject: Re: [PATCH v5 5/8] mm/gup: break out gup_lookup_pte() helper
From: Rik van Riel <riel@surriel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand	
 <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Christoph Hellwig <hch@infradead.org>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>,  John Hubbard <jhubbard@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
Date: Fri, 20 Nov 2026 13:10:47 -0500
In-Reply-To: <awCD56Ncl5_Tjrl6@gremlin>
References: <20261116210127.3837898-1-riel@surriel.com>
	 <20261116210127.3837898-6-riel@surriel.com> <avxXgTBaJkPN6XOh@gremlin>
	 <89e41824f1371b5880029f264e19b5d0589ae22c.camel@surriel.com>
	 <awCD56Ncl5_Tjrl6@gremlin>
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
X-Rspam-User:
X-Rspamd-Queue-Id: AFD0C80004
X-Stat-Signature: yre85sc9nw7gkfycnqji5srg3f85thbc
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795198281-723634
X-HE-Meta: U2FsdGVkX1+UMU87ojTquTy1+aLy05UKq5D/tuoy/JAq6PlnZfhpZy5KPLKJaq5/wf7nyguupkc+ojNbJIwqW4/9OXsnBx4oxqteMYyvH6jofqgsM4lBVEezBstLcOcd5alRVlZjo9KZaZl6jTmqCp3Ht2eeG4Ab2pmGWxvUbc4labcw59NQgLtCOSHvWi8D3Qr30FO7nvwv6vh+6Q5oMlPVkuqtacOcZTHyRzF5VBkHyMMs6QXfv4cXM89172I8KW7agomIrqYBcFl+uqmPz45j9nWMomh5RxlsxVpkW37YF6uE4UHu0SJfnbtrVmAXi+a5siDepFsHBzFc04nMEItzTqGjQTZRQkAwvhrNOdGdph1P7ZZNlu/7MqCuX15a+qLAAOP/dLLmZhk6syoGcHnL8ARBaae4w6fvq8vn0e5j2+N4g3PeoC8C8whXEZGyvsNlnxo4zC9vaPxCeoSqQQJx6SDuTVQ6quz9/ppkh9Q0PASZynbPG0egZImnLi8vpXhww7bcoJPv7BFsLXPBaz64A1x2+qr+mCdk3muuAreRow9jZPRxCprKaHxXItKi/hTvUEbce5Silcii/MXAHv38WPDN05KgZ7Fwce+SGxqohQPE2q1XFbN0rqcxtzL/8v4VhlUyaxncwjdII+RTGVhcpBpXl0oZ6E+v0KRfgNVS5eHrMHXD+WAJVv9+4M4b4OAwxekRFUzJZWSGgXXqFI4vsdFIpVtWpv0pO9hofwltFOKlQwkVhJJ6R9zI2zMNz/Q4nqZJu9cj+TY28Uw7PHtCA7iA3F0za2fLUkLfahrNOuzhLEMEhHOk7UDYTzBww0b29D06RYXASVrh1mKw06/+afsY5Jy63fhKKbmExk4YNDDng0mPrz3X9U0Euo83J2W1u90n+FwcBPYEFcqo0SdkaDgqQJmOZ+6g0tzn96S63hqbAjlsIgnhIaKqKsN3UvSI2xRcMBtN/mk4iCq
 8tV9VzjU
 y03cO0mnwe0xsHfMLC2vCqSjqH6MxhDYT3dnUe5mN0dBIWUoUysnQCKU7s/N/Kr8SE6UiPiHor4pRGksG9tXlToZUY6irJpyFdhq+TWf2lm+0f8GVDbmvGSj/kC8tc/EuHDh6PSt28Fp/pgG1uUXOeIyrXyZKrI8b72wZaarvh8Y+vvwehBu8hRrsSqjVp9ADocWgG7CvcTcmyA78MgLOV10QQdGiUivGVT7BzQ/A5RleCB/Xz/4YjfPFOvriJorR8J8/qFnDBr+OUF1B5srvVPaxsjDzLszEdIZlyXejlJdu5FEZzkUQ9hDeSb2dQUeiCDzCQkuKVSjnf5brXXL4gqZl2Xgn5B875kAArEQ9IpJAbNlYE2kxGBxbLFjGZcOSLpP4KEVtJ21IyuwC7b8OyaLNg6QI8QKMq0ZHs2TVl9BsyKZOYS5MWYCgjuP+j9MULZlNqXs/jNa9pSqnRVqDUKw6Bkql46kohg22
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-20 at 17:33 +0000, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 19, 2026 at 10:04:04PM -0500, Rik van Riel wrote:
>=20
>=20
> Right, I think I need to see it in context to judge really :) but
> obviously we
> can't be introducing completely dead code like that, even
> incrementally.

Agreed. That's been cleaned up now.
>=20
> >=20
> > >=20
> > > 'need_no_page_table' isn't a great name either. Maybe is_none or
> > > something?
> > >=20
> > Maybe pte_is_none?
>=20
> OK, let's see how that looks in context.
>=20
> Since you've not replied to the rest of the reviews I will assume
> implicit 'ack,
> will do's or what not on those? ;)

Those are all "will do's", or rather already done
but not posted yet because I'm combing through the
series for other nits like that to address.

--=20
All Rights Reversed.

