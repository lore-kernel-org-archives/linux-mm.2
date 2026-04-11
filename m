Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF20F36BA6
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 07:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD686B0089; Sat, 11 Apr 2026 03:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0854B6B008A; Sat, 11 Apr 2026 03:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04B86B0092; Sat, 11 Apr 2026 03:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0ED56B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 03:22:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C7D31A0758
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:22:19 +0000 (UTC)
X-FDA: 84645431598.27.3E56512
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6306E40004
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:22:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="woAEs/Np";
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775892137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XDCidWv+N0yMg7BZtqHjmakg+ga87CgFP2PpQeYyTU=;
	b=ADyOIeAkZIj9vI7zbvYSPATtNJHejKblw1K+yEBBm9nU5qj7lk9aFqxQjIBbSKaTl/zzv0
	fNSGLEPmY7YDSNOpFTaNkmM9SECuP55gq37ZPDop1/MnAPYXIfdmV3/A2u+ZvXgdfDnOjT
	FsDGxlnJTiFCCA1v87vKuqWLcbUu+rs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="woAEs/Np";
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775892137; a=rsa-sha256;
	cv=none;
	b=RG3LeCSvJp7nuhpXgpjdwn/Th5HXsMyD6rV4bqJ9SF7GJpt9VTPfXWGn2vK+gElTc9Gkkn
	KV9Szcs8Sa8wJ3gsXy4shye8iqjcQdoP7ulygaZros8OrACSDxMXApa7XFFMni6C380cWM
	HNt7zin+bR1gzMjYyImsmV3xgYxphgE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775892133; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6XDCidWv+N0yMg7BZtqHjmakg+ga87CgFP2PpQeYyTU=;
	b=woAEs/Np3B1hIAgoNhkE7wwR7aVyFH4ZIv0dn9sjf7xt/Q+njnYD9/oSv/1UbwT/BzdNXy2qT0KuCmFvMfi5OEfRXh/ZxdV8AaTfXwXAzsk2+dg5Mcj8jbIQ35qQGbC6jVnYUPwCTgYbNPEz2MHTnTmMMm7z0VCXri9FG1yIOHU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X0n6158_1775892131;
Received: from 30.74.144.103(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0n6158_1775892131 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 15:22:12 +0800
Message-ID: <5e653a9b-9265-4bfd-89ce-f0fbe0df2ae6@linux.alibaba.com>
Date: Sat, 11 Apr 2026 15:22:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6306E40004
X-Stat-Signature: ndxjg1qdiboj9w3ceepicwfn7mktbum7
X-Rspam-User: 
X-HE-Tag: 1775892136-418401
X-HE-Meta: U2FsdGVkX19dkxq8/AOYCBNk+jUOe2JtIV+wiAcRtDxdqxmJzjMpDaOu+AtS9Nn/gFbDN4M2XzmCFaqj9Lo3lHxMZtLCVBHALz1yV9yt+/UPUadkBOCQgGelZKPBA2LkENpzkZS+aeyAGbQuS6DvlPCpgKWOZZ2JyUcs62w/djuKmRWj3e+xQZeSUFBEo0SLwiu02F9d/tyfOyXnfSUVAs4x/Fisyf8KjEnWxzltNkTuMS9N85mQcjfc3RHUeVCyZeKUCsgpGENhH63wZTlzwIhX506r0BpZ9ICP2i8HiJALQovebE/mSHOlO8vExGcCbe25ZWyHNHuCTNQJYMZaNS9SzTto51GzmAmfdiW2qvybila1IthVYKjBpGIyrG1jt3/gITemD1KFToXGrSkt8b6z+vfqbXn8jU3ZjQN0NyzvRL8jkv9md/kChUBR4i+qW9m5xE/r4o/cHrdiZrtFlYJZ8pyxa3i9JBEFyEvHaMo/Tiw0UUrFAOEIq40DWEY1y+83r2IVre7AsG6HWj7KhQ7OylvOSbNex2r4WGztN6ZDoVfEKK7L72QJSISPiyb56UGxn6pqloSmNWSIZFyOWLh4fRl7XPbdkv65QK3dqn2MnFts19mwAi3je9fVdCiF6QGseOCOV06u4NJAROdrB5EFQ98mFUp6I/7NFA2HED70Sn0T7tMnHCBwnIaVdz3gM7fCU3T2ojJiklCzdLEvBXzdovdFCuAH9AUeppN1m2nYGr75zIlMipBQ6t71YamFU38cN9Qm0y+4tqwFBlxt9pB5jVncVDZF9/W1tdPPcjkjZ8RbPCs6yCYqde1yb8LhcNWZYdsqk+31iPKObPzwreQce8ptYWSjriM8BJWO/2JZ0hy6UREzVFGIRWM/igkCTBVAY2M6778Ks8DxiW+iuvlf+BKMAbOn8nixjNNJMjruUfSDXfCbOmVXdk0W9sTP27U622mdzcrp7i+cWRg
 gLmXrS6b
 Bm2t48YT3zDwTgqi8u7U8vKRKS3zzDJYMzKqxX/6KAmiVmaYixgf+qZo1IGtVHELdIzfW3U6rX2A7P6bvb6CBBzG07AmJXIfGE1E5nghFPLcYV2F3hftT+1iOmAVjMNeSZMGSBYyhpIKqW95uWLNcObAykWnSg4h3aac1c4fh7FzIsUeMsVaYv+JFwDWenO3em+/QeXA1FmxC+ypmLKyB0/b2BIbsEiw1vlac3V8GodtaYb/ZqETPDQ0X0Uv26blPTpT7ChmTM75YdTAyYC5hoPX0A3KaeX8ck2Np58n84Iba9No=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/26 4:23 AM, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem:
> 
>   - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>     check so that mTHP sizes are considered
>   - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>     when PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/huge_memory.c | 13 ++++++++-----
>   mm/shmem.c       |  4 +++-
>   2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 86e489c0a150..6de3d8ebc35c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -118,6 +118,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	else
>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>   
> +	if (!pgtable_has_pmd_leaves())
> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +
>   	orders &= supported_orders;
>   	if (!orders)
>   		return 0;
> @@ -125,7 +128,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	if (!vma->vm_mm)		/* vdso */
>   		return 0;
>   
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>   		return 0;
>   
>   	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -787,7 +790,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>   	 * constant so we have to do this here.
>   	 */
> -	if (!anon_orders_configured)
> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>   		huge_anon_orders_inherit = BIT(PMD_ORDER);
>   
>   	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
> @@ -809,6 +812,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	}
>   
>   	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves())
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +
>   	order = highest_order(orders);
>   	while (orders) {
>   		thpsize = thpsize_create(order, *hugepage_kobj);
> @@ -908,9 +914,6 @@ static int __init hugepage_init(void)
>   	int err;
>   	struct kobject *hugepage_kobj;
>   
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -
>   	/*
>   	 * hugepages can't be allocated by the buddy allocator
>   	 */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 613393eae5a9..b49a30475cb0 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1839,7 +1839,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>   	unsigned int global_orders;
>   
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>   		return 0;
>   
>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
> @@ -1947,6 +1947,8 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>   
>   	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>   		orders = 0;
> +	else if (!pgtable_has_pmd_leaves())
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
Sorry, I still don't like the changes here, because 
shmem_allowable_huge_orders() is meant to determine which large orders 
are allowed. Something like below (untested):

@@ -1834,6 +1834,7 @@ unsigned long shmem_allowable_huge_orders(struct 
inode *inode,
                                 struct vm_area_struct *vma, pgoff_t index,
                                 loff_t write_end, bool shmem_huge_force)
  {
+       unsigned int filter_orders = pgtable_has_pmd_leaves() ? 
(BIT(PMD_ORDER) | BIT(PUD_ORDER)) : 0;
         unsigned long mask = READ_ONCE(huge_shmem_orders_always);
         unsigned long within_size_orders = 
READ_ONCE(huge_shmem_orders_within_size);
         vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
@@ -1846,7 +1847,7 @@ unsigned long shmem_allowable_huge_orders(struct 
inode *inode,
                                                   shmem_huge_force, 
vma, vm_flags);
         /* Tmpfs huge pages allocation */
         if (!vma || !vma_is_anon_shmem(vma))
-               return global_orders;
+               return global_orders & ~filter_orders;

         /*
          * Following the 'deny' semantics of the top level, force the huge
@@ -1871,6 +1872,7 @@ unsigned long shmem_allowable_huge_orders(struct 
inode *inode,
         if (global_orders > 0)
                 mask |= READ_ONCE(huge_shmem_orders_inherit);

+       mask &= ~filter_orders;
         return THP_ORDERS_ALL_FILE_DEFAULT & mask;
  }


Additionally, we also need a pgtable_has_pmd_leaves() check before 
setting huge_shmem_orders_inherit as well.

@@ -5428,7 +5430,7 @@ void __init shmem_init(void)
          * Default to setting PMD-sized THP to inherit the global 
setting and
          * disable all other multi-size THPs.
          */
-       if (!shmem_orders_configured)
+       if (!shmem_orders_configured && pgtable_has_pmd_leaves())
                 huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
  #endif
         return;

