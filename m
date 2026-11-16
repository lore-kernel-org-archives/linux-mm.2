Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84252606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=JxnmLjSq
Received: by kanga.kvack.org (Postfix)
	id 8AFC46B05B4; Mon, 16 Nov 2026 12:26:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8870F6B05B5; Mon, 16 Nov 2026 12:26:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776906B05B6; Mon, 16 Nov 2026 12:26:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 564AA6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:26:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D43E2A5ED2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:26:10 +0000 (UTC)
X-FDA: 85441660500.25.1B6A947
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 80FA5160003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:26:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JxnmLjSq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794849968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzxgjF868Q8FAbCCoDm+JvCE/jhxHH7vVIq4SATyN8s=;
	b=XgAiiZ6DUdjXOtsTtrQXp3oVWX2MPAb/Av0rkj8ELwQfb5ddHHdx0OlnNc5tJJor+p7vpp
	hkcBtKfxrMKU5xM8whFLEeAH+M8Xyw5iGzaEmsLG+4k/BiTHuQIa27YCUyumnNGf3Rf9bN
	CGrb7+H1Eq1/m3/4auGtDbgPzqadoRE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JxnmLjSq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794849968;
	b=72EMEONnGS+7v6sJH5gcu8HGVUaeNJMSUu1dkVIEdc4hX+p5GXyScIofjF1G1vmOlEZ2gU
	X9Q+u1xWStZ91MCsMNqAOGJtxnHR86IrC8KUL3//uEFzW8K8Uot4PZiLDvyZ493XkOVrqE
	y4hBD1RHn9GCGoLxnXgwT22qM5/HVmQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rzxgjF868Q8FAbCCoDm+JvCE/jhxHH7vVIq4SATyN8s=; b=JxnmLjSqavqJ6CKwoKaJlMeyNp
	D6BysKfZB+wzztxq+k73ocwtwInNef3O66o5U/ZZYYhzD8T5gcQs9/P0L68dpAI1+payU/WSVrLYV
	r7RjEULHlK0XjY1WM72Yf4Z/LOI8oWH7hTXeei4gwegj/HejhK+eDCPG0h7sGm62m7KVgLN7wc/EJ
	dNEEZ/JBANht5iXOsLeiMgRjuZbqFd4Trimf/0F8QHfT0kJQPVYQI4oVh4C8+XArRUcq5d/BVFygO
	oNbSRjbjSFYQp3Z6CIGcOAj3VoQtz35oVFCauvlCP6FBP0yisEgsUfBT+9YCbpx8eQ4t4uHBVMGPL
	hDLzO5uw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xT0Sy-00000003P62-2xr9;
	Mon, 16 Nov 2026 17:26:04 +0000
Date: Mon, 16 Nov 2026 12:26:01 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
Message-ID: <ofd747zeh26u3rba42fsdryoe2mwdhi6r4cjvrmjn25tps4ar4@ubcwdhamdyui>
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 80FA5160003
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rm7ab7hnuftrqsbfxhi7gt8w8e3zckmi
X-HE-Tag: 1794849967-26357
X-HE-Meta: U2FsdGVkX1+g9/bFeywo/HYV6v0e3eEB8FtDPtcLnKQ4oWb2b8wFBqzEdMMlSaPhxgemX9imSkYNQUlrXv8UqknG99SG2JU/1ygA0wxka7uql1ERtKnuI1OHAfrSUjZJ8036rJXu3GYTDhVG6+kMRzhSJBwaogkWfADFfHpnDneX5hNCWtrxaERLyQ6IyZSDzbR8Bovvfkl4DJUsbKjvQ4BTDI4/0JVWHFBuZGZukzP+KjjSPhy4a9fum4/G8Qk9PI7N+Vt6yCBvjuy2mOty3U6jNvyf6/UXkUwSghVVEj5dqVqtIPVfZ8gHCFvC1/ZZsYeXLdxVw6A+Vq9xx2ybRVqBGqiGynT2sWQDL0XrgqCJhwBEORxPrHRlwu3jRYCxXWGjhIf3hQ9eEMM1L3BanCVAQXjJTiCa2rcl2xxXwh9/OYeVLzJOOaHoIQ1wmhfkclawBpLxpAuyO15yztA2lymjLgrPIb2sbrG+CiVNuecEq+WTRxgRNyA71Zu7Tbc6NRyrd9YbE6Qpd/iMTbZwUtvaEKwHB9gr7hO2JKNftPlbnEtLX5F5oHV8jjODwnEddJu4ZIq6zQqKQ0tCrpOlKhE4xNqlMX3J9+/M66gKYpzvTx2rFwG6nu43BVmHBB7CTjjlZoDKHifdC6mHNg8ys0PiUewE959bQBMSNogo915MoeLQ5rsDKyjTpsqtkLiilKlVqI2JvFRZf2xA97VNQTbST31JAFu1YGvOe/8EMM0ffgy7zoBYExhl1G+zHbl3LpCZm2JfgdCxIoV7foBBU3t2BopPkshV83Q4qrTToZ0o79nK7x2I5/W467/T4vUzOP1vVd2A6s7x5VT1qCvkN7NAvFkSgUiOstRRuENOuj2jLfYwpXFQOD1fWbKvpkulIwFDQrunp0F5nkGLLPOb6IuhW6VRB2Ye6lmfL9bZVFaqiO8MovVkEABifbi4MNJ5X0x2QQIroZsplYxO4Rm
 XLpHRLcM
 XPHOGxML65gVjdy7RdBtpGyyEWm3KB2+0hAz+9zRKv+LwBTrxDnwOppysPvzt3FPdvf9U6VD3XVWiRxXPaC/hyvVzuMU3Y/Ct3cJJQDvNISIzfN/Dz3rVKLcoG2E0yHVhdJOq1xEx0tHvmy4JG9XEnmDgoYJCyKCml9dZdIyVcy47MMGmBckN/BDpjPM2brO5RoXD+1TcqGFfFdhnXM5pkCIu/LaRhsrRyQEVu3De8lkzNwPD5WFOMpkLFhoOKROeC028H3ZTnlnStcUgcTVvVcnfZ8rkSdBNsz7BGyK+TwA7k6vCFYoLQbAuarrS+IyIh+fcqxBxYamRk2n5Pkw36Jr1LSA2UMI/nvZZXIxMrdg9Aek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/13 09:04PM, Lorenzo Stoakes (ARM) wrote:
> In order to establish guard regions, guard markers are installed in the
> page tables of a mapped VMA.
> 
> However, problems arise when one tries to combine this with registering a
> VMA for userfaultfd, as such operations may themselves need to install page
> table markers such as uffd-wp.
> 
> When the installation is attempted the guard marker prevents these markers
> being applied, which can lead to unexpected results (especially if the
> guard regions are later removed.)
> 
> This is especially problematic because guard region installation causes the
> regions to be zapped first, meaning that the removal of userfaultfd-tracked
> ranges will not be logged in this case.
> 
> Additionally, the uffd-wp page table marker will be propagated regardless
> for file-backed mappings as the zap being performed does not clear these
> markers.
> 
> This is problematic, as it can cause repeated failure to install guard
> markers resulting in an infinite loop.
> 
> Therefore, update guard region installation to invoke the zap with the
> ZAP_FLAG_DROP_MARKER flag applied.
> 
> Both before and after this change, uffd remove events will not trigger on
> guard region installation, nor will write protect state be propagated after
> guard region removal.
> 
> This makes sense as conceptually, guard regions mark a part of a VMA as
> effectively unmapped at the page table level, and removing the markers is
> like mapping the VMA again, over which operation uffd markers would in any
> case be lost.
> 
> A survey of open source users indicates nobody is relying on installing
> guard regions in uffd-armed VMAs. Software including glibc, android,
> tcmalloc and CRIU were checked.
> 
> This change means that any already established guard regions are removed on
> zap. These will be overwritten with the newly installed guard markers on
> success.
> 
> However, if this fails for some reason (fatal signal likely the only
> reasonable cause), guard regions may remain removed, and concurrent faults
> may succeed in the interim in the range.
> 
> Since the installation failing guarantees nothing about the range being
> installed into, and since success overwrites with guard markers, this isn't
> an issue.
> 
> Since MADV_DONTNEED does something similar, abstract the zapping to
> zap_range() and call it from both places.
> 
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> Reported-by: Tal Zussman <tz2294@columbia.edu>
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
> v2:
> * Updated to just zap everything as per David + Tal.
> 
> v1:
> https://lore.kernel.org/r/20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org
> ---
>  mm/madvise.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014..4f7728583207 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>  	return 0;
>  }
>  
> +static void zap_range(struct madvise_behavior *madv_behavior,
> +		      zap_flags_t flags)
> +{
> +	const struct madvise_behavior_range *range = &madv_behavior->range;
> +	struct zap_details details = {
> +		.reclaim_pt = true,
> +		.zap_flags = flags,
> +	};
> +
> +	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> +			      range->start, range->end - range->start, &details);
> +}
> +
>  /*
>   * Application no longer needs these pages.  If the pages are dirty,
>   * it's OK to just throw them away.  The app will be more careful about
> @@ -872,13 +885,7 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>  static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
>  
>  {
> -	struct madvise_behavior_range *range = &madv_behavior->range;
> -	struct zap_details details = {
> -		.reclaim_pt = true,
> -	};
> -
> -	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> -			      range->start, range->end - range->start, &details);
> +	zap_range(madv_behavior, 0);
>  	return 0;
>  }
>  
> @@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>  
>  		/*
>  		 * OK some of the range have non-guard pages mapped, zap
> -		 * them. This leaves existing guard pages in place.
> +		 * them. This also drops any PTE markers in the range,
> +		 * including existing guard markers, which we reinstall on
> +		 * the next attempt.
>  		 */
> -		zap_vma_range(vma, range->start, range->end - range->start);
> +		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
>  	}
>  
>  	/*
> @@ -1845,6 +1854,7 @@ static bool madvise_batch_tlb_flush(int behavior)
>  	case MADV_DONTNEED:
>  	case MADV_DONTNEED_LOCKED:
>  	case MADV_FREE:
> +	case MADV_GUARD_INSTALL:
>  		return true;
>  	default:
>  		return false;
> 
> ---
> base-commit: 4318887a3efa4c53d6f083ccfd7105b809a3ac65
> change-id: 20261112-disallow-uffd-guard-install-a5294129ad7b
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

