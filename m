Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A6E4F3D317
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 15:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF91A6B0089; Thu,  5 Mar 2026 10:46:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99796B008C; Thu,  5 Mar 2026 10:46:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C67F6B0092; Thu,  5 Mar 2026 10:46:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 870396B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:46:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 267371C11C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:46:31 +0000 (UTC)
X-FDA: 84512436582.05.22B19BD
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6399B10000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:46:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772725589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz18BPhhLbrMFDeP9iesyIHVAdCDGwOouFhibJHXxLo=;
	b=edwqhb/tlK7rgJV3pJkSOewL4tutEhMSwJAPmGULb1goLOwcR65f3aqc1hUP1JluIku5m7
	eAIsEvdly/1lG+ezD8OVRj7TMp0CQufxn/KFXa3V+pPn9czcq1X2BMuG49iuvfwQc3iOrI
	wnZ+sHmxf945sK1GMKdjLJGxy56+ZsY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772725589; a=rsa-sha256;
	cv=none;
	b=DNodQM6uqJqp1IJ3qAj2SljlmrBpnagNmOw01wixVhDtvwaDOMjkwGFdWceNRq5SioKJi5
	DEAhXm1ZPxQmeKo/ptu0kpKek3zQc3jhbTlc/XpeyAJOs7I/syGa12wbSSrOcmiF/EbrZU
	8PcT83uBmQ2AvTrOtCUsceAmq6893Nk=
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4AB9B5A3F;
	Thu,  5 Mar 2026 15:46:27 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 5F5C918;
	Thu,  5 Mar 2026 15:46:24 +0000 (UTC)
Date: Thu, 5 Mar 2026 10:47:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Dennis Zhou <dennis@kernel.org>, Tejun
 Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 2/3] locking/percpu-rwsem: Extract
 __percpu_up_read_slowpath()
Message-ID: <20260305104703.2a1e8151@gandalf.local.home>
In-Reply-To: <20260304220223.GS606826@noisy.programming.kicks-ass.net>
References: <cover.1772642407.git.d@ilvokhin.com>
	<6b1f1521ca186d5c402a65619d8f30fe83b93bf6.1772642407.git.d@ilvokhin.com>
	<20260304220223.GS606826@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+HpKi6jg9NxZeYvZzvI5zrlCwxsTFUgfk=
X-HE-Meta: U2FsdGVkX1/vo6T3T+yuIek1bKKSMPqW9ClvKUbD/u9KLUN2zrHj7XRTbFeVkRtaSFZUOkw0539RDqNm6B207m1bk35iuxf4EGUTuw+XDhzWoTOU8tj3v9jYqdnTLTT7VTiqb4HXVp4wE7ZDusaVw70vI16AfZWUaKQPfB3VZF3sm0LMDmMBzHshvIh7eZRl9Sm5PXhFImNF/H+YoC2hp8sDcCRc4CkqevvjO+kSmbfHywomSMfO3lSy5PqSg6i7dSStj6O5q+He0it6WCjhMI/77NpkQXNdYrCifzUVrEknKsDZEaNkAo5avvJcKA85+SP9HlWuTo1GcfqwE6LBAXHndQewr22fChGGaLE8ghkvpTN+ymuojV3y960dI67n
X-Rspamd-Queue-Id: 6399B10000E
X-Stat-Signature: xogyrag5siss1giwi7cwggcx8feeg5ur
X-HE-Tag-Orig: 1772725584-160659
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772725589-457891
X-HE-Meta: U2FsdGVkX1/8D6VZdeSfLlomF8XeCuDBMZG2cJ8oWry+R6YlVntBODfOgGzSz5W08Il6OL31MaJ+lgQtGZcmuYDPfCfVHmAuMFHSUSnDkbV3ciJtSs4hjz6dkkmdvIVL4vabqVx3D120R6zrIxqs1N8rjaBZQCF1X55B7ZneQ9hoKPCbpXukcqhf/9VPJrU4lfYpUt4j776vDypgXgCsIfr7EUEqCBamfdurryMlNcI8xSnw+mgFyYyPpPJvhFAD+PTW0/cIw/fyhFq3+CZwpMu8ogBn82qewRLwq32HkI2C5vDaZVK6MFOdDLQSWtgnAshIA3u723G6ZXCWGZ+VVHvvFnAVxfb6eglu611UPfZb+nZesChiA1L4JKodH2ZryZE8NInUivVoNExKMTESdCtXqj3VVdbz4dxwSLmi4+VIYti9XM0S4zgoV+ZGsIWcAp66YyKG1eCUuJEIpDNl69FXEOnJ2OpPBTqFJSccxXqZ8f4uduWKvn4u7v23kuJ1leTA70/GljGI1Nghg2/4O1oInTHbH9rrMoWCSPC4rtG+2oF2IsTWHw64po1swtJSYkexoooevo1uyirXpsysY8dirYbr9r0JKnFtuf+6XPKMPNo+OqDAqJShmmcIan82NGnaSEw6zQb5lMGHDv/9h/mp8jAhk/Oz+UrmFzIdI8nCVOYWS6Z+Y6+ULW0m9U65zToYQHogJqaJ8Qj5n0fedHnLHs/t0fMqIIO6sjYSpCT4fqTGMFAnkbPsOu9B+B5/LwFH59yXHbyeLe3lb6zXIcMNUF7qc7eHJRQfj0UzeCKl82rGM4vTiA1qHV2d3aahqLgFxP86NF7GKMp/FacMLuPIz9LXkrTzD5Q18f339VNc2sSKJfYu0mqiTFjYFA7xpVVQJ7uQNMiNrNf8IG96SdgfBJ8NndO9iRmNfbXy73n4MdgvN+IHnptp1ifzmksU1n7ZTxmT8jGpvhCAdP3
 yzjYzr9q
 iZB7PP6Ik6DBiv1vwAN2SdkfbS/nCsuV6Y17xR+D6LZ4KdAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 23:02:23 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> > diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
> > index c8cb010d655e..89506895365c 100644
> > --- a/include/linux/percpu-rwsem.h
> > +++ b/include/linux/percpu-rwsem.h
> > @@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
> >  	return ret;
> >  }
> >  
> > +void __percpu_up_read_slowpath(struct percpu_rw_semaphore *sem);
> > +  
> 
> extern for consistency with all the other declarations in this header.

I wonder if a cleanup patch should be added to remove the "extern" from the
other functions, as that tends to be the way things are going (hch just
recommended it elsewhere).

> 
> s/_slowpath//, the corresponding down function also doesn't have
> _slowpath on.
> 
> >  static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
> >  {
> >  	rwsem_release(&sem->dep_map, _RET_IP_);  

And since "slowpath" is more descriptive (and used in the rtmutex code),
should that be added too?

-- Steve

