Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84AECC54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9F06B009F; Tue, 28 Jul 2026 16:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699A56B00A4; Tue, 28 Jul 2026 16:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588396B00B7; Tue, 28 Jul 2026 16:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7C96B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:51:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D75E7A03F5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:51:10 +0000 (UTC)
X-FDA: 85039380300.21.E0E81BF
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3AC9F18000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:51:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="QI8Gdru/";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOyUjsmgXcmwxLGUR+BXyO+9MAop4Phk0/0jRVLflok=;
	b=dlglJtKDAqxAPhJ1n5jPbjBl45jH2ey1N7qm9IuLtlplz4jDMnuXIRzBJhQLMaPgjOxHzd
	tOb7qeOkWE8D69zGy6SaMqLTyx4YxLFjdNFhzn8y7jy0+a3Uc99sQ9k3fSHg1MfNwx7Tlj
	TP6POrBvqOGJeAzNrs/hKpCKU5bwERw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271869;
	b=RktxnvTnhaNuYvmIQ1Eq9iwmXFqRWD+dacd63ZyehoTMWGX6d51tS9Yjnxgj1HG2xM5yoN
	pePrX2YnCK0an71uMZHmh0LFipApULOBCOwcWeBAa7cR5luUutmb2a+yCoDO/rUTRERU7d
	OHrUjW1TaijPXH3EELj0vzj/+FLZs4I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="QI8Gdru/";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cOyUjsmgXcmwxLGUR+BXyO+9MAop4Phk0/0jRVLflok=; b=QI8Gdru/6F6p8yIdMjYE2vFcbg
	O3+DWaJJRsMeK0A5lP0nf+4vUUvo062X0rjfsCZHIl/qPvO7LMvNVbXPXIf/UapWt48pOx2P3dNmv
	Ic/I5AjnaAUEnyu6ZonJZoZsN8J4+7cFl7V1MaTu+S1boo51FeXOZPNEqlxYXjkEXHfzjN4uSvk+D
	2eWztvrR8XAtDqsgzR8UVKpCu2Pcer0TVyQulNEmWeQ2XIsqeLKChx0LBnpLuIhPfVxDuqdOqjsdJ
	i+WaQX/DmTAnruW3GLNQXOAR6m2xVO/F14mhCmz1Yb+u5iA/1E7lXaL+aPxOnR3pQ4VAfqFX2wsEi
	HucH/aZQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wool8-000000000hY-0AjG;
	Tue, 28 Jul 2026 16:50:42 -0400
Message-ID: <3a1d42b01fa4707a991278580ae2db648376872d.camel@surriel.com>
Subject: Re: [PATCH v3] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
From: Rik van Riel <riel@surriel.com>
To: Guillaume Morin <guillaume@morinfr.org>, linux-mm@kvack.org
Cc: Breno Leitao <leitao@debian.org>, muchun.song@linux.dev, david@kernel.org
Date: Tue, 28 Jul 2026 16:50:41 -0400
In-Reply-To: <amkC_1Ya6OiUoiLZ@bender.morinfr.org>
References: <amkC_1Ya6OiUoiLZ@bender.morinfr.org>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3AC9F18000C
X-Stat-Signature: cod7x41mjchdx7wxfuprd7o4zdwmojeq
X-HE-Tag: 1785271869-346966
X-HE-Meta: U2FsdGVkX18/nkNPG+7yKABdeuSjlBcbm9wGJ7bMLbX52JcKma39EiApZWigohBUlvT7NpaREnhWGAXeNscs7MtNo4Idm5pgepQ0f8fHKTOvfeAZMBiyqpZu2FNRcTRgHnIIGEfhAusOLWeBblwxn72L/u7x9CSZqUeHjoQ8NAhOrbOV72/N7YYguRRFLcyJMWlPT0rMDhc8uDGcKegTFcbCfz3IioDzZ2ICpveamDzJKrMC1MHi5rrGvI5hGiMfoFTU1Ls2IpOO5eO8LZQK96C6ltyQxO/mqro9wwUjky93dMol24KoaN+19DMeHOnZUzA9Yd6frjfqNXky5G7gYuGlTbZ7QFSz7DQm8pufQZqGGESoue8wfoon3WWA4/VWv3hMCxvygWqFjdAAJXyQRsT+29nhH2rYXP+JsbAfLfY5JH2eJEpoH+MC6OAFg/WTsC2SkVl4sexmRMRm+mpuY8Hth0SsJy36oGyWd8Z76fU1DKr/0kPfqONPKJRn9zxmPNFNM76Ff3xV+dDGNXqRNyF9n8cy44gYOAGu66QBTyivsHi9Sx8OX+dFpY7eQGECDtO8Ljwu6hIMFa4v4icD1pOwk2Nv3wh38ozk9iNtTfowrk/ND2+7zMXdBhw4SQMDWL36OwOBA6BoAdX0bWENIUiSAxL7et29C+5ka8fU3gaQg6SlHzxp2J2R1UTIgsqarETJzayYwIokcTbfGOF1ZvodhatcWwABT0x1lrRhBcbVy7xKyxX8UqFcAqi0wicJH6pQ6p//fpg+eKoIjYPC1Ui+6BhLcAZUPf4DPlUREqpWHKpjqrDBGiB+YHbERttKJ6pdFFqP7CADDINoR630cUBIqDeNTOtK1+4wtlpzDYK8MD0ikdsmcAODeVeSa70IuPcDnKb2Ut64Ea4cDyNIbAkNKmzM30QASJiULbWHoogTJRQS/3WgYPrx2kdwfawmQfXkMMLHGhOAdE/VH0m
 W44qMUqU
 2lmWrpO5OTmHKiLQQJXgjQNu57Z6Bg9zwSCinnl3QyDYy3hl7QV83YdFJivKGXiLGceAbrofCiKeez/tJYbigqYtTIO+FDIQXMSy3flcFrSK2ET08i+5DVG3lGW7P2DGeRDCHdXdCnpOH3arDrpJThKZMUB9nLbnGk/M57rhdc2o94Sw+LtNe0nrloPUiFO6GRl8kWdmuNLCh26+5UO6/NbnN354XPH/UH47zUNlIHbASzmCtl3MWEp7k/Tx1P3jEFlgh7fmuBRPozXnxNDJNBixqRM5nxOrnR4FRL78kp3J8gQQJoW87G6iW1xcP0DxtDlzC9kimg/jTZsg20nyk56VOEHgOSp93xQlCVs/B57DDLSqB7w4DIq/EIDN73nFCQHsk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-07-28 at 21:29 +0200, Guillaume Morin wrote:
> Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations.
> In
> the case of folio mapped in both a parent and a child, if the parent
> unmaps the range first, the reservation adjustment will result in
> an underflow of the reserved count. Once the child unmaps the range,
> the
> count is restored.
> Change __unmap_hugepage_range() to check the mapcount before
> adjusting
> the reservation.
>=20
> Link:
> https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

