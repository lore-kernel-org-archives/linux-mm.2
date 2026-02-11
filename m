Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D812E81BD2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9B96B0005; Wed, 11 Feb 2026 04:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A775D6B0089; Wed, 11 Feb 2026 04:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADB46B008A; Wed, 11 Feb 2026 04:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3876B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:24:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE9601B3548
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:24:46 +0000 (UTC)
X-FDA: 84431640972.06.5A09F99
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id AFE0AC0004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:24:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=di5Fuh1e;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770801885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dpvw+vIfQxetwPmCL64Sfty9H2n+wMSrw+rP8I2lIm4=;
	b=M7opCopUPClORF9E9Pqe7Sr9wyWPzC5T9520JMd8SEnZ8HV4H29PK11fkQ2ufoiC5LRjS6
	QGqGNjkBB2vX7KVFHhnkLhLSrs/gzyJ1tx2OonYIQTBoaJ6HOYCT0zJ+lpC/R74mghEdPW
	k1QNc9jZ70uIce6Lxi+CUYwgaCGitXE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=di5Fuh1e;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770801885; a=rsa-sha256;
	cv=none;
	b=5nntJ8AQPpUGCWZsB8NtV1Xw68PPzfcMeSNqiKE2qOJBJsyjxspmIedwYsr8Zd4ghoWM52
	clDiEX8MS/kmB+q7VKDr0OGXVWqzs5EKwusl2uRHEfpP86Y4DBUoqp8ycWuPkcD1ZtCz/w
	vb+wqyV4cEaOoeIa1Dp0KfvmNveVoYk=
Date: Wed, 11 Feb 2026 01:24:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770801882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dpvw+vIfQxetwPmCL64Sfty9H2n+wMSrw+rP8I2lIm4=;
	b=di5Fuh1eYSBaEAEoEfeRBcpidR6cwZqkBU8qCe9BMEjoFQkbnIRRYS33T/juFnq3BYshWj
	9MCz0NomF71bqILtp3lsb6GkeLG3MDfcwZSD42eAAbAGDmPtiivS/LEoAdFFH+epxzzXFw
	pntUqkOLtOr9yBbQivvjDoPdtgPVwgQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
Message-ID: <aYxIr5neJP8wBdZg@linux.dev>
References: <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
 <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com>
 <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
 <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com>
 <aYtbevHEwx_3fn0Q@linux.dev>
 <5a6782f3-d758-4d9c-975b-5ae4b5d80d4e@arm.com>
 <aYxDkkDI4mk3r011@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYxDkkDI4mk3r011@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFE0AC0004
X-Stat-Signature: c5s3ydjsmadc59uqtxqbcaiqukqwz34w
X-Rspam-User: 
X-HE-Tag: 1770801884-491928
X-HE-Meta: U2FsdGVkX196ITq60paV9wHSa349J4VbAYOojWfkcq69bvsQYG/u5ZDuyqFXWiOBERUz9lB+xgsn8JYk7IP5ysTraMJRe75hcV8mLc7blKYTKmQKGvX8f91XfiQcza2nX+k8Vu/DWxdWZ0xWI6iL8qRPrk0MnAQB1zc0/GnMKn3zApjSAg6/QsScr3zdTpv7LXFZTf1IFhaODElY8xI2ar4NXajaChg+AseCDPK86Pmi4hU3K5jyqq5SVDc/S7F5z4GJtnoG7CPd5aamO/SEh0eHj9RI7pktKJrAozta8DY1JiHn/O6RCMPCrNtmnpBQ6f4BXiUi/hlMR87UjVfjh3QnrhR6nbHthfz3omzFgWt8LRLftQjXc2Nsof+I7csZEO2G5WPojcXXPRv18YwubJE4msBj7HZ0tsszPajk2+vvGXnvQjblgo5VE8mT4amlCk+yunkz5Hwp07f0VSv99k0wLY1yeX+f3CIMo0/zxaEKLXo+1jJeDrnRe49RVtCqrrwDCHBbhSOFwwq87h2zi6BGgiVa8aLDOgcEaZUe3UtlnxmfuHrR6lk3qLOFfY2O87LpGa8z8ytNoz0Z2A+yFRyEaqrOsqZmvJP+/+cUhT4lKOteYrsa8VbHvNIKXQlJ9a17ukUX/B3IHgYW4G3p+5uz+U//+V/NP0V0kL50aNj4SMGwL6a+6yeXDkxS1zkxXQL94o4Q+FAw+xnSnfom4GnD7YbSygwYn/ui9A+nTcOf+WHS3nUpmNV6JR8T0XlmIv5pdEiDafK3Z2dFIxp5xL+qoZ9z7V2aeNLBq3tb/THnDX+Sb4uvPgnY4CfqgCXMjkU3XbUitWoNxwDrNCFFuvMvsUGmdBdpoTFY8NDWNz9nhTkfgjOz1POZm+AHeeSjildWVARUs/5nF4jotihPmFQOY2z8lhndr8PjPDY0mQfsVPCMW8PaoDrTnI+FUp+cW+RCeUp10K/MhbJ8+bP
 43MeSEos
 bzXb6YCU2TJMJuilpWrR0rgMYIhtbFAK+72frilZyCb7Oo3CK31S8evMk8o5uVVEosx36v6pcnTstqf59AzN1vmYCG8bJuwZNu3lbkYn64VZxzmFH6ecfY3D6v4fkxdhL6j9P+2pO7lzxxTy7WkHhh6W1l9QE45DBIrstjEorxzqMSWld691iFHCuI5+mWL9UjXx0DxlMyauP8emRB53JZzD1wx9hHw2ijNw8bowwWPHMgD7l2eqWM0eCTuyU5c00p4eCm88tze3VqOaTWK1zHRjG11qNYgSNWZrZgDYo1TzBDHpUFWeyuh0FEf/U4vlIPG5NqOdahOgTREVCMAK/eNL2Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 05:53:38PM +0900, Harry Yoo wrote:
> On Wed, Feb 11, 2026 at 01:07:40PM +0530, Dev Jain wrote:
> > 
> > On 10/02/26 9:59 pm, Shakeel Butt wrote:
> > > On Tue, Feb 10, 2026 at 01:08:49PM +0530, Dev Jain wrote:
> > > [...]
> > >>> Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
> > >>> the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
> > >>> double underscore, uses LL/SC instructions. 
> > >>>
> > >>> Need more thought on this. 
> > >>>
> > >>>>> Also can you confirm whether my analysis of the regression was correct?
> > >>>>>  Because if it was, then this diff looks wrong - AFAIU preempt_disable()
> > >>>>>  won't stop an irq handler from interrupting the execution, so this
> > >>>>>  will introduce a bug for code paths running in irq context.
> > >>>>>
> > >>>> I was worried about the correctness too, but this_cpu_add() is safe
> > >>>> against IRQs and so the stat will be _eventually_ consistent?
> > >>>>
> > >>>> Ofc it's so confusing! Maybe I'm the one confused.
> > >>> Yeah there is no issue with proposed patch as it is making the function
> > >>> re-entrant safe.
> > >> Ah yes, this_cpu_add() does the addition in one shot without read-modify-write.
> > >>
> > >> I am still puzzled whether the original patch was a bug fix or an optimization.
> > > The original patch was a cleanup patch. The memcg stats update functions
> > > were already irq/nmi safe without disabling irqs and that patch did the
> > > same for the numa stats. Though it seems like that is causing regression
> > > for arm64 as this_cpu* ops are expensive on arm64. 
> > >
> > >> The patch description says that node stat updation uses irq unsafe interface.
> > >> Therefore, we had foo() calling __foo() nested with local_irq_save/restore. But
> > >> there were code paths which directly called __foo() - so, your patch fixes a bug right
> > > No, those places were already disabling irqs and should be fine.
> > 
> > Please correct me if I am missing something here. Simply putting an
> > if (!irqs_disabled()) -> dump_stack() in __lruvec_stat_mod_folio, before
> > calling __mod_node_page_state, reveals:
> > 
> > [ 6.486375] Call trace:
> > [ 6.486376] show_stack+0x20/0x38 (C)
> > [ 6.486379] dump_stack_lvl+0x74/0x90
> > [ 6.486382] dump_stack+0x18/0x28
> > [ 6.486383] __lruvec_stat_mod_folio+0x160/0x180
> > [ 6.486385] folio_add_file_rmap_ptes+0x128/0x480
> > [ 6.486388] set_pte_range+0xe8/0x320
> > [ 6.486389] finish_fault+0x260/0x508
> > [ 6.486390] do_fault+0x2d0/0x598
> > [ 6.486391] __handle_mm_fault+0x398/0xb60
> > [ 6.486393] handle_mm_fault+0x15c/0x298
> > [ 6.486394] __get_user_pages+0x204/0xb88
> > [ 6.486395] populate_vma_page_range+0xbc/0x1b8
> > [ 6.486396] __mm_populate+0xcc/0x1e0
> > [ 6.486397] __arm64_sys_mlockall+0x1d4/0x1f8
> > [ 6.486398] invoke_syscall+0x50/0x120
> > [ 6.486399] el0_svc_common.constprop.0+0x48/0xf0
> > [ 6.486400] do_el0_svc+0x24/0x38
> > [ 6.486400] el0_svc+0x34/0xf0
> > [ 6.486402] el0t_64_sync_handler+0xa0/0xe8
> > [ 6.486404] el0t_64_sync+0x198/0x1a0
> > 
> > Indeed finish_fault() takes a PTL spin lock without irq disablement.
> 
> That indeed looks incorrect to me.
> I was assuming __foo() is always called with IRQs disabled!

Not necessarily. For stats which never get updated in IRQ context, can
be updated using __foo() with just premption disabled.

> 
> > > I am working on adding batched stats update functionality in the hope
> > > that will fix the regression.
> > 
> > Thanks! FYI, I have zeroed in the issue on to preempt_disable(). Dropping this
> > from _pcpu_protect_return solves the regression.
> 
> That's interesting, why is the cost of preempt disable/enable so high?
> 

What made you (Dev) so convinced that preempt_disable is that expensive.

> > Unlike x86, arm64 does a preempt_disable
> > when doing this_cpu_*. On a cursory look it seems like this is unnecessary - since we
> > are doing preempt_enable() immediately after reading the pointer, CPU migration is
> > possible anyways, so there is nothing to be gained by reading pcpu pointer with
> > preemption disabled. I am investigating whether we can simply drop this in general.
> 
[...]
> 
> ... so, removing preempt disable _in general_ is probably not a good idea.
> 

Yup, I agree here.

> [1] https://lore.kernel.org/all/20190311164837.GD24275@lakrids.cambridge.arm.com
> 
> -- 
> Cheers,
> Harry / Hyeonggon
> 

