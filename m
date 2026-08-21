Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87144C5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A47F6B009F; Fri, 21 Aug 2026 13:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6555F6B00A0; Fri, 21 Aug 2026 13:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BB06B00A1; Fri, 21 Aug 2026 13:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 353C86B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:38:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6BF71A00E9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:38:54 +0000 (UTC)
X-FDA: 85125986988.07.18D213C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf17.hostedemail.com (Postfix) with ESMTP id E1B7140008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:38:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nQ5WY+ T";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787333933;
	b=HU3TQW9E+1pm/rL6YgdHbryF5fTy3tyka2V0IdnY5p8ReNZ+3NWO3Y077ZKknSURDJt3T5
	mfMiIAh9vyFaJ0uiDjRZVHiVPateb/p5L5r67UxO1nKvatXfr3bhytRdb/xGhmSfuITEhn
	kAso8OguYSLnn9AphdFRIGwb+JDUyEM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nQ5WY+ T";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787333933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U59ADqk7aozsVhhhw2d/PHb1Nno8XXvbFhD55idcDjw=;
	b=IxjCScveUu4M0+WVbUd5zWxhLKGd4OK9kLo/yL4LgzWDcQnqjb90F+/jH6BFn8UIUWZMp2
	w/uxQEnpj+FML+7bvA6sT920KgNTK7EL1CH9zkBiBWWEEMLTgFmEsX9IFp0gqrc/EEpHUd
	Z283T9kTZL3qqLDoqKyaxALXNL01Ufs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=U59ADqk7aozsVhhhw2d/PHb1Nno8XXvbFhD55idcDjw=; b=nQ5WY+
	TXnj009z9SFpcTybXwBLLM3P+t3fI4R7PV6ucyvcZd6sMDcny5ngmsdPktPRxdfIJeRTPGMKdfiBg
	w3dC07a6lj9/4163O4hnu9MEZF5d3Uk4zPr7+2lgmw8VfpW19HJWB0AOKetE+7qVo9v4qEGzzIIB2
	eYMZl73cHJvVVu/zgvgw9rhkTEp9MWMfMDMJgXMxQdbkC6BQVXDSUtNN7rFCcMUkr8073Te2DjJCc
	go+WfGa018oe1ZKGtIe7RPQdHLgjpQQg0RK6G71YpieiIWBWzRmAzQwy5jI29OM8fGp6iQdUrf7Xj
	+Z3il23ah3jOxLLL3BzIMv5jT1gw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wxTC8-000000028xV-0qb2;
	Fri, 21 Aug 2026 17:38:20 +0000
Message-ID: <ab1661573257d7755d5a48e4f9165ff22febba29.camel@surriel.com>
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out
 of follow_page_pte()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, 	linux-mm@kvack.org
Date: Fri, 21 Aug 2026 13:38:20 -0400
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
X-Rspamd-Queue-Id: E1B7140008
X-Stat-Signature: x9umy8hexfp7qytt93sn14t55in5rnyf
X-HE-Tag: 1787333932-913012
X-HE-Meta: U2FsdGVkX18o37VaxeH/LhSOu4OBC9twuMR6m7Zb5cso1OGOIGF+ZZJDvJek3XxLX299y4TDgs2k6YbMrN/v//2oTZqeqzuLhGcF3GpPYnhmJmKaX1SVWFFakN3jX70KRnKSzml0vFLNX164xp36uLkPkGUSs8cG7aLFug3EspAWOw5OzPeZ7BNzFZNiB6cC+WN+vXjSHiO4kv3VDXodKVvqX2cSJJQ8HJ6HM51hQcr9RPO9ykXXcjPG4Tq5rGNbD5M9NecCJyL5Zmbh7LZXlNt/LgJsrKO8U0Iap51wnLjlnb1C01lz+mcYO1ijZs3ec0vSu/pD5cdEzWHD45OGKgiSf7XcB7vbMdH3TA2B2bZrPPoOYWGtBqmA1/w0L73aeLoEP4Wia6aJbVxTbAWQ+obK7GReGzsxMmnvZLPubgFB444Usw8SsNDlCN8k54piUhNsJhYU378Ch+4xAlQYMTER0pdb1PRzMkRtzhFWXIw5V3YRtQDQxdMm4iWQKjk/8Flt5HjNmEzl3ghzfeFu99u4cpDUoV8LNrK00mVNWPYbTlSJtplSaIL7EihWXXBhubfRWhD4ckidCgnTqb9f2qYlMh3smmS6x9xxAeF1hf9Q+nKCj7Nyv37Pj188Rladnj0Ig7rD3PcVoZ47KxfFMDnW0zp4TRwZE8x3NiT96kw7itgZVNmdgWWPabsJtLs4Wiu1iPAmCpWofdnTheaUuhmeOKX313+Q/Z+Fo5cUe4eYCbq4DG6wHtxqUAc7ZwQkOz4C/j4NUNjlWzO/0zBLY/VTmgmWlAWNRh8dE78v1gGsB66Ci6k8BsZM4SFVXKvCn39OsaaCrhcNHXX0t9ORQapNUKCbk3+mBWj1kEaUvo4tu/HkCNEqTDCemRHnxljk/o1KUNeQyZPCFYV7rNvptOlRnBykI5SX0WCg9MCCWvS73QK+Em0NYyC7lzt9Vv/WVMaKug/hFxqgUZ1dRG4
 L2TuUD1D
 u3QEunYcmkCTRJ0zFaDF435sO7PwA7xLS4pa2qAPJjq/dv4G6iItbsEjCu07grAUnaMrsB3TVV93DB/3SlTCz0ruDOEfnDSKU2Mee+BvnATlkS19jqZJrHoXSyOe0waZi6jlj11Yuw70ghtCjzAjHbF3Gc3bUQbvvLLIS2UfXJQbaTclVXRjF0gIzh3zEBkKHN2JTJiJLCctw37ySzgXPsZL2qWDexcquk7U+V8O8YGrdkLbyLkmV/LMA7TYMgeK7XE5BP2JZh0Lq2zI2Flbz87YSKqbF6aQqJ4e4AjXb27BP+aKURMiVQO7I+7kfTmBiDQh0ZrjMUGSjjxK2OAN2pyD/wV3z6y/vRES1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-08-12 at 15:23 +0200, David Hildenbrand (Arm) wrote:
> On 8/12/26 15:02, Rik van Riel wrote:
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

Heh, now the filesystem people want sub-folio dirty
tracking, to reduce write amplification.

https://lore.kernel.org/all/aocFPRgqieScf_yo@pedro-suse.lan/

This makes me wonder that while your suggestion
makes sense for anonymous and tmpfs memory, we might
need something else for filesystem backed large
folios and get_user_pages?

Thinking about it some more, we are marking the=C2=A0
folio dirty before (potentially long before) a write
is actually done.

Doesn't that give the flushing code time to clean
the page (by writing out content identical to what
is already on disk) before the actual dirtying of
the memory, through e.g. PTRACE_POKE is done?

Does the dirtying of folios and/or pages need to
be done when they are actually being written to,
and not at GUP time?

It looks like __access_remote_vm() already does
that dirtying, as do most of the other places
that use GUP with FOLL_WRITE.

A number of places use unpin_user_pages_dirty(_lock)
to get the pages marked dirty at unpin time, after
the data has been written into the pages.

However, there seem to be some places in the
kernel that are not marking pages dirty when
they write after GUP with FOLL_WRITE.

I suppose we need to fix those, given how
sometimes they can pin pages for a long time,
and do multiple writes over a long period of
time?

I'm combing through the tree now to find those
places.

This raises the question whether we want to
call mark_folio_dirty() at all from inside
GUP.

--=20
All Rights Reversed.

