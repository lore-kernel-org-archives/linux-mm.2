Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7D7C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 10:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589EA6B0088; Wed, 26 Aug 2026 06:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B596B008A; Wed, 26 Aug 2026 06:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A026B008C; Wed, 26 Aug 2026 06:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 201AE6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:48:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EA1A1A031C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:48:38 +0000 (UTC)
X-FDA: 85143097116.01.0684EC5
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id 33C621C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:48:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MXExMPQp;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787741316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UriBigU2hDRfKDYTaqTqER0mfYgcu+iprH5qyaWSQWc=;
	b=TRWG/sep3dn8MCumKbKaVoaDAv5sDV4oC9cytKb1T9137iZ4cnmKV2fOICoggOLzvTdOVV
	oyqCGH8mQy2fKXpf/+0R0TlmDuSztLQQomI4hZRazKVzFM7h4cWNzS+r8aYqfZPP1Oq0c2
	nI8g+2GqGhfisKUYEeQW/acjhGVyRNU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787741316;
	b=8mKFT6fVRj2zFJa8Jb1BHCL3pAQmZqjjNMF3d7fU/F9KYyqlanXXbQUIOBcqgPI0CixyNR
	ocBdz8So+sg0KelZPDjlMTERPyzTRsHHIFPmrO3CMofBKSPMTiCsqzCRzWRYgCnyiMp9LP
	1JumLJIQj3mJq1iOsMTKTbuSlII5Djk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MXExMPQp;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OWFpLa2hlcedUTd6dCHWJ++O5mBHb6pDvO1c2wDCw8Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787741314; v=1; x=1788346114;
 b=MXExMPQpEcImL2tZdJVmRrI6eUh1yjzMDoZd06yP05X7mata90VLyUGMjzh+Yqnwq74Kwugz
 aMqLN+x91SWlUFW3P15r3IvVA8zPbP3wuF4/Cxs4BzoQEI2GfIhTgp4+FcSQYR1OKhoHp2ztLUE
 CHaRL+mZ89S2tDN9hsgA8epM=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id 19486a93eca802f7;
	Wed, 26 Aug 2026 10:48:24 +0000
X-Mizu-Trace-ID: 19486a93eca802f7
X-Migadu-Flow: FLOW_OUT
Message-ID: <49526857-62f4-45e3-9d8c-40d22586abdd@linux.dev>
Date: Wed, 26 Aug 2026 18:48:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33C621C0002
X-Stat-Signature: o39j1gutnkn84jdnwpm58xmikppcjdrp
X-HE-Tag: 1787741315-191177
X-HE-Meta: U2FsdGVkX1/vFSRbF7I/BiIuft/T7UbYfDw5yxihWJsFsbiDSgbWq+L0IoNo1gG7LsSW4U/n7ya2lptDJ826IYvz9cBGh0Ix1sBIgd+eJKcCq94uwjtdDbpDp01GV/k3mQUEcplCUD2vBmr+NilAv6cM8ShsKOclyrIrWLQDB/SZy85iogT/rqWUDuK9nccfWQaYylz8pbzx8uYzBg33PFDXGyi8c6tqn84o8UgkNHvOt1AsQAzQnzB+fVZBUn+QU+oNQynUI0b1qRuq5aHJump7quFV8iDuP0lUB98PHMgdp2rzK2qV+7Ip+FRLlgnZ8hHyYg/ezfYOwbuMf0AoiTEp9iow5YYGU4cN6+kqVuk/t0uj2gvc68MYliiwFmCNSyuwRCHXG7UM3vpno2RDeqMjcMyDXgqg5rUJMkXRDtuQBAcxjYtt+L+1ucD92wEzTMDxGr85EX5RmxmOgYICfiBr2TorRyehibFwQC17hTlyFgnrdJxMnPOzsWd/0QH1Pc8vUW/ZlOuEERDA3F7id3j5M2ucWcIYP0sefIELsjfwihPqEScMXitP2MjY0ekugkNBkBiH5aYt7qOUoe3yx14VOSjPoVs2J70EDnHQDSuAyP4DLGF0zjmwORebyQj9CRy5zLhAiIMco2ctHDNn3tiKauFGvaJREz7BXFd6gnjfYQcbNl0mY/YFc/XRQd6V/7zne75T/YLfEBkyQb59twcs6BOPl0JChH3e5oQnHg8a9kV8oZs5XP/yXz+lV75yziRntEX+9pFFxcNYsPj8vcEp/c6Zkx58r8u2wUOrj1DVgTBzer7U9vkM4/owhVxwdk80NQehNpIAULdmJIZs3PKyd1mlhRfBmQKVGKw7gaxh5Ziz6EOvpYt06rP4eq/1ZqezSuCPgPGTPclSs8W10jPP6/QEir9sEWxHWU3og5+twIhqNwNm9Jbtg3n7EtbzfL8E9OXGaeW+dIekvhq
 rrqU6i/V
 j2kUWdwmshfJguSbUf4Aohk7eFjfIlMGx7pGLPWK5S35AW0Y8JzKFg+AU3IfI2xef9QFupy4q+c6Ec69HvoHpZ+Fa4EBB1C7m7WolV5AfBrDVSD69pcfgvams75xmYl/uT/uWtXrOJZDWW7a24ZWTcxZd+qx7M5dBjZu7AHDkKesDx811O+ZQKeV/QVhy/9J5dliyMCcFZX5IFYc8vQnJXK/taFIP6KHq/KQcV0opKGWxvGMR6nT5uINmpBZRr3KZwG+y9/qe+T1aAe48h/3WYGd9M2qRDtMhVrdKc6EIE1ASWeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On 8/26/26 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
>   include/linux/mmzone.h    |  1 +
>   mm/folio.c                | 19 +++++++-----
>   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>   4 files changed, 114 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..edfaf2661812 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>   }
>   
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);

It seems a bit weird to have this build warning inside this function,
but after I tried using static_assert() and failed, I think I understand
why you put it here.

Besides that, LGTM, so:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


