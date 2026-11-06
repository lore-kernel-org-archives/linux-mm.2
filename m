Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA86606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 21:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHkxMzoj
Received: by kanga.kvack.org (Postfix)
	id 4B2226B05B0; Fri,  6 Nov 2026 16:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464C06B05B1; Fri,  6 Nov 2026 16:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B7D6B05B2; Fri,  6 Nov 2026 16:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 153CF6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:16:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A79F24020D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:16:17 +0000 (UTC)
X-FDA: 85405952394.07.CAE378D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17821C0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:16:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHkxMzoj;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793999776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGIry59/kztjQjrt6vun5/zmI1Vxrfxdl0pZwMKu6dk=;
	b=TDTdRDZ20isK+V/YntJgmEPpKJZcRAYxC7seD6Zlwzv0Tmk6Bqp3oYr/qzNfzrcPClBxcy
	WAk1J/HguB+Bmgi9OUuF7qOTuawbZ2icfJSV/F6Nr596UcAvdicWNNMMtqUFNHiLoWCd3Y
	aaH6kv0znVKWLXB+wIj3Uix/vHrZ2t0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHkxMzoj;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793999776;
	b=M6Xvw6WfjDCqngXflD7V7p8UCFDucfSn5uF2p5ww2X7X1QKxjpFaLb+1VnCfu7fLLoS4xQ
	0tm0lrh9OUPPCnsYGz3K53fWvJNMzZb9gBbHPHLUd1viHehgMcM6OOctdMXXXvOSu8tynf
	PbMg+I/yVyDaK2zHjpuVqr44xBNx5xk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4EF060145;
	Fri,  6 Nov 2026 21:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224811F0089F;
	Fri,  6 Nov 2026 21:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793999775;
	bh=lGIry59/kztjQjrt6vun5/zmI1Vxrfxdl0pZwMKu6dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KHkxMzojGNv82WuwiAhohEz5muS6LECPJGM545RBj1EfFNYtPurIgbEssNtN2VQLx
	 8L8OsE2Lkv2BnuGTihJubUE/ExDn4RDMSpFu7LorsuwNEV+8WcZQCnu3P+Dfvixu5d
	 a3Vh8AFreDjKwd2g9bMyFrz9x8dB+mhfyKxy91vMN+ZDjh1Mwi3Fa5t4ASSaHqxivC
	 UW3uS0exUkF36cOnL640O0PfBs61LoFpl7clTBXPKybP4+eXwURCpDBWCevt+vI7ay
	 rDQgN9C83HQMOAZdaa03R0awimi3M4Isxnjgt7RQgqn/Z8joo5eFkVENzxge/Q+P0x
	 aCbtD+foXHZDw==
Date: Fri, 6 Nov 2026 21:16:12 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, chenhuacai@kernel.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, qi.zheng@linux.dev, 
	luizcap@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v9 16/32] mm: zswap: reject high-order swap cache
 allocations backed by zswap
Message-ID: <au5CgmSHCebwhNMa@google.com>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-17-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105183940.2236717-17-usama.arif@linux.dev>
X-Stat-Signature: 95r67dqdswbhykm7kmfry3hkawyn5swx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 17821C0004
X-HE-Tag: 1793999775-414422
X-HE-Meta: U2FsdGVkX1+LnNa66HC0Qx8dyDvl6n8BQa37HQk8EZ6jG/OOwUOq5HRN4GZ5FQC7wh9OEjmX4dEIwtYvYDlKwjISSpUjRIvui/BE3n4JlZBHJFsTBHGMZOG132LkF4izkFaCO1khWd24Wwku6jT4NTkS8pmN/HNTv9Np5oB717KjHHzlTM4Hk0tmJDJEO1mttC4UQyEheIB0olwOo6tpmXgrEvBqPTqdhf7LanXdZNC/ov3V6BwWjC9GA1Q4cb9wBLROTkZgBoJUFQLiGm0p1wu2Ucve0b15MPZBK3xZ+Bm4f6oQ8I2j8Hk4UFT0jgaNQoHXhXsMUo/3ybUWB2dB581Xkz/ZGOfa74TronHXJ2rQWXi1Ne8Uy1M4DTrZr3lN3DMfMtV449lX0QmwX4IpQMHn+OOieX39kPSBBhtGmd7m2LnhCWbwwGOp9H7YCxkT8Nd2etjKZGV7SB2+X15dgAJkUaQYk6o8kOtZrK15CyF23mW0jD49/ty4w2X9iqXnN/TSY9rmK0a8g1eIshw5l2ckxaCOjYKbwsWW8pWO+quJOKS5Gz1RDGCiM6L+2wLpNXYngBPH1I3YaZk5R5epKYvtWeYrKjyg/Cs43qb6RWwHKDGcTmI7ykXHSH1i5jwKA/VDbGLDIcAmGSHQpzZ6vtuDA6r06Xdst09ZO+DvGjbJH1TIn0FyjXbYHvL47yP5TpbkMroLvtXF92wUrcLRrO/JTz/tVbJQbsMu83GAT7gubMJIMi8PgSgcv0wGC5ruVsmSCkUVjTftAV0SgmOpyuqUX10oX3jmkv+39XQpDjKmc/+F1kvKuWa6MIcodWkZC3yc2ec7lPlsf9apGIaPLXD5CZUv53JvhuySmMoLa1ArKDA75OtyBxM/ubRvJRaez+jo5ODRc/MP2crBIt9pEn7wKjo13WX7JQ/3AG0EvTY1S4Wp3IbgZomiA7ZEaYSUjjIw5YFzbXDGpkqWCa6
 P1VPrysM
 Kvs13nEXkBD96bREPa4eVha01vIGXhmNnv7Y/H9kEojJPcrgXYNFJbmLHWYLLfio4Suf54tHTD3i1BuwpENvRTjynZjOdqAa8a/m2WzGZIFBkY8e8FhT2HDGE+d7XSiyNo/6hSUQX0yYayfUWWpDNX+OgpBywnUb04NmTflkevYtCzyrcS/mcGhx9kZT4M/Ht38rR+wP25iP3YBCjkOOmpmaNxf+qzmILiiuCXtleImjvnI1JWzrSkwDWACUQCifJHx02j6rG8+2Th6dD5EQIPOLHsHTJSR04DEa5EQfQBGbbdVqzWsDpSIzo+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:39:00AM -0800, Usama Arif wrote:
> zswap stores swapped-out pages one at a time, so a range of swap slots can
> be split between zswap entries and the backing device. A high-order
> swap-cache folio over such a range cannot be read back in one go: the disk
> read would return stale or zero data for every slot zswap owns.
> 
> Reject that in __swap_cache_alloc(). Do the check after the folio is in the
> swap cache: from that point zswap can neither start storing nor start
> writing back any slot in the range, so the answer is stable. Callers
> already fall back to order-0, which zswap_load() handles per page.
> 
> Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/swap_state.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index a8a486b0403ab..f41e740a91b87 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mempolicy.h>
>  #include <linux/swap.h>
> +#include <linux/zswap.h>
>  #include <linux/leafops.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
> @@ -482,6 +483,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>  	__swap_cache_do_add_folio(ci, folio, entry);
>  	spin_unlock(&ci->lock);
>  
> +	/*
> +	 * Now that the folio is in the swap cache, zswap can no longer start
> +	 * storing or writing back any slot in the range, so this is a stable
> +	 * answer. Reject a high-order allocation over a range that already
> +	 * has per-page zswap entries.

Probably worth mentioning *why* we reject the folio is part of it is in
zswap.

> +	 */
> +	if (order && zswap_is_present(entry, nr_pages)) {

I am curious how often this fails in practice when zswap is enabled and
how often do we end up churning the lock and swap allocation for no
reason. I am mainly wondering if a lockless check at the top of the
function would be useful.

Anyway, this looks good:

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

> +		err = -EBUSY;
> +		goto delete_folio;
> +	}
> +
>  	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
>  					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
>  		err = -ENOMEM;
> -- 
> 2.53.0-Meta
> 

