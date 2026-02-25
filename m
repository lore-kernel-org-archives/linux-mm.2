Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C08BF5545D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 05:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A396B0005; Wed, 25 Feb 2026 00:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8276B0088; Wed, 25 Feb 2026 00:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4356B008A; Wed, 25 Feb 2026 00:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 295F56B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:53:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C057314047F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:53:28 +0000 (UTC)
X-FDA: 84481911696.29.85D5BB6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10D4518000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:53:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771998807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xcnse+MgG/vV7O8PnEBPcGrdSo6tLe12LSghuY2hApg=;
	b=i1256loIs3PO1xpOZrWu9LXqFKWgWgBlvmowWXLipbj+n1BNrwGEU3er73QsdCwnbZAo49
	Hmo9UVE4/7H9dJlFFeM0yhSVF3si+Q3DH7jg8jqI4Rre0PGYGtBU/G0dT7k5Od4KYWieq3
	UweLs2ePnEIyHLa3pmeN2klJuUzDXUw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771998807; a=rsa-sha256;
	cv=none;
	b=mFd5oVf7TrJOm80e9wEaDkCU/DuPLx8j1knCFJamFj5hIN1YqeOzDeR4vIhU0w7xc3Dben
	fYLivZviKZ/wsOz1wIKgGe/OvJwChQfhRy3Vt1z8hWIPsHWkRjo/TK2CdKfN9DHpDbkB2U
	DUnhRBCgovyCyo9FYksSljILKrGIcLU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7C0B165C;
	Tue, 24 Feb 2026 21:53:19 -0800 (PST)
Received: from [10.163.172.18] (unknown [10.163.172.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4F3D3F7BD;
	Tue, 24 Feb 2026 21:53:20 -0800 (PST)
Message-ID: <72855b0c-5bf1-48dc-b4b8-a04f8ac34317@arm.com>
Date: Wed, 25 Feb 2026 11:23:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
 Ron Economos <re@w6rz.net>
References: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10D4518000E
X-Stat-Signature: xcwzka6iqd691dpxfndkf5ace6oq4jkb
X-HE-Tag: 1771998806-185502
X-HE-Meta: U2FsdGVkX1+mz8Ps2ZY1zmAX8pL3CofSwd6gNgXVGA5XH4R3U1uqvI2JslLYYR6HEwpi+LDMr201RX7bqeYsbzZ11eBhUHSAka0gKlOQvco0ld+/gr8SiOkY9KQ4uk0gA1ymkAcZn9XG/DOISTXK1PHwbPQgTWdKt1ZlmGGfcPYjIdl6I/YitsRb4Iqz2QQeA8TTctuLg0oLD2j6KlYI5S84XdSY4QYu4vkgBuKverONNdhCMRXJMYuLxYHAqHldlBSUdXq/Dah3hx2OchxS+I5jLdN9jlaKC4I26VS3hRwtnMCJo6SASei4goP6pTEU0+EDY1TBDzzO2HkJgsm5WD2RJzT74GAV7v1mGz/GCYSaVdA8SGrZ93jmQGHLNEz4//Qfau+vWKOcyInmHNvA1VI9xpBa5pdobqmI/yidbEgZKTLgIRAEkgif6ZXCtUOMCayyMllRyvxN11ZHdz1zIXZi4gbqS0AbQf65O8Lf2faMAggf/3HRjDBEA37QEyRbUMqtzD8jky8ins4wSh0DyifqHgLwPla8L/VTq63mQxEKWn06Udc3YzXow5lYvRRJ2NeULGtm0NDMfL5o26c05ymEap1IvagxGrkePdJI2pfmdpyq43VPjI71oQBrPQ+xJPTIPHbEyjnm6b+DX77ZLgRHWpWywjGC1EnFx6LLOV2Y/v13gF2H7vPM3K9mut2dD2Pcfcnv4Zchb6TnTbjjKCNv5NfI1xXQsZd8f1M6sI+wVot/xYrLqXr+01PvQLDIbYu0OD+ENEHti2yvOnOALlgeUNeT0Kt02PsZVVQRJmuq1c6DVzEpTJ+rh9oK900ay13jC5hEgb6dQfHM0o/ZSLcbWzCdhgngiCaOD2Pccn+7R41uUKnTnsG9VrgOjb7nLyYN5Wz3nqpo6/lbWzSFp1tMmhXQqdq3klgct9aEwYTX1P5riZr+qhCtnLrM0RuxmtfD4blV0Sr+MWcLOC9
 BTs5GFGJ
 QAhTOJ6isDLhPreb1PwuNpYucXlV2kkWVHl+91K0lbq2AIzc3AdnOgFAXzKMV2H3g5kpl2PamHTqQVRUVlfw2/ah9nhhT8mJrG2ihBBZS0BQt8urwyvp2fFtcwTBnKxgJIWYriJ5Esj80mTV64AZJC6KsbO7OzDgfGS5fUfvMExgmclOhQnWTWUuMNKdejK1EYN9uXjoe/iBe7TJuOdGMugpUyZeD254bhLhtw7QI8j5gpbbbllENG4QP9qbnFpj9NBiV8Ir5y9CBIIlm9E7adCaVzL84ajVakzfg5H5Yl74JGmTPAC4Skz+8WL7+ycpziesoHqT3Bi2V0ULzQwcPUdJuPpyiHQ97KdkDnNaECj6WJoCezNkBBF1wAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/02/26 8:42 AM, Zi Yan wrote:
> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> From V2:
> - Collect !put_page_testzero() to get the right result.
> 
> From V1:
> - Collect all put_page_testzero() results and do a single WARN after the
>   loop.
> 
>  mm/cma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..15cc0ae76c8e 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  		 unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> +	unsigned long ret = 0;
>  	unsigned long i, pfn;
>  
>  	cmr = find_cma_memrange(cma, pages, count);
> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  
>  	pfn = page_to_pfn(pages);
>  	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +		ret += !put_page_testzero(pfn_to_page(pfn));
> +
> +	WARN(ret, "%lu pages are still in use!\n", ret);
>  
>  	__cma_release_frozen(cma, cmr, pages, count);
>  

Makes sense to make the above warning unconditional regardless of CONFIG_DEBUG_VM.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

