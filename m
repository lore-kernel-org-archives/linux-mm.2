Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD56C54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E54F6B0092; Wed, 29 Jul 2026 22:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC666B0093; Wed, 29 Jul 2026 22:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D56A6B0095; Wed, 29 Jul 2026 22:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3C16B0092
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:53:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFAEA12065C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:53:10 +0000 (UTC)
X-FDA: 85043921340.16.9D82792
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23355A000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:53:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=be7ilEyQ;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785379989;
	b=lNAtz/wxY/h7guS6aSxo0NmVgvfnBbCZjU4ayxkbU6xk3DvMjuiEQ+9Iyhh/Kr2gFEv6yz
	HbjeN5W9hVz4VSxfwbJcrC49/ioGGdOTr/sJrT5cdayX2Huba2bN8IkAYE8vFz8t9d1/uo
	OJHrFKr1ScGAWRWDsG8zQ3ps6E7nADY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=be7ilEyQ;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785379989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjx9IpZ8ImTKeEqYEWqNw8reCWkkI4bG3P98loavW/8=;
	b=TKn40Ro/VqLJjBbKfP6Pqasxoqyh55LK9d698nCAgA1sFaj7EX/IqQ7vqMZCr8X1zPCYXB
	TIzWGENyQ2PgfdZZL3SZV0+T0RuXCanTKkq9BiJoH9q9AczlEeelp9THJrdXtiDqVyqkcN
	v2vvnv9Em+sVV2N850Jc7K7nwYxaOyM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785379984; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pjx9IpZ8ImTKeEqYEWqNw8reCWkkI4bG3P98loavW/8=;
	b=be7ilEyQPB4KX8nRbrYZqWNzoVnA8jiqWQyWLPd7cjmx9Oa97ci67XP4ZqYe/Of9z43dbeuZZEkO8Q1A2SB9q8CziJ7QwxQ55RssGNYwylRULOHEAlrCMpCAHSza2OEW+/LoO3qEoIxN0y9x2fsQbBFx+/FGCKDOkRxhFLXr3ss=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0X83cfc2_1785379979;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X83cfc2_1785379979 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Jul 2026 10:53:01 +0800
Message-ID: <f0bde6a0-d4be-48b3-abe2-28127a82a139@linux.alibaba.com>
Date: Thu, 30 Jul 2026 10:52:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/4] mm/shmem: split large folios only on -E2BIG
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
 <20260730021630.2235914-5-xueyuan.chen21@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260730021630.2235914-5-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nakipmiaipiatxd35oh85rzsrgto4riq
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 23355A000F
X-Rspam-User: 
X-HE-Tag: 1785379986-9095
X-HE-Meta: U2FsdGVkX18xqYwZHD5juVmDl6h321VnX42lugZ/M643cHV+Wd5Bglts83M/SIPRIPzYsFx2zSibqjqOlcHvyXavA+LMYYsuIaDBQkUNMXVpqMegziPkStZnGgMlIF+uSpzBPrUAIytW2Y56RWO/9jQfXNGGhw3s7BiAVEcpcHKLL/f9Hi5Mi417/ISmh/Mc/3atxSRl5148tN4v/Xf5027DTPxN1xzDSwKyb0M5cqW8fCLh+rVfZVeF4Uwpjtt6iDBvYxpJPKAHqye1VT0qldXSOd8FyF++k0oZFSz3Jp9v3VCHBgoFKpZ9usUWkEUcMkvRkk3Cx/u7iBEuFH+9QzJuNUJLjXiZ3haSpDtRTYMb0kPuFHnytxD0tdTuUUznVceeO9SFTY9ABHOTvmLbPLpM9ML7z69rFzt7J0ks5olzxlBEdKnQ1Lycrpexnd5Lm/k3djmhpwKyYHzUoEhfy6ajFHkklV9F7MaC/fDi1KZ/KeICxN/OjOVPdmpICSF8/GUBbxfpQ9kyIlc2zpJ7m4/SJQW2JcH2gBoLFrkxqI6tEzoGO07GNJMn3CEt4VzExV43KuSe0QJcnXTVWCvm8OH/pr9EJUJ6znbzvOrBIAS7rXho+66a2P2MIXP5taDU9COUNMO7dbANqpXey3D07HKGXAV+PDJxVAFI2+wa2DAsfc5SPTOR1rDtLvrD34p7EEm2QGFLIgQ261W5wXIF9bnico6mSHW/nI9Ob7gCF6so577HS3mNOzzwEY2gA83QY+fQhDwlV4jufMKatx4zkXndXrHpx3rsX+vOAk6Bdsgp7haJOnRZPzKixSIcWKuntNcQgyPJmGU32/rd9d3MJV18O70qZq0Buqc/HpgNPNvFbVv9x46wfScz+jOjGL6pGmje2DMHlO2n8kYf8r9eSqOIRvjYEmmd73gynfrKcdkgaZXeOdFFWZVWHMBCmfV4X5tnLzQTDg+UPzJc2/2
 qp3HmZPA
 JRyS5wgwSAWADwXHNEvPsSFRJNScU48Iy5J5AqtXNJT48mui+4vy99yQESk0FLONjRrk1Rt2HX8t8MFYNMh+9Qdbmyj/XGzVMaJhfV3oPb/qrdZCFbnXQWkqu7VYB5WUCW7/I35RJpBA00qzkvM7eejsxlQRUmZWg0rfok4Di2QDSjJr0/cco55axKxYRXlmH99Y8Izvt3BfrqxqtD/tUhbvP1cLEzfeJSD1cY5e36lu49RSTWYvbKfPuOcpR+DodOJzjp+E93XK0bxu73dgr6W2Uu+Qs8IdVoQwuN4YgGVeXuycAHIvmrQvY/blJ34HTyzDsnrJmhvTN8Cq03RyWP7gKKLz4N3EsBgGEI0L81xXphZY5CduKA8qY5YUEqmJVOKWs40xUY8Nkio8yKsHYaZCoMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/30/26 10:16 AM, Xueyuan Chen wrote:
> shmem_writeout() currently splits a large folio on every
> folio_alloc_swap() failure. With the refined return-value contract, only
> -E2BIG indicates that splitting might allow smaller folios to be swapped
> out.
> 
> Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
> redirty and reactivate the folio as before.
> 
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6641823bed16..6f959191ef70 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1609,6 +1609,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>   	pgoff_t index;
>   	int nr_pages;
> +	int ret;

Nit: can be in one line:

int nr_pages, ret;

>   	bool split = false;
>   
>   	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
> @@ -1689,7 +1690,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>   		folio_mark_uptodate(folio);
>   	}
>   
> -	if (!folio_alloc_swap(folio)) {
> +	ret = folio_alloc_swap(folio);
> +	if (!ret) {
>   		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
>   		int error;
>   
> @@ -1742,7 +1744,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>   		swap_cache_del_folio(folio);
>   		goto redirty;
>   	}
> -	if (nr_pages > 1)
> +	if (nr_pages > 1 && ret == -E2BIG)
>   		goto try_split;
>   redirty:
>   	folio_mark_dirty(folio);


