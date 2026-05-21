Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E54CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72C16B0096; Thu, 21 May 2026 19:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5356B0098; Thu, 21 May 2026 19:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D0E6B0099; Thu, 21 May 2026 19:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71EF96B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:59:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0661CC2AE6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:59:14 +0000 (UTC)
X-FDA: 84793095828.25.706E7B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6924420008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:59:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iwyuwGa7;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779407952; a=rsa-sha256;
	cv=none;
	b=jKTi6qpEAusagO9WkIsjL9CiPsc45SjQjRnHZ18LPLZ/rrrMG3trgkwGgkcnB87gLO7DEA
	UdKfZ6hgLkzvJpluLjaXzIANCBzSV2+YLWbMrD+qqgctvdvpS6eyXesKV3VyCszVIjCJ/5
	57zbZLA3YWyLC2CLzYZ+cFt9Lmnw4Ts=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iwyuwGa7;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779407952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrQlxqbsZV4W/Kem03RWjAZ9GqIVBQf6LbmpMN2XAU8=;
	b=FCrIq/b9hh+bIlYcRnZXsa3QkYodfkqLYxIpVaea+/26VNdDCZz1+6YPB70yrKR0zFGAHG
	zzhRshOMtBXhx/NQCItbUdYNqMeZ5N+PYvby8t+pGgGr+bSo50hlYo4OJpK9LRIpcF3Maf
	NVDqimRlCNzr6SJT+8n31TkkszZQv+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B709360122;
	Thu, 21 May 2026 23:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ADF1F000E9;
	Thu, 21 May 2026 23:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779407951;
	bh=jrQlxqbsZV4W/Kem03RWjAZ9GqIVBQf6LbmpMN2XAU8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iwyuwGa76WUk5RKM/5qI/fV6PEguuuL3WXWzU5BxiitxspAQPvtS4DerZoRUUrswy
	 F13uuWjiF9yLjvgEasymfleV0c/XWzTPzd1Nz8HAgMOyMJKpjZh2op7x8pppu+a2jM
	 BpTLUDw8D3Jxg1azxynJDazOVVKLlnw797hadHUI=
Date: Thu, 21 May 2026 16:59:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-Id: <20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
In-Reply-To: <20260520122228.201550-1-d@ilvokhin.com>
References: <20260520122228.201550-1-d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6924420008
X-Rspamd-Server: rspam03
X-Stat-Signature: uyp413cjunjrwrr548xkjz7kmk88ngn3
X-HE-Tag: 1779407952-424203
X-HE-Meta: U2FsdGVkX192WD5r54Rh3Wo94RF+dU5vfjV9KpNS48aINb6LRHjta83n0NXFSifDNnQW55kQTpK6DXTqPb+4xPPa6wmSzY2Yw220kKFcrE/a81w988Ol4zSnG/gbHpBPFzPrL3Qqsrx2J+/qgHJyDplCSibaBqYH1kIU+aXV3MXtLX4herCDchB9GnTP1lnOicX76yoowMt9Ax9X1G7HYp5wdjxtqXT4jfAkmSwW3idjmJTvVrcLwuk4dscmPPNi4wIhdd3MuuO7oR/EiZ9w0mOOLzvfg9YVENikMY6CgLo4nMdmRmNlUXVXnz3JzFRpVXAyM4xUVgr94qVwAYU77Un0pTsJzI30yyXiTraq4xXtRos1iNWS/ZOHVSwe64YheXyV0vWPvkQk1s5Tjxb6IhLNsY7J9cIKhHuiFZ35SJRMOdWCBuaeidAeN0GZvglnyJ921ZVJ5KfrYj2SDXtVQUz0LVKQ6ugp/MMB6ujTXQicltvIyaXXnykcGuKwq5DzHEWHKcNZ7VhAfXJJDkvMnR3lvbmykEur6+oH8RgyNWmnl1luGOdVxfQFUX81g6sWkg5j0q67hDugp5lJfRWD1lxaNWnqOWOj48+SjG6jMXkxCPfukkEpjcgypKX1ohUWyU5XIXwpN/2OxEQO6G5gCX0YzkJgim3UuF7At5TqVBXFYnKp9LW/vfcJGX+hgFR+6z7abdpgNd6PAqyoOId4Yo287WF5qxOu1W5dYT80RvRl7kpxHujab+y1EnmtzZbTiF8gjubbpdk0VKYaIS1IMw1exFrYuLFQcy4W7/dxaTK5FTI4C9kDztZZz0TKkJtTD+fOZK7IWpZrmP4Y9wuXrIXdbJvG5Mr8aIE3e0aVxeceHFq8xuL3BZsD08hKWi8CYy8RygZ1mLiBAS7aDlT3CX6lpIdTK3DQ8RpuwtYgUs3a+8cw5jOzSigz3mBjCAMAsWoOLMiclf6dDca4l2u
 sOUK5RUv
 EtRBt+/PohZKHKzOrXpBoCSNnvsKiEXkZkZ7MaKkdDtr8JpH7B3gSmGVxaA5cGn2iDDiKoT89igUj8UVMetfWuzhugiIV6kT9TZKJleeRekMCWhAqSTrsXHoMv7UDFA0QaAWpkoWRhAMIINPRWG7MyMj66miVKNJi++72bxn3xu7wsukpYpO7sDtmyf+YrWSrk967ocAePwt2GJviO+7wYPzYTCDPrG6yWYsRXLfTUgWsX/XhdOfF45Ww2lNEZnDJmMDezzSHNhhL01qFaROM5g7Xn3wU/cF8Yus0teqjgGgfMln7csEao4quaXaIq1eMM4LSZe7T7/vn8xQzzEYRe9H+HfmzCoLyRPUqwT7EuP9G7ZTn0i7KGsQlNBbMeiJRpnz04+jVMplLmFOOefV4e4cQ0txOcW5YSFw1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 12:22:28 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> migratetype fallbacks and keep pageblocks clean. The allocator relies on
> reclaim and compaction to free pages of the correct type before allowing
> fallback as a last resort.
> 
> However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> direct reclaim or compaction. With defrag_mode=1, these allocations hit
> the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> 
> This causes a large number of SLUB allocation failures for
> skbuff_head_cache under network-heavy workloads, despite free memory
> being available in other migratetype freelists.

That sounds painful.

> Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
> reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
> speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
> __GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
> fallbacks and should not cause fragmentation.

How serious is this to our users when running real-world workloads?

> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>


