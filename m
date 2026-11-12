Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F05606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 20:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=O0f92Jl/
Received: by kanga.kvack.org (Postfix)
	id 242CA6B05E6; Thu, 12 Nov 2026 15:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2826B05E7; Thu, 12 Nov 2026 15:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1886B05E8; Thu, 12 Nov 2026 15:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D17906B05E6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:59:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6780FA9BE9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:59:21 +0000 (UTC)
X-FDA: 85427682522.02.F7ADB1F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 434BB140005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:59:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="O0f92Jl/";
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794517159;
	b=VuQHtoNscBNFLO2ktsR5d80GaTTPw442v0nOdf/Z4Eb/wafToxVxoXU6CMA1xFDsZgE0tk
	+7BVoD26z7tWFMkVoRTsWq0Xf/qKhkHw26YFr+CFAviCyq3CR76SXpX9XrNc8yyQGq88kS
	DkleyJX8sMHJMagILjNyHGn387EtwdU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="O0f92Jl/";
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794517159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWxW0v3Yp3gUIU8y20wR7hKoi5jJwchqtRdIOf3GtkQ=;
	b=Zw93ZCLyEe3l9PLdHTuWvffyKzg0Z6c+ckC6S9kHXrAbhLOqghlG3dP/K11ETOd8mkX+G6
	JzkUeDVB6/7o5fBcF2n8UaYOEpZbKXfv33ExwOagVpnCDiTlWJFykFXNfKTyOgNmM3qkO9
	MO8Ll9OI2RKI8d++NGoQdJBWyHCTQKY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DWxW0v3Yp3gUIU8y20wR7hKoi5jJwchqtRdIOf3GtkQ=; b=O0f92Jl/Q7JNZC57lF2m123DO3
	ZdljTMVUMMcWHgd354KPoiCaWYtR04IXtmDeLHs6jL3Hdw3NkGid7JuqrfD86VbShMe5qKFqG93lM
	xPF0YfPpe6x7snQwKe93O4nUpuJQDwf4pXzje+EttCMdg12x3aOO8xmD5pspmuKCclG34iCVYOwQ+
	0v3xQyOPAZWqClKkdiqhJYvDJrZmPhbvDlbOH9pq1mAHshLNcKkV+ue/9dzolAZ3QZ1mlsXmhgQo9
	lc8z1ev5qYOT8qaSHOzu4YTatxSk1r8nfbEkVXuvy3sw9HSfRdDhFTHgzZAKIn4B1lYTKIlUsMdt1
	ywLEKeNA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRbt7-0000000B2ea-2awE;
	Thu, 12 Nov 2026 20:59:17 +0000
Date: Thu, 12 Nov 2026 15:59:10 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
Message-ID: <63skl724i2jss7itcq63fbojykh462s3voi6to52ze6v3unp35@kgakyccedf64>
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
X-Stat-Signature: bg4smpminww9fkht81d81mbbcfretz97
X-Rspamd-Queue-Id: 434BB140005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794517159-997883
X-HE-Meta: U2FsdGVkX18xOBCfLl5eAkA02k7R0YEDLZNnXoj9N1UgWWHnd4VfwTO4E47xySFpW4e48/5/1p77q6OKr1jckZbqGR0xr9xbEmrWvy0nMTrDxTEnX2dNtzvrLuNaGBpxH4acN0iZpimaWlF6xqj5GfSN8jIYn/5iI4hQtpPc4R01np5H0nBwmUrl3QvTxv0/dZXFddAtd3rrYfa8WILd+526gXfzMzEJVdyHqOeekzcN/xgAMh0HJ5JaWvcBOMj42aCNmCRCn/qK3NHxJ9aIaLFhzd0OsJLV3OS4xe4SoTsLvNUoa6X5CGcGlRe7Xyzitzso0kM45binfyPvknrDHpngtCPZGHu+P+zV0UVF6HkLIZVMwaB6KWmHPh2kDLuJiQD4EDTSpR9fwBPA+D5LrGAbt++wHvVH4RTrPvF8r2bParMzQRHs9HBYEpaWAoNuj04L/isv6yoqDg/URiesGJ0Fd5/LoOtZZFLVc3+1g0UHv6bpuEcG7kGm8RsLQGEaiYwSg1zBgEp9Ci2Tr4fMP1/JD1YbZshb3kTugUb4bp0OQuGvLy33tKHIXqhNWsEjm5eDHY0/vT6XH/QjSxvEm/xCPI02awGFlqsjKzbbEtBdQAb9mR1F3x9MQoEomulBE/utmpWEF9CKCXmh2U6InF8Ni8ro+HEkYFB9zhquv5zpvdCz885Nc06iioZaN/IcEK4OS4WrcujaGLNNf7w2h2MHkBrAJWLtluOgkqan/ETRtW1+Df9PobxPRPnNAW7ts03O3uUZc2ywhdT6xQZnHe6BM7s9bsU576hNWteHrfrY1eHQ/qZAp++Yw9AXW4IpwtAN/izTjKOQIkkWBWX49mx6/23nKo6y7UhJ07715uZhbxiPsIewghV/3mOwvQG/QzRxFp/mHSHQOav7mtrN/kuV8+Cs0dcGIXC8Q5X7Lbu9FuSrHbBPxkopbpvbj4jR2t43m7Gx/XHRJJ+Lzdl
 jxtPvKNT
 y5TAq9L0oHFiGnXN3aM/z06sr6yVP+aKLOEMz5wv2q1bB1A32zJmE/TJqEHFY03wWSERLwLM/TMKTXzFoH9KMZLaWJqjxrJfmrQlr+KBCn4wBCe/oSZ5fsXi+RmwYQp0rXJTf50GlfLouz8T6QAyKKdiM4q0CUqr1KfvVp/Gss6Gs4kEn3+NQgHhDnPFWnRBid4yWfZgCbedngYhH2ek7ftFcKdahBJoQQGNx7pb9Kx3T0woo/uYMhwYixFKRZeeHyK+PdLXtaxA7cvAAOhKHq0fVwzmP5j3/G24G/tBnC2MSzoAnYoMPoKuiwjORUu68haUGBal5fRn48aGXJqVyhaJp+lhrK41Lnv8b4xR0ZQ5jqd4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/12 05:38PM, Lorenzo Stoakes (ARM) wrote:
> In order to establish guard regions, guard markers are installed in the
> page tables of a mapped VMA.
> 
> However, problems arise when one tries to combine this with registering a
> VMA for userfaultfd, as such operations may themselves need to install page
> table markers such as uffd-wp.
> 
> When this installation is attempted the guard marker prevents these markers
> being applied, which can lead to unexpected results (especially if the
> guard regions are later removed.)
> 
> This is especially problematic because guard region installation causes the
> regions to be zapped first, meaning that the removal of userfaultfd-tracked
> ranges will not be logged in this case.
> 
> Therefore, disallow this.
> 
> This makes sense as conceptually, guard regions mark a part of a VMA as
> effectively unmapped at the page table level, and removing the markers is
> like mapping the VMA again, over which operation uffd markers would in any
> case be lost.
> 
> Only check for this on installation, as a VMA can be registered for
> userfaultfd after guard regions are established.
> 
> In this case, the guard regions cannot have new markers installed, and no
> faults can occur in the guard regions, until they are removed, at which
> point everything should function normally.
> 
> A survey of open source users indicates nobody is relying on installing
> guard regions in uffd-armed VMAs. Software including glibc, android,
> tcmalloc and CRIU were checked.
> 
> Fix the selftest to reflect the change.
> 
> Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
> Reported-by: Tal Zussman <tz2294@columbia.edu>
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  mm/madvise.c                               |  4 ++++
>  tools/testing/selftests/mm/guard-regions.c | 12 ++++++++----
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014..268731e90f12 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1156,6 +1156,10 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>  	if (!is_valid_guard_vma(vma, /* allow_locked = */false))
>  		return -EINVAL;
>  
> +	/* Guard markers are incompatible with UFFD markers. */
> +	if (userfaultfd_armed(vma))
> +		return -EINVAL;
> +
>  	/*
>  	 * Set atomically under read lock. All pertinent readers will need to
>  	 * acquire an mmap/VMA write lock to read it. All remaining readers may
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 02f69244f9a4..97da54dcf3a4 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -1476,7 +1476,7 @@ TEST_F(guard_regions, cold_pageout)
>  	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
>  }
>  
> -/* Ensure that guard pages do not break userfaultd. */
> +/* Ensure that guard regions cannot be installed in uffd-armed VMAs. */
>  TEST_F(guard_regions, uffd)
>  {
>  	const unsigned long page_size = self->page_size;
> @@ -1526,10 +1526,15 @@ TEST_F(guard_regions, uffd)
>  	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
>  	ASSERT_EQ(ioctl(uffd, UFFDIO_REGISTER, &reg), 0);
>  
> -	/* Guard the range. This should not trigger the uffd. */
> +	/* Now try to guard, should fail with EINVAL. */
> +	ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), -1);
> +	ASSERT_EQ(errno, EINVAL);
> +
> +	/* Once unregistered, we should be able to guard the range. */
> +	ASSERT_EQ(ioctl(uffd, UFFDIO_UNREGISTER, &range), 0);
>  	ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), 0);
>  
> -	/* The guarding should behave as usual with no uffd intervention. */
> +	/* The guarding should behave as usual. */
>  	for (i = 0; i < 10; i++) {
>  		char *curr = &ptr[i * page_size];
>  
> @@ -1537,7 +1542,6 @@ TEST_F(guard_regions, uffd)
>  	}
>  
>  	/* Cleanup. */
> -	ASSERT_EQ(ioctl(uffd, UFFDIO_UNREGISTER, &range), 0);
>  	close(uffd);
>  	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
>  }
> 
> ---
> base-commit: 4318887a3efa4c53d6f083ccfd7105b809a3ac65
> change-id: 20261112-disallow-uffd-guard-install-a5294129ad7b
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

