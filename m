Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C52FC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 20:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA796B008A; Fri, 28 Aug 2026 16:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA29F6B008C; Fri, 28 Aug 2026 16:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDEA66B0096; Fri, 28 Aug 2026 16:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B54D86B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:01:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3571E120557
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:01:54 +0000 (UTC)
X-FDA: 85151748948.02.03F4169
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 68E4F1C0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:01:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="catOVL y";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787947312;
	b=0+KJMVNbZrObMPUurSdZGbbU0x3uqaRsDw9vvhvH4yn+hRizI/axnOe4CZf4TO68Lmc6Tu
	nwN9J7phXwWyewsp5EH0WS0POhFT1F5MotoPPz68AL8R/o6ZSiOc91cmYWfP5F0g9Q8IFx
	0i121h23Y6AHiGAwrlg5mh00eAlP4Sg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="catOVL y";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787947312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=razbEjG7v/vD2MHf2Nl4LqxEc42lTPrbwDbu0D1xjpk=;
	b=iV/gNd8wS/1UC6yckJlnVS5cqoElb/tD3yZCFqrbY9glMEibBnSWfF0N/TDLOliYI2l+sX
	4u/v9lWhgpd0b22/yj9RF1c1ElOFlcdhuvgoeY8WPjJKbb2dfazotp1UU1f66bPgRhk+rr
	/ZJ4nwWtbcm9qzSas8SBLF2Buz7awSU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=razbEjG7v/vD2MHf2Nl4LqxEc42lTPrbwDbu0D1xjpk=; b=catOVL
	ykWz8eTaecnMjoIwEXNOk8AP4KT3M27FLQ5wFnaret64xgZKxQzMo7F6s0QVhW+OBy9Lv9Zk0UYxa
	F8MFlVgaBXL9p4fpC+ihSTBCCDYoxDjeNG1tYhUKpPe1eXntG72pbpUaltBuL+d2gkWkg8hXR4ODR
	XgShWAy6W4TRJ/YXwRWK/ahuiy3x6Zo5giUIJ8n5l6Nine6RXNOOa4G7b69n0pMOHhyjCwW3cQFlg
	x5g1nG3+InZdwndZvImTdUJdAC8Zjjp1JxH8QF7Hq53+OBIT2U+qrnQhYxe+D2/CI+/TO3Trj5D55
	NtMMtkvMpGyM62Pl90qMoN/l4nQw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x02lg-00000009622-1Ell;
	Fri, 28 Aug 2026 20:01:40 +0000
Message-ID: <58177d60a0d6842aa40104d16021829468205d3b.camel@surriel.com>
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt
	 <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song	 <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, 	kernel-team@meta.com
Date: Fri, 28 Aug 2026 16:01:40 -0400
In-Reply-To: <20260828125509.83d2e242534c2209ca253504@linux-foundation.org>
References: <20260828135036.7d44361f@fangorn>
		<20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
		<apHgs2ZAxAdy8WIH@linux.dev>
	 <20260828125509.83d2e242534c2209ca253504@linux-foundation.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68E4F1C0004
X-Stat-Signature: 5wz4h561515r31h414cf4fipcy6takc3
X-Rspam-User: 
X-HE-Tag: 1787947312-507231
X-HE-Meta: U2FsdGVkX19+IvHAPiAqrWCkMMY2bG4IEwWL0bgKwGV03lsQmNFJytIQmo0Getz2KCfugsjqvYt9z4dbn6tDn+CLPF960tx8M8kxFTkHM76HcMXevI71AsYcBvUiB8/fm0RkGm8CSB+nOWZrihnKd60ke0avECjlOXhN0owH3tnf2v5fLJKQ0e7TlMdSiTsjCl7fC58w7XGbNcWr7Kt7NfHbNCV1Ymlo8KlfVK+9Xya5MJXggACQeBLsWWlMRp5KeBz8+FwQ5LDSURsEAo1hFrDdVME2kjOXQqmZDAg8BQDwvt2qh5gR4HixCnn8qqDUC2Pvgsun1WX8f4mw90Q9xfecND2oj7weXmeMuO/edTtyEizFxC2YaKLgTKN/lPiX8gmRca4oG95Rny2mBh1FM4U3Dxlf4INHaRMJGGDTpmkO67hGL6hAbDZpzLz2CFS7AuB5xc6T7hxogHaUOcV5LmalkAz3pjkFIj7a9WrBvz37m72gLaIt1hYFAoBQw4oyEJo8lDbd2t00LRlc4cEGY1Ya5dak0MGSq7ls8lxI1p5jlaYiQ6mypQ+QV21ZVV7ByWR5eQLdToXLBed11ls8uxTi/zv0jBR7dTt8dXDDjKSz+baW6VPD8yuY2v4DL9+XILMZtSM7VG1VShfW8HIl9jTwC/BpqNq+9DvlLO08BSt+JdSMtZV/GlYWiZwy82+SWilEplOZiKtcL6UGqJqQAdlxJDYJn/4foOAceZxzgq1xvp2jPLlQsqEg9OzEBnxRdGrLE4O+S5R6F4Pemhdo6aYvq1VWQNfyLViaUK6XusIQSUZPXvDdLbwTYcTIwm3tF+hBCWYJfP+v3qPI7rh5JF6s3UNwIUt44IgN7oNLS28oqiuXnTXf0Gk0cEQ8kbt+jsKkZ5tgC95iHxI/g18c39UInAsmEopsIa1VyLtmOouF4mUzpKiaaw6O5Sz/Ph8NTuPGZIcEn5UbbhCVjl7
 sqZ1hbUD
 nIl5yu/hMbBCfQIYSdo9/wnNAoVWCOfOkG23WDukIkhZC42jTxaMZN7ViihmtTeeAj1UUFnMYZ0rCgCcZz9eHMFus9ajGqFd8hQ04mnH0OoOwEN8ljSFF3iqOJDtBZk0t+Fghw0gWkM5PMO/h5ZPEB6JRJ0JviDBuv9CKVWcARQMOfjAGyEPjo7fBWu2dCMv18sZE2mdopwZBoNh37IOuF1OgcCm7mbqi5aqbTm/c5+0Oww/0qgVk8FFiELiPXC0XDD83tCgqm9JKFV8G2Y8W0rU7V1JIbmotIBU70CHVg/ZDjn+g7Pahp1iGBnS7plWOWofay3xRUy/prqrCLtFZi5CbTR6hI/PLY+/0t/96ZJJ0LbfLQ35xikNRiCuqfEQlKtuB++bhuo8gko0J8mEPMVQQdKGjqUyOgjAo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-28 at 12:55 -0700, Andrew Morton wrote:
>=20
> Cool.
>=20
> And... guess what?
> =09
> https://sashiko.dev/#/patchset/20260828192419.3057939-1-shakeel.butt@
> linux.dev

That one should be fixed by this patch you merged earlier:

mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-
cpus.patch

--=20
All Rights Reversed.

