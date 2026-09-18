Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE3EC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9721E6B008C; Fri, 18 Sep 2026 08:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949F56B0093; Fri, 18 Sep 2026 08:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8873B6B0095; Fri, 18 Sep 2026 08:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DAF66B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:53:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3263A067A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:52:59 +0000 (UTC)
X-FDA: 85226872878.15.9DF3A5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4404520003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:52:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+48af3L;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789735978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URFVDzgpelJJ+jDhgim6DiODp4bS41sZLqrpRa8KViA=;
	b=WESKAy0rDlXr8l2qivLeTM0ULT5C2A56MgUL6IPlxY+NNsraukrBSmV1fIQt8ZrPA+Nn4r
	2C6MmNlF2RMciMUgE6PgS/TIZmO7jam6FENdN+U7Ny8A0ats2+pIb90lGJxS9cFhoxR2E4
	RMHtOqbJPsdbn0DvAndLvL+nbin5oaU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+48af3L;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789735978;
	b=B+xwa1HLledEUs4MH5D+6dl6qwkW82vuXSjQ68DBUIKmPhcNQSWAohrgxFY735ElXtp0X8
	DWk8TN9H2jGVXlyxIAsWQXug/N1CW6OxW8lVqaww5fTemfdfpJeorylPXzXAUyYTnAkxmj
	wiQW+1+5Vc+ueNhtF0JrjcsUa549ngo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A47C438E5;
	Fri, 18 Sep 2026 12:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16921F00898;
	Fri, 18 Sep 2026 12:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789735977;
	bh=URFVDzgpelJJ+jDhgim6DiODp4bS41sZLqrpRa8KViA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I+48af3LUNbvFF0M3+2V6k077VkMdkXCMw8Tzm8fgogJIAAmrrhl/pZKR5ouKn8pZ
	 +muGLNETLWA6HqkauxvPPoviHN/g9Nhnh91tTxenAf/9E9KA7Flsub2ItEXFDyJVN9
	 Ld+fSiYZsNwBJV/MKfr12j2E1+UebbO2km/rQMj89KBNbPiYqHN9fwhqX0ngN26TqI
	 KEzInAmEOdeTFvZxzU/BUrOHJuWIIq0OGV6lr4kerUBwuFA3KWRpKJbiCiDIA4u+VB
	 eXBeBBtMMNmk6/OQb08Fk9NfbcMfU/OpvLCoppOXjPSMjxfpTY5WFW2grMdqaS6RKF
	 sON1aXuXpBh1g==
Date: Fri, 18 Sep 2026 14:52:52 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4404520003
X-Stat-Signature: j983zgz4t9ne97dipj89ckxzx5yt9ijb
X-Rspam-User: 
X-HE-Tag: 1789735978-197682
X-HE-Meta: U2FsdGVkX19WIiCIdHIPpOWd5c0ZkXd2m7ydhnM7kHoKzBVfGzqlx7xRPtc9F8VuqVr5rh99DrtSdie3HwNHIHpSXyVcV0kNNFfT0EytdoFRAalFQ+oF7Ob7FwwrOTbLu3RY5ztxmMEECsWXWlAyqEiDvHHMh/Z3XiThWcNzUgSF7TiuLXodMH7A08MTNsv4j1rpVNxDEuVK0IUXQJQfXPbDnjcIN3w4OHWmGjTSQ4Atee1/7F96v+7+CORU3OBRD7nG7GFhWkEglkifVRYNFMcPAwHR3120hh1+iYrnbrYaUZ3ehTy3NsGdYWEnTNJ+GpX5IqyP1YeOuKtZDnudOB+Fuwyh5OCefWi4+yV2uawBVYIqWV5CuTxA0ysxxQhXi/fzZl3THOtPfG1516dKOS6mulBuFeR4nzdoeUT87Cq990h36BHlAvdX5m2XIlG++5Xw9p2x4XWhEukLqTuBR81zrvbOFkv/je+zE63SF1NYazDYPpgTJ847GBQ9/mmcl2sFseCB5SQuDARuGHRuKwcLXp9tIOEgkgz4KIKsoFQtRJ7+6qfA+dSOUB6EZGqIUtA+k3qq23L5pBLszgPuIbYuQ0ZpEIeMEr0X5SRvFtNUOQc9rvi0xvVRRyNDmirFYa//RIKXtpFm0cXgz691zc2QvtEbcdw3xdgppt1KnpntCSh40eoxzG0D94phs5P3/EAKub+R1nQ+b/bJQTpdHtcnH99RNie+T0P0MZk61Ma0eS0C9vyNUElHavaDBPjyp9J1tVTNMyNOBv4URc7VfggyYex1VBSqBS51Z8538DWgEwtMs8hfwv5ncbOwBJT97jSb9M7nh6csLAPUpg4KqACK2akLvM31R9uyMdeJoCUGdNbu1kTEZuMgjpMelTIP21aeFrUiGNE7PDR7HN1Co6yGXs5ZyKRy63FDb3ZN2KyULZkfaV6l4FlwJn418SUQtnJ1qXznAlQNx9yYb97
 E+sno8T1
 1WMqcYKgl1aYalj2rvwaZ2qdZp90Y21QnqZ7xOXc1ozZ0sEbAKIuWNlbXnmfbIuVQTgYX9DHbJnJpawO9IT/zLLey2ZVWHSiG+nFEVjhkyXy/qCcB7R3r/ADYS0zpazgpqiMu0sPdC+Ka/ZxwLnCBYdr3MmGz0ag7kz4DtTFqEkH1iYhIIdBOKm9te+CTWuiv1/LrznmvMUzXqja0aOnxckrdNsAkJqQmbxU2G8pRjYeXToYnM4U72giOLRd72IaMHsXllrRn65lsOzMysyLWiEXPta+4sqsGWogA14AGv3be3g4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 02:24:07PM +0200, Christian Brauner wrote:
> On Fri, Sep 18, 2026 at 12:40:45PM +0200, Oleg Nesterov wrote:
> > On 09/17, Christian Brauner wrote:
> > >
> > > Say a SQPOLL thread is a member of a thread-group that coredumps.
> > > The coredump code uses zap_process() and sends SIGKILL. The SQPOLL
> > > thread uses io_sqd_handle_event() and calls get_signal(). It removes
> > > SIGKILL from the pending set and returns. The SQPOLL thread breaks out
> > > of the loop and drains its own task work.
> > >
> > > Any pending io_req_task_submit() with REQ_F_FORCE_ASYNC creates a new
> > > worker when no other worker is free. So it ends up calling
> > > create_io_thread() from a thread whose fatal signal is gone.
> > 
> > Oh.. Can we fix this in the io_uring/ code somehow? The very fact that
> > copy_process() can be called after get_signal() returns SIGKILL looks
> > very wrong to me. See below.
> 
> Yeah, I agree but the io_uring solution I came up with all where a bit
> involved...
> 
> > 
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -2491,8 +2491,10 @@ __latent_entropy struct task_struct *copy_process(
> > >  		goto bad_fork_core_free;
> > >  	}
> > >
> > > -	/* Let kill terminate clone/fork in the middle */
> > > -	if (fatal_signal_pending(current)) {
> > > +	/* Let kill or a group exit, exec or coredump abort clone/fork */
> > > +	if (fatal_signal_pending(current) ||
> > > +	    (current->signal->flags & SIGNAL_GROUP_EXIT) ||
> > > +	    current->signal->group_exec_task || current->in_execve) {
> > 
> > Well, the comment doesn't explain why should we care about exec or coredump,
> > if we forget about the problem above fatal_signal_pending() must be true.
> > 
> > At least, can we move these additional checks into create_io_thread() ?
> > To not uglify copy_process()...
> > 
> > Hmm... get_signal() sets PF_SIGNALED before it checks PF_USER_WORKER, so
> > perhaps something like below can work?
> > 
> > And perhaps io_should_retry_thread() should check PF_SIGNALED too?
> 
> Hm, I like this idea...
> Let's see.

I think this works but they also need to check ->in_execve as the
exec'ing thread is obviously never signaled:

@@ -2709,6 +2707,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
                .user_worker    = 1,
        };

+       /* A creator past its fatal signal or in execve gets no thread. */
+       if ((current->flags & PF_SIGNALED) || current->in_execve)
+               return ERR_PTR(-EINTR);
+
        return copy_process(NULL, 0, node, &args);
 }

