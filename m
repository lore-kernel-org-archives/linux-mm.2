Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB19CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 03:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5986B0098; Thu, 25 Jun 2026 23:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D3D6B00CA; Thu, 25 Jun 2026 23:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DDA6B00CC; Thu, 25 Jun 2026 23:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8576E6B0098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:40:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2AC58D484
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:40:33 +0000 (UTC)
X-FDA: 84920661546.21.3DCEADE
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id B5729180008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:40:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=reozai8T;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782445231;
	b=3v59z9LeUJQJSNfJmFQJxboao852iUYhnHIbqtq7/mpqPuHD0EYOAzvFW85t+h16B1vgGg
	AJoMsa4y+WrAiuC3AEzTWs/RE7AJvdabqXWSkl0LCIidsdcZccCi0ro5x3miL7tH08uy8P
	46ft3RsnW8xZkPj+CLhM9AQSaX7GdBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782445231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuVdpRIguPMFSlXQhOOtEgFq7gSJAyQxVrZOCwx3KkM=;
	b=skvrdJuhoWRNBeGartUcH2khY2Tv2VxwyG66EjmTKdHM8EZQTlVWeNDwujPfUGaib2jsF5
	eYBVlX7iEfRlgdeoRfMloPzB+sE2Hh7LAXnZdCuGi9qhPPnK1lUqL5E4YVM/qt1wMZwhzE
	vUB01XVrtLLarvJWop/gFKUl0lVFPvQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=reozai8T;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <28f75d0d-de54-43a1-b46a-fe3dd1188929@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782445228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuVdpRIguPMFSlXQhOOtEgFq7gSJAyQxVrZOCwx3KkM=;
	b=reozai8TTI24Te6z59/Idhy/4ExwpoKf76qZ/QygeLqLnuQaqt+53ywcl6JtzSMN8/yEoT
	hNSB+NcGUreDFseQjyBqyhDgwgmftLUFFTH0OhkVJxOrWUydco42qggU6eqoewmaEhomQR
	lfwAoz3mnILobNZHkWC1MDxCAkqScBY=
Date: Fri, 26 Jun 2026 11:40:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] mm/mprotect: use huge_ptep_get() for hugetlb
To: Dev Jain <dev.jain@arm.com>
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, mel@csn.ul.ie, nao.horiguchi@gmail.com,
 ak@linux.intel.com, j-nomura@ce.jp.nec.com, pfalcato@suse.de,
 dave.hansen@intel.com, tglx@kernel.org, jpoimboe@kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, david@kernel.org,
 liam@infradead.org
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-6-dev.jain@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260625112955.3254283-6-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p79irdhz9pt1wpg1zgdb6u6rruygh4sw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5729180008
X-HE-Tag: 1782445230-941464
X-HE-Meta: U2FsdGVkX1+xUBIZdqXLTlzuiHQrefJztjfxqdk3eE37DXta27AWsN351x9xfmOIEFE5xT3xH82cRAEBBfu+uDMM/riwRgjYMRJ0Bt7Y7TO2sxwobfDXtnaSTXfoJRJvGJuzGtw9/8QStYNMGi6G/bQVkZHp6aU4CRlaj1ynNY+7BHhsYW3IggYQ3Xs0LXKGLaLWw8xbGYvS+eo2T8qKRQ9HkZOWvl5cqjSOQtEF2ySUmp4Nuaucm4vd1w4icRBbWidj2dTE1a/KdEOEgY2Q1sAlKH8EjptzA/1QtqcLk9JydHYLsAOO7hpGxCPR5ZoBFvwpJv/LTAdCaSAAkg1vN6GgkVXgm0FUNv0JNEUR2uU4LezB6zDc8Zv8Ld2DAb3aJvBDtaAMktW6TkwJY4gNEV/E3iyHd8SCHjjrHKM4fCo6VqOVCqcPP67QEMT0Nu4skC6v75d2ZhI4hFgNrcKLOoK0irSVw5c9jyfWujUrluzhICnJFOEf+xSQ5g+RQRjS+uA0XZcHTKmUuDNhKbTD8zCZyT3pEGU5lqboRaePEs7kjEtthykqcNd6yWk+BA7ccuf25P2UNSdSWzOj9IThWtGnjtpVYPKosi7i9S3kREl87kIySAZTzv0ooc6UN2W+Fxp+G4x8eUe9OjRyCxgUhYkA1wEiMS8gGO4OhyvSaj59haguTqXw0VcphZdcMzMK3Km+4Z6uZFKm3Zqio7Dy+kK7KxGbBt1djCY+ycu35gvlU5gzJT79vOa/9voZdgdzouOVZq3G6qdsSthgjSaF3Hym46E0Xz+9nSZ9CpszU1EzsCnCI2yJyM15GkRIcldK1rI1C4Z8PmnQco2cmiL2SBhDHL6rig5SqsWRUdaIHaeG1ynkYldHP+skc99QMHZjzZRmzZ0YMcVyresWcaOSwpkfpJfO73skLNGqXZHaRcG6zAmVprTh9/GOAcwMdCYi4GT14HSbiFWdFhoNlL3
 490Q8DGr
 vWrFHvHex6CllFzlE1YxKewv6lNxOOp+iickoDj6cMofx0cq5fYqGGeBK3mdStvFfxUBzYGESWmpuWKbMRGTqW0vLzH5wVy/fgIqFqfZR1hb48kByJB8i5qcQa8X8gmz1GXKFEA409zvCNKmYOokSTxI8Z9hxnUm7/KjdVKYEOIplPWKuPOxRD8etbnkyLrj8d8h8i1wg7tpHRVow72SEjv9wY8EATU9M0FyOozgtyZOz4AcNW8WDZHWNQuYuDy2L4MLHm4i18Mjoi4PaHI0syDwyaRD5UVx1mnI/qpPUTBuPKx236JEZ/xZ69ouS5gBpcwPgZYrb9f9as5iEugqrEkDEsfW6K0Dwjfyldii7Oi/q5ntM2pG9irdRmI8iP8CpAO6mK72K2cu791az4nLfg1L3Yl50MVeYaJ7wyuK+o3+FYCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/25 19:29, Dev Jain wrote:
> prot_none_hugetlb_entry() is the hugetlb callback for the early
> mprotect(PROT_NONE) PFN permission walk on x86.
>
> The callback passes the decoded PFN to pfn_modify_allowed(). For a
> hugetlb callback, the pte pointer refers to a hugetlb entry. On
> architectures where hugetlb entries need huge_ptep_get(), reading that
> entry with ptep_get() can make the permission check use the wrong PFN.
>
> Use huge_ptep_get() before decoding the hugetlb PFN.
>
> Currently there is no path which can trigger a bug: huge_ptep_get() is a
> simple ptep_get() for x86, and the prot_none walk occurs only for x86.
> But use the correct helper anyways.
>
> Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>   mm/mprotect.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028cf..23779632d18bf 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
>   		0 : -EACCES;
>   }
>   
> +#ifdef CONFIG_HUGETLB_PAGE
>   static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>   				   unsigned long addr, unsigned long next,
>   				   struct mm_walk *walk)
>   {
> -	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
> +	pte_t entry = huge_ptep_get(walk->mm, addr, pte);
> +
> +	return pfn_modify_allowed(pte_pfn(entry),
>   				  *(pgprot_t *)(walk->private)) ?
>   		0 : -EACCES;
>   }
> +#else
> +#define prot_none_hugetlb_entry	NULL

This is very strange, because we defined a stub as NULL for a helper
function. How about  the following diff?

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028c..4d8c1551fbce 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -716,7 +716,9 @@ static int prot_none_test(unsigned long addr, 
unsigned long next,

  static const struct mm_walk_ops prot_none_walk_ops = {
         .pte_entry              = prot_none_pte_entry,
+#ifdef CONFIG_HUGETLB_PAGE
         .hugetlb_entry          = prot_none_hugetlb_entry,
+#endif
         .test_walk              = prot_none_test,
         .walk_lock              = PGWALK_WRLOCK,
  };

Thanks,
Muchun

> +#endif
>   
>   static int prot_none_test(unsigned long addr, unsigned long next,
>   			  struct mm_walk *walk)


