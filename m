Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4FFCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2E36B00B9; Wed, 20 May 2026 11:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3C86B00D8; Wed, 20 May 2026 11:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0B76B00F5; Wed, 20 May 2026 11:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 108736B00B9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:25:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEC6A8B5A7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:25:00 +0000 (UTC)
X-FDA: 84788171160.15.53F34B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 402792000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:24:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlIZFR5T;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02VulsBrQ26KxkFy1uLs1usEbCuvcLCxXaVCS5AldyM=;
	b=2PghpcQbYqvoZ4uRmVUUo3DxY/tCvkgKLfS6EuWyfJg68L1EsdgYLCR2FBxBxwMYDkge6P
	IIbcyNMLtBttRLs24dAENPzGjUfXh0vtdbjffBtpsIwxRIjxPLW6VQysADKyeiNKrqQSRL
	rM8z38nxK/OayWgaOObqHqbKQeOvGVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779290699; a=rsa-sha256;
	cv=none;
	b=IkTUni294W2eReoSQAPBtzT9OdSKhYsG7yGf3z9ZcKYyRDz32BaQKP0ffps51+1iOvkEhH
	nQfiV1HngCxKBH95AOzFcxApV8E5v5vMWQY3BNjmBtlUxOzbC567FpnXSY9HAPznaE/N6m
	TCDggmAEuAlROdjzT5bxDKyLTTk1ASs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlIZFR5T;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 903CE60008;
	Wed, 20 May 2026 15:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99F31F000E9;
	Wed, 20 May 2026 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779290698;
	bh=02VulsBrQ26KxkFy1uLs1usEbCuvcLCxXaVCS5AldyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KlIZFR5TF6TtvusJyJ4yFS4cuEhbk9h/NzbeT75W7tbJBnZQbCbiv/faTy6+r2+Pc
	 SJpdPj4oj9UoBwJQJYY+dfoHs5a76V24q/gIDUdkDrm1r/wqKVZS9xf7bzsTg3o8D5
	 zubSst9b/h3Vx2yftYnaSpDU5isvV6NnMCq/iUTRAHo+U5ZCFYpRHC+WQ4v61gdOD/
	 k3nlfCiUYLOIaI+YMbhNduxacBrBFDOxv/fpSY7fB8mHZF0JTsZHfuqLq+Q/HUtDBo
	 St+Rt7T1LQUGkW7iTYXBMsJubAlYAxSPd8H0HRxjKOwUif1iEBja2CVj+H0lfG6Sts
	 hIEAbntI0sfog==
Date: Wed, 20 May 2026 17:24:52 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2 2/5] exec: introduce struct task_exec_state and
 relocate dumpable
Message-ID: <20260520-tragik-ambitioniert-11b687b5921a@brauner>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <20260520-work-task_exec_state-v2-2-9ea88ceb09e6@kernel.org>
 <CAHk-=whDUZb6WM+99_aUuTK0n8UZYEbm7Y6cn2nbXp4oO+bNGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whDUZb6WM+99_aUuTK0n8UZYEbm7Y6cn2nbXp4oO+bNGA@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 402792000F
X-Rspam-User: 
X-Stat-Signature: r67xwhax5fjwcqimm7bpk5bahaoq1oy5
X-HE-Tag: 1779290699-598565
X-HE-Meta: U2FsdGVkX18NSy2zHrS1hmGf06oGa2pfJfML4XwEJy3rYzX+STmisLUIB98EBe9qtG+gIPlfGzH/R7RYeY5mYxKnh/4cdzlJJHqhhXCG5cAsexWRwnr/tG7ttWs6gQ/UFpOcsBw2oBRev1VT8MF1+6SCkcnNVejT18SPHsnnh3jD3R+4kjcjSsB7tLN8kB14NZvSjSLiiLNRSB5ILwuEBqa797fZf9uYqkjb7PkA+WBgzC8DpoPFQVNiUduplzcx7FhY3V2aSvfdPCVKquWgeNgms6+k7Xf+6krNBqDA28bFuM+sAPMvTeGe9KrLLv+lUzEMvL6zlrMzD/Rkrx6ccagG1Qdv+ApjdcJh//lE2JdoYO9T/f3ll1RlkpAIfwf3Fxeo5VgytYKdW6MdQkc1os3gWkn8Ej54pAl6G56jpOBNHUrAMpil92LsY9HZPJp8T6z0K7u3uo3V93fDfolJcIguuCnvjqkUVL3iEd5Q/mCllBIEMRkLIZzuoP95ZFlQ0tjdbDddKwKVzXj7AA8DF0cSMyxp7U/SbpmjTNvJSA1Ft8Byhe+aM7lMn+xR+f68Hn1OV4N4PXhE4w9iH7jxh0Kod6byaJLBz7RR9m7+gJmskZmyuZbgCaez5ggNZ2SJa6oj3Kw/Gav4AMDwES/bO1+uXMDah1y8kqf9jZBcSYRHXz4ZcRdGi1l8KUXp3ihFTkgDI5mjFdC2QswtimmiC+JMQNvASw7MBLq/EBgUdonyeVdpFD8wTM4mjafxKW1JukJkA4uOnFnHoNKgg8T2fMN5G4Pkt/2YD5yXmDwXMc5r7OdnzY4bYhj4eDOYnYLbZ0SisUJjJNyLs+3FWwb8pHxYV6WituiO0UhdDaC1081AdYkWkLFY1DR+8AmtvKax0cOql8p+wfQwzAZQDkbms2LlN6HidOAmJ3Mmvhk+Wptje6ik8Dg80Lkh1UJjJF6FU323+M23rSRYPIOAVwR
 r7m+XZUA
 DdbjwVoagLXfl/0X1jbrFS+QhDuZZeG1HzTfaTAxycEnYt6vYijxcUgRsHhS1bTCmTk4yTQJZAvLQh5o6CyyAhpphc6cplepYC4J6ORZTDQz36itGCdWARsMkGcgTAlu5I2sbuIouLOTTyDdvGC5O7j3sMu6yfdD6zmaVux9Y2QHe9qjZgHSkgqFofMvTv/bOiVozVCXoHTJOk04EQpr5r3UyM3GK7Pghu4nSgXNTlPLZTOjavC5KPb1sIHJlk07WYW2toY59lCARg8h/xHnbABTqGo2ZxcOp6JjKWwK1yqdO8H2m9c8YuDIkTBV85ObKU3a6ciSN5G7e+kTyvwsnTOjHv9kug/0gzFUPWi1OKDgJ8EjWm9uUyaxl5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 10:14:17AM -0500, Linus Torvalds wrote:
> On Wed, 20 May 2026 at 09:43, Christian Brauner <brauner@kernel.org> wrote:
> >
> > +struct task_exec_state {
> > +       refcount_t              count;
> > +       enum task_dumpable      dumpable;
> > +       struct user_namespace   *user_ns;
> > +       struct rcu_head         rcu;
> > +};
> 
> I like the whole series, and it all gets acks from me, and I just
> wanted to say that maybe we would want to - possibly later - add some
> more of the bprm information into this structure.
> 
> I'm thinking of bprm->cred in particular, because in some respects

Yeah, I spoke to Jann off-list about the same idea of a creds-at-exec
primitive that would come in handy in various ways... So +1 from me.

