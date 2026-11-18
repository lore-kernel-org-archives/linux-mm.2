Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB713606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nYvU/FA4
Received: by kanga.kvack.org (Postfix)
	id 0DA916B05C0; Wed, 18 Nov 2026 10:47:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B866B05C2; Wed, 18 Nov 2026 10:47:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09616B05C5; Wed, 18 Nov 2026 10:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCD936B05C0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:47:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D9ACA07CD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:47:03 +0000 (UTC)
X-FDA: 85448668326.03.3415D9F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7DC63100005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:47:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="nYvU/FA4";
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016821;
	b=0q5h8HkOID1JYSNmlorz9a6a8AKzmM5rABAKSP1E0DUVfIkCX70ET9P5jF/M2GnMLyuwEb
	kEcRJY0VmK1ANvDZPsZa9aMl6+Nl3ffXkUc7oQ3lDgTwwfEML7HCE8lmDbS/Sme7hG898P
	kw4mgCIa8NOuHvvtchVBMUux2fB9UZY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="nYvU/FA4";
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qgt/D7EjetA1zXjZ4OojFsT9YpnJKXfxEGboHnE/gd8=;
	b=7SxlqiYIAcLi+vN7neICH4yyXxD2RPFhl9DG8Vd3Q6z4nBP70GRnMut/pulpe4jsZRD/+N
	Ch41cUlZLzUoM8W++WUguQEqCYiedGYUCvAtmiQ68NcBujNKl3tSZb4CxhZoZj6iJchl6F
	0fVoh6Cq8TlRsaDY68z8jxlexNCzIiU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C28A4339;
	Wed, 18 Nov 2026 07:46:57 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D6323F632;
	Wed, 18 Nov 2026 07:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795016820; bh=AkNRT3RQuliNSsz+dDJtjd/2TDwlCHcU7deLN3qC6XE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nYvU/FA4MPmlvSnqmXps2Wbn7Huogpk0j4p9MFldIIA3Fx7wOdgDmvmbh9V4mEPa0
	 rr5P4CpV/BmJDkS27UOK+Fx7XoY1cW67MzGMgmJ/oPBN/7Z3fFfDiaklOz0TF5I6uq
	 gPqSmkldPvLyByemva6p/vW/kGtcQrlqDWGShTHA=
Message-ID: <bf8692ab-f5b6-4ffe-b5ad-02ad59182cc0@arm.com>
Date: Wed, 18 Nov 2026 21:16:51 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/page_alloc: move the kswapd node skip check
 into a helper
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-3-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261116232346.788145-3-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m4189q4nsp67x6c8yru1x1mno8gkwo4t
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DC63100005
X-HE-Tag: 1795016821-635377
X-HE-Meta: U2FsdGVkX19iQG/GjnKeZjBSehl0xQD1tNsPD6Xa/yNqkaUuazxNcPbV0dgW1pVc5o1rlG08WzZntkbLn5CM+lL6lOw069el/lpJewsXzP0OIY69daQt1MxMdeT5qKLrNdbX2n6o1Bz8gdhj5unvsAricYP/zHW0UwN+YoH5ce4G41lcjXFWEOCRqczuyYdAIYUVkCcyBB9ziP4MITrM/rUuwZLeWS2zhrALukQreLpIPrVn8MQsLzu8R9Kfo8IPEAQM4YJG1C602AAQv8cZycRZs5U2UC/9KgSGF8BygOtwUSYyLDnnLg3TKEMvTgA8yVnpn8qxwv9NUJp6VfHJwvjB5c9wxOdQ6JuhYrq4Z4522m76IkMN6Lmu5ZCSK8i3xkQ75BUJbF4pd91k5qaysIlcb6knB5NiWS8EKCr2iURVR3ozHBRaMWS7jPTUxKxayZtcyv5wn0CsfX0CB5OUapgYhgMLS645JB/F+g9KAdRkjcxXHRrqg1TEpeGPfvnKpRoCqiLumHWnjx6Dbl6/XvstDZREsG53BcMAyXnGu4SQb3Lg/Mc5izl9zZCgYCcRqdPjgJpOZijo4lhzEmAlb41Lhw9nSib5tQBv4LSYgQScRzCnsng/ujbbBVTcV0V9nibXoI0ZoxMAu2O67yE16cmFtWyh++wfDufRmEQCnDyDxyZPHHjay56cuTL0JUQZxw8x2jBU+Rj6hnAvkyfY5HW7Cnf9QJgG456ERnjfL3sEixcoZSkW2atnyxjfOPMvABzapflWry+T6qngWqtO1261hyYRa4Di9/v8jIDDsJAAy8CNMpBFRl2xY1FG9m3lzp8BgRDIpv/+m1odiugcd/IwfO0jgs/NOq2lHe8PMTBs2mGCnIvpfoQV6QUUSoGtS99NFufxtqrivIY0aSI/iOwsen7MbqQsECfoufxEU1YDoAxCwAE4sjhlVcF1GheIY2DJfaWTylLkrQ98pjo
 xjWNB7gX
 1H0iClSKI+1NJjolDOxOBz6yC7eV+htGZziZONnlDof1Z1dPhGjVTipqspWbtEo3IOXT7wh1tOXRFaAtVhlHoq4fU2//o7GvkGNklJds8SEEnARxY8bZ8isIQwvRcgAV7p/OlM8we05632T9HI+4LNdGc4A7gPptFJJJy09sX20diVOWfesdj+QBf9RvVzyklMG+i4KGHutiLTc4E048B+jcKl+bP56VvCBTvJFLVz5gFj32F5uQ4G+w/08VepY5+c9TIQx9YuNpcEin+R8LNGWK69rdC+HhraGJS24/NdUjDhy+MbKgS0X2+N2CWL1SGGppLBrxetYq56L8GGpUiruZJSCnYV0ADZqt9wTwxe+RPmOG26q8A/dxmYPs7IX0k8i26hnRP5e6sFx4APVoOc4y2XjE6ily31JQoMTOoz0VvCOZUjiG0O7ToQKhVN++DKLQ0GGD/JMB2eOZUeH5CrB1dSJ6jkJTt21W8R3D+mqF6ZD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 4:53 am, Joshua Hahn wrote:
> get_page_from_freelist() checks many conditions for each zone, often
> with a big comment block explaining the conditions.
> 
> Move the kswapd check and its comment into should_skip_kswapd_zone() to
> make the zone iteration cleaner to read.
> 
> While moving this, also resolve a checkpatch warning which complains of
> a waitqueue_active() call with no corresponding comment explaining why
> the lockless use is OK in this case.
> 
> No functional change intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Thanks looks better.

Reviewed-by: Dev Jain <dev.jain@arm.com>

But see below.


>  mm/page_alloc.c | 47 +++++++++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4d829e5eac49d..43929faffb989 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3785,6 +3785,32 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
>  	return ALLOC_DEFAULT;
>  }
>  
> +/*
> + * If kswapd is already active on a node and the zone is below its kswapd
> + * watermark for this request, keep looking for other nodes that might be idle.
> + * This can happen if another process has NUMA bindings and is causing kswapd
> + * wakeups on only some nodes. Avoid accidental "node_reclaim_mode"-like
> + * behavior in this case.
> + */
> +static bool should_skip_kswapd_zone(struct zone *zone, unsigned int order,
> +				    const struct alloc_context *ac)

Make this inline? This is the very hot page allocator code that's why :)
I may be overthinking but in page_alloc.c I do see functions with similar
size being marked inline.



> +{
> +	unsigned long mark;
> +
> +	/*
> +	 * This means kswapd is asleep, so don't skip the zone. This is a
> +	 * lockless check, since a stale result only affects zone selection.
> +	 */
> +	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
> +		return false;
> +
> +	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> +		mark = promo_wmark_pages(zone);
> +	else
> +		mark = high_wmark_pages(zone);
> +	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx, 0);
> +}
> +
>  /*
>   * get_page_from_freelist goes through the zonelist trying to allocate
>   * a page.
> @@ -3796,9 +3822,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  	struct zoneref *z;
>  	struct zone *zone;
>  	struct pglist_data *last_pgdat = NULL;
> -	enum zone_watermarks kswapd_watermark =
> -		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
> -		WMARK_PROMO : WMARK_HIGH;
>  	bool last_pgdat_dirty_ok = false;
>  	bool no_fallback;
>  	bool skip_kswapd_nodes = nr_online_nodes > 1;
> @@ -3865,22 +3888,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  			}
>  		}
>  
> -		/*
> -		 * If kswapd is already active on a node and the zone is below
> -		 * its kswapd watermark for this request, keep looking for
> -		 * other nodes that might be idle. This can happen if another
> -		 * process has NUMA bindings and is causing kswapd wakeups on
> -		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
> -		 * behavior in this case.
> -		 */
>  		if (skip_kswapd_nodes &&
> -		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> -			mark = wmark_pages(zone, kswapd_watermark);
> -			if (!zone_watermark_fast(zone, order, mark,
> -					ac->highest_zoneidx, 0)) {
> -				skipped_kswapd_nodes = true;
> -				continue;
> -			}
> +		    should_skip_kswapd_zone(zone, order, ac)) {
> +			skipped_kswapd_nodes = true;
> +			continue;
>  		}
>  
>  		cond_accept_memory(zone, order, alloc_flags);


