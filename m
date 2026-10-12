Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F2CCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 16:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847C76B0088; Mon, 12 Oct 2026 12:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8F46B008A; Mon, 12 Oct 2026 12:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E70D6B008C; Mon, 12 Oct 2026 12:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2DD6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:55:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 327E91C4B71
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:53 +0000 (UTC)
X-FDA: 85314576186.26.60DE790
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FF8E140004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Iw6b+w/Y";
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791824151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7HfjIRGk/NqR0+5Ufhz1l0P5qFNkr4N0pj7z0Zjx8s=;
	b=aT8dcU63Z7R/myfAFQLyRlJLDBKaJC0OX5gkb9ThjRXLSIRnGrFNoisXOwceocosPDA3Gj
	lpkqdTp8cd56UlYhODwXYWeFMMP0VXudSRnhJFtCahwiexn+KrMXWSAJOOFE2WqM3UzL38
	nBFc7VAjZJbpWxzooSITUquH4tmYIDY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Iw6b+w/Y";
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791824151;
	b=yAJebeid68qFzQeLh3t+giVu8IF8WCNwyii1EIQRD8/ANdwMAjhZapcOfd0k3wDroA/9El
	Kjvawmz/MvQGQnofLZlKwlVAA+tQhpF8ABtMWdmH4XJGPuoMhIa3/XfEMRQob4iIsZJLrh
	yNADJJ2T+E3aXyK9pcd/fgAYW3wZgyk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92FEC4360C;
	Mon, 12 Oct 2026 16:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328371F0089C;
	Mon, 12 Oct 2026 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791824150;
	bh=J7HfjIRGk/NqR0+5Ufhz1l0P5qFNkr4N0pj7z0Zjx8s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Iw6b+w/YwdvpaDOggPl6kVhXz4RZy2KQysvehJV8ygCRljQpiDzBTmTtoepl+ccaK
	 QKIqQDHBdABXijxQAW97dkA0vACEgcptpmvLIJ0rMKHU93zIfXl0DOpTPt5veC62Cz
	 H9EsLcUyPoxXx7noMrF7YFCLDT2Y6DP130qqBHkFqNNXgQsXpdMQA3wxf8vpP1kW40
	 fgRpgOa2iqcfkyEfHSH8Owy/T9d9X+RMTDS5YCH90C4/8VauKtXe3DyzVl6Zb2K/DF
	 h3Vlu6w9TXCmMdoKG1xwEp4ig5xw9hDIy4+QLIpSVvA48fV0J94sYwAfO5kgAHC7oR
	 eMbItKXoH8aqQ==
Message-ID: <32d71681-157c-4d86-a019-e08357ce6352@kernel.org>
Date: Mon, 12 Oct 2026 18:55:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 1/8] mm/slab: Mark the kmem_buckets_create()
 context as a Context: section
Content-Language: en-US
To: Kees Cook <kees@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-1-kees@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261006092035.166776-1-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5FF8E140004
X-Rspam-User: 
X-Stat-Signature: w8rxncefsdqyex6x71k76qhga76gg6xg
X-HE-Tag: 1791824151-752574
X-HE-Meta: U2FsdGVkX194u41x/1WdUvxiHU1+Y1iemV5sWWityz67AUvsMEdcZa1kfVzutY27v6Hx4pBUe9W8Q0odK4QKo2TkRZrIE/jXvGx/1jTEaD5I80By6GICxnU2wqoH7KiZXadfM58FYnSYewKl3tK33L11MlFCXl/+1O6vvTEyBdhhOk6gTRv63XcUCVOBoR0Dv9ajVTRsMkcljGJeX+NneJv8k3+K06Pr52jPxiRJP5cdLkUvn+84slhAHSRbds4Hn4Q1hhTkvFjNHcBoFWbps6YUAKPi8gxAqfHS9LKdJ9b0U1tzqKp7hdlMbXxhqnAfAbxjisapzdkh+3UwWG6AyKSAPxH7p21ZSClFoaoi4JTyFf+7nSsrZMO55/t9c7xuaBQ8BKJR3siDIdmUlYPUuySZs+YIvT9tSQLMsQQdPwLRj5aBrbWNUZORLJzTOuLpED3pq5ufF2eYhL7I/RzZm43f0lRuk+f+91YhgkrySc1lvcwjfrNd6P7NpkCACQzxeNJ1n+QyN8UmxursF1oG6Sa7t5ePF0TAMu3pzvEcgrCuNyQ+aYSpWY18YD8OuloOLpAqLSW3vLB2UEO3AVnnwS1OQCVcHgkXonsgb7iTLjtD4041tFAqbxbDqxUwyuuZ+ZtEjrB1haHnmz2FwCLexJJrVQ48D1BKbXkJ4mY4Mhf+Azow7qf626Xg9VqJop8NkpOuVoJvb9FeWiEJsvmNdsv5dffzuF/Te7qVXcAPbnduDZPMGa/0NoVT94e2xIY8iYXu3AvlqXecX4n1mpkA4nKVp8hfDGASRH688yNZeRTcOS9DoompJhkWXndU5JU18pDJRmrblFyaaSPNHbMdz2RJPd4u1wEGKiWzJBfZ69LR0DkN/O2F5VQF+MKmgHTKiEWu4cWReWeN4w2Va6gT5SzF3H+xl9ffEW62OC3KZ+UfIDXp1B3zTwLtJVBjMjT8ZaWofgq0J/kw4sSJNdu
 Xz2jaiYy
 P//i0BhkzDaNFZKc+I9YF1HZUwm/oFi+OTqIsko0eCdqrqs3flLWWOMrb6OrQR9DFOY6Hti5ZHi0hstDon9HH6cUfZ9fwYWqsstXFy034n4MRMgI5nXRulhKEapS+nV3dy3mhQYEPjHmBAqSzjBgFUCSuwg+t2PVlEySG0VGr58dgB3iacHS5j6k/NMlM5StAHWMFleDSI5fiEPuJCgGPKJrDyJN2cMsh0fQ4xxx02hZsKCRGVTp4isNLq0hBc86N+psNLsSAK42H6MNQ3eYeudT/v4QK7nPy0Kt9AsfnnTlLKwg+X9eNt6kDYeReLtI7DQT9J9+NkLxk/rND7eFROaSo4d9c20K9qcOvOHJprVlAaa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/6/26 11:20, Kees Cook wrote:
> kmem_buckets_create() had the same sentence about calling context as
> kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
> rendered in the body instead of as a "context" section.
> 
> Give it the missing prefix. Additionally fix the "a interrupt" typo
> __kmem_cache_create_args() had.
> 
> Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
> Assisted-by: LLM
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/slab_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index b19ba1b31484..270408ce5a9d 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -311,7 +311,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
>   * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
>   * by a grace period - see the full description before using.
>   *
> - * Context: Cannot be called within a interrupt, but can be interrupted.
> + * Context: Cannot be called within an interrupt, but can be interrupted.
>   *
>   * Return: a pointer to the cache on success, NULL on failure.
>   */
> @@ -422,7 +422,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
>   *		to/from userspace.
>   * @ctor: A constructor for the objects, run when new allocations are made.
>   *
> - * Cannot be called within an interrupt, but can be interrupted.
> + * Context: Cannot be called within an interrupt, but can be interrupted.
>   *
>   * Return: a pointer to the cache on success, NULL on failure. When
>   * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and


