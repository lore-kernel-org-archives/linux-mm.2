Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2450CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 06:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4DC8E0002; Fri,  3 Oct 2025 02:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885188E0001; Fri,  3 Oct 2025 02:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774398E0002; Fri,  3 Oct 2025 02:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2BF8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:30:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D40A5C06C0
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:30:10 +0000 (UTC)
X-FDA: 83955828180.11.83D2F49
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id D57CF40008
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:30:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="gy/GpU1O";
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759473009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkLFiACyw+pxXQ9Sqz5bYmdEFhy/428iFAOlJwo0q5k=;
	b=Cxrd5u7gik0Ly6oEzMRElo5oN8mVPCtde5CetP05kv5hIytzSnnoab+l2flISQvZR9GUiT
	qtYN7ZZ4XNA1h2YjhiGgQf6IFETsJxB0hkBlLznNqjq1nR/Zsd3wp6n2biygJNkH7174jI
	V5jh86cbR0bPY/hzR6cyrsT0B/RxeTk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="gy/GpU1O";
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759473009; a=rsa-sha256;
	cv=none;
	b=YhP8BptOdbSzq2p72kth11se4y4aMqrrh2awCWaM1CB3eE3YtPELFbAx9N6sJvZwRCsmS4
	H0tVQYrHioYW+OTisEmhPPz/vVzGyDgbFb50WqnbQV8SRpR+mH5bIhgFGaz85c7413kwQQ
	hmwAWCtWV4bvPff2j9AyiiTQF2Ybezk=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62fa062a1abso3385238a12.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 23:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759473007; x=1760077807; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XkLFiACyw+pxXQ9Sqz5bYmdEFhy/428iFAOlJwo0q5k=;
        b=gy/GpU1OvigHLjWG/xoqudlQO1KhZrVaIyE33uNL51hdwg6PrjU7/as6s6980tGDLF
         BKMgZbo/KieOpahE1UZiBPaYcrACO/zS1BmU/828Zcz/2r9qwySi+MGkenECYy8weu1N
         OS/klHELSgLGF4j/oW1dMy8jxZC6Nop5nD3/UjgAywPMMnHujz5FFv8qZhjiW/bWh+oF
         YNdU32HgqZH2TFe9RrvibDB+0ixWBcrGvZnLo+FqtRtPw7x9dhnVyoYuyk0oDNxtHOx3
         268lxxKFQRa1VXJavKBoFR0HUwiKPwtQzpNu94m1Ge8MrdzGnrXCFDESPqd6VWpYb0m6
         YLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759473007; x=1760077807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkLFiACyw+pxXQ9Sqz5bYmdEFhy/428iFAOlJwo0q5k=;
        b=eQFK+J+Ct2kyBPc0kWzFwWrk4NRnIRU8wz1XWoXgUQVHbsjTtSUyXmkhDjiMB1GE3W
         6XA10Y9lM0Z4bSaUqA2TqP7Uq+86l126lxV7BuoDF66uRfT2wmtkJhdXYEtaHqlYpS6a
         vMofz2w13fY83zGZYiJb13MX828U+ADerWS64Foe5Sb7ISxF8rUd/K+QjoVaGN0N2hUB
         gQgPUuOwXX6qVXMzaYiTnxSkPchZPsipAfD7Kai8oiNQQHxtyxR57kV3h4t/YmhbzpnG
         sdbWpxQsX6D/dcuDakgkqsAQlj31L/Li8I2d5hhlyOwuyTov7ZNuWlXjp/MTFysamsZq
         HIMQ==
X-Gm-Message-State: AOJu0YwsXK4QU94vY8C5iUXQcyHM9p91IrVURHyqiHLv3mFm3VIllwMw
	I0LWV5+s67kCmuA2yLFOO3KWnhZM3rUZhNdHR20V90DFn7FRHFicYVG/30vtfmzZwCc=
X-Gm-Gg: ASbGncvt/tcvR1henx6ZiLp+UOr21XEypZXEuKzHuv2JtbFG1VPlocwutRTLHBaQg5c
	KAEinL2xWxkwqlrgfxSlY5mDYmG/fUoy4KXOvPdcOaSA2kULepuPTsE1WJSZnKSD8+PCNpGGZUg
	TctuOQVoGeuuzoD0Le/tbTGpfwDJ8TwEXOZDr2KQm3zttUAgA/Rw+32GzO9PtdjrY8J+5MN/n1r
	l4vPuxKjbo80drg7X2QRAWm2S79Sx7UIC+Ik0qE/wShc40QjOkJ3jbFszWJcoIxs6Bad4SrkTEr
	wZJbGIsWwXjt4GRjOQasklZ8fQ1JYS8ohbRPKoPZU149cH4RJQx2k3dL6ctOuSg3JOSmGtqLdXG
	5So0e2wP1N2fEbVnqKcG6h3dTedaU0b1Uhfp6YdmhkHk8nrLPLtJsKLf7lsqD
X-Google-Smtp-Source: AGHT+IGXX832rzQ3SHMm9cxe/AbXuwPv3O0q1qi/7SX7y0yjjhFdzCNvPBXopZojYDFGU05IQJ2DLQ==
X-Received: by 2002:a17:907:3e93:b0:b04:6fc2:ebb9 with SMTP id a640c23a62f3a-b49c393aa02mr220162166b.45.1759473007029;
        Thu, 02 Oct 2025 23:30:07 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b4869c4c1f6sm365114166b.78.2025.10.02.23.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 23:30:06 -0700 (PDT)
Date: Fri, 3 Oct 2025 08:30:05 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 10/10] mm: kvmalloc: Add non-blocking support for
 vmalloc
Message-ID: <aN9tbS3RkEqm2tzP@tiehlicka>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-11-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001192647.195204-11-urezki@gmail.com>
X-Rspamd-Queue-Id: D57CF40008
X-Stat-Signature: uudo6y4qen4tj6zs81ty4x8obqukazw4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759473008-497416
X-HE-Meta: U2FsdGVkX19j/eqzsnlP7szc+4fwgnmnxMfq1bZvM2Biegi7Syz3vsds+c028kn3DQeI6Uu8cEAfqeKT1JOMNWXhw9MQcLtYKGjCtrvYOGb0F5ekGe8xQUGJSZBQvEB9TQlel2Z+Iy5ZyCXeOFubYjTLVnSkhKXASKw/hHqQo3zmoESuI/137o/NOh/EshuOTEMhQExuZvV9QWus6aPjC5YCBf61tter6o9mekj/mozpG51UEhnmy+AvOcbrHyyROY6VgILY5kSMMHi7Z5Q0VtrJ6SdTpvZrL7+L6AeJBJhWtzxakR0+eXF5pbubI3Wj/uDRV4ubhU80OJAxQIFQqELNqdkvCcoKec4CZAHaC1v7CR0n7eFteRho8rgrKCcUfqro4na5K1aWS2mnXuE9oQTbA6KAIICIjn4eYr1pJABgFZ8FuaVRT/n0ombjKpcpUysiDQQ7UeYPKH1K91HxrUxlGz6AnsNcGt0yoKj+LSJaKcwcGVB9q1R/86bjy0GH5h0EVpqOy4uwYgDMG4rAWRcwjaerN/gj9m7jlboKIjh6wxcfwgD+0nLTCgYsRCnpJ6kHLNUA4M0pewZpFYeUrJaxW5cdJ0hGTAq0iBC2alWLDPuZCEssdNTUJLtZb/SNoOj4nYoDfNPC7Hu05vUIcz/tD64zqj/gqwKSQE3Wajke+v/K8c1bw12UPDAtk7g6M8or57z0NFZPKBN9DfjrDWBOD/jOPM4J1j16Sy1CyS9TOr7J/E75Ozp7xLJZ/mQk80RyUbiVVbZPrQVEa/bRncgQYsThL+qyIA9oIhME2lIzl1ooDQp+qEM4Xm3Ro8hSGBcSGtEN70dippVyCrMntSNckAY6dJFl4C0AWh8xoWzVOUk+uqsMootY5VIrRrKvIDH919WCY9uMOSQhSwrK+3vWtHkOSnAbj0g6BK3AGDNGc82HGAQoiq0E3gkTNEJIkNmAhFHS23wLDjM91S7
 UssAJw+1
 DbgBEA4TQ/mUCFhxQud7Q77k2Wpds15csXEAGZ2wbpqhuVluyl2AQQJaA2ccPZi8938S6cnedP9BGm6cMjZOetYEko5jEhPCeoGLqmU6p3P8PDQHG/MvWXP2QwXQBnpjJ8iG0eU7Dl1CVDwkbz51E365MzVoxELyDyzNRbLuLohPCwfz9nJRs74NgJ44MhjERkobnP3gbACe/N7blW8Y7YHjHDkQM5PYSUnUNebCsIh5CczlOeaVk2gB7gfGz5L9g/cT1GBOHIEkBQ6CeJ8rkvF6CKvDONzxDXUxdeQ0D8bSOwzT/ypqUnRMs9B8mvyy3kWBLLu64Kwwh760idP7aKq1+DbuSeWpbvK/dM8WLhhRF/AKClIeqIPNlDU5zsZZcwhYz9beFDgTDPLM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 01-10-25 21:26:46, Uladzislau Rezki wrote:
> Extend __kvmalloc_node_noprof() to handle non-blocking GFP flags
> (GFP_NOWAIT and GFP_ATOMIC). Previously such flags were rejected,
> returning NULL. With this change:
> 
> - kvmalloc() can fall back to vmalloc() if non-blocking contexts;
> - for non-blocking allocations the VM_ALLOW_HUGE_VMAP option is
>   disabled, since the huge mapping path still contains might_sleep();
> - documentation update to reflect that GFP_NOWAIT and GFP_ATOMIC
>   are now supported.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/slub.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 584a5ff1828b..3de0719e24e9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7018,7 +7018,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
>   * Uses kmalloc to get the memory but if the allocation fails then falls back
>   * to the vmalloc allocator. Use kvfree for freeing the memory.
>   *
> - * GFP_NOWAIT and GFP_ATOMIC are not supported, neither is the __GFP_NORETRY modifier.
> + * GFP_NOWAIT and GFP_ATOMIC are supported, the __GFP_NORETRY modifier is not.
>   * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
>   * preferable to the vmalloc fallback, due to visible performance drawbacks.
>   *
> @@ -7027,6 +7027,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
>  void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
>  			     gfp_t flags, int node)
>  {
> +	bool allow_block;
>  	void *ret;
>  
>  	/*
> @@ -7039,16 +7040,22 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
>  	if (ret || size <= PAGE_SIZE)
>  		return ret;
>  
> -	/* non-sleeping allocations are not supported by vmalloc */
> -	if (!gfpflags_allow_blocking(flags))
> -		return NULL;
> -
>  	/* Don't even allow crazy sizes */
>  	if (unlikely(size > INT_MAX)) {
>  		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>  		return NULL;
>  	}
>  
> +	/*
> +	 * For non-blocking the VM_ALLOW_HUGE_VMAP is not used
> +	 * because the huge-mapping path in vmalloc contains at
> +	 * least one might_sleep() call.
> +	 *
> +	 * TODO: Revise huge-mapping path to support non-blocking
> +	 * flags.
> +	 */
> +	allow_block = gfpflags_allow_blocking(flags);
> +
>  	/*
>  	 * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
>  	 * since the callers already cannot assume anything
> @@ -7056,7 +7063,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
>  	 * protection games.
>  	 */
>  	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
> -			flags, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
> +			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
>  			node, __builtin_return_address(0));
>  }
>  EXPORT_SYMBOL(__kvmalloc_node_noprof);
> -- 
> 2.47.3

-- 
Michal Hocko
SUSE Labs

