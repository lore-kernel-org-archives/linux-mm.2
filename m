Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 058ECC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3A86B0092; Tue, 14 Jul 2026 05:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAB36B0093; Tue, 14 Jul 2026 05:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09166B009B; Tue, 14 Jul 2026 05:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6FA66B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:45:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40296C02DF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:45:27 +0000 (UTC)
X-FDA: 84986899494.01.8064D4C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2FE4DC0009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:45:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s2kVBwVl;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784022325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mekORx+dFKRiABrAy+XEgciHwWSjZPvElZQGPDy01aI=;
	b=pw/2/dWTLLmuaQQb5RdMcBUjFhU56COuYo3a0XJsDDkKnbf2iWRvlM0vTe6c4W7iqihwBc
	Bu7uq6ErBy3o595SFOX0uw+0fVNQIEk4NTNOpLHwAo6z/eVI6euHf+r9s58AxkJkHdMqVL
	+bo46NJQofL9gAGvwaX4LKarYKZ1K2U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s2kVBwVl;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784022325;
	b=tKzvvX+7SnnAXlCSObeZ89Mzwzo0f53ts1Qa4BXGJVnqLjcurzy68fafj/LvP8q1odX731
	CPqRrfMJTu1ioPaze64+Fszyzj0x0fL3QS1YdVqbWaVE2f5nBUPH1Ls947NcG+iz1gjjim
	AfayOtibaop+W/hk7nio7OH2+9KOg9Q=
Message-ID: <04f5b50a-a526-4644-b9f0-c54a0d6db702@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784022323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mekORx+dFKRiABrAy+XEgciHwWSjZPvElZQGPDy01aI=;
	b=s2kVBwVl7nJQg4Gb/Kqxo1bPGuZQp8vx9e/9dh096WOea1GmNZvCyunI+kd7T22YqJYDA/
	NKH2dTJV7HWZL661cCIPgju0vw80HFbKnXFteGddtiUZO3JDANIoYLOYb9ukTtCzgsEIpr
	nc7fRXOdZErHcdm3A2EnLN4UvV7I5T4=
Date: Tue, 14 Jul 2026 17:45:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 8/8] mm: use memcpy_nt() in zone-device template copies
To: Li Zhe <lizhe.67@bytedance.com>
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com,
 david@kernel.org, kees@kernel.org, mingo@redhat.com, rppt@kernel.org,
 tglx@kernel.org
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-9-lizhe.67@bytedance.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260709112520.24857-9-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FE4DC0009
X-Stat-Signature: c3sek3z15n6pky5ffu3ehuampt98arzi
X-HE-Tag: 1784022325-953599
X-HE-Meta: U2FsdGVkX186zfQH37GWoKh/xarelYnx+G1py+lJNoQ1yDqx0DV6elqstPLvl0YbQDJzPxkE9xxvBjWIfCzNlkk2Fo+nVs2Twa9J07VbiBPOM+hJ0hUL+kUUqXo1Yut4JFM5yzikfUFU1P/tSyvDpHO+iyAsOeUTL1zhT1icC62IdODCxsy/DKBQgJhzcBj6N81Y4f33tTS7emdnc60fCpIwED/jOY8no2WISFbutL+xHelHcUCXBADfR5BQt7yoWGuuWg9IKA/FPBmGQW2Z0W8TS7ZD6YRLfUgrI7J5lXRb3goajcB3+q/gIZ1n0bP45GzAPtPnCgLcbgymiD+FHD8EHQyQiQdiyxbjNiWey3m93LGV+ZH29RNtZAUkejjZKidcepnTbC8RKcVN/0HODeKIt5m5WbKVIekfVDEHuPNw5+ll78mXjFY8Kb00ln5FJIMCAxT1XdG58C4s8r7+CQKc/z+0HqiSgiSWIlP+ROWr7LBrQURMD2x4gTv9C1ZuogtYLVd13GkkLs4ErHMZ//zDL9ywN2maF0GAbNJcZDYonrtmeoB1Nq99Rwyheni5pw7V7mgZoPCteAfYXyJ8hyF7/qgjQS3pNY0609Lm6s8tvi2Hhz8JfRvWRX7bG3Bg7Nv9zuqLZzYmsA0GQFqWsg1jPVr4AjZcH7HgxujUxv78ouVg47y4ac9I/y/t2hQZTKyfE8nY1MfPwYI1DGqydMLS2mCeOW7VHHgUd6/CV3Wfdj6m1USraJ9Uq1TFkCbAzyF+YnT75rPElqygrbTogR7JwO2nOTZVLHmDc3lZsh+mZNWjLq/KT6FgZREX1POhL14hIyRLkm99YyHtGKy3yOFQ/w541EEa+RBgIU8SxDyifuEnAlQB9jGCnqvgCdrtR6mbEvyQXPBxYOvuL5uOSlAM+ygD+qhO8tAGfHfbNOZHvtDkvCPZ/LStpgEmyTWc6dLh+cLyqCAbx6dW+Y1
 aifr8fF3
 WGoLU0CSlTCPEivezJjPPC+lXyD/XOqPqwghipyAQfFSAk+B+lGqBdYCJhs8SpzvNmJA5W1h1y3fxol+3lnfxm5rjV8HRzgWbAdTOow1oQjbPpKI/ED996vQD93zYJMBZux59P0U1x1FgmPiuymHtPe73xC2Av0GoR0/72SPwreaLabOoZgwVAwjPxkw9vKlKZfb4jwGjU1hLyYIEIwib+FodObNwkioHVdt4WCyCP3JEeND4ruG5tTJ8xpLV2j8DOdXpK7/eJvngXxrpNa5QwsX/90e0IpTv9Wo1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/9 19:25, Li Zhe wrote:
> The template fast path currently uses memcpy() for the actual struct
> page copy. Switch zone_device_page_init_from_template() to memcpy_nt()
> and add memcpy_nt_drain() before memmap_init_compound(), before
> prep_compound_head() updates overlapping tail metadata, and before
> returning from memmap_init_zone_device().
>
> ZONE_DEVICE memmap initialization is largely write-once: each struct
> page is populated once, and most destination cachelines are not expected
> to be reused immediately afterwards. On x86, a regular cached memcpy()
> can therefore incur write-allocate traffic by pulling destination
> cachelines into the cache before writeback, and can populate the cache
> with data that has little near-term reuse. Using memcpy_nt() lets this
> path request non-temporal stores for that copy pattern, which can reduce
> cache pollution and avoid part of the associated write-allocate
> overhead, while architectures without a specialized backend still fall
> back to memcpy().
>
> When memcpy_nt() maps to non-temporal stores, order those stores before
> memmap_init_compound(), before prep_compound_head() updates overlapping
> compound metadata, and before returning from memmap_init_zone_device().
>
> Keep sanitized builds on the slow path so KASAN/KMSAN retain their
> instrumented stores.
>
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> server.
>
> Test procedure:
> Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
> initialization time from the pr_debug() output of
> memmap_init_zone_device().
>
> Base(v7.2-rc1):
>    First binding for nd_pmem driver: 1456 ms
>    Average of subsequent rebinds: 244.28 ms
>
>    First binding for dax_pmem driver: 1462 ms
>    Average of subsequent rebinds: 273.31 ms
>
> With this series:
>    First binding for nd_pmem driver: 1272 ms
>    Average of subsequent rebinds: 96.79 ms
>
>    First binding for dax_pmem driver: 1354 ms
>    Average of subsequent rebinds: 119.04 ms
>
> This reduces the average rebind time by about 60.4% for nd_pmem and
> 56.4% for dax_pmem.
>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>   mm/mm_init.c | 39 +++++++++++++++++++++++++++++++++++++--
>   1 file changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index fb855bb0437a..addb4969587e 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1067,11 +1067,21 @@ static void __ref zone_device_page_init_slow(struct page *page,
>
>   static inline bool zone_device_page_init_optimization_enabled(void)
>   {
> +	/*
> +	 * Keep sanitized builds on the slow path so their stores stay
> +	 * instrumented.
> +	 */
> +	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_KMSAN))
> +		return false;

It is not a major concern if struct page initialization lacks KASAN or
KMSAN instrumentation. To keep things simple, let's just entirely remove
zone_device_page_init_optimization_enabled() to simplify the code.

Thanks.

> +
>   	/*
>   	 * The template fast path copies a preinitialized struct page image.
>   	 * Skip it when the page_ref_set tracepoint is enabled.
>   	 */
> -	return !page_ref_tracepoint_active(page_ref_set);
> +	if (page_ref_tracepoint_active(page_ref_set))
> +		return false;
> +
> +	return true;
>   }
>
>   static inline void zone_device_tail_page_init(struct page *page,
> @@ -1110,7 +1120,7 @@ static void zone_device_page_init_from_template(struct page *page,
>   	 * to the destination page.
>   	 */
>   	zone_device_page_update_template(template, pfn);
> -	memcpy(page, template, sizeof(*page));
> +	memcpy_nt(page, template, sizeof(*page));
>   }
>
>   /*
> @@ -1179,6 +1189,15 @@ static void __ref memmap_init_compound(struct page *head,
>   							    &template);
>   		}
>   	}
> +
> +	/*
> +	 * When the template path is enabled, order the preceding tail-page copies
> +	 * before prep_compound_head() updates the overlapping compound metadata
> +	 * in the first tail-page descriptors. If memcpy_nt() fell back to
> +	 * regular cached stores, memcpy_nt_drain() may be a no-op.
> +	 */
> +	if (use_template)
> +		memcpy_nt_drain();
>   	prep_compound_head(head, order);
>   }
>
> @@ -1238,10 +1257,26 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   		if (pfns_per_compound == 1)
>   			continue;
>
> +		/*
> +		 * When the template path is enabled, order the preceding head-page copy
> +		 * before memmap_init_compound(), which immediately updates compound-head
> +		 * metadata. If memcpy_nt() fell back to regular cached stores,
> +		 * memcpy_nt_drain() may be a no-op.
> +		 */
> +		if (use_template)
> +			memcpy_nt_drain();
> +
>   		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>   				     compound_nr_pages(pfn, altmap, pgmap),
>   				     use_template);
>   	}
> +	/*
> +	 * Ensure any prior template copies are ordered before returning.
> +	 * On architectures where memcpy_nt() used regular cached stores,
> +	 * memcpy_nt_drain() may be a no-op.
> +	 */
> +	if (use_template)
> +		memcpy_nt_drain();
>
>   	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
>
> --
> 2.20.1
>


