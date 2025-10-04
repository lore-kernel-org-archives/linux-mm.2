Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F708CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 13:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5F28E0006; Sat,  4 Oct 2025 09:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466738E0002; Sat,  4 Oct 2025 09:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3C28E0006; Sat,  4 Oct 2025 09:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5E18E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:08:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD6ABC0139
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 13:08:34 +0000 (UTC)
X-FDA: 83960460948.11.FEFB0C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC37620011
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 13:08:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759583313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kb+7ePhaxZt3mzsQ6zqvpk20jy2OaWb3ERJe5vk5NtM=;
	b=Zv+9HYNPhmABz0j4KWMU6DuOF03krh5dUSLATC7b2acZ4xC+g1Q0dfhFsMfxb791qOeTk4
	At7JdgcqOsXrJfHFAAZYaok5b8PSqNd9+pf2ABZ5h8TRMMnpV7e+OQIlU+XclXOjFwZcZ0
	4WgzYolVWxJf9qNDkRhqiAuUIMQvwCY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759583313; a=rsa-sha256;
	cv=none;
	b=0a+n/zcfNgSdciKRVFEH9HZeD13dMzvNqZAQqb5H2+3jldDnRNIFqWvCJccWIDiJS81u7/
	1fY0IUIzyTuArjgyyUHFyE5w8Nf3hvQIvxYENorg2sMgMtSXX7w56gmCj49+bJTs364gu8
	JLri7nAIhiRC4SRXqDw10Mptd5c4VN0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF89C153B;
	Sat,  4 Oct 2025 06:08:23 -0700 (PDT)
Received: from [10.163.66.97] (unknown [10.163.66.97])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 800663F66E;
	Sat,  4 Oct 2025 06:08:29 -0700 (PDT)
Message-ID: <766f5a8a-851f-4178-8931-5355472d5558@arm.com>
Date: Sat, 4 Oct 2025 18:38:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: readahead: make thp readahead conditional to
 mmap_miss logic
To: Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org
References: <20250930054815.132075-1-roman.gushchin@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250930054815.132075-1-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC37620011
X-Stat-Signature: spcmucsbwmnwya9otcuunesz9c9zk35x
X-HE-Tag: 1759583312-966959
X-HE-Meta: U2FsdGVkX1/yyyM5Mgwf8HZN2IlQgBHEKtONxZUx9xTvxkWs6u/4O4+RWLx4Vv0tOy11UvZy5Rc89tptt1lkxm0GeeYYjWXxwXewDGlqJkBYivIntAYamFckts4INiz8StRpUHIAm1swdeUm/2ZBjmFVyUgFSYOc/gL3w7+ghtRCKipA6mKUCnclSjMbErUL6dWR7DeLUyhZWm8Pz20wPav1rAfXgBWRHPzCE8tJ7swz39pknpH+BN1ED0M3Ej1XmSxAEoUVUv8ZeYZkOqhs/n/c20/8YmRVTNts3e1ludA7XqhZ5MMHIhMgm7wmvLZBlbEJJJCuktJprUcUjzTUlxYISS1+7/N+MzQeo8SXB4cjjfGU862VnbcSrnOhv5jDEB+4dHQcn1GnCTLFIWE3xXXEv4I4N3Y+sOe7kw3s9Heou6tsPgmjCBt1wLPeR0vXvY6wxHZqWAhTUkPCi8cCPGGyr7M+n1krD3fNHXpZIrOwb79aoqnXBh6O1URuwUn9PT/kGXndW4DEhY/sQhJT4bywilEtxBTpghpV9It/BX1wpDuMg5FzGHNAgV4fISXlKKSkwqXMDsV4uwuM9dWfkRlI3rw20j18d7T68VaEErPtHIf5ye9glpjjnospmMRbmJOHfDeBVN/R64wFfnYHg+oj9yj2xfvK+FjDzmRKnj3v4X4MIXrDB3WjD44+Jz7mT2yPRC8ky39Ip9sZIjI5rGQX8NRtehnl0jFk7vkzOn0QVMC6vHJ2//ZEkiKw/GvCR+Xsduo18rypZx8b8HlqMr3BXgPFVK+r8zsd0aBGuJ2VkWomg3zVqRqnwqgyVO1S+Vbq4w8G1v19GQYrvfK8y873XibmtdObhNIg5ceFUlLRFb53OZykfd8gaZBEMKgdFZ1L+kreHZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 11:18 am, Roman Gushchin wrote:
> Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
> introduced a special handling for VM_HUGEPAGE mappings: even if the
> readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
> allocated.
>
> This change causes a significant regression for containers with a
> tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
> commit, mmap_miss logic would eventually lead to the readahead
> disablement, effectively reducing the memory pressure in the
> cgroup. With this change the kernel is trying to allocate 1-2 huge
> pages for each fault, no matter if these pages are used or not
> before being evicted, increasing the memory pressure multi-fold.
>
> To fix the regression, let's make the new VM_HUGEPAGE conditional
> to the mmap_miss check, but keep independent from the ra->ra_pages.
> This way the main intention of commit 4687fdbb805a ("mm/filemap:
> Support VM_HUGEPAGE for file mappings") stays intact, but the
> regression is resolved.
>
> The logic behind this changes is simple: even if a user explicitly
> requests using huge pages to back the file mapping (using VM_HUGEPAGE
> flag), under a very strong memory pressure it's better to fall back
> to ordinary pages.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-mm@kvack.org
> ---
>   mm/filemap.c | 40 +++++++++++++++++++++-------------------
>   1 file changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a52dd38d2b4a..b67d7981fafb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3235,34 +3235,20 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>   	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
>   	struct file *fpin = NULL;
>   	vm_flags_t vm_flags = vmf->vma->vm_flags;
> +	bool force_thp_readahead = false;
>   	unsigned short mmap_miss;
>   
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   	/* Use the readahead code, even if readahead is disabled */
> -	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
> -		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> -		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
> -		ra->size = HPAGE_PMD_NR;
> -		/*
> -		 * Fetch two PMD folios, so we get the chance to actually
> -		 * readahead, unless we've been told not to.
> -		 */
> -		if (!(vm_flags & VM_RAND_READ))
> -			ra->size *= 2;
> -		ra->async_size = HPAGE_PMD_NR;
> -		ra->order = HPAGE_PMD_ORDER;
> -		page_cache_ra_order(&ractl, ra);
> -		return fpin;
> -	}
> -#endif
> -
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> +		force_thp_readahead = true;
>   	/*
>   	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
>   	 * already intended for random access.
>   	 */
>   	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
>   		return fpin;
> -	if (!ra->ra_pages)
> +	if (!ra->ra_pages && !force_thp_readahead)
>   		return fpin;
>   
>   	if (vm_flags & VM_SEQ_READ) {
> @@ -3283,6 +3269,22 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>   	if (mmap_miss > MMAP_LOTSAMISS)
>   		return fpin;
>   

You have moved the PMD-THP logic below the VM_SEQ_READ check, is that intentional?
So VMAs on which sequential read is expected will now use the common readahead algorithm,
instead of always benefitting from reduced TLB pressure through PMD mapping, if my understanding
is correct?

> +	if (force_thp_readahead) {
> +		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> +		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
> +		ra->size = HPAGE_PMD_NR;
> +		/*
> +		 * Fetch two PMD folios, so we get the chance to actually
> +		 * readahead, unless we've been told not to.
> +		 */
> +		if (!(vm_flags & VM_RAND_READ))
> +			ra->size *= 2;
> +		ra->async_size = HPAGE_PMD_NR;
> +		ra->order = HPAGE_PMD_ORDER;
> +		page_cache_ra_order(&ractl, ra);
> +		return fpin;
> +	}
> +
>   	if (vm_flags & VM_EXEC) {
>   		/*
>   		 * Allow arch to request a preferred minimum folio order for

