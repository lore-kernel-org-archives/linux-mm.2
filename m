Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AFAC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 02:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262706B007B; Thu, 24 Jul 2025 22:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2136C6B0088; Thu, 24 Jul 2025 22:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A0D6B0089; Thu, 24 Jul 2025 22:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 008A76B007B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:38:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A765A1D8951
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:38:34 +0000 (UTC)
X-FDA: 83701228548.17.FF4E71A
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3EAFE180002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:38:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g8XlYM+D;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753411112; a=rsa-sha256;
	cv=none;
	b=hlvzeSZHwxPRbN7bU1sBaF7xKKFLc4CiSrnFg3MLhAZffiVu9OepBKDsPD2dQeWxE/JfOG
	FXCHqWJ33DX1Mzx3Ev87lNnoJI/Bx3/wfok52e4bT75hVFt/yod4/M34cFFgCR8utXeh4t
	Gng7j5vGX4A8vhL6apafqafV+AQHbsw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g8XlYM+D;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753411112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HN0s+hdKn5rU9FyZkmT5ogrtEb0lIbKzVoa6+/K/tFg=;
	b=ItdUt8ByAYhfhMF+Atrh3gLD2F3+S658fLAGAK6Vi1McSQpTXN51zYQiW1pNPOG2G4CTY/
	/ud1xjIUFY69ZvT8lQkmL8tQNXiJZeNmhaykX3pSitPChDwN5Q0J2ntHxDc9dZDPWFs+7K
	oT/UE7l+eLdfnsWmQsTpoan4RGXtM1A=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753411108; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=HN0s+hdKn5rU9FyZkmT5ogrtEb0lIbKzVoa6+/K/tFg=;
	b=g8XlYM+DJtGvmyPQ4elgzOINDqvFP/7rfsSzolcpfl756AHsMQWAEEB9n49hItoFigM038J10n0XUGEtXJfCe5ZKScYpzpyNo0EcvozfeJK1dHjEcmjkOhbiiBk22mDnhOIqrm8LQnHni4ZIt4zoCP9CT2d+TxiBfNG3kUcx7Lo=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjuuTqp_1753411106 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 25 Jul 2025 10:38:26 +0800
Message-ID: <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com>
Date: Fri, 25 Jul 2025 10:38:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: regression - mm: shmem: add large folio support for tmpfs affect
 GPU performance.
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>
Cc: Patryk Kowalczyk <patryk@kowalczyk.ws>, da.gomez@samsung.com,
 baohua@kernel.org, wangkefeng.wang@huawei.com, ioworker0@gmail.com,
 willy@infradead.org, ryan.roberts@arm.com, akpm@linux-foundation.org,
 eero.t.tamminen@intel.com, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?=
 <ville.syrjala@linux.intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <CAJCW39JCDX6_S2Ojt1HMmX-h_qAKm2eBRzxX5kOHNJz60Zu=vw@mail.gmail.com>
 <d5c6ac93-1af0-4093-afea-94a29a387903@redhat.com>
 <63b69425-2fd1-2c77-06d6-e7ea25c92f34@google.com>
 <3f204974-26c8-4d5f-b7ae-4052cbfdf4ac@redhat.com>
 <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com>
In-Reply-To: <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EAFE180002
X-Stat-Signature: yne1jgeyfn1bs9eyny31ikh8hnfgmdie
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753411110-315361
X-HE-Meta: U2FsdGVkX193nIxFu/iiabYqJ2Z0yCBcmk/v40EoJ3s5eAHd79DjKsMWPPFnhXG1OIEQ8TPq+57jY8a3ugGbBT7XlJNPYXLGKnX+S55YS3jv4xMvrIGgwMCCXX+H+7/8Ed1JyPxZ4n4vEixNBcGgNn6jy+NKH/fpMO6fAKtbIdfAh/kL/WBngGqTHoM5yjseKhnS0SbzFiFFQBuW9DUQFWf1U6g/9PUcYEYSPZGlbA1jLPUKlBhN7LIVQSB0rKceQ2wdplX3W7o7od6a3SWrlSdg7pI4VCP9dSALyvgKD/63AwLc0MzKCAMiBmXBvVtCW2svigIQZFmJLFadhVuQEqAWJF2DURAato9PBA+PURFCiWRpv6E6WxzkbKeDQzudDSbvZNydAEX3OzdX+crmzCsLJY4eITlmH4RpgrFKyGgNU8a6VU/sS7qU0xlntpzZpTPgKyu0/BJD8Z0aY3SOL7lWNskoRbSucU67HRveOcaKieuMqYqdbmiwddc0hXVZtOZQo1u887X8PwbFIdeQ7IVwpiykcMBj1NBw0f3YoJPNlZpddtu6UohqiG7ai+gk0giK20xRLSMEocVxFpb3UZizHYfEM/4TEBgJWjwGHzoABPMtNuTQi248o/YifTbrb0O9d8BO3xZ46IICRcPQ6tYVY7JRveWS4P3h4HeX3iYIe1C74As16oZx0P6XgM3Kcy9b9E5ZImHpFIdMBXUl4CqbopYtVMaIONZXxPnhjtPTP06OqGVxfA5DmtTxJ1qQj6IBJsHXk8VkBjj6ZI/OdNzxFgumqbjtbFwrJFW5VYX3HvOh9UeP8xlTM2LkFEX0XOfi9RevFaPUZYbxsZbp+pc4wG1qgFspqUuguC3Cu0nL7mwryq+L1OHpx3fZWEvLE7wK0TAQLD0xlknrFk1KZGyhgrL1OszJNRDLlansYZravoSHdb8BmDrvgAKnnVHNYp8iTsiN0cTVwaWtFT7
 omGhEcuW
 XXa2lk2AlgwhTozHpfotSsepcVKNeTCVfe4swX0wk8pRu47b6K4BkSn5gOjtRI1FyHI0axPDBWwDzMSuPkNuWZQ3IFnZz+2h8aQO13PkCIcx69S/sQiRD+YcB+OVow1fOhCJWYBRdlvtQNApP6zGX3Kx1ChMJm86Oe8tkPeCpZe0QuPxSTqRbc9fS8muxDVDXbZYHvuMWaIwbwy8gVpyNlSQsxYwGz+9Dr+X/s6/PzkZ7CXW8d6EPKJmpjlfZuTwjoK4U/ssYoZU2ANrHtfbH/dmLXCNAy8sLNJ/STNcdZJkMjbAcXtBOfXiUOzpxQHEC1YlM6+MpWnuFwlf1VQRzCXPt4pusv05Gp7Ge4iobib4IYDRkbwrdjjdTFKnOkghn5PyN6rxz6vjPUBTax26y+pyEncnnBNUtRGkidRi7GW2R0fjlZ3wtAiG2qy69ov4NmhqhxsgheWRHFUsFV9IsN/RdE1Ou0CqSb+E3TNjdgKiQF02PiVOMucP4TVn2F1QhL2/FTCdEGxqq7VKr1BRiUqmw+LzZ8FLOl/SG0e38H0em6/OEAuGHPBHv4HN/QeAcf17l3qr+GPUSSIOoVTM/K95JfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc +mm maillist

On 2025/7/25 10:29, Baolin Wang wrote:
> 
> 
> On 2025/7/25 03:34, David Hildenbrand wrote:
>> On 24.07.25 21:19, Hugh Dickins wrote:
>>> On Thu, 24 Jul 2025, David Hildenbrand wrote:
>>>> On 24.07.25 20:34, Patryk Kowalczyk wrote:
>>>>>
>>>>> Recently, I have observed a significant drop in the performance of the
>>>>> graphics card on a Meteor Lake platform equipped with an Intel Core 
>>>>> Ultra
>>>>> 155H CPU and Xe 128EU GPU, using the i915 driver. Nearly every 
>>>>> workload now
>>>>> runs slower, with memory-intensive tasks experiencing performance 
>>>>> reduced by
>>>>> several percentages.
>>>>>
>>>>> This issue began with the Linux kernel version 6.14.x. Using git 
>>>>> bisect, I
>>>>> identified the problematic commit as
>>>>> acd7ccb284b86da1b2e3233a6826fe933844fc06, which relates to the " 
>>>>> large folio
>>>>> support for tmpfs in the memory management subsystem."
>>>>>
>>>>> More information about this regression can be found at the 
>>>>> following issue
>>>>> tracker: https://gitlab.freedesktop.org/drm/i915/kernel/-/ 
>>>>> issues/14645
>>>>> <https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645>
>>>>>
>>>>> Older bug for textures:
>>>>> https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845 
>>>>> <https://
>>>>> gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845>
>>>>
>>>> Reading the tracker, the valuable information is:
>>>>
>>>> "I tested all the options available via the sysfs interface for 
>>>> shmem_enabled
>>>> in transparent hugepage. The selectable settings are: always, 
>>>> within_size,
>>>> advise, [never] (the default), deny, and force. Among these, only 
>>>> the force
>>>> option restores GPU performance on kernels later than version 6.13 
>>>> and only
>>>> for application executed after change."
>>>>
>>>> So probably you are no longer getting PMD THPs, whereby previously 
>>>> you would
>>>> have gotten PMD THPs.
>>>>
>>>> Do we know how the shmem memory is accessed? read/write or mmap? I 
>>>> suspect it
>>>> is accessed through write() first.
>>>>
>>>> I think we had a change in behavior regarding write(): we will now try
>>>> allocating a PMD THP only if the write() spans the complete PHD range.
>>>>
>>>> I recall that we had a similar report before ...
> 
> Yes, Ville reported the same issue before[1], and I provided a fix to 
> Ville off-list, but I have not received any feedback.
> 
> [1] https://lore.kernel.org/lkml/aBEP-6iFhIC87zmb@intel.com/
> 
>>> I haven't noticed a similar report, but that's my guess too: although
>>> I thought I checked for precisely this (knowing it to be a danger)
>>> during 6.14-rc, I did later find that I must have messed my test up;
>>> but still haven't found time to establish precisely what's going on and
>>> fix it (can't worry too much about releases between LTSs these days).
>>
>> At least scanning the code, write() would behave differently now.
>>
>> Now, I don't know which "hint" we should use to use PMD-sized THPs and 
>> ignore the write size.
>>
>> Maybe the last resort would be starting at PMD-size, but falling back 
>> to smaller orders if we fail to allocate one, hmmmm
> 
> I hope to correct the logic of i915 driver's shmem allocation, by 
> extending the shmem write length in the i915 driver to allocate PMD- 
> sized THPs. IIUC, some sample fix code is as follows (untested). Patryk, 
> could you help test it to see if this resolves your issue? Thanks.
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 1e659d2660f7..5dee740d1e70 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -591,7 +591,7 @@ struct page **drm_gem_get_pages(struct 
> drm_gem_object *obj)
>          i = 0;
>          while (i < npages) {
>                  long nr;
> -               folio = shmem_read_folio_gfp(mapping, i,
> +               folio = shmem_read_folio_gfp(mapping, i, 0,
>                                  mapping_gfp_mask(mapping));
>                  if (IS_ERR(folio))
>                          goto fail;
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/ 
> drm/i915/gem/i915_gem_shmem.c
> index f263615f6ece..0edc75208b7a 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -69,6 +69,7 @@ int shmem_sg_alloc_table(struct drm_i915_private 
> *i915, struct sg_table *st,
>          struct scatterlist *sg;
>          unsigned long next_pfn = 0;     /* suppress gcc warning */
>          gfp_t noreclaim;
> +       size_t chunk;
>          int ret;
> 
>          if (overflows_type(size / PAGE_SIZE, page_count))
> @@ -94,6 +95,7 @@ int shmem_sg_alloc_table(struct drm_i915_private 
> *i915, struct sg_table *st,
>          mapping_set_unevictable(mapping);
>          noreclaim = mapping_gfp_constraint(mapping, ~__GFP_RECLAIM);
>          noreclaim |= __GFP_NORETRY | __GFP_NOWARN;
> +       chunk = mapping_max_folio_size(mapping);
> 
>          sg = st->sgl;
>          st->nents = 0;
> @@ -105,10 +107,13 @@ int shmem_sg_alloc_table(struct drm_i915_private 
> *i915, struct sg_table *st,
>                          0,
>                  }, *s = shrink;
>                  gfp_t gfp = noreclaim;
> +               size_t bytes = (page_count - i) << PAGE_SHIFT;
> +               loff_t pos = i << PAGE_SHIFT;
> 
> +               bytes = min(chunk, bytes);
>                  do {
>                          cond_resched();
> -                       folio = shmem_read_folio_gfp(mapping, i, gfp);
> +                       folio = shmem_read_folio_gfp(mapping, i, pos + 
> bytes, gfp);
>                          if (!IS_ERR(folio))
>                                  break;
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ 
> ttm_backup.c
> index 6f2e58be4f3e..0c90ae338afb 100644
> --- a/drivers/gpu/drm/ttm/ttm_backup.c
> +++ b/drivers/gpu/drm/ttm/ttm_backup.c
> @@ -100,7 +100,7 @@ ttm_backup_backup_page(struct file *backup, struct 
> page *page,
>          struct folio *to_folio;
>          int ret;
> 
> -       to_folio = shmem_read_folio_gfp(mapping, idx, alloc_gfp);
> +       to_folio = shmem_read_folio_gfp(mapping, idx, 0, alloc_gfp);
>          if (IS_ERR(to_folio))
>                  return PTR_ERR(to_folio);
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index cbe46e0c8bce..9fb5f30552e4 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -156,12 +156,12 @@ enum sgp_type {
>   int shmem_get_folio(struct inode *inode, pgoff_t index, loff_t write_end,
>                  struct folio **foliop, enum sgp_type sgp);
>   struct folio *shmem_read_folio_gfp(struct address_space *mapping,
> -               pgoff_t index, gfp_t gfp);
> +               pgoff_t index, loff_t write_end, gfp_t gfp);
> 
>   static inline struct folio *shmem_read_folio(struct address_space 
> *mapping,
>                  pgoff_t index)
>   {
> -       return shmem_read_folio_gfp(mapping, index, 
> mapping_gfp_mask(mapping));
> +       return shmem_read_folio_gfp(mapping, index, 0, 
> mapping_gfp_mask(mapping));
>   }
> 
>   static inline struct page *shmem_read_mapping_page(
> diff --git a/mm/shmem.c b/mm/shmem.c
> index c5eea697a96f..fcf233440c34 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5920,6 +5920,7 @@ int shmem_zero_setup(struct vm_area_struct *vma)
>    * shmem_read_folio_gfp - read into page cache, using specified page 
> allocation flags.
>    * @mapping:   the folio's address_space
>    * @index:     the folio index
> + * @write_end: end of a write if allocating a new folio
>    * @gfp:       the page allocator flags to use if allocating
>    *
>    * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
> @@ -5932,14 +5933,14 @@ int shmem_zero_setup(struct vm_area_struct *vma)
>    * with the mapping_gfp_mask(), to avoid OOMing the machine 
> unnecessarily.
>    */
>   struct folio *shmem_read_folio_gfp(struct address_space *mapping,
> -               pgoff_t index, gfp_t gfp)
> +               pgoff_t index, loff_t write_end, gfp_t gfp)
>   {
>   #ifdef CONFIG_SHMEM
>          struct inode *inode = mapping->host;
>          struct folio *folio;
>          int error;
> 
> -       error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
> +       error = shmem_get_folio_gfp(inode, index, write_end, &folio, 
> SGP_CACHE,
>                                      gfp, NULL, NULL);
>          if (error)
>                  return ERR_PTR(error);
> @@ -5958,7 +5959,7 @@ EXPORT_SYMBOL_GPL(shmem_read_folio_gfp);
>   struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
>                                           pgoff_t index, gfp_t gfp)
>   {
> -       struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
> +       struct folio *folio = shmem_read_folio_gfp(mapping, index, 0, gfp);
>          struct page *page;
> 
>          if (IS_ERR(folio))


