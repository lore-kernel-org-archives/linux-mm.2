Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5318BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E62E6B00C0; Thu,  9 Jul 2026 18:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD886B00C1; Thu,  9 Jul 2026 18:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACEB6B00C2; Thu,  9 Jul 2026 18:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEC8D6B00C0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:36:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DF221C1E65
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:36:30 +0000 (UTC)
X-FDA: 84970698540.20.51A195C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 531C540005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:36:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WsH6/JgJ";
	spf=pass (imf17.hostedemail.com: domain of djbw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djbw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYe9dIAh4mnmt/HW6FqRq0Wejif0Bu3nu1Ncr4ybcGI=;
	b=sRqRQCTp3Gvpdmgw/dV5FnOIGQBH7y//CI0bz+u6mETSLb6FqRlkV7/ZfhSyCE2GgQuD0Y
	6muh6LRdNC9P9aICKVqLe+59ahf7O4GgHN85+6vORKi0B9aD78WO0RPp4F+68CfnIzgQXp
	l4CfzIRtUirtfHJ9KOPxA3y/Xlgj1vg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636588;
	b=wXOrYcm4IR0oaLDDb5lWDUpSM0UsLdI/MHF4Rgfc/zrO+q8rlaGCBdGrIrXhneq+jd9/9r
	b1XSbQAkHeEriWR08Q2oy8z80V+WKh+uEBA0zW2kO5vgiM5Jzzdfsq2p28iYswMI99fLw1
	ZnmWxSh7ZpSaAWF5SZQoE1blCDunPBY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WsH6/JgJ";
	spf=pass (imf17.hostedemail.com: domain of djbw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djbw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 799FE44588;
	Thu,  9 Jul 2026 22:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633661F000E9;
	Thu,  9 Jul 2026 22:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636587;
	bh=CYe9dIAh4mnmt/HW6FqRq0Wejif0Bu3nu1Ncr4ybcGI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=WsH6/JgJWwivHk0uSuKJY2FiJJW5z6FzEaS8r2dK8ohRTRcwBRxjbyxR1X1Tz2urd
	 Y9LUmwivh96z4ekgmB77TI9qqLrEvQrCyoc4oLLLNGdDzpeOIS51z/EnLsAkQnsKS0
	 wa1aje3wiBrK3EyMP+uFa+RSgWaoc29n4ilvveb9XQkiV7Bizrp1Zjs5105K8wm07d
	 awijbvOZ3niLb0bK5dgU97nXedzJLlJW8mcZS4g3rJ8Wk8C5uPdWEttFWB7HRJvnmV
	 iASskZIGErAHUdCnNlUDA4ew8dxaV1XpCuxOPHE/L7FWByrcDcHilIhF1BrEjsXpdn
	 KUtu+qYNRQ0sw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 86F83F40068;
	Thu,  9 Jul 2026 18:36:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 09 Jul 2026 18:36:25 -0400
X-ME-Sender: <xms:aSJQahLPSgXukth1wk7VMaCWLPxWmtUMpBjs-ouKqcpw_fzpD49gdA>
    <xme:aSJQakFYD_FVAuk7HCFKWkPpYJD_EvvOLlKqte9ad-cB_jEj9Jebdh_VsqvvjS27P
    UYkfDiVKMcSEclOuFYv370nTJ-QQHqAS_1wzOVyJDsNl-QP0x3dIRg>
X-ME-Received: <xmr:aSJQagKlf7KPlE8lt5rP6KGbGVPfhA459eFq2U1kqoeNI9jbPitggHN6x_E7q9rtw01BzL6zn_dVnHAXhzOCogbIjRNgxgNGu5Q>
X-ME-Proxy-Cause: dmFkZTGGunwBKJk+mjhiAZcusxzfbnVG8WZSyBblDGCO2zhJY/OuGZY3GW73fQoHcp3LPO
    QOMxwPLkjSDk/4DHSAvaRl5lR3AL9JaT1hXosBkusp+2Ft0BXioq5wLDrnE1PZUYOhQpAd
    WK2hK/Rv1VwNw2Dq3WFIxz9WVxAxRV8dT3LZWKoWPkUtK8zwb6tWzLXdn7iwtP4c1Ktb1s
    tE/Sw17GtxGqCVLaTHhlmzmVAU40LW9Dl32/qZDu3Wup6caBaK1uC7eRgZbxtMDd9xOIsV
    Rw1+VOtEAJPwW19K8BXS25kzV8bK2AyhdzLygC8h4s1IgOpb7bFKBFcLv5l8khEyLBOOpk
    3pXHHUfhtpXa5yKRvMeelfguK8M0cmj982GVgpaU4Z6TGqAtcNTpU2h6g9210ulPipT674
    qe9nHXq/4lyCRzjuPSwnd5Qadv4wyrrcObUzEV5AKbfPSBk/vQnUS2yxvg29ZlsVLGGxfr
    qtuVEtZMV7gUEpkPjtWkPwyzypUPaPbI4MBm4PnV0tmmrlRBxBzxGerixrHikb2PrAMUwC
    0YK4TnOwtU3wD6DiXfNvlcY+IzG96cF4bDiD5rNuOQDD2Vk9G94+9p0xDvF74X1u9lJqPN
    d3Aw4stU9J4Qtx1nS4eibNK0qSBEfIzoHtCyJAYaiFbFePsHXzLBPXL3HilA
X-ME-Proxy: <xmx:aSJQag4X5MmLbDxWopcarYE5rkATHj7_6KVQY__1-x4BYuydCroapw>
    <xmx:aSJQapmUgXUwq5MAe3q2Do8BSuk2mlryZ7IG1EQObpchljujq-iVvw>
    <xmx:aSJQalRRWGQyDDHJtRoc1zNdF2i71vhgSiGbluE9seUAFhtWckLGSQ>
    <xmx:aSJQamhb7r6Kr5ewEdhBwor-__3VGlwUopjIwP4yprFC-QwE9W_tvw>
    <xmx:aSJQav3KjzwD8vtt_7XP65AJooHc6-yCfUoOKEvWHlSNZ3byuGxOV3A4>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 18:36:24 -0400 (EDT)
Date: Thu, 09 Jul 2026 15:36:23 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 djbw@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 gourry@gourry.net, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com, 
 Hannes Reinecke <hare@suse.de>
Message-ID: <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
In-Reply-To: <20260630211842.2252800-10-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 531C540005
X-Stat-Signature: zc3hre55xc9mawzosaiifztuiga1e7es
X-HE-Tag: 1783636588-498821
X-HE-Meta: U2FsdGVkX18F3q/sY7aqoKS8TOefvA527UcjwzrfGLWrMfCnk1AxNX2MmVwK39oB07zpZlRM44Dk2Sv5GE+tU1DCfTmx7SXF6Z6tvZLdu5VDB3PN3qQUFtVLRiismOMpJNSs57GV9LFl1LAvGZBN5HIFeJNSaerAHzXb7tpSMq+AtjwAJqhW6prQPstsrJxz5Rf7CBZEl1/5yvCXn2VOiOQulSvDI4X4oEaY+XkhdolcH1KGNgBlB8XEHxZtO6MLuYEoKN/ZJnNWAfzl7rVcQ0I4WnmxBWdeBZ9eams0pm100OZOkxFkzm8YMdoguScipOcIng/MnQbx8WcHnSSlW1oGXi31R/fAGq7U5i0u4Q1yA4YFOqdsuK5JY9Flowe0Zaqxg/voXL+5vkyCSLEUNHf6TquWZ35HiiWCR+S3I5oQlS9HqVMmtkWgMJfv2tnRNDC3mRDx91yA1Ys3nRkcMaMIyfjkKXFqdQl1QPoK4RPmTnv6kjDgXNRPyMw9VYCNm48l8tOxhIhGnVVe+F2cHFnMddy4aW1fyVJjIp0xZjiqMSTTN7KE/DGbybV7688ko3iJyGLRBCSBt8O+DFGN5QOnSM6LiJM3oviNnUPtAZNTp5ZoXUZnd/Gwq5nVL1r7/tsPLmALyVxDxjjJ1iepP5XlwKg0Vk9LjhkxdvIzhyyEpLW0VwT5B1qUhbxxyGBSeaCw0qRMfPROJUVcNVfO9DN6q3wEaO8yCYxjQETx5IyF5UdHQrUa+o500siSNcIIetAJTSbbDMTXqsqbpTjN0ErVmWlFpIC4R1HUs2G9+LZKYxbGnTJED6cbCF71/G6njRqPKi6ikc8buJHNf1pM5GlFFGzPu9WHrGpQSl1bfwSiSGcMIWQV6qfxtZytsdvW1v5RBDzmTGuEqSa17eu6jFHQgI4y6MSaM1aOgIIT0w6FfKvyZWz4Of7w92tsKWWuYMlx/XF6PCTMMtZ9WAO
 8buYC+HA
 yuc1SH2+z6+iwhf48sHz6lrSQJRk8KNwTe45zlM01cK9TJAC2cyo/YswiFko5RQu2DwLriD8rYVYGcfNJ5srapn2oIxQWIT0yqyjghpTfHdEZ7YZrqk+PXOG+UOfMqlJXD030JhvjxqTYOEDhBmKbvYzogWDlu7s3SXJn6Osmzu1zoIsLGStnQovW8K02625ZWRu/1EiRRzzQhyV9ZfqAqs0fidWs3TKxaqxZ2XSU27nZJkqF8753exOmimzP7CV+mYWWcD61YiKvEw5WiiZF7tvMqnGcaYuZNP7iC8JdgnOkzqebfhEswZy54i/tl0k9kvJSfuNGPgSYU7jTyesWLmeaiUYxOQDpJdadokhG3l34r3jLzG9IsRCIuyXgt2tecvyoFA9y7RvPjp2CBj49Z7HnJpt1NRSgfikEt4HFgKCEtT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price wrote:
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

Yeah, it looks like BUG behaviour was there from day 1 when it should
always have been a WARN.

>   An offline dax device memory is removed on unbind as before.
> 
>   If online at unbind, the resources are leaked (as before), but now
>   we prevent deadlock if a memory region is impossible to hotremove.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

A collection of fixups below. The broad strokes look good to me. The
only architecture feedback I have is whether a memory_block device
should grow a sysfs link back to the dev_dax kobject. If only to
indicate "hey, I have an alternate management interface over here for
atomic removal". That can be kicked down the road to a later patch.

With the fixups:

Reviewed-by: Dan Williams <djbw@kernel.org>

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

Date and KernelVersion do not really provide much info, especially when
documenting kernels that never existed. I have dropped them from my ABI
documentation.

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

The new hotness is:

ranges = kmalloc_objs(*ranges, dev_dax->nr_range);

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

Cannot happen with a dev_group attribute. If probe succeeds then drvdata
is present. If probe fails, attribute never appears.

When unplugging, dev_groups are unregistered before drvdata is cleared.

> +
> +	if (data->state == DAX_KMEM_UNPLUGGED)
> +		state_str = "unplugged";
> +	else
> +		state_str = mhp_online_type_to_str(data->state);
> +
> +	return sysfs_emit(buf, "%s\n", state_str ?: "unknown");

So the "unknown" case does not need to be here.

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

Same comment.

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

Unless maybe a driver knows better and wants to preclude the possibility
of legacy per-block hotplug policy firing? I.e. driver asks for dax_kmem
to start in the unplugged mode per my "should DAX_KMEM_UNPLUGGED be a
online_type with a different sentinel".

>  	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
>  	if (rc < 0)
>  		goto err_hotplug;
> +	data->state = online_type;
> +
> +	rc = device_create_file(dev, &dev_attr_state);
> +	if (rc)
> +		dev_warn(dev, "failed to create state sysfs entry\n");

Always prefer statically declared attributes. In this case an attribute
that only appears while the driver is attached would be something like:

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 2cc8749bc871..9be582a33be4 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -270,10 +270,22 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+static DEVICE_ATTR_RW(state);
+
+static struct attribute *dev_dax_attrs[] = {
+        &dev_attr_state.attr,
+        NULL
+};
+
+ATTRIBUTE_GROUPS(dev_dax);
+
 static struct dax_device_driver device_dax_kmem_driver = {
        .probe = dev_dax_kmem_probe,
        .remove = dev_dax_kmem_remove,
        .type = DAXDRV_KMEM_TYPE,
+       .drv = {
+               .dev_groups = &dev_dax_groups,
+       },
 };
 
 static int __init dax_kmem_init(void)



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

I like that the BUG() is avoided, but I think these should stay
dev_err() given the severity.

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

One less cleanup to do if the attribute is registered statically.
Attributes are shutdown prior to this point.

>  	/*
>  	 * Without hotremove purposely leak the request_mem_region() for the
>  	 * device-dax range and return '0' to ->remove() attempts. The removal
> -- 
> 2.53.0-Meta



