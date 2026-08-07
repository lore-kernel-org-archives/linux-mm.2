Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9875C5AC80
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA546B008A; Thu,  6 Aug 2026 20:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975526B0096; Thu,  6 Aug 2026 20:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E946B0098; Thu,  6 Aug 2026 20:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 559756B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:16:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC959A01FB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:16:46 +0000 (UTC)
X-FDA: 85072557612.27.E3D313E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D103080008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:16:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HQaSI/cf";
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786061803;
	b=EynGoN7QsrgZZfNyoYI1hHmFcmCcHEyxvZNMaTvmAjFbMCcwmO+GOQBQG4IL9edsgPyjfT
	poYZylngwuZS1N43vy2H43kyOJQLc7dUdPBRh01dRvXhrSMKsmwhFPYRy46MpnwViVAqSU
	sCxBLvXBw+aPX4ApmME8cDDAYtACVME=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HQaSI/cf";
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786061803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkevoz5jx7erzd5Ik87vNymctnq+yckBopcIFpf/dQI=;
	b=PwZ8rpGjY+G0bW+MO4bJCCbGMWlUSHLul0b513B6XtP9e0hiatuzkQBgAU/fk2nlATaJQ2
	QM0fy8q6WGiDyHt8xljIjlFa2D1qrqlpZSSLlc+/I74lGmPWp3iW1CCv4BZl+TSCL5L9Ns
	KNt//DlDvGOCdBVqmE21TP5JNaHkrkc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22A4943CB2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA90E1F00A3F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786061802;
	bh=pkevoz5jx7erzd5Ik87vNymctnq+yckBopcIFpf/dQI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HQaSI/cfSX8zzyCVbNNYTrKisR24zrpRcxY7Qj5UVvfySDu5hhTCp2GUsYylPqH5d
	 sXOZ62DROdUSWBTSJ8lSykX4XgXz9bOgdI07N56UWyAdujOx4db1/xZB0qGelbg/yq
	 rSuT/SkgsRe1F/Gf/N5nfn5H41Mof39FZJy3RzysEnzdX0qYq4ZUgFG65nWvPVNJEb
	 /NmI7SQECmXbRd1mPLV6mmz/oUgGHvSZUQkYC2JmAE2SrpBJacx6ktLod5PSOgFoeT
	 K4nOaJf+di0TqfPzaObXj2zKjgFaSm1UI4zMGbdN0NyH8JOV7BrkdtHBGm58eXn7x5
	 Gl1bjMhIC9zLw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1f758014b8so264955766b.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 17:16:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpBRZptayngA+11ZXxxKNhie9IfMf4EeqaqWHC6qJc4UIP7/4z4lh6uoTIB2Edse1lf55zL9QEjsQ==@kvack.org
X-Gm-Message-State: AOJu0YyxdqJugeDIf4jTUeEo8tVi/4UOs6YDtIp34tSGFxf7BkUVcrXy
	aJo64Ey6Cm3Jkn58OwRLWSkRK05Amnic7yak2e8ICvDDRGtUM/AG4b1gVDT168SNH7Gj5C/9NxG
	8NTTegI4TLoABR1QgfamypXPDSOyZgLk=
X-Received: by 2002:a17:906:99ca:b0:c16:29eb:e834 with SMTP id
 a640c23a62f3a-c2039cad23amr848650366b.21.1786061801831; Thu, 06 Aug 2026
 17:16:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com> <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
In-Reply-To: <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 6 Aug 2026 17:16:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zODy9UCrtJuU5_SuiZDUbg4dUYLhOyOwZtD-U0N0tpCsA@mail.gmail.com>
X-Gm-Features: AUfX_mx3Xce8tq1HGfkrtfLUcGc5qz1WU-fRmuaPsRk6wi3LUzKvaDu9efg2rJ4
Message-ID: <CAO9r8zODy9UCrtJuU5_SuiZDUbg4dUYLhOyOwZtD-U0N0tpCsA@mail.gmail.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED allocations
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D103080008
X-Stat-Signature: 4pipo1b3qygouwpbhnxxmjer747bd89t
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786061803-807912
X-HE-Meta: U2FsdGVkX1/3hacRatxSL7JuWZ1QCqm+2+spmcsJ+btqre+0np0bQK9nDEXH1OzXgDkLw8Uo9pK4d0AVQ9gcCL9c+fHbCY3Ie4Mt/eYNoQuebYG8zjDYTpi5dHVP/GWWKf++oILHg6xCb2cuxEzMIeIYeU8T3Hg7WFrg48V2VA6f209Vh9uSlkqq75A8UAqgnRjLPoEPlqkcf0nrWmpHgJGoxK0oAzhATZdi62/uUjd3hlAVPy/eQHYubQSDBsi1VOHQG5id9s2LLTIcZdr258vKPpFyCYoWYbDwwD2kqd1EDU7hwDawx3yt4p8c0S9EW9acx+aou6RbIQJzqsHnYyD/RzKm6YuKT6AvrnrjAzY0AOnjXr9kTQCmVgZZcrr0BVTnZNFxrpGgUFhomgKFL0aCjut8V4LV8RpVn0QAnD1mDvviybGm6GMg08s6rlDJ55blb2Vf8T77TFZwjnqPRdntBN6nYYQq4oYlGVJBarj3D7s2sg5YprsRJKDMUc1KLeU2atMVvfyMQCM9kls1ocli+YHIlgkkhaqqzFKV0SqGlVUx5LbBuICvBru82hPLn+FS8b3lkx8lnPdBBACpt2NBes12hUF//O4/vNawRDB2/241Zxng3nxkmzOl577wLgBREGeJHXIqgxsYBrRvIN8JsNPZJdFtArSOc6YlpBPhHUxXQSR3z9z1XppHQsUSkcQcT7ac4OunICLJ+FgK+wNZHO+FyHVWnLHMxl+HKntvX081vltnHUOGGZWtPr++wycNWt5XTdDAgnPNk8/WKNhDVN5KjVuQVgEtjzLY9EVBQPpo4qHoSAsbvou6AL99PLd5LELrH0q9GQQFTdqOuOnQB0s+ch9jCKvh5ptTV2B0AxZCRQ899qNMiKWFzxR5vuFt3MNXY+sXjUMdgWDfMTIz4WLUY4VbuaR9P0sA7za8kmIWI6/ATBZZzSqkJaVQt+qvZ7Lu614BQzX5as9
 +a+DMxDt
 sWLhhSTPjMsLwjLn2+6ZB6NiiwfEYdbpF1NRqVTnNGPgA/Wa5Hx3jJwzUeJf/td7RZDNuQ9PvlxWklbDgylz+B/cfg1jUJqc5nQsLIXsKPgLYrv9YUa2ZPk6h2V3dQhqTnubeZtbkGIrC0ME8Os0hutKxszHmVdYmWXJh9PruEHxLO/JJfL2dy+5PuPbJETGIIpeeYAtrceuKHLMZdX4gHPbk9M+5s3G6XzTjaRq2HSZHYpYTxqbR5FNV1vsaqjKq1jIMusUWqEZw4dD6bSl26kobzsyycf3NPiqr+SZYSqX9t9Sf4SjKOTcJho5BfY9qwKvu2wKPGHcIJ/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 67b01af024e17..c9eb3947ffc79 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1393,6 +1393,9 @@ static bool suitable_migration_source(struct compact_control *cc,
>         block_ft = get_pageblock_freetype(page);
>         block_mt = free_to_migratetype(block_ft);
>
> +       if (freetype_unmapped(get_pageblock_freetype(page)))
> +               return false;
> +
>         /*
>          * CMA pages can only be taken by ALLOC_CMA requests. For anybody
>          * else, vacating a CMA block consumes free pages the caller
> @@ -1444,6 +1447,9 @@ static bool suitable_migration_target(struct compact_control *cc,
>                         return false;
>         }
>
> +       if (freetype_unmapped(get_pageblock_freetype(page)))
> +               return false;
> +

Do we also want to add safety checks in the page migration code? IIUC,
if we miss a check in the compaction code and try to compact an
unmapped pageblock the kernel will crash with a #PF in supervisor
mode.

>         if (cc->ignore_block_suitable)
>                 return true;
>

