Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63E1D6ACD7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58CB86B0088; Thu, 18 Dec 2025 04:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AB96B0089; Thu, 18 Dec 2025 04:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C0A6B008A; Thu, 18 Dec 2025 04:24:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FAAB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:24:13 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA50613C2EE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:24:12 +0000 (UTC)
X-FDA: 84232055544.28.92C1193
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D9B31A0015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:24:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4qQOG8M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766049851; a=rsa-sha256;
	cv=none;
	b=MzcRTC1ZdSLabS1xEhqADKxU0ArV4TSVGK6PNcy1jXVx1Fl7QcJ7SDtMt00dggdjlil4zo
	ggZQZW7yns1y7fowIXnd/CXeyTYWjYKoqQaEOorz+ONjHKfRQyTXnh8EfnPmH1KqlXdb6P
	JawoOgaVUCt5DI6JOkuFVH6GpOR7PJA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4qQOG8M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766049851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMrnHe2ZjIivtsm4JKnTaWTf/aI7xj5pyhDxrmzWzg8=;
	b=0nobHvDXyjS1S3e3ZRWf2d/s7V/KDhSf4Hm6yjpLYiI9Kjq0DIteY4gbgJj8g8w8chzxwu
	ONBN5zNCQ+ywELhdKsiGbHm/Yurqe3J5asj+xgn3/3HAFkgtHRSGgO0tvgVg9EQ9563/Ki
	cvdjqO7dd+F2FbovFYYmnjrNpOSFFI8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1C8142DA2;
	Thu, 18 Dec 2025 09:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC05C4CEFB;
	Thu, 18 Dec 2025 09:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766049849;
	bh=xG6w3fio6dKWuk97Zku7z65Al4P60C9/eHgl56AJCqM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U4qQOG8M/4YSGXJXhPf/Ht6cdkKIq/PjQRlLodfjxj11Rk0saqUhH/k2iQTzcRFJM
	 QkFtJr7rR20/MYu/HfyDWKO1tsycGHTcXT3l3Ox3hzUKkQJYhYhu1TOebee1twQQDx
	 6kS80h28IogzsQrlgGx0JHvItuBokvNTLoOOqTc7jfmlljUrLjfc8C07+xArsHgVBn
	 y5qmgIOcJfZhICYY2HkqSAxxN/9BULpaIiScXDqsueOLmOiZuG7Xv7P7ih26LdQw7E
	 hH0GR+YeB4L3yzprgxZG6WTtuqd59XkrfhJfNdNY/zGagswXZvZ54+Lcmrjj0qJ2rb
	 CGFzquffZA6Xw==
Message-ID: <83f303d6-ab03-4e28-95ab-04c5e879a916@kernel.org>
Date: Thu, 18 Dec 2025 10:24:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, npache@redhat.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-2-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215090419.174418-2-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D9B31A0015
X-Stat-Signature: 7skfgm857nqbfac9jjsgt6t8otfd998w
X-Rspam-User: 
X-HE-Tag: 1766049850-213416
X-HE-Meta: U2FsdGVkX1/f5u+BgfnslVxW15FJdriW//rALh/jBCarctAVIdvL/2oienuWpsFN55TtqlQt/omkxz3uQToBU37Z3bKQem/ggv/MFNOIXAu4iM2w/HWgPNdxnJYm5BFrVew1/1OlJgo+CoKmad+X1bxhJ2Sw+qOIa0DHDfSH+aSWl4VOLMCB+mu1qUOKSLCU3uRRtpPac9X7SVKjH+xBOHbTM2o8TrDqj7154Qat0NPvRMPRPupI+zKiYo7r4nYV+ke7BnNPp/gysKcLr+CbO/tMHYlK0gAi/OrOiWHPji8Xj6xM8O2iptKRXO9pFQX7S56YZFa65Si3+cpM+mdoiYlGiMoVZf3r2STXmIi2MEHrEwSVeWa8fOpDCAk2uyPnTShvLla6gflxhLCdfn7QBysQNsDHufVCc38vxbGhIOsw4hulLB67uujt5Q/3UYJKE/WLEi02Oixv6ElvY9svLoQFaEUZ2HbDigNRl57ebQxphO2Do05MkaOPUA9baVGI/kLb1daA45+8NByr/TmZp+Tu3vbGZjfNw3LsZ7UxIhQJcG6Fstb3YGE93gF3+9TvsDxD2YwcYqxzKnR9R3ZkQ92fbGv0eu8m5VguFQgpwB2mO9rdNVAQWF4bV8tLNtfShgfcKpvO0jReiBhGl9cZJfZ7y/SlQIlWdiP6xAnLdfp93As2QowLKe2VTzBtQZBnkNYesLDPBiHskAJ5PpbCQMe6y9u0AD7xffsFoK1rMD3SLyrbce7StfeUxXZ9su0nfh+hjh/MHG3tfTVZ1+EesuDLB3le0zWjtLPlgyVQXdQQFEOZPkPnJ7VqMQnNoOC2YeLy3EAuwH/JVEzSmAQWiuhSb74hoPW3KFjkbRR69yXcuSURzVKUFE2yn+We6Us9lSo2l4inNFcqzU7HgRCBA1fZuUztm54NTU352vNxWuqaLHJDs5KbRUl7YPsYMibxneYIoIVJxX+e7HJa7ys
 wga9dBjF
 uM19QOReJhBk6K+5BFaxNyCyjNPO9mVBcjEdjxu9RWtGrzjhH1cOmM52O4BFTfh6WuVIGUIIxdmnA4oIT8IJWQ3Use388Jqro7Ms4jEM4MYRDDDFDQYmbuG5DLuNWi1KkIxX/VcnCYo3ewP5TSa5na0FHIdRU3EgBpa4U1R6dUkgEw7zoLdesv/0bQan2FPVB/JxtFVNEprtVvK710zOxqkWHp7d3e5DYVwm9UfyTksYb+OUytnSG0uCy9X+X2Ys9rLDytD3XI0MOwZI7FpAE+5frZZaQVHQvFm3J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 10:04, Vernon Yang wrote:
> Add mm_khugepaged_scan event to track the total time for full scan
> and the total number of pages scanned of khugepaged.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
>   mm/khugepaged.c                    |  2 ++
>   2 files changed, 26 insertions(+)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index dd94d14a2427..b2824c2f8238 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -237,5 +237,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
>   		__print_symbolic(__entry->result, SCAN_STATUS))
>   );
>   
> +TRACE_EVENT(mm_khugepaged_scan,
> +
> +	TP_PROTO(struct mm_struct *mm, int progress, bool full),
> +
> +	TP_ARGS(mm, progress, full),
> +
> +	TP_STRUCT__entry(
> +		__field(struct mm_struct *, mm)
> +		__field(int, progress)
> +		__field(bool, full)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->mm = mm;
> +		__entry->progress = progress;
> +		__entry->full = full;
> +	),
> +
> +	TP_printk("mm=%p, progress=%d, full=%d",
> +		__entry->mm,
> +		__entry->progress,
> +		__entry->full)
> +);
> +
>   #endif /* __HUGE_MEMORY_H */
>   #include <trace/define_trace.h>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index abe54f0043c7..0598a19a98cc 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2516,6 +2516,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   		collect_mm_slot(slot);
>   	}
>   
> +	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> +
>   	return progress;
>   }
>   

Nothing jumped at me, except that "full" could be called 
"full_scan_finished" or smth like that.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

