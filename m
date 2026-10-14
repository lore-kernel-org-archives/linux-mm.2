Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F1CCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0766B0088; Wed, 14 Oct 2026 07:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7880A6B008A; Wed, 14 Oct 2026 07:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E186B0095; Wed, 14 Oct 2026 07:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E573A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:13:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74F3D1404A2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:13:41 +0000 (UTC)
X-FDA: 85320971442.30.42D575E
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 661AD40004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:13:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XlQAItU1;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791976419;
	b=MrQQeFv9GThEcBSkrZlb65HpCAjaxoGod3Cgu7+Q8AqO9ONJH1FpRFxLVok/EaT4ABSX2S
	RD6Y5bbqFRCx1H0zHZinaW1kfym1HwhivEKv99M0UIxu1xZ6MCwtrgpgt3+4pNmdCWefcD
	DPnTyS1ahk4VEu3OtxDcVN0f4urHkBU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XlQAItU1;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791976419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXlUIURbYu6APktqXqLBKzg8bDGva6jksAa9GUaz5Wg=;
	b=QiwIW9Ff6yJmJKzJtOkjcbVWnNlT6uDNO8nCSGjtI4y8qeQsu02YOKDvqdJ+fFSX/7QqGw
	ecMD2YiDvOAPgR7EsAH0X4hEuT2kiSJ043W7LYj265Li5WceX1nIUNuwsbtPXbeD/rPaVI
	lv1AgFUfmzaMFe7n9s15I2YGnZaj6dw=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1ad2e2391so12659645e9.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791976418; x=1792581218; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NXlUIURbYu6APktqXqLBKzg8bDGva6jksAa9GUaz5Wg=;
        b=XlQAItU1yH8N8+09+uuDVdF5u132DrhnQ3sit+YXmV060ZoyTz47ce4mgmxkPvBnse
         yEYOmMhFttlqSDEXFGIq+fwB+EI4IkkL68ypV0TU7m7OHZjqlWA411uKTQw5QhJQhdLA
         2yIQZCrQcWZmbH//iciFOzwylznPgf0oA34orv4XjGuCKza4UK0YpZH4bPN6gtU3nbf4
         hY9w77wdwIrIdc9+RVNZozBx1c8RJMX3I9HDl9ZKIEcDVEVjSXF76Q6ih7PGbC00D0m2
         dCmPjg0d2Ex+ceJZfkDus9ULpAbNEbokAuLqebF5ayVJE4fLyZ8gfRItbpZMgaoxxH11
         FW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976418; x=1792581218;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NXlUIURbYu6APktqXqLBKzg8bDGva6jksAa9GUaz5Wg=;
        b=hCXxO0kj7BlMExBS8ybj6hSM0o4Fr+av0cZM1FCEnJzc2uq+ZqZA0g5ORI5fEg7b7f
         CgdojKXJaBltRabxg/vOcLVDxsjGpN8EdP8brmmVtSsqZkmSH2N1YscoW7BOqW6SPqkF
         OqMFb2FfsMYju5lenrTC6pGQC2t63Q/088aBhDKz6Z44t/NmG74xi5Dl9eyvbbB79Jc4
         28MdPfcT1HCeeaD5WA3X4aH2abMbTPfa3dY+0QSTDOaXIT4sdg5uFaRvz/esNlj2HB0e
         xcAXDruG5eK3XuxcrJeDCQ91Hv7EGosUhJ3YyquBCbOVzObko5CiGtZkYJZvrLEjyfn/
         0Vdw==
X-Forwarded-Encrypted: i=1; AKwUvByOzy8yMAdOAG13/MLc8ULDGToaFGk6BOR/9i4bwYeOKkhRKiHsupkO2PjfuI3gF0c3Lpn+mPfLmQ==@kvack.org
X-Gm-Message-State: AFq9FYIMAI2fVwgHK0AxB3Sxyv0/RpTxh/ivWqji3XkQqCQlMZYo06Is
	xSd5aC4mPbmHHVTmjkz5dvVZJg2yZ3yWNkZzjW2JODCbm7xuQCw6oJejQ6j92el87Fs=
X-Gm-Gg: AYBFou3+6t4uIfVJ10zrQTY1CxLCVVBFvNGduulH03rQD9ijU1FP8KP3EmcrYoSWZ4W
	YqTjq+x9ZxdL+s3Hm7h4oSq7LLTQftHTkorY+zR5jE7l3sShynjfOqwZdnyU6uD2PQCQXbpbIzF
	DR7BOgUzMjpqdk1+gmJcvr9KcI19A1wYRts884mcvuk28307DPXxOra7rMtdjiuK/Q5oE+Vl7tK
	ZIeOJA07rJR5+70aRjapzql/iOJo434N5E24SlTNwBYsBGLa5kZzuJUW2QAk+LmUbHZRZVXOqHF
	VFDmazza86H+7M/6Q+0wi4XVaNDIoKXY2txrSQEwMWaCa14WWauRWIhzbPUVOhQQxrb6YAByPlY
	4+DJPWAm5QIhRIPlc296qNuY3z3kB7yR2UtOZ9dCbx2lx2JYvhzx4mFZs0VPbaSzRLV/U6CIv1m
	3JB1vtSGyrGRqG2UpmbMHP1CzlQ+fzhqb892tcXPQTxHaVtwRHXhCPZ5zCZZSeENRWRuZXL3co7
	UqGGFz2UBH5
X-Received: by 2002:a05:600c:4ecd:b0:4a1:96cd:2f60 with SMTP id 5b1f17b1804b1-4a19ecf4c20mr181213675e9.3.1791976417794;
        Wed, 14 Oct 2026 04:13:37 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b3615f2esm43732895e9.1.2026.10.14.04.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:13:37 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:13:34 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
Message-ID: <as9j3rH3qRtFO0-7@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-2-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-2-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 661AD40004
X-Rspam-User: 
X-Stat-Signature: fmyb9ttgznk6xy4e8kckz7z4sy7p9b65
X-HE-Tag: 1791976419-674150
X-HE-Meta: U2FsdGVkX1+vGWaoE0Rz2VkRQqj+8H+CCYeFlEUYXIlMwvOmgrbVQOGo4JlJ1PyHaJfZ/dHrsB4aa5GHhJbYdmn06o46NB+oN0IMSVsFjWjQFVtCUeGoTKYv0rjButEzBuNDbwc6BTf6/ZgP/qIMhI2zYejo5zr/r1awxA/pnFUGCWRMoyaN4yETbhEtJHNkU5neVftUSkgQ3JX3VPV1+djpTO3oWOzS8srFLCvycIDs1luTu6zF5xugPigu1kNQXbpXx0L2Ic+NQaNzr+stEOfjK9GsMLHJRz/t1M2xlYITRHt6JcJJu/3rSMSkb/4jNmBBLfxs6Jxve7CmCtVi3yzqQCDRZ+Hgw6nvrWZGYD2gwM+OdVspLfAkmtiS8Zo/vNKfxi7NvvirppRGMEmH6LCJc/MPjqjkpPzBZLLIQKldXrvc9RGfydZKHblL4beYRbbNvyAtyMC1j+yP6hufl6xRSi0Oq/epTigv4TrPqclzfmrkrx/Cj/UHoVHUamneZoEl7fRZ8mPFKM4W7sSyW9eyYVd5HkeEkM/9E/+7sqcSRjMTrtFfqizvhvbFwy3btSCLzXSSWvWma9RsAxQHu1Jl/fx3I4rMsd2JsR9hI2O44/op4Z+BBRvWV7O0WTR7dLd0Mg55m1tcR5KlugXYi1GGKJC9v6BtEN5aYXgBMMUzHJV7VDvwA93SFMpYji1DQLyKThqKX6C096eDPczVr0P25e/bXnGjHE++RZWE7AeKyTN4znoBsVtc9MWcDyRpLcQdAn2wQo+6JItqpfIk/4j5BL6pLsKWXQ6W0g9d3t5e12FX++Cp4cj9nHRsjdiSpjFVD0/7wOabSNrbCP4/O1M5SKkhIgZtl7+si1OztY5rvGWMfuiT9I6F3OsFGQygtYZKFPlQukvj484Pwa9Re7JTTcR0lQLimMLcShkqsnDaBZ+0mYnpy8P2R3QY8BLDG72UUgumZHz87S03vmj
 foljGFhm
 tuwuWszNlmME69sWvLCX2L/LGB8GQzVxqzbxWUPA7IqEFIZcjzytvupxI8MIiD1GlrRHD835THCkC46Q3Mh5K7nUWjaTSn7m/lD42nrdoCR3HSjzWsvKsOaLj1NkZUzofUeWiMIXfSfTUEXXpDD11oedndEehdM4iSI4UzmZTYcKAKw8qc8c5ZxFywKp9rW76lzy/0nEr19PFel9VMHajV4d2pCEusCtrywLoFTMTwqLwi5yZraMNo3zXga3n99VE13Ch9D3p6S6RRcxX6UmLVZmLbQaOQnoiw7XoMsaya1DzgS5r6zQmYpN70vj9PIa19GPm9LVO0fAbX9n8BGR27/6VqtGuR2sI5GVBtnRFU7tl25XHeQKgjL10MzqiQnwQnu/p+HLACggOuIzA07VmQ1S88+za0YziUu6sSnVCdc7pH/HnsFz1b+01Gyw4jFCEn7h4lN2LrkTxa9ZxhDNXQ0wDaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 10-10-26 14:09:53, Shakeel Butt wrote:
> try_charge_memcg() does a lot. It charges the page counters, reclaims
> when a limit is hit, may call the OOM killer, and at the end it checks
> and enforces memory.high. Move the memory.high part into a new function,
> memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> memory.high code is easier to read and change.
> 
> The code and its comments move as they are. The only difference is that
> the new function gets allow_spinning from gfp_mask itself.
> 
> No functional change.

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol.c | 125 ++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 56 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aad0498a7bd6..20c5dfe1a894 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2696,6 +2696,74 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
>  	css_put(&memcg->css);
>  }
>  
> +/*
> + * Called after @nr_pages were charged to @memcg. If @memcg or one of its
> + * ancestors is over memory.high or memory.swap.high, start reclaim or slow
> + * down the task.
> + */
> +static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
> +			       gfp_t gfp_mask)
> +{
> +	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> +
> +	/*
> +	 * If the hierarchy is above the normal consumption range, schedule
> +	 * reclaim on returning to userland.  We can perform reclaim here
> +	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
> +	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
> +	 * not recorded as it most likely matches current's and won't
> +	 * change in the meantime.  As high limit is checked again before
> +	 * reclaim, the cost of mismatch is negligible.
> +	 */
> +	do {
> +		bool mem_high, swap_high;
> +
> +		mem_high = page_counter_read(&memcg->memory) >
> +			READ_ONCE(memcg->memory.high);
> +		swap_high = page_counter_read(&memcg->swap) >
> +			READ_ONCE(memcg->swap.high);
> +
> +		/* Don't bother a random interrupted task */
> +		if (!in_task()) {
> +			if (mem_high) {
> +				if (allow_spinning)
> +					schedule_work(&memcg->high_work);
> +				else
> +					irq_work_queue(&memcg->high_irq_work);
> +				break;
> +			}
> +			continue;
> +		}
> +
> +		if (mem_high || swap_high) {
> +			/*
> +			 * The allocating tasks in this cgroup will need to do
> +			 * reclaim or be throttled to prevent further growth
> +			 * of the memory or swap footprints.
> +			 *
> +			 * Target some best-effort fairness between the tasks,
> +			 * and distribute reclaim work and delay penalties
> +			 * based on how much each task is actually allocating.
> +			 */
> +			current->memcg_nr_pages_over_high += nr_pages;
> +			set_notify_resume(current);
> +			break;
> +		}
> +	} while ((memcg = parent_mem_cgroup(memcg)));
> +
> +	/*
> +	 * Reclaim is set up above to be called from the userland
> +	 * return path. But also attempt synchronous reclaim to avoid
> +	 * excessive overrun while the task is still inside the
> +	 * kernel. If this is successful, the return path will see it
> +	 * when it rechecks the overage and simply bail out.
> +	 */
> +	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> +	    !(current->flags & PF_MEMALLOC) &&
> +	    gfpflags_allow_blocking(gfp_mask))
> +		__mem_cgroup_handle_over_high(gfp_mask);
> +}
> +
>  static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  			    unsigned int nr_pages)
>  {
> @@ -2853,62 +2921,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (batch > nr_pages)
>  		refill_stock(memcg, batch - nr_pages);
>  
> -	/*
> -	 * If the hierarchy is above the normal consumption range, schedule
> -	 * reclaim on returning to userland.  We can perform reclaim here
> -	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
> -	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
> -	 * not recorded as it most likely matches current's and won't
> -	 * change in the meantime.  As high limit is checked again before
> -	 * reclaim, the cost of mismatch is negligible.
> -	 */
> -	do {
> -		bool mem_high, swap_high;
> -
> -		mem_high = page_counter_read(&memcg->memory) >
> -			READ_ONCE(memcg->memory.high);
> -		swap_high = page_counter_read(&memcg->swap) >
> -			READ_ONCE(memcg->swap.high);
> -
> -		/* Don't bother a random interrupted task */
> -		if (!in_task()) {
> -			if (mem_high) {
> -				if (allow_spinning)
> -					schedule_work(&memcg->high_work);
> -				else
> -					irq_work_queue(&memcg->high_irq_work);
> -				break;
> -			}
> -			continue;
> -		}
> -
> -		if (mem_high || swap_high) {
> -			/*
> -			 * The allocating tasks in this cgroup will need to do
> -			 * reclaim or be throttled to prevent further growth
> -			 * of the memory or swap footprints.
> -			 *
> -			 * Target some best-effort fairness between the tasks,
> -			 * and distribute reclaim work and delay penalties
> -			 * based on how much each task is actually allocating.
> -			 */
> -			current->memcg_nr_pages_over_high += batch;
> -			set_notify_resume(current);
> -			break;
> -		}
> -	} while ((memcg = parent_mem_cgroup(memcg)));
> -
> -	/*
> -	 * Reclaim is set up above to be called from the userland
> -	 * return path. But also attempt synchronous reclaim to avoid
> -	 * excessive overrun while the task is still inside the
> -	 * kernel. If this is successful, the return path will see it
> -	 * when it rechecks the overage and simply bail out.
> -	 */
> -	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> -	    !(current->flags & PF_MEMALLOC) &&
> -	    gfpflags_allow_blocking(gfp_mask))
> -		__mem_cgroup_handle_over_high(gfp_mask);
> +	memcg_enforce_high(memcg, batch, gfp_mask);
>  	return ret;
>  }
>  
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

