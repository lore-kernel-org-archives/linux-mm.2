Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55ECEF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1F36B008A; Mon, 13 Apr 2026 14:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9897D6B009B; Mon, 13 Apr 2026 14:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F686B00A7; Mon, 13 Apr 2026 14:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B61C6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:54:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FA8EE28FF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:54:35 +0000 (UTC)
X-FDA: 84654433710.05.490E02F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 64811C0013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:54:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bkvzGnUP;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVk5ADEd74aPQL4pfRXJB+KLfJewXL4p7iOkcl9BAII=;
	b=gxgm02EIHYed1DRLTUnIpoNDb6fw9xMqmYOi5RO0lajtGoI5z/KwvvFnLp7aDG+6uJdnNB
	px/KUxWGTKkjN6Prw4mgE6MPPJiKTm7csqrG+LkJlKzLSzDQVsl5PPYgCw6Q9MXnyxxmrs
	4W3cd5z9y7bA6mWJNob3SDSRwg1GmhI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bkvzGnUP;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106473; a=rsa-sha256;
	cv=none;
	b=YwMZeb9GMynfv+9zQf6ecJ7k0CQsfEDt4DH7QZ9GWMrPe4Ficw1UGm1dZuMQ2BNINAa1xn
	dGkiiB2jCenFAAwnxDG8chfBMAt2yAnhcM+0LxtpOqPmXSUR/TTaCwGyKawsEzTH915dRb
	CQxHxU0LXY8gNWMxKrIa1nQgu98KEfw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C4DA16183B;
	Mon, 13 Apr 2026 18:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3060EC2BCAF;
	Mon, 13 Apr 2026 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776106472;
	bh=cjxZitnjPb4Jy1WAV60ZHvr8PJFLvJxr+yiMh2G9OpQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bkvzGnUPVHwddEiVTSj7OIwi/5Xi6mvV8RZ0xburxFKi6g4MGU0hSJXNNTFmgQU4R
	 8Vmr4eTl5/70eRUeQ/PX5Eny0X70xWzqVk7ZTGTASCiUD1gfF1tnjD04FI/jobAd1A
	 2wQZ/dErxGL3W212VtYOi9AbEVpKlZBe6r8H7GmGs+JwTPg5TCcnaaKvQlboanq8Ai
	 UNMpJwK24W63xz8bFH/0cyOZLML1Ff9V4asquDshXZ83Os7mNYARZdm+NZwhg+z5He
	 QFfggLllVa2PQ6ddSv3ZN7VWMaWDjMLC7JAlApW3bJWfup8CbZST/JOUsY+FujRHM3
	 Bxc95neEkcLxQ==
Message-ID: <08a82aa4-f556-4e0f-9e50-b9fe0a5fb4c1@kernel.org>
Date: Mon, 13 Apr 2026 20:54:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/49] mm/mm_init: use pageblock_migratetype_init_range()
 in deferred_free_pages()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-8-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260405125240.2558577-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64811C0013
X-Stat-Signature: 8shjkbp7rfqnz6ppr98nry1xn5tfcqn6
X-Rspam-User: 
X-HE-Tag: 1776106473-636356
X-HE-Meta: U2FsdGVkX19KsuXWr6xrBtjzMu5XKB3vHn/uEm5nDhgP0N5TDIjZCTXBJKUSPKGoxWlPd+JqsYAKhnYwTt1s+4zog+Hwv5Sn7VL19CT0xrNLwwC7VkntnuDVxVSHRzxvSGwx4nJnfQ6WCfWrSnarlsfszlVgcY6A6y/B1ITS35WhdloDzaJBEXH9MG8ZdE0jkfpWnPDVgNegZt/HVvgKm90qyf48DJ5SzO1vrdCa8rmeIQyS8Bdt3ZAVjvJqYNN5L7Qygm+WKVNzduxbb9br+TrTHU+1oO0mlKktZFR1sz40H9DZARFyZyx+4w08uUUnwFsOnkgC5INupUq/zlrBsWnsLHv2mVINBGtOFdHgMKNoIxKLX/tU31IRIFoGTNrGvZGtkiyAePyzIVmf/Q+Lz2sJ7F/W1J1+rIINREiAMWd2NKIupwr42BL50AuWySwHtacMr3Ctt8wp9exYePkjfpJYAcSgmeq36WgReblHg0ybPiu+qIAF36ThRcAV94d/8bZWVl2NWVeYTcZfrJE+lBnq7cc2rJ4SOMqL/mD+pjQa29IkDePfGwOeIVjD3bngF8Tu+nVjJ6HjeIHAdTDuVpaDuBCncWeIxYksapf0UvcHcjo3Tkv26jRdr2PRXVPf6i4xpAcWoS52zkJrvnnP2ZuckQLPOjoGxIHUMN6lx4xclLze7a+T9eB88R4cq7P0B+e3eko/pwTq/NKq7ESB6aFhK3kLybylmpmp++5GUyFpYOJFjEwrRr4KWxK2vsKmTJ+NBvB+2rDbP8u2hXibxF+MZ6GB6fDGu2sGGuJ5ZI9fnaqfz4qysDAJ81gLnAs9h3Y6cugo2wKBGx+zvDG6tbVYZZ71Buc/O1Ad73COImaTghnV1W2WwCSk4uFMbj/GJUcCe8TMokGkiybyi26WdnFBOnsfJSpvayMceZlrRh/qChtK7efrMWLHrHtFQmbU7WA7miIiM0KyK+48I7c
 lCmgJKKA
 OTGa5UENQUis0jTEHGbtjhbwR1pW4GgQsSoSo6XbUTKHTyGpgbPa5Qz0yHhVU5jmrGpHBVNbYjf/fKNId5OQUNFc9PwKtlVEoNbYLAjG/tziqG8aLGaXEjin1OcMhlodXndv6Gi9usmpWEuO2utMx8xnfn/KhZDoWIe7FwrCwV/q5bq9SLlvIUFB6VATn3n1JH3+Fiy1/hP03GTrKlOexfV0WmL/X7TbaV7ThltPrL/KEuFLCdB14dWO73WThhHDY552EEPkSZtGZrHA46oYCJWk6ZwjVIaDJs8ZEXGqSlODhQvk4lAbAjTXj6LvsXsJXyBbt3Sd1jyJ8Aag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/5/26 14:51, Muchun Song wrote:
> Simplify deferred_free_pages by replacing the duplicate loops for
> initializing pageblock migratetype with a call to
> pageblock_migratetype_init_range to simplify the code.

"Simplify ... to simplify the code."

Likely you can drop the last part.

> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/mm_init.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 4936ca78966c..a92c5053f63d 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1974,13 +1974,12 @@ static void __init deferred_free_pages(unsigned long pfn,
>  	if (!nr_pages)
>  		return;
>  
> +	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE);


pageblock_migratetype_init_range() will align the PFN up to the next
pageblock.

Are we sure the range we are getting called with is always aligned to
pageblocks, such that we won't miss to initialize the first pageblock?

-- 
Cheers,

David

