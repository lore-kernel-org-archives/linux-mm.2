Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E54606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=La82y597
Received: by kanga.kvack.org (Postfix)
	id E7B016B05B5; Tue, 10 Nov 2026 14:21:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BBF6B05B6; Tue, 10 Nov 2026 14:21:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1AAC6B05B7; Tue, 10 Nov 2026 14:21:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B04116B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:21:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B09F80A7C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:21:31 +0000 (UTC)
X-FDA: 85420178382.07.7C78F26
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id A785E40008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:21:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="La82y5 9";
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794338488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1t73b5ZSa12OsN3iPrfbLNmR1n1bS9CZocRd+GhLFbo=;
	b=Z2h3bNZAc4oHab2S5OeuYpsUlQE7CaT8GnTKmjm5x4sJy03Om0Ikg3ol6GOID315Hsdauq
	Zb+KtWiAwZWkqv3xoFh85OOpebG+gmyNWWyJsW7wFTBGV1g2qSkxlWmHGB+U2jpmW/Xn4I
	gS6m2+HycE/jqm78yGKT/9RM7WjIdoo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794338488;
	b=HfniOcDjgqsxO/yvAc4zLFBOyWXUhWwWNkeBRzclOpPBN78NoXmKxtucHeeh00WWdWxtp4
	ZQL9cJaeseWWhOjjgS8KDcAy768qy6R+BB2qM1lwcIKxvmECeSudYtNl+pMCaSkLyHQQYT
	lcZPlIV5vgzUyE3PvPHCLtch4CRw/W0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="La82y5 9";
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=1t73b5ZSa12OsN3iPrfbLNmR1n1bS9CZocRd+GhLFbo=; b=La82y5
	97ml0CQGynNL0ie1/M+r2AMEH6r0CUjXrEOt8hBih5Yayt9jYw5yR2vnqfofWCOo23FjTfexiCHqH
	Aoct88cTpSYIbbhnnU3p97+EeDxJDGsdZv4cegHk2SXkSlecCxPlX4JQi13Fb+p1sQIYly/M5CY1A
	PyPXgHDfUPBaUOgKH6Y3spdl/56HRudd37a/zhjET2rumoAxrCFyhaujJgQkvLIkmTjUGvqiy+BYk
	2UK1jpdqYo95Daomv5UtIuJrnNYP75/8+gH3Ng4k/ufLRE6O/RTXGqVV+2GZZwEZfnehLqgi0BCyD
	CLiddLOdwCa4KrJN13Zk/KWbC4oQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xQrPC-00000003grc-2AWO;
	Tue, 10 Nov 2026 19:21:18 +0000
Message-ID: <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Yeoreum Yun
	 <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jason Gunthorpe	
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>,  Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Andrew Morton	 <akpm@linux-foundation.org>, Yuan-Hao Hsu
 <aa9736195201@gmail.com>
Date: Tue, 10 Nov 2026 14:21:18 -0500
In-Reply-To: <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
	 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
	 <avLqwIWHa5CAbHO2@e129823.arm.com>
	 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
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
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qqyz8pmmw5ugnexbgc8xpo8a5tut3mxh
X-Rspamd-Queue-Id: A785E40008
X-Rspam-User: 
X-HE-Tag: 1794338488-469996
X-HE-Meta: U2FsdGVkX18RfFsawRgkT+IrXpfkc8FpuEWFv8C5sgDpS+IPV4uMj/ZYgiH3juLJMph0jg1UdZRt3i8xhQ17RFy5TYmuMxe+/bn8j4A2jl8F+X7AbIG1Hx6aWBlrVipeGnF22wBNKFhA/atp+4JFt6st7L9G6zlqrq07LzoEviHhDU9iEYcrS6NtsyGncysERvZdByE3VHv9xDyGXZc4nsRUSkZiwY70AywmE3m6cAsm3s+CNFbcqpmEf6BtZKeL4KdTfsFMNuMg7u0f+GTOIKeXSc3Di1sm7NWeZExuQfiLppE/sDH4PeM4o/r9cPf8AIgrblOM4cMNTGDCgKOLMaqeZbbiMM/ZsgXEkMXOn8GBV+psPPi3o65ffN8/wA14K4HzizLSQv0yKHUbJ4udRdosVH5SS9AAHiBTqg3CFqZ9zyvptjmLCWi1cAQSPhVJWEUazleZQYTdgMMKskcJ+JnMDns6X/H3kREbZiz/BFJfWzart3ghIiNNzAUFcfMvrUq5Hev7eCOAGpsheWw6NUB+ieb4pDZzOUU+PJLEm8s4dxpxnyFqMgJt7l3+D1WSCEDCny7U+10tZ63NOwbmyOEfnNoF1IHnLdaYGVt6Di0lRvds+iTICAG8y/FUwfZbO9SPcobghFYStPwiEb8RasObXMhhvtVUyCo3PBHqsycFKvtE8s2/k1jMvn20UEE52kpXTGTPBqbwXBzWzyq8gCUeAc2XEp9npX+lxwYTQ+PQodZ/0pz7jhs2XgbkISwQ1fW5gnaSuw6Dtm3TJoQu8rMJ3RkWRJfVCK7qbo5QFBbN2CQO2+gzS9xFb0CDFnVdsXeN6R9+5lAArJKgHfIR2Lr2yIIWEDhiYbEhTdf6YvaAX9MACgfATY7W1GVJCUn1JlPBcCHM/86T3RMnFvcvMUjJEItsfDquv5FB8e2gpno/KOlu5LhES6oP7mEebKoOYg3nzP86tD9CSg0Ydws
 t7lIjd1r
 C9WFm6cGKXEGTtofMUZXvSa7DWjaW4pbMeMyEZJZaBtyfTRRDSQjKZiDxjQ7rDvFpGbBwdolr4TTx5I5gKKXgu5cFSNTVt2S0pG6u0BxwOfYfz4ZnZVqPQRao4GmOn2VT7pKlLZJAVw/9/7g0zs9+aClWcHedAIAsODT7GGstpsI7xxpI+i5fF5wq0a/lNYXgpwfElMChPCTwa+wXmqrxyboK0DmRFgQvdnmr/nrBbRVgs6OIyhv4Gx3lE7F2yLFNBRoBRo3vt3LXDE4lzfTTLMGOUj3bdDpLucPTGp9SiGPnwgOunhQeN2kuDCdJ8sBh/RCf9dS0GeGYK5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 14:04 +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 10:58, Yeoreum Yun wrote:
> > Hi Rik,
> >=20
> > > On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> > > > This is preparatory patch to make gup_fast_pte_range()
> > > > batchable.
> > > >=20
> > > > Introduce gup_unshared_pages() to count consecutive pages
> > > > within a
> > > > folio
> > > > that do not require unsharing, and use it to implement
> > > > gup_must_unshare().
> > > >=20
> > > Could gup_exclusive_pages() be a better name?
> >=20
> > Yes. This seems much better for me. I'll change it in next-spin.
>=20
> Not quite the right semantics. For pagecache folios we simply don't
> need
> unsharing in MAP_SHARED VMAs. That does not imply that these are
> exclusive.
>=20
> So it's all about "number of pages that don't need unsharing".
>=20
gup_no_unshare_len() ?

a little awkward sounding, but it describes
what it's doing?


--=20
All Rights Reversed.

