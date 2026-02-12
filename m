Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8E9E9E31B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E926B0005; Wed, 11 Feb 2026 20:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19436B0089; Wed, 11 Feb 2026 20:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A280A6B008A; Wed, 11 Feb 2026 20:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93B856B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:31:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4131314069D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:31:34 +0000 (UTC)
X-FDA: 84434077308.20.E9B4B17
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B3B5120015
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:31:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FY+TTj8H;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770859892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXoRO4v4rHvgrYKgkmZGAeu/KgPPkLUT0T4HFcXiuVc=;
	b=DBHHS1D7cZqW5CWsSFiJsHbCDxEV5GYy+ID7G8n9+Y4x+m2XnRMx4s8MyIrbUH87BVv/ur
	ptF7Jx6pG9AsSQMVxanwpSuxaVJE9Z8PPWSou5iw7puboQ2YU3ILvxhYeMfqTfLFw4XCSs
	CZ0oMrre90W27e8p9MoO/u8URbZT81A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FY+TTj8H;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770859892; a=rsa-sha256;
	cv=none;
	b=jEnIrux7luDXElACXKCctzirQoRB5faEWO9yVNvNrh7Dx0/YFYkPh9+ZlP8UQtj5YnOu/x
	kDgytXJEax2ENQLYH3uw4lXscAn++v+RjRSoVOKo/g6a4G2ZxqIqXjv0V1N+K5c2/nUhSk
	AwqbYkotnLSHDsoG6SIdhSuk8gNdVDs=
Date: Wed, 11 Feb 2026 17:31:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770859890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XXoRO4v4rHvgrYKgkmZGAeu/KgPPkLUT0T4HFcXiuVc=;
	b=FY+TTj8H8AHJJcKbeySIehPXIDj8Ixtxz/MVGG8esxlLyrRndxYaSxY1uPNJoYv7dejEGd
	te9wGLgCNVZT1THR2FtJyl6scAwHIxhuGzezgZOLZXdWMD+4l4RWlFz8Gj0wSg3a5FSyFK
	wW7/BZhcvm7bHdcwvESThaiDvJ1ArFM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>, Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>, shy828301@gmail.com, cl@gentwo.org
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
Message-ID: <aY0szfVYWR_eWdpn@linux.dev>
References: <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
 <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
 <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com>
 <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: owy95qcwbw9qg6wsayuqeni5x6uw4efg
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B3B5120015
X-HE-Tag: 1770859892-371098
X-HE-Meta: U2FsdGVkX1/4xY1cceCqfz26wNzlW1ORlcnwg0evsuq8vYnosxGb6f0r2dd6RGPGAD9dLSqJKZeDowa/55wkscHgLZkD8jDj5rN7m/gdyG9G7R9JwyM97cv2d85BxcgK6ovjqcWA5x4sPE18EJSzNj4nR2DGBb7ptGfzGs1Uny9N3r8rHr0XqMVWfCyf2Xm881NfMaaRsJRtHmzgWWv0IbJMEA8NBRoEzV52js3wpdQwnjVcwXGszQuF6wcXUweHUkO/qMsw9iLE6ZCGujMZaBqgogyzS9wUoiO96FJhmgVDRwq+o0QFL/9O0i+O0McfMfOL0GtOmpykp2ArFRIbZ9MPgI2n7vcdzMRBj5UBxQKVXaiXza8m2Y2SVwPg1lACCCipTf4vWjq2Z+AtTZK/WIdVHe94kmV4WWpGgiCpUlLeCySoL9fFsoZ6Pxq0nw+6qakQX4xYbRCBlkXaFCfzQFQyQcYg6Aikz5nDshiM5uWHZxWaqYm2qW4P3m7HtUwR8BmK5UjAb0VxCybU0N5VT0zsd3cYSBgQz7/IkD7F61FxpPpJZZxxJSID5UTA3+gkTciqd6eeF/SYEOnDkv+Vfj7Al8bel/Hhe01UKku3+ezfruaesYQIY439ZuFmhN/1JgTNdWeUa/gnJkYJcPuvHykNOVjMNuWO7YMYGXVZutjPOupoUWkSruooGKwaPHdxrwwHQQ7AkLeF1wwQb/kZcGTCYuu7V/Rtkwptz28yTEZGtkteAvMyF3PRh04iZ/ZRRC232WLI578XBjil3cWSzf2J8XNdbjfOkvXiudYjbLIOtJg6vIp06btQIPrXJTkiUlbSAoGrzWsGEfkFoRtDHPl8gj6H8bLGWSMHuD+lQpK/ODNSQ8OI6R2RyzG3q2AHfvh4p2ML3ZPcbZXjPP4d/uLKJMayJOV18p0XA4mWNkxDR6423f2maDm7RuthdA2iZdba7J6n30+BTkN1gcV
 tBpPw8zo
 v3KnD0fh0ptr5VF4+9XarvAD3ApTJaULKkajsR4jyCSRuUE1cds2BXiD5wQL8ks0dBVNsF83nkqXzrs0rHoF6FqkO3f6l1KtwJmbt+Q9XdVdCInOF8y3P2h0M2SlwK97moohWNP50fTxzmxmm3xcdgpzszPS+v10hftHhJW7V3ar7x5pLARzCQfOptIWavsP6pdjWP56JPo9eDfIr0G5hd4leye80Lcx7ie37YG/TP1cJpJtYpczdSOhr4IvS+uqcbuiOW6fTlrpVI33Kkg+thZQpd7EiDwIC/6Em3jhvwKLeObUKSXGoSG8ZYqIvRbOp/QNksKaPylcrNb4uiSV9S41K9gmYpQrdihYiMMTvxVB4BZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Yang Shi and Christoph Lameter

On Thu, Feb 05, 2026 at 05:58:44AM +0000, Shakeel Butt wrote:
> > 
> > On Thu, Feb 05, 2026 at 10:50:06AM +0530, Dev Jain wrote:
> > 
> > > 
> > > On 05/02/26 2:08 am, Shakeel Butt wrote:
> > >  On Mon, Feb 02, 2026 at 02:23:54PM +0530, Dev Jain wrote:
> > >  On 02/02/26 10:24 am, Shakeel Butt wrote:
> > >  Hello Shakeel,
> > > 
> > >  We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
> > >  the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
> > >  to munmap. Please see below if my understanding of this patch is correct.
> > > 
> > >  Thanks for the report. Are you seeing regression in just the benchmark
> > >  or some real workload as well? Also how much regression are you seeing?
> > >  I have a kernel rebot regression report [1] for this patch as well which
> > >  says 2.6% regression and thus it was on the back-burner for now. I will
> > >  take look at this again soon.
> > > 
> > >  The munmap regression is ~24%. Haven't observed a regression in any other
> > >  benchmark yet.
> > >  Please share the code/benchmark which shows such regression, also if you can
> > >  share the perf profile, that would be awesome.
> > >  https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/microbench/micromm.c
> > >  You can run this with
> > >  ./micromm 0 munmap 10
> > > 
> > >  Don't have a perf profile, I measured the time taken by above command, with and
> > >  without the patch.
> > > 
> > >  Hi Dev, can you please try the following patch?
> > > 
> > >  From 40155feca7e7bc846800ab8449735bdb03164d6d Mon Sep 17 00:00:00 2001
> > >  From: Shakeel Butt <shakeel.butt@linux.dev>
> > >  Date: Wed, 4 Feb 2026 08:46:08 -0800
> > >  Subject: [PATCH] vmstat: use preempt disable instead of try_cmpxchg
> > > 
> > >  Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >  ---
> > > 
> > [...snip...]
> > 
> > > 
> > > Thanks for looking into this.
> > >  
> > >  But this doesn't solve it :( preempt_disable() contains a compiler barrier,
> > >  probably that's why.
> > > 
> > I think the reason why it doesn't solve the regression is because of how
> > arm64 implements this_cpu_add_8() and this_cpu_try_cmpxchg_8().
> > 
> > On arm64, IIUC both this_cpu_try_cmpxchg_8() and this_cpu_add_8() are
> > implemented using LL/SC instructions or LSE atomics (if supported).
> > 
> > See:
> > - this_cpu_add_8()
> >  -> __percpu_add_case_64
> >  (which is generated from PERCPU_OP)
> > 
> > - this_cpu_try_cmpxchg_8()
> >  -> __cpu_fallback_try_cmpxchg(..., this_cpu_cmpxchg_8)
> >  -> this_cpu_cmpxchg_8()
> >  -> cmpxchg_relaxed()
> >  -> raw_cmpxchg_relaxed()
> >  -> arch_cmpxchg_relaxed()
> >  -> __cmpxchg_wrapper()
> >  -> __cmpxchg_case_64()
> >  -> __lse_ll_sc_body(_cmpxchg_case_64, ...)
> > 
> 
> Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
> the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
> double underscore, uses LL/SC instructions. 
> 
> Need more thought on this. 
>

It seems like Yang Shi is looking into improving this_cpu_ops for arm64.

https://lore.kernel.org/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/

