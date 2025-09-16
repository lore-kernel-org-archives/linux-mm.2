Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE954CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C258E000C; Tue, 16 Sep 2025 18:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCD38E0001; Tue, 16 Sep 2025 18:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2121B8E000C; Tue, 16 Sep 2025 18:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8748E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:58:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC93CC02D2
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:58:03 +0000 (UTC)
X-FDA: 83896628046.17.F23D870
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22A42C0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:58:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CdJQYLee;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758063482; a=rsa-sha256;
	cv=none;
	b=PmxjWBfx4jKubmRrdExWC+ZGOTbHAUcUxF4UZBclzmTbCDm0cqL5wWvLiHK/zPBzZJV1ET
	0z4w6GGvGpqAEo+PwxENRqMTd60t7aolaIA6rlYj3WO8WmH/am8v99dfvsd9FG6zTCua3V
	HJmHKVNzmkRpNSPS2q2yaK5m4yKcd7c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CdJQYLee;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758063482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=962Ya8WbZIcFc3rK6+ItlnR0V3Bzyc7brf0QRJ6xPtE=;
	b=qhrlFRIQDEAPuvTHPYkbv7J0INcnm+chFtwjVISUlN4tTHb56HV+Pydsd+Y7aHqmQYGOk1
	8CY4jwAFJulDh0DKbxGNbUC/I9ri8MfQen4/d90G4KHqMCK/lWm89JfRVF7TscybGcK54u
	5dhkMFDNyDf2xIhvDw8AkllzQwsrd8Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=962Ya8WbZIcFc3rK6+ItlnR0V3Bzyc7brf0QRJ6xPtE=; b=CdJQYLee3GQh+wKmt21VERifqu
	6Av289A+zkiPEcjm6ZnN8BoKTYLKZ2+ITCjU+U4ydipm+NcvRBPvqHW3QcW3xTjBVADIMANoMNhXp
	4cIfbuN8LOzUFypuh3D9P1dEZLtEJdpcC43uZqPbE74uy/aX6GxV4nPqhfCY0m3wZAHdMyQJTDqdg
	WphqZxbJMol0LgnG/sYUihaq7ZMkstU3W7J4GHIEID8+GYzzzsm/Trd8mBmf/mYdZJp0iOz7B0SVb
	34h4+fIQDDPDMw98eVnB+dN0y/PDC4oHuC7+o/IzkZkpkNpz2MHu5rg7zLmgHPwgBxqHGtvkkOQRA
	o5YcdK2w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uyecK-000000001Qv-3GIS;
	Tue, 16 Sep 2025 18:57:44 -0400
Message-ID: <6f2708406372450edb39ed6ed5a5d0bc112c84af.camel@surriel.com>
Subject: Re: [RFC PATCH 05/12] mm/cma: add helper functions for CMA balancing
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Tue, 16 Sep 2025 18:57:44 -0400
In-Reply-To: <20250915195153.462039-6-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-6-fvdl@google.com>
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
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22A42C0008
X-Stat-Signature: uqez1te5eo5hoobpdiokh8mhwtt8t7wu
X-Rspam-User: 
X-HE-Tag: 1758063481-427295
X-HE-Meta: U2FsdGVkX19mWAfEnJkBNnjhq2SVyq89BEujvSPYLmWG3vV8C2PKATiqj6+wuUrGvPeyjpCDHF+uinhHKkTmIjkUpniHs6w3cPWraobgdP3eOU4LYiWdvE2S9UnXD9m5EF13GAaPumvaM/aHOweUOt6q/Sgke8FabAkYbZGbpvvXU0q7sug7BXuKjBWiR6tDwn1SbQ9P3GEreSjbVku//CqjkFPPNxY2DT/MpqJQinpWXBi84TrWYsYOataGOebbCMA57VYHtd8P0bh8sGTd8qb9EX6wX4Z4696uficaMhnbw9ggU/fbA1xH60gYEuglCfx62QLvzGyDWgR4pMjxXIIToC0GZK1tVdQmSVNc1jA3+x2/Tzm6/GhyEU9nCWIE2Y5sVhJvAoIE/MOsrjlU+y8umMBhx5e2Gp8J6mEK0W46FcPnm9ibLnavpvJmcgjNMo5f/L0sSH5HKzZd4f6bVg4QqKdacdbRGx3unIdksu4PnTUNQUktSHe43rqx1RjeMcrzLADYJh+efeBSgSuecSEGqn+imu+60ml6U19F4g9C74IGlz8HSzzkVgdWBPZwZjwo/FZIPvhu93lmcLYD9X0uWtm2v9+PWjpVEXudWTb2VstbPetbNJ1tACEVD6BxSAc5euJa1umFGTxeHBpMkFnrd82Omy78dRvfroGhAQkhv9qR0dFOmgZVkKGtWZblbRr72WonM0Whe3Gd5heQSBYThi5RF2dLHZ8gLfDUUM/NC2fSdds5iA4wde+LsrabMKXNBe3bKyrlH6U2gdpX7q8JiNgbXUzQYO1XlmWSrw89KzA1x7a//aRUmONPgsnuYcpHg3x7I17BcObFctvHES7P2yvdViJglFw2gsqt35J/4FXkruD1wxdW1MCMbMjNPbQm2Gj62FNC+QZXKncJ7/d/PKfljuEqE+N/hSbOe6REwP7egwhfL4R8hNB+lJbeAlov0P2PwOjn7KkWLdr
 +KWqiM+0
 NtTjhFMeItDqBpeO5e3bDLlRsMiAESONgvbU/O1QPs6/fqwYTtkF0DyQ5b5Tw6zrqjz+/xzRVeWbg0BDtvqGGi/J6WVKT/cystby6wrNiT3xZr2GfolnkWXOocwlS6AvqzKwyw+fe9GtWmqJfMFtH/TltvZveXi8JEE/5vMGd2nW0XNFWUWbOfIJRHe4I1lxNv64ozeAnbS+IIRSsAV6OFY7NLpUJYHCuGGc5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
>=20
> +/*
> + * Provide the next free range in a cma memory range, as derived
> + * from the bitmap.
> + *
> + * @cmr: memory range to scan
> + * @start_pfn: the beginning of the previous range
> + * @end_pfn: the end of the previous range, zero for the first call
> + *
> + * The caller can adjust *end_pfn end use it as a starting point.
> + */

The function documentation does not really make it clear
that start_pfn and end_pfn are also used for the function
OUTPUT, and that the return value indicates whether or
not a next area was found.

Same for cma_next_noncma_pagerange. Other than that, this
looks reasonable so far.


--=20
All Rights Reversed.

