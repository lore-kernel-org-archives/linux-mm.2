Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCA5CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E9A8E00FA; Tue,  4 Nov 2025 03:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E9A8E00E7; Tue,  4 Nov 2025 03:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6D28E00FA; Tue,  4 Nov 2025 03:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64DD98E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:34:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA3E158F74
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:34:47 +0000 (UTC)
X-FDA: 84072263814.02.6A2960F
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id F20444000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:34:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6PnWNYbL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762245286; a=rsa-sha256;
	cv=none;
	b=K/fqmaNjF01dstjdwOqQc6Qk8u6mQIzrkOApwU5ZNoA78FSkIW/8F+/793qtvwWlP8MLj5
	ReP1407P7vMiQeMP+9c4tE7Dhvr3xBQH5JQJPt8uqPDRwb3PB7jpVRrwUyFPIuU6D0MNtZ
	vLA3dMH27QASM3lhpRsojUgmEEcPNi4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6PnWNYbL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762245286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygSjWRMSgTUl3tMg0VUWCTluYgOZCWbSkQByvPvwY4A=;
	b=lvhlILJHMXlIR9y51nVk3sFUZaObpvGDyNIomPb5pY+ZRjOH601S3Qr0IKJ96NSZeDv+PZ
	kdavAwBXUktXiZ3dlvFWzK0DWSHIzc1gmEJ43urPaetFreKkjf8kzs7dSo2UhubKcXDQTs
	B1uuvhG4E1iU8zDBGsNAyDoyz5m9UxU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ygSjWRMSgTUl3tMg0VUWCTluYgOZCWbSkQByvPvwY4A=;
	b=6PnWNYbLKFAIOpZFhY2dDOc0/Wmw8i8ZdEK7i+0ApItauSsPYKLBNN5G4SCN49aeP9cALroJw
	zjdFy4oUflOVA20EAvj8LUs22Un59ttZaKwjJ5CZvx8c7GOmmgTI00F0oSUq+Rnd2S8btpRUx3J
	Dsg8gfpMqRJSsxAJ8olhZlI=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4d11tR2n8Xzcb1q;
	Tue,  4 Nov 2025 16:33:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 28B83140156;
	Tue,  4 Nov 2025 16:34:38 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 16:34:36 +0800
Message-ID: <efeb3350-fbdf-408c-92ef-c6eada4a5755@huawei.com>
Date: Tue, 4 Nov 2025 16:34:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: Barry Song <21cnbao@gmail.com>, <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>
CC: <linux-kernel@vger.kernel.org>, Barry Song <v-songbaohua@oppo.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>, Vlastimil
 Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Lokesh Gidra
	<lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>, Qi Zheng
	<zhengqi.arch@bytedance.com>
References: <20250607220150.2980-1-21cnbao@gmail.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20250607220150.2980-1-21cnbao@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F20444000F
X-Stat-Signature: qbweezk1b71kn1qpqradrucrgsepngtt
X-HE-Tag: 1762245283-988356
X-HE-Meta: U2FsdGVkX18ArtWrtX/diMw/24O9nSMTHFZdzhYScH1TT0kGfGgR8pdTwT0K5h5QtMKSlyTtEViWbEymjktR5WYQhTDy/Tj+TuvC8JSqvB2x9LKEyhSfJe/TV1rPkSV7/SU+pcq58QjkYoir3sCcpME9Qdg+jXbRvrMTW4i50GbiXQhktxyLIfVryj/H/eTfjNPe3ZvRZ+s2fp8mNHq4stW+RpZyuckDOVM7aWB5Vqe+8ihH5fndhY/SAc3d59TJmHb0nXVOQsRgKb7YTbri3YUm+FpaTICVD5EQJH4VNrtn4hG9sl0LjbKvTXSavLmOhLqfFtgsoX3B1MOkmAjdc5qFYgV0i9HRDn3nyPWcwjiIMQyRBk8ApLrvMDUiUOFlw9kVIJbxEag//9pemSI3NSpq2mPNDka3/AOOM0FiOKt2hD5onIjMvm6wcrJ5048jzDunxHC3lR/ZS89gNX7ryulsA4ZSTW5YZCkeCAEiP7FiCF8NC4aGRIm5Wk615/fGDugyNTe8GCmCUlPuw8UrxD71JArY4aXhfoDs8dmr1nxe1F2hOh8fb5YZxJsi3np6EbFLvTyvoYAKevG+G9bmlhei02KSN5X//9Ucpeay/fwo19k8fHzdTeeuD53Ftc1ufOjxFgdPNsw4IwnDl5xRBmbUmihRwGpqCL7q8bMm6Qv1017ufFKjxIUZFgo7g0zjz8JUPiEG1YH90SjaIjzbymxd53m5/TsUA6I52TPc7EvZAumjUBWa9wxq1nML16Red0OKl805dg7ErPL7jD8zyczxoAX+6jb1DJ5QvPbYep5CJTInBm5b/JJTR84m8HOAuggES6RCH3VTBqI9g1yIB75jFpZJrQeORr4C/S8Gz3vGGkh5+3o/CfuZEAHv01sSBssTLsIMBa1M6yjgtOFaLZMICZIyFWwdpF/nuDYPRCjJ4AofzZp2b2M7qg7d/CQEdot7KXa9kaRj0nTjMFG
 peYMbQhV
 tmlt32JxAnZixmMQWG6sSiJdXFz1CwMjcG7ZftmdTqyl4BDR4v7NK7zhGNhafVnh9clZAp8v1ZGNsmGoDJ5+3VKnMzgiJZ60QJx14M8srKAPWrSpHW9GOYoGa+eIovXoeIrbIBkfao8suc1m+AGwQSHgEjIxvMpBkQyJ7EouvsQsUVvdlQgewLkjd1ZtqTjg1C85/RImRhdRc1tPKXm1qS1lA7il54ZCz0fFMfWTKRoJCV5sDaUDsxSkNp4FXgHj/b6PvHJ3D/yeMJa+NLFMA2t1kJWEI5Hb3Em5I82t+to1tnOs8yL+hjZ8KmuzLe1NiSwZSQLnOIW5T7l9D2ryD95/4YfLSXWjMEsMGNE+5PvtbfwU+yXc3gzx4hcy8fKXr4NrNCvVrRDeA+hChbE6T4Ld4H2Cyuxeva0CdaCrPlt3K35968FfMx8ZeH1gMI4BIEiCcGaOk3h7WBVH2t3wZfFBWioEiVtCHyfc1bJeBF35upF+X0foT4KNL1BPy6sx5TZnMmCxLWYqAZ0eTRiY3t/dAUaZZVgqXPNrEwGp9E3wCAg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry and Suren,

On 2025/6/8 6:01, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> Certain madvise operations, especially MADV_DONTNEED, occur far more
> frequently than other madvise options, particularly in native and Java
> heaps for dynamic memory management.
> 
> Currently, the mmap_lock is always held during these operations, even when
> unnecessary. This causes lock contention and can lead to severe priority
> inversion, where low-priority threads—such as Android's HeapTaskDaemon—
> hold the lock and block higher-priority threads.
> 
> This patch enables the use of per-VMA locks when the advised range lies
> entirely within a single VMA, avoiding the need for full VMA traversal. In
> practice, userspace heaps rarely issue MADV_DONTNEED across multiple VMAs.
> 
> Tangquan’s testing shows that over 99.5% of memory reclaimed by Android
> benefits from this per-VMA lock optimization. After extended runtime,
> 217,735 madvise calls from HeapTaskDaemon used the per-VMA path, while
> only 1,231 fell back to mmap_lock.
> 
> To simplify handling, the implementation falls back to the standard
> mmap_lock if userfaultfd is enabled on the VMA, avoiding the complexity of
> userfaultfd_remove().
> 
> Many thanks to Lorenzo's work[1] on:
> "Refactor the madvise() code to retain state about the locking mode
> utilised for traversing VMAs.
> 
> Then use this mechanism to permit VMA locking to be done later in the
> madvise() logic and also to allow altering of the locking mode to permit
> falling back to an mmap read lock if required."
> 
> One important point, as pointed out by Jann[2], is that
> untagged_addr_remote() requires holding mmap_lock. This is because
> address tagging on x86 and RISC-V is quite complex.
> 
> Until untagged_addr_remote() becomes atomic—which seems unlikely in
> the near future—we cannot support per-VMA locks for remote processes.
> So for now, only local processes are supported.
> 
> Link: https://lore.kernel.org/all/0b96ce61-a52c-4036-b5b6-5c50783db51f@lucifer.local/ [1]
> Link: https://lore.kernel.org/all/CAG48ez11zi-1jicHUZtLhyoNPGGVB+ROeAJCUw48bsjk4bbEkA@mail.gmail.com/ [2]
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Cc: Tangquan Zheng <zhengtangquan@oppo.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>   -v4:
>   * collect Lorenzo's RB;
>   * use visit() for per-vma path
> 
>   mm/madvise.c | 195 ++++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 147 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 56d9ca2557b9..8382614b71d1 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -48,38 +48,19 @@ struct madvise_walk_private {
>   	bool pageout;
>   };
>   
> +enum madvise_lock_mode {
> +	MADVISE_NO_LOCK,
> +	MADVISE_MMAP_READ_LOCK,
> +	MADVISE_MMAP_WRITE_LOCK,
> +	MADVISE_VMA_READ_LOCK,
> +};
> +
>   struct madvise_behavior {
>   	int behavior;
>   	struct mmu_gather *tlb;
> +	enum madvise_lock_mode lock_mode;
>   };
>   
> -/*
> - * Any behaviour which results in changes to the vma->vm_flags needs to
> - * take mmap_lock for writing. Others, which simply traverse vmas, need
> - * to only take it for reading.
> - */
> -static int madvise_need_mmap_write(int behavior)
> -{
> -	switch (behavior) {
> -	case MADV_REMOVE:
> -	case MADV_WILLNEED:
> -	case MADV_DONTNEED:
> -	case MADV_DONTNEED_LOCKED:
> -	case MADV_COLD:
> -	case MADV_PAGEOUT:
> -	case MADV_FREE:
> -	case MADV_POPULATE_READ:
> -	case MADV_POPULATE_WRITE:
> -	case MADV_COLLAPSE:
> -	case MADV_GUARD_INSTALL:
> -	case MADV_GUARD_REMOVE:
> -		return 0;
> -	default:
> -		/* be safe, default to 1. list exceptions explicitly */
> -		return 1;
> -	}
> -}
> -
>   #ifdef CONFIG_ANON_VMA_NAME
>   struct anon_vma_name *anon_vma_name_alloc(const char *name)
>   {
> @@ -1486,6 +1467,44 @@ static bool process_madvise_remote_valid(int behavior)
>   	}
>   }
>   
> +/*
> + * Try to acquire a VMA read lock if possible.
> + *
> + * We only support this lock over a single VMA, which the input range must
> + * span either partially or fully.
> + *
> + * This function always returns with an appropriate lock held. If a VMA read
> + * lock could be acquired, we return the locked VMA.
> + *
> + * If a VMA read lock could not be acquired, we return NULL and expect caller to
> + * fallback to mmap lock behaviour.
> + */
> +static struct vm_area_struct *try_vma_read_lock(struct mm_struct *mm,
> +		struct madvise_behavior *madv_behavior,
> +		unsigned long start, unsigned long end)
> +{
> +	struct vm_area_struct *vma;
> +
> +	vma = lock_vma_under_rcu(mm, start);
> +	if (!vma)
> +		goto take_mmap_read_lock;
> +	/*
> +	 * Must span only a single VMA; uffd and remote processes are
> +	 * unsupported.
> +	 */
> +	if (end > vma->vm_end || current->mm != mm ||
> +	    userfaultfd_armed(vma)) {
> +		vma_end_read(vma);
> +		goto take_mmap_read_lock;
> +	}
> +	return vma;
> +
> +take_mmap_read_lock:
> +	mmap_read_lock(mm);
> +	madv_behavior->lock_mode = MADVISE_MMAP_READ_LOCK;
> +	return NULL;
> +}
> +
>   /*
>    * Walk the vmas in range [start,end), and call the visit function on each one.
>    * The visit function will get start and end parameters that cover the overlap
> @@ -1496,7 +1515,8 @@ static bool process_madvise_remote_valid(int behavior)
>    */
>   static
>   int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
> -		      unsigned long end, void *arg,
> +		      unsigned long end, struct madvise_behavior *madv_behavior,
> +		      void *arg,
>   		      int (*visit)(struct vm_area_struct *vma,
>   				   struct vm_area_struct **prev, unsigned long start,
>   				   unsigned long end, void *arg))
> @@ -1505,6 +1525,20 @@ int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
>   	struct vm_area_struct *prev;
>   	unsigned long tmp;
>   	int unmapped_error = 0;
> +	int error;
> +
> +	/*
> +	 * If VMA read lock is supported, apply madvise to a single VMA
> +	 * tentatively, avoiding walking VMAs.
> +	 */
> +	if (madv_behavior && madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
> +		vma = try_vma_read_lock(mm, madv_behavior, start, end);
> +		if (vma) {
> +			error = visit(vma, &prev, start, end, arg);
> +			vma_end_read(vma);
> +			return error;
> +		}
> +	}
>   
>   	/*
>   	 * If the interval [start,end) covers some unmapped address
> @@ -1516,8 +1550,6 @@ int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
>   		prev = vma;
>   
>   	for (;;) {
> -		int error;
> -
>   		/* Still start < end. */
>   		if (!vma)
>   			return -ENOMEM;
> @@ -1598,34 +1630,86 @@ int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
>   	if (end == start)
>   		return 0;
>   
> -	return madvise_walk_vmas(mm, start, end, anon_name,
> +	return madvise_walk_vmas(mm, start, end, NULL, anon_name,
>   				 madvise_vma_anon_name);
>   }
>   #endif /* CONFIG_ANON_VMA_NAME */
>   
> -static int madvise_lock(struct mm_struct *mm, int behavior)
> +
> +/*
> + * Any behaviour which results in changes to the vma->vm_flags needs to
> + * take mmap_lock for writing. Others, which simply traverse vmas, need
> + * to only take it for reading.
> + */
> +static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
>   {
> +	int behavior = madv_behavior->behavior;
> +
>   	if (is_memory_failure(behavior))
> -		return 0;
> +		return MADVISE_NO_LOCK;
>   
> -	if (madvise_need_mmap_write(behavior)) {
> +	switch (behavior) {
> +	case MADV_REMOVE:
> +	case MADV_WILLNEED:
> +	case MADV_COLD:
> +	case MADV_PAGEOUT:
> +	case MADV_FREE:
> +	case MADV_POPULATE_READ:
> +	case MADV_POPULATE_WRITE:
> +	case MADV_COLLAPSE:
> +	case MADV_GUARD_INSTALL:
> +	case MADV_GUARD_REMOVE:
> +		return MADVISE_MMAP_READ_LOCK;
> +	case MADV_DONTNEED:
> +	case MADV_DONTNEED_LOCKED:
> +		return MADVISE_VMA_READ_LOCK;

I have a question, we will try per-vma lock for dontneed,
but there is a mmap_assert_locked() during madvise_dontneed_free(),

madvise_dontneed_free
   madvise_dontneed_single_vma
     zap_page_range_single_batched
       unmap_single_vma
          unmap_page_range
            zap_pud_range
              mmap_assert_locked

We could fix it by passing the lock_mode into zap_detial and then check
the right lock here, but I'm not sure whether it is safe to zap page
only with vma lock?

And another about 4f8ba33bbdfc （"mm: madvise: use per_vma lock
for MADV_FREE"）, it called walk_page_range_vma() in 
madvise_free_single_vma(),  but from link[1] and 5631da56c9a8 
("fs/proc/task_mmu: read proc/pid/maps under per-vma lock"), it saids

   "Note that similar approach would not work for /proc/pid/smaps
   reading as it also walks the page table and that's not RCU-safe"

We could use walk_page_range_vma() instead of walk_page_range() in 
smap_gather_stats(), and same question, why 4f8ba33bbdfc(for MADV_FREEE)
is safe but not for show_numa_map()/show_smap()?

Thanks.

[1] https://lkml.kernel.org/r/20250719182854.3166724-1-surenb@google.com



> +	default:
> +		return MADVISE_MMAP_WRITE_LOCK;
> +	}
> +}
> +
> +static int madvise_lock(struct mm_struct *mm,
> +		struct madvise_behavior *madv_behavior)
> +{
> +	enum madvise_lock_mode lock_mode = get_lock_mode(madv_behavior);
> +
> +	switch (lock_mode) {
> +	case MADVISE_NO_LOCK:
> +		break;
> +	case MADVISE_MMAP_WRITE_LOCK:
>   		if (mmap_write_lock_killable(mm))
>   			return -EINTR;
> -	} else {
> +		break;
> +	case MADVISE_MMAP_READ_LOCK:
>   		mmap_read_lock(mm);
> +		break;
> +	case MADVISE_VMA_READ_LOCK:
> +		/* We will acquire the lock per-VMA in madvise_walk_vmas(). */
> +		break;
>   	}
> +
> +	madv_behavior->lock_mode = lock_mode;
>   	return 0;
>   }
>   
> -static void madvise_unlock(struct mm_struct *mm, int behavior)
> +static void madvise_unlock(struct mm_struct *mm,
> +		struct madvise_behavior *madv_behavior)
>   {
> -	if (is_memory_failure(behavior))
> +	switch (madv_behavior->lock_mode) {
> +	case  MADVISE_NO_LOCK:
>   		return;
> -
> -	if (madvise_need_mmap_write(behavior))
> +	case MADVISE_MMAP_WRITE_LOCK:
>   		mmap_write_unlock(mm);
> -	else
> +		break;
> +	case MADVISE_MMAP_READ_LOCK:
>   		mmap_read_unlock(mm);
> +		break;
> +	case MADVISE_VMA_READ_LOCK:
> +		/* We will drop the lock per-VMA in madvise_walk_vmas(). */
> +		break;
> +	}
> +
> +	madv_behavior->lock_mode = MADVISE_NO_LOCK;
>   }
>   
>   static bool madvise_batch_tlb_flush(int behavior)
> @@ -1710,6 +1794,21 @@ static bool is_madvise_populate(int behavior)
>   	}
>   }
>   
> +/*
> + * untagged_addr_remote() assumes mmap_lock is already held. On
> + * architectures like x86 and RISC-V, tagging is tricky because each
> + * mm may have a different tagging mask. However, we might only hold
> + * the per-VMA lock (currently only local processes are supported),
> + * so untagged_addr is used to avoid the mmap_lock assertion for
> + * local processes.
> + */
> +static inline unsigned long get_untagged_addr(struct mm_struct *mm,
> +		unsigned long start)
> +{
> +	return current->mm == mm ? untagged_addr(start) :
> +				   untagged_addr_remote(mm, start);
> +}
> +
>   static int madvise_do_behavior(struct mm_struct *mm,
>   		unsigned long start, size_t len_in,
>   		struct madvise_behavior *madv_behavior)
> @@ -1721,7 +1820,7 @@ static int madvise_do_behavior(struct mm_struct *mm,
>   
>   	if (is_memory_failure(behavior))
>   		return madvise_inject_error(behavior, start, start + len_in);
> -	start = untagged_addr_remote(mm, start);
> +	start = get_untagged_addr(mm, start);
>   	end = start + PAGE_ALIGN(len_in);
>   
>   	blk_start_plug(&plug);
> @@ -1729,7 +1828,7 @@ static int madvise_do_behavior(struct mm_struct *mm,
>   		error = madvise_populate(mm, start, end, behavior);
>   	else
>   		error = madvise_walk_vmas(mm, start, end, madv_behavior,
> -					  madvise_vma_behavior);
> +				madv_behavior, madvise_vma_behavior);
>   	blk_finish_plug(&plug);
>   	return error;
>   }
> @@ -1817,13 +1916,13 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
>   
>   	if (madvise_should_skip(start, len_in, behavior, &error))
>   		return error;
> -	error = madvise_lock(mm, behavior);
> +	error = madvise_lock(mm, &madv_behavior);
>   	if (error)
>   		return error;
>   	madvise_init_tlb(&madv_behavior, mm);
>   	error = madvise_do_behavior(mm, start, len_in, &madv_behavior);
>   	madvise_finish_tlb(&madv_behavior);
> -	madvise_unlock(mm, behavior);
> +	madvise_unlock(mm, &madv_behavior);
>   
>   	return error;
>   }
> @@ -1847,7 +1946,7 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>   
>   	total_len = iov_iter_count(iter);
>   
> -	ret = madvise_lock(mm, behavior);
> +	ret = madvise_lock(mm, &madv_behavior);
>   	if (ret)
>   		return ret;
>   	madvise_init_tlb(&madv_behavior, mm);
> @@ -1880,8 +1979,8 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>   
>   			/* Drop and reacquire lock to unwind race. */
>   			madvise_finish_tlb(&madv_behavior);
> -			madvise_unlock(mm, behavior);
> -			ret = madvise_lock(mm, behavior);
> +			madvise_unlock(mm, &madv_behavior);
> +			ret = madvise_lock(mm, &madv_behavior);
>   			if (ret)
>   				goto out;
>   			madvise_init_tlb(&madv_behavior, mm);
> @@ -1892,7 +1991,7 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>   		iov_iter_advance(iter, iter_iov_len(iter));
>   	}
>   	madvise_finish_tlb(&madv_behavior);
> -	madvise_unlock(mm, behavior);
> +	madvise_unlock(mm, &madv_behavior);
>   
>   out:
>   	ret = (total_len - iov_iter_count(iter)) ? : ret;


