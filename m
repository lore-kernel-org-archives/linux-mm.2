Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06575C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8B66B009B; Thu, 30 Jul 2026 08:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0A16B009D; Thu, 30 Jul 2026 08:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE67C6B009E; Thu, 30 Jul 2026 08:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 973126B009B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:49:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 361EE160137
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:49:50 +0000 (UTC)
X-FDA: 85045424940.11.391EAB3
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E948100002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:49:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CDsJyu8N;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785415788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmEwD1aH0H0rZlxyJ22DUchnx362h5tsqtqK+qI1YZw=;
	b=GcCr9Esw8jY+u/LHzB8MpdfqG9FDk/SUsUdpjIoNA8SaMsw60PmVd6C4e3DFE/LlGts1tK
	JYn6bKnoREFVbRr4pMhGpqe7rqGFjU55kWA+hfFlCTV/tWFusfJGil8kGy5bUCAlwPD6a4
	WYa92w3Ydv3kSuwHa6lFofmvg0cp8LM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CDsJyu8N;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785415788;
	b=JuUUwkz5DBsoJp3k33qXKpLSENYX9W/FuFpEq5iHsm7nmfRM6Z+KLpP7553jOT1ICQ3BGD
	Q3NA19XCgbiUhNsFZ0LI9H+wE9ixU1Nsg2oPBt6BXTOoELUliqtGewZuTbWCBtvnfVe1sP
	aQPO/z7z38gF02Z1DvVPONcxXm2UxNM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785415784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmEwD1aH0H0rZlxyJ22DUchnx362h5tsqtqK+qI1YZw=;
	b=CDsJyu8N1O5uh/jYakqQrwBIlvNzeiUJyveqTHqyxOlk1SkRBXGNtG4aHs9NauQpOOMaOU
	qTy9rMJuLj1yF4Yed1/11c/SqAL0qooK3tuDMpn1a65GG6QUDX+cJm8h8g5PVKnXgOubc+
	xt5FYyGweLABBXA8HossoZexF4cK0ho=
From: Usama Arif <usama.arif@linux.dev>
To: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	surenb@google.com,
	fvdl@google.com,
	gthelen@google.com,
	rientjes@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
Date: Thu, 30 Jul 2026 05:49:37 -0700
Message-ID: <20260730124938.2619968-1-usama.arif@linux.dev>
In-Reply-To: <20260729163148.3271755-1-souravpanda@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7E948100002
X-Rspam-User: 
X-Stat-Signature: 1u786dt4yuisfiwoqtddnqt3549u7ss4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785415787-776415
X-HE-Meta: U2FsdGVkX18bqrbfNl7i0hZT284Y3LiJZtrsoqAcInZDS5Lorq8X/yF/xCBGRpNbht3yg3n4l8UYsw5GUqZKtbc9e1nMBBxOWC+oKtvYknfRhe6tRPSaTbT/ZjSHY1eWipD0HOPadwuKOBBA2w1ozBklDfb80Ja0FLkkT25ilox367/u54YW43LAVWXSZM4Ci8QyZYOVtb77PLEQgDt0CTo+1sPyOPvgMetxCzw7RRasN+7wwbPR2uQh+D4B/cAcXA7VDdie18nre8IVS5FcoI9GvhPvDZo470HS0BsnOmL0fKqdpBe2jjqSh5Jd5h8bdOd6cMgYQyZXqTJGHY/uzEnVCq5YgMEuPlJc7GK3gt8fxVNQp7eE19K7W9YT7oQdqHoa6UaEDoAau+Oa1IbHPh3cPiO2tra6t8glj72dw4aVtJRmS0BKcaCKGrRLXPuXYTJh9AW+a7eHUhtKsKvsGqib7h/qztx4lBzf+Y0Mmmr8luu2ukOhXSeWutM4Y22FN4joiGNCxkdAnIBbuMcyT02Mh8Jg9dmQ+heSB0pClOAwlGkzh9btRTALu2/LUzI4OORwgrA36KZJdsRmU00M+DXIUDVVc80eimoPXMJqFFmYTskz6fvsYw4w2icMA4XUeNeVrSUZrfmvlGQ8a0fbd7bSoef0iRmanMNMP9++YZDnkZRcgqD2FwC9068BVyHtImK6M3fg71ny4gXYEOk+I+vIqJ2L56coRi5XKoNhetzqN1o/rSBkyInGb5JJZMvNwze9+KyanjO5o/PNsugxCSPa3WlxyiWRMIyGF2Q0Itld1+nexRMC/cn4rk3Lo8O0BY8krRedtc1iEkScFRjkR9IqYNYQijg/4BNyDmNoGrI9eewq3Zth2P/sRjK93fqz2qazpsmaplBEhk+IFLAlADswQrPcqTslutuSQFdXZyjxNWEOpGRxNPDL1hkjKGM4jU0H+MM0oM07zWZYu7w
 dTax5ZVs
 XZDIoP2156jdYjWrnYai55w673jI29Gg7QiapyN+IIlNtC+MnvrpEkQEGjDC0WbY4l8YoZr9UU0KRosjnCunZTfvplGaBwD0VQ3DqhtOG3pbRP11V6Qc23cqqt/Jm1kTPuK9MvoyBxS9DLktoBJZvU3BnCqZIhzVybkPbjV9hAEBUVOwMGPFyDrOTEK9LIBRTbKJG3dV73qyXlHE4L4P3wgYAL0naSfv/aydpHTqxQr5dh1T2k1h1WjuJE3ztB6S6EgresWKVATUc2RL5QkM2ImaKe83oKW7C7q2L5SObNhHxM9zyBCHh+qO6Lf1DivIGs9o8nQ4JnuM+h70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 16:31:48 +0000 Sourav Panda <souravpanda@google.com> wrote:

> Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
> hugetlb_cma=2G or hugetlb_cma=0:1G,1:1G). This can be restrictive in
> heterogeneous environments or when deploying common kernel command lines
> across machines with different memory capacities.
> 
> Add support for percentage-based hugetlb_cma reservation (e.g.,
> hugetlb_cma=20% or hugetlb_cma=0:20%,1:10%).
> 
> The percentage is calculated against the total memory (for global
> settings) or against the node-specific memory (for node-specific
> settings) using memblock APIs during early boot.
> 
> Signed-off-by: Sourav Panda <souravpanda@google.com>
> ---
> Link: https://lore.kernel.org/linux-mm/20260628190155.3655895-1-souravpanda@google.com/ [v2]
> Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravpanda@google.com/ [v1]
> 
> v3:
> - Enhance pr_info logs to explicitly show percentage-derived sizes per Andrew Morton's suggestions.
> - Explicitly align percentage-derived sizes down to the gigantic page size to prevent allocation failures (Usama Arif).
> 
>   .../admin-guide/kernel-parameters.txt         |   7 +-
>  mm/hugetlb_cma.c                              | 126 ++++++++++++++++--
>  2 files changed, 123 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 5a05b48d1684..846940ce2858 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2064,8 +2064,11 @@ Kernel parameters
>  	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
>  			of gigantic hugepages. Or using node format, the size
>  			of a CMA area per node can be specified.
> -			Format: nn[KMGTPE] or (node format)
> -				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
> +			The size can be an absolute value (e.g., 2G) or a
> +			percentage of the total memory or node memory (e.g., 20%).
> +			Format: nn[KMGTPE] or nn% or (node format)
> +				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]] or
> +				<node>:nn%[,<node>:nn%]
>  
>  			Reserve a CMA area of given size and allocate gigantic
>  			hugepages using the CMA allocator. If enabled, the
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 7693ccefd0c6..99d05eb82abc 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -9,6 +9,9 @@
>  #include <asm/setup.h>
>  
>  #include <linux/hugetlb.h>
> +#include <linux/memblock.h>
> +#include <linux/math.h>
> +#include <linux/math64.h>
>  #include "internal.h"
>  #include "hugetlb_cma.h"
>  
> @@ -18,6 +21,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
>  static bool hugetlb_cma_only __ro_after_init;
>  static unsigned long hugetlb_cma_size __ro_after_init;
>  
> +static unsigned int hugetlb_cma_percent __initdata;
> +static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initdata;
> +
> +#ifdef CONFIG_NUMA
> +static phys_addr_t __init memblock_node_memory_size(int nid)
> +{
> +	struct memblock_region *reg;
> +	phys_addr_t size = 0;
> +
> +	for_each_mem_region(reg) {
> +		if (reg->nid == nid)
> +			size += reg->size;
> +	}
> +	return size;
> +}
> +#else
> +static phys_addr_t __init memblock_node_memory_size(int nid)
> +{
> +	return memblock_phys_mem_size();
> +}
> +#endif
> +
>  void hugetlb_cma_free_frozen_folio(struct folio *folio)
>  {
>  	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
> @@ -100,14 +125,28 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
>  			break;
>  
>  		if (s[count] == ':') {
> +			char *next;
> +
>  			if (tmp >= MAX_NUMNODES)
>  				break;
>  			nid = array_index_nospec(tmp, MAX_NUMNODES);
>  
>  			s += count + 1;
> -			tmp = memparse(s, &s);
> -			hugetlb_cma_size_in_node[nid] = tmp;
> -			hugetlb_cma_size += tmp;
> +			tmp = memparse(s, &next);
> +			if (*next == '%') {
> +				if (tmp > 100) {
> +					pr_warn("hugetlb_cma: invalid percentage %lu for node %d\n",
> +						tmp, nid);
> +					break;
> +				}
> +				hugetlb_cma_percent_in_node[nid] = tmp;
> +				hugetlb_cma_size_in_node[nid] = 0;
> +				s = next + 1;
> +			} else {
> +				hugetlb_cma_size_in_node[nid] = tmp;
> +				hugetlb_cma_percent_in_node[nid] = 0;
> +				s = next;
> +			}
>  
>  			/*
>  			 * Skip the separator if have one, otherwise
> @@ -118,7 +157,28 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
>  			else
>  				break;
>  		} else {
> -			hugetlb_cma_size = memparse(p, &p);
> +			char *next;
> +
> +			tmp = memparse(p, &next);
> +			if (*next == '%') {
> +				if (tmp > 100) {
> +					pr_warn("hugetlb_cma: invalid percentage %lu\n", tmp);
> +				} else {
> +					hugetlb_cma_percent = tmp;
> +					hugetlb_cma_size = 0;
> +					for (nid = 0; nid < MAX_NUMNODES; nid++) {
> +						hugetlb_cma_size_in_node[nid] = 0;
> +						hugetlb_cma_percent_in_node[nid] = 0;
> +					}
> +				}
> +			} else {
> +				hugetlb_cma_size = tmp;
> +				hugetlb_cma_percent = 0;
> +				for (nid = 0; nid < MAX_NUMNODES; nid++) {
> +					hugetlb_cma_size_in_node[nid] = 0;
> +					hugetlb_cma_percent_in_node[nid] = 0;
> +				}
> +			}
>  			break;
>  		}
>  	}
> @@ -144,8 +204,36 @@ void __init hugetlb_cma_reserve(void)
>  {
>  	unsigned long size, reserved, per_node, order;
>  	bool node_specific_cma_alloc = false;
> +	bool has_node_specific_param = false;
>  	int nid;
>  
> +	for (nid = 0; nid < MAX_NUMNODES; nid++) {
> +		if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_in_node[nid]) {
> +			has_node_specific_param = true;
> +			break;
> +		}
> +	}
> +
> +	if (has_node_specific_param) {
> +		hugetlb_cma_size = 0;
> +		for (nid = 0; nid < MAX_NUMNODES; nid++) {
> +			if (hugetlb_cma_percent_in_node[nid]) {
> +				phys_addr_t node_gfp_mem = memblock_node_memory_size(nid);
> +				u64 s;
> +
> +				s = mul_u64_u32_div((u64)node_gfp_mem,
> +						    hugetlb_cma_percent_in_node[nid],
> +						    100);
> +
> +				hugetlb_cma_size_in_node[nid] = s;
> +			}
> +			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
> +		}
> +	} else if (hugetlb_cma_percent) {
> +		hugetlb_cma_size = mul_u64_u32_div((u64)memblock_phys_mem_size(),
> +						   hugetlb_cma_percent, 100);
> +	}
> +
>  	if (!hugetlb_cma_size)
>  		return;
>  
> @@ -163,6 +251,20 @@ void __init hugetlb_cma_reserve(void)
>  	 */
>  	VM_WARN_ON(order <= MAX_PAGE_ORDER);
>  
> +	if (hugetlb_cma_percent) {
> +		hugetlb_cma_size = ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE << order);
> +	} else if (has_node_specific_param) {

Hello,

What will be done here if you have the following in kernel commandline?

hugetlb_cma=20% hugetlb_cma=0:20%,1:20%


It looks like the later node form doesn't clear hugetlb_cma_percent,
so node specific sizes will be ignored, which I think is not the right
behaviour.

> +		hugetlb_cma_size = 0;
> +		for (nid = 0; nid < MAX_NUMNODES; nid++) {
> +			if (hugetlb_cma_percent_in_node[nid]) {
> +				hugetlb_cma_size_in_node[nid] =
> +					ALIGN_DOWN(hugetlb_cma_size_in_node[nid],
> +						   PAGE_SIZE << order);

Maybe print a warning here if you round down to 0?

For example, 5% of a 16G machine will round down to 0.

> +			}
> +			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
> +		}
> +	}
> +
>  	hugetlb_bootmem_set_nodes();
>  
>  	for (nid = 0; nid < MAX_NUMNODES; nid++) {
> @@ -205,8 +307,12 @@ void __init hugetlb_cma_reserve(void)
>  		per_node = DIV_ROUND_UP(hugetlb_cma_size,
>  					nodes_weight(hugetlb_bootmem_nodes));
>  		per_node = round_up(per_node, PAGE_SIZE << order);
> -		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
> -			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
> +		if (hugetlb_cma_percent)
> +			pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up to %lu MiB per node\n",
> +				hugetlb_cma_size / SZ_1M, hugetlb_cma_percent, per_node / SZ_1M);
> +		else
> +			pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
> +				hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
>  	}
>  
>  	reserved = 0;
> @@ -241,8 +347,12 @@ void __init hugetlb_cma_reserve(void)
>  		}
>  
>  		reserved += size;
> -		pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
> -			size / SZ_1M, nid);
> +		if (hugetlb_cma_percent_in_node[nid])
> +			pr_info("hugetlb_cma: reserved %lu MiB (%u%%) on node %d\n",
> +				size / SZ_1M, hugetlb_cma_percent_in_node[nid], nid);
> +		else
> +			pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
> +				size / SZ_1M, nid);
>  
>  		if (reserved >= hugetlb_cma_size)
>  			break;
> -- 
> 2.55.0.rc0.799.gd6f94ed593-goog
> 
> 

