Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B72606A327
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 10:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=H87Iowrz
Received: by kanga.kvack.org (Postfix)
	id E4E646B0B31; Fri, 23 Oct 2026 06:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF5D6B0B32; Fri, 23 Oct 2026 06:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15676B0B33; Fri, 23 Oct 2026 06:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD9E86B0B31
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:19:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E4EF8037B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:19:06 +0000 (UTC)
X-FDA: 85353493092.23.6F80D99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7ED10A0002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:19:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H87Iowrz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792750744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVoPvZV32EnV3nhq+nvsH8tkgnbU6lXXBkfpvhV3RiQ=;
	b=0vQIbgnRDEjATVuxoR96s2m3/y3bfzY+yWWLEQJGQI6xYczUjKPhUlTMIVg5+8SsEDuS03
	TKTPJNifK9MCtBKS1Al0viOLd6dLhl+w+uhu0QamtJHe0nEDDyvs+cPv03zOjLze1+fBBC
	SOhAkyxSrSipClFgsQ2PG8OG4Q1AJXo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H87Iowrz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792750744;
	b=zNMGULmhcebnqIvyVZhP7QttMMErkO3pqqXTKRb0Ah45nN2zFhoLimr8PfxlfAsNNiFj88
	vNQ85YQfy2AU7VfsxKbi7jCR272egimnp7ZRp4XhzjsdCUV7FsFCBPPUKHk3cP1Z1MwtaW
	CZ75iEQytVSz/wjW02d1RzZQ+4k+3GU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3502A1650;
	Fri, 23 Oct 2026 03:19:00 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AFBD3F7B4;
	Fri, 23 Oct 2026 03:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792750743; bh=cTejc6vMr58Bc8gk6KW2BncO0y2Cvz1clpAKwoF7/Ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H87IowrzP0rj9C3cOW7Vzu9QCUMfiSLZ0/G+PHAGddRwpJrTeToyiptqu8vx7+3pH
	 w8RG+x0XddtHFphc6crHsU1gk8O6PWmj3qeZaN0M0Ly+45BVp2wb77l+7WxSJLLoTm
	 DUEPs9U6xhyWQsEoNRpuxhalPnHIewHnLwfzo0Zw=
Date: Fri, 23 Oct 2026 15:48:59 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v3 4/4] arm64/mm: fix destructor for unconstructed
 hotplug page tables
Message-ID: <4vrj226au2t5cyjsgqem7bami3tsgn57zcbw6cbedhkutknnh3@p4hngiltvm6j>
References: <20261023063428.3658761-1-songmuchun@bytedance.com>
 <20261023063428.3658761-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023063428.3658761-5-songmuchun@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7ED10A0002
X-Stat-Signature: f4wp4pscq9qjrj59zgu5dui8a7mramic
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792750744-926582
X-HE-Meta: U2FsdGVkX1992N/k2jzty4PQtLpDzr+tbYlEPu7YIQXpdxW6orj/zx13Zvx3Qm8vZL2JJiNMp08BbVMWUeTD2DglJzNDXjBh2OY9tuSaotuqQ8FFUwOuP/6AOjx4F5j58NX8M1gGfkfaUWoAOZ0m0nwLZG/fVMzt+nX0T7Tm3zupjge4NsSNdkvN6LH2Wh9KCMOGfiXo4oODTo+l9EsYCUEuJg4XGJbR432+eeNN0MUuclTzQxI7EVGmP1aVro7K8DzRezB0zObeu3HPqNXNfxsJeaDhGzn+PVCe9HA5q5dcRtL1kUNX20oYGwF+UdgOIKqppjRIIWInReQNsqWksg9pawTx+mac2v2tUPyD6HoI1hUcyAxJAYaxeqiQxbSzCQqFmIHOuVZd0AqkT4UQJcrmUa9fsi7Toodc7qOKLFgsi9bXtinB8tAu7QmmWIWmUE5P+vdrEwi+BD65JYk44heFmp7vUi+2TYgonplNv5KuesSxA/lhdEywJeOo//ozZaoW3FPjzTRrlhnD2cvVF2uDISo6nY9NG+u7mgSEkWpRd5g6FZJshIXDRtMMm9Jbs2eHe0QIRVMQgtwDeSCZTbZ5J5CmR+Kp6105MtmW19HI3JUWjOMnLN755juEbLAfeUJh73KYdIcNY6772HIU/RpgazEJChG3dNVlI/ezo+jHIDutjZaLyiGsQGnaPiYAzscvS0+djCVmH9BY3H3BaptuKTmGfoY50oZQ/Ncjfadt86UUrufP8Zi98pEGWvQIFoWlZ7CwZIj73O6Sm5gYqnGCJJruZAQZDI/C1rUwyzlBclLWqnmLUVFvFDhOLnLMbCqlPf03yG3HZeHiyYhasG6s1AYlfR1I0uyv/JTmm5Oi1JzPC90NA27V1sseRJF2BjkgzspeekLS4NSlsZLqBTpLKDDsmxMDA7P/JQRpBklhwkd6L5WAGjpsEI285QBDfCxYk4LeoTwlTl3Vlxw
 J+PcGSqM
 MTCkyDm/j4Tto7CT2uCfa5/5vdxsLy5XuIIYMbuKUgIQAAdDBROBThPoqnPGLXA/RQh+DVl33s6kKjCIyMy+TDl0VsKyZTltf8wIy7yQTRs5yx7gyJ0Eu3C17J6DDRUrwjg9a6DOZO++iPXdgqNWQDBJC8dEUT4rp8l7++lcj0afUrJyFbVUtiUeaZMFzTakyMgWb9slWpWlDHbz8UHE6MbOK8PcCQYl2ZENZrdf5rkxuyyU8kEVvp1tjnErT+CucGVKRnOIal9LEfVKsbNP5Z1tHai+0vCNbGUELAdP8xak12bfYfW7TxhTErTdJXby5QDJvn11HzasIUkdi17EuCtkA1vDN/q1A631w8e68O0D8syRTvnJG4wMnNBf+E3B6Br9D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:34:28PM +0800, Muchun Song wrote:
> Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
> hot-removed page tables") made free_hotplug_pgtable_page()
> unconditionally run the page-table destructor. This matches page tables
> allocated by the arm64 mapping code, which runs the corresponding
> constructors.
> 
> However, arm64 also uses the generic sparse-vmemmap population code.
> Runtime intermediate page tables allocated by that code do not run a
> page-table constructor. Freeing one during memory hot-remove therefore
> runs a destructor without a matching constructor and corrupts
> NR_PAGETABLE accounting.
> 
> Free intermediate page-table pages through pagetable_free(). It runs the
> destructor only for constructor-backed pages and then releases the page
> through the page-table freeing path.
> 
> Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> v3:
> - Collect Acked-by from David Hildenbrand
> - Collect Reviewed-by from Kevin Brodsky
> 
> v2:
> - Free intermediate tables through pagetable_free() (suggested by David
>   Hildenbrand)
> - Update the commit message for the page-table freeing path
> ---
>  arch/arm64/mm/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 79d90226fd5d..4dce8fa227c3 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1495,8 +1495,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>  
>  static void free_hotplug_pgtable_page(struct page *page)
>  {
> -	pagetable_dtor(page_ptdesc(page));
> -	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> +	pagetable_free(page_ptdesc(page));
>  }
>  
>  static bool pgtable_range_aligned(unsigned long start, unsigned long end,
> -- 
> 2.54.0
> 

