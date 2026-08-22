Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE10BC5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FDF6B0095; Sat, 22 Aug 2026 09:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420DB6B009B; Sat, 22 Aug 2026 09:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30ECD6B009D; Sat, 22 Aug 2026 09:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10BD16B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:20:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1010D140133
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:20:28 +0000 (UTC)
X-FDA: 85128964536.08.EDAC7B2
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53C4EC000B
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:20:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Kmf8z2 z";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787404826;
	b=hUf80wnCYPlqfgSnw8rbRxWZcS+s7xcCG3Ra0sMf3hRDwjl2wd3ASNZljJFu8h9UNwftK2
	RWI3VlwVpkIzAE8VeWdvZ0q2BzENZUw0YTxEdTL0I18HyUTyeIqTS+HemoRgXV1UyEvwt2
	lsfjWTrbpcX02ewVPxWTat4f0pAND8Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Kmf8z2 z";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787404826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjMXvPk9aH54O5E/fcDNppHp//EgL+Bd1eWrHkkFL4U=;
	b=EHwsTNu0V9iSGt27EU4nfyTba0rIuHvQ/iXgp9idifOmDYNpnL3wZ0GOKDItck9wyDCHMN
	4lrLDsVJdcu34i8cQMGzovSfEBrXhu0AWEdnGKE5kXmii3GabLvp5FMzfem+QE9zU82Wo+
	tU3e0hxAomDSBb27GCf25NHjNhOOUw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=EjMXvPk9aH54O5E/fcDNppHp//EgL+Bd1eWrHkkFL4U=; b=Kmf8z2
	z2JWjgLOFoUVn8fQxue+KUEv1gSA3YRhP7b+ea7Jl8DgjSIOOd6U0uApckUZpr9o45y/v52NWyXmA
	myJQBFTwR5ucBdWoleZgHyV4r8B/X5gfBHhxVCRahtW5fjBnv3icdtzmYZIg4EFrDnBBA66YgitQC
	FiC9GE2yA8jOvSVabhj/YFy0LPF5Vmlz90GarGSrByI341ICvIkLq4Xe2aUFYbdHYVu3j5xFYVzDo
	zlg9l8tPGQSNmFsVnEYXCWqq1CE81DbWsCGMYzvfKz75VcTG9LhB8CK2htuHqsgb0fLqH2ph34K6U
	q9q7ivFXmaK1fy8r63X0vUFym2MA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wxldo-00000002LbJ-0X79;
	Sat, 22 Aug 2026 13:20:08 +0000
Message-ID: <f86ca125a9b63cdab8edeb3c3b02a29141f18c1a.camel@surriel.com>
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out
 of follow_page_pte()
From: Rik van Riel <riel@surriel.com>
To: John Hubbard <jhubbard@nvidia.com>, "David Hildenbrand (Arm)"
	 <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
Date: Sat, 22 Aug 2026 09:20:07 -0400
In-Reply-To: <fe9f0bb5-73e3-4509-951d-e529e37011fd@nvidia.com>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <20260811025157.1632867-4-riel@surriel.com>
	 <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
	 <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
	 <3b8cb743-702a-4362-9abb-7c30e687c3c2@kernel.org>
	 <ab1661573257d7755d5a48e4f9165ff22febba29.camel@surriel.com>
	 <fe9f0bb5-73e3-4509-951d-e529e37011fd@nvidia.com>
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
X-Rspamd-Queue-Id: 53C4EC000B
X-Stat-Signature: 64g7xcigsrckhmuqetnmheof7h5d3nsd
X-HE-Tag: 1787404826-36860
X-HE-Meta: U2FsdGVkX1+qi8czrTzVefslrR0om6MXWJy2VL0SF5dyRPmQOUZWYFS8CZqsInHDVlqvNAWViG5vD1SQ4nUPs8WfDRc24padnB7+fKkY8ScJ1OWBdXwhLcvElkvDATps9EQVqAv5TfBtBn6wwX6W7IHFx4pk0p2BJOtYZVc96aovi8xPe3dpfinCzWTvOLzRULKWGHxJhGK1BT1wWq6B1MtrPNnl6jfhGM/w18H+50DtQkU+OAbDRIHXqyH+0TGWBt2Xyb9PggTWRwX3V2YEgV2moLAldtXQSAanGnShCyAbsFBZeY0zoXakHXMkQOLPf0tY+Vxjh22MlWO6/VyeUTEMqVorRD//0eC+DdvAalwDbtppBFEMLUnOAZoFCaZt0NsQ2kiD2ZKjSsscldHuznPGnE+MiPrJjiSJ0zIEj5f2o3rzc0GP0x7qRd6SFkmj9XY0rVjcO6a+F1XNS+sDGbDTTrDn6gGcPTf7cGcK2LOey1eiSjPwnC0M7gjz2jJbEMWUmNEZbMWbaLkuxN3FrjvMw+C7r31ZxkaR/QEYFYn/knFsfZuuxG9FRjKhW+Amp91KgaoCx6tCapoRhAY12d+SR1nBRv+BQN+nEyOFe19tYJJVMIecMBZtHJxIzJclRZR0+qdihFP09eLRES1qmpccAmaY/CkfW2TKg7F5hQSMhJrD2GMk1r3XXNwvv5/lZtXPaIjALXshKjb/2qCoM8QBamhJ2GQ9pna3D8OcL32br1u197/NZkmmJWzcSQswNfpgSI0kZHTml8wGuNiNOmQ8foIlI8b6H5OkCaLNJiikOzyfzkpYKDD4xQZdFrYFGGVSBwr4rGo+d09vP2nq7jRzx0X9zP3lS65pzWPqDTqC9pfT2l3qX+kddp5dXjM8aD7/YFvzoRuShSxJo+6izNEiprHjq5GWwtreO5iUCMS+eFqjuO9RPTUorUmMYbjx+xQ2AFuiL3+MbioumWq
 31hygdGh
 6p6hLMq24BGUl+AUggb2s4hzx8JsEkjjAXUwazdMcMH8rZaQZWvrdxjzIToXHUkOBpWgaH9lFBUTY0Gl0VVDnj1+lNm55N2n7gsABNRKCrLsjYZ5tTjsWzDhaKfqNJlXlZkjw6AFRJd6Z9hJnhMPlouKiq6T7Iz6rWI4DWCNSzjBO9txbeFYBMWqDwvYJBdNrBvpErhibbAq1THSZSc42nXsdDwSopbxmRP4Wnv/4LEzaqNOwOuSkJQZKijazyjEqYQcUL3zL4QMno9SuTz/YIfxvo17uv9HOSzPMrR/8fEMfUf09Bv41NXpj70xzSH9F0NdB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-21 at 15:04 -0700, John Hubbard wrote:
>=20
> You have delved too deep, and now uncovered something that's been
> a problem for the whole time. :)
>=20
> Specifically, "no, GUP should not be setting folios nor pages
> dirty", because that generally needs to be done as part of a
> filesystem
> coordinated set of steps. If the page is dirty, and the filesystem
> didn't expect it to be, that leads to problems.
>=20
> This is part of the big, remaining set of required fixes, that
> launched the creation of pin_user_pages*() and related. Connecting
> up the filesystems properly is yet to be done. And until then, this
> is a real defect.
>=20
Not just filesystems.

I found about two dozen places where drivers
fail to mark a page dirty after writing to
it, after obtaining the page from GUP.

I'll get out patches for that, unless there's
some reason I shouldn't.

--=20
All Rights Reversed.

