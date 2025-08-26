Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231F2CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 22:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450016B00C2; Tue, 26 Aug 2025 18:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427216B00C3; Tue, 26 Aug 2025 18:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364476B0108; Tue, 26 Aug 2025 18:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 270416B00C2
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:26:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8EFD1392B6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:26:49 +0000 (UTC)
X-FDA: 83820344538.29.0D74C50
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id C679E14000C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:26:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lYVZxmGA;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756247208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzFI8fgj/BdF0obZ/y49hT7uslbpWc7a8KSBkYRAaRM=;
	b=X6V7oenCM8ByECT3I+TeIRzOuyWEmpcGgddxwc2CLi93NpjV9MjaYmMF2zC3pEq58WCkHG
	w6Vv0Cl81X5LWwLObXKIHQwgi8mA9Qx501hNtPjInDXkSHWcFDmeX0VSGso+gQIbdu0koI
	2P+k+6WPqtVPqJ0u3y2k8ai06yQkPnQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lYVZxmGA;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756247208; a=rsa-sha256;
	cv=none;
	b=BvZwcKEhlNNqiIiuvY1XCvz2e2q9Ypq/+RUyQQdHqAEUjFfVhHTKzM5+uoWJUw3FzXaqBj
	NMeC3Usktpr8F1cnBtPNjslDGH+Mhst/X1/lQkCePTGZzZmpBXUJ+s8FCHsRe2Y9FDmZY4
	T6qZBcC9WmEqDwCBgYZpto+omlIG6U4=
Date: Tue, 26 Aug 2025 15:26:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756247205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tzFI8fgj/BdF0obZ/y49hT7uslbpWc7a8KSBkYRAaRM=;
	b=lYVZxmGA6CRCML0HPmZ5H8e/RnWO8lNbW87RG3tFCHjRLBhNsJmrBHjyNXYOCbR2qb+MKV
	vXBWCA1YgYMfibr4YvFtzlAjyete/8w5XQM8MfKVj6/VUT+d+t8/PpgNcE0zxEigqkpQoH
	GFwoxS4TLrfpYA+mZcQgtK7aISDGidk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, zhongjinji <zhongjinji@honor.com>, mhocko@suse.com, 
	rientjes@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
Message-ID: <oogiwonpxtqurkad7rt2zxc3ffgeujtilivno3ibcybzucsliw@ym7jm6r5kdil>
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-3-zhongjinji@honor.com>
 <002da86b-4be7-41a1-bb14-0853297c2828@lucifer.local>
 <nwh7gegmvoisbxlsfwslobpbqku376uxdj2z32owkbftvozt3x@4dfet73fh2yy>
 <bcabe7cb-d09c-4789-ae39-407b2e0653da@lucifer.local>
 <ip7al6pv3nm54raaptrxq3v4t7cpilqgppkezowzn2sfbjax65@qt72zuotrwnw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ip7al6pv3nm54raaptrxq3v4t7cpilqgppkezowzn2sfbjax65@qt72zuotrwnw>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7qchf6azwptzcjybtptzc8o18bjhmztt
X-Rspam-User: 
X-Rspamd-Queue-Id: C679E14000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1756247207-718626
X-HE-Meta: U2FsdGVkX19zBPbvpbSY1eXx2gSxe3zhldiFFd0hRavS/qT+OpXburBJ+lqU1jzNP8VUfndXAHVrGnt0y6f1Sjvl164uy7PMU3n/2yIjicYkM88/4xiSKYjXU6X3h+3aPFJqmF14iII2Ghx2GWMw/K9RMa3bzzoSKHgR46uGahnNX+Njz9aqJZMMakO7G3RzbZSvPHEoNExE7R0nzVLu2NcUU911Hyn/2vPw3AND5aD4rP+UEnYIv+RpoWSsL3pTALrDg68ory4PDe6jU1jJHXWM35lZt45rAdlPeei2albKUnajGHjhXvcTG2dYE2C38is25P7nyWUeu8lGnEH2miiX/6lTfn4tGb3R+amsucXO+M+U3HHWDcYNY2opNcLwoB8SfYfYK95nxtbXNJADJCMdRMRW4Mt8ix0jWHRAS55ajnrWJS1uTRw+CtXe/KaXfoMHHhziaa4zCbNwDZZKPHEflaokgN1ISglsQEVVsDtZGwn0fmKDzMlYkRcQzrTiYFCCLQR/uLBoJpN0zGKKXHydVBdBH4p+l5W01J48as+7N8+MJhaxloSfNA6iNBFfU4rR1flf+FNSPPgLqZkZsanWRs9OZrA6jsJHmtO/ApJlqSFP8tOK7+lieearw9Pf2OfySOBVrwokoIAAE01GvEG3llW9Tmxh5Qny5Tzf/Ps6TJEWrNUaMIQR+nhQ7/fx94pihjrH3Ix4+UkF/FaB2q+ZaL2AETCLWIRvtE32R/nyEwBJBh/LY+B30wGLGQv7FYlHHGZrUQqmoBq5g1z0MjQlSJ/geo1NsK9d4PW//O+C6WUf2wHJ3JMFzkFogAQvwqNiG56OTO0tSS0CMLOatYppC4DqOwrmtY9ij55r07vkp6zMrPHuSSlCl2PjxRTZImLbQRcQlVhAzfnKoA95ajTM0KlHol2GpT8ZK4TOGC5kpj7XxaxKia6Uv9KAnUkEqxH+64cL5Qa5i3l7prT
 MHnHSWz9
 zwHn3xm7J5FQWZrCdKKgwYILk2mEt9qMdMzoNuRQDHI7ce5w99c2WnHbIrRBeT3CUFZwnmfnDNo8TXLkH912nJLlqlzFOWnTEBpuADNyGKTknxrwRcbMzLOWxFjZzoP9+aYw0M6XuxMDCNHcg7HZMB0V6Az1m/Db80l2oLYd3NfPg85iexTLGEUd1LIUpdbPCNaBe2r6wp/gIFNzfvBkgf8Wk1MpmiSuLB8P6kgrCX40o415p0SPZ/j1bNtZS5zOvOzUvoy4upNdq/oD1WEckyEOq83lFaW+3YrK5t8WzaLwmtwZL9qKSuz7fZ0Hovse9GPEy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 11:21:13AM -0400, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250826 09:50]:
> > On Tue, Aug 26, 2025 at 09:37:22AM -0400, Liam R. Howlett wrote:
> > > I really don't think this is worth doing.  We're avoiding a race between
> > > oom and a task unmap - the MMF bits should be used to avoid this race -
> > > or at least mitigate it.
> > 
> > Yes for sure, as explored at length in previous discussions this feels like
> > we're papering over cracks here.
> > 
> > _However_, I'm sort of ok with a minimalistic fix that solves the proximate
> > issue even if it is that, as long as it doesn't cause issues in doing so.
> > 
> > So this is my take on the below and why I'm open to it!
> > 
> > >
> > > They are probably both under the read lock, but considering how rare it
> > > would be, would a racy flag check be enough - it is hardly critical to
> > > get right.  Either would reduce the probability.
> > 
> > Zongjinji - I'm stil not sure that you've really indicated _why_ you're
> > seeing such a tight and unusual race. Presumably some truly massive number
> > of tasks being OOM'd and unmapping but... yeah that seems odd anyway.
> > 
> > But again, if we can safely fix this in a way that doesn't hurt stuff too
> > much I'm ok with it (of course, these are famous last words in the kernel
> > often...!)
> > 
> > Liam - are you open to a solution on the basis above, or do you feel we
> > ought simply to fix the underlying issue here?
> 
> At least this is a benign race. 

Is this really a race or rather a contention? IIUC exit_mmap and the oom
reaper are trying to unmap the address space of the oom-killed process
and can compete on page table locks. If both are running concurrently on
two cpus then the contention can continue for whole address space and
can slow down the actual memory freeing. Making oom reaper traverse in
opposite direction can drastically reduce the contention and faster
memory freeing.

> I'd think using MMF_ to reduce the race
> would achieve the same goal with less risk - which is why I bring it up.
> 

With MMF_ flag, are you suggesting oom reaper to skip the unmapping of
the oom-killed process?

> Really, both methods should be low risk, so I'm fine with either way.
> 
> But I am interested in hearing how this race is happening enough to
> necessitate a fix.  Reversing the iterator is a one-spot fix - if this
> happens elsewhere then we're out of options.  Using the MMF_ flags is
> more of a scalable fix, if it achieves the same results.

On the question of if this is a rare situaion and worth the patch. I
would say this scenario is not that rare particularly on low memory
devices and on highly utilized overcommitted systems. Memory pressure
and oom-kills are norm on such systems. The point of oom reaper is to
bring the system out of the oom situation quickly and having two cpus
unmapping the oom-killed process can potentially bring the system out of
oom situation faster.

I think the patch (with your suggestions) is simple enough and I don't
see any risk in including it.


