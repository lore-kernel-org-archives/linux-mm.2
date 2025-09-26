Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9BBCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 14:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9298E000C; Fri, 26 Sep 2025 10:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A218E0001; Fri, 26 Sep 2025 10:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78A78E000C; Fri, 26 Sep 2025 10:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 91D9C8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:50:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16C4D43D53
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:50:07 +0000 (UTC)
X-FDA: 83931686454.06.BF3BF65
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id F30F714000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:50:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZUMwUbF7;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758898205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfW+9l2SULTf/PnftEI2v39jut/0ik4R4e6yFkbRBVU=;
	b=TLXZX4O1uR9B68htMpS4ZoFzqky3orO4Oi0rAVolMb2qNPYWBgMMlntGTQbihnZfwuDg/H
	6cOreCUBEllGMIu8kFIo52T4D7fufE4ndA9USTyJImRBdkfGQWOIPBoA18G226TfMoXcFM
	cLtc0t6qFCTMe2ECkvSLGgBI3UIQNYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758898205; a=rsa-sha256;
	cv=none;
	b=NpkFLVsusFauG8i9SUtoYwVYByYHwfmmYMWPboGhbPwJVyTHW1qBMC1Dcvg/ZQVYxOoH2r
	XhfRs1XnE3iJmkic38ilwPuVxBQzXUadb033EtOYw9c04CBGBdRQsgoQ0+Sy8pCGBy4bru
	80gAU5C67JX7GLjB3Cc+jizYekP9GrU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZUMwUbF7;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ee155e0c08so1348555f8f.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758898203; x=1759503003; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LfW+9l2SULTf/PnftEI2v39jut/0ik4R4e6yFkbRBVU=;
        b=ZUMwUbF7cgJLc8gJhaUoLQO4ZSwUGDTQRUbiAMGfGaRLUFj6zWcHJK1/U1A8dgmSD2
         23ofzdYyuiOxB/NjL6yCqFjHKYevRVCXF0SnzleTYf73BcQV3BNtPTFGdcVITK08zGeh
         wVR9VJIqwAzyt/JqfgbpfVrZpksqbfXEwRtt1138W15exrA4/kMnsyiNxlspUnO7jtDs
         Jv+myPz4Gq9S9SjRt//QP04RoqYrSK8Uz9uAg5LFIkbHHjlyUNeeeyPrMyjqoymfkYZe
         LSju5zrEZoYAPRJXPJEL+04Vg/fWSH79iyLLC3MeOw6i7ot3n1HRzTEyVMI3b51g14SI
         4KTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758898203; x=1759503003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LfW+9l2SULTf/PnftEI2v39jut/0ik4R4e6yFkbRBVU=;
        b=oDdzyqPx4qqN6G4MR3btEZyUXFZ00+ERBkqG7LXwP9iElurX1W6pg0Z6NdC4Rz7nYK
         GWa3DslzmOVVNmnUGhwaIENChuFIT1xGdSOP7ZzkbHZ0nc6OXKPJxrGov0vyALxmi2uA
         kRAkxKVpghZ/+/N9JYwKexTY59hGjROZs4+P5PDkK8HLcKxo/yb2/A+T2WwpyF+DQRMR
         AS9rmztKYEfLLBp0P9W3fOrdHn0rNo/WWBJJh4D23xqUR7TNTVmVnBL6XSjcLPp/nmJ2
         ix36fip/I7hibZREkC/spGxnLn3zA+GVXFJZ5ywbgcWw6yrwgOyybbpx4V+UnT3nLwCV
         sZVg==
X-Forwarded-Encrypted: i=1; AJvYcCVGbTwfHL/+399praezvmMM2GDXyQhEgAOWI1Qke0CWrLR6GgARnpGuHIKl7Qtw5o7YrEqox2lrvA==@kvack.org
X-Gm-Message-State: AOJu0YzMDJcDJWYAUkrvvUpomVl2ze9aW3ThinDAiyqV4kvjcsHfm1jm
	6Uc5R1eFYxGXIk5vJ4CbDXO+yiDzj7Jo2p/DHdqGzr/DhnzXSmEo14LM
X-Gm-Gg: ASbGncvWjKajoAIw/aTZshDjo3q0VwIgDoxiCuJqWQAJorSl1RODZ9AbgqQ4d4GZmkf
	E+8Xa6QXUa2gaUm+yzU/PtPwYjWUcNUpVge1sLNlX8zkpGQZL+C3ragcNl+URLF7ko1XBN31auo
	BELqvCdjHxNeRcc79ZtFbXSyCtHo3uG7LhvYBt0CSOhyvPwtpGxN7+EmzVgqAlIRAHQZyfEkvzh
	IGYG3zXhXNJc+JIicrah7E+WP3fNjY9zAa1gmxkhpkb7hLJsvKLWGYkmQMwvg3qI0su7XxvK64B
	F95EhvN6Yw8WzvnX7QVtyqhnxRJhDK7HKDn7U0U0NGHBxctYrBZOcpaGkGVTHNRXMCxy6kIY/tg
	jWhyVgExmhJmAqJWQsb6Gg3lZnM8w4CHc7fuw0Q8zKAbcF5SIZRAiVWHe5MYcJuhUfgMsl/tfAj
	+1LdMYhTed9VUefQYDkxUyCMFsoDuUwUaVHw==
X-Google-Smtp-Source: AGHT+IGRnafcH0soxzxg3eb9QKsI4SDpey1Eua5rAJCC4vB8nwuidScxQ4sm/5KgvJbQ9NySWjYQ2Q==
X-Received: by 2002:a05:6000:2907:b0:401:41a9:524f with SMTP id ffacd0b85a97d-40e4adce99dmr6532292f8f.29.1758898202610;
        Fri, 26 Sep 2025 07:50:02 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb7203b8asm7487419f8f.9.2025.09.26.07.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 07:50:01 -0700 (PDT)
Message-ID: <146b95bd-e0f0-4e6b-a9fa-5a8f11355268@gmail.com>
Date: Fri, 26 Sep 2025 15:49:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 mm-new 02/12] mm: thp: remove vm_flags parameter from
 khugepaged_enter_vma()
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
 linux-kernel@vger.kernel.org, Yang Shi <shy828301@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
 <20250926093343.1000-3-laoar.shao@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250926093343.1000-3-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qryuqhancf33c4i1rgmmcxofy4n586ws
X-Rspamd-Queue-Id: F30F714000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758898204-203262
X-HE-Meta: U2FsdGVkX1+9zZbvYkAYU/jpo3QekpaVvVo83qJGIoSFaC4dCA/TiKW6yorZHdqC/YMtvNDTz7uOkglW8KCC8vnKDQtja1ITw9T54egR3mt/0erDNpLC9lZqKWg/4Ne3u7NxNn266gI2KfFurKohEJ76dQ5aTXpniFzfS2/SefOzsNd6w5UNrfqAtOYrxXTcbmiM+TOIecIRQ84kX14qKg752w6AxqnJmPotgPIxAsffiXsjiPv/+iRuU63gqNiXDOgd+aItkQNuifoauXyiXdYGyXHHFfde3RcTxjHXePqjzIQZd6c/Z3mujPd+jgJIJF6yKB2yYbdfNePooOvCreuhCNIlG6A20PVcVAmOOu/jYnsuTkjuBlLmSLP0gSHsznLPCr9PSrCzd/8m0NnEzwj/KAjdIKJNFm64DwnMNNGxQJrrz9PxF02Ibi0CbbuzaniMu1OTF05dee9V1NKHd1TylBaJu4AMcUah7Zh6gFNsyZwQEj0eoj+X9oHjVGYDYvCmqeHHIiG5YAbb/aqefCYpledmUyLr2K+W91O683mMTewKccG1ohYRLWM20SDC2s4O+WKD9tMDcChRJCbnuMLd8OBUP8xVM2GYaGxewnrWhq2IqkmNPU/XaUeP/qs1aYeS2YXEpaNVC6PSA79smKt1NjyEcFpRPbHMHY38NuTgDMazZNDinTqC7G6mNeZEgeZ6vL4lnRRKNng/7DfjTgWG1EELchTGmlNvvtQE0SYDacYmjCTJO8lV5zvciAQhRVoOiQEWa8wUUCWEFoEb6PTyF3D6Cc3QXWntYUW2x5uaJUSsT3NZp0MJec0exTsIpeYogbjaMLRr7hUH7JlyMuuCD8zutNr+HOZgd+0atbCaTGBukuedD5LCA96ZwaPMSSx4Op20a52mi+iQ/g3l9ssYa3TP1clGzxWBhRKfIDTkQuiKiuneXhPteHCJRqC0KtF7Nr6+OP47Y4rbNfY
 CqEzwO4M
 iWI8Kx/f7CXF/WgRgNDVPtfWoMbOpAn6KarCvxExttkvqOZymcAovK+52eakFOq9YtTGKXDkcRjHg4VdHFWU6iwt35mwiOiBO9J8RAXtNI9nHA3GtWhaCcT+e/EV4g+m+jjxbnPFK3xU1F5gcXgYkFx3IIoag2Vm7Tkev1ytsGHkGK8DA4mdVrTixQDxL/7/vTlWttZF5qbFJ3LuN2bqSOHgKWHjC2bAHTIThLtqf1bWga+qncdMCHzVKMT+5qkoJ8Zi1RokN+XP0tDDXlutYke87p9K4ismPRt0wxEqmhZXZs1tWE+yBqOxF1mk5Bxi/xb0OUsmwnWCZ0rMUvKaHfBlxNwW1UDx/LOoua2RxOS22l9lEilJebMiRd3wIFNE/BRHo7pcdApmmSrJ+BedUeVNK0nbc+nwbJGfBK9SpmYNRB2RhgjWxXCo6QS6OHBpyshNbHUKRgj86boA5VWD8casbF7d9+RGkaidhaAc3uABXHSGRHOwdbvKwU3xzDLdinvfNLOgli9sTsPt/NYvMwz55S3rWLc/koUL/R6jpAJ2Nj0JnaFI443Hbq8OOo+GsFEagUaJZ6n6KSochnfvGaidMG7GZwjWD80pddgvKfM1R3bC+DoRjds0g3kFhfoMfsME6/XOIwQ9TA8k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/2025 10:33, Yafang Shao wrote:
> The khugepaged_enter_vma() function requires handling in two specific
> scenarios:
> 1. New VMA creation
>   When a new VMA is created, if vma->vm_mm is not present in
>   khugepaged_mm_slot, it must be added. In this case,
>   khugepaged_enter_vma() is called after vma->vm_flags have been set,
>   allowing direct use of the VMA's flags.
> 2. VMA flag modification
>   When vma->vm_flags are modified (particularly when VM_HUGEPAGE is set),
>   the system must recheck whether to add vma->vm_mm to khugepaged_mm_slot.
>   Currently, khugepaged_enter_vma() is called before the flag update, so
>   the call must be relocated to occur after vma->vm_flags have been set.
> 
> Additionally, khugepaged_enter_vma() is invoked in other contexts, such as
> during VMA merging. However, these calls are unnecessary because the
> existing VMA already ensures that vma->vm_mm is registered in
> khugepaged_mm_slot. While removing these redundant calls represents a
> potential optimization, that change should be addressed separately.
> Because VMA merging only occurs when the vm_flags of both VMAs are
> identical (excluding special flags like VM_SOFTDIRTY), we can safely use
> target->vm_flags instead.
> 

The patch looks good to me, but if we are sure that khugepaged_enter_vma
is not needed in VMA merging case, we should remove it in this patch itself.
If the reason we are removing what flags are being considered when calling
khugepaged_enter_vma in VMA merging case is because the calls are unnecessary,
then we should just remove the calls and not modify them
(if its safe and functionally correct :))

> After this change, we can further remove vm_flags parameter from
> thp_vma_allowable_order(). That will be handled in a followup patch.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Yang Shi <shy828301@gmail.com>
> ---
>  include/linux/khugepaged.h |  6 ++----
>  mm/huge_memory.c           |  2 +-
>  mm/khugepaged.c            | 11 ++---------
>  mm/madvise.c               |  7 +++++++
>  mm/vma.c                   |  6 +++---
>  5 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index f14680cd9854..b30814d3d665 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -13,8 +13,7 @@ extern void khugepaged_destroy(void);
>  extern int start_stop_khugepaged(void);
>  extern void __khugepaged_enter(struct mm_struct *mm);
>  extern void __khugepaged_exit(struct mm_struct *mm);
> -extern void khugepaged_enter_vma(struct vm_area_struct *vma,
> -				 vm_flags_t vm_flags);
> +extern void khugepaged_enter_vma(struct vm_area_struct *vma);
>  extern void khugepaged_enter_mm(struct mm_struct *mm);
>  extern void khugepaged_min_free_kbytes_update(void);
>  extern bool current_is_khugepaged(void);
> @@ -39,8 +38,7 @@ static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm
>  static inline void khugepaged_exit(struct mm_struct *mm)
>  {
>  }
> -static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
> -					vm_flags_t vm_flags)
> +static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
>  {
>  }
>  static inline void khugepaged_enter_mm(struct mm_struct *mm)
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..ac6601f30e65 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1346,7 +1346,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>  	ret = vmf_anon_prepare(vmf);
>  	if (ret)
>  		return ret;
> -	khugepaged_enter_vma(vma, vma->vm_flags);
> +	khugepaged_enter_vma(vma);
>  
>  	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>  			!mm_forbids_zeropage(vma->vm_mm) &&
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f47ac8c19447..04121ae7d18d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -353,12 +353,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  #endif
>  		*vm_flags &= ~VM_NOHUGEPAGE;
>  		*vm_flags |= VM_HUGEPAGE;
> -		/*
> -		 * If the vma become good for khugepaged to scan,
> -		 * register it here without waiting a page fault that
> -		 * may not happen any time soon.
> -		 */
> -		khugepaged_enter_vma(vma, *vm_flags);
>  		break;
>  	case MADV_NOHUGEPAGE:
>  		*vm_flags &= ~VM_HUGEPAGE;
> @@ -467,10 +461,9 @@ void khugepaged_enter_mm(struct mm_struct *mm)
>  	__khugepaged_enter(mm);
>  }
>  
> -void khugepaged_enter_vma(struct vm_area_struct *vma,
> -			  vm_flags_t vm_flags)
> +void khugepaged_enter_vma(struct vm_area_struct *vma)
>  {
> -	if (!thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
>  		return;
>  
>  	khugepaged_enter_mm(vma->vm_mm);
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 35ed4ab0d7c5..ab8b5d47badb 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1425,6 +1425,13 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
>  	VM_WARN_ON_ONCE(madv_behavior->lock_mode != MADVISE_MMAP_WRITE_LOCK);
>  
>  	error = madvise_update_vma(new_flags, madv_behavior);
> +	/*
> +	 * If the vma become good for khugepaged to scan,
> +	 * register it here without waiting a page fault that
> +	 * may not happen any time soon.
> +	 */
> +	if (!error && new_flags & VM_HUGEPAGE)
> +		khugepaged_enter_mm(vma->vm_mm);
>  out:
>  	/*
>  	 * madvise() returns EAGAIN if kernel resources, such as
> diff --git a/mm/vma.c b/mm/vma.c
> index a1ec405bda25..6a548b0d64cd 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -973,7 +973,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  	if (err || commit_merge(vmg))
>  		goto abort;
>  
> -	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> +	khugepaged_enter_vma(vmg->target);
>  	vmg->state = VMA_MERGE_SUCCESS;
>  	return vmg->target;
>  
> @@ -1093,7 +1093,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  	 * following VMA if we have VMAs on both sides.
>  	 */
>  	if (vmg->target && !vma_expand(vmg)) {
> -		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> +		khugepaged_enter_vma(vmg->target);
>  		vmg->state = VMA_MERGE_SUCCESS;
>  		return vmg->target;
>  	}
> @@ -2520,7 +2520,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
>  	 * call covers the non-merge case.
>  	 */
>  	if (!vma_is_anonymous(vma))
> -		khugepaged_enter_vma(vma, map->vm_flags);
> +		khugepaged_enter_vma(vma);
>  	*vmap = vma;
>  	return 0;
>  


