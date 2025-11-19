Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1902CF31AD
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 11:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C5B6B00AB; Wed, 19 Nov 2025 06:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533C86B00AE; Wed, 19 Nov 2025 06:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449856B00AF; Wed, 19 Nov 2025 06:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F43B6B00AB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:42:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9D9014049F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:42:57 +0000 (UTC)
X-FDA: 84127169994.27.C032612
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id E8496C0003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:42:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ngAFrctV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763552576; a=rsa-sha256;
	cv=none;
	b=UIx6JuR2KZw1Rc++HQ4liK7kn7pig+Jsj4J+KEMUvO0Fz7T1209OI/qVacuEQwog1W9ylA
	R4pP32z9O+En2XNZeyg9iqQ0TYXBmlOyHRAJ1nj4G0wcuUnfl6ArkpObhyGNLAOKo7OqIF
	ehAFdW6pM+MGCP4eU02QNIAysONk+V4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ngAFrctV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763552576;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+8CdVW7qRHuadRsFNXcHiteFeYMuyKZGGt4Q4lo3EA=;
	b=lheTjRdQQiVdl2l4jnCu6aO4eftsPabp4sfPf5MddpOUO6Qx7wRCcip+eraswKl0gEAo9C
	J1FSGlV8e8z0LNExBxPOMtP0ytdxamJVBYjTToItv2uJniBKwP6daY1wV8ueWgboVMZU7k
	xwxnPaHTpGX092QymBTWQkUFtlmlQi8=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so1699692a12.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763552574; x=1764157374; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+8CdVW7qRHuadRsFNXcHiteFeYMuyKZGGt4Q4lo3EA=;
        b=ngAFrctV1oCMoZjbnY3NZaCcMaXaSMQ72aLFdhpjEKyQeTAy4iQC82J42hMTe2w56N
         JkXHk0VTtS4qhV/lsGIgw/K+jDXZSVigRDDf/ISvz9ApQHFNU6CPuZylrmEVSj3uEKoe
         iU9C068EkdkKHBZMl2olQWDHPkt420tELdRcJ/bY1pQCEivP8dp8t+KKi1q5uPzVCGtp
         9S6yZ/yf8mi54dWgqiIRmkf3PuFcHDFD2rqpLk9YU0z67pbUaf8fH096UFIxO72ezNhU
         cqVziDlqxvrvmmZ7s/CJqPDqZx67CeVPUIcL3FMrkl0+d8vYhH3NqA/ngb6BDhpE9fGq
         6uqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763552574; x=1764157374;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p+8CdVW7qRHuadRsFNXcHiteFeYMuyKZGGt4Q4lo3EA=;
        b=XOHEaVnOq4jKGyT8s0JUVjujnZxFc9/2zJgshxrdHtr7rZVC7z9OuX+WnF+mzu37+J
         oleKxSktT+BbeiimyyPJUoa4vi6gag/jgQXT5ijnqaRTlptjKSKnlaY6F2/0Rl8H4xxD
         YUtcc2dXhBH1DRpM7061BBLjwSTN7FfSV4CbK1vRzwfF4u6cIVZLcG5/gDecE6T7MOan
         aGQg5IkaF9njvvOwulS0MJnh1z8tUv/yisK5l9t6Mhq9/xjtdTHawWbkOHhoUZ44e9kv
         aaRGXRVleB6cUKf2fw3JSib1zSDqONJYKMzuSAPef7FHTBjJu/EHFSBPImQ7UrgBrgBc
         bEuA==
X-Forwarded-Encrypted: i=1; AJvYcCVM0UrpYfzZSJWZrKrqtNvK4cLKkQbEfxzYLBYVfs4LsgZBuf7YU8MaOoirM1ErU4WZALNlhcIz/g==@kvack.org
X-Gm-Message-State: AOJu0Ywe0dKDpIUsrBfLqZyIer4WXNEx3CaypnezOAqSPwWl0SlOWK8D
	4KBn7TbXb+ng5UYv9D7hztj7HNAg/sxTkyhPTCM8y7pWXGclrQi6nbCc
X-Gm-Gg: ASbGncuz+N6nolZx0oQRgt+2ASkNFsocyGeqmM+O0k6oPt59xkYgTXJA6ihFGVqHrMh
	jwnvqGyGZOFgHCumVoQCSvryt7pTw6hTQzTK32zu6JVTkmS3FOq4lCuIlcfgBIqyjoSvl5zn9O7
	DmxuhTFQQ6udliQ0O+YlbMXBq8IcvlrNQ3bfnOH4rV4pDyEw/NesvNMbmhKigkq2TRr4ddFz6PQ
	Zax/hOeQNVlbQx4LgwKt1ADWPqXok5ZZKHQZXkMqj4GDfQdQSGNCYyUZLRG6GM4brj2Vw1ifzk9
	0ThKiFrN3SZncJL0O3XQnVG5obW3EPV+VH0mRBTMJX9ry+0BMUK0eCaTnOjr5/jf2e5usvR5iDL
	iW63U4FXIiWgC6hb5mllrEzSpoFXXkMMesQcqhtFTOKKXyy0QXFvMpX504wEM3F9uyzrHEgARcX
	twjXTUl0w/Y1P84w==
X-Google-Smtp-Source: AGHT+IHsC8WLzRz86acSXKKLf9htyktUYbaQTt584boJvhtqrXAJbQVTaPMhhYWIheLKaJCxpnT9YA==
X-Received: by 2002:a05:6402:2806:b0:643:60b6:3eed with SMTP id 4fb4d7f45d1cf-64360b63f56mr15412046a12.31.1763552574059;
        Wed, 19 Nov 2025 03:42:54 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a4b1fadsm16169223a12.31.2025.11.19.03.42.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 03:42:53 -0800 (PST)
Date: Wed, 19 Nov 2025 11:42:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
Message-ID: <20251119114252.oykrczprf3ecd7ak@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <aRwAjSQBby614Itx@kernel.org>
 <20251119040718.2735199-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119040718.2735199-1-tianyou.li@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8496C0003
X-Stat-Signature: 6jwh1ogzdb7iatiy3ew6axq9ot4esjjd
X-HE-Tag: 1763552575-723950
X-HE-Meta: U2FsdGVkX1/wHSe8MIt83DdZtA7YyzUp0QDvDFSowUQwJ8PbdKt03T0+6PjBmh+kIxtzYekD1PuI50BIXzWyqXuSYcO7duK1E5XZDQVPQ4ihNAH+eslV6ZF46G3yUmAHrWcnhugY6PIf1hJCSIzG6tSfF/ItGjZHrylfFJns6swtvvZ13uHkCJPrpsW2AtngzFJbB1MvhGcOslv/IzvmMLJPhmF0MxagSC9iVMMmMETd/qvftV3rXJjHPu6dVMI0JqfjJ5ZcLbQ/XObbwSOcqaPkSOELh8iAsMm829bLYbnTQOegsxNk46fz0dRnGsk17EVARGf8n7xAQG6N0f4JGvNk6y3Zy9lYgda1HAT2SspE64b93HT0GTEcdretYsWqiYMPUZjgULyUgAb67uCtwNZZzZbZsZITjn4ByEak0y0XAchOuu7dgj9xdd+GKHwtuqtsPsDAP2L1rcRKE8NWfqlCOdERZPxpsLpK3xkrQsXneGJagsqD22BgST14pi2wjeoa+ko3KF+uuV2EwW2cVRzejmCKNubb59zqHJWg0UaEajatlAl5i/P+xpQEeRk/dnK8lM1hzVuozFE5DPeHm//aonjaF6aGRRuwsM7FjUQ+3E6IGYjzi8WF/lfl6ByIztUk30gy+pEqs+Qp7oaj0lMOrVUYWgmgIujU7MH5Qz7hGGeCdrHOhnwS4Ab8gPuhrHCzEB5M9CgQmL/GCkpyKQVcLxx6EjnTvbUlj6VRdy4iQV533VcPreUWjB5JRw1/Ue5b2LqYogEvb+jWgWiChxDoAmKS21VVNcHPZa81Aa4/p3myRev6LWUISDPrZ3I0LqCrsqh+RDUAqETMXJlrFwVTlovc88vkFLAojYbvjJ14hDwGdeQQYYjtERa3m7S94xh4k5JUMzj+pPuJe44nwUxWVK0ewUpetvyPcbZ85+HW3/yzSaNOBQkH+kNFOuH50NEt/2jQmAYiPvk4H50
 oWRmcwEI
 2KYDVBUqVf4zeyz7Ym1MhS1B5K8jVh3C7318I18XWSRBowaqA6oFTUZjKR+5tFCvSbMqRMUNUSW1IO59mA9CJ1TNd9mFzxIMoQFvIzb4o2fC0zWYmyEB4e2XBTZv691popt98eMP68VHz4pEsbzrAyfZq/Dj9E9BKcMaTnXCtQxna83M7VDWF/bQNte3twpZvmr0t3V8TdGYtbf4k0vuyY1HDGgcogfrxFI3+s7uEFy/nMPNbYjYem1WZLy7ceNYmnFwSF782riwpyhhTfnqz5aVIA5i5tMG62YJMTcHYhtfsdaglP8Uz6OKec+uNpcXlk2i9aD1fBXYDtfSOBawLrmXjzdCLd82rCBMX8+hRweHqH/Ht+DRP1uXtYFZjmX3kuaadMGIcRvwTbtKGAOsgW17QAZTEYStegZch7sRBUtjCWr4uZ490tN2xUw2IQ/leq2GRLeEVlisjiAxJQK+gDM8fxY+Kn5T1ZKNTSTLWl20nMfekNlwfb4WzN1roj5zqByUYcXJjE/oArY5M8wUVZg75lvR4NgpXUWh9RfsBsCpamHsiXQKcuR2PigjBjBLfqzYZaATKtyDmFPqL7gDL8+0OPHjKvmYaQUFUBPur0vZ5rehHoYaEolnXiQttIwyvtXj0SHEWCSfW19rCL42VDV++khx88CDNunlN4MuTxT1UyA1NAN1+bSBPtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 12:07:18PM +0800, Tianyou Li wrote:
>When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
>checking the new zone's pfn range from the beginning to the end, regardless
>the previous state of the old zone. When the zone's pfn range is large, the
>cost of traversing the pfn range to update the zone->contiguous could be
>significant.
>
>Add fast paths to quickly detect cases where zone is definitely not
>contiguous without scanning the new zone. The cases are: when the new range
>did not overlap with previous range, the contiguous should be false; if the
>new range adjacent with the previous range, just need to check the new
>range; if the new added pages could not fill the hole of previous zone, the
>contiguous should be false.
>
>The following test cases of memory hotplug for a VM [1], tested in the
>environment [2], show that this optimization can significantly reduce the
>memory hotplug time [3].
>
>+----------------+------+---------------+--------------+----------------+
>|                | Size | Time (before) | Time (after) | Time Reduction |
>|                +------+---------------+--------------+----------------+
>| Memory Hotplug | 256G |      10s      |      2s      |       80%      |
>|                +------+---------------+--------------+----------------+
>|                | 512G |      33s      |      6s      |       81%      |
>+----------------+------+---------------+--------------+----------------+
>

Nice

>[1] Qemu commands to hotplug 512G memory for a VM:
>    object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>    qom-set vmem1 requested-size 512G
>
>[2] Hardware     : Intel Icelake server
>    Guest Kernel : v6.18-rc2
>    Qemu         : v9.0.0
>
>    Launch VM    :
>    qemu-system-x86_64 -accel kvm -cpu host \
>    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>    -drive file=./seed.img,format=raw,if=virtio \
>    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>    -m 2G,slots=10,maxmem=2052472M \
>    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>    -nographic -machine q35 \
>    -nic user,hostfwd=tcp::3000-:22
>
>    Guest kernel auto-onlines newly added memory blocks:
>    echo online > /sys/devices/system/memory/auto_online_blocks
>
>[3] The time from typing the QEMU commands in [1] to when the output of
>    'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>    memory is recognized.
>
>Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>Tested-by: Yuan Liu <yuan1.liu@intel.com>
>Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>Reviewed-by: Pan Deng <pan.deng@intel.com>
>Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>---
> mm/memory_hotplug.c | 57 ++++++++++++++++++++++++++++++++++++++++++---
> 1 file changed, 54 insertions(+), 3 deletions(-)
>
>diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>index 0be83039c3b5..8f126f20ca47 100644
>--- a/mm/memory_hotplug.c
>+++ b/mm/memory_hotplug.c
>@@ -723,6 +723,57 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
> 
> }
> 
>+static bool __meminit check_zone_contiguous_fast(struct zone *zone,
>+			unsigned long start_pfn, unsigned long nr_pages)
>+{
>+	const unsigned long end_pfn = start_pfn + nr_pages;
>+	unsigned long nr_filled_pages;
>+
>+	/*
>+	 * Given the moved pfn range's contiguous property is always true,
>+	 * under the conditional of empty zone, the contiguous property should
>+	 * be true.
>+	 */
>+	if (zone_is_empty(zone)) {
>+		zone->contiguous = true;
>+		return true;
>+	}
>+
>+	/*
>+	 * If the moved pfn range does not intersect with the original zone span,
>+	 * the contiguous property is surely false.
>+	 */
>+	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
>+		zone->contiguous = false;
>+		return true;
>+	}
>+
>+	/*
>+	 * If the moved pfn range is adjacent to the original zone span, given
>+	 * the moved pfn range's contiguous property is always true, the zone's
>+	 * contiguous property inherited from the original value.
>+	 */
>+	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
>+		return true;
>+
>+	/*
>+	 * If the original zone's hole larger than the new filled pages, the
>+	 * contiguous property is surely false.
>+	 */
>+	nr_filled_pages = end_pfn - zone->zone_start_pfn;
>+	if (start_pfn > zone->zone_start_pfn)
>+		nr_filled_pages -= start_pfn - zone->zone_start_pfn;
>+	if (end_pfn > zone_end_pfn(zone))
>+		nr_filled_pages -= end_pfn - zone_end_pfn(zone);
>+	if (nr_filled_pages < (zone->spanned_pages - zone->present_pages)) {
>+		zone->contiguous = false;
>+		return true;
>+	}
>+

Mike's suggestion is easier for me to understand :-)

>+	clear_zone_contiguous(zone);
>+	return false;
>+}
>+
> #ifdef CONFIG_ZONE_DEVICE
> static void section_taint_zone_device(unsigned long pfn)
> {
>@@ -752,8 +803,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> {
> 	struct pglist_data *pgdat = zone->zone_pgdat;
> 	int nid = pgdat->node_id;
>-
>-	clear_zone_contiguous(zone);
>+	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
> 
> 	if (zone_is_empty(zone))
> 		init_currently_empty_zone(zone, start_pfn, nr_pages);
>@@ -783,7 +833,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> 			 MEMINIT_HOTPLUG, altmap, migratetype,
> 			 isolate_pageblock);
> 
>-	set_zone_contiguous(zone);
>+	if (!fast_path)
>+		set_zone_contiguous(zone);
> }
> 
> struct auto_movable_stats {
>-- 
>2.47.1
>

-- 
Wei Yang
Help you, Help me

