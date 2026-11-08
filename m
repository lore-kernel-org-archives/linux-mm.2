Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8443606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QmLTW06v
Received: by kanga.kvack.org (Postfix)
	id A3E5E6B05B0; Sun,  8 Nov 2026 12:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6976B05B1; Sun,  8 Nov 2026 12:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF716B05B2; Sun,  8 Nov 2026 12:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66D396B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 12:58:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD9D9C04A6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 17:58:17 +0000 (UTC)
X-FDA: 85412711034.05.F55391E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A05B180004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 17:58:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmLTW06v;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794160696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yNrGH+7MD7g2peNpAiNoMgnUZhFrksazqLFqyuuJY0=;
	b=NiOe5N769B5D0IqGpOab8E2gP653bwEBHCcMA87+cDjfANJ6kxQURPgnLRQ5amARhYlU0z
	dqNvLjgP5MSevIq+nUGT9G9+Z8bdkp8qbGDkJwnwDgmT3Um9VYEJrMWE7TkttEk+h1Fj++
	B7/bQIoY553xDa/Vyd91yjDr9bbeUjc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmLTW06v;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794160696;
	b=lvZ8gOMDosaKdEK8fCIBEQ7B9wVAU2AIsETeRPcVgFX4Nd7LFJSY7zjX39l/r8IVh+m99h
	fpEuiuoHsPLj6J/eW7DlmWdeyoMSi9Fva08LWmi/LRLT3uckK14oqW4KcawNuAaiDv9xPJ
	RJ3vbXeONmFEObubyMS+tckmn8jaTJ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F29A94022D;
	Sun,  8 Nov 2026 17:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDE31F0089F;
	Sun,  8 Nov 2026 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794160694;
	bh=3yNrGH+7MD7g2peNpAiNoMgnUZhFrksazqLFqyuuJY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QmLTW06vCK7JGjKpUs7lHZJh/niGMLMEpTh1l2EvrBm+QsSfrnL1GILxSrUKRTXqp
	 ESTDJyOYNdEXxfGzKoQ1sNPYkJMw0nOzd/lzwiyu4AC4vx1ApGFNboKTCnS9m2qq1O
	 55at46+B9nyvqfzWvK+ho8uGu5ouwYIybklCAJRFBWB+5Rn6TgvfEmY0Qas9BCfIlu
	 YkrllIoxlF1Lvy40Vz2CyQYDGFG0awpdUCwamiuFUQ3kfMoFckuq5wzA0rD9awCDiU
	 I7LeiZ8enwGnowmE3GTgZcIm+pKNpK80ZqCZEwWEtIADb81J0X9NEpxqhX8af6Swg4
	 ipQI9U/cQ6wgw==
Date: Sun, 8 Nov 2026 17:58:12 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 06/10] mm, slab: make SLUB_TINY handling dynamic for
 sizing decisions
Message-ID: <avC3UnTk21iV1i6O@minisforum>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-6-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-6-0484ce59eabb@kernel.org>
X-Stat-Signature: j7wz1pjk7dk4ozdzzbdmna84i4iw3cah
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2A05B180004
X-HE-Tag: 1794160695-354822
X-HE-Meta: U2FsdGVkX1+vZ8NX2CyxT23LTN6kBBpOdThioSsu1ydFx+h0ScfDPhFmHdxGP1yJyM+2T/CodbUEVpqBZiULPSoCskjL9x86eNFuejhnTxu6uRgvbD8wxXJKZEiElxeVhvUBAjuhUSX0PPQAQAO4x/MSUZYyhSE91jRplpO+EbJPMhyjVtG+hXPWuUpk5CBfJpNaRbe8lvg8dJSexsl3Tzk5xf6cVvM4jVL7J4VJr6z/EM9OUb/JI7qVUqKDcvHzr8dJ6gn3ugr/3eVrqHpkXh1BatRsNcFrTrAO5dQPEhbptVdcDHSAm3wXLlkt0yKTG0walB4AVqLAvHSgq3b6uXSJjpKFLcbOnSy27dzgFqriO+3nzErYmxMRvmQdLnqetR3OL9PQT3/lQL8Jo9P9bezlrT73xil8h8S4u4bzEFlUxzuTlWR82CW1tEm6/hqm/xh4LlTZg3UEgbh3IX97JjBrEhugiMVW0CooHDXIwXNkQhPL2+C9XICaejFdz5k9ALGfxpPzsP2FwlXlavw9mAEWz6qm7HGXEfqIu2ginlPoxa39TJeCzTbWjmrZrKBpwtDjFbZ+5Q5kA/giIYT2iEU7y0u2GuCTgOHaYnp04wkBRk8zyBw0YUmcWvl5x89+kTS8T0Snog2VOp/CocieSH5uABZwlffV07+I4YNKdWrcVG95gW5jJGdWVcNScc90oBhdqmd9bFJBAnhL9MOn2VDsY9a0sPTWggeAAnQJ1ryGIznCDDqVg5rAoRfB4enZHa+idu45K3BV9eakEt61zDCx2UGBsDWmx09fO4bQWACGhc/4MajjmjdW6J+M+tBjpi1RSKlaYA4E545kEAEYt6JO2EIDon/cpmdo/5uUfnbzez7VeoN+RQgpISZK8gs/2NkXkGuZ3M2AJAO4X5LDumFpiJukRX34vE624jPKPFXaoBztHJZzJn9VbJkQgnCtc9m99K8/3kGyrGchHls
 2xs950az
 BqtFyvCqVKJ2H22ckKQ8zp87hFs/svHnYVRwIecCI/w09SWE1khREIyyTrz/j4hkTOyeBzvULnMKnGDHdGkJI4420XWIJpgl+JEtfu9r3IPb4rPRr+beg+KNsN/jtlAfrK8qq0/F+PKDhNsVIv493ePszQRn0/galhqPwfpZxwE3oyJDCf7KvHiIu6EeIWs+UIpRiOFcHosFQW7ZuO2L7N1FivbQirbN6dnd3lBuZ0rrJ6Ujvpyyk+/yQtWIdukdYjlN2OfHsQE0rvnqw1uo0Pz3cPuZdrRrLakHR8Mfd5mZKi5ABm0QTcATmZ8o0deEJmBEGucRrIjFu2IAwYta3CD0nob91TZIbAGNPnUCmiHrQFSmJx1f3WoYMc0QWnAN+q9bN+j3aHIfDVQuV+E6n/yXqzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:55AM +0100, Vlastimil Babka (SUSE) wrote:
> Enabling CONFIG_SLUB_TINY results in the caches' min partial slabs
> threshold to be zero, thus every slab where all objects become free is
> freed immediately. It also sets the default slab_max_order to 1, with
> the goal of reducing the potential of internal slab fragmentation.
> 
> Rework both of these decisions to be based on the newly introduced
> slab_tiny_enabled flag instead of #ifdefs. It's still possible to
> override the reduced slab_max_order with the boot parameter, as before.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>
>  mm/slub.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index a3ee1bdf0eb3..be4e1f193295 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8027,7 +8021,7 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>  	size_t size;
>  
>  
> -	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
> +	if (slab_tiny_enabled || s->flags & SLAB_DEBUG_FLAGS)
>  		return 0;

nit: this change is not mentioned in the changelog

Otherwise looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

