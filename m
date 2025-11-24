Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5A4BCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7146B0022; Mon, 24 Nov 2025 11:16:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4574B6B0023; Mon, 24 Nov 2025 11:16:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392F36B002A; Mon, 24 Nov 2025 11:16:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2754C6B0022
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E71FA13ACCB
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:16:03 +0000 (UTC)
X-FDA: 84146002206.29.316F034
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0DA3916001A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:16:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=igl0mxAp;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764000962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6beLxcxpvJofFupu+Pp8rnFaBGMhE6ymVXBxzN7ScaU=;
	b=D+eYgvcDuB2cUvJoWtOHiicTPeTz/Pr3hzLFAA/zsGvzpyWYgpa0BRE3br9Z56gktLe/Pk
	xdS1F55V2WstWXeBLxTmFG0IN1CT3SR0AZmL8IBslA9ugGplWuQ5G1yrUyxiWneGaxchU/
	Pc7yJVZ6eF42TD0hOf7LHgQZySqeTek=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=igl0mxAp;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764000962; a=rsa-sha256;
	cv=none;
	b=vQbFg70HdwC8vOKsDahg1vvGiVhEkuJwL+n6BaNvhUycN0ZaZKdmW/9fpgEWeb7WWyVFAF
	9VwqK5C+Kym1ylzcoLFmn4ki17dwJjEfMZJEybsmeU/W9J53h0xbx51mIeZ2jF03z/1BD9
	jbsJk1PNdlG16vOpGOBb6Aoyi421MXE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6beLxcxpvJofFupu+Pp8rnFaBGMhE6ymVXBxzN7ScaU=; b=igl0mxApDDmV2CGkLDpRPW/MOV
	lUKY9WvBVk+fufApJzqDbEXQf5rEr6so61OrNktZy34q14BqvRZ6+jM7Jqg2URrAin2LY2s4DO3+a
	XgF2W3630wCBBVsBuZ/1tqr7rne6tvArqQzkYx3+uCBd/7/K88Gnb6Gexrq/6lnMWarSEjSrwPLEK
	vHmO4j9kSVFRVa2ao2P1zVEPPTxOqhWAnby34t4Dm26QSHWpslL8zfaTbeFjuxR162JXEagBqnKrG
	CctHhxiKkXHm9pXkUgY2/Vw4NdrkNr1VMIpkh3FRdONuEXNDNJ/FqHFaZHzhug/C1K7OynWOaxEM/
	4Rc4Ywmg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vNZCu-0000000085j-0CbX;
	Mon, 24 Nov 2025 11:14:29 -0500
Message-ID: <340fd55d9d7d9436f18205bb458e9bd469b36c6c.camel@surriel.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song
 <kasong@tencent.com>,  Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou	
 <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 	pratmal@google.com, sweettea@google.com,
 gthelen@google.com, weixugc@google.com
Date: Mon, 24 Nov 2025 11:14:29 -0500
In-Reply-To: <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
	 <20251121114011.GA71307@cmpxchg.org>
	 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
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
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DA3916001A
X-Stat-Signature: yd1gcnww814ck7h1utpa3we1utaxcg93
X-Rspam-User: 
X-HE-Tag: 1764000960-413032
X-HE-Meta: U2FsdGVkX18tBNs4q5rfuBn5d/JvrrG1WKpI28HpNhiD5dpIAsfeUvur7thLs8aTcDXsbn5vmvS4S+O8VIwwKS1b0vha9bk2cmzwd9pQWXBS++W4lHNDRCS5lSgPQnrWpeGuiwWuT0j9eiYC7cL0yp1EWoJnbjgzlx6KQOwL+HSn2bCx1cYdab4+Ybmkc1Ses+Iu53to9L4LNAKDRIUbo1SuDDVrv1wgHgb8ETDxsw+XU+BRcXv7WangG1YM6abL3owerjj6dnpBo6xcLgtsHXToC4LoHi7IPtj8h5UwlMI6YpGx3ZNax8yF6IgY2A3ApMqM6D8EPc4uSTLm+ngnabxnjz+Ljr7bUgJdLKNHxhsVJ5v5b3l6MI2kjQZ2kmpYCMQ7NGzHCe5+XBQ6+Who+Oad1WC0FICLV5ydk3IBaefpPhkkrXgJa9gwypYaa8Qti0JS6+wI+k9rm+nfhRTWMSvPyADHLts4tuMBi3N694S92vKefnpbJKjfCfdxQ0xoR7aQ+5Co7oTgQ8XkimQqxmr5yzrW2rYzia2J03W95NtEK2ZYtwwbk3yNfTwosgGPypufzd3Ehz5qBNXMZOehiv3199OP4dE6eJq9xJ0IP3asf53K0g9ugeGuYEUvCfd0maejWGrQqrzjVp7LXd0SocajU22XczvQtk5BqnbB+vnZ2lD1g41tiCq2rtCi3RhiesoZpcaAzhOfT3q8sMCn2st8VBacL7TIRw+LNMH3wHxYbAiiwd9Io4gHU56eTIO7ngQF8J/5LTKJ3HKZKq6er9Ecu6Bs2OTdZEwdfGYob2YvdM5SeFxE2/xuVdoY/+u0DjAig3bKkUXk5VCusbM1FKDf6a8uQ83BihGT06Zpv+McBiqObbTnZC4Hda1XOaTjlmkd/OQA87HHY/XL8mB1GEpQY4XuuPGD8VzdbcjR+t6fc3kdOuTCpJ4aAv+IPB3bKbBLVLv1ET+Lm9s/RtF
 UFdzPen/
 S7TahfBG7SdiDwkQkiEzBg0f59dn4wGJohOws6194nAgE032WAJ4NeCTyFoMuuLxuZJ6ysel8I19r/hQKW0EWgsnK2MXWZyBqngcKQHOPUsC0aum+7mVJB+aT0TpaNiOC8F/G71lVBcj2c8vlm5SpQc6UzL3CRn/h0ecTIiCyMJt3y5rEAgYOMjHUoKeMDWEWUHAW/70xf13h8bjQ+DxLpfcu85zDNjXnyLAWgq2Onm4CIlNaT/vcV0QQK7dqJXXxW2B3kqq2mIesbCv52ZaDWW5afQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-11-21 at 17:52 -0800, Chris Li wrote:
> On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg>
> wrote:
> >=20
> >=20
> > Zswap is primarily a compressed cache for real swap on secondary
> > storage. It's indeed quite important that entries currently in
> > zswap
> > don't occupy disk slots; but for a solution to this to be
> > acceptable,
> > it has to work with the primary usecase and support disk writeback.
>=20
> Well, my plan is to support the writeback via swap.tiers.
>=20
How would you do writeback from a zswap entry in
a ghost swapfile, to a real disk swap backend?

That is the use case people are trying to solve.

How would your architecture address it?

--=20
All Rights Reversed.

