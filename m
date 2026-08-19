Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61526C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EBE6B0098; Wed, 19 Aug 2026 08:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F306B009B; Wed, 19 Aug 2026 08:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565326B009D; Wed, 19 Aug 2026 08:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E71366B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:50:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CE1E1A056B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:50:59 +0000 (UTC)
X-FDA: 85118003838.06.A8687EB
Received: from mta1.migadu.com (out-253.mta1.migadu.com [95.215.58.253])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04CAC140002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:50:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JdPJee/e";
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787143857;
	b=akpmrmqse0EUx5iM76oHFpGxviLWgQpBYUGqQxtnH0p2RCBZwecZk65GLygjejGF9yh5su
	mfc7hd2y5MB6VptsbL93qhnz0DB/pO/DHijzsHapY8VTeoQ8pPI2H3UdeS8o4vB9K/dWMr
	uYy2JLkYUrWuUVhZs2u9sOklsWrNGLk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JdPJee/e";
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787143857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ui0sD6EXt6GPPYbXKrPSr9XEYg0MShUwiXEMJkgmdEo=;
	b=Utiv0eXeD2nDkd4O1iMbM8UMVLNDPCE1IMSTSCgdfRvAOq0y0+Dkc5EDGw8srtWpivayjX
	axJRPTUrOiz4lEB/lZ9lm9y1PzBscQtJPWeFxkoK9PSWwlLx9JOKckV0j46VCDX2aLAWF5
	dGFGMJrHsrKwdMljofbU5WQu+zh8T5s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FaLcnIZQQCyJBLufWv3s26tqVddfc3EknPROmkcgp9U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787143855; v=1; x=1787748655;
 b=JdPJee/eOZcq1DcR0W3b6f68KuYgfYKTojYw/wYI69T7eYldyGQGo4e7nIX27L6ay11iiu9N
 tX1KDKjP361dG44K3ALJZLYzTWUWMmNaJ+jNJz94W3VeYJ1kLrPRBUsRu37j0qS+LxE+R47j8CR
 WMqaqshoxV5dnDWTfHWjLKco=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:a428)
	by smtp.migadu.com with ESMTPS id 8b2f049e6c0f7c81;
	Wed, 19 Aug 2026 12:50:45 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <e9180bf3-b226-484f-bb9a-c23cd3f8efd2@linux.dev>
Date: Wed, 19 Aug 2026 13:50:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/12] mm: zswap: add range lookup for large-folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com,
 Alexandre Ghiti <alexghiti@fb.com>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-6-usama.arif@linux.dev> <aoSd8iovG5QKc6mT@google.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aoSd8iovG5QKc6mT@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 04CAC140002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xnjjhb4orcmqj3e841zgomwob51wwuct
X-HE-Tag: 1787143856-138055
X-HE-Meta: U2FsdGVkX1+N4Xxz12Gi5gXTOneKeGv9TuG/v6ou/3UiPHfWQMtoTZwzUPhSZGmulBSxYyZQxB+DhcDD7ZMgK95a1ndLHumD2CznEQsoPRB37i1wDpsnJPFarsOalAFwfOgJUwcevcbfaVCkrGtdcP6H/JEtVXy+yt+/MjWTGrgP/4CDMqwKmnyiIKxlEET5CFBYbiluffbM+dOR/8KS9ObH2RsDix6o0FRnkyA0+OOIKjFy1Q+RNY2hCc8C+M+mqgPNoLA6OB4rZhHKTO3pL/pbzixIw2xPq3hxjBJnomCky2xjfB1rxMNvHxkC7Qw6C//ZlJgzcHSs7ktCOY5Ln21dCaVmbMS9gURL2hm+ARUXxfdY2plmkPRC37IiIEdW02klEE5akpcmaXZcPHqYIAbab3W/V6OWw0xJzzsKTz7d/5CytpoL5OMkB6BMSxLBbJ4Z2iEB8Aad+Fg2NE/7TJIN649TcZvj3d8nzW6ioOcih+rjI9SP0IUVk8fRIIRg/VAfZoR0ZZ6BMqnqoNXPtRiLrJR4KebOjWw/1upMFyHhjlX52e0IseGFamuZ2RF8zT7UB8FiOhqyDVw3jgGh3DvarrWMCLhPs4f6dunbOu3vgifaVUrtJb0ERf8GPdlutNbWZawcRHmKu9qzptI9uuUnLeCXhSm+PnfARu7W4EghBr/OAikxHvKNRuhzyiiU8C0kgRmDZ9Sg+1dkePQp1tjJvUAVktfvgOacu8zO8jS3ToK7a/SAh7m57sDTyrIg47CdRLnzTyvypHPvfP66Pa+oilf4QuaEzVRuZgEDj6vqzJrtgalrAMdUBdukUMNLiPUCfsoE4Uzm4gH3f3ZkuvF+q//XPwUkm78U02i7nrRcZ30xAnBxQH3MR9/gQ14I8EvPsYRm5DcZcfh/kjJCtk+jxOL5uVkDQjeKSZ+5RJ9vgWhqJ3ZXvgy3sC4ChOLpLAXw+J+alsKVKSMWP4t
 KeMy0mal
 VxVZF31qmf61qbzodL28cd229mX/cH2YCwixxHrcb4WIegKzZsC3fogkdaeXeCwsgR4iXzFEqKyVh8NouiIfxko4PMpr2e/iAOpXPXSzbX9Lo1juzoAfpWB8u01le9vq/teOGiWgU2GH5eCvyd8s5fBPEkgeYS5LYLfNmdKyn+B3Uxnjvh+Wy5mPHK2A9Qaiwk5a4yVALtq5uqJIhY4KpmgUDBY2hUPmxxepo6BDqNeKT8gL5dDJUyYzVqU2UDTB23egKu7MeqfH69ffpO4sx3hcSH8edaDRcYcELIZjVV15M/ZF1AxW9TtpiIqQpFU+CjBXuwNBzNAugwpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2026 19:28, Yosry Ahmed wrote:
> On Tue, Aug 18, 2026 at 06:09:46AM -0700, Usama Arif wrote:
>> From: Alexandre Ghiti <alexghiti@fb.com>
>>
>> A large folio reaches zswap_load() only when the caller expects
>> the whole range to be on disk. Zswap still stores large folios as
>> independent order-0 entries, so reconstructing a large folio from
>> zswap entries would risk returning partially initialized data.
>>
>> Teach zswap_load() to scan the covered range. If no slot is in zswap,
>> return -ENOENT so swap_read_folio() reads the backing device. If any
>> slot is still in zswap, fail the large-folio read so the caller can
>> fall back to per-page swapin.
>>
>> Return -EIO rather than -EINVAL for that conflict. Large-folio loads
>> are now valid requests; the error means zswap cannot safely satisfy
>> the request from partial per-page compressed state, not that the
>> request is unsupported. Existing callers only distinguish -ENOENT,
>> so this is a semantic clarification rather than a behavioral change.
>>
>> Add zswap_is_present() so PMD swap-entry consumers can make the same
>> range decision before attempting PMD-order swapin. Also use it from
>> __swap_cache_add_check() for multi-page insertions while holding the
>> swap cluster lock. That check runs before folio allocation and again
>> immediately before swap-cache insertion, closing the race with zswap
>> writeback and rejecting mixed zswap/disk backing with -EBUSY.
>>
>> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  include/linux/zswap.h |  6 ++++++
>>  mm/swap_state.c       | 10 ++++++++++
>>  mm/zswap.c            | 46 +++++++++++++++++++++++++++++++------------
>>  3 files changed, 49 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
>> index 30c193a1207e1..cd9efcf9dec94 100644
>> --- a/include/linux/zswap.h
>> +++ b/include/linux/zswap.h
>> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>>  void zswap_folio_swapin(struct folio *folio);
>>  bool zswap_is_enabled(void);
>>  bool zswap_never_enabled(void);
>> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>>  #else
>>  
>>  struct zswap_lruvec_state {};
>> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>>  	return true;
>>  }
>>  
>> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif
>>  
>>  #endif /* _LINUX_ZSWAP_H */
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index b76eb3d876fd7..15e200d6966b9 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/kernel_stat.h>
>>  #include <linux/mempolicy.h>
>>  #include <linux/swap.h>
>> +#include <linux/zswap.h>
>>  #include <linux/leafops.h>
>>  #include <linux/init.h>
>>  #include <linux/pagemap.h>
>> @@ -191,6 +192,15 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
>>  	if (nr == 1)
>>  		return 0;
>>  
>> +	/*
>> +	 * The cluster lock serializes swap-cache insertion with zswap
>> +	 * writeback. Reject mixed zswap/disk backing before allocating a
>> +	 * large folio and recheck it before adding the folio to swap cache.
>> +	 */
>> +	if (zswap_is_present(swp_entry(swp_type(targ_entry),
>> +				       round_down(swp_offset(targ_entry), nr)), nr))
> 
> 
> Sorry I didn't catch it in the discussion in v5, but I think it's
> actually clearer to do have this check in __swap_cache_alloc() as you
> initially suggested, but not necessarily under the lock.
> 
> I don't think the cluster lock is relevant per se, but rather the actual
> swap cache allocation. Once you allocate the folio in the swapcache,
> you cannot race with zswap store or writeback. I think the comment here
> is a bit misleading in that regard. Especially that it mentions
> writeback, but I think the real risk is racing with zswap store?
> 
> The check here is performed twice, once before allocating the folio and
> once after. I think the one before allocating the folio is not really
> useful, as we don't actually allocate the swapcache entry so nothing
> actually prevents a zswap store/writeback from happening right after
> releasing the lock.
> 
> We already have a failure path in __swap_cache_alloc() after allocating
> the folio and dropping the lock. Can we use the same path to check if
> zswap is present?

Yes, I think the above makes sense. I am looking at the code and I think we
can check the range after __swap_cache_do_add_folio() and use
the existing allocation rollback path if the folio exists in zswap.

The code will look slightly different from the diff below, but will
achieve the same thing.

Thanks for the review!


> 
> Maybe something along these lines (completely untested):
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 8ccd03c39a407..ce00a2311c5fd 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -415,6 +415,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>         swp_entry_t entry;
>         struct folio *folio;
>         void *shadow = NULL;
> +       bool large_in_zswap;
>         unsigned short memcg_id;
>         unsigned long address, nr_pages = 1UL << order;
>         struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
> @@ -459,7 +460,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>         __swap_cache_do_add_folio(ci, folio, entry);
>         spin_unlock(&ci->lock);
> 
> -       if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
> +       /*
> +        * Check if any part of the folio is in zswap after stabilizing the swap
> +        * cache entry to avoid races with zswap store/writeback. Reject
> +        * high-order entries that are partially or fully in zswap, as it is not
> +        * supported.
> +        */
> +       large_in_zswap = order && zswap_is_present(entry, nr_pages);
> +
> +       if (large_in_zswap ||
> +           mem_cgroup_swapin_charge_folio(folio, memcg_id,
>                                            vmf ? vmf->vma->vm_mm : NULL, gfp)) {
>                 spin_lock(&ci->lock);
>                 __swap_cache_do_del_folio(ci, folio, entry, shadow);
> 
> 
>> +		return -EBUSY;
>> +
>>  	is_zero = __swap_table_test_zero(ci, ci_off);
>>  	ci_off = round_down(ci_off, nr);
>>  	ci_end = ci_off + nr;
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 37f34e406c8e3..32671dc2bf84d 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1571,6 +1571,23 @@ bool zswap_store(struct folio *folio)
>>  	return ret;
>>  }
>>  
>> +/**
>> + * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
>> + * @entry: base swap entry of the range
>> + * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
>> + */
>> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>> +{
>> +	pgoff_t offset = swp_offset(entry);
>> +	struct xarray *tree = swap_zswap_tree(entry);
>> +	unsigned long index = offset;
>> +
>> +	if (!nr || zswap_never_enabled())
>> +		return false;
>> +
>> +	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
>> +}
>> +
>>  /**
>>   * zswap_load() - load a folio from zswap
>>   * @folio: folio to load
>> @@ -1578,13 +1595,9 @@ bool zswap_store(struct folio *folio)
>>   * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
>>   * of the following error codes:
>>   *
>> - *  -EIO: if the swapped out content was in zswap, but could not be loaded
>> - *  into the page due to a decompression failure. The folio is unlocked, but
>> - *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>> - *  will SIGBUS).
>> - *
>> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
>> + *  -EIO: if the swapped out content was in zswap but could not be handed
>> + *  back, either because decompression failed or because a slot in a
>> + *  large-folio range is unexpectedly still in zswap. The folio is unlocked,
>>   *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>>   *  do_swap_page() will SIGBUS).
>>   *
>> @@ -1605,13 +1618,20 @@ int zswap_load(struct folio *folio)
>>  		return -ENOENT;
>>  
>>  	/*
>> -	 * Large folios should not be swapped in while zswap is being used, as
>> -	 * they are not properly handled. Zswap does not properly load large
>> -	 * folios, and a large folio may only be partially in zswap.
>> +	 * A large folio reaches zswap_load() only when its whole range is
>> +	 * expected to be on disk: PMD swap-entry consumers split before
>> +	 * calling into PMD-order swapin whenever any slot is still in zswap.
>> +	 * Confirm the range is entirely absent from zswap and return -ENOENT
>> +	 * so the caller reads it from disk; if a slot is unexpectedly still in
>> +	 * zswap, fail the read rather than return partially-initialized data.
>>  	 */
>> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
>> -		folio_unlock(folio);
>> -		return -EINVAL;
>> +	if (folio_test_large(folio)) {
>> +		if (WARN_ON_ONCE(zswap_is_present(swp,
>> +						  folio_nr_pages(folio)))) {
>> +			folio_unlock(folio);
>> +			return -EIO;
>> +		}
>> +		return -ENOENT;
>>  	}
>>  
>>  	entry = xa_load(tree, offset);
>> -- 
>> 2.53.0-Meta
>>


