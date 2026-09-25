Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95963C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9322A6B0093; Fri, 25 Sep 2026 06:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2206B0095; Fri, 25 Sep 2026 06:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA676B0096; Fri, 25 Sep 2026 06:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56E4F6B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:57:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62C511205B7
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:57:46 +0000 (UTC)
X-FDA: 85251984132.02.8508ED3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id BDE0420004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:57:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFSHH485;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790333864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nnw14xvfnQJHUMg1YXGWQNGAHKQa7rYgYgJD3iK4zYE=;
	b=gXdDPrOviZolGchb+lMUsDYlTg0sjCoPzJL2ED7vL7toWPW5uwzb4xLTgoqTm/kftfnJY4
	6G7ut6UvKa+imL6pJdyMIkFQkh92vNsJ2J8iAf8F8StI40tPy7VkQ8qdP1HmO1GTQCUqiT
	RAcomAt9/oSrhRcld5uKd+o6lD+fqPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790333864;
	b=7zi45HKcn66fjdYUdCX0r/yZWRiJ9CnIcAGPXJL36zHUIQ957z8wEaWa1+LMCCSW31q+Tc
	JLG9ZB9sD8yqpuDp5uIkpC12i4KPDhla61MNmn436CGuI/govlE0dgQUFlBR40qg21hgnP
	xIA1G8FMl6wGNjUs66CxyRZwTYPEVgg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFSHH485;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43E7F6022F;
	Fri, 25 Sep 2026 10:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2FF1F000FF;
	Fri, 25 Sep 2026 10:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790333864;
	bh=Nnw14xvfnQJHUMg1YXGWQNGAHKQa7rYgYgJD3iK4zYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NFSHH4853QkanVK7cAcdsVYAO7CYl3VgyNJYz2cVgQtgurMgoA3lFdYljYW/k9syR
	 3iLr0riA8QHTHG+jgg+f7jROnNDUwZYZ633UjZ1M5/70fCm6UsfoeyKoblQAClGJAn
	 t7eBTDsQHSF5p3YIfUhIiiKOjIu7mlTYOCEwTdT6E4BfV4XrST0m1eEG4xxAGnSsY3
	 q+xVulTcc5tNj7kVYX00uvcM4mttnaY3zaCCQ6F3onF+q5RD/6Hec7jryDoUiiBM3Y
	 hWPZ2MrnOGXId0wyubFDI8IcuEwFClX0ByYw1lP+xnX0C1zvIQIkKsToQ+nus7++SD
	 yUqx0FT6Da1Cw==
Date: Fri, 25 Sep 2026 11:57:41 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: do not wake up kswapd in
 __kfree_rcu_sheaf()
Message-ID: <arVERNhXeU1BX54G@thinkstation>
References: <20260922-kfree-rcu-dont-wakeup-kswapd-v1-1-42d7e2636f9e@kernel.org>
 <2db41ce0-a510-4050-a79c-ff1f16640b47@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db41ce0-a510-4050-a79c-ff1f16640b47@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BDE0420004
X-Stat-Signature: 4679wxbzux93wjhk1b8u4onp9jj68kje
X-Rspam-User: 
X-HE-Tag: 1790333864-854758
X-HE-Meta: U2FsdGVkX18yy4G83ikfBUxum4xKTmLlKlV3lu8aLmdz/Qr840QB67icLD/N4YwJQjfh1vyggFJJQ7rK0Bq9iMYZ+cJ97n1zibXSdRl9cozM5BR7iSryp6SEHLxcNbhuUrSP5Xykua7bS95NwnoavaJEFFhjcg1IWptKs6/m7EAGP082HdS1bu6p2d3aMQavvrg1UKOwW+bI+KnUZYu1a737bBo6xwPEOsxXq+k+UmQzAtCwTLe29oBIkxPYNWgv9q7FEOvPMQ3mk1VeovM/dhAzqoTCxKFpVICBineAYm7zFE4E5zQXD6bKxp91eVpcLFd5KYHKuofhOs/qSaVr6T269sPu4z7mhQjvOjpktO5tn4zbVm1v91rvU9x8XLuPTH3fJLuTaXgIfPktPrzA+i8Kd8g5DiFsPBPM2VfC4m0/xHa0EoPni3LAchHzNX4IPEMNLxb3jTl9yVHURyfpuJ84vksROfoe88Rjk9kNNlUGAOrOCKYsDL0PYGWzKN8hQl0kC31sRsX77ULTJpI9m8PmV2uIDLlEyQQ1GhbTwjGkb6SbfuAf3jS1N7fbGcVdOGSY5udAiLJMGOi9XA0nSUUXqakuPWoXdML2XVyKGrDVkj72pSdUhVXtQt9CSzSWfytnzJ8+4SR1/hDNwjWyp9sIjGcJQFdI5a+CDKR7ao/ACz6JSKnCNzv1U4hkHUOq1qgHeoiZlqDwpslWXxVTtyfgNTonmkLcntJJ0ubHrFqXbhDWzOVYlK8QNiIOgi+9b5jmnOVpL9rxsauFmBLPqQzloMxci1LsYdxD72CTsSOBe4oshk4aaqxzjuSQx/x0VGbpEc2/BvKqYf7tKyC3ZV3B1i2ucEzK+H0wWuUspbA+jI1lEvs7pPlxEWZ/i1YEacpfVBACks1xfe9smpi7uV9M4w0SWX/vncO0ZTV9VKZ7Q4ggrCCppjny2eQ4o9myPIgegAMWnBWe3RppO+l
 EA8CNMvO
 iv8mz6I8v6nnO0xngcAel16FzT+MCtEC1TMWzQu/r9o+p+63VUUS1cuJGR6aRMGhncHUrMkMcfkGB7H+F5OpFusolPM+y26RMccVP0STuIGXUUKpableIRR2tlgzUWXBqgMQ0r2KreT80PLjl4jsFmmX7bSo29LIr5oLaE0UqT38CMp6XjnHiFRedewb24ao9dxSIT2fm83zUfo2N1+N63L8k74a1Re3SKfhO1zl9tDfOd5nPNR2j3P9O97ox8/ueHVqqt3/Uo2SbUCPo7PoQO5hrFn9ISthzqsJ/zqsNvOojs4RujwL25HEumT4wnd42DtOJDdA5UwK/507EiSYMMKuOK2HtQK/872BUQLqosLNEpHjeulrhjEKtYFP0U/qVMn8xUxOJi7APido+MzDPMT/Kpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:43:01AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/22/26 13:56, Harry Yoo (Meta) wrote:
> > Fix this by always avoiding waking up kswapd in __kfree_rcu_sheaf().
> > Note that there are two paths that might wake up kswapd:
> > 
> >   1) __kfree_rcu_sheaf()
> >      // __GFP_KSWAPD_RECLAIM might wake up kswapd
> >      -> alloc_empty_sheaf(GFP_NOWAIT)
> > 
> >   2) __kfree_rcu_sheaf()
> >      // Let's say __kfree_rcu_sheaf() doesn't pass GFP_NOWAIT
> >      -> alloc_empty_sheaf(__GFP_NOWARN)
> >      -> kmalloc_flags()
> >      -> slab_alloc_node()
> >      -> alloc_from_pcs()
> >      -> __pcs_replace_empty_main()
> >      // Free a sheaf in an allocation path when the sheaf becomes empty
> >      // and refilling the sheaf fails
> 
> So that's this
> 
>                 /*
>                  * we must be very low on memory so don't bother
>                  * with the barn
>                  */
>                 sheaf_flush_unused(s, empty);
>                 free_empty_sheaf(s, empty);
> 
> Now I wonder if we should just use the barn then, lol. We either took the
> empty sheaf from there, or there was none, so we don't risk overfilling it
> with free sheaves.

Well when refill_sheaf() fails, it's not guaranteed to be empty.
Might have to put a partial sheaf to full list?

... well, now we have sheaf_partial though :-)

> Well but I guess sheaf_flush_unused() could end up in freeing paths anyway.
> But that's a bulk free which doesn't involve sheaves at least.

What do you mean by "**sheaf_flush_unused()** could end up in freeing path"
but "that's a bulk free which doesn't involve **sheaves**"?

> We could also distinguish which callers of refill_sheaf() can continue with
> a partially refilled sheaf. This one likely can so we'd not have to be
> flushing, ever?

Can we do that without adding too much complexity?

> >      -> free_empty_sheaf()
> >      -> slab_free()
> >      -> free_to_pcs()
> >      -> __pcs_replace_full_main()
> >      // However free path always assumes it's safe to wake up kswapd
> >      -> alloc_empty_sheaf(GFP_NOWAIT)
> 
> Would be great to avoid all this from kfree_rcu().

Yeah.

> > Drop __GFP_KSWAPD_RECLAIM in both cases. Note that the kfree_rcu() is
> > not the only user of free_to_pcs() path, but it should be fixed as it
> > can be invoked under pi_lock.
> > 
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://sashiko.dev/#/message/20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b%40kernel.org
> > Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> > Link: https://lore.kernel.org/linux-mm/20260831143500.x-saxdAs@linutronix.de
> 
> Fixed up per your reply.

Ack.

> > Assisted-by: LLM
> 
> Changed to (per below)
> 
> Assisted-by: LLM # dicovery and verification

Ack.

Didn't know adding # blablah after Assisted-by: was a thing!

> > Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> > ---
> > The discovery and verification (w/ a modified kernel) of the bug was
> > assisted by LLMs.
> > 
> > More speicifically, the first path was pointed out by Sashiko, and
> > the second path was discovered by LLM while reviewing the commit with
> > review-prompts [1].
> > 
> > Harry Yoo reviewed those findings and manually crafted the patch based
> > on that.
> > 
> > [1] https://github.com/masoncl/review-prompts
> > 
> > I believe the right direction to address this issue is to make
> > kfree_nolock() work in any context and replace it with kfree_rcu()
> > in the scheduler. However for now it won't work under pi_lock,
> > and resolving that would be a longer journey.
> 
> Indeed.
> 
> > Address this issue by dropping __GFP_KSWAPD_RECLAIM, for now.
> 
> Applied to mm/slab.git slab/for-next-fixes, thanks!

Thanks!

> But still could discuss a better solution per above.

-- 
Cheers,
Harry / Hyeonggon

