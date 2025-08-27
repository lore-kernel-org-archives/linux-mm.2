Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C95ACA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75408E0114; Tue, 26 Aug 2025 22:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E788E0105; Tue, 26 Aug 2025 22:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C428A8E0114; Tue, 26 Aug 2025 22:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2E7F8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:13:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6956D1DD9C7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:13:24 +0000 (UTC)
X-FDA: 83820915528.24.F86FE61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CEDDE140002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:13:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hgTIAS6y;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756260802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkbp71U0nIYFKHOywQ8zqs/UwnsEonKSptVh3r3UG04=;
	b=Hahpqmo9APdS2ClH+ch87h3UU9FajJRRXyavvDx9IRzzHNa8c8s9Tx7f+KG7jT/rleKwOu
	WbJMcP9kC/oHVqGTKTBe9zbzMwS6+nTaE0R19STq/n2msXYPOL5zJfVbA7uMc2sz/VZQGQ
	R3Z9KBIaAeM11AWy34yc4T0wBMk8HHk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hgTIAS6y;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756260802; a=rsa-sha256;
	cv=none;
	b=aqZ7c8QwJ7yPIDxyS5wMSLOHot2lbUaCvHELYTvetoi6W8UmYAsnYkpJU//AVxaBuy3l0q
	z7FGDLp/VSJpW9gAYgOr4JDTIOp3lfEY9IxdXIsMHpzNcDDt2kTDOxqI6NG7x6fXPyQf4Z
	zzDUOhqcEgMf+pKT29BVL7PmhWNNaFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F21B56022C;
	Wed, 27 Aug 2025 02:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70614C4CEF1;
	Wed, 27 Aug 2025 02:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756260801;
	bh=31xzUCd2w+RjdiecsXImYkR5SG0HS35zBroNDDwiWR0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hgTIAS6yP/wrdJ0SA2Mce6/+XNZ4GoM0RcWE+3Y8geFt4RR8cFij/JCSKDywrlkZt
	 HjEkPsZWhSn1ogFHu5QDI2c6dSrV2vc0Pm0jjbC/Acz5cZAXiKpekrSZrwORbESDo2
	 koHcbNaKVIyqOUCnwuzCqRatMlcik1tLtH7ZHZjg=
Date: Tue, 26 Aug 2025 19:13:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Harmonize should_compact_retry() type
Message-Id: <20250826191320.d5aa551eb5abef316de41175@linux-foundation.org>
In-Reply-To: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
References: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEDDE140002
X-Stat-Signature: ibakzf4jyjx3e9bajhhfij8zufpndkfd
X-Rspam-User: 
X-HE-Tag: 1756260802-516475
X-HE-Meta: U2FsdGVkX19B8b+1WPx5zM6BhtsUFAHQjZ6REqH8tqjeeL19U3vulntfHkiOV1j+IjRTrQjAGetLDQBYWZuN8xDoWUG2FR9vBU/FDP7ELeAdkgDRhEsIG4jkT0RuZSb//AQ9DKMZNnceYGODWfDgV73tYgcR14JHmwWwCNwIfaGVXJN+3QHzGQqgH8fuFdTgL1dVmA/kFN4vDqnDKpP0bzKnSf/7O0OMzh7dmQnDDD2aLQa4oJRZGrC1GVt/fx6Hqsx+LvCd0QBCq1qz5Ux3QbD4fONKmFrhUCzlz8UV0b0MA/RWSZmXTkKoyvnZWWupY2J3qtookIveSO6aI7j6GsGmj53gOFAhKIhrLyP2+PcFVe1jNUNcKzMlLsQxnaiVsGs6Fqd+BCUR6H+G6ccaUFHSxZT+0nhaQ1MJ2JBWDc2otAPXekHIHq5rKNResl7GACtLbi+bIWXXP0Bd1fM8YCdrc6BX3jgGCRdodvDQqQUdJJdGnYacBIposbOukeUmgERtUK0nbcAgwuefdbEYcHTJ+8FMCXcVTevOOVlGKGWS/Pdvb5mVo2P31ABbWx3IZL6FMiKWg6jnrZWwjLaXWjfORsBYZMPh03ci4NyYQpmzGMO54k3LcKxVz6DGV8aN3qnSpM/vaQ9UsM8mMkPBKnJFsdp92Hy5xSrIu52y2HnKdb8d51cq8AoifORL4bkxDZjbtnqTejjxq7togXIxuNwtkJVKbNGeaKv0S0gEZAmCDUlK64PrVI2tr6t3kmKQwXTJrSc5gV2T9X1lAFbSVg049sDybADBs7/bpXOsnneyqxdtOoVvN4cVJsI9ZeED7NJI87otXoFb5rXo2ZS7RNuI0OQW2OIqWnrpkmODAGs2uHnzq0lm2vUYeyBLsw5mMPUmx10S1HaGiHFxQrybgrxX620gZTN59ke4qyol/Mmroo89EDYPejB1VDtU4LjsacwmhOu8MDNNOgDHqUJ
 +oheMU4f
 y0zQdHATKmySt8Ou23QHxozA1L/ZNW73DWK8Sf0acb+LWr7x/2heESyy62G5+8ZOV5iLDe1mkqwWA49WkuaT/tsQKt7EOFBwbvCTL4xJmV5wg6Dn0DcpyBIVt13FyKchhCiwzWYScEEXliinogG6hmyvyxgPn65PjLwznsNjGjuWhE6TC3JVXvldzzcCjg6LUZcvd+d+IVLZzVXxSs0+5ogt4Rnq0AS0Z/VJkUGBlJo2/5KJ8RQcUiKfHvw4eBw1VZ/ehkeMN3sCOd4T6UBLNYQmNWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 14:06:54 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> Currently order is signed in one version of the function and unsigned in
> the other. Tidy that up.
> 
> In page_alloc.c, order is unsigned in the vast majority of cases. But,
> there is a cluster of exceptions in compaction-related code (probably
> stemming from the fact that compact_control.order is signed). So, prefer
> local consistency and make this one signed too.
> 

grumble, pet peeve.  Negative orders make no sense.  Can we make
cc->order unsigned in order (heh) to make everything nice?

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4182,7 +4182,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  }
>  
>  static inline bool
> -should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
> +should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
>  		     enum compact_result compact_result,
>  		     enum compact_priority *compact_priority,
>  		     int *compaction_retries)
> 


