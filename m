Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF850C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76366B0093; Fri, 18 Sep 2026 12:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26ED6B00A5; Fri, 18 Sep 2026 12:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E006B00A6; Fri, 18 Sep 2026 12:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1BDD6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:41:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AC991C3007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:41:32 +0000 (UTC)
X-FDA: 85227448824.09.8963213
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA534C0006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:41:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9c0xfB4;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkdJK9giFjk4YEtdusx2eMulBHT1yDg70N+OeuIzdy4=;
	b=IVQv3hWSFLeFiw0tQcJqqAzfMLC5W/vlzqBj2AguzfZX+7xIcGgkSwvR1sB6z+g/h0fl+G
	1sk7PVm3TmE8AJdN4HD47DKt4u19Z3Z2pjZsbQvVgGD1w6opb+Xeem7S37JX6a2X6sTBm4
	FRTKLRYyCylQbeHbBDAUziJ8ltDwdog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749690;
	b=Ha/LY2kPu4cLLHftTrRwXrwhy3opSIAKrwGh66RRsyS1i/SqcosvQKhP++k2fYUUQRWr/C
	G/n8qM9o7jrvYyG6IiBTS77dSxpbQm0eY51DaIy7TPP6xVZn0Cp1CdDi2scUeXirJ4IeFA
	ADIltpfLMTz7YCCoEJfp6WmaQ5zAGt4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9c0xfB4;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0458E602C5;
	Fri, 18 Sep 2026 16:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8541F0089A;
	Fri, 18 Sep 2026 16:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749689;
	bh=XkdJK9giFjk4YEtdusx2eMulBHT1yDg70N+OeuIzdy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m9c0xfB4N+NXT0c8cDLuNHJ7ec/rQ3jURIK1q6ZLvhP71iE7DZhb9SLkAZYAqKs+x
	 VGl7K+dqvCryyuRvs9vOlSfvh9WSywC5plv/gurICgHD5fGc/p1LRd+i5H9z/V3MbS
	 8Yw87VL50qTMVjIPG9mYqcjnrBeZYlhQR2PxaO+ZqrVXNQIC22fnushTSTfn3NpjeF
	 sonFNU6lX+BZQViV2c439ykmAPR+fGLoig2TZx7C7LBwU5TEUzkn65aPQMMSXnAGXJ
	 fZu/xuGM/KzvCuwhqeWw6HrHh8hW6eznkuq8BLp4AaJQ3u1NqrAhIclQuF1+T891Bv
	 zQ3eOceISmqMA==
Date: Fri, 18 Sep 2026 17:41:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Rakie Kim <rakie.kim@sk.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: make Gregory a co-maintainer of MEMORY
 MANAGEMENT - NUMA PLACEMENT
Message-ID: <aq1pX_L_On9rWspf@gremlin>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
 <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
X-Stat-Signature: 1p4tacyznzndacmf5qspqwm68fac5mq8
X-Rspam-User: 
X-Rspamd-Queue-Id: CA534C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789749690-590797
X-HE-Meta: U2FsdGVkX199WRPrEcfLRHD2XE6jqQWGFQ3X6dfVa1RqU9GvaP0/vg5steMkeBTiUHw7nMFSiLIUN4wPi1lzg4Ixez+HTgHrRKZIOUZeRqMp+/u5ZQLaJ1o3p1aO6uaCA82wFkL4q0VTz/wrXCNkmgcRdtSvV9mD89kChrUtg7xeDVY//1bQIK4/qitc/km6xH8bp4K/JJYkog713Av7tzUG1EhOXfXg8hGdoC/a8J3rPIWMTf4v3S8qdbwD/1X6tqjgU9J9C0LaNOMf4Gh3CZ1/HGDuXNWfLECCYzrNPlb7D4Rhr81EyL6lTmOVnLO07o2RjjIvqSGIqu/mld/EJlZyGglb9E+YtmiLd0xQ6Hv3065HyCLrhf7pEzHmqkTnf+uAJx9CuX1LgCIHKjp4VAc4NFgio9+HA1z+kXXyYJz4n10E7t/Y7jQw8jRDVdHQPzQjIsPyjlTulKGX7bJ2Cf4ekr3l0VzuTKnba5ddDs8HEZtGz14Lgkp9fofg6iQ/820kleYe7j1Nk6h+YTnYcRDBM9MaR5BHGhDBEDhgDF60YoF0IGo8ElS+I7BFYUDpLKyf1rxMCcWdizqHn8J7Hb4CPf5RFvtJStJ4TAGIwvp+x44BT890VQJjBOo49GD6HfNLtEeuhhVhXFvL6eVgawzZwif2B8XFfU/wuWIZVfgGP/nEgXXDyBBlokOpfwKrz2FEleqQhK9dZ2X4FwtKn647ApVut8hWpTgQKiKbVQimudhhJDHURJ/vYOnOhJX7GQnYPz5L8noBdh+xCpf1jMVqRhTgon3rPgmy4y28ntsbPhQ1DNoRBsc9yPyoqjxwblliaaCSVUcCxC1hK67QfOOnbmfSe2ZYHNRML0RkcU9vCaGooW8taAHgWjz3BhCyc/5i/F/HqQ2dcUTzR2glWccBNPTKKkonO5g51XLIw5hyXB27aFU3ljUuLJoQNC9pabRuq0d2oPOJVc/8HyO
 inF/b3h8
 Uo21v2ImYJuCD53ya8wl1RplQ8chqzcSclOP+0cfCziSugAg4GDbJIEPb9rbYykqH9ooCDDim/Tsy39zG7D7Bp82HlLHdnqpgFgBEemEgUQ4w4RqYZQp+bB4srRGSXVEElQjPsETBumPtYTf4DuGGo38IqsH67ZLZt7VtncxTAY/9YXZlIewkN49+O2UQufh8IdtOF5gvrWBYaqrlIG5f6+hdj0xRZ8WraPm6nePjsNLGcRAUr+0SdwyE/RnoVd71EJv7lNmboxZqMgRaD1ngafe+CAeKTKscJFbM2K7wwvujGqJ14M8s+yTskTAsachihYdw6PS9u1/lpMkBc9HldNGD7/QpMMrMzxCw2yvhBSm538Y2RS/kEHpvkp/BkJepIph76/DYIfKxEIRhFYMxVJoaX7/2WiwHrg+g/hF09x2aobLVRngQ0bQ6svANtB8FGvu4JlqfUmO35fC/97U1OwTb29p6Sds/bDFi2FAJFlcSzEZ4fj8FHHwhc3CygZnhKRtD4AZAoheAzBwJ8tCROJYBsN6RKnoBFhAXAu5UyXfT+xS4yuIbtpP3p5Ph4gAHJi2Ykv0b5WvkPKexbZV/6PrkcZFYcVFKyQicOKNF0UoBRoeTi1TaIzzm8G+0zFAQjUTGI4JIY9a1ktbHVHsgEdjZYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 06:34:26PM +0200, David Hildenbrand (Arm) wrote:
> Gregory is extremely familiar with NUMA placement handling and volunteer
> to help co-maintain the numa placement bits. So add him as a
> co-maintainer.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Makes sense to me, Gregory has shown himself to have expertise in this area
and is very technically capable and great to work with in mm in general, so
am happy to see this :)

Congrats Gregory!

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 344875eefd175..2b99a593436d2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17298,10 +17298,10 @@ F:	mm/numa_memblks.c
>  MEMORY MANAGEMENT - NUMA PLACEMENT
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> +M:	Gregory Price <gourry@gourry.net>
>  R:	Zi Yan <ziy@nvidia.com>
>  R:	Joshua Hahn <joshua.hahnjy@gmail.com>
>  R:	Rakie Kim <rakie.kim@sk.com>
> -R:	Gregory Price <gourry@gourry.net>
>  R:	Ying Huang <ying.huang@linux.alibaba.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

