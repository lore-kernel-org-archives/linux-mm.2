Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2021CCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 08:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E36A8E0005; Sat, 27 Sep 2025 04:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BBB08E0001; Sat, 27 Sep 2025 04:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8F18E0005; Sat, 27 Sep 2025 04:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 593FB8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:40:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B7661A067D
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 08:40:31 +0000 (UTC)
X-FDA: 83934383862.17.96B4865
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B78EC000D
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 08:40:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=softfail (imf22.hostedemail.com: 148.251.105.195 is neither permitted nor denied by domain of MUsamaAnjum@gmail.com) smtp.mailfrom=MUsamaAnjum@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758962429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9f7uDmaTpvKSFHeG7L9fZv/HsKeQ2X9yEzWeOuxFzTE=;
	b=EBK76NY4PtLK2IBLTEUR+WSpdeAE7bVJs/2gMpyHhKeU4azLRKHyQGm6tkXpTx+MQtnrQB
	CAEtPvL0lbIcmQ6gE65yMfDi4Z/l86k+i0cQ/Bid08nZRc5bikDZQ2MO/reJPdNFWqvEe1
	/7eqowmV8HYjJksbAM2Tehkgq6rbyFw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=softfail (imf22.hostedemail.com: 148.251.105.195 is neither permitted nor denied by domain of MUsamaAnjum@gmail.com) smtp.mailfrom=MUsamaAnjum@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758962429; a=rsa-sha256;
	cv=none;
	b=gTq8k0KsuwzBNd92E+3TkHBZc4vTfhYDWAakXZ3q4YccGLQwuNEwochHYkEQ8wkYX4MFId
	hmzVhLpC3oOKqBtCTnVX0BnY0syOXWWUlle8H5buJRkBvSIrgb6UMOQvPTuspz0cTwmqPG
	APjt3UUPMzbFqk4Yqi7nyWHJf6PzWGs=
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B3DAD17E12D8;
	Sat, 27 Sep 2025 10:40:23 +0200 (CEST)
Message-ID: <648726ab-bd57-4ed3-bcaa-0d0372264728@gmail.com>
Date: Sat, 27 Sep 2025 13:40:21 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 SeongJae Park <sj@kernel.org>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-3-richard.weiyang@gmail.com>
Content-Language: en-US
From: Muhammad Usama Anjum <MUsamaAnjum@gmail.com>
In-Reply-To: <20250927004539.19308-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B78EC000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3ksd5hcy6pse4usow6idq115r7pkhxd4
X-HE-Tag: 1758962428-767838
X-HE-Meta: U2FsdGVkX18piOCbwcdvzt9tzZX/kcAYIfsn6LGEob5FV3l5L3mt+Lw/goUDa8Hr4nXDwm74HUA8KGdJhArYgsExOHYZUxcw/TZ6RyoL0Mc6nqHAG22CUOx+i3WrCgjFNaIRHQJxgUvyQzZEY/bS740hchGAUX/sHz1KF37q5V9Jg7YAE7DL2gtHcImZpx40Yu8AnEB5Vne9syL8bqkac+rhthGFc91s7bIiW5aMacvALHwGujaWqcfxzdYEbPYnsrT5FZ3av1DbfQ9Vvc1wBsQzVwPEgNwCH6e/vdEBUN9gcABV0xQsf1itdH6UqUpZcs6IKCchNlcY5D/Aqw0wBfQqMZCSH0Z1mwXTLu1b5PqTYqG05TaY8YdUDZMZJw/Lk8pfMgJeWIOTDCNlsoVAckjchvBDqXTagnzAsWn/cGZeMr0tNtYqFUpZvV8E23eHkAL2eWiTaoKjtY9zKtJb8MLfVfPBGGHHY7kCLe/TOlLdMzib5p6+g42n+JsJF4eRmNRVi79EcTOVi/TzUYVdOdTgIWU+Vku1PB3mjDI/o6ZuzlzHpAyW2qapbfOQF5qfPq78sFIeFEDSqZ4uhh8JpN92ExduiLT7UE2p+mz7UxLyIrOXkFiKl1cQy8Xp6WtboJM98Sm4zCOBcXYtIBlH3MedZ2CYacPgebjAK0+I6gvDUj8qu6aFmh024ZmwgWqT0CeUCfPVqIs/B/SJLr6bDz5gMSnQXge6OcPMTnX4dGx3noyaQtzTPzCC0Pnd2YesfcORkIHMql+0Vcntgd5yKGcXVSAZgXdqXZGMpObsFDzJKWH+xMXlI/iq3qzmcdy+eLuO6rLiRx9npQ+Xjg9FkudJcxFUuu7FyUSCXiBdTszzzwYWUgAbFsFP44xQCppV1TNhVnwBlQi9FM/M3s4cGvBdJtJrTDXfuZ5YYR2UkO3Vqqhl/bxn8oFke5jvj4WhAvOoG964FSj0DkSJM8P
 LFof+LeX
 jLBStW/aQSxGIkJrMBUVJSGHLigJNFaJlTCgGYXFnHFxWolSZ1Gf9nLXO6pEIFX/wGqtMH8OOgKfQFGM86HyMu8amEPb3qd/0Uisave1KSh+T6ADPjeOnIyzZalYuDqRf6Qj8NNh6Zii07wGUFopYpzqpU6gd3hzliScO4Wscr9VzPLpXUNj5VGXyF7SBNEHKFGcCnjvLmht+gWYnfCBW0mNU7Gt8YASGiMGGsmqViC4UF6O9FB+X99L9FefN4pHOsqBSOg8UEu2WLkOikcUe9sAxrc08M2y1Vz/IwvOXTa8jb1Gt8VZyZUIfRo4zqPOCXPOnQ/jikAZAWIIio/BQKQ/JMRq9NIMBycnxb/uCARU+GDp9KWs3kNzNryq7cCo4xnYCj5PjW5B2kU7aUMuY6l8Lr29pZp2de6lHPnWaMCVs5joF+Eu/W47DRlxcGiaTtWowdVxa5aTUh2gBP4EyOxpYmSFb1+fd4GpOYI/QV3zcsGFeEa06jFfWaGC9KDnE85oSzsG0+0cGLuN/zO1HAJzWkJ/vX7sjMOutZrGclOjfMWx48eE2x0NDa7YvH9SE+jVEwbmV8eM31PwT4jzhetDmQvaGXY57Z40JChYhXAd6hF7zd75Ls6ResHAGxJyul9TGD16d/Vqn8DaIqdVU2lQfFTNCFpMhq0KBkpPYxqaYj7sdv/d3TFfV4QQkqmWvTFlzmqHPG5i/s5pRoczfLW+V9S7FZ+XymdwUFKbow9BTMy0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/25 5:45 AM, Wei Yang wrote:
> Current code calls mm_slot_entry() even when we don't have a valid slot,
> which is not future proof. Currently, this is not a problem because
> "slot" is the first member in struct khugepaged_mm_slot.
> 
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
> is no need to define it.
> 
> Remove the definition of struct khugepaged_mm_slot, so there is not chance
> to miss use mm_slot_entry().
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Nico Pache <npache@redhat.com>
Acked-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

> 
> ---
> v3:
>   * adjust changelog
>   * rename the slab cache to "mm_slot"
> v2:
>   * fix a PF reported by SeongJae, where slot is changed to next one
> ---
>  mm/khugepaged.c | 55 ++++++++++++++++---------------------------------
>  1 file changed, 18 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 204ce3059267..67540078083b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -103,14 +103,6 @@ struct collapse_control {
>  	nodemask_t alloc_nmask;
>  };
>  
> -/**
> - * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
> - * @slot: hash lookup from mm to mm_slot
> - */
> -struct khugepaged_mm_slot {
> -	struct mm_slot slot;
> -};
> -
>  /**
>   * struct khugepaged_scan - cursor for scanning
>   * @mm_head: the head of the mm list to scan
> @@ -121,7 +113,7 @@ struct khugepaged_mm_slot {
>   */
>  struct khugepaged_scan {
>  	struct list_head mm_head;
> -	struct khugepaged_mm_slot *mm_slot;
> +	struct mm_slot *mm_slot;
>  	unsigned long address;
>  };
>  
> @@ -384,7 +376,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  
>  int __init khugepaged_init(void)
>  {
> -	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
> +	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
>  	if (!mm_slot_cache)
>  		return -ENOMEM;
>  
> @@ -438,7 +430,6 @@ static bool hugepage_pmd_enabled(void)
>  
>  void __khugepaged_enter(struct mm_struct *mm)
>  {
> -	struct khugepaged_mm_slot *mm_slot;
>  	struct mm_slot *slot;
>  	int wakeup;
>  
> @@ -447,12 +438,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>  	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>  		return;
>  
> -	mm_slot = mm_slot_alloc(mm_slot_cache);
> -	if (!mm_slot)
> +	slot = mm_slot_alloc(mm_slot_cache);
> +	if (!slot)
>  		return;
>  
> -	slot = &mm_slot->slot;
> -
>  	spin_lock(&khugepaged_mm_lock);
>  	mm_slot_insert(mm_slots_hash, mm, slot);
>  	/*
> @@ -480,14 +469,12 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>  
>  void __khugepaged_exit(struct mm_struct *mm)
>  {
> -	struct khugepaged_mm_slot *mm_slot;
>  	struct mm_slot *slot;
>  	int free = 0;
>  
>  	spin_lock(&khugepaged_mm_lock);
>  	slot = mm_slot_lookup(mm_slots_hash, mm);
> -	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> -	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
> +	if (slot && khugepaged_scan.mm_slot != slot) {
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
>  		free = 1;
> @@ -496,9 +483,9 @@ void __khugepaged_exit(struct mm_struct *mm)
>  
>  	if (free) {
>  		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> -		mm_slot_free(mm_slot_cache, mm_slot);
> +		mm_slot_free(mm_slot_cache, slot);
>  		mmdrop(mm);
> -	} else if (mm_slot) {
> +	} else if (slot) {
>  		/*
>  		 * This is required to serialize against
>  		 * hpage_collapse_test_exit() (which is guaranteed to run
> @@ -1432,9 +1419,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	return result;
>  }
>  
> -static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
> +static void collect_mm_slot(struct mm_slot *slot)
>  {
> -	struct mm_slot *slot = &mm_slot->slot;
>  	struct mm_struct *mm = slot->mm;
>  
>  	lockdep_assert_held(&khugepaged_mm_lock);
> @@ -1451,7 +1437,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
>  		 */
>  
>  		/* khugepaged_mm_lock actually not necessary for the below */
> -		mm_slot_free(mm_slot_cache, mm_slot);
> +		mm_slot_free(mm_slot_cache, slot);
>  		mmdrop(mm);
>  	}
>  }
> @@ -2394,7 +2380,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	__acquires(&khugepaged_mm_lock)
>  {
>  	struct vma_iterator vmi;
> -	struct khugepaged_mm_slot *mm_slot;
>  	struct mm_slot *slot;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> @@ -2405,14 +2390,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	*result = SCAN_FAIL;
>  
>  	if (khugepaged_scan.mm_slot) {
> -		mm_slot = khugepaged_scan.mm_slot;
> -		slot = &mm_slot->slot;
> +		slot = khugepaged_scan.mm_slot;
>  	} else {
>  		slot = list_first_entry(&khugepaged_scan.mm_head,
>  				     struct mm_slot, mm_node);
> -		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>  		khugepaged_scan.address = 0;
> -		khugepaged_scan.mm_slot = mm_slot;
> +		khugepaged_scan.mm_slot = slot;
>  	}
>  	spin_unlock(&khugepaged_mm_lock);
>  
> @@ -2510,7 +2493,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  breakouterloop_mmap_lock:
>  
>  	spin_lock(&khugepaged_mm_lock);
> -	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
> +	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>  	/*
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm.
> @@ -2522,16 +2505,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		 * mm_slot not pointing to the exiting mm.
>  		 */
>  		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> -			slot = list_next_entry(slot, mm_node);
> -			khugepaged_scan.mm_slot =
> -				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> +			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
>  			khugepaged_scan.address = 0;
>  		} else {
>  			khugepaged_scan.mm_slot = NULL;
>  			khugepaged_full_scans++;
>  		}
>  
> -		collect_mm_slot(mm_slot);
> +		collect_mm_slot(slot);
>  	}
>  
>  	return progress;
> @@ -2618,7 +2599,7 @@ static void khugepaged_wait_work(void)
>  
>  static int khugepaged(void *none)
>  {
> -	struct khugepaged_mm_slot *mm_slot;
> +	struct mm_slot *slot;
>  
>  	set_freezable();
>  	set_user_nice(current, MAX_NICE);
> @@ -2629,10 +2610,10 @@ static int khugepaged(void *none)
>  	}
>  
>  	spin_lock(&khugepaged_mm_lock);
> -	mm_slot = khugepaged_scan.mm_slot;
> +	slot = khugepaged_scan.mm_slot;
>  	khugepaged_scan.mm_slot = NULL;
> -	if (mm_slot)
> -		collect_mm_slot(mm_slot);
> +	if (slot)
> +		collect_mm_slot(slot);
>  	spin_unlock(&khugepaged_mm_lock);
>  	return 0;
>  }


