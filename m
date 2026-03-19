Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85440108E1FE
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6B16B049E; Thu, 19 Mar 2026 08:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87856B04A0; Thu, 19 Mar 2026 08:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB206B04A1; Thu, 19 Mar 2026 08:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5C86B049E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:22:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B3081604E9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:22:29 +0000 (UTC)
X-FDA: 84562725618.05.F88B94D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D77714000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:22:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773922947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NoDUHnsqcrd3qtBz0MzbtUQ4Qt0DSZv3jE11sc/V9Hc=;
	b=e5HnoRwmAxxkEbwO57M1W/tQ6WbXVm18J78MY/woglFzDVClraJw95t+rWPg6kyIbWzUWz
	3yevNLdikr23vS6xqI8bQ7lYoYL76WWtiObOX51H53u9ZNkqQathzeXp/JhOmyeF7aVB9o
	yMSSgAcEUY0MsuZjtIadg9uEzl5ZG0k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773922947; a=rsa-sha256;
	cv=none;
	b=1vrcRnL6eZM6eYos6XhmYSTX1yF1RVKRIME/h4fjH0ul7h3nSRz0elcdmvJyBL+CaEYIQ4
	r8lHgwYm+dZw2R9b3pqwxkD6z863yA96xKZQN+W1xpQVQ8V04AFosRrhrTemh/yWtTY/wT
	DKJKfREjsp6yqCCY8PFRVgew+wlZzQo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 513311A25;
	Thu, 19 Mar 2026 05:22:20 -0700 (PDT)
Received: from [10.57.85.34] (unknown [10.57.85.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6B7C3F778;
	Thu, 19 Mar 2026 05:22:21 -0700 (PDT)
Message-ID: <0d963ff9-9222-4e0f-8e57-ff22088ce978@arm.com>
Date: Thu, 19 Mar 2026 12:22:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] vmalloc: add __GFP_SKIP_KASAN support
Content-Language: en-GB
To: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260319114952.3241359-1-usama.anjum@arm.com>
 <20260319114952.3241359-2-usama.anjum@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260319114952.3241359-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D77714000A
X-Stat-Signature: paa7xj7o9fokdzth461xux1nnd4xkpnz
X-Rspam-User: 
X-HE-Tag: 1773922947-966932
X-HE-Meta: U2FsdGVkX18womOphIEy+X8XvjPYsrYMarg4G0/YisCfLv7gh+AwxxyVGNpoIHtpTov5EYqcs2nm94ESoyjBla0oj6/0Vp/qwgIz0ZanZ8q3S4vsG08uxt2D4gu32iAzHGnFGSgjMVGq4TKmYO8iN7EbxiSf5eVeK72FahTno+LI4KD4k9kYDT8Wek+f/yOa3WUdR4exDEkGqM4+E5Fg9JBOCa8mzBjR5nUA+bcavmqukFbAM346APlHjoyKsUKkcZJ2EWPC+97H3XCQBy6msdqi4y1mAPspWKz2B4Izyk3xRCTEQumeBtP6NhujvnvcdRBs3T9Pb1P9xQrWVpSiS+KKNXsKXI63BiV4GZR95MOZ4qi2Vg9WH8aBa1BkkfmcE+S8kCbYqO+cdf8x4RyqAarj0KylsTmWEKXUmuzNi9wF8aUFx++fhRnJIcpy67d/mcTC6xiYvyTjzuRD0RvmvWnAPzf0QkK2EhD0SFKaDylpvZSXUX4fv0uaf/Ef3hS4AioL7tWIXQvAdoVUXvQAwSPQcoEgQjjwhM/9jatlS00emlFZE3cp5lKRYgolT88bEGB+y74wqZXYpZbbDOFxL1plwLZ2Uro+6To8h2R5u+afNleJV4p5cJ6ChWwy+YbV0vvLIPTNJ/X05WZQGflkYOos7rb7Ai5FbnwCTWzeEqtCSJm2IR5Bqq/EDDZLvciGtmMKQjYBL0TomfUtiNgySAwYCxt14FUxIaWmXMa6Vkn9NzgnHJ+jI+9sC775aLn0CrHpPhGyyz4bFLt/QQIIj+h06AFqSqBIc10AV/i5mszN/ZkTfCdQ1w1ahgbPArw6omC6zb0gp1oF44B1fqBSKecHg1GakE2+ovSdhrB0JvFisVDD2fUSgOzEOu4OQPRVMb68/9j1ZnAVWizOu0PbCsEINxJtezBETiU8rqCd0s2IZ6xbF8WH5C2GoWouLfg9/ooxu8ktzrGcDeWqcjl
 OiqgIexm
 9IJ6+sAgAoP+2KVv2VveoZDEEs9ZB+5lsnQqvcmUB6c21Pp2E0RmMA4D+IIjh17KCmF9TMuaz1vjadC0w8BL8/xHYdNPs31owbjX3CxgJ4f6C3md/B6DE3WvoqAUK7gKcZHomhEpVQLVTtPgsWPCPsOe5jEhZhBdoPSVWcUvJYqZHwiJ0GYfgGcALkLqnBGdZ2QLFtHaNirMTeSXqpUMJD2tLULGhGuBZd+Gwq+FZXaCsT0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/03/2026 11:49, Muhammad Usama Anjum wrote:
> For allocations that will be accessed only with match-all pointers
> (e.g., kernel stacks), setting tags is wasted work. If the caller
> already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
> don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
> returns early without tagging.
> 
> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
> APIs. So it wasn't being checked. Now its being checked and acted
> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
> defined there.
> 
> This is a preparatory patch for optimizing kernel stack allocations.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  mm/vmalloc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..1baa602a0b9bb 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4041,7 +4041,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	 * kasan_unpoison_vmalloc().
>  	 */
>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
> -		if (kasan_hw_tags_enabled()) {
> +		bool skip_kasan = kasan_hw_tags_enabled() &&
> +				  (gfp_mask & __GFP_SKIP_KASAN);
> +
> +		if (kasan_hw_tags_enabled() && !skip_kasan) {

It's unfortunate that kasan_hw_tags_enabled() is involved twice in this expression.

>  			/*
>  			 * Modify protection bits to allow tagging.
>  			 * This must be done before mapping.
> @@ -4057,7 +4060,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  		}
>  
>  		/* Take note that the mapping is PAGE_KERNEL. */
> -		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
> +		if (!skip_kasan)
> +			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;

I wonder if it would be clearer to just not call kasan_unpoison_vmalloc() below
if the user passed in __GFP_SKIP_KASAN? It's really just an implementation
detail that kasan_unpoison_vmalloc() skips unpoisoning if
KASAN_VMALLOC_PROT_NORMAL is not provided.

Thanks,
Ryan


>  	}
>  
>  	/* Allocate physical pages and map them into vmalloc space. */


