Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31B9C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8EF6B009D; Mon,  7 Sep 2026 06:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD18A6B009F; Mon,  7 Sep 2026 06:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10376B00A0; Mon,  7 Sep 2026 06:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC926B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:52:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2896514010B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:52:11 +0000 (UTC)
X-FDA: 85186651662.12.6EAE651
Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id F1E2420004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:52:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EhO2ieRZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzQSfIDp9gwR1vCr0c9JB+9sQJvaSz0aDGhRN8SYhP4=;
	b=TntLpMSYDk2asY5gFlg715klQuoZ/3fwuepILlVvxp0A3/XnTUnKyI8odhd5vt2Ook5J3D
	2y9hxPm7bqtPL8ClDbgsHA3YpZ8cHI1AMiXFdnWJUi4mvmwVJBUHb6QgJNUQ/x4bfGxaHZ
	w2utyGnRQnymGxYun/Jvf5QzMU8onuI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EhO2ieRZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778329;
	b=qimidFt43snoarRPMDMHEE0TNVWWUherVdvveFTmsLyVoZMJeIxTwfsZ+jrUNQaUDX4YAG
	kgym0CI9UDj7LGneLTl2lfLX2m5nDh50i1tTvoav8eP+XHCnwgxoeY0wmvD6akSPTocytf
	aV+IYiauGZGKDLeuHBo621qPZYQmVcc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kIs7OO2Nz8gSyLnqYZsS6sd9DA4Hzm9SNGUNUFTSoCY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788778327; v=1; x=1789383127;
 b=EhO2ieRZ2O4YEVpxN/0PD59C0RgiTOl9GGy/gBa7S8zbgwOG6/I1vOlVN0fEN45DjQsQctdK
 CcaRX+rG0XelhcHcOg85AxkDmm5MPoGMN1xCRyJnZvH4vONiRIu8qmmRKreXBWceIaICD2ZTG9Q
 9G7JzQg+fEcUjJDZIIMNNfHM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 49a947ce0a393c76;
	Mon, 07 Sep 2026 10:52:07 +0000
X-Mizu-Trace-ID: 49a947ce0a393c76
X-Migadu-Flow: FLOW_OUT
Message-ID: <a0277c83-6beb-4e65-a892-37eace21fc0f@linux.dev>
Date: Mon, 7 Sep 2026 11:52:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
To: Qinyun Tan <qinyuntan@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Kairui Song <kasong@tencent.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
 <20260904033503.4067283-2-qinyuntan@linux.alibaba.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260904033503.4067283-2-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cdpbk5xxsxaoffb1keouzf64rg83sqfa
X-Rspamd-Queue-Id: F1E2420004
X-HE-Tag: 1788778328-380623
X-HE-Meta: U2FsdGVkX1/+hdzBH6Raz5/9f5CYS0dQENmeaV2BIFN4pbj4yokF2SFQbEBinBuAL3Ia8MpvUdUH+i/yr1UGNIc9ROMKpdw8LYMSf918P3+39kNJZbfl4Am61h+FtJ/KiF41TRwrmxRuaK9ILIzYfzFBHH0hjZIQCL+npEPBZH6T5zW9prFXxnW13OM5Lfwp45+FqEIgUwK3rY9iEduFZXXqByCG16O58+gBTGEGEdbO86Mav3MONVRwmDqV2MoGPKxgXxtp+SbkcDlxYnEAcUXkOsgmdPGVFiWWl6bO/mqXI5YONw/EHY/0tyrH0Rnp7YhSDTiz8YWpXHhcwmCt5FBiavPdQPaVgMxcWT904iNcs/iPCRFSg0BP8u7SRIUKaVk1tZ2EMKxjzyiLs3ppgH2tyxfIetiu/MuRiY/Jsbxyj5fMuHc5lljvjMKyd30Ftl0nlAHco0R6smo38hhbkiQPoQZtXxVr7oMC8qDdeIMemdHtn9WLgJ+mKx86yUQqofTxg+3EbNAtKx4v8WGU1i1EFO30j+gFiuKpOPyT3B/5c0+qX53AU7mfHaElxz/FZe7lvuDl67cmMo4a/YeMa0p5KoxCdUzXv+Per13cK/+o74plaWCRrNiBjY1dxBGIm1x2XyLPpRh36BX9nWu9ad6KTknX4wEFDvp2blXposWw1gVRuEczEf8pA5N49cc5Sg/PbWHyWyY3GmsTbvmzWsfq2gBBnvgMLMEqahgq40T3af9Mlx9fwHAmXsTHWDVv6+jAP8efdoHl32alctKECs2cIj5g+vBMBgALpQIT1RgmKqLpf5pwGse9mOGWxPdZakQthtmrsMKsqoGbr7J8g5gZhxdm+C8s1qQXEp77QfpEHqiUkjYruTIFHBUYb0uqZNGeqvjy460ioF6bjeEZ4J41Ax0u/Hdz2EVPC9TlVsYcYaMrhWRE5sNZGvZ/fOyuaGZJM5ZMgtg4OxYhpgb
 ADdx3d2r
 9Z8G+xXzmuwuqsNtxk1uszlRmZ89EzB3nPLC0s6Z+jD3LTi2RP3UukWSbhZYJV6SU+xXO35NRS5pjRuCmDjzfwcqd/ZQ0/Bmak9V+Wl0eaZxS0ofgIjM/VXTCSbsBQLve2tHyKY8+3q9m8bGo3XjnYxzyUHzek7qaUwguS+/axP6hHHkViiAL1lziCqKB4gsgZGjnAJRz4/gtqr5m2G0euW9jBz9ZajtjRUDift9/x00goTLQAAQAb0pZPnPcGjsVWVC/mmeUu11Q11uiLQU5n4Q9qII7tQe5v2dT6x7vN1i+ggPBidcIYz+UeTneEhazT17bpyjCX1qVDMqu5SmYhx16FhhlsxlfAqQ1sc7G/nfiy/anT1FTdQ36k428GYxooJ1FL+Q8EzaH6kmWj80eVHLXTFhatdg8GY4qcj7K24XnCir7BZvpSQxqM4je9z78fE3tAw6OE04tP2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/09/2026 04:35, Qinyun Tan wrote:
> On a system booted with cgroup.memory=nokmem, the deferred split
> shrinker is quietly demoted to a non-memcg-aware one.  As a result,
> partially unmapped THPs are only split under global reclaim; memcg
> (limit-induced) reclaim never splits them, so a cgroup under memory
> pressure keeps its underused THPs intact.
> 
> This is a regression from commit fafaeceb89a5 ("mm: switch deferred
> split shrinker to list_lru"), which re-registered the shrinker without
> SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
> 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
> precisely so it would keep working with kmem accounting disabled.
> Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
> nokmem and the shrinker loses its memcg awareness.
> 
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
> 
> Restore the flag.
> 
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
>  mm/huge_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 644d6905b49cc..16f9aa5b2d077 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1022,7 +1022,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
>  static int __init thp_shrinker_init(void)
>  {
>  	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
> -						 SHRINKER_MEMCG_AWARE,
> +						 SHRINKER_MEMCG_AWARE |
> +						 SHRINKER_NONSLAB,
>  						 "thp-deferred_split");
>  	if (!deferred_split_shrinker)
>  		return -ENOMEM;

Acked-by: Usama Arif <usama.arif@linux.dev>


