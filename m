Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27419D3ABEF
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 02:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549CC6B013F; Fri,  5 Dec 2025 21:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521376B0341; Fri,  5 Dec 2025 21:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437116B0342; Fri,  5 Dec 2025 21:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF0D76B013F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:51:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35845C03BD
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:51:23 +0000 (UTC)
X-FDA: 84187520046.18.E50AA1F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf20.hostedemail.com (Postfix) with ESMTP id 92F7C1C0013
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:51:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JxwpmNur;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764989481; a=rsa-sha256;
	cv=none;
	b=eqbFYrzgH4FizEtt1U7rOJ0EcbKOUh5XRyZ+SDul6FhFPQxuSUmhnuSqlRXuGMatoSXwAS
	2VWPb6HdhmePU4u519TAP7u9XWmYHy0LGeMR6ET7Lp8pZoBbXFSOJsUlCNKltexPztVfos
	2BT6b+JJFIUaKJzVEopPgKGamLgf12w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764989481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46i4JdpR+8kUV3f1SyUYziYHtT5tVVSL7qw/bHAaonY=;
	b=aQjPXyFDCV4qapqkP38UDjJpwfxx/0ILepn+bN/U4nnnzgNrcJdbS8xTPLRNxG7gNNMIWa
	J1QOooZykD4JgM3zLImmtXlM+qP7aS0mxUXnkA1VvAg64PtFObLZklOfb7p6QBgVmN9KW8
	HVFvq9fEfHlyM6DzP6obXcuaZXVsaXM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JxwpmNur;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=46i4JdpR+8kUV3f1SyUYziYHtT5tVVSL7qw/bHAaonY=; b=JxwpmNurKOPe7xdTaNKzFhbUjz
	2+atJh5c6Ubg+NoOSUMWKObtHEXfymc0DOnXNL9yoRkLTddJBv9ByFJora6bNy+4zaRGadNIeq+B6
	PvsNpOvYjWvx6JWKquKqNviKIfYR8B8MoL12pssq2YGmc1w7cJGcfo85AI0YdZK+4qkIVfqNtfKOX
	9/0JxASVFchfnYmChRw9HqRTcWdVCfksTa5td5XVJnMZ28AvMNOFQOUZJulQYnZ+e2X/DpoTrhtoM
	d6PXJIsYMBsGZl62IGOokOSKG8qcmFYy7VMdGY5L3E96qGFxp0/CSCfj9Hx+9VDxvPbPHcib0Yu/7
	pEkRM8xA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vRiNo-000000005lS-0ehm;
	Fri, 05 Dec 2025 21:50:53 -0500
Message-ID: <3a574abe86703f925c9ce8b751ca5fb1370d1ce2.camel@surriel.com>
Subject: Re: [PATCH v1 3/4] mm/rmap: fix two comments related to
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
Date: Fri, 05 Dec 2025 21:50:53 -0500
In-Reply-To: <20251205213558.2980480-4-david@kernel.org>
References: <20251205213558.2980480-1-david@kernel.org>
	 <20251205213558.2980480-4-david@kernel.org>
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
X-Rspamd-Queue-Id: 92F7C1C0013
X-Stat-Signature: jxpzyefk7mps4ijd7ambt5mythxdj19e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764989481-437764
X-HE-Meta: U2FsdGVkX1+LjTe9et78y8ERZc6VgKtLrzsTqQD1Mc6w4YNHOQrvt2pyZ5hbWo2UQs7qoEfI91H6gFqRR7hZIx5EFfBAPAXRsjV9d/Adh1xno5LLcDoJL+cKletKuge20B+AtUHZoK4bolBVKbfW+85v8+32FDgrsX6BVthbCjpixoE0CZt7+OW7Bvg4/9kMMEpGqEx88FwHeemX3aVSIE2f610KDS1eC3yPt2vNEobhapPTc3VfM71iIpnqWFXxl5k8eEH55JG+Ih0FkX3v+Ncd+XE7dT5yUIPXCTYq7XhcUbOIBG4p3IzkFvBiEprt1baYJPCguF/Qqj1DhuxzVeqg98K4c2i+8l6uTnMKtSsKj/ZmOUpKU2CeIhEc/HDVKZ6/lggDo00CVsrkiKgsNP6UuuVcKddtzzXi/Ag53SfHGJP6qchFzBZi9XlnZ2LUouYKJph4RBnpYX83e1bMjx/jE5iCUbDfoCAhQcE0/G+PET9OwG3Squ30px8r+ovkQ+SwooojPWuLsiFgsYkQ1QwZGpahNwTzvxmL+/XZNcLH/pCyjT+itz6e5/1E2yyxXL2zbRo98SzQ2fqdn7AdW9Eq5fveQwpmVCFYxt+eYPdlzhWh4EcCsrYaQLJVd/c0hSZn3rftjD1gWj28fgD55w3WbZq3jFOJpx9fdqbdLpcXGvDizUJJuvmlf2q0YevlRHwWX1U9Z05OE9GpBZlbl41QGgKBRwMzWzMQaKLGQlt2FQ7LkBn8DCrzJtEbYoAxI6UYweM8FXhEp1ANMnxrMVpgCit35FTpObsZ4M2EMwrSA7W7VDIBIPnDO9ITs6lSVSMfG57nkyCdxRMpQxdSRIAmSM8oxicpZxaQRs1u+kV2Qoy4Pk7XjyROscWTC1m7v6mVKBoK165MDH6Qdm4MkVspaVfNM6WfSAo1aofjRyLJ6GOBZd+xnkaWSCEo+AJereROMRg4NemNpXeQUfY
 rdIR8lKn
 CQLXx6zSRKDqXVk+iB4shFu2OPgIdaChpA87TnsP07k/vkQ+ttWqRbKqY22HMblbSzFqM2pd/MJe1Tgm3QrA+GY+Fy6klbIVUm2uJ+A6b4nFmIxvaBQpfcXy0Q9/Zu1P0iGHO5iCh5oTYec0Ad8HHsaI3Yrf0tKDnI4vUsYeeZBMV6zR76myKB+Z8i00c6U29iaYVNOuYiHn0jkMJY2JP0RXtjOCwd+j17sSI6kxeW548i4KW2Xn/2IzJBwl2CG5rGJFsQx9CfIyHFRQnw3G1b7CJmWLCwZY1f/UqukCX2rRtJSjiaayyNe107gtsDx9Qh7EeZLm9PySEidYTmIaNcbMN2u851nvDh4AKhPVjIa4DTpkAQXid0V8EkwGQpNDVITB4Y/pF+2PV5i9CEsj3yK/YeQxPlPnys14AW1QOTmoFPEOyT3aTnVktJAsu6sQHPT8i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-12-05 at 22:35 +0100, David Hildenbrand (Red Hat) wrote:
> PMD page table unsharing no longer touches the refcount of a PMD page
> table. Also, it is not about dropping the refcount of a "PMD page"
> but
> the "PMD page table".
>=20
> Let's just simplify by saying that the PMD page table was unmapped,
> consequently also unmapping the folio that was mapped into this page.
>=20
> This code should be deduplicated in the future.
>=20
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared
> count")
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

