Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D74F3C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF35C6B00A4; Mon, 21 Sep 2026 07:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAFB6B00A9; Mon, 21 Sep 2026 07:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0A86B00D9; Mon, 21 Sep 2026 07:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1A4D6B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:20:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 339591A012D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:20:17 +0000 (UTC)
X-FDA: 85237525674.16.8297144
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94CC3120002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:20:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4G+eyVJ;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789989615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kg/TXvOegdx6UJZ/kLCIs+vBCNA4Z77iTJNVCR7wKs=;
	b=Janqtm00V4fJLuclPFa4g/9s53LTdKVipLlDfaSLkRU3JKD98yiSgEBRiV4ZGjIcIPhyQh
	R1CuSFQnLVwAuDaBnDEs6RufO4XpMzIAG5BX0MBnhh5GyPmTz6/Mza8D+n1sR8E7/ig1be
	/t8Ec2lvMTSGqM6NiB/HX7XZuhudJ+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789989615;
	b=DGFleXR5Q+TJyMOSaBlKL95BLd1FOk8coYCg+var3DtvOT2C8+RGhEdekqupsRN+mnTgJU
	KyhdXcFLWQe7OEFIthEAeCptWSxNjvzhL/fyDmt5Go/FZPVdI++0x71eYN6lUnRAT5nyHI
	pmc9z4M96VbHnRDLR7xuW8xlwuUTZkw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4G+eyVJ;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1385E600C8;
	Mon, 21 Sep 2026 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39521F000FF;
	Mon, 21 Sep 2026 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789989614;
	bh=2kg/TXvOegdx6UJZ/kLCIs+vBCNA4Z77iTJNVCR7wKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a4G+eyVJTj1TD1yFXh40Wkj0vOwJyfJ2dJgvMdbOqEoy7IPUeeVXA2y4WnmvAAsni
	 Pq8AH9usOFsni9gXpy/Unnufp1BGPGx7zs6/EO/vakHJibOhWrChcyP3VuzN1TYA1U
	 CS7zm8uAomtHruXfTx06DLt0EiOdWmWaODscqnC5Eg3JXqBjPXDpK4w7axzRsAsEeh
	 QT0x7Ze8s1jer8ePBOvkNbfljBK0RLTixj1BljoQrSESB/HEm/FlGU3WIr0snFvqMQ
	 qkTERjAvODAyy5CSiADhF3/hgIKCmISmQLAAAvhBBGwZyX1rJFEQPoLlapT09UK+Au
	 BEfcyT/CrGpxg==
Date: Mon, 21 Sep 2026 13:20:09 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: NeilBrown <neil@brown.name>, Chris Mason <mason@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, io-uring@vger.kernel.org
Subject: Re: user workers as coredumpers [Re: [PATCH 1/6] coredump: don't
 switch a dumper that has no files] table
Message-ID: <20260921-programm-rentner-faltblatt-ec5ed7719d55@brauner>
References: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
 <20260916194837.3732307-1-mason@kernel.org>
 <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
 <178960987412.207413.3957049392884487413@noble.neil.brown.name>
 <20260917-zahnpasta-aufweichen-flackern-1182320f5c81@brauner>
 <20260918-tonart-umgeladen-gesponnen-519fca5172bd@brauner>
 <aq_4fY6GVtK47Njq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aq_4fY6GVtK47Njq@redhat.com>
X-Stat-Signature: imt5isbtsjmn4uosic6k1ukmzd7tb85i
X-Rspam-User: 
X-Rspamd-Queue-Id: 94CC3120002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789989615-603663
X-HE-Meta: U2FsdGVkX19pLMujJiPYEyy2Ms1dVf32FZQU2cFqJn3jv7RTPFfD9Wdeab6juMkZ3e/nOrKDYrEmesy/2rmgg+B3FY0w9iKzJwGWFU0YytNYt3ir5Ky+xgcMr3Q+kKcsubh/qRdYkl9brMR9nmSPRnKPR5Ha44IRboio/8cZEKJGdXw3j1g2KyyKJkdXiatzaH52WRp9+sXT43a2ZOuRkP/6ZMePbvDnhJG7d9+Spvrd2cLkBiIRiXP/TZfv4uazVs3vQqDvedtT5A3DLqx8Sfj4I4hiYD43lomC92gtaX90MQh7zF3Cub6Vi09jTZ4sPHupY+nj2nHOR8R/jox043YhL5+sDf7dZCE4GVTl+zxJIckImJi7Th/wCSpRQFVca9IQxd5Kns+oV4IeQZ6fRjC5Ok0ynkSbcbGILsf24QhW7UHJp+pRAaGOXyCOSQvxtSAxAdlK2vlD6NNpDV9mRzORbca4m3Ybe3kBvsmox6wZDreeVMe5Gl3XVRSJ+hotm5WzeNT0C9jsVNtfBZD/AsF+rC6gRYuWc6a3TzzJ/oDtcm8i1dMzloPZ3+12s2iycokXX4rkbvn3T9rJgg0SWVq9KUMuiRARzCoS7GnK7exx9Ieg6AIzHxYTLLTJQJfR0De5njlU1Pm6ZC7eA1/4CFlJ4uNOPisU3TkBtVLywcXJRSZL+7YY82ADWCvhJrzNl+9anbI3unCyYuncHlnLwxdEaav6myBJjG71PT35WRRpXLocJz5eW1QmEGOE9GmNOYd+yadHZeEktcdSktX71bYOlozrz8KLGw6ejmkwccmCdgJe+Wa3Pyfpy7q5xHGAtf1M61VXWOKYqpOtz+pENriohb0x+j+k17dOVCqC2AfxCQOFECqoQqMzjh8xNUJ+1WJQmT58xv8TIEEzmXubJxwiCwkFyRlrTr3gn4DbpvHi1YXAJ/Odn2iLdh4P7+dayNoIRB3HJxmBTpG8vsm
 fAWxNwqq
 tA+79mSl+zLAwsrm3RZpMYSlsFaptgyweCEeiyYTYayBQTizXiqyuh+bdo1C5UGrKP4I9h/4s+5aFls74nA6mlR2BzwENPbxPK0m/L4/Y+09O9oV5rOC+498Hn73ytJwi2L5wk1XA7btAf95f4lNG77fHYcL1IfmlClbjo2kfLCJ+LXcmt9sG89q6bcHHLz7OQMKFBqtlIUC+buJqZ3RHF9YM7f7IISotaTj77PkPCZxE3jUh3oAS7IpwAMHo+ffdMKHgQQHDMJ9jNHOiy0t/jslBHXZSwWy4SFbpj6CxU/OzzNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 05:15:09PM +0200, Oleg Nesterov wrote:
> On 09/18, Christian Brauner wrote:
> >
> > So I thought a bit about this yesterday and had some brief discussions
> > bout this as well. I think we should kill this whole bug class by
> > ensuring that PF_USER_WORKERs never participate in a coredump.
> 
> Agreed,
> 
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -3021,6 +3021,21 @@ bool get_signal(struct ksignal *ksig)
> >  		 */
> >  		current->flags |= PF_SIGNALED;
> >
> > +		/*
> > +		 * PF_USER_WORKER threads will catch and exit on fatal signals
> > +		 * themselves. They have cleanup that must be performed, so we
> > +		 * cannot call do_exit() on their behalf. Note that ksig won't
> > +		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
> > +		 *
> > +		 * They must not dump core either. The dumper waits for every
> > +		 * other thread in the group to exit, and a sibling's exit path
> > +		 * may in turn wait for this worker's own exit, which only runs
> > +		 * after get_signal() returns: io_sq_thread() ends up in
> > +		 * io_wq_exit_workers() and waits there for its io-wq workers.
> > +		 */
> > +		if (current->flags & PF_USER_WORKER)
> > +			goto out;
> 
> This probably makes sense anyway... but see below.
> 
> Perhaps it makes sense to change ptrace(PTRACE_SETSIGMASK) to fail if
> child->flags & PF_USER_WORKER ?

Yes, see my other mail.

> Currently get_signal() from PF_USER_WORKER can only return SIGKILL,
> I think we should keep this rule.

Yes, agreed.

> I don't think your change can fix all problems. Suppose we have a main
> thread T and a PF_USER_WORKER sub-thread W.
> 
> Some signal, say, SIGHUP has a handler. Debugger unblocks SIGHUP for W.
> 
> Now, kill(SIGHUP, T) can choose W as a target, complete_signal() can
> choose any thread if wants_signal(t) is true. W will "drop" this signal,
> its signal handler won't be called.
> 
> 
> In the longer term it would be nice to rework this logic somehow to not
> rely on ->blocked...

Agreed.

