Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A8CDEF06FF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 02:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE656B0089; Sun,  8 Feb 2026 21:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671F36B0092; Sun,  8 Feb 2026 21:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570F56B0093; Sun,  8 Feb 2026 21:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40C606B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:21:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A50268C256
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:20:59 +0000 (UTC)
X-FDA: 84423315438.13.78B4B92
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 90C8B160005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:20:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLXexndb;
	spf=pass (imf08.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770603658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQN407ZmYQBloA6BAF7c/l2mr9zhF3xU5Rg1TJMGq9I=;
	b=fbfLmcHjFtjPgdP7judam7u+/RXSX/YNrzQdtK8e6FtfKXEWBqwQLeghPt2I++WMcAl5sd
	gK9KbQe8ovzmJjUXXfyTnuBdE7v1x/rUaeDC4AQTKWAXWVsJZqe025UnW2ijS/qqITeaKo
	SBdeLOGchTIsIKWwiDqcIoqSsS5qV/Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLXexndb;
	spf=pass (imf08.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770603658; a=rsa-sha256;
	cv=none;
	b=QehwDbnllYV8eYUaHQuS/BI2rPXeVxS9JUNjN9JrNUZddVQbAgi9FRItK5AoctYc2cHyH6
	BbK9IzG9gZxcojpqHg9z+25gV4jA23EO/1YOBDwQ8Z5UhG5geXSJLu2PLMRjoCidLIISNg
	HTWOMVG0nhHlUIde2Fv1H7ezKg2Oxxs=
Message-ID: <d1770ffe-e89f-4ccc-97a0-be74be4e81a2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770603655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OQN407ZmYQBloA6BAF7c/l2mr9zhF3xU5Rg1TJMGq9I=;
	b=aLXexndbUwlN08ZbKLTgVZ3S+Cbm85Eh/H41U4JdL/Q+E/mWv4gQ9k3I628Wp/AiIU5+LQ
	laJ0F7j7YblXLM10Jh4ObSziGAKFyblkgQO3O1+S82HtB1jar0rYvFDzqOqUVeo8pp/46f
	VFtG+BLtbatP7AajwURsO3VFzaSFlbk=
Date: Mon, 9 Feb 2026 10:20:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] mm: zswap: add per-memcg stat for incompressible
 pages
To: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>, Nhat Pham <nphamcs@gmail.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260206072220.144008-1-jiayuan.chen@linux.dev>
 <20260206072220.144008-2-jiayuan.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20260206072220.144008-2-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90C8B160005
X-Stat-Signature: 5twe6x649fnbixjanhazntsitw3sjdai
X-Rspam-User: 
X-HE-Tag: 1770603657-317585
X-HE-Meta: U2FsdGVkX1/UZGq8ozSUdPLCZBJMRE4nGDAwvdfa16erd/RldMTylkWNTrm25qbU1Haq7P9Uasczqvvx2qx+JdO2zLJ83I34VDXk1qXelrR0SkFtgXlhIwVpU27RB1cpg5gDX1eqHZDXQZThApWkvas+8+bLMaFe1NDSjUfNQS1rgqA5JYIlkoGCDPqWjrMACteTcwYE+uAVA7yQ904MLu/ExzGWBMBsQ7PP0BM0LuJOiJF2TEyn0GjaCwWyjQTtNGU4lR50rftXTILK7hJ6tjWp9xoT9rttuTe/JYBKMmFhOqbM9Nm3xcABSE1XRXnx5lOscmYfjEbq2y/tpKBmjuTKHXhIBrDbmkGMcDPSni4H2lWbXwb12Nh7shZpUE67NsklaAcADDpZ0THjURZIEI0JWE+6gPcTD181i9giktk9ValAKczrItwD/Ip22ysZsqkZrFolpcmXikgzkpxPJ+QCqRe37/EzaJwH8gXaOGrbh0NcrVcbYd0ZNi15zM0aPhLJHZf71NCX2bhNSsji5R7NeBdldNwjZEKIBz7Ey8Yl89p2rt1migvVNg+wglENUE0/Z4RlCYDd9nOsYDq/frN1tFMUJ2+oEZHGP2uR2dBr3mvaUsQ1zMVuukuQgG+mMYxXWKcD6xglKC0Xs3Qr30GI6SlFkH/IAEhCA8kx2LR0ed9CCBYKVLQ1VI7XvcAyvx4jSfG2ES8s/S/8/HLj3c0L81XlwnyL2rx6aRwNkAMm30KwMeNSMt46HIhzC/NWSFsx0pHsWyM41tU2xRnZfNIZpqHgTR3hq1/lE6A6DH1DC9ELdTAkXpiFONPcwQQvbZUIQXA5hapN1tsJQy0PA2BQQjR2AVf7D7cSzfPCwTdFpO5SDee0Js2ecdKkyq8PXCSMyJktm+2yLkUSzDCIGqRo2P+5zLb2oqDDZytPxHEWOKLNNtodM+0FSU7Jtno/AMR1+7hli7TBdSItbKQ
 fuIZ+x0u
 3mSzwy3FAbY9V4L9m+/hUNGVk/kak6Ynun8axL9Yozq9JtWonfYN9WMpmsoLzI+NiGn0M9nBA4jAVxD7G7TAQnyHODsRX85WR78i2FaizEU9YjzoJgRf1h9vP+hqX26s577pB5/GpEMZZmpvkcdjHgmat0zr9WR7KqeRTTbvo8hYlXirpn+AyNUU78e32txib1HuJt5//QgK0lbGgfE75p/FbwvpZadvFn+IQ18FVeavSbz21RhCglm9/NvnDILtAIPsO27ZPDx4FA5nPZuS8VDWkJAT+JfJR7f+gMCsp7ixpkdDybBoQ9r7CnkjeagwYQfrU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/6 15:22, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The global zswap_stored_incompressible_pages counter was added in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
> to track how many pages are stored in raw (uncompressed) form in zswap.
> However, in containerized environments, knowing which cgroup is
> contributing incompressible pages is essential for effective resource
> management [1].
> 
> Add a new memcg stat 'zswap_incomp' to track incompressible pages per
> cgroup. This helps administrators and orchestrators to:
> 
> 1. Identify workloads that produce incompressible data (e.g., encrypted
>     data, already-compressed media, random data) and may not benefit from
>     zswap.
> 
> 2. Make informed decisions about workload placement - moving
>     incompressible workloads to nodes with larger swap backing devices
>     rather than relying on zswap.
> 
> 3. Debug zswap efficiency issues at the cgroup level without needing to
>     correlate global stats with individual cgroups.
> 
> While the compression ratio can be estimated from existing stats
> (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> "uniformly poor compression" and "a few completely incompressible pages
> mixed with highly compressible ones". The zswap_incomp stat provides
> direct visibility into the latter case.
> 
> [1]: https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com/
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks!

> ---
>   Documentation/admin-guide/cgroup-v2.rst | 5 +++++
>   include/linux/memcontrol.h              | 1 +
>   mm/memcontrol.c                         | 8 ++++++++
>   3 files changed, 14 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 7f5b59d95fce..78a329414615 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1737,6 +1737,11 @@ The following nested keys are defined.
>   	  zswpwb
>   		Number of pages written from zswap to swap.
>   
> +	  zswap_incomp
> +		Number of incompressible pages currently stored in zswap
> +		without compression. These pages could not be compressed to
> +		a size smaller than PAGE_SIZE, so they are stored as-is.
> +
>   	  thp_fault_alloc (npn)
>   		Number of transparent hugepages which were allocated to satisfy
>   		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b6c82c8f73e1..d8ec05dd5d43 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -39,6 +39,7 @@ enum memcg_stat_item {
>   	MEMCG_KMEM,
>   	MEMCG_ZSWAP_B,
>   	MEMCG_ZSWAPPED,
> +	MEMCG_ZSWAP_INCOMP,
>   	MEMCG_NR_STAT,
>   };
>   
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 007413a53b45..a6b6cf5f1aeb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -341,6 +341,7 @@ static const unsigned int memcg_stat_items[] = {
>   	MEMCG_KMEM,
>   	MEMCG_ZSWAP_B,
>   	MEMCG_ZSWAPPED,
> +	MEMCG_ZSWAP_INCOMP,
>   };
>   
>   #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> @@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[] = {
>   #ifdef CONFIG_ZSWAP
>   	{ "zswap",			MEMCG_ZSWAP_B			},
>   	{ "zswapped",			MEMCG_ZSWAPPED			},
> +	{ "zswap_incomp",		MEMCG_ZSWAP_INCOMP		},
>   #endif
>   	{ "file_mapped",		NR_FILE_MAPPED			},
>   	{ "file_dirty",			NR_FILE_DIRTY			},
> @@ -5458,6 +5460,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
>   	memcg = obj_cgroup_memcg(objcg);
>   	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
>   	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> +	/* size == PAGE_SIZE means compression failed, page is incompressible */
> +	if (size == PAGE_SIZE)
> +		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
>   	rcu_read_unlock();
>   }
>   
> @@ -5481,6 +5486,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
>   	memcg = obj_cgroup_memcg(objcg);
>   	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
>   	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
> +	/* size == PAGE_SIZE means compression failed, page is incompressible */
> +	if (size == PAGE_SIZE)
> +		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, -1);
>   	rcu_read_unlock();
>   }
>   

