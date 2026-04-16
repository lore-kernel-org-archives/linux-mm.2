Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE5A7F43841
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1BA6B0005; Thu, 16 Apr 2026 02:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B7A6B0089; Thu, 16 Apr 2026 02:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B4C6B008A; Thu, 16 Apr 2026 02:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 331476B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:34:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D91D5BAE1D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:34:57 +0000 (UTC)
X-FDA: 84663456234.05.4416697
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB78D140002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:34:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CA+zeACm;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776321296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDHjIGP2sDM7hq81LUFhFNMqKnLfS/kpxiTLXkT2VCE=;
	b=CUvo/rHDSt2vT2kvU59am+G2O2jEG8gosb9GaGgxbrtwUgFVswFmvjwPwb/ntcdVd3+l/J
	5kIljqCeqxkwJDBaL1fQec0R1npKYt8SsT5jdi/Q2LkzZJt0d7EgyOss0AmpKx7d1KtG3c
	l9HWAovM9ul0SCpbLsY8zUCGUZmbdAA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CA+zeACm;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776321296; a=rsa-sha256;
	cv=none;
	b=ZTn4kGngO3R+0vn/CLOC7B1c48v/gQT03u/3kmoaXiDhtWZMKC5OneAJ+bkAiSy+cDUUy2
	tipVL6dVOsAP8KtRJiFOFqoKC+gIOskZYq34lB8qH38NfMjZBi4xhnJyJIbHKbDR+FnxQF
	cL26SOeDNlDH9meoWAsdijau2DFXds4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1239125E9;
	Wed, 15 Apr 2026 23:34:49 -0700 (PDT)
Received: from [10.164.148.39] (MacBook-Pro.blr.arm.com [10.164.148.39])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 871D73F7D8;
	Wed, 15 Apr 2026 23:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776321294; bh=ziInnYwfR3yWZrCQOeoQ1nSAx4XZG4lKRwK0zno5cuk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CA+zeACmHsjs86HPLF61HtcjzxdugiXRD6NoW5ykZrsPdNT1h/FT/yCamV2pD1/Dt
	 ewBcfl5s4zR2SsqaBUCRHqr2x2KXxQPX3i7tAjZcY+kYZoL9TrFc2V+xVYvbPzCODZ
	 nmochaV7pKzP7jqRzMAzfS71pTtFKzu2UKj9Zr14=
Message-ID: <0eed63fd-4119-44e8-90e9-79bca1620826@arm.com>
Date: Thu, 16 Apr 2026 12:04:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: fix spaces used for indentation instead
 of tabs
To: Xiang Gao <gxxa03070307@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, donet.tom@gmail.com,
 Xiang Gao <gaoxiang17@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
 <20260416052752.713821-1-gxxa03070307@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260416052752.713821-1-gxxa03070307@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB78D140002
X-Stat-Signature: bdxcxoowrczeaek5fyrjhb3nk44oahx4
X-Rspam-User: 
X-HE-Tag: 1776321295-298627
X-HE-Meta: U2FsdGVkX1+V8EvHYE0qOQrQYRoWTc8ZmOGZvXenSC/TBsDPagRkOO1RoicbLF9XtJyu5jljREYZ1hAUCKZ7xPVC0pyFLR1IY+cIJr3T1ifjZCllppU9raOGbNXcnfvqolGzdXSptyvKsenCcULMEQb8Pb6crMIRW3vl+zXAKU9OQcAOxCyPXnqrn/GgPSI6pnZEWrwfJ50QBr9snq5F07iuYGKOx5HN6qJhjVO6U7UlaDwMeQqd46gs5LoAR+gBGn6aquE4pVegCg4icusb2NuavqcK63vpB7i/Iw0I71smwpNRjhIUfihdF2dHgDmEr2sjIamYu+WuoZUvQsHTjV0tL0RnKO7/95pdLJKlxO6aFVBsuYkMWiWQtoABlAKRphvPT1aU3xF/E+7/mfTMbaPZTW/dlwXfFLWRETZdYiMpCaH0d26cEnPKMaK4G5EUJn2GR8zswKbvHXw+Dir/I0ANbsM54pXknLdAtW9LFIviumKCtV9z/s+ahmJlmNXVIcqpWIMzvuD9228xjMOy7r5D9IBIkqU5lOhwiwpsmjzNGR/h+1ROn2f9eGJoaiZc+UoMc0GNCMCE5pt1Ojvv/EM3SIFwsj60D0OMHfLvyi8mGNrKeQ/OtrO6uzYNcBMqXhVNpFfqrDH8KKPMDMkCcCCGSViFRrVNW3H7+KnkC1d4IMbsfsoED+ZH7jQs+H1sbJAU2zFvBk6hiPR5SAPotqLQ2aQMSAfqQMVPFYCY8e3C0x5bIcLvrBpwJvQnwLZglDiQKidl3WiJwH2NgBzx7MZ5x/eEj5g/YngaL0MS6hJGPt8o33JwQKFC4sy3hoH+R0VRBYgeW/RpDKm81cJ34DfooVZtDxz4oicySXoITreRM+lX22oINRfeWJ81tL4DNGJcPs1Cci9Xqv2+at2PwY4xDWdu6JGGbKUPNzbgtxtb+cXp2kDezsYJSjud/2wnjyQ23wB31l55+A+Qfc9
 vXphZF87
 rQ7zWohOA5o+yBZTdkFjtGL4XPzmwiI08+a1ibTX5+bcZjMJJ+VvEu6LOQhiy20b4vaOKR62FRncz0hz5/jXS6ZMYb7JIfUTXrfHJHHKSyettj76oPQgNdY/wT19IKSZIWdtc4zSu3QtcdAmdvKkRle7galLVJZDgGy45PJkQMGZLIgo2A88TjNVndLD/8wTFQJoEhwO8c1ylRWxrVDeyfygjsMZn8bindSxXxOv0isVMenj/SJtDvFGSUoXIWAevnX7q+fyWZPu335rXxGwm92MmBqAOtQ4e/4Mr5kn9duZAhW/Y9K7i4rRdvpuQoNU2SX6ZsJzKUcfi5oI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/04/26 10:57 am, Xiang Gao wrote:
> From: Xiang Gao <gaoxiang17@xiaomi.com>
> 
> checkpatch.pl reports two indentation errors in page_alloc.c where
> spaces are used instead of tabs:
> 
>   ERROR: code indent should use tabs where possible
>   #887: FILE: mm/page_alloc.c:887:
>   +        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,$
> 
>   ERROR: code indent should use tabs where possible
>   #6626: FILE: mm/page_alloc.c:6626:
>   +						         sysctl_min_unmapped_ratio) / 100;$
> 
> In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
> spaces for indentation instead of a tab. The identical VM_WARN_ONCE
> calls in __add_to_free_list() and move_to_free_list() both correctly
> use a tab.
> 
> In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
> tabs + 9 spaces for alignment. Replace the excess spaces with 6 tabs

6 tabs + 9 spaces -> 7 tabs + 1 space.


> + 1 space to correctly align with the opening parenthesis on the
> previous line.
> 
> Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>
> ---
>  mm/page_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..752673a9b43c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -884,7 +884,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
>  {
>  	int nr_pages = 1 << order;
>  
> -        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
> +	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
>  		     "page type is %d, passed migratetype is %d (nr=%d)\n",
>  		     get_pageblock_migratetype(page), migratetype, nr_pages);
>  
> @@ -6623,7 +6623,7 @@ static void setup_min_unmapped_ratio(void)
>  
>  	for_each_zone(zone)
>  		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
> -						         sysctl_min_unmapped_ratio) / 100;
> +						 sysctl_min_unmapped_ratio) / 100;
>  }
>  
>  


