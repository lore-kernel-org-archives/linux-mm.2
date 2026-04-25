Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4CBFF885D
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 09:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225FC6B0005; Sat, 25 Apr 2026 05:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6C86B008A; Sat, 25 Apr 2026 05:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5C26B008C; Sat, 25 Apr 2026 05:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB58F6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:01:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D92BA027D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:01:54 +0000 (UTC)
X-FDA: 84696485748.28.56995FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B6A7E40006
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:01:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkEwOF2Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777107712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ly6yc6pDJGQRXfKryHvH5aFf8vpWnWth6d9ty9PtjL4=;
	b=UtGRHaWaxoc+ccQw/b8YcvRwEy5sti1EjASPgSNymF2gS/NbucBCv4Azhnzt9vSNFLYKN/
	EKPT2ZwChRyfcj5Cml8wn8QJz1HSgp/ePOVJk4sU02vS79MssOTS9Yjf6wwZncBxfxOcVu
	Mkk40MvHUaRNtfqgw/kSTdoJ5psTlUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777107712; a=rsa-sha256;
	cv=none;
	b=XetSItv/qQG/9TkNxXAGfebBY3T71lxlT9dhltef00xyu3hyoCMTPnLnRYwebEUANha/jN
	lKWfv/Xs1sFZd4BiV4gUzArrgRCa5Z5T3nCoMeqCmEsAbM18wzdDXeaHS5KVB0lMgxedOP
	kWe3D5XUGXCJGob5WuFiR2MMx9nqj/k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkEwOF2Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90B7840DFC;
	Sat, 25 Apr 2026 09:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE36C2BCB0;
	Sat, 25 Apr 2026 09:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777107711;
	bh=5yiqehpqcmPkZRD49hIB6BWbV7/+EwrK/ftgYf7l+DQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HkEwOF2Q88ie3HEjo2W0sQPgQBUwFPH3UABPKNCMZxk89hJ/hoG1QNte2jcu7qPNt
	 0iC6DHxQQz6286/vynT2oO1mnHMVZTtCr0YQrFgCQwHTKMxqy1JdyTl8D7JtVw8MXK
	 Nu02SNOk0hJ3g6AmFtIf4/Ym2ZuE0tMmRfcgjOLj1w0tUsu7jzIZ5Pz+OUo5RUnojn
	 2RO6M2UgD23XBi/LtUUQhg/EmG2Re69HC11go8o4qrA5Auj33TUJiE2hlsM8i5zTjG
	 5BVDS+bjr2sHHGfxXgfUwf6INOwWaOPQhuHG4LgUaxUv25RPvcY0LsxmoTg5Z8G/Kd
	 fGYQF9TDHO2gQ==
Date: Sat, 25 Apr 2026 11:01:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Message-ID: <aeyC9i2TziSzY8_Z@kernel.org>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421125508.2317429-2-yuan1.liu@intel.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6A7E40006
X-Stat-Signature: r4rfgsmw1494t7mmey1ikdojejoci1fk
X-Rspam-User: 
X-HE-Tag: 1777107712-579305
X-HE-Meta: U2FsdGVkX1+MVdDIPbC3d2JFILIHaHaUWh1szmWkcUt6Uyc2SmcnjC9RMuvGLXnsAyDyXfLaDzeXpXD2uj75ovnB9e74VGujLEeA2pC4aXUl1qv4H4gQRaKQOQZU+MktFO8zGhExN1pwAiONAJNLmFjhlJ4UgdEcguTY9ew8BJZjrcZCCPiMr7bdgS4fqUqCr1erp4hacEjKZ0HgjIvhX3EWXjnuPJTxb/487SdSd69ZZlSB0f9fbvrHae5u7hctqHiIoRCOyeZ6TPmQDJhRK3k24YO3ZrZa+5lrOjNU8nm4I6mN8eBrI5uKobZItOOQ5cSwUBG+T5DfsvsZK7iSpdKqYSC8DHBpLU27rVMUl/QcdwEhGpOFwZLBUqucJqpLGpi8iUU0cdIuY+2nKAiA2WNSLA7MAjgx8lZhlBk6T3Zx2sjhdrw2X5b/kyrXZfKQBOu0fhRXn8KPnqrBPHAwooBcddEONtriFPmePJzC+Fd7OsT9xhA1J7dVeWCmkDVoDQRibVO5dXXP4m7CiM0JrqVs5b2jC2Fp4a5DHfzxq8qB9kXgcHCs3EyVqqLvBwn9vDiBrKSwOLDrUeWnQ0dHs5fkMkccQQSM/efCvAWs1YffgbUmns6dfzwUuFt+wIl1xDZmgU08or7SzgR+svTzqlT0YNt1CcX1mvYZW8Ur/oG28FTe36w/7/ILZ0qfVpNU0zkeRYDybIC3Vw0sPyQ7fBWfcbhitnDCMckbyyCPMy5Qs3Cpo8y0dvL+v1AxeVjfDry7WvtZmRThqjImvbFjngZfN0gwEU8gUjnU/+7n++qEzesV+WYiBZeFDgojdGhF9DXBsDcQLwcEoKxt9tFvet2egqAPfMQ31eBV2g3HxdsUf2wb9kXlbZagVH4rO8tnLGGdFpH3l5kHNF5DdABSytCMsOBrhd7q6jGA/ApdnZe808KlScptYqVBhbK7OMOnvUK4gWeWwRc6SloVPNg
 zcR5L542
 X6QRGRCje5ZjbwrMV4L5CN/F818zU+jEfKu5Wpj6Dx7XjNn/3BIahrakbcrcwWeUP8rTgmqwpx37z33YYYpTp9VWbCHTvltSvEwJwC3C/m590LQlKZPuATRffQA5/o00wyVDGyhiS7ffDbKEo4JDlshc0zVZo538IpYdloCxIyBGMwdGcImrxO7YPRBq5/1B8SXavN85B3FQvEir4KiOSRFx7mSvtUcUwdlobeXCZ9JIncYAiWd98fT6xeJgMsylaZaHBkZHoLz9PWURlGdQMGuS0yQKMhOQJvUZk5cOQ1+B49bcyNbrogDMAV/l3/vxp1c3azUS8f/ZLK8MJ6xsxMt61dVHU9xTm/iwa/lyPdrU1rxRrghwARbD1BWPK43XZZ0EvUq6jU9XGpA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Apr 21, 2026 at 08:55:07AM -0400, Yuan Liu wrote:
> Move the overlap memmap init check from memmap_init_range() into
> memmap_init().
> 
> When mirrored kernelcore is enabled, avoid memory map initialization
> for overlap regions. There are two cases that may overlap: a mirror
> memory region assigned to movable zone, or a non-mirror memory region
> assigned to a non-movable zone but falling within the movable zone
> range.
> 
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  mm/mm_init.c | 37 +++++++++++++------------------------
>  1 file changed, 13 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index df34797691bd..2b5233060504 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
>  	}
>  }
>  
> -/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
> -static bool __meminit
> -overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> -{
> -	static struct memblock_region *r;
> -
> -	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
> -		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
> -			for_each_mem_region(r) {
> -				if (*pfn < memblock_region_memory_end_pfn(r))
> -					break;
> -			}
> -		}
> -		if (*pfn >= memblock_region_memory_base_pfn(r) &&
> -		    memblock_is_mirror(r)) {
> -			*pfn = memblock_region_memory_end_pfn(r);
> -			return true;
> -		}
> -	}
> -	return false;
> -}
> -
>  /*
>   * Only struct pages that correspond to ranges defined by memblock.memory
>   * are zeroed and initialized by going through __init_single_page() during
> @@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>  		 * function.  They do not exist on hotplugged memory.
>  		 */
>  		if (context == MEMINIT_EARLY) {
> -			if (overlap_memmap_init(zone, &pfn))
> -				continue;
>  			if (defer_init(nid, pfn, zone_end_pfn)) {
>  				deferred_struct_pages = true;
>  				break;
> @@ -971,6 +947,7 @@ static void __init memmap_init(void)
>  
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>  		struct pglist_data *node = NODE_DATA(nid);
> +		struct memblock_region *r = &memblock.memory.regions[i];

Please move this declaration above struct pglist_data, let's keep reverse
xmas tree where possible.
>  
>  		for (j = 0; j < MAX_NR_ZONES; j++) {
>  			struct zone *zone = node->node_zones + j;
> @@ -978,6 +955,18 @@ static void __init memmap_init(void)
>  			if (!populated_zone(zone))
>  				continue;
>  
> +			if (mirrored_kernelcore) {
> +				const bool is_mirror = memblock_is_mirror(r);
> +				const bool is_movable_zone = (j == ZONE_MOVABLE);
> +
> +				if (is_mirror && is_movable_zone)
> +					continue;
> +
> +				if (!is_mirror && !is_movable_zone &&
> +				    start_pfn >= zone_movable_pfn[nid])
> +					continue;
> +			}
> +

I think this:

			if (mirrored_kernelcore && j == ZONE_MOVABLE &&
			    memblock_is_mirror(r))
				continue;

would be enough to remove overlap_memmap_init() and keep the existing
logic.

I wouldn't deal the theoretical cases Wei mentioned in this thread for
now and prefer to keep the things simple. 
The assumptions that mirrored memory spans a contiguous range below some
limit and that mirrored memory is not removable existed for years and I
don't see why we should change the logic now and complicate the code for
exotic theoretical memory layouts.

>  			memmap_init_zone_range(zone, start_pfn, end_pfn,
>  					       &hole_pfn);
>  			zone_id = j;
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

