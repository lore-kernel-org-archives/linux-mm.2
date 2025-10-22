Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD4ADCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E508E000F; Wed, 22 Oct 2025 14:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066418E0002; Wed, 22 Oct 2025 14:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96CB8E000F; Wed, 22 Oct 2025 14:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8B618E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:35:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DDB913BF03
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:35:05 +0000 (UTC)
X-FDA: 84026602170.23.D91DF1A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 129C420004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:35:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YUEliZag;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YqHMSkF5T/6MQvDyGjDyvV6SwZ5EdSH42dFss7fcAw=;
	b=7UpnmP4ansXEZ2DHhPoBkEujKGS0mgQRa0H5Y5I9rE3jY2q+76hWUBXsWqQY2/mQw59bQG
	j+hYvDvlPZKyQ94vHRtcmllwZe6UtrYO4cdAbjbxHZGiardQ35P9oQ/p3FJimAssBuPwpW
	6jaBEmBsfBW6j+I7LJNv1l5xJO19a/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158103; a=rsa-sha256;
	cv=none;
	b=rJ4hsFjcKAWSKTdwkLTVPWvVPOdpRCLiPGErLlY3B2JJ1nFpOeRYjKSdAyfnZh/cQ/EnmU
	X9slfgdVXbWt6pq5chvd90RHwuM6YCqTqwjMQmUtE3uE8HrwUOMYBahEAzj/7poYVYk0ag
	KdsJPgA7WI0bxj+WWpjVG7Z3MFLCTiQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YUEliZag;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9YqHMSkF5T/6MQvDyGjDyvV6SwZ5EdSH42dFss7fcAw=;
	b=YUEliZagU6JTLdIc2t5uXB1J2kDpSmntJa8IYb9CKgxqZfO4v48Ep3m0KbZFgc4dS+wxYg
	v6dqzHc0Q1pWkdy4tkH1FqjeLD0gxo1enMUiJM3c39JsCDjPkehrWM9/IWhBWZT9VAUZEB
	12U5yta2frmZWRF6n6zLkVnKAN8fg+M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-HKDvtQM4NBmlQ1_Ch0AR7g-1; Wed, 22 Oct 2025 14:34:59 -0400
X-MC-Unique: HKDvtQM4NBmlQ1_Ch0AR7g-1
X-Mimecast-MFC-AGG-ID: HKDvtQM4NBmlQ1_Ch0AR7g_1761158098
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-475c422fd70so8919995e9.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761158098; x=1761762898;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9YqHMSkF5T/6MQvDyGjDyvV6SwZ5EdSH42dFss7fcAw=;
        b=cVg5vZDxWugBwDV2OgV6nKcxf5KDnlHf0+4Zw6dfFTWfSdUzu8qwjk4TB9KTli7xkC
         W3YQNQJ8kuiW6py+jxbLEeUIVnaDHvnqpNIFlYO6mU7bF52RVFsjRoN6TQ8C3OEnhD56
         9ed6+PRtOzycIOdHXHQiYtmYX/1miO4tyHbdxybKaQaP5y9QIdgtd4U0ouLJfkkJMLtO
         5G1SdwjTvDyIEdmo26XQ7gBtVCWj1PJX8Ba1blmtVp5dsWNp4Kqn0koB0pkjiMQr98Ox
         2UC48c9S+VLpzbxXdf0ugJa+K/+E1qYEf/G8k7nXgsRZgrhm43Yd/aJP+5cChRLxojgc
         Ly6A==
X-Forwarded-Encrypted: i=1; AJvYcCWhm3Rki3NcEj6KF3FcdQddI2/mVT7PHiEs8fiM1lFek+fa/NbFrm8/C4GS9s5QXT9gARfbp+kv8w==@kvack.org
X-Gm-Message-State: AOJu0YxAoKDjJyMxgX9qOtAfNZHU/6M+9EBmoKJwrz+D/fK05uHzKNvP
	uqyrIi8kQ863Fo8b3PI/tWzIk4Hnt46OVySO2iHTeDKPt+j/xNFKP409zJ9gv0nWSUZJmSEc7SM
	smgsAvH2c+c88hkIGqrgOyRnrVW79TO8ZH3mx7MmQ64tF58n25M2v
X-Gm-Gg: ASbGncvo8tZPD68VLxwRzrdar0j5D6W0lgmU01PnN/cTuYHGG2aDnGaWlmlYcIe6VlT
	x3ft/WyOkHmLZs/+vzoL1uHzT9bhDXtk6oCi3REmNtH0jl3d0JeWN6q/QhEKlkIE1MBYCdXWzdT
	IXik+Vy/pgRUl1sbN+M5ug4fcnSJbiTV9IaRNs8KgoQhcwpQDVFwNl85emE8cQ5d5wLlOP7t1d5
	Ylq3bueUGDe+piCq4NkdCubxfVf42D5icbP75jYvtU0H2TPqn8mrTht53Zvqf56zAdwbRgnyfnx
	BYASDNakJHfgFAwZsVQZCaMc2g4e4SWlQ8LOTAQhMbCsdz7xmSsA1nECDTx5/ak6ey9yN+mfJrB
	gfqNu8q9lPFWvvMZQrNMeyjfBHqjBBx2aNVdJgN0t0Z3OnNgA2ebWvef7Maf8SvsvZfoM66mGwc
	x3QeIiuEX8qLaNtAqtNVMhpbLc+kk=
X-Received: by 2002:a05:600c:5026:b0:470:bcc4:b07c with SMTP id 5b1f17b1804b1-47117925d38mr175826165e9.37.1761158097763;
        Wed, 22 Oct 2025 11:34:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0oQ3lTCB2x2oM5MOeaEhX/tcQ15X6pp7tPbV7z1c7xivg9xS8IzzR5hA20GTIyMNevbuRow==
X-Received: by 2002:a05:600c:5026:b0:470:bcc4:b07c with SMTP id 5b1f17b1804b1-47117925d38mr175825825e9.37.1761158097325;
        Wed, 22 Oct 2025 11:34:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428e9b2sm56333455e9.5.2025.10.22.11.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 11:34:56 -0700 (PDT)
Message-ID: <dabf557c-d83b-4edb-8cf3-1ab8581e5406@redhat.com>
Date: Wed, 22 Oct 2025 20:34:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/8] mm: Introduce deferred freeing for kernel page
 tables
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-8-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251022082635.2462433-8-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Avzis0Qf4b5EzKDaRU1geihIF2MABn8O2K9h0GXN5hU_1761158098
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: zbiggjy484adrmit6ygj7t88x8z3wdhz
X-Rspam-User: 
X-Rspamd-Queue-Id: 129C420004
X-HE-Tag: 1761158102-291774
X-HE-Meta: U2FsdGVkX1+YpYeZQo7bVu0mQSkmmQaoNi1sMyGtZlh+lhUfafAyFVbVtaxPGol/C/1CLRmzW/gxrCJy1JvqLTgll7IaiU2EfWVnruM7sQAIWQBWGy2Q1N4QbNB+3CAjeBIdXnzEsr5E4Ipb2ZDVpVBqWajVpaUDO2+fPL1mUrWrHxPM6fsuBvP/pm3F7iJJhysQrCD9XHHD5I0/Sgl0HGqIaFLwqybEiLQN6vVijaQpEA4aKASKoKUhj++GgyiMg4ZspRYOMqz5JPZurKBk8Gafet+u0zTsGqi6Z411Z1tAApKlD1BFIaBSQzDOVPRXAQhT0YinCnTOmjgVCFI0cGlFAdp9EYjYX04Mmoe2aJK6oMo+H+DOJ8IB5orpKOTGnJmmSSLdvULBQoTfjlQHU6LG05o7Ce5ECabe2jG1g2ZYm2OzPdVuVamxcxkkWnjTa1pozuadzFOZ/vsBD/DcY8aveGwfKvmbmPW0JS+s0TFLnkvB7u66DJRphHEtPOdf3GYSalnYABE6Me4VwWwSsIm+dj8nATWk4AQY5KE3xc20B1zNC/YukYZbaDrSOotVIyaZCfsZXuBXUv92QjXXDl0liZnq1DRddsbvqCRs8myQ/hsyKI2ccXiktQv0SfW+/54f98pqo5pX/kLn020QuYDUeqdwH35a59bnzJkc+MWESd32gexdXUPeBpBBxSJ0iFLi8jjt0q8EwWOAH5IsswMU6G7nQQwdIZ0Qw/2q54o5wp3p7CUokvLdVOa8RL19UrL9ZKdZXF23TeH4dWL/PyLQxEYZOxhZDAmI1ewJNCogMZBe7Eg6QRiHqwQv9JrR7H0a20qDHlAVVyDRDLth18uLCJvEspEkCHuI96P7CsRE6FK+g6j50d8sy8rjBOo7uJBq88NjAVXvKgHOiC2MlZBpEZKasXhSFumN6hALWTB0IzJpNHkHbznJnR69muvEgF+pXYw6ibuUQxO3+v5
 /Mx6BIRK
 lv127EK3mZU8CYCPpR9XJKO/pqMXnl1LdaW6yvjYT8ueNFiS4dPs9pdsPZWbVxpzR2f6vKsiLV8uxt2udbN21Uib5DxDrx6CIcRVOhTaEm1NWiFkAx3INyx6ohTT1a8mTgzbY3OI+on7pS0jf7yn7fbs94LyK991v3LJOC7ajzFINtKpgMRz8j9LQHlOj6jKpUgQ/KiqX7LF32fbWGO/likMK0JNZyMLVPvkfm0GtQc8NI7wLPss9HQhnXBOX81Z78tAeWkYEyOYKod+2pOqTApQQVsdc+i5XTJOVz8lEZNUPf/7PvZDeykdGnMr6kkX7uccFtlVlsfSQtvUZRkqN+i51mYSmTVsSvq8K46g6jfzFPXfJa3OZc4QswxcS6s80AqpXaiTO4SJtVFHrQJ5MwavpXaWfGqdhHdLuTbdc24HT/MHn5BSzXYVNzwccNDunz0HadNRkyAq8Ffn/KVCzDyFXE5d4XWWIvQjwcr1RmO9M2O+toZkrSZnQ+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 10:26, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This introduces a conditional asynchronous mechanism, enabled by
> CONFIG_ASYNC_KERNEL_PGTABLE_FREE. When enabled, this mechanism defers the
> freeing of pages that are used as page tables for kernel address mappings.
> These pages are now queued to a work struct instead of being freed
> immediately.
> 
> This deferred freeing allows for batch-freeing of page tables, providing
> a safe context for performing a single expensive operation (TLB flush)
> for a batch of kernel page tables instead of performing that expensive
> operation for each page table.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   mm/Kconfig           |  3 +++
>   include/linux/mm.h   | 16 +++++++++++++---
>   mm/pgtable-generic.c | 37 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 53 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717..a83df9934acd 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -908,6 +908,9 @@ config PAGE_MAPCOUNT
>   config PGTABLE_HAS_HUGE_LEAVES
>   	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>   
> +config ASYNC_KERNEL_PGTABLE_FREE
> +	def_bool n
> +
>   # TODO: Allow to be enabled without THP
>   config ARCH_SUPPORTS_HUGE_PFNMAP
>   	def_bool n
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 52ae551d0eb4..d521abd33164 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3031,6 +3031,14 @@ static inline void __pagetable_free(struct ptdesc *pt)
>   	__free_pages(page, compound_order(page));
>   }
>   
> +#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> +void pagetable_free_kernel(struct ptdesc *pt);
> +#else
> +static inline void pagetable_free_kernel(struct ptdesc *pt)
> +{
> +	__pagetable_free(pt);
> +}
> +#endif
>   /**
>    * pagetable_free - Free pagetables
>    * @pt:	The page table descriptor
> @@ -3040,10 +3048,12 @@ static inline void __pagetable_free(struct ptdesc *pt)
>    */
>   static inline void pagetable_free(struct ptdesc *pt)
>   {
> -	if (ptdesc_test_kernel(pt))
> +	if (ptdesc_test_kernel(pt)) {
>   		ptdesc_clear_kernel(pt);
> -
> -	__pagetable_free(pt);
> +		pagetable_free_kernel(pt);
> +	} else {
> +		__pagetable_free(pt);
> +	}
>   }
>   
>   #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 567e2d084071..1c7caa8ef164 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -406,3 +406,40 @@ pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
>   	pte_unmap_unlock(pte, ptl);
>   	goto again;
>   }
> +
> +#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> +static void kernel_pgtable_work_func(struct work_struct *work);
> +
> +static struct {
> +	struct list_head list;
> +	/* protect above ptdesc lists */
> +	spinlock_t lock;
> +	struct work_struct work;
> +} kernel_pgtable_work = {
> +	.list = LIST_HEAD_INIT(kernel_pgtable_work.list),
> +	.lock = __SPIN_LOCK_UNLOCKED(kernel_pgtable_work.lock),
> +	.work = __WORK_INITIALIZER(kernel_pgtable_work.work, kernel_pgtable_work_func),
> +};
> +
> +static void kernel_pgtable_work_func(struct work_struct *work)
> +{
> +	struct ptdesc *pt, *next;
> +	LIST_HEAD(page_list);
> +
> +	spin_lock(&kernel_pgtable_work.lock);
> +	list_splice_tail_init(&kernel_pgtable_work.list, &page_list);
> +	spin_unlock(&kernel_pgtable_work.lock);
> +
> +	list_for_each_entry_safe(pt, next, &page_list, pt_list)
> +		__pagetable_free(pt);
> +}
> +
> +void pagetable_free_kernel(struct ptdesc *pt)
> +{
> +	spin_lock(&kernel_pgtable_work.lock);
> +	list_add(&pt->pt_list, &kernel_pgtable_work.list);
> +	spin_unlock(&kernel_pgtable_work.lock);
> +
> +	schedule_work(&kernel_pgtable_work.work);
> +}
> +#endif

Acked-by: David Hildenbrand <david@redhat.com>

I was briefly wondering whether the pages can get stuck in there 
sufficiently long that we would want to wire up the shrinker to say 
"OOM, hold your horses, we can still free something here".

But I'd assume the workqueue will get scheduled in a reasonable 
timeframe either so this is not a concern?

-- 
Cheers

David / dhildenb


