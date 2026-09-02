Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D08CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB306B0095; Wed,  2 Sep 2026 01:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A4C6B0096; Wed,  2 Sep 2026 01:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B74C6B0098; Wed,  2 Sep 2026 01:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB066B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:30:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86655160720
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:30:12 +0000 (UTC)
X-FDA: 85167696264.23.75ABA59
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B5CD40005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:30:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=b9vfS4zj;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788327009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8SuqTKhovBiNOhy36sFqG8T3PHPsV4g3A2I1lrc+ec=;
	b=d19UVeAL1A70vdW7+0r42tVO4/7wZ9y3JGfubH+txPvZlfSAgvVrodLtYqh4SdCZC9oVEy
	rbum9filYFVXSRTcmH/kaLkA5VIAYiuZQK/leyBRqDT8FWymFrZxWHdejnakPycM/lfCww
	dw1Hug7FwcddHrsC4uA84IS5Bu0utAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788327009;
	b=ZppSIdzbyNvh8ysUhB1517lVUQphMsFXw6oqxb95CAsA0ahrpC8GWzmdFe8QSoTamqUlx0
	92rcDUDXedZx/Y8c1M9Wo621UZGm7JhXD4A0rq9zueL8An4Gvh+d7whepz4FJ1/+aPuPAa
	4tjdym5kP6E9LcwPyBSazQlElmPA1AA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=b9vfS4zj;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788327004; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=M8SuqTKhovBiNOhy36sFqG8T3PHPsV4g3A2I1lrc+ec=;
	b=b9vfS4zjeQrtSaUZYCsVdFq3ODxggb4bbr0Aov0PbrJp+Tleqp6AEngKnz2BrnEJBCen64vKUgDfQh8S/ZuoPLPQeUjFWifPucn9leBKG5FUiswC63hl+5fVSqydUQYYkvzyB7fTb34YuKoz361dfR5tdd4zfoZiAj9sA/8X+4w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XABT2kE_1788327002;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XABT2kE_1788327002 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 13:30:03 +0800
Message-ID: <aba2f612-001c-4e74-8c6f-7fa4ac2e2a98@linux.alibaba.com>
Date: Wed, 2 Sep 2026 13:30:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
To: Qinyun Tan <qinyuntan@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dave Chinner <david@fromorbit.com>,
 David Hildenbrand <david@kernel.org>, Xunlei Pang
 <xlpang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B5CD40005
X-Stat-Signature: tikop4q49oq5b395idajudw69om4hfjb
X-HE-Tag: 1788327007-551880
X-HE-Meta: U2FsdGVkX1/JWuJBhljKYv05Mo5fcWTOj6TawadkQ2RxUKjJrU8xbyshzDOT8RI2IbDa+E2Yz/pNt73fI6UcanEBnLTwX9jgfCXEjaTkxmgmD7z2jkQ2sq3vRL4oxp+URs7UfOcnCVdP09kefp5miSbUH+E6cKyrrxj/3YR5xaPlrpv3z1VQYsBcxgFgmbXPGK9hgR0IHLXgw6ATrO5yKhKX8a6ycNrpwPkOPeYDJ2M+Hpdew7S+Vv/M+o+acq2Vp3Mxg3q2qyZnsEQa3VVThS+s9o4bkhUiBhKNEi7Ud5JKzsJEiRtQTUBW5abMssTxBm92LHSIqmJvAQr1q24eQ1Ljn1EEVPkYQgYTi2vKRrrmqlj7mRkWwURt3T9Jyfy+7KiWTAVH65qfCPCnKtJypLr+lcYNodM+JIvsrX7ftFCaL5194yGx37969pKrhMouNy55uhuxZ2BjlSPOk3WK1Cf29qvWHmPgPRkR4Bb+rjzIkG1OA8q6vY3Xpc1ZV0PMAn7fS6xGC02BTSshgf5zdtN+jmDvf+4bUg9dVu0Yhb/68V4J4fErvCccjLRGhxVPSV7WnsJhVq1vMj7q3jzZOH+h3q2KjeHCcih6vnxhJ1LBk2Cqawnmz536h5b+hrGlIlRKPbdjg15IKVWm2VMoRh9h88D7Pp76Kqdw3xoIOviJm1mJFB8rgUJH6g+SWzr8aBuTjW8VTcfbOD+1QjwPZWnuvoYATQxSSrAdEVrIxRS90Q9oCjB0E1+3L2DI31j6Pr5STNgj9H9f6sC216A8zWIy+o/IdcsqDRkrieX0Lwa+XR9TICHyZokkahLL/+mLkL+Qkz3nQR3Iw+3Xr9bMqOjPU5ZSkBAEnZsFcBAxG8x7nXONoSIuYGU/0C42wK/qoI5kfB6teNtj56+qiwAXr6xNW4OaXlGd9Zk7KZRwpiuWGe6oGhFFVYOJigF/+KC2sVHvNGHGLWSRbDnYAxq
 3zWcUb+E
 yt+LmN0xx+8ZYub1QrKr9oCkiHVuqejH56Gc4Kc5Q/bd6kRYr0eWok/vZiqZxbQm5sUhtb+8W/27hPsgNOnelvJwn3tXa1FrJf7iuet3AVzWQ0WhRVaTXvE+IGlnlAakkmk3cAbSem9Sn2w99vgzvAcvtZafqH/n9RZIcW8IZYl2skrmacfxdPgTOBvVHNYTh3yQSBRtR0Me1wJBIO6oCVG5Zj4ioTOf0Wh8+r/u75dGfIM/j60SX2EsNU+zqLBSczL1kMiyQdcsZfm1WxeU8ekzZwUeYBh+OBrT0aMh25P9WTrKkvPqKtlrauOQQVKyMZlA3iE6KcJFgCd7w5UZNnq1jMK8N2tERaAnd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/1/26 7:51 PM, Qinyun Tan wrote:
> With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS
> for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
> back to a non-memcg-aware shrinker.  On this fallback path,
> shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
> valid id belonging to whichever memcg-aware shrinker registers first.
> 
> __list_lru_init() copies shrinker->id unconditionally, so every
> list_lru backed by such a fallback shrinker (thp-deferred_split,
> zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
> up with lru->shrinker_id == 0 instead of -1.
> 
> Under nokmem the list_lru collapses to the shared per-node lists, but
> __list_lru_add() still calls set_shrinker_bit() against the memcg of
> the added object.  Most list_lru users are unaffected because their
> objects resolve to a NULL memcg without kmem accounting, but the THP
> deferred split queue holds user folios, which are charged regardless
> of nokmem.  Since no memcg-aware shrinker can register under nokmem,
> shrinker_nr_max stays 0 and every memcg's shrinker_info has
> map_nr_max == 0, so the first folio added by khugepaged triggers on
> every boot:
> 
>    WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0
> 
> On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
> and expand the maps, there is no warning; instead bit 0 is set
> spuriously for an unrelated shrinker.
> 
> shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set,
> and all readers inside mm/shrinker.c already check the flag before
> using the id.  Make __list_lru_init() do the same and fall back to -1,
> so set_shrinker_bit() is never reached with a bogus id.  The stale
> shrinker->id itself is left as is; cleaning that up is a separate
> topic.
> 
> Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

