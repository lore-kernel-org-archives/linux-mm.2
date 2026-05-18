Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DF9CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036466B008C; Mon, 18 May 2026 02:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BF36B0092; Mon, 18 May 2026 02:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64E66B0095; Mon, 18 May 2026 02:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D64BF6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:32:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8692B1C0547
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:32:33 +0000 (UTC)
X-FDA: 84779571786.10.BC582B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BA1B680005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:32:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Og+6qPd6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTpSoV7L/+B93kkAyhuI+KkZWfF4sTg8M+xt8aTaHUs=;
	b=W8QM3Z2J5MtCNn4zi/0fvsZntj3U/x3q7IPvXem5ZOQnexWUgp57NIgAji50+sQPuGbNPV
	ga7CPQ4syXkrQoJVjrQSrsyMK2tK9fQ0/Sg0cXYCuGaBJPOji3h3ZstdnRaKN5UtszeaBk
	HkPAXv3Mk0YIEXKw+YIZMrpPsrIYd+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085951; a=rsa-sha256;
	cv=none;
	b=Pe24qwdDOoDb+ilmbNi51f4N0F5WB4g9Wl+oKW/r9o6yyu8cs2g0z0myfihth5WqZhrbDV
	+hU4DkdRv9E6LhMDZ+AUbYLRKjhQny4BrgwUIgqx4YISgL6DGde4vuCULNwFVizkvR+wt+
	L2HnhYZX11FW3CZcrtfQu8QaPIDhcsw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Og+6qPd6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E59BB406AE;
	Mon, 18 May 2026 06:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7030C2BCB7;
	Mon, 18 May 2026 06:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779085950;
	bh=rUV2HjQXZO7sfqTTk9IjtWhQHj2MdFmFFqNhZEMa2h0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Og+6qPd670cvWeHTzLyJZvKdtvjnhP1wBWakivhOrQry8c9Ks62iyoyAAXHqwUjzn
	 4EFb7DXdv5GeOX5oQ4L0GoivdXT9BFOHh8KgITS4KT7APm3v90cdQappGioXkw4kAf
	 2Z0HIBnjr9VXzA8h0prMHg39OnMSV9oatLPyJqdSLRkTw+mC4QOhSxyrrOHZY8A6yx
	 CTQRFaZb/GL8VCzbbehWccEcuhFjnxhSQgxQZZm8m0geP/BeL0YM2B9GjPQcQCpNZT
	 5rJoEjU1GKJfh4VlfDUkv/36pnHk/XF65ODt2ASBeLhv0ZIP2evK+Dz6UNysYtb1JK
	 C4asp49Fg7k2w==
Date: Mon, 18 May 2026 09:32:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, arnd@arndb.de,
	akpm@linux-foundation.org, david@kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: factor zone-device page init helpers out of
 __init_zone_device_page
Message-ID: <agqyd5Kncrx5B_ex@kernel.org>
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
 <20260515082045.63029-2-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515082045.63029-2-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA1B680005
X-Stat-Signature: wspuuqwbmtrf4rd8dhdywscik7zojzx8
X-Rspam-User: 
X-HE-Tag: 1779085951-598152
X-HE-Meta: U2FsdGVkX19A8JVJmYqlkykA5X/9eYq9GnAOFruOzTnS3BgbHHWfaqHi0g9Y1hHiEf0JzvOHLZ0dh6Jx4onZJXMvSW9EoB2bizM808y7BucTAuJ8AKbG9SF8xEl+HbaP/QXplgtkE/ZxH/y7wsO2fwkMuWw5ZzGR5kPjoG3M4jmQOePsoTnMgYud1sMetn+0uJbnv1mbWFW00baC1/+3m6DHmTEuhJBUf5ruMuXM7tAsD6yTiLSmHxK9spd9hH+pPIdekKojTqy3N0kBpylkDmFzSTwX0FFIOlrqoGGc5E7Kr/MuCafHTu09wO124hTENNoq5PQU3X5TjI3vxpupFoSz0TBMsJe/6FEx0+1j7JShkilLV7s0MWVW171XhkNhNwXOcLHlrnZ00icw07yz3cL++Lu0LEvcYw7D1UknJSWJn439keotCkEkE8/JjCPbAZSbag9qYeGa3skwQ+dHFUJaDL9bk0bo0wGdbCU6lH33lh+baSjjr/2uy6EStHFvJ2qac84w+MpOd0hdr5Rnf3ESI6kTk0ifoyt6ivwAKT/IiIaG03NK8/KSjbYADiRe1G8dqX9V4YfmPoTtRdtDe5LvTnJxUmQJt3d9lCN/Ml6hZi29wKhalXesrFmaP55fCLkeZT23UX3ab6mqv7jMrt3nPEPXb0C+63wLpkPbNrqYR3Lfa8IY/o7O55ja4kIyuVF95gesBi9nbTjJX/tgoc/RUzUIuJRy+F9cFJajAvonCElseuHJyh/4CX9XZl2yE+kAoJo4BwyFBQHN289F/gfiJld65DEuJlc6G/JztVVAQVr++r9+Q9BuIzOrt3UBpBjgSKF4+1VG9doN8iN9Itih/WPqKb7BrAUpVXiIa6AajLpvDVvQAJy0Ni4sGKpVFqx/znwcTwKDq+UyOGWfDaoC5mvV+mhw0SBv+CBSTUmc2szmvM104G5gqzm8W9VwO8ifC4/f9oarU2WMl/X
 pbP/LREC
 7j/Caqbemil6Yk0XqHq5dLv3c3fQhAzn5LMSGkRj6YWPJeJe+DvUtFIjDsjcpAyqdqNDCoiPVrihw2RIq/NOdKNtMw/hsQsgj4DbiQJxe5Mu8uFdjJcsrqpid8Ve8KQmQTCcBBp/8xfouMfVsa/K7EkLT8OqtGHc5g6wHNmPsTvGTbeKFa65mZdLLTGj3EzYBFKcdficXOE5RJPdJ61G/xDB+gZ7vAq45ohwSbG0k+U+wVVAjM/BsQJILdsOiJBFs9D1QtHG62gfdr6tgL2bkZ5oDE8AfcsGbHPXeGMWG1AueQlktfhDczWw53ZxOOno5jX3vIXoCoBUDLOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, May 15, 2026 at 04:20:42PM +0800, Li Zhe wrote:
> __init_zone_device_page() currently mixes three different jobs: deciding
> the initial page refcount, initializing the generic ZONE_DEVICE state, and
> setting up pageblock metadata.
> 
> Split the refcount policy into zone_device_page_init_refcount() and move
> the generic page initialization into generic_init_zone_device_page(). This
> keeps the slow path behavior unchanged, but makes the individual pieces
> reusable by later fast-path patches.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/mm_init.c | 62 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 38 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..5244acb96dbb 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -987,11 +987,36 @@ static void __init memmap_init(void)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> -					  unsigned long zone_idx, int nid,
> -					  struct dev_pagemap *pgmap)

Since you are already changing __init_zone_device_page(), I'd suggest
renaming it to zone_device_page_init().

> +static inline int zone_device_page_init_refcount(
> +		const struct dev_pagemap *pgmap)
>  {
> +	/*
> +	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
> +	 * directly to the driver page allocator which will set the page count
> +	 * to 1 when allocating the page.
> +	 *
> +	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
> +	 * their refcount reset to one whenever they are freed (ie. after
> +	 * their refcount drops to 0).
> +	 */
> +	switch (pgmap->type) {
> +	case MEMORY_DEVICE_FS_DAX:
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_COHERENT:
> +	case MEMORY_DEVICE_PCI_P2PDMA:
> +		return 0;
> +	case MEMORY_DEVICE_GENERIC:
> +		return 1;
> +	default:
> +		WARN_ONCE(1, "Unknown memory type!");
> +		return 1;
> +	}
> +}
>  
> +static void __ref generic_init_zone_device_page(struct page *page,
> +		unsigned long pfn, unsigned long zone_idx, int nid,
> +		struct dev_pagemap *pgmap)
> +{

Here also would be better to use zone_device_page_ prefix. 
And I don't think "generic" adds clarity about what this function is doing.

Seeing that later patches rename it again to _slow variant, I'd suggest to
call it __zone_device_page_init() at keep this name going forward.

>  	__init_single_page(page, pfn, zone_idx, nid);
>  
>  	/*

-- 
Sincerely yours,
Mike.

