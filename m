Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4163ECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CFD6B009E; Tue,  2 Jun 2026 00:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75886B00A0; Tue,  2 Jun 2026 00:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B156B00A3; Tue,  2 Jun 2026 00:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884556B009E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:42:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56914140811
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:42:56 +0000 (UTC)
X-FDA: 84833727552.24.488DC57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC899100003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:42:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX7UIQaf;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5LjwyqHv+cuF7cox7QKxMaKT1u+xe8DMZ1+K1paDkg=;
	b=JArRV7moJduUC/uDuk8eK1iPKzOFi/FDJiz8WPhPucMT3ozw8hcwuCungRb81GbGEe9sp9
	ZQZ/YnNh0HAEn1DagV2wqVzMb3fpy/doFKqUsKiJfYlOzCduXdHuDaYVIWsMlXQKCLPIoI
	zN/uNtKX4Itv50lmE25AUyZRJug/C8g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX7UIQaf;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375374;
	b=XRv49Qs0zSZesC8CT2hZlIFUO2wHP+ms2wV50N68bXKpbgOVuOSuVu529cR1otGP5VZEM1
	XAAaOXkIS9n1EiyHLu5PAsoLuO1F/im2AJk97IWZA6pm/VOTWs0zZzSm07b26flBZ3Twep
	VqtYzK+J6yjgZGlB97iFk4DAhyivVEo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EBE56001A;
	Tue,  2 Jun 2026 04:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758F31F00893;
	Tue,  2 Jun 2026 04:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375374;
	bh=q5LjwyqHv+cuF7cox7QKxMaKT1u+xe8DMZ1+K1paDkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NX7UIQafey5Ppn3S4T1W8ulKWcx4GVHL15p4QQacar67iFhuJ0SNvibBo7j5gjswm
	 JcsAqP7zzZJzRnXqBdU6QzcN+4R7VKIeX8Xdykkre0iNXgb6t953myJbsK50zpg649
	 HE0ZA2rzhJDVPZNjRWV9WaDh9YH2eHkyATGegZvIUvbXG5v8xMKnkL74KMQNC/kNlZ
	 KmgKKRYH1J5c1mXc7/VgzS/aLHeNKUEj83ZfX+Ne/KdABkR9otndfuDAiJoe5YDyPi
	 XDsF7iWnVbPKMaoX/HaJJ0jS+/fBdjlRU2RNdW2K5dYPOAPsoYmXIasV6MVTYSvymN
	 PNjrjnre0i6Pw==
Date: Tue, 2 Jun 2026 06:42:45 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 2/5] arm64/mm: drop vmemmap_pmd helpers and use
 generic code
Message-ID: <ah5fRXPvpOSmKoxl@localhost.localdomain>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601084845.3792171-3-songmuchun@bytedance.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC899100003
X-Stat-Signature: 6zpwxx4qhbipjzq1o6hae5jndib54es6
X-Rspam-User: 
X-HE-Tag: 1780375374-745285
X-HE-Meta: U2FsdGVkX1/g0UV8ep8lXozOgQdhMZulRerwlpd8iZg5Qdvi8BRxc0A3zLkvPQCi90g/xJ9zEOUBcUfG8fllJMnhNtYUVxraMQ1XA0K9JfGclG+CppkTf519YTfPaEOyJy6qUVwfUEpWNAwtQOxMPzsqtw2tuIZgCi/ixrZSnws6lRIt9+JQZT66nx0c3IeXGWN9uSZmnvFxgLkgKV/QeNH2L3jU1QmzDhJg/K4MV7ueNX/0kgClpRFI0JcFodInhnbQ3499EShdIo8QXpNFbW5x0UlRRSmv7Ip55EdgSftRbjTiSioalMEA7Xp6WMbxKs8YamGvPyEVwuE6U95vs3o3IZgC88ZknQ96rOojIOhRkU3pO0urff/udsMijtHuYRl8JfQmhQ+6B6Wmge8kJLx0Bs2cqGIbVJnjZdF0+olSptxwesmZs336cZi4iUKsMwaimxdDTKpRLRwv+zcOtqap14gieU7vkDRxKdc+xJ0SsswU5neDTKgHbgCLBVhLmIhFr/rPmd20hqzu3Ri9ty8i7ys1a2cXXFGBL1UxYz+mO44BwG+kvkVyQfBG69MkS7PtFkgCJ847H2+KuOAIZtXi7UaqYXB9xY8QZeKqKsjSOfwCmheHFajxHouQeRPmCFAiUm4bz0ZK4kU5HFPBYiHUlYooMpNNcfcyGyQbaM3J1mJTbZ2ZdxDU66mvTpp4ae2B8q06BNA+pwgHWZc881RLoyJ7/eyT8coJ90SfHckRaXuTb0U5DtHRkdeF/tVhrnmEmHhW21HjHdEuHUvV5vqAcdwXYt8DE8yW2PWZJvlPs1NgZ8xlHzplRdEX1mj1fzhqiceNavRi7kPZogpVOUwaLC65hFL7JeccLciH+oC2bEoC0mzSR1BmgZlmHLnk1l+IUkGOU1GFF5VqXXa1RGzNeh1VFsh+A0LjaGOCllWaYyv1VHswTscOggsHIYnbjCH4n8nu1TEZtav2b39
 h02iqx2i
 zO3YjwtY3Zs1uIFjH/kZXxguBX7UMqkeX30a3in70vWFceizpkH/AsFZjwcJz0wcSw2AwrIoi/Rr2BRzpXN4l+D0hgkANoCs24Zg+5RIpzPis4OCHmuabQSMC/JMUhJOzwyc8c287XTT8nTYECFL2cT6zGLwYgQGqzCKTwPAAralJt9Nf0EpE0NBXDyvuBPhw/+KgpJqrPiPADc+1hjT9M043ppftbqu08FYu2CCraX7YKAwIzJkWwBNj1zFeK0Ggm13pl1YYm2q0ZfSpvdIT+OzFxMsvGWDxKZEIbj6Hy4yY1pwPkJzd5N+3RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:48:41PM +0800, Muchun Song wrote:
> The generic implementations now suffice; remove the arm64 copies.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Will Deacon <will@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

> ---
> v2->v3:
> - Collect Acked-by from Will Deacon
> ---
>  arch/arm64/mm/mmu.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 24388e5c727d..ea10b0ebecd7 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1776,20 +1776,6 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
>  }
>  #endif
>  
> -void __meminit vmemmap_set_pmd(pmd_t *pmdp, void *p, int node,
> -			       unsigned long addr, unsigned long next)
> -{
> -	pmd_set_huge(pmdp, __pa(p), __pgprot(PROT_SECT_NORMAL));
> -}
> -
> -int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> -				unsigned long addr, unsigned long next)
> -{
> -	vmemmap_verify((pte_t *)pmdp, node, addr, next);
> -
> -	return pmd_leaf(READ_ONCE(*pmdp));
> -}
> -
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  		struct vmem_altmap *altmap)
>  {
> -- 
> 2.54.0
> 
> 

-- 
Oscar Salvador
SUSE Labs

