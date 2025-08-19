Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2140CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E78F8E0006; Tue, 19 Aug 2025 13:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF5E8E0005; Tue, 19 Aug 2025 13:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCEB8E0006; Tue, 19 Aug 2025 13:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0B78E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:15:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB302160178
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:15:49 +0000 (UTC)
X-FDA: 83794159218.28.46EAF46
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf13.hostedemail.com (Postfix) with ESMTP id D100B20008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:15:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PM0s0ghi;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755623748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiJkya2g4FSff5yfUkVXC41MIiQghloJYZcE1SJkKQ0=;
	b=ie2em56xKiCRuhzplU20LVx2YAlDztUL+THPWslss9MlEOVnXZAEcd9ldGlocCei6YX+QN
	H2/n3sP6jH4uI1ZKFPepTWtt0ffJS3RKKGRIKNUKSLRpHtnoPL4Z4l5YTfY0QPWNzFIrzY
	kwdV5Vp/1/jYiUIx+6kQ5SSZvB2O1wQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PM0s0ghi;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755623748; a=rsa-sha256;
	cv=none;
	b=KQJ/tC3h+Fx6DlrY27EqAPDBTNmik1sLVNK16amXH9xEq0uHRtBkC9lwFwxmDnIKz2bBoj
	TjwgWVgXiNCI3P6J1dPdEMtw+Flfauv0gMPEtnemTPdrRw7tbkGY6gKPcwToaA7VmDAUCk
	xKbF3gxQHSIk7Kai5HR0wQATJ3Twg1w=
Date: Tue, 19 Aug 2025 10:15:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755623745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PiJkya2g4FSff5yfUkVXC41MIiQghloJYZcE1SJkKQ0=;
	b=PM0s0ghiradGy03X4ixMIgB1feFBiOl0LfEPp8M3JIx3pNrtNS/5jHMuSo99IfK4CmL9rL
	ksudLu01f1It0+rLdkLKcTRguI9GVKcf3BArCXnHtENWbUHVDqWhDiffebMOI53+S9fbn/
	XRR8xy3T+P5gUIbforqLuYGimUzOt54=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@gogle.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in
 batch freeing
Message-ID: <x3xp3cj6wpgxu5mjsd62fzvuzpn2mxpvlk6sau65si7bk6ncu5@dx6jbuacy42i>
References: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
 <k6fpx5adh45t4jrxgiccq7acubwcgmi746crggxi6e4oihtvpt@thks5zrn53n3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k6fpx5adh45t4jrxgiccq7acubwcgmi746crggxi6e4oihtvpt@thks5zrn53n3>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: obegbdxw9imrwsqqdjp55hd6suw1eqcn
X-Rspam-User: 
X-Rspamd-Queue-Id: D100B20008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755623747-811835
X-HE-Meta: U2FsdGVkX1+i8bbreIGJPsSo+UjHYsfJdiSJHS7UdWGKUNf/ckyuFovqsM/OIGXHRk1xryidiiELVAt9n6bKjQbdPjTHyrky3URM/caE1AZNszbI9IM8/WRohyYC9ag+nOFPpM5WkypndiirU2hsx1By+WZTqVmAbLvuqg0YDqM+Fq2GX6iJq3Ez45ONd6Iu45qgiPMXrF5YR8vdK0BqAVhiAuWBMnTvtcGhTzpTu52c/zP6kOJgiVQI5CuekTvdZqMIneA3Z6Uq7FBxM0gunjgex8qVgpULqfK3NZl9uEXhNtHxs8tFcuFKDuFOAz+4KgZA/d+W8GmIvevdKdqhzwcv/jzRa41aURocv5wsnhWh6FT/YWowTkjp0SsUjoE1GdEhZSHIhJ/SGziMHCU84K/0A6OrGUmuLSEyOxEZSFWtjHNfctZwUolZip5ByHPoGXF5USWvklqf9Bd4jJQzABnSPjgQs3kBo+GsauFe7fa7gJBSV9jn1MVYAOa58UDh+252ybISVheCo8YV35mQpiVQCWQzCm26mpVo2z9eByShdaenf2UoyVCyUzCCnOOd5SahRRDGXBLsquf8egD69OE/AL1E9uzt9HjVttc9i+AWb34GWOCijxLH3CJYTBaKfIBa2ayLX4vLcwOaaKTxsaEJQlkZPUnWHlYEd2Hb445YYS0uFITVcLSbo3HqdKXrGN8Pn7iFnX240By2946EFUFfHqZCDFWvdpBBq/AIXv92J792VQcMz5DPo0hPzNx4dSmJXiYYbIJDQBF/9ots+orefex5YJRAnlA5mXfRZh9bJGITa9fnT15apmvqpTQG99oORN7SXZE2I0S+5fH4lOPV5zRM2y/sqIcNcfalw9/1u/A2M70DONzWA6GnQdRC/7TvfQcaapILxSyVM9zVgXkEX2X48QJVUo7DlWEz/ZyLYiY662ZUoMLh/28m3/Tt7/FzSRX9CyvwO1zkl/w
 dCFVMuPl
 PBf3+MYbpxrOxrBeTMRXmjvU+7/oQxjctUVi8kCHFYcwX8BupF/Yz0H7RFDkjVoh6brQBgfjyd7XuIp+XOaougug8luUaf2MXVIFL0iyU98ao9QhYLfODa/UCZ2Jq0QIHA8aUDjDibG93wB2AzPoIJHJmBvcHKc7i2ooKFrXt2EZtIcmsya/9CYaIDjsG57c7s3RdK71baG3vyP4F5pT2RsuDuky2hhUnzg7PPnKtCP6Ld/5sbCn2H4oYZ36SmrU0AB43DqYG6A07wjYA54soyQEhqsXtjFWHjh2n0W0NDng8WW3/QYvK4QiTJrrpV96ym6BTvCdrrNuO2R3hqE95g1tAxaEzdh9+IiyBVkpt4ReQLHclSVDhKl1uCq2xUwQdNTQlV/YxEYCpWj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:15:13AM +0100, Kiryl Shutsemau wrote:
> On Mon, Aug 18, 2025 at 11:58:03AM -0700, Joshua Hahn wrote:
> > While testing workloads with high sustained memory pressure on large machines
> > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > Further investigation showed that the lock in free_pcppages_bulk was being held
> > for a long time, even being held while 2k+ pages were being freed.
> > 
> > Instead of holding the lock for the entirety of the freeing, check to see if
> > the zone lock is contended every pcp->batch pages. If there is contention,
> > relinquish the lock so that other processors have a change to grab the lock
> > and perform critical work.
> 
> Hm. It doesn't necessary to be contention on the lock, but just that you
> holding the lock for too long so the CPU is not available for the scheduler.
> 
> > In our fleet, we have seen that performing batched lock freeing has led to
> > significantly lower rates of softlockups, while incurring relatively small
> > regressions (relative to the workload and relative to the variation).
> > 
> > The following are a few synthetic benchmarks:
> > 
> > Test 1: Small machine (30G RAM, 36 CPUs)
> > 
> > stress-ng --vm 30 --vm-bytes 1G -M -t 100
> > +----------------------+---------------+-----------+
> > |        Metric        | Variation (%) | Delta (%) |
> > +----------------------+---------------+-----------+
> > | bogo ops             |        0.0076 |   -0.0183 |
> > | bogo ops/s (real)    |        0.0064 |   -0.0207 |
> > | bogo ops/s (usr+sys) |        0.3151 |   +0.4141 |
> > +----------------------+---------------+-----------+
> > 
> > stress-ng --vm 20 --vm-bytes 3G -M -t 100
> > +----------------------+---------------+-----------+
> > |        Metric        | Variation (%) | Delta (%) |
> > +----------------------+---------------+-----------+
> > | bogo ops             |        0.0295 |   -0.0078 |
> > | bogo ops/s (real)    |        0.0267 |   -0.0177 |
> > | bogo ops/s (usr+sys) |        1.7079 |   -0.0096 |
> > +----------------------+---------------+-----------+
> > 
> > Test 2: Big machine (250G RAM, 176 CPUs)
> > 
> > stress-ng --vm 50 --vm-bytes 5G -M -t 100
> > +----------------------+---------------+-----------+
> > |        Metric        | Variation (%) | Delta (%) |
> > +----------------------+---------------+-----------+
> > | bogo ops             |        0.0362 |   -0.0187 |
> > | bogo ops/s (real)    |        0.0391 |   -0.0220 |
> > | bogo ops/s (usr+sys) |        2.9603 |   +1.3758 |
> > +----------------------+---------------+-----------+
> > 
> > stress-ng --vm 10 --vm-bytes 30G -M -t 100
> > +----------------------+---------------+-----------+
> > |        Metric        | Variation (%) | Delta (%) |
> > +----------------------+---------------+-----------+
> > | bogo ops             |        2.3130 |   -0.0754 |
> > | bogo ops/s (real)    |        3.3069 |   -0.8579 |
> > | bogo ops/s (usr+sys) |        4.0369 |   -1.1985 |
> > +----------------------+---------------+-----------+
> > 
> > Suggested-by: Chris Mason <clm@fb.com>
> > Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > 
> > ---
> >  mm/page_alloc.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index a8a84c3b5fe5..bd7a8da3e159 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1238,6 +1238,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  	 * below while (list_empty(list)) loop.
> >  	 */
> >  	count = min(pcp->count, count);
> > +	if (!count)
> > +		return;
> >  
> >  	/* Ensure requested pindex is drained first. */
> >  	pindex = pindex - 1;
> > @@ -1247,6 +1249,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  	while (count > 0) {
> >  		struct list_head *list;
> >  		int nr_pages;
> > +		int batch = min(count, pcp->batch);
> >  
> >  		/* Remove pages from lists in a round-robin fashion. */
> >  		do {
> > @@ -1267,12 +1270,22 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  
> >  			/* must delete to avoid corrupting pcp list */
> >  			list_del(&page->pcp_list);
> > +			batch -= nr_pages;
> >  			count -= nr_pages;
> >  			pcp->count -= nr_pages;
> >  
> >  			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
> >  			trace_mm_page_pcpu_drain(page, order, mt);
> > -		} while (count > 0 && !list_empty(list));
> > +		} while (batch > 0 && !list_empty(list));
> > +
> > +		/*
> > +		 * Prevent starving the lock for other users; every pcp->batch
> > +		 * pages freed, relinquish the zone lock if it is contended.
> > +		 */
> > +		if (count && spin_is_contended(&zone->lock)) {
> 
> I would rather drop the count thing and do something like this:
> 
> 		if (need_resched() || spin_needbreak(&zone->lock) {
> 			spin_unlock_irqrestore(&zone->lock, flags);
> 			cond_resched();

Can this function be called from non-sleepable context?

> 			spin_lock_irqsave(&zone->lock, flags);
> 		}
> 
> > +			spin_unlock_irqrestore(&zone->lock, flags);
> > +			spin_lock_irqsave(&zone->lock, flags);
> > +		}
> >  	}
> >  
> >  	spin_unlock_irqrestore(&zone->lock, flags);
> > 
> > base-commit: 137a6423b60fe0785aada403679d3b086bb83062
> > -- 
> > 2.47.3
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

