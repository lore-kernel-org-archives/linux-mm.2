Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E38DC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750A56B007B; Mon, 10 Aug 2026 14:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728E06B008A; Mon, 10 Aug 2026 14:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619326B008C; Mon, 10 Aug 2026 14:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D29E6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:53:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A593DA0278
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:53:23 +0000 (UTC)
X-FDA: 85086257886.17.7E1FF95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EC179A000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:53:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOG6eDQA;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786388002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/eKo78QOe0SXZpHQEeh5FfA11qf/k2Y+f89Z+lzEo4=;
	b=deIXWvimRQCFTlDZNygt82Gm9mFX+b9lNRM/eheDi1Yiqr9wtNuUukQHekXeLRpL4k4idN
	YOThDSzx8wyMpLNiZ7bl3BXrb0C/N7KHoQcqeOYJ9VFdBPAquTDQc6TOOwdQodsqLKSiSE
	9o7I4LwX88YLDsQVoYgtnVGVzp0I3as=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786388002;
	b=FuZHbmwFt3GyBVGfkFeUowCfAkadn69Qg8v8Tz7usfTY4Eso4SQ+Q9ZMmICow/9t5/dzY4
	wJBzXbiN3EEmQTNPSt2snWTiLfvQqo2XLVEAznlGIsiXkvNMa+qFqvLsg9cm5xNPHXm9bv
	OLYPwXfoGLAzyrnNpBKintNMNj9wazA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOG6eDQA;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61930600AE;
	Mon, 10 Aug 2026 18:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19D41F000E9;
	Mon, 10 Aug 2026 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786388001;
	bh=g/eKo78QOe0SXZpHQEeh5FfA11qf/k2Y+f89Z+lzEo4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WOG6eDQAaHhbYQgktX3rdJKmd8CJkea3MKk2oTiU2wj925uVkM8nPffjXQTO3dV/h
	 s9VG6v0qaUkP4/p3aGwYKzbJAJTZ3lxgWRtEQ5uImOjsNgDQgeDiC4qiGW4rLiKZr2
	 nF1Mi2CM/eRYQXOx4HslEN6Dxj95iy9PdF92I9Ox3ByCRkoctWV96DCUE3rxz6Lgkz
	 7ZmrV7DmEcaeFjj5HMsQ6fPRu5PHXse3D/03Q1KKfiXWS1RafuvuWtbFLzqA+IBPNh
	 N5E2HUTv2rLS2fNy5GK0VWXFtRVWI+a+dGg+MsL0U+THRNlsealu3NygYuufoFqdR/
	 Mr8kppBmiTJnA==
Message-ID: <50b1dadb-37f1-48a0-adf6-c6ff8b704582@kernel.org>
Date: Mon, 10 Aug 2026 20:53:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH] mm/cma: don't release CMA pages still in use
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Mason <clm@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260810122737.030f8452@fangorn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260810122737.030f8452@fangorn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC179A000A
X-Stat-Signature: iiufbn1gr7jtqnbuqhk8nkaneck899z7
X-Rspam-User: 
X-HE-Tag: 1786388001-607681
X-HE-Meta: U2FsdGVkX18oUYg3jK3djybX1pS+2iVbN5WS0dTnKRQfDmtCcdzdWlSxIJoWichlnhXUjsRvxEOayJVZcmOyDQ5qujzhrisGBHvVwiQvU6pcM5gO3RsfzGGDiT7+kFhyxvBcehpQg24gCcB5oERnCSgqvfTiUl/T1YQWIzLqAE/PAJ9cck5gsnc11V8sdGy61qBcQ/nv1//KYmiPTX0lXeuapeXWHDO0bbV+Z23qKVKB3zF3SIfrq6JcuZVEF0QFI3vNz240TPOfXyPgS7LowTzFe/VU0IBjz5sYdVxvKJwacW8xeESFoWH64aB5ROgyWNxNGSO2O/T1U3w8XzxZynuASKkBDghOF0A38V465mLLKQ2HeZUW3WmW8IJ/yEGuQudufzXyYEBeAUWDq0TWKYA9Zte3uu+aLrUcLPQpC1+AsW/e+pJZa20+euBPPQjNujxbUHaRYy5bJeyDcyu7qLt86t2aMV7tJtlK4pWPsfd6q+Ex4/735KZZbeOTKKJaKjv5Lb+ADTX6n3Knj4DtSOgDE/jaxSYHRvIcd7YADktJ7UtlPUkmN+BJEyRaRH3+foA5TB59jAQiR2Yac3ABkFJVSp+Wvf24MyQ/A4RZKMEsSqK0khEVmbc9x4uiWIZZOQne/jHawYhZce3XiwLMVezUsPHz7YAaGD9xaU6d6UlqRp1vU08+FblVJlXD64yOtrSNKauXpZ8/vWH8OToTvLxV3HfMVDaL10pkPZWJI6THqCChZjnRl72biLthrJOuhzdknFsk7xxA7NhbXhcl34oxRlTYu1EI0a1LahuxlrQwd3yunqkAOrF+pp5PxJs/sIIdBzkrbPINuD1s8AlJPFX7qf/VzOLvbGZM1w5qJjeFeqTS5FwDRMS28ev8Hynf8kjI8+Afb0TMVV2M61gDdlxPz/keF+YsJRR5jjIQ7Msj2IJmvPECZjm1dyRq5GJcTfaLD9qdAOPPqeXzIC9
 Uy2GVjrT
 tbpRJsZmNoAzw++iEq/7NMcqK0koI3UFirPD1ttuGJfp4qirmvSKHOEDpKWnP2ize+HPY7lZ2o6cHWaTjTb5jT7V/Cwd5EUp85q16X4W1q/WlDKx86cVlNxXeXzb9DVMXEntTB29JxYuLNn6M6Jlr1/LRBiNKzk/j/VA0SPB36V26UV/vztNGDdVLHaJgzo/u42JACnEyEtwrCQwEZxV7Fye+C6jA28GmGNOd9wz1lW8of1hnvR/aay3GJ/7udtDQqBKHh31T6fygKybrjIGjIwroFRXrjasC5fK05tiiQxBe/rg+I7a5dNW5Bbw91ZGkrTjPHG+jDvs/wH4gWRoTmOk+7BEIWXa723n/PAqvQ7BtNlKjDT4Nz2n5hhTgG89X1ti2g7eeOSHKWz8L6CBgXImSSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 18:27, Rik van Riel wrote:
> When a driver calls dma_free_contiguous() before quiescing DMA, the
> page still has a reference from the device. put_page_testzero() there
> returns false, WARN fires, but the code proceeds to
> free_contig_frozen_range() putting a live page onto buddy and clearing
> the bitmap. Later cma_alloc() hands the same PFN to a new owner while
> the original holder still references it.

Hm, it rather sounds like it's really the drivers job to quiescing DMA. Are you
aware of an in-tree driver that can trigger this, and if so, how?

Freeing memory through CMA, while the memory is still in use is problematic for
CMA as you discovered :)

> 
> A concurrent put_page() that drops the last reference between the
> testzero loop and free_contig_frozen_range() can double-queue the page
> via page->lru, corrupting buddy lists.
> 
> Fix by freeing already-frozen pages in contiguous runs, while keeping
> still-referenced pages. When any live page exists, a future cma_alloc()
> on this address range will fail until whoever holds the extra references
> frees those pages.
> 
> This change should be safe because nothing can get reallocated while it
> is still in use.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Cc: stable@vger.kernel.org
> Assisted-by: Hermes:muse-spark-1.2 syzkaller
> Reported-by: Chris Mason <clm@meta.com>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
> v2:
>  - don't play clever games with the CMA bitmap, the page allocator
>    alone will prevent re-use of not-free-yet pages
>  - v1: https://lore.kernel.org/all/20260809210608.06b5ccb9@fangorn/
> 
>  mm/cma.c | 39 +++++++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index a13ce4999b39..cbf8dba8f077 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -998,7 +998,6 @@ static void __cma_release_frozen(struct cma *cma, struct cma_memrange *cmr,
>  
>  	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
>  
> -	free_contig_frozen_range(pfn, count);
>  	cma_clear_bitmap(cma, cmr, pfn, count);
>  	cma_sysfs_account_release_pages(cma, count);
>  	trace_cma_release(cma->name, pfn, pages, count);
> @@ -1018,18 +1017,45 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  		 unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> -	unsigned long ret = 0;
> +	unsigned long skipped = 0;
>  	unsigned long i, pfn;
> +	unsigned long base_pfn;
> +	unsigned long run_start = 0;
> +	unsigned long run_len = 0;
>  
>  	cmr = find_cma_memrange(cma, pages, count);
>  	if (!cmr)
>  		return false;
>  
> -	pfn = page_to_pfn(pages);
> -	for (i = 0; i < count; i++, pfn++)
> -		ret += !put_page_testzero(pfn_to_page(pfn));
> +	base_pfn = page_to_pfn(pages);
> +	pfn = base_pfn;
> +	for (i = 0; i < count; i++, pfn++) {
> +		if (put_page_testzero(pfn_to_page(pfn))) {
> +			/* Add it to the batch. */
> +			if (run_len == 0)
> +				run_start = pfn;
> +			run_len++;
> +		} else {
> +			/*
> +			 * This page is still in use! Free the freeable
> +			 * pages encountered so far, but skip this page.
> +			 */
> +			if (run_len) {
> +				free_contig_frozen_range(run_start, run_len);
> +				run_len = 0;
> +			}
> +			skipped++;
> +		}
> +	}
> +	if (run_len)
> +		free_contig_frozen_range(run_start, run_len);
>  
> -	WARN(ret, "%lu pages are still in use!\n", ret);
> +	/*
> +	 * Some pages were still in use! This should not happen.
> +	 * Subsequent cma_alloc() calls to the same range will fail
> +	 * until whoever grabbed the extra refcounts frees the pages.
> +	 */
> +	WARN(skipped, "%lu pages are still in use!\n", skipped);


We still issue a WARN, which itself is problematic. See "Do not WARN lightly" in
Documentation/process/coding-style.rst.

So it's either

(a) This scenario is valid to be triggered. In that case, WARN is not appropriate.

(b) This scenario is not valid to be triggered. In that case, this is not a fix.

-- 
Cheers,

David

