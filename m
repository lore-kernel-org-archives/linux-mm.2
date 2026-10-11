Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30350CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 21:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C3B6B0088; Sun, 11 Oct 2026 17:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB916B008A; Sun, 11 Oct 2026 17:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2DA6B008C; Sun, 11 Oct 2026 17:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 355C46B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 17:44:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EEDFC0781
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 21:44:57 +0000 (UTC)
X-FDA: 85311675834.15.D12E53D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id C2C3C20007
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 21:44:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="EV4Zdl w";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791755095;
	b=rGOaVkilr6PQdB6/OphRjGIFNvAm0WnGkYtr0jVt1fRn4TO9EOpUbi7nw7fUTlg0k1zvYO
	w/RCWjQmYW3raz5gf+2GfTaA23Ptme0OiwWrJr1a4YN3JmKmF8Zlyn4URj66RrrE3Rx0EY
	3n3tbfeuEsbWVku9zzgpux2t1qYWZLk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="EV4Zdl w";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791755095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbf7Z2VFPiTT53lRwlSp/xE5y81p6hF8UBpX7LIzQ/c=;
	b=FZp4lStJ7taZrTibFRGkW6uuO3fgqELzx/xcXfO3TpYByMAsKUZvNP/Tq/m53DzIxpl7Ed
	Qgzn21Jlzc0vDoxe0Zl7InmIZ8+Bm1pFfADkMnM4ECVBL2Zg5795Tjd2YXbrwxWZjuUhtd
	vchyg6/gRwVKZjiljZ8Wp1ELewd11ng=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=dbf7Z2VFPiTT53lRwlSp/xE5y81p6hF8UBpX7LIzQ/c=; b=EV4Zdl
	w435M3Kk1dbk8mAM9muIWjItRwj+bSQYYoxZms2gdJuyJw/R6DXrBAxpCIoncZ6sBfcWhiN597FoW
	aR+/EHtKRBt/n92s48UuYEbmV9wi+nxZNTDi0UOpQnt0P0kBuiBgE+WXsPPt5vLgs8E2i4HOxfUiQ
	Be+zWT+oErTFHbxhp6y1Pg3RYkEb3g/yKFMOksl+0VykZpBBF/R8EITDAL1Gjx2ABRHxDSLs5IcWg
	QAJbEWTk73YfB2pGDp8lwkkrUa0wNGcgCNKUdvok3v/b4P+tzmt3wfvmf7zDB5p1gHKn0zeEFn6WD
	oI3fHOZWKk98t6AEa7T+1pRfneEQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xG1L3-00000003Bmh-3JvA;
	Sun, 11 Oct 2026 21:44:13 +0000
Message-ID: <003fdeb213ca0460c8681d4ae7baa562b337ed1a.camel@surriel.com>
Subject: Re: [RFC PROTOTYPE] mm: reliable 1GB page allocation
From: Rik van Riel <riel@surriel.com>
To: Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt	 <shakeel.butt@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Brendan Jackman	 <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>
Date: Sun, 11 Oct 2026 17:44:11 -0400
In-Reply-To: <55adcc67-e545-4bf5-93ba-7e4180f1b523@arm.com>
References: <20261004013657.03a63c4c@fangorn>
	 <55adcc67-e545-4bf5-93ba-7e4180f1b523@arm.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2C3C20007
X-Rspam-User: 
X-Stat-Signature: r675f4cpga9kx9mqr7fcap1tkh1ixjdo
X-HE-Tag: 1791755093-513870
X-HE-Meta: U2FsdGVkX19wA8vozLFLfXaCnpjE7sjeXQ3dNMT1iYHqr085kP2V46uuhDnl1cZtzCG3UnZ9us1Rkf2k5CmNtTaDWJnioOqnpszSgUOHsntLF/w7lG1KmH0by8HFnEQke+mxBpbHWD7SPXXKadTFJbS0T77UDDEhJvPZ3jNF+dJ953+s78DsrgLvkOBeiQxLG1PujJa4iD1DjWVH0LJy4ETOZllGCoS/Wmxni0O2YaF6Gu31GzKTSU2LNKySivTSb8XwexlrOAapf+h2xFkcYa0YBjBHh1b6/41PsY0SqMwBAbGnoTG4xLAOZudhwAEDR/P8OlMtls+5e1wSEzBoSY0cjajO3G2gKf637fPynry/K6qex6c1f4enEF0tmxD1YlxNGzvT/B7KhYbnU7y0rfqGDPUT6Mh/HDzddshRK4KjI695fooDjo6XE40luRZJoia/FJlIrmxdGHcVRe6tApczLjsDgxD4W4+JfWa9M54N/FmAuN1opsUNexHgggYEh927M+SaZ8/OEwWjy8hQ5mK8jpuoxXJWEVkwdnd+NOCrhkVnH40R/vlmM09YPURfReObiAYnaG2GzLMB2ZtlYVe2GY0a9baif7b9kcsNngZ7XM5nhaOfisbVxOBwwMavH2damXdU7NFt4TIgUIaGUiXTI7B8/bq0iPfdrqZ29caSXiIvRvOIdCsLQOHy0V+2KnUtbRNhxFIQphv1tsgBkOkD+Bp2phvHyuep1wkqFmXLnsiYn3lkJ7BS85uQScd90e2b3nWwVcSEBCJD7B2e+S5yNC/g8KOlgsqugNFef/PUBMCRa0xLJycqXy9BS1hAJI+nNUCV0JgThaN6cYHFrOI+mnFQ+318DGG6+gWXDkHapmCBS1SP5F0rwQ1NeqFZOBVmhlBRkhXRLRs7Dwrz9/RRjXVn5hSyHZj5+GCJB+Ew9k4wBbf/OsFet/fg669CGvixXfx9ED5gXhuEEJO
 Ed/L+0s7
 JcRbNnRdnpE3qgABbdN1R4N350QrH0vP+BdnjSmT8SsIVPo5R/T//LsIsVS5hEQDNZzTbfMVtlBrsUh/ArsLuPvZjtIoxRe2+Bpybk9wqUp7XhpOsezj3O0KdZaKwA/TSnneUBqLworSYYP3OmsVJ7eJVYsgHUNP2jGvkP/ylKs7iqRygkpTgR+M2m7oH20OPUA8OauvoOWIBVLv69zlwiwu7nl2/8KiiKL+yqWQbBsxBdrSVzJ6/cWk2eJ5fUNASTZS8lcU8hq35oVjAMV0B0PmYug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-10-11 at 22:58 +0530, Dev Jain wrote:
>=20
>=20
> On 04/10/26 11:06 am, Rik van Riel wrote:
> >=20
> > When the kernel free lists run low, the slow path moves pages and
> > page
> > blocks from inside mixed gigablocks onto the kernel free lists.
>=20
> Did you consider a design to introduce MIGRATE_POLLUTED: simply
> have another migratetype which stores polluted pageblocks.
> This idea can work in general, not sure how relevant it is
> for gigablock concept.
>=20
Don't the first half a dozen or so changes from this
prototype do that already?

What differences do you have in mind?


--=20
All Rights Reversed.

