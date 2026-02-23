Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D905EC110C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3376B0089; Mon, 23 Feb 2026 11:52:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC49F6B008A; Mon, 23 Feb 2026 11:52:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7B86B008C; Mon, 23 Feb 2026 11:52:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6C8A6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:52:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 123DF1601D2
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:52:28 +0000 (UTC)
X-FDA: 84476314776.27.64C8B8F
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id DAA801C0002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:52:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ah5rVmZb;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771865546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9p76BczVPf+ipMBZjWxZMf67W68G0E63s5eoAZ2wq80=;
	b=orI6+7arXKoGIbQGQZd3Xcpw8IM2bQ1OmdoXQgbIgIvoVbIJ06oo02JXiaz0i/R7nTgj24
	S644Hmao8Htrcc+Cv2qzBVA824UDjd+qSmCjazVODYeNrvoBfE+51Ir8evRSvbt3HU8Qt6
	sKDijG5/AVylCB3m9TOMHUaSszT4Inc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ah5rVmZb;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771865546; a=rsa-sha256;
	cv=none;
	b=QALEgEEzkb0nqkir+z1BA3GdTQOa5wtfqh5nIEkGtr8Lhh+sTVX5ks5m2IMA2NwAE1uCEX
	wBsrtK+9/CGZXexd2D+R/9A5u7Byzc2YPLh0EZuFG7MwsSVQeOplqv5l/dtkB3P6ojab1/
	DQHGT9dZV5HOjOQDDbJ2G2/gHkfJXus=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5062fc5d86aso43845281cf.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771865545; x=1772470345; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9p76BczVPf+ipMBZjWxZMf67W68G0E63s5eoAZ2wq80=;
        b=ah5rVmZbgvSckRhX73qdwW+3uLP2TY6b9INz1jh9OMW9n32Xv19HWtxmB0rKAIdRJY
         iZCGCHcJwqvadxr65Mjv+ZjVlSdHywno5I+blaD9V2n4kl4fWagkpEnVAY66ZWzFqTnL
         vW0S7xKeo6VzfAY0NSs9kT3gQuGU4Tk4yTdKF3oT4Lm4ymHj0J2rl334kSVU8TIlJN8P
         rnCpuQ8C8oqnswChJTfWfGGfC7ypk3OcG6RWA0V1LVY8+dtiBaLBqDmaZsjsfGlkoew1
         mQUcVjbFeyegRiGvMD8sjYSWN6GcZtNuFxMwvPmwGU4TwAIh0CmSqFYqChbQs7026i2d
         6w1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771865545; x=1772470345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9p76BczVPf+ipMBZjWxZMf67W68G0E63s5eoAZ2wq80=;
        b=adi3CUk9WFQwMbSPLEznW0oWBArcZ/WW0rc5fShCZukV++UxSIJ8ZCEc5INTZs829w
         jJK4NRpgipVbWc88awcc4TUMp3Ku0nHdUODw7qm3JWvIMSiNCASsDvCURNGBleo+BXuq
         wR4WuAKnl5m7GeTxs6L/XvnV1Bxve/dW9zM8c9XRHUncfFha0epraR1JVoOUpXhMV2HD
         ju9vfYCRhsvlHgpPhAe2ujz6bYOQ347bZ+SXm8uV1MiIVZbCIRsAzhpV4d3DpRY5wIuO
         2JO4CsZlIgAQxwGmsT47c4qUVMytNgb/3/pUR2eRddiMGtj4EoAXqaTeLox8gA7v3IGr
         YA6A==
X-Gm-Message-State: AOJu0YyJMLG2z/XKhf9/qTywLnDErVv3j9R4ffodq/0aiHfuBfzdj62V
	6VB5fSkprdFVeUEI9YEUNJnszC4H+/y6hL2Ytk5EIAzo4q8H7Z2FmOWa8w2hoTgjV84=
X-Gm-Gg: AZuq6aKHNs8oe20/FdCSYzdzsq5gPclKOVJ/AX8L9p7uLchf7JM2Yh2W8kU+zoFdI/I
	gyW0b515K9Ns0jDy74PBylO5iG9qPBd7klphZp+B5gvTELWonkUTdZ8izAr42Z5FdPpnfnQk+W/
	gApf9BH3wFpL8gCH4n7yZptpyHF2GVKb3OZi/L5fcf2+vnrM4YUfOKZhoWHd/37zJDc5C2qkBln
	B4DnN8jN++l8Cy7A2HotEAtmBVOMwm7qhqnEueDL58tJBSMVXNLoPWqe6JLvbHGR4zma0I4MrCw
	PB23CbQ369B/5OlaUYr+RvhQmCvxu7KIcO4hez7y2wQ4P545kENitKWJ+0beD3f0o9+ng0t0p0L
	LpDJlTKIiaZyrydHB3QjngULByTr0iaZsTMqtmrnncHripjq2z3t65T963mrcrc0mWRTQ5eeHN7
	M3EFONFKw+TBrF67i5zs/F2A==
X-Received: by 2002:a05:622a:11ce:b0:501:4859:c7aa with SMTP id d75a77b69052e-5070bbab6a2mr133092191cf.20.1771865544833;
        Mon, 23 Feb 2026 08:52:24 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5072afdef0bsm4637311cf.16.2026.02.23.08.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:52:24 -0800 (PST)
Date: Mon, 23 Feb 2026 11:52:20 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
Message-ID: <aZyFxKGXc8J6PIij@cmpxchg.org>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: DAA801C0002
X-Stat-Signature: a66zb565pjc5ghd8nuwrwpb5okjyfd1z
X-HE-Tag: 1771865545-159275
X-HE-Meta: U2FsdGVkX18+PNvzWzOEpnR98nQGK05xEt//fAJdzvRoyfislAFbiIImllC6lxQpDDX106yuC899zpQpXp6ZZwH3QuYs5DF+NfkxO9FcM+YwQFKFO1WYpF8yEZOf8s7I1f9uOpeBvf7J1SVXy03t8aYywCvDgsIQ7fNeQngw73NHeJ+xxPjgQnpD3Iujfne6k2FUjgVydHDCrlyqAMCEAGrL8uY4L6mWuQ4D94Gx1GzaZqnJQDdStGhMOslbqi/D9lB/x0d7qp61NCx9TZYSrTFK/6UOT+hFwSvs4O8lvVL9GH1xLwAcEX9SoIDn0rQxD6wucdHy7GZfsfHDmLbPy/zLRKoogePgsyWuQRgqZwyxPBKTmhNKdUmBtrezkfINsH+3BUN53TYk32DNCZmQWCCNrN+ygMAi6V0g4ehoKT5vLm1nNeBWRTH059m3uhbDToMBa+U2GK4UnVfEWTtpyiG49Hzu5x8IijYbVhJlllRLX11GWXoeK1VUvKsR/W0urw2HSgG8G/+NHGGScmGgmWmIwLWd3tcRHEzmsYlA0vS4XQxF5kdXU3UfAwoMeGyjOrTZf6incbJPoZAPDDNtz+6e0iW0dhkdRjpe7l87sktS8439GUa5d0qh2HN+tKKTnrvIci1db/F3z6TZpEM+1J1wcV8+oebfSL61w9SzPGdlmhSUZsgcE0QT2GNLxIHA3qOhLsttg5nuJ4h7ik39rix/5HV+h68rckeiO2yI556bVSQ9TL7UasW5tOmuRiYe4LwuNV3Ur2+LFGOyWnZxSeqYnQTj2nW7C8rUIWZQYaN0V4kWzolHlUlxN8vOLsi2AviA8DBRQ1yUYHEu5C26iD6EEKMoUykcuarm7qRj7Uq64UktSQO23B8l3jpHJoZNXegIe2pwtoEhXXwJz/E/08+YliFdr5Flk1cvEY1oCKiFr0Y49rMCY0kVxaRcgXfZVKVsygcGPJuISMvpe5u
 uZi9I6ej
 t4JM/lspLw6oUzMRrsVfa4VKLi3TlTJ/nhXuwOLZb18g2f09zHyeqzk1Fl5nQahk8Fp1NpSBdVe+2E2XGWTWopTz/nfiWRq8b9hx2GhtHFRGfMtQu1nn3mA9QiJU0Ki3a17T/DDRnD+QIHTiiG7rTnd1IQx/Y787C0n+tIEZlZWelqu1Pa5x9st71FTqyZgsPtqDOuLGX2dERSazobBbSEWtz2iJWJFgZQfAtYZ8czj4AmU6pfblShqTxtIlV2rqL/E8e+lwTThQNSgKe7qsJXQuTDL2O/4Z+qAzMGjBSLgMirdeRxagSqi+KpAl4FvQZvee76vOZ7qBIA/0aDYcrY4Dc27c6JeTunsXoCpuC8Ep/oeThQQt/kGT579SXxsRNmmzY06aBXA22rqs0Y1akfkI0APoloaJBdm88hjkQY6XCJxytljyc/l7eF/ex8VsyMJc+VTxD41BVpTVLjD23mgC46D3sXMdyrR4rAvZmKogOubNNYMIeVZ6Q6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 07:42:01AM +0800, Kairui Song via B4 Relay wrote:
> - 8 bytes per slot memory usage, when using only plain swap.
>   - And the memory usage can be reduced to 3 or only 1 byte.
> - 16 bytes per slot memory usage, when using ghost / virtual zswap.
>   - Zswap can just use ci_dyn->virtual_table to free up it's content
>     completely.
>   - And the memory usage can be reduced to 11 or 8 bytes using the same
>     code above.
>   - 24 bytes only if including reverse mapping is in use.

That seems to tie us pretty permanently to duplicate metadata.

For every page that was written to disk through zswap, we have an
entry in the ghost swapfile, and an entry in the backend swapfile, no?

> - Minimal code review or maintenance burden. All layers are using the exact
>   same infrastructure for metadata / allocation / synchronization, making
>   all API and conventions consistent and easy to maintain.
> - Writeback, migration and compaction are easily supportable since both
>   reverse mapping and reallocation are prepared. We just need a
>   folio_realloc_swap to allocate new entries for the existing entry, and
>   fill the swap table with a reserve map entry.
> - Fast swapoff: Just read into ghost / virtual swap cache.

Can we get this for disk swap as well? ;)

Zswap swapoff is already fairly fast, albeit CPU intense. It's the
scattered IO that makes swapoff on disks so terrible.

> The size of the swapfile (si->max) is now just a number, which could be
> changeable at runtime if we have a proper idea how to expose that and
> might need some audit of a few remaining users. But right now, we can
> already easily have a huge swap device with no overhead, for example:
> 
> free -m
>                total        used        free      shared  buff/cache   available
> Mem:            1465         250         927           1         356        1215
> Swap:       15269887           0    15269887

I'm not a fan of this. This makes free(1) output kind of useless, and
very misleading. The swap space presented here has nothing to do with
actual swap capacity, and the actual disk swap capacity is obscured.

And how would a user choose this size? How would a distribution?

The only limit is compression ratio, and you don't know this in
advance. This restriction seems pretty arbitrary and avoidable.

There is no good technical reason to present this in any sort of
static fashion.

