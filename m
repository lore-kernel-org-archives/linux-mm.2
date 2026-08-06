Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774F7C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C056B007B; Thu,  6 Aug 2026 02:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD596B0088; Thu,  6 Aug 2026 02:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB406B008A; Thu,  6 Aug 2026 02:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1505C6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:26:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0302D80680
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:26:22 +0000 (UTC)
X-FDA: 85069860246.29.CDA7586
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 68DE640008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:26:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FE7aXVZP;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785997581;
	b=0W3W8uL/YR3+GTwpYbM3rc4vZQZVcemo4r2g/FHPFGvSDvi+lCr+h9+CYF2BY9jQD8VjVu
	zdm+kfZFPuuJulgVob4oV0mwzmzUhCHyOJq3pYXR5eyEH1cZ4ugLLzOTLnz11jHfwjGNRu
	Hwv2wzeTJv82OQeoERdlWCeInR/CV4w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FE7aXVZP;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785997581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMdisCQV5YYFAzlzsAkCnp6p2kMaT/VUoOBS5G94/LQ=;
	b=tl1U9F2Fq3Qtbc2NNKv2orrZNZUkT+7eiPej4OPhF/oPr+1ARXUsHq125Hrvf4DIuUoWN0
	lOPiUM9jk0Ypsnj/n70TegRZe6NRDNVd+eUwU5JwVHRJqm2GFU/bmaEZ+wV+jhLKYiMS0F
	RWdmVrtYktVM/qDz4wlPKp2c59s1FiQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D2CD60A80;
	Thu,  6 Aug 2026 06:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8611F000E9;
	Thu,  6 Aug 2026 06:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785997580;
	bh=AMdisCQV5YYFAzlzsAkCnp6p2kMaT/VUoOBS5G94/LQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FE7aXVZPB4G6U2Y7JkMeL/mN8FH3Ijh6cd+5ABNFV+BP4TG9TufITG1o+qAi95lDk
	 +R/pgFriNK1dXJPiiKeuroehJ9XyigZkAPI+xdkHrN6+c237fuC8AdWTLa11vf6jCE
	 hmgiVy82x2T+eyWuYT4i9FH3GuLa1HUKEnzVZjcFkgYZ5bwMRHegjfzKlnhZMkphPR
	 QVFQ5e8WAmOZLsyk99bN6VhBE/fpGZrILyI0cfjyvDpQa34F0MnIoPHknQ5zafp24R
	 htqvGNIjOIMvnDqrpAgucDCpZlo6DMz8JLWjx+W8RbG4Po8ycFoHzAh95sef0qZiyc
	 rJ12229o+LrWw==
Date: Thu, 6 Aug 2026 07:25:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>, christian.koenig@amd.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	"Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Aboorva Devarajan <aboorvad@linux.ibm.com>, David Carlier <devnexen@gmail.com>, 
	Josh Law <objecting@objecting.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v20 0/6] Hierarchical Percpu Counters for RSS
Message-ID: <anQoW3dG-97i9lUc@lucifer>
References: <20260707131544.75906-1-mathieu.desnoyers@efficios.com>
 <0d454717-be7c-47c3-bd5e-2ad304c3423e@efficios.com>
 <10ca9ff9-428f-49c0-92af-698fd5bea3a3@efficios.com>
 <20260805115738.5d74e7f41c6f02cc5fd4791e@linux-foundation.org>
 <0393072a-3950-461b-929e-154001ea4595@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0393072a-3950-461b-929e-154001ea4595@efficios.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 68DE640008
X-Stat-Signature: 66yr4o865yoyyg6nty4u78456xp8efac
X-Rspam-User: 
X-HE-Tag: 1785997581-395987
X-HE-Meta: U2FsdGVkX19q4VUikVHmtpor6AiiGDV2Qz2n4tUEWyAAlzCRpEfZS1tzP/Fdare5MA6bMq9twFO9ewARVhvfgV+OS4pIPY2gGPctU1v0IB6ZGsJwsIXsbYluy1QXHO2f6bxIx3WVNnGiQl9B+LLZ7FOtjeMeUe3HFVdFmh6Csqx9CBwb/811SFwm+HskJxyPM6oS8QZgEJNj4g+7SEGDHueld/XPnq4xqVPbLHdqqpsbYvw8eVqC/fz+gqoeRmW0eRFIDtI/0Da0IV4anKA0Mw2mqI8+dtn8syvgD7b4voQtm9rMMPez5HfYxSMauuABNWC7pA8z7IN4IRGd5F3uUvEwv8Q40ZKgZIK5EZFIZpbElI+I6+uSU/NW5VaM9m2JVQqYutaEnLsjsWfjqt0VYguNfH8ytnjTamoo7uA/tcS2CmQo/gRMfIM9o4OfbQEYEUcn7V7y6X6o7Zv2kNDIO++OdI6g6EtdvL/9seNswI3hAJ4/P0IGcjd72aEuYH9sjYqLecSFgvqugtRQ0tQUFpic3m6uryw0iRVuP9H3XiiV6R1uZPf+ylX0uOAkOgAcl+F1snWQsOuenM1egzn6YuroLyg6KqGXDsqKytULNpcQSAQbs6nFaKWhOMU3kBNbnmRbbwn6qZatKOuCyhIlpNMjUI9W3Mf1f5luTyyn7OHBvPSLrLGhpZUF8RnXyLQdxXjUd3dsVhQHKrEqlC2qqYGlvcAWpVqAmIVw5HiWJfThqwsftSM5XYW57ylsejSMkRbiyvYzw8Ue5iBgEwJlv6SXuf9KAKa7is7URngc3YWonD4tLQ2JGaSq3cSS/zTDuDa0czRhuVwhHiwDthikQdqThWcm6m9xY1gWwRXZn3AE1gSQIKj/PkyEaVTjD+gqsQzzvPSkmF0e6fFm3HScDMTnejw3vdGSnG/ISAqgMwoQjk3+ygs6b3HUzLLmGL7akeAu8kaOjjuxG5edtVg
 FI/5Gid4
 nexu7wzh6fDQIb30wek8mwRNc3KXlaT7J4JREaSI5mRs+0fEmc9gDQ1EgW2Bk0/H6cxG69gTjUerKlGggdYqffFgur9fc/lTdfZnU+gPKEp2xraaYkVe0Nmdp8fyYoguv5LhJ6RCq+prwTxqwx79B+4sJZXz6+4HYX3PKb0Txu2LuhedH/7f+2C+kAQJSQodAD7BninWao997v9T1oI2By/wbrYEIDHGg7Me1lQ/o7hNHyH7RZwFAmUTJBi7jUBIEnxtbsgaIeWvm4A+bs9jJUY6HYlNrm4V97NUZLG/7/xOdYz4o1YLTCncCTx6JSnO3NQi8cISnbiOiYK7zStKNa0SuNhrAyPpO9/ezzf7H638TcfOwDOZlfNxb3wvZY7xMP2mI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 03:03:39PM -0400, Mathieu Desnoyers wrote:
> On 2026-08-05 14:57, Andrew Morton wrote:
> > On Wed, 5 Aug 2026 14:37:08 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> >
> > > On 2026-07-23 13:53, Mathieu Desnoyers wrote:
> > > > On 2026-07-07 09:15, Mathieu Desnoyers wrote:
> > > > > Hi Andrew,
> > > > >
> > > > > Here is the hierarchical percpu counters series rebased on top of
> > > > > v7.2-rc2. It includes small bootup fixes which were needed to fix
> > > > > bootup sequence on specific architectures, and a rename of the
> > > > > test config option to include "KUNIT_".
> > > > >
> > > > > This aims at replacing the prior version of the series you had
> > > > > in mm.
> > > > >
> > > > > As a reminder, the goal here is to provide more precise RSS counters
> > > > > through /proc.
> > > >
> > > > Hello,
> > > >
> > > > Just a gentle ping for feedback whenever it's convenient.
> > >
> > > Hi Andrew,
> > >
> > > Can you pick this up after the upcoming merge window ?
> >
> > Resending after -rc1 would be appropriate.
>
> Will do, thanks!
>
> >
> > > That's of course assuming this is solving an issue which is
> > > still relevant.
> > >
> > > If there is no interest in solving this issue anymore, kindly
> > > let me know and I'll drop this series.
> >
> > This was 1000-2000 patches ago so I've forgotten what the issue was!
> > Please ensure that changelogging describes the issue in glorious
> > detail and I'm sure it'll all come back.
>
> Certainly. For the immediate records, the issue addressed by this series
> is RSS stats inaccuracy when reading /proc files on large SMP boxes. It
> gets increasingly worse for long-lifetime processes which jump around
> various cores while allocating/freeing memory over their lifetime.
>
> And once we get this in, it would be relevant to use this infrastructure
> to address the tail latency of memcg oom killer, which AFAIU is now a
> scan in the order of num_possible_cpus * nb processes. Although not so
> bad when the OOM killer fires due to a machine memory use ballooning out
> of proportions, it's rather inconvenient to cause large latencies when
> it's used to apply the mem cgroup limits, which is a rather more common
> routine scenario nowadays.

Perhaps Shakeel might have an interest from the memcg side here? :)

Also similarly Johannes and Michal/Roman too perhaps?

>
> Thanks,
>
> Mathieu
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com

--
Cheers, Lorenzo

