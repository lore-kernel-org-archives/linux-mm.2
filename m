Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1590CF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC8B6B00C2; Mon, 13 Apr 2026 15:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4C26B00C4; Mon, 13 Apr 2026 15:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9FD6B00C6; Mon, 13 Apr 2026 15:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2D46B00C2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:41:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B2E51B6E83
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:41:44 +0000 (UTC)
X-FDA: 84654552528.16.6AC066F
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4957240010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:41:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iV7Oh0IX;
	spf=pass (imf07.hostedemail.com: domain of dennisszhou@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=dennisszhou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776109302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+e5A6rrRb07CI/0TyJFt1WuefeVIntv7J60tzg/4E4=;
	b=OxUKfIYU7Sb1I5hs+Px7u7mTPZGfOTgFBtMZiDpq0pT+OZD+PXvTdXjvbjprHg2aFfEGrx
	khUb9+T4igz2RGty1XUUqF7AYJLr+K2SrxAToFReH2blqNaRjCvWMum7UTmvPErw9VlkkE
	Ox12lBB9EtjAXpW3/eJ7dkiRxW6+WbU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iV7Oh0IX;
	spf=pass (imf07.hostedemail.com: domain of dennisszhou@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=dennisszhou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776109302; a=rsa-sha256;
	cv=none;
	b=oSitRhKn551LCfvP6Dj4VVcb2jLr4qXqcoRyoF0qpVERe1I2Vtz+3VTZqqxxLPUD0/x6mv
	bkE9kGkrS6r2ZeUPoDQX2SHrIa8IsEZ7bryWuVtgf0ncnL7bd4XD5awaCEuqa7RlNUx3k0
	OydkLGAUoSR0L99fErXpVaZVBm6toe0=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c287eb77fso5686962c88.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776109301; x=1776714101; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b+e5A6rrRb07CI/0TyJFt1WuefeVIntv7J60tzg/4E4=;
        b=iV7Oh0IXFRsdFA+rstBpCmSwByhHBXw25ZNJKjE/Lsmkuh5T73zF1597TJbL4dlU0j
         D52nZHD1a2Sk3S0GcQcO7fJvYgYM+kM2QB/XLlVSiYAraoGrYAMr7rjVsXL/pGSwpcZY
         WO8ee1plWED4giPa3W/01ng554b+jO1L/kA5buP4h2PcgrCJPa92/TfC5Kum5iTHiGoL
         /bmN5XffwHyOlz4/ikUKmfGYm2ltHbYWU+89jrZaSrJXbO0qySMubgrhhsIp041nxpLd
         1yH+C19JtzhDdG7wqiToL9ky2w83izpp2LlOOurakaaA8ewEXoypUBUFpUCvMHRDShud
         2Cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109301; x=1776714101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+e5A6rrRb07CI/0TyJFt1WuefeVIntv7J60tzg/4E4=;
        b=KPwx/pqbtMVJcTlFeDRqtAXYG8g+DKBMuckzZ2p4VrQfwI5l7hDvf6AzBhqzvvzyv/
         Z10iVZqx7Yy3LmLq1W8mEJEsu4bjG8hEeRJ64Q4mkKVWlg4CUfEtn9J+FDLGNGWalGo4
         PMUPs2K8qy0+xNSV3pV/B17Gfha5Yng725e9t3hO56T+lQIxjmnP+l+rN95QDDa2MV2o
         1eQA86o4yLDW0CIWsAWR4/xMHmy23QrsetYtqauoTu6sCBtuWvpw8mA1jrC9obPikKhA
         XnZGeYeq6ejPzLMGfagRRJxTcrIt8lnMYzkKfqRdU1FU5jNkgWas6lZh8yJ92XOErixv
         3wVw==
X-Forwarded-Encrypted: i=1; AFNElJ88wUkXHF6RjSmyh0dY+kyhehHwWjxk1hHtQXF0HWbckrZ8XqAuPkqVy+/m6vQk29BbOq8hPtnRpA==@kvack.org
X-Gm-Message-State: AOJu0Ywn8I2W8D2jhwGcsTVO4P1ZSnKlDGEn7DBjgEfWgtwddIwdEgd0
	iY+vNuJSj/mFHDJEMDoj4GjbFmFEr6xzCMxkIA61ALXRhWAlAQSqfy3f
X-Gm-Gg: AeBDiestNY1uN08WQc/tSLs8/0sEAmRrK1RaNrc5Y668uUzLiayMm15UKKlfzW3OkLF
	NrxIUTYgEMXj2ix7ptHumTLzsWYefgQzrWOKZzcaW+D69+VaifXAi+nsX47g1OiFF57Yn6MTpH3
	4cdtVFqKwqaiuG4acK/e/iyLRfYOkiEruQagTIg+xo5Zyu/Q0dOxiNqnU8DENeTwohPMbW+oM6S
	1rxznoFiZymHALvBFZnGFjGkR2vpI2JFNNNiLCBhFwNIpFUDJHAlC3dnYQGA81Acad8PiaqzlLV
	w6T//6/6rcZQWDMoNk2ydcIohnd2eb6L/G3w5huq3RU13oOFmOGAOKX4pDPz55v6VS0VnC1zwQd
	uymhSJUC2Wnn6ph9PypcNYeC6cBFvVSvZM083MB/KqPG+BJvg5amk1zputYamQ1zlpS42B56qTO
	vMb/hztep8a8qXLJwPk47Ddf6EFRSzNbwxkoYCAbVprPB/y/ft
X-Received: by 2002:a05:7301:1f17:b0:2d2:ff9e:c07d with SMTP id 5a478bee46e88-2d5888a0fe0mr7287600eec.24.1776109300931;
        Mon, 13 Apr 2026 12:41:40 -0700 (PDT)
Received: from palisades.local ([136.25.84.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55faa586bsm21063373eec.11.2026.04.13.12.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:41:38 -0700 (PDT)
Date: Mon, 13 Apr 2026 12:41:36 -0700
From: Dennis Zhou <dennisszhou@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, shakeel.butt@linux.dev,
	inwardvessel@gmail.com, hannes@cmpxchg.org, josef@toxicpanda.com,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, martin.lau@linux.dev, usama.arif@linux.dev,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: blk-cgroup: fix use-after-free in
 cgwb_release_workfn()
Message-ID: <ad1G8IuNgI2Xy_wU@palisades.local>
References: <20260413-blkcg-v1-1-35b72622d16c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413-blkcg-v1-1-35b72622d16c@debian.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4957240010
X-Stat-Signature: 8w7bnph9urwaj6dyafsr1dirp49idwgu
X-Rspamd-Server: rspam06
X-HE-Tag: 1776109302-722182
X-HE-Meta: U2FsdGVkX1+Hhf9hkubnx/1Wc/LnZtdgucEIZ1CGcuVe6v9SLsvbgAtURs1VCDHg4NOufzhMFE3GJV1LJk5WOesfeMqYrNSUbM2PT5ryV6g6QngeJFgeuUo+T6CERJKHv+MO1rcteRjl+YQlpo8tDDmkp2n92Qhvxl9kzbQtPY//vXG3aS87QmogN67K3RnEikprrxKLNm2PZCgPv8IZp1WHfz0VksmwBtUuHpZpPJe0byplF2f2PL0cpcOhaCc6+hLseCJOt5BZqK77u0yoifqoWPjdpLM+kaVZwvWEXt5s3PeG/Frkni6LYJs/9c0Yjf5exZ7tCoWowGolZ/Psl4BeK8t8qHF0m/MAmjZJdYDXH6k4SK21dUpL08S5+khoTMFeFcBmrf8eK1GBlaL0vD1dhZnaKS8QQYq8JV9kz9RajGWzzvvgHOzejoiWSAUNGR034s6FRfk1Wse/+iWBTCiSbeNJzm6hHyAacXKp6l71zSe42piwRyhvVk6bqk3b78Z6GfpwEf7uxT7Nje1wIlCcZ/joXfI9s70kOsI5UE0hM0xs0NERLrV55vKWJz9YKO2RlCqX1JGg5GnbIaF8sP9R3gbD1MjDCLuWs2sTMTfsKe/9fKpZkJPXJlPGZThhgHO94fK2pkpAy0xZMN6WXjLMKxVhDe2JbHYxDxevz1wk7MS/aW1nqOvdk2WR1TRoA1gr8/9dSNLSoRA8S3/jknVGT7mVu60l1ts07hP0+5PyQUf3LizuvPtxmku6HAULOWuM7Gwj66kXc/j79woLLV8A8P3XSayWt56ld+Y7zd4FWKeqmnhzQ+vtiBRCPJbd3dXLlc5sjELyb+ONTCT50lXe8pMbd5ZF8qX8CSxQkuC6vA0wFKbl/jgO5rRTcTuAEKTIlnYZlXpFUrYHplhpfioz1WWlwHib4yMBAZzSmT23BPON7qp7wn+UytechRho5oagHF3ydXfIzCAb2DS
 1+Qqiha5
 jOLl30obwMPGMdahpZvN1KoD1c5Wp9tfSs83dmv/0wxEyzqPWq7CBOWAExTD9HJLCv+JZ8Nhjg2IbxI6lV0s048iYPmCtQMM9DXXyyPFxQtPaI5YhF0/htHHSn4oJlohizhH2cp2se5HPbgQ8ywq+0Kj9f7uZtZo2Mj7LCCGqWAjciBOlTIugI9BKk/mlCbB7Ws3uKulqpfy3XOhTJuwY2/avmzdEh77jI+imON3AI9JIXKAZvkf38xatUXWKzUQs7c2skoe/EtQfRbksGtAdoAs1CJfIgqRjb98Fvs6T4VRErk41FF+q6n8CcPSa99ellPa0nMKqlI43xc8t/UJC7vBUw9bngUShPUFxZdgeNln1FZO6pCUav2GgG88x1E4HjAVdWz51KB25NbeCHrEuU1gAb8nEzSxfVn84LriLIoLLqvolxzxoiWio3ScpqVQPDEDBT4PoMNed1G8HSzDxZbuareeOJcAIlPNt0fQX5mpIldHAGFsBz1XrI6w/u0m70sH/SmBkpcMXGUaDOuzUS56ImY/US6UhcvCv1CKPkVPXJCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Apr 13, 2026 at 03:09:19AM -0700, Breno Leitao wrote:
> cgwb_release_workfn() calls css_put(wb->blkcg_css) and then later
> accesses wb->blkcg_css again via blkcg_unpin_online(). If css_put()
> drops the last reference, the blkcg can be freed asynchronously
> (css_free_rwork_fn -> blkcg_css_free -> kfree) before blkcg_unpin_online()
> dereferences the pointer to access blkcg->online_pin, resulting in a
> use-after-free:
> 
>   BUG: KASAN: slab-use-after-free in blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
>   Write of size 4 at addr ff11000117aa6160 by task kworker/71:1/531
>    Workqueue: cgwb_release cgwb_release_workfn
>    Call Trace:
>     <TASK>
>      blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
>      cgwb_release_workfn (mm/backing-dev.c:629)
>      process_scheduled_works (kernel/workqueue.c:3278 kernel/workqueue.c:3385)
> 
>    Freed by task 1016:
>     kfree (./include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6246 mm/slub.c:6561)
>     css_free_rwork_fn (kernel/cgroup/cgroup.c:5542)
>     process_scheduled_works (kernel/workqueue.c:3302 kernel/workqueue.c:3385)
> 
> ** Stack based on commit 66672af7a095 ("Add linux-next specific files
> for 20260410")
> 
> I am seeing this crash sporadically in Meta fleet across multiple
> kernel versions. A full reproducer is available at:
> https://github.com/leitao/debug/blob/main/reproducers/repro_blkcg_uaf.sh
> 
> (The race window is narrow. To make it easily reproducible, inject
> a msleep(100) between css_put() and blkcg_unpin_online() in
> cgwb_release_workfn(). With that delay and a KASAN-enabled kernel, the
> reproducer triggers the splat reliably in less than a second.)
> 
> Fix this by moving blkcg_unpin_online() before css_put(), so the
> cgwb's CSS reference keeps the blkcg alive while blkcg_unpin_online()
> accesses it.
> 
> Fixes: 59b57717fff8 ("blkcg: delay blkg destruction until after writeback has finished")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/backing-dev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 7a18fa6c72725..cecbcf9060a65 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -618,12 +618,13 @@ static void cgwb_release_workfn(struct work_struct *work)
>  	wb_shutdown(wb);
>  
>  	css_put(wb->memcg_css);
> -	css_put(wb->blkcg_css);
> -	mutex_unlock(&wb->bdi->cgwb_release_mutex);
>  
>  	/* triggers blkg destruction if no online users left */
>  	blkcg_unpin_online(wb->blkcg_css);
>  
> +	css_put(wb->blkcg_css);
> +	mutex_unlock(&wb->bdi->cgwb_release_mutex);
> +

I haven't been in this code for quite some time, but does this need to
be protected by cgwb_release_mutex? My understanding is that
cgwb_release_mutex serializes wb_shutdown() between
cgwb_bdi_unregister() and cgwb_release_workfn().

>  	fprop_local_destroy_percpu(&wb->memcg_completions);
>  
>  	spin_lock_irq(&cgwb_lock);
> 
> ---
> base-commit: 66672af7a095d89f082c5327f3b15bc2f93d558e
> change-id: 20260413-blkcg-9b82762430f4
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

Whoops. I think I made a bad assumption that wb implied a blkg existed
but if it never created one yet, then there's no blkg pinning the blkcg.
Either way that is tougher / more wrong than just keeping the blkcg_css
ref.

Reviewed-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis

