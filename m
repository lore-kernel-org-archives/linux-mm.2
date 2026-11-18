Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19EE606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dlsig+ad
Received: by kanga.kvack.org (Postfix)
	id C1C796B05E2; Wed, 18 Nov 2026 16:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4506B05E5; Wed, 18 Nov 2026 16:27:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31216B05E6; Wed, 18 Nov 2026 16:27:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6636B05E2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:27:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF732A087A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:27:28 +0000 (UTC)
X-FDA: 85449526176.22.0BDC408
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9387CC0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:27:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dlsig+ad;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mogADoqfrbMYaLMvgpMtuagWfc8Fc+oIhYZ0ChD1RsA=;
	b=O4I0gppBg8mX9vPkBZjcIunJUjhvEwLNrQ3SNVWUlIhp5+/AanFp2EMJ5gX8/5MA4vXRpu
	via7O9FACugxGb+h9YaFYSu8Ws8saJc9yEsv/D9TDpnLsLU5l329MFercrm1gENMN/n9jv
	KiLrXuGBimjthPjMeJNhgFd8LEEhAbg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dlsig+ad;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037247;
	b=P4Jqt/sZwYlihJn72QEGUmzLyOHNd33sYUwoi0D00iIlEVR2tP1rWua3827h4oKw8u2don
	SQ2g93ANpUrGkjaI0HgKJuQqDZtotwQA7bza2YGBjQRBrx7xDCNNTpougbsPXp4Go7+rvV
	nwlsGt4rjv3J8GSyrLvOZ3ClDN1Kt04=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qDO+A0+DzQtZ1Jpw/GJ73qszkY+5+RWSqSSSXpqLzf8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795037244; v=1; x=1795642044;
 b=dlsig+adDIK23HTMVmpI32tmQcroVlpWzqBQbpdlScFHTB4uGVRchNnY8bt3qYe1+8yVmHPQ
 2FwSU+W/65HXMmoCOwjKJCMUA3VREeW+2h7VuO2QfHiCcNW8gPMUoMjBV3WQhWpPtWSmrM6gUOy
 xoSh1EFTjlj3C2cRnqxEgDfE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f673159cc3706187;
	Wed, 18 Nov 2026 21:27:24 +0000
X-Mizu-Trace-ID: f673159cc3706187
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>,
	aarcange@redhat.com
Subject: Re: [PATCH v2 2/2] mm/ksm: prevent zero-page remapping during ksmd-triggered THP splits
Date: Wed, 18 Nov 2026 13:27:21 -0800
Message-ID: <20261118212722.3922741-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261025-b4-ksm_fixv2-v2-2-8b61ad0491f1@linux.dev>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9387CC0008
X-Stat-Signature: jy8ipwdjapqb8ybdy1z4pri6ut9nwtzr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795037246-671273
X-HE-Meta: U2FsdGVkX1+X6XTyC9jSEsGyEEGnL1T7npmI1md6r7r8OYbGjUfoVmebvNOVIaXUj3nOJmxFGrIRNTQPpULjlsIXKnquLBPfAE6Wzhq36opGGKIW5xUqvA8XOEd5NBOYQX9r6nCIqoDbwMXdad5dVdP6rXyhrPNdGR1P211eB19IIh60dI085JnCrvKJWz9t2ME6XOmyx37jMifMCYSmQ33g8eF95W6v9jYI1IbkE+khN01+8UxStNtPxp5SksW4yMWYfxDYtBaG1mu1wygOd1ouTTrhU6/jsuw6E4OI194ds8aKxP50SiINKNENRIbzW0zyP7uCJz6sOWBlrTqJtRrRfqhZlIyX5kFHdhdP1XlP84J2qo9v9LrNzJkzYuwKiVxJ9DoEKRs98as/EG9ColVVFxqQOunpwvqQS43yAHEdVwHHWkwkJbLnblJ7SxekJTKye8k3T4FbH5l+op6S8HENIQhZULUOYZmtFw2LzAb7anIqD9BlxBqdvx6/e57inQq7oP+elkQa0JCNTeRd7TnPZUkBT1zqeFPB0jXpxK9NM5TchR5P4H3p/lgBAMLGjJdAwYsyNM3XGDof8LqfO0g/ulE355780/gfLT7hxS6Nf5aikH4iDJwhkRA5DmpCwyJ1qA3NBHTGQLTgKB6Vkgh6PKVtdyBcan4HgDgG81CpOdcXQTM5U3yKfl5+sW4VoHw1BqgsVaYedqC/UgJe6IkvYIv71nKdci4iDC4n/fOzIWT1RlTI9SPK6ClpNbXTHT+sHvnbWbA1BzaN5+vC4SrYymuIFeA/sVhyT2hftzVdz351nbGc0hIAAYPNJwGe/SGGPlseaMmTUpgUG75jXg/swgEIf+wShEQBZIugk8F7IvT5gQXyLWyOg08ZFkwgmxyyXD5vV+rjKUDBFY0oROCwTXBM+u4su1JugLXk0X3bHpVzVL66JbxPRUahzOtm7Jr4BraCmjc4Lql3g9y
 bNw6ZefR
 6nakMxIWH6cKnELnC5DyjKlEIGVHKcNmJTsUEaHmknKT2XYaB62wh50Vfwb/0WuNaDWweN34JiIERTJFD2byOKE9DbRdqxIbgJqBMgQEQgnZNDSy8Y50v/Ac3oHCsdBvujslbyFq3RaOGhl81u27w1eM4MWtEXsbKxdqKFgqaIcwkFbKaJ9uvLUSYf2MLJ4gulo/Ah9n46AJovtZzaY9x42zoxv3p/iQi+VlKVPw4xgljyZpOsQqe6HWOKSh31+WLvn37rv2OdeI8RsTngvpqMA4T7KsdulI+mIa9OZUC9rHbw5MI7xrXZMBJlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 11:39:47 -0600 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:

> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> when splitting isolated thp"), splitting an anonymous THP remaps all
> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> This flag is set unconditionally for every anonymous folio split,
> including splits triggered by KSM.
> 
> When KSM is enabled with THP=always, this causes two regressions:
> 
> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>    split_huge_page(). The split remaps all 512 zero-filled subpages to
>    the shared zeropage at once, freeing the entire 2MB THP when KSM only
>    intended to process a single 4KB page. This bypasses KSM's
>    pages_to_scan rate limiting, causing ~1GB to be freed almost
>    instantly.

Hey Nico,

I think I have had this conversation either on the previous revision
or the mailing list somewhere else before, so sorry for restarting this
again.

Isnt above a good thing? KSM is a memory saving feature, and this
is resulting in 1G being freed instantly?

> 
> 2. use_zero_pages=0: The same split side-effect occurs through the
>    stable/unstable tree merge paths. Each pages_to_scan iteration
>    triggers an expensive split_huge_page() that silently frees 2MB,
>    while the scanner wastes cycles on tree searches for zero-filled
>    pages that were already freed as a side-effect.

As an alternate to having this patch, should we just have patch 1
and users should turn off split_underused_thp when using KSM.

If you have a large number of THPs on your machine, using KSM is a very
bad idea IMO due to all the splits that happen.
IMO, there are 2 optimum host conditions:
- A large number of THPs, and KSM disabled, hence shrinker can stay on.
- Very low number of THPs, KSM can be enabled or disabled, but as there
are a low number of THPs, the shrinker can be turned off.

> 
> Introduce current_is_ksmd(), which uses kthread_func() to check whether
> the current task is the KSM scanning thread, and use it in
> try_to_map_unused_to_zeropage() to skip zero-page remapping when the
> split is triggered by ksmd.
> 
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  include/linux/ksm.h | 6 ++++++
>  mm/ksm.c            | 5 +++++
>  mm/migrate.c        | 3 +++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index d39d0d5483a2..41c06a6abf60 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -17,6 +17,7 @@
>  #ifdef CONFIG_KSM
>  int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  		unsigned long end, int advice, vm_flags_t *vm_flags);
> +bool current_is_ksmd(void);
>  vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
>  			  vma_flags_t vma_flags);
>  int ksm_enable_merge_any(struct mm_struct *mm);
> @@ -144,6 +145,11 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  	return 0;
>  }
>  
> +static inline bool current_is_ksmd(void)
> +{
> +	return false;
> +}
> +
>  static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
>  			struct vm_area_struct *vma, unsigned long addr)
>  {
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 910a1307ac9f..e3ab037b1ebe 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2866,6 +2866,11 @@ static int ksm_scan_thread(void *nothing)
>  	return 0;
>  }
>  
> +bool current_is_ksmd(void)
> +{
> +	return kthread_func(current) == ksm_scan_thread;
> +}
> +
>  static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
>  {
>  	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7bdcdb57652f..c33ae3fa1043 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -305,6 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>  	if (PageCompound(page) || PageHWPoison(page))
>  		return false;
>  
> +	if (current_is_ksmd())
> +		return false;
> +
>  	VM_BUG_ON_PAGE(!PageAnon(page), page);
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(pte_present(old_pte), page);
> 
> -- 
> 2.56.0
> 
> 

