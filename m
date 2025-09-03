Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92892CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9EE66B0008; Wed,  3 Sep 2025 10:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76708E0002; Wed,  3 Sep 2025 10:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C7C8E0001; Wed,  3 Sep 2025 10:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 843826B0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:01:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19F91137A61
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:01:48 +0000 (UTC)
X-FDA: 83848102296.06.8EC558F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id D616B14001C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:01:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Gb2fAwLM;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756908106; a=rsa-sha256;
	cv=none;
	b=ZwCE55Mv2wK6XOF6B0T9MeBmnyKUBtAqNPlamnu5Lzjhv0FbxsviIbJiatMZE6fA9+BV0g
	hhiw4Sm+NxBp3UPnnlNkPsAPWnlneCBH/JekmDt31Njq8m9ouYjuN7xWEhEoVrY3AlmHEY
	20znfi2caNvv8LuTxFQudEYCtvaTSWE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Gb2fAwLM;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756908106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MywEynYNUb/+vviy4Gt34/JK2ggRg79daM+ma7Rs1DE=;
	b=GSMN6eNuR+ExCQJxL/EiZhycIP0BMAepm5Ej1I1/V9UflARAIhr4sBQNVc2lVJZt+pmsrS
	mT0oJJ55Ry7JGcHSu3GtPqOrCoIj8VZhYJSa9S7o8fKOAjObfgS6/F4HRvI8NNckd7lRac
	GzJ1qdbKIjC5TyIzV0oENcxxZxo1crc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MywEynYNUb/+vviy4Gt34/JK2ggRg79daM+ma7Rs1DE=; b=Gb2fAwLMTtymMLa7ezoFfLhSpS
	u1sDrLJZmp5PAtqVxy0YMI0UTXeBzWzUcr7lHjAnImbU3dlfXlHzRl/Xucj3+YoAfx2GyQwBWHpuR
	liEjR+KCRhUOAwctQBJJkX1DU1wcO9l90tbTfIpKFNcGR7X6lbIVdcRHK+QhZqy53jVmOtm4VAvK3
	iv6Poz6xSKgnerY7XlnNM22ysjWf0/DoOSviiAXdZGSAdPYWcOZaMl31ClSL3mtlhAE7w00R9gPrM
	ElZ/15hOBqiJVJ75N/RdDELHMI0bVBnJruPCWJ4JipggYDYB+yAJiaV78QiTfDTTkK4Xty9eVnVK9
	yguwjVaA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uto2H-000000004Ed-2uVr;
	Wed, 03 Sep 2025 10:00:29 -0400
Message-ID: <59f1b1b6e1ef24b0d514a9885a08400c76b0eeec.camel@surriel.com>
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
From: Rik van Riel <riel@surriel.com>
To: Dave Hansen <dave.hansen@intel.com>, Giovanni Cabiddu
	 <giovanni.cabiddu@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, bp@alien8.de, 
	peterz@infradead.org, dave.hansen@linux.intel.com,
 zhengqi.arch@bytedance.com, 	nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, 	linux-mm@kvack.org, akpm@linux-foundation.org,
 jackmanb@google.com, 	jannh@google.com, mhklinux@outlook.com,
 andrew.cooper3@citrix.com, 	Manali.Shukla@amd.com, mingo@kernel.org,
 baolu.lu@intel.com, 	david.guckian@intel.com, damian.muszynski@intel.com
Date: Wed, 03 Sep 2025 10:00:28 -0400
In-Reply-To: <913a509d-d985-4520-a879-538a1198b946@intel.com>
References: <20250226030129.530345-1-riel@surriel.com>
	 <20250226030129.530345-2-riel@surriel.com>
	 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
	 <913a509d-d985-4520-a879-538a1198b946@intel.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D616B14001C
X-Stat-Signature: aqyggja1tcf9ui5iku4s1crfqubdiuas
X-Rspam-User: 
X-HE-Tag: 1756908104-506463
X-HE-Meta: U2FsdGVkX1+5VUYiMFghUwwxFZlKLtVlIKNCcNR48mP+5PDeADWhACAv1slZEHjIy4Y2kFW/L/XUx0Lbmq5IWdYczkCJUGZ7T7l00iyH/3pDI6XpNlqw1DlptrhxK+z5YqMfCa6O1LFAVb8J441mtg2D7wfgAXd9HPspiyCekj1sTbCPklf+NHpSG0XA0e9C0sF47eVdTHSYqYue51urz4+ProYBPNRkf4ko8mzAK5sx4RT8PGF7ScL93QO7lZHdI98+8L23sKSxv0YtTGTcUd9ZrgA9vKqRPQtIYZJ/d87F1cNMGM9onqw5zZVubQN9p0Ufjum+5RyMGU7NEkFsjSDGNEV7w7RebeghDKYwJFRZLncI8NYGyYIvUIzPD7srMRg/EvAxT53ILTkBcgZ7uv+D8Yv3+S9KRnJMcGcJiwXAuFHIsljvTTpmxnSgCf5Gf6JAgKm7RqzzB4HB1OXQEuNKAnRecZjuF5egW7RoJphV7aNW2/3zdsRLmh8VPkLlauYnDjxeumvjvgaIJaRKUGk+qS1YyFOVTAgV4VlLtOpfbUnARNkMjsE8b617rZa4hd6vZMXDLZED1R24q582ZDZelvDpjtKFqDCy4tWn5tw3M0UHOVia0vd+cfOxT2eAJbTGQLiNeRVBW37uauGe6ssDURauEQM/SAqz1RfW+JqtGmKmu8/wOwGR6udlDkMxqEdFk4yFj4+8qI8I+bU66F+ueEqtfrLj3QRpnlXDRVlFd5rR6q9hDjp6iNjxPWdx3tsiBz93Rfj5dfd8esZksn3GwF+X2M/BDnrokalCmbuuQAklXGCCDFFOEqQ/TAlvJaSGmkFp1HL9W7dL8XUqARYPZ+AeXRNNJCcMrG8VT2w3M1PpBQgoqIygKFNhgafYqzmheQp9mNqjXqYXrZfH5T9f+mBLv0cwFp7PoVuwJec5Hg1tkh/KPpMupaPjuoj8SXXzFLWvkxj2Pg6rygr
 J9pzDuel
 sG/PZT0G6mG/0bIEeBsVE3OaRCgqabS3K/pVQ5sc+ZjQ4d/JOuCo8V+EYTZfqLt7lSBsKBBFd7a7OU02vM6gsT0Th8mjeyKf1a6RU/Zt7/qUg9Fzl4F08jAXDO3CVrh9xXPyY8A51zD5CFN6AfdvkzaxpjRwrN0mLQEVN/lj5WPkXuWu4crUUQ6dG4+omKBfusJj2NIQhGM3dhOJCyRtxJ2w8pqmm4Emzm4X3py4NZ/UBuNb4Rv3AebX2PheEh9FIs3pRPoTiGK4IeiJc/n8Qq1xZy/xkQQKXnqYqwYIwkNCneW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-09-02 at 08:50 -0700, Dave Hansen wrote:
> On 9/2/25 08:44, Giovanni Cabiddu wrote:
> > diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> > index 39f80111e6f1..e66c7662c254 100644
> > --- a/arch/x86/mm/tlb.c
> > +++ b/arch/x86/mm/tlb.c
> > @@ -1459,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm,
> > unsigned long start,
> > =C2=A0
> > =C2=A0	put_flush_tlb_info();
> > =C2=A0	put_cpu();
> > -	mmu_notifier_arch_invalidate_secondary_tlbs(mm, start,
> > end);
> > +	mmu_notifier_arch_invalidate_secondary_tlbs(mm, info-
> > >start, info->end);
> > =C2=A0}
>=20
> That does look like the right solution.
>=20
> This is the downside of wrapping everything up in that 'info' struct;
> it's not obvious that the canonical source of the start/end
> information
> moved from those variables into the structure.
>=20
> Rik, is that your read on it too?
>=20
In flush_tlb_mm_range(), we only need to flush from
start to end. The same should be true for the mmu notifier.

The only reason info->start and info->end can be modified
is because a global TLB flush can be faster than a ranged
one.

I can't think of any reason why that should affect the
range the mmu notifier needs to flush.

--=20
All Rights Reversed.

