Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 970FFC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 17:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A8D6B0093; Wed, 29 Jul 2026 13:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBAE6B0095; Wed, 29 Jul 2026 13:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA3F6B0096; Wed, 29 Jul 2026 13:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1AF96B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:33:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 473BD80735
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:33:13 +0000 (UTC)
X-FDA: 85042510266.26.A39C58D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 16F611C000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:33:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Im3l2SZG;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785346391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEb8Bd5m5xa8tu6hvQqbyARRDUBCS3xJAvu2ciC4syI=;
	b=Wig8HgwZTgU4OpwKwOhb6FIwu85Edr3+baf+vspa94X8kZrDDYe5JuWBEaC7XCQ77qkIlI
	gx1LF7LB2KWuiP6puPUOgBsBQ762Lz6U7x0dtuK9CoZWy393kLPKC5GzTA5ynipuPMYH68
	xzts2SfsrdaAebB/ebf0k9shUIe5Np0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Im3l2SZG;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785346391;
	b=ROwkZyGFJmMp/SE1u7u7OUV0VccX7r9ZepyAZdgjb7l+TuySF+rcR93vkfyoel0uejJn1y
	gmGWXJj/PPz+TlCYdRlJSNGJkKV9qxs9Mo171zIzTmupew0gSr4w/cloDAvdmky40xWcT6
	MrxQbgXqFStvHg3VNiJCLuRCEd+bWI4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pEb8Bd5m5xa8tu6hvQqbyARRDUBCS3xJAvu2ciC4syI=; b=Im3l2SZGB5RJ2y1IabZ/DfirIB
	4rjdzTIdhLZB0hdrG9+W/0+4ctuo+tTn8xqyMBNV/owAV/8tpZLlKs4moIu5Nraf/CYHrgLFctqkQ
	f/80vjwDUvZGNAUr3uDQo/9tFU7M28n1MgHpNohrhYvie1LsBOEQQAyrzLWlKhawbz4tbsOfjFKQ2
	QPUXkPS3Tj0XuDbJeWJfx3YFbSo9QGWNEqRbvHedh/2IYex9MOtaz6z2FMYl6duv5OfDsDOHOuXs1
	o8wpIyVN1GnRj1rdyIXtr09zDF2nfv9CHgimadmGYWtVX1eHNgTSILZTW5xrMlH3nYmxfnBjU4QgY
	g1RxJwyg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wp87q-000000006BO-1M8h;
	Wed, 29 Jul 2026 13:31:26 -0400
Message-ID: <432cbf0c1194174259736d929f7f919ef55d19a9.camel@surriel.com>
Subject: Re: [PATCH 1/2] mm/gup: pass an end address to follow_page_mask()
 and return a page count
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Dave
 Hansen	 <dave.hansen@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Suren Baghdasaryan <surenb@google.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,  "Liam R.
 Howlett"	 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal
 Hocko	 <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard	
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Matthew Wilcox	
 <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	kernel-team@meta.com
Date: Wed, 29 Jul 2026 13:31:26 -0400
In-Reply-To: <a3411350-d4c7-47c7-9ed8-b36748815660@kernel.org>
References: <20260729030234.2063885-1-riel@surriel.com>
	 <20260729030234.2063885-2-riel@surriel.com>
	 <a3411350-d4c7-47c7-9ed8-b36748815660@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16F611C000F
X-Stat-Signature: n9ri4k8j19xqsc8ihdrnzrwyoqjhie99
X-HE-Tag: 1785346389-198186
X-HE-Meta: U2FsdGVkX1+6gcrwlO/4bxs5YSuGA4zpZ9VjIDBHTjzYD0oJ6AvS45BP4asI1i4li2NcqpKbxoXBI0gp6SYM94t5P65sARDWQoi0LJjA2WcQBaNkSnasNNSPB/EYUAF4IPA57JiXiC+nAZPWhruqiXQifBjxvvz1Y3yqBL5BMDGwQDsQFE9pwQ4wVGLZNStxYwif1ECEdR8YXRF52chdbMifk1BlfRpcwN62uNAMIjBtHJqj0PlMqLoLaBtetWpj7RtgTeUbSCKUStjqIMkCHoSSkMStIUIAvjBRnse2IrgPvG1+bMiiAd1qht3cCxI6ahPhTjYaJYYwxuMcIV2kHVf1orGi0Wz7+9fB3G1UyUlRGr35fg+afW1FEujbneoPyE6Inx6FwIWnVdA/tsbtLQpGaUN+uQ5vRPAQDjVVQ/36CgZOWcpW35NNtCyftqkPCtlcnFbIPbmMLmu9P/12Q5ktLYNmLQA8k/f8a+UFYTGhDjy8qY0OmnDd6O4nNChgFgLryVwTDkzHGfk/qJC0TOrVRdZFaFe60oO+8y3kCQXOZUqSlR+qFIXAfxV8bq66dBdprd5QN8Rj/gWbRsQsGhw1/RyM97xl5mOHLHNQCY7FxK5z5mHv8oIJU/+8rZvVwSe4Zx8qbh6nCh7bmr8pEqOCjFX/uOkQ8Di1f2w4OCibGsAYKJF6/kDvLYAVO5xwa20In2OJG/tKvH4DVNNvj3lCEbZP7n65DJR0Cg7icwUYfgpLoUmZ+/7TS48APxhVFbu1l8NaAAyWKJAK0JmZwPej8SVLooohANX6J7tASiXZ7zqlhKLk1Xqsk0sx3cBHE5jUCPuAOUiiTfovUs18vbKko0YoftHhIxgilrjA9e1p2lepdWBvj5NhnXPCphSZVCIkjgl1snedPWOFkWckSZFuYD9uhiptG/8X5bNXspyQn6pW8lEZbtdkGwky2cBtzCkioGCHiYc4gOPmao+
 POlQ2FCi
 lRl48KHEiIUjfSgJ54dqMGmeM4+PIZhSmOApZeWM1D6PzRnMBjd8p3uj6Gm0wBC49psmdillMo9B7Nq3thP5AFqdu0lPaZhgljCYd75jaIYz4ljISiGTidMDUYFPUBShUyiDXox7OWP34x3VZHu6nnS8lyQGbf9JNAQ+za8Nv+7NyZ+J4rHmaCkWPbAgCX59FibogJaeL53/AnaNzBb6tsptH8OXhnd1tSPvl6g1bNxr6CE2wxFBtyVdsb7t16Q3uT/o2UYdcX0igqLuuhLpaFWyzln2bGnHVzUK/ffb6AJ67yfqU7vsp/+q7hMVIyTk3oElCRkuj+Ux/wkE/Mhfk/ltCbSlLzxG4D1VpxkFP567MTI8uJdd7CpuvMWfPqxMjhYbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-07-29 at 09:16 +0200, David Hildenbrand (Arm) wrote:
>=20
> This patch moves us closer towards the GUP-fast path, however, that
> is about to
> change:
>=20
> =09
> https://lore.kernel.org/all/20260219050250.266876166@ruivo.org/
>=20
> With that in mind, I guess in the future we want to have:
>=20
> static long follow_page_mask(struct vm_area_struct *vma,
> 		unsigned long address, unsigned long end,
> 		unsigned int flags, struct page **pages)
>=20
> or even better, now that follow_page() no longer exists, in light of
> gup_fast():
>=20
>=20
> static long gup_slow(struct vm_area_struct *vma,
> 		unsigned long address, unsigned long end,
> 		unsigned int flags, struct page **pages)
>=20
> Returning the number of pinned pages.
>=20
>=20
> In particular, such an interface would allows us to process multiple
> ptes/pmds/... in one go, without having to restart the page table
> walk all the
> time for each non-batchable folio.
>=20
Let me give that a try. This looks like a very
nice optimization, and cleanup.

--=20
All Rights Reversed.

