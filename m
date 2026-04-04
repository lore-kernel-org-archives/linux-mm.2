Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFCB0E88D6E
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 01:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335D86B0089; Fri,  3 Apr 2026 21:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DB06B008A; Fri,  3 Apr 2026 21:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223436B008C; Fri,  3 Apr 2026 21:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12BEE6B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:43:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A38A1A05D9
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:43:27 +0000 (UTC)
X-FDA: 84619176054.15.6F27D6E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id 033DBC000D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:43:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ol9lcwub;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775267006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHW+k8KQfaTNE2WRP5tjhicsFjNo+SBioyXM4XMu8gk=;
	b=bZsgdNi+sp0laOHBUnbXTzhVhI+DKOJja5/0UhmpvFxr2Z5CSKIHjjBuyNkRYUoG+firt7
	BMNiPGu3Vok0PYrBmWgA9I97fwI3UcKG90cC6x/nBRo75jSdS5HGMbmu/ODv/5PQtStEVm
	Xzpr5mwUoUcMAPEkMKM4i5n4eaR4VDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775267006; a=rsa-sha256;
	cv=none;
	b=nxDiNsgkoZcS/ADutf9RV91YabykA/QXg5BYzpZFXGCsPxi2gcobIw6C8hoApg6yA9ryYD
	ofC5bporOql1T0XXOJdYm0e96VHHpYB7ziC5BsX+SMaJMTFOcxQ4Gq60uxYPq8YYlHD+Cm
	fbwsanVCEoja35a3RS639Qd81TodlEo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ol9lcwub;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PHW+k8KQfaTNE2WRP5tjhicsFjNo+SBioyXM4XMu8gk=; b=Ol9lcwubolhlRoTGwUL3kna3nS
	CaFpulKcuPIwmTn18FC17gPDwtLY6JBEgpPbBLzJ9+9GfPHxrk5LZ/Nw99JkxAhzESbGuMsMtPTqP
	UWlIeokYe3aOrAHWLsgOOtzwBNi9x/1rGV6UPYXX5VtYlHB3r9p3IxWgwpOU4uK5wSiADHH6Xr4nU
	G/2WmgcvYRTfh0dlJGiBt/hyPeQJL3igMCVgP9pAryYGlKuH09FwLQAkKcUDV/S8uCNyIu5OCMzcB
	A6JDQu338+ydTWEOmt8gPveb0xnUXJGO5Ies3QIHyEUZ/aj8AvqHj9WUtrxMbt2k/ckCsxzrkNxVS
	g/a01vLA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1w8q2l-000000000cl-3M6u;
	Fri, 03 Apr 2026 21:43:23 -0400
Message-ID: <901716dddb748bd91a107cce1f95a8eb44ebeeae.camel@surriel.com>
Subject: Re: [RFC 1/2] mm: page_alloc: replace pageblock_flags bitmap with
 struct pageblock_data
From: Rik van Riel <riel@surriel.com>
To: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett"	 <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, Johannes
 Weiner	 <jweiner@meta.com>
Date: Fri, 03 Apr 2026 21:43:21 -0400
In-Reply-To: <20260403194526.477775-2-hannes@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
	 <20260403194526.477775-2-hannes@cmpxchg.org>
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
X-Rspamd-Queue-Id: 033DBC000D
X-Stat-Signature: myewf66anpwjpwn8aquj6zffyr75ir5s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775267005-299945
X-HE-Meta: U2FsdGVkX1+djCthJJCRF+opLR/usxy1/ecz8hugV8Hxum3rVGhgfCQOSVjvxBvTUpUXGw7iEpQG5b8QU71M2MiMOqaAYfeRwsYpXPKv6IuA/LOjUcnBP+EwueRECKNJd1yCe0Xh8iYV/HMouqwCodAu5IXL/IcEXDlG9Mx7oLnRPrW325kRp3Eyl7o9VRPqCOFRCi9XcEe8CSWV1ZyO/xBM03JaZJ0OAwhshx8hZepnLe3bLXlfrPoVYFlmdmF1MNY4Gjk4rm1PNu0TRVrxEbV36UnBRbk5x8O31FUZi1SuUZZh5NwMYl+ONp55EJnJToHFPIac9Z/Z7aDxWi2ifJ5XsxVOU5kEk8jpSDxAqhMSi5uqtzz/qDQMzg9AbE3nj6p1LIq80LkJjY3W95tMNEqyr7HuO+XW1ze1Vqz5/35qv8Qz7l8jzE+B9x9MDftj9KTGLQj3PjGF8nWlP8EROEeMptQALKXTmqqrGBOKLkuzFqVTgvteCRoe0xdYaRBPBxJP6FPKL+aQJQPNjJ9cZMlP7xJpTIzoz3Z+e2YSKwL8jIOS4L+mPDcgkpx55ms0SY15heN/c2dV7iBk7n73I9IiEBAFAGI464H3ec5lI3/5FMLsSYanLDzKxVDFTt0Pt4fIutOYMS2NtcQAPpCGbKm1Auh2kDm+I6PSLlNkuc87QWpou09EheHuWoDIa/uZjoDM4Up+TfmH2lVcbPc9+2FkG8u1bd5ir9sdwHbL3Llhtsd/w80sa6Wt9toGj797YZ9lgroWf5nPprBdcY4thIrG9KgilKQGdabdcaSnhoK/bIeEe6xocqtH8laRWEDJ48vNS3UFQjcf4GGF5QOtiRZdCSC9Oiy5kErayHCK9izblPEMAkY9a3K1eXnT1FC02//P4NcmGJesrwbxrQdom5xXQm3/3fRLwUk2xAh7VW/AM2+ZUVANAPB98Fj+BUnC9fvcdgkJPU9luOPlJSo
 ybglyV8m
 GIX+fRoznGM3DDw4JBL6vZ1E1E+t/GiHyIUw3GHhLAgqYk2A/1r6Hk0VscnL0/nNVtaY0UN+qroHQ/DKRVI2IBxf3mba99kAA1FVT6oS8do7a4wn4MjI1Kb4J+2oNg/9bjs7xfuCss1993URvxtaLXp9f0HT1G4j7TDndqq+q70yenoO9DhtKZqky3Grnc13fqnO+9tq14vsoOT8ihxfDD2stwVAfwZacbmUJK0HfwkDcbAq8C3aatVxTI3ZcDUshA2deFAjUqk7J3kxvxzLOpTJB1s7ZeHrlBydonUEwj0dONLadyMK7LhNxPGxQfIsIIYjhvcErVoZA162wtA5eaMSozz5a+9Gr2AhVASQF3Hf4LGq3rNPjTIrepKXkssgQ9Ib6Ew8xyeCEio1bU++5D0VDlRhFeOqmCrFNr12y5fOYCHozAIOmYpEp49AjB764cxsR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-04-03 at 15:40 -0400, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
>=20
> Replace the packed pageblock_flags bitmap with a per-pageblock struct
> containing its own flags word. This changes the storage from
> NR_PAGEBLOCK_BITS bits per pageblock packed into shared unsigned
> longs,
> to a dedicated unsigned long per pageblock.
>=20

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

