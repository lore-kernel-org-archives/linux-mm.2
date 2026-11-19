Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB92606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=FcooJitz
Received: by kanga.kvack.org (Postfix)
	id B19746B068D; Thu, 19 Nov 2026 13:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAC26B0690; Thu, 19 Nov 2026 13:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991946B06CA; Thu, 19 Nov 2026 13:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7537F6B068D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:37:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13661A8A6D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:37:44 +0000 (UTC)
X-FDA: 85452727248.20.5930A89
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F9DE120017
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:37:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FcooJi t";
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795113462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOGyuEBqNGHMugkFQIAH4ZNUVzC7p8qP2vafmtIpIFc=;
	b=2JX4pyBpc5EPDHjE84aAIp+cB6oku1mIL6R9mbu3k169wPnHoRLoS1bGuhrRXm7XSK55tL
	EJz0R+1WxWs+t0IOE3B5o8ivq45rchsbpAG1mrDPkdspM+HwrsD2iWAiEufOywvJcCvvuB
	L243tJ9y4zS81sJMMQ0yS4QI9tA8FzI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FcooJi t";
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795113462;
	b=zI6UTwuTIXV6UeowLvg+fCBYNk8CxQ/Gq6fmEIQ0RASD5oeG7ryhpBRT2kM4ZZBnTfXE8S
	EvDrQ7f28X7lsijMQ6zVdL5mNpLOR+4C8DgilIl+poWcebKwMqRuxJU8Jtm1fZajK6Iooq
	rKvuvAwkJ3ug0q22VvUiUFNv2vdb7NM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=hOGyuEBqNGHMugkFQIAH4ZNUVzC7p8qP2vafmtIpIFc=; b=FcooJi
	tzDw3zVoDPq0uJIF0miKVcEZSjTaXPvikK4Dwi+ZpodFqmT+SuAcm1CEKVEMXVL5NL8Ch+MQUVIVT
	wnY8cFy3sob+4V/ZdnQfnBvBd7uWZUUOQ3amvI1p4ktKPZQOyD0dntAl+S9pkpolZJwK+XKQSEKnc
	ruJYnRZmahq9UarlwFpN1rEZhpAIdGRwJcgQdgW+PbhUMo/0Ir54ctkolC2mZJnxCV8eLynCcvmBf
	XHzGh6vwI43SKQvYfOkSf0oB8wh8toh0B0j0SbSAOMdX1q1B4D8NnYu2CSliN49ngsKuoaXebZPbs
	ca9Ijuu2l3dwkMgTmyg8BXLn3G/g==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xU70Z-00000005X5i-23qR;
	Thu, 19 Nov 2026 18:37:19 +0000
Message-ID: <d0e9436df88758bf7ba121cf4b0e53d6e59b6450.camel@surriel.com>
Subject: Re: [PATCH] mm/gup: unshare-check every page of a pte batch
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, John
 Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Andrew Morton	
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,  Lorenzo Stoakes	 <ljs@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, "Liam R. Howlett"	 <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko	 <mhocko@suse.com>
Date: Thu, 19 Nov 2026 13:37:19 -0500
In-Reply-To: <55dece20-678c-4726-9abe-cad5fd4dccfc@kernel.org>
References: <20261119105701.3f57ac54@fangorn>
	 <81418de6-3c5e-4f5c-a447-98f338f5096f@kernel.org>
	 <55dece20-678c-4726-9abe-cad5fd4dccfc@kernel.org>
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
X-Stat-Signature: 6hw1monrf8oqp4j6dg1ncd96ixjptjim
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F9DE120017
X-HE-Tag: 1795113462-699346
X-HE-Meta: U2FsdGVkX19xBzdDYFb4Z809zx4eSosxC5HGg8ENjIcEKiNYhcN8f/FUErA5xa9xl5BrcgwWCd8kOkmbyzPbjSQcXx/T9uKsuMSLLH0esjx3fUEVPM66TeEJIYN/TMTR8fYJ/VwBW/pZhrxDoXRGTPv5b5WQS/fPzMUODA/W3LijrMyW1rdNmwumMJp1FzgVBnWFBvY3mJ2PT+c+rjzKUa8Ks8p14ptnx2yyszCk2wJCnOZVRMzk73tFeO/ULXZ4ln4K517EnDbflXQb6gHoJv6yYeHD7eBu9+MIVAjAZcd2LNLCY8ttIpdZl3Tq06lQKX4N+J/LIRIGVcuukPgXDd6p2pFCybykUV3Xpo+/sDnI3ZNdTfEH2ikUQxiEA1JRb02JKS+o5oF5hVA3GYhlj0UaXWADfe6ZAZLfv1SCEY6vNTCzsQyLeyGcTWCa7a5D0kKFGqFaGAhUBMLOJ0eKCqoRV6MYEFZsBfDNfmdOz/087JAuEm/S7N2n1iqh1VtM/RLsZRDq7ty0b99jJ503mudyQ5gxOv4MJoDwiA77HDpS7fspb0xO/3Uo0OuLNHlzZnf/EJpf2kad0UhsHm25s/p0LyROaW+BGbhelX0MrdKl4fjYypFMlvrD6bFlV0BXYNRKpSKXtXZ6OzlKoBDLNLV9N9BIITBkaDA3hVjpQRRiDEor1bt3/O5UOTGaP16E8DCYlYDrVNdZKC4HWnk54Ht/xxo+jZl+SYGOm7q49prC/Z7KDqpZIA1AwYmfOWKj6GCsNN3d2qeKnoSVHjfd6+Dh4xLsZD5vcs0ZniOYYAgwaVPuw3+GL/DASGcmNS/gNKZN568SHxkjfxI+mOAXKebUViANTiFp51XRVjEBAz5myIZEgrYqnII0v9CyktAe/B5hNkd/s4ht6uPkLG5S1H31UQFbfnUYoZs+6xaXQFRBLs39v1/v6dtpAEwQRVeEf5ijTABwoXuvtpwzZM2
 7qmdcqiR
 jXVA2Xkh3qsjMu1o4VHJVPDdMzfa4JgrFDR/hytOPhLcRq8dSlMw4gchM95lQf8b63oMVgUVQpUUNAFYUrSkX/C0wDKo89tf8Xzhk93Q5XlA017IfKCJW/cxjLGM62M7a7AroWu6Ll2eCqfVzgPtknk682+z4gjctSp7lBggcWhopkRm1xWKBoOGVU3BgsyZBg4mlHQJoti0z0kjaFjQkkxTjeDEg9fknaaPYhHhJDj+QssLBkWCn37fiDebW2G9BdjJVK2EIFrqQyFkODguVzsvgIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 2026-11-19 at 17:20 +0100, David Hildenbrand (Arm) wrote:
>=20
> So this smells like a bug in your new GUP user instead? Or some
> incompatibility
> with the helper when used in different context (that would surprise
> me).

It turns out it was a bit of both. The GUP slow
path was using this helper wrong.

I'll send v6 of the GUP slow series soon(ish).

--=20
All Rights Reversed.

