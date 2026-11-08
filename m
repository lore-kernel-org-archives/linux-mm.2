Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32AC606A330
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jPglDm2r
Received: by kanga.kvack.org (Postfix)
	id E4D026B05B4; Sun,  8 Nov 2026 04:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26276B05B5; Sun,  8 Nov 2026 04:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D624A6B05B6; Sun,  8 Nov 2026 04:15:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4E486B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:15:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C8841C3C03
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:15:10 +0000 (UTC)
X-FDA: 85411392780.12.B5E20C5
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0F40A1C0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:15:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jPglDm2r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794129307;
	b=UKDZyOQawZX+I0eo2FG10N77nXSIkcRhSG9oiLKnjqKSBTexw49nDKanCm942w2TyM9q1b
	T+rX6ifHV6VeZUN/I1/xSVMPdgvro5FeE0m5w4DBVPHWU+lQi7BzCov28c1/4C/tLaPg1b
	WG2716xJUwULHuNKJXT+auJviLU6La4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794129307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeQtM5VzYu47mMivuajAK9kUAFs5kDbX9OFi64Z8JXs=;
	b=foNSuIve4zswj5zHqgcfkD2paiyB6UL5VNUFv5+zr4pFliQ9wCIAN7LHAK/hNA6kcvYf2J
	VY7JVzhBpj2Aydh+pKUz+Slq1TepNilbXMbYDKkaSWtEi4+xHkziY03nbUH5u+zunX66hE
	xbDVgLLTgdfs5EHsvcVWRAr9u/laCfU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jPglDm2r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t4Z7aeZNT5PlqzzWkin+BcsnPWpstMOaNJUW6KAwwws=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794129304; v=1; x=1794734104;
 b=jPglDm2rDcjeZdDo5iLArbqU/YoZm7OXvO6MSf4ZypK3bkncRkj1eBPoG4CL9ApVzJNOZ92A
 XF4dMJAi6mxkFGS9cEiaQkoI/vNzJhnQt1ZGuMwpkHHHJqqPQqUxvBxcrw0DRcjzD7qncmDzYBN
 qerqr5g6hvdhXxQdmnkZ6b+M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4eda76d6e28ebe59;
	Sun, 08 Nov 2026 09:15:04 +0000
X-Mizu-Trace-ID: 4eda76d6e28ebe59
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	qi.zheng@linux.dev,
	hughd@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: free unused page table allocated by do_set_pmd()
Date: Sun,  8 Nov 2026 17:14:55 +0800
Message-ID: <20261108091455.88759-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org>
References: <20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F40A1C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: yzjkogg185q7dfgsd5pcheaipjpw7roz
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794129305-212300
X-HE-Meta: U2FsdGVkX19uInDJ2FH3Js8yF/OjoYjJaOrHP3q9WwifOMnOnkjBozxkqW6aAvwIryDNEBILDSeC3gY9rG6zpqVGmXLNBlm3yhLwYE7VJY1BXMckRUZl6y2B/S4+GfIFTmRJGMxOG4AKHDZEOUAG75P5Ukozgysa/OMyH9XQnYP6NIKCVzKjv7qFGx3EcO51TXEKv6rcwAYr3iU8QIQBUJfQE3cy/s85n1mXqRiGMiYqv8oF6dGqRUawvfYbCeP4lJ+Jljej/6rMkKU3Py7ZsW99HEnFYuBJNwxlo2wgobfjMyEu3bfwh9M9w1c9KJIlk2517tY+uH3jJigJWNyVkfRnrS3dOETdv3g/twwuB4jZcI5d4a23tbAErMW6/evPlVHUoz/84ec9t2cSNJViFpXuw6fH5IzccrPRar/rAtmQye1sfPG13wAT8tF9HxWLS4vjCNqzoOwwVDrdctFHE72VuAkvwCDQ8r/n2ZR+n+9tzl3biu3elJ0FvEftUZLrwcaIQboH1HAxEwY8w4W3/WM2p1w7pEdr7027cRq99mWO8CFBj7f2g8WjMODjgYvR5BjcWDFtb1bGOPJByMPjp47NT5ZqYPBbvxOjDP/hLpvy3pBOKwntbGHPLVwQH8u9zQYIAU/Se1PLzBqWHVyPbDnBfsN2WzCZImsJV5B4oqKWIdmBAIX6WL/bAK2HQkOW5klJF9i/2cKkQwjJ1N0iktRH4DRy0qfcEA4NvFbAcw+qFy/wgFEXNP4+2yITKRZLDQefS8IeWgEgPd0dPP3DrPtt/39eWsTuUbqjK+OPqJ8PBankywSXpLSgTJURVdv9VRdlomMi9kb6aqacfSwbwAhLqWL0bk9PbHD5ZWmWB0p4/qL0FVNJcO2ug3vJ+NMgRgZdJS0DW+5xAiu4xfPGmmPMNVN4WRQr/tXLUPX4dPRy0f/FiRKKc8hLztoEtZvpgtZvPp+EPtXoZe2hTCC
 X+nBIdwQ
 HxH6X4kM07jlVngzoSGFwNshnxDp7cG7/hN2cr+W+W5TLH4gb11oL8D1nivotUtOgink3NgmYGAFn2rwya7PNPUF+K8Awv7pZzCeAy7j/dZYS0hkvq9lwuWXVff5cArmN9XNaSbH+nqeQtsZCvSs3GzZ3tOVNQt0WMMGXLBqUM4pk5TOygT7LJ1gnPglR0RdIe0H4+hHZOiMxJlxgt1NTOLVglq92MYF6OIYUS159Oa0/2sY4SWRInehxtCFBM2ir0rljcypyMBazYuHZv/PlCAy6JPCwRzrs7cf5INS7anCm+rM6N54pxHcnZfeQTj0w6h62rZ9Y001646HErdXVoWUlliv/w/9DJHjDnKpKLyzbTlnqj6fdokO0Dzxoql9bMkobpY/isiXERY2Ge0bBAX1vLxvsYP/Spram6IX8ZRkvcdeRGqu9/QX6cLxdHlgNE86Eldm/Kz+kpYiDh7U3RT2U2gk34n5VJmuu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 06, 2026 at 01:36:12PM +0100, David Hildenbrand (Arm) wrote:
>do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
>deposited page table, such as PowerPC with the hash MMU. If the PMD is
>no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
>without consuming that table.
>
>Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
>userfaultfd operation can install a PTE table before taking the folio
>lock. If that races with set_huge_pmd(), the unused preallocated table
>is lost when its local vm_fault goes out of scope.
>
>Track whether do_set_pmd() allocated the table and free it after dropping
>the PMD lock if it was not consumed. Preserve any preallocated table
>supplied by the caller for PTE fallback. Successful PMD installation
>consumes the table and clears the pointer.
>
>Returning without a preallocated table matches the existing behavior on
>architectures that do not need a deposited table. All callers
>already handle that case.
>
>Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
>Cc: stable@vger.kernel.org
>Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/memory.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/mm/memory.c b/mm/memory.c
>index becf53a2a0944..421064aef3cf0 100644
>--- a/mm/memory.c
>+++ b/mm/memory.c
>@@ -5687,6 +5687,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
> 	struct vm_area_struct *vma = vmf->vma;
> 	bool write = vmf->flags & FAULT_FLAG_WRITE;
> 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
>+	bool pgtable_allocated = false;
> 	pmd_t entry;
> 	vm_fault_t ret = VM_FAULT_FALLBACK;
> 
>@@ -5725,6 +5726,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
> 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
> 		if (!vmf->prealloc_pte)
> 			return VM_FAULT_OOM;
>+		pgtable_allocated = true;
> 	}
> 
> 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
>@@ -5755,6 +5757,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
> 	count_vm_event(THP_FILE_MAPPED);
> out:
> 	spin_unlock(vmf->ptl);
>+	if (pgtable_allocated && vmf->prealloc_pte) {

Took me a sec ... to see why we can't just check vmf->prealloc_pte here
...

Emm ... as it turns out, the caller might have supplied it for fallback :D

LGTM1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>+		pte_free(vma->vm_mm, vmf->prealloc_pte);
>+		vmf->prealloc_pte = NULL;
>+	}
> 	return ret;
> }
> #else
>
>-- 
>2.43.0
>
>

