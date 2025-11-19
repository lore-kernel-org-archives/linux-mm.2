Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE56CF34A1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861956B0062; Wed, 19 Nov 2025 07:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812096B00AB; Wed, 19 Nov 2025 07:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7278A6B00AF; Wed, 19 Nov 2025 07:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0F56B00AB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:44:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 022B113A5DE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:44:22 +0000 (UTC)
X-FDA: 84127324806.01.323EDB4
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3EC71A0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:44:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OzRaAt92;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763556261; a=rsa-sha256;
	cv=none;
	b=SgxbcWqaonpwT4R/CKZXuuUUJ9WAEIqar8ljxruf8k5E8CrprQ88DfiH4olQV8/TXovMqJ
	QarocLWEBSHlkn+H5FSt/Z2+i/Yo1BoVnUN06FuiMcElmXVNR4iir3UF/p+bq4mGlj0DYj
	nHDcF00Ua3yNZXJZCR/tDIq6CFvPG4E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OzRaAt92;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763556261;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Er5hZIqRlPa0ixIsJDMLxf9OqXoeqQqYf2QlqpDUVlY=;
	b=pjsEq7LZVe7L5dmF5OKT2IcCOX62xyYd1RBl/B+rC2RB+3YtUvG9tS6alkmEY6myL6y/yH
	gOea7k25xfQU/VewRl5QZzkrOTrdSoA4yrYOQUFWLAdMMVE0SoVbEb7ZmCu0ktSl+d1h23
	/knFSvg0T1FRolR6E7nGgUJoN9g2NCo=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b73875aa527so563988966b.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763556259; x=1764161059; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er5hZIqRlPa0ixIsJDMLxf9OqXoeqQqYf2QlqpDUVlY=;
        b=OzRaAt92YzQk74F5ONIf5/P0BpNbgE1oJzu8ZfG06DRi6VtvT6LP1pLKYraOKCDkOY
         8TJf0BmFPpYNEr+LzRTEhuDxRWBEMN+vpG18P8j+QfokmbHGgjng+RJ3WmnobyMjag46
         3EHFpYfQBsNZCQ7nf/jPOIVZ7C9oTTuGGh7FVK95RzBEP7Sk7sa1han9rmcmwqI2vLf4
         E6DahK9hkojfySvXL8aZvHwSMPmdpgOpRrLOov3to9+TGL9K5vwcJgJ3rRBuJj2J4HgS
         t0Lm4APAC5mdm26k6lE29t34N3gadzGIIsU24NWyK3IEmVJfJHNfZxHsw9R4PBtuwh5n
         EX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763556259; x=1764161059;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Er5hZIqRlPa0ixIsJDMLxf9OqXoeqQqYf2QlqpDUVlY=;
        b=fKQ6dm0fr4WHOlBEd3q5E2wrGXrv1CI3qP5E5OkQXV/STEZHixC/Pb4qDi5PGwcc7G
         Ryb7kHAtM2nLNb0+k9XvHn7q2c9MTEsOEf6++iCxrhKW/pqI0gF3L4FdcsGR8y5hWm7O
         NBYebG5d+1k1apDh8RddXt964dyT4OqE5OHrTXcdOT1g8TNaZ7MG2TYHh6g93KRWRud/
         lUDJfGFPlv0eUU6USzHylKweDRLMadYQd3WEdkC/Iu/EQbb2n6lVlDlQ9qlWBYuLiYX3
         r8ujrrVmc3k6+oZQJi4FLnHI2ziUNSE+jYgpb1LAbbsrK4XNrnaQtaW8YGWWegA84bDa
         KiEw==
X-Forwarded-Encrypted: i=1; AJvYcCVPM6f9YRHJcdtH82L5jqtgSu9Hg91OB7JG6IvWuh9XPwwe9e+DV3vxhRdjZQR2t7o/4G65oimMXg==@kvack.org
X-Gm-Message-State: AOJu0YzTouZgytMVjWa8Xn1qaXIz9TjnfxUof+8o2DcADJRhAdrAU8lg
	gbgNcGrDUagd6Fy8sueiYUQFqSfttqXAIzPKzyaQbUPDv3Ik8c9asxPzV+XUTA==
X-Gm-Gg: ASbGncsyvcwTUFwmbBQ/9n3coHXbZOW9bqEoeu7KPKtyLfXlg6aHz5hgGRPRdGV7nD0
	AkBuIr/m9NpPCEESp0o/Zb39Qn8CCSrVtbHDz+QvDnW/Adb5bECrHsE99cOInREmWJ7RMr78J8F
	VvQPZLHBgX309PTXFlzdmLGu4QdIwcatZ8Wqm49H2PFDoS+AdFTOd397l0EBHWLwY12hDsUi+G5
	9m6brYM22au6NTBYa5jLVSskxJwbVHPAXxx6UFPPV/1fTwPsQJPLfbwsek3n0KUv87psQy0UPBJ
	pIDyhOWp2F7XsFXFwOYTFIN0j9d057iE5vNXhfAT5lx36tKZnUltUOZVWRWLty5SbNS2HfKsP+c
	u84CLZ9mPwCWgdO7XuMr1r2e1NIop40wE8bAs2spGcOzvpuaUngXIU/i7lzGE8AtCRLMwO8sVXY
	Hd6++wrGgESGw6RQ==
X-Google-Smtp-Source: AGHT+IFd8hKmc2jM3KNaePrLrpMcefLHG/PSsZriTY72DGBaBlUfEaL+X8nYTtEzcYp1HUuhkqMWGw==
X-Received: by 2002:a17:907:97d4:b0:b71:5079:9702 with SMTP id a640c23a62f3a-b736780c27fmr1940894966b.21.1763556259287;
        Wed, 19 Nov 2025 04:44:19 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fd809fasm1613908866b.45.2025.11.19.04.44.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 04:44:18 -0800 (PST)
Date: Wed, 19 Nov 2025 12:44:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Li, Tianyou" <tianyou.li@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
Message-ID: <20251119124418.nhzgjweamqb6vjig@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <aRwAjSQBby614Itx@kernel.org>
 <20251119040718.2735199-1-tianyou.li@intel.com>
 <20251119114252.oykrczprf3ecd7ak@master>
 <ca02b44b-fc3e-4626-a331-d0348ad5e9f0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca02b44b-fc3e-4626-a331-d0348ad5e9f0@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: E3EC71A0005
X-Rspamd-Server: rspam07
X-Stat-Signature: aebhmjdhfa7he1pwx99zo5r9678w5zg7
X-Rspam-User: 
X-HE-Tag: 1763556260-22779
X-HE-Meta: U2FsdGVkX18j/I/DRP7r6EDEeZ2q53ogPIveadsOG5LFjTGFH/FRRQT+0EpSY8kqzPtrxlVrCeOSTD+fiBIr37RyYImgA4AAHaMkQoRph+pFtZ+pj1W7qcYJEcjkRD7BYjpkGPFh7Wj7pJEfyiZ3z2yJI0TRRW94PeL0QcbEkzhw99rwsWh6ScYOoyjnq7AnQtNL+uYxa7RJdvEEg69LaVXe7s1mdC9MyeHJPS3mwLVBSTyRxJIchvyywqdolvfwOWRgIA3rTLf1Juw2y5bEiC0J2I9vEUQr/BWFpPJ8HwhPUT2VqBUZIJdLPM5BTiGjy8qxgf1cqyu6QLEFx4zAMMGAbEUs8iVbarGC9jU3mTs08w0Y1WG8CTU8bIZQPeMcG4He+wMbAcsL6BSCCA7ac4szWtl7uQ8mgLilecdp+bch/h52PeZ2Lm5RYYoxEeKS5xe3fwy1kEyiF5rJatbRSQ3pCqAm8zPzFSEJfkQMH0dizg9r+HiRKMwxAMvaaTiMX9O3EIy0f2bMj8L1JoemU3XDaTrf4U8/zyALVX4iENP1oicUAsG97MbVInqbcyqPe11qs3Hzpqn8AcH2xnmry2ivzWpGiUXeavmvSTE+lUac67OMXXz+BCwgAsbU/4nQGm7ucr9gB0kY6fGD3yTskxCsy2cN9e/cO3l4XdhuTs/QrUtM9COExQfg2n3svRgY2TqEiH9YOrd8FJ+9Pi7TMH1YYVwR+XCvatmRnw/uhuOG2JYTGe+p64xo6mfjEyJ4fAJjsz1VFSCVllDnIkaAN5bjSUs23Jlwc0p97I+3c8J10vDfYDyMAUMNgEe3+ET6Xy7bBI5IxU0BPJY1fI67hUvsYmS4L/bmWuvJ1pzb2wQhH3MBKntbctH32NRTsdwIQS7pLJ4H8YN6PLrNQFZdzWSDqAStu7/ZV6wdfMq2XNaaDeFPj2Fdp5yaWHoAiN/LNg/mTwJJvyD/m0dndO6
 q46XTtsX
 8t2UWGk6EpNT1YHzdkAOTP/C24nJlV3H5qc+9SlZj1+ueDq2wGZndC7MBXxwsENRBDyOrhIRQbN4wSUIbAnNt6DRTFcC40yfcr2e9QhgIkNk4CAyEMfV4NAaHc6/8XLi2cJON+qPDmO95/FBuvjpODeacRO/HlOghXRuSeKcBDfkRGHy+zANfsJI7/0Ed2F1FjglsmqIUYj27wF41hLAD3l7bedgv3ijjY7Ok7XhLzKkZ1msr3fMFRJ8bQ0xDwWFXu7gCqc6nbT8bXhvjw3QgNR4C9WERrl1KBFDQ4T6XIKoGtomgYf9LYx0//HKOL6tnp5rna5fIor6Gdc0Gx4tiNdOMH5y2fObcHGUbkVzhCIHlf1Ixj+WKcoJ7y4uleVIpqochgPxf/Iqckz2h8Jma1DG462880sdnX7QnOeIMGihS1KOk74sZS6Z6c18qBtyhkR2bJJQ0ttGJlxLZlTGlj+KFfN2OGu8GzNRHSDk9Ubofvqw9aMo9rnidyvZahQjmjkzZ0y7Fk66oDlCtz4hXmL3b44jhARHxV27kBgG1LmSEAucPbVH3jr6o7WFQ9n8cHHlYGiigZ166jzUbN1KnH9Zy3H74TAA7oM8ZINHtYcKU1T4DMW3nhrkfd9EoJqSqEUx8OQrnhdXWn/UL39dLtJk+m0KaMtGom8+xn8spNSiO/QBHGXLAWKuvVH1PJsPlsTw3RsTWnb0lBDxfmUHxVszErk+HckmnIY6n7vSrSWO6dmOw+uL3+fSlhEzhtK9Ou96v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 08:41:11PM +0800, Li, Tianyou wrote:
>
>On 11/19/2025 7:42 PM, Wei Yang wrote:
>> On Wed, Nov 19, 2025 at 12:07:18PM +0800, Tianyou Li wrote:
>> > When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
>> > checking the new zone's pfn range from the beginning to the end, regardless
>> > the previous state of the old zone. When the zone's pfn range is large, the
>> > cost of traversing the pfn range to update the zone->contiguous could be
>> > significant.
>> > 
>> > Add fast paths to quickly detect cases where zone is definitely not
>> > contiguous without scanning the new zone. The cases are: when the new range
>> > did not overlap with previous range, the contiguous should be false; if the
>> > new range adjacent with the previous range, just need to check the new
>> > range; if the new added pages could not fill the hole of previous zone, the
>> > contiguous should be false.
>> > 
>> > The following test cases of memory hotplug for a VM [1], tested in the
>> > environment [2], show that this optimization can significantly reduce the
>> > memory hotplug time [3].
>> > 
>> > +----------------+------+---------------+--------------+----------------+
>> > |                | Size | Time (before) | Time (after) | Time Reduction |
>> > |                +------+---------------+--------------+----------------+
>> > | Memory Hotplug | 256G |      10s      |      2s      |       80%      |
>> > |                +------+---------------+--------------+----------------+
>> > |                | 512G |      33s      |      6s      |       81%      |
>> > +----------------+------+---------------+--------------+----------------+
>> > 
>> Nice
>
>
>Thanks for your time to review.
>
>
>> > [1] Qemu commands to hotplug 512G memory for a VM:
>> >     object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>> >     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>> >     qom-set vmem1 requested-size 512G
>> > 
>> > [2] Hardware     : Intel Icelake server
>> >     Guest Kernel : v6.18-rc2
>> >     Qemu         : v9.0.0
>> > 
>> >     Launch VM    :
>> >     qemu-system-x86_64 -accel kvm -cpu host \
>> >     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>> >     -drive file=./seed.img,format=raw,if=virtio \
>> >     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>> >     -m 2G,slots=10,maxmem=2052472M \
>> >     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>> >     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>> >     -nographic -machine q35 \
>> >     -nic user,hostfwd=tcp::3000-:22
>> > 
>> >     Guest kernel auto-onlines newly added memory blocks:
>> >     echo online > /sys/devices/system/memory/auto_online_blocks
>> > 
>> > [3] The time from typing the QEMU commands in [1] to when the output of
>> >     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>> >     memory is recognized.
>> > 
>> > Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>> > Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>> > Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>> > Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>> > Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>> > Reviewed-by: Pan Deng <pan.deng@intel.com>
>> > Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> > Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>> > Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> > ---
>> > mm/memory_hotplug.c | 57 ++++++++++++++++++++++++++++++++++++++++++---
>> > 1 file changed, 54 insertions(+), 3 deletions(-)
>> > 
>> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> > index 0be83039c3b5..8f126f20ca47 100644
>> > --- a/mm/memory_hotplug.c
>> > +++ b/mm/memory_hotplug.c
>> > @@ -723,6 +723,57 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>> > 
>> > }
>> > 
>> > +static bool __meminit check_zone_contiguous_fast(struct zone *zone,
>> > +			unsigned long start_pfn, unsigned long nr_pages)
>> > +{
>> > +	const unsigned long end_pfn = start_pfn + nr_pages;
>> > +	unsigned long nr_filled_pages;
>> > +
>> > +	/*
>> > +	 * Given the moved pfn range's contiguous property is always true,
>> > +	 * under the conditional of empty zone, the contiguous property should
>> > +	 * be true.
>> > +	 */
>> > +	if (zone_is_empty(zone)) {
>> > +		zone->contiguous = true;
>> > +		return true;
>> > +	}
>> > +
>> > +	/*
>> > +	 * If the moved pfn range does not intersect with the original zone span,
>> > +	 * the contiguous property is surely false.
>> > +	 */
>> > +	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
>> > +		zone->contiguous = false;
>> > +		return true;
>> > +	}
>> > +
>> > +	/*
>> > +	 * If the moved pfn range is adjacent to the original zone span, given
>> > +	 * the moved pfn range's contiguous property is always true, the zone's
>> > +	 * contiguous property inherited from the original value.
>> > +	 */
>> > +	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
>> > +		return true;
>> > +
>> > +	/*
>> > +	 * If the original zone's hole larger than the new filled pages, the
>> > +	 * contiguous property is surely false.
>> > +	 */
>> > +	nr_filled_pages = end_pfn - zone->zone_start_pfn;
>> > +	if (start_pfn > zone->zone_start_pfn)
>> > +		nr_filled_pages -= start_pfn - zone->zone_start_pfn;
>> > +	if (end_pfn > zone_end_pfn(zone))
>> > +		nr_filled_pages -= end_pfn - zone_end_pfn(zone);
>> > +	if (nr_filled_pages < (zone->spanned_pages - zone->present_pages)) {
>> > +		zone->contiguous = false;
>> > +		return true;
>> > +	}
>> > +
>> Mike's suggestion is easier for me to understand :-)
>
>
>OK :-), with the clear votes now, I will change it in patch v3 real quick.
>Thanks.
>

Thanks for your effort.

While maybe wait a little for v3, let's see other's comment on v2 :-)

-- 
Wei Yang
Help you, Help me

