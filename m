Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1083D3E791
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 05:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27A56B0005; Thu, 11 Dec 2025 00:07:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD83D6B0007; Thu, 11 Dec 2025 00:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC76A6B0008; Thu, 11 Dec 2025 00:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC10D6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:07:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37FD95B048
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:07:54 +0000 (UTC)
X-FDA: 84206008068.27.73F47A8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9795A000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:07:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iX5bt+hQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hNw/kktA";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kUOpH0Z8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9QyR5IDC;
	spf=pass (imf25.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765429672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7DNDRFGzVCcVWE+kBBV+oyh/JbLf2abSR0tz8270oM=;
	b=vOGzNr2nmqKLd8oFCEk1iNUWRk/KLssl4Yi5DXmXsrqbCVtu+To+6Gon0uHdZxoMqskzIm
	6MAIf30SgH39mseUhD+bEhOxmu3rce952RNgyE6r/bjucAxCzAXuhB6GjvkeegREeZPOoa
	HXCBQS8GcFuX2qDnHZxCGYB+YItlL2Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iX5bt+hQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hNw/kktA";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kUOpH0Z8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9QyR5IDC;
	spf=pass (imf25.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765429672; a=rsa-sha256;
	cv=none;
	b=uResfQso4qSch4jtuqf8mbjbbjbPqpP9k4+9vVAnEKyvqx1xLrO8d1asLvfslb4QdSCB6A
	pMNhvzdKpOXlIERZDHJ7rylbWRIZ8vdkxTPq1AjKe0EqRLq1pQZEcQeVI6UAK3Q6VzjtLW
	A0HATHhKkEmsUeYvp0bHGG5uFgWkngc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0589633711;
	Thu, 11 Dec 2025 05:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765429669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7DNDRFGzVCcVWE+kBBV+oyh/JbLf2abSR0tz8270oM=;
	b=iX5bt+hQDAJC5S4LfiUX18S3l2QkD8B2WemtgtdEYM9IQHDTG2lxrcGmuYJiB+KLC1eP2b
	040ugC63kRy1PHAgrCjB9qn7rDwmDvphdeGkO+0r6IQnf7rtayNGHiARcVzNFFM89BEA1g
	vr4pdZBWl9H/EtRbjIN7kXX67b9mBak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765429669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7DNDRFGzVCcVWE+kBBV+oyh/JbLf2abSR0tz8270oM=;
	b=hNw/kktAhwG/ePOyE+JI2y/i79asQr5nYn/RykAJ4vgjyikRbz97x1Lwlu9ODm4ZsD/eK5
	WQjodRnVCUWLKdDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765429668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7DNDRFGzVCcVWE+kBBV+oyh/JbLf2abSR0tz8270oM=;
	b=kUOpH0Z8JCjmGDRYsM0c7GhyP/n4CBGGZAdWg/UuoN49qP5bqiYF3vo6MWY8dE40HFN1m1
	/fxZdzOsodoGcGR3P0wKn9Qzgre71HxOmNObNKmxfeT1VtVlkKuOGJyQEjG7w7SYfRaDVL
	12FVNZQWbHQzfrkwln8fr8CVLUALGPU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765429668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7DNDRFGzVCcVWE+kBBV+oyh/JbLf2abSR0tz8270oM=;
	b=9QyR5IDCtfCYs79YZMeDUXv8DTfQ7i5dcV4CBhRUCQ+FMvRgxEnpmlANSoWkFY7uW30V3Q
	QH8a86/NE9BFO8Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B3463EA63;
	Thu, 11 Dec 2025 05:07:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4C5EB6NROmmxFQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 11 Dec 2025 05:07:47 +0000
Date: Thu, 11 Dec 2025 06:07:45 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
Message-ID: <aTpRoUt0WvEULeKE@localhost.localdomain>
References: <20251208152544.1150732-1-tianyou.li@intel.com>
 <20251208152544.1150732-2-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208152544.1150732-2-tianyou.li@intel.com>
X-Rspamd-Action: no action
X-Stat-Signature: b4bz7fk7zxe7wxrx1rbzydxrsqej7zn5
X-Rspamd-Queue-Id: D9795A000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765429671-988832
X-HE-Meta: U2FsdGVkX1+7JP1lwTcZ+cETBDZnqTKLRAIToxIyTGBo/RzKbYClj4JFCvKgYXcikSmAb1/Ru68Mi6j9H3MtumUeXslKe3edrfDDoDMPu+LvOosoMHpj042wMU+/p6qJ8lLyrioLRI17r/ykv3dRKOjOgc06mfNF4lCCtNgjdumRGU5PFO9AjYZJlAfCB9moQ6CRD1hCr/aNMgKAQM4jMWWjNq25Y7ZKsRJzzQh/H5xqu9+92YpmRBB7SIIi1lyK4ACaMyiQE5VqieL7uL8Q43VuU81dO2S7j4VFEJkXoHcjCU55sFpzWfbPRH78wUcuRwub158CTn7wJx0MwnCjHqbZKFadj7xybAWA2cIhGl1p0LzB3wz57ENULEEjcL0XDbYDLTxuCOJq06Hue54quqR0Xy4c3tBzeycISHLoMuJJ9NrtnCfWZIiGNi+dtYFxU1VrTAo339BKbFoIG1DOnhW9cpF0Cwq6365nf6gMUTp/6aAcpZ+X9wawmZP8jK05A3PkLr7i477zpeZJ0CkcPi/vH13HsYdX5c/aJA26y3Fci2kmuQJL2BEP3+gL2dbikQdTSd9hocgy8wcjPUHkN/9W8jFaQy0GCP6NZayZR8Sa5h34n8+Na6j7WAVw1W+JwmPINjlWhqmb4tfx/PSI0AI4lIRh6C5aTJxr+alATnAHE1WicS4A9FEU5JWbRTZISAn9/a2x35FXa8utUuwAXi2UuR6Iva7kghERGAWBCyBNoMMvzuUGA9w+8A5yAyBcNzIBarFCcOiIg8bUgGRUmBFsKLGh3tNtPN6yapAFJpWIcysG3+cAyK47sKNDcAT0jKofiUINYU0vVrdYA92EzYHr1e3z5sZTMQX2LNm+Ix4Fg2ZCtYLssvN1/W6ysDwwY2nG9/jQovQA5Dew5zoJlAxr6+kHPLwg1dPZhP4K201tXacBUA7WEzpiQPrvrdOTzoMfEj2/Bg0+vi1stxj
 4XH+zUJk
 JmKTM+6vZJORloU5NCJnikhbWW2ornZ3hfDIVKlowGRB+yVRQedULgd3t7RlZ0a5bcR2ovxHaZaC7AtDdZC3ktSIb25ioeWfsLkJFEvpIjSLdepf+5isNT2KKt+xWCgMgDRr3VDjtnc1VXOZTUcMh740VqBUb3Z/ZJryNAhDkb7QiasLTXew7LrmwJvFuNne7dPINTtTJ4nCUF7MKSG9mv5rNru7/gE2JSMc7uni75Oci2Va0pMOROGfE96YO+oIWd18I6MY2RxDMugK+IgdiGYpNmwxVoR2XVv+Zcc5OLDzWL9PeAQMpN9vp0IqM/ZhNj5aesD/qUjZAdjmkHwIEdBncvDZPhUxyLzKmSI3Dg73YswQ6iBgmaxFx9MqnBek3kzPM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 11:25:43PM +0800, Tianyou Li wrote:
> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
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
> | Plug Memory    | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      6s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      34s      |      6s      |       82%      |
> +----------------+------+---------------+--------------+----------------+
> 
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 256G/512G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
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

Overall this looks good to me, thanks Tianyou Li for working on this.
Just some minor comments below:

> ---
>  mm/internal.h       |  8 +++++-
>  mm/memory_hotplug.c | 64 ++++++++++++++++++++++++++++++++++++++++++---
>  mm/mm_init.c        | 13 +++++++--
>  3 files changed, 79 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..1b5bba6526d4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -730,7 +730,13 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>  }
>  
> -void set_zone_contiguous(struct zone *zone);
> +enum zone_contig_state {
> +	ZONE_CONTIG_YES,
> +	ZONE_CONTIG_NO,
> +	ZONE_CONTIG_MAYBE,
> +};
> +
> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state state);
>  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>  			   unsigned long nr_pages);
>  
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..d711f6e2c87f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -544,6 +544,28 @@ static void update_pgdat_span(struct pglist_data *pgdat)
>  	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>  }
>  
> +static enum zone_contig_state __meminit zone_contig_state_after_shrinking(
> +		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)

Why do we need the __meminit? These functions are only used from memory-hotplug
code so we should not need it?

> +{
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +
> +	/*
> +	 * If the removed pfn range inside the original zone span, the contiguous
> +	 * property is surely false.
> +	 */
> +	if (start_pfn > zone->zone_start_pfn && end_pfn < zone_end_pfn(zone))
> +		return ZONE_CONTIG_NO;
> +
> +	/* If the removed pfn range is at the beginning or end of the
> +	 * original zone span, the contiguous property is preserved when
> +	 * the original zone is contiguous.
> +	 */
> +	if (start_pfn == zone->zone_start_pfn || end_pfn == zone_end_pfn(zone))
> +		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_MAYBE;
> +
> +	return ZONE_CONTIG_MAYBE;
> +}
> +
>  void remove_pfn_range_from_zone(struct zone *zone,
>  				      unsigned long start_pfn,
>  				      unsigned long nr_pages)
> @@ -551,6 +573,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>  	const unsigned long end_pfn = start_pfn + nr_pages;
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	unsigned long pfn, cur_nr_pages;
> +	enum zone_contig_state contiguous_state = ZONE_CONTIG_MAYBE;

I think that new_contiguous_state is clearer, but I do not have a strong
opinion here.

>  	/* Poison struct pages because they are now uninitialized again. */
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
> @@ -571,12 +594,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>  	if (zone_is_zone_device(zone))
>  		return;
>  
> +	contiguous_state = zone_contig_state_after_shrinking(zone, start_pfn, nr_pages);
>  	clear_zone_contiguous(zone);
>  
>  	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>  	update_pgdat_span(pgdat);
>  
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, contiguous_state);
>  }
>  
...
> @@ -752,7 +809,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  {
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	int nid = pgdat->node_id;
> -
> +	const enum zone_contig_state contiguous_state =
> +		zone_contig_state_after_growing(zone, start_pfn, nr_pages);

Same comment from remove_pfn_range_from_zone.

>  	clear_zone_contiguous(zone);
>  
>  	if (zone_is_empty(zone))
> @@ -783,7 +841,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
>  
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, contiguous_state);
>  }
>  
>  struct auto_movable_stats {
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7712d887b696..e296bd9fac9e 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2263,11 +2263,19 @@ void __init init_cma_pageblock(struct page *page)
>  }
>  #endif
>  
> -void set_zone_contiguous(struct zone *zone)
> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state state)
>  {
>  	unsigned long block_start_pfn = zone->zone_start_pfn;
>  	unsigned long block_end_pfn;
>  
> +	if (state == ZONE_CONTIG_YES) {
> +		zone->contiguous = true;
> +		return;
> +	}
> +
> +	if (state == ZONE_CONTIG_NO)
> +		return;
> +
>  	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>  	for (; block_start_pfn < zone_end_pfn(zone);
>  			block_start_pfn = block_end_pfn,
> @@ -2283,6 +2291,7 @@ void set_zone_contiguous(struct zone *zone)
>  
>  	/* We confirm that there is no hole */
>  	zone->contiguous = true;
> +

Not needed?

>  }
 

-- 
Oscar Salvador
SUSE Labs

