Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7171D41C12
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 09:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437706B0005; Thu, 11 Dec 2025 04:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7E26B0008; Thu, 11 Dec 2025 04:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325B36B000A; Thu, 11 Dec 2025 04:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 264336B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:36:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA0685B760
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:36:33 +0000 (UTC)
X-FDA: 84206685066.10.E19C5EA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 18182100002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:36:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765445792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gq+E1TioMkRyWalZWYlhGRes+OzspdwoZs3/fVyyf9w=;
	b=hgUSr8iqO0TH/8PJKEksPwNJ7nncKJ8LN7DPmBUS16R+lhYdaUDPYwzN4aatt9Xq9Ek0i+
	iDgbU+T0ng1M/6b3PVHU1eC6V8SSrmkaR0C5UZdKjxo+FpKI9/9zoeQJVvuXTYLaZC5Trp
	/W6l5vNImaqZvTJzpUgc0LzyK7okQFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765445792; a=rsa-sha256;
	cv=none;
	b=fHJO+cQ+gskSyt56Q7A8hsVRpAsTNfvpYvbmPsbjohYokxqgQdDi/GAEvlbfOcv8l28dG0
	RZK3ZhqD37BUEiT7b4ivEpVCQufZEVBuKBSem2fUW1Ifejju89Qmk+PGPkw03HBkLo1iJg
	R0sMkoL4tEPe7lVItzfpK98Dv2dNcSo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0563B153B;
	Thu, 11 Dec 2025 01:36:24 -0800 (PST)
Received: from [10.57.90.205] (unknown [10.57.90.205])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B32D3F740;
	Thu, 11 Dec 2025 01:36:28 -0800 (PST)
Message-ID: <12ac22e3-d943-431e-a3da-15987fbb458e@arm.com>
Date: Thu, 11 Dec 2025 09:36:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/debug_vm_pgtable: Use set_pXd() to write page
 tables
Content-Language: en-GB
To: Samuel Holland <samuel.holland@sifive.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Anshuman Khandual <anshuman.khandual@arm.com>, Gavin Shan
 <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
 <20251211081117.1126521-2-samuel.holland@sifive.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251211081117.1126521-2-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18182100002
X-Stat-Signature: pw9btzdu4xhc9tqwahj43ra188hjcbnp
X-Rspam-User: 
X-HE-Tag: 1765445791-245674
X-HE-Meta: U2FsdGVkX18q5MeQriEKOSZHo3zom5Ce2rhImSDCwL/pCyDSj/t9x7e6gQzZyVeJB/hTmOre60MQj4+RfaLMptyIHgI1Vjmsi5EhVlGzX2KzW9YVQERMQh9HooglwWsxLrIhnpBK0cd4PDD+mPJKPFitm5Y/FycS8+PCOTwnGqBtQ20iNx1ycbt36Fd+z+0uwAcKVyYfvP8+087DG6cssqrHAK2a7P6NXThzpGzXQeJjsEU0SVJ42zUwjAbYhhK8AGgY8NIddMb9KEqjZ+7ZpG63rkbEZnzSSjhA+P4+0D/uwQO9oFpqSOALdnd0UGfkdEtCq9pSf3XDWi0J6pZ1fP+u3wbaodw+JcoHl+RS4MLHU8xbuz00Z8M80F80k34ySNHZXlCjHPztcy/p2dBMMvBVtG3zR/a2g1xZl4FKuV5D0qNKsCfxHPGkvbsGVSTaa0IzSBN5iJarK+RieJzuIpVwGolqWOFNk5RSLqHixyoTz1OOerNPXUYC+1s1y41wx93v/CLTw3QHTZeXn0sDggunMBDapTgW8eEPLKrtzaQy5f4tWHpWIeZRjzc243ys7b7wICZFz/6o/jJijsk+24hJNrsS2HUuSnTKCf+lJaZeXOJdQ+ExPRJhsM49GKC0fUScffUyWfzJQaMCB1HAozT/1ol0MYaTRrM1NgdtBW8qRaOz9HdVpXCdqUQTdV8T8PJOo3KWg0yDz7ivZI907NnL4c3z9sACGOVJZ68f9qw8Pcw2zBbJ2YIRmHXoNUuXwbnQnV4rWK7yzHUFQnnUlakCQ/yU6gJyQfJ26ZycFIO9DmUCEQo9jyDNgBnd+Jwzg9I7CO39X6YFoGhdMsqMfDOeXWflBflWmEBpyROL+Xar7tCMxNYrdjnw3xKqK6p7is/MrlMg5iY2elbm2odng+AmgPSRNVcsoRQKAa3YK0T+PJtHloR8rbSfVS7c+F/cjiehk72koj3y317vZhi
 zsYH+B0+
 GqEsyyryrZ/wfb7F/lSNk0c26NvKw06y/fliTd6NmdtcAPHoI0Pexevg9tgx1AcTXCtLv+UhnERsUcGQzkI1CYjs5QrxbWrffk/PTHaQMsZgCbrU0AZL+0L3ysWbfL7E0wIelFALXyUlwszI8U45vDGpQsKHX2I1BSDvXrLimkJdgxx/Cv0FyJeSGgtHjJzCVd2ObmAf2D4ZoETIOeirWoDZtpS9K+oDJWV90FQF0bdWccUVoCKazcMSa6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/2025 08:11, Samuel Holland wrote:
> Generic code must always use the architecture-provided helper function
> to write page tables.
> 
> Fixes: a5c3b9ffb0f4 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
> Fixes: c0fe07b0aa72 ("mm/debug_vm_pgtable: use struct pgtable_debug_args in PMD modifying tests")
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> 
>  mm/debug_vm_pgtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index ae9b9310d96fd..8c7996d6c1f2a 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
>  	 * X86 defined pmd_set_huge() verifies that the given
>  	 * PMD is not a populated non-leaf entry.
>  	 */
> -	WRITE_ONCE(*args->pmdp, __pmd(0));
> +	set_pmd(args->pmdp, __pmd(0));

My guess is that this should actually be:

	pmd_clear(args->pmdp);

As the "clear" value may not be zero on some arches (see um) or there may be
more to do on other arches (see arm32's 2 level pgtable).

>  	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
>  	WARN_ON(!pmd_clear_huge(args->pmdp));
>  	pmd = pmdp_get(args->pmdp);
> @@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
>  	 * X86 defined pud_set_huge() verifies that the given
>  	 * PUD is not a populated non-leaf entry.
>  	 */
> -	WRITE_ONCE(*args->pudp, __pud(0));
> +	set_pud(args->pudp, __pud(0));

Likewise, I think this should be:

	pud_clear(args->pudp);

Thanks,
Ryan

>  	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
>  	WARN_ON(!pud_clear_huge(args->pudp));
>  	pud = pudp_get(args->pudp);


