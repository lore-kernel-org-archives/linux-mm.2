Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1368CEDA68C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E4B6B00C6; Tue,  3 Mar 2026 10:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689CC6B00C8; Tue,  3 Mar 2026 10:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C03B6B00CA; Tue,  3 Mar 2026 10:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 498906B00C6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:25:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A717137DDB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:25:00 +0000 (UTC)
X-FDA: 84505124760.17.E9E87F0
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4E6881C000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:24:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772551498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cd4IJaDBzDT6Q/LLPgkIQv8PHV1aQjfRqH479pAgYOw=;
	b=zniua1jxTSQjywzd9/cvf4w59P9M5lWvqEiSkzz8KkjsLzu9CZ446uscSysV0lLxnw2zMq
	SZDwynlQsSJVCWUm+OBEMz7snSzEdMQNkXK1cPsZhCMNXI7Y41Gev8CUw9HsGW4XRkkMMN
	Jgl/8HMizMLkc1D+sL6oAh4tYF4Ah94=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772551498; a=rsa-sha256;
	cv=none;
	b=JVLY3QBti4HZhFgmEudSlr4Czvs+wByvxtcFH4hqdf/b7sb5aBc/QfFs837rkTHz7Sb+pm
	mTFZJ64L5LYha0FVpvTrA6fb/igQ4ymMOhd58F6pnhRJgm2vIZ2hLkG77Layw+r4iKPqMe
	6NVSUvn89wH+CVwVyH3gjewlS8MP+cg=
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12D481B7133;
	Tue,  3 Mar 2026 15:24:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 9A45C2000F;
	Tue,  3 Mar 2026 15:24:54 +0000 (UTC)
Date: Tue, 3 Mar 2026 10:25:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, Qing Wang
 <wangqing7171@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@suse.cz>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] tracing: Fix WARN_ON in tracing_buffers_mmap_close
Message-ID: <20260303102528.744d57ae@gandalf.local.home>
In-Reply-To: <71c3a923-dc00-471c-9555-c08d5e135dee@lucifer.local>
References: <20260227025842.1085206-1-wangqing7171@gmail.com>
	<aaFrmHzIAkEe7ufy@google.com>
	<aaF0zS3xh5KgM_yy@google.com>
	<aaF-bhAIhCgusG9k@google.com>
	<20260227102038.0fef81e9@gandalf.local.home>
	<20260227155601.18ebd3ca@gandalf.local.home>
	<e4deff21-2fb5-4f37-a7d3-ede5f69a4489@lucifer.local>
	<20260302115220.163f1249@gandalf.local.home>
	<71c3a923-dc00-471c-9555-c08d5e135dee@lucifer.local>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/zCUL7l9k7aAQL9zP7zTX9PtIr2mrAw/4=
X-HE-Meta: U2FsdGVkX1/U5dGM2Ji56yBvpitHsyp/1MMnC/4RWiVNbQHmR4bqhmw5c7bj6a29vcZwVoZZZXpQ6h7pGSDYxGAWk+78G66Fe6b3cZybZzfatPp1Z7ZXi7YF26lb43ALlMHaOuLgCkYbWT0N0hiLzdJbdikXpWnnEPHDpks7DFKR5Mm+H0rgfJjn6w7lBNaAc6DgiWap1z/G+lOmIPWXc4ImvAqhyqzwzfyKEPVNllRfdyXIfnarjrNpGj52MmOQXW8FvTgNd9KCBNZJcfbGkgsouYyMTgo8aZS03U1cPNh5fwaRV6AC1QXo2yE/Pb67GhaRfiLbJAIpGhK6b3aXviCB2muvNjSFGP6ncgO2Bmy6JCm9latSXMnnF5ybXPHYHURLBsI0XOM=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E6881C000E
X-Stat-Signature: 3hz885ypkoypc367hso7gzicnnuezpsz
X-HE-Tag-Orig: 1772551494-105759
X-Rspam-User: 
X-HE-Tag: 1772551498-882818
X-HE-Meta: U2FsdGVkX1/i11fPUS790U3jRbeIiZ4LD0wJ899rgI1J2xIpEalFT+0LXUh5+Odi8N/jMkt7NGJymuFta8HgEGgIQaQ4P/2zdJrn1WjqIl6UmpXdwdeBwhU/R+jdfilOyPqYmx116xa41cUN4Y+n2yCydAyd1R+Yh/ORAI0aGdvQR/bTB3jLClaHiTfzCRyantJKG3a94xCkX6Wg0kC/oqqarnHp5dIwNzkjCikGTBYnHhlfirTfchvfFjdhah8K0H09kKSM+cnE0pdMjnPt1nCZ/hoaPb0kXSIChPsefmFWNr//Rx0vM2/HEydqHq2DxSaw7zW2CsMrV7XmIXEm3VwZ+0nUoT86FGgt4cosPLHQ2cdzVT+LFCI73zubvRE6bGUkiKCyzPXLDqHhPJu3fNeZETx/d61AGjLxU1AqRbyE3LfEQZP0iDZtf7gNriwlgWfmX8+wI2y+YnK6Zs292vt+w8+dhhYkVVb9Brv1iBiUYKxTvmky7bqLqLXUg/N3X9EiDiq5bdA24eNtZwcG04WtdeuKW2oEozggkMm7MgBVbR5DcduQeE5DiLMDXnms83qp8rBGBZFjGuSIKjNi6vlepjPWTPcRNB3l9RfPgyvpLm/P1v9QF+mkYIOnpQvMl8QPYlsZgCSC0OiyXiUeVI7bGgY0rlO/Qwz5fC1HlgP6NxJgKXAQSsRIN8/+kjQgE9wsoBnXhcFqatvlF6Jc+eqmFQVqV08PP+Pnd6KEg8An9tQeq1WEcdS4PdtNpQx1Kg3EOBqfKufho1dMfdcBmd0DX6n3An9q2k5pUvUvj2Ti7Yl1d7BzRnlccKGfFdzVZAry/ML8jEsEqVPlsL42xxcSFihQH1PF/7DzWMXhnWE5XrY248xWJ+wg4F6obCyu+sA1q+7P8o+X+Mm6wzTdkLDQzvmQhPLBIGj9P1wJ8J6J3oO9guLPzt2TEMnY8IhAg8+UY9QGfVvY63zwKu0
 voSHBFrV
 34Y228ccwyr4Md8g7SDoJVzmubjWOQN8tPztVIjkPURky0XqCN6f/kAOaKsVRK4KwtAlDyrip8AhBXy1IRbfYsRn0yhjX/8qgt+OJ9IvHv44QPF0SthcD7oElOIK8FdWFCb8Q3YAh2pNzn5+oVCKVGWEX3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Mar 2026 10:19:52 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > > Setting VM_IO just to trigger a failure case in madvise() feels like a hack? I
> > > guess it'd do the trick though, but you're not going to be able to reclaim that
> > > memory, and you might get some unexpected behaviour in code paths that assume
> > > VM_IO means it's memory-mapped I/O... (for instance GUP will stop working, if
> > > you need that).  
> >
> > Well, we don't reclaim that memory anyway.  
> 
> OK so maybe not such an issue then! As long as GUP not working with it wouldn't
> break anything?

Yeah, we don't ever use get_user_page() for this memory. It's pretty much
all handled on the kernel side. User space just has it mapped as read only.
The kernel doesn't care what user space does with it.


> > Yeah, right now the accounting gets screwed up as the mappings get out of
> > sync when it is forked.  
> 
> Ack, is that in a way that could screw up things from a kernel point of view at
> all? Presumably there was some report that triggered this work, like an assert
> fail or something, or a warning?

Yes, it triggered a warning. The start of this thread added a patch to allow
madvise to remove DONTCOPY from this memory without screwing things up
(by adding an open() handler for the vm_operations_struct).


> 
> If a user is explicitly going to an ftrace buffer and madvise()'ing it in random
> ways they've only themselves to blame for being so stupid :)
> 
> As long as it's not exploitable in some way I don't think that's too much of an
> issue?
> 
> It'd be nice to keep the semantics of 'don't copy on fork' if we could, even if
> some crazy users might override it with madvise().

OK, so should we add the VM_IO flag?

> 
> Kind of separate from the question, but I mean if it's kernel-allocated memory
> which you're managing separately it should surely be VM_PFNMAP?

OK, I'm a bit confused. What do you mean "managing separately"? You mean
managing the user space side of things? if so then yes.

Hmm, I haven't heard of VM_PFNMAP, can you explain more its use case.

> 
> It depends if you want to have a refcounted folio underneath though. If you do
> then yeah don't do that :)

I have no idea what a refcounted folio would do here :-p

> 
> In general I'd suggest supporting the fork case if you can, or just let things
> be wrong if a user does something crazy and undoes the VM_DONTCOPY flag.

OK, so don't add these flags and just allow the forking to happen as this
patch does (if they screw it up, it's their problem).

This patch is here:

  https://lore.kernel.org/all/20260227025842.1085206-1-wangqing7171@gmail.com/

I mean, we allow two separate tasks to mmap the same buffer, and they will
have the same issues as a fork would have. Thus, I guess the answer is to
apply this patch?

-- Steve

