Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76DFEC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384666B0005; Sun, 28 Jun 2026 17:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335B56B0088; Sun, 28 Jun 2026 17:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226686B008A; Sun, 28 Jun 2026 17:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E96FC6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:03:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FC95167B0A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:03:27 +0000 (UTC)
X-FDA: 84930547254.06.CDE2A01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98C12C0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:03:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782680605;
	b=VfQCDOn81geRw9B2RJ/pa09yHhpZusYWHluPKY5E8Xa5IKo3VVPjxUjps4nT0xo8DILO9f
	N8Bx6bNw9wNPAmJClPbaznO9XEnEhBn+AzdWAXKopex02cWExJ1JbcevKNgmzIyPVfB9rS
	0G3f5cL5Fy3XtufYDbXieh3BybD3bIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782680605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLL+w03ILhn18lV7GOA2Wr8bP6de3zfij54LKfo98AA=;
	b=MHqoErW9OGd/KOLH3+OLtdKNhL8pW1fZH5AeWgs3xQkvKEBkhIpKrz0iIfRcL8+6z0Wgjo
	MxU97jXW8Pg8CnCdDmSUeX+9bSCSALQzJK1wWMc9V/dOGZkJDcCtn3EOqgs/9q5eQ5lzIh
	n0dH5ijEPf4ZNI2yzJG7AlCraMNJjl0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D00740C52;
	Sun, 28 Jun 2026 21:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45231F000E9;
	Sun, 28 Jun 2026 21:03:23 +0000 (UTC)
Date: Sun, 28 Jun 2026 14:03:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal
 Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 0/3] mm: clean up folio LRU and swap declarations
Message-Id: <20260628140322.c3ce1a7428d6c6d021069e7d@linux-foundation.org>
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ft1aifyb1jmg4ma17rkgkti4mmdwwouf
X-Rspamd-Queue-Id: 98C12C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782680605-853265
X-HE-Meta: U2FsdGVkX18aeUFau20y1/zLnTrGiwEnrHdQCOjmiM6lroiGkUHS3Ps/yewVoLvUXZksA8sIY6RmPxJF4D21rnpmr0RJKmBN4C2JkjvU50JzEwm5xaH0INhkJCvIZ4qG1M2s8fdC2pM6RAtrLLF8PcZRo2KYoH67q7RnfeAG9nA7xLavFHI42ET+3F75GguM1DSotBpfgguTe4afISWZHKUa4aT41ws+If+rHshUaCTGwowxYiRLzqJuHGCTdQLwfRYxMeuIq33pEgPdqBUvsaHD6TPk7yAXZaWpjf3EykE2MFe3b5EMFlgn81zfUAZ2yPRgUXXmW6Tr9V9acLvkKfXTTNSGoOlDW84PG//LIEYIcAgZ+1f4yPf8TjlYWiyYYWYRgsG9vl9U+FLZr4LTn2UrpgQiUuvtULRjoYf5+aLi2TJjytoQKI2KjvVboplc2uYYMggc3i1BmZ9eox27jioJmoRdrICpOMtMCoY531uDl8SyPSYU7Ylmpe/Xi2BaMcCmfuSR0cZp1i2l+2Jp2hLp/Eymmdxso1EIokPgq5GtdLWmp7poJvDq78qVla4EIe4IODSv1ocRKwvHujbHkmD0WGu/MggZomqWj6bafH5UWekfSVH6rCzP4hkfJMgbhaRD2G5FuM/L57M1HstrJ+UjfZ0iYNTyKBb2NLJHNtyw1jys92FrZzM9pi7FTNLgLBupdnvVTNjqdGl82dG29zfyw9Wi4VNm1uFZmbC/w37gxlqBtlvc9J8Ab/Um4eIc6Cy/qNs85cNsSwz/bzdP9Iyu5mwccZJHNwBe74o2oLiSPEQa9xYXcq7Dwo4jMRMji9lH/pxFl8aV2DnQAjnv992xfrBRHVYcbIPYR791OpTq2MTKOKH5fpv3RpfbhW247oW3soqe2nOqSUzHjPdLTMN5/go4ctFXr/QGCJ4J3qvSeXu0Es8Bx0HEgykSTuN5XNBY/9TEJ8SFuKp2zTC
 A7FlIEEz
 8vfnXrsFR6Yiyx+GlJ5En0QYEam5qsmnlTnN8rtw7UEK0+GTUQWfVY8wjqks0hF8aRKvRmEwoEPJbmt1oLqJNhfSs1Cvpf1goWP3Y8dcAm/izYto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 03 Jun 2026 21:05:31 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:

> The previous version moved the folio LRU helpers out of mm/swap.c in
> one step. Based on review feedback from Johannes, Baoquan and Barry,
> split the cleanup into smaller steps:
> 
>   - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
>   - rename mm/swap.c to mm/folio_lru.c after the swap-specific bits move out
>   - move MM-internal reclaim declarations out of include/linux/swap.h
> 
> After this series, swap cache and swap-in readahead stay in mm/swap_state.c,
> folio LRU helpers live in mm/folio_lru.c, and MM-internal reclaim/workingset
> declarations move from include/linux/swap.h to mm/internal.h (public LRU
> helpers used outside mm/ remain in swap.h).
> 
> The first patch handles the swap-specific page-cluster state before the
> file rename, so the rename commit only carries folio LRU code. The last
> patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
> moves the internal reclaim/workingset declarations to mm/internal.h.
> 
> This series is based on Christoph Hellwig's swap_ops series, which
> moves swap I/O dispatch behind swap_ops and leaves mm/swap.c with less
> swap-specific state. That makes the folio LRU cleanup more natural to
> split out on top.

Patchset looks good and is well-reviewed (thanks, all).

But it's a little old and Sashiko was unable to apply it and I'm seeing
at least one (probably trivial) reject.

So please can you refresh, retest, gather the ack/review tags and
resend?

Thanks.

