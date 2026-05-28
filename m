Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89CBCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4EE6B0093; Thu, 28 May 2026 15:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4848D6B0095; Thu, 28 May 2026 15:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3731E6B0096; Thu, 28 May 2026 15:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26F696B0093
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:41:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFB681620A7
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:41:37 +0000 (UTC)
X-FDA: 84817848234.16.6B3F265
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF32440015
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:41:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DaRSN3et;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779997296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCdBYtvZPP11aQlPQeSM2ybwZJhqmrs4vdzqMl79lJI=;
	b=EOWE9sz27NR1OwH1dVA0pHsu5r7Okquz8x9tTDLKMO1KSgPuPbrBbWffuiumw9u67VIiJy
	s+O9bCP0MvBk6KgjTNVl8IVqKZCMueIbeMMTMYTbCktsbHG5kLzrpYHxjBioZFj1e+/wRN
	c8jIGhk1wKvOXlLnsYqAZECidHR3o1A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DaRSN3et;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779997296; a=rsa-sha256;
	cv=none;
	b=kQxU4pW1rWYNtdCW5irnwyCsvAHDxTHAw6ohF+gag2r3on4EeSr9a2tZ9x90nlViFYM4xq
	2VydggzSMVJxC1WvMZmGa41EUXX1BMGJYZo66pyq3tAFdZ1Jlc7KRqjB87kbYFJshoKzfA
	MRQFzXVwcj9e3wjmVVtB/6YK9iBMQxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 799FC43E9B;
	Thu, 28 May 2026 19:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E535C1F000E9;
	Thu, 28 May 2026 19:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779997294;
	bh=mCdBYtvZPP11aQlPQeSM2ybwZJhqmrs4vdzqMl79lJI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DaRSN3etf1UD0hQ8XimNb/OzlvKUJp6QzbYxVb3eBDYbD1ycGL8pJSAeZzSf6w7qZ
	 j1pDGOcNdoQR6Jc9TaSaaVHxDN2g+ucKrAzeA8Yfo2ExXxN7uLdPLTD0TxrC8hn9Nz
	 sdiNS4IuWTfK6VsesMHt8hbAF2J2xIITFY/cspF8=
Date: Thu, 28 May 2026 12:41:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>,
 Waiman Long <longman@redhat.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-Id: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
References: <20260528190337.878027-1-ynorov@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bwnppx5p4x1pi8osi9pygxxrxbubpdwd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF32440015
X-HE-Tag: 1779997295-703031
X-HE-Meta: U2FsdGVkX1+XewLGkQH/eHQooiYnkGSkPboLy50GEfwaT4mwSWMnO8JyyOEwZDdvnrz/DJt0v6bMskIDkXtFtrYtgN5Y9PIwvwHT1/+QfZIGpbfMn2/4o/EaAlSd3CM4lex+wOZqswVhN9iQcQUA/Oooc9A0gllqRn69tw9vnF/QmizBQ/1XMPrWfaC3ru58Hoa0bAGOn9Fzd13N7vA7T/hjo2V9Z6TKSGX1I+LyvO0jPQ7cWw1WKpDvKLfveFotEvvMWoIyvqq8NJOboQfvLwwCT4MywBO5Uut7ULTad13VliJpyS8TCPR2TgY8AVf9Do/Y70L3unn36rreO4k/8B9s/8nyMXzb6Z2oyTkSwGwcBxRdXDV4xkq9SU2rmie8VGcoLixR8lih6q2RbyH0mRQi9W8R51wfCPm+bt16Llw/KVAQBDFrOf8FBUvSNNwoHQEb9sQOa6wnH6sPx/O/MGxfJZTGqn9hBRY4w2DHZECzWMwlgDXO0+3M0NjSHbqDFqsH8CNM+DMYGKbTz3Eol91et9t8OOmiqFxJjIEoraK74zByiEHJPCvZMfkuZ3nfzBKXXBMok6GwAyax0/foL14qlPuiZAbidXyql8X+jbwT+r+9MZIplt/IIZLZONlPB0cCKWxnsQXUBorcrKPYcRGHBT4qZwuKZ/16plpjBft/vzEHvZUwBe22B+3b5PwAz5DmQQ5vKZzFwoIo1GASZ6qdkukCxfDkJmlVTBnRoCAONK8AITYCR54lrlmmXEA4H03cIQOsUr4EZBm4mNxgaEs5G93l5hemwQvqbGw62DzP8OIQAaQ49RcR1Qrvr6NlE0PIjJJx9PQbLU6oG3nEITJSvkM0dFsO5Lud7pTqAwBIEyQr8Q8g+hZP8824Af+BDHU0WRzT3Q63/btUuuWkWQG34fGWbO09ELl8BT+fjntBhJmstUO0Ea5YjHaw3u6/eyyjXhIjR4kSeyAvRUu
 bJqNkAUX
 jrnCJpb1JoJ1Ma47lMG66af14F65NNE2GxiFCi55u+aQ3HBaSnakb03iO7dBKB2gGRxsrz3xDCKVa7RsROh0oNGzp4sOjJ7/4zEgq9LTmmUBGLNZqQW7QCV57o0ScAQjF0IcauDfPZZ9VlkR/h1kMDEAgRr33a3bV0tabzreT4beO35cKKL3xef8/XBDaYzhk2hlU8r8thOBZhxfbYyVB4ukwuKgF6I5ilgscUz2tc0UJ1te8G/C85+lxjgBUHe0n9EBQMzP7c+J8ImIAYcXMkvRbmjEZ8gL3E7yiu9vn4LC1TCI4KYSmVsQ6Lk5Tj3jLeoVGxfAFLhTdoBc2EBNMqo3j1Q8FPgwZBLfAHLx6rJE3JaP2bRLDjIj6XBx70c4wZXbqgk0sm8ZD9vXuaajA2Oep/WgGq3zBcBN4FSQtZXlCO2rqlm36FpF5GMgOt2XhQK2s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 15:03:37 -0400 Yury Norov <ynorov@nvidia.com> wrote:

> Reassigning nodes relative an empty user-provided nodemask is useless,
> and triggers divide-by-zero in the function.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/

Thanks both.

It looks like this is very old code, so we'll be wanting a cc:stable in
this.

> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
>  				   const nodemask_t *rel)
>  {
> +	unsigned int w = nodes_weight(*rel);
>  	nodemask_t tmp;
> -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> +
> +	if (w == 0)
> +		return -EINVAL;
> +
> +	nodes_fold(tmp, *orig, w);
>  	nodes_onto(*ret, tmp, *rel);
>  }

I suspect we should address this at the mpol level - it should never
have got that far.  Hopefully the mempolicy maintainers can have a
think.



