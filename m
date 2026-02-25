Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E6EFF55434
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 00:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801C26B0089; Tue, 24 Feb 2026 19:24:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABA46B008A; Tue, 24 Feb 2026 19:24:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E62D6B008C; Tue, 24 Feb 2026 19:24:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3766B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:24:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 128F21C37D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:24:58 +0000 (UTC)
X-FDA: 84481083876.04.EDF27F6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60E9880003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:24:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S2ZwHguM;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771979096; a=rsa-sha256;
	cv=none;
	b=JH4WAidwo0SGsQKcOCPSLJd2NzZJWa80sqmN0Ma5LEdoOIsD7Gs2lyFmUNtpbIBq+rIVw9
	JbF04ylPVTLgk2F4jGa55C8QtQ2uKtf4dXoRPjMMhtJB3z1Qp5SD+dQtINzR5BbZI/J43G
	Q6PvfwWcPlT3rHRtg2SWmp9i6xdb57k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S2ZwHguM;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771979096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PRdpHcAqnlEUxMCuCnxi7GEr8v1m/WI58JkwH1AonY=;
	b=uyNhnBb5KqxsCLYEKGYU/IhULgf7UiFKVUVUkro7POnEqec7O9ptzFMDbmpECbNu1hkj4M
	asT1BmBqiyrquPADEbxQx2/qPT/HPsbE4kjHzhMUafoJvUTzpJ+G1W5dzuzZvyfoa4j3Ny
	KeF+hWp/WsVkDOdhg9/LPugwJkBW57w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3PRdpHcAqnlEUxMCuCnxi7GEr8v1m/WI58JkwH1AonY=; b=S2ZwHguMvVW6apjzW2unhuN4IC
	EYHQRVmMic8UQL/vGVwFVy8D+uuJArWSEi+w8bOo1+JF9cMy8QhWzCMgPlvdgKd7t0xrOkg4CDYNw
	gwJcPN+g2IIAUBs3vUPchpId9Q5fC4bIfqX5HfZ+kxPx1JNUAQibJzdG0I2NufC+KHnQZ3ZG01rwm
	q4IzCeCft/qj1coc7JWdA/8/s6n7LCAoO7Jz4VqOB7P23RTGhqWnXgcXOJ791x9X7TF0Sxn8tSwqj
	HxCo2MSjxw8ulqIUfF/U1CJ32L/AFRhygqbfDvrSLESWAH/9smWq7oSuy8Bp4TCx6HE/xEug6rDnA
	6dWDSfRw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vv2gr-000000004Ti-3V1E;
	Tue, 24 Feb 2026 19:23:46 -0500
Message-ID: <ff81e4bbb7b9febcbc10ed133a50e62caab4d099.camel@surriel.com>
Subject: Re: [PATCH 5/5] arm64: mm: implement the architecture-specific
 test_and_clear_young_ptes()
From: Rik van Riel <riel@surriel.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com, 
	ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, 	surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com,
 jannh@google.com, 	willy@infradead.org, baohua@kernel.org,
 dev.jain@arm.com, axelrasmussen@google.com, 	yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, 	zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2026 19:23:46 -0500
In-Reply-To: <5933ff4d7124cf972bb2474666b4699580fbc334.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
	 <5933ff4d7124cf972bb2474666b4699580fbc334.1771897150.git.baolin.wang@linux.alibaba.com>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 60E9880003
X-Stat-Signature: ybnjo6r48bzpc4joxwxppoy5gr96dqar
X-HE-Tag: 1771979096-662477
X-HE-Meta: U2FsdGVkX18FOeWVaEIj+yk5kMNDrmu7cswxysHQqJBiiCTncMGoILjuyL7hyAF23VBMODRuMOZ8h+NrAhmQFMN+NanxXbHFiwWK4GmyGQVBeQdB/xSVUcLUbPAY7NTbq0LOPTEs3MNvyHyqEC3M9zV1GRAFHv8sp2Mfu8JNKId3AXUZfhbcQuXgPOZv+IfiF96Uw3bR184beCAAcz/q3azzvmXL5GUI7T2iIqepeOmV2I6et9zKXJguDvt8pRt2DYuukYtbl1zx1jB6J4/g0k8jrys2JvLoj3smroRVFZ3FZeSiuverBgLnJlqqrvSo3WORSdLrSmrU95tfqPwmeMH++yVFuEDGAqByMs4MB9IshcPoskrmHo2XBfCOqud8s+d2coWluol5L6bxwDZciuDiUy47giYKIIg27/ft1hF1kaXAAeUjAa4C+u7PQjfHkJrQtEvEPvqagWI2/Cf7yYiF58fpIzVkIN6Z0mDgfd0/XLwkj+dqAQwi3eWXeOe2dKBKNNscLgNO0JtMZYiVi8Mqfpy+YbK4T5xSr4k9rJYj3EPYyxGhBgYVllVxwO0KVrYBVeWXI/2eKdmS5JJM+yJxXwa2w7P6jyEsX9nZT8lVqmGaBRARCPgkiyiNDUzqJzKkdTpYB8xu+GJMp1pTbPaekzdtLlY2qO5Tqggnm6hZUou0HjRx6zy6Xsp0MJWrkT6Slxxke+0078cR3qz9c28RdSmveBoRPejCInk9tfRw4xLg4tcBrgyG5x0NSAPW/PO+yDVVPS4L7z8NJAHstVCwxMo6D90GhnjxjKzzuOqo6GfwB6pu6ifkLVYIl6tfilO2Q8AVjf+BkYJ+Ud2iIKSY/ze57mfbR6ZXWFMfgbABS6xazO2/WE+6XJ76ZGywNMjoAj/aLwQgTFOhagYS+XpKw4JoOs9+tIkpid/fPN8CSkkZpxd3QIiXpOfiFgHPoo2viuexHU44DpS/8vC
 lKonM5O+
 vVrM/HGxgUxUm8KjX9zZtAtflNGZ74r2etBF8TOLjfx6zwRwCHI02a3kJ75lKNmdDTuh/mvkNQ+H2ehLkuyX8u57+pCBnNbcHk0hq3xLCKzXa+5lowW1i9PACOa/O0TPuQ37dA8+/JM6cPgI6osOGSsJPKde8v525moeGlE86Vq3MbH3zENeOjuVKgdgVKCouA0hfP7+ML6h9iaQDbDAmf3CEQ7r0dN7gMlMNgpZi6P9ruCot8Zolyd1dM4ffwyxgvPrSUjGypJUPu1ox7hsHRPwHR8HkxbxxFV4MqYY/ybQeqeAOoGEF3tJnlrkIqSam1ldYZ9uJUyJHV9kVq4SpbIWkncStctMH2fPhiwRjRtXiLUQssxnbJnHPQgv79E5EeXMi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
> Implement the Arm64 architecture-specific test_and_clear_young_ptes()
> to enable
> batched checking of young flags, improving performance during large
> folio
> reclamation when MGLRU is enabled.
>=20

> W/o patchset:
> real	0m0.470s
> user	0m0.000s
> sys	0m0.470s
>=20
> W/ patchset:
> real	0m0.180s
> user	0m0.001s
> sys	0m0.179s
>=20
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>=20

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

