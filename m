Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A767C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EC36B00B4; Thu,  9 Jul 2026 14:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FE56B00B5; Thu,  9 Jul 2026 14:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA8A6B00B6; Thu,  9 Jul 2026 14:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7B3B6B00B4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:48:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AE6A1C20E2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:48 +0000 (UTC)
X-FDA: 84970124736.27.055B425
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9626A1A0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A4V9I73E;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zce7Gy7BLpJGfRbz5Cyr9kZ7ZaCsZR2gUrsy+Ad21SE=;
	b=xoi7CSGPXOPnffuEPJZzMscGxYuQ0uxAk7Q5uoojyhdEgYJOonRfe57YIj0e5DGT8QnRu4
	CpEv5Teo/mYLAYGwzbNDioNjAK2IVT+Wxl5KfH89pX/+yuZ+7585pabhndeWRCYiYLGgI9
	80NF5PlQ42wxIe+EpjDzYZ8ao6a1Imw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A4V9I73E;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622926;
	b=yH85nFH5ajpwRVAHxYg/FJMoRF2La0N5ZFmzJ1JagEJxIJgXshimDxdSTzqFKExhyxPgif
	AEuh6LyUZBnBXMTNXDB1giK1G5OqrZTthb9uNPUML5WzhYa2v2KNbo6JhNqNdAMtB87hor
	EE9VsA5eX0dp4ojnMldGroeS5be2blw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783622926; x=1815158926;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eQe38nCcFVma1LFoo+FfKYEwuC+uAK1QDlLMvNStl/w=;
  b=A4V9I73ErKuPhUmkpqwVvKDqQzGKaKapXs+8k+IgIjPl1m2txS/eslGe
   ov5k2Zj+61uJ0No/lEUzGlkkqGIZvCe5+hTqGz21rOnevjvBsA1UiNYnR
   6vpHZAsBQ3Wg/et8KHaxcX1WvMZdhD4/YGv54AghdQ/WmF4ZfQZSJPLgb
   rRWjxlzb/jGJTOmzmGJVBiraa4WkD2oNkOqvOBDoHacfojZKVSbEQyGHD
   q1aR1rM1SEDRbQu/+1Suw/XdBBvqD2VnIh2jAujToiPnwcdrshdTnDRTK
   QotkPGxxwVsJNyZ8KIUV6HzINzee4kymIlACa7p3oAwWAnLhVfAcGc32W
   Q==;
X-CSE-ConnectionGUID: /PdxT1YnRCeaZsi2xZyGcw==
X-CSE-MsgGUID: hkw+3hfwSJuWZyYv6oGwsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84510527"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84510527"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:48:39 -0700
X-CSE-ConnectionGUID: kYtsmSMOTf29rCwwFr7afQ==
X-CSE-MsgGUID: KmQqYJpaQhGKsg7QNVCUnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252932157"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:48:37 -0700
Message-ID: <da2b9492-8b92-42dd-9906-e8942a42105d@intel.com>
Date: Thu, 9 Jul 2026 11:48:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/10] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
 Pankaj Gupta <pankaj.gupta@amd.com>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-6-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9626A1A0002
X-Stat-Signature: y7ia343peitgbpexcu9z5cubujqk14ua
X-Rspam-User: 
X-HE-Tag: 1783622925-685214
X-HE-Meta: U2FsdGVkX18dxsK1IaQjWAzPNNKLswvUh3IAyC/0lWBmq5GN9JQhQMj0zxv8c854wcnjOfNgNdBlfkxSDTBPzisToLg1pFsuy2CfudwiHeYWf4jLjoJGA4KZtdWb4V7CJXw+nX2/YLhUz0QznqqHnHZm0Q+Ypm1CVAtCHoCEauLhZdaikdVV6EvC+J8Ys5ANuALuggPkop+xUYGR6MbAM8yDnWwAGXYZAAqonR+OnIIADIYFS3TMCANVXWFujB06fpb9QfJ0r29DCQD+kuDJuwIwLSLXa8HSndH7HLY9r3bzdEmyIrrrVrYvhXR03W5Rvv6BXmSTpnKMIMQ7AwrzBSfsXpzcoyEctjdot0zr1v/VZFO7l3mhP8LOLgxR2zQxfoRfwUE3w9A/tAcAappqUBqzB97GTf1je0VqW5+zWDABpndtqFAn02x7y21uWnUPj44uEjqyn/g/DyGJFC+Yna1Zx2A0ajMezDkA5pZDB4/sjp6ScPBb0i3Gu9+CRAPTlufiVE6WcU4c30M3+jX8BbourfS80n/diRkbLQ8wgy1v7IU8feX6iLh2AaC5+9OkbD0FsfG6gNOD4dJROsSy+beWFlV41s2MlqYGYlqW5U4Qo3SFAn8lNqVDIlGp9TlId0YegqLSMQFb22monbaRkGHgQU/HZlZBTonZDmWAlr3Z2mrYiCj2Myd+n8Qc1K4Cvu3DeNDZ3taNj4U+JewmjgiTLje80hdNXJQqjfZ37lkz69lOVixZqUoTXYggcmuMJ4VePaGY3XoRp0F/cuBOKtcTBUurhBXKqoiKmnhQXSNwG0FO5ZRCjjtS53PfwlD3FTEHdjmvbtDdfroen5Yu7pPAVyA3jemGBJzN3oOXZw9bLo+HUBPfHJ7ngxofQiEGIbY+BgOzSEu1NlWbifNVKdtbpiIsXdL+boBrojIAQXTe7NcInSnzXHmXqxGr6zDdG/IpTerMhNocfGj3oSm
 37Q+fdXo
 3dgFvE+ZdxN2JU0F/RD3pMbl4ZEYdjmpjtEqf/4I3yyjCnzh0US47l3EptJq3f5DndV/0IWTSodLsrmFyaHhIJbyxDr6XZXJmkAFW96SdelL8CDX07RVHvCA21rNeKmbbHuaKklp8FIdhxD2vX5McisLDa4G9vgJx9gdKeq9y4cIbnX+qifmX1cA7KTxZ3GNks2cTTyOaKV72KLwBWfK6wdyR5K/2mAJm6RkxyhCG2+VVpdD+1aqKcQbum2wRGXoyFKZsxqVfl8rG05VA2HisaYU8QPlNuQRHdcL/9+/u9imKPAeBg34hVpKWOBJ1MBg0pZR7zhJ4j0+MFNKH584ge80VMD22SRlr4oAaLHYoyv7YONj1Ildjb/d7UN8x3ZBekaKQOrHthNXxl4h5NyyCJJx0ZpQ8+x8bzmAWeJzpmceGz0U5RXp0J6aVmz3HJGedQ3CDTPV0n6PuOmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> Existing callers of add_memory_driver_managed cannot select the
> preferred online type (ZONE_NORMAL vs ZONE_MOVABLE), requiring it to
> hot-add memory as offline blocks, and then follow up by onlining each
> memory block individually.
> 
> Most drivers prefer the system default, but the CXL driver wants to
> plumb a preferred policy through the dax kmem driver.
> 
> Refactor APIs to add a new interface which allows the dax kmem module
> to select a preferred policy.
> 
> Overriding the configured auto-online policy is only safe for known
> in-tree modules, where we know the override reflects a different,
> user-requested policy.  We do not want arbitrary out-of-tree drivers
> silently overriding the system-wide onlining policy, so restrict the
> new interface to the kmem module using EXPORT_SYMBOL_FOR_MODULES()
> rather than a plain EXPORT_SYMBOL_GPL().  Other in-tree modules (e.g.
> cxl_core) can be added to the allowed list as the need arises.
> 
> Refactor add_memory_driver_managed, extract __add_memory_driver_managed
> - Add proper kernel-doc for add_memory_driver_managed while refactoring
> - New helper accepts an explicit online_type.
> - New helper validates online_type is between OFFLINE and ONLINE_MOVABLE
> 
> Refactor: add_memory_resource, extract __add_memory_resource
> - new helper accepts an explicit online_type
> 
> Original APIs now explicitly pass the system-default to new helpers.
> 
> No functional change for existing users.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  include/linux/memory_hotplug.h |  3 ++
>  mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
>  2 files changed, 56 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 4d51fcb93a37..ff3b865ea7e7 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -295,6 +295,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory_resource(int nid, struct resource *resource,
>  			       mhp_t mhp_flags);
> +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +				const char *resource_name, mhp_t mhp_flags,
> +				enum mmop online_type);
>  extern int add_memory_driver_managed(int nid, u64 start, u64 size,
>  				     const char *resource_name,
>  				     mhp_t mhp_flags);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 494257054095..a66346def504 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1494,10 +1494,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>   *
>   * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
>   */
> -int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
> +static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
> +				 enum mmop online_type)
>  {
>  	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> -	enum mmop online_type = mhp_get_default_online_type();
>  	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>  	struct memory_group *group = NULL;
>  	u64 start, size;
> @@ -1585,7 +1585,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  		merge_system_ram_resource(res);
>  
>  	/* online pages if requested */
> -	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> +	if (online_type != MMOP_OFFLINE)
>  		walk_memory_blocks(start, size, &online_type,
>  				   online_memory_block);
>  
> @@ -1603,7 +1603,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	return ret;
>  }
>  
> -/* requires device_hotplug_lock, see add_memory_resource() */
> +int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
> +{
> +	return __add_memory_resource(nid, res, mhp_flags,
> +				     mhp_get_default_online_type());
> +}
> +
> +/* requires device_hotplug_lock, see __add_memory_resource() */
>  int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
>  {
>  	struct resource *res;
> @@ -1631,7 +1637,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
>  }
>  EXPORT_SYMBOL_GPL(add_memory);
>  
> -/*
> +/**
> + * __add_memory_driver_managed - add driver-managed memory with explicit online_type
> + * @nid: NUMA node ID where the memory will be added
> + * @start: Start physical address of the memory range
> + * @size: Size of the memory range in bytes
> + * @resource_name: Resource name in format "System RAM ($DRIVER)"
> + * @mhp_flags: Memory hotplug flags
> + * @online_type: Auto-Online behavior (offline, online, kernel, movable)
> + *
>   * Add special, driver-managed memory to the system as system RAM. Such
>   * memory is not exposed via the raw firmware-provided memmap as system
>   * RAM, instead, it is detected and added by a driver - during cold boot,
> @@ -1639,6 +1653,7 @@ EXPORT_SYMBOL_GPL(add_memory);
>   *
>   * Reasons why this memory should not be used for the initial memmap of a
>   * kexec kernel or for placing kexec images:
> + *
>   * - The booting kernel is in charge of determining how this memory will be
>   *   used (e.g., use persistent memory as system RAM)
>   * - Coordination with a hypervisor is required before this memory
> @@ -1651,9 +1666,12 @@ EXPORT_SYMBOL_GPL(add_memory);
>   *
>   * The resource_name (visible via /proc/iomem) has to have the format
>   * "System RAM ($DRIVER)".
> + *
> + * Return: 0 on success, negative error code on failure.
>   */
> -int add_memory_driver_managed(int nid, u64 start, u64 size,
> -			      const char *resource_name, mhp_t mhp_flags)
> +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +		const char *resource_name, mhp_t mhp_flags,
> +		enum mmop online_type)
>  {
>  	struct resource *res;
>  	int rc;
> @@ -1663,6 +1681,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>  	    resource_name[strlen(resource_name) - 1] != ')')
>  		return -EINVAL;
>  
> +	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
> +
>  	lock_device_hotplug();
>  
>  	res = register_memory_resource(start, size, resource_name);
> @@ -1671,7 +1692,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>  		goto out_unlock;
>  	}
>  
> -	rc = add_memory_resource(nid, res, mhp_flags);
> +	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
>  	if (rc < 0)
>  		release_memory_resource(res);
>  
> @@ -1679,6 +1700,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>  	unlock_device_hotplug();
>  	return rc;
>  }
> +EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
> +
> +/**
> + * add_memory_driver_managed - add driver-managed memory
> + * @nid: NUMA node ID where the memory will be added
> + * @start: Start physical address of the memory range
> + * @size: Size of the memory range in bytes
> + * @resource_name: Resource name in format "System RAM ($DRIVER)"
> + * @mhp_flags: Memory hotplug flags
> + *
> + * Add driver-managed memory with the system default online type set by
> + * build config or kernel boot parameter.
> + *
> + * See __add_memory_driver_managed for more details.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int add_memory_driver_managed(int nid, u64 start, u64 size,
> +			      const char *resource_name, mhp_t mhp_flags)
> +{
> +	return __add_memory_driver_managed(nid, start, size, resource_name,
> +			mhp_flags,
> +			mhp_get_default_online_type());
> +}
>  EXPORT_SYMBOL_GPL(add_memory_driver_managed);
>  
>  /*


