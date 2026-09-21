Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82CE2C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4A76B0092; Mon, 21 Sep 2026 16:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BCAF6B00B4; Mon, 21 Sep 2026 16:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA686B00B5; Mon, 21 Sep 2026 16:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD616B0092
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:05:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBC11A5AF7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:05:46 +0000 (UTC)
X-FDA: 85238849892.24.029EE4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2BBBB1C000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:05:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=laERZ3Kx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=laERZ3Kx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790021145;
	b=cGSG4Qg4zrB09KG8cBse+P5s5XHc5zUP84uxecfM6K5pivmmosoK6pxHWpVprK0s0mljTS
	dz/+UNYDxbQtIcH/MwFrh62D28Bl6jgFTLePEHlxtsLKuuFy1JG0v2/zSkFWSLkRdPIC9I
	H3J0lOC7I2VXdSSEeIf57ECcWGJDz3Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790021145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJrvbjKP0uMSBOgrfNHJZVcDEbLyWTjMWbSdfBccSIw=;
	b=s0Rqz6juwUOv7ahTfNE7G5FRWhW3Sti2Rswt6vknPNeznq1S+IAFt02d6br3Wfj8+2g5uh
	FEGZSyC0NHiGy8VI1bvXtBtQWcWkIHqs14423ClbY3t3mbThJfID9UDs+eDMqVYqySmfoz
	xJ+AIaZbbNAx5jDH6EZTWc+mdV01mlM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5181140202;
	Mon, 21 Sep 2026 20:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777591F000FF;
	Mon, 21 Sep 2026 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790021144;
	bh=dJrvbjKP0uMSBOgrfNHJZVcDEbLyWTjMWbSdfBccSIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=laERZ3KxzyekBtxnWDnLIqlvZO/wuj02jHIybpTnAhK2uldNxQQ0YAD172rdWUaiB
	 r9qPrrQ2NveG1l6JBtnpCu54AsMB++aHwc2kqI20kM/0C51oqB0fKEftifaZivkKC5
	 eQ37/qrMyqXwXZw1Pa3A2+y1zfEiUmA7krVG8wRc/N0kU6cwEWLGj+CisCnk0mSBN9
	 2AD8eP0rbGOfSrx+u9XQDsKQEukcM1OWuKo76zH0lbDYLkt6pFhsW3FZj9+X2hdT9K
	 gYiUuJUQmrHm1sVRLPg5nphE7EszecXcCCsNe7EslBoBxY9TZQitBcBdRQL+2xQlPu
	 lYa1wP7z25MKQ==
Date: Mon, 21 Sep 2026 22:05:38 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 16/17] signal: enforce the user worker signal mask in
 __set_task_blocked()
Message-ID: <20260921-gehirn-gleis-wenig-27dc2bd318bb@brauner>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-16-8e4adb1619e6@kernel.org>
 <arFYWLJ8yzpS325k@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <arFYWLJ8yzpS325k@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BBBB1C000C
X-Stat-Signature: r7k918k5czqn5xfzcwt9o8tizad8sn7r
X-Rspamd-Server: rspam01
X-HE-Tag: 1790021144-906396
X-HE-Meta: U2FsdGVkX1/dYpgOSnz4yyn9rdm5aTGjDhREYWnauQAo0FAMXu4zEs5v2S+9z8EABhm8YIEpbtrpnNTXRM11UXsJoNdPB3usuicnEcqDyZUdfATxJusDnAsdsX8EEmmzj/1ipOcQVPl8fHufqLDmNEBxp2IZ3RDZ8BbPPqIbsNM+hbkbyLbkvU9oh35zf3HyhCM4wfmjRCUMzKZZTcytMP9u6Q9ei+GYX4VIjPwbolY4Oq00AnNqJm+3mGe5Wcl8KT6heHQYEErS8uRxtNlt/uskNH3640SwwTIdMPK11m1IuZ9gF9SjMjdg3mTt9qA2JDTCRPCYWmYSIQk3Q4uS4LbDd0bFzk+T+AphHy8uarGD8RPHncXxgN9rGASVwADAieuSg1AarlTc7j8bmTJu0Ft2B5BZwHoNsfZSaRjqjwVrsNtOKOnoPolCN8rU+f39mLGeatt4LRkwGpkH/srfWQxs8PSlHP9btMGgj36lfSXq6Oiow/fjW1eGVcB+jj147aCo+MQ3v0VuKzxW8o77NxtmJrqGt43HsTnKrW/GCvEmBCUuiFahqBJTGoFo5hjPjT/RiiT0s3qtLS1GshxggAysKZ8AIEcWbryrmrUGC8F8/u9Yhh6eekqpDN4+vnayeLdtFVz0NZ64aoF3ztPmw4axvJjYYccKcpcw43BZxYxRuXbmJbcUtLgcLSTJ9y3J6Fo3/nkIU+7SCtUDIwMfXKULSVX3bJIoZAiBijurpb3T0VmluXJXcuE6fTgBpHkezwPjNpQ0YAu84gDkL4wmqwnPdoin49DML6tUwISVBP/q//E3tcZqSGYuXvemikMwRQ3Iaz/5CFdsJ+96Df4MoeCjQh0oF9wIiuAxFH7E1rO4MueJx2aMw0xOLu8fFZhkTElVdLTvn9Yf2Bo01U/O6LTvCKH4HvQQSvo+HCHSpbAsKWaX3HEQ5UvCrTmVpjBDHafPrwWB6sAAURqa6Rd
 bB3IoG8z
 GWOsTN4yh+/D1vYigKzu+52i3HmPa/ulj78tFEcK5Qjc5aVflClIhpq3yCW2BmyuVKgfJFYzcpK9TVSKuhjaMX8ElTkQxPKKwccYBRXXKKNOjpHhlYhlQxC+yS0tN0GOsBI8uP77M4EXtvJksTL0HQkOcpCrBjPSDBfNbZoqLGd2gEFB6sm8WoSo7TpEuYFFuKnPT7+3xzGe1R+WckLujkB3nIASE0vYw1+jXJEVVij9oPUUhBDkWsdCtmgbjcPawNWalO9u3wTnhfboRpwIrkAMAk3vHGLLHAgt8VW2Io/e5N5jckY1LPY8b7A7vm4I/0O2IrKudDr2s/II22Ev26JS06sj8t+N0YOdTQ7NDlYl4FIxxKPIn3cZe3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 06:16:24PM +0200, Oleg Nesterov wrote:
> On 09/21, Christian Brauner wrote:
> >
> > The in-kernel sigprocmask() users block more signals for a critical
> > section and restore the saved mask afterwards. cifs used to do that in
> > __smb_send_rqst() and ocfs2 in ocfs2_block_signals(). Both were
> > reachable from an io-wq worker. Both only add SIGKILL and SIGSTOP to the
> > user workers's and then put the fork-time mask back.
> 
> Ooh, this reminds me... see below.
> 
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -3212,6 +3212,16 @@ long do_no_restart_syscall(struct restart_block *param)
> >
> >  static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
> >  {
> > +	sigset_t floor, floored;
> > +
> > +	/* A user worker never unblocks anything but SIGKILL and SIGSTOP. */
> > +	if (unlikely(tsk->flags & PF_USER_WORKER)) {
> > +		siginitsetinv(&floor, SIG_KERNEL_ONLY_MASK);
> > +		sigorsets(&floored, newset, &floor);
> > +		WARN_ON_ONCE(!sigequalsets(&floored, newset));
> > +		newset = &floored;
> > +	}
> 
> OK, Acked-by: Oleg Nesterov <oleg@redhat.com>
> 
> although to me something like a more simple version
> 
> 	/* A user worker never unblocks anything but SIGKILL and SIGSTOP. */
> 	if (unlikely(tsk->flags & PF_USER_WORKER)) {
> 		sigset_t xxx;
> 		siginitsetinv(&xxx, SIG_KERNEL_ONLY_MASK);
> 		if (WARN_ON_ONCE(has_pending_signals(&xxx, newset)))
> 			return;
> 	}

Ok, let me see and fold that in if this is workable.

> makes more sense. But this is minor.
> 
> In fact I think that __set_task_blocked() should simply do
> 
> 	if (WARN_ON_ONCE(tsk->flags & PF_USER_WORKER))
> 		return;
> 
> but yes, we can't do this right now, we have in-kernel abusers of sigprocmask().

Yes, I found the two offenders. But fwiw, I've already fixed smb with
PF_NO_NOTIFY_SIGNAL which you reviewed some time ago. It's sitting in
kernel-7.4.signal. So only ocfs2 is left.

> IMO, they should be changed to not rely on sigprocmask(). Lets look at
> ocfs2_delete_inode() for example,
> 
> 	/* We want to block signals in delete_inode as the lock and
> 	 * messaging paths may return us -ERESTARTSYS. Which would
> 	 * cause us to exit early, resulting in inodes being orphaned
> 	 * forever. */
> 	ocfs2_block_signals(&oldset);
> 
> ocfs2_block_signals() blocks everything including SIGKILL and SIGSTOP.
> I guess to protect against signal_wake_up / TIF_SIGPENDING ?

I don't know. I guess so.

> But this can only help in the single-threaded case. And PF_USER_WORKER's
> are never single-threaded.

Yes.

> Blocking SIGSTOP can't protect from SIGSTOP if another thread dequeues
> SIGSTOP or another sig_kernel_stop() signal. This another thread will do
> do_signal_stop() -> signal_wake_up().
> 
> Same for SIGKILL...

Yes.

> In short, I agree with this patch, but mostly because of WARN_ON_ONCE()
> it adds.

