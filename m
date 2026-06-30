Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 542E8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F21B6B0095; Tue, 30 Jun 2026 13:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CACF6B00BD; Tue, 30 Jun 2026 13:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0F56B009F; Tue, 30 Jun 2026 13:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E23236B00BD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:40:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BDB08F405
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:40:02 +0000 (UTC)
X-FDA: 84937292244.22.E3892EA
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id 891FEA000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:40:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sr0wdT6V;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782841200;
	b=rcBEKoBaS18Y/4uVAP5tTtntBkazhLk21ZIDrEmitkvhMj8fYQhp+mVjqx1UAu0KsK81is
	VS/g+ZNpQ2kxJTMfFiHY0mALhLk335AdBop1bIRhJZZ7hnK/fiou/A2EbaeFAJ9kuu4q5T
	ahvsaYj0RZhx5wTmJb6+KT64lVDKwWo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782841200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qW1a37iNA3MeU1ejC3DqxBAWc5gePXhychoyezKqHo=;
	b=cF2Q9yoIIiFf58BeElkmLdoAhqBncL6Jns52Hk1e+zkw1L9qqKx5z7eNtrmtCF5ju+u+HM
	iI9gNLoHHMPihOmyb/vR4wqGc3k2la0R39MNmm48Xk7jc0KFGWoP1DVGH0+2R8QNzmP5yz
	FJwansk02l883JMuqirofrpqLIW4abs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sr0wdT6V;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782841198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0qW1a37iNA3MeU1ejC3DqxBAWc5gePXhychoyezKqHo=;
	b=Sr0wdT6VReJ2L6E1Kf/XUnnltL0YWj1HwAjjM0pLuaOxBd+2DP7+aKiCKfZWNPJnMuoTtE
	CVBmwanSeX7Ai7Apfw6L4QTFp7yq0fioOSnQluFrcDAntu3kBPgRgq/ybr6GWQCxSPwBnu
	dry1Pyn/z4qLacmlL7UPNbuBFxAgGnU=
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
Subject: Re: [PATCH v2] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
Date: Tue, 30 Jun 2026 10:39:51 -0700
Message-ID: <20260630173953.642186-1-usama.arif@linux.dev>
In-Reply-To: <20260628190155.3655895-1-souravpanda@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: cdou7xatqn4oiip7j9ew17rhcbfcmiti
X-Rspamd-Queue-Id: 891FEA000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782841200-60299
X-HE-Meta: U2FsdGVkX1+WMtbG2jxrpTdbjHpOto9/c+VbztD/Obvv9NJC6UTDxBZwFMIeMKYQV9ZLP0kN/9AfyqvPF+5U5Aw9CcJNkbr1n6GvgK/gA+M1LCfw5kVghgvBo/9QusgDTXzs9Qa34NTMjFGvG5Wiu5vJwQKN0AFj3IZJDquLhXxivxJsmw19cRPqJkG90HpVAM0na6bhwMQCufweXTqt0Wsle1TdeaicJtEJFKSVJ1A1J5U1GcnHlz/9uMgGXgSwFI9vdJBYTDlEZlz1tnIMBs67N7in1hy93qLYXvDunUk2A3DUmVyKDPXtyaSUo5+QTl4CM7vMrk0hhG2QLD2nfZ+C11HKMiobsfpZ5ME5B01o/bCiTxc7POYyCjAHpVPFRwsfgXgR35QCM+jr0q2SbN+ltKWQv8tGUDvlIJvPGwIOvnVfV8Ar7qZF3i5yWOmeLTpwHKdFbkDRzAxFMOYYHRYDuZcEaJfWy5k8/EsPTM5OFB2Zqm7+h0/rzEE8GzaKTSqy82+l80P26FhEdDBck2igBL2piWOpMVI2/AVJ7V3NJaz/FvolZQW+d4AbdG9KPlPSExfbuAGF/Slx6fn0AWzJt4ePmwuM1QZbT3X/WsryvfSQy+WGCpiFMkY48+7sVv4Qup35/atwHYRAnjYiIoySi1s9cpFOAE+bAQt85vkkLbPrvAXLwvvoHhArXXJXxspfj64+P8S5ACF2sQuky+vBosYmzyo6Wr3e4EC1a8hNsrPAmoP9JFp8Tv8e9LCmYwGXffDLEUlUlnKQtFBthjjUBmn7rR89qt5Ag2UCliGkcLIj4FRQ2JTELlLvgmKOFSXeTmBH7OkkNlGGbsLCJUbJikQr6xNsqjupGqrtjKThaRNPJHrOxfp6cjkWcKRBir8YOf0t3OBfdpHS/iTNS305TCIi16/gER6mkOmcVPP7xySyURJCwn8of8+WxZdcCqYZiBUoZcU1NPjuUDY
 w+rB+3TE
 45VTxGwCPLVKY5Dshaqd3MvCUdaNofA1jua0vvfDNsrNht9x11+pADG9I+w9F+uNentauajzdL+6GQsq0bi7nZHD+XMOWL8F99CerL3BDHYBokNDaTtpFLiD03fsFtEMwhUnWlZnF0EQHAMit8T1ByX95BvBbNkGiuJPJjmIIr705spsFVfk98PQ4629nP7FfVkNaA5eSMUiFbnnijZlOt7oV9ZPkBMFLlaZm4QZ3lPBcuUwDMBqM4WrQsJmvGFv/2dHfPNCXQsMgYJSUXewFSoDATw0P3L7FGNCqcbun9weOOsj58/qTgmJLmeIfIjEjX3QmPeciI3u7aIBmmUk9OxeqUNjsCbgZLAjAGempvujfYRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 19:01:55 +0000 Sourav Panda <souravpanda@google.com> wrote:

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
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp@intel.com/
> ---
> Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravpanda@google.com/ [v1]
> 
> v2:
> - Use mul_u64_u32_div() instead of mult_frac() to avoid 64-bit division on 32-bit architectures (Reported by kernel test robot).
> - Fix physical memory size truncation on 32-bit PAE by using phys_addr_t in memblock_node_memory_size() (Sashiko).
> - Fix boot parameter override logic to respect standard last-one-wins precedence by clearing opposite values during parsing and clearing node-specific values when global values are parsed.
>  .../admin-guide/kernel-parameters.txt         |  7 +-
>  mm/hugetlb_cma.c                              | 96 ++++++++++++++++++-
>  2 files changed, 97 insertions(+), 6 deletions(-)
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
> index 7693ccefd0c6..684ffa3537d2 100644
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

Can this round percentage-derived sizes to the gigantic page size before the
existing alignment checks run?

For example, on an x86_64 machine with 64 GiB of memory, hugetlb_cma=20%
computes 12.8 GiB.  The later hugetlb_cma_reserve() alignment check requires
the total to be a multiple of the gigantic_page_size, so the documented 20%
example is rejected and the reservation is disabled?

>  
> -- 
> 2.55.0.rc0.799.gd6f94ed593-goog
> 
> 

