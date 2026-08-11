Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D8A9C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A9A6B007B; Mon, 10 Aug 2026 23:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272626B008A; Mon, 10 Aug 2026 23:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B07B6B008C; Mon, 10 Aug 2026 23:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFE736B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:49:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 608A01A0336
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:49:46 +0000 (UTC)
X-FDA: 85087609572.04.0F39FC3
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id CEEB01A0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:49:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OFwNOTRM;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786420184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HW3ljMdDkgUv1pkjZ70wXHJIMtblhGmLTYZIquDiu0Q=;
	b=GXqqXnq/DbwmOlwm38IhrXpaPj8SwZfX004/Ko7+wOyff36Rn8T6O4vFs7uorOdDa53FSE
	LEIzstReFzMT3JEMubiWTAHzKDa4H5jeY+NQ5B78iFiuV3/FsCXJ00r+YJNpqXlKZu0eO0
	uRX8MWL799cvO2dp+ea+XI5p7La7Qmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786420184;
	b=74u6UoNiYXXYfUlYkCjbuWmq/pJr/Q3/P8GTBnp7wGNpD3TjEZWyaniuis1gCyCk5VVv4d
	Yx0JqU6H3abW0FX6YFoLPOblIx1ZcW+9TahEt+kjpX6EvObN5LmT95pSdfY+4VCtTSrp0U
	wPVjwH5R2g8mVSbPAvhMG69z0ro8mdo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OFwNOTRM;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HW3ljMdDkgUv1pkjZ70wXHJIMtblhGmLTYZIquDiu0Q=; b=OFwNOTRMOyjs4QUS7/ZcavY3W6
	QlN5oyjXBul0J155btHf5kU4SSlDLpi10hp3Lgfohi4mB+eQ3d5lBQBs4ro5eaEnfTCMjWA5iBNKq
	n2PZCGhyUoefCSXHxlmXgN6SAWiFgvJus4q7l/Ef9xFfTijNhvrLVhknGiHpk2INt2hMmAlAX45lv
	bdcY7mGhSjFeP6HECJQtZUe7sysGX985QgLut42PyQr5Yj6qD5YMNK4632QhuRxd3BZbSqoeaBDsK
	iBvbn8KwGrQOHQX542GGq17HZ+NF2bhMnfx0eckEY5qPNn3kLZg8M7ORhK2p+vf5jUB64v3zBjgX/
	zJqvuwRg==;
Received: from [96.67.55.146]
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtdUB-000000000f6-2KzG;
	Mon, 10 Aug 2026 23:49:07 -0400
Message-ID: <007c8bf2717346bdba791e1a5079f4d0abad41f5.camel@surriel.com>
Subject: Re: [RFC v2 PATCH] mm/cma: don't release CMA pages still in use
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>, Chris Mason <clm@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Date: Mon, 10 Aug 2026 23:49:07 -0400
In-Reply-To: <50b1dadb-37f1-48a0-adf6-c6ff8b704582@kernel.org>
References: <20260810122737.030f8452@fangorn>
	 <50b1dadb-37f1-48a0-adf6-c6ff8b704582@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CEEB01A0007
X-Stat-Signature: o1os3o81fekpxruq17x8au8bm1r8k4pb
X-Rspam-User: 
X-HE-Tag: 1786420184-716735
X-HE-Meta: U2FsdGVkX19Lw7Ltb7BPNHe2Y5U08O1Vi1WRbNZRa3yoKIh0iy/Ibb0X8QxFLOFPSdmhejuDyRXmTYW62IUiv8JhQDlWhOj2AFyxoIxztN26QsrJbUrOTX8v2zwn2VCvFMEZdpcv39SHMI7lmdLXM/2JMf6nm48Fbqx7KsyVKWp81tRsXRkYnjr4Q5OSAgodUh5b21qqzXarpj0qPaCka7iLledy9PA4mZgkmKat8s23n9Bd2uEWdOnCq9OX3P72OWthRVistJ0CNEB6CM4Q8cEKfTkbG9NrDROS4XlLM2xCb5kY0UHd+hOMn2IEjrPUq3oQkgGpAKTjGiMk6cNvPFiD8DF3J9/2iKdwCCoRafqjnjkfhPg+wqUo9fXtLTuBKD38Q3yx7014c8iBthgTKL63RnjZVTkldlztwBnc9Vs9C162cEdrky7zCH5bX8p/lw7XSWtCvLL3bLJGyRsHX1lLKRLvjpzVICvbDfqR+QzwUBa6QGu4A+fbU4IQ4jqWHMNvegwe+iL6/rllhO5ja8vatMgob60/3hUFoRMR1WBHKKmLi38e5gR5n5EBxaFadL6BhOl4pxCqVw6p1HhDu633eGWAro4kzO2WdFkYGLopgMTsgYgA9H1sbB1BMWugrn3gzOcNt6RcIHzvpstVFmBDA9X6fw/LqtIZNa6QidvPKQZUW2YK8XvjUuf0rK0v9BOL9foYBhmQSwoKDTyfWJYqDrR3e5Ng0TIadHemehHlvvXhKP/aAOUgbq4dUBMO8kIfKuQQF/rmAFL6SGhfEPN/9MmD4GNko7N9o2j0DKCplYWggkbbMD+UAgEHE6s6p9+y3vcC9BWhEGjJ1CsHjQSK806Zc9TmH6KnVqsKplOzYqN6rVmNm/7ETCtc3vULdidS/SRmEPF0Mb9raqk5GoHVLRg5Hb41kpgi4oDoTHlClurGf1RhkW0/9dZNiTNkw54lSG7qk6AqbF24MXd
 76ZxL6WH
 uVIWHGYf1Lg98khmU74t6NWX7OQtuJnASq5w8oGb3vYEckoq2gEP8y7orsYbK40Lo8lCsQ1cSTmygVSLZAoqeYEkTw/GLudtjAq1r2GJ++9pYp7pv4YC5KBWhFBa/k/F3A9AffgCDPcZG8u90Qb4GxGK1nAeuqH9hH7cUqh5lPznS+MOjASzHFCvSzKl5vveCEomRSoOzblXpDfpNgHmeN276Qfu+I6zbMSDN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-08-10 at 20:53 +0200, David Hildenbrand (Arm) wrote:
> On 8/10/26 18:27, Rik van Riel wrote:
> > When a driver calls dma_free_contiguous() before quiescing DMA, the
> > page still has a reference from the device. put_page_testzero()
> > there
> > returns false, WARN fires, but the code proceeds to
> > free_contig_frozen_range() putting a live page onto buddy and
> > clearing
> > the bitmap. Later cma_alloc() hands the same PFN to a new owner
> > while
> > the original holder still references it.
>=20
> Hm, it rather sounds like it's really the drivers job to quiescing
> DMA. Are you
> aware of an in-tree driver that can trigger this, and if so, how?
>=20
> Freeing memory through CMA, while the memory is still in use is
> problematic for
> CMA as you discovered :)

I agree the driver should not be doing that.=C2=A0

I do not know of any driver that currently does it, but
it has led to CVE-2025-37837 in the past, and there
appear to have been other cases of this issue happening.

> > +	WARN(skipped, "%lu pages are still in use!\n", skipped);
>=20
>=20
> We still issue a WARN, which itself is problematic. See "Do not WARN
> lightly" in
> Documentation/process/coding-style.rst.
>=20
> So it's either
>=20
> (a) This scenario is valid to be triggered. In that case, WARN is not
> appropriate.
>=20
> (b) This scenario is not valid to be triggered. In that case, this is
> not a fix.

If a driver does it with the current code, it can=C2=A0
cause free list corruption, with potential for
temporary data exposure, until the system crashes.

If we get rid of the free list corruption, it
can continue to be a WARN, since it will no longer
kill the system.

If we continue to corrupt the free list when this
happens, it should probably be a panic?

A simpler fix may be to not free any of the memory,
or the CMA address space, if there are still pages
in use at cma_release() time.

--=20
All Rights Reversed.

