Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0494C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C136B008A; Wed,  2 Sep 2026 00:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2626B008C; Wed,  2 Sep 2026 00:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FE66B0095; Wed,  2 Sep 2026 00:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 876616B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:16:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1868B80642
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:16:24 +0000 (UTC)
X-FDA: 85167510288.04.26E0045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C20BC000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:16:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZUs5V50K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788322582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZLplcC78nW04+rNik0Rv2RsIFoVAuiKuAJHw6vULLA=;
	b=37VMKGP+4n201FjZWgDeJ1x5BeUdkOvy/8BvFTVReXk6zwSOuYHI/DcesbwMZpS76D0ZCo
	GO8+TA77daHvhuAtfvOkV0oirxb6hnBg6Q47zGggkULR9CDUxUGtc0YzkMODvnRmm/7F8x
	l5+lige97Gp2hO9auUP8kU5YDn3p4Ts=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZUs5V50K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788322582;
	b=YgLxl+A+dl/KB5nebTfp+tPK6drjmT7ngvM4GY9B0VX7+TNvcR9XHyU9/4n+p+1nXgVs7f
	F6EKPdwd7/R+jN1H2K4zEaLn5/VEebpMBKeCJGXm+cP5AQ/SAqWvFnSAsnEyK/NDUppFnu
	Fy+EqfkcgqPWXcCrOlX2Dc5lixwMYBY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1194E600C8;
	Wed,  2 Sep 2026 04:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5DF1F000E9;
	Wed,  2 Sep 2026 04:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788322581;
	bh=BZLplcC78nW04+rNik0Rv2RsIFoVAuiKuAJHw6vULLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZUs5V50KLwRoGyMtkB1q+P4WuOZQdIgVCfbYV1lxIu+szOOxUYKyLxRa5oFZwj6Xn
	 MOFB+A3ho/QCG+1FNcOrk109aBfOPaUKGVFA4Y/udCbbfyS5hp1JBDcQn9Yioo8896
	 4gGmxHNyvahFFCMylZtWPPNXF9fXaJGyajMIGT0cRUKpe4Zc4QwmDEqvB0vj2/u8iF
	 9rqtus/lJejBJJnC8xR80EzOn2H0lkIGHH6zMPuUYv7WvO93WwnbuukJmcTAcSVxbI
	 j5uU2jayAE1ZLy9EzqJS/nZzUItVmAYk0xfBp0SYGdf+1iw64eby9gr9cW84kiUOOA
	 eVa67NbVMnDHg==
Date: Wed, 2 Sep 2026 07:16:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com,
	david@kernel.org, kees@kernel.org, mingo@redhat.com,
	muchun.song@linux.dev, tglx@kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v11 3/7] mm: add a template-based fast path for
 zone-device page init
Message-ID: <apejDEdW95T-tekb@kernel.org>
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
 <20260831111638.76012-4-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831111638.76012-4-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C20BC000B
X-Stat-Signature: x7e8wdxq5wztnjq1m7rxi3bf5se1kgnq
X-Rspam-User: 
X-HE-Tag: 1788322582-618921
X-HE-Meta: U2FsdGVkX18bfUqwIaA4z9B2h+0UMgNimN6CcxcoZM4G/2MAXIVH91JYrbly+V/EBcWFLLpuflp1Ow+pWmwgDVzfn314JkdG3P0+Dlmz46aQr3dT3rbl3EDh05nWFyqpzwA8p3XeyTrd9OwEpJFArGhx5uKs4mbKpLw7rHkIqTH+utke3I9IwiTgilmBCbtkk+c0NC9FnZvilau2xAse5RKto+zSIFg9xxYyMqlTHUgypeeCb4aLnI5CGnY6cjU7bGtSgKVS09QlwiZOLeGjFSFEFICsg9ZC8icdD2VzKMO3NUFL+ef2mnXUGBvpCohxsWMCFe6Nj8d8U6GFb1vrWfbukFx/FaACaAQ6yZwbctItgwOjPsyj4Orwvees7muUBXYFb+eB6IUgpBVMMq8SGr8GOpk+4tVxlBNGqFlOSFmj3En8eTihxRXp/eCEIhO6gqgv9jl2mVDcUvrPJUJfNoKw7+OuZGUUwWB9SR0JhCr6bp7Qmrhw3xQcXYGm1jq0Odg5orFr8WNY9LDuhC7gL557U8tEvbj5oFKzBygWtT3IoZaFXovqnk5t0gl55D51SDER7VFGOr+lkw7Uo5WhWsoOA8o9Ffh71UD7aDWaTpOPcZ6plByyy6ZjNnlH+xd9UzIkRSxUKDiYNW/4Hw7/1sMoVGZhPemAbzh8U8oG8XsAOPEzeh+O1e7NJrbJ7tIMoS8+eNYX4sHAnC5PJHuyrh9pXpv76GePTcgsf633+V8fipDBPx5cX0lqyfoadszEbSGW684f2iDYITxqVgqsd/rJNrfrwuLjTjFs6EBFjCct/A6hZJxKXBBBKrw1OS5i4PnHfFR9oJrAmCEbBf8r4TWmgxDrEEf4wjdIYMjqiXQYQqplDNow9hogXrTN778Pxiri1U890NJIBNZxdPJbDOMweB1z/6UtsqMSfUP/V4L5p1HWSL1rr6ASu6l5XPs2AsqoIOHh8jzYA6ZqftJ
 0RZ46qLr
 M2ZOa+fH1dYQSgguoEBQSufG5Pzncsif5yE7Wvnyx/CTJhJbRkiNGCw/dMuSFXiuL13yliCHk67ASJJSpeCObiDt5b9awdojiMptmZYLMFm/YjY+PXRk+aeRCn+LA2H7qLEvLqsTVmGZ+ueVrq0/KqmAFZariYRuEgdEzjnSWEn/yB3G+KevFwGXZGMM6h7OnLvNluOde16qd3x5UE0RcbgL7+1uauomTg/Uf+/BQsHVcxruJXTJOD/wzCAjtinwxjS56OqrI5xqvBpQwPqbOTIRpnM58yHWMw4Im/F6bJCMxmfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 07:16:34PM +0800, Li Zhe wrote:
> memmap_init_zone_device() repeats nearly identical head-page
> initialization for each PFN. Initialize the first real ZONE_DEVICE head
> page through the existing path, copy that final state into a reusable
> template, refresh the PFN-dependent fields in that template before each
> copy, and copy it into the remaining destination pages.
> 
> Use the template path unconditionally. The page_ref_set tracepoint is
> primarily a debugging aid, while this code is still initializing struct
> pages before they are handed out. From the perspective of users of those
> pages, the initialization-time refcount transitions are not part of the
> observable page lifetime.
> 
> This means page_ref_set will no longer observe every initialization-time
> refcount assignment for copied ZONE_DEVICE head pages. The impact is
> controlled because the final initialized struct page state is unchanged,
> and keeping a separate non-template path only for this local tracepoint
> observability would add complexity to the common path.
> 
> This patch accelerates head-page initialization. The pfns_per_compound
> == 1 case gets the full benefit here, compound tails are handled in the
> next patch.
> 
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
> path (pfns_per_compound == 1).
> 
> Test procedure:
> Rebind the nd_pmem driver 30 times and collect the memmap initialization
> time from the pr_debug() output of memmap_init_zone_device().
> 
> Base(v7.3-rc1):
>   Average of rebinds for nd_pmem driver: 221.07 ms
> 
> With this patch and its prerequisites applied:
>   Average of rebinds for nd_pmem driver: 155.00 ms
> 
> This reduces the average memmap initialization time measured during
> rebind from 221.07 ms to 155.00 ms, or about 29.9%.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

With one nit below

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/mm_init.c | 38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> @@ -1093,10 +1106,29 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  		nr_pages = end_pfn - start_pfn;
>  	}
>  
> -	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
> -		struct page *page = pfn_to_page(pfn);
> +	if (!nr_pages)
> +		return;
>  
> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +	/*
> +	 * Seed the reusable head-page template from the first real struct
> +	 * page. The normal page-init and refcount helpers must operate on
> +	 * a real memmap entry rather than a stack object.
> +	 */
> +	pfn = start_pfn;
> +	page = pfn_to_page(pfn);
> +	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +	memcpy(&template, page, sizeof(*page));
> +	if (pfns_per_compound != 1)
> +		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> +				     compound_nr_pages(pfn, altmap, pgmap));
> +	pfn += pfns_per_compound;
> +
> +	/* Initialize the remaining head pages from template. */
> +	for (; pfn < end_pfn; pfn += pfns_per_compound) {
> +		page = pfn_to_page(pfn);
> +
> +		zone_device_page_init_from_template(page, pfn,
> +						    &template);

Nit: this seems to fit into 80-chars line without wrapping.

>  
>  		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>  			cond_resched();
> -- 
> 2.20.1

-- 
Sincerely yours,
Mike.

