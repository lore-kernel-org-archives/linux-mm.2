Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E891AD1951B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 00:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D676B0088; Mon, 26 Jan 2026 19:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CEB6B0089; Mon, 26 Jan 2026 19:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1EA06B008A; Mon, 26 Jan 2026 19:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D30B36B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:47:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 799DD1B0AF7
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:47:33 +0000 (UTC)
X-FDA: 84375905586.25.537A582
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 106184000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:47:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvpsxbeY;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769474852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JIAOWoTOVVgS0apUA0EQDBlj7SL1Z6Y9hKPAsx01xE=;
	b=Yb9AZMF9WOSujyiywz0jhXS4+7RpV6VYshh39XgNepmArYJ+atRw5LckE/Sg9YpKNlqbst
	dZ/mNlTFtoVkb7TZyBD7A8wnyadGMbvjR6x7SypIWmjwr4nXIrdcsXDRhFG9tsZMqdSV+S
	c2J2yZwF7HGZzUOgSr8P1/xKjQ0RyX0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvpsxbeY;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769474852; a=rsa-sha256;
	cv=none;
	b=OJWO4wiYa6nVg8EF6jzTepSVco8YJWoK/2FZnxW5cj+lh3N6WgRJ/YjwAk3qZl8bfhP+yz
	z2GfIdLyC7QhNqzbMRZCxI8ItAzySiAPT9VpVSg8tjxGVGfWa5DESzeBMXLlXcZxlXQo4M
	2HSouYfPd6XwTlE4m/dG8ar2kp8OT8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7707D60051;
	Tue, 27 Jan 2026 00:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA882C116C6;
	Tue, 27 Jan 2026 00:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769474851;
	bh=o4cpQ2rr6KeMaWgY+0sspntwm5GM5tEpAhU7E40caqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvpsxbeYxiMgxSUL11CwhU52txRzTU2qIG2m3opA1l1AT6SI+JhguSAdsFzbWhYEf
	 dafvZQ+KG8HXw35DCitqpQOlI1JMdCsNBlDzN6BvbgPveKjRVS8YEXQhJO2W5YaiAh
	 qZyaki7kf5wOaYxPRRpSbh47j+yPU4xp5czI/HzKWsdeHrW/2Ge8c+9KcDvMRELAku
	 8Zmg3C/Qt8goOgMpQhaVfqetZSzm30Y5YNTaN+aFmtkXQM9iMWW972e9HuPBlJ/+EZ
	 lmgixTDm0Ba0tooxa2SQa12xZZBpAafteMFa+Ix0U02jnXXdTspuRi3gPp27KeL+4L
	 nEaw9Bzp8li5w==
From: SeongJae Park <sj@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/cma: Replace snprintf with strscpy in cma_new_area
Date: Mon, 26 Jan 2026 16:47:22 -0800
Message-ID: <20260127004723.74422-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126174516.236968-1-thorsten.blum@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 106184000C
X-Rspamd-Server: rspam07
X-Stat-Signature: gswr5kbw9b1uezymhrkxc7eeo9dtaxc5
X-HE-Tag: 1769474851-554544
X-HE-Meta: U2FsdGVkX18mT8baSjnqvc0yvDpO4afPsiOSJAOuTUFgUYsfAtKjt+q9VQzvPbo2ZFxeVyv2GsLXjIQou81xykrLkERPXa7F3wzr6KdefYbD8btxQx3pi6FLuvmLp5iCrjByQJvEaExgfi+ZSB9DomcxtlPZfTxRi+Fi7/orNU525xCiPZs72NlAOZ/Jjf4xOwGkvA4ZfZNJpphArC6XGybNGSpLiu5zD9KXEs5fS0/KLAbv42d0Z/AeVqADoxfKUMaLQJWrujNJxuxXK4YTjkQOW6xITZgq7HP2SiQZdxo4180ipcEwDh50qLmFJmuse/C+8ZbqG74Vonvp73K3h7IjYP1v6UhBsGM+74zweiZ8pMrvk1VY2Jt+wCUlpA0yCK8sUjiqMW4bkl+QiIHAX4t/k8JBpfCsBK6ewcai9EeFGKWTig2QbVF/Ssv8N1O3ULgXmXeWy78OHBEtSxji/XeUOCEniJxd1hWrg6YQ0WqQ3UhrqOc8szj0vYvVkSmtJ24tlGfhNkrk9TwmK9N56wxcXRkMqSlfuxDLgUzXihTe5Culhd5CrJ/U0kBSCW5lZFiwMqJ2j5g6vUNhIoi3GUzsomnwLcpGcEzAVX88Vgs9BN3qhdU6M1XljbnVLCOc5Fd7hqhQxlwnKqhwPXB+x/xIabCop1AfTuqQ3rRh7E86GF4ZM27GCB+Q54rN6FTVnfXZ3is40LMMHO6q/MGB8Bfv8eILC8JWZ3gxtJAFj4JdfFBbvh3pxvjwtrOUGwHQZewUj0T4ac9P0ZT/Smi8860QHc2o/X9zLcR5dPnzfemGwbY7bzxGE91iuitaBeAeg/1WVDam7+nVGKiT0TbcqrOtQgyZQ691pJpFOWxGKFhHMOoAOZ6rYkqN/aDxAS9i0y9vac6+sVWagiSPb77c/FgmJgBmlhgipv5j+26TF2HOinShic+BTporGy5JcXBn5Sd46gw8zdyZ2u4yBea
 dbAwGdM+
 cyTDhTjxYeom3CMWVJscEGfIxWgHuPTqXV+uyHhpWUmOHZrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Thorsten,

On Mon, 26 Jan 2026 18:45:15 +0100 Thorsten Blum <thorsten.blum@linux.dev> wrote:

> Replace snprintf("%s", ...) with the faster and more direct strscpy().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  mm/cma.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 813e6dc7b095..44b43de28c13 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -22,6 +22,7 @@
>  #include <linux/mm.h>
>  #include <linux/sizes.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/string_choices.h>
>  #include <linux/log2.h>
>  #include <linux/cma.h>
> @@ -233,7 +234,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
>  	cma_area_count++;
>  
>  	if (name)
> -		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
> +		strscpy(cma->name, name);

Any reason to drop CMA_MAX_NAME protection?  You can pass the size of
destination buffer as the third argument of strscpy().


Thanks,
SJ

[...]

