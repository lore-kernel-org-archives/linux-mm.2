Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D25BBCD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 13:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93B66B0005; Sat, 30 May 2026 09:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49746B0088; Sat, 30 May 2026 09:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C597B6B008A; Sat, 30 May 2026 09:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4A8A6B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:32:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 661314038E
	for <linux-mm@kvack.org>; Sat, 30 May 2026 13:32:30 +0000 (UTC)
X-FDA: 84824175660.11.3241228
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9E0A480011
	for <linux-mm@kvack.org>; Sat, 30 May 2026 13:32:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9yE5s8P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780147948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuZmZ9O6Ey6eBcqbPXxSPn0Ltn/BFozmA0B78fw4jlU=;
	b=pqEDJyvaY50LAR7mnNNbkBPe4+Sh1HKnMCYJESCMUnyErWWDHFL6lv9JNMeH5TsDCCcopv
	tkyqJjfrWDmPSPiTc+YjJr6YVQGZashjCj68WK+eHzbMkmcWKmJNcGFTUJsUQI/ZTd8vDz
	7kXV5MLo14IApr+l69lPFoXPdhNPNvk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9yE5s8P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780147948; a=rsa-sha256;
	cv=none;
	b=QnQXg6z+edg/CfBJR3Tt8oNGHKfKREjApr0APp/LMaYrugVTLWs/PUDeqlx7MGFxFY+jjT
	CtBGRNjTLB+cKIa5m9oAxDfTALnbujx2XXSNFQiUoneF3dl12XyhsFVJUZVF8HJG+mR3WE
	N0+V2+3wsySpylG/WuU9r+j1CAmodew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C03E445C6;
	Sat, 30 May 2026 13:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF5B1F00893;
	Sat, 30 May 2026 13:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780147947;
	bh=EuZmZ9O6Ey6eBcqbPXxSPn0Ltn/BFozmA0B78fw4jlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K9yE5s8PceHzNMT8nnsiASvNt1Y5CofrO0mbuoqdI2rhoS9d4/LZ3XOIoaDBUIEKd
	 cOdCHdt94NlHcO2DldxqADeF4juHmG07FfxoXgPYqv+L+c3UKtENkyVQVgLD7+WDSp
	 GaYJLJP7BQKygtQ9No5ixgne66Jvh1Keb8O8JFlX1TQjNBscu7X8mH6qJn2Hiy2YVp
	 L6QeQLoe0WpVSLC+lvhG2MpCU25nhZ9bkrK3dQEHuNwdwBlEGKK7XYuDvT6JFZ1oXA
	 Rw2VVmISJTe4fYTVHCnv4roLOgGquUBf7rpBboca8ZXTnNR7QVBUKJPJXC3tX74s4S
	 00djM3dh3d+TQ==
Date: Sat, 30 May 2026 15:32:19 +0200
From: Dennis Zhou <dennis@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org,
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, mhocko@suse.com,
	vbabka@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Message-ID: <ahrm4x2ubbjs4An1@palisades.local>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan>
 <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E0A480011
X-Stat-Signature: 4wtecjus8hjew6bf3t9hekfkb9db7iha
X-Rspam-User: 
X-HE-Tag: 1780147948-174944
X-HE-Meta: U2FsdGVkX1/7/4y64XYlmyJa6NiNWqcimJ2l/SlbkKSQuBo8zKVSYORGUk/m+n7NqGu/rM2ZQ4j6I6wxlNbYuNZI9NcMtR4xHKWG4LISXBF4dBFgZava2BOFIjdoQsDzVEn3XQczE+HL3vrFMCK4/9TvNSkT3h4vEfxc6wcoBvHGEG/7XMtxoas7dTtida9uoxVGQbiXG8YezXgoWSoZmtb5JRbay6f+8vXtXikxzSowHoVWQMs0TFKAsITIFsYpXjzyZbenIJmbSlXXeJHpGhdym0iiQYoVrNWe1zWQvBzRzknVCSr1h+IRSELKDhAJmo4Vu3g2ZxzsqeSYPxSegDuDKOAgSR0LRnHlfNyzuZBdOsVUyHM/zH5t/K89gqFudf0FRZidZnb+HWaHFvOOvayXd968MM3iFoIsz1u4sYQbmV8vha4Mi8+zEUl8JLL1EE2qIHZ7kEPCzkr4wXg+QbBdxl5lOYVRiz7ITUu98/sxYr/jQs28vqXUt9ty55KFLcN3bGEryMOezDaNal5BI/H3fRBeHB+3feoeJKymYErJ97djbBSibZjBVSy1SIEPUzKuJeBYuXoPN0X84Dk2ydLKj2y2h/l8/6f+KIlFxkNAEo9fAqjrIltkXnpCTVBK/CTQGcyUj4QjtzqIa7d/qf1Ou5/NuGMTSVleBuY+QLiaabFVE/2yxjoSWmmoCFJfaIcIbA6rRNSH9AM1HLvcDLPGCB9qeas17SIQJD42oDqD5CeZaX83I4JfLSDQOHOXoyAO+hp84NfV1JpQxcoF0DMBmNu6xeSgwIpfUP1o4D88JLC4EKPtaslo8BW/tWrVt10doLAggk/YGzgcro4vw2Kba5ZcpjV4eB0sDTcJ5G6NrE6WQAf1VAIIk87YmkcWwlFQGfOBnSR+cEL9l8V/86AFghLfULKoXbTXZ3uXEqftxa5UXgw4o2U5OkD++nQPVvyK6K4M9BAyXFQeWPx
 QKfVDupN
 0U6RWce/R+jL43C5tXRKifro1cPfKhfqIS7pqYNn/wrHsMz2scwcWp46huSzMPAaeZTO5K8rI2Qlfjir21LD0/atLM098xzOEq1n6puJdYwJ5nKaCgVSr7FO0rJjIUBo5/6dCE3rQ58YdtwiL8vsM37m9wfDxTHGvJ4BBKJINjOi6wYin8gWpGO2EW0XMAxI6G0v8P1b7zdkj5MZDwJECtj4cPMzWnB2waiMtqiujuU64pAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Sat, May 30, 2026 at 08:47:34PM +0800, Kaitao Cheng wrote:
> 在 2026/5/29 17:38, Pedro Falcato 写道:
> > On Fri, May 29, 2026 at 10:25:28AM +0100, Pedro Falcato wrote:
> >> On Thu, May 28, 2026 at 09:29:16PM +0800, Kaitao Cheng wrote:
> >>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>>
> >>> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
> >>> passes it to the backing percpu allocators. This preserves GFP_NOFS and
> >>> GFP_NOIO for pcpu_alloc_pages() and for the initial pcpu_chunk allocation.
> >>>
> >>> However, the chunk creation and population slow paths also call helpers
> >>> which do not take a GFP mask and perform internal allocations with
> >>> GFP_KERNEL. For example, pcpu_create_chunk() calls pcpu_get_vm_areas(),
> >>> and population can allocate temporary metadata or page tables while mapping
> >>> backing pages. As a result, a caller which explicitly uses GFP_NOFS or
> >>> GFP_NOIO can still enter FS or IO reclaim while creating or populating a
> >>> percpu chunk.
> >>>
> >>> This is problematic for callers which use GFP_NOFS or GFP_NOIO because
> >>> they are already holding filesystem or IO-path locks. If free chunks are
> >>> exhausted, the percpu allocation can take pcpu_alloc_mutex and then enter
> >>> unconstrained reclaim from these internal allocations, defeating the
> >>> caller's allocation context and potentially recreating reclaim lock
> >>> dependencies.
> >>>
> >>> Wrap chunk creation and population in a scoped NOIO or NOFS context when
> >>> pcpu_gfp has the corresponding constraints. Leave ordinary GFP_KERNEL
> >>> allocations unchanged so they retain full reclaim capability.
> >>>
> >>> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> >>
> >> I assume you _did not_ observe this in production? As in no reclaim path should be
> >> insane^W daring enough to do pcpu allocations?
> > 
> > Oops, I mixed my issues up. This is purely a GFP flags issue. A quick
> > "git grep alloc_percpu_gfp" shows that the vast majority (all?) callers are
> > using some combination of GFP_KERNEL or GFP_ATOMIC + other GFP flags, but no
> > NOFS or NOIO as far as I can see. So you probably did not observe this?
> 
> Right, this issue has not been observed in production. It came from a
> question raised by AI code review, and after carefully reading the code,
> I found that there are indeed some synchronization concerns.
> 
> Here is one example of the scenario [PATCH 1/2] is trying to address:
> 
> blk-cgroup after 5d726c4dbeed ("blk-cgroup: fix possible deadlock while
> configuring policy"). blkg_conf_prep() now serializes against
> blkcg_deactivate_policy() with q->blkcg_mutex, and blkg_alloc() was
> changed to GFP_NOIO for that reason:
> 
>   CPU0: blkg_conf_prep()
>     mutex_lock(q->blkcg_mutex)
>     blkg_alloc(..., GFP_NOIO)
>       alloc_percpu_gfp(..., GFP_NOIO)
>         -> if percpu chunks are exhausted, chunk create/populate may do
>            internal GFP_KERNEL allocations
>         -> direct reclaim / writeback can issue IO to this queue
>         -> IO waits because the queue is frozen
> 
>   CPU1: blkcg_deactivate_policy()
>     blk_mq_freeze_queue(q)
>     mutex_lock(q->blkcg_mutex)
>       -> waits for CPU0
>     ... unfreeze only happens after q->blkcg_mutex is acquired/released
> 
> So the concern is that the caller deliberately uses GFP_NOIO because it
> may hold a lock which can be acquired after queue freeze, but the percpu
> slow path can temporarily lose that allocation context. The failure
> requires the slow path (new chunk creation or population), so it is not
> expected to be common.

This is likely just a miss for [1] where we switching to
gfpflags_allow_blocking(),

This seems like it's just a miss from [1] where we switched to a less
conservative approach than atomic == !GFP_KERNEL. If anything we just
need to allow the additional flags through. Maybe just add GFP_NOIO and
GFP_NOFS in pcpu_gfp via the whitelist.

[1] 9a5b183941b ("mm, percpu: do not consider sleepable allocations atomic")
> 
> >>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>> ---
> >>>  mm/percpu.c | 26 ++++++++++++++++++++++++++
> >>>  1 file changed, 26 insertions(+)
> >>>
> >>> diff --git a/mm/percpu.c b/mm/percpu.c
> >>> index 71a85d7245c7..1bb38467390b 100644
> >>> --- a/mm/percpu.c
> >>> +++ b/mm/percpu.c
> >>> @@ -1778,6 +1778,23 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
> >>>  }
> >>>  #endif
> >>>  
> >>> +static unsigned int pcpu_memalloc_scope_save(gfp_t gfp)
> >>> +{
> >>> +	if (!(gfp & __GFP_IO))
> >>> +		return memalloc_noio_save();
> >>> +	if (!(gfp & __GFP_FS))
> >>> +		return memalloc_nofs_save();
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
> >>> +{
> >>> +	if (!(gfp & __GFP_IO))
> >>> +		memalloc_noio_restore(flags);
> >>> +	else if (!(gfp & __GFP_FS))
> >>> +		memalloc_nofs_restore(flags);
> >>> +}
> >>
> >> I disagree with this. We already have gfp flags, they're already passed to pcpu_create_chunk()
> >> and pcpu_populate_chunk(). It's their job to respect the gfp flags and
> >> Do The Right Thing(tm). Can you fix the problematic places? It seems like it's
> >> mostly the vmalloc backend that's problematic.
> 
> I’ll try to do it.
> 
> Following your suggestion, including in [PATCH 2/2], I will also try a
> different approach and fix the issue by reducing the scope of the
> pcpu_alloc_mutex critical section.
> 

No please don't. The point of the percpu mutex is to ensure that only
one person is ever possibly creating a new chunk. If you drop the mutex,
then you have to deal with concurrent callers when available percpu
memory is low. Percpu memory is expensive and unmovable so the cost is
in the control plane to avoid excess fragmentation.

Thanks,
Dennis

