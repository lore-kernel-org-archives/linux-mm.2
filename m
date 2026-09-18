Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D883AC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1AAD6B008A; Fri, 18 Sep 2026 11:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2476B008C; Fri, 18 Sep 2026 11:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A093F6B0092; Fri, 18 Sep 2026 11:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83BFE6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:15:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00B321406C9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:15:15 +0000 (UTC)
X-FDA: 85227231432.16.75660FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 698FF100011
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:15:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALXpnp1G;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789744514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/F6D1NMbwjNTV7KUzsWnd2D24VgFEgesLpZdXDwK78=;
	b=IsvesaBhbf02XWhPwQgCeOJ9OWM+0DUvQoj+o7XVbhF5ZxcYxgJOUP4FIEwdVztiSdmei8
	Oicw13W0QvPiXv5QwQzDxaD6oA+0VVs9WR0RalrNLk1JKdsNhhRJe/8j67o+btMuscH8EV
	KcHAvxniKnPjxyNk9nQ1U9VdH1kE6uc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALXpnp1G;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789744514;
	b=FdZSxERQUcBShb8VEgOco9vObIpHOzrUY1+0BtdKWICyqtKOh2iTBCcMgJaCFsp6RdHk+R
	pwEbcJcK0JNt8LBzkr2Wze+pE0At4IcnjECkkvQft4jz/e3MOGzzmPR0GUcd2FUNhAYRcb
	O8YXKBUTWNzdEggQCTVx1xjkwjM5W6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94751601EF;
	Fri, 18 Sep 2026 15:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F781F000FF;
	Fri, 18 Sep 2026 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789744513;
	bh=D/F6D1NMbwjNTV7KUzsWnd2D24VgFEgesLpZdXDwK78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ALXpnp1GHZGwryIUe3HRJsdfB2RX/g4ef7xnnB6/pGLV1iAWyFzmsR5PIapv6H17q
	 jj0UwoN+pu/t44md9aeZl9dKsdth73UiY7msfLcpTSW98gTyKG3GMRHLZU8Sk0H1fd
	 Ut7nYF8fKH6Cc8L/Aom3goTKn31Lrvh+s3V+zMcnRoduUNeg9ZdIi+rwT5qGY44bxU
	 hP+VoPIKc6IB2IdsVHYpP0p7rXLMOWuseQReBCxLLue5iPVlWCaolHYqUVD29J0Gjh
	 3CfxbMl8eBIeQ8Cm/1x91vcAlbhIMxuX3scvMP9eig4RKFD4hzU+9AxMZyF3lEvmhv
	 z9yKshBOgxgJQ==
Date: Fri, 18 Sep 2026 17:15:08 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <20260918-indiz-halbkreis-puzzeln-424924a9f781@brauner>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
 <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
 <aq0_lvHDViIpX_Mu@redhat.com>
 <20260918-elstern-potenzieren-marotten-71ebd0744753@brauner>
 <20260918-oliven-lebst-wohltat-c633868711f1@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918-oliven-lebst-wohltat-c633868711f1@brauner>
X-Rspam-User: 
X-Stat-Signature: 3g8p1k9q6hn5oxhwd6t7ei9or64f38bj
X-Rspamd-Queue-Id: 698FF100011
X-Rspamd-Server: rspam07
X-HE-Tag: 1789744514-305449
X-HE-Meta: U2FsdGVkX1+fxkuaZi32aSydThqIPq5K6JeYLmwADX82Y5R62M1R6CsyacWGhiVQz9GrxBPYKlmMJ9wXinnI8PAlktkwj2ddj1dS7B1Dt/LUt4GBa5NTK9gOEzNr5eYJF04bNqZerfhccUK/xSe5i6iPFfg9G3ZgpcdXxYNBFCA5J8zdchRK1nS1g5PxDy6oJ1CUzBu0CBvppBvOVGyWvvlmjNRmCQZkgNpvo+LnbnqgyHzPxVH6Z9k7Qzkqplh+y4QQ3NiFS9m3hGjELrMkVoOm38U8TCqISxUjhW/hw1UtMij+UH/RzwrDPgcy7bOfHPQgN7nwPVaqUEhQ9WO44YGS29s8ggYB/8cI6aQ3cdrHKkft4HtqHMePv5jm+BFPj8Qf+Q8gayPr9XpAG92Kp0vjV0LsaslJxpdBUUHBKu/3A1XMjb597t7fUrzcRz3kjV2FdOBXtrsXsOyHNIK/RvobtUgL3Dz9Rh1UyMKiDz1ciXjJ/La8bzRlr5E+X+cr2itvNB41sWlUIXcMkVCcddthzbQglLERY/Pez08tAZNrmELrz5IKuKhXBTXiBVrOBzKVFn5IWBG2VODUIZwVv1bSr8pGY4JzfN437EyHzmOMa8vaRNpPkWiWAbp1vGZuFX74XxIhWOnBYSn8jEenSTKAai8AD2u6Nr/vQqSCcDxzIldWUa7ctYQojKdTw4cwCDgPBM+10zU2TJOezi3XtuuwwQSxKngl18iZI8hen3z64Tf0aYUIb1XmAW4o9vcJkHtMyHl9sYdhR5NRT+1dOAV9vSblh4Qt7ZQSXPgw9DjVMs0yoQHwCqHFyIP+src4fnC0LA0CCF/oHaP5UYk+4RXitTr4VQWUfhusl0qrLgr1sqrqsD3h3kKD9QDQ9X9Nc9RymXDoYpLMoT7PtTA39T95WuBZZoqqwt3RBvcRMqntmh1dnyXM1CeVrbuLTwtx9VlpRQH0H0gBDXYZYpf
 aWD1YGn0
 43SsVHm0kdPZZeHQ6U2shiNuouDGtd7Tuqmh06dGZNSYmtCypFftsJ9JWwFaTyA17evEP+Rp1pW6i/JoPOSaqCTo9kZgyZvyMn/mI4Zh5kaIqEAaT5Un8dnremdgKN7YGd37IdR1eqjb+n+W5QDrzEufnytTkoqu6/JYLMkIqQJSHLZXdJlQWXsiKxo5eB8W8uu2D5LSWISkQSaVorglsN2GxgsMD7ICw84N/aMjxAZRwnz3wBG5Jtpuv6HqWdIlyyJ1uvhHMchGF1K4nLFCj3fgE4fmAOSjOmDMgHlVvAKIJOMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:00:50PM +0200, Christian Brauner wrote:
> On Fri, Sep 18, 2026 at 04:29:41PM +0200, Christian Brauner wrote:
> > On Fri, Sep 18, 2026 at 03:41:42PM +0200, Oleg Nesterov wrote:
> > > On 09/18, Christian Brauner wrote:
> > > >
> > > > I think this works but they also need to check ->in_execve as the
> > > > exec'ing thread is obviously never signaled:
> > > >
> > > > @@ -2709,6 +2707,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
> > > >                 .user_worker    = 1,
> > > >         };
> > > >
> > > > +       /* A creator past its fatal signal or in execve gets no thread. */
> > > > +       if ((current->flags & PF_SIGNALED) || current->in_execve)
> > > > +               return ERR_PTR(-EINTR);
> > > 
> > > Ah, I forgot to mention...
> > > 
> > > Can we shift io_uring_task_cancel() up, after setting bprm->point_of_no_return
> > > but before de_thread() ?
> > > 
> > > I know nothing about io_uring, not sure this would be enough...
> > 
> > From my reading of this code it works.
> > The cancel runs task work and any create_worker_cb() queued before the
> > exec can still create an io-wq worker. If that happens before
> > de_thread(), that worker just becomes a sibling that de_thread() kills
> > and waits for. After the cancel nothing new can be queued.
> 
> Right, one more thing to think about with this...
> 
> zap_process() skips every thread that has PF_POSTCOREDUMP set.
> do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
> io_uring_files_cancel() right after that.
> 
> That runs task work, create_worker_cb() runs and creates a new io-wq
> worker. If a thread started a coredump rgith before that worker gets
> created from a thread with PF_POSTCOREDUMP set which zap_processes()
> doesn't see. So two ways of fixing this:
> 
> (1) mask off PF_POSTCOREDUMP in copy_process() -> probably the wrong
>     place
> (2) key on PF_SIGNALED | PF_POSTCOREDUMP
> 
> I think (2) is probably correct:
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a28fd3976cc0..94a652d933c8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2707,8 +2707,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>                 .user_worker    = 1,
>         };
> 
> -       /* A creator past its fatal signal gets no thread. */
> -       if (current->flags & PF_SIGNALED)
> +       /* A creator past its fatal signal or its coredump point gets no thread. */
> +       if (current->flags & (PF_SIGNALED | PF_POSTCOREDUMP))
>                 return ERR_PTR(-EINTR);
> 
>         return copy_process(NULL, 0, node, &args);
> 
> Better ideas?

I guess we could move io_uring_files_cancel() before
synchronize_group_exit() but that feels sketchy.

