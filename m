Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCD5FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F476B0088; Tue, 28 Apr 2026 05:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0296B008A; Tue, 28 Apr 2026 05:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6616B008C; Tue, 28 Apr 2026 05:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAB096B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:51:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DC871C0679
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:51:41 +0000 (UTC)
X-FDA: 84707497602.04.0B27E88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE212100002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:51:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WxTSaql7;
	spf=pass (imf14.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoWtmWhRrocedIkITp32kFJtjAFfvGFSjjAMP4SzY14=;
	b=Xa/in7g3wyuURoZ9q6tFMrLTLSJhhPg6O7IiHVcMsM+HvWMgQwJ7Zg7FTogrlT7SU1C60R
	akdau89d7nPlCi1jy4zFx/R6mwqSXHVm8B7QxUYm0neh6occxu/+Om0zCmXCsmrul0Fu7m
	d8wdaKJ1Ah8WhFUdoSmne8sEiI/tLmg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WxTSaql7;
	spf=pass (imf14.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777369899; a=rsa-sha256;
	cv=none;
	b=3sQDgXgD7Q+Bkbfq25MeSVszdHvXwDM/zKQPglaFHVDmLLsKpcq682QKue8+F0vfklmP9X
	Aa+CfhRsoZ9hB7lzkR6pwUeiwhx/qXI27YzQzhdGWsaIZwCgGiu39lq4RMbmUPC6RbURrR
	gZGiisUzzcWex8HB8Ic8NAw4t7uCDwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2871560142;
	Tue, 28 Apr 2026 09:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4615BC2BCAF;
	Tue, 28 Apr 2026 09:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777369898;
	bh=Qtgzl9uQeZRdCw0Q5qVLT5RiRrK4qvEsHQ3PXE3CYOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WxTSaql7s5o2xq8bLFvL8+8zawGPs9gT0E2KRQkyWx19f907nl6uczr6BRySYHlC4
	 LD8vwCChAxOavFoUEClVXC5Y8Fu2ZQq1tcJJtkFaP82QRvncGA+BOJuuWrjzsJJPEl
	 XS2uy7hwFFNOV+QziuppXmErCmssY064EObfxEpR6tC2/7eI1IrvlVdCExaIyEJPnI
	 xTgBOymGHVZGYKMRlZU1Y7nczVKOQTfzsVJneVbjI2aVekEOc5KMeQqJ9qysE+yLaD
	 1023mUcvfm/cIOwJWutGhvtXrWcG+0YDdgdHr8HjetD+cbU6wqWQc68H8no/sKe0IC
	 /ucV8opqnE12Q==
Date: Tue, 28 Apr 2026 11:51:34 +0200
From: Andi Shyti <andi.shyti@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Message-ID: <afCCCuLglfi70Tgq@zenone.zhora.eu>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260423055656.1696379-2-matthew.brost@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE212100002
X-Stat-Signature: t3at5t4boc8uh99r58mtj88oikm8ny87
X-HE-Tag: 1777369899-387138
X-HE-Meta: U2FsdGVkX1+X/YKj9f8xCNN5X9nqK8Zy9aR0Y1jO4bcSV3DZW5eyO9rt+HwyhHY2WgIgMvdNOgv60+Ir0fM0prISyMTKp0uXQaQppGlgCG3EWYWVY11uZardRRfoSkYAtTTzT+fA9RTidLdpcXWb3yG2c4U24GzcjtvQHLYFphZonEQDhjdhW4RaYzMmML2Ca/DzmJYb3GXitb/P1RzNxGotItC0mhq39BoZEJlY2kvQyA+zLaRe5tMjUutIU/mOyuPGG7+W5YgYgFL7JXMmyjExaHl6cA9KCHhR9TCd2eU7nO8ZyuaVWzOLfv06e6izLlkHVzgVkPgBA8BYpSGFKBdbbRF/aSpKBfzRHp7UcKRvjMRf86ICjoA9G+zL8xX+ld+rA0gf30gROezwNzHcbh9bw1QgLmYYEBFwAC0Tmk6v9MwZL6Bn0prC2Uk17Wr/maqAkfqs9P9FhOxoJHjLJntpb+HrL/w8E24tp6SFQ0F9VRWEBKXOfk9uqwVmu9ZQkeA9ang97YECaCtuhc0DbXExrUX81AUOsjKf3k+pQ74JAf6USHuCDAAoDVuuJrKeIbMjYMByF1pxrquizyJjoyMtcGWAb31uIBpXV4KiTBIeN2HmlZ11FhjIGMN+iM/4bt7NlEIs06fuFzEcL97WmNU77BQ5Y8t2E6WWMxUinzkpUXObjbkbDe9a6rYuVxXgakpJJ3Q/jH0a0CLTTL0dtFTyj84LIxJQhlMS7gM+pfzQrhfBillnISHni0FOS6j7lLct3qoV82RbNxTK4ixBsIw695LKw95EKAZY6/rLivSjnJUKFyeBKuiDSJGPdOPW+ZDXOIgAasSAZq3IFX1dk68oODh1RssjjYECijvKHWokxkP2vB7M2TJs/tZkMOrCGDbYyJTPqOS4CZMURis21bXbvunioNMcD070U7t1G06zKtc7zj4SuyZJmU2aPhC1Dem6MdITzq5hwtS80Dv
 Sf2fy3dA
 5Z4bjiRGlUGK3H/k7vImTzc6UNd/lvbw1vaPoNSBnKOIuFy7Qd9tUH60FDQUyio+LtcU12yyHQXxImbHTfY0Xv9Do42FCr5Z9351joLv8KUMvC0QZNlz2qXbDa/iewzeEq6GK0afdytAt0o5QUiafmDrRoU7dThwVfFMI8VnaVh1LZ1EUBzkCSOuoCxxbl3QAI9qHQ+DX3WAe7XTWd5LYEVLzstzKv3f6SlZZi3mcfeDHKZb6ofEXkg0PwMGS7+rsGTJ/0pQ/ANhTkU8vXVZueOSqHao/dZmGgFhVukkwTGcDv0mBkUSI9ffOWdmrfG3Hi8Gp6DkKz0gf1gCGikHQsX4iLePV+mQ4izEvjukVFcqQyujx/vzDZA2XqcsKnZHqbOzGpwqCtKn/nzVuNTWZBqUiVVPP8zc9k4kyseOmPLhsDrVmxPYsnquMC/XXP/lpFESFI7fedTdv4ciNZxiBFSmVQ3TZb6D3huFU7smPmAdMszD3pabqq8B2tCpn5hy/CPxw7Ug/cljEYi16Pxp6RzckFEmXx8qXQGGh8JHKsumgqHbHH5U18Fj8Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matt,

On Wed, Apr 22, 2026 at 10:56:52PM -0700, Matthew Brost wrote:
> Introduce zone_appears_fragmented() as a lightweight helper to allow
> subsystems to make coarse decisions about reclaim behavior in the
> presence of likely fragmentation.
> 
> The helper implements a simple heuristic: if the number of free pages
> in a zone exceeds twice the high watermark, the zone is considered to
> have ample free memory and allocation failures are more likely due to
> fragmentation than overall memory pressure.
> 
> This is intentionally imprecise and is not meant to replace the core
> MM compaction or fragmentation accounting logic. Instead, it provides
> a cheap signal for callers (e.g., shrinkers) that wish to avoid
> overly aggressive reclaim when sufficient free memory exists but
> high-order allocations may still fail.
> 
> No functional changes; this is a preparatory helper for future users.
> 
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> ---
>  include/linux/vmstat.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 3c9c266cf782..568d9f4f1a1f 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum zone_stat_item item)
>  	return vmstat_text[item];
>  }
>  
> +static inline bool zone_appears_fragmented(struct zone *zone)

this is a bit of a strong statement and the function name might
be misleading. You received some suggestions from David and I
would rename this function to something like
"zone_maybe_fragmented()".

> +{
> +	/*
> +	 * Simple heuristic: if the number of free pages is more than twice the
> +	 * high watermark, this strongly suggests that the zone is heavily
> +	 * fragmented when called from a shrinker.
> +	 */

The commit log explains it a bit better. The heuristic statement
here is too strong and it still sounds stronger than it should.

Andi

> +	if (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2)
> +		return true;
> +
> +	return false;
> +}
> +
>  #ifdef CONFIG_NUMA
>  static inline const char *numa_stat_name(enum numa_stat_item item)
>  {
> -- 
> 2.34.1
> 

