Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2AB7C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFFC6B00A3; Thu, 30 Jul 2026 10:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7A36B00B6; Thu, 30 Jul 2026 10:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FB36B00B7; Thu, 30 Jul 2026 10:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4286B00A3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:18:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03329A0185
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:18:49 +0000 (UTC)
X-FDA: 85045649220.30.00C3ED9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27B69160009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:18:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYYCtwAj;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swoCWGdlaECteypHrMqmfRUyWFHKvTb0U1amc3WON8s=;
	b=Cv7cVnmB3szKDkAFa+Q2ygnGqbk33raz7aZUt+YZK/dUXOlaUt5q8BiyzbLB0hWrKVZoFb
	fXzfiqufPMaMLEPb/kvDvnFJuNDlglDsewL8DH3qYW30A4rcCLadA6RX5fqKJCmHkxCM8m
	vevp+b/AgIGqiRpgKj/MTk1Wk8ngaxE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYYCtwAj;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421128;
	b=jjG30cpapQ/e8kR5eYf7w9Ap00ptO0BoWj5E7zp2HfherL4xT1CsmvTEdoyYpLY+c4W6/t
	1aJftJ7QbFkdUdVwB1fI5IPoirookHv66XjA+e+FHU5UXhC3nu57/e3IIJb0jU8NzY1bMG
	CQ1ejD1wEK8cxWq4BbviztxQWNxAwx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C7164144F;
	Thu, 30 Jul 2026 14:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AC21F000E9;
	Thu, 30 Jul 2026 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785421127;
	bh=swoCWGdlaECteypHrMqmfRUyWFHKvTb0U1amc3WON8s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gYYCtwAjaY13b3bjz7310oW6xyE1WYdcYTfN42+1zsrWTBgFqquOV4/hYdWz0mQYH
	 gvvvBF6ds6F6MNDfEblEHibOx6T1G9vedrXxdFznRBpl4VZh9bUtHQc9fIuemNEJM4
	 eUoj3bsfe3NU8fT/zXsBT7gABj4/WGHF+KqXyWCr2rFKr0TH88xSlNa0EWQPkjfoVz
	 pLHwNdUHaSbQsCblpILUavZeVpLiNmsFqmCUpWOgjfedQ4RxpVQ0x3hBMSZZtx0Nh7
	 gYL1fxBd0cYPCc7Mlzl8Rew1GsvDF+nnptugHnm6y9kup55cBZseSEZnyP5J+usp6n
	 WLboD8Yzar8Zw==
Message-ID: <7c19c4f3-2d89-48ff-bdf1-5bad418e719b@kernel.org>
Date: Thu, 30 Jul 2026 16:18:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes v2 1/2] mm/huge_memory: fix huge_zero_pfn race
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>,
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>,
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
References: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
 <20260730-fix-refcounted-huge-zero-v2-1-c5d8a41b317f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730-fix-refcounted-huge-zero-v2-1-c5d8a41b317f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27B69160009
X-Stat-Signature: rouqmuu83qsuc4r6yt3omeyksi66duhw
X-HE-Tag: 1785421128-209917
X-HE-Meta: U2FsdGVkX1/gvnHLsTSnBHWA6HtUB85Pmhxi2tqDtzzXqiTiEK/TYKlMYab1YLqzEBridot6E8Gn0sN2ETiagJVHSmVO9NwEUaaE0l19zfQscC8bARekp3VHCA6gp3XLEOH02xZRlzBEugBU25wns+OrevfUAjh24wWiidqRDFzKdebaS/6/5I8T4OOQxZzOR4NQQugTLTiADfjcqruC+t3Kqf4fj/PBx3SGpQ6auOHCfovDRF3Mp7Xc4TDETGZx98p6f2PpRCP0ofapBRxkxQNfTFnYIhjMx1K+5N85J/iTixjEZhjRzQcUiL4BOeLWtYSJqHnuYAWTusomLHkR1bJtwj/AusFfoH2k6iLbdTxELc2w8Z0HRMDsijx9JTgD/A459Im84fOK1uXx/0xKDqTBvur1WeAi1l9ZmPhyHqETynx9e4mlp9t5qPNzn9WWCbVwOQDBnOXdqptFJL7gT9hvDoVL8TaVRQppm1N5cUO4e1lyGyHKvlpLZUZuoVXvz/+aLt9NNDMa83NVJhxkn++S12CqYJtZodhbXKc8+/cIGLPJE7C1Cwc1/JKjsaA4tNRh+c+jXm+B/03aNOE6wV5tKgyXynrOAPpwWJw5VTjjReBUJj0xyLqt6imdBobYRU30ytKDIwK+3LM140YsZmoJgYtG1OHe1m3ba9MFtyi5fqWTZZpfb/Yb0aSqm2HaOe+r2PaKIJkQGY8OBsqQeeoaUZ269K6TZAjPIwHGGInMaXLxnKGFjYZAPjn07y7jAJwdxR5eURuBugPxn+UBJAtNOPSapnXL1yxUTwXp1uMR2n0IpvwoeX+bvA8ocdwrHY7TU4FRKx4iMmhSqDfd5hQca2d0RxQ6aaIrBepOW+Da5uicIyvuV4AVL9Q+GnZ6wj2mquTGIVxhWmzZ/9SqseO0Op6OZ+ZBfcUQ77X6kKFNw0ilWdDU/xNvpN2Ya2N3vj0ZINcqGG5BSe/Tb3r
 yCqK7fGl
 +fo+NzPP5FXRoGdglywakXKbC7DuhZPQxRSGFHFQliY2LcwLxcpCXJKIpC1viBHpBNPoinsnzwcDrsyGt5ue7VeTkCmxxB6bfou9ibdPZ9tRgJmsFWxLObyfCAz1P2NCilFKNar+8wczEs/eJu/EUvATYEjk1Rs8h7rIJegLgPfzzs5mHi65zf+UQyII1fpAliGXJMvhJWS03F7crN50p5wpsd8ubabh5/fWgyGDQU4Abj3P2PcwgUMtvV6ZwF+E5UpAWDjXcxylZaxW6QX+ycCWVxFFiKMHBhyLVQDwPkdvWoI/aoDvf3b8j2zZ5FPLyS+I3HF3F6WRrTr9+MrwALKFnRZbo6vO82n1J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 12:55, Lorenzo Stoakes (ARM) wrote:
> If !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO, the huge_zero_folio is refcounted by
> huge_zero_refcount and returned by mm_get_huge_zero_folio().
> 
> When the caller is done with the huge zero page, its reference count is
> decremented. Only a shrinker can set the reference count to zero.
> 
> A race can unfortunately occur between a shrinker decrementing the
> reference count to zero and a concurrent page fault.
> 
> This is because shrink_huge_zero_folio_scan() might, if very
> unlucky, be preempted between setting huge_zero_refcount to zero
> and writing an invalid value.
> 
> During this time get_huge_zero_folio() could write to huge_zero_pfn
> before shrink_huge_zero_folio_scan() resumes.
> 
> In this event the huge zero folio will be persistently
> misidentified causing the THP code path to be entered
> inappropriately for the huge zero folio:
> 
>                 CPU 0                                   CPU 1
> =======================================|=================================
> shrink_huge_zero_folio_scan()          |
>    atomic_cmpxchg() sets refcount to 0 |
>    xchg() sets huge_zero_folio to NULL | get_huge_zero_folio()
>                  |                     |    atomic_inc_not_zero() -> zero
>       preempted for a long time        |    Allocate new huge zero folio
>                  |                     |    Write valid huge_zero_folio
>                  v                     |    Write valid huge_zero_pfn
>   Overwrite huge_zero_pfn with ~0UL   <--- Invalid overwrite!
> 
> This results in is_huge_zero_pfn() and is_huge_zero_pmd() incorrectly
> returning false for a huge zero page which could result in issues like the
> huge zero folio being incorrectly split.
> 
> Note that the issue is with huge_zero_pfn not huge_zero_folio, as
> get_huge_zero_folio() uses cmpxchg() gated on huge_zero_folio being NULL
> with a retry loop and shrink_huge_zero_folio_scan() uses xchg() to set
> huge_zero_folio.
> 
> Fix the issue by introducing a spinlock, huge_zero_lock, to prevent
> concurrent write of huge_zero_folio, huge_zero_pfn and huge_zero_refcount.
> 
> There needs to be significant care taken here to ensure correctness:
> 
> The fast path in get_huge_zero_folio() uses atomic_inc_not_zero(), which is
> outside of the critical section, and means huge zero allocation is gated on
> zero huge_zero_refcount.
> 
> The fast path doesn't use huge_zero_lock, so the critical section is
> irrelevant to it.
> 
> So invariants are required - huge_zero_refcount MUST:
> 
> * Only be set in the huge_zero_lock critical section to ensure
>   serialisation of huge_zero_pfn, huge_zero_folio and huge_zero_refcount
>   writes.
> 
> * Be set non-zero only AFTER huge_zero_[pfn, folio] are set to valid values
>   so installation of the huge zero folio on read page fault ensures
>   concurrent is_huge_zero_*() calls correctly identify the huge zero folio.
> 
> * Be set zero only BEFORE huge_zero_[pfn, folio] are set to NULL and ~0UL
>   respectively, and atomically.
> 
> Establish these by:
> 
> * Only setting huge_zero_refcount to zero or an absolute value in the
>   huge_zero_lock critical section in get_huge_zero_folio() and
>   shrink_huge_zero_folio_scan(), and always updating atomically there
>   and elsewhere.
> 
> * Using atomic_set_release(&huge_zero_refcount) in get_huge_zero_folio()
>   after huge_zero_[pfn, folio] are set. This is paired with
>   atomic_inc_not_zero() to ensure atomic_inc_not_zero() only observes a
>   non-zero value if huge_zero_[pfn, folio] are set.
> 
> * Using atomic_cmpxchg() in shrink_huge_zero_folio_scan() (as before) to
>   ensure that it is set zero only when equal to 1 and set atomically.
> 
> * atomic_cmpxchg() being fully ordered ensures this is done prior to
>   huge_zero_[folio, pfn] being set to NULL and ~0UL respectively.
> 
> Eliminate the retry loop in get_huge_zero_folio() as the atomic_cmpxchg()
> in shrink_huge_zero_folio_scan() is now performed under the lock, and
> replace with an equally locked atomic_inc() to set the reference count
> should the caller be raced on huge zero folio installation.
> 
> folio_put() naturally implies a full memory barrier so its ordering is
> maintained correctly.
> 
> The huge zero folio also cannot be released except when the shrinker does
> so as it is non-LRU and non-rmappable.
> 
> Note that only the huge zero shrinker (via shrink_huge_zero_folio_scan())
> can actually set huge_zero_refcount to zero, which is the count of mm's
> which have at least one huge zero folio installed plus one shrinker pin.
> 
> Additionally convert a BUG_ON() to a VM_WARN_ON_ONCE().
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reported-by: Hengbin Zhang <uqbarz@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20260727154001.4102341-1-uqbarz@gmail.com/
> Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

