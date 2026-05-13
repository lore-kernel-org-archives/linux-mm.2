Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9ADCCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9AB6B009E; Wed, 13 May 2026 14:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1915F6B009F; Wed, 13 May 2026 14:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE516B00A0; Wed, 13 May 2026 14:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F34096B009E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:27:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B90288B7A1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:27:11 +0000 (UTC)
X-FDA: 84763228662.05.6BE69D3
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89E54C0016
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:27:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778696830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tyI66OdLGvBNo9rO712/TPGYAS/DM8+RpyFPTrVuElo=;
	b=Ak8r+rglpohs19RCMyn5+CnAZd64O8dpPFNnE68nvauY9CxKTgaOq0Z1eqmhNepCh0+qu8
	YrYfQOhd7GfwvYS/KtAYvODcED8pRkkZ2DGi1Soi0WVG6IdbWoQaI/LYBx/3sPmqV3r0LO
	wyzFVuVNiY3lq0gYlF7fjPpD5xnDzdo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778696830; a=rsa-sha256;
	cv=none;
	b=Nslw6nerOUnvwslv0PFRT99QStckoXL/oFCEqsjFt4zrNt7UOpTCxirQPqF2s1TeOKYvww
	xfDHogXWhUr5zfVi6z70Rrqy8fpUsacl5vmVOzUuAx9DFdvrRV0k89Eu2ZURoQoPKPR59b
	lNNAL2ICpdJV3LcT5XHC6nYIeuysG3w=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 14 May 2026 03:27:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 14 May 2026 03:27:04 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v3 12/12] mm, swap: merge zeromap into swap table
Message-ID: <agTCeEuMWJtYN9EF@yjaykim-PowerEdge-T330>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-12-2f23759a76bc@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-swap-table-p4-v3-12-2f23759a76bc@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89E54C0016
X-Stat-Signature: g4y61d79f1gwsqio3nmjzb7ayzk94bhp
X-HE-Tag: 1778696828-13543
X-HE-Meta: U2FsdGVkX180AkxXpOi31UMUHnf9o4LrlYgVNsixIp8r7AS2prJfSlCwnuNb4nFYhnorD4gPe7lQ9vgGJlDOW/wmQoIbswl3xIEkmm8iHUQw5Wt6s0i0GKYXW4TfmOPX5cMiud6YxqvmzqeTBlt2VPnrxhxigohB1k/zmG4PTUT0bcLyGmQwW92jroVWtAbDSoMsORQ8Wl12gZWGMw+w3oG7QbM4AYWX4OxsKmjs2oJl6AawaKQRdixLQtiI5l/a2cnWtcJ91Iju6/IdrflrAx54AOKeFf7Zb5WF/w170wV9dBON3/mu2BgGCF+C24TK5xVGrHudmmCtuysGcYGGAJpqKx1yFoERVb/uuXBRz92yQ0LItE1rmPaR1FRhPqHU6W8x3t5SNE0pegbb3SxPRADcxGpPaFD418r0ETnv3TdRq18+0xr5LNkqq1hyTPMSOUWmMWFWr3MF1MTN68HAkd80hyv31YAHUaSB2C5iT72ARNODVQbpJqD/stnbdJKjNzIpekH/6kG6O6tKXTaMBZKlRQ3EahoF90rIni7uPaW6oEg/J/ACw/jgjPvwo8vzHCaJrUiZshWuH8oCgB0PK2Xrpz7dcPA8MKv0Ixr5gvpq/UezrXd4Fp9Ll0qdepZsVh42X9M63dmq+dgaVxPCHM+6BbHaNOF9LRlSUW9PqCZg4kIo9IGVZyJSwObrbWFTyevHHPaodWzEhqqoUhAHQadkrf0/8SaG6P3zqhap2rmlVduCgkhKvKFKSbr0Dzp8Q/u88ESTHZi2b7Sr8IcfgohdiqIAGX75LLLP36V/1tyMAS0irBHrtXhTTvxWKZoJUlV3S5edgCcOMo5thVJ4kaVcEgmXrIzM+a2AIbHpFX073kvtL8kRWmY5CqMOCDwqeUjGAvAnD0v7rhkVBX7yJT3v7CCt8nYxAtqFpAlyrrJwf7CbDIVR2QeVUDpcuaZExRgQYwLNZXKuNLLFoCC
 eXCpNGkT
 oFIjwyXV4KjuH13xDRS9CqMMrYDYM/Fk7E9QbGy3bVT94e3ioKl+EhnYgFn9q3ikBa5e6wZBFp9djOpWRrFAtc0J3gys+QwB+fOXsrOsYI2fEAhjW0BupQKepBMOAlLIgUlJ1yJHXawK3rzyL8wXDDVyGIx8V3u1icFkG7+UMBm39ATuAJx/10KmjdQLNq1T/XiZvKwPrdW7jpSWTXBagBbuuzHXqRouV++fYZk4F4mdylJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 02:16:56PM +0800, Kairui Song via B4 Relay wrote:

Nice! LGTM

Reviewed-by: Youngjun Park <youngjun.park@lge.com>

A few nitpicks follow. take them if you find them useful. :)

> +static inline void __swap_table_clear_zero(struct swap_cluster_info *ci,
> +					   unsigned int ci_off)
> +{
> +

trailing blank line. 

> +#if SWAP_TABLE_HAS_ZEROFLAG
> +	unsigned long swp_tb = __swap_table_get(ci, ci_off);
> +
> +	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
> +	swp_tb &= ~SWP_TB_ZERO_FLAG;
> +	__swap_table_set(ci, ci_off, swp_tb);
> +#else
> +	lockdep_assert_held(&ci->lock);
> +	__clear_bit(ci_off, ci->zero_bitmap);
> +#endif
> +}
...
> +
>  	table = (struct swap_table *)rcu_access_pointer(ci->table);
>  	if (!table)
>  		return;
> @@ -470,6 +475,13 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>  	if (!ci->memcg_table)
>  		ret = -ENOMEM;
>  #endif
> +
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> +	if (!ci->zero_bitmap)
> +		ret = -ENOMEM;
> +#endif
> +

memcg_table above uses `if (!ci->memcg_table)` before
kzalloc, but ci->zero_bitmap is assigned unconditionally.  Both
are NULL on entry today (swap_cluster_free_table nullifies them),
so either form works but the asymmetry reads oddly.  Either
drop the memcg guard (with an entry VM_WARN_ON asserting both
NULL by design), or mirror the guard here.


