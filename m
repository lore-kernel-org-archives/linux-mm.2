Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8801606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1/RpaODb
Received: by kanga.kvack.org (Postfix)
	id EDDF66B05B1; Tue, 10 Nov 2026 20:29:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5206B05B2; Tue, 10 Nov 2026 20:29:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF826B05B4; Tue, 10 Nov 2026 20:29:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8EE46B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:29:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 522E61C250B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:29:34 +0000 (UTC)
X-FDA: 85421105868.10.92B9CF0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17118160003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:29:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="1/RpaODb";
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794360572;
	b=DyCfBOwsO1Ie7O9YpvJ2rD+YDpHHHzi+f2O1zd6KeUbGsDiUjv19DtiO238MFcjys7759J
	BQA8KVYWWN7ZyhLEoKTm91iKNIXQNTbf7c8/YkfpAQe5HgAzYzvHYGmc3cCdZNC1rEguI8
	L+hQQQvyZtVaEDNlxrvEW7TdA4uYquQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="1/RpaODb";
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794360572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJO9J925Zyjd9oDjnhBcl5C5X6Z/lz/HeHH0GON15bE=;
	b=l6ShLJjZx0ZbMWov3+88SoSB64LF2iaqFFyt+BQV5VieTrBfLJjZZogdGkEb//TysYiswT
	DwWJD1QRHwUvfdCuCAfrjCAuG7SGrgwhU/0UElNcrHNt1v/e2ddT0NuEHpxMA8LNg+junn
	95RnZv31wgZN47ONhKRFCdzmLEUNB74=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WJO9J925Zyjd9oDjnhBcl5C5X6Z/lz/HeHH0GON15bE=; b=1/RpaODbmOCV8/voA+ETbz8wIS
	D+MaCvQiwqxGlBmsaZVcjMWo9siecOysfznzNvNxLp32tCxNP8NmbhQuvNqu0b/Ab+/ny+6DrFa/U
	QNXCMXOUZ1vY66BQIkkvwftL9xMoX6RbizU0ClULKa1/5GyZ4x9GUu/axBRuxtPJjS51a+PH4rxJo
	vhNkn/CP5C7yNkY5/zW79XGdaRneCY/yvD633z0/1cJ4KfvClFbryn0+bHAuRTbvGxppTWSzm0jiU
	0MWFg67+2eywVbIT4ZGFgHbtrKRWltpz4JvPmcqwVgKMCg2saBYPW0dASl2K3nRISJ3IvDnlS4rPE
	lvO3aOoA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQx9W-00000005Nbn-0Ih6;
	Wed, 11 Nov 2026 01:29:30 +0000
Date: Tue, 10 Nov 2026 20:29:27 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: only assert VMA locks if CONFIG_DEBUG_VM is set
Message-ID: <dtmgkdxvqouwm2gipfccmnxjjm33qcamkjunh4cyqrf4si6ixi@g5uussz2eqwh>
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
 <20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org>
X-Stat-Signature: wcrhq9yqw695jdbounzbj6ayp9a9txmh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17118160003
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794360571-178178
X-HE-Meta: U2FsdGVkX19CeA7hf2Yec15qrwUODnAOKBiVcsY95WNdWAPzRr67iYiw4zhfz20W69IhC7qkNl7IzSBG6yoQ4xSwvzkn6NC8kja+XXK85k+KJd84npSjLC1WIil9Typ9y07Mr4meJPr8CNmHs91QzfAukTwXt1WmgQQCP/17YQcpDmJyDrnfgt6YujChEQL2iGfwSariIMqkLlSiwH1azjsm0wFUUdyMRTT6k33aND4SV0X9Tlq/BdrUn1/bdxKKPQcke3T/3qpUDVk6SVk4D+HlmCAOs/G5rYTsqUAmYLKOr1qu3joUxdAlWfawMINF8Om8whiHGYq43dEF1067DLkG1QBWmDEgbijVa/lbXyWgqNFiKOu3fjdRg60eS1rvsFHfCQ6nLMScnGD8ZVGc1UayQMbWjhrUMdlTkAstxrzhZbrjITO7xNCNX/QMG/pnWV16KLgHaoVDz87OpAGPbpEDquFjxj/Xt2Q/TNtC3IlhvXTGDclGFMCCXxJxeuq82P/PSmI7fqybclNVGcWTVjo4AsQGBHq6zMcgxrfLGUD4A1olIhtR5wH+wQz1qKjXp4N6OhONaLRjreVFpwnKAhiHua+SjobBai1E/Nwfd8MXebs4sdb1IeGax5HmioRLplYUJBRScof1BIymSyv9PT677dQbzTeSfYEeaDeplRljHx12kXb8gYGTNj8KikkURo4SFVO1jJj5Fb5FAgzY7z4u45YU/1gPny40H59EOtH9eJLKpW6d2NJo4Owb3z+cEs6AFkniekqcy3pKklalSzAZBQ5wo7HT9XGoAW8azw6itXtBCEvWkx1cZ20UqLQGHvRSdxYX7xcb/spQrbIiIFNNxAyzaWWjNzwuwbNxniA71PeZWxHGhnjfx8WMFdBMPkZblw5h0fDY0BJdvFV1VTArnf5jBVCURsv0shngjZWxsGXznTUG4cxzfN1miH4SUBrpMJm1Gusm26k698G
 E876LMIo
 OGyWmmj/+w136PXuX372hnBZsyDY1+EeQl6BgzDgkF+ubd1Fyi2y3G9C7mEJOIQm1hz3Z3lu3CZx7gaUzj+Q7iROwJ4ZdNffx1p38sTK6aXMkBqJ6iYGal2a6TjYfx41wLAWc3Ni0Go4QAzXhrzbeMJI6yaklx9yyLT6droj6XJaMaI9v2S/JIWDUkwWywD2HVG5uL+QfObiiMRz+/V9RUzIprpNZ8Uw1JxAw5rZM0N0sSk6RjUxzveWc81L1IaT3DdHXjikxKMsZeUOCFQ+hUM9A8GZozRA8Rqvdn5CqDMagvf3znd7GOCaB3jLL3i0zT69+fqQwzsFzgoQk0Zmrx/5oEay+vVK4yKut7iin6GQ/812Jh4vw4blv6DIq4akT2yy49UMCYvFndPQ5cVA1nj7BapTj6izhxCC2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/10 04:57PM, Lorenzo Stoakes (ARM) wrote:
> Similar to the mmap lock asserts, we have also asserted VMA locks
> regardless of whether or not the kernel is a debug build or not.
> 
> Similarly, these are asserting basic assumptions about kernel code which
> should never assert in production code.
> 
> Since all such bugs are generally asserted using VM_WARN_ON_ONCE() or
> similar, it creates an odd and inconsistent situation where some
> programmatic asserts are only checked under CONFIG_DEBUG_VM and some are
> always checked.
> 
> Since the intent is the same as any VM_WARN_ON_ONCE() check, do not assert
> if CONFIG_DEBUG_VM is not set.
> 
> Implement by updating vma_assert_attached() and vma_assert_detached() to
> use VM_WARN_ON_ONCE() rather than WARN_ON_ONCE(), and gating
> vma_assert_[write_]locked() and vma_assert_can_modify() on CONFIG_DEBUG_VM.
> 
> nommu loses its CONFIG_LOCKDEP asserts if !CONFIG_DEBUG_VM in
> vma_assert_[write_]locked(), but this doesn't seem to be a problem.
> 
> In addition, there were already inconsistencies - vma_assert_write_locked()
> uses VM_WARN_ON_ONCE_VMA() and performs no actions if CONFIG_DEBUG_VM is
> not set, and vma_assert_locked() looked up vma->vm_refcnt but also only
> asserted if CONFIG_DEBUG_VM was set.
> 
> Therefore simply update these functions such that they're predicated on
> CONFIG_DEBUG_VM and update their kdoc descriptions accordingly.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

One nit, but not worth holding things up for.

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  include/linux/mmap_lock.h | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9367430ee53c..bada7a03ddf4 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -354,9 +354,14 @@ int vma_start_write_killable(struct vm_area_struct *vma)
>  /**
>   * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
>   * @vma: The VMA to assert.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.

These are stating what the code does at the very start of the function
and I'm not sure the kernel docs needs to state the debugging behaviour.

>   */
>  static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
>  {
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
>  	if (!IS_ENABLED(CONFIG_MMU)) {
>  		mmap_assert_write_locked(vma->vm_mm);
>  		return;
> @@ -369,11 +374,16 @@ static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
>   * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
>   * lock and is not detached.
>   * @vma: The VMA to assert.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_locked(const struct vm_area_struct *vma)
>  {
>  	unsigned int refcnt;
>  
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
>  	if (!IS_ENABLED(CONFIG_MMU)) {
>  		mmap_assert_locked(vma->vm_mm);
>  		return;
> @@ -480,12 +490,12 @@ static inline void vma_assert_attached(struct vm_area_struct *vma)
>  	if (!IS_ENABLED(CONFIG_MMU))
>  		return;
>  
> -	WARN_ON_ONCE(!vma_is_attached(vma));
> +	VM_WARN_ON_ONCE(!vma_is_attached(vma));
>  }
>  
>  static inline void vma_assert_detached(struct vm_area_struct *vma)
>  {
> -	WARN_ON_ONCE(vma_is_attached(vma));
> +	VM_WARN_ON_ONCE(vma_is_attached(vma));
>  }
>  
>  static inline void vma_mark_attached(struct vm_area_struct *vma)
> @@ -549,6 +559,9 @@ struct vm_area_struct *lock_next_vma(struct vma_rcu_iter *rvmi,
>  
>  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
>  {
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
>  	if (vma_is_attached(vma))
>  		vma_assert_write_locked(vma);
>  }
> 
> -- 
> 2.56.0
> 

