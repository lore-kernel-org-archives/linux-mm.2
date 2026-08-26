Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A8EC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400DC6B008A; Wed, 26 Aug 2026 09:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0E16B008C; Wed, 26 Aug 2026 09:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3226B0095; Wed, 26 Aug 2026 09:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02ADA6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:14:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9104F40387
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:14:51 +0000 (UTC)
X-FDA: 85143465582.20.A35D735
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id 52F29180006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:14:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Us1hEVv1;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787750088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VY+6n/5elVC8hwBjWkQixPjDDn3ia+6z+6/gZrGy1ZY=;
	b=XNnPrx7xYZwRQq/5KP/pAx67HVn6BRKp0gf+U9ljNAvG8H1SVkSGdwnCrijD1/Ob9vqULW
	hVPw4Htplnyw1mP/0mH9QWqC5nr3d/Ufc8+IB6QwbpPEEU2Yi5fh3Dvum3s/FMKISPEC1q
	l1kmv+HKO0jiQI+5wHRASkApnQG7ND8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787750088;
	b=cdDS3PjiUkaKdqGXtbQBw26f/tffLRuLs9EO27IA2fUcjCP+4l4dGpQFx/a+k5/vkSVVvO
	XgPA98EE96IyIm5RAZZNfFCf9LAMeZk6VrgWiAVdi2/LNNbkRSgUfjvWC2cjDXfkVhx0tl
	nml2iF1ZcjUTmwvCumxH27g7o1VQzok=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Us1hEVv1;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260826131445euoutp02197bcec1c4f1522f5d444b8d6dcb48b4~PXTsHh9X10325503255euoutp02i
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:14:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260826131445euoutp02197bcec1c4f1522f5d444b8d6dcb48b4~PXTsHh9X10325503255euoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787750085;
	bh=VY+6n/5elVC8hwBjWkQixPjDDn3ia+6z+6/gZrGy1ZY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Us1hEVv1IxQW93jEvGhJaHi0QWVIacTPIxxmLsnAcuIhl3lp2FwlVqDO6wWYqT6eB
	 2CdasTRwngIpbOvEDQZ5d9TlbCar5iqR9M0vq7qyK0FJp/z+Mv8yY/YYGn7/s9xTPa
	 eoiWzJwrrvmg2QKtV4J9BXLKQj6+bHINGLao+Hcw=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260826131445eucas1p1dfa5844c01c4705731fdd2f4772e4fc8~PXTr_zaZu2811628116eucas1p1K;
	Wed, 26 Aug 2026 13:14:45 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260826131444eusmtip1c8b1026d97f4887a1c808cabbdcb3df7~PXTrbvWoQ1345413454eusmtip1i;
	Wed, 26 Aug 2026 13:14:44 +0000 (GMT)
Message-ID: <72074a49-2963-4f96-b939-79bf95a829cb@samsung.com>
Date: Wed, 26 Aug 2026 15:14:44 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 1/5] of: reserved_mem: skip init for regions whose
 early reservation failed
To: Wandun Chen <chenwandun1@gmail.com>, robh@kernel.org,
	saravanak@kernel.org, rppt@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260818092420.2859026-2-chenwandun1@gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260826131445eucas1p1dfa5844c01c4705731fdd2f4772e4fc8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260818092438eucas1p20115e5d33908e32ef4433cb246da8098
X-EPHeader: CA
X-CMS-RootMailID: 20260818092438eucas1p20115e5d33908e32ef4433cb246da8098
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
	<CGME20260818092438eucas1p20115e5d33908e32ef4433cb246da8098@eucas1p2.samsung.com>
	<20260818092420.2859026-2-chenwandun1@gmail.com>
X-Stat-Signature: woyiciadsqu3ci5wywoj99bo3xyh9sny
X-Rspamd-Queue-Id: 52F29180006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787750087-737831
X-HE-Meta: U2FsdGVkX18DObV4rLHoQjvKFOo2fie8XIUg6L2pl/W94uemzTYZjHUSar9IGZt+h0p/FTKf57IA0wAMe5zQ3RF7zxlTDMj1lC/XpJtc2OCxmZDG8LEQe0bAajAUz+IpArpz8D9EwLTALn+l3beXIWeIpzDCXDY+7av/hCSRrqcm+5k5oseBWgyRy512sUVvwchhLYCzlP0an/jJ34YCkAgTx21JIXFsqwcCxYZuNVydT35POR46VpIcv6vmx5eR/CLYWqh7ep2vxYBPSd3gbkIIqWUWXoEjTD2W/gGNokkn+a5YuNyCLWIDzLb+e2rtVv+J+THb4UeURRyXQIptaqbFdUR0vSNNLTY0CmVHizae9wOAF2yVlzxsAYbu67t1gYgPigfDYWsBvR1bLrsOXZQD6rBXw8iO/z8+g4xVZSJOMSYiDMnyC1+Y4ZgZRFmHPcU78/102R4NBEl5SnQ1uYyqAH8W4oJAVWAjy41EH4CuQHYMzMwLS8O1I3DllJw+8TNrXfG79aVLWVYipZ/jhR35ZtKb6A4wUIZ/meWEyt4gOb3qoe2esvAAV6XExouR9iRHsbIzg/KEPRBBXmQLxjCzjtaMbzSaqZylwmAzvrPv4rQoSaphplmsAwwfc3djtqe6BypMsrZPvPQklbMZli7BhwRICFG2t/Y/V2uVINEZV/RDyNDZCqZ9u8bVez2at3XfyU14vWr+1HaG0Nu9hQb5gqULAENhx/L/ClRA7EezRf/A3di0CDUM9LmBTQ2R1ogwhcoZzN4teJLy38o2qy5th5SPYF2F+YDImTNskwrhXqCelgAV2B5SKWJZU4sJXp9n8mTJWjJgqe1RibspR7IiOtpUSzs7ZAYLM+E0AlnQQMwt+GgXavcQc7Yyuhom1YLQd91HSY8BCwkZTHHyIBlzT4tHPattA1FcxYxnbq7r09Zk7HEaJuK6V3TfwutrsrLqkQtamqe1bwQnHnq
 hYj4ZIer
 knGRHsIq0fHjtrbxCcSYa4EtFxM/vk6Sd/Z/gbkG+vdIDfnwSFCHEGLNMKj2q2LkYqi6DzMEf+tj2eisP6kZ8jhKwg0614kiRQ91kZlTSTev0bKFwtYRWkRwxtPp1UGKtDJixJVzF9mGFIoOhEnDx7kAx1AYMKPx/+KMan2vI/OxHbFTjcVOVZ68wXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.2026 11:24, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> __reserved_mem_reserve_reg() discards the error from
> early_init_dt_reserve_memory() and returns 0 unconditionally, so the
> caller counts the node in total_reserved_mem_cnt and the late scan
> initializes it without checking whether the early reservation actually
> succeeded. A region whose reservation failed is then handed to a
> device assuming the memory is protected.
>
> Propagate the error so failed reservations are no longer counted, and
> record the failed nodes so fdt_scan_reserved_mem_late() can skip them.
>
> Recording the failed nodes explicitly is necessary because
> fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
> tell from memblock whether early reservation succeeded.
>
> The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
> of static regions is not bounded by it, so on overflow the extra nodes
> fall back to being initialized, which is the current behavior.

I'm not very keen on such partial solution. Indeed we have no place to

store the result of the early init call, but we can check if the given

region has been earlier marked in memblock as reserved or no-map in

fdt_scan_reserved_mem_late(). If those attributes don't match the

region can be simply skipped then.


> Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> ---
>  drivers/of/of_reserved_mem.c | 65 ++++++++++++++++++++++++++++++------
>  1 file changed, 54 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 8c9d6395d6a3..c6e73d710ee1 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -32,6 +32,30 @@ static struct reserved_mem *reserved_mem __refdata = reserved_mem_array;
>  static int total_reserved_mem_cnt = MAX_RESERVED_REGIONS;
>  static int reserved_mem_count;
>  
> +static int reserve_failed_nodes[MAX_RESERVED_REGIONS] __initdata;
> +static int reserve_failed_nodes_cnt __initdata;
> +
> +static bool __init reserved_mem_node_reserve_failed(int node)
> +{
> +	int i;
> +
> +	for (i = 0; i < reserve_failed_nodes_cnt; i++)
> +		if (reserve_failed_nodes[i] == node)
> +			return true;
> +	return false;
> +}
> +
> +static bool __init record_reserve_failed_node(int node, const char *uname)
> +{
> +	if (reserve_failed_nodes_cnt == MAX_RESERVED_REGIONS) {
> +		pr_err("too many failed regions, '%s' reservation failed\n", uname);
> +		return false;
> +	}
> +
> +	reserve_failed_nodes[reserve_failed_nodes_cnt++] = node;
> +	return true;
> +}
> +
>  static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
>  	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
>  	phys_addr_t *res_base)
> @@ -141,7 +165,8 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
>   * first entry in 'reg' property
>   */
>  static int __init __reserved_mem_reserve_reg(unsigned long node,
> -					     const char *uname)
> +					     const char *uname,
> +					     bool *should_record_failed_node)
>  {
>  	phys_addr_t base, size;
>  	int len, err;
> @@ -149,6 +174,8 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
>  	bool nomap;
>  	u64 b, s;
>  
> +	*should_record_failed_node = false;
> +
>  	prop = of_flat_dt_get_addr_size_prop(node, "reg", &len);
>  	if (!prop || !len)
>  		return -ENOENT;
> @@ -167,14 +194,20 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
>  	base = b;
>  	size = s;
>  
> -	if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
> -		fdt_fixup_reserved_mem_node(node, base, size);
> -		pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
> -			 uname, &base, (unsigned long)(size / SZ_1M));
> -	} else {
> +	if (!size)
> +		return -EINVAL;
> +
> +	err = early_init_dt_reserve_memory(base, size, nomap);
> +	if (err) {
> +		*should_record_failed_node = true;
>  		pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
>  		       uname, &base, (unsigned long)(size / SZ_1M));
> +		return err;
>  	}
> +
> +	fdt_fixup_reserved_mem_node(node, base, size);
> +	pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
> +		 uname, &base, (unsigned long)(size / SZ_1M));
>  	return 0;
>  }
>  
> @@ -306,10 +339,14 @@ void __init fdt_scan_reserved_mem_late(void)
>  		base = b;
>  		size = s;
>  
> -		if (size) {
> -			uname = fdt_get_name(fdt, child, NULL);
> -			fdt_init_reserved_mem_node(child, uname, base, size);
> -		}
> +		if (!size)
> +			continue;
> +
> +		if (reserved_mem_node_reserve_failed(child))
> +			continue;
> +
> +		uname = fdt_get_name(fdt, child, NULL);
> +		fdt_init_reserved_mem_node(child, uname, base, size);
>  	}
>  
>  	/* check for overlapping reserved regions */
> @@ -349,6 +386,7 @@ int __init fdt_scan_reserved_mem(void)
>  
>  	fdt_for_each_subnode(child, fdt, node) {
>  		const char *uname;
> +		bool should_record_failed_node;
>  		int err;
>  
>  		if (!of_fdt_device_is_available(fdt, child))
> @@ -356,9 +394,14 @@ int __init fdt_scan_reserved_mem(void)
>  
>  		uname = fdt_get_name(fdt, child, NULL);
>  
> -		err = __reserved_mem_reserve_reg(child, uname);
> +		err = __reserved_mem_reserve_reg(child, uname,
> +						 &should_record_failed_node);
>  		if (!err)
>  			count++;
> +		else if (should_record_failed_node &&
> +			 !record_reserve_failed_node(child, uname))
> +			/* Keep a slot for the untracked node's late initialization. */
> +			count++;
>  
>  		/*
>  		 * Save the nodes for the dynamically-placed regions

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


