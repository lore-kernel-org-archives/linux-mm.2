Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C62CD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 02:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AED6B0005; Tue, 26 May 2026 22:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BE56B008A; Tue, 26 May 2026 22:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1615D6B008C; Tue, 26 May 2026 22:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 056B66B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 22:17:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84F3D8D29D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:17:10 +0000 (UTC)
X-FDA: 84811587420.11.F4228E7
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4EC82A000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:17:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779848229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5uPMD/hT+PibOFjxB0sOUpuoOjVivs2Y3JIYeIpc10Y=;
	b=qLEsLV8zxUzPQDwbgRJO2z+fBQZeWiLLtOttvgh+EaqYQGMQY6piBmgxp9r4yq4oJs8dLP
	2LAoznMqdV7NxGoArUPsgHUk9zq/Xj/USkTM+FoN/D+v9mxPVm/dVuFhEq2ZzBi5LaL+qb
	cMO1HUp9mckCDpGxQjxGeeMkse37Akk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779848229; a=rsa-sha256;
	cv=none;
	b=1ZHwamf4PbGCCxeRDzZpc2HGElJT6XA/gPiRvVQNV5WNJ2XT82SUfwlulvHe0HAXCWz284
	7NI2cjpNOiKPtjx+vR1NBtdwb0VIx/y8DBzPq3nvUMKNT5WJuCjo4lGKjrKPkwKnV+xUOg
	9KOVhDXQYfweAJu3cUe4HkNW2xkzDqE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 May 2026 11:17:05 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 27 May 2026 11:17:05 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ahZUIQHreEaqd6z4@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-5-youngjun.park@lge.com>
 <ahZMHmMbhnNPspQj@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahZMHmMbhnNPspQj@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EC82A000D
X-Stat-Signature: a1s3d8tkj8wxz9jxs93ednkshpdmyw89
X-Rspamd-Server: rspam06
X-HE-Tag: 1779848227-581958
X-HE-Meta: U2FsdGVkX19cz4TQbOyORdusBVFzYj/vJACKZJtk8FsqP7p+xuMDUFys4tK8huGo8EPRNINfne83d36eyvSK0vOPJBZMVoBnQqvLGPro2sWGsXqi0GLBjfRWbTWjqlAQSA45gw7y5Q8yTgSCDyX628VX4fuVZjthYz2Zn49HQTKnvXvPQRSMlwz1AMDdBWej/m0dW877XZhwz6FzI4lIvEhlSUHiDXeHkCmjf2yFzkFGCF06OOUx8qrhc5xx/T3ZxYeF7cg1Sk7fHuPhr0dSbmu3JWMHrJuIRZK2mNA3ySvAWThIukfhZkOQcEFOaPKFIBi0vddAhqESvaER/l7vk+bpzxw/rNI3tYt9z7rgU6KTU5obxPBl5UV7+c3FrXkQirpnqUOTELJwv/ijGnBA3vBQa3YeHiWzU8RxnkXFnPEAh/wb5c6Lla6wUYvraBctIpuxJEKqWs8DcnQsILYL15hfkjTz6/17KuFg+JOSxfX9buhwKpc996Jxr+4aT+7CSOfICxY/2orB+X04MfVieFXGrxo+SPKYOYUUAXGsAbqlzlF5XjLC6+n6NEVvTlRLS3qhK2XeusaeKOYpXfK8od0MUiIvcoCVsezpdeSr75DZWbK2J21cDXHjypriicHBWwahByD3co4P95yyJ0GwWVm6kN1jKiMPNinrN0jL5LXCF+cypb+Eq2pw3U+c51qi54MNsyJ3sGGChlc7yrQw4WT2dzNX7otv2Em3vb0gI7biRUJICbsbDu9Mxw5/8VjPIxe14szZNUbWCefVHAxi2IUj+8QfM+tFnd3ZY7m83vDFOAp89nQwQckxnvLb1uNNeioVb5avOfwfB8AKFYThPZqEbzl3YisKWTSYHB2i392/ieavYKMZ1GqqrROi6EWPXsLoG8nL8ZwPS3Cz/0hryvBn6EdNm7LRrC2VJeZGY9gHiXQfH+DXZbeY2JVzZcD14GRTTmWNKZqS9QnsocU
 m9ScfZ1z
 tDitLnHgWtr/2ywC3wU62zDWa0KpzRI+vhVmFDdugMRyA7SjACJudYxwPCgJtUbcgvJDEarVi4u6hu5umz0cO2xhpSqCuRsLi0NeUNTwC61w54vXc+F9mjlWXt4QdxAGGWi+z5izmuAs0Lk5HneQvZaLvKj782EJivtzgLogNyo4+1IChqbQriXrFPUKlKqjcQw29Sfnr0xpUHdHy8PWcps1AZmc1lc86hV0Wu6hYu0Zkt1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:42:54AM +0800, Baoquan He wrote:
> On 04/21/26 at 02:53pm, Youngjun Park wrote:
> > Apply memcg tier effective mask during swap slot allocation to
> > enforce per-cgroup swap tier restrictions.
> > 
> > In the fast path, check the percpu cached swap_info's tier_mask
> > against the folio's effective mask. If it does not match, fall
> > through to the slow path. In the slow path, skip swap devices
> > whose tier_mask is not covered by the folio's effective mask.
> > 
> > This works correctly when there is only one non-rotational
> > device in the system and no devices share the same priority.
> > However, there are known limitations:
> > 
> >  - When non-rotational devices are distributed across multiple
> >    tiers, and different memcgs are configured to use those
> >    distinct tiers, they may constantly overwrite the shared
> >    percpu swap cache. This cache thrashing leads to frequent
> >    fast path misses.
> > 
> >  - Combined with the above issue, if same-priority devices exist
> >    among them, a percpu cache miss (overwritten by another memcg)
> >    forces the allocator to round-robin to the next device
> >    prematurely, even if the current cluster is not fully
> >    exhausted.
> > 
> > These edge cases do not affect the primary use case of
> > directing swap traffic per cgroup. Further optimization is
> > planned for future work.
> > 
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index d5abc831cde7..8734e5d26b08 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1352,15 +1352,22 @@ static bool swap_alloc_fast(struct folio *folio)
> >  	struct swap_cluster_info *ci;
> >  	struct swap_info_struct *si;
> >  	unsigned int offset;
> > +	int mask = folio_tier_effective_mask(folio);
> >  
> >  	/*
> >  	 * Once allocated, swap_info_struct will never be completely freed,
> >  	 * so checking it's liveness by get_swap_device_info is enough.
> >  	 */
> >  	si = this_cpu_read(percpu_swap_cluster.si[order]);
> > +	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
> > +		!get_swap_device_info(si))
> > +		return false;
> > +
> >  	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
> > -	if (!si || !offset || !get_swap_device_info(si))
> > +	if (!offset) {
> > +		put_swap_device(si);
> >  		return false;
> > +	}
> 
> The whole patch looks good to me except of one nitpick. Is it a lille
> cleaner with below tiny adjustment?
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2864cd8c2da9..cdf453bf6b80 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1359,15 +1359,12 @@ static bool swap_alloc_fast(struct folio *folio)
>  	 * so checking it's liveness by get_swap_device_info is enough.
>  	 */
>  	si = this_cpu_read(percpu_swap_cluster.si[order]);
> -	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
> -		!get_swap_device_info(si))
> +	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
>  		return false;
>  
>  	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
> -	if (!offset) {
> -		put_swap_device(si);
> +	if (!offset || !get_swap_device_info(si))
>  		return false;
> -	}

Thanks!

Your suggested version of code is simpler than privious one.
I will apply it.

