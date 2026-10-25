Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8286C606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 10:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blPOGtHH
Received: by kanga.kvack.org (Postfix)
	id 8AC176B05B4; Sun, 25 Oct 2026 06:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8839C6B05B5; Sun, 25 Oct 2026 06:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772EE6B05B6; Sun, 25 Oct 2026 06:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E86E6B05B4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:57:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6A0CA80C9
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:57:06 +0000 (UTC)
X-FDA: 85360846452.07.F5687B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 059BD1C0003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:57:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blPOGtHH;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792925825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxGHp2cRhL5SwPo0OwBRfhp0Jz+5ULz4/oEe6eLF81A=;
	b=B4krJ0KiBq4aYiwix0t3ZeZwOOEgIOsl0BEIGuM/701HtIbm2GJQnERRJ1KoZvIhM8pTW+
	esG6rL52a9tHmc3IqtEGCw8Xob5xmokiH8dm3v4cTmL3IwNWz+kjS1+Pua2MgvVsy4Z9zh
	rzANIukkHMIkILSzo4Mp3tdRJb5ZR6s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blPOGtHH;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792925825;
	b=axPKir4V7Y32WSjZCf/AULzWXggtX3wpFJkArlzrUAjLoOaUs9Qm82zdqOncMySRCJqwO3
	3pZpQhDfDwbi9iuGLiIs3fsTxvxuzrs68UaIKlM4Ps9l2JCkY7yT1CifRAQw8qaQekX5NI
	9c9YEkXbcCaqMi4Peto6tUEP9f8YZIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5201541B45;
	Sun, 25 Oct 2026 10:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1336A1F01825;
	Sun, 25 Oct 2026 10:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792925824;
	bh=WxGHp2cRhL5SwPo0OwBRfhp0Jz+5ULz4/oEe6eLF81A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=blPOGtHHu1tq3dB00Ujh+vtvVYU+cG9XGGANoibb6V930ieUlGbThJR+UuVR5cEbd
	 VDxHHioU5Hje8/Bmd1zSATXRtXaqJ9kl4uv8M/A2r1CF7seZT7bVSEoy53/lqc5FJU
	 hjOb1vaWSnLDDFQP7W6iS9d+m9w9BjQqTReqGEnGK0c++AFP05BLJJZ6qpqfHYt0we
	 tDS/J1Oom1CD5WxjzTCiI+tVn5uu8mJ6/9kWgudDMDN9VJvTniA8vjcs5F0p2RdjqQ
	 VnkTzliosOQ4wMTZFG7/8Lwjt8/PHd78lWpeF3K2r+jObJgsTzLeBkEVrVTjApt3vN
	 QRD3NcP3ba2ZA==
Message-ID: <d5dc39ba-6af9-484a-9e3d-9c73662c431c@kernel.org>
Date: Sun, 25 Oct 2026 11:56:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
To: Ngoc Quy <ngocquy0700@gmail.com>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261014095540.3261469-1-ngocquy0700@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261014095540.3261469-1-ngocquy0700@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 059BD1C0003
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: zbjoi56q8dtue4azxk5iep5hq93f3xj5
X-HE-Tag: 1792925824-709527
X-HE-Meta: U2FsdGVkX1/A6zIbkdGXHitdBKSKlzNqdpUpmGLvjatieUFZF4DzlbHTu1rp0Z2ntRZ98l97Aq3N/NGCO8WfoBBixcSsB0fKOsZ4SDimQcEy8Pvr4f/tdt4BJI+lbn9vsmKZg6e9yDnbdtl184XGTPIAr0+zTNH+pr01cQxQf/3o4t5p+dLopUkkLURBHeDY3DuJZFz0MvFHXAWL728PzWsQrWO7kTbWSxUqNIyvuLQUFCTvoTnJCRdZJA3Dwdf1OdwyUd+XegqNAbo1U3irHxWsNEa9bBsA+RoTg0tTQDi6SaNUUky7cAazxhLM7fNUi93tSBuSt3A6CyKz7mbeQaOqDRog4WUDMmCvViBrQ5jwAooSmZgXWTuNJ6ZW2xztxk1rETj1QP+8sp8y2IluhFM0Jh+lFJsP/bFg2SHLLuCDpE3ydIAgSkM5BbO3ZYUa4J3nK+UOa5+qkOUqh0W1hkYlh+SvuFlhZ/zBnH6qeUdc01CAtkVpTpp9KtGHXoBTzouaQW3IoktStWV6j1zUZvN4gjc8P2BrFsLLxjgHYX9NODXCUH5Pvm1OtTAPpL+QJ/MZJXHNnS5sJbxYLDMKMFV3GXYmtLtyS4iZXU2HQEuo6JE547WuunIbw+h6b0a5im2cwmbwdFVGmfTf6pl1+8optXt7OPBm4gaue8gFF+wtWU+cZq+mRdv3+PkkDOCxoJ7JlZQqbX5AZNeaXNyhAzZqajGKAPbHQ0ikCxsW1TV16YpBUbgSnUxGlw46S3BeiInUyHcoKEBYZD9ov7sR1Huc0ySk8rtWJDfbqNu83QSV70e+BEQtFw8U7xsLvD6I1l/FMMr/Hs4GMb5ew7J85T5CZRD/A3t6ipm7VIxitgG0JGewkLP5ncdOpEqyEqQxzeHFIQaV+6k8OX/uSGVrBXny2z4e0QXHbV/J8z+Uoc4bQogwVlrDRHBNl1/dr+rawekupga9Ac9g/4qJe8F
 Yootk7Q9
 jlI78FaUd5pICFQWCrDjFNDrbI2z0vitQxug5eWlQayD/o7GKhBri60Lnt2cwCLrFtTM2+idPE0Jh39hHO8NLXblkt0Kw7mcLMExfCoBddofgoo+d7vhGgM82wSyWGzbtc00xToY1zaxRh1Xvuv8hQspwLfXgkMJ4HJ5Lg2JChYqrm5++eW5y8FcxZy+kjb5tbvyvoPR6CdeTMx2NTKihMz8RpEmneqwk3q5ug4nmt8YFybnzkkx8RXan4eHpwWWe+TfVH9c8EfdK3a5J6kji+kpKEXTGkYBrRr4SIICtgr9b83bhWzfwy+sQcXd1RHAQPCQZ7+aruwmFpEv3qsslKHvh1iKubPrEHcjm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/14/26 11:55, Ngoc Quy wrote:
> The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
> /proc/<pid>/pagemap without holding a reference to mm_users.
> 
> proc_mem_open() deliberately grabs only mm_count, so a consumer that
> touches the address space has to call mmget_not_zero() first. Every
> other consumer in this file does -- m_start(), do_procmap_query(),
> show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does
> not.
> 
> Without that reference the target can reach exit_mmap() concurrently,
> and exit_mmap() calls unmap_vmas() while holding mmap_lock only for
> reading, which does not exclude the scanner. For ordinary VMAs this is
> harmless, as free_pgtables() and remove_vma() run afterwards under
> mmap_write_lock. A shared hugetlb VMA is different: __hugetlb_zap_end()
> frees the VMA's hugetlb_vma_lock inside the read-locked phase.
> 
> walk_hugetlb_range() can therefore load vma->vm_private_data, have the
> lock freed underneath it, and then down_read() a freed rw_semaphore.
> The load happens before the freeing side clears the pointer, so this is
> a use-after-free and not a NULL dereference. Any unprivileged user can
> reach it with no huge pages configured, as hugetlb_reserve_pages()
> allocates the lock before the VM_NORESERVE early return.
> 
> Pin mm_users across the scan, the way the other consumers do. mmput()
> from the exiting task can then no longer reach exit_mmap() while a walk
> is in progress.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Ngoc Quy <ngocquy0700@gmail.com>
> ---
>  fs/proc/task_mmu.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 5c54aebe2118..8825b01f5e38 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -3231,15 +3231,18 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
>  	size_t n_ranges_out = 0;
>  	int ret;
>  
> +	if (!mm || !mmget_not_zero(mm))
> +		return -ESRCH;
> +
>  	ret = pagemap_scan_get_args(&p.arg, uarg);
>  	if (ret)
> -		return ret;
> +		goto out_mmput;
>  
>  	p.masks_of_interest = p.arg.category_mask | p.arg.category_anyof_mask |
>  			      p.arg.return_mask;
>  	ret = pagemap_scan_init_bounce_buffer(&p);
>  	if (ret)
> -		return ret;
> +		goto out_mmput;
>  
>  	for (walk_start = p.arg.start; walk_start < p.arg.end;
>  			walk_start = p.arg.walk_end) {
> @@ -3294,6 +3297,8 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
>  		ret = -EFAULT;
>  
>  	kfree(p.vec_buf);
> +out_mmput:
> +	mmput(mm);
>  	return ret;
>  }

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

