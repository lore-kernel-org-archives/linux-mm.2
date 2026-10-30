Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D632A606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 05:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QlYl8R23
Received: by kanga.kvack.org (Postfix)
	id C18B16B05B1; Fri, 30 Oct 2026 01:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9A46B05B3; Fri, 30 Oct 2026 01:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB89D6B05B4; Fri, 30 Oct 2026 01:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA086B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:51:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12DF4C0512
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:51:39 +0000 (UTC)
X-FDA: 85378220718.13.0C7F940
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf24.hostedemail.com (Postfix) with ESMTP id 939A5180006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:51:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=QlYl8R23;
	spf=pass (imf24.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793339497;
	b=oZhGDXElfjdIELqP39KQ8Gk6Pqp2do5rPM4Cpm4LZx6eErW1pOzLGJRSx/wMvrRXNND3pZ
	JRMV8hDeE35ZK/wfTmaxnYExzL2PT6sXvAmNLJIF7nXw8awdEHZBlAwNn1FDD9OkJimNEH
	78dzBN2/4SS5SRd3PGHG8ndg9zw0jJQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=QlYl8R23;
	spf=pass (imf24.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793339497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YfJOSpnYoqiR78tZwDBtF0PrUJ/nLB9HJdYwRb1UHU=;
	b=blMBB8OixrDyLaW4kbtL9ofj2WSGkcex18Dd4gWbNd6ZMA3McSqca3zcqaZQoe2JAUxMxw
	bpx/TGoa0dDM0bbjPAeAavkFHFJK9qqiGSHtVIj468P4DzghRTNEFJ6nbBfoZhBcWGOaM6
	Q4hYHNuM9B1vt6BGIWmd02c92QI3b0c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9YfJOSpnYoqiR78tZwDBtF0PrUJ/nLB9HJdYwRb1UHU=; 
	b=QlYl8R23ah7db17cXjIK67qEfvz8JUtktiO7fjnOtMoLCiyWnmZA3/MnFD4QhgRePS3V2XlyJ5m
	SHueIHs1OxKrVfgPR9Cur5A17QChscsZYTpyZNEj6oLMIKjUO+lMKmVlP725RDtaDAfTGjF40UoSN
	rI8WTGQfxdkbr0pdR66K5Cg8mc+BY3NuJtmjfM+iB9AxhFWNjc349K6LhV6SOfeOWv4ha5YbI3f2w
	0IKrX+w1QeNNbWcwYujuLdcYF/sqkedsBuag4Tka+PjEdcuJGCiuEMg5iTty3YYRVeIw87KRhf3UF
	mOQxSDjHsxPgt0yfy6To3jpBqfE8o9bEOsAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMfWM-00000008zTr-1ZKw;
	Fri, 30 Oct 2026 13:51:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2026 13:51:22 +0800
Date: Fri, 30 Oct 2026 13:51:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
Message-ID: <auQwWgMbBuo0YEBI@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au>
 <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
X-Stat-Signature: h9pzokcf3ii5p7bn6ksmhzn3jd34nxdn
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 939A5180006
X-Rspam-User: 
X-HE-Tag: 1793339496-902185
X-HE-Meta: U2FsdGVkX18gIZV/IkpFXfGvFo42xjoLY9390eZqbq8THm1W5mUsGKhZ4Wwi+sd85zFXQNJfa1qs/e3vNUcpNuvd+qr0jU13i5rxUyit54CxgemHUSR5HmPnEPfNn0AUgDL7KP2HGNfXVSr6SVE1coPIVqRe9ciwbtow4nebRZSkqKX9G57c0B4WbUznnFiXH5I1/dmMTNaa+n1bmDC8ME8YpUsa1dmimX/DVOZ5TW9ONju5Gkvuph+G4YlKi1waJKEM/YO6djppUqD//LPDeOS6i8Rdtz3k8udYWI91USpRHCIU9oG/yZUJKLAfg4vKBQc8HHEd1jJ8STSNExIBDI8yHePrgA0LFlwC3I57ipWP96tR9HuSOIyZw+BB1KZ8M4kHMDAAV7vBitOY0b/XZ4v63vZI7AjzKLA7Nfrct7m2EM1rhddVr9pqNePKMAafCh6xGINIqqYrGKy2cDfZzkjXg9kCq9T2RYWyHCAb2PZLbE6JSXLZXvNXT1d8UhAQOqwAvo0zt2577pbOZN0RSlgRtNBol53+OfF6P/oIDozvl2lyidXDFpkMTjFUH6DdZbnOkNXWeE2U1TDhRlj7ZzvZetqpjCwiSpmf7/P5kKtWNerXr+IB6z0FF3WS9egBXwgAD6wNxXKUA1wu1JB3iZzZ8Ia7A3JVwDwuTu6L9dd8ekLtqEBg3f/jxx2ctkwURcWhXmdTZbsXN6PcIMuolWvvYKJDB9Q/Q/ySbJw8Pp05HWclZ3o41S5eWh2K68HPAOUUNVNwfA8lWEX3q/gdFYdTULA/XpZmPl5ikUPoxfj7ePcmBxjGqduxx2yqrIiQa0NVbSvWyVZOO8BKVK9Q0b16sRhu58IZ+Er10MBshmLdaQ7PbVqNUJVRNJkU05JOhumNs2fBzPsvWiDtTZKbVerh4RwE5yRVffHy+YlCealpqFa5rB6C1P3QQaE28J1cXu5li8L6jHcS6E/xWoB
 D0rAEXS9
 qzEouG5Lw1PABjT//V46KzpssWW/v/nRBcuCu4i5FdU98nHLJAMK0rZ/tVi2iWG6UszuPytMT6VObGGo5E8/Mxh5hMJkIT9u+Pcg2SJbv5FWxruh2AJOKvtMUl+FSPoMwazC66+jy62wkGN8MeC7PN9IbKx8maHvVSHqN+l9H31pJ3GxQustnaG9hU8x7vccvKcNFrP1yi40NrC39lD3QgYK+5eOOKIlcXxVuRIcjnVkmNn/QtdFFU5r6HEftuNhQdeklaE55X5C8bHwd9KldCQX/GersbAGb1fwb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> 
> This is how it is in the current mainline, and has been for as long as
> I can remember.. I assumed it was because we need a per-CPU acomp_req
> to be allocated for the tfm. Can this be done with a single
> crypto_acomp for a given algorithm?

The request needs to be per-cpu, but the tfm does not.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

