Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9BBF31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90A56B008A; Thu,  9 Apr 2026 10:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41EC6B0093; Thu,  9 Apr 2026 10:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30936B0095; Thu,  9 Apr 2026 10:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD67D6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:40:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 644D7E2CD4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:40:15 +0000 (UTC)
X-FDA: 84639277590.28.5F3A4D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A49F440002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:40:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BIvkZIdm;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775745613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/7AyDoaGDPpMzpK0gJ/IHYyTPy8WmbZ9sxmYH+CqVA=;
	b=T5KYwkmrf6hwwtkhyZIw6gSYKHFAEnnhsBofTzJPJAJFmaD2All5JzaB7q0THxtdexnoI5
	ssNqTXfWQXRBFV1lbA++g9lYkrgu5VNYAqMe5vnLc0+TLP+zv1XsaePTCHPVn8fJsrYToj
	wasV9cZZp7CM9nYboxgs+SpQRLNPFwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775745613; a=rsa-sha256;
	cv=none;
	b=bPhPPLMLUe51F4K3VKLHpu+XRUxJVw+kSrhmbhXHmjZPSrPwhlq3erd2fqeCRLBgPk3J51
	ETBORg8T/aZh/tYlTaMg1YdH37ZLs+7H/i94QSZ3TfxGrQJnkc3e1giLZznucr6o29cotA
	Mjfv/tTfeZAguSlfjoIFlB74kbm/IK0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BIvkZIdm;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A9B2E409FE;
	Thu,  9 Apr 2026 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96CBC4CEF7;
	Thu,  9 Apr 2026 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775745612;
	bh=kEAP5eB0z0PaQwrbMq601FsxrVj/+btiOm2UxZu5PFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BIvkZIdmTl5KJXqNs+MFxCnQetWyTSsMEopZThPFaYzp+R6QbklDeetEFoqWxgoWk
	 VPqJBCnYi/bqcqmeRjrq4xQUr++aZQ8y/t81AP94SBGrEN5Au7NtlnN8gIfrwh96Wj
	 35yZ/xZjf/4w4dPMSdCQ4BVdq5l6dm1C3bvaAxum6wglYZeX91+iQKZPhz7UIktoVi
	 QWilpoGQbqMFOwXzMst8giXWYjqmMH8Qw0UmlEMEAieo70U1nw66aCaDFvgx9XLhB5
	 CeF0dK2kh5YZ7mcWJS389h7hF/XN6idp/0NtE8uoxK/UhncjL71yxdS+5SLeltJXat
	 qAImlj/TVUh5Q==
Date: Thu, 9 Apr 2026 17:40:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <ade6RVeXxDt7ImP4@kernel.org>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: kzy1rgz48mb7uappyfeynd6uui1p6w8c
X-Rspamd-Queue-Id: A49F440002
X-Rspam-User: 
X-HE-Tag: 1775745613-777239
X-HE-Meta: U2FsdGVkX1+q+CqXBEus/jfHYLodl57UXEXj8kscI3s8nOZDbAlb/Ixj7t3Oy3WYiZNMWxhUvtsIRvrOae1uPNuXFRc6zpOYB3KB7zfEED4WNmtbcUgJTjfnlzLO1sCvhP5FvOtJIZl1aBPwO7expLcVsJXlZ/X/pTzbgb7cYgxIgvwpJ971h8tcl+z2MhNAVytOEFd1NF27975nOfW5Wem0D1j5GyVP9Xr7BaCqj+S2UOWaFcfIA5n/SAliaE+pQ7Gl7wIK/QsNICIXsoz1m8eG17x7A9/Xlv/ME0iq5wO/DXCTNIGq9xe9w9+rQHsmPWhOGAynHEBY+OEOO7XDDXQAOHZ/rkPu7hsa/2yPCrjEduqwZhyY6ij6g/NhGtrCvS3DtMZ2Csn9GzmYuLkNSlAQQpcRiZ/iCfYMaap4AtXawUrs8qgCjuePtUS33ymUfDjtLxRcluNmTAR1mmbvw9isGlbx0waMkL8M1BjCyVij5xb5v+SLytzHoAOkD7Z1Ls4OWMjgQDaf+5iMhB36s6K8OeNQRMGxvbAI4uym6u23V7dpPKGa3/PYAQISrzYgu2G306OaXICRZBv67bWjv+KEvR9E3LffSFZyxVlN6ieJse7o3O8cOuiUbRKriAe5MPLBjufbQG70hhzhdBd+FiQ7JRKY6UARLbxvVJX2zxXx80geD6u+zUo3wffsDc6OSM1xVDzIyOhwFmytubLBZhAYe6zrinWMcpW6ZwDi4E3IER+dmZqx2BNn9ZYPyyZZYIer9ItY2bU3I6j3ERHGrTUfJwWkZxNJJPJrJJBp8t54NY9KzE9MgrAqn2nynpUEASMHsdyv3k+yq4rnrhWpZmECKPsdbMGT4q+Y57sHwNQK22wUC7LhQtvfnJnx5avjTvolRtBgwIcyS7j7sZaEyGOulSHvk5VbgaaNYTvxg7VsGLH//M3tEoYtuw5D1f4Uj6q1Se7xitmGYFrl0+K
 s5Dubmm+
 UtIlJpXeFH0Ql2GExZp71kVCb1H3tHhFI6rReLs5A4hph/EYHuRPPZdrAOqyBrD8w8NafjxBkqbkuSUVqAJwPbgK0v+zQ2Fo8E0a6r+VRo5cZOYqQx4nqse20GkCY/JV9VlFZLOGZaLSPOSOMOsmwrld14faQZlcL6H2380wrBNRr83BCUdC/fPTkH5WAFYSdKoCYWvnDQWR+HYCMXuYvaCRifA1J4oramNCGcWcvmKqrvHxEjmAEuLmGIlX0oGaTaK4L1LGVPtwglfUGlGXhQ1xM9szXYug5EI6CkBM96Rmuh3sVrKTSBgLhN18kdZ0G9cckE6q4zgA4luDa9GL4UTMXA00PdenbIj8+yd37nfeVmGDYUujFfhJcDdJ+dYxaFn2WuLgiM3BYFOIM4daqaTQotVKwTVk+KscvIdJQ2bWa2WqwIo5JO8qda2yQGX96gG2nFKL48+0e1I0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 09:36:14AM +0200, David Hildenbrand (Arm) wrote:
> On 4/8/26 05:16, Yuan Liu wrote:
> > When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> > zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
> > to rebuild zone->contiguous. For large zones this is a significant cost
> > during memory hotplug and hot-unplug.
> > 
> > Add a new zone member pages_with_online_memmap that tracks the number of
> > pages within the zone span that have an online memory map (including present
> > pages and memory holes whose memory map has been initialized). When
> > spanned_pages == pages_with_online_memmap the zone is contiguous and
> > pfn_to_page() can be called on any PFN in the zone span without further
> > pfn_valid() checks.
> > 
> > Only pages that fall within the current zone span are accounted towards
> > pages_with_online_memmap. A "too small" value is safe, it merely prevents
> > detecting a contiguous zone.
> > 
> > The following test cases of memory hotplug for a VM [1], tested in the
> > environment [2], show that this optimization can significantly reduce the
> > memory hotplug time [3].
> > 
> > +----------------+------+---------------+--------------+----------------+
> > |                | Size | Time (before) | Time (after) | Time Reduction |
> > |                +------+---------------+--------------+----------------+
> > | Plug Memory    | 256G |      10s      |      3s      |       70%      |
> > |                +------+---------------+--------------+----------------+
> > |                | 512G |      36s      |      7s      |       81%      |
> > +----------------+------+---------------+--------------+----------------+
> > 
> > +----------------+------+---------------+--------------+----------------+
> > |                | Size | Time (before) | Time (after) | Time Reduction |
> > |                +------+---------------+--------------+----------------+
> > | Unplug Memory  | 256G |      11s      |      4s      |       64%      |
> > |                +------+---------------+--------------+----------------+
> > |                | 512G |      36s      |      9s      |       75%      |
> > +----------------+------+---------------+--------------+----------------+
> > 
> > [1] Qemu commands to hotplug 256G/512G memory for a VM:
> >     object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
> >     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
> >     qom-set vmem1 requested-size 256G/512G (Plug Memory)
> >     qom-set vmem1 requested-size 0G (Unplug Memory)
> > 
> > [2] Hardware     : Intel Icelake server
> >     Guest Kernel : v7.0-rc4
> >     Qemu         : v9.0.0
> > 
> >     Launch VM    :
> >     qemu-system-x86_64 -accel kvm -cpu host \
> >     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
> >     -drive file=./seed.img,format=raw,if=virtio \
> >     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
> >     -m 2G,slots=10,maxmem=2052472M \
> >     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
> >     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
> >     -nographic -machine q35 \
> >     -nic user,hostfwd=tcp::3000-:22
> > 
> >     Guest kernel auto-onlines newly added memory blocks:
> >     echo online > /sys/devices/system/memory/auto_online_blocks
> > 
> > [3] The time from typing the QEMU commands in [1] to when the output of
> >     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
> >     memory is recognized.
> > 
> > Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> > Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> > Tested-by: Yuan Liu <yuan1.liu@intel.com>
> > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> > Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> > Reviewed-by: Pan Deng <pan.deng@intel.com>
> > Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> > Co-developed-by: Tianyou Li <tianyou.li@intel.com>
> > Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> > Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> 
> [...]
> 
> > @@ -842,7 +842,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> >   *   zone/node above the hole except for the trailing pages in the last
> >   *   section that will be appended to the zone/node below.
> >   */
> > -static void __init init_unavailable_range(unsigned long spfn,
> > +static unsigned long __init init_unavailable_range(unsigned long spfn,
> >  					  unsigned long epfn,
> >  					  int zone, int node)
> >  {
> > @@ -858,6 +858,7 @@ static void __init init_unavailable_range(unsigned long spfn,
> >  	if (pgcnt)
> >  		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
> >  			node, zone_names[zone], pgcnt);
> > +	return pgcnt;
> >  }
> >  
> >  /*
> > @@ -956,9 +957,22 @@ static void __init memmap_init_zone_range(struct zone *zone,
> >  	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
> >  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
> >  			  false);
> > +	zone->pages_with_online_memmap += end_pfn - start_pfn;
> >  
> > -	if (*hole_pfn < start_pfn)
> > -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> > +	if (*hole_pfn < start_pfn) {
> > +		unsigned long pgcnt;
> > +
> > +		if (*hole_pfn < zone_start_pfn) {
> > +			init_unavailable_range(*hole_pfn, zone_start_pfn,
> > +					       zone_id, nid);
> > +			pgcnt = init_unavailable_range(zone_start_pfn,
> > +					start_pfn, zone_id, nid);
> 
> Indentation of parameters.
> 
> > +		} else {
> > +			pgcnt = init_unavailable_range(*hole_pfn, start_pfn,
> > +					zone_id, nid);
> 
> 
> Same here.
> 
> > +		}
> > +		zone->pages_with_online_memmap += pgcnt;
> > +	}
> 
> 
> Maybe something like the following could make it nicer to read, just a
> thought.
> 
> 
> unsigned long hole_start_pfn = *hole_pfn;
> 
> if (hole_start_pfn < zone_start_pfn) {
> 	init_unavailable_range(hole_start_pfn, zone_start_pfn,
> 			       zone_id, nid);
> 	hole_start_pfn = zone_start_pfn;
> }
> pgcnt = init_unavailable_range(hole_start_pfn, start_pfn,
> 			       zone_id, nid);
> 

Yeah, this looks better :)

sashiko had several comments
https://sashiko.dev/#/patchset/20260408031615.1831922-1-yuan1.liu%40intel.com

I skipped the ones related to hotplug, but in the mm_init part the comment
about zones that can have overlapping physical spans when mirrored
kernelcore is enabled seems valid.
 
> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.

