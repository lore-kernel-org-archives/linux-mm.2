Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA903CA0EFA
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46AFD8E001F; Wed, 20 Aug 2025 01:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442C08E0011; Wed, 20 Aug 2025 01:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FD68E001F; Wed, 20 Aug 2025 01:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26C2B8E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:11:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A54B0C024C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:10:59 +0000 (UTC)
X-FDA: 83795961438.27.282537A
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7718380010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:10:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=bwkG0iRb;
	spf=pass (imf30.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755666658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pn4NalMMn4Jin9v8qpHCQzOPlQZJKwiK8VwjOAPeQaM=;
	b=EapYvNNRwkkAeqzWwypktwdeApXMaD4copZlgzpYeKltYb+FyNag1alBjnCjm9ZBU2enLL
	KBuJ9Qh4+CUwO1ut26IPUbL+9qvxSdPV7zqoUMPzUrGXyKEjhd6qATGiRMLv9vsm4jOXHB
	4mISFMhcVTtBOWwGQj9DSziXD2UYGh4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=bwkG0iRb;
	spf=pass (imf30.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755666658; a=rsa-sha256;
	cv=none;
	b=pyb6cgJNg2UWA3L3m1crpfq6EpjPmpKs8+80v8d5iqKD7AtBo/+jhTOHbaY3yibq3yFFWb
	+7VXQUj9vkbptq8pstwLX1z2p2a6RtMmEmvhZ4bfHqUMpU3libOYv6XY36LOOuPL8E4yd1
	LaP0t4FnvjB2ylYhA40oKgu1BUGwhdQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Pn4NalMMn4Jin9v8qpHCQzOPlQZJKwiK8VwjOAPeQaM=; b=bwkG0iRbHDSOt6auGT0C4z/tWP
	UFOqSMgc0xa3YTjpqG/LcYtlOeV/6fpiFpEjd4F50EwxhL80RCDCGYH0E+Z507LOwKiKhy8q0utAg
	1oAqX+wpGO6o4CislU2dAFi4a94NwIoXggPOsWpkGg5PZG7s4vZ7ME0tAXhJpyzmCdNEq6vlRrhuS
	Ripg4IQUE2JLOXbv9XrOdaM5xcAXQSq08r6kDsPQSUbEoqJl6Y6LETva8K2MGn1tgKYgPL9g/dmXN
	K/w8EXQ4Wg0Ij5vG5nm6F7B7eawDhDGsE+Uq+++1B+Hiix18j5MYrn9OH1sqGSkEg+3/yM7VaazbX
	LO/83aJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uoaqK-00Fi3M-0f;
	Wed, 20 Aug 2025 13:10:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Aug 2025 13:10:32 +0800
Date: Wed, 20 Aug 2025 13:10:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chris Li <chrisl@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <aKVYyGWiWRYgxfE-@gondor.apana.org.au>
References: <20250819193404.46680-1-sj@kernel.org>
 <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
 <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
 <CAF8kJuNJ8s2D9NBdXDQ4vpBP0a-5k7r_=DdFuJJ95nMKmm6LBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8kJuNJ8s2D9NBdXDQ4vpBP0a-5k7r_=DdFuJJ95nMKmm6LBg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7718380010
X-Stat-Signature: dk8qitamqo9zgh15iojhw1t58m8fxa11
X-Rspam-User: 
X-HE-Tag: 1755666656-45114
X-HE-Meta: U2FsdGVkX19gsTAcJzVSPkKzjhk9WXil/ZkIiAczC4qUGxHttgNyU4P2S8dxH3A+fi47G2yeTrw9HVdXz07P9UJCf0r2Y4J9P3nUh2TwLxg3MTvNKzii09pA7E2H0E7MoPGk/V9l1p+Oqb5YD2rumMm+r3PK338gcvMIaJPSs3moILZT7D+IbaDFjqP/prO96k/4DjlDUgWY+NLdCfUocts1Z7HQ2eCtTimMYW0kHZMInDlDbGlyPigd6DyG2gw9MEgang25og20MphFXxqPj2mmUVHLxhhtMpZye3cmVBmHNXP0Mtrdv8ItrdtcUgaM/9kDoqv5Y0naVNhMCermQEqFmw/Lzypol2H8f3KgaZhp1WMtrA5YtY+PJf7wukW3NQhFoy5LmUig4QRHKbxNGmGsnL7KADuyhOik2miew4l5/mm0aiyplVSq47DyO9EjmNR2Q00M3X3Uj5zROMEkvbs8pI+6NSHbRW9zXt9yY/9+Q2jKMM5zobT/jhOAAhoiUtPyTmIYhpTVOIoCto/9/uko+R33yft3yOS25+t7iirJ5RB0F2sILcImJcjnNCJ/gAt/UMELlYotmBNltFYtXv/siES+D/y/WuMh8qcFn3485tppBAKXCtpjLZrJ1lVqrNduq06QgYpc4+KWX1z+FGo3sZSE1qa2iajWT6e0ExxKzO+b0qs+R8Beods4ysVIqLv8YVoc7POImIsW1fe4eGwGFqr/+3tXN6VZCkVK182jIVgDmQJJKNoXH73Eq/QYzSOtZZpkPdNRfa0zMT9e76uSQhodAS8NMcCdAzdp2o3uryGMnPSkKmMWCOQ2nCgQf+iYj4gAuxNSCZ4LCDrw1gszV9ssuAe440DwGgD0RLLJtipwDCysLzHMIg4ZofYIVIbnFoIHGh5O5/rfnwC1UX5cKpfqAGIOGAueE/kMXYOqG/o2hUgqf9VFeR7qXGRU1XdaQpTpNojE0UkCh9x
 5LdVA8iX
 MqjckijZVuZU45mjW3H3G41aEeZbxLZodQ9HvLoYllPrBGtECE0aC8pRUNQvP430cs3hOLFxap5HrdwCAjGFOB6fXAFR+26e5Fy+rAM6uhXM9/9UAJE+DwzMS+/HtvMXQJF3Vaarz5yoZKfNEAfQebsIrQGbqPjrOAWaUpIJWaj1nxPksE/PWEe/Qq6Y76LLKjngTMKviuzhScLUWO/gIaqEpERqbvtVF9gTa+IIRQIBnpUWRPxMmfRhFYoej7a1FX60MR8L6uax6jSsFchz6DuhZGYRzPpfgm1Gf+6zh7V+8JINwAVMQwU1dQ+34Hpd9JOqb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:07:57PM -0700, Chris Li wrote:
>
> But if that error case can never happen, we should convert the crypto
> compression from returning error number to bool instead. It does not
> make sense to return a free form error code and also demand the caller
> does not check on it. If you insist that the caller should check
> return value like a boolean, just let the API return a boolean.

No we need the error value for other things, such as asynchronous
return -EINPROGRESS.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

