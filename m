Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED307CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98D66B0093; Wed, 24 Jun 2026 17:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A876B0095; Wed, 24 Jun 2026 17:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13D16B0096; Wed, 24 Jun 2026 17:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5C766B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:11:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A22131A04A6
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:01:07 +0000 (UTC)
X-FDA: 84916026174.13.448CF28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC722100018
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:01:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X1YzewiD;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782334865;
	b=lG0FJOeacr84MlQViaCXSSx7VoCsJp+9ToXdi1fcgh8cxXd6OFH5qHdYTKIUogmqRif64S
	Km+FCPhjOeylbNTnxXf2oMgnSWIKj0s0+zRcd/u//+iujGbSM/fthn0m2a0Lyu/G3JCT/J
	A9xZ1WON4LhbhrG4APmsPLGZfHX9gdw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782334865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6AiIW0qUO5FLu24Zy/LeQ2RfXKyse0PDrwQy1AWVx8=;
	b=wTujst97PZdZixfboSismQYJZ7feddlLPyte7A3gsAZSncrCXdx+UFo2fw7Fa1NHjulwY5
	M0ilCJgvbFaYm6Y3NZYewskgTmjNWWww+Q8E+gyHOJNboJmewFVYqDpZkDeoAki7jmQzOW
	1Ps6OPXtA7PgcwM1FuZ459HbgTr3+2Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X1YzewiD;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4395D60018;
	Wed, 24 Jun 2026 21:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4DF1F00A3D;
	Wed, 24 Jun 2026 21:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782334865;
	bh=T6AiIW0qUO5FLu24Zy/LeQ2RfXKyse0PDrwQy1AWVx8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X1YzewiDkAcUK6Xvk3Rc4GL9vilaLtIncvcdSLTtHu5K5LmqLWBEUmhcM4L06iEoF
	 t4S0Bqti94qLIRNJE/PTaC4GoA4/Q5GRJAwctP6sgpNHQl/dwBWcujkEkk4Nmy5vGm
	 b5HkAKJee4gITSHmJw748m1J8MpYtmUzPX0/KajU=
Date: Wed, 24 Jun 2026 14:01:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2] mm: avoid KCSAN false positive in memdesc_nid()
Message-Id: <20260624140104.eacc15e291eec123bc7b3349@linux-foundation.org>
In-Reply-To: <20260623084432.701120-1-hui.zhu@linux.dev>
References: <20260623084432.701120-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kfpkqoydugrfw5qkpym5jsh3quhrc6jb
X-Rspamd-Queue-Id: CC722100018
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782334865-843525
X-HE-Meta: U2FsdGVkX18OK+z6XGv5f4kHc/fup0A6w0yvePuSFMcpSYdGeV4PDuk82isSwwQvX9ChJ9g5iXnZALE3k4uOzLWCM3kPQUMbiIalC7vE6ilo/3Q+K3WhuDXRKGOwbB7a6CtU0TA1ff0Fx+ZNVxv9OLgT9xMfWIe6rWd1VKVoamJBP8RF88N5o45xQfcxF9rkMgxp0Z+R6x5X9rnwFEma7tl4xPp8b2QpCa2Yj1Hz2z6JzYF/8pQCM8kbqkiaWCexk4PrV7jTHnbr8FnwOsy7mHSbcaPWG5RvtzucH9cAox+ow+fGPsJKf2UwbVCpY3PgdFVW7M0UABmxS/YLM/qKAfvT5k7LP5pdVIbYIMjFHXwXjTIVQQamEUt5NbW2XIAOjeSwpHUYr15igs9Q+YqXWLhP4QO2Hm6yib6flaoCLhgwRbCFj8Hm5LnHfUc49ldCvu3gvfGSUBM7f7EFlRB1O6Jw8YiJda/fFbkiAQ/hZ5IGbYTdqo3VjNHNdQqGcewVa7nT0z7u0ATdOsjVG6rRgKwx4pYA+1tZoi3onR+Vuw0Vgors21iseCRycv43181c68NLuiOuPaelRk65gEHrTBGjwCT77JexVYtrpZNJfgI6uP69w/EKFPU+EhLtwDNDksOSPG/4P3QlQ3a4gi0QbKPuGyij5wfjsQNmHQ5otEj0GORpSQND1nrl+cPJ+6WpliHw4FrF79jsztz48o7nuLuY5yjBhAzHZlpyxRkzIlxESMj6wtEqRPF/4VtM4vWcI/z9kfw+8j1a3rYlMllMNwvs77IoDl3KLhQ0JU2Iv05Tx2bMtLOorX3WwWCS9Umqq2xp9xawJEQGKUiUGKfE7yhhVcE4GN0MmQR99Ja7DHz9Sz69UhvPrtDQWmCHH8zRUcFTJ3YBztRBuWBQUJwAALmZZm2riayyT45zw+Fo2rLZDiQiNwzlWF5UI3hORpvYayxzpD390ghac4lrq7S
 ipbWkW8O
 Ytm8W6S0KfEp9QnSpU3mmdSCb9hlVWPl8Cz3dXO5xPBj3iDfCSKFTLl/I5FPXwoLqtucWW2iHgyRdZslagKyfmOSlODW4XDpRbUQUpHSmOCoQzI7sEeCJ2Bxt6Eq/fMutbbwbmQFszdcDTu0lRMx9kWT/zFu04LIKIuW53OKSta1vvoQte6M6BFdqRLsL4qy9GZeCTgOhyml18pHDEN7fAs5TaM1k3hdVq70FAjvpMZbP1RipiiluxHvGup5s1PGbrZGrye+RZzoamWnJ61PZCjd0Yp6m/ggGFDCKp9EfkOg4R6gzOjfuuSH5XYmLxQ3y6/1Wk44PoGq2YZOklJZdTYxOMg3QIdx5bVzf54uK7Kypw6CpL9PEzWFxwRak+MM0/BUTHjoenTQdWEgRkziMMQxafA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 16:44:32 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_nid() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id occupies a fixed bit-range of page->flags that is set
> once at page init and never modified afterwards, so it can never
> overlap with the low PG_locked/PG_waiters bits touched by the folio
> lock path.
> 
> Use ASSERT_EXCLUSIVE_BITS() in memdesc_nid() to scope the exemption
> to just the node-id bits, consistent with how memdesc_zonenum()
> already handles the same class of race for the zone-id bits.
> 
> ...
>
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2290,6 +2290,7 @@ int memdesc_nid(memdesc_flags_t mdf);
>  #else
>  static inline int memdesc_nid(memdesc_flags_t mdf)
>  {
> +	ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);
>  	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
>  }
>  #endif

It seems weird to be doing this against a local variable within a
random function, seemingly unrelated to the problematic functions which
you've identified.

Seems that it fooled Sashiko:
	https://sashiko.dev/#/patchset/20260623084432.701120-1-hui.zhu@linux.dev

I'm wondering what the heck is going on here?

