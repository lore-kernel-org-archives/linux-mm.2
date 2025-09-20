Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5771CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 04:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC678E0005; Sat, 20 Sep 2025 00:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066738E0001; Sat, 20 Sep 2025 00:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE8A8E0005; Sat, 20 Sep 2025 00:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D77A98E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:31:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C6221A089F
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:31:50 +0000 (UTC)
X-FDA: 83908355580.18.38B251D
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf04.hostedemail.com (Postfix) with ESMTP id B07C340006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:31:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I8NnZzbJ;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758342708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7Oqwm27EVC3hegeL8o9rPQpBwMcTLBc733/TDvrqNg=;
	b=61Kk2l04O0nRaMYYKn3S4mr/lnd55pny/hxpx30Uec72V6lPrfmqoiNsYOxxeACfTkeLod
	OLuHnaa4b+WJF1G+wpFdZUsHiTAy+9XaOckTXLb3Iny1W9FE4s0qbUDZfdpNjNGUxXdvxw
	4jZ6+a7DN53XL2oB/fNbOKG7epSZ+Fk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I8NnZzbJ;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758342708; a=rsa-sha256;
	cv=none;
	b=xknZlQdzjVv7LePZxNCX51CWL25bQYcjVhX4lvhuH5y5jWHseRwL2eChs0azPgduhGIbag
	MXiaZjGLlWOllMSymXvlF1ybfX0msMKNPCiWlhWpGOVG+S5Cw19lMrvYKzuMOmcH2YZ5CA
	1LyH9kXOr/oXEn0wXFKnX2pkxvyLm8k=
Date: Fri, 19 Sep 2025 21:31:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758342706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7Oqwm27EVC3hegeL8o9rPQpBwMcTLBc733/TDvrqNg=;
	b=I8NnZzbJ2dD4btg1IUawDHxKrOqJfngGHi+zHOtn3M+Avc93+yeIKyVifm0k7Ituth24jD
	v1ABEIEgPqY2t9LKb+wsRUs39CNi7xQP/MQvDA4PocieQPmN4G9lhK+3tnxWs7fjokgrf8
	yWMAjK2Ngj4kBM79bYSfryXJBtZbTVY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Peilin Ye <yepeilin@google.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <eba3aiglp2hmj65sd4vsmav26o45orrlog2ifexd44yovygcdg@43wfk6dbgqda>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd>
 <CAADnVQK_wvu-KBgF6dNq=F5qNk-ons-w3UenJNaew6h9qTBpGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQK_wvu-KBgF6dNq=F5qNk-ons-w3UenJNaew6h9qTBpGw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B07C340006
X-Stat-Signature: n6o1mjge3ep6rq686j4wodxotn95y71e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758342708-932470
X-HE-Meta: U2FsdGVkX19gPnXfr1eqRlZXG1MqZU7rtj8QSPutneVs2+zGHXuFpb2KPOAa2ur2YOPtQfDLzZ3inNRHVUm7DbLG0wxOfqF/N0rB0FR+JZUMtZ4nQ08D+7ojn/37V82OLN03m7cjumK6E//3F+iH3bCt14ydzKAp+ezgAxuVPGIS8K10rywDfFbEOuRPpJw51unZ07jkNQie72TNPBBCPJEoc5laR1EF2Nrvvtg+doalPK4uXE2ET5PwmDMuyPSXUb5wltTH7y8BioCpAmqxThydIyBda6aNftBZ9nFmaj0IQGzq5G13qmawL/1rQihI86gmXz4OzZUhqSSdXsk2bPTElfuyxajb2pOVEEDbYV2ZIhyimJnCRGN/sf+V8voQq6yv/vImwnioc8W/eD4ozJQxhz6XIIorWtwm1N5zh6KdkssqK4awCf9jCjjeJGurH4I1ONkJV2vySE6RQXvYBKERZqiRsvGBz2nD+/qrntMVy1qkLELseZ1ToHZRY1qFpVTXvZPEk+uR58lOMoB3MuSUfWOM1c97YyBYqIL2f6IX4xmsC7b1N+GWW5asPiez6cCGjNav/TW0DYnvlZX/rc/28eJp96SglsvkCqMrWNF/fgWQjh2JWhcLw7g5y4gGrHAtt/rIYCnBECh+eZaA/9cOCF0IJq4k2nsQVU57qAFfxpPtnNjQ/OMBiIfMSri37qXJRT474tewhwKPWAo0zWBj4aiTjCMOndAtfl6GbkkAC9vQynu/8M2QBTn+gPAAthHMKJb+8qHMEwpWtcvO1X8gEqjgemrdijzxbcZ3fM2LLpvlQV+MTpPJM11xzCv10FtOc0ILdaC+p7pH4fzWKwbBqDEF1WrtImZbV+moWAQMfhHZcZdDo8vzN7HpyyPVBQBucx9hP1qBpssYeXGQmfi+CDn+7IDOGbY6/DDTUppyqMSUaCrWPlUYWo+oehiw10JwaiYU07vxvQZ8BNf
 j0adNY4o
 sS1ZEfxNL8bVbACNfW6cjsAwPa1dpTbl72IcG5UVNfCi7TfAUgB68y0XSWSSAPlXiT+nWENmM8ZPZzktFH5YqVHDcVkVeSnHPdcI5bRQFiEF/2QS2JMD9rreWBrRJ5pQ/kPQkezX9XciPMhUh7mcUDBi6G9yz3JMApZ729yiywtLrKalhOqSXuEbRRuMHHpGlHlqo1Fm88pFn5Dpo4GrfAqXichdKeul5SWeU+51PhX6o0Ttz6V7hIrF5XxAxqhLTCNX3z3oSOorN+L6DzZB6xXwncXpWht7NebUJP6RlhvU5gEixaue/X7LobQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 07:47:57PM -0700, Alexei Starovoitov wrote:
> On Thu, Sep 18, 2025 at 7:49 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
[...]
> > +
> > +static DEFINE_PER_CPU(struct defer_memcg_events, postpone_events) = {
> > +       .memcg_llist = LLIST_HEAD_INIT(memcg_llist),
> > +       .work = IRQ_WORK_INIT(process_deferred_events),
> > +};
> 
> Why all these per cpu stuff ? I don't understand what it helps with.
> To have max_events per-cpu?
> Just one global llist and irq_work will do just fine.
> and global max_events too.

Right, global llist and irq_work will work but max_events has to be
per-memcg. In addition we will need llist_node per-memcg and I think we
will need to do a similar cmpxchg trick I did in css_rstat_updated() to
eliminate the potential race of llist_node of a given memcg i.e.
multiple CPUs trying to add llist_node of a memcg to the global llist.

This can work but I am still debating if this additional complexity is
worth it as compared to the original patch where we skip
cgroup_file_notify() for !allow_spinning condition.

