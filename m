Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C20CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141B98E0003; Mon,  6 Oct 2025 16:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2148E0002; Mon,  6 Oct 2025 16:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23068E0003; Mon,  6 Oct 2025 16:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB4C38E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:33:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AD62BAB6B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:33:08 +0000 (UTC)
X-FDA: 83968838856.20.9800559
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 127FA4000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:33:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uKjbHzCh;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759782787; a=rsa-sha256;
	cv=none;
	b=xnz8gtXy3Kx8S+BZuWBMS4muw/aeCHOyREJC+lETRaNjhDG9+i4GzPBgJJizobljfHeaPi
	a6CpLkKF2E4j2dszoO9DJRIlJS6Ppr1LMAN7EQWubaF1Jw51P7vwC44BGvNcbsRsFXR/XX
	gKIQIgMv+YR8hqhY8Qh+vEX0yTkviHY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uKjbHzCh;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759782787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHH+4bf3hlBlZ1LmstUIJffws4jWpMP8V0lgu/gJTUg=;
	b=b5aP5frXu6+KUDmYSVf7oO1BWEMlO+D8ET+RWGcCzIHmPfP3Q9ZctqrTt2nh7taISJnLBn
	q/KP6dC642WYPyzQr6XHlYzti7HsMWmnVfd0b2414E8GFEoQiUwuoe6uDa7f20YXYVwErR
	IUNTiqEOjVXTJkaMrze6hUQrYAPUKYA=
Date: Mon, 6 Oct 2025 13:32:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759782781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JHH+4bf3hlBlZ1LmstUIJffws4jWpMP8V0lgu/gJTUg=;
	b=uKjbHzChnzx2wm6WdKX0G2O+LfEbF03GVh9A/3b/TBEuOow+68ow8vPjH+P53r8tVxfIYY
	Xy3oB/BjxBm/7ZPUpEhPclJ5X/SBvU6wHFNuj3oRMrkCbsVeg6scn9Vmaf+j15PBbZiWt8
	JoZsT/ZOhVwDT9f/n4F61TteGGFb/OA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: JP Kobryn <inwardvessel@gmail.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Kernel Team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: introduce kfuncs for fetching memcg stats
Message-ID: <galnconmnd4uoupb5dfa7nbfmpeovpjnov6fnxa56sslejl5em@fmhbdnn5v25e>
References: <20251001045456.313750-1-inwardvessel@gmail.com>
 <CAADnVQKQpEsgoR5xw0_32deMqT4Pc7ZOo8jwJWkarcOrZijPzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKQpEsgoR5xw0_32deMqT4Pc7ZOo8jwJWkarcOrZijPzw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: em7whzgx9ubncf58aitbdszzfuc47yg4
X-Rspamd-Queue-Id: 127FA4000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1759782784-807884
X-HE-Meta: U2FsdGVkX192kgYlyK/I9z12WprymDAonzE+JxoI/dPYMcfDwvPFJmZYPeM5880NgPIEGMKANPd2QtK/NrF2K16zc96fN+R22dIR31xiO+QtBfDnn1wf5GzWq3a10Oz/yqPpgrN9tx1al1zIQ+RXSsRXrXbAM7KWdwhlIuldcuWPCO50rtFRB18nq9Im5uBLDlcKQiIptuKP3FRykiHTmEDmS2LLJuANl7h57yVcfsjjE8tJGq9AwRbmCOoMOY4GEk/hFq82koKUaHqPZaKgglJ3YmdDmsN3bu5ME0n1t8mJJLNneDkDQuQ6E8gRSMWtJoMAwu4NlwM5dEguOAeboTLBvOuASk0sXgzupnEFso15GsZBt/HnRFajUhoZkDv2ASrXcVWScLyXXix/O6yOWw6Ln9VbVlJ0bFpVWYBsqjRGHN1xAJk1XqxZQppa80vQoqlYm2yh9/Dxle3ANa8PeWwSsiUig+yPSC2xkxlOUQTThAbJ21yhXQzwZ9+6Ym6vQLuff1WdE8uGLp56yR0QnEQ05IDqDeAfqMJAmpy1/JMy5HvXHcUWTIMqu0rkS2njft0F8RS64rohbtJqE2ed8eSyG07y0Wcs26t4Zc2w3RqMdbO+a9cWiAfZkJNtttipp78ORT+g1AMPV9ufU1KyqpnBFyamvuv89DXP9ZN7pHKFxMe/cVZiYg2mKhp/ZRNzoezTtnqJ/CUKuUAe9o9vbVBu+eKtu1lipA5S3CrGTIhYnSWSjHQpqrwPMdW2RbEoweW7cfF/Og6DlPPkTi9fflKG2cFjvqOdL0EDgPJG8xye0cdeb7kliRfi8A1H1FbsQIY42RVXuyGsSqs6KS/yfsfMTT2WGvsi0DvZ/0huh7uXI00hLwL0ddGUKb6N3J9kUCan63bNHG1Lb+V4V+f58Mpao7eombNGQcw0bFeqG0Ufq2xSWJMi3TeGS6UW9LQ5DA5vAlRTe8CcMkXG0HE
 EO3MSXja
 HIj11JnE+Pjmy4b9Vhv2CsyuRlKwxolq0ooxY6/JMbFw35b4Yv/wSbG2TtrbM0h9EHxG/duZJ9MklcFpNJcSQJgY15z4K47zMhjje5FxX3J4BFbwpiuX3LQF3Q2/0NcZD0YUgRLrRtVYj/5EbrToVgCTFUIt392WbPGgmIwW8I56x+79Wy+COH1V7d3Ajs1SjRpjkmvVY65IVZCln2moO+Eb1EW5PnWoZqzWI5Pr9W4taJHLnYA6X0CmKxcWMaWzM4WDVEA85S90BZlPKQcm69CJX10Qi4dbJ3UvQswceSP3lnHbgw02XAwTfnmfrDW457GXE3Y4/iF/MRzKIkOeA5WM8o/jlgPrnjKAB6dFhh2o22DA+X7rtCAzQgegiK0KZkF67B/2vk4vfJbI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 03:25:22PM -0700, Alexei Starovoitov wrote:
> On Tue, Sep 30, 2025 at 9:57 PM JP Kobryn <inwardvessel@gmail.com> wrote:
> >
> > When reading cgroup memory.stat files there is significant work the kernel
> > has to perform in string formatting the numeric data to text. Once a user
> > mode program gets this text further work has to be done, converting the
> > text back to numeric data. This work can be expensive for programs that
> > periodically sample this data over a large enough fleet.
> >
> > As an alternative to reading memory.stat, introduce new kfuncs to allow
> > fetching specific memcg stats from within bpf cgroup iterator programs.
> > This approach eliminates the conversion work done by both the kernel and
> > user mode programs. Previously a program could open memory.stat and
> > repeatedly read from the associated file descriptor (while seeking back to
> > zero before each subsequent read). That action can now be replaced by
> > setting up a link to the bpf program once in advance and then reusing it to
> > invoke the cgroup iterator program each time a read is desired. An example
> > program can be found here [0].
> >
> > There is a significant perf benefit when using this approach. In terms of
> > elapsed time, the kfuncs allow a bpf cgroup iterator program to outperform
> > the traditional file reading method, saving almost 80% of the time spent in
> > kernel.
> >
> > control: elapsed time
> > real    0m14.421s
> > user    0m0.183s
> > sys     0m14.184s
> >
> > experiment: elapsed time
> > real    0m3.250s
> > user    0m0.225s
> > sys     0m2.916s
> 
> Nice, but github repo somewhere doesn't guarantee that
> the work is equivalent.
> Please add it as a selftest/bpf instead.
> Like was done in commit
> https://lore.kernel.org/bpf/20200509175921.2477493-1-yhs@fb.com/
> to demonstrate equivalence of 'cat /proc' vs iterator approach.

+1.

> 
> >
> > control: perf data
> > 22.24% a.out [kernel.kallsyms] [k] vsnprintf
> > 17.35% a.out [kernel.kallsyms] [k] format_decode
> > 12.60% a.out [kernel.kallsyms] [k] string
> > 12.12% a.out [kernel.kallsyms] [k] number
> >  8.06% a.out [kernel.kallsyms] [k] strlen
> >  5.21% a.out [kernel.kallsyms] [k] memcpy_orig
> >  4.26% a.out [kernel.kallsyms] [k] seq_buf_printf
> >  4.19% a.out [kernel.kallsyms] [k] memory_stat_format
> >  2.53% a.out [kernel.kallsyms] [k] widen_string
> >  1.62% a.out [kernel.kallsyms] [k] put_dec_trunc8
> >  0.99% a.out [kernel.kallsyms] [k] put_dec_full8
> >  0.72% a.out [kernel.kallsyms] [k] put_dec
> >  0.70% a.out [kernel.kallsyms] [k] memcpy
> >  0.60% a.out [kernel.kallsyms] [k] mutex_lock
> >  0.59% a.out [kernel.kallsyms] [k] entry_SYSCALL_64
> >
> > experiment: perf data
> > 8.17% memcgstat bpf_prog_c6d320d8e5cfb560_query [k] bpf_prog_c6d320d8e5cfb560_query
> > 8.03% memcgstat [kernel.kallsyms] [k] memcg_node_stat_fetch
> > 5.21% memcgstat [kernel.kallsyms] [k] __memcg_slab_post_alloc_hook
> > 3.87% memcgstat [kernel.kallsyms] [k] _raw_spin_lock
> > 3.01% memcgstat [kernel.kallsyms] [k] entry_SYSRETQ_unsafe_stack
> > 2.49% memcgstat [kernel.kallsyms] [k] memcg_vm_event_fetch
> > 2.47% memcgstat [kernel.kallsyms] [k] __memcg_slab_free_hook
> > 2.34% memcgstat [kernel.kallsyms] [k] kmem_cache_free
> > 2.32% memcgstat [kernel.kallsyms] [k] entry_SYSCALL_64
> > 1.92% memcgstat [kernel.kallsyms] [k] mutex_lock
> >
> > The overhead of string formatting and text conversion on the control side
> > is eliminated on the experimental side since the values are read directly
> > through shared memory with the bpf program. The kfunc/bpf approach also
> > provides flexibility in how this numeric data could be delivered to a user
> > mode program. It is possible to use a struct for example, with select
> > memory stat fields instead of an array. This opens up opportunities for
> > custom serialization as well since it is totally up to the bpf programmer
> > on how to lay out the data.
> >
> > The patch also includes a kfunc for flushing stats. This is not required
> > for fetching stats, since the kernel periodically flushes memcg stats every
> > 2s. It is up to the programmer if they want the very latest stats or not.
> >
> > [0] https://gist.github.com/inwardvessel/416d629d6930e22954edb094b4e23347
> >     https://gist.github.com/inwardvessel/28e0a9c8bf51ba07fa8516bceeb25669
> >     https://gist.github.com/inwardvessel/b05e1b9ea0f766f4ad78dad178c49703
> >
> > Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> > ---
> >  mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 67 insertions(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8dd7fbed5a94..aa8cbf883d71 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -870,6 +870,73 @@ unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
> >  }
> >  #endif
> >
> > +static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
> > +{
> > +       return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) : NULL;
> > +}
> > +
> > +__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)
> > +{
> > +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
> > +
> > +       if (!memcg)
> > +               return;
> > +
> > +       mem_cgroup_flush_stats(memcg);
> > +}
> 
> css_rstat_flush() is sleepable, so this kfunc must be sleepable too.
> Not sure about the rest.
> 
> > +
> > +__bpf_kfunc static unsigned long memcg_node_stat_fetch(struct cgroup *cgrp,
> > +               enum node_stat_item item)
> > +{
> > +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
> > +
> > +       if (!memcg)
> > +               return 0;
> > +
> > +       return memcg_page_state_output(memcg, item);
> > +}
> > +
> > +__bpf_kfunc static unsigned long memcg_stat_fetch(struct cgroup *cgrp,
> > +               enum memcg_stat_item item)
> > +{
> > +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
> > +
> > +       if (!memcg)
> > +               return 0;
> > +
> > +       return memcg_page_state_output(memcg, item);
> > +}
> > +
> > +__bpf_kfunc static unsigned long memcg_vm_event_fetch(struct cgroup *cgrp,
> > +               enum vm_event_item item)
> > +{
> > +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
> > +
> > +       if (!memcg)
> > +               return 0;
> > +
> > +       return memcg_events(memcg, item);
> > +}
> > +
> > +BTF_KFUNCS_START(bpf_memcontrol_kfunc_ids)
> > +BTF_ID_FLAGS(func, memcg_flush_stats)
> > +BTF_ID_FLAGS(func, memcg_node_stat_fetch)
> > +BTF_ID_FLAGS(func, memcg_stat_fetch)
> > +BTF_ID_FLAGS(func, memcg_vm_event_fetch)
> > +BTF_KFUNCS_END(bpf_memcontrol_kfunc_ids)
> 
> At least one of them must be sleepable and the rest probably too?
> All of them must be KF_TRUSTED_ARGS too.

The *_fetch ones don't need to be sleepable. Will marking them sleepable
here make them more restrictive?

> 
> > +
> > +static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
> > +       .owner          = THIS_MODULE,
> > +       .set            = &bpf_memcontrol_kfunc_ids,
> > +};
> > +
> > +static int __init bpf_memcontrol_kfunc_init(void)
> > +{
> > +       return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> > +                                        &bpf_memcontrol_kfunc_set);
> > +}
> 
> Why tracing only?

I can see sched_ext using these to make fancy scheduling decisions and
definitely bpf oom-killer will need these.

