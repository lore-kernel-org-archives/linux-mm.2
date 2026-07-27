Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6CCC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B582D6B0096; Mon, 27 Jul 2026 12:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F346B0098; Mon, 27 Jul 2026 12:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B406B009F; Mon, 27 Jul 2026 12:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE9B6B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:29:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1111E40130
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:29:52 +0000 (UTC)
X-FDA: 85035093024.19.CCF8B02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 804141C000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:29:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kw1AZvYl;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785169790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=barQc/nnGT6K9yO5qrPbNOA4nT34BHoggqlafqCfinU=;
	b=1x98LFvqGPPldhsuBSIqYhlfq9Iyw3+1ECHVBrcdqhnkHmfjrscDG40cp3VkVmnzHYObz3
	XIyRVFZQW0rp+44xyumITMS5g69rMTn/RvH5hZJKV9RRHNFwyX8Ym8diqZNNucZMDViZ1M
	YwxAdrm3GtNz1kQhiNsscQv/ToadVhE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kw1AZvYl;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785169790;
	b=F0W4nd1eKlxVf+JjvG6zTQCs5TFDnoyZn3HSi2PofugFw2p+OMHscD6Fu9rsd5sKMw9/4E
	3qhBnseqOiQz1koyUKX0F5EXSa9YaPyRe3qB6l03y7umxUWP9sXwiZbd7u/LyfwCB/Zfcr
	lsGceCFtKVm65IYAVzhGUVEVO2w/ggc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E773360008;
	Mon, 27 Jul 2026 16:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FBB1F000E9;
	Mon, 27 Jul 2026 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785169789;
	bh=barQc/nnGT6K9yO5qrPbNOA4nT34BHoggqlafqCfinU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kw1AZvYl9fsLLFDrf03thMZpapgwREV573+aQgtXJh/1L6MywmzdrV1OuJ7BHGQNH
	 8v5SgpSQfSOWTyOcwAMNseru5+3K6ksmtAzWkk8GpbPI8NNusgv492yCWXaaeuYUY8
	 rKsB43XM+GHowHoQOSxt9fdNDbtekWruf8UMGYefBB4paSz565+bNU/RMnhv9Ldwjc
	 brX5s+dV2Nm+yBS5y6KTZLF6U+B3dD3TNe8Bp6CBYF8J0+80Ai9LK7K3WKu95nRtr5
	 d5yudcbvmB4UIQu6hbyjLzl7cZwBXn7TqxspmFCKLy9VpilG0EHAMDi/CpfJ/E8zBE
	 Hft7HhitnW3gQ==
Date: Mon, 27 Jul 2026 17:29:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2 1/2] mm: Use a folio in the softleaf_is_device_private
 path
Message-ID: <amdkR-gX_ABcKyCQ@lucifer>
References: <20260723030752.16979-1-hongfu.li@linux.dev>
 <20260723030752.16979-2-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723030752.16979-2-hongfu.li@linux.dev>
X-Rspamd-Queue-Id: 804141C000C
X-Rspam-User: 
X-Stat-Signature: buc4f33xapgktj6ddykkhismefopcwsj
X-Rspamd-Server: rspam04
X-HE-Tag: 1785169790-62857
X-HE-Meta: U2FsdGVkX18vQ+kxGCwoZIjUGgrOMjiJRKBVHkQLBzgx1UlPdxOMQIEirArgXhuPwUapCBGjW5ni242UAp7Xn82FVSF/6H2rb8GYK7F3+ncgWrIqnj7SmYWRbP/jwhdyxPbeHyKGIFA1fdwqrS54d6OZ9oSJD+qdTP6fkvOmABvIeSf25SR1seKqzwPFA8nHA5oMx4NUEIZgDUphZmIZ5YubbRHZovqdjCFXrdNWgF8XucWawf8iA33HEQdkOnRxZ6BxM5riH58KNQQ5xmZUEjtGDa7kZSU0mD6nkf28jN2D16xhbCBMh76Tc0SOYbzkRfhpQIjOIO6+JC5QxiVjjmzbFhQPrXV+GdX7QaUfHyFtpzO4vUX8G5HkrxJ1qeFpDmdr0GrPh+p7BtZuM7x/h2LvlE/+wAvNdlp+xMGdAPk+ramQsHtejIIU5jyGiCw7Nc6dXp8ClsU2ep5m4r4dX5OW5qULRaKTWRdIiBHgbL0ggQm5yRds4iHFD8kQxm1lIu3+8mvsbXYd/dSbpZamDHOQdBm2cXWnV1kF9Y/TTajXOAaa5sDFvgk3XJRQMS5yK9hsR9BC/DjtiZQt+pJVttNQ66YZvFncLz/4OrzJ9HNjklBRa6Z+6wOgNAx09dyjnF2+5GgaiQbwoyrxdZ/WCldm51ZaOKy908tqa6G7zB+ggkuSp/VerXa70j1xsQZfOB3xWSPzLvIHenEW2VB+rU+5+c0tfTCptgFHtYzvHirxjmHnsMnubnh+mwSa/YJkcllCBZU7/drCUVQVrqEbm0Kx2vU2PYFnQi/r+bg/aM+t/DcuT8ouESye6LDX8/ar8MNSzbM1n26m4H4fUm5yi6MLTrYQ49UNkWYwCU52WOtth6nYPU1o6uSF7Ot3yRr/p6m9rLHNSPIIsDOBsA1qPsIx1w/bpZw4NJhCB3qvk94K8NZJDzDS0uTSTxvAGGk6WVhfzx6ppEBzSmoDjt2
 NoU6o3/f
 GgSYnJyWPMfUwSMtYkY4EYTEKpeeDZcnGrfLxGa3BrqEVN6zJfz32tdf10CxI3ffHu8F2OZVK1HmAXmdjOCRvHyMggto00lZgmHf0ERF8rM+012KZj89h/2Xn8gflFhOMHYzyldWgh2t4wWJvNz3+qSJswTr35xGsQ7r/gKqo52f0nzITPRE0mWxKdn6fDj/2Rto5rfydnlRGsdcHG1Rb6UXGFxCangwSXsPrhGpNPW/8ercKUG8Y+rwm6TC3LrljwvJV2fgEdPUzz9K1eN8nAw7ILZl8JQQqIvfyG29+6XZGwzbnJkRvVDizBHOI9m329SOqxres4lXsR992LP8/Si9buVg1P0wwuj7D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:07:51AM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> Use the folio APIs in the device_private migration path of do_swap_page(),
> replacing four calls to compound_head() with one.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

With changes below applied LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d5e87624f692..ae521baa8c84 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4871,18 +4871,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  				goto unlock;
>

Up here we have:

			vmf->page = softleaf_to_page(entry);
			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
					vmf->address, &vmf->ptl);
			if (unlikely(!vmf->pte ||
				     !pte_same(ptep_get(vmf->pte),
							vmf->orig_pte)))

Since we're canonicalising to folio why not actually set folio using
softleaf_to_folio()?

So

+			folio = softleaf_to_folio(entry);
-			vmf->page = softleaf_to_page(entry);
+			vmf->page = &folio->page;

This would also make more sense in your 2/2. But more on that in a sec.

>  			/*
> -			 * Get a page reference while we know the page can't be
> +			 * Get a folio reference while we know the folio can't be

NIT: be -> next line for 80 chars.

>  			 * freed.
>  			 */
> -			if (trylock_page(vmf->page)) {
> +			folio = page_folio(vmf->page);
> +			if (folio_trylock(folio)) {
>  				struct dev_pagemap *pgmap;
>
> -				get_page(vmf->page);
> +				folio_get(folio);
>  				pte_unmap_unlock(vmf->pte, vmf->ptl);
>  				pgmap = page_pgmap(vmf->page);
>  				ret = pgmap->ops->migrate_to_ram(vmf);
> -				unlock_page(vmf->page);
> -				put_page(vmf->page);
> +				folio_unlock(folio);
> +				folio_put(folio);
>  			} else {
>  				pte_unmap(vmf->pte);
>  				softleaf_entry_wait_on_locked(entry, vmf->ptl);
> --
> 2.54.0
>

Thanks, Lorenzo

