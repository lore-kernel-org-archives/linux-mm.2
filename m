Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16F3C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A0B6B008A; Fri, 18 Sep 2026 08:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B426B008C; Fri, 18 Sep 2026 08:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B604D6B0092; Fri, 18 Sep 2026 08:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9881E6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:24:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D95191A063A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:24:14 +0000 (UTC)
X-FDA: 85226800428.11.781B07C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 53D791C000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:24:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzoCNVPQ;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789734253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6oMeyEK/1JyGwnyMfukKkQ88mHLG2Cz9KdlVILMP34=;
	b=gUQTfonbfBZnB86GFF2i0g515CWvj4lChTUjETXi6CDc/XlXFQtyBq9MH1cjnhYeLFdvEb
	RDRi2YlVxncwxA5Uf9ZBmatTKD4ZYWevHmoS2+YgfFEmq3mpj9VT30p9z3qsPVt6ci1zdl
	4QWX5uKuw1Wkzi6wiun2ekWZeADxNEY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzoCNVPQ;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789734253;
	b=ihhfHTuhO/0ubRJBQY3fTEyd2jVlF5537FoUO4AYF97h0n69Xn44faL5OvkxDxc+8nOviQ
	41ZrUVygLvMc4VikNNud5ShuzCLUAPSmyB1sLW8ISuKYb6hZNGyAFIDXapOfrLslh5WZPb
	L7M1R4ZMu8982lSrJMSirEsHjSQ+PoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F4674327A;
	Fri, 18 Sep 2026 12:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EF61F000FF;
	Fri, 18 Sep 2026 12:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789734252;
	bh=Q6oMeyEK/1JyGwnyMfukKkQ88mHLG2Cz9KdlVILMP34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UzoCNVPQCiXKBTYtowh0ZR/LLXxwdtOWPoKneKGSAqYgMe/WyRWSHetaw5EiwvjGR
	 WeJjNKZGrrIKcTSvmpF9VUP7qcYlgwmR+JOMpRHTLxGy4gvjeGqsqYoW1dqqJtpRsQ
	 pLRV8irhFy6iyo7XbFIlM0X78irC7zNhMx7hrAcrZuH2mE9R3FGJsGhauhMMXRE0nv
	 u7NAYalvWl01s1XENCPDT0fZQGWMwcxcPTXDtkYUbnhW0wFCBhfqv7L4OZygWUlzpY
	 3iXAodlCgCOPfV6hy0tzot8Vh/NWc8PNRMLoj5iJ4JCbVagqL7TOphRI1Soo7q/i9h
	 l+YtUxsU2NFHA==
Date: Fri, 18 Sep 2026 14:24:07 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aq0VLTyxNatFmLOK@redhat.com>
X-Rspam-User: 
X-Stat-Signature: dh4dgtshekqy6asejnikmrohhdikuowr
X-Rspamd-Queue-Id: 53D791C000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789734253-861477
X-HE-Meta: U2FsdGVkX1++OtiZv/MsYpx+8uNYlDF3mz3mR1Sy3piDREKembD221Z+CN8sjAM+0W2Z0iuhVOgo1QfTumNLx7tfeGBBMYK7lQg0+MD94CGZpfqZBMnStv5PtXb7gec6z0otYrdncQZgyI7LxiXVTLfgicwmcUspgUmU9QCOmggooq9LnmV6zFiPWexUV9s3uzScwmoNgDc5ATUf+YbD7A7hISaXyyyjuSjizKDWrntDTLps7If8oVXbNDhQJvZjqineU9zl7+rFN/7mDDsF54GZO5fXSaeE/tYVE2oz0DOPXOduNlwyGNlEn0iFD1qpZtkYrYWTpBhWrxEnGrnhamrujXA9eqMFSwbAnhNa1ZV9GZ9uaNglrfKUn56OeQ7OOXctjUKkCFgtpBire+jZ5Q0nBTX3Iu093j5AS+UUAyfQWa5BmcG/tHoVBWkL45/B5EDijZ5IH87NeO/8H6BwPXLuqC0r6jokvxbAtPMQQWpBkONAaRI7CbaW0m8QyV+WZGDEP/sWDmuhnALHx0CMWox0hhe7gV6B3kSLzZIJogk+gIFiX+CJ+5dpoprvInNkS6LjP4IbFupfMqMg6wYuYkbMpxor6gYT14ZwdleS2yU4Dy02Jrf8ffJTrD7KysNpItQ4WgnPbpTex4GiT0L541jQM+nLN8iv8Lo+ucEEKYhk9PgtUcdd3MqAArm7Fm3V1OuXj7NJCscym9G3d2RYtkQl2reFfagZQcjvhKvO0WBRjFvqpqhdQJ36O9GTuByOi6erbQQMrzN+M/dg6hlk+r+8SZiTAWhym+vK7ZfrcH++lq2q23gtcHWDFmcGBxsz1R379VxUNahjQYNY0nExKJQRdsOLtURo6nXb5hRS0aoiCrGzwk6evm3UIlGdSTRwRTgC5VwoNgSoRwlUv02DhfZxouNqjkZPRBW5gKdO8T4G1xeWxXkO8PlzVKrx1wCQkZ1yvXKpTO3WAPH1QHO
 9N2Ftg+I
 2K6ZLoBNpO0uCpGXdWksRITzLm9lYsCtihzaEkP9J2SnvphDo2spDiBDpD2s1Av3E/QC6cwlPZZlSZFiFz4Ga6vkztOg7HV0X07j3aMcXDuydDDprJTyeqYp019+gzKWbP/6V7NLvRGYgDuuFSa/KJ4ZrkMhf/1QzIFMZtmKEqCm9rUfEDbiZOi9I51/5coJVaj2wEWF1X4DTzl1rKQ6gvMRDGIrhRhUI2ZoaobOI4Prx1TB29FdRbNwM2X6N2sQ6EHFWg0Dl23m7NTrb6C7YCp38g5YTEFrzEbyhG5e+iOMj/Ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:40:45PM +0200, Oleg Nesterov wrote:
> On 09/17, Christian Brauner wrote:
> >
> > Say a SQPOLL thread is a member of a thread-group that coredumps.
> > The coredump code uses zap_process() and sends SIGKILL. The SQPOLL
> > thread uses io_sqd_handle_event() and calls get_signal(). It removes
> > SIGKILL from the pending set and returns. The SQPOLL thread breaks out
> > of the loop and drains its own task work.
> >
> > Any pending io_req_task_submit() with REQ_F_FORCE_ASYNC creates a new
> > worker when no other worker is free. So it ends up calling
> > create_io_thread() from a thread whose fatal signal is gone.
> 
> Oh.. Can we fix this in the io_uring/ code somehow? The very fact that
> copy_process() can be called after get_signal() returns SIGKILL looks
> very wrong to me. See below.

Yeah, I agree but the io_uring solution I came up with all where a bit
involved...

> 
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -2491,8 +2491,10 @@ __latent_entropy struct task_struct *copy_process(
> >  		goto bad_fork_core_free;
> >  	}
> >
> > -	/* Let kill terminate clone/fork in the middle */
> > -	if (fatal_signal_pending(current)) {
> > +	/* Let kill or a group exit, exec or coredump abort clone/fork */
> > +	if (fatal_signal_pending(current) ||
> > +	    (current->signal->flags & SIGNAL_GROUP_EXIT) ||
> > +	    current->signal->group_exec_task || current->in_execve) {
> 
> Well, the comment doesn't explain why should we care about exec or coredump,
> if we forget about the problem above fatal_signal_pending() must be true.
> 
> At least, can we move these additional checks into create_io_thread() ?
> To not uglify copy_process()...
> 
> Hmm... get_signal() sets PF_SIGNALED before it checks PF_USER_WORKER, so
> perhaps something like below can work?
> 
> And perhaps io_should_retry_thread() should check PF_SIGNALED too?

Hm, I like this idea...
Let's see.

> 
> Oleg.
> 
> --- x/kernel/fork.c
> +++ x/kernel/fork.c
> @@ -2700,6 +2700,9 @@ struct task_struct *create_io_thread(int
>  		.user_worker	= 1,
>  	};
>  
> +	if (current->flags && PF_SIGNALED)
> +		return -EINTR;
> +
>  	return copy_process(NULL, 0, node, &args);
>  }
>  
> 

-- 

