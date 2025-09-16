Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C52CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286E58E0005; Tue, 16 Sep 2025 14:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237DA8E0001; Tue, 16 Sep 2025 14:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D3F8E0005; Tue, 16 Sep 2025 14:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 059C78E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:52:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8164C0260
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:51:59 +0000 (UTC)
X-FDA: 83896007958.13.22AAE0A
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf21.hostedemail.com (Postfix) with ESMTP id 020761C000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:51:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758048718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F413NCqhhZ3zDqhuVV3cXM9kJR9Bks2wNiNw2yAzbRY=;
	b=0ix2pvB9UkFBSv9/NwPw7Z8IZWqCsAdVqD3Wl0zXvs13pk1+hKi4zE5FePI9r8aCgbJ89Y
	AosqouNpfA7HTkZMQ2oyIMEO7x9bw5FeubbS5TFKIlkDgqAyIGmq4J24UG1f5seCcDqLu6
	fDzmjClBvMcXerI/7NB6+oLVXDDYUJE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758048718; a=rsa-sha256;
	cv=none;
	b=gFtQyhrtR+/q81nXEiMQFs1l4D0o+GR7nAjtm76LgH2xAJTI5rNBWgajE1EXMkUXs3UD8u
	/DhAgFfCSTkalCxFy3LJrpoBdONp937lq6Wqla5S+OTzFFsg7yL0WYgghqiGAv+Fbgy+7n
	cSGHXvAiMjQyS6m4mx7hyyz0UdkJlGU=
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41DBCB6F0C;
	Tue, 16 Sep 2025 18:51:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 76DAA8000F;
	Tue, 16 Sep 2025 18:51:47 +0000 (UTC)
Date: Tue, 16 Sep 2025 14:51:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org,
 lorenzo.stoakes@oracle.com, david@redhat.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de, kernel-team@android.com,
 android-mm@google.com, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded
 trace event
Message-ID: <20250916145146.046f56a8@batman.local.home>
In-Reply-To: <CAC_TJvfAQDiL9PydWnKE6TDMcCzw0xrsLMZVZLe6eO0R1LODhA@mail.gmail.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-8-kaleshsingh@google.com>
	<20250915194158.472edea5@gandalf.local.home>
	<CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
	<20250916115220.4a90c745@batman.local.home>
	<CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
	<20250916134833.281e7f8b@gandalf.local.home>
	<CAC_TJvc6aqjBRZ05wyGb49AU+-aKpSph=ZSk3fdV2xraXi-_nQ@mail.gmail.com>
	<20250916140245.5894a2aa@gandalf.local.home>
	<CAC_TJvfAQDiL9PydWnKE6TDMcCzw0xrsLMZVZLe6eO0R1LODhA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18AaF19e3B9PdxiVyBsClWhsh9I/89dalw=
X-HE-Meta: U2FsdGVkX185Jk6EEAUV8t4XubC8/kXNROIjXRupcelR+hH3LPjbVvHzsC//ioq5oS07dWS2t7cQckl27RISrjNCA88UBb0WAorl7tjjsLJmAKwUX70maRG2rX9HPTBirBDH4VHEimIgl8f+sKXSAQQAFna9voNks/f8vy1zMr+7hWy7EAKlbbNCjd3jVgdRV30jSqdSv4iERGG1Z8w+dpwGGctTjQ9PNTMFD/16TifGmYPPyAk/4HUaqXfRy6P5otXkNPqkDkKMf59MRJxuHUt4InKNbMuwnay4dXCncAd6/+5o9+JNFiLY2MaD0GVL7y7Xz7aYj1A/e4MnaFiiQ0W5uB2CRAwb
X-HE-Tag-Orig: 1758048707-555230
X-Rspamd-Queue-Id: 020761C000A
X-Rspamd-Server: rspam05
X-Stat-Signature: zhgao48ed3ybtbf99jtjrd1dnjfqei54
X-Rspam-User: 
X-HE-Tag: 1758048717-351941
X-HE-Meta: U2FsdGVkX1/4nYapvRsvecTK5eZK+qP2g6QFA+yVGPgG8tGtUATjTM8ttZpKwPVjKGkLTx2BR/wHspwXJmkqGfY/+ntGFE9xAH4TfL59wiRQKrgV9CL19Jh/lGOYqHWkW27+fz+LgpBA/QkSmOw083lyg/Hc3gGqPaTHEqT0Pndfggjmy8SCUFrYztKcQdnAXxe3gQapbJK+s2dAQ89eLRubtSnEVNzezkN9Xfof9EW3194ECEKh+orzjUIgM8rVClk2Mg3/Nrkeo1H3yE/jDvswIQy9GjNJMHzTgnw/WoJkHjPxr3Se9aPilIadLxCi+oXYdF+FhOmof5SwcHRWh2y9nBagbiN+YBih9OZ7pPbz+OneHNtK1PLqyHcttYoJjRY3hhCYx52/q0sbgpUwp+oUPyURd/K2d5etlA4LD3z+ops++OXRiVN+X1As+0qAUq6rFCgRl1/uZeBaxvOoIlGFD/yJ3aaUgIJLq0kGrbG+owCFBwjpJ07LM4Pd90iQY5c7WIhSnQNg8tSvzWJudSMGByiP27ltH0kMLLy6XsJUiVjpokqeGkb8fJy78vzXtwMVpyHwdvijgfPa4+skgedeC44j5TcDiQnPc+CBpFXiBrFtKq24++ft1nXvIgLtaehHZg1M0teAS2YHUHqMBRvYdWuiAuINwUwq5UoTMazx67VhEqzhotJys+IpJbgooe3hGUx1sbOFpzcAdTrj5D2iOsDwm9+aJqSOo3C0i98FLN4bLHclc7Oahsazwuy6Znw1iEIeIPT4yZhxNMtva77rtOYQqpsBtEp+OWlIHIbn3DqXI+ThIhoDBgSkcUy44e3JRIvUC7XkQWegaFLVOlRHskZX4qqVjgjI9kAWQ/4Z7+upNXfb2rKP1caRFTLl1bVWnwaiVcym9MyzMuy/dGokWRlH8Cm9rRo+8J87Gp2lqZ1YKfZr9icgm5BmvLhM/JvO8Qi/JrMk67lFjzP
 OzjJr6bR
 MprlA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 11:23:03 -0700
Kalesh Singh <kaleshsingh@google.com> wrote:

> > When it comes to tracing, you already lost. If it goes into the ring buffer
> > it's a raw pointer. BPF doesn't use the output of the trace event, so you
> > are exposing nothing from that. It uses the proto directly.  
> 
> My understanding is that the BPF tracepoint type uses the trace event
> fields from TP_STRUCT__entry(); whereas the raw tracepoint type has
> access to the proto arguments. Please CMIW: Isn't what we'd be adding
> to the trace buffer is the hashed mm_id value?

Ah, right. Can't the BPF infrastructure protect against it?

> 
> >
> > Heck, if you enable function tracing, you are exposing every function
> > address it traces via the raw data output.  
> 
> Right, security doesn't allow compiling CONFIG_FUNCTION_TRACER  in
> Android production kernels.

Does it block all the other trace events that share pointers?

Like nmi handler tracepoints, x86_fpu tracepoints, page_fault kernel
tracepoint, tasklet tracepoints, cpu hot plug tracepoints, timer
tracepoints, work queue tracepoints, ipi tracepoints, scheduling
tracepoints, locking tracepoints, rcu tracepoints, dma tracepoints,
module tracepoints, xdp tracepoints, filemap tracepoints, page map
tracepoints, vmscan tracepoints, percpu tracepoints, kmem_cache
tracepoints, mmap lock tracepoints, file lock tracepoints, and many
more! (I got tired of looking them up).

Again, are you really protecting anything if this one trace point
hashes the pointer? Most other tracepoints expose this. If BPF can
access a tracepoint entry struct, it can access the raw address and
break KASLR.

-- Steve

