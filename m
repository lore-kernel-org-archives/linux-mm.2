Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E858C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6056D6B0095; Wed, 26 Aug 2026 05:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCAD6B0099; Wed, 26 Aug 2026 05:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4896B009B; Wed, 26 Aug 2026 05:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 269C16B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:06:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6972BA02E8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:06:34 +0000 (UTC)
X-FDA: 85142839908.16.DB236D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 96D521A0011
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:06:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Db8eitT4;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xif2Q2bWA61yFoe3xlnqfvMwm3Fzd4eNOw/v0/j4IUs=;
	b=AJk+ci5rCTljJQEcn0AKYwChLoK9pFyGODKeyCMHC2tGYgFqILzu27sHVvUFUuq98f/JVI
	mSSNlKkPmT1fpBc+KUE3phCL8VYHkn4R9Ody0gH4wknC9dr0K8MDB7qfRTxzlCpZv4D8D3
	6YRAbS0q+0cOFlt2VcJbrjV+qAfc16U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735192;
	b=tqCY4u7Yp0/FIWDJHT8/SRWySLNKKDayPYYnj4CrO47CzTW3r1VFwUHayenn0TnpUNbpUr
	24tEdRczUHuMRPneG81CQ8RHMhIQvU14+7gw9YpuSZk3P/iOuqAPlQXeBdQANBu+Ax3S32
	9Tg0gUO/FOUwQ1Dx7G6z4XOs6AywFtw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Db8eitT4;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05F926020E;
	Wed, 26 Aug 2026 09:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53171F000E9;
	Wed, 26 Aug 2026 09:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787735191;
	bh=xif2Q2bWA61yFoe3xlnqfvMwm3Fzd4eNOw/v0/j4IUs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Db8eitT43zkxTQ0tnZ30RXDVmrEY5w16260uJUMWz//E/eeLQbEVqgO/gcd8sdOQ6
	 cXQxRKiQ7vHFxA80EbPJoVkWnX4e9K+090XZW7LLvIlizJB/uJMb4Ln2x3P0jhzChc
	 vQQzZ5IHrY/bVYEviOTrthsjNuZeZooe+KWunOpbHjAeHZOOBsasEHFRKZiTq3XR89
	 qcDcwWZfFRQs4IfMvHY970IRQM/cfivgxbajHtDo+SNewAc1zy+vfDsgkuRDDKyghm
	 D+FR64X7oBQvm4wVotbT788ttAGA9aNM/rGyq2j+PavBRT1g20xVCLdrZexIHwjdVG
	 03C+rqLuiXrJw==
Message-ID: <819cc4b4-1855-4dbc-adb4-3b18d6fa2924@kernel.org>
Date: Wed, 26 Aug 2026 11:06:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
 "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com>
 <ac77571f-4a10-4511-83e0-c6372d5b4a09@kernel.org>
 <MW4PR11MB69369259EB8B2FDF237B863AA3A42@MW4PR11MB6936.namprd11.prod.outlook.com>
 <bf298ebe-55bd-4f42-9339-9567eadaa514@kernel.org>
 <MW4PR11MB6936054EC741918CCFC6FDD6A3A32@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB6936054EC741918CCFC6FDD6A3A32@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96D521A0011
X-Stat-Signature: jsu9w4bm5iqdyzxuowq1okp8t8nkz8bb
X-HE-Tag: 1787735192-11570
X-HE-Meta: U2FsdGVkX18CVKxw05i2GDKoFltB1+C07Btb9z/BfZNfkKq0oboMsSoKYl0la4nZ92uxQn/PFdGmhxwr9b7TO50b2oc8484vSCT1q2dfyerMeQWLDswx/FTrkrrvetQ8FwSgh1vALjK5+KHhKUOgLePVyiyE1w5WzQhVlljmgx+jl1S4ckD1HuOor2NTcx6ipvUuKS7GYuHiBCaDjU4QIsKMa5apLbs8d/bkNiy9SCr4ZYYqgHFeiwWgS+yULK9zqHCtsWWMxjEc7kC1knl6VVPf4x9hIK41nhqdHbLKH43qe2aZyzAmrjLQ4JwH0X5Sss1mYHKl2KRirKopK092aZueLebRLEsaYsEaUB+ilCQBp4PhgUku/oOvVvM7pHbWbbqdq9BHuO737TMhvWyX26bdDm9hM05dPjtn21wRBP6cbX9wArnIgwlCHB3W4L1qGw9dd8iXTOC2T3ItsQ+YuoV6ldt3DlCFUI8lOS9kAzy98zi6V9lV3p1UANFV5FwbzHM5LCpC0Kbv8kqrpvjqBttJzUenZTKcbxTD9jJLSPZlsLd1CaWWGUOebHJBuGPun8aoBS6uomOKSoLezXjsUONQJyMsO25dqonTzmoqCYJCl7zh/EqdTVU4z3tK3bjbB2Z6RkVfsjTiHVQh96zhAaK4i5TpbSEihB/u895QNDZ9GJ1IUEEV7uBaRlOHBWgqu7nMpPlamfvhX7LTF9qDJx9RE5HykjEGXVxApeDhDtPenD3xBC+xAUjWFOqM9LemPmogG20Urz1O5lMgYR+7YWsHrnZsAwxAgqrGi7VNkHD/gUlNYYn5zLObSwprwMCpqd6vMBZJZwzx8kIFfHLPrC/T41Y8Hn2GS7oc54UdIlk7RBWZmBHetvisE8nlr/8bZHUYgR8skcG/RT3KB6yL61wuDUP27y9bhCCHhzEUzJZnX3IQlzFR4AilI2h2dZdP4VpULNynIO+kOuwBK+W
 176s0kSn
 knju/UuUGucQIZBVEPrnFPyHWAE7aJhXY9seCfnPFn0eKfGiOgcmqren8yPX6z1itxaZSLmTyWNHLf64V5X9yhFdeD8MC34W60wN7KMQPtEhaqVYtgC0LoE6fJMkZc5S+yKzI9KlLX1QUblQCou+4rvUd4V2+ybx9xvBZzTUXWURVmypB9MIfXcFMe68OvuQjQf+ctkJHo5/v0KU8zVanLT+nFIc1ITFhSfcjvHrssCpyG0iFsRtNa2DA9BWWr5eWaW8TXrCxwfiVybwuybwlQFqJLvDRWq6jBtAeBPbMMN5rL4pM6mX2qcroXk+22H7w7B7aY5ZqYZKgF/Dcw0UZjlEpbrRXxMSip66xIFUUez+rZASGQ9K72237wFKILg4r50N0ebrn5nqZwqHgpGZPvBWWIziHolFhCVrTHjZB7QlNqwfzy0/iXRfHVXSzbea4BaIIapVPzUBbED9KXS1v1Di/YVEfBF78H2OhOnOVoZHk0DWCmoVeXRmNaSxFkRKU4aI88f/IfN498iuBOSCl9K1QDqz1rVWC8uFB4aQBYPf9ZibGESf6I4ekdeRC2JiiPXcZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 05:17, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: David Hildenbrand (Arm) <david@kernel.org>
>> Sent: Friday, August 21, 2026 1:46 AM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
>> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
>> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Chen Zhang
>> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; Chen, Yu C
>> <yu.c.chen@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
>> <tianyou.li@intel.com>; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous
>> check when changing pfn range
>>
>>>
>>> I think there may be an issue here: PAGE_SUBSECTION_MASK is not
>>> defined when CONFIG_FLATMEM is enabled, which would result in a
>>> build failure.
>>
>> Ah, yeah.
>>
>>>
>> until
>> actually
>>>
>>> Hi David
>>>
>>> What about the following approach? It removes the helper and changes
>>> the per-PFN online check to a per-chunk check.
>>>
>>> +       u64 pgcnt = 0, online_pgcnt = 0;
>>> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
>>> +       const unsigned long chunk = PAGES_PER_SUBSECTION;
>>> +#else
>>> +       const unsigned long chunk = epfn - spfn;
>>> +#endif
>>>
>>> -       for_each_valid_pfn(pfn, spfn, epfn) {
>>> -               __init_single_page(pfn_to_page(pfn), pfn, zone, node);
>>> -               __SetPageReserved(pfn_to_page(pfn));
>>> -               pgcnt++;
>>> +       /*
>>> +        * With VMEMMAP, subsection-sized holes can exist, and PFNs
>> within
>>> +        * these holes can fail pfn_to_online_page(). Without VMEMMAP,
>> we
>>> +        * always only have early sections when they are actually
>> online.
>>> +        */
>>> +       for (pfn = spfn; pfn < epfn; pfn += chunk) {
>>> +               const unsigned long chunk_epfn = min(pfn + chunk, epfn);
>>> +               const bool is_online
>> = !IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ||
>>> +                                      pfn_to_online_page(pfn);
>>> +               unsigned long p;
>>> +
>>> +               for_each_valid_pfn(p, pfn, chunk_epfn) {
>>> +                       __init_single_page(pfn_to_page(p), p, zone,
>> node);
>>> +                       __SetPageReserved(pfn_to_page(p));
>>> +                       if (is_online)
>>> +                               online_pgcnt++;
>>> +                       pgcnt++;
>>> +               }
>>
>> I'd keep the for_each_valid_pfn() the outer loop.
> 
> Hi David
> 
> Do you mean the following approach? We use for_each_valid_pfn as 
> the outer loop and, with VMEMMAP,check online PFNs 
> in PAGES_PER_SUBSECTION chunks
> 
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +       const unsigned long chunk = PAGES_PER_SUBSECTION;
> +#else
> +       const unsigned long chunk = epfn - spfn;
> +#endif
> +       unsigned long pfn, next_chunk_pfn = spfn;
> +       u64 pgcnt = 0, online_pgcnt = 0;
> +       bool is_online = true;
> 
>         for_each_valid_pfn(pfn, spfn, epfn) {
>                 __init_single_page(pfn_to_page(pfn), pfn, zone, node);
>                 __SetPageReserved(pfn_to_page(pfn));
> +
> +               /*
> +                * With VMEMMAP, subsection-sized holes can exist, and PFNs
> +                * within these holes can fail pfn_to_online_page(). Without
> +                * VMEMMAP, early sections only exist when actually online.
> +                */
> +               if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
> +                   pfn >= next_chunk_pfn) {
> +                       is_online = !!pfn_to_online_page(pfn);
> +                       next_chunk_pfn = min(pfn + chunk, epfn);
> +               }
> +               if (is_online)
> +                       online_pgcnt++;
> +

It's hard to get it any cleaner. I was wondering whether we should just have a separate
for_each_online_pfn() call afterwards, but that's also not ideal.

I was wondering whether we should also just use pfn_section_valid() directly.

Something like the following:


diff --git a/mm/mm_init.c b/mm/mm_init.c
index e9c4204b73adb..cc7d55a71a060 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -838,22 +838,39 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
  *   zone/node above the hole except for the trailing pages in the last
  *   section that will be appended to the zone/node below.
  */
-static void __init init_unavailable_range(unsigned long spfn,
-                                         unsigned long epfn,
-                                         int zone, int node)
+static unsigned long __init init_unavailable_range(unsigned long spfn,
+                                                  unsigned long epfn,
+                                                  int zone, int node)
 {
+       unsigned long next_chunk_pfn __maybe_unused = spfn;
        unsigned long pfn;
-       u64 pgcnt = 0;
+       u64 online_pgcnt = 0, pgcnt = 0;
+       bool is_online = true;
 
        for_each_valid_pfn(pfn, spfn, epfn) {
                __init_single_page(pfn_to_page(pfn), pfn, zone, node);
                __SetPageReserved(pfn_to_page(pfn));
                pgcnt++;
+
+               /*
+                * With vmemmap, at this stage all pages in an early section
+                * have a valid memmap and are marked as online. However, only
+                * subsections in the subsection map are actually online.
+                */
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+               if (pfn >= next_chunk_pfn) {
+                       is_online = pfn_section_valid(__pfn_to_section(pfn), pfn);
+                       next_chunk_pfn = min(SUBSECTION_ALIGN_UP(pfn + 1), epfn);
+               }
+#endif
+               if (is_online)
+                       online_pgcnt++;
        }
 
        if (pgcnt)
                pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
                        node, zone_names[zone], pgcnt);
+       return online_pgcnt;
 }
 
 /*


I'd love to avoid any CONFIG_SPARSEMEM_VMEMMAP, but that's hard as well :)

-- 
Cheers,

David

