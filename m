Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F3C606A331
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=mYfWrggO
Received: by kanga.kvack.org (Postfix)
	id 13A2C6B05B4; Thu, 26 Nov 2026 04:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111146B05B5; Thu, 26 Nov 2026 04:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DD96B05B6; Thu, 26 Nov 2026 04:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB45B6B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:44:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60D17402CE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:44:11 +0000 (UTC)
X-FDA: 85476784302.07.D684287
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 33F5F1C0006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:44:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mYfWrggO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795686249;
	b=iUvya6kERY55UJ0VdK7xpaxFkxsgb8SEIY2nCQ8wQpCMof7PS4JU9zGgK3kEwbaEZSLDFt
	5skwJYdHAqtZizFe9CtpZhxaHdI+gDmS+r4XhXDlQWGoV37ZqWhJ1DW+nVEcs5qHBgVeRZ
	LYb1iT1IhK+1MBnpJPFv9swdn4MtM+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VJC6n1hJwExr4EuZxRtgDyPGN93jbJ5pGv3/LKWlIo=;
	b=44gIT3TsOucvqfXf8LXkuQhPSd5HR5HXqebbwsDO7jky7JnT/H3Rj7kX617aWbGlAjnP5q
	oEn8al76AFdQ4hop0oZIqC8SFT5b6ysKupGsF1oN2TKMS3pONsYWhD96XX0a4Q3MRN1Nm3
	+IJNCZfR+rkHaP09refNGkJBih+oDgs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mYfWrggO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5VJC6n1hJwExr4EuZxRtgDyPGN93jbJ5pGv3/LKWlIo=; b=mYfWrggOtGDgLQkraxk8jwrHB9
	I0YDFhk6XT5etnPyoX7WtgS/UG7Y5XbpzoWR3LOGdonMJL6mlPpFRrsmoLV/k8taYMZpY+Pa3aAvV
	6ONbVWf3P1iUw7L76jKLpH9pX+NQr/HDb54L4qzairth1l7jYLEXFjS4TjwAD1jyxYAQDESMcFuvD
	iJtGYxRCQeuauFaP0vlRuko+VUg0KLUOXMNo0CH0Tch0ZCy2UtzXG1jR7E/HLKtyrh9c9glWXBWPM
	J60mFEEn5NaM2khTXcsaRRwJTjIVyBN4pS1nwgG3EBhoRHkYj8nBFUEMb3sxB1aN3Xgu3zL9Rc7bP
	kQpRBbkQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWW1M-00000000Ch3-3rUU;
	Thu, 26 Nov 2026 09:44:05 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C61DA300446; Thu, 26 Nov 2026 10:44:03 +0100 (CET)
Date: Thu, 26 Nov 2026 10:44:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Harry Yoo <harry@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
	bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, daniel@iogearbox.net,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
Message-ID: <20261126094403.GA49833@noisy.programming.kicks-ass.net>
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com>
 <awWRZ9xCzWLnj_R6@thinkstation>
 <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
 <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33F5F1C0006
X-Rspam-User:
X-Stat-Signature: 64pn3sgqztsir6wpgz98s1ssmx6hb9px
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795686249-388153
X-HE-Meta: U2FsdGVkX188FFfjmHe980+HW8S8ZwyfLdLZUryTq3YY89/mRkKtbuskkUhMRP2kNH5VbogVpZ8KieD/Xe5RmZLxIirT6rAuWGQgj/lw1JypImI04ZPzjXaTuU3iLaNi8Vvx4m6qjlmWUYc5emw5zRce1V566HvaoeDT3SZOg3cWJ0unF7mp4m+djWZCkwlaKXevphjuklTwThqXLdxoNyW2yb8Zu7OhsMmH6vOMDOLmHkCBOGVYBxjIWRXK6XYPqo+fRN2POR/9AQV8pddQDS1P6XOtOpyI5+TwVZUxFUG8CoaSy3szViTB1Ck55akOYteGt/BIWsIBYUyO80nnX02n/LY1MVlhKpv31scTCKLlwsDbDVoNPtEjFMUdHh/Vf3Yb3WUfIE3/92ac6xb/nxUqNdd99eMoCspa+9hrsfY/cS154R1CbkooZ66HXsiRLR66wyQStI4o4BlA33aGEk9QT4m7tjgeSksbnQL6bElq0KQ2A68vZNsLQf8lc9K8K0tMRauE9GB87wlOj3hRIAeQN7la+o1ER2TjTW8+xV5Vp9bWN0cCI8N8IUyFNAt8rx7AqrybIqolfu5U/wmCgVPf1QeTLhHOW/wjIpxaXl0nfD8fQHw7b8fTuI/dWtx1EGSPZrxpUGkrPzKu9eHsyRppT8Pl2sfs3Z62nDC6LMNhCiVBhtL6T53MUMcW7dTw9mZVKQmh5+ktqio4x17TYDV9l24eIWEMYQir8Bsm4pKParcbKduTk/lW69gKpy0QDQYT9w2XgdkRS/wrjTSraaKR4kjwmQ0p3jkewgEXUzUbi0wmuUkxmRUcq+6OYJ0HBnkDxHQwnEIubkzOPJpvo/n+lNhuGpmIyXEhiOrnROSsj2YwrKBvafZkeHmdgqFFPpMGQfQ9jlIm2cPkuLK7TkCpoRUcRxN7fz+SDAFjvok14ckJFuF+au9QpXm99XhdATBlLBK5syQqDEpYvDj
 uOgy3bS0
 mxT/a7/QRMdkwk0Fa090xhJjljFYL2TVEOGN2P8oZPc+r2eaHcWMH69vUSkmq2HigZzFhmPNKZCZ6P4k5gf5tCIFZ119wQT8iUh1Nl1hutUspB7AOS6+p6uRI+KpzTkG/OAG1hcS4XY3N4yFth4eLALxpbOEEEODqBPXH7jZtOTj4XEgQeE52C6OObEsvEhavSEYvT8/+28nHv1UZ+EBT0H7CE4rEjl4E6gxd2urnZy+Z+wNt64VPqjzv/tNrWM6HNIZRPeFbp1nqy7kZTD3nt4FbPbMhS3pTb1lqM9CEBtKABIKzUORhv+D8+IvZvqN2U5SeGJK+eqFWmlsHIiizHEyf9FrTMojye/CRrbdj/zrEf8F0Ed93IG3ZAm4g2SikFZU9+uJudpuc3H8L0ZPEtghdCpP59gkfIemujOaTZjNcRiCaWayAF1aZHM1bpuCK6G4a7s1I5ri9ClyROkcFootPVVTZOWqZY2CV35aDMWV1AH7f/Va8zZqAON+Rx16Gw9wgJg0Bz1VXSynUX5hXF3z0euF1CnchY4l5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 01:04:27AM +0000, Alexei Starovoitov wrote:
> On Wed, Nov 25, 2026 at 06:09 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > This is absolute atrocious shite. You cannot attempt a spin_trylock from
> > NMI context. That thing might be a mutex.
> 
> cannot spin_trylock from NMI _on PREEMPT_RT_ ... correct.
> And the patch guard against that.
> 
> On RT the nolock path doesn't reach zone->lock in NMI or hardirq:
> 
>   __alloc_frozen_pages_noprof()     alloc_flags has ALLOC_NOLOCK
>     alloc_nolock_allowed()
>       can_spin_trylock()
>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>                 return false;
> 
> fwiw kmalloc_nolock() has the same check.
> 
> > This should not work; if it does, that is an accident we need to fix.
> 
> It's not an accident.
> In NMI only !RT SMP kernels reach the trylock.

Allowing this on !RT makes people think this is 'OK' and then the RT
people get to fix endless crap again :-(

Locking constructs should behave identical across the configurations to
avoid divergence and create problems.

You're actively creating something that doesn't and cannot work on RT.
That is not cool.

