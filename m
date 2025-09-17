Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A81CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFDE8E0038; Wed, 17 Sep 2025 11:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8068E0003; Wed, 17 Sep 2025 11:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BDB98E0038; Wed, 17 Sep 2025 11:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3898E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:23:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3AEE59B8D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:23:10 +0000 (UTC)
X-FDA: 83899110540.19.7CE01D3
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3FBC44000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:23:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CwU4Ch8L;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQU70G0zFUhPGUvEQuHcfAfzttzbDI2NDOfl36y9O2c=;
	b=p5JvJObwt0vB7DWO89zUEWulokUZE6wnXlfoOHCuWcucRk8uk3NGlvYBjVDWkEBcCquu/P
	G1Q0eqmE/gzlpxlxpssxlq1ywocaMDBhujUMIoOG6vz/oRbwetwmpnViTNu1i52inZcutb
	2wROFT2PfuJBcbqPV7aAJbzq0WA+T38=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CwU4Ch8L;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758122589; a=rsa-sha256;
	cv=none;
	b=GjsTQlomEAkVw7WEeOCRkTjFX535r9stweoGOnuH2PUtWDAE/Dq0fZX1gkUor4vruKf+XQ
	6YMOec1ITGKvyThdTRsvmQbbG445RSBiGPUdxlgcv4eZ4NAL/p3ZgdqaPEGgV1hLor04Ln
	kJ5z3VqinFtOF+zTC2bpWGTUB3CrDfE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cQU70G0zFUhPGUvEQuHcfAfzttzbDI2NDOfl36y9O2c=; b=CwU4Ch8L5+MTlP1kZMMACEdHum
	zIsW2X75R2t8AzmHNLa4iDvZGYl+9cU5ZoCI/1OzxMvLag/xUc8B/taWLIZPXih6CbFsLURKZKOdd
	ADhEGrtJPevOwsKftjR+GAFVwMCTuksWp/6Y5q0Dn4CPKD5Kn1dDLUYnbcll/OHZou2IQPg8qSs/R
	ZgQh8ErELHDr1QlpfGYDN2VNi72Vz+sgItjr3tyqNS9hdqSG/VG3GPo15mLr5m4niYcN2Qa643Mnl
	B9V8T+5+euFQL8A4NKRimCOw3sUUyzQUqWP+BQRGdV+nGkS7s8bIrUh3lcJnQWu0ti+CAVdjTcJWj
	nMnr9puQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uytzh-000000001BW-1m8q;
	Wed, 17 Sep 2025 11:22:53 -0400
Message-ID: <9dd63161c07c1c56522e3941ea59142fbd54c4ee.camel@surriel.com>
Subject: Re: [RFC PATCH 12/12] mm/cma: add CMA balance VM event counter
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Wed, 17 Sep 2025 11:22:46 -0400
In-Reply-To: <20250915195153.462039-13-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-13-fvdl@google.com>
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
X-Rspamd-Queue-Id: 3FBC44000E
X-Stat-Signature: rdx7s51k79fpd4y5ce4m4xt64w8ne9zn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758122589-197423
X-HE-Meta: U2FsdGVkX1/+Yl8xVG7Rdjk1eBKWq32m0RX987HFuFKiQSTnbj0QHBrURT4JOvcPjPWGAFUlKcRXEpn2OfBy6rv3nWA9yIXC+4NEMuHEGUTNJtDifracSAmaAOz5Opy30LKN3R7jKbOn6GTM3mwLrTFeIXLuUbH3xLHFcYzATOW8KaCCgaxBNeL6fuzRdPQRWRRRzlMMcrgc28PvgvOxMsscEqBlJag142bcmpWpKucZ7qlnK5RvxuK/NCxYmyilSApd5ID9KikQECPktyna0A6QzHG1FEfHGIQ8U6JaqA8noBE+wummUkhQMi2o1fXFxD7y2fxwKbqQYIblOLfBMf6FjfIJsZungTjtbGgzp534yRgk8LpnYpD12eXYxOBGrVJvGH7CzMKDgwn9YBViRMT05sPaz/MWNU8nX22g6Xyd/tbQsEyaV0B8qOvXN5V1cv6bDaTsFMJR2y1Ytvz4H1Pr3mLJbgdDaCnHxQwb2zO4/OmESuFme1FbQmnh08/ZlZ2FtACHblMZmTcXT3AZwZImRVQMSVluAIu0vQuddQzXHENzsaULlC4F/f+l1M+YWFmdnvrP1mWPl6W1JM7HvDRElUld8xEEEVCuDOjyQaSQuDLENigSvW0cVR61dgSXdx0yf7gDNpuQDn4gzBYEHNhQx7d7frgfg1cE+XylgtUlaVssu52bdpd+kgGR5To24ZLu3tSxJcpnKcdPzb5kOHh8XYcRQgpllL0Rv6ZGVhFB34qvjauwgPDO3E52R2locPUH65oSZcIr9oOnnABT4iTtDmKBpAGT7gp5JZAXnbl4ciK485viprx4NgTeMWN2f3KMW4jPz1XiX4ef8fzhj766rZazx9/irEaJ99cvKHIwBw5yyF/UjMOt/6an6UexzlYXqbfsY5vNX2jdhlsvJwOCby3n5svYlavoJkXFZ2acuf/OXdNZ5Mcc60iiY8j5GqpXujt5N2RpPGIbEEi
 M0Unwtsr
 /BscV02UXlaHdOkBR9gptIZlUnt3ZoGjtoT7hCjrcbCd5BNtaZ6YdsDoqYXyZQzozNJi+Is3Bb1Y32zBqBfniOGEClttHo9mJtAkHhb9FbSk6pVjd6n1VqSktzVLbaAPKPrSlVVXdaNzXPidF6o7opQj2Nm1yBY/HD3f1boLaIvVwKc9Ek6vqJ3nrfHQC8Cru0Lv6nAPDrGY5aN8NPeFWm/MzXIPosJlUZP0A6YRCswbE1AYJHcUSVFSNVnw0peNYd0ap11zOtFn0A/LQNWokrTrxYu/Rw6EvYOGYGoI4YCOxh6Er3QNiLWpGMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> Add VM counters that record the number of migration
> success / failures during CMA rebalancing. This is
> similar to other migrate counters.
>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

