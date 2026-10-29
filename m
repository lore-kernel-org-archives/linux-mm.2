Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD51606A336
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Beg7O1Bc
Received: by kanga.kvack.org (Postfix)
	id 45CFC6B05B2; Thu, 29 Oct 2026 05:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435466B05B3; Thu, 29 Oct 2026 05:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34C006B05B4; Thu, 29 Oct 2026 05:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF206B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:44:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9531240368
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:44:43 +0000 (UTC)
X-FDA: 85375179246.30.7E0402F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 74B42160006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:44:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Beg7O1Bc;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793267081;
	b=PUCC3cJKYWUK/xHCvXbaIB2QEfSRtvlYL5h9JxpiXaZZwnZc5DmIOXbOjlCSBB0KQk8Y5d
	U69tOMz1Gi7pazvPmE9ftpm3kK3JpkmZBMIShhTiSo5Etw//bYarGrsYOVUh45ngZquw9f
	fNRk7lLwBuGX4QAtCWbMb4wHQbmvqcs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Beg7O1Bc;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793267081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XB5wy8uf7FyauSpZxvm0L4wuvw+kVmeWTT3Ttyk8h0A=;
	b=wEgZ4/cT/JtQyplM8qrO3O1SpSwotIKC3ns48lkwRlgEcBL7rjp5KxUaVDIYB1ixxlbTtV
	XlHG7N6p6PqNRaSyHJ2gH2wDkmy2dvN6Sf/iMN4alJP2TSV0sCPQEHrAtZAk8F8usY53Hf
	+JxhVKq53lK2rfxYpyjIIICG649gNMw=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so17942385e9.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793267080; x=1793871880; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XB5wy8uf7FyauSpZxvm0L4wuvw+kVmeWTT3Ttyk8h0A=;
        b=Beg7O1BcV389opQylePDsjW42QJZumQFvEdCvSQ5j6f7VXxUTCHLUiAGLTlppd2RyP
         0eXNMqXbczVzcVu3TpzrieCeZ5NuEIRvPYVz69XHSykXB4l/GvyZVGDNBwOkMsbFnR+1
         K4pto+QgmHxDKHxZWjyMZgZZBHdlZ9hyK3aX0/Sw8/kyikGN5q+xp5NGLp9mzav5FXlm
         GJSbR5TuoDF0s65luFy/J349eCd/Tdx7U+IkfvAp9VexZpPJU7qlpByyweWt7aUcnfxZ
         S/f95fbhc/71mCEckOtbpPqefq5z0dga6hQlL6MsSvOzK/GzUgR0As0PH0tEN3K9ouMi
         6A+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793267080; x=1793871880;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XB5wy8uf7FyauSpZxvm0L4wuvw+kVmeWTT3Ttyk8h0A=;
        b=reo+8GXNRb1zWK/oRQ41mKCpexwoNRvWT6ciMArgSUuEjjnxhKKD97EGs0gtH8hUub
         0Fzq7UnmUqwlW+w5UG82FPiE/rDpr+tHzClgJcdJmnN1DybLXFbn6GRbqLsDVC/SoaEO
         CheIRxakXMAOuDkqt92hrBzQgl7yJbLCFidB38Nq1eRr40PlHQeMgMmEizNE1aauiSBb
         A455oQc9HVv9k8CnyPlnAckkBoJ/c3Ok/hj5gvXsL8sNN2yY0432hg2MDbYKxoElP3Y7
         F7wo/LF5WtmWXZ7BN2Ksp1H9b/O1/zBhZJjSvadZ7xbXJYSZCNjyPjsaq8sof4KOn/9i
         DqDw==
X-Forwarded-Encrypted: i=1; AKwUvBwrUDtCM4hlBdZ+EKe9ZjjzynqGAQW04PVlLQ3uTfqfNo5GZy4qU9oCGx2LWw0lrAabhcIM9057Zg==@kvack.org
X-Gm-Message-State: AFq9FYK+LQH0sV2TwA3qwSosdlD8G8XI9y573K/Ft9T9aGaRwFBpszzK
	rYDuiXV6VObgJJn5TtAiIo3ar2ey5EVlOfFdnxpCFhv0aZ418W/p42tT5Q1mVD3Vh/0=
X-Gm-Gg: AYBFou1orqsWhNIxyaAZEQ+gvXhGNHOn2sZvOHAyqrXpn0NnB/46ra9yxNaNV6iuVSS
	BMMHHOhZpdWsja1mBBH7tJ4ivlUqs/40aovgAkh8OaW5YtdFLz+ntUGgFLzbzmCi4FEVmAffgOt
	uQX7PvDSz/oLgkoN0gf6WAXT6sTt17hxMGFrcv9QmE/9cR2bqGKTcispRCi59KGy4N6ANytfpIi
	ZC19tIaaZgleP03wurUc05EQyTKVXGvxDWSj1lNBg6t9u/H1LO4HQB6E54uUBBnx7ZPxPqnGWmX
	sNDJHJAhNOx768hmF1D1AsaOoIKVRTmFJP8TOKmVJNYChd/j+NsApybqU4SzfqrIcou5JHlQC3Z
	IsWEoz6GTFjVxZ0ypIzoJ+U5awPwmQ/RxHpoqg+sYlGPQ85KYpc0ZEaczCsFhXvEBia/z+3CReh
	teGAwLdB35hQPt9QpWglOciUz8wga9ZYW1RhPVxmOhQ8TofTVgtFfgeS+PDjDpZZ+2Cy0YA7Zqb
	KRIqUMudQOw6ZmMiGetIGS8Yh4rX/NXq1vs93yUsI820AIy+mdHjkxmwfNijcfo9jpGKiMKc/Vs
	WJkbQdOyR81fDJAtosvLYXJ+uvCIAA/SAkTeqH+AcW9p7Oi9tfc2pyc4NgMSAwej
X-Received: by 2002:a05:600c:4f89:b0:4a1:d8fc:8165 with SMTP id 5b1f17b1804b1-4a966f209d9mr110155365e9.20.1793267079846;
        Thu, 29 Oct 2026 02:44:39 -0700 (PDT)
Received: from localhost (109-81-92-234.rct.o2.cz. [109.81.92.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80286fc6sm60488145e9.15.2026.10.29.02.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 02:44:39 -0700 (PDT)
Date: Thu, 29 Oct 2026 10:44:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/vmstat: annotate data race in
 zone_page_state_snapshot()
Message-ID: <auMVhhCC5Ap5pdh5@tiehlicka>
References: <20261028100549.70689-1-hui.zhu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028100549.70689-1-hui.zhu@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 74B42160006
X-Stat-Signature: e7ioj51ok1fx4rz7p4xuadnff7eyyzwm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793267081-427935
X-HE-Meta: U2FsdGVkX18tpWNnvch9Wgxa1eiCWH8+9NOvFvUQa5fMIfOJLc7l1b4j7Mdy8ZLJyRsD5EMeWBXjMlAvfNe7RC2bNB4O/pdvvTJj+me+vvBYl66VmYXTLYfElz3UX32JMXkGN2sgXsRfUnmMQUT2992EU/aGhgSMULOLjdlZXkOpNmqLn4OFNJy02K0M51sOPre72KqsJ4+Z1uexpTWUuEseyYeWT8XcTcerWGBc2rR5REGmO1UIRw4zjAceTpF1vCSe6w+Wc9EQjNnX/8n5oLnZOwgdf5nPEwdU9Fb9Sf4iOz7i+MixeHOidPC8+YlvGP8ijbTdFq7wrygaR8Fb4IY8nwK5mG6mjVv2zwCcC+zCrtLOTdv+yXwYS2/rNx+rnwjk8zg991wY9zNmcEd1zGzvoUu7b8gDZPIFb02hY1I7a8941CgTLZ/OLcTI26BJTkimNi3oVHqPJOHZTRcRz/vyjh5X6RKaUAmp981TeVJTj9E6jwP9nw0IxxJGXKo4fwUje4TAb2re+yu2DAN2GCh0sXCvvhm+QtBDplMMcuyDoThnGL0MX1m9pLS/2lnAO+mNwUyGIyIsVTOCTEiTr+evmmP1EejaKyVcyM1ewM5jlT3TuNHUE0+Quw9vEKe/LhnZGbIsAbaqRXeg1CPgQpBq82mwg2+0EgKzNverTHFUM8k7DZv+PZ1CnAw7knVByNmy1wcgHBW/ZyiZT481Z7oiqz6aaWGsPfUq1+Z56MSdkXP9Yo734LQRyrHOY+s+UQKeI1G9sv3EJ06A0f7HrgXz2d7u2UAVuRvulecSp7kRc8DB8Omv0A+vEJabFlxygCOklEF4i68kjl2hO9zbNwWnURms3IzlW4FOkjkaQVij3RDOKQ7ZE3g+CFhTcqs85u/y20rA3eR4fQmIQTofB774uU3US6zSERSC5Jb2EweE+l6rc3GwYn6YtAnK66EFtaccGEyEExiHI7E6FgV
 xNHzuyAY
 UDJK9Z/kmNj4Ae5BjUmsIEnfEekmx/O7kfiIcNSfkzBdJFk4S7qHZ9nvxc+7FlcS/9arlYL+P9fw2OVaLmCdEnJVUm4lVmv9n9wEgYrpnTk7CcMczzItCyspn4rMGxIQdX/IjMRGuzVaxiaYp6uzI7JYbfKbb4VNQ8Ca5oVboM1302SzHt11rxtgcumGoXjJIJOVSB0q0Gd8EP/+bLhXZRkoFz5ZJu15qxxHGj6QBGKpZRHBekr4dAzz60PmH5vWNH8jn8A3PMIiDKDjbW8kg47KCqEK/q2XDTr8cU3Y096eaZc8isYmcWygjIabp7x1tau1xN0NcbGg+jvh4Qo446eB7DwDnf6dGQfgtKKW1U8d0c40xbOAMTt48DgBtY7/Gc2Ukr+5wj5wV40LHJiT9nV3QXw0t+RA3f7c+P9nLC62eidG67vznIeEAsDZVgpDAhjvEwJFPP5ONJhX64Cd4VJ+2FNvdGbCS84Jrm1zYia8SObCqjMsnZ1K3af6qS4svzYNw7oy6QEfGMx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 28-10-26 18:05:49, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data-race on v6.6 which also exists on mainline:
> 
> BUG: KCSAN: data-race in zone_page_state_snapshot root/klinux/./include/linux/vmstat.h:232 [inline]
> BUG: KCSAN: data-race in allow_direct_reclaim+0x150/0x290 root/klinux/mm/vmscan.c:6328
> 
> race at unknown origin, with read to 0xffff9e0575410740 of 1 bytes by task 209280 on cpu 15:
> zone_page_state_snapshot root/klinux/./include/linux/vmstat.h:232 [inline]
> allow_direct_reclaim+0x150/0x290 root/klinux/mm/vmscan.c:6328
> throttle_direct_reclaim+0x1c4/0x480 root/klinux/mm/vmscan.c:6402
> try_to_free_pages+0x177/0x590 root/klinux/mm/vmscan.c:6466
> __perform_reclaim root/klinux/mm/page_alloc.c:3966 [inline]
> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3988 [inline]
> __alloc_pages_slowpath.constprop.0+0x3b3/0xdf0 root/klinux/mm/page_alloc.c:4395
> __alloc_pages_noprof+0x28a/0x2d0 root/klinux/mm/page_alloc.c:4794
> alloc_pages_mpol_noprof+0x181/0x470 root/klinux/mm/mempolicy.c:2270
> alloc_pages_noprof+0x7a/0xe0 root/klinux/mm/mempolicy.c:2347
> io_mem_alloc_compound root/klinux/io_uring/io_uring.c:2848 [inline]
> io_pages_map+0xb9/0x330 root/klinux/io_uring/io_uring.c:2892
> io_allocate_scq_urings+0x231/0x300 root/klinux/io_uring/io_uring.c:3933
> io_uring_create+0x29c/0x9c0 root/klinux/io_uring/io_uring.c:4091
> io_uring_setup+0xb6/0x100 root/klinux/io_uring/io_uring.c:4203
> __do_sys_io_uring_setup root/klinux/io_uring/io_uring.c:4230 [inline]
> __se_sys_io_uring_setup root/klinux/io_uring/io_uring.c:4224 [inline]
> __x64_sys_io_uring_setup+0x66/0xe0 root/klinux/io_uring/io_uring.c:4224
> x64_sys_call+0x1816/0x1d90 root/klinux/./arch/x86/include/generated/asm/syscalls_64.h:426
> do_syscall_x64 root/klinux/arch/x86/entry/common.c:51 [inline]
> do_syscall_64+0x70/0x2a0 root/klinux/arch/x86/entry/common.c:81
> entry_SYSCALL_64_after_hwframe+0x76/0xe0
> 
> value changed: 0xdd -> 0xb6
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 15 PID: 209280 Comm: syz-executor.13 Tainted: G S ------- ---- 6.6.89+ #1250
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> 
> Found by KCSAN testing on an older kernel; the same race still exists on
> mainline.
> 
> zone_page_state_snapshot() sums the per-cpu vm_stat_diff[] deltas of all
> online CPUs with a plain load, while the allocation and free fast paths
> update the local delta through this_cpu_cmpxchg() and friends.  Those are
> inline asm, and page_alloc.o is excluded from KCSAN, so the writer is not
> instrumented and the report is of unknown origin.
> 
> The race is benign: the function already documents that the result cannot be
> exactly accurate, and every consumer is a reclaim or compaction heuristic
> that tolerates an estimate.  Annotate the read with data_race(), following
> commit af1c31acc853 ("mm/vmstat: annotate data race for
> zone->free_area[order].nr_free").
> 
> No functional change intended.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/vmstat.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 5b31d8e7ae405..9df3587a29685 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -236,9 +236,15 @@ static inline unsigned long zone_page_state_snapshot(struct zone *zone,
>  	long x = atomic_long_read(&zone->vm_stat[item]);
>  
>  #ifdef CONFIG_SMP
> +	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
>  	int cpu;
> +
>  	for_each_online_cpu(cpu)
> -		x += per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_stat_diff[item];
> +		/*
> +		 * Access to vm_stat_diff is lockless as the result is only
> +		 * an estimate. Use data_race to avoid KCSAN warning.
> +		 */
> +		x += data_race(per_cpu_ptr(pzstats, cpu)->vm_stat_diff[item]);
>  
>  	if (x < 0)
>  		x = 0;
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

