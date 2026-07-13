Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58DBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58436B0122; Mon, 13 Jul 2026 12:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30156B0123; Mon, 13 Jul 2026 12:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E056B0124; Mon, 13 Jul 2026 12:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 898956B0122
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:29:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B02DA01B2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:13:23 +0000 (UTC)
X-FDA: 84984097086.28.FA66F71
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6BC4D1C0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:13:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l18hC4xT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783955601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0qkF5e+IsQQ+xyny/lcvjpB8Rmv7gMJ/99iomJ8KKE=;
	b=pW+zfnZ6AQmwYLTNwavelOhB9kAOgJEHH9+PGnBcMEMYinKEeUFNxKD/trqbOs1BfUdWbF
	R/d91ubktH4VtXQ1b8RypB4simPYIUZiwl+1z17YMaI+Ry61YGXcMMCqNnwoD9kG68U4d1
	G9nL9kDTHHsNp0AfT+r7LNGCoYoP68k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l18hC4xT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783955601;
	b=EPQWYkWX+mGExr2xDCo4VBxEILtpfJfXmvYRdjCIfeorS7i9hK9kq5KqDJDc3hz4uDHgcY
	wTduMeZs2+zAyZeF5WANNQhM+QMWjkkC8rep7pWorZW60ZFYC0qR0SoNQ/JaFlRfS49Zpy
	VuZL3weHICybKODuDUTkId5jclMSkjg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 569451576;
	Mon, 13 Jul 2026 08:13:16 -0700 (PDT)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8B5B3F93E;
	Mon, 13 Jul 2026 08:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783955600; bh=FxZLR9R+Tw/RTXShqH2JiucTcF7BYOfeeQ7iY565rBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l18hC4xT/sUPl8dCaDqcr/Ljf4Uj9z5GidEBxYlDB+Za59H+9rQjYDbLJFszRBqYW
	 PxjxqhsMi5uQxLcE4Nl/DuuoVFXXxhLjquX1Os0uGlFuFAuY9NJJW5nS3LunIq6U9n
	 qnX+Oi/SN60p8p0hOGnN7SN2AjE0Cqe1N/bsuZak=
Message-ID: <54434a84-51b3-4e3f-988b-6bcbac5a2f42@arm.com>
Date: Mon, 13 Jul 2026 20:43:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Wen Jiang <jiangwenxiaomi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, Wen Jiang <jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kcy1do5iu418q694nhdte6qxuyfx3bnp
X-Rspamd-Queue-Id: 6BC4D1C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783955601-54
X-HE-Meta: U2FsdGVkX1+vglQL3w3+JMHy97c6QgVY7c9nqCtay3JUzwJiFOR2Tf6yesw4d8p5RKN7RvETU8w6XxkgQXrgJCx+E5ibwKPO5k9oNtGQpXdjvWVkyFF/lp+90DrQrQepGqBbmPMKolaVsootml66ZPycQaxgwbCB08dD8jX5tSd/0MWZR6vvlKgePBBx15yTjFMGkh05eOC9zJUx4oLNzMGI4M+Cx+feXth7ynnR3GIvrdfhlchgerHWa9UynvoSX8e0ZNOMv3KdQrJJuGBUZWsNp3nUueg/pOrZIWRUwg80S5/MrhdOtDMRxuDOsAbaOoopzk3xMajQXAvDbthbIVv5PhGvLbbX/JoNUwgEDVs5+ONQ8pzHEJeyTEBCG0Ss7SDbdKsU/5ZSCA3+YZACwoEwu9P6tDALpc2PtrDTREUKAg38z7LkDSHLpv0mezcj/aTa2x4v5Ri3HkmDBSK1b2WsuDdkvG8MACb9Dt8ajyfcXUvjHuSKzBnSfzTddho5gvDB+2DcgWzBEaTRy6DmUNYdBgpEheJjTMc7BflC2vcZngbYSLZGv6nzuE1ocHPyKUjRfr1kHmzOMWHMfdEEw+iNnxBJ2SaHKRBH4+aAX3vjfHuCaircjMEjkBef2N0kDxsgyoUFCQNQWSC71RgfKI5VXR+4cGHA1WB7/JrT2ZeXn45p9zy6VXMuONxY8bc68jVRfpSD3lyYLnodWLNQejQzWuhPjAmNGyaTcSHoc5dWTObP+EzeAxJlcjsmoBwBhIkOVZUfMw0lRJwbn4vfDjFZo4uYO4Dlpe57HZ4W93ty5p3Sx5hzW/xaxp76ubd6kjYIDzRiLGPfYDaXDRiqXDrq0AFu/UylQXnE0dUzz9iRvyyqfiYLwkrSgadnuQfOSYGqEXAFYW4SmD3/kRXcar6tJicEu2Q8CUnwZ68zGNXMVA0611vbkRkVMn1/ratb1VEQN0aBLkad2H9ZC8x
 5/sRV+g8
 qLpHNxkbMPheAmCWPqr8ck/9+JjY+e8RvX2REvyqkhEfs46phze8AKcWMrCYC5Qt86m0YzIdIfDJKC/ixq7nrzjeXyRhw5ybEeoQbCE3OzaZiHf09aphVYqe64+5OKnvov5NPnMtHJdUm12u6cub0XsUGj5tukxTY8XdAVBP2kow2XSjw0NgHSJMWywu95BdLc2fb2pftqm+qBqvMHq6TcDGxsjHtEIpIFdI2hV2zW86AZTyNS9s+CKe23ENdH6oeCifSWgFEtOYgF/HoiPEGSnMJmKwk6YLiG4pYRWkQahhfOTeYQIL7QYynRJKeUnVi3fYipLBf2W+MR/7JtAokQbFBtfb3+11KxFazHid78wgYVF9r32iaoiAuqFg1yX2EyjkZhaOFVBk+9aGA4CZq9Zra7VlwKRNBuhZVtZ507MeFxg9/xNVKhIBTTXizIKYE/yy1YcJKdNhtXsqExh9CVXar9pWFegb7q48u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 2:24 pm, Wen Jiang wrote:
> On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>
>>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
>>> is physically fully or partially contiguous.
>>
>> Thanks, I added this to mm.git's mm-new branch for wider testing.
>>
>> AI review asked some questions, and some of them are new since the v5
>> series:
>>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com
> 
> Hi Andrew,
> 
> I've gone through the Sashiko findings:
> 
> - Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
>   is added. The extra sizes are only used by init_mm kernel mappings via.
> 
> - Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
>     array of valid struct page pointers.

Correct, but vmap_pages_pte_range has !page and !pfn_valid checks.

I really hate those checks - if those checks have any remote possibility of
firing, then we already have a bug at

vm_map_ram -> vmap_pages_range -> vmap_pages_range_noflush -> kmsan_vmap_pages_range_noflush

because the last function dereferences the struct page pointers.

It is painful to do the page array sanity check deep into vmap - it implies
we simply cannot play with the page array before that.

But since vmap is an exported function, doing a sanity check for the page array
in the vmap code makes sense.

So how about the following:

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index afaa14ebf17bb..0c44bb7a45b5d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -566,14 +566,6 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			err = -EBUSY;
 			break;
 		}
-		if (WARN_ON(!page)) {
-			err = -ENOMEM;
-			break;
-		}
-		if (WARN_ON(!pfn_valid(page_to_pfn(page)))) {
-			err = -EINVAL;
-			break;
-		}

 		pfn = page_to_pfn(page);
 		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
@@ -603,11 +595,6 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 			struct page *page = pages[*nr];
 			phys_addr_t phys_addr;

-			if (WARN_ON(!page))
-				return -ENOMEM;
-			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
-				return -EINVAL;
-
 			phys_addr = page_to_phys(page);

 			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
@@ -3663,6 +3650,19 @@ static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
 	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
 }

+static inline bool vmap_page_sanity_checks(struct page **pages, unsigned int count)
+{
+	for (int i = 0; i < count; ++i) {
+		if (WARN_ON(!pages[i]))
+			return true;
+
+		if (WARN_ON(!pfn_valid(page_to_pfn(pages[i]))))
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3706,6 +3706,9 @@ void *vmap(struct page **pages, unsigned int count,
 	if (!area)
 		return NULL;

+	if (unlikely(vmap_page_sanity_checks(pages, count)))
+		return NULL;
+
 	addr = (unsigned long)area->addr;
 	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
 				pages) < 0) {



Reasoning for calling vmap_page_sanity_checks() before vmap_pages_range_batched,
and not at the start of vmap: I am worried that since vmap() is already very
fast, we may cause a regression:

vmap() -> scan page array with linear map pointers -> vmap_get_aligned_vm_area (does
memory allocation, throwing out the linear map VAs from cache and TLB) -> walk
the pgtables and again access cold page array.

Perhaps I am being very pedantic here. What do you think?

> 
> - Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing. This was
>     already discussed in the V3 thread, and a separate fix was proposed
>     there.
> 
> Thanks,
> Wen
> 


