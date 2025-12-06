Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5732DD3ABE0
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 02:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368676B00BD; Fri,  5 Dec 2025 21:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319656B00BE; Fri,  5 Dec 2025 21:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208476B00BF; Fri,  5 Dec 2025 21:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D81F6B00BD
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:26:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72938C03E6
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:26:40 +0000 (UTC)
X-FDA: 84187457760.30.177BA6C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1806A0003
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:26:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=M7+aYeR7;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764987998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YraZ21sr3pEy95zok5HC/hyqaMU3Jyx/mXxfjHFQH0=;
	b=vbV08uVyRoJGQ4T9R+NUVL8Piemg5nZEe213/6cdLiWHj2RbxzIhxXVRutgsdAFv7vRCZo
	xmIAvH9l9PR/qyFS4TTqnokjnvlTGmTDOr+jIKiVIfvIO1maAxQK6c2iFegZTk4gjTqPQZ
	H59z5rwpSdN5N9MDpqjAibRg6wyYpgk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=M7+aYeR7;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764987998; a=rsa-sha256;
	cv=none;
	b=eb9M5ZY1ARpeKZ568hrNxswgen/qbYnlxeyOWMfrpqm80fsMrlOz/jYD+Mf7V2rzDo8ySw
	HNDTy7RlszkQVQOqJJyC2n7prvta4rHzrS4M1bNZxv5899c19LPkuqked3ghQRv0pDAM2x
	lAmMGM2byKNFC92PFMnaxyZkJuq34x0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4YraZ21sr3pEy95zok5HC/hyqaMU3Jyx/mXxfjHFQH0=; b=M7+aYeR7DGAortFobUdduH7USL
	LqdGydqLAv5JwVi6Z45lZw6tnqK6pZpUfN2NQ1TdRS9BDRO7ZJeff9FPq0dxgDtAt1d9TiZkh3TGL
	u6y/fMcbZi/MceBbe+isJywhaPpBCK/S+1Mqx+GB3qf1iE4AtxTaqWlNluJq4nbAtk2n1ONmZuAL6
	mWNsGo3ebZIJfkUX4UpMcaJjgGHUP5BMIOphaokkON24yOu9PUxA4uxAbsABd4wdcQbs9IZXt/41p
	TotVDCa9I4va5CrG2V5d4Yk/Pm3kcEm89iCBYnwB1aiGX4i55xbx4mun1YvgielcqcAy039yAekuX
	An+kvVsQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vRhzu-000000005aL-3EMY;
	Fri, 05 Dec 2025 21:26:11 -0500
Message-ID: <bf3c6fc4118c5d63b87ace078d94848b19aa16d2.camel@surriel.com>
Subject: Re: [PATCH v1 2/4] mm/hugetlb: fix two comments related to
 huge_pmd_unshare()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, Will Deacon
 <will@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,  Peter
 Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Muchun Song
 <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes	
 <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn	
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Harry Yoo	
 <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>, Prakash
 Sangappa <prakash.sangappa@oracle.com>, Nadav Amit <nadav.amit@gmail.com>,
 Liu Shixin	 <liushixin2@huawei.com>
Date: Fri, 05 Dec 2025 21:26:11 -0500
In-Reply-To: <20251205213558.2980480-3-david@kernel.org>
References: <20251205213558.2980480-1-david@kernel.org>
	 <20251205213558.2980480-3-david@kernel.org>
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
X-Stat-Signature: kt77hw4j1n1yjuqdsx6a5ifcsetyrygp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1806A0003
X-HE-Tag: 1764987998-776572
X-HE-Meta: U2FsdGVkX18/g5daPZ7t+cBSgCiu3XFM1J8HZLFmItQzV/rk05MCKfDB/hcQg5XUS5A0jgpLSCpV3LFhbFGA5o0/iHV09Xz22UFt7bRufBpU/gUF0rEpX6FkPndE9bO1e7udw76oQsLmYfiRbDkJEXsW+hp3+rYs/5PFL468+/qEjY8e5xxgMMwTWiUQe4AZvEILws1budoS9BCpvPk6/Dtb1imQVo3xp6ZkrTka9wrQJySmoYRnbDDJRL3XFlxtlXB4UZgsD6TNWWS+S8hGNEmsYrUquRSroO+fuvvZ/h/8X4d5OC75yEARA1cfSLs3TV35nv4j0seN1HBDuWWXsmvwbRF+O86INdbhUdMjXHgGd7XJ+0tXycVxOT6PSZQnLMMA7ndw4lSnq1g7E7ihPPXzPGYdCHlWX34kMUfVWG8IGfe4uue0G2Z/9s3MucKfjm0+l6oKLcV9MrFoTWONfvYP1v3oRTWUg83gfUawE+tkvuzSwZPUgxNwEkCobVSR+jeTmn6sin5/1hvU2BkqKTbnKeIFADfbuK4OKlNh+6XpKtZcT7TUKY9LpkJ6+Y8rVZJkMtbvUaUBVvwV4GQkDug5nu81cQ1zRgoLuXiFnMP7khDLg4ASGSgwR78ULDDq5QiNcNDxF6MCGLawMdPqTu5ewNMgfmj9wjaJKxQgg+Fwipib4HaDUG2w3aw9U22YQtyeLKpd7OT4jtvyj0l35pcoKfy0l4BOPUCQME520NLMYLUAOd9FEsExc1z5G2m4v2JXisyFi5P5S99rZP43UczkBQmdyxboWWuNq1ePVetePA556yspQUNXx5cVWftWD+pjOqUQibU4EVqGDBOwY6cBNhDLsSTtP1BnfzZpzVGvePK5DOmUz/MRK5h7n1teDFiLsMRPuW7BCvmSIhHooHKIvxVWMlLER7j9opAt2YGeYKl/HRUKAbKu2uEOQyAvaxNiSOIa2K9WgJh95E5
 lu5VEJuK
 Jf9W7WmfnihkF9Mu4bRBI0Eww3wiqjmFzYgYATFSzQPVhdT6yHJNNG7ZUr4e4Z8iKbILktSPXhiPXweHZ30Hvwtzw6rIdR6KAdMLNH2qhkhzlvmBNuD5kR1I6glkRysbQCPf88HaJIoGRoA9wbMUuKohK66DwIdOUcDDQkRgRgXqxpA/yEKVg+EcH7NInCY88G9WbY8tl85Tdu+ve0s3kQViqHQeb4CfxiRp5PGj0h3KwFRJF/O5S2rZH4BncGfTskQ78Nwx8F5sEMYIGztd98yjhWK8Qctr7sIE+u+5unkF/VAQJYmW/8ijpVZMQMa9+ZPaygXbEHFxFnGp2GH7Yaet/oJnMb0+mrtM6iQ16zXApuUCr9ZHyo50VrSpJ91m9kR+HogbNsXS++JNjV+wRz1az5RhAeR9Oc7KcxOcEEG4Md3ThdUZi5HCxPAESWIpc/YPk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-12-05 at 22:35 +0100, David Hildenbrand (Red Hat) wrote:
>=20
> So let's simplify the comments a bit.
>=20
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared
> count")
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

