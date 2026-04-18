Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08EAEF99C80
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 14:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3523E6B02B7; Sat, 18 Apr 2026 10:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301FD6B02B8; Sat, 18 Apr 2026 10:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219006B02B9; Sat, 18 Apr 2026 10:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12CEB6B02B7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:03:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56608591C9
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:03:29 +0000 (UTC)
X-FDA: 84671844138.01.0B5C077
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA1961C0012
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:03:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776521007; a=rsa-sha256;
	cv=none;
	b=dlgUKl7adK3b2r3zulQYMii3UNFPNP9BkRcrgZfsSD7HHA+oRk+29vhaQy06Tio7PuiTeg
	orFt+jvq6lEAcwO7WsKrpZc69CpSNI1gonDA7FM81/8OU8Ptcv/Hayq7SQkrs+CF5cWlp4
	oEt9O+1EQhx2Ka6ULIGepH6c7hPV5hI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776521007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYPC2N1VfI4bTOk5XclpF7SLAKAyeUf+v5VJqkFFYo0=;
	b=04dgsCZd12Az3ser98MtxwRK/muJtYMgcIV20l7O28S4OwDb/vSwOM7VMLeWOSutJ+996v
	WfmZKLlCHwoJwn5q+r+73FNBbu4prTbZhSCB+XqIE0tmooo6Xytq6Wc7HhnaenFjGURBBV
	YzyQRkXPC9nwYeOXpAgJlU3dF74CUc4=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Apr 2026 23:03:22 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 18 Apr 2026 23:03:22 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 09/11] mm/memcg, swap: store cgroup id in cluster
 table directly
Message-ID: <aeOPKlF4qAdM2oMH@yjaykim-PowerEdge-T330>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
 <20260417-swap-table-p4-v2-9-17f5d1015428@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417-swap-table-p4-v2-9-17f5d1015428@tencent.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 18a3f6u8wscpmqfurb7gyn3wrkfuog17
X-Rspam-User: 
X-Rspamd-Queue-Id: AA1961C0012
X-HE-Tag: 1776521006-292500
X-HE-Meta: U2FsdGVkX1+AgBZfojrCEWdMVIEFzFz/dNHZmnJd472SmAalZpYTUdCJ7x99uRdY8f2oW0vOC5wU1aGXopvJE/ehpHgtD2WTY4joQqrg1N/lcws5A5Ba+eV3edFYiFNezwQ4UtH9JoSVnE1EL4G9zSTgMCFXDm4atD6vzu3ptkJveyexmZ6RuEKM0werrF1Fjl7zkY7BEsvBFYRPyug72H6ggeMnJMj1RmF6KqHpfBdv5OuoegFmCL1WIYZJufN5jRN/ydikXoHcgKkJjS5kxHAiDdGOU95wp4MYWCqJfQVobe2T/nCvLqFltTMrjQSnIJNJGqYhXyHczgiA1bI+D8YeFcrZQlxM4D5RSDFzgDGEOgDMSj3HK4J/2UE4R53fmWeyn76OwQLo+7OABdP47wYakwvIOGRcxBXJesP//mCfKLASrKl3Vn+JZ338+EnR110A+kvMfvTL8zrg20S8rBKWisKa6uQc6QMUMK3kL6CTLMnOsx+bu8EkJo7p74MtCcwm9NvB7yR8DsdVIk+QVI4oyg7YZ75kFmatkUN/O6cKfBq/TuSwjV08LStKuZxcezUxtakv9kQ3DtpKq2tR1u8qQ9YbqAD1DeJG/7/XNbbPivuDUOxOoUGiwzjZvtG38JBd0x3OY1L3kfm/G/yQ8tt0HAqCDEloNKOUzIidGFpALZDlBu/Rs6DkEpZIoXgUZNEivBzfli2LXrdHLY39kuz9FlGQOxo2u31L6sB6NowB8jznzC4BFgIu9/VXQPXZ/3cYhyct1KuY1URI6H9FQJRo08s9KmEaA5snBdjHMQlvkH5HTSoCoIvEVt33koCPeSmhbSF4evZTlM6ajToaFX6gzbXtWJleeGDvtiiN2pyCgq58gLiQu0dQwaVN5VQX2hsVf6A80DToIVcIpewX1e9ntXRzkjo7TKLiyo4Uz7pVdjmsW8hLGIiLLyE9mK2FX8UKqnyD5PkJElLs5ls
 tX3XjayM
 mTV8n+Tx/EFe53+46NGmVPhpgJK1CImhwvSKxjHwkc3dDBoQj7UQQ7kF/ehe+T7EL+esF720ewaS2d2KRmNUPgpFJ85Wzz0/hTMRVKJetSzvKDOZtKI9BNKQJGqeRnusyDQthYRabAtELDsdG1cBQ59pO8BoR1S0iSMaJAu1XpMayIYtTbmpZzINCSQMB/f3ksA6p0oiixqU/bofHYyAF098QBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +		if (IS_ENABLED(CONFIG_MEMCG) && !memcg_table) {
> +			swap_table_free(table);
> +			return -ENOMEM;
> +		}

Hi Kairui,

Nit: 
(Just a readability nit. purely my preference, feel free to ignore.)
the checks around swap_memcg_table_alloc() reduce to two
equivalent forms of the same memcg success/failure question:

(!IS_ENABLED(CONFIG_MEMCG) || memcg_table)   /* success */
(IS_ENABLED(CONFIG_MEMCG) && !memcg_table)   /* failure */

A macro for the failure side would let the call sites read as plain
positive/negative:

#define SWAP_MEMCG_TABLE_ALLOC_FAILED(t) \
	(IS_ENABLED(CONFIG_MEMCG) && !(t))

SWAP_MEMCG_TABLE_ALLOC_FAILED(memcg_table)     /* failure */
!SWAP_MEMCG_TABLE_ALLOC_FAILED(memcg_table)    /* success */

Equivalently, the same macro can be expressed by splitting on
CONFIG_MEMCG.

#ifdef CONFIG_MEMCG
#define SWAP_MEMCG_TABLE_ALLOC_FAILED(t)  (!(t))
#else
#define SWAP_MEMCG_TABLE_ALLOC_FAILED(t)  (0)
#endif

What do you think?

Thanks,
Youngjun Park

