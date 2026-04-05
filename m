Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9625BE64014
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 07:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438E06B0088; Sun,  5 Apr 2026 03:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B5F6B0089; Sun,  5 Apr 2026 03:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C556B008A; Sun,  5 Apr 2026 03:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 104926B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 03:07:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72A38BBC6D
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 07:07:25 +0000 (UTC)
X-FDA: 84623621250.24.996E876
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C0D0C1C000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 07:07:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9O82ylM;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775372843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpL4ijEbUECggDcqUNUkDOyu4qSsZc537hx2cfM4pKw=;
	b=SaRwof64BCTaJTsu5ahPhv6IdUbzBeZlhUMpRyzHPtShiDpVCb1CPHr2BG6gzMkuxQPPwv
	WF5FIM3Bn4o5sZJH3W5CsU2SFAZL6BB1aoavJmK4wl/X52M3b7p+SirqbFTxULdsZ1Ky4x
	Zh0+tyesf65nqUOhTe92i3NbRSJde64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775372843; a=rsa-sha256;
	cv=none;
	b=WLMEEfLucMOGILiJZf1Y+QPf07D4CV6xDSZrhZK4r1kXdTXz8NotH6ofpFe8wv5mBS5+TN
	UPiZOjTcb1ifEtvzcefxc1KEBACLWALqA2k2a8akC116JcRFAhhICUP6vhyAq/Qepc00bG
	wcCowjy4Htyc7DNW5h8EYYc0dH8VAA4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9O82ylM;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 797C741728;
	Sun,  5 Apr 2026 07:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71541C116C6;
	Sun,  5 Apr 2026 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775372842;
	bh=ohaCCzJ/OyCQHyLoFW3oiQ6UbSpvt0apq1+Vo/peCVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i9O82ylMyOl+wffziX6EHyuKjfZRNOtXBwBb6x2Hg7c6kPg80cHo7ELy/0MCqL7hM
	 zzJgRcwLV/uuF/9OKHmDyL77CuR9VDSx12X/updR8lgoF6BSDTtPvgF27mrBLA42YZ
	 CFFehpXSQqNLVVCdEnRvKBvi+rExumtbNx1Wj+1up9LfvMSwI0YpDP7d4ScIyBzM9x
	 yfR5FMLbQ1atusilXnxq32F7XNd7iU/5SwKgCH6URQBKQ71r5hxIzqA1/6vwLjUzNY
	 kzqgWRyHCBokcS+i9cmrqJ2yVxXMFNOA/XKsXXGVZ0iEINkynHLLaopjI1tX4qEA2W
	 sYWRmBmFLsEdA==
Date: Sun, 5 Apr 2026 10:07:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd() and vmemmap_check_pmd()
Message-ID: <adIKIhRL6q2NIgnj@kernel.org>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
 <20260404122105.3989557-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404122105.3989557-2-songmuchun@bytedance.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 8n3wmr8t735q3h418p7i9ipamr4jnn7s
X-Rspamd-Queue-Id: C0D0C1C000A
X-Rspam-User: 
X-HE-Tag: 1775372843-402620
X-HE-Meta: U2FsdGVkX1+Z1NuX3aKYclrk+19Z6xFBNNCCqQWPem7bs/92eRZODYZNCxwPwR3uwKsT3Q3a2NxynMeSOFJJdpTxb/gPioklqg0e1vKyF1yJ0ELQZeHgVmFEirwBMC93fNe04t1nEIxsNsHupKRfpy9PodKI3mnxAsZNDtq22z6K640eoNeZojL74sQ2AHO5DPv4DGxyKX1SaIHUPUW4rlGPhE8CaE0o187NG6gUzbVNWyFSlTKlwXJNTr5ErYEbazJiKdyDYABhRvwQDHXQgq870sQRR/Uh4wEFbymDAuQRZPJAaEAIuyF7SwB/uDLkvr2olRZfy0Rba9qal5Suh65u2ItQ7n/Fd8AxZ3gTbEHiO0482HArmnUX+S75dLb9XCbBH2PNyXo3c0Ajmxi6NztVBPHQHm/usIYl4IA11aWymU+a4b5SP303Tp/YMOWpoNe1E7hEbo8o+iTcDKramYtpORI24zdlyaua2eZDJvrEqLXcKOkAyioy6Sl+Jkj4MBiKnYrAyo2lWDiAzclkfrFNM3uV1AXt+V7A6WhGrAs8bbZ3Eum8xUVXJ/I14BSSP0qOZjgv/BbLDbJ/1lX8mwh+H8+mlbcsWkrq+bUiH+uhPWKCVZQrdkESssFnC4CfNBTln4+Lg8PFjdKZikwANSV8qx+dGsXjuYCb3llg/pPJ8L4YNvHQVs7s/xdsx+V4KjyQQC9YJAtZR0EMOGOcSYWSIE3kcl/Uhr2iIPfuh0BjLxXsMcvLRTmvQNljlE4eQFBsisJwBuH0KHbZnEqrunb0KUVXTSCs5sFHwv4YA/KqM4Pgy8+TYmTROlfSzmxdAD23X3kkYD35zHv0Mvw3obV9RuaYJzkDBwXKhZ6iyGDMn3MaFGImSzX9KW6uSaI31d50uepLqwrVYy2vE7fK26m99yoBYwpICqG47jaiB1hZNlNGCkksJMo46wCZ8KY9YBp4adOLqGEObP1d0Wd
 XTn4UZa+
 cJV5hqTMuBrhi+vlUlzez4vPZT0OQbnVLQ8mqk1XqsofulE69TRBF2Jrw7Sd7JMEKCsZwEwuwiMTCtpVpJV0t7np+ixB1T4BLrZ5dDsmceGEc+WDnYpXvFe0fN38bSHcASszieXr8VW5LCA7gv+tsHMP4BT0QiHBRRckWCiFRUiGajAtxGLbE4IjeXhW9LsIYiY7Sl2ec/TeF+70ZMec9qiMe3QV8QfOLFIytepGerZP8XwDvCBW/G5zAS5mzTO+wxngQSNuMsj7+sOuDeiRTTTZfoNu1ZI8SGRAxqwWpjkxKdydLKInIMsFgE4zp/iWAPjZwTwqwGqMFOh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Apr 04, 2026 at 08:20:54PM +0800, Muchun Song wrote:
> The two weak functions are currently no-ops on every architecture,
> forcing each platform that needs them to duplicate the same handful
> of lines.  Provide a generic implementation:
> 
> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.
> 
> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>   then calls the existing vmemmap_verify() helper.
> 
> Architectures that need special handling can continue to override the
> weak symbols; everyone else gets the standard version for free.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/sparse-vmemmap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 6eadb9d116e4..1eb990610d50 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -391,12 +391,17 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>  void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>  				      unsigned long addr, unsigned long next)
>  {
> +	BUG_ON(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));

Do we have to crash the kernel here?
Wouldn't be better to make vmemmap_set_pmd() return error and make
vmemmap_populate_hugepages() fall back to base pages in case
vmemmap_set_pmd() errored?

>  }
>  
>  int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
>  				       unsigned long addr, unsigned long next)
>  {
> -	return 0;
> +	if (!pmd_leaf(pmdp_get(pmd)))
> +		return 0;
> +	vmemmap_verify((pte_t *)pmd, node, addr, next);
> +
> +	return 1;
>  }
>  
>  int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

