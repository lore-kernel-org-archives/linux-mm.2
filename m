Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE594CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944376B0088; Wed,  7 Oct 2026 06:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDE46B008C; Wed,  7 Oct 2026 06:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7966D6B0092; Wed,  7 Oct 2026 06:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E23206B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:10:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6450AC0177
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:10:41 +0000 (UTC)
X-FDA: 85295411082.05.7CF65F2
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id B6C461C0007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:10:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="oMGUxy w";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791367838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7e69kFUwkZGJvCU9G8Z+9oS71uNrW8NRzXwhyF1TWDw=;
	b=OUlmzsfmI+1mAOj9zSNZSWnzS/NEtTq02WMrBjcvwGbxjdmp5FVjLT2xgRip549Jl6ABVh
	csR00eDWBtoxx4DIdlKmAiMI9GTfk3m5RYylo3UBvZ9DyF3OhgAJeqY7PJhHIMJfcewK7V
	4DsjR8sTfp9VPNCjNjavHqo/rUFf+3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791367838;
	b=4cYBH+4djIHVhMi78FZE5xdKeKTkgwToVNwBcyBJsgfbARaTN8lYwl07or8TwrC3Sh9S55
	/3e76fW2EGJii8jd6P0MteQLBlcmAV8yE4d/qNX7v2F7UwK9uXF9kEor9OX5FUUpcKq0Cu
	VJArRYifRJ+glCd1os4gSy1lUe8K3ZQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="oMGUxy w";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=7e69kFUwkZGJvCU9G8Z+9oS71uNrW8NRzXwhyF1TWDw=; b=oMGUxy
	wyLKL7FU/3mZQ2paX7J1caF6MGcfuGr0ryZoOJyqga/8K2AQNniwzYMTECAtjPD+oLE0cA5NYRvT4
	5/DsFor5W4dFU/+N/7MSdYu2ZyqGc4yPYy0jW2VHANUM1f05mhwTS/dAWRVLaL0kzyKo0Z3H+0UcZ
	ihNc1MipFUl+wabzzuJdRZjNx1fGPpXRyey2aagMz+4U6a9mwx3lK1I3wVmPGQOH2EHU85dpoERvq
	JlcQ21X96iXCGBW6A8HLjsfYjchJ3Er8uZxz4Hux7JUEZoq2KdApudvEexZFs/vt5gKrbtP+LA7EW
	U0CBadTtIzGSIk2jY4nEy0QxA4vQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEOZ1-0000000B68R-3Iey;
	Wed, 07 Oct 2026 10:07:55 +0000
Message-ID: <fca681e9e9af66c8bbc43a181409ef44a24d9250.camel@surriel.com>
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Yuan-Hao Hsu
	 <aa9736195201@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Aristeu Rozanski	 <aris@ruivo.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 	linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2026 06:07:55 -0400
In-Reply-To: <f8f6d553-d818-4cc6-a1a1-a9c9149a17e9@kernel.org>
References: <20260917083747.786-1-aa9736195201@gmail.com>
	 <f8f6d553-d818-4cc6-a1a1-a9c9149a17e9@kernel.org>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6C461C0007
X-Rspam-User: 
X-Stat-Signature: sjps7jg8r4n4yzabnksszxpceui18hiu
X-HE-Tag: 1791367838-7718
X-HE-Meta: U2FsdGVkX1/xHWvsI78plB1QtFxi/5Bd42igyEhvZVoYC468zckXQjDvTYGQbLk1y0MSpgCdRAmuEsoXnr4eVJATrkj8kbIeWn5YpJ3uPm8SpAmxOMAkYZgbVG2jND2AjwfHKhZIGHNXOYWgLiIn7+gaYJsdfF5WB+hGpeZNLBAqzAQgbrfRdM1EWJO1jZZrgo29qNbVBG2luziL2rG6vJiyvHDuoJcpLr8/Ty6Y2q8vXOc6hkyxtzla74gvFVkXGuzOfd/ON9nBpoDDXBq4h1nPy6ibuOutV3BL391Wy/T58aBBZurPCAIwgWeQvjc4QNVCyFg2Z+nqARuG8DiP/WUevw10OHVI3EgcDuObnYbrGQ/jNXn3ChdUJQSziEBXjVcwF9XrHPaLfoTbGMGZLEb1OYxiO3EOpiv/K8DMrusg/xMauRFLP2WUMZBgN9CiTra/JeBHQiWrF5z2j2jfpLbUg/24p5RpJbP8Sp6sLiC6zMAbUfKyCRtmZhBOvBNlqw/92CFf7hHHWLg/KLCClqGGt3+2nd/ue0om9kaz/jDfUCI5yWMc4LXXdieeC1EVHKMMjrmkFatPgcALPIXr+5Fu28jJUzBQytJSCpTa4iRtMqENJMpcmHY9EWhZutOSM9/CBaBYphs+FoJdaqAgmtMk+/bKh26Q4lOHpQLszDUJdXV7Lx3+eTbaPypih4xiydmNcK0QSglExrRdKKABC48XuDSHEde72ONdh0jF+0OKnc8rZOjDsVBcUFIR57vDaiiaCgMp3A2CIwqffbUhuTCTjvXDLBNfk4xLzvhvtByxmjn2GsG7Vfy6+mD9GrfvkRv+UTq/kL6n6GEZm1uAHOQpfjhVzO9WyAFCT0gizCSd6jyjjqrQrPsJhfE62X2i6KDUtWtMumF7Y7V28ueGO0QJfqenZOnAiZKpVQv9j6WD4lNQslqWxOWhJhWoBSTgWc3Zvm7YLf2vPAjheek
 MwUxO+52
 lk12beSQNeu5RDgo7rEYUl2WkviyAePtrwmY/xAB/qM9UpQtxgYriJFDJ97Lfc+SzPIbJrCpqhvgf61pa9GQdjqNKCZLFYXqiNULGYITQUQjTxtoadHCkPYDifcTUkddFzylZMuGN3EMGcA2GhhE+7dCgZarZJj0Iz2RMXDxoX73Z9EEqqrAWwoc8gkDQdly/PXflJQQVSflHTmn6iVslcv2jCd1THUmWDJlM9Z7E0ocnYwt0+9+cXA5Y6y3vwBjwca9SLwQOhUKfjGkU45zQL/Jgon+BQZ/7ihSWSqYjZVXow9q7Dw9Z383T637yKQK4aoVt2TxOc6Jc8EE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-17 at 10:42 +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 10:37, Yuan-Hao Hsu wrote:
> > GUP-fast grabs a PTE-mapped large folio one page at a time.=C2=A0 Every
> > PTE
> > costs a try_grab_folio_fast() (a refcount cmpxchg, plus the
> > pincount
> > atomic, a full barrier and a node stat update for FOLL_PIN), a
> > gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB
> > mTHP
> > pays sixteen of each and a PTE-mapped 2 MB THP pays 512.=C2=A0 The PMD
> > and
> > PUD leaf paths already take the whole range with one
> > try_grab_folio_fast() call, and the slow path is getting the same
> > treatment for PTEs in Rik's follow_page_mask() series.
> >=20
> > IORING_REGISTER_BUFFERS of 1 GB, median of 15:
> >=20
> > =C2=A0 64 kB mTHP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 6179/5998 us=C2=A0 ->=C2=A0 1599 us
> > =C2=A0 1 MB mTHP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 5790/5801 us=C2=A0 ->=C2=A0=C2=A0 893 us
> > =C2=A0 4 kB pages=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 7173/6741 us=C2=A0 ->=C2=A0 6763 us
> >=20
>=20
> I think Rik was already working on this and sent some patches.
> Anyhow, there is
> quite some GUP review backlog I have t go through, so this will have
> to wait.

My patches are for the regular gup path, in
follow_pages_mask()

This is for the gup_fast path.

Unfortunately there is some nearly duplicated
code between them. Last I looked I did not
find any clear ways to merge them, but I
can take another look if you want.

--=20
All Rights Reversed.

