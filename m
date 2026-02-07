Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B9E8EE0AEC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00246B0092; Sat,  7 Feb 2026 17:02:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAC36B0093; Sat,  7 Feb 2026 17:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6E86B0096; Sat,  7 Feb 2026 17:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB136B0092
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:02:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2274D13B080
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:02:39 +0000 (UTC)
X-FDA: 84419035638.03.96CCE80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 60BCE160004
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:02:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YRqXTTbc;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770501757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16OFG3f4YALzf7XNPRkEdKjp7dc+uIFyTRnt/KCcElg=;
	b=gekVvmzEnRF4z338vmtMaWYbq4MhMROX5Hlutlq2gb9v4wKkpaL1tHRijUUPPsK9GxHZYc
	lPLr+4pIE7GuFJkO76pHEO0lhAPWAioRN91Xvq5RHiC2bn69cc8QIh+2k9EcmgpKHKNsPa
	j/1+ZNe8Ca5vkGjYRrAXF8ReQqQe3oM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YRqXTTbc;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770501757; a=rsa-sha256;
	cv=none;
	b=isG1fB/Im5HOy99WS8xiehKspHebbHe9blOuYZqL7GVDL2SOSVrRVXlxTkGpC/sPw4URfl
	jBMt/v5Mh6FxHGny/N5v6ap+AX2i9oiH/z/Jd2UD9hOWkBsKYaBvDcy9bP0HFLBomCxEks
	5hGLSPyec1MxxBtvyLWwzysJRXYwmRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 780AE6001D;
	Sat,  7 Feb 2026 22:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6812CC116D0;
	Sat,  7 Feb 2026 22:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770501756;
	bh=lfcGFF8NdgjshgOUdzirLedNFsV9Zt9+VFJxLpuBxJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YRqXTTbcGx40NrSqDqzfY/onQI7Oo//mZmwZDyNY/maP0p4HOQPI7MDjeHSgpXcgX
	 v4bKJmWQvAk51DKDvBbnvx4blrRUsLdNewnoFGTBaCzTFVqefb+Qd6bnQOadW/LaJB
	 HdS1hvjs7Hd3pvTGf54NcqlYVq82l6vB3dnc/ncKmGKGU1Q1kaef2CPUrnXr1RMPpu
	 RcJlSKs0EIE/Wm74rWbYYQro8YLZELp6JbrqWqPyT9f91QOBAsdVRE2HPNtBRfCgJU
	 e9DY0ErMD7D29hs8O3KJprmdTIj/4zYBLY0xu/eaFy+GEJwsdY2YhbSrTVRgRTdxMl
	 sQ6c+OWqZyJgg==
Message-ID: <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
Date: Sat, 7 Feb 2026 23:02:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 npiggin@gmail.com, linux-kernel@vger.kernel.org, kasong@tencent.com,
 hughd@google.com, chrisl@kernel.org, ryncsn@gmail.com,
 stable@vger.kernel.org, willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 3sr9bjiq79zjgyaoctmmyxszdwb7s7a4
X-Rspam-User: 
X-Rspamd-Queue-Id: 60BCE160004
X-HE-Tag: 1770501757-600954
X-HE-Meta: U2FsdGVkX1/Jg8DQasdeKiu0u4RZhDTtzpQTo6hpqPNsSAK7HveyElC3a7gVI596fzqqszhMqiRazUp4+LTA9gm4ACAJLx+WtN5TJN8pGTQYTwVQ+qgGhc+dZLzjCRcGjfcSe2m7nUlsPKKPCbV5MnsK6XgC0D1ec3U3DjFrPOoZP6Jn2nF7nZq6teyVyYWlQ6IdG8Zxtxl3Ewv3vmbuMr2AFTC/tfG2yOcgj+QGJnz9gqFRWIJ4fMjJVZuM2YKER4r3y08Dv2kAFLTmr2qx4WQPZbMNKYayrlf/c82v+12caSpjQp4YNj2xuCEpXeX5fk9fDVffvpJIkm5CmqVEgWqU8gRFrI5+IApzx07yYZpckRXpP0ayhRWBpUQlrdrpjxj4iw6lkkWtcEHL0p/oIiPoYlJrQtFy8ZRQNj2mfbAnwEMWPaPtlleaZ/6fa+ZvUAOaBcX9NIeLcvegh6aDnlb/xDD26nZYPeW8Ps8CrbTTKBaKY+8BEejMRFCZIMEeq2jX42Zve7tT2r6jg+R6EgOjeiOr5o55tXwKH0QDcRepcLlc37yQiPSzJW7Gan3g2AWli+xSszWSQZ27kEkr36E+3NmLxa75HNY343jFoiH2x9P9854ZdGNvaU8EhCOFWG9qIK6oXQT770CHZ4OY/eRzbx2CKWfXW7CH1HS0W/aYalD65e+uFHj3ygpsbTHYlBENqYupbBGKNEYIuHqayAd4FkES48oQoMAA8AG6nG6u0p+JE0NlP/vZS5pAgZzzt8pKUafe8sXkG60oolND5Gic97T2RFL7J1B/imWFaUNGT4zi1aDAh4A2UvOp8WLx5He+cJ+bvJOU4ZPLDUQZjZDu7u/wJBZzwqXrPifvNbpJcjHE9MsIXLeTKIUsYtfY3GUVtNYyotXuf1KP4vMkwrbncshSbipH6mWkz8h1LaziFtfhVGaCDvimEh962QCX35fTqz/7KbQQU5bmXsc
 00TlAj3s
 /+Nv2NvfyVUVcYaEEJP23I7UE00l+SZGoYnuB/DAHUK1qclIHWWPqaOA55/bJIQ9QztWzqYVAM38Mfa504KHsb33Nc51Ven9oD4ewY9MGJdA2sEjJt/gOAXdvWpvqYczh2T/kjGGSZffhHI6CwtgZ51za4ASzd0HLbfrQX4ECZyQ9oK6wuqnZMcQyYALCf5VJ+1ZI7Ox5D+vX0dKgECvwaGYb0vxAnV5hsRfu79VZ6coI4Xz2AM8xO+W/BlP0fHQtgmSDeU1VdV1IVP/irLf0a0x2wY9zd/7BpMaEGS5N/6DLU4XhgbiHgoTi59CioDwydXbOlwjX8rJf2kdRGFacoTpuYsG2lrmSoHbe1egYO8IdEl7aQyEshLjHonQPkpE38R02aHrzuBhOAQ9OH54hc/VbIxlj1oZyrCj+xOm+tfg8noPRj8rVYwthFsR6+b5N4vQR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 18:36, Mikhail Gavrilov wrote:

Thanks!

> Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
> clear it before freeing pages. When these pages are later allocated as
> high-order pages and split via split_page(), tail pages retain stale
> page->private values.
> 
> This causes a use-after-free in the swap subsystem. The swap code uses
> page->private to track swap count continuations, assuming freshly
> allocated pages have page->private == 0. When stale values are present,
> swap_count_continued() incorrectly assumes the continuation list is valid
> and iterates over uninitialized page->lru containing LIST_POISON values,
> causing a crash:
> 
>    KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
>    RIP: 0010:__do_sys_swapoff+0x1151/0x1860
> 
> Fix this by clearing page->private in free_pages_prepare(), ensuring all
> freed pages have clean state regardless of previous use.

I could have sworn we discussed something like that already in the past.

I recall that freeing pages with page->private set was allowed. Although
I once wondered whether we should actually change that.

> 
> Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
> Cc: stable@vger.kernel.org
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---

Next time, please don't send patches as reply to another thread; that
way it can easily get lost in a bigger thread.

You want to get peoples attention :)

>   mm/page_alloc.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cbf758e27aa2..24ac34199f95 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1430,6 +1430,7 @@ __always_inline bool free_pages_prepare(struct page *page,
>   
>   	page_cpupid_reset_last(page);
>   	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +	page->private = 0;

Should we be using set_page_private()? It's a bit inconsistent :)

I wonder, if it's really just the split_page() problem, why not
handle it there, where we already iterate over all ("tail") pages?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2..cbbcfdf3ed26 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3122,8 +3122,10 @@ void split_page(struct page *page, unsigned int order)
         VM_BUG_ON_PAGE(PageCompound(page), page);
         VM_BUG_ON_PAGE(!page_count(page), page);
  
-       for (i = 1; i < (1 << order); i++)
+       for (i = 1; i < (1 << order); i++) {
                 set_page_refcounted(page + i);
+               set_page_private(page, 0);
+       }
         split_page_owner(page, order, 0);
         pgalloc_tag_split(page_folio(page), order, 0);
         split_page_memcg(page, order);


But then I thought about "what does actually happen during an folio split".

We had a check in __split_folio_to_order() that got removed in 4265d67e405a, for some
undocumented reason (and the patch got merged with 0 tags :( ). I assume because with zone-device
there was a way to now got ->private properly set. But we removed the safety check for
all other folios.

-               /*
-                * page->private should not be set in tail pages. Fix up and warn once
-                * if private is unexpectedly set.
-                */
-               if (unlikely(new_folio->private)) {
-                       VM_WARN_ON_ONCE_PAGE(true, new_head);
-                       new_folio->private = NULL;
-               }


I would have thought that we could have triggered that check easily before. Why didn't we?

Who would have cleared the private field of tail pages?

@Zi Yan, any idea why the folio splitting code wouldn't have revealed a similar problem?

-- 
Cheers,

David

