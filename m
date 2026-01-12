Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184BFE67484
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A14B6B0089; Mon, 12 Jan 2026 05:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BC76B008C; Mon, 12 Jan 2026 05:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57EB26B0089; Mon, 12 Jan 2026 05:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 464C96B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:21:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B97F15B8FA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:21:22 +0000 (UTC)
X-FDA: 84322919604.23.CA2FC53
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id BAFA120004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:21:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ga984PiL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768213280; a=rsa-sha256;
	cv=none;
	b=673nGJMYWnIYaMxflHu17bZLIgF4xGicflCqwIz+NsNQw8onh5vNjUlVkbzFgVeQKVq4RS
	IPdPH0Y2TQjklx5pywi2crhA9aOAHrze4IDFOvI9iIXpyQEiNdVnEXtntxEoG7LGbF4i/8
	nOCjFX6Gd14Snb/rJV9N1PHKpEKxBYU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ga984PiL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768213280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MH16cCGkiKRTIwcYIk3CP93gcE4h3kBjVckxfOORWKY=;
	b=D6rlmhpmhJDxgH2FkXsPxds6wGbtMNTIyHlIGitG8k2PSvi1kgfQU7o7bqQcbktVysKpCJ
	BPNs1koxOWlY6tESVLArtOz8n47JpU2FmNgz26rBHbgdvP8J5M3dKu0GF7tdj6cw+vCfYX
	T6drlcEjHSLMvYAtrBVLFBG9rkM9xTA=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59b79f700a1so3410580e87.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768213279; x=1768818079; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MH16cCGkiKRTIwcYIk3CP93gcE4h3kBjVckxfOORWKY=;
        b=ga984PiLS9pYZmDRIW13oAXf4BpImVd2l5yr37Af5uxrmyNAwW+SOen1ivZJLgR0nv
         0IdmWaIqhrOxpFOEjKcdbP0KOTDpwHsGs25XQfaJaf1xtP13TsIQnkovawizSuP/YH4R
         02ydE9T3zOr0Irg5t2s72KsTRN+bAn8Pn3SycGC2F1UH77qcwn4acmeT+d8jUu2jSv0x
         yNDd0P9mhCqZHToIhhmgljPsYh8RrgM+wR5g++uM/Wgc2XbeQSn/iFcor/hkXzJsKw2t
         vDM1q7qQgVAnVizY/b6EE4eTUHbZZnFWLarVSTnhC2PDOkXqnuB4INZVXEpiQxh7SrZf
         59Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768213279; x=1768818079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MH16cCGkiKRTIwcYIk3CP93gcE4h3kBjVckxfOORWKY=;
        b=XFRn6FMbnqYILWy7dB5fV/UZL/+BzrKCQiwauxRHPf9WcJcm0GaahAvZNx4XRylecn
         eoaiI3Ax4ypbPNBnJjaXX+6aODRDUdQ19ZPNH9RjLN2LV+8PudFG88HrBpx9keklpn+G
         pHsgNkc72t5obbvwkxjU84tey64E0KKKsg64t8NK/Ps8KWWF0IZsu2KWPJH2qy1dCr98
         g1GO6ssl8kBSPRzEn2acAtBgqOzJ11nkXYfcgHWs3PHad9YTIovpbsvkm9GRDn1unpZO
         gGxB0Kf2EyZHDOmYx7tVjpNjCfjKMeG/bUNeXXCU1UC8+mBLNYfjvNRkJmu9f1XCEYxn
         BiMw==
X-Forwarded-Encrypted: i=1; AJvYcCVJRB+AQBcpoJrNQWXEeSgD3/Zyh7dgTtcIW+zelbHs8p20RRBTZqRpnD+zyCB3xmFB+8Il4RUcxg==@kvack.org
X-Gm-Message-State: AOJu0YxKTQrNCdOSET7bbDRl4eYY1KjmKL7Y0GHgcl1vttRWPuD3tHpL
	N4X3p40sURao7bhcZCiAX7/cp3Cz2eu0+tKtVdEqu0uch4jVScA3LYfo
X-Gm-Gg: AY/fxX7SuVEuyP/KcwKZjGoQt4007lpuOKYGKHhTeETn432BGlsLhsB+Ky5yNdNQmfJ
	Sbbx84SURwHSOLQa9abywC1/czpOGMg696jbl6UbN+DJ/P4s1JRU8b48Nrmi521pS1JR1a0ek5N
	4wClQMFKbudYUSmcUtfhaOZdre8jGVw6zEzZZA2DuGOBDc1fBJivFrkP9Dbqw0BIOkaEKWdes/d
	8wcckMwMV/L83/J4zFicEyncls7dnAE4vbPkB2/V0KQ7dgWh3xNu+t6ig5Ffsk46cClxhuTItun
	ifSGvcTiRj+VnrIUjWN9zJlnrrDkF7Zx144ImDVsQ5Snw/vGGENtdWnZtpp0Nobx9lBp1xKDnG1
	NJaauep7ryhJXDpbmxAYkHY3iRlhOItRmwL3h3mXiICQW8ic+XQEdyCo//hxp9YulNFrFaRB906
	kDAnsepWgUoHinH7ps8qw9p9Rt9VYD+I7K48Wo7n3Lf236xFhR
X-Google-Smtp-Source: AGHT+IE0UtcUUd+0NPLty+/GtN4PIwioNMqlewY8nUJ0HWNNcErN36LVPtVC79QsrDnD3tS85Ukohw==
X-Received: by 2002:a05:6512:118b:b0:594:2d64:bce9 with SMTP id 2adb3069b0e04-59b6eb0c486mr6660079e87.4.1768213278614;
        Mon, 12 Jan 2026 02:21:18 -0800 (PST)
Received: from pc636 (host-95-203-18-139.mobileonline.telia.com. [95.203.18.139])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b6e821f52sm4042503e87.29.2026.01.12.02.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 02:21:17 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 12 Jan 2026 11:21:15 +0100
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: prevent RCU stalls in
 kasan_release_vmalloc_node
Message-ID: <aWTLGxeFm5BkSb4b@pc636>
References: <20260112084723.622910-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112084723.622910-1-kartikey406@gmail.com>
X-Rspamd-Queue-Id: BAFA120004
X-Rspamd-Server: rspam06
X-Stat-Signature: ndsrfy1nbsi3cba5twj3iys76mw7mk6u
X-Rspam-User: 
X-HE-Tag: 1768213280-120046
X-HE-Meta: U2FsdGVkX19+a2IRuYO/ejD6yKgTeLC0sWzGwx79Q/oHJXqRFM2D/bCs1JBJGMtbExU/NXiRhVneEBz4VMOE0PfVMX69vTxno50k46BwJHZYyi8Jtl1e7aZwMnpSZelV8l/tzpH+mTxtDjkp3a12S2iSAv9J7jpSHmFd6Uxz4fqRKUDTIIcXRJowv0aUZePkk1/urcocfzjrhJKQaa8JXqhqYv3CeyiWaWQh+FR1T30Uvjm44ZLA/bl+iE0swQzwmxxMyVoyg+7cubUep0vZ0qTVIMXuY/O/FuU7g1hwlyaXDNPG55woU96bY1vlLtVA+1951RnZbB9NQUuwLb9SDkWpyrDi35o4fVQ6nr+yFcmm6iW3OZaYGVSYlzfTdnmbHEEdVOGegF60qTbcG26fBNEfJImXuOcILWy8o+l5ttis9rSYSGpKiTxxh6cXin91IhC8iuT4MbrziiU8/uB5uYtRE+sOKxldYLZ1TpbZlpps2Dp5CgnLZ2+l71pJ+zXfLiVoekWel4FOF74QV1A1c1mqTZU7XIWxhc6iqjjbl63WlYUOLQLxCq4y1S1o3NRXHekXbkFvH/WSSImEfKLxNBhDEsLUfKh/22ChYHCE2edtdyCH161xeobnuewq+N9HgoCt/kdaK/WgGVCG7cJ55mS5doJ19jsxRI5Dj6JByLK0q6p3XWFCxI7F0fLUVI7O/JTR+qIO3x3JKtY56XCOTSZRbuPbik6Dhc58axoVARl2sphOwN6C+xc0ndz57JiOfBiMcgNyBmvuRDgxWE8UC4KiJgFJFy83PCNL7HmHAtKJYd5q3YbeM7s86s+M0fu43pn7Bs10ALoQR1JrfpTk0F5DI5GDqer+fU6gI3+nymsGxTUBmU/VFikIsL4tA44kGqAh3794VMmh6J3EhoWF23KmBFkhsvE/FhenuyiEPXxMzexu3108xgFt3wLouZ4vPLOy3bQIdQ1OhwnTgdV
 9YN57Gi2
 KRHi8ZaUkqi9/sFlPC6Bw6swv+0bSnKg4o/RqtPrKLAegyqZI4DS2MM4hIkBoSawlGJMwV0+kIbJrEnl56KYd06oxF8CdNSKbW0jMU/9bbK9OIVv3x3tFMNEksM8azLys6Mg7KUgPeaeEQ48kOcfCf0d02IWFH3Ayc3IrlNR2KXPFW+Otf4wDqZyzOdjK48dXOWOidSrN7Derwoa2lU7i7gp/3KvE+ssalxa3c6nMGeVKB0xXsXq7/tbCt07s5Em9vUOi2FEEt5zWsg2rat1u0y5EK4sZ7SdqE2FYA8hRdaEGVWf09LxbaV3rK8ApSmGkVImREggwqVT3HAEKOdtpIZ4ZYcAPG+DAM8200osZMMfAUp7ghhpBQB3U8cdRtOlsdPSBvuNQ4JtiBwrGQz5p86jKTQktHNR+k65ZpAmQ+HtDZOzCBvE6ucdC9I30z4k0SP4BmoUcVeMKLjzeVrmBmrIxxvfTU8G7WGsKBfcMxGdV0RYZAyQG/MIQiurKImrhGjTJ/KBxyQ/7QX82hARcjWbKieka65yLCKmNIpuOGzXovqZn2f8WaCRKnEnKAD1BYQuZSaqb/YnQAvtbcv14FutBr+gaD1WFCiBOpb0gybUJlSp9kj0H+u3yjrv8biw69yY1xJj6nbef1IB5NW9qE554ZMJWCrKtgNbHrhiKYZlFZWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 02:17:23PM +0530, Deepanshu Kartikey wrote:
> When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
> vmalloc cleanup triggers expensive stack unwinding that acquires RCU
> read locks. Processing a large purge_list without rescheduling can
> cause the task to hold CPU for extended periods (10+ seconds), leading
> to RCU stalls and potential OOM conditions.
> 
> The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
> where iterating through hundreds or thousands of vmap_area entries and
> freeing their associated shadow pages causes:
> 
>   rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>   rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
>   ...
>   task:kworker/0:17 state:R running task stack:28840 pid:6229
>   ...
>   kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
>   purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299
> 
> Each call to kasan_release_vmalloc() can free many pages, and with
> page_owner tracking, each free triggers save_stack() which performs
> stack unwinding under RCU read lock. Without yielding, this creates
> an unbounded RCU critical section.
> 
> Add periodic cond_resched() calls within the loop to allow:
> - RCU grace periods to complete
> - Other tasks to run
> - Scheduler to preempt when needed
> 
> The fix uses need_resched() for immediate response under load, with
> a batch count of 32 as a guaranteed upper bound to prevent worst-case
> stalls even under light load.
> 
> Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  mm/vmalloc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c..a9161007cf02 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2273,6 +2273,7 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
>  {
>  	struct vmap_area *va;
>  	unsigned long start, end;
> +	unsigned int batch_count = 0;
>  
>  	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
>  	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
> @@ -2282,6 +2283,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
>  			kasan_release_vmalloc(va->va_start, va->va_end,
>  				va->va_start, va->va_end,
>  				KASAN_VMALLOC_PAGE_RANGE);
> +
> +			if (need_resched() || (++batch_count >= 32)) {
> +				cond_resched();
> +				batch_count = 0;
> +			}
>  	}
>  
>  	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
> -- 
> 2.43.0
> 
Introduce a macro to represent an upper-bound? 

Thanks!

--
Uladzislau Rezki

