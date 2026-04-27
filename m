Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17325FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F36F6B00A2; Mon, 27 Apr 2026 08:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC266B00A6; Mon, 27 Apr 2026 08:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406916B00A7; Mon, 27 Apr 2026 08:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB026B00A2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:21:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3A0F88ACB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:21:19 +0000 (UTC)
X-FDA: 84704245878.16.9769954
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2BEA7180015
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:21:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RscBaywc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777292478; a=rsa-sha256;
	cv=none;
	b=evo+6kM9CkrwvbEeCzaTQgsq3p0oObLPoS5ETSFCoo+9eiyKO5x9bUngRkbbjGTfiRacHZ
	zZ7fPIqspi/TDDOXCdcV2ppGLgLDN2WO0RxRO2+uNtvuuuuf33pVwevd1y4f/TzrIfS4Si
	2Fnu0Ih9g4iyUmKDHu+tC6a6/PtZXUU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RscBaywc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777292478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzcYpC2vyvn+HZ/paGjPO2fPo0+EMmAbH+eI5hURHRw=;
	b=XsUYRKaondHpeF/cv8kta7UrkSgLamH3cVWvtuhmo6OCGHz5beZr8NBG6dMsjcvwQqeDUc
	9228Y1xdyp916TOyu0Q7asN5e4zCirfY5AcSpMFoTKMzq5EV6kkwn+XZMAEKuMaVjZNgdk
	Z0nCjHiCWKW2TRc46lvd1rB0YzXevk4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C8B341A3E;
	Mon, 27 Apr 2026 12:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF84C19425;
	Mon, 27 Apr 2026 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777292477;
	bh=y5YbLZwgt5tGfMeBdX7DbB1fAcNv5JOlbmjt5fbiW8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RscBaywcFhwoI3SqDyzrigx+bPwRL4F6kV1gY7DSITn7AFSvt/XrXV9jwgFBMmfma
	 l7QsGrNpDg/2TqwSm8SaY5BPQDb5DXHP0Fmo461xxj9R/kycEznf2AqDxoL/OqlRCE
	 Ki4cDJipE+/Lz4ezngsXUthKafX+XMzveZM3Xx0hZIjXlUwtMXfIWrz91FRyODKRfP
	 RiCdz6kaME6KLLcia+I1KwgxGdsieiSYwd84Rge2TqMFb/J2WCiprpOGphi8tZkjtq
	 VtDOKaJARCp2y0VReMYF906QaVSy+BGMZNvp8ZZNKps7Gk8KJa60XxCotrq8+wOgq0
	 vDA61Tu0ebQGg==
Date: Mon, 27 Apr 2026 14:21:10 +0200
From: Christian Brauner <brauner@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com, 
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, 
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-ID: <20260427-ledig-urform-4719da0a06d2@brauner>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
 <ae9ItoKFvB12Qimn@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ae9ItoKFvB12Qimn@gondor.apana.org.au>
X-Stat-Signature: igmc5tryu5ct1o1fo44jjjgt1wfpmfy3
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BEA7180015
X-Rspamd-Server: rspam07
X-HE-Tag: 1777292477-655387
X-HE-Meta: U2FsdGVkX19KAFLZLTKOlJGoMeokJB+vZGcHqe6kR1zo/Eq5kUQAynA6REShGJfEmYQ3vMDyFsVX4ivcXw/Q/bf/+QoiSZG5chVznu+MkB3KeZ17QGA8OdlvvrON55u+NFnTeJugcPQ8h4/xHGopVVLBlSiYJ7l+ELLW17s/BIUMCbqN9eeNtM9uVFUikHtT0gb1PL+E6Rr6xTsSVgdheTPwxYarg0lqn1c2wLM39yGCHeZkTPB/NweQ97tA8xlC7QttCxKLG5cz1N7WD5ad+s18eoxpHTi9oSScDG8rToinInIkB72Yvdra+CnGsAyhghXvqDzCx+W7JmW29emlPq7TY22CsGK8LU5N6fy2RMHc/eELJOLB1U29ghXvj6gPKyPH/waHAd78CL1kwI6vZTC9a06DShMg36fcDaZnJZcW42j8TS0uTgl00e/tm2Rf8VJsH9ET37sECXEq+q7y8q/fCYH89X/RUkWO30hasN7SqX5v4jCVAY2TTRWRFOBnHxx4SQPx2muNUhsp5NcAOex3bUdRPjD7+vk2n4TKIfCyNpHqqvfJCtPXUME1qL0iZIWoXnwdA3Ov6bMIAo4l4vIXAukz6GeRjc02/GIT9gY0mqhn3yWDnX8bzD3SuDM9Z3bteyS4Mnc25Uyt+3f2LmYvzHq7OpZDdfYiirNrS4Bfk9+9MfL0xuOk1TfCzgTl9y+Laa3ThBpcZ1BW3HwcNaBSCOYbALltJXvJhoOENXfbOhVgfN9o834HfyWjejAsHnhbr4IqZ0k94P0qncsYRkbgzGr5b0gAsnp7R1EPBVEaMIvmjMOsBsdPbHx39KPjGNHLBAW/1W/LFm0t844Rv9Kx73GaRuYUv2tl9+AQhAQhh09VjaXaARFrwjrBxDJGr5cXoIU5ecG+5ZYzjFZkqXeq2kw4cat+nzfL6C8nD0MO2cHXR/hyqzuenz8rm1NyG1RvDv0fFZrFMgWY9Ix
 mdyfukKB
 16OqRObCr91uKoH15ao1WwFdHUkL0+Ia6l9NYOF6u0hnEcabAP9Lf2JzJYL97yUHO/aeUzy4+TcLu7az2AvvvEQH8db3myrMJOcWcp/DMJxgDPpiwECNKEABW3MJl41PPY8iKQw23ao0OI2bkjcTkdPqX9GarOYsTssyqLAJv1NNGCvH8U7F2eaXFIbubBJnsSwnsXWdLO+qoo5faYY5pvkoEgXyPUyR8uWHgA3Ay2QFKCMCK1BXoMbc3bleELVT0JpIHJAjPRPUaqTgf3D8R0Ei2U+ePyRZRRhX6rhWHFNHEIRirFek697W7VnibXoVPj+7Pv2u6sB1NYdlChDZMlTwShn5cbLDLJoJ8W4esClUF7nAydVO1iDriPB4+JknlxQ8SCGht4TqLfcCIEqbTfJqJQGi0LAIY7jYXSncGfTEmdchgZjYjPDeaQVk7ijisLWR8sy4qVj64YAm9/jVSYasB4KNDhRt+IRwlFx/KC4VJWluvq4WTj/quF0GvTkjf6PXtHoNCbIuiWJMxG8oEUw9h2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 07:29:58PM +0800, Herbert Xu wrote:
> On Mon, Apr 27, 2026 at 01:09:57PM +0200, Christian Brauner wrote:
> > syzbot reported a possible circular locking dependency between
> > &ht->mutex and fs_reclaim:
> > 
> >   CPU0 (kswapd0)                    CPU1 (kworker)
> >   --------------                    --------------
> >   fs_reclaim                        ht->mutex
> >     shmem_evict_inode                 rhashtable_rehash_alloc
> >       simple_xattrs_free                bucket_table_alloc(GFP_KERNEL)
> >         rhashtable_free_and_destroy       __kvmalloc_node
> >           mutex_lock(&ht->mutex)            might_alloc -> fs_reclaim
> > 
> > The two halves of the splat refer to two different events on
> > &ht->mutex.
> > 
> > The kswapd0 path is unambiguous: shmem_evict_inode at mm/shmem.c:1429
> > calls simple_xattrs_free(), which calls rhashtable_free_and_destroy()
> > on the per-inode simple_xattrs rhashtable being torn down with the
> > inode.
> > 
> > The previously-recorded ht->mutex -> fs_reclaim edge comes from
> > rht_deferred_worker -> rhashtable_rehash_alloc ->
> > bucket_table_alloc(GFP_KERNEL) -> __kvmalloc_node ->
> > might_alloc -> fs_reclaim. That stack stops at generic library code:
> > there is no subsystem-specific frame above rht_deferred_worker, so
> > the splat does not identify which rhashtable's worker recorded the
> > edge -- only that some rhashtable in the system did.
> > 
> > Whether or not that recording happened on the same simple_xattrs ht
> > that is now being destroyed, the predicted deadlock cannot occur:
> > rhashtable_free_and_destroy() does cancel_work_sync(&ht->run_work)
> > before taking ht->mutex, so the deferred worker cannot be running on
> > the instance being torn down. If the recording was on a different
> > rhashtable instance, the two ht->mutex acquisitions are on distinct
> > mutex objects and cannot deadlock either.
> > 
> > Lockdep flags a cycle regardless because mutex_init(&ht->mutex) lives
> > on a single source line in rhashtable_init_noprof(), so every
> > ht->mutex in the kernel shares one static lockdep class. Lockdep
> > matches by class, not by instance, and collapses all of these into
> > one node.
> > 
> > Lift the lockdep key out of rhashtable_init_noprof() and into the
> > caller. The user-visible rhashtable_init_noprof() /
> > rhltable_init_noprof() identifiers become macros that declare a
> > per-call-site static lock_class_key.
> > 
> > Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/69e798fe.050a0220.24bfd3.0032.GAE@google.com
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> >  include/linux/rhashtable-types.h | 22 ++++++++++++++++++----
> >  lib/rhashtable.c                 | 17 ++++++++++-------
> >  2 files changed, 28 insertions(+), 11 deletions(-)
> 
> Thanks for the patch.
> 
> But could you please try this patch and see if it also fixes
> your problem?
> 
> https://patchwork.kernel.org/project/linux-crypto/patch/20260422213349.1345098-2-mikhail.v.gavrilov@gmail.com/

Possibly, I don't have a way to easily reproduce this though.
Imho, the right thing would be to have both: actual useful keyed lockdep
annotation and - if safe - dropping the mutex.

