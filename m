Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE5AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665156B0088; Thu,  9 Jul 2026 14:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615D26B0092; Thu,  9 Jul 2026 14:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552E06B0093; Thu,  9 Jul 2026 14:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3386A6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:30:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC4E51C1FF2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:30 +0000 (UTC)
X-FDA: 84970078620.06.BF53A80
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14021160006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VpNCJupc;
	spf=pass (imf08.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783621828;
	b=D0NoTrDfiQcjwJ60TstXa6O2tPgorXWJBebU0Euo2NlAdQJpT06kHDP4MUs2cusYx3/WXc
	poD3jecvaSViTpJHgIRflb5ZOAlH3CFk3ApTlDHpyxuETAarRZwG4rcNr0dZG+EN/lTX1O
	0aOnz4KiKl9Iw0W0uR1YvAgbjlaj0oQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VpNCJupc;
	spf=pass (imf08.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783621828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSIblLaznmZlTWnPXhnYlJQAVMxEGTQDCsBIHdlMB00=;
	b=AWm9Q0VSmc3wi1RSjOQ2cWPQY/5zO2gHIZTqG9BvfyGS7DT6ZK74PwN2RUt7M/ZIOqyM/E
	px265AtDiPoXHspfqG2XgpYZmaWCLh6IZSePo3j4f0wH013QodOkVRdciLpdGAABh8MstZ
	hMZpHUB8Mn5ww6xWv/5UkPb2b0h8XV0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783621828; x=1815157828;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sJrITh55upt9+7i4xO8v5KWYgInW0gtqD9Qlj0C5gCY=;
  b=VpNCJupcThGuEOTkLpYsGwXaM5S1t7Dx/7mvKmqh6KTeJFVKHa12nhYw
   tU+q6bdgnUfxoGXQdNAVPC11s5Gp1GprbA1HQkFwJA9502KCxLv317Vcx
   S8Sz1ksGomliPXaE3jM4A6yAWNpddBzLs6LGNnPXo+cItd8lshBcaAItt
   CppuYqvEu/37l8U7PC2nsSA8ZNVWaff+ad2PVBnHpyc94RRPQ9wKvTrTl
   Do/gI2v4A9JVWDt298eIpOShakW/Hgc3qlbCGHDfqkE+NRHj84Yxube8p
   YPLeyhgNVCCkCiHhOXUQQaZnJg6IqXuKq10GoYhaLsE2VWQQZr44N3j1s
   g==;
X-CSE-ConnectionGUID: 8i+y7gBrRsWZtqDPnPGm4Q==
X-CSE-MsgGUID: 40wlsOdJSSGhmZe8SW+G1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88232219"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88232219"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:30:27 -0700
X-CSE-ConnectionGUID: CreSit38SEqhU34F5Ejwog==
X-CSE-MsgGUID: GyVfq50gT2Gw6mAARUjGdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="256580746"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:30:24 -0700
Message-ID: <6cc4354f-c494-4198-b1ad-a8b538aa1a77@intel.com>
Date: Thu, 9 Jul 2026 11:30:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/10] mm/memory_hotplug: export
 mhp_get_default_online_type
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-5-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 14021160006
X-Stat-Signature: jwo914ouazcf3ouo9tekt8fpoze5ihnu
X-HE-Tag: 1783621827-575988
X-HE-Meta: U2FsdGVkX1/wPrmG+kz6Uuq+GY3PWBaRbSQ4WU4jOfgWGJimg5nzZhJxshvyVov7cw/Ed8Auquk06YVX/GLIfivpDwNadhAImq6Dy8q0im1MpCC2vURv43VoE+Uwqh/pGfPTlJNo0jcioGHXhEaMFXCmqonRnB+Ub/z24sYl8eZKOZYoqGEzKs8ffi1kLsHAVXKm6aq5YwJjxspOK1HacD1g14PuDzT2s9XwlGF+S5UuX5iwdqnZpn+uU/plawJT1opSUFgvLpJOt9iX929b/jCG/8sMPhAwrz9LpzHaRCR/kdITEv1MlXzXlUmanuELL6NymkyJ/KBjhNAr9S575oh80+7aU51EMI8/bB+GD5TDuODrSwt+ygv85C8oT3YeD9996f6v/+gqJRh8OqH4Lf2xr0MET/XkP0JtejCLRMVrQeEU005WwkSFTU8Hb+GwoEmG19K3k7WZ3mtzHjLFT/xsehVfbtQCfL5uVbxTsD0KrayekvGdaI/0jFXNTfQ4q6Djnkn9HYaUhiOMoc2egmQrH0TD/WaGM16X/fIkGeeBzvlSV5HrvDmml3g3EYjdKXm7o1WdIpDCJdjRI28U32MOKsuWNJpR8EbbCD/k39TzdWwpTh4VMbj9zvmUzqATgkICkCvwTjwdeHGtRjYQXH0XrZazmB+pvgk2JunoOXiMLnYKXRWrjIu/e1YHVdnIuZmXM32Tu7Tj1tUJ71MIdGNymfFu9pecSX0uR6PxHW4albANb2eH/5rCren0iRe8EqykzVeKFwp6wk3y3bk8+rVimeLAIR+cqB5Dh9mGMYnL9U7STJEmy+vijNAyb93kERIis2ItjxFYCoYBYN1TToqNa/RkOpoX0MbZLQhZMldW1VWwNLCj4VEoxOquNe5x5futlrdo8WFiUn5uPkWERPdUZBcFru4++VpgxJVnzKZT1VFPfPJDDMO/heDNqbrtf8cznn5UTxlnRnMdeJR
 4qYaze5l
 8PfqQrolIoshRTAqS5xe8+DD7poATPOUsXTWljjVFNoEehGslhW5ggdkp4sZ8zL/C6G1P55LHTp9PzPuY7GGSwxkxC3HE0XKZxrzCaOb+xpeiGiOTT4VzwEsb/gsKIUbOO/Q2cGab18MYsLF3fTZ3NFrrolpiCaxG7krAIlH1cTMWZuWMEM113ewV1FwksOfVOKwg8cc4P3HnanpFhZuY7gvN0pL4GlJjgR9SKW/C+ujC6h532iXePZ4fHDXKv+d1B9vmCxFBTgQeTckhRR29LLD0wAFU4caPWSCR+HGYv04oKHqI6TtZTxiLJ+b1xIdPJUXf/67wwt3dLdfL+QNFpkofV7EwEvvHC2MIByjHen3yUW3uQ3v7rb6b8IuAPXAISC+TqLFaXxhz6tbYrP/19HSmbXXoKeGofuD9xMhEWWNV3u47yK5vxdaxuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
> and the mhp_get_default_online_type function for hotplug use cases.
> 
> Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
> the same driver code, and chose the dax_kmem path as the default driver
> path - making it difficult to require hotplug as a predicate to building
> the overall driver (it may break other non-hotplug use-cases).
> 
> Export mhp_get_default_online_type function to allow these drivers to
> build when hotplug is disabled and still use the DAX use case.
> 
> In the built-out case we simply return MMOP_OFFLINE as it's
> non-destructive.  The internal function can never return -1 either,
> so we choose this to allow for defining the function with 'enum mmop'.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  include/linux/memory_hotplug.h | 2 ++
>  mm/memory_hotplug.c            | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 5d4b628c4a1f..4d51fcb93a37 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -317,6 +317,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
>  extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
>  				      struct mhp_params *params);
>  void arch_remove_linear_mapping(u64 start, u64 size);
> +#else
> +static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
>  #endif /* CONFIG_MEMORY_HOTPLUG */
>  
>  #endif /* __LINUX_MEMORY_HOTPLUG_H */
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 6833208cc17c..494257054095 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
>  
>  	return mhp_default_online_type;
>  }
> +EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
>  
>  void mhp_set_default_online_type(enum mmop online_type)
>  {


