Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5014FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33CC6B0092; Fri,  1 Aug 2025 19:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0BC06B0093; Fri,  1 Aug 2025 19:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21C06B0095; Fri,  1 Aug 2025 19:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A41996B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:08:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 508D016031A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:08:11 +0000 (UTC)
X-FDA: 83729728782.16.3239519
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 88C6A80010
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:08:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dj4UyGcG;
	spf=pass (imf30.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754089689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0S3szeJAlU80mk+/W50EtKyLt6yvbLEZazkw9uRti0=;
	b=H6ixASxtpEzHpFIvM2hkodvuewDo3Z3w/HrPINii+KHvlWJs67RpxG6I12yPtYa5oyA39i
	pV4DXhdupGnnOk4jBhECRjS4kMLYTbudoVBiGyJhrnEnBxtuwbXinFrojq77hcEriY5wL6
	GrcEGk7Tv3xDe5AJpwqDY0u4Hlik/Cg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754089689; a=rsa-sha256;
	cv=none;
	b=J/j8h+cG3pDyqt0N2g6FKx07JaD3yWov5NTyo32h93YTUgddijmwhWIxaTF+8gPp3WsKos
	6YW9VxaoRjMu0q+W3Qlek8zySlEdt0gis67/DLmeAj9kWML1/yV+fpBY+HCV4tMTQ5xjXl
	5fzC9dliHGvoS/rPW2Ht7gSe1/+M2I0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dj4UyGcG;
	spf=pass (imf30.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1175044014;
	Fri,  1 Aug 2025 23:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96870C4CEE7;
	Fri,  1 Aug 2025 23:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754089687;
	bh=6pOY9vWaKIl9etre7R8PY0gT1B9BcwDb9n4CCJLLzNo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dj4UyGcGbuIkBc98+22HPLqigl8NgNkMOdvw1zAqKlBQbRiiBxUzvRfWrVyzOtC6D
	 cjuiqHDMdxYBp16KLznBJPAhgVMiEnno49wryNNiuQ5AIayb0Lzi/MAMXBDmJHtduV
	 atkxVrhkNH6oExT6DhZwgH4YEXVh0epCd6rbjc37Rud5naxpUDu9/SX15b0QuZeA2G
	 Go7Lyxio35OeHyJsgXdE/F2mkL3LAAOw5HayQ4Me9AMRRIbkXeJ9elEBJHllp+5v7C
	 4RpA+plFtMLbsK5xWsInIJVj3hWYYCznrcH0gHUz+H3oxe5ida+og57qZTFXSnj0Nh
	 B4pJak/XeYcjw==
Date: Fri, 1 Aug 2025 16:08:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
Message-ID: <20250801160805.28fa1e05@kernel.org>
In-Reply-To: <20250729110210.48313-1-byungchul@sk.com>
References: <20250729110210.48313-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88C6A80010
X-Stat-Signature: jzwgo3e9du5yc6o5wteuotcqxu9n7aok
X-Rspam-User: 
X-HE-Tag: 1754089689-535013
X-HE-Meta: U2FsdGVkX1/u1ODRK9Hk8ggYrxRbKO2cGAzP3QU95US/ERZFIXYaejoaaSjAxIk62hJGDFxzwtkaOwk1qVQMaaiaPdElOcqr9PKps8QUvZpAQcd8NQZ3Bs5J2OQyJD8gOnCSx3kFTx4Qa2Ba3sAQmu/Yb9hPuY6jTgJKUhr0YbpfsqmvXKvUbF0m0GK0L2zt5lx+AXMDNCDbTQl2iqoDhoiO/ONPr1hysp7zxd7PVZv3B2DUw4U9UXZHx7mGuTKGgRM+0hj0xk3HJrJ7kSGqX0C1JEa3z/pAfQMMMjVUeRb5GNWz1ywp/VGjkHmU0FoB/FQDTLUeYQAr271Fnw8N5BfIDV8lzEexrEQ0PkNmFXkdq43h0OHT881xhTy4ITLQ46n+Sxy4Xeaikvn9milz0W4gr8456TDqdT/YswqQk0cxDn6/UIO2vDpiV3c2g/Aj2UG03ivyyZE25c4XJ5Zp/DHf0ylUIkK2Pzk9qceSPbEKOPoEYQMjY/hpYS9biXBD44jU3UQMs9rxzCVhs+mx5Jfvc9KjtRyZLXUDzfIJJjZ5Tgw35q++9N38eU0ohTvfwiFqrEcXdgkhGHZUvFzeR1ChwjGfL4h3Ldjv6p8mnY3YhxBH1CNaDMGDeAti0A7VJpAZYUcUNOkEzqslxRSlcbr7PmNfDwjJoCYw/AJ8z83rsr3IiNTMyJwxHXsFpygibeZ5jYJw1GF8jHj92gMpxTnDa4/MKFNUH2q8EiCEKVtqZCEFpKfXpdqX4G2IhGuLh3crZFdK0DA0D8hhRceMAJ7DEvlApOD9jWqdtg/pOW7XfqS0vyEzoI7F2ZMswQMxVNQ0wmPzdN/xaCwJvoy8HZV9IBHxFWY4a9tb3dHHBDPF87JlERtejhI+xilvxw43CiV07kMEA263UlZCrB7E9rhcKlaiUlbg92HKTrnjRiM6VUHjvX1FSIqe+bt+9kQU+oHxMJeArnOqHPMK/XL
 mPNgCX/Z
 ti7kYvvNVH4lWpd0qnrt5m0mnJIVomNbc2Hm7lW9CffIkg919sRTFzasVsvQmiQ+UQwreqCFiuvfu/xhH7JPmZNZ3KOosrtzJcCkclGV1KlnHHydi76vM3twsnrmZa/WvC7F87MrnL0kKAelw/9iszfKl5f90ZSfnagwd972/LldcQQBahKCbd1AOish4ZxgXq16F7nzRX5z4pWVDDtDOc7A4GPSJHoz8E6NWA85rx3qo1IYLfK4JbaL/lPLovBF47OHmTNog6w6A7J46mt3Qx3NYobND3Ecyk+3Q4d/l+8mrkva4yseskkPzYcBbMnMLg1wHdmMEJdwNxVedPhKU8YTqFcvfKgcVGR+LlhYwsb9QbBmaCKcwIqK2gRLjDvukGTUfsdGbnYOt4bkDB7TcLoLq0upYYng0P2gj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 20:02:10 +0900 Byungchul Park wrote:
> [PATCH linux-next v3] mm, page_pool: introduce a new page type for page pool in page type

linux-next does not accept patches. This has to go either via networking or MM.

> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {

Maybe add :

		/* networking expects to clear its page type before releasing */

> +		WARN_ON_ONCE(PageNetpp(page));
>  		/* Reset the page_type (which overlays _mapcount) */
>  		page->page_type = UINT_MAX;
> +	}

>  static inline bool netmem_is_pp(netmem_ref netmem)
>  {
> -	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> +	/* Use ->pp for net_iov to identify if it's pp, 

Please try to use precise language, this code is confusing as is.
net_iov may _belong_ to a page pool.

	* which requires that non-pp net_iov should have ->pp NULL'd.

I don't think this adds any information.

> +	 */
> +	if (netmem_is_net_iov(netmem))
> +		return !!__netmem_clear_lsb(netmem)->pp;
> +
> +	/* For system memory, page type bit in struct page can be used

"page type bit" -> "page type", it's not a bit.

> +	 * to identify if it's pp.

... to identify pages which belong to a page pool.

> +	 */
> +	return PageNetpp(__netmem_to_page(netmem));
>  }
>  
>  static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 05e2e22a8f7c..37eeab76c41c 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -654,7 +654,6 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
>  void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>  {
>  	netmem_set_pp(netmem, pool);
> -	netmem_or_pp_magic(netmem, PP_SIGNATURE);
>  
>  	/* Ensuring all pages have been split into one fragment initially:
>  	 * page_pool_set_pp_info() is only called once for every page when it
> @@ -665,12 +664,19 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
>  	page_pool_fragment_netmem(netmem, 1);
>  	if (pool->has_init_callback)
>  		pool->slow.init_callback(netmem, pool->slow.init_arg);
> +
> +	/* If it's page-backed */

Please don't add obvious comments.

> +	if (!netmem_is_net_iov(netmem))
> +		__SetPageNetpp(__netmem_to_page(netmem));

