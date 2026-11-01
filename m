Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73253606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xY+HVFBq
Received: by kanga.kvack.org (Postfix)
	id 77A586B00EF; Sun,  1 Nov 2026 01:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72AC56B05B1; Sun,  1 Nov 2026 01:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618E56B05B2; Sun,  1 Nov 2026 01:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36AB26B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:31:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9A031C4167
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:31:42 +0000 (UTC)
X-FDA: 85385579244.30.EBA8AD3
Received: from mta1.migadu.com (out-105.mta1.migadu.com [95.215.58.105])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3953100002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:31:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xY+HVFBq;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.105 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793514701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/f/Ic8iNRBscTPM/Roy1R1y5UupvBWWJfdvYPp6M38=;
	b=dcsCk3YVSmHCOwgqWWNG8TWlGnH1UKasboa9R5OhXo18uRmv557EtLrksqtVP2dy7ZPF+j
	uthOztaMmiTwxpH9+J4D6I6Wm9oUHcBfNEyE3aIp98PZzl3znbM+JEit5YfvviqVzKxf8p
	xARX8OHV3M+IdiOYBBVC1830LBGTreY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793514701;
	b=OBJuEcu2y2VlXv+wllgxyyfNzgujNHxomeXqILi1jaGiObHWQPtW2NLIcHfqJEWRdUgkaX
	SmSpZeAmM568Kk31+qD9DfIaJG6e3QM1LOWMko5blmwbDaEkd3FocOA86XIWzzoKDoQGSB
	4ZpuyMKQY0THlUc25KSEiTYijHgF8dQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xY+HVFBq;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.105 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MQQBK01CLkmuEldY36FpAZR9pIhbrpe/1CRm0UOIKVA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793514699; v=1; x=1794119499;
 b=xY+HVFBqLlL29sSlrtuRKeI04WYPdqOOYeX/KNUAtfX3c07DyoO6W0VNhOpCy95Jp7sUzoC3
 eofCnKq9srkbprjgFaMDAzpGHPTPMtTcjDvGWNZ4gk4eB09LFzDOEivHvFWo/EOOvWci8ghNCj+
 9oQG35VurhFDKW+oduG9lJt4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7f876ae71b4a29e6;
	Sun, 01 Nov 2026 06:31:39 +0000
X-Mizu-Trace-ID: 7f876ae71b4a29e6
X-Migadu-Flow: FLOW_OUT
Message-ID: <587556c5-389f-4616-99f9-f0216b72f112@linux.dev>
Date: Sun, 1 Nov 2026 14:31:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page
 handling
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-2-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3953100002
X-Stat-Signature: ypuzqmzngn1qas3jgpg1yrkk4pqxdesj
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793514700-774704
X-HE-Meta: U2FsdGVkX19+9eVCMXrXUl9Qbu0PkXmNLI5MBtQvETerBd5Bri48HIqD48JFxQaN8KUzc2pJ7pfgNrWFzCRmGMuRQYaqlP5poKchXHWKe617sclrUg4IR5aczqbcD389zgCADHi6/uc4oNhlbxjafC9GxBA55hYS/sDYydVDQ2ZQrXvfk30/HpJ2/3R7Yoba/OtUR7o3tXhygYFjTq71WAeJ/eBRPUumAMMagPrh/hsH7CnKDiTYs38NfkOZHNMdUAohp1NsMpQ//Yme6nkNXyZVNv8uP0RRuFEZzLn5OwAzfijAMAsale7EVbOUpI7phDkG2gINgaUsOML9pjfGMy7Ucyb+G0hR1Bj6PuRm0TRfd9ZcEdBgA90rsdptpezpRYahIgfzhCkeDIy0of6KD5NboJ3fv3h2ZNtYhe/ypPu672Srp3HdD5aPzM0vRxefZ0p1+ySYJXvv0FIiLBwRgNVpLiikQXLioV5J0xbGZG9N15UwrGuyw9oSpqy4EZHuK5pTqAQtZaWt//aEr6Gg0VpErfkJzuUXWJ2SyWY5FdDtuu/0JJ3m+SfkK3Oz7zdd9l0BQvBnNmkUPMiZg0Kux2joF1V4whmHDlrNMUNTmLgI18svBXzyCZz1wYjrDI/5oWXPWQvIKisCu8uOYmLmTpSTg5VFu6ARsgUGLInDMUFZ0eL7cx3xYXqeUh0P4rNcvZ2cxbP9H1wZ4zmkUml5SOxxMtn2L3Avv4jMXfRW1aoSl+yaI8+Ob9D6FQZLXGgaJnOfizVr/PLEEk6CXZEw13Vv2XKTRSgaJwzfy5X9hLMRlO/MOPYXSRnz7KyJ5PSjhO2wvl9aD4XqrJ9KF15Bci08oUr2oW412ltf/vwrOZMpbNZyO+NEpPXwoOHPoE3/f3LCkKfWaG4iC3JI99ro7q6rjSTgzhktze4jtt54lHNyfOpOaZpR+FM673g8SDtPSBPKFk6jrh6GscllqQD
 AJGl+WVZ
 bmVxLqoLrx1KIAFENIWiA2NlZzreSqFR8lOQcRkX6nUJVoBIeXtJBon0VSFTzmRLWB538fNvamRfgEYdgUFDUq3IBRE3caoT1TulmdyHnV82xQjhOPesbbTLg3ZIdJtwbcH+aX+QrHqCpUbt4E04gK4wXcoJHbAHUWIEkI4M4D6uOhhX0TXULeZVOb6BfPhr8lVMskFe0GiHfUl1ZkQc8LZuTad5S9bcxju6THH97sP5hRrjsD8xMfeI44mclpl/jZUZBmC3pHFr9niG3oiqT2JibtdwdFrkl/k0a917vaRLCVLAjJz1GSvqjZE+QvOGlskBmRJLpwAG2swdu5Y9CoS8mYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> The new head page is already tracked on the vmemmap page list before
> remapping starts.  Passing it separately gives the remap walker two
> ways to refer to the same page and unnecessarily complicates its
> interface.
> 
> Use the page list as the single handoff mechanism for the head page,
> removing the redundant state from the walker.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 17 +++++++----------
>   1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 8b3abb562599..164e93e980bf 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -25,7 +25,6 @@
>    *
>    * @remap_pte:		called for each lowest-level entry (PTE).
>    * @nr_walked:		the number of walked pte.
> - * @vmemmap_head:	the page to be installed as first in the vmemmap range
>    * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
>    * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
>    *			or is mapped from.

The @vmemmap_pages description may need updating as well. After this
change, the list is no longer only an output list for pages to be freed;
its first entry is also consumed as the new head backing page. It would
be helpful to document this input contract explicitly.

Other than that, once Lance's comment is addressed:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> @@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
>   					     struct vmemmap_remap_walk *walk);
>   
>   	unsigned long		nr_walked;
> -	struct page		*vmemmap_head;
>   	struct page		*vmemmap_tail;
>   	struct list_head	*vmemmap_pages;
>   
> @@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
>   	pte_t entry;
>   
>   	/* Remapping the head page requires r/w */
> -	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
> +	if (unlikely(walk->nr_walked == 0)) {
> +		struct page *head;
> +
>   		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
>   
> -		list_del(&walk->vmemmap_head->lru);
> +		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
> +		list_del(&head->lru);
>   
>   		/*
>   		 * Makes sure that preceding stores to the page contents from
> @@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
>   		 */
>   		smp_wmb();
>   
> -		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
> +		entry = mk_pte(head, PAGE_KERNEL);
>   	} else {
>   		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
>   
> @@ -289,7 +290,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
>    *		to remap.
>    * @end:	end address of the vmemmap virtual address range that we want to
>    *		remap.
> - * @vmemmap_head: the page to be installed as first in the vmemmap range
>    * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
>    * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
>    *		responsibility to free pages.
> @@ -298,7 +298,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
>    * Return: %0 on success, negative error code otherwise.
>    */
>   static int vmemmap_remap_free(unsigned long start, unsigned long end,
> -			      struct page *vmemmap_head,
>   			      struct page *vmemmap_tail,
>   			      struct list_head *vmemmap_pages,
>   			      unsigned long flags)
> @@ -306,7 +305,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
>   	int ret;
>   	struct vmemmap_remap_walk walk = {
>   		.remap_pte	= vmemmap_remap_pte,
> -		.vmemmap_head	= vmemmap_head,
>   		.vmemmap_tail	= vmemmap_tail,
>   		.vmemmap_pages	= vmemmap_pages,
>   		.flags		= flags,
> @@ -547,8 +545,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	 * they can be freed by the caller.
>   	 */
>   	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
> -				 vmemmap_head, vmemmap_tail,
> -				 vmemmap_pages, flags);
> +				 vmemmap_tail, vmemmap_pages, flags);
>   out:
>   	if (ret)
>   		folio_clear_hugetlb_vmemmap_optimized(folio);


