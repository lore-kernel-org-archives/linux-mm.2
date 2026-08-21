Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 390C1C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F376B00B2; Fri, 21 Aug 2026 15:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4464C6B00B3; Fri, 21 Aug 2026 15:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C176B00B4; Fri, 21 Aug 2026 15:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 134496B00B2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:34:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8625440256
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:34:38 +0000 (UTC)
X-FDA: 85126278636.23.5423C97
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE017100003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:34:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ItEM/Z h";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340876;
	b=Ab8jqkHnS0aef5vd5JfgkBS4qTDdqblL8JOBoP3ZeGvtI8B6kLTpdOj3Xjq4os0nIG4Ex+
	VaKxWxMpeGyY+6V2+DtNc8X1g6mwAPWvnT2NiIaCjDpKQYnhhNTfr5cu7YN1R27GRmoVBQ
	Kf6q/OETmmGHVtA1gbLc2eNl+0DsNFQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ItEM/Z h";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apR/SL7EOGYA6pQsnj9uSwhIrtp09LqCajLjnk7fEZI=;
	b=sDvUzx31nMKjIG2X0E+GQQTs9zBaV8qO1x6pynP+cETQbaAwtGCKYqASPg64WVdD+ke7eH
	6gp9TX7qD8BKMDwgc3IxGTvcqfoxIGRoNtecdKjs0Jc4JLPBMf2cX7upHEaIb1uhB1MOvl
	uk/Li/JC1kpdg/7wg/FG0/NIECMbiuM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=apR/SL7EOGYA6pQsnj9uSwhIrtp09LqCajLjnk7fEZI=; b=ItEM/Z
	haYVG/MyV3KL8a/I5+wfJDAnN8A0gt8E71uTRg91cmQXG35I/YbMr/zRKQQd5kMoxHuhtVwSh2ixD
	vuxyZvU+4iN7PaXvgGMj1OlpDBXiopndhyhl6J2UfZ7lvfsyPZKs4lYgdl7L/pk907NkzQcKlqYIP
	JQ4MnbIElJOlnWt2LxabySlFsHgEFotKIPGSUs9oHXbfi+MnMpqUpxL277XzdZMOLHeGRFUcsdtsr
	omYbgSU5dzJS0UvvsHg/NYxrPAEs4rhUHhp02mLScGY9H/IAQmcj9AGFm6Ye1Y0Yf+icEHWvKl94Z
	qdiJFs1GWfmw8OwTyymxP4LHQvlw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wxV0Y-00000002AD5-0m1H;
	Fri, 21 Aug 2026 19:34:30 +0000
Message-ID: <500549bf86f8fab571424af9a7f3a69bb1a08a5b.camel@surriel.com>
Subject: Re: [PATCH v3 15/19] maple_tree: Document erase and allocations
 better
From: Rik van Riel <riel@surriel.com>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Jason Gunthorpe <jgg@ziepe.ca>
Date: Fri, 21 Aug 2026 15:34:29 -0400
In-Reply-To: <20260821192627.4085470-16-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
	 <20260821192627.4085470-16-liam@infradead.org>
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
X-Rspamd-Queue-Id: CE017100003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: e41ptmnzmppca5qhnzgic3dynka567md
X-HE-Tag: 1787340876-329027
X-HE-Meta: U2FsdGVkX194n0EnyHVuEDGaU5/YCFXCiHSBXD4P+AQDoEUh/PM/I+6DTtjikoK1J2KGTVKEkJ1M11YGzv0BBSbMsP28lTLxpS5l7UnlkHXpVbI8z1nIORfKWWLKASojCkK7CJiEluJy4ymwswLjBn/2Dn4tJYgisjfcL85N1e2bUje0DUncpnoC9VlK6FiUUgJgxEoKqLSdQZeFwPFPWXhbgj/m9Xvo6H4PYIRBAA44wvWm9wFBk15VqtdJpX/g8H+QZ0w+JSdCzBn5y4rVDx8MHRgh3m62PnQmkcbkY4NdaNKcms/TumNKtlpDajG4iO7RS7oddQJaAEjjiIHLzpNDLb1IwunnRJPMO8WzB7giH7BJTYdXEY0tAvLFcfEz2TRZntDJdbkLmnLpUw/gu9kSdNswxSxSoSLZV1iON4nZvpeAX0tuyTIzQIoosByqjCx0adIf925IdKvPzIxfIyxPZFOwImEDQgyC+IbPy9qGIrXDW9Y0TrGSTA48xKHVYhhgn7C4xXIcd8NMV3Z5VLElxbfL9i8jc1C/n/Kbgr3yNcnC5j0mU6cX1Mgk2K5EDIm1Z4/c/4rJwdwqcSnADbLOsJyA6vCxocoZFPCrfSLUj7B3hQr6nInM37cnpSPglgu3dpG+YEJoVKPC3XSeRRN8OBCaeAwe0afoyn6xbGtAqPoKkqrMoVLn/9bS3S/bVIo+joKkCMNMksp+QUOrK5qJIY2NcgmrqkxuQS7LGLfukhmMVnviAZ7DA/ob6SF3gdvBzEgRGLe6NoAOKALWQ1gUehu6t3fwEikxHeQJKcKsv7BNPVuG8ON3ogcXLzxGgEi7/8lcroiTtTKFz8k8NBEXVC9w2niCAxMN8X37q36cs4E2TcmBAeqCWFAz166PlF1OdljvmWZjZbgKB+tctBKhopSCDQOwdTCrqAjfx+dx8ZZvE9bJn373Bwj6L1GGNEc5W+z+MuvvHjPc4D6
 LZXI5wol
 XrVD/I0YY8At59Iywv56rqDitsSJlazlKULXbAGjl2j+Jei6CqYzefR9vK5uC/ikdvNJq2GQT/qkihKv8/YbIbSVRdgzyd3Bi5Cya5A/W65w3LuqO59XzqS9Y9xFakdIvg+5JpKA9WYYrkjdngBN3WML6Z5Tr1PgA8bzQl0qAc5iOXsEGSlVOVPZJxeUBVteCpJwVND2+nmbiXmME541QiGFm5HVTDOLe3quSI/7ldAdmam5I5V3Gt8q+hZ6w2m1tXVF7Sg/mLlHTatXwJuXaoP1Y81ouSBT52Rva8MutFLjHO9rdvd1Oi5HvGXGB4FR8/usV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-21 at 15:26 -0400, Liam R. Howlett (Oracle) wrote:
>=20
> =C2=A0knowing one value within that range, or mtree_store() call with an
> entry of
> -NULL may be used to partially erase a range or many ranges at once.
> +NULL may be used to partially erase a range or many ranges at once.=C2=
=A0
> Note that
> +mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and
> cannot
> +fail, but may need to sleep - do not use mtree_erase() from a
> blocking context.
>=20

Do you mean "from a context that cannot block" ?

--=20
All Rights Reversed.

