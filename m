Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D31606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9s92eRV
Received: by kanga.kvack.org (Postfix)
	id E406A6B0621; Thu, 19 Nov 2026 09:24:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA916B0623; Thu, 19 Nov 2026 09:24:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93186B062C; Thu, 19 Nov 2026 09:24:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9EA6B0621
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:24:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3187940ADC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:24:58 +0000 (UTC)
X-FDA: 85452090276.13.940B880
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A44F2000B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:24:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9s92eRV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795098296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yh04qxgrTE0t9Qiy350KcpsHv2F2CP3xlLrXbQ4gfzA=;
	b=klESoQQ3LZki1ZN2VogvtPcZq2YEyNmDi1miuZOcjbMh8gH66SIE3iklUk1XDFXbVwKXl2
	Sp5EN8prdtdReq3vTlnJ7qDiKQOA4tPuBQRITY+7EAR2G9VNXvs2gPm6F+aAst3rWh9+QC
	x9ZEZyfpxLRmKHvye3s8mFDqv4hUbBU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9s92eRV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795098296;
	b=d3GZcUD0p02mjFGbxdWlI5Evg14qgcjzq1z8WYgw30YVNh86sQ0DhKKC9+hvgrLEVBByB7
	P+tN8wlUuBwLjWG2TruOo7KEggUBZdbXrhgY06r2NjCh4+Wka0/mBMkZo4NGCBYxjJsBQd
	6/AV3x++9o4Sj01af+iMSlhslDwCSN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F983450CF;
	Thu, 19 Nov 2026 14:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E1D1F000C5;
	Thu, 19 Nov 2026 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795098295;
	bh=yh04qxgrTE0t9Qiy350KcpsHv2F2CP3xlLrXbQ4gfzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R9s92eRVO5KZjAlc1LnkaSV0Fh04CAjiJvc/nVRN4ystnHTnuZ5Oux6IA2R7aQwsp
	 tk+1qgVU0Ju6+QKo7RNnORInuvYaHCpjjx5rAfXUtXu5LY+sPcRU+ZMR0MNav1O/0w
	 MuKCiD5XyByr8Us88gspOmznkYFtNPaZrhX55hCjZZPmC0DH+MXFD9T/uqx2aVFDXL
	 iZqKjgPCeE+Y9lpXKUDP57Z0h/rBA4g3Y6uuGWl5regeiYHqtgDriEZXSuOfrOYyN7
	 6j+7WxKLWVhGa9sR7uJCCMhrqRRqJ6Cgm9T2IFwvajsFxm8ht2WFnjpTUb6sfDKHBq
	 AviYZY2QAtMjQ==
Date: Thu, 19 Nov 2026 14:24:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Qi Zheng <qi.zheng@linux.dev>, 
	Tal Zussman <tz2294@columbia.edu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/mprotect: don't skip uffd marker install when racing
 with PTE table reclaim
Message-ID: <av8EisTx8vlYID0b@gremlin>
References: <20261107-uffd_shmem_marker-v1-1-91fa2d653cfe@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107-uffd_shmem_marker-v1-1-91fa2d653cfe@kernel.org>
X-Stat-Signature: 7ishsyq4agz7cejbx5hyq8syiqchgjwe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6A44F2000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795098296-734009
X-HE-Meta: U2FsdGVkX1+16jYD48ZKt3IXdrNLJ6sGRIv3XHtcB/F0dLHdci7DOk2317MgwYEVEBRZOS8d5xpxMj4A0/fxkTSPpol4mOumSVEHYIFuAuFXSQTO/M/p4PKgONsTkRkGfLIpYfIKNnNGRUTi5RwboLc1VNU2FvEpelD9U9filUuZZRXO9dHTi8fP6rLNbDsdCIsgXY+5a743BhrgbBlKwBLvDceyAMhYPzjisskGpHeWNfce54uxeaT4JBEZontSuc76otRg6orxaP3CavNHeY758Us6b7xjJA0zRpLkq2DZRvGlpuWvxmHRPA20rFviMBGGoo9nLWvVDm621TSNLSQ3Yk3tWvW6f8GiqHoAda04xCJsns8EuU2P000MjeBmTXpIeASGbZCKrZYXKiGsU3NsEXv3pyh4wQM7D2XDYa9MwBkaU8Z9A1pCCBPqq9PxFlJszF1QNenPqW00I70J7c1jkFhSVjoXBF4MM1gEKwVS0uMp20ABq/affSvH5iOL1F7r1AR5WdLwzcimWFpJQP9/O49n/dQQ6wcMlcJSK7Vvlu8D0l+fu7USIK6B5ihI6Y81bwLAS1hVuHZZxMLiOu+gvmLWaYUJ3KU7vVRQNYoqJRhVtMGIGCPmAg40bGTtQ6r5Lv4ciZ07Goh7pEZJ0txx0EAyKPE2Kij4Igi+Bk2IVV57rwLsUudiculX/j0/NJZPXecmFPa7726v4gzhLuQMZQg7L3m+4i5s1Gw/2ryz+MooIsG7GM7gqZIjFbZLcA59m8cRiCB/+w1RYtveoa0+XCWDl1+rydBwokxq5tdDN7Sw73tycBTHu4PeU2MNxi+Z0yY1GVV6Zu7faLcey9TPf8t5MY63fAKYxQwldGYJulBTlZGKCN8Tyg0MDjOYjoMPCyeWC5WFa2bE1VlICsLPPgqGB1mb99agDFh71q3AT1ni5a7wgr1AvCPU2UHk3cX5imfnt1maMQCGDwM
 VXlFTEDP
 RabItXZ2YkwgDCpBPixJEzE+tSvpvyYzZTA8KhhodHBS1QtaR+konU4FyNSih3U5lUFnRQlyq7ZcR1JStVnFTlryu+qCGlTaOABViK+IV8W1nUgRnZINmWo+VZ4L+EdHttgtrlbSLIvMDk8reJRfGbRb/yLYQMOCGSJESZLkCCWkzOqE7oGDBHrC3FUavUDZYIPiraPs2tN6grsAJrhq5ARju92KoSchDDi4ft6PKtG+kSMzIlbCMRyVYTgVXHO2CKHgvniAVlukA77UqpZRQpkT6Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 12:28:55AM +0100, David Hildenbrand (Arm) wrote:
> change_pmd_range() populates PTE tables before installing uffd-wp
> markers. An empty PTE table can be removed after change_pmd_prepare()
> returns but before the pmd_none() check.

These *** wp markers man :)

>
> That check then skips the range, allowing UFFDIO_WRITEPROTECT to report
> success without installing the required markers. Subsequent writes by
> userspace to these areas will not trigger uffd events.
>
> PTE table reclaim during MADV_DONTNEED and page table retraction during
> khugepaged can trigger this.
>
> Retry page-table allocation in that case. Simplify the code, getting
> rid of change_pmd_prepare() by routing all code through the "again" label.
>
> It's a small race though, so likely this is not very urgent.
>
> Fixes: fe2567eb5521 ("mm/shmem: allow uffd wr-protect none pte for file-backed mem")
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> I expect Andrew to pick this up.
> ---
>  mm/mprotect.c | 48 +++++++++++-------------------------------------
>  1 file changed, 11 insertions(+), 37 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index e18d4e12fc341..ef4e7188e24da 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -470,25 +470,8 @@ pgtable_populate_needed(struct vm_area_struct *vma, unsigned long cp_flags)
>  }
>
>  /*
> - * Populate the pgtable underneath for whatever reason if requested.
> - * When {pte|pmd|...}_alloc() failed we treat it the same way as pgtable
> - * allocation failures during page faults by kicking OOM and returning
> - * error.
> - */
> -#define  change_pmd_prepare(vma, pmd, cp_flags)				\
> -	({								\
> -		long err = 0;						\
> -		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {	\
> -			if (pte_alloc(vma->vm_mm, pmd))			\
> -				err = -ENOMEM;				\
> -		}							\
> -		err;							\
> -	})
> -

Oh lord... glad to see the back of this!

> -/*
> - * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
> - * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
> - * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
> + * Populate the lower-level page table if marker installation requires it.
> + * Return -ENOMEM on allocation failure.
>   */
>  #define  change_prepare(vma, high, low, addr, cp_flags)			\
>  	  ({								\
> @@ -517,30 +500,21 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>  again:
>  		next = pmd_addr_end(addr, end);
>
> -		ret = change_pmd_prepare(vma, pmd, cp_flags);
> -		if (ret) {
> -			pages = ret;
> -			break;
> -		}
> -
> -		if (pmd_none(*pmd))
> +		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {
> +			if (pte_alloc(vma->vm_mm, pmd)) {
> +				pages = -ENOMEM;
> +				break;
> +			}
> +		} else if (pmd_none(*pmd)) {
>  			goto next;
> +		}
>
>  		_pmd = pmdp_get_lockless(pmd);
>  		if (pmd_is_huge(_pmd)) {
>  			if ((next - addr != HPAGE_PMD_SIZE) ||
>  			    pgtable_split_needed(vma, cp_flags)) {
>  				__split_huge_pmd(vma, pmd, addr, false);
> -				/*
> -				 * For file-backed, the pmd could have been
> -				 * cleared; make sure pmd populated if
> -				 * necessary, then fall-through to pte level.
> -				 */
> -				ret = change_pmd_prepare(vma, pmd, cp_flags);
> -				if (ret) {
> -					pages = ret;
> -					break;
> -				}
> +				goto again;
>  			} else {
>  				ret = change_huge_pmd(tlb, vma, pmd,
>  						addr, newprot, cp_flags);
> @@ -554,7 +528,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>  					goto next;
>  				}
>  			}
> -			/* fall through, the trans huge pmd just split */
> +			/* The PMD might have been split. */
>  		}
>
>  		ret = change_pte_range(tlb, vma, pmd, addr, next, newprot,
>
> ---
>
> base-commit: a3d27154a205f6b32000e7e2734b2a6a4d22c65b
>
> change-id: 20261107-uffd_shmem_marker-a0b9869d783c
>
> --
>
> Cheers,
>
> David
>

--
Cheers, Lorenzo

