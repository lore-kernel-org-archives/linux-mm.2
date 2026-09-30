Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20032CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 13:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000986B0088; Wed, 30 Sep 2026 09:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3BC6B008A; Wed, 30 Sep 2026 09:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09106B008C; Wed, 30 Sep 2026 09:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA7A06B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:28:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41C62A07B4
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:28:31 +0000 (UTC)
X-FDA: 85270508022.20.9660CF9
Received: from mta1.migadu.com (out-224.mta1.migadu.com [95.215.58.224])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0462812000D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:28:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dw9rFbZO;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790774909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PM+HIaQaVukBWhY6PwwAw8oJcqlCKt9t1wHgfzzd+08=;
	b=IaN66so8EU5RdUQpWelDC79vSi5CCD9mPxtMoPZWy+FZ4SVQaHF8QAcEv/s4kM8J37ZBqb
	QQ7fb2k62zlV9iogungjr+9RCx4z2dTdR07pNgC/hNs9qE0IQSeV8gDiwx3yMbJToaldbS
	dCH9u2eeKd1DKH7mCIhh7jFG5gZQ5sg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dw9rFbZO;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790774909;
	b=8de5lthLC0QZWvjjrUuGc/ZNaKDcH/L8ae1XhcNtv+iKlsCF4JQeUAiAzWC8sc4OZGLOs5
	JfxNxs9TyIr9aQJjTQUELsR0BLjDAf5IkRyGhNecoXxIOJkVd6ZGAz/erS8vNeVb/+oAkY
	SJylw2rj+rDNOlPhXo+CQ2t/vloFsyk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Hsdm4rJdIk1UsbW5gttlY7rEJh2gpgb8d3cHbDg7CKw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790774907; v=1; x=1791379707;
 b=dw9rFbZOf7XvxLNqrULbYFqI/7sEpm2RPYJqOonRKM+bEjnj1BKPUV76yuCHYg67mCK2+OXQ
 wMMl/bOPbsOOp/+ZsWSRIONsey/wvGPgOpPhjHoqgxDk8pr099nRBEDh/qaFit9hTjnLM+Slu8L
 q1JKEmWRYRONghXKspKAWN3c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3a312f617140e728;
	Wed, 30 Sep 2026 13:28:26 +0000
X-Mizu-Trace-ID: 3a312f617140e728
X-Migadu-Flow: FLOW_OUT
Date: Wed, 30 Sep 2026 06:28:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <arw4rjVkm2ob9ioL@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bda525506b3fb3e61da28a112f28abba@kernel.org>
X-Stat-Signature: tyirob6jt3xwbsd48rjxfhmt8fg6fquq
X-Rspamd-Queue-Id: 0462812000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790774908-755518
X-HE-Meta: U2FsdGVkX18PIrsmKUWH472QhHT4aNArBjxWa1RlxCFvbrymQehO/nfbd+krplFoXRdOoUKRUvNi1f8z/ydAbsMLqEllDJSg+rhdeMx7if167GjB5EKHNS0tN6A3n2Hk57OOxJZ2eYgIiNjY3yQkjW1hHReaUzYBwDLUJSsBIrxcDWvAzi1UAwgYdkiuixMp9OPCb0WYOnb1QVuVPl7TT6fmcHljBOEerLRdO8s2GFKtsKCeD8f4rvGWK6n0xQvmvhMxzqFwrfnPfYLI7QzlsyRshjNv3L+c2Jid6WovzX/dFWodeJGjlgH5oecyyHg6CLp88CA0erf77IWtbt9NaOIqSiS7KsW5VZJzaJiKl054L2T+DvHjFVCTJJ4mv242oGjm58C222Nwxy2JpN/6h47+MUgQkpmc5AZLRVuipNQEgrg6t/NBhm/h7+8gboJi3SIjrnVSx3ZoJLnzppdKRuXmIq2ntEbia+ndqnLEoAFYKHLP69Ulhm0SGKL94YzNFvkQw90MQ+lkvERJRE3EYC9FD1kOxeeaUjb4kaQ/TZYjmt3tr5gD6ycGXpD7oG2J7y/yhbey+MHb4CsQXgi/RLcXDC1GElEjFNFqnGn4ZIULEDxkdLQn61ZoCyTVswo5a445Xf9e0nswxtAQFLTENzC0Qm//VAppfQy07W6VNvvOQjNmSJsrXt2hSyL9QsqG6sYbts4uuiQoHFVal5Nxi8rM4fBn3Nqwm794XG6QWZsOAlGuKv+q6kzAqkkKEbEOqJ7443E+3JdVhnTedVXciupziSCN2RM0tJpQQ9ZABqMkD/4FeRVGHeu59udUtmoyISpncepirZSgHSCP83b81SC32bQW+izrx3OTjzXwYfrsjP8FTC3jufU8ghXrw1H4NqSSZwaqyJokel9jaxA8FuNMLilLfTi9YO2S5SwaZedRC1gZ9I5E0AV3FhipYKzB0buVMEgmovWSAQEVI8t
 8KZ7xa2C
 kGiPtzgH2c/avPPb2siMwDsne9bjprjr1mpkcWMvY7lgISRGtZuaeAMc+MVBl2mlA1TFo6chFa5j1A4FNNCivdjNwPYwPGsxi2tOtZV5r1KkVp08nL1sMvFRLDcow5Kg6479suowsO5euOVv7uBGJiJvOCzcwfjx9nkxQuh0VE84w4oP8i/NROfReBcFQhJiY9XoazzJRhQb4lTzehui/GT5OKIrst/APIsiO6fRz11x9VYxUEX2waCJue/UamWDCB7IsbKQPtH4zhxbFA3wz2nPnhGhX9KfpYhxtctjANh3MsFImX9/kfsdsGIqjIek+h05mmB78CsaYwzbAP9ZNHOPvJNWaSzN5kTna1TYJdyZ/B16DBMkg6icbSMlHKhy0cxShaWw1/4XpL88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 10:40:20AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Mon, Sep 21, 2026 at 12:25:55PM -0700, Shakeel Butt wrote:
> > try_charge_memcg() calls __mem_cgroup_handle_over_high() before it returns,
> > which reclaims and can throttle the task.  That happens wherever the charge
> > happens, so a task holding a kernel lock can be stuck there, and everything
> > waiting on that lock is stuck behind it.
> 
> Why not just raise the lazy bound high enough that most charges never
> enforce inline, and maybe annotate the specific paths that can allocate a
> lot so that they do? Inline enforcement should be the exception, not the
> rule. Flipping that and then trying to reverse it with custom BPF policies
> doesn't make a lot of sense.
> 

Please correct me if I misunderstood you. Mainly, you are saying that we
should have a sane default behavior for memory.high. At the moment, if the
current charging process accumulates charges totaling more than
MEMCG_CHARGE_BATCH pages and the target memcg is over its high limit,
memory.high is enforced synchronously. You are suggesting that we should
increase the threshold from MEMCG_CHARGE_BATCH to some arbitrarily large
number. In that case, synchronous enforcement of memory.high will be very
rare.

I am fine with changing the default behavior. Actually, I have been
contemplating whether I should propose a revert of commit c9afe31ec443e
("memcg: synchronously enforce memory.high for large overcharges") because
it has introduced more problems than it has solved, but that is a separate
topic. The initial commit already mentioned that MEMCG_CHARGE_BATCH was used
arbitrarily, so replacing it with something big might be acceptable. I want
to keep that decision separate.

I am not sure about annotating specific paths. I think it would impose a
greater maintenance burden as the kernel evolves, since the annotations
might become stale. Also, people might object to adding memcg-internal hooks
in non-memcg code paths. In any case, this can be explored separately.

Returning to the actual proposal, my plan was to start small with a narrow,
specific use case. However, my long-term plan is to provide a mechanism to
change the default behavior for custom use cases. For example, for
memory.high, I will provide a way for users to specify what behavior they
want, i.e., whether or not they want more synchronous throttling. Second, I
will introduce a mechanism to trigger async reclaim workers. I also plan to
extend this functionality to memory.max. I just wanted to convey that I will
keep pushing this proposal, with the use cases adjusted a bit.

> > One concrete scenario which can be resolved by this new feature is the
> > kernfs notify worker. It delivers notifications with the cgroup2
> > kernfs_rwsem held for read, and the charge for the delivery allocation goes
> > to the cgroup that set the watch, usually one already under pressure. So
> > the worker reclaims while holding the lock, a waiting writer blocks every
> > later reader, and anything touching cgroupfs stalls for seconds.
> 
> Slowing down the kworker inline doesn't make sense. It's charging on behalf
> of the watcher through set_active_memcg(), which already tells us whose debt
> it is. Wouldn't it make more sense to defer the debt to that cgroup instead
> of slowing down the kernel thread?
> 

Yes, that makes sense. When a non-task-context charge exceeds memory.high,
the kernel already schedules high_work for the charged memcg. I plan to do
the same for kthreads so they need not reclaim or throttle inline. This is
best-effort reclaim rather than exact debt accounting; I still need to
examine userspace tasks that charge another memcg through
set_active_memcg(). I am addressing the reclaim worker's CPU accounting
separately.

Thanks for taking a look and providing feedback.

