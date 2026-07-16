Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 133D9C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC186B0116; Thu, 16 Jul 2026 11:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1186B011B; Thu, 16 Jul 2026 11:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B7C6B0136; Thu, 16 Jul 2026 11:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABFA86B0116
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:32:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20FFAA0134
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:57:19 +0000 (UTC)
X-FDA: 84994489398.18.936F860
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf20.hostedemail.com (Postfix) with ESMTP id D87931C0005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:57:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AJNb6aDx;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784203037;
	b=8EyORe1/LHvzUtk/iycAiQINawJvbdGyL/Q1Ier/iAuJtllYld1QHmueaPMC2JEsgUWVW2
	jj1NMr+0kQTlsFGkMmy2nvx6PvlrcWeKFCPwZXwen4xWTos39gG51mydwnlqojlv2jcCPm
	Li3TFBgGMRYGrL7kdCyW76PmHK0NiZU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AJNb6aDx;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784203037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7po/hPV41ebN4SVCqHfXqnGtA3i/KcvpBhmzyD+bII=;
	b=QgWbmbcb4Zbk94926NO6sgSWks6lq7q8n198j8f9A9JXAEkth0KYNSIAlYXbP3Z5BI1vsd
	aOLijijayWYq+8r6Ca35WRNEEXQzo9i7rJt0e0a4jbcm7+rrLoqKKqKZYdwV77Em6vVbyF
	0Wdkiei+p7ac70n0+0x+V5wBMBT9+zQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784203032; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=w7po/hPV41ebN4SVCqHfXqnGtA3i/KcvpBhmzyD+bII=;
 b=AJNb6aDxv0WDBNphnYixnCKDK1hE4Ty1BsgmdMn7dK7QsFkTOIKivRtq98pkrHpQkPvrxT
 aaxPvQzU+nUQ6m/wPE26CNbqLye8mFIIGEKxwqyi4kwHIi3U7A60IXvFCpMisxDwCDnZ0b
 E9NQFZTy+uLnBjXlsCXbVo7nKa6+TqzzTMK5/+Q/lH/0FCunF28Je+Pazkx2bEZmmkvmb2
 AQF61Ugp4RdgzjuBit/jH34f/U5IM+nqo2plwhDOciWjQupnakv8mdtjtm8MNr3kbHEi8+
 v73qGNlLwWfCpux8Ym35wHIhN3mW8/3P4gC8orIG4whIqlAJMjHnMJSjvctiuA==
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Subject: Re: [PATCH v6 8/8] mm: use memcpy_nt() in zone-device template copies
Message-Id: <2e4ecb6f-4c9d-45b6-8ae1-3c165110c9ad@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com> <20260709112520.24857-9-lizhe.67@bytedance.com> <04f5b50a-a526-4644-b9f0-c54a0d6db702@linux.dev> <67BC9BE5-A201-4DED-B847-8C74BF30B16D@linux.dev> <fcfe93e4-e7fc-4d77-bce5-d027c597e556@bytedance.com> <10E87709-2116-46E3-96E2-6BC4E6F69952@linux.dev>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a58c716+ac34ec+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <10E87709-2116-46E3-96E2-6BC4E6F69952@linux.dev>
To: "Muchun Song" <muchun.song@linux.dev>
Date: Thu, 16 Jul 2026 19:56:48 +0800
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D87931C0005
X-Stat-Signature: 5cz6i6iipqwo98sg611osu1osr55cj56
X-HE-Tag: 1784203036-208238
X-HE-Meta: U2FsdGVkX1+NcuroECJusYt3KlDNpr22b8vlAJKJXCj+JPER8n78PHeVPuz+bbhy4spgRmar8Uas5gPdzpDvzYrpOywxbEOtTFRdUMm0Z26zAkVxr6tPT5A9vxWFNQUTT8hDhHNTRWt40n7+3wlxF37HUeaYjtcxERnKg7zO4Qmf48b8VulDSzre9SC4ggBFRTnWmdS4Vcsl/syhhL4kXUTwAbMykFv0JDCHzq7txDGCxRrx/xerqjgcy00GruzfbKjvjPFQYZRwHLhgRaamgmjm/JFefjN0w/r6LsPSqKwgyCx5fWTHtocG8O8SZXKFOtU2lCyDwyWTyjj8DDkZKMIT0aV/NZ99/bqp50lq1sZNsf7smiwYqweRu0ZmuUzcX0Dnnm3Vpz3YZJbX5IbLuBNgXxHaawfojArY0TJa4hl1sIDmvvyfoR4YwqkDHLsNXdnDbckxl4nnRJgcEEYEEVYP0UcWY8P3oTPQjslqSyoq8D3bgf/Lxfr85JzZ92/BDZeKzp9LOG+dvIiqI1nn3GYJ6PTfI+M9u/ohQ8mAuk91AmaOdGznNQWdRJmx20UEKSp74AB9aKNmp1JpdAmaktdvVfMKrnB+IDeNnkmCAGXmBoCYDyEif4/l64Gza+4ngctrdGanVt0l3c0JoDUziDWlKYlMHqdMmLHluHxvb8c0+tQOXbs3E0l0dH15t0BFVcoaXBGBfcmaX6mfxefKmucPUv16RVW2LoYDR45eVIvpi5T8qn35Wly+K5EKdRsHSun3dJnNxhFjgZj4rR5rLqHz+ZXMj69Cy+Ks8//EGkgIW8BVfV3/idYPImzHNOQw/J7KVl6ogrXsc//PBLkoYfiIM4KQzJi1LPX+QgjV/sQUyWX5uBMEvNAvIKC0TyHqpbycPwL9HQiFRzLk1ZRTRkrdSJp/ARqrGRsmAd/72G/ViJCc4aQf7jalBYjw3DRvV2SMrUplC/VWMvHFGj9
 aLpOKjvD
 kHCnueYMwaxUnUXLw8oCojs7s5R9SPWNzW4XQoWtHe9i8OMO+CzJGnGCxoGMeNFPO2AZxXQ+mxwQVaKJM/FKmc8H56j5vk2qTjsclYdTHS8GmN8ZRpkpFJi8AHt3+gggHPOZ7iOeoMu7Ag6ojhKQCSLCcITeF/TqfLnJBI/aa5mf8QTQqf9E79wnW+nRGezen2Qj9kVGoJHUiOpqfTMVTN6NnT4XvkjA3kxeGkQWxI/r42iVhQ0Ca4W4UDODxyqdA4Gu2S9Pl3EtRnhjeFq3G9SajfpiK+EemD7g7ZpPogarZY3h4Bci6incAM/GLl2u/bEHLaGdg+6ApUSv97P2fPoEWU02feMhGT+lR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 5:45 PM, Muchun Song wrote:
>
>> On Jul 15, 2026, at 14:30, Li Zhe <lizhe.67@bytedance.com> wrote:
>>
>> On 7/14/26 7:22 PM, Muchun Song wrote:
>>>> On Jul 14, 2026, at 17:45, Muchun Song <muchun.song@linux.dev> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/7/9 19:25, Li Zhe wrote:
>>>>> The template fast path currently uses memcpy() for the actual struct
>>>>> page copy. Switch zone_device_page_init_from_template() to memcpy_nt()
>>>>> and add memcpy_nt_drain() before memmap_init_compound(), before
>>>>> prep_compound_head() updates overlapping tail metadata, and before
>>>>> returning from memmap_init_zone_device().
>>>>>
>>>>> ZONE_DEVICE memmap initialization is largely write-once: each struct
>>>>> page is populated once, and most destination cachelines are not expected
>>>>> to be reused immediately afterwards. On x86, a regular cached memcpy()
>>>>> can therefore incur write-allocate traffic by pulling destination
>>>>> cachelines into the cache before writeback, and can populate the cache
>>>>> with data that has little near-term reuse. Using memcpy_nt() lets this
>>>>> path request non-temporal stores for that copy pattern, which can reduce
>>>>> cache pollution and avoid part of the associated write-allocate
>>>>> overhead, while architectures without a specialized backend still fall
>>>>> back to memcpy().
>>>>>
>>>>> When memcpy_nt() maps to non-temporal stores, order those stores before
>>>>> memmap_init_compound(), before prep_compound_head() updates overlapping
>>>>> compound metadata, and before returning from memmap_init_zone_device().
>>>>>
>>>>> Keep sanitized builds on the slow path so KASAN/KMSAN retain their
>>>>> instrumented stores.
>>>>>
>>>>> Tested in a VM with a 100 GB fsdax namespace device configured with
>>>>> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
>>>>> server.
>>>>>
>>>>> Test procedure:
>>>>> Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
>>>>> initialization time from the pr_debug() output of
>>>>> memmap_init_zone_device().
>>>>>
>>>>> Base(v7.2-rc1):
>>>>>    First binding for nd_pmem driver: 1456 ms
>>>>>    Average of subsequent rebinds: 244.28 ms
>>>>>
>>>>>    First binding for dax_pmem driver: 1462 ms
>>>>>    Average of subsequent rebinds: 273.31 ms
>>>>>
>>>>> With this series:
>>>>>    First binding for nd_pmem driver: 1272 ms
>>>>>    Average of subsequent rebinds: 96.79 ms
>>>>>
>>>>>    First binding for dax_pmem driver: 1354 ms
>>>>>    Average of subsequent rebinds: 119.04 ms
>>>>>
>>>>> This reduces the average rebind time by about 60.4% for nd_pmem and
>>>>> 56.4% for dax_pmem.
>>>>>
>>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>>> ---
>>>>>   mm/mm_init.c | 39 +++++++++++++++++++++++++++++++++++++--
>>>>>   1 file changed, 37 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>>> index fb855bb0437a..addb4969587e 100644
>>>>> --- a/mm/mm_init.c
>>>>> +++ b/mm/mm_init.c
>>>>> @@ -1067,11 +1067,21 @@ static void __ref zone_device_page_init_slow(struct page *page,
>>>>>
>>>>>   static inline bool zone_device_page_init_optimization_enabled(void)
>>>>>   {
>>>>> + /*
>>>>> + * Keep sanitized builds on the slow path so their stores stay
>>>>> + * instrumented.
>>>>> + */
>>>>> + if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_KMSAN))
>>>>> + return false;
>>>> It is not a major concern if struct page initialization lacks KASAN or
>>>> KMSAN instrumentation. To keep things simple, let's just entirely remove
>>>> zone_device_page_init_optimization_enabled() to simplify the code.
>>> BTW, If you really want to properly support KASAN, you should integrate
>>> the check directly into memcpy_flushcache() via kasan_check_write(), rather
>>> than treating it as a special case here.
>> I agree that proper KASAN-aware support, if ever needed for
>> memcpy_flushcache(), would belong in the low-level helper itself rather
>> than in this caller.
>>
>> That said, for this series I would still prefer to keep the local check
>> in zone_device_page_init_optimization_enabled(). The goal here is not to
>> add full KASAN support to memcpy_flushcache(), but simply to keep
>> sanitized builds on the existing instrumented slow path.
>>
>> When KASAN/KMSAN is enabled, performance is usually not the priority for
>> that configuration, while preserving the instrumented store path is.
>> Keeping the check local here avoids broadening the scope of this series
>> into a generic memcpy_flushcache() change.
> However, there is an even simpler approach: just don't do any special handling
> for KASAN. In fact, many callers of memcpy_flushcache don't handle it at all.
>
> So I'm curious, why are you keen on handling KASAN as a special case here?
>
> Thanks.
I agree that this is a simpler direction.

If we do not need to keep the sanitizer case on the non-template path,
then there is little value in keeping a separate
zone_device_page_init_optimization_enabled() helper either. The template
path can be the only initialization path, and the old non-template helper
code can be removed.

If this looks good to everyone, I plan to do that as a separate cleanup
patch in the next version, likely as patch 9. The reason for keeping it
separate is that patches 4 and 5 introduce the template initialization
logic, while patch 8 only switches the copy primitive used by that path.
Dropping the remaining non-template fallback is a follow-up cleanup made
possible by this discussion, so a separate patch should make the change
easier to review: first add and use the template path, then remove the
now-unneeded fallback code.

Thanks,
Zhe

>> Thanks,
>> Zhe
>>
>>>> Thanks.
>>>>
>>>>> +
>>>>>    /*
>>>>>    * The template fast path copies a preinitialized struct page image.
>>>>>    * Skip it when the page_ref_set tracepoint is enabled.
>>>>>    */
>>>>> - return !page_ref_tracepoint_active(page_ref_set);
>>>>> + if (page_ref_tracepoint_active(page_ref_set))
>>>>> + return false;
>>>>> +
>>>>> + return true;
>>>>>   }
>>>>>
>>>>>   static inline void zone_device_tail_page_init(struct page *page,
>>>>> @@ -1110,7 +1120,7 @@ static void zone_device_page_init_from_template(struct page *page,
>>>>>    * to the destination page.
>>>>>    */
>>>>>    zone_device_page_update_template(template, pfn);
>>>>> - memcpy(page, template, sizeof(*page));
>>>>> + memcpy_nt(page, template, sizeof(*page));
>>>>>   }
>>>>>
>>>>>   /*
>>>>> @@ -1179,6 +1189,15 @@ static void __ref memmap_init_compound(struct page *head,
>>>>>       &template);
>>>>>    }
>>>>>    }
>>>>> +
>>>>> + /*
>>>>> + * When the template path is enabled, order the preceding tail-page copies
>>>>> + * before prep_compound_head() updates the overlapping compound metadata
>>>>> + * in the first tail-page descriptors. If memcpy_nt() fell back to
>>>>> + * regular cached stores, memcpy_nt_drain() may be a no-op.
>>>>> + */
>>>>> + if (use_template)
>>>>> + memcpy_nt_drain();
>>>>>    prep_compound_head(head, order);
>>>>>   }
>>>>>
>>>>> @@ -1238,10 +1257,26 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>>>>    if (pfns_per_compound == 1)
>>>>>    continue;
>>>>>
>>>>> + /*
>>>>> + * When the template path is enabled, order the preceding head-page copy
>>>>> + * before memmap_init_compound(), which immediately updates compound-head
>>>>> + * metadata. If memcpy_nt() fell back to regular cached stores,
>>>>> + * memcpy_nt_drain() may be a no-op.
>>>>> + */
>>>>> + if (use_template)
>>>>> + memcpy_nt_drain();
>>>>> +
>>>>>    memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>>>>>        compound_nr_pages(pfn, altmap, pgmap),
>>>>>        use_template);
>>>>>    }
>>>>> + /*
>>>>> + * Ensure any prior template copies are ordered before returning.
>>>>> + * On architectures where memcpy_nt() used regular cached stores,
>>>>> + * memcpy_nt_drain() may be a no-op.
>>>>> + */
>>>>> + if (use_template)
>>>>> + memcpy_nt_drain();
>>>>>
>>>>>    pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
>>>>>
>>>>> --
>>>>> 2.20.1

