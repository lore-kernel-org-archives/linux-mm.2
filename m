Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D84CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0A98E0006; Tue, 18 Nov 2025 00:14:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890458E0002; Tue, 18 Nov 2025 00:14:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FBF8E0006; Tue, 18 Nov 2025 00:14:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5178E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:14:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26A7B13AB1A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:14:02 +0000 (UTC)
X-FDA: 84122561124.29.00102A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5381040003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:14:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAegSsMW;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/Pgcn9FL1eB7/GCJ5V3hukdX/r6JeU4wt+CQwQjxGk=;
	b=kL5N9HF+XbxY3aOsCPz8IHbpsJBnUYnMYfNgA26PHNj3eFPYQmmT5J23bIopAYYJzzIhkj
	wJ35xCr/R1j4l1R5JZfdLF+es82DLniA0xvSZkAQbRkySgzwa7oDWiX06Hl8Aeh2dqMtg8
	uS6MuGJ841JO4xBEm4g+3w5uFM1676I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442840; a=rsa-sha256;
	cv=none;
	b=SCVzRKqU0h4c9OsPOg+Dqk7MqOjx+j5+6lTbcY3+/pCdi4dsaEebKbG79l8tajP7i2vNuN
	17E9S+L+XkKPjEzGO76sc83EIKsIjxCjsZQW0mPFJhgtPrFm9Isg8OEAPuyYCuDl/prXOI
	eLmzpJ+TLkZORKKoJgVli3Llpn4PFVQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAegSsMW;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E760C44691;
	Tue, 18 Nov 2025 05:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46982C19422;
	Tue, 18 Nov 2025 05:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763442838;
	bh=jdRkvdlH3v2L3QcvROvVXorTnpNzH8U4UQVnYOf8xYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sAegSsMWaprMohFyiJoNMpH6ElBw95gK0DWumYUkdCk2F5OXBuwLvMuDYLqMhZu4I
	 WMmvLXuC21mNm02z87SKX+L6ICui6bC73ZzrOFOE/91BCFR4oSU7VFQ78Osh0PRgPf
	 tnIPwIQ3sybdcorfXCLRaYAi5dlT1zDY3OF+MMK+eVHo1g3dRPcWvGi8D4bz5Wj+x6
	 v5OiWDSG3WoKuuXF5mVXhwCcDKffthk6fSNzF1hH7VkEwSTMIfMDsjwf6KRO2sGzuB
	 7W0KpjuMhB3/imcQHxjqORrf9k5Eh5xHr2rXGVtYI/LZUmURoKDaPkcaW7u0tYmlid
	 tLVI1/Vx+V5Xw==
Date: Tue, 18 Nov 2025 07:13:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
Message-ID: <aRwAjSQBby614Itx@kernel.org>
References: <20251117033052.371890-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117033052.371890-1-tianyou.li@intel.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5381040003
X-Stat-Signature: jod5hbb1378borqz1si7734kzbg19ref
X-HE-Tag: 1763442840-564074
X-HE-Meta: U2FsdGVkX19sxJ1yJKq0uofcZbmenU0OTZ1WEk6D09C7lb/SxeFxYEvYQ72NsrbceNxF2DiJOx2da0IWlAc8yNewjvT0FESbT4/on3/Ojr+t4E4KPrmcorYzgR+4BWv81vgK9FeDDBqXa6CnfB3L88VYPv+H6yV2kVTCnGUAo8ptiuAXbhWjZEtpRh7ZBUiKnZhu8Au/H7GD4BjNKghpyD9rc3h7vSvhWVPFVRXMpTCXCQsBh/v6NefCWWFz7s5sQGW5lovJVBqBTRG6AISkhPfZ2kVL6/aBXkZ3+x31EyTjoOnsEXt8PHS/X0aRw8MjfQ5JvjxMSH1DDlHqVKVEEH7m4Hhgs6haWUU45Gheys81+2I4fGlMgmqeTkIcPC2bOWrKF8RPJD5ASjtCw+0MewfMfNohH6UTgfFU72wlcqElgykDw58DEQWW7sIxas6lC843MdODJbf+Sexy6L7IGpnwzHFifsyrrql1ejizr4SpuRHQHitBU9u8Z7EtuwYBm1aO8brqYyfn2JxhvhE+DV5Riyi2h3hX0H1QDNETkXe0ljkGvPhpUYJwwtUiSoOLvSZFZ+ZtwR7Hc8Tyofoajfewb7DuRwAicaXvVrwJjPLffs737ok9Djk6ZFadj8z8Uvdzl+a9N0uC5g6/poyGsdGOABL+E5xvbAVjYHtCSNKdYuEEDT0bBPeIe1OwMLA7w6pOe96Ol+EWNkEeQkxtR/l/AJ0ga9epvF2P7gJgSGiNCVtB0WBSjCTyjVq1EuEvvPzbMBdoJlK8sWTIzEyiovYYjsyVTG+ScpBZJeJOUOYGp0z9g8d+qi5SkICduJ+gQmpux2o2imVGREQLsTQVX4x6f3JVSyzsbWzEbaJskKAgP5oCWEegdVAsRnIvhNzAJvRdwSfdsNWNi8Hml2NZIYlK/1O6XjgxVJvlSCsBWHfqaNWG8zvoAJj5OW3p/yDtGDhA+hfKBv2Z0WiBJZb
 myak0kMR
 Fut8o2zI/jVEjDcGC2cKQdOe0p3GIDGMxd/gva16TsPrqmwqlV+Au2E8gPWmOFyEDS0ztSahz6HplyztAl8tHG8WcEPnMSp9gOhkpj6alr2YJ6gqlrWxeAQI+HqGkN1NSQWW9TeWnMfXXKJB4EbdiCQw467YMAG3zLcDeO797oML1D4MFvd/7DsE+F6+m1OSSxDwELW0ZhzFm4MTkx84CMpH9fo82KzzFzc+SwBWxVtKRoUw3E22CFlpjyAcB/iTYel5JfYgzKnnR2ebYJTolehOiaMPfG3rRVsAPtjKr0ZXd6xE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 11:30:52AM +0800, Tianyou Li wrote:
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
> | Memory Hotplug | 256G |      10s      |      3s      |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      8s      |       76%      |
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
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>  mm/internal.h       |  3 +++
>  mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
>  mm/mm_init.c        | 31 ++++++++++++++++++++++-------
>  3 files changed, 74 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..734caae6873c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
>  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>  			   unsigned long nr_pages);
>  
> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
> +			   unsigned long nr_pages);
> +
>  static inline void clear_zone_contiguous(struct zone *zone)
>  {
>  	zone->contiguous = false;
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..96c003271b8e 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>  
>  }
>  
> +static void __meminit update_zone_contiguous(struct zone *zone,
> +			bool old_contiguous, unsigned long old_start_pfn,
> +			unsigned long old_nr_pages, unsigned long old_absent_pages,
> +			unsigned long new_start_pfn, unsigned long new_nr_pages)
> +{
> +	unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
> +	unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
> +	unsigned long new_filled_pages = 0;
> +
> +	/*
> +	 * If the moved pfn range does not intersect with the old zone span,
> +	 * the contiguous property is surely false.
> +	 */
> +	if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
> +		return;
> +
> +	/*
> +	 * If the moved pfn range is adjacent to the old zone span,
> +	 * check the range to the left or to the right
> +	 */
> +	if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
> +		zone->contiguous = old_contiguous &&
> +			check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
> +		return;

The check for adjacency of the new range to the zone can be moved to the
beginning of move_pfn_range_to_zone() and it will already optimize the
common case when we hotplug memory to a contiguous zone.

> +	}
> +
> +	/*
> +	 * If old zone's hole larger than the new filled pages, the contiguous
> +	 * property is surely false.
> +	 */
> +	new_filled_pages = new_end_pfn - old_start_pfn;
> +	if (new_start_pfn > old_start_pfn)
> +		new_filled_pages -= new_start_pfn - old_start_pfn;
> +	if (new_end_pfn > old_end_pfn)
> +		new_filled_pages -= new_end_pfn - old_end_pfn;
> +	if (new_filled_pages < old_absent_pages)
> +		return;

Let's just check that we don't add enough pages to cover the hole

	if (nr_new_pages < old_absent_pages)
		return;

and if we do go to the slow path and walk the pageblocks.

> +
> +	set_zone_contiguous(zone);
> +}
> +

-- 
Sincerely yours,
Mike.

