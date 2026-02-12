Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76734EE369D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FC76B0005; Thu, 12 Feb 2026 11:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD1F6B0088; Thu, 12 Feb 2026 11:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29306B008A; Thu, 12 Feb 2026 11:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 902136B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:03:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26FFE1B37F4
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:03:32 +0000 (UTC)
X-FDA: 84436274664.02.8841AE9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 413BE40013
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:03:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XIM+yHLJ;
	spf=pass (imf17.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770912210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfB8sYnqeXbZ8+ffK0AiALU2iMNWAjVfv8J2wFjT0wA=;
	b=bXzZph0cPeBHsz4NXW/QRKDSOiqHZdllqrYywPTucn3skic5n3HM4lQVP4KwmUSFAD1jA2
	Er5A1v7W8bq6ciiPX8vIg9g/jtAgq/fySwaJRVLzQm+TY8GAcGPxS2/ijqpNXyAAAh7UyC
	JBMbtkB+Mvn+7/Pja0NVgl9UOJl2BaE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XIM+yHLJ;
	spf=pass (imf17.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770912210; a=rsa-sha256;
	cv=none;
	b=tC8e/YCvYQuvgnYB9F9pbBCfee1AOqk4/zMFJaD0FJitunmzOQgqyvWNrGYX7rPRXp7Cdm
	y/uJTDnowh1plSv4RdC+zFhqE1J4ZHiAhR36WFO1nFeQoE9jy2rOXtmOjuOrgcRL/rmjZu
	3dk9durcb8wEC3GTaZdSEsS5owubqVw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770912209; x=1802448209;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4fNG3CvKr4wbi0rfYGfQ4Cqr/mMgMiKPkb2OL6y6uAM=;
  b=XIM+yHLJOW28/mCfelHyIoHiVw1B6hzQcZvSadiolgn60mIpFkcTcbx9
   in2X+1AuMiyCZW8m2SYUBXx1ycUqdSSS2nmEQJQ7M2cL8kRm2r4Pxd8tr
   yUpjt6m4N4Z8LkkRiqQSg28VI4ED+EzHkIuMoVzkfX1eXe4Scf2F3tyl1
   PnXM40eoQ14EXGZ1TQZSe9WX+EjQChaoZi+048Xu3a2upLZ37COKFHW/O
   5weQPvdZpERVssNBXBqBAlyR+tttUbZAskSyqK+RLTvujYt4FEqDKUfxT
   0eUBoxM5Kvd4MmhI032cZ4LA6yAvLLYgwpkQehV3pXIIXXHg65Xn3Wdyj
   w==;
X-CSE-ConnectionGUID: MXhEEAFyTlyf3aJEnGoa7Q==
X-CSE-MsgGUID: b0KSxgIUTlKdwSrqHiToIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="82813826"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="82813826"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 08:03:28 -0800
X-CSE-ConnectionGUID: dnElJ8ayQoicUF6JOOrR1w==
X-CSE-MsgGUID: IpkXjC5sRe6ez8ntWDGTVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="217167749"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.204]) ([10.125.108.204])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 08:03:27 -0800
Message-ID: <82bf721a-6e22-4e73-ad19-7a4744f9d145@intel.com>
Date: Thu, 12 Feb 2026 09:03:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: name the anonymous MMOP enum as enum mmop
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Jonathan Cameron <jonathan.cameron@huawei.com>
References: <20260211215447.2194189-1-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260211215447.2194189-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 413BE40013
X-Stat-Signature: guegx94zste5dos9axoy8qs9sacd5p9q
X-Rspam-User: 
X-HE-Tag: 1770912209-158020
X-HE-Meta: U2FsdGVkX1/2DMGb/oTTj87G0MBOxdzDZaD102ougURXi2kHzI/m2O6CKfc91Jikdot2/UAGaaXuVhbMXbal6QwQnSKPwa+e1SDHm41bC+HpcV66FiFK3gvUIfPovZqi2EscI2s29yN9QaTEfXYgmxjaA81+76IywEl20G4ocZ+0kgF5kvvPnWJnJu8OYtSvYT7iPdmipYaavI+c9DfVWXy6IiKwGf8evrI4TmDAwD5RTAql++T33kLsXDax/viOHmraGbEIGxasUupTBPCwwy6/i9PtKcCWTwhA7kpVQvwtllp04b1qJZ9nfUlsixUVsnrQV7yxqhzFbvzoMZLF0TOQl/FYD98ME0FwrFNZ1t3jHlcLmpbG6e9uUhpeK23fPwn45UXY+mDM/T5T62LNyqojACdoncqYfPNb2SNqoRUx+hVBsKFswdgshz8tfM0hx2kiOvk/7k+TSgSm+L0EGgtQKBSJ7RGMCcxMv47FR+35FKGoVv55ZC8pIbKX3RKFyQOl3MHrMuuhWHZ8F9mcD1J9uyFmC3flFjQ3VXBkNvLgYHYIvSm21/vN8UTKzgRFPzaZuwyfvb9NrJPit/vHpIxox0NdCMBgZUJ3Yi7Mk9KRs/DHXbgVhP/4ZnavwqDradtsjkyK0BRdw/uE+fpEXUS5kciCaOwQlCw8lZW8/65f+vCvpba64ddyyl1GMxE6B14OX4b0C/o0Xx5j0SpLkfHdwknkhI2lIxHzCPPAibirEVAmV8NwJz+RC3+dBEPjmZk8Bb5m5wBtE2LP2RD+rrOo0SMVct9kNIvfGjcX3LghoeAnmNZqJPVnSq8S5wq9jKuRnNFUbC3QHlUMtIz++R0BUfxgjPrQ0SJHxJiBe89Zlj8KZhtPzFIPTO6PbKHheL+/0gIWQkGc3HtyqfEB9RYxn4KuLXy8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/11/26 2:54 PM, Gregory Price wrote:
> Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type
> name so the compiler can help catch invalid values being assigned to
> variables of this type.
> 
> Leave the existing functions returning int alone to allow for
> value-or-error pattern to remain unchanged without churn.
> 
> mmop_default_online_type is left as int because it uses the -1
> sentinal value to signal it hasn't been initialized yet.
> 
> Keep the uint8_t buffer in offline_and_remove_memory() as-is for
> space efficiency, with an explicit cast when we consume the value.
> 
> Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so
> it is unconditionally available for struct memory_block in memory.h.
> 
> No functional change.
> 
> Link: https://lore.kernel.org/linux-mm/3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Suggested-by: "David Hildenbrand (arm)" <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/base/memory.c          |  2 +-
>  include/linux/memory.h         |  3 ++-
>  include/linux/memory_hotplug.h | 16 ++++++++--------
>  mm/memory_hotplug.c            | 10 +++++-----
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 751f248ca4a8..3753ca80069d 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -452,7 +452,7 @@ static ssize_t phys_device_show(struct device *dev,
>  static int print_allowed_zone(char *buf, int len, int nid,
>  			      struct memory_group *group,
>  			      unsigned long start_pfn, unsigned long nr_pages,
> -			      int online_type, struct zone *default_zone)
> +			      enum mmop online_type, struct zone *default_zone)
>  {
>  	struct zone *zone;
>  
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index faeaa921e55b..5bb5599c6b2b 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -19,6 +19,7 @@
>  #include <linux/node.h>
>  #include <linux/compiler.h>
>  #include <linux/mutex.h>
> +#include <linux/memory_hotplug.h>
>  
>  #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
>  
> @@ -77,7 +78,7 @@ enum memory_block_state {
>  struct memory_block {
>  	unsigned long start_section_nr;
>  	enum memory_block_state state;	/* serialized by the dev->lock */
> -	int online_type;		/* for passing data to online routine */
> +	enum mmop online_type;	/* for passing data to online routine */
>  	int nid;			/* NID for this memory block */
>  	/*
>  	 * The single zone of this memory block if all PFNs of this memory block
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index f2f16cdd73ee..e77ef3d7ff73 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -16,11 +16,8 @@ struct resource;
>  struct vmem_altmap;
>  struct dev_pagemap;
>  
> -#ifdef CONFIG_MEMORY_HOTPLUG
> -struct page *pfn_to_online_page(unsigned long pfn);
> -
>  /* Types for control the zone type of onlined and offlined memory */
> -enum {
> +enum mmop {
>  	/* Offline the memory. */
>  	MMOP_OFFLINE = 0,
>  	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
> @@ -31,6 +28,9 @@ enum {
>  	MMOP_ONLINE_MOVABLE,
>  };
>  
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +struct page *pfn_to_online_page(unsigned long pfn);
> +
>  /* Flags for add_memory() and friends to specify memory hotplug details. */
>  typedef int __bitwise mhp_t;
>  
> @@ -286,8 +286,8 @@ static inline void __remove_memory(u64 start, u64 size) {}
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  /* Default online_type (MMOP_*) when new memory blocks are added. */
> -extern int mhp_get_default_online_type(void);
> -extern void mhp_set_default_online_type(int online_type);
> +extern enum mmop mhp_get_default_online_type(void);
> +extern void mhp_set_default_online_type(enum mmop online_type);
>  extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
>  extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
> @@ -310,8 +310,8 @@ extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
>  				  struct vmem_altmap *altmap);
>  extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
>  					  unsigned long pnum);
> -extern struct zone *zone_for_pfn_range(int online_type, int nid,
> -		struct memory_group *group, unsigned long start_pfn,
> +extern struct zone *zone_for_pfn_range(enum mmop online_type,
> +		int nid, struct memory_group *group, unsigned long start_pfn,
>  		unsigned long nr_pages);
>  extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
>  				      struct mhp_params *params);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..41f48f493b8e 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -221,7 +221,7 @@ void put_online_mems(void)
>  bool movable_node_enabled = false;
>  
>  static int mhp_default_online_type = -1;
> -int mhp_get_default_online_type(void)
> +enum mmop mhp_get_default_online_type(void)
>  {
>  	if (mhp_default_online_type >= 0)
>  		return mhp_default_online_type;
> @@ -240,7 +240,7 @@ int mhp_get_default_online_type(void)
>  	return mhp_default_online_type;
>  }
>  
> -void mhp_set_default_online_type(int online_type)
> +void mhp_set_default_online_type(enum mmop online_type)
>  {
>  	mhp_default_online_type = online_type;
>  }
> @@ -1046,7 +1046,7 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
>  	return movable_node_enabled ? movable_zone : kernel_zone;
>  }
>  
> -struct zone *zone_for_pfn_range(int online_type, int nid,
> +struct zone *zone_for_pfn_range(enum mmop online_type, int nid,
>  		struct memory_group *group, unsigned long start_pfn,
>  		unsigned long nr_pages)
>  {
> @@ -2305,7 +2305,7 @@ EXPORT_SYMBOL_GPL(remove_memory);
>  
>  static int try_offline_memory_block(struct memory_block *mem, void *arg)
>  {
> -	uint8_t online_type = MMOP_ONLINE_KERNEL;
> +	enum mmop online_type = MMOP_ONLINE_KERNEL;
>  	uint8_t **online_types = arg;
>  	struct page *page;
>  	int rc;
> @@ -2338,7 +2338,7 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
>  	int rc;
>  
>  	if (**online_types != MMOP_OFFLINE) {
> -		mem->online_type = **online_types;
> +		mem->online_type = (enum mmop)**online_types;
>  		rc = device_online(&mem->dev);
>  		if (rc < 0)
>  			pr_warn("%s: Failed to re-online memory: %d",


