Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFE4FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 14:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAC26B00AD; Sun, 22 Mar 2026 10:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45BD86B00B0; Sun, 22 Mar 2026 10:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A2F6B00B1; Sun, 22 Mar 2026 10:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3616B00AD
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:49:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEA91C2A75
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:49:56 +0000 (UTC)
X-FDA: 84573983592.16.00D9B45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id B18EAC000C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:49:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DV8kUO3h;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774190994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlTFfUPhBocGaxMerdSh1BiMW+L3wVNprEAxKNc1b7Y=;
	b=a8DpPYDJ1smtIvNjFFXJlGDJT3aR/7ZQidkzZsLnjOHOg2FwA605F1QMXuMJL7VD06N9ki
	SS02RNUKr+2rDTC7REKBcDLKlGALgwoCuxrP2Z8FOPtNxC61GLYfcmxOQV2IiGe9WHXH8Z
	6SaNfr57XpPZV/nDVVuGoZKayWDrH/A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DV8kUO3h;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774190994; a=rsa-sha256;
	cv=none;
	b=2R97gQ2HmczkZnxObXFexQXw/9Eb8YsUkKPSlKQDoK2GHiNxcXqVWVKU5IEmtQkaF/+1YS
	ZRAMEZzSYcOngdzAIcfBOVcYEsZJ5SASUsuMinCmIqvhBPyxnIWII+mIC1hAYBbmtU9i4J
	p0mibc3Qhm16qOGUtETjeTyVAlRtYl8=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-59de8155501so3326764e87.3
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774190993; x=1774795793; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rlTFfUPhBocGaxMerdSh1BiMW+L3wVNprEAxKNc1b7Y=;
        b=DV8kUO3hUntsiE72wt3NQnNavsxuLIRxavyZZgSNLF+iNan7ij1HiAxwl6xVn1j4mE
         HgNwLu6+DPmmqq5gdd+MTbWuSOlafPqxm66YH30gWymLMP/6IX0ajc2L77nm6geAk6cU
         EaqmFsSaR36xE2BQquWMF/jo98fbkUbxWLQ23lGF/VNeCGsnud3ZcDqPmL0F7rI28Kch
         K+S2JAFY4nYglOVzOZjWqu/boPt7AHl6rrrGZbl8Ow+mx9VFodyWBoZTnoUX63j8uPJ9
         hTlHkhG0TRIY5FvyEWOLMt7S1EECTWKKg22YVbnOp0ncjWaLTqz85amFrIxrM4kAHqew
         WtIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774190993; x=1774795793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlTFfUPhBocGaxMerdSh1BiMW+L3wVNprEAxKNc1b7Y=;
        b=h2ZqxJ9cBJze5rOIgDE0YlGdlbTabFuGjh8yVcsOEjPovbbtVVae1vYSn2nuvTsu25
         sKSlmol/qXaDn5MWDWTOtwYAhmuBCcRSmh+A9gT4aLssD9XJ+d7m6M8LarMQfyx13/w/
         gWEO5UhtgQtYqrPK7Qaw2G9WYN7p3ar1EYmc6tN4SoZCus2M3jPkq5OEvRwqjOcOQzhh
         qjYOlxpheEGH9TRIblQc64ptefUgE0rrEDTO2ak2MC9FRAz3YuXfjfsOhxDxBZW/Zfju
         sOZPdBW0D787Nn2jz1njRPLRU9tJlHH0kN/5nyyzRUy2dCUwWddiVI1gy+fE86Xxfomd
         94vg==
X-Forwarded-Encrypted: i=1; AJvYcCUFdkW0bb4iy4O9vSDo8/QkTCqbFwE6kXR6wuY889PcrVrlBeKnDRdVGfVuJGOA3OvJ9HeCD2g3fg==@kvack.org
X-Gm-Message-State: AOJu0YwhTBPFkPxs7ri7GGShL5Vlhoe6qAcanYoWM2M9+13NGkfqjVsn
	m5b17KOVUsxhzCPb3QplVFrVC7g/Aw762YE9iQ+aKKVkVV62Uvdb5yPL
X-Gm-Gg: ATEYQzyNU+pfF9Towj5BFG14w8z1kVSvKcgvoMi5QmfAByLkwstRtCJiwYYC8LX4+R8
	VR7aRbJQB3CtKrF6ML+t4QhvuMd2j6uRgsiX2pM+0+FvoiByo06k0KPiMdZ4yHwh0HFn/VQbUoW
	2K+2d/wDvYI5QrfjrEGhOYZTWFXp9qRuqHjaxioqMcAIo1ad0lUr4z0pCIwZKhfpsng3SZ4f7BL
	01lZ5tkP5TcQRl/dqAOcmknDHl3/wFwJFQPger+IR2r0gY9aZ7CGJtnx/SPicuR9L4e158GilmW
	PEDN1MYcsQ5jaXzS3ZV8fUl31pUDzez2ph5ROKVmt+jy2MTYZM4GaPtVdQrZO5HeL/Jc5qnt88I
	ysQ2AX68A2Ws/ImIFGC/POsCTC2cVtyOa8DZGWORdlummlzPYljOg/gRwuw3oVrY=
X-Received: by 2002:a05:6512:3c82:b0:5a2:7c1c:749 with SMTP id 2adb3069b0e04-5a285b641eemr2701104e87.39.1774190992739;
        Sun, 22 Mar 2026 07:49:52 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2852071edsm1784683e87.49.2026.03.22.07.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 07:49:52 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sun, 22 Mar 2026 15:49:50 +0100
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v6 4/6] mm/vmalloc: protect /proc/vmallocinfo readers
 with READ_ONCE()
Message-ID: <acABjmeJT0eS9Hdu@pc636>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
 <20260321-vmalloc-shrink-v6-4-062ca7b7ceb2@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321-vmalloc-shrink-v6-4-062ca7b7ceb2@zohomail.in>
X-Rspamd-Queue-Id: B18EAC000C
X-Stat-Signature: eqby7bentyti7fjc5bhexibrqmfw5ajq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774190994-680671
X-HE-Meta: U2FsdGVkX1+PXaQ61snE2O6TLRBplCl0jCxixP75q1TaCmgWArTJ7/2bgqetBLqgFwDMq6VK9ExnEgyUw24T50dX6EuH4up0LhrMtNNjcvIhe/ZGnT3Utgrz0u8T2M99mX8Uyl6EfW06cC2XOP0xH1CRTXROy1p1FpArhym8PSvYf/o2+xt2bYJWDAc4m+uQNg+SSZB3cXGVUbA3/YxqlY9MtN6PH+wjBNqYGb3YtfA3RRD9298SteesOyd/gq69J8rOctwobutXpC5QPIt5dzWyWvcHnqyvpku0ONnzvyxVBDkNvGX4oSmLZJBV6HgLOcGtpJ/kzqGqFbBtD5c0d/CN5k0Zogkw79DsmTaNjpAcIVHjMIMJNCw0M4/xhZrGzdMWTm4B1k+8OZMXPPwlRd2ohXHpFl9ajOJazXL8TAAaBQGdei2+XdehcPh0SkPdX1ii75/ffSqsOq17EuXSv/i8tJC6OXMHzq8ZA7IU0n9q8CEfRqiHg5ieMl/RxdZMbx7uXIcqyoWMHI4oukFcwkKRrRHLbpmsGHx0aOLj11ZZZpJilEukjZW2NYu4xC6GrX4vT94B4VdAT4qBzOgRCEuIl2VFRT1ZcLewsGdcITqTM5p2YXNeYeu8oWALS8MrNhaX9njA7Ugxb8RntJheUcpMG8PeYuSpSSllTIL/4jytOkI3kViG/bZuvJAgYDFLiUthWqBrd98BYp374jDmV2tMwM6uD/k9G7w51pDD2Ao2hf+MoFElltlfWJ2dclVka3pGv/2LxeWTva3baruAQZ9gbbxSCY6ibaZTDZKjc/acvq2VdsXKPcibAzD7z0/G/CmgxPu8KvwLYj0lj2rFlKp3zP78ev4QWFfmejea0KZHozJku1BwvwCV156vpuN9XZuscDJ9UlLvp3JrHaKyRe1L2ubG4TrJ6elzQVibt9Tu5GWWLLAMB4EDXXW1d6EDHf8qwayUWz5V4FrwYuz
 D56DNDNe
 /RSHceD2bQz5Vh+c8RDDfQNhudy43ul2ORwhmmMs86YrjNDb66bNydfCWYNjRFttnhlqjdvRYeyrQhiIvyyZjM2bdVBQ8SP+K6z9uwiH54sBQCq1OuLxztV5J4xfWkKOdYL9PhoBfRC6xpeEolgPWWbe7wNubNp+bOQksabRdal2QKJ0M2JzWeB5KZ1rSai8YRifJL5NNEENYuYwYWpwAweMFqQ+Aiu4T+OvDSB1wtiREKxkLkaT1DLYL2uZ8S4djnLtkkJgNVhHCbZ/GhKSGLH4YRzkdv0q45FSsVdEVX9U3K2DNWKtTQrg2rK/lYVTZ/9EYhwTfFymK9EIjzoCasTQKOSMuDKIbLEdFjmNPz8GN+niiFwgwa6lXphXvDAstu+kpuTbB/f/Xs2FaoJBeDtHT35dZ+448oYL7YDiI9ant6Kh2eePMQLfiEW7FW1Uea18XwHiwQf3dc2bw1VSfC4nzkjNILTblFtqHnJQ2nlaffLwxIVTO0wouhEedQdia5rlPPDuHZ3UiNWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 11:35:49PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> The /proc/vmallocinfo readers, specifically show_numa_info() and
> vmalloc_info_show(), currently read v->nr_pages and the v->pages
> array without any concurrent protection.
> 
> In preparation for vrealloc() shrink support, where v->nr_pages can
> be decreased and entries in the v->pages array can be nulled out
> concurrently, these readers must be protected to prevent use-after-free
> or NULL pointer dereferences.
> 
> Update show_numa_info() to use READ_ONCE(v->nr_pages) and
> READ_ONCE(v->pages[nr]), explicitly checking for NULL before
> dereferencing the page. Similarly, update vmalloc_info_show() to
> read nr_pages safely to avoid parsing a torn or inconsistent value.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 64f5d1088281..7658fdc087d2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5204,7 +5204,7 @@ bool vmalloc_dump_obj(void *object)
>  static void show_numa_info(struct seq_file *m, struct vm_struct *v,
>  				 unsigned int *counters)
>  {
> -	unsigned int nr;
> +	unsigned int nr, nr_pages;
>  	unsigned int step = 1U << vm_area_page_order(v);
>  
>  	if (!counters)
> @@ -5212,8 +5212,13 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
>  
>  	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
>  
> -	for (nr = 0; nr < v->nr_pages; nr += step)
> -		counters[page_to_nid(v->pages[nr])] += step;
> +	nr_pages = READ_ONCE(v->nr_pages);
> +	for (nr = 0; nr < nr_pages; nr += step) {
> +		struct page *page = READ_ONCE(v->pages[nr]);
> +
> +		if (page)
> +			counters[page_to_nid(page)] += step;
> +	}
>  	for_each_node_state(nr, N_HIGH_MEMORY)
>  		if (counters[nr])
>  			seq_printf(m, " N%u=%u", nr, counters[nr]);
> @@ -5241,6 +5246,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>  	struct vmap_area *va;
>  	struct vm_struct *v;
>  	unsigned int *counters;
> +	unsigned int nr_pages;
>  
>  	if (IS_ENABLED(CONFIG_NUMA))
>  		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
> @@ -5270,8 +5276,9 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>  			if (v->caller)
>  				seq_printf(m, " %pS", v->caller);
>  
> -			if (v->nr_pages)
> -				seq_printf(m, " pages=%d", v->nr_pages);
> +			nr_pages = READ_ONCE(v->nr_pages);
> +			if (nr_pages)
> +				seq_printf(m, " pages=%d", nr_pages);
>  
>  			if (v->phys_addr)
>  				seq_printf(m, " phys=%pa", &v->phys_addr);
> 
It is protected by the vn->busy.lock. When you update the page counter
in the vrealloc, we should do it under the lock if i do not miss anything.

--
Uladzislau Rezki

