Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62452C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E516B013F; Wed, 12 Aug 2026 12:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE9E6B0141; Wed, 12 Aug 2026 12:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDF46B0148; Wed, 12 Aug 2026 12:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB6BA6B013F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:20:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 414B71603F0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:20:18 +0000 (UTC)
X-FDA: 85093129716.26.9E62414
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8CB924000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:20:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LhLgNVWz;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786551615;
	b=PXMmxJv4ja4+S7IuPMJBxubNmuGgPf3QCcKuZRRlbxS2CU2hRMRAk5AcyxMKLzWKxqSZfm
	jxN0Np7riSM2Pvgezdyq+vlIFi6AYkl9kz1Od37fptNgZGzWcHC7qLjxGGHTJFloiKPuwr
	cA/fU2eC/GVU5gCwHbwnYSGHyJ3Mtsk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LhLgNVWz;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786551615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNARAhxSuKsGipY2rsokDXV2y2U+/O2KiSz5qfAfCW8=;
	b=k2jWypmfRjdgUkIoUn0tRJa/Yxk3UIPbzN7NhRPaIFKwuIHaWlBhLkq3Fd6N+HX9xNDTNt
	krnEp7XCDG+FMwq3OXYcEnpsibg4uE28KHtN35p5xjcsFzM8tMAXCksk2FZQbYKeAbHk6X
	GGoAfqfGXUiLThw12dECWC1JCjFuux8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XNARAhxSuKsGipY2rsokDXV2y2U+/O2KiSz5qfAfCW8=; b=LhLgNVWzi6I7OereAiAQuV9LbP
	WF81K3u32RUFjYeBZVpLzVrDMItQiQOwGxpWHAJ6hpVlx3jCxawM9vNM9a5giBmu+MlyqhZuqgeI3
	tC49il0fRmEAeGefXkL1y+9DA+lhUEihfU1cEH52eTxNoMPoVfVHoU7Ph8N5VJz0Bk+hsxOUW+2U9
	6UCQhOBw8EfvbEYsn1O6iBa0tU8LB9vhhRJ63CueYvjbCqjYJFosoQWTDivLZGX8sIdmDxy+kBcqE
	QbAyNVcsuoZsG9kFjuZs7p9wujW88Jw1S2eKS9JVPaKVIGSyrmAnxs1F53sVB2yYcITndzHX86+uQ
	Yty8I6oA==;
Received: from [96.67.55.146]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wuBgG-0000000095B-0YT2;
	Wed, 12 Aug 2026 16:19:52 +0000
Message-ID: <576db557841c7989100cef3a16f2ddf0d8bf4ab9.camel@surriel.com>
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out
 of follow_page_pte()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, 	linux-mm@kvack.org
Date: Wed, 12 Aug 2026 12:19:52 -0400
In-Reply-To: <3b8cb743-702a-4362-9abb-7c30e687c3c2@kernel.org>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <20260811025157.1632867-4-riel@surriel.com>
	 <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
	 <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
	 <3b8cb743-702a-4362-9abb-7c30e687c3c2@kernel.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8CB924000E
X-Stat-Signature: xq4q6ftssr37zgg4tt63usfemaj44rys
X-HE-Tag: 1786551615-225707
X-HE-Meta: U2FsdGVkX18oifvU6xVXDy8lvqOk0x1em0ffuzNQNsVHxoiGU32O3PJglOhv+AP33F2DSGIO31MVDAOTZqTfOfrRie/UPDY/ysSJsY/maAbGWL4ahRODY6Qjn6Dqe71XwR2ywkWLFXc578/B2GM7aReaNcVrUDxHnOujp4owO+ab9An7NtMQ75N/I6OXiwkdfUg6GxoPjGccMO9dHHCOs9R4scjywJUVXG9M333MIPa6kamOCNsqJwhe1zT0Vq7E5is7B/ovKL0Ltd1rSzwx6UQJPAGOo8A8ku54FNDjgQai6GBf8N3cbTOil8SlEWEdOtphBGAp4sWOh9HM7hK7BnGqnND4hpl99pxeb7UK5GcYw4Qsm/p49XYCj666XKMJI84t7pgw+zfv/ohsAHyI4gzfdI4hC/NT8+XdWi/d9mpm/QJgRtu5iEXPEvBYjCDHGoL5UUOvxuwYIl8ZkG9ncZbXyAvi8yY3ARYBFDtKwe6ivy6gj3dhopTDO8FP3/s3BIxeIVvc+PxHVC64fBzJ0dVLSvNM8IQDFG3z7JhR47D1QkzThEPEVYzAoqZp9sf3HIUKUtT3h3krTjZNYMVQwFe7oLj6T4jgF1cCSkeBK79O4OwsBD7OZqoYQtKlxV3CAwmCJ9kponv2taO7u8WNA0pS+/+i6OJs/+34bIKL/WyFy5oHmRrtMtNJm59jg21ol3+g7ztNlnN2ZkXCvSWPZqEVT5E+LwAkmbZ+ToEa/3JAR0vwL52LaFeazeuEcLgkE8WCET2WPk1Bxip2hralX04wn1wiEA9Q90ZO9/xWO248NvWfLqeOOqNFPDT0jCJAvSSU5jA8uVtVKRYGLQdlcVz49iSY9vpiSYhuL0i5LM8FVS1SOloWgmnOZTUqmF17zu6J6cHRKMZzj7lFEnwCzCod6HDr8SrzCDQsFRMb3Ki5uA7GYdAda1ZE7oc/qr8anY7sfpqdCI4qJ7EepWh
 jjAQzfyL
 eCSj+aBNjkdr9S72FN6GgTb6L0JzMWAKnfIttg8ermTQgl2P3jy6gULUZ0stI9yL/MuHISfUnzUEoGiZgDPwmeCF1AzyKj7dkZTUF54pv+ffU5QYkJQc2dbntN3BnHaYQcz2Q0xJ5W+OH5MbY8euX7SW0eiFMtZW295lhIoXsEznZSTX2LARp23GFFE5wrUqFyvrGoPD6/gXuS9pmsB1Usw1M72wflN9nG0xAUk1llVhmdJSOr+L0+xe/E4vOfFomVU7OSpWeuUO9Kk+B3PPr4vDPrFCEnVpdoraqQi1MD9a6Bb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-08-12 at 15:23 +0200, David Hildenbrand (Arm) wrote:
> On 8/12/26 15:02, Rik van Riel wrote:
> > On Wed, 2026-08-12 at 13:50 +0200, David Hildenbrand (Arm) wrote:
> > > On 8/11/26 04:51, Rik van Riel wrote:
> > > >=20
> > > > +/*
> > > > + * The caller has already run every per-PTE safety check
> > > > (present,
> > > > + * write-fault, gup_must_unshare()) on the PTE, so this only
> > > > does
> > > > the
> > > > + * per-folio work: the refcount grab, the FOLL_PIN
> > > > accessibility
> > > > fault-in,
> > > > + * dirty/accessed marking, and the array fill with the cache
> > > > flush.
> > > > + */
> > >=20
> > > If a function needs 4 lines of internal doc to understand what it
> > > does, then
> > > maybe it's not the right function name or abstraction. :)
> > >=20
> > > I don't particularly enjoy the "commit" terminology, it looses
> > > the
> > > detail of the
> > > most important thing this function is supposed to to: grab a
> > > folio
> > > reference.
> > >=20
> >=20
> > Should we rename it to gup_grab_folio() ?
>=20
> It does more than grabbing, hm, let me think.
>=20
> gup_grab_and_store_folio_pages()
>=20
> not sure.

It does more than grabbing, but if we want to
have the PUD path use this same function, we
will probably want to move the gup_fill_pages()
call to outside the lock.

At that point we'll be left with grabbing the
pages, and marking the folio dirty/accessed,
plus the arch_make_folio_accessible() call,
which seems to be a noop on anything but s390,
where it makes the page accessible to the
hypervisor (not sure when/why GUP needs this).
>=20
> >=20
> > Looking at the differences between the pte and pmd
> > code, there is another big thing that stands out.
> >=20
> > The pte code will call mark_folio_dirty() when
> > needed, but the pmd and pud code do not.
>=20
> Yes, and my gut feeling is that the same helper should be also used
> in the other
> places. Maybe there is no real bug there, but the inconsistency is
> concerning.

The page table dirty bits should ensure that we
don't lose any data written to the page, but not
marking the folio dirty might mess with dirty
balancing.

--=20
All Rights Reversed.

