Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487F1F44840
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739AD6B0089; Fri, 10 Apr 2026 07:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C38F6B008A; Fri, 10 Apr 2026 07:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B166B0092; Fri, 10 Apr 2026 07:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 426856B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:24:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E32058EC3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:24:50 +0000 (UTC)
X-FDA: 84642413940.24.33D3A66
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 609C818000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:24:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lgc0buJb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775820288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pL2u8G14yedECayBazskDlM9FGACE+Bqe2F5AnR4p0w=;
	b=updfWPVCJWyNiDJBboOPVDYgOB9UJnwmCmZf4MJ7ttHRYTBJ/LwHOGuULf6fUR1jCZn81I
	hHrSvF+hnFyxw5tLi/P8T3PxQ8gyUgjynEnCZXVe392Sb0eFwF4kRe78He61xImRdbD4xd
	oybdEeg/0zEP16aYw7ettan9Qvn3ZIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775820288; a=rsa-sha256;
	cv=none;
	b=c4E2M85jQes/0FtsjHG3VQPIpszUmuPAZmbsK3h0J529iQrZsfV5+1o7k+US38XgrxrlU4
	js8oRjYxhn5jSKX8DNI1KYSFcPV0yhlw4zL5LzG/sqeddmAwZ2Zf2dp9I7Dq7yYzzFhpev
	Uw+JVt96G0+/MY8ntqoadsMz4hTmMCI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lgc0buJb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775820286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pL2u8G14yedECayBazskDlM9FGACE+Bqe2F5AnR4p0w=;
	b=Lgc0buJbwkSBl9H29bocyedc72ItyFsaAvpYxeazrNi8uKkkmpOkYKIuqoy6zLqjrUOF4H
	j7mbJ3zl+i0Cz/9du9+JO4FfGZOnSKU6BmHlsN+lbRh6LgyILLCF2B2rCVDrCRzZLHOoHT
	0biJvrXVp0hla/Qn6xTcNSfmBYj4B9I=
From: Usama Arif <usama.arif@linux.dev>
To: Jane Chu <jane.chu@oracle.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
Date: Fri, 10 Apr 2026 04:24:31 -0700
Message-ID: <20260410112433.3248586-1-usama.arif@linux.dev>
In-Reply-To: <20260409234158.837786-4-jane.chu@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 609C818000A
X-Stat-Signature: 71tu1af7z3tqpxpi8ho8i5ge7wf3c46z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775820288-461333
X-HE-Meta: U2FsdGVkX1942yEOIQIzTvEtJTfkC/TzV0SU3MZEI1XZJnK/6JBS2MSuM0zgx1s250TvOreqKJ1Hbi9DhmJg7A7/896ibHcOdZ+fBlcFLZeZvbtTdDQxgvzC1eDrdbgGp98mai2fXc0JrqzJ3DCi31Oxyoh6qRVB5h2FTosARmxQQ8CJHejrcyAO3edZ/v3RGgbvHZE6PmYor1pEtAvR+9YZyeuWtHIfhx+38Tf/bMCTZ+k0Oogq7gDO1BkaXZdcoGYM0YS895QzwoqUz25nH3b6+PYhUkjH+txXuyFIUOfegdM4KZlDBZf6G8rGGAhuwpxp+2jC71n9hMOrg/zyzcjC0RaZG3+VJzvsVgdcIyFXNRAUj4Kxfd1B1B9oDbHm8niGZVdF8lhnbQJcvHMSr0TmKp39Ne71rGawwlYlL/GFgJNz0cccQql0W1t//kYpvW7i04lIkjBgb8ey2j4t5FVlS65dKKzajevHcVncAVmGc8QctQxT1cquopc+OY94nse1+c5NS2GVWs28uPGzAz5RbkkkL1bJFcT9uEN6Bvm+MQcDjdHybZhSI82tfjGDuxiVRNV2wlkVsuVFxwT7S+w/sVtD0oVHTLxNKOCw3KdQ3F9JTrgMQC8vzBlBrxt3j6i2GbhlhGGTudYwVpgUQArLYiJLP5CqUvqYYNtCOsdXSKb1e7Huzh4IGAQsoqWk1j8OFLdcac8eMRNvCIBLcdNIVJDBmQnsFLjZG5ZAL3WsUJImPxLqpQDai4XgLGB1xF8UuosPt+OEOU5KTNRx99xW8zQzb4Z0uHOgHDPCSSUdwtlOnnlkQIBt6ilkONzJLAC5uo3UbWOsXvuP93+Owte7jQhhf1MGfH/VAISOWhAk4xzuCWN1XkzSheQwni1ybXDzrfaTLYxShh3BzUSzCaen78ws6k5PEGoM5Zz/4fXT12rk8rd9AjB9SfvGZiiGWy47OnZPzUd8Gi1WFeA
 V0vuowfU
 SVW0mDnrZleORqa54pRJWZR8UF2Z6OeZcNF3QFxQ4KY35snJlqIDDVnMI87MCT/T3pcVE5OwWBqf1tDogTixQzAxHCFMM1xOWmz8TTYko7zTB4x4Hd70nXOJnzUyIylIQ3mUvF0zpaQVzKzxG+vtY5K2yJwSKiBvLEOrtHfF9kDMkovuKffiFo0nrPhizCZYz0aKqY6buvbRDRtYpYkbSOXVn/bAayGHOMgJ5H3KZQQWST/rAG8DNhkk49waiGq7VeRAuznwXOfcRjsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Apr 2026 17:41:54 -0600 Jane Chu <jane.chu@oracle.com> wrote:

> hugetlb_fault_mutex_hash() is used to serialize faults and page cache
> operations on the same hugetlb file offset. The helper currently expects
> its index argument in hugetlb page granularity, so callers have to
> open-code conversions from the PAGE_SIZE-based indices commonly used
> in the rest of MM helpers.
> 
> Change hugetlb_fault_mutex_hash() to take a PAGE_SIZE-based index
> instead, and perform the hugetlb-granularity conversion inside the helper.
> Update all callers accordingly.
> 
> This makes the helper interface consistent with filemap_get_folio(),
> and linear_page_index(), while preserving the same lock selection for
> a given hugetlb file offset.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  fs/hugetlbfs/inode.c | 19 ++++++++++---------
>  mm/hugetlb.c         | 28 +++++++++++++++++++---------
>  mm/memfd.c           | 11 ++++++-----
>  mm/userfaultfd.c     |  7 +++----
>  4 files changed, 38 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index cf79fb830377..e24e9bf54e14 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -575,7 +575,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>  	struct address_space *mapping = &inode->i_data;
>  	const pgoff_t end = lend >> PAGE_SHIFT;
>  	struct folio_batch fbatch;
> -	pgoff_t next, index;
> +	pgoff_t next, idx;
>  	int i, freed = 0;
>  	bool truncate_op = (lend == LLONG_MAX);
>  
> @@ -586,15 +586,15 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>  			struct folio *folio = fbatch.folios[i];
>  			u32 hash = 0;
>  
> -			index = folio->index >> huge_page_order(h);
> -			hash = hugetlb_fault_mutex_hash(mapping, index);
> +			hash = hugetlb_fault_mutex_hash(mapping, folio->index);
>  			mutex_lock(&hugetlb_fault_mutex_table[hash]);
>  
>  			/*
>  			 * Remove folio that was part of folio_batch.
>  			 */
> +			idx = folio->index >> huge_page_order(h);
>  			remove_inode_single_folio(h, inode, mapping, folio,
> -						  index, truncate_op);
> +						  idx, truncate_op);
>  			freed++;
>  
>  			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> @@ -734,7 +734,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  	struct mm_struct *mm = current->mm;
>  	loff_t hpage_size = huge_page_size(h);
>  	unsigned long hpage_shift = huge_page_shift(h);
> -	pgoff_t start, index, end;
> +	pgoff_t start, end, idx, index;
>  	int error;
>  	u32 hash;
>  
> @@ -774,7 +774,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  	vm_flags_init(&pseudo_vma, VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
>  	pseudo_vma.vm_file = file;
>  
> -	for (index = start; index < end; index++) {
> +	for (idx = start; idx < end; idx++) {
>  		/*
>  		 * This is supposed to be the vaddr where the page is being
>  		 * faulted in, but we have no vaddr here.
> @@ -794,14 +794,15 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  		}
>  
>  		/* addr is the offset within the file (zero based) */
> -		addr = index * hpage_size;
> +		addr = idx * hpage_size;
>  
>  		/* mutex taken here, fault path and hole punch */
> +		index = idx << huge_page_order(h);
>  		hash = hugetlb_fault_mutex_hash(mapping, index);
>  		mutex_lock(&hugetlb_fault_mutex_table[hash]);
>  
>  		/* See if already present in mapping to avoid alloc/free */
> -		folio = filemap_get_folio(mapping, index << huge_page_order(h));
> +		folio = filemap_get_folio(mapping, index);
>  		if (!IS_ERR(folio)) {
>  			folio_put(folio);
>  			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> @@ -824,7 +825,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  		}
>  		folio_zero_user(folio, addr);
>  		__folio_mark_uptodate(folio);
> -		error = hugetlb_add_to_page_cache(folio, mapping, index);
> +		error = hugetlb_add_to_page_cache(folio, mapping, idx);
>  		if (unlikely(error)) {
>  			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
>  			folio_put(folio);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 38b39eaf46cc..9d5ae1f87850 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5515,7 +5515,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
>  		 */
>  		if (cow_from_owner) {
>  			struct address_space *mapping = vma->vm_file->f_mapping;
> -			pgoff_t idx;
> +			pgoff_t index;
>  			u32 hash;
>  
>  			folio_put(old_folio);
> @@ -5528,8 +5528,9 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
>  			 *
>  			 * Reacquire both after unmap operation.
>  			 */
> -			idx = vma_hugecache_offset(h, vma, vmf->address);
> -			hash = hugetlb_fault_mutex_hash(mapping, idx);
> +			index = linear_page_index(vma, vmf->address);
> +			hash = hugetlb_fault_mutex_hash(mapping, index);
> +
>  			hugetlb_vma_unlock_read(vma);
>  			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>  
> @@ -5664,6 +5665,10 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
>  						  unsigned long reason)
>  {
>  	u32 hash;
> +	pgoff_t index;
> +
> +	index = linear_page_index((const struct vm_area_struct *)vmf, vmf->address);

This is supposed to be linear_page_index(vmf->vma, vmf->address), right?
 

