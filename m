Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18AD606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=id4TkeXo
Received: by kanga.kvack.org (Postfix)
	id 85A4E6B06F7; Thu, 19 Nov 2026 22:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4606B0712; Thu, 19 Nov 2026 22:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB656B0713; Thu, 19 Nov 2026 22:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43FE76B06F7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:04:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A08D9A0D2C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:04:18 +0000 (UTC)
X-FDA: 85454003796.17.545CCBC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE2AAC0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:04:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="id4Tke X";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795143856;
	b=NhoJprKZC0mSXyHUVITva4WqCLGBYb6A6asAvHTpmu8PwzqSr+rGxchK6OlcnZSaQ96UtC
	bceKRbTUoE813tazyoPjF1aI/ynNuiRpjyJUFkX8n+qMMonEtocfiPw1Zm3RGM9FfNz4hC
	uiDiYmvsoRH7bM1W0KdrLtCsLTIys64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795143856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fj1f9s84rqSArxiRYtZ9EY+vp9TA7GW6SELZM+VBUY=;
	b=7HnQkFiN8V0bJ/UJNmos1UxfJIZ+i9BW7JB2MiEOP1PxCVCVVOwq+WX+TULeJ8iaZbcWbK
	kgsrLcYPeqyZ+Mj97lANv8mvwm7a4yXkJ/Lo73893BgK6YHgPfeIrkggDjALoBpCx2KKgq
	DLolwNLuIU9AxrBpaNnO5rtquUNJh/0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="id4Tke X";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=3fj1f9s84rqSArxiRYtZ9EY+vp9TA7GW6SELZM+VBUY=; b=id4Tke
	XotKuwhNhtPXtJ8/mYlY5KR/HcjS64J1TJzz+ZbMG8NIfdaV0ytkPD4pTQ3WmttBUqs3dcPEuVAkt
	5qNpRPVA67DePP/jsW43zbl34s+m9y3Pw2F0UMBcZwc3gS3ASsXPsDOn7i0RTW1vQd3yfqUMV1jhg
	UZNKuFolBqTFoE/ASYUn0G3LWSZzdk646nlXEwwg+aoYYFWyIW8GphdoF1kSnnehnnn0oJIs6tP+8
	3Duc1PB3Q+y5vgmCa6uy9/ZXHij2sPrcvijjA8MIGEK8OYUTWSThTn/KeVpJG76Nfwitt3oqed1P4
	wRPmb9eT4mNUxwvgQzN+XxlbfPow==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xUEuy-00000005akT-2X5q;
	Fri, 20 Nov 2026 03:04:04 +0000
Message-ID: <89e41824f1371b5880029f264e19b5d0589ae22c.camel@surriel.com>
Subject: Re: [PATCH v5 5/8] mm/gup: break out gup_lookup_pte() helper
From: Rik van Riel <riel@surriel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand	
 <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Christoph Hellwig <hch@infradead.org>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>,  John Hubbard <jhubbard@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
Date: Thu, 19 Nov 2026 22:04:04 -0500
In-Reply-To: <avxXgTBaJkPN6XOh@gremlin>
References: <20261116210127.3837898-1-riel@surriel.com>
	 <20261116210127.3837898-6-riel@surriel.com> <avxXgTBaJkPN6XOh@gremlin>
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
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: g6588s5ngzfsoa4s87kfya9cihn3oogf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE2AAC0003
X-HE-Tag: 1795143855-475570
X-HE-Meta: U2FsdGVkX1/GEYvWnzuA61VjUc4A5EbansPNAIOEdhxUPWBkw3BhITffWL4IZ98vfYb0eB7cXS9I/suhK/9hgMt2xbthFuhhzty6dqkOOghvwnSaTGcZUEUxTng7jTahWsUo/Br+gOPQsV5PO6xyyDBOsno3F4OmgODokmuNccwxe/0u/TSD8ePf/4eSQxFvveJUVmtp71VDNSjfBVWVYXRTR1rJzX8D8Ee2z7GgDc0PK+vRo/7+YaZhbDtYWdeUXaG+3zIr8Ylv2XVwoF7h9Q3WazmoFLuY1fmb+FHQnxX+m9Q5mwtq+PZHCE/ih5WD+1e7DWWJEaDGAvavNlzf/OBMM15e8SB4Ku1nZzmXMEKHAYJ/TTf0DO0I5+zEWzSQYq7MVWQtQEluHL6Nhe21GigQ3DkpNjUfY38mWThIRiD7MERvj4LyGcQWcWeD6X72ZgW0DKWwhj8I0LxO5olUlr1U4Na4Jqnp/riWXMrZ2Ue/p8s08j+YPq38xAmg4C+yyDlZvpN5kjad1UaILxeG86TDC8MRhgMr5ZSSkOIhf96tQKzHqm8KzvFzq1k38tlba/pI+/pphWcKuVJ5UFAsWiXb8PgUwd0psak3ibKZYeEw63fsrvG/IkUtrhDoeFlWQEBaUTFIjvW1HcDjVSMNXnluG4H+doKtT4vQGfQBx4nBY9i1iI6PbM/yjGUxIk+WLwrm4EUPmxxYe47zzq6Zqr8TjnaGlAMPuph8jIUnd3jJuxt1OUJVPwW7pcw/s2XNKWincFx+IsbvVRkSl8rTtqPJJqBtLrGAMANFLfJCUpWyCp/1G3GEa460aVQLNIPgbXtZnrz9d0XIvLKsJ3pcGbQmGNGXh609j3U7WpOhO968QDR16wBTJsCxQhVz+EkA0jgjxKPLgTNEOiseOH2L3ZLB/WcqfR9pM8aJov7NOAI362IF6O58nqd2+gyropoAgaEQYZvue8t9JJ3NH+m
 Sl6JIH7L
 74+Pha7je9j3c7CZsksibql7jYBmlKF//8TyOu/BSRE5BLGus4tHAuWO54AOPzRPvyqP8/MNISuQ1Hk3SvQ+6WPLcCcrNGJqm8DMJlRyaPLXYN0isxuYTANkRELHAFYFPue0jxizChDGQKRBCuCTRf00lV53xqMDHKSIrtA5KJjK1MPcTiMJrBJCks6N8hb3gIGgO+e36kBymNhGPnGJdlE0bGNvSNS2w7OW6VYssatcMCJl1BacqCB9Iuh/+UfJOq/27+Uag+Eg9GQ2x/EjoRHKuPbrkXraMeER/cf99pScEq3YyQlBbN2b51EY2fxXxgb+gvfKucA8/iHIVw34Iefeqv6TvMBkanzf/bFp8wqT34g7P0BEIA2wGvmCx9VhneFd0sKKzNHRpTXLI0Sa0RYEk/yb4BdVm/lG/S892yeorz2dVolMF/AE6/qTC2phsELXpJHM/oLgho7ygIhoZfn09Zpf1Luz1ng8h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-17 at 13:48 +0000, Lorenzo Stoakes (ARM) wrote:
>=20
> > +		need_no_page_table =3D true;
>=20
> This is set true but not used anywhere? This is dead code no? Am I
> missing
> something?
>=20
> Patches should be incremental but adding completely useless locals
> incrementally
> seems silly?
>=20
> > +	}
> > +
> > =C2=A0	pte_unmap_unlock(ptep, ptl);
> > =C2=A0	return ret;
>=20
> I'm guessing you forgot to include the code that works with
> need_no_page_table here?

That code is in patch 7. The check isn't needed
yet in patch 5, and it got shuffled wrong during
some refactoring.

In v6 the need_no_page_table thing will be in
patch 7.

>=20
> 'need_no_page_table' isn't a great name either. Maybe is_none or
> something?
>=20
Maybe pte_is_none?

--=20
All Rights Reversed.

