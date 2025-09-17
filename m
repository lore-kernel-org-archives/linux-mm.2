Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103A1CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B6E8E0034; Wed, 17 Sep 2025 11:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC188E0003; Wed, 17 Sep 2025 11:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A668E0034; Wed, 17 Sep 2025 11:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 415588E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:04:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6D4459CB4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:04:51 +0000 (UTC)
X-FDA: 83899064382.12.E2E48AE
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A29C20023
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:04:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LVryhove;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758121490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWbZ90YVdSq+kjIWiBXEOTftCuga90gFz5KTLyY/92U=;
	b=Iz+dcVSQUfEhMk2tchD48vOmWXlWih7POcJ+2Ac9RFBt4/InZXTLFjttFF8gYMf3SIMS7c
	Ab+mKK020qFiqCggAyTvL5WoxVP5h3944/hCkbgzJq2ubwY0jJkTU9W9Xi2FHKLSRt7egf
	BYOUz9vV7qKt1MHLaYy/wsMQra7TYio=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LVryhove;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758121490; a=rsa-sha256;
	cv=none;
	b=yoD5dDN3Kb0GhWExlsl/tRJXITodDRiOqlMJtw+7/v94Ktu6JFDz19GCu57gdEYWJIL8Rg
	ZcKgkgtP/eYuQ98padeTF7QclPFunOmTIzIzu/6UfQ9ZvaJp5ITv1ZRwlDeAY3Yob1WJkZ
	hctY9nmX3TStY0Vnz2pgL1N34FbJ2qs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pWbZ90YVdSq+kjIWiBXEOTftCuga90gFz5KTLyY/92U=; b=LVryhover5uV0i4gPFExEMmwFi
	DES5Ni1EAyqyPJHKet7Pgo1w0XIAuB3tPqeqBjc89Wt84YT1y6fVAWqiZPTe2ugaxDGqy4+2aarlm
	p3MKlHn4wyeEs2ENLyov5OcwsvGliCyk0rth74abRGWl8buMcmcpJcyM9eByzY6PWADqIhQXMpVyJ
	cslZOitpmJbQQmWuQuDT4Jl/SdqoxLbibpjUE1SJj/56Oa5VO2P0N2kHnUEbD1Td+oqqF6Pt/8bDI
	n0VkRMloYGbNKrv+bP/TwwapFK+RviOlDrIg/DjRpi+SXsG7J48my0Hu1BDY6kqrii2D3un08GnCv
	p2Nk5j+Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uytNy-000000004Wg-07gX;
	Wed, 17 Sep 2025 10:43:54 -0400
Message-ID: <43786209742be00c5bc2e4ba665b696379be8dc2.camel@surriel.com>
Subject: Re: [RFC PATCH 08/12] mm/compaction: simplify isolation order
 checks a bit
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Wed, 17 Sep 2025 10:43:53 -0400
In-Reply-To: <20250915195153.462039-9-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-9-fvdl@google.com>
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
X-Rspamd-Queue-Id: 2A29C20023
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ztostxzjzcy4k1ynjmbqmbx4ys3k4k9b
X-HE-Tag: 1758121488-180910
X-HE-Meta: U2FsdGVkX18cpkbqFD/Srz+de9nZJTvHAtdIV/4tz/xeDevWrrNdvdUlw30MVbCNa8fAZOZZIeHTGSDclAtgAd6KcIKYoBUI9+dIxCby9Y7LbEXrcuYT2cgrpuP5mmeDJHG9oqlvZ+HYPuFr8+x+kRRo8hwkdOXTcVUtxoNnOsiJ5Vl8+cINhjc+DTzzf6QXNKm2ddX2gAPqLG27bnoPFMatFT2tqxG6p5z8vxOzuIgpsfJz/VJ+zVkLpJ8shpBgTpr9PHFjMomFcbDKFSRS1ixVV18J1BBJaeB7rC30Bj6WbFLIMRzM/hfPKJeZlmIpSF5+TOOVH6XrQnDeOPoGshJ1M15drr3ST+uKGr9TZ04G5hBvz2dUqJhDIpNuhZPgLvXuZmCRjty7rt5SudafGZSKyMj0kFOJxtwcFQciGYqv/AgSPJIgted3Z8a1KZ9I0lcFjj/P/yebUJ7vr9SRI6NRIoDFz6p0mRSdknEekZq5+oWvrpjtQigA6+CGKS3IYv2B3dVhZNBSplrZ9CQqi6blWbJEIaDbnRhgsRPKwh/Noz53xcXIJSCJEvVE/gNIQx2iqDBzWHAcToimZ5aBkb04Vu0iajOI5Rhzpvo/WWqHjBZBJnH5wgliYaBVEE4PMOsP0YPbnXOwGkvVP1g8uMDBs57G8bd/UUWMkIqmv/15/5n2ZLFg9et19WBbDOJi9omFjnsD0tvkLQdE1Y2pDSLYQ+UTO7emuKbDO/OP+7agqRRP5YhpxT2eAqQBx7KCNlJV/vYJz6es6Kpx5Mhs11T7nIomhhLENJ4IpgllDa4PMVLhq6DFrWEGf4XgFSFm4m7WvohjZOyS6O0GmZM298O1RQqg5ClIcSNfFK40G1fYO7cwFz6O5m2Fxt7Uiqo601Tk8bNXJQ8sK2s8OKdS7abBuzOYXpRsJu2RTan+jna8oPXEF6PxDXMh/MC98L7cM+cB1/XzXIl0g65ukJn
 JTFAfsE+
 jgzm/+7I0RZl0cV21DmcGlaETtjSMNJ0e6AekCtsFwEXCrXNBDaoccrEuU6V6I/0uIUmEtwoIw4jsP2hWajuHBDLwqfyFYZWy/y+B30HWDjBbT40sKBVOIgSDT2Y0UErlL9VhuDtHSa/fB286Z/X7QjeIFbJwXeBcY4wepYORccHT80dkKqkfGILf/K8p74uVIZjMPnRCrKG3aNAO7smM0vUHb/9MmwG9DQwmKa/hLa8n5OCtdQx3uu7uDs7JHoagYmxeO52TAGB8ohzlQq4pHn6bZqds4mbd2NrEbfHdVtT8TvlcaqUAGdBP1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> The code to isolate pages for migration always checked both
> cc->alloc_contig and skip_isolation_on_order to determine
> whether a page could be isolated for migration.
>=20
> Simplify this a little bit by moving the cc->alloc_contig
> check in to skip_isolation_on_order. Also rename alloc_contig
> to migrate_large, since there will be an additional user
> (CMA balancing) of this field soon, not just alloc_contig_range.
>=20
> No functional change.
>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>
>=20

Acked-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

