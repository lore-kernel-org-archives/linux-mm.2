Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33DCEB26E5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095C26B0005; Tue, 10 Feb 2026 11:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0190F6B0089; Tue, 10 Feb 2026 11:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D626B008A; Tue, 10 Feb 2026 11:30:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5BB06B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:30:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52D948C17B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:30:18 +0000 (UTC)
X-FDA: 84429084516.24.FF21F01
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66EDA40018
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:30:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dDBNiYK3;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770741016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ciUjhVvToHNuGHTWYUtNytWkQjP8xnn0ronWwShe/v4=;
	b=55O+wuwx4/RXvrVL/c19a5e4Srq4C/DIPyu7bJwrts0JK1Debu6obAFjh4V+80NY8Zj28x
	VHG/0XdPBWHbNzLkWadRiEmgR3TAxLi1S+AGkoXI/4f6ORXuw+on9J+bb/VoVLxGH+9bmT
	iO7QjaG9NGIDnCQPgYZO74At98nc6/o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dDBNiYK3;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770741016; a=rsa-sha256;
	cv=none;
	b=sJIwLzLA4gBHjjY9hbgjnnEiw8vYjJLwEb4S72ZUbWvZKCpx4KcDo8nz76EB9E4S6oiEEq
	yJFaH6zC2WEpRuehiAyP36b8ouK7WSPObeLMCRqkfXNq81EiDqMjN3I/XIcUW0LmyavT8+
	cRutRJcrRGUlhDa35UeAaXJzomm9eCY=
Date: Tue, 10 Feb 2026 08:29:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770741012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ciUjhVvToHNuGHTWYUtNytWkQjP8xnn0ronWwShe/v4=;
	b=dDBNiYK3kAcBNyjmK6tAsif/GJhG5jdJ6YP36U3pdsspXExzOFwt0xJmk971+m1noj6eBs
	QZcarLuLNpMR2MvCWsG+jNIfEbgwuGDnS3piJxgnie6cUiXA6SytzhmUoZ+V00noIJdLz+
	sGQN6ankIQEd6jfvWZverOQFyGwElss=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
Message-ID: <aYtbevHEwx_3fn0Q@linux.dev>
References: <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
 <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
 <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com>
 <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
 <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: nzkju6tchjysieozeuh981kmz7c99cx9
X-Rspamd-Queue-Id: 66EDA40018
X-Rspam-User: 
X-HE-Tag: 1770741016-786763
X-HE-Meta: U2FsdGVkX1/51BLNF9mpMGJgmMFroVX/lqkSHb5MhOVFG6n41/TzKBTK04XWIXObo9SCQI6JMUQbWM5s42yqNhe/oGe5hpe10W//Sg5RzGzLjSIZ9ITcmP1GgplkfhePAfU5GMaU8JnQWBiGKNGjVX0mD92lYlaMLxg7bIeqk1+Kteu0Vq4tqH+1hlMgncO86rV9NPbx3/hxDbcIo+Ft/2j2jzYhjlnOLgr2QcLWANtWlFmrt0tqQ5Tas3E57lZDVZRG+RN/gAiOIRYSEeeP8PG/2scrYHf9A8pl1kOKUmlZ0AyGy1Wiq+OW7TY0joBTkv4OfCGIKt0HKTcLnJaunP9RsdcX3MF8/i1LbKINvzdSqmjs3RyepqkH4DPNdR1Pulp0H4AWMpvixAUzt7cPXrnHVl7zk5l/r1OweBCRM0N7/X9tvhyQB6VkvW6ppvezDftW7OFozZkaLY15y95P2yRPXqAPoqLkHoxwxjbhLWlceUDUaK7sOSAXgzc+WcLYmrebwxHfIQoUyFCcogN5O3hYApmAZbNd8pUSb2vHr9j+6xuER8NmClEjobqewzOkNleRfiwhRuEPcQCqJrlv/u8fY5eYz5idjMd18yvG5y66q5R5eZPGSvnM4tYrJj25Ffi9EPdsx8MhonCMy3e2nB3z/lMVb4GTASaXcwjZqSVwiP6PJx/zFpZpR1qs9APCX9uky1VKE9yvE/KHYDfwQOiqHvpaNkvHKzwu888cznzI/psjreixyLUmLrNcML0RLk4Ykg1tuFxWyKizK5fOjAVs86wmI+wkoryFDQKEFWNcc74K57ai++67c2eH7IKJSzcszefUFXM2I77TFzAhLAW7V2dCIGHBL3c6G8wyy64UZSiwo7tsbCC50RDqAwofNxeLL7uxTuy/TO/Qk9IbfFJGEOMpTCvTooacZxdRVjWM7sbZeSmZpx5T4kOngSsZsuOUnP7hsdI6hqy/sj2
 KCQv8SEm
 /WCX0ZAw6hWQwBwzNjoH9xfuzuV6bLO+gvewEHIydQSNt5rQWzTQBKeGkNYNFHBwHwsSsco8enpDVNOB+HzV3Vq5EIdGTWT5PWhpQxKbD6p+1VMZQL/toy3QWAo2F3kcD1cZuutJ1VB/EFJnXMo2sO2ECCnoN1AVEpAOD2x0Xf6I8qyq7gdOPpYBxv7VDsucOx6ehND3YxMPC4PASBkQK4Jrq6rPFxsTMfY5izQ7dOKE473Fmnrteira+GWuKHGq9V3g9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 01:08:49PM +0530, Dev Jain wrote:
[...]
> 
> >>
> > Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
> > the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
> > double underscore, uses LL/SC instructions. 
> >
> > Need more thought on this. 
> >
> >>> Also can you confirm whether my analysis of the regression was correct?
> >>>  Because if it was, then this diff looks wrong - AFAIU preempt_disable()
> >>>  won't stop an irq handler from interrupting the execution, so this
> >>>  will introduce a bug for code paths running in irq context.
> >>>
> >> I was worried about the correctness too, but this_cpu_add() is safe
> >> against IRQs and so the stat will be _eventually_ consistent?
> >>
> >> Ofc it's so confusing! Maybe I'm the one confused.
> > Yeah there is no issue with proposed patch as it is making the function
> > re-entrant safe.
> 
> Ah yes, this_cpu_add() does the addition in one shot without read-modify-write.
> 
> I am still puzzled whether the original patch was a bug fix or an optimization.

The original patch was a cleanup patch. The memcg stats update functions
were already irq/nmi safe without disabling irqs and that patch did the
same for the numa stats. Though it seems like that is causing regression
for arm64 as this_cpu* ops are expensive on arm64. 

> The patch description says that node stat updation uses irq unsafe interface.
> Therefore, we had foo() calling __foo() nested with local_irq_save/restore. But
> there were code paths which directly called __foo() - so, your patch fixes a bug right

No, those places were already disabling irqs and should be fine.

I am working on adding batched stats update functionality in the hope
that will fix the regression.
> 

