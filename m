Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BE5606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VhokyNrA
Received: by kanga.kvack.org (Postfix)
	id BAE846B05B1; Fri,  6 Nov 2026 10:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38DF6B05B3; Fri,  6 Nov 2026 10:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02856B05B4; Fri,  6 Nov 2026 10:34:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6FE6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:34:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E9D240D1E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:34:21 +0000 (UTC)
X-FDA: 85405090722.29.E4D5301
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0737912000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:34:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhokyNrA;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793979259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UAbQu4Zz7jM5fvfnVPIQRW8LGHO6T/qo7Hc+AehbY4=;
	b=IafJvN3RdKTCi+aEDyzwpx6QkBP8hGU7HuunTFhldH6+TXvCId0VikG7tp56AZmY8vu2RM
	AKrJRvIg2X8shm84eFPaXxwdbcDOcuYDRNc6vsWwdHA7nLk99dF/1Fv9aSV2BQ1NLfR1K7
	ZuOYNttb24mveGsyW1LKXgt6VZC1y/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793979259;
	b=fHAKikB5ETucpbdkTwukkjaUzO7Ws36dsoMomUsSLxra3+/JiNZQfTFwc8o8zxrIahUGKM
	7O/vQvDHyfvzdMkZW02WCYvK/qBK0/7t+vewlZKESioBxX7R0DMq6ZwJEzKn2a+83lOXhA
	4j9d+sti+JdLidcU25qer7XTr4sGCAQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhokyNrA;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4IpYDm1JeTeVQryoSNRzjLLGuozzk6CpKr9+AhGJ6uY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793979257; v=1; x=1794584057;
 b=VhokyNrA9rO/IiddTY7Qj6x7ba7aZUn1FKhs7ajCtrOgaJAPnmZzejHHyYw4UfLOAiH5bxP+
 4EWVftLheEtm70YmUWkm1Px7Rdi/ZpK1E+FLUi4G28bspY0FLOVM838t2GYXE+DcjLjAXlIXX6y
 nSKJFHy9h74g1jcO9X8vu3GA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 1c7542236927aa1f;
	Fri, 06 Nov 2026 15:34:17 +0000
X-Mizu-Trace-ID: 1c7542236927aa1f
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: free unused page table allocated by do_set_pmd()
Date: Fri,  6 Nov 2026 07:34:13 -0800
Message-ID: <20261106153414.2938216-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: nzciahzp5y5dw3xnf9e6fsn57xh5iai5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0737912000A
X-Rspam-User: 
X-HE-Tag: 1793979258-235294
X-HE-Meta: U2FsdGVkX1+vcWfD6hcTgPeeFwgtrKiynY4Ydn3yWjFZJ9udVeQEBr3qsYlQbt3szhK+nWCveSp62a9ZJ9WFZshZNo4G7lS9ZOcUhxEbibZSPGVoVdfW8vyeKgxXB7Wv4GTi4ItR5EyIw0ktRwBH1fSZuiRkqp7tQ5PbdOLhtAIjRjDV/uDX0r1qqSZj43My9Z6+bi2N/bUp/mLG2Ph/tFUDnQs3RR2wYdB5L0BiT/snAhImj4rUDKLpWB/uy0c+uZkRMD8W+nebGIZtBPLGH2JB4n2bTqx7sq0nc40uzCl75r4a4TSduvVFrtG0qNmUg+Oj0OOfpBhpgBS+pY0D7gdk7OK1RlurFktqNUVaK/OP0iSmWrm8DW8N5xJ6cWJrJlq/juAV8vZpSGLHRjyrEVf0Mt7Cr86Rcs7HFYRGIuG1Y+uqKq99u1Awor9J5TySTgFKAmK5hGDypUDQ/TAUJ8EMIYOke/tTCykE39cPF15hDj3tt398QoKRqaNn20SfhKSEvFG+pFJF90w4FEbnITwJJyqc2p1exI5tFTcVKLtDWxrb5rB99YoRTsHRIf/kv8+WU2y1j+XbkItLnKYUMuc1vRsUZbIIs2ZXCIW688RZsDVxx4piUOCOf59XXAPvUQM8DA6yGDOE19vxwdZ4HXaapb+R6D8RPo+mVDI/37QJYn4mE4KFu6mml5lejtJWtgcxHWSYmPoX7p58y3JXdjiYaOIEAMZlWICVnXpRexiNpdwVW7WzrxaIkkQBlvJaTGSuswVD6gLXXiURhMOHWQElldRmeJ2IJxA7UkwYo0MLGVXPRAmnmcxpk96NSqef6+f7WOvVkVu6Fizd/ZbUQLe9SvdeX8zlSmnBgLoFdh8UiW6hs73ud8GX6VtfgKfTDozT0EFu3OeEHpc2KXzCSNt9WUAJWyLc8ea/He+JntsMKt42PeIiJvrPRvEEQSIc0WQ/W/2xye7suVJEJOY
 8F85xz2n
 yep1pyCGVbqfgPuhzgTfr2fNegZDESlZjr9WaW7PUfpRDB8KXV95pJ9OLlctIfjJ9M1fR29cYdZpXSeNBInuAGiIBacKWXCzBWvM/L0APR8xJd+W71tKi36mKEJEJO3jPtSKN1BqJ4D3MzPisZzsft8WI5GgHE8ua6/5cqekjSN+E01aXbtl+nZAv9hwJFZ96nDjCu1Vf93qHYT6R52XGh7sMNQdtwz1rGvpyska07/zAnqGTVG0UUO3fXDBCZQudQc3avlv+XLsEq9YNtKrELhnANijqnJFzGA2OFl5n/u0+qH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 13:36:12 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
> deposited page table, such as PowerPC with the hash MMU. If the PMD is
> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
> without consuming that table.
> 
> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
> userfaultfd operation can install a PTE table before taking the folio
> lock. If that races with set_huge_pmd(), the unused preallocated table
> is lost when its local vm_fault goes out of scope.
> 
> Track whether do_set_pmd() allocated the table and free it after dropping
> the PMD lock if it was not consumed. Preserve any preallocated table
> supplied by the caller for PTE fallback. Successful PMD installation
> consumes the table and clears the pointer.
> 
> Returning without a preallocated table matches the existing behavior on
> architectures that do not need a deposited table. All callers
> already handle that case.
> 
> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/memory.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Acked-by: Usama Arif <usama.arif@linux.dev>

Reminded me of lazy pagetable deposit series :)

> 
> diff --git a/mm/memory.c b/mm/memory.c
> index becf53a2a0944..421064aef3cf0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5687,6 +5687,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  	struct vm_area_struct *vma = vmf->vma;
>  	bool write = vmf->flags & FAULT_FLAG_WRITE;
>  	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
> +	bool pgtable_allocated = false;
>  	pmd_t entry;
>  	vm_fault_t ret = VM_FAULT_FALLBACK;
>  
> @@ -5725,6 +5726,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
>  		if (!vmf->prealloc_pte)
>  			return VM_FAULT_OOM;
> +		pgtable_allocated = true;
>  	}
>  
>  	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> @@ -5755,6 +5757,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  	count_vm_event(THP_FILE_MAPPED);
>  out:
>  	spin_unlock(vmf->ptl);
> +	if (pgtable_allocated && vmf->prealloc_pte) {
> +		pte_free(vma->vm_mm, vmf->prealloc_pte);
> +		vmf->prealloc_pte = NULL;
> +	}
>  	return ret;
>  }
>  #else
> 
> -- 
> 2.43.0
> 
> 

