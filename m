Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C45C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9EFB6B008C; Thu, 24 Sep 2026 11:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28D56B0092; Thu, 24 Sep 2026 11:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0F76B0093; Thu, 24 Sep 2026 11:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE2C6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:19:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 056CE402E3
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:19:01 +0000 (UTC)
X-FDA: 85249013682.14.1462019
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 68EA540011
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:18:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVDH9WLs;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790263139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7s1CAgd45i1qVFJKno+reNnGoGUQMAT+I7uYiP/nks=;
	b=xCskSODUhsMKPHeIQnj7i7kXI3f/y0Z7U1JPHiSkFvMULrkiuOGhCQWORUcjgYUyXTz5CR
	L0YS6WzzMaBQkYerucy2e29P3+sSL2ryDY8t0QixRhHr2KuZq0tTVEAd489XNDULw4wZ7C
	Lfgx2M5f4CdYgYu/vPbLHS8L2Q7KCHk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVDH9WLs;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790263139;
	b=szbdRVLo9IFn9Qz2PbR5SBzeoB09nvs6j0/ErJa6vsWYD9xiIHduRSE3o0uRvvq5TgciIS
	WofNDpLtEkZtFT43HXi8udbJiUVQD4gE1FrigN79/L/r+tG9d68Q3IUgrFwXoAWUo1jQyy
	wCFm9S7XiRu79hbmTOqjbJWyv7eHEF4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7256601DE;
	Thu, 24 Sep 2026 15:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6A61F000FF;
	Thu, 24 Sep 2026 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263138;
	bh=r7s1CAgd45i1qVFJKno+reNnGoGUQMAT+I7uYiP/nks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VVDH9WLsvrmzpUg4Z+hLDHBG/pO4qlIBnTIodD5pt0BF9Re7iMX6ULoPqbHSz2RnM
	 mymMnw1a5pmRQCiKHNjX4xaFkJd3E2HmVEGs+O7u5jfWVN5bmkH6nlOUe7THYjtE/f
	 mL9o7Tj6iKdrgU8ZuOjyGB03amWLl/t1FrPbO9ve033yVQ+VQR2hizSLCNpgOzVIWT
	 6XnXVTerX2Y6rVe8Mk+UHq65CpLKmamkWuT4mkfE3jZlWwLjl051pbc+nuoNQpiPAh
	 +Z2Nny5WtQQtwJzs7+VmPoQhFBBLhVHeoXzW8TFatOOXvBDWsF+IG4mzjumIzBkQ0I
	 foBvXytVcx/3g==
Date: Thu, 24 Sep 2026 16:18:56 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
	Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/8] replace CONFIG_SLUB_TINY with a slab_tiny boot
 parameter
Message-ID: <arU956kfc1QpA7N-@thinkstation>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68EA540011
X-Stat-Signature: qeqrxak8fhgahzm43zgfxo9x54u9afnf
X-HE-Tag: 1790263139-276877
X-HE-Meta: U2FsdGVkX18zh7Y3MKG7yTZLkigaYmmGdxqJRkPDC+gJOwJJviPEHVk4ipq+w9YnrH1eK5euYs9W09swnGjFrYrQqMRrp6HPKRuxRH37yvvG7ObQE3TEIb3GUjQOoCJuOkhFxrJTuHRycZmj/eGRHu80TR8kg8g7FBlUkbz8L+cw52NrcqB0oagI7jGkwFfg0aKjDvHIlyZ6VSLlp1UBk69XuBIhfX22fuGcs6mD6S0DZDIG7oSBUZuqqK/hiyRYpVW6MLrY/pHCU8wqRpekV+hmc8d7jueO4mWnCACla8+gzToHvMiny6/hzQFIO6qdkW8H279Rzs0ICWJCNWP8iUeMxF4nqB3dZRPdltoB72rPBZlfAiIBNq+8ScXZ3RbZBl7aORpfbCR8SVAeGX2C+tFJrc/6ZfNzao2CfWxHzSS3LBz0Q3MPupEj4PqVKw/lpLrRYVG7JFfsx562yG5vBzuhWX/Dx9r7bMNYK2quNU4IrCXCp30yDgs62toCMhRog29YZycwjzuMLqyYZbOqq3bCPv7+kVsf+4Hvc/O4bEsq5GbnwKJp9Am2gs3NuaGoF+WJnadTXMOn53quo/5jUJqDeOlrROL6Pts8/APy26Fer2Pe/D/wPc/KP+OVhiI+VF7bbyJHAK86cOL4KRdFeY7O1c1KPtKwCLg9FRCKe7XzrTI+WdM7PWeUPmul8CwlpHgJ7M3PXnj51R2Ctu+PXyn97bxebB7Tj1ukeJ7LJXHt/yecctpeolEzAlu2WwXAZ0aq6wIl4+1O4K1drOBMLZT9DTRG2MpF+FWUC0kpfhKDd7jbsVfyPB9yafTwz65B+dP9yDGdO+kS2107NhsuLHwBrh58DrBOjP1DEO8Zb4CB5iWiBTrltVLMMcjXNByevPkHuLGWaG34W2Nuqti3rkZOFGBq41kslBReyxeKztK8KTqcvBDPla0kAMy3AIC0IT1S+dmo3FEaetZNgUV
 FmJ/nCRl
 6aHgNFpnram6b/Ltk0aHYlidXruST6GioNf+Tx/2h8hUqNJQUgciYvy1udZe65rhv9oZNVhdQEsVb4fydGeo3ckTRMN7LKozmuo5ObKJZAuI+2oT/zfais9SJAJHGCuDGnn4ESqgr2bwuIzA2zufe1wX4FunN/I9xd/MdlhHah5uJht+90rZJpUEOKKdDr3EQcbRFlPNMVH5OQ/TerNBswHDD6KZOtFz9psM2M0569noR0vA1q/Xidw3Yegy6zTHc6gZfqQOpz0wBHpvst5nxKkdIL2B2wOzvZwG+xSHETcd18QsA2hrC9NZyadAyvUgDIHBgL54n8+NZ28Y23QDFsKnxJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:45:05PM +0200, Vlastimil Babka (SUSE) wrote:
> To sum up, after this series:
> 
> - CONFIG_SLUB_TINY is a deprecated option that has no interaction with
>   other options and only controls the default behavior.
> 
> - New slab_tiny boot parameter controls the functionality (and can
>   override CONFIG_SLUB_TINY in both directions).
>
> - slab_debug=N can effectively achieve most of slab_tiny and on a
>   per-cache basic

Allowing "slab_tiny=0" doesn't make much sense given that
CONFIG_SLUB_TINY is deprecated anyway. I was assuming specifying
"slab_tiny" would enable it and not specifying it would disable it
unless CONFIG_SLUB_TINY is set.

Also it's bit confusing to have multiple ways to achieve the same thing.
Is there a reason why we can't interpret "slab_debug=N" as
"slab_tiny_enabled = 1" internally and drop "slab_tiny" boot parameter?

> - the implementation is simpler with many ifdefs removed
> 
> [1] https://lore.kernel.org/all/CAHk-=wh-k04MsoEC0SGKff2Snm6bBF_e+0pHOKwaWv4umZ_SnQ@mail.gmail.com/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Vlastimil Babka (SUSE) (8):
>       mm, slab: refactor slab_min/max_order handling
>       mm, slab: introduce slab_debug=N
>       mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
>       mm, slab: make SLUB_TINY handling dynamic for sizing decisions
>       mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
>       mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
>       mm, slab: add slab_tiny boot param
>       mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects
> 
>  Documentation/admin-guide/kernel-parameters.txt |   4 +
>  Documentation/admin-guide/mm/slab.rst           |  18 ++-
>  include/linux/slab.h                            |  17 +--
>  lib/Kconfig.kasan                               |   2 +-
>  mm/Kconfig                                      |  16 ++-
>  mm/Kconfig.debug                                |   2 +-
>  mm/slab.h                                       |  32 +++--
>  mm/slab_common.c                                |  12 +-
>  mm/slub.c                                       | 149 +++++++++++-------------
>  9 files changed, 120 insertions(+), 132 deletions(-)
> ---
> base-commit: b4218126d498275444f315b0ed4cef6add6beabc
> change-id: 20260911-slub_tiny_rework-8f2634dd17a7
> 

-- 
Cheers,
Harry / Hyeonggon

