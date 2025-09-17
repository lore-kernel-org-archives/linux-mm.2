Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1329CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2EC98E0037; Wed, 17 Sep 2025 11:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8C58E0003; Wed, 17 Sep 2025 11:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8218E0037; Wed, 17 Sep 2025 11:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7C848E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:21:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 535CFBA00C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:21:41 +0000 (UTC)
X-FDA: 83899106802.23.3ED21B1
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id A4D57100011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:21:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kRZ08od4;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Jn9cqENQBz9wlb9m8v/hRdjL6PD83V+XLEj/Z5ytdY=;
	b=1bedUAc2wxy9lEqzuiGdPiviu+Ur12EeL0sl+w4AhD1Clyy8yxU10MFmZuH+r8O9KSzRql
	o/S8CsF/YEFWph88YCsqjqR6WxcUOQA82U38CwtSVY2vsNWTqcn+2FqDrSA1OwV7cdbuNE
	dH3liSqaiZswUyexlLDE5UylhMMBZO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758122499; a=rsa-sha256;
	cv=none;
	b=V7GNyiZalqj2fq4fugnvx97Khn10OYEeY0auMuspWSfUBJbKXrlhcY+HvcW98uagXYGf+L
	XBdA94wR9Sko6iWOfdHAnYBFGtiN9HNhoVtTBFGDJLYatNnmTaKpl8j9qhHx903XAMJzRy
	gQdxG6Nou4OMwnLkQ3ejKsXQYdGY0oU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kRZ08od4;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8Jn9cqENQBz9wlb9m8v/hRdjL6PD83V+XLEj/Z5ytdY=; b=kRZ08od4q1oLOhIe8ryYYwIdOS
	g72yHRZ3s7C6A+kCwqLOIFMau75U1LaWb3wfHbDVls/U1lTvdcqv0fP4Y6dBRggDbuQqjcHjunu4f
	icmLP9aKT1mfIHeizMPGgnu72UxKg6srn7YW6JUOwrS1+VyuE1JAoXG7rzM8pm4O6X51Rwn2q+y3Z
	GZHoPE0GUeY014XVxqrSxQtW3i+wRA2N27wtvFVCa07PikFS4NNFR5O8Sx2Uqh3j/RtyC4NJV3EuG
	P8VOLyUDyEFB99/WM+d1CICsWCvuccQUZ2wLwJhl+U5NeTy5Eibhq/hZV0sWhweLERBc2iiErDigL
	4+p+wgYg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uytyO-000000001A9-2dO5;
	Wed, 17 Sep 2025 11:21:32 -0400
Message-ID: <6c10723cb3da89dad12eb8f8f44ec335bb2680c8.camel@surriel.com>
Subject: Re: [RFC PATCH 10/12] mm/hugetlb: do explicit CMA balancing
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Wed, 17 Sep 2025 11:21:32 -0400
In-Reply-To: <20250915195153.462039-11-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-11-fvdl@google.com>
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
X-Rspamd-Queue-Id: A4D57100011
X-Stat-Signature: b9hw3ko4cbmi954f3jg8jtf8uz4ai5es
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758122499-983718
X-HE-Meta: U2FsdGVkX18qLH5cas6HxrQY6gCtqqLTp8WvPjaJ1usi/52AB8LZ7wN4maHdCRPzfM8ZOapAx1dJb95ONrJi+M41i2KVLF43VTaOLNsXROb1WQcmQXM6gwI/TdKrBYgpQa1oAdZnA8OY9/vEzzYrRM7gIt10wfilY+Ajg0i9qENeqfDpMbmLX+mhuNJwCr/V7xxFvkzCzSnkx9NQTByfZAyPkMkAT4Ba762GgdRlbXd1LjB39BS8LJTT7vpCYPz4SNylTbJx2GXWbhVRfYxBCHMfNYW/SLGBKOS04qPY9/XiurecMulCIYMJP0LELs2p30tz4/mKm8Dz1lrTKFHBfdtiWBDaM2vD7kKq14ftrGyPgaBivIpqeKmfaHkExp/Pt0t7EHB5T4C1vS8MsBzHLD4OxvM7rS7zbknLBwdEBVPWw6x+ZLUrFBT2CCPWgUHJGjjksY0CCAcgIeJKk5/QC/NkREd5pmURxACmDZ9wVQJy2UYUtrNHB7jKoZ2utYNvQA9EampitGPLaXHiUKRecGMXw7PybN3l4a4vHJPz8wiYh8O19Y3BJ7zzfp9rYz0mfYZyeKnnsfauIWBshnvHZSdzwiwzS/OEmDddkxIaT9NG6a1rfs52ZWkxrlAQa0/U5e5Z0qJppWQXOSt0RXEVve5lRJhnfsYxYCtfDLsHxDJ5gslPzuKs7C9MYQJUPLOSIK6K4nxcpgHzxB5/ft2N+SMPXYxdIvcHciypfC6RaPEnrrFpw+el56EyUUDlUSqasIhR13F/qgwMiO47ZmmD/maxNAeZ3NNS8RB9VBFt7lFLULQXPR5hOHwmVQ5vPXn5yGHsiFrH4rsyyRxEdai9qZnT+T+I/5pOJrtehabRehmR/a6cqMEvSmlmXSYU/yZOn6ZZUk7KPGbvYaSGdebONK+YL/LDNYa+slHnFL8UQTPZ11KVPx1lPlQuCfrDiAwZ8CmxZAv/MGVUE3uB49r
 RPDO0AIc
 1f05JpqD5tFW9nzJHqy37QAjsfhGh7VIsfPmhtpm9JqRCph0KnikB86LO+SoRU2fdlYFEVeAsVoPqR+Oa7TO+jpkiiOPtI6t+/vOu5vhPd1X6JMTGYRbCxwfonmhB2Y/jgRcBuZ29uKBXNpBfq8pShDL3988kf8KUvcIyBvRwTKbT3lu6/gj4NyPECFfGNEIpI1wE6kWWlwBEjLsh4dFuOkTpEJc5qaYDWPK4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> CMA areas are normally not very large, but HugeTLB CMA is an
> exception. hugetlb_cma, used for 'gigantic' pages (usually
> 1G), can take up many gigabytes of memory.
>=20
> As such, it is potentially the largest source of 'false OOM'
> conditions,

The false OOM kills also seem to happen when a system
does not use hugetlbfs at all, but a cgroup simply has
most/all of its reclaimable memory in a CMA region,
and then tries to do a kernel allocation.

Would it make sense to call hugetlb_cma_balance() from
the pageout code instead, when the pageout code is
trying to free non-CMA memory, but ended up freeing
mostly/only CMA memory?

--=20
All Rights Reversed.

