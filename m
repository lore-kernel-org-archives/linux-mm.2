Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78991FEA81C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDBA6B0089; Wed, 25 Mar 2026 03:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5BA6B008A; Wed, 25 Mar 2026 03:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC156B008C; Wed, 25 Mar 2026 03:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFFAE6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:31:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E8F5E05F6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:31:23 +0000 (UTC)
X-FDA: 84583764846.21.F58E733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CFE6E160004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:31:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nQ1tBcxS;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774423881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U01UvLL+2GKumhMfccsBdT4HdxsnM5GOcch+EONw0Lo=;
	b=1qy7JRpsCNDMVHtfA00s08JGtC7b3Rbf5DEdMG87dlimDgfHUo2XZRj7oOcsX+MGhkutw9
	/u+rb7Jt0m8ZULjtdpWemEgEmxY8TxUpiysZ0nOv1ZPisWVqGrsBIjVT3704ux92uYFdIA
	gBwJq1LG6q9ujBQAbXPfDbvCm9Nl95w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nQ1tBcxS;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774423881; a=rsa-sha256;
	cv=none;
	b=lpL8S4wx6C+V3u7FvEczX1twx5z7vermlWjFbYuKKyW0s2EjNKbDtXqpLOVVh4wNE9dsvL
	Yag9xbUjrs7wmO91mh6YpymMlgucpynxrJc5jUfA6obwXpndfOndoS5XAY5iRctK1wTqGf
	hWXVpzJ8OFu8c2Leh7my+y0sSv8EmJw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31B99600AC;
	Wed, 25 Mar 2026 07:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BAAC4CEF7;
	Wed, 25 Mar 2026 07:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774423880;
	bh=PDpC05xIR6s/4UV5jN3PjFOdu2Q97pVq9psWfxYFyHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nQ1tBcxSm01q4n6kTNrYWBbiz6PEozKBxiLI/zRRn9IVJLOFBuiCTBZTV6Ycbv68o
	 oiWSh5L8g+RNHWwPtdhmgn1oKV6wvxKTmlFbkJn31BymWvwaLcilghpF/Kt/e22P+q
	 To61pHOGS02rXG/sHWxWWIOLGtCXLJBQT+6jZQNKx4kBXkP5f8DvFEMIKhLfbKwCRz
	 8lqFvmWOowscszEiyhGCEjWBxzBqyWA5PR4f3CAd2qIwYN8saFjOzhVIqCVJoXxKNz
	 TPC4R2t+1iEuQeBDdvvuzwc1kVUBP5vhdKl/eZDomHm8OIwC74J3M9QLLUmopfkeUj
	 a2GPHfKz7cfEA==
Message-ID: <d0111a86-7fc9-4e2f-b652-9ecbb894ada5@kernel.org>
Date: Wed, 25 Mar 2026 08:31:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CFE6E160004
X-Stat-Signature: rmysm5spk8xxzomhz31x8hwcq44yi6qa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774423881-674274
X-HE-Meta: U2FsdGVkX18KE1+rcQKjyTDUJP9mZoMdSAxaa5W0HcYoMBnz+g4KUpYRBXiXHoNwJcqFweVsV2eJGyzBRr20+t1VMOrUy3LPvPbVUoxH8g5XAHhpQC8+uH6Fne3XpO+srQEFn4O4oenCk0FGWvz1oCt8BjnjQKR+D5ml/7Ub3X/55vIF6TTMeqoltN6YZIXMxbYprU+z3eT6ULhLkWScEGk2EXkAQPKIF3xU36GmFnNXe1ijOhPd7+3eQFev/GBi6MjtM4L6ewMs5NF04WLX0ZP4EEOGTz55KflLky/NEwfW8oxS7LDRL+E5NUQG5UhAdPgvP6xMQW/25vB0tGYAP+shfOJQ5mGQLEaQhPxk673k6+oA9bHW5ndve4UZ9PBJ3yKXIIYnu7VY64OLgDMrWbGoz9GibHDAO/5LyOLRkwOxB16r1GNRf+OA/QDfj7uKzsXTn4mJXNL15AoCMbJt2KJqVhGYRHw7vZAAxtYl37OhBHh3T/8+uf3LPwExzFxgqwqpmqZJUhYZ3e19yZDuGUXnuudUhrKbyL1qVAb7MVZtKnwQn7+IvG0fZfDbWQmGtFdJOSlAQBQwmlrTbrtKPkY9lnE3GQ2haEMgCCuGOON5x/1SKbapoGUycE5TrxcXFk/SncDZcr4HrDF/LooRJ6tIYbYD9iLilxrDOM4RF06p2lfdL87NR8sN7bRDivAHSw7hi+fArK7wGRzXT1ULAB7qK3z6FAP9OxmYNSOktCSR3WQGo3llkDUwFhsRuoWGfFe2+77vfHam/u2/C201AK8B+xRuZ/UQ6D27vhjFe2PhI0BePh9i4lMb4iO21AwHfTcxpyHG6GN8/12VVb/kRs+sI5+sMy2Kl2Wwffu0WnpdW9a3CUfyLtRDIr7UtlkdPegcNcMhdnqeXugkivtqhJb+0/w/36pxaKeIJ9vfYgVlVqqTqhmEfiKtdDf8x7fxTq+EvyEjX8RZWshvzyk
 b0AaDDAQ
 5kd99Z2jO6DKlMqCTWFyVzsS7hxW+iwIPUJ1lv+iu5tOfbE60/wkmDO7OiO6DQutmVuy+z+Z/MMXw1a1tGOCZq/UYd+2X+4vVSK7QCc7SsXO7ANzBkjFHvtOw46eB8XbOtMkQA9GYuPgg1qSQaFbZ4YDnG7+FH8/uMRv59xfmTqhKH1jykksdoOZAp0osV36lml8tdb8H1oMSeFb9+GEnajD4brD3H+p4sXY1Lm8b5cS9GuLaMAGfgNi1fE3Nyp7aohtRtt6kzeP4y2PW2UUVCiaREISW8HfJeSc3DjtN6cz4QHKNcmR/FMsTEkigr8EtHVDlSQPBouOWSWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> it.
> 
> While we're here, update the helper function comments to be more
> consistent.
> 
> Also add the same to the VMA test headers.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

I thought I saw David review all of the series and so focused on other
stuff, didn't notice he skipped this one :)

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  fs/erofs/data.c                 |  3 +--
>  fs/zonefs/file.c                |  3 +--
>  include/linux/mm.h              | 24 ++++++++++++++++++++----
>  tools/testing/vma/include/dup.h |  9 +++++++++
>  4 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 6774d9b5ee82..b33dd4d8710e 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -473,8 +473,7 @@ static int erofs_file_mmap_prepare(struct vm_area_desc *desc)
>  	if (!IS_DAX(file_inode(desc->file)))
>  		return generic_file_readonly_mmap_prepare(desc);
>  
> -	if (vma_desc_test_any(desc, VMA_SHARED_BIT) &&
> -	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
> +	if (vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
>  		return -EINVAL;
>  
>  	desc->vm_ops = &erofs_dax_vm_ops;
> diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
> index 9f9273ecf71a..5ada33f70bb4 100644
> --- a/fs/zonefs/file.c
> +++ b/fs/zonefs/file.c
> @@ -333,8 +333,7 @@ static int zonefs_file_mmap_prepare(struct vm_area_desc *desc)
>  	 * ordering between msync() and page cache writeback.
>  	 */
>  	if (zonefs_inode_is_seq(file_inode(file)) &&
> -	    vma_desc_test_any(desc, VMA_SHARED_BIT) &&
> -	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
> +	    vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
>  		return -EINVAL;
>  
>  	file_accessed(file);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index db738a567637..9a052eedcdf4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1178,7 +1178,7 @@ static inline void vma_set_flags_mask(struct vm_area_struct *vma,
>  #define vma_set_flags(vma, ...) \
>  	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
>  
> -/* Helper to test all VMA flags in a VMA descriptor. */
> +/* Helper to test any VMA flags in a VMA descriptor. */
>  static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  		vma_flags_t flags)
>  {
> @@ -1186,8 +1186,8 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  }
>  
>  /*
> - * Helper macro for testing VMA flags for an input pointer to a struct
> - * vm_area_desc object describing a proposed VMA, e.g.:
> + * Helper macro for testing whether any VMA flags are set in a VMA descriptor,
> + * e.g.:
>   *
>   * if (vma_desc_test_any(desc, VMA_IO_BIT, VMA_PFNMAP_BIT,
>   *		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)) { ... }
> @@ -1195,6 +1195,22 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  #define vma_desc_test_any(desc, ...) \
>  	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
>  
> +/* Helper to test all VMA flags in a VMA descriptor. */
> +static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
> +		vma_flags_t flags)
> +{
> +	return vma_flags_test_all_mask(&desc->vma_flags, flags);
> +}
> +
> +/*
> + * Helper macro for testing whether ALL VMA flags are set in a VMA descriptor,
> + * e.g.:
> + *
> + * if (vma_desc_test_all(desc, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
> + */
> +#define vma_desc_test_all(desc, ...) \
> +	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
> +
>  /* Helper to set all VMA flags in a VMA descriptor. */
>  static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
>  		vma_flags_t flags)
> @@ -1207,7 +1223,7 @@ static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
>   * vm_area_desc object describing a proposed VMA, e.g.:
>   *
>   * vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
> - * 		VMA_DONTDUMP_BIT);
> + *		VMA_DONTDUMP_BIT);
>   */
>  #define vma_desc_set_flags(desc, ...) \
>  	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index c46b523e428d..59788bc14d75 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -922,6 +922,15 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  #define vma_desc_test_any(desc, ...) \
>  	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
>  
> +static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
> +		vma_flags_t flags)
> +{
> +	return vma_flags_test_all_mask(&desc->vma_flags, flags);
> +}
> +
> +#define vma_desc_test_all(desc, ...) \
> +	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
> +
>  static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
>  					   vma_flags_t flags)
>  {


