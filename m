Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B473D606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=LjleV6k/
Received: by kanga.kvack.org (Postfix)
	id D68356B05B1; Tue, 10 Nov 2026 00:46:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40376B05B2; Tue, 10 Nov 2026 00:46:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F606B05B4; Tue, 10 Nov 2026 00:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A26876B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:46:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4412F140880
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:46:33 +0000 (UTC)
X-FDA: 85418124666.08.6384857
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 968E080006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:46:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="LjleV6 k";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuQsoR9tPJYej403khjA69eF9BxXmLtVailVY3tVfCg=;
	b=a8SpYt/GFdnPuH4ct1XyFYwwmFWGdGrKldC0DvNWvbkcXQ6+3yxem9ifP6pfv+rkMfc5H1
	AeCoWFceqDK4UbCO2W8nJWOXyXiswKmnkOSQga8iS+T+nFchkvoaX44kHxbzREG0KvT4Vx
	d253WGsODF5KOxS89gNK3JKrHq9i8eo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289591;
	b=z4XQv3ygAlzv0ThowH4k7v4vdWoqLXMj823nrtAic5T9RWbxlp/qx+cvlKnnYYTArjKAEc
	wmIE284Adlj3qQ5r6rn9dxtMUYZ7hiXgfSK9JyGyGjamLO4JpcPR2hAp+zgXDVXVL0mWAh
	k+TCYG+MAJ0Onnw8XZsDtlmUkqnA6j8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="LjleV6 k";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=NuQsoR9tPJYej403khjA69eF9BxXmLtVailVY3tVfCg=; b=LjleV6
	k/zqdb6koxxCgHCqclYvvqJpWG1UgnUGN15BNd92fM0iLdISwY/VedwqOmy7YsJiw+0xzwINxD+jy
	FYJB8Zv8wiFH5lkZRukjgYCacMqYcvC3Yj3/PF3ShA/GSgPeLtt7qEom+S+wwDveA73u6EN2+xUjd
	yJKLN8TSeat53uY0455CLmmMAUwmk7T0zFAKaaaLWDEU1pN+ojyPMIrmaqjhXOIsWQ/yvBLgtMuIr
	tAnliJnnGBwrPFTr/+3YEMvRg42x8jN1psHt66b5q4QBCjlCfeHLFMihBOGGOKRLepbOtMN81/RiT
	sutvg3AcnFunTRVaWUwhe5vbXTiw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xQegc-00000003X53-1GHF;
	Tue, 10 Nov 2026 05:46:26 +0000
Message-ID: <e370aab7e1b158ded7be0c21d9c79ddf7c4397b1.camel@surriel.com>
Subject: Re: [PATCH v3 6/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
From: Rik van Riel <riel@surriel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand	 <david@kernel.org>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Date: Tue, 10 Nov 2026 00:46:25 -0500
In-Reply-To: <20261109-refactor_gup_fast-v3-6-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-6-2aaef02df0e1@arm.com>
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
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8h6yostt9big55mrp9tx7mncqcniptud
X-Rspamd-Queue-Id: 968E080006
X-Rspam-User: 
X-HE-Tag: 1794289591-504094
X-HE-Meta: U2FsdGVkX182lPxOrVY8WNEP74Lu6hnyRLatmvMXpnbatUGoGpQ1tTaxkU40lVbo8PxkUK767GlgTms9XZvtFtQy/uHMl2RERxZi7HEKVjKxqBzNcMFQLqkpSWBknEQftLe8nBQyAQZc7zz8IvT2fW9/so6mnf6lRXIiPMKnRkjbRXGyB1krXXPb3/fWYwqvi6+dqEKITOX+r+EHRQ6w9DrZLqfCieYwuk2mUeYIzn6jrj92wWG4cQxY4XmII5AlZ5L5h9pWZXvHFk44AgS6OGgjMCHv8LP2As63hNTMGq31mZP+yehRw8joo6xO81Jyy838RsQnK/JV87gG1QB/2gApaV9+ogD33onRaFx5Dlh/sdzXkfcSulT1sf5p/8Ckn8wLW3jo6AkhA2Q4wtrzlIY6N6xRPt+WrJNOKKhjCG2bb+jCSTH5aysBY+tpeNxHuchTnRIiGG5YOgZTJaoJuU9mcopHOSlwBW/KaLNEgbFKbuL8FA8x2kRfvKbi7L521Krdsr7vmVV/p9QCROAgvAYnITMhQliHps0YXRkXSzaV9tBlsJwyYTlao7wVRhaeTtBV9MFZQxGriMn6GXlJZ81Kz7yZcVGg4IpPfn0RON1yRfeDQkyTBfWzIj/wACduJXLwwu84Fgh57h0xdIFErVzVCjcEvcRqq5HP/tr5LDZ+qqSIA36s1Xb2jwc/wpNgZCHmPiNijj+CWS8OC/QPrXIAkWPxzDR77+WJIfXe4pSLnS/IzpRMaCtohNjsplaOi5+S45MGQ4mmXQPGDW13om8BpDqfVzGkG74SHCjf4UbIAob/+6G33TrVib3uIm0Fti4xemKE6hNozwzK+IeJC4hNY7clUVUfMTMxP5FCFRMX12XJ4sknrr+GFnhFLmidIPRwaHMjQaWwny2tdwYEdRhlsQugPgGWVXKy5+OUhqXgt/wVJOblUdMWhNW3ECAcPDnDT2h5quTuu4JLE9p
 2uj5ZZpD
 ItTQZotOrL8ei0xvoOk2+Y+hJ0eLt93sLyhr9c9rN5OhfSiS2q9xvuc+DWAMMY377fCgj6eCIjHyDIwFA8z+sl7RKEx0Qwz5polkQWpPFQJw94s4U6VlInfMdz8fm/dvSnRnC7rBRONpOhcFavoa9uq2tydFVMA4urMVcivAj9vJRh/PNHJ3GI4HcVQNa1of5TG15hix05uOh+LgBQy8B43RwG/v/xv3aExxudDuzQ+nrKQmGgzZrKPvpdt3Dx+HthJbyFIPzTe6NlZ/a+KidzDF8sTDvdRV8SfZPerpALcdtY7HxjeHBuzan4ab62O7AjrkkdzWohK+Gzf1QlKEtMHjGMcxfO8OPFkoKfqI5Jfn201EDUd6mcwyB6SgBC6Qv9XAR106/F7kZtOm/6ycJqtnZEbfiv7/1MWQ7cQ8UdFQpHTY4IhqOL3X7f6ypHT51HcVIqgoRfV30gETNM0MancIiyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> GUP-fast grabs a PTE-mapped large folio one page at a time.=C2=A0 Every
> PTE
> costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
> atomic, a full barrier and a node stat update for FOLL_PIN), a
> gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB
> mTHP
> pays sixteen of each and a PTE-mapped 2 MB THP pays 512.
>=20
> Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>


Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

