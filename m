Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F11CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 11:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66576B0088; Fri,  1 May 2026 07:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17BA6B008A; Fri,  1 May 2026 07:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D136B008C; Fri,  1 May 2026 07:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B129C6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:58:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DEAB1C0081
	for <linux-mm@kvack.org>; Fri,  1 May 2026 11:58:47 +0000 (UTC)
X-FDA: 84718704294.12.E65DF76
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 73A7940006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 11:58:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=WV1syePI;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777636725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOhKLlF1R9uNdLjOTRmAoX1xETWbiu0eXI1TIXZFb0Q=;
	b=73f6k5tTREEf2tUyqSzm5LjY1FjI0nDUOPjscahGIu5P6glGjb2b03rikcQ5+euwa/no2c
	m4gP9E9ei3M+D4cCfiWnkJOmSf1+bRrbcIZFlGpjaq0C/0TZPQW4rMqIBYZwvS/L7a7IPy
	NJvwSfS9HtkT1SCeNlCoYNhkaOAJsy0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=WV1syePI;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777636725; a=rsa-sha256;
	cv=none;
	b=WFrlbAmDseXMF/K30KuoH1Alq464v4HdO8B/whbjrFBA80jiy6j8b7jJDPXNmmkfZIT474
	plWlvqvDEf6oaOInKiTELW9THEYRxyXPwI4cZVibwKQzv3n7d9Q6OPKEQwUj6HyECdATdV
	Qj7EpFAZqmA+qT603NX17FKhLWXrXvY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MOhKLlF1R9uNdLjOTRmAoX1xETWbiu0eXI1TIXZFb0Q=; b=WV1syePIbQFw6I/Q+gY8j2puce
	YmjU66RBOwKO1VVyutp/WVx9SUyAUbXAx3v8KY9Bm68+iLyBB/o3vv2Nb1XOla2krNEUqE7jcj+sS
	wtbollJmEyhfXYdoFWZX+MvsrXV9cTbSwGsQ3qn3dRypS+sT+q8QyHPyjSLtKZ5LUbgEmZFetaYL0
	wKaKEemTWgqOO8HRXoCrESieD8M1PvJAe6e+pcn++h0YAw6POFndWz7wuwfpc4VXVS5FhksPPlQgY
	EuOPdfml3ivPbJ+3yWgswaG/5fu/F0iPWaeAO+YSD74GQwL6ApgjPwjrSj6hroThZqk4ut1h4uLud
	mGkdpElw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wImVn-000000007Dt-3ud2;
	Fri, 01 May 2026 07:58:27 -0400
Message-ID: <40661a7095b2b28b2476fbb9656e3d5478914779.camel@surriel.com>
Subject: Re: [00/45 RFC PATCH] 1GB superpageblock memory allocation
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, linux-mm@kvack.org, willy@infradead.org, 
	surenb@google.com, hannes@cmpxchg.org, ljs@kernel.org, ziy@nvidia.com, 
	usama.arif@linux.dev
Date: Fri, 01 May 2026 07:58:27 -0400
In-Reply-To: <428786cf-6873-4cdf-ae57-cef43b174f8c@kernel.org>
References: <20260430202233.111010-1-riel@surriel.com>
	 <428786cf-6873-4cdf-ae57-cef43b174f8c@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73A7940006
X-Stat-Signature: mqz1ibuinxa5m85q16rangxzpfc4w8ix
X-HE-Tag: 1777636725-578787
X-HE-Meta: U2FsdGVkX1/fKqKqpc+rsNmnqhNRsmR/1qWIaFe5MK4q6beKlsxWB/aFlfd8CtJcFQwSmYvJDqFJHG0QK0s59sNGke3kv6VaMPVYze0ieP0s3m6xKoLQ6UubIq5SAEoOVhvRi91H1ex3eHx7Mz3IN2rB723v5PDS4/qZQUV9sF/3+PWJTO6kEibDYMZFDG6MWs4K1fXPM4IjNjJHbxikpSbrGQW9nZ++HGvDqeIWrA24u/EpQtbp43bskJh/eB282XH/cGZNPS2asnXyuQ8MFZIR4EzKLtkq4TjfIx89MzhcD9XgsRmhMfwkPQ0BsoYDQDqeqVbYinsXDPTsc2SCniUGsiEEg9EJKL9QJBrY8x3tzt0JmeRcyXkUXkNbM3AgLJ4uAj8VKoExy5icb8eBCzXNVTd6el51EQ90tgKTdENZrtFKQNyzxW2jPcPz73NtwEKFFM5daYpxkOurZDMt8okDK5gBdDOeSppIIz1Can6xQowzWAxM5kFHUXuobCDYDRmJrXT5MnHRn/KNpabPuZf4s6KVwDQwoA4ySdtzQA6JDQObcNzBl1XghWAPkTlj8nx2iqODndOE/vdJvlwqYx6gnAZTFn7Tr31PDfxm7BZ3PuXEnK58mIwYV3+0kZglILOXs2OZ4qV3IE1WOjEf2SLEegdJG88+0M0HS4MAu1ZWjGE9yA37s98bLMqxu0xLu8O2AFcQ2UZ/8l2+HvzxdsuSVAn3SDqXLNTzGdeqLKaAFqIV6e33rrW9yxvI7VBYOLwVHX601q8MsnNe4k2sCBwTIYzNMcNarSj+qQMWTq+5AKO/41NQO5kz2AL1PMCnoViTnSN3tl9IuL5xICyjo/dXW0urd9m/2aM42sLtvlv7cZaaiXObAanId+EQcYpKxVxcReu9Mv7C2RZ6F6QGeJ6Ym9w0lsCgc4Rha1hGQ8cJ+ZEpkyh5mEWyIm8YHRGqwnjUD/VVbtkaD5h+fqv
 Pmt4g9d5
 ApL6+aYXrW0VlKAZ0+JfR+a1cGLc9abJwxTxI+Eq6iO4KgYx6UjTggnwabiKPVWm8d3CUVfItnJrNoQGotCZkRjk6LEtzV3qmyno9PRxjsUunmgHhZGmz+kYNM8cjzBb0WqSjLsDzb2hNjNnZn0siBqsJd/uU3cFesl0uKOeK1O9bZ6MDFPgKHvWsUBeMaVQ49BNgnFgzd+4zSO3Z577UIBDPaOgSUxkeGalh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-05-01 at 09:14 +0200, David Hildenbrand (Arm) wrote:
> On 4/30/26 22:20, Rik van Riel wrote:
>=20
> Is there some text missing here, given that the first paragraph
> starts with
> "Neither of those" and I am not sure which solutions you have in
> mind?

Yeah, sorry. I suspect what may have happened is I
failed to leave a blank line between the email
headers and the first paragraph when I inserted the
file into the send-email compose.

Here's the first paragraph:

Some workloads see real performance benefits from using 1GB pages,
but allocating 1GB pages has often been limited to hugetlb pages
that were set aside at boot time, or using CMA to keep a fixed
amount of system memory off limits to the kernel.

>=20
> > Neither of those are great solutions, given that modern servers
> > tend to be large, often run multiple workloads simultaneously,
> > and each workload wants something else.
> >=20
> > To address that issue, this patch series divides memory not just
> > into 2MB page blocks, but into PUD sized superpageblocks, and
> > aggressively tries to steer unmovable, reclaimable, and highatomic
> > allocations into those superpageblocks that have already been
> > "tainted" by such allocations.
>=20
>=20
> Also, I know this series still needs a lot of
work. I will try to get many of those things out
of the way over the next few weeks.

Right now this mostly serves as an illustration
that reliable 1GB page allocation can be done.

Hopefully the next version will be more worthy=C2=A0
of reviewer time.


--=20
All Rights Reversed.

