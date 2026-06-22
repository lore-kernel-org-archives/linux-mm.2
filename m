Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63B5CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D01C6B0088; Mon, 22 Jun 2026 05:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980AB6B008A; Mon, 22 Jun 2026 05:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8962B6B008C; Mon, 22 Jun 2026 05:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 652936B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:07:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F10041A05C3
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:07:33 +0000 (UTC)
X-FDA: 84906970386.28.0E13056
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24E2E1C0006
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:07:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsBGj0Ka;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782119252;
	b=oeabsx8HJ5icgDUMoNy7p1KnkCjt9zfL8SLiE4VSu7PSuRiKsdKt/j3w/n0WeZkIU692yH
	WpyRbMHEYbNOEqXBe9TD0fQ/7z8t49FaJs9mIK1qDpvfdQU9SHdIBFMP/0HElpHqB4Jcwc
	ywO82+3LkmM5R6DrO3nCUEo5KGgBlQA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsBGj0Ka;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782119252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFZ35FzPXQdOQq3s39dM5wKLfyApcvTpz6XHQgSTFIw=;
	b=1OU266w994YR3kmARo+G5++13UjNiaWN0oxMYQ64xs6qBUvxzuo4sD+sx7ks/pLyml62UX
	+QYb3RSWoRWdIApjvEPdSN17r4zE3iOl3FaVY3JUUFajY/63o3THTC85yR86hHjyynuWqV
	ve9sUzBKvEDgpMv5iqaKRdNow9/gSRs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BDF343A9A;
	Mon, 22 Jun 2026 09:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A6E1F000E9;
	Mon, 22 Jun 2026 09:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782119251;
	bh=NFZ35FzPXQdOQq3s39dM5wKLfyApcvTpz6XHQgSTFIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bsBGj0KazsOFozDBp9hAoxV6gL6zq3A+An5uN2lyXp8z06AO+NjkJIonjXJRHyDbT
	 w5fKlS6JTqIJG8grI2ajObQh6Zip8hnzwzkAFF5OhdBiGqW1pJ84fqQtVSuKUK6GR1
	 ba/1n+W06edyFQrdoNgoURK2nj4WayKVyTU7035jMmSF1zEwkJRMd4pDdjFgdQNJod
	 ABNU87FqWEiESyh+30BvGYZI00XINixNqfEoj4Ix6mlJFAF0U1s1ATPDG+oCCF+R+1
	 D2e+mpk7hNkKCMwDUth5zMxncmHFCeyrLd/hOQxhJyR8llAQsn/F31V1j4N+WLLgZT
	 Tz0WIj64f0hRw==
Message-ID: <b8e21f13-14ea-4e9a-bf17-d69a4f7d85b2@kernel.org>
Date: Mon, 22 Jun 2026 11:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm/hugetlb: remove unnecessary empty range check in
 hugetlb_bootmem_set_nodes()
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
References: <20260621145919.1453-1-ekffu200098@gmail.com>
 <20260621145919.1453-7-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260621145919.1453-7-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 24E2E1C0006
X-Stat-Signature: 66jur1wozciktboesnb4f9xfdhqr8s6t
X-HE-Tag: 1782119251-580254
X-HE-Meta: U2FsdGVkX19d1PwM/fWKNs+oZos5jNHzJeHtWSLDrHcthHk+vZldEtPLOQ6MVMzh6RfGKajbD3KQpy/F0y/okDddL8bcIP2rTPbwaqKxw3tFef/TSImovd8tckpb+xjPt6zsjFV7YZarUg3D0JR6q2AQcg0G3qInkKIB+5evGEFxyMALVMCL/XFEKXmCY5KX/nh/6U6RH90GIqqGFjxDGN7S4qiQ8IkbBQP46pyysfB0HLvhSPFl4Puuvm22Ln3wle6X9lh6vMC59hgA7mDQkCtO+CKUB5mMmn/jXFt+0HeBnUw4HXLqEy6gO4NWX38kv7OAj54jNOl3QL/fC1Uc1YCvjr6AIzrEy0EpVAkcpXPzupls9JGXSTLvZ9zvn1CDBK7CsbI3L0zvN/SCO6fvL8rDqJaw5SGQBlRBqKK7Mco7YuNO03aIK/HdDQzM9kF82D0DR0T0uEQyw5RmyvzSMbRCweODLJpN+aNeiVoApUUYT8zqOMAG50SQhobZB4RSIu/ExDhzz6raXV4IOFl8ZUo9Lr+M6+MqCYZhQkF0z57WBeT/3QfIaOvObaOez71vTxfVjXU3HToltQk1sN+385CM28KSgcLpHM+r3TusXxkHKJq3andyr/NvaCHtkuYbJ9XQ5iE0MbP2A6VOFoUMAcu7XySFvXGomDJ4aX2FZwHwCkeD+GMQbbd7+SbQUoEm5/ICuvu9X3jAzUlj779urhQcaf2iLNpduY4NyIQhoTO4g6jlgEnQBnf4a2wnev0SsPQRna3X0jbeGWOTtvRjyYW+dCO74InAfIvXBsfcgDG6HzpvkS/EgfDezCeJmEN3XsgeyHOEuCG9DxVcJwQne35RAxs64OKzqNrSC/vnAZsxMdrQlW6FaCG8q44srWRD11md56NnVROgqui5EMuEqkUt3/baEgDWRXOe1dUYcpXFnWLDuE97zpUXqE7p7dVPFoFbtj60FfkzRKkW1Oh
 gCv/qFmp
 qt7BOJDfUcWasb2xgxrSjiZiNoyKdMPm1+KyueJtrDu0rXGvMYfVnMArhvwq9jZLTDqpdDBLPEqaq0QYbwlNNhvII8jN7l/rQkWcTCctK/Abzgi382LFJxPWmhYkakab67AX5M4UkJt06Vm4r+VGHC0cJBBqSnIKw9rWb/y9GIQbKPuVrmSegNHHXKELbmxPmILqeWb0yNiu+2crawWsbPO9PUIIp+I31TxKfPXz0EgfdteWe69mXGMdKWQSFHEOHq+c/FTZHpuCkLa6aT6y+QObE0dBG/vkUbG4XeXzAMda32zL4LGyZ+Zuac+1tKMJZR7bC71C0aZZcP6brzvTbACb680C8v+5+DF0s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/21/26 16:59, Sang-Heon Jeon wrote:
> hugetlb_bootmem_set_nodes() iterates the memory ranges with
> for_each_mem_pfn_range() and calls node_set(nid, hugetlb_bootmem_nodes)
> only when end_pfn > start_pfn. for_each_mem_pfn_range() never returns an
> empty range, so start_pfn < end_pfn always.
> 
> Therefore the check is unnecessary, so remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  mm/hugetlb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..d4d4c9df5f51 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4450,8 +4450,7 @@ void __init hugetlb_bootmem_set_nodes(void)
>  		return;
>  
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> -		if (end_pfn > start_pfn)
> -			node_set(nid, hugetlb_bootmem_nodes);
> +		node_set(nid, hugetlb_bootmem_nodes);
>  	}
>  }

We have

	if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
		continue;

...

*out_start_pfn = PFN_UP(r->base);
*out_end_pfn = PFN_DOWN(r->base + r->size);

So we should always have *out_start_pfn < *out_end_pfn

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

