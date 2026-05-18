Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767CCCD4F50
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23206B0005; Mon, 18 May 2026 14:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3896B0088; Mon, 18 May 2026 14:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8C76B008C; Mon, 18 May 2026 14:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89CFB6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:32:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39DFF1A07F5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:32:41 +0000 (UTC)
X-FDA: 84781386522.01.530FDAE
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5BB1140010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:32:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oMay0ixZ;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779129159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXHUYRMce7ARIc5s4WnL47A3d01wGcNanUodNfVijnI=;
	b=1OHwifXHop4uVF5P3ItFwzEc9af9Ii3seExph7m3lB7Q8AwbceKEt3/EwA+0XSt8u/FbDv
	YxM5OF5WS5Vf5IcLiolaCkX6xR4BKA3tecfBmm8pecFH/Ip9vmHdzWyjjlvKdU+Ghx4dnl
	0FVgfb3AB5Rtt2wwoC8WnSDaLD0CuMM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oMay0ixZ;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779129159; a=rsa-sha256;
	cv=none;
	b=0CQm7rfNbWvsjl1BBdeDU2U4Fby+/D/zQWo/XPnkLq9qmLqGEwedtwjfHlmouTl/L9155k
	7qp2/3dKLsyBeMVxoCBEF7vZrpDJfZ/AUsYYB86884WLVYfohJbtanNKRRpdmPFdidD3KD
	OO1TT4TnKQaImn28ybaJyNXwdQV7DMA=
Date: Mon, 18 May 2026 11:32:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779129155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FXHUYRMce7ARIc5s4WnL47A3d01wGcNanUodNfVijnI=;
	b=oMay0ixZ8rUB5vFEuLI8LeuR0E7rii2KoCUvRIRwi9ahQcInm6XJsG/kmSCF3JIPGhEOij
	df40rL6/I/w4/poq/oF9Ydo/WfNP9U/69c7BkPH3Fv0HnP/eYUg0ym+ycUfYXVIsfFdFva
	1GYmVy1PqokvefTdam4LyFdtnr1wlOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>, alex@ghiti.fr, joshua.hahnjy@gmail.com
Subject: Re: [PATCH v2] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <agtZWXhtXSfLQ4GW@linux.dev>
References: <20260517194308.952655-1-shakeel.butt@linux.dev>
 <ags818dAvMjylVmP@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ags818dAvMjylVmP@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5BB1140010
X-Stat-Signature: nbhpdxt666r54wf8nhk7hboao11wxm3y
X-HE-Tag: 1779129157-104868
X-HE-Meta: U2FsdGVkX190sFKWExwWVbir7EBPeVeNR1r19aA65jdmVCeR0gH38s1oy4dnydI3AMZ8JyUpZzWKDygvAfBKLz0ay1xlGHIiDJCErmC51nH+NNdtgNC6N0kH/xlSjWDx/gUaLbMqlovoK50LQB6kM7z0G06Zxm8iBwDLvdO30osQXl2M5w+5oDGP1oM9/k0hDzSuFaR8yJ+JZ09lGI4ippOZxMUi96dm1Z6/ugm/4k0JpgePTDPJ2w2KAxzHSGD4XcGaat1QRxj2/+dcJ82laoERZ2rQCbWV6/mpyNscUnZPPnV6pevAQr0xBWL+X6ELx2ICw4+VK9E6WZ3ms9RD+SooxO/K5cpqxpqNDz3/UoLJs4c00J34qV83Vb2e0bDIUHfPCwArR2lwH1G2yStQpzB1/e1JxvsthV35tKOV728wkH0eTYOK5JNSNJ2DSSvgRMSV36hQLRqzCwJDF7lP1v5B8bwSskterO0ZDN1zDGjNRAAJE2Q9mMUDs6dXYXfKKDmsXWV+DrLDETs7NmiS3JdfIQR/OnQ/AKSvb18Kgb26Rttx/6fXyEgkDG2yGsJqD11rgoZ2djP+7gQOwx3C7mXvfpSDnZCcyjZ0U3KL5FDW7JcbaEFWjd8jdacMzWES0jOmyk/YQ01XW0/o7AhSA+cW00U5HvMSVX5sH0hSAptn3rCsS/TzqJ5VapN05/kldXYpoRKbW5M0TwdOP++w3ig3GVbNsk8Drs78oUEXNqi4KwpxU5N7sZAPaAHwNWyiwEpmohFLA3J/ITl3OMbLBLiD0aOWTz7FCHHbWHPkDUrgL7hhyHsjfDOwrXJRaIaOm51g+7c/GRCJ1J4UiEjq/TdmalZhAUQX7O3UKzJCJ8CPlIppDcBqJfvFxRHvZQ6LM7c+Acgu75Q4LKMzdh6/HoB6rSJS6QMs3HiX0Ocn3mhfOm0pOCI0mT6HOSaQ58tJxRTwLnyWg2vrGbRRK0s
 z+WifpYe
 SavUT4STX7vkdp7LsIKHDJTdYwRmh7LdUNVVCupgKZ9zAWVXXxfv2h2yaei87givhVIQ3cIgpRE5EqddOnOuh64ziObJc71cBaKkmFl+kfavpPJVS762241MhFtB7N8fjR+lkZd9aUG2lvLzRxDHcJ9KBkODuKBc1Xzo8ud5tf93IuJ/IcZVyKYPfzYFJ/ENz/+Q4FcbqpGeyN7VSAQhspnkBobcCg3ye56jAS0oxbzZ8mNs0RVTldtvtEAYKvbv8fJJDXf/vGcoPgUeKnatPLdFz8+dyl1MvxttaFIh46qv8LZSU5q3iE9C7Z+j8CRrMoUb+ouHBRNm3RivJtSE4Yn1aXC5HXrjCr1YID+ct6jsu29MFPHUcNOt8PweEK69BjHri7uL+iciuyx6GyEpWdCJEnumfz+BA+lrRabbV7D1keSFFqHk+biWfRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 09:46:04AM -0700, Shakeel Butt wrote:
> Cc Alex, Joshua (since they are working on making per-num kmem accounting work)
> 
> On Sun, May 17, 2026 at 12:43:08PM -0700, Shakeel Butt wrote:
> > Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> > per-node type") split a memcg's single obj_cgroup into one per NUMA
> > node, but the per-CPU obj_stock_pcp still keys cached_objcg by
> > pointer. Cross-NUMA workloads now see a drain on every refill and a
> > miss on every consume that targets a sibling per-node objcg of the
> > same memcg, producing the 67.7% stress-ng switch-mq regression
> > reported by LKP.
> > 
> > stock->nr_bytes are fungible across per-node objcgs of one memcg.
> > Treat the cache as keyed by memcg in __consume_obj_stock() and
> > __refill_obj_stock() so siblings share the reserve. Compare via
> > READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
> > the rcu_read_lock contract on obj_cgroup_memcg() does not apply.
> > 
> > In the same-memcg refill path also fold the incoming objcg's
> > nr_charged_bytes into the stock; otherwise sub-page residue
> > accumulates on whichever sibling was cached at drain time and
> > obj_cgroup_release() silently drops it, leaking up to nr_node_ids *
> > (PAGE_SIZE - 1) bytes per memcg lifecycle from the page_counter.
> > This issue was reported by Sashiko.
> > 
> > Update the now-stale invariant comment on __account_obj_stock().
> > 
> > Qi Zheng built a specialized reproducer [1] for the corner case and
> > confirmed the fix.
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> > Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Debugged-by: Qi Zheng <qi.zheng@linux.dev>
> > Tested-by: Qi Zheng <qi.zheng@linux.dev>
> 
> Sashiko [1] reported two issues. First one seems benign but the second one is
> real. However I think we need to take a step back and rethink on how to solve
> this issue in more future proof way.
> 
> It seems like Alex and Joshua are working on enabling per-node kmem accounting
> and that would need accurate per-numa association for each per-node objcg.
> So, checking objcg->memcg in consume and refill, would go against the per-node
> kmem accounting.
> 
> One way to fix the regression and be future proof is to follow the approach we
> have for memcg_stock_pcp which is multiple per-cpu objcg stocks. We will need to
> test it more and depending on the additional code complexity, we will need to
> decide to backport it to 7.2 or not.
> 
> 
> [1] https://sashiko.dev/#/patchset/20260517194308.952655-1-shakeel.butt@linux.dev?part=1
> 

Previously I had prototyped the multiple per-cpu objcg stocks (when I worked on
multi-memcg percpu stock) which I just rebased on latest linux-next and sent [1].

That patch is additional 100 LOC. For upstreaming, I will break it up into at
least 4 patches. However I am questioning about backporting them to 7.1. One
thing I can do is fix whatever sashiko is asking for and send v3 which can be
ported to 7.1 and then later for 7.2+, revert this short term fix and send out
the multiple objcg patch series.

Any concerns?

[1] http://lore.kernel.org/agtPMpQK2jXdQAY4@linux.dev



