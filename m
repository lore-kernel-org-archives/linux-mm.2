Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E52CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001BE8E0011; Mon, 17 Nov 2025 12:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BC68E0002; Mon, 17 Nov 2025 12:09:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58AA8E0011; Mon, 17 Nov 2025 12:09:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF7098E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:09:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C94EC01ED
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:09:06 +0000 (UTC)
X-FDA: 84120734292.29.230F359
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A0F37180017
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:09:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ehKeqUsj;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763399344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrerORctnVagLrhTa/S+/pCafgTvRswDFaW4UGVbybQ=;
	b=UOGyFIOjjgMqTD7nPczq45HfGCIBeKOJGJKqQX+m36OTuIdX8UHgj8ne6SokH9trZnpzjh
	gpOIxcS2oHysMri/7e7QSGZNBunUGr0ck8d9UDQ7SWrbtQFcetYXYB6WFClxoatAITc+pV
	ozci2Qbz4nz7nHO02J54PG4wGjwN4bY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763399344; a=rsa-sha256;
	cv=none;
	b=MFb6y4z54lu7pvzu3jlq25hHWPtkQTfqiaWWyeT2Mu2ltluBdeD4TLkdZ+F/gz1x0zdckW
	dvGFm17Jbu/7nWhgpjmWNehYWZ8xsICWZIEdvKaiS2uFuNF9B9/4vwQavHPIGAUKnm9WNx
	QbGLVfPDJ0rfJYKIRcA5gtvqONn6VoA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ehKeqUsj;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0970A6023A;
	Mon, 17 Nov 2025 17:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79107C4CEF1;
	Mon, 17 Nov 2025 17:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763399343;
	bh=RuS09nJyeqNS8Db0pvG4BOuHVgtzKyDFtBIV37Zz3OY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ehKeqUsjA8DloYD0X8DNYblCUZB3qIRIlB9+2dqOC1p/8Qa9CCGGCW+1t/ltXQgDt
	 5OBn9R76l0aDrReC4cD25v5Q9WWbeBZUzO9tfInbVvA70ywWrLmfH13JplaoHoZ8gl
	 RPMjj+zX9g961agbLV/++/j8252BXeu3IahHFFW3NRFTeL5v9KTwJrz1RY587W6nmp
	 tCjFr4SeqdXZrXnFjxR5TZUQliuX9f5YcUK9I1TXHM4CTRYjIJtW3NNORwORPCZKH+
	 A2mN7i4dg+OQ9m/+/vC239WZLil7+E7R+qeZPIN/zC5tw7bBLNZcAf+7DP8X3rpEEd
	 Cl7SfHIEbl3MQ==
Message-ID: <94fcc32f-574a-4934-b7a9-1ed8bd32a97f@kernel.org>
Date: Mon, 17 Nov 2025 18:08:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] userfaultfd, shmem: use a VMA callback to handle
 UFFDIO_CONTINUE
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251117114631.2029447-1-rppt@kernel.org>
 <20251117114631.2029447-3-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251117114631.2029447-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A0F37180017
X-Stat-Signature: j48yrw8iphj95cyqtesjjj73oqu91b4r
X-Rspam-User: 
X-HE-Tag: 1763399344-90440
X-HE-Meta: U2FsdGVkX1+IvDcDPEonqyENGYe5Zho45qc5/9wtW8MUAqFG0FnvPrOIbgtL2eneIadUpbWoWQA9YCHg4k/ZNYhZVHaJhAaP7k4VfsBCYsisUwo4mgYmmxmBgu0E1eUrdupgbG/6t+FUyhUHZ/iB1GavTL/F0iJIQBvM59vDvsG0qbv/ybSNWnHh3vVBWCa0+bQySl+PCMuNkv0wO3xLE/iUKcFRguPZUpxXv1THpKH//jxxTSUrmkSt+a32BLgugtTdfcCeu9tQ3OhbfagDE/4A6EfiQCeBNTQdBJenJ1X2crCtrLxHUJOsNN+Q+36cF7ajtuMDmy0SxfOThjqF01gnJMTuj6kU92sp5rLJPPcYhzSRo/wokhcPNrTr8E/EHjmgxbRasZ5YXMntVD4EeSDkBSj7rlpTExNcWxiDXedLxWZR/UTVMcDLfXdwiKuc33YO3c3wHGa/p/ffCnQQQQcsbScBqh5tJAR5Ydkw5eof+LlTBSD+IHNVgiricaxEdhocJlRVCbOSTIKV2Lz6AW66qXSR4Yfr2ENmyFJgMzv/jWY6h7NN/4nPaTa3W8qQrFkSy5xs7E5W47/Emhr2fvdArpdzBe9i564fcbnqBeFb6p+gld0cSjMyKAkpjwvqO2/wH9/ALSEEdd9Skgyc1NKpMSpQVt4x690QViR75AZKd0g3QprCoyVK6pcl1p4TvFgGituRHvG7PbdRDlurkIy7g5hhzLFjDawK8GnUmOVwciUuR1V/8B7oFZ+4P2EK8hkkgBkzFuuxKZGFzmHIlj0qMSBlU7yAodtmNX574ktQsm1z9m677nlLzmKEU9GBXma6j6ulJDtIek4RLfm/Ziy9qidiEnnshNoFTcVjUptrDM5ZpV/a5F0pf2v/50aAuo+/XjYj+pPW7n0N3tXronciOjUVWC08yuh3R/BzLVz91sdms/L5XnZOiARxlrvO4iAMycnJRWz9VRpfLTl
 mTmQ5kLO
 3FU7lSYhzvoCsD5skjWEK3dmxp5ZrYFiH0lS6tMrrosh3R+CP7PP+aPjAYZMj3l/+v/HBaZE/vIY64sW8n8DpreWWITCLjRdYF28I/UBsoDVNLu9O6Hde+8jzK5LfVGd5J3Vys8N0xr6RNsCZP6DABHbIOj5A5mojPUOIiEVlI+r/b4i7cMw0mTZ5owaKMITz3cxWxisDW6Y1uL5pdil0jHqdt3HwtahrLC6EjYwvRyZCaErBmqlCqsOorB4Gr2boLtSiu+1Y+CEhtU3SSt4qXZYArZ+KQE17R5tmYXaRNcOAPdjHdVURM1Xog8tWIAEVdKQA9bzs90FJkiuG8gNaxPOMZpWqfCnA/bt3qBD+aUDi/AU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.11.25 12:46, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> it needs to get a folio that already exists in the pagecache backing
> that VMA.
> 
> Instead of using shmem_get_folio() for that, add a get_pagecache_folio()
> method to 'struct vm_operations_struct' that will return a folio if it
> exists in the VMA's pagecache at given pgoff.
> 
> Implement get_pagecache_folio() method for shmem and slightly refactor
> userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
> this new API.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   include/linux/mm.h |  9 +++++++
>   mm/shmem.c         | 20 ++++++++++++++++
>   mm/userfaultfd.c   | 60 ++++++++++++++++++++++++++++++----------------
>   3 files changed, 69 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32..c35c1e1ac4dd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -690,6 +690,15 @@ struct vm_operations_struct {
>   	struct page *(*find_normal_page)(struct vm_area_struct *vma,
>   					 unsigned long addr);
>   #endif /* CONFIG_FIND_NORMAL_PAGE */
> +#ifdef CONFIG_USERFAULTFD
> +	/*
> +	 * Called by userfault to resolve UFFDIO_CONTINUE request.
> +	 * Should return the folio found at pgoff in the VMA's pagecache if it
> +	 * exists or ERR_PTR otherwise.
> +	 */

What are the locking +refcount rules? Without looking at the code, I 
would assume we return with a folio reference held and the folio locked?

> +	struct folio *(*get_pagecache_folio)(struct vm_area_struct *vma,
> +					     pgoff_t pgoff);


The combination of VMA + pgoff looks weird at first. Would vma + addr or 
vma+vma_offset into vma be better?

But it also makes me wonder if the callback would ever even require the 
VMA, or actually only vma->vm_file?


Thinking out loud, I wonder if one could just call that "get_folio" or 
"get_shared_folio" (IOW, never an anon folio in a MAP_PRIVATE mapping).

> +#endif
>   };
>   
>   #ifdef CONFIG_NUMA_BALANCING
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b9081b817d28..4ac122284bff 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3260,6 +3260,20 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
>   	shmem_inode_unacct_blocks(inode, 1);
>   	return ret;
>   }
> +
> +static struct folio *shmem_get_pagecache_folio(struct vm_area_struct *vma,
> +					       pgoff_t pgoff)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +	struct folio *folio;
> +	int err;
> +
> +	err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	return folio;
> +}
>   #endif /* CONFIG_USERFAULTFD */
>   
>   #ifdef CONFIG_TMPFS
> @@ -5292,6 +5306,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
>   	.set_policy     = shmem_set_policy,
>   	.get_policy     = shmem_get_policy,
>   #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.get_pagecache_folio	= shmem_get_pagecache_folio,
> +#endif
>   };
>   
>   static const struct vm_operations_struct shmem_anon_vm_ops = {
> @@ -5301,6 +5318,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
>   	.set_policy     = shmem_set_policy,
>   	.get_policy     = shmem_get_policy,
>   #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.get_pagecache_folio	= shmem_get_pagecache_folio,
> +#endif
>   };
>   
>   int shmem_init_fs_context(struct fs_context *fc)
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 8dc964389b0d..60b3183a72c0 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -382,21 +382,17 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
>   				     unsigned long dst_addr,
>   				     uffd_flags_t flags)
>   {
> -	struct inode *inode = file_inode(dst_vma->vm_file);
>   	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
>   	struct folio *folio;
>   	struct page *page;
>   	int ret;
>   
> -	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> +	folio = dst_vma->vm_ops->get_pagecache_folio(dst_vma, pgoff);
>   	/* Our caller expects us to return -EFAULT if we failed to find folio */
> -	if (ret == -ENOENT)
> -		ret = -EFAULT;
> -	if (ret)
> -		goto out;
> -	if (!folio) {
> -		ret = -EFAULT;
> -		goto out;
> +	if (IS_ERR_OR_NULL(folio)) {
> +		if (PTR_ERR(folio) == -ENOENT || !folio)
> +			return -EFAULT;
> +		return PTR_ERR(folio);
>   	}
>   
>   	page = folio_file_page(folio, pgoff);
> @@ -411,13 +407,12 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
>   		goto out_release;
>   
>   	folio_unlock(folio);
> -	ret = 0;
> -out:
> -	return ret;
> +	return 0;
> +
>   out_release:
>   	folio_unlock(folio);
>   	folio_put(folio);
> -	goto out;
> +	return ret;
>   }
>   
>   /* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
> @@ -694,6 +689,22 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
>   	return err;
>   }
>   
> +static __always_inline bool vma_can_mfill_atomic(struct vm_area_struct *vma,
> +						 uffd_flags_t flags)
> +{
> +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
> +		if (vma->vm_ops && vma->vm_ops->get_pagecache_folio)
> +			return true;
> +		else
> +			return false;

Probably easier to read is

	return vma->vm_ops && vma->vm_ops->get_pagecache_folio;

> +	}
> +
> +	if (vma_is_anonymous(vma) || vma_is_shmem(vma))
> +		return true;
> +
> +	return false;


Could also be simplified to:

return vma_is_anonymous(vma) || vma_is_shmem(vma);


-- 
Cheers

David

