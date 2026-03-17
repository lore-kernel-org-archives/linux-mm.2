Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8694DFD7077
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B294A6B0005; Tue, 17 Mar 2026 06:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00C56B0088; Tue, 17 Mar 2026 06:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D406B0089; Tue, 17 Mar 2026 06:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93F8B6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:58:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C4F4BA44B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:58:19 +0000 (UTC)
X-FDA: 84555255918.26.08350C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9427216000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:58:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lrdGJ9/i";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773745097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+dFpKRmqF0aFlDjP7jIygjmaXLuGqGmWNgNqzjWZDo=;
	b=jrnUJapOgvFlhHax730KCEw367R/Tm2qB3olJ1shITya/zIFd/Qka9Wby+9zdtU+jB08gF
	oSv3dKAOyb1YJqxc4VoCJmrHnv8J7AnSvMMAyDEUWQgxZifLYbm0YBMf0lyToXCKxvyMXf
	iLeWEsXfTJGuBDJskHrsbYAhi8nFaPE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lrdGJ9/i";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773745097; a=rsa-sha256;
	cv=none;
	b=2nmLl0ijxJF8uXCraJyTB+CUHQYviBl+7RF+0SvwXRNSqz7WiFx94j1GT/aPrR15ZFUl8c
	vBJf/dEmrnpM3oh9YTKEwbo2XdtQnYw3sXOzy1qODMfsYtqT3pHC2zyBc8MHV+v+Wyjhf3
	rL694pH3Obqc1chTdkBk9F4nOoT0yqY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A966560018;
	Tue, 17 Mar 2026 10:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9883C4CEF7;
	Tue, 17 Mar 2026 10:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745096;
	bh=JRICjwmVdpqzYAIOq+YrlzgrUpxdi4BRyqT6V9luW6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lrdGJ9/iis3b83G40HFKGqhkIYJXHTqFAkYNA/h4LpOAxnlaqvG7OKR3o7mN6WPvv
	 FfeUpmVK6vb/7YovtaTzl+r8Ww3zHpqalWMmkmHCjdAwZwSC9ERWWQnCGrpKB57/9G
	 s4jDs7jjGXMX+pPfbPyvG3EwBiBMgL5Zy8NRs6Taf8fYruEi5EWEG0C9Uu1G59mtsI
	 5nU9L1fPycnOu0sG25ZiSIuGI21yppb5N+cry3GbOqo+jyHeeaarIBhqjq39//yG9C
	 sb2Jc0gwLyaMrEBHsykPyIZPpxcdYWdR3/D546Dyq64sRivKCRyu5UnguGpvo+vX7v
	 fhEGskjIuW/Ww==
Date: Tue, 17 Mar 2026 10:58:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 12/13] mm/khugepaged: run khugepaged for
 all orders
Message-ID: <a74178af-54f3-44ba-a007-4eaf49e40ab3@lucifer.local>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032650.234386-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226032650.234386-1-npache@redhat.com>
X-Rspamd-Queue-Id: 9427216000A
X-Rspamd-Server: rspam07
X-Stat-Signature: ef6ncpqumwjanmzxaii5szdtidn61a9i
X-Rspam-User: 
X-HE-Tag: 1773745097-597430
X-HE-Meta: U2FsdGVkX1/kDbqobjlRawoGrJwm8HvVReVodcngc26uXNvs1Y1SlK6DhAqxW9v174DkxVtKFdrWY1sYzd3b0rOTFrjwT8fhJbXRMhIi7a36Z2vmfxq/tNddf/DBJw8YMsiDvkX4vj3BaMjBGHsfb+nsKyoDLtGkalgwlqv3HW5hlJwCTHKBNqzKRQzB6v7FRvc/D0fV8/Y0L8DWYCpbjB+ORPwZT3haeTApCe6ElKdPgSO1yzsMGdVU3SIiKkU8Ekf0FyF+HL7UVLa5AkRr0/p1bHdf+04B+U5pxqWVcw+dMcf2P32tOZ7t8PY5vKjVqOLiMnrDyxgbifKopPcEtsibcb9u2wDIG0KsP2dA65pcAYEJjViWXr7KHkAlMPrJGjAFTJFTbzsl4yatt/OuiZHXWP8FnEDSAC1tq9uUso+ZbAvLDByzIx/le3/QkpXxZhohqOXtiHXx8TmDTzhvBN+mPGTSipNMvn2SpLIw1rlDWXCFOCeSFw6MN0ahtZt3npP5pb9tKyLHD3A3ecAeeTrBHkqjn3DxCjEZZQbUzqWfEitBx4t9ZG3prsj7UI0kTpzABiI4emUbwU5zfDGCCw3hAUAsNTPfsvG5nmTEBvuBe238X/pKPFKt7QWrFRURiGJv4I2cV5AmyAYkMTjUpTxEQ5xoLjcyF8yGVWE8gvzdj0lfuLFtVfzgsV5dEcR6XOnEMbs2Xgr41AdlzAdVRC+ZjtPLZBQh8SDMS6MmD5tmvVBlMeVk0so8rNjtNOKmSVnwRVixizyk6B3pVm+dA0Efg2lrhCLGab7mnYkcs0aE4hEXalFYIQYHFLNIb/4ncMzCvJGUMMUWVFjSiNtN4SzFUln0BDBEwLK5LBaDLO2Cw5wCK6JchMtNZGSM8Q1cn4quVn39fI4Di0LmSI13PWcChKd3bfXRHGj0EfRkU2ZGabQcLsoKyUbUVApLKfes3uDoMxyN9ZW/IQNEJDh
 OmcZkllw
 xlWi69JjPCGMvRCf3GEPzF1+V1oyfEViqyVwZ3okYC5MHSjU+Zi5jWWvFewnVrOePA2yT/ankbwt1YlfvSrKZm5rXpbhyaN1L8PRSS0nS6sCyMwcNXqI6Ut3g1h1Y59cb42U3pJl/TG1sCSt1tbib+n2JGC4WY/kJCv4Xcd/3ZDP10FnjcL/5/Qx37B2p6sT5KFxzJ2dCqmVOthp/HcyC60r2/J6/4w+hqwyIT7/Vw0z5WSt4ZykkEFKsPBnXFwJxC/z7PC2+spkzMPB95AjH1HXeWLDkORwS39kZyujdI5FyXErBmFpXaQeQnQ/a7oCm+81qHxxFRA0vm0QUCv64oFY3ddPWnZhOQa1X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:26:50PM -0700, Nico Pache wrote:
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>
> If any order (m)THP is enabled we should allow running khugepaged to
> attempt scanning and collapsing mTHPs. In order for khugepaged to operate
> when only mTHP sizes are specified in sysfs, we must modify the predicate
> function that determines whether it ought to run to do so.
>
> This function is currently called hugepage_pmd_enabled(), this patch
> renames it to hugepage_enabled() and updates the logic to check to
> determine whether any valid orders may exist which would justify
> khugepaged running.
>
> We must also update collapse_allowable_orders() to check all orders if
> the vma is anonymous and the collapse is khugepaged.
>
> After this patch khugepaged mTHP collapse is fully enabled.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

This looks good to me, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 388d3f2537e2..e8bfcc1d0c9a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -434,23 +434,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>
> -static bool hugepage_pmd_enabled(void)
> +static bool hugepage_enabled(void)
>  {
>  	/*
>  	 * We cover the anon, shmem and the file-backed case here; file-backed
>  	 * hugepages, when configured in, are determined by the global control.
> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> +	 * Anon hugepages are determined by its per-size mTHP control.

Well also PMD right? I mean this terminology sucks because in a sense mTHP
includes PMD... :)

>  	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>  	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>  	 */
>  	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>  	    hugepage_global_enabled())
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
> +	if (READ_ONCE(huge_anon_orders_always))
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> +	if (READ_ONCE(huge_anon_orders_madvise))
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>  	    hugepage_global_enabled())
>  		return true;
>  	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
> @@ -521,8 +521,14 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
>  static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
>  			vm_flags_t vm_flags, bool is_khugepaged)
>  {
> +	unsigned long orders;
>  	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> -	unsigned long orders = BIT(HPAGE_PMD_ORDER);
> +
> +	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
> +	if (is_khugepaged && vma_is_anonymous(vma))
> +		orders = THP_ORDERS_ALL_ANON;
> +	else
> +		orders = BIT(HPAGE_PMD_ORDER);
>
>  	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>  }
> @@ -531,7 +537,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> -	    hugepage_pmd_enabled()) {
> +	    hugepage_enabled()) {
>  		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
>  			__khugepaged_enter(vma->vm_mm);
>  	}
> @@ -2929,7 +2935,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>
>  static int khugepaged_has_work(void)
>  {
> -	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
> +	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
>  }
>
>  static int khugepaged_wait_event(void)
> @@ -3002,7 +3008,7 @@ static void khugepaged_wait_work(void)
>  		return;
>  	}
>
> -	if (hugepage_pmd_enabled())
> +	if (hugepage_enabled())
>  		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
>  }
>
> @@ -3033,7 +3039,7 @@ static void set_recommended_min_free_kbytes(void)
>  	int nr_zones = 0;
>  	unsigned long recommended_min;
>
> -	if (!hugepage_pmd_enabled()) {
> +	if (!hugepage_enabled()) {
>  		calculate_min_free_kbytes();
>  		goto update_wmarks;
>  	}
> @@ -3083,7 +3089,7 @@ int start_stop_khugepaged(void)
>  	int err = 0;
>
>  	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled()) {
> +	if (hugepage_enabled()) {
>  		if (!khugepaged_thread)
>  			khugepaged_thread = kthread_run(khugepaged, NULL,
>  							"khugepaged");
> @@ -3109,7 +3115,7 @@ int start_stop_khugepaged(void)
>  void khugepaged_min_free_kbytes_update(void)
>  {
>  	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled() && khugepaged_thread)
> +	if (hugepage_enabled() && khugepaged_thread)
>  		set_recommended_min_free_kbytes();
>  	mutex_unlock(&khugepaged_mutex);
>  }
> --
> 2.53.0
>

