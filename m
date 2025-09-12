Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE125CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 22:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70D16B0006; Fri, 12 Sep 2025 18:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21786B0008; Fri, 12 Sep 2025 18:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9103D6B000D; Fri, 12 Sep 2025 18:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDBC6B0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:47:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF2871DF801
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 22:47:20 +0000 (UTC)
X-FDA: 83882085840.20.948ACAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5DB9B180009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 22:47:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dxWG5wTB;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757717239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIOczoHNCKvI3Crq9vawprubGXJnnjcgNR6EABBe2UA=;
	b=DargUOUw+47/ieeCifv9ENSWi4j65UI9LDsQvI/loGjomdi05sUG/s7np81sBE79fxgee5
	jzQlbI+wQGHgFjfg9ii9KGJm4l53AItTAQZfaOtBbQaTMPisr3y0NNMWgMIuogFgQGAez7
	pTilk4VYIYYS4eZ2/Kj9mPAvnWHE9GI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dxWG5wTB;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757717239; a=rsa-sha256;
	cv=none;
	b=VShAxP5bjqhR3ZfGcB2LPeZ+uoBmQ1IyrmUg7t2z4gALDQNLBXM6bBVwUFtmsPfVqHWvsq
	pqAJdJw8uR8SGqNx0BWgQzfAIy90ytS3lCXneJM0fSvszLnaVHb/d9cytyVcIL6TjRjzfX
	CbLcQbMzukP03l5BL0IdS7bWbJQiG9g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21053417C2;
	Fri, 12 Sep 2025 22:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B1DC4CEF1;
	Fri, 12 Sep 2025 22:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757717238;
	bh=PuC0x0wZxSshYp65vfPecqp3riKCUu3EhmJ42hnawOo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dxWG5wTBOFkF1kdlND8tSYAP+hU5SK1eCl0+VJNoGbNp3Ul8kyb6vt39djZqMiKPh
	 cGjstpDgVr1sAiu7IzNZbUBYoHspUKQsZYnwXdtN8j6l0tYdNrPd2Sy3XCXkoXu+8L
	 +ICkEZ2dGlH2F5G2gzSNf9Exd5CVFWp9Hv37b2Fc=
Date: Fri, 12 Sep 2025 15:47:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Deller <deller@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Toke =?ISO-8859-1?Q?H=F8iland-J?=
 =?ISO-8859-1?Q?=F8rgensen?= <toke@redhat.com>, Linux Memory Management List
 <linux-mm@kvack.org>, Linux parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
Message-Id: <20250912154717.c557cc39b72740491938fd91@linux-foundation.org>
In-Reply-To: <aMQ2ZjZNyNwAiUk-@p100>
References: <aMQ2ZjZNyNwAiUk-@p100>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5DB9B180009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 61jfhftr9na3j6193mke39g4jq49bxj4
X-HE-Tag: 1757717239-992079
X-HE-Meta: U2FsdGVkX1+hqg2ygGQZQ+F/lKd0BzxfNdpVjsIhxtti+i3EqfzNNLpOxrA1uhPBpbSljoIw1Kt0F5+xiuRqIh6hbplIXFlu0hQ8poGSlrflYZ63biwFwoQo9SzG8hyFkQSCo3PoHV8bWmtFjwnZH9YILG+LjW53QhMwKrxHGAI6UwOGljmdMxqLmPGY9x1tDQog891WxWPb0gMf/8jmciMwVldaU05v3fvXYuj+wa/5S1MkCm+nwITJOTj4/B7/vJcYs1tGW9NvhWOswh4bQSeNTe4z0zTWksgHNlcwz5hdzsmmnGO41ewMjX1Y+XfSR88w0GxWxxqf3RGwch8duK70GEg9e6mJiMhoXlnRawxg9nBbesoLemYcBJov7MHdoCHTVk5tyUft62rWqajkU8Jr1wJpdTwg34Qd1dTawdBxuFI+Lmb9b8vddrWTiDHcIyVPgSKyU7dYKkWr5VPBRQMDR6zGv4Fk8IoZOp6iAMUWzo55FBrXM93l0eJi5ede0AWjM423Zxpn6p3K/YLW+6KmhCtKdQzkIKohKL9Tyyf6Gpe0rdHjB1SwQTPYfZkjl3lJ3hVN4BZnFXJg8GNnSg+pnZQTMaKGkjOt/xecIj6K0uyBVw5HUtQ5Qf13I/S1xSeK7MwYRuhyb4gY78/fRhoyKOx+AWsNhE4rnmOjJ8qHzrNZyYkzSVTDDMdppJDgreH2LmgtGHsZbFFBtWxbi2lC/xcvC/QNYHxiFGeE7FXLCcYzhBnKuTVlAk4e7lZJ3CYoAF+Qu+n9fXNiWML1py7MFYT+oFSHVG4OiBB7NuqoPEMba6ITDW9zh+u1pR3SLfnCmtBh2CN/yXJT+P/vurR6ovb09vOJc17LMoZsuPFR+qPiiscM7PcuGh2XfZM/sg3KD8QpEDp3totfBVKQjA/0mwKstdnZ0uBy0eQWQuy4wX0YFaOwE1oOaRY8AfGZehv+m7cVVFALMJ7So6t
 yIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Sep 2025 17:04:06 +0200 Helge Deller <deller@kernel.org> wrote:

> To: David Hildenbrand <david@redhat.com>, Toke H=F8iland-J=F8rgensen <tok=
e@redhat.com>, Linux Memory Management List <linux-mm@kvack.org>, Linux par=
isc List <linux-parisc@vger.kernel.org>, Andrew Morton <akpm@linux-foundati=
on.org>
> Subject: [PATCH] Fix 32-bit boot failure due inaccurate page_pool_page_is=
_pp()
> Date: Fri, 12 Sep 2025 17:04:06 +0200
>=20
> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them wh=
en
> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c=
 on
> 32-bit platforms.

page_pool is a networking thing which partly lives in mm/. =20

Can you please resend, Cc'ing the people and lists identified by
	scripts/get_maintainer.pl net/core/page_pool.c

