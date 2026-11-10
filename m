Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E54D60A2611
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oslHdUoi
Received: by kanga.kvack.org (Postfix)
	id 7A26D6B05B2; Tue, 10 Nov 2026 09:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A4A6B05B4; Tue, 10 Nov 2026 09:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8F66B05B5; Tue, 10 Nov 2026 09:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1976B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:12:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BED904091E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:12:46 +0000 (UTC)
X-FDA: 85419400332.28.5591EFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0C700140011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:12:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oslHdUoi;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794319965;
	b=YKX629R1G7aC9JjvoBRwjdCzc2hqtr8UXH2YhOKIHxm3RyPEUjhhrPme4bBg9qwrWKigoE
	Bu06R+wrpmanqVg5VwVx1tiCHf1Jz3ahwDgy4us/NhpE0LVeN4gxw4i8Ga4d8aKh6n7BxH
	2UqGVEsBS6Chf+QqbnZhV02prClh/Gw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oslHdUoi;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794319965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+V15z8m7UdvbBzbEX/x0QkH/lxGlqnHfdKeJrvJ+5c=;
	b=Uyzg3+Kv5SktHGebXQ02BRtzOnboPZDXQjTuJZGVg5BEF6g9AoF1r4oyW8AI4CFSLPP6cg
	saCiqZC8IxK8im5PS+hE4GO+yIR7hdBFXBXw1/WHx3xGyrJw0KdcAC0/OrmFfJTuc8ZEBm
	vvlsii+x2RXP9MMlRtPTsPuAMjAMS+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40E9A47091;
	Tue, 10 Nov 2026 14:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C53B1F008A1;
	Tue, 10 Nov 2026 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794319964;
	bh=m+V15z8m7UdvbBzbEX/x0QkH/lxGlqnHfdKeJrvJ+5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oslHdUoiR64VbiiafyI6ATcvNxwYlRY3xb5IU4xDwX3NMiXfj7MU+qqsfifj1rcUG
	 DOyRCuHOntA5D1mRI5qQa+Ln5f9fnxYbCTREpwcLEzzmZ2bw6nV20OURxi6yDpCuHY
	 gdOTvTKvV1+RwZ6wLq5FfvHpQNhVZIyuU/KMDYbkFzcm8g2P9buai1+c7a+8bvbFKl
	 xYFTrL4H9y7STBsNKw7DlxdD+V43XJ4zfpKlCb5xdikJ5VKtsCcbeRi00ZQ3ejShZS
	 ycVa9jX8FIg8k+aBe+Ip0naomQQKV4ejKTgNyPkZh7oUXRPun3NjlWw61HteaUKzzF
	 NmYsjMXypqeFA==
Date: Tue, 10 Nov 2026 15:12:41 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 07/10] mm, slab: convert CONFIG_SLUB_TINY checks to
 kmem_cache_debug()
Message-ID: <avMkWtwUQkQVkp07@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-7-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-7-0484ce59eabb@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0C700140011
X-Stat-Signature: 9zywxo1kd4fnotntfhmkgmzxzj4ek19i
X-Rspam-User: 
X-HE-Tag: 1794319964-78297
X-HE-Meta: U2FsdGVkX1/c2+ZTBWdR2sDMolybsIWGHOGUsX36E1VOf3wPt5x8Y10jxq5HaaaqOU+oecEIM6E9S8RhqHAOLbP2yFjiBhvCKUKxX8GHmgn7DZZ1sB3cPBiI/MWwjuCRS0ESiVgCRCTQRnLsoMY5VZ045CfCT8Sj1sfGiEWTrUj/ZYktqw5gq45NK7/SHU49936x5FjuuBDfHlO13+0xaALctZkEcc3o9Q2VuWTO7DMh+aCQVHPcTOUFNyvrfcTvoMRpf0zJE8NjOc8+800UJsliSQlEiVfL45dqgk9LHWk/wdRKwD8SuXq0LfiGERmYE0FeRjtTpzRdfMIqu+QLPLrFBUNJBqAPvQsTsMyymH0UB4LGg7Xrw9Y8x476/L57DGDjAdncZltlhLzJ6WohbCi5AtqXJ48aBGol2DsOXndSCWaymDOMjReG0o9gPInX/eiO87YzTrRnKrFh4U6Fqf2frPm2BzUqE8Juok3D6Oxeok5AVnsZunxGsHB4+R7uEqMXZRMQD87RGOtvedaBZJEUznv2X0n7jZEZJ2jReAI2hzFO2hutlpteDOzH0BfXxZYh/bCeTqtkmbeSB5zdJtpLn6wv1yu5R867CpZ8BoyXo5a9j29uhYRuVcaa72XBQpDz/2W9vCerFLh6+J4fKZdM5k6VeZDaYDiTJkfoTaTrex+8qAFx/N7MgxadBmQ8TOm7YRsP8qj7XjR/s4t35VPrnkdG0AxiMkwF7hH7EfW9prQXo7ENPfAeejM2rsiGLPayULiG+K4ZM8OStSc1wqxTv79bDGq9qyOFlPmipO2cC+FyxacdZrJ0pxrw5fjoaH2KXG07UZxcnjR0SzMhOQNvHVHF2vtmJrmlD9aNLpUom1c1uvlujlAY0lbNwo2Mzexxme99Ea9CyqAvEyopfOIkn5eGemCcpKs1aaOSDhHRXK4n9QxGO2GuParKBS6i5XsmVGCX5Ye89hnAMkp
 O+mOVxH0
 ZenUiNdnnCelDjykehYqSq8AZN1zo1eIBbRbyjLcLERy7unwgo/svxwFGIHHAYE1lqfm9TQ9jDTRgfacM4D6x3VSp4UY+7WLAw449Gfe3XAEobrADQt9lUAjtmx1aZMAb70dqePM+nulXpZydLBoqE743KZ0A80yTiUr3TGSbSPIXVRuTecWi3EzJ+Fub90BWB9JMzdB02qZwsl3CwcWNNQQs24/uP0eBq1pdyD0lhaUgFO/TPoJPkWYD10rIGaSms3dPjhCNKCPZlE+NGVJrrHalvFtVWIwAWPOnTRDYVs5R+27ybjZUpCSYGa+T8nh2nIGfFf7EMRaBjaYbpzCmsyzBZe8dtiiR3xYMdZwT32SBJ8wzNUTHjPoZzMse8adPJoXoeTKMXMrRMK6oebv6BKd7qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:56AM +0100, Vlastimil Babka (SUSE) wrote:
> CONFIG_SLUB_TINY shares several slowpaths with debugging as both of them
> avoid percpu caching of objects. With the goal of replacing the config
> with a boot-time decision, extend this sharing by hooking
> slab_tiny_enabled into kmem_cache_debug() check itself.
> 
> This is made possible by the new SLAB_DEBUG_NOOP debug flag. Make
> slub_debug_enabled static key always available (not just with
> CONFIG_SLUB_DEBUG enabled) and have slab_tiny_enabled add
> SLAB_DEBUG_NOOP to all caches in kmem_cache_flags(). Do this also in the
> CONFIG_SLUB_DEBUG variant, which is currently exclusive with
> CONFIG_SLUB_TINY, but that will be lifted later.
> 
> Remove the various IS_ENABLED(CONFIG_SLUB_TINY) checks that
> complement kmem_cache_debug() checks as they are no longer necessary.
> 
> While removing/adjusting the CONFIG_SLUB_DEBUG #ifdefs, also convert
> CONFIG_SLUB_DEBUG_ON to *_STATIC_KEY_MAYBE().
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Nice cleanup!

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

> diff --git a/mm/slub.c b/mm/slub.c
> index be4e1f193295..1b7626645068 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7874,7 +7870,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
>  		 * cache.
>  		 *
>  		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
> -		 * caches with debug enabled, and all caches with SLUB_TINY.
> +		 * and caches with debugging enabled.
>  		 * For kmalloc caches it's used temporarily during the initial
>  		 * bootstrap.
>  		 */
> @@ -8757,8 +8753,10 @@ void __init kmem_cache_init(void)
>  
>  	slab_obj_ext_has_codetag_init();
>  
> -	if (slab_tiny_enabled)
> +	if (slab_tiny_enabled) {
>  		slab_max_order = 1;
> +		static_branch_enable(&slub_debug_enabled);

At first sight I thought this would be unnecessary if we handle
slab_tiny_enabled in setup_slub_debug, but slab_tiny should work
w/o slab_debug= parameter.

-- 
Cheers,
Harry / Hyeonggon

