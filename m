Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA536CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0516B0088; Wed,  7 Oct 2026 06:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851206B008C; Wed,  7 Oct 2026 06:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767A16B0092; Wed,  7 Oct 2026 06:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6716B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:47:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6E5F140171
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:47:33 +0000 (UTC)
X-FDA: 85295503986.27.4477BF1
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id E801C14000A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:47:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ZFU0+l i";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791370052;
	b=AI6wlHf04fhOh0llUS3jYBPKv3Zr0TelTdD4v/VEVwox25vE3J5Fikk1QnH1DZokqHSWQ0
	uwEH839tiWkgn6TxjrUkcoKkJPU+Ej+5kOL5r4UCPolbkwI0w8SCJNKFqr3URuTrqvviJM
	i0gyRrNjU/ATGyzj9ZRtCGr5NkCyl7g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ZFU0+l i";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791370052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHWw+UmZtYdvqxe4hUGh5SBBbAD7g60VuTJC0Vf5JM8=;
	b=ngIitTSER2rdhmz7ZIV91roGdJvPq4sL+qBY4L2u6e7TSOVlhLruS2YYlDF0flz0hsdUGs
	e5XSmaycNhhrm4AnGshtDGwYtK9hrRbQMqBXAzd41VWqs8yAqyJL/vFPuevO22Unyf7jh6
	fnaaxjc3GOAKN0k0cHi5u4Rs6aE8BEc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=eHWw+UmZtYdvqxe4hUGh5SBBbAD7g60VuTJC0Vf5JM8=; b=ZFU0+l
	i8Rtyg1iPkyPedc1z1baeYcAfaxOHKohenBGWw0OQFG6eHvnzFmHoaZyFuyjsXY/GQZiXjjZdSbcx
	1bz56Xnn17VBuRB0BJHM5TH6mcFi3z6NMXdrdaAdJmEj0ttHXIB1FbmYgHGrg7qis12GCiUDVm0XY
	78yJ7Gwmk0VMss/4DgyCrQ2Fjv+6XFwEFylNsNiYp+3GAvwAEnSc0a/DgYvMVpVMmNgrr8CJxfIGB
	CMxHfYAQvEU5vukKRlpLFsXK0PmkYxiiGTlDn3SaF71h8QpRXe5MF5Vr5rv507DlBuAh6b4O7g6To
	MQhODRmKczxDx8USwf0rmuPshdZA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEPAz-0000000B6vR-0oEP;
	Wed, 07 Oct 2026 10:47:09 +0000
Message-ID: <7dd4ec994502233cdc09fe5c4369adc89168d738.camel@surriel.com>
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
From: Rik van Riel <riel@surriel.com>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>, Andrew Morton
	 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Aristeu Rozanski	 <aris@ruivo.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 	linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2026 06:47:06 -0400
In-Reply-To: <20260917083747.786-1-aa9736195201@gmail.com>
References: <20260917083747.786-1-aa9736195201@gmail.com>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E801C14000A
X-Stat-Signature: ec1ckr1qdtazwegyqe9ys7b68e6aub6d
X-HE-Tag: 1791370051-115794
X-HE-Meta: U2FsdGVkX194yLmDAZ+cAtv3m9qrl921X302engdw1j8biiLG8pEyKZXtpOiPsQQuNsQk1O6Nnd6+BN+TmhoUOCre/QQOp4LNwE+Gg1cep4oCbK7T7w14BlLjiBnC0Nma2eSAOWdsGfLnCzNyInrbn7koeFFpY4ZyCo25ycMxINlifnhDhemltEBdD+7bL/FZAzr7ksttS1dE8uRsjr9Ai3/vX+H2tOFjqI/G0UCBMXEVCXK6sdsjjQuunbtRi6ttYgjMTer1wKyAupZPCdAW5kFcvPSnbE3Elw28pfJlz8vxwJEyh37G3E+F4eHyWNZfhojCkfv1rbnwMlIVUcNh0dur2y+518Dl41ZbobytEUDRuRAX8WFyXu1W91gf0bq0Oxm5CSBTBWRmlPAaPKBnxbLvzNYyuln3hW07VwecGXgXXPs4Ksn0i7I7xTuX3Ob5kU+LVDRz5fUr6l2JQo1Sf6l5cPMEBRZAntxUuAcPynkNSmb+KVD2ZPalzQSa0S6byxs0e42dOvjjEh7OmP0do2kW2APGtz7NIgQloPlrveWP0AtR1qC1hQqI7lIkq2oSGy5HusdBGDaHTu5oqt9VwNPz+o6vvvxP+Vp7pzWD0+cKTSqWCBR+gP1fpjUjLLyGTXFrjQir3gLXhKjFLlle5qN/tsbMd7jsUZ2zZbMItO8XisYSsY7ScB9f9ynJhZTHo996zOr4SxdEhpvwMkPap+A/InUky3SOYStxxUcsOlljHrzfYuiei5X5CKI88BJHy4hPJIKRnqXEHf8AZhSkyDhMg/eU4S7RUhfLalPmRrvzVACjM49GKjneqAxVO2f2QATszFrsYiI6JcQMLqUhR+F5iqzN9ytFqmApSFNyflSBnv0cryoqtvBR5sFdTHCwOHfsT9EAZ3VJEoZaVZQpJEaD1wsEJZZXtVg2O2aVPNG/h5rRKWESCpZMSS5MJZtZ0CJKYm9cwenibshDOM
 kPukkZ2h
 Bzoh1bpBfiz+XBuzKPjeyqUuBOMnVEvGdxbxxvwu45BD6GG1LqVmSw0xCrQaIRwHVrLNfanlAUKHnfg8nyJiBkGMFoxyy4sWGcTsJA7tWFf5imr4/mD+3IvuvpoDRC8Vo+VkiHggsuufOUHI472LrDrD47z9lfpRovZwVbJIQLjMXhpjJRgiSRKAmjzSe559/Qb/3PGip48dPY0t2OW/oD9Mp2Isx1B3gfusnERL1gX8C+F8lAc853g5Hu4b8zumT71fHv5h5Bt4Du+wQYoGaxqWMX7W+x7DWfTfzXgZRXsEb/63XCDXOK17SO6MWbccLFymegSTh/fI+m2GkPjEqRzz4rUguzOOII+IKMAh+yfwjeBCxRg66EXhXgNt1urpHRAyDza5B8eDcrLzv6z+kv6AA2j3xaYfwBTU/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-17 at 16:37 +0800, Yuan-Hao Hsu wrote:
> GUP-fast grabs a PTE-mapped large folio one page at a time.=C2=A0 Every
> PTE
> costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
> atomic, a full barrier and a node stat update for FOLL_PIN), a
> gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB
> mTHP
> pays sixteen of each and a PTE-mapped 2 MB THP pays 512.=C2=A0 The PMD an=
d
> PUD leaf paths already take the whole range with one
> try_grab_folio_fast() call, and the slow path is getting the same
> treatment for PTEs in Rik's follow_page_mask() series.
>=20

> fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
> buffer in 64 kB mTHP, median of 15 five-second runs:
>=20
> =C2=A0 bs=3D1M psync=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 126.2/125.6 GB/s=C2=A0 ->=C2=
=A0 220.6 GB/s
> =C2=A0 bs=3D1M io_uring, iodepth 16=C2=A0=C2=A0 71.2/71.6 GB/s=C2=A0=C2=
=A0 ->=C2=A0 112.1 GB/s
> =C2=A0 bs=3D64k io_uring, iodepth 16=C2=A0 50.2/50.7 GB/s=C2=A0=C2=A0 ->=
=C2=A0=C2=A0 60.1 GB/s
>=20
That's huge! Nice.

>=20
> +static unsigned int gup_fast_pte_batch(struct folio *folio,
> +		struct page *page, pmd_t pmd, pmd_t *pmdp, pte_t
> *ptep,
> +		pte_t pte, unsigned int flags, unsigned int max_nr,
> +		struct page **pages)
> +{
> +	unsigned int nr, i;
> +
> +	if (max_nr =3D=3D 1)
> +		return 1;
> +
> +	/*
> +	 * The reference on @folio keeps folio_nr_pages() stable.=C2=A0
> The PTEs
> +	 * are read without the PTL, hence FPB_LOCKLESS.
> +	 */
> +	nr =3D folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr,
> +				=C2=A0=C2=A0 FPB_RESPECT_WRITE |
> FPB_LOCKLESS);
>=20
...
> +	if (try_grab_folio(folio, nr - 1, flags))
> +		return 1;
>=20

Since this is lockless, the PTEs could change under
us between when we walk them in folio_pte_batch_flags()
and the batched try_grab_folio().

Is that race condition safe, or do we need to re-check
afterward that:
1) the ptes still point at the same folio, and/or
2) the folio still spans the entire range, and was
   not split before we grabbed the refcount?

The equivalent changes to GUP do not need that check,
because that all happens under the pte_lock:

https://lore.kernel.org/all/20260811025157.1632867-1-riel@surriel.com/

--=20
All Rights Reversed.

