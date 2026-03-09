Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D95FCA181
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 20:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5686B0005; Mon,  9 Mar 2026 16:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C4B6B0089; Mon,  9 Mar 2026 16:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E266B008A; Mon,  9 Mar 2026 16:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF636B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:19:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 173B48B4E6
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:19:40 +0000 (UTC)
X-FDA: 84527640120.22.180DBE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A18B4000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:19:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtmHvZQO;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773087578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFCYtDgZNBy/k7iX22hecf0icbSiO/rj9QIWcsJKGDk=;
	b=hync+vXqdYcigC3t4+HQpqHSjzlC0XvvwTkWlEnf41aOX/DhN6y99m+VrSqsTXFUI4di6J
	BJOo6ORHM0ds9/Unb9sMGM0biCz1nnTEjB4fSa2XwhGC1stjltIU1q4s5hRwKFEYqbY7Rg
	HrNJZC9E6dypgFHKroSJZUjPhCcLRVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773087578; a=rsa-sha256;
	cv=none;
	b=HlzPZV3vvyYY36zKG3PaoZAYxPUGI50DrlxXhimXtZ2/k1xQcYVyugYluKjsE6Ql7k4QTF
	4PBczxeG9QYutmqj2HdNekz35ytQXeINWomAmlMa4HTtl5GrDkDFzpnAdY/aXAh9d8ppjp
	IGoi1W1vh/r4x1P2X6JajNyZ0HuCsTs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rtmHvZQO;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6C2140E1E;
	Mon,  9 Mar 2026 20:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AC3C4CEF7;
	Mon,  9 Mar 2026 20:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773087576;
	bh=F4qDOTwlmpMVGOYoeh7zdnEaIRA9urHrMzvm9TRvvyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rtmHvZQOcr65RyUvYfRo6thVlEqEYzrZSaYDahQ3yDf/gi9p3aM6XEUsBwI4I40Kv
	 HOTPVJGa4gr3NQdKRb/7W6D69ePW/HgnX1ARb7ncBFYAkCH84LLTvpuFfTMmKOOBMz
	 jbZGJYPHvykA9p8Fz/kb/oC9ugNndtcy9ofFGdVlO8fGr8zJqPd7wMR048WvjOsQWZ
	 OCzbJ2Tqp3JRtDX57M5uaLmsRrQUE+VV9VQLnad5nWb8ShqIi3oN/b0RWaAuCZi9fm
	 64V0Snonoou+slsMoIzX/0byAF/pOn/9P39aWN8QzoaWaD3bznLRdJbu9rwE1xNjAw
	 UYgJ3PycJffZQ==
Message-ID: <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
Date: Mon, 9 Mar 2026 21:19:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
To: Max Boone <mboone@akamai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Max Tottenham <mtottenh@akamai.com>,
 Josh Hunt <johunt@akamai.com>, Matt Pelland <mpelland@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309174949.2514565-2-mboone@akamai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 85jdd6c9k6s8y7gyin9bh8cifo5qtss9
X-Rspamd-Queue-Id: 2A18B4000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773087577-70077
X-HE-Meta: U2FsdGVkX1/G9rL3wWOu2JXvT3L/3iqfhnlrHMa8Cu5GDagx//b2lf0GEVivtkgF7GiW3JnOVD8FCMZV6yIhdl4zFQbOJRnj0HvyWiX3MJ4wOSqWSvQZNkXXXwBwntPuuPAGvUv/JSAsMcLzug9NhDH6bs5eDAm1qCapQwxT0GDA4UkiT3R99yuqcYrj86mRG9dPE3NWBpVPTlmhBtcjRiLftlVM9uYvMm4Xgxe+6zX1mqruFLNJ1OcLCBe0aP24wqQlzs1Jg47TNuNtzmV7S6Wk7QwxYik9W1MSA3nvyLEU6cfE6M29yEDsak8Jzi6BX5hS87+HOtz6fGbb19cuCIVd3ME1IntjWZl8RqRIYDJV9x8ORKqKzZI3+cUAj14Qea+g0X/BczOquDhq786u+E0t9LwHezOmPZgomSS7S1luFrXq4Abn+PxbmFVdsxjhPcuvdTOY7Z3iAHM1bbt58PQZin6PfRwzexcaz2pRVz44Qv+zCPStF4TiWTB0r7TbFYqNzNvzHhvqCZTGx8GL7kjyfzbjgfzTyQF5xWIVRjQryAgZZX5WR5TUsVq+WZ2ce6nRK6w7Hq3twPZH/PHJVO2XSq2tUYC5k0+VI/wjCEd7ebFK1r0+7N4CbKNCHLGyGY5O+2RGUdO9c3qVWlFy4v8fiFzyqH1Pdc4exzRafwbH1yRP4v0W5WqRm1Bp2UoHp1QjQghLn3XE6qm50KVTZo46QSzHrcjEB4gckdd/+1zAOjjDSNWIN6x0N5XRVTv9d5kjDF+1VCj7q8VadgvXPd9DI82hy+e9cZ8Q5HZMdYbCvaRLdVWCbnpYDBmJytJ6IXmXZ+sjWRNUnLJ3p5kiz4U+leiu/QjYPFqGQVpk5MnjBoIXWnTYf0BcSOS87IYYK5eNMOI9o8pdTaNd+aMyZ2hnO08lQZgcUoyZfYp8Catr1EosAmEyimCHFpZF1wDMQ6Cxym8Kirp9VejDGSX
 lMQZPXxx
 ZsB6ZbBspB9+y+lLWydvfFk0vPNyGK7xauqO8m16M2goJX7k/uMaG/OfrpvJ4NXBCXZRHaQi7G77Q2LIhES0YNbiJkWfGijzSG6DYkiDJO5+3QjmEmTQS4sZyjNeNIpmuWO5yh9xoKMc1M8oBoUni2wH1E79+YI5z8ySDBJ/g7R4mF1YX18lyoDPtt5bIRm4EqZmW+HO4tUbht+1s60vgBXRiJsBCNiWkRsIVDgg86QpghTdwttL4sB7DYQq+G6Hu2TAdaLbyyxSOqIZpkA+mOPotpq638qSSQv2y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 18:49, Max Boone wrote:
> Don't split and descend on special PMD/PUDs, which are generally
> device-backed huge pfnmaps as used by vfio for BAR mapping. These
> can be faulted back in after splitting and before descending, which
> can race to an illegal read.
> 
> Signed-off-by: Max Boone <mboone@akamai.com>
> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
> 
> ---
>  mm/pagewalk.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index a94c401ab..d1460dd84 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -147,10 +147,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  				continue;
>  		}
>  
> -		if (walk->vma)
> +		if (walk->vma) {
> +			/*
> +			 * Don't descend into device-backed pfnmaps,
> +			 * they might refault the PMD entry.
> +			 */
> +			if (unlikely(pmd_special(*pmd)))
> +				continue;

In general, if you're using pmd_special()/pud_split() and friends in
ordinary page table walking code, you are doing something wrong. We
don't want to leak these details in such page table walkers.

We do have vm_normal_page_pmd() to identify special mappings, but I
first have to understand what exactly you are trying to solve here.

(You would also be affecting the remapping of the huge zero folio.)

A lot more details from the cover letter belong into the patch
description. In fact, you don't even need a cover letter :)

IIUC, this is rather serious and would require a Fixes: and even Cc: stable?

I'll spend some time tomorrow trying to understand what the real problem
here is.

But for now: can this only be reproduces with PUDs (which you mention in
the cover letter) or also PMDs?

For the PMD case I would assume that pte_offset_map_lock() performs
proper checks And for the PUD case we are missing a re-check under PTL.

-- 
Cheers,

David

