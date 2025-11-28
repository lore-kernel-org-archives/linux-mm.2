Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26980CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EADF6B0005; Fri, 28 Nov 2025 07:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2716B002A; Fri, 28 Nov 2025 07:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7EC6B002B; Fri, 28 Nov 2025 07:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA5D6B0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:01:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 264BA160594
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:01:49 +0000 (UTC)
X-FDA: 84159876738.29.3BB8F6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6118440018
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:01:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYqY+8tm;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764331307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uApkqFEVZAU6X3+lQ+UVri128QwhT6+bFURx4uHt/Vs=;
	b=3UiICqdMgxTuyW6mc03UIyo7n2JNkyAoIfhi6EyvKwVUQj1inEB4LZ46QDeKAs0MyohwRz
	Le+Csuo9Y1PbRPAchteJ9hV1RwXlrkNR2A3g8KDaSCf8aC+x2LyXrDzn8zbdxyvi2iLpQ6
	rA4EtpAhBsEBzkTqlE6/ovu72wProHs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYqY+8tm;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764331307; a=rsa-sha256;
	cv=none;
	b=X4YYizWTDZ9ZkwGnPePN2RXR/sxX1NWuqLRjGldeIo3ARndMJINj/LBIN9h0eyPZYyEvP3
	iQCmGrZwxAQoO/CG/GqXeubVbFYXqNR07tRBVzE6Mae8MWImrdlYiEksm+iJ7TXsP/cYVg
	xVbRNbKzGXyoBgHdQjmT5DknzozECr0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B8101601FD;
	Fri, 28 Nov 2025 12:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E91DC4CEF1;
	Fri, 28 Nov 2025 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764331306;
	bh=TE0VHrsyBTtH+8LiAUpYKJbewTMJlLtJgN448eEWoXw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WYqY+8tmPEvuF9UdWtUEpfFGUnHx2AvQNxZj87VmbMKAcBgsgTOb5OgpC7Lgaz00I
	 fSweEVCKB6okC7J54G0mvLufTf0enkLFsxe9P7dzolNgLvn339oTgzi1JOxgJ+Gd+p
	 ZrePF8JmSj3pA5ukr04Mxu3KJ4qjYMBcN23pwMcZKyRYv3bVqNrGEuNToAN1KDpeqB
	 6GJmgXALzX8b6py64a82AKodl5aQzC5OVraYNeZoohxQnrHSBeO7Z0wH99o1kVLsa6
	 iEGs/9J5cT8potZUhWVXrfkYICXWXQqKiG8wMqnkDUTO1HGmKToHOJKGBsE27uXYTO
	 nEE903Q6XCeeA==
Message-ID: <872562fa-5dd7-4cc9-82ab-5b7c09ee8fe3@kernel.org>
Date: Fri, 28 Nov 2025 13:01:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251119114252.oykrczprf3ecd7ak@master>
 <20251119140657.3845818-1-tianyou.li@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119140657.3845818-1-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6118440018
X-Rspamd-Server: rspam02
X-Stat-Signature: umamoic7w3rdpjcxc6cmd8iktrsdxtpg
X-Rspam-User: 
X-HE-Tag: 1764331307-743156
X-HE-Meta: U2FsdGVkX1+RaXoO9f28fIXfR4Zg5PezqVXsbANlw22W5VbXe6CHt7cSbHGPDjvUwAs0GgXmM8KiFPODWUMqGwZF9fJigHKoDQQqQw/FqeebD7ty3gCWNDOZP3Jpq+chwReYHZZ/MP1j/1cqn6JwxpCofAnRCGiJ0Pc8rkTEf5LZ1Pe2h+MjR9ElNhg4uZV4n8HjDGRG9k7XKVNJBR8rJHAACIdP8CSitXw77ipzidSKA8zjRtcouHohaN0ILVgZdlDGXb5+WB27Uyu682lxA/zNIRP/NU2qvbiNoy5AOTD4V8UQ7lnjUgOKE/qL7r0DONi9pWroK+zaF6f/fPrhQsprYd9mNiWAcphnFE4Xp9EFu+Qh+fXQrQD6AzTfoANMcN3WmqJw1n8MwrgXG2wgGkDIWxnTgOgbM76UZZfav0nvytxzpCOA61AJUqJhE7CmTFNTR2jjBdAs2fVTTo6b/JTz4oTgjGNaxqrMBMIj7J+hgJ2yYhT3G5zG5UpCSD2NnsSmRViN0D9EM6SYvWcoYC9YOPvZjd2Gx1KzOlfGId+QuBcmWdrQvGWjtQmYLDpVdLb9GDDt7Two2gUuAtcL+vdmP3UOKZvUiiR38yGv+WFBg7UXX5rMyFMp/oQlw81LyRI1e830S27x3CbgVR5Xf8ieSXWRvE3OyTninuIWoH0cyGzoogHipFEKlArKdRSUk1ZF2hyJnyFlGBXYmMfyNeCGInOszPlSvItBlgqrBt4AE5eR8XTXe0FE9RYqbUZmS4mIr2wncJzSqEuhl6IumPZCIFIyeAqG7SKB4xXAe0AHb3e/qPsQUaMCUjrM8/ghPf82pGkIs7LPSePMd99/2ay+VURUkyEqkVfJec7PnhPXwXHBX7pDZiJpH3AaezKlHY30D4YimWxJ592n9NmQkCIan/wrELZDs0vVpBjsyLh5dS7mMYLrkkHl45vRiDUReTyXJ0ZCSfYJLe17ii+
 VViS/CmS
 hAMG1b/ilMOlkFtvHOpDYuArgRnvZP8ZOJQQAMK0nCfRRNnfXDG04gmlGKhw1hxpj9X8lyONEzZkPPrTM8M0GjDqJmvLgKuUxn+H78rCnjeMOHDd6rUjcQuGspKsONQn3VYV59av+XBTD8OrM6CI0d9ePbI1n9u3+eKU/wozQ38dbwzAAwNGp/89ggYUyJAOgRbwlkBcUADpWTx1/xgxckdHEfn+EsbafSjllrZ8JQqJIaigv3RT2PRG5EGA4PrWR21Pmd0s3BuOmmvkPffZc1TDHSGlUsMWREVu7VMOXhtX70rvdl8LmLdcjsVwwfHpHOk+/gihBwqMqBbeoHllfG3MeVG6M34je3zFSGw6pMODu+KaKlR72MLxtyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/19/25 15:06, Tianyou Li wrote:
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
>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>      qom-set vmem1 requested-size 512G
> 
> [2] Hardware     : Intel Icelake server
>      Guest Kernel : v6.18-rc2
>      Qemu         : v9.0.0
> 
>      Launch VM    :
>      qemu-system-x86_64 -accel kvm -cpu host \
>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>      -drive file=./seed.img,format=raw,if=virtio \
>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>      -m 2G,slots=10,maxmem=2052472M \
>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>      -nographic -machine q35 \
>      -nic user,hostfwd=tcp::3000-:22
> 
>      Guest kernel auto-onlines newly added memory blocks:
>      echo online > /sys/devices/system/memory/auto_online_blocks
> 
> [3] The time from typing the QEMU commands in [1] to when the output of
>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>      memory is recognized.
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
>   mm/memory_hotplug.c | 51 ++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 48 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..aed1827a2778 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -723,6 +723,51 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>   
>   }
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
>   #ifdef CONFIG_ZONE_DEVICE
>   static void section_taint_zone_device(unsigned long pfn)
>   {
> @@ -752,8 +797,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   {
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	int nid = pgdat->node_id;
> -
> -	clear_zone_contiguous(zone);
> +	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
>   
>   	if (zone_is_empty(zone))
>   		init_currently_empty_zone(zone, start_pfn, nr_pages);
> @@ -783,7 +827,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>   			 isolate_pageblock);
>   
> -	set_zone_contiguous(zone);
> +	if (!fast_path)
> +		set_zone_contiguous(zone);
>   }
>   
>   struct auto_movable_stats {

Agreed with Mike that we should keep clearing+resetting the bit.

Also, I don't particularly enjoy the "fast_path" terminology. Probably we
want in the end something high-level like:


bool definetly_contig;

definetly_contig = clear_zone_contiguous_for_growing(zone, start_pfn, nr_pages);

...

set_zone_contiguous(zone, definetly_contig);


We could do something similar on the removal path then, where the zone
will for sure stay contiguous if we are removing the first/last part.


bool definetly_contig;

stays_contiguous = clear_zone_contiguous_for_shrinking(zone, start_pfn, nr_pages);

...

set_zone_contiguous(zone, definetly_contig);



If we can come up for a better name for definetly_contig that would be nice.

-- 
Cheers

David

