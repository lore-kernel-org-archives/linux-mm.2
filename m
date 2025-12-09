Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D91DD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAAB6B0005; Mon,  8 Dec 2025 20:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B996B0007; Mon,  8 Dec 2025 20:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681596B0008; Mon,  8 Dec 2025 20:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 561AB6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:59:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD351160365
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:59:51 +0000 (UTC)
X-FDA: 84198276582.01.B07FDCC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8DA2C0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:59:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZWbantto;
	spf=pass (imf28.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765245589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkpVCIWkHi0Ov4T6FfyUlWgC1DLrP6ETdWb7pKYa8SA=;
	b=MDLZf/c48fk05UsyKameeyj086AroRD9maBUEaPC3sindmHMNIOP8+k5rL3TlR5sgtZMj3
	/osX9xdHSFu/JVPZSDr+ZvW4zgx34uaky+ZPG03AzEr4QZ0XmiK82VHukgEXjGDgMHAMj7
	Zepm3pxkKaqisS2TWV8jjPYlWL/evSM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZWbantto;
	spf=pass (imf28.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765245589; a=rsa-sha256;
	cv=none;
	b=XKFl5MtJByK3jlQwo2DsRfy4dIjv8PieCGIA/EavSdBc5bijHzon4LasGe7y2c3sCpDuB5
	EWA/KJo7KjCB1FCa2UWQE1WSBPZzYI3dd3yXEn4qkUvmX3rOBzETkP/OCEwgy/dHEWVMzn
	wsleipb5ot5v1H0efxKhalbfaaez/r8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765245589; x=1796781589;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3VqMdSggJxrHPpmH+5FpuHZQMwjsfWTpiO2SJgzVl1E=;
  b=ZWbanttoN9dZ1RatwPRbltSYrrSV2UQymq86kXe2xn4oF67Wsh5RH92C
   U3HnQ+KdwkrnjaDtvPBrCWCbOMi0o7c89fVgpJbyHzIX29MQ5OCpdV+No
   +cDriGtn7TcCmrl5rRuAV6+La3zAqUhVde9KigpqN4AcD+KomyJdsKsTX
   ZxSugHekpzGJSDg7L0rfromOUdf/2iJEHXReVO79XvMHhR5mM5dH1Cz35
   N3lCLjxwvjmgcSHhz7YeE2S6oSTcN6yqllDi99WsyZAAXrNgrSHfBd0mA
   xoC2BEoIa7nc2sCIgXEn9XYaN48OLngG7kt6cGQkTBJWuZMK8m3Y32iZO
   w==;
X-CSE-ConnectionGUID: rQTFc0CZSxamPxKd3Ki5pw==
X-CSE-MsgGUID: a1n/nVAdQiSrjqtxVNCM2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67129957"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67129957"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 17:59:47 -0800
X-CSE-ConnectionGUID: 5TdfkdsSS9CYHHtagBCGWQ==
X-CSE-MsgGUID: PeCt+jUsRVKlVClJzGUIVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="201007501"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 17:59:43 -0800
Message-ID: <99b3a5a1-600b-4419-8215-824e7a525f12@linux.intel.com>
Date: Tue, 9 Dec 2025 09:55:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-3-smostafa@google.com>
 <07434771-3233-4c88-b505-ee02da72c905@linux.intel.com>
 <aSV-Xi5uMJcMtk1b@google.com>
 <CAFgf54qGdWNB=Oa=vbU1hRN2XOxQSESGO6K0CiG4Qizv=T3+Qw@mail.gmail.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <CAFgf54qGdWNB=Oa=vbU1hRN2XOxQSESGO6K0CiG4Qizv=T3+Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qaxm5nje8hu98dkcscougfzqocrufdmk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8DA2C0008
X-HE-Tag: 1765245588-673632
X-HE-Meta: U2FsdGVkX18zoxJpCyx/3qFuP2HDfURNStOBIe0yZvLGOZK/VRwLSdssUmbvVn02jZjsugGSSZcZjPLat/GdNTXyZl7Q02ElqGqYhr5a/jkOmyCcJoHqJFaujvHVnvj8roDTyXY0R1PEkUkIoApT0SsPK6hJfzl5RMVQzN5O1+hIaH6NiXW2zRtR8/BucwFHiFd3E2G8zZXsEyyUduiM26GogoKrKcRqcQYp5OWCLEzTo3ism3DyFrr0m/qksrSufSZqClA/db9Bgk7C2nhXuazqXdcXO3GTCTxy8Y5pAtL2qfAwW1ErPYQ0VUJStxmN0FH0PDuGtRMKUwHEoRuyEL4U6LfspvcnIRa54f5rNNhC+wecSQQSoDSZx3JSXM49kmXGHdTc4xOS3zxkIQxu2w/HDuo5Jwlf2cSY6z+/ecX6k31KaWdt23w3HWT/Eb7ewgJK6KC97tJTG3ySpeFuF08oBd3CGm9l7E/6htdycpwfUfZTSN+sZZXzNdrcmIdwTXV0s8GzQzADoBU9Gr60Qqlgx2tbN36p5eMWj93Asn9xknNkIfdI6l7sBB95VAxmBUp8MsmlowgehmqtbuPDwwur4e0+WWnJpXiWrh/6/NlR3QXNAhomJyQJoDvtuT7QvFZt6Sib0Fr2D8kLR2bjHBYnnVLbLR6lDU34sntNUNljioewjsIIJWb8Ru+cBifao6MuQatAqz1E9rtBGYOO/HhVNssCu+/ALQgP0tGikrj0piVzQ2XDc53d9QM7vAmaF/b7w55tJyEUdJg2jUjCq0Goa+xBabOL+avtNPmigiqOjssK1Ah5LQb75S6QhqMVBopj/bG9ZgNJF7F3KpF/h1H2Ug+YNQpN6l9qMW32CwS5Ve6ZtzOgBzeIRrzXfhtN1veN+FPzIJ4eRXMmhI7ZfYSqhLbn3g+3bgTD22clEG0P3BawrVf2PQVvd4e1WdEAhM0C6Co6eSaQOgAz4be
 946AR6DP
 5GzAtWwZUq5bKhq+tw7MIP+gPDom4q2hWqt1UkOEWwbC0IcAPid+bYecJSRfceiUIgfZsKVdmkcP48oGOxHibzAhMo0J0J6oFL8nrVh+fM9xspk0IZKZrtLIpONZ5jnuKaq9Pi++re9fuMps/7bcOPh5jVfTZ79EyJciCGuEnFLeAwq1YCEZC+SaYUEWZMNs2xlluL0xYP4lGQDCffblx/EyV6yDvyziVQodEixnMCxDgEdfhSgXMUPORmHoobkUOIFYf301PnCytuldM1rL1GR+6ile73vY9kj3YRg1O6w3MJcFI8IZACOZ4cgS7Q8Dfk7+71jmJAXgjXvY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/9/25 04:09, Mostafa Saleh wrote:
> On Tue, Nov 25, 2025 at 10:01 AM Mostafa Saleh<smostafa@google.com> wrote:
>> On Tue, Nov 25, 2025 at 03:35:08PM +0800, Baolu Lu wrote:
>>> On 11/25/25 04:08, Mostafa Saleh wrote:
>>>> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
>>>> - iommu_debug_init: Enable the debug mode if configured by the user.
>>>> - iommu_debug_map: Track iommu pages mapped, using physical address.
>>>> - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
>>>>     IOVA and size.
>>>> - iommu_debug_unmap_end: Track the end of unmap operation, passing the
>>>>     actual unmapped size versus the tracked one at unmap_begin.
>>>>
>>>> We have to do the unmap_begin/end as once pages are unmapped we lose
>>>> the information of the physical address.
>>>> This is racy, but the API is racy by construction as it uses refcounts
>>>> and doesn't attempt to lock/synchronize with the IOMMU API as that will
>>>> be costly, meaning that possibility of false negative exists.
>>>>
>>>> Signed-off-by: Mostafa Saleh<smostafa@google.com>
>>>> ---
>>>>    drivers/iommu/iommu-debug-pagealloc.c | 26 +++++++++++++
>>>>    drivers/iommu/iommu.c                 | 12 +++++-
>>>>    include/linux/iommu-debug-pagealloc.h | 56 +++++++++++++++++++++++++++
>>>>    3 files changed, 92 insertions(+), 2 deletions(-)
>>>>
>>> Remove "drivers/" from the commit title.
>>>
>>> $ git log --oneline drivers/iommu/iommu.c
>> My bad, I will fix it.
>>
>>> [...]
>>>> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
>>>> index 83e64d70bf6c..454303ec09c2 100644
>>>> --- a/include/linux/iommu-debug-pagealloc.h
>>>> +++ b/include/linux/iommu-debug-pagealloc.h
>>>> @@ -8,10 +8,66 @@
>>>>    #ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
>>>>    #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
>>>> +struct iommu_domain;
>>>> +
>>>>    #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
>>>> +DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
>>>> +
>>>>    extern struct page_ext_operations page_iommu_debug_ops;
>>>> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
>>>> +                  size_t size);
>>>> +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
>>>> +                          unsigned long iova, size_t size);
>>>> +void __iommu_debug_unmap_end(struct iommu_domain *domain,
>>>> +                        unsigned long iova, size_t size, size_t unmapped);
>>>> +
>>>> +static inline void iommu_debug_map(struct iommu_domain *domain,
>>>> +                              phys_addr_t phys, size_t size)
>>>> +{
>>>> +   if (static_branch_unlikely(&iommu_debug_initialized))
>>>> +           __iommu_debug_map(domain, phys, size);
>>>> +}
>>>> +
>>>> +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
>>>> +                                      unsigned long iova, size_t size)
>>>> +{
>>>> +   if (static_branch_unlikely(&iommu_debug_initialized))
>>>> +           __iommu_debug_unmap_begin(domain, iova, size);
>>>> +}
>>>> +
>>>> +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
>>>> +                                    unsigned long iova, size_t size,
>>>> +                                    size_t unmapped)
>>>> +{
>>>> +   if (static_branch_unlikely(&iommu_debug_initialized))
>>>> +           __iommu_debug_unmap_end(domain, iova, size, unmapped);
>>>> +}
>>>> +
>>>> +void iommu_debug_init(void);
>>>> +
>>>> +#else
>>>> +static inline void iommu_debug_map(struct iommu_domain *domain,
>>>> +                              phys_addr_t phys, size_t size)
>>>> +{
>>>> +}
>>>> +
>>>> +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
>>>> +                                      unsigned long iova, size_t size)
>>>> +{
>>>> +}
>>>> +
>>>> +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
>>>> +                                    unsigned long iova, size_t size,
>>>> +                                    size_t unmapped)
>>>> +{
>>>> +}
>>>> +
>>>> +static inline void iommu_debug_init(void)
>>>> +{
>>>> +}
>>> I suppose that all these should go to drivers/iommu/iommu-priv.h, as
>>> they are for use in other files inside the IOMMU subsystem.
>> It seemed better to have all the feature functions/declarations in one
>> isolated file, as it is included outside of the iommu susbsystem also.
>> I have no strong opinion, I can keep them in drivers/iommu/iommu-priv.h
>> if you think it's better. But then we will have to include also
>> "iommu-debug-pagealloc.h" for the static key to avoid including extra
>> files to linux/mm.h.
>>
>> Thanks,
>> Mostafa
>>
> Hi Baolu,
> 
> I plan to post a new version soon. So far, I only have the commit
> subject rewrites. Do you have any opinion on the header file split or
> the unmap size part?

I have no option regarding the unmap size part, as the comments already
declare the possible cases. For the header file split, I feel it's
better to put staff that is only used in the IOMMU subsystem in drivers/
iommu in iommu-pri.h instead of the global ones under include/linux.

Thanks,
baolu

