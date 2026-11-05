Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81883606A90B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eRTmDFF2
Received: by kanga.kvack.org (Postfix)
	id 934E86B05B2; Thu,  5 Nov 2026 11:40:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5106B05B5; Thu,  5 Nov 2026 11:40:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC0C6B05B6; Thu,  5 Nov 2026 11:40:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4981C6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:40:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1C85120AE5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:40:47 +0000 (UTC)
X-FDA: 85401629334.21.5D23CA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDD8D14000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:40:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRTmDFF2;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793896846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMfT6NnqJNQ4fwmo+zlAfszpntP7F4+aKhwQgsQvMfU=;
	b=PRhbynqfsWAzA5FQCBpImJUHU7oti9cI4MJybSkEDASsZnVzkW3FJ6K1rOth7IT9XbnV8E
	VVwitaWDyuddRFfxGE3r8heH6K0aJPjtBEHL0UZfAoJWJNd5OIwk3EMlMFVqS+ofOeXKJk
	G3JY6gKV1qUpzM3o/g7WEXWGCNaTUP4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793896846;
	b=aHDJd5AXBQ1Ud3gMwBd94R/FwOSpaTGKkCHIrWlwPULms/0JT2t/Y1PcRYMUJeZNNXt3KP
	Ub6/IYYWna7jvaM1HVm34x1FeiRzlZx+hKqlRxsr7mcmwklGGjTDldObldfxQQth9cMJgX
	wQCj4wAUz3dIoqWyy6UpPuMYEcbe7Ps=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRTmDFF2;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D35A54012C;
	Thu,  5 Nov 2026 16:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE99E1F000C1;
	Thu,  5 Nov 2026 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793896844;
	bh=jMfT6NnqJNQ4fwmo+zlAfszpntP7F4+aKhwQgsQvMfU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eRTmDFF21AokwEeLbpwgXPGufwdoan/3wTSHEhhcxjntte+tq/knqfW+SQtBcfKIX
	 oDKY1eSAyS2RmFB+kVayVtrMrjXegac0cFwPwntDKHf+VWHV5AH97rP9Fk5PP7e6+z
	 aGLlouWS7XmXh9xJWrJuL/CeImXsADQQnhRGK5eKGks5/XstygPJqB19ZJyF+C7Pur
	 Ne9m0o5gMuet9ljDF9tNmp9It4Jhh8zosFfhaiOHcDuFpWREsdnmJZ0Pu6LKkINTyI
	 KPkeU/fyQLg//pjEkhF3IsdOQ7czbi1Ck5RocPrgMLHf2QkxiJq7XuUUZJu3w6ZyTS
	 kKZA4N/B/9eHA==
Message-ID: <c13cdd25-7d7b-4059-a22d-af0a48fabaac@kernel.org>
Date: Thu, 5 Nov 2026 17:40:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: free unused page table when setting a huge
 PMD fails
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261105-khugepaged_set_pmd-v1-1-cb79ab117199@kernel.org>
 <aux9liPvdZgpKCpa@thinkstation> <aux-ZdKu97JHLY96@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aux-ZdKu97JHLY96@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDD8D14000C
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: fgk4gu9b6r4ykj8otpfsd3y5qcrmw6ar
X-Rspam-User: 
X-HE-Tag: 1793896845-625865
X-HE-Meta: U2FsdGVkX1/poDX7AaANDWp5zq4/RCzh/VgDSxVGdItWgSQWnJ2Rz0ReAqckScQ6wPU8PKNprhBcUeHUGRYW21LsYHHx+Lf7p5SntlJdYFgzz8gBBQhG7SMBIa7QsXTRIYe5nCJ2Y7Elu9jgNSr39fEGdfFvVlRl86/JsuilvtLK4dgh+CVXwH7X+FzBtV5aMxy9cvE3+Xq4Yl4U3QgYGPutMG0LYxrfSRO2gqMAqn08rtDgbRenZmAZ6x+grokTWvs1SxFKxcm8UqslWHEKwqwRcwB5dpvIscduB0tW7sjq1kaZGooouSMqMVZe1CmfPISewYN6zbvg7zN1g+q395qHu/xo/CKIvqlcVUarHBYzgKSVSfjU3jVvGz9FwaPOihNWQWPmw7fvrKumHD9IoeYhyWKNC0OLrXA4XA139cVkf2iesYvpebThUmP+KjxfnNh27mOnRJhVAwqOKiDvyL1y+tlgfloB6yUhxwtfsxogNDFBSPPl5cImPW/AkiZuhhdYwlqzFmeiV211udN7DbrHYpOcTkkPmPqRemUt439xfsoNquuJm4VbEFQRFQg7sFyNqilURoLRenjzqNO2lkJ2ge5HmS64LR6d5urN67XDS40KTUOn5tDszmIFbZx7+Mzbvs8+2BMwwHVP+PCWuucLaCVybHR7ZhIrchHZvCuBIX2JnhGARLM8d4EgP/3LnAXrLt222qru+6umZfb4apQ48HyWHTlljXE6n0U1J12LPHht6bfm/RtWZ+kywGVIiqZOxJ6+oZLElkfr/IwMN8zPAg2vdlIXLvpAQ4I22Z558eIGk3Eb68gnIyICoYYZt/psfb+b7D4JOs22kaWrpXsA6uqTHLbBwuaNP8cyh3TOWl/7NHtWZN0msKcF4uE0+Otau5O6mJ1PMwNjLVDmJEfcBPO3v0pu3+w+mZO5fpQmJ4Oe2Wy9COxvM3fGvZ1+arlM0mTbBvC6ZN8w7IB
 HqNS5gpJ
 z9z058rfXNDekBqw1a66SSCZqDiBcAaBcBDdmeSjZv84sWXNp8FtAkPME+e1Xp8blUYeFNIZG4Hp58yNyt6cgIyJ/MDlHQrD078spExZYtbuVSYe+ShbQe09uOSea8IThaVtODIZ/CQrVICDMe1rMkJmJNIS+helz1xDjxn9uPPTVPJ+lLEOxI3qTCX3Zr0zGL2sG4+2nFYcPiyAeeiiXtRVMUma6fOWD0rCe5av1/id68xkqpd/JfKJUIGPdzxgIoO9k6K4ldZPZkzwexLHKSLyYGOQv4D2ZnbxQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 14:04, Kiryl Shutsemau wrote:
> On Thu, Nov 05, 2026 at 01:02:08PM +0000, Kiryl Shutsemau wrote:
>> On Thu, Nov 05, 2026 at 01:16:05PM +0100, David Hildenbrand (Arm) wrote:
>>> do_set_pmd() can allocate vmf.prealloc_pte on architectures that need a
>>> deposited page table, such as PowerPC with the hash MMU. If the PMD is
>>> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
>>> without consuming that table.
>>>
>>> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
>>> userfaultfd operation can install a PTE table before taking the folio
>>> lock. If that races with set_huge_pmd(), the unused preallocated table
>>> is lost when its local vm_fault goes out of scope.
>>>
>>> Free vmf.prealloc_pte on failure, as do_fault() already does. Successful
>>> PMD installation consumes the table and clears the pointer.
>>>
>>> Having to do this cleanup outside of do_set_pmd() is rather nasty, but
>>> other callers depend on it already having been allocated. This needs a
>>> cleanup at some point.
>>
>> I hate this being outside of do_set_pmd().
>>
>> What about making do_set_pmd() freeing ->prealloc_pte if it was
>> allocated inside? Nothing changes for caller.
>  
> Or if we want to keep in set_huge_pmd() then set_huge_pmd() has to
> allocate it too. At least, it makes some sense.

It's all rather nasty.

I thought the callers depend on it, but if we just free in the function
it will behave the same way independent of arch_needs_pgtable_deposit(),
so that makes sense.

From 4e8d0a928f0b21e0583dac9234fb1821f3c973b2 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 4 Nov 2026 20:56:37 +0100
Subject: [PATCH] mm: free unused page table allocated by do_set_pmd()

do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
deposited page table, such as PowerPC with the hash MMU. If the PMD is
no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
without consuming that table.

Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
userfaultfd operation can install a PTE table before taking the folio
lock. If that races with set_huge_pmd(), the unused preallocated table
is lost when its local vm_fault goes out of scope.

Track whether do_set_pmd() allocated the table and free it after dropping
the PMD lock if it was not consumed. Preserve any preallocated table
supplied by the caller for PTE fallback. Successful PMD installation
consumes the table and clears the pointer.

Returning without a preallocated table matches the existing behavior on
architectures that do not need a deposited table. All callers
already handle that case.

Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index becf53a2a0944..421064aef3cf0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5687,6 +5687,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	bool pgtable_allocated = false;
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
@@ -5725,6 +5726,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
+		pgtable_allocated = true;
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -5755,6 +5757,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	count_vm_event(THP_FILE_MAPPED);
 out:
 	spin_unlock(vmf->ptl);
+	if (pgtable_allocated && vmf->prealloc_pte) {
+		pte_free(vma->vm_mm, vmf->prealloc_pte);
+		vmf->prealloc_pte = NULL;
+	}
 	return ret;
 }
 #else
-- 
2.43.0


Apparently we might be allocating in do_set_pmd() from a RCU critical section ... maybe I'll find the
time to look into that.

-- 
Cheers,

David

