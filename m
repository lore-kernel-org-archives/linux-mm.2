Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297F5C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308B56B0093; Mon, 14 Sep 2026 13:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2996F6B0095; Mon, 14 Sep 2026 13:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DB16B00A6; Mon, 14 Sep 2026 13:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E27E26B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:29:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AAA31401F9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:29:30 +0000 (UTC)
X-FDA: 85213054500.10.1C946E1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E40E140002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:29:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K4bqCdr8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUcgivQGJN+Vsw/hHC21NgkEl31HzcmiVji1nib8ZWE=;
	b=bsfK3X22BZXnAJLjIYF1DpjoHWqanEyfQ2IcQ+bF4poyepFoVXRFj6VtTqBxOXmvvoukpW
	0cPBumG0nEbHedVfVWz+wf32YqPnmQgkecuKfDvbG/agFy84Ef2ZM346kx0O7sx4dUOqQ9
	Lm2kyX/hwzdi6l7PrmEpSwXJrHpoqhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406968;
	b=5dyfbIf9OXlyqtUV6Ct5doDSQj3OCW4Xr561ZHWomv4lLK0inphbSXD3Dx6tIQbjP2c3L2
	H/pl1S+PyblkBk2wpWCLkLGWJ0NGqWWciN03TzihuBcjfhbOVQo58U+t+4vfzjCQOzAfHB
	8FjoDB3DEPyxxcW1v7b2r3MeEQaYrHc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K4bqCdr8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0325E1CE0;
	Mon, 14 Sep 2026 10:29:24 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E3673F882;
	Mon, 14 Sep 2026 10:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789406967; bh=nz4UZHfetPz1HaMRoljOfiKUFFTRj4qW0/9YDY5Ref8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K4bqCdr8yZxGdIYRtjY3hWdiY8ZQASCFId/YLeO/rspBu44f1j1uGha6ApNh6fxOi
	 NhxQ540d+nS9BVuKjGAxOVaAh9YBMTTcE7780q2GBd+C2CwxiayA/8rUgnrssfzoYg
	 Tp5mTdwhsVGBGNhaLw1KAkSW/Da1Ozu5e4RSwo40=
Date: Mon, 14 Sep 2026 18:29:22 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 10/17] mm/huge_memory: move the racy refcount check
 into unmap_folio()
Message-ID: <aqgu8nnDzBPtXXwe@e129823.arm.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-10-39878b37dfb0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-swap-thp-cleanup-v5-10-39878b37dfb0@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E40E140002
X-Stat-Signature: ub4qrk59duzh5qmcihnmu8kycur9rpi4
X-HE-Tag: 1789406968-70806
X-HE-Meta: U2FsdGVkX1+qzJ2tcNwOd5sOOexlSHhmdmOlICiLoqmoYDDZnLlE17uP8nAlMqt9HO9pltMcapAgg1n913E9k1MC/b/GwUP6c+cjPZ8exXTo9Nzk71Do9lC1rr37bobfhLLr8/c51cfDknKqPUUeipsC4IAgDABN8SMm5LFMppgP5LFZRKRijKZuJWTfSzgt07Jxrw7X2oeKjclhMBodtQX6bNC/lbTI3YpT+k1xFsDpDhx6YHV2tRYawznfsrFVzgcbQ4thToNGZ2khpPGp/D1IWG8OCj4moJA4YESpbjM7P6GLc990wZ0sV1QK+v1kqb2SXwIUystRNtPtFLdSJCOT2gJ9qCIooYh56kXNzT8XbZ4nx1NIB0Fq4qSVgjN8TTnxG10EABh5GLkMV2sU/QeTmQZuP5ZmPXDZnRsahC5+Qrv30KMsGzvQ/UyNWE1G04heVz/jPcvwimSn4vGRlnU/PJ3wVqH5kUDYtLtwJfI5RHFjeMhUIsOH/YNyM2+NHwuig0mLllZUCpYMLZjoEpTexSe+RS0oR6SQlY02conz15NBZG7t7MzFuL88UJc14egDMKekiTjIV3NCe7s8+sz1SWAeqZWnc/U10kzartmtVebej8FaKn5PsHQbZi/eR9VXudHpK6XofN48VEnz4bjBi9BjDhuL6HhRjjdbwnK1GpaQnwz0IjA9d2rIfBuFXGPgA+GwNTa7mrjpA7oyU9swK5ZQ7YflZ4huInRAbYSjuNjEKV5G/fldpYB/x6n6bGN6UW85CS4eYNmel03A2xNxCwQh1R3+dfFUMLGRpXsdNN0akx9/FtpDKi0y+lPwkC3RSYiTNyQ4mGItcligWnNI3t3E300oPz1ExJPwlrssIE9KFbLuFImfqjXGEy8bUPqq16QPQEKlTchuhchGcZYjm14IU4NFvST8mPYZYNZAr0lsO4tfJI8iCaU97ekxTu5Xrr+8hnyLqhBa2rm
 d6MO/Zjz
 Bn2Pv5TZux30Jh7IUEyMKfH40Z0XxIMi312hQlO6Eys0QPPjmWZpFRBRqmLKsiBuyjlN+r1TO9vDPMmUk5pL7MxcOX7ryJ5XrI/PcYkXCnsep10zf5UMU/D94PKHoGXMGdhV0Tdrb2YoYhJ2V5HiUWa173jIkIjsMBRRcQ+kwBTe3CJqQ5UwKmy9bKmKV30wOcK5lGk+zHV1HoRu8baQzwqVqWlXUvoivg/gYE9OJgU+Vj0K//Hh7LCm9rrjrbIhsuRb2kB5GjgxsBywu57/tQYm+VHwxaK5yRlspdaFA0c78L4l9IVVymntsAjVmqWLyXWjUuuSjl0CSnj+M2Z8vX2dU2DL+s4AZ4j/MOz7ocBU7x3AZFCzkLhHb1l/cxMVCJio2nvE9/49IbydZmavWgjQlrD350TQUK5P/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

On Tue, Sep 15, 2026 at 01:14:51AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The check only exists to avoid the expensive PMD-splitting unmap of a
> folio that cannot be split anyway.  Move it from __folio_split() into
> unmap_folio(), right before the PMD split, so both the anon and file
> split helpers get the early check without repeating it.
> 
> unmap_folio() now returns -EAGAIN if the check fails and the split
> helpers propagate the error.  folio_split_unmapped() drops its own
> copy of the check: it works on already unmapped folios and the
> definitive folio_ref_freeze() in __folio_freeze_split_anon() still
> catches unexpected references.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 77bf68c9b9af..859aefda7356 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3539,13 +3539,17 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
>  		split_huge_pmd_if_needed(next, end);
>  }
>  
> -static void unmap_folio(struct folio *folio)
> +static int unmap_folio(struct folio *folio)
>  {
>  	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
>  		TTU_BATCH_FLUSH;
>  
>  	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
>  
> +	/* Racy check if we can split the page, before we split PMDs */
> +	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
> +		return -EAGAIN;
> +
>  	if (folio_test_pmd_mappable(folio))
>  		ttu_flags |= TTU_SPLIT_HUGE_PMD;
>  
> @@ -3560,6 +3564,8 @@ static void unmap_folio(struct folio *folio)
>  		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
>  
>  	try_to_unmap_flush();
> +
> +	return 0;
>  }
>  
>  static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
> @@ -4030,7 +4036,9 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  
>  	if (folio_mapped(folio)) {
>  		need_remap = true;
> -		unmap_folio(folio);
> +		ret = unmap_folio(folio);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	local_irq_disable();
> @@ -4124,7 +4132,9 @@ static int __folio_freeze_split_file(struct folio *folio,
>  	if (shmem_mapping(mapping))
>  		end = shmem_fallocend(mapping->host, end);
>  
> -	unmap_folio(folio);
> +	ret = unmap_folio(folio);
> +	if (ret)
> +		return ret;
>  
>  	xas_lock_irq(xas);
>  
> @@ -4332,15 +4342,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		i_mmap_lock_read(mapping);
>  	}
>  
> -	/*
> -	 * Racy check if we can split the page, before unmap_folio() will
> -	 * split PMDs
> -	 */
> -	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
> -		ret = -EAGAIN;
> -		goto out_unlock;
> -	}
> -
>  	if (is_anon)
>  		ret = __folio_freeze_split_anon(folio, new_order, split_at,
>  						true, list, split_type);
> @@ -4379,7 +4380,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		free_folio_and_swap_cache(new_folio);
>  	}
>  
> -out_unlock:
>  	if (anon_vma) {
>  		anon_vma_unlock_write(anon_vma);
>  		put_anon_vma(anon_vma);
> @@ -4427,9 +4427,6 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
>  
> -	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
> -		return -EAGAIN;
> -
>  	return __folio_freeze_split_anon(folio, new_order, &folio->page,
>  					 false, NULL, SPLIT_TYPE_UNIFORM);
>  }
> 
> -- 
> 2.55.0
> 
> 

-- 
Sincerely,
Yeoreum Yun

