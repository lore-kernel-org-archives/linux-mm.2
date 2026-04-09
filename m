Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D318E9DE5E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357A56B0005; Thu,  9 Apr 2026 03:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308216B0088; Thu,  9 Apr 2026 03:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7166B008A; Thu,  9 Apr 2026 03:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10E7A6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:52:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B17FD13ADAB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:52:16 +0000 (UTC)
X-FDA: 84638249472.07.5BE3A57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id CA4DE1C0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:52:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvVJ8Uzm;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775721135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HC4yIbeMFoP9fA1jy6cixoRbkOvK+TszSTx3OCbvWxc=;
	b=yU8bD4jb0MvOGngK2ojVioDX78tqtiCmovqMWJLBeMO1jFaNzM6yvs4pRQCwD3G/N09skh
	38rRTxRV3+Ri7KZod35ldvyNe0K5GuCRZkTXHC0SXq1FzY6D7fi/eEUA3mp5qpXo50OnDD
	E4GE3ngFhEfEBNsmd8LlTcsLKUcYnvQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvVJ8Uzm;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775721135; a=rsa-sha256;
	cv=none;
	b=PIDwlOBWVVkgJ7CU6mnG3MhQD4cGib8ebmE1DQNOx1PD5fajJ2j98HrvMotl93r6R1BnVZ
	h4k0FUalg7jg6ZhGl9RFG5OmdCoDuax7z7M/FLMKdZ9GGw1717TwaEzj14s2+fc9IIG4e0
	reMudo5CDrc8SYsVBJF6dBoK8kIMcws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4DB443995;
	Thu,  9 Apr 2026 07:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DCEC4CEF7;
	Thu,  9 Apr 2026 07:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775721133;
	bh=yGi65EzNbfPcmaJHDWorm0OFGsNjNwfdp9HFY6agVns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RvVJ8UzmOEqrs0G14kFM++8rr6iSHglz2PZ93CS4iIyeprIkvH8VqMiq/edzOnkCw
	 Si4666iPcgT3pRU8sE0Wf+cubbsOxmSkc58sEXEE0TCWStDdwgdVmxRQmfBm8wrY71
	 mzI3VspNd6nW1JYnfViIiONMRI2Kej7tVv4FKomuFTLENDR/OcJ18kSdXGarSyzoR5
	 r118jxfBv6pJ7S8C5KL9DbZVwIWGBoDobp64ckPeC4QjdTdxu0/gPXSdcQNREJvO9n
	 jJLUS6GwJ0Vjf3l1frsawwNuCCzoXfWttFhEnBiG3G2B7XWsVMhPxhMs+7qvRANkx0
	 J1LsyFry/mCQw==
Message-ID: <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
Date: Thu, 9 Apr 2026 09:52:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Mike Rapoport <rppt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, Sourab Gupta <sougupta@nvidia.com>,
 Zi Yan <ziy@nvidia.com>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260409014647.397515-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7htiauzsmr585impu4oe18ux9qj8bqch
X-Rspamd-Queue-Id: CA4DE1C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775721134-244941
X-HE-Meta: U2FsdGVkX19jsNtiZ7H5Q6hXj98zO6zLJyu0B8/QYCdz7VpwSTqwBab1sGZp3jPnIQbREgGD3qfCmjKY/ugqYrdQS+x5Bj546rq3cOx6rPfHPlCiaYqjKrCgKnUFtlSrGISAEaQbooyPhKfxLauy1YPwl0DnQpDqpGfCplC8k9MBEqhee96D0U1OcojKumRdCYnZQmB2RyBWiSzjmYLAG/2/eqpcd04aKQyu5dUPFyhyh1DSjGGCiJUfDbKnEmsXDWBCQVZYdS3jWGoBOLwy0WHGpDYO8bkzBnJRz6qB02gSQjkcP/iYumwuTOYYyQkP52gI4dPqPgf7DdPclCSA6z9UZJjmSMY42M1JSisDENs9vD53e3wDCchmRnQ39joGqYcGl+or5BBptVWGftttgLJZ8Tc24tbzVTqrzcYqABCWz17roq1Q+GJe8Vr60x4KIcrRQR797CC0IOHJ2bUqTWuqLKnaw6ZOYsaqAMb8wZbKqm2bdQC4RNGzyFq8RG0HPEjAXD4ZaT0XkCKYOM14wY+ZEsgIC3kJuIUm0Q0AL+XXAToltbiszKVcN6ZTgzn2R6P9CVrD+2Yy6z1ls9i/o//+oiZgWt+jyRsS7+TNY537g3z6dlpbA5ZiIZpREjkKBoLHPEckRgXO27/4Y+tLHEF0ncLabqE4AUR0lBSyKoMtBZ4LBWYFJfDUUErjuOF+ySt2MM9SzZUF2dVrfpTbNgnS+jdrvXLPR+8FcjBb7ECJnlsU4ACIXkgLpaWQPsxcynRutKXNtCsHUUql/88fNyfT3OjeoGjf3GJVD+RQcTnBhEya1Mr+ZsoE73eCBNIyEAMNg2ROVt1nTqkbPmUrVWHmfkb5ohGeY7yOjygk94lO9Io0FJ+97BOX6XnsKDUS08qDWNCN39hkfZp83XFdAYNavG3/Z3bGh/YT1ZzxSuzoMgQATKuF6Vl3kioHluB6Rzl2Uino7LXeCq3CiOz
 mL8iEmwt
 fAnsD11p6AKuMvxLLp0tPjYMWfZASvpw74tWRwbTlo3UBQt2O6Et4mhNaZ0uclsgKJxXruYvU4x50eo2njbIYlzrBSIbbDq2TQ+O3FIgOcZYKdhrSn2Hsl3DgPZgnUtHnOUq2XhyJrcl372CsEVFLLnljm8R4pvrIGrRlkBht5+Bnnc2ZtZB7nl8WgKmYQKEgzj2wg5ULqGKp5ywTPY2f3QT/ArpyZcbdRrvidaEY3rMIoCKMLIAoNXoMhSeYxvtbVjsAEzvuoP/DoPEp+nj4twGqFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 03:46, John Hubbard wrote:
> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
> gup_fast_folio_allowed() falls back to the slow path for any order-0
> folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
> performance regression for drivers that allocate pages with alloc_page()
> and insert them into VMAs via vm_insert_page(). These pages legitimately
> have a NULL folio->mapping, but they cannot be secretmem pages.
> 
> Secretmem pages are always added to the secretmem inode's page cache via
> filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
> A folio with a NULL mapping can never be a secretmem folio. The
> NULL-mapping check was intended to handle truncated file-backed pages (a
> reject_file_backed concern), not secretmem detection.
> 
> When only check_secretmem is true (and reject_file_backed is false), a
> NULL mapping is sufficient to prove the folio is not secretmem, so the
> fast path can proceed.

Hm, what if secretmem folio just got truncated? I hate to rely on some
handling in the caller to detect truncation differently during GUP-fast,
but this function returning "true".

Zi is working on a way to distinguish folios from non-folio things: that
we can identify whatever was added through vm_insert_page().

Because that's really the key problem here: vm_insert_page() pages are
not actually folios, they just look like a folio today, but looking at
fields like ->mapping does not make any sense.

> 
> Tested-by: Sourab Gupta <sougupta@nvidia.com>
> Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()")
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/gup.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 8e7dc2c6ee73..3ea661e67eea 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	mapping = READ_ONCE(folio->mapping);
>  
>  	/*
> -	 * The mapping may have been truncated, in any case we cannot determine
> -	 * if this mapping is safe - fall back to slow path to determine how to
> -	 * proceed.
> +	 * If the mapping is NULL (truncated, or never set), we cannot
> +	 * determine whether the folio is file-backed, so a long-term writable
> +	 * pin must fall back to the slow path.
> +	 *
> +	 * Otherwise, a NULL mapping proves this is not a secretmem folio
> +	 * (secretmem folios always have a valid mapping to the secretmem
> +	 * inode's address_space), so in that case, we can continue with the
> +	 * fast path.
>  	 */
>  	if (!mapping)
> -		return false;
> +		return !reject_file_backed;
>  
>  	/* Anonymous folios pose no problem. */
>  	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
> 
> base-commit: 7f87a5ea75f011d2c9bc8ac0167e5e2d1adb1594


-- 
Cheers,

David

