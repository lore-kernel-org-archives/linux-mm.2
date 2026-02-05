Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1302E91260
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5F46B0099; Thu,  5 Feb 2026 00:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83E46B009D; Thu,  5 Feb 2026 00:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966096B009E; Thu,  5 Feb 2026 00:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82F276B0099
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:58:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02D7B1B2391
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:58:49 +0000 (UTC)
X-FDA: 84409349220.25.B91A43D
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 238F5180004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:58:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t53RKWK7;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770271128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Do4oFfIEa50WSzHZOziS8xFG9v2IcUGA8qMR6h8p3qQ=;
	b=aNout9ToUsDhlHvHXWbhCfCG4X0V1XYjAuDT0JmoqOTBxrLUlPwY8MMMz1xmNqiOZlH2zc
	2tZmQhdCT8qeJczZJh2dcfWwEVqshygvemOl8Uu9FDvJNemoTg9YuIMCR9jI+6DGhLBQx+
	dHz9muv0e2w9KCAi+cge3QJ/DGqluE4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t53RKWK7;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770271128; a=rsa-sha256;
	cv=none;
	b=FFhGeNr1Pd3toK2KLTMVTTzjwhjpNdPutfB5hbl8JfC5ttibrdBD8N7EHYZIMORtgFX8ui
	VdgQdTHzApVrRDNoYgYlKjaBYRspSbQ7bYqTuCDAT7mDNvLSq0oW2jJIkoSAGhnTq/AOj7
	CsZu7qKgZ7d6hfQfAmi2dxRB9F5RDOg=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770271126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Do4oFfIEa50WSzHZOziS8xFG9v2IcUGA8qMR6h8p3qQ=;
	b=t53RKWK7ghUmThH4yywVf5BqCpKuImQbWh+x4YlyjNNRKA1sUVB80ttIheKlspymzRkzYn
	+fMDqbdiLTSnKt7iGKswbYBeBSukxDJWubiomyD0WtWl+EEdlWB65Q+XIrb6lqPfaMHlJg
	29JuTeHt0UqyAj4/NIrXUJ8Djui63U8=
Date: Thu, 05 Feb 2026 05:58:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: "Harry Yoo" <harry.yoo@oracle.com>, "Dev Jain" <dev.jain@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>, "Vlastimil
 Babka" <vbabka@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Meta kernel team" <kernel-team@meta.com>
In-Reply-To: <aYQuj6Ot-JS4tXvY@hyeyoo>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
 <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
 <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com>
 <aYQuj6Ot-JS4tXvY@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 238F5180004
X-Stat-Signature: 7j1d5ax7h4zm6w73c1zsm7fuqaw5j3so
X-Rspam-User: 
X-HE-Tag: 1770271127-970118
X-HE-Meta: U2FsdGVkX184QQNycSxW1zFWiNhgCzt1gwAH56MH4gW5U/8KTeLO0rxW34Fh1v1U4GWKC8IZd7ILpvf27fDqlIip0i61H06lAN2Ak0MaD3HSGrSfs3XX1Skw3yVFHxKzMQfBN5aycKsOrm2ZeTkj593hJBjRKYTu1EW+GinFNxNqrxFSRIID6NnkpG1wupvv1nJuAXx3NvdcPq7BfHWe7hPxsZCaoRIw+QCNUQq4i1KOfQza+vXHVUud3R/Rc74GLVUkrgc75+1FRhRMYmtGvBlGKtJbga9qMXnlu92JFKsHMWbPluC9RG6bSWAKkG2uoNoSbELPnZMld1D6m99+tjd1S5QG6dL+ORfk4SI++XaQjBTWBlYve1wGP2dWEQGWhF+QcnkEsM5rX5pxeRTtzbQ1ZbqHRTQI+epSqbiCuCjXo0jx64tuCi2Cyclw/v7cN/h+gF8BJ7ZlLKDKSn8PXRpGBpMVRDtTq64YH9zfXrxv6c08h2FC5iOq7z370RiM1qBd7uW+/6fWxt5/bCbeQ5+B4LSH63PrWhY3x8RzQe6IwCf3ocezOqshOIDWYzzbb4ywCB/j88p4lp/3DqTX4N1EKnkfdo+gElzIfBNKgd7LqGTVzgSd7yh2kGSm6wv4k5O99yCRkEQtVDyUxccrDr/jIpi1Sk2wzIyogqQlKquaKO8+ab771FKu++MdYM9E6cgyVazf09zgY/u9e+caaxJCvVH+X8OaxHMYR/d9WZnJFCQl1Uo6bscbD/TBqy0Ik3QM5FP4CIc8tVv2cYstESqzi2TBGKbIVixsEnUGcOmHzCjNx/dpMqYZVlBD/qc82/KRhDo1siGXAtdDi8XcR3JV3vn6LpqxbhSQOtVuRTrJATQrLh/u0egdMMsq5MXEYbxuHHUs2u9vdOZQZF19YJmjrrhYHstAE+tDBtq87wsZ8uGeny1R1PYV7sDWmAxFi6SHDz/ygX+2ul+NtMj
 qHgJs5TI
 S471Nx5xuR/Fmf3O2GqSBG599IYoZOmr8lwztO7NHi+RwUKPCP1XKvDxAX2wv6EcVZ/amteLhLuAqjzRliWB+XZSyQTqhiBW0fWjVHyC/klB/gkcCG/TaDSqJk7nZ10ulij5bT6+HpVq+uuRobUbt/meMaGbL1M/XsxzZ4+CxZ7i6Qe5yU4ex7+La7M/YYa4ARM3pW0lCbQYeQ/qIsEjxhaX5fFntIKBbG9QbGo/xioaIZG1rX2eEzC5DHZZoUUKtpXvKW5bfd8InrJlKKHwlqCeHgGDqNs/HNjdcFizmHM5uQ9HHvsx5pBA82AzyZHTIJW6C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Thu, Feb 05, 2026 at 10:50:06AM +0530, Dev Jain wrote:
>=20
>=20>=20
>=20> On 05/02/26 2:08 am, Shakeel Butt wrote:
> >  On Mon, Feb 02, 2026 at 02:23:54PM +0530, Dev Jain wrote:
> >  On 02/02/26 10:24 am, Shakeel Butt wrote:
> >  Hello Shakeel,
> >=20
>=20>  We are seeing a regression in micromm/munmap benchmark with this p=
atch, on arm64 -
> >  the benchmark mmmaps a lot of memory, memsets it, and measures the t=
ime taken
> >  to munmap. Please see below if my understanding of this patch is cor=
rect.
> >=20
>=20>  Thanks for the report. Are you seeing regression in just the bench=
mark
> >  or some real workload as well? Also how much regression are you seei=
ng?
> >  I have a kernel rebot regression report [1] for this patch as well w=
hich
> >  says 2.6% regression and thus it was on the back-burner for now. I w=
ill
> >  take look at this again soon.
> >=20
>=20>  The munmap regression is ~24%. Haven't observed a regression in an=
y other
> >  benchmark yet.
> >  Please share the code/benchmark which shows such regression, also if=
 you can
> >  share the perf profile, that would be awesome.
> >  https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/micro=
bench/micromm.c
> >  You can run this with
> >  ./micromm 0 munmap 10
> >=20
>=20>  Don't have a perf profile, I measured the time taken by above comm=
and, with and
> >  without the patch.
> >=20
>=20>  Hi Dev, can you please try the following patch?
> >=20
>=20>  From 40155feca7e7bc846800ab8449735bdb03164d6d Mon Sep 17 00:00:00 =
2001
> >  From: Shakeel Butt <shakeel.butt@linux.dev>
> >  Date: Wed, 4 Feb 2026 08:46:08 -0800
> >  Subject: [PATCH] vmstat: use preempt disable instead of try_cmpxchg
> >=20
>=20>  Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >  ---
> >=20
>=20[...snip...]
>=20
>=20>=20
>=20> Thanks for looking into this.
> >=20=20
>=20>  But this doesn't solve it :( preempt_disable() contains a compiler=
 barrier,
> >  probably that's why.
> >=20
>=20I think the reason why it doesn't solve the regression is because of =
how
> arm64 implements this_cpu_add_8() and this_cpu_try_cmpxchg_8().
>=20
>=20On arm64, IIUC both this_cpu_try_cmpxchg_8() and this_cpu_add_8() are
> implemented using LL/SC instructions or LSE atomics (if supported).
>=20
>=20See:
> - this_cpu_add_8()
>  -> __percpu_add_case_64
>  (which is generated from PERCPU_OP)
>=20
>=20- this_cpu_try_cmpxchg_8()
>  -> __cpu_fallback_try_cmpxchg(..., this_cpu_cmpxchg_8)
>  -> this_cpu_cmpxchg_8()
>  -> cmpxchg_relaxed()
>  -> raw_cmpxchg_relaxed()
>  -> arch_cmpxchg_relaxed()
>  -> __cmpxchg_wrapper()
>  -> __cmpxchg_case_64()
>  -> __lse_ll_sc_body(_cmpxchg_case_64, ...)
>=20

Oh=20so it is arm64 specific issue. I tested on x86-64 machine and it sol=
ves
the little regression it had before. So, on arm64 all this_cpu_ops i.e. w=
ithout
double underscore, uses LL/SC instructions.=20

Need=20more thought on this.=20

>=20>=20
>=20> Also can you confirm whether my analysis of the regression was corr=
ect?
> >  Because if it was, then this diff looks wrong - AFAIU preempt_disabl=
e()
> >  won't stop an irq handler from interrupting the execution, so this
> >  will introduce a bug for code paths running in irq context.
> >=20
>=20I was worried about the correctness too, but this_cpu_add() is safe
> against IRQs and so the stat will be _eventually_ consistent?
>=20
>=20Ofc it's so confusing! Maybe I'm the one confused.

Yeah there is no issue with proposed patch as it is making the function
re-entrant safe.

