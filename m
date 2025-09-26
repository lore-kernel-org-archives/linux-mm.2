Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23ECCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0848E000D; Fri, 26 Sep 2025 11:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298A08E0001; Fri, 26 Sep 2025 11:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADD88E000D; Fri, 26 Sep 2025 11:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07A998E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:13:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A532B87A26
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:13:35 +0000 (UTC)
X-FDA: 83931745590.22.BE71A57
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6A293140003
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:13:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hiES9xFT;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758899613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhtyBota5SG0ZAohFmugv1mltFcEigM7VyFxAyvdoGU=;
	b=XfC0JUovMvnKGsV1PWwBNzHKSQRXVrwyCplUMYjcQvjxfWjOq617KBpOvyuIn2Cq5uy6Y4
	NfQpxaYvK8EEuchM9Nb3NNBzuW0sdPCUBC+r1J+ks9bILZmgmgxEx26/st6yYtnijg0DmX
	0p6lSwO2U0144bjCN/NzEkIIvoeEu3o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hiES9xFT;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758899613; a=rsa-sha256;
	cv=none;
	b=JKLyvGru3pskap7EV9Gos/EO+cZPRHk2+BaO9jTQ2GNls6gUqJ/R25BipAXFQkPwxRsWzv
	gZWG2y6pVEYNHvECJq+aK6kyImnZWIqpo8//4wnOV6vmtvfVeaybtRzT0c0meAAEFLbsyz
	uhgUWluwDDv7MtY1fMTc1kAKgwtaS5A=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f2ae6fae12so1261391f8f.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758899612; x=1759504412; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XhtyBota5SG0ZAohFmugv1mltFcEigM7VyFxAyvdoGU=;
        b=hiES9xFTnCbpByuLC3ONvkBoROZCuxgI1lxJwSARy9qfVouEJX24CB+RsZeW7yKr35
         y1v6+Z3ifvBg2Iggjoxy+R1v42sE8onpcLPdjRsCXNtaEhC7HLUB90bOo05GUs5jCor9
         YsLagOVwuNA3hEjz1RuPdFRI49gSK2z4mFnkv6K8rLj9z7cUR4sVkcAIv1q+lV29scBL
         S3Rzj1SPVtUJOCZmEm0JH+8o44Ys4eldNH1dx6XLROX3rUOMhu021lgMQXgADpXOjOke
         GXoGfcx98m2a2pPrLbXPplGUUostpGDMXQ3kCO8rnkIxfRHmUBK81Gx/GtFwopRztB+c
         1rnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758899612; x=1759504412;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XhtyBota5SG0ZAohFmugv1mltFcEigM7VyFxAyvdoGU=;
        b=AURTMgapbcgKdg2/maZLBxc2nEiwLEHARbK9Cl+3gpuCV012Qzm38KlttSnwnTjkJn
         e42lhezntNW+LaGUl+Htr7DlqlWTEfCL2lBR9QNxgkgqhBpWgeEtjrZqGq17svG880g0
         ZnpajHoV1zittdVFvQ8A/vmsQNsQv2Zuaj0TOFARLCsqOo59DOVUYZKlBkyXY48M7rv3
         /+HXr4Nf3tvSDIM1G6X024RWYliDEFAQfzTjpFHar+0iYnAcWSQhwNXs8ZtkzvqBsEx2
         BB+2pCidtc4UVgPCMzAHY8XOO9E8ca99bpYIolB4drnCJmBYZPUoeNHFW54xeNygcpMR
         oK3w==
X-Forwarded-Encrypted: i=1; AJvYcCVy9gSsUbHS+nZWdmDE29LcIwUWQ+nRPZz9QhXBSI2VSd015/7oi35SQmqkv+R57a2XXRwVSnFpcw==@kvack.org
X-Gm-Message-State: AOJu0YzsRbkqsFe49DgC/WmJN2XeruCxEES0A0Pw70A/NnjhjgHIoLVF
	M7sIRPH+pRshuLxqFvDExxfyz1QEe8sREnR9kWKHxm34+0WWDWaHvmQ0
X-Gm-Gg: ASbGncuWp2cO8rEqnjny/tOqV3U14bpoNBO0NRW9aPME+/2EKckyaPcf7NCoENHDHrp
	J6s0G42txa5WBB7dcEwNP7uqAI3LJKJJwhgnFccGqmxlcr/PwAkIi1lsRSklBy3kiDd0gt4Af3K
	flfriSdf6KIIuT0ix5oeFonJQAAJveIfJ6nQc6oYFTf+aA11sHiLzW2+SHgdISK8L03aWSuADTp
	DINwzxdndsFBPKTBxXmXLuSqeY1Cw5jsx1OAcVK3rbTkWOIncHM316ZdAyLSvGZIyQrOLk2b5MD
	aFCqhD687KtwaRKKT5/YJDq2RytxLnI84qyggvmMuhP4HvYLJUNlHoPq7/cuWFBQZs+h5eYjP+Z
	c3rZez55T7hR08R1xZxGzRH9dHVhYFTzT5frBOA9NdDQLeu42WWfo4RuPKglzDoXXZ6Rq3fKX8h
	ICvyzJGN715uUL6SOI+IbVTi7jiLPh
X-Google-Smtp-Source: AGHT+IH3ajbe7vhTC6lcuJXDcjluXUUBAEeXkjep5KMm/cFj2+525ch3y8uHWArtYHiTW4yanFzxaA==
X-Received: by 2002:a05:6000:1447:b0:3ee:2ae2:3f34 with SMTP id ffacd0b85a97d-40e497c3458mr8048374f8f.13.1758899611592;
        Fri, 26 Sep 2025 08:13:31 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb871c811sm7457233f8f.15.2025.09.26.08.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 08:13:30 -0700 (PDT)
Message-ID: <073d5246-6da7-4abb-93d6-38d814daedcc@gmail.com>
Date: Fri, 26 Sep 2025 16:13:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 mm-new 04/12] mm: thp: add support for BPF based THP
 order selection
Content-Language: en-GB
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250926093343.1000-1-laoar.shao@gmail.com>
 <20250926093343.1000-5-laoar.shao@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250926093343.1000-5-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A293140003
X-Stat-Signature: 4ztt7nktgheo5msusrsmiebbqqnar8zt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758899613-448714
X-HE-Meta: U2FsdGVkX1+O/ptXw8nNgwQphtw7YQSDs4wWy5Xdf90NPu2FpjxQ/mrTx8S1dj1+OLlG8qVG6E28XCmCmOTvQemPDxILNTbFM1cPnmq0E4gTbvmQGG1k9P832yvmUdx9Kx3k89pzawjrEpSOFLmpUD2gS0Zp18q+04B/WeW1hRbFZknFDBO6+jw8Mo008lnnKeij1tM7Sxf/i2hGf7/elMPJYXgyMF2VZQ1hockJmnxepQyUOus7WZQNSEzoaXvfUhEBVLToO7cj5BFq2f+0VQqMzG5OI1m0sfXHnqQ8iaSTkEKIAncImWr/0o1ZLgUn04h9AVYoCW31OF+RJwRKuxRak1tpj0lO9PqvPlL2EHXpa73zs2ncZbiLtw0RKHrIFqjp25tqO0lhGs/CoeJxw8GHXakX9/FAJiwD8O2cmZ63uKBUxl2AR2GhzRXBpFdou0NWvB11WPx7QmrTy9AJBsXXwY5uDgSwzXU4qHIYlchzcEVz6uOTUGfnf3hy7TZ91N7T2d+1aPrbxG7spezWLcNoq0KPcmeV/10tljzsQ8eNr3n/hC515fe81T+FUBqL6chsXpBOxZQjxe9A1DT5u+iZx/Of0GHSRnG/Ssa28UDz5mRYDwRHgBhOK3BhGgPe3S4Cd2Ebnhamhkq6NrSk/8aTGUAbW9lp0b4bh0alF+JHfzsZJ5jAkzFSwKrYaHtSVOUo0HYWcu6/DqpTnRzq8F2ItZKCqds6Cn0+34ZfGmt93okvcfNBl7FbWV1DsW3WlDdN4Trk1i8VegSDlco7uFfbnxgvubYPKz2yFIMwkT01XwN8QgrfalAvS5hBFBwggdcuLr5IW/oqvaO7KwOoBAfbX8Gaqitkz/IZ8if+tRahy9UKh1lYniENdqBdaiqpwRSonORWNcWLTUtv8ACIwoToh/s9Ylzw+353d08xKlPg6VojBDywB5TTRRAVx41N9av50MkuM2ZbWyJrW6H
 P7uB2ks2
 slhqQDVvY6b92TP5wkk2QEJFRqJBn9lDw235qN8iNzNXPxlriOF+fDGToHniOlGdvEXrWDX3aaeRx1D+N7LKhhikmHoQHu4E2qCBXkqPtTiOUKV0JAGe3rSxzVNDu+teHpiNdk+Kl/lkVCHg/fuI8EXqCrNhO++2by+XZE064w4+6t51LnUdfwfRgjcUT1xc4nqPRUdup11xHdILRugWE8GJYJ3kXwqutYxnfROslSDTrqHjpPcszQUkkLMV9LQkurLmpN3E/Dp6nToqAdnPmxhF1ILWKLw9HMwdBn7Yhn0uTMimjSx2w35PMC48Mu3JN1YChA5VHWJ14Gop12ofXpYbSUW/2KSDHWlG5cvHn6saUET/D68+AL9TzIxH45Bh0uTBzKtz2TOFgCcc6EzazkX2XSh71EoMpJ3T9BPEEMoA+t0xousYUMcFleBlXdh5bEh14HvYbcMgpgNvutEsSUuuhIw+CtCQOzlwYI6lXcUyi/dJYRtEl3Tp7GFzo7bfTd0N+IhLAVKAUc36ZntRw7FBJMkuURHNFI1aD6/k0j0463lfCVmz2U/t1gTaWueD3l+x2bRl6RUuT/CJ+TcHzBLvvmWUlI9Zzu7NmomZp52I3/WoIIN2C4e0hTE3prEc+GZZT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/2025 10:33, Yafang Shao wrote:
> This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
> THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> programs to influence THP order selection based on factors such as:
> - Workload identity
>   For example, workloads running in specific containers or cgroups.
> - Allocation context
>   Whether the allocation occurs during a page fault, khugepaged, swap or
>   other paths.
> - VMA's memory advice settings
>   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> - Memory pressure
>   PSI system data or associated cgroup PSI metrics
> 
> The kernel API of this new BPF hook is as follows,
> 
> /**
>  * thp_order_fn_t: Get the suggested THP order from a BPF program for allocation
>  * @vma: vm_area_struct associated with the THP allocation
>  * @type: TVA type for current @vma
>  * @orders: Bitmask of available THP orders for this allocation
>  *
>  * Return: The suggested THP order for allocation from the BPF program. Must be
>  *         a valid, available order.
>  */
> typedef int thp_order_fn_t(struct vm_area_struct *vma,
> 			   enum tva_type type,
> 			   unsigned long orders);
> 
> Only a single BPF program can be attached at any given time, though it can
> be dynamically updated to adjust the policy. The implementation supports
> anonymous THP, shmem THP, and mTHP, with future extensions planned for
> file-backed THP.
> 
> This functionality is only active when system-wide THP is configured to
> madvise or always mode. It remains disabled in never mode. Additionally,
> if THP is explicitly disabled for a specific task via prctl(), this BPF
> functionality will also be unavailable for that task.
> 
> This BPF hook enables the implementation of flexible THP allocation
> policies at the system, per-cgroup, or per-task level.
> 
> This feature requires CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL to be
> enabled. Note that this capability is currently unstable and may undergo
> significant changes—including potential removal—in future kernel versions.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  MAINTAINERS             |   1 +
>  include/linux/huge_mm.h |  23 +++++
>  mm/Kconfig              |  12 +++
>  mm/Makefile             |   1 +
>  mm/huge_memory_bpf.c    | 204 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 241 insertions(+)
>  create mode 100644 mm/huge_memory_bpf.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ca8e3d18eedd..7be34b2a64fd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16257,6 +16257,7 @@ F:	include/linux/huge_mm.h
>  F:	include/linux/khugepaged.h
>  F:	include/trace/events/huge_memory.h
>  F:	mm/huge_memory.c
> +F:	mm/huge_memory_bpf.c
>  F:	mm/khugepaged.c
>  F:	mm/mm_slot.h
>  F:	tools/testing/selftests/mm/khugepaged.c
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a635dcbb2b99..fea94c059bed 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -56,6 +56,7 @@ enum transparent_hugepage_flag {
>  	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
>  	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
>  	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
> +	TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached */
>  };
>  
>  struct kobject;
> @@ -269,6 +270,23 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  					 enum tva_type type,
>  					 unsigned long orders);
>  
> +#ifdef CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL
> +
> +unsigned long
> +bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
> +			unsigned long orders);
> +
> +#else
> +
> +static inline unsigned long
> +bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
> +			unsigned long orders)
> +{
> +	return orders;
> +}
> +
> +#endif
> +
>  /**
>   * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
>   * @vma:  the vm area to check
> @@ -290,6 +308,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
>  {
>  	vm_flags_t vm_flags = vma->vm_flags;
>  
> +	/* The BPF-specified order overrides which order is selected. */
> +	orders &= bpf_hook_thp_get_orders(vma, type, orders);
> +	if (!orders)
> +		return 0;
> +
>  	/*
>  	 * Optimization to check if required orders are enabled early. Only
>  	 * forced collapse ignores sysfs configs.
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bde9f842a4a8..fd7459eecb2d 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -895,6 +895,18 @@ config NO_PAGE_MAPCOUNT
>  
>  	  EXPERIMENTAL because the impact of some changes is still unclear.
>  
> +config BPF_THP_GET_ORDER_EXPERIMENTAL
> +	bool "BPF-based THP order selection (EXPERIMENTAL)"
> +	depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> +
> +	help
> +	  Enable dynamic THP order selection using BPF programs. This
> +	  experimental feature allows custom BPF logic to determine optimal
> +	  transparent hugepage allocation sizes at runtime.
> +
> +	  WARNING: This feature is unstable and may change in future kernel
> +	  versions.
> +

I am assuming this series opens up the possibility of additional hooks being added in
the future. Instead of naming this BPF_THP_GET_ORDER_EXPERIMENTAL, should we
name it BPF_THP? Otherwise we will end up with 1 Kconfig option per hook, which
is quite bad.

Also It would be really nice if we dont put "EXPERIMENTAL" in the name of the defconfig.
If its decided that its not experimental anymore without any change to the code needed,
renaming the defconfig will break it for everyone.


>  endif # TRANSPARENT_HUGEPAGE
>  
>  # simple helper to make the code a bit easier to read
> diff --git a/mm/Makefile b/mm/Makefile
> index 21abb3353550..62ebfa23635a 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
>  obj-$(CONFIG_NUMA) += memory-tiers.o
>  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
> +obj-$(CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL) += huge_memory_bpf.o
>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
>  obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
>  obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
> diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> new file mode 100644
> index 000000000000..b59a65d70a93
> --- /dev/null
> +++ b/mm/huge_memory_bpf.c
> @@ -0,0 +1,204 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * BPF-based THP policy management
> + *
> + * Author: Yafang Shao <laoar.shao@gmail.com>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/huge_mm.h>
> +#include <linux/khugepaged.h>
> +
> +/**
> + * @thp_order_fn_t: Get the suggested THP order from a BPF program for allocation
> + * @vma: vm_area_struct associated with the THP allocation
> + * @type: TVA type for current @vma
> + * @orders: Bitmask of available THP orders for this allocation
> + *
> + * Return: The suggested THP order for allocation from the BPF program. Must be
> + *         a valid, available order.
> + */
> +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> +			   enum tva_type type,
> +			   unsigned long orders);
> +
> +struct bpf_thp_ops {
> +	thp_order_fn_t __rcu *thp_get_order;
> +};
> +
> +static struct bpf_thp_ops bpf_thp;
> +static DEFINE_SPINLOCK(thp_ops_lock);
> +
> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> +				      enum tva_type type,
> +				      unsigned long orders)
> +{
> +	thp_order_fn_t *bpf_hook_thp_get_order;
> +	int bpf_order;
> +
> +	/* No BPF program is attached */
> +	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> +		      &transparent_hugepage_flags))
> +		return orders;
> +
> +	rcu_read_lock();
> +	bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
> +	if (!bpf_hook_thp_get_order)

Should we warn over here if we are going to out? TRANSPARENT_HUGEPAGE_BPF_ATTACHED
being set + !bpf_hook_thp_get_order shouldnt be possible, right?

> +		goto out;
> +
> +	bpf_order = bpf_hook_thp_get_order(vma, type, orders);
> +	orders &= BIT(bpf_order);
> +
> +out:
> +	rcu_read_unlock();
> +	return orders;
> +}
> +
> +static bool bpf_thp_ops_is_valid_access(int off, int size,
> +					enum bpf_access_type type,
> +					const struct bpf_prog *prog,
> +					struct bpf_insn_access_aux *info)
> +{
> +	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
> +}
> +
> +static const struct bpf_func_proto *
> +bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	return bpf_base_func_proto(func_id, prog);
> +}
> +
> +static const struct bpf_verifier_ops thp_bpf_verifier_ops = {
> +	.get_func_proto = bpf_thp_get_func_proto,
> +	.is_valid_access = bpf_thp_ops_is_valid_access,
> +};
> +
> +static int bpf_thp_init(struct btf *btf)
> +{
> +	return 0;
> +}
> +
> +static int bpf_thp_check_member(const struct btf_type *t,
> +				const struct btf_member *member,
> +				const struct bpf_prog *prog)
> +{
> +	/* The call site operates under RCU protection. */
> +	if (prog->sleepable)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int bpf_thp_init_member(const struct btf_type *t,
> +			       const struct btf_member *member,
> +			       void *kdata, const void *udata)
> +{
> +	return 0;
> +}
> +
> +static int bpf_thp_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_thp_ops *ops = kdata;
> +
> +	spin_lock(&thp_ops_lock);
> +	if (test_and_set_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> +			     &transparent_hugepage_flags)) {
> +		spin_unlock(&thp_ops_lock);
> +		return -EBUSY;
> +	}
> +	WARN_ON_ONCE(rcu_access_pointer(bpf_thp.thp_get_order));
> +	rcu_assign_pointer(bpf_thp.thp_get_order, ops->thp_get_order);
> +	spin_unlock(&thp_ops_lock);
> +	return 0;
> +}
> +
> +static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
> +{
> +	thp_order_fn_t *old_fn;
> +
> +	spin_lock(&thp_ops_lock);
> +	clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags);
> +	old_fn = rcu_replace_pointer(bpf_thp.thp_get_order, NULL,
> +				     lockdep_is_held(&thp_ops_lock));
> +	WARN_ON_ONCE(!old_fn);
> +	spin_unlock(&thp_ops_lock);
> +
> +	synchronize_rcu();
> +}
> +
> +static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
> +{
> +	thp_order_fn_t *old_fn, *new_fn;
> +	struct bpf_thp_ops *old = old_kdata;
> +	struct bpf_thp_ops *ops = kdata;
> +	int ret = 0;
> +
> +	if (!ops || !old)
> +		return -EINVAL;
> +
> +	spin_lock(&thp_ops_lock);
> +	/* The prog has aleady been removed. */
> +	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> +		      &transparent_hugepage_flags)) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	new_fn = rcu_dereference(ops->thp_get_order);
> +	old_fn = rcu_replace_pointer(bpf_thp.thp_get_order, new_fn,
> +				     lockdep_is_held(&thp_ops_lock));
> +	WARN_ON_ONCE(!old_fn || !new_fn);
> +
> +out:
> +	spin_unlock(&thp_ops_lock);
> +	if (!ret)
> +		synchronize_rcu();
> +	return ret;
> +}
> +
> +static int bpf_thp_validate(void *kdata)
> +{
> +	struct bpf_thp_ops *ops = kdata;
> +
> +	if (!ops->thp_get_order) {
> +		pr_err("bpf_thp: required ops isn't implemented\n");
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int bpf_thp_get_order(struct vm_area_struct *vma,
> +			     enum tva_type type,
> +			     unsigned long orders)
> +{
> +	return -1;
> +}
> +
> +static struct bpf_thp_ops __bpf_thp_ops = {
> +	.thp_get_order = (thp_order_fn_t __rcu *)bpf_thp_get_order,
> +};
> +
> +static struct bpf_struct_ops bpf_bpf_thp_ops = {
> +	.verifier_ops = &thp_bpf_verifier_ops,
> +	.init = bpf_thp_init,
> +	.check_member = bpf_thp_check_member,
> +	.init_member = bpf_thp_init_member,
> +	.reg = bpf_thp_reg,
> +	.unreg = bpf_thp_unreg,
> +	.update = bpf_thp_update,
> +	.validate = bpf_thp_validate,
> +	.cfi_stubs = &__bpf_thp_ops,
> +	.owner = THIS_MODULE,
> +	.name = "bpf_thp_ops",
> +};
> +
> +static int __init bpf_thp_ops_init(void)
> +{
> +	int err;
> +
> +	err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
> +	if (err)
> +		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
> +	return err;
> +}
> +late_initcall(bpf_thp_ops_init);


