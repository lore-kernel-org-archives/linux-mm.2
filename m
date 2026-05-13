Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C26CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2BB6B0005; Wed, 13 May 2026 04:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974926B008A; Wed, 13 May 2026 04:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889C86B008C; Wed, 13 May 2026 04:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78BD86B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2737D1A07BF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:46:16 +0000 (UTC)
X-FDA: 84761764752.03.40620B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 78D001C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:46:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DRJceDL9;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lb1usnsh5URVINL0RsbB/MJmjDu50WcmR/KIHT6EB3U=;
	b=3jwIms0fPdTB5b98IdOh7LFMiUcmFY2Te7bHkXpP77po3QN1vhAS0SJzfBJwvvDt1dsBqK
	QJH2AiCmVXIDU0jj76HguPKni0f46e7FqNHTDJXRypK97XbqXnlPS5uaiWzCGLSOBUoHrS
	XFF06FjDUXUkRp3B4Crdc2N51HYCUBU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DRJceDL9;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661974; a=rsa-sha256;
	cv=none;
	b=4a18zmLrS3+/PiuMPYPkFTQNdQPrk9nPEhLd8ICrBZOwFF0wP4G21zfAAx6CSwwhc1fZxI
	jD6/MMz/mgzD/s5ax5gxgSTqBVixqnVFpS/8DsT06WIBg0N/J2IAeCpkiSO5xwp2MTAu+v
	2ouPkXyPaq7CmJ9t30urbKJz1GV3aPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DBF8160120;
	Wed, 13 May 2026 08:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06085C2BCC6;
	Wed, 13 May 2026 08:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661973;
	bh=ILWBwGm83K3BmLSOpvLrUBlj85UBNl86Bqkemg2OxXA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DRJceDL9vOKLM1mjkAiDRA6gLZQki+SibT/RXFX3rZjHTMno3DOy0cQ1s3lwUmxiu
	 xA/VXkFXesot8egraTCH0yK27xHLHtinSgs3bmDeKv5dgVtFm1RNQaMoBN7WhX6WE2
	 orkf9gh2eR3LG9je8Hcuu4tuhSYoWQxa41psIv4jvpaUh6FZCLbrMYhkMWYs0jc5KE
	 o1K+zkjdfDXO8nGvm69xRPMDyz88OfHPc+2Ya+u40U/fZZeqxmm16jD97mU5LkRfMm
	 VsvnPdrdnEolhz8eSJRR3H/giVuIjOrB8iGZ+U/l4l4a++Ul9OJ8en8wplVle65sQ2
	 2B16qypcMVJVA==
Message-ID: <995579f8-d099-4985-874b-ad8114936661@kernel.org>
Date: Wed, 13 May 2026 10:46:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/22] mm/page_alloc: separate pcplists by freetype
 flags
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-16-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-16-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78D001C0005
X-Rspam-User: 
X-Stat-Signature: 45k189h6up446fk4tbppyeksor5z8r3p
X-HE-Tag: 1778661974-362159
X-HE-Meta: U2FsdGVkX18hbfpia4abHV1JGpPUDQc/BFyBxt6NL54PlS6XQ1/vIfcTxs56WXFZjMWTw9Q1RYk3hXP4UwTU77t+hyC8zYqm+550aGMVMEpZyjm/U0t8P4mq//OzSG/JALA6PJ9D5otqZkL+B5kpx/uubNsixUprMz72ih8nYf83UO25Kyw/6LtTa5h17FXwaqMU+QzxMdaIos5A/up/GIj5MuXcK5coDnCVBMn38gtsRjAUFjJcWoMQ7A88pWMixOYyFh8xRwOS+wCcCM+43vx0hHDeJ5TCnmTZUZN3z5fFt4rfR0JMf85U3bjmxNZ3nUjueLeRPx1DUa6HxApDL7dy30PCLyrwpXM5/Hd84+EWSn/36XN5yv+4NBDwx1wxc060xiuQG3pmnhsu+Cvzb04WAJk8UPKjEHQ4ud/e2+tO+a2rTMv8I69HVijsbBPyRrwCUVjn5loeNXjEZHuX1LYE4LfbKZ/PMo+skSlz4WHgf+LYeKoHlJjOtkI9Bmn1YUiigcD/Fv/29mRVDdC+pk35Oh6wnIumhMPj0R4ZBUBKQG3ke0s3zLqV35UeMDY8q5v8OSusGGHCkMVu20M8OFu8QoTKEKTVB2BVD+VDRXxyNynXbFyfTSrpQ1HiP5HKjmopSw8eW5K0X6cVgsvxWVo+Xe1TjURAliNFZFSs7TPv4CkXEM1J0GIMVdvTJTV3iy5THJs+FS/ruaNrloTxABcZ9tbE4f70QC6Jk1UX1n+JTQTFn44F6RqMIisA+6hXFKKTktxk2pKmkHlabYNzwAzaBRhsfyCgVuLkzAxtqnto4+LzTn4sEXkvLPFcr1y2dCW8aJsPxSkjhPKb/h4gLscVpzdlwKwo6ee60DOwWlOoWshmfrJwlUX0V01TPER8578ZBRe1sOAgfpson594yhKKx//wdCbSJDdhDrzJMHpQmCj+2zREA0nrl8jH4ssMx8fWRD2hJfjaogCzqiT
 q59EwSBO
 wnQthmnNxDNTxR+s3k7Cs11wPDEGzHNcHs/qMfZ2arJdcYp+YVGJghMen4vsMiOvWJEyQdwP3BPHUuQnyz7r7Zon3jPFHqiS7VpHtAmA7r+Li1lmnDyBasGpB077X1n5rgaro5jZOn05toCFnyVK2xVuXp8XhdRkr/dx20O0y6aYimYu34ld3UbQehFXbvDZxjpJmzHeydDbhn8CRlZxV5Us5Gy9oebQXET0mLXI/iJXf5Hjx97ByPQzc7Jm5q9QtLXUAWo7L1X/FTEfxJ7cyCJLRuhKH1S9TrUNApjPQxaljbIYJ5eSSqRlNMO10AC7Bknci9GBev6QW7fqTPt2l80gSHwJaQB1ziXEiRzeFmKBp7+er6a1Qo8dgUL6mS8OE6iog
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> The normal freelists are already separated by this flag, so now update
> the pcplists accordingly. This follows the most "obvious" design where
> __GFP_UNMAPPED is supported at arbitrary orders.
> 
> If necessary, it would be possible to avoid the proliferation of
> pcplists by restricting orders that can be allocated from them with this
> FREETYPE_UNMAPPED.
> 
> On the other hand, there's currently no usecase for movable/reclaimable
> unmapped memory, and constraining the migratetype doesn't have any
> tricky plumbing implications. So, take advantage of that and assume that
> FREETYPE_UNMAPPED implies MIGRATE_UNMOVABLE.
> 
> Overall, this just takes the existing space of pindices and tacks
> another bank on the end. For !THP this is just 4 more lists, with THP
> there is a single additional list for hugepages.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Nit:

> ---
>  include/linux/mmzone.h | 11 ++++++++++-
>  mm/page_alloc.c        | 44 +++++++++++++++++++++++++++++++++-----------
>  2 files changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index af662e4912591..65efc08152b0c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -778,8 +778,17 @@ enum zone_watermarks {
>  #else
>  #define NR_PCP_THP 0
>  #endif
> +/*
> + * FREETYPE_UNMAPPED can currently only be used with MIGRATE_UNMOVABLE, no for

                                                                        so ^

> + * those there's no need to encode the migratetype in the pindex.
> + */
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +#define NR_UNMAPPED_PCP_LISTS (PAGE_ALLOC_COSTLY_ORDER + 1 + !!NR_PCP_THP)
> +#else
> +#define NR_UNMAPPED_PCP_LISTS 0
> +#endif
>  #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
> -#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
> +#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP + NR_UNMAPPED_PCP_LISTS)
>  
>  /*
>   * Flags used in pcp->flags field.
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f125eae790f73..53848312a0c21 100644

