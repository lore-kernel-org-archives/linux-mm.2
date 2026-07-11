Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348F1C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 10:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251716B0005; Sat, 11 Jul 2026 06:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2030E6B0088; Sat, 11 Jul 2026 06:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119956B008A; Sat, 11 Jul 2026 06:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E47E66B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:08:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8588C1C8E67
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:08:57 +0000 (UTC)
X-FDA: 84976072314.05.414C8DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE34C1C0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:08:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJR7iEPv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783764536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7h3aGld2owdMP9awF/sIZ0ZeSAhD+gvPs1e421zuh8E=;
	b=8Kfd39HXx68gxt5tnznJG1JybdKZCQI89Woa/FGBtZj/uRouiTlEXEuZZH+oiFMPnDZ442
	f01nrdSZERlLQh3yhdFON2FyXL21sfC1S6dqB9YqQxQj0hGf4PXQm70cYgDqdoDjg2zfPM
	rBdzqaXGVJ6X1h7un3Zbx4yJQMUGSV0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJR7iEPv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783764536;
	b=oQo4NDuQhcxK3RVRqyhO8Ir47dI4hO5/ng3qmRNXZHzjIf5DMSwu1YPllzlVUJGNhC7e0Y
	rjlVgi+KCFRJzZi9XjXWqewNvCchdXv+nw8SS7ukOpIDEa9djiWWJdWz+IZvMcUKSR4jAg
	M2EBZ1MCa0+VvCZbR75eK5VoxiqeJYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1A8341247;
	Sat, 11 Jul 2026 10:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51D81F000E9;
	Sat, 11 Jul 2026 10:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783764534;
	bh=7h3aGld2owdMP9awF/sIZ0ZeSAhD+gvPs1e421zuh8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GJR7iEPvoOLeZDVwN8a/m8eQsstNeIf+B49TSqFKwMDzcFpMtF/YF/maBObxCalaC
	 UUiaJvdi75QpJocaczvMAKnn9lGxyXeSYhgITG+bL8vXr99iad+Xvf3aDHHNhW/8H7
	 XsCm1q+bAukOUDEU06GDaWtlOaBP68l59MkJld1bcXlNBYkw6KxyMk5Bk7NcpXYziv
	 seRHPaOcR7+s1L6tyyq0corRJWjWDsYWiJnZQtjT13c9BscneJ3M+3Pz8NgqFcyWEg
	 8XXsvxxQZsQDY6zq+tkoPbsYBz/LuJ2gDxWek8sIqPOB6M2riU7RIco5FskBQqWO/Q
	 NP8eqdg37xZZw==
Date: Sat, 11 Jul 2026 13:08:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Toshi Kani <toshi.kani@hpe.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Will Deacon <will@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/ptdump: always stabilise against page table freeing
 using init_mm
Message-ID: <alIWLiLObQuZTGQZ@kernel.org>
References: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
X-Rspamd-Queue-Id: DE34C1C0005
X-Stat-Signature: 8au99tzp5i9e9qbjsn5nqjh1h6tcsogr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783764535-713637
X-HE-Meta: U2FsdGVkX195LXig20v+8RCs8cfMRnk5PzINKSHKH9Ejuuzvwi2ajL5hhqogt7Nnu2CZMxjM/fbLP7blKzEpI+ACz5etxb/WuOBSFBXnAkMscHoNgmi+juSvqEgusBJPRzjr24Cj2DkHVjwUtB03FziJ3LHXC+jzrSdzYsj1wxf5uE/XCa0kQibVBBJOaZWhwz5mAirM/jtIVSgIDY40sv0zrB+9HGqP8mvCvLtXK3YMKwqeQx5TFHmkRyojj8WJ2RAN5BDKmbOkIpGOfW+Ljp1yOvU7hrSGQ8znVkjYoAXLpoWd01xfMifH6ViiKHMWqeUm0ivvGZ46Kk4LdfMrj4QlADsMPJSvy96kPsCkOqcw6rUElR0noRVCC6aEzD3I0m27zT7BvF899tbwP+eiPdXm74ZOBz6WFgxd/SvTeLKJqhqbdTxYH4mVbeKI1Zj5VIN/ZHsREglcynMlim7npFKE5q5KaKjvG0JBy2ngywlSwaKpFLibyPbm19DQtz/vYfr1CN7gKitsMMQcroiq8TsAeTG0pt5+PhxbX0cGobr0EDHi1tLC+4J+zkZeOVAovBWJBmDiyez8u25lBfVnCLmslAAyC78Jo/BRY8yNeJ0gdnLimyZoYQ7NkGUG8olCEktIzDTOKjJy82cLXh5wYTE3OE5debl3iXhsZQShmnkXKstAuvCs+p4JjG6y5+syw52fiUa+3zrGJrzBmYCHcS4UxYrwOOiDqf9gaKieGnDGIzxZdl4hbCYaHbgmzvzePmN/CtxhszaVo1jvAf39C9F7Xa1ra8o3RjY1YBgul3kGi1j2t+NO4n931KsvBFa2UeugUSObKoVAEtSZkIJvW+eNLzf5V+ZiwTgwTUmwUz1WwiTTuhogxY4I0T+Q4arjGwib5NKBADqcx7xh3gjyptH7apatlZMsgAeHen6zkVEJqVt6vTmZIsNNT33+qP4toT+FHvg5dLQD6bE1GTr
 5nPkDBfH
 ZeGgvrPw5eIPVm0dA2oCOvwWC5P03pFwEOn/Zsq3Hf8HVAXgNXnNxsiD/2vUy3AsB/91KMBOa0V9bTCCSfuienT1AefIKR5zi6VtTFxMLGDvREwYIThHqLD011twd1K1z4BiSRTTD/sDo/jf41ylp5nK1oxihaL+4KecbiAtSS4X3BbE5W+hTWvyOiWY5mhtPRYb4UFRnlJumJ/pkr92yPzYLB4owJCIblZtYu91xUhsQXukK48tQBhvt9T9h/CgW5yPi2smRx6VCjJ4JDkXDWLTe+llX5sygjkfYAbUG7Sy0Ue3dYikLPFmSreQ9AbktsWNk+PzPVx54bdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 02:29:21PM +0100, Lorenzo Stoakes wrote:
> x86 and arm64 invokes ptdump_walk_pgd() with non-init_mm mm whilst still

Nit:            ^ invoke

> walking kernel page table ranges.
> 
> For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
> first passing current->mm, and the second passing efi_mm (we reach kernel
> mappings that init_mm protects for current->mm due to x86 cloning shared
> kernel page tables for arbitrary mm's).
> 
> arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
> for efi ranges against efi_mm.
> 
> The init_mm mmap lock is used to stabilise page table freeing against
> ptdump, so take a nested lock on init_mm to ensure that we are correctly
> stabilised.
> 
> We take this after mmap write locking the non-init_mm mm. Nothing acquires
> the init_mm lock first before locking an arbitrary mm, so no deadlock is
> possible.
> 
> Other fixes have been sent which update the two cases which can cause races
> with ptdump in init_mm ranges to acquire the init_mm mmap write lock - vmap
> and x86 CPA huge page promotion.
> 
> For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
> already provides exclusion against init_mm for the vmap case, which this
> patch also pairs with.
> 
> The first point at which ptdump can race kernel page table freeing is
> commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
> table"), so we target this in the Fixes tag.
> 
> Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> ---
>  mm/ptdump.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/ptdump.c b/mm/ptdump.c
> index 973020000096..6bef47b1a073 100644
> --- a/mm/ptdump.c
> +++ b/mm/ptdump.c
> @@ -178,11 +178,18 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
>  
>  	get_online_mems();
>  	mmap_write_lock(mm);
> +	/* To stabilise page tables we must hold the init_mm lock too. */

Maybe

	/* To stabilise kernel page tables we must hold the init_mm lock too. */

Other than these nits

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

