Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DDBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE246B0005; Mon, 29 Jun 2026 02:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FF76B0088; Mon, 29 Jun 2026 02:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3076B008A; Mon, 29 Jun 2026 02:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B80E6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:30:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4C35167F26
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:30:31 +0000 (UTC)
X-FDA: 84931976262.23.001456D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2AEAB20002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:30:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782714630;
	b=coJQsgoI5E0vOWah08vb/aI/8S90m1Fz67VlGNOon94K+YR0SeL2bPiMvI5s+F6h2L3ysS
	DleZIhrD9CBZpryZGLPbKPC5+roPNzoFZ//mNiEKcG4AYH7Gm20HTNqUHK9EcxvQmENpTX
	bYEmsV4VAIvARMrP3mXBnJ1TC+uSvdM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782714630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AbZjj792jPZcKgYXmFwt4sTUI/UTDCGHqyWqLkYup2I=;
	b=Vt+ffPsg4g9nKhs+kaztp5O+eAm7KHQGdElKlDo3Nr8m6kbqFlR8BS+UR9jPjnQ+/lz1WL
	d3oGCaDBbv9GowEt+KpsEmfxVSoXjHmZI28wx0v0rquVY4wnKfROcC/vbAl2dbRPWw77YI
	h0fYErlFj6VUm3JiIKO9uP9IULqNgmU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1788A43C43;
	Mon, 29 Jun 2026 06:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0A01F000E9;
	Mon, 29 Jun 2026 06:30:25 +0000 (UTC)
Message-ID: <e29d1211-8bc3-433a-b1d7-d7fb44c2f0cd@kernel.org>
Date: Mon, 29 Jun 2026 08:30:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260627195630.24519-1-sj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260627195630.24519-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: msxxeiqkeuj5iupg3tzpf68xchj9ucgc
X-Rspamd-Queue-Id: 2AEAB20002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782714630-800647
X-HE-Meta: U2FsdGVkX1/98N1vKw3rRz4ihV8JYw2dhrU/Th3+AByw1cxDen/NMWOL58PBpiKBnHOnPn4ErWDWtGVRHyFPv6A9xhl9v+rLzMbCtIdlAmZhUKUKweFUrHBBxMi1yrgUJLxIcZjja4M56L8P4ggY443O+co9Qq/6r/BKTsWWqmJnuZZTQ4UkC/wxYNaB8RVIzZbuEl7orf/lzWStGGsNStU6r0oG0MIEZuq8NTxN8Ap5ymorClB+9B29XG/r0hC4kqhfr3hFlPoJMSuSS3KTNw4LpOUVq0e52cHBMWizMrAgw2SwQ9ARg4ztX1F8CpY7EXFpl4MgcAc++fiyc7WYGrKqclZF0VFRlF6K6MRErgaC/+bU9gmLvXqKEDkon18d0Myn07dFhMPHVwcMwfAlum7kTrKCUmMRo3xLC4W4nnPPb8MIALaiS7ZKY2YDGdjfnXKZX5dVAVX+00Vq8ZsmRLGcaW4BxEfVHj4jOaEFeBSjqG9lJyuAB3X9QjmX02WNX2PQaIWTq7t8fHQWzykdw9mTnCWvAQ95DfzNs21yAT1sHg385s0lUruTxHOy3DkAGYnMG0Z6cdYHoS71kkHKGyzR/SZG2Svw2Vy4pFu513DF04B+KfagfbWOqGOu1v3aUx7rK8MDVv2Pawi956EHYQJD0Yo96HEZPrGFY8trD05clUYhXXSOyYLzKdRYZkawSymBaHRkHMbpMsmvwWxBPhUbt/E+8AQTlIeHGsll1mTIWciDo9Uh3pYYltlfSq+Jv6NqHF+xx3iz/xQQRFCm+fxvskRcswIitp45+EzfvxLZbE7D5/Lg8BQAEY08vCp22jvOhZ/8+HJLfLjorO09Szpe7TXUHSMLc1qq9UdZzrEF0Q14RXobKubVyv7cvGjCilpdXeFG8CC5/p4AxEzZHKeQ5+g/J1mz6gYeWwyG4oK8uLvWHL6iPkZPfOK+8eNgS7ecU8O0iHU2f/ACiJh
 mghA6tQ1
 Trpk+oXwXqleaqxVuAGzsdkoe34AnFaJveANCiYqCY+UcjmdfGMzPviPfvFVNERzomnPo4yvocFRG5VJRrK0ujgfuiFZ9E6EPX0CA7L1D246m/OKdgDrX1OJdxeYTADUAUhlLPq83WslY9fYdwkvVNs07l5o5vXCaq3ClL85VN9Hl/T6bkrqwyhQplBJvmxxIsD3AOHYLuxzSxP1reQBzdq3A8vjxzt0HcxSE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/26 21:56, SJ Park wrote:
> My legal name and preferred first names are SeongJae and SJ,
> respectively.  I was using the legal name for commits and tags, while
> using the preferred name for conversations.  It sometimes confuses
> people including myself.  Consistently use the preferred name.
> 
> Signed-off-by: SJ Park <sj@kernel.org>

[...]

>  #include <linux/pid.h>
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 1cfb8c176b873..fcf7c7fadb5fe 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -1,10 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Data Access Monitor Unit Tests
> - *
> - * Copyright 2019 Amazon.com, Inc. or its affiliates.  All rights reserved.
> - *
> - * Author: SeongJae Park <sj@kernel.org>

Just curious, why do you drop the author and copyright information? (can you
even drop the Amazon copyright note?)

I looked in the patch description for the "why" but wasn't able to find it :)

-- 
Cheers,

David

