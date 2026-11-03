Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB16606D80E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngGMpUJa
Received: by kanga.kvack.org (Postfix)
	id 8DDE06B00EF; Tue,  3 Nov 2026 14:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5866B05B1; Tue,  3 Nov 2026 14:07:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784416B05B4; Tue,  3 Nov 2026 14:07:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD1696B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:07:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE389A7D9E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:07:54 +0000 (UTC)
X-FDA: 85394742468.28.0DE6525
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 48B6F2000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:07:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngGMpUJa;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793732873;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hj5sGf4zuQDzxKH9qB3EIUe2aXuw6LNNWfdi8I5hW/k=;
	b=evvx4nbtGTBKKXJojxY3YIs3+erGsDzCDmWCrhl5sCkYl0U99qq2JshKU891Q1AW/9D0V6
	n0zRzQjk1WYSQgkzP+/8ckaXaDmuddoHgBWBhX/VDj9OBQtJSmoiStkiE4wSWzt/ok6v68
	lCeFOmIR85JpgZlvg6hhrzOqj335MYE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793732873;
	b=jKtnAmJ4Q0rnNvcP8tdr3yVx4AB5VujkvhWKbD6yNBCDhboOtuxneTmAaJr5NfmeRZkZlL
	Y4VNpIYH+yB33+svJFTUttU+6OUJW0lui9STFUJhlXagLQ+iqgvPK4YUkGlmXqvwau9FSs
	lvcSwHC+Eg4Nv1I67ykeqSUoeM3X3XA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngGMpUJa;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A65BD601EF;
	Tue,  3 Nov 2026 19:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8221F000C1;
	Tue,  3 Nov 2026 19:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732872;
	bh=Hj5sGf4zuQDzxKH9qB3EIUe2aXuw6LNNWfdi8I5hW/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ngGMpUJa26AXpOYCLOj8Ws2TWAtRrkSUJNmAMWoILDJ/YqTAp7sZpQTVsoS1jSuN6
	 2GzbPOEBiHxEnnKlesKpTlg3zLI6egZjPUSvDK/qL0DYBNlDHXBIBUyjl739WFA52M
	 QGMIbVxGdSoz2RqEr5vKBT2KQXwgctslR2Rh9hgjjdxrXGLdtwLdF2RZSa0jcf9cKh
	 g6GSjyKpKgu6gK7xAHo5EsfUzkMAZDls82BoEd8VdXwvDS5HtF81yMIaNcdWeMWjUk
	 9DwCMnxXu3qOQr5th0d6Gz1UfZf1igpLEPpLT9F9iuKweOptfFcAJbx1zFBR/zL8j7
	 cRLu58yPfANVg==
Message-ID: <sashiko-outbox-195884@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v23 02/10] lib: test hierarchical per-cpu counters
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
In-Reply-To: <20261102190708.1287100-3-mathieu.desnoyers@efficios.com>
References: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
 <20261102190708.1287100-3-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:07:49 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: iukc5dwgufh1kpmas9po3ntb3q958arx
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 48B6F2000C
X-Rspam-User: 
X-HE-Tag: 1793732873-93999
X-HE-Meta: U2FsdGVkX1+gRc8jbAvBNdAXgTNbDp1WWis21BiVHKwN5p/sNbzWVjNPFIf5UGRtRLbD16rNpTkP8KO5PCJexn/9w/uUnU6XALYFKnK7XM+0XFknKdconexXvgxlWft3Yvdr54ZAPjLOZhzVcMhnpfrMABwT9tJfg15l8RVKBI+l/lbS61UYZS9NZ6bJr40eehGCI9AVfkwK2dW4A4Op+0BequXD5ydR1iB0XWi0Z20QztdncV97h5McnjgRJ7ABNeAGMBoYkwHXhz8ah236Kk5NTNUvbJ2++mDfqypOL4h5Qz/Mzyq0ZoVNDuQdYGnVQsLzOomD0Pxrvdm4UnSlWYHXIS/fLCxsGjShqaY13y4GTXi3x3P8Qk/d2/o0Q03L7o6JJ7Jk9R7YSmssGLe87DHLbfco/SLU5Dwqj9D8wSGj0k3qJ5HzvU1BKawYnFoCMiRoA44MBWnxIbt79Pht+SRu+15L6QGgs/Zsvz3+TGimgjC9/koxjL87F2teRHIbvSGZMoQT0nIkZ07D3zap2SMboYLg8hLNBgJYL3w4M144A2X0v6LzSKKFqAol5FXQ5q6nfWjAF3aAdLv13hLZcOdfL2MownZxbHgnGTlwmdszdwWVRQRWymuTaiAVp/8an002Y9Zg85yk6v4J4v4UxzkU2a6ExN9MyhGCPfyCFjbjjdFtpSjh+kWR8wOfaTBmDhO8GUjW8WQaiIfpg0DgcsX5FQ7d4UCbEHXRYdoJ3cZjEVjAS7/a7xCMfxEisctqFrd87eX6XdE/AQxOE/fm/ePEFsYrb6Fy8Ua6w2YVQbGF58A5sx+27FjIo35omzCMND0VLsqLxxWfnfU3+0nOxoa6dqBJKzjIy8XVHnecy4pmAZF+rueF9Imm7Gf/0L84tZ/kf7hW10Iih/w1Tnpc8h6PS7BmWka4K2fBNhe6N7xAJqcQB0XLzQWex1ddZBRV6nZUom56nl7TJzpCVFf
 y7ff6MND
 JBrIJjsI1u9Qwp6bq3i5nfAU6GHA2uvdpCx+EtVLTYte/hORnjF9XbQ5b0i8lUkmyNXwq6joLpZyFyMwB7VLaIG4yucrhqJS/Np+u+h4PX2mmZ1w2z+CxqzY0IKSYja9V4o6teJc0zHWz5oX1Jz3ZHK+af354XhXDhK7617om46zO4jjEdFum01S05PZREL2flq/wEaqMYlcxXZwYWCI04lKpZjTrdciuQqBVQDg7RElu8aBaBeMtQMmlcdz8syJqQa2HCVLUGTI6oNJLbcOB8/ygX91CynsDm15Zbho2p5tVClKpmgcdcitxY4NvdCFliO5c6QIOuCmpDGFTiivtFeMlnvL4AbxmTSBUd9p5ks0/Q9QjR9ZhGXzRWAgSVNSpENbFK7AUbTGPJOUPk+Jp0K+pw2bunneo3Ufdo8DnPjQaKm36e+VZY96okBf0ZQiXfwiF39RpS+zXL4IEgUWMoxnY1fFt9r2E1g0JUzsH4A+U74XTKj4EJ/i78HOsMzophUVNADBJiFJYU/7Zu1yJvDYmLTwyJrLYLzgIwg0KKl+al/bnlDNNlfcV8BraE1H9kXQBKYpguqTDe0l9CXx46zzgbNLAIWLa2yaoOunwXTBHXLDsh0Sd7RHkyxjOrHKtELLWSxvsN2Tlha/BbphsqbJze+peo+Cdc8DlUNhpaX2E1rADDWC+LgvxfAa2vOzjmrz43IvuhI3A7PX+5vSlaeSxxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] lib/tests: unlocked cpu_online_mask read passed to work_on_cpu()
- [Medium] lib/tests: missing release/acquire ordering on sh.started in con=
tention test
- [Low] lib/tests: unlocked num_online_cpus() check in do_hpcc_test_saturat=
ed_compare()
--

commit 48b3ce088047ee1ccff5c20155903c1a143e78df
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

lib: test hierarchical per-cpu counters

Introduce KUnit tests for hierarchical per-CPU counters covering
single-threaded updates, concurrent multi-threaded updates, contended
carries, and saturated counter comparisons.

Link: https://lkml.kernel.org/r/20260227153730.1556542-3-mathieu.desnoyers@=
efficios.com

> diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_cou=
nter_tree_kunit.c
> new file mode 100644
> index 0000000000000..58b2e488e3c6b
> --- /dev/null
> +++ b/lib/tests/percpu_counter_tree_kunit.c

[ ... ]

> +static void do_hpcc_test_single_thread(struct kunit *test, int _cpu0, in=
t _cpu1,
> +				       enum up_test_inc_type type)
> +{
> +	unsigned long batch_size_order =3D 5;
> +	int cpu0 =3D _cpu0;
> +	int cpu1 =3D _cpu1;
> +	unsigned long deadline =3D jiffies + SINGLE_THREAD_MAX_SECONDS * HZ;
> +	int ret, i;
> +
> +	ret =3D init_counters(1UL << batch_size_order);
> +	KUNIT_EXPECT_EQ(test, ret, 0);
> +	if (ret)
> +		return;
> +	cpus_read_lock();
> +	for (i =3D 0; i < 10000 && time_before(jiffies, deadline); i++) {
> +		struct single_thread_update u0 =3D { .counter_index =3D 0 };
> +		struct single_thread_update u1 =3D { .counter_index =3D 1 };
> +		long increment;
> +
> +		switch (type) {
> +		case INC_ONE:
> +			increment =3D 1;
> +			break;
> +		case INC_MINUS_ONE:
> +			increment =3D -1;
> +			break;
> +		case INC_RANDOM:
> +			increment =3D (long)get_random_long() % 50000;
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			increment =3D 0;
> +		}
> +		if (_cpu0 < 0)
> +			cpu0 =3D cpumask_any_distribute(cpu_online_mask);
> +		if (_cpu1 < 0)
> +			cpu1 =3D cpumask_any_distribute(cpu_online_mask);
> +		u0.increment =3D increment;
> +		u1.increment =3D increment;
> +		work_on_cpu(cpu0, single_thread_update_fn, &u0);
> +		work_on_cpu(cpu1, single_thread_update_fn, &u1);
> +		check_counters(test);
> +	}
> +	cpus_read_unlock();
> +	fini_counters();
> +}
> +
> +static void hpcc_test_single_thread_first(struct kunit *test)
> +{
> +	int cpu =3D cpumask_first(cpu_online_mask);
> +
> +	do_hpcc_test_single_thread(test, cpu, cpu, INC_ONE);
> +	do_hpcc_test_single_thread(test, cpu, cpu, INC_MINUS_ONE);
> +	do_hpcc_test_single_thread(test, cpu, cpu, INC_RANDOM);
> +}
> +
> +static void hpcc_test_single_thread_first_random(struct kunit *test)
> +{
> +	int cpu =3D cpumask_first(cpu_online_mask);
> +
> +	do_hpcc_test_single_thread(test, cpu, -1, INC_ONE);
> +	do_hpcc_test_single_thread(test, cpu, -1, INC_MINUS_ONE);
> +	do_hpcc_test_single_thread(test, cpu, -1, INC_RANDOM);
> +}

[Severity: Medium]
Can cpu go offline before or between the calls to
do_hpcc_test_single_thread()?

Both hpcc_test_single_thread_first() and
hpcc_test_single_thread_first_random() sample cpumask_first(cpu_online_mask)
without holding cpus_read_lock(), and then pass that cpu across three
separate calls to do_hpcc_test_single_thread(), each of which acquires and
releases cpus_read_lock() on its own.

Because _cpu0 >=3D 0 (and _cpu1 >=3D 0 in hpcc_test_single_thread_first()),
do_hpcc_test_single_thread() never re-reads or validates cpu0 or cpu1 under
cpus_read_lock() before passing them to work_on_cpu(), which requires the
caller to ensure the target CPU cannot go offline.

If CPU hot-unplug runs concurrently under CONFIG_HOTPLUG_CPU=3Dy, could
work_on_cpu() be called on an offline CPU?

[ ... ]

> +static int contention_worker_fn(void *data)
> +{
> +	struct contention_data *cd =3D data;
> +	struct contention_shared *sh =3D cd->sh;
> +	int round;
> +
> +	wait_event(contention_wq, READ_ONCE(sh->started));
> +	for (round =3D 1; round <=3D CONTENTION_NR_ROUNDS; round++) {
> +		if (cd->coordinator) {
> +			atomic_set_release(&sh->round, round);
> +			contention_add(cd);
> +			while (atomic_read_acquire(&sh->nr_done) < round * (sh->nr_workers - =
1))
> +				cond_resched();
> +#ifdef CONFIG_SMP
> +			if (percpu_counter_tree_check_residuals(&counter[0]))
> +				sh->nr_errors++;
> +#endif
> +		} else {
> +			while (atomic_read_acquire(&sh->round) < round)
> +				cond_resched();
> +			contention_add(cd);
> +			/* Order the additions before the coordinator check. */
> +			atomic_inc_return_release(&sh->nr_done);
> +		}
> +	}
> +	complete_work();
> +	return 0;
> +}
> +
> +static void do_hpcc_test_contended_carries(struct kunit *test, unsigned =
long batch_size)
> +{

[ ... ]

> +	for_each_cpu(cpu, cpus) {
> +		cd[cpu].sh =3D &sh;
> +		cd[cpu].coordinator =3D first;
> +		cd[cpu].seed =3D get_random_u32() | 1;
> +		task[cpu] =3D kthread_create_on_cpu(contention_worker_fn, &cd[cpu], cp=
u,
> +						  "kunit_hpcc_contention/%u");
> +		KUNIT_EXPECT_FALSE(test, IS_ERR(task[cpu]));
> +		if (IS_ERR(task[cpu]))
> +			break;
> +		atomic_inc(&kernel_threads_to_run);
> +		get_task_struct(task[cpu]);
> +		wake_up_process(task[cpu]);
> +		sh.nr_workers++;
> +		first =3D false;
> +	}
> +	/* Start the workers once their number is known. */
> +	WRITE_ONCE(sh.started, true);
> +	wake_up_all(&contention_wq);

[Severity: Medium]
On weakly-ordered architectures, can the coordinator thread in
contention_worker_fn() observe sh->started =3D=3D true before seeing all
increments to sh.nr_workers?

In do_hpcc_test_contended_carries(), each worker kthread (starting with the
coordinator on the first iteration) is woken via wake_up_process(task[cpu])
inside the loop while sh.nr_workers++ is still being incremented on
subsequent iterations, and completion is published with
WRITE_ONCE(sh.started, true).

In contention_worker_fn(), if the already-running coordinator hits the
wait_event(contention_wq, READ_ONCE(sh->started)) fastpath before
wake_up_all() is called, it does not go through the waitqueue spinlock and
there is no release/acquire pairing ordering the updates to sh.nr_workers
before the coordinator reads sh->nr_workers in:

	while (atomic_read_acquire(&sh->nr_done) < round * (sh->nr_workers - 1))

Could this cause the coordinator to wait for fewer workers than were created
and call percpu_counter_tree_check_residuals(&counter[0]) while other worke=
rs
are still updating counter[0]? Should sh.started use smp_store_release() and
smp_load_acquire()?

[ ... ]

> +static void do_hpcc_test_saturated_compare(struct kunit *test, unsigned =
long batch_size,
> +					   long inc)
> +{

[ ... ]

> +	cpus_read_lock();
> +	for_each_online_cpu(cpu) {
> +		work_on_cpu(cpu, saturate_worker_fn, &sd);
> +		KUNIT_EXPECT_FALSE(test, sd.overrun);
> +		if (sd.overrun)
> +			break;
> +	}
> +	cpus_read_unlock();
> +
> +	precise =3D percpu_counter_tree_precise_sum(c);
> +	approx =3D percpu_counter_tree_approximate_sum(c);
> +	kunit_info(test, "batch_size=3D%lu inc=3D%ld precise=3D%ld approx=3D%ld=
 accuracy=3D%lu\n",
> +		   batch_size, inc, precise, approx, accuracy);
> +
> +	check_residuals(test, c);
> +	check_residuals(test, &probe);
> +
> +	/* Accuracy contract. */
> +	KUNIT_EXPECT_GE(test, approx, precise - (long)accuracy);
> +	KUNIT_EXPECT_LE(test, approx, precise + (long)accuracy);
> +	/* Saturating every possible CPU reaches the accuracy exactly. */
> +	if (num_online_cpus() =3D=3D nr_cpu_ids)
> +		KUNIT_EXPECT_EQ(test, (precise - approx) * inc, (long)accuracy);

[Severity: Low]
In do_hpcc_test_saturated_compare(), what happens if a CPU is offline during
the for_each_online_cpu() saturation loop and comes online after
cpus_read_unlock()?

Because num_online_cpus() =3D=3D nr_cpu_ids is checked after cpus_read_unlo=
ck()
is dropped, a CPU brought online in that window would make
num_online_cpus() =3D=3D nr_cpu_ids true even though saturate_worker_fn() d=
id not
run on it, causing the KUNIT_EXPECT_EQ(test, (precise - approx) * inc,
(long)accuracy) assertion to fail spuriously.

Should num_online_cpus() =3D=3D nr_cpu_ids be recorded while cpus_read_lock=
() is
still held?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102190708.1287=
100-1-mathieu.desnoyers@efficios.com?part=3D2

