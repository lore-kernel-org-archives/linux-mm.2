Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 904B3D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 09:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010C96B0088; Sun, 11 Jan 2026 04:14:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A596B0089; Sun, 11 Jan 2026 04:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F536B008A; Sun, 11 Jan 2026 04:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D02C36B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:14:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F940D021C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:14:45 +0000 (UTC)
X-FDA: 84319122930.15.AC38FC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DC287140009
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:14:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JjqqupCp;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768122883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovxgaWEWtvoH4l4+eP0byrY57HYSCoOWbDCKt0O04Bw=;
	b=xFnzVe5yBn+dOoPLD+FF0yzYbYFstTypAwmYGpMgEcf51HQgoZ3cJ1GHVyx1Wi98XIUv7x
	2sYHre86oDWX1hbu2hG/BTPk12063oIEWr9zcFExtP2DJ0SKfV+l3+/69bBl3q0im5WIJB
	3yBC+/wfobu8vRkE9f9QO81si4dR+2Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JjqqupCp;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768122883; a=rsa-sha256;
	cv=none;
	b=Q7W1qNFQtgUPLTzmAyYEAB1gsQI+HZlxAfvZGr8VX4CDmNVjrny2bG4FbXNrfRIUV5z05z
	3/mtd3f9cwLT+ubZhcob+uq6v8Gqa7CD0IiZr7o7QvOzapwuONVMcUEFdf2OXWL+Q8gm2M
	tKuPaBNVZDxZ6PGFiyCkRJJhDrCHQw8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5278860010;
	Sun, 11 Jan 2026 09:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1ACC4CEF7;
	Sun, 11 Jan 2026 09:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768122882;
	bh=+eIiB8wmKtBPZLFPA5HPpiKv0zBcRE9iGummK/Yx3RU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JjqqupCpx9hXZySMzpTrZ5nm4UXE/3Ks73i14xJ2Px8oi8W0uD7ogFg4fPNv+YLXb
	 FysJcwQAH9ajB/A0X7wY24nfNFv4I22VKrilRzG4YdukB6qQArOguyYYPu6UEE0iiL
	 apihL5iIilppttMfk0l+UMqrCm80DSKAEMhdLcW4YMaFq/iHMQWxgtu86wM1NT412B
	 o5bUneTj98sjivf7ZBKD6cYS7n0eZ/c5CofLNkh8Hbw/5LXj1uDsKoyxDaX7nwkYat
	 iqdIfnK1hQcT/JD9tDxq24QIPalsPil06kaOHPbVDmF06wT9XhqT2SM0Vx0XhUlTVG
	 31SwIM8MwyUMQ==
Date: Sun, 11 Jan 2026 11:14:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/early_ioremap: Print the starting physical address in
 __early_ioremap()
Message-ID: <aWNp_PRovaLO97zt@kernel.org>
References: <aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com>
X-Rspamd-Queue-Id: DC287140009
X-Stat-Signature: 7yiyt57qrtw8m9dmourn9kcej1czc97u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768122883-879893
X-HE-Meta: U2FsdGVkX19K5iojMmERK6mdr68uJlxYp1BlkoydUPljpocMJlLBdVTzoO0Akmt22X6rI7jkheaFgSYVsFxv6Rm7lI1WP+yBgl6D4K4eG/3EXrCGrKrv6xR9ULpgG/3iw+Ne/kel2byj16D5xqcVdn2Yqwcq6jwolcN3TiiYK0P3t/l/N/tOgPBKXn6U8xn+Yra/tLuVPXqnRwXklVLm4BKUEwVwuNKS2umexPNuRcnkrUXOC2f7YfyCue8zA3xILqAd1tD1BE71wOmyBgGcNllzSwqOl6VGLEMh0ueaociLOpSdLv6XzzZPaosa7gvVtt9OJq5fPwHZYr+lBaEr9Spr1KpA4Cxt6uF5b1ZcQvkhk7yXeEdrugbtZh4qEK9Z9ahzcAnbz0fzLRQBr5yUQzK+CumimiJrz8F7Hjmz+dqKoRdnLyaNSAt2xJF5GE6suikpLhS21i/nh2T/OCc/tiGeXdBa8l2INsdjgnzMNMsmrmv6dAC5Eem9bPweBpC9NUwGyjIM1C6V/He79QrGbwLPp1x9qM73rwfhRdFGj73Y2HpmiAdxcLBI0KWXEq4OH6FZXKB/DaUHW93sM9qID/wiI6bbzsW/YX1yfVY4XzyGHfmgABujb/zi4vGkM2+H+vOm1NPKdCRWu5JYXzyeJ5/hAMo0srO8GLl3DzzXpDM6dS/q37JVnm6rKD/vPB0EsY7OeQnGhxyHcz8JbZ3Ngpy31o0OxI68R0acj8ILmME/E05IMIq0EZn+PPBK3EbHVFrDt8dQZ93dHQOzy9pcgONygBqyIIZNeLA85hRVBsWXj+xnZbpkoWnJ3BDogEz9ym7ucpsAnD3tuppvcle3CVNw18zXHmxmW+07NxpXAMhCKIiS5E8C39NnokYk8OXc/2TBHIA0PHj1zMjK/unzxPXHLz866TbmS5kKELDFR5JKV6+HTqowlYZKPKe/OmeiXXq+sk1MkFztFrZB26G
 JEfqks9y
 /jyEE5PjBMtTOlQX+tUQsGjCt5T33PNtU9PsU173Axhr7Ri/T/aMBQYLxlW63Yqpxs8715raHrxRfFM64FLXgUPKy428j9ESLdjYENdMacyib/YCB34bHfUTEv83dgM8+FMVBo1Rf8+oFJdN1cZA+3oRBHNZS4DHycZgOXz9Q0Pnkyk1q/Xh4jPgnKO2CK8y8/YmnOC8lHEwYqOd/hemaote8SSooxcmhy4NzgRhH5KGtuQGfaRNJzwgpx73igJXyr9DbfEOVYHH7gIBLTyjOvSk5JusUTrZq/iQcx5kWdUZLqJeHte8vcmv9Bli3CFW8/EiT7M7EgwaMv5p8V/Wm3bNTqnSujdvtDEyOLZCBKqRBy7is9TIlTqOenXkF+qAmjrGf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 09:31:51PM +0800, Hou Wenlong wrote:
> The debug WARN() printing occurs after the while loop, so the
> 'phys_addr' reflects the last physical address rather than the actual
> starting physical address, which is not useful for debugging. To
> simplify, the WARN() statement could be moved up before the loop instead
> of introducing a new variable to record the original 'phys_addr' value.
> Additionally, swap the print order of 'slot_virt[slot]' and 'offset', as
> this will enhance output readability.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/early_ioremap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
> index ff35b84a7b50..3fdde074c9da 100644
> --- a/mm/early_ioremap.c
> +++ b/mm/early_ioremap.c
> @@ -139,6 +139,9 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
>  	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
>  		return NULL;
>  
> +	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> +	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
> +
>  	/*
>  	 * Ok, go for it..
>  	 */
> @@ -152,8 +155,6 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
>  		--idx;
>  		--nrpages;
>  	}
> -	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> -	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);
>  
>  	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
>  	return prev_map[slot];
> -- 
> 2.31.1
> 

-- 
Sincerely yours,
Mike.

