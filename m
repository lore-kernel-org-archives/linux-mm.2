Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B172DC53209
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 00:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809A26B0088; Mon, 27 Jul 2026 20:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1EA6B008A; Mon, 27 Jul 2026 20:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1676B008C; Mon, 27 Jul 2026 20:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0EC6B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:39:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8C641A025A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:39:10 +0000 (UTC)
X-FDA: 85036326060.04.8E92375
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 087DC40003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:39:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=KThfH92v;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785199149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hkekweVDgigm4cPKAiKfOzXU7bCJAvocV05G6iZWjw=;
	b=6kVwVcXg6KE2WFcm5OYUJp5PeH7L5wmWIW+sQTMu4NGD5ptttnKr0wxhzYHIhzv1kFUM5N
	WsdMLbjk2KophPv1BYCE4A0rvZm9m6lFg353PA35VQA0fSfvPOtxERIxyphOMCNmpPRbK0
	gfiwqwZ10lG8CB/dCksfd/9Fprj9bG0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785199149;
	b=Bg1MkxlhlBHjM3TTHxpTvew9rUGoakLQHNOueiYjGEDTBXaajaj2pM+JsfZgYeEs9AUqDf
	qXyiQXbij/QGvRtVVvbpoqGFlvTuaht/bhKeKq3mMVhguGFf+SOj6+RKHc3WDhY0p0+pvA
	8Yu98W4vWiQjKuUaRsOGZU++uI6LNKw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=KThfH92v;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9hkekweVDgigm4cPKAiKfOzXU7bCJAvocV05G6iZWjw=; b=KThfH92vzkutKeI61n25jlmzpc
	yVeuXMICRGx406TBBKU0HhVx6n7Y/gaX79a/xpXdizggnlI3DFB9Hx1Iij+gPnDR+gVFqNCvavXDm
	gLelQKcRX+ll6F8LKbjL0AKpWnxvbGbHZchPzmV4HXXcktUIGWbkplMOKm6sJ6GFsAX7j4pxCVZ1A
	i4Y7AXwQ/d64Cg5egQ2PXcDCIqOWVwwHrwgLvWLKKbDuvhaKBQfCtP8Y3vTuzhYcdjbcEWyzIVBBu
	ZGyDEe9x9Ht6L5gCHc1k2SOYhyHGwTiFsRlvbwgNq0+AkJqmolwhEH5+qCHtBKzUGrlSpW9Wd2xwM
	uonBAsAA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1woVot-000000002nW-41zO;
	Mon, 27 Jul 2026 20:37:19 -0400
Message-ID: <a086dbb3cc9ee8faa638c70bd282ca31c58d402d.camel@surriel.com>
Subject: Re: [PATCH RFC v4 11/12] mm/gup: batch contiguous PTE-mapped large
 folios in follow_page_mask()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com, 
 Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Suren Baghdasaryan	 <surenb@google.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka	 <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Mike Rapoport	 <rppt@kernel.org>, Michal
 Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,  John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Matthew Wilcox
 <willy@infradead.org>,  Usama Arif <usamaarif642@gmail.com>
Date: Mon, 27 Jul 2026 20:37:19 -0400
In-Reply-To: <5490f8b1-d611-4e4d-bd8b-19c0e05698a3@kernel.org>
References: <20260724222934.1463812-1-riel@surriel.com>
	 <20260724222934.1463812-12-riel@surriel.com>
	 <5490f8b1-d611-4e4d-bd8b-19c0e05698a3@kernel.org>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 087DC40003
X-Stat-Signature: iopcbe53cjx6yrbnj6j84qy1eaaqfdi8
X-HE-Tag: 1785199148-738370
X-HE-Meta: U2FsdGVkX1+HQ7GAVpIHXnjFxDTkAw0nUWh0Um5pFC58dV2SC3Hjc8UkGJQO3T/JolN49eslTqa3ZoqEnc1DYZwe5yD4nZwVfNlgCSd+lckJG0uJM9YCsYWKmSJI3RiHIDzsTpkQpJEO8l7bcr7ZhYHpr3O+CE6dUxO7uzg0uFczyL81iaAwixB1Gjm9cZZ3iFE93DBExlUshtxXzFig2YIdU4HMVfG6tdBh6JPwv0Wezz31nmrpHGoLfWhfURP0icuxDDR9lI1neFjqDBsudKYKVBSkCkLZEDCEu3tsSf480VIwX7Jovtl2qq4Yy8Aai4vkCwl5cZLtb5rQwt2w/QKpx62qOH5M2qfFvoFtilZx7otflx754M9l+YfKAUVpb3XkLiplC6PpLKWa+dScI73rlxm/nkJ8OPpW3mpD+8TnjHOUd8ijqn6dY0hGnf8B3OTf/NaNSwF8fvAWIczpY/1W0Swq9h/0JKcFuR3hO3Y6VoJFRpyEb0mDsbXLwvt7yWb6S17NanCXE2PYoCstKyjBscPcVYX30/le2xyDcleW3YClgp2xQoj6+hP6oDQiXFUGLHjsuLMRHu1s6ny1ukX/Al0KEnYzjEGmyhoaYIrWpEO7tuk+9+LHaqMo6xtRitJPT5IBoP9wLkYPtzfXLpDobAn1b7WZZ4GwV7e2+W/HaLVaUV3agKgMq3aNRHtpavCnIOL+3CRVDkkFcLnCokfQpwNBi0paAVrMdvWax2DwA0ivKIBDluW8F+LFKO8YRJnw2mRZQ74g8bCf/11jDAjlglh/6WHz3mzbSwuUpBCWQdeTLfQTYKiMUYB9Icv0XU4lXEGhywg0ls99YaBQuoQ7+Pkr5CmjzGojGh8kfZDtM/FgQDSHeq4NLbGlqmxU/9BIEd1P9ZDfsgjz47ef2dtppeGhMxVMoKWBVQZtWiRRk9y8hgsM8a7VdIB1XH8XgSAP4pBUOlIzcPQOxIf
 Z3iynw2X
 ag2hXO+8cGh/e1tytxV0j+5s8I+sYBsc3bEn6jh0Xdco4K6H7c6VNOv7NPQcDNPYnCafUawRA6cIUMuYYUBJPS08p+gy9hyzui10aMyjTXPDP9czR3Q9XWhpVlsytJLX+mx1iqs/zF4wuR5SwvycFpC+3SAD9uNwE6s0oJiqnRGKZN4ULFjQyDjfRaCMe45gX2xir7t1aziV/dT0m/GzW4cCiRq7+5SSrjCFivDL3jiIg9W75L2P5uOo6zB+786gA9IGu6gZ+Rbwge7eImzklunLTx/qhsmmyR+Uv13DI1/tYpgaUwLe42Lx1y41j3Is3LYo7uZC6fqIEYcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-27 at 15:54 +0200, David Hildenbrand (Arm) wrote:
> On 7/25/26 00:29, Rik van Riel wrote:
> >=20
> > =C2=A0 gup_test -L -m 256 -n 65536 -r 16 -t
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 befor=
e=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 after
> > =C2=A0 64 kB mTHP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 3140 us=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 412 us=C2=A0=C2=A0 (7.6x=
)
> > =C2=A0 2 MB THP (control)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 78 us=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 76 us
> > =C2=A0 4 kB base (control)=C2=A0=C2=A0 3010 us=C2=A0=C2=A0=C2=A0=C2=A0 =
3042 us
> >=20
> > The PMD-mapped 2 MB THP already returns the whole mapping in one
> > step, so
> > it stays fast and unchanged. The 4 kB baseline shows the per-page
> > walk cost
> > that the 64 kB case paid before this change; only the PTE-mapped
> > large
> > folio case improves.
> >=20
> > Assisted-by: Claude:claude-opus-4.8
> > Signed-off-by: Rik van Riel <riel@surriel.com>
>=20
> Why is this patch part of this patch set?
>=20
> This makes perfect sense independently, no?

I'm happy to drop this for now. I think it would
fit in better with another optimization to only
take one refcount per continuously mapped extent
of pages from the same folio.

I can't really untangle it because it modifies
some of the same code as other patches in the
series, but I'm happy to save it for a follow-up.

--=20
All Rights Reversed.

