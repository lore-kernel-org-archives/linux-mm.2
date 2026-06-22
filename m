Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AD2BCDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19336B0088; Mon, 22 Jun 2026 19:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA966B008A; Mon, 22 Jun 2026 19:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0A86B008C; Mon, 22 Jun 2026 19:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBD46B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:37:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCA221C1F05
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:36:59 +0000 (UTC)
X-FDA: 84909161358.30.EFF079C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 25E6140004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:36:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oT+WFVOm;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782171418;
	b=RgF/SE1eErFY8ecfxsFoiXa1/F2U46DX12YtH0mDGcDlqN02dxOEm8wcx5P7n8OEi/wnFV
	MKbh7NBDMc7LShQx4cbPNoxBBOZghWTfqIwaibiWU1lV/vQIMtZdJFff6mTyOzZ1ruI90L
	4Bn94l/ELlMthqWLjxDNckPBfDAm6sY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782171418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XI1hxdezynCpB8B16MUEAQeC3TVNk9JYHRaQPktGvjw=;
	b=ok0J/WsheiOMO4m3O5glClDGjgWTuzp8RREaP5BE2DsrFM8QklGyoQKM+cdfkICM5kynbX
	x/gBOXJWc6/7J6IwqIlPknSXPXGlgLEVxZoIGo6NMosxgIDCGId3cyG5KZAlKHgpR6/coa
	F9pXzc+1qSwTbRSlu6aUUu6E6tFML6o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oT+WFVOm;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4314440379;
	Mon, 22 Jun 2026 23:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895731F000E9;
	Mon, 22 Jun 2026 23:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782171417;
	bh=XI1hxdezynCpB8B16MUEAQeC3TVNk9JYHRaQPktGvjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oT+WFVOmZhzP60d/nrMwBnaFfl3RcgBckMmT5NKwkN0CM05cz9S4xqNOPM9ZDwRJo
	 Yi7ftQepiOsHhVNrEg7p4XOz6irQiRY+PD4RwAsjQAMaFMbqXGF2imGawaE0BibjKo
	 oyRMxyXx8i1c/XWY8UB6PmpMdBnoQXbXrIKNqxa4TdnlqiT1pbWitx2IwyN/X00SZs
	 D0mUX8uD8adtnERyCFDi3CbVCDC+WGvHB3dgVxRHQ84Z7F3qYggG+b05PTIAQqWE/4
	 zI2/+K9t1R5UjaAnYwnuB+JUgyDCiLR3rUa3L2fbdOGsw14UnD+BxwcH/D3j+OKp6h
	 fH9emVrTQrWLw==
Date: Mon, 22 Jun 2026 23:36:55 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of
 shrink_worker()
Message-ID: <ajnGTt8tkbAWX8Oc@google.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-3-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618044857.69439-3-jiahao.kernel@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25E6140004
X-Stat-Signature: 9oijyyehkkj5awmump97t3yco4fi75q4
X-HE-Tag: 1782171418-142983
X-HE-Meta: U2FsdGVkX19GK69ZmkCoKbFksmiH9tiDOLeCTfCOGzRXOsz1LmSmWe1H4Sg4haJRG+5b85e36aMfhr3750qFzoqKI2t5GX8swDGVe2cxNnGeryo2ueN2UaHYenkU8d+Sl+K3CL5fFhO3iJlgK7cwukQuAm2Pt5ojkPiOCGyLztr0KpUnt1e8I/O+MHjuGSLz6w1CRATFO3slC6zv8SeHNSpV0AkCpG+2VE72bDXsLDwMD0b9w/4waN0DaaBHkYX8wdjhP67GdoD+md9eQ7G7jICseR5mDS6ls8bFgtXDvk95mvg1SaidC7sPdOlwHwaed5fNZoTBO4OVcdfmDukt6FiC32HeoiCR9K5kGYfnb6KeEgTD/CL6vtcv4S/DJNtqVM58Gif8gtD6kJamFvmuw2C30X24+18fD1Fv3W6SADSHoAlK1IoK/lgJGkrz/h2XZkeDWr0wg4QFnCO2xqMRokl33lXImVk3MHD0IcU/sWr0yTLMZIapDaSVn4Gaoc11jfwV1wh8IcrnHvZk8RUITwgXNDsqJXcVI/48UsQ+HX/B4FPGCiiqdqgKH0s7F2vD8JatJUfOdorY0tWnbss9FvKu/TpklCMNr7GD2gY/rVwYK6wgN8DK5YGt/igRXc9JwstmzA9LSJUVhqYOct7laQ8Qu4OcWoCLKEOXN7hFJk189EOrdiJw6TD05JbPsrKHrq0kFL/nxf+W1Ba7bHV4tug+ic/sW9NPYms+lE9JzPCJ4f1wkTjd3AWxemrUYD8T8Ujn7NAX4TcL+T9vn0L0Tj0pinUKqC2Js7EMHfkrMX+qnwBldBfj6ziPb5kI7xwR//JWzhzbTPWK66t2rlEHLu4P3A5Ypuqhl613GCJrK+GW2SrYKJNZDLLu9CWm+46qTmMTAe9wnWFl97Oavss1uPXCjdLFZCgzYLOXI5h3ara7beN/6ebC5ZMPasuiY92hnzbP+w4Emd3skyIzl/N
 6zgHib1c
 Sk2LxNbmfGC9DIMIfWSmy27YPRk7P8NUS+NOPC/5ZSYXglS69HxSmYnkx45MlQkC7qvDLkSmQuCufcVGV0ifIj9Eo93mu+60WRid26MDKlBPcbpcoMQUpdiWt1yMWRZxYY+OxeRS0c2VbOrrkCAs41G63dg7UmisJ19fSeVOxMWe2nWptV9zC6tb9OIMDCoUnTxTKQE1GNcN8Apg6FsHha/CNUH+LZZZrlske4FNR8+IrD5kdJiViz/eRzy/0XYF6prXnGi1NDRvuq114izinByiO3XeCXwlbHk/4FgA+OD03qxOcJOlNCfXgcgU5ieX3HduxdDJE5xDepDPP+Vz8CK0cyxswObdqVDg+blSyHDk/KVSiL47gLgR4tyPiqV3gJNuIxZoKH9icUg0Ls5TgwdHnMepBQFkfVlcR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/*
> + * Walk the memcg tree and write back zswap pages until the
> + * (lower_pages, upper_pages) window closes, or abort encounter
> + * MAX_RECLAIM_RETRIES times of the following conditions:
> + * - No writeback-candidate memcgs found in a memcg tree walk.
> + * - Shrinking a writeback-candidate memcg failed.
> + *
> + * For shrink_worker(), it passes lower=thr and upper=zswap_total_pages().
> + * The @upper limit is refreshed in each iteration by re-evaluating
> + * zswap_total_pages(), and the window closes once the total falls
> + * below the threshold.

This is the wrong abstraction level, and it's obvious by the fact that
the function calls zswap_total_pages() again to recalcualte
'upper_pages'. It gets much worse in the next patch as well.

The lower_pages and upper_pages thing is also unnecessarily hard to
follow.

The core of the reuse here is the retry logic. So maybe keep the memcg
iteration in the callers, and define a function that takes in one memcg
and reclaims one batch from it? failures and attempts can be passed into
the function to maintain the state across scans of different memcgs,
like zswap_shrink_walk_arg?

WDYT?

> + */
> +static void zswap_try_to_writeback(unsigned long lower_pages,
> +				   unsigned long upper_pages)
> +{
> +	int failures = 0, attempts = 0;
> +	struct mem_cgroup *iter_memcg;
> +
> +	while (lower_pages < upper_pages) {
> +		unsigned long batch_size;
> +		long shrunk;
>  
> -		if (!memcg) {
> +		cond_resched();
> +
> +		iter_memcg = zswap_iter_global();
> +		if (!iter_memcg) {
>  			/*
>  			 * Continue shrinking without incrementing failures if
>  			 * we found candidate memcgs in the last tree walk.
> @@ -1443,12 +1457,16 @@ static void shrink_worker(struct work_struct *w)
>  				break;
>  
>  			attempts = 0;
> -			goto resched;
> +			continue;
>  		}
>  
> -		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> +		batch_size = min(upper_pages - lower_pages, NR_ZSWAP_WB_BATCH);
> +		shrunk = shrink_memcg(iter_memcg, batch_size);
>  		/* drop the extra reference */
> -		mem_cgroup_put(memcg);
> +		mem_cgroup_put(iter_memcg);
> +
> +		/* zswap total pages might have changed, refresh it. */
> +		upper_pages = zswap_total_pages();
>  
>  		/*
>  		 * There are no writeback-candidate pages in the memcg.
> @@ -1456,15 +1474,23 @@ static void shrink_worker(struct work_struct *w)
>  		 * with pages in zswap. Skip this without incrementing attempts
>  		 * and failures.
>  		 */
> -		if (ret == -ENOENT)
> +		if (shrunk == -ENOENT)
>  			continue;
>  		++attempts;
>  
> -		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
> +		if (shrunk <= 0 && ++failures == MAX_RECLAIM_RETRIES)
>  			break;
> -resched:
> -		cond_resched();
> -	} while (zswap_total_pages() > thr);
> +	}
> +}
> +
> +static void shrink_worker(struct work_struct *w)
> +{
> +	unsigned long thr;
> +
> +	/* Reclaim down to the accept threshold */
> +	thr = zswap_accept_thr_pages();
> +
> +	zswap_try_to_writeback(thr, zswap_total_pages());
>  }
>  
>  /*********************************
> -- 
> 2.34.1
> 

