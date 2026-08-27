Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148FDC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 22:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F42176B0088; Thu, 27 Aug 2026 18:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF31C6B008A; Thu, 27 Aug 2026 18:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08BF6B008C; Thu, 27 Aug 2026 18:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF8146B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:50:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9A0CC01DC
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:50:23 +0000 (UTC)
X-FDA: 85148544726.11.4E3015D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0DD7980007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:50:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YqeGqYYh;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787871022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hrqml8c1MbGVS6iqvEsIMrnzdqhBIjUR56tKZiSMOs=;
	b=u4j+T7ls+MWdJmDpWTFlyv3qjUy6m277kfM4HlrqMPhSRYJqCvEG8CauhrO/jpTlNLS20d
	kHZ9/5yubc3hPKlh9+bSWK9D/bmEwMlmZl6H3yOx+liikHDYyCU/J3MsSPPumABKtJI4X8
	x+mHxfmkmhw926mNOt2/9WQvyXNL//c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YqeGqYYh;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787871022;
	b=N//6J/TkfotyLaOzMxWWFzlMNZO9NNoR1yQKf2fJvC7fPOeCn0BmVgsndgQwWbwOX6O91G
	FsklDbE4rMGBUHh1jjg5vSf9DHgaxU/LxaalY0xY/kYLoFzOENI10nu8oD45w4lykHppRk
	+XnoRdw5AdBfOg1+w59XchrWO1hXMy0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CD96601F2;
	Thu, 27 Aug 2026 22:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0801F000E9;
	Thu, 27 Aug 2026 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787871020;
	bh=+hrqml8c1MbGVS6iqvEsIMrnzdqhBIjUR56tKZiSMOs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YqeGqYYhzoVgUUpvm6KZZd2OD/Z3uRoWsdGSckp6y1yuo07avs2dtVccmTgA3rAuN
	 xLTD5R+6EJC33dMiEMn4dyGGtaDB66YqnWGpg7sTHXp6ji8UYr73RO7H2hsn4DHnFL
	 5FpE2ib+D8JF9JtjbvfhRS9FJFFgyt7rYD+KzpgI=
Date: Thu, 27 Aug 2026 15:50:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 0/4] make unused huge shrinker memcg aware
Message-Id: <20260827155020.530e28b0afa3b43fede9aa9c@linux-foundation.org>
In-Reply-To: <cover.1786955972.git.zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DD7980007
X-Stat-Signature: 7nxip353uphwomayjpgyt337ngnscryk
X-Rspam-User: 
X-HE-Tag: 1787871021-433219
X-HE-Meta: U2FsdGVkX1+MS2QbmTIYVyRg8NchFNEIaIAKHMEfKji0pZ8QkeC20Xy9Uhhkdb68WDCKl3lfmTocHgyCa283dcLwWtSE2kXFPSQECNDSO7Q9u29u4PfG3dc/B0I66NqwwHHG7v7v2h8TZq0UOmyUhTAqGZgXpi34IaZNZStQ8ck2x5nDChIRpXsf1K1VyscOIi9Jrm9ekaqxLaMG6YYNUVi7+XYG+fX+0m5ItUpDENznA57Z7a95Mp+SuznunLzhid8IbJ1KskA05ubbeE+8FfvND5+7ue54uYeTtvPSBImnPUgdBlN+/XWkAyMT88do+w8G2RseqWlZrf/wfnu5wwHwAf/v16HktDeGu3JcQJWUufSPuF354wCZrdG+VaZHeAHSEoNTIqFifOoxFkX6I7KIbnyN5rdO+JzzyviCF1Xf51ekZoUn2tWNHjAgUi3D4YiNEYr59ZJuB0MKb+dObZS8ksLjbZbf1FF1TXF83Z++7Y+j53mdKQ+TKZk6M159fn4ZGv/zwWW37hISde6rJBwE9aXGr4qhFL1vj2BmLJF8coysc5jhmNFxWYv26tWXW6q5TSukRwApioHcqm3G1NWhQoh/rNB+NcCNih0u+WyKkef4HYGmwsQAIsr5U85q7VtYLHpEVlDYvgbOO5cEr462IUcI/dDq2Hi6vdL1ZFikDnn1mmLaUOG1p+EQ6lGGpjX2n4OwEKkMTyXjij+FAoWRVNOHhGgZBdwFKXpgMAKoHDrSW8arVJRswpR+q1euKx9Bf+7ickiKg7iiuMf2J9fwCakw24wKax3OmrR1LoaHfyF1r9A52eD2UfYIudZYF0GnhUUobNqd9lu/pvD9bFjYE9f6IZrAOgekdTmGxflcw2Y3+29nWFYU3qC2rGSLNtza048BtSYMnjrKbAWAnjdnr8POmEPLxGNyu1wfqIhDA/atQh4OtMzbwVyD/R1ScoUDtCQ/pXxXz9F5sen
 Y9KeJ0cz
 MMXW8MdVrjZUJo7ktmoKqK4TVOmeT3vss0MEwz/p1WBAoMWMytdR3psLnqV5J+fPXxeJ/7EMU6JmcgL5NT/YgrJEemMgC7xR6+rKisyhPLZ4QZvwKsO8aoaabsd22W2o9Kx0b90Yk4aHMQeksnjyumd/bdOOdZZqs0M2IVf+50J1ShODVvfp/x2FqfdvehNZPZkrX2UNeyUFVTJIVZt15TYT5E9rq7jffTLKn0I3xV0nZ9K7qv4hXZJ7YuNrn3ZEDcLy8X+LCylFIDbcYdD5SXxo/Odcw7YsOv3OwHfnwQsN/jHz1MkmgwN6M1ovOqj4ydD6A9fcitW/uX+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 17:03:24 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Changes in v4:
> Changes in v3:
> Changes in v2:

Thanks for the diligent versioning info.  fyi, it is conventional to
maintain this below the --- separator.  It's not really the most
important part of the [0/N]!

> 
> The shmem unused huge shrinker maintains a per-superblock list of inodes
> whose tail huge folio extends beyond i_size.  Because this list is not
> memcg aware, reclaim triggered by memcg A can scan inodes across the
> entire superblock and split huge folios charged to unrelated memcg B,
> causing unexpected impact on it.
> 
> In the worst case, memcg A has no reclaimable shmem at all, making the
> reclaim entirely useless and incurring unnecessary latency.  We observed
> this in production, where page lock contention during split caused
> multi-hundred-millisecond stalls:

Ugh.  That's the most important part!

>   tid 11340 comm scanner locked a page for 182264 us! kstack:
>           unlock_page+1
>           split_huge_page_to_list+3135
>           shmem_unused_huge_shrink+767
>           super_cache_scan+329
>           do_shrink_slab+291
>           shrink_slab+533
>           shrink_node+400
>           do_try_to_free_pages+206
>           try_to_free_mem_cgroup_pages+262
>           try_charge_memcg+591
>           mem_cgroup_charge+136
>           __handle_mm_fault+2431
>           handle_mm_fault+194
>           do_user_addr_fault+462
>           __do_page_fault+176
>           do_page_fault+48
>           page_fault+62
> 
> Usama's recent patch [1] prevents the shmem unused shrinker from being
> invoked during memcg-level reclaim altogether, but this is overly
> conservative: we can do better by reclaiming only the shmem charged to
> the reclaiming memcg.
> 
> This series converts the shrinker list to a memcg-aware list_lru, so
> that non-root memcg reclaim walks only candidates charged to the
> reclaiming memcg.  Global reclaim, root memcg reclaim and shmem quota
> reclaim retain their existing global semantics.
> 
> To avoid pinning a dying memcg through a long-lived CSS reference, each
> inode stores an obj_cgroup reference instead of a mem_cgroup reference.
> The list_lru add/delete paths resolve the current memcg from the objcg
> under RCU, staying consistent with list_lru's own memcg migration on
> offline.

Sashiko said a few things and they look disturbing-if-true:

	https://sashiko.dev/#/patchset/cover.1786955972.git.zhengqi.arch@bytedance.com

(Apologies if this has already been considered - we don't have ways of
tracking all this (yet, I hope) apart from personal memory and personal
memorys are quite fried at present)


