Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F248FC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5D06B008C; Tue, 28 Jul 2026 10:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76826B0093; Tue, 28 Jul 2026 10:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A546B0095; Tue, 28 Jul 2026 10:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5D66B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:31:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8359803DA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:31:14 +0000 (UTC)
X-FDA: 85038422868.08.8369550
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8938680002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:31:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kYp4Ln09;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785249073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4j0wskVBVDU60BDmXPyQxCAW0lR+mxtKp+75cckQtE=;
	b=LQWuBeZ7T9X0pryEOgoglE1Xr2678xlx0Yx7D1MkSNgdCpYr15/6kMhNi1OjsB+N+ZvRso
	W3dtqyKEbg2hJzSgWUdct26gGyn+vdUloMxOhKO17r9vapIEanMOeGAXEsSHMLKQBpqTus
	9YAbz/Llu/pUQrrQ4PMIuE6Oaj3A9nU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kYp4Ln09;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785249073;
	b=eMohY6aYwTSx//PFduY4Hox/X/h2IUZrqKE1nawyno1trAgUf1wmpPpZlwiHs+vOAt0Szb
	y68UFA0KXAVqt4kp7i+JMQueFqu5JgfmU4BNGPzPAuRq15NR4/xvFspMLq9Z5Gx9Fqc+Vs
	PULkR5gEz9PQnnV8MetM5ACFPE5sN38=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G4j0wskVBVDU60BDmXPyQxCAW0lR+mxtKp+75cckQtE=; b=kYp4Ln09krj9o74H5kxOhuFCfM
	acRS6uWF+8ihGec3OfRtmcLb0TRTVtd5TgPJduhNrIb6J3xP1kd2bWxr6NyY4QzJF3NVyZmu95Qh4
	EZH3KBB+ydlg9Oth6Ruu7v+RQq3Z6ahlV6+2RIxzszmmZCH7YVpyUdWDIZVpXJEs5X/UfTMQXHTxx
	s69nlzir1nLs+l09+rDnBTAYE4WhZiOth5tfKIaFzS1c4R07w5oBuyMU3dsfn+NPUMduMJPeq1LM7
	Tk7gWBclEk+y3Sgg5tCwsyAXUY67OEeM1rVn+Cj6/WI6wEt1ScIECkk2XOd/+rtObpEoUXo32/bYz
	DZhgNMBQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1woins-000000004CP-05pC;
	Tue, 28 Jul 2026 10:29:08 -0400
Message-ID: <6fc2148992dc9ec6226410a709c4b8eb9ae5d15c.camel@surriel.com>
Subject: Re: [PATCH RFC v4 04/12] mm/gup: let check_vma_flags() ignore
 selected VMA flags
From: Rik van Riel <riel@surriel.com>
To: John Hubbard <jhubbard@nvidia.com>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com, 
 Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Suren Baghdasaryan	 <surenb@google.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka	 <vbabka@kernel.org>, David
 Hildenbrand <david@kernel.org>, "Liam R. Howlett"	 <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko	 <mhocko@suse.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,  Matthew Wilcox
 <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>
Date: Tue, 28 Jul 2026 10:29:07 -0400
In-Reply-To: <510410af-dfb6-403a-a864-50afdeceb896@nvidia.com>
References: <20260724222934.1463812-1-riel@surriel.com>
	 <20260724222934.1463812-5-riel@surriel.com>
	 <510410af-dfb6-403a-a864-50afdeceb896@nvidia.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8938680002
X-Rspam-User: 
X-Stat-Signature: ko8xzfki8bdr693ia9x8en7k6n45o651
X-HE-Tag: 1785249071-91909
X-HE-Meta: U2FsdGVkX19mITezbOgtCBuZRfyEWFzw6EQmOD18d5u2p9LTjCqennWiiw2ZR5rM+RpO3YPvMGsSU3+5HV3W/yjGvuL/gjRlafNgnMPfaEhxYZahopBxGidksF/tiY6WUtfI4VPXo18Yfe133w8a+HO9+ujhO7grWv3jJa8NfqkHjh81bgv2vTQxTsUoMq6G7KH8bzPZG4tcfOPewjmzJxiDkmL5eoVMFTCBU2Z9BEC5JEM7BaJzTOrZMZRVbKjCTk3KfIzzpqQ1y2LTRYoCkqasl+HioSapLuVYzkbuaAnYpY2a7R9dgN/zrc1TxrwagQmzzFUVuGEm++0KJupd2KbBtaItysLtbwSiE44lyQVijJkNbStiSWvl2TCaPF5kx3y8Gt+zN9NiCd8MBKqKSFLf8sPhBXcVhf7JX8GSQ/WKtFfJFQoS3nBtxtCBwr0mqmxxAtPE8FMmVY/K66lovY2y28npJG71lHv0QrMqjlvSnd8MUdTXRB2MmsGdFLxelEYO6cHfiSPcoGblgxBhRBOA/Lb9ohXJAmfpP+FTxAXCnBViTg453dlVwGm2QE1maFW5IBpcvl6ira3jtioLZ5YFQIjMMtn9Rboszcg/5t/NPza7ZXs4jlS54vkVRP1ul351VEkUk6PUqx1BDXZvcbhHAImdARLKBgCYGucdV8EcHt5LFMShQRD52ft5pGU4W+vPNc5ThIvLzwgYaxw7sA5hylczK1WM3zDTnFLI2Fqb7m9OM7lolR8T+grKmkZAOtH6O+nuvUWE0DJ9gqFOtsLXc/ltXBrzcyKWRwuZTMW+tkQg6AGRZPw7N+Wj42ScPMipgHDqctnuuo2zW9HOSOx8bVVazjh4PS6oCkri7zR9jD/yBapSbYqqRJxppYHmj6TBJgmwfOTFkxvkkZ8iO5uaUJOfK2oce97ld7e8QhpSWBitX1UJydBdLDZ4pmc7SfhG5htZ9lNX71SmWB0
 x4NFYV41
 Y+ig8Bt41bBUpzVSv8nIkPrTqFpbQWHfU7HAnEVZFXl2YPOXTlL5kgd2AJ3wYI7DMQmhJ39d0hI02nC7UZ4M8hXAyy+2oqjn6VVYq0bFum3LECmdZhJ8NLn34ZdZelrgoyth0OkICiLJPk4poJfFucjDqz0f04ijbl5I78JktyB/IBw9Fl4YtVToBRE+elaZz3oof2/Q0go1wx+Ex2X3k5QoAnPl6IK4Dcfr0PX9ozmmaiCeXh521j6h9kVCX4qjr6ckUZufMObELAm5xmkS6rAaGXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-27 at 19:40 -0700, John Hubbard wrote:
>=20
> Perhaps it is best to replace the mask with a single-purpose internal
> GUP flag, such as FOLL_PFNMAP_COW, and apply it only to the
> special-mapping gate:
>=20
> 	if (vm_flags & (VM_IO | VM_PFNMAP) &&
> 	=C2=A0=C2=A0=C2=A0 (!(gup_flags & FOLL_PFNMAP_COW) ||
> 	=C2=A0=C2=A0=C2=A0=C2=A0 !(vm_flags & VM_PFNMAP)))
> 		return -EFAULT;
>=20
> This permits the later caller to examine a VM_PFNMAP mapping while
> keeping VM_IO-only mappings and every other VMA check unchanged.

Nice idea. I will implement that for v5!


--=20
All Rights Reversed.

