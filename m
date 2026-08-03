Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90866C5516F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985236B0098; Mon,  3 Aug 2026 02:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936B86B0099; Mon,  3 Aug 2026 02:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84EA46B009B; Mon,  3 Aug 2026 02:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6736B6B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:25:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E256AA05DF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:25:42 +0000 (UTC)
X-FDA: 85058972124.01.07366F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2860E80008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:25:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IFD03ouS;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785738341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrAczNwFtdU85VsQkZuDqJVX+QLoJ9uhliuQtodhFUM=;
	b=Cdp26l/jpamnk4+CpvvlhDN6oKNeGEhLs8WdSnYSRHmfYQnpHireyZkwvtup7CnaMP+yza
	Fugqy6iM6zNvUqkE9FqhmAvXkEGKNAIhaAKs4dxFVfMBKpdIOe5XFkpHJjCfd14Mix2SmC
	n//ODJz7n8kWuUFItsbRK8IwDMXZDnE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IFD03ouS;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785738341;
	b=u3gMbNLDTHrdkYkYwSJNGw2v9bcYLO0NBvby4+GvceKznVut98ryN2h6SuPhvSbrnnTJ4L
	Auq1GRLKGsj6W5jiiP7O4D21MCEhtDonkOortuXpnkotR+Yjia+sy3vbR8hlKjfTB8XIr5
	BsK8ojn2ZSvbAtmTbJVUevfEXu9hg0M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 587C4143D;
	Sun,  2 Aug 2026 23:25:36 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A412A3F66F;
	Sun,  2 Aug 2026 23:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785738340; bh=RKq6hP0U1OVLWTz4hyoXRyz0INTLWTUzSfIHquC8AgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IFD03ouS7R1QaF5y+VtmO1ceFsWWEzlSTcW82WfqEa/NDxGR5uyUZLQ7wQmxjlFtA
	 lTCozgI7+Yk5Sx7cd67xIkGkOlWod9EQXdz8rkPGPRjVOLl7q71h8HRiu7sS3R5OYV
	 dVgsRaDbr3hAcZj/4ELVDuU0cNX1y1qHjMrulW+o=
Date: Mon, 3 Aug 2026 11:55:36 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
Message-ID: <meghpao4fryw6y5qrzk2y4576pkv7clzclf4tmg655lnp7tm2u@2juxush73364>
References: <20260803031554.30421-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803031554.30421-1-hongfu.li@linux.dev>
X-Rspamd-Queue-Id: 2860E80008
X-Rspam-User: 
X-Stat-Signature: ie1qknyb9kcme86gsoitooqa1kkrjyci
X-Rspamd-Server: rspam04
X-HE-Tag: 1785738341-343538
X-HE-Meta: U2FsdGVkX1+mZYl7G1s+vpiqq1ElDe3bsAXXnbdIPUPtmYYWJGzjmzk6j0jFfitzIp4wulzFZPeomosiOZltec5cA2LExls6pQPsHXLZo+iXDR//7L7HrNAL3Rapq2xjtSmTQJjZVC/eUj0ZrNO5ezzZL3CuJTlWnhsDZeQjwJYQdSZ4tv0U+BFU+Xc1DBJETuFT5zu55VysxzmtL7uED3U9QQaxcl7MazN+WBkcVfs53URqrVJnXskxmIEa92wGvyO8b6D1Kxbz5Yn48somgDRlYb2OgWgwozkXkEPZTrETz5Wk7DZe9htkpHKFHL9ouUBaoyNjyi0vE8xGjcMmfLE6uWAbnqI6gEkFH39WbsJbeUC4vn5bPqQx0LRMhFRo3b3cDf0SnijW6LLzAnkeDlsjYXni1WlSFgHBxZTr4Fqg7sdq0oFexMeC7ID2A21kgL5P9ayAkrpOHfS7Rr/qx+aC1ZYA0h6eT5XRmPT9bDM7G2RKhItoGFrJpR9RaMGjyZ1Wt3Ba8nnMIkj5WburbmZ0BYtPzmj8WMX7VL/47lJ3gKUGWZoYWgRlb6yDHXC+mOaL7X8yMrbaF59ara/IMoV89tlwq7Hj2Mr8HaLbB9HyIA6VhtGUXowwnnuYCEcp15QQl9bwYuuo9Zq8xfVA2b4awZ7MnznYQsLGsRayDC+9sidOUMPBpqQ/DbOp5cpNc8k4/SrKgzROQbmwbIfYOxX9pvxxdGfMxxmjFlzK71Qdda+8tevzY6h8OYc6k85WcUOpIEk2pFrQ6zaTIlaEyCxacbXGZG6RnHdXKVK9emK9axyzUmakKpO3AhuscPXGOBxUpAi5y6TV8SdBIepCCcTFhRf5S0oooPZbb4I5MXxNW2NP0ZigvCV2RgLV5rdZ5o1Oo2ZO1lf+ux6sB2NqFr24Yo0mRLOi3PdWeA4tyOvRCaaTEIm9HA2IGH/ftEwHKfzlr4r9jyR7wP5MG/n
 XCOgP7mC
 P9OEwNEnfcLrr+bdzipiMenxAKjE5k+pzb/j/rBWJnAwg3BTOHMqVo9o80TyklTc8xCup2OcphUHDSDQUmG/cEx/EcUYW3k9biOeijfTHz0wamZBWCokfMtWp1AXFJR7h66V8G++P4iVgke7lTBSUfal+aIS/ahYpbUzD00yUMvgdfKV1ouYJZejddaDttrTxnGAhMfoWXlZ977X2G3KKaqZpxDGR2ncEHllyqO0NHlwtJuRQg6vhp8H+CzhK3y6VGzKBigH1VKPwM/vxVL6JRW3NZ99dvasQ6cIaJB52pAQ8UHfCFvEO/QEALWfHTYHql1/X7z3AgDupfWovXt/IE4ZT1aJuO6WvqrOZKfuvnPzRDmr9N7ybxVBv7b1x4i/WDKH0nbcTfwOg7rjNji16ji+SzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:15:54AM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Use the folio APIs in the device_private migration path of do_swap_page(),
> replacing four calls to compound_head() with one.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Anshumman Khandual <anshuman.khandual@arm.com>

> ---
> v4:
> - Drop the do_non_swap_page() extraction (patch 2/2 from v2)
> - Added Reviewed-by: Lorenzo Stoakes
> - Link to v2: https://lore.kernel.org/all/20260723030752.16979-1-hongfu.li@linux.dev/
> v3:
> - Please ignore v3.
> v2:
> - Drop fault_folio, reuse the existing folio variable instead
> - Refresh commit messages
> - Update comment to use "folio" instead of "page" in the
>   device_private path
> - Add Acked-by: David Hildenbrand
> - Add patch 2/2 to extract do_non_swap_page() from do_swap_page()
> - Link to v1: https://lore.kernel.org/all/20260721013347.65698-1-hongfu.li@linux.dev/
> ---
>  mm/memory.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 56b244552f13..bbb289ba09d3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4873,18 +4873,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  				goto unlock;
>  
>  			/*
> -			 * Get a page reference while we know the page can't be
> +			 * Get a folio reference while we know the folio can't be
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

