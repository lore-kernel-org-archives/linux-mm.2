Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389AFCAC5BC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 14:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D218E0007; Fri, 26 Sep 2025 10:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD968E0001; Fri, 26 Sep 2025 10:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC4F8E0007; Fri, 26 Sep 2025 10:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 472C68E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:11:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEE8F11AB13
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:11:47 +0000 (UTC)
X-FDA: 83931589854.02.79AE78C
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id C5F0B4000A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:11:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=np2puoCs;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758895905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ny7pIQ2SCuYpPr5sAoZMtmx+LX6//dYVYgLJ9SYLcgQ=;
	b=6kahh0T34YnDvyR6waQoSB+8eAa5wd282Vo4zH5hgZ9Q1iTpbp1ByEwtKMIju4OGkerXM4
	QXBJEYsQ88rggFQe5j7GGpE7QENbqiU8l5rtx9Ht0OUvTYvILb6+XzuUv6nyqe4dtlmDfw
	id7pPOpSOum0bhb2KUtI7zwZLqQTu7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758895905; a=rsa-sha256;
	cv=none;
	b=Tl7HIh2lF8CT3GdY20jp/BuqIp0HECCyttUTTGqsogUllCSjkXkV6bZGWH+1siupxU/Nfn
	Xp5x3NY7cb0khJZxDB69rv/IypcyCiVjCgp/SseXUFbbeHAzEPSEsHOBiBXlfubcIce2+6
	PBl4G0dwpP5/k5gRTonbFhkyQOWXs1w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=np2puoCs;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46b303f755aso20051385e9.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758895904; x=1759500704; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ny7pIQ2SCuYpPr5sAoZMtmx+LX6//dYVYgLJ9SYLcgQ=;
        b=np2puoCsC2/Nn5RI/jDUhrREPY4d03BgUfR2bRdSexBJLf4K7gMdBFMPxQyosYrlSE
         qPp6Vq5qS1ueKx5Yx7z45Ap4Vw5vawJeaQO+B6mKvFemsQWmt/vuN44pTTUttCZ2NqFv
         q3tnB214PS+oItpFkOh0k/SR0ILiuFltU1Z+dQSOXxMa1m4kE328uK/1OSmangFy9/xn
         UKmv+PvCrmuFWphLPR83ilnFlGoe9+VxRVi95BF0MvbL5/NRnFkc2nNg06bm4SJs//Lc
         wT6xoy29UVwzBY0obc4UfYy0vj3ZoXMDtvjg1ouTyQjaOnetUOUg9T114NDWpcpvnIoU
         JIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758895904; x=1759500704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ny7pIQ2SCuYpPr5sAoZMtmx+LX6//dYVYgLJ9SYLcgQ=;
        b=tuKE/t4fL4Md/eUSHloFnjepgkQ8no205n+aOVMLio5VSauXMoUkFgpuu2Mndmrkm9
         TtOib2W4f9hGTK2dpdw2yeGmhu/YEGZ55pn0IrJ3KIM7USUk3U2GEQTaY7d8PTQb6EVy
         CeIRSOOwF6Y0bY0qCM3vC+FI6CXx44Fp8SAY7zTVRPA5YgCox/gr9A+P/oLmoaqIn1Jq
         a8DkCQdGM1UkseBsVXMYtEScRD3+EmUoo8qeDk6vltMUzQomT6O9Jp2TN5lz3V/ikvfq
         tTmTTlFPDgn/VEF6p9Qm6IpRFlPGmSJ57G1GpmVy+U5KBFezfih6wRDDrno9N4T5DHsr
         X2rA==
X-Forwarded-Encrypted: i=1; AJvYcCVDFLn42y22a7l5Fkza0gIkRi4zWzOuHPoMg7HvQqb7bPFetUmVEYZRnq0VcalO5CbeEnxdXqVXMg==@kvack.org
X-Gm-Message-State: AOJu0YwD67TJen11avdVHQBt1AdBKXLbvXvR/slo6aJpp15kGSnV8IIV
	HrXp4absVswGW0tZm4Lfwb7N+LhGPPCPA167a4f4gBBgUTbw26LjbpQJ
X-Gm-Gg: ASbGncsFDfLM0AlXAaVjPitW9GhYXyNw9ATuU2mXggiX111/fCOZPXyoo7EzoTkKeKv
	CxK1V/juJ6BiZMd4xG/pTi7qcYz3T4k/OYv1MWOzXHus+zrUCcrmE1+jXKWNJuxs8qgEbQJ8kcr
	yigAJJG099vdd+WNBntCtV1Oz7cao47v7mdvgbMnoNY3rrqyXg3z/ScoFAOw2lm9bkCro9ILpMl
	ACVqCPl78izIrA1XV12gnsOAlMjYbc8Bx1KpRkrzjfNpnVjIrsVZEamd0C9OhgL5Aq3HxrUWGCn
	0wq0obZVzNN1qi2siGG/ToQV7OwEudLcQoEndeoR9RQUdb7E2+MuaUEsZxDBMXaKjxDZlH6LbVE
	uZrUKKXooXXOR40g/huTkIFnw2oricVwcSB2gC2+r21uaMdFBTAmwgjlvYfXe3Na1OTeuO+fEFx
	bclZkd46SMbvsZCZ5G+rlB8xizGMoBWcFaqg==
X-Google-Smtp-Source: AGHT+IGIsygixbycwSxGEYYSjqdX4hw6Wrb2gEHvzCCx3um4Q8sxCxU/06IukXa1VlsWWUmFmo66KA==
X-Received: by 2002:a05:600c:4fca:b0:46d:45e:350a with SMTP id 5b1f17b1804b1-46e329fb93bmr92609295e9.17.1758895903786;
        Fri, 26 Sep 2025 07:11:43 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32bd6360sm39873825e9.1.2025.09.26.07.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 07:11:43 -0700 (PDT)
Message-ID: <34a9440f-b0c4-4f76-a2ac-f88b54c2242e@gmail.com>
Date: Fri, 26 Sep 2025 15:11:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 mm-new 01/12] mm: thp: remove disabled task from
 khugepaged_mm_slot
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
 <20250926093343.1000-2-laoar.shao@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250926093343.1000-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C5F0B4000A
X-Stat-Signature: horhdhct3z7bqiqaf7hkd6t7mynoejef
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758895905-607471
X-HE-Meta: U2FsdGVkX19wGf9ZJC98Rg7p3YS5K7VgJ/lv0eZa4mzLgt7N+9OCDun6i71pprR8pCFaOGx7LcmIrK6E5lGkAqKqKuUjZxLagZkWqHr0swklXr166sOaert9xNP92NGW0XproOMlunjvtHx2+69N+dfSzqI/YCT2A3rFsIF3uywCL5lJ7Vt0eposTedXs4geqa2T3p4mbRgGBxC9LifAAlNSlJSO0CwZpT4iJW3wGoD/Z1npZLoT7ezz4RJj+/9qIF1QH17YRJ1GLNc+xtyQL/4R5gdNaEkNmjBoz8WkLlrMqmDnRYRD0rmb8iZIhC4VIbIPK3CLey2Wo70PqJbpXDx3L7ihNw2cPPBRAJg5G6lK6KKm0IBzeGJv18DEWsAR6Q7PKXsXnfaEQJ49F99xiZ6LbTgCPWCIOu32NTX6qNrBWZONEuZCsdbYE2uAqlwzjHNMPUk1AW8DEZr/B+AsKVS5Edi1xqQrf+1nF+2BCvyfcInneyRjbEuUYaPqEi4SSnKWkuj3Ng6g+aNZXj+8rBNsUBL7HVyskvscngylmPxf5YaKUBNYo10MrkWgXqKXd5FvvsMO/Hy2bxqOh81vWUIByOYblHhtDfmZxyyjFrnNj1RrAQPHko0wNZLoR2A2XCfcY/6nwk+wqk4RtGdc+gPI5WAQpJ2jYi2vh4k53uII5sLXFuHOVfOe7TnnAfY7NK9hrW6f4UUpkqYyf3fIhkvrsMy7lDj5LpHlgRlgMd72js4wy/KqVv3OTqlrTGst1pqTVY8J8IGDRp1zkZPS6006RiHvhEfaadkYbL4e07eI8oJvVyAai4D5q4ZrPr4a3hDiGb5wCZmXGVFDnJt/1dswCXl32WHXCmVK3aEYGtRDzO8s4OKdU28ss4CXj1FZknXlmpOkdK6CJZ0e45cBsYzwA6URitfJmfKUUYo0vs+WRrG785IkNsukjwFgwXsIc/Q4q3f/ubGMGmYns7i
 SDWjmQld
 i0VtkFE2SNIHRrSX915XT6UBIXKY7dkBBJYci+UPUwe/4UaWgWzhzP1TdbmIAPfcEUD2QfIN395WHvnVdZbQSSRCjNJkw1RRomAL2QECGmdBGA5Of8BM63n7q9CGG8ihusrI3QTfErOErJMPL6ngTqNi4DHfDvU9ab+4jmny6/w261eg8gvEOCt5FVGmDpmV+WPAWviPXHojn9IquBACD0I7Ui5HoDY1mYvTcpgbQCDdox4wKUlysQBTqia1ikj1xkeiwskj+cWvNwmMt0Cu+fiew5b5x9XWEYs508DmiwdwYiWs5TQDMSgzk9HuGKOCTJqPI9/X10a6/i73OIqdwz6S6oYADOOegp/FbEgUYpEnQoAYg24RFOw4ziCpugEsPJ7fKKziw6PuMS7ln4HIrHcu4znWauPXYIcgXcxcayp1e5+1oXN+JMEaKqvLkdbWBVCy5PqtWBGKeEVdPwcleVD8Trsve+57wXkk9R3PjomHg4avC9PZNDxp0gpvatqW05rFQNI4apqBQWIfYW1oyCscdyZ6swLMGLXgxq6QdXtcXT7XsgrL7LmRAdlijDPBHNFSlrefFFHF/uAi154q+gfKUUmyvE2xfzukqOGILxM8IP4/k7D2tghJNdc5PK7/81Lp8K/vj1CKxal0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/2025 10:33, Yafang Shao wrote:
> Since a task with MMF_DISABLE_THP_COMPLETELY cannot use THP, remove it from
> the khugepaged_mm_slot to stop khugepaged from processing it.
> 
> After this change, the following semantic relationship always holds:
> 
>   MMF_VM_HUGEPAGE is set     == task is in khugepaged mm_slot
>   MMF_VM_HUGEPAGE is not set == task is not in khugepaged mm_slot
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> ---
>  include/linux/khugepaged.h |  4 ++++
>  kernel/sys.c               |  7 ++++--
>  mm/khugepaged.c            | 49 ++++++++++++++++++++------------------
>  3 files changed, 35 insertions(+), 25 deletions(-)
> 


Hi Yafang,

Thanks for the patch! Sorry wasnt able to review the previous revisions.

I think it would be good to separate this patch out of the series?
It would make the review of this series shorter and this patch can be merged independently.

In the commit message, we also need to write explicitly that when prctl
PR_SET_THP_DISABLE is cleared, the mm is added back for khugepaged to consider.

Could you also mention in the commit message why the BUG was turned into WARN?

Thanks!

> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index eb1946a70cff..f14680cd9854 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -15,6 +15,7 @@ extern void __khugepaged_enter(struct mm_struct *mm);
>  extern void __khugepaged_exit(struct mm_struct *mm);
>  extern void khugepaged_enter_vma(struct vm_area_struct *vma,
>  				 vm_flags_t vm_flags);
> +extern void khugepaged_enter_mm(struct mm_struct *mm);
>  extern void khugepaged_min_free_kbytes_update(void);
>  extern bool current_is_khugepaged(void);
>  extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> @@ -42,6 +43,9 @@ static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
>  					vm_flags_t vm_flags)
>  {
>  }
> +static inline void khugepaged_enter_mm(struct mm_struct *mm)
> +{
> +}
>  static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
>  					  unsigned long addr, bool install_pmd)
>  {
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a46d9b75880b..2c445bf44ce3 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -8,6 +8,7 @@
>  #include <linux/export.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
> +#include <linux/khugepaged.h>
>  #include <linux/utsname.h>
>  #include <linux/mman.h>
>  #include <linux/reboot.h>
> @@ -2479,7 +2480,7 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>  	/* Flags are only allowed when disabling. */
>  	if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>  		return -EINVAL;
> -	if (mmap_write_lock_killable(current->mm))
> +	if (mmap_write_lock_killable(mm))
>  		return -EINTR;
>  	if (thp_disable) {
>  		if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
> @@ -2493,7 +2494,9 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>  		mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>  		mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>  	}
> -	mmap_write_unlock(current->mm);
> +
> +	khugepaged_enter_mm(mm);
> +	mmap_write_unlock(mm);
>  	return 0;
>  }
>  
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7ab2d1a42df3..f47ac8c19447 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -396,15 +396,10 @@ void __init khugepaged_destroy(void)
>  	kmem_cache_destroy(mm_slot_cache);
>  }
>  
> -static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> -{
> -	return atomic_read(&mm->mm_users) == 0;
> -}
> -
>  static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
>  {
> -	return hpage_collapse_test_exit(mm) ||
> -		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> +	return !atomic_read(&mm->mm_users) ||			/* exit */
> +		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);  /* disable */
>  }
>  
>  static bool hugepage_pmd_enabled(void)
> @@ -437,7 +432,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>  	int wakeup;
>  
>  	/* __khugepaged_exit() must not run from under us */
> -	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +	VM_WARN_ON_ONCE(hpage_collapse_test_exit_or_disable(mm));
>  	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>  		return;
>  
> @@ -460,14 +455,25 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		wake_up_interruptible(&khugepaged_wait);
>  }
>  
> +void khugepaged_enter_mm(struct mm_struct *mm)
> +{
> +	if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
> +		return;
> +	if (mm_flags_test(MMF_VM_HUGEPAGE, mm))
> +		return;
> +	if (!hugepage_pmd_enabled())
> +		return;
> +
> +	__khugepaged_enter(mm);
> +}
> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
> -	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> -	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> -			__khugepaged_enter(vma->vm_mm);
> -	}
> +	if (!thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		return;
> +
> +	khugepaged_enter_mm(vma->vm_mm);
>  }
>  
>  void __khugepaged_exit(struct mm_struct *mm)
> @@ -491,7 +497,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	} else if (slot) {
>  		/*
>  		 * This is required to serialize against
> -		 * hpage_collapse_test_exit() (which is guaranteed to run
> +		 * hpage_collapse_test_exit_or_disable() (which is guaranteed to run
>  		 * under mmap sem read mode). Stop here (after we return all
>  		 * pagetables will be destroyed) until khugepaged has finished
>  		 * working on the pagetables under the mmap_lock.
> @@ -1429,16 +1435,13 @@ static void collect_mm_slot(struct mm_slot *slot)
>  
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (hpage_collapse_test_exit_or_disable(mm)) {
>  		/* free mm_slot */
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
>  
> -		/*
> -		 * Not strictly needed because the mm exited already.
> -		 *
> -		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> -		 */
> +		/* If the mm is disabled, this flag must be cleared. */
> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>  
>  		/* khugepaged_mm_lock actually not necessary for the below */
>  		mm_slot_free(mm_slot_cache, slot);
> @@ -1749,7 +1752,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
>  			continue;
>  
> -		if (hpage_collapse_test_exit(mm))
> +		if (hpage_collapse_test_exit_or_disable(mm))
>  			continue;
>  		/*
>  		 * When a vma is registered with uffd-wp, we cannot recycle
> @@ -2500,9 +2503,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>  	/*
>  	 * Release the current mm_slot if this mm is about to die, or
> -	 * if we scanned all vmas of this mm.
> +	 * if we scanned all vmas of this mm, or if this mm is disabled.
>  	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>  		/*
>  		 * Make sure that if mm_users is reaching zero while
>  		 * khugepaged runs here, khugepaged_exit will find


