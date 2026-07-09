Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35201C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2856B0005; Thu,  9 Jul 2026 18:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CAA6B0088; Thu,  9 Jul 2026 18:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044086B008A; Thu,  9 Jul 2026 18:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C15126B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:14:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12DF312029B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:14:35 +0000 (UTC)
X-FDA: 84970643310.02.7D94AF0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8479310000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:14:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mEPJw3Qj;
	spf=pass (imf05.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783635273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M94IAuvV4+QhxGhOa+LeYfxhtX2YDuwiGYbQ4fxHZ8w=;
	b=hQBGyuzKZii8BcBjoRFKYSscRegaJNLlJZCvVq37v22B8HOXva+LLHz9im0PWHSWpFtxBC
	X96jAcYvpilf8Jq6Dw0JzdDLGm1CTKW44TTlOctl/a/N/k728BngdS833RQU3RgHD5cxEu
	coP6jiMkQGVtBkQf/Q++fD3nYgBRIo0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mEPJw3Qj;
	spf=pass (imf05.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783635273;
	b=TWPf3GiFT1+LOHi1XENJKstuPJ7crxhMA/ZpXqmDtQUEMU/D4mnn1bNllmwkLZ3Mt0g40Q
	xQLcmW3J5PXK4Mfn4t7rZdBJCUNq0X7a9SdRrKIbUAAIvGRMvwzSHs6GzadTAJyBawqH+R
	0cHVGksGkpLUTXjAAsNJ/T+on8/+K24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783635271; x=1815171271;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H13cOZs0rbpMAnxve/WCmr3/qvgKGoLzGrSYFqPcPfw=;
  b=mEPJw3Qj4iwrxQWNjZtsfcRbEzI8MrcYILPyXb4OWHLt5Zj7HNdM+uK8
   gXO3ws1HNprbZjI4hydhLG4V+w34Rq2b7yBVK48p2FJKu3QqTpuAJZKsQ
   jnK3VDa+zfJbcmlJ3pRcJgEEVYoU3wa0Ck3CtFcklppcZ6fHt3ny7c/FQ
   FsB+peneZyZebJ/1L63a/waJiJVNyZb8+lyso4T/u5a2mIm5XxUJKk6Y+
   miqHNkeI9s25sqnqGCUNBVNzVwtZs+ml5kWkuFhloT2OyP9+YkZOpCQNe
   lqOwXtlzUb87m13zZcnIW/TyYTEHB1vbHaeSBuuxDMYzhj2yXlPaYx+TN
   Q==;
X-CSE-ConnectionGUID: 8nzDktquRu+prwnUTDPgsQ==
X-CSE-MsgGUID: 9gL8XuqiQG6Yz+kgxdag8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71859267"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71859267"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 15:14:30 -0700
X-CSE-ConnectionGUID: CX//9Zr4Th6aMk7l2xDAtw==
X-CSE-MsgGUID: 22qVyAETSnC5lNDGXLID8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258601322"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 15:14:28 -0700
Message-ID: <6fd50351-93e0-4d65-960f-53dee655a786@intel.com>
Date: Thu, 9 Jul 2026 15:14:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
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
 Hannes Reinecke <hare@suse.de>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-10-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8479310000A
X-Stat-Signature: xq1zx3ute51fgr9m9mpnwezbr8fr3oyx
X-HE-Tag: 1783635271-818063
X-HE-Meta: U2FsdGVkX18/GDDEpLVhU/8WVdXRPRqX12va04aRETvRH40ctkg7SPuKLIBsBptXNCJUvX5R7Dv/2Ar8U536Yn/zgGmBZtCVji3UX2WEYFlHzrOfOdApeXW2w1QwzOnqtBSCj+bWWSMMk1JcWo8XjkVn9HoQEPWb6xg+FR48AYNL8iOY0LC30ye3FyYeNDd1el6ygeVEfk4gYdrB+rSso9lAiEIDpRANs9/xS/TNUrDvSsvbQh2h4abO/6w4ImaM3E86muhODvcorumh9UP+joCWBVyCq/qXI9lJzogk6ka0sDQOLkMoZrUZIDnakLuomg5Vbt4G3PM1/GG4XeTulcUKSLE7HhZIh/xPQoQie6I0/hV9f8vOiP/XHAM0HPdwpqX2OAINlHBzRvg7GXypP4uw6jkRy5/xWX8dMqmX96cAVjuflt9tNDeInMCc6PN+pi1aEpXayhVm8VnOt9mRZkqx7ld1Z+jBD+sVrmtcfy/Km9OxfnyzjsogSZaUfRZv7YfUV4k0QjOeS0RAFIsLL+abA5CBSVyFr7EyH/nD036mq9vD0i0piqEENG2/x52iblllgKR0TGKNmsbswuJu2ANlKz97bLIEM8VsyqSVp5ngyN30PIR1iYcYGj7JUSvPS5eG3cic886wsoKiOWJkhv5CwzMdXJhMvTzM3LAZeq80hnpercaLJ2jfkMhUbhXVzgrbjhyS3y90IdFVJIMemYAXbGtNV0elVnq9sSRoJxK9oAHJgGakyK5+/43FPIULKc/zApEr6LQFzwgCxeLZYKejjlNfwqR1kBPd7ZbYg0lLqj/KpcURjYzS0j9tR1eyd2fPmOBNCU6FJnul7nA2j4WlDaZLmjh5xZZpiKQobdV7jAkBlsD+JsKc583DMFo3v9XR+MoM1CU4fG/HUSkHsBN0MAoNGDx2Tn47YClQl7sTICmD+s24ymS2Wh7emhHO+Qzw6IWQbETD7t1taPh
 bLICGVNW
 3XUhIoennSzbYZQaU/YibpbTHhWIx9MBatr9bAjesiD1FGvw7CiRpQeH7wlUBlCebgf/J4Yf9nmGhgqRUeIjM3VELNK9Gp+fX12kvTLdAkkrfpwsoZV0wFs+Fcs+rHFrH0L7m/kWMx759xeiKK23oQm5suHJdfRixejRW45YBmtuPRvcrIcu+7AQnjdcfneXm3xBw9202Of9CF1Vxt3eA6gW9K0pSU+K35mpsfqd7welM2q5pzCqRbeNjn7EYucElYH3qljh2nO7cMigL3kD9C+jk94+QCh9hhkjymS2ystdG8Eq/d7MoZYBY3ryRWYiWyNUfLRJxhMYC4nzrWwVLsMLhHOfCLuWLvFir4ZN7cvFjQGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:
>     1. offline all
>     2. remove all
> 
> This creates a race condition where another entity operates directly
> on the memory blocks and can cause hot-unplug to fail / unbind to
> deadlock.
> 
> Add a new 'state' sysfs attribute that enables an atomic whole-device
> hotplug operation across its entire memory region.
> 
> daxX.Y/state mirrors the per-block memoryX/state ABI:
>   - [offline, online, online_kernel, online_movable]
>   - "unplugged" - is added specifically for dax0.0/state
> 
> The valid writable states include:
>   - "unplugged":      memory blocks are not present
>   - "online":         memory is online, zone chosen by the kernel
>   - "online_kernel":  memory is online in ZONE_NORMAL
>   - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>   - unplugged                -> online[_kernel|_movable]
>   - online[_kernel|_movable] -> unplugged
>   - offline                  -> unplugged
> 
> A device can only be onlined from "unplugged", so it must be returned
> there before being onlined into a different state.
> 
> For backwards compatibility the memory blocks are always created at
> probe - existing tools expect them to be present after kmem binds.
> 
> "offline" is therefore a reportable state but is not writable: it only
> arises from the legacy auto_online_blocks=offline policy.  Onlining
> such a device through this attribute requires unplugging it first in
> an effort to get drivers creating DAX devices to set a default.
> 
> Unplug is atomic across the whole device: dax_kmem_do_hotremove()
> collects every added range and offlines/removes them in one operation.
> Either the operation succeeds or is entirely rolled back.
> 
> Unbind Note:
>   We used to call remove_memory() during unbind, which would fire a
>   BUG() if any of the memory blocks were online at that time.  We lift
>   this into a WARN in the cleanup routine and don't attempt hotremove
>   if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.
> 
>   An offline dax device memory is removed on unbind as before.
> 
>   If online at unbind, the resources are leaked (as before), but now
>   we prevent deadlock if a memory region is impossible to hotremove.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  Documentation/ABI/testing/sysfs-bus-dax |  26 +++
>  drivers/dax/kmem.c                      | 258 ++++++++++++++++++++----
>  2 files changed, 248 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> index b34266bfae49..2dcad1e9dad0 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -151,3 +151,29 @@ Description:
>  		memmap_on_memory parameter for memory_hotplug. This is
>  		typically set on the kernel command line -
>  		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
> +
> +What:		/sys/bus/dax/devices/daxX.Y/state
> +Date:		June, 2026
> +KernelVersion:	v6.21

Kernel version a bit old :)

DJ

> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) Controls the state of the memory region.
> +		Applies to all memory blocks associated with the device.
> +		Only applies to dax_kmem devices.
> +
> +		Reading returns the current state; the writable states mirror
> +		the per-block /sys/devices/system/memory/memoryX/state ABI::
> +
> +		  "unplugged": memory blocks are not present
> +		  "online": memory is online, zone chosen by the kernel
> +		  "online_kernel": memory is online in ZONE_NORMAL
> +		  "online_movable": memory is online in ZONE_MOVABLE
> +
> +		"offline" (memory blocks are present but offline) may also be
> +		reported - this happens when the device is bound while the
> +		auto_online_blocks policy is "offline".  It cannot be written,
> +		as it's not useful and creates device destruction races.
> +
> +		A device can only be onlined from the "unplugged" state, so a
> +		device must be returned to "unplugged" before it can be onlined
> +		into a different state.
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 72dcccee41e1..19effe0da3dc 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -42,9 +42,15 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
>  	return 0;
>  }
>  
> +#define DAX_KMEM_UNPLUGGED	(-1)
> +
>  struct dax_kmem_data {
>  	const char *res_name;
>  	int mgid;
> +	int numa_node;
> +	struct dev_dax *dev_dax;
> +	int state;
> +	struct mutex lock; /* protects hotplug state transitions */
>  	struct resource *res[];
>  };
>  
> @@ -63,12 +69,22 @@ static void kmem_put_memory_types(void)
>  	mt_put_memory_types(&kmem_memory_types);
>  }
>  
> +/* True for the online states a kmem dax device can hold. */
> +static bool dax_kmem_state_is_online(int state)
> +{
> +	return state == MMOP_ONLINE ||
> +	       state == MMOP_ONLINE_KERNEL ||
> +	       state == MMOP_ONLINE_MOVABLE;
> +}
> +
>  /**
>   * dax_kmem_do_hotplug - hotplug memory for dax kmem device
>   * @dev_dax: the dev_dax instance
>   * @data: the dax_kmem_data structure with resource tracking
> + * @online_type: the online policy to use for the memory blocks
>   *
> - * Hotplugs all ranges in the dev_dax region as system memory.
> + * Hotplugs all ranges in the dev_dax region as system memory with the
> + * provided online policy (offline, online, online_movable, online_kernel).
>   *
>   * Returns the number of successfully mapped ranges, or negative error.
>   */
> @@ -77,9 +93,15 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
>  			       int online_type)
>  {
>  	struct device *dev = &dev_dax->dev;
> -	int i, rc, onlined = 0;
> +	int i, rc, added = 0;
>  	mhp_t mhp_flags;
>  
> +	if (dax_kmem_state_is_online(data->state))
> +		return -EINVAL;
> +
> +	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
> +
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct range range;
>  
> @@ -123,14 +145,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
>  				kfree(data->res[i]);
>  				data->res[i] = NULL;
>  			}
> -			if (onlined)
> +			if (added)
>  				continue;
>  			return rc;
>  		}
> -		onlined++;
> +		added++;
>  	}
>  
> -	return onlined;
> +	return added;
>  }
>  
>  /**
> @@ -193,45 +215,64 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
>   * @dev_dax: the dev_dax instance
>   * @data: the dax_kmem_data structure with resource tracking
>   *
> - * Removes all ranges in the dev_dax region.
> + * Offlines and removes every currently-added range in the dev_dax region
> + * atomically: either all ranges are offlined and removed, or none are and
> + * the device is returned to its prior state.
>   *
> - * Returns the number of successfully removed ranges.
> + * Returns 0 on success, or a negative errno on failure.
>   */
>  static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
>  				 struct dax_kmem_data *data)
>  {
>  	struct device *dev = &dev_dax->dev;
> -	int i, success = 0;
> +	struct range *ranges;
> +	int i, nr_ranges = 0, rc;
> +
> +	ranges = kmalloc_array(dev_dax->nr_range, sizeof(*ranges), GFP_KERNEL);
> +	if (!ranges)
> +		return -ENOMEM;
>  
> +	/* Collect the ranges that were actually added during probe. */
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct range range;
> -		int rc;
>  
> -		rc = dax_kmem_range(dev_dax, i, &range);
> -		if (rc)
> +		if (!data->res[i])
>  			continue;
> -
> -		/* range was never added during probe, count as removed */
> -		if (!data->res[i]) {
> -			success++;
> +		if (dax_kmem_range(dev_dax, i, &range))
>  			continue;
> -		}
> +		ranges[nr_ranges++] = range;
> +	}
>  
> -		rc = remove_memory(range.start, range_len(&range));
> -		if (rc == 0) {
> -			/* Release the resource for the successfully removed range */
> -			remove_resource(data->res[i]);
> -			kfree(data->res[i]);
> -			data->res[i] = NULL;
> -			success++;
> +	/* Nothing added means nothing to remove. */
> +	if (!nr_ranges) {
> +		kfree(ranges);
> +		return 0;
> +	}
> +
> +	rc = offline_and_remove_memory_ranges(ranges, nr_ranges);
> +	kfree(ranges);
> +	if (rc) {
> +		/* Recoverable: the ranges rolled back, nothing is leaked yet. */
> +		dev_err(dev, "hotremove failed, device left online: %d\n", rc);
> +		return rc;
> +	}
> +
> +	/* All ranges removed; release the reserved resources. */
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		if (!data->res[i])
>  			continue;
> -		}
> -		any_hotremove_failed = true;
> -		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
> -			i, range.start, range.end);
> +		remove_resource(data->res[i]);
> +		kfree(data->res[i]);
> +		data->res[i] = NULL;
>  	}
>  
> -	return success;
> +	return 0;
> +}
> +#else
> +static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
> +				 struct dax_kmem_data *data)
> +{
> +	return -EBUSY;
>  }
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
> @@ -247,6 +288,18 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
>  {
>  	int i;
>  
> +	/*
> +	 * If the device unbind occurs before memory is hotremoved, we can never
> +	 * remove the memory (requires reboot).  Attempting an offline operation
> +	 * here may cause deadlock and a failure to finish the unbind.
> +	 *
> +	 * Note: This leaks the resources.
> +	 */
> +	if (WARN(((data->state != DAX_KMEM_UNPLUGGED) &&
> +		  (data->state != MMOP_OFFLINE)),
> +		 "Hotplug memory regions stuck online until reboot"))
> +		return;
> +
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		if (!data->res[i])
>  			continue;
> @@ -256,6 +309,85 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
>  	}
>  }
>  
> +static int dax_kmem_parse_state(const char *buf)
> +{
> +	int online_type;
> +
> +	/* "unplugged" is kmem-specific - the rest map to MMOP_ */
> +	if (sysfs_streq(buf, "unplugged"))
> +		return DAX_KMEM_UNPLUGGED;
> +
> +	online_type = mhp_online_type_from_str(buf);
> +	/* Disallow "offline": it's not useful and creates race conditions */
> +	if (online_type == MMOP_OFFLINE)
> +		return -EINVAL;
> +	return online_type;
> +}
> +
> +static ssize_t state_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct dax_kmem_data *data = dev_get_drvdata(dev);
> +	const char *state_str;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	if (data->state == DAX_KMEM_UNPLUGGED)
> +		state_str = "unplugged";
> +	else
> +		state_str = mhp_online_type_to_str(data->state);
> +
> +	return sysfs_emit(buf, "%s\n", state_str ?: "unknown");
> +}
> +
> +static ssize_t state_store(struct device *dev, struct device_attribute *attr,
> +			     const char *buf, size_t len)
> +{
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	struct dax_kmem_data *data = dev_get_drvdata(dev);
> +	int online_type;
> +	int rc;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	online_type = dax_kmem_parse_state(buf);
> +	if (online_type < DAX_KMEM_UNPLUGGED)
> +		return online_type;
> +
> +	guard(mutex)(&data->lock);
> +
> +	/* Already in requested state */
> +	if (data->state == online_type)
> +		return len;
> +
> +	if (online_type == DAX_KMEM_UNPLUGGED) {
> +		rc = dax_kmem_do_hotremove(dev_dax, data);
> +		if (rc)
> +			return rc;
> +		data->state = DAX_KMEM_UNPLUGGED;
> +		return len;
> +	}
> +
> +	/* Onlining is only allowed from the unplugged state. */
> +	if (data->state != DAX_KMEM_UNPLUGGED)
> +		return -EBUSY;
> +
> +	/* Re-acquire resources if previously unplugged, otherwise no-op */
> +	rc = dax_kmem_init_resources(dev_dax, data);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
> +	if (rc < 0)
> +		return rc;
> +
> +	data->state = online_type;
> +	return len;
> +}
> +static DEVICE_ATTR_RW(state);
> +
>  static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  {
>  	struct device *dev = &dev_dax->dev;
> @@ -324,6 +456,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	if (rc < 0)
>  		goto err_reg_mgid;
>  	data->mgid = rc;
> +	data->numa_node = numa_node;
> +	data->dev_dax = dev_dax;
> +	data->state = DAX_KMEM_UNPLUGGED;
> +	mutex_init(&data->lock);
>  
>  	dev_set_drvdata(dev, data);
>  
> @@ -336,9 +472,15 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	if (online_type == DAX_ONLINE_DEFAULT)
>  		online_type = mhp_get_default_online_type();
>  
> +	/* Always create blocks for backward compatibility, even if offline */
>  	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
>  	if (rc < 0)
>  		goto err_hotplug;
> +	data->state = online_type;
> +
> +	rc = device_create_file(dev, &dev_attr_state);
> +	if (rc)
> +		dev_warn(dev, "failed to create state sysfs entry\n");
>  
>  	return 0;
>  
> @@ -357,22 +499,62 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  }
>  
>  #ifdef CONFIG_MEMORY_HOTREMOVE
> +/*
> + * Remove the device's added ranges with remove_memory().
> + * Unlike the sysfs unplug path it never offlines and fails if the blocks are
> + * online (-EBUSY), so it is safe from unbind. Failures leak until reboot.
> + *
> + * Returns 0 only if every added range was removed.
> + */
> +static int dax_kmem_remove_ranges(struct dev_dax *dev_dax,
> +				  struct dax_kmem_data *data)
> +{
> +	struct device *dev = &dev_dax->dev;
> +	int i, rc = 0;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct range range;
> +
> +		if (!data->res[i] || dax_kmem_range(dev_dax, i, &range))
> +			continue;
> +		if (remove_memory(range.start, range_len(&range))) {
> +			dev_warn(dev, "mapping%d: %#llx-%#llx stuck online until reboot\n",
> +				 i, range.start, range.end);
> +			rc = -EBUSY;
> +			continue;
> +		}
> +		remove_resource(data->res[i]);
> +		kfree(data->res[i]);
> +		data->res[i] = NULL;
> +	}
> +	return rc;
> +}
> +
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  {
> -	int success;
>  	int node = dev_dax->target_node;
>  	struct device *dev = &dev_dax->dev;
>  	struct dax_kmem_data *data = dev_get_drvdata(dev);
>  
> +	device_remove_file(dev, &dev_attr_state);
>  	/*
> -	 * We have one shot for removing memory, if some memory blocks were not
> -	 * offline prior to calling this function remove_memory() will fail, and
> -	 * there is no way to hotremove this memory until reboot because device
> -	 * unbind will succeed even if we return failure.
> +	 * If UNPLUGGED: state is known clean and reboot can clean up.
> +	 *
> +	 * If ONLINE_*: memory cannot be removed here: offlining during an
> +	 * uninterruptible unbind can deadlock. Leak the resources until reboot.
> +	 *
> +	 * If OFFLINE: blocks are attempted to remove with remove_memory(),
> +	 * which never attempts offlining. A block onlined behind our back
> +	 * fails -EBUSY and is leaked.
>  	 */
> -	success = dax_kmem_do_hotremove(dev_dax, data);
> -	if (success < dev_dax->nr_range) {
> -		dev_err(dev, "Hotplug regions stuck online until reboot\n");
> +	if (dax_kmem_state_is_online(data->state)) {
> +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> +		any_hotremove_failed = true;
> +		return;
> +	} else if (data->state == MMOP_OFFLINE &&
> +		   dax_kmem_remove_ranges(dev_dax, data)) {
> +		any_hotremove_failed = true;
> +		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
>  		return;
>  	}
>  
> @@ -393,6 +575,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  #else
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  {
> +	struct device *dev = &dev_dax->dev;
> +
> +	device_remove_file(dev, &dev_attr_state);
> +
>  	/*
>  	 * Without hotremove purposely leak the request_mem_region() for the
>  	 * device-dax range and return '0' to ->remove() attempts. The removal


