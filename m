Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C24F5A8AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B66F6B0088; Mon, 20 Apr 2026 14:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767076B0089; Mon, 20 Apr 2026 14:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CBF6B008A; Mon, 20 Apr 2026 14:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3216B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:27:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D29EC5C13E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:27:31 +0000 (UTC)
X-FDA: 84679767102.02.49198B8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6E38180005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:27:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kaWAWf0K;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776709650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLIX+xxXAjemUdxSYuHOuwKYeKdsGBn4WrCDh+lQ6mw=;
	b=ks3HoytR+tdcENIu9+ClyfnHCBpQt7rmh+We9SPlY9mNVUvNQbM67k2wHheeYvRwn7CYrp
	GcubUPmt/V4lhS1FRlx2RdmmXWempgE9B2/dxfwnuzRSeo++aLqPmeMftXS+Plxef8BwGT
	5R5QTwABma5cd82B84vCR8ou9PFsMOQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kaWAWf0K;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776709650; a=rsa-sha256;
	cv=none;
	b=HoviSOU3jjCz16MeyhIAAtFZiNel19rJ8RxP2LtlAvV2onScSaR3Vq0oDyIwsiMAzOSwC1
	8aRaMuGwR8s/WbVn2E0w94yvBe95E3Rp0EoxdZs0/NcUNrxtFTSTn2ytkVId5sh9CgKy4F
	B8CoraXXq59EXyIX52yzDx0GX8jmVIY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tLIX+xxXAjemUdxSYuHOuwKYeKdsGBn4WrCDh+lQ6mw=; b=kaWAWf0KMUTkQbFigTk+u+H8bm
	0fdGUmtJavbSvVWGggAzL5BiyMtURI1pMB2HaC4UCMrEAAzImymyNZnmlv19BNyh69epGlwMUVzW6
	FpoTE2a65d8UGLYwYb44iCZYqDoJIfRNQGlKciMyICkLlpU8JeQNzacE9hRTR4FQoF/TaeW//XNk2
	yFiCo8KQraXB3vwIMKCMssd+Q3GV/2E79ZZfd7KpzNrY0t6A/EvLEPawi9SUHsTEvuJGcRHjJh0gZ
	L87WP+nPgztOoAN2oUCeZfpHTK1ExYTIUeAIHfiE4dyqEWdXdTeNmq68Kt62uS0gtGz5u1Spr0T1J
	kjxYX3nw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEtL1-00000008rF3-3xNc;
	Mon, 20 Apr 2026 18:27:15 +0000
Date: Mon, 20 Apr 2026 19:27:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	osalvador@suse.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, hughd@google.com,
	baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index
 conversion
Message-ID: <aeZwAz6PcdlqSnJ2@casper.infradead.org>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-2-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-2-jane.chu@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6E38180005
X-Stat-Signature: qo3gpegba4zbm4jre5gde64ecg4rt37d
X-HE-Tag: 1776709648-187150
X-HE-Meta: U2FsdGVkX18j1jWOqUQMNgtudhQH6O4OtEqQj23ZXICNZHvbqiY/67jxH8DiFofAID3Ty3QVKaB+lST+Bw9C3cAWOAPlzc6ZZGKYE+Ed0Qbvkf2C+COUxWZCxL3b/FqKwHUITEFdsLTfVSp8jggS64LskDIf5JVpqz3OPrmUQGs/6BSiIi+QZhB6Fe61/W5TzOApFfPCUmrCGO1xizJ2lX2x5csR/sk9C0JA2Ig41n4E1AnSG86bv2d2nWWqA+ZjDDUrUtcqophIbT7XRElfVorh/cdyADmFKwZkWx1Cro9h3DhIux71AARnDN18fREeMVWPk8cYTML+4DmmSTf4gvDHjX+27QOvIA9ZBYx1c4+s+MxUZPtIKwMHQdkNnGSzvwoOWvdw7KSJdRxf8ldwLh5zswo4pnafmCyLhd+SxW+mA8AYxG38UkN4hfjEzT+sfBYL7iDtgpL33IFB8z2sCu1veeZrKnn5ukaEtsra3DgCfs44mj0AmBic36EjedXZQ9JO+I3rfQv/auOMO3FVgSNUDDIfD43eolqS8VSz4ZibJvLBQnY5vre+Ig1GthLsDSLhToMPJ9BhyxvCSo1Bbx/tiWeafMHC3Zmoi23kwV4B13JGPMZrz7wzwnxR64YB1Nw/9gvkjkvVXkM/9Hlmbeuni1kbauiqBj+3s8l6kfjhy7fTjGk0zIGfM4B84o3tnrmBNHl0N0blzYnvitmK9/Wo9dV/SC3GUvcsvZ7UrbkFIzMYVjTly7f6JLiSwIoLV8CfW3dG55g/Fct1/aZF+ChAEwEf+AW6ZDchjc4ERmKFzuVGhLiG1abeOLLkoYDWjcyETEeb77plqUv10jGpWrQO1ARrR7HEcGxW9tPVAXTPky7YnxmjQclSCpKTJQX8k5U6MnbsspkaqLFLxtER3OJXtGPfCiSu5Vt9wR8LBexZbCCRiNI0UzQkjSMdZapRL+x1W2aJyAUbSTU4ygz
 564l/cr4
 X0go4bsvPX0RWK5b1qZDiwiB9sa0diJfbagSTm9QYBaVfsaNNIcaGa+pTscRwmbH/8UMhUdaES+BP+43Y3AAcrZJPYEod5yOSm9q+kXSvnDAhiLm3EGAafVDOTYk949akxDHvdi5OsK58YgrMFDuOsKLLckZQRke8kmQytwHynTvQZzeLiAH1xOLQBz0v00+gnI1Z2iHWD8fzt7BVwYKcjgfD91pTD5ctV2E5E4vbaq3witozIU1+bUMmzp0lZizYKmrT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:52PM -0600, Jane Chu wrote:
> This patch removes `filemap_lock_hugetlb_folio()` and open-codes
> the index conversion at each call site, making it explicit when
> hugetlb code is translating a hugepage index into the base-page index
> expected by `filemap_lock_folio()`

I think this is too large a piece to break off in a single patch.
The first thing I did was look at hugetlbfs_read_iter() and wonder
why we're not able to use generic_file_read_iter() here?  It used
to be necessary because we used to index the page cache in units
of hsize, but now we don't, it seems to me that we could use
generic_file_read_iter() instead.

Now, what hugetlbfs_read_iter() does have is support for hwpoison
handling.  I suspect this is something we want in
generic_file_read_iter(), it's just nobody's done it yet.

So perhaps that's patch 1 -- add hwpoison support to
generic_file_read_iter().  Then patch 2 removes hugetlbfs_read_iter() in
favour of using generic_file_read_iter().  

Patch 3 is purely this:
(and you can put my Reviewed-by on it).

> @@ -652,10 +652,10 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
>  					loff_t start,
>  					loff_t end)
>  {
> -	pgoff_t idx = start >> huge_page_shift(h);
> +	pgoff_t index = start >> PAGE_SHIFT; 
>  	struct folio *folio;
>  
> -	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
> +	folio = filemap_lock_folio(mapping, index);
>  	if (IS_ERR(folio))
>  		return;
>  

Now for patch 4 ...

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a786034ac95c..38b39eaf46cc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5724,7 +5724,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  	 * before we get page_table_lock.
>  	 */
>  	new_folio = false;
> -	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
> +	folio = filemap_lock_folio(mapping, vmf->pgoff << huge_page_order(h));
>  	if (IS_ERR(folio)) {
>  		size = i_size_read(mapping->host) >> huge_page_shift(h);
>  		if (vmf->pgoff >= size)

This points to a horrible problem.  Everywhere else in the VM has
vmf->pgoff in PAGE_SIZE units, and of course hugetlb works in units of
hpagesize.  So this is an entirely different piece of work where we
convert vmf->pgoff to be in units of PAGE_SIZE.  That'll be fun!

> @@ -6208,7 +6208,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  
>  	if (is_continue) {
>  		ret = -EFAULT;
> -		folio = filemap_lock_hugetlb_folio(h, mapping, idx);
> +		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
>  		if (IS_ERR(folio))
>  			goto out;
>  		folio_in_pagecache = true;

This is a much smaller (more contained) problem.  At least idx is local
to this function, so you can calculate it using linear_page_index()
and modify the whole function.

Finally, you can delete filemap_lock_hugetlb_folio():

> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 9c098a02a09e..c64c6e5e50f5 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -829,12 +829,6 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
>  	return huge_page_size(h) / 512;
>  }
>  
> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
> -				struct address_space *mapping, pgoff_t idx)
> -{
> -	return filemap_lock_folio(mapping, idx << huge_page_order(h));
> -}
> -
>  #include <asm/hugetlb.h>
>  
>  #ifndef is_hugepage_only_range
> @@ -1106,12 +1100,6 @@ static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio
>  	return NULL;
>  }
>  
> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
> -				struct address_space *mapping, pgoff_t idx)
> -{
> -	return NULL;
> -}
> -
>  static inline int isolate_or_dissolve_huge_folio(struct folio *folio,
>  						struct list_head *list)
>  {

