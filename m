Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B40160A2631
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=nuRrXCJb
Received: by kanga.kvack.org (Postfix)
	id 7740C6B05D1; Tue, 10 Nov 2026 15:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B556B05D2; Tue, 10 Nov 2026 15:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6887E6B05D3; Tue, 10 Nov 2026 15:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1B46B05D1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:23:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A05F1C452B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:33 +0000 (UTC)
X-FDA: 85420334706.06.D6F9303
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id 96A8940007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nuRrXC J";
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hA3MfN1BbBCvTGqSHg5RbmX88uNEM87rEQGr3yVhnA=;
	b=6u5YkF1yaPZ7eJ5vCuqawIpbkL/UR7DkHwkqWLCcdgK8lcFQkV51A8v8j8CQwTnyk8h50j
	ahrziL+WFv6qVzDOkKUrccVQaE5Cm2/LXvnsZrlDlU70DvHx6Jz2kaqikleKHt32msZSh2
	d8Zp1PtH/pMza9flWd33wYj98LR5BRQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nuRrXC J";
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342211;
	b=0/VL1qVjfO1HEUMTue8B9K1UXFF3f+iwJRuU2ExXibx60fLKfBSMGI410BIL7l81wCQL7D
	Fz/rZ7pzpQNdB6bonIqE6Wp50Gd6IDlmQmzfZHJsUJQ4Umgo5OUDCwg/UrY4soztjNZ+CA
	qqnNEYNecpkYo06Ffv3LMJPhyXzwAus=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=6hA3MfN1BbBCvTGqSHg5RbmX88uNEM87rEQGr3yVhnA=; b=nuRrXC
	JblYDcQlT7M+FY0Fw+jCUrv6dIe352eRe3+z1Hr9DVVo8CYLForaq7+mhXy2yZZoyaybdsubaLNeY
	rI8clDBgELyStdptyGcWpgot+Cm41srvMkD3PhoRiCxOh2LJmuFzva+GsJwfc9CE13iqjRoFXAjRn
	xcw6+cgDc6bjiP6gUg7ImfCPliFxHVIWDGm7nTjdSZ+QU7Yocy4QfIoldxBkxpIpripccVbENuthR
	2zt3hEkKzz7nIAv1T1DTro3SC2Kg+YSvTvaNwgfBhazuh/PRO12G1iLwlHCFb+gQ4c3zruKAo5tAm
	aqix980rD2xv8ND8l3Y53x4iB/qQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xQsNA-00000003hWy-0yIi;
	Tue, 10 Nov 2026 20:23:16 +0000
Message-ID: <5db7a358c293393a93984ac3c3cc58e810edd75a.camel@surriel.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
From: Rik van Riel <riel@surriel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
	 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Lorenzo Stoakes
	 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton
	 <akpm@linux-foundation.org>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Date: Tue, 10 Nov 2026 15:23:15 -0500
In-Reply-To: <avN8WISVUF7u4bXl@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
	 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
	 <avLqwIWHa5CAbHO2@e129823.arm.com>
	 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
	 <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
	 <avN8WISVUF7u4bXl@e129823.arm.com>
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
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: 4a6dhaxgh86xiu63rjj5dj1ecqkzojya
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 96A8940007
X-HE-Tag: 1794342210-935060
X-HE-Meta: U2FsdGVkX1+bPp6qBZToWHEfQlOpPtnzbQfvk23gdEwyoi2kH82ubZsH6wTYjgYIIzWtbxHXMeL5nxVePGOnaz1iyaLn+NsZny/y6DJ92bvmxPiWhMJqKBZ9OaeOfVu6LfE67efYbrehLy674QXfCBXa3fHw8MIhGZ0mTOfy68RpoZsK3MqexN+p5G0cx493dfJmbEO16ilpY46A2OZrP3rPx2gl8hFibDNhbtombEGf5M/3mssh6lyPueOLhxJvqL12dN31aYozhIw58qZ91KbZ0kR11t8irWOl4b8BeRQMMPhSEzXB9j+0WLZQPSVdR8ssrfVusBnHTDpe0ASCqkTun42w3AdtO2pILaregHYCmFew3TatbDueDE0EpKCPXyyY453vm5nzqc9LtdnbmFqLXFFXZN96pwTty8QkjIVwsd9IQlMC739CGN+HzrjY/p+WCFjwSfbzygPUoy8YzGAbpPQcnQArjP4Gf4mpRlsSBuknRQonp51kxDfHTj8v66wIgb3Sqvr0BvcvANTMpNkOT0heEJ85NatfvLQGm7wnWwmzJxgqn5R6VJphHh/1XxKZgRvYURq/6oiYgNYwUtNBV8yeijkoCaEq/obhBYaxXjhQQZYSVW7bxolDuGDIS4ey70YTHmF6bcXZq2mA2dujCWMGXA1nwcC0OC3gX0hn/R2mGTwY8YgrOLM4s+VcEWLw0cmsX2ppVQ683o/ez0MQKCKH55fnY1VnVLdRkV0GUP7j/xLQaPzn/OjOOZQSDiK72Aa86JwbmGixQq8IzyxA98vv1MrjU0B0IsuX2hR3Xj60Dgyy+uErrH7yVqH13UDfIXzU2jYepHPIeXm5axPu2EViCjuNwySPGtNt8cfNv4fvVxbl5LvJoejhjMrpAnlOTyqyOrs1+iHwlDHh1L3JVXEds9sRzpQfNc3sGGbh1dsUBlVpEONnK+icyd9aftLSYg824sKHzYlmSM7
 n2FpB6cO
 xz0Z8264f/K3aj2p/6MpHjLyJrbgJIMpBit7MJ1JHswuPOY5Qu7pppMPco7Ib1KkAelQMHug+7YzQ+wDzgkwpjO40/k7sLkvjafcL/clcIit/ZRwnlMcZLN9CjNfhJp10ghLiD7gi+X3piKbGoibbdTyPgxCWxY0bfirH2WNa7/WErnZQQTgDnLa+NhAcwECco1isBbV0yKIi7AMiBxYrrkdzK4pgyY/zJ/h1xM1GQmVKeXKaS8kg05sLOVg8NKnGlRjJRu2aukKgnDPwgeLxj8EcKPXwe6xPqDeI/OqUWhT/d7KU7waBObURI1yB0jzLbcnippZM5wb1dpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 20:19 +0000, Yeoreum Yun wrote:
> On Tue, Nov 10, 2026 at 02:21:18PM -0500, Rik van Riel wrote:
> > On Tue, 2026-11-10 at 14:04 +0100, David Hildenbrand (Arm) wrote:
> > >=20
> > > So it's all about "number of pages that don't need unsharing".
> > >=20
> > gup_no_unshare_len() ?
> >=20
> > a little awkward sounding, but it describes
> > what it's doing?
>=20
> Hmm, Wouldn't this name be semantically much the same as keeping
> the existing gup_unshared_page(), since both essentially convey that
> no unsharing is required from GUP's perspective?

The function measures how many pages in
this current interval do not need to be
unshared.

I'm happy with any name, though.

I would really like to just see this
code go in, so I can post my two
GUP series on top, first the batching
for the GUP-slow path, and then the
series that allows access_remote_vm()
and friends to work under the per-VMA
lock.

--=20
All Rights Reversed.

