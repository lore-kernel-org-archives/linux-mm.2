Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DF2CF8847
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 12:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0366B000E; Thu, 20 Nov 2025 07:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7F86B0022; Thu, 20 Nov 2025 07:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE376B0023; Thu, 20 Nov 2025 07:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6596B000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:00:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBDAE140885
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:00:18 +0000 (UTC)
X-FDA: 84130842516.21.89D38E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1A704A001C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:00:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1dqDXb5;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763640017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izoi8yQsiqbRVYHfS6EEAgxH+tvjcbRq8E1ezeHjWsM=;
	b=I/v1ngS4Dw6Oi48byJTu68ohFrvL/DeOUvP9D1dwrmJLyG2odglDAfUbDqc2qDNvIs2OBn
	0+ZM04niRfGS6K48qx/X/wObDVCx5DvkwbV+FHlx5Q1eVzaaVJcCMC72iXUERY6o8A6jD2
	iMQYpQApndNF3S5z8pyS0TAHXfvm8l8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763640017; a=rsa-sha256;
	cv=none;
	b=YeKAQ+LYmeP8jRrgpBo+asGImUHoWZdi+3Snw2vTef4LlFcnQcjN3eMuNWyscRV8jQ75mK
	i59qtRZO5k3jdfkNu3mN3wtJlZc0cOclVpr/0307yxDODpfs3J1FOzHv7VEjiQwmvk2Gfg
	O+nCSrVigS/+WIqCLoe15rIXRCws2uQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1dqDXb5;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E3956014A;
	Thu, 20 Nov 2025 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D163FC116B1;
	Thu, 20 Nov 2025 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763640016;
	bh=a891wy2LWb3q2/Qd/lnECCF9sVIO/WgE2s+OoTfoJFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B1dqDXb5vwyekZMQTVzWrNIa3ii435VJA9YGdsMd12UcKhIyrY47VzRMFUQst9HEM
	 lqmNlXlj0DfISnogXhDAcDa76t1saCVD5TtDEV7CdFlQNEirQnRdZxtG6eDAgMUQXp
	 NBhW8+ko2f9Az3rlRQ+U2aMYlEQnnqZiIqakVgcajTN+UndTLeibEzPmhdMJ4XnbMl
	 3PMImHGIJ0+jwJ4PfNkXwkeOTdc/dUwN93UBgJjVrbJYOMBxBgJ7qLPMYDaPIQUhiE
	 UhY2BSOj8zLyCxKseM4ZRlB7pwwbCOsQPhPMRnGGYDWjsyEXUWuu/QolHVt8PmnZFV
	 1U0iwQ8F48AqA==
Date: Thu, 20 Nov 2025 14:00:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
Message-ID: <aR8Cx_K2N8DPlwkP@kernel.org>
References: <20251119114252.oykrczprf3ecd7ak@master>
 <20251119140657.3845818-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119140657.3845818-1-tianyou.li@intel.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A704A001C
X-Stat-Signature: qg87ydptk1b5r1q8nzxqraoarhek7uh3
X-Rspam-User: 
X-HE-Tag: 1763640016-842526
X-HE-Meta: U2FsdGVkX19KumtOa9pKUYM/NGlGN8ntB9kuvfkhLdQsi3v9OmIjAsZmU725lTriF0SQOD5KDRBOe7EIwNAls7xDOtsrRcDG8lEEGtMi7OSd9KsPLDcG/eXc31m1JNcCq2rrGlIXqGHT94s34Lv+vhOkrnspGcojoddUX4wgh3mZNLlXkKdnqNhKQ7x/D9xpe7g/0aqcCzX5r/rjJreKG+PkRP+kQcNYs77ZbXufwl7FPK6++Oq2lqdl4FDQPzd7Eivc/cBoKhWSKi5cEtZ1qwYaDPs0XOGqVnrqeGvp+jwAPUWF/PwlQc9qfLUs8BRryjEwFA5oB/mr48S6epo8ucHKr7A1ACofrNcVdgDqj+0ze1H2zjGvzSoWHKninjgbDPKFFpPUFrcV/gWa4nMv/tms6cG1sXsJrQrAB0MD/L4i4B5sbyPVbgzPS7RfWER66L37YeTkSd4u5I30p5zPhcwuRovNZNrtjBhRaFf4EHtmCHZeKoPOQbVJJNfD6YoGZqwqA6r88t6ViHSNSbCM7UV0467Ej5gUKuMjNRc5y2k4R3sNbNht0EQJ15yMRKOMIP2lUepohCD38srmDXRFksqaHSsy0C5ED4sKgCxf/WPCTiQcfHScrCtKU20qC7vThqUR8RJFYumQaCpWd+FmQKoi83sLX+oVkml1iJzWTbD9a6ZfZC8oWB8bD+aFLj2biyoYn9Bwe1Au+dY8dOeL2Jvs/uWGXpekSMpVVt7ybXH1R0oAyNBXnh1CtFhqu7/jQABEAJ82GA7gE6zf2Tu0YCCt1uAeayrE2E+fvGh7DyR99TJt4jtx9BayQqPeFJcq+FM3e/HgXZNwgsFn4WBftDMp2Aff5r2C/RPPhwQS4Ly81OssON7kw2lak1ICAfa3YHw8qUT6sIPYOWcibn5DEK8xAphxo8J5LOsuJwbCCxG5KIfR3KSMRAi1QAplekl5+sVo9ZncZu0VuWBpzpu
 Lto4S9CI
 hTyjYmux7BMijxNdD//RbXWXzVafS0qpldqk0uaj6ey3KIfhsdI0zYI8fhcJU2RApdXjRzemePP8dsvIebgjDOu/0t2W8/UbncjZz2eGHS1kxZBMmnum/6C7chFiD7NAgT/q2I4JGNIU4Ac98Oj+aIlwOss7KloEENdiKgrPbZBs7aG7P/mhtuLM3XkDyOkr2pbgSP+XnUMU2k8yA8YvOLv6ZhxBta3Xp4Ys2aWyDvelVrMsRUv1dBmnVihWwA8E9IIrNaPm7qwZvFoiAhcST2czrKg8Sopy2N/Ct4mfJLnc4zWWo+SmKZAGB35G8UkY0eEKzFEjxDACztcU8CU4iCS26bfC+yCk+6X9PgkcPMLhrus1v7znMzG/giA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please start a new thread when sending a new version of a patch next time.
And as Wei mentioned, wait a bit for the discussion on vN to settle before
sending vN+1.

On Wed, Nov 19, 2025 at 10:06:57PM +0800, Tianyou Li wrote:
> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
> checking the new zone's pfn range from the beginning to the end, regardless
> the previous state of the old zone. When the zone's pfn range is large, the
> cost of traversing the pfn range to update the zone->contiguous could be
> significant.
> 
> Add fast paths to quickly detect cases where zone is definitely not
> contiguous without scanning the new zone. The cases are: when the new range
> did not overlap with previous range, the contiguous should be false; if the
> new range adjacent with the previous range, just need to check the new
> range; if the new added pages could not fill the hole of previous zone, the
> contiguous should be false.
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Memory Hotplug | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      6s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> [1] Qemu commands to hotplug 512G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 512G
> 
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v6.18-rc2
>     Qemu         : v9.0.0
> 
>     Launch VM    :
>     qemu-system-x86_64 -accel kvm -cpu host \
>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>     -drive file=./seed.img,format=raw,if=virtio \
>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>     -m 2G,slots=10,maxmem=2052472M \
>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>     -nographic -machine q35 \
>     -nic user,hostfwd=tcp::3000-:22
> 
>     Guest kernel auto-onlines newly added memory blocks:
>     echo online > /sys/devices/system/memory/auto_online_blocks
> 
> [3] The time from typing the QEMU commands in [1] to when the output of
>     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>     memory is recognized.
> 
> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>  mm/memory_hotplug.c | 51 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 48 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..aed1827a2778 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -723,6 +723,51 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>  
>  }
>  
> +static bool __meminit check_zone_contiguous_fast(struct zone *zone,
> +			unsigned long start_pfn, unsigned long nr_pages)
> +{
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +
> +	/*
> +	 * Given the moved pfn range's contiguous property is always true,
> +	 * under the conditional of empty zone, the contiguous property should
> +	 * be true.
> +	 */
> +	if (zone_is_empty(zone)) {
> +		zone->contiguous = true;

I don't think it's safe to set zone->contiguous until the end of
move_pfn_range_to_zone(). See commit feee6b298916 ("mm/memory_hotplug:
shrink zones when offlining memory").

check_zone_contiguous_fast() should only check if the zone remains
contiguous after hotplug or it's certainly discontinuous, but should not
set zone->contiguous. It still must be cleared before resizing the zone and
set after the initialization of the memory map.

> +		return true;
> +	}
> +
> +	/*
> +	 * If the moved pfn range does not intersect with the original zone span,
> +	 * the contiguous property is surely false.
> +	 */
> +	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
> +		zone->contiguous = false;
> +		return true;
> +	}
> +
> +	/*
> +	 * If the moved pfn range is adjacent to the original zone span, given
> +	 * the moved pfn range's contiguous property is always true, the zone's
> +	 * contiguous property inherited from the original value.
> +	 */
> +	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
> +		return true;
> +
> +	/*
> +	 * If the original zone's hole larger than the moved pages in the range,
> +	 * the contiguous property is surely false.
> +	 */
> +	if (nr_pages < (zone->spanned_pages - zone->present_pages)) {
> +		zone->contiguous = false;
> +		return true;
> +	}
> +
> +	clear_zone_contiguous(zone);
> +	return false;
> +}
> +
>  #ifdef CONFIG_ZONE_DEVICE
>  static void section_taint_zone_device(unsigned long pfn)
>  {
> @@ -752,8 +797,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  {
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	int nid = pgdat->node_id;
> -
> -	clear_zone_contiguous(zone);
> +	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
>
>  	if (zone_is_empty(zone))
>  		init_currently_empty_zone(zone, start_pfn, nr_pages);
> @@ -783,7 +827,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
>  
> -	set_zone_contiguous(zone);
> +	if (!fast_path)
> +		set_zone_contiguous(zone);
>  }
>  
>  struct auto_movable_stats {
> -- 
> 2.47.1
> 

-- 
Sincerely yours,
Mike.

