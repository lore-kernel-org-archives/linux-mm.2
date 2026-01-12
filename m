Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B32C9EC98
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CAB6B0005; Mon, 12 Jan 2026 11:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1556B0088; Mon, 12 Jan 2026 11:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A274C6B008C; Mon, 12 Jan 2026 11:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2DD6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:00:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D1C213B4C2
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:00:30 +0000 (UTC)
X-FDA: 84323774220.04.D7EA946
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C41340018
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:00:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f6Hng7b8;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768233628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AwRDVpeM17EEeoZNK0PaKuSBZiZAhHoUWQufrk7k7lE=;
	b=SOFtrXl1MOrV1gAq1mzhJ6FGvfclvh9yXHK0HGeKZwv7O31NeRpkA2wj9e0EYRjOsz/tIW
	L4l0KbKzoabisrJA04TQJDdGeGQ021S7kw+d7bnNbDFUAlVLo6jl6Xf5Gki6qnUPrEvqLQ
	GFxoZYWy8NwHb7YwzWyUwdViH1HQ6MM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f6Hng7b8;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768233628; a=rsa-sha256;
	cv=none;
	b=7PqrQkOUDjPMoIhiu1bo/y0cAYqlQE+qZY0UCewsclrOXQlQb8OjWLND0x59PXO1ZvzpBL
	rI6MXj9ML6jWciYjltoTtXroKAIAnD9xV44Fu4QiK/05Z8hkEe7zIVVf/SD+LdvesaqcWE
	gDidWOP+Wg090R4PVJMBygTbPS8RpzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3291043F7C;
	Mon, 12 Jan 2026 16:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEBCC16AAE;
	Mon, 12 Jan 2026 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768233627;
	bh=n8113yOzN7lCcBhp2c/oOHNFTBhReGgKAxXLFYobadM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f6Hng7b8ysqnPik6LRV6KI2gsl/gCP0Ex7xxE0CTTs7XUWw6RpgMk/YE0Yn/Zc4gB
	 OPimihWQRb5oxqtFTCkF6UubzC+yZF4wUwY6uQnp4yRQb4HZvMuoa4dDRGFZKiKcLs
	 sFMzSztvR8yUduEtWPOMR+xAvyPGUgkvkHs2YF+vHMbTApwxwWdfKNMzOEzKnKPPZI
	 6ksVctSS1mopmOsMbH/5XvTvzvC2Yh7uyKhGnaWtbBYjOYEwtl/yG+R0sJH2nFcGrQ
	 ZJzRpbLhrL+cJXO2f0sqj8Ieosi9oDsn3DcnbM65a3VvBF/sqxO1fWvVkDbN0XeFwg
	 /oMyVKO62Y5LQ==
Date: Mon, 12 Jan 2026 18:00:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH mm-new] mm/early_ioremap: Clean up the use of WARN() for
 debugging
Message-ID: <aWUalAtwkLgLNt3F@kernel.org>
References: <d4470531ce0c03fd80f9a1be7e8d8ae1bc60fcd1.1768220636.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4470531ce0c03fd80f9a1be7e8d8ae1bc60fcd1.1768220636.git.houwenlong.hwl@antgroup.com>
X-Rspam-User: 
X-Stat-Signature: fii49qk9qdh7dsxc5a8oxxugfzduyf8x
X-Rspamd-Queue-Id: 6C41340018
X-Rspamd-Server: rspam04
X-HE-Tag: 1768233628-529989
X-HE-Meta: U2FsdGVkX1+/KFms1sNhVfK0YdZVafyAW8AwlfQ24MGrVECj+9gw7Ks2qDnHypOcbwA7KfbGCDXrc9UIIaW6YTG+/jqxZXjUrAqRIDbCJtaYidM2g2H8jXXo5Es7WQKkHNTO1i7cVxkP3kyqCDfpdnI6UjI3mNlie4FfVIfXF/8cMkBClhhX2pqKy9d0R56KfNXAVHnky/PPgEu6UISrkAakjvOsNAqxe0Zh1LowHVGynjhi1W6J2RXbKJZ/Uw0f3tsR8h4Sx67PTYAukXUsqoXEHSckyMgevGXRx464ZA0ousxN4OTsVWhe8t7YXpULETxAm5Q+5u4KLD6D+sv4qgRXxwtFifZMAGFliwHnEEwXpIK5OSVwPbkoxat7sokBRM1xIacSFk/TaByepP3tqgUZmjL9wUq+4ff73S8v4gtZiPjCYxK/mVwCA8QHEAnN3lq/934+sh6lQHzaDzZBJk++JzrSjX5dfhk+RtNgLbBjQDiJWJ7/78lNrdhwOwvprsV+ak6M/lTlp7QpaSEbY9eoudducUns+ivv8GHTbXejBJsH+QDQKr+LrQL5oRJHSd97knAFN3QPjkqyzCR+f8gAULYvBmMvavQKOs8gh1Er9keM/cGgK6XT3LAe4iqg2XySwpXiYhtDw+KZtYzKw9pZFp+K2OUrlfjvZjl1cHf22hzjpeBpHfn+0Wzy/0ZNyXWbPqwwhlSA0rNYRa6rLRh6NziqzEa80GzsNWY4q1dMB53EBUsgwP9TvNKXGf60H0xOquLQawr75P4m6BihBI1uuD4erUoeajxjMO/nWMyeDruo4LluuNTopmFLJscJtap8Wa7P+pkG4Rxe2Yp+90AGSkqBf57sjk6tn9h7pH7mDNLQOifDxxpPp9DDjhtcWpc1+d01oY5y2kSTYvYpof0LZauKGpYt7//8M8wO8TgywnRcyEulvrJsaJGc5Ec/WjyVuA7wTCE1rkb4PFI
 MeJexI/p
 ZcyeTIDxUatgvrqgyHFS30sHjc7DfRalYrnY46Fl6gMWAB9UhJLHTHun2Dbr8e0DwqU1PMclkpHWNlEM/uzJtvDG9v2hM6+Dh7BBG1jk9KXSWzltfaHFEJECH11vDqOASjCtPuYOem63N3EkZ7htk0r0aVRv1Z+KunHMLG+rRxX6CAnwD2TaueiFbEFK7fxWQiwtSLa63gXaZNJKhsmvCpBEYi7UbPgOCHh7tV4nfQJ2r8sRz+AtWaAPD9YrF1B5+aQ2xBoSqoIvx7q4W8kFwZksNU5XNkLL/i4MKSMxZU4FY+b3NQGKU+SpL+bnC3O6ohUeX1HAeuKl1cKxUWh5LJs4DMo+yIcNFqj+WKKYebb2CdJinzlRQo1JZhkIlEMipHIiZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 08:24:29PM +0800, Hou Wenlong wrote:
> Using WARN() for debugging is strange when nothing is wrong, so replace
> WARN(early_ioremap_debug) with pr_warn() + dump_stack().
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/early_ioremap.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
> index 3fdde074c9da..96c29b9dc85d 100644
> --- a/mm/early_ioremap.c
> +++ b/mm/early_ioremap.c
> @@ -30,6 +30,14 @@ static int __init early_ioremap_debug_setup(char *str)
>  }
>  early_param("early_ioremap_debug", early_ioremap_debug_setup);
>  
> +#define early_ioremap_dbg(fmt, args...)			\
> +	do {						\
> +		if (unlikely(early_ioremap_debug)) {	\
> +			pr_warn(fmt, ##args);		\
> +			dump_stack();			\
> +		}					\
> +	} while (0)
> +
>  static int after_paging_init __initdata;
>  
>  pgprot_t __init __weak early_memremap_pgprot_adjust(resource_size_t phys_addr,
> @@ -139,8 +147,8 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
>  	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
>  		return NULL;
>  
> -	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> -	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
> +	early_ioremap_dbg("%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> +			  __func__, &phys_addr, size, slot, slot_virt[slot], offset);
>  
>  	/*
>  	 * Ok, go for it..
> @@ -185,8 +193,7 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
>  		  __func__, addr, size, slot, prev_size[slot]))
>  		return;
>  
> -	WARN(early_ioremap_debug, "%s(%p, %08lx) [%d]\n",
> -	      __func__, addr, size, slot);
> +	early_ioremap_dbg("%s(%p, %08lx) [%d]\n", __func__, addr, size, slot);
>  
>  	virt_addr = (unsigned long)addr;
>  	if (WARN_ON(virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)))
> 
> base-commit: ab3d40bdac831c67e130fda12f3011505556500f
> -- 
> 2.31.1
> 

-- 
Sincerely yours,
Mike.

