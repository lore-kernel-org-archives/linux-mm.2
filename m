Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D3B606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q1PUiHki
Received: by kanga.kvack.org (Postfix)
	id 386BD6B05B4; Tue,  3 Nov 2026 14:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E6F6B05B6; Tue,  3 Nov 2026 14:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277006B05B4; Tue,  3 Nov 2026 14:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E77236B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:08:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 662B51C3D53
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:08:00 +0000 (UTC)
X-FDA: 85394742720.15.4ADAAF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C11BC8000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:07:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1PUiHki;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793732878;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lmbd2zINdcFJEsKttels94/lSvSKbYVRhf8W4gVvI0M=;
	b=pvrw7H+W5m4laD29QmtCzA1Sq6P3Yg1AC4X2kWmkBdRvvq85XJcIjjw5h7JfAHeEz43i9s
	hSK5/IL0sID9zrEyD9UGbjBy7ij3tUhkvKjk3I0SqsQen+XPFPhOV2vbPJF4kY3MAVVjV6
	z9kVIt0re8I2HTsM+xLMVYjpdHkjFaw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1PUiHki;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793732878;
	b=Hm9r1j2R0GAxyhqyYOsotWT7Y92GXXVzFJ+0+AnoYbABh1bKa3xMnFCn2Yooj6oMzeAGMR
	LOelzJg4oCftBHyhRo1vI4SN2fyZCDEZKSExD5fgHxGOp00aLRV/DfzrHFL7mBXFZrD/hv
	0iKAhPazjF6wqJdXlTUJbaB0cElAqBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C67E609EB;
	Tue,  3 Nov 2026 19:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBB51F0093A;
	Tue,  3 Nov 2026 19:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732878;
	bh=Lmbd2zINdcFJEsKttels94/lSvSKbYVRhf8W4gVvI0M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q1PUiHkiuD66i9itoKJxIYkyzDAK6zu7VDkvdc50PUOnlxFunr5pBcD4FVxjXxouL
	 Z1dp8U35zueBMTTlphtnvBi4Tor463tYtZAlB6LT+rv+XG3Lk10OfxOquRMwLrW/Ow
	 /IhV6pS8GAteyqGLnAhMTlPFZusubLD8OKs+US5UJU/lXR40VtEzHa5PVr+3kXFScn
	 3xN6T+iBY9fB57SaRPL+JYtkcrJJ06HYsTfAMEqWtRl0fFIewzAdlZGyv8euY4Xe/g
	 FN3RLZRvJs0RYzFrB2ItlFrIIHo3E99ldcv/h8xio85KHzdFAjHOdSM1sdFrWCTDBy
	 y7fMmb812dzdA==
Message-ID: <sashiko-outbox-195892@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v23 10/10] lib: add a benchmark of hierarchical
 per-cpu counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "David Hildenbrand" <david@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Martin Liu" <liumartin@google.com>, "David
 Rientjes" <rientjes@google.com>, christian.koenig@amd.com, "Shakeel Butt" <shakeel.butt@linux.dev>, "SeongJae
 Park" <sj@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Sweet
 Tea Dorminy" <sweettea-kernel@dorminy.me>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Wei Yang" <richard.weiyang@gmail.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Al Viro" <viro@zeniv.linux.org.uk>, "Yu Zhao" <yuzhao@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Mateusz Guzik" <mjguzik@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>, "David Carlier" <devnexen@gmail.com>, "Josh
 Law" <objecting@objecting.org>, "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Kees Cook" <kees@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, linux-trace-kernel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Oleg Nesterov" <oleg@redhat.com>
In-Reply-To: <20261102190708.1287100-11-mathieu.desnoyers@efficios.com>
References: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
 <20261102190708.1287100-11-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:07:55 +0000
X-Stat-Signature: xkuefujut1warfoypz4foozy8i9ck5xo
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C11BC8000E
X-HE-Tag: 1793732878-934034
X-HE-Meta: U2FsdGVkX1+BH+Q/HR9oK7RJ+ESFsgwvVKpNIv9/IU+nYWsLNrDIJcDsX3zsmmwJxa6OGl4FY04mHE66DPFR4HL5I+rtyi7qoXSDDY99fazM4Y+SoJKKW4KN/w0gzrhVS7kYQR8+gJuHWPMCjvB3TUZKgZCSaZ/P1bzjAO+alCEQV7sbmN5lgInFlTYdKZy/BEOHyycPFkefhvlhIEJy3R8OWGzXfPDCSW5iozMXhQsIQfSTD+iNdS0eNhNjUqbEQWx51rh/SlWtDCtxllJ1epXVexI6F9hN6YyXDNHsnbHWeXqEtKZ4Yhv7wgtNiTGO+VFdQTcFLwWJaN6s0qd5Yv3DwRQpG0+k6q/JkGtZ0Ewu2383+JU5XBZDhv0/P+cSUJoNJzHjR3zYQW4u/sujrSR0ihMT9wi0UZ839yOgMKfvz6Kykn9tCoxSEPf7gjLo5IhFqDzf4PlgWOsnCy/jrGFogFYspeRAW0e6fsANt+giErfjbqtXovMPEgexkM7CaB/3JUQZwPSfopMIACdKe+sd3tPBDshy1y98a6Zg0cqQ1VjdM+bHINthVFfZA7zy+rAZcrpB4ow5jX691o5TEHDna3pON48pVIJytTyXPAu171u1LI0VEVozISuTZJj5p1kr2egasAbIIUTiwcZdGeXNCU77T7PEz17+9fcXqHBka/ne//vlqaZXLe2yRR5BNKhiQ3KRIKoXdohuOKBC2CjJYQoL0OlpWFGdPTtKxeziOA7EFMwM6T56cmHd0rATKdp58+ppqP7jzKtO7UvuSoC7WZAalyR0O+RqTaqslrsujB/V2GlP0f6ImfaHowuJuHyZ2Xvp+0142uX49N+dZG3pXuw9t0Y5MzpElS2/GTOiymW+EHVzn4SNrtB6nE/cNAHH7ikOnkizJ1jjFC2syJdi2+H050sRvCLh0DCTBkc29YqQ4rtBlDaOxkU9wXSXQdrJAKsty9KRpHV7Ztm
 bzyuZyFd
 /JsYNCp1+loXGPYNAmB3WLCCgM2nEHnzFDL/A/4hPRpmfItA5/oaKBhsIqAo6VEQCtLmIbSL2LJta4WoD/k/rcfPNwSZen04mUlCCS//YIWnMu1LhebZAWbUV0zRd+jS1ZedEwsFSf7v2hN3UfQXKEf2A8EQWyz+hoZlLcY6zSBkR6F9Y+Sg4R9MIRBvX1WVtIQGYw01oGMBv/XQS3KHJ51n5UVYUCtoPYio0wWZ4QYhkyt2Ehmbew+6OT55enx5fReUNEpKdaeRPjoG6EbbCmW1W2NH+ZmrBreubY9SSIdkP+LkS9QlKgu/JGQe1Xhnxx7HT4PfXDFZ6Smgi/nEnoNQMEr+fyLtxuWirbG3wz65l86pvfK3yYDlKEpAcPBsHsSgPBUn1LoxYCzZgpdioy20v7djLgDcoDUkr7N0GpxFDXWq0ADbIDB4MxWvXwM6ira97AO6ewJprEl3A25XQiZOUsiMgDuIg6dJQx1JIBAMFPLbAgPHk0c7LlwtGVr83xTG5wcPTj9mi3njYiM8yO+Vzxhq3eVGh0Ta3+L2SZWQz5Sq2kpiho0XcAa0XxsUb3GavFkZZQ0WaCwYVCJuFUNUbUOfdIQM4eos/p5OWD/jYuOTO7MS3OrqNC2c4GXM9Kvz5KiEbcq1dgq1YaQATFX6XKDuVCrY1y40ZH9sLOXO80xukYBWPvcTqnwJ86O1jr/zC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] lib: stack-allocated percpu_counter in bench triggers debugobjec=
ts WARN_ON
- [Low] lib: missing kernel-parameters.txt entry for percpu_counter_tree_be=
nch.batch
--

commit a1a6611650e4e4f4d5279cc3d46fb8ab12ea614c
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

lib: add a benchmark of hierarchical per-cpu counters

This commit adds a KUnit benchmark comparing hierarchical per-CPU counters
with struct percpu_counter across update, lifecycle, and churn workloads.
It introduces CONFIG_PERCPU_COUNTER_TREE_BENCH and the batch module
parameter to configure the hierarchical counter batch size.

> diff --git a/lib/tests/percpu_counter_tree_bench.c b/lib/tests/percpu_cou=
nter_tree_bench.c
> new file mode 100644
> index 0000000000000..bf260bef196a5
> --- /dev/null
> +++ b/lib/tests/percpu_counter_tree_bench.c

[ ... ]

> +/* Like the RSS counters by default. */
> +static unsigned int batch =3D 32;
> +module_param(batch, uint, 0444);
> +MODULE_PARM_DESC(batch, "Batch size of the hierarchical counters (power =
of 2, 2 to 128)");

[Severity: Low]
Should percpu_counter_tree_bench.batch=3D also be documented in
Documentation/admin-guide/kernel-parameters.txt?

Both the commit message and the CONFIG_PERCPU_COUNTER_TREE_BENCH help text =
in
lib/Kconfig advertise passing percpu_counter_tree_bench.batch=3D on the ker=
nel
command line alongside percpu_counter_tree.arity=3D, which is documented th=
ere.

[ ... ]

> +static int bench_lifecycle_fn(void *data)
> +{
> +	struct bench_thread *t =3D data;
> +	struct percpu_counter_tree c[LIFECYCLE_NR];
> +	struct percpu_counter pc[LIFECYCLE_NR];
> +	u64 t0;
> +	int i;
> +
> +	if (bench_wait_go(t->sh))
> +		return 0;
> +	t0 =3D ktime_get_ns();
> +	for (i =3D 0; t->sh->impl =3D=3D IMPL_PERCPU_COUNTER && i < LIFECYCLE_I=
TER; i++) {
> +		if (percpu_counter_init_many(pc, 0, GFP_KERNEL, LIFECYCLE_NR))
> +			break;
> +		percpu_counter_add(&pc[0], 1);
> +		percpu_counter_add(&pc[0], -1);
> +		percpu_counter_destroy_many(pc, LIFECYCLE_NR);
> +		cond_resched();
> +	}

[ ... ]

> +static int bench_churn_fn(void *data)
> +{
> +	struct bench_thread *t =3D data;
> +	unsigned int pin_period =3D t->sh->pin_period;
> +	struct percpu_counter_tree tmp[LIFECYCLE_NR], *c;
> +	struct percpu_counter tmp_pc[LIFECYCLE_NR], *pc;
> +	u64 t0;
> +	int i;
> +
> +	if (bench_wait_go(t->sh))
> +		return 0;
> +	t0 =3D ktime_get_ns();
> +	for (i =3D 0; t->sh->impl =3D=3D IMPL_PERCPU_COUNTER && i < CHURN_ITER;=
 i++) {
> +		bool pin =3D pin_period && !(i % pin_period);
> +
> +		pc =3D pin ? &t->pinned_pc[t->nr_pinned * LIFECYCLE_NR] : tmp_pc;
> +		if (percpu_counter_init_many(pc, 0, GFP_KERNEL, LIFECYCLE_NR))
> +			break;

[Severity: Medium]
Will passing stack-allocated struct percpu_counter arrays (pc in
bench_lifecycle_fn() and tmp_pc in bench_churn_fn()) to
percpu_counter_init_many() trigger a debugobjects WARN_ON(1) when
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is enabled?

The call chain is:

  percpu_counter_init_many()
    __percpu_counter_init_many()
      debug_percpu_counter_activate()
        debug_object_init()
          __debug_object_init(..., onstack =3D 0)
            lookup_object_or_alloc()
              debug_object_is_on_stack()

Because debug_object_init() is called with onstack =3D 0 while pc and tmp_pc
reside on the kthread stack, debug_object_is_on_stack() will warn that a
non-onstack object is on the stack.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102190708.1287=
100-1-mathieu.desnoyers@efficios.com?part=3D10

