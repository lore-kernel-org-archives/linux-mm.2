Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22A2CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B415C6B008A; Thu, 25 Jun 2026 08:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B191C6B0093; Thu, 25 Jun 2026 08:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F856B0095; Thu, 25 Jun 2026 08:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 776136B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:52:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EABB1406F6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:52:29 +0000 (UTC)
X-FDA: 84918423618.21.9390956
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA844140002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:52:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782391948;
	b=hwOtn8/d1PtdS26HYo6nsItRd2PdazgWypKzzXaJLBnlBeiWe3Q3FO1Mz9jnVYYV3JeY1z
	MpbHVDKEKuVdjp69QDchXBmVKtYhWIT9YB8v2mGAWg3XsNsBEJT3FnyZl5uynvHa35jBqM
	pZUOrseL5XRP5O2d6KNa+RBic59NTJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782391948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EgwwyurCx+jwFpG8Ti2JVcOo2Nkv7KcTR4YDhgEQtnc=;
	b=qcmXKh/8GdKOtv0Yso6891ckCr62HtETyAI4gu6LgpTb0ubhd7Du+46ghrY4LCTgeoccSC
	ngbKFRenEGTL5KGbwRu0ymwOD9JKumiiOJwYfr302y907Ddz9bnNjizrVn5kmE5DWYUcz9
	xlpFpCLPGIbX9KTjhgILUvSDfhYA1TY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id CBD273EC2A;
	Thu, 25 Jun 2026 12:52:21 +0000 (UTC)
Message-ID: <dd9be1f0-3ecf-4ca0-b13c-31660f1479aa@ghiti.fr>
Date: Thu, 25 Jun 2026 14:52:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, chrisl@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624075700.751467-1-alex@ghiti.fr>
 <CAGsJ_4xM=WnFO-OuwVude-DQ_UkaCi_zF_bXBP9Li5+ZPNy0VQ@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAGsJ_4xM=WnFO-OuwVude-DQ_UkaCi_zF_bXBP9Li5+ZPNy0VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGcYnh6MCmRTsUkbg0/vjGusvdXxNY/03k36Dpfi38lmVoCUQAaUUy1+N5Qu/YS6DCKnar+aQvwPW5phPf+V9+kUu+p0TAyqVBz8gcI+J0xK5tnT9uInRklHrvHK8Xbh9ZGD0HbPvMt+S8I255khw+U7RMkYyrLPY4DbP9mZtLJg47EGOOwhjijGWYTplF61Uw/dFJHsWCzbwwqUV85C4Rfx8W8FktwPxkN6s25m4M02Y/tz6Y7M2IOYoMF0SJkNmStzcHEsLZDlA89XYrtcx2RdS+2tOXuM6v/Obb5ouWgeqwOio1ovnHGxkR+USZFnnhnB5lP1xlbLuDYDnIf+SaCIigXT3VQrtJBVxdGKTWRrgj0+JIzwf+rLdiWlSZ59+pYxUSV9wOhnkLO9SIEUixJ401yrOyS86OJ5XyoPXA9VWp7G8ydBM4WlCdd6ZbVppL57+cfrHwwMevf4h3Tj+wfRkKjXUDHIeXYj5mINEwCbgqAqntDmDzsHO5go7elV62cGgIi71PivOYrvMbTd+KxQy680wecqGLecfBGE0PJPG/YmyjYDV9PMxOajbxGhOvODTzrFM62/DurgJT5SJHWogvDY5/KWqrEME/FVYMHV+YgjXeQUnoaZWMpcCdcZ7b0TP8AIDVLAPqEgFmCau4brqGlKA8mHN3K8KiVgSlaeA
X-GND-State: clean
X-GND-Score: 0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA844140002
X-Rspam-User: 
X-Stat-Signature: 36o61dn1bc9k1chcebbi66x1agywck6b
X-HE-Tag: 1782391947-377448
X-HE-Meta: U2FsdGVkX1/RQNJsqTUKiynTTsYdDXdgOUz4TOiF/x7b7/48ooEsnsJA26recdd8HlJX5MoK7G7VDhCtXt6tAvJT2WBYRQ4N1k39TvoxBaKhLvOu6LoP3FnDF8T3USRRPt8NHI8bW9wDON4i/1cQGNue17stjOxxl7si0Qk3YSfGheRjNU0/3T+BXumo8AVRqxKvVrFaSLrUwLovdlkP1zaFmIJNb0tjxozzyLrX4oTsk2+6AduhgdFRLxySCKsGY4QGugj5+m+3TGHRq0Jgwdmnemqqoi4fPXyneLQYD/qNvUqBjMiwQINpuq1I3djn/G8fkNUqtsaLwLia50pT7p6Z1uZXrnlNiQ/lWH279KC3MTEnyrUD3Y8mxJL9kX0MPL+XfMtMzCQvPlfXwvARg+Pn523IwnDJQfy9uW8iHP7jqutq5RuR37QYk7X/3Pb92dhm3+7nuHsSvQ/L48q49KNHGqpM2C7Li5Kx5j/gCuRba1aHVFSok5SCzGLdEKUVBf3+tQSArDPONqPr8yNaXhIvcRtVIsBwbEL76KhOCSJJ/y/dGTIlGp3RDlcv3TiiF1qdIWFXnIghqoQswUlk9/zFUotZf/gAfy8BYZXZPnSELNWj2qUtBMODwfts7dn8D0KSyaGS9a7DDZ1alVZPvY/ob1NDIWg15av06ufDBG8dFoa6pJFEQ13aqKgZeD75GbBI8c5NoOzs7kLeFnLnsigRRGzHZwRaWtKNg1vuaPMkmql4asj9rT+4QznJy0QBcl9mTkSxm9KW4ja5PzZwRan8LKolscr7SEBvDdWwnUqz2x+Lj7hBEnZxI4XL9YKH+74Mr/RY305hHblT6uzPd92UKb+27LQBMXRV2rd5t6DpnpIaqApoq/Bl9e/yPYFzFPS/H9BbI3Ru++ZZkWk5VSHdGgdPmUb/sicQKYPlcSkNK0BopcXJSNZS+TIw6N9h70GfdfLo15I0Y9OjOjl
 DHb4Mv1h
 qc9QZTGIyN6rseI7owYcfTlEQPBSWHs3pWmPivXJhi6Vq17RYc2hA8OEJyqgjLTDH5VuGXkyAgxf/aDChjEtfHxetYFJMZ9ZTZ0zeYlIP7BnECmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On 6/24/26 21:24, Barry Song wrote:
> On Wed, Jun 24, 2026 at 3:57 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
>> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
>> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>>
>> zswap is the same kind of in-memory, synchronous backend as zram, not a
>> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
>> swapin_readahead().
>>
>> Here are the results from bypassing readahead for zswap too: it was
>> measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
>> off, on Sapphire Rapids and 3 iterations.
>>
>>    768M memcg (sustained swap thrash):
>>      metric                 mm-new    + bypass    delta
>>      build time (s)          405.0       341.7    -15.6%
>>      zswap-in (GB)            79.5        53.0     -33%
>>      zswap-out (GB)          144.8       115.6     -20%
>>      swap readahead (pages)  6.79M       0.45M     -93%
>>      swap_ra hit (%)          72.1        89.9     +18pp
>>
>>    1G memcg (light pressure, build not memory-bound):
>>      metric                 mm-new    + bypass    delta
>>      build time (s)          177.7       176.0    ~same (no regression)
>>      zswap-in (GB)            10.2         7.5     -26%
>>      zswap-out (GB)           27.7        25.1      -9%
>>      swap readahead (pages)  1.07M       0.08M     -93%
>>      swap_ra hit (%)          68.6        87.2     +19pp
>>
>> The gain is from no longer prefetching pages that are pointless for an
>> in-memory backend: readahead inflates anon residency and thrashes the
>> page cache (file pages get evicted and re-read), lengthens each fault by
>> synchronously (de)compressing a cluster of neighbours, and adds
>> compression traffic when those extra pages are reclaimed.
>>
>> Bypassing swap readahead for zswap therefore makes sense.
>>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>
>> - This bypass originally comes from Usama's series that implements
>>    large folio zswapin: while working on improving this series, I noticed
>>    the gains I got only came from the bypass of readahead.
>>
>>   include/linux/zswap.h |  6 ++++++
>>   mm/memory.c           |  5 +++--
>>   mm/zswap.c            | 11 +++++++++++
>>   3 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
>> index 30c193a1207e..b6f0e6198b6f 100644
>> --- a/include/linux/zswap.h
>> +++ b/include/linux/zswap.h
>> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>>   void zswap_folio_swapin(struct folio *folio);
>>   bool zswap_is_enabled(void);
>>   bool zswap_never_enabled(void);
>> +bool zswap_present_test(swp_entry_t swp);
>>   #else
>>
>>   struct zswap_lruvec_state {};
>> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>>          return true;
>>   }
>>
>> +static inline bool zswap_present_test(swp_entry_t swp)
>> +{
>> +       return false;
>> +}
>> +
>>   #endif
>>
>>   #endif /* _LINUX_ZSWAP_H */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index ff338c2abe92..5aa1ea9eb48a 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>          if (folio)
>>                  swap_update_readahead(folio, vma, vmf->address);
>>          if (!folio) {
>> -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
>> -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
>> +               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
>> +               if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
>> +                   zswap_present_test(entry))
>>                          folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
>>                                              thp_swapin_suitable_orders(vmf) | BIT(0),
>>                                              vmf, NULL, 0);
> Basically, I have been seeing the same issue recently. If the
> readahead swap entries are also in zswap, we end up doing the
> decompression during one page fault, but then need another page fault
> to fetch the page from the swap cache and install the mapping. In that
> case, readahead may not be beneficial.


Oh I had not noticed that, indeed since zswap readahead is synchronous, 
we can clearly avoid the second page fault!


>
> On the other hand, if the readahead swap entries are not in zswap, the
> situation is different.
>
> For example, suppose we fault on the swap entry for address 1 MB and
> readahead brings in the entry for 1 MB + 4 KB. If both entries are in
> zswap, readahead does not seem like a good trade-off. However, if the
> 1 MB + 4 KB entry is not in zswap and would otherwise require storage
> I/O, then readahead can be beneficial.


Yosry made the same comment, I'll explore this.


>
> So I implemented a rather ugly fault_around-like mechanism in
> do_swap_page(). At least with page-cluster == 1, I am seeing a
> performance improvement, as the readahead folios can be mapped
> directly and do not require a second page fault.


IIUC the code below, you wait for the end of the page fault to try and 
map a folio that would have been readahead right? I guess you do that at 
the end in the hope that the io has finished by then?

Maybe we can do that synchronously for zswap since the readahead is 
synchronous?  And for the readahead pages that require io, wouldn't it 
be possible to do it in the end of io callback instead?

Thanks for your comments,

Alex


>
> It is admittedly quite ugly and is only meant as a proof of concept :-)
>
> Subject: [PATCH PoC] mm: enable do_swap_page fault_around
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/memory.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 95 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index c00a31a6d1d0..1db79f45a575 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4736,6 +4736,100 @@ static void check_swap_exclusive(struct folio
> *folio, swp_entry_t entry,
>           } while (--nr_pages);
>   }
>
> +static void do_swap_map_around(struct vm_fault *vmf, struct
> swap_info_struct *si)
> +{
> +        struct vm_area_struct *vma = vmf->vma;
> +        int nr_around = 1 << page_cluster;
> +        unsigned long start = max3(vma->vm_start, vmf->address -
> (nr_around - 1) * PAGE_SIZE,
> +                        vmf->address & PMD_MASK);
> +        unsigned long end = min3(vma->vm_end, vmf->address +
> nr_around * PAGE_SIZE,
> +                        (vmf->address & PMD_MASK) + PMD_SIZE);
> +        unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
> +        unsigned long delta_pages = (vmf->address - start) >> PAGE_SHIFT;
> +        pte_t *ptep = vmf->pte - delta_pages;
> +
> +        for (int i = 0; i < nr_pages; i++, ptep++) {
> +                unsigned long address = start + (i << PAGE_SHIFT);
> +                rmap_t rmap_flags = RMAP_NONE;
> +                pte_t orig_pte, pte;
> +                struct folio *folio;
> +                struct page *page;
> +                softleaf_t entry;
> +                bool exclusive;
> +
> +                if (ptep == vmf->pte)
> +                        continue;
> +                orig_pte = ptep_get(ptep);
> +                exclusive = pte_swp_exclusive(orig_pte);
> +                if (!exclusive)
> +                        continue;
> +                entry = softleaf_from_pte(orig_pte);
> +                if (!softleaf_is_swap(entry))
> +                        continue;
> +                folio = swap_cache_get_folio(entry);
> +                if (!folio)
> +                        continue;
> +                if (unlikely(!folio_matches_swap_entry(folio, entry)))
> +                        goto skip;
> +                if (folio_test_locked(folio))
> +                        goto skip;
> +                if (!folio_test_uptodate(folio))
> +                        goto skip;
> +                if (!folio_trylock(folio))
> +                        goto skip;
> +                if (folio_test_ksm(folio) || folio_test_large(folio) ||
> +                        !folio_test_uptodate(folio))
> +                        goto unlock;
> +                if (exclusive && folio_test_writeback(folio) &&
> +                                data_race(si->flags & SWP_STABLE_WRITES))
> +                        exclusive = false;
> +
> +                arch_swap_restore(folio_swap(entry, folio), folio);
> +
> +                page = folio_page(folio, 0);
> +                add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> +                add_mm_counter(vma->vm_mm, MM_SWAPENTS, -1);
> +                pte = mk_pte(page, vma->vm_page_prot);
> +                if (pte_swp_soft_dirty(orig_pte))
> +                        pte = pte_mksoft_dirty(pte);
> +                if (pte_swp_uffd_wp(orig_pte))
> +                        pte = pte_mkuffd_wp(pte);
> +
> +                if (exclusive) {
> +                        if ((vma->vm_flags & VM_WRITE) &&
> !userfaultfd_pte_wp(vma, pte) &&
> +                                        !pte_needs_soft_dirty_wp(vma, pte)) {
> +                                pte = pte_mkwrite(pte, vma);
> +                        }
> +                        rmap_flags |= RMAP_EXCLUSIVE;
> +                }
> +                flush_icache_pages(vma, page, 1);
> +
> +                if (!folio_test_anon(folio)) {
> +                        folio_add_new_anon_rmap(folio, vma, address,
> rmap_flags);
> +                        folio_put_swap(folio, NULL);
> +                } else {
> +                        folio_add_anon_rmap_ptes(folio, page, 1, vma, address,
> +                                        rmap_flags);
> +                        folio_put_swap(folio, page);
> +                }
> +
> +                set_ptes(vma->vm_mm, address, ptep, pte, 1);
> +                arch_do_swap_page_nr(vma->vm_mm, vma, address,
> +                                pte, pte, 1);
> +
> +                if (should_try_to_free_swap(si, folio, vma, 1, vmf->flags))
> +                        folio_free_swap(folio);
> +                folio_unlock(folio);
> +                swap_update_readahead(folio, vma, address);
> +                update_mmu_cache_range(vmf, vma, address, ptep, 1);
> +                continue;
> +unlock:
> +                folio_unlock(folio);
> +skip:
> +                folio_put(folio);
> +        };
> +}
> +
>   /*
>    * We enter with either the VMA lock or the mmap_lock held (see
>    * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
> @@ -5121,6 +5215,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>           /* No need to invalidate - it was non-present before */
>           update_mmu_cache_range(vmf, vma, address, ptep, nr_pages);
> +        do_swap_map_around(vmf, si);
>   unlock:
>           if (vmf->pte)
>                   pte_unmap_unlock(vmf->pte, vmf->ptl);

