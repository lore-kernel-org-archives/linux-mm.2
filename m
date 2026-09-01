Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7AF9C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2F26B008A; Tue,  1 Sep 2026 14:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9737B6B008C; Tue,  1 Sep 2026 14:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889216B0092; Tue,  1 Sep 2026 14:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65D256B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:49:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE36CC04D1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:49:53 +0000 (UTC)
X-FDA: 85166082666.30.08B692E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4CFA018000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:49:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXvEGBMt;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788288592;
	b=qs+S1UoTWOpUp76Yjd98ZX6NztP90/n0xAn+Krscj+C9ezXWlnooUePbU21BH5s1wh90ro
	7+OP/y3XRLQg0Ab4fAWzxbcuHc9tRusBGZkJuxVW70xDrIY+UL18QeL4OS2hB645q5CDBx
	Yp+zDSb26qMtQ4Y6bc0CM1tBc5VUNrk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788288592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQfJLK2VIEkaTXMnxOJLe4f64C7BVo/SEWCYopPxAgs=;
	b=JoXjZ+mGIho9Mes5o5PBmgnFU1yvBBEyiGKgCxQSlUKFdo6A5IoZMoB1ipMc7FtvGeB0cM
	a6qKiVAUX+pZVSxgB5OBbjMo09ltm0G8AyTBXeEII6Cc+WukpfJej7QystCHrbmHepbU5A
	xiP7i5JRaOvejzQTNgIPlGSY/KF3hz4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXvEGBMt;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80A1B60207;
	Tue,  1 Sep 2026 18:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1E11F000E9;
	Tue,  1 Sep 2026 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788288591;
	bh=GQfJLK2VIEkaTXMnxOJLe4f64C7BVo/SEWCYopPxAgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nXvEGBMtNl8qgI84IB/MXFyHvTle71fwMSR3UZk245lcu+k8fPcRrYLtvKLoPkmZ+
	 UMhhnIYbBWHDAe+dGhQh2Z5JL6VE6xoOWQUtUSSaVyLle30l1+udz8Y702tD4XihlR
	 vj1aoLqgE7M4z3vTJxJM2Nu/C05GMMO+qLAXD3Br8hdHIAS+3+zOGWgrAJPpc4xQcc
	 nv/b0iwf/33qIWhL83e6CWzozC4m81q0kXxlFm6q7gvMqKC9V2ZRYeTG6W/G6vwlAV
	 TT9Po0BUmTTReeWVGEpK+lE4zFhJldWEFROfzm+GbsgXPKHij+cpa2iO+8cpT7CVn4
	 6r4e/BxzqiHYw==
Date: Tue, 1 Sep 2026 21:49:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	Pratyush Yadav <pratyush@kernel.org>
Subject: Re: [PATCH] memblock: fix page count when preserving reserve_mem
 regions
Message-ID: <apceSXvb6soT2U1-@kernel.org>
References: <20260901165237.1025973-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901165237.1025973-1-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4CFA018000B
X-Stat-Signature: fe1mgsoem7zkacegj1in65oe5a5hsxb6
X-HE-Tag: 1788288592-107546
X-HE-Meta: U2FsdGVkX1++hXr3zTS3vM7B/D5aulVKjZ4neohr51E6BrOoiLakZjreKYbSitIVYMwQ+w6Kv7TpaGnFUSE3jhSGX8GcEZJpKCs0JJVlgj/F+bW98/52wef0Yp22i2lsto1LxZw/6LOhfANLwLfNp1gkgMhblit+rIROzyrVhZI9uHWOX+PDwNPNUp/s+GriSSX9AZdr49+UpamGNY9tmhn5TiVBAC1A+EC0PUDK1w0gOeshaKCXrL6SgMq0tm57ZtTGJpwftpLcFSR0ryjY9c5xe6sUGYW1g2tybmxVhvHHwkCHClBvd7nRe5DUc90et1BsEJ1LQgmKUwb3u3S1snAAybSNm8/Hq103x//YhpNiWCErmqVCYotEWkyZ9Z1Gkl/jITedbV3nxESiJxQ9wjKexXmofCozrJ5/GWb3w9nX9XvsCZHrYZ8SNxoRumxhrT7b68CNYaTMv0a7MFSeKMc8DXPRGgAia1nzIzzS5Q7YXDf8AWx0v66AIQqd/ILAo/feJl6bBAUFHe1heQQI6BVIFTMlhHOZ9Zskg+P12jLMQ1o1JlDQI03gaghI178luftynjDwjcYxHPOfKBqg9fpbcmKdO8jVaCt4Qj3M2U1h06XfP92NlwQH4H6YD7WiN7SgZXvumbiKVgzbcFy1VU4KAEVcjuAPOzw/QvnVJ9OFbdvtUHiQm+RLjg+bW7CSFeZEXG0Sqhuzbo43C1Kw8FoLOjSnvC72SUGu5LGX04j1MDkxtTNZffWAYVLLJCy91M6M80aJR9yqCNTC368ExzZwbsTIIuJ/MlHPKWGi2taCVedvb43MWvoYEJKVmdCqrboQDqtLqAE73tUiTIvRl1E2TX2sGF6Kytilpoe0DJhNi/ah/Nm46+InkJVuADEUhSQv9Yw0qLsXzon9NC5lftUFFg7GHABgsy9nOMMc3yK1ZObnwR3COkeTPg7OjNakM70ddmBIF/125KXbEiP
 tTVqnPOS
 ABgW/X+bjLqxkDhC8JIEMz8E6+3txNSwJxEzPiY9Emm7oduY+TH557x9IAiGFbYS0BuQ8xzWxOV5cRhIGm0FkC/Roil+jHxegESlPeO5b2tOGRZaFQyJBVMV92lH3wNl2inbjPfMufogP5RdsHoCSiJkAG8T1MEh/jDA1rM9bUCtl3hPtHK63ToGV9LD08hk42XvHSJ/aUpe+jSEGqFsxMKE4pznLeM9m79MULPPT24GMW8ZCXhMHmjwN5CA5lWR3QEkb1p/UlxvdbM3FfMsnX+RciB6gHHLxn1jeKhrqC7zGSxDj5o3eJx+C3pFX71zR4egp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Sep 02, 2026 at 01:52:35AM +0900, Sang-Heon Jeon wrote:
> When map->start or map->size is not page aligned,
> reserved_mem_preserve() does not preserve the last pages of the region

I believe it's the last page, not pages.

> from map->start to map->start + map->size.
> 
> After kexec the new kernel reserves only the preserved pages, so the
> last pages are released to the buddy allocator. But
> reserve_mem_find_by_name() still returns the whole region including the
> last pages, so they can be allocated while the subsystem is still using
> them.
> 
> Preserve every page the region spans so the new kernel reserves all of
> it.

If there are two adjacent not page aligned reserve_mem regions, we'll
preserve them twice, or worse unintentionally unpreserve one of them on
error handling of another.

I think it's better to restrict the reserve_mem alignment to PAGE_SIZE.
 
> Fixes: 8375b76517cb ("kho: replace kho_preserve_phys() with kho_preserve_pages()")
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> 
> QEMU-based test results
> 
> - Booted with "memblock=debug kho=on reserve_mem=5000:64:oops"
> 
>   # kexec -s -l /bzImage --initrd=/initramfs.gz --reuse-cmdline
>   # kexec -e
>   # dmesg | grep kho_preserved_memory_reserve
> 
> 1) AS-IS (before fix)
> [    0.188536] __memblock_reserve: [0x000000013ffee000-0x000000013ffeefff] nid=-1 flags=0 kho_preserved_memory_reserve+0x3d/0x70
> 
> 2) TO-BE (after fix)
> [    0.076935] __memblock_reserve: [0x000000013ffee000-0x000000013ffeffff] nid=-1 flags=0 kho_preserved_memory_reserve+0x3d/0x70
> 
>  mm/memblock.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 777c69f05400..a17b1cccaf3d 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2534,7 +2534,8 @@ static int __init reserved_mem_preserve(void)
>  	for (unsigned int i = 0; i < reserved_mem_count; i++, nr_preserved++) {
>  		struct reserve_mem_table *map = &reserved_mem_table[i];
>  		struct page *page = phys_to_page(map->start);
> -		unsigned int nr_pages = map->size >> PAGE_SHIFT;
> +		unsigned int nr_pages = PFN_UP(map->start + map->size) -
> +					PFN_DOWN(map->start);
>  
>  		err = kho_preserve_pages(page, nr_pages);
>  		if (err)
> @@ -2547,7 +2548,8 @@ static int __init reserved_mem_preserve(void)
>  	for (unsigned int i = 0; i < nr_preserved; i++) {
>  		struct reserve_mem_table *map = &reserved_mem_table[i];
>  		struct page *page = phys_to_page(map->start);
> -		unsigned int nr_pages = map->size >> PAGE_SHIFT;
> +		unsigned int nr_pages = PFN_UP(map->start + map->size) -
> +					PFN_DOWN(map->start);
>  
>  		kho_unpreserve_pages(page, nr_pages);
>  	}
> 
> base-commit: dde94c26af59f5020adafafa08ece21ccd32590b
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

