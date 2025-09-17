Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422FCCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696078E0035; Wed, 17 Sep 2025 11:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645AB8E0003; Wed, 17 Sep 2025 11:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534FE8E0035; Wed, 17 Sep 2025 11:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3E18E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:18:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0A23BA2D9
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:18:25 +0000 (UTC)
X-FDA: 83899098570.24.0126373
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6210120008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:18:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=K1wQ1gNx;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTm6Kno/A/RV/QvjQ0c4Y28+JRucs4g2C/pMQmU1ytA=;
	b=cAC9dJAhEnYb6jdnbUbfyEKwSHEDs9hQLb+CYmFbaSAYWSj9XdoLP5lOsr5ujry6sAI2zE
	Fu7vWFDlhHosfVzWSUjBluT+T6X29qlwIiVcpvi1FrJv5zmOXnsoh0vSRrrNUi2NS1aSJy
	urf8uzQKlpHJO8oE868uwvZ6EYLsPY4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=K1wQ1gNx;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758122304; a=rsa-sha256;
	cv=none;
	b=JHmGVv8czRF7FARVdLSbI7TI+0zR8b5RqyXQI4sz6/SIzIsOKqSO5jjq8BOJlnBK80Yjaf
	4j0E+ncB/OfzTlH9yhxCoxdH/dMD7kgYVncoptRgGL56lxYhU+sftgcsc8p7ex6ulS1iPM
	klkQB5WVibLRHW1ib6lJ+RdNwwrjl0o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oTm6Kno/A/RV/QvjQ0c4Y28+JRucs4g2C/pMQmU1ytA=; b=K1wQ1gNxlechhgJrAfzTg8HUHN
	r1nlHrjACWGE4H3a98mR1Uh2qXL0DP8/qzebriJgOrJFR1MkOIL5hOAJLMzy1VwdccGVaJCjf5jUE
	9QkwnMeDyyrIGCTSAFNBN0j8y57ijrbjfPQXKsePh3rkQnlPa82Q3LUuY13Uirh4MqV3FjCqwiccG
	Sbedlel5FqmnhKbTdXQgVXKbB+hTPSQ1sJUJ/ENUOzEnoN0y4/jxScrSc79lhqajn6tc/n3shI1ne
	4nxP6YsroVhaJuVuVkwd9sFAnS+x1+yWUg4Z/kSI9aofmaBr0mMXCPSApad5rpYAcv0qq1caBayEQ
	cIpzzwew==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uytuc-0000000014L-2ZhN;
	Wed, 17 Sep 2025 11:17:38 -0400
Message-ID: <3d5fc5eb4ec225b693c59fb1b888c5161794f869.camel@surriel.com>
Subject: Re: [RFC PATCH 09/12] mm/cma: introduce CMA balancing
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Wed, 17 Sep 2025 11:17:38 -0400
In-Reply-To: <20250915195153.462039-10-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-10-fvdl@google.com>
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
X-Rspamd-Queue-Id: 6210120008
X-Rspamd-Server: rspam05
X-Stat-Signature: i166aud53ib66szaq8oxig1rhwh1ugch
X-Rspam-User: 
X-HE-Tag: 1758122304-159674
X-HE-Meta: U2FsdGVkX1/JYQC62Vzd+hYyNYyl3pJMKIKonEF9vjQdSWjq9CCsqkK/p5g3YTxaX6Z7ytg/mPEII+ywSe2xKZYAS63CTxxQtv2wSVIdzsxCLu/GAbY6CGZPBY+u6Qii3/jML2zNAYzNTQo9tgW7Kl2az6jbKVbuo9sN/d05kf+1aPmAb7Mx+TRQQuOa8+5aZAuB3dmPwxd6PW7O0awCasXIWpOsNn9tQTgL8d9AAr/7uNwH1KVx71hoO1wo1hrX4E8Ft6K5cQEePNk6ZjZMqG4sBJvCYEgpsDwRILsXYNa93lQ8xhh5OK35rVm2nidh43TNsX8/9kCy7vmxzBsBgl+OzufpHGzw/UynLoWQOr2ki8+agrvanObrMKq+zdp1AJg52XvdcAcjYtMC3Wf4kQWuXKOimGOKWRGMqSYiNbpQO1eBV+/YxVMr3I3MdnYN6umjAlH9kmLZF6tQmhrrzSM+g2KVyZjquoYtD7aonv9gDuP584vphfk2+Zg27+nAYsNO6PTXgkuyHUcz3vV//GlEDPMZEUx1GMI5DqqOhXr1viplR95QqhRIN/RJZFl/hoHuU2rquVWfTGJ1ZhKrVSwCMBz2VvBVGm84ewRhu6A8215UDCd+qVeJdO88Smtja155NV9RSV4vb8gAqlOZeCDWoDzRWeVcvZV56lhdlEjEUFBY2h1HWqG+QzCYnLyh20zWvrx2eJgif4f4or6L0YlelApHC6JYejps2XQX+cFw75jRH4gQPGn/wfDtWgGbFJ6xRWRH88rQgAYOPK0JqbVBibOW93xd3g5oOG9apFva8nA2tw/vnxpXzFmVnFwjf54j5YeNthqIApuIpjBLrMtMvwXQiRs1VHyRzk0mh94EzvrrFIVOS6BHn4fNE959Rc3577AHF5P3EW+gLDcoEssZD795gPReN8c6mi/Ki7wMn59kb18WyzAeS+7enUxKth3fp0PrpKyOic/r1li
 o3O+/2bs
 T6VxIaC53wefdn/vuch9gxYNZ1/Dqq59UG3oCeWQR75cWjHqL4f8szx1j2wCU83eeh5FbNxH7L4TCUnCyq3HM8JVjn6c8tShJLXYipXj2sAOEOLNSYv4o7FASu7UnKQomGw4pesAMdvnnqqMyuveRiyQRjKwQMh/6JJF4NTZ27l52IWzgRSFbwHllVJ9tqV8fBElqbSEXvdxPpzYncPc5enNvUsZAFAOmtty+z6b2yPmUj7OlFMW1e7rHvYlpQZ4DmQQI7uMfooo8G9FReGziIAG4LTxPpWPSAxxdO2mTOtLKIfMKHqUUaM2DAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> A longstanding problem with having a lot of CMA pageblocks in
> the system (through hugetlb_cma), is that this limits the amount
> of memory that the kernel can use for its allocations. Kernel
> allocations are unmovable and can not come from CMA pageblocks.
>=20
> This can lead to situations where kernel allocations cause OOMs,
> when in fact there might still enough memory available.=20

We are seeing this situation happen even when the
CMA region is relatively small.

When a system has multiple cgroups, and has been
reclaiming the non-CMA memory for a particular cgroup
for long enough, at some point essentially all the
remaining reclaimable memory for that cgroup can be
in CMA, and you get early OOM kills.
>=20

> To counter this issue, introduce interfaces to explicitly
> move pages in to CMA areas. The number of pages moved
> depends on cma_first_limit. It will use that percentage to
> calculate the target number of pages that should be moved.
>=20
I've been working on some code for this situation
as well, but your code seems to handle a lot more
corner cases than the small hack I was working on.

I hope this issue can be fixed upstream soon-ish :)

> A later commit will call one of these interfaces to move pages
> to CMA if needed, after CMA-allocated hugetlb pages have been
> freed.

Is that the right place?

The CMA region will also be used by regular 4kB
pages and 2MB THPs, and we may also need to do
CMA balancing if the cgroup is up against its memory
limit, needs to do a kernel allocation, but its
remaining freeable memory is in movable allocations
in the CMA region.

I have the hook for migrating pages to CMA on the
page reclaim side, when the reclaim code notices
that it is doing direct reclaim on behalf of a
non-movable (kernel) allocation, but it has been
reclaiming a bunch of CMA pages.

Hugetlb is not the only case triggering this issue.

>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>
>=20

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

