Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D443FCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BB56B020C; Fri,  8 May 2026 13:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395C06B020D; Fri,  8 May 2026 13:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284B56B020E; Fri,  8 May 2026 13:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 120876B020C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:29:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE1741C064A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:29:35 +0000 (UTC)
X-FDA: 84744939510.14.44A1FAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0DE3440008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:29:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DkubKOtD;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778261374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JtqdeNZQzTyL3ck5v+8v0MzEqnK7N+IfhFNzWDiWTo=;
	b=gH54MZp4ADbjgCxKQZm1UyLS8/5az+DYfNRfxODVM+ddGqdF+C7FkXKTCLZwf1/h97qBZO
	3Q2N6+iA63ywf7NHamTihYsNzcVYxhPkiR2HKiW/o04ThQRqzC6IcWUzTmFYNEKDp6NLb6
	/plVdTmysT7qRbgy2CDa1FQE7SRRw38=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DkubKOtD;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778261374; a=rsa-sha256;
	cv=none;
	b=IrrhjcPsDiewoxI5i/dSFdnIOxe6lkC2ieWyfiKg2NA5722ayMhUIrdjQk72gxd17w2okZ
	Hc32lKa8mNRjJjmUr7PKKgTMvDqxqjd25Yj3VynKeo6fDdBrRwgX6Xuk2HvP4bnNVVuc62
	4rtxmtc8uOa4uit03PQGL3lBfC7uTXc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF2DD406A1;
	Fri,  8 May 2026 17:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8921C2BCB0;
	Fri,  8 May 2026 17:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778261372;
	bh=6SVrO0LmOjWH4obgCokBnZqfrETPZpR+dj9JHY4awYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DkubKOtDiUcZwfo4FOCvSQ2G/fDHpJgYZc9S9NhkYt6NS0BD5CXbcJcY3v/LpR6R0
	 yOsPdGBnv2+X+vMyyTX2SL3lLQ/q1TlVzLyqSoTJ3l0EkAQgKUJvAS+/hLCQ/SAdhq
	 8jwtQBZZyUFTRLLNUiAsF7n04TPU/brw7uXifZZAEhnZRDhXmCSeIrkVXbSn7c78nT
	 7ePqU+4QdYVg1cSOhVdNvYsVGS/+1JASfp2loVGoBwkiJmQ66idhGc0Jy1SaWTU8cJ
	 6J3muLhBqGy3y03DqAcTviRpK5VAmdoC4VclNmYqkeaNh/YZy7ZdTMnYrYc5XLJXrh
	 x9Mu7i9IG91sA==
Date: Fri, 8 May 2026 18:29:26 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 4/6] binder: Remove mmap_lock fallback
Message-ID: <af4dDky6E7DjV-hr@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182000.93887DFB@davehans-spike.ostc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429182000.93887DFB@davehans-spike.ostc.intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DE3440008
X-Rspamd-Server: rspam06
X-Stat-Signature: krend3gpjponrzzufsy76wio1wkwz4dr
X-HE-Tag: 1778261373-645237
X-HE-Meta: U2FsdGVkX1848rUW+hibFuDWfJAkvdCqeKHrWDmfpgBqgcdv8w1cOoNpzEtj3GVuqB8YhoS36Veij8BY8nVjStVuLJjjcrRx+8TmsCLr6jc8WJCaUp7SnbH6L2ddDyu9evgDTLjp3ZwSxBwfpdoMxe5gLxuiXpq0SPWYj1O2hGK1t+0+sWAK9Y8q2FITJ5JRHHjhQKupX/tycHlQYTgVFYk3aPlXJcNH5nVxgkZpPjrh8eG2pUSJ30xAaV2+moo5TyYMDd/Tqp8fnFZZO/9NiiEXBvrjmDXYY5+T+rgZFbwQcjdUjm0EDAUIik3hg0CbTxZ5jPqV45VZMwffbUHEx6jsmVV6dHMxJNFwjdHeWS1PIx9DyYZ7mENT5JUSwjFD/+PMfPY9lzVyDDFXJL4dTU+HCsLkLwBrPPqZ+vkUmtk0LMTIRCLfL56uggKHDObsiYCKQNqxoZ+/TiBTY3l1cmGGMZ+4vPfSFla5/ykfkZN0v9F6WSXPaUcWDS/iMmCBlsC4VxG0S8pRjrXlSc1ACVdozONnbCIwr6q2y2Ul/m/wvQtAIOVnBSetNMs4wynKi296bc8XfPdHS8918SL7UMGCoQRaNfqCUxYFbC749IGlcxjhzJeY5lU9Ot7rudlOgXh9PTdWs7we2fSCwDBE1Fre+p//ZAZ4lTjcq6LZWSxbKx2AN6nVYF64YBcPWVHj2EsmLalwiZwFfZvy3zYJebhrSVD5OK+9IyAX8GR3rvH8UlR1NIIbcWaLIZBRh3ZCc0kIQ60AG9F38pTKMOnGuIm9FKVadK7CoA5CUw3T+Uj7mXsEWm7OOKVoh8whGqXE5I65eRftlpuNLlHm4IP+yKStMcdfL40MhYHMy+WfFEeMtD/mf6NSljhwZhjc0rvAUTKhuB7lrguqvyAQnxlTrWpBxOpcikuttEuXO/BtVWxnssyafNQCZ/VkOW6nBunLPXlSR1L96A9S/nGzQM5
 3kt8jBWV
 PJePqOu/owW4hKUqUcQ3zURnDDbf01QiSiY2VyPmWWf7V0IVWq1uTnX7b+xbtLHNkmrjfbi3tDo7r8ax18rBLulNKttV4+tXFbbasvut5cWPu2L0IkLS0Fpi32wyOSAhQMrxKs1Sd3opZtNeFq9KX8bZ0ZSdJHcsqIko2m2LMw9bJGmorJHJndCLXq1xBfjfxsRnspHY797dxjzhbdQJZIdob0/4NC2N6AAN7nJ5ftXScUg6FM/iKGlXd76gZIIxmQf6U9sjM/44FoQsqLyAIu7wWZd2IXDvfv9f5YL8bCRLKKNHQjK0ek13qyUehjIMKzUl1PRjn3UJbgw5CNsS/Ex9GJ/7ZVP95mQLTe5FlM2HpFzZAbvft5puYZh1w8Fklt1OPASg93MthneT0PN6Ouunlc7ik2KeWtvEkUSstj1jxHH+ZEa3EHWhdh4w9moW7HOHC/gScQJXJtLQrlFDg4yvQO5dY36eiaicyVDIHusntBifZ2d0OO+17wMhG1mmdOzTP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:20:00AM -0700, Dave Hansen wrote:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> Previously, the per-VMA locking could fail in the face of writers
> which necessitate a fallback to mmap_lock. The new
> lock_vma_under_rcu_wait() will wait for writers instead of failing.
>
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

LGTM in principal, though again not a binder dev so just an A-b :)

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> ---
>
>  b/drivers/android/binder_alloc.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
>
> diff -puN drivers/android/binder_alloc.c~binder-vma-waiter drivers/android/binder_alloc.c
> --- a/drivers/android/binder_alloc.c~binder-vma-waiter	2026-04-29 11:18:51.307654829 -0700
> +++ b/drivers/android/binder_alloc.c	2026-04-29 11:18:51.310654944 -0700
> @@ -259,21 +259,14 @@ static int binder_page_insert(struct bin
>  	struct vm_area_struct *vma;
>  	int ret = -ESRCH;
>
> -	/* attempt per-vma lock first */
> -	vma = lock_vma_under_rcu(mm, addr);
> -	if (vma) {
> -		if (binder_alloc_is_mapped(alloc))
> -			ret = vm_insert_page(vma, addr, page);
> -		vma_end_read(vma);
> +	vma = lock_vma_under_rcu_wait(mm, addr);

Yeah this name is definitely iffy haha!

> +	if (!vma)
>  		return ret;
> -	}
>
> -	/* fall back to mmap_lock */
> -	mmap_read_lock(mm);
> -	vma = vma_lookup(mm, addr);
> -	if (vma && binder_alloc_is_mapped(alloc))
> +	if (binder_alloc_is_mapped(alloc))
>  		ret = vm_insert_page(vma, addr, page);
> -	mmap_read_unlock(mm);
> +
> +	vma_end_read(vma);
>
>  	return ret;
>  }
> _

