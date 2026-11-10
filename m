Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6468F606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=M8XvkRLs
Received: by kanga.kvack.org (Postfix)
	id 7EEEE6B05B5; Tue, 10 Nov 2026 10:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787356B05B9; Tue, 10 Nov 2026 10:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5D16B05BC; Tue, 10 Nov 2026 10:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 444186B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:23:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7E631C42D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:23:37 +0000 (UTC)
X-FDA: 85419578874.03.628172E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id AEE0E1A0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:23:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=M8XvkRLs;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794324216;
	b=N5ssmXeupF1oRTxNbAmO4vHiTqdVTWhU9aun4M74ihgIgLY4arv/S2h1etNIdqKrNklcJr
	IGLtBSVStQd7zzm4iZBPIO3dO56MiFUlIv10KayHEMNpMZj2n4jV6CG4B8NSK86oFA59iQ
	JV1feHaqcGAnoyyfCq0CUYFkaMYaZRw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=M8XvkRLs;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794324216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ol7GNy+63xj88WNy00G3u2hsfNXRSF5seB3zhJoLPRs=;
	b=OLoMqDN2Q7EFj/ID5ZrnjRpHOqwWq/TRAMhU51XTxnw/Sz3lGPYZAzjOC3sXDmdfvRPGw3
	3rdIrhLICgggNyJJ8E+hmkYF8z/JCMIlQCHqSQnnAOJOGr2lJsYNaT19Q6nDHUh5SBoPYN
	I+8YPlreYIt4xc0IdLt0YQAcNtbLXNA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ol7GNy+63xj88WNy00G3u2hsfNXRSF5seB3zhJoLPRs=; b=M8XvkRLs89QZa2Lq7GTAk1pBcD
	4Aoq3M/qH9JrmhWSOBCqW0hW5i8dsf1R+hjeSZG26HKNKQ4xpi9otNdm0/miHHcYa5XMKSpodlcFu
	D1EYi5juV047C7gdlOwzi2N6GXUTM8o2udIwmcn2lxjA1yFX+7vIZlmswr0mw5zKzCt958a2779N3
	Ue73cYM7x/hwfMfMnctAmMIIT9N99fscyVCHIGl8LtwGeZ+rZ4IgoJutFHOlSzUvSF989UvcHyrAT
	IubOdrtKjQta07zYHDPU/q4OzI0RKlVgpKl11tyWRDm6Ai/UYlWNnO6H1dD0yDe0/8ahmfxI7W65Y
	YVNErJUA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQnh8-00000004M3C-1bpX;
	Tue, 10 Nov 2026 15:23:34 +0000
Date: Tue, 10 Nov 2026 10:23:32 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Lance Yang <lance.yang@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Seunghyun An <san55@wisc.edu>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Message-ID: <lwcxgxweftxmm42ujpctfaq2mxwviv33e4ml54ln56ssvlgrfv@hnm3jhsypjih>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
X-Stat-Signature: fkhgit1aqiu83w5cay9g8qsn8a6zaxn3
X-Rspamd-Queue-Id: AEE0E1A0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794324215-253475
X-HE-Meta: U2FsdGVkX186UVz+z1Js7uI/5TWE0466/mDQB0FxfuncczrXLkoIKFk+iisEL+NokyzXBSWAiromDcjYMFf7almKzIzpTvlXIlzh4vcDLpxgJhmlwaTKClBd4YStCGbp7xTGFkIt8+4cbLeZY6cAWx1UnAdK24SOI5WnLfCoQnMQAh7WmQn62MzCDjTi4aLL9TuhtsIraKQm8B+CGKOxWtI8OcbudipxeI9AF7SfulrgqO47rbBquLS++8kZ74jlP/lAcVCfPVXpH4kIqpo/IXtPchYkgJcBIbwM3qBYs3UbSltJzgla0b2oYWdsawqOmfO76akz5F+IyRjIaWR14YswFBnIYpT8mDuVtkpQzFXW2MsQ9po+5FAjfE0BYGPMSROpTrf7omY8+57mFfpQyk03LWAzoNiuSBP/0r43s4fhigyk9Gnlevq6l4Br1dfiKb00K44t7zhU00DP1p+uAPTdOxqRxV7jEE3R8zTW3HSYxEvID+TeJ5nZDEmUBuJQaqzlBCVTsIvMJgAI6qOlDrNzRXdXIG7JIUJcrirLxCCpq6ZkshS1MNeiJE+rgj1nlY/19nc8xa6qk0puun7Cf4W6SJYhm3X13G65e/3ZArNclPlegbYXE6GoL9SKBh3RUNQeSSELcFO+YbFmWegYw+6h2uIPKqnmjGC3PLOuN/Xgp0vXjg2lbFy57NHkpK8j+cedFe/H8r2BE2wCyrSSRvbFWaGZ/4Pf16ErMXvcooDv+SThldJwuvgbGtpI0BalmiOrnLPJWMytN7VWrXtmiRmqpnpcldZxcD8HbS8AVDx7ySHQ7EUmGuch1btEOiI7w8wodCqN1h7wBH7X+4qnn1kBNPoQpptyAe9d4F9+uJKjBk2Qyt2HSVyKCkVXZTCojRObRXiMYwZ95p2RCjpdrSlC560wNRBMbnGdDJ0mLfX99lF8rpUL4r3hKnmm65lon9pmwcqb7JRr/BEBJSf
 y+JVWBMx
 RQ+G889vhKx87ATTMT08XQVLch5kWZ54kTSTLWKQcfOb/xg5/xtsGGPFy/VEPJVdoZRynKLDQ56X6KLl3AK3LLity+V2XPg16utdKtb7BCBm+yT/83+VHVlzDWb/oJBgYlaxHclAEW3PLqpcndeW/J6BnDup8OrxmiobnFXlvX51far4h1WEnBSDvdTlHbtCzdWtq6eUsjV5NbZPNK+MnR5QseGvpQpNMZAl8anoTp0hSqcWyx+Ls8eFqI8JOMwCYVG1gQ8m+ZjT3RJfHqJCHtD8hzF3tNLUIw4IObz9G5tqeocIRbzjVL73yx++jPmz+SqJrLGtPueT6oS3iVENT5qpciVK2d7oKUBkQdiB28Dri3vnnk9ekZqGYEmnrGI+BSbKRJVrP6l4j7hSzG0Ni1cv2uwR0GzwIJL/c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/10 03:10PM, Lorenzo Stoakes (ARM) wrote:
> I introduced commit 17fd82c3abe0 ("mm/vma: add and use
> vma_assert_stabilised()") with the intent of picking up programmatic bugs
> when debugging mm code, but kept the general practice of asserting even
> when CONFIG_DEBUG_VM is not set in line with existing code.
> 
> However, it turns out doing so can cause performance regressions,
> especially when asserted in vma_has_anon_rmap() which is referenced in a
> number of hotpaths.
> 
> Since the intent was always a debug-only assertion, explicitly check for
> CONFIG_DEBUG_VM and do not assert if it isn't set.
> 
> Really all of the assert paths need to be predicated on this, but start
> with this one only, out of caution.
> 
> Additionally, since a detached VMA is trivially stabilised (nothing to
> stabilise against), check for this case at the outset, and update
> vma_has_anon_rmap() to not explicitly need to check for this.
> 
> This also, importantly, avoids reading any VMA fields if CONFIG_DEBUG_VM is
> not set.
> 
> Target the commit which introduced vma_has_anon_rmap() for the fix, as this
> is where the issue started manifesting in practice.
> 
> Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
> Reported-by: Seunghyun An <san55@wisc.edu>
> Closes: https://lore.kernel.org/linux-mm/20261110000002.1834454-1-san55@wisc.edu/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
> Note that vma_is_anon_rmap() was introduced in 7.4, so no need for a cc: stable,
> just needs to be sent to Linus as a hotfix. Thanks!
> ---
>  include/linux/mmap_lock.h | 19 ++++++++++++++-----
>  mm/vma.h                  |  3 +--
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9ccbbcbd7aca..9c3a9c6525c1 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -408,6 +408,11 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
>  	vma_assert_write_locked(vma);
>  }
>  
> +static inline bool vma_is_attached(const struct vm_area_struct *vma)
> +{
> +	return refcount_read(&vma->vm_refcnt);
> +}
> +
>  /**
>   * vma_assert_stabilised() - assert that this VMA cannot be changed from
>   * underneath us either by having a VMA or mmap lock held.
> @@ -418,9 +423,18 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
>   *
>   * With lockdep disabled we may sometimes race with other threads acquiring the
>   * mmap read lock simultaneous with our VMA read lock.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
>  {
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
> +	/* Detached VMAs are trivially stabilised. */
> +	if (!vma_is_attached(vma))
> +		return;
> +
>  	/*
>  	 * If another thread owns an mmap lock, it may go away at any time, and
>  	 * thus is no guarantee of stability.
> @@ -454,11 +468,6 @@ static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
>  	vma_assert_locked(vma);
>  }
>  
> -static inline bool vma_is_attached(const struct vm_area_struct *vma)
> -{
> -	return refcount_read(&vma->vm_refcnt);
> -}
> -
>  /*
>   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
>   * assertions should be made either under mmap_write_lock or when the object
> diff --git a/mm/vma.h b/mm/vma.h
> index 3fc3b47a954b..05300badd70b 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -278,8 +278,7 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
>   */
>  static inline bool vma_has_anon_rmap(const struct vm_area_struct *vma)
>  {
> -	if (vma_is_attached(vma))
> -		vma_assert_stabilised(vma);
> +	vma_assert_stabilised(vma);
>  	/* KCSAN gets confused about the optimistic check. Silence it. */
>  	return data_race(vma->anon_vma);
>  }
> 
> ---
> base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
> change-id: 20261110-vma-fixup-debug-asserts-2d327fe27f8c
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

