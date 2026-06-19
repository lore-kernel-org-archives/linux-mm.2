Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D2DCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4276B0088; Fri, 19 Jun 2026 09:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABD36B008A; Fri, 19 Jun 2026 09:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1306B008C; Fri, 19 Jun 2026 09:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1306B6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:47:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88ED4A0477
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:47:24 +0000 (UTC)
X-FDA: 84896789208.11.7C9A371
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 21CC0180006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:47:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=De4WtBE6;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781876842;
	b=tcDUKg/fIi5EAQBwEjyHk24cmbjCJ3xWNL4mdJx5neX5vBBJmUZvoUpYzZpB/vWA9Ua8pa
	Oy3Zc7eYfNPV6qf/WdpqCXst0o8ZLh42ifr7t5oQ1ZQR8c0R4eoctLQ5y9zhxaEbPdV5vn
	l+hiJUkQNHKcm+4STJbEa5qPVMOE6r4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=De4WtBE6;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781876842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1qLucesoWgHaIP4TOC2pf/IxP0E/HXh12PHFI5S4nU=;
	b=bgJzMLR0kjycnmWHAES4uPNClA7VvqeMML1b1ATVD0Y0/M/D9CnqASln0j0R9iitzKTEiN
	64iyhe0tSFBdj0zMy4+f0344FGq42B9Fsk6IeBoHdsbfoZ1iQreonL6v3mpnrLJwRK3daL
	67Ncxdfa4ometkKhe3t8rjvJddfkdRg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=t1qLucesoWgHaIP4TOC2pf/IxP0E/HXh12PHFI5S4nU=; b=De4WtBE6abFyYMdRz055gKojLz
	8Ok2LfR4UllT7qABFjxdob8lG3yLVKffOkZ2+UByMfrHYJrBWqobdfi67j3gwNmsxRYVcVdOY/Sxk
	yRvPdb+Alp45Tc2fP6PBurpQjb4B/Twqm5L1G8lN0RmvMvT1Ny8PC3vCU73O1BIM+HLZO7MQoqzeY
	oSFXWu4xAwJxklcuml7zLH+tAP5ZQpBMGkN7D98PzdaQI9d/cZg9E+EriksyzT9R5vOguNRGk0fZe
	z7/GOnNloMwIc3DBva5yCb3ZxVfcr47jfs1ghY1nSEnBPkvHj1XPz8lwzX55NHuDofDSY0zhTNMET
	4mQYmtSA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1waZYh-000000006uA-1em7;
	Fri, 19 Jun 2026 09:46:59 -0400
Message-ID: <af82cd43ef0c5bd4a5337942650fba3b8bccd94b.camel@surriel.com>
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where
 possible
From: Rik van Riel <riel@surriel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin
 <d@ilvokhin.com>,  Borislav Petkov	 <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andrew Morton	 <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>
Date: Fri, 19 Jun 2026 09:46:59 -0400
In-Reply-To: <CAJuCfpHHkQyj7MMoH++RGraZgQ1Hr+4=T4PfbBn-minUCZyuOQ@mail.gmail.com>
References: <20260616190300.1509639-1-riel@surriel.com>
	 <20260616190300.1509639-4-riel@surriel.com>
	 <CAJuCfpHHkQyj7MMoH++RGraZgQ1Hr+4=T4PfbBn-minUCZyuOQ@mail.gmail.com>
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
X-Stat-Signature: axpc57164pgwdzetpe35o1p3mkytpkju
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21CC0180006
X-Rspam-User: 
X-HE-Tag: 1781876840-835903
X-HE-Meta: U2FsdGVkX1/IMD8HldhMQYFCtadgqroqTHIxb3s1jOqdYxuw4LkCLIdn1DRemQrGyY2u7yEgiReC/RUywuJRsm2jbhWzLe6Y61QKRFBYfegGOms7DzbSTAoolZ4BKF0lfWV6B77NmbSltpw3gR5/EU2qQNXS0fL2BvT6VlBU94XI9t9bTF6xcEaoQ80ggxvp4A+u5trM9QXcuRVjWUVB0ZQ0Jb5pmHoCvdDL1PofNEVX90Ad6IQJIg+xMYIpBndkk/ugUzx/dsWOsdsL7CZt8tS7Vyzfr51CQ9wGnpdcm04MEbE4bUP916oQy7XCFp8RwmMNv9hsP99GdytCWVkAi6HPA1pM3K9UHEnrQwqpIlZp7WVrvMnlt7k4EqZfL4LfQPm0IrIMuU4tBx1nnG/eLJ8saWSSLN2YVokcJnw+TOvE7bHoOotec37Wlsh/7vat6VUEFMdl/0fW4JbDNIR1J6+0qJMZAsjiYU94uYeyA/OO0kv89qDwK620Bi36cjuj+jPh/gjCYnz5ndBuL+i/ByFq6FQxRGUbEgc8jT20/SpnRRIU64UglvlBqQHE9OSLIkptWdqOsqd5LUcGJW8dAqMqzB5VYEZqNjlQ7nR+WZ6O7hGUZie3a3Gwnz2KB4iXwAd+u4xpamXGRaU1pD4l64xTcdrQGqwtHIa0m8JoGtcmR5r+rzVzdmL7lkLlKWRtgSzfa7pS1WolZGq49AEtQLXVMGr0oGug4L4ovdoPRvnhW0r58qt6tbMCBKMnmwFjT8Ub7eFA57gGnSUHhSF/mWYCgFSSQeCWGbqRK+lTIxgGZ2j0EOh7mED0cICJbXuq3rqBZa7K2yxbmRtA+drIZu7s+1eVvV31RH2JcHSlAB+KM/pGclIhJ8Cs2mgumS3nDdusouHR8gs0mmYZ4Dariwf5kw6p68SJL9iY4ybr+phAaxFd/yb6yn8WUfw8BpbUAmAbkWulzvXM4jOOr+G
 7/GeFF7B
 rYdlcw3pJ6+9r/ups30Gg5DfZ1V8oyjn6twtxx9xzYpLU7cx9/88l6wYCJrB7NWHEXcvEO/jNFLG7LFfUUtYLInl5tT2n0pPN2wF5IUjG3XBaG0SFMF4Rb9Rp6Jye8zOwCWe8AQj0tPfmq1WqzateEt6Zs6ceNLpnb9zYWEJ7ocER/qs2wfFnzUk2doNQa2dlQO2t7kk7lt8XOLI/9YhNLm9oz2RDxypDLaSf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-06-16 at 23:19 -0700, Suren Baghdasaryan wrote:
>=20
> I don't think we should be using per-VMA locks if the read spans
> multiple VMAs. Doing that would risk a possibility of reading
> inconsistent data since we are locking one VMA at a time. While we
> load and read VMA, its neighboring VMA can be unmapped and another
> one
> can be mapped in its place.=20

How is that different from userspace overwriting
data while we are reading it, and us reading half
new, and half old contents?

We already have nothing synchronizing the contents
today.

All our locking does is protect the metadata we
use to find the memory.

--=20
All Rights Reversed.

