Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FBC9606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JnoLrQun
Received: by kanga.kvack.org (Postfix)
	id 75FDE6B09AC; Wed, 25 Nov 2026 05:44:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736F86B09AD; Wed, 25 Nov 2026 05:44:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CE56B09AE; Wed, 25 Nov 2026 05:44:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E35A6B09AC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:44:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44A17A0E49
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:44:15 +0000 (UTC)
X-FDA: 85473306870.12.D2B64C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 772F2140009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:44:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnoLrQun;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795603453;
	b=XnWuX78Lph9UCJ0HBCeRlTh+qYa+O7LvxjaBZgx2k3zvf+vE4fYoRCIYPAmPLw6iAVp2QJ
	2zJQSco5BpN9QPP7A0H1HoBm5jeP4didKTKnzEFTC1VKUEEgw1V47HsnEXRBhkeOfLqF9r
	LL8oi+25SnvkXElPC2OuEq8KVq6DzyY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795603453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlKXvFWX4gEJBHibIvdqd1FwvtITIqKSf4ngjmttRnE=;
	b=U9xRUflx21uKtaoUEutIbyii6jf9Ylrt5rM3JvO0FREdoCM1Wj/QerspwHdIJF3Jg8Zhjo
	3FjA21NOsvN1wXF42BAfoP2Os1HA5WMY36CtVZz3b8lpEDOKeOVlW3Ma1ps2IlmPYKgfOv
	lw5x/zG0BHi2NLwmmtEm/B8tGtSCkGs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnoLrQun;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E4ED40B3D;
	Wed, 25 Nov 2026 10:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46061F000C6;
	Wed, 25 Nov 2026 10:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795603452;
	bh=GlKXvFWX4gEJBHibIvdqd1FwvtITIqKSf4ngjmttRnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JnoLrQun8sxhUp4swp0IvwihTOOxGD/EM/rE7gBzt53x11QuFNBQVSfs9nYk8qMou
	 hs3JDqoomNLTrASrtit0BBoM/FFUHa6h3jMP4g7gDW6V9WQj3L9lPb0BPjQvYfKwtF
	 TpAW5lD6ZGALJUyd61dniIdtqqGa5lNhGQV//esHpnsLE5JeM60DXcRM+Iwmn9h4vq
	 G+3ivSs4s6my3YxZouboSEISornuxoSpfzhQMdPgg+FNEGyR8u1r817VgJDOAZdOrF
	 ZZ/jhzIxUXV3fY0rwHdpGa1QHbTRma0W24eCsLkNK+c9SceJI+GWJlIpN2m0CVTnzU
	 5LaEPzxHYtCwQ==
Message-ID: <83701963-9c6c-4784-a53c-c9f0fb7738ea@kernel.org>
Date: Wed, 25 Nov 2026 11:44:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6.y v2 0/2] mm/page_alloc: fix iomap buffered write
 regression from 5d8edfb900d5
Content-Language: en-US
To: Salvatore Dipietro <dipiets@amazon.it>, stable@vger.kernel.org
Cc: dipietro.salvatore@gmail.com, Sasha Levin <sashal@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20261113110724.2920455-1-dipiets@amazon.it>
 <20261116112229.3815501-1-dipiets@amazon.it>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261116112229.3815501-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 5aff4sk33u7yp63boq7yxp5j87aai96i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 772F2140009
X-Rspam-User:
X-HE-Tag: 1795603453-240506
X-HE-Meta: U2FsdGVkX198N33av6rR/Ce+k8Ht3xBhy2+QNanWBvKGz7lUQAPw11UeoNnvsfCTptpBDH31buFALeLYIz3hNypdBAxz/nI1ngwmKe1dTwDR6lul1M5uyGQ9fESEbIHnDkT1fbFTg6v3JmkjJI5Yi/mJZGrF1lkxIcabwgEjzNirXyq1GEUzlIe4s+bUBJ7Gz0gOIjOgPAhtACxIatW/FVf1FiF5/Fsk+ShOTBNBzlhepy4di+cfRuEFeI8FYxAz3JbTJiLxurngaXKYuokxQL8LVvRSKay3V79plISCiHAN3JyTZ/vSgREOc42tipq0BGwYcFelX/nYmjEpYEOxFuO9ZRwZj9FUn5kKKLGnfa3ozjTVkDzeZavxBUMoUc3gI6dyHMy0O38a9KQuDF7rUK8Ig9TQUDAeZGLUtQCZPoxHso6Mr6XY4KkgYROM3S9I0QAyoPnHrM6zKOMI82hBz8y86veQdOOtdY0OBfA4xWb+kKo92RDV1f9KgSmtpPXo9ofZuMZQQOzjfUP4UZkl3a4msY9bFqM2CC6yb41oihouFNTv0vAMapUNv7zj3poFJMixaDvEKAd1O5UBes2AKwrhtkHm9OGg68+4uNoNJhCWc9pw5L7flagffxdmF7O/oq9Jz0BaDckeIqtMx9Ha+LJfi7SQnxZRYycjR+KYyUc1hox2zW++yErF9G2k7fdJ8lipNIz9G8sxGUWgYa9eWttO5YcmhmL0gskzPTSZAnDRSqBx3l08yu/uyhwxT4NpJLT+zz5I/TRqmcB0P/FYARad0GxQy9FcpK3jDeOn2sBDrB1LBYVdlK/xTN8gt+6VDoDXKwlpc8IwN1P5EBryw2KkwEqxJrwhAOQltFyxB6okIyMif6MQEECfE+h3QcNd8+wABmJOYueNPRl+s+rbMwf4tHlFR+xr3EgZcIiv3t0JAk1RU3u4a+o9YgpXJW6vaNjkEHpXtXDcmuvNleN
 nernXBbh
 p9LZUopQ7jkoIAM6MNqZF5aakxeojQt+li2xsyl/5K+hN9GLaaDPaQpnYLaaAUB1PsIeZ7ja5bL3eUGjtItn19QgMvCI+hd7T1P3uw3cUkt3ILl5oZJeq+Gpgqw8A3PiA9Pq1URNvOk9lvBxL+36hs/hGQ0Kkc2NfJjS8q6WK+lO0e6Sa/6rLKangjENtBDoch4Wt+Vp+ds643laOLS3H2r4q6anonDlItabvplpwTm6jBHC5dMDFaMqzQAu/1gtPhdpex4VBMmssxibwXFMzZSd+mcou8+qMWY+d57oDCCXtS6I1wDCBj3q6x1M1D/7u7fUq77uyBTT7rfCKXWH63KmsUolR8R70gBftZahAtLf1OPCblUS6j2Kzc0rYqoILwXhlCQFxnKPMrOaq+8/2MDyJEPaM7nW3BppxVpusTlh4zlHI7kZwUDi/ACGd1QF5b30f5wtbU5KGle7FCfKs1+rdt+Ypk+ll1S4SgrKAATCxjAxeKbwFJ/P61jGhniyGNei3JYhhgeZRKiOAsPJo4zMO7g5j6XdR1ICaZorR+TEjAhEVW+/2mohwqT72Ovk6O93Z9CGquvbDNb9/YwOcmxd0XKlxaR1rhJmHhxiHYjxZEGS2MMJU3jtpi3f4Ce9ZakUL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 12:22, Salvatore Dipietro wrote:
> Backport of 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and
> compaction for costly __GFP_NORETRY allocations") to 6.6.y. It fixes a
> regression from 5d8edfb900d5 ("iomap: Copy larger chunks from userspace",
> v6.6), which slows buffered writes under memory fragmentation.
> Andrew and Vlastimil agreed it should go to stable [1].
> 
> The series applies on top of Sasha's backport of 6ee3d87b9408 ("mm:
> page_alloc: do not give all non-blocking requests reserve access") [2].
> Patch 1 is the other prerequisite, fe21f930d1e6, only moved from
> mm/page_alloc.h to mm/internal.h. Patch 2 is adjusted for this tree, see
> its changelog. Acks from Vlastimil and Johannes on these adjustments
> would be appreciated.
> 
> Patch 2 keeps the mainline behaviour, including the THP defrag=always
> case raised in the Sashiko review of v1 [3].
> 
> Built, booted and tested with pgbench simple-update (PostgreSQL 18.6,
> 1024 clients, 96 threads, 1200s) on m8g.24xlarge (96 vCPU arm64),
> 12x io2 RAID0 XFS, mean of 3 runs:
> 
>   v6.6.162               93,808 TPS
>   v6.6.162 + series     159,670 TPS  (+70.2%)
> 
> Changes in v2:
> - Dropped 6ee3d87b9408, now queued from Sasha's backport [2].
> - Added my Signed-off-by to both patches.
> 
> v1: https://lore.kernel.org/all/20261113110724.2920455-1-dipiets@amazon.it/
> 
> [1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/
> [2] https://lore.kernel.org/all/20261113005511.435938-1-sashal@kernel.org/
> [3] https://lore.kernel.org/all/sashiko-outbox-214392@kernel.org/
> 
> Johannes Weiner (1):
>   mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
> 
> Salvatore Dipietro (1):
>   mm/page_alloc: avoid direct reclaim and compaction for costly
>     __GFP_NORETRY allocations
> 
>  mm/internal.h   | 11 +++++------
>  mm/page_alloc.c | 12 +++++++++++-
>  2 files changed, 16 insertions(+), 7 deletions(-)

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>




