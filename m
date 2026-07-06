Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85A1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 19:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A55B6B009D; Mon,  6 Jul 2026 15:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B936B009E; Mon,  6 Jul 2026 15:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495306B009F; Mon,  6 Jul 2026 15:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224E96B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:34:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B09F8B780
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:34:30 +0000 (UTC)
X-FDA: 84959353500.10.9DEA2A8
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1880E1C0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:34:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IZEhSE9H;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783366469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FIHHLRwVR4NtU0/LL0GRJyj4HVJuRDsfXvwLZzguVw=;
	b=F4+txEctvihxTj3HOAKemNNJ+orFLIr+d6JaZkewADrY5BZgPPNZp/AeWmeyghvobGlLwo
	hOaS67dnkKjwAJkBTV3JHH6ek1TOnsQk1T56v/bXeIpfsfA4WV2JWlqbSpe0bHqS6YQJ+p
	/dHdXdpYRpWEWR08UPXEqdUr/rOAEVo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783366469;
	b=yd3GKnwtnjgr0M9eWhwo0BnbZN5+IyBOlrhPIVwK6GCjjs79Cd9mNzeMPwXBtYnwiM5tX0
	l7ZsZFEQufQxg5jpOji2QGzJux46tqe9AucJimjYHpv1qXPKf+NQmcsChju5IgbMyXM9Tj
	mp1p6w3D+0NtXShImt62EYw/r64CfM0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IZEhSE9H;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783366465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FIHHLRwVR4NtU0/LL0GRJyj4HVJuRDsfXvwLZzguVw=;
	b=IZEhSE9Hn+GAtySFANf8zpZy70wX6zakvqMszh5suNaxs2g92mI7HXIFOX3/tWNbIX/g6g
	HCrJ7FoS8rGGkXvqTUWDdbpCKNlSnIIH8FyGQ+xZwDBDSycvLiijeo5LJnMO7kTMbu5b7l
	ZfA89c/n1BImcgpi83k/4cTN/4yc6XM=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 6/8] mm/khugepaged: unmap pte before releasing vma write lock
Date: Mon,  6 Jul 2026 12:34:06 -0700
Message-ID: <20260706193407.825323-1-usama.arif@linux.dev>
In-Reply-To: <20260706154500.39178-7-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1880E1C0002
X-Stat-Signature: nkwzuwb3orm9bogojpxh3g4y6jc8geda
X-HE-Tag: 1783366467-47177
X-HE-Meta: U2FsdGVkX1/LfqDRzEjorhnQ7tC5thWabhw5zKIJl43r0ftVYY3vdQ2NOy4O+sQCvcQUQnaColEKrOfJWvxG0HO9plUAgadMecptjbS/Qjtu6Cvx0bJAMglSWb4U11BabsQuqz5fXEx9CDdzFHtm7DUE3cLMgPYdCUhukmTS1hvlf+Xop9D0qlgsFVCvLFbM5szd2mvcIjP+qoqfElkHW1UMzdsQg7TKULZVQloPYdVY3p4AeZ2aWh9ZFLO7r9jOttvKchXW7mYWSLAYyNahK76QxpKEP4yZymkAcSE5exBohxoQGc8OOk4UPowuGgw0IEoPJIVE+8AXqcVYkAvPkWLCBvnACSym8jUp522c56oahGUsGeYCjji6WlWV00DghVkRuhyeZkqJkiIs9uxKt1+D+BYKBpgrfYkhdKnp1Lbu3yzjfHjLn7Z0//evxDgiNe4drKPpX+50WusJYQKeQvcCeNfSEVmT7zHzckBCf5TFbekgkIU3GesvAhwMrp/wztIj2UPdr9E8/QJMTc3DWbD9/SQGZ3lA0gzVA0fgZO72SERV0sa3tOf+gQJMyv2mwHVdIhJV04xf7LpPT7QYfC7AaBWoJ25B461GEbay7kXN4NiMQmRtBFe/qMR268c4TS0Ja1K8qiog++WrQr+gK++oymuUIJZL4Z07gdNJHy4e41LMJrxZ5uiaK/eimML1n/+foGGvc3/9U2JZylLoeqOYaDsHkLbyOjdf7Jeo6ht3JZ8sFiVdM6vjwYoEHisqN1EDBEJombq5p5wnGzkcFmssgUyzybwMbrjZ2m3MJDbyN+5hFoMnY5TuM57rhWh40jnnVndAEhhSlC97tuoqfU4jW4v4e+6DBs/mtJaWAupcml4rxPXIcoJwsag3nzChCZfDtisN7pLxZZXUFXZ1KIV6/8t+QVzSYP+xNwtkXTKMESigZsK5qELGcgD3upNZCIxOtSMWDAUEeKTajoo
 g0u+/1I2
 0Epu4WOaPecK40z9O4YshwzRuE5modIUFfFckXNZkErUvltrGN2MHOPNTULV1ObXnXpQG9RwSz3SvJsu4ppQQfYT3qv9+pE5qbwEwZegrveS2DlEedaPAmIvyFzXmpCEgVu7IfM2s+jCoZ5l0zWpj0IJBc5OFWx+21UBSXmzBwIu0NGguckA2sgtAlisc2h2llKk/3APXhTncKtB5Gg3PSSC3h0mVzMnWK8uNAXcUMXBx0fEvuLtcm8EnCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:44:53 -0600 Nico Pache <npache@redhat.com> wrote:

> We are currently dropping the anon_vma write lock before unmapping the
> PTE. Although this is safe, due to us still holding the mmap_write_lock,
> its safer and less confusing to switch the order of these two operations.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Would it not be better to add a comment here why its safe to do so, instead
of extending lock hold period?

I think its more confusing to hold a lock for longer than we should.

> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c4ea2dc1591b..3c6f1254deca 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1548,10 +1548,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  
>  	result = SCAN_SUCCEED;
>  out_up_write:
> -	if (anon_vma_locked)
> -		anon_vma_unlock_write(vma->anon_vma);
>  	if (pte)
>  		pte_unmap(pte);
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
>  	mmap_write_unlock(mm);
>  out_nolock:
>  	if (folio)
> -- 
> 2.54.0
> 
> 

