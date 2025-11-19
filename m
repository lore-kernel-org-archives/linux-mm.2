Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB02CF3182
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1AA6B0030; Wed, 19 Nov 2025 04:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E522D6B00A5; Wed, 19 Nov 2025 04:16:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41276B00A8; Wed, 19 Nov 2025 04:16:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF9EE6B0030
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:16:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63B9B1603E7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:16:28 +0000 (UTC)
X-FDA: 84126800856.03.A5FFBDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B8B1AC0008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:16:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlTNcb3M;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763543786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzpCFtBCrrzCM/5GvRHS1rCNTxwfe7bXDs9M4IdsMNU=;
	b=yxHEpZZBCoVZDgO/IHL701fhQitruhqETVm+IgScGmMxoWyxBcm/CMTLN9zBvt/4MSsa7w
	V/XqKz4GMNOKtEEpvvqnrT1ffBB5F3pulwVLneNQpCdNbAL2b6C0POEIZyJvoJ+5DhEupd
	VKQ0VeTV3uRiqkV0Mo9R0nM6kCiHEcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763543786; a=rsa-sha256;
	cv=none;
	b=Px5t5ifjFR+XNNiMwDBpFRuahQEDkhlgXL8YzeWTogbLQ0plsd9meTmSIrQRPXAmXf+W8R
	cWx/GL3cpC0TgJrDSvTXIyhMbFaB41ymw57JeYMLnrO6RcV3c4vFPLLFVHBc8PRAo/fLpS
	kC3mbVO10yCrKsxF7+6ZSMMzjcF4FHc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlTNcb3M;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1A366015E;
	Wed, 19 Nov 2025 09:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25F6C2BCB6;
	Wed, 19 Nov 2025 09:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763543785;
	bh=pVtZ+fK4btyZD14SaYan12k/0/Sh9SgT5AKYHSQTNMw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FlTNcb3MPw83x3iSu8dqCCFLrB+fCZKLBfiYE+hxgj98uFnZcSe9DxEcrzBDKIDDm
	 l3wkzpgeMFUFKVOYtzOHyLB9/xL7CRM7yxH98fJjZNlmwshO13xwdCRQp55x2+qquh
	 oVQqZMKP8QH9QroiilyrMy9gf9M6JRIsOI/kyUri7SnctuceDpLp5rkwi+9wCp8e9Y
	 BQdJZpQHyWFKT1ah1HnhIGAkT3ytbceyguPa5erSYk4TFZUTNAeRN0w763wzefvhI4
	 4qMjkvkep1aLhSQla5QjFmeCoSpBQ3r0pOf+gHLXvOtnx4H4kWigjtQ8YwR6OLMXDv
	 jWH4MV5JyfsoA==
Message-ID: <61f7c6d2-a15e-4c6a-9704-0e3db65eed3c@kernel.org>
Date: Wed, 19 Nov 2025 10:16:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] mm: set the VM_MAYBE_GUARD flag on guard region
 install
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <e9e9ce95b6ac17497de7f60fc110c7dd9e489e8d.1763460113.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <e9e9ce95b6ac17497de7f60fc110c7dd9e489e8d.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3nokga8p13b4hfu8ds8ka3eb4t6g6jai
X-Rspam-User: 
X-Rspamd-Queue-Id: B8B1AC0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763543786-716119
X-HE-Meta: U2FsdGVkX1+TNQ5JR3Gxi1U+/gal2JllsLPru8cruh0dshPcQcKYfChuxfXViDIZ2qLBscRAgPnngVO2V6IDgf61QJM2GXvzDvJew/2KKHfUFGScrbh3NfRjV8hGzcw+aAD2uEm+hkTlLi25r33tUgXTAvR2J3LzUaMgstBFinc9wn9sMBOZc7VTAd8jkE5b/ZUZtB/pf7L86RaoehDcv3BeN/WeS46o8t8DLRUly3yGCPg8tx/xtIhEoId2ccohBRI0LRZNnm4gzfFrlTL4ia2154cllSXEmFBZbAvu/xDegxZII5T5c48ZZg8mlfXFtHNWX7taeKfAswVmGuddrRj4zIv+sbVWs4dF9kI0aul63NgmSREm3a9O2nOfgUzEv/6aQ/WdTvc3/NGgESBrFn8j9Asvx3EkBbmUnarPbNdazaWZhOAbK7YEC7hJhEK2/UaG6EKP0TsRhdAZJGp2whT4ypeZMGx7868b3gHaCn6HnXTddWK1bfdpshVthxFGSh+4vky94aNQoPM6u7w3tqDs3W0RjfZ/QQqRetQB1sfANFqmUBXT8MKgmOlI0avWam0VCYQwJIcY3LvncCmiUjZE9RRHQ+6Ykc6MFiPEh1D52ulk7krqxcEfe/JrR60kRabQUNmhWQqhKGK5m5X0sH+0z6vGi0SGnPb3/pBj7dXzUS0JocbvZ+EyYYYQ6mcBVcdIbNe45MNsIpU8THZIhT/t1AcodBXssYDSDk29lLyGeAna1yMjIIh9Ly7AFIcNzzOTnSVbP4fTBmkyEWrpDHPWMGcFlVV2NMl5m3UqIGo1QsMdl10d+obhIphBNCf4xnCRhrwLhhY6GihL6LnsK2nnS9LuX7C3wVB1caWuAeYlAiJ4VFqTfqJchzBdVZmeWQan0Y8wQay7f+k4g7aLxnWmyxwfpIPnZP3PHojolUjbr972V3bsQ5mzO1adj5i03LQGyXUWJNjOAM8EPuJ
 0TJ37HIW
 Vknb8kEtOiHR4nNjt3FPRkrlKtOL0AFJY5IyZhoe9lv3Xd41D+4T5LW8C2Et/51cyx5d16ijtw6kcVonHQFJ5n47wqFxTfWW1wkcCK0U5H0F9yvEtAvdsGdy2T9FEvOwjTJtlpkYHWRn8+TmZf9eMKRajfOJkss+T1V9Dkr0/UVSWBCOy+DsczkZudQPHq92jt2ybDztEIU8Me4pm/vb25OnRkTMmkD7jOeaugwnaFdCSyu79uQhFfJUxwrjDGA4yFcUdJa4oL/Cn7feGBfiBTHnJzQ0Y9bzsuTGeOZBDspsf9PYuppF3nQDZWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   
> +/* Can we retract page tables for this file-backed VMA? */
> +static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)

It's not really the VMA that is retractable :)

Given that the function we are called this from is called 
"retract_page_tables" (and not file_backed_...) I guess I would just 
have called this

"page_tables_are_retractable"

"page_tables_support_retract"

Or sth. along those lines.

> +{
> +	/*
> +	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
> +	 * got written to. These VMAs are likely not worth removing
> +	 * page tables from, as PMD-mapping is likely to be split later.
> +	 */
> +	if (READ_ONCE(vma->anon_vma))
> +		return false;
> +
> +	/*
> +	 * When a vma is registered with uffd-wp, we cannot recycle
> +	 * the page table because there may be pte markers installed.
> +	 * Other vmas can still have the same file mapped hugely, but
> +	 * skip this one: it will always be mapped in small page size
> +	 * for uffd-wp registered ranges.
> +	 */
> +	if (userfaultfd_wp(vma))
> +		return false;
> +
> +	/*
> +	 * If the VMA contains guard regions then we can't collapse it.
> +	 *
> +	 * This is set atomically on guard marker installation under mmap/VMA
> +	 * read lock, and here we may not hold any VMA or mmap lock at all.
> +	 *
> +	 * This is therefore serialised on the PTE page table lock, which is
> +	 * obtained on guard region installation after the flag is set, so this
> +	 * check being performed under this lock excludes races.
> +	 */
> +	if (vma_flag_test_atomic(vma, VM_MAYBE_GUARD_BIT))
> +		return false;
> +
> +	return true;
> +}
> +
>   static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   {
>   	struct vm_area_struct *vma;
> @@ -1724,14 +1761,6 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   		spinlock_t *ptl;
>   		bool success = false;
>   
> -		/*
> -		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
> -		 * got written to. These VMAs are likely not worth removing
> -		 * page tables from, as PMD-mapping is likely to be split later.
> -		 */
> -		if (READ_ONCE(vma->anon_vma))
> -			continue;
> -
>   		addr = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
>   		if (addr & ~HPAGE_PMD_MASK ||
>   		    vma->vm_end < addr + HPAGE_PMD_SIZE)
> @@ -1743,14 +1772,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   
>   		if (hpage_collapse_test_exit(mm))
>   			continue;
> -		/*
> -		 * When a vma is registered with uffd-wp, we cannot recycle
> -		 * the page table because there may be pte markers installed.
> -		 * Other vmas can still have the same file mapped hugely, but
> -		 * skip this one: it will always be mapped in small page size
> -		 * for uffd-wp registered ranges.
> -		 */
> -		if (userfaultfd_wp(vma))
> +
> +		if (!file_backed_vma_is_retractable(vma))
>   			continue;
>   
>   		/* PTEs were notified when unmapped; but now for the PMD? */
> @@ -1777,15 +1800,15 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
>   
>   		/*
> -		 * Huge page lock is still held, so normally the page table
> -		 * must remain empty; and we have already skipped anon_vma
> -		 * and userfaultfd_wp() vmas.  But since the mmap_lock is not
> -		 * held, it is still possible for a racing userfaultfd_ioctl()
> -		 * to have inserted ptes or markers.  Now that we hold ptlock,
> -		 * repeating the anon_vma check protects from one category,
> -		 * and repeating the userfaultfd_wp() check from another.
> +		 * Huge page lock is still held, so normally the page table must
> +		 * remain empty; and we have already skipped anon_vma and
> +		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
> +		 * it is still possible for a racing userfaultfd_ioctl() or
> +		 * madvise() to have inserted ptes or markers.  Now that we hold
> +		 * ptlock, repeating the retractable checks protects us from
> +		 * races against the prior checks.
>   		 */
> -		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
> +		if (likely(file_backed_vma_is_retractable(vma))) {
>   			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
>   			pmdp_get_lockless_sync();
>   			success = true;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0b3280752bfb..5dbe40be7c65 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1141,15 +1141,21 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>   		return -EINVAL;
>   
>   	/*
> -	 * If we install guard markers, then the range is no longer
> -	 * empty from a page table perspective and therefore it's
> -	 * appropriate to have an anon_vma.
> -	 *
> -	 * This ensures that on fork, we copy page tables correctly.
> +	 * Set atomically under read lock. All pertinent readers will need to
> +	 * acquire an mmap/VMA write lock to read it. All remaining readers may
> +	 * or may not see the flag set, but we don't care.
> +	 */
> +	vma_flag_set_atomic(vma, VM_MAYBE_GUARD_BIT);
> +

In general LGTM.

> +	/*
> +	 * If anonymous and we are establishing page tables the VMA ought to
> +	 * have an anon_vma associated with it.

Do you know why? I know that as soon as we have anon folios in there we 
need it, but is it still required for guard regions? Patch #5 should 
handle the for case I guess.

Which other code depends on that?

-- 
Cheers

David

