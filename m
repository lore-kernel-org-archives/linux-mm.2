Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50EDCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A266B0301; Mon,  1 Jun 2026 05:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BAF6B0303; Mon,  1 Jun 2026 05:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57CE6B0304; Mon,  1 Jun 2026 05:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D243F6B0301
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:47:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A0DAC22D1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:47:17 +0000 (UTC)
X-FDA: 84830865714.15.B58130F
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB01FA000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:47:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=PrAfqeV0;
	spf=pass (imf25.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.236 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780307235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMqwrr8u5pYCeIw/PApgz03U97VeplrhWhprOu8NgIU=;
	b=kfiL7ofi4YZMx2LMET+PSLsmk9VgtR5dVLGXMRBrv/hBiUbaBXTI4upyfEBX0YEP8rLxAY
	edwLTdIN2PulvM+vqkMVFnwj+cxKfRW+WQiEIvfDCr8cJ4l7aXJG+QCv1vy/LQDV2q0c1L
	WUj7Wpc9ByyNr89/m0bY1ZmYMKxoF44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780307235; a=rsa-sha256;
	cv=none;
	b=q2pHJGznIXvd5Z8KDRsV4DUfHwEyJs73thgagfNNeqrQWxLrr7QJKJmkowSsGfcNkvNr0k
	NNYZZQ1GzTvPmR4Ml0QtHpAMuSbc1Z9i6mZg717iIfofVDKNmOOyeHM5uYP6YxH1HHLmIX
	NQ5rlCJq7dlytAIHpkA5XEaHOCCljdI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=PrAfqeV0;
	spf=pass (imf25.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.236 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780307230; bh=eMqwrr8u5pYCeIw/PApgz03U97VeplrhWhprOu8NgIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PrAfqeV0pdFNWcCr3iZCqKphK3C9YN+BhoCGp+RbtfpgO8irwMg3gmroW/S8DfB2J
	 4oqpgxdC6AhHM5CzS52muYgdAEt5NvnS4QUyThny9CkHBAZhxH74XzSIrdLQoHtDhM
	 3qVnDL6ew7rQawb/f7ofyGaQ0UhmEeuz0kpcrv08=
Received: from [192.168.31.251] ([36.112.3.38])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id BC59D48D; Mon, 01 Jun 2026 17:47:05 +0800
X-QQ-mid: xmsmtpt1780307225te5erbruk
Message-ID: <tencent_F532C5B6F91A8FF411BB1B3E8B27AEB6E707@qq.com>
X-QQ-XMAILINFO: Mkw1Oys1xyjCtnCf5TdxDiJhwoqNWpzPrZFYcnZ9WJ1YZ5IlXpokWp1u86XQYU
	 e2k2uufxCNvj9nkx6hO3Ix03s6XFq33OEUd/rmB4YF3AArDc5saiaGlkxNv1OQRkwXmU5v+3isH2
	 7FukhsD7FX+D+rd8AfhsVk7JWZ7xGvIw2BMKDV7SbyoY+PgAj6Smb+GIWj6M1ZsHPGbEhEn30AKA
	 j8ux7b6z/ZpcER5o7E32idXaw/9fSYns35gAarQUzeyvPRe3uId36pi352zMhzPCUY7NMuzaJwPR
	 AJNDozmSlXVdgzZ11AqYjttlEakXhXf5/LzydUolhCmbXOCj+l0DT48DDmoNr3S49jBajh8B7kcX
	 jiwsORodVHRhsy4IxoIj0l6CqxwGzfpqFPWnVf37PBabNiMg4AkUJQxJ/xbNRtH2jNSwmXPuuEF8
	 V3ihnlkDDR8SGpg8uG0Pm1FJLT8vr02D7aGMT+UXOkKe+mq//ijHI2NlcLxYgI2/dXk9pRLQr3J9
	 EnEZnX0nKVESGPg4LpcBi475SfjeCL764tPrz9sDA2lWOslnGl82bFf38kFNZwoDM6vUWnQ6Wbz5
	 sOnqcVgsbC0CwNVmxnKLJzl/zbQ/VOJozK9CSXay90V47qQIpc7krUrMedQ7hzo23dfH2tVsFBiQ
	 HecPmwcYJFSSPCOvOrNyShWtTWhupicHFkyFfZkQzVv9AqL5uTzDivtEC/eV7dw3DaM8G+5bOjJu
	 2WgI0nQt5R2U67QfWD37rHGnqIdOgihXE7RhgGocEoicM/CoS2WwxQVVTeqTZ9t4Vmxjca4to0cT
	 UlFGKCRcz44+fUqmb1dmALQr5Ci98becGaO1BNMTGuGllUhXg9QMpKfS2CjJp2HYs8c8uHLtGxkR
	 pFlX4duDxrol+NXpiP3cwmtNARHokrd6d3w5c2+sOyrbp618T1Oo5uC1BtPi0LNpWMjznGsFNx3K
	 yoJ5c+cQdL3oG2BEVA0E7QxV2+0dDun6WutGaMUuKjBolJdZl/tQ3QxSVYIPGEkTjyKToM4uEw7w
	 FnFePbmuAaqNVrjcSyjALxtJQlMqVAmt907P3DvT96lpGzBa6GyDOEstVLf/I=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-OQ-MSGID: <1d67dd4d-7fc7-483d-8d46-d69f139ad3ba@qq.com>
Date: Mon, 1 Jun 2026 17:47:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 5/9] mm: add common locality admission for zswap
 large swapin
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>,
 Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <tencent_69E7033C2446FE6E922D28B82E9F59142D09@qq.com>
 <CAKEwX=O_Jt3aCxocDoY1h5AY=-eOYnj_0saQ4rMbdfnLzPAFxw@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAKEwX=O_Jt3aCxocDoY1h5AY=-eOYnj_0saQ4rMbdfnLzPAFxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BB01FA000F
X-Stat-Signature: 7547fmduzkon8wj4p46gwqsz8rs3we8b
X-Rspamd-Server: rspam06
X-HE-Tag: 1780307234-960276
X-HE-Meta: U2FsdGVkX1/GcHBz1zbRZknVchf/Qd4AiB5vLbKY2qOIrtj8S/4UQifjcQvsHDxeQPP0a4khpHYShpy5Yxn80+KC+Bd68D30M2xEUAs9LHYU/0wDKtB74v1UYtu96RB3p5I6euAmyKHXJXfbDmRgYUCOUSQkB28Ko+lQAoqXMgmu1seYFwGemlS57twz6cDgrwr/07wozj3tMjRtjyykgx8hlonm/Tr/ctrQuRzE0NDvMNrKdRMMP1u9LF/otThkyF5csZwUzzQ134VnRYqvhkEIPUiOI15sJMswMpdtj8lzSTk0ZwixOICHkpVzpsBTV3cKEZSyXpWFHbREVgmZr7QPaUzKGbWQK3T5X8SXE+MgRGzGuj9jjNLG21gW7SdwvRy1xo7O8rePpRAZa7lYMKnnwkXhdwCt303p7KxN6kd3mJxGTMoLLBldCzA1XtARz+V7/6y/8AmS1qHxUBgi7HOhxlpVNsV/Ni4NqUXVa+1VneHLC6+Hwp7t7FO83JAxIUq2KrlLkNKZ2GNSG0cOyYrc+6LhP4SSx0ya4Lu3azYC0LngVxWM+5dIOoVsep8kr8fM+cutAHJs3SUFxFsROIXbhqoeSHOeU1+iiS4h8YKN0hJjjRTUt4Y//8NYE+22pzzZhUolOhgMw18xmh+DMEXDDn2CxlEDEEivm4PrXFPdpvk/PYDN+66mZmjEpWieu1OXfGiNh5O9TSQzcZWkImFHAhxl++7gw/x9a4+Rb5xwBcplrfzDyIkY1DMf7EVlDKBTgpLAjq0DHUbVx6NSiQlZCZ4F9Yfga10xXoIGT1OfKU8InpEn96gQc8gh37tYU+qfbGP2+qsPWd96/MhXIjOXdFXQTGLK54z4FWsb6WG96xAdX0wDVtmVIvCyu5DmOH99FMK6n36yqa6eGBwButpb1jPF0sptlV6lvVMK7motH2Q+MuRANdB3znf2lXaM9zVrfL+94O3ZRM1ITfG
 IRhwppov
 4WL4DrrQ8Gr1efPKXL6m4tZNS7yPV694iY4Cj+FxVVEu16nUIp3fLKiS15sqraPkpSvEuft06cKELhNzl0K0cXwKmGtyHhOjoxXuU1GdKTumP9tl6tTC3KhCJG+Mgxsy8mw8DSbH3gn2BW+dnY77hmvYNM6UywhI/7R9w03VK1Zjk7BWDMStPn5Bppn+L2VuTa2ZfVyBABFcEZMGu/uh3U3q+3Onse3jHhoPTbnlT+n2lnzRnExdySZ8QzU15NViD+Tu0IFXV+Ykk49USW6SFYu726cFkr+ToFHIp7TK22m90gPn2zJldEZRI1g228TOX4jHabAFv7yM9O0HvNzAKNAjBxWH+RTNo1VlkV8ShB93MSKQo0Gq5PM/GBcMt8VD+CiPc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/2026 3:00 AM, Nhat Pham wrote:
> On Fri, May 29, 2026 at 5:19 AM fujunjie <fujunjie1@qq.com> wrote:
>>
>> Fully zswap-backed ranges are safe to load as a large folio only when
>> the caller has a reason to expect the neighbouring slots to be useful.
>> Otherwise a sparse refault can turn one 4K demand fault into a 64K
>> decompression and swapcache fill.
>>
>> Add a common admission gate for zswap-backed large swapin. The common
>> layer keeps backend checks, the 64K cap, recent-refault rejection, and
>> zswap reclaim-pressure rejection. It consumes a caller-provided locality
>> order mask instead of looking at anon or shmem state directly.
> 
> Can you add more documentation about these policies, both in patch
> changelog and in code? I'm pretty confused by the
> zswap_pool_reclaim_pressure heuristics, for e.g
> 
You're right, this should have been documented much better, and I think the
heuristic itself needs another look.

The intent was not to block demand swapin when zswap is under pressure. It was
only meant to block speculative large zswapin. Even after locality_orders
admits an order, that is still only evidence that the neighbouring slots are
likely useful; it does not prove that the whole large folio will be consumed
soon enough to justify the extra resident memory under pressure.

In this RFC, the cost is also higher because of my late mixed-backend fallback
design. I kept the zswap entries after filling the large swapcache folio, so
that the fresh large folio could still be dropped and retried as order-0 if a
late mixed-backend race was detected. With that design, a large zswapin does
not immediately reduce the zswap pool: the uncompressed large swapcache folio
and the compressed zswap entries can exist at the same time until the swap
slots are freed.

I used zswap_pool_reclaim_pressure() as a rough signal for avoiding that extra
speculative expansion. My assumption was that a zswap pool that has reached
its limit is often correlated with memory pressure. But that is not a strict
relationship, and I did not validate this heuristic rigorously. Sorry, this
was too under-explained and probably too ad hoc in this RFC.

Your earlier point also makes me think the design is over-defensive. Once the
large swapcache folio is installed, zswap writeback should not be able to turn
one slot in the range into disk-backed state, since it first has to allocate
an order-0 swapcache folio. For v3 I will revisit the completion rule first:
drop the late mixed-race -EAGAIN path, decide whether a successful large load
should consume zswap entries like the order-0 path, and then either remove
this pressure heuristic or keep it only with clearer documentation and
specific experiments.

>>
>> Callers pass no locality evidence for now, so this patch only installs
>> the common policy hook. Later patches add anon and shmem producers.
>>
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
>>  mm/memory.c     |   2 +-
>>  mm/shmem.c      |   2 +-
>>  mm/swap.h       |   8 ++--
>>  mm/swap_state.c | 118 ++++++++++++++++++++++++++++++++++++++++++++----
>>  4 files changed, 117 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index d73a19692dea..92a82008d583 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4849,7 +4849,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
>>                         folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
>>                                             thp_swapin_suitable_orders(vmf) | BIT(0),
>> -                                           vmf, NULL, 0);
>> +                                           0, vmf, NULL, 0);
>>                 else
>>                         folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 56c23a7b15c7..fa99b48ed62b 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2031,7 +2031,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>
>>  again:
>>         mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
>> -       folio = swapin_sync(entry, gfp, BIT(order), vmf, mpol, ilx);
>> +       folio = swapin_sync(entry, gfp, BIT(order), 0, vmf, mpol, ilx);
>>         mpol_cond_put(mpol);
>>
>>         if (!IS_ERR(folio))
>> diff --git a/mm/swap.h b/mm/swap.h
>> index ea7e1f3c4410..dd35a310d06d 100644
>> --- a/mm/swap.h
>> +++ b/mm/swap.h
>> @@ -323,9 +323,10 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
>>                 struct mempolicy *mpol, pgoff_t ilx);
>>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
>> -               struct vm_fault *vmf);
>> +                       struct vm_fault *vmf);
>>  struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
>> -                          struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx);
>> +                         unsigned long locality_orders, struct vm_fault *vmf,
>> +                         struct mempolicy *mpol, pgoff_t ilx);
>>  void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>>                            unsigned long addr);
>>
>> @@ -418,7 +419,8 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
>>
>>  static inline struct folio *swapin_sync(
>>         swp_entry_t entry, gfp_t flag, unsigned long orders,
>> -       struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
>> +       unsigned long locality_orders, struct vm_fault *vmf,
>> +       struct mempolicy *mpol, pgoff_t ilx)
>>  {
>>         return NULL;
>>  }
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index f03ad4832f16..5a4ca289009a 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/migrate.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/huge_mm.h>
>> +#include <linux/sizes.h>
>>  #include <linux/zswap.h>
>>  #include <linux/shmem_fs.h>
>>  #include "internal.h"
>> @@ -556,6 +557,24 @@ static struct folio *swap_cache_alloc_speculative_folio(swp_entry_t targ_entry,
>>                                         mpol, ilx, true);
>>  }
>>
>> +/*
>> + * Initial conservative cap for speculative zswap large swapin. Locality
>> + * evidence is supplied by the caller or by generic VMA hints; the common
>> + * swapin layer keeps backend safety and pressure decisions here.
>> + */
>> +#define SWAPIN_ZSWAP_MAX_SIZE                  SZ_64K
>> +#if PAGE_SIZE < SWAPIN_ZSWAP_MAX_SIZE
>> +#define SWAPIN_ZSWAP_MAX_ORDER                 \
>> +       ilog2(SWAPIN_ZSWAP_MAX_SIZE / PAGE_SIZE)
>> +#else
>> +#define SWAPIN_ZSWAP_MAX_ORDER                 0
>> +#endif
>> +
>> +struct zswap_admit_ctx {
>> +       bool pressure_checked;
>> +       bool reclaim_pressure;
>> +};
>> +
>>  static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages)
>>  {
>>         unsigned int ci_start = swp_cluster_offset(entry);
>> @@ -586,11 +605,84 @@ static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages)
>>         return true;
>>  }
>>
>> +static bool swapin_zswap_locality(struct vm_fault *vmf, unsigned int order,
>> +                                 unsigned long locality_orders)
>> +{
>> +       struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
>> +
>> +       if (!order || order > MAX_PAGE_ORDER)
>> +               return false;
>> +
>> +       if (vma && (vma->vm_flags & VM_RAND_READ))
>> +               return false;
> 
> what about VM_SEQ_READ?
This helper is meant to consume locality_orders, not to produce locality
evidence itself. VM_SEQ_READ is handled by the caller-side locality producer:
the anon producer returns all candidate orders for VM_SEQ_READ, and the shmem
producer does the same for now.

I kept the check in the common helper mostly as a common veto for the readahead path where ra_orders are passed as locality_orders directly.

I think the cleaner fix is to move this into the producer side as well.

> 
>> +
>> +       return locality_orders & BIT(order);
>> +}
>> +
>> +static bool swapin_zswap_refaulted(swp_entry_t entry, unsigned int nr_pages)
> 
> nit: this does not seem zswap-specific. Just call it
> swapin_range_refaulted or sth like that, maybe?
> 
>> +       for (i = 0; i < nr_pages; i++) {
>> +               bool workingset;
>> +               void *shadow;
>> +
>> +               shadow = swap_cache_get_shadow(swp_entry(type, offset + i));
> 
> This seems inefficient. Can't we just lock the swap cluster once,
> check all the shadow in the range, instead of repeatedly getting then
> dropping the swap cluster lock?
both points make sense.

The refault check is not zswap-specific, so I will rename it to something like
swapin_range_refaulted().

And yes, the current implementation is too expensive. The range is already
bounded and contiguous, so I should check the swap table under one cluster lock
instead of calling swap_cache_get_shadow() for every slot. I will rework that
in v3.

> 
>> +               if (!shadow)
>> +                       continue;
>> +               if (workingset_test_recent(shadow, false, &workingset, false) &&
>> +                   workingset)
>> +                       return true;
>> +       }
>> +
>> +       return false;
>> +}
>> +
>> +static bool swapin_zswap_admit(swp_entry_t entry,
>> +                              unsigned int order, unsigned int nr_pages,
>> +                              struct vm_fault *vmf,
>> +                              unsigned long locality_orders,
>> +                              struct zswap_admit_ctx *ctx)
>> +{
>> +       if (order > SWAPIN_ZSWAP_MAX_ORDER)
>> +               return false;
>> +
>> +       /*
>> +        * Treat zswap-backed large swapin as speculative. The common layer
>> +        * consumes caller-provided locality orders, but does not inspect
>> +        * anon-specific PTE state or shmem-specific mapping state directly.
>> +        */
>> +       if (!swapin_zswap_locality(vmf, order, locality_orders))
>> +               return false;
>> +
>> +       /*
>> +        * A recent workingset refault shadow in the target range means reclaim
>> +        * already saw churn there. Keep the refault path narrow instead of
>> +        * speculatively decompressing neighbouring slots.
>> +        */
>> +       if (swapin_zswap_refaulted(entry, nr_pages))
>> +               return false;
> 
> Hmm this depends. If it's just a refault coming from a speculative
> read (readhead or THP (z)swpin), which is then promptly discarded,
> then yeah we should backoff here. But maybe the refaulted page is
> workingset one?
> 
> But yeah I guess it is better to be cautious when you are uncertain :)
> 
> 
>> +
>> +       if (!ctx->pressure_checked) {
>> +               ctx->reclaim_pressure = zswap_pool_reclaim_pressure();
>> +               ctx->pressure_checked = true;
>> +       }
> 
> Why do we backoff if there is zswap_pool_reclaim_pressure (which only
> check if the pool is full ONCE in its lifetime)? What's the rationale
> here?
The ctx is only local to one swapin_admit_orders() call. It is initialized
before walking the candidate orders, so pressure_checked is not persistent
across faults and is not tied to the lifetime of the zswap pool.

It is also not there because zswap_pool_reclaim_pressure() is expensive. That
helper is cheap. The point was to use one consistent pressure snapshot while
evaluating all candidate orders for the same fault, instead of letting
different orders observe different pressure states.

The zswap state being read is not "full once forever". It is
hysteretic: zswap_check_limits() sets zswap_pool_reached_full when the pool
reaches the max limit, and clears it after the pool drops below the accept
threshold.

The rationale for backing off was conservative: I treated zswap pool pressure
as correlated with memory/reclaim pressure. With this RFC's current design,
large zswapin can temporarily keep both the compressed zswap entries and the
uncompressed large swapcache folio, so I wanted to avoid that speculative
expansion when the compressed pool already looks stressed.

> 
>> +       if (ctx->reclaim_pressure)
>> +               return false;
>> +
>> +       return true;
>> +}
>> +
>>  static unsigned long swapin_admit_orders(swp_entry_t entry,
>> -                                        unsigned long orders)
>> +                                        unsigned long orders,
>> +                                        struct vm_fault *vmf,
>> +                                        unsigned long locality_orders)
>>  {
>>         unsigned long candidates = orders & ~BIT(0);
>>         unsigned long admitted = orders & BIT(0);
>> +       struct zswap_admit_ctx zswap_ctx = {};
>>         int order;
>>
>>         if (!candidates)
>> @@ -616,9 +708,14 @@ static unsigned long swapin_admit_orders(swp_entry_t entry,
>>
>>                 state = zswap_probe_range(range_entry, nr_pages);
>>                 switch (state) {
>> +               case ZSWAP_RANGE_ALL_ZSWAP:
>> +                       admit = swapin_zswap_admit(range_entry, order,
>> +                                                  nr_pages, vmf,
>> +                                                  locality_orders,
>> +                                                  &zswap_ctx);
>> +                       break;
>>                 case ZSWAP_RANGE_MIXED:
>>                         break;
>> -               case ZSWAP_RANGE_ALL_ZSWAP:
>>                 case ZSWAP_RANGE_NEVER_ENABLED:
>>                 case ZSWAP_RANGE_NO_ZSWAP:
>>                         admit = true;
>> @@ -769,8 +866,8 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>>         ret = swap_read_folio(folio, plug);
>>         /*
>>          * Swap readahead allocates order-0 folios. -EAGAIN is reserved for
>> -        * retryable large zswap backend races and must be handled by the
>> -        * synchronous common swapin path.
>> +        * retryable large zswap backend races and should never escape to this
>> +        * order-0 path.
>>          */
>>         VM_WARN_ON_ONCE(ret == -EAGAIN);
>>         if (readahead) {
>> @@ -786,6 +883,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>>   * @entry: swap entry indicating the target slot
>>   * @gfp: memory allocation flags
>>   * @orders: allocation orders
>> + * @locality_orders: orders with caller-provided locality evidence
>>   * @vmf: fault information
>>   * @mpol: NUMA memory allocation policy to be applied
>>   * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
>> @@ -794,16 +892,20 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>>   * existing folio in the swap cache for @entry. This initiates the IO, too,
>>   * if needed. @entry is rounded down if @orders allow large allocation.
>>   *
>> - * Context: Caller must ensure @entry is valid and pin the swap device with refcount.
>> + * Context: Caller must ensure @entry is valid and pin the swap device with
>> + * refcount.
>>   * Return: Returns the folio on success, error code if failed.
>>   */
>> -struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
>> -                          struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
>> +struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp,
>> +                         unsigned long orders,
>> +                         unsigned long locality_orders,
>> +                         struct vm_fault *vmf, struct mempolicy *mpol,
>> +                         pgoff_t ilx)
>>  {
>>         struct folio *folio;
>>         int ret;
>>
>> -       orders = swapin_admit_orders(entry, orders);
>> +       orders = swapin_admit_orders(entry, orders, vmf, locality_orders);
>>  again:
>>         do {
>>                 folio = swap_cache_get_folio(entry);
>> --
>> 2.34.1
>>


