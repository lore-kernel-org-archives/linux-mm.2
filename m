Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC77C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8B16B0096; Wed, 26 Aug 2026 09:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898926B0098; Wed, 26 Aug 2026 09:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5DA6B0099; Wed, 26 Aug 2026 09:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 559706B0096
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:17:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D37871C1809
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:17:50 +0000 (UTC)
X-FDA: 85143473100.17.2ED446E
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7FCEC40004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:17:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=aMMrKVlr;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf11.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787750268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Me0VmWoWAYHkVt/MT/VZKdgMLOyOPPoKW1qhK464E4Y=;
	b=1AJ4COQW1h6eq/T8c2RPU+yThyIi22sORzh+IOfAVOtdu1qXD+hA/f8obhUkwFtc9dihsZ
	X2xD9UM8Mb8PP3Cc735EGtzlBAGYIY8dIUV4s8Reog4MzQtv6lGX6L77wzQ6q64QpeBgWj
	/2hqsuQlLyURWieSs6ptd3KkAFl2fpA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787750268;
	b=bDXc9U0zfwRD3PYk/5PTV6R40E6T/ZpDHPN5zU5pHfLBBZDvpUQf2x5NiYvWFsrES7CNEa
	vE3//+gfz+J0v6iGYUQzTtL3+Xfe6tzX1mZ+TKoEFtrmdjzXpqOKO0Ns3XzkXIIJu6GEcr
	XtUIuBS/p3kv10B8W8Z3h9oxIdTGLps=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=aMMrKVlr;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf11.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260826131747euoutp02122a3209aaf1a9a4c0bb45050d5ed41a~PXWV2JNYv0588305883euoutp02W
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:17:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260826131747euoutp02122a3209aaf1a9a4c0bb45050d5ed41a~PXWV2JNYv0588305883euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787750267;
	bh=Me0VmWoWAYHkVt/MT/VZKdgMLOyOPPoKW1qhK464E4Y=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=aMMrKVlr5oXAHFFawFLnkYgSa/sThUsBpW0oq1j/1ACdrYDGqS5Tb00SUGzaTMB5E
	 FK22rrgip4DS/1cEakMKGoLD/1kvYjSWDIJCXQQPEaIGe5PK9jNw17H/90gjr+MPWX
	 6K/XdbuAxnUrFfS9nBwInfUfPCLsKttBh0Lb6AYo=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260826131747eucas1p213224e419e6b00c8c84b85a0bedc84e6~PXWVl6Ksu1479414794eucas1p2P;
	Wed, 26 Aug 2026 13:17:47 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260826131746eusmtip12f599e284d828f3483e2e6ed3c54a55d~PXWVCb-nm1351413514eusmtip1M;
	Wed, 26 Aug 2026 13:17:46 +0000 (GMT)
Message-ID: <8948e46d-bcc2-47e9-84de-dd6907cf0876@samsung.com>
Date: Wed, 26 Aug 2026 15:17:46 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 4/5] of: reserved_mem: release dynamically allocated
 no-map region on init failure
To: Wandun Chen <chenwandun1@gmail.com>, robh@kernel.org,
	saravanak@kernel.org, rppt@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260818092420.2859026-5-chenwandun1@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260826131747eucas1p213224e419e6b00c8c84b85a0bedc84e6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260818092450eucas1p1f1d7f5ad5fc8d786580dd9dcad6ce196
X-EPHeader: CA
X-CMS-RootMailID: 20260818092450eucas1p1f1d7f5ad5fc8d786580dd9dcad6ce196
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
	<CGME20260818092450eucas1p1f1d7f5ad5fc8d786580dd9dcad6ce196@eucas1p1.samsung.com>
	<20260818092420.2859026-5-chenwandun1@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FCEC40004
X-Stat-Signature: dcd5qzutoe9g95roi4czfbpu8ok7ye85
X-Rspam-User: 
X-HE-Tag: 1787750268-990804
X-HE-Meta: U2FsdGVkX1+L/5HAwcoEWKZlwpb3qBmF5R/tHu8oX8jm0BO34WbCTXB8wbsnmZfo5VnecmbvfaHSYnQANqLy6OR/yZpSR9dWgki9hxtyo4oWsOt9tSyQUdIBDUiknTsrO1k++qcu7YVAPr8a8Kk0C5MlpCeNovokg7/T6I8HM0X7EstQgocFuj2WUAjqKEC2xUsx/PK+72wtXx4t6g1EkKQ6eYXzKbxKs+D0FCnjSZF2prXWp2srj004fepQfZzOeuu/ywaRgpnFbmsVRyt7RQQ9/S6xlNMHxaphNI01pK/RcN2vZ2Blx+Sc+Ltn3hmxqzbu7mbeKisQc5optBT8pExJ3iq4eAfnA/+myRQwoUsxX08Zd3Xq9XePAJBJTXvhMIe6Ja5jOT1K2/cUHJlUzZjAbBuXS+Lfq5iQrqx2TobWrjAfFOtziEyZJt9sm+9v1PEtOB6B4QM+/nUPZfvGoYSGPW/a6idGbQCunCJLrX2Ca/ymxRqJjFFkgfwroGGZIC8bBMIYCBOcxuNxS7YZGYrU9Sbu/w+vB2E4kqzrYzD+p4MVPBIBJwHM0QrO8SwhmtVq4P7Xh5VircGi7Oe4sAICGsUzhIL4zFMj+rE0s9zWfcfw3YUvdMZFOpk9RFT/qAhBch2/shhwDyrrbchoROCXWgMzqOpJIcN+uObsGNQuewG2qJ9hY1L+BGALlQ8w4e7uK6a0DeEWE5T3vDJRzY6Q52Nt49Q3aKJt54DSeHzp1gYBExcoRVhCI/Sc+5RVqACVSfHxlMurZ3t1X7lr5oolOP3tvRs6eJKl48PHlf+QpyRkpCiw5mEKPqo2LCR6QzeAHKD1qYpQvl2ImdGTdUIqPZobitkeFE+9G7NEo08twBCXycuJSwph9+dIFVgVwP2VWdg02X7LRss0Qi6j6bfSmlRyfUnXE28ByAUgOTIVVFZcsy68qAYVxeeU8l1UfUBf2VlEPq3BZuGUGs4
 HyINo+yU
 wG5leTzY8vaVlXZ1zr78Tqs+W8kV4LDuozJApvrUHxE6UZoZBuGk5e9ZSZU5CxSufnqBBKHx2JB1Wjk0XP0MAiJeIp48KEAV6lTwBQXdlQMlcfOClzo2f88p6ovA4JeniHrlfFFQ+H5ahnyqJ3V6rMwnLY8rQx5MpGhwpsLbyIRj7PoM5DSkdPxNMJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.2026 11:24, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> Dynamically reserved-memory regions are added to memblock.reserved by
> memblock_phys_alloc_range() during __reserved_mem_alloc_size(). When a
> reserved-memory region's driver initialization fails,
> fdt_init_reserved_mem_node() cleans up the reservation. For no-map
> regions it only calls memblock_clear_nomap(), leaving the range in
> memblock.reserved and unavailable for normal memory use.
>
> Fix it by freeing the region on init failure when it was dynamically
> allocated.
>
> Sashiko found this issue in [1].
>
> Fixes: 7b25995f5319 ("of: of_reserved_mem: mark nomap memory instead of removing")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Link: https://protect2.fireeye.com/v1/url?k=37bb3269-68033acb-37bab926-000babff88b5-00648778f1201363&q=1&e=40542077-d5ad-41ca-88fd-1cf102a816c1&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fmessage%2F20260806100605.2C2C01F000E9%2540smtp.kernel.org [1]
> ---
>  drivers/of/of_reserved_mem.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 767ef702392e..ac5db19dcc93 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -136,7 +136,8 @@ static int __init alloc_reserved_mem_array(void)
>  }
>  
>  static void fdt_init_reserved_mem_node(unsigned long node, const char *uname,
> -				       phys_addr_t base, phys_addr_t size);
> +				       phys_addr_t base, phys_addr_t size,
> +				       bool dynamic);
>  static int fdt_validate_reserved_mem_node(unsigned long node,
>  					  phys_addr_t *align);
>  static int fdt_fixup_reserved_mem_node(unsigned long node,
> @@ -352,7 +353,7 @@ void __init fdt_scan_reserved_mem_late(void)
>  			continue;
>  
>  		uname = fdt_get_name(fdt, child, NULL);
> -		fdt_init_reserved_mem_node(child, uname, base, size);
> +		fdt_init_reserved_mem_node(child, uname, base, size, false);
>  	}
>  
>  	/* check for overlapping reserved regions */
> @@ -567,7 +568,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
>  	}
>  
>  	fdt_fixup_reserved_mem_node(node, base, size);
> -	fdt_init_reserved_mem_node(node, uname, base, size);
> +	fdt_init_reserved_mem_node(node, uname, base, size, true);
>  
>  	return 0;
>  }
> @@ -676,13 +677,15 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
>   * @uname: name of the reserved memory node
>   * @base: base address of the reserved memory region
>   * @size: size of the reserved memory region
> + * @dynamic: whether the region was dynamically allocated
>   *
>   * This function calls the region-specific initialization function for a
>   * reserved memory region and saves all region-specific data to the
>   * reserved_mem array to allow of_reserved_mem_lookup() to find it.
>   */
>  static void __init fdt_init_reserved_mem_node(unsigned long node, const char *uname,
> -					      phys_addr_t base, phys_addr_t size)
> +					      phys_addr_t base, phys_addr_t size,
> +					      bool dynamic)
>  {
>  	int err = 0;
>  	bool nomap;
> @@ -708,7 +711,8 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
>  
>  		if (nomap)
>  			memblock_clear_nomap(rmem->base, rmem->size);
> -		else
> +
> +		if (dynamic || !nomap)
>  			memblock_phys_free(rmem->base, rmem->size);
>  		return;
>  	} else {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


