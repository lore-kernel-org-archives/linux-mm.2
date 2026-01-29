Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2390D61015
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 13:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4546B0088; Thu, 29 Jan 2026 08:05:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BF06B0089; Thu, 29 Jan 2026 08:05:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2106B008A; Thu, 29 Jan 2026 08:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB6736B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:05:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 869081A016D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:05:30 +0000 (UTC)
X-FDA: 84385022820.13.B43A3AB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id A073A40008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:05:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769691928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+xsghJlUIlIfSVEkQom36oUjAnXZDJrRxxGjnxLu/E0=;
	b=KFrpSpR8vU6zeg4EHKcdcrBO12LKcrjjYk9lJKVO0qHmuGhuj9wEuXnKkGY/g3nizMdluz
	l5965LjgucWRXQJ5tkW5vV113sWs/nIqRDzIxPHksnCQcm+8WNGLwOxNw3SQ8KMmA2I9XA
	fcyXgCX6YCUwE9s65xc0Q4DiY484Ebo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769691928; a=rsa-sha256;
	cv=none;
	b=1ekOxjTDX2R99dqcgNZNqHee/zqmbJkK368bSMLQOwwwezTWcTkOajdKSCczVLrSCSFLa+
	Q0+C+6o2mdIBQ44IphsFl5p0QQnKlaqxSL+yMAuzoz+olHjlWUoxeWLGS0NPj2edLMHRme
	Ee9p555oToLo8TpbfGwDiiKsVob5mG8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CDD2153B;
	Thu, 29 Jan 2026 05:05:21 -0800 (PST)
Received: from [10.164.18.94] (unknown [10.164.18.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 420E43F73F;
	Thu, 29 Jan 2026 05:05:24 -0800 (PST)
Message-ID: <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
Date: Thu, 29 Jan 2026 18:35:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251110232008.1352063-2-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A073A40008
X-Stat-Signature: 3pczjdiqxp5gf8kxop5x5k3ugponnh75
X-Rspam-User: 
X-HE-Tag: 1769691928-794903
X-HE-Meta: U2FsdGVkX19Cn0DWwBRkMrLyELe0egyLRMp5Eq/IUqaa/tZCKRbQzzTjgIvrNir5RiWMTDr1drZJNTw2xgt6rwYOv09WLT9CK3mBy9m6twvVZ7fe3mjAnxyca9A/5jaR54vfacy6d/53svG6Ur87DiAdFLxxYm7dabq2VYgK2vzdevQ/6FYFgcWO68KpWToGavf2alsW+QqW1b8HYbka0cZ6DTgKdHb3nos6KQsfBMz++vk+HSaxyX3y5f7Cw68aZwC0YyRrK2zfDnnOTTuTILfUiaz5TMpAOcgeuA15z7F7hxWNKKmVQt5BAzPluNM5tS1kFV9lhKK7ozeJRvvIgepVyIzJ1fyTDwlgcjohPvF/eToSux7MWifH90nCa578hukXZUxOD1lxlly+W+UUnp1IddsgG6pr93zZsvVPKZFX7Q7cC+OrlbRkms/GGgvl1PuLn1Ig6x6aCTKm+Ls6f0rnng/5szQs8HCOSEIxtkugjTsPk0gKPSVx798tbgCeGrYk0N8gms1qTASKyrTaju9Nfh9MEHuhXE6cSw1p+LN4bAHnXGXgEw3jd9TzQ5f+iUqca7FElAkRsLG03x/bU2AJ/vbQOJabb3tDz9R2pJNiM7mQ0P+iamiybSQjkzSTR6SPKg5KZmpn64GANdC34lndfVLX57v1g3eIg5KIMMxdPjZMKSuePoJ3l3vQjTuSRL2k8Ej2sI9yzg4Zs8sEZcB7tISMnpLDA84BOxxj/Z0C73L9jvG23Nkx5UFlb7DGcbMaOz21v8e49Q8x0WJiDOS0lBquqCQ25uaxzURSsBPmVJ9uNv4xzMByLx9kI1OqMiwlyxDg/tq26VTp6i/XHoANF3xalfV0/SQIzzqh8ame9gnypiw6foUJd5IpVsMvmUhsbEolg6dCl/RTkV3r6n1NDV+lkJGOlKRZhl7jkf1BS3a1l+vy8wf5QnaaHsdDVuZWUkzPI+5K1CQYbpY
 IYdMduYx
 +57MLi6Zzgb5x8q2VeQYWCSnlc0/cAo6TyLw4C3EQIusX9vE1QlgOkv89NM2O/zY9UMS4oxxD5fcf7Exn2uHXNQSNLzUjHhwszFi8pkL63ZMI0hxnO5Mv3Vh0v90QF9L/KctMriEb08PHSNecOFV2XbXS51PzoVhi3jiiIZM6FPaPXsXkLcZfoiAjp2qJPMY+t0x7xbplvpW5mapP2Kx1o61/tG7d/rN8nDlh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/11/25 4:50 am, Shakeel Butt wrote:
> The memcg stats are safe against irq (and nmi) context and thus does not
> require disabling irqs. However some code paths for memcg stats also
> update the node level stats and use irq unsafe interface and thus
> require the users to disable irqs. However node level stats, on
> architectures with HAVE_CMPXCHG_LOCAL (all major ones), has interface
> which does not require irq disabling. Let's move memcg stats code to
> start using that interface for node level stats.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Hello Shakeel,

We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
to munmap. Please see below if my understanding of this patch is correct.

>  include/linux/memcontrol.h | 2 +-
>  include/linux/vmstat.h     | 4 ++--
>  mm/memcontrol.c            | 6 +++---
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8c0f15e5978f..f82fac2fd988 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1408,7 +1408,7 @@ static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
>  {
>  	struct page *page = virt_to_head_page(p);
>  
> -	__mod_node_page_state(page_pgdat(page), idx, val);
> +	mod_node_page_state(page_pgdat(page), idx, val);
>  }
>  
>  static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index c287998908bf..11a37aaa4dd9 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -557,7 +557,7 @@ static inline void mod_lruvec_page_state(struct page *page,
>  static inline void __mod_lruvec_state(struct lruvec *lruvec,
>  				      enum node_stat_item idx, int val)
>  {
> -	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
> +	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
>  }
>  
>  static inline void mod_lruvec_state(struct lruvec *lruvec,
> @@ -569,7 +569,7 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
>  static inline void __lruvec_stat_mod_folio(struct folio *folio,
>  					 enum node_stat_item idx, int val)
>  {
> -	__mod_node_page_state(folio_pgdat(folio), idx, val);
> +	mod_node_page_state(folio_pgdat(folio), idx, val);
>  }

See folio_remove_rmap_ptes -> __folio_mod_stat -> __lruvec_stat_mod_folio. This path now
has the unconditional overhead of doing this_cpu_try_cmpxchg(). AFAIU the purpose of
this patch was to remove local_irq_save and optimize it by using a cmpxchg atomic
(coupled with the fact that the caller will have ensured preempt_disable), but
there are code paths which are not doing local_irq_save in the first place, so
those get regressed.

>  
>  static inline void lruvec_stat_mod_folio(struct folio *folio,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 025da46d9959..f4b8a6414ed3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -770,7 +770,7 @@ void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  			int val)
>  {
>  	/* Update node */
> -	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
> +	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
>  
>  	/* Update memcg and lruvec */
>  	if (!mem_cgroup_disabled())
> @@ -789,7 +789,7 @@ void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
>  	/* Untracked pages have no memcg, no lruvec. Update only the node */
>  	if (!memcg) {
>  		rcu_read_unlock();
> -		__mod_node_page_state(pgdat, idx, val);
> +		mod_node_page_state(pgdat, idx, val);
>  		return;
>  	}
>  
> @@ -815,7 +815,7 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
>  	 * vmstats to keep it correct for the root memcg.
>  	 */
>  	if (!memcg) {
> -		__mod_node_page_state(pgdat, idx, val);
> +		mod_node_page_state(pgdat, idx, val);
>  	} else {
>  		lruvec = mem_cgroup_lruvec(memcg, pgdat);
>  		__mod_lruvec_state(lruvec, idx, val);

