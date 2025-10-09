Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8492CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238C68E0068; Thu,  9 Oct 2025 15:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210F48E0002; Thu,  9 Oct 2025 15:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D788E0068; Thu,  9 Oct 2025 15:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0331B8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:11:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E9591409A2
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:11:56 +0000 (UTC)
X-FDA: 83979520632.10.A398889
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D39AF180006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:11:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NuQKWRfz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037115; a=rsa-sha256;
	cv=none;
	b=0QQmdAnIY1M796OwB/rD5VAQ3YUx5eq6EoJPbWkczKmKeUOQHniM1LB+3bwSDH0Ulfh4pf
	YIRAziCJ0NYhQvWzMXC5zUlog1VCKD+4BhvPYNE4rKcTtOaCQj8fitQ58ppSIakVAn6PW7
	wpHoGKBD89TYCAWBQO4CqnV3DftYJJ4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NuQKWRfz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7HBbauRVjtLxT/2KqWAHpd85frdweQH7T0ABnBZNzU=;
	b=dYd20tcdwAmdoiyh5xZHPdL4HZ8u2uaGmTTlED4YwDjB4evundA8RKTPh0Hv6WMFazfw7+
	15XATOvBlVKIo1b3xFJ3L8+bOLboodLlosgn8hAXTFvGw9zpUWdBhyUAO1RTiYCG7s2oGb
	0rhpZO5d3OliYUMEsUTXPvhnpaRit4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 678A1459F1;
	Thu,  9 Oct 2025 19:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D44C4CEE7;
	Thu,  9 Oct 2025 19:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760037113;
	bh=6DwPMa+Wql2BSz1ZhMVyoJpuMWrdGiCDNvWyDRowITo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuQKWRfzxA6IS/MRDXbYxHjq+bGfXpIWBY8+7wLZeZ8FOFcDXG34cW7gWwjmX3k7j
	 GjZHs1x588d+C2H2iIT7mwhrsTHJfWd+IUj1XRTlFBtmFxP5sWLq6KfchIgWRNRC1e
	 SMI/GrGb4Sm3EhB+ZEsIK3EUvOI2h/+z5rPgL3bFB3dYv54tcaEdCWvhfkL6mXHAeA
	 R3YKDadCNsIQ/1aq98CE2GPEuG71IZjhBKbta5KB/JlKwrxExMq+hY0ddTs5m6Br4k
	 lAFdyzym8bbKXxmEHjHs1N/1zDIzyycI8hDQfObUHCKxZubqPTI8g78N2DaqMvD9m5
	 W22CHEnOvITZQ==
From: SeongJae Park <sj@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime helper
Date: Thu,  9 Oct 2025 12:11:49 -0700
Message-Id: <20251009191149.57652-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009172433.4158118-1-usamaarif642@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D39AF180006
X-Stat-Signature: uf3o1rj3jugziyeswhybm4tniprju7ey
X-HE-Tag: 1760037114-73114
X-HE-Meta: U2FsdGVkX1/ky+VRe2YgyQokKfcwxl9Z9d2m4C+cfPxDTpZ59wXhGIRJBXwNieBHu079SlA1wLQA7PKOEJRPtm6exwKawit1yTDg284fmGawXdQ7o0frPdNAKs7qmaHK2QRGLZbG+MIpXegvGgJARU7UpmxxSngpay96ftnKPs0TxZzaUPh8a+ZkSAfojguuenTKFzAYiYXSBjlMyQMf4hx18Rf4A0KtOLEKTUs0jZ2IdjJypR5PuyDvQtSGWKcD7+w5DP0tu5GQ2igIwbPbG6FFg8Hszy4tOtUIAmBcfDzY/+xSx2rEnWS8BGcDL7CtIJVtuJdlnQ1AaJDOlJE0KXGu72qf0QXPqTEXEjbz5YBET4XtXZ3Vx4Ew7lApBTeApPYzzNr1VsHIxN5RAlcI9jATqh7CZrF1TBVJt+wzUFLUra7F5nkqOCvhp482mpbOxi1qPguIPOeh9zfSTN8f+tnkF+phpvZx0LU//61CBVTfQgBi8pXhc+j0dkVyEts4nyTdKv1e/LGqLjrRbt+1AxI8urNxg4LFNM1+LfmyOOqMi7pWo50UB7YcMC/ceIrtydxgwKgS0KsQQhv5pIX18/+YDm8jUL2dXiIfexuwq4r8QiGvWjBBhna+qVfGuMRNBzQze4cmi52PcB14U9BmoBLgBKyJNjIhvs/ss9I15hxQ0w3gvcow4Vw1ptHipMjz3s5lE/i0YHaycdVpxFEx+xlHaqJEEno2gXm4yrmQAmcAZFhkEaYg9cV+OX7oACrjRsZDLmsqa3JfgSR7G9NlUk3XfLlPEt2WZmVnSzLCfI0vRwTfu9x0NZ+n/NGET5z2FFiLeEsp2OILp+6i9/KkkED/j1Gkg1QYSvPyeDYUIvmxm5hT3brzyWujPga3kmHNWx+BS+gTDeJK2bb1BavEcVupISOllbbELGYNlsrwgLZ7VHztHsJFg8Qrsl8Bek6KxW5aZxyi0g1CXvIMYFs
 2g0/YcVU
 ZyyVbtK7hcBGYAyKva7IEo/D7wMjl3Scovz8TjFSuvVtrtbkcUcrFgiGTK+OFQ2MI7r8KrkhFyO5SbYEQZk60tR6nTg9hSnUjorHwkK4oxd2LB9jYocfX1ROyVSjAVK+WCLIzwOXKqhohtkA+PC4nd1iKEB8eu3U/A/2XZ4LVcSMXq5YNu4jX/6EueUsADUxeQIJo1JkMuralyxZLUtJQLLF9yyFjH3sMoXZ202VD795yZv7DmPUI52bAK8Tzyhhn/leMPOZZkYXjjJ+lL5/6GelqbZ/zLfj0OGXlRTp/7PyK6bglfcF2dGUx0isvPNOtlvmVlLqV+fLpjoHiSEpd9RGhMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On Thu,  9 Oct 2025 18:24:30 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

> This is a common condition used to skip operations that cannot
> be performed on gigantic pages when runtime support is disabled.
> This helper is introduced as the condition will exist even more
> when allowing "overcommit" of gigantic hugepages.
> No functional change intended with this patch.

The change looks good to me.  I have a couple of trivial comments below.

> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---

I think adding a change log since v1 here, or adding a cover letter with it
would be nice.

>  mm/hugetlb.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c07b7192aff26..e74e41386b100 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -134,6 +134,17 @@ static void hugetlb_free_folio(struct folio *folio)
>  	folio_put(folio);
>  }
>  
> +/*
> + * Check if the hstate represents gigantic pages but gigantic page
> + * runtime support is not available. This is a common condition used to
> + * skip operations that cannot be performed on gigantic pages when runtime
> + * support is disabled.
> + */
> +static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
> +{
> +	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
> +}
> +
>  static inline bool subpool_is_free(struct hugepage_subpool *spool)
>  {
>  	if (spool->count)
> @@ -1555,7 +1566,7 @@ static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
>  	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
>  
>  	lockdep_assert_held(&hugetlb_lock);
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>  		return;
>  
>  	list_del(&folio->lru);
> @@ -1617,7 +1628,7 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
>  {
>  	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
>  
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>  		return;
>  
>  	/*
> @@ -2511,7 +2522,7 @@ static void return_unused_surplus_pages(struct hstate *h,
>  	/* Uncommit the reservation */
>  	h->resv_huge_pages -= unused_resv_pages;
>  
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>  		goto out;
>  
>  	/*
> @@ -3725,7 +3736,7 @@ static void __init hugetlb_init_hstates(void)
>  		 * - If CMA allocation is possible, we can not demote
>  		 *   HUGETLB_PAGE_ORDER or smaller size pages.
>  		 */
> -		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +		if (hstate_is_gigantic_no_runtime(h))
>  			continue;
>  		if (hugetlb_cma_total_size() && h->order <= HUGETLB_PAGE_ORDER)
>  			continue;
> @@ -4202,7 +4213,7 @@ static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
>  	int err;
>  	nodemask_t nodes_allowed, *n_mask;
>  
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>  		return -EINVAL;
>  
>  	if (nid == NUMA_NO_NODE) {
> -- 
> 2.47.3

It seems the new helper could be used for three more cases.

On mm-new:

    $ git grep gigantic_page_runtime_supported mm/hugetlb.c
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:           if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())

After applying this patch on top of mm-new:

    $ git grep gigantic_page_runtime_supported mm/hugetlb.c
    mm/hugetlb.c:   return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
    mm/hugetlb.c:   if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())

I'm curious if you are planning to do the conversion later, or there is a
reason why this patch is keeping those as is but I'm missing.


Thanks,
SJ

