Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3611C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 00:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C946B008A; Wed,  8 Jul 2026 20:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BCD6B008C; Wed,  8 Jul 2026 20:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906066B0092; Wed,  8 Jul 2026 20:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6588E6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:38:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C08CDC1624
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:38:03 +0000 (UTC)
X-FDA: 84967376046.30.4B3A0A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 231D5A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:38:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCQRopgm;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783557482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RENAVN6va6uTjcNLhj+4No96sH1HBb8IuOBXBZj+j0c=;
	b=Oart1rN3T1BzZhgd3LxvtkGGAwW3ZInHtKS10MOGEURiiz2sD9We/hll+jFk4Ocnm8pekE
	tZ/BYZ+ZKTqnuZPxPITnMj6FpRZEGB991CNDRZsGOCMIozoJUJ7IJ2WqdhGV9fWZkHtDIe
	LFksf3TkY6fa8kUUYEUwDVfIZRAOW9Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCQRopgm;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783557482;
	b=3zxdLnKAHoPFJEE1AodpEbdfd1RDAsdtH5Pp6pVvHh0PkGIlTQn44/ilkLaW21gDTl6zFM
	caSzhvLYFKa3OSViAOmeXtQSvc0Suf3sdNu5ihaFch5pJ89yWqRjhy0bgpGmhMBDijjilz
	r8AfvKPU8MR7xqsYF9Z4mHGeyWbBaWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48FF3404C2;
	Thu,  9 Jul 2026 00:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A911F000E9;
	Thu,  9 Jul 2026 00:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783557481;
	bh=RENAVN6va6uTjcNLhj+4No96sH1HBb8IuOBXBZj+j0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCQRopgmzMF9+fu5Z+cWag8f3rAUgxSI/1etATZktL7ZGEZcVpeSSDqdagb4xGVpm
	 zK9xuQhCTH0c3ME71pFMGugXQb/WpYMLpW4tuA/bEAOBYdIRHM38VoN2Ql4w8afu4v
	 vjB59u85W4NZrqWQKLDj0z5vObwx4osUJIR+eD1ke3d7eO7W6FC5ccDBPcdy8hvSP1
	 Hklc2PadiBIdTviR2xXnAgu9KsufWlRwz2Aazrsa58V5XQyIdplfDi/uV3SXufeSn8
	 eUFMTqEj85PrLDN4u80kMAiMNI6HjLCzkToCm7vMIRs2LgxGDZC3eKaBJ4yrnEOnSH
	 Nem/y/mMSREKw==
From: SJ Park <sj@kernel.org>
To: Jiahui Zhang <jiahuitry@outlook.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Honggyu Kim <honggyu.kim@sk.com>
Subject: Re: [PATCH] mm/damon: prevent migration fallback to non-target nodes
Date: Wed,  8 Jul 2026 17:37:51 -0700
Message-ID: <20260709003752.127954-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To:  <BY5PR02MB6642569E180FF82F147E7880B5FF2@BY5PR02MB6642.namprd02.prod.outlook.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 231D5A0004
X-Stat-Signature: zke5mgrretckb9scaa71bikgx7btz99p
X-HE-Tag: 1783557481-372587
X-HE-Meta: U2FsdGVkX1/f85+OkTKg2OdYaVSfuAIui0rNygq/g2LWaUnMeodH9FbX0NiORnt/bOJIYAB6IwJCXDNls1K+Ga/4NRNaGHJovEhv0yGL+0/yrtW1k1hDtWgmUMmLd1hm2J13NyrrMJiNiDAMHlIQADqCXN62rl7o4FSn1sna1jpbatx4qwb4/b4PsVI+5YJGtY7vx0imE+Qu0ygKVxWHAuT3n7WllkCUNfO/rR3RHo8XSWiDa+jc8E+6QcRxWRGCa4AOtRioX2VdboIsY7TzfkysaBhax6YJSQ1j7+FjRlb8mMwGs0QkEwvmN9I/LSabQSWZk5UxDqmdHIrNQmyhR0/ZkLpLPssOJhOL9T/zpKhJvAA9A7fGzcgdX7FkzA7CObisLcY8DLzOPGR8F/dwXM9ESnOUegU6GGtHkA8zcIjwHX3lrXjuTm039sHLwiNd3rSGYnjpL5ApIRSNNowVpiUVg7Soc6bDOzrOXnWnmoXmK6pBFADmIoLBJbmKV/HhzY42YnbT6jNtwFITFG7k7UQKJdBSVM1kLgC5FGEkrdNTmzKrP1Auw5Y6+xGbyXyu9FgEdWdDJrCaprGXHbjbSKm1RuYtdO4v+2F+raB41S0tXbMQRZVMHCuesW359sEh8ft8I10lJOEPl1reqayc2mWK5WyIOYFiiyH9fbeO99XvxKELZW/GZxugfXk6zgXQYTr1eWGjNRLhHlo+JCE7A+hB6EPQTs44axQ8ACoj6EqbwnEka3pJzOPTnZtiTK1HWx/uyl2wQJM/7J7itBwjkdlbUWu7BtScUqSf6bw7QaIB11XL+F4sfME5jP7P9ClmZah1BHjI1xJEx0RjiyN+xljRMt8l622OGB1V+yk+Qr5ZKSMUonZfUG0ledILiHgRr4GTaz5xeU6eQzDo2OrpVCVmA6VKGLxXN4/3emdEVmRbHUlhuWV7huzb9InSDZ/cDi5bvOF/Q72hqsJdd9f
 XfFzYWGO
 8n1Y//tUiAXQegEnt3x6uoYg2Pywj/roB22lUrPH4Eb3mLZD9fRrdlYULKWsZNq0+daDQrtK4hZsbYettgrBptGamkX/oTGbLPTtQTwJI47jPqD4RgydBlvZSXiDS+oO3cz9I7jby2J2BnJXXD+ZGjIlWbaavGcd8tg34LCVnrLl9nUy0Hbh1ErnJph6VAcCFcheFf+8SEGlQh1oRk6NDxgQdVGrhHRs6GG6JW7v+oCnaa3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Honggyu for origin intent of not adding __GFP_THISNODE

On Wed, 8 Jul 2026 10:55:05 -0700 Jiahui Zhang <jiahuitry@outlook.com> wrote:

> Hi SJ,
> 
> Thank you for the review.
> 
> On Wed, Jul 08, 2026 at 07:11:33AM -0700, SJ Park wrote:
> > So this patch is introducing a small behavioral change.  May I ask
> > why you think the new behavior is better?  Have you find some 
> > negative user impacts from the current behavior?
> 
> Consider a two-node tiered system, where node 0 is the fast tier and 
> node 1 is a CPU-less slow tier, such as CXL memory.  Suppose node 0 
> is nearly full and the user wants to promote hot regions (which reside
> on node 1) to node 0 with a command like:
> 
>   sudo damo start --ops vaddr --target_pid ${workload_pid} \
>       --damos_action migrate_hot 0 \
>       --damos_access_rate 70% max
> 
> Without the __GFP_THISNODE flag, when the memory allocator finds that
> node 0 is nearly full, it can fall back to node 1 without waking up 
> kswapd.

Have you considered or tested running demotion-purpose DAMOS scheme together?

> Then the pages allocated for migrate_pages() are still on node 1, 
> and the regions that are expected to be promoted to node 0 are only moved
>  to different physical pages on node 1.
> 
> As a result, the NUMA node placement does not change, but the following
> command still observes successful migrations:
> 
>   sudo bpftrace -e '
>   tracepoint:migrate:mm_migrate_pages /args->reason == 9/
>   {
>       @succeeded_pages = sum(args->succeeded);
>   }
>   interval:s:1
>   {
>       time("%H:%M:%S ");
>       print(@succeeded_pages);
>       clear(@succeeded_pages);
>   }'
> 
> I've also checked other page migration paths, such as alloc_demote_folio(),
>  alloc_misplaced_dst_folio() and do_move_pages_to_node(), all of which set
> the __GFP_THISNODE flag.
> 
> I am not sure whether the original design intended to provide only
> best-effort semantics,

To my understanding, it was initially trying to reflect what
demote_folio_list() does.  Because it doesn't have ___GFP_THISNODE, this
function also ended up not having it without a very serious reason.

My mental model of DAMOS_MIGRATE_{HOT,COLD} nowadays is like move_pages().
And I find do_move_pages_to_node(), which is used by move_pages() is also using
the flag.

So I think adding the flag is ok.  Cc-ed Honggyu for a case he has different
opinions, though.

> but I found this behavior very confusing in my
> experiment.

Thank you for sharing this pain point.

I agree this can be very confusing for inveestigations.  Not just confusing but
makes investigations of this case nearly impossible, iiuc.  DAMOS provides its
own stats for succeeded and failed operations, but that will again not be
helpful since migrate_pages would returned success in this case.

So, yes, let's add the flag unless someone else has a different opinions.

> 
> > We as the kernel community disallow [1] anonymous patch submissions.  Is zjh
> > your preferred identity?  Also, it is not a strict rule, but we as the mm
> > community prefer using a formal name if that's ok.
> 
> Sorry I did not notice this.  If you think the GFP flag should be added, I will
> send a v2 of the patch and correct the Signed-off-by issue.

Yes, please give others time to comment on (say, one day?) and proceed to v2 if
nobody disagrees to.

On the version, could you please add the clarification of the pain points you
encountered, and how this change made it disappeared?

Also, let's change the subject prefix from mm/damon: to mm/damon/ops-common:


Thanks,
SJ

[...]

