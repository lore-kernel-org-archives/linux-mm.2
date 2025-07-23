Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CC7C83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 03:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF0A6B0096; Tue, 22 Jul 2025 23:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DCF6B0098; Tue, 22 Jul 2025 23:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88AA76B0099; Tue, 22 Jul 2025 23:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7676D6B0096
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:29:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6EC959652
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:29:16 +0000 (UTC)
X-FDA: 83694098712.29.B6D3F52
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id B30D240002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:29:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bXb7mXUn;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753241354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6Jagj2jPuRvwPABsY6jnls738Yft9yLjN8PP/NZGf0=;
	b=aXNhJFVHaJUG/nC9PkHqRznIMVvHXN5b99gVF5DeRg9ni2SdLOSUodugKAI6RtdIUqzykt
	d9NBiIDC8dLZgjXUfTT5SO57BVSyoViNBi+1KZ3j11Jt0NvgCw/NsHHtcsD+BNnpe9X2da
	3W7TEaJFE97Omb2ka4l+I+bGYiNtFls=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bXb7mXUn;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753241354; a=rsa-sha256;
	cv=none;
	b=k+qQrZQwtjem//V009ZFzY5E71E/TQlZri7OepZEs3y82bQWSgTvq+qW4EPbOmMFACjbac
	3VS55KpogMMFYXk7PbtcTZSt7+EUPELRgmOdC6QwdYLmMiXJtbMxCH122nmZabgy9wDxTY
	hmU8IAGD4lVPWQXyAQ1jXrR8lVsFXco=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753241350; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=P6Jagj2jPuRvwPABsY6jnls738Yft9yLjN8PP/NZGf0=;
	b=bXb7mXUnoDs8F+/9eU/ZXdmO5BZ0reSRqVqE5VN5r6QpLj+Wruu+Gdla//AwJdEfzM1MOyGdYNe+eAFCxHQc0xIM0ClqGX+fL7DQip2eNRHDGAuMz0kYKX34hxNvtTJ7cg7FlFLJMRVSNjJEQVpmj6R8iX9yv9wJbyfX83KH2mo=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjZl.Qi_1753241348 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Jul 2025 11:29:09 +0800
Message-ID: <2dfb2d7a-40c4-4ab6-be71-4a03670ea994@linux.alibaba.com>
Date: Wed, 23 Jul 2025 11:29:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: add get_and_clear_ptes() and clear_ptes()
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com
Cc: ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250722150559.96465-1-dev.jain@arm.com>
 <20250722150559.96465-2-dev.jain@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250722150559.96465-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x3nnbaj8n5e9fiakb9f4ijmii5wryjs7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B30D240002
X-Rspam-User: 
X-HE-Tag: 1753241353-566328
X-HE-Meta: U2FsdGVkX1/gjebEqKMgXdcnAjUvWk24YOe76aVa/9eVKnGwcZ/4Lvot6V91GLC6hQ8plU+rt4v15rC3M/LYW5kEp0lfSk7yURHqKejEsi6VfGnezT1lD5USUts4+22Pyy8Ca/3RxkfSkKfc1KrK26ahBhkcpGfYje+x2OoKTTLK5Y/jJW9AtoyN6SEDwugjdK9sHkioA+K/cl8D2JK34QScbs9HoelPfR8M13+aZMooFo2EDyZtmNK78JoKjIP3NiQrEaRjCmAwrXUfgbtBb279ovv9ISM0zi26l1ZqL2NPMa+Vij7R+TlYvY8c14+xw9hRkj8ku0jAlPc9pRNDYIOwOoiSigIrFpR98/zneYbudygykjAJVHmgInDdsreduMI9+Y77fNxul5XhqahGcFg4fWN43IpqgfrsWVJ3XN6S+IVRyNCV0spzDXFFCT6h3yfqeXsV2ZL9D0OnrQIadiciqZSweP3FWEx0EGHhrPcB1rysg9SBkLlxNnoJCBLYcAZDoEyGZr5zKqQcnbkOxWeclhVs5T1s9C7DWWBqRfWeMirqYkTLs0WbVa/E3kwdeIdHR9mrk1955aHiFlv8KI2qpkDUTagrCZC3rSFKxSdjyPlGv2yN5HE4p83wkJmM4mUSZcCcwnxsqp953Q9h4XzSFI5hIwxGP46opEnsAxIptcocRKfElmv5ToT9rrr7uXN4osfSSkVQ18hiu6auJLJDiMKjTW9j74wYEwLlEr9tcykJxTa96S4C1q5Apyw+RVOoxLm9TQqUdELF3lLI9Ti3/7eVw5M456xjN2oauCtRRQ7ekrMaZNY0K6dV3Sx3qf8chTpkQDOvpQ0mTgofFcCqNAU5Pn+D5bxj5wsINyzgIeLNrYezAIyke/LMpkoyb9z5dkBrAzE7pG+/Hrs1sPZLcTrCHPSHmTxWjYNlfOrhpcFzy3dWTfBqYNOpEEhvb/UNXeXGvpwZzVfURdd
 OBIxBCGk
 eGfKdtznx4dQbStRI/Su3McGvAbJ35E1bGViOrZDjVXpsUgwQZiqy8RAascYEcatvUipsCIxzZ6cjcbf/pe8uOmYTvjZk80rSYz//r3JQxwDUzDp3bDOvKiPpLl8C0O2VGIhdFiO+YM+dysC/00+NKDlYZSqTYDInubqDF1PvQHXYxBEZNKSH+0G+zi8CxiKM7zRW/fVMMqC4yfeBQp2nT4ZTg0H0KgTVQnw9hs6l60mJuX2prj118HdeICE0dw5S+BfLxalv/KrVcuSNLGCX3wM5+OP9YSX/3qIimNUNRgGTFpN0Dlb7LDiR7c7PUeU6DyWt/qHRjLfSEqjlAmxwkqiprGHw4YUm7aIRZ1/RjnaENKrcdaO7WSFa6/8RIm0VGJ27uU21pgcC5fkFqk/zkXELK3KWnqs60DD2QKgiu+otCVA1v4IhhbotUpDamzVXLO/X7vikBnyvSkF3Vcgl+c5eIuY9qCjhPrkR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/22 23:05, Dev Jain wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> From: David Hildenbrand <david@redhat.com>
> 
> Let's add variants to be used where "full" does not apply -- which will
> be the majority of cases in the future. "full" really only applies if
> we are about to tear down a full MM.
> 
> Use get_and_clear_ptes() in existing code, clear_ptes() users will
> be added next.
> 
> Should we make these inline functions instead and add separate docs?
> Probably not worth it for now.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> ---
>   arch/arm64/mm/mmu.c     | 2 +-
>   include/linux/pgtable.h | 6 ++++++
>   mm/mremap.c             | 2 +-
>   mm/rmap.c               | 2 +-
>   4 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index abd9725796e9..20a89ab97dc5 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1528,7 +1528,7 @@ early_initcall(prevent_bootmem_remove_init);
>   pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
>   			     pte_t *ptep, unsigned int nr)
>   {
> -	pte_t pte = get_and_clear_full_ptes(vma->vm_mm, addr, ptep, nr, /* full = */ 0);
> +	pte_t pte = get_and_clear_ptes(vma->vm_mm, addr, ptep, nr);
>   
>   	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
>   		/*
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e3b99920be05..e45986b54277 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -736,6 +736,9 @@ static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
>   }
>   #endif
>   
> +#define get_and_clear_ptes(_mm, _addr, _ptep, _nr) \
> +	get_and_clear_full_ptes(_mm, _addr, _ptep, _nr, 0)
> +
>   #ifndef clear_full_ptes
>   /**
>    * clear_full_ptes - Clear present PTEs that map consecutive pages of the same
> @@ -768,6 +771,9 @@ static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>   }
>   #endif
>   
> +#define clear_ptes(_mm, _addr, _ptep, _nr) \
> +	clear_full_ptes(_mm, _addr, _ptep, _nr, 0)
> +
>   /*
>    * If two threads concurrently fault at the same page, the thread that
>    * won the race updates the PTE and its local TLB/Cache. The other thread
> diff --git a/mm/mremap.c b/mm/mremap.c
> index ac39845e9718..677a4d744df9 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -280,7 +280,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>   							 old_pte, max_nr_ptes);
>   			force_flush = true;
>   		}
> -		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr_ptes, 0);
> +		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
>   		pte = move_pte(pte, old_addr, new_addr);
>   		pte = move_soft_dirty_pte(pte);
>   
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f93ce27132ab..568198e9efc2 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2036,7 +2036,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   			flush_cache_range(vma, address, end_addr);
>   
>   			/* Nuke the page table entry. */
> -			pteval = get_and_clear_full_ptes(mm, address, pvmw.pte, nr_pages, 0);
> +			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>   			/*
>   			 * We clear the PTE but do not flush so potentially
>   			 * a remote CPU could still be writing to the folio.


