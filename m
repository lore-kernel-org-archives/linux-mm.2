Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7983ECD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 01:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76CE16B0005; Wed, 20 May 2026 21:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744AE6B0088; Wed, 20 May 2026 21:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681A36B008A; Wed, 20 May 2026 21:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5616B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:05:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C08040479
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:05:46 +0000 (UTC)
X-FDA: 84789634692.17.1CFDD02
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 50A401C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:05:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QR5Fl/3T";
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779325544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1MTLIIAhH9UvgwVNHsziM8OkcgXCZAnwRaysqlVF3I=;
	b=rpSjPdlrhw71F2qyoy8a02hyGABbuhlFKo3Uby2riFASjHJVj9WE4xe4/SdirfYNi2ZspC
	7FRmSGs0Dv+yIcgeGW27MaE0GbwiCFojYQpwd1derYM3PBXV4onoscx+iUqWJPAQkgpN7L
	KejYuzESvuVawB2m4iJJ7aWoyANHRok=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QR5Fl/3T";
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779325544; a=rsa-sha256;
	cv=none;
	b=HYz9r0DTlUsXY2r0Ka+7L2Ipr+T3P1S/leI/Wry52gIMDNgtqyFpDt0KSO9/5k0DJ/iYEV
	EoTHy3irA/VS6zOWcma58PsFG4DnWr2JcChmDU/4QHKdTtqd4T1ZKsMx28RwWeeT2ittxp
	toOUNXiQQOIwYqDvN/N2T6NHf3CPmFE=
Date: Wed, 20 May 2026 18:05:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779325543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H1MTLIIAhH9UvgwVNHsziM8OkcgXCZAnwRaysqlVF3I=;
	b=QR5Fl/3T42AWhOS0T14rdTy6QqS8+DeaDevCSsA/S9l9kCVGm82RVcfZLwxJ8LcOTqRN8+
	bvoBSGwy7CVoFcdQEMyEosrRn4RpEE9HUBytIp70iBKeCCNH8EopGTiB+orK8XIm2zmcmx
	dvs5Fq5UTZhlkzR5d2hbSjRCvLigMQw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 4/4] memcg: multi objcg charge support
Message-ID: <ag5Z9uIMoXpr3rLP@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-5-shakeel.butt@linux.dev>
 <4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4xxfzbzzms1nk1p498qeghzt9j5mbwhz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 50A401C0007
X-HE-Tag: 1779325544-763182
X-HE-Meta: U2FsdGVkX18LIipeZyxX4Wo4tYZ0RrcMDKgSs2GwMi+LBV0r00oX2psFHioLA5DaLNo6QoCSFGwxKnOjrXrGn5xnlIdnf3pVZQa6sY7c/WVcWxReKBQUn+0/UFsmulqV+a/xxY6FfduXpX20lR92RT4g8ZiAxgxdUWJwvxCB/0hXKf98ZSWV3U+sbl1nPKyZkdA1j2koxWJGv68qu0BVJreAZzs0WNdWNrTvY56OHjWqZNtsdz2q1rKud0PhdmGlqxJqiUJk60i1S2a9RNosJxcSKvumNmGS4PFtPi/PlbI1584ZGQ4XXXp+78llfNlDKUQfFUsFzHc5gzG4EULGrRLVIRDqshGU6SRRXpx4YMYrOR7Aw5x6+6Gv0rXY9dvkkNpA7/TwoqUv1QEWz74RDTvDiSDHLotJejeIQnzznBO2HzNrBOtU2jcqXumn9iQIbukNOKE2RlEen4b1/xiE6gjU1n7MkayHxWXVHfKdKvjLn6bGotgVaxsD5ILABBrGk+OPQw7kqU0mMOLQI6qGLE7Scwix6QkQj9xZrAkUMIjd0muD2XXKRTyhi6/dLq7WvWu9CdJzQbIBVrVXN3cHQY5nS3n6AoU0wMNOUQ9KjmWd09e5NZS8pyO0zSnzNrwsr/RuEZs2mo2UiTS+rRnAJkXCg/Q4Q//QHJ9t7SaBqIhrkVNBysKaqwaTCY0Bpgz12qacRfBGvlEFhcU8xaoTFYsfgK2NQvpEvgpNtM7nRGxJBOXIOB0xP4IiWDXnL2gEyZ9hxi1r8D7Z869OcOPORexEkIxZxoM3TcsJtN0TjEl7gv5h3CC7VBAlDShk9cxdPeTTudV2eOfTWrUW1d7QLXZw75BRPNQL3eLk6TauUVTqS8gjTWfCLIMZfYMGzgBA1z6lxXzapqBXDhLxxNDXb1tMn/om6J8cBIK6VSr309BL+Ebag3BXJXLDJizqyZS9egPIvKDAGpUsOD5h/Xl
 0Vq4uBvO
 Z9YJsF1CzVA+97JbHbrvy+TTGcA2T/b8KPY5snae+DJxPf2y5p5xQfimFtJBJGCIIXE8Prg1hOwRIluwtj5xkDCXHH7L46Icf/QIy9BRpPR4Wle6yTUDWC/0Vkb5KC5xroWv9KQ3/rOkphH/JPlC1T72KHTq15nDwJVQCgbhTrSN/HFLizhOpSBL944yu7zYsIToV+XL/PoMfZOS6fzYb7r3X35Zx50zgq9JdtXtd+2S+NJDAzAenYB3pNqCmLqBg85Y+OotwwSHTIwXOJFg86q0mzg8AV/uXKCfFH1/6HxwboFZ4gTGxP4kvJhbudgjWpwiHVrNm4mOjuHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 06:35:30PM +0900, Harry Yoo wrote:
> 
> 
> On 5/20/26 2:31 PM, Shakeel Butt wrote:
> > Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> > per-node type") split a memcg's single obj_cgroup into one per NUMA
> > node so that reparenting LRU folios can take per-node lru locks. As a
> > side effect, the per-CPU obj_stock_pcp -- which caches exactly one
> > cached_objcg -- thrashes on workloads where threads of the same memcg
> > run on different NUMA nodes. The kernel test robot reported a 67.7%
> > regression on stress-ng.switch.ops_per_sec from this pattern.
> > 
> > Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
> > nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all
> > slots on consume/refill/account, prefer empty slots when inserting,
> > and evict a random slot only when full. With multiple slots a CPU can
> > hold the per-node objcg variants of one memcg plus a few siblings
> > without ever forcing a drain.
> > 
> > A single int8_t index records which slot the cached slab stats belong
> > to; the stats are flushed on slot or pgdat change. With NR_OBJ_STOCK
> > = 5 the layout (verified with pahole) is:
> > 
> >    offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) = 8B
> >    offset 8  : nr_bytes[5]                                     = 10B
> >    offset 18 : padding                                         = 6B
> >    offset 24 : cached[5]                                       = 40B
> >    offset 64 : (line 2) work_struct + flags (cold)
> > 
> > so consume_obj_stock, refill_obj_stock and the slab account path each
> > touch exactly one 64-byte cache line on non-debug 64-bit builds.
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> > Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Tested-by: kernel test robot <oliver.sang@intel.com>
> > ---
> > @@ -3350,19 +3405,45 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> >   		goto out;
> >   	}
> > -	stock_nr_bytes = stock->nr_bytes;
> > -	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> > -		drain_obj_stock(stock);
> > +	for (i = 0; i < NR_OBJ_STOCK; ++i) {
> > +		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
> > +
> > +		if (!cached) {
> > +			if (empty_slot == -1)
> > +				empty_slot = i;
> > +			continue;
> > +		}
> > +		if (cached == objcg) {
> > +			slot = i;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (slot == -1) {
> > +		slot = empty_slot;
> > +		if (slot == -1) {
> > +			slot = get_random_u32_below(NR_OBJ_STOCK);
> 
> It would break kmalloc_nolock() because _get_random_bytes() uses a spinlock.
> perhaps prandom_u32_state() should be sufficient in this case.
> 
> Is there a reason why it uses random eviction, unlike multi-memcg percpu
> charge cache?

Oh I didn't know and actually we are already using get_random_u32_below() in
refill_stock(). So, it need fixing as well. That would be a separate patch.

I will explore prandom_u32_state().

