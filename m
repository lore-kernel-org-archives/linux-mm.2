Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA355C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 12:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A588A6B0095; Fri, 21 Aug 2026 08:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A304A6B009B; Fri, 21 Aug 2026 08:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96CE56B009D; Fri, 21 Aug 2026 08:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64F6B6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:50:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E6B880114
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:50:05 +0000 (UTC)
X-FDA: 85125259170.06.43689C5
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 31960C0002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:50:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WZfcWbqp;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787316603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fhro7MxrmdtRID/n94E3pPhgJ57IS7qKaNzNOptQ1Mg=;
	b=Yrj8HFGm0/AmUfKJTNf/42y1ePaBu4z10h2tFHgDViIMIiHLVb1Rm04sWC//pzs30+l20i
	iV9nYZoOL/HNplYc19FH49ntaqDmC3ctmfTPy9w0PucZN14CJoQs0q80bXtjUVR4Q0SwPK
	K4CKLVnqumo5UNeAovebMUJQ5Qw5jIE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WZfcWbqp;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787316603;
	b=zLtRkbnXxiLX82fFCcHoM1pHT4gj3fcRp2oWEAhcHftiIDf7svdrrhak5a97QX5TdCFCmi
	jfyAUjJtIKqA9caof8Gbax8txxpVQk/k86KGY00PoviCvpackauTNgkf40jBiWqcQ469Nc
	Bd9IL5sePYw5qO2glMEI6PAwIhE+WKY=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c05dcdf49so8641921cf.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787316602; x=1787921402; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fhro7MxrmdtRID/n94E3pPhgJ57IS7qKaNzNOptQ1Mg=;
        b=WZfcWbqpRowvjFUxFQuo+RQob9q0If//KTCrnPAY8T0NhASXwtRmL51hBYHVIAVAAX
         pi/Tdi9OZEa/DaNn8tbuaBF2BVq4ZTq7puvUY7SMvuL8FQx1OPsa4NP9hl/ApJ2s3gcR
         E2/JZ9tobWE4foFo0oKZVXpsBu0S5gMnyQrrwFTevwrrZ8ORuS6RZfXck30O6cLQu7CF
         mjgOC/GXInrLAItINIO1N46myMpTqhI5dOk7el5oYQJLpq95wgHa8G1nP0hFkOXQxZN7
         DJDOGrwayXSil+U+tsp+Vp97SBGhNR1cVLEqXRDns1b/KL6Dib0SQRM0jfvni/KvUGeh
         f4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787316602; x=1787921402;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fhro7MxrmdtRID/n94E3pPhgJ57IS7qKaNzNOptQ1Mg=;
        b=piaB0jc9ZxB5BRgVrKiyq/hfiUgdHfUXNHq5kMWKNf65psAx1Z2SoKObuCutLYlScQ
         eSg6yGxuxCfmVVhmxGtb7+kWMLX+1Bdd5YtzuR39YJzR1v63e3zh3qE/fSR4OYbiZ3hN
         nioDc3Yi4Xh9uTtYC+FfYJarYEsZhKMT1iaTNA30nOjkBtlfY77kmB8ITentSFCiNEcB
         CqUiVLdZ7KCgOrQwlYizbaV0ArFL4QE0rVWLT1zbo4FU4dd9q4bNK2ZRP3dHXB1aKWfq
         +gqIGa4a+oebDFeAgnEw+KjZ1rNzhsPEK6uSecizgRxyu1sKoi6EcQpnGXST/RN3mOpy
         TpfA==
X-Forwarded-Encrypted: i=1; AHgh+Rp2Iy5h5gY5rNzUNYnN20YDSdIZ7fVRsGLZN/hYyQWxzJleamsra056efcPNcaa9DRxiKdm67CQvg==@kvack.org
X-Gm-Message-State: AOJu0YzIELsjXXcSGl3S5DiVNPpyDIPi3xYPpbSlW/IfajeWZqUBtV2K
	KxexU3TFFYws/m8hOv4z6lHpbLrZ4QznFBgjgVshM1I85/aIIBX8IWwPTiS7rqm19+Y=
X-Gm-Gg: AR+sD1379kux5hSO2M4tQomCylFFqxxrLNT/KhxIJd85S1XgbZJ39qOkdRbLewexnt4
	rQUv8D1rXoiu9WxgFryiI/tWI1lsFnRwAoyZYCbmH0Ip2SXFRUqpIKVAnJXAAhwo/SOaaBj6PQB
	MOi8NA1RP/nosO0cmprg0+5w2UsApmIReCgGjnvzslas/0ENAsGCPTFHEcGeqpth+pJex+NR7v4
	HtfACy3/yGAwBUiVj9dAKikgWlCfYyQLMAUhzGMSJ0dmBMRGwaAmfYNJj1Kw5KWlv1QhxH5OOj9
	6ATsQK+ARa36b3kM9X37F9aw8rK+fga5FbG4xPXVT8BIdwMwMe3e6KNs6/4W6kj0dIpYBFWa5kC
	DyXrHpMR5VIkUDW5jRf5pUBDFIvhDxrkRMyNLwVz6o2z2CIdRasUuLr2uRYSnU1Su0sTNeeCGGC
	vEwtPMstuhZ5Yt4ApgOgcGj0rw595mxQMjBnmcCrWG2iDM0KWHn6qsqrGZfxM=
X-Received: by 2002:a05:622a:2305:b0:51c:849b:86b with SMTP id d75a77b69052e-52df5ba9d6fmr52365311cf.43.1787316602046;
        Fri, 21 Aug 2026 05:50:02 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720493f05sm578788685a.6.2026.08.21.05.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 05:50:01 -0700 (PDT)
Date: Fri, 21 Aug 2026 08:49:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 3/4] mm/vmscan: drop the combined limit gate in
 __node_reclaim()
Message-ID: <aohJdZmJjL1YvqIH@cmpxchg.org>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <20260821081741.1340277-4-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821081741.1340277-4-ridong.chen@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 98bmzyhqhib9hiehc5yek684hmqrbdok
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 31960C0002
X-HE-Tag: 1787316603-976038
X-HE-Meta: U2FsdGVkX1+ccgsJ08seAjfp32xxirgXXqwyZBPmt7nW97Qa2meJXasEgaORL1b+BU6TbiaXHepOPnr6DBxvtqOuGMq2f2IaOVO4MwJ0/pTek6GIwA4HA6mBazqeLIZSACv0++xSGJ8ztKXD4zQfoAksD/dDJqIY22dg4RJNfscpzwmYqzWvMLudOmlzbkIVrn+wbn2fRXTmTHlbwUpTnojFGKOcDiGewKYOZ61rizxPX7r5e3SXijWCpRsguRGqrE37F7MHA/U+sUDQuyRrnKitWrIW5DBErnIgUfPoNgIER1OlFGV/+/Y1rMkdD6TJC78rMARTQpklXrnTn5SRwAOTx+iMfIWczeleHWcACnBuGtEyuaMwZWCmhWoKa/wtrisgSCf3++7ygE5xiwYeHes12/fCATaSrBsZ+89Jsjg14cAV+cBIpKfyAOPi86Ter1s3iNu0lvdxOX23HbHmW4iLElktjJyw/YepDwNn4XXkQXQP8JQdEhVh7tyS9LB0x2UX/5yFWhu5vXkF/1GDRTOD5R37tqwfOlNEPox+zkIloikwn9w9ZbCq/HGjsBRyOVhi2iuyZcl9iFAdh0q9FhNrrw/azRAHlT8B71WGXGa22b6k18jnFd4Py1T3+gMRBbd3KAk8wLv1cuGdL2u8vsJgatQ2OniI2NFLTQc8oyXYPGBq32myAyaTaHsXK51ncZxbWV8dFhUzfLJhvgSn0wGRr8LQ6F9p/jc0yX8ZCzYjh4ssekQvtoDCYgXqQ3XkELHnqssSXWzfXbIzh/NS95080dsBbeCqZoe2NNs8RXVB3plVmG6510hbwEvF06FHu82roNSWL0OTqzQCz6LU5BHNcG3fSKHUY8LIICgMTpfQDsE7n6jrZ9QvBgFlGZ8OSVzXtgulJ6wsJeJfmNYh+cDHH16w18VzzERtIz/6xqVI6dXZVtdvmCp7g/FVzWAo7tYhV/tvnsJ6+84kLl9
 P5o6EFl1
 ooBuop1zOWO0D9CHX21knIS5IMgIToDFAS2pDvoTBFdxD1Io1ZZFPfAV8ST0ifolkmsJL1aJ2uAK05I1UVBIc641hYMRUvqCQLXuqH3iBCdMCHUkyXC2ciGbH7ajhKQbjiQfyf9Jin5o3wDcVIv8wj9SAFaTTjtu/ZZLEfn66dMxs+lDq208I1o4DGw8WDGKavaI2Y3SvoPtMtVPQ3UB8JrTWfsvBlgk6etKse724IgFFs+NuvzDu3PNrF0p12oGpQIQhM620xBMc4I0Edc9j7Is4i4sA5ZkHv/RPxYQK0dmde8gEbvAmv1MwJXN8j1LpHLmz2tfUWkgkSoIYCTnQxj/M6tAiAIAgsBuTDPWiS99SjTWGBBtPdad1R2zRRD0c1o/przpeFHHGLUa/PnRDbeu0dnL/RsJ2ihh2cLLMgfrNZouMoSwzxl3PNWqT1frelPmmnRwhb8imc+2uyaNrNtbE5vGDkmxq3mL50/iMNGE/oignwyG8QS5nyvIB5rYfCd6/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 04:17:40PM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> __node_reclaim() only ran shrink_node() when unmapped page cache was
> over min_unmapped_pages OR reclaimable slab was over min_slab_pages.
> 
> With slab and file reclaim now gated per type by sc->skip_slab_reclaim and
> sc->skip_file_reclaim, this combined gate is either redundant or harmful:
> 
>  - for the NUMA node reclaim caller it is always true, since
>    node_reclaim() only calls in when at least one limit is exceeded;
> 
>  - for the per-node proactive reclaim caller (which does not go through
>    node_reclaim()'s checks) it wrongly suppressed all reclaim -- anon
>    included -- whenever both page cache and slab happened to sit at or
>    below their limits, even with plenty of reclaimable anon present.
> 
> Drop the gate and let the per-type flags decide what to reclaim.  The
> node reclaim path is unchanged; the proactive path can now reclaim anon
> as requested.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Could we go with this patch and table the rest of the series?

These minimums are specifically for zone_reclaim_mode. I don't know
who is using that at this point, and it seems the behavior has been
like that for a while with no practical complaints. So my take is,
leave it until somebody has a real problem.

Applying those limits to proactive reclaim, on the other hand, wasn't
intentional, isn't documented, and can lead to unexpected behavior -
considering we have non-zero default values on these knobs.

Since the gate was already redundant for some reason, leaving it in
node_reclaim() (zone_reclaim_mode) and killing it in __node_reclaim()
(the path shared with proactive reclaim), like you did here, sounds
like the best way forward for now to me.

With an updated changelog to that end,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  mm/vmscan.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1e56973ceb73..5a3f67b3ba32 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7906,16 +7906,16 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>  	noreclaim_flag = memalloc_noreclaim_save();
>  	set_task_reclaim_state(p, &sc->reclaim_state);
>  
> -	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
> -	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
> -		/*
> -		 * Free memory by calling shrink node with increasing
> -		 * priorities until we have enough memory freed.
> -		 */
> -		do {
> -			shrink_node(pgdat, sc);
> -		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
> -	}
> +	/*
> +	 * Free memory by calling shrink node with increasing
> +	 * priorities until we have enough memory freed.

Might as well drop this comment. It just says what the code does.

> +	 *
> +	 * What to reclaim is gated per type by sc->skip_slab_reclaim and
> +	 * sc->skip_file_reclaim.
> +	 */
> +	do {
> +		shrink_node(pgdat, sc);
> +	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
>  
>  	set_task_reclaim_state(p, NULL);
>  	memalloc_noreclaim_restore(noreclaim_flag);

