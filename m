Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB06DCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 11:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1EB46B0005; Wed, 20 May 2026 07:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF9B6B0088; Wed, 20 May 2026 07:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C556B008A; Wed, 20 May 2026 07:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C00126B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:35:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27BCC1C017D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:35:47 +0000 (UTC)
X-FDA: 84787593534.20.B803608
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5796414000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:35:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=XKbT3kpX;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779276945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxBqUM9QMhCc7/xYGwYeGP+hV4g1ifsVOKoXgGqJ0+Q=;
	b=m9FCltD1fqsJ0/4rvoZK/hIs+o7w1E4SCMbXutWRplYPVFAEcVuHc+qcvlzg/F0IAz6Xhs
	9v35tfO0p8kC17c+3IQ2TmKOcTRW+c/dmPu4qd/GcCtOnppKSIvndotyJSdK/312UiWuTq
	3JVotl4ywp3nEexxfimSVVLjwOwMe0o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=XKbT3kpX;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779276945; a=rsa-sha256;
	cv=none;
	b=1ZlP7OFwJh/YwKVpKSyL79Mc5xW2sZHzTIrRL/DpbRo4dEDE35YrOtvl72Q0QxNzvIHhDm
	upPwGbLobXBMuJMlBhDv3/1/cvq15NNWrIK6XYot+NfCvS+2RPTqPG5cqL/3MxQj6YzCoh
	3usiDzYPqYURWRTMmpZHVVg/8A8rhAg=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id BD8E3D0896;
	Wed, 20 May 2026 11:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779276943;
	bh=fxBqUM9QMhCc7/xYGwYeGP+hV4g1ifsVOKoXgGqJ0+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XKbT3kpXC4RpOmMxnNqIM5QRxgCHU6DbI2HO8Ji1VE3z9TnHV3D58cQ3adwgXWs6R
	 o48tDbnnwquJY9KBjkkboClFLT5riqL5Y9a/J6B4/6Volmqn1XfJkJ+gubPdvYQEgh
	 C8g7IDD4iXyijMe6SRgV5fXnAbweo+AgwfIr6kXU=
Date: Wed, 20 May 2026 11:35:40 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-ID: <ag2cjFyRh9K28WOL@shell.ilvokhin.com>
References: <20260518163736.173910-1-d@ilvokhin.com>
 <20260518132422.8cfec729a4d7e974c87ace72@linux-foundation.org>
 <agxqCE2juj14EhyZ@shell.ilvokhin.com>
 <agyBp_j6CXuhfkfp@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agyBp_j6CXuhfkfp@cmpxchg.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5796414000E
X-Rspam-User: 
X-Stat-Signature: hs3sm1ayy8gt1c117hgrfp4bdnf7s6yo
X-HE-Tag: 1779276945-781515
X-HE-Meta: U2FsdGVkX181+lOnVUjLkKFCVTWfs0w1vX6OnEB/zVCEBHxyCOEERnezgo/Cfo/dytuWA0dH2o/hYof7k+CZMnzeza8gkBDMaRJOZG79wxd4AvlSjOKor50ibHpC7kHq/cF3W1WssYYPdc0N82+nXY9+TVLIO+D3RjZllETVZhMopE9L4cnQihg+SSzi2TT4v7T+OPZke0h6S1nha/oIEAEn5JjlZKsQcFp+yZ60YLodR6FlCB28wwE6ZyjFxAwjtqzbW4NPb1RcfLCmLBbh1UicnWlJfz6ygr9G1a08ELO485gvzzX6lC9fqT7EbO9I80a9sM4V6S67dEPzYRSfRJDj/Lbj2tiOPrEqQ/LEAiuyvaQntnx2QHQp99zrTFnnQkA1S7ODGatMKuhGicfC354kATGTJppEFb4sxPrYhF/2L69R5XIWLxnkvr1vx7bl4FsTHGAwy2qNY0FiGV0d0JQ1MozpYUAOdV/27nQX0troF71AcDZgNs1CUCrMAomTc1UYCZqMt0pJ/a6+DJNFDnO2dZ0gnUz1o2wGoZZCFxFJ5wzrrNrzAGtAVplWEW39TaB2yBJF60n0S/sG7Rs9Ao2TQ1xTGZGrBBszarFTot+e0/3HeYazugjXRJ6ETXzJxvzY8WZPZO9waPd7i/+6K794JeohvTD+Xq1Yzi+SGWKf2yCohs3pDgnuNALW3pJX06FQhWD+7Keutc4VCacGUjyZKcrM+fhy73ZamDzxfRvknpO3HxhTcHGIWG7eVZqsRwH//Ibr+4Kedl9zFghvlHbGerGEyZhwzHcECLPtLCFaQuwzpgGhnzyEtrkoEjN/qAv5WrmLHUhARgq0tujKoekBPb0GLxbojvUjJNzgvPQ7GSZtDwcGZn9O+ITA6UJ/aK7wp6HOFF9SEdRlh/AiU5dhkY5F5l+25HQDFOWVR9DsxyG7hxarfFXWbRTUsuPiVhwpb/AeEuDqOt0ZnxG
 FAc7Vckr
 lC3d++lIO2vS/IIrzjDiMh55hGNxByFW9/0P5cEtAGtbyOipwi9nXmISBYnbtfgt9C4TY9ZBBQWXp7ViE4pFGopORMQNU/n2goUqvZ0Wah/MyPrAUthQefwbFIxsNiqbxAEddfOtROcSK3RJq/DyH6Ge+P07P5ESnd+ofVOEBOKXhq739G+ZLMj4yAUY/mLx62C+BqDfA351E8pC09sT6FV14quCL9drfwq9jM3PvXhm7kDj9+euXTi7JuYN1GLUK+D6f9jwa/Z8wnDl5dt+xECdw1Dkk6VexjUsUD1odelyopRCDxsywG8Dvn5YNxOQPW3hfcoAmPAbE+BStnS1wFletbkAgFhgtystZjgKFTxOwLjToV9OB/UMxxe6KoGCpk13dNtrsAeG8fw6rt+0SR61R9wyYEiURY1HVbpK24vEsyrC1d7XeDMJpUgn6lx6J4yEhGk+hOD9nSGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 11:28:39AM -0400, Johannes Weiner wrote:
> On Tue, May 19, 2026 at 01:47:52PM +0000, Dmitry Ilvokhin wrote:
> > On Mon, May 18, 2026 at 01:24:22PM -0700, Andrew Morton wrote:
> > > On Mon, 18 May 2026 16:37:36 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > > 
> > > > When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> > > > migratetype fallbacks and keep pageblocks clean. The allocator relies on
> > > > reclaim and compaction to free pages of the correct type before allowing
> > > > fallback as a last resort.
> > > > 
> > > > However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> > > > direct reclaim or compaction. With defrag_mode=1, these allocations hit
> > > > the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> > > > ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> > > > 
> > > > This causes a large number of SLUB allocation failures for
> > > > skbuff_head_cache under network-heavy workloads, despite free memory
> > > > being available in other migratetype freelists.
> > > > 
> > > > Clear ALLOC_NOFRAGMENT and retry before giving up on allocations that
> > > > cannot reclaim, following the same pattern used after reclaim/compaction
> > > > exhaustion later in the slowpath.
> > > 
> > > Thanks.  Sashiko asked a couple of things:
> > > 
> > > 	https://sashiko.dev/#/patchset/20260518163736.173910-1-d@ilvokhin.com
> > > 
> > > I'm not sure what to make of the first one - we aren't holding any locks
> > > in there which prevent concurrent cpuset or zonelist alterations
> > > anyway (?).
> > > 
> > > But your change might violate the later comment `No "goto retry;" can be
> > > placed above this check * unless it can execute just once'?
> > 
> > Thanks for taking a look, Andrew.
> > 
> > Goto retry can execute at most once, since ALLOC_NOFRAGMENT is cleared
> > before the jump, so on the next iteration the condition is false and we
> > fall through to goto nopage. This is the similar to the existing
> > can_retry_reserves path.
> 
> Yes, it's just a one-off retry with relaxed fragmentation rules, no
> need to re-evaluate the cpuset. So this looks fine to me.
> 
> > Just for the sake of keeping everything in one place. Another point
> > Sashiko raised.
> > 
> > "Will allocations hitting this PF_MEMALLOC check, or the __GFP_NORETRY check
> > further down in the function, still fail prematurely under defrag_mode=1?
> > Because these terminal error paths also jump directly to the nopage label,
> > they skip the normal ALLOC_NOFRAGMENT clearing at the bottom of the slowpath.
> > Should we also clear ALLOC_NOFRAGMENT and retry for these paths so they are
> > allowed to fall back rather than failing outright?"
> > 
> > I think by the time we reach the PF_MEMALLOC check, ALLOC_NOFRAGMENT has
> > already been cleared, since we set only ALLOC_NO_WATERMARKS and
> > ALLOC_KSWAPD in reserve_flags, when PF_MEMALLOC is set.
> 
> Yes, that's correct. alloc_flags gets overwritten, losing NOFRAGMENT,
> for privileged requests. And then we retry with that already.
> 
> > For GFP_NORETRY, we can do direct reclaim (compared to GFP_ATOMIC case),
> > so we either succeed or not, we don't need another round.
> 
> This is an interesting question.
> 
> GFP_NORETRY can reclaim and compact once, yes, but ALLOC_NOFRAGMENT is
> still a higher bar, increasing the likelihood of failure.
> 
> However, unlike GFP_ATOMIC, GFP_NORETRY are usually speculative
> allocations with reasonable fallback options (like slub's optimistic
> higher order requests).
> 
> The idea behind defrag_mode is to not fragment until the alternative
> is OOM. For GFP_ATOMIC, failing is an OOM-like event. For the other
> nopage cases, it's more about "my favorite thing isn't available".
> 
> So I'd say let's fix GFP_ATOMIC and leave the other cases alone unless
> somebody specifically brings it up as an issue.
> 
> However, there is one catch: GFP_ATOMIC is not its own flag. You're
> gating on can_direct_reclaim which is also true for optimistic things
> like mTHP allocations (GFP_TRANSHUGE_LIGHT e.g.). We don't want to
> fragment for those, either.
> 
> So I think you'd want to check at least if __GFP_KSWAPD_RECLAIM is set
> (which it is for GFP_ATOMIC) to decide between fragmenting and
> failing. If the caller doesn't even set that, it's a good indicator
> that they're purely speculative, and failing is the better option.

Thanks for taking a look, Johannes.

Makes sense to me. I'll add a check for __GFP_KSWAPD_RECLAIM.

> 
> With that,
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

