Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D46EFB7E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ACA46B0088; Mon, 23 Feb 2026 21:38:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A6F6B0089; Mon, 23 Feb 2026 21:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132CC6B008A; Mon, 23 Feb 2026 21:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0185A6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:38:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D8CE1C3B1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:38:06 +0000 (UTC)
X-FDA: 84477790572.03.3430A5A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id C199B2000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:38:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=N0fPBP0Z;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771900684; a=rsa-sha256;
	cv=none;
	b=5ubfp4nEHvdVYWsW1bE95w1PHQKdWg5OTVhktaeVF/ykdCunSbrkFAw7guA7Qc9BXC38SA
	MxFBuCNG1Yhhusl7mnHLNixKkIBk/bf8GOnccTK/ihl0JXyKGrScP4O1LqUvjDSB4Ji7+D
	tJyrsv/q/aOKMl0ntIeyv7WvBHfPtJ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=N0fPBP0Z;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771900684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G24I7Ff/etxg0a2wqzeI/LH7DTsK+u1io5dvhJpjM+c=;
	b=6CDC1aia+wR8q8ojrQgMoy68GuQ4QMUox+RyranyUDFD1qjsLCFEiLh6ylmm6SOJIU1usm
	SvDBsK2s5ogfxfDWbSer3VDj8d+HE3540yABclNS5qbedTGVGQTy3Zz7M+ck6GyVrt3k2Q
	l9VtQ1WNnu7iRZLrsi66/CaD99a69ck=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G24I7Ff/etxg0a2wqzeI/LH7DTsK+u1io5dvhJpjM+c=; b=N0fPBP0ZX3nff+uESHr5dr836B
	DFRdCMf3GvEX6pucye5mFXvdon/1RMquIa2SWyCAt0OtILzFqh4mEeh7zI8UA7ryKKGO4+iMj9ecA
	4od6s2TJAoWRl98Eoo42SaRd0JZ12d/CtajA0lU5UMRMyBH8zTiuHfInBt60A9z/kHOSge9KZgVCG
	1D3NSnr8x0I4U1n/A4lXRDShJrK7H4PI6xiFd2SQSHxs3OzNLyHC4MVR8cxNc72jq6aCNTobtHBJO
	uFa9pu7zX6chMGPqbq6ckUfYkygRP75MlToC6N1m7Jdatdi6apM4AOTzmNGS2u+45GJ77yZfhShiA
	vwEVG3Og==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vuiHl-000000000cE-3D2J;
	Mon, 23 Feb 2026 21:36:30 -0500
Message-ID: <01f4ffab0da9e4326a78f8b6eedce23dfb115e7a.camel@surriel.com>
Subject: Re: [PATCH 1/5] mm: use inline helper functions instead of ugly
 macros
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
Date: Mon, 23 Feb 2026 21:36:30 -0500
In-Reply-To: <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
	 <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
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
X-Stat-Signature: 7qgp81wtue55ppuern8pgfewdszj8c5o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C199B2000C
X-HE-Tag: 1771900683-41265
X-HE-Meta: U2FsdGVkX19sa/161bd6muk41oyNSXA9XfbdazBnODOjZB9pRHF3dh70/a8c1r7ovPDHmNUEF19HLq381YhbMhAtBAwODuN3pLPoc8dv43m8/UHbcM/9UDbV4UFP48ZzB3wsRXLspuY2dTxnN5DYtVGmxl9dGk8Ec12ZEe0HqyRzaskrYQQe7sLXsnc0Q/uJmRWZacJ6tUpeBQECedtz/218UutpqsLYRJenlN20gRJY3P3AnYd4N1lpWv2jXW6LSqzAFXa+JLdjiHFsidyxq8sZRlsJVjh59T08wtnlbRa50ce8L1OFr3MtdP7M8U/ViIs0Ye79qof4NI6+o07efD3mPJPvOo4EpSQVnbca7DYsY+j9MsLMB7gHF0zBVZhOWkWIhLWpxQzsCSAV4XYMq3e8J2F4OHYIjhw1cH2obrwnvyRCnZbqvIPZT7px/e1Ai+38FsCv8gR3eKyNVUU0whjQcmXpE/Y12GeJS8qeoInu0kyPJ7TqVhS2+3EbK4vltv4zt4hYhv06ofNzIY49dDfFCG3EYNWAWxc6lOsCYupIklp+3JSDbQpR0XYXxFzZyWIeU5BWSxH3HjugD2bferL2rmojxeEPbKWCfyHMlSrq/NrqYcnvRQzEe7zx5m70V/0/MC9xb5EXDbr3nHOO5pnSYqduVh3syxlsQ9PUqhAFvFhRMThQ61SHHbZpBXibqoVkIlpj+p/CK/ZMyfajgdBMGshIIkB1HaFCJM1pFpOgNsJjJ0zqtqdXHVU71WChZeUD4mpN93LMBLf4a2wenfkzq6XcWpsr/uzLDLbrZsxrTeO3kRDKn+/qmWbz28FTV/+/cKv+N+cAu8l/dTEMisqgKNW6vasjmPNbvOwqPb2344qyhutyrPoIFevJMGjojM+VJQe/AptuR7+rusq5/u+HLQ06FQIklQVvfrNCo98Ag1JdKouSBNuiKFcl35Ys1rC9bC/HZGzpYCyHc+b
 IZ23s/Uq
 LsSUnkLibvZ0ABjohXNpZV6EahjaUCd0Wb6Hb50SEP4CX5KEAv6rLT9i9iwppYGQuZiTOH8BNTX9P35Y0Gy16MMENfig5RHd2Fugikxw47m/uVQS+DhgIYtFzi9gV2YqteGmnWLhEEm033gHuOK0llopuwOlTKqpyVNlhVjtYWZLkbsjeV+fuRiOSz0wqB1/eLq2l/UyXdSCL2fo5w1R7XSlTR8MTNZa+gxEzYcjmsdcK/LTSDnLCVKtJu7mx8oGA4foCDQYw1wsWQJtrv1Q4aqXUNN7O/2aljCYntaXXaRbJf+POm5HuhxZsVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
> People have already complained that these *_clear_young_notify()
> related
> macros are very ugly, so let's use inline helpers to make them more
> readable.
>=20
> In addition, I cannot implement these inline helper functions in the
> mmu_notifier.h file, because some arch-specific files will include
> the
> mmu_notifier.h, which introduces header compilation dependencies and
> causes
> build errors (e.g., arch/arm64/include/asm/tlbflush.h). Moreover,
> since
> these functions are only used in the mm, implementing these inline
> helpers
> in the mm/internal.h header seems reasonable.
>=20
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

