Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4554EFED3C3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA566B009F; Fri, 24 Apr 2026 08:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2436B00A0; Fri, 24 Apr 2026 08:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D89A6B00A2; Fri, 24 Apr 2026 08:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8766B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:48:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E93440149
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:48:03 +0000 (UTC)
X-FDA: 84693426846.11.0616AC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 339BD20005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:48:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+MBUo4Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034881; a=rsa-sha256;
	cv=none;
	b=Vs/GF/xGeZBl7de1EPeb6BrhXLXWHdAEJr3SusFptKXoS+P7Fwu4+fcdb9FcSZnY074PzV
	j6oklYTPafvnIGgPhaB2Tk0eW8igb8s9qwoOB29z2RE/wAzOEG9u5LJ3G22X1YX5Xq0KGd
	Y6RItgbSUOrJW7JL5mIRQcdFeSjsEqU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+MBUo4Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1DrDpo3HgoPPFrtNqNQ3FUd48K/RVzaBiJILRM0FwU=;
	b=BuVL+9pngjiiJ2ETk6oH3EJQJwnkt2FEL4TCGUlVOI2dtNxkLQZljuvF+uCaSlhvsHp3DL
	ENLNUYOSdn1lkZi0ue4eK8N41p5Mgw31t40CIe2L/ZhghX2wjRh7bLPvTgBTEuqkA3xTuC
	MV55zWg87m8yIvB0S3P6C09bJmS7co4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25F4140A93;
	Fri, 24 Apr 2026 12:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7209C19425;
	Fri, 24 Apr 2026 12:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777034880;
	bh=1Cf3B57eA/Xv1J45OL1HqPDwusKTeEJ3wvuRI4kM4Qg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c+MBUo4YmmqJhSbQ4lFHV+9KptHXnOQ2WBGmJw6ZiQE7tBQ3jQlZAyfTO3iyN66GU
	 aIMlLh9/QbG3nB+FjT1XcH+cyLPmstj0Myw9tOuwh2XOO5vbrKnmfYjNhWn1PWy65j
	 1bm0FUiVTRTqtxHhyQ4aOxumH8Q5jW8MtCGM5/pO4DkocHAwFB9tLBoiwUR7T8BLia
	 f3iu49Yia6FdGkcK2ti2TGHzfW1T1CTt/JK+iqEReocUdjphyJuJcmQx/iFZ3Sgw+N
	 QTcUkVONSW+tUxsG0aHVaDMGa9lJH8Z/V6YRxgetHHhBeWoyjKFT8vu0FhB29mWECS
	 OIxyjdHp7g80g==
Message-ID: <312bc872-be82-457b-b0dc-fae7f4e15bbf@kernel.org>
Date: Fri, 24 Apr 2026 14:47:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_enabled()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-5-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424024915.28758-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 339BD20005
X-Rspamd-Server: rspam12
X-Stat-Signature: mmbeno7ig4xujoqy6jjs6uc3ithxu4r4
X-Rspam-User: 
X-HE-Tag: 1777034880-407680
X-HE-Meta: U2FsdGVkX1+M7fBIWQI8LhM0Oc0pohWy3lzkjEmDJpbZLiiaYHa+ri0Q+dmtteIkZFkd/UU4fg8WxYsOC3CFRPXHrGh/GlMFEfjQM11Vw2laJ/958EdkeSFqR4SdAmPM2ig4Zd2Uege1mXiekdZ3smiZggnVbWUY2UXaM3n1d1oAKVRssGHrCeYXUeuqSbGYqAXk4aK0S6NQDQ/jZjLk+ZSLkISSc9d8XnBBfclf0jKUV5YNxihCX/6AQnZ9PfyFcEeRgPfaaU91dyrIo2dhr/ePK0t1GFxad11rr0e2I69owMLXzm/VYS6zaQQ/BXPJ+R2H+gU6GC0U69eujMcnIGqyUFVaxgUXbd/MEZN3plngSYZPFmCg8CFum4TffMx/wuVwoZsAFcQzLH3PpP71nFpJXq7E9azzgcbSZv0Mv5SYZYemDcqJLYIGJWmRPhmb4nO5bEuw/bvEkqUHvoBZHu0CwUkE+FtgovuYmO46gN+50vrmqCvXir7neqNd92DUCPj5QsXn3rX1lsLAWKSWFF5isLtg4JQM3eVSCfRo2YCFQNACkuh29TnjYtT3JqoRsA3ojgZCV7WLQBlmfq+E6PPFZfj12X+u2ywv8S5DzgoLbgF2XwNM7tQC7kxVcVbU773yt7xCb+dSryGPXikL2xgtLKH6EemvEsVhK66uOBbfCYydujTENJXGJHKFnqUY6rWe8VLNWrYzl4+5NvFWkSH8LNN8c38JUp1CNp4cL6jVSeNBrfFaVaPR3O0ZZObUQVOtveaeAFo08kVltYVTJ5x2KQI7nr8HtK0Uw87XcxfPV2yJGVuUV2f+QsT42IoR1uZVgUowKTzV+qFspoZVnkyoKQSObFzcgfJo/qvcXsfV2aGSDOsTJlapy4uv5LpUaIfyawY0QABex1efk4x6FlSPAKQEoQYfW8ACa08fGASh5eL/uxZYqG518wl7c/gVRfU6rLvcYjp1B1WLtZO
 EWQhZKW3
 +oWVPHStKeMrFBeJ3EKvpd1IcXJ6e2CmFjMwBm9siIv7eQS/jgsVpWYmUJ9PKbCQ0YsZr9TokIFxJ/6BFXpEZQ2sNgwka4i8ocusYi7S0L959yjrvo7itsDhldm30yNY5DLy3aElfNTtP0jb7K8jlFlYVDzmCzo83tm7AcV8VPAEYvqjZnO5MjAX40tqlPDb7ufJ8e/jMUnNTTmlgCYKBYRCw4u0p6Nx9vFWCjrd8DXDCZ2G1CsSbIcqFyI9NWf4A6jWdKkgbss6ZpfB33RmNXmMIrQOye1IKf2yeICdVkm/RfgM6abqN5rGvWzEdtjwyot4gQg/p+VnbreY7JHBzuIZlK8TXr0g2u0SobrsyocpdGb5y8MOmW6ixURCDy6nQ2OjO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:49, Zi Yan wrote:
> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
> hugepages are enabled by the global transparent hugepage control.
> khugepaged can still be enabled by per-size control for anon and shmem when
> the global control is off.
> 
> Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
> IS_ENABLED(SHMEM) in hugepage_enabled().
> 
> Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/shmem_fs.h |  2 +-
>  mm/khugepaged.c          | 26 ++++++++++++++++----------
>  2 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 93a0ba872ebe..acb8dd961b45 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
>  int shmem_unuse(unsigned int type);
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>  unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  				struct vm_area_struct *vma, pgoff_t index,
>  				loff_t write_end, bool shmem_huge_force);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 726f8ace01af..cdd4b37e4a68 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>  
> +static inline bool anon_hpage_enabled(void)
> +{
> +	if (READ_ONCE(huge_anon_orders_always))
> +		return true;
> +	if (READ_ONCE(huge_anon_orders_madvise))
> +		return true;
> +	if (READ_ONCE(huge_anon_orders_inherit) &&
> +	    hugepage_global_enabled())
> +		return true;
> +	return false;
> +}

Ah, that is based on Nicos work, right?

> +
>  static bool hugepage_enabled(void)
>  {
>  	/*
>  	 * We cover the anon, shmem and the file-backed case here; file-backed
> -	 * hugepages, when configured in, are determined by the global control.
> +	 * hugepages are determined by the global control.
>  	 * Anon hugepages are determined by its per-size mTHP control.
>  	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>  	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>  	 */
> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    hugepage_global_enabled())
> -		return true;
> -	if (READ_ONCE(huge_anon_orders_always))
> +	if (hugepage_global_enabled())
>  		return true;
> -	if (READ_ONCE(huge_anon_orders_madvise))
> -		return true;
> -	if (READ_ONCE(huge_anon_orders_inherit) &&
> -	    hugepage_global_enabled())
> +	if (anon_hpage_enabled())
>  		return true;
> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
> +	if (shmem_hpage_pmd_enabled())
>  		return true;
>  	return false;
>  }

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

