Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319A2F36C2A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A7E6B00F9; Mon, 20 Apr 2026 02:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702056B00FA; Mon, 20 Apr 2026 02:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6402D6B00FE; Mon, 20 Apr 2026 02:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 533546B00F9
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:55:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0409E160909
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:55:10 +0000 (UTC)
X-FDA: 84678022422.16.ACCC184
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E00A80004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:55:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tn5ztGqB;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776668109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wwaB5GIadZhT3WNLdwXoaV7zc2xYRrQwirl3loMrXg=;
	b=0kSGrXp/lBwHcS2VmyMu/R9ibEk33JEJYsOi/hYQ9Bsv64y0mVHe8o6a1rmLYYgTJ6ns6P
	Ine7lvYVKQgbf/3YKDqbkA8BxG05+LgxfyKGvUm1D1Ur1GBGVp3IGSRwSkRbXmziG0qAwO
	R5OyypmT9wM57vZO+e6s+7YWWa2YwFs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tn5ztGqB;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776668109; a=rsa-sha256;
	cv=none;
	b=Kqdj+aco8eLU8icBxjQnUIt/Y2JukMaKujGQMoTLlj48u7yetx5zBEmo8ixpH8KaMl+ItT
	2/0YTc27oDmtkGhXB67vPdMfmoYzr6h98zADdockETTJuFVD+1Lt6OQ9rjzdrZi/cAfj8b
	lA2zCrse1L4ohgXuBAkGXa968u7hB9g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776668103; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4wwaB5GIadZhT3WNLdwXoaV7zc2xYRrQwirl3loMrXg=;
	b=tn5ztGqBDQEQ5IfiUVEK2xVgZ/YCJHkN0qgkD+aM9kOI8AAXgXFNe0UQuTsR6cddpknrhwnxkGHeIkJHtuzdqOTzyhPcFTnGMmAdo9KM1uXCOVSZcmz6lSJQMld2IE4xZG7g0wkmMgsw5puxmQheM36PeOLpOQLTmIa8fUcE9zA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1IKCmb_1776668101;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1IKCmb_1776668101 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 14:55:02 +0800
Message-ID: <b228baf2-0dcd-4135-bab9-04d979b6e617@linux.alibaba.com>
Date: Mon, 20 Apr 2026 14:55:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-5-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hhwghd5y1aikk8mfrewosncspfe5wpes
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E00A80004
X-HE-Tag: 1776668106-506319
X-HE-Meta: U2FsdGVkX1+FOf2NxSZbmNFGTlYlUgnyW7LUibex7u0Lzo3SXfE6aid+fTOvUhFNBrj6uHUufQOUPvj8dvvDqkfZ1aXzQv3Q0OmPAfwPZYjh8G+ZDNVVJlWrWxYmscuA5jOvMgn4LHynZDyRoCFisNzYdk/wVgcT8vsDjwDtUhf7qnw06RdE4OioC4s4qY1l0yuB1jFIvvh9Ea4asCRP3pA8z9OdEBksdwxZ3VkfWoJk9F4hiSTOAitqLZKBEjaX6v49BINqvWXTgH6RTz2lc9L6Uj7hyG8/7WOmKXgL0ouCIc1oU3/NDHXSgqqDRsT2YOmWaffZgRIMoa/Cm087o5u3DydY14O5US9kyNAymjn71TzZ9XgxT8HPbDVEY9O5uk9fdijBqZhE3MhiMHQoLqKeNEChazuNK+ZAQQ2X1CrUTeZA0a67Yc6PmzEBEQDCHllGLBgEst4u7tzGqcjh95tR2S/LLXq4PgyS1A2DROCna69WM/GrRkWvp2sNGKiq1ZWPsJQtxENrDqt1i8BhMoQmqsPYhgrNpCyxPP9VfH1XorlEAFTHYkOMI1+9SHmc1XJbrtB/bSG16/iP4qDhFZnsAR9aGHHwKEjrsaqvh56C33DIIZRUxxRumreTbtZ3humqWzf/mbEjkmVLHUfYPWA36B1G0qrd5OFX93dlEbY9FGiBSiyj6BNIapglq3pNk7lQSWnvhO8p9xHRdaspymD4Q7bgzeLdnL4VTuKEEtnAKNbIZVJ9v2xglQJEMYwo7SSi3sQ21XUAsyZ/obq0UlG+Fv55Ufh88g8uV6id5xqqnowoJeZWkoO2m+TrkEtrogbXav+zkA6S/0HuiW3iQDEM76Y0V5L1mKHTJ39wf1Au9w4D6XQSVhumFKPG2rzJ62tGiLhQvxCq0mww2ErBV+G6XqMLRMNy12pgZ42Wz3QTGbj/3mUacolHZJ+Bt6ZV3IV85M6DxkuVgArrXYt
 47sdyaqX
 nodlyp/mXrGXeF/unHLZ8NHtWA/qhRjIf+JbgZ6zWdEIi62zNZhG7TKY+PZlyqK6szVFzO4boM33YdsYBYDO531rPPbHmpJiJebzFFW6nG4Ye9QLVtC1GRCdUTRExwIIQQaZTFv7b9GgudXRxerUm7FFxP9IXPsjbv+5fbaVnLPBLnCcyfLDScqPgrtvlxgpBnsiT7eZxqBhYL2rwU++HUfl63I3bjq5X5AOqTtooIfE+Wgi9svhd2A4LH6UlW5aLAyELKWy/4Tm5xwD/8k1WNcZnlq7fBT5O1nAw9isI4Bs1tOIOoeuLgJVNNbagaU3wJ3AhpVOb1N5jgGP24Uay1eS123VVP5gyYxNO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/18/26 10:44 AM, Zi Yan wrote:
> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
> hugepages are enabled by the global transparent hugepage control.
> khugepaged can still be enabled by per-size control for anon and shmem when
> the global control is off.
> 
> Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
> IS_ENABLED(SHMEM) in hugepage_pmd_enabled().
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/shmem_fs.h |  2 +-
>   mm/khugepaged.c          | 28 ++++++++++++++++------------
>   2 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 1a345142af7d..dff8fb6ddac0 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
>   int shmem_unuse(unsigned int type);
>   
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>   unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   				struct vm_area_struct *vma, pgoff_t index,
>   				loff_t write_end, bool shmem_huge_force);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1c0fdc81d276..718a2d06d1e6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>   }
>   
> -static bool hugepage_pmd_enabled(void)
> +static inline bool anon_hpage_pmd_enabled(void)
>   {
> -	/*
> -	 * We cover the anon, shmem and the file-backed case here; file-backed
> -	 * hugepages, when configured in, are determined by the global control.
> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> -	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> -	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> -	 */
> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    hugepage_global_enabled())
> -		return true;
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>   		return true;
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> @@ -425,7 +415,21 @@ static bool hugepage_pmd_enabled(void)
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>   	    hugepage_global_enabled())
>   		return true;
> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
> +	return false;
> +}
> +
> +static bool hugepage_pmd_enabled(void)
> +{
> +	/*
> +	 * Anon, shmem and file-backed pmd-size hugepages are all determined by
> +	 * the global control. If the global control is off, anon and shmem
> +	 * pmd-sized hugepages are also determined by its per-size control.
> +	 */

Personally, I found the previous comments clearer to me. The statement 
"Anon, shmem pmd-size hugepages are all determined by the global 
control" seems somewhat confusing. For example, if 
hugepage_global_enabled() returns true but the pmd-sized sub-control is 
set to 'never', that means anon pmd-size hugepages are not allowed.

The code changes LGTM.

> +	if (hugepage_global_enabled())
> +		return true;
> +	if (anon_hpage_pmd_enabled())
> +		return true;
> +	if (shmem_hpage_pmd_enabled())
>   		return true;
>   	return false;
>   }


