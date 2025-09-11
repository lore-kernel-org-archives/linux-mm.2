Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24782CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D4F8E0005; Thu, 11 Sep 2025 05:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824D18E0001; Thu, 11 Sep 2025 05:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713BB8E0005; Thu, 11 Sep 2025 05:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59B938E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:31:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23D2B1DE70F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:31:11 +0000 (UTC)
X-FDA: 83876450742.24.D788942
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id A9B14C000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:31:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hqu2WDM4;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757583068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQgBSzW7MZBLnkTQQxNiCmSvpaQHwAjw2wmF5H1RJdc=;
	b=8Gp+YgcXviavzNu9qhFm05SUDUvJ2F1yrovvY1ViRyqIAXszFd3SUwct4oJO7WlpmwHC2B
	fqkiGPQRm1N3gRfJ5EU7JoU0wBwIWsPItgNLZEInW9TIzI9TBzR0HIMcoqN5Tqme88Ib2h
	H+xJRnRhlx2I7VzGJPNqnTx0i42qThs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757583068; a=rsa-sha256;
	cv=none;
	b=p+LUgY2hSA2zYuYhlr7IOJkSJF5ZqcwZsH9MCvndHaZeQ+q9747dCLw0pAvYPuXYOGA86r
	CXYiZlaoxGzQfEsTFgLgS8/NwWHG6z3NKXNgLkTtJMlj6wzUALRLHP4kiGRB7K+MRZNPOH
	icLRWiu1YdxIruDqWCF/gSowtNCibHY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hqu2WDM4;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757583068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tQgBSzW7MZBLnkTQQxNiCmSvpaQHwAjw2wmF5H1RJdc=;
	b=Hqu2WDM4GoBOQq7/+dYtL7mmtCTupqcMiON+flCZ67VVRF8RMhDpfiSpN9GvUuVAhmht1V
	xMa1ZNL/czTkAdyIA9JGjBs++LNTOZSuXyPK+xh5lmObMrVtI+qTJlI0Mh/loi6ukJICXG
	vG18qWLWphcNT3GkSBmxmFpmyCoYxEU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-bWz8rfBXNlCEGp_aKEMu9g-1; Thu, 11 Sep 2025 05:31:06 -0400
X-MC-Unique: bWz8rfBXNlCEGp_aKEMu9g-1
X-Mimecast-MFC-AGG-ID: bWz8rfBXNlCEGp_aKEMu9g_1757583066
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45dd9a66cfbso4177125e9.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757583065; x=1758187865;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQgBSzW7MZBLnkTQQxNiCmSvpaQHwAjw2wmF5H1RJdc=;
        b=wFiPLvIloMDhLvawgEiIqkCKfmjRxnU8vqHadd+CmShAbBos/QlLyGzud+CSve/KzN
         b8PiOssuoJliN1G8WKSY45a2aFv8Z23H2leS952o+H/Wa2fxKT7lqOT/jCHsouGXgvpS
         5VNhC2bcCsv9+5KlphTXkE5fAeFVN7c1r66h0/E1rW5QHoR20U/6GteQFUCaDyPhzPSX
         GKQBin8DG11dFaLm1D9iLpya8bic3LxsQ2wJTfBDK01QE0yGNTTAPiudFgz7fF/3CwY4
         nwSsJuBt1HZp/Umkc2g+Q4DuW0dviZI0Pp1HmE05zAHO7HqRuMUXz+MGjM+smGl1o8dd
         +IAg==
X-Forwarded-Encrypted: i=1; AJvYcCVCIPV3LcZclKvbH9zbhu6/yZy+F97oVia+cC4LXApOmuGnF/yVcco9sp0ycwoVVP5Y+c7Vk34kdQ==@kvack.org
X-Gm-Message-State: AOJu0YyMwpBWBmsYXQ2ZoGXR3+S8vcEO/vhzNNi7fnB181e/UTTjTA3n
	FrE96C+24Tqx3QUq89kLUMsVJ03+R3Budks6nfbquOEbZfxGIPSQ17ipJYq7B86GGn2ptnJy/D/
	1ACn8cBfnlVIn6+RBZguxwzpVQpJos5c2QZ3/yOK6RcnU/JpAD6O3
X-Gm-Gg: ASbGnct0m+6fz57cA7VaO8YxeKY8WufocJNU3qf9CMs5iwNkUVbli6mx5Ao6UTOxyHG
	Kjo0BRK5Qc2Y4phhMRPCeL8FXcWJ2GcpgSCh5AaNjZc62kKcwgUXhJOcI8GnBmCgX2EbqqqQ+P3
	8pj8QfQOKBJv3nGrbntomvz7c+tX10GXKAVoXlbwyQKHjIdUUsu4t9GL+7fDnQEjZM5zuQ/hNj8
	RcdxEpOO6L1pwTG+OOjbAnBWOjr8e4JRtenBkzOfucGO4VOpH7sxSHpXnGqvjONLyb18ZGi1peg
	IVeNPpHypuzKr/lCeb6NSYRCWaXZQLjuWVxeLKc15n/IDdPJQM1Q0Z0GHzNCdNLR4lHkmU27+3U
	fe6K1G1Rug7hdX//nDVKKOYZqXWBddO/vybygJixXQId07hqt662WzULtgrWhz/5DI18=
X-Received: by 2002:a05:600c:154c:b0:45d:da25:595d with SMTP id 5b1f17b1804b1-45de241c045mr143090065e9.22.1757583065421;
        Thu, 11 Sep 2025 02:31:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGL1YG8rjRM376Qm23m4BVQbfhxC1h3Ges4BLaAmucG/B6vAYPJtZTYpNyHaceuuLmMA9KADg==
X-Received: by 2002:a05:600c:154c:b0:45d:da25:595d with SMTP id 5b1f17b1804b1-45de241c045mr143089605e9.22.1757583064918;
        Thu, 11 Sep 2025 02:31:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0156b0a8sm19931135e9.3.2025.09.11.02.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 02:31:04 -0700 (PDT)
Message-ID: <a05ffc6c-33b3-4e14-92b6-852e8ff37d96@redhat.com>
Date: Thu, 11 Sep 2025 11:31:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 6/9] mm: Change dup_mmap() recovery
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-7-Liam.Howlett@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909190945.1030905-7-Liam.Howlett@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QwMzRY-Cv3LuXoerVUnUyg6iuLJS3SUDhu_qB2y41Io_1757583066
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9B14C000C
X-Stat-Signature: fzcfy4ehncp8f6t5u48s8psqdsyf95oz
X-Rspam-User: 
X-HE-Tag: 1757583068-329484
X-HE-Meta: U2FsdGVkX1+17SlRoXrl7jVxnZSnnxLjwhAlgTwfAyP6WqPvIXwl/SLbTDLKGTguDsAehcDjKuJrB7PVvdjImfWdy6cUGAmmVSiNh1HuiXytJSL4ALRVNX5geyunM57GtpYTms1P/git9yWQGBZMjcWSltHUezsrFq0spiySYl54HzH+oWbkaCBU7anvqpQbvBCD5mf5AwlC/vh+MAfqjGQWzwgjFhf6+GkS4uTv3vTN18Ij2WZSZwL3yJ1Lrlqn92lqOBFfa9g64J9jsM2Csn//6LGuhQ/JJH37rC6Yv4+RCMvKslWFVD5jg8qNdcQeTsvdaa9eM6RCCfAmQvM/C0mmFwY5xBhfjJd6tQarlDukJeKRds7EcrBPI4DC2N7zIYWYkJHT20Cj/h18JKiQqfIszo8gNStEgxTcqIasK320RjY+HvUpCy7UwtDGiExrG5VD2vfAtpIubvn7WU2YG4kb2KVksYEUF43O0ybpUaGJ3LjtgqN6AmzpqAMUNE3PthZNXCkxNNr7SV9QQxPq4IZIhkfj5+cCCcHIZ0b8IO4gV8yVJFdmVUnUcBhgsakHya9ZEvuwlxFanfI9Kn+tbGK2WrVOtEBLKtk+FNv7kLmi9MXLGyyxwMr4/GF1Jc0lTgPZVndImKp8jf80phj8GOTtHhpFhb6dPe/noh2aLsPI2xwFjzDhOZJsG8pCPSnMOibS4lhyR/mVTilg+LGKvyud8tiIPPTNr/X7G9OjimmN2h0BwkE9cq+tpsGD76rutcTJDB/yPfoGbZz2VvvNEHACL2OyrSARQ+8hFAwtOoyXyuknPAYjPl6cCEGmmi+0EVshIT3XNvxF2lj2Euw6Rq5/0myF96IGzc5Soxw/SPCNlQyrNmWSdkZlhWKNWwHU+39bRQ/u4i1o55gAswZcWGvAhfF+BRHZAWLzTcTOmMjjnXX9dk/S/dw3MydoPtc2CWtvaotwSzI8MNE3edc
 zKcdLaN9
 05/r9uqF9pO6nZ4cNcxt+FdqvlDCi9el5wu+pwlziK6pxjV86Ez+w+InaSrrwN5EuqPwcNvFvsnLRDjAWMfY3vO8K+hcB60bERQGza8wriO1eVIt1RwqGadhkt7M5Unfucs1CrAo+uwPzTOQ7WifNXUZgORlY0LLMj7IbdzPvMIZhUCoD51yJEzHegxIQ/uSXYqiZPnIRnldcmjVPgSR86g9XvRvbDiDS+e4cLGQHnIVTwaNdett9tEiJAAz/bPtxnrsQI0CI5JJm7TJ2VkreKa98/FyQ9o48CF1ivxT9rp8xfcYdDXqm+Mrm+6DflCDc0Ip7TUOziJFgctl8Am6Qew0VN7QhXPRSI6HbDI9eIOLoLuzNGxYLBx1Sdm8waJL1VuHuSgTvBauRzZR5q7ZB5un9ACtCRZoLtNtPZjCsFH4hNShsK5rl6S7b5CYDKM8mmBomUvo+Xoq486DaF2xkeWg9qbCSbxz5Oi7YdBUtoSmTmF/ZBFnS9TwvHvRqAUQWxE44PmJ+MLOJTWzyTjYkiIGeCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 21:09, Liam R. Howlett wrote:
> When the dup_mmap() fails during the vma duplication or setup, don't
> write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
> free the new resources, leaving an empty vma tree.
> 
> Using XA_ZERO introduced races where the vma could be found between
> dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
> race can occur because the mm can be reached through the other trees
> via successfully copied vmas and other methods such as the swapoff code.
> 
> XA_ZERO was marking the location to stop vma removal and pagetable
> freeing.  The newly created arguments to the unmap_vmas() and
> free_pgtables() serve this function.
> 
> Replacing the XA_ZERO entry use with the new argument list also means
> the checks for xa_is_zero() are no longer necessary so these are also
> removed.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>   mm/memory.c |  6 +-----
>   mm/mmap.c   | 42 +++++++++++++++++++++++++++++++-----------
>   2 files changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 24716b3713f66..829cd94950182 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -408,8 +408,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>   		 * be 0.  This will underflow and is okay.
>   		 */
>   		next = mas_find(mas, tree_max - 1);
> -		if (unlikely(xa_is_zero(next)))
> -			next = NULL;
>   
>   		/*
>   		 * Hide vma from rmap and truncate_pagecache before freeing
> @@ -428,8 +426,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>   		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
>   			vma = next;
>   			next = mas_find(mas, tree_max - 1);
> -			if (unlikely(xa_is_zero(next)))
> -				next = NULL;
>   			if (mm_wr_locked)
>   				vma_start_write(vma);
>   			unlink_anon_vmas(vma);
> @@ -2129,7 +2125,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>   				 mm_wr_locked);
>   		hugetlb_zap_end(vma, &details);
>   		vma = mas_find(mas, tree_end - 1);
> -	} while (vma && likely(!xa_is_zero(vma)));
> +	} while (vma);
>   	mmu_notifier_invalidate_range_end(&range);
>   }
>   
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0f4808f135fe6..aa4770b8d7f1e 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
>   	arch_exit_mmap(mm);
>   
>   	vma = vma_next(&vmi);
> -	if (!vma || unlikely(xa_is_zero(vma))) {
> +	if (!vma) {
>   		/* Can happen if dup_mmap() received an OOM */
>   		mmap_read_unlock(mm);
>   		mmap_write_lock(mm);
> @@ -1858,20 +1858,40 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>   		ksm_fork(mm, oldmm);
>   		khugepaged_fork(mm, oldmm);
>   	} else {
> +		unsigned long max;
>   
>   		/*
> -		 * The entire maple tree has already been duplicated. If the
> -		 * mmap duplication fails, mark the failure point with
> -		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
> -		 * stop releasing VMAs that have not been duplicated after this
> -		 * point.
> +		 * The entire maple tree has already been duplicated, but
> +		 * replacing the vmas failed at mpnt (which could be NULL if
> +		 * all were allocated but the last vma was not fully set up).
> +		 * Use the start address of the failure point to clean up the
> +		 * partially initialized tree.
>   		 */
> -		if (mpnt) {
> -			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
> -			mas_store(&vmi.mas, XA_ZERO_ENTRY);
> -			/* Avoid OOM iterating a broken tree */
> -			mm_flags_set(MMF_OOM_SKIP, mm);
> +		if (!mm->map_count) {
> +			/* zero vmas were written to the new tree. */
> +			max = 0;
> +		} else if (mpnt) {
> +			/* partial tree failure */
> +			max = mpnt->vm_start;
> +		} else {
> +			/* All vmas were written to the new tree */
> +			max = ULONG_MAX;
>   		}
> +
> +		/* Hide mm from oom killer because the memory is being freed */
> +		mm_flags_set(MMF_OOM_SKIP, mm);
> +		if (max) {
> +			vma_iter_set(&vmi, 0);
> +			tmp = vma_next(&vmi);
> +			flush_cache_mm(mm);
> +			unmap_region(&vmi.mas, /* vma = */ tmp,
> +				     /*vma_min = */ 0, /* vma_max = */ max,
> +				     /* pg_max = */ max, /* prev = */ NULL,
> +				     /* next = */ NULL);
> +			charge = tear_down_vmas(mm, &vmi, tmp, max);
> +			vm_unacct_memory(charge);
> +		}
> +		__mt_destroy(&mm->mm_mt);

Usually comment about just calling things start/end, maybe with prefix 
if required.

Apart from that, LGTM.

-- 
Cheers

David / dhildenb


