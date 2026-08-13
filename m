Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49297C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C176F6B027B; Thu, 13 Aug 2026 12:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDA06B054E; Thu, 13 Aug 2026 12:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB69C6B054F; Thu, 13 Aug 2026 12:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA776B027B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:54:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E49B71A0207
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:54:54 +0000 (UTC)
X-FDA: 85096845708.25.5BFCEE4
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1959380002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:54:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FHeiJupv;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786640093;
	b=mXj0rMojZkEC9WBZ4wJ5hmBXpTZlILqUPMCihcTXGLlicNhqhrzSB8oXUjFs+KHM148QM1
	oHzUfY6hi1Z2bH9OfWbPLfILmjcUsUkjyD/6c/uZ1rJ+lfcHDufR2mDEn4QwpSrJ0IdW+8
	Xbignzgs0xvm7pPE3Ra5SLIU/qiQBZ8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FHeiJupv;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786640093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZF8aKVZrYVCh7+k16WJltKqPpEr/CkIHv01ANgxJqc=;
	b=gfV8c0Z5A1C9jMWYNgu6QiHOZZ4V0xUXzNPOTgHwl9zGX61JVZ4ulzD/DMMZBH8B+17Y+M
	N6uls4NUVnTSEe9lj4hsDg7kOoNsjyjeMgrhjfocTEMAMQh3iPTCU0/sDkaJqCSSgohh+d
	ct1LWxjAp717fSDKxNHVnuE9DAzya6c=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1671ec8692so22292466b.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786640091; cv=none;
        d=google.com; s=arc-20260327;
        b=GF2KDLn3/1PghGMrxAwus/fQQqCKQ9WNtKmoAEx9SlcGcrSEHoiZ2pcZdtU3+QYj9O
         hUa5MY0dMsx6he7I2pFbFgqyIaTZpF2nYy//pgaLLAZJdx41z7nFyRVy8y1Q3s9pPrjv
         f5tVs64Gw49qkw/mNuPb3IgEjO6GAVqYOeCIvM1X0r7jTWCBswU4jmBniLhTqglsC/Go
         xh3S1+TkVtRL0pw3zTBvvHGOgx/2+JSTLc1lPyuGhKZ6ID1d2Q46S5Cu+MLoSnuQWFpQ
         rwd4dPxdYs8lARkG/SsAxq9WDAUUMBsGaPNzU7JRZfIlwIbzBLPi3oNG+dS8yITvOnG7
         UZpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YZF8aKVZrYVCh7+k16WJltKqPpEr/CkIHv01ANgxJqc=;
        fh=ctMiu4LrH7HpDGA6W/13/okPxSD1uxAWh0a2WMBvIy4=;
        b=fWY1UjSNN8nBtz51esZ/vNXKEi1+Qm69DQVmRcstMxCOjUSdNU+qmDXipCWF6HMf4M
         KtOIvYLYSafcSeOEsjt7FbFinlSbTnfZFjnFm2cn0B7+zjOe4x+waooEtSCgGpenrXvQ
         ssfm6iP+JARrChVjCkajK+Ud0Pshn37jQ3Ami9c4ziQcdh6xDI5xn9v9K3++EgXKiDuN
         CjUr9tOx8NsQniZ+daA9tC2pyC/PXOHogx7ruFgLVubmPKCcKfVfZEV8YQ/YoBNJN7sl
         VQj7weKjnol9fPdwRv4UnRrOHZrvlgJA6lpkEJQ/ka1M8+HIYf9M/P+SKUiz/a0EvXWv
         Z5rA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786640091; x=1787244891; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YZF8aKVZrYVCh7+k16WJltKqPpEr/CkIHv01ANgxJqc=;
        b=FHeiJupvD9LGe4lIQ5foKmJne5r+DWnBdwuPZ1T02O7ynFsDg9Fva2C3RawRR/qJ6l
         n/PFfNKvKC7JL+xUgwSTu9t+T2f6uLp9C2FobBnOsofGlU46BpQaN4d0iOZJKMbBPBsP
         0oIDOxw9efVqjnCZCG7/Pzjd8vY6/bEQHs87SgixX6WwcyT7UcMX3RtfS9Z1oq+JHKoy
         8BzqpKIua1JJPT9zu3R/rYMkFZcaA2gHCB0JAXvVItHEpo5m1GX3BWBqIuoKe+MksaMD
         pe30IUJaMRW0UxfS75tBluMx4Jt73c9NU9k9yk1c9N1mLWkMrcI4rim+2SKhRgcSABVV
         3TTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786640091; x=1787244891;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YZF8aKVZrYVCh7+k16WJltKqPpEr/CkIHv01ANgxJqc=;
        b=f4Bs5fft7eRBZfdCpQWtjwANCrtus8/Tw9CGv072Gui0atN2DlybtlmbgLi6KPCeQT
         94Q7nKZqdp4W8Cy5z1AIaMOGJpK44owVM27ofIOpeR/P5i5BT8XM0yKp924QhE/6aQLr
         /d9NJcEGZFRQ4wF8Xiih411G7RVb41KVxKEmVY0qqD2w8r15hrbSkcxYTE4XLPr9QrCa
         jtrgZCjCLT4C8vt0KMPuGoeF6uxlce8nVhb0Ce9YYRI2gHlgsTxCbi9pW8rf4sEkwHV9
         oJb+pskKFQnArj2i8HfxeHdch4dyqQXjoB9oW4UfHMc6yEcQRkM7MudAd3ZYIJZRBVFk
         lPRA==
X-Gm-Message-State: AOJu0YyM+4CkVQm5oiUNRiZZqIFSiiw2K44yrJYW0jsoQ3kKGKm89bDt
	7a3wP5xliI0QlIGzYpTpzF99GtZH0YKFSYStLxXh3bGlJFzf23Bib0j/sjLF+SXcanTbpwRR9aJ
	5JKFda5mfi64ii5kzrvUl7bXb85BzntA=
X-Gm-Gg: AR+sD12h1AR56Gk3tYQhgKWbvPCUoF/yW1CLE8E9vcgAyMKgcT132EFETUzKiquR46A
	EHmSSA3ixg4DM2vSR8Ws5G/Nt5uTge287qHfhuCVKKkZV4ZCcJz497jMDW2oyU/zZZV2bAEtXZ8
	Oy+yfg9Cj7hYz+PhBRORD2ZUBfbDqYEJJEFS6Q+AfxBVa0i/vbvLrysO+F87XzMlfUe+IE0tf0z
	K6+dMewCqdIVbQw1CAsO/oPuwuakEzBd/GxAe5dTHqRBYVCeHiLRqtCChSJFwSRu/rEY9HMeWFL
	Znmm8W0Vo8e8Vmn9cuUY0q3+UdrM3tZ4RfOm9lSvNU8BJ8BzYu9ECtrPCZ+nww3JwgM+s4kidox
	Jlw==
X-Received: by 2002:a17:906:7947:b0:c12:631c:67c6 with SMTP id
 a640c23a62f3a-c2108ee3e29mr325611966b.1.1786640091317; Thu, 13 Aug 2026
 09:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com> <20260813-swap-thp-cleanup-v2-2-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-2-d2ee48c6aa49@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 14 Aug 2026 00:54:14 +0800
X-Gm-Features: AUfX_mwH8tDMiLjXi-Bmpa6vH5hndTs5qrgc8m85VxWXOLxwtPN0GXklvgSZjAg
Message-ID: <CAMgjq7AG4BLuDwJut4rTPyi1_T=CbhjxM0xZFaKjddQu=ZHwkQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/17] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1959380002
X-Stat-Signature: q3q6n4snhdrpq7k6mwekos56qik13tbk
X-HE-Tag: 1786640092-516778
X-HE-Meta: U2FsdGVkX1/K2gK1OBtrnJwSOURjhswDhzr+K6YKA+hnjbdyAagsD01zpHYPF9U+groI4gs467pE24KPoC47F3Dt5/BINz2oxaJOpOjqXcB+/nXpPcTLcJxxR4ccobu/t5LwZvVYwDc+nZmhVv7DW0/RWhtXuwKaLQWobJDb2uITckb0tgXyCSRAXajj7EvtRaTsxNYwKU/nmnH5Pp+hYUJyqyzeVEFj2OeXn/uXsH0LuoL0GFT1+jr2bmj4wipmNvWxLVCK92xJPIZkf0a6epE6l6+MIACPxkjyAxBS+8DQU2isuPRY7R5TDMTUXWnDntEoY4Z0pkSHdSNMdfkGnyLPU9a+viX42KVsMj2fAB3Y2OTCgu7ez9+wo1AHy+L8eNGOGViFvGjYOgOhrhBOTDEBnwtlb4G1c9w/USliAXnSDHeq3x+zic+KCHtzUogHsHuY0X9p4FzK+Vw1ACoXeM12uHGThWwb1YSRxaHiDLxdN1EgmCwyWWd/OCGOseqpqIw5q4lVUENQr3FxqeOibctV451kiN6FkN6VhK+sDUe5CMdPPnHwwsKQwQE0Homns3PUwdB7ci7o5Um1xX0QsTxxZ7xX5BMqH/YZS8C8A6oyqCkyP+5qilS+0av4vD7LJK+LzH5ytapzlodlBgfbiDnSC5jLkSeMoe88XCehKCKj+y543NgpMdWdtqBk5C1/lIXbybT3MCnlXhAUD4CDncUpw47yXpxM7G0SyukTBSZmJ7FPLJALPwjBqHFdxjmcYHj+taL4Y2/9/rI/mtAiiHD8ISfmTZd6c7iqKcFw/8M8W4RYidu3Pd97nHAr1nXuzzBb20jhmcK35jvsVZ+M8NzrbYwmpw31OI8u5SNVSxUj+kPaWg4fw1SjGKzEwD8uOVXnhPnRCCdcDMg9zsGa+XZ2oO7Avgzz8JiZAzmCxm/0RJYSnu99sCg2HWhn8QZUX6bBtTRd8jydyETMuTJ
 gs21k6Nk
 eSq+q5LJClcTqu6j+dTQrLKW/VLbLuYYlOlPyQd07O6BkF4ltzJ1VzffqhNGRoUktTXwuYg7dxFHLVIbzJq8rZnymEyEaTizH2wwdmk6FvOnLAHL2rlQ77ji1kCWiJXKHWZSQ/KJgDOfyVJWoXO39nj3ambIaOD2JJhGZElhWTj6Cd3wnjtypHRf1JhbhCD8G4FXRpiwsshGuLfK5opKP6rdSf9b2WMA0hI5CIGnzXt6gk7TR2EW8O81VjkC1TcsOEPfwwHmYFb/3nOYRss4lYcMk0cv6cpQAXLlGmanr/IASjy7KwVDHjCgop37diL3+grFZfabp+rUvCpQW2toXRTUl9lz0Ecy/6M5+5ddS4d/XgQO0W5CF2kpII4SErpxDiXpx5XQNGGPEii0EyapsbgDy2KXA4l7UTKQIaiWBrlcciUfUjev+QDYrHZypj5fkZRhhcLwt63zs3aZnNLYAljACSJbTF/VeI4/n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So sashiko reports (TLDR: false positive)

--- Patch [2]: [PATCH v2 02/17] mm/huge_memory: fix rejection of swap
cache folios with a mapping ---
commit de15de8c8cd6208f74b7fc4e795437aa367a9b26
Author: Kairui Song <kasong@tencent.com>

mm/huge_memory: fix rejection of swap cache folios with a mapping

A folio in the swap cache cannot be split if it has a mapping (shmem). The
split code currently does a defensive check for this after the folio ref
has been frozen, leaving it frozen on failure. This patch moves the check
up front to folio_check_splittable to reject the split before modifying
any state.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43a..a6759a14e057f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c

[ ... ]

> @@ -3983,14 +3994,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>   }
>   }
>
> - if (folio_test_swapcache(folio)) {
> - if (mapping) {
> - VM_WARN_ON_ONCE_FOLIO(mapping, folio);
> - return -EINVAL;
> - }
> -
> + if (folio_test_swapcache(folio))
>   ci = swap_cluster_get_and_lock(folio);

This is a pre-existing issue, but does acquiring spinlocks here while
hardware interrupts are disabled cause a sleeping-in-atomic-context BUG
on PREEMPT_RT?

Looking at __folio_split_unmap_and_freeze(), it explicitly disables
hardware interrupts earlier in the function:

local_irq_disable();

and then proceeds to acquire multiple spinlocks, such as in
swap_cluster_get_and_lock() and folio_lruvec_lock():

if (folio_test_swapcache(folio))
ci = swap_cluster_get_and_lock(folio);

if (do_lru)
lruvec = folio_lruvec_lock(folio);

On PREEMPT_RT kernels, spinlocks are mapped to sleepable rt_mutexes.
Attempting to acquire them after local_irq_disable() attempts to sleep
in atomic context, which can lead to system crashes or deadlocks when
large folios are split.

>   /* lock lru list/PageCompound, ref frozen by page_ref_freeze */
>   if (do_lru)

---

It's pre-exsiting, and THP is not supported on RT yet, so no problem,
and that is exactly a good reason for the following patch to swtich
from local_irq_disable + spin_lock to spin_lock_irq. So we are in the
right direction :), and we can extend that further based on this
series.

