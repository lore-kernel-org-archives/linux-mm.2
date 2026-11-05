Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61822606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TpbPfdgW
Received: by kanga.kvack.org (Postfix)
	id 6D52B6B05B0; Thu,  5 Nov 2026 04:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687AC6B05B1; Thu,  5 Nov 2026 04:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F3D6B05BD; Thu,  5 Nov 2026 04:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EDF96B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:29:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B464F140980
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:29:29 +0000 (UTC)
X-FDA: 85400542458.21.6491D45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1EB0920002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:29:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpbPfdgW;
	spf=pass (imf13.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFCU0FbtSuC2D7iPyi82SNxybv9/1CahXus+XyLTnc4=;
	b=sDZyCErt7luq8j4ZOHk8boAQSw52PocxK2wv8a1RPUTae3pCSBK83/XPx10pJNyrIcrCax
	Wejb/bNUq8zckdPb8Ror/lvgklSLjJoh50eXIuhdmli24rapahTQxuYQGo0absKYj4yqHC
	eps3Fv/9HgyzGnIiAZqROjWmffJC7V4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpbPfdgW;
	spf=pass (imf13.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870968;
	b=Vot35VunD5BpI5u/UpxWwJs+f2ClID2pQWZyjUQTsvvpXVbMIe2ahfCEkn/y92L/na9NqH
	wlMerO0Xz5gfij1Sf/ZPkZMLev/OQaRG6pMN4SeOl5z9avF3Oiu6MmC7b0gnXMh7zcpNsd
	8aw9v0GhGBoSXpOWz5GLQYr0OYXnLNQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5587841FFA;
	Thu,  5 Nov 2026 09:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A6C1F000C1;
	Thu,  5 Nov 2026 09:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793870967;
	bh=JFCU0FbtSuC2D7iPyi82SNxybv9/1CahXus+XyLTnc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TpbPfdgWbH6gGD1XVstA3oJT7b5CDkZRmfmPvVlwNVz4gi1txWb4MKNvOd82hHgzx
	 M5n8Hmb/YE7vOWlwMKHpqWHPpRRa9p7m0CXdDzdArFmMwW8329BlYcDhHpVfpkbf9t
	 XsDszlEngFjzmH/tsneOFgvuRQ0B4NUL7WOT0fTxGOXmR0Y8sateaDFB1Uvp7/riDW
	 cpyHu51t9NjfjbOmkgb/P/0Cj+GSqjjP+yqXVo0GINez7r4zd34ot8676o2QweXQhB
	 O/isZNK0GboRZ8H9gaLSOhM8H/HMh1YB+Eyum/mnnJ6C5UeIf/aN47XVz+8g59wzdS
	 YcSuMUyFfZUIQ==
Date: Thu, 5 Nov 2026 10:29:22 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] x86: hugetlb: disable default CMA reservations on
 32-bit kernel
Message-ID: <auxMctmYZTTwtRRJ@localhost.localdomain>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <ece5aebe95f6565046d17ffb738670feb3202943.1793850539.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ece5aebe95f6565046d17ffb738670feb3202943.1793850539.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: szfdhia3sza851qezgugdii65x1s3xeq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1EB0920002
X-HE-Tag: 1793870967-602062
X-HE-Meta: U2FsdGVkX1/Frfp6KjxvRD4EfkYATvT/hBzvOtXsZPxQzTBpHCoefTD+y9Q770z3jQwFmWlI/y5D1yuatPEOzgqJyKprFjTtqtGpwL5vnYfOhOHzdx+B17IznIQL15jCKh1e3gl/BvW9FMGQxspkntaGNF7GVJIZt3iyUh5GNAfgb88H/osx2JCIqkxJr7famhvq+1mK3e0XLI6mFlHbXTfKBtSatJ/LXWFxgcC+K6HDlBlLZE/usAaU7NYtHO3Q1uxh1erSaeRMlJL7uoiWF+q8oFOnw78ceUpExrM4jSHFoV2we52KkQS0hBMeeF2wEZ3zEe3ZiGoeRJKVEvnssQWXxLL1sppmx5pqryk3rUBdqRCaMEa+NJEHXxLz2gktR2H5U41BVnTKPl5IPCuB1JyJQu+LDSjVlvb4+3uPOCBguimkaNRamvr29FuQBgzaTC8tSx9vCU3xlZNqne85nuWy8DbqEBVv9DJN4vw1hBUfhycCUE4aCKcaP/f+xzbW2WcLYp8XpR4t3UsV/y2kJB7MpA8yAo8Xt7cNNY/h2e1W88lg87l4wSnayphzUPukmdzFJArNGe+bpFZah3PQZRsUOnu+h/2qVB/030PXcejpucWB84/iYJFOJDUh1vW1fUF7lHZVdNynlK6o07XbVy6QzFrNqO8vhXHokHDKD3g36DjSa+rQ0EtolH9lT5IgWCIAZ/GBKK6CcxIS2hxCkKM9isVog/MeVAll/0qGrKnUN1o5tJIXV5ICvksvvGH2MY+fVis1gr3PMBfNNxxmrf0Wwv3UcxSigojCaN4ganGgIcIuXW4WdjoguLr/O4+pBwOXwyDsCmbqE69XAir3ah1mebtZJh/tn3nbc6gsJScN27cUkkLo7cWMXjym0e8yjyzH8RHPyoTOlU5DSSHXfVTrAduPODeivJpgKZM0HChL4vZfkgCmC21HhPblDbEpS7solQ1671uNlX81Gzy
 bqiYERex
 /YiniMMONipN8pN/owvRVPYHa7tZRAOWbmeViJAfkjy9+titqrpZWUp/WvJXM5D9ib48tbGTXgToEDMUPkieZ9bfIBx3Vyp6knZ+dX6+ELWAmoaXVGaeklEFF6IuYDUkQP3Dn6H3jpXEpy4HKnMwhv+W6mKfw7fwzP1hscHLXAF6D17HhyZzrkbgczSq0HXLImUG7a8oYkvAUTqj5RRiMpDyj3bE9dYCzI9V/iyxaVhILbY7apPcMAssFEHwghG0jLbSENjxW0sBm4FCXnZmPaWZbZ6wMq5irOE20
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 12:07:43PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> A 32-bit x86 kernel can run on a 64-bit-capable CPU advertising GBPAGES.
> arch_hugetlb_cma_order() checks only this feature and returns a nonzero
> order, although gigantic HugeTLB support on x86 requires CONFIG_X86_64.
> Specifying hugetlb_cma= can therefore reserve a CMA area that cannot
> serve the intended gigantic HugeTLB allocations.
> 
> On non-PAE kernels, the folded PUD_SHIFT yields a 4 MiB order, which is
> equal to MAX_PAGE_ORDER. With CONFIG_DEBUG_VM enabled, this triggers the
> VM_WARN_ON(order <= MAX_PAGE_ORDER) check in hugetlb_cma_reserve(),
> warning that hugetlb_cma is attempting to reserve a non-gigantic order.
> 
> Require CONFIG_X86_64 as well as GBPAGES when selecting the default CMA
> order to avoid these ineffective reservations.
> 
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
>  arch/x86/mm/hugetlbpage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index 3b26621c91286..70726a99ede7b 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -45,7 +45,7 @@ arch_initcall(gigantic_pages_init);
>  
>  unsigned int __init arch_hugetlb_cma_order(void)
>  {
> -	if (boot_cpu_has(X86_FEATURE_GBPAGES))
> +	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_GBPAGES))
>  		return PUD_SHIFT - PAGE_SHIFT;
>  
>  	return 0;
> -- 
> 2.54.0
> 

-- 
Oscar Salvador
SUSE Labs

