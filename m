Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3ABCD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 12:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9206B0131; Sun, 31 May 2026 08:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A8E6B0132; Sun, 31 May 2026 08:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C486D6B0133; Sun, 31 May 2026 08:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE83C6B0131
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:21:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A8891403D5
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:21:18 +0000 (UTC)
X-FDA: 84827625036.19.3BB41DD
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6266F18000B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:21:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=VGFk4qUo;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780230076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0U5WRb9wpBn+CSXUdJxa1a1P5zPqfLCisGYgFPCnlM=;
	b=FbA3es83Dxg5TBqk37OC6LEVOCgMhVYUgHdfDIWfdu5QXC/l+otqvZAWxZv3oWw4NjLSjK
	npqlwnofQDRKt7ya/MCVIrTHmy5a5oveFImedtCKk3MF7/MHXUkFFYc3pysjEZk4rX4REh
	GXBnWrQoc/oW5o1PcOt36F68iJ4yucc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=VGFk4qUo;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780230076; a=rsa-sha256;
	cv=none;
	b=JBeS/eNlV1erEeik6S11zp4H9STSE9fKlO3zrC6prhnr4i+lH7Bf1qweOOAYeRUmmHEWzh
	ysQou+qynBpSW3tV4amBFlIZFsnv/32wDAeK5YuswGGUAI7Pxf7/qDIaKaaGykkAz89HFo
	gWAe1eh9v1McvUwwyGxH/IgrLIAZ3ic=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780230068; bh=C0U5WRb9wpBn+CSXUdJxa1a1P5zPqfLCisGYgFPCnlM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VGFk4qUoLfJSR+8u2Xow8L1Y50We4oTefReTGDFUkh5mL4rybk3PY0xm9HD4EHph/
	 ceI/02lJfgx95eNePOB2SRb+eCjmthrxKm6eLwf5E7id4BRPslRdrUKFutwArfdi12
	 cXln+EanqmaBcllk0VccIrMJviGPhcvcxV2aIOlk=
Received: from [10.24.9.42] ([123.112.11.230])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 544834C5; Sun, 31 May 2026 20:21:04 +0800
X-QQ-mid: xmsmtpt1780230064tpwcseaav
Message-ID: <tencent_FBB491DE9B018B3FAE9C670AC590F9050F07@qq.com>
X-QQ-XMAILINFO: OEUhVsHQax4MPQUHt4FdO9CA+DSZ3ixpq4zBcMj9ulacz0ZBFYPTCZlSe1aHG7
	 +371qSgm3Bzm+1WrhgZ7teEciKXSS7MuQmFLPBpulm1ilAR51bE0ia0xsGZdh+Of+kRswSudNd2g
	 OVb1EBgyr8xGerRPvU2kJo412nzWNZLpZKCYoYKXqoWh6wvuc/ca5haT0wNClpnDiX838clJcE1X
	 Y6XqsWGLn6+o4dU7VV5lsB2gOwb5eRGuRsMZzJ71ueViKTJ4RV1IahgPwYHPk6mjJZkPymLgsgb7
	 J+JrqYM/Sb3rLpeninwzWfAs1Iboi+xQccino6slp1uv5BTL4Obb7fAt5YPmcol4lcS2VR6g0Q+9
	 BcybfBRT8ds8T5lOc5rZmySfJxWNZ2vTJhSCFrnkZ69bfU6/NV39nMQwM+OjlZT4i6hDM/SeIA0Z
	 8zRQob2POetYUX8rIj90K70pYasoW3AkOOF5y+akwV25fBDUYdwItEBgg7JACTyX3s8uKb8BRZq9
	 gzTVLVHz76JqRP1wlIRBLNq7Oohfi5hyhhH0ubZMLahfrRfqJfd4+NQfOPlzViLCEoYagIfupD3s
	 6fvwzKxuTXSfcQeqowXUVMjmORQvZu8xPdvuEWm0DWDCoA3xV5C9v0Ij8xha7Z876zQ+0voY/xSv
	 43wjTaX9QR51AqshI/Vj7x4VHefgiHspWhNNh1SP4VXD+VFrw5FYJken6SPM1Z4enmHpAyCK+Axs
	 ZGKFfn9b2P4+IsS72pKqC13oGN5g6Xa7ASiYte3QvkFYH8fkh7wG/eLxdby5qP59LktmpVhVdRay
	 ObNLlqtvB13ALdygzxY2p4umol48PK5Hdy5s3g1y1VTpRvuiWYjDAzmLK3KY57hIc4jFNsG5XmlG
	 1bN1NOscZ14R0wo0mt3IBEojXoxs0ir9NH3qpIb6YB4A6ee0ekqiiJZkBNuMU8nUddLl23Q9a5zJ
	 xDqXb6bAe/7s4rvyxCR4ypaqV0qZS6ERnH7Y0qi9gESjYg0bvSVHE/rcNFIwuiptqna3UokJVN9D
	 H3+pzw9V45UaVeX7QbWUL/f8ZKw1EGs6+0UismZjP4FJUN4vTkHvkNL2R05M0=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-OQ-MSGID: <13b1e03e-a5b8-4b91-ab09-74f273fe9fcb@qq.com>
Date: Sun, 31 May 2026 20:21:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/9] mm: admit large swapin by backend range in
 swapin_sync()
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@meta.com>, Usama Arif <usamaarif642@gmail.com>,
 Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com>
 <CAMgjq7AA_1esgtA8VyxaBLWBBRM12bCBpxO2Jch5OESBZSg--A@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAMgjq7AA_1esgtA8VyxaBLWBBRM12bCBpxO2Jch5OESBZSg--A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6266F18000B
X-Stat-Signature: uxfodojkqphbr7dn6p15juggeqs93s18
X-Rspam-User: 
X-HE-Tag: 1780230073-580642
X-HE-Meta: U2FsdGVkX1+kEhpHYjha4sxeX8adtSUtp0GKc8fi8armlTQkNy7iXXmwVnTobV1+t8HWb1+Hfnc6RI8bpkmodfyBD40ZEbMvg2T2JO7/akUhXgrefowWlsrj3sRZXLaD0lp/1XyeKrn3qkI5f3k8zh8CevllpHWEnIPiXuON39bUuQH850oox0M3lBv+SOu5IFf2OoYWWb8JrGUBqV40jsBXqVFAKkdYMzxTs3rLhGDGYjFTiZLpp/FWui9GDoSNmLq0+EASGmC7oazqa6zYuKbdSRV0akLWFlHA0YlE0ErrUPYNeIbrXSYDSXU4djtfoIpYEiZUtcH+Qg0v5zGrMGVvetyfgpoh/ITiG6yqne4GZKdaofsRcjU80WzwSmNaatooaLIo6fZOssz6jenteA7ztG3gNwx2izwRBeeL1Kz8HWUnktK1a20TwJg9HbVs+n9w/LYdBgToXvUpGLiIMl6VoUfg/CjiVLr1ilJXUvvJz2ay+PCbhK5TXJHDWI3BM/voV1lTy4+b0zwtKeqwuYKu6+HweQ09U15m6IuqD9FsUIcGN0CtFEy33EDXYUj3l54Jj2mN9VBr5RkKXtWb/gRQeDu5vfo7axmMcl1Pvyxet8Y/urM7AMP4KgyOoZQQkGIg67y695g/m7OcnrwV94BU68SVzsCrwz9EAvVBiSjRrBijQUUF0HWN4tSO7xxiB3grPnbO5gje+TrnScZizouqWASjsr1bBt31EuYPQXusOBQB5Wmfkr7rRNh8RbCgQS0e6JJZ+5rDNJiu4e2ivvWEHpe5OlVMu3qdaW1s51U0blF/GzAz+5jLYmxiK5EJvsnuV7LhjjOg2X/wtQJ+l+5QKMs0qMQ7ZAPr79ICDOMtgvhx/rKOaGOSU0AE0ncxVJ7994K+BR8WSTp16tqq149s9zGEhIiixDcfgDN8qZmenZ7+MpVFWVBBTSTOcH3AHWIVWFkGUiO2C3R04St
 IWNUL5FM
 TnlglT/nzcRsxWuFpVbuza2TSN0HbYo+EX6l7FqKPi1pzQArsb6OWA5aU8FJcZAZeXB0nUjpXMdw5l3pZiV6p2eMRGxRR8lewYv4HGt39VgmmHHetPXO2a2e03uH0Os65ZNN2GwbfnPK7QCBujFDVKaQXNJCz3P6epkuKvw1m7KZXxr7lmXH3nwAHg+NUW7GdiUxtJHZu2QPbtl4QMUkHSGft5NbTfBt0edIEUvWbw7zDY2Aqbe6XifgbRe+8/wezVHjS45TiebHB4B8PqY+ck/eYwCRhu+8YCikfFaXUgbVV7+/5Qp7npPLDST3p0d5L65sr+GDlycheWZBoJt3Mp5ljKtrQm2Ul5DI6U4ZzaR+gk0VfHobgNKyI2Po8nWSmBQPwg3PC739AmqFl9Fh7uY0RhSQzLonp0f9Q3zF0RxIhb7MYeIbJRWyww6BVC6qGZUL8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/29/2026 10:43 PM, Kairui Song wrote:
> On Fri, May 29, 2026 at 8:26 PM fujunjie <fujunjie1@qq.com> wrote:
>>
>> A large swapin can only read one folio when the whole range has compatible
>> backing. Mixed zswap/disk ranges must not reach large-folio IO, and zswap
>> range probes are only snapshots.
>>
>> Filter the orders passed to swap_cache_alloc_folio() in swapin_sync().
>> Uniform zeromap ranges and all-disk ranges keep the existing large swapin
>> path. Fully zswap-backed ranges may be tried. Mixed zswap/disk ranges fall
>> back before allocation.
>>
>> After a large swapcache folio is installed, recheck the zswap range and
>> drop the fresh folio if it became mixed. Also consume -EAGAIN from
>> swap_read_folio() the same way. Both cases retry order-0, where each slot
>> can resolve its current backend independently.
>>
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
>>  mm/memcontrol-v1.c |   8 ++-
>>  mm/memory.c        |  31 ++++++++-
>>  mm/swap_state.c    | 169 ++++++++++++++++++++++++++++++++++++++++++---
>>  3 files changed, 194 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
>> index 765069211567..5b11b8055c66 100644
>> --- a/mm/memcontrol-v1.c
>> +++ b/mm/memcontrol-v1.c
>> @@ -682,8 +682,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
>>   * memcg1_swapin - uncharge swap slot on swapin
>>   * @folio: folio being swapped in
>>   *
>> - * Call this function after successfully adding the charged
>> - * folio to swapcache.
>> + * Call this after the charged folio has been added to swapcache and the caller
>> + * is no longer going to drop it back to swapped-out state.
>>   *
>>   * Context: The folio has to be in swap cache and locked.
>>   */
>> @@ -721,7 +721,9 @@ void memcg1_swapin(struct folio *folio)
>>         id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
>>                                  nr_pages);
>>         swap_cluster_unlock(ci);
>> -       mem_cgroup_uncharge_swap(id, nr_pages);
>> +
>> +       if (id)
>> +               mem_cgroup_uncharge_swap(id, nr_pages);
>>  }
>>  #endif
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 5a365492a9a2..d73a19692dea 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4538,6 +4538,24 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>>                 folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
>>  }
>>
>> +static void memcg1_swapin_retry_folio(struct folio *folio,
>> +                                     struct vm_fault *vmf)
>> +{
>> +       if (!folio_test_large(folio) || !folio_test_swapcache(folio))
>> +               return;
>> +
>> +       if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT) {
>> +               if (!folio_trylock(folio))
>> +                       return;
>> +       } else {
>> +               folio_lock(folio);
>> +       }
>> +
>> +       if (folio_test_large(folio) && folio_test_swapcache(folio))
>> +               memcg1_swapin(folio);
>> +       folio_unlock(folio);
>> +}
>> +
>>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
>>  {
>>         vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>> @@ -4857,8 +4875,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>
>>         swapcache = folio;
>>         ret |= folio_lock_or_retry(folio, vmf);
>> -       if (ret & VM_FAULT_RETRY)
>> +       if (ret & VM_FAULT_RETRY) {
>> +               memcg1_swapin_retry_folio(folio, vmf);
>>                 goto out_release;
>> +       }
>>
>>         page = folio_file_page(folio, swp_offset(entry));
>>         /*
>> @@ -5067,6 +5087,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>         if (unlikely(folio != swapcache)) {
>>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>>                 folio_add_lru_vma(folio, vma);
>> +               if (folio_test_large(swapcache))
>> +                       memcg1_swapin(swapcache);
>>                 folio_put_swap(swapcache, NULL);
>>         } else if (!folio_test_anon(folio)) {
>>                 /*
>> @@ -5076,6 +5098,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
>>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
>> +               if (folio_test_large(folio))
>> +                       memcg1_swapin(folio);
>>                 folio_put_swap(folio, NULL);
>>         } else {
>>                 VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
>> @@ -5132,8 +5156,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>         if (vmf->pte)
>>                 pte_unmap_unlock(vmf->pte, vmf->ptl);
>>  out_page:
>> -       if (folio_test_swapcache(folio))
>> +       if (folio_test_swapcache(folio)) {
>> +               if (folio_test_large(folio))
>> +                       memcg1_swapin(folio);
>>                 folio_free_swap(folio);
>> +       }
>>         folio_unlock(folio);
>>  out_release:
>>         folio_put(folio);
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index d37097913b30..f03ad4832f16 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/migrate.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/huge_mm.h>
>> +#include <linux/zswap.h>
>>  #include <linux/shmem_fs.h>
>>  #include "internal.h"
>>  #include "swap_table.h"
>> @@ -403,7 +404,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>>  static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>                                         swp_entry_t targ_entry, gfp_t gfp,
>>                                         unsigned int order, struct vm_fault *vmf,
>> -                                       struct mempolicy *mpol, pgoff_t ilx)
>> +                                       struct mempolicy *mpol, pgoff_t ilx,
>> +                                       bool defer_memcg1_swapin)
> 
> Hi Fujunjie,
> 
> Thanks for the update, but this whole defer_memcg1_swapin thing is so
> ugly I don't think this is the right way at all.
> 
> If you really need this, maybe you can always defer the memcg1
> uncharge, I don't see why we need to treat large folio differently.
> This charge doesn't effect the memory pressure, the reason we uncharge
> memcg1's swap counter is to avoid long pinning swap cache holding the
> swap cache of a cgroup so the cgroup will no longer be able to swap
> out more folios. Deferring it won't hurt.

Yes, I think you are right.

I added defer_memcg1_swapin because I was still treating the freshly
allocated large swapcache folio as something that might be dropped after it
was installed, so I tried to avoid clearing the cgroup v1 swap owner too
early.

Nhat Pham also pointed out that this is probably the wrong model. Once the whole
range is covered by the large swapcache folio, zswap writeback should not be
able to turn one subslot into disk-backed state, since it has to allocate an
order-0 swapcache folio first and that should fail.

So the deferred memcg1 handling is likely self-inflicted complexity. I'll
drop this flag and rework the mixed-backend check so we fail the current
order before we need this late abort path. If any memcg1 timing issue remains
after that, I'll try to handle it with a uniform rule rather than a
large-folio-specific flag.
> 
>>  {
>>         int err;
>>         swp_entry_t entry;
>> @@ -466,7 +468,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>         }
>>
>>         /* memsw uncharges swap when folio is added to swap cache */
>> -       memcg1_swapin(folio);
>> +       if (!defer_memcg1_swapin || !order)
>> +               memcg1_swapin(folio);
>>         if (shadow)
>>                 workingset_refault(folio, shadow);
>>
>> @@ -495,9 +498,12 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>   * Return: Returns the folio if allocation succeeded and folio is in the swap
>>   * cache. Returns error code if failed due to race, OOM or invalid arguments.
>>   */
>> -struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
>> -                                    unsigned long orders, struct vm_fault *vmf,
>> -                                    struct mempolicy *mpol, pgoff_t ilx)
>> +static struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry,
>> +                                             gfp_t gfp, unsigned long orders,
>> +                                             struct vm_fault *vmf,
>> +                                             struct mempolicy *mpol,
>> +                                             pgoff_t ilx,
>> +                                             bool defer_memcg1_swapin)
>>  {
>>         int order, err;
>>         struct folio *ret;
>> @@ -512,7 +518,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
>>
>>         do {
>>                 ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
>> -                                        vmf, mpol, ilx);
>> +                                        vmf, mpol, ilx,
>> +                                        defer_memcg1_swapin);
>>                 if (!IS_ERR(ret))
>>                         break;
>>                 err = PTR_ERR(ret);
>> @@ -525,6 +532,124 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
>>         return ret;
>>  }
>>
>> +struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
>> +                                    unsigned long orders, struct vm_fault *vmf,
>> +                                    struct mempolicy *mpol, pgoff_t ilx)
>> +{
>> +       return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
>> +                                       mpol, ilx, false);
>> +}
>> +
>> +static struct folio *swap_cache_alloc_speculative_folio(swp_entry_t targ_entry,
>> +                                                       gfp_t gfp,
>> +                                                       unsigned long orders,
>> +                                                       struct vm_fault *vmf,
>> +                                                       struct mempolicy *mpol,
>> +                                                       pgoff_t ilx)
>> +{
>> +       /*
>> +        * Speculative large swapin may drop this fresh swapcache folio and
>> +        * retry order-0 after backend or page-table revalidation. Keep the
>> +        * cgroup v1 memsw swap owner until the caller commits the folio.
>> +        */
>> +       return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
>> +                                       mpol, ilx, true);
>> +}
>> +
>> +static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages)
>> +{
>> +       unsigned int ci_start = swp_cluster_offset(entry);
>> +       struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
>> +       bool is_zero;
>> +       unsigned int i;
>> +
>> +       if (ci_start + nr_pages > SWAPFILE_CLUSTER) {
>> +               VM_WARN_ON_ONCE(1);
>> +               return false;
>> +       }
>> +
>> +       rcu_read_lock();
>> +       if (!rcu_dereference(ci->table)) {
>> +               rcu_read_unlock();
>> +               return true;
>> +       }
>> +
>> +       is_zero = __swap_table_test_zero(ci, ci_start);
>> +       for (i = 1; i < nr_pages; i++) {
>> +               if (is_zero != __swap_table_test_zero(ci, ci_start + i)) {
>> +                       rcu_read_unlock();
>> +                       return false;
>> +               }
>> +       }
>> +       rcu_read_unlock();
>> +
>> +       return true;
>> +}
>> +
>> +static unsigned long swapin_admit_orders(swp_entry_t entry,
>> +                                        unsigned long orders)
> 
> And this swapin_admit_orders chunk doesn't look good either...、

Yes, this helper is doing too much.
I wanted to keep mixed zswap/disk ranges away from large-folio IO, but this
ended up mixing policy with range feasibility checks.

> 
>> +{
>> +       unsigned long candidates = orders & ~BIT(0);
>> +       unsigned long admitted = orders & BIT(0);
>> +       int order;
>> +
>> +       if (!candidates)
>> +               return orders;
>> +
>> +       while (candidates) {
>> +               enum zswap_range_state state;
>> +               unsigned int nr_pages;
>> +               swp_entry_t range_entry;
>> +               bool admit = false;
>> +
>> +               order = fls_long(candidates) - 1;
>> +               if (order > MAX_PAGE_ORDER) {
>> +                       candidates &= ~BIT(order);
>> +                       continue;
>> +               }
>> +
>> +               nr_pages = 1U << order;
>> +               range_entry = swp_entry(swp_type(entry),
>> +                                       round_down(swp_offset(entry), nr_pages));
>> +               if (!swapin_zeromap_same(range_entry, nr_pages))
>> +                       goto next;
> 
> I think you don't need to test zeromap at all? __swap_cache_alloc
> handles that already.

I am sorry for missed that this is already covered by __swap_cache_add_check().
I'll drop the explicit zeromap scan in v3 version.

> 
>> +
>> +               state = zswap_probe_range(range_entry, nr_pages);
> 
> If you just move the zswap_probe_range into __swap_cache_alloc and do
> fallback there (or maybe you can shrink the order faster), then this
> two new helpers are all redundant.
> 
>> +               switch (state) {
>> +               case ZSWAP_RANGE_MIXED:
>> +                       break;
>> +               case ZSWAP_RANGE_ALL_ZSWAP:
>> +               case ZSWAP_RANGE_NEVER_ENABLED:
>> +               case ZSWAP_RANGE_NO_ZSWAP:
>> +                       admit = true;
>> +                       break;
>> +               }
>> +
>> +next:
>> +               if (admit)
>> +                       admitted |= BIT(order);
>> +               else
>> +                       count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
>> +               candidates &= ~BIT(order);
>> +       }
>> +
>> +       return admitted ? admitted : BIT(0);
>> +}
>> +
>> +static bool zswap_needs_order0_retry(struct folio *folio)
>> +{
>> +       if (!folio_test_large(folio))
>> +               return false;
>> +
>> +       /*
>> +        * Admission sees only an advisory zswap snapshot. Recheck after the
>> +        * large swapcache folio is installed; if the range became mixed, drop
>> +        * the fresh folio before IO and let order-0 handle each slot.
>> +        */
>> +       return zswap_probe_range(folio->swap, folio_nr_pages(folio)) ==
>> +              ZSWAP_RANGE_MIXED;
>> +}
>> +
> 
> Again, I think you can just probe the suitable size in
> __swap_cache_alloc directly, that way, we avoid the diverge of sync /
> non-sync device, and avoid the whole chunk making the code much
> simplier too, just like what we are alreadying doing for zero map in
> __swap_cache_alloc, or am I over simpliying it?Thanks for your review! I will try it.


