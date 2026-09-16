Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575C6C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D4A6B0088; Wed, 16 Sep 2026 07:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEDC6B008C; Wed, 16 Sep 2026 07:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4266B0092; Wed, 16 Sep 2026 07:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2148F6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:30:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8376806C3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:30:29 +0000 (UTC)
X-FDA: 85219407378.26.C8D0026
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1002314000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:30:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D6mXo8aG;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNxxziEzSRjeeKkjHPI2ybzZcO+hLZVdC7CPel2aGig=;
	b=WxQSRHVZtRcefW+wxh1BiBBiMJr+zlbBPFNvEJrES5oPJltYhnjWpp4F+GkPXTNj7YWrab
	x6fDM2Orwpi5ZXkpa27gFd/SKRR+i1/SPl1q/JGb1BgPhLOsnHtrHjkApUlHNvsaaimioo
	jmsGc2ZXi6uCrv19x91BdGkbAHzD4+U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D6mXo8aG;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558228;
	b=d7vxfWHIyK6vMDyG/aRp+lt1Mm1obBKs5CiuCiRHDOZCR2/dmQxx+eGwC8VyQR95mzd4Y0
	VjJTtTR37XnQWFBq4Ie8CkBNPfJcURnwRIGiKVD+zKy0D+JsDSf1U3dYJDrEPKPsD9itl/
	YvAtNOrrE3WoX9UNu9sB/NLc14Bi0ko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF8DE6053A;
	Wed, 16 Sep 2026 11:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11CD1F00893;
	Wed, 16 Sep 2026 11:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789558226;
	bh=cNxxziEzSRjeeKkjHPI2ybzZcO+hLZVdC7CPel2aGig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D6mXo8aGO1S4K38ZGd8hkcIL0zJZyK5x1+eSM6TRcftvJ9ZosYGt4bxLvysVZ+c/Y
	 xDcSDPMp52bYcCHZbgSChB8nsQXIgP/tAv10w+e4enDJXg7Uhd6pl3beUXWDcN6RdQ
	 6VF7pTigbgLNIIxkSvcuWk5HBji2ptCf94tszX/X9Ha5vfIU5DpjUo7TzugCOisXTb
	 AuyPrBRFbuaFK29qI7SDRhEjy3Ku7qyicG1MDeY96T6+L6Tts7MoKh14J/IoMUKB9B
	 HCQc6d71jHWqbETl0C7+9hNnVoF9hUItBo8u3gooJ0NJZhejtfpJE89vQU4GBshhLq
	 T/Un53225h9YQ==
Date: Wed, 16 Sep 2026 13:30:21 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/6] fork: refuse new threads while a coredump is in
 progress
Message-ID: <20260916-geortet-ermessen-delegation-07b36ac1f4eb@brauner>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
 <20260915-work-coredump-fixes-v1-2-f354ca41780c@kernel.org>
 <aqleExxTBcHsonQe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqleExxTBcHsonQe@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1002314000B
X-Stat-Signature: qus3yeq9iw1uzf4yibqc74kf5m78itob
X-Rspam-User: 
X-HE-Tag: 1789558227-479898
X-HE-Meta: U2FsdGVkX18AaZ2z3dpKDjZOZbehh06CDyKw58GxdeVBQDa9Jel+IO18RmW301b5Tm8XqXqcYOr+F7CPIVpjPNy9LPg2vajBYRoVBhKQi/ZxQDER03vYeiB1cMyNe/6ckQxkgxbUatz2XdWySGxez9u/fHht+Rkdq5Yc3VO7aCXF+yNqrvoL9yy9JMhGYc0xUcNvaWD+Tb+DcUHIebpt/4PshFUVLUVyap7Oa/vb3TbFaeQuxpnsOS5UPN+Uhefrwrx72MLz187cMq+eBfuf6k2hzCg0CizCWFqma33yX+2hXQe/+A7odlWNr43Zp9sj/+wAWluiqbAgKvtAr1RtW+TjvsTpMFkZq7VM2+8OOzVnHxgJ6AbQvBSJrZ9A3vaEzFsnUrW9kMUkfMayAsUhKsTwmmaExBQWA9x4qnPWO/C44EXYcp+LheumR1OOu/wk+JkontNMmSvIjn3WP5vXVEgISgV4m3Bikey0sldL386dVkKnoGkigd3UuLihB+4K/TkUaIjohAltP3zaOXGx+yCKBoFAA35Ok+tyxNEP8xMBisC7ZGqHOQmH1kS2Bdag/3vpQ2wHckDXiWqdOg83wamYNdfTj+zVI4Rz8f/5y1IeD2JO3MvcfZGSNU6f/fDAgw93pggElXqDH2AWmrzycdUtKGT0dsP+nzbTgKe6RQUhSEFYML/BtE2aQTDEr04BxW9NlXE68FUwgEJL0rDMtD+STFVioRVRF0pNg/cYGvVsf8G+MhN/N+QQKp93hffEwvh8xLkVNF1Eb/bb490ksbRTBDbLuVyEq101tklJnH4cJ+QwI8pQzeoreW/xy3Zw0u6D3UZrA/0+6TDgcyfqCUnaFlAvWaOoscN9Hzqb9qQBaiBnziWoxGsFayeV0QXAkBDjQ9Jzr41GCSijLyzurTyg5KrYssO2i1FajuHpPm438bEglk6JyESKP3PUpuJa7xoor53z5GClTAyOFFV
 Pu6tBXky
 r1PrtF5EAo8OGJXkO1ufhRpGTK2Ch1//k9x3Jf1rXNQ03ge5PYJgIJli92Mcr6seih25L9e4N+kNUv5OdahgExgk83TWUfuk9u+uKHhGbqdhfSIv4WLOjeH7QrJuekDr9Gm+UStzwUH0p6BUraAqg2M5TVvIKcBsKjuRWbrvEzwsHgvXzD9eU1PSfnYPTiPNx7Q6+SMhEAe2GS0h9v8IxMXbckqeCCRJV8njr/bf3G/QbOLdiQlQIjqvkii+di3yd/d+SY2e0vy/X5dkHWJkjZo0RvzL5iLlEd+U01Zvn4lRWfe0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 05:02:43PM +0200, Oleg Nesterov wrote:
> On 09/15, Christian Brauner wrote:
> >
> > Say a SQPOLL thread is a member of a thread-group that coredumps.
> > The coredump code uses zap_process() and sends SIGKILL. The SQPOLL
> > thread uses io_sqd_handle_event() and calls get_signal(). It removes
> > SIGKILL from the pending set and returns. The SQPOLL thread breaks out
> > of the loop and drains its own task work.
> >
> > Any pending io_req_task_submit() with REQ_F_FORCE_ASYNC creates a new
> > worker when no other worker is free. So it ends up calling
> > create_io_thread() from a thread whose fatal signal is gone. That means
> > copy_process() allows the creation.
> 
> Hmm, thats bad ;)
> 
> But then ...
> 
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -2491,8 +2491,8 @@ __latent_entropy struct task_struct *copy_process(
> >  		goto bad_fork_core_free;
> >  	}
> >
> > -	/* Let kill terminate clone/fork in the middle */
> > -	if (fatal_signal_pending(current)) {
> > +	/* Let kill or a coredump in progress terminate clone/fork */
> > +	if (fatal_signal_pending(current) || current->signal->core_state) {
> >  		retval = -EINTR;
> >  		goto bad_fork_core_free;
> 
> this change is not enough? Don't we have a similar race with exec?

Yeah, we do...

> de_thread() kills all other threads and counts them too. Shouldn't it
> also check signal->group_exec_task ?

not just that. We need in_execve checked too because
io_uring_task_cancel() runs the exec'ing thread's task work after
de_thread() when group_exec_task is unset.

