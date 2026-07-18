Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC52AC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 10:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8BC6B008C; Sat, 18 Jul 2026 06:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C03C6B0095; Sat, 18 Jul 2026 06:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6A86B009D; Sat, 18 Jul 2026 06:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4259B6B008C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:55:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C406F4041C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:55:04 +0000 (UTC)
X-FDA: 85001590128.24.34CFE4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C12E4000A
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:55:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiI8R0kP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784372103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Wk95nsyLty8ZIxsRyt5wCr5/RC7WWcTwZjDgbSZNSs=;
	b=NMzJMOIgeUt38ePMxnf1hsCwlmUOR7nILRoa1++NZmF+DWGo4J7bWSKft2i7val+bzNi/A
	r2Q8McipzMAcHNQuzpnz9C2iy/Afi7ds4FqxBM5rk4yi4OO5yY4qbeXYAGkSHA/Gf3cixG
	WjkO0XLq6zJgeuT6cMiIevyhzHX1B9c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiI8R0kP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784372103;
	b=xnTbGBeFhbQHWepMGu6eHe9RXOMCchpxmxQIagHIDWUHyLjJiM5zKTkm736D/Id236K6Jj
	dWiMLZ1IYciY2xd2nkQkWqFEIrdpBWOMlwANIUnwJ2Y5tzMSPACtc5pSxlbEvL7t3D+RSS
	dYQ8jCLIKFKkG7rqtqG+dt5wUDQNWp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B6F460018;
	Sat, 18 Jul 2026 10:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B31D1F000E9;
	Sat, 18 Jul 2026 10:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784372102;
	bh=6Wk95nsyLty8ZIxsRyt5wCr5/RC7WWcTwZjDgbSZNSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aiI8R0kPNLSytO43AkjaOcOjJhYehi+jiu0VA1Efoyqtg1kBLTrE0UTrpEjDlMu/K
	 dnFZ5QtHXVwRiuDjw8yONGi0FSYk9RBir2PD/U99wZJ1Vb4q+9Q4RbVpWwNVcr91Yq
	 r26wxPsubsi+R9hxTg+TqhAGi1e756ZR7odtaCpKb0PSYO/H5GFAFLy4cbmG5YQ0re
	 pgLWdpkAR+xyXqa9zjTTRyaD6kK/ktq2b15gni9Bc+q78KU5jfhbAVk+s5GWZpn6Tg
	 mzKAgRuA9T7wlRb+kZ1gwGzSToi43PYttqNOzzE6ePr5aWjBeK4df/8CUqk7vVM6BB
	 us/qCDz52pdng==
Date: Sat, 18 Jul 2026 13:54:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Denis V. Lunev" <den@virtuozzo.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v5 3/5] x86/mm/pat: acquire init_mm read lock
 on attribute change to avoid UAF
Message-ID: <altbeuTZ0HCz_7HS@kernel.org>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
 <20260717-series-vmap-race-fix-v5-3-606a0ac6d3e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-series-vmap-race-fix-v5-3-606a0ac6d3e5@kernel.org>
X-Rspamd-Queue-Id: 3C12E4000A
X-Stat-Signature: dcrcambywpd16794cxhud7om6w43gyo9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784372103-615639
X-HE-Meta: U2FsdGVkX1+yCKiiqzRoticH28HE1nM9WjwqlbjIYExcw1QnTDiK8ZNuw4EMZhwE7iylHzoHdWuXczmlJ7O0cegIXHwasNTlYc4pwzmA4xazZuxcFbXHbFdypCZ48vmGElCDe1SgU9cOH9VOlJNGf2C8IqCnC4LPCSQGjqtCXCT7U63WWUrClgJAwM8VQlQFWycE73qaS/hK7x2GxqkSCMuuYePLNjzFv10/7411ZGRyhgoyP9BuSIyqf37kAw7XLW1LxvRrJNlLZoNrI9Vu2CFF88eV+oTNHL+oMnxcCMMRN1lIZ68pijYUxzHRz/xLTf4l4tlU4dwV2uSA6kEyh+oZGT7D5Ej1PzDXXIUszhx4RUdKUrx46exIDgpAn+pARQyEl2iZmpN+estPDZtB1uNaYt837ewiGwnMiJqP1SAk51bpmz0iVOSgr6KydqBQWRoaZqXVzWYwWz2AHaWnzYDv9jiP24neR4KSE3xmCuc8KtHj+s4E1zcM5hYcBNnRw1Zc8Kln09YIDomV9/WoM7ow23mU6YitqCh9/7UQJrprd6ciXkIs10PDtTXfI0v/B4ZXm/lKZvEXY6D9CG6yMoWoyb8YtCfurnrsuq6kejdjwtTZ2wesDiAZo1kxWFlvH/Gn7YvFkdzoIHLGksJ4tUUh+EC4gfihebR3d+SdLRBBDV5DIyn3OpbpQkj0aOB75mPS8SjOsctld2V1KKcyj6o1fh6s1YNPuhUIxqQrX+UAB9mRCwQxDLzHh5XYJHzVJwUcQiFh1LRUCrnTt1t2aRnudaIyTtLQ63vWm/XKh4ew1x4LChYRO0IggANvJUOpd5EXLTsXa1Kd6wJQJ1OCiGCgvop27uGZ8wvjNMW6wKdks6g+bYl3YQTYiyyWZO8ntZWKkKwI3QOiOQLmIdJ9RmqN2Hk0jAM2YxiQPcw7B0Luh55YwySXJyQomQ+s21tmMxmi/hWjN51a6s8tRqc
 bPZaB13v
 +UZv/J00hV20mQc2TmSICPYNdowMcOKdWE/ubUvPa+hoQpsPSjLAOQkANA5YOTw8lJlZjruv6nUkhj8YULco9s9sj3U8ekFofNxfSxVrzOyg4TCU64gBH4aOVxhaUQ4P8OHz5jE95OpB3XkIdTuRvygspK550dP9v/d78CVspGIf/2+777lHQUQ7iiJeuLqpT8Wk8xP6Ad9oFCQmeDbYWXSHBpiolIahXgweg1sGP1bIxgHe3hqEuEiFqMrgQWx8PZIzKfPqI+bn4mbY2cCKMYfyvX7SrHcuqvALQKmpXR1IiOFqSWh5DoUJsBhBUVHsyFuQoHxV7G1I+HmmZifBpkZuDN8Fy8Uj30vlDFNBbIfnCfvPNg+AuHeJaKfcGtqrlGG6i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 06:30:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> A previous commit protected us against races between ptdump and CPA
> collapse, however one still exists between attribute changes and collapse
> as reported by Denis V. Lunev (linked).
> 
> When an attribute change arises, a lockless page table walker obtains a PTE
> entry, which is later written to via set_pte_atomic():
> 
> ...
> -> change_page_attr_set_clr()
> -> __change_page_attr_set_clr()
> -> __change_page_attr()
> 	-> _lookup_address_cpa()
> 	-> lookup_address_in_pgd_attr()
> 	-> [ lockless page table walker ]
> -> set_pte_atomic()
> 
> There is nothing preventing a concurrent CPA collapse which can free the
> PTE that was retrieved here, resulting in a use-after-free.
> 
> With the mmap write lock taken on init_mm over CPA collapse, we can now
> resolve this race by acquiring an mmap read lock on init_mm over
> __change_page_attr_set_clr().
> 
> This locks across the whole operation over which the walk and the PTE entry
> write occurs, solving the race.
> 
> It is safe to do this here, as no spinlocks are held upon entry to
> __change_page_attr_set_clr().
> 
> The CPA_COLLAPSE flag is only set by set_memory_rox(), which exclusively
> operates upon vmalloc ranges, and on x86 only within the module mapping
> space.
> 
> This is important, because some callers directly invoke
> __change_page_attr_set_clr(), bypassing this lock. However, none of these
> operate within the module mapping space.
> 
> * cpa_process_alias() - a recursive helper called by
>   __change_page_attr_set_clr().
> * __set_memory_enc_pgtable() - operates on the direct mapping and (via
>   __vmbus_establish_gpadl()) the vmalloc mapping space.
> * __set_pages_[n]p() - called by set_direct_map_[invalid, default,
>   valid]_noflush(), __kernel_map_pages() - operates on the direct map.
> * kernel_[un]map_pages_in_pgd() - operates on EFI ranges.
> 
> This work is based upon Denis V. Lunev's excellent analysis of the bug with
> gratitude.
> 
> Link: https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org/
> Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/x86/mm/pat/set_memory.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index d1e63f7d267f..301fb9e77d91 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2122,7 +2122,9 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
>  	cpa.curpage = 0;
>  	cpa.force_split = force_split;
>  
> -	ret = __change_page_attr_set_clr(&cpa, 1);
> +	/* Avoid race with concurrent CPA collapse. */
> +	scoped_guard(mmap_read_lock, &init_mm)
> +		ret = __change_page_attr_set_clr(&cpa, 1);

There's a small issue with this. debug_pagealloc_unmap_pages() ends up here
and since it's called from __free_pages() it can be in an atomic context.

>  
>  	/*
>  	 * Check whether we really changed something:
> 
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

