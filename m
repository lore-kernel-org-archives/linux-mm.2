Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C26D3ABD5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 02:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D776B033C; Fri,  5 Dec 2025 21:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDF86B033D; Fri,  5 Dec 2025 21:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACFB6B033E; Fri,  5 Dec 2025 21:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02DA46B033C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:19:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1F981603B6
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:19:00 +0000 (UTC)
X-FDA: 84187438440.27.0E20EEE
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id E2531140006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:18:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=bdEcVnFr;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764987539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAiD+sW2byU1J2Xu/2qEmRZszPnNdC5pgRnrIbr+nS8=;
	b=TVcsdnLKCuccjK71PlFxC3GgvE4ee7MiKK0slW1NFVSyPdTV6VgI8IdoP9neLb7we2Gu2P
	8VLs0el2A4hq3rMKb4HUbOKFlmfTiTNe9RKKkN7u8sezRO+X6IKLPTsian80YzbX8055tj
	7sSkv7UoLH5v8Db4CuE0+2pP+OW4z+Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=bdEcVnFr;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764987539; a=rsa-sha256;
	cv=none;
	b=0ODQZrreNFrg2+IBH9B7ra1MaKpkqSgUv2YG5KFWDsHAWEEkRKsOVqWhvT9PZo3SbDxuum
	OVKhtqZVpr4dZWilGXj8UKnp+21kcwWxSC5cSYNJHQ6e/LZn564XS1r7J4KIanedxsgBCi
	jy+2OL1iSVFqlHKRasgfqMXRsOBkrXc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vAiD+sW2byU1J2Xu/2qEmRZszPnNdC5pgRnrIbr+nS8=; b=bdEcVnFr5FdsRzdBiToyXg4M6L
	9UzyFFjENZ0VvozJLjwVlq6h5vpBpkvllZJKjFbp3ZPsb3nWYR6IhOUjhUOFcSGKWpUWFzdxsfn0v
	5OLmjJCigQHm/jwbfIJFcokNEH34ciXvglrCyjP9S/i9MYk1we/KkcbPFo69OROB7r6RrLRGW3x9X
	Qa9KANlompuLXa0Xp2Dfe+QV0shTgOPqriL5/1difEYhYw1i6QpE9cVa7TfvvTI4+Vbhn2AwTE96U
	GPcVX0FQiuNMTav30l/h+blrNgufFSu4PhjkZBewKz4/6EsaW1z2I86OxHmQRps6Y+2A8MOou0Nmb
	QWWrYFtw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vRhs3-000000005W6-1y18;
	Fri, 05 Dec 2025 21:18:04 -0500
Message-ID: <414f56e94f641aff9bb3db2c4feac70997580d45.camel@surriel.com>
Subject: Re: [PATCH v1 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
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
 stable@vger.kernel.org,  Liu Shixin <liushixin2@huawei.com>
Date: Fri, 05 Dec 2025 21:18:04 -0500
In-Reply-To: <20251205213558.2980480-2-david@kernel.org>
References: <20251205213558.2980480-1-david@kernel.org>
	 <20251205213558.2980480-2-david@kernel.org>
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
X-Stat-Signature: 9pimrdcif3g74q9x9cunc6sf594c16ef
X-Rspamd-Queue-Id: E2531140006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764987538-736737
X-HE-Meta: U2FsdGVkX1+mfLx4IXvZUQ3uJFtqxIoAcgWmy6TFpUSS4Egp6UQ1v6uA+GWjaddEZ9icfo0OdbCAsaArP+VQBA/RYKa//EMXiNlO/TJwHUrX6VljMRcE7Hby0eQFMQLTQoGUcoBFWOrTDhTC1qWfAtO0CQXG0shQuPDY1TLQ5m2CXTw4ThxaJv6hVYfpx790ATQ8MD0rXuqOphFNB5PThkPZiMjTLcXB9AtTuzCNGL1JYSK1Hd3yT8yLLPKEdjNlJGtCz1Qp8nx7ZDBUaf4g+e05eGYebZ4zcDqaU9GBTtz1O0IwAVXRudBAcPOgiiO+CovMS+Jll0iXM6hPSUb0DZ1DNWdpIl/nAcxvuFnzTEEWZJwAQFrTdKjdp0JjTHRoduLwXmm0+R1gzwE4or7ka/uer4WJ0pnMCZb3uhu5mTM9SaBiE6INtzFjeG+7n/6QRbtWTUuwpMCT0H0SlAuR5iGdcXriZMcV/RKdFLtTWw83QvqLFV7ko/O+vJDYlsTPBi4wrpW81MUKGCJfP3yD5aOxjWvcxpoPp+yd+79CAd8EQT5ydzZZWSfOtd9RST+4vjzSGYe9bJWxM60U+d/zrHpufvNUTXwgWVczrlOoQCMJbGdDixby+BcFwQqYej5PrC175BtNac1oE4fh36zMSfA439E0QtXZxnyqAREjoJHhhLWywYfa3NGpquf6TBYDCgzASblENurxb/nnm1jBijwnJlv8CshOH6x0iJeb4Rof3fLvAgsdZdRgR2/8kvNwwRZEWHcBnF8FH0b7mPuGgEROo8G0NWm3rRD1j+TkZ51KcESvkR5SO6hA9ebAT+kWbRtQ9S/+k9oN7gLrLarvYH1MMHhGQ5dntjm4NwmvKYsXBnABVGbKeD+3QvaAmU7X3rtVTygq0XsUCJEl1ART3TmvnySrMvVfXbOymjZ4ne78xQUvmWbsQ9FFubWTosl1ktJ580jpB1qKp/z8woI
 ZrYOyWF7
 8VM3P25xUNlUnMdY6KppmQCm9iQkY0uYtBqK7hqgpqZx/gLRQO4QlMBg/QIQggIf0zUGxm31GurCAJDehX1jY0SgYPY5fvz2V/zcffW8aulZ1yFOVXTtNchHrowjhx/FXFsitbDAuPocGJ8gC9c/BDYUVP1LsytkG0GtnXszGAGkBuq4ySEYVmytcAuXikZVHn66qOZ3zk46lCnJeu/Mg2quhb4mx+0VFI6ZPG01rldlNyd1gPtyWy3RKoh9ljfumTru8tmDtrCMGlCkUFlzt1yMUmOpljjPK7QTt74g0rPoMVxcw5MsVH2wpGBRGp30m6X6zS1Rk4e2e6J5NDiV9DTXrGquCgk4KgxyVop1cr7houBJkiWL650+mJ3UcRcY2iGX7Qqad1wsZGU+py9p4c8yTadhrC6BqTw06h8fsBtxT1fE4vf9sNz4K1Fi09BteNTQR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-12-05 at 22:35 +0100, David Hildenbrand (Red Hat) wrote:
>=20
> Fix it by properly using ptdesc_pmd_is_shared() in
> hugetlb_pmd_shared().
>=20
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared
> count")
> Cc: <stable@vger.kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

